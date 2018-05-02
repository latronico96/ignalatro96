<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="funciones.Funciones"%>
<%
	Funciones fun = new Funciones(request);
	String idGrilla = "Frm_Articulos_CargaRapida_Grilla";
	String idForm = "Frm_Articulos_CargaRapida";
	String URL = "'./Frm_Articulos_CargaRapida'";
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
	formulario = $.fn.extend($(<%="\"#"+idForm+"\""%>), {
		idForm: "#<%=idForm%>",	
   		idGrilla:"<%=idGrilla%>",
   		NidGrilla: "#" + "<%=idGrilla%>",
		cargados:"",
		stringFrom:"<div id=\"form\">\n"+
						"<div Style=\"width: calc(100% - 20px);float: left;\">"+
						"	<input id=\"rem_codig\" class=\"dato\" type=\"hidden\">\n"+
						"	<input id=\"art_codbr\" class=\"form-control with-15-00 dato\" type=\"text\" placeholder=\"Cod. Barras\"  maxlength=\"13\">\n"+
						"	<input id=\"art_codig\" class=\"form-control with-5-00 dato\" type=\"text\" placeholder=\"Cod.\" >\n"+
						"	<input id=\"red_canti\" class=\"form-control with-5-00 dato\" type=\"text\" placeholder=\"Cant.\" >\n"+
						"	<input id=\"mar_codig\" class=\"dato\" type=\"hidden\" placeholder=\"codigo\" >\n"+
						"	<input id=\"mar_nombr\" class=\"form-control with-15-00 dato\" type=\"text\" placeholder=\"Grupo\" list=\"listaMarca\"  maxlength=\"45\">\n"+
						"	<datalist id=\"listaMarca\"></datalist>\n"+
						"	<input id=\"art_nombr\" class=\"form-control with-15-00 dato\" type=\"text\" placeholder=\"Articulo\"  maxlength=\"45\">\n"+
						"	<input id=\"art_stmin\" class=\"form-control with-5-00 dato\" type=\"text\" placeholder=\"Stk Min\" >\n"+
						"	<input id=\"art_costo\" class=\"form-control with-10-00 dato\" type=\"text\" placeholder=\"Costo\" >\n"+
						"	<input id=\"art_pmenoP\" class=\"form-control with-5-00 dato\" type=\"text\" placeholder=\"%\" >\n"+
						"	<input id=\"art_pmeno\" class=\"form-control with-10-00 dato\" type=\"text\" placeholder=\"Minorista\" >\n"+
						"	<input id=\"art_pmayoP\" class=\"form-control with-5-00 dato\" type=\"text\" placeholder=\"%\" >\n"+
						"	<input id=\"art_pmayo\" class=\"form-control with-10-00 dato\" type=\"text\" placeholder=\"Mayorista\" >\n"+
						"</div>"+
						"<div Style=\"width: 20px;float: left;\">"+
						"	<button id=\"btn_act\" class=\"form-control\" style=\"height: 18px;width: 16px;  padding: 1px;\" type=\"button\" value=\"se apreto\" >\n"+
						"		<img src=\"/img/iconos/check.svg\" style=\"width: 16px; \">\n"+
						"	</button>\n"+
						"</div>"+
					"</div>",
		validarMarca:function (){   		
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
	        	colNames:['Nro Remito','Cod. Barras','Cod.','Cant.','Codigo grupo','Grupo','Articulo','C. Min','Costo','P Men.','P. May.'],
	        	colModel:[
	        		{name:'rem_codig', index:'rem_codig', width:0, hidden:true},
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
	        	rowNum:'100',
	        	rowList:[10, 15, 20, 25, 50, 75, 100, 150, 200, 250, 500, 750],
	        	pager: formulario.NidGrilla + '_pie',
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
	        		
	        		$("#form",formulario).remove();
	        		$(formulario.stringFrom).insertBefore(formulario.idForm + " .ui-jqgrid-bdiv");
	        		$("#form div:first *",formulario).each(function( index ) {
	        			  $(this).width(parseFloat($(this).width()-2));
	        			});
	        		$("#listaMarca",formulario).html(funciones("GetHTMLOtionList",["mar_codig","String","mar_nombr","String","dbmarcas","String"]));
	        		
	        		$('#mar_nombr',formulario).change(function(){
	        	        var clave=$("#listaMarca option[value='" + $('#mar_nombr',formulario).val() + "']",formulario).attr('data-id');
	        	        clave=(clave==undefined,"",clave);
	        	        $('#mar_codig',formulario).val(clave);
	        	    });
	        		
	        		$('#art_codbr',formulario).change(function(){
	        			var codBarra=$(this).val();
	        			$(this).val(fillZero(codBarra,13));
	        			codBarra=$(this).val();
                		rowArt=JSON.parse(valyget("ARTB",codBarra));    
                		switch(rowArt.error){
        	                case "2":
        	                	abrirAlerta("ERR", "Error al tratar de buscar el Articulo.","Error interno");
        	            		$("#art_codbr",formulario).val(""); 
        		                break;
        	                case "1"://no se encontro otro sigue
        		                break;
        	                case "0":
        	                	abrirAlerta("NOT", "El Articulo \""+rowArt.datos.art_nombr+"\" tiene el mismo codigo. Vuelva a leer el codigo.o ingrese uno distinto");
        	            		$("#art_codbr",formulario).val(""); 
        		                break;
        		            default:
        		            	break;
                        }
	        	    });
	        		
	        		$('#art_codig',formulario).change(function(){	        			
	        			var cod=$(this).val();        				
                		rowArt=JSON.parse(valyget("ART",cod));    
                		switch(rowArt.error){
        	                case "2":
        	                	abrirAlerta("ERR", "Error al tratar de buscar el Articulo.","Error interno");
        	            		$("#art_codig",formulario).val(""); 
        		                break;
        	                case "1"://no se encontro otro sigue
        		                break;
        	                case "0":
        	                	abrirAlerta("NOT", "El Articulo \""+rowArt.datos.art_nombr+"\" tiene el mismo codigo. Vuelva a leer el codigo.o ingrese uno distinto");
        	            		$("#art_codig",formulario).val(""); 
        		                break;
        		            default:
        		            	break;
                        }
	        	    });
	        		
	        		$('#red_canti',formulario).change(function(){	        			
	        			var cant=$(this).val();
                		if(cant<=0){
        	                abrirAlerta("NOT", "La cantidad tiene que ser mayor que 0.");
        	            	$("#red_canti",formulario).val("");         		         
                        }
	        	    });
	        		
	        		$('#art_costo,#art_pmenoP,#art_pmayoP',formulario).change(function(){	 
	        			var costo=$('#art_costo',formulario).val();
	        			$('#art_costo',formulario).val(number_format(costo,2));
	        			var costo=parseFloat($('#art_costo',formulario).val()); 
	        			
	        			var porceMin=$('#art_pmenoP',formulario).val();
	        			$('#art_pmenoP',formulario).val(number_format(porceMin,2));
	        			var porceMin=parseFloat($("#art_pmenoP",formulario).val())/100;
	        			
	        			var porceMay=$('#art_pmayoP',formulario).val();
	        			$('#art_pmayoP',formulario).val(number_format(porceMay,2));
	        			var porceMay=parseFloat($("#art_pmayoP",formulario).val())/100;
	        			
	        			$("#art_pmeno",formulario).val(number_format(costo+(costo*porceMin),2));
	        			$("#art_pmayo",formulario).val(number_format(costo+(costo*porceMay),2));	        			
	        	    });	 
	        		
	        		$('#art_pmeno,#art_pmayo',formulario).change(function(){	 
	        			var costo=$('#art_costo',formulario).val();
	        			$('#art_costo',formulario).val(number_format(costo,2));
	        			var costo=parseFloat($('#art_costo',formulario).val()); 
	        			var pmeno=parseFloat($('#art_pmeno',formulario).val()); 
	        			var pmayo=parseFloat($('#art_pmayo',formulario).val()); 
	        			
	        			$('#art_pmenoP',formulario).val(number_format( (pmeno/costo - 1)*100 ,2));
	        			$('#art_pmayoP',formulario).val(number_format( (pmayo/costo - 1)*100 ,2));		
	        	    });	 
	        		
	        		$("#btn_act",formulario).unbind("click").click(function(){
	        			var costo=$('#art_costo',formulario).val();
	        			var menor=$('#art_pmeno',formulario).val();
	        			var mayor=$('#art_pmayo',formulario).val();
	        		
	        			if(Math.max(costo,menor,mayor)>=100000){//limitye de la base de datos
	        				abrirAlerta("ERR", "El costo, el precio minorista y el precio mayorista debe ser menor a $100,000.00");
	        			}else{	        		
		        			cargando();
		        			$.ajax({
		        				dataType:'json',
		        				data:$('.dato',formulario).serializeI(),
		        				type:'GET',
		        				url:  <%=URL%>,
		        				success:function(data){
		        					cerrarAlerta();
		        					console.log(data);
		        					if(data.error !=0){
								    	abrirAlerta("ERR", data.msg);//hubo  un error
							    	}else{
							    		formulario.cargados+=","+$('#art_codig',formulario).val();
							    		$(formulario.NidGrilla).jqGrid('setGridParam',{ 
							    			postData : {
							    				BusquedaCampo : 'art_codig',
												BusquedaValor  : formulario.cargados 
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
	        		var ret = $(formulario.NidGrilla,formulario).jqGrid('getRowData', id);
	        		$(".dato",formulario).each(function(index){
	        			if(this.type=="checkbox"){
	        				$(this).prop("checked",(ret[this.id]!="" && ret[this.id]!="0" ));	
	        			}else{
	        				$(this).val(ret[this.id]);	        				
	        			}
	        			$('#art_pmeno,#art_pmayo',formulario).change();        			
	        			
	        		});
	        		$(".dato#modo",formulario).val("MODI");
	        	},
	        	caption:"",
				postData : {
					BusquedaCampo: 'art_codig',
					BusquedaValor  : formulario.cargados }
	        });
	        $(".ui-jqgrid-titlebar",formulario).hide();	        
        }
					
	});
	
    $(document).ready(function(){
    	formulario.show();
       	formulario.cargados="";
       	formulario.Grilla();
    });    
    	
	</script>	
</div>