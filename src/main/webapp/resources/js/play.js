const TARGET_WIDTH			= 50;		// 타겟 넓이
const TARGET_HEIGHT			= 50;		// 타겟 높이
const HIDDEN_PADDING		= 50;		// 숨겨진 공간
const RIGHT_ANGLE 			= 90;
const RECOVERY_DEGREE   	= 10;     // 체력 회복 수치
const FULL_LIFE				= 100;

const ITEM_COST_LIME = 10;	// 파워 아이템 비용
const ITEM_COST_SPRAY = 50;	// 스프레이 아이템 비용
const ITEM_COST_HEART = 20;

const COMBO_COIN 			= 2;

const TARGET_NORMAL			= "normal";
const TARGET_WARNING 		= "warning";
const TARGET_GOLD	 		= "gold";


const TARGET_NORMAL_COIN	= 1;
const TARGET_NORMAL_RECOVERY= 5;
const TARGET_WARNING_DAMEAGE= -50;
const TARGET_GOLD_COIN		= 10;


const MAX_GOLD_TARGET		= 2;

const LEVEL_CONFIG =[
	{ // level1
		maxWarningTarget: 2,
		maxNormalTarget : 30,
		maxTime			: 50,
		targetMoveSpeed	: 60,
		lifeDecreaseRate: 100
	},
	{ // level2
		maxWarningTarget: 4,
		maxNormalTarget : 25,
		maxTime			: 100,
		targetMoveSpeed	: 50,
		lifeDecreaseRate: 80
	},
	{ // level3
		maxWarningTarget: 7,
		maxNormalTarget : 15,
		maxTime			: 150,
		targetMoveSpeed	: 40,
		lifeDecreaseRate: 60
	},
	{ // level4
		maxWarningTarget: 10,
		maxNormalTarget : 15,
		maxTime			: 200,
		targetMoveSpeed	: 30,
		lifeDecreaseRate: 50
	}
]


var startX;
var startY;
var endX;
var endY;

var level				= 0;
var config				= undefined;
var time				= 0;
var targetMakeRate 		= 500; 	// 타겟이 생성되는 간격 , 1000 = 1초
var wariningTargetRate  = 0.3;  // Warning 타겟이 생성되는 확률
var goldTargetRate  	= 0.01;  // 골드 타겟이 생성되는 확률
var totalCoin           = 0;    // 코인 숫자
var makeTargetThread;
var checkTargetThread;
var fallingSpeedUpThread;
var makeFeverTargetThread;
var timeThread;
var warningBackgroundChange;
var moveDistance 		= 10;
var feverTargetTouchCount= 0; 	// 보스 타겟 터치 카운트

// targeting 범위
var attackAreaWidth 	= 150;
var attackAreaHeight    = 150;

//배경음악
var backgroundAudio; // 노말 배경 음악

// 효과음
var removeSound; // 클릭시 소리
var itemSound;	// 아이템 소리

// 체력
var life = FULL_LIFE;
var lifeDecreaseThread;


// 타겟 삭제 - 공격당했을때
function doAttackTarget(target){
	var target = $(target);
	
	if(!target.hasClass("died")){
		if(target.hasClass(TARGET_WARNING)){
			lifeRecovery(TARGET_WARNING_DAMEAGE);
			removeTarget(target,true);
		} else if (target.hasClass(TARGET_GOLD)){
			makeCoin(TARGET_GOLD_COIN);
			removeTarget(target,true);
		} else{ // 노말 타겟인 경우
			lifeRecovery(TARGET_NORMAL_RECOVERY);
			makeCoin(TARGET_NORMAL_COIN);
			removeTarget(target,true);
		}
		
		target.addClass("died");
	}
}

function removeTarget(target, doEffect){
	if(doEffect){ // 소리, 제거 효과
		startAudio(removeSound);			
		removeSound.currentTime = 0;
		target.removeClass('limit');
		target.addClass('removed'); // 이미지 변경
		target.find(".toLeftDistance").val(0);
		target.find(".toTopDistance").val(5);
		setTimeout(function(){
			target.remove();
		}, 300); 
	} else{
		target.remove();
	}
	
	var moveTargetThreadID = target.find(".moveTargetThreadID").val();
	clearTimeout(moveTargetThreadID); // 쓰레드종료
}

// 모든 타겟 삭제
function removeAllTarget(targetType, doEffect) {
	var targets = $(targetType);
	targets.each(function(){
		removeTarget($(this), doEffect);
	});
}

// 체력 회복
function lifeRecovery(recover) {
	life += recover;
	if(life > FULL_LIFE) {life = FULL_LIFE;}
	$(".wrap-life-progress .progress-bar").stop();
	$(".wrap-life-progress .progress-bar").css("width", life + "%");
}

function usingItem(itemId){
	var coin = $(".coin");
	var coinNumber = parseInt(coin.text(), 10);
	var duration = 3000; //아이템 지속 시간
	
	startAudio(itemSound);		
	
	switch(itemId){
	case 0 : doSetLime();break;
	case 1 : doUsingSpray(); break;
	case 2 : doRecoveryHeart(); break;
	case 3 : doChangemoveSpeed(duration); break;
	}
	
	function doSetLime(){
		console.log("끈끈이 설치!");
		decreaseCoin(ITEM_COST_LIME); //코인 감소
	}
	
	function doUsingSpray(){
		if(coinNumber >= ITEM_COST_SPRAY){//가지고 있는 코인이 아이템 비용보다 높다면
			$(".effect.spray").addClass("on");
			setTimeout(function() {
				$(".effect.spray").removeClass("on");
			}, 1000)
			removeAllTarget(".target", true)// 모든 타겟 삭제
			decreaseCoin(ITEM_COST_SPRAY); //코인 감소
		}
	}
	
	function doRecoveryHeart(){
		if(coinNumber >= ITEM_COST_HEART){ //가지고 있는 코인이 아이템 비용보다 높다면
			$(".effect.heart").addClass("on");
			setTimeout(function() {
				$(".effect.heart").removeClass("on");
			}, 1000)
			
			lifeRecovery(30);
			decreaseCoin(ITEM_COST_HEART); //코인 감소
		}	
	}
	
	function doChangemoveSpeed(duration) {
		targetMoveSpeed = targetMoveSpeed - 40;
		setTimeout(function() {
			targetMoveSpeed = targetMoveSpeed + 40;
		}, duration)
		
	}
}


// 음악 시작
function startAudio(playtimeType){  
	if($(".bgm-source-board").attr('data-click-state') == 1){ // 지금 정지 중이라면
		playtimeType.play(); 
		playtimeType.volume = 0.0;
	}
	else { // 지금 재생중이라면
		playtimeType.play(); 
		playtimeType.volume = 0.5;
	}
	
}

// 음악 정지
function stopAudio(playtimeType){ 
	playtimeType.pause(); 
}

// 타겟을 만들어 떨어트림
function makeTarget(){
	var playGround = $(".play-ground");
	var target = $("<div>", {"class" : "target"});
	var targetType = randTargetType();
	
	function randTargetType(){
		var rand = Math.random();
		if(rand < wariningTargetRate) { // warningTarget이 만들어질 확률
			if($(".target" + "." + TARGET_WARNING).length >= config.maxWarningTarget){
				return randTargetType();
			}
			return TARGET_WARNING;
		} else if(rand < wariningTargetRate + goldTargetRate && rand > wariningTargetRate){
			if($(".target" + "." + TARGET_GOLD).length >= MAX_GOLD_TARGET){
				return randTargetType();
			}
			return TARGET_GOLD;
		} else {
			if($(".target" + "." + TARGET_NORMAL).length >= config.maxNormalTarget){
				return undefined;
			}
			return TARGET_NORMAL;
		}
	}
	
	if(!targetType){
		return ;
	}
	
	target.addClass(targetType);
	target.append($("<div>", {"class" : "target-icon"}));
	target.append($("<input>", {"class" : "moveTargetThreadID", type : "hidden"}));
	target.append($("<input>", {"class" : "angle", type : "hidden"}));
	target.append($("<input>", {"class" : "toLeftDistance", type : "hidden"}));
	target.append($("<input>", {"class" : "toTopDistance", type : "hidden"}));
	
	target.appendTo(playGround);
	target.css("width", TARGET_WIDTH);
	target.css("height", TARGET_HEIGHT);
	
	// 벌레가 나오는 위치 선정
	var startLine = Math.floor(Math.random() * 4);
	var left = 0;
	var top	 = 0;
	var angle = 0;
	
	switch(startLine){
	case 0:// 왼쪽, 상하랜덤
		left	= startX - HIDDEN_PADDING;
		top 	=  Math.random() * ((endY - TARGET_HEIGHT) - startY) + startY;
		angle 	= 90;
		break;
	case 1:// 오른쪽, 상하랜덤
		left	= endX - TARGET_WIDTH + HIDDEN_PADDING; 
		top 	=  Math.random() * ((endY - TARGET_HEIGHT) - startY) + startY;
		angle 	= 270;
		break;
	case 2:// 위쪽, 좌우랜덤
		left	=  Math.random() * ((endX - TARGET_WIDTH) - startX) + startX;
		top 	= startY - HIDDEN_PADDING;
		angle 	= 180;
		break;
	case 3:// 아래쪽, 좌우랜덤
		left	=  Math.random() * ((endX - TARGET_WIDTH) - startX) + startX;
		top 	= endY - TARGET_HEIGHT + HIDDEN_PADDING;
		angle 	= 0;
		break;
	}
	
	target.css("left", left);
	target.css("top", top);

	randAngle(target);
	function randAngle(target){
		var currentAngle = 	target.find(".angle").val();
		var angle 	= (Math.floor(Math.random() * 90) + currentAngle) % 360;
		var tangent	=  Math.abs(Math.tan(angle * (3.14/180)).toFixed(2)) ;
		var toLeftDistance;
		var toTopDistance;
		
		// x + , y +
		if(angle == 0){
			toLeftDistance = 0;
			toTopDistance = moveDistance * -1;
		}
		
		if(angle > 0 &&  angle < 1 * RIGHT_ANGLE){
			// left, top 양수
			toLeftDistance = moveDistance;
			toTopDistance = tangent * moveDistance * -1;
			angle = 1 * RIGHT_ANGLE - angle;
		}
		
		if(angle == 1 * RIGHT_ANGLE){
			toLeftDistance = moveDistance;
			toTopDistance = 0;
		}
		
		// x + , y -
		if(angle > 1 * RIGHT_ANGLE && angle < 2 * RIGHT_ANGLE ){
			// left 양수, top 음수
			toLeftDistance = moveDistance;
			toTopDistance = tangent * -1 * moveDistance * -1;
			angle = 1 * RIGHT_ANGLE + (RIGHT_ANGLE - angle % RIGHT_ANGLE);
		}
		
		if(angle == 2 * RIGHT_ANGLE){
			toLeftDistance = 0;
			toTopDistance = moveDistance;
		}
		
		// x - , y -
		if(angle > 2 * RIGHT_ANGLE && angle < 3 * RIGHT_ANGLE){
			// left 음수, top 음수
			toLeftDistance = -1 * moveDistance;
			toTopDistance = tangent * -1 * moveDistance * -1;
			angle = 2 * RIGHT_ANGLE + (RIGHT_ANGLE - angle % RIGHT_ANGLE);
		}
		
		if(angle == 3 * RIGHT_ANGLE){
			toLeftDistance = moveDistance * -1;
			toTopDistance = 0;
		}
		
		// x - , y +
		if(angle > 3 * RIGHT_ANGLE && angle < 4 * RIGHT_ANGLE){
			// left 음수, top 양수
			toLeftDistance = -1 * moveDistance;
			toTopDistance = tangent * moveDistance * -1;
			angle = 3 * RIGHT_ANGLE + (RIGHT_ANGLE - angle % RIGHT_ANGLE);
		}
		
		if(Math.abs(toTopDistance) > moveDistance){
			var ratio = Math.abs(toTopDistance/moveDistance); 
			toTopDistance = 10 * Math.sign(toTopDistance);
			toLeftDistance /= ratio; 
		}
		
		target.css("transform", "rotate(" + angle + "deg)");
		
		target.find(".angle").val(angle);
		target.find(".toLeftDistance").val(toLeftDistance);
		target.find(".toTopDistance").val(toTopDistance);
	}
	
	moveTarget(target);
	function moveTarget(target){
		var left= parseInt(target.css("left"));
		var top = parseInt(target.css("top"));
		var toLeftDistance = parseInt(target.find(".toLeftDistance").val());
		var toTopDistance = parseInt(target.find(".toTopDistance").val());
		
		left= left + toLeftDistance;
		top = top + toTopDistance;
		
		// 범위를 넘어간경우
		if(left < (startX - HIDDEN_PADDING)
				|| left > (endX - TARGET_WIDTH + HIDDEN_PADDING)
				|| top < (startY - HIDDEN_PADDING)
				|| top > (endY - TARGET_HEIGHT + HIDDEN_PADDING)) {
			var moveTargetThreadID = target.find(".moveTargetThreadID").val();
			
			randAngle(target);
		}  else{
			target.css("left", left);
			target.css("top", top);
		}
		
		// 재귀를 이용한 Interval
		var moveTargetThread = setTimeout(function(){ moveTarget(target)}, config.targetMoveSpeed);
		target.find(".moveTargetThreadID").val(moveTargetThread); 
	}
	
}

// 게임 오버
function gameover() {
	removeAllTarget(".target", false)// 모든 타겟 삭제
	stopPlayNormalTime();
	
	$(".wrap-fg").addClass("on");
	$(".wrap-gameover").addClass("on");
}


// 돈 증가
function makeCoin(coin) {
	totalCoin = totalCoin + coin;
	drawCoin(totalCoin);
	checkItemCost();
}

// 돈 감소
function decreaseCoin(coin) {
	totalCoin = totalCoin - coin;
	drawCoin(totalCoin);
	checkItemCost();
}

// 돈 초기화
function initCoin(){
	totalCoin = 0;
	drawCoin(totalCoin);
	checkItemCost();
}

function drawCoin(coin){
	$(".coin").text(coin);
}

// 아이템 활성화 체크
function checkItemCost(){
	if(totalCoin >= ITEM_COST_SPRAY){ $(".spray-item .overlay-item").removeClass("on"); }
	else { $(".spray-item .overlay-item").addClass("on"); }

	if(totalCoin >= ITEM_COST_LIME){ $(".lime-item .overlay-item").removeClass("on"); }
	else { $(".lime-item .overlay-item").addClass("on"); }
	
	if(totalCoin >= ITEM_COST_HEART){ $(".heart-item .overlay-item").removeClass("on"); }
	else { $(".heart-item .overlay-item").addClass("on"); }
}


/** ** ========== 플레이 타임에 시작/정지 로직 =================== * */

function startPlayNormalTime(){
	startAudio(backgroundAudio); // 보스 타임 백그라운드 음악 제거
	
	config = LEVEL_CONFIG[level];
	startTime();
	startMakeTarget(); // 타겟 생성 쓰레드
	startLifeDecrease(); // 생명력 감소 스레드 시작
	warningBackgroundChange = undefined; // 생명력 경고 쓰레드 초기화
}

function stopPlayNormalTime(){
	removeAllTarget(".target", false)// 모든 타겟 삭제
	stopAudio(backgroundAudio);
	
	stopTime();
	stopMakeTarget();
	stopLifeDecrease();
	stopWarningBackgroundChange();
}

/** ============================================================================== * */

function startTime(){
	timeThread = setInterval(function(){
		time += 0.01;
		$(".time-board .time").text(time.toFixed(2));
		if(time >= config.maxTime){
			stopPlayNormalTime();
			setTimeout(function(){
				level += 1;
				startPlayNormalTime();
			}, 1000);
		}
	}, 100);
}

function stopTime(){
	clearInterval(timeThread);
}

// 타겟 생성 스레드
function startMakeTarget() { // 재귀를 이용한 Interval
	makeTarget();
	makeTargetThread = setTimeout(startMakeTarget, targetMakeRate);
}

// 타겟 생성 스레드 정지
function stopMakeTarget() {
	clearTimeout(makeTargetThread);
	makeTargetThread = undefined; // 쓰레드 변수 초기화
}

// 체력 감소 스레드 시작
function startLifeDecrease() { // 재귀를 이용한 Interval
	life = life - 0.5;
	if(life < 0){
		gameover();
		lifeDecreaseThread = undefined;
	} else {
		if(life <= FULL_LIFE/3 && warningBackgroundChange == undefined){ // 체력이 일정수준 이하로 감소했을때 
			startWarningBackgroundChange();
		} else if(life > FULL_LIFE/3 && warningBackgroundChange != undefined){
			stopWarningBackgroundChange();
		}
		
		$(".wrap-life-progress .progress-bar").stop().animate({"width" : life + "%"});
		lifeDecreaseThread = setTimeout(startLifeDecrease, config.lifeDecreaseRate);
	}
}

//체력 감소 스레드 중지
function stopLifeDecrease(){
	clearTimeout(lifeDecreaseThread);
	lifeDecreaseThread = undefined;
}

// 경고 백그라운드 스레드 시작
function startWarningBackgroundChange(){
	if(warningBackgroundChange == undefined){
		warningBackgroundChange = setInterval(function(){
			var playGround = $('.play-ground');			
			if(playGround.css("background-color") == "rgba(0, 0, 0, 0)"){ // 배경색 변경
				playGround.css("background-color","red");		
			} else {
				playGround.css("background-color","rgba(0, 0, 0, 0)");	
			}
		}, '200');
	}	
}

// 경고 백그라운드 스레드 중지
function stopWarningBackgroundChange(){
	clearTimeout(warningBackgroundChange);
	warningBackgroundChange = undefined; // 쓰레드 변수 초기화
}


$(document).ready(function(){
	var attacker = $(".attacker");
	attacker.css("width", attackAreaWidth);
	attacker.css("height", attackAreaHeight);
	
	$(".coin").text(totalCoin);
	
	
	// 초기화 (좌표)
	initXY();
	function initXY(){
		var playGround = $(".play-ground");
		startX 	= 0 - HIDDEN_PADDING;
		startY	= 0 - HIDDEN_PADDING;
		endX	= playGround.width() + HIDDEN_PADDING;
		endY	= playGround.height() + HIDDEN_PADDING;
	}
	
	initAudio();
	function initAudio(){
		// 노말 타임 백그라운드 음악
		backgroundAudio = new Audio(getContextPath() + '/resources/audio/sample_bgm.mp3');
		// 피버 타임 백그라운드 음악
		feverTimeBackgroundAudio = new Audio(getContextPath() + '/resources/audio/sample_fever_bgm.mp3');
		// 제거 소리
		removeSound = new Audio();
		removeSound.src = getContextPath() + "/resources/audio/sample_remove_sound.wav";
		removeSound.preLoad = true;
		removeSound.controls = true;
		removeSound.autoPlay = false;
		// 아이템 사용 소리
		itemSound = new Audio();
		itemSound.src = getContextPath() + "/resources/audio/sample_item.wav";
		itemSound.preLoad = true;
		itemSound.controls = true;
		itemSound.autoPlay = false;
	}
	
	// 아이템 비용 표시
	initItemCost();
	function initItemCost(){
		$(".lime-item-cost").text(ITEM_COST_LIME);
		$(".spray-item-cost").text(ITEM_COST_SPRAY);
		$(".heart-item-cost").text(ITEM_COST_HEART);
	}
	
	// 화면 클릭 이벤트
	 $(".play-ground").on("click",function(e) {
		var attacker = $(".attacker");
		attacker.addClass("on");
		
    	var x = e.pageX - $(".play-ground").offset().left;
    	var y = e.pageY - $(".play-ground").offset().top;
    	
    	var attackStartX = x - (attackAreaWidth/2);
    	var attackStartY = y - (attackAreaHeight/2);
    	var attackEndX = x + (attackAreaWidth/2);
    	var attackEndY = y + (attackAreaHeight/2);
    	
    	attacker.css("left", attackStartX);
    	attacker.css("top", attackStartY);
    	setTimeout(function(){attacker.removeClass("on")}, 100);
			        
    	var attackedTargetNumber = 0;
    	
		var targets = $(".target");
		var checkComboflag = true;
		targets.each(function(){
			var targetStartX= parseInt($(this).css("left"));
			var targetStartY= parseInt($(this).css("top"));
			var targetEndX	= targetStartX + TARGET_WIDTH;
			var targetEndY 	= targetStartY + TARGET_HEIGHT;
    		var attacked	= false;
			
    		//case1 왼쪽에 벌레가 걸쳤다.
			if(targetEndX > attackStartX 
					&& targetEndX < attackEndX
					&& targetStartY > attackStartY
					&& targetEndY < attackEndY){
				attacked = true;
			}
			
			//case2 오른쪽에 벌레가 걸쳤다.
			if(targetStartX < attackEndX 
					&& targetStartX > attackStartX
					&& targetStartY > attackStartY
					&& targetEndY < attackEndY){
				attacked = true;
			}
			
			//case3 위쪽에 벌레가 걸쳤다.
			if(targetStartX > attackStartX 
					&& targetEndX < attackEndX
					&& targetEndY > attackStartY
					&& targetEndY < attackEndY){
				attacked = true;
			}
			
			//case4 아래쪽에 벌레가 걸쳤다.
			if(targetStartX > attackStartX 
					&& targetEndX < attackEndX
					&& targetStartY < attackEndY
					&& targetStartY > attackStartY){
				attacked = true;
			}
			
			
			if(attacked){
				if(!$(this).hasClass(TARGET_WARNING)){
					attackedTargetNumber = attackedTargetNumber+1;
				}
				doAttackTarget(this);
			}
			
		}); 
    		
		checkCombo();
		function checkCombo(){ // 콤보 수 확인
			if(attackedTargetNumber >= 2){
				var comboMessage = $(".combo-message");
				comboMessage.css("left", attackStartX);
				comboMessage.css("top", attackStartY);
				comboMessage.find(".combo-count").text(attackedTargetNumber);
			
				setTimeout(function(){comboMessage.addClass("on");}, 100);
				setTimeout(function(){comboMessage.removeClass("on");}, 1000);
				
				makeCoin(COMBO_COIN * attackedTargetNumber);
			}
		}
    });

	// 오디오 버튼 활성화 , 비활성화, 이거는 첫화면에 있어야하는듯? (-이찬구)
//	$(".bgm-source-board").on("click",function(e) {
//		
//		var audio;
//		
//		switch(timeType){
//		case PLAYTIME_NORMAL :
//			audio = backgroundAudio;
//			break;	
//		case PLAYTIME_FEVER : 
//			audio = feverTimeBackgroundAudio;
//			break;
//		}
//		
//		if($(this).attr('data-click-state') == 1) {
//			$(this).attr('data-click-state', 0);
//			startAudio(audio);			
//			$(".bgm-source-board").css({"background":"url(resources/image/sample_start_audio.png", 'background-repeat' : 'no-repeat', 'background-size' : 'contain'});} 
//		else {
//			$(this).attr('data-click-state', 1);		
//			stopAudio(audio);			
//			$(".bgm-source-board").css({"background":"url(resources/image/sample_stop_audio.png", 'background-repeat' : 'no-repeat' ,'background-size' : 'contain'});
//		}
//	});
			
	 startPlayNormalTime();
})
		
	
