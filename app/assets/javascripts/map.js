/*(function( $ ){

    $.fn.googleMap = function(options) {

        // Create some defaults, extending them with any options that were provided
        var geocoder;
        var map;
        var centerLatLng;
        var mapCanvas = document.getElementById($(this).attr('id'));

        //Jakarta
        var centerLat = -6.211544;
        var centerLng = 106.845172;
        var zoom = 8;

        if (options != undefined){
            if((options.centerLat != undefined) || (options.centerLng != undefined)){
                centerLat = options.centerLat;
                centerLng = options.centerLng;
            }

            if(options.zoom != undefined){
                zoom = options.zoom;
            }
        }

        drawMap();


        function drawMap(){
            geocoder = new google.maps.Geocoder();
            var centerLatLng = new google.maps.LatLng(centerLat, centerLng);
            var mapOptions = {
                zoom: zoom,
                center: centerLatLng,
                mapTypeId: google.maps.MapTypeId.ROADMAP
            }
            map = new google.maps.Map(mapCanvas, mapOptions);

            if(options.markerData != undefined){
                addMarker();
            }
            

        }

        //Marker
        function addMarker(){
            var markerList = options.markerData;
            var i = 0;
            for (i = 0; i < markerList.length; i++){
                var newMarker = markerList[i];
                var marker = new google.maps.Marker({
                    position: new google.maps.LatLng(newMarker.lat, newMarker.lng),
                    map: map,
                    title: newMarker.info
                });
                addInfoWindow(marker, newMarker);

            }

        }

        function addInfoWindow(marker, newMarker){
            var infowindow = new google.maps.InfoWindow({
                content: newMarker.info
            });

            google.maps.event.addListener(marker, 'click', function() {
                infowindow.open(map,marker);
            });
        }


        function findAddress(location) {
            alert(location);
            var address = location;
            geocoder.geocode( {
                'address': address
            }, function(results, status) {
                if (status == google.maps.GeocoderStatus.OK) {
                    map.setCenter(results[0].geometry.location);
                    var marker = new google.maps.Marker({
                        map: map,
                        position: results[0].geometry.location
                    });
                } else {
                    alert("Geocode was not successful for the following reason: " + status);
                }
            });
        }

    };
})( jQuery );
*/
