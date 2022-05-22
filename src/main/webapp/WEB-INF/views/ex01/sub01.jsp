<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
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

<title>Insert title here</title>
</head>
<body>


	<div class="container">
		<div class="row">
			<div class="col">

				<form action="">
					<c:forEach items="${categoryList }" var="category">
						<input type="checkbox" class="form-check-input" name="category"
							value="${category.categoryId}"
							id="category${category.categoryId }" />
							
						<label class="form-check-label"
							for="category${category.categoryId }">${category.categoryName }</label>
					</c:forEach>

					<input type="submit" value="조회" />
				</form>

				<table class="table">
					<thead>
						<tr>
							<th>CategoryName</th>
							<th>ProductName</th>
							<th>Unit</th>
							<th>Price</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach items="${list }" var="prod">
							<tr>
								<td>${prod.categoryName }</td>
								<td>${prod.productName }</td>
								<td>${prod.unit }</td>
								<td>${prod.price }</td>
							</tr>
						</c:forEach>
					</tbody>
				</table>

			</div>
		</div>
	</div>
</body>
</html>