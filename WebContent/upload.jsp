<%@ page session="false" pageEncoding="ISO-8859-1" contentType="text/html; charset=ISO-8859-1" %>
<!DOCTYPE html>
<html lang="es">
    <head>
        <meta charset="ISO-8859-1" />
        <title>Prueba 29/10/2017</title>
        <link rel="stylesheet" href="css/bootstrap.min.css">                    
        <link rel="stylesheet" href="css/pisaBootstrap.css">
        <link rel="stylesheet" href="css/general.css">      
        <script src="js/jquery-3.2.1.js"></script>
        <script src="js/popper.js"></script>
       <script src="js/bootstrap.min.js"></script>

    </head>
 <body>
	<div class="container">
	    <div class="row justify-content-md-center">
		    <div class="col-3">
			    <h1>File Upload</h1>
		    </div>
	    </div>
		<form method="post" action="UploadServlet" enctype="multipart/form-data">
			<div class="row justify-content-md-center">
			  	<div class="col-2"><label>Cargar Foto</label> </div>
				<div class="col-5">
	   				 <input name="file" type="file" class="form-control-file" id="exampleInputFile" aria-describedby="fileHelp">
				</div>		    
			</div>
			<div class="row justify-content-md-center">
		        <div class="col-2">titulo</div>
		        <div class="col-5"><input class="form-control" type="text" name="titulo" /></div>
			</div>
			<div class="row justify-content-md-center">
		        <div class="col-2">texto</div>
		        <div class="col-5"><input class="form-control" type="text" name="texto" /></div>
			</div>
			<div class="row justify-content-md-center">
		        <div class="col-2"><input class="btn " type="submit" value="Upload" /></div>
		    </div>
		</form>
	</div>
	
</body>
</html>