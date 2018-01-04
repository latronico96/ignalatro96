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
<script type="text/javascript" src="js/general.js"></script>
<script>
	$(document).ready(function(){
		$("#puntosDeVenta").click(function(){
			$.ajax({
				type:'GET',
				url: 'Frm_ptaVta_ABM.jsp',
				success:function(data){
					$(document.body).prepend($(data));
					$(".modal").draggable();
					$('#Frm_ptaVta_ABM').show();    			      				
        		}, 
        		error:function(data){
        	    	console.log(data);
			    }
        	});
        });	
		
		
		
	});
</script>
</head>
<body style="height: 100vh;">
	<section id="bloqueoAlerta" class="backmodal"></section>
	<div class="container container-fluid cuerpo" style="">
		<!-- Barra de menus -->
		<div class="row justify-content-between">
			<nav class="navbar navbar-expand col navbar-light negro T-blanco rounded">
				<div class="collapse navbar-collapse" id="navbarNav">
					<ul class="navbar-nav">
						<li class="nav-item">
							<h3 class="col-12 negro T-blanco rounded-bottom">Facturacion Electronica</h3>
						</li>
						<li class="nav-item dropdown">
							<a class="nav-link dropdown-toggle" id="archivo" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
								Archivo
							</a>
							<div class="dropdown-menu" aria-labelledby="archivo">
								<a class="dropdown-item" id="nuevo">Nuevo</a>
								<a class="dropdown-item" id="modificar">Modificar</a>
								<div class="dropdown-divider"></div>
								<a class="dropdown-item" id="borrar">Borrar</a>
							</div>
						</li>
						<li class="nav-item dropdown">
							<a class="nav-link dropdown-toggle" id="ver"	data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
								Ver 
							</a>
							<div class="dropdown-menu" aria-labelledby="ver">
								<a class="dropdown-item" id="zoomIn">zoom in +</a>
								<a class="dropdown-item" id="zoomOut">zomm out -</a>
								<a class="dropdown-item" id="zoomAuto">zomm automatico</a>
								<div class="dropdown-divider"></div>
								<a class="dropdown-item" id="fuente+">Fuente +</a>
								<a class="dropdown-item" id="fuente-">Fuente -</a>
							</div>
						</li>
						<li class="nav-item dropdown">
							<a class="nav-link dropdown-toggle" id="configuracion" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
								Configuración
							</a>
							<div class="dropdown-menu" aria-labelledby="configuracion">
								<a class="dropdown-item" id="datosDeFacturacion">Datos De Facturación</a>
								<a class="dropdown-item" id="puntosDeVenta">Puntos de Venta</a>
								<a class="dropdown-item" id="impuestos">Impuestos</a>
								<div class="dropdown-divider"></div>
								<a class="dropdown-item" id="contantes">Contantes</a>
								<div class="dropdown-divider"></div>
								<a class="dropdown-item" id="administracionDeUsuarios">Administracion de Usuarios</a>
							</div>
						</li>
						<li class="nav-item dropdown">
							<a class="nav-link dropdown-toggle" id="ayuda"	data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
								Ayuda
							</a>
							<div class="dropdown-menu" aria-labelledby="ayuda">
								<a class="dropdown-item" id="ejemplos">Ejemplos</a>
								<div class="dropdown-divider"></div>
								<a class="dropdown-item" id="acercaDe">Acerca de</a>
							</div>
						</li>
						<li class="nav-item" id="salir">
							<a class="nav-link" href="Frm_logeo">Salir</a>
						</li>
					</ul>
				</div>
			</nav>
		</div>
		<!-- fin  Barra de menus -->
		<div class="row justify-content-between">
			<!-- Barra Lateral -->
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
			<!-- fin Barra Lateral -->	
			<!-- cuerpo -->
			<div class="col-10 noPadding-left">
				<div class="tab-content rounded" id="Cuerpo">
					<table id="GrillaCuerpo"></table>
					<div id="GrillaCuerpo_pie"></div>
				</div>
			</div>
			<!-- fin cuerpo -->
		</div>		
		<!-- pie -->
		<div class="row justify-content-between pie">
			<nav class="navbar navbar-expand col navbar-light negro T-blanco rounded">
				<div class="collapse navbar-collapse" id="navbarNav">
					<ul class="navbar-nav">
						<li class="nav-item">Hecho por Ignacio Latrónico</li>
					</ul>
				</div>
			</nav>
		</div>		
		<!-- fin pie -->
	</div>
</body>
</html>


