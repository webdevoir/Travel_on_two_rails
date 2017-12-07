$( document ).ready(function() {
  $("#menu-toggle").click(function(e) {
      e.preventDefault();
      $("#wrapper").toggleClass("toggled");
  });

  $(".post-sidebar-item").on("click",function(e){
    e.preventDefault()
    var val_old = $("#current_post_date").val()
    $("."+val_old).removeClass("sidebar-active-item")
    var href = $(this).attr('href');
    $.get(href, {}, null, "script").done(function(){
      var val = $("#current_post_date").val()
      $("."+val).addClass("sidebar-active-item")
      if ($(window).width() < 765 ) {
        $("#wrapper").toggleClass("toggled");
      }
    });
  })
})
