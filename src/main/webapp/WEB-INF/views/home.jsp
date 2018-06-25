<html>
<head>
<%@ include file="/WEB-INF/views/included/included_head.jsp" %>
<style>
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
	
	.candy{
		position: absolute;
		display : inline-block;
		width : 50px;
		height: 50px;
		border-radius : 20px;
		background-repeat: no-repeat;
		background-size: contain;
		background-image: url("resources/image/sample_candy.png");
	}
</style>

<script>
	var candyMakeRate = 1000; // 사탕이 생성되는 간격 , 1000 = 1초
	var candyFallings = []; // 쓰레드 보관
	var fallingSpeed = 100; // 사탕이 떨어지는 속도
	var candyIndex = 0; //사탕 인덱스값
	
	var startX;
	var startY;
	var endX;
	var endY;
	
	
	//사탕을 만들어 떨어트림
	function makeCandy(){
		var playGround = $(".play-ground");
		var candy = $("<div>", { "class" : "candy"});
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
				tg.remove();
				var index = tg.find(".index").val();
				clearInterval(candyFallings[index]); //쓰레드종료
			}
		}
	}
	
	$(document).ready(function(){

		//초기화 (좌표)
		init();
		function init(){
			var playGround = $(".play-ground");
			startX 	= playGround.offset().left; 
			startY	= playGround.offset().top;
			endX	= startX + playGround.width();
			endY	= startY + playGround.height();
		}
		
		setInterval(function (){
			makeCandy();
		}, candyMakeRate);
	})
	
</script>
<body>


<div class="wrapper">
	<div class="head"></div>
	<div class="play-ground"></div>
	<div class="footer"></div>
</div>
</body>
</html>
