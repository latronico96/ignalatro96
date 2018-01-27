<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="funciones.Funciones"%>
<%
	Funciones fun = new Funciones(request);
	String idForm = "Frm_GrillaClientes";
	String idGrilla = "GrillaClientes";
	String URL = "'./Frm_GrillaClientes'";
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
			<h3 style="margin: 0px;">Clientes</h3>
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
</div>
<script type="text/javascript">
			
		var idGrilla="<%=idGrilla%>";
        var NidGrilla = "#" + idGrilla;
        
        $(document).ready(function(){	        
	       	/* $("#<%=idForm%>").draggable();*/
	       Grilla();
	       	
	        $("#<%=idForm %>  .tool:not(:first-child)").click(function(){
	        	var cod=GetSelected();
	        	cargando();
				$.ajax({
					type:'GET',
					url: 'Frm_ClienteABM',
					data: { modo: $(this).data("modo"), cli_codig: cod },
					success:function(data){     			
			    		cerrarAlerta();
						$("#<%=idForm%>").prepend($(data));  			      				
	        		}, 
	        		error:function(data){     			
			    		cerrarAlerta();
	        	    	console.log(data);
				    }
	        	});
	        });		       	
        });
        function GetSelected(){
        	var id = $(NidGrilla).jqGrid('getGridParam','selrow');
        	var cli=0;
			if (id) {
				var ret = $(NidGrilla).jqGrid('getRowData',id);
				cli = ret.cli_codig;
			}
        	return cli;
        }
        
        function Grilla(){	        
	        $(NidGrilla).jqGrid({
	        	url: <%=URL%>,
	        	datatype:"json",
	        	mtype:'GET', 
	        	colNames:['Compania','Cod.','Nombre','Telefono','Celular','Direcion','IVA','Documento','Plazo'],
	        	colModel:[
	        		{name:'cli_compa', index:'cli_compa', width:100, hidden:true},
	        		{name:'cli_codig', index:'cli_codig', width:30, hidden:false,  formatter:'FormatCliente'},
	        		{name:'cli_nombr', index:'cli_nombr', width:100, hidden:false},
	        		{name:'cli_telef', index:'cli_telef', width:60,hidden:false},
	        		{name:'cli_celul', index:'cli_celul', width:60,hidden:false},
	        		{name:'cli_direc', index:'cli_direc', width:100,hidden:false},
	        		{name:'iva_nombr', index:'iva_nombr', width:60,hidden:false},
	        		{name:'cli_nrdoc', index:'cli_nrdoc', width:80,hidden:false},
	        		{name:'cli_plazo', index:'cli_plazo', width:20,hidden:false, align:'right'}],
	        	width: ($("#Cuerpo").width()-10),
	        	height: ($("#Cuerpo").height()-80),
	        	rowNum:'10',
	        	rowList:[10, 15, 20, 25, 50, 75, 100, 150, 200, 250, 500, 750],
	        	pager:NidGrilla + '_pie',
	        	sortname:'cli_codig',
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
	        		$("#jqgridSearchForm").remove();
	        		$(NidGrilla + "_pie_left").prepend(<%out.println(fun.buscadorGrilla("nombre", "cli_nombr"));%>);
	        		$("tr.jqgrow.ui-row-ltr.ui-widget-content").first().trigger("click");
	        		$(NidGrilla).focus();
	        	}, 
	        	ondblClickRow:function(id){
	        		var ret = $(NidGrilla).jqGrid('getRowData', id);
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
	        $( window ).resize(function(){  
	      	  reSizeGrid("GrillaClientes",($("#Cuerpo").width()-10),($("#Cuerpo").height()-80));
	      	});
        }
	</script>
</div>