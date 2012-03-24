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

// default tab option e.g. to show menu
jQuery(function() {
  jQuery("#tabs").tabs()
});

// tab for sorting menu tab and item orders
jQuery(function() {
  var num_lists = jQuery('[id^=taborder]').length;
  for(cnt=0;cnt<num_lists;cnt++){
    jQuery( "#sortable"+cnt ).sortable({
      update: function(event,ui) {
        jQuery(this).find(".ui-state-default").each(function(i){
          var val = jQuery(this).attr("id");
          var part = val.split("_");
          document.getElementById("dd_"+part[1]).value = i;
        });
      }
    }).disableSelection();
  }
    
  var jQuerytabs = jQuery( "#tabssortable" ).tabs().find( ".ui-tabs-nav" ).sortable({ 
                            axis: "x",
                            update: function(event, ui){
                              //alert(jQuery(this).text());
                              jQuery(this).find("a").each(function(i){
                                var val = jQuery(this).attr("href");
                                var part = val.split("_");
                                document.getElementById("taborder_"+part[1]).value = i;
                              });
                            } 
                        })
});

// datepicker in add visit form
jQuery(function() {
  jQuery( "#visit_visit_date" ).datepicker({ dateFormat: 'yy-mm-dd' });
});

// autocomplete used in search store and add dishes to visit
jQuery(function() {
  jQuery('#city_name').autocomplete({
    minLength: 3,
    source: '/autocomplete/cities',
    focus: function(event, ui) {
      jQuery('#city_name').val(ui.item.name);
      return false;
    },
    select: function(event, ui) {
      jQuery('#city_id').val(ui.item.id);
      return false;
    }
  });
  jQuery('#store_name').autocomplete({
    minLength: 3,
    source: function(request, response) {
      jQuery.ajax({
        url: "/autocomplete/stores",
        dataType: "json",
        data: {
          term : request.term,
          city_id : jQuery('#city_id').val()
        },
        success: function(data) {
          response(data);
        }
      });
    },
    focus: function(event, ui) {
      jQuery('#store_name').val(ui.item.name);
      return false;
    },
    select: function(event, ui) {
      jQuery('#store_id').val(ui.item.id);
      jQuery("#display").load('stores/'+jQuery('#store_id').val()+" #store");
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
          store_id : jQuery('#store_id').val()
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
      jQuery("#cart").load('/change_cart #cart', { 'dish_id': ui.item.id, 'dish_name': ui.item.name } );
      return false;
    }
  });
});