$( document ).ready(function() {

  $("#add-route-button").on("click", function(e){
    e.preventDefault()
    var route_id = $("#route_id").val()
    var trip_id = $("#trips").find(":selected").val()
    var url = "/trips/" + trip_id + "/posts/new?route_id=" + route_id
    window.location.href = url
  })

})
