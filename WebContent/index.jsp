<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="funciones.Funciones"%>
<%
	Funciones fun = new Funciones();
%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
<link rel="stylesheet" href="css/general.css">
<script src="js/jquery-3.2.1.js"></script>
<script src="js/popper.js"></script>
<script src="js/bootstrap.js"></script>
</head>
<body style="height: 100vh;">
	<div class="container container-fluid cuerpo">
		<div class="row justify-content-between">
			<nav
				class="navbar navbar-expand col navbar-light negro T-blanco rounded">
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
			<nav
				class="navbar navbar-expand col navbar-light negro T-blanco rounded">
			<div class="collapse navbar-collapse" id="navbarNav">
				<ul class="navbar-nav">
					<li class="nav-item col"><h3>Login</h3></li>
					<li class="nav-item col"><spam class="form-control">Usuario</spam></li>
					<li class="nav-item col"><input class="form-control"
						type="text" name="usuario" /></li>
					<li class="nav-item col"><spam class="form-control">contraseña</spam></li>
					<li class="nav-item col"><input class="form-control"
						type="text" name="contraseña" /></li>
					<li class="nav-item col"><input class="btn " type="button"
						id="btn_Enviar" value="Ingresar" /></li>
				</ul>
			</div>
			</nav>
		</div>
		<div class="row justify-content-between pie">

			<div class="tab-content" id="Cuerpo">
				<div class="with-50-00">
					<div id="DESCRIPCIONDELSISTEMA">Un sistema rapido y confiable
						con backups diarios, que le permite crear facturas elecrtonias, y
						mas huevadas q se me van a ocurrir.</div>
				</div>
				<div class="with-50-00">
					<div class="fila">

						<spam class="form-control with-50-00">Compania</spam>
						<input class="form-control with-50-00 campo" type="text"
							name="usuario" />
					</div>
					<div class="fila">
						<spam class="form-control with-50-00">Razón Social</spam>
						<input class="form-control with-50-00 campo" type="text"
							name="usuario" />
					</div>
					<div class="fila">
						<spam class="form-control with-50-00">Abreviatura</spam>
						<input class="form-control with-50-00 campo" type="text"
							name="usuario" />
					</div>
					<div class="fila">
						<spam class="form-control with-50-00">Condicion de Iva</spam>
						<select class="form-control with-50-00 campo" type="text"
							name="usuario">
							<%=fun.GetHTMLSelect("iva_codig", "iva_nombr", "dbCondIva", "")%>
						</select>
					</div>
					<div class="fila">
						<spam class="form-control with-50-00">C.U.I.T.</spam>
						<input class="form-control with-50-00 campo" type="text"
							name="usuario" />
					</div>
					<div class="fila">
						<input class="form-control with-50-00 campo btn float-right"
							type="Button" style="padding: 10px; margin: 3px;"
							value="Registrarse" />
					</div>
				</div>
			</div>
		</div>
		<div class="row justify-content-between pie">
			<nav
				class="navbar navbar-expand col navbar-light negro T-blanco rounded">
			<div class="collapse navbar-collapse" id="navbarNav">
				<ul class="navbar-nav">
					<li class="nav-item">Hecho por Ignacio Latrónico</li>
				</ul>
			</div>
			</nav>
		</div>
	</div>
</body>
</html>