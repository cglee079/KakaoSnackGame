var bgm = undefined;
var sound = "on";
var soundMapTimout = {};

function setBGM(tg){
	bgm = tg;
	bgm.preLoad 	= true;
	bgm.controls 	= true;
	bgm.loop		= true;
	bgm.autoPlay 	= true;
	bgm.volume		= 0;
	bgm.play();
}

function doSoundOn(){
	sound = "on";
}

function doSoundOff(){
	sound = "off";
}

function startBGM(){
	if(sound == "on"){
		bgm.volume = 1;
	}
}

function stopBGM(){
	bgm.volume = 0;
}


/*
 * 모바일상에서 play시 딜레이가 발생하여 재생되는 에러 확인
 * 오버플로우에서 검색하였는데 해결방법으로
 * 루프 무한으로 걸고, 볼륨을 조절하는 방식을 권장함.
 * timeout으로 재생후 볼륨 0으로 하엿는데, 타임아웃이 중복되어 소리가 안나는 경우가있어
 * src를 key값으로 맵에다 넣어서 조작함.
 */
function startAudio(playtimeType){  
	if(sound == "on"){
		if(soundMapTimout[playtimeType.src]) {
			clearTimeout(soundMapTimout[playtimeType.src]);
		}
		
		playtimeType.currentTime = 0; 
		playtimeType.volume = 1;
		
		var timeoutID = setTimeout(function(){
			playtimeType.volume = 0;
		}, playtimeType.duration * 1000);
		
		soundMapTimout[playtimeType.src] = timeoutID;
	}
}

// 음악 정지
function stopAudio(playtimeType){ 
	playtimeType.pause(); 
}

//사운드 정의
function makeSound(src){
	var sound = new Audio();
	sound.src 		= src;
	sound.preLoad 	= true;
	sound.controls 	= true;
	sound.loop		= true;
	sound.autoPlay 	= true;
	sound.volume = 0;
	sound.play();
	return sound;
}
