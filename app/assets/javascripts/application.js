// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require ckeditor/ckeditor
//= require bootstrap-collapse
//= require bootstrap-dropdown
//= require bootstrap-modal
//= require bootstrap-tab
//= require chart
//= require chosen.jquery
//= require jquery-ui-1.8.autocomplete.min
//= require jquery-ui.min
//= require jquery.livesearch
//= require jquery.numeric
//= require jquery.smartWizard-2.0
//= require jquery.tokeninput
//= require jquery.shorten.1.0
//= require jscolor
//= require tag-it
//= require validate_people

$(document).ready(function(){
  $("#options_action").change(function(){
    if($(this).val() == "1"){
      $(".checkbox").attr("checked", "checked")
    }
    else {
      $(".checkbox").removeAttr("checked")
    }
  });
  $("#custom_action").change(function(){
    if($(this).val() != "0"){
      $("#message_action_form").submit();
    }
  })
})

//---test time zone
