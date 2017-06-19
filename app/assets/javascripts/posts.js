$( document ).ready(function() {

  var count = 0

  $("#post-file-container").on("change", function(){
    count += 1
    var count_string = count.toString();
    $("#post-file-container").append(
      "<div class='field-title'>" +
        "<label for='post_post_pictures_attributes_" + count_string + "_picture'>Upload an Image here</label>" +
        "<input class='form-control' type='file' name='post_pictures[image][]' id='post_post_pictures_attributes_" + count_string + "_picture'>" +
      "</div>"
    )
  });

  $(".center").slick({
      dots: true,
      infinite: true,
      centerMode: true,
      slidesToShow: 1,
      slidesToScroll: 1,
    });

})
