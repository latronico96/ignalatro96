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
 * Servlet implementation class GrillaCliente
 */
@WebServlet("/Frm_GrillaRemitos")
public class Frm_GrillaRemitos extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private Funciones fun=null;
	private String imgEntrada="'<img src=\"img/login.png\" style=\"width: 18px;\">'";
	private String imgSalida="'<img src=\"img/logout.png\" style=\"width: 18px;\">'";

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public Frm_GrillaRemitos() {
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
			
			if(ordenarcampo.equals("cmp_compo")){
				ordenarcampo=" concat(cmp_letra,' ', cmp_ptvta,' ',cmp_nroco) ";
			}
			
			String sql="select right(concat('000',rem_codig),3) as rem_codig, \n"
					+ "right(concat('000',rem_codcl),3) as rem_codcl, \n"
					+ "trim(cli_nombr) as cli_nombr,rem_tipor, \n"
					+ "case when rem_condi='"+Funciones.Contado+"' then 'Contado' else 'Cta. Corriente' end  as rem_condi, \n"
					+ "	rem_total, count(red_nitem) as rem_canti,DATE_FORMAT(rem_fecha, '%d/%m/%Y') as rem_fecha, \n"
					+ " case when rem_tipor='S' then "+this.imgSalida+" else "+this.imgEntrada+" end as rem_tipoI \n"
					+ "from dbremitos \n"
					+ "left join dbremDetalles on (rem_codig=red_nrore) \n"
					+ "left join dbclientes on (cli_codig=rem_codcl) \n"
					+ filtro
					+ " group by rem_codig "
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
