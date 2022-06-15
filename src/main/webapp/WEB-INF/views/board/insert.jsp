<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="my" tagdir="/WEB-INF/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.1.1/css/all.min.css" integrity="sha512-KfkfwYDsLkIlwQp6LFnl8zNdLGxu9YAA1QvwINks4PhcElQSvqcyVLLD9aMhXd13uQjoXtEKNosOWaZqXgel0g==" crossorigin="anonymous" referrerpolicy="no-referrer" />
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.1.3/css/bootstrap.min.css" integrity="sha512-GQGU0fMMi238uA+a/bdWJfpUGKUkBdgfFdgBm72SUQ6BeyWjoY/ton0tEjH+OSH9iP4Dfh+7HM0I9f5eR0L/4w==" crossorigin="anonymous" referrerpolicy="no-referrer" />
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js" referrerpolicy="no-referrer"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-ka7Sk0Gln4gmtz2MlQnikT1wXgYsOg+OMhuP+IlRH9sENBO0LRn5q+8nbTov4+1p" crossorigin="anonymous"></script>
<title>Insert title here</title>


<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.20/summernote-bs5.min.css" integrity="sha512-ngQ4IGzHQ3s/Hh8kMyG4FC74wzitukRMIcTOoKT3EyzFZCILOPF0twiXOQn75eDINUfKBYmzYn2AA8DkAk8veQ==" crossorigin="anonymous" referrerpolicy="no-referrer" />
<script src="https://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.20/summernote-bs5.min.js" integrity="sha512-6F1RVfnxCprKJmfulcxxym1Dar5FsT/V2jiEUvABiaEiFWoQ8yHvqRM/Slf0qJKiwin6IDQucjXuolCfCKnaJQ==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>

</head>
<body>
	<my:navBar current="insert"></my:navBar>
	<!-- .container>.row>.col>h1{글 작성} -->
	<div class="container">
		<div class="row">
			<div class="col">
				<h1>글 작성</h1>
				
				<form action="${appRoot }/board/insert" method="post" enctype="multipart/form-data">
				<!-- 파일 업로드 구현할 때 넣어줘야함 enctype="multipart/form-data"  -->
					<div>
						<label class="form-label" for="input1">제목</label>
						<input class="form-control" type="text" name="title" required id="input1" />
					</div>
					
					<div>
						<label class="form-label" for="textarea1">본문</label>
						<textarea class="form-control" name="body" id="summernote" cols="30" rows="10"></textarea>
					</div>
					<div>					
						파일
						
						<input multiple="multiple" type="file" name="file" accept="image/*"/>
					</div>
					
					<!-- <button id="addFile"  type="button" class="btn btn-default">파일 폼 추가</button> -->
					
					<button type="submit" class="btn btn-primary">작성</button>
				</form>
			</div>
		</div>
	</div>
</body>

<script src="/static/vendor/summernote/dist/summernote.min.js"></script>
<script>
	$(document).ready(function() {
		
		$('#summernote').summernote({
			height : 300,
			onImageUpload : function(files, editor, welEditable) {
				console.log(files);
				console.log( files[0] );
				data = new FormData();
				data.append("file", files[0]);
				var $note = $(this);
				$.ajax({
					data : data,
					type : "POST",
					url : '/board/imageupload',
					cache : false,
					contentType : false,
					processData : false,
					success : function(url) {
						alert(url);
						$note.summernote('insertImage', url);
					}
				});
			}
		});
		
	/* 	$('#addFile').click(function(){
			var fileIndex = $('.fileDiv').length;
			$('#fileTable').append("<input type=\"file\" name=\"files["+fileIndex+"] class=\"fileDiv\">");
		});
 */
	});
</script>


</html>










