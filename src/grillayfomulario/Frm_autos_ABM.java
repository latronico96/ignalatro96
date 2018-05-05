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
@WebServlet(asyncSupported = true, description = "Administracion de Autos", urlPatterns = { "/Frm_autos_ABM" })
public class Frm_autos_ABM extends HttpServlet {
	private static final long serialVersionUID = 1L;
    private Funciones fun = null;
    private String tabla="dbautos";
    private String claveCampo="aut_codig";
    /**
     * @see HttpServlet#HttpServlet()
     */
    public Frm_autos_ABM() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		fun = new Funciones(request);
		Map<String,String> tipos=fun.getTipos(tabla);
		String campos="";
		String valores="";
		String claveValor="";
		String updateStr="update "+this.tabla+" set ";
		String camposUpdate="";
		Map<String,String> parametros=fun.parametrosAMap(request);
		String modo=parametros.getOrDefault("modo", "CONS");
		Iterator<Entry<String, String>> it = tipos.entrySet().iterator();
		while (it.hasNext()) {
			Map.Entry<String, String> pair = (Map.Entry<String, String>)it.next();
			if (!campos.equals("")){ 
				campos+=",";
				valores+=",";
			}else{
				/* mantiene el orden pero no se que tan seguro es
				this.claveCampo=(String) pair.getKey();
				claveValor=(String) pair.getValue();*/
			}
			if (this.claveCampo.equals(pair.getKey())){
				claveValor=parametros.getOrDefault((String) pair.getKey(),"");
			}
			campos+=pair.getKey() ;
			valores+= Funciones.PrepararCampo( (String)pair.getKey(), tipos, parametros.getOrDefault((String) pair.getKey(),""));
			
			camposUpdate+=(camposUpdate.equals("")?"":", ");
			camposUpdate+=pair.getKey() + " = " +  Funciones.PrepararCampo( (String)pair.getKey(), tipos, parametros.getOrDefault((String) pair.getKey(),""));
			
		    System.out.println(pair.getKey() + " = " + parametros.getOrDefault((String) pair.getKey(),""));
		    it.remove(); // avoids a ConcurrentModificationException
		}

		String delete="delete from "+this.tabla+" where "+this.claveCampo+"='"+claveValor+"'";
		String insert="insert into "+this.tabla+" ("+campos+") values ("+valores+")";
		updateStr+=camposUpdate + " where "+this.claveCampo+"='"+claveValor+"'";
	
		response.setContentType("application/json"); 
	    PrintWriter prt=response.getWriter();
	    JSONObject json=new JSONObject();
	    Connection cn = null;
		try {
			cn = fun.Conectar();
			cn.setAutoCommit(false);
			Statement st = cn.createStatement();		
			String sql="";
			if (modo.equals("ALTA")){
				sql=insert;
			}else if (modo.equals("BAJA")){
				sql=delete;
			}else if (modo.equals("MODI")){
				sql=updateStr;
			}
				System.out.println(sql);
			st.executeUpdate(sql);			    
			cn.commit();
			st.close();
			cn.close();
			json.put("error","0");  
			json.put("msg","sin errores se modifico con exito");	
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			json.put("error","1");  
			json.put("msg","Error con la conexióon. Por favor vuelva a intentarlo.");	
		} catch (SQLException e) {
			// TODO Auto-generated catch block		if (cn != null) {
            try {
                System.err.print("Transaction is being rolled back");
                cn.rollback();
                cn.close();
            } catch(SQLException excep) {
            	excep.printStackTrace();
            }        
			e.printStackTrace();
			json.put("error","1");  
			json.put("msg","Error con la base de datos. Por favor vuelva a intentarlo.");	
		}
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

		if(!(BusquedaValor == null || BusquedaValor.length() == 0)){
			if(filtro==""){
				filtro= "where ";
			}else{
				filtro+= " and ";
			}	    	
			filtro+= BusquedaCampo+" LIKE '%"+BusquedaValor+"%' ";	   		
		}


		response.setContentType("application/json"); 
		PrintWriter prt=response.getWriter();
		try{			    
			// the sql server url		          
			String sql="Select * from "+tabla+" "
					+ " left join dbmarcas on (mar_codig=aut_marca) ";
			JSONObject jsonGrilla=fun.Grilla(sql,empieza,termina,pagina,rp,ordenarcampo,ordenarmetodo);	 		   
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
