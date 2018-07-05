<%@ page pageEncoding="UTF-8"%>
<html>
<head>
<%@ include file="/WEB-INF/views/included/included_head.jsp"%>
<style>
html, body, .wrapper {
	overflow-x: hidden;
}

.wrapper {
	position: relative;
	display: flex;
	flex-flow: column nowrap;
	height: 100%;
	max-width: 500px;
	background-repeat: no-repeat;
	background-size: cover;
	/* background-image: url("resources/image/bg_play.jpg"); */
}

.wrapper .wrap-fg {
	display: none;
	z-index: 1;
	position: absolute;
	left: 0;
	right: 0;
	top: 0;
	bottom: 0;
	background: rgba(0, 0, 0, 0.6);
}

.wrapper .wrap-fg.on {
	display: block;
}

.wrapper .wrap-gameover {
	display: none;
	z-index: 3;
	position: absolute;
	left: 0;
	right: 0;
	top: 0;
	bottom: 0;
	background: rgba(0, 0, 0, 0);
	justify-content: center;
	align-items: center;
}

.wrapper .wrap-gameover.on {
	display: flex;
}

.gameover {
	width: 300px;
	height: 400px;
	background: #FFF;
	border-radius: 10px;
	box-shadow: 0px 10px 20px #222;
	display: flex;
	flex-flow: column nowrap;
	justify-content: center;
	align-items: center;
}

.gameover .gameover-icon {
	width: 150px;
	height: 150px;
	background-repeat: no-repeat;
	background-size: contain;
	background-position: center;
	margin-bottom: 10px;
}

.gameover .gameover-message {
	font-size: 2rem;
	font-weight: bold;
}

.wrap-fevertime {
	display: none;
	z-index: 3;
	position: absolute;
	left: 0;
	right: 0;
	top: 0;
	bottom: 0;
	background: rgba(0, 0, 0, 0);
	justify-content: center;
	align-items: center;
}

.fevertime {
	width: 100%;
	height: 100%;
	/* background: #FFF;
	border-radius: 10px;
	box-shadow: 0px 10px 20px #222; */
	display: flex;
	flex-flow: column nowrap;
	justify-content: center;
	align-items: center;
}

.fevertime .fevertime-message {
	font-size: 2rem;
	font-weight: bold;
}

.head {
	width: 100%;
	height: 50px;
	display: flex;
	justify-content: space-between;
}

.bgm-source-board {
	width: 50px;
	height: 100%;
	background-repeat: no-repeat;
	background-size: contain;
	background-image: url("resources/image/sample_stop_audio.jpg");
	z-index: 4;
}

.score-board {
	width: 100px;
	height: 50px;
	margin: auto;
	display: inline-block;
}

.score {
	font-size: 2rem;
	font-weight: bold;
	text-align: center;
}

.combo {
	font-size: 1.5rem;
	font-weight: bold;
	text-align: center;
	position: absolute;
	display: none;
}

.life-board {
	width: 200px;
	height: 50px;
	margin: auto;
	display: inline-block;
	border: 2px solid black;
}

.ui-widget-header {
	background: #cedc98;
	color: #333333;
	height: 50px;
}

.play-ground {
	flex: 1;
	position: relative;
	overflow: hidden;
}

.footer {
	width: 100%;
	height: 100px;
	background: red;
}

.target {
	position: absolute;
	z-index: 2;
	display: flex;
	justify-content: center;
	align-items: center;
	background: rgba(0, 0, 0, 0);
	transform-origin: 50% 50%;
	/* transition: transform 1s cubic-bezier(0.215, 0.61, 0.355, 1); */
}

.target .target-icon {
	width: 100%;
	height: 100%;
	background-repeat: no-repeat;
	background-size: contain;
	background-image: url("resources/image/sample_target.png");
}

.target.candy 	.target-icon {
	background-image: url("resources/image/sample_candy.png");
}

.target.item 	.target-icon {
	background-image: url("resources/image/sample_candy_item.png");
}

.target.removed .target-icon {
	background-image: url("resources/image/sample_target_removed.png");
}

.fever-target {
	position: absolute;
	z-index: 2;
	display: flex;
	justify-content: center;
	align-items: center;
	background: rgba(0, 0, 0, 0);
	transform-origin: 50% 50%;
}

.fever-target-icon {
	width: 100%;
	height: 100%;
	background-repeat: no-repeat;
	background-size: contain;
	background-image: url("resources/image/sample_heart.gif");
}

.boss-target {
	position: absolute;
	z-index: 2;
	display: flex;
	justify-content: center;
	align-items: center;
	background: rgba(0, 0, 0, 0);
	transform-origin: 50% 50%;
}

.boss-target .boss-target-icon {
	width: 100%;
	height: 100%;
	background-repeat: no-repeat;
	background-size: contain;
	background-image: url("resources/image/sample_target_boss.jpg");
}

.attacker {
	position: absolute;
	background: red;
	z-index: 4;
	display: none;
}

.attacker.on {
	display: block;
}
</style>

<script>
	//FINAL
	const TARGET_POINT	  = 100;	// 타겟 하나당 점수
	const COMBO_POINT	  = 200;	// 콤보 시 타겟 하나당 점수
	const FEVER_POINT	  = 300;	// 피버 타겟 하나당 점수
	
	const TARGET_WIDTH			  = 50;		// 타겟 넓이
	const TARGET_HEIGHT			  = 50;		// 타겟 높이
	const FEVER_WIDTH      = 50;		// 피버  타겟 넓이
	const FEVER_HEIGHT     = 50;		// 피버 타겟 높이
	const HIDDEN_PADDING		  = 50;		// 숨겨진 공간
	const ITEM_CREATE_PERCENT	  = 0.05;	// 아이템 생성 확률
	const RIGHT_ANGLE 			  = 90;
	const LIMIT_COMBO_NUMBER	  = 0;		// 보스타임이 되기까지 콤보 수/ n번 때리면 보스타임 시작
	const BOSS_TARGET_NUMBRT	  = 10;     // 보스 터치 제한 횟수
	const BOSS_TARGET_LEFTDISTANCE= 30;
	const BOSS_TARGET_WIDTH		  = 300;	// 보스 타겟 넓이
	const BOSS_TARGET_HEIGHT	  = 300;	// 보스 타겟 높이
	const RECOVERY_DEGREE   	  = 10;     // 체력 회복 수치
	const FEVER_TIME_SEC		= 10000;		//피버 타임 시간
	
	const ITEMS = [
		{type :"ITM_001", duration :5000}, 
		{type :"ITM_002", duration :5000}
	]; 
	
	const PLAYTIME_NORMAL	= "PLAYTIME_001";
	const PLAYTIME_FEVER 	= "PLAYTIME_002";
	const PLAYTIME_BOSS 	= "PLAYTIME_003";
	
	var startX;
	var startY;
	var endX;
	var endY;
	
	var targetMakeRate 		= 600; 	// 타겟이 생성되는 간격 , 1000 = 1초
	var randAngleTime		= 5000; // 타겟이 이동방향을 바꾸는 쓰레드 간격.
	var bossTargetMoveTime  = 100;  // 보스 타겟이 이동하는 쓰레드 간격.
	var totalScore			= 0; 	// 점수
	var feverTargetMakeRate = 100;  // 피버 타겟이 생성되는 간격, 1000 = 1초
	var makeTargetThread;
	var checkTargetThread;
	var fallingSpeedUpThread;
	var makeFeverTargetThread;
	var moveDistance 		= 10;
	var maxTargetNumber 	= 5;	//최대 타겟 수 
	var comboNumber 		= 0; 	//콤보 횟수 저장
	var targetMoveSpeed 	= 100; 	//타겟 스피드
	var bossTargetLeftdistance= 10; //보스 타겟 왼쪽 이동 거리
	var bossTargetTouchCount= 0; 	//보스 타겟 터치 카운트 
	var timeType 			= PLAYTIME_NORMAL; 	
	var fullLife 			= 100; 	//총 생명력
	
	//targeting 범위
	var attackAreaWidth 	= 150;
	var attackAreaHeight    = 150;
	
	//노말 음악
	var backgroundAudio; //노말 배경 음악
	
	//보스 타임 음악
	var bossTimeBackgroundAudio; //보스 배경 음악
	
	//피버 타임 음악
	var feverTimeBackgroundAudio; //피버 배경 음악
	
	//효과음
	var removeSound; //클릭시 소리
	
	//체력
	var life = fullLife;
	var lifeDecreaseThread;
	var lifeDecreaseRate = 2000; //체력이 감소하는 속도

	
	//타겟 삭제 - 공격당했을때
	function doAttackTarget(target){
		var target = $(target);
		if(target.hasClass("item")){ //타겟이 아이템을 가진 경우
			var item = target.find(".item-id").val();
			usingItem(item);
			removeTarget(target, true);
			
		} else if(target.hasClass("fever-target")){ //피버타임 아이템인 경우
			gainScore(FEVER_POINT);	
			removeTarget(target, true);
			
		} else if(target.hasClass("boss-target")){ //보스타임 아이템인 경우
			gainScore(TARGET_POINT);	
			lifeRecovery(10);
			
		} else{ //노말 타겟인 경우
			gainScore(TARGET_POINT);
			lifeRecovery(5);
			removeTarget(target, true);
		}
	}
	
	function removeTarget(target, doEffect){
		if(doEffect){ //소리, 제거 효과
			removeSound.play();
			removeSound.currentTime = 0;
	
			target.addClass('removed'); //이미지 변경
			target.find(".toLeftDistance").val(0);
			target.find(".toTopDistance").val(5);
			setTimeout(function(){
				target.remove();
			}, 300); 
		} else{
			target.remove();
		}
		
		var moveTargetThreadID = target.find(".moveTargetThreadID").val();
		clearTimeout(moveTargetThreadID); //쓰레드종료
	}
	
	//모든 타겟 삭제
	function removeAllTarget(targetType, doEffect) {
		var targets = $(targetType);
		targets.each(function(){
			removeTarget($(this), doEffect);
		});
	}

	//체력 회복
	function lifeRecovery(recover) {
		$(".life-board").progressbar({value: life + recover});
	}
	
	//Item 사용
	function usingItem(item) {
		switch(item) {
		case ITEMS[0]: //타겟 속도 감소
			targetMoveSpeed = targetMoveSpeed + 50;
			setTimeout(function(){ 
				targetMoveSpeed = targetMoveSpeed - 50;	
			}, item.duration);
			break;
		case ITEMS[1]: //타겟속도 증가 및 파리채 면적 감소
			setTimeout(function(){ 
				
			}, item.duration);
			break;
		}
	}
	
	
	//아이템 생성
	function makeItem(){
		target.addClass("item");
		var item = Math.floor(Math.random() * ITEMS.length); //어떤 아이템을 부여할지 랜덤으로
		target.append($("<input>", {"class" : "item-id", type : "hidden", value : ITEMS[item]}));
	}
	
	//음악 시작
	function startAudio(playtimeType){ 
		playtimeType.play(); 
	}
	//음악 정지
	function stopAudio(playtimeType){ 
		playtimeType.pause(); 
	}

	//타겟을 만들어 떨어트림
	function makeTarget(){
		var targets = $(".target");
		if(targets.length > maxTargetNumber){ //최대 타겟수보다 많을경우 만들지 않음.
			return;
		}
		
		var playGround = $(".play-ground");
		var target = $("<div>", {"class" : "target"});
		target.append($("<div>", {"class" : "target-icon"}));
		target.append($("<input>", {"class" : "moveTargetThreadID", type : "hidden"}));
		target.append($("<input>", {"class" : "angle", type : "hidden"}));
		target.append($("<input>", {"class" : "toLeftDistance", type : "hidden"}));
		target.append($("<input>", {"class" : "toTopDistance", type : "hidden"}));
		target.appendTo(playGround);
		target.css("width", TARGET_WIDTH);
		target.css("height", TARGET_HEIGHT);
		
		//벌레가 나오는 위치 선정
		var startLine = Math.floor(Math.random() * 4);
		var left = 0;
		var top	 = 0;
		var angle = 0;
		
		switch(startLine){
		case 0://왼쪽, 상하랜덤
			left	= startX - HIDDEN_PADDING;
			top 	=  Math.random() * ((endY - TARGET_HEIGHT) - startY) + startY;
			angle 	= 90;
			break;
		case 1://오른쪽, 상하랜덤
			left	= endX - TARGET_WIDTH + HIDDEN_PADDING; 
			top 	=  Math.random() * ((endY - TARGET_HEIGHT) - startY) + startY;
			angle 	= 270;
			break;
		case 2://위쪽, 좌우랜덤
			left	=  Math.random() * ((endX - TARGET_WIDTH) - startX) + startX;
			top 	= startY - HIDDEN_PADDING;
			angle 	= 180;
			break;
		case 3://아래쪽, 좌우랜덤
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
			
			//x + , y +  
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
			
			//x + , y - 
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
			
			//x - , y - 			
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
			
			//x - , y + 
			if(angle > 3 * RIGHT_ANGLE && angle < 4 * RIGHT_ANGLE){
				// left 음수, top 양수
				toLeftDistance = -1 * moveDistance;
				toTopDistance = tangent * moveDistance * -1;
				angle = 3 * RIGHT_ANGLE + (RIGHT_ANGLE - angle % RIGHT_ANGLE);
			}
			
			/* if(Math.abs(toTopDistance) > moveDistance){
				console.log("1 " + toTopDistance + ", " + toLeftDistance + "===>");
				var ratio = Math.abs(toTopDistance/moveDistance);
				toTopDistance = 10;
				toLeftDistance /= ratio;
				console.log("2 " + ratio + "===>" + toTopDistance + ", " + toLeftDistance);
				console.log(" ");
			}		 */	
			
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
			
			//범위를 넘어간경우
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
			
			//재귀를 이용한 Interval
			var moveTargetThread = setTimeout(function(){ moveTarget(target)}, targetMoveSpeed);
			target.find(".moveTargetThreadID").val(moveTargetThread); 
		}
		
	}
	
	//게임 오버
	function gameover() {
		removeAllTarget(".target", false)// 모든 타겟 삭제
		stopPlayNormalTime();
		
		$(".wrap-fg").addClass("on");
		$(".wrap-gameover").addClass("on");
	}
	
	//점수 증가
	function gainScore(point){
		 var score = $(".score");
		 totalScore = totalScore + point;
		 score.text(totalScore);
	}
	
	
	/**** ========== 플레이 타임에 시작/정지 로직  =================== **/
	
	function startPlayNormalTime(){
		timeType = PLAYTIME_NORMAL;
		
		startMakeTarget(); //타겟 생성 쓰레드
		startLifeDecrease(); //생명력 감소 스레드 시작
	}
	
	function stopPlayNormalTime(){
		removeAllTarget(".target",false)// 모든 타겟 삭제
		
		stopMakeTarget();
		stopLifeDecrease();
	}
	
	function startPlayBossTime(){//보스타임 시작
		timeType = PLAYTIME_BOSS; //보스 타임으로 변경
		
		startLifeDecrease();
		stopAudio(backgroundAudio);
		startAudio(bossTimeBackgroundAudio);
		
		var playGround = $(".play-ground");
		var windowWidth = playGround.width();
		var windowHeight = playGround.height();
		var bosTarget = $("<div>", {"class" : "boss-target"});
		bosTarget.on("click", function(){
			bossTargetTouchCount = bossTargetTouchCount+1;
			if(bossTargetTouchCount == BOSS_TARGET_NUMBRT){ //보스 타겟 다섯번 터치하면	
				bossTargetTouchCount = 0;	
				stopPlayBossTime();
				startPlayFeverTime();
			}
		});
		
		//보스 타겟 설정
		bosTarget.append($("<div>", {"class" : "boss-target-icon"}));
		bosTarget.append($("<input>", {"class" : "toLeftDistance", type : "hidden"}));
		bosTarget.append($("<input>", {"class" : "toTopDistance", type : "hidden"}));
		bosTarget.appendTo(playGround);
		bosTarget.css("width", BOSS_TARGET_WIDTH);
		bosTarget.addClass("boss");
		bosTarget.css("height", BOSS_TARGET_HEIGHT);
		bosTarget.css("left", (windowWidth/2)-(BOSS_TARGET_WIDTH/2)); //보스 벌레 이미지 정중앙 배치
		bosTarget.css("top", (windowHeight/2)-(BOSS_TARGET_HEIGHT/2));
		bosTarget.find(".toLeftDistance").val(bossTargetLeftdistance);
		
		//보스 타겟 스레드 시작
		moveBossTargetThread = setInterval(function(){
			moveTarget();
		}, bossTargetMoveTime);
		
		//보스 이동 스레드
		function moveTarget(){
			var left= parseInt(bosTarget.css("left"));
			var toLeftDistance = parseInt(bosTarget.find(".toLeftDistance").val());
			
			left = left + toLeftDistance;
			
			//범위를 넘어간경우 //보완 필요
			if(left < (startX - HIDDEN_PADDING)
					|| left > (endX - BOSS_TARGET_WIDTH + HIDDEN_PADDING)
					|| top < (startY - HIDDEN_PADDING)
					|| top > (endY - BOSS_TARGET_HEIGHT + HIDDEN_PADDING)) {
				bossTargetLeftdistance = bossTargetLeftdistance-(bossTargetLeftdistance*2);
				bosTarget.find(".toLeftDistance").val(bossTargetLeftdistance);
				
			}  else{
				bosTarget.css("left", left);
			}
		}
		
	}
	
	//보스 타겟 이동 스레드 정지
	function stopPlayBossTime(){
		stopLifeDecrease(); //체력감소 중지
		
		clearTimeout(moveBossTargetThread);
		moveBossTargetThread = undefined;
		
		//보스 이미지 삭제 
		var bossTarget = $(".boss-target");
		bossTarget.remove();
		
		life = fullLife;
		$(".life-board").progressbar({value: life}); 	//체력 가득
	}
	
	//피버타겟 스레드 시작
	function startPlayFeverTime(){
		timeType = PLAYTIME_FEVER; //피버 타겟 모드
		//오디오 설정
		stopAudio(bossTimeBackgroundAudio); //보스 타임 백그라운드 음악 제거
		startAudio(feverTimeBackgroundAudio); //피버 타임 백그라운드 음악 시작
		
		makeFeverTargetThread = setInterval(makeFeverTarget, feverTargetMakeRate);
		
		//피버타임 메세지 나타남
		 var startFeverTimeMessage = setInterval(function(){
			
			var feverTimeMessage = $(".wrap-fevertime");
			feverTimeMessage.toggle();
		 }, '300');
		
		var startFeverTimeBackgroundChange = setInterval(function(){
			var playGround = $('.play-ground');
			
			var r =  Math.round( Math.random()*256);
			var g =  Math.round( Math.random()*256);
			var b =  Math.round( Math.random()*256);
			
			var rgb = r + "," + g + "," + b;
			playGround.css("background-color","rgb(" + rgb +")");
			
		}, '300');
		 
		function makeFeverTarget(){
			var playGround = $(".play-ground");
			var feverTarget = $("<div>", {"class" : "fever-target"});
			
			feverTarget.append($("<div>", {"class" : "fever-target-icon"}));
			feverTarget.append($("<input>", {"class" : "moveTargetThreadID", type : "hidden"}));
			feverTarget.css("width", FEVER_WIDTH);
			feverTarget.css("height", FEVER_HEIGHT);
			feverTarget.addClass("fever");
			feverTarget.appendTo(playGround);
		
			var left = 0;
			var top	 = 0;
			
			//보완필요
			left	=  Math.random() * ((endX - FEVER_WIDTH) - startX) + startX;
			top 	=   Math.random() * ((endY - FEVER_HEIGHT) - startY) + startY;
			
			//피버 타겟 위치 지정
			feverTarget.css("left", left);
			feverTarget.css("top", top);
		}
		
		setTimeout(function(){ // 피버 타임 백그라운드 색 변경 스레드 제거
			var playGround = $('.play-ground');
			clearTimeout(startFeverTimeBackgroundChange);
			startFeverTimeBackgroundChange = undefined; 
			playGround.css("background-color","rgba(0, 0, 0, 0)");
			}, 
			FEVER_TIME_SEC);
		
		setTimeout(function(){ // 피버 타임 메세지 스레드 제거
			clearTimeout(startFeverTimeMessage);
			startFeverTimeMessage = undefined; 
			var feverTimeMessage = $(".wrap-fevertime");
			feverTimeMessage.css("display","none");
			}, 
			FEVER_TIME_SEC);
		
		setTimeout(stopPlayFeverTime, FEVER_TIME_SEC); // 모든 피버 타겟 삭제
		setTimeout(startPlayNormalTime, FEVER_TIME_SEC);
	}
	
	//피버타겟 스레드 중지
	function stopPlayFeverTime(){
		clearInterval(makeFeverTargetThread);
		makeFeverTargetThread = undefined;
		removeAllTarget(".fever-target", false);
		
		//음악 설정
		stopAudio(feverTimeBackgroundAudio); //피버 타임 백그라운드 음악 제거
		startAudio(backgroundAudio); //노말 타임 백그라운드 음악 시작
	}
	
	/**  ============================================================================== **/
	
	
	//노말 타겟 생성 스레드
	function startMakeTarget() { //재귀를 이용한 Interval
		makeTarget();
		makeTargetThread = setTimeout(startMakeTarget, targetMakeRate);
	}
	
	//타겟 생성 스레드 정지
	function stopMakeTarget() {
		clearTimeout(makeTargetThread);
		makeTargetThread = undefined; //쓰레드 변수 초기화
	}
	
	//체력 감소 스레드
	function startLifeDecrease() { //재귀를 이용한 Interval
		life = life - 10;
		if(life <= 0){
			gameover();
			lifeDecreaseThread = undefined;
		} else {
			$(".life-board").progressbar({value: life});
			lifeDecreaseThread = setTimeout(startLifeDecrease, lifeDecreaseRate);
		}
	}
	
	//체력 감소 스레드 중지
	function stopLifeDecrease(){
		clearTimeout(lifeDecreaseThread);
		lifeDecreaseThread = undefined;
	}
	
	$(document).ready(function(){
		var attacker = $(".attacker");
		attacker.css("width", attackAreaWidth);
		attacker.css("height", attackAreaHeight);
		
		//초기화 (좌표)
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
			
			//노말 타임 백그라운드 음악
			backgroundAudio = new Audio('${pageContext.request.contextPath}/resources/audio/sample_bgm.mp3');
			//보스 타임 백그라운드 음악
			bossTimeBackgroundAudio = new Audio('${pageContext.request.contextPath}/resources/audio/sample_boss_bgm.mp3');
			//피버 타임 백그라운드 음악
			feverTimeBackgroundAudio = new Audio('${pageContext.request.contextPath}/resources/audio/sample_fever_bgm.mp3');
			//제거 소리
			removeSound = new Audio();
			removeSound.src = getContextPath() + "/resources/audio/sample_remove_sound.wav";
			removeSound.preLoad = true;
			removeSound.controls = true;
			removeSound.autoPlay = false;
		}
		
		startAudio(backgroundAudio);
		
		//체력게이지
		$( ".life-board" ).progressbar({
			classes: {
				  "ui-progressbar": "ui-corner-all",
				  "ui-progressbar-complete": "ui-corner-right",
				  "ui-progressbar-value": "ui-corner-left"
			},
     	 	value: life
 	   	});
			
		//화면 클릭 이벤트
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
        	
        	if(timeType == PLAYTIME_NORMAL){ //노말 타임
        		var targets = $(".target");
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
        				doAttackTarget(this);
        			}
        			
        		}); 
        		
        		checkCombo();
        		function plusCombo(){ //콤보 수 증가
        			comboNumber = comboNumber+1;
        		}
        		function checkCombo(){ //콤보 수 확인
        			if(attackedTargetNumber >= 2){
        				if(comboNumber == LIMIT_COMBO_NUMBER){ //보스타임 검사
        					comboNumber = 0;
        					stopPlayNormalTime(); 
        					startPlayBossTime(); //보스 타임 시작	
        				}
        				
        				else{
        					var combo = $(".combo");
            				combo.css("left", attackStartX);
            				combo.css("top", attackStartY);
            			
            				setTimeout(function(){combo.css("display", "block")}, 100);
            				setTimeout(function(){combo.css("display", "none")}, 1000);
            				
            				gainScore(COMBO_POINT); //콤보 점수 추가 획득		
            				plusCombo(); //콤보 증가
            				
        				}
        		
       				}
        		}
        	}
        	
        	else if(timeType == PLAYTIME_FEVER){ //피버 타임
        		var feverTargets = $(".fever-target");
        		feverTargets.each(function(){
        			var targetStartX= parseInt($(this).css("left"));
        			var targetStartY= parseInt($(this).css("top"));
        			var targetEndX	= targetStartX + FEVER_WIDTH;
        			var targetEndY 	= targetStartY + FEVER_HEIGHT;
        			
        			if(targetStartX > attackStartX 
        					&& targetEndX < attackEndX
        					&& targetStartY > attackStartY
        					&& targetEndY < attackEndY){

        				doAttackTarget(this);
        			}
        		}); 
        	}
        	
        	else if(timeType == PLAYTIME_BOSS){ //보스 타임
        		var bossTarget = $(".boss-target");
        		var targetStartX= parseInt(bossTarget.css("left"));
    			var targetStartY= parseInt(bossTarget.css("top"));
    			var targetEndX	= targetStartX + BOSS_TARGET_WIDTH;
    			var targetEndY 	= targetStartY + BOSS_TARGET_HEIGHT;
    			
    			if(targetStartX < attackStartX 
    					&& targetEndX > attackEndX
    					&& targetStartY < attackStartY
    					&& targetEndY > attackEndY){

    				doAttackTarget(bossTarget);
    			}
        	}
	    });
	
		//오디오 버튼 활성화 , 비활성화
		$(".bgm-source-board").on("click",function(e) {
			
			var audio;
			
			switch(timeType){
			case PLAYTIME_NORMAL :
				audio = backgroundAudio;
				break;	
			case PLAYTIME_FEVER : 
				audio = feverTimeBackgroundAudio;
				break;
			case PLAYTIME_BOSS :
				audio = bossTimeBackgroundAudio;
				break;
			}
			
			if($(this).attr('data-click-state') == 1) {
				$(this).attr('data-click-state', 0);
				startAudio(audio);			
				$(".bgm-source-board").css({"background":"url(resources/image/sample_stop_audio.jpg", 'background-repeat' : 'no-repeat', 'background-size' : 'contain'});} 
			else {
				$(this).attr('data-click-state', 1);		
				stopAudio(audio);			
				$(".bgm-source-board").css({"background":"url(resources/image/sample_start_audio.jpg", 'background-repeat' : 'no-repeat' ,'background-size' : 'contain'});}
		});
		
				
		startPlayNormalTime();
		//난이도UP 쓰레드 - 타겟이 빨리 떨어질수록, 타겟 만드는 속도는 빨라지도록
		/* fallingSpeedUpThread = setInterval(function(){
			fallingSpeed 	*= 0.97; 
			targetMakeRate 	*= 0.97;
		}, 1000); */
		
	})

</script>
<body>
	<div class="wrapper">
		<div class="wrap-fg"></div>
		<div class="wrap-gameover">
			<div class="gameover">
				<div class="gameover-icon"
					style="background-image: url('${pageContext.request.contextPath}/resources/image/icon_play_gameover.gif');"></div>
				<div class="gameover-message">GAME OVER</div>
			</div>
		</div>
		<div class="wrap-fevertime">
			<div class="fevertime">
				<%-- 	<div class="fevertime-icon"
					style="background-image: url('${pageContext.request.contextPath}/resources/image/icon_play_gameover.gif');"></div> --%>
				<div class="fevertime-message">FEVER TIME</div>
			</div>
		</div>

		<div class="head">
			<div class="bgm-source-board">
				<%-- <embed class="back-music-source"
					src="${pageContext.request.contextPath}/resources/audio/sample_bgm.mp3"
					autostart="true" hidden="true" loop="true"> --%>
			</div>
			<div class="score-board">
				<div class="score">0</div>
				<div class="combo">COMBO!!</div>
			</div>
			<div class="life-board"></div>
		</div>
		<div class="play-ground">
			<div class="attacker"></div>
		</div>
		<div class="footer"></div>
	</div>
</body>
</html>
