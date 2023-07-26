<%@page import="java.util.Locale"%>
<%@page import="java.time.format.DateTimeFormatter"%>
<%@page import="java.time.LocalDateTime"%>
<%@page import="java.time.LocalDate"%>
<%@page import="java.util.Date"%>
<%@page import="java.util.Calendar"%>
<%@page import="com.example.model.party.PartyTO"%>
<%@page import="org.springframework.beans.factory.annotation.Autowired"%>
<%@page import="com.example.model.comment.CommentDAO"%>
<%@page import="com.example.model.party.ApplyTO"%>
<%@page import="com.example.model.comment.CommentTO"%>
<%@page import="com.example.model.comment.CommentListTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/top_bar_declare.jspf"%>

<%
	int cpage = 1;
	if(request.getParameter("cpage") != null && !request.getParameter("cpage").equals("")){
		cpage = Integer.parseInt(request.getParameter("cpage"));
	}

	BoardTO to = (BoardTO)request.getAttribute("to");
	
	String boardSeq = to.getSeq();
	
	String subject = to.getSubject();
	String writer = to.getWriter();
	String memSeq = to.getMemSeq();
	String content = to.getContent();
	String wdate = to.getWdate();
	String wip = to.getWip();
	String hit = to.getHit();
	String recCnt = to.getRecCnt();
	String cmtCnt = to.getCmtCnt();
%>
<%
	PartyTO pto = (PartyTO)request.getAttribute("pto");
	
	String address = pto.getAddress();
	String address2 = address;
	if(address2.contains("(")){
		address2 = address2.substring(0, address2.indexOf("("));
	}
	String detail = pto.getDetail();
	String location = pto.getLocation();
	String date = pto.getDate().replace(" ", "T");
	LocalDateTime ldt = LocalDateTime.parse(date);
	String date2 = ldt.format(DateTimeFormatter.ofPattern("yy년 MM월 dd일(E) a HH시 mm분").withLocale(Locale.forLanguageTag("ko")));
	String desired = pto.getDesired();
	String participants = pto.getParticipants();
	String latitude = pto.getLatitude();
	String longitude = pto.getLongitude();
	int status = Integer.parseInt(pto.getStatus());
	
	StringBuilder partyAddress = new StringBuilder("[" + location + "] ").append(address).append("&nbsp;-&nbsp;").append(detail);
%>
<%
	String comments = (String)request.getAttribute("comments");
%>
<%
	boolean isWriter = (boolean)request.getAttribute("isWriter");
	ArrayList<ApplyTO> atos = (ArrayList<ApplyTO>)request.getAttribute("atos");

	String strApply = "";
	StringBuilder reportBtn = new StringBuilder();
	StringBuilder delmodBtn = new StringBuilder();
	StringBuilder sbForm = new StringBuilder();
	
	String manBtn = "";
	if(!isWriter){
		strApply = "&nbsp;<button id='appBtn' class='btn btn-dark'><i id='appIcon' class='bi bi-patch-check'></i>&nbsp;<span id='appText'>참여신청</span></button>";
		reportBtn.append("<button class='btn btn-dark mx-3' style='margin-left: auto;' onclick='report(").append(boardSeq).append(", \"board\")'>신고</button>");
	}else{
		manBtn = "&nbsp;<button id='manBtn' class='btn btn-success'><i class='bi bi-wrench'></i>&nbsp;참여관리</button>";
		
		delmodBtn.append("<button class='btn btn-dark' style='margin-left: auto;' onclick='partyBoardDelete(").append(boardSeq).append(")'>삭제</button>")											
		.append("&nbsp;<button class='btn btn-dark' style='margin-left: auto;' onclick='location.href=\"partyBoardModify?seq=").append(boardSeq).append("\"'>수정</button>");
		
		// 참여관리 페이지 전송 폼
		sbForm.append("<form action='/partyManage' target='applyManage' method='post' id='aform'>");
		sbForm.append("<input type='hidden' name='boardSeq' value=" + boardSeq + ">");
		sbForm.append("<input type='hidden' name='memSeq' value=" + memSeq + "></form>");
	}
	
	boolean didUserRec = (boolean)request.getAttribute("didUserRec");
	String recBtnColor = "btn-dark";
	if(didUserRec){
		recBtnColor = "btn-primary";
	}
	
%>
<!doctype html>
<html>
	<head>
		<%@ include file="/WEB-INF/views/include/head_setting.jspf"%>
		<!-- Template Main CSS File -->
		<link href="assets/css/style.css" rel="stylesheet">
		<!-- kakao Map API -->
		<script src="//dapi.kakao.com/v2/maps/sdk.js?appkey=62a899b99d2f71a7e481ba3867c742b7&libraries=services,clusterer"></script>
		<!-- 자바 스크립트 영역 -->
		<script type="text/javascript">
			$(() => {
				const bseq = <%= boardSeq %>, mseq = <%= memSeq %>, useq = <%= userSeq %>, isWriter = <%= isWriter %>;
				let status = <%= status %>;
				
				// 지도 생성
				const container = document.getElementById('map'),
				position = new kakao.maps.LatLng(<%=latitude%>, <%=longitude%>),
				options = {
					center: position,
					level: 6
				};
				let map = new kakao.maps.Map(container, options);
				const marker = new kakao.maps.Marker({
					map: map,
					position: position
				});
				
				document.getElementById('linkMap').onclick = function(){
					lat = position.getLat(),
					lng = position.getLng();
					window.open('https://map.kakao.com/link/map/' + encodeURIComponent('<%=address2%>') + ',' + lat + ',' + lng);
				}
				
				document.getElementById('resetMap').onclick = function(){
					map.setCenter(position);
					map.setLevel(6);
				}
				
				// 일반 지도와 스카이뷰로 지도 타입을 전환할 수 있는 지도타입 컨트롤 생성
				const mapTypeControl = new kakao.maps.MapTypeControl();
				// 지도 확대 축소를 제어할 수 있는 줌 컨트롤을 생성
				const zoomControl = new kakao.maps.ZoomControl();
				// 지도에 컨트롤을 추가
				// kakao.maps.ControlPosition 컨트롤이 표시될 위치를 정의 TOPLEFT는 왼쪽 위를 의미
				map.addControl(mapTypeControl, kakao.maps.ControlPosition.TOPLEFT);
				map.addControl(zoomControl, kakao.maps.ControlPosition.LEFT);
				
				document.getElementById('loadmap').onclick = function(){
					if(container.style.display === 'none'){
						container.style.display = 'block';
						map.relayout();
						map.setCenter(position);
					}else{
						container.style.display = 'none';
					}
				}
				
				function loggedin(){
					if (useq !== null) {
						return true;
					} else {
						Swal.fire({
							icon : 'warning',
							title : '로그인 필요'
						});
						return false;
					}
				}
				
				// 글 추천하기
				document.getElementById("recBtn").onclick = function() {
					$.ajax({
						url : '/rec',
						type : 'post',
						data : {
							boardSeq: bseq,
							userSeq: useq,
							isWriter: isWriter
						},
						success : function(result) {
							const res = (result % 10);
							const updatedRecCnt = Math.floor(result / 10);
							
							if(res == 2){
								alert('먼저 로그인 해야합니다');
							}else if(res == 3){
								$('#viewRecCnt').html(updatedRecCnt);
								$('#recBtn').removeClass('btn-primary').addClass('btn-dark');

								alert('게시글 추천을 취소했습니다');
							}else if(res == 0){
								alert('알 수 없는 추천 오류');
							}else{
								$('#viewRecCnt').html(updatedRecCnt);
								$('#recBtn').removeClass('btn-dark').addClass('btn-primary');

								alert('글을 추천했습니다');
							}
						}
					});
				};
		
				// 댓글쓰기
				document.getElementById("cmtWbtn").onclick = function() {
					if(document.getElementById("cContent").value.trim() == ''){
						Swal.fire({
				  			icon: 'error',
				  			title: '내용을 입력하세요',
				  			confirmButtonText: '확인',
				  			timer: 1500,
				  			timerProgressBar : true
			  			});
						
						return false;
					}
					
					$.ajax({
						url : '/freeboardCommentWrite',
						type : 'post',
						data : {
							boardSeq : bseq,
							memSeq : useq,
							content : document.getElementById("cContent").value,
						},
						success : function(res) {
							if (res != "") {
								$('#comments').html(res);
								$('#cContent').val('');
								
								let numberOfComments = res.split("<span class='dropdown'").length - 1;
								$('#viewCmtCnt').html(numberOfComments);	
							} else {
								alert("먼저 로그인 해야합니다");
								console.log(res);
							}
						}
					});
				};

				let appIcon = null;
				let appText = null;
				if(!isWriter){
					appBtn = document.getElementById("appBtn");
					appIcon = document.getElementById("appIcon");
					appText = document.getElementById("appText");
					
					if(status == 1){
						appText.innerText = '신청완료';
						appIcon.className = "bi bi-patch-check-fill";
						appBtn.classList.remove('btn-dark');
						appBtn.classList.add('btn-success');
					}else if(status == 2){
						appText.innerText = '승인됨';
						appIcon.className = "bi bi-person-check-fill";
						appBtn.classList.remove('btn-dark');
						appBtn.classList.add('btn-success');
					}else if(status == -2){
						appText.innerText = '거부됨';
						appIcon.className = "bi bi-x-octagon";
						appBtn.classList.remove('btn-dark');
						appBtn.classList.add('btn-danger');
					}
					
					appBtn.onclick = function() {
						if(loggedin()){
							if(status == 0){
								$.ajax({
									url : '/partyApplyOk',
									type: 'post',
									data: {
										boardSeq : bseq,
										memSeq : useq,
										status : status
									},
									success: function(result){
										status = 1;
										appIcon.className = "bi bi-patch-check-fill";
									}
								});
							}else if(status == -1 || status == 1){
								let tmp = 0;
								if(status > 0){
									tmp = -1;
								}else{
									tmp = 1;
								}
								$.ajax({
									url : '/partyToggleOk',
									type: 'post',
									data: {
										boardSeq : bseq,
										memSeq : useq,
										status : tmp
									},
									success: function(result){
										status = tmp;
										if(status == -1){
											appText.innerText = '참여신청';
											appIcon.className = "bi bi-patch-check";
										}else{
											appText.innerText = '신청완료';
											appIcon.className = "bi bi-patch-check-fill";
										}
									}
								});
							}
						}
					}
				}else{
					document.getElementById('manBtn').onclick = function(){
						let left = Math.ceil((window.screen.width - 500) / 2)
						let top = Math.ceil((window.screen.height - 555) / 2)
						window.open('', 'applyManage', "width=500, height=555, left="+left+", top="+top);
						document.getElementById('aform').submit();
					}
				}
				
				const tooltips = Array.from(document.querySelectorAll('[data-bs-toggle="tooltip"]'), tip => new bootstrap.Tooltip(tip));
			});

			// 글 삭제
			function partyBoardDelete(seq){
				Swal.fire({
					title: '글을 삭제하시겠습니까?',
					showDenyButton: true,
					confirmButtonText: '네',
					denyButtonText: `아니오`,
				}).then((result) => {
					if (result.isConfirmed) {
						$.ajax({
							url:'partyBoardDeleteOk',
							type:'post',
				  			data: {
				  				seq: seq
				  			},
				  			success: function(data) {
					  			if(data == 0) {
						  			Swal.fire({
							  			icon: 'success',
							  			title: '삭제 완료',
							  			confirmButtonText: '확인',
							  			timer: 1500,
							  			timerProgressBar : true,
							  			willClose: () => {
							  				location.href='partyBoardList?cpage=<%=cpage%>';
						  				}
					  				});
					  			} else {
						  			Swal.fire({
							  			icon: 'error',
							  			title: '삭제 실패',
							  			confirmButtonText: '확인',
							  			timer: 1500,
							  			timerProgressBar : true
						  			});
					  			}
					  		}
						});
					}
				})
			}
			
			// 댓글 추천함수
			function recommendComment(wSeq, mSeq, cSeq){
				$.ajax({
					url: '/commentRec',
					type: 'POST',
					data:{
						writerSeq: wSeq,
						memSeq: mSeq,
						cmtSeq: cSeq,
						boardSeq: <%=boardSeq %>
					},
					success: function(result){
						const res = parseInt(result.substring(0, 1));
						const updatedComments = result.substring(1);

						if(res == 0){
							alert('먼저 로그인 해야합니다');
						}else if(res == 1){
							$('#comments').html(updatedComments);
						}else if(res == 2){
							$('#comments').html(updatedComments);
						}
					},
				});
			}
			
			// 댓글 삭제함수
			function deleteComment(cSeq){
				$.ajax({
					url: "/commentDelete",
					type: "POST", 
					data: {
						boardSeq: <%=boardSeq %>,
						commentSeq: cSeq,
						userSeq: <%=userSeq %>
					},
					success: function(res){
						$('#comments').html(res);
						
						let numberOfComments = res.split("<span class='dropdown'").length - 1;
						$('#viewCmtCnt').html(numberOfComments);
					}
				});
			}
			
			// 댓글 수정함수
			function modifyComment(cSeq){
				const cmtId = 'cmtContent' + cSeq;
				let curContent = $('#' + cmtId).html();
				let options = 'cmtOptions' + cSeq;
				
				$('#' + options).html('<button class="btn float-end" onclick="modifyCommentOk(' + cSeq + ')"><i class="far fa-check-circle"></i></button>');
				$('#' + cmtId).html('<textArea id="modifiedCmt' + cSeq + '" class="form-control" rows="3" style="resize: none;">' + curContent + '</textArea>');
			}
			
			// 댓글 수정완료함수
			function modifyCommentOk(cmtSeq){
				const cmtId = 'modifiedCmt' + cmtSeq;
				const modifiedContent = $('#' + cmtId).val();
				
				if(modifiedContent.trim() == ''){
					Swal.fire({
			  			icon: 'error',
			  			title: '내용을 입력하세요',
			  			confirmButtonText: '확인',
			  			timer: 1500,
			  			timerProgressBar : true
		  			});
					
					return false;
				}
				
				$.ajax({
					url: '/modifyComment',
					type: 'POST',
					data: {
						cSeq: cmtSeq,
						userSeq: <%=userSeq %>,
						boardSeq: <%=boardSeq %>,
						content: modifiedContent
					},
					success: function(result){
						$('#comments').html(result);
					}
				});
			}
			
			// 신고
			function report(seq, type){
				if(<%=userSeq%> == null){
					alert('먼저 로그인 해야합니다');
				}else{
					let url = '/report?targetType=' + type + '&seq=' + seq;
					const pageName = 'DUKR - report';
					// 팝업 위치설정
					const screenWidth = window.screen.width;
					const screenHeight = window.screen.height;
					const popupLeft = (screenWidth / 2) - 300;
					const popupTop = (screenHeight / 2) - 400;
					const spec = 'width=600, height=800, left=' + popupLeft + ', top=' + popupTop;
					
					let popup = window.open(url, pageName, spec);
					
					if(!popup) {
						alert('팝업이 차단되었습니다. 팝업 차단을 해제해주세요');
					}
				} 
			}
			
			
		</script>
	<style>
		.bottombody{
			max-width: 992px;
		}
		
		.subject_info{
			display: flex;
		}
		.subject_info{
			color: #888888;
		}
		.subject_info.address{
			cursor: pointer;
		}
		.main_info{
			margin-right: auto;
		}
		.party_info{
			display: inline-block;
		}
		.slash {
			font-size: 15px;
		}
		
		.dropdown {
			display: inline-block;
		} 
		
		.disinherit {
			color: black;
		}
		
		img {
			max-width: 100%;
		}
		
		.image{
			display: flex;
			justify-content: center;
		}
		.image.image-style-side{
			display: flex;
			justify-content: flex-end;
		}
		
		#map{
			border-radius: 0.5em;
		}
		.screen_out {display:block;overflow:hidden;position:absolute;left:-9999px;width:1px;height:1px;font-size:0;line-height:0;text-indent:-9999px;}
    	.wrap_button {position:absolute;right:15px;top:12px;z-index:2}
		.btn_comm {float:left;display:block;width:70px;height:27px;background:url(/assets/img/kakao/sample_button_control.png) no-repeat;}
		.btn_linkMap {background-position:0 0;}
		.btn_resetMap {background-position:-69px 0;}
		
		@media (max-width: 575px){
			.subject_info{
				font-size: 14px;
			}
		}
		
		@media (min-width: 576px){
			.subject_info{
				font-size: 16px;
			}
		}
	</style>
	
	</head>
	<body>
		<%@ include file="/WEB-INF/views/include/top_bar_header.jspf"%>
		<header class="py-5 bg-secondary">
			<div class="container px-4 px-lg-5 my-5">
				<div class="text-center text-white">
					<h1 class="title">모임게시판</h1>
					<p class="lead fw-normal text-white-50 mb-0">Party Board</p>
				</div>
			</div>
		</header>
		<main>
			<div class="container-fluid bottombody">
				<hr class="my-4">

				<div class="subject">
					<b><%=subject%></b>
					<div class="subject_info mt-2">
						<div class="main_info">
							<div class="dropdown">
								<a href="#" role="button" id="dropdownMenuLink" data-bs-toggle="dropdown"> <b><%=writer%></b>
								</a>
								<ul class="dropdown-menu" aria-labelledby="dropdownMenuLink">
									<li><a class="dropdown-item" href="/partyBoardList?select=3&search=<%=writer%>">게시글 보기</a></li>
									<li><a class="dropdown-item" href="/partyBoardList?">댓글 보기</a></li>
								</ul>
							</div>
							<span class="slash">|</span>
							<%=wdate%>
						</div>
						<div class="extra_info">
							<i class="fas fa-eye"></i>&nbsp;<%=hit%>&nbsp;&nbsp;
							<i class="fas fa-comment"></i>
							<span id='viewCmtCnt'><%=cmtCnt%></span>&nbsp;&nbsp; 
							<i class="fas fa-thumbs-up"></i>
							<span id='viewRecCnt'><%=recCnt%></span>
						</div>
					</div>
				</div>

				<hr class="mt-4 mb-2">
					<span class="badge bg-secondary">장소</span>
					<div class="party_info">
						<span class="subject_info address" id="loadmap" data-bs-toggle="tooltip" data-bs-placement="bottom" title="지도를 출력합니다"><%= partyAddress %></span>
					</div>
					<br>
					<span class="badge bg-secondary">일정</span>
					<div class="party_info">
						<span class="subject_info"><%= date2 %></span>
					</div>
					<div id="map" class="border border-5" style="height: 400px; display: none;">
						<div class="wrap_button">
							<a href="javascript:void(0);" class="btn_comm btn_linkMap" id="linkMap"><span class="screen_out">지도 크게보기</span></a>
							<a href="javascript:void(0);" class="btn_comm btn_resetMap" id="resetMap"><span class="screen_out">지도 초기화</span></a>
						</div>
					</div>
				<hr class="mb-4 mt-2">

				<div class="content">
					<%=content%>
				</div>
				
				<div class="mt-5 pt-5 d-flex justify-content-center">
					<button id="recBtn" class="btn <%=recBtnColor %>">
						<i class="fas fa-thumbs-up"></i> 추천
					</button>
					<%= strApply %><%= manBtn %><%= sbForm %>
				</div>
				<div class="d-flex">
					<button class="btn btn-dark" style="margin-right: auto;" onclick="location.href='partyBoardList?cpage='">목록</button>
					
					<div class="d-flex">
						<%= reportBtn %>
						<%= delmodBtn %>
					</div>
				</div>
				<hr class="my-2">

				<b style="font-size: 20px;">댓글</b>

				<!-- 댓글영역 -->
				<div class="mt-2 mb-3" id="cmtArea">
					<div id="comments">
						<%=comments%>
					</div>
					
					<textarea id="cContent" name="cContent" class="form-control" rows="3" style="resize: none;"></textarea>
					<div class="d-flex" style="margin-top: 10px;">
						<button id="cmtWbtn" class="btn btn-dark" style="margin-left: auto;">댓글쓰기</button>
					</div>
				</div>
			</div>
		</main>
		<footer></footer>
	</body>
</html>