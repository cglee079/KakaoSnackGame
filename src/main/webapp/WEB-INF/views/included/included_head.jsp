<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<title>KakaoSnackGame</title>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta id="viewport" name="viewport" content="width=device-width, initial-scale=1, user-scalable=no" >

<!-- font -->
<%-- 
<link rel='stylesheet' href='${pageContext.request.contextPath}/resources/css/font/font-nanumsquare.css'/>
<link rel='stylesheet' href='${pageContext.request.contextPath}/resources/css/font/font-nanumgothic.css'/>
<link rel='stylesheet' href='${pageContext.request.contextPath}/resources/css/font/font-lora.css'/>
<link rel='stylesheet' href='${pageContext.request.contextPath}/resources/css/font/font-misaeng.css'/>
<link rel='stylesheet' href='${pageContext.request.contextPath}/resources/css/font/font-kcc.css'/>
<link rel='stylesheet' href='${pageContext.request.contextPath}/resources/css/font/font-apple-sd.css'/>
 --%>
 <link rel='stylesheet' href='${pageContext.request.contextPath}/resources/css/font/font-bm.css'/>
 
<!-- lib-js -->
<script src="${pageContext.request.contextPath}/resources/js/lib/jquery-3.2.1.min.js"></script>


<script src="${pageContext.request.contextPath}/resources/js/common-sound.js"></script>
<link rel="stylesheet" href="${pageContext.request.contextPath}/resources/css/common.css" />

<script>
/* context Path */
var contextPath = "${pageContext.request.contextPath}";
function getContextPath(){ return contextPath; }

/* check, is mobile?*/
var maxMobileWidth = 800;
var isMobile = false;
var deviceWidth = undefined;
var deviceHeight = undefined;

function checkDevice(){
	deviceWidth 	= Math.min(window.innerWidth || Infinity, screen.width);
	deviceHeight	= Math.min(window.innerHeight || Infinity, screen.height);
	if(deviceWidth <= maxMobileWidth){
		isMobile = true;
	}
	
}

checkDevice();
$(window).resize(function(){
	checkDevice();
})

$(document).ready(function(){
	$("html, body").css("font-family", "BM_Jua, serif");
})

</script>