package formularios;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map;
import java.util.Map.Entry;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;

import funciones.Funciones;

/**
 * Servlet implementation class ClientesABM
 */
@WebServlet("/Frm_RemitoSABM")
public class Frm_RemitoSABM extends HttpServlet {
	private static final long serialVersionUID = 1L;
    private Funciones fun = null;
    private String tabla="dbremitos";
    private String tablaDetalle="dbremdetalles";
    private String claveCampo="rem_codig";
    private String claveCampoDetalle="red_nrore";
    private String claveCampoDetalleItem="red_nitem";
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public Frm_RemitoSABM() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		
		fun=new Funciones(request);
		String modo=request.getParameter("modo");
		int cod=Integer.parseInt("0"+fun.isNull(request.getParameter(claveCampo)));
		String respuesta="";
		
		JSONObject obj=new JSONObject();
		JSONObject jsonGrilla=new JSONObject();
		switch (modo) {
		case "ALTA":
			String rem_codig=String.valueOf(fun.getMaximo(tabla,claveCampo)+1);
			obj.put(claveCampo, fun.fillZero( rem_codig, 4));		
			respuesta=fun.JSONObjectToJavaScriptMap("Remito", obj);
			break;
		case "BAJA":case "MODI": case "CONS":
			Connection cn;
			try {
				cn = fun.Conectar();
				PreparedStatement pst=cn.prepareStatement(
						"select format(rem_total,2) as rem_total,rem_tipor,DATE_FORMAT(rem_fecha, '%d/%m/%Y') as rem_fecha,rem_condi,rem_codig,rem_codcl  "
						+ "from "+tabla+" "
						+ " where "+claveCampo+"= ? ");
				pst.setInt(1, cod);
				ResultSet rs= pst.executeQuery();
				respuesta=fun.ResultSetToJavaScriptMap("Remito", rs);
				String sql="select art_codbr,red_canti,red_artic,mar_nombr,art_nombr, \n"
						+ "		red_pmeno,round(red_pmeno*red_canti,2)  as red_tmeno,red_pmayo,red_costo, \n"
						+ "		round(red_pmayo*red_canti,2)  as red_tmayo, \n"
						+ "		case when rem_condi='"+Funciones.Contado+"' then red_pmeno else red_pmayo end as red_preci, \n"
						+ "		case when rem_condi='"+Funciones.Contado+"' then red_pmeno else red_pmayo end * red_canti as red_total, \n"
						+ "		red_nitem, \n"
						+ "		concat('<div class=\"',case when stk_canti<art_stmin then 'T-rojo' else 'T-verde' end,'\">',stk_canti,'</div>') as art_cstok  \n"
						+ "from dbremitos \n"
						+ "		left join dbremDetalles on (rem_codig=red_nrore) \n"
						+ "		left join dbarticulos on (art_codig=red_artic) \n"
						+ "		left join dbmarcas on (art_marca=mar_codig) \n"
						+ "		left join stockhoy on (stk_artic=art_codig) \n"	
						+ "where red_nrore="+cod+" \n";
				jsonGrilla=fun.Grilla(sql,"0","1000","0","100","red_nitem","asc");	
			} catch (ClassNotFoundException | SQLException e) {
				// TODO Auto-generated catch block
				System.out.println("erro al cargar los datos del Comporbante. " + String.valueOf(cod));				
				e.printStackTrace();
			}		
			break;
		default:
			break;
		} 	
		
		
		request.setAttribute("Remito",respuesta);
		request.setAttribute("Grilla",jsonGrilla.toString());
        request.setAttribute("modo",modo);
        RequestDispatcher rd=request.getRequestDispatcher("Frm_RemitoSABM.jsp");
        rd.forward(request, response);
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		fun = new Funciones(request);
		Map<String,String> tipos=fun.getTipos(tabla);
		String campos="";
		String valores="";
		String claveValor="";
		Map<String,String> parametros=fun.parametrosAMap(request);
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
				if (parametros.getOrDefault("modo", "ALTA").equals("ALTA")){
					claveValor=String.valueOf(fun.getMaximo(this.tabla, this.claveCampo));
					claveValor=String.valueOf(Integer.parseInt(claveValor)+1);
					campos+=pair.getKey() ;
					valores+= Funciones.PrepararCampo( (String)pair.getKey(), tipos, claveValor );
				}else{ 
					claveValor=parametros.get((String)pair.getKey());
					campos+=pair.getKey() ;
					valores+= Funciones.PrepararCampo( (String)pair.getKey(), tipos, parametros.get((String)pair.getKey()) );
				}
			}else{
				campos+=pair.getKey() ;
				valores+= Funciones.PrepararCampo( (String)pair.getKey(), tipos, parametros.get((String)pair.getKey()) );
			}
		    it.remove(); // avoids a ConcurrentModificationException
		}
		
		response.setContentType("application/json"); 
	    PrintWriter prt=response.getWriter();
	    JSONObject json=new JSONObject();
	    Connection cn = null;
		try {
			cn = fun.Conectar();
			cn.setAutoCommit(false);
			
			if (!parametros.getOrDefault("modo", "ALTA").equals("ALTA")){
				String delete="delete from "+this.tabla+" where "+this.claveCampo+"='"+claveValor+"'";
				Statement stBaja = cn.createStatement();	
				stBaja.executeUpdate(delete);
				stBaja.close();
				
				delete="delete from "+this.tablaDetalle+" where "+this.claveCampoDetalle+"='"+claveValor+"'";
				stBaja = cn.createStatement();	
				stBaja.executeUpdate(delete);
				stBaja.close();
				
			}
			
			if (!parametros.getOrDefault("modo", "ALTA").equals("BAJA")){
				String insert="insert into "+this.tabla+" ("+campos+") values ("+valores+")";
				Statement stAlta = cn.createStatement();	
				stAlta.executeUpdate(insert);

				stAlta.close();
				
				this.procesar(cn,claveValor,parametros.getOrDefault("jsonGrilla", "{}"));
			}
			
			   
			cn.commit();
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
		} catch (ParseException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			json.put("error","1");  
			json.put("msg","Error con la base de datos. Por favor vuelva a intentarlo.");	
		}
	    response.setContentType("application/json"); 		    
		prt.print(json.toString());
	}
	

	private void procesar(Connection cn,String clave, String JSONArrayString) throws ParseException, SQLException{
		JSONArray array=(JSONArray) new JSONParser().parse(JSONArrayString);
		int i=0;
		while (i<array.size()){

			String campos="";
			String valores="";
			Map<String,String> tiposDetalle=fun.getTipos(tablaDetalle);
			Iterator<Entry<String, String>> it = tiposDetalle.entrySet().iterator();
			Map<String,String> tiposDetalle2=new HashMap<String,String>(tiposDetalle);
			
			JSONObject obj=(JSONObject) array.get(i);
			while (it.hasNext()) {
				Map.Entry<String, String> pair = (Map.Entry<String, String>)it.next();		
				
				if(!this.claveCampoDetalle.equals(pair.getKey()) && !this.claveCampoDetalleItem.equals(pair.getKey())){
					if (!campos.equals("")){ 
						campos+=",";
						valores+=",";
					}else{
						/* mantiene el orden pero no se que tan seguro es
						this.claveCampo=(String) pair.getKey();
						claveValor=(String) pair.getValue();*/
					}
					campos+=pair.getKey() ;
					valores+= Funciones.PrepararCampo( (String)pair.getKey(), tiposDetalle, (String) obj.get((String)pair.getKey()) );
				}
			    it.remove(); // avoids a ConcurrentModificationException
			}
			campos+=","+this.claveCampoDetalle+","+this.claveCampoDetalleItem;
			valores+= ","+Funciones.PrepararCampo( this.claveCampoDetalle, tiposDetalle2, clave );
			valores+= ","+Funciones.PrepararCampo( this.claveCampoDetalleItem, tiposDetalle2, String.valueOf(i+1) );
			
			
			String insert="insert into "+this.tablaDetalle+" ("+campos+") values ("+valores+")";
			Statement stAlta = cn.createStatement();
			System.out.println(insert);
			stAlta.executeUpdate(insert);
			stAlta.close();
			i++;
		} 
	}

}
