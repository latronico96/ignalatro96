<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
	<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
	<title>Insert title here</title>
	<link rel="stylesheet" href="css/bootstrap.css">
	<link rel="stylesheet" href="css/pisaBootstrap.css">
	<link rel="stylesheet" href="css/general.css">
	<script src="js/jquery-3.2.1.js"></script>
	<script src="js/popper.js"></script>
	<script src="js/bootstrap.js"></script>
</head>
<body style="height: 100%;">
	<div class="container">
		<div class="row">
			<div class="row">
				<h1>Facturacion Electronica</h1>
			</div>
		</div>
	</div>
	<div class="container container-fluid" style="overflow: auto;">
		<div class="row justify-content-between align-items-center">
			<div class="col-md-6 col-lg-8 col-xl-8 align-self-center "></div>
			<div class="col-md-6 col-lg-4 col-xl-4 recuadro align-self-center">
				<div class="interno rounded border border-success verde T-blanco">
					<div class="container">
						<form method="post" id="formId" enctype="multipart/form-data">
							<div class="row justify-content-md-center">
								<h3>Login</h3>
							</div>
							<div class="row justify-content-md-center">
								<div class="col-12 col-md-4">Usuario</div>
								<div class="col-12 col-md-8">
									<input class="form-control" type="text" name="usuario" />
								</div>
							</div>
							<div class="row justify-content-md-center">
								<div class="col-12 col-md-4">contraseña</div>
								<div class="col-12 col-md-8">
									<input class="form-control" type="text" name="contrase?a" />
								</div>
							</div>
							<div class="row justify-content-md-center">
								<div class="col-10 col-md-2">
									<input class="btn " type="button" id="btn_Enviar"
										value="Upload" />
								</div>
							</div>
						</form>
					</div>
				</div>
			</div>
		</div>
	</div>
</body>
</html>