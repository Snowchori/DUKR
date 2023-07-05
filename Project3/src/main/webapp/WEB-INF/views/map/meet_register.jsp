<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Calendar"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/top_bar_declare.jspf" %>
<%
	Calendar cal = Calendar.getInstance();
	
	SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
	cal.setTimeInMillis( cal.getTimeInMillis() + 86400000L );
	String sdate = df.format( cal.getTime() ) + "T00:00";
	
	cal.setTimeInMillis( cal.getTimeInMillis() + 2592000000L );
	
	String ldate = df.format( cal.getTime() ) + "T23:59";
%>
<!doctype html>
<html>

<!-- java 영역 -->

<head>
<!-- 페이지 제목 -->
<title>DUKrule?</title>

<!-- Required meta tags -->
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0, user-scalable=no">

<!-- Bootstrap CSS v5.2.1 -->
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-iYQeCzEYFbKjA/T2uDLTpkwGzCiq6soy8tYaI1GyVh/UjpbCx/TYkiZhlZB6+fzT" crossorigin="anonymous">
<link rel="stylesheet"
	href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.6.0/font/bootstrap-icons.css" />

<!-- Bootstrap JavaScript Libraries -->
<script
	src="https://cdn.jsdelivr.net/npm/@popperjs/core@2.11.6/dist/umd/popper.min.js"
	integrity="sha384-oBqDVmMz9ATKxIep9tiCxS/Z9fNfEXiDAYTujMAeBAsjFuCZSmKbSSUnQlmh/jp3"
	crossorigin="anonymous">
	
</script>

<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.2.1/dist/js/bootstrap.min.js"
	integrity="sha384-7VPbUDkoPSGFnVtYi0QogXtr74QeVeeIs99Qfg5YCF+TidwNdjvaKZX19NZ/e6oz"
	crossorigin="anonymous">
	
</script>

<!-- jQuery Google CDN -->
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.0/jquery.min.js"></script>

<!-- Daum Post API(postcode.v2) -->
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

<!-- kakao Map API -->
<script 
	src="//dapi.kakao.com/v2/maps/sdk.js?appkey=62a899b99d2f71a7e481ba3867c742b7&libraries=services,clusterer,drawing">
	</script>

<!-- SmartEditor2.0
<script src="/smarteditor/js/service/HuskyEZCreator.js" charset="utf-8"></script>
 -->
 
<!-- 자바 스크립트 영역 -->
<script type="text/javascript">
	window.onload = () => {
		/* 다음 주소 검색 API */
		let element_layer = document.getElementById('mbody');

		/* 카카오 맵 주소-좌표 전환 객체 */
		let geocoder = new kakao.maps.services.Geocoder();
		
		// 다음 주소 검색 기능창이 삽입될 레이어(modal-body)의 height, border 속성 초기화 함수
		function initLayerPosition(){
			element_layer.style.height = '510px';
			element_layer.style.border = '1px black solid';
		}

		function convertAdr(addr){
			// 카카오 API geocoder.addressSearch = 비동기 함수
			// 내부 비동기 함수가 끝나는 대로 값을 반환( resolve(반환값) )
			return new Promise((resolve, reject) => {
				
				// geocoder가 주소문자열을 가공해 반환한 result
				const callback = function(result, status){
					if(status === kakao.maps.services.Status.OK){
						const latlng = [result[0].y, result[0].x];
						resolve(latlng);
					}else if(status === kakao.maps.services.Status.ERROR){
						// ERROR : 서버 응답 문제
						reject('서버 응답이 없습니다.\n(관리자에게 문의)');
					}else if(status === kakao.maps.services.Status.ZERO_RESULT){
						// ZERO_RESULT : 정상 응답, 검색 결과는 없음
						reject('다시 시도해주세요.\n(문제가 계속해서 발생한다면 관리자에게 문의)');
					}
				};
				
				// 콜백 -> 주소-좌표 변환이 끝난 후 2번째 인자로 넘겨받은 함수(callback)를 실행
				geocoder.addressSearch(addr, callback); 
			});
		}
		
		document.getElementById('zbtn').onclick = function(){
			initLayerPosition();
			
			new daum.Postcode({
				// 검색결과 항목을 클릭했을때 실행할 코드
				oncomplete: function(data) {
					
					let addr = ''; // 주소 변수
					let extraAddr = ''; // 참고주소 변수
			
					// 사용자가 선택한 주소의 도로명 주소값
					addr = data.roadAddress;
			
					// 법정동명이 있을 경우 추가 (법정리는 제외)
					// 법정동의 경우 마지막 문자가 "동/로/가"로 끝남
					if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
						extraAddr += data.bname;
					}
					
					// 건물명이 있을 경우 추가
					if(data.buildingName !== ''){
						extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
					}
					// 표시할 참고항목이 있을 경우, 괄호까지 추가한 최종 문자열을 만듦
					if(extraAddr !== ''){
						extraAddr = '(' + extraAddr + ')';
					}		
					
					//convertAdr 함수 실행 => 내부 Promise가 return 되면 내부 코드 실행
					// 위도 / 경도를 필드에 삽입
					
					convertAdr(addr).then(latlng => {
						if(typeof(latlng) === 'object'){
							document.getElementById('latitude').value = latlng[0];
							document.getElementById('longitude').value = latlng[1];
						}else if(typeof(latlng) === 'String'){
							alert(latlng);
						}else{
							console.log(latlng);
						}

						// 테스트
						/*
						console.log(document.getElementById('latitude').value);
						console.log(document.getElementById('longitude').value);
						*/
					});
					
					
					// 시구군 코드를 필드에 삽입
					document.getElementById("loccode").value = data.sigunguCode;
					
					// 도로명 주소를 필드에 삽입
					document.getElementById("address").value = addr;
					
					// 조합된 참고주소를 필드에 삽입
					document.getElementById("extra").value = extraAddr;
				},
				
				// 검색결과를 클릭했을때 modal창 숨김
				onclose: function(state){
					$("#modal").modal("hide");
				},
				
				width : '100%',
				height : '100%',
				maxSuggestItems : 5
				
			}).embed(element_layer);
		}
		
		
		
		/* 데이터 무결성 검사 */
		document.getElementById('rbtn').onclick = () => {
			//alert('등록');
			const subject = document.getElementById('subject');
			let date = document.getElementById('date');
			const address = document.getElementById('address');
			const detail = document.getElementById('detail');
			const location = document.getElementById('location');
			const desired = document.getElementById('desired');
			const content = document.getElementById('content');
			
			const min = date.getAttribute('min').replace('T', ' ');
			const max = date.getAttribute('max').replace('T', ' ');
			const sdate = new Date(min);
			const ldate = new Date(max);
			
			switch(0){
				case subject.value.trim().length:
					alert('제목을 입력하세요');
					break;
				case date.value.length:
					alert('날짜를 선택하세요');
					break;
				case address.value.length:
					alert('주소를 선택하세요');
					break;
				case detail.value.trim().length:
					alert('상세주소를 입력하세요');
					break;
				case location.value.trim().length:
					alert('장소 별칭을 입력하세요');
					break;
				default:
					date = new Date(date.value);
					if(sdate <= date && date <= ldate){
						document.getElementById('rfrm').submit();
					}else{
						alert('모임 날짜는 내일부터 한달이내로 설정 가능합니다.\n(' + min + ' ~ ' + max + ')');
					}
			}
			
		}
	};
</script>

<!-- 개별 CSS -->
<style type="text/css">	
	@font-face {
		font-family: 'SBAggroB';
		src: url('https://cdn.jsdelivr.net/gh/projectnoonnu/noonfonts_2108@1.1/SBAggroB.woff') format('woff');
		font-weight: normal;
		font-style: normal;
	}
	
	.title{
		font-family: SBAggroB;
	}
	
	html {
		min-width : 280px;
	}
	
	a {
		text-decoration: none;
	}
	
	label{
		font-weight: bold;
	}
	
	.bottombody{
		max-width: 1920px;
	}
	
	@media (max-width: 575px){
		.formframe{
			margin: 0em 0em 5em 0em;
			padding:5em 0em 5em 0em;
		}
	}
	
	@media (min-width: 576px){
		.formframe{
			margin: 0em 0em 5em 0em;
			padding:5em 2em 5em 2em;
		}
	}
	
	@media (min-width: 768px){
		.formframe{
			margin: 0em 5em 5em 5em;
			padding: 5em 2em 5em 2em;
		}
	}
	
	@media (min-width: 992px){
		.formframe{
			margin: 0em 5em 5em 5em;
			padding: 5em 5em 5em 5em;
		}
	}
</style>
</head>

<body>
<%@ include file="/WEB-INF/views/include/top_bar_header.jspf" %>
	<header class="py-5 bg-secondary">
		<div class="container px-4 px-lg-5 my-5">
			<div class="text-center text-white">
				<h1 class="title">모임등록</h1>
				<p class="lead fw-normal text-white-50 mb-0">Register Meeting</p>
			</div>
		</div>
	</header>
	<main class="d-flex justify-content-center">
		<!-- 메인 요소 -->
		<div class="container-fluid d-flex justify-content-center bg-light bottombody">
		 
			<div class="container d-flex justify-content-around formframe">
				<form action="meetRegisterOk" class="row" id="rfrm" name="rfrm" method="post">
					<input type="hidden" id="latitude" name="latitude"/>
					<input type="hidden" id="longitude" name="longitude"/>
					<input type="hidden" id="loccode" name="loccode"/>
					<div class="col-md-6 mb-3">
						<label for="subject" class="form-label">제목</label>
						<input type="text" class="form-control" placeholder="제목을 입력하세요" name="subject" id="subject"/>
					</div>
					<div class="col-md-6 mb-3">
						<label for="date" class="form-label">날짜 선택</label>
						<input type="datetime-local" min="<%=sdate%>" max="<%=ldate%>" class="form-control" id="date" name="date"/>
					</div>
					<div class="col-12 mb-3">
						<label for="address" class="form-label">모임 장소</label>
						<div class="input-group">
							<input type="text" class="form-control" id="address" name="address" placeholder="주소" readonly>
							<input type="button" id="zbtn" class="btn btn-outline-primary" data-bs-toggle="modal" data-bs-target="#modal" value="우편번호 찾기"/>
						</div>
					</div>
					<div class="col-md-6 mb-3">
						<input type="text" class="form-control" id="detail" name="detail" placeholder="상세주소">
					</div>
					<div class="col-md-6 mb-3">
						<input type="text" class="form-control" id="extra" name="extra" placeholder="(동, 건물명)" readonly>
					</div>
					<div class="col-md-6 mb-3">
						<label for="location" class="form-label">장소 별칭</label>
						<input type="text" class="form-control" id="location" name="location" placeholder="별칭">
					</div>
					<div class="col-md-6 mb-3">
						<label for="desired" class="form-label">희망인원 수</label>
						<select class="form-select" id="desired" name="desired">
							<option value="2">2</option>
							<option value="3">3</option>
							<option value="4">4</option>
							<option value="5">5</option>
							<option value="6">6</option>
							<option value="7">7</option>
							<option value="8">8</option>
						</select>
					</div> 
					<div class="col-12 mb-3">
						<label for="content" class="form-label">내용</label>
						<textarea
							class="form-control"
							name="content"
							id="content"
							rows="15"
							placeholder="내용을 입력하세요"
							style="resize: none;"
						></textarea>
					</div>
					<div class="col-12 mb-3 d-flex justify-content-end">
						<input type="button" class="btn btn-dark mx-2" value="취소" onclick="alert('취소');"/>
						<input type="button" class="btn btn-primary" id="rbtn" value="등록"/>
					</div>
				</form>
			</div>
			<!-- Modal Zipcode -->
			<div class="modal" id="modal" data-bs-backdrop="static" data-bs-keyboard="false">
				<div class="modal-dialog modal-dialog-centered modal-fullscreen-sm-down">
					<div class="modal-content" style="">
			
						<!-- Modal Header -->
						<div class="modal-header">
							<h6 class="modal-title">우편번호 선택</h6>
							<button type="button" class="btn-close" data-bs-dismiss="modal"></button>
						</div>
			
						<!-- Modal body -->
						<div id="mbody" class="modal-body">
						</div>
			
						<!-- Modal footer -->
						<div class="modal-footer">
						</div>
			
					</div>
				</div>
			</div>
		</div>
	</main>
	<footer>
		<!-- 최하단 디자인 영역 -->
	</footer>
</body>

</html>