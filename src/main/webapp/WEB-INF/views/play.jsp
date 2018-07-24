<%@ page pageEncoding="UTF-8"%>

<html>
<head profile="http://www.w3.org/2005/10/profile">
<%@ include file="/WEB-INF/views/included/included_head.jsp"%>
<script src="${pageContext.request.contextPath}/resources/js/play.js"></script>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/play.css" />
</head>
<body>
	<div class="wrapper">
		<div class="wrap-fg"></div>
		<div class="wrap-gameover">
			<div class="gameover">
				<div class="gameover-icon"
					style="background-image: url('${pageContext.request.contextPath}/resources/image/icon_play_gameover.gif');"></div>
				<div class="gameover-message">GAME OVER</div>
				<input type="button" class="home-button" value="홈"
					onclick="location.replace(getContextPath() + '/');" /> <input
					type="button" class="restart-button" value="다시하기"
					onclick="location.reload();" />
			</div>
		</div>
		<div class="wrap-effect">
			<div class="effect lime">
				<div class="effect-message">LIME</div>
			</div>
			<div class="effect spray">
				<div class="spray-effect">
					<div class="effect-message">Spray Attack</div>
				</div>
			</div>
			<div class="effect heart">
				<div class="effect-message">Heart UP</div>
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
			
			<div class="wrap-life-progress">
				<div class="progress">
					<div class="progress-bar">
						<div class="crop-progress-bar"></div>
					</div>
				</div>
			</div>
		</div>
		<div class="play-ground">
			<div class="attacker"></div>
			<div class="combo-message">
				<!-- COMBO <span class="combo-count">1</span> !! -->
			</div>
			<div class="stage-message"></div>
			<div class="lime_item_area"></div>
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
