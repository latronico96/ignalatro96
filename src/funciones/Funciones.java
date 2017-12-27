package funciones;

import java.sql.Statement;
import java.text.SimpleDateFormat;
import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.util.Date;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Hashtable;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.Properties;

import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

public class Funciones {
	private int codigoHash=12;
	public Map<String,String> parametros=new HashMap<String,String>();
	public int compania=0;
	/*public String server="";
	public String puerto="";
	public String usuario="";
	public String contrasenia="";	
	public String base="";*/

	public Funciones(){
		this.CargarConfiguracion();
	}
	
	public Funciones(HttpServletRequest request){
		
		this.CargarConfiguracion();

	}

	private void CargarConfiguracion(){
		Properties prop = new Properties();
		InputStream  output = null;
		try {
			ClassLoader classLoader = getClass().getClassLoader();
			output =  classLoader.getResourceAsStream("funciones/configuracion.properties");

			// load a properties file
			prop.load(output);
			Enumeration<Object> indexs = prop.keys();

			// get the property value and print it out
			while (indexs.hasMoreElements()) {
				String index=(String) indexs.nextElement();
				parametros.put(index,prop.getProperty(index));
			}	

		} catch (IOException io) {
			System.out.println("erro en cargar configuracion");
			io.printStackTrace();
		} catch (Exception io) {
			System.out.println("erro en cargar configuracion");
			io.printStackTrace();
		} finally {
			if (output != null) {
				try {
					output.close();
				} catch (IOException e) {
					e.printStackTrace();
				}
			}

		}
	}	
	
	public String getUsuario(HttpServletRequest request){
		return String.valueOf( request.getSession().getAttribute("usu_usuar"));
	}
	
	public String getCodUsuario(HttpServletRequest request){
		return String.valueOf( request.getSession().getAttribute("usu_usuar"));
	}

	public Connection Conectar() throws SQLException,SQLException, ClassNotFoundException {

		Connection conexion=null;
		conexion=ConectarPrivate();

		if (conexion==null){
			conexion=ConectarPrivate();
		}
		return conexion;
	}
	
	private Connection ConectarPrivate() throws SQLException,SQLException, ClassNotFoundException {
		Connection cnx=null;  
		Class.forName("com.mysql.jdbc.Driver");
		cnx = DriverManager.getConnection("jdbc:mysql://"+this.parametros.get("server")+":"+
				this.parametros.get("puerto")+"/"+this.parametros.get("base")
				, this.parametros.get("usuario"),
				this.parametros.get("contrasenia"));      
		return cnx;
	}
	
	
	public String getMaximo(String tabla,String campo){
		return this.getMaximo(tabla, campo, "");
	}

	public String getMaximo(String tabla,String campo, String where){
		String wheresql=(where.trim().equals("")?"":"where "+where);
		int max=0;
		try {		
			Connection cn=this.Conectar();
			Statement st;
			st = cn.createStatement();		
			String sql="select ifnull(max("+campo+"),0) as maximo from "+tabla+wheresql;
			ResultSet rs=st.executeQuery(sql);
			if (rs.next()){
				max=(rs.getString("maximo")==null?0:rs.getInt("maximo"));
			}
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return String.valueOf(max);
	}

	public String isNull(String valor){
		return this.isNull(valor,"");
	}

	public String isNull(String valor,String valorDefault){
		return (valor==null?valorDefault:valor);
	}

	public String GetHTMLOtion(String CampoValue,String CampoTexto,String Tabla,String Where){
		String html="";
		Where=(Where.equals("")?"1=1":Where);
		try{
			Connection cn=this.Conectar();
			Statement st=cn.createStatement();
			ResultSet rs=st.executeQuery("select "+CampoValue+" as campo, "+CampoTexto+" as texto from "+Tabla+" as tabla where "+Where);
			while( rs.next()){
				html+="<option value=\""+rs.getString("campo")+"\">"+rs.getString("texto")+"</option>";
			}
		}
		catch(Exception e){
			e.printStackTrace();
		}

		return html;
	}

	public String[] getCampos(ResultSet rs) throws SQLException
	{   //dado un Resulset, devuelve los nombres de las columnas en un vector
		ResultSetMetaData rsmd = rs.getMetaData();
		String[] campos = new String[rsmd.getColumnCount()] ;
		int i=0;
		while (rsmd.getColumnCount()>i)
		{
			i++;
			campos[i-1]=rsmd.getColumnName(i);
		}
		return campos;
	}

	public String acentos(String cadena) {

		// cambia el caracter por el codigo html (NO SE USA UTF-ENCODE)

		cadena = cadena.replace("á", "&#225;");
		cadena = cadena.replace("é", "&#233;");
		cadena = cadena.replace("í", "&#237;");
		cadena = cadena.replace("ó", "&#243;");
		cadena = cadena.replace("ú", "&#250;");
		cadena = cadena.replace("ñ", "&#241;");
		cadena = cadena.replace("Á", "&#193;");
		cadena = cadena.replace("É", "&#201;");
		cadena = cadena.replace("Í", "&#205;");
		cadena = cadena.replace("Ó", "&#211;");
		cadena = cadena.replace("Ú", "&#218;");
		cadena = cadena.replace("Ñ", "&#209;");

		return cadena;
	}

	public String sinAcentos(String cadena) {

		// cambia el caracter por el codigo html (NO SE USA UTF-ENCODE)

		cadena = cadena.replace("á", "a");
		cadena = cadena.replace("é", "e");
		cadena = cadena.replace("í", "i");
		cadena = cadena.replace("ó", "o");
		cadena = cadena.replace("ú", "u");
		cadena = cadena.replace("ñ", "n");
		cadena = cadena.replace("Á", "A");
		cadena = cadena.replace("É", "E");
		cadena = cadena.replace("Í", "I");
		cadena = cadena.replace("Ó", "O");
		cadena = cadena.replace("Ú", "U");
		cadena = cadena.replace("Ñ", "N");

		return cadena;
	}
	public Map<String, String> parametrosAMap(HttpServletRequest req){
		Map<String, String> allMap=new LinkedHashMap<String, String>();
		Enumeration<String> parameterNames = req.getParameterNames();
		while (parameterNames.hasMoreElements()) {
			String key = (String) parameterNames.nextElement();
			String val = req.getParameter(key);
			/*System.out.println("A= <"+key+"> Value<"+val+">");*/
			allMap.put(key,val);
		}
		return allMap;
	}

	public JSONArray ResultSetToJSONArray(ResultSet rs){
		JSONArray json = new JSONArray();
		JSONObject objAux=new JSONObject();
		try {
			if (!rs.isClosed()){
				String[] vec= this.getCampos(rs);//devuelve el nombre de las columnas    
				while (rs.next()){
					objAux= new JSONObject();
					for (int i = 0 ; i <vec.length;i++){	       
						objAux.put(vec[i], this.acentos(rs.getString(vec[i]).replaceAll("\n", "")));	         
					}
					json.add(objAux);
				}
			}		
		}catch (SQLException e) {
			e.printStackTrace();
		}
		return json;
	}

	public JSONObject Grilla(String subConsulta,String desde,String hasta, String pagina,String CantPorPagina){
		String consulta="select @rownum as total,grilla.* from ("
				+ "		select *, @rownum := @rownum + 1 AS rank "
				+ " from ("+subConsulta+")consulta, "
				+ "	(SELECT @rownum := 0) contador"
				+ " )grilla LIMIT "+desde+" , "+hasta+";";

		JSONObject jsonGrilla = new JSONObject();
		JSONArray json = new JSONArray();
		try {
			Connection cn=this.Conectar();
			Statement st=cn.createStatement();
			ResultSet rs=st.executeQuery(consulta);
			json=this.ResultSetToJSONArray(rs);
			rs.close();
			st.close();
			cn.close();		

			int  total=0;//
			if (json.size()>0){

				total=Integer.parseInt((String) ((JSONObject) json.get(0)).get("total"));		    	 
			}

			jsonGrilla.put("records",total);
			total=(int) Math. ceil((double) total/ Integer.valueOf(CantPorPagina));	    	 
			jsonGrilla.put("total",total);
			jsonGrilla.put("page",pagina);  
			jsonGrilla.put("rows",json);	

		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		return jsonGrilla;
	}

	public Map<String,String> getTipos(String tabla){
		Map<String,String> tipos=new HashMap();
		Connection cn;
		try {
			cn = this.Conectar();
			Statement st = cn.createStatement();
			st = cn.createStatement();
			ResultSet rs = st.executeQuery("DESCRIBE "+tabla);
			while (rs.next()){
				tipos.put(rs.getString("Field").toLowerCase(),rs.getString("Type"));
			}
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return tipos;
	}

	public String PrepararCampo(String campo,Map<String,String> tipos,String valor){
		String comillas="'";
		Boolean esTexto=tipos.get(campo.toLowerCase()).toLowerCase().startsWith("varchar") || tipos.get(campo.toLowerCase()).toLowerCase().startsWith("datetime");
		return (esTexto?comillas+valor+comillas:valor);
	} 
	
	public  String FormatDate(Date fecha, String tipo) {
		if(fecha==null){
			return "";
		}else{

			SimpleDateFormat sdf = new SimpleDateFormat(tipo); // Set your date
																// format
			String currentData = sdf.format(fecha);
			return currentData;
		}
	}
	
	public Date Ahora(){
		return new Date();		
	}
	
	public String Ahora(String tipo){
		return this.FormatDate(this.Ahora(), tipo);		
	}


	public String input(String id,String classe,String style, String tipo, String extra){
		return ("<input id=\""+id+"\" name=\""+id+"\" class=\""+classe+"\" style=\""+style+"\" type=\""+tipo+"\" "+extra+" />");
	}

	public String inputString(String id,String classe,String style, String tipo, String extra){
		return "\""+input(id,classe,style,tipo,extra).replaceAll("\"", "\\\\\"")+"\"";
	}

	public String input(String id,String classe,String style, String tipo){
		return input(id,classe,style,tipo,"");
	}

	public String inputString(String id,String classe,String style, String tipo){
		return inputString(id,classe,style,tipo,"");
	}

	public String button(String id,String classe,String style, String tipo, String value,String html,String extra){
		return "<button id=\""+id+"\" name=\""+id+"\" class=\""+classe+"\" style=\""+style+"\" type=\""+tipo+"\" "
				+ "value=\""+value+"\" "+extra+" >"	+ html + "</button>";
	}

	public String buttonString(String id,String classe,String style, String tipo, String value,String html,String extra){
		return  "\""+button(id,classe,style, tipo, value,html, extra).replaceAll("\"", "\\\\\"")+"\"";
	}
	
	public String select(String id,String classe,String style,  String value,String options,String extra){
		return "<select id=\""+id+"\" name=\""+id+"\" class=\""+classe+"\" style=\""+style+"\" value=\""+value+"\" "+extra+" >"	+ options + "</select>";
	}

	public String selectString(String id,String classe,String style,  String value,String options,String extra){
		return  "\""+select(id,classe,style,value,options,extra).replaceAll("\"", "\\\\\"")+"\"";
	}
	

	public String buscadorGrilla(String SearchBy,String field){
		return "\""+("<div id=\"jqgridSearchForm\">"
				+ this.input("jqgridSearInput", "form-control with-85-00 noPadding" , "min-width: 100px; margin: 5px 1%;" , "text", "data-field=\"field\" placeholder=\""+SearchBy+"\"")
				+ this.button("btn_act",  "form-control with-9-00", "min-width:20px;height: 18.5px;padding 3px;", "button", "se apreto", "<img src=\"/img/iconos/glyphicons-28-search.png\">", "") 
				+ "</div>").replaceAll("\"", "\\\\\"")+"\"";

	}

	public  boolean haysesion(HttpServletRequest request) {
		HttpSession sesion = request.getSession();
		boolean respuesta;
		if (sesion.getAttribute("seccionActiva") != null) {
			if (sesion.getMaxInactiveInterval() == 0) {
				//// ////System.out.println(sesion.getMaxInactiveInterval());
				respuesta = false;
			} else {
				respuesta = true;
			}
		} else {
			respuesta = false;
		}
		return respuesta;
	}

	public  boolean ActSesion(HttpServletRequest request) {
		HttpSession sesion = request.getSession();
		boolean respuesta;
		if (sesion.getAttribute("seccionActiva") != null) {
			if (sesion.getMaxInactiveInterval() == 0) {
				//// ////System.out.println(sesion.getMaxInactiveInterval());
				respuesta = false;
			} else {

				sesion.setMaxInactiveInterval(Integer.parseInt(parametros.getOrDefault("TIMEOUT","86400"))); //24*60*60=86400
				respuesta = true;
			}
		} else {
			respuesta = false;
		}
		return respuesta;
	}

	public String getCookie(String nombre, HttpServletRequest request){// dado el nombre(sede/conn/fGri)devuelve el valor de una cookie
		Cookie[] cookies = null;
		cookies = request.getCookies();
		String val = null;
		if (cookies==null){			
		}else{
			for (int i = 0; i < cookies.length; i++) {
				if (cookies[i].getName().equals(nombre)) {
					val = cookies[i].getValue();
				}
			}	
		}
		return val;
	}


	public  void crearsesion(HttpServletRequest request, String compa, String codig, String nombr) {

		HttpSession sesion = request.getSession();
		sesion.setAttribute("seccionActiva", "1");
		sesion.setAttribute("usu_compa", compa);
		sesion.setAttribute("usu_usuar", codig);
		sesion.setAttribute("usu_nombr", nombr);
		sesion.setMaxInactiveInterval(Integer.parseInt(this.parametros.get("TIMEOUT")));
	}
	
	public  void cerrarsesion(HttpServletRequest request) {

		HttpSession sesion = request.getSession(true);

		sesion.invalidate();

	}
	
	public String hashPassword(String password_plaintext) {
		String salt = BCrypt.gensalt(codigoHash);
		String hashed_password = BCrypt.hashpw(password_plaintext, salt);

		return(hashed_password);
	}

	/**
	 * This method can be used to verify a computed hash from a plaintext (e.g. during a login
	 * request) with that of a stored hash from a database. The password hash from the database
	 * must be passed as the second variable.
	 * @param password_plaintext The account's plaintext password, as provided during a login request
	 * @param stored_hash The account's stored password hash, retrieved from the authorization database
	 * @return boolean - true if the password matches the password of the stored hash, false otherwise
	 */
	public boolean checkPassword(String password_plaintext, String stored_hash) {
		boolean password_verified = false;

		if(null == stored_hash || !stored_hash.startsWith("$2a$"))
			throw new java.lang.IllegalArgumentException("Invalid hash provided for comparison");

		password_verified = BCrypt.checkpw(password_plaintext, stored_hash);

		return(password_verified);
	}
	
	public  boolean valClave(String user, String pass) {
		boolean res = false;

		try {
			
			Connection conexion =this.Conectar();
			Statement str = conexion.createStatement();
			//// ////System.out.println(str);
			String sql = "select uco_contra "
					+ " from dbcontrasenias where uco_codus="+user+" order by uco_fecve desc limit 1 ";
			//// ////System.out.println(sql);
			ResultSet rs = str.executeQuery(sql);
			//// ////System.out.println(rs);

			if (rs.next()) {
				// rs.first();
				res = this.checkPassword(pass,rs.getString("uco_contra"));
			}
			str.close();
			conexion.close();

		} catch (SQLException e) {
			e.printStackTrace();
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return res;
	}

	/**
	  * A simple test case for the main method, verify that a pre-generated test hash verifies successfully
	  * for the password it represents, and also generate a new hash and ensure that the new hash verifies
	  *just the same.
	  * 
	  *public static void main(String[] args) {
	  *		String test_passwd = "abcdefghijklmnopqrstuvwxyz";
	  *		String test_hash = "$2a$06$.rCVZVOThsIa97pEDOxvGuRRgzG64bvtJ0938xuqzv18d3ZpQhstC";
	  *		System.out.println("Testing BCrypt Password hashing and verification");
	  *		System.out.println("Test password: " + test_passwd);
	  *		System.out.println("Test stored hash: " + test_hash);
	  *		System.out.println("Hashing test password...");
	  *		System.out.println();
	  *		String computed_hash = hashPassword(test_passwd);
	  *		System.out.println("Test computed hash: " + computed_hash);
	  *		System.out.println();
	  *		System.out.println("Verifying that hash and stored hash both match for the test password...");
	  *		System.out.println();
	  *		String compare_test = checkPassword(test_passwd, test_hash)
	  *			? "Passwords Match" : "Passwords do not match";
	  *		String compare_computed = checkPassword(test_passwd, computed_hash)
	  *			? "Passwords Match" : "Passwords do not match";
	  *		System.out.println("Verify against stored hash:   " + compare_test);
	  *					System.out.println("Verify against computed hash: " + compare_computed);
	  *}	
		*/
}
