<%@page import="com.example.model.party.PartyTO"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.Calendar"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/top_bar_declare.jspf" %>
<%
	BoardTO boardTo = (BoardTO)request.getAttribute("boardTo");
	String subject = boardTo.getSubject();
	String content = boardTo.getContent();
	
	PartyTO partyTo = (PartyTO)request.getAttribute("partyTo");
	String totalAddress = partyTo.getAddress();
	String address = "";
	String extra = "";
	if(totalAddress.contains("(")){
		address = totalAddress.split("\\(")[0];
		extra = "(" + totalAddress.split("\\(")[1];
	}else{
		address = totalAddress;
	}
	String detail = partyTo.getDetail();
	String location = partyTo.getLocation();
	String date = partyTo.getDate();
	date = date.substring(0, 16);
	date = date.replace(" ", "T");
	String desired = partyTo.getDesired();
%>
<%
	/* 선택 가능한 최소, 최대 날짜 계산 */
	Calendar cal = Calendar.getInstance();
	
	SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd");
	cal.setTimeInMillis( cal.getTimeInMillis() + 86400000L );
	String sdate = df.format( cal.getTime() ) + "T00:00";
	
	cal.setTimeInMillis( cal.getTimeInMillis() + 2592000000L );
	
	String ldate = df.format( cal.getTime() ) + "T23:59";
%>
<!doctype html>
<html>
	<head>
		<%@ include file="/WEB-INF/views/include/head_setting.jspf" %>
		<!-- jQuery Google CDN -->
		<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.0/jquery.min.js"></script>
		<!-- Daum Post API(postcode.v2) -->
		<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
		<!-- kakao Map API -->
		<script src="//dapi.kakao.com/v2/maps/sdk.js?appkey=62a899b99d2f71a7e481ba3867c742b7&libraries=services,clusterer,drawing">
		</script>
		<!-- CKEditor5 -->
		<script src="https://cdn.ckeditor.com/ckeditor5/34.0.0/classic/ckeditor.js"></script>
		<!-- 자바 스크립트 영역 -->
		<script type="text/javascript">
			window.addEventListener('DOMContentLoaded', () => {
				
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
							} else if (status === kakao.maps.services.Status.ERROR){
								// ERROR : 서버 응답 문제
								reject('서버 응답이 없습니다.\n(관리자에게 문의)');
							} else if (status === kakao.maps.services.Status.ZERO_RESULT){
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
							let tag = ''; // 도(시) 변수
							
							// 사용자가 선택한 주소의 도로명 주소값
							addr = data.roadAddress;
							
							// 사용자가 선택한 주소의 도(시) 값
							if(addr != null && addr.length >= 2){
								tag = addr.substring(0, 2);
							}
							
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
								} else if (typeof(latlng) === 'String'){
									alert(latlng);
								} else {
									console.log(latlng);
								}
								
								// 도(시) 명을 필드에 삽입
								document.getElementById('tag').value = tag;
								
								// 시구군 코드를 필드에 삽입
								document.getElementById("loccode").value = data.sigunguCode;
								
								// 도로명 주소를 필드에 삽입
								document.getElementById("address").value = addr;
								
								// 조합된 참고주소를 필드에 삽입
								document.getElementById("extra").value = extraAddr;
								
								adr_ok = true;
								address.classList.remove('is-invalid');
								address.classList.add('is-valid');
							});
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
				
				// 수정 전 기본정보 로드
				$('#subject').val("<%=subject %>");
				$('#address').val("<%=address %>");
				$('#extra').val("<%=extra %>");
				$('#detail').val("<%=detail %>");
				$('#location').val("<%=location %>");
				$('#content').val('<%=content %>');
				const desId = 'des' + '<%=desired %>';
				$('#' + desId).prop("selected", true);
				$('#date').val("<%=date %>");
				
				/* 데이터 유효성 검사 */
				// 제목
				const subject = document.getElementById('subject');
				// 날짜선택
				const date = document.getElementById('date');
				const sdate = new Date(date.getAttribute('min'));
				const ldate = new Date(date.getAttribute('max'));
				// 모임 장소
				const address = document.getElementById('address');
				// 상세 주소
				const detail = document.getElementById('detail');
				// 장소 별칭
				const location = document.getElementById('location');
				
				let subject_ok = false;
				let date_ok = false;
				let adr_ok = false;
				let detail_ok = false;
				let loc_ok = false;
				
				subject.addEventListener('input', () => {
					if(subject.value.length >= 2){
						subject_ok = true;
						subject.classList.remove('is-invalid');
						subject.classList.add('is-valid');
					}else{
						subject_ok = false;
						subject.classList.remove('is-valid');
						subject.classList.add('is-invalid');
					}
				});
				date.addEventListener('input', () => {
					const pdate = new Date(date.value);
					if(date.value.length > 0){
						if(sdate < pdate && pdate < ldate){
							date_ok = true;
							date.classList.remove('is-invalid');
							date.classList.add('is-valid');
						}else{
							date_ok = false;
							date.classList.remove('is-valid');
							date.classList.add('is-invalid');
						}
					}else{
						date_ok = false;
						date.classList.remove('is-valid');
						date.classList.add('is-invalid');
					}
				});
				detail.addEventListener('input', () => {
					if(detail.value.length >= 2){
						detail_ok = true;
						detail.classList.remove('is-invalid');
						detail.classList.add('is-valid');
					}else{
						detail_ok = false;
						detail.classList.remove('is-valid');
						detail.classList.add('is-invalid');
					}
				});
				location.addEventListener('input', () => {
					if(location.value.length >= 2){
						loc_ok = true;
						location.classList.remove('is-invalid');
						location.classList.add('is-valid');
					}else{
						loc_ok = false;
						location.classList.remove('is-valid');
						location.classList.add('is-invalid');
					}
				});

				let ckeditor;
				document.getElementById('rbtn').onclick = () => {
					switch(false){
						case subject_ok: 
							subject.classList.remove('is-valid');
							subject.classList.add('is-invalid');
							document.location.href='#subject';
							break;
						case date_ok: 
							date.classList.remove('is-valid');
							date.classList.add('is-invalid');
							document.location.href='#date';
							break;
						case adr_ok: 
							address.classList.remove('is-valid');
							address.classList.add('is-invalid');
							document.location.href='#address';
							break;
						case detail_ok: 
							detail.classList.remove('is-valid');
							detail.classList.add('is-invalid');
							document.location.href='#detail';
							break;
						case loc_ok: 
							location.classList.remove('is-valid');
							location.classList.add('is-invalid');
							document.location.href='#location';
							break;
						default: 
							$.ajax({
								url:'partyBoardRegisterOk',
								type:'post',
								data: {
									subject: document.getElementById('subject').value.trim(),
									content: ckeditor.getData(),
									tag: document.getElementById('tag').value.trim(),
									address: document.getElementById('address').value.trim(),
									extra: document.getElementById('extra').value.trim(),
									detail: document.getElementById('detail').value.trim(),
									location: document.getElementById('location').value.trim(),
									date: document.getElementById('date').value.trim(),
									desired: document.getElementById('desired').value.trim(),
									loccode: document.getElementById('loccode').value.trim(),
									latitude: document.getElementById('latitude').value.trim(),
									longitude: document.getElementById('longitude').value.trim()
								},
								success: function(data) {
									if(data == 0) {
										Swal.fire({
											icon: 'success',
											title: '글쓰기 완료',
											confirmButtonText: '확인',
											willClose: () => {
												document.location.href='partyBoardList';
											}
										});
									} else {
										Swal.fire({
											icon: 'error',
											title: '글쓰기 실패',
											confirmButtonText: '확인'
										});
									}
								}
							});
					}
				}
	
				/* CKEditor5 설정 */
				ClassicEditor.create(document.getElementById('content'),{
					language: "ko",
					ckfinder: {
						uploadUrl : '/upload/freeboard'
					}
				})
				.then(editor => {
					ckeditor = editor;
				})
				.catch(error => {
					console.error(error);
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
			}
			
			label{
				font-weight: bold;
			}
			
			.bottombody{
				max-width: 992px;
			}
			.essential{
				color: red;
			}
		
			.ck-editor__editable { height: 400px; }
		</style>
	</head>
	<body>
		<%@ include file="/WEB-INF/views/include/top_bar_header.jspf" %>
		<header class="py-5 bg-secondary">
			<div class="container px-4 px-lg-5 my-5">
				<div class="text-center text-white">
					<h1 class="title" id="title">모임등록</h1>
					<p class="lead fw-normal text-white-50 mb-0">Register Party</p>
				</div>
			</div>
		</header>
		<main>
			<!-- 메인 요소 -->
			<div class="container-fluid my-4 bottombody">
				<form action="partyBoardRegisterOk" class="row" id="rfrm" name="rfrm" method="post">
					<input type="hidden" id="tag" name="tag"/>
					<input type="hidden" id="latitude" name="latitude"/>
					<input type="hidden" id="longitude" name="longitude"/>
					<input type="hidden" id="loccode" name="loccode"/>
					<div class="col-md-6 mb-3">
						<label for="subject" class="form-label">제목 <span class="essential">*</span></label>
						<input type="text" class="form-control" placeholder="제목" name="subject" id="subject"/>
						<div class="invalid-feedback">제목을 2자 이상 입력하셔야 합니다.</div>
					</div>
					<div class="col-md-6 mb-3">
						<label for="date" class="form-label">날짜 선택 <span class="essential">*</span></label>
						<input type="datetime-local" min="<%=sdate%>" max="<%=ldate%>" class="form-control" id="date" name="date"/>
						<div class="invalid-feedback">날짜를 선택하셔야 합니다. (<%= sdate.replace("T", " ") %> ~ <%= ldate.replace("T", " ") %>)</div>
					</div>
					<div class="col-12 mb-3">
						<label for="address" class="form-label">모임 장소 <span class="essential">*</span></label>
						<div class="input-group has-validation">
							<input type="text" class="form-control" id="address" name="address" placeholder="주소" readonly>
							<input type="button" id="zbtn" class="btn btn-outline-primary" data-bs-toggle="modal" data-bs-target="#modal" value="우편번호 찾기"/>
							<div class="invalid-feedback">주소를 선택하셔야 합니다.</div>
						</div>
					</div>
					<div class="col-md-6 mb-3">
						<input type="text" class="form-control" id="detail" name="detail" placeholder="상세주소">
						<div class="invalid-feedback">상세주소를 2자 이상 입력하셔야 합니다.</div>
					</div>
					<div class="col-md-6 mb-3">
						<input type="text" class="form-control" id="extra" name="extra" placeholder="(동, 건물명)" readonly>
					</div>
					<div class="col-md-6 mb-3">
						<label for="location" class="form-label">장소 별칭 <span class="essential">*</span></label>
						<input type="text" class="form-control" id="location" name="location" placeholder="별칭">
						<div class="invalid-feedback">장소 별칭을 2자 이상 입력하셔야 합니다.</div>
					</div>
					<div class="col-md-6 mb-3">
						<label for="desired" class="form-label">희망인원 수 <span class="essential">*</span></label>
						<select class="form-select" id="desired" name="desired">
							<option id="des2" value="2">2</option>
							<option id="des3" value="3">3</option>
							<option id="des4" value="4">4</option>
							<option id="des5" value="5">5</option>
							<option id="des6" value="6">6</option>
							<option id="des7" value="7">7</option>
							<option id="des8" value="8">8</option>
						</select>
					</div> 
					<div class="col-12 mb-3">
						<label for="content" class="form-label">내용</label>
						<textarea name="content" id="content" maxlength="10000" style="display: none;"></textarea>
					</div>
					<div class="col-12 d-flex justify-content-end">
						<input type="button" class="btn btn-dark mx-2" value="취소" onclick="history.back();"/>
						<input type="button" class="btn btn-dark" id="rbtn" value="등록"/>
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
		</main>
		<footer>
			<!-- 최하단 디자인 영역 -->
		</footer>
	</body>
</html>