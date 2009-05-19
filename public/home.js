$(document).ready(function() {
  $.each(['pics', 'index', 'intro'], function(i, elt) {
    $('<img />').attr('src', '/' + elt + '_underline.png');
    $('#' + elt + ' img').hover(
      function() { $(this).attr('src', '/' + elt + '_underline.png') },
      function() { $(this).attr('src', '/' + elt + '.png') }
    )
  })
})
