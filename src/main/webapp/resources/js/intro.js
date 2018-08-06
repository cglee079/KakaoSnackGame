function doStartGame(tg) {
	if(clickBlock) { return ;}
	clickBlock = true;
	
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
		
		clickBlock = false;
	}, 500);
}

function doToggleSound(tg) {
	var tg = $(tg);
	tg.toggleClass("on");

	if (tg.hasClass("on")) {
		doSoundOn();
		startAudio(btnClickSound);
	} else {
		startAudio(btnClickSound);
		doSoundOff();
	}
}

//도움말 버튼 클릭시
function doHelp() {
	if(clickBlock) { return ;}
	clickBlock = true;
	
	initHelp();
	
	startAudio(btnClickSound);
	$(".help").addClass("on");
	$(".help .h-wrap-fg").addClass("on");
	
	doExplain(true);
	
	timeoutSetBlockFalse();
}