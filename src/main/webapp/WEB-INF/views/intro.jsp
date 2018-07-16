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
	justify-content : space-between;
	height: 100%;
	background-repeat: no-repeat;
	background-size: cover;
	background-image: url("resources/image/sample_back.png");
}

.head {
	display: flex;
	justify-content: space-between;
	align-items : center;
	padding : 10px;
}

.head .icon-help{
	width: 50px;
	height: 50px;
	background-repeat: no-repeat;
	background-size: contain;
	background-image: url("resources/image/sample_music_button.png");
}

.head .icon-sound {
	width: 50px;
	height: 50px;
	background-repeat: no-repeat;
	background-size: contain;
	background-image: url("resources/image/sample_music_button.png");
}

.head .info{
	flex : 1;
	height: 40px;
	background: rgba(0,0,0,0.4);
	margin: 0px 5px;
	border-radius: 5px;
}

.contents{
	flex : 1;
	display: flex;
	align-items: center;
	justify-content: center;
}

.start-button {
	width: 50px;
	height: 50px;
	background-repeat: no-repeat;
	background-size: contain;
	z-index : 1;
	background-image: url("resources/image/sample_start_button.png");
}

.contents{
	height: 100px;
	border-radius: 10px;
	background: rgba(0,0,0,0.4);
	margin: 10px;
}

.footer {
	width: 100%;
	display: flex;
	justify-content: center;
	align-items: center;
}

.footer .btn{
 	background: red;
 	border-radius : 10px;
 	height: 70px;
 	margin: 10px;
 	flex: 1;
}

.footer .btn.btn-start{
 	background: red;
}

.footer .btn.btn-send-to{
	background: red;
}

</style>

<script>
	var isPlaySound = false;
	function doStartGame(){
		location.href = getContextPath() + "/play&isPlaySound=" + isPlaySound;
	}
	
	function doToggleSound(tg){
		var tg = $(tg);
		tg.toggleClass("on");
		
		if(tg.hasClass("on")){
			isPlaySound = true;
		} else{
			isPlaySound = false;
		}
	}
	
</script>
<body>
	<div class="wrapper">
		<div class="head">
			<div class="icon-help"></div>
			<div class="info info1"></div>
			<div class="info info2"></div>
			<div class="icon-sound on" onclick="toToggleSound(this)"></div>
		</div>
		
		<div class="empty" style="flex:1"></div>
		
		<div class="contents">
		</div>

		<div class="footer">
			<div class="btn btn-start" onclick="doStartGame()">시작</div>
			<div class="btn btn-send-to"></div>
		</div>
	</div>
</body>
</html>
