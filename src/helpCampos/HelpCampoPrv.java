package helpCampos;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import funciones.Funciones;

public class HelpCampoPrv extends HelpCampo {
	
	
	public  HelpCampoPrv(Funciones func, HttpServletRequest req, String campo, String OrdenarCampo, String OrdenarMetodo, String Pagina, String CntRows, 
			 		String search_campo,  String search_oper,  String search_valor, String BusquedaValor, String BusquedaCampo,String FiltExt){
		this.fun=func;
		
		this.campo = "prv_codig";
		this.ordenarMetodo = "asc";
		this.pagina = "1";
		this.cntRows = "10";	
		this.search_campo =search_campo;	
		this.search_oper = search_oper;	
		this.search_valor = search_valor;	
		this.busquedaValor =BusquedaValor;	
		this.busquedaCampo = BusquedaCampo;	
		this.filtExt = FiltExt;	
		
		
		this.setCampo(campo);
		this.setOrdenarCampo(OrdenarCampo);
		this.setOrdenarMetodo(OrdenarMetodo);
		this.setPagina(Pagina);
		this.setCntRows(CntRows);
	}
	
	public  HelpCampoPrv(Funciones func, HttpServletRequest req){
		this.fun=func;
		
		this.campo = "prv_codig";
		this.setOrdenarCampo(campo);
		this.ordenarMetodo = "asc";
		this.pagina = "1";
		this.cntRows = "10";			
	}

	@Override
	public String getTabla (){
		String consulta = "";
		
		 try {// the sql server url	
			consulta="select prv_codig, \n"
						+ "	CASE WHEN trim(ifnull(prv_fnomb,''))='' THEN prv_nombr ELSE prv_fnomb END as prv_nombr,\n"
						+ "	CASE WHEN trim(ifnull(prv_ftele,''))='' THEN prv_telef ELSE prv_ftele END as prv_telef, \n"
						+ "	CASE WHEN trim(ifnull(prv_fcelu,''))='' THEN prv_celul ELSE prv_fcelu END as prv_celul, \n"
						+ "	CASE WHEN trim(ifnull(prv_fdire,''))='' THEN prv_direc ELSE prv_fdire END as prv_direc, \n"
						+ "	iva_nombr,prv_cliva,prv_tpdoc,prv_condi, \n"
						+ "	convert( CASE WHEN trim(ifnull(prv_fndoc,''))='' THEN prv_nrdoc ELSE prv_fndoc END,char)  as prv_nrdoc, \n"
						+ "	prv_plazo,prv_email \n"
						+ "from dbproveedores \n"
						+ "	left join dbCondIva on (iva_codig=CASE WHEN trim(ifnull(prv_fciva,''))='' THEN prv_cliva ELSE prv_fciva END) \n"
						+ "left join dbTipoDocumentos on ( doc_codig =CASE WHEN trim(ifnull(prv_fndoc,''))='' THEN prv_tpdoc ELSE prv_ftdoc END) "
						+ "  "+this.getFiltro() +"\n"
								+ " ORDER BY "+ this.getOrdenarCampo() +" "+  this.getOrdenarMetodo();	

		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return consulta;
	}

	
	@Override
	public Map<String,String> getColum()	{
		Map<String,String> colum = new HashMap<String, String>();
		
		// campo a mostrar en cada columna 
		String col=	"{name:'prv_codig', index:'prv_codig', width:30, hidden:false,  formatter:'FormatClient'},\n"
				+	"{name:'prv_nombr', index:'prv_nombr', width:100, hidden:false},\n"
				+	"{name:'prv_telef', index:'prv_telef', width:60,hidden:false},\n"
				+	"{name:'prv_celul', index:'prv_celul', width:60,hidden:false},\n"
				+	"{name:'prv_direc', index:'prv_direc', width:100,hidden:false},\n"
				+	"{name:'prv_prvva', index:'prv_prvva', width:0, hidden:true},\n"
				+	"{name:'iva_nombr', index:'iva_nombr', width:60,hidden:false},\n"
				+	"{name:'prv_tpdoc', index:'prv_tpdoc', width:0,hidden:true},\n"
				+	"{name:'prv_nrdoc', index:'prv_nrdoc', width:80,hidden:false},\n"
				+	"{name:'prv_condi', index:'prv_condi', width:0,hidden:true},\n"
				+	"{name:'prv_plazo', index:'prv_plazo', width:20,hidden:false, align:'right'}";
		colum.put("colum",col);
		
		// Campo con nombres de cada columna
		String name="'Cod.','Nombre','Telefono','Celular','Direcion','','IVA', '', 'Documento', '', 'Plazo'";
		colum.put("names",name);
		
		// campo a mostrar en cada columna 
		String busc = "<div class='busqGrill'>"
					+ "		<label style='float:left; height:26px; vertical-align: 26px;'>"
					+ "			Buscar:"
					+ "		</label>"
					+ "		<input id='BusquedaValor' type='text' class='form-control with-30-00 inputBusqGrilla'>"
					+ "		<select id='BusquedaCampo' class='form-control with-30-00 selectBusqGrilla'>"
					+ "			<option value='prv_bloq'>Est.</option>"
					+ "			<option value='prv_codi'>C&oacute;d.</option>"
					+ "			<option value='prv_nomb' selected>Nombre</option>"
					+ "			<option value='prv_razo'>Raz&oacute;n Social</option>"
					+ "			<option value='prv_ndoc'>DNI</option>"
					+ "			<option value='prv_cuit'>CUIT</option>"
					+ "		</select>"
					+ "		<div class='with-10-00 elem'>"
					+ "			<button  onclick='ActualizarParametros();' type='button' class='btn blanco form-control with-50-00 campo' id='btn_HcPrv'>"
					+ "				<img src='/img/iconos/glyphicons-28-search.png'	style='height: auto; filter: invert(55%);'>"
					+ "			</button>"
					+ "		</div>"
					+ "	</div>";
		colum.put("busc", busc);
		
		// mostrar ordenador por id 
		colum.put("ordCampo", this.getOrdenarCampo());	
		colum.put("ordMetodo", this.getOrdenarMetodo());	
		colum.put("ancho", "960");
		colum.put("tipo", "PRV");
		colum.put("titulo", "Proveedores");
		
		return colum;
	}

	@Override
	public String getFiltro() {
		String filtro = this.getSentenciaWhere();
	
		
	    if(!(busquedaValor == null || busquedaValor.length() == 0)){
	    	filtro=(filtro.equals("")?" where ":" and ");
	    	filtro+= "("+busquedaCampo+" LIKE '%"+busquedaValor+"%' or "
	    			+busquedaCampo+" LIKE '%"+busquedaValor+"' or "
	    			+busquedaCampo+" LIKE '"+busquedaValor+"%' or "
	    			+busquedaCampo+" LIKE '"+busquedaValor+"' ) ";
		}
	    
  		
   		 if(!(filtExt == null || filtExt.equals("") )){
   			 String[] filtros = filtExt.split(",");
   			 if (filtros.length>=1 && !filtros[0].equals("") ){
   				filtro+=(filtro.equals("")?" where ":" and ");
   				 filtro += "prv_activ = '"+filtros[0]+"' ";  
   			 }
   		 }

    	return filtro;
	}


	
}
