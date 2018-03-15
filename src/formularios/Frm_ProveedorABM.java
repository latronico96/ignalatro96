package formularios;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Iterator;
import java.util.Map;
import java.util.Map.Entry;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONObject;

import funciones.Funciones;

/**
 * Servlet implementation class Proveedor
 */
@WebServlet("/Frm_ProveedorABM")
public class Frm_ProveedorABM extends HttpServlet {
	private static final long serialVersionUID = 1L;
    private Funciones fun = null;
    private String tabla="dbProveedores";
    private String claveCampo="prv_codig";
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public Frm_ProveedorABM() {
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
		int cod=Integer.parseInt("0"+request.getParameter("prv_codig"));
		String respuesta="";
		
		JSONObject obj=new JSONObject();
		switch (modo) {
		case "ALTA":
			String prv_codig=String.valueOf(fun.getMaximo(tabla,claveCampo)+1);
			obj.put("prv_codig", fun.fillZero( prv_codig, 4));
			obj.put("prv_fac", "true");		
			respuesta=fun.JSONObjectToJavaScriptMap("Proveedor", obj);
			break;
		case "BAJA":case "MODI": case "CONS":
			Connection cn;
			try {
				cn = fun.Conectar();
				PreparedStatement pst=cn.prepareStatement(
						"select *,case when prv_fnomb='' then 'false' else 'true' end as prv_fac  "
						+ "from "+tabla+" "
						+ " where "+claveCampo+"= ? ");
				pst.setInt(1, cod);
				ResultSet rs= pst.executeQuery();
				respuesta=fun.ResultSetToJavaScriptMap("Proveedor", rs);
			} catch (ClassNotFoundException | SQLException e) {
				// TODO Auto-generated catch block
				System.out.println("erro al cargar los datos del Proveedores. " + String.valueOf(cod));				
				e.printStackTrace();
			}		
			break;
		default:
			break;
		} 	
		
		
		request.setAttribute("Proveedor",respuesta);
        request.setAttribute("modo",modo);
        RequestDispatcher rd=request.getRequestDispatcher("Frm_ProveedorABM.jsp");
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
					claveValor=String.valueOf(fun.getMaximo(this.tabla, this.claveCampo)+1);
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
			}
			
			if (!parametros.getOrDefault("modo", "ALTA").equals("BAJA")){
				String insert="insert into "+this.tabla+" ("+campos+") values ("+valores+")";
				Statement stAlta = cn.createStatement();	
				stAlta.executeUpdate(insert);
				stAlta.close();
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
		}
	    response.setContentType("application/json"); 		    
		prt.print(json.toString());
	}

}
