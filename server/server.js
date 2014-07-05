var express = require('express');
var app = express();
var server = require('http').Server(app);
var fs = require('fs');
var AWS = require('aws-sdk');
var busboy = require('connect-busboy');

app.set('views', __dirname + '/views');
app.set('view engine', 'twig');
app.set('twig options', {
    strict_variables: false
});

app.use(busboy());

app.use(express.static(__dirname + '/public'));
app.use('/uploads', express.static(__dirname + '/uploads'));

server.listen(5000, function() {
    console.log('Now listening on port 5000');
});

var io = require('socket.io').listen(server);

app.get('/', function(req, res) {
    res.render('index.twig', {
        message: "Hello World"
    });
})


app.get('/ask', function(req, res) {
    res.render('ask.twig', {
        message: "Hello World"
    });
});


app.get('/inner', function(req, res) {
    res.render('inner.twig');
});

app.get('/answer', function(req, res) {
    res.render('answer.twig', {
        message: "Hello World"
    });
});

app.post('/upload', function(req, res) {
    var fstream;
    req.pipe(req.busboy);
    req.busboy.on('file', function(fieldname, file, filename) {
        console.log("Uploading: " + filename);
        filename = +new Date() + ".jpg";
        fstream = fs.createWriteStream(__dirname + '/uploads/' + filename);
        file.pipe(fstream);
        fstream.on('close', function() {
            res.send("http://49.212.129.143:5000/uploads/" + filename)
        });
    });
});


io.on('connection', function(socket) {
    console.log('connected');
    socket.emit('debug', 'connected!');
})

var qid = 1;
var questionList = [{
    qid: 100,
    name: "default",
    text: "What's this?",
    url: "/assets/manekineko.jpg"
}, {
    qid: 101,
    name: "default",
    text: "How to use it?",
    url: "/assets/washletbig.jpg"
}];

var answerList = {
    100: [],
    101: []
};

var askers = io.of('/ask').on('connection', function(socket) {
    var user = {
        'name': 'Shintaro',
        'id': socket.id
    }

    socket.emit('userInfo', user);
    socket.on('userInfo', function(data, fn) {
        user.name = data.name;
    })

    console.log('connected to ask');

    socket.on('ask', function(data, fn) {
        data.qid = qid;

        answerList[data.qid] = [];
        questionList.push(data);
        io.of('/answer').emit('question', [data]);

        console.log('ask', data, qid)

        // qid のルームに接続
        socket.join('q' + qid);
        console.log('joining', 'q' + qid);

        // ここからダミー
        var sendDummyAnswer = function() {
            console.log('sent dummy answer to qid:', 'q' + data.qid);
            var answer = {
                'qid': 'q' + data.qid,
                'name': 'Ryohei',
                'text': 'Benjo!',
                'aid': answerList[data.qid].length
            };
            answerList[data.qid][answer.aid] = answer;
            askers.to('q' + data.qid).emit('answer', answer);
            answerers.to('q' + data.qid).emit('answer', answer);
        };

        socket.on("eval", function(data_eval) {
            console.log("eval received", data_eval);
            var eval_result = Array.prototype.map.call(data_eval.eval, function(aid) {
                return answerList[data.qid][aid]
            });

            answerers.to('q' + data.qid).emit('eval', eval_result);
        })

        var interval = setInterval(sendDummyAnswer, 5000);
        sendDummyAnswer();

        socket.on('disconnect', function() {
            console.log('disconnected');
            clearInterval(interval);
        });

        qid++;
    });

})

var answerers = io.of('/answer').on('connection', function(socket) {
    console.log('connected to answer');
    socket.emit('question', questionList);

    var interval = setInterval(function() {
        socket.emit('active', {
            active: io.sockets.clients().length
        });
    }, 5000);
    socket.on('disconnect', function() {
        clearInterval(interval);
    })

    socket.on('answer', function(data, fn) {
        if (listeningTo) socket.leave('q' + listeningTo);
        socket.join('q' + data.qid);
        listeningTo = qid;

        data.aid = answerList[data.qid].length;

        console.log('answer', data);
        askers.to('q' + data.qid).emit('answer', data);
        answerers.to('q' + data.qid).emit('answer', data);
        answerList[data.qid][data.aid] = data;
    });

    var listeningTo = null;

    socket.on('listenTo', function(qid, fn) {
        if (listeningTo) socket.leave('q' + listeningTo);
        socket.join('q' + qid);
        console.log("joining room q", qid)
        listeningTo = qid;
    })
})