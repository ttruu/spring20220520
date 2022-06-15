<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="my" tagdir="/WEB-INF/tags" %>
<%@ taglib prefix="sec" uri="http://www.springframework.org/security/tags" %>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.1.1/css/all.min.css"
	integrity="sha512-KfkfwYDsLkIlwQp6LFnl8zNdLGxu9YAA1QvwINks4PhcElQSvqcyVLLD9aMhXd13uQjoXtEKNosOWaZqXgel0g=="
	crossorigin="anonymous" referrerpolicy="no-referrer" />
<link rel="stylesheet"
	href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.1.3/css/bootstrap.min.css"
	integrity="sha512-GQGU0fMMi238uA+a/bdWJfpUGKUkBdgfFdgBm72SUQ6BeyWjoY/ton0tEjH+OSH9iP4Dfh+7HM0I9f5eR0L/4w=="
	crossorigin="anonymous" referrerpolicy="no-referrer" />
<script
	src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"
	referrerpolicy="no-referrer"></script>
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js" integrity="sha384-ka7Sk0Gln4gmtz2MlQnikT1wXgYsOg+OMhuP+IlRH9sENBO0LRn5q+8nbTov4+1p" crossorigin="anonymous"></script>

<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.20/summernote-bs5.min.css" integrity="sha512-ngQ4IGzHQ3s/Hh8kMyG4FC74wzitukRMIcTOoKT3EyzFZCILOPF0twiXOQn75eDINUfKBYmzYn2AA8DkAk8veQ==" crossorigin="anonymous" referrerpolicy="no-referrer" />
<script src="https://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.20/summernote-bs5.min.js" integrity="sha512-6F1RVfnxCprKJmfulcxxym1Dar5FsT/V2jiEUvABiaEiFWoQ8yHvqRM/Slf0qJKiwin6IDQucjXuolCfCKnaJQ==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>


<script>
	$(document).ready(function() {
		$("#edit-button1").click(function() {
			$("#input1").removeAttr("readonly");
			$("#summernote").removeAttr("readonly");
			$("#modify-submit1").removeClass("d-none");
			$("#delete-submit1").removeClass("d-none");
			$("#addFileInputContainer1").removeClass("d-none");
			$(".removeFileCheckbox").removeClass("d-none");
		});
		
		$("#delete-submit1").click(function(e) {
			e.preventDefault();
			
			if (confirm("삭제하시겠습니까?")) {
				let form1 = $("#form1");
				let actionAttr = "${appRoot}/board/remove";
				form1.attr("action", actionAttr);
				
				form1.submit();
			}
			
		});
		
		
		// 페이지 로딩 후 reply list 가져오는 ajax 요청
		const listReply = function() {

				const data = {boardId : ${board.id}};
			
			$.ajax({
				url : "${appRoot}/reply/list",
				type : "get",
				data : data,
				success : function(list) {
					//console.log("댓글 가져오기 성공");
					console.log(list);
					
					const replyListElement = $("#replyList1");
					replyListElement.empty();
					
					// 댓글 갯수 표시
					$("#numOfReply").text(list.length);
					
					for(let i = 0; i < list.length; i++) {
						const replyElement = $("<li class='list-group-item' />");
						replyElement.html(`
						
								<div id="replyDisplayContainer\${list[i].id }">
									<div class="fw-bold">
										<i class="fa-solid fa-comment"></i> 
											\${list[i].prettyInserted}
											
											<span id="modifyButtonWrapper\${list[i].id }">
											</span>
							
											
									</div>
									<span class="badge bg-light text-dark">
									<i class="fa-solid fa-user"></i>
									\${list[i].writerNickName}
									</span>
									<span id="replyContent\${list[i].id}"></span>
							
									
								</div>
											
								
								<div id="replyEditFormContainer\${list[i].id }" 
										style="display: none;">
									<form action="${appRoot }/reply/modify" method="post">
										<div class="input-group">
											<input type="hidden" name="boardId" value="${board.id }" />
											<input type="hidden" name="id" value="\${list[i].id }" />
											<input class="form-control" value="\${list[i].content }" 
													type="text" name="content" required /> 
											<button data-reply-id="\${list[i].id}" 
													class="reply-modify-submit btn btn-outline-secondary">
												<i class="fa-solid fa-comment-dots"></i>
											</button>
										</div>
									</form>
								</div>
								
										`);
						replyListElement.append(replyElement);
						$("#replyContent" + list[i].id).text(list[i].content );
						
						// own이 true일때만 수정, 삭제 버튼 보이기
						if(list[i].own) {
							$("#modifyButtonWrapper" + list[i].id).html(`
								<span class="reply-edit-toggle-button badge bg-info text-dark" 
							 	id="replyEditToggleButton\${list[i].id }" 
							 	data-reply-id="\${list[i].id }" >
						 		<i class="fa-solid fa-pen-to-square"></i>
								</span>
							 	<span class="reply-delete-button badge bg-danger" 
							 	data-reply-id="\${list[i].id }">
						 		<i class="fa-solid fa-trash-can"></i>
							 	</span>	
							 `);
						} 
					
					} // end of for
					
					$(".reply-modify-submit").click(function(e){
						
						e.preventDefault();
						
						const id = $(this).attr("data-reply-id");
						const formElem = $("#replyEditFormContainer" + id).find("form");
						// const data = formElem.serialize(); // put방식은 controller에서 못받음
						const data = {
								boardId : formElem.find("[name=boardId]").val(),
								id : formElem.find("[name=id]").val(),
								content : formElem.find("[name=content]").val()
						};
						
						$.ajax({
							url : "${appRoot}/reply/modify",
							type : "put",
							data : JSON.stringify(data),
							contentType : "application/json",
							success : function(data) {
								console.log("수정 성공");
								
								// 메세지 보여주기
								$("#replyMessage1").show().text(data).fadeOut(3000);
								
								// 댓글 refresh
								listReply();
							}, 
							error : function() {
								$("#replyMessage1").show().text("댓글을 수정할 수 없습니다").fadeOut(3000);
								console.log("수정 실패");
							}, 
							complete : function() {
								console.log("수정 종료");
							}
						});
					});
					
					// reply-edit-toggle 버튼 클릭시 댓글 보여주는 div 숨기고,
					// 수정 form 보여주기
					$(".reply-edit-toggle-button").click(function() {
						console.log("버튼클릭");
						const replyId = $(this).attr("data-reply-id");
						const displayDivId = "#replyDisplayContainer" + replyId;
						const editFormId = "#replyEditFormContainer" + replyId;
						
						console.log(replyId);
						console.log(displayDivId);
						console.log(editFormId);
						
						$(displayDivId).hide();
						$(editFormId).show();
					});
					
					// 댓글 삭제 버튼 클릭 이벤트 메소드 등록
					// reply-delete-button 클릭시
					$(".reply-delete-button").click(function() {
						const replyId = $(this).attr("data-reply-id");
						const message = "댓글을 삭제하시겠습니까?";
						
						if (confirm(message)) {
							//$("#replyDeleteInput1").val(replyId);
							//$("#replyDeleteForm1").submit();
							
							$.ajax({
								url : "${appRoot}/reply/delete/" + replyId,
								type : "delete",
								success : function(data) {
									//console.log(replyId + "댓글 삭제됨");
									// 댓글 list refresh
									listReply();
									// 메시지 출력
									$("#replyMessage1").show().text(data).fadeOut(3000);
								}, 
								error : function() {
									$("#replyMessage1").show().text("댓글을 삭제할 수 없습니다").fadeOut(3000);
									console.log(replyId + "댓글 삭제 중 문제 발생됨");
								}, 
								complete : function() {
									console.log(replyId + "댓글 삭체 요청 끝");
								}
							});
						}
					});
						
				},
				error : function() {
					console.log("댓글 가져오기 실패");
				}
			});
	}
			
		// 댓글 가져오는 함수 실행
		listReply();
		
		// addReplySubmitButton1 버튼 클릭시 ajax 댓글 추가 요청
		$("#addReplySubmitButton1").click(function(e) {
			e.preventDefault();
			
			const data = $("#insertReplyForm1").serialize();
			
			$.ajax({
				url : "${appRoot }/reply/insert",
				type : "post",
				data : data,
				success : function(data) {
					// 새 댓글 등록되었다는 메세지 출력
					$("#replyMessage1").show().text(data).fadeOut(3000);
					
					// text input 초기화
					$("#insertReplyContentInput1").val("");
					
					// 모든 댓글 가져오는 ajax 요청
					// 댓글 가져오는 함수 실행
					listReply();
					
					//console.log(data);
				}, 
				error : function() {
					$("#replyMessage1").show().text("댓글을 작성할 수 없습니다").fadeOut(3000);
					console.log("문제 발생");
				},
				complete : function() {
					console.log("요청 완료");
				}
				
			});
		});
		
	});
</script>

<script>
$(document).ready(function() {
	var toolbar = [
		    // 글꼴 설정
		    ['fontname', ['fontname']],
		    // 글자 크기 설정
		    ['fontsize', ['fontsize']],
		    // 굵기, 기울임꼴, 밑줄,취소 선, 서식지우기
		    ['style', ['bold', 'italic', 'underline','strikethrough', 'clear']],
		    // 글자색
		    ['color', ['forecolor','color']],
		    // 표만들기
		    ['table', ['table']],
		    // 글머리 기호, 번호매기기, 문단정렬
		    ['para', ['ul', 'ol', 'paragraph']],
		    // 줄간격
		    ['height', ['height']],
		    // 그림첨부, 링크만들기, 동영상첨부
		    ['insert',['picture','link','video']],
		    // 코드보기, 확대해서보기, 도움말
		    ['view', ['codeview','fullscreen', 'help']]
		  ];
	var setting = {
            height : 300,
            minHeight : null,
            maxHeight : null,
            focus : true,
            lang : 'ko-KR',
            toolbar : toolbar
         };
        $('#summernote').summernote(setting);
        
        
 });
  
</script>

<title>Insert title here</title>
</head>
<body>
	<my:navBar></my:navBar>
	<!-- .container>.row>.col>h1{글 본문} -->
	<div class="container">
		<div class="row">
			<div class="col">
				<h1>글 본문
					
					<sec:authorize access="isAuthenticated()">
						<sec:authentication property="principal" var="principal"/>
						<!-- 
						로그인한 사람 : ${principal.username}
						작성한 사람 : ${board.memberId} 
						--> 
						<c:if test="${principal.username == board.memberId }">
							<button id="edit-button1" class="btn btn-secondary">
								<i class="fa-solid fa-pen-to-square"></i>
							</button>
						</c:if>
					</sec:authorize>
				</h1>
				
				<c:if test="${not empty message }">
					<div class="alert alert-primary">
						${message }
					</div>
				</c:if>
				
				<form id="form1" action="${appRoot }/board/modify" method="post" enctype="multipart/form-data">
					<input type="hidden" name="id" value="${board.id }"/>
					
					<div>
						<label class="form-label" for="input1">제목</label>
						<input class="form-control" type="text" name="title" required
							id="input1" value="${board.title }" readonly/>
					</div>

					<div>
						<label class="form-label" for="textarea1">본문</label>
						<textarea class="form-control" name="body" id="summernote"
							cols="30" rows="10" readonly>${board.body }</textarea>
					</div>
					
					<c:forEach items="${board.fileName }" var="file">
						<%
						String file = (String) pageContext.getAttribute("file");
						String encodedFileName = java.net.URLEncoder.encode(file, "utf-8");
						pageContext.setAttribute("encodedFileName", encodedFileName);
						%>
						<div class="row">
							<div class="col-1">
							<!-- 삭제 체크박스 -->
								<div class="d-none removeFileCheckbox">
									<i class="fa-solid fa-trash-can"></i>삭제 <br />
									<input type="checkbox" name="removeFileList" value="${file }"/>									
								</div>
							</div>
							<div class="col-11">
								<div>
									<!-- 파일 aws 저장하기 -->
									<img class="img-fluid" src="${imageUrl }/board/${board.id }/${encodedFileName}" alt="" />
								</div>
							</div>
						</div>
					</c:forEach>
					
					<div id="addFileInputContainer1" class="d-none">
						파일추가 :
						<input type="file" accept="image/*" multiple="multiple" name="addFileList" id="" />
					</div>
					
					<div>
						<label for="input3" class="form-label">작성자</label>
						<input class="form-control" type="text" value="${board.writerNickName }" readonly/>
					</div> 

					<div>
						<label for="input2" class="form-label">작성일시</label>
						<input class="form-control" type="datetime-local" value="${board.inserted }" readonly/>
					</div>
					
					<button id="modify-submit1" class="btn btn-primary d-none">수정</button>
					<button id="delete-submit1" class="btn btn-danger d-none">삭제</button>
				</form>
					
			</div>
		</div>
	</div>
	
	
	<%-- 댓글 추가 form --%>
	<!-- .container.mt-3>.row>.col>form -->
	<div class="container mt-3">
		<div class="row">
			<div class="col">
				<form id="insertReplyForm1">
					<div class="input-group">
						<input type="hidden" name="boardId" value="${board.id }" />
						<input id="insertReplyContentInput1" class="form-control" type="text" name="content" required /> 
						<button id="addReplySubmitButton1" class="btn btn-outline-secondary"><i class="fa-solid fa-comment-dots"></i></button>
					</div>
				</form>
			</div>
		</div>
		<div class="row">
			<div class="alert alert-primary" style="display:none;" id="replyMessage1"></div>
		</div>
	</div>
	
	
	<%-- 댓글 목록 --%>
	
	<!-- .container.mt-3>.row>.col -->
	<div class="container mt-3">
		<div class="row">
			<div class="col">
				<h3>댓글 <span id="numOfReply"></span>개</h3>
			
				<ul id="replyList1" class="list-group">
				<!--  
					<c:forEach items="${replyList }" var="reply">
						<li class="list-group-item">
							<div id="replyDisplayContainer${reply.id }">
								<div class="fw-bold">
									<i class="fa-solid fa-comment"></i> 
									${reply.prettyInserted}
								 	<span class="reply-edit-toggle-button badge bg-info text-dark" id="replyEditToggleButton${reply.id }" data-reply-id="${reply.id }" >
								 		<i class="fa-solid fa-pen-to-square"></i>
							 		</span>
								 	<span class="reply-delete-button badge bg-danger" data-reply-id="${reply.id }">
								 		<i class="fa-solid fa-trash-can"></i>
								 	</span>
								</div>
						 		<c:out value="${reply.content }" />
							 	
							 	
							</div>
							
							<div id="replyEditFormContainer${reply.id }" style="display: none;">
								<form action="${appRoot }/reply/modify" method="post">
									<div class="input-group">
										<input type="hidden" name="boardId" value="${board.id }" />
										<input type="hidden" name="id" value="${reply.id }" />
										<input class="form-control" value="${reply.content }" type="text" name="content" required /> 
										<button class="btn btn-outline-secondary"><i class="fa-solid fa-comment-dots"></i></button>
									</div>
								</form>
							</div>
						 	
						 	
						</li>
					</c:forEach>
				-->
				</ul>
			</div>
		</div>
	</div>
	
	<%-- reply 삭제 form --%>
	<div class="d-none">
		<form id="replyDeleteForm1" action="${appRoot }/reply/delete" method="post">
			<input id="replyDeleteInput1" type="text" name="id" />
			<input type="text" name="boardId" value="${board.id }" />
		</form>
	</div>
</body>
</html>








