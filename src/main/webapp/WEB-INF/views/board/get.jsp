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

<script src="/static/vendor/summernote/dist/summernote.min.js"></script>

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
			
			if (confirm("?????????????????????????")) {
				let form1 = $("#form1");
				let actionAttr = "${appRoot}/board/remove";
				form1.attr("action", actionAttr);
				
				form1.submit();
			}
			
		});
		
		
		// ????????? ?????? ??? reply list ???????????? ajax ??????
		const listReply = function() {

				const data = {boardId : ${board.id}};
			
			$.ajax({
				url : "${appRoot}/reply/list",
				type : "get",
				data : data,
				success : function(list) {
					//console.log("?????? ???????????? ??????");
					console.log(list);
					
					const replyListElement = $("#replyList1");
					replyListElement.empty();
					
					// ?????? ?????? ??????
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
						
						// own??? true????????? ??????, ?????? ?????? ?????????
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
						// const data = formElem.serialize(); // put????????? controller?????? ?????????
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
								console.log("?????? ??????");
								
								// ????????? ????????????
								$("#replyMessage1").show().text(data).fadeOut(3000);
								
								// ?????? refresh
								listReply();
							}, 
							error : function() {
								$("#replyMessage1").show().text("????????? ????????? ??? ????????????").fadeOut(3000);
								console.log("?????? ??????");
							}, 
							complete : function() {
								console.log("?????? ??????");
							}
						});
					});
					
					// reply-edit-toggle ?????? ????????? ?????? ???????????? div ?????????,
					// ?????? form ????????????
					$(".reply-edit-toggle-button").click(function() {
						console.log("????????????");
						const replyId = $(this).attr("data-reply-id");
						const displayDivId = "#replyDisplayContainer" + replyId;
						const editFormId = "#replyEditFormContainer" + replyId;
						
						console.log(replyId);
						console.log(displayDivId);
						console.log(editFormId);
						
						$(displayDivId).hide();
						$(editFormId).show();
					});
					
					// ?????? ?????? ?????? ?????? ????????? ????????? ??????
					// reply-delete-button ?????????
					$(".reply-delete-button").click(function() {
						const replyId = $(this).attr("data-reply-id");
						const message = "????????? ?????????????????????????";
						
						if (confirm(message)) {
							//$("#replyDeleteInput1").val(replyId);
							//$("#replyDeleteForm1").submit();
							
							$.ajax({
								url : "${appRoot}/reply/delete/" + replyId,
								type : "delete",
								success : function(data) {
									//console.log(replyId + "?????? ?????????");
									// ?????? list refresh
									listReply();
									// ????????? ??????
									$("#replyMessage1").show().text(data).fadeOut(3000);
								}, 
								error : function() {
									$("#replyMessage1").show().text("????????? ????????? ??? ????????????").fadeOut(3000);
									console.log(replyId + "?????? ?????? ??? ?????? ?????????");
								}, 
								complete : function() {
									console.log(replyId + "?????? ?????? ?????? ???");
								}
							});
						}
					});
						
				},
				error : function() {
					console.log("?????? ???????????? ??????");
				}
			});
	}
			
		// ?????? ???????????? ?????? ??????
		listReply();
		
		// addReplySubmitButton1 ?????? ????????? ajax ?????? ?????? ??????
		$("#addReplySubmitButton1").click(function(e) {
			e.preventDefault();
			
			const data = $("#insertReplyForm1").serialize();
			
			$.ajax({
				url : "${appRoot }/reply/insert",
				type : "post",
				data : data,
				success : function(data) {
					// ??? ?????? ?????????????????? ????????? ??????
					$("#replyMessage1").show().text(data).fadeOut(3000);
					
					// text input ?????????
					$("#insertReplyContentInput1").val("");
					
					// ?????? ?????? ???????????? ajax ??????
					// ?????? ???????????? ?????? ??????
					listReply();
					
					//console.log(data);
				}, 
				error : function() {
					$("#replyMessage1").show().text("????????? ????????? ??? ????????????").fadeOut(3000);
					console.log("?????? ??????");
				},
				complete : function() {
					console.log("?????? ??????");
				}
				
			});
		});
		
	});
</script>


<title>Insert title here</title>
</head>
<body>
	<my:navBar></my:navBar>
	<!-- .container>.row>.col>h1{??? ??????} -->
	<div class="container">
		<div class="row">
			<div class="col">
				<h1>??? ??????
					
					<sec:authorize access="isAuthenticated()">
						<sec:authentication property="principal" var="principal"/>
						<!-- 
						???????????? ?????? : ${principal.username}
						????????? ?????? : ${board.memberId} 
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
						<label class="form-label" for="input1">??????</label>
						<input class="form-control" type="text" name="title" required
							id="input1" value="${board.title }" readonly/>
					</div>

					<div>
						<label class="form-label" for="textarea1">??????</label>
						<div class="form-control" name="body" id="summernote"
							cols="30" rows="10" readonly>${board.body }</div>
					</div>
					
					<c:forEach items="${board.fileName }" var="file">
						<%
						String file = (String) pageContext.getAttribute("file");
						String encodedFileName = java.net.URLEncoder.encode(file, "utf-8");
						pageContext.setAttribute("encodedFileName", encodedFileName);
						%>
						<div class="row">
							<div class="col-1">
							<!-- ?????? ???????????? -->
								<div class="d-none removeFileCheckbox">
									<i class="fa-solid fa-trash-can"></i>?????? <br />
									<input type="checkbox" name="removeFileList" value="${file }"/>									
								</div>
							</div>
							<div class="col-11">
								<div>
									<!-- ?????? aws ???????????? -->
									<img class="img-fluid" src="${imageUrl }/board/${board.id }/${encodedFileName}" alt="" />
								</div>
							</div>
						</div>
					</c:forEach>
					
					<div id="addFileInputContainer1" class="d-none">
						???????????? :
						<input type="file" accept="image/*" multiple="multiple" name="addFileList" id="" />
					</div>
					
					<div>
						<label for="input3" class="form-label">?????????</label>
						<input class="form-control" type="text" value="${board.writerNickName }" readonly/>
					</div> 

					<div>
						<label for="input2" class="form-label">????????????</label>
						<input class="form-control" type="datetime-local" value="${board.inserted }" readonly/>
					</div>
					
					<button id="modify-submit1" class="btn btn-primary d-none">??????</button>
					<button id="delete-submit1" class="btn btn-danger d-none">??????</button>
				</form>
					
			</div>
		</div>
	</div>
	
	
	<%-- ?????? ?????? form --%>
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
	
	
	<%-- ?????? ?????? --%>
	
	<!-- .container.mt-3>.row>.col -->
	<div class="container mt-3">
		<div class="row">
			<div class="col">
				<h3>?????? <span id="numOfReply"></span>???</h3>
			
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
	
	<%-- reply ?????? form --%>
	<div class="d-none">
		<form id="replyDeleteForm1" action="${appRoot }/reply/delete" method="post">
			<input id="replyDeleteInput1" type="text" name="id" />
			<input type="text" name="boardId" value="${board.id }" />
		</form>
	</div>
</body>
</html>








