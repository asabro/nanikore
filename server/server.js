var express = require('express');
var app = express();
var server = require('http').Server(app);
var fs = require('fs');
var AWS = require('aws-sdk');

app.set('views', __dirname + '/views');
app.set('view engine', 'twig');
app.set('twig options', {
    strict_variables: false
});

app.use(express.static(__dirname + '/public'));
server.listen(5000);
var io = require('socket.io').listen(server);

app.get('/', function(req, res) {
    res.render('index.twig', {
        message: "Hello World"
    });
})