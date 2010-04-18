$(document).ready(function() {
	$.getJSON('/', function(data){
    $('input#search_field').autocomplete(data, {
		  formatItem: function(item) {
		    return item.text;
		  },
		  matchContains: true
		}).result(function(event, item) {
		  location.href = item.url;
		});
  });

// City map

	var map = new GMap2(document.getElementById('city_map'));
	map.setCenter(new GLatLng(center[0], center[1]), 11);
	map.addControl(new GSmallZoomControl());

	$.each(coordinates, function() {
		var text = "<a class=\"image_link\" href=\"" + $(this)[1] + "\">" + $(this)[0] + "</a>";
		var point = new GLatLng($(this)[2], $(this)[3]);
		var marker = new GMarker(point);
		marker.value = text;
		GEvent.addListener(marker, "click", function() {
		    map.openInfoWindowHtml(point, text);
	  });
		map.addOverlay(marker);
	});
});