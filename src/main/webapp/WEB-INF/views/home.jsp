<%@ page pageEncoding="UTF-8"%>
<html>
<head>
<%@ include file="/WEB-INF/views/included/included_head.jsp"%>
<style>
html, body, .wrapper {
	overflow-x: hidden;
}

.wrapper {
	display: flex;
	flex-flow: column nowrap;
	height: 100%;
	background-repeat: no-repeat;
	background-size: cover;
	background-image: url("resources/image/sample_back.png");
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
	position: absolute;
	top: 0;
	left: 0;
	width: 100%;
	height: 100%;
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
}

.candy {
	position: absolute;
	display: inline-block;
	z-index: 1;
	border-radius: 20px;
	background-repeat: no-repeat;
	background-size: contain;
	background-image: url("resources/image/sample_candy.png");
}
</style>

<script>
	//CONST
	var CANDY_MAKE_RATE = 1000; // 사탕이 생성되는 간격 , 1000 = 1초
	var FALLING_SPEED 	= 100; 	// 사탕이 떨어지는 속도
	var PER_SCORE		= 10; 	// 캔디 하나당 점수
	var CANDY_WIDTH		= 50;	// 캔디 넓이
	var CANDY_HEIGHT	= 50;	// 캔디 높이
	
	var startX;
	var startY;
	var endX;
	var endY;
	
	var totalScore = 0; //점수
	var candies	= [];	
	var candyIndex 	= 0; //사탕 인덱스값
	
	//캔디 삭제 - 터치했을때, 다 떨어졌을때.
	function removeCandy(tg){
		tg.remove();
		var intervalId = tg.find(".intervalID").val();
		var index = candies.indexOf(tg);
		if (index > -1) {
			candies.splice(index, 1);
		}
		
		clearInterval(intervalId); //쓰레드종료
	}
	
	//사탕을 만들어 떨어트림
	function makeCandy(){
		var playGround = $(".play-ground");
		var candy = $("<div>", { "class" : "candy"});
		candies.push(candy);
		candy.appendTo(playGround);
		candy.css("width", CANDY_WIDTH);
		candy.css("height", CANDY_HEIGHT);
		
		//candy의 X(좌,우)좌표를 랜덤하게 지정한다. 
		var candyX 	= Math.random() * ((endX - CANDY_WIDTH) - startX) + startX;
		candy.offset({ "left": candyX });
		
		//사탕이 떨어지는 쓰레드
		var candyFalling = setInterval(function(){
			doFallCandy(candy);
		}, FALLING_SPEED);
		candy.append($("<input>", {"class" : "intervalID", type : "hidden", value : candyFalling})); //쓰레드ID
		
		function doFallCandy(tg){
			var tg = candy;
			var top = tg.offset().top;
			var toTop = top + 10;
			tg.offset({ "top": toTop });
			
			// 사탕이 다떨어지는 순간
			if(toTop - CANDY_HEIGHT >= endY){  
				removeCandy(tg);
			}
		}
	}
	
	//점수 증가
	function gainScore(){
		 var score = $(".score");
		 totalScore = totalScore + PER_SCORE;
		 score.text(totalScore);
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
		
		//사탕 생성 쓰레드
		setInterval(function (){
			makeCandy();
		}, CANDY_MAKE_RATE);
		
		//터치이벤트 
		$(".play-ground").on("click", function(event){
			var x = event.pageX;
			var y = event.pageY;
			
			for(var i = 0; i < candies.length; i++){
				var candy = candies[i];
				var candySX = candy.offset().left; 	//startX
				var candySY = candy.offset().top;	//startY
				var candyEX	= candySX + candy.width(); // endX
				var candyEY	= candySY + candy.height(); // endY
				
				if( x > candySX && x < candyEX 	&& y > candySY 	&& y < candyEY){
					removeCandy(candy);
					gainScore();
					break;
				}				
			}
			
			
		})
	})
	
</script>
<body>
	<div class="wrapper">
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
		<div class="play-ground">
		</div>
		<div class="footer"></div>
	</div>
</body>
</html>
