// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require bootstrap-sprockets
//= require turbolinks
//= require poller
//= require_tree .
 
$(document).ready(function () {
	$("#how-panel").hide();
	window.setTimeout(function() {
	    $(".alert").fadeTo(1500, 0).slideUp(500, function(){
	        $(this).remove(); 
	    });
	}, 3000);
	$(function() {
    	$("#how_text").on("click", function() {
    	if ($("#how-panel").is(":visible") ) {
    		$("#how-panel").toggle();    
    	}else{
    		$("#how-panel").toggle();    
    		var y = $(window).scrollTop(); 
    		$("html, body").animate({ scrollTop: y + $(window).height() }, "slow");      
    	} 
    	return false;
    });
}); 
});
