<%@page import="java.sql.SQLException"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Connection"%>
<%@page import="funciones.Funciones"%>
<%@page import="java.sql.Statement"%>
<%@page import="java.sql.DriverManager"%>
<%@ page session="false" pageEncoding="ISO-8859-1" contentType="text/html; charset=ISO-8859-1" %>

<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="ISO-8859-1" />
        <title>Prueba 29/10/2017</title>
        <link rel="stylesheet" href="css/bootstrap.css">                 
        <link rel="stylesheet" href="css/pisaBootstrap.css">         
        <link rel="stylesheet" href="css/general.css">      
        <script src="js/jquery-3.2.1.js"></script>
        <script src="js/popper.js"></script>
        <script src="js/bootstrap.js"></script>

    </head>
    <body>
    	<div class="container">
    		<div class="row">
    			<div clas="row"><h1>Te Amo Mucho</h1></div>
    		</div>
    	</div>
        <div class="container">
            <%
            Funciones f=new Funciones();
			Connection cn=f.Conectar();
			Statement st;
			int i=1;
    		try {
    			st = cn.createStatement();		
    			String sql="select * from dbGaleria";
    			ResultSet rs=st.executeQuery(sql);               
                out.println("<div class=\"row\">");
                while (rs.next()){
               		if (i%4==1 && i>4){out.println("</div><div class=\"row\">");}
	                out.println("<div class=\"col-md-6 col-lg-3 col-xl-3 recuadro\">");
	                out.println("<div class=\"interno rounded\">");
	                out.println("<button class=\"btn btn-dark btn-Close\" name=\"boton\" value=\""+rs.getString("gar_nrofo")+"\">X</button>");
	                out.println("<img class=\"rounded border border-dark\" src=\"img/"+rs.getString("gar_fpath")+"\">");
	                out.println("<h2>"+rs.getString("gar_titul")+"</h2><h5>"+rs.getString("gar_texto")+"</h5>");
	                out.println("</div>");
	                out.println("</div>");
	                i++;
                } 
    		} catch (SQLException e) {
    			// TODO Auto-generated catch block
    			e.printStackTrace();
    		}
            
            if (i%4==1 && i>4){out.println("</div><div class=\"row\">");}
            %>
	            <div class="col-md-6 col-lg-3 col-xl-3  recuadro">
			        <div class="interno rounded">
			        	<div class="container">
							<form method="post" id="formId" enctype="multipart/form-data">
								<div class="row justify-content-md-center">
								  	<div class="col"><h2>Cargar Foto</h2> </div>
								</div>
								<div class="row justify-content-md-center">
									<div class="col">
						   				 <input name="file" style="width: 100%;" type="file" class="form-control-file" id="exampleInputFile" aria-describedby="fileHelp">
									</div>		    
								</div>
								<div class="row justify-content-md-center">
							        <div class="col-12 col-md-2">titulo</div>
							        <div class="col-12 col-md-10"><input class="form-control" type="text" name="titulo" /></div>
								</div>
								<div class="row justify-content-md-center">
							        <div class="col-12 col-md-2">texto</div>
							        <div class="col-12 col-md-10">
							        	<input class="form-control" type="text" name="texto" /><!--  data-container="body" data-toggle="popover" data-placement="bottom"
								         data-content="Vivamus sagittis lacus vel augue laoreet rutrum faucibus."/-->
							        </div>
								</div>
								<div class="row justify-content-md-center">
							        <div class="col-10 col-md-2"><input class="btn " type="button" id="btn_Enviar" value="Upload" /></div>
							    </div>
							</form>
						</div>
			        
			        </div>
		        </div>
            </div>
        </div>
        
        <div class="row">
	        
        </div>

    </body>
<script >
$("#btn_Enviar").click(function(){
	$(document).children().css( 'cursor', 'wait' );
	$.ajax( {
        url: '/UploadServlet',
        type: 'POST',
        data: new FormData( $("#formId")[0] ),
        processData: false,
        contentType: false
    }).done (function( data ) {
    	location.reload();
    });
});

$(".btn-Close").click(function(){
	$(document).children().css( 'cursor', 'wait' );
	$.ajax( {
        url: '/UploadServlet',
        type: 'POST',
        data: {data : this.value}
	}).done (function( data ) {
        location.reload();
    });
});
</script>
</html>
