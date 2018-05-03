$(document).bind('keydown',function(e){
	
	switch (e.which) {
		case 27: //[ESC]
			teclaEsc();
			break;
	}
	
});

function cargando(){
	abrirAlerta("","","Cargando...","");
}
function abrirAlerta(tipo,msg="",titulo="",cfocus=""){//ABRE MODAL ALERTA DE TIPOS (ERROR-NOTIFICACIÓN)
	
	if(titulo==""){	
		switch (tipo) {
			case "ERR":
				titulo="Error";
				break;
			case "NOT":
				titulo="Atención";
				break;
		}
	}
	
	if(msg.trim()!=""){
		msg='<div class="modal-body">'+msg.trim()+'.</div>';
	}
	
	$("#bloqueoAlerta").html(
	                         '<div class="modal modal-alerta" data-tmodal="alerta"> '+
	                         ' 	<div class="modal-head"> '+
	                         ' 		<h5 class="modal-title">'+titulo+'</h5> '+
	                         ' 		<button type="button" class="close" onclick="cerrarAlerta('+cfocus+');"> '+
	                         ' 			<span aria-hidden="true" >x</span> '+
	                         ' 		</button> '+
	                         ' 	</div> '+msg+
	                         ' 	<div class="modal-foot"> '+
	                         ' 		<button id="btnCerrarAlerta" type="button" class="btn btn-gris" onclick="cerrarAlerta('+cfocus+');">Cerrar</button> '+
	                         ' 	</div> '+
	                         '</div>'
	);
	
	$(".modal").draggable();
	$("#bloqueoAlerta").show();
	
}

function cerrarAlerta(cfocus=""){//CIERRA MODAL ALERTA EJECUTANDO FOCUS
	
	$("#bloqueoAlerta [data-tmodal='alerta']").last().remove();
	
	if(cfocus!=""){
		$(cfocus).focus();
	}
	
	$("#bloqueoAlerta").hide();
	
}

function abrirPregunta(preg,funcionOk=function(){},funcionNo=function(){}){//ABRE MODAL DE TIPO PREGUNTA (FUNCION CONFIRMACION,CANCELACION)
	/*
	if(funcionOk.name===undefined){		
	}else{
		funcionOk=funcionOk.name;
	}
	
	if(funcionNo.name===undefined){		
	}else{
		funcionNo=funcionNo.name;
	}*/
	
	$("#bloqueoAlerta").html(
	                         '<div class="modal modal-pregunta" data-tmodal="pregunta"> '+
	                         '	<div class="modal-head"> '+
	                         '		<h5 class="modal-title">Seguro que...</h5> '+
	                         '	</div> '+
	                         '	<div class="modal-body"> '+
	                         '		¿'+preg+'? '+
	                         '	</div> '+
	                         '	<div class="modal-foot"> '+
	                         '		<button id="btnConfirmarPregunta" type="button" class="btn btn-azul">Si</button> '+
	                         '		<button id="btnCerrarPregunta" type="button" class="btn btn-gris">No</button> '+
	                         '	</div> '+
	                         '</div>'
	);
		
	$("#bloqueoAlerta #btnConfirmarPregunta").unbind("click").click({funcionOk: funcionOk },okPregunta);


	$("#bloqueoAlerta #btnCerrarPregunta").unbind("click").click({funcionNo: funcionNo },cerrarPregunta);

	$(".modal").draggable();
	$("#bloqueoAlerta").show();
	
}

function cerrarPregunta(event){//CIERRA Y EJECUTA FUNCION DE CANCELACIÓN EN MODAL TIPO PREGUNTA
	
	$("#bloqueoAlerta [data-tmodal='pregunta']").last().remove();
	$("#bloqueoAlerta").hide();

	event.handleObj.data.funcionNo();
	
}

var formularios=[];
var formulario={};
function abrirFormulario(parametros={}){// parametros.url parametros.parametros
	if(parametros!={}){
    	cargando();
    	formularios[formularios.length]=formulario;
		$.ajax({
			type:'GET',//todos los 
			url: parametros.url,		
			data: parametros.parametros,
			success: function(data) {
	    		cerrarAlerta();
	    		if($(data).data("popup")){
					$(document.body).append($(data));	
					$(".modal").draggable();
					$(data).show();  			    			
	    		}else{
	    			cerrarFormu();
					$("#Cuerpo").html($(data));
	    		}   
    		}, 
    		error:function(data){        			
	    		cerrarAlerta();
    	    	console.log(data);
    		}
    	});				
	}
}

function cerrarFormu(formu="",funcion=""){//CIERRA Y EJECUTA FUNCION DE CANCELACIÓN EN MODAL TIPO PREGUNTA
	if (formularios.length>1){
		if(formu==""){
			formu=$(".formulario").last().attr("id");		
		}
		formulario=formularios.pop();
			//(formularios.length-2<0?undefined:formularios[formularios.length-1]);		
		$("#"+formu).last().remove();
		$(".popover").popover("hide");
		$("table.ui-jqgrid-btable.ui-common-table",$(".formulario").last()).trigger( 'reloadGrid' );
		if(funcion!=""){
			funcion();
		}
	}
}


function okPregunta(event){//CIERRA Y EJECUTA FUNCION DE CONFIRMACIÓN EN MODAL TIPO PREGUNTA
  
	$("#bloqueoAlerta [data-tmodal='pregunta']").last().remove();
	$("#bloqueoAlerta").hide();
	console.log(JSON.stringify(event));
	event.handleObj.data.funcionOk();
	
}

function teclaEsc(){//CIERRA EN ORDEN: MODAL (ALERTA-PREGUNTA-LOADING); FORMULARIOS
	var ok = true;
	
	//SI HAY MODAL ALERTA (APRETA EL BOTÓN POR SI TIENE FUNCION DE EJECUCIÓN)
	if(ok && $("#bloqueoAlerta [data-tmodal='alerta']").length>0){
		$("#bloqueoAlerta [data-tmodal='alerta'] #btnCerrarAlerta").click();
		ok=false;
	}
	
	//SI HAY MODAL PREGUNTA (APRETA EL BOTÓN POR SI TIENE FUNCION DE EJECUCIÓN)
	if(ok && $("#bloqueoAlerta [data-tmodal='pregunta']").length>0){
		$("#bloqueoAlerta [data-tmodal='pregunta'] #btnCerrarPregunta").click();
		ok=false;
	}
	
	//SI BLOQUEO ESTA ACTIVADO	
	if(ok && $("#bloqueoAlerta").css("display")=="block"){
		$("#bloqueoAlerta").hide();
		ok=false;
	}
	
	return ok;
}
function fillZero(str, max) {
	str = str.toString();
	return (str.length < max ? fillZero("0" + str, max) : str);
}


function reSizeGrid(idGrid,width,height){
	$("#"+idGrid).jqGrid('setGridWidth', width).jqGrid('setGridHeight', height);	
}

$.extend($.fn.fmatter , {
	FormatClient : function(cellvalue, options, rowdata) {
		return fillZero(cellvalue,4);
	}	
});

$.extend($.fn.fmatter.FormatClient , {
	unformat : function(cellvalue, options) {
		return parseInt(cellvalue);
	}
});

$.extend($.fn.fmatter , {
	FormatActivo : function(cellvalue, options, rowdata) {
		if (cellvalue=="1"){
			return "<img src=\"img/iconos/glyphicons-153-check.png\" style=\"height: auto;width: 22px;\">";
		}else{
			return "<img src=\"img/iconos/glyphicons-198-remove-circle.png\" style=\"height: auto;width: 18px;\">";
		}
	}	
});

$.extend($.fn.fmatter.FormatActivo , {
	unformat : function(cellvalue, options,cellObject) {
		if ($($(cellObject).html())=="<img src=\"img/iconos/glyphicons-153-check.png\" style=\"height: auto;width: 22px;\">"){
			return "1";
		}else{
			return "0";
		}
	}
});

function formatImage(cellValue, options, rowObject) {
	if (cellValue=="1"){
		var imageHtml =  "<img src=\"img/iconos/glyphicons-153-check.png\" style=\"height: auto;width: 22px;\" originalValue='" + cellValue + "' >";
	}else{
		var imageHtml =  "<img src=\"img/iconos/glyphicons-198-remove-circle.png\" style=\"height: auto;width: 18px;\" originalValue='" + cellValue + "' >";
	}
    return imageHtml;
}

function unformatImage(cellValue, options, cellObject) {
    return $($(cellObject).html()).attr("originalValue");
}

function funciones(nombre,arg1=[],funcionSuccess=''){//devuelve resultados de las funciones declaradas en Funciones.java
	//Declarar los parametros de la funcion como:
	// var arg =['valor','tipo','valor','tipo']; en el orden que se los declara en las funciones
	//Con alguno de los siguientes tipos : 
	// int, String, boolean, HttpServletRequest, double, float, long
	//Despues llamar a la funcion:
	// funciones("nombre de la funcion", arg)
	var js=JSON.stringify({nombre: nombre ,parametro:arg1});
	var x="";
	$.ajax({
		url:'funciones',
		type:'GET',
		data:{js:js},
		success: function(data){
			if (isBoolean(data.trim())){
				x = stringToBoolean(data.trim());
			}else{
				x = data.trim();
			}
			if(funcionSuccess!=''){
				funcionSuccess();
			}
		},	
		async:false
	});
	return x;
	
}

function valyget(cod,id,funcionSuccess=''){
	return funciones("ValyGet",[cod,'String',id.toString(),'String'],funcionSuccess);
}

function NuevoUsuario(usu,con){	
	return funciones("NuevoUsuario",[usu,'String',con,'String']);
}

$.fn.extend(
            $.fn.validar = function(validaciones={}){
            	var ret=true;
            	
            	$(this).each(function(){
            		var mensaje="";
            		if( ($(this).filter(":enabled").prop("tagName")=="INPUT" && $(this).prop("type")!="hidden" ) || $(this).prop("tagName")=="SELECT"){
            			if(validaciones.hasOwnProperty("noVacio") && $(this).val()==""){
            				ret=true; //no puede quedar vacio
            				mensaje="Este campo no puede quedar vacio.";
            			}
            			if(ret && validaciones.hasOwnProperty("largoMinimo") && $(this).val().length<=validaciones.largoMayor){        			
            				ret=true; //largo minimo
            				mensaje="El valor de este campo tiene que ser mayor a "+validaciones.largoMayor+" caracteres.";
            			}
            			if(ret && validaciones.hasOwnProperty("largoMaximo") && $(this).val().length>validaciones.largoMenor){      			
            				ret=true;//largo maximo
            				mensaje="El valor de este campo tiene que ser menor o igual a "+validaciones.largoMenor+" caracteres.";
            			}
            			if(ret && validaciones.hasOwnProperty("esNumero") && $.isNumeric($(this).val())){        			
            				ret=true;//numerica
            				mensaje="En este campo solo se pueden ingresar numeros.";
            			}
            			if(ret && validaciones.hasOwnProperty("noCero") && parseFloat($(this).val())!=0){        			
            				ret=true;//numerica
            				mensaje="En este campo no puede ser cero.";
            			}
            			
            			if(ret){
            				$(this).abrirpopover(mensaje);
            				return false;
            			}
            		}
            		
            	});
            	
            	return (ret?this:false);
            }
);

$.fn.extend(	
            $.fn.validarData = function(){
            	var ret=true;		
            	$(this).each(function(){
            		ret=$(this).validar($(this).data); //valida pero trae las validaciones desde el data del obj
            		return ret;//si es true sigue con el otro sino corta el ciclo
            	});		
            	return (ret?this:false); //si no se cumplieron todas las validaciones devuelve falso sino
            }
);

$.fn.extend(
            $.fn.abrirpopover = function(mensaje){	
            	if($(this).size()>0){
            		$(".popover").popover("hide");//antes de borrar alguno lo borro
            		$(this).popover({html:true, trigger:"manual"});
            		var popover = $(this).data('bs.popover');
            		popover.config.content = mensaje;
            		$(this).popover('show');
            		$(this).focus(function(){
            			$(this).popover("hide");
            		});
            	}
            	return this;
            }
);



$.fn.extend(
            $.fn.size = function(){				
            	return ($(this).length);
            }
);

$.fn.extend(
            $.fn.serializeI = function(){	
            	var conjunto=$(this); 
            	result = new Object();
            	conjunto.each(function(){
            		if(this.type=="checkbox"){
            			result[$(this).attr('id')]=(this.checked?1:0);            		
            		}else if (this.type=="radio" && $(this).is(":checked")){
            			result[$(this).attr('id')]=$(this).val(); 
            		}else{
            			result[$(this).attr('id')]=$(this).val();            			
            		}            		
            	});
            	/*
          		var checkboxes = conjunto.filter('input[type="checkbox"]');          		
    			$.each( checkboxes, function( key, value ) {
    			    if (value.checked === false) {
    			        value.value = 0;
    			    }else{
    			        value.value = 1;
    			    }
    			    $(value).attr('type', 'hidden');
    			});
    			var disabled = conjunto.filter(':disabled').prop("disabled",false);
    			param=conjunto.filter(':not(.precio)').serialize();
    			$.each(conjunto.filter('.precio'), function( key, value ) {
    				param += (param==""?"":"&");
    				param += $(this).attr("id")+"="+$(this).priceToFloat();
    			});
    			checkboxes.attr("type","checkbox");
    			disabled.prop("disabled",true);*/
            	return ((result));
            }
);

function stringToBoolean(string){
	switch(string.toLowerCase().trim()){
		case "true": case "yes": case "1": case "si": return true;
		case "false": case "no": case "0": case "no": case null: return false;
		default: return Boolean(string);
	}
}
function isBoolean(string){
	switch(string.toLowerCase().trim()){
		case "true":  return true;
		case "false":  return true;
		default: return false;
	}
}

$( document ).ajaxComplete(function( event, xhr, settings){	
	switch( xhr.getAllResponseHeaders().indexOf("index") )
	{
		case 95: //here you do whatever you need to do
			//when does a redirection
			location.reload()
			break;
		case -1: //here you handle the calls to dead pages
			//alert("Page Not Found");
			break;
	}
});

$.ajaxSetup({
	dataType: "html"
});

function HelpCampo(cod,inpuId="",funcionId="",filtExt="",BusqVal="",BusqCam="",pop=false){
	var FuncionValidacion;
	var pag="HelpCampo";	
	var contenedor="";
	
	if (funcionId==""){				
		function FuncionValidacion(row,id){
			$(inpuId).val(id);
			$(inpuId).change();
		}
	}else{
		FuncionValidacion=funcionId;
	}
	
	if (contenedor==""){
		contenedor="bloqueoAlerta";
	}
	
	$.ajax({
		type:'GET',
		url: pag ,
		data:{tipo: cod, filtExt: filtExt, BusqVal: BusqVal, BusqCam: BusqCam},
		dataType: "text",
		success:function(data){	   
			var res=data;		   
			$("#bloqueoAlerta").html(res); /*alert("se envio");*/
			//$("#bloqueoAlerta").css("display","block");
			$("#frm_HelpCampo,#bloqueoAlerta").show()
			HC_ValCampo=FuncionValidacion;
		}
	});
	
	
}

function bloquear(flag){
	if (flag){
		document.getElementById('bloqueoAlerta').style.display="block";
	}
	else{
		document.getElementById('bloqueoAlerta').style.display="none";
		document.getElementById('bloqueoAlerta').innerHTML="";
		teclaEsc();
	}
}

$.maxZIndex = $.fn.maxZIndex = function(opt) {
    /// <summary>
    /// Returns the max zOrder in the document (no parameter)
    /// Sets max zOrder by passing a non-zero number
    /// which gets added to the highest zOrder.
    /// </summary>    
    /// <param name="opt" type="object">
    /// inc: increment value, 
    /// group: selector for zIndex elements to find max for
    /// </param>
    /// <returns type="jQuery" />
    var def = { inc: 10, group: "*" };
    $.extend(def, opt);
    var zmax = 0;
    $(def.group).each(function() {
        var cur = parseInt($(this).css('z-index'));
        zmax = cur > zmax ? cur : zmax;
    });
    if (!this.jquery)
        return zmax;

    return this.each(function() {
        zmax += def.inc;
        $(this).css("z-index", zmax);
    });
}

function round(num, decimales = 2) {
    var signo = (num >= 0 ? 1 : -1);
    num = num * signo;
    if (decimales === 0) //con 0 decimales
        return signo * Math.round(num);
    // round(x * 10 ^ decimales)
    num = num.toString().split('e');
    num = Math.round(+(num[0] + 'e' + (num[1] ? (+num[1] + decimales) : decimales)));
    // x * 10 ^ (-decimales)
    num = num.toString().split('e');
    
    return signo * (num[0] + 'e' + (num[1] ? (+num[1] - decimales) : -decimales));
}

function number_format(amount, decimals) {
    amount += ''; // por si pasan un numero en vez de un string
    amount = parseFloat(amount.replace(/[^0-9\.]/g, '')); // elimino cualquier cosa que no sea numero o punto
    decimals = decimals || 0; // por si la variable no fue fue pasada
    // si no es un numero o es igual a cero retorno el mismo cero
    if (isNaN(amount) || amount === 0) 
        return parseFloat(0).toFixed(decimals);
    // si es mayor o menor que cero retorno el valor formateado como numero
    amount = '' + amount.toFixed(decimals);
    var amount_parts = amount.split('.'),
        regexp = /(\d+)(\d{3})/;
    while (regexp.test(amount_parts[0]))
        amount_parts[0] = amount_parts[0].replace(regexp, '$1' + ',' + '$2');
    return amount_parts.join('.').replace(/[^0-9\.]/g, '');
}
