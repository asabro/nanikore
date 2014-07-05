var timelimit = 15;

$(function() {
    var socket = location.host == "nani-colle.com" ? io.connect('49.212.129.143:5000/answer') : io.connect('/answer');
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
        console.log(data, questionList);
        questionList = questionList.concat(data);
        console.log(data, questionList);
        $("#waitView").hide();
        $("#answersView").html('');

        if (started) return;
        started = true;
        nextQuestion();
    });

    var question;
    var nextQuestion = function() {
        sent = false;
        $("#answerArea").attr("disabled", false);
        $("#answersView").html('');
        question = questionList[0];
        questionList.splice(0, 1);

        console.log(question, questionList)

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
            var endDate = +new Date() + timelimit * 1000;
            var timer = setInterval(function() {
                var sec = Math.floor((endDate - (+new Date())) / 1000);
                $("#restTimer").text(sec);
                $("#userCounter").text(20);
            });

            setTimeout(function() {
                clearInterval(timer);
                setTimeout(function(arguments) {
                    if (questionList.length) {
                        nextQuestion();
                    } else {
                        $("#waitView").show();
                        started = false;
                    }

                }, 5000);
            }, timelimit * 1000);
        }
    }

    var sent = false;
    $("#sendButton").click(function() {
        if (sent) return;
        sent = true;
        $("#answerArea").attr("disabled", "disabled");
        var answer = {
            qid: question.qid,
            text: $("#answerArea").val(),
            name: name,
        };
        socket.emit('answer', answer);
        $("#answerArea").val('');
    })


    socket.on('answer', function(data, fn) {
        $('<div class="answer"><div class="answerText">' + data.text + '</div><div class="answerName">' + data.name + '</div></div>').appendTo("#answersView");
    });

});