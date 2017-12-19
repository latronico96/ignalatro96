package forms;
import java.io.File;
import java.io.IOException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;

import javax.servlet.ServletException;
import javax.servlet.annotation.MultipartConfig;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;

import funciones.Funciones;
@SuppressWarnings("serial")
@WebServlet("/UploadServlet")
@MultipartConfig(fileSizeThreshold=1024*1024*2, // 2MB
                 maxFileSize=1024*1024*10,      // 10MB
                 maxRequestSize=1024*1024*50)   // 50MB
public class UploadServlet extends HttpServlet {
    /**
     * Name of the directory where uploaded files will be saved, relative to
     * the web application directory.
     */
	private Funciones fun=null;
    private static final String SAVE_DIR = "img";
     
    /**
     * handles file upload
     */
    protected void doPost(HttpServletRequest request,
            HttpServletResponse response) throws ServletException, IOException {
    	fun=new Funciones();
        // gets absolute path of the web application
        String appPath = request.getServletContext().getRealPath("");
        // constructs path of the directory to save uploaded file
        String savePath = appPath + File.separator + SAVE_DIR;

        System.out.println(request.getParameter("data"));
        String data=request.getParameter("data");
        if (data==null){
	         
	        // creates the save directory if it does not exists
	        File fileSaveDir = new File(savePath);
	        if (!fileSaveDir.exists()) {
	            fileSaveDir.mkdir();
	        }
	        String parameterName="";
	        String path="";
	        String titulo="";
	        String texto="";
	        String fileName="";
	        for (Part part : request.getParts()) {
	        	parameterName=part.getName();
	        	System.out.println(parameterName);
	        	if( "file".equals(parameterName) ) {
	        		   fileName = extractFileName(part);
	                  // refines the fileName in case it is an absolute path
	                  fileName = new File(fileName).getName();
	                  part.write(savePath + File.separator + fileName);
	        	  }else{
	        		  System.out.println(part.toString() ); 
	        		  System.out.println(request.getParameter(parameterName) ); 
	        	  }
	        	switch (parameterName) {
				case "file":
					path=fun.isNull(fileName);
					break;
				case "titulo":
					titulo=fun.isNull(request.getParameter(parameterName));
					break;
				case "texto":
					texto=fun.isNull(request.getParameter(parameterName));
					break;
				default:				
					break;
				}
	
	        }
	        String max=fun.getMaximo("dbGaleria","gar_nrofo");
	        String insert="insert into dbGaleria (gar_nrofo,gar_fpath,gar_titul,gar_texto,gar_orden) values ("+max+",'"+path+"','"+titulo+"','"+texto+"',"+max+") ";
			
	        try {
				Connection cn=fun.Conectar();
				Statement st = cn.createStatement();	
				st.executeUpdate(insert);
			} catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (ClassNotFoundException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
        }else{
        	String insert="delete from dbGaleria where gar_nrofo="+data.trim();
	        try {
				Connection cn=fun.Conectar();
				Statement st = cn.createStatement();	
				st.executeUpdate(insert);
	        } catch (SQLException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			} catch (ClassNotFoundException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
        	
        }
        
        request.setAttribute("message", "Upload has been done successfully!");
        getServletContext().getRequestDispatcher("/upload.jsp").forward(
                request, response);
    }
    private String extractFileName(Part part) {
        String contentDisp = part.getHeader("content-disposition");
        String[] items = contentDisp.split(";");
        for (String s : items) {
            if (s.trim().startsWith("filename")) {
                return s.substring(s.indexOf("=") + 2, s.length()-1);
            }
        }
        return "";
    }
}