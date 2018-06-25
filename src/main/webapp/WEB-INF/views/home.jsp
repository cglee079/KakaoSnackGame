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
	var candyFallings = [];
	var speed = 3;
	
	//사탕을 만들어 떨어트림
	function makeCandy(){
		var playGround = $(".play-ground");
		var candy = $("<div>", { "class" : "candy"});
		candy.appendTo(playGround);
		
		//candy의 X(좌,우)좌표를 랜덤하게 생성한다. 
		var startX 	= playGround.offset().left;
		var endX	= startX + playGround.width();
		var candyX 	=Math.random() * (endX - startX) + startX;
		
		candy.offset({ "left": candyX });
		
		
		var candyFalling = setInterval(function(){
			doFallCandy(candy);
		}, 100);
		
		candyFallings.push(candyFalling);
		
		//사탕이 떨어지는 쓰레드
		function doFallCandy(tg){
			var tg = candy;
			var top = tg.offset().top;
			
			var toTop = top + speed;
			tg.offset({ "top": toTop });
		}
	}
	
	$(document).ready(function(){
		//테스트로 캔디를 10개 생성해보자~
		for(var i = 0; i < 10; i++){
			makeCandy();
		}
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
