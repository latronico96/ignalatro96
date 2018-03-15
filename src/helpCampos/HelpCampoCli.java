package helpCampos;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import funciones.Funciones;

public class HelpCampoCli extends HelpCampo {
	
	
	public  HelpCampoCli(Funciones func, HttpServletRequest req, String campo, String OrdenarCampo, String OrdenarMetodo, String Pagina, String CntRows, 
			 		String search_campo,  String search_oper,  String search_valor, String BusquedaValor, String BusquedaCampo,String FiltExt){
		this.fun=func;
		
		this.campo = "cli_codig";
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
	
	public  HelpCampoCli(Funciones func, HttpServletRequest req){
		this.fun=func;
		
		this.campo = "cli_codig";
		this.setOrdenarCampo(campo);
		this.ordenarMetodo = "asc";
		this.pagina = "1";
		this.cntRows = "10";			
	}

	@Override
	public String getTabla (){
		String consulta = "";
		
		 try {// the sql server url	
			consulta="select cli_codig, \n"
						+ "	CASE WHEN trim(ifnull(cli_fnomb,''))='' THEN cli_nombr ELSE cli_fnomb END as cli_nombr,\n"
						+ "	CASE WHEN trim(ifnull(cli_ftele,''))='' THEN cli_telef ELSE cli_ftele END as cli_telef, \n"
						+ "	CASE WHEN trim(ifnull(cli_fcelu,''))='' THEN cli_celul ELSE cli_fcelu END as cli_celul, \n"
						+ "	CASE WHEN trim(ifnull(cli_fdire,''))='' THEN cli_direc ELSE cli_fdire END as cli_direc, \n"
						+ "	iva_nombr,cli_cliva,cli_tpdoc,cli_condi, \n"
						+ "	convert( CASE WHEN trim(ifnull(cli_fndoc,''))='' THEN cli_nrdoc ELSE cli_fndoc END,char)  as cli_nrdoc, \n"
						+ "	cli_plazo,cli_email \n"
						+ "from  dbClientes \n"
						+ "	left join dbCondIva on (iva_codig=CASE WHEN trim(ifnull(cli_fciva,''))='' THEN cli_cliva ELSE cli_fciva END) \n"
						+ "left join dbTipoDocumentos on ( doc_codig =CASE WHEN trim(ifnull(cli_fndoc,''))='' THEN cli_tpdoc ELSE cli_ftdoc END) "
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
		String col=	"{name:'cli_codig', index:'cli_codig', width:30, hidden:false,  formatter:'FormatClient'},\n"
				+	"{name:'cli_nombr', index:'cli_nombr', width:100, hidden:false},\n"
				+	"{name:'cli_telef', index:'cli_telef', width:60,hidden:false},\n"
				+	"{name:'cli_celul', index:'cli_celul', width:60,hidden:false},\n"
				+	"{name:'cli_direc', index:'cli_direc', width:100,hidden:false},\n"
				+	"{name:'cli_cliva', index:'cli_cliva', width:0, hidden:true},\n"
				+	"{name:'iva_nombr', index:'iva_nombr', width:60,hidden:false},\n"
				+	"{name:'cli_tpdoc', index:'cli_tpdoc', width:0,hidden:true},\n"
				+	"{name:'cli_nrdoc', index:'cli_nrdoc', width:80,hidden:false},\n"
				+	"{name:'cli_condi', index:'cli_condi', width:0,hidden:true},\n"
				+	"{name:'cli_plazo', index:'cli_plazo', width:20,hidden:false, align:'right'}";
		colum.put("colum",col);
		
		// Campo con nombres de cada columna
		String name="'Cod.','Nombre','Telefono','Celular','Direcion','','IVA', '', 'Documento', '', 'Plazo'";
		colum.put("names",name);
		
		// campo a mostrar en cada columna 
		String busc = "<div class='busqGrill'>"
					+ "		<label style='float:left; height:26px; vertical-align: 26px;'>"
					+ "			Buscar:"
					+ "		</label>"
					+ "		<input id='BusquedaValor' type='text' class='inputBusqGrilla'>"
					+ "		<select id='BusquedaCampo' class='selectBusqGrilla'>"
					+ "			<option value='cli_bloq'>Est.</option>"
					+ "			<option value='cli_codi'>C&oacute;d.</option>"
					+ "			<option value='cli_nomb' selected>Nombre</option>"
					+ "			<option value='cli_razo'>Raz&oacute;n Social</option>"
					+ "			<option value='cli_ndoc'>DNI</option>"
					+ "			<option value='cli_cuit'>CUIT</option>"
					+ "		</select>"
					+ "		<div class='w1 elem'>"
					+ "			<button onclick='ActualizarParametros();' style='height: 26px;top: 0px;' type='button' class='form-control elem w3 glyphicon glyphicon-search icono'>"
					+ "			</button>"
					+ "		</div>"
					+ "	</div>";
		colum.put("busc", busc);
		
		// mostrar ordenador por id 
		colum.put("ordCampo", this.getOrdenarCampo());	
		colum.put("ordMetodo", this.getOrdenarMetodo());	
		colum.put("ancho", "960");
		colum.put("tipo", "CLI");
		colum.put("titulo", "Clientes");
		
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
   				 filtro += "cli_activ = '"+filtros[0]+"' ";  
   			 }
   		 }

    	return filtro;
	}


	
}
