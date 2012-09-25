/*
document.addEventListener("deviceready", onDeviceReady, false);

// PhoneGap is ready
//
function onDeviceReady() {
  navigator.geolocation.getCurrentPosition(onSuccess, onError);
}

// onSuccess Geolocation
//
function onSuccess(position) {
  var element = document.getElementById('geolocation');
  window.latitude = position.coords.latitude
  window.longitude = position.coords.longitude
}

// onError Callback receives a PositionError object
//
function onError(error) {
  alert('code: '    + error.code    + '\n' +
    'message: ' + error.message + '\n');
}
*/