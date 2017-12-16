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
<body style="height: 100vh;">
	<div class="container container-fluid" style="overflow: auto;">
		<div class="row justify-content-between">
			<nav class="navbar navbar-expand col navbar-light negro T-blanco rounded">
			<div class="collapse navbar-collapse" id="navbarNav">
				<ul class="navbar-nav">
					<li class="nav-item">
						<h3 class="col-12 negro T-blanco rounded-bottom">Facturacion
							Electronica</h3>
					</li>
				</ul>
			</div>
			</nav>
		</div>
		<div class="row justify-content-between">
			<nav class="navbar navbar-expand col navbar-light negro T-blanco rounded">
			<div class="collapse navbar-collapse" id="navbarNav">
				<ul class="navbar-nav">
					<li class="nav-item col"><h3>Login</h3></li> 
					<li class="nav-item col"><spam  class="form-control">Usuario</spam></li>
					<li class="nav-item col"><input class="form-control" type="text" name="usuario" /></li>
					<li class="nav-item col"><spam  class="form-control">contraseña</spam></li>
					<li class="nav-item col"><input class="form-control" type="text" name="contraseña" /></li>
					<li class="nav-item col"><input class="btn " type="button" id="btn_Enviar" value="Ingresar" /></li>
				</ul>
			</div>
			</nav>
		</div>		
	</div>
</body>
</html>