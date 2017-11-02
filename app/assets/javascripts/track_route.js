$( document ).ready(function() {

  function initMap() {
    // setting as global scope which might be bad
    var uluru = {lat: -25.363, lng: 131.044};
    map = new google.maps.Map(document.getElementById('map-track-route'), {
      zoom: 7,
      center: uluru
    });

    $("#track-route").on("click", function(){
      var array = []
      var trackRoute = setInterval(function() {
        getLocation(function(pos){
          array.push(pos)
        })
      }, 1 * 1000); // 60 * 1000 milsec
      $("#stop-track-route").on("click", function(){
        clearInterval(trackRoute);
        drawPolyLine(array)
        console.log(array);
      })
    })

  }

  function drawPolyLine(array) {
    var path = new google.maps.Polyline({
      path: array,
      geodesic: true,
      strokeColor: '#FF0000',
      strokeOpacity: 1.0,
      strokeWeight: 2
    });

    path.setMap(map)
    var array_mid_value = array[parseInt(array.length/2)]
    newLocation(array_mid_value.lat, array_mid_value.lng)
  }

  function newLocation(newLat,newLng) {
    map.setCenter({
      lat : newLat,
      lng : newLng
    });
    map.setZoom(11)
  }

  function getLocation(callback) {
    if (navigator.geolocation) {
      navigator.geolocation.getCurrentPosition(function(position) {
        var pos = {
          lat: position.coords.latitude,
          lng: position.coords.longitude
        };
        callback(pos);
      }, function() {
        handleLocationError(true, infoWindow, map.getCenter());
      });
    } else {
      // Browser doesn't support Geolocation
      handleLocationError(false, infoWindow, map.getCenter());
    }
  }

  function handleLocationError(browserHasGeolocation, infoWindow, pos) {
    alert("Some stuff went wrong")
  }

  initMap()
})
