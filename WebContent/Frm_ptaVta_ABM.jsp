<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="funciones.Funciones"%>
<%
	Funciones fun = new Funciones();
	String idGrilla = "Frm_ptaVta_ABM_Grilla";
	String URL = "'./Frm_ptaVta_ABM'";
%>

<div id="Frm_ptaVta_ABM" data-popup="true" class="backmodal formulario">
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
		
		#jqgridSearchForm {
			position: relative;
			-moz-box-sizing: content-box;
			-webkit-box-sizing: content-box;
			box-sizing: content-box;
			margin: 0px auto;
			width: 100%;
			z-index: 1;
		}
		
		#Frm_ptaVta_ABM>div {
			width: 720px;
			margin-top: 20px;
		}
	</style>

	<div class="modal" data-tmodal="alerta">
		<div class="modal-header">
			<h5 class="modal-title" id="exampleModalLabel">Administración de
				Puntos de Venta</h5>
			<button type="button" type="button" class="close"
				onclick="cerrarFormu('Frm_ptaVta_ABM');">
				<span aria-hidden="true">&times;</span>
			</button>
		</div>
		<div class="modal-body">
			<div class="d-block">
				<table id="<%=idGrilla%>"></table>
				<div id="<%=idGrilla%>_pie"></div>
			</div>
		</div>
		<div class="modal-footer">
			<button type="button" class="btn btn-primary">Guardar Cambios</button>
			<button type="button" class="btn btn-secondary" data-dismiss="modal" onclick="cerrarFormu('Frm_ptaVta_ABM');">Cerrar</button>
		</div>
	</div>

	<script type="text/javascript">
		stringFrom="<div id=\"form\">\n"+
			<%out.println(fun.buttonString("btn_rev", "form-control ", "width:20px; height: 18px; padding: 1px;", "button",
					"se apreto", "<img src=\"/img/iconos/glyphicons-208-remove.png\" style=\"width: 16px; \">", ""));%> +
			<%out.println(
					fun.inputString("iva_codig", "form-control dato", "width:101px;", "text", "placeholder=\"Codigo\""));%> +
			<%out.println(fun.inputString("iva_nombr", "form-control dato", "width:394px;", "text",
					"placeholder=\"Nombre\""));%> +
			<%out.println(fun.inputString("iva_diiva", "form-control dato", "width:127px;", "text",
					"placeholder=\"Discirmina iva\""));%> +
			<%out.println(fun.buttonString("btn_act", "form-control ", "width:14px; height: 18px;  padding: 1px;", "button",
					"se apreto", "<img src=\"/img/iconos/check.svg\" style=\"width: 16px; \">", ""));%> +
			"</div>";
			
		var idGrilla="<%=idGrilla%>";
        var NidGrilla = "#" + idGrilla;
        
        $(document).ready(function(){	        
	        $("#Frm_ptaVta_ABM").draggable();
	        Grilla();
        });
        
        function Grilla(){	        
	        $(NidGrilla).jqGrid({
	        	url: <%=URL%>,
	        	datatype:"json",
	        	mtype:'POST', 
	        	colNames:['iva_codig', 'iva_nombr', 'iva_diiva'],
	        	colModel:[
	        		{name:'iva_codig', index:'iva_codig', width:100},
	        		{name:'iva_nombr', index:'iva_nombr', width:300},
	        		{name:'iva_diiva', index:'iva_diiva', width:100}],
	        	width:700,
	        	height:500,
	        	rowNum:'10',
	        	rowList:[10, 15, 20, 25, 50, 75, 100, 150, 200, 250, 500, 750],
	        	pager:NidGrilla + '_pie',
	        	sortname:'iva_codig',
	        	viewrecords:true,
	        	sortorder:"desc",
	        	hidegrid:false,
	        	title:false,
	        	gridComplete:function(){
	        		$('tbody [role="row"]').each(function(id, val){
	        			if(id % 2 == 0){
	        				$(NidGrilla + ' #' + id).css('background-color', 'rgb(224, 224, 224)');
	        			}
	        		});
	        		$("#form").remove();
	        		$(".ui-jqgrid-bdiv").prepend(stringFrom);
	        		$("#btn_rev").unbind("click");
	        		$("#btn_rev").click(function(){
	        			$(".dato").val("");
	        		});
	        		$("#btn_act").unbind("click");
	        		$("#btn_act").click(function(){
	        			$.ajax({
	        				dataType:'json',
	        				data:$('.dato').serialize(),
	        				type:'GET',
	        				url:idGrilla,
	        				success:function(data){
	        					console.log(data);
								if(data.error == 0){
									$(NidGrilla).trigger('reloadGrid');
								}
							}, 
							error:function(data){
				            	console.log(data);
					        }
						});
	        		});
	        		$("#jqgridSearchForm").remove();
	        		$(NidGrilla + "_pie_left").prepend(<%out.println(fun.buscadorGrilla("nombre", "iva_nombr"));%>);
	        		$("tr.jqgrow.ui-row-ltr.ui-widget-content").first().trigger("click");
	        		$(NidGrilla).focus();
	        	}, 
	        	ondblClickRow:function(id){
	        		var ret = $(NidGrilla).jqGrid('getRowData', id);
	        		$.each(Object.values(ret), function(i, val){
	        			$(".dato")[i].value = val;
	        		})
	        	},
	        	caption:""
	        });
	        $(".ui-jqgrid-titlebar").hide();	        
        }
	</script>
	
</div>