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
	position : relative;
	display: flex;
	flex-flow: column nowrap;
	height: 100%;
	max-width : 500px;
	background-repeat: no-repeat;
	background-size: cover;
	/* background-image: url("resources/image/bg_play.jpg"); */
}

.wrapper .wrap-fg{
	display : none;
	z-index: 1;
	position : absolute;
	left : 0;
	right : 0;
	top :0;
	bottom : 0;
	background: rgba(0,0,0,0.6);
}

.wrapper .wrap-fg.on{
	display : block;
}

.wrapper .wrap-gameover{
	display : none;
	z-index: 3;
	position : absolute;
	left : 0;
	right : 0;
	top :0;
	bottom : 0;
	background: rgba(0,0,0,0);
	justify-content: center;
	align-items: center;
}

.wrapper .wrap-gameover.on{
	display: flex;
}

.gameover{
	width : 300px;
	height : 400px;
	background: #FFF;
	border-radius: 10px;
	box-shadow: 0px 10px 20px #222;
	display: flex;
	flex-flow : column nowrap;
	justify-content: center;
	align-items: center;
}

.gameover .gameover-icon{
	width : 150px;
	height : 150px;
	background-repeat: no-repeat;
	background-size: contain;
	background-position: center;
	margin-bottom: 10px;
}

.gameover .gameover-message{
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
	background-image: url("resources/image/sample_music_button.png");
}

.score-board {
	width: 100px;
	height: 50px;
	margin: auto;
	display: inline-block;
}

.score {
	font-size : 2rem;
	font-weight: bold;
	text-align: center;
}

.play-ground {
	flex: 1;
	position: relative;
}

.footer {
	width: 100%;
	height: 100px;
	background: red;
}

.target .target-icon{
	background-image: url("resources/image/test.gif") !important;
}

.target {
	position: absolute;
	z-index: 2;
	display: flex;
	justify-content: center;
	align-items: center;	
	background: rgba(0,0,0,0);
	transition: transform 2s cubic-bezier(0.215, 0.61, 0.355, 1);
}

.target .target-icon{
	width : 80%;
	height : 80%;
	background-repeat: no-repeat;
	background-size: contain;
}

.target.candy 	.target-icon{ background-image: url("resources/image/sample_candy.png");}
.target.item 	.target-icon{ background-image: url("resources/image/sample_candy_item.png"); }
.target.removed .target-icon{ background-image: url("resources/image/effect.gif"); }

</style>

<script>
	//FINAL
	const PER_SCORE				= 10; 	// 타겟 하나당 점수
	const TARGET_WIDTH			= 50;	// 타겟 넓이
	const TARGET_HEIGHT			= 50;	// 타겟 높이
	const TOUCH_PADDING			= 10;
	const ITEM_CREATE_PERCENT	= 0.05;  // 아이템 생성 확률

	//001 모두지우기
	//002 잠깐 멈추기
	const ITEMS = ["ITM_001", "ITM_002"]; 
	
	var startX;
	var startY;
	var endX;
	var endY;
	
	var targetMakeRate 		= 500; 	// 타겟이 생성되는 간격 , 1000 = 1초
	var randAngleTime		= 5000; // 타겟이 이동방향을 바꾸는 쓰레드 간격.
	var totalScore			= 0; 	// 점수
	var makeTargetThread;
	var fallingSpeedUpThread;
	var moveDistance 	= 5;
	
	//클릭시 소리
	var removeSound = new Audio();
	removeSound.src = getContextPath() + "/resources/audio/sample_remove_sound.wav";
	removeSound.preLoad = true;
	removeSound.controls = true;
	removeSound.autoPlay = false;
	
	//타겟 삭제 - 터치했을때
	function doTouchTarget(target){
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
			gainScore();			
		}
		
		removeTarget(target, true);
	}
	
	function removeTarget(target, doEffect){
		if(doEffect){ //소리, 제거 효과
			removeSound.play();
			removeSound.currentTime = 0;
	
			target.addClass('removed'); //이미지 변경
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
		target.on("click", function(){
			doTouchTarget(this);
		});
		target.append($("<div>", {"class" : "target-icon"}));
		target.append($("<input>", {"class" : "randAngleThreadID", type : "hidden"}));
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
		var deg	 = 0;
		
		switch(startLine){
		case 0://왼쪽, 상하랜덤
			left= startX;
			top =  Math.random() * ((endY - TARGET_HEIGHT) - startY) + startY;
			deg	= 90;
			break;
		case 1://오른쪽, 상하랜덤
			left= endX - TARGET_WIDTH; 
			top =  Math.random() * ((endY - TARGET_HEIGHT) - startY) + startY;
			deg	= 270;
			break;
		case 2://위쪽, 좌우랜덤
			left=  Math.random() * ((endX - TARGET_WIDTH) - startX) + startX;
			top = startY;
			deg	= 180;
			break
		case 3://아래쪽, 좌우랜덤
			left=  Math.random() * ((endX - TARGET_WIDTH) - startX) + startX;
			top = endY - TARGET_HEIGHT;
			deg	= 0;
			break;
		}
		
		target.offset({ "left": left });
		target.offset({ "top": top });
		target.css("transform", "rotate(" + deg + "deg)");
	
		randAngle(target);
		function randAngle(target){
			var toLeftDistance 	= Math.floor(Math.random() * 2 * moveDistance) - moveDistance;
			var toTopDistance  	= Math.floor(Math.random() * 2 * moveDistance) - moveDistance;
			var tangentAngle	= toTopDistance/toLeftDistance 
			var angle			= Math.atan(tangentAngle) * 180;
			
			target.css("transform", "rotate(" + angle + "deg)");
			
			//재귀를 이용한 Interval
			target.find(".randAngleThreadID").val(randAngleThreadID);
			target.find(".angle").val(angle);
			target.find(".toLeftDistance").val(toLeftDistance);
			target.find(".toTopDistance").val(toTopDistance);
			
			var randAngleThreadID = setTimeout(function(){ randAngle(target)}, randAngleTime);
		}
		
		moveTarget(target);
		function moveTarget(target){
			var left= target.offset().left;
			var top = target.offset().top;
			var toLeftDistance = parseInt(target.find(".toLeftDistance").val());
			var toTopDistance = parseInt(target.find(".toTopDistance").val());
			
			left= left + toLeftDistance;
			top = top + toTopDistance;
			
			//범위를 넘어간경우
			if(left < startX
					||left > endX - TARGET_WIDTH
					|| top < startY
					|| top > endY - TARGET_HEIGHT) {
				var randAngleThreadID = target.find(".randAngleThreadID").val();
				var moveTargetThreadID = target.find(".moveTargetThreadID").val();
				
				clearTimeout(randAngleThreadID);
				randAngle(target);
			}  else{
				target.offset({ "left": left + toLeftDistance});
				target.offset({ "top": top + toTopDistance});
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
	function gainScore(){
		 var score = $(".score");
		 totalScore = totalScore + PER_SCORE;
		 score.text(totalScore);
	}
	
	
	function startMakeTarget() { //재귀를 이용한 Interval
		makeTarget();
		makeTargetThread = setTimeout(startMakeTarget, targetMakeRate);
	}
	
	function stopMakeTarget() {
		clearTimeout(makeTargetThread);
	}
	
	$(document).ready(function(){
		//초기화 (좌표)
		initXY();
		function initXY(){
			var playGround = $(".play-ground");
			startX 	= playGround.offset().left;
			startY	= playGround.offset().top;
			endX	= startX + playGround.width();
			endY	= startY + playGround.height();
		}
		
		//타겟 생성 쓰레드
		startMakeTarget();

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
				<div class="gameover-icon" style="background-image: url('${pageContext.request.contextPath}/resources/image/icon_play_gameover.gif');"></div>
				<div class="gameover-message">GAME OVER</div>
			</div>
		</div>
		
		<div class="head">
			<div class="bgm-source-board">
				<embed class="back-music-source" src="${pageContext.request.contextPath}/resources/audio/sample_bgm.mp3"
					autostart="true" hidden="true" loop="true" >
			</div>
			<div class="score-board">
				<div class="score">0</div>
			</div>
			<div></div>
		</div>
		<div class="play-ground"></div>
		<div class="footer"></div>
	</div>
</body>
</html>
