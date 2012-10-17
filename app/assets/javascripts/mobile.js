//= require jquery
//= require jquery_ujs
//= require bootstrap-collapse
//= require jquery.mobile
//= require jquery.easing.compatibility
//= require bootstrap-tab
//= require tag-it
//= require jquery-ui-1.8.autocomplete.min


$(document).ready(function(){
  var lat, lng
  navigator.geolocation.getCurrentPosition (function (pos){
    lat = pos.coords.latitude
    lng = pos.coords.longitude
    data = {
      geo:{
        mobile_lat: lat,
        mobile_lng: lng
      }
    }

    $.ajax({
      url: "/set_time_zone",
      type: 'GET',
      data : data
    });
  });
});

