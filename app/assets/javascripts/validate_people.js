function validatePeople(day, button, action){
  if (action == "new"){
    var valid = false;
    if($('#peoples_'+day+'_0').val() == '' || $('#peoples_'+day+'_1').val() == '' || $('#peoples_'+day+'_2').val() == '' || isNaN(parseInt($('#peoples_'+day+'_0').val())) || isNaN(parseInt($('#peoples_'+day+'_1').val())) || isNaN(parseInt($('#peoples_'+day+'_2').val())) || parseInt($('#peoples_'+day+'_0').val()) <= 0 || parseInt($('#peoples_'+day+'_1').val()) <= 0 || parseInt($('#peoples_'+day+'_2').val()) <= 0 ){
      $('#people_warning_text_'+day+'_0').hide();
      $('#peoples_'+day+'_0').css('border', '1px solid red');
      $('#people_warning_text_'+day+'_1').hide();
      $('#peoples_'+day+'_1').css('border', '1px solid red');
      $('#people_warning_text_'+day+'_2').hide();
      $('#peoples_'+day+'_2').css('border', '1px solid red');
    
      if ($('#peoples_'+day+'_0').val() == '' || isNaN(parseInt($('#peoples_'+day+'_0').val())) || parseInt($('#peoples_'+day+'_0').val()) <= 0 ){
        $('#people_warning_text_'+day+'_0').show();
        $('#peoples_'+day+'_0').css('border', '1px solid red');
      }
      else if ($('#peoples_'+day+'_1').val() == '' || isNaN(parseInt($('#peoples_'+day+'_1').val())) || parseInt($('#peoples_'+day+'_1').val()) <= 0 ){
        $('#people_warning_text_'+day+'_1').show();
        $('#peoples_'+day+'_1').css('border', '1px solid red');
      }
      else if ($('#peoples_'+day+'_2').val() == '' || isNaN(parseInt($('#peoples_'+day+'_2').val())) || parseInt($('#peoples_'+day+'_2').val()) <= 0 ){
        $('#people_warning_text_'+day+'_2').show();
        $('#peoples_'+day+'_2').css('border', '1px solid red');
      }

      valid_people = false;
    }else{
      $('#peoples_'+day+'_0').css('border', '1px solid grey');
      $('#peoples_'+day+'_1').css('border', '1px solid grey');
      $('#peoples_'+day+'_2').css('border', '1px solid grey');
      valid_people = true;
    }
    if(valid_people){
      $('#'+button+'').click();
    }
    return valid;
  }
  else if (action == "update"){
    var valid = false;
    if($('#peoples_update_'+day+'_0').val() == '' || $('#peoples_update_'+day+'_1').val() == '' || $('#peoples_update_'+day+'_2').val() == '' || isNaN(parseInt($('#peoples_update_'+day+'_0').val())) || isNaN(parseInt($('#peoples_update_'+day+'_1').val())) || isNaN(parseInt($('#peoples_update_'+day+'_2').val())) || parseInt($('#peoples_update_'+day+'_0').val()) <= 0 || parseInt($('#peoples_update_'+day+'_1').val()) <= 0 || parseInt($('#peoples_update_'+day+'_2').val()) <= 0 ){
      $('#people_update_warning_text_'+day+'_0').hide();
      $('#peoples_update_'+day+'_0').css('border', '1px solid red');
      $('#people_update_warning_text_'+day+'_1').hide();
      $('#peoples_update_'+day+'_1').css('border', '1px solid red');
      $('#people_update_warning_text_'+day+'_2').hide();
      $('#peoples_update_'+day+'_2').css('border', '1px solid red');

      if ($('#peoples_update_'+day+'_0').val() == '' || isNaN(parseInt($('#peoples_update_'+day+'_0').val())) || parseInt($('#peoples_update_'+day+'_0').val()) <= 0 ){
        $('#people_update_warning_text_'+day+'_0').show();
        $('#peoples_update_'+day+'_0').css('border', '1px solid red');
      }
      else if ($('#peoples_update_'+day+'_1').val() == '' || isNaN(parseInt($('#peoples_update_'+day+'_1').val())) || parseInt($('#peoples_update_'+day+'_1').val()) <= 0 ){
        $('#people_update_warning_text_'+day+'_1').show();
        $('#peoples_update_'+day+'_1').css('border', '1px solid red');
      }
      else if ($('#peoples_update_'+day+'_2').val() == '' || isNaN(parseInt($('#peoples_update_'+day+'_2').val())) || parseInt($('#peoples_update_'+day+'_2').val()) <= 0 ){
        $('#people_update_warning_text_'+day+'_2').show();
        $('#peoples_update_'+day+'_2').css('border', '1px solid red');
      }

      valid_people = false;
    }else{
      $('#peoples_update_'+day+'_0').css('border', '1px solid grey');
      $('#peoples_update_'+day+'_1').css('border', '1px solid grey');
      $('#peoples_update_'+day+'_2').css('border', '1px solid grey');
      valid_people = true;
    }
    if(valid_people){
      $('#'+button+'').click();
    }
    return valid;
  }

}