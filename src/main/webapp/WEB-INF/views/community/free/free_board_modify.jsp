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
	BoardTO to = (BoardTO)request.getAttribute("to");

	String boardSeq = to.getSeq();
	
	String subject = to.getSubject();
	String writer = to.getWriter();
	String content = to.getContent();
	String tags = to.getTag();
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
				document.getElementById( 'mbtn' ).onclick = function() {
					const subject = document.getElementById('subject');

					switch(0){
						case subject.value.trim().length:
							alert('제목을 입력하세요');
							break;						
						
						default:							
							$.ajax({
						  		url:'/freeBoardModifyOk',
						  		type:'post',
						  		data: {
						  			subject: document.getElementById('subject').value.trim(),
						  			content: editor.getData(),
						  			boardSeq: <%=boardSeq %>,
						  			tags: document.getElementById('tags').value.trim(),
						  		},
						  		success: function(data) {
						  			if(data == 1) {
							  			Swal.fire({
								  			icon: 'success',
								  			title: '수정 완료',
								  			confirmButtonText: '확인',
								  			willClose: () => {
								  				document.location.href='freeBoardView?cpage=<%=cpage%>&seq=<%=boardSeq%>';
							  				}
						  				})
						  			} else {
							  			Swal.fire({
								  			icon: 'error',
								  			title: '수정 실패',
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
		<header class="mt-5 py-5 bg-secondary">
			<div class="container px-4 px-lg-5 my-5">
				<div class="text-center text-white">
					<h1 class="title">자유게시글 수정</h1>
					<p class="lead fw-normal text-white-50 mb-0">Free Board Modify</p>
				</div>
			</div>
		</header>
		<main>
			
			<div class="container-fluid my-4 bottombody">	
 				<form action="/write/new" method="POST" enctype="multipart/form-data">
 					<div class="row">
						<div class="subject col-sm-8 mb-3">
							<input type="text" name="subject" id="subject" value="<%=subject %>" class="form-control input-sm" placeholder="제목" maxlength="100">
						</div>
						<div class="tags col-sm-4 mb-3">
							<input type="text" name="tags" id="tags" value="<%=tags %>" class="form-control input-sm" placeholder="태그" maxlength="100">
						</div>
 					</div>
					
					<div class="content mb-3">
							<textarea name="content" id="editor" maxlength="10000" style="display: none;"><%=content %></textarea>
							<div class="wordCount mt-2 d-flex justify-content-end">
								내용&nbsp;:&nbsp;
								<span id="count">0</span>
								/10000
							</div>			
					</div>
					
					<div class="btn_area">			
						<button type="button" class="btn btn-dark" onclick="location.href='freeBoardList?cpage=<%= cpage%>'" >목록</button>
						<button type="button" class="btn btn-dark" onclick="location.href='freeBoardView?cpage=<%= cpage%>&seq=<%=boardSeq %>'" >보기</button>
						
						<input type="button" id="mbtn" class="btn btn-dark float-end" value="수정"/>
					</div>
				</form>
			</div>

		</main>
		<footer>
		</footer>
	</body>
</html>