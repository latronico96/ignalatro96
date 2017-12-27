package filtros;

import java.io.IOException;
import java.util.Enumeration;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebFilter;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import funciones.Funciones;

/**
 * Servlet Filter implementation class Flt_seccion
 */
@WebFilter(asyncSupported = true, description = "filtro de secciones", urlPatterns = { "/*" })
public class Flt_seccion implements Filter {
	Funciones fun=null;
	public static final String css="/css/";
	public static final String js="/js/";
	public static final String img="/img/";
	public static final String fonts="/fonts/";
	private String patronDeArchivosVarios="^(/js/|/css/|/img/|/fonts/).*(\\.js|\\.jsp|\\.css|\\.png|\\.jgp|\\.svg|\\.eot|\\.ttf|\\.woff|\\.woff2)$"; // ^empeza con .*cualquiercosa fin del texto$
	private String patronSinSeccion="(.*)(/frm_logeo)$";//"(.*)(/index.jsp)$|(.*)(/frm_logeo)$"; //(?!) es no .*cualquiera https://www.debuggex.com
	public static final String inicio="/frm_main.jsp";
	public static final String ind="index.jsp";
	public static final String index="/index.jsp";	
	/**
	 * Default constructor. 
	 */
	public Flt_seccion() {
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see Filter#destroy()
	 */
	public void destroy() {
		// TODO Auto-generated method stub
	}

	/**
	 * @see Filter#doFilter(ServletRequest, ServletResponse, FilterChain)
	 */
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain) throws IOException, ServletException {
		fun =new Funciones();
		// TODO Auto-generated method stub
		// place your code here
		if (fun.parametros.getOrDefault("Debug","true").equals("false")){
			// pass the request along the filter chain
			String path = ((HttpServletRequest) request).getRequestURI();
			HttpServletResponse httpResponse = (HttpServletResponse) response;
			HttpServletRequest sesion=(HttpServletRequest) request;		


			String referer = ((HttpServletRequest) request).getHeader("referer"); 
			if (referer!=null){ 
				//System.out.println(referer);
				int atr = referer.indexOf("/"); 
				//httpResponse.getWriter().println(" "+atr+" "+referer);
				try{
					referer =referer.substring(atr-1, referer.length()); //devuelve el URL de la pagina que llamó al filtro
				}catch (Exception e) {
					// TODO: handle exception
					e.printStackTrace();
					referer=null;
				}
			}

			/*System.out.println("session "+fun.haysesion(sesion));
			System.out.println("referer "+referer);
			System.out.println("Path "+path);
			System.out.print("path start with index ");
			System.out.println(path.toLowerCase().startsWith(index));
			System.out.print("path arc v ");
			System.out.println(path.toLowerCase().matches(patronDeArchivosVarios) );
			System.out.print("path sin seccion ");
			System.out.println(path.toLowerCase().matches(patronSinSeccion) );*/

			if ( path.toLowerCase().matches(patronDeArchivosVarios) 	|| path.toLowerCase().matches(patronSinSeccion) ){
				//si son archivos planos
				chain.doFilter(request, response);
			}else{
				if(fun.haysesion(sesion)){
					//si la sesion está abierta y se cciona a index lo devuelve a inicio					
					if (referer!=null && path.startsWith(index) ) {
						httpResponse.sendRedirect(inicio);
					}else{
						//si va a otra pagina que no sea por el inicio, lo redirecciona a inicio
						if (path.startsWith(inicio) || ( referer!=null && referer.startsWith(inicio))) {
							chain.doFilter(request, response);
						}else{
							httpResponse.sendRedirect(inicio);
						}								
					}					
				}else{				
					if (sesion.getRequestURI().equals(index)){ 
						chain.doFilter(request, response);
					}else{
						httpResponse.sendRedirect(index);
					}							
				}	
			}		





		}else{
			chain.doFilter(request, response);
		}
	}

	/**
	 * @see Filter#init(FilterConfig)
	 */
	public void init(FilterConfig fConfig) throws ServletException {
		// TODO Auto-generated method stub
	}

}
