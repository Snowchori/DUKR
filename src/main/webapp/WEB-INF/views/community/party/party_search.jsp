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
			let rvlat = '';
			let rvlng = '';
			function setRoadviewPos(lat, lng){
				rvlat = lat;
				rvlng = lng;
			}
			
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
				function drawMap(map){
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
								content: '<div style="width:180px;text-align:center;"><a href="partyBoardView?seq=' + datas[i].boardSeq + '" class="meet">' + inner + '</a>'//&nbsp;<a href="#" class="roadview" onclick="return false"><i class="bi bi-eye"></i></a>
							});
	
						} else {
							infoContents[infoContents.length-1].content = infoContents[infoContents.length-1].content + '<br/><a href="partyBoardView?seq=' + datas[i].boardSeq + '" class="meet">' + inner + '</a>';
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
						drawMap(map);
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
						fetch('api/geoCodes.json?loccode=' + dcode)
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
				
				document.getElementById('rbtn').onclick = function(){
					loadMeet();
				}
				
				
				
				/* 로드뷰 */
				const control = document.getElementById('roadviewControl');
				
				const wrapper = document.getElementById('container');
				
				const mcontainer = document.getElementById('mmap'),
					mcontrol = document.getElementById('mroadviewControl'),
					rcontainer = document.getElementById('roadview');
				
				let overlayOn = false;
				
				const markImage = new kakao.maps.MarkerImage(
						'https://t1.daumcdn.net/localimg/localimages/07/2018/pc/roadview_minimap_wk_2018.png',
						new kakao.maps.Size(26, 46),
						{
							spriteSize: new kakao.maps.Size(1666, 168),
							spriteOrigin: new kakao.maps.Point(705, 114),
							offset: new kakao.maps.Point(13, 46)
						}
				);
				
				// mmap 객체 생성
				const moptions = {
						center: new kakao.maps.LatLng(37.566661, 126.978378),
						level: 10
				}
				let mmap = new kakao.maps.Map(mcontainer, moptions);
				
				let rv = new kakao.maps.Roadview(rcontainer); // 로드뷰 객체 생성
				let rvClient = new kakao.maps.RoadviewClient(); // 좌표로부터 로드뷰 파노라마ID를 가져오는 객체 생성

				const marker = new kakao.maps.Marker({
				    image : markImage,
				    draggable: true
				});
				
				// 마커를 옮길때 로드뷰도 같이 이동
				kakao.maps.event.addListener(marker, 'dragend', function(mouseEvent) {
				    // 마커가 놓인 자리의 좌표
				    let position = marker.getPosition();
				    // 마커가 놓인 위치를 기준으로 로드뷰 설정
				    toggleRoadview(position);
				});
				
				// 로드뷰를 통해서 이동할때 마커도 같이 이동
				kakao.maps.event.addListener(rv, 'position_changed', function() {
				    // 현재 로드뷰의 위치 좌표 
				    let rvPosition = rv.getPosition();

				    // 지도 중심을 현재 로드뷰 위치로 설정
				    mmap.setCenter(rvPosition);

				    // 지도 위에 로드뷰 도로 오버레이가 추가된 상태일때
				    if(overlayOn) {
				        // 마커 위치 현재 로드뷰의 위치로 설정
				        marker.setPosition(rvPosition);
				    }
				});
				
				kakao.maps.event.addListener(map, 'click', function(mouseEvent){
					
				})
				
				const toggleMapWrapper = (active, position) => {
					// 파노라마ID 값 존재 유무 분기(지도만 출력 / 지도-로드뷰 반반)
					if (active) {
						
						// 지도 width 100%로 변경
						wrapper.classList.remove('view_roadview');
						// 지도 너비 변경 이후 지도 재조정
						mmap.relayout();
						// 지도 너비 변경 이후 중심 재조정
						mmap.setCenter(position);
					} else {
						if (!wrapper.classList.contains('view_roadview')) {

							// 지도 width 50%로 변경
							wrapper.classList.add('view_roadview');
							// 지도 너비 변경 이후 지도 재조정
							mmap.relayout();
							// 지도 너비 변경 이후 중심 재조정
							mmap.setCenter(position);
						}
					}
				}
				
				const toggleRoadview = position => {
					// 인자로 전달받은 좌표와 50m 반경 내 가장 가까운 로드뷰 파노라마ID로 로드뷰 출력
					rvClient.getNearestPanoId(position, 100, function(panoId){
						if(panoId === null){
							toggleMapWrapper(true, position);
						}else{
							toggleMapWrapper(false, position);
							
							rv.setPanoId(panoId, position);
						}
					})
				}
				
				const toggleOverlay = active => {
					if(active){
						overlayOn = true;
						
						mmap.addOverlayMapTypeId(kakao.maps.MapTypeId.ROADVIEW);
						
						marker.setMap(mmap);
						marker.setPosition(mmap.getCenter());
						
						mcontrol.classList.add('active');
						
						toggleRoadview(mmap.getCenter());
					}else{
						overlayOn = false;
						
						mmap.removeOverlayMapTypeId(kakao.maps.MapTypeId.ROADVIEW);
						
						marker.setMap(null);
						
						mcontrol.classList.remove('active');
					}
				}
				
				const activeRoadview = () => {
					// 클래스 이름 중 active의 존재 유무를 통해 css를 부여해 클릭 효과를 줌
					// classList.add('active') + classList.remove('active')
					control.classList.toggle('active')
					if(control.classList.contains('active')){
						drawMap(mmap);
						mmap.setCenter(map.getCenter());
						mmap.setLevel(map.getLevel());

						toggleOverlay(true);
						toggleRoadview(map.getCenter());
					}else{
						toggleOverlay(false);
					}
				}
				document.getElementById('roadviewControl').onclick = activeRoadview;
				document.getElementById('mdbtn').onclick = activeRoadview;
				
				document.getElementById('mroadviewControl').onclick = () => {
					mcontrol.classList.toggle('active');
					if(mcontrol.classList.contains('active')){
						toggleOverlay(true);
					}else{
						toggleOverlay(false);
					}
				};
				document.getElementById('close').onclick = () => {
					toggleMapWrapper(true, mmap.getCenter());
				}
				
				window.onresize = () => {
				}
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
			
			#roadviewControl {position:absolute;top:90%;left:5px;width:42px;height:42px;z-index: 2;cursor: pointer; background: url(/assets/img/kakao/img_search.png) 0 -450px no-repeat;}
			#roadviewControl.active {background-position:0 -350px;}
			#container {overflow:hidden;height:50em;position:relative;}
			
			#mapWrapper {width:100%;height:100%;z-index:1;}
			#container.view_roadview #mapWrapper {width: 50%;}
			#mroadviewControl {position:absolute;top:5px;left:5px;width:42px;height:42px;z-index: 2;cursor: pointer; background: url(/assets/img/kakao/img_search.png) 0 -450px no-repeat;}
			#mroadviewControl.active {background-position:0 -350px;}
			
			#rvWrapper {width:50%;height:100%;top:0;right:0;position:absolute;z-index:0;}
			#close {position: absolute;padding: 4px;top: 5px;left: 5px;z-index: 3;cursor: pointer;background: #fff;border-radius: 4px;border: 1px solid #c8c8c8;box-shadow: 0px 1px #888;}
			#close .img {display: block;background: url(https://t1.daumcdn.net/localimg/localimages/07/mapapidoc/rv_close.png) no-repeat;width: 14px;height: 14px;}
			
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
					<div id="map" class="col mb-3 border border-5" style="width:1000px;height:600px;">
						<div id="roadviewControl" data-bs-toggle="modal" data-bs-target="#myModal"></div>
					</div>
					<!-- 
					<div id="roadview" class="col mb-3 border border-5" style="width:1000px;height:600px;display: none;">
						<div id="close" title="로드뷰닫기" onclick="closeRoadview()"><span class="img"></span></div>
					</div>
					 -->
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
						<div class="d-flex">
							<button class="btn btn-primary" id="rbtn"><i class='bi bi-arrow-clockwise'></i></button>&nbsp;
							<input type="button" class="btn btn-primary" id="sbtn" value="검색" style="width: 100%" disabled/>
						</div>
					</div>
				</div>
			</div>
		</main>
		<!-- Map Modal -->
		<div class="modal" data-bs-backdrop="static" id="myModal">
			<div class="modal-dialog modal-fullscreen "><!-- modal-dialog-centered modal-xl -->
				<div class="modal-content">
	
					<!-- Modal Header -->
					<div class="modal-header">
						<h5 class="modal-title" style="font-family: SBAggroB;">로드뷰</h5>
						<button type="button" id="mdbtn" class="btn-close" data-bs-dismiss="modal"></button>
					</div>
	
					<!-- Modal body -->
					<div class="modal-body">
						<div id="container">
							<div id="rvWrapper">
								<div id="roadview" style="width:100%;height:100%;"></div> <!-- 로드뷰를 표시할 div 입니다 -->
								<div id="close" title="로드뷰닫기"><span class="img"></span></div>
							</div>
							<div id="mapWrapper">
								<div id="mmap" style="width:100%;height:100%"></div> <!-- 지도를 표시할 div 입니다 -->
								<div id="mroadviewControl"></div>
							</div>
						</div>
					</div>
	
					<!-- Modal footer
					<div class="modal-footer">
						<button type="button" class="btn btn-danger"
							data-bs-dismiss="modal" onclick="setRoadview()">Close</button>
					</div>
					 -->
				</div>
			</div>
		</div>
		<footer>
		<!-- 최하단 디자인 영역 -->
		</footer>
	</body>
</html>