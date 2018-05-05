<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@page import="funciones.Funciones"%>
<%
	Funciones fun = new Funciones(request);
	String idForm = "Frm_RemitoEABM";
	String idGrilla = "RemitoEABM";
	String URL = "'./Frm_RemitoEABM'";
	String modo=(String) request.getAttribute("modo");
	String Remito=(String) request.getAttribute("Remito");
	String Grilla=(String) request.getAttribute("Grilla");
%>
<div id="<%=idForm%>" data-popup="true" class="backmodal formulario">
	<style type="text/css">
#<%=
idForm %>#form {
	position: relative;
	-moz-box-sizing: content-box;
	-webkit-box-sizing: content-box;
	box-sizing: content-box;
	margin: 0px;
	z-index: 1;
}

#<%=
idForm %>.form-control {
	margin: 0px auto;
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
}

#<%=
idForm %> >div {
	width: 850px;
	margin-top: 20px;
}

#<%=
idForm %>#fld_totales, #<%=idForm %>#fld_totales .fila * {
	float: right;
}
</style>

	<div class="modal" data-tmodal="alerta">
		<div class="modal-header">
			<h5 class="modal-title" id="exampleModalLabel">
				<span id="Titulo"></span> Remito
			</h5>
			<button type="button" type="button" class="close"
				onclick="cerrarFormu('<%=idForm%>');">
				<span aria-hidden="true">&times;</span>
			</button>
		</div>
		<div class="modal-body">
			<div class="d-block">
				<fieldset>
					<div class="fila">
						<input id="modo" class="form-control campo" type="hidden">
						<input id="rem_tipor" class="campo" type="hidden" value="E">
						<span class="form-control with-10-00">Fecha</span> <input
							id="rem_fecha" class="form-control with-20-00 campo fecha"
							type="text" maxlength="4"> <input id="rem_codig"
							class="form-control with-20-00 campo float-right" type="text"
							maxlength="8"> <span
							class="form-control with-10-00 float-right">N°</span>
					</div>
				</fieldset>
				<fieldset>
					<legend>Proveedor</legend>
					<div class="fila">
						<span class="form-control with-10-00">Nombre</span> <input
							id="rem_codcl" class="form-control with-6-30 campo" type="text"
							maxlength="30">
						<button type="button"
							class="btn blanco form-control with-3-70 campo" id="btn_HcPrv">
							<img src="/img/iconos/glyphicons-28-search.png"
								style="height: auto; filter: invert(55%);">
						</button>
						<input id="prv_nombr" class="form-control with-50-00 prv_campo"
							type="text" maxlength="30"> <span
							class="form-control with-5-00">IVA</span> <select id="prv_cliva"
							class="form-control with-25-00 prv_campo">
							<%=fun.GetHTMLOtion("iva_codig", "iva_nombr", "dbCondIva", "")%>
						</select>
					</div>
					<div class="fila">
						<span class="form-control with-10-00">Telefono</span> <input
							id="prv_telef" class="form-control with-25-00 prv_campo"
							type="text" maxlength="30"> <span
							class="form-control with-10-00">Celular</span> <input
							id="prv_celul" class="form-control with-25-00 prv_campo"
							type="text" maxlength="30"> <span
							class="form-control with-5-00">Doc.</span> <select id="prv_tpdoc"
							class="form-control with-10-00 prv_campo">
							<%=fun.GetHTMLOtion("doc_codig", "doc_nombre", "dbTipoDocumentos", "")%>
						</select> <input id="prv_nrdoc" class="form-control with-15-00 prv_campo"
							type="text" maxlength="11">
					</div>
					<div class="fila">
						<span class="form-control with-10-00">Direción</span> <input
							id="prv_direc" class="form-control with-45-00 prv_campo"
							type="text" maxlength="60"> <span
							class="form-control with-17-00">Cond. de pagos</span> <select
							id="rem_condi" class="form-control with-18-00 campo">
							<%="<option value=\""+Funciones.Contado+"\">Contado</option><option value=\""+Funciones.CtaCorrienta+"\">Cta. Corriente</option>"%>
						</select> <span class="form-control with-5-00">Plazo</span> <input
							id="prv_plazo" class="form-control with-5-00 prv_campo"
							type="text" maxlength="2">
					</div>
				</fieldset>
				<fieldset id="fld_<%=idGrilla %>" class="with-100-00">
					<legend>Detalle</legend>
					<div class="fila gris T-blanco rounded"
						style="height: 40px; padding: 4px 10px;">
						<div class="tool d-none"></div>
						<div class="tool tool-boton" data-modo="ALTA">
							<img src="/img/iconos/glyphicons-433-plus.png"
								style="width: auto; filter: invert(55%);">
							<div class="overlay gris">
								<div class="textimg">Crear</div>
							</div>
						</div>
						<div class="tool tool-boton" data-modo="MODI"
							onclick="formulario.ModRow();">
							<img src="/img/iconos/glyphicons-31-pencil.png"
								style="width: auto; filter: invert(55%);">
							<div class="overlay gris">
								<div class="textimg ">Modificar</div>
							</div>
						</div>
						<div class="tool tool-boton" data-modo="BAJA"
							onclick="formulario.DelRow();">
							<img src="/img/iconos/glyphicons-208-remove.png"
								style="width: auto; filter: invert(55%);">
							<div class="overlay gris">
								<div class="textimg">Eliminar</div>
							</div>
						</div>
					</div>
					<div class="d-block">
						<table id="<%=idGrilla%>"></table>
						<div id="<%=idGrilla%>_pie"></div>
					</div>
				</fieldset>
				<fieldset id="fld_totales" class="with-50-00">
					<legend>Totales</legend>
					<!--div class="fila">
						<input id="rem_fdire" class="form-control with-30-00 campo" type="text" maxlength="60">
						<span class="form-control with-30-00">Neto</span>
					</div>	
					<div class="fila">
						<input id="rem_fdire" class="form-control with-30-00 campo" type="text" maxlength="60">
						<span class="form-control with-30-00">IVA</span>
					</div-->
					<div class="fila">
						<input id="rem_total" class="form-control with-30-00 campo precio"
							type="text" maxlength="60"> <span
							class="form-control with-30-00">Total</span>
					</div>
				</fieldset>
			</div>
		</div>
		<div class="modal-footer">
			<button type="button" class="btn btn-primary" id="btn_confirmar">Guardar
				Cambios</button>
			<button type="button" class="btn btn-secondary" data-dismiss="modal"
				onclick="cerrarFormu('<%=idForm%>');">Cerrar</button>
		</div>
	</div>

	<script type="text/javascript">     
       	var formulario = $.fn.extend($(<%="\"#"+idForm+"\""%>), {
       		modo:"<%=modo%>",      
       		idGrilla:"<%=idGrilla%>",
       		NidGrilla: "#" + "<%=idGrilla%>",
			modoGrilla:"ALTA",
       		GetProveedorRow: function (nroprv=""){       			
            	if(nroprv.toString().trim()==""){
            		$("#rem_codcl",formulario).val(""); 
            		return "";
            	}else{
            		rowprv=JSON.parse(valyget("PRV",nroprv));    
            		switch(rowprv.error){
    	                case "2":
    	                	abrirAlerta("ERR", "Error al tratar de buscar el Proveedor","Error interno");
    	            		$("#rem_codcl",formulario).val(""); 
    	                	return "";
    		                break;
    	                case "1":
    	                	abrirAlerta("NOT", "No se encontro el Proveedor");
    	            		$("#rem_codcl",formulario).val(""); 
    	                	return "";
    		                break;
    	                case "0":
    	                	return rowprv.datos;
    		                break;
    		            default:
    		            	break;
                    }
            	}
            },
       	 	CargarProveedor: function (rowprv={}){
            	$(".prv_campo",this).each(function(){
            		$(this).val(rowprv[$(this).attr('id')]);
            	});
            	if (this.modo=="ALTA" || this.modo=="MODI"){
            		$("#rem_condi",formulario).val(rowprv.prv_condi);
            	}            	
            },       		
            GetArticuloRow: function (nroArt='',codBarra=''){       			
            	if(nroArt.toString().trim()==""){
                	if(codBarra.toString().trim()==""){
                		$("#art_codbr",formulario).val(""); 
                		return "";
                	}else{
                		rowArt=JSON.parse(valyget("ARTB",codBarra));    
                		switch(rowArt.error){
        	                case "2":
        	                	abrirAlerta("ERR", "Error al tratar de buscar el Articulo.","Error interno");
        	            		$("#art_codbr",formulario).val(""); 
        	                	return "";
        		                break;
        	                case "1":
        	                	abrirAlerta("NOT", "No se encontro el Articulo. Vuelva a leer el codigo.");
        	            		$("#art_codbr",formulario).val(""); 
        	                	return "";
        		                break;
        	                case "0":
        	                	return rowArt.datos;
        		                break;
        		            default:
        		            	break;
                        }
                	}
            	}else{
            		rowArt=JSON.parse(valyget("ART",nroArt));    
            		switch(rowArt.error){
    	                case "2":
    	                	abrirAlerta("ERR", "Error al tratar de buscar el Articulo.","Error interno");
    	            		$("#art_codig",formulario).val(""); 
    	                	return "";
    		                break;
    	                case "1":
    	                	abrirAlerta("NOT", "No se encontro el Articulo");
    	            		$("#art_codig",formulario).val(""); 
    	                	return "";
    		                break;
    	                case "0":
    	                	return rowArt.datos;
    		                break;
    		            default:
    		            	break;
                    }
            	}
            },
       	 	CargarArticulo: function (row={}){
       	 		$(".dato").val("");
       	 		for (propiedades in row ){
       	 			$("#"+propiedades,this).val(row[propiedades]);
       	 		}
            },
       	 	ActualizarTotal: function (){
       	 	 	$("#rem_total",formulario).val($(formulario.NidGrilla,formulario).jqGrid('getCol','red_total', false, "sum"));
            },
       	 	ActualizarFormaDePago: function (){
         		
         		var ventamenor=$("#rem_condi",formulario).val()==<%="\""+Funciones.Contado+"\""%>;
         	
				var ids = $(formulario.NidGrilla,formulario).jqGrid('getDataIDs');
				for(var i=0; i<ids.length; i++){
					var obj=$(formulario.NidGrilla,formulario).jqGrid('getRowData', ids[i]);
					if(ventamenor){
						obj.red_preci=obj.red_pmeno;
						obj.red_total=obj.red_tmeno;
	       	 		}else{       	 			
	    				obj.red_preci=obj.red_pmayo;
	    				obj.red_total=obj.red_tmayo;
	       	 		} 
					$(formulario.NidGrilla,formulario).jqGrid("setRowData",ids[i], obj);
				}	
				
				formulario.ActualizarTotal();
       	 		
            },
       	 	getParametros: function (){
       	 		var obj=$(".campo").serializeI();
       	 		obj.jsonGrilla=formulario.GetGrillaJson();
       	 		return obj;       	 
            },
            LimpiarArticulo: function(){
            	$(".dato").val("");
            },
       	 	DelRow: function (){
       	 		var selectedRowId = $(formulario.NidGrilla,formulario).jqGrid("getGridParam", 'selrow');
       	 		if(selectedRowId){
       	 			$(formulario.NidGrilla,formulario).jqGrid('delRowData',selectedRowId);
       	 		}
       	 		formulario.LimpiarArticulo();
            },
            ModRow: function(){
            	formulario.modoGrilla="MODI";
            	var selectedRowId = $(formulario.NidGrilla,formulario).jqGrid("getGridParam", 'selrow');
            	if(selectedRowId){
            		var obj = $(formulario.NidGrilla,formulario).getRowData(selectedRowId);
            		obj.art_codig=obj.red_artic;
            		obj.art_pmeno=obj.red_pmeno;
            		obj.art_pmayo=obj.red_pmayo;
            		obj.art_costo=obj.red_costo;
            		formulario.CargarArticulo(obj);
            	}
            },
       	 	GetGrillaJson: function (){
       	 		return JSON.stringify($(formulario.NidGrilla,formulario).jqGrid("getRowData"));;       	 
            },
            Grilla: function (){	        
    	        $(formulario.NidGrilla,formulario).jqGrid({
    	        	datatype : "jsonstring",
    	        	mtype:'GET', 
    	        	colNames:['Cod Barras','Cant.','Cod.','Grupo','Nombre','STK','Costo','Precio','Subtotal','Precio','Subtotal','Precio','Subtotal'],
    	        	colModel:[
    	        		{name:'art_codbr', index:'art_codbr', width:15, hidden: false},
    	        		{name:'red_canti', index:'red_canti', width:5,  hidden: false, align:'right'},
    	        		{name:'red_artic', index:'red_artic', width:5,  hidden: false,key: true},
    	        		{name:'mar_nombr', index:'mar_nombr', width:25, hidden: false},
    	        		{name:'art_nombr', index:'art_nombr', width:25, hidden: false},
    	        		{name:'art_cstok', index:'art_cstok', width:5,  hidden: false},
    	        		{name:'red_costo', index:'red_costo', width:10, hidden: true, align:'right'},
    	        		{name:'red_pmeno', index:'red_pmeno', width:10, hidden: true, align:'right'},
    	        		{name:'red_tmeno', index:'red_tmeno', width:10, hidden: true , align:'right'},
    	        		{name:'red_pmayo', index:'red_pmayo', width:10, hidden: true, align:'right'},
    	        		{name:'red_tmayo', index:'red_tmayo', width:10, hidden: true, align:'right'},
    	        		{name:'red_preci', index:'red_preci', width:10, hidden: false, align:'right'},
    	        		{name:'red_total', index:'red_total', width:10, hidden: false, align:'right'}
    	        		],
    		        	width: ($("#fld_<%=idGrilla%>",formulario).width()),
    		        	height: 200,
    	        	rowNum:'100',
    	        	datastr: <%=Grilla%>,
    	        	sortname:'red_codig',
    	        	viewrecords:true,
    	        	sortorder:"desc",
    	        	hidegrid:false,
    	        	title:false,	        	
    	        	gridComplete:function(){
    	        		$('tbody [role="row"]').each(function(id, val){
    	        			if(id % 2 == 0){
    	        				$(formulario.NidGrilla + ' #' + id,formulario).css('background-color', 'rgb(224, 224, 224)');
    	        			}
    	        		});
    	        		
    	        		if($("#form",formulario).length<=0){
    	        			$(".ui-jqgrid-bdiv",formulario).prepend(stringFrom);
    	        			$("#form",formulario).width($(<%="\"#fld_"+idGrilla+"\""%>).width()-20);
    	        		}
    	        		
    	        		$("tr.jqgrow.ui-row-ltr.ui-widget-content").first().trigger("click");
    	        		$(formulario.NidGrilla).focus();
    	        	}, 
    	        	ondblClickRow:function(id){
    	        		formulario.ModRow();
    	        		/*var ret = $(formulario.NidGrilla).jqGrid('getRowData', id);
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
            },
            validarForm: function(){
            	if($("#rem_total",formulario).val()=="" ||  parseFloat($("#rem_total",formulario).val())<=0){
            		abrirAlerta("NOT","El importe no puede ser nuelo. Por favor selecciones un articulo.");         			
            		return false;
         		}else{
         			return true;	
         		}
            }
       	});


        $(document).ready(function(){
       		$("#modo",formulario).val("<%=modo%>");       	     
	       	<%=Remito%>
	       	stringFrom="<div id=\"form\" style=\"height: 24px;\"> \n"+
	       	"   	<input id=\"art_codbr\" class=\"form-control dato\" style=\"width: calc( 15% - 7px);\" type=\"text\" placeholder=\"Cod de Barras\"> \n"+
	       	"   	<input id=\"red_canti\" class=\"form-control dato numero\" style=\"width: calc( 5% - 7px);\" type=\"text\" placeholder=\"Cant.\"> \n"+
	       	"   	<input id=\"art_codig\" class=\"form-control dato\" style=\"width: calc( 5% - 7px);\" type=\"text\" placeholder=\"Cod.\">   	   	 \n"+
	       	"   	<button id=\"btn_hcArt\" class=\"form-control dato\" style=\"width: calc( 5% - 7px);\"  type=\"button\" value=\"se apreto\">  \n"+
	       	"   		<img src=\"/img/iconos/glyphicons-28-search.png\" style=\"height: 22px;width: auto;\"> \n"+
	       	"   	</button>   	   \n"+
	       	"   	<input id=\"mar_nombr\" class=\"form-control dato\" style=\"width: calc( 20% - 7px);\"  type=\"text\" placeholder=\"Marca\">  \n"+
	       	"   	<input id=\"art_nombr\" class=\"form-control dato\" style=\"width: calc( 25% - 7px);\"  type=\"text\" placeholder=\"Nombre\"> \n"+
	       	"   	<input id=\"art_pmeno\" class=\"form-control dato\" style=\"width: calc( 15% - 7px);\" type=\"text\" placeholder=\"Precio\"> \n"+
	       	"		<input id=\"art_cstok\" class=\"dato\" type=\"hidden\" value=\"\" >"+
	       	"		<input id=\"art_costo\" class=\"dato\" type=\"hidden\" value=\"\" >"+
	       	"   	<input id=\"art_pmayo\" class=\"form-control dato d-none\" style=\"width: calc( 15% - 7px);\" type=\"text\" value=\"0\" placeholder=\"Precio\"> \n"+
	       	"   	<button id=\"btn_act\" class=\"form-control dato\" style=\"width: calc( 5% - 7px);\" type=\"button\" value=\"se apreto\"> \n"+
	       	"   		<img src=\"/img/iconos/check.svg\" style=\"height: 22px;width: auto;\"> \n"+
	       	"   	</button> \n"+
	       	"</div> \n";
        	$(".campo.precio",formulario).priceFormat({
        	    clearPrefix: true,
        	    clearSuffix: true,
        	    prefix: '$ ',
        	    suffix: '',
        	    limit: 9,
        	    centsLimit: 2,
        	    centsSeparator: '.',
        	    thousandsSeparator: ','
        	});

        	$(".campo.fecha",formulario).datepicker({ 
			    dateFormat: 'dd/mm/yy',
			    firstDay: 1,
				 beforeShow: function() {$('#ui-datepicker-div').maxZIndex(); },
			}).datepicker("setDate", new Date());
        	
        	Remito.forEach(function(value,index){	
        		if (value=="true" || value=="false"){
        			$("#"+index,formulario).first().prop("checked",(value=="true"?true:false));            			
        		}else{
        			$("#"+index,formulario).first().val(value);
        		}	
        	});
        	

        	
        	$(".modal",formulario).draggable();
        	formulario.show();   
        	
        	$("#btn_confirmar",formulario).unbind("click").click(function(){
        		if (true){
        			cargando();
				    $.ajax({
				    	dataType:'json',
				    	data: formulario.getParametros(),
				    	type:'POST',
				    	url:"/<%=idForm%>", 
				    	success:function(data){		
				    		cerrarAlerta();//mensaje cargando
					    	if(data.error !=0){
						    	abrirAlerta("ERR", data.msg);//hubo  un error
					    	}else{
					    		cerrarFormu('<%=idForm%>'); // cierra le fomrulario
					    	}
				    	},
				    	error:function(data){		
				    		cerrarAlerta();
					    	abrirAlerta("ERR", data.msg);
				    	}
				    });
        		}
        	}); 
        	$("#btn_HcPrv",formulario).unbind("click").click(function(){
            	HelpCampo("PRV","#btn_HcPrv",function(row,id){
            				$("#rem_codcl",formulario).val(id);         				
            				formulario.CargarProveedor(row); 
            			});
        	});
        	$("#rem_codcl",formulario).unbind("change").change(function(){
        		formulario.CargarProveedor(formulario.GetProveedorRow(this.value)); 
        	});
        	        	
        	formulario.Grilla();
        	 
         	$("#btn_hcArt",formulario).unbind("click").click(function(){
            	HelpCampo("ART","#btn_hcArt",function(row,id){         				
            				formulario.CargarArticulo(row);             				
            			});
        	});
         	
         	$("#btn_act",formulario).unbind("click").click(function(){
				var obj=$(".dato").serializeI();         	
         		if(obj.red_canti=="" ||  parseFloat(obj.red_canti)<=0){
         			$("#red_canti").abrirpopover("La cantdad tiene que ser mayor a 0.");         			
         		}else{
	         		var ventamenor=$("#rem_condi",formulario).val()==<%="\""+Funciones.Contado+"\""%>;
	         			
					obj.red_artic=obj.art_codig;
					obj.red_pmeno=obj.art_pmeno;
					obj.red_tmeno=round(obj.art_pmeno*parseFloat(obj.red_canti));
					obj.red_pmayo=obj.art_pmayo;
					obj.red_costo=obj.art_costo;
					obj.red_tmayo=round(obj.art_pmayo*parseFloat(obj.red_canti));	
					if($(formulario.NidGrilla).jqGrid('getDataIDs').indexOf(obj.art_codig)==-1){
						if(ventamenor){
							obj.red_preci=obj.red_pmeno;
							obj.red_total=obj.red_tmeno;
		       	 		}else{       	 			
		    				obj.red_preci=obj.red_pmayo;
		    				obj.red_total=obj.red_tmayo;
		       	 		} 
						$(formulario.NidGrilla,formulario).addRowData(obj.art_codig, obj, "last");
					}else{
						var obj2=$(formulario.NidGrilla,formulario).jqGrid('getRowData', obj.art_codig);
						if(formulario.modoGrilla=="ALTA"){
							obj.red_canti = round(parseFloat(obj2.red_canti) + parseFloat(obj.red_canti));
						}
						
						obj.red_tmeno = round(obj.art_pmeno*obj.red_canti);
						obj.red_tmayo = round(obj.art_pmayo*obj.red_canti);
						if(ventamenor){
							obj.red_preci=obj.red_pmeno;
							obj.red_total=obj.red_tmeno;
		       	 		}else{       	 			
		    				obj.red_preci=obj.red_pmayo;
		    				obj.red_total=obj.red_tmayo;
		       	 		} 
						$(formulario.NidGrilla,formulario).jqGrid("setRowData",obj.art_codig, obj);
					}
					formulario.modoGrilla="ALTA";
					formulario.ActualizarTotal();
					
	       	 		formulario.LimpiarArticulo();
         		}
        	});
         	
         	$("#rem_condi",formulario).unbind("change").change(formulario.ActualizarFormaDePago);         	

         	$("#art_codig",formulario).unbind("change").change(function(){
         		formulario.CargarArticulo(formulario.GetArticuloRow(this.value,'')); 
         		if( $(this).val()=="" ) {
         			$(this).focus();
         		}else{
         			$("#red_canti",formulario).focus();
         		}
         	});         	

         	$("#art_codbr",formulario).unbind("change").change(function(){
         		$(this).val(fillZero($(this).val().toString().trim(), 13));
         		formulario.CargarArticulo(formulario.GetArticuloRow('',this.value)); 
         		if( $(this).val()=="" ) {
         			$(this).focus();
         		}else{
         			$("#red_canti",formulario).focus();
         		}
         	}); 
         	
         	$("#red_canti",formulario).unbind("change").change(function(){
         		if(isNaN($(this).val())){
         			$(this).val("0");
         		}
         		$(this).val(round(parseFloat($(this).val())));
         	}); 
         	       
         	var modoTitulo="";
        	switch(formulario.modo){
	        	case "CONS":
	        		modoTitulo="Consultar";	  
	        		$("#btn_confirmar",formulario).hide();
	        		$("#rem_codcl").change();
	        		$("input.campo,input.dato",formulario).prop("readonly",true);
	        		$("select.campo,select.dato,button.campo,button.dato",formulario).prop("disabled",true); 
		        break;
	        	case "BAJA":
	        		modoTitulo="Eliminar";	
	        		$("#rem_codcl").change();	
	        		$("input.campo,input.dato",formulario).prop("readonly",true);
	        		$("select.campo,select.dato,button.campo,button.dato",formulario).prop("disabled",true);        		
		        break;
	        	case "MODI":
	        		modoTitulo="Modificar";	       
	        		$("#rem_codcl").change(); 
		        break;
	        	case "ALTA":
	        		modoTitulo="Crear";	        
		        break;	        
		        default:
			        break;
	        }       

        	$("#Titulo",formulario).html(modoTitulo);
        	
    		$("input.prv_campo, #mar_nombr, #art_nombr",formulario).prop("readonly",true);
    		$("select.prv_campo,button.prv_campo",formulario).prop("disabled",true);
         	
        });
	</script>
</div>