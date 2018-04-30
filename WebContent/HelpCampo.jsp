<%@page import="funciones.Funciones"%>
<%@page import="helpCampos.HelpCampo"%>
<%@page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.ResultSet"%>
<%@ page import ="java.util.Map"%>    
<%	Funciones fun = new Funciones(request);

	String filtExt=(String) request.getAttribute("filtExt");
	HelpCampo hc=(HelpCampo) request.getAttribute("hc"); //para llamar a los pametros	
	String BusqValparam =((String) request.getAttribute("BusqVal")).trim();
	String BusqCamparam =((String) request.getAttribute("BusqCam")).trim();
	String BusqVal ="";
	String BusqCam ="";
	if (BusqValparam==null){
		BusqVal = "1";
		BusqCam = "2";
	}
	
	String todo = hc.getColum().get("todos");
	if (todo!=null){
		BusqVal = "1";
		BusqCam = "1";
	}
%>
<script>
	var campo ='<%=hc.getCampo()%>';
	var filtro=0;
	
	function HC_Aceptar() {
	 	var id = $("#GrillaHelpCampo").jqGrid('getGridParam','selrow');
	 	HC_ProcesarId(id);
	} 
	
	function HC_ValCampo(row={},campo=""){
		
	}
	
	function HC_ProcesarId(id=false ) {
		if (id) {
			var ret = $("#GrillaHelpCampo").jqGrid('getRowData',id);		
			var idselect = ret[campo];	
		   bloquear(false);	
		   HC_ValCampo(ret,idselect);
		} 
	}

	function HC_Grilla(){
		$("#GrillaHelpCampo").jqGrid({
			url:"HelpCampo",
			datatype : "json",
			mtype : 'POST',
			colNames : [ <%=hc.getColum().get("names") %> ],
			colModel : [ <%=hc.getColum().get("colum") %>],
			width : <%=hc.getColum().get("ancho") %>,
			height : 400,
			rowNum : 200,
			pager : '#pagerhc',
			sortname : '<%=hc.getColum().get("ordCampo") %>',
			viewrecords : true,
			sortorder : '<%= hc.getColum().get("ordMetodo") %>',
			hidegrid : false,
			title : false,
			rows: <%=hc.getRows() %>,
			dataEvents:  $("#GrillaHelpCampo").bind('keydown',function(e) {
				var TeclasPer = "abcdefghijklmnñopqrstuvwxyzABCDEFGHIJKLMNÑOPQRSTUVWXYZ1234567890., ";	
				if ((TeclasPer.search(e.key) >= 0) || (e.which == 8)) {
					$("#frm_HelpCampo #BusquedaValor").focus();
				}												
			}) ,
			gridComplete: function (){
				$('#frm_HelpCampo tbody [role="row"]').each(
						function(id,val){ if(id%2==0){ 
							$('#frm_HelpCampo #'+id).css('background-color','rgb(224, 224, 224)');} 
						} );
				$("tr.jqgrow.ui-row-ltr.ui-widget-content").first().trigger( "click");
				$("#GrillaHelpCampo").focus(); 
				$("#frm_HelpCampo #BusquedaCampo").val($("#GrillaHelpCampo").jqGrid('getGridParam','sortname'));
					
			},
			ondblClickRow : function(id) { HC_ProcesarId(id); },
			caption : "",
			postData : {
				tipo:			'<%=hc.getColum().get("tipo") %>',
				filtExt: '<%=filtExt %>',
				filtro:			filtro,  
				BusquedaValor : '<%=BusqValparam %>',
				BusquedaCampo : '<%=BusqCamparam %>' },
				jqGridHeaderClick : function(rowid, status, e) {
			} 
		});
	
		$("#GrillaHelpCampo").jqGrid('navGrid', '#pagerhc', {edit : false, add : false, del : false }); 
			
		$("#GrillaHelpCampo").jqGrid('bindKeys', {"onEnter" : function(id) { HC_ProcesarId(id); } } );
			
		$("<%= hc.getColum().get("busc") %>").insertAfter("#headerhcmodal");
			
		$(".ui-jqgrid-titlebar").hide();
	
		$("#frm_HelpCampo #BusquedaValor").bind('keydown', function(e) {			
			switch (e.which) {				
				case 13:
					HC_ActualizarParametros();
					break;				
			}
		});
	
		$("#BusquedaValor").val("<%=((BusqValparam==null || todo!=null)?"":BusqValparam.trim()) %>");
	}

	function HC_ActualizarParametros() {
		$("#GrillaHelpCampo").jqGrid('setGridParam',{ 
			postData : {		
				tipo:			'<%= hc.getColum().get("tipo") %>',
				filtExt: '<%=filtExt %>',
				filtro:			filtro,  
				BusquedaValor : $("#frm_HelpCampo #BusquedaValor").val(),
				BusquedaCampo : $("#frm_HelpCampo #BusquedaCampo").val()
			} 
		}).trigger("reloadGrid");
	}
</script>
<div id="frm_HelpCampo" data-popup="true" class="backmodal formulario">
	<style type="text/css">
		/*#frm_HelpCampo #form {
			position: relative;
			-moz-box-sizing: content-box;
			-webkit-box-sizing: content-box;
			box-sizing: content-box;
			margin: 0px auto;
			width: 100%;
			z-index: 1;    
			height: 100%;
    		max-height: 17px;
		}*/
		
		/*#frm_HelpCampo #jqgridSearchForm {
			position: relative;
			-moz-box-sizing: content-box;
			-webkit-box-sizing: content-box;
			box-sizing: content-box;
			margin: 0px auto;
			width: 100%;
			z-index: 1;
			height: 18.5px;
		}*/
		#frm_HelpCampo .busqGrill *{
			float:left;
		}
		
		#frm_HelpCampo>div {
			width: calc(<%= hc.getColum().get("ancho") %>px + 20px );
			margin-top: 20px;
		}
	</style>
	<div class="modal" data-tmodal="alerta">
		<div class="modal-header" id="headerhcmodal">
			<h5 class="modal-title"><%= hc.getColum().get("titulo") %></h5>
			<button type="button" type="button" class="close" onclick="bloquear(false);">
				<span aria-hidden="true">&times;</span>
			</button>
		</div>
		<div class="modal-body">
			<div style="margin: auto; padding-left: 0px;" >	
				<table id="GrillaHelpCampo"></table>
				<div id="pagerhc"></div>
				<script type="text/javascript">HC_Grilla();</script>				
			</div>		
		</div>				
		<div class="modal-footer" id="footer-btn" style="background: #ffffff;padding: 5px;border-bottom-left-radius: 5px;border-bottom-right-radius: 5px;">
			<button type="button" class="btn btn-secondary" style="margin-left:0px;" data-dismiss="modal" onclick="bloquear(false);">Salir</button>
			<button type="button" class="btn btn-primary" style="margin-left:5px;" onclick="HC_Aceptar();">Ok</button>
		</div>
	</div>
</div>	
	
