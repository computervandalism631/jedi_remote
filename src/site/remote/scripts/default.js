
$( document ).ready(function() {

$("#button-up").click(function(e) {
    e.preventDefault();
    $.ajax({
        type: "GET",
        url: "/action/volume?RemoteCommand-volume-up",
        success: function(result) {},
        error: function(result) {}
    });
});

$("#button-down").click(function(e) {
    e.preventDefault();
    $.ajax({type: "GET", url: "/action/volume?RemoteCommand-volume-down"});
});

$("#button-next").click(function(e) {
    e.preventDefault();
    $.ajax({type: "GET", url: "/action/track?RemoteCommand-track-next"});
});
$("#button-pre").click(function(e) {
    e.preventDefault();
    $.ajax({type: "GET", url: "/action/track?RemoteCommand-track-pre"});
});
$("#button-pp").click(function(e) {
    e.preventDefault();
    $.ajax({type: "GET", url: "/action/track?RemoteCommand-track-playpause"});
});


});
