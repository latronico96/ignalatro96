<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="funciones.Funciones"%>
<%
	Funciones fun = new Funciones(request);
	String idForm = "Rpt_StockHoy";
	String idGrilla = "StockHoy";
	String URL = "'./Rpt_StockHoy'";
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

#<%=
idForm %> >div {
	width: 720px;
	margin-top: 20px;
}
</style>
	<div class="modal" data-tmodal="alerta">
		<div class="modal-header">
			<h5 class="modal-title" id="exampleModalLabel">
				<span id="Titulo"></span> Informe Stock Hoy
			</h5>
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
						<input id="sin" type="checkbox" name="filtro" value="0"
							class="form-control with-20-00 campo"> Sin Stock </input>
					</div>
					<div class="fila">
						<input id="poc" type="checkbox" name="filtro" value="2"
							class="form-control with-20-00 campo"> Con poco stock </input>
					</div>
					<div class="fila">
						<input id="con" type="checkbox" name="filtro" value="1"
							class="form-control with-20-00 campo"> Con stock </input>
					</div>
				</fieldset>
			</div>
		</div>
		<div class="modal-footer">
			<button id="btn_confirmar" class="btn btn-primary" type="button"
				style="margin-left: 10px; float: right;">Confirmar</button>
			<button id="btncancelar" class="btn btn-danger" type="button"
				style="float: right;" onclick="cerrarFormu('<%=idForm%>');">salir</button>
		</div>
	</div>

	<script type="text/javascript">    
		formulario = $.fn.extend($(<%="\"#"+idForm+"\""%>), {
	   		idGrilla:"<%=idGrilla%>",
	   		NidGrilla: "#" + "<%=idGrilla%>"
	   	});
		
        $(document).ready(function(){	
        	$(".modal",formulario).draggable();
        	formulario.show();   
        	
        	$("#btn_confirmar",formulario).unbind("click").click(function(){        		
        			bloquear(true);
        			var bloqueo=document.getElementById("bloqueoAlerta");
        			bloqueo.innerHTML="<div style=\"float:right;padding: 0;\"><button type=\"button\" class=\"btn btn-default btn-Salir\" style=\"z-index:500;float: right;margin: 5px;\" data-dismiss=\"modal\"  onclick=\"bloquear(false);teclaEsc();\" data-toggle=\"tooltip\" data-placement=\"bottom\" title=\"Salir\">X</button></div>";
        			var div = document.createElement("div");
        			$(div).css("margin","10px auto");
        			$(div).css("width","93%");
        			$(div).css("height","94%");
        			var pdf = document.createElement("EMBED");
        			pdf.type="application/pdf";
        		    pdf.id="pdfDocument";
        		    pdf.width="100%";
        		    pdf.height="100%";
        		    var parametros=[];
        			$("input:checkbox[name=filtro]:checked").each(function(){
        				parametros.push( parseInt($(this).val()));
        			});
        			parametros=parametros.toString();
        			pdf.src="/<%=idForm%>?filtro="+parametros;
        			div.appendChild(pdf);
        			bloqueo.appendChild(div);
        			
        			$("#alertmsg").css("z-index","2");  			
        			
        			/*pdf.addEventListener('load', function()
        					{
        					    // Operate upon the SVG DOM here
        						cerrarFormu('<%=idForm%>');
        					},false);*/  	 
        	}); 
        });
	</script>
</div>