<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="funciones.Funciones"%>
<%
	Funciones fun = new Funciones(request);
	String idForm = "Frm_ArticuloABM";
	String idGrilla = "ArticuloABM";
	String URL = "'./Frm_ArticuloABM'";
	String modo=(String) request.getAttribute("modo");
	String Articulo=(String) request.getAttribute("Articulo");
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
			<h5 class="modal-title" id="exampleModalLabel"><span id="Titulo"></span> Artículo</h5>
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
						<input id="modo" class="form-control campo"type="hidden" >					
						<span class="form-control with-20-00">Nombre</span>
						<input id="art_codig" class="form-control with-10-00 campo" type="number" maxlength="4">
						<input id="art_nombr" class="form-control with-70-00 campo" type="text" maxlength="45">
					</div>
					<div class="fila">				
						<span class="form-control with-20-00">Marca</span>
						<select id="art_marca" class="form-control with-80-00 campo">
							<%=fun.GetHTMLOtion("mar_codig", "mar_nombr", "dbMarcas","") %>
						</select>
					</div>
					<div class="fila">
						<span class="form-control with-20-00">Neto</span>							
						<input id="art_pneto" class="form-control with-20-00 campo precio" type="text">	
						<span class="form-control with-20-00" style="padding-left: 10px;">Final</span>
						<input id="art_final" class="form-control with-20-00 campo precio" type="text">
						<span class="form-control with-10-00" style="padding-left: 10px;">Activo</span>
						<input id="art_activ" class="form-control with-10-00 campo" style="margin: 5.5px 0px;" type="checkbox">
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
        	$("#modo",formulario).val("<%=modo%>");
        	formulario.modo="<%=modo%>";
        	<%=Articulo%>
        	Articulo.forEach(function(value,index){	
        		if (value=="true" || value=="false"){
        			$("#"+index,formulario).first().prop("checked",(value=="true"?true:false));            			
        		}else{
        			$("#"+index,formulario).first().val(value);
        		}	
        	});
        	
        	$(".precio",formulario).priceFormat({
        	    clearPrefix: true,
        	    clearSuffix: true,
        	    prefix: '$ ',
        	    suffix: '',
        	    limit: 9,
        	    centsLimit: 2,
        	    centsSeparator: '.',
        	    thousandsSeparator: ','
        	});
        	
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
   	
        	
        	$("#btn_confirmar",formulario).unbind("click").click(function(){
        		if (validarArt()){
        			cargando();
				    $.ajax({
				    	dataType:'json',
				    	data: $(".campo", formulario).serializeI(),
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
        

    	
    	function validarArt(){
    		var formulario = $("#<%=idForm%>");    		
    		var res=true;
    		
    		if(res && $("#art_nombr",formulario).val()==""){
    			mensaje="El nombre no puede quedar vacio.";
    			res=false;
    			$("#art_nombr").abrirpopover(mensaje);
    		}
    		if(res && $("#art_marca",formulario).val()==""){
    			mensaje="La marca no puede quedar vacia.";
    			res=false;
    			$("#art_marca").abrirpopover(mensaje);
    		}
    		if(res && $("#art_pneto",formulario).val()=="0.00"){
    			mensaje="El precio neto no puede ser cero.";
    			res=false;
    			$("#art_pneto").abrirpopover(mensaje);
    		}
    		if(res && $("#art_final",formulario).val()=="0.00"){
    			mensaje="El precio final no puede quedar vacio.";
    			res=false;
    			$("#art_final").abrirpopover(mensaje);
    		}
    		return res;   		
    	}

	</script>
	
</div>