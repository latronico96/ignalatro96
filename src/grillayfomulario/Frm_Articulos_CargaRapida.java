package grillayfomulario;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.Iterator;
import java.util.Map;
import java.util.Map.Entry;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.json.simple.JSONObject;

import java.sql.Connection;
import java.sql.SQLException;
import java.sql.Statement;

import funciones.Funciones;

/**
 * Servlet implementation class Frm_ptaVta_ABM
 */
@WebServlet(asyncSupported = true, description = "Carga rapida de articulos", urlPatterns = { "/Frm_Articulos_CargaRapida" })
public class Frm_Articulos_CargaRapida extends HttpServlet {
	private static final long serialVersionUID = 1L;
    private Funciones fun = null;
    /**
     * @see HttpServlet#HttpServlet()
     */
    public Frm_Articulos_CargaRapida() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		fun = new Funciones(request);
		Map<String,String> parametros=fun.parametrosAMap(request);
		String error="0";
		String msg="sin errores se modifico con exito";
		
		response.setContentType("application/json"); 
		PrintWriter prt=response.getWriter();
		JSONObject json=new JSONObject();
		Connection cn = null;
		Statement st = null;
		try {
			cn = fun.Conectar();
			cn.setAutoCommit(false);
			
			String sigMar=parametros.getOrDefault("mar_codig", "");
			if(sigMar.equals("")){
				sigMar=fun.getMaximoStr("dbmarcas", "mar_codig");
				sigMar=String.valueOf(Integer.parseInt(sigMar)+1);
				String insertMarca="insert into dbMarcas (mar_codig,mar_nombr,mar_activ) values ("+
						sigMar+",'"+parametros.getOrDefault("mar_nombr", "")+"',1)";
				st = cn.createStatement();			
				st.executeUpdate(insertMarca);
				st.close();
		    }	
			
			
			String art_codig=parametros.getOrDefault("art_codig", "");
			String art_marca=sigMar;
			String art_nombr=parametros.getOrDefault("art_nombr", "");
			String art_codbr=parametros.getOrDefault("art_codbr", "");
			String art_activ="1";
			String art_stmin=parametros.getOrDefault("art_stmin", "");
			String art_costo=parametros.getOrDefault("art_costo", "");
			String art_pmeno=parametros.getOrDefault("art_pmeno", "");
			String art_pmayo=parametros.getOrDefault("art_pmayo", "");
			String insertArticulo="insert into dbArticulos "
					+ "(art_codig,art_marca,art_nombr,art_codbr,art_activ,art_stmin,art_costo,art_pmeno,art_pmayo) "
					+ "values ("+art_codig+","+art_marca+",'"+art_nombr+"','"+art_codbr+"',"+art_activ+","+art_stmin+","+art_costo+","+art_pmeno+","+art_pmayo+")";
			st = cn.createStatement();			
			st.executeUpdate(insertArticulo);
			st.close();
			
			
			double red_canti=Double.parseDouble(parametros.getOrDefault("red_canti", "0"));
			String rem_codig=fun.getMaximoStr("dbremitos", "rem_codig");			
			rem_codig=String.valueOf(Integer.parseInt(rem_codig)+1);			
			String insertRemito="insert into dbremitos (rem_total,rem_codcl,rem_condi,rem_fecha,rem_codig,rem_tipor) values "
					+ "("+String.valueOf(red_canti*Double.parseDouble(art_pmeno))+",null,'"+fun.Contado+"',now(),"+rem_codig+",'E')";
			st = cn.createStatement();			
			st.executeUpdate(insertRemito);
			st.close();
			
			String insertRemitoDet="insert into dbremdetalles (red_pmeno,red_pmayo,red_costo,red_artic,red_canti,red_nrore,red_nitem) values"
									+ "("+art_pmeno+","+art_pmayo+","+art_costo+","+art_codig+","+String.valueOf(red_canti)+","+rem_codig+",1)";
			st = cn.createStatement();			
			st.executeUpdate(insertRemitoDet);
			st.close();
			
			
			
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			error="1";  
			msg="Error con la conexióon. Por favor vuelva a intentarlo.";	
		} catch (SQLException e) {
			// TODO Auto-generated catch block		if (cn != null) {
                
			e.printStackTrace();
			error="1";  
			msg="Error con la base de datos. Por favor vuelva a intentarlo.";	
		} finally{
			try {
				if(error.equals("0")){
					cn.commit();
				}else{
					System.err.print("Transaction is being rolled back");
					cn.rollback();
				}
                cn.close();
            } catch(SQLException excep) {
            	excep.printStackTrace();
            }    
		}
		json.put("error",error);  
		json.put("msg",msg);	
		prt.print(json.toString());
		
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		fun = new Funciones(request);
		// TODO Auto-generated method stub
		// TODO Auto-generated method stub
		String empieza="";
		String termina="";
		String pagina = request.getParameter("page");
		String rp =request.getParameter("rows");
		String ordenarcampo = request.getParameter("sidx");
		String ordenarmetodo = request.getParameter("sord");
		String BusquedaValor = request.getParameter("BusquedaValor");
		String BusquedaCampo = request.getParameter("BusquedaCampo");
		String search_campo=request.getParameter("searchField");
		String search_valor=request.getParameter("searchString");
		String search_oper=request.getParameter("searchOper");
		String search_operador="";
		String sentenciaWhere="";

		if(!(search_valor == null || search_valor.length() == 0)){
			switch (search_oper ) {
			case "eq" : 
				search_operador ="=" ;
				break;
			case "ne" :
				search_operador ="<>" ;
				break;
			case "lt" : 
				search_operador ="<" ;
				break;
			case "le" :
				search_operador ="<=" ;
				break;
			case "gt" :
				search_operador =">" ;
				break;
			case "ge" : 
				search_operador =">=" ;
				break;
			case "bw" : 
				search_operador ="LIKE" ;
				search_valor+="%";
				break;
			case "bn" :
				search_operador ="NOT LIKE" ;                
				search_valor+="%";
				break;
			case "in" :
				search_operador ="LIKE" ;
				search_valor="%"+search_valor+"%";
				break;
			case "ni" :
				search_operador ="NOT LIKE" ;
				search_valor="%"+search_valor+"%";
				break;
			case "ew" : 
				search_operador ="LIKE" ;
				search_valor="%"+search_valor;
				break;
			case "en" : 
				search_operador ="NOT LIKE" ;
				search_valor=" %"+search_valor;
				break;
			case "cn" :
				search_operador ="LIKE" ;
				search_valor="%"+search_valor+"%";
				break;
			case "nc" :
				search_operador ="NOT LIKE" ;
				search_valor="%"+search_valor+"%";
				break;
			}
			sentenciaWhere=" where "+search_campo+" "+search_operador+" '"+search_valor+"'";
		}

		if ((ordenarmetodo == null || ordenarmetodo.length() == 0)){
			ordenarmetodo = "asc";
		}

		if ((pagina == null || pagina.length() == 0)){
			pagina = "1";
		}

		if ((rp == null || rp.length() == 0)){
			rp = "10";
		}

		int pag=-1+Integer.parseInt(pagina);	    
		int rpaux = 0+Integer.parseInt(rp);

		empieza = String.valueOf( pag * rpaux);	
		termina= String.valueOf(Integer.parseInt(pagina) *Integer.parseInt(rp));	

		String filtro = sentenciaWhere;

		if(!(BusquedaCampo == null || BusquedaCampo.length() == 0)){
			if(filtro==""){
				filtro= "where ";
			}else{
				filtro+= " and ";
			}	    	
			filtro+= BusquedaCampo+" in (0"+BusquedaValor+") ";	   		
		}


		response.setContentType("application/json"); 
		PrintWriter prt=response.getWriter();
		try{			    
			// the sql server url		          
			String sql="select * "
					+ "from  dbarticulos \n"
					+ "left join dbmarcas on (art_marca=mar_codig) \n"
					+ "left join dbremdetalles on (art_codig=red_artic) \n"
					+ filtro
					+ " ORDER BY " + ordenarcampo+ " " +ordenarmetodo;
			JSONObject jsonGrilla=fun.Grilla(sql,empieza,termina,pagina,rp);	 		   
			prt.print(jsonGrilla.toString());

		}catch(Exception e){
			e.printStackTrace();
			System.err.println("Got an exception! ");
			System.err.println(e.getCause());
			System.err.println(e.getMessage());
			prt.println(e.getMessage());


		}	     
	}

}
