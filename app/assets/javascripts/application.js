// Place your application-specific JavaScript functions and classes here
//= require jquery
//= require jquery_ujs
//= require jquery-ui
//= require_tree .

var $ = jQuery.noConflict();

//function to prevent submission of form on enter
$(function() {
  $("input").not( $(":button") ).keypress(function (evt) {
    if (evt.keyCode == 13) {
      alert("enter pressed");
      return false;
    }
  });
});


