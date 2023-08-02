<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/top_bar_declare.jspf" %>
<!doctype html>
<html>
	<head>
		<%@ include file="/WEB-INF/views/include/head_setting.jspf" %>
		<!-- Template Main CSS File -->
		<link href="assets/css/style.css" rel="stylesheet">
		<!-- kakao Map API -->
		<script src="//dapi.kakao.com/v2/maps/sdk.js?appkey=62a899b99d2f71a7e481ba3867c742b7">
		</script>
		<!-- 자바 스크립트 영역 -->
		<script type="text/javascript">
			userSeq = <%= userSeq %>;
			$(() => {
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
				const mcontainer = document.getElementById('mmap');
				const moptions = {
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
				
				
				let today = new Date();
				
				let datas = null;
				
				/* marker 객체 정보를 저장할 배열 */
				let markers = [];
				let mmarkers = [];
				let rvmarkers = [];
				/* 마커가 위치한 좌표 저장할 배열 */
				let points = [];
				
				let infoContents = [];
				
				let isloaded = false;
				
				$.ajax({
					url: '/api/party.json/user/' + userSeq,
					success: result => {
						datas = result;
						for(let data of datas){
							const tmp = new Date(data.date);
							
							let month = String(tmp.getMonth() + 1);
							let date = String(tmp.getDate());
							if(month.length == 1){
								month = '0' + month;
							}
							if(date.length == 1){
								date = '0' + date;
							}
							data.date = month + "/" + date;
							
							if(tmp < today){
								data.strike = 'strike';
							}else{
								data.strike = '';
							}
							
							switch(data.status){
							case "2":
								data.status = 'accepted';
								break;
							case "1":
								data.status = 'applied';
								break;
							case "-1":
								data.status = 'canceled';
								break;
							case "-2":
								data.status = 'denied';
								break;
							}
						}
						setTimeout(() => drawMap(datas), 100);
					},
					error: (xhr, status, error) => {
						alert(`모임 정보를 불러오는 중 문제가 발생했습니다.\n[\${status}]\${error}`);
					}
				});
				
				function drawMap(datas){
					for(let i in datas){
						// 인포윈도우에 작성될 내용 미리 가공
						const inner = datas[i].location + '('+ datas[i].date +')';
						
						// 첫 데이터 or 직전 데이터의 주소와 현 주소가 다를때 인포윈도우 새로 생성
						if( (i == 0) || (datas[i-1].address !== datas[i].address) ){
							pos = new kakao.maps.LatLng(datas[i].latitude, datas[i].longitude);
							points.push({
								pos: pos
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
							mmarkers.push(mmarker);

							let rvmarker = new kakao.maps.Marker({
								map: rv,
								position: pos
							});
							rvmarkers.push(rvmarker);
							
							let rvshortcut = '&nbsp;<a href="javascript:void(0);" data-bs-toggle="modal" data-bs-target="#myModal" class="rvshortcut '+ (points.length-1) +'"><i class="bi bi-eye"></i></a>';
							// 인포윈도우 작성될 정보(마커 인덱스, 내용) 배열로 저장
							infoContents.push({
								marker: markers.length-1,
								content: `<div class="mapinfo"><a href="partyBoardView?seq=\${datas[i].boardSeq}" class="meet \${datas[i].strike} \${datas[i].status}">\${inner}</a>\${rvshortcut}`,
								content2: `<div class="mapinfo"><a href="partyBoardView?seq=\${datas[i].boardSeq}" class="meet \${datas[i].strike} \${datas[i].status}">\${inner}</a>`
							});

						} else {
							infoContents[infoContents.length-1].content = infoContents[infoContents.length-1].content + `<br/><a href="partyBoardView?seq=\${datas[i].boardSeq}" class="meet \${datas[i].strike} \${datas[i].status}">\${inner}</a>`;
							infoContents[infoContents.length-1].content2 = infoContents[infoContents.length-1].content2 + `<br/><a href="partyBoardView?seq=\${datas[i].boardSeq}" class="meet \${datas[i].strike} \${datas[i].status}">\${inner}</a>`;
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
					}

					const rvs = Array.from(document.getElementsByClassName('rvshortcut'));
					rvs.forEach(rv => {
						rv.onclick = function(){
							const index = rv.classList[1];
							map.setLevel(3);
							map.setCenter(markers[index].getPosition());
							activeRoadview();
						};
					});
					
					if(datas.length == 0){
			  			Swal.fire({
				  			icon: 'warning',
				  			title: '참여신청한 모임이 없습니다.',
				  			confirmButtonText: '확 인'
			  			});
						
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
				}
				
				function drawMmap(){
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
					}
					isloaded = true;
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
							rv.setPanoId(panoId, position);
							toggleMapWrapper(false, position);
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
						
						if(!isloaded){
							drawMmap();
						}
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
			});
		</script>
		<style type="text/css">
			#roadviewControl {visibility:visible;}
		</style>
	</head>
	<body>
		<%@ include file="/WEB-INF/views/include/top_bar_header.jspf" %>
		<header class="py-5 bg-secondary">
			<div class="container px-4 px-lg-5 my-5">
				<div class="text-center text-white">
					<h1 class="title">마이페이지</h1>
					<p class="lead fw-normal text-white-50 mb-0">MyPage</p>
				</div>
			</div>
		</header>
		<main>
	  		<!-- 버튼 디자인 -->
			<div class="container mt-3">
				<div class="row g-1 text-center selection">
					<div class="col-6 col-lg-3" onClick="location.href='/mypage'"><div>회원 정보 변경</div></div>
					<div class="col-6 col-lg-3" onClick="location.href='/mywrite'"><div>내가 쓴 글</div></div>
					<div class="col-6 col-lg-3" onClick="location.href='/mycomment'"><div>내가 쓴 댓글</div></div>
					<div class="col-6 col-lg-3" onClick="location.href='/favwrite'"><div>좋아요 한 글</div></div>
					<div class="col-6 col-lg-3" onClick="location.href='/favgame'"><div>즐겨찾기 한 게임</div></div>
					<div class="col-6 col-lg-3" onClick="location.href='/mail'"><div>쪽지함</div></div>
					<div class="col-6 col-lg-3" onClick="location.href='/admin'"><div>문의하기</div></div>
					<div class="col-6 col-lg-3" onClick="location.href='/myparty'"><div>참여신청한 모임</div></div>
				</div>
			<!-- 버튼 디자인 -->
	  		<!-- 마이페이지 정보페이지 디자인 -->
				<div class="row py-5 g-2">
					<div id="map" class="col border border-5" style="height:800px;">
						<div id="roadviewControl" data-bs-toggle="modal" data-bs-target="#myModal"></div>
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
		<!-- 최하단 디자인 영역 -->
		<footer>
		</footer>
	</body>
</html>