<%@page import="com.example.model.party.PartyTO"%>
<%@page import="java.util.List"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/top_bar_declare.jspf" %>	
<!doctype html>
<html>
	<head>
		<%@ include file="/WEB-INF/views/include/head_setting.jspf" %>
		<!-- kakao Map API -->
		<script src="//dapi.kakao.com/v2/maps/sdk.js?appkey=62a899b99d2f71a7e481ba3867c742b7&libraries=services,clusterer">
		</script>
		<!-- 자바 스크립트 영역 -->
		<script type="text/javascript">
			window.addEventListener('DOMContentLoaded', () => {
				/* 초기 지도 설정 */
				// 지도 출력될 태그 할당
				const container = document.getElementById('map');
				const options = {
					center: new kakao.maps.LatLng(37.566661, 126.978378),
					level: 10
				}
				
				let map = new kakao.maps.Map(container, options);
				
				// 일반 지도와 스카이뷰로 지도 타입을 전환할 수 있는 지도타입 컨트롤 생성
				const mapTypeControl = new kakao.maps.MapTypeControl();
				// 지도 확대 축소를 제어할 수 있는 줌 컨트롤을 생성
				const zoomControl = new kakao.maps.ZoomControl();
				
				// 지도에 컨트롤을 추가
				// kakao.maps.ControlPosition 컨트롤이 표시될 위치를 정의 TOPLEFT는 왼쪽 위를 의미
				map.addControl(mapTypeControl, kakao.maps.ControlPosition.TOPLEFT);
				map.addControl(zoomControl, kakao.maps.ControlPosition.LEFT);
				
				/* 첫 로딩 시 자체 API를 통해 전국 모임 데이터 저장할 배열 */
				let datas = [];
				
				/*  맵 새로 로딩 시 초기화를 위해 marker, infowindow 객체 정보를 저장할 배열 */
				let markers = [];
				let infos = [];
				/* 조건 변경 시 지도 이동을 위해 마커가 위치한 좌표와 지역코드를 저장할 배열 */
				let points = [];
				
				const dosel = document.getElementById('dosel');
				const sisel = document.getElementById('sisel');
				const sbtn = document.getElementById('sbtn');
				/* 선택된 조건에 따라 맵을 그리는 함수 */
				function drawMap(){
					let infoContents = [];
					
					for(i in datas){
						// 인포윈도우에 작성될 내용 미리 가공
						const inner = datas[i].location + '('+ datas[i].date +')';
						
						// 첫 데이터 or 직전 데이터의 주소와 현 주소가 다를때 인포윈도우 새로 생성
						if( (i == 0) || !(datas[i-1].address === datas[i].address) ){
							pos = new kakao.maps.LatLng(datas[i].latitude, datas[i].longitude);
							points.push({
								pos: pos,
								loc: datas[i].loccode,
								loc2: datas[i].loccode2
							});
							
							// 마커 객체 생성(map:map = 마커가 위치할 지도:map 변수 / position:coords = 마커가 위치할 좌표)
							let marker = new kakao.maps.Marker({
								map: map,
								position: pos
							});
							// 마커 객체 외부 배열로 저장(초기화용)
							markers.push(marker);
							
							// 인포윈도우 작성될 정보(마커 인덱스, 내용) 배열로 저장
							infoContents.push({
								marker: markers.length-1,
								content: '<div style="width:180px;text-align:center;"><a href="#" class="meet">' + inner + '</a>'
							});
	
						} else {
							infoContents[infoContents.length-1].content = infoContents[infoContents.length-1].content + '<br/><a href="#" class="meet">' + inner + '</a>';
						}
					}
					
					for(infoContent of infoContents){
						// 인포윈도우 객체 생성(+ 닫기 기능)
						let infowindow = new kakao.maps.InfoWindow({
				 			content: infoContent.content + '</div>',
				 			removable: true
						});
						const marker = markers[infoContent.marker];
						
						// 마커 클릭시 인포윈도우 열기
						kakao.maps.event.addListener(marker, 'click', () => {
							infowindow.open(map, marker);
						});
						infowindow.open(map, marker);
						
						infos.push(infowindow);
					}
	
					// 검색한 지역에 데이터가 존재하지 않을 시 alert() 지도 중심 변경
					if(datas.length == 0){
						alert('예정된 모임이 없습니다.');
						map.setLevel(10);
						map.setCenter(new kakao.maps.LatLng(37.566661, 126.978378));
						
					} else {
						// 지도를 재설정할 범위정보를 가지고 있을 LatLngBounds 객체를 생성
						let bounds = new kakao.maps.LatLngBounds();
						// LatLngBounds 객체에 좌표를 추가
						for (point of points) {
							bounds.extend(point.pos);
						}
					    // LatLngBounds 객체에 추가된 좌표들을 기준으로 지도의 범위를 재설정
					    map.setBounds(bounds);
					}
					sbtn.removeAttribute('disabled');
				}
				
				function loadMeet(){
					fetch('/api/party.json')
					.then(response => response.json())
					.then(jsonData => {
						datas = jsonData;
						// 직전 저장된 infowindow, marker, point 객체 지우기
						for(info of infos){
							info.close();
						}
						for(marker of markers){
							marker.setMap(null);
						}
						infos.length = 0;
						markers.length = 0;
						points.length = 0;
						
						dosel.options[0].selected = true;
						sisel.options[0].selected = true;
						sisel.setAttribute('disabled', '');
						
						drawMap();
					});
				}
				
				/* 초기 도(시) select - option 생성 */
				fetch('/api/geoCodes.json')
				.then(response => response.json())
				.then(response => {
					const features = response.response.result.featureCollection.features;
					
					let html = '<option value="0">전국</option>';
					features.forEach(f => {
						let lcode = f.properties.ctprvn_cd;
						let lname = f.properties.ctp_kor_nm;
						html +='<option value="' + lcode + '">' + lname + '</option>';
					});
					
					dosel.innerHTML = html;
					dosel.removeAttribute('disabled');
					
					loadMeet();
				});
				
				/* 도(시) 값 변경 시 >> 시/군(구) 값 갱신 */
				dosel.addEventListener("change", e => {

					sisel.setAttribute('disabled', '');
					sisel.innerHTML = "<option value='0'>전체</option>";
					
					let dcode = dosel.value;
					if(dcode !== "0"){
						fetch('api/geoCodes.json?prvcode=' + dcode)
						.then(response => response.json())
						.then(response => {
							const features = response.response.result.featureCollection.features;
							
							let html = sisel.innerHTML;
							features.forEach(f => {
								let lcode = f.properties.sig_cd;
								let lname = f.properties.sig_kor_nm;
								html += '<option value="' + lcode + '">' + lname + '</option>';
							});
							sisel.innerHTML = html;
							sisel.removeAttribute('disabled');
						});
					}
				});

				/* 검색 버튼 클릭 조건에 해당하는 마커 중심으로 지도 이동 */
				document.getElementById('sbtn').onclick = function(){
					let loccode = dosel.value;
					const sival = sisel.value;
					let doSearch = true;
					
					if(sival !== "0"){
						loccode = sival;
						doSearch = false;
					}
					// 지도를 재설정할 범위정보를 가지고 있을 LatLngBounds 객체를 생성
					let bounds = new kakao.maps.LatLngBounds();
					
					// LatLngBounds 객체에 좌표를 추가
					// 1. 시군구 단위 검색 / 2. 전국검색 / 3. 도 단위 검색
					if(!doSearch){
						for (point of points) {
							if(point.loc === loccode){
								bounds.extend(point.pos);
							}
						}
					}else if(doSearch && loccode === "0"){
						for (point of points) {
							bounds.extend(point.pos);
						}
					}else if(doSearch){
						for (point of points){
							if(point.loc2 === loccode){
								bounds.extend(point.pos);
							}
						}
					}
					
					
					if(!bounds.isEmpty()){
					    map.setBounds(bounds);
					}else{
						for (point of points) {
							bounds.extend(point.pos);
						}
						map.setBounds(bounds);
						sisel.setAttribute('disabled', '');
						dosel.options[0].selected = true;
						sisel.options[0].selected = true;
						alert('조건에 해당하는 모임이 없습니다.');
					}
				};
			});
		</script>
		<!-- 개별 CSS -->
		<style type="text/css">	
			@font-face {
				font-family: 'SBAggroB';
				src: url('https://cdn.jsdelivr.net/gh/projectnoonnu/noonfonts_2108@1.1/SBAggroB.woff') format('woff');
				font-weight: normal;
				font-style: normal;
			}
			
			.title {
				font-family: SBAggroB;
			}
			
			html {
				min-width : 280px;
			}
			
			a {
				text-decoration: none;
			}.meet{
				color: black;
				text-decoration: underline;
			}
			
			label{
				font-weight: bold;
			}
			
			.bottombody{
				max-width: 1920px;
			}
			
			@media (min-width: 767px){
				#map-side{
					padding: 0em 3em 0em 3em;
				}
			}
			
			@media (max-width: 991px){
				.mapframe{
					width: 100%;
				}
			}
		</style>
	</head>
	<body class="bg-light">
		<%@ include file="/WEB-INF/views/include/top_bar_header.jspf" %>
		<header class="py-5 bg-secondary">
			<div class="container px-4 px-lg-5 my-5">
				<div class="text-center text-white">
					<h1 class="title">모임검색</h1>
					<p class="lead fw-normal text-white-50 mb-0">Search Parties</p>
				</div>
			</div>
		</header>
		<main class="d-flex justify-content-center">
			<!-- 메인 요소 -->
			<div class="container-fluid d-flex justify-content-center bottombody">
				<div class="row py-5 mapframe">
					<div id="map" class="col mb-3 border border-5" style="width:1000px;height:600px;"></div>
					<div id="map-side" class="col-lg-4 align-self-center">
						<form action="" class="row">
							<div class="mb-3 col-sm-6 col-lg-12">
								<label for="dosel" class="form-label">도(시)</label>
								<select id="dosel" name="dosel" class="form-select" disabled>
									<option value="0">전국</option>
								</select>
							</div>
							<div class="mb-3 col-sm-6 col-lg-12">
								<label for="sisel" class="form-label">시/군(구)</label>
								<select id="sisel" name="sisel" class="form-select" disabled>
									<option value="0">전체</option>
								</select>
							</div>
						</form>
						<input type="button" class="btn btn-primary" id="sbtn" value="검색" style="width: 100%" disabled/>
					</div>
				</div>
			</div>
		</main>
		<footer>
			<!-- 최하단 디자인 영역 -->
		</footer>
	</body>
</html>