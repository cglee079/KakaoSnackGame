var tabNumber = 0;

$(window).resize(function(){
	initHelp();
});

$(document).ready(function(){
	$(".h-wrap-fg").touchwipe({
		wipeLeft: function() { 
	    	startAudio(btnClickSound);
			tabNumber += 1;
			if(tabNumber > 2) {
				helpExit();
			} else{
				explain();
			}
    	},
	    wipeRight: function() {
	    	startAudio(btnClickSound);
	    	
			tabNumber -= 1; 
			if(tabNumber < 0) {
				helpExit();
			} else{
				explain();
			}
	    },
	    min_move_x: 20,
	    min_move_y: 20,
	    preventDefaultEvents: true
	});
})

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
	
	var items = $(".h-itembar-item");
	items.css("height", items.width());
	
	var lime = $(".h-itembar .h-itembar-item.h-lime-item");
	var expLime = $(".h-wrap-fg .h-wrap-exp.h-exp-3 .h-exp-lime");
	expLime.css("left", parseInt(lime.offset().left) - parseInt(lime.width()) + 5);
	expLime.css("top", parseInt(lime.offset().top)  - parseInt(lime.height()) + 20);
	
	var portion = $(".h-itembar .h-itembar-item.h-portion-item");
	var expPortion = $(".h-wrap-fg .h-wrap-exp.h-exp-3 .h-exp-portion");
	expPortion.css("left", parseInt(portion.offset().left) - 35);
	expPortion.css("top", parseInt(portion.offset().top) - parseInt(portion.height()) + 23);
	
	var spray = $(".h-itembar .h-itembar-item.h-spray-item");
	var expSpray = $(".h-wrap-fg .h-wrap-exp.h-exp-3 .h-exp-spray");
	expSpray.css("left", parseInt(spray.offset().left) - 17);
	expSpray.css("top", parseInt(spray.offset().top) - parseInt(spray.height()) + 6);
	
	var wrapCoin = $(".h-info.h-wrap-coin");
	
	var mortionCoin = $(".h-wrap-fg .h-wrap-exp.h-exp-3 .h-coin-mortion");
	mortionCoin.css("left", parseInt(wrapCoin.offset().left) + 45);
	mortionCoin.css("top", parseInt(wrapCoin.offset().top) + parseInt(wrapCoin.height()));
}

function doHelpExit(tg){
	startAudio(btnClickSound);
	helpExit();
}

function helpExit(){
	$(".help").removeClass("on");
	$(".help .h-wrap-fg").removeClass("on");
	$(".help .explain-obj").removeClass("on");
}

function doExplain(isStart){
	startAudio(btnClickSound);
	
	if(isStart){
		tabNumber = 0;
	} else{
		tabNumber += 1;
	}
	
	explain();
}

function explain(){
	var help = $(".help");
	var explainObj = $(".exp");
	
	explainObj.removeClass("exp");
	$(".help .h-tab-status .h-value").removeClass("on");
	$(".help .h-tab-status .h-value").eq(tabNumber).addClass("on");
	
	switch(tabNumber){
	case 0: explainLayout0();break;
	case 1: explainLayout1();break;
	case 2: explainLayout2();break;
	default : doHelpExit(); break;
	}
	
	function explainLayout0(){
		help.find(".h-progress").addClass("exp");
		help.find(".h-wrap-fg .h-wrap-exp.h-exp-1").addClass("exp");
		help.find(".h-icon-bugs").addClass("on");
	}
	
	function explainLayout1(){
		help.find(".h-wrap-fg .h-wrap-exp.h-exp-2").addClass("exp");
		help.find(".h-icon-bugs").removeClass("on");
	}
	
	function explainLayout2(){
		help.find(".h-itembar .h-itembar-item").addClass("exp");
		help.find(".h-info.h-wrap-coin").addClass("exp");
		help.find(".h-wrap-fg .h-wrap-exp.h-exp-3").addClass("exp");
	}
}