<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="funciones.Funciones"%>

<%@page import="java.sql.Connection"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>
<%
	Funciones fun = new Funciones(request);
	String idForm = "Frm_GrillaArticulos";
	String idGrilla = "GrillaArticulos";
	String URL = "'./Frm_GrillaArticulos'";
	
	String optionMarca="<option value='0'>Todos</option>";
	
	String optionModelos="<option value='0' data-marca='0'>Todos</option>";			

	try{
		Connection cn=fun.Conectar();
		Statement st=cn.createStatement();
		ResultSet rs=st.executeQuery("select * from dbMarcas order by mar_nombr");
		while(rs.next()){
			optionMarca+="<option value='"+rs.getString("mar_codig")+"'>"+rs.getString("mar_nombr")+"</option>";		
		}
		rs.close();
		st.close();
		
		st=cn.createStatement();
		rs=st.executeQuery("select * from dbautos");
		while(rs.next()){
			optionModelos+="<option value='"+rs.getString("aut_codig")+"' data-marca='"+rs.getString("aut_marca")+"'>"+rs.getString("aut_nombr")+"</option>";
		}
		rs.close();
		st.close();
	}catch(Exception e){

	}
		
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

#<%=
idForm %> >div {
	width: 100%;
	margin-top: 1px;
}

#<%=
idForm %> > h3>img {
	background-color: #ffffff;
}

#<%=idForm%>
{
width:100%;
}

#<%=idForm %> .tool:not (:first-child ) {
	cursor: pointer;
	border-right: solid #fff 1px;
}

#<%=
idForm %> label {
	padding: 0px 15px;
}

</style>
	<div class="fila negro T-blanco rounded"
		style="height: 40px; padding: 4px 10px;">
		<div class="tool">
			<h3 style="margin: 0px;">Artículos</h3>
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
	<div class="fila negro rounded" style="padding: 6px 0px 0px 0px;">
		<label class="float-left with-7-00 T-blanco">Artículo</label>
		<select class="form-control with-15-00 filtro" id="aut_marca"><%=optionMarca %></select>
		<select class="form-control with-15-00 filtro" id="aut_nauto"><%=optionModelos %></select>
		<input class="form-control with-15-00 filtro" id="mod_nombr1" type="text">
		<input class="form-control with-15-00 filtro" id="mod_nombr2" type="text">
		<input class="form-control with-15-00 filtro" id="mod_nombr3" type="text">
		<label class="float-left with-2-00 T-blanco">O</label>
		<input class="form-control filtro with-2-00 " id="mod_nombr5" type="radio" name="operador" value="OR" checked="checked" style="top: 7px;">
		<label class="float-left with-2-00 T-blanco">Y</label>
		<input class="form-control filtro with-2-00 " id="mod_nombr4" type="radio" name="operador" value="AND" style="top: 7px;">
		<button class="form-control with-7-00 btn" onclick="formulario.ActualizarParametros();">Actulizar</button>
	</div>
	<div class="d-block">
		<table id="<%=idGrilla%>"></table>
		<div id="<%=idGrilla%>_pie"></div>
	</div>
	<script type="text/javascript">
	formulario = $.fn.extend($(<%="\"#"+idForm+"\""%>), {
		idForm:"<%=idForm%>",
   		idGrilla:"<%=idGrilla%>",
   		NidGrilla: "#" + "<%=idGrilla%>",
		modoGrilla:"ALTA",
		GetSelected: function (){
        	var id = $(formulario.NidGrilla).jqGrid('getGridParam','selrow');
        	var art=0;
			if (id) {
				var ret = $(formulario.NidGrilla).jqGrid('getRowData',id);
				art = ret.art_codig;
			}
        	return art;
        },
        getFiltro: function(){
        	return $.extend($(".filtro").serializeI(),{
        		marca: $("#aut_marca",formulario).val(),	        	
        		modelo: $("#aut_nauto",formulario).val(),     	
		     	BusquedaValor : $(formulario.NidGrilla + "_pie_left #jqgridSearInput",formulario).val(),
		     	BusquedaCampo : $(formulario.NidGrilla + "_pie_left #jqgridSearInput",formulario).data("field")	
    		} );
        },
        ActualizarParametros: function(textbox=""){  
        	$(formulario.NidGrilla,formulario).jqGrid('setGridParam',{ 
    			postData : formulario.getFiltro()
    		}).trigger("reloadGrid");
    	},
        Grilla: function (){	        
	        $(formulario.NidGrilla,formulario).jqGrid({
	        	url: <%=URL%>,
	        	datatype:"json",
	        	mtype:'GET', 
	        	colNames:['Cod.','Marca','Articúlo','Cod. Barra','Costo','P. Menor','P. Mayor','Activo'],
	        	colModel:[
	        		{name:'art_codig', index:'art_codig', width:15, hidden:false, formatter:'FormatClient'},
	        		{name:'mar_nombr', index:'mar_nombr', width:100, hidden:false},
	        		{name:'art_nombr', index:'art_nombr', width:100,hidden:false},
	        		{name:'art_codbr', index:'art_codbr', width:80,hidden:false,},
	        		{name:'art_costo', index:'art_costo', width:60,hidden:false, align:'right'},
	        		{name:'art_pmeno', index:'art_pmeno', width:60,hidden:false, align:'right'},
	        		{name:'art_pmayo', index:'art_pmayo', width:60,hidden:false, align:'right'},
	        		{name:'art_activ', index:'art_activ', width:15,hidden:false, formatter:'FormatActivo'}],
	        	width: ($("#Cuerpo").width()-10),
	        	height: ($("#Cuerpo").height()-80),
	        	rowNum:'100',
	        	rowList:[10, 15, 20, 25, 50, 75, 100, 150, 200, 250, 500, 750],
	        	pager:formulario.NidGrilla + '_pie',
	        	sortname:'art_codig',
	        	viewrecords:true,
	        	sortorder:"asc",
	        	hidegrid:false,
	        	title:false,
	        	gridComplete:function(){	        			        	
	        		$('tbody [role="row"]',formulario).each(function(id, val){
	        			if(id % 2 == 0){
	        				$(formulario.NidGrilla + ' #' + id,formulario).css('background-color', 'rgb(224, 224, 224)');
	        			}
	        		});
	        		
	        		if ($(formulario.NidGrilla + "_pie_left #jqgridSearchForm",formulario).length<=0){
						$("#jqgridSearchForm",formulario).remove();
						$(formulario.NidGrilla + "_pie_left",formulario).prepend(<% out.print(fun.buscadorGrilla(" Nombre", "art_nombr")); %>);
						$(formulario.NidGrilla + "_pie_left #jqgridSearInput",formulario).bind('keydown', function(e) {			
							switch (e.which) {				
								case 13:
									$(formulario.NidGrilla,formulario).jqGrid('setGridParam',
									   { postData : { 
									     	BusquedaValor : $(formulario.NidGrilla + "_pie_left #jqgridSearInput",formulario).val(),
									     	BusquedaCampo : $(formulario.NidGrilla + "_pie_left #jqgridSearInput",formulario).data("field")
									   } 
									}).trigger(	"reloadGrid");						    
									break;				
							}
						});
						      
						$(formulario.NidGrilla + "_pie_left #jqgridSearInput",formulario).click( function() {			
							$(formulario.NidGrilla,formulario).jqGrid('setGridParam',
							   { postData :  formulario.getFiltro()
							}).trigger(	"reloadGrid");
						});
	        		}	        		
	        		
	        		if (!$(formulario.NidGrilla + "_pie_left #jqgridSearInput",formulario).is(":focus")) {
		        		$("tr.jqgrow.ui-row-ltr.ui-widget-content",formulario).first().trigger("click");
		        		$(formulario.NidGrilla,formulario).focus();	        			 
	        		}
	            	if (formulario.textbox!=""){
	            		$(formulario.textbox).focus();
	            		formulario.textbox="";
	            	}
	        	}, 
	        	ondblClickRow:function(id){
	        		$(".tool:not(:first-child)",formulario).first().click();
	        	},
	        	loadBeforeSend: function () {
	        		var x=this;	        	
	        	    $(this).closest("div.ui-jqgrid-view").find("table.ui-jqgrid-htable>thead>tr>th").each(function(index, elem){
	        	    	$(elem).css("text-align", (x.p.colModel[index].align===undefined? "left" : x.p.colModel[index].align));
	        	    });
	        	},
	        	caption:"",
	        	postData : formulario.getFiltro()
	        });
	        $(".ui-jqgrid-titlebar").hide();	 
	        $( document ).resize(function(){  
	      	  reSizeGrid(formulario.idGrilla,($("#Cuerpo").width()-10),($("#Cuerpo").height()-80));
	      	});
        }
   	});
$(document).ready(function(){	        
	/* $("#<%=idForm%>").draggable();*/
	formulario.Grilla();	

	$("#aut_marca",formulario).change(function(){
		var marcaAct=$(this).val();
		if (marcaAct==0){
			$("#aut_nauto",formulario).enable();
			$("#aut_nauto",formulario).val("0");
			$("#aut_nauto",formulario).disable();
		}else{
			$("#aut_nauto",formulario).enable();
			$("#aut_nauto",formulario).val("0");
			$("#aut_nauto option",formulario).disable().hide();
			$("#aut_nauto option[data-marca='"+marcaAct+"']",formulario).enable().show();
			$("#aut_nauto option[data-marca='0']",formulario).enable().show();
		}		
		formulario.ActualizarParametros();
	});

	$("#aut_nauto",formulario).change(function(){	
		formulario.ActualizarParametros();
	});
	
	$(".tool:not(:first-child)",formulario).click(function(){
		var parametros=$(this).data();
		parametros.url='Frm_ArticuloABM';
		parametros.parametros={ modo: $(this).data("modo"), art_codig: formulario.GetSelected() };
		abrirFormulario(parametros);		
	});	
	$(".filtro").on('change paste input propertychange keyup ', function(){
		formulario.textbox=$(this);
		formulario.ActualizarParametros(this);
	});
	
 
});        

</script>
</div>