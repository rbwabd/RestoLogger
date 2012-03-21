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
  jQuery("#tabs").tabs()
});

jQuery(function() {
  // 2do: change this hard coded thing to dynamic
  //var num_lists = $('[id^=tabs-]').length;
  //for(i=1;i<=num_lists;i++){
  //  $("#sortable"+i).sortable().disableSelection();
  //}
  jQuery( "#sortable0, #sortable1, #sortable2, #sortable3, #sortable4, #sortable5, #sortable6, #sortable7, #sortable8, #sortable9, #sortable10, #sortable11, #sortable12, #sortable13" ).sortable({
    update: function(event,ui) {
      jQuery(this).find(".ui-state-default").each(function(i){
        var val = jQuery(this).attr("id");
        var part = val.split("_");
        //alert(part[0]+":"+part[1]+":"+part[2]);
        document.getElementById("dishorder_"+part[1]+"_"+part[2]).value = i;
      });
    }
  }).disableSelection();
  
  var jQuerytabs = jQuery( "#tabssortable" ).tabs().find( ".ui-tabs-nav" ).sortable({ 
                            axis: "x",
                            update: function(event, ui){
                              var data = jQuery('#tabssortable .ui-tabs-nav').sortable('toArray');
                              for(var key in data) {
                                var val = data[key];
                                var part = val.split("_");
                                //update each hidden field used to store the list item position
                                document.getElementById("taborder"+part[1]).value = key;
                              }
                            } 
                        })
});

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
      return false;
    }
  });
});