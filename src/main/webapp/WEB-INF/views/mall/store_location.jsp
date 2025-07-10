<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
    String ctxPath = request.getContextPath();
    //     /MyMVC
%>

<jsp:include page="../header1.jsp" />

<style type="text/css">

    div#title {
        font-size: 20pt;
        /* border: solid 1px red; */
        padding: 12px 0;
    }

    div.mycontent {
        width: 300px;
        padding: 5px 3px;
    }

    div.mycontent>.title {
        font-size: 12pt;
        font-weight: bold;
        background-color: #d95050;
        color: #fff;
    }

    div.mycontent>.title>a {
        text-decoration: none;
        color: #fff;
    }

    div.mycontent>.desc {
        /* border: solid 1px red; */
        padding: 10px 0 0 0;
        color: #000;
        font-weight: normal;
        font-size: 9pt;
    }

    div.mycontent>.desc>img {
        width: 50px;
        height: 50px;
    }

</style>

<div id="title">매장지도</div>
<div id="map" style="width:90%; height:600px;"></div>
<div id="latlngResult"></div>

<script type="text/javascript" src="//dapi.kakao.com/v2/maps/sdk.js?appkey=23e3fd3f62a37613a04f55e3b626bd34"></script>
<script>
    var container = document.getElementById('map');//지도를 표시할 div
    var options = {
        center: new kakao.maps.LatLng(33.450701, 126.570667), //지도의 중심좌표 위도 경도
        level: 3 //지도의 확대 레벨
    };

    var map = new kakao.maps.Map(container, options);//지도 생성

    // 일반 지도와 스카이뷰로 지도 타입을 전환할 수 있는 지도타입 컨트롤을 생성함.
    var mapTypeControl = new kakao.maps.MapTypeControl();
    // 지도 타입 컨트롤을 지도에 표시함.
    // kakao.maps.ControlPosition은 컨트롤이 표시될 위치를 정의하는데 TOPRIGHT는 오른쪽 위를 의미함.
    map.addControl(mapTypeControl, kakao.maps.ControlPosition.TOPRIGHT);
    // 지도 확대 축소를 제어할 수 있는 줌 컨트롤을 생성함.
    var zoomControl = new kakao.maps.ZoomControl();
    // 지도 확대 축소를 제어할 수 있는  줌 컨트롤을 지도에 표시함.
    // kakao.maps.ControlPosition은 컨트롤이 표시될 위치를 정의하는데 RIGHT는 오른쪽을 의미함.
    map.addControl(zoomControl, kakao.maps.ControlPosition.RIGHT);

    if(navigator.geolocation) {
        // HTML5의 geolocation으로 사용할 수 있는지 확인한다

        // GeoLocation을 이용해서 웹페이지에 접속한 사용자의 현재 위치를 확인하여 그 위치(위도,경도)를 지도의 중앙에 오도록 한다.
        navigator.geolocation.getCurrentPosition(function(position) {
            var latitude = position.coords.latitude;   // 현위치의 위도
            var longitude = position.coords.longitude; // 현위치의 경도
            console.log("현위치의 위도: "+latitude+", 현위치의 경도: "+longitude);
            // 지도 중심을 현위치로 이동
            var locPosition = new kakao.maps.LatLng(latitude, longitude);
            map.setCenter(locPosition);
            // 마커이미지를 기본이미지를 사용하지 않고 다른 이미지로 사용할 경우의 이미지 주소
            var imageSrc = '${pageContext.request.contextPath}/images/pointerPink.png';
            // 마커이미지의 크기
            var imageSize = new kakao.maps.Size(34, 39);
            // 마커이미지의 옵션. 마커의 좌표와 일치시킬 이미지 안에서의 좌표를 설정한다.
            var imageOption = {offset: new kakao.maps.Point(15, 39)};
            // 마커의 이미지정보를 가지고 있는 마커이미지를 생성한다.
            var markerImage = new kakao.maps.MarkerImage(imageSrc, imageSize, imageOption);
            // == 마커 생성하기 == //
            var marker = new kakao.maps.Marker({
                map: map,
                position: locPosition, // locPosition 좌표에 마커를 생성
                image: markerImage     // 마커이미지 설정
            });

            marker.setMap(map); // 지도에 마커를 표시한다

            // === 인포윈도우(텍스트를 올릴 수 있는 말풍선 모양의 이미지) 생성하기 === //

            // 인포윈도우에 표출될 내용으로 HTML 문자열이나 document element가 가능함.
            var iwContent = "<div style='padding:5px; font-size:9pt;'>여기에 계신가요?<br/><a href='https://map.kakao.com/link/map/현위치(약간틀림),"+latitude+","+longitude+"' style='color:blue;' target='_blank'>큰지도</a> <a href='https://map.kakao.com/link/to/현위치(약간틀림),"+latitude+","+longitude+"' style='color:blue' target='_blank'>길찾기</a></div>";
            var iwPosition = locPosition;
            // removeable 속성을 true 로 설정하면 인포윈도우를 닫을 수 있는 x버튼이 표시됨
            var iwRemoveable = true;
            // == 인포윈도우를 생성하기 ==
            var infowindow = new kakao.maps.InfoWindow({
                position : iwPosition,
                content : iwContent,
                removable : iwRemoveable
            });

            // == 마커 위에 인포윈도우를 표시하기 == //
            infowindow.open(map, marker);

        })
    }else {
        // HTML5의 GeoLocation을 사용할 수 없을때 마커 표시 위치와 인포윈도우 내용을 설정한다.
        var locPosition = new kakao.maps.LatLng(37.556513150417395, 126.91951995383943);

        // 위의
        // 마커이미지를 기본이미지를 사용하지 않고 다른 이미지로 사용할 경우의 이미지 주소
        // 부터
        // 마커 위에 인포윈도우를 표시하기
        // 까지 동일함.

        // 지도의 센터위치를 위에서 정적으로 입력한 위.경도로 변경한다.
        map.setCenter(locPosition);

    }// end of if~else------------------------------------------
</script>

<jsp:include page="../footer1.jsp"/>

