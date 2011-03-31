jQuery(document).ready(function() {
  jQuery('time.relative').timeago();
  jQuery('.flash').delay(6000).fadeOut('slow');
  jQuery('form.switcher select').change(function(){
    $(this).closest('form').submit();
  });
  jQuery('form .hint').each(function(){
    var hint = $(this);
    hint.parent().find('input,textarea,select').each(function(){
      $(this).focus(function(){ hint.show(); });
      $(this).blur(function(){ hint.hide(); });
    });
  });

});
