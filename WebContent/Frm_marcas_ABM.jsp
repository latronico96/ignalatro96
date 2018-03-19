<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="funciones.Funciones"%>
<%
	Funciones fun = new Funciones(request);
	String idGrilla = "Frm_marcas_ABM_Grilla";
	String idForm = "Frm_marcas_ABM";
	String URL = "'./Frm_marcas_ABM'";
	String tiposPuntos="<option value=\"E\">Electronico</option><option value=\"M\">Manual</option>";
%>

<div id="<%=idForm%>" data-popup="true" class="backmodal formulario">
	<style type="text/css">
		#<%=idForm%> #form {
			position: relative;
			-moz-box-sizing: content-box;
			-webkit-box-sizing: content-box;
			box-sizing: content-box;
			margin: 0px auto;
			width: 100%;
			z-index: 1;    
			height: 100%;
    		max-height: 17px;
		}
		
		#<%=idForm%> #jqgridSearchForm {
			position: relative;
			-moz-box-sizing: content-box;
			-webkit-box-sizing: content-box;
			box-sizing: content-box;
			margin: 0px auto;
			width: 100%;
			z-index: 1;
			height: 18.5px;
		}
		
		#<%=idForm%>>div {
			width: 720px;
			margin-top: 20px;
		}
	</style>

	<div class="modal" data-tmodal="alerta">
		<div class="modal-header">
			<h5 class="modal-title" id="exampleModalLabel">Administración de Marcas</h5>
			<button type="button" type="button" class="close"
				onclick="cerrarFormu('<%=idForm%>');">
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
			<button type="button" class="btn btn-secondary" data-dismiss="modal" onclick="cerrarFormu('<%=idForm%>');">Cerrar</button>
		</div>
	</div>

	<script type="text/javascript">
	formulario = $.fn.extend($(<%="\"#"+idForm+"\""%>), {
		idGrilla:"<%=idGrilla%>",
   		NidGrilla: "#" + "<%=idGrilla%>",
		stringFrom: "<div id=\"form\">\n"+
						"<button id=\"btn_rev\" class=\"form-control \" style=\"width:20px; height: 18px; padding: 1px;\" type=\"button\" value=\"se apreto\">\n"+
						"	<img src=\"/img/iconos/glyphicons-208-remove.png\" style=\"width: 16px;\" >\n"+
						"</button>\n"+
						"<input id=\"mar_codig\" class=\"form-control dato\" style=\"width: 40px;\" type=\"text\" placeholder=\"Codigo\" >\n"+
						"<input id=\"mar_nombr\" class=\"form-control dato\" style=\"width: 531px;\" type=\"text\" placeholder=\"Nombre\" maxlength=\"45\" >\n"+
						"<input id=\"mar_activ\" class=\"form-control dato\" style=\"width: 71px;\" type=\"checkbox\" placeholder=\"activo\" >\n"+
						"<button id=\"btn_act\" class=\"form-control\" style=\"width: 14px; height: 18px;  padding: 1px;\" type=\"button\" value=\"se apreto\" >\n"+
						"	<img src=\"/img/iconos/check.svg\" style=\"width: 16px; \">\n"+
						"</button>\n"+
					"</div>",
		validarMarca: function (){  		
    		var res=true;    		
    		if(res && $("#mar_nombr",formulario).val()==""){
    			mensaje="El nombre no puede quedar vacio.";
    			res=false;
    			$("#mar_nombr",formulario).abrirpopover(mensaje);
    		}
    		return res;   		
    	},
    	Grilla: function (){	        
	        $(formulario.NidGrilla).jqGrid({
	        	url: <%=URL%>,
	        	datatype:"json",
	        	mtype:'POST', 
	        	colNames:['Cod.', 'Nombre', 'Act.'],
	        	colModel:[
					{name:'mar_codig', index:'mar_codig', width:10,  formatter:'FormatClient'},
	        		{name:'mar_nombr', index:'mar_nombr', width:80},
	        		{name:'mar_activ', index:'mar_activ', width:10}
	        		],
	        	width:700,
	        	height:400,
	        	rowNum:'10',
	        	rowList:[10, 15, 20, 25, 50, 75, 100, 150, 200, 250, 500, 750],
	        	pager: formulario.NidGrilla + '_pie',
	        	sortname:'mar_codig',
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
	        		$("#form",formulario).remove();
	        		$(".ui-jqgrid-bdiv",formulario).prepend(formulario.stringFrom);
	        		$("#btn_rev",formulario).unbind("click").click(function(){
	        			$(".dato",formulario).val("");
		        		$("#mar_codig",formulario).val(Math.max(...$(formulario.NidGrilla).jqGrid('getCol', 'mar_codig', false).concat([0]))+1);   	
		        		$("#mar_activ",formulario).prop("checked",true);
	        		});	        		        		
	        		$("#btn_act",formulario).unbind("click").click(function(){
	        			if(formulario.validarMarca()){
		        			var checkboxes = $('input[type="checkbox"].dato',formulario);
		        			$.each( checkboxes, function( key, value ) {
		        			    if (value.checked === false) {
		        			        value.value = 0;
		        			    }else{
		        			        value.value = 1;
		        			    }
		        			    $(value).attr('type', 'hidden');
		        			});
		        			var disabled = $('.dato:disabled', formulario).prop("disabled",false);
		        			cargando();
		        			$.ajax({
		        				dataType:'json',
		        				data:$('.dato', formulario).serializeI(),
		        				type:'GET',
		        				url:  <%=URL%>,
		        				success:function(data){
		        					cerrarAlerta();
		        					console.log(data);
									if(data.error == 0){
										$(formulario.NidGrilla).trigger('reloadGrid');
									}
								}, 
								error:function(data){
									cerrarAlerta();
					            	console.log(data);
						        }
							});
		        			checkboxes.attr("type","checkbox");
		        			disabled.prop("disabled",true);
	        			}
	        		});
	        		$("#mar_codig",formulario).val(Math.max(...$(formulario.NidGrilla).jqGrid('getCol', 'mar_codig', false).concat([0]))+1);
	        		$("#mar_activ",formulario).prop("checked",true);	
	        		$("#mar_codig",formulario).prop("disabled",true);
	        		
	        		$("#jqgridSearchForm",formulario).remove();
	        		$(formulario.NidGrilla + "_pie_left",formulario).prepend(<%=(fun.buscadorGrilla("nombre", "ptv_nombr"))%>);
	        		$("tr.jqgrow.ui-row-ltr.ui-widget-content",formulario).first().trigger("click");
	        		$(formulario.NidGrilla,formulario).focus();
	        	}, 
	        	ondblClickRow:function(id){
	        		var ret = $(formulario.NidGrilla,formulario).jqGrid('getRowData', id);
	        		$(".dato",formulario).each(function(index){
	        			if(this.type=="checkbox"){
	        				if(ret[this.id]!="" && ret[this.id]!="0" )
	        				$(this).prop("checked",true);	        		
	        			}else{
	        				$(this).val(ret[this.id]);	        				
	        			}
	        		});
	        	},
	        	caption:""
	        });
	        $(".ui-jqgrid-titlebar",formulario).hide();	        
        }
	});
		
	$(document).ready(function(){
		formulario.show();
		formulario.Grilla();
	});
	
	</script>	
</div>