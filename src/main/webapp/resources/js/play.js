const TARGET_POINT	  = 100;	// 타겟 하나당 점수
const COMBO_POINT	  = 200;	// 콤보 시 타겟 하나당 점수
const FEVER_POINT	  = 300;	// 피버 타겟 하나당 점수

const TARGET_WIDTH			= 50;		// 타겟 넓이
const TARGET_HEIGHT			= 50;		// 타겟 높이
const HIDDEN_PADDING		= 50;		// 숨겨진 공간
const ITEM_CREATE_PERCENT	= 0.05;	// 아이템 생성 확률
const RIGHT_ANGLE 			= 90;
const LIMIT_COMBO_NUMBER	= 3;		// 보스타임이 되기까지 콤보 수/ n번 때리면 보스타임 시작
const FEVER_TARGET_NUMBRT	= 5;     // 보스 터치 제한 횟수
const FEVER_TARGET_WIDTH	= 300;	// 보스 타겟 넓이
const FEVER_TARGET_HEIGHT	= 300;	// 보스 타겟 높이
const RECOVERY_DEGREE   	= 10;     // 체력 회복 수치
const FEVER_TIME_SEC		= 5000;		// 피버 타임 시간

const ITEM_COST_POWER = 10;	// 파워 아이템 비용
const ITEM_COST_SPRAY = 50;	// 스프레이 아이템 비용
const ITEM_COST_HEART = 20;

const PLAYTIME_NORMAL	= "PLAYTIME_001";
const PLAYTIME_FEVER 	= "PLAYTIME_002";

const FULL_LIFE			= 100;


var startX;
var startY;
var endX;
var endY;

var targetMakeRate 		= 600; 	// 타겟이 생성되는 간격 , 1000 = 1초
var randAngleTime		= 5000; // 타겟이 이동방향을 바꾸는 쓰레드 간격.
var wariningTargetRate  = 0.3;  // Warning 타겟이 생성되는 확률
var totalScore			= 0; 	// 점수
var totalCoin           = 0;    // 코인 숫자
var feverTargetMakeRate = 100;  // 피버 타겟이 생성되는 간격, 1000 = 1초
var makeTargetThread;
var checkTargetThread;
var fallingSpeedUpThread;
var makeFeverTargetThread;
var warningBackgroundChange;
var moveDistance 		= 10;
var maxTargetNumber 	= 20;	// 최대 타겟 수
var comboNumber 		= 0; 	// 콤보 횟수 저장
var targetMoveSpeed 	= 100; 	// 타겟 스피드
var feverTargetTouchCount= 0; 	// 보스 타겟 터치 카운트
var timeType 			= PLAYTIME_NORMAL; 	
var attackPower  	    = 1;    // 공격 파워
var targetLife          = 1;    // 타겟 생명
var targetLifeIncTime   = 10000;

// targeting 범위
var attackAreaWidth 	= 150;
var attackAreaHeight    = 150;

//배경음악
var backgroundAudio; // 노말 배경 음악
var feverTimeBackgroundAudio; // 피버 배경 음악

// 효과음
var removeSound; // 클릭시 소리
var itemSound;	// 아이템 소리

// 체력
var life = FULL_LIFE;
var lifeDecreaseThread;
var lifeDecreaseRate = 100; // 체력이 감소하는 속도


// 타겟 삭제 - 공격당했을때
function doAttackTarget(target){
	var target = $(target);
	
	if(target.hasClass("fever-target")){ // 피버타겟 아이템인경우
		gainScore(TARGET_POINT);	
		lifeRecovery(10);
		makeCoin(5);
		
	} else if(target.find(".targetType").val() === "warning"){
		lifeRecovery(-10);
		usingItem(3);
		removeTarget(target,true);
	}else{ // 노말 타겟인 경우
		var targetlife = parseInt(target.find(".life").val());
		if(targetlife - attackPower > attackPower ) {
			target.find(".life").val(targetlife-attackPower);
		} else if(targetlife - attackPower === attackPower) {
			target.find(".life").val(targetlife-attackPower);
			target.addClass('limit');
		} else  {
			gainScore(TARGET_POINT);
			lifeRecovery(5);
			makeCoin(1);
			removeTarget(target,true);
		}
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
	case 0 : doUpgradePower();break;
	case 1 : doUsingSpray(); break;
	case 2 : doRecoveryHeart(); break;
	case 3 : doChangemoveSpeed(duration); break;
	}
	
	function doUpgradePower(){
		if(coinNumber >= ITEM_COST_POWER){ //가지고 있는 코인이 아이템 비용보다 높다면
			$(".effect.powerup").addClass("on")
			setTimeout(function() {
				$(".effect.powerup").removeClass("on");
			}, 1000)
			
			attackPower++;// 공격 강화
			decreaseCoin(ITEM_COST_POWER); //코인 감소
		}	
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
	if($(".bgm-source-board").attr('data-click-state') == 1){ // 지금 정지
																// 중이라면
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
	var targets = $(".target");
	if(targets.length > maxTargetNumber){ // 최대 타겟수보다 많을경우 만들지 않음.
		return;
	}
	
	var playGround = $(".play-ground");
	
	
	var targetType = Math.random();
	if(targetType < wariningTargetRate) { // warningTarget이 만들어질 확률
		var target = $("<div>", {"class" : "target warning"});
		target.append($("<div>", {"class" : "target-icon"}));
		target.append($("<input>", {"class" : "targetType", type :"hidden", value: "warning"}));
		target.append($("<input>", {"class" : "life",type : "hidden" , value: 1}));	
	} else {
		var target = $("<div>", {"class" : "target"});
		target.append($("<div>", {"class" : "target-icon"}));
		target.append($("<input>", {"class" : "targetType", type :"hidden", value: "normal"}));
		target.append($("<input>", {"class" : "life",type : "hidden" , value: targetLife}));
	}
	
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
		var moveTargetThread = setTimeout(function(){ moveTarget(target)}, targetMoveSpeed);
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

// 점수 증가
function gainScore(point){
	 var score = $(".score");
	 totalScore = totalScore + point;
	 score.text(totalScore);
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

	if(totalCoin >= ITEM_COST_POWER){ $(".power-item .overlay-item").removeClass("on"); }
	else { $(".power-item .overlay-item").addClass("on"); }
	
	if(totalCoin >= ITEM_COST_HEART){ $(".heart-item .overlay-item").removeClass("on"); }
	else { $(".heart-item .overlay-item").addClass("on"); }
}


/** ** ========== 플레이 타임에 시작/정지 로직 =================== * */

function startPlayNormalTime(){
	timeType = PLAYTIME_NORMAL;
	
	startAudio(backgroundAudio); // 보스 타임 백그라운드 음악 제거
	
	startMakeTarget(); // 타겟 생성 쓰레드
	startLifeDecrease(); // 생명력 감소 스레드 시작
	warningBackgroundChange == undefined; // 생명력 경고 쓰레드 초기화
}

function stopPlayNormalTime(){
	removeAllTarget(".target",false)// 모든 타겟 삭제
	stopAudio(backgroundAudio);
	
	stopMakeTarget();
	stopLifeDecrease();
	stopWarningBackgroundChange();
}

function startPlayFeverTime(){// 보스타임 시작
	timeType = PLAYTIME_FEVER; // 보스 타임으로 변경
	
	startAudio(feverTimeBackgroundAudio);
	
	var playGround = $(".play-ground");
	var windowWidth = playGround.width();
	var windowHeight = playGround.height();
	var feverTarget = $("<div>", {"class" : "fever-target"});
	feverTarget.on("click", function(){
		startAudio(removeSound);			
		removeSound.currentTime = 0;
	});
	
	// 보스 타겟 설정
	feverTarget.append($("<div>", {"class" : "fever-target-icon"}));
	feverTarget.appendTo(playGround);
	feverTarget.css("width", FEVER_TARGET_WIDTH);
	feverTarget.css("height", FEVER_TARGET_HEIGHT);  // 보스 벌레 이미지 정중앙 배치
	feverTarget.css("left", (windowWidth/2) - (FEVER_TARGET_WIDTH / 2));
	feverTarget.css("top", (windowHeight/2	) - (FEVER_TARGET_HEIGHT / 2));
	// ////////////////////////////////////////////////////////////////

	

	/*
	// 피버타임 메세지 나타남
	var startFeverTimeMessage = setInterval(function() {
		var feverTimeMessage = $(".play-ground");
		feverTimeMessage.toggleClass("fevertime");
	}, 300);
	
	
	setTimeout(function() { // 피버 타임 메세지 스레드 제거
		clearTimeout(startFeverTimeMessage);
		startFeverTimeMessage = undefined;
		var feverTimeMessage = $(".effect.fevertime");
		feverTimeMessage.removeClass("on");
	}, FEVER_TIME_SEC);
	
	*/

	var startFeverTimeBackgroundChange = setInterval(function(){
		var playGround = $('.play-ground');
		var r =  Math.round( Math.random()*256);
		var g =  Math.round( Math.random()*256);
		var b =  Math.round( Math.random()*256);
		var rgb = r + "," + g + "," + b;
		playGround.css("background-color","rgb(" + rgb +")");
		
	}, 300);
	
	setTimeout(function() { // 피버 타임 백그라운드 색 변경 스레드 제거
		var playGround = $('.play-ground');
		clearTimeout(startFeverTimeBackgroundChange);
		startFeverTimeBackgroundChange = undefined;
		playGround.css("background-color", "rgba(0, 0, 0, 0)");
	}, FEVER_TIME_SEC);

	setTimeout(function() { stopPlayFeverTime(); }, FEVER_TIME_SEC)	// N초후 피버타임 종료
	setTimeout(startPlayNormalTime, FEVER_TIME_SEC); //N초후 노멀타임 시작
}

function stopPlayFeverTime(){
	stopAudio(feverTimeBackgroundAudio); // 보스 타임 백그라운드 음악 제거
	
	// 피버 타겟 삭제
	var feverTarget = $(".fever-target");
	feverTarget.remove();
	
	lifeRecovery(FULL_LIFE);
}

/** ============================================================================== * */


// 노말 타겟 생성 스레드
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
		lifeDecreaseThread = setTimeout(startLifeDecrease, lifeDecreaseRate);
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
	
	startAudio(backgroundAudio);
	
	// 아이템 비용 표시
	initItemCost();
	function initItemCost(){
		$(".power-item-cost").text(ITEM_COST_POWER);
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
    	
    	if(timeType == PLAYTIME_NORMAL){ // 노말 타임
    		var targets = $(".target");
    		var checkComboflag = 0;
    		targets.each(function(){
    			var targetStartX= parseInt($(this).css("left"));
    			var targetStartY= parseInt($(this).css("top"));
    			var targetEndX	= targetStartX + TARGET_WIDTH;
    			var targetEndY 	= targetStartY + TARGET_HEIGHT;
    			
    			
    			if(targetStartX > attackStartX 
    					&& targetEndX < attackEndX
    					&& targetStartY > attackStartY
    					&& targetEndY < attackEndY){
    				attackedTargetNumber = attackedTargetNumber+1;
    				
    				if($(this).find(".targetType").val() ==="warning")
    					 checkComboflag =1;
    				 
    				doAttackTarget(this);
 
    			}
    			
    		}); 
    		if(checkComboflag === 0) {
    		checkCombo();
    		}
    		function checkCombo(){ // 콤보 수 확인
    			if(attackedTargetNumber >= 2){
    				comboNumber = comboNumber + 1;
    				
    				if(comboNumber >= LIMIT_COMBO_NUMBER){ // 보스타임 검사
    					comboNumber = 0;
    					stopPlayNormalTime(); 
    					startPlayFeverTime(); // 보스 타임 시작
    				}
    				
    				else{
    					var comboMessage = $(".combo-message");
    					comboMessage.css("left", attackStartX);
    					comboMessage.css("top", attackStartY);
    					comboMessage.find(".combo-count").text(comboNumber);
        			
        				setTimeout(function(){comboMessage.addClass("on");}, 100);
        				setTimeout(function(){comboMessage.removeClass("on");}, 1000);
        				
        				gainScore(COMBO_POINT * attackedTargetNumber); // 콤보 점수 추가 획득
    				}
   				}
    		}
    	}
    	
    	else if(timeType == PLAYTIME_FEVER){ // 보스 타임
    		var feverTarget = $(".fever-target");
    		var targetStartX= parseInt(feverTarget.css("left"));
			var targetStartY= parseInt(feverTarget.css("top"));
			var targetEndX	= targetStartX + FEVER_TARGET_WIDTH;
			var targetEndY 	= targetStartY + FEVER_TARGET_HEIGHT;
			
			if(targetStartX < attackStartX 
					&& targetEndX > attackEndX
					&& targetStartY < attackStartY
					&& targetEndY > attackEndY){

				doAttackTarget(feverTarget);
			}
    	}
    });

	// 오디오 버튼 활성화 , 비활성화
	$(".bgm-source-board").on("click",function(e) {
		
		var audio;
		
		switch(timeType){
		case PLAYTIME_NORMAL :
			audio = backgroundAudio;
			break;	
		case PLAYTIME_FEVER : 
			audio = feverTimeBackgroundAudio;
			break;
		}
		
		if($(this).attr('data-click-state') == 1) {
			$(this).attr('data-click-state', 0);
			startAudio(audio);			
			$(".bgm-source-board").css({"background":"url(resources/image/sample_start_audio.png", 'background-repeat' : 'no-repeat', 'background-size' : 'contain'});} 
		else {
			$(this).attr('data-click-state', 1);		
			stopAudio(audio);			
			$(".bgm-source-board").css({"background":"url(resources/image/sample_stop_audio.png", 'background-repeat' : 'no-repeat' ,'background-size' : 'contain'});
		}
	});
			
	//타겟 체력 증가 스레드
	setInterval(function(){	targetLife++; }, targetLifeIncTime);
	
	startPlayNormalTime();
})
		
	
