<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="funciones.Funciones"%>
<%
	Funciones fun = new Funciones(request);
	String idForm = "Frm_GrillaRemitos";
	String idGrilla = "GrillaRemitos";
	String URL = "'./Frm_GrillaRemitos'";
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
			<h3 style="margin: 0px;">Remitos</h3>
		</div>			
		<div class="tool tool-boton" data-modo="CONS">
			<img src="/img/iconos/glyphicons-28-search.png"
				style="width: auto; filter: invert(55%);">
			<div class="overlay">
				<div class="textimg">Consultar</div>
			</div>
		</div>
		<div class="tool tool-boton" data-modo="ALTA">
			<img src="/img/login.png" style="width: auto;padding: 3px;">
			<div class="overlay">
				<div class="textimg">Entrada</div>
			</div>
		</div>	
		<div class="tool tool-boton" data-modo="ALTA" data-tipo="S">
			<img src="/img/logout.png" style="width: auto;padding: 3px;">
			<div class="overlay">
				<div class="textimg">Salida</div>
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
			
		var idGrilla="<%=idGrilla%>";
        var NidGrilla = "#" + idGrilla;
        
        $(document).ready(function(){	        
	       	/* $("#<%=idForm%>").draggable();*/
	       Grilla();
	       	
	        $("#<%=idForm %>  .tool:not(:first-child)").click(function(){
	        	var obj=GetSelected();
	        	var cod=obj.cod;
	        	if(cod>0 || $(this).data("modo")=="ALTA"){
		        	cargando();
		        	var link= 'Frm_RemitoEABM';
		        	if($(this).data("modo")=="ALTA"){
		        		if($(this).data("tipo")=='S'){
		        			link= 'Frm_RemitoSABM';
		        		}else{
		        			link= 'Frm_RemitoEABM';
		        		}		        		
		        	}else{
		        		if(obj.tip=='S'){
		        			link= 'Frm_RemitoSABM';
		        		}else{
		        			link= 'Frm_RemitoEABM';
		        		}	
		        	}
		        	
					$.ajax({
						type:'GET',
						url: link,
						data: { modo: $(this).data("modo") , rem_codig: cod },
						success:function(data){     			
				    		cerrarAlerta();
							$("#<%=idForm%>").prepend($(data));  			      				
		        		}, 
		        		error:function(data){     			
				    		cerrarAlerta();
		        	    	console.log(data);
					    }
		        	});
	        	}
	        });		       	
        });
        
        function GetSelected(){
        	var id = $(NidGrilla).jqGrid('getGridParam','selrow');
        	var rem=new Object();
			if (id) {
				var ret = $(NidGrilla).jqGrid('getRowData',id);
				rem.cod = ret.rem_codig;
				rem.tip = ret.rem_tipor;
			}
        	return rem;
        }
        
        function Grilla(){	        
	        $(NidGrilla).jqGrid({
	        	url: <%=URL%>,
	        	datatype:"json",
	        	mtype:'GET', 
	        	colNames:['Codigo','Tipo','Cod','Nombre','Fecha','Condicion','Cantidad','Tipo de remito','Total'],
	        	colModel:[
	        		{name:'rem_codig', index:'rem_codig', width:15, hidden: false},
	        		{name:'rem_tipoI', index:'rem_tipoI', width:20, hidden: false},
	        		{name:'rem_codcl', index:'rem_codcl', width:20, hidden: false},
	        		{name:'cli_nombr', index:'cli_nombr', width:100,hidden: false},
	        		{name:'rem_fecha', index:'rem_fecha', width:40, hidden: false},
	        		{name:'rem_condi', index:'rem_condi', width:100,hidden: false},
	        		{name:'rem_canti', index:'rem_canti', width:100,hidden: false},
	        		{name:'rem_tipor', index:'rem_tipor', width:0  ,hidden: true},
	        		{name:'rem_total', index:'rem_total', width:40 ,hidden: false, align:'right'}],
	        	width: ($("#Cuerpo").width()-10),
	        	height: ($("#Cuerpo").height()-80),
	        	rowNum:'10',
	        	rowList:[10, 15, 20, 25, 50, 75, 100, 150, 200, 250, 500, 750],
	        	pager:NidGrilla + '_pie',
	        	sortname:'rem_fecha',
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
	        		
	        		if ($(NidGrilla + "_pie_left #jqgridSearchForm").length<=0){
						$("#jqgridSearchForm").remove();
						$(NidGrilla + "_pie_left").prepend(<% out.print(fun.buscadorGrilla(" Nombre", "cli_nombr")); %>);
						$(NidGrilla + "_pie_left #jqgridSearInput").bind('keydown', function(e) {			
							switch (e.which) {				
								case 13:
									$(NidGrilla).jqGrid('setGridParam',
									   { postData : { 
									     	BusquedaValor : $(NidGrilla + "_pie_left #jqgridSearInput").val(),
									     	BusquedaCampo : $(NidGrilla + "_pie_left #jqgridSearInput").data("field")
									   } 
									}).trigger(	"reloadGrid");						    
									break;				
							}
						});
						      
						$(NidGrilla + "_pie_left #jqgridSearInput").click( function() {			
							$(NidGrilla).jqGrid('setGridParam',
							   { postData : { 
							     	BusquedaValor : $(NidGrilla + "_pie_left #jqgridSearInput").val(),
							     	BusquedaCampo : $(NidGrilla + "_pie_left #jqgridSearInput").data("field")
							   } 
							}).trigger(	"reloadGrid");
						});
	        		}	        		
	        		
	        		if (!$(NidGrilla + "_pie_left #jqgridSearInput").is(":focus")) {
		        		$("tr.jqgrow.ui-row-ltr.ui-widget-content").first().trigger("click");
		        		$(NidGrilla).focus();	        			 
	        		}
	        	}, 
	        	ondblClickRow:function(id){
	        		$("#<%=idForm %>  .tool[data-modo='CONS']").first().click();
	        		/*var ret = $(NidGrilla).jqGrid('getRowData', id);
	        		$.each(Object.values(ret), function(i, val){
	        			$(".dato")[i].value = val;
	        		})*/
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
	      	  reSizeGrid("GrillaClientes",($("#Cuerpo").width()-10),($("#Cuerpo").height()-80));
	      	});
        }
	</script>
</div>