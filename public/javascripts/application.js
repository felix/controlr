jQuery(document).ready(function() {
  jQuery('time.relative').timeago();
  jQuery('.flash .notice').delay(6000).fadeOut('slow');

  // auto submit forms
  jQuery('form.auto-submit select').change(function(){
    $(this).closest('form').submit();
  });

  // tooltips
  jQuery('form .hint').each(function(){
    var hint = $(this);
    hint.parent().find('input,textarea,select').each(function(){
      $(this).focus(function(){ hint.show(); });
      $(this).blur(function(){ hint.hide(); });
    });
  });

  // toggle user domains
  jQuery('#user_role').change(function(){
    $('#role-domains').toggle($(this).val() != 'administrator');
  }).trigger('change');

  // toggle name record types
  jQuery('#name_record_type').change(function(){
    $('#mx-distance').toggle($(this).val() == 'MX');
  }).trigger('change');


});
