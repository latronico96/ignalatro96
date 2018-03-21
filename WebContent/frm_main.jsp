<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="funciones.Funciones"%>
<%
	Funciones fun = new Funciones(request);
%>
<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="utf-8" />
<title>Prueba 29/10/2017</title>
<link rel="stylesheet" href="css/general.css">
<script type="text/javascript" src="js/jquery-3.2.1.js"></script>
<script type="text/javascript" src="js/jquery-ui.js"></script>
<script type="text/javascript" src="js/popper.js"></script>
<script type="text/javascript" src="js/bootstrap.js"></script>
<script type="text/javascript" src="js/datepickers.js"></script>
<script type="text/javascript" src="js/jquery.priceformat.js"></script>
<script type="text/javascript" src="js/jquery.jqGrid.min.js"></script>
<script type="text/javascript" src="js/i18n/grid.locale-es.js"></script>
<script type="text/javascript" src="js/general.js" charset="UTF-8"></script>
</head>
<body style="height: 100vh;">
	<div class="container container-fluid cuerpo" style="">
		<!-- Barra de menus -->
		<div class="row justify-content-between">
			<nav class="navbar navbar-expand col navbar-light negro T-blanco rounded">
				<div class="collapse navbar-collapse" id="navbarNav">
					<ul class="navbar-nav">
						<li class="nav-item">
							<h3 class="col-12 negro T-blanco rounded-bottom" style="font-weight: bold;text-shadow: 2px 2px #324731;">Latronic</h3>
						</li>
						<!--li class="nav-item dropdown">
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
								<a class="dropdown-item" id="puntosDeVenta" data-url="Frm_ptaVta_ABM.jsp" data-form="Frm_ptaVta_ABM">Puntos de Venta</a>
								<a class="dropdown-item" id="marcas" data-url="Frm_marcas_ABM.jsp" data-form="Frm_marcas_ABM">Marcas</a>
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
						</li-->
						<li class="nav-item dropdown">
							<a class="nav-link dropdown-toggle" id="configuracion" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
								Artículos
							</a>
							<div class="dropdown-menu" aria-labelledby="configuracion">
								<a class="dropdown-item" id="marcas" data-url="Frm_marcas_ABM.jsp" data-form="Frm_marcas_ABM">Marcas</a>
								<a class="dropdown-item" id="marcas" data-url="Frm_Articulos_CargaRapida.jsp" data-form="Frm_Articulos_CargaRapida">Carga Rapida</a>

							</div>
						</li>
						<li class="nav-item">
							<a class="nav-link" onclick="$('#Prv').click()">
								Proveedores
							</a>
						</li>
						<li class="nav-item">
							<a class="nav-link"  onclick="$('#Cli').click()">
								Clientes
							</a>
						</li>
						<li class="nav-item">
							<a class="nav-link"  onclick="$('#Art').click()">
								Artículos
							</a>
						</li>
						<li class="nav-item">
							<a class="nav-link"  onclick="$('#Rem').click()">
								Remitos
							</a>
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
			<div class="fila">
				<div class="list-group d-none" id="list-tab" role="tablist">
					<div id="accordion" role="tablist">
						<div class="card">
							<div class="card-header" role="tab" id="Prv" data-url="Frm_GrillaProveedores.jsp" data-form="Frm_GrillaProveedores">
								<h5 class="mb-0">
									<a class="collapsed" href="javascript:void(0)">Proveedores</a>
								</h5>
							</div>
							<div class="card-header" role="tab" id="Cli" data-url="Frm_GrillaClientes.jsp" data-form="Frm_GrillaClientes">
								<h5 class="mb-0">
									<a class="collapsed" href="javascript:void(0)">Clientes</a>
								</h5>
							</div>
							<div class="card-header" role="tab" id="Art" data-url="Frm_GrillaArticulos.jsp" data-form="Frm_GrillaArticulos">
								<h5 class="mb-0">
									<a class="collapsed" href="javascript:void(0)">Artículos</a>
								</h5>
							</div>
							<div class="d-none card-header" role="tab" id="Cmp" data-url="Frm_GrillaComprobantes.jsp" data-form="Frm_GrillaComprobantes">
								<h5 class="mb-0">
									<a class="collapsed" href="javascript:void(0)">Cmp. de venta</a>
								</h5>
							</div>
							<div class="card-header" role="tab" id="Rem" data-url="Frm_GrillaRemitos.jsp" data-form="Frm_GrillaRemitos">
								<h5 class="mb-0">
									<a class="collapsed" href="javascript:void(0)">Remitos</a>
								</h5>
							</div>
						</div>
					</div>
				</div>
			</div-->	
			<!-- fin Barra Lateral -->	
			<!-- cuerpo -->
			<div class="fila">
				<div class="tab-content rounded" id="Cuerpo">
					<!-- table id="GrillaCuerpo"></table>
					<div id="GrillaCuerpo_pie"></div>
					<div class="fila">
						<input type="text" id="cli_codig">
						<button type="button" class="btn btn-primary" id="btn_confirmar" onclick="HelpCampo('ART','#cli_codig')">
							<img src="/img/iconos/glyphicons-28-search.png"	style="width: auto; filter: invert(55%);">
						</button>
						<input type="text" id="cli_nombr">
					</div-->
				</div>
			</div>
			<!-- fin cuerpo -->
		</div>		
		<!-- pie -->
		<div class="fila">
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
	
	<section id="bloqueoAlerta" class="backmodal" style="z-index: 10000;"></section><!-- div para mensajes emergentes (al final para que este arriba de todos los formularios -->

	<script>
		$(document).ready(function(){
			$(".dropdown .dropdown-item").click(function(){				
				var item=$(this);	
				if(item.data().hasOwnProperty("url")){
					abrirFormulario(item.data());			
				}
	        });	
			
			$(".card-header").click( function(){
				abrirFormulario($(this).data());				
			});
			$("#Rem").click();
			
		});
	</script>
</body>
</html>

