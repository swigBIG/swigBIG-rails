var map

function GenerateMap(lat, lng){
    var myOptions = {
        center: new google.maps.LatLng(lat, lng),
        zoom: 17,
        mapTypeId: google.maps.MapTypeId.ROADMAP,
        disableDefaultUI: true
    };
    map = new google.maps.Map(document.getElementById("map_canvas"), myOptions);
    CreateMarker(lat, lng, '/assets/data/images/user_blue.png');
    CreateRadius(myOptions);
}

function CreateMarker(lat, lng, icon){
    new google.maps.Marker({
        position: new google.maps.LatLng(lat, lng),
        map: map,
        icon: icon
    });
}

function CreateRadius(myOptions){
    var radius = {
        strokeColor: "#7B90E4",
        strokeOpacity: 0.8,
        strokeWeight: 2,
        fillColor: "#8C9EE7",
        fillOpacity: 0.35,
        map: map,
        center: myOptions.center,
        radius: 30
    };
    new google.maps.Circle(radius);
}