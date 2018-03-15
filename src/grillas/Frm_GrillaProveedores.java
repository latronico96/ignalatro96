package grillas;

import java.io.IOException;
import java.io.PrintWriter;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONObject;

import funciones.Funciones;

/**
 * Servlet implementation class GrillaProveedores
 */
@WebServlet("/Frm_GrillaProveedores")
public class Frm_GrillaProveedores extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private Funciones fun=null;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public Frm_GrillaProveedores() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
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
			String sql=
					"select prv_codig, \n"
					+ "	CASE WHEN trim(ifnull(prv_fnomb,''))='' THEN prv_nombr ELSE prv_fnomb END as prv_nombr,\n"
					+ "	CASE WHEN trim(ifnull(prv_ftele,''))='' THEN prv_telef ELSE prv_ftele END as prv_telef, \n"
					+ "	CASE WHEN trim(ifnull(prv_fcelu,''))='' THEN prv_celul ELSE prv_fcelu END as prv_celul, \n"
					+ "	CASE WHEN trim(ifnull(prv_fdire,''))='' THEN prv_direc ELSE prv_fdire END as prv_direc, \n"
					+ "	iva_nombr, \n"
					+ "	concat(trim(doc_nombre),' ',convert( CASE WHEN trim(ifnull(prv_fndoc,''))='' THEN prv_nrdoc ELSE prv_fndoc END,char))  as prv_nrdoc, \n"
					+ "	prv_plazo,prv_email \n"
					+ "from  dbproveedores \n"
					+ "	left join dbCondIva on (iva_codig=CASE WHEN trim(ifnull(prv_fciva,''))='' THEN prv_cliva ELSE prv_fciva END) \n"
					+ "left join dbTipoDocumentos on ( doc_codig =CASE WHEN trim(ifnull(prv_fndoc,''))='' THEN prv_tpdoc ELSE prv_ftdoc END) "
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

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
