package funciones;

import java.io.IOException;
import java.io.PrintWriter;
import java.lang.reflect.InvocationTargetException;


import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
@WebServlet("/funciones")
public class funcionesJS extends HttpServlet { 
	private static final long serialVersionUID = 1L;
	public funcionesJS() {
        super();
        // TODO Auto-generated constructor stub
    }

	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		// Create cookies for first and last names.   
		
		PrintWriter ptw=response.getWriter();
		java.lang.reflect.Method method;
		String ClassName = "funciones.Funciones";
		Class<?> Class = null;
		Object obj = null;
		String methodName = "";
		String js=request.getParameter("js");
		System.out.println(request.getParameter("js"));
		System.out.println(request.getParameter("nombre"));
		System.out.println(request.getParameter("parametro"));
		JSONObject jsonok = null;
		JSONArray PARAMETROS=null;
		JSONParser parser = new JSONParser();
		Object[] arg =  {};
		Class<?>[] paramTypes = {};
		Object aux = null ;
		Object[] parametrosx={};
		
		try {
			jsonok=(JSONObject) parser.parse(js);
			methodName = (String)jsonok.get("nombre");
			PARAMETROS = (JSONArray) jsonok.get("parametro");
			////System.out.println(PARAMETROS);
			////System.out.println(methodName);
			////System.out.println(jsonok);
			for (int x=0;x<PARAMETROS.size();x++)
			{
				aux = PARAMETROS.get(x);
				x++;
				String tipo=(String) PARAMETROS.get(x);
				tipo=tipo.toUpperCase();
				switch(tipo)
				{
				case "INT":
					Class<?>[]inte = {int.class};
					paramTypes = ConcatenarArrayClass(paramTypes, inte);
					parametrosx=new Object[1];
					parametrosx[0]=aux;  
					arg = ConcatenarArrayObject(arg , parametrosx );
					break;
				case "STRING":
					Class<?>[]str = {String.class};
					paramTypes = ConcatenarArrayClass(paramTypes, str);
					parametrosx=new Object[1];
					parametrosx[0]=aux;   
					arg = ConcatenarArrayObject(arg , parametrosx );
					break;
				case "BOOLEAN":
					Class<?>[]bool = {boolean.class};
					paramTypes = ConcatenarArrayClass(paramTypes, bool);
					parametrosx=new Object[1];
					parametrosx[0]=aux;  
					arg = ConcatenarArrayObject(arg , parametrosx );
					break;
				case "HTTPSERVLETREQUEST":
					Class<?>[]req = {HttpServletRequest.class};
					paramTypes = ConcatenarArrayClass(paramTypes, req);
					parametrosx=new Object[1];
					parametrosx[0]=request;   
					arg = ConcatenarArrayObject(arg , parametrosx );
					break;
				case "DOUBLE":
					Class<?>[]dob = {double.class};
					paramTypes = ConcatenarArrayClass(paramTypes, dob);
					parametrosx=new Object[1];
					parametrosx[0]=aux;    
					arg = ConcatenarArrayObject(arg , parametrosx );
					break;
				case "FLOAT":
					Class<?>[]flo = {float.class};
					paramTypes = ConcatenarArrayClass(paramTypes, flo);
					parametrosx=new Object[1];
					parametrosx[0]=aux;    
					arg = ConcatenarArrayObject(arg , parametrosx );
					break;
				case "LONG":
					Class<?>[]lon = {long.class};
					paramTypes = ConcatenarArrayClass(paramTypes, lon);
					parametrosx=new Object[1];
					parametrosx[0]=aux;  
					arg = ConcatenarArrayObject(arg , parametrosx );
					break;
				}
				
				
			}
		} catch (ParseException e2) {
			// TODO Auto-generated catch block
			e2.printStackTrace();
		}
		String data ="error";
		try {
			Class = java.lang.Class.forName(ClassName);
			obj = Class.getConstructor(HttpServletRequest.class).newInstance(request);
			method = obj.getClass().getMethod(methodName,paramTypes);
			Object inv = method.invoke(obj, arg);
			////System.out.println(inv);
			data = String.valueOf(inv);
		} catch (InstantiationException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		} catch (IllegalAccessException e1) {
			// TODO Auto-generated catch block
			e1.printStackTrace();
		}
		catch (IllegalArgumentException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (InvocationTargetException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		catch (NoSuchMethodException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SecurityException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		response.setContentType("text/html"); 
		ptw.println(data);
	}

	public static Class<?>[] ConcatenarArrayClass(Class<?>[] o1, Class<?>[] o2)
	
	{
		Class<?>[] ret = new Class<?>[o1.length + o2.length];
		System.arraycopy(o1, 0, ret, 0, o1.length);
		System.arraycopy(o2, 0, ret, o1.length, o2.length);
	
		return ret;
	}
public static Object[] ConcatenarArrayObject( Object[] o1, Object[] o2)
	
	{
		Object[] ret = new Object[o1.length + o2.length];
		System.arraycopy(o1, 0, ret, 0, o1.length);
		System.arraycopy(o2, 0, ret, o1.length, o2.length);
	
		return ret;
	}

}