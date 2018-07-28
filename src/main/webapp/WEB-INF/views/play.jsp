<%@ page pageEncoding="UTF-8"%>
<html>
<head profile="http://www.w3.org/2005/10/profile">
<%@ include file="/WEB-INF/views/included/included_head.jsp"%>
<script src="${pageContext.request.contextPath}/resources/js/play.js"></script>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/play.css" />
</head>
<body>
	<input type="hidden" id="sound" value = '${sound}'>
	<div class="wrapper">
		<div class="wrap-fg"></div>
		<div class="wrap-gameover">
			<div class="gameover">
				<div class="gameover">GAME OVER</div>
			</div>
			<div class="gameover-menus">
				<div class="menu btn-regame" onclick="doRegame()"></div>
				<div class="menu btn-home" onclick="doHome()"></div>
			</div>
		</div>
		<div class="head">
			<div class="move_friends"></div>
			
			<div class="info-board">
				<div class="info stage">
					<div class="title">STAGE</div>
					<div class="value">0</div>
				</div>

				<div class="info time">
					<div class="title">TIME</div>	
					<div class="value">0</div>
				</div>

				<div class="info coin">
					<div class="title">COIN</div>
					<div class="value">0</div>
				</div>	
			</div>
			
		</div>
		
		<div class="wrap-life-progress">
			<div class="progress">
				<div class="progress-bar">
					<div class="crop-progress-bar"></div>
				</div>
			</div>
		</div>
			
		<div class="play-ground" onclick="doAttack(event)">
			<div class="attacker"></div>
			<!-- 공격범위 체크를 위해 임시로 만듬. 지울게 BY찬구 -->
		<!-- 	<div class="attacker-temp"></div>
			<style>
				.attacker-temp{
					display : none;
					position: absolute;
					background: red;
				}
			</style> -->
			<div class="combo-message"></div>
			<div class="stage-message"></div>
			<div class="lime_item_area"></div>
			
			<div class="effect spray"></div>
			<div class="effect lime"></div>
			<div class="effect portion"></div>
		</div>
		
		<div class="footer">
			
			<div class="itembar">
				<div class="itembar-item lime-item" onclick="usingItem(0)"></div>
				<div class="itembar-item spray-item" onclick="usingItem(1)"></div>
				<div class="itembar-item heart-item" onclick="usingItem(2)"></div>
			</div>
		</div>
	</div>
</body>
</html>
