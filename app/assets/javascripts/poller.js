$(function() {
	setTimeout(updateRequests, 2000);
});

function updateRequests(){
	if($("#game-body").length > 0){
		$.getScript("/update_game.js?&game=" + $('#game-body').attr('data-game'));
	}else{
		$.getScript("/update_request.js")
		
	}
	setTimeout(updateRequests, 2000);
}