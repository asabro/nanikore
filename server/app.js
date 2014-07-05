var express = require('express');
var app = express();

var server = require('http').Server(app);
var fs = require('fs');

var spawn = require('child_process').spawn;
var buffer = require('buffer');
var AWS = require('aws-sdk');

app.configure(function() {
    app.set('views', __dirname + '/views');
    app.set('view engine', 'twig');
    app.set('twig options', {
        strict_variables: false
    });
});

app.use(express.static(__dirname + '/public'));
server.listen(3000);
var io = require('socket.io').listen(server);

app.get('/youtube', function(req, res) {
    res.render('youtube', {
        message: "Hello World"
    });
})

/**
http://docs.aws.amazon.com/AWSJavaScriptSDK/guide/node-making-requests.html
// Set your region for future requests.
AWS.config.region = 'us-west-2';

// Create a bucket using bound parameters and put something in it.
// Make sure to change the bucket name from "myBucket" to something unique.
var s3bucket = new AWS.S3({params: {Bucket: 'myBucket'}});
s3bucket.createBucket(function() {
  var data = {Key: 'myKey', Body: 'Hello!'};
  s3bucket.putObject(data, function(err, data) {
    if (err) {
      console.log("Error uploading data: ", err);
    } else {
      console.log("Successfully uploaded data to myBucket/myKey");
    }
  });
});
*/

var visitor_sockets = []

var active_sockets = [];


var devices = io.of('').on('connection', function(socket) {
    var oginolib = spawn('./sanalyzer');
    // spawn document : http://nodejs.org/api/child_process.html
    // #child_process_child_process_spawn_command_args_options

    active_sockets.push(socket);
    socket.user_display_id = "Anonymous" + (Math.floor(Math.random() * 90) + 10)
    socket.emit('debug', {
        "msg": "connected (user_display_id: " + socket.user_display_id + ")"
    });

    var respawn_count = 0;
    var raw_data_store = [];
    var latest_data_id = 0;


    socket.on('data', function(data) {
        console.log('data received');
        socket.emit('debug', {
            "msg": "data received"
        });
        if (!data.user_id || !data.data) {
            console.log("invalid data");
            return false;
        } else {
            if (data.data_id == 0) {
                // starting new session?
                latest_data_id = 0;
            } else if (latest_data_id >= data.data_id) {
                // old data
                console.log("received obsolete data. throwing away")
                return false;
            }
            //            console.log("data written");
            //            console.log("data written", data.data);
            oginolib.stdin.write(data.data + "\t");
            return true;
        }
    });

    socket.on('set_user_data', function(data) {
        console.log('user_data', data);
        socket.user_display_id = data.user_display_id;
        socket.join(data.user_display_id);
    });

    socket.on('disconnect', function(data) {
        active_sockets.splice(active_sockets.indexOf(socket), 1);
        oginolib.kill('SIGHUP');
    });

    // oginolib からデータが帰ってきたら…
    oginolib.stdout.on('data', function(data) {
        console.log('oginolib stdout: ' + data);
        // @todo こういう形式でやってくると想定
        //        data = "15,47,68,36,29";
        console.log(data.toString())

        data = data.toString().split(",").map(Math.floor);
        if (data.length < 4) {
            //            sendError(100, "Oginolib return value is not valid");
            return;
        }

        socket.emit("result", {
            "result": data
        })

        // sharing data with viewer 
        if (socket.user_display_id) {
            console.log("emitting to:", socket.user_display_id);
            viewers.to(socket.user_display_id).emit("result", {
                "result": data
            });
        }

        // @todo store
    });

    oginolib.stderr.on('data', function(data) {
        // stderr は使わない
        console.log('oginolib stderr: ' + data);
        sendError(100, 'oginolib stderr: ' + data);
    });

    // Oginolib プロセスが終了したら…
    oginolib.on('close', function(code) {
        console.log('oginolib process exited with code ' + code);
        sendError(100, 'oginolib process exited with code ' + code)
        if (respawn_count++ < 10) {
            console.log('respawning ignored')
            // oginolib = spawn('./sanalyzer');
        }
    });

    function sendError(code, msg) {
        console.log("send error: ", msg);
        socket.emit('debug', {
            "msg": "error: " + msg
        });
    }
});


// access from viewer
// Youtube とか View からのアクセスをさばく namespace 
var viewers = io.of('/view').on('connection', function(socket) {
    console.log("viewer entered");

    var user_display_id = null;

    // アクティブなデバイスのリストを送信する関数
    var sendDevicesList = function() {
        socket.emit("device_list", active_sockets.map(function(socket) {
            return {
                "user_display_id": socket.user_display_id,
                "socket_io_id": socket.id
            };
        }))
    };

    // これを即座に実行し，さらに2秒ごとに実行する
    sendDevicesList();
    var intervalTimer = setInterval(sendDevicesList, 2000);

    // disconnect されたら clear
    socket.on('disconnect', function(arguments) {
        clearInterval(intervalTimer);
    })

    // user_display_id を指定して listen してきたら その room に join させる.
    socket.on('listen', function(data) {
        if (user_display_id) {
            socket.leave(user_display_id);
        }
        if (data.user_display_id) {
            console.log('A client is listening to', data.user_display_id);
            socket.join(data.user_display_id);
            user_display_id = data.user_display_id;
        }
    });
})