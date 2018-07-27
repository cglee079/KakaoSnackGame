var bgm = undefined;
var sound = "on";

function setBGM(tg){
	bgm = tg;
}

function doSoundOn(){
	sound = "on";
}

function doSoundOff(){
	sound = "off";
}

function startBGM(){
	startAudio(bgm);
}

function stopBGM(){
	stopAudio(bgm);
}


// 음악 시작
function startAudio(playtimeType){  
	if(sound == "on"){
		playtimeType.play(); 
		playtimeType.volume = 0.5;
	}
}

// 음악 정지
function stopAudio(playtimeType){ 
	playtimeType.pause(); 
}

//사운드 정의
function makeSound(src){
	var sound = new Audio();
	sound.src = src;
	sound.preLoad = true;
	sound.controls = true;
	sound.autoPlay = false;
	
	return sound;
}
