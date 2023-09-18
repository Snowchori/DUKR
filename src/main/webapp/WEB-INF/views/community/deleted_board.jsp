<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/head_setting.jspf" %>
<body>
	<script type='text/javascript'>
		Swal.fire({
			icon: 'error',
			title: '삭제된 게시글입니다.',
			confirmButtonText: "확인",
			timer: 1500,
  			timerProgressBar : true,
			willClose: () => {
				history.back();
			}
		});
	</script>
</body>	

