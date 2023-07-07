<%@page import="com.example.model.MeetTO"%>
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
				let options = {
					center: new kakao.maps.LatLng(37.566661, 126.978378),
					level: 10
				}
				
				let map = new kakao.maps.Map(container, options);
				
				// 일반 지도와 스카이뷰로 지도 타입을 전환할 수 있는 지도타입 컨트롤 생성
				let mapTypeControl = new kakao.maps.MapTypeControl();
				// 지도 확대 축소를 제어할 수 있는 줌 컨트롤을 생성
				let zoomControl = new kakao.maps.ZoomControl();
				
				// 지도에 컨트롤을 추가
				// kakao.maps.ControlPosition 컨트롤이 표시될 위치를 정의 TOPRIGHT는 오른쪽 위를 의미
				map.addControl(mapTypeControl, kakao.maps.ControlPosition.TOPRIGHT);
				map.addControl(zoomControl, kakao.maps.ControlPosition.RIGHT);
				
				/*  맵 새로 로딩 시 초기화를 위해 marker, infowindow 객체 정보를 저장할 배열 */
				let markers = [];
				let infos = [];
				
				/* 선택된 조건에 따라 맵을 그리는 함수 */
				function drawMap(){
					const doval = document.getElementById('dosel').value;
					const sival = document.getElementById('sisel').value;
					let loccode = doval;
					
					if(sival !== '0'){
						loccode = sival;
					}
					
					fetch('api/meetings.json?loccode=' + loccode)
					.then(response => response.json())
					.then(jsonData => {
						const datas = jsonData;
		
						let points = [];
						let infoContents = [];
						
						for(i in datas){
							pos = new kakao.maps.LatLng(datas[i].latitude, datas[i].longitude);
							points.push(pos);
							
							// 인포윈도우에 작성될 내용 미리 가공
							const inner = datas[i].location + '('+ datas[i].date +')';
							
							// 첫 데이터 or 직전 데이터의 주소와 현 주소가 다를때 인포윈도우 새로 생성
							if( (i == 0) || !(datas[i-1].address === datas[i].address) ){
								
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
		
						// 검색한 지역에 데이터가 존재하지 않을 시 alert() 지도 중심 변경(추후 수정 필요)
						if(datas.length == 0){
							alert('검색하신 조건에 해당하는 모임이 없습니다.');
							map.setLevel(10);
							map.setCenter(new kakao.maps.LatLng(37.566661, 126.978378));
							
						} else {
							// 지도를 재설정할 범위정보를 가지고 있을 LatLngBounds 객체를 생성
							let bounds = new kakao.maps.LatLngBounds();
							// LatLngBounds 객체에 좌표를 추가
							for (point of points) {
								bounds.extend(point);
							}
						    // LatLngBounds 객체에 추가된 좌표들을 기준으로 지도의 범위를 재설정
						    map.setBounds(bounds);
						}
					});
				}
				
				/* 검색 버튼 클릭 시 새로운 지도-drawMap() 실행 */
				document.getElementById('sbtn').onclick = function(){
					// 직전 저장된 infowindow, marker 객체 지우기
					for(info of infos){
						info.close();
					}
					for(marker of markers){
						marker.setMap(null);
					}
					infos.length = 0;
					markers.length = 0;
					
					drawMap();
				}
				
				/* 초기 도(시) select - option 생성 */
				fetch('api/geoCodes.json?type=sido')
				.then(response => response.json())
				.then(response => {
					const features = response.response.result.featureCollection.features;
					
					let html = '';
					features.forEach(f => {
						let lcode = f.properties.ctprvn_cd;
						let lname = f.properties.ctp_kor_nm;
						html +='<option value="' + lcode + '">' + lname + '</option>';
					});
					
					document.getElementById('dosel').innerHTML = html;
					document.getElementById('dosel').removeAttribute('disabled');
					document.getElementById('sisel').removeAttribute('disabled');
					drawMap();
				});
				
				/* 초기 시/군(구) select - option 생성(attrfilter: 'sig_cd:like:11' >> 서울(시구군코드가 11로 시작하는) 내부 구 정보 출력) */
				fetch('api/geoCodes.json?loccode=11')
				.then(response => response.json())
				.then(response => {
					const features = response.response.result.featureCollection.features;
					
					let html = "<option value='0'>전체</option>";
					features.forEach(f => {
						let lcode = f.properties.sig_cd;
						let lname = f.properties.sig_kor_nm;
						html +='<option value="' + lcode + '">' + lname + '</option>';
					});
					document.getElementById('sisel').innerHTML = html;
				});
				
				/* 도(시) 값 변경 시 >> 시/군(구) 값 갱신 */
				document.getElementById('dosel').addEventListener("change", e => {
					const sisel = document.getElementById('sisel');
					
					sisel.setAttribute('disabled', '');
					let dcode = document.getElementById('dosel').value;
					
					fetch('api/geoCodes.json?loccode=' + dcode)
					.then(response => response.json())
					.then(response => {
						const features = response.response.result.featureCollection.features;
						
						let html = "<option value='0'>전체</option>";
						features.forEach(f => {
							let lcode = f.properties.sig_cd;
							let lname = f.properties.sig_kor_nm;
							html += '<option value="' + lcode + '">' + lname + '</option>';
						});
						sisel.innerHTML = html;
						sisel.removeAttribute('disabled');
					});
				});
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
	<body>
		<%@ include file="/WEB-INF/views/include/top_bar_header.jspf" %>
		<header class="py-5 bg-secondary">
			<div class="container px-4 px-lg-5 my-5">
				<div class="text-center text-white">
					<h1 class="title">모임검색</h1>
					<p class="lead fw-normal text-white-50 mb-0">Search Meetings</p>
				</div>
			</div>
		</header>
		<main class="d-flex justify-content-center">
			<!-- 메인 요소 -->
			<div class="container-fluid d-flex justify-content-center bg-light bottombody">
				<div class="row py-5 mapframe">
					<div id="map" class="col mb-3 border border-5" style="width:1000px;height:600px;"></div>
					<div id="map-side" class="col-lg-4 align-self-center">
						<form action="" class="row">
							<div class="mb-3 col-sm-6 col-lg-12">
								<label for="dosel" class="form-label">도(시)</label>
								<select id="dosel" name="dosel" class="form-select" disabled>
								</select>
							</div>
							<div class="mb-3 col-sm-6 col-lg-12">
								<label for="sisel" class="form-label">시/군(구)</label>
								<select id="sisel" name="sisel" class="form-select" disabled>
									<option value="0">전체</option>
								</select>
							</div>
						</form>
						<div class="btn btn-primary" id="sbtn" style="width: 100%">검색</div>
					</div>
				</div>
			</div>
		</main>
		<footer>
			<!-- 최하단 디자인 영역 -->
		</footer>
	</body>
</html>