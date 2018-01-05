<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="funciones.Funciones"%>
<%
	Funciones fun = new Funciones();
	String idForm = "Frm_ClienteABM";
	String idGrilla = "ClienteABM";
	String URL = "'./Frm_ClienteABM'";
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

</script>
</head>
<body>
<div id="<%=idForm%>" data-popup="true" class="backmodal formulario">
	<style type="text/css">
		#form {
			position: relative;
			-moz-box-sizing: content-box;
			-webkit-box-sizing: content-box;
			box-sizing: content-box;
			margin: 0px auto;
			width: 100%;
			z-index: 1;
		}
		
		.form-control {
    		margin: 0px auto;
    	}
		
		#jqgridSearchForm {
			position: relative;
			-moz-box-sizing: content-box;
			-webkit-box-sizing: content-box;
			box-sizing: content-box;
			margin: 0px auto;
			width: 100%;
			z-index: 1;
		}
		
		#<%=idForm%>>div {
			width: 720px;
			margin-top: 20px;
		}
	</style>

	<div class="modal" data-tmodal="alerta">
		<div class="modal-header">
			<h5 class="modal-title" id="exampleModalLabel">Cliente
			<button type="button" type="button" class="close"
				onclick="cerrarFormu('<%=idForm%>');">
				<span aria-hidden="true">&times;</span>
			</button>
		</div>
		<div class="modal-body">
			<div class="d-block">
				<fieldset>
  					<legend>Datos:</legend>
					<div class="fila">
						<%=fun.input("cli_compa","form-control campo","","hidden","")%>
						<spam class="form-control with-20-00">Codigo</spam>
						<%=fun.input("cli_codig","form-control with-10-00 campo","","number","")%>
						<spam class="form-control with-20-00">Nombre</spam>
						<%=fun.input("cli_nombr","form-control with-50-00 campo","","text","")%>
					</div>
					<div class="fila">
						<spam class="form-control with-20-00">Telefono</spam>
						<%=fun.input("cli_telef","form-control with-30-00 campo","","text","")%>
						<spam class="form-control with-20-00">Celular</spam>
						<%=fun.input("cli_celul","form-control with-30-00 campo","","text","")%>
					</div>
					<div class="fila">
						<spam class="form-control with-20-00">Direción</spam>
						<%=fun.input("cli_direc","form-control with-80-00 campo","","text","")%>
					</div>
					<div class="fila">				
						<spam class="form-control with-20-00">Cond. de IVA</spam>
						<%=fun.select("cli_condi", "form-control with-80-00 campo", "", "",
										fun.GetHTMLOtion("iva_codig", "iva_nombr", "dbCondIva", ""), "")%>
					</div>
					<div class="fila">
						<spam class="form-control with-20-00">Tipo de Doc.</spam>
						<%=fun.select("cli_tpdoc", "form-control with-30-00 campo", "", "",
										fun.GetHTMLOtion("doc_codig", "doc_nombre", "dbTipoDocumentos", ""), "")%>		
						<spam class="form-control with-20-00">Nro. Doc.</spam>
						<%=fun.input("cli_nrdoc","form-control with-30-00 campo","","text","")%>
					</div>
				</fieldset>
				<fieldset>
	  				<legend>Datos de Facturación:</legend>
					<div class="fila">
						<spam class="form-control with-20-00">Razon Social</spam>
						<%=fun.input("cli_fnomb","form-control with-80-00 campo","","text","")%>
					</div>
					<div class="fila">
						<spam class="form-control with-20-00">Telefono</spam>
						<%=fun.input("cli_ftele","form-control with-30-00 campo","","text","")%>
						<spam class="form-control with-20-00">Celular</spam>
						<%=fun.input("cli_fcelu","form-control with-30-00 campo","","text","")%>
					</div>
					<div class="fila">
						<spam class="form-control with-20-00">Direción</spam>
						<%=fun.input("cli_fdire","form-control with-80-00 campo","","text","")%>	
					</div>
					<div class="fila">			
						<spam class="form-control with-20-00">Cond. de IVA</spam>
						<%=fun.select("cli_fcond", "form-control with-80-00 campo", "", "",
										fun.GetHTMLOtion("iva_codig", "iva_nombr", "dbCondIva", ""), "")%>
					</div>
					<div class="fila">
						<spam class="form-control with-20-00">Tipo de Doc.</spam>
						<%=fun.select("cli_ftdoc", "form-control with-30-00 campo", "", "",
										fun.GetHTMLOtion("doc_codig", "doc_nombre", "dbTipoDocumentos", ""), "")%>
						<spam class="form-control with-20-00">Nro. Doc.</spam>
						<%=fun.input("cli_fndoc","form-control with-30-00 campo","","text","")%>
					</div>
				</fieldset>
			</div>
		</div>
		<div class="modal-footer">
			<button type="button" class="btn btn-primary">Guardar Cambios</button>
			<button type="button" class="btn btn-secondary" data-dismiss="modal" onclick="cerrarFormu('<%=idForm%>');">Cerrar</button>
		</div>
	</div>

	<script type="text/javascript">
			
		var idGrilla="<%=idGrilla%>";
        var NidGrilla = "#" + idGrilla;
        
        $(document).ready(function(){	        
	        $("#<%=idForm%>").draggable();
	        $("#<%=idForm%>").show();    	
        });

	</script>
	
</div>

</body>
</html>