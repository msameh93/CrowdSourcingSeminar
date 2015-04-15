$(function() {
	setTimeout(updateRequests, 2000);
});

function updateRequests(){
	if($(".polling").length > 0){
		var game= $('#zone').attr('data-game');
		$.getScript("/update_game.js?&game=" + game);
	}else{
	$.getScript("/update_request.js")
	setTimeout(updateRequests, 2000);
}
}