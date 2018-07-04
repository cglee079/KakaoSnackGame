<!-- setInterval 쓰지말기, 동적으로 속도 바꿀수 없음. -->
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
	const PER_SCORE			 	  = 1000;	// 타겟 하나당 점수
	const COMBO_SCORE			  = 2000;	// 콤보 시 타겟 하나당 점수
	const FEVER_PER_SCORE		  = 3000;	// 피버 타겟 하나당 점수
	const TARGET_WIDTH			  = 50;		// 타겟 넓이
	const TARGET_HEIGHT			  = 50;		// 타겟 높이
	const FEVER_TARGET_WIDTH      = 50;		// 피버  타겟 넓이
	const FEVER_TARGET_HEIGHT     = 50;		// 피버 타겟 높이
	const HIDDEN_PADDING		  = 0;		// 숨겨진 공간
	const ITEM_CREATE_PERCENT	  = 0.05;	// 아이템 생성 확률
	const RIGHT_ANGLE 			  = 90;
	const LIMIT_COMBO_NUMBER	  = 2;		// 보스타임이 되기까지 콤보 수/ n번 때리면 보스타임 시작
	const BOSS_TARGET_NUMBRT	  = 10;     // 보스 터치 제한 횟수
	const BOSS_TARGET_LEFTDISTANCE= 30;
	const BOSS_TARGET_WIDTH		  = 300;	// 보스 타겟 넓이
	const BOSS_TARGET_HEIGHT	  = 300;	// 보스 타겟 높이
	const RECOVERY_DEGREE   	  = 10;     // 체력 회복 수치
	
	//001 모두지우기,지속시간
	//002 잠깐 멈추기
	const ITEMS = [{item_type :"ITM_001", item_duration :5000}, {item_type :"ITM_002", item_duration :5000}]; 
	
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
	var feverTargetThread;
	var moveDistance 		= 10;
	var maxTargetNumber 	= 5;	//최대 타겟 수 
	var comboNumber 		= 0; 	//콤보 횟수 저장
	var targetMoveSpeed 	= 100; 	//타겟 스피드
	var bossTargetLeftdistance= 10; //보스 타겟 왼쪽 이동 거리
	var bossTargetTouchCount= 0; 	//보스 타겟 터치 카운트 
	var timeType 			= 0; 	//게임 타입 0 - 노말 모드 , 1 - 피버모드, 2-보스모드
	var fullLife 			= 100; 	//총 생명력
	
	//targeting 범위
	var attackAreaWidth 	= 150;
	var attackAreaHeight    = 150;
	
	//배경음악
	var backgroundAudio;
	
	//클릭시 소리
	var removeSound = new Audio();
	removeSound.src = getContextPath() + "/resources/audio/sample_remove_sound.wav";
	removeSound.preLoad = true;
	removeSound.controls = true;
	removeSound.autoPlay = false;
	
	//체력
	var life=fullLife;
	var lifeDecreaseThread;
	var lifeDecreaseRate = 2000; //체력이 감소하는 속도

	
	
	//타겟 삭제 - 공격당했을때
	function doAttackTarget(target){
		var target = $(target);
		if(target.hasClass("item")){ //타겟이 아이템을 가진 경우
	
			var itemObj = target.find(".item-id").val();
			var itemID = itemObj.item_type;
			var duringTime = itemObj.item_duration;
			
			using_item(itemID,duringTime);
			
			removeTarget(target, true);
		
			
		}else if(target.hasClass("fever")){ //피버타임 아이템인 경우
			gainScore(FEVER_PER_SCORE);	
		
			removeTarget(target, true);
		}
		else if(target.hasClass("boss")){ //보스타임 아이템인 경우
			gainScore(PER_SCORE);	
		
			var recovery_degree = 10;
			life_recovery(recovery_degree);
		}		
		else{ //노말 타겟인 경우
			gainScore(PER_SCORE);
			
			//체력증가
			var recovery_degree = 5;
			life_recovery(recovery_degree);
			
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

	//아이템 생성
	function makeItem(){
		target.addClass("item");
		var item = Math.floor(Math.random() * ITEMS.length); //어떤 아이템을 부여할지 랜덤으로
		target.append($("<input>", {"class" : "item-id", type : "hidden", value : ITEMS[item]}));
	}
	
	//타겟을 만들어 떨어트림
	function makeTarget(){
		
		var playGround = $(".play-ground");
		var target = $("<div>", {"class" : "target"});
		/* target.on("click", function(){
			doTouchTarget(this);
		}); */
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
			var moveTargetThreadID = setTimeout(function(){ moveTarget(target)}, targetMoveSpeed);
			target.find(".moveTargetThreadID").val(moveTargetThreadID); 
		}
		
	}
	
	//게임 오버
	function gameover() {
		removeAllTarget(".target",false)// 모든 타겟 삭제
		stopMakeTarget(); // 타겟 생성 중지
		stopTargetNumber(); //타겟 수 체크 스레드 중지
		stopLifeDecrease(); //생명 감소 스레드 중지
		
		$(".wrap-fg").addClass("on");
		$(".wrap-gameover").addClass("on");
	}
	
	//점수 증가
	function gainScore(scoreType){
		 var score = $(".score");
		 totalScore = totalScore + scoreType;
		 score.text(totalScore);
	}
	
	//타겟 수 체크 
	function checkTargetNumber(){ 
		var targets = $(".target");
		var targetNumber = 0;
		targets.each(function(){
			targetNumber = targetNumber+1;			
		});
		
		if(targetNumber >= maxTargetNumber){ //만약 타겟수가 max 이상이라면 생성 쓰레드 정지
			stopMakeTarget();
		}
		else{
			if(makeTargetThread == null)
				startMakeTarget();
		}
	}
	
	//노말 타겟 생성 스레드
	function startMakeTarget() { //재귀를 이용한 Interval
		makeTarget();
		makeTargetThread = setTimeout(startMakeTarget, targetMakeRate);
	}
	
	//타겟 수 체크 스레드 시작
	function startTargetNumber(){ 
		checkTargetThread = setInterval(function(){
			checkTargetNumber();
		},targetMakeRate);
	}	
	
	//타겟 생성 스레드 정지
	function stopMakeTarget() {
		clearTimeout(makeTargetThread);
		makeTargetThread = null; //쓰레드 변수 초기화
	}
	
	//타겟 수 체크 스레드 정지
	function stopTargetNumber(){
		clearTimeout(checkTargetThread);
		checkTargetThread = null;
	}
	
	//보스 타겟 이동 스레드 정지
	function stopMoveBossTarget(){
		clearTimeout(moveBossTargetThread);
		moveBossTargetThread = null;
		
		//보스 이미지 삭제 
		var bossTarget = $(".boss-target");
		bossTarget.remove();
	
		timeType = 1; //피버 타겟 모드
		startFeverTarget();
		
		//체력감소 중지
		stopLifeDecrease();
		//체력 가득
		$(".life-board").progressbar({value: fullLife});
		life = fullLife;
		
		// 모든 피버 타겟 삭제
		setTimeout(stopFeverTarget, '5000');	
		setTimeout(startTargetNumber, '5000');
		setTimeout(startMakeTarget, '5000');
		setTimeout(startLifeDecrease, '5000');
	}
	
	//피버타겟 스레드 중지
	function stopFeverTarget(){
		clearTimeout(feverTargetThread);
		feverTargetThread = null;
		removeAllTarget(".fever-target",false);
		timeType = 0; //노말 타겟 모드
	}
	
	//피버타겟 스레드 시작
	function startFeverTarget(){
		makeFeverTarget();
		feverTargetThread = setTimeout(startFeverTarget, feverTargetMakeRate);
	}
	
	//피버 타겟 생성 스레드
	function makeFeverTarget(){
		
		var playGround = $(".play-ground");
		var feverTarget = $("<div>", {"class" : "fever-target"});
		
		feverTarget.append($("<div>", {"class" : "fever-target-icon"}));
		feverTarget.append($("<input>", {"class" : "moveTargetThreadID", type : "hidden"}));
		feverTarget.css("width", FEVER_TARGET_WIDTH);
		feverTarget.css("height", FEVER_TARGET_HEIGHT);
		feverTarget.addClass("fever");
		feverTarget.appendTo(playGround);
	
		var left = 0;
		var top	 = 0;
		
		//보완필요
		left	=  Math.random() * ((endX - FEVER_TARGET_WIDTH) - startX) + startX;
		top 	=   Math.random() * ((endY - FEVER_TARGET_HEIGHT) - startY) + startY;
		
		//피버 타겟 위치 지정
		feverTarget.css("left", left);
		feverTarget.css("top", top);
		
	}
	
	//체력 감소 스레드
	function startLifeDecrease() { //재귀를 이용한 Interval
		life = life - 10;
		$(".life-board").progressbar({value: life});
		lifeDecreaseThread = setTimeout(startLifeDecrease, lifeDecreaseRate);
	}
	
	//체력 회복
	function life_recovery(recover) {
		$(".life-board").progressbar({value: life + recover});
		
	}
	//체력 감소 스레드 중지
	function stopLifeDecrease(){
		clearTimeout(lifeDecreaseThread);
		lifeDecreaseThread = null;
	}

	//체력 확인 쓰레드
	var checkLife = setInterval(function() {
		if(life <= 0) {
			gameover();
			lifeDecreaseThread = null;
		}
	},500);
	
	//Item 사용
	function using_item(item_type,time) {
		switch(item_type) {
			case 01: //타겟 속도 감소
				moveTargetThread = moveTargetThread + 50;
				setTimeout(function(){ turnBack_item(item_type); }, time);
				break;
				
			case 02: //타겟속도 증가 및 파리채 면적 감소
				setTimeout(function(){ turnBack_item(item_type); }, time);
				break;
			
		}
	}
	
	//Item 효과 되돌리기
	function turnBack_item(item_type) {
		switch(item_type) {
			case 01: //타겟 속도 감소
				moveTargetThread = moveTargetThread - 50;
				break;
			case 02: //타겟속도 증가 및 파리채 면적 감소
				break;		
		}	
	}
	
	function startBossTime(){//보스타임 시작
		
		//기존 스레드 모두 정지
		stopTargetNumber();
		stopMakeTarget();
		
		removeAllTarget(".target",false)// 모든 타겟 삭제
	
		var playGround = $(".play-ground");
		var windowWidth = playGround.width();
		var windowHeight = playGround.height();
		var bosTarget = $("<div>", {"class" : "boss-target"});
		bosTarget.on("click", function(){
			//보스 타겟 터치 이벤트
			
			bossTargetTouchCount = bossTargetTouchCount+1;
			
			if(bossTargetTouchCount == BOSS_TARGET_NUMBRT){ //보스 타겟 다섯번 터치하면	
				//보스 스레드 정지 
				stopMoveBossTarget();
				bossTargetTouchCount = 0;	
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
		startMoveBossTarget();
		function startMoveBossTarget(){
			moveBossTargetThread = setInterval(function(){
				moveTarget();
			},bossTargetMoveTime);
		}
		
		//보스 이동 스레드
		function moveTarget(){
			var left= parseInt(bosTarget.css("left"));
			var toLeftDistance = parseInt(bosTarget.find(".toLeftDistance").val());
			
			left= left + toLeftDistance;
			
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
			
		startMakeTarget(); //타겟 생성 쓰레드
		startTargetNumber(); //타겟 수 체크 스레드 시작
		startLifeDecrease(); //생명력 감소 스레드 시작
		startAudio(); //오디오 시작
	
		function startAudio(){
			backgroundAudio = new Audio('${pageContext.request.contextPath}/resources/audio/sample_bgm.mp3');
			backgroundAudio.play();
		}
		
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
        	//범위 안에 있는지 검사
        	
        	if(timeType == 0){ //노말 타임
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
        					startBossTime(); //보스 타임 시작	
        					timeType = 2; //보스 타임으로 변경
        				}
        				else{
        					var combo = $(".combo");
            				combo.css("left", attackStartX);
            				combo.css("top", attackStartY);
            			
            				setTimeout(function(){combo.css("display", "block")}, 100);
            				setTimeout(function(){combo.css("display", "none")}, 1000);
            				
            				gainScore(COMBO_SCORE); //콤보 점수 추가 획득		
            				plusCombo(); //콤보 증가
            				
        				}
        		
       				}
        		}
        	}
        	else if(timeType == 1){ //피버 타임
        		var feverTargets = $(".fever-target");
        		feverTargets.each(function(){
        			var targetStartX= parseInt($(this).css("left"));
        			var targetStartY= parseInt($(this).css("top"));
        			var targetEndX	= targetStartX + FEVER_TARGET_WIDTH;
        			var targetEndY 	= targetStartY + FEVER_TARGET_HEIGHT;
        			
        			if(targetStartX > attackStartX 
        					&& targetEndX < attackEndX
        					&& targetStartY > attackStartY
        					&& targetEndY < attackEndY){

        				doAttackTarget(this);
        			}
        			
        		}); 
        	}
        	
        	else if(timeType == 2){ //보스 타임
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
				
				if($(this).attr('data-click-state') == 1) {
					$(this).attr('data-click-state', 0)
					backgroundAudio.play();
					$(".bgm-source-board").css({"background":"url(resources/image/sample_stop_audio.jpg", 'background-repeat' : 'no-repeat', 'background-size' : 'contain'});
					} else {
					$(this).attr('data-click-state', 1)
					backgroundAudio.pause();
					$(".bgm-source-board").css({"background":"url(resources/image/sample_start_audio.jpg", 'background-repeat' : 'no-repeat' ,'background-size' : 'contain'});
					}
			});
		
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
