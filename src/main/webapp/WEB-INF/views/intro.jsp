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
	justify-content: space-between;
	height: 100%;
	width: 100%;
	background-repeat: no-repeat;
	background-size: cover;
	background-image: url("resources/image/intro/bg_intro.jpg");
}

/* @media screen and (min-width: 751px) {
	.wrapper {
		margin-top: -300px; 
		height: 100%;
		background-size: cover;
	}
}

} */
.head {
	display: flex;
	justify-content: space-between;
	align-items: center;
	padding: 15px;
}

.head .icon-help {
	width: 40px;
	height: 40px;
	background-repeat: no-repeat;
	background-size: contain;
	background-image: url("resources/image/intro/btn_intro_help.png");
}

.head .icon-sound {
	width: 40px;
	height: 40px;
	background-repeat: no-repeat;
	background-size: contain;
	background-image: url("resources/image/intro/btn_intro_sound_on.png");
}

.title {
	margin-top : -20;
	height : 160px;
	background-size: contain;
	background-repeat: no-repeat;
	background-position: center center;
	background-image: url("resources/image/intro/icon_intro_title.png");
}

.footer {
	display: flex;
	justify-content: center;
	align-items: center;
	margin : 0px 15px;
	padding-bottom: 20px;	
}

.footer .btn {
	border-radius: 10px;
	height: 80px;
	margin: 5px;
	flex: 1;
}

.footer .btn.btn-start {
	background-size: contain;
	background-image: url("resources/image/intro/btn_intro_start.png");
	background-repeat: no-repeat;
}

.footer .btn.btn-send-to {
	background: red;
}
</style>

<script>
	var isPlaySound = false;
	function doStartGame() {
		location.href = getContextPath() + "/play"; //&isPlaySound=" + isPlaySound; */
	}

	function doToggleSound(tg) {
		var tg = $(tg);
		tg.toggleClass("on");

		if (tg.hasClass("on")) {
			isPlaySound = true;
		} else {
			isPlaySound = false;
		}
	}
</script>
<body>
	<div class="wrapper">
		<div class="head">
			<div class="icon-help"></div>
			<div class="icon-sound on" onclick="toToggleSound(this)"></div>
		</div>
		<div class="title"></div>
		<div class="empty" style="flex: 1"></div>
		<div class="footer">
			<div class="btn btn-start" onclick="doStartGame()"></div>
			<div class="btn btn-start" onclick="doStartGame()"></div>
		</div>
	</div>
</body>
</html>
