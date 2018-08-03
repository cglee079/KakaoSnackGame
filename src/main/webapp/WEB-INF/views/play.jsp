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
				<div class="gameover-time"></div>
			</div>
			<div class="gameover-menus">
				<div class="menu btn-restart" onclick="doRestart()"></div>
				<div class="menu btn-exit" onclick="doHome()"></div>
			</div>
		</div>
		
		<div class="wrap-pause">
			<div class="pause-title"></div>
			<div class="pause-menus">
				<div class="menu btn-regame" onclick="doRegame()"></div>
				<div class="menu btn-restart" onclick="doRestart()"></div>
				<div class="menu btn-home" onclick="doHome()"></div>
			</div>
		</div>
		
		<div class="wrap-stageup on">	
			<div class="value stage1 on"></div>
			<div class="value stage2 "></div>
			<div class="value stage3"></div>
			<div class="value stage4"></div>
		</div>
		
		<div class="header">
			<div class="info-board-t">
				<div class="progress">
					<div class="progress-bar">
						<div class="crop-progress-bar"></div>
					</div>
					
					<div class="progress-marking"></div>
					<div class="progress-apple"></div>
					<div class="progress-portion"></div>
				</div>
			
				<div class="info wrap-coin">
					<div class="value">0</div>
				</div>
				
				<div class="btn-pause" onClick="doPause()"></div>
			</div>
			
			<div class="info-board-c">
				<div class="info stage">
					<div class="value stage1 on"></div>
					<div class="value stage2"></div>
					<div class="value stage3"></div>
					<div class="value stage4"></div>
				</div>
				
				<div class="info time">
					<div class="value">0.00</div>
				</div>
				
				<div class="info empty"></div>
			</div>
			
			<div class="move-friends"></div>
		</div>
		
		<div class="wrap-play-ground">
			<div class="play-ground" onclick="doAttack(event)">
				<div class="attacker"></div>
				<!-- 공격범위 체크를 위해 임시로 만듬. 지울게 BY찬구 -->
			 	<div class="attacker-temp"></div>
				<style>
					.attacker-temp{
						position: absolute;
						background: red;
					}
				</style>
				
				<div class="combo-message">
					<div class="value combo1"></div>
					<div class="value combo2"></div>
					<div class="value combo3"></div>
					<div class="value combo4"></div>
					<div class="value combo5"></div>
					<div class="value combo6"></div>
					<div class="value combo7"></div>
				</div>
				
				<div class="effect lime"></div>
				<div class="effect spray"></div>
			</div>
		
			<div class="wrap-item">
				<div class="itembar">
					<div class="icon-basket-occupy"></div>
					<div class="itembar-item lime-item" onclick="usingItem(0)"></div>
					<div class="itembar-item portion-item" onclick="usingItem(2)"></div>
					<div class="itembar-item spray-item" onclick="usingItem(1)"></div>
				</div>
			</div>
			
			<div class="icon-basket">
				<div class="value status-100 on"></div>
				<div class="value status-60"></div>
				<div class="value status-30"></div>
				<div class="value status-died"></div>
			</div>
				
		</div>
	</div>
</body>
</html>
