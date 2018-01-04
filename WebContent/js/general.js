$(document).bind('keydown',function(e){
		
		switch (e.which) {
			case 27: //[ESC]
				teclaEsc();
			break;
		}
	    
	});

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
	$("#bloqueoAlerta").html(
		'<div class="modal modal-alerta" data-tmodal="alerta"> '+
		' 	<div class="modal-head"> '+
		' 		<h5 class="modal-title">'+titulo+'</h5> '+
		' 		<button type="button" class="close" onclick="cerrarAlerta('+cfocus+');"> '+
		' 			<span aria-hidden="true" >×</span> '+
		' 		</button> '+
		' 	</div> '+
		' 	<div class="modal-body"> '+
		' 		'+msg+'. '+
		' 	</div> '+
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