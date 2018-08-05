var clickBlock = false;

function timeoutSetBlockFalse() {
	setTimeout(function (){
		clickBlock = false;
	}, 500);
}

function redrawToHome(){
	$(".intro").addClass("on");
	$(".play").removeClass("on");
	$(".play > .wrap").removeClass("on");
	$(".play .itembar-item .icon-on").removeClass("on");
}

function redrawToPlay(){
	$(".intro").removeClass("on");
	$(".play").addClass("on");
	$(".play > .wrap").removeClass("on");
	$(".play .itembar-item .icon-on").removeClass("on");
}

$(window).on("load", function(){
	$(".splash").removeClass("on");
});