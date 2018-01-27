<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="funciones.Funciones"%>
<%
	Funciones fun = new Funciones(request);
	String idForm = "Frm_ClienteABM";
	String idGrilla = "ClienteABM";
	String URL = "'./Frm_ClienteABM'";
	String modo=(String) request.getAttribute("modo");
	String cliente=(String) request.getAttribute("Cliente");
%>
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
			<h5 class="modal-title" id="exampleModalLabel"><spam id="Titulo"></spam> Cliente</h5>
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
						<spam class="form-control with-20-00">Nombre</spam>
						<%=fun.input("cli_codig","form-control with-10-00 campo","","number"," maxlength=\"4\"")%>
						<%=fun.input("cli_nombr","form-control with-70-00 campo","","text"," maxlength=\"45\"")%>
					</div>
					<div class="fila">
						<spam class="form-control with-20-00">Telefono</spam>
						<%=fun.input("cli_telef","form-control with-30-00 campo","","text"," maxlength=\"30\"")%>
						<spam class="form-control with-20-00">Celular</spam>
						<%=fun.input("cli_celul","form-control with-30-00 campo","","text"," maxlength=\"30\"")%>
					</div>
					<div class="fila">
						<spam class="form-control with-20-00">Direción</spam>
						<%=fun.input("cli_direc","form-control with-80-00 campo","","text"," maxlength=\"60\"")%>
					</div>
					<div class="fila">				
						<spam class="form-control with-20-00">Cond. de IVA</spam>
						<%=fun.select("cli_cliva", "form-control with-80-00 campo", "", "",
										fun.GetHTMLOtion("iva_codig", "iva_nombr", "dbCondIva","", ""), "")%>
					</div>
					<div class="fila">
						<spam class="form-control with-20-00">Tipo de Doc.</spam>
						<%=fun.select("cli_tpdoc", "form-control with-30-00 campo", "", "",
										fun.GetHTMLOtion("doc_codig", "doc_nombre", "dbTipoDocumentos","", ""), "")%>		
						<spam class="form-control with-20-00">Nro. Doc.</spam>
						<%=fun.input("cli_nrdoc","form-control with-30-00 campo","","text"," maxlength=\"11\"")%>
					</div>
					<div class="fila">				
						<spam class="form-control with-20-00">Mail</spam>
						<%=fun.input("cli_email","form-control with-80-00 campo","","text"," maxlength=\"80\"")%>
					</div><div class="fila">
						<spam class="form-control with-20-00">CBU</spam>
						<%=fun.input("cli_nrocbu","form-control with-30-00 campo","","text"," maxlength=\"22\"")%>
						<spam class="form-control with-17-00">Cond. de pagos</spam>
						<% String optionsCondi="<option value=\""+fun.Contado+"\">Contado</option>"
												+"<option value=\""+fun.CtaCorrienta+"\">Cta. Corriente</option>"; 
						out.println(fun.select("cli_condi","form-control with-18-00 campo","","",optionsCondi,""));%>	
						<spam class="form-control with-10-00">Plazo</spam>
						<%=fun.input("cli_plazo","form-control with-5-00 campo","","text"," maxlength=\"2\"")%>
					</div>
					<div class="fila">			
						<spam class="form-control with-30-00">Facturar a otra persona</spam>	
						<%=fun.input("cli_fac","form-control with-5-00 campo","margin: 6.5px 0px;","checkbox","")%>	
						<spam class="form-control with-50-00">Datos bancarios verificados 01/12/2017 (IJL)</spam>
							<%=fun.button("cli_veri", "form-control with-15-00 campo", "", "button", "veri", "verificar","")%>
					</div>
				</fieldset>
				<fieldset id="facturacion">
	  				<legend>Datos de Facturación:</legend>
					<div class="fila">
						<spam class="form-control with-20-00">Razon Social</spam>
						<%=fun.input("cli_fnomb","form-control with-80-00 campo","","text"," maxlength=\"45\"")%>
					</div>
					<div class="fila">
						<spam class="form-control with-20-00">Telefono</spam>
						<%=fun.input("cli_ftele","form-control with-30-00 campo","","text"," maxlength=\"30\"")%>
						<spam class="form-control with-20-00">Celular</spam>
						<%=fun.input("cli_fcelu","form-control with-30-00 campo","","text"," maxlength=\"30\"")%>
					</div>
					<div class="fila">
						<spam class="form-control with-20-00">Direción</spam>
						<%=fun.input("cli_fdire","form-control with-80-00 campo","","text"," maxlength=\"60\"")%>	
					</div>
					<div class="fila">			
						<spam class="form-control with-20-00">Cond. de IVA</spam>
						<%=fun.select("cli_fciva", "form-control with-80-00 campo", "", "",
										fun.GetHTMLOtion("iva_codig", "iva_nombr", "dbCondIva", "", ""), "")%>
					</div>
					<div class="fila">
						<spam class="form-control with-20-00">Tipo de Doc.</spam>
						<%=fun.select("cli_ftdoc", "form-control with-30-00 campo", "", "",
										fun.GetHTMLOtion("doc_codig", "doc_nombre", "dbTipoDocumentos", "", ""), "")%>
						<spam class="form-control with-20-00">Nro. Doc.</spam>
						<%=fun.input("cli_fndoc","form-control with-30-00 campo","","text"," maxlength=\"11\"")%>
					</div>
				</fieldset>
			</div>
		</div>
		<div class="modal-footer">
			<button type="button" class="btn btn-primary" id="btn_confirmar">Guardar Cambios</button>
			<button type="button" class="btn btn-secondary" data-dismiss="modal" onclick="cerrarFormu('<%=idForm%>');">Cerrar</button>
		</div>
	</div>

	<script type="text/javascript">       
        $(document).ready(function(){	 		
       		var idGrilla="<%=idGrilla%>";
        	var NidGrilla = "#" + idGrilla;
        	var formulario = $("#<%=idForm%>");
        	formulario.modo="<%=modo%>";
        	<%=cliente%>
        	Cliente.forEach(function(value,index){	
        		if (value=="true" || value=="false"){
        			$("#"+index,formulario).first().prop("checked",(value=="true"?true:false));            			
        		}else{
        			$("#"+index,formulario).first().val(value);
        		}	
        	});
        	
        	if ($("#cli_fac",formulario).is(":checked")){
				$("#facturacion",formulario).show();        				
				
			}else{
				$("#facturacion",formulario).hide();
			}
        	
        	var modoTitulo="";
        	switch(formulario.modo){
	        	case "CONS":
	        		modoTitulo="Consultar";	  
	        		$("#btn_confirmar",formulario).hide();
		        break;
	        	case "BAJA":
	        		modoTitulo="Eliminar";	
		        break;
	        	case "MODI":
	        		modoTitulo="Modificar";	        
		        break;
	        	case "ALTA":
	        		modoTitulo="Crear";	        
		        break;	        
		        default:
			        break;
	        }       
        	$(".modal",formulario).draggable();
    		$("#btn_confirmar",formulario).html(modoTitulo);
        	formulario.show();   
        	
        	$("#cli_fac",formulario).unbind("click").click(function(){
        			if ($(this).is(":checked")){
        				$("#facturacion",formulario).show();        				
        				
        			}else{
        				$("#facturacion",formulario).hide();
        				$("input,textarea",$("#facturacion",formulario)).val("");
        				$("select option",$("#facturacion",formulario)).removeAttr("selected");
        			}
        	});        	
        	
        	$("#btn_confirmar",formulario).unbind("click").click(function(){
        		if (validarCli()){
        			cargando();
				    $.ajax({
				    	dataType:'json',
				    	data: $(".campo", formulario).serialize(),
				    	type:'POST',
				    	url:"/<%=idForm%>", 
				    	success:function(data){		
				    		cerrarAlerta();//mensaje cargando
					    	if(data.error !=0){
						    	abrirAlerta("ERR", data.msg);//hubo  un error
					    	}else{
					    		cerrarFormu('<%=idForm%>'); // cierra le fomrulario
					    	}
				    	},
				    	error:function(data){		
				    		cerrarAlerta();
					    	abrirAlerta("ERR", data.msg);
				    	}
				    });
        		}
        	}); 
        	$("#Titulo",formulario).html(modoTitulo);
        });
        

    	
    	function validarCli(){
    		var formulario = $("#<%=idForm%>");    		
    		var res=true;
    		
    		if(res && $("#cli_nombr",formulario).val()==""){
    			mensaje="El nombre no puede quedar vacio.";
    			res=false;
    			$("#cli_nombr").abrirpopover(mensaje);
    		}
    		if(res && $("#cli_telef",formulario).val()==""){
    			mensaje="El telefono no puede quedar vacio.";
    			res=false;
    			$("#cli_telef").abrirpopover(mensaje);
    		}/*
    		if(res && $("#cli_celul",formulario).val()==""){
    			mensaje="no puede quedar vacio.";
    			res=false;
    			$("#cli_celul").abrirpopover(mensaje);
    		}
    		if(res && $("#cli_direc",formulario).val()==""){
    			mensaje="no puede quedar vacio.";
    			res=false;
    			$("#cli_direc").abrirpopover(mensaje);
    		}*/
    		if(res && $("#cli_cliva",formulario).val()==""){
    			mensaje="La condicion de IVA no puede quedar vacia.";
    			res=false;
    			$("#cli_condi").abrirpopover(mensaje);
    		}
    		if(res && $("#cli_tpdoc",formulario).val()==""){
    			mensaje="El tipo de Documento no puede quedar vacio.";
    			res=false;
    			$("#cli_tpdoc").abrirpopover(mensaje);
    		}
    		if(res && $("#cli_nrdoc",formulario).val()==""){
    			mensaje="El numero de Dcoumento no puede quedar vacio.";
    			res=false;
    			$("#cli_nrdoc").abrirpopover(mensaje);
    		}/*
    		if(res && $("#cli_email",formulario).val()==""){
    			mensaje="El email no puede quedar vacio.";
    			res=false;
    			$("#cli_email").abrirpopover(mensaje);
    		}
    		if(res && $("#cli_nrocbu",formulario).val()==""){
    			mensaje="El CBU no puede quedar vacio.";
    			res=false;
    			$("#cli_nrocbu").abrirpopover(mensaje);
    		}*/

    		if(res && $("#cli_condi",formulario).val()==""){
    			mensaje="Condicion de pago no puede quedar vacio.";
    			res=false;
    			$("#cli_condi").abrirpopover(mensaje);
    		}

    		if(res && $("#cli_plazo",formulario).val()=="" && $("#cli_condi",formulario).val()=="U"){
    			mensaje="Si se factura a cta. Corriente el plazo de pago no puede quedar vacio.";
    			res=false;
    			$("#cli_plazo").abrirpopover(mensaje);
    		}

    		if(res && $("cli_fnomb").val()==""){
    			if(res && $("cli_ftele").val()==""){
    				mensaje="El telefono no puede quedar vacio.";
    				res=false;
    				$("#cli_ftele").abrirpopover(mensaje);
    			}
    			/*if(res && $("cli_fcelu").val()==""){
    				mensaje="El cleular no puede quedar vacio.";
    				res=false;
    				$("#cli_fcelu").abrirpopover(mensaje);
    			}
    			if(res && $("cli_fdire").val()==""){
    				mensaje="La direccion no puede quedar vacia.";
    				res=false;
    				$("#cli_fdire").abrirpopover(mensaje);
    			}*/
    			if(res && $("cli_fciva").val()==""){
    				mensaje="La condicion de IVA no puede quedar vacia.";
    				res=false;
    				$("#cli_fciva").abrirpopover(mensaje);
    			}
    			if(res && $("cli_ftdoc").val()==""){
    				mensaje="El tipo de Documento no puede quedar vacio.";
    				res=false;
    				$("#cli_ftdoc").abrirpopover(mensaje);
    			}
    			if(res && $("cli_fndoc").val()==""){
    				mensaje="El numero de Dcoumento no puede quedar vacio.";
    				res=false;
    				$("#cli_fndoc").abrirpopover(mensaje);
    			}
    		}
    		return res;   		
    	}

	</script>
	
</div>