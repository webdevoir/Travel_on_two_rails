$( document ).ready(function() {
  $("#menu-toggle").click(function(e) {
      e.preventDefault();
      $("#wrapper").toggleClass("toggled");
  });

  $(".post-sidebar-item").on("click",function(e){
    e.preventDefault()
    var href = $(this).attr('href');
    $.get(href, {}, null, "script");
  })
})
