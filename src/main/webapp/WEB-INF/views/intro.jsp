<%@ page pageEncoding="UTF-8"%>
<html>
<head>
<%@ include file="/WEB-INF/views/included/included_head.jsp"%>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/intro.css" />
<script>	
	var btnClickSound = undefined;

	$(document).ready(function(){
		setBGM(new Audio(getContextPath() + '/resources/audio/intro/bgm_intro.mp3'));	
		
		doSoundOn();
		startBGM();
		
		btnClickSound = makeSound(getContextPath() + "/resources/audio/sound_common_button.mp3");
	});
	
	function doStartGame() {
		startAudio(btnClickSound);
		
		setTimeout(function(){
			var form = $("<form>", {
				method : "post",
				action : getContextPath() + "/play" 
			})
			
			form.append($("<input>", {name : "sound", value : sound}));
			form.appendTo($("body"));
			form.submit();	
		}, 500);
	}

	function doToggleSound(tg) {
		var tg = $(tg);
		tg.toggleClass("on");

		if (tg.hasClass("on")) {
			doSoundOn();
			startBGM();
			startAudio(btnClickSound);
		} else {
			startAudio(btnClickSound);
			doSoundOff();
			stopBGM();
		}
	}

	//도움말 버튼 클릭시
	function doHelpIcon() {
		startAudio(btnClickSound);
		
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
			<div class="icon-sound on" onclick="doToggleSound(this)"></div>
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
		</div>
	</div>
</body>
</html>
