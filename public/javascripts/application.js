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
})