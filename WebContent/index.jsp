<%@page import="java.math.BigInteger"%>
<%@ page language="java" contentType="text/html; charset=UTF-8;link=index;"
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
<link rel="stylesheet" href="css/general.css">
<script src="js/jquery-3.2.1.js"></script>
<script src="js/jquery-ui.js"></script>
<script src="js/popper.js"></script>
<script src="js/bootstrap.js"></script>
<script src="js/general.js" charset="UTF-8"></script>
<script>
	$(document).ready(function(){
		$("#frm_login input").on('keyup', function (e) {
		    if (e.keyCode == 13) {
		    	$("#frm_login input#btn_Enviar").click();
		    }
		});
		
	    $("input[type=button]").click(function(){
		    var formulario = $("#login");
		    var cancelar = false;
		    var objeto = "";
		    var mensaje = "";
		    var parametros = "";
		    
		    if(this.id == "btn_Enviar"){
			    formulario = $("#frm_login");
			    $("*", formulario).popover('hide');
			    if(!cancelar && $("#usuario", formulario).val() == ""){
				    mensaje = "El usuario no puede ser vacio.";
				    cancelar = true;
				    objeto = $("#usuario", formulario);
				    $("#usuario", formulario).focus();
			    }
			    
			    if(!cancelar && $("#contrasenia", formulario).val() == ""){
				    mensaje = "La contraseña no puede ser vacia.";
				    cancelar = true;
				    objeto = $("#contrasenia", formulario);
				    $("#contrasenia", formulario).focus();
			    }
			    
		    }else{
			    formulario = $("#frm_registrar");
			    $("*", formulario).popover('hide');
			    if(!cancelar && $("#compania", formulario).val() == ""){
				    mensaje = "La compania no puede quedar vacia.";
				    cancelar = true;
				    objeto = $("#compania", formulario);
				    $("#compania", formulario).focus();
			    }
			    if(!cancelar && $("#razon", formulario).val() == ""){
				    mensaje = "La razon social no puede quedar vacia.";
				    cancelar = true;
				    objeto = $("#razon", formulario);
				    $("#razon", formulario).focus();
			    }
			    if(!cancelar && $("#abrev", formulario).val() == ""){
				    mensaje = "La abreviatura no puede quedar vacia.";
				    cancelar = true;
				    objeto = $("#abrev", formulario);
				    $("#abrev", formulario).focus();
			    }
			    if(!cancelar && $("#condIva", formulario).val() == ""){
				    mensaje = "La condIva no puede quedar vacia.";
				    cancelar = true;
				    objeto = $("#condIva", formulario);
				    $("#condIva", formulario).focus();
			    }
			    if(!cancelar && $("#cuit", formulario).val() == ""){
				    mensaje = "El cuit no puede quedar vacio.";
				    cancelar = true;
				    objeto = $("#cuit", formulario);
				    $("#cuit", formulario).focus();
			    }
			    if(!cancelar && $("#usuario", formulario).val() == ""){
				    mensaje = "El usuario no puede quedar vacio.";
				    cancelar = true;
				    objeto = $("#usuario", formulario);
				    $("#usuario", formulario).focus();
			    }
			    if(!cancelar && $("#contrasenia", formulario).val() == ""){
				    mensaje = "La contraseña no puede quedar vacia.";
				    cancelar = true;
				    objeto = $("#contrasenia", formulario);
				    $("#contrasenia", formulario).focus();
			    }
			    if(!cancelar && $("#contrasenia2", formulario).val() == ""){
				    mensaje = "La contraseña no puede quedar vacia.";
				    cancelar = true;
				    objeto = $("#contrasenia2", formulario);
				    $("#contrasenia2", formulario).focus();
			    }
			    if(!cancelar && $("#contrasenia2", formulario).val() != $("#contrasenia", formulario).val()){
				    mensaje = "Las contraseñas deben coinsidir";
				    cancelar = true;
				    objeto = $("#contrasenia2", formulario);
				    $("#contrasenia2", formulario).focus();
			    }
			    
		    }
		    parametros = $(".campo", formulario).serialize();
		    
		    if(cancelar){
			    console.log(mensaje);
			    objeto.popover({html:true, trigger:"manual"})
			    var popover = objeto.data('bs.popover');
			    popover.config.content = mensaje;
			    objeto.popover('show');
		    }else{
		    	cargando();
			    $.ajax({
			    	dataType:'json',
			    	data:parametros,
			    	type:'GET',
			    	url:"/Frm_logeo", 
			    	success:function(data){		
			    		cerrarAlerta();
				    	if(data.cod != 1){
					    	abrirAlerta("ERR", data.msg);
				    	}else{
					   		window.location.href = "frm_main.jsp";
				    	}
				    	console.log(JSON.stringify(data));
			    	},
			    	error:function(data){		
			    		cerrarAlerta();
				    	abrirAlerta("ERR", data.msg);
			    	}
			    });
			    
		    }
	    });
    });
</script>
</head>
<body style="height: 100vh;">
	<section id="bloqueoAlerta" class="backmodal"></section>
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
		<div id="frm_login" class="row justify-content-between">
			<nav
				class="navbar navbar-expand col navbar-light negro T-blanco rounded">
			<div class="collapse navbar-collapse" id="navbarNav">
				<ul class="navbar-nav">
					<li class="nav-item col"><h4 style="margin-bottom: 2px;">Login</h4>
						<input id="form" class="form-control campo" type="hidden" value="frm_login">
					</li>
					<li class="nav-item col">
						<span class="form-control">Usuario</span>
					</li>
					<li class="nav-item col">
						<input id="usuario" class="form-control campo" type="text" maxlength="45">
					</li>
					<li class="nav-item col">
						<span class="form-control">contraseña</span>
					</li>
					<li class="nav-item col">
						<input id="contrasenia" class="form-control campo" type="password" maxlength="60">
					</li>
					<li class="nav-item col">
						<button id="btn_Enviar" class="form-control campo btn float-right" 
						style="padding: 2px; margin: 0px;" type="button" value="Ingresar">
							Ingresar
						</button>
					</li>
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
				<div id="frm_registrar" class="with-50-00">
					<div class="fila">

						<span class="form-control with-50-00">Compania</span>
						<input id="form" class="campo" type="hidden" value="frm_registrar">
						<input id="compania" class="form-control with-50-00 campo" type="text" maxlength="45">
					</div>
					<div class="fila">
						<span class="form-control with-50-00">Razón Social</span>
						<input id="razon" class="form-control with-50-00 campo" type="text" maxlength="45">
					</div>
					<div class="fila">
						<span class="form-control with-50-00">Abreviatura</span>
						<input id="abrev" class="form-control with-50-00 campo" type="text" maxlength="3">
					</div>
					<div class="fila">
						<span class="form-control with-50-00">Condicion de Iva</span>
						<select id="condIva" class="form-control with-50-00 campo">
							<%=fun.GetHTMLOtion("iva_codig", "iva_nombr", "dbCondIva", "","")%>
						</select>
					</div>
					<div class="fila">
						<span class="form-control with-50-00">C.U.I.T.</span>
						<input id="cuit" class="form-control with-50-00 campo" type="text" maxlength="11">
					</div>
					<div class="fila">
						<span class="form-control with-50-00">Usuario</span>
						<input id="usuario" class="form-control with-50-00 campo" type="text" maxlength="45">
					</div>
					<div class="fila">
						<span class="form-control with-50-00">Contraseña</span>
						<input id="contrasenia" class="form-control with-50-00 campo" type="password" maxlength="60">
					</div>
					<div class="fila">
						<span class="form-control with-50-00">Confirmar Contraseña</span>
						<input id="contrasenia2" class="form-control with-50-00 campo" type="password" maxlength="60">
					</div>
					<div class="fila">
						<button id="registrarse" class="form-control with-50-00 campo btn float-right"
							style="padding: 10px; margin: 3px;" type="button" value="Registrarse">
							Registrarse
						</button>
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