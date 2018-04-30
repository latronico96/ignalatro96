<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="funciones.Funciones"%>
<%
	Funciones fun = new Funciones(request);
	String idForm = "Frm_GrillaProveedores";
	String idGrilla = "GrillaProveedores";
	String URL = "'./Frm_GrillaProveedores'";
%>
<div id="<%=idForm%>" class="formulario">
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
		
		#<%=idForm %> >div {
			width: 100%;
			margin-top: 1px;
		}
		
		#<%=idForm %> > h3>img {
			background-color: #ffffff;
		}
		
		#<%=idForm %> {
			width: 100%;
		}
		
		#<%=idForm %>  .tool:not(:first-child) {
		    cursor: pointer;
		    border-right: solid #fff 1px;
		}
	</style>
	<div class="fila negro T-blanco rounded" style="height: 40px;padding: 4px 10px;">
		<div class="tool">
			<h3 style="margin: 0px;">Proveedores</h3>
		</div>			
		<div class="tool tool-boton" data-modo="CONS">
			<img src="/img/iconos/glyphicons-28-search.png"
				style="width: auto; filter: invert(55%);">
			<div class="overlay">
				<div class="textimg">Consultar</div>
			</div>
		</div>
		<div class="tool tool-boton" data-modo="ALTA">
			<img src="/img/iconos/glyphicons-433-plus.png"
				style="width: auto; filter: invert(55%);">
			<div class="overlay">
				<div class="textimg">Crear</div>
			</div>
		</div>
		<div class="tool tool-boton" data-modo="MODI">
			<img src="/img/iconos/glyphicons-31-pencil.png"
				style="width: auto; filter: invert(55%);">
			<div class="overlay">
				<div class="textimg">Modificar</div>
			</div>
		</div>
		<div class="tool tool-boton" data-modo="BAJA">
			<img src="/img/iconos/glyphicons-208-remove.png"
				style="width: auto; filter: invert(55%);">
			<div class="overlay">
				<div class="textimg">Eliminar</div>
			</div>
		</div>
	</div>

	<div class="d-block">
		<table id="<%=idGrilla%>"></table>
		<div id="<%=idGrilla%>_pie"></div>
	</div>
<script type="text/javascript">
	formulario = $.fn.extend($(<%="\"#"+idForm+"\""%>), {
		idGrilla:"<%=idGrilla%>",
		NidGrilla: "#" + "<%=idGrilla%>",
		modoGrilla:"ALTA",
		GetSelected: function (){
        	var id = $(formulario.NidGrilla).jqGrid('getGridParam','selrow');
        	var prv=0;
			if (id) {
				var ret = $(formulario.NidGrilla).jqGrid('getRowData',id);
				prv = ret.prv_codig;
			}
        	return prv;
        },
        Grilla: function (){	        
	        $(formulario.NidGrilla).jqGrid({
	        	url: <%=URL%>,
	        	datatype:"json",
	        	mtype:'GET', 
	        	colNames:['Cod.','Nombre','Telefono','Celular','Direcion','IVA','Documento','Plazo'],
	        	colModel:[
	        		{name:'prv_codig', index:'prv_codig', width:30, hidden:false,  formatter:'FormatClient'},
	        		{name:'prv_nombr', index:'prv_nombr', width:100, hidden:false},
	        		{name:'prv_telef', index:'prv_telef', width:60,hidden:false},
	        		{name:'prv_celul', index:'prv_celul', width:60,hidden:false},
	        		{name:'prv_direc', index:'prv_direc', width:100,hidden:false},
	        		{name:'iva_nombr', index:'iva_nombr', width:60,hidden:false},
	        		{name:'prv_nrdoc', index:'prv_nrdoc', width:80,hidden:false},
	        		{name:'prv_plazo', index:'prv_plazo', width:20,hidden:false, align:'right'}],
	        	width: ($("#Cuerpo").width()-10),
	        	height: ($("#Cuerpo").height()-80),
	        	rowNum:'100',
	        	rowList:[10, 15, 20, 25, 50, 75, 100, 150, 200, 250, 500, 750],
	        	pager:formulario.NidGrilla + '_pie',
	        	sortname:'prv_codig',
	        	viewrecords:true,
	        	sortorder:"asc",
	        	hidegrid:false,
	        	title:false,
	        	gridComplete:function(){
		        	
	        		$('tbody [role="row"]',formulario).each(function(id, val){
	        			if(id % 2 == 0){
	        				$(formulario.NidGrilla + ' #' + id).css('background-color', 'rgb(224, 224, 224)');
	        			}
	        		});
	        		
	        		if ($(formulario.NidGrilla + "_pie_left #jqgridSearchForm").length<=0){
						$("#jqgridSearchForm",formulario).remove();
						$(formulario.NidGrilla + "_pie_left").prepend(<% out.print(fun.buscadorGrilla(" Nombre", "prv_nombr")); %>);
						$(formulario.NidGrilla + "_pie_left #jqgridSearInput").bind('keydown', function(e) {			
							switch (e.which) {				
								case 13:
									$(formulario.NidGrilla).jqGrid('setGridParam',
									   { postData : { 
									     	BusquedaValor : $(formulario.NidGrilla + "_pie_left #jqgridSearInput").val(),
									     	BusquedaCampo : $(formulario.NidGrilla + "_pie_left #jqgridSearInput").data("field")
									   } 
									}).trigger(	"reloadGrid");						    
									break;				
							}
						});
						      
						$(formulario.NidGrilla + "_pie_left #jqgridSearInput").click( function() {			
							$(formulario.NidGrilla).jqGrid('setGridParam',
							   { postData : { 
							     	BusquedaValor : $(formulario.NidGrilla + "_pie_left #jqgridSearInput").val(),
							     	BusquedaCampo : $(formulario.NidGrilla + "_pie_left #jqgridSearInput").data("field")
							   } 
							}).trigger(	"reloadGrid");
						});
	        		}	        		
	        		
	        		if (!$(formulario.NidGrilla + "_pie_left #jqgridSearInput").is(":focus")) {
		        		$("tr.jqgrow.ui-row-ltr.ui-widget-content",formulario).first().trigger("click");
		        		$(formulario.NidGrilla).focus();	        			 
	        		}
	        	}, 
	        	ondblClickRow:function(id){
	        		var ret = $(formulario.NidGrilla).jqGrid('getRowData', id);
	        		$.each(Object.values(ret), function(i, val){
	        			$(".dato")[i].value = val;
	        		})
	        	},
	        	loadBeforeSend: function () {
	        		var x=this;	        	
	        	    $(this).closest("div.ui-jqgrid-view").find("table.ui-jqgrid-htable>thead>tr>th").each(function(index, elem){
	        	    	$(elem).css("text-align", (x.p.colModel[index].align===undefined? "left" : x.p.colModel[index].align));
	        	    });
	        	},
	        	caption:""
	        });
	        $(".ui-jqgrid-titlebar").hide();	 
	        $( document ).resize(function(){  
	      	  reSizeGrid(formulario.idGrilla,($("#Cuerpo").width()-10),($("#Cuerpo").height()-80));
	      	});
        }
        
	});
    
        
        $(document).ready(function(){	        
	       formulario.Grilla();
	       	
	        $("#<%=idForm %>  .tool:not(:first-child)").click(function(){
	        	var parametros=$(this).data();
				parametros.url='Frm_ProveedorABM';
				parametros.parametros={ modo: $(this).data("modo"), prv_codig: formulario.GetSelected() };
				abrirFormulario(parametros);					
	        });		       	
        });


	</script>
</div>