package funciones;

import java.sql.Statement;
import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.ResultSetMetaData;
import java.sql.SQLException;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;

public class Funciones {
	public Map<String,String> parametros=new HashMap<String,String>();
	/*public String server="";
	public String puerto="";
	public String usuario="";
	public String contrasenia="";	
	public String base="";*/
	
	public Funciones(){
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
	
	public Connection Conectar() throws SQLException,SQLException, ClassNotFoundException {
		Connection cnx=null;  
        Class.forName("com.mysql.jdbc.Driver");
        cnx = DriverManager.getConnection("jdbc:mysql://"+this.parametros.get("server")+":"+
        		this.parametros.get("puerto")+"/"+this.parametros.get("base")
        		, this.parametros.get("usuario"),
        		this.parametros.get("contrasenia"));      
       return cnx;
	}
	public String getMaximo(String tabla,String campo){
		int max=0;
		try {		
			Connection cn=this.Conectar();
			Statement st;
			st = cn.createStatement();		
			String sql="select ifnull(max("+campo+"),0) as maximo from "+tabla;
			ResultSet rs=st.executeQuery(sql);
			if (rs.next()){
				max=(rs.getString("maximo")==null?0:rs.getInt("maximo")+1);
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
	
	public String GetHTMLSelect(String CampoValue,String CampoTexto,String Tabla,String Where){
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

			 total=Integer.parseInt((String) ((JSONObject)json.get(0)).get("total"));		    	 
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

public String buscadorGrilla(String SearchBy,String field){
	return "\""+("<div id=\"jqgridSearchForm\">"
			+ this.input("jqgridSearInput", "form-control with-85-00 noPadding" , "min-width: 100px; margin: 5px 1%;" , "text", "data-field=\"field\" placeholder=\""+SearchBy+"\"")
			+ this.button("btn_act",  "form-control with-9-00", "min-width:20px;height: 18.5px;padding 3px;", "button", "se apreto", "<img src=\"/img/iconos/glyphicons-28-search.png\">", "") 
			+ "</div>").replaceAll("\"", "\\\\\"")+"\"";

}

}
