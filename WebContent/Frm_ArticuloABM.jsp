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
			<h5 class="modal-title" id="exampleModalLabel"><spam id="Titulo"></spam> Artículo</h5>
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
						<%=fun.input("modo","form-control campo","","hidden","")%>
						<%=fun.input("art_compa","form-control campo","","hidden","")%>
						<spam class="form-control with-20-00">Nombre</spam>
						<%=fun.input("art_codig","form-control with-10-00 campo","","number"," maxlength=\"4\"")%>
						<%=fun.input("art_nombr","form-control with-70-00 campo","","text"," maxlength=\"45\"")%>
					</div>
					<div class="fila">				
						<spam class="form-control with-20-00">Marca</spam>
						<%=fun.select("art_marca", "form-control with-80-00 campo", "", "",
										fun.GetHTMLOtion("mar_codig", "mar_nombr", "dbMarcas", "mar_compa",""), "")%>
					</div>
					<div class="fila">
						<spam class="form-control with-20-00">Neto</spam>	
						<%=fun.input("art_pneto","form-control with-20-00 campo precio","","text","")%>	
						<spam class="form-control with-20-00" style="padding-left: 10px;">Final</spam>
						<%=fun.input("art_final","form-control with-20-00 campo precio","","text","")%>
						<spam class="form-control with-10-00" style="padding-left: 10px;">Activo</spam>
						<%=fun.input("art_activ","form-control with-10-00 campo","margin: 5.5px 0px;","checkbox"," ")%>
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