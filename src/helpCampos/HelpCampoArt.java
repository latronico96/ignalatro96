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
		this.setOrdenarCampo(campo);
		this.ordenarMetodo = "asc";
		this.pagina = "1";
		this.cntRows = "10";			
	}

	@Override
	public String getTabla (){
		String consulta = "";
		
		 try {// the sql server url		   
			 consulta=	"select  art_codig,art_marca,mar_nombr,art_nombr,art_codbr,art_costo,art_pmeno,art_pmayo,art_activ , \n"
						+ "		concat('<div class=\"',case when stk_canti<art_stmin then 'T-rojo' else 'T-verde' end,'\">',stk_canti,'</div>') as art_cstok  \n"
						+ "	from dbArticulos \n"
						+ "		left join dbMarcas on (art_marca=mar_codig) \n"	
						+ "		left join stockhoy on (stk_artic=art_codig) \n"	
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
		String col=	"{name:'art_codig', index:'art_codig', width:20, hidden:false, formatter:'FormatClient'},\n"			
				+ 	"{name:'art_marca', index:'art_marca', width:0, hidden:true},\n"
				+ 	"{name:'mar_nombr', index:'mar_nombr', width:70, hidden:false},\n"
				+ 	"{name:'art_nombr', index:'art_nombr', width:70,hidden:false},\n"
				+ 	"{name:'art_codbr', index:'art_codbr', width:40,hidden:false},\n"
				+ 	"{name:'art_costo', index:'art_costo', width:60,hidden:false, align:'right'},\n"
				+ 	"{name:'art_pmeno', index:'art_pmeno', width:60,hidden:false, align:'right'},\n"
				+ 	"{name:'art_pmayo', index:'art_pmayo', width:60,hidden:false, align:'right'},\n"
				+ 	"{name:'art_activ', index:'art_activ', width:15,hidden:false, formatter:'FormatActivo'}";
		colum.put("colum",col);
		
		// Campo con nombres de cada columna
		String name="'Cod.','Cod marca','Marca','Articúlo','Cod. Barras','Costo','P. Menor','P. Mayor','Act.'";
		colum.put("names",name);
		
		// campo a mostrar en cada columna 
		String busc = "<div class='busqGrill'>"
					+ "		<label style='float:left; height:26px; vertical-align: 26px;'>"
					+ "			Buscar:"
					+ "		</label>"
					+ "		<input id='BusquedaValor' type='text' class='inputBusqGrilla'>"
					+ "		<select id='BusquedaCampo' class='selectBusqGrilla'>"
					+ "			<option value='art_codig'>C&oacute;d.</option>"
					+ "			<option value='art_marca' selected>marca</option>"
					+ "			<option value='art_nombr'>articulos</option>"
					+ "			<option value='art_codbr'>Cod barra</option>"
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
		colum.put("ancho", "600");
		colum.put("tipo", "ART");
		colum.put("titulo", "Articulos");
		
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
   				 filtro += "art_activ = '"+filtros[0]+"' ";  
   			 }
   		 }

    	return filtro;
	}


	
}
