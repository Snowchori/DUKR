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
			});
		</script>
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
			.selection > div > div{
				padding: 5px 0 5px 0;
				border: 1px #cacaca solid;
				box-sizing: border-box;
				cursor: pointer;
			}
			.selection > div > div:hover{
				background-color: #f2f2f2;
			}
			#map{
				border-radius: 0.5em;
			}
			#map-side{
				height: 100%;
			}
			.sideframe{
				border-radius: 0.5em;
			}
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
				
				<div class="row py-5 g-2 mapframe">
					<div id="map" class="col border border-2" style="width:1000px;height:600px;">
						<div id="roadviewControl" data-bs-toggle="modal" data-bs-target="#myModal"></div>
					</div>
					<div id="map-side px-0" class="col-lg-4 align-self-center">
						<div class="sideframe border border-2">
							<ul class="nav nav-tabs nav-justified mt-1" id="partyTab" role="tablist">
								<li class="nav-item">
									<button class="nav-link active" id="all-tab" data-bs-toggle="tab" data-bs-target="#all-party">전체</button>
								</li>
								<li class="nav-item">
									<button class="nav-link" id="approved-tab" data-bs-toggle="tab" data-bs-target="#approved-party">승인</button>
								</li>
								<li class="nav-item">
									<button class="nav-link" id="applied-tab" data-bs-toggle="tab" data-bs-target="#applied-party">미승인</button>
								</li>
							</ul>
							<!-- 탭 내용 -->
							<div class="tab-content text-center">
								<div class="tab-pane active" id="all-party">
									<table class="table table-bordered">
										<thead>
											<tr>
												<th>모임명</th>
												<th>주소</th>
												<th>승인일자</th>
												<th>신청일자</th>
											</tr>
										</thead>
										<tbody>
											<tr>
												<td>모임명</td>
												<td>모임명</td>
												<td>모임명</td>
												<td>모임명</td>
											</tr>
											<tr>
												<td>모임명</td>
												<td>모임명</td>
												<td>모임명</td>
												<td>모임명</td>
											</tr>
											<tr>
												<td>모임명</td>
												<td>모임명</td>
												<td>모임명</td>
												<td>모임명</td>
											</tr>
											<tr>
												<td>모임명</td>
												<td>모임명</td>
												<td>모임명</td>
												<td>모임명</td>
											</tr>
											<tr>
												<td>모임명</td>
												<td>모임명</td>
												<td>모임명</td>
												<td>모임명</td>
											</tr>
											<tr>
												<td>모임명</td>
												<td>모임명</td>
												<td>모임명</td>
												<td>모임명</td>
											</tr>
											<tr>
												<td>모임명</td>
												<td>모임명</td>
												<td>모임명</td>
												<td>모임명</td>
											</tr>
											<tr>
												<td>모임명</td>
												<td>모임명</td>
												<td>모임명</td>
												<td>모임명</td>
											</tr>
											<tr>
												<td>모임명</td>
												<td>모임명</td>
												<td>모임명</td>
												<td>모임명</td>
											</tr>
											<tr>
												<td>모임명</td>
												<td>모임명</td>
												<td>모임명</td>
												<td>모임명</td>
											</tr>
										</tbody>
									</table>
								</div>
								<div class="tab-pane fade" id="approved-party"></div>
								<div class="tab-pane fade" id="applied-party"></div>
							</div>
							<div class="text-center">
								<ul class="pagination justify-content-center">
									<li class="page-item"><a class="page-link" href="#">&lt;</a></li>
									<li class="page-item active"><a class="page-link" href="#">1</a></li>
									<li class="page-item"><a class="page-link" href="#">2</a></li>
									<li class="page-item"><a class="page-link" href="#">3</a></li>
									<li class="page-item"><a class="page-link" href="#">&gt;</a></li>
								</ul>
							</div>
						</div>
					</div>
				</div>
			</div>
			<!-- 버튼 디자인 -->
	  		<!-- 마이페이지 정보페이지 디자인 -->
		</main>
		<!-- 최하단 디자인 영역 -->
		<footer>
		</footer>
	</body>
</html>