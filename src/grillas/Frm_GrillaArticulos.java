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
@WebServlet("/Frm_GrillaArticulos")
public class Frm_GrillaArticulos extends HttpServlet {
	private static final long serialVersionUID = 1L;
	private Funciones fun=null;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public Frm_GrillaArticulos() {
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
		String marca=request.getParameter("marca");
		String modelo=request.getParameter("modelo");
		String mod_nombr1=request.getParameter("mod_nombr1");
		String mod_nombr2=request.getParameter("mod_nombr2");
		String mod_nombr3=request.getParameter("mod_nombr3");
		String operador=request.getParameter("operador");
		
		
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
		
		if(!(marca == null || marca.length() == 0)){
			if (!marca.equals("0")){
				if(filtro==""){
					filtro= "where ";
				}else{
					filtro+= " and ";
				}	    	
				filtro+= "aut_marca= "+marca+" ";	
				
				if(!(modelo == null || modelo.length() == 0)){
					if (!modelo.equals("0")){
						if(filtro==""){
							filtro= "where ";
						}else{
							filtro+= " and ";
						}	    	
						filtro+= "ara_nauto= "+modelo+" ";	  
						
					}			
				}
				
				
			}			
		}
		
		if(!( (mod_nombr1+mod_nombr2+mod_nombr3) == null || (mod_nombr1+mod_nombr2+mod_nombr3).length() == 0)){
			String filtro2="(";
			if (!mod_nombr1.equals("")){   	
				filtro2+= " ( art_nombr like '%"+mod_nombr1+"%' ";	
				filtro2+= " OR art_nombr like '%"+mod_nombr1+"' ";	
				filtro2+= " OR art_nombr like '"+mod_nombr1+"%' ) ";	
					
			}			
			
			if (!mod_nombr2.equals("")){
				if(!filtro2.equals("(")){
					filtro2+= " "+operador+" ";
				}	    	
				filtro2+= " ( art_nombr like '%"+mod_nombr2+"%' ";	
				filtro2+= " OR art_nombr like '%"+mod_nombr2+"' ";	
				filtro2+= " OR art_nombr like '"+mod_nombr2+"%' ) ";						
			}	
			
			if (!mod_nombr3.equals("")){
				if(!filtro2.equals("(")){
					filtro2+= " "+operador+" ";
				}	    	
				filtro2+= " ( art_nombr like '%"+mod_nombr3+"%' ";	
				filtro2+= " OR art_nombr like '%"+mod_nombr3+"' ";	
				filtro2+= " OR art_nombr like '"+mod_nombr3+"%' ) ";						
			}	
			filtro2+=")";
			
			if (!filtro2.equals("()")){
				if(filtro==""){
					filtro= "where ";
				}else{
					filtro+= " and ";
				}
				filtro+=filtro2;
			}
		}
		
		
		
		


		response.setContentType("application/json"); 
		PrintWriter prt=response.getWriter();
		try{			    
			// the sql server url		          			

			String sql="select distinct  art_codig,art_marca,mar_nombr,art_nombr,art_codbr,art_costo,art_pmeno,art_pmayo,art_activ \n"
					+ "	from dbArticulos \n"
					+ "		left join dbMarcas as art on (art_marca=mar_codig) \n"
					+ "		left join dbartaut on (ara_artic=art_codig)\n"
					+ "		left join dbautos on (ara_nauto=aut_codig) \n"
					+ filtro			;
			JSONObject jsonGrilla=fun.Grilla(sql,empieza,termina,pagina,rp
					,ordenarcampo, ordenarmetodo);	 		   
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
