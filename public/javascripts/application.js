jQuery(document).ready(function() {
  jQuery('time.relative').timeago();
  jQuery('.flash').delay(6000).fadeOut('slow');
  jQuery('form.switcher select').change(function(){
    $(this).closest('form').submit();
  });
});
