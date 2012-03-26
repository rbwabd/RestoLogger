// Place your application-specific JavaScript functions and classes here
//= require jquery
//= require jquery_ujs
//= require jquery-ui 
//= require_tree .

var $ = jQuery.noConflict();

// default tab option e.g. to show menu
$(function() {
  $("#tabs").tabs()
});

// datepicker in add visit form
$(function() {
  $( "#visit_visit_date" ).datepicker({ dateFormat: 'yy-mm-dd' });
});
