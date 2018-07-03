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
	const PER_SCORE				= 1000; 	// 타겟 하나당 점수
	const COMBO_SCORE			= 2000; 	// 콤보 시 타겟 하나당 점수
	const TARGET_WIDTH			= 50;	// 타겟 넓이
	const TARGET_HEIGHT			= 50;	// 타겟 높이
	const HIDDEN_PADDING		= 0;	// 숨겨진 공간
	const ITEM_CREATE_PERCENT	= 0.05;  // 아이템 생성 확률
	const RIGHT_ANGLE = 90;

	//001 모두지우기
	//002 잠깐 멈추기
	const ITEMS = ["ITM_001", "ITM_002"]; 
	
	var startX;
	var startY;
	var endX;
	var endY;
	
	var targetMakeRate 		= 600; 	// 타겟이 생성되는 간격 , 1000 = 1초
	var randAngleTime		= 5000; // 타겟이 이동방향을 바꾸는 쓰레드 간격.
	var totalScore			= 0; 	// 점수
	var makeTargetThread;
	var fallingSpeedUpThread;
	var moveDistance 	= 10;
	var maxTargetNumber = 5; //최대 타겟 수 
	
	//targeting 범위
	var attackAreaWidth = 150;
	var attackAreaHeight = 150;
	//배경음악
	var backgroundAudio;
	
	//클릭시 소리
	var removeSound = new Audio();
	removeSound.src = getContextPath() + "/resources/audio/sample_remove_sound.wav";
	removeSound.preLoad = true;
	removeSound.controls = true;
	removeSound.autoPlay = false;
	
	//타겟 삭제 - 공격당했을때
	function doAttackTarget(target){
		var target = $(target);
		if(target.hasClass("item")){ //타겟이 아이템을 가진 경우
	
			var itemID = target.find(".item-id").val();
			switch(itemID){
			case ITEMS[0]: doItem001(); break;
			case ITEMS[1]: doItem002(); break;
			}
			
			function doItem001(){ // 모든 사탕 삭제, 아이템은 삭제X
				removeAllCandy(true);
			}
			
			function doItem002(){ // 떨어지는속도, 타겟 생성 잠깐 멈추기
				fallingDistance = 0; // 속도 멈춤
				stopMakeTarget(); // 생성 중지
				
				setTimeout(function(){
					fallingDistance = 10;
					startMakeTarget();
				}, 2000);
			}
			
			function doItem003(){ // ??
					
			}
			
		} else{
			gainScore(PER_SCORE);			
		}
		
		removeTarget(target, true);
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
		
		var threadID = target.find(".threadID").val();
		clearTimeout(threadID); //쓰레드종료
	}
	
	//모든 캔디 삭제 
	function removeAllCandy(doEffect) {
		var candies = $(".candy");
		candies.each(function(){
			removeTarget( $(this), doEffect);
		});
	}
	
	//모든 타겟 삭제
	function removeAllTarget(doEffect) {
		var targets = $(".target");
		targets.each(function(){
			removeTarget($(this), doEffect);
		});
	}

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
			var moveTargetThreadID = setTimeout(function(){ moveTarget(target)}, 100);
			target.find(".moveTargetThreadID").val(moveTargetThreadID);
		}
		
	}
	
	//게임 오버
	function gameover() {
		removeAllTarget(false)// 모든 타겟 삭제
		stopMakeTarget(); // 타겟 생성 중지
		
		$(".wrap-fg").addClass("on");
		$(".wrap-gameover").addClass("on");
	}
	
	//점수 증가
	function gainScore(scoreType){
		 var score = $(".score");
		 totalScore = totalScore + scoreType;
		 score.text(totalScore);
	}
	

	function checkTargetNumber(){ //타겟 수 체크 
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
	
	function startMakeTarget() { //재귀를 이용한 Interval
		makeTarget();
		makeTargetThread = setTimeout(startMakeTarget, targetMakeRate);
	}	
	function startTargetNumber(){ //타겟 수 체크
		setInterval(function(){
			checkTargetNumber();
		},targetMakeRate);
	}	
	function stopMakeTarget() {
		clearTimeout(makeTargetThread);
		makeTargetThread = null; //쓰레드 변수 초기화
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
		
		//타겟 생성 쓰레드
		startMakeTarget();
		startTargetNumber();
		//오디오 시작
		startAudio();
		function startAudio(){
			backgroundAudio = new Audio('${pageContext.request.contextPath}/resources/audio/sample_bgm.mp3');
			backgroundAudio.play();
		}
		
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
    		function checkCombo(){
    			if(attackedTargetNumber >= 2){
    				var combo = $(".combo");
    				combo.css("left", attackStartX);
    				combo.css("top", attackStartY);
    				setTimeout(function(){combo.css("display", "block")}, 100);
    				setTimeout(function(){combo.css("display", "none")}, 1000);
    				
    				gainScore(COMBO_SCORE);		
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
			<div class="bgm-source-board" >
				<%-- <embed class="back-music-source"
					src="${pageContext.request.contextPath}/resources/audio/sample_bgm.mp3"
					autostart="true" hidden="true" loop="true"> --%>
			</div>
			<div class="score-board">
				<div class="score">0</div>
				<div class="combo">COMBO!!</div>
			</div>
			<div></div>
		</div>
		<div class="play-ground">
			<div class="attacker"></div>
		</div>
		<div class="footer"></div>
	</div>
</body>
</html>
