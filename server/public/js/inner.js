$(function() {
    var socket = io.connect('/answer');
    socket.emit('debug', 'connected (answer)');
    var name = "Ryohei";

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
        var question = data[data.length - 1];
    })

    var started = false;
    var questionList = [];


    socket.on('question', function(data, fn) {
        questionList.push(data);
        console.log(questionList);

        if (started) return;
        started = true;

        var question = data[data.length - 1];

        $(".countDownView").show();
        $("#quesitonImage").attr('src', question.url);
        $("#questionText").text(question.text)

        var set3 = setTimeout(function() {
            $("#countDownView3").hide();
            var set3 = setTimeout(function() {
                $("#countDownView2").hide();
                var set3 = setTimeout(function() {
                    $("#countDownView1").hide();
                    startAnswer();
                }, 1000)
            }, 1000)
        }, 1000);

        function startAnswer() {
            var endDate = +new Date() + 15 * 1000;
            var timer = setInterval(function() {
                var sec = Math.floor((endDate - (+new Date())) / 1000);
                $("#restTimer").text(sec);
                $("#userCounter").text(20);
            });
            setTimeout(function() {
                $("#result").fadeOut();
            }, 10000);
        }
        $("#sendButton").click(function() {
            var answer = $("#answerArea").attr("readonly", "readonly").val(); {
                qid: question.qid
                answer:

            }

        })

        socket.on('answer', function(data, fn) {


        });
    });


});