<%@ page pageEncoding="UTF-8"%>
<html>
<head>
<%@ include file="/WEB-INF/views/included/included_head.jsp"%>
<script src="${pageContext.request.contextPath}/resources/js/play.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/intro.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/help.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/common.js"></script>
<script src="${pageContext.request.contextPath}/resources/js/common-sound.js"></script>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/common.css" />
<link rel="stylesheet" 	href="${pageContext.request.contextPath}/resources/css/intro.css" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/play.css" />
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/help.css" />

<body>
	<div class="wrapper">
		<div class="splash on"></div>
		
		<div class="intro on">
			<div class="head">
				<div class="icon-help" onclick="doHelp(this)"></div>
				<div class="icon-sound on" onclick="doToggleSound(this)"></div>
			</div>
			<div class="title"></div>
			<div class="empty" style="flex: 1"></div>
			<div class="footer">
				<div class="btn btn-start" onclick="doStartGame(this)"></div>
			</div>
			
		</div>
	
	
	
		<!-- ================================================-->
		<!-- =================== PLAY =======================-->
		<!-- ================================================-->
		
		<div class="play">
			<div class="wrap wrap-fg"></div>
			<div class="wrap wrap-gameover on">
				<div class="gameover">
					<div class="gameover-time"></div>
				</div>
				<div class="gameover-menus">
					<div class="menu btn-restart" onclick="doRestart(this, true)"></div>
					<div class="menu btn-exit" onclick="doHome(this)"></div>
				</div>
				<div class="btn-restart-mortion"></div>
			</div>
			
			<div class="wrap wrap-pause">
				<div class="pause-title"></div>
				<div class="pause-menus">
					<div class="menu btn-regame" onclick="doRegame(this)"></div>
					<div class="menu btn-restart" onclick="doRestart(this)"></div>
					<div class="menu btn-home" onclick="doHome(this)"></div>
				</div>
			</div>
			
			<div class="wrap wrap-stageup">	
				<div class="value stage1"></div>
				<div class="value stage2 "></div>
				<div class="value stage3"></div>
				<div class="value stage4"></div>
				<div class="bg-stage"></div>
			</div>
			
			<div class="header">
				<div class="info-board-t">
					<div class="progress">
						<div class="progress-bar">
							<div class="crop-progress-bar"></div>
							<div class="crop-progress-bar-overlay"></div>
						</div>
						
						<div class="progress-marking"></div>
						<div class="progress-apple"></div>
						<div class="progress-portion effect1"></div>
						<div class="progress-portion effect2"></div>
						<div class="progress-portion effect3"></div>
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
					<div class="combo-message">
						<div class="value combo1"></div>
						<div class="value combo2"></div>
						<div class="value combo3"></div>
						<div class="value combo4"></div>
						<div class="value combo5"></div>
						<div class="value combo6"></div>
						<div class="value combo7"></div>
					</div>
					
					<div class="effect spray"></div>
				</div>
			
				<div class="wrap-item">
					<div class="itembar">
						<div class="icon-basket-occupy"></div>
						<div class="itembar-item lime-item" onclick="usingItem(0)">
							<div class="icon icon-off on"></div>
							<div class="icon icon-on"></div>
						</div>
						<div class="itembar-item portion-item" onclick="usingItem(2)">
							<div class="icon icon-off on"></div>
							<div class="icon icon-on"></div>
						</div>
						<div class="itembar-item spray-item" onclick="usingItem(1)">
							<div class="icon icon-off on"></div>
							<div class="icon icon-on"></div>
						</div>
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
		
		<!-- ================================================-->
		<!-- =================== HELP =======================-->
		<!-- ================================================-->
		
		<div class="help">
			<div class="h-exit" onClick = "doHelpExit(this)"></div>
			<div class="h-wrap-fg" onClick="doExplain()"></div>
			
			<div class="h-header">
				<div class="h-info-board-t">
					<div class="h-progress">
						<div class="h-progress-bar">
							<div class="h-crop-progress-bar"></div>
						</div>
						<div class="h-progress-marking"></div>
						<div class="h-progress-apple"></div>
					</div>
				
					<div class="h-info h-wrap-coin">
						<div class="h-value">0</div>
					</div>
					
					<div class="h-btn-pause" onClick="doPause()"></div>
				</div>
				
				<div class="h-info-board-c">
					<div class="h-info h-stage"><div class="h-value h-stage1 on"></div></div>
					<div class="h-info h-time"><div class="h-value">0.00</div></div>
					<div class="h-info h-empty"></div>
				</div>
				
				<div class="h-move-friends"></div>
			</div>
			
			<div class="h-wrap-play-ground">
				<div class="h-play-ground">
					<div class="h-target h-normal">
						<div class="h-target-icon"></div>
					</div>
					
					<div class="h-target h-warning">
						<div class="h-target-icon"></div>
					</div>
					
					<div class="h-target h-gold">
						<div class="h-target-icon"></div>
					</div>
				</div>
				
				<div class="h-wrap-item">
					<div class="h-itembar">
						<div class="h-icon-basket-occupy"></div>
						<div class="h-itembar-item h-lime-item on" ></div>
						<div class="h-itembar-item h-portion-item on"></div>
						<div class="h-itembar-item h-spray-item on"></div>
					</div>
				</div>
				
				<div class="h-icon-basket">
					<div class="h-value h-status-100 on"></div>
				</div>
			</div>
		</div>
	</div>
</body>
</html>
