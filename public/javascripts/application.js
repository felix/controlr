jQuery.showFlash = function(type, flash) {
  var msg = $("<li />").addClass(type);
  msg.html(flash);

  jQuery('#flash ul').append(msg);

  msg.show('drop', {
    direction:'up'
  }, 300)
  .delay(6000)
  .hide('drop', {
    direction: 'up'
  }, 300, function(){
    $(this).remove();
  });
  return msg;
};

// process AJAX flash
jQuery(document).ajaxComplete(function(e, request, opts) {
  if (flash_alert = request.getResponseHeader('X-Message-Alert')) {
    jQuery.showFlash('alert',flash_alert);
  }
  if (flash_notice = request.getResponseHeader('X-Message-Notice')) {
    jQuery.showFlash('notice',flash_notice);
  }
});

jQuery(document).ready(function() {
  jQuery('time.relative').timeago();

  // auto submit forms
  jQuery('form.auto-submit select').change(function(){
    jQuery(this).closest('form').submit();
  });

  // tooltips
  jQuery('form .hint').each(function(){
    var hint = jQuery(this);
    hint.parent().find('input,textarea,select').each(function(){
      jQuery(this).focus(function(){ hint.show(); });
      jQuery(this).blur(function(){ hint.hide(); });
    });
  });

});
