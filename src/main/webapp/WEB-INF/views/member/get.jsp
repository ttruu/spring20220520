<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="my" tagdir="/WEB-INF/tags"%>
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
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/js/bootstrap.bundle.min.js"
	integrity="sha384-ka7Sk0Gln4gmtz2MlQnikT1wXgYsOg+OMhuP+IlRH9sENBO0LRn5q+8nbTov4+1p"
	crossorigin="anonymous"></script>
<script>
	$(document).ready(function() {
		// 암호, 암호 확인 일치 여부
		let passwordCheck = true;
		// 이메일 중복 확인 여부
		let emailCheck = true;
		// 닉네임 중복 확인 여부
		let nickNameCheck = true;
			
		
		// 기존 이메일 
		const oldEmail = $("#emailInput1").val();

		//기존 닉네임
		const oldNickName = $("#nickNameInput1").val();
		
		// 수정버튼(modifySubmitButton1) 활성화 함수
		const enableModifyButton = function() {
			if(passwordCheck && emailCheck && nickNameCheck) {
				$("#modifySubmitButton1").removeAttr("disabled");
			} else {
				$("#modifySubmitButton1").attr("disabled", "");
			}
		}

		// 이메일 input 요소에 text 변경시 이메일 중복확인버튼 활성화
		$("#emailInput1").keyup(function() {
			const newEmail = $("#emailInput1").val();

			// 기존 이메일과 수정한 이메일이 같은지 다른지 확인
			if (oldEmail === newEmail) {
				$("#checkEmailButton2").attr("disabled", "");
				$("#emailMessage2").text("");
				emailCheck = true;
			} else {
				$("#checkEmailButton2").removeAttr("disabled");
				emailCheck = false;
			}
			enableModifyButton();
		});

		// 닉네임 input 요소에 text 변경시 닉네임 중복 체크 활성화
		$("#nickNameInput1").keyup(function() {
			const newNickName = $("#nickNameInput1").val();

			// 기존 이메일과 수정한 이메일이 같은지 다른지 확인
			if (oldNickName === newNickName) {
				$("#checkNickNameButton2").attr("disabled", "");
				$("#nickNameMessage2").text("");
				nickNameCheck = true;
			} else {
				$("#checkNickNameButton2").removeAttr("disabled");
				nickNameCheck = false;
			}
			
			enableModifyButton();
		});
		
		// 이메일 중복버튼 클릭시 ajax요청 발생	
		$("#checkEmailButton2").click(function(e) {
			// 기본 이벤트 진행 중지
			e.preventDefault();

			const data = {
				email : $("#emailInput1").val()
			};
			emailCheck = false;
			$.ajax({
				url : "${appRoot}/member/check",
				type : "get",
				data : data,
				success : function(data) {
					switch (data) {
					case "ok":
						$("#emailMessage2").text("사용 가능한 이메일 입니다");
						emailCheck = true;
						break;

					case "notOk":
						$("#emailMessage2").text("사용 불가능한 이메일 입니다");
						break;
					}
				},
				error : function() {
					$("#emailMessage2").text("중복 확인 중 문제 발생, 다시 시도해 주세요");
				},
				complete : function() {
					console.log("이메일 중복 확인 완료")
					enableModifyButton();
					//$("#checkEmailButton2").attr("disabled");
				}
			});
		});
		
		// 닉네임 중복버튼 클릭시 ajax요청 발생	
		$("#checkNickNameButton2").click(function(e) {
			// 기본 이벤트 진행 중지
			e.preventDefault();

			const data = {
				nickName : $("#nickNameInput1").val()
			};
			nickNameCheck = false;
			$.ajax({
				url : "${appRoot}/member/check",
				type : "get",
				data : data,
				success : function(data) {
					switch (data) {
					case "ok":
						$("#nickNameMessage2").text("사용 가능한 닉네임 입니다");
						nickNameCheck = true;
						break;
					case "notOk":
						$("#nickNameMessage2").text("사용 불가능한 닉네임 입니다");
						break;
					}
				},
				error : function() {
					$("#nickNameMessage2").text("중복 확인 중 문제 발생, 다시 시도해 주세요");
				},
				complete : function() {
					console.log("닉네임 중복 확인 완료")
					enableModifyButton();
					//$("#checkEmailButton2").attr("disabled");
				}
			});
		});
		
		// 암호/암호확인 요소 값 변경시
		$("#passwordInput1, #passwordInput2").keyup(function() {
			const pw1 = $("#passwordInput1").val();
			const pw2 = $("#passwordInput2").val();
			
			if (pw1 === pw2) {
				$("#passwordMessage2").text("패스워드가 일치합니다");
				passwordCheck = true;
			} else {
				$("#passwordMessage2").text("패스워드가 일치하지 않습니다");
				passwordCheck = false;
			}
			
			enableModifyButton();
		});
		
		// 수정submit 버튼 () 클릭시
		$("#modifySubmitButton2").click(function(e) {
			e.preventDefault();
			
			const form2 = $("#form2");
			
			// input값 옮기기
			form2.find("[name=password]").val($("#passwordInput1").val());
			form2.find("[name=email]").val($("#emailInput1").val());
			form2.find("[name=nickName]").val($("#nickNameInput1").val());
			
			// submit
			form2.submit();
		});
		

	});
</script>
<title>Insert title here</title>
</head>
<body>
	<my:navBar current="memberInfo"></my:navBar>

	<!-- .container>.row>.col>h1{회원정보} -->
	<div class="container">
		<div class="row">
			<div class="col">
					<div>
						<p>${message }</p>
					</div>
			
					<div>
						<h1>회원정보</h1>
						아이디 :
						<input type="text" value="${member.id }" readonly />
						<br />
						암호 :
						<input id="passwordInput1" type="text" value="" />
						<br />
						암호확인 :
						<input id="passwordInput2" type="text" value="" />
						<br />
						<p id="passwordMessage2"></p>

						이메일 :
						<input id="emailInput1" type="email" value="${member.email }" />
						<button id="checkEmailButton2" disabled>이메일중복확인</button>
						<p id="emailMessage2"></p>
						<br />

						닉네임 :
						<input id="nickNameInput1" type="text" value="${member.nickName }" />
						<button id="checkNickNameButton2" disabled>닉네임중복확인</button>
						<p id="nickNameMessage2"></p>
						<br />

						가입날짜 :
						<input type="datetime-local" value="${member.inserted }" readonly />
						<br />
					</div>

				<%-- 요구사항(0526)
				1. 이메일 input에 변경 발생시 '이메일중복확인버튼 활성화'
				   ->버튼클릭시 ajax로 요청/응답, 적절한 메시지 출력
				2. 닉네임 input에 변경 발생시 '닉네임중복확인버튼 활성화'
				   ->버튼클릭시 ajax로 요청/응답, 적절한 메시지 출력
				3. 암호/암호확인일치, 이메일 중복확인 완료 ,닉네임 중복확인 완료 시에만
				   수정버튼 활성화
				 --%>
				 
					<div>
						<button id="modifySubmitButton1" data-bs-toggle="modal" 
						data-bs-target="#modal2" disabled>수정</button>
						<button id="delete-submit1" data-bs-toggle="modal"
							data-bs-target="#modal1" class="btn btn-danger">삭제</button>
					</div>
			</div>
		</div>
	</div>
	<!-- 탈퇴 암호 확인 Modal -->
	<div class="modal fade" id="modal1" tabindex="-1"
		aria-labelledby="exampleModalLabel" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="exampleModalLabel">탈퇴하시겠습니까?</h5>
					<button type="button" class="btn-close" data-bs-dismiss="modal"
						aria-label="Close"></button>
				</div>
				<div class="modal-body">
					<form id="form1" action="${appRoot }/member/remove" method="post">
						<input type="hidden" value="${member.id }" name="id" />
						암호 :
						<input type="text" name="password" />
					</form>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-secondary"
						data-bs-dismiss="modal">Close</button>
					<button form="form1" type="submit" class="btn btn-danger">탈퇴</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 수정(modify) 암호 확인 Modal -->
	<div class="modal fade" id="modal2" tabindex="-1"
		aria-labelledby="exampleModalLabel" aria-hidden="true">
		<div class="modal-dialog">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="exampleModalLabel2">수정하시겠습니까?(**암호입력)</h5>
					<button type="button" class="btn-close" data-bs-dismiss="modal"
						aria-label="Close"></button>
				</div>
				<div class="modal-body">
					<form id="form2" action="${appRoot }/member/modify" method="post">
						<input type="hidden" value="${member.id }" name="id" />
						<input type="hidden" name="password" />
						<input type="hidden" name="email" />
						<input type="hidden" name="nickName" />
						기존암호 :
						<input type="text" name="oldPassword" />
					</form>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-secondary"
						data-bs-dismiss="modal">Close</button>
					<button id="modifySubmitButton2" form="form2" type="submit" class="btn btn-primary">수정</button>
				</div>
			</div>
		</div>
	</div>
</body>
</html>