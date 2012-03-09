// Place your application-specific JavaScript functions and classes here
//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require_tree .
jQuery.noConflict();

jQuery(function() {
  jQuery("#tabs").tabs();
});

jQuery(function() {
  jQuery('#visit_city_name').autocomplete({
    minLength: 3,
    source: '/autocomplete/cities',
    focus: function(event, ui) {
      jQuery('#visit_city_name').val(ui.item.name);
      return false;
    },
    select: function(event, ui) {
      jQuery('#visit_city_id').val(ui.item.id);
      return false;
    }
  });
  jQuery('#visit_store_name').autocomplete({
    minLength: 3,
    source: function(request, response) {
      jQuery.ajax({
        url: "/autocomplete/stores",
        dataType: "json",
        data: {
          term : request.term,
          city_id : jQuery('#visit_city_id').val()
        },
        success: function(data) {
          response(data);
        }
      });
    },
    focus: function(event, ui) {
      jQuery('#visit_store_name').val(ui.item.name);
      return false;
    },
    select: function(event, ui) {
      jQuery('#visit_store_id').val(ui.item.id);
      return false;
    }
  });
});