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
            res.send("http://" + req.headers.host + "/uploads/" + filename)
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
    url: "https://dl.dropboxusercontent.com/u/6324118/toilet.png"
}, {
    qid: 101,
    name: "default",
    text: "What do you recommend?",
    url: "https://dl.dropboxusercontent.com/u/6324118/toilet.png"
}];

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
        questionList.push(data);
        io.of('/answer').emit('question', [data]);

        console.log('ask', data, qid)

        // qid のルームに接続
        socket.join('q' + qid);
        console.log('joining', 'q' + qid);
        fn(true);

        // ここからダミー
        var aid = 1;
        var sendDummyAnswer = function() {
            console.log('sent dummy answer to qid:', 'q' + data.qid);
            var answer = {
                'qid': 'q' + data.qid,
                'name': 'Ryohei',
                'text': 'Rubber Duck!',
                'aid': aid++
            };
            askers.to('q' + data.qid).emit('answer', answer);
            answerers.to('q' + data.qid).emit('answer', answer);
        };

        var interval = setInterval(sendDummyAnswer, 5000);
        sendDummyAnswer();

        socket.on('eval', function(data, fn) {


        })

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

    socket.on('answer', function(data, fn) {
        console.log('answer', data);
        socket.join('q' + data.qid);
        if (!data.qid) {
            return fn(false);
        }
        askers.to('q' + data.qid).emit('answer', data);
        answerers.to('q' + data.qid).emit('answer', data);
    })

    var listeningTo = null;

    socket.on('listenTo', function(qid, fn) {
        console.log("listenTo", qid);
        socket.emit('answers', answerList[qid]);
        // if (listeningTo) socket.leave('q' + listeningTo);
        socket.join('q' + qid);
        console.log("joining room q", qid)
        // listeningTo = qid;
    })

})