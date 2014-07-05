$(function() {
    var socket = io.connect('/ask');
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

    socket.on('debug', function(data) {
        $("#console").append("<li>" + data + "</li>");
    })

    socket.on('answer', function(data) {
        console.log("answer received");
        $("#answer").append("<li>" + data.name + ": " + data.text + "</li>");
    })

})