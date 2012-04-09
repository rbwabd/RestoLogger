// Place your application-specific JavaScript functions and classes here
// require jquery
//= require jquery_ujs
// require jquery-ui
// maybe the below work in production but they crash the interpreter under windows
// require jquery.ui.sortable
// require jquery.ui.autocomplete
// require jquery.ui.tabs
// require jquery.ui.datepicker
// require jquery-star-rating
//= require_tree .

var $ = jQuery.noConflict();

// function to submit a store to a list
$(function() {
  $('#store_list_select').change(function() {
    $("#store_list_select option:selected").each(function () {
      // if a valid existing list selected, redirect to add_to list page
      if ($(this).val() == "") {     
      }
      // if "new list" option selected, redirect to list creation page
      else if ($(this).val() == -1) {
        // reset selection so that same prompt text is displayed (otherwise selection would be displayed)
        $(this).removeAttr('selected');
        window.location.href = "/store_lists/new?add_store_id=" + $("#store_id").val();
      }
      else {
        $(this).removeAttr('selected');
        window.location.href = "/store_lists/"+$(this).val()+"/add_item?store_id="+$('#store_id').val();
      }
    });  
    return false;
  });
});

//function to prevent submission of form on enter
$(function() {
  $("input").not( $(":button") ).keypress(function (evt) {
    if (evt.keyCode == 13) {
      //iname = $(this).val();
      //nestedFormEvents.addFields("add_nested_fields");
      
      // if Value of field is submit, submit the form. need to change this
      //if (iname !== 'Submit'){  
      //  var fields = $(this).parents('form:eq(0),body').find('button,input,textarea,select');
      //  var index = fields.index( this );
      //  if ( index > -1 && ( index + 1 ) < fields.length ) {
      //    fields.eq( index + 1 ).focus();
      // }
      return false;
      //}
    }
  });
});

// default tab option e.g. to show menu
$(function() {
  $("#tabs").tabs()
});

// tab for sorting menu tab and item orders
$(function() {
  var num_lists = $('[id^=taborder]').length;
  for(cnt=0;cnt<num_lists;cnt++){
    $( "#sortable"+cnt ).sortable({
      update: function(event,ui) {
        $(this).find(".ui-state-default").each(function(i){
          var val = $(this).attr("id");
          var part = val.split("_");
          document.getElementById("dd_"+part[1]).value = i;
        });
      }
    }).disableSelection();
  }
    
  var $tabs = $( "#tabssortable" ).tabs().find( ".ui-tabs-nav" ).sortable({ 
                            axis: "x",
                            update: function(event, ui){
                              //alert($(this).text());
                              $(this).find("a").each(function(i){
                                var val = $(this).attr("href");
                                var part = val.split("_");
                                document.getElementById("taborder_"+part[1]).value = i;
                              });
                            } 
                        })
});

// datepicker in add visit form
$(function() {
  $( "#visit_visit_date" ).datepicker({ dateFormat: 'yy-mm-dd' });
});

// autocomplete used in search store and add dishes to visit
$(function() {
  $('#city_search_name').autocomplete({
    minLength: 3,
    source: '/autocomplete/cities',
    focus: function(event, ui) {
      $('#city_search_name').val(ui.item.name);
      return false;
    },
    select: function(event, ui) {
      $('#city_id').val(ui.item.id);
      return false;
    }
  });
  $('#store_search_name').autocomplete({
    minLength: 3,
    source: function(request, response) {
      $.ajax({
        url: "/autocomplete/stores",
        dataType: "json",
        data: {
          term : request.term,
          city_id : $('#city_id').val()
        },
        success: function(data) {
          response(data);
        }
      });
    },
    focus: function(event, ui) {
      $('#store_search_name').val(ui.item.name);
      return false;
    },
    select: function(event, ui) {
      $('#store_id').val(ui.item.id);
      $('#display').load(''+$('#store_id').val()+'/show_search_result #store');
      return false;
    }
  });
  $('#dish_search_name').autocomplete({
    minLength: 3,
    source: '/autocomplete/dishes',
    select: function(event, ui) {
      $('#dish_id').val(ui.item.id);
      $.ajax({
        url: "/change_cart",
        dataType: "html",
        data: {
          dish_id : ui.item.id,
          dish_search_name: ui.item.name
        },
        success: function(data) {
          $('#dish_search_name').val("");
          $("#cart").html(data);  
          $('#dish_search_name').focus();
        }
      });
    }
  });
});