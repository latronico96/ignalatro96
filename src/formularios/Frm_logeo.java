package formularios;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.Iterator;
import java.util.Map;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.simple.JSONObject;

import funciones.Funciones;

/**
 * Servlet implementation class Frm_logeo
 */
@WebServlet("/Frm_logeo")
public class Frm_logeo extends HttpServlet {
	Funciones fun=null;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public Frm_logeo() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub

		//salida
		String[] data = new String[3];
		fun =new Funciones(request);
		Map<String,String> parametros=fun.parametrosAMap(request);
		Connection cn = null;
		
		PrintWriter v=response.getWriter();
		JSONObject jsonok=new JSONObject(); 
		//System.out.println( "Login prueba " );
		/*Iterator it = parametros.entrySet().iterator();
		while (it.hasNext()) {
			Map.Entry pair = (Map.Entry)it.next();
			jsonok.put(pair.getKey(), pair.getValue());
		    System.out.println(pair.getKey() + " = " + pair.getValue());
		}*/
		String operacion=parametros.getOrDefault("form",null);
		if(operacion==null){
			fun.cerrarsesion(request);
			data[0] = "0";//"2";
			data[1] = fun.acentos("La operacion no es valida por favor vuelva a intentar.");
			RequestDispatcher rd=request.getRequestDispatcher("index.jsp");
			rd.forward(request, response);
		}else if (operacion.equals("frm_registrar")){
			try {
				String tablaCmp="dbCompanias";
				Map<String,String> tipos_compania=fun.getTipos(tablaCmp);
				String insertCmp="";
				String camposCmp="";
				String valoresCmp="";
				String tablaUsu="dbusuarios";
				Map<String,String> tipos_usuarios=fun.getTipos(tablaUsu);
				String insertUsu="";
				String camposUsu="";
				String valoresUsu="";
				String tablaUco="dbcontrasenias";
				Map<String,String> tipos_contrasenia=fun.getTipos(tablaUco);
				String insertUco="";
				String camposUco="";
				String valoresUco="";
				cn = fun.Conectar();
				cn.setAutoCommit(false);
				Statement st = cn.createStatement();
				//CONSULTA
				parametros.put("com_codig", String.valueOf(1+fun.getMaximo(tablaCmp, "com_codig")));
				parametros.put("usu_usuar", String.valueOf(1+fun.getMaximo(tablaUsu, "usu_usuar")));
				
				
				//compania

				valoresCmp+=fun.PrepararCampo("com_codig",tipos_compania,parametros.get("com_codig"));
				camposCmp+="com_codig,";
				valoresCmp+=",";				
				valoresCmp+=fun.PrepararCampo("com_nombr",tipos_compania,parametros.get("compania"));
				camposCmp+="com_nombr,";
				valoresCmp+=",";	
				valoresCmp+=fun.PrepararCampo("com_razon",tipos_compania,parametros.get("razon"));
				camposCmp+="com_razon,";
				valoresCmp+=",";
				valoresCmp+=fun.PrepararCampo("com_abrev",tipos_compania,parametros.get("abrev"));
				camposCmp+="com_abrev,";
				valoresCmp+=",";
				valoresCmp+=fun.PrepararCampo("com_condi",tipos_compania,parametros.get("condIva"));
				camposCmp+="com_condi,";
				valoresCmp+=",";
				valoresCmp+=fun.PrepararCampo("com_ncuit",tipos_compania,parametros.get("cuit"));
				camposCmp+="com_ncuit,";
				valoresCmp+=",";
				valoresCmp+=fun.PrepararCampo("com_activ",tipos_compania,"1");
				camposCmp+="com_activ";
				
				insertCmp="insert into "+tablaCmp+" ("+camposCmp+") values ("+valoresCmp+")";
			    System.out.println(insertCmp);
			    st.executeUpdate(insertCmp);
			    st.close();

				//USUARIO

				valoresUsu+=fun.PrepararCampo("usu_usuar",tipos_usuarios,parametros.get("usu_usuar"));
				camposUsu+="usu_usuar,";
				valoresUsu+=",";				
				valoresUsu+=fun.PrepararCampo("usu_compa",tipos_usuarios,parametros.get("com_codig"));
				camposUsu+="usu_compa,";
				valoresUsu+=",";	
				valoresUsu+=fun.PrepararCampo("usu_nombr",tipos_usuarios,parametros.get("usuario"));
				camposUsu+="usu_nombr";
				
				insertUsu="insert into "+tablaUsu+" ("+camposUsu+") values ("+valoresUsu+")";
			    System.out.println(insertUsu);
			    st=cn.createStatement();
			    st.executeUpdate(insertUsu);			    
			    st.close();
			    				
				//contraseña

				valoresUco+=fun.PrepararCampo("uco_codus",tipos_contrasenia,parametros.get("usu_usuar"));
				camposUco+="uco_codus,";
				valoresUco+=",";				
				valoresUco+=fun.PrepararCampo("uco_fecve",tipos_contrasenia,fun.Ahora("yyyy/MM/dd HH:mm:ss"));
				camposUco+="uco_fecve,";
				valoresUco+=",";	
				valoresUco+=fun.PrepararCampo("uco_contra",tipos_contrasenia,fun.hashPassword(parametros.get("contrasenia")));
				camposUco+="uco_contra";
				
				insertUco="insert into "+tablaUco+" ("+camposUco+") values ("+valoresUco+")";
			    System.out.println(insertUco);
			    st=cn.createStatement();
			    st.executeUpdate(insertUco);			    
			    st.close();
			    fun.crearsesion(request, parametros.get("com_codig"), parametros.get("usu_usuar"), parametros.get("usuario"));
			    data[0] = "1";//"2";
				data[1] = fun.acentos("Se inicio seccion");
				
			    cn.commit();
				cn.close();
			} catch (SQLException e) {
				e.printStackTrace();			
				data[0] = "0";//"2";
				data[1] = fun.acentos("Hubo un error inesperado en la base de datos, por favor vuelva a intentar.");
				if(cn != null){
					try{
						cn.rollback();
					}catch (SQLException ec) {
						// TODO: handle exception
						ec.printStackTrace();
					}
				}
			} catch (ClassNotFoundException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
				data[0] = "0";//"2";
				data[1] = fun.acentos("Hubo un error inesperado en la base de datos, por favor vuelva a intentar.");
			} catch (Exception e) {
				// TODO: handle exception
				e.printStackTrace();
				data[0] = "0";//"2";
				data[1] = fun.acentos("Hubo un error inesperado, por favor vuelva a intentar.");
				if(cn != null){
					try{
						cn.rollback();
					}catch (SQLException ec) {
						// TODO: handle exception
						ec.printStackTrace();
					}
				}
			}
			
			
		}else if (operacion.equals("frm_login")){
			try {
				cn=fun.Conectar();
				cn.setAutoCommit(false);
				Statement st =cn.createStatement();
				String sql="select usu_usuar,usu_compa,usu_nombr from dbusuarios where usu_nombr='"+parametros.get("usuario")+"'";
				ResultSet rs=st.executeQuery(sql);				
				if(rs.next()){
					////System.out.println(fun.valClave(rs.getString("usu_usuar"), pass));

					if ( fun.valClave(rs.getString("usu_usuar"), parametros.get("contrasenia")))	{
						data[0] = "1";
						data[1] = fun.acentos("El usuario y contraseña correctas");
						HttpSession sesion = request.getSession();
						String codus=String.valueOf(sesion.getAttribute("usu_usuar"));
						if (codus.equals(rs.getString("usu_usuar"))){
							data[2]="0";
						}else{
							if (codus.equals("null")){
								data[2]="0";
							}else{
								data[2]="1";}
						}

						fun.crearsesion(request,rs.getString("usu_compa"),rs.getString("usu_usuar"),rs.getString("usu_nombr"));

					}else{
						data[0] = "0";//"2";
						data[1] = fun.acentos("La contraseña no es válida. Vuelva a intentarlo");
					}
				}else{
					data[0] = "0";
					data[1] = fun.acentos("El usuario no es válido.");
				}
				

			} catch (SQLException e) {
				e.printStackTrace();			
				data[0] = "0";//"2";
				data[1] = fun.acentos("Hubo un error inesperado en la base de datos, por favor vuelva a intentar.");
				if(cn != null){
					try{
						cn.rollback();
					}catch (SQLException ec) {
						// TODO: handle exception
						ec.printStackTrace();
					}
				}
			} catch (ClassNotFoundException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
				data[0] = "1";//"2";
				data[1] = fun.acentos("Hubo un error inesperado en la base de datos, por favor vuelva a intentar.");
			} catch (Exception e) {
				// TODO: handle exception
				e.printStackTrace();
				data[0] = "1";//"2";
				data[1] = fun.acentos("Hubo un error inesperado, por favor vuelva a intentar.");
				if(cn != null){
					try{
						cn.rollback();
					}catch (SQLException ec) {
						// TODO: handle exception
						ec.printStackTrace();
					}
				}
			}
			
			
		}
		

		jsonok.put("cod",data[0]);
		jsonok.put("msg",data[1]);
		jsonok.put("ses",data[2]);
		
		
		response.setContentType("application/json"); 
		v.println(jsonok.toString());
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub

		fun=new Funciones();
		PrintWriter v=response.getWriter();
		String[] data = new String[2];
		JSONObject jsonok=new JSONObject();
		Cookie sesC = new Cookie("sesC",(  fun.getCookie("sesC", request)==null ? "0" :  String.valueOf(Integer.parseInt(fun.getCookie("sesC", request))+1) ) );
		sesC.setMaxAge(Integer.parseInt(fun.parametros.getOrDefault("timeCookieSes", "604800")));//una seamna 
		response.addCookie( sesC );
		jsonok.put("err",data[0]);
		jsonok.put("msg",data[1]);
		response.setContentType("application/json"); 
		fun.cerrarsesion(request);
		v.println(jsonok.toString());
	}

}
