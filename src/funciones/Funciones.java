package funciones;

import java.sql.Statement;
import java.text.DateFormat;
import java.text.DecimalFormat;
import java.text.DecimalFormatSymbols;
import java.text.FieldPosition;
import java.text.ParseException;
import java.text.ParsePosition;
import java.text.SimpleDateFormat;
import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.util.Date;
import java.util.Enumeration;
import java.util.HashMap;
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
	public  Date hoy = new Date();
	public static final String RemEntrada="E";
	public static final String RemSalida="S";
	public static final String RemStock="T";
	public static final String Contado="O";
	public static final String CtaCorrienta="U";
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
		try{
			conexion=ConectarPrivate();
		}catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}		

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
	
	
	public String getMaximoStr(String tabla,String campo){
		return this.getMaximoStr(tabla, campo, "");
	}

	
	public int getMaximo(String tabla,String campo){
		return this.getMaximo(tabla, campo, "");
	}

	public int getMaximo(String tabla,String campo, String where){
		
		int max=0;
		try {		
			Connection cn=this.Conectar();
			Statement st;
			st = cn.createStatement();		
			String sql="select ifnull(max("+campo+"),0) as maximo from "+tabla+where;
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
		return max;
	}
	public String getMaximoStr(String tabla,String campo, String where){
		return String.valueOf(getMaximo( tabla, campo,  where));
	}

	public static String isNull(String valor){
		return Funciones.isNull(valor,"");
	}

	public static String isNull(String valor,String valorDefault){
		return (valor==null?valorDefault:valor);
	}

	public String GetHTMLOtion(String CampoValue,String CampoTexto,String Tabla , String where){

		where=(where.trim().equals("")?"":" where ")+where;
		String html="";
		try{
			Connection cn=this.Conectar();
			Statement st=cn.createStatement();
			ResultSet rs=st.executeQuery("select "+CampoValue+" as campo, "+CampoTexto+" as texto from "+Tabla+" as tabla "+where);
			while( rs.next()){
				html+="<option value=\""+rs.getString("campo")+"\">"+rs.getString("texto")+"</option>";
			}
		}
		catch(Exception e){
			e.printStackTrace();
		}

		return html;
	}
	
	public String GetHTMLOtionList(String CampoValue,String CampoTexto,String Tabla ){
		return this.GetHTMLOtionList(CampoValue, CampoTexto, Tabla, "" );
	}
	
	public String GetHTMLOtionList(String CampoValue,String CampoTexto,String Tabla , String where){

		where=(where.trim().equals("")?"":" where ")+where;
		String html="";
		try{
			Connection cn=this.Conectar();
			Statement st=cn.createStatement();
			ResultSet rs=st.executeQuery("select "+CampoValue+" as campo, "+CampoTexto+" as texto from "+Tabla+" as tabla "+where);
			while( rs.next()){
				html+="<option data-id='"+rs.getString("campo")+"' value='"+rs.getString("texto")+"'>"+rs.getString("texto")+"</option>";
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
			campos[i-1]=rsmd.getColumnLabel(i);
		}
		return campos;
	}

	public String acentos(String cadena) {

		// cambia el caracter por el codigo html (NO SE USA UTF-ENCODE)

		cadena = cadena.replace("Ã¡", "&#225;");
		cadena = cadena.replace("Ã©", "&#233;");
		cadena = cadena.replace("Ã­", "&#237;");
		cadena = cadena.replace("Ã³", "&#243;");
		cadena = cadena.replace("Ãº", "&#250;");
		cadena = cadena.replace("Ã±", "&#241;");
		cadena = cadena.replace("Ã�", "&#193;");
		cadena = cadena.replace("Ã‰", "&#201;");
		cadena = cadena.replace("Ã�", "&#205;");
		cadena = cadena.replace("Ã“", "&#211;");
		cadena = cadena.replace("Ãš", "&#218;");
		cadena = cadena.replace("Ã‘", "&#209;");

		return cadena;
	}

	public String sinAcentos(String cadena) {

		// cambia el caracter por el codigo html (NO SE USA UTF-ENCODE)

		cadena = cadena.replace("Ã¡", "a");
		cadena = cadena.replace("Ã©", "e");
		cadena = cadena.replace("Ã­", "i");
		cadena = cadena.replace("Ã³", "o");
		cadena = cadena.replace("Ãº", "u");
		cadena = cadena.replace("Ã±", "n");
		cadena = cadena.replace("Ã�", "A");
		cadena = cadena.replace("Ã‰", "E");
		cadena = cadena.replace("Ã�", "I");
		cadena = cadena.replace("Ã“", "O");
		cadena = cadena.replace("Ãš", "U");
		cadena = cadena.replace("Ã‘", "N");

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
						objAux.put(vec[i], this.acentos( this.isNull(rs.getString(vec[i])).replaceAll("\n", "")));	         
					}
					json.add(objAux);
				}
			}		
		}catch (SQLException e) {
			e.printStackTrace();
		}
		return json;
	}

	public JSONObject ResultSetToJSONObject(ResultSet rs){
		JSONObject objAux=new JSONObject();
		try {
			if (!rs.isClosed()){
				String[] vec= this.getCampos(rs);//devuelve el nombre de las columnas    
				if (rs.next()){
					objAux= new JSONObject();
					for (int i = 0 ; i <vec.length;i++){	       
						objAux.put(vec[i], this.acentos(rs.getString(vec[i]).replaceAll("\n", "")));	         
					}
				}
			}		
		}catch (SQLException e) {
			e.printStackTrace();
		}
		return objAux;
	}
	
	public String  ResultSetToJavaScriptMap(String name,ResultSet rs){
		String respuesta="var "+name+" = new Map();\n";				
		try {
			if (!rs.isClosed()){
				String[] campos= this.getCampos(rs);//devuelve el nombre de las columnas    
				while (rs.next()){
					for (int i = 0 ; i <campos.length;i++){	 
						respuesta+= name + ".set('"+campos[i]+"','"+this.acentos(isNull(rs.getString(campos[i])).replaceAll("\n", ""))+"');\n";;	         
					}
				}
			}		
		}catch (SQLException e) {
			e.printStackTrace();
		}
		return respuesta;
	}
	
	public String  JSONObjectToJavaScriptMap(String name,JSONObject json){
		String respuesta="var "+name+" = new Map();\n";				
		for (Object key : json.keySet()) {
		        //hago un foreach
		        String keyStr = (String)key;
		        Object keyvalue = json.get(keyStr);       
		        //si es un objeto el hijo traigos como si estuvieran al mismo nivel
		        if (keyvalue instanceof JSONObject){
		        	JSONObjectToJavaScriptMap(name,(JSONObject)keyvalue);
		        }else{
		        	respuesta+= name + ".set('"+keyStr+"','"+this.acentos(String.valueOf(keyvalue).replaceAll("\n", ""))+"');\n";
		        }
		    }
		return respuesta;
	}

	public JSONObject Grilla(String subConsulta,String desde,String hasta, String pagina,String CantPorPagina,
			String ordenarcampo, String ordenarmetodo){
		String consulta="select @rownum as total,grilla.* from ("
				+ "		select *, @rownum := @rownum + 1 AS rank "
				+ " from ("+subConsulta+")consulta, "
				+ "	(SELECT @rownum := 0) contador"
				+ " )grilla "
				+ " ORDER BY " + ordenarcampo+ " " +ordenarmetodo 
				+ " LIMIT "+desde+" , "+hasta+";";

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
		Map<String,String> tipos=new HashMap<String, String>();
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

	public static String PrepararCampo(String campo,Map<String,String> tipos,String valor) {
		String comillas="'";
		if(Funciones.isNull(valor).equals("") || Funciones.isNull(valor).toLowerCase().trim().equals("null") ){
			return "null";
		}else if(tipos.getOrDefault(campo.toLowerCase(),"varchar").toLowerCase().startsWith("date")){
			DateFormat entrada = new SimpleDateFormat("dd/MM/yyyy");
			Date date = new Date();
			try {
				date = entrada.parse(valor);
			} catch (ParseException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			SimpleDateFormat salida = new SimpleDateFormat("yyyy-MM-dd");
			return comillas+salida.format(date)+comillas;
		}else{
			Boolean esTexto= 
					(tipos.getOrDefault(campo.toLowerCase(),"varchar").toLowerCase().startsWith("varchar") || 
						tipos.getOrDefault(campo.toLowerCase(),"varchar").toLowerCase().startsWith("datetime") ||
						tipos.getOrDefault(campo.toLowerCase(),"varchar").toLowerCase().startsWith("char"));
			if(esTexto){
				return (comillas+valor+comillas);
				
			}else{
				return (valor.replaceAll(",", ""));
				
			}
		}
	} 
	
	public  static String FormatDate(Date fecha, String tipo) {
		if(fecha==null){
			return "";
		}else{

			SimpleDateFormat sdf = new SimpleDateFormat(tipo); // Set your date
																// format
			String currentData = sdf.format(fecha);
			return currentData;
		}
	}
	
	public  static String FormatNumber(Object numero, int digitos) {
		String patron="0."+Funciones.fillZero("", digitos);
		DecimalFormatSymbols unusualSymbols = new DecimalFormatSymbols();
		unusualSymbols.setDecimalSeparator('.');
		unusualSymbols.setGroupingSeparator(',');
		DecimalFormat formateador = new DecimalFormat(patron,unusualSymbols);
		return formateador.format(numero);
	}
	
	public  static String FormatNumber(Object numero) {
		return Funciones.FormatNumber(numero,0);		
	}
	
	public Date Ahora(){
		return this.hoy;		
	}
	
	public String Ahora(String tipo){
		return this.FormatDate(this.Ahora(), tipo);		
	}
	

	public String buscadorGrilla(String SearchBy,String field){
		return "\""+("<div id=\"jqgridSearchForm\">"
				+ 	"<input id=\"jqgridSearInput\" class=\"form-control with-85-00 noPadding\" style=\"margin: 1px calc(1% - 1px);\" type=\"text\" data-field=\""+field+"\" placeholder=\""+SearchBy+"\" >"
				+ 	"<button id=\"jqgridSearButton\" class=\"form-control with-9-00 noPadding\"style=\"height: 18.5px; margin: 1px calc(1% - 1px);\"  type=\"button\" value=\"se apreto\">"
				+	"	<img src=\"/img/iconos/glyphicons-28-search.png\" style=\"height: 18px;width: auto;\">" 
				+	"</button>"
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


	public  void crearsesion(HttpServletRequest request, String codig, String nombr) {

		HttpSession sesion = request.getSession();
		sesion.setAttribute("seccionActiva", "1");
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
		
	public static void out(Object obj){
		if (true){
			System.out.println(obj);
		}
	}
	
	public  String fillLeft(String str, int n) {
		if (n > (str.length())) {
			while ((str.length()) < n) {
				str = " " + str;
			}
		}

		return str;
	}

	public  String fillRight(String str, int n) {
		if (n > (str.length())) {
			while ((str.length()) < n) {
				str = str + " ";
			}
		}

		return str;
	}
	
	public JSONObject ValyGetOBJ(String cod, String id){
		String tabla="";
		String campo="";
		String err="";
		String sql="";
		switch (cod) {
			case "CLI":
				tabla="dbClientes";
				campo="cli_codig";
				break;
			case "PRV":
				tabla="dbproveedores";
				campo="prv_codig";
				break;
			case "ART":
				sql="select  art_codig,art_marca,mar_nombr,art_nombr,art_codbr,art_costo,art_pmeno,art_pmayo,art_activ, \n"
						+ "		concat('<div class=\"',case when stk_canti<art_stmin then 'T-rojo' else 'T-verde' end,'\">',stk_canti,'</div>') as art_cstok  \n"
						+ "	from dbArticulos \n"
						+ "		left join dbMarcas on (art_marca=mar_codig) \n"
						+ "		left join stockhoy on (stk_artic=art_codig) \n"	
						+ " where art_codig="+id+" \n";
				break;
			case "ARTB":
				sql="select  art_codig,art_marca,mar_nombr,art_nombr,art_codbr,art_costo,art_pmeno,art_pmayo,art_activ, \n"
						+ "		concat('<div class=\"',case when stk_canti<art_stmin then 'T-rojo' else 'T-verde' end,'\">',stk_canti,'</div>') as art_cstok \n"
						+ "	from dbArticulos \n"
						+ "		left join dbMarcas on (art_marca=mar_codig) \n"	
						+ "		left join stockhoy on (stk_artic=art_codig) \n"	
						+ " where art_codbr='"+this.fillZero(id,13)+"' \n";
				break;
		}
		
		JSONObject obj=new JSONObject();
		JSONObject jsonGen=new JSONObject();
		
		try {
			Connection conexion =this.Conectar();
			Statement st = conexion.createStatement();
			ResultSet rs = null;
			if(sql.equals("")){
				sql="select * from "+tabla+" where "+campo+"="+id+"";
			}
			rs = st.executeQuery(sql);
			if(rs.next()){				
				err="0";
				String[] vec= this.getCampos(rs);//devuelve el nombre de las columnas
				for (int i = 0 ; i <vec.length;i++)
				{	
				    obj.put(vec[i], rs.getString(vec[i])==null?"":rs.getString(vec[i]).trim());
				}
				jsonGen.put("error",err);  
				jsonGen.put("datos",obj);
				
			}else{
				err="1";
				jsonGen.put("error",err); 
			}
		
			
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			err="2";
			jsonGen.put("error",err); 
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
			err="2";
			jsonGen.put("error",err); 
		}
		
		return jsonGen;
		
	}
	public String ValyGet(String cod, String id){
		return  ValyGetOBJ( cod,  id).toString();
	}
	public static String fillZero(String str,int max) {
		  str = str.toString();
		  return (str.length() < max ? fillZero("0" + str, max) : str);
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
	
	public static String llamImg(String tip) {
		String foto;
		switch (tip) {
		case "A":
			foto = "<img src='img/checkbox-checked.png' style='width: 30%;display:block;margin:auto;'>";
			break;
		case "x":
			foto = " ";
			break;
		case "17": // auto nuevo
			foto = "<img src=\"img/Autos32b.ICO\" style=\"width: 50%;display:block;margin:auto;margin-bottom:-4px;\">";
			break;
		case "18": // auto usado
			foto = "<img src=\"img/AutoUsado.ico\" style=\"width: 50%;display:block;margin:auto;margin-bottom:-4px;\">";
			break;
		case "4": // cerrado
			foto = "<img src=\"img/Ok32.ICO\" style=\"width: 50%;display:block;margin:auto;margin-bottom:-4px;\">";
			break;
		case "5": // pendiente
			foto = "<img src=\"img/about.ICO\" style=\"width: 50%;display:block;margin:auto;margin-bottom:-4px;\">";
			break;
		case "6": // resuelto
			foto = "<img src=\"img/Inactivo.ico\" style=\"width: 50%;display:block;margin:auto;margin-bottom:-4px;\">";
			break;
		default:
			foto = "sin ico\"" + tip + "\"";
			break;
		}
		return foto;
	}
	
	public String NuevoUsuario(String usuario,String Constrasema){
		String coUs=String.valueOf(1+this.getMaximo("dbusuarios", "usu_usuar"));
		String insertUsu="insert into dbusuarios (usu_usuar,usu_nombr,usu_vence) values "
				+ "("+coUs+",'"+usuario+"',DATE_ADD(NOW(), INTERVAL 2 MONTH) )";
		String insertContra="insert into dbcontrasenias (uco_codus,uco_fecve,uco_contra) values "
				+ "("+coUs+",DATE_ADD(NOW(), INTERVAL 2 MONTH),'"+this.hashPassword(Constrasema)+"' )";
		String error="0";
		Connection cn=null;
		try{
			cn=this.Conectar();
			cn.setAutoCommit(false);
			
			Statement st=cn.createStatement();
		    st.executeUpdate(insertUsu);			    
		    st.close();
		    
		    st=cn.createStatement();
		    st.executeUpdate(insertContra);			    
		    st.close();		    

			cn.commit();
			cn.close();
		}catch(SQLException e){
			error="1";
			try {
                System.err.print("Transaction is being rolled back");
                if(cn!=null){
                	cn.rollback();
                	cn.close();
                }
            } catch(SQLException excep) {
            	excep.printStackTrace();
            }
			e.printStackTrace();
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			error="1";
			e.printStackTrace();
		}
		return error;
	}
}
