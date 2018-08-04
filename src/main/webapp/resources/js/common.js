function redrawToHome(){
	$(".intro").addClass("on");
	$(".play").removeClass("on");
	$(".play > .wrap").removeClass("on");
}

function redrawToPlay(){
	$(".intro").removeClass("on");
	$(".play").addClass("on");
	$(".play > .wrap").removeClass("on");
}

$(window).on("load", function(){
	$(".splash").removeClass("on");
});