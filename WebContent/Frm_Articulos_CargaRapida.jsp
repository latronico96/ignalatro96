<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="funciones.Funciones"%>
<%
	Funciones fun = new Funciones(request);
	String idGrilla = "Frm_Articulos_CargaRapida_Grilla";
	String idForm = "Frm_Articulos_CargaRapida";
	String URL = "'./Frm_Articulos_CargaRapida'";
	String list = fun.GetHTMLOtionList("mar_codig","mar_nombr","dbmarcas");
	list=list.replaceAll("\"", "\\\"");
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
		#<%=idForm%> #form .dato{
			padding: 0px;
			margin: 0px;
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
			width: 1000px;
			margin-top: 20px;
		}
	</style>

	<div class="modal" data-tmodal="alerta">
		<div class="modal-header">
			<h5 class="modal-title" id="exampleModalLabel">Carga rapida de Articulos</h5>
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
			<button type="button" class="btn btn-secondary" data-dismiss="modal" onclick="cerrarFormu('<%=idForm%>');">Cerrar</button>
		</div>
	</div>
	<script type="text/javascript">
		stringFrom="<div id=\"form\">\n"+
						"<input id=\"art_codbr\" class=\"form-control with-14-50 dato\" type=\"text\" placeholder=\"Cod. Barras\"  maxlength=\"13\">\n"+
						"<input id=\"art_codig\" class=\"form-control with-5-50 dato\" type=\"text\" placeholder=\"Cod.\" >\n"+
						"<input id=\"red_canti\" class=\"form-control with-4-50 dato\" type=\"text\" placeholder=\"Cant.\" >\n"+
						"<input id=\"mar_codig\" class=\"dato\" type=\"hidden\" placeholder=\"codigo\" >\n"+
						"<input id=\"mar_nombr\" class=\"form-control with-14-50 dato\" type=\"text\" placeholder=\"Grupo\" list=\"listaMarca\"  maxlength=\"45\">\n"+
						"<datalist id=\"listaMarca\"><%=list%></datalist>\n"+
						"<input id=\"art_nombr\" class=\"form-control with-14-50 dato\" type=\"text\" placeholder=\"Articulo\"  maxlength=\"45\">\n"+
						"<input id=\"art_stmin\" class=\"form-control with-4-00 dato\" type=\"text\" placeholder=\"Stk Min\" >\n"+
						"<input id=\"art_costo\" class=\"form-control with-9-50 dato\" type=\"text\" placeholder=\"Costo\" >\n"+
						"<input id=\"art_pmenoP\" class=\"form-control with-4-00 dato\" type=\"text\" placeholder=\"%\" >\n"+
						"<input id=\"art_pmeno\" class=\"form-control with-10-00 dato\" type=\"text\" placeholder=\"Minorista\" >\n"+
						"<input id=\"art_pmayoP\" class=\"form-control with-4-00 dato\" type=\"text\" placeholder=\"%\" >\n"+
						"<input id=\"art_pmayo\" class=\"form-control with-10-00 dato\" type=\"text\" placeholder=\"Mayorista\" >\n"+
						"<button id=\"btn_act\" class=\"form-control with-1-00\" style=\"height: 18px;  padding: 1px;\" type=\"button\" value=\"se apreto\" >\n"+
						"	<img src=\"/img/iconos/check.svg\" style=\"width: 16px; \">\n"+
						"</button>\n"+
					"</div>";

			
		var idGrilla="<%=idGrilla%>";
        var NidGrilla = "#" + idGrilla;
        var form=$("#<%=idForm%>");
       	var cargados="";
        $(document).ready(function(){
        	form.draggable();
        	cargados="";
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
	        	colNames:['Cod. Barras','Cod.','Cant.','Codigo grupo','Grupo','Articulo','C. Min','Costo','P Men.','P. May.'],
	        	colModel:[
					{name:'art_codbr', index:'art_codbr', width:15,},
					{name:'art_codig', index:'art_codig', width:5,  formatter:'FormatClient'},					
	        		{name:'red_canti', index:'red_canti', width:5, align:"right"},
	        		{name:'mar_codig', index:'mar_codig', width:0, hidden:true},
	        		{name:'mar_nombr', index:'mar_nombr', width:15},
	        		{name:'art_nombr', index:'art_nombr', width:15},
	        		{name:'art_stmin', index:'art_stmin', width:5, align:"right"},
	        		{name:'art_costo', index:'art_costo', width:10, align:"right"},
	        		{name:'art_pmeno', index:'art_pmeno', width:15, align:"right"},
	        		{name:'art_pmayo', index:'art_pmayo', width:15, align:"right"}
	        		],
	        	width: ($("#<%=idForm%>>div").width()-20),
	        	height:400,
	        	rowNum:'10',
	        	rowList:[10, 15, 20, 25, 50, 75, 100, 150, 200, 250, 500, 750],
	        	pager:NidGrilla + '_pie',
	        	sortname:'art_codig',
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
	        		
	        		$(listaMarca).html(funciones("GetHTMLOtionList",["mar_codig","String","mar_nombr","String","dbmarcas","String"]));
	        		
	        		$('#mar_nombr',form).change(function(){
	        	        var clave=$("#listaMarca option[value='" + $('#mar_nombr',form).val() + "']",form).attr('data-id');
	        	        clave=(clave==undefined,"",clave);
	        	        $('#mar_codig',form).val(clave);
	        	    });
	        		
	        		$('#art_codbr',form).change(function(){
	        			var codBarra=$(this).val();
	        			$(this).val(fillZero(codBarra,13));
	        			codBarra=$(this).val();
                		rowArt=JSON.parse(valyget("ARTB",codBarra));    
                		switch(rowArt.error){
        	                case "2":
        	                	abrirAlerta("ERR", "Error al tratar de buscar el Articulo.","Error interno");
        	            		$("#art_codbr",form).val(""); 
        		                break;
        	                case "1"://no se encontro otro sigue
        		                break;
        	                case "0":
        	                	abrirAlerta("NOT", "El Articulo \""+rowArt.datos.art_nombr+"\" tiene el mismo codigo. Vuelva a leer el codigo.o ingrese uno distinto");
        	            		$("#art_codbr",form).val(""); 
        		                break;
        		            default:
        		            	break;
                        }
	        	    });
	        		
	        		$('#art_codig',form).change(function(){	        			
	        			var cod=$(this).val();
                		rowArt=JSON.parse(valyget("ART",cod));    
                		switch(rowArt.error){
        	                case "2":
        	                	abrirAlerta("ERR", "Error al tratar de buscar el Articulo.","Error interno");
        	            		$("#art_codig",form).val(""); 
        		                break;
        	                case "1"://no se encontro otro sigue
        		                break;
        	                case "0":
        	                	abrirAlerta("NOT", "El Articulo \""+rowArt.datos.art_nombr+"\" tiene el mismo codigo. Vuelva a leer el codigo.o ingrese uno distinto");
        	            		$("#art_codig",form).val(""); 
        		                break;
        		            default:
        		            	break;
                        }
	        	    });
	        		
	        		$('#red_canti',form).change(function(){	        			
	        			var cant=$(this).val();
                		if(cant<=0){
        	                abrirAlerta("NOT", "La cantidad tiene que ser mayor que 0.");
        	            	$("#red_canti",form).val("");         		         
                        }
	        	    });
	        		
	        		$('#art_costo,#art_pmenoP,#art_pmayoP',form).change(function(){	 
	        			var costo=$('#art_costo',form).val();
	        			$('#art_costo',form).val(number_format(costo,2));
	        			var costo=parseFloat($('#art_costo',form).val()); 
	        			
	        			var porceMin=$('#art_pmenoP',form).val();
	        			$('#art_pmenoP',form).val(number_format(porceMin,2));
	        			var porceMin=parseFloat($("#art_pmenoP",form).val())/100;
	        			
	        			var porceMay=$('#art_pmayoP',form).val();
	        			$('#art_pmayoP',form).val(number_format(porceMay,2));
	        			var porceMay=parseFloat($("#art_pmayoP",form).val())/100;
	        			
	        			$("#art_pmeno",form).val(number_format(costo+(costo*porceMin),2));
	        			$("#art_pmayo",form).val(number_format(costo+(costo*porceMay),2));	        			
	        	    });	 
	        		
	        		
	        		
	        		
	        		
	        		$("#btn_act",form).unbind("click").click(function(){
	        			var costo=$('#art_costo',form).val();
	        			var menor=$('#art_pmeno',form).val();
	        			var mayor=$('#art_pmayo',form).val();
	        		
	        			if(Math.max(costo,menor,mayor)>=100000){//limitye de la base de datos
	        				abrirAlerta("ERR", "El costo, el precio minorista y el precio mayorista debe ser menor a $100,000.00");
	        			}else{	        		
		        			cargando();
		        			$.ajax({
		        				dataType:'json',
		        				data:$('.dato').serializeI(),
		        				type:'GET',
		        				url:  <%=URL%>,
		        				success:function(data){
		        					cerrarAlerta();
		        					console.log(data);
		        					if(data.error !=0){
								    	abrirAlerta("ERR", data.msg);//hubo  un error
							    	}else{
							    		cargados+=","+$('#art_codig',form).val();
							    		$(NidGrilla).jqGrid('setGridParam',{ 
							    			postData : {
							    				BusquedaCampo : 'art_codig',
												BusquedaValor  : cargados 
							    			} 
							    		}).trigger('reloadGrid');
							    	}
								}, 
								error:function(data){
									cerrarAlerta();
									abrirAlerta("ERR", data.msg);
						        }
							});
	        			}
	        		});
	        		
	        	}, 
	        	ondblClickRow:function(id){
	        		/*var ret = $(NidGrilla,form).jqGrid('getRowData', id);
	        		$(".dato",form).each(function(index){
	        			if(this.type=="checkbox"){
	        				if(ret[this.id]!="" && ret[this.id]!="0" )
	        				$(this).prop("checked",true);	        		
	        			}else{
	        				$(this).val(ret[this.id]);	        				
	        			}
	        		});*/
	        	},
	        	caption:"",
				postData : {
					BusquedaCampo: 'art_codig',
					BusquedaValor  : cargados }
	        });
	        $(".ui-jqgrid-titlebar",form).hide();	        
        }
	</script>	
</div>