$( document ).ready(function() {

  var count = 0

  $("#post-file-container").on("change", ".first-file:last", function(){
    count += 1
    var count_string = count.toString();
    $("#post-file-container").append(
      "<div class='first-file'>" +
        "<label for='post_post_pictures_attributes_" + count_string + "_picture'>Upload an Image here</label>" +
        "<input class='' type='file' name='post_pictures[image][]' id='post_post_pictures_attributes_" + count_string + "_picture'>" +
      "</div>"
    )
  });

  $(".center").slick({
    slidesToShow: 3,
    arrows: true,
  });


})
