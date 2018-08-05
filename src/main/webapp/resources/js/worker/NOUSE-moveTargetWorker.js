var left 	= 0; // 1씩 증가시켜서 전달할 변수
var top		= 0; 

// 메시지 수신
self.onmessage = function( e ) {
	if(e.data.cmd == 'init'){
		left	= e.data.left;
		top 	= e.data.top;
		
	} else if(e.data == "start") {
		loop();
	} else if(e.data == "stop"){
		clearTimeout(timeThread);
	}
};

// 호출한 페이지에 1씩 증가시킨 i를 1초마다 전달한다.
function loop() {

    // 1씩 증가시켜서 전달
    postMessage( i = i + 0.01 ); 

    // 1초뒤에 다시 실행
    timeThread = setTimeout( function() {
        loop();
    }, 10 );
}