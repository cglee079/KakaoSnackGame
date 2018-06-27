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
	height: 100%;
	background-repeat: no-repeat;
	background-size: cover;
	background-image: url("resources/image/sample_back.png");
}

.head {
	width: 100%;
	display: flex;
	justify-content: space-between;
	
}

.bgm-source-board {
	width: 50px;
	height: 50px;
	background-repeat: no-repeat;
	background-size: contain;
	background-image: url("resources/image/sample_music_button.png");
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


.footer {
	width: 100%;
	height: 100px;
}

</style>

<script>

	$(document).ready(function(){
		$(".start-button").click(function() {
			$("#start").submit();
		});

	})
	
</script>
<body>
	<div class="wrapper">
		<div class="head">
			<div class="bgm-source-board">
				<embed class="back-music-source" src="${pageContext.request.contextPath}/resources/audio/sample_bgm.mp3"
					autostart="true" hidden="true" loop="true" >
			</div>
		</div>
		
		<div class="contents">
			<form id="start" action="${pageContext.request.contextPath}/play" method="post">
				<div class="start-button"></div>
			</form>
		</div>

		<div class="footer"></div>
	</div>
</body>
</html>
