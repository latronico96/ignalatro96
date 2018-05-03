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
						<span class="form-control with-10-00">Nombre</span>
						<input id="art_codig" class="form-control with-10-00 campo" type="number" maxlength="4">
						<input id="art_nombr" class="form-control with-70-00 campo" type="text" maxlength="45">
					</div>
					<div class="fila">				
						<span class="form-control with-10-00">Marca</span>
						<select id="art_marca" class="form-control with-20-00 campo">
							<%=fun.GetHTMLOtion("mar_codig", "mar_nombr", "dbMarcas","") %>
						</select>
						<span class="form-control with-10-00">C. Barra</span>
						<input id="art_codbr" class="form-control with-20-00 campo" type="text" maxlength="13">
						<span class="form-control with-10-00">Stk. min</span>
						<input id="art_stmin" class="form-control with-20-00 campo" type="text" maxlength="7">
					</div>
					<div class="fila">
						<span class="form-control with-10-00">Costo</span>							
						<input id="art_costo" class="form-control with-20-00 campo precio" type="text">	
						<span class="form-control with-10-00">$ Menor</span>							
						<input id="art_pmeno" class="form-control with-20-00 campo precio" type="text">	
						<span class="form-control with-10-00" >$ Mayor</span>
						<input id="art_pmayo" class="form-control with-20-00 campo precio" type="text">
					</div>
					<div class="fila">
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
	formulario = $.fn.extend($(<%="\"#"+idForm+"\""%>), {
   		idGrilla:"<%=idGrilla%>",
   		NidGrilla: "#" + "<%=idGrilla%>",
		modo: "<%=modo%>",
		validarArt: function (){
    		var formulario = $("#<%=idForm%>");    		
    		var res=true;
    		
    		$("#art_codbr",formulario).val(($("#art_codbr",formulario).val()==0?"":fillZero($("#art_codbr",formulario).val().toString().trim(), 13)));
    		
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
    		if(res && $("#art_costo",formulario).val()=="0.00"){
    			mensaje="El costo neto no puede ser cero.";
    			res=false;
    			$("#art_pneto").abrirpopover(mensaje);
    		}
    		if(res && $("#art_pmayo",formulario).val()=="0.00"){
    			mensaje="El precio al mayor neto no puede ser cero.";
    			res=false;
    			$("#art_pmayo").abrirpopover(mensaje);
    		}
    		if(res && $("#art_pmeno",formulario).val()=="0.00"){
    			mensaje="El precio al menor no puede quedar vacio.";
    			res=false;
    			$("#art_pmeno").abrirpopover(mensaje);
    		}
    		return res;   		
    	}
   	});
        $(document).ready(function(){	 		
        	$("#modo",formulario).val(formulario.modo);
        	<%=Articulo%>
        	Articulo.forEach(function(value,index){	        		
        		if($("#"+index,formulario).first().attr("type")=="checkbox"){
        			console.log("#"+index +" "+value);
        			$("#"+index,formulario).first().prop("checked",(value!="" && value!="0" ));	
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
        	
        	$("#art_codbr",formulario).unbind("change").change(function(){ 
        		$(this).val(fillZero($(this).val().toString().trim(), 13));
        	});
   	
        	
        	$("#btn_confirmar",formulario).unbind("click").click(function(){
        		if (formulario.validarArt()){
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
        

    	

	</script>
	
</div>