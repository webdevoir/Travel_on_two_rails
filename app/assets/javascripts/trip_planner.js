$(function(){

  function initMap() {
    var directionsService = new google.maps.DirectionsService;
    var directionsDisplay = new google.maps.DirectionsRenderer;
    var map = new google.maps.Map(document.getElementById('map-trip-planner'), {
      zoom: 7,
    });
    directionsDisplay.setMap(map);
    directionsDisplay.setPanel(document.getElementById('right-panel'));

    calculateAndDisplayRoute(directionsService, directionsDisplay);
  }

  function calculateAndDisplayRoute(directionsService, directionsDisplay) {
    $.ajax({
      url: "/trips/3/fetch_posts",
    }).done(function(result){
      var posts = result.posts
      var trip = result.trip
      var start = trip.start
      var end = trip.end
      var waypts = []
      for (var i = 0; i < posts.length; i++) {
        if (!(posts[i].address1 === start || posts[i].address1 === end)) {
          waypts.push({
            location: posts[i].address1,
            stopover: true
          });
        }
        if (!(posts[i].address2 === end || posts[i].address2 === end)) {
          waypts.push({
            location: posts[i].address2,
            stopover: true
          });
        }

      }
      directionsService.route({
        origin: start,
        destination: end,
        waypoints: waypts,
        optimizeWaypoints: true,
        travelMode: 'DRIVING',
        unitSystem: google.maps.UnitSystem.METRIC
      }, function(response, status) {
        if (status === 'OK') {
          directionsDisplay.setDirections(response);
        } else {
          window.alert('Directions request failed due to ' + status);
        }
      });
    })
  }

  initMap()
})
