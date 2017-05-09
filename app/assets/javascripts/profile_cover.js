$( document ).ready(function() {

  $(".profile-picture").hover(function(){
    $(".profile-picture-edit").fadeIn(100)
  }, function(){
    $(".profile-picture-edit").fadeOut(100)
  })

  $(".cover-photo").hover(function(){
    $(".cover-photo-edit").fadeIn(100)
  }, function(){
    $(".cover-photo-edit").fadeOut(100)
  })

  $("#user-information").hover(function(){
    $(".user-edit").fadeIn(100)
  }, function(){
    $(".user-edit").fadeOut(100)
  })

});
