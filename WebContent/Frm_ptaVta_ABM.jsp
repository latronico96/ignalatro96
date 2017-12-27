<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="funciones.Funciones"%>
<%
	Funciones fun = new Funciones();
	String idGrilla = "Frm_ptaVta_ABM";
%>
<!DOCTYPE html>
<html lang="es">
<head>
<meta charset="utf-8" />
<title>Prueba 29/10/2017</title>
<link rel="stylesheet" href="css/bootstrap.css">
<link rel="stylesheet" href="css/pisaBootstrap.css">
<link rel="stylesheet" href="css/general.css">
<style type="text/css">
	#form{
		position: relative;
		-moz-box-sizing: content-box;
		-webkit-box-sizing: content-box;
		box-sizing: content-box;
		margin: 0px auto;
		width: 100%;
		z-index: 1;
	}
	
	#jqgridSearchForm{
		position: relative;
		-moz-box-sizing: content-box;
		-webkit-box-sizing: content-box;
		box-sizing: content-box;
		margin: 0px auto;
		width: 100%;
		z-index: 1;
	}
</style>
<script type="text/javascript" src="js/jquery-3.2.1.js"></script>
<script type="text/javascript" src="js/popper.js"></script>
<script type="text/javascript" src="js/bootstrap.js"></script>
<script type="text/javascript" src="js/datepickers.js"></script>
<script type="text/javascript" src="js/jquery.jqGrid.min.js"></script>
<script type="text/javascript" src="js/i18n/grid.locale-es.js"></script>
<script>
stringFrom="<div id=\"form\">\n"+
			<% out.println(fun.buttonString("btn_rev",  "form-control ", "width:19px;height: 22.5px;", "button", "se apreto", "<img src=\"/img/iconos/glyphicons-208-remove.png\">","")); %> +
			<% out.println(fun.inputString("iva_codig", "form-control dato", "width:80px;", "text", "placeholder=\"Codigo\"")); %> +
			<% out.println(fun.inputString("iva_nombr", "form-control dato", "width:300px;", "text", "placeholder=\"Nombre\"")); %> +
			<% out.println(fun.inputString("iva_diiva", "form-control dato", "width:100px;", "text", "placeholder=\"Discirmina iva\"")); %> +
			<% out.println(fun.buttonString("btn_act",  "form-control ", "width:20px;height: 22.5px;", "button", "se apreto", "<img src=\"/img/iconos/check.svg\">", "" )); %> +
			"</div>";
var idGrilla="<%=idGrilla%>";
var NidGrilla="#"+idGrilla;
        $(document).ready(function(){
        	$('#exampleModal').modal('show');
        	$("#exampleModal" ).draggable();
        	Grilla();
		});
        function Grilla() {
        	
        	$(NidGrilla).jqGrid({
        		url : "./"+idGrilla,
        		datatype : "json",
        		mtype : 'POST',
        		colNames : ['iva_codig',
        			'iva_nombr',
        			'iva_diiva'],
        		colModel : [
        			{name : 'iva_codig', index : 'iva_codig', width : 100 },
        			{name : 'iva_nombr', index : 'iva_nombr', width : 300 },
        			{name : 'iva_diiva', index : 'iva_diiva', width : 100 } ],
        		width : 520,
        		height : 500,
        		rowNum : '10',
        		rowList : [
        				10, 15, 20, 25, 50, 75, 100, 150, 200, 250, 500, 750 ],
        		pager : NidGrilla+'_pie',
        		sortname : 'iva_codig',
        		viewrecords : true,
        		sortorder : "desc",
        		hidegrid : false,
        		title : false,
        		/*dataEvents:  $("#grillaTraficos").bind('keydown',function(e) {					
        							var TeclasPer = "abcdefghijklmnñopqrstuvwxyzABCDEFGHIJKLMNÑOPQRSTUVWXYZ1234567890., ";
        							switch(e.which) {											
        								case 116://[F5]			
        									$("#Atra").click();
        									return false;
        								break;											
        								case 117://[F6]			
        									$("#Mtra").click();
        									return false;
        								break;
        								case 118://[F7]			
        									$("#Ctra").click();
        									return false;
        								break;		
        								case 119://[F8]			
        									$("#Btra").click();
        									return false;
        								break;
        								default:
        									if ((TeclasPer.search(e.key) >= 0) || (e.which == 8)) {
        										$("#BusquedaValor").focus();
        									}	LL
        								break;											
        							}												
        		}),*/
        		gridComplete: function (){ 
        			$('tbody [role="row"]').each(function(id,val){ if(id%2==0){ 
        						$(NidGrilla+' #'+id).css('background-color','rgb(224, 224, 224)');
        			}});
        			$("#form").remove();
        			$(".ui-jqgrid-bdiv").prepend(stringFrom);
        			$("#btn_rev").unbind("click");
        			$("#btn_rev").click(function(){$(".dato").val("");});
        			
        			$("#btn_act").unbind("click");
        			$("#btn_act").click(function(){
        		        $.ajax({
        		            dataType: 'json',
        		            data: $('.dato').serialize(),
        		            type: 'GET',
        		            url: idGrilla,
        		            success: function(data){
        		            	console.log(data);
        		            	if(data.error==0){
        		            		$(NidGrilla).trigger( 'reloadGrid' );	
        		            	}
                            },
        		            error:  function(data){
        		            	console.log(data);
	                            
                            }
        		        });

        			});

        			$("#jqgridSearchForm").remove();
        			$(NidGrilla+"_pie_left").prepend(<% out.println(fun.buscadorGrilla("nombre","iva_nombr")); %>);        			
        			$("tr.jqgrow.ui-row-ltr.ui-widget-content").first().trigger( "click");
        			$(NidGrilla).focus(); 
        							
        		},
        		ondblClickRow : function(id) {
        			var ret = $(NidGrilla).jqGrid('getRowData', id);        			
        			$.each(Object.values(ret),function(i,val){$(".dato")[i].value=val;})
        			        			
        		},
        		caption : ""
        	});
        	
        	$(".ui-jqgrid-titlebar").hide();
        	
        	
        }
</script>
</head>
<body style="height: 100vh;">

	<div class="modal fade" id="exampleModal" tabindex="-1" role="dialog"
		aria-labelledby="exampleModalLabel" aria-hidden="true">
		<div class="modal-dialog" role="document">
			<div class="modal-content">
				<div class="modal-header">
					<h5 class="modal-title" id="exampleModalLabel">Administración
						de Puntos de Venta</h5>
					<button type="button" class="close" data-dismiss="modal"
						aria-label="Close">
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
					<button type="button" class="btn btn-secondary"
						data-dismiss="modal">Cerrar</button>
					<button type="button" class="btn btn-primary">Guardar
						Cambios</button>
				</div>
			</div>
		</div>
	</div>

</body>
</html>