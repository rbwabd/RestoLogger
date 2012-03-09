// Place your application-specific JavaScript functions and classes here
//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require_tree .
jQuery.noConflict();

//function to prevent submission of form on enter
jQuery(function() {
  jQuery("input").not( jQuery(":button") ).keypress(function (evt) {
    if (evt.keyCode == 13) {
      iname = jQuery(this).val();
      nestedFormEvents.addFields("add_nested_fields");
      
      // if Value of field is submit, submit the form. need to change this
      if (iname !== 'Submit'){  
        var fields = jQuery(this).parents('form:eq(0),body').find('button,input,textarea,select');
        var index = fields.index( this );
        if ( index > -1 && ( index + 1 ) < fields.length ) {
          fields.eq( index + 1 ).focus();
        }
        return false;
      }
    }
  });
});

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
  jQuery('#visit_dish_name').autocomplete({
    minLength: 3,
    source: function(request, response) {
      jQuery.ajax({
        url: "/autocomplete/dishes",
        dataType: "json",
        data: {
          term : request.term,
          store_id : jQuery('#visit_store_id').val()
        },
        success: function(data) {
          response(data);
        }
      });
    },
    focus: function(event, ui) {
      jQuery('#visit_dish_name').val(ui.item.name);
      return false;
    },
    select: function(event, ui) {
      jQuery('#visit_dish_id').val(ui.item.id);
      return false;
    }
  });
});