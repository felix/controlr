jQuery.fn.delayFade = function() {
  return jQuery(this).delay(6000).slideUp();
}

// process AJAX flash
jQuery(document).ajaxComplete(function(e, request, opts) { 
  var flash = '';
  if (flash_alert = request.getResponseHeader('X-Message-Alert')) {
    flash += '<li class="alert">'+flash_alert+'</li>';
  }
  if (flash_notice = request.getResponseHeader('X-Message-Notice')) {
    flash += '<li class="notice">'+flash_notice+'</li>';
  }
  jQuery('#flash ul').append(jQuery(flash).delayFade());
});

jQuery(document).ready(function() {
  jQuery('time.relative').timeago();

  // HTML placed flash
  jQuery('#flash li').delayFade();

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

  // toggle user domains
  jQuery('#user_role').change(function(){
    jQuery('#role-domains').toggle(jQuery(this).val() != 'administrator');
  }).trigger('change');

  // toggle name record types
  jQuery('#name_record_type').change(function(){
    jQuery('#mx-distance').toggle(jQuery(this).val() == 'MX');
  }).trigger('change');


});
