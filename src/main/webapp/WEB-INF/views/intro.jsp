<%@ page pageEncoding="UTF-8"%>
<html>
<head>
<%@ include file="/WEB-INF/views/included/included_head.jsp"%>
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/css/intro.css" />
<link rel="stylesheet"
	href="${pageContext.request.contextPath}/resources/lib/swiper/dist/css/swiper.min.css" />
<script>
	var btnClickSound = undefined;
	var swiper;
	$(document).ready(
			function() {
				var bgm = new Audio(getContextPath()
						+ '/resources/audio/bgm.mp3');
				setBGM(bgm);

				doSoundOn();
				startBGM();

				btnClickSound = makeSound(getContextPath()
						+ "/resources/audio/sound_common_button.mp3");
			});

	function doStartGame() {
		startAudio(btnClickSound);

		setTimeout(function() {
			var form = $("<form>", {
				method : "post",
				action : getContextPath() + "/play"
			})

			form.append($("<input>", {
				name : "sound",
				value : sound
			}));
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
		
		$(".help-board").addClass("on");
	
		setSwiper();
		function setSwiper() {
			if (swiper == undefined) {

				swiper = new Swiper('.swiper-container', {
					pagination : {
						el : '.swiper-pagination'
					},
				});
			}
		}
		
		$('#cancel').click(function() {
			cancel();
		})

		function cancel() {

			//초기화
			$(".help-board").removeClass("on");
			$(".swiper-wrapper").css('transform', 'translate3d(0px, 0px, 0px)'); //맨 처음 이미지로 이동 

			//swiper-pagination-bullet 맨 처음으로 이동
			setSwiperPaginationBullet();
			function setSwiperPaginationBullet() {
				var swiperPaginations = $('.swiper-pagination-bullets')
						.children(); //모든 자식 노드 찾기

				for (var i = 0; i < swiperPaginations.length; i++) {
					if (i == 0)
						swiperPaginations[i]
								.setAttribute('class',
										'swiper-pagination-bullet swiper-pagination-bullet-active');
					else
						swiperPaginations[i].setAttribute('class',
								'swiper-pagination-bullet');
				}
			}

			//버튼 이벤트 제거
			$('#cancel').off();
		}
	}
</script>
<body>
	<div class="wrapper">
		<div class="head">
			<div class="icon-help" onclick="doHelpIcon()"></div>
			<div class="icon-sound on" onclick="doToggleSound(this)"></div>
		</div>
		<div class="help-board">
			<img id="cancel" src="resources/image/cancel_btn.png" />
			<div class="swiper-container">
				<div class="swiper-wrapper">
					<!-- Slides -->
					<div class="swiper-slide"><img src='resources/image/help_img_1.png'></div>
					<div class="swiper-slide"><img src='resources/image/help_img_2.png'></div>
					<div class="swiper-slide"><img src='resources/image/help_img_3.png'></div>
				</div>
				<div class="swiper-pagination"></div>
			</div>
		</div>
		<div class="title"></div>
		<div class="empty" style="flex: 1"></div>
		<div class="footer">
			<div class="btn btn-start" onclick="doStartGame()"></div>
		</div>
	</div>

	<script
		src="${pageContext.request.contextPath}/resources/lib/swiper/dist/js/swiper.min.js"></script>
</body>
</html>
