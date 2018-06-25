<%@ page pageEncoding="UTF-8" %>
<html>
<head>
<%@ include file="/WEB-INF/views/included/included_head.jsp" %>
<style>
	html, body, .wrapper{
		overflow-x : hidden;
	}
	
	.wrapper{
		display: flex;
		flex-flow : column nowrap;
		height: 100%;
		background-repeat: no-repeat;
		background-size: cover;
		background-image: url("resources/image/sample_back.png");
	}
	
	.head{
		width : 100%;
		height : 50px;
	}
	
	.play-ground{
		flex : 1;
		position: relative;
	}
	
	.footer{
		width : 100%;
		height : 100px;
	}
	
	.touch-place{
		position: absolute;
		left : 0;
		right : 0;
		bottom : 0;
		height : 100px;
		z-index: 2;
		background : #000;
		opacity: 0.7;
	}
	
	.candy{
		position: absolute;
		display : inline-block;
		width : 50px;
		height: 50px;
		z-index : 1;
		border-radius : 20px;
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
					console.log("점수 UP!!");
					break;
				}				
			}
		})
	})
	
</script>
<body>


<div class="wrapper">
	<div class="head"></div>
	<div class="play-ground">
		<div class="touch-place"></div>
	</div>
	<div class="footer"></div>
</div>
</body>
</html>
