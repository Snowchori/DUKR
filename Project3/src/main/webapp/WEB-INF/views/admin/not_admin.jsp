<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/include/head_setting.jspf" %>
<body>
	<script type='text/javascript'>
		Swal.fire({
			icon: 'error',
			title: '권한이 없습니다.',
			confirmButtonText: "확인",
			willClose: () => {
				history.back();
			}
		});
	</script>
</body>	