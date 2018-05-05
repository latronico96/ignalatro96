<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="funciones.Funciones"%>
<%
	Funciones fun = new Funciones(request);
	String idGrilla = "Frm_ptaVta_ABM_Grilla";
	String idForm = "Frm_ptaVta_ABM";
	String URL = "'./Frm_ptaVta_ABM'";
	String tiposPuntos="<option value=\\\"E\\\">Electronico</option><option value=\\\"M\\\">Manual</option>";
%>

<div id="<%=idForm%>" data-popup="true" class="backmodal formulario">
	<style type="text/css">
#<%=
idForm %>#form {
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

#<%=
idForm %>#jqgridSearchForm {
	position: relative;
	-moz-box-sizing: content-box;
	-webkit-box-sizing: content-box;
	box-sizing: content-box;
	margin: 0px auto;
	width: 100%;
	z-index: 1;
	height: 18.5px;
}

#Frm_ptaVta_ABM>div {
	width: 720px;
	margin-top: 20px;
}
</style>

	<div class="modal" data-tmodal="alerta">
		<div class="modal-header">
			<h5 class="modal-title">Administración de Puntos de Venta</h5>
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
			<button type="button" class="btn btn-primary">Guardar
				Cambios</button>
			<button type="button" class="btn btn-secondary" data-dismiss="modal"
				onclick="cerrarFormu('<%=idForm%>');">Cerrar</button>
		</div>
	</div>

	<script type="text/javascript">
	stringFrom="<div id=\"form\">\n"+
					"<button id=\"btn_rev\" class=\"form-control \" style=\"width:20px; height: 18px; padding: 1px;\" type=\"button\" value=\"se apreto\">\n"+
					"	<img src=\"/img/iconos/glyphicons-208-remove.png\" style=\"width: 16px;\" >\n"+
					"</button>\n"+
					"<input id=\"ptv_codig\" class=\"form-control dato\" style=\"width: 29px;\" type=\"text\" placeholder=\"Codigo\" >\n"+
					"<input id=\"ptv_nombr\" class=\"form-control dato\" style=\"width: 225px;\" type=\"text\" placeholder=\"Nombre\" >\n"+
					"<select id=\"ptv_tipop\" class=\"form-control dato\" style=\"width: 110px;\" >\n"+
					"	<%=tiposPuntos%>\n"+
					"</select>\n"+
					"<input id=\"ptv_certi\" class=\"form-control dato\" style=\"width: 225px;\" type=\"text\" placeholder=\"Certificado\" >\n"+
					"<input id=\"ptv_activ\" class=\"form-control dato\" style=\"width: 36px;\" type=\"checkbox\" placeholder=\"activo\" >\n"+
					"<button id=\"btn_act\" class=\"form-control\" style=\"width: 14px; height: 18px;  padding: 1px;\" type=\"button\" value=\"se apreto\" >\n"+
					"	<img src=\"/img/iconos/check.svg\" style=\"width: 16px; \">\n"+
					"</button>\n"+
				"</div>";
			
		var idGrilla="<%=idGrilla%>";
        var NidGrilla = "#" + idGrilla;
        var form=$("#<%=idForm%>");
        $(document).ready(function(){
        	form.draggable();
	        Grilla();
        });
        
    	function validarPtVta(){
    		var formulario = $("#<%=idForm%>");    		
    		var res=true;
    		
    		if(res && $("#ptv_nombr",formulario).val()==""){
    			mensaje="El nombre no puede quedar vacio.";
    			res=false;
    			$("#ptv_nombr").abrirpopover(mensaje);
    		}
    		
    		if(res && $("#ptv_tipop",formulario).val()==""){
    			mensaje="El tipo de punto de venta no puede quedar vacio.";
    			res=false;
    			$("#ptv_tipop").abrirpopover(mensaje);
    		}
    		
    		if(res && $("#ptv_tipop",formulario).val()=="E" && $("#ptv_certi",formulario).val()==""){
    			mensaje="El certificado no puede quedar vacio si es un punto de venta Electrónico.";
    			res=false;
    			$("#ptv_certi").abrirpopover(mensaje);
    		}
    		
    		return res;   		
    	}
        
        function Grilla(){	        
	        $(NidGrilla).jqGrid({
	        	url: <%=URL%>,
	        	datatype:"json",
	        	mtype:'POST', 
	        	colNames:['Cod.', 'Nombre', 'Tipo', 'Certificado', 'Act.' ],
	        	colModel:[
	        		{name:'ptv_codig', index:'ptv_codig', width:50,  formatter:'FormatClient'},
	        		{name:'ptv_nombr', index:'ptv_nombr', width:200},
	        		{name:'ptv_tipop', index:'ptv_tipop', width:100},
	        		{name:'ptv_certi', index:'ptv_certi', width:200},
	        		{name:'ptv_activ', index:'ptv_activ', width:30}
	        		],
	        	width:700,
	        	height:500,
	        	rowNum:'100',
	        	rowList:[10, 15, 20, 25, 50, 75, 100, 150, 200, 250, 500, 750],
	        	pager:NidGrilla + '_pie',
	        	sortname:'ptv_codig',
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
		        		$("#ptv_codig",form).val(Math.max(...$(NidGrilla).jqGrid('getCol', 'ptv_codig', false).concat([0]))+1);   	
	        		});	        		        		
	        		$("#btn_act",form).unbind("click").click(function(){
	        			
	        			var checkboxes = $('input[type="checkbox"].dato',form);
	        			$.each( checkboxes, function( key, value ) {
	        			    if (value.checked === false) {
	        			        value.value = 0;
	        			    } else {
	        			        value.value = 1;
	        			    }
	        			    $(value).attr('type', 'hidden');
	        			});
	        			var disabled = $('.dato:disabled',form).prop("disabled",false);
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
	        		});
	        		$("#ptv_tipop",form).unbind("change").change(function(){
	        			if($(this).val()!="E"){
	        				$("#ptv_certi",form).prop("disabled",true);
	        			}else{
	        				$("#ptv_certi",form).prop("disabled",false)
	        			}
	        			
	        		});
	        		$("#ptv_tipop",form).change();
	        		$("#ptv_codig",form).val(Math.max(...$(NidGrilla).jqGrid('getCol', 'ptv_codig', false).concat([0]))+1);
	        		$("#mar_activ",form).prop("checked",true);
	        		$("#ptv_codig",form).prop("disabled",true);
	        		
	        		$("#jqgridSearchForm",form).remove();
	        		$(NidGrilla + "_pie_left",form).prepend(<%=fun.buscadorGrilla("nombre", "ptv_nombr")%>);
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
	        		/*$.each(Object.values(ret), function(i, val){
	        			$(".dato",form)[i].value = val;
	        		})*/
	        	},
	        	caption:""
	        });
	        $(".ui-jqgrid-titlebar",form).hide();	        
        }
	</script>

</div>