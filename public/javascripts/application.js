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

  // specific toggles

  // user domains
  jQuery('#user_role').change(function(){
    $('#role-domains').toggle($(this).val() != 'administrator');
  }).trigger('change');

  jQuery('#name_record_type').change(function(){
    $('#mx-distance').toggle($(this).val() == 'MX');
  }).trigger('change');


});
