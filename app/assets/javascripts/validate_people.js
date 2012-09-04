function validatePeople(day, button){
  var valid = false;
//  if(isNaN(parseInt($('#peoples_'+day+'_0').val()))
//    || isNaN(parseInt($('#peoples_'+day+'_1').val()))
//    || isNaN(parseInt($('#peoples_'+day+'_2').val()))
//    || parseInt($('#peoples_'+day+'_0').val()) <= 0
//    || parseInt($('#peoples_'+day+'_1').val()) <= 0
//    || parseInt($('#peoples_'+day+'_2').val()) <= 0)  {
//    valid = true;
//  }
  //  else{
  //    $('#peoples_'+day+'_0').css('border', '1px solid grey');
  //    $('#peoples_'+day+'_1').css('border', '1px solid grey');
  //    $('#peoples_'+day+'_2').css('border', '1px solid grey');
  //    alert("salah");
  //  }



//  if($('#peoples_'+day+'_0').val() == '' || $('#peoples_'+day+'_1').val() == '' || $('#peoples_'+day+'_2').val() == ''){
//    $('#peoples_'+day+'_0').css('border', '1px solid red');
//    $('#peoples_'+day+'_1').css('border', '1px solid red');
//    $('#peoples_'+day+'_2').css('border', '1px solid red');
//    $('#people_text').text('people require must fill!');
//    valid_people = false;
//  }else{
//    $('#peoples_'+day+'_0').css('border', '1px solid grey');
//    $('#peoples_'+day+'_1').css('border', '1px solid grey');
//    $('#peoples_'+day+'_2').css('border', '1px solid grey');
//    valid_people = true;
//  }
//  if(valid_people){
//    $('#'+button+'').click();
//  }

  if($('#peoples_'+day+'_0').val() == '' || $('#peoples_'+day+'_1').val() == '' || $('#peoples_'+day+'_2').val() == '' || isNaN(parseInt($('#peoples_'+day+'_0').val())) || isNaN(parseInt($('#peoples_'+day+'_1').val())) || isNaN(parseInt($('#peoples_'+day+'_2').val())) || parseInt($('#peoples_'+day+'_0').val()) <= 0 || parseInt($('#peoples_'+day+'_1').val()) <= 0 || parseInt($('#peoples_'+day+'_2').val()) <= 0 ){
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
  return valid;
}