<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="funciones.Funciones"%>
<%
	Funciones fun = new Funciones();
%>
<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="utf-8" />
<title>Prueba 29/10/2017</title>
<link rel="stylesheet" href="css/bootstrap.css">
<link rel="stylesheet" href="css/pisaBootstrap.css">
<link rel="stylesheet" href="css/general.css">
<script type="text/javascript" src="js/jquery-3.2.1.js"></script>
<script type="text/javascript" src="js/popper.js"></script>
<script type="text/javascript" src="js/bootstrap.js"></script>
<script type="text/javascript" src="js/datepickers.js"></script>
<script type="text/javascript" src="js/jquery.jqGrid.min.js"></script>
<script type="text/javascript" src="js/i18n/grid.locale-es.js"></script>
<script>
        $(document).ready(function(){
		});
		</script>
</head>
<body style="height: 100vh;">
	<div class="container container-fluid cuerpo" style="">
		<div class="row justify-content-between">
			<nav
				class="navbar navbar-expand col navbar-light negro T-blanco rounded">
				<div class="collapse navbar-collapse" id="navbarNav">
					<ul class="navbar-nav">
						<li class="nav-item">
							<h3 class="col-12 negro T-blanco rounded-bottom">Facturacion
								Electronica</h3>
						</li>
						<li class="nav-item dropdown"><a
							class="nav-link dropdown-toggle" id="idnro1"
							data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
								Archivo </a>
							<div class="dropdown-menu" aria-labelledby="idnro1">
								<a class="dropdown-item">Nuevo</a> <a class="dropdown-item">Modificar</a>
								<div class="dropdown-divider"></div>
								<a class="dropdown-item">Borrar</a>
							</div></li>
						<li class="nav-item dropdown"><a
							class="nav-link dropdown-toggle" id="idnro2"
							data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
								ver </a>
							<div class="dropdown-menu" aria-labelledby="idnro2">
								<a class="dropdown-item">zoom in +</a> <a class="dropdown-item">zomm
									out -</a> <a class="dropdown-item">zomm automatico</a>
								<div class="dropdown-divider"></div>
								<a class="dropdown-item">Fuente +</a> <a class="dropdown-item">Fuente
									-</a>
							</div></li>
						<li class="nav-item dropdown"><a
							class="nav-link dropdown-toggle" id="idnro3"
							data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
								Configuración </a>
							<div class="dropdown-menu" aria-labelledby="idnro3">
								<a class="dropdown-item">Datos De Facturación</a> <a
									class="dropdown-item">Puntos de Venta</a> <a
									class="dropdown-item">Impuestos</a>
								<div class="dropdown-divider"></div>
								<a class="dropdown-item">Contantes</a>
								<div class="dropdown-divider"></div>
								<a class="dropdown-item">Administracion de Usuarios</a>
							</div></li>
						<li class="nav-item dropdown"><a
							class="nav-link dropdown-toggle" id="idnro4"
							data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
								Ayuda </a>
							<div class="dropdown-menu" aria-labelledby="idnro4">
								<a class="dropdown-item">Ejemplos</a>
								<div class="dropdown-divider"></div>
								<a class="dropdown-item">Acerca de</a>
							</div></li>
						<li class="nav-item" id="salir"><a class="nav-link">Salir</a>
						</li>
					</ul>
				</div>
			</nav>
		</div>
		<div class="row justify-content-between">
			<div class="col-2 noPadding-right">
				<div class="list-group" id="list-tab" role="tablist">
					<div id="accordion" role="tablist">
						<div class="card">
							<div class="card-header" role="tab" id="Cli">
								<h5 class="mb-0">
									<a class="collapsed" href="#Cuerpo">Clientes</a>
								</h5>
							</div>
							<div class="card-header" role="tab" id="Art">
								<h5 class="mb-0">
									<a class="collapsed" href="#Cuerpo">Artículos</a>
								</h5>
							</div>
							<div class="card-header" role="tab" id="Cmp">
								<h5 class="mb-0">
									<a class="collapsed" href="#Cuerpo">Cmp. de venta</a>
								</h5>
							</div>
							<div class="card-header" role="tab" id="Rec">
								<h5 class="mb-0">
									<a class="collapsed" href="#Cuerpo">Recibos</a>
								</h5>
							</div>
						</div>
					</div>
				</div>
			</div>
			<div class="col-10 noPadding-left">
				<div class="tab-content" id="Cuerpo"></div>
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

