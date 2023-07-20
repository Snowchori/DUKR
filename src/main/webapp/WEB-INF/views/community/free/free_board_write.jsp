<%@page import="ch.qos.logback.core.recovery.ResilientSyslogOutputStream"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%
	// 현재 페이지 번호
	int cpage = 1;
	if(request.getParameter("cpage") != null && !request.getParameter("cpage").equals("")){
		cpage = Integer.parseInt(request.getParameter("cpage"));
	}
%>

<%
	MemberTO user = (MemberTO)session.getAttribute("logged_in_user");
	String memSeq = user.getSeq();
	String writer = "'" + user.getNickname() + "'";
	//System.out.println(memSeq + writer);
%>
    
<%@ include file="/WEB-INF/views/include/top_bar_declare.jspf" %>
<!doctype html>
<html>
	<head>
		<%@ include file="/WEB-INF/views/include/head_setting.jspf" %>
		<!-- Template Main CSS File -->
		<link href="assets/css/style.css" rel="stylesheet">
		
		<!-- CKEditor5 -->
		<script src="https://cdn.ckeditor.com/ckeditor5/34.0.0/classic/ckeditor.js"></script>
		
		<style>
			.bottombody{
				max-width: 992px;
			}
			.ck-editor__editable { height: 400px; }
	  		.ck-content { font-size: 12px; }
			}
		</style>
		
		<!-- 자바 스크립트 영역 -->
		<script type="text/javascript" >
			window.onload = function() {
	
				/* CKEditor5 설정 */
				ClassicEditor
				.create(document.querySelector('#editor'),{
						language: "ko",
						ckfinder: {
							uploadUrl : '/upload/freeboard'
						}
					})
					.then(editor => {
						console.log('Editor was initialized');
						window.editor = editor;
					})
					.catch(error => {
						console.error(error);
					});
				
				/* 데이터 무결성 검사 */
				document.getElementById( 'wbtn' ).onclick = function() {
					const subject = document.getElementById('subject');

					switch(0){
						case subject.value.trim().length:
							alert('제목을 입력하세요');
							break;						
						
						default:							
							$.ajax({
						  		url:'/freeBoardWriteOk',
						  		type:'post',
						  		data: {
						  			subject: document.getElementById('subject').value.trim(),
						  			content: editor.getData(),
						  			memSeq: <%=memSeq %>,
						  			writer: <%=writer %>,
									boardType: 1,
						  			tags: document.getElementById('tags').value.trim(),
						  		},
						  		success: function(data) {
						  			if(data == 1) {
							  			Swal.fire({
								  			icon: 'success',
								  			title: '글쓰기 완료',
								  			confirmButtonText: '확인',
								  			willClose: () => {
								  				document.location.href='freeBoardList';
							  				}
						  				})
						  			} else {
							  			Swal.fire({
								  			icon: 'error',
								  			title: '글쓰기 실패',
								  			confirmButtonText: '확인'
							  			})
						  			}
							  	}
							});
						} 
					}	
				};
		</script>
	
	</head>
	<body>
		<%@ include file="/WEB-INF/views/include/top_bar_header.jspf" %>
		<header class="py-5 bg-secondary">
			<div class="container px-4 px-lg-5 my-5">
				<div class="text-center text-white">
					<h1 class="title">자유게시판 글쓰기</h1>
					<p class="lead fw-normal text-white-50 mb-0">Free Board Write</p>
				</div>
			</div>
		</header>
		<main>
		
			<div class="container-fluid my-4 bottombody">	
 				<form action="/write/new" method="POST" enctype="multipart/form-data">
 					<div class="row">
						<div class="subject col-sm-8 mb-3">
							<input type="text" name="subject" id="subject" value="" class="form-control input-sm" placeholder="제목" maxlength="100">
						</div>
						<div class="tags col-sm-4 mb-3">
							<input type="text" name="tags" id="tags" value="" class="form-control input-sm" placeholder="태그" maxlength="100">
						</div>
 					</div>
					
					<div class="content mb-3">
							<textarea name="content" id="editor" maxlength="10000" style="display: none;"></textarea>
							<div class="wordCount mt-2 d-flex justify-content-end">
								내용&nbsp;:&nbsp;
								<span id="count">0</span>
								/10000
							</div>			
					</div>
					
					<div class="btn_area">			
						<button type="button" class="btn btn-dark" onclick="location.href='freeBoardList?cpage=<%= cpage%>'" >목록</button>
						<input type="button" id="wbtn" class="btn btn-dark float-end" value="글쓰기"/>
					</div>
				</form>
			</div>
			
		</main>
		<footer>
		</footer>
	</body>
</html>