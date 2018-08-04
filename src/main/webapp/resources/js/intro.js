function doStartGame(tg) {
	var tg = $(tg);
	if(!tg.hasClass("on")){
		tg.addClass("on");
		
		startAudio(btnClickSound);
		stopBGM();
		
		setTimeout(function(){
			redrawToPlay();
			initGame();
			
			stageEffectOn();
			setTimeout(function(){
				stageEffectOff();
				startPlay();
				startBGM();
			}, 1500);
			
			tg.removeClass("on");
		}, 500);
	}
}

function doToggleSound(tg) {
	var tg = $(tg);
	tg.toggleClass("on");

	if (tg.hasClass("on")) {
		doSoundOn();
		startBGM();
		startAudio(btnClickSound);
	} else {
		startAudio(btnClickSound);
		doSoundOff();
		stopBGM();
	}
}

//도움말 버튼 클릭시
function doHelp() {
	initHelp();
	startAudio(btnClickSound);
	$(".help").addClass("on");
	$(".help .h-wrap-fg").addClass("on");
	
	doExplain(true);
}