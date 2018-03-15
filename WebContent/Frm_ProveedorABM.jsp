<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="funciones.Funciones"%>
<%
	Funciones fun = new Funciones(request);
	String idForm = "Frm_ProveedorABM";
	String idGrilla = "ProveedorABM";
	String URL = "'./Frm_ProveedorABM'";
	String modo=(String) request.getAttribute("modo");
	String Proveedor=(String) request.getAttribute("Proveedor");
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
			<h5 class="modal-title" id="exampleModalLabel"><span id="Titulo"></span> Proveedor</h5>
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
						<input id="modo" class="form-control campo" type="hidden">
						<span class="form-control with-20-00">Nombre</span>
						<input id="prv_codig" class="form-control with-10-00 campo" type="number" maxlength="4">
						<input id="prv_nombr" class="form-control with-70-00 campo" type="text" maxlength="45">
					</div>
					<div class="fila">
						<span class="form-control with-20-00">Telefono</span>
						<input id="prv_telef" class="form-control with-30-00 campo" type="text" maxlength="30">
						<span class="form-control with-20-00">Celular</span>
						<input id="prv_celul" class="form-control with-30-00 campo" type="text" maxlength="30">
					</div>
					<div class="fila">
						<span class="form-control with-20-00">Direción</span>
						<input id="prv_direc" class="form-control with-80-00 campo" type="text" maxlength="60">
					</div>
					<div class="fila">				
						<span class="form-control with-20-00">Cond. de IVA</span>
						<select id="prv_cliva" class="form-control with-80-00 campo">
							<%=fun.GetHTMLOtion("iva_codig", "iva_nombr", "dbCondIva", "")%>
						</select>
					</div>
					<div class="fila">
						<span class="form-control with-20-00">Tipo de Doc.</span>
						<select id="prv_tpdoc" class="form-control with-30-00 campo">
							<%=fun.GetHTMLOtion("doc_codig", "doc_nombre", "dbTipoDocumentos", "")%>
						</select>		
						<span class="form-control with-20-00">Nro. Doc.</span>
						<input id="prv_nrdoc" class="form-control with-30-00 campo" type="text" maxlength="11">
					</div>
					<div class="fila">				
						<span class="form-control with-20-00">Mail</span>						
						<input id="prv_email" class="form-control with-80-00 campo" type="text" maxlength="80">
					</div><div class="fila">
						<!-- span class="form-control with-20-00">CBU</span>
						<input id="prv_nrocbu" class="form-control with-30-00 campo" type="text" maxlength="22"-->
						<span class="form-control with-17-00">Cond. de pagos</span>
						<select id="prv_condi" class="form-control with-18-00 campo">
							<%="<option value=\""+Funciones.Contado+"\">Contado</option><option value=\""+Funciones.CtaCorrienta+"\">Cta. Corriente</option>"%>	
						</select>					
						<span class="form-control with-10-00">Plazo</span>
						<input id="prv_plazo" class="form-control with-5-00 campo" type="text" maxlength="2">
					</div>
					<!-- div class="fila">			
						<span class="form-control with-30-00">Facturar a otra persona</span>	
						<input id="prv_fac" class="form-control with-5-00 campo" type="checkbox" style="margin: 6.5px 0px;">
						<span class="form-control with-50-00">Datos bancarios verificados 01/12/2017 (IJL)</span>
						<button id="prv_veri" class="form-control with-15-00 campo" type="button" value="veri" >
							verificar
						</button>
					</div-->
				</fieldset>
				<!-- fieldset id="facturacion">
	  				<legend>Datos de Facturación:</legend>
					<div class="fila">
						<span class="form-control with-20-00">Razon Social</span>
						<input id="prv_fnomb" class="form-control with-80-00 campo" type="text" maxlength="45">
					</div>
					<div class="fila">
						<span class="form-control with-20-00">Telefono</span>
						<input id="prv_ftele" class="form-control with-30-00 campo" type="text" maxlength="30">
						<span class="form-control with-20-00">Celular</span>
						<input id="prv_fcelu" class="form-control with-30-00 campo" type="text" maxlength="30">
					</div>
					<div class="fila">
						<span class="form-control with-20-00">Direción</span>
						<input id="prv_fdire" class="form-control with-80-00 campo" type="text" maxlength="60">	
					</div>
					<div class="fila">			
						<span class="form-control with-20-00">Cond. de IVA</span>
						<select id="prv_fciva" class="form-control with-80-00 campo">
							<%=fun.GetHTMLOtion("iva_codig", "iva_nombr", "dbCondIva", "")%>
						</select>
					</div>
					<div class="fila">
						<span class="form-control with-20-00">Tipo de Doc.</span>
						<select id="prv_ftdoc" class="form-control with-30-00 campo">
							<%=fun.GetHTMLOtion("doc_codig", "doc_nombre", "dbTipoDocumentos","")%>
						</select>	
						<span class="form-control with-20-00">Nro. Doc.</span>
						<input id="prv_fndoc" class="form-control with-30-00 campo" type="text" maxlength="11">
					</div>
				</fieldset-->
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
        	$("#modo",formulario).val("<%=modo%>");
        	formulario.modo="<%=modo%>";
        	<%=Proveedor%>
        	Proveedor.forEach(function(value,index){	
        		if (value=="true" || value=="false"){
        			$("#"+index,formulario).first().prop("checked",(value=="true"?true:false));            			
        		}else{
        			$("#"+index,formulario).first().val(value);
        		}	
        	});
        	
        	if ($("#prv_fac",formulario).is(":checked")){
				$("#facturacion",formulario).show();        				
				
			}else{
				$("#facturacion",formulario).hide();
			}
        	
        	var modoTitulo="";
        	switch(formulario.modo){
	        	case "CONS":
	        		modoTitulo="Consultar";	  
	        		$("#btn_confirmar",formulario).hide();
	        		$("input.campo",formulario).prop("readonly",true);
	        		$("select.campo",formulario).prop("disabled",true);
		        break;
	        	case "BAJA":
	        		modoTitulo="Eliminar";	
	        		$("input.campo",formulario).prop("readonly",true);
	        		$("select.campo",formulario).prop("disabled",true);
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
        	
        	$("#prv_fac",formulario).unbind("click").click(function(){
        			if ($(this).is(":checked")){
        				$("#facturacion",formulario).show();        				
        				
        			}else{
        				$("#facturacion",formulario).hide();
        				$("input,textarea",$("#facturacion",formulario)).val("");
        				$("select option",$("#facturacion",formulario)).removeAttr("selected");
        			}
        	});        	
        	
        	$("#btn_confirmar",formulario).unbind("prvck").click(function(){
        		if (validarprv()){
        			cargando();
				    $.ajax({
				    	data: $(".campo", formulario).serializeI(),
				    	type:'POST',
				    	url:"/<%=idForm%>", 
				    	success:function(data){		
				    		cerrarAlerta();//mensaje cargando
				    		data=JSON.parse(data);
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
        

    	
    	function validarprv(){
    		var formulario = $("#<%=idForm%>");    		
    		var res=true;
    		
    		if(res && $("#prv_nombr",formulario).val()==""){
    			mensaje="El nombre no puede quedar vacio.";
    			res=false;
    			$("#prv_nombr").abrirpopover(mensaje);
    		}
    		if(res && $("#prv_telef",formulario).val()==""){
    			mensaje="El telefono no puede quedar vacio.";
    			res=false;
    			$("#prv_telef").abrirpopover(mensaje);
    		}/*
    		if(res && $("#prv_celul",formulario).val()==""){
    			mensaje="no puede quedar vacio.";
    			res=false;
    			$("#prv_celul").abrirpopover(mensaje);
    		}
    		if(res && $("#prv_direc",formulario).val()==""){
    			mensaje="no puede quedar vacio.";
    			res=false;
    			$("#prv_direc").abrirpopover(mensaje);
    		}*/
    		if(res && $("#prv_cliva",formulario).val()==""){
    			mensaje="La condicion de IVA no puede quedar vacia.";
    			res=false;
    			$("#prv_condi").abrirpopover(mensaje);
    		}
    		if(res && $("#prv_tpdoc",formulario).val()==""){
    			mensaje="El tipo de Documento no puede quedar vacio.";
    			res=false;
    			$("#prv_tpdoc").abrirpopover(mensaje);
    		}
    		if(res && $("#prv_nrdoc",formulario).val()==""){
    			mensaje="El numero de Dcoumento no puede quedar vacio.";
    			res=false;
    			$("#prv_nrdoc").abrirpopover(mensaje);
    		}/*
    		if(res && $("#prv_email",formulario).val()==""){
    			mensaje="El email no puede quedar vacio.";
    			res=false;
    			$("#prv_email").abrirpopover(mensaje);
    		}
    		if(res && $("#prv_nrocbu",formulario).val()==""){
    			mensaje="El CBU no puede quedar vacio.";
    			res=false;
    			$("#prv_nrocbu").abrirpopover(mensaje);
    		}*/

    		if(res && $("#prv_condi",formulario).val()==""){
    			mensaje="Condicion de pago no puede quedar vacio.";
    			res=false;
    			$("#prv_condi").abrirpopover(mensaje);
    		}

    		if(res && $("#prv_plazo",formulario).val()=="" && $("#prv_condi",formulario).val()=="U"){
    			mensaje="Si se factura a cta. Corriente el plazo de pago no puede quedar vacio.";
    			res=false;
    			$("#prv_plazo").abrirpopover(mensaje);
    		}

    		if(false && res && $("prv_fnomb").val()==""){
    			if(res && $("prv_ftele").val()==""){
    				mensaje="El telefono no puede quedar vacio.";
    				res=false;
    				$("#prv_ftele").abrirpopover(mensaje);
    			}
    			/*if(res && $("prv_fcelu").val()==""){
    				mensaje="El cleular no puede quedar vacio.";
    				res=false;
    				$("#prv_fcelu").abrirpopover(mensaje);
    			}
    			if(res && $("prv_fdire").val()==""){
    				mensaje="La direccion no puede quedar vacia.";
    				res=false;
    				$("#prv_fdire").abrirpopover(mensaje);
    			}*/
    			if(res && $("prv_fciva").val()==""){
    				mensaje="La condicion de IVA no puede quedar vacia.";
    				res=false;
    				$("#prv_fciva").abrirpopover(mensaje);
    			}
    			if(res && $("prv_ftdoc").val()==""){
    				mensaje="El tipo de Documento no puede quedar vacio.";
    				res=false;
    				$("#prv_ftdoc").abrirpopover(mensaje);
    			}
    			if(res && $("prv_fndoc").val()==""){
    				mensaje="El numero de Dcoumento no puede quedar vacio.";
    				res=false;
    				$("#prv_fndoc").abrirpopover(mensaje);
    			}
    		}
    		return res;   		
    	}

	</script>
	
</div>