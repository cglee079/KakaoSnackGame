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
		<div class="wrap-effect">
			<div class="effect lime">
				<%-- 	<div class="fevertime-icon"
					style="background-image: url('${pageContext.request.contextPath}/resources/image/icon_play_gameover.gif');"></div> --%>
				<div class="effect-message" >LIME</div>
			</div>
			<div class="effect spray">
				<div class="spray-effect">
				<%-- 	<div class="fevertime-icon"
					style="background-image: url('${pageContext.request.contextPath}/resources/image/icon_play_gameover.gif');"></div> --%>
				<div class="effect-message">Spray Attack</div>
				</div>
			</div>
			<div class="effect heart">
				<%-- 	<div class="fevertime-icon"
					style="background-image: url('${pageContext.request.contextPath}/resources/image/icon_play_gameover.gif');"></div> --%>
				<div class="effect-message">Heart UP</div>
			</div>
			
		</div>
		

		<div class="head">
			<div class="time-board">
				<div class="time">0</div>
			</div>
			<div class="wrap-life-progress">
				<div class="progress">
					<div class="progress-bar"></div>
				</div>
			</div>
		</div>
		<div class="play-ground">
			<div class="attacker"></div>
			<div class="combo-message">COMBO <span class="combo-count">1</span> !!</div>
			<div class="stage-message"></div>
			<div class="lime_item_area"></div>
		</div>
		<div class="itembar">
			<div class="itembar-item lime-item" onclick="usingItem(0)">
				<div class="item-icon lime-item-icon"></div>
				<div class="item-cost lime-item-cost">0</div>			
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
