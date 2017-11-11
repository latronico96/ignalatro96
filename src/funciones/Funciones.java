package funciones;

import java.sql.Statement;
import java.io.IOException;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;

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
				parametros.put((String) indexs.nextElement(),prop.getProperty((String) indexs.nextElement()));
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
	
	public Connection Conectar(){
		Connection cnx=null;  
	         try {
	            Class.forName("com.mysql.jdbc.Driver");
	            cnx = DriverManager.getConnection("jdbc:mysql://"+this.parametros.get("server")+":"+
	            		this.parametros.get("puerto")+"/"+this.parametros.get("base")
	            		, this.parametros.get("usuario"),
	            		this.parametros.get("contrasenia"));
	         } catch (SQLException e) {
	            e.printStackTrace();
	         } catch (ClassNotFoundException e) {
		            e.printStackTrace();
	         }

	      return cnx;
	}
	public String getMaximo(String tabla,String campo){
		int max=0;
		Connection cn=this.Conectar();
		Statement st;
		try {
			st = cn.createStatement();		
			String sql="select ifnull(max("+campo+"),0) as maximo from "+tabla;
			ResultSet rs=st.executeQuery(sql);
			if (rs.next()){
				max=(rs.getString("maximo")==null?0:rs.getInt("maximo")+1);
			}
		} catch (SQLException e) {
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
	
}
