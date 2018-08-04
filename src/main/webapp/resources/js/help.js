var tapNumber = 0;

function initHelp(){
	var moveFriends = $(".h-move-friends");
	moveFriends.removeAttr("style");
	moveFriends.css("left", ((life * 0.65) + 20) + "%");
	
	var basketOccupy = $(".h-icon-basket-occupy");
	var basket  = $(".h-icon-basket");
	basket.removeAttr("style");
	basket.css("width", basketOccupy.width());
	basket.css("height", basketOccupy.width());
	
	var progressBar = $(".h-progress .h-progress-bar");
	var cropProgressBar = $(".h-progress .h-progress-bar .h-crop-progress-bar");
	progressBar.removeAttr("style");
	cropProgressBar.removeAttr("style");
	cropProgressBar.css("width", progressBar.width());
	
	var targets = $(".h-target");
	targets.css("width", TARGET_WIDTH);
	targets.css("height", TARGET_HEIGHT);
	targets.css("top", 100);
	targets.eq(0).css("left", (deviceWidth/2) - 100 - (TARGET_WIDTH/2));
	targets.eq(1).css("left", (deviceWidth/2) - (TARGET_WIDTH/2));
	targets.eq(2).css("left", (deviceWidth/2) + 100 - (TARGET_WIDTH/2));
	
	var items = $(".h-itembar-item");
	items.css("height", items.width());
}

function doHelpExit(tg){
	startAudio(btnClickSound);
	$(".help").removeClass("on");
	$(".help .h-wrap-fg").removeClass("on");
	$(".help .explain-obj").removeClass("on");
}

function doExplain(isStart){
	startAudio(btnClickSound);
	
	var help = $(".help");
	var explainObj = $(".explain-obj");
	
	explainObj.removeClass("explain-obj");
	
	if(isStart){
		tabNumber = 0;
	} else{
		tabNumber += 1;
	}
	
	switch(tabNumber){
	case 0: explainLayout0();break;
	case 1: explainLayout1();break;
	case 2: explainLayout2();break;
	default : doHelpExit(); break;
	}
	
	function explainLayout0(){
		help.find(".h-progress").addClass("explain-obj");
		help.find(".h-info.h-stage").addClass("explain-obj");
		help.find(".h-info.h-time").addClass("explain-obj");
	}
	
	function explainLayout1(){
		help.find(".h-target").addClass("explain-obj");
	}
	
	function explainLayout2(){
		help.find(".h-itembar .h-itembar-item").addClass("explain-obj");
		help.find(".h-info.h-wrap-coin").addClass("explain-obj");
	}
	
}