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
				// 지도 생성
				const container = document.getElementById('map'),
					options = {
					center: new kakao.maps.LatLng(37.566661, 126.978378),
					level: 10
				};
				let map = new kakao.maps.Map(container, options);
				
				// 일반 지도와 스카이뷰로 지도 타입을 전환할 수 있는 지도타입 컨트롤 생성
				const mapTypeControl = new kakao.maps.MapTypeControl();
				// 지도 확대 축소를 제어할 수 있는 줌 컨트롤을 생성
				const zoomControl = new kakao.maps.ZoomControl();
				// 지도에 컨트롤을 추가
				// kakao.maps.ControlPosition 컨트롤이 표시될 위치를 정의 TOPLEFT는 왼쪽 위를 의미
				map.addControl(mapTypeControl, kakao.maps.ControlPosition.TOPLEFT);
				map.addControl(zoomControl, kakao.maps.ControlPosition.LEFT);
				// 메인 지도 로드뷰 버튼(로드뷰 모달창 활성화)
				const control = document.getElementById('roadviewControl');
				
				
				/* 모달 지도 & 로드뷰 설정 */
				// 모달창 프레임
				const wrapper = document.getElementById('container');
				// 모달창 지도 생성
				const mcontainer = document.getElementById('mmap'),
					moptions = {
					center: new kakao.maps.LatLng(37.566661, 126.978378),
					level: 10
				};
				let mmap = new kakao.maps.Map(mcontainer, moptions);
				
				// 모달창 지도 로드뷰 버튼(로드뷰 오버레이 & 로드뷰 마커 활성화)
				const mcontrol = document.getElementById('mroadviewControl');
				
				// 로드뷰 생성
				let rvcontainer = document.getElementById('roadview');
				let rv = new kakao.maps.Roadview(rvcontainer); 
				// 좌표로부터 로드뷰 파노라마ID를 가져오는 객체 생성
				let rvClient = new kakao.maps.RoadviewClient();

				// 로드뷰 마커 생성
				const markImage = new kakao.maps.MarkerImage(
						'/assets/img/kakao/roadview_minimap_wk_2018.png',
						new kakao.maps.Size(26, 46),
						{
							spriteSize: new kakao.maps.Size(1666, 168),
							spriteOrigin: new kakao.maps.Point(705, 114),
							offset: new kakao.maps.Point(13, 46)
						}
				);
				const rmarker = new kakao.maps.Marker({
				    image : markImage,
				    draggable: true
				});

				
				/* 첫 로딩 시 자체 API를 통해 전국 모임 데이터 저장할 배열 */
				let datas = [];
				
				/*  맵 새로 로딩 시 초기화를 위해 marker, infowindow 객체 정보를 저장할 배열 */
				let markers = [];
				let mmarkers = [];
				let rvmarkers = [];
				let infos = [];
				let minfos = [];
				let rvinfos = [];
				
				/* 조건 변경 시 지도 이동을 위해 마커가 위치한 좌표와 지역코드를 저장할 배열 */
				let points = [];
				let infoContents = [];
				
				let isloaded = false;
				
				const dosel = document.getElementById('dosel');
				const sisel = document.getElementById('sisel');
				const sbtn = document.getElementById('sbtn');
				
				/* 맵을 그리는 함수 */
				function drawMap(){
					for(let i in datas){
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
							
							// 마커 객체 생성(map:map = 마커가 위치할 지도:map 변수 / position:pos = 마커가 위치할 좌표)
							let marker = new kakao.maps.Marker({
								map: map,
								position: pos
							});
							// 마커 객체 외부 배열로 저장(초기화용)
							markers.push(marker);
							
							let mmarker = new kakao.maps.Marker({
								map: mmap,
								position: pos
							});
							let rvmarker = new kakao.maps.Marker({
								map: rv,
								position: pos
							})
							mmarkers.push(mmarker);
							rvmarkers.push(rvmarker);
							
							let rvshortcut = '&nbsp;<a href="javascript:void(0);" data-bs-toggle="modal" data-bs-target="#myModal" class="rvshortcut '+ (points.length-1) +'"><i class="bi bi-eye"></i></a>';
							// 인포윈도우 작성될 정보(마커 인덱스, 내용) 배열로 저장
							infoContents.push({
								marker: markers.length-1,
								content: '<div class="mapinfo"><a href="partyBoardView?seq=' + datas[i].boardSeq + '" class="meet">' + inner + '</a>' + rvshortcut,
								content2: '<div class="mapinfo"><a href="partyBoardView?seq=' + datas[i].boardSeq + '" class="meet">' + inner + '</a>'
							});
	
						} else {
							infoContents[infoContents.length-1].content = infoContents[infoContents.length-1].content + '<br/><a href="partyBoardView?seq=' + datas[i].boardSeq + '" class="meet">' + inner + '</a>';
							infoContents[infoContents.length-1].content2 = infoContents[infoContents.length-1].content2 + '<br/><a href="partyBoardView?seq=' + datas[i].boardSeq + '" class="meet">' + inner + '</a>';
						}
					}
					
					for(let infoContent of infoContents){
						// 인포윈도우 객체 생성(+ 닫기 기능)
						const infowindow = new kakao.maps.InfoWindow({
				 			content: infoContent.content + '</div>',
				 			removable: true
						});
						
						let marker = markers[infoContent.marker];

						// 마커 클릭시 인포윈도우 열기
						kakao.maps.event.addListener(marker, 'click', () => {
							infowindow.open(map, marker);
						});
						infowindow.open(map, marker);
						
						infos.push(infowindow);
					}
	
					// 검색한 지역에 데이터가 존재하지 않을 시 alert() 지도 중심 변경
					if(datas.length == 0){
			  			Swal.fire({
				  			icon: 'warning',
				  			title: '예정된 모임이 없습니다.',
				  			showCancelButton: true,
				  			reverseButtons: true,
				  			cancelButtonText: '뒤로가기',
				  			confirmButtonText: '확 인'
			  			})
			  			.then(result => {
			  				if(result.isDismissed){
			  					history.back();
			  				}
			  			});
						map.setLevel(10);
						map.setCenter(new kakao.maps.LatLng(37.566661, 126.978378));
						
					} else {
						// 지도를 재설정할 범위정보를 가지고 있을 LatLngBounds 객체를 생성
						let bounds = new kakao.maps.LatLngBounds();
						// LatLngBounds 객체에 좌표를 추가
						for (let point of points) {
							bounds.extend(point.pos);
						}
					    // LatLngBounds 객체에 추가된 좌표들을 기준으로 지도의 범위를 재설정
					    map.setBounds(bounds);
					}
					sbtn.removeAttribute('disabled');
				}
				
				function drawMmap(){
					if(!isloaded){
						for(let infoContent of infoContents){
							const infowindow = new kakao.maps.InfoWindow({
					 			content: infoContent.content2 + '</div>',
					 			removable: true
							});
							const rvinfowindow = new kakao.maps.InfoWindow({
					 			content: infoContent.content2 + '</div>',
					 			removable: true
							});
							
							let mmarker = mmarkers[infoContent.marker];
							let rvmarker = rvmarkers[infoContent.marker];

							kakao.maps.event.addListener(mmarker, 'click', function(){
								infowindow.open(mmap, mmarker);
							});
							kakao.maps.event.addListener(rvmarker, 'click', function(){
								rvinfowindow.open(rv, rvmarker);
							});
							infowindow.open(mmap, mmarker);
							rvinfowindow.open(rv, rvmarker);
							
							minfos.push(infowindow);
							rvinfos.push(rvinfowindow);
						}
						isloaded = true;
					}
				}

				function loadMeet(){
					fetch('/api/party.json/prvcode/0')
					.then(response => response.json())
					.then(jsonData => {
						datas = jsonData;
						// 직전 저장된 infowindow, marker, point 객체 지우기
						for(let i in markers){
							markers[i].setMap(null);
							mmarkers[i].setMap(null);
							rvmarkers[i].setMap(null);
						}
						for(let i in infos){
							infos[i].close();
						}
						for(let i in minfos){
							minfos[i].close();
							rvinfos[i].close();
						}
						
						markers.length = 0;
						mmarkers.length = 0;
						rvmarkers.length = 0;
						infos.length = 0;
						minfos.length = 0;
						rvinfos.length = 0;
						points.length = 0;
						infoContents.length = 0;
						
						isloaded = false;
						
						dosel.options[0].selected = true;
						sisel.options[0].selected = true;
						sisel.setAttribute('disabled', '');
						
						drawMap();
						rvEvent();
						control.style.visibility = 'visible';
					});
				}
				
				document.getElementById('rbtn').onclick = function(){
					control.style.visibility = 'hidden';
					loadMeet();
				}
				
				
				/* 로드뷰 */
				function rvEvent(){
					const rvs = Array.from(document.getElementsByClassName('rvshortcut'));
					rvs.forEach(rv => {
						rv.onclick = () => {
							const index = rv.classList[1];
							map.setLevel(3);
							map.setCenter(markers[index].getPosition());
							activeRoadview();
						}
						
					});
				}
				
				// 마커를 옮길때 로드뷰도 같이 이동
				kakao.maps.event.addListener(rmarker, 'dragend', function(mouseEvent) {
				    // 마커가 놓인 자리의 좌표
				    let position = rmarker.getPosition();
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
						rmarker.setPosition(rvPosition);
					}
				});
				
				kakao.maps.event.addListener(mmap, 'click', function(mouseEvent){
					if(overlayOn){
						let pos = mouseEvent.latLng;
						
						rmarker.setPosition(pos);
						mmap.setCenter(pos);
						
						toggleRoadview(pos);
					}
				});
				
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

						rmarker.setMap(mmap);
						rmarker.setPosition(mmap.getCenter());
						
						mcontrol.classList.add('active');
						
						toggleRoadview(mmap.getCenter());
					}else{
						overlayOn = false;
						
						mmap.removeOverlayMapTypeId(kakao.maps.MapTypeId.ROADVIEW);
						
						rmarker.setMap(null);
						
						mcontrol.classList.remove('active');
					}
				}
				
				const activeRoadview = () => {
					// 클래스 이름 중 active의 존재 유무를 통해 css를 부여해 클릭 효과를 줌
					// classList.add('active') + classList.remove('active')
					control.classList.toggle('active')
					if(control.classList.contains('active')){
						mmap.setLevel(map.getLevel());
						mmap.setCenter(map.getCenter());
						
						toggleOverlay(true);
						toggleRoadview(map.getCenter());
						
						drawMmap();
					}else{
						toggleOverlay(false);
					}
				}
				
				control.onclick = activeRoadview;
				document.getElementById('modal-close').onclick = activeRoadview;
				
				mcontrol.onclick = () => {
					mcontrol.classList.toggle('active');
					if(mcontrol.classList.contains('active')){
						toggleOverlay(true);
					}else{
						toggleOverlay(false);
					}
				};
				
				document.getElementById('close').onclick = () => toggleMapWrapper(true, mmap.getCenter());

				
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
						if(points.length != 0){
							for (point of points) {
								bounds.extend(point.pos);
							}
							map.setBounds(bounds);
						}
						sisel.setAttribute('disabled', '');
						dosel.options[0].selected = true;
						sisel.options[0].selected = true;
			  			Swal.fire({
				  			icon: 'error',
				  			title: '조건에 해당하는 모임이 없습니다.',
				  			confirmButtonText: '확인'
			  			});
					}
				};
				
				const tooltips = Array.from(document.querySelectorAll('[data-bs-toggle="tooltip"]'), tip => new bootstrap.Tooltip(tip));
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
			}
			
			label{
				font-weight: bold;
			}
			
			.mapframe{
				max-width: 1200px;
			}
				
			#map{
				border-radius: 0.5em;
			}
			.mapinfo{
				width:190px;
				text-align:center;
			}
			.refresh{
				display: none;
			}
			
			.swal2-title {
				font-size: 1.5em;
			}
			
			#roadviewControl {position:absolute;top:90%;left:5px;width:42px;height:42px;z-index: 2;cursor: pointer;visibility:hidden; background: url(/assets/img/kakao/img_search.png) 0 -450px no-repeat;}
			#roadviewControl.active {background-position:0 -350px;}
			#container {overflow:hidden;height:50em;position:relative;}
			
			#mapWrapper {width:100%;height:100%;z-index:1;}
			#container.view_roadview #mapWrapper {width: 50%;}
			#mroadviewControl {position:absolute;top:5px;left:5px;width:42px;height:42px;z-index: 2;cursor: pointer; background: url(/assets/img/kakao/img_search.png) 0 -450px no-repeat;}
			#mroadviewControl.active {background-position:0 -350px;}
			
			#rvWrapper {width:50%;height:100%;top:0;right:0;position:absolute;z-index:0;}
			#close {position: absolute;padding: 4px;top: 5px;left: 5px;z-index: 3;cursor: pointer;background: #fff;border-radius: 4px;border: 1px solid #c8c8c8;box-shadow: 0px 1px #888;}
			#close .img {display: block;background: url(/assets/img/kakao/rv_close.png) no-repeat;width: 14px;height: 14px;}
			
			@media (min-width: 576px) and (max-width: 991px){
				.refresh{
					display: inline-block;
				}
			}
			
			@media (min-width: 992px){
				#map-side{
					padding: 0em 1em 0em 1em;
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
					<p class="lead fw-normal text-white-50 mb-0">Search Parties</p>
				</div>
			</div>
		</header>
		<main>
			<!-- 메인 요소 -->
			<div class="d-flex justify-content-center">
				<div class="container-fluid row py-5 mapframe">
					<div id="map" class="col mb-3 border border-5" style="height:600px;">
						<div id="roadviewControl" data-bs-toggle="modal" data-bs-target="#myModal"></div>
					</div>
					<div id="map-side" class="col-lg-3 align-self-center">
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
							<button class="btn btn-primary" id="rbtn" data-bs-toggle="tooltip" data-bs-placement="bottom" title="모임 정보를 갱신합니다." style="width: 20%;"><i class='bi bi-arrow-clockwise'></i><span class="refresh">&nbsp;갱신</span></button>&nbsp;
							<input type="button" class="btn btn-primary" id="sbtn" value="검색" style="width: 80%" disabled/>
						</div>
					</div>
				</div>
			</div>
		</main>
		<!-- Map Modal -->
		<div class="modal" data-bs-backdrop="static" id="myModal">
			<div class="modal-dialog modal-fullscreen"><!-- modal-dialog-centered modal-xl -->
				<div class="modal-content">
					<!-- Modal Header -->
					<div class="modal-header">
						<h5 class="modal-title" style="font-family: SBAggroB;">로드뷰</h5>
						<button type="button" id="modal-close" class="btn-close" data-bs-dismiss="modal"></button>
					</div>
	
					<!-- Modal body -->
					<div class="modal-body">
						<div id="container">
							<div id="rvWrapper">
								<div id="roadview" style="width:100%;height:100%;"></div> <!-- 로드뷰 div -->
								<div id="close" title="로드뷰닫기"><span class="img"></span></div>
							</div>
							<div id="mapWrapper">
								<div id="mmap" style="width:100%;height:100%"></div> <!-- 지도 div -->
								<div id="mroadviewControl"></div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
		<footer>
		<!-- 최하단 디자인 영역 -->
		</footer>
	</body>
</html>