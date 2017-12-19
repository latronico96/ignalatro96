/**
 * jqGrid Spanish Translation
 * Traduccion jqGrid en Español por Yamil Bracho
 * Traduccion corregida y ampliada por Faserline, S.L. 
 * http://www.faserline.com
 * Traduccion corregida y ampliada por Fern&#225;n Castro Asensio
 * Traducci&#243;n corregida y ampliada por Luis S&#225;nchez
 * Dual licensed under the MIT and GPL licenses:
 * http://www.opensource.org/licenses/mit-license.php
 * http://www.gnu.org/licenses/gpl.html
**/
/*global jQuery, define */
(function( factory ) {
	"use strict";
	if ( typeof define === "function" && define.amd ) {
		// AMD. Register as an anonymous module.
		define([
			"jquery",
			"../grid.base"
		], factory );
	} else {
		// Browser globals
		factory( jQuery );
	}
}(function( $ ) {

$.jgrid = $.jgrid || {};
if(!$.jgrid.hasOwnProperty("regional")) {
	$.jgrid.regional = [];
}
$.jgrid.regional["es"] = {
	defaults : {
		recordtext: "Mostrando {0} - {1} de {2}",
	    emptyrecords: "Sin registros que mostrar",
		loadtext: "Cargando...",
		savetext: "Guardando...",
		pgtext : "P&#225;gina {0} de {1}",
		pgfirst : "Primera p&#225;gina",
		pglast : "&#250;ltima p&#225;gina",
		pgnext : "Siguiente p&#225;gina",
		pgprev : "Anterior p&#225;gina",
		pgrecs : "Registros por p&#225;gina",
		showhide: "Alternar Contraer Expandir Grid",
		// mobile
		pagerCaption : "Grid::Configurar p&#225;gina",
		pageText : "P&#225;gina:",
		recordPage : "Registros por p&#225;gina",
		nomorerecs : "No m&#225;s registros...",
		scrollPullup: "Arrastrar arriba para cargar m&#225;s...",
		scrollPulldown : "Arrastrar arriba para refrescar...",
		scrollRefresh : "Soltar para refrescar..."		
	},
	search : {
	    caption: "B&#250;squeda...",
	    Find: "Buscar",
	    Reset: "Limpiar",
	    odata: [{ oper:'eq', text:"igual "},{ oper:'ne', text:"no igual a"},{ oper:'lt', text:"menor que"},{ oper:'le', text:"menor o igual que"},{ oper:'gt', text:"mayor que"},{ oper:'ge', text:"mayor o igual a"},{ oper:'bw', text:"empiece por"},{ oper:'bn', text:"no empiece por"},{ oper:'in', text:"est&#225; en"},{ oper:'ni', text:"no est&#225; en"},{ oper:'ew', text:"termina por"},{ oper:'en', text:"no termina por"},{ oper:'cn', text:"contiene"},{ oper:'nc', text:"no contiene"},{ oper:'nu', text:'es nulo'},{ oper:'nn', text:'no es nulo'}, {oper:'bt', text:'entre'}],
	    groupOps: [	{ op: "AND", text: "todo" },	{ op: "OR",  text: "cualquier" }	],
		operandTitle : "Clic para seleccionar la operaci&#243;n de b&#250;squeda.",
		resetTitle : "Reiniciar valores de b&#250;squeda",
		addsubgrup : "Agregar subgrupo",
		addrule : "Agregar regla",
		delgroup : "Borrar grupo",
		delrule : "Borrar regla"
	},
	edit : {
	    addCaption: "Agregar registro",
	    editCaption: "Modificar registro",
	    bSubmit: "Guardar",
	    bCancel: "Cancelar",
		bClose: "Cerrar",
		saveData: "Se han modificado los datos, ¿guardar cambios?",
		bYes : "Si",
		bNo : "No",
		bExit : "Cancelar",
	    msg: {
	        required:"Campo obligatorio",
	        number:"Introduzca un n&#250;mero",
	        minValue:"El valor debe ser mayor o igual a ",
	        maxValue:"El valor debe ser menor o igual a ",
	        email: "no es una direcci&#243;n de correo v&#225;lida",
	        integer: "Introduzca un valor entero",
		date: "Introduzca una fecha correcta ",
		url: "no es una URL v&#225;lida. Prefijo requerido ('http://' or 'https://')",
		nodefined : " no est&#225; definido.",
		novalue : " valor de retorno es requerido.",
		customarray : "La funci&#243;n personalizada debe devolver un array.",
		customfcheck : "La funci&#243;n personalizada debe estar presente en el caso de validaci&#243;n personalizada."
		}
	},
	view : {
	    caption: "Consultar registro",
	    bClose: "Cerrar"
	},
	del : {
	    caption: "Eliminar",
	    msg: "¿Desea eliminar los registros seleccionados?",
	    bSubmit: "Eliminar",
	    bCancel: "Cancelar"
	},
	nav : {
	    edittext: " ",
	    edittitle: "Modificar fila seleccionada",
	    addtext:" ",
	    addtitle: "Agregar nueva fila",
	    deltext: " ",
	    deltitle: "Eliminar fila seleccionada",
	    searchtext: " ",
	    searchtitle: "Buscar informaci&#243;n",
	    refreshtext: "",
	    refreshtitle: "Recargar datos",
	    alertcap: "Aviso",
	    alerttext: "Seleccione una fila",
		viewtext: "",
		viewtitle: "Ver fila seleccionada",
		savetext: "",
		savetitle: "Guardar fila",
		canceltext: "",
		canceltitle : "Cancelar edici&#243;n de fila",
		selectcaption : "Acciones..."
	},
	col : {
	    caption: "Mostrar/ocultar columnas",
	    bSubmit: "Enviar",
	    bCancel: "Cancelar"	
	},
	errors : {
		errcap : "Error",
		nourl : "No se ha especificado una URL",
		norecords: "No hay datos para procesar",
	    model : "Las columnas de nombres son diferentes de las columnas del modelo"
	},
	formatter : {
		integer : {thousandsSeparator: ".", defaultValue: '0'},
		number : {decimalSeparator:",", thousandsSeparator: ".", decimalPlaces: 2, defaultValue: '0,00'},
		currency : {decimalSeparator:",", thousandsSeparator: ".", decimalPlaces: 2, prefix: "", suffix:"", defaultValue: '0,00'},
		date : {
			dayNames:   [
				"Do", "Lu", "Ma", "Mi", "Ju", "Vi", "Sa",
				"Domingo", "Lunes", "Martes", "Miércoles", "Jueves", "Viernes", "S&#225;bado"
			],
			monthNames: [
				"Ene", "Feb", "Mar", "Abr", "May", "Jun", "Jul", "Ago", "Sep", "Oct", "Nov", "Dic",
				"Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"
			],
			AmPm : ["am","pm","AM","PM"],
			S: function (j) {return j < 11 || j > 13 ? ['st', 'nd', 'rd', 'th'][Math.min((j - 1) % 10, 3)] : 'th'},
			srcformat: 'Y-m-d',
			newformat: 'd-m-Y',
			parseRe : /[#%\\\/:_;.,\t\s-]/,
			masks : {
	            ISO8601Long:"Y-m-d H:i:s",
	            ISO8601Short:"Y-m-d",
	            ShortDate: "n/j/Y",
	            LongDate: "l, F d, Y",
	            FullDateTime: "l, F d, Y g:i:s A",
	            MonthDay: "F d",
	            ShortTime: "g:i A",
	            LongTime: "g:i:s A",
	            SortableDateTime: "Y-m-d\\TH:i:s",
	            UniversalSortableDateTime: "Y-m-d H:i:sO",
	            YearMonth: "F, Y"
	        },
	        reformatAfterEdit : false,
			userLocalTime : false
		},
		baseLinkUrl: '',
		showAction: '',
	    target: '',
	    checkbox : {disabled:true},
		idName : 'id'
	},
	colmenu : {
		sortasc : "Ordenar ascendentemente",
		sortdesc : "Ordenar descendientemente",
		columns : "Columnas",
		filter : "Filtrar",
		grouping : "Agrupar por",
		ungrouping : "Desagrupar",
		searchTitle : "Obtener elementos con un valor que:",
		freeze : "Congelar",
		unfreeze : "Descongelar",
		reorder : "Mover para reordenar"
	}
};
}));
