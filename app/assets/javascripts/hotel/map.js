//Google Map object
var map = null;

//url to get hotel location details
var hotelServiceUrl = "/hotels/hotel_location";
var allHotelServiceUrl = "/hotels/get_all_hotel_location";
//the marker for a hotel (at center of the map)
var mainMarker = null;

//the markers for places around the hotel
var otherMarkers = [];


$(document).ready(function(){
	//initialize Google Map here
	$("a.map-link").fancybox({
	});
	$("#toogle_view").fancybox({
	});
})

/*
* Initialize a Map object
*/
function initializeMap(center){
		var mapOptions = {
			center: center,
			zoom: 16,
			mapTypeId: google.maps.MapTypeId.ROADMAP
		}
		map = new google.maps.Map(document.getElementById('map_canvas'), mapOptions);
}
/*
* Display Google Map on screen with selected hotel
* Author: ChienTX
*/
function showHotelMap(hotelId){
	//check if the map has been loaded
	//if (map != null){
		//return;
	//}

  $("#map_canvas").html("");
  $("#map_canvas").mask("Loading...");

	//send request to get location of current hotel and other places around it
	$.ajax({
		url: hotelServiceUrl,
		data: {'hotelId' : hotelId},
		type: 'GET',
		dataType: 'JSON',
		success: function(response){
			//process data

			if(response.data != false){
				var hotel = response.data.hotel;
	
				var places = response.data.places;

				//remove the first place because it is the same with hotel
				places.splice(0, 1);

				//display the map here
				var center = new google.maps.LatLng(hotel.Latitude, hotel.Longitude);

				//initialize map with provided center
				initializeMap(center);

				//info
				var html = "<div>" + hotel.Name + "<br />" + hotel.Address1 + "</div>";
				var infoWindow = new google.maps.InfoWindow({
					content: html
				})

				//display hotel at the center of the map
				mainMarker = new google.maps.Marker({
					position: center,
					title: hotel.name,
					map: map,
					icon: '/assets/hotel.png'
				});
				google.maps.event.addListener(mainMarker, 'mouseover', function(){
					infoWindow.setContent(html);
					infoWindow.open(map, mainMarker);
				})
				infoWindow.open(map, mainMarker);

				var subInfoWindow = new google.maps.InfoWindow();

				//display other places on the map
				$.each(places, function(index, place){

					var marker = new google.maps.Marker({
						position: new google.maps.LatLng(place.latitude, place.longitude),
						title: place.name,
						map: map
					});

					otherMarkers.push(marker);

					google.maps.event.addListener(marker, 'mouseover', function(){
						infoWindow.setContent(place.description);
						infoWindow.open(map, marker);
					})
				});

	      $("#map_canvas").unmask();
	    }else{
	    	$("#map_canvas").text("No maps found")
	    	$("#map_canvas").unmask();
	    	//alert("No maps found");
	    	
	    	
	    }
		}
	})
}
jQuery.fn.outer = function() {
	return $( $('<div></div>').html(this.clone()) ).html();
}
/*
* Display Google Map on screen with selected hotel
* Author: KhoiPCQ
*/
function showAllHotelMap(){
	
	var array_hotels = [];
	var array_links = {};
	$("a.map-link").each(function(i,e){
    array_hotels.push($(e).attr("tab"));
	});
	$("span.bold-blue-text a").each(function(i,e){
    var href = $(e).attr("href");
    var h_key = href.match(/\d+\?/)[0].match(/\d+/)[0];
    array_links[h_key] = $(e).outer();
	});
	
	$("#map_canvas").html("");
  $("#map_canvas").mask("Loading...");

	//send request to get location of current hotel and other places around it
	$.ajax({
		url: allHotelServiceUrl,
		data: {'hotelIds' : array_hotels},
		type: 'GET',
		dataType: 'JSON',
		success: function(response){
			//process data
			if(response.data != false){
				var hotel = response.data.hotel;
				
				var places = response.data.places;


				//display the map here
				var center = new google.maps.LatLng(places[0]["Latitude"], places[0]["Longitude"]);

				//initialize map with provided center
				initializeMap(center);

				//info
				 var html = "<div>" + array_links[places[0]["EANHotelID"].toString()] + "<br />" + places[0]["Address1"] + "</div>";
				 var infoWindow = new google.maps.InfoWindow({
				 	content: html
				 })

				//display hotel at the center of the map
				mainMarker = new google.maps.Marker({
				 	position: center,
				 	//title: places[0]["Name"] + "\n" + places[0]["Address1"] ,
				 	map: map,
				 	icon: '/assets/hotel.png'
				});
				
				//infoWindow.open(map, mainMarker);
				google.maps.event.addListener(mainMarker, 'mouseover', function(){
						infoWindow.setContent(html);
						infoWindow.open(map, mainMarker);
					})
				
				//places.splice(0, 1);
				var subInfoWindow = new google.maps.InfoWindow();
				//display other places on the map
				$.each(places, function(index, place){
					var desc = place["Name"] + "\n" + place["Address1"];
					var html = "<div>" + array_links[place["EANHotelID"].toString()] + "<br />" + place["Address1"] + "</div>";
					var marker = new google.maps.Marker({
						position: new google.maps.LatLng(place["Latitude"], place["Longitude"]),
						//title: desc,
						map: map,
				 		icon: '/assets/hotel.png'
					});
					
				  
					otherMarkers.push(map,marker);
					//subInfoWindow.open(map, marker);
					google.maps.event.addListener(marker, 'mouseover', function(){
						subInfoWindow.setContent(html);
						subInfoWindow.open(map, marker);
					})
				});

	      $("#map_canvas").unmask();
	    }else{
	    	$("#map_canvas").text("No maps found")
	    	$("#map_canvas").unmask();
	    	//alert("No maps found");
	    	
	    	
	    }
		}
	})
}