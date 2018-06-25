<html>
<head>
<%@ include file="/WEB-INF/views/included/included_head.jsp" %>
<style>
	.wrapper{
		display: flex;
		flex-flow : column nowrap;
		height: 100%;
	}
	
	.head{
		width : 100%;
		height : 50px;
		background: #CCC;
	}
	
	.play-ground{
		flex : 1;
			
	}
	
	.footer{
		width : 100%;
		height : 100px;
		background: #CCC;
	}
	
	.candy{
		display : inline-block;
		width : 10px;
		height: 10px;
		background: #000;
	}
</style>

<script>
	var candyMakeRate = 1000 // 사탕이 생성되는 간격 , 1000 = 1초
	var candyFallings = []; // 쓰레드 보관
	var fallingSpeed = 3; // 사탕이 떨어지는 속도
	
	//사탕을 만들어 떨어트림
	function makeCandy(){
		var playGround = $(".play-ground");
		var candy = $("<div>", { "class" : "candy"});
		candy.appendTo(playGround);
		
		//candy의 X(좌,우)좌표를 랜덤하게 지정한다. 
		var startX 	= playGround.offset().left; 
		var endX	= startX + playGround.width();
		var candyX 	= Math.random() * (endX - startX) + startX;
		candy.offset({ "left": candyX });
		
		
		//사탕이 떨어지는 쓰레드
		var candyFalling = setInterval(function(){
			doFallCandy(candy);
		}, 100);
		
		candyFallings.push(candyFalling);
		
		function doFallCandy(tg){
			var tg = candy;
			var top = tg.offset().top;
			var toTop = top + fallingSpeed;
			tg.offset({ "top": toTop });
		}
	}
	
	$(document).ready(function(){
		//
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
