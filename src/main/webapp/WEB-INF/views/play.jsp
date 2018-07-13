<%@ page pageEncoding="UTF-8"%>
<html>
<head>
<%@ include file="/WEB-INF/views/included/included_head.jsp"%>
<script src="${pageContext.request.contextPath}/resources/js/play.js"></script>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/play.css" />
</head>
<body>
	<div class="wrapper">
		<div class="wrap-fg"></div>
		<div class="wrap-gameover">
			<div class="gameover">
				<div class="gameover-icon"
					style="background-image: url('${pageContext.request.contextPath}/resources/image/icon_play_gameover.gif');"></div>
				<div class="gameover-message">GAME OVER</div>
				<input type="button" class="home-button" value="홈" onclick="location.replace(getContextPath() + '/');"/>
				<input type="button" class="restart-button" value="다시하기" onclick="location.reload();"/>
			</div>
		</div>
		<div class="wrap-fevertime">
			<div class="fevertime">
				<%-- 	<div class="fevertime-icon"
					style="background-image: url('${pageContext.request.contextPath}/resources/image/icon_play_gameover.gif');"></div> --%>
				<div class="fevertime-message">FEVER TIME</div>
			</div>
		</div>
		
		<div class="wrap-effect">
			<div class="effect powerup">
				<%-- 	<div class="fevertime-icon"
					style="background-image: url('${pageContext.request.contextPath}/resources/image/icon_play_gameover.gif');"></div> --%>
				<div class="effect-message" >POWER UP</div>
			</div>
			<div class="effect spray">
				<%-- 	<div class="fevertime-icon"
					style="background-image: url('${pageContext.request.contextPath}/resources/image/icon_play_gameover.gif');"></div> --%>
				<div class="effect-message">Spray Attack</div>
			</div>
			<div class="effect heart">
				<%-- 	<div class="fevertime-icon"
					style="background-image: url('${pageContext.request.contextPath}/resources/image/icon_play_gameover.gif');"></div> --%>
				<div class="effect-message">Heart UP</div>
			</div>
		</div>
		

		<div class="head">
			<div class="bgm-source-board">
				<%-- <embed class="back-music-source"
					src="${pageContext.request.contextPath}/resources/audio/sample_bgm.mp3"
					autostart="true" hidden="true" loop="true"> --%>
			</div>
			<div class="score-board">
				<div class="score">0</div>
				<div class="combo">COMBO!!</div>
			</div>
			<div class="life-board"></div>
		</div>
		<div class="play-ground">
			<div class="attacker"></div>
		</div>
		<div class="itembar">
			<div class="itembar-item power-item" onclick="usingItem(0)">
				<div class="item-icon power-item-icon"></div>
				<div class="item-cost power-item-cost">0</div>			
				<div class="overlay-item on"></div>
			</div>
			
			<div class="itembar-item spray-item" onclick="usingItem(1)">
				<div class="item-icon spray-item-icon"></div>
				<div class="item-cost spray-item-cost">0</div>
				<div class="overlay-item on"></div>
			</div>
			
			<div class="itembar-item heart-item" onclick="usingItem(2)">
				<div class="item-icon heart-item-icon"></div>
				<div class="item-cost heart-item-cost">0</div>
				<div class="overlay-item on"></div>
			</div>
			
			<div class="itembar-item coin"></div>
		</div>
		
		<div class="itembar-cost">
		</div>
	</div>
</body>
</html>
