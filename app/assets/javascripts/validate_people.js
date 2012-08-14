function validatePeople(day, button){
  if($('#peoples_'+day+'_0').val() == '' || $('#peoples_'+day+'_1').val() == '' || $('#peoples_'+day+'_2').val() == ''){
    $('#peoples_'+day+'_0').css('border', '1px solid red');
    $('#peoples_'+day+'_1').css('border', '1px solid red');
    $('#peoples_'+day+'_2').css('border', '1px solid red');
    $('#people_text').text('people require must fill!');
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
  return false
}