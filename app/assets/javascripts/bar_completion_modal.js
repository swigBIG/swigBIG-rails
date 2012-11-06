
$(document).ready(function() {
  $('#copy_example').click(function() {
    $('#bar_standard_swig_to_copy').html($.trim($('#example').html()))
  });

  $("#tk_sports").tokenInput("/bars/sport_lists", {
    theme: "facebook",
    preventDuplicates: true
  });
});

function countChar(val){
  var len = val.value.length;
  if (len >= 500) {
    val.value = val.value.substring(0, 500);
  }else {
    $('#charNum').text(len);
  }
};

function validate_address(){
  if($('#bar_address').val() == ''){
    $('#bar_address').css('border', '1px solid red');
    valid_address = false;
  }else{
    $('#bar_address').css('border', '1px solid black');
    valid_address = true;
  }
  if($('#bar_city').val() == ''){
    $('#bar_city').css('border', '1px solid red');
    valid_city = false;
  }else{
    $('#bar_city').css('border', '1px solid black');
    valid_city = true;
  }
  if($('#bar_zip_code').val() == ''){
    $('#bar_zip_code').css('border', '1px solid red');
    valid_zip = false;
  }else{
    $('#bar_zip_code').css('border', '1px solid black');
    valid_zip = true;
  }
  if(valid_address && valid_city && valid_zip){
    $('#goto_phone').click();
  }
}
function validate_phone(){
  if($('#bar_phone_number').val() == ''){
    $('#bar_phone_number').css('border', '1px solid red');
    valid_phone = false;
  }else{
    $('#bar_phone_number').css('border', '1px solid black');
    valid_phone = true;
  }
  if(valid_phone){
    $('#goto_link').click();
  }
}
function validate_link(){
  if($('#bar_website_link').val() == ''){
    $('#bar_website_link').css('border', '1px solid red');
    valid_web = false;
  }else{
    $('#bar_website_link').css('border', '1px solid black');
    valid_web = true;
  }
  if($('#bar_facebook_link').val() == ''){
    $('#bar_facebook_link').css('border', '1px solid red');
    valid_facebook = false;
  }else{
    $('#bar_facebook_link').css('border', '1px solid black');
    valid_facebook = true;
  }
  if($('#bar_twitter_link').val() == ''){
    $('#bar_twitter_link').css('border', '1px solid red');
    valid_twitter = false;
  }else{
    $('#bar_twitter_link').css('border', '1px solid black');
    valid_twitter = true;
  }
  if($('#bar_google_plus_link').val() == ''){
    $('#bar_google_plus_link').css('border', '1px solid red');
    valid_google = false;
  }else{
    $('#bar_google_plus_link').css('border', '1px solid black');
    valid_google = true;
  }
  if(valid_web && valid_facebook && valid_twitter && valid_google){
    $('#goto_hour').click();
  }
}
function validate_hour(){
  if($('#bar_bar_hour').val() == ''){
    $('#bar_bar_hour').css('border', '1px solid red');
    valid_hour = false;
  }else{
    $('#bar_bar_hour').css('border', '1px solid black');
    valid_hour = true;
  }
  if(valid_hour){
    $('#goto_description').click();
  }
}

function validate_description(){
  if($('#bar_bar_description').val() == ''){
    $('#bar_bar_description').css('border', '1px solid red');
    $('#bar_description_validation').text('Please describe your bar!!');
    valid_description = false;
  }else{
    $('#bar_bar_description').css('border', '1px solid black');
    valid_description= true;
  }
  if(valid_description){
    $('#goto_sport_team').click();
  }
}
function validate_sports_team(){
  if($('#mytags').val() == ''){
    $('#mytags').css('border', '1px solid red');
    valid_description = false;
  }else{
    $('#mytags').css('border', '1px solid black');
    valid_description = true;
  }
  if(valid_description){
    $('#goto_check_data').click();
    get_all_data();
  }
}
$('#goto_check_data').click();
get_all_data();

function get_all_data(){
  $('#address_text').html($('#bar_address').val());
  $('#city_text').html($('#bar_city').val());
  $('#zip_text').html($('#bar_zip_code').val());
  $('#phone_text').html($('#bar_phone_number').val());
  $('#website_text').html($('#bar_website_link').val());
  $('#facebook_text').html($('#bar_facebook_link').val());
  $('#twitter_text').html($('#bar_twitter_link').val());
  $('#google_text').html($('#bar_google_plus_link').val());
  $('#hour_text').html($('#bar_bar_hour').val());
  $('#description_text').html($('#bar_bar_description').val());
  $('#sport_text').html($('#mytags').val());
  $('#swig_text').html($('#swig').val());
}
function validate_standard_swig(){
  if($('#bar_standard_swig_to_copy').val() == ''){
    $('#bar_standard_swig_to_copy').css('border', '1px solid red');
    $('#swig_notice').text('Bar must have at least 1 standard swig!');
    valid_standard_swig = false;
  }else{
    $('#bar_standard_swig_to_copy').css('border', '1px solid black');
    valid_standard_swig = true;
  }
  if(valid_standard_swig){
    $('#goto_description').click();
  }
}

