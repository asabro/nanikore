$(function() {
    var socket = location.host == "nani-colle.com" ? io.connect('49.212.129.143:5000/ask') : io.connect('/ask');
    socket.emit('debug', 'connected');

    $("#form-ask").submit(function() {
        console.log("ask");
        socket.emit('ask', {
            'name': $("#inputName").val(),
            'text': $("#inputText").val(),
            'url': $("#inputURL").val()
        }, function(data) {
            $("#inputName").val("");
            $("#inputText").val("");
            $("#inputURL").val("");
        });
        return false;
    });


    $("#form-eval").submit(function() {
        console.log("eval2");
        socket.emit('eval', {
            "eval": [$("#input1st").val(), $("#input2nd").val()]
        }, function(data) {
            $("#input1st").val("");
            $("#input2nd").val("");
        });
        return false;
    });


    socket.on('debug', function(data) {
        $("#console").append("<li>" + data + "</li>");
    });

    socket.on('answer', function(data) {
        console.log("answer received");
        $("#answer").append("<li>" + data.name + ": " + data.text + "(aid: " + data.aid + ")</li>");
    });

    $("#button").click(function() {
        socket.emit('ask', {
            'name': 'Mario',
            'text': 'How to use it?',
            'url': 'http://49.212.129.143:5000/assets/washletbig.jpg'
        });

        socket.emit('ask', {
            'name': 'Mario',
            'text': 'What is it?',
            'url': 'http://49.212.129.143:5000/assets/manekineko.jpg'
        });

        socket.emit('ask', {
            'name': 'Mario',
            'text': 'What are they doing?',
            'url': 'http://49.212.129.143:5000/assets/tachiyomi.jpg'
        });

    })


})