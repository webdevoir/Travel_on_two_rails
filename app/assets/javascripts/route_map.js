$(function(){

  $(".trip-planner-sidebar-item").on("click", function(){
    var lat = $(this).data("lat")
    var lng = $(this).data("lng")
    newLocation(lat, lng)
  })

  function initMap() {
    // var directionsService = new google.maps.DirectionsService;
    // var directionsDisplay = new google.maps.DirectionsRenderer;
    // setting as global scope which might be bad
    var uluru = {lat: -25.363, lng: 131.044};
    map = new google.maps.Map(document.getElementById('map-trip-planner'), {
      zoom: 7
    });
    // directionsDisplay.setMap(map);
    // directionsDisplay.setPanel(document.getElementById('right-panel'));

    calculateAndDisplayRoute(map);
  }

  function calculateAndDisplayRoute(map) {
    var poly_line = $("#route_polyline").val()
    createDirections(poly_line, map)
  }

  function createDirections(poly_line, map) {
    var lat_lng_path = google.maps.geometry.encoding.decodePath(poly_line)
    createPolyline(lat_lng_path)
    var address1_point = lat_lng_path[0]
    var address2_point = lat_lng_path[lat_lng_path.length -1]
    createMarker(map, address1_point, "label", "html", null)
    createMarker(map, address2_point, "label", "html", null)
    var center_point = lat_lng_path[Math.round(lat_lng_path.length/2)]
    setPOI()
    setCenter(center_point)
  }

  function renderDirections(result, map) {
    var directionsRenderer = new google.maps.DirectionsRenderer();
    directionsRenderer.setMap(map);
    directionsRenderer.setDirections(result);
  }

  function setPOI() {
    var id = $("#route_id").val()
    $.ajax({
      url: "/routes/"+id+"/fetch_pois",
    }).done(function(result){
      var pois = result.pois
      for (var i = 0; i < pois.length; i++) {
        createMarker(map, {lat: parseFloat(pois[i].latitude), lng: parseFloat(pois[i].longitude)}, "label", "html", pois[i])
      }
    })
  }

  function createPolyline(lat_lng_path) {
    var path = new google.maps.Polyline({
      path: lat_lng_path,
      geodesic: true,
      strokeColor: '#FF0000',
      strokeOpacity: 1.0,
      strokeWeight: 2
    });

    path.setMap(map)
  }

  function createMarker(map, latlng, label, html, poi) {
    var marker = new google.maps.Marker({
        position: latlng,
        map: map,
        title: label,
        zIndex: Math.round(latlng.lat*-100000)<<5
        });
        marker.myname = label;

    if (poi != null) {
      var contentString = "<h3 class='info-title'>" +
                            poi.category +
                          "</h3>" +
                          "<p class='info-text'>" +
                            poi.info +
                          "</p>"
      var infowindow = new google.maps.InfoWindow({
        content: contentString
      })
      google.maps.event.addListener(marker, 'click', function() {
        infowindow.open(map, marker);
      });
    }
    return marker;
  }

  function setCenter(latlng) {
    map.setCenter({
      lat : latlng.lat(),
      lng : latlng.lng()
    });
  }

  initMap()
})
