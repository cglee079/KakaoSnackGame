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
}

.back-music-source-board {
	width: 50px;
	height: 100%;
	position: absolute;
	left: 0;
	top: 0;
	display: inline-block;
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

.touch-place {
	position: absolute;
	left: 0;
	right: 0;
	bottom: 0;
	height: 100px;
	z-index: 2;
	background: #000;
	opacity: 0.7;
}

.candy {
	position: absolute;
	display: inline-block;
	width: 50px;
	height: 50px;
	z-index: 1;
	border-radius: 20px;
	background-repeat: no-repeat;
	background-size: contain;
	background-image: url("resources/image/sample_candy.png");
}
</style>

<script>
	var candyMakeRate = 1000; // 사탕이 생성되는 간격 , 1000 = 1초
	var candyFallings = []; // 쓰레드 보관
	var candies	= [];		
	var fallingSpeed = 100; // 사탕이 떨어지는 속도
	var candyIndex = 0; //사탕 인덱스값
	
	var startX;
	var startY;
	var endX;
	var endY;
	
	var totalScore = 0; //점수 
	
	//캔디 삭제 - 터치했을때, 다 떨어졌을때.
	function removeCandy(tg){
		tg.remove();
		var index = tg.find(".index").val();
		clearInterval(candyFallings[index]); //쓰레드종료
	}
	
	//사탕을 만들어 떨어트림
	function makeCandy(){
		var playGround = $(".play-ground");
		var candy = $("<div>", { "class" : "candy"});
		candies.push(candy);
		candy.appendTo(playGround);
		candy.append($("<input>", {"class" : "index", type : "hidden", value : candyIndex++})); //인덱스부여
		
		//candy의 X(좌,우)좌표를 랜덤하게 지정한다. 
		var candyX 	= Math.random() * (endX - startX) + startX;
		candy.offset({ "left": candyX });
		
		//사탕이 떨어지는 쓰레드
		var candyFalling = setInterval(function(){
			doFallCandy(candy);
		}, fallingSpeed);
		
		candyFallings.push(candyFalling);
		
		function doFallCandy(tg){
			var tg = candy;
			var top = tg.offset().top;
			var toTop = top + 10;
			tg.offset({ "top": toTop });
			
			// 사탕이 다떨어지는 순간
			if(toTop >= endY){ 
				removeCandy(tg);
			}
		}
	}
	
	//점수판 만들고 초기화함
	function initScore(){
		var scoreBoard = $(".score-board");
		var score = $("<div>", { "class" : "score"});
		score.appendTo(scoreBoard);
		score.text(totalScore);
	}
	
	//점수 증가
	function addScore(){
		 var score = $(".score");
	
		 //속도, 아이템 등 반영한 점수 증가 폭 설정 
		 var scoreInterval = function(){
			 return 10;
		 };
		 
		 totalScore =totalScore + scoreInterval();
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
		
		//점수 초기화
		initScore();
		
		//배경음악 설정
	    setBGM();
		function setBGM(){
	        var backMusicSourceBoard = $(".back-music-source-board");
			var backMusicSource = $("<embed>", { "class" : "back-music-source", src : "${pageContext.request.contextPath}/resources/bgm/sample_back_music.mp3", 
				hidden : "true",height: "0", width : "0", loop : "true", Autostart : "true" });
			backMusicSource.appendTo(backMusicSourceBoard); 
		} 
	
		//사탕 생성 쓰레드
		setInterval(function (){
			makeCandy();
		}, candyMakeRate);
		
		//터치이벤트 
		$(".touch-place").on("click", function(event){
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
					addScore();
					console.log("점수 UP!!");
					break;
				}				
			}
			
			
		})
	})
	
</script>
<body>


	<div class="wrapper">
		<div class="head">
			<div class="back-music-source-board"></div>
			<div class="score-board"></div>
		</div>
		<div class="play-ground">
			<div class="touch-place"></div>
		</div>
		<div class="footer"></div>
	</div>
</body>
</html>
