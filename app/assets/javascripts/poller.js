$(function() {
	setTimeout(updateRequests, 2000);
});

function updateRequests(){
	if($("#game-body").length > 0){
		if($(".gamepolling").attr('data-turn') == 'false'){
			var game= $('#game-body').attr('data-game');
			$.getScript("/update_game.js?&game=" + game);
		}
	}else{
		$.getScript("/update_request.js")
	}
	setTimeout(updateRequests, 2000);
}