// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults
//= require jquery
//= require jquery_ujs
//= require jquery-ui
jQuery(function() {
  jQuery("#tabs").tabs();
});
$(function() {
  $('#visit_city_name').autocomplete({
    minLength: 3,
    source: '/autocomplete/cities',
    focus: function(event, ui) {
      $('#visit_city_name').val(ui.item.name);
      return false;
    },
    select: function(event, ui) {
      $('#visit_city_id').val(ui.item.id);
      return false;
    }
  });
  $('#visit_store_name').autocomplete({
    minLength: 3,
    source: function(request, response) {
      $.ajax({
        url: "/autocomplete/stores",
          dataType: "json",
        data: {
          term : request.term,
          city_id : $('#visit_city_id').val()
        },
        success: function(data) {
          response(data);
        }
      });
    },
    focus: function(event, ui) {
      $('#visit_store_name').val(ui.item.name);
      return false;
    },
    select: function(event, ui) {
      $('#visit_store_id').val(ui.item.id);
      return false;
    }
  });
});