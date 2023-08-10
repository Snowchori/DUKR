<%@page import="com.example.model.note.NoteTO"%>
<%@page import="com.example.model.note.NoteListTO"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/top_bar_declare.jspf" %>
<%
	NoteListTO listTO = (NoteListTO)request.getAttribute("myNoteList");

	int cpage = listTO.getCpage();
	int totalRecode = listTO.getTotalRecord();
	int recordPerPage = listTO.getRecordPerPage();
	int totalRecord = listTO.getTotalRecord();
	
	int totalPage = listTO.getTotalPage();
	
	int blockPerPage = listTO.getBlockPerPage();
	int startBlock = listTO.getStartBlock();
	int endBlock = listTO.getEndBlock();
	
	//받은 쪽지 html
	StringBuilder getNoteHTML = new StringBuilder();
	for(NoteTO noteTO : listTO.getNoteList()) {
		getNoteHTML.append("<div class='row mt-3'>");
		getNoteHTML.append("<div class='col-md-12'>");
		getNoteHTML.append("<div class='form-check'>");
		getNoteHTML.append("<input class='form-check-input' type='checkbox' id='"+noteTO.getSeq()+"'>");
		if(noteTO.getStatus() == 0) {
			getNoteHTML.append("<label class='form-check-label' onclick=\"location.href='/mailGetView?seq="+noteTO.getSeq()+"'\"><i class='bi bi-envelope'></i> 발신자 : "+noteTO.getSenderSeq()+" | 제목 : "+noteTO.getSubject()+" </label>");
		} else {
			getNoteHTML.append("<label class='form-check-label' onclick=\"location.href='/mailGetView?seq="+noteTO.getSeq()+"'\"><i class=\"bi bi-envelope-open\"></i> 발신자 : "+noteTO.getSenderSeq()+" | 제목 : "+noteTO.getSubject()+" </label>");
		}
		getNoteHTML.append("</div><hr class='my-1'></div></div>");
	}
	
	//페이징
		StringBuilder pageHtml = new StringBuilder();
		
		if (startBlock != 1) {
			pageHtml.append("<li class='page-item'>");
			pageHtml.append("<a href='mail?cpage=");
			pageHtml.append(startBlock - blockPerPage);
			pageHtml.append("&recordPerPage=" + recordPerPage + "' ");
			pageHtml.append("class='page-link' aria-label='Previous'>");
			pageHtml.append("<span aria-hidden='true'>«</span>");
			pageHtml.append("</a>");
			pageHtml.append("</li>");
		}
		
		for(int i=startBlock; i<=endBlock; i++) {
			if(i == cpage) {
				pageHtml.append("<li class='page-item active'><a class='page-link'>" + i + "</a></li>");
			} else {
				pageHtml.append("<li class='page-item'><a class='page-link' href='");
				pageHtml.append("mail?cpage=" + i);
				pageHtml.append("&recordPerPage=" + recordPerPage + "' ");
				pageHtml.append(">" + i + "</a></li>");
			}
		}
		
		if(endBlock != totalPage) {
			pageHtml.append("<li class='page-item'>");
			pageHtml.append("<a href='mail?cpage=");
			pageHtml.append(startBlock + blockPerPage);
			pageHtml.append("&recordPerPage=" + recordPerPage + "' ");
			pageHtml.append("class='page-link' aria-label='Next'>");
			pageHtml.append("<span aria-hidden='true'>»</span>");
			pageHtml.append("</a>");
			pageHtml.append("</li>");
		}
	
%>
<!doctype html>
<html>
	<head>
		<%@ include file="/WEB-INF/views/include/head_setting.jspf" %>
		<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.4/jquery.min.js"></script>
		<!-- 자바 스크립트 영역 -->
		<script type="text/javascript">
			function deleteMail() {
		        var selectedIds = [];

		        var checkboxes = document.querySelectorAll(".form-check-input");

		        checkboxes.forEach(function (checkbox) {
		            if (checkbox.checked) {
		                selectedIds.push(checkbox.id);
		            }
		        });
		        $.ajax({
					url: "mailDeleteOK",
	                   type: "post",
	                   contentType: "application/json",
	                   data: JSON.stringify(selectedIds),
					success : function(data) {
						//0 성공 / 1 오류 및 실패
						if(data == 0) {
							Swal.fire({
	                            title : '쪽지 삭제 성공',
	                            text  : '쪽지를 삭제하였습니다',
	                            icon  : 'success',
	                            showCancelButton : false,
	                            confirmButtonText : '확인',
	                            timer : 1500,
	                            timerProgressBar : true,
	                            willClose : () => {
	                            window.location.href = '';
	                            }
	                        });
						} else {
							Swal.fire({
	                            title : '쪽지 삭제 실패',
	                            text  : '쪽지 삭제에 실패하였습니다',
	                            icon  : 'error',
	                            showCancelButton : false,
	                            confirmButtonText : '확인',
	                            timer : 1500,
	                            timerProgressBar : true,
	                            willClose : () => {
	                            window.location.href = '';
	                            }
	                        });
						} 
					}
				});
			}
		</script>
		<link href="assets/css/style.css" rel="stylesheet">
		<style type="text/css">
			.selection > div > div{
				padding: 5px 0 5px 0;
				border: 1px #cacaca solid;
				box-sizing: border-box;
				cursor: pointer;
			}
			.selection > div > div:hover{
				background-color: #f2f2f2;
			}
		</style>
	</head>
	<body>
		<%@ include file="/WEB-INF/views/include/top_bar_header.jspf" %>
		<header class="mt-5 py-5 bg-secondary">
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
			</div>
			<br/>
			<!-- 버튼 디자인 -->
	  		<!-- 마이페이지 정보페이지 디자인 -->
			<!-- 상단버튼 -->
			<div class="container my-4">
    			<div class="d-flex justify-content-between">
        			<div>
            			<button class="btn btn-dark" onclick="location.href='/mail'">받은 쪽지함</button>
            			<button class="btn btn-dark" onclick="location.href='/mailSend'">보낸 쪽지함</button>
        			</div>
        			<div>
            			<button class="btn btn-danger" onclick="deleteMail()">쪽지 삭제</button>
            			<button class="btn btn-dark" onclick="location.href='/mailWrite'">쪽지 보내기</button>
        			</div>
    			</div>
			</div>
			<!-- 상단버튼 -->
			<!-- 받은 쪽지 -->
			<div class="container mt-5">
				<%=getNoteHTML %>			
			</div>
			<!-- 받은 쪽지 -->
		</main>
		<footer class="container-fluid d-flex justify-content-center">
			<div class="container demo mx-5 p-2">
				<nav class="pagination-outer" aria-label="Page navigation">
					<ul class="pagination">
						<%= pageHtml %>
					</ul>
				</nav>
			</div>
		</footer>
	</body>
</html>