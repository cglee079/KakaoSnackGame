<%@ page pageEncoding="UTF-8"%>
<html>
<head>
<%@ include file="/WEB-INF/views/included/included_head.jsp"%>
<style>
</style>

<body>
	<div class="wrapper">
		<div class="wrap-fg"></div>
		<div class="wrap-gameover">
			<div class="gameover">
				<div class="gameover-icon"
					style="background-image: url('${pageContext.request.contextPath}/resources/image/icon_play_gameover.gif');"></div>
				<div class="gameover-message">GAME OVER</div>
				<input type="button" class="home-button" value="홈"/>
				<input type="button" class="restart-button" value="다시하기"/>
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
			<div class="powerup">
				<%-- 	<div class="fevertime-icon"
					style="background-image: url('${pageContext.request.contextPath}/resources/image/icon_play_gameover.gif');"></div> --%>
				<div class="powerup-message">POWER UP</div>
			</div>
			<div class="spray">
				<%-- 	<div class="fevertime-icon"
					style="background-image: url('${pageContext.request.contextPath}/resources/image/icon_play_gameover.gif');"></div> --%>
				<div class="spray-message">Spray Attack</div>
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
		<div class="footer">
			<div class="power-item"></div>
			<div class="spray-item"></div>
			<div class="coin-item"></div>
			<div class="coin"></div>
		</div>
	</div>
</body>
</html>
