//효과음
var attackSound; // 공격시 소리
var heartItemSound;	// 체력회복 아이템 소리
var sprayItemSound; // 스프레이 아이템 소리
var sprayItemCompSound;
var limeItemSound; // 끈적이 아이템 소리
var coinSound;     // 동전 소리
var multiCoinSound;// 많은 동전 소리
var wrongAttackSound; // 잘못된 공격 소리
var stageupSound;
var gameoverSound;
var comboSound;
var btnClickSound;

var bgm = undefined;
var sound = "on";

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

function restartBGM(){
	stopBGM();
	startBGM();
}

function startAudio(howl){  
	if(sound == "on"){
		if(howl.isPlaying){howl.stop();}
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

$(document).ready( function() {
	setBGM(getContextPath() + '/resources/audio/bgm.mp3');
	doSoundOn();

	attackSound 		= makeSound(getContextPath() + "/resources/audio/play/sound_play_attack.mp3");
	wrongAttackSound 	= makeSound(getContextPath() + "/resources/audio/play/sound_play_wrong_attack.mp3");
	heartItemSound 		= makeSound(getContextPath() + "/resources/audio/play/sound_play_item_portion.wav");
	sprayItemSound 		= makeSound(getContextPath() + "/resources/audio/play/sound_play_item_spray.mp3");
	sprayItemCompSound 	= makeSound(getContextPath() + "/resources/audio/play/sound_play_item_spray_complete.mp3");
	limeItemSound		= makeSound(getContextPath() + "/resources/audio/play/sound_play_item_lime.mp3");
	coinSound 			= makeSound(getContextPath() + "/resources/audio/play/sound_play_money.mp3");
	multiCoinSound 		= makeSound(getContextPath() + "/resources/audio/play/sound_play_multi_money.mp3");
	warningSound 		= makeSound(getContextPath() + "/resources/audio/play/sound_play_warnig.mp3");
	gameoverSound		= makeSound(getContextPath() + "/resources/audio/play/sound_play_gameover.mp3");
	stageupSound		= makeSound(getContextPath() + "/resources/audio/play/sound_play_stageup.mp3");
	comboSound			= makeSound(getContextPath() + "/resources/audio/play/sound_play_combo.mp3");
	btnClickSound		= makeSound(getContextPath() + "/resources/audio/sound_common_button.mp3");
});

