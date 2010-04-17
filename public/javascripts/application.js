$(document).ready(function() {
	$.getJSON('/', function(data){
    $('input#search_field').autocomplete(data, {
		  formatItem: function(item) {
		    return item.text;
		  }
		}).result(function(event, item) {
		  location.href = item.url;
		});
  });
})