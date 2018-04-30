package Reportes;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import funciones.Funciones;
import net.sf.jasperreports.engine.export.JRXlsExporter;
import net.sf.jasperreports.engine.export.ooxml.JRXlsxExporter;
import java.sql.Connection;
import java.sql.SQLException;
import java.util.Map;
import java.util.HashMap;
import net.sf.jasperreports.engine.export.JRXlsExporter;
import net.sf.jasperreports.engine.export.ooxml.JRXlsxExporter;
import net.sf.jasperreports.engine.JasperReport;
import net.sf.jasperreports.engine.JasperPrint;
import net.sf.jasperreports.engine.JasperExportManager;
import net.sf.jasperreports.engine.JasperFillManager;
import net.sf.jasperreports.engine.JRException;
import net.sf.jasperreports.engine.JasperCompileManager;

/**
 * Servlet implementation class Rpt_StockHoy
 */
@WebServlet("/Rpt_StockHoy")
public class Rpt_StockHoy extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public Rpt_StockHoy() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		java.io.OutputStream output = response.getOutputStream();
		response.setContentType("application/pdf;charset=UTF-8");
		Funciones fun=new Funciones(request);
		Connection conn;
		try {
			conn = fun.Conectar();
		    Map parameters = new HashMap();
		    String filtro=request.getParameter("filtro");
		    parameters.put("filtro", filtro);
		    JasperReport report = JasperCompileManager.compileReport(request.getSession().getServletContext().getRealPath("/reportes/rpt_StockHoy.jrxml"));
		 	JasperPrint print = JasperFillManager.fillReport(report, parameters, conn); 
		 	response.setContentType("application/pdf");
		    JasperExportManager.exportReportToPdfStream(print, output); 
		} catch (ClassNotFoundException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (SQLException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (JRException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} 
	}

}
