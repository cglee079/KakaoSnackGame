var bgm = undefined;
var sound = "on";
var soundMapTimout = {};

function setBGM(src){
	bgm = new Howl({
		"src"	: [src],
		"loop"	: "true",
		"preload": "true",
		"html5"	: "false",
		"volume": 1
	});
}

function doSoundOn(){
	sound = "on";
}

function doSoundOff(){
	sound = "off";
}

function startBGM(){
	if(sound == "on"){
		bgm.play();
	}
}

function stopBGM(){
	bgm.stop();
}


/*
 * 모바일상에서 play시 딜레이가 발생하여 재생되는 에러 확인
 * 오버플로우에서 검색하였는데 해결방법으로
 * 루프 무한으로 걸고, 볼륨을 조절하는 방식을 권장함.
 * timeout으로 재생후 볼륨 0으로 하엿는데, 타임아웃이 중복되어 소리가 안나는 경우가있어
 * src를 key값으로 맵에다 넣어서 조작함.
 */
function startAudio(howl){  
	if(sound == "on"){
		howl.play();
	}
}

// 음악 정지
function stopAudio(playtimeType){ 
	howl.pause();
}

//사운드 정의
function makeSound(src){
	var howl = new Howl({
		"src": [src],
		"preload": "true",
		"html5"	: "false",
		"volume": 1
	});
	return howl;
}
