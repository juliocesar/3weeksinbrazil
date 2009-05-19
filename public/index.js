$(document).ready(function() {
  $.each(['next', 'previous'], function(i, elt) {
    $('<img />').attr('src', '/' + '_underline.png');
    $('#' + elt + ' img').hover(
      function() { $(this).attr('src', '/' + elt + '_underline.png') },
      function() { $(this).attr('src', '/' + elt + '.png') }
    )
  })
})
