package helpCampos;

import java.util.HashMap;
import java.util.Map;

import javax.servlet.http.HttpServletRequest;

import funciones.Funciones;

public class HelpCampoArt extends HelpCampo {
	
	
	public  HelpCampoArt(Funciones func, HttpServletRequest req, String campo, String OrdenarCampo, String OrdenarMetodo, String Pagina, String CntRows, 
			 		String search_campo,  String search_oper,  String search_valor, String BusquedaValor, String BusquedaCampo,String FiltExt){
		this.fun=func;
		
		this.campo = "art_codig";
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
	
	public  HelpCampoArt(Funciones func, HttpServletRequest req){
		this.fun=func;
		
		this.campo = "art_codig";
		this.ordenarMetodo = "asc";
		this.pagina = "1";
		this.cntRows = "10";			
	}

	@Override
	public String getTabla (){
		String consulta = "";
		
		 try {// the sql server url		          
			 consulta="select  art_compa,art_codig,mar_nombr,art_nombr,art_pneto,art_final,art_activ \n"
						+ "	from dbArticulos \n"
						+ "		left join dbMarcas on (art_marca=mar_codig and art_compa=mar_compa) \n"
						+ " "+this.getFiltro()+" \n"				
						+ " ORDER BY " + this.getOrdenarCampo()+ " " +this.getOrdenarMetodo();				

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
		String col=	"{name:'art_compa', index:'art_compa', width:0, hidden:true}, \n"
				+ 	"{name:'art_codig', index:'art_codig', width:20, hidden:false, formatter:'FormatCliente'},\n"
				+ 	"{name:'mar_nombr', index:'mar_nombr', width:70, hidden:false},\n"
				+ 	"{name:'art_nombr', index:'art_nombr', width:70,hidden:false},\n"
				+ 	"{name:'art_pneto', index:'art_pneto', width:60,hidden:false, align:'right'},\n"
				+ 	"{name:'art_final', index:'art_final', width:60,hidden:false, align:'right'},\n"
				+ 	"{name:'art_activ', index:'art_activ', width:15,hidden:false, formatter:'FormatActivo'}";
		colum.put("colum",col);
		
		// Campo con nombres de cada columna
		String name="'Compania','Cod.','Marca','Articúlo','Precio Neto','Precio Final','Act.'";
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
		colum.put("ancho", "600");
		colum.put("tipo", "ART");
		colum.put("titulo", "Articulos");
		
		return colum;
	}

	@Override
	public String getFiltro() {
		String filtro = this.getSentenciaWhere();
		
		filtro=(filtro.equals("")?" where ":" and ");
		filtro+= "art_compa="+String.valueOf(fun.compania)+" \n ";
		
		
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
   				 filtro += "art_activ = '"+filtros[0]+"' ";  
   			 }
   		 }

    	return filtro;
	}


	
}
