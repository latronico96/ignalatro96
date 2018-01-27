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
function abrirAlerta(tipo,msg,titulo="",cfocus=""){//ABRE MODAL ALERTA DE TIPOS (ERROR-NOTIFICACIÓN)

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

function abrirPregunta(preg,funcionOk,funcionNo=""){//ABRE MODAL DE TIPO PREGUNTA (FUNCION CONFIRMACION,CANCELACION)
	
	if(funcionOk.name===undefined){		
	}else{
		funcionOk=funcionOk.name;
	}
	
	if(funcionNo.name===undefined){		
	}else{
		funcionNo=funcionNo.name;
	}
	
	$("#bloqueoAlerta").html(
		'<div class="modal modal-pregunta" data-tmodal="pregunta"> '+
		'	<div class="modal-head"> '+
		'		<h5 class="modal-title">Seguro que...</h5> '+
		'	</div> '+
		'	<div class="modal-body"> '+
		'		¿'+preg+'? '+
		'	</div> '+
		'	<div class="modal-foot"> '+
		'		<button type="button" class="btn btn-azul" onclick="okPregunta('+funcionOk+');">Confirmar</button> '+
		'		<button id="btnCerrarPregunta" type="button" class="btn btn-gris" onclick="cerrarPregunta('+funcionNo+');">Cancelar</button> '+
		'	</div> '+
		'</div>'
	);

    $(".modal").draggable();
	$("#bloqueoAlerta").show();

}

function cerrarPregunta(funcion=""){//CIERRA Y EJECUTA FUNCION DE CANCELACIÓN EN MODAL TIPO PREGUNTA

	$("#bloqueoAlerta [data-tmodal='pregunta']").last().remove();
	$("#bloqueoAlerta").hide();

	if(funcion!=""){
		funcion();
	}

}

function cerrarFormu(formu='',funcion=''){//CIERRA Y EJECUTA FUNCION DE CANCELACIÓN EN MODAL TIPO PREGUNTA

	$("#"+formu).last().remove();

	if(funcion!=""){
		funcion();
	}

}

function okPregunta(funcion=""){//CIERRA Y EJECUTA FUNCION DE CONFIRMACIÓN EN MODAL TIPO PREGUNTA

	$("#bloqueoAlerta [data-tmodal='pregunta']").last().remove();
	$("#bloqueoAlerta").hide();

	if(funcion!=""){
		funcion();
	}

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
	  return str.length < max ? fillZero("0" + str, max) : str;
	}


function reSizeGrid(idGrid,width,height){
	$("#"+idGrid).jqGrid('setGridWidth', width).jqGrid('setGridHeight', height);	
}

$.extend($.fn.fmatter , {
    FormatCliente : function(cellvalue, options, rowdata) {
    return fillZero(cellvalue,3);
}
});

$.extend($.fn.fmatter.FormatCliente , {
    unformat : function(cellvalue, options) {
    return parseInt(cellvalue);
}
});

function funciones(nombre,arg1=[]){//devuelve resultados de las funciones declaradas en Funciones.java
	//Declarar los parametros de la funcion como:
	// var arg =['["valor"','"tipo"','"valor"','"tipo"...]']; en el orden que se los declara en las funciones
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
		},	
		async:false
	});
	return x;
	
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
			$("input,select").popover("hide");//antes de borrar alguno lo borro
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
    			var param=$(this).serialize();
    			checkboxes.attr("type","checkbox");
    			disabled.prop("disabled",true);
        		return (param);
            }
        );

function stringToBoolean(string){
    switch(string.toLowerCase().trim()){
        case "true": case "yes": case "1": return true;
        case "false": case "no": case "0": case null: return false;
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
