function ValidSignIn(){
    var info =[]
    var msg = true
    var emailPattern = /^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,4}$/;
    $("#forms .rounded .alert strong").text("");
    $("#forms .rounded .alert").hide();
    if(emailPattern.test($("#email").val()) == false && $("#email").val() != ""){
        $("#forms .rounded .alert strong").text("Please Check Email !")
        $("#forms .rounded .alert").show();
        msg = false;
        return msg;
    }else if($("#email").val() == "" || $("#password").val() == ""){
        info.push("Email or Password Can't Balnk !")
        $("#forms .rounded .alert strong").text("Email or Password Can't Balnk !")
        $("#forms .rounded .alert").show();
        msg = false;
        return msg;
    }
    
    return msg;
}