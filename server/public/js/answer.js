$(function() {
    var socket = io.connect('/answer');
    socket.emit('debug', 'connected (answer)');

    $("#form-answer").submit(function() {
        console.log("answer");
        socket.emit('answer', {
            'name': $("#inputName").val(),
            'text': $("#inputText").val(),
            'qid': $("#inputQId").val()
        }, function(data) {
            $("#inputName").val("");
            $("#inputText").val("");
            $("#inputQId").val("");
        });
        return false;
    });

    socket.on('answer', function(data) {
        console.log("answer received");
        $("#answer").append("<li>" + data.name + ": " + data.text + "</li>");
    })

    socket.on('question', function(data, fn) {
        console.log('question list received', data);
        for (var i = 0; i < data.length; i++) {
            var q = data[i];
            var qid = q.qid;
            $("<li>" + q.name + ": " + q.text + "</li>").appendTo("#questions").click(function(qid) {
                return function() {
                    console.log("listening to answer qid: ", qid);
                    $("#inputQId").val(qid);
                    socket.emit('listenTo', qid);
                }
            }(qid));
        }
    });
})