<html>
<head>
<%@ include file="/WEB-INF/views/included/included_head.jsp" %>
<style>
	.wrapper{
		display: flex;
		flex-flow : column nowrap;
		height: 100%;
	}
	
	.head{
		width : 100%;
		height : 50px;
		background: #CCC;
	}
	
	.play-ground{
		flex : 1;
			
	}
	
	.footer{
		width : 100%;
		height : 100px;
		background: #CCC;
	}
</style>
<body>

<div class="wrapper">
	<div class="head"></div>
	<div class="play-ground"></div>
	<div class="footer"></div>
</div>
</body>
</html>
