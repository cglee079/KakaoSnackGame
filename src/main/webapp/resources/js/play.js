const ATTACKER_HEIGHT    	= deviceHeight * (3/10);
const ATTACKER_WIDTH 		= ATTACKER_HEIGHT * (1/2); //width : height = 1 : 2;
const TARGET_WIDTH			= deviceHeight * (1/18);	// 타겟 넓이
const TARGET_HEIGHT			= deviceHeight * (1/18);	// 타겟 높이
const HIDDEN_PADDING		= deviceHeight * (1/18);	// 숨겨진 공간
const RIGHT_ANGLE 			= 90;
const RECOVERY_DEGREE   	= 10;   // 체력 회복 수치
const FULL_LIFE				= 90;	// 사과땜에 가려저셔 90으로바꿈..
const COMBO_COIN 			= 2;

const ITEM_COST_LIME 		= 20;	// 파워 아이템 비용
const ITEM_COST_HEART 		= 50;
const ITEM_COST_SPRAY 		= 100;	// 스프레이 아이템 비용

const TARGET_NORMAL			= "normal";
const TARGET_WARNING 		= "warning";
const TARGET_GOLD	 		= "gold";

const TARGET_NORMAL_COIN	= 1;
const TARGET_NORMAL_RECOVERY= 5;
const TARGET_WARNING_DAMEAGE= -40;
const TARGET_GOLD_COIN		= 10;
const ITEM_LIME_WIDTH		= 250;
const ITEM_LIME_HEIGHT		= 250;
const MAX_GOLD_TARGET		= 100;

const TARGET_MAKE_SPEED 		= 300; 		// 타겟이 생성되는 간격 , 1000 = 1초
const WARNING_TARGET_MAKE_RATE  = 0.3;  	// Warning 타겟이 생성되는 확률
const GOLD_TARGKET_MAKE_RATE  	= 0.02;  	// 골드 타겟이 생성되는 확률
const TARGET_MOVE_DISTANCE 		= 10;

const LEVEL_CONFIG =[
	{ // level1
		maxWarningTarget: 3,
		maxNormalTarget : 17,
		maxTime			: 30,
		targetMoveSpeed	: 60,
		lifeDecreaseRate: 100
	},
	{ // level2
		maxWarningTarget: 5,
		maxNormalTarget : 15,
		maxTime			: 60,
		targetMoveSpeed	: 50,
		lifeDecreaseRate: 80
	},
	{ // level3
		maxWarningTarget: 7,
		maxNormalTarget : 13,
		maxTime			: 90,
		targetMoveSpeed	: 40,
		lifeDecreaseRate: 60
	},
	{ // level4
		maxWarningTarget: 10,
		maxNormalTarget : 10,
		maxTime			: 999999,
		targetMoveSpeed	: 30,
		lifeDecreaseRate: 50
	}
]

var life;
var startX;
var startY;
var endX;
var endY;
var level;
var config;	
var time;
var totalCoin;    // 코인 숫자

// 쓰레드
var makeTargetThread;
var timeWorker = new Worker( getContextPath() + '/resources/js/worker/timeWorker.js' );
var warnigLifeThread;
var lifeDecreaseThread;
var moveTargetThread;


function removeTarget(target, doEffect){
	 
	if(doEffect){ // 소리, 제거 효과
		if(target.hasClass(TARGET_WARNING)) {
			startAudio(wrongAttackSound);
		} else if (target.hasClass(TARGET_GOLD)){
			startAudio(coinSound);
		} 
		
		var duration = 500;
		if(target.hasClass(TARGET_GOLD)){
			duration = 1000;
		}
		
		setTimeout(function(){
			target.remove();
		}, duration); 
	} else{
		target.remove();
	}
}

function removeSomeTarget(targets, doEffect){
	targets.each(function(){
		removeTarget($(this), doEffect);
	})
}

// 체력 회복
function lifeRecovery(recover) {
	life += recover;
	if(life > FULL_LIFE) {life = FULL_LIFE;}
	$(".progress .progress-bar").stop();
	$(".progress .progress-bar").css("width", life + "%");
}

function usingItem(itemId){
	var coin = $(".info.wrap-coin .value");
	var coinNumber = parseInt(coin.text(), 10);
	
	switch(itemId){
	case 0 : doSetLime();break;
	case 1 : doUsingSpray(); break;
	case 2 : doRecoveryHeart(); break;
	}
	
	function doSetLime(){
		var duration = 3000; // 아이템 지속 시간		
		
		if(coinNumber >= ITEM_COST_LIME){// 가지고 있는 코인이 아이템 비용보다 높다면
			startAudio(limeItemSound);
			
			// 끈끈이 지역
			var stopedTargets = [];
			var limeItemArea = $("<div>", {"class" : "effect lime"});
			limeItemArea.css("width",ITEM_LIME_WIDTH); 
			limeItemArea.css("height", ITEM_LIME_HEIGHT);
			limeItemArea.appendTo($(".play-ground"));
		
			// 랜덤 위치
			var x =  Math.random() * ((endX - ITEM_LIME_WIDTH) - startX) + startX;
	    	var y = Math.random() * ((endY - ITEM_LIME_HEIGHT) - startY) + startY;
	    	
	    	// 끈끈이 위치 지정
	    	limeItemArea.css("left", x);
	    	limeItemArea.css("top", y) ;
	    			
			setTimeout(function() {
				limeItemArea.remove();
			}, duration);
			
			var limeThread = setInterval(function() {
			 	// 끈끈이 범위 X,Y
				var padding = 20;
		    	var limeAreaStartX = x + padding;
		    	var limeAreaStartY = y + padding;
		    	var limeAreaEndX = x + ITEM_LIME_WIDTH - padding;
		    	var limeAreaEndY = y + ITEM_LIME_HEIGHT - padding;
		    
				var targets = $(".target:not(.stoped)");

				// 끈끈이 범위 속하는지 검사 //attacker 로직 동일
				targets.each(function(){
					var targetStartX= parseInt($(this).css("left"));
					var targetStartY= parseInt($(this).css("top"));
					var targetEndX	= targetStartX + TARGET_WIDTH;
					var targetEndY 	= targetStartY + TARGET_HEIGHT;
		    		var catched	= false;
					
					if(targetStartX > limeAreaStartX
							&& targetEndX < limeAreaEndX 
							&& targetStartY > limeAreaStartY
							&& targetEndY < limeAreaEndY){
						catched = true;
					}
					
					// 만약 끈끈이 지역에 속한다면
					if(catched){
						var target = $(this);
						stopMoveTarget(target);
						target.addClass("stoped");
						stopedTargets.push(target);
					}
				}); 			
			}, config.targetMoveSpeed);
			
			// 끈끈이 스레드 정지
			setTimeout(function() {
				// 끈끈이 스레드 초기화
				clearInterval(limeThread);
				limeThread = undefined;

				// 아이템 효과 사라진 후 move 스레드 재시작
				for(var i = 0; i < stopedTargets.length; i++){
					restartMoveTarget(stopedTargets[i]);
					stopedTargets[i].removeClass("stoped");
				}

			}, duration);
			
			decreaseCoin(ITEM_COST_LIME); // 코인 감소
		}
	}
	
	function doUsingSpray(){
		if(coinNumber >= ITEM_COST_SPRAY){// 가지고 있는 코인이 아이템 비용보다 높다면
			startAudio(sprayItemSound);
			stopLifeDecrease();
			stopMakeTarget();
			
			$(".target").addClass("died");
			$(".effect.spray").addClass("on");
			stopMoveTargetThread();
			
			setTimeout(function() {
				$(".effect.spray").removeClass("on");
			}, 1000)
			
			setTimeout(function() {
				removeSomeTarget($(".target"), false);
				
				lifeRecovery(FULL_LIFE)
				startLifeDecrease();
				startMakeTarget();
				startMoveTargetThread();
				startAudio(sprayItemCompSound);
			}, 1500)
			
			decreaseCoin(ITEM_COST_SPRAY); // 코인 감소
		}
	}
	
	function doRecoveryHeart(){
		if(coinNumber >= ITEM_COST_HEART){ // 가지고 있는 코인이 아이템 비용보다 높다면
			
			startAudio(heartItemSound);
			
			$(".progress .crop-progress-bar-overlay").addClass("on");
			$(".progress .progress-portion.effect1").addClass("on");
			setTimeout(function(){ $(".progress .progress-portion.effect2").addClass("on");}, 200);
			setTimeout(function(){ $(".progress .progress-portion.effect3").addClass("on");}, 400);
			
			setTimeout(function() { $(".progress .progress-portion.effect1").removeClass("on");}, 300);
			setTimeout(function() { $(".progress .progress-portion.effect2").removeClass("on");}, 500);
			setTimeout(function() { $(".progress .progress-portion.effect3").removeClass("on");}, 600);
			setTimeout(function() { $(".progress .crop-progress-bar-overlay").removeClass("on");}, 600);
			
			lifeRecovery(30);
			decreaseCoin(ITEM_COST_HEART); // 코인 감소
			
		}	
	}

}



/** ============== 시간 타이머 관련 =========== **/

function startTime(){
	timeWorker.postMessage('start');    // 워커에 메시지를 보낸다.
	timeWorker.onmessage = function( e ) {
		time = e.data;
		$(".info-board-c .info.time .value").text(time.toFixed(2));
		if(time >= config.maxTime && time < config.maxTime + 0.01){
			level += 1;
			removeSomeTarget($(".target"), false);
			$(".effect.lime").remove();
			
			stopPlay();
			stopBGM();
			stageEffectOn();
			setTimeout(function(){
				stageEffectOff();
				startPlay();
				startBGM();
			}, 1500);
		}
  };
}

function stopTime(){
	timeWorker.postMessage('stop');
}

function stageEffectOn(){
	var wrapStageup = $(".wrap-stageup");
	var stages = wrapStageup.find(".value");
	var infoBoardC = $(".info-board-c");
	var stageInfo = infoBoardC.find(".info.stage .value");
	
	startAudio(stageupSound);
	wrapStageup.addClass("on");
	stages.removeClass("on");
	stages.eq(level).addClass("on");
	
	// 스테이지 info board 설정
	stageInfo.removeClass("on");
	stageInfo.eq(level).addClass("on");
}

function stageEffectOff(){
	var wrapStageup = $(".wrap-stageup");
	var bgStage = wrapStageup.find(".bg-stage");
	wrapStageup.removeClass("on");
	bgStage.removeClass("on");
}

/** ============== 타겟 생성, 이동관련 로직 ================= **/

//타겟 생성 스레드
function startMakeTarget() { // 재귀를 이용한 Interval
	makeTarget();
	makeTargetThread = setTimeout(startMakeTarget, TARGET_MAKE_SPEED);
}

// 타겟 생성 스레드 정지
function stopMakeTarget() {
	clearTimeout(makeTargetThread);
	makeTargetThread = undefined; // 쓰레드 변수 초기화
}

// 타겟을 만들어 떨어트림
function makeTarget(){
	var playGround = $(".play-ground");
	var target = $("<div>", {"class" : "target"});
	var targetType = randTargetType();
	
	function randTargetType(){
		var rand = Math.random();
		if(rand < WARNING_TARGET_MAKE_RATE) { // warningTarget이 만들어질 확률
			if($(".target" + "." + TARGET_WARNING).length >= config.maxWarningTarget){
				return randTargetType();
			}
			return TARGET_WARNING;
		} else if(rand < WARNING_TARGET_MAKE_RATE + GOLD_TARGKET_MAKE_RATE && rand > WARNING_TARGET_MAKE_RATE){
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
	if(targetType == TARGET_GOLD) {
		target.append($("<div>", {"class" : "target-icon-bg"}));
	}
	target.append($("<div>", {"class" : "target-icon"}));
	target.append($("<input>", {"class" : "angle", type : "hidden"}));
	target.append($("<input>", {"class" : "toLeftDistance", type : "hidden"}));
	target.append($("<input>", {"class" : "toTopDistance", type : "hidden"}));
	target.append($("<input>", {"class" : "saveToLeftDistance", type : "hidden"}));
	target.append($("<input>", {"class" : "saveToTopDistance", type : "hidden"}));
	
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
}

// 타겟 각도 변경 함수
function randAngle(target){
	var currentAngle = 	target.find(".angle").val();
	var angle 	= (Math.floor(Math.random() * 90) + currentAngle) % 360;
	var tangent	=  Math.abs(Math.tan(angle * (3.14/180)).toFixed(2)) ;
	var toLeftDistance;
	var toTopDistance;
	
	// x + , y +
	if(angle == 0){
		toLeftDistance = 0;
		toTopDistance = TARGET_MOVE_DISTANCE * -1;
	}
	
	if(angle > 0 &&  angle < 1 * RIGHT_ANGLE){
		// left, top 양수
		toLeftDistance = TARGET_MOVE_DISTANCE;
		toTopDistance = tangent * TARGET_MOVE_DISTANCE * -1;
		angle = 1 * RIGHT_ANGLE - angle;
	}
	
	if(angle == 1 * RIGHT_ANGLE){
		toLeftDistance = TARGET_MOVE_DISTANCE;
		toTopDistance = 0;
	}
	
	// x + , y -
	if(angle > 1 * RIGHT_ANGLE && angle < 2 * RIGHT_ANGLE ){
		// left 양수, top 음수
		toLeftDistance = TARGET_MOVE_DISTANCE;
		toTopDistance = tangent * -1 * TARGET_MOVE_DISTANCE * -1;
		angle = 1 * RIGHT_ANGLE + (RIGHT_ANGLE - angle % RIGHT_ANGLE);
	}
	
	if(angle == 2 * RIGHT_ANGLE){
		toLeftDistance = 0;
		toTopDistance = TARGET_MOVE_DISTANCE;
	}
	
	// x - , y -
	if(angle > 2 * RIGHT_ANGLE && angle < 3 * RIGHT_ANGLE){
		// left 음수, top 음수
		toLeftDistance = -1 * TARGET_MOVE_DISTANCE;
		toTopDistance = tangent * -1 * TARGET_MOVE_DISTANCE * -1;
		angle = 2 * RIGHT_ANGLE + (RIGHT_ANGLE - angle % RIGHT_ANGLE);
	}
	
	if(angle == 3 * RIGHT_ANGLE){
		toLeftDistance = TARGET_MOVE_DISTANCE * -1;
		toTopDistance = 0;
	}
	
	// x - , y +
	if(angle > 3 * RIGHT_ANGLE && angle < 4 * RIGHT_ANGLE){
		// left 음수, top 양수
		toLeftDistance = -1 * TARGET_MOVE_DISTANCE;
		toTopDistance = tangent * TARGET_MOVE_DISTANCE * -1;
		angle = 3 * RIGHT_ANGLE + (RIGHT_ANGLE - angle % RIGHT_ANGLE);
	}
	
	if(Math.abs(toTopDistance) > TARGET_MOVE_DISTANCE){
		var ratio = Math.abs(toTopDistance/TARGET_MOVE_DISTANCE); 
		toTopDistance = 10 * Math.sign(toTopDistance);
		toLeftDistance /= ratio; 
	}
	
	target.css("transform", "rotate(" + angle + "deg)");
	target.css("-webkit-transform", "rotate(" + angle + "deg)");
	
	target.find(".angle").val(angle);
	target.find(".toLeftDistance").val(toLeftDistance);
	target.find(".toTopDistance").val(toTopDistance);
}

function moveTarget(target){
	return new Promise(function (resolve, reject) {
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
			randAngle(target);
		}  else{
			var xy = {};
			xy["target"] = target;
			xy["left"] = left;
			xy["top"] = top;
			resolve(xy);
		}
	});
}

// 타겟 움직임 스레드
function startMoveTargetThread(tg){
	moveTargetThread = setInterval(function(){
		var targets = $(".target:not(.died)");
		targets.each(function(){
			moveTarget($(this)).then(function (xy){
				xy["target"].css("left", xy["left"]);
				xy["target"].css("top", xy["top"]);
			});
		});
		
	}, config.targetMoveSpeed);
}

function stopMoveTargetThread(){
	clearInterval(moveTargetThread);
	moveTargetThread = undefined;
}

function stopMoveTarget(tg){
	var toLeftDistance 		= tg.find(".toLeftDistance");
	var toTopDistance 		= tg.find(".toTopDistance");
	var saveToLeftDistance 	= tg.find(".saveToLeftDistance");
	var saveToTopDistance 	= tg.find(".saveToTopDistance");
	
	saveToLeftDistance.val(toLeftDistance.val());
	saveToTopDistance.val(toTopDistance.val());
	
	toLeftDistance.val(0);
	toTopDistance.val(0);
}

function restartMoveTarget(tg){
	var toLeftDistance 		= tg.find(".toLeftDistance");
	var toTopDistance 		= tg.find(".toTopDistance");
	var saveToLeftDistance 	= tg.find(".saveToLeftDistance");
	var saveToTopDistance 	= tg.find(".saveToTopDistance");
	
	toLeftDistance.val(saveToLeftDistance.val());
	toTopDistance.val(saveToTopDistance.val());
	
	saveToLeftDistance.val('');
	saveToTopDistance.val('');
}


/** ** ========== 플레이 타임에 시작/정지 로직 =================== * */

function startPlay(){
	config = LEVEL_CONFIG[level];
	startTime();
	startMakeTarget(); // 타겟 생성 쓰레드
	startLifeDecrease(); // 생명력 감소 스레드 시작
	startMoveTargetThread();
}

function stopPlay(){
	stopTime();
	stopMakeTarget();
	stopLifeDecrease();
	stopWarnigLifeThread();
	stopMoveTargetThread();
}


/** =============== 체력 관련 ================ * */

// 체력 감소 스레드 시작
function startLifeDecrease() { // 재귀를 이용한 Interval
	life = life - 0.5;
	if(life < 10){
		gameover();
		lifeDecreaseThread = undefined;
	} else {
		if(life <= 20 && warnigLifeThread == undefined){ // 체력이  일정수준 이하로 감소했을때
			startWarnigLifeThread();
		} else if(life > 20 && warnigLifeThread != undefined){
			stopWarnigLifeThread();
		}
		
		$(".progress .progress-bar").stop().animate({"width" : life + "%"});
		$(".move-friends").stop().animate({"left" : ((life * 0.65) + 20) + "%"});
		lifeDecreaseThread = setTimeout(startLifeDecrease, config.lifeDecreaseRate);
	}
	
	var basket = $(".icon-basket");
	basket.find(".value.status-100").removeClass("on");
	basket.find(".value.status-60").removeClass("on");
	basket.find(".value.status-30").removeClass("on");
	
	if( life > 60 && life <= FULL_LIFE){
		basket.find(".value.status-100").addClass("on");
	} else if( life > 30 && life <= 60){
		basket.find(".value.status-60").addClass("on");
	} else if( life <= 30){
		basket.find(".value.status-30").addClass("on");
	}

}

// 체력 감소 스레드 중지
function stopLifeDecrease(){
	clearTimeout(lifeDecreaseThread);
	lifeDecreaseThread = undefined;
}

// 경고 백그라운드 스레드 시작
function startWarnigLifeThread(){
	startAudio(warningSound);
	
	if(warnigLifeThread == undefined){
		warnigLifeThread = setInterval(function(){
			var basket = $(".icon-basket");
			basket.find(".value.status-died").toggleClass("on");
			var progressbarWarningOverlay = $(".crop-progress-bar-overlay-warning");
			progressbarWarningOverlay.toggleClass("on");
		}, 100);
	}	
}

// 경고 백그라운드 스레드 중지
function stopWarnigLifeThread(){
	var basket = $(".icon-basket");
	basket.find(".value.status-died").removeClass("on");
	var progressbarWarningOverlay = $(".crop-progress-bar-overlay-warning");
	progressbarWarningOverlay.removeClass("on");
	clearTimeout(warnigLifeThread);
	warnigLifeThread = undefined; // 쓰레드 변수 초기화
}

/** =============== 공격 관련 ============== */

function doAttack(e){
	startAudio(attackSound);

	var attacker = $(".attacker");
	attacker.addClass("on");
	attacker.removeClass("left");
	attacker.removeClass("right");

	var x = e.pageX - $(".play-ground").offset().left;
	var y = e.pageY - $(".play-ground").offset().top;

	var centerX = (endX - startX)/2;
	if(x < centerX){ attacker.addClass("left");}
	else { attacker.addClass("right")};
	
	var attackAreaValidWidth 	= ATTACKER_WIDTH;
	var attackAreaValidHeight 	= ATTACKER_HEIGHT * (1/2);
	var attackStartX = x - (attackAreaValidWidth / 2);
	var attackStartY = y - (attackAreaValidHeight / 2);
	var attackEndX = x + (attackAreaValidWidth / 2) ;
	var attackEndY = y + (attackAreaValidHeight / 2) ;

	attacker.css("left", attackStartX);
	attacker.css("top", attackStartY);
	setTimeout(function() {
		attacker.removeClass("on")
	}, 100);
	
	
//	임시로 측정을위해 만든 코딩임.
//	var attackerTemp = $(".attacker-temp");
//	attackerTemp.css("left", attackStartX);
//	attackerTemp.css("top", attackStartY);
//	attackerTemp.css("width", attackEndX - attackStartX);
//	attackerTemp.css("height", attackEndY - attackStartY);
	
	// 보이지 않는 곳의 벌레가 죽게되는 것을 방지.
	if(attackStartX < (startX + HIDDEN_PADDING) ) { attackStartX = (startX + HIDDEN_PADDING);}
	if(attackStartY < (startY + HIDDEN_PADDING) ) { attackStartY = (startY + HIDDEN_PADDING);}
	if(attackEndX > (endX - HIDDEN_PADDING)) { attackEndX = (endX - HIDDEN_PADDING);}
	if(attackEndY > (endY -HIDDEN_PADDING)) { attackEndY = (endY - HIDDEN_PADDING);}
	
	var attackedTargetNumber = 0;

	var targets = $(".target:not(.died)");
	var checkComboflag = true;
	targets.each(function() {
		var targetStartX = parseInt($(this).css("left"));
		var targetStartY = parseInt($(this).css("top"));
		var targetEndX = targetStartX + TARGET_WIDTH;
		var targetEndY = targetStartY + TARGET_HEIGHT;
		var attacked = false;

		
//		console.log ("A// " + attackStartX + "," + attackStartY + " // " + attackEndX + "," + attackEndY + " //" );
//		console.log ("B// " + targetStartX + "," + targetStartY + " // " + targetEndX + "," + targetEndY + " //" );
		
		// case1 왼쪽에 벌레가 걸쳤다.
		if (targetEndX > attackStartX
			&& targetEndX < attackEndX
			&& targetStartY > attackStartY
			&& targetEndY < attackEndY) {
			attacked = true;
		}

		// case2 오른쪽에 벌레가 걸쳤다.
		if (targetStartX < attackEndX
			&& targetStartX > attackStartX
			&& targetStartY > attackStartY
			&& targetEndY < attackEndY) {
			attacked = true;
		}

		// case3 위쪽에 벌레가 걸쳤다.
		if (targetStartX > attackStartX
			&& targetEndX < attackEndX
			&& targetEndY > attackStartY
			&& targetEndY < attackEndY) {
			attacked = true;
		}

		// case4 아래쪽에 벌레가 걸쳤다.
		if (targetStartX > attackStartX
			&& targetEndX < attackEndX
			&& targetStartY < attackEndY
			&& targetStartY > attackStartY) {
			attacked = true;
		}

		if (attacked) {
			if (!$(this).hasClass(TARGET_WARNING)) {
				attackedTargetNumber = attackedTargetNumber + 1;
			}
			doAttackTarget(this);
		}

	});

	checkCombo();
	function checkCombo() { // 콤보 수 확인
		if (attackedTargetNumber >= 2) {
			startAudio(comboSound);
			
			var comboMessage = $(".combo-message");
			comboMessage.css("left", attackStartX - 50);
			comboMessage.css("top", attackStartY);
			var values = comboMessage.find(".value");
			values.removeClass("on");
			values.eq(attackedTargetNumber-1).addClass("on");
			
			setTimeout(function() {
				comboMessage.addClass("on");
			}, 100);
			setTimeout(function() {
				comboMessage.removeClass("on");
			}, 1000);

			makeCoin(COMBO_COIN * attackedTargetNumber);
		}
	}
}

//타겟 삭제 - 공격당했을때
function doAttackTarget(target){
	var target = $(target);
	
	if(!target.hasClass("died")){
		target.addClass("died");
		if(target.hasClass(TARGET_WARNING)){
			lifeRecovery(TARGET_WARNING_DAMEAGE);
			removeTarget(target,true);
		} else if (target.hasClass(TARGET_GOLD)){
			makeCoin(TARGET_GOLD_COIN);
			target.css("transform", "rotate(0deg)");
			target.find(".target-icon").css("background-image", "url(" + getContextPath() + "/resources/image/play/icon_play_target_gold_died.gif?" + Math.random() + ")");
			removeTarget(target,true);
		} else{ // 노말 타겟인 경우
			lifeRecovery(TARGET_NORMAL_RECOVERY);
			makeCoin(TARGET_NORMAL_COIN);
			removeTarget(target,true);
		}
		
		
	}
}

//돈 증가
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

function drawCoin(coin){
	$(".info-board-t .info.wrap-coin .value").text(coin);
}

// 아이템 활성화 체크
function checkItemCost(){
	if(totalCoin >= ITEM_COST_LIME){  $(".itembar-item.lime-item .icon.icon-on").addClass("on"); }
	else { $(".itembar-item.lime-item .icon.icon-on").removeClass("on"); }

	if(totalCoin >= ITEM_COST_HEART){ $(".itembar-item.portion-item .icon.icon-on").addClass("on"); }
	else { $(".itembar-item.portion-item .icon.icon-on").removeClass("on"); }
	
	if(totalCoin >= ITEM_COST_SPRAY){ $(".itembar-item.spray-item .icon.icon-on").addClass("on"); }
	else { $(".itembar-item.spray-item .icon.icon-on").removeClass("on"); }
}

/**================ GAMEOVER 관련  =================**/

function gameover() {
	stopBGM();
	startAudio(gameoverSound);
	
	removeSomeTarget($(".target"), false);// 모든 타겟 삭제
	stopPlay();
	
	$(".wrap-fg").addClass("on");
	$(".wrap-gameover").addClass("on");
	$(".wrap-gameover .gameover-time").text(time.toFixed(2));
}


/** ============ Pause =============== **/
function doPause(){
	if(clickBlock) { return ;}
	clickBlock = true;
	
	startAudio(btnClickSound);
	
	stopBGM();
	stopTime();
	stopMakeTarget();
	stopLifeDecrease();
	
	var targets = $(".target");
	targets.each(function(){
		stopMoveTarget($(this));
	})
	
	$(".wrap-fg").addClass("on");
	$(".wrap-pause").addClass("on");
	
	timeoutSetBlockFalse();
}

function doRegame(){
	
	if(clickBlock) { return ;}
	clickBlock = true;
	
	startAudio(btnClickSound);
	
	startBGM();
	startTime();
	startMakeTarget();
	startLifeDecrease();
	var targets = $(".target:not(.stoped)");
	targets.each(function(){
		restartMoveTarget($(this));
	})
	
	$(".wrap-fg").removeClass("on");
	$(".wrap-pause").removeClass("on");
	
	timeoutSetBlockFalse();
}

function doRestart(tg, doMortion){
	
	if(clickBlock === 1) { return 0;}
	clickBlock = 1;
	
	startAudio(btnClickSound);
	stopBGM();

	var mortionInterval;
	var duation = 400;
	if(doMortion){
		var restartMotion 	= $(".wrap-gameover .btn-restart-mortion");
		restartMotion.addClass("moving");
		mortionInterval = setInterval(function(){
			
			restartMotion.css("left", parseInt(restartMotion.css("left")) + 15);
			restartMotion.css("top", parseInt(restartMotion.css("top")) - 20);
		}, 40);
		
		duation = 1000;
	}
	
	setTimeout(function(){
		var restartMotion 	= $(".wrap-gameover .btn-restart-mortion")
		clearInterval(mortionInterval);
		restartMotion.removeClass("moving");
		
		stopPlay();
		redrawToPlay();
		initGame();
		stageEffectOn();
		setTimeout(function(){
			stageEffectOff();
			startPlay();
			startBGM();
		}, 1500);
		
		clickBlock = false;
	}, duation);
}


function doHome(tg){
	if(clickBlock) { return ;}
	clickBlock = true;
	
	var tg = $(tg);
	startAudio(btnClickSound);
	stopBGM();
	
	setTimeout(function(){
		stopPlay();
		redrawToHome();
		startBGM();
		
		clickBlock = false;
	}, 500);
	
}


function initGame(){
	/* ---- 변수 초기화 -------*/
	startX				= undefined;
	startY				= undefined;
	endX				= undefined;
	endY				= undefined;
	config				= undefined;
	life 				= FULL_LIFE;
	level				= 0;
	time				= 0;
	totalCoin           = 0;    // 코인 숫자

	makeTargetThread		= undefined;
	moveTargetThread		= undefined;
	timeThread				= undefined;
	warnigLifeThread		= undefined;
	lifeDecreaseThread 		= undefined;
	
	
	timeWorker.postMessage("init");
	
	/*-----  좌표 초기화 -------- */
	var playGround = $(".play-ground");
	startX 	= 0 - HIDDEN_PADDING;
	startY	= 0 - HIDDEN_PADDING;
	endX	= playGround.width() + HIDDEN_PADDING;
	endY	= playGround.height() + HIDDEN_PADDING;
	
	/*---- 값, 위치, 너비, 높이 초기화 ----*/
	removeSomeTarget($(".target"), false);
	$(".info.time .value").text(time.toFixed(2));
	$(".info.wrap-coin .value").text(totalCoin);
	
	var attacker = $(".attacker");
	attacker.removeAttr("style");
	attacker.css("width", ATTACKER_WIDTH);
	attacker.css("height", ATTACKER_HEIGHT);
	
	var moveFriends = $(".move-friends");
	moveFriends.removeAttr("style");
	moveFriends.css("left", ((life * 0.65) + 20) + "%");

	redrawTag();
}

function redrawTag(){
	var basketOccupy = $(".icon-basket-occupy");
	var basket  = $(".icon-basket");
	basket.removeAttr("style");
	basket.css("width", basketOccupy.width());
	basket.css("height", basketOccupy.width());
	
	var progressBar = $(".progress .progress-bar");
	var cropProgressBar = $(".progress .progress-bar .crop-progress-bar");
	var cropProgressBarOvelay = $(".progress .progress-bar .crop-progress-bar-overlay");
	var cropProgressBarOvelayWarning = $(".progress .progress-bar .crop-progress-bar-overlay-warning");
	progressBar.removeAttr("style");
	cropProgressBar.removeAttr("style");
	cropProgressBar.css("width", progressBar.width());
	cropProgressBarOvelay.removeAttr("style");
	cropProgressBarOvelay.css("width", progressBar.width());
	cropProgressBarOvelayWarning.removeAttr("style");
	cropProgressBarOvelayWarning.css("width", progressBar.width());
	
	var items = $(".itembar-item");
	items.css("height", items.width());
	
	var restartMotion 	= $(".wrap-gameover .btn-restart-mortion");
	var restartBtn 		= $(".wrap-gameover .menu.btn-restart");
	restartMotion.css("left", restartBtn[0].offsetLeft);
	restartMotion.css("top", restartBtn[0].offsetTop);
}
		
$(window).resize(function(){
	redrawTag();
})
