var city
var data_bar
var jQT = new $.jQTouch({});
//var url = 'http://localhost:3000/'
var url = 'http://swigbig.com/'
var user = {
  id: ""
}
var swig = {
  deal: "",
  people: "",
  bar: ""
}

function viewMap(){
  window.location = "/api/v1/swig_mobiles/get_map#bar-view-map" 
}

function gotoDashboard(){
  window.location = "/api/v1/swig_mobiles/swigbig_mobile" 
  DashboardUser()
  jQT.goTo("#dashboard")
}

function gotoProfile(){
  window.location = "/api/v1/swig_mobiles/swigbig_mobile#profile" 
}

function gotoSwig(){
  window.location = "/api/v1/swig_mobiles/swigbig_mobile#bar_to_swig" 
}

function init(){
  PageHome();
  $.ajax(url+"api/v1/swig_mobiles/swigbig_mobile?lat="+window.latitude+ "&" + "lon=" + window.longitude);
}

function PageHome(){
  $("#home #pagehome #sign_up").click(function(){
    jQT.goTo("#register")
    Cancel()
  //    sign_up_validation()
  });

  $("#home #pagehome #user_sign_in").click(function(){
    jQT.goTo("#forms")
    Login()
  });
}

function Login(){
  data = {
    user:{
      email: $("#email").val(),
      password:  $("#password").val(),
      remember_me: "0"
    }
  };
  ajaxRequest("POST",url+"api/v1/user/login",data,function(data){
    console.log(a = data)
    
    if(data.user !== undefined){
      user.id = data.user.id
      //user.name = data.user.name
      $("#profile_email").html("<h2> Email: "+data.user.email+"</h2>")
      $("#profile_name").html("<h2> Name: "+data.user.name+"</h2>")
      DashboardUser()
      jQT.goTo("#dashboard")
    }else{
      $("#error-msg-login").html("login failure!")
    }
   
  });
}

function DashboardUser(){
  var data_req = {
    user:{
      id: user.id,
      lat: window.latitude,
      lng: window.longitude
    }
  };
  //GenerateMap(data.city_lat_lng[1], data.city_lat_lng[2])
  //GenerateMap("40.7089", "-74.0012")

  ajaxRequest("POST",url+"api/v1/swig_mobiles/home",data_req,function(data){
    //GenerateMap(data.city_lat_lng[1], data.city_lat_lng[2])
    console.log(data)
    data_bar = data
    for(var i = 0; i <  data.bars.length; i++) {
      var bar = data.bars[i];
      //      CreateMarker(bar[2], bar[3])
      //$("#dashboard .bar_list").append("<tr><td>"+bar[0]+"<td/><td>"+bar[4]+"<td/><td><a id="+bar[5]+" onclick='bar_swigs_list("+bar[5]+")'><img src='images/goto.png' style='height: 50px;'/></a></td></tr>")
      $("#dashboard .bar_list").append("<tr onclick='bar_swigs_list("+bar[5]+","+user.id+")'><td>"+bar[0]+"<td/><td>"+bar[4]+"<td/></tr>")
    }
    for(var i = 0; i <  5; i++) {
      var bar = data.bars[i];
      $("#bar_to_swig .bar_list_to_swig").append("<tr onclick='bar_swigs_list("+bar[5]+")'><td>"+bar[0]+"<td/><td>"+bar[4]+"<td/></tr>")
    }

    $("#dashboard #map").click(function(){
      jQT.goTo("#map_canvas")
    });
    
  })
}

function bar_swigs_list(id){
  //  window.location = '/api/v1/swig_mobiles/swig_list'
  data = {
    bar_id: id
  }
  ajaxRequest("POST",url+"api/v1/swig_mobiles/bar_swigs",data,function(data){
    $("#bar_name").html("<h2>"+data.bar_name+"</h2>")
    $("#swig_to_bar").html("<a class='btn btn-large buttonWidth' style='width: 80%;margin-bottom: 10px;' onclick='swig_bar("+id+")'><b>SWIG!</b></a>")
    $("#bar_detail .swig_list").html("")
    
    for(var i = 0; i < data.swigs.length; i++) {
      var bar = data.swigs[i];
      var tier;
      
      if(i == 0){
        tier = "Tier One";
      }else if(i == 1){
        tier = "Tier Two";
      }else{
        tier = "Tier Three";
      }
      
      $("#bar_detail .swig_list").append('<tr><td><div class="accordion" id="accordion-'+i+'"><div class="accordion-group">'+
        '<div class="accordion-heading"><div><a class="accordion-toggle" href="#" onclick="showHide('+i+')">'+
        tier+'</a></div><div style="text-align:right;margin-top: -22px;margin-right:20px">'+
        bar[2]+'</div></div><div id='+i+' class="accordion-body collapse"><div class="accordion-inner">'+
        'Bar Name: '+ bar[1]+
        '</div></div></div></td></tr>')
    //        $("#bar_detail .swig_list").append("<tr><td>"+bar[1]+"<td/><td>"+bar[2]+"<td/></tr>")
    }
    jQT.goTo("#bar_detail")
  });
}

function showHide(div){
  var inVal = $('.in').html()
            
  if(inVal == null){
    $('#'+div).addClass('in')
  }else{
    $('#'+div).removeClass('in')
  }
  return false
}
$(".btn-bar-view-map").live('click', function(){
  
  })

function fbRequest(){
  window.location = url+"users/auth/facebook?mobile=true"
}

function swig_bar(bar_id){
  data = {
    bar_id: bar_id,
    user_id: user.id
  }
  console.log(data)
  ajaxRequest("POST",url+"/api/v1/swig_mobiles/swig_bar",data,function(data){
    $("#status").html("<h2>"+data.text+"</h2>")
    jQT.goTo("#swig_status")
  });
}


//function get_distances(data){
//  for(var i = 0; i <  data.bars.length; i++) {
//    var bar = data.bars[i];
//
//    ajaxRequest("POST",url+"api/v1/swig_mobiles/get_lat_lon", bar, function(data){
//
//    })
//    }
//}


//function Logout(){
//    ajaxRequest("GET",url+"api/v1/user/logout",data,function(data){
//        console.log(data)
//        jQT.goTo("#home")
//    })
//}
//
function Cancel(){
  $("#register #cancel_register").click(function(){
    jQT.goTo("#home")
  })
}

function ajaxRequest(type_rq, url_rq, data_rq, success){
  $.ajax({
    url: url_rq,
    type: type_rq,
    data : data_rq,
    cache: false,
    timeout: 3000,
    beforeSend: function (data){
      $("#loader").show();
    },
    success: function(data){
      if(typeof(data) == "string"){
        data =  jQuery.parseJSON(data)        
      }else{
        data
      }
      success(data);
    },
    error: function(jqXHR, textStatus, errorThrown){
    //      error()
    },
    complete: function(jqXHR, textStatus){
      $("#loader").hide();

    }
  });
}
var t=setTimeout(function(){
  $(".alert-success").hide();
  $(".alert-error").hide();
  $(".alert-notice").hide();
},10000)


function signUp(){
  var email = $("#email_register").val();
  var password = $("#password_register").val();
  var confirmation = $("#password_confirmation").val();
  var full_name = $("#full_name").val();
  var bird_date = $("#bird_date").val();
  var agree = $("#agree:checked").val()
 
  if(email.length == 0){
    $("#error-msg").html("Email can't be blank")
    return false
  }else if(email.length <= 5){
    $("#error-msg").html("Invalid email address")
    return false
  }
  else if(password.length == 0){
    $("#error-msg").html("Password can't be blank")
    return false
  }else if(password.length < 6){
    $("#error-msg").html("Password must be at least 6 characters")
    return false
  }
  else if(confirmation !== password){
    $("#error-msg").html("Password confirmation doesn't match")
    return false
  }
  else if(agree == null){
    $("#error-msg").html("You have to agree first")
    return false
  }else{
    data = {
      user: {
        email: email,
        password: password
      }
    }
    ajaxRequest("POST",url+"api/v1/swig_mobiles/register",data,function(data){
      if(data.notice == undefined){
        window.user_id = data.user_id
        jQT.goTo("#step2")
      }else{
        $("#error-msg").html("*Error to register your account")
        jQT.goTo("#register")
        
      }
    }, function(){
      alert("Failed to register")
    });
  }
}



function complete(){
  var full_name = $("#full_name").val();
  var day = $('#article_written_on_3i').val();
  var month = $('#article_written_on_2i').val();
  var year = $('#article_written_on_1i').val();
  var bird_date = day + '/' + month + '/' + year
 
  if(full_name.length == 0){
    $("#error-msg2").html("Fullname can't be blank")
    return false
  }
  else if(bird_date.length == 0){
    $("#error-msg2").html("Bird Date can't be blank")
    return false
  }
  else{
    data = {
      name: full_name,
      bird_date: bird_date, 
      id: window.user_id
    }
    ajaxRequest("POST",url+"api/v1/swig_mobiles/update_user",data,function(data){
      if(data.notice == undefined){
        $(".alert-success").show();
        jQT.goTo("#home")
      }else{
        $("#error-msg2").html("*Failed to complete your account")
        jQT.goTo("#step2")
        
      }
    }, function(){
      alert("Failed to register")
    });
  }
}

