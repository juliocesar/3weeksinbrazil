$(document).ready(function() {
  $.each(['pics', 'index', 'intro'], function(index, elt) {
    $('#' + elt + ' img').hover(
      function() { $(this).attr('src', '/' + elt + '_underline.png') },
      function() { $(this).attr('src', '/' + elt + '.png') }
    )
  })
})