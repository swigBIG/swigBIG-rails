$(document).ready(function(){
  
  $("#tk_bars").tokenInput("home/bars_lists", {
    theme: "facebook",
    preventDuplicates: true
  });
  
  $("#tk_users").tokenInput("home/users_lists", {
    theme: "facebook",
    preventDuplicates: true
  });
});
