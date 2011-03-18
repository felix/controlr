jQuery(document).ready(function() {
  jQuery('time.relative').timeago();
  jQuery('.flash').delay(6000).fadeOut('slow');
  jQuery('select.selectdomain').change(function(){
    document.location = $(this).val();
  });
});
