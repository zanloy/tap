// Javascript to enable link to tab
$(document).ready(function() {
  var url = document.location.toString();
  if (url.match('#')) {
    $('.nav-pills a[href=#'+url.split('#')[1]+']').tab('show');
    window.scrollTo(0, 0);
  }

  // Change hash for page-reload
  $('.nav-pills a[data-toggle="tab"]').on('shown.bs.tab', function (e) {
    window.location.hash = e.target.hash;
    window.scrollTo(0, 0);
  })
});
