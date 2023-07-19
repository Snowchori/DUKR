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
		
		<style>
		main {
		    position: relative;
		    display: flex;
		    align-items: flex-start;
		    justify-content: center;
		    width: 100%;
		}
		
		aside {
			display: flex;
		    flex-direction: column;
		    align-items: center;
		    justify-content: center;
		    width: 200px;
		    min-width: 200px;
		    margin: 10px;
		
		    position: sticky;
		    top: 10px;
		}
		
		.article {
		    display: flex;
		    flex-direction: column;
		    align-items: center;
		    justify-content: flex-start;
		}
		
		.article .subject {
		    display: flex;
		    width: 100%;
		    margin: 25px 0px;
		}
		
		.article .content .textareaContainer {
		    width: 100%;
		}
		
		.article .content .textareaContainer .wordCount {
		    display: flex;
		    align-items: center;
		    justify-content: end;
		    margin: 10px 0px;
		}
		
		.ck-editor__editable { height: 400px; }
  		.ck-content { font-size: 12px; }
  		
  		.article .tags {
		    display: flex;
		    width: 100%;
		    margin: 10px 0px;
		}
  		
  		.align_left { float: left; }
		.align_right { float: right; }
		
		</style>
		
		
		
		<!-- CKEditor5 -->
		<script src="https://cdn.ckeditor.com/ckeditor5/34.0.0/classic/ckeditor.js"></script>
		
		<!-- 자바 스크립트 영역 -->
		<script type="text/javascript" >
			window.onload = function() {
	
				/* CKEditor5 설정 */
				ClassicEditor
					.create(document.querySelector('#editor'),{
						language: "ko",
						ckfinder: {
							uploadUrl : '/upload/announce'
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
						  		url:'/announceBoardWriteOk',
						  		type:'post',
						  		data: {
						  			subject: document.getElementById('subject').value.trim(),
						  			content: editor.getData(),
						  			memSeq: <%=memSeq %>,
						  			writer: <%=writer %>,
									boardType: 0,
						  			tags: document.getElementById('tags').value.trim(),
						  		},
						  		success: function(data) {
						  			if(data == 1) {
							  			Swal.fire({
								  			icon: 'success',
								  			title: '글쓰기 완료',
								  			confirmButtonText: '확인',
								  			willClose: () => {
								  				document.location.href='announceBoardList';
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
					<h1 class="title">공지사항 글쓰기</h1>
					<p class="lead fw-normal text-white-50 mb-0">Announcement Write</p>
				</div>
			</div>
		</header>
		<main style="height: auto !important;">
			
			<aside class="left">
				<section id="adsense" class="leftWing">
				
				</section>
			</aside>
				
			<div class="container-fluid article" data-article-id="">
<!-- 			<form action="/write/new" method="POST" enctype="multipart/form-data" onsubmit="onSubmit(this); return false;">		
 -->			<div class="container">	
	 				<form action="/write/new" method="POST" enctype="multipart/form-data">
						<div class="subject">
							<input type="text" name="subject" id="subject" value="" class="form-control input-sm" placeholder="제목" maxlength="100">
						</div>
						
						<div class="content">
							<div class="textareaContainer">
								<textarea name="content" id="editor" maxlength="10000"></textarea>
								
								<div class="wordCount">
									내용&nbsp;:&nbsp;
									<span id="count">0</span>
									/10000
								</div>						
							</div>
						</div>
						
						<div class="tags">
							<input type="text" name="tags" id="tags" value="" class="form-control input-sm" placeholder="태그" maxlength="100">
						</div>
						
						<div class="btn_area">
							<div class="align_left">			
								<button type="button" class="btn btn-dark" onclick="location.href='announceBoardList?cpage=<%= cpage%>'" >목록</button>
							</div>
							<div class="align_right">			
								<input type="button" id="wbtn" class="btn btn-dark" value="글쓰기"/>			
							</div>								
						</div>
						
					</form>
				</div>
				
			</div>
			
			<aside class="right">
				<section id="adsense" class="rightWing">
			
				</section>
			</aside>
		</main>
		<footer>
		</footer>
	</body>
</html>