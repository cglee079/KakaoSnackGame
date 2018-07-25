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

.mask {
	position: absolute;
	left: 0;
	top: 0;
	width:100%;
	height:100%;
	background-color: black;
	opacity: 0.5;
	filter: Alpha(opacity = 50);
	display:none;
}

.mask.on {
	display:flex;
}
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
	margin-top: -20;
	height: 160px;
	background-size: contain;
	background-repeat: no-repeat;
	background-position: center center;
	background-image: url("resources/image/intro/icon_intro_title.png");
}

.help-board {
	display: none;
	z-index: 3;
	position: absolute;
	left: 0;
	right: 0;
	top: 0;
	bottom: 0;
	background: rgba(0, 0, 0, 0);
	justify-content: center;
	align-items: center;
}

.help-board.on {
	display: flex;
}

.images {
	display: flex;
	justify-content: center;
	padding-left: 600px;
	align-items: center;
}

.image-slide ul li img {
	width: 300px;
	height: 450px;
	position: realative;
}

.image-slide {
	width: 300px;
	height: 400px;
	background: #FFF;
	border-radius: 10px;
	box-shadow: 0px 10px 20px #222;
	display: flex;
	flex-flow: row nowrap;
	justify-content: center;
	align-items: center;
}

#back {
	cursor: pointer;
	z-index: 1;
	width: 40px;
	height: 40px;
	margin-right: 10px;
	margin-left: 10px;
}

#next {
	cursor: pointer;
	z-index: 1;
	width: 40px;
	height: 40px;
	margin-right: 10px;
	margin-left: 10px;
}


#cancel {
	cursor: pointer;
	z-index: 1;
	position: absolute;
	top: 0px;
	margin-top:5px;
	width: 30px;
	height: 30px;
	right: 0;
}

.footer {
	display: flex;
	justify-content: center;
	align-items: center;
	margin: 0px 15px;
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

	//도움말 버튼 클릭시
	function doHelpIcon() {

		var imgSlide = $(".image-slide");
		var images = $(".images");
		var mask = $(".mask");		
		var wrapper = $(".wrapper");
		var imgPosition = 1;

		$(".help-board").addClass("on");
		mask.addClass("on");

		setImages();
		function setImages() {
			var imgSlide = $(".image-slide");
			var images = $(".images");
			images.append("<li><img src='resources/image/help_img_1.png'></li>");
			images.append("<li><img src='resources/image/help_img_2.png'></li>");
			images.append("<li><img src='resources/image/help_img_3.png'></li>");

			imgSlide.css("overflow", "hidden");
			imgSlide.css("positon", "realative");
			imgSlide.css("margin", "auto");
		}

		$('#back').click(function() {
			back();
		})
		$('#next').click(function() {
			next();
		})
		$('#cancel').click(function() {
			cancel();
			
		})
		
		function back() {
			if (1 < imgPosition) {
				images.animate({
					'padding-right' : '-=600px'
				});
				imgPosition--;
			}
		}
		
		function next() {
			if (images.children().length > imgPosition) {
				images.animate({
					'padding-right' : '+=600px'
				});
				imgPosition++;
			}
		}
		
		function cancel(){
			
			//초기화
			$(".help-board").removeClass("on");
			mask.removeClass("on");
			
			$(".images *").remove();
			images.css("padding-left", "600px");
			images.css("padding-right", "0");
			
			//버튼 이벤트 제거
			$('#back').off();
			$('#next').off();
			$('#cancel').off();
		}
	}
</script>
<body>
	<div class="mask"></div>
	<div class="wrapper">
		<div class="head">
			<div class="icon-help" onclick="doHelpIcon()"></div>
			<div class="icon-sound on" onclick="toToggleSound(this)"></div>
		</div>
		<div class="help-board">
			<img id="cancel" src="resources/image/cancel_btn.png" /> <img
				id="back" src="resources/image/back_btn.png" />
			<div class="image-slide">
				<ul class="images"></ul>
			</div>
			<img id="next" src="resources/image/next_btn.png" />
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
