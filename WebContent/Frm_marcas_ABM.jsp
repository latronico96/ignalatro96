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
		stringFrom="<div id=\"form\">\n"+
			<%out.println(fun.buttonString("btn_rev", "form-control ", "width:20px; height: 18px; padding: 1px;", "button",
					"se apreto", "<img src=\"/img/iconos/glyphicons-208-remove.png\" style=\"width: 16px; \">", ""));%> +
			<%out.println(fun.inputString("mar_compa", "form-control dato", "width: 0px;", "hidden", "value=\""+String.valueOf(fun.compania)+"\""));%> +		
			<%out.println(fun.inputString("mar_codig", "form-control dato", "width: 40px;", "text", "placeholder=\"Codigo\""));%> +
			<%out.println(fun.inputString("mar_nombr", "form-control dato", "width: 531px;", "text",	"placeholder=\"Nombre\" maxlength=\"45\""));%> +
			<%out.println(fun.inputString("mar_activ", "form-control dato", "width: 71px;", "checkbox",	"placeholder=\"activo\""));%> +
			<%out.println(fun.buttonString("btn_act", "form-control ", "width:14px; height: 18px;  padding: 1px;", "button",
					"se apreto", "<img src=\"/img/iconos/check.svg\" style=\"width: 16px; \">", ""));%> +
			"</div>";
			
		var idGrilla="<%=idGrilla%>";
        var NidGrilla = "#" + idGrilla;
        var form=$("#<%=idForm%>");
        $(document).ready(function(){
        	form.draggable();
	        Grilla();
        });
        
    	
    	function validarMarca(){
    		var formulario = $("#<%=idForm%>");    		
    		var res=true;
    		
    		if(res && $("#mar_nombr",formulario).val()==""){
    			mensaje="El nombre no puede quedar vacio.";
    			res=false;
    			$("#mar_nombr").abrirpopover(mensaje);
    		}
    		return res;   		
    	}
        
        function Grilla(){	        
	        $(NidGrilla).jqGrid({
	        	url: <%=URL%>,
	        	datatype:"json",
	        	mtype:'POST', 
	        	colNames:['compania','Cod.', 'Nombre', 'Act.'],
	        	colModel:[

	        		{name:'mar_compa', index:'mar_compa', width:0, hidden:true},
	        		{name:'mar_codig', index:'mar_codig', width:10,  formatter:'FormatCliente'},
	        		{name:'mar_nombr', index:'mar_nombr', width:80},
	        		{name:'mar_activ', index:'mar_activ', width:10}
	        		],
	        	width:700,
	        	height:400,
	        	rowNum:'10',
	        	rowList:[10, 15, 20, 25, 50, 75, 100, 150, 200, 250, 500, 750],
	        	pager:NidGrilla + '_pie',
	        	sortname:'mar_codig',
	        	viewrecords:true,
	        	sortorder:"asc",
	        	hidegrid:false,
	        	title:false,
	        	gridComplete:function(){
	        		$('tbody [role="row"]',form).each(function(id, val){
	        			if(id % 2 == 0){
	        				$(NidGrilla + ' #' + id,form).css('background-color', 'rgb(224, 224, 224)');
	        			}
	        		});
	        		$("#form",form).remove();
	        		$(".ui-jqgrid-bdiv",form).prepend(stringFrom);
	        		$("#btn_rev",form).unbind("click").click(function(){
	        			$(".dato",form).val("");
		        		$("#mar_compa",form).val(Math.max(...$(NidGrilla).jqGrid('getCol', 'mar_codig', false).concat([0]))+1);   	
		        		$("#mar_activ",form).prop("checked",true);
	        		});	        		        		
	        		$("#btn_act",form).unbind("click").click(function(){
	        			if(validarMarca()){
		        			var checkboxes = $('input[type="checkbox"].dato',form);
		        			$.each( checkboxes, function( key, value ) {
		        			    if (value.checked === false) {
		        			        value.value = 0;
		        			    }else{
		        			        value.value = 1;
		        			    }
		        			    $(value).attr('type', 'hidden');
		        			});
		        			var disabled = $('.dato:disabled', form).prop("disabled",false);
		        			cargando();
		        			$.ajax({
		        				dataType:'json',
		        				data:$('.dato').serialize(),
		        				type:'GET',
		        				url:  <%=URL%>,
		        				success:function(data){
		        					cerrarAlerta();
		        					console.log(data);
									if(data.error == 0){
										$(NidGrilla).trigger('reloadGrid');
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
	        		$("#mar_codig",form).val(Math.max(...$(NidGrilla).jqGrid('getCol', 'mar_codig', false).concat([0]))+1);
	        		$("#mar_activ",form).prop("checked",true);	
	        		$("#mar_codig",form).prop("disabled",true);
	        		
	        		$("#jqgridSearchForm",form).remove();
	        		$(NidGrilla + "_pie_left",form).prepend(<%out.println(fun.buscadorGrilla("nombre", "ptv_nombr"));%>);
	        		$("tr.jqgrow.ui-row-ltr.ui-widget-content",form).first().trigger("click");
	        		$(NidGrilla,form).focus();
	        	}, 
	        	ondblClickRow:function(id){
	        		var ret = $(NidGrilla,form).jqGrid('getRowData', id);
	        		$(".dato",form).each(function(index){
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
	        $(".ui-jqgrid-titlebar",form).hide();	        
        }
	</script>
	
</div>