package funciones;

import com.sun.org.apache.xerces.internal.jaxp.datatype.XMLGregorianCalendarImpl;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.Reader;
import java.io.StringReader;
import java.net.MalformedURLException;
import java.nio.file.Files;
import java.rmi.RemoteException;
import java.security.KeyStore;
import java.security.PrivateKey;
import java.security.Security;
import java.security.cert.CertStore;
import java.security.cert.CollectionCertStoreParameters;
import java.security.cert.X509Certificate;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.Base64;
import java.util.Collection;
import java.util.Date;
import java.util.GregorianCalendar;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.ListIterator;
import java.util.Map;
import java.util.regex.Pattern;

import javax.xml.rpc.ParameterMode;
import javax.xml.rpc.ServiceException;
import javax.xml.soap.MessageFactory;
import javax.xml.soap.MimeHeaders;
import javax.xml.soap.Name;
import javax.xml.soap.Node;
import javax.xml.soap.SOAPBody;
import javax.xml.soap.SOAPConnection;
import javax.xml.soap.SOAPConnectionFactory;
import javax.xml.soap.SOAPElement;
import javax.xml.soap.SOAPEnvelope;
import javax.xml.soap.SOAPException;
import javax.xml.soap.SOAPHeader;
import javax.xml.soap.SOAPMessage;
import javax.xml.soap.SOAPPart;
//import javax.xml.rpc.ServiceException;
import org.apache.axis.client.Call;
import org.apache.axis.client.Service;
//import org.apache.axis.encoding.Base64;
import org.apache.axis.encoding.XMLType;
import org.bouncycastle.cms.CMSProcessable;
import org.bouncycastle.cms.CMSProcessableByteArray;
import org.bouncycastle.cms.CMSSignedData;
import org.bouncycastle.cms.CMSSignedDataGenerator;
import org.bouncycastle.jce.provider.BouncyCastleProvider;

import org.dom4j.Document;
import org.dom4j.DocumentException;
import org.dom4j.io.SAXReader;
import org.w3c.dom.Element;
import org.w3c.dom.NodeList;

import static java.util.Base64.*;

import funciones.Funciones;

public class Wsaa {
	private Funciones fun=null;
	private String token="";
    private String sign="";
    public String cuit="";
    private Date fExp=null;
    private String TRA_PATH= "\\tra.xml";// path de donde guarda el tra
    private String certPATH = "\\server.p12"; //path del certificado
    private static String signer = "1"; // siempre va  a ser 1 
    private static String p12pass = "1"; // contrase�a del certificado cuando se lo pasa de crt a p12/pfx
    
    private boolean Produccion=false; //true;
    
    
    private static String endpointPrueba = "https://wsaahomo.afip.gov.ar/ws/services/LoginCms";
    private static String endpointProduccion = "https://wsaa.afip.gov.ar/ws/services/LoginCms";    
    private  String endpoint = "";    

    private static String URL_SOAPPrueba="https://wswhomo.afip.gov.ar/wsfev1/service.asmx";
    private static String URL_SOAPProduccion="https://wswhomo.afip.gov.ar/wsfev1/service.asmx";
    private String URL_SOAP="";
    
    private static String dstDNPrueba="CN=wsaahomo, O=AFIP, C=AR, SERIALNUMBER=CUIT 33693450239";
    private static String dstDNProduccion="CN=wsaa, O=AFIP, C=AR, SERIALNUMBER=CUIT 33693450239";
    private String dstDN = "";
    
    private static String FEDummy="http://ar.gov.afip.dif.FEV1/FEDummy";
    private static String FECompConsultar="http://ar.gov.afip.dif.FEV1/FECompConsultar";
    private static String FECAESolicitar="http://ar.gov.afip.dif.FEV1/FECAESolicitar";
    private static String FECompUltimoAutorizado="http://ar.gov.afip.dif.FEV1/FECompUltimoAutorizado";
    
  //*****CONSTANTES	
    private static int FE_TDR_IvaIns = 1;
    private static int FE_TDR_Monotributo = 6;
    private static int FE_TDR_ConsFinal = 5;
    private static int FE_TDR_IvaExento = 4;
	
    private static String FE_CON_PRO = "1";  /**' Productos / Exportaci�n definitiva de bienes*/
    private static String FE_CON_SRV = "2";  /**' Servicios*/
    private static String FE_CON_PyS = "3" ; /**' Productos y Servicios*/
	
    private static String FE_DOC_CUIT = "80";
    private static String FE_DOC_CUIL = "86";
    private static String FE_DOC_CDI = "87";
    private static String FE_DOC_LE = "89";
    private static String FE_DOC_LC = "90";
    private static String FE_DOC_CIPF = "0";    /**' Policia Federal*/
    private static String FE_DOC_CIExt = "91";  /**' Extranjera*/
    private static String FE_DOC_PAS = "94";
    private static String FE_DOC_DNI = "96";
    private static String FE_DOC_NoIdent = "99";

	// -- MONEDAS ---------------------------
    private static String FE_MON_PES = "PES";
    private static String FE_MON_DOL = "DOL";
    
    //  -- TRIBUTOS --------------------------

    private static String FE_IMP_NAC = "1";
    private static String FE_IMP_PRO = "2";
    private static String FE_IMP_MUN = "3";
    private static String FE_IMP_INT = "4";
    private static String FE_IMP_OTROS = "99";
    
    //  -- ALICUOTAS IVA ---------------------
    private static String FE_IVA_000 = "3";
	private static String FE_IVA_105 = "4";
	private static String FE_IVA_210 = "5";
	private static String FE_IVA_270 = "6";
	private static String FE_IVA_050 = "8";
	private static String FE_IVA_025 = "9";
    
	public Wsaa(Functiones func) throws Exception{			
		fun=func;
		
		if (this.Produccion){
			this.endpoint = this.endpointProduccion;   
			this.URL_SOAP = this.URL_SOAPProduccion;
			this.dstDN    = this.dstDNProduccion;
		}else{
			this.endpoint = this.endpointPrueba;  
			this.URL_SOAP = this.URL_SOAPPrueba;
			this.dstDN    = this.dstDNPrueba;
		}
		
	    this.TRA_PATH = this.getPath()+this.TRA_PATH;
	    this.certPATH = fun.CertFE;
		if(!this.certPATH.trim().equals("")  ){

			File cert=new File(this.certPATH );
			String separador = Pattern.quote(".");
			String[] aux=this.certPATH.split(separador);
			String extencion=aux[aux.length-1];
			
			
			if(cert.exists() && (extencion.toLowerCase().equals("p12") || extencion.toLowerCase().equals("pfx")) ){
				System.out.println("certifiacado valido");
			}else{
				System.out.println("1"+this.certPATH);
				throw new Exception("No hay certificado valido");
			} 
		}else{
			System.out.println("2"+this.certPATH);
			throw new Exception("No hay certificado valido");
		}
	    
		try{
			this.GetFirma();
		}catch (Exception e) {
			System.out.println("2");
			e.printStackTrace();
		};
		System.out.println("Sertifiacado valido2");
	}
	   
    private String[] GetFirma() throws Exception {
    	if (this.hayTraValido()){
    		this.GetCuit();
    	}else{		
	        String LoginTicketResponse = null;	
	        
	        String service ="wsfe";
	        Long TicketTime = new Long("360000");	
	        // Create LoginTicketRequest_xml_cms
	        byte [] LoginTicketRequest_xml_cms = create_cms(certPATH, p12pass,
	                signer, dstDN, service, TicketTime);
	
	        // Invoke AFIP wsaa and get LoginTicketResponse
            LoginTicketResponse = invoke_wsaa ( LoginTicketRequest_xml_cms, endpoint );
	
	        // Get token & sign from LoginTicketResponse
            this.GuardarTra(LoginTicketResponse);

        	if (!LoginTicketResponse.equals("")){
	            Reader tokenReader = new StringReader(LoginTicketResponse);
	            Document tokenDoc = new SAXReader(false).read(tokenReader);
	
	            token = tokenDoc.valueOf("/loginTicketResponse/credentials/token");
	            sign = tokenDoc.valueOf("/loginTicketResponse/credentials/sign");

        	}
    	}
        String[] s = new String[2];
        

        s[0]=token;
        s[1]=sign;

        return  s;

    }

    static String invoke_wsaa (byte [] LoginTicketRequest_xml_cms, String endpoint) throws Exception {

        String LoginTicketResponse = "";
        try {
            Service service = new Service();
            Call call = (Call) service.createCall();
            //
            // Prepare the call for the Web service
            //
            call.setTargetEndpointAddress(new java.net.URL(endpoint));
            call.setOperationName("loginCms");
            call.addParameter("loginCmsRequest", XMLType.XSD_STRING, ParameterMode.IN);
            call.setReturnType( XMLType.XSD_STRING );
            // Make the actual call and assign the answer to a String
            
            LoginTicketResponse = (String) call.invoke(new Object [] {
            		Base64.getEncoder().encodeToString(LoginTicketRequest_xml_cms)} );
        } catch ( Exception  e) {
            e.printStackTrace();

			System.out.println("errr 1");
        }
        return (LoginTicketResponse);
    }

    //
    // Create the CMS Message
    //
    private byte [] create_cms (String p12file, String p12pass, String signer, String dstDN, String service, Long TicketTime) {
        PrivateKey pKey = null;
        X509Certificate pCertificate = null;
        byte [] asn1_cms = null;
        CertStore cstore = null;
        String LoginTicketRequest_xml;
        String SignerDN = null;
        
        try {
            // Create a keystore using keys from the pkcs#12 p12file
            KeyStore ks = KeyStore.getInstance("pkcs12");
            FileInputStream p12stream = new FileInputStream ( p12file ) ;
            ks.load(p12stream, p12pass.toCharArray());
            p12stream.close();

            // Get Certificate & Private key from KeyStore
            pKey = (PrivateKey) ks.getKey(signer, p12pass.toCharArray());
            pCertificate = (X509Certificate)ks.getCertificate(signer);
            SignerDN = pCertificate.getSubjectDN().toString();
            String[] sourceCert=SignerDN.split(",");
            int i=0;
            while (i<sourceCert.length){
            	String[] aux=sourceCert[i].split("=");
            	String auxString="";
            	if(aux.length==2){
            		if (aux[0].trim().toUpperCase().equals("SERIALNUMBER")){
            			auxString=aux[1].trim().toUpperCase();
            			aux=auxString.split(" ");
            			if(aux.length==2){
                    		if (aux[0].trim().toUpperCase().equals("CUIT")){
                    			this.cuit=aux[1].trim().toUpperCase();                   			
                    		}
                    	}
            		}
            	}
            	i++;
            }                                   
            // Create a list of Certificates to include in the final CMS
            ArrayList<X509Certificate> certList = new ArrayList<X509Certificate>();
            certList.add(pCertificate);

            if (Security.getProvider("BC") == null) {
                Security.addProvider(new BouncyCastleProvider());
            }

            cstore = CertStore.getInstance("Collection", new CollectionCertStoreParameters (certList), "BC");
        }
        catch (Exception e) {
            e.printStackTrace();
			System.out.println("errr 2");
        }
        //
        // Create XML Message
        // 
        LoginTicketRequest_xml = create_LoginTicketRequest(SignerDN, dstDN, service, TicketTime);
        //
        // Create CMS Message
        //
        try {
            // Create a new empty CMS Message
            CMSSignedDataGenerator gen = new CMSSignedDataGenerator();

            // Add a Signer to the Message
            gen.addSigner(pKey, pCertificate, CMSSignedDataGenerator.DIGEST_SHA1);

            // Add the Certificate to the Message
            gen.addCertificatesAndCRLs(cstore);

            // Add the data (XML) to the Message
            CMSProcessable data = new CMSProcessableByteArray(LoginTicketRequest_xml.getBytes());

            // Add a Sign of the Data to the Message
            CMSSignedData signed = gen.generate(data, true, "BC");

            // 
            asn1_cms = signed.getEncoded();
        }
        catch (Exception e) {
            e.printStackTrace();
			System.out.println("errr 3");
        }

        return (asn1_cms);
    }

    //
    // Create XML Message for AFIP wsaa
    // 	
    public static String create_LoginTicketRequest (String SignerDN, String dstDN, String service, Long TicketTime) {

        String LoginTicketRequest_xml;

        Date GenTime = new Date();
        GregorianCalendar gentime = new GregorianCalendar();
        GregorianCalendar exptime = new GregorianCalendar();
        String UniqueId = new Long(GenTime.getTime() / 1000).toString();
        
        gentime.setTime(new Date(GenTime.getTime()-(5*60000)));
        exptime.setTime(new Date(GenTime.getTime()+TicketTime+(5*60000)));

        XMLGregorianCalendarImpl XMLGenTime = new XMLGregorianCalendarImpl(gentime);
        XMLGregorianCalendarImpl XMLExpTime = new XMLGregorianCalendarImpl(exptime);

        LoginTicketRequest_xml = "<?xml version=\"1.0\" encoding=\"UTF-8\" standalone=\"yes\"?>"
                +"<loginTicketRequest version=\"1.0\">"
                +"<header>"
                +"<source>" + SignerDN + "</source>"
                +"<destination>" + dstDN + "</destination>"
                +"<uniqueId>" + UniqueId + "</uniqueId>"
                +"<generationTime>" + XMLGenTime + "</generationTime>"
                +"<expirationTime>" + XMLExpTime + "</expirationTime>"
                +"</header>"
                +"<service>" + service + "</service>"
                +"</loginTicketRequest>";
        System.out.println(LoginTicketRequest_xml);
        return (LoginTicketRequest_xml);
    }
    
    private void GuardarTra(String valorDeXml){
    	if (!valorDeXml.equals("")){
        	try{
            	PrintWriter out = new PrintWriter( TRA_PATH );
                out.println( valorDeXml );
                out.close();
            }catch (FileNotFoundException  e) {
				// TODO: handle exception
            	e.printStackTrace();
    			System.out.println("errr 4");
			}
    	}
    	
    }
    
    private Boolean hayTraValido(){
		String xml="";
		BufferedReader br=null;
    	try {
    		File xmlTra=new File(TRA_PATH);
	    	if (xmlTra.exists()){
	    		br = new BufferedReader(new FileReader(TRA_PATH));
	    		String sCurrentLine;
				while ((sCurrentLine = br.readLine()) != null) {
					xml+=sCurrentLine;
				}
				
	            Reader tokenReader = new StringReader(xml);
	            Document tokenDoc = new SAXReader(false).read(tokenReader);
	
	            token = tokenDoc.valueOf("/loginTicketResponse/credentials/token");
	            sign = tokenDoc.valueOf("/loginTicketResponse/credentials/sign");
	            fExp = fun.newDate(tokenDoc.valueOf("/loginTicketResponse/header/expirationTime"), "yyyy-MM-dd'T'HH:mm:ss.SSSX");       
	            br.close();
	            return  fExp.after(fun.today);
	    	}
		} catch (IOException | DocumentException e) {
			// TODO Auto-generated catch block
				try{
					if(br!=null){
						br.close();
					}
				} catch (IOException ez) {					
				}
			e.printStackTrace();	
			System.out.println("errr 5");    	
		}
    	return false;
    }
    public String Call(String Funcion,Map<String,String> Parametros)  {
    	try{ 
	
	    	SOAPMessage Request=null;
	    	switch (Funcion) {
				case "Dummy":
					Request=createDummyRequest();
					break;
				case "CompConsultar":
					Request=createCompConsultarRequest(Parametros.get("tipo"),Parametros.get("ptvta"),Parametros.get("nroco"));
					break;
				case "CompUltimoAutorizado":
					Request=createFECompUltimoAutorizado(Parametros.get("tipo"),Parametros.get("ptvta"));
					break;
				case "GenerarFactura":
					String mensaje="";
					Request=createFEGenerarFactura(Parametros.get("nrove"),mensaje);
					break;
				default:
			}
	    	if (Request!=null){
	            // Create SOAP Connection
	            SOAPConnectionFactory soapConnectionFactory = SOAPConnectionFactory.newInstance();
	            SOAPConnection soapConnection = soapConnectionFactory.createConnection();
	            // Send SOAP Message to SOAP Server
	            SOAPMessage soapResponse = soapConnection.call(Request, URL_SOAP);
	            ByteArrayOutputStream outResponse = new ByteArrayOutputStream();
	            soapResponse.writeTo(outResponse);
	            String strResponse = new String(outResponse.toByteArray());
	            soapConnection.close();
	            ByteArrayOutputStream outRequest = new ByteArrayOutputStream();
	            Request.writeTo(outRequest);
	            String strRequest = new String(outRequest.toByteArray());
	            String DatosAXML = "TOKEN : "+this.token +"\n SING : "+this.sign +"\nRequest :\n" + strRequest + "\nResponse : \n"+strResponse;
	            if (Funcion.equals("GenerarFactura")){
	            	
	            	this.GuradarDatos(DatosAXML);
	            }
	            System.out.println(DatosAXML);
	            return strResponse;
	    	}	    	
    	
    	}catch(UnsupportedOperationException e){
    		e.printStackTrace();
			System.out.println("------------------------------------------");
			System.out.println("ERROR FACTTURACI�N ELECTR�NICA");
			System.out.println("Error UnsupportedOperationException - "+ e.getMessage());		
			System.out.println("------------------------------------------");
    	}catch(SOAPException e){
    		e.printStackTrace();
			System.out.println("------------------------------------------");
			System.out.println("ERROR FACTTURACI�N ELECTR�NICA");
			System.out.println("Error en xml - "+ e.getMessage());		
			System.out.println("------------------------------------------");
    	}catch(IOException e){
    		e.printStackTrace();
			System.out.println("------------------------------------------");
			System.out.println("ERROR FACTTURACI�N ELECTR�NICA");
			System.out.println("Error de entrada salida - "+ e.getMessage());		
			System.out.println("------------------------------------------");
    	}catch(Exception e){
    		e.printStackTrace();
			System.out.println("------------------------------------------");
			System.out.println("ERROR FACTTURACI�N ELECTR�NICA");
			System.out.println("Error en Sistema - "+ e.getMessage());		
			System.out.println("------------------------------------------");
    	}
    	return "err";
    }
    
    public boolean Dummy() throws Exception {
    	String xml=Call("Dummy", null);

        String AppServer= this.FEGetXMLToken(xml, "AppServer");
        String DbServer= this.FEGetXMLToken(xml, "DbServer");
        String AuthServer=this.FEGetXMLToken(xml, "AuthServer");   
        
        if (!(AppServer.equals("OK") && DbServer.equals("OK") && AuthServer.equals("OK"))){
			System.out.println("------------------------------------------");
			System.out.println("ERROR FACTTURACI�N ELECTR�NICA");
			System.out.println("El dummy Dio error");
			System.out.println("AppServer - "+AppServer);
			System.out.println("DbServer - "+DbServer);
			System.out.println("AuthServer - "+AuthServer);			
			System.out.println("------------------------------------------");
        }
        
    	return AppServer.equals("OK") && DbServer.equals("OK") && AuthServer.equals("OK") ;
      }    
    
    public String CompConsultar(String tipo,String ptvta,String nroco) {
    	Map<String,String> Parametros = new HashMap<String,String>();    	
    	Parametros.put("tipo",tipo);
    	Parametros.put("ptvta",ptvta);
    	Parametros.put("nroco",nroco);
    	return Call("CompConsultar",Parametros);
      }  
    
    public String CompConsultar(String Letra,String TipoCo,String ptvta,String nroco) {
    	return CompConsultar(this.FECodigoComprobante(TipoCo, Letra),ptvta,nroco);
      } 
    
    public String CompUltimoAutorizado(String tipo,String ptvta) {  
    	Map<String,String> Parametros = new HashMap<String,String>();    	
    	Parametros.put("tipo",tipo);
    	Parametros.put("ptvta",ptvta);    	
    	String xml=Call("CompUltimoAutorizado",Parametros);
    	if (xml.equals("err")){
        	return xml;
    	}else{
        	return this.FEGetXMLToken(xml, "CbteNro");
    	}
     }
    
    public String CompUltimoAutorizado(String Letra,String TipoCo,String ptvta) {  
    	return this.CompUltimoAutorizado(this.FECodigoComprobante(TipoCo, Letra),ptvta);
    }
    
    public Map<String,String> GenerarFactura(String nroVe) { 
    	Map<String,String> Parametros = new HashMap<String,String>();    	
    	Parametros.put("nrove",nroVe);
    	String xml=Call("GenerarFactura",Parametros).trim();    	
    	Map<String,String> repuesta=new HashMap<String,String>();
    	if (xml.equals("err")){
    		repuesta.put("err",xml);
    	}else{
    		List<String> errores=new ArrayList<String>();   		
    		if(this.FEGetVecXMLVec(xml,"Errors","Err",errores)>0){
        		for (String error : errores) {
        			repuesta.put("err", repuesta.getOrDefault("err","")+this.FEGetXMLToken(error, "Code")+ " - "+this.FEGetXMLToken(error, "Msg")+"\\n");
        		}
    		}else{    			
    			if((this.FEGetXMLToken(xml, "Resultado").trim()).equals("A")){
    	    		repuesta.put("NroCAE",this.FEGetXMLToken(xml, "CAE"));
    	    		repuesta.put("FecCAE",this.FEGetXMLToken(xml, "CAEFchVto"));
    	    		repuesta.put("NroCo",this.FEGetXMLToken(xml, "CbteHasta"));
    			}else{
    				List<String> obs=new ArrayList<String>();   	
    				this.FEGetVecXMLVec(xml,"Observaciones","Obs",obs);
    				for (String obser : obs) {
    					System.out.println("JKLHDASFGHSADMghnkfsa /n Nkj " +obser);
    	    			
            			repuesta.put("err", repuesta.getOrDefault("err","")+this.FEGetXMLToken(obser, "Code")+ " - "+this.FEGetXMLToken(obser, "Msg")+"\\n");
            		}
    			}
    		}
    	}
    	if (!repuesta.getOrDefault("err","").equals("")){
    		System.out.println("------------------------------------------");
    		System.out.println("ERROR FACTURACI�N ELECTR�NICA");
    		System.out.println("En GeneraFE_Factura");
    		System.out.println("xml de respuesta :" + xml);
    		System.out.println("error - "+repuesta.getOrDefault("err",""));	
    		System.out.println("------------------------------------------");
    	}
		
    	return repuesta;
     }
    
    private static SOAPMessage createDummyRequest() {
    	try{
	    	javax.xml.soap.MessageFactory messageFactory = MessageFactory.newInstance();
	    	javax.xml.soap.SOAPMessage soapMessage = messageFactory.createMessage();
	    	javax.xml.soap.SOAPPart soapPart = (javax.xml.soap.SOAPPart) soapMessage.getSOAPPart();
	        SOAPEnvelope envelope = soapPart.getEnvelope();
	        envelope.addNamespaceDeclaration("FEDummy", FEDummy);
	        MimeHeaders headers = soapMessage.getMimeHeaders();
	        headers.addHeader("SOAPAction",FEDummy);
	        soapMessage.saveChanges();
	        return soapMessage;    	
        }catch(SOAPException e){
			e.printStackTrace();	
			System.out.println("------------------------------------------");
			System.out.println("ERROR FACTTURACI�N ELECTR�NICA");
			System.out.println("En CompConsultar");			
			System.out.println("error de xml - "+e.getMessage());	
			System.out.println("------------------------------------------");					
    	}catch(Exception e){
			e.printStackTrace();	
			System.out.println("------------------------------------------");
			System.out.println("ERROR FACTTURACI�N ELECTR�NICA");
			System.out.println("En CompConsultar");
			System.out.println("error de sistema - "+e.getMessage());	
			System.out.println("------------------------------------------");			
		}
    	return null;
    }
    
    private SOAPMessage createCompConsultarRequest(String tipo,String ptvta,String nroco) {
    	try{
	    	this.GetFirma();    	
	    	javax.xml.soap.MessageFactory messageFactory = MessageFactory.newInstance();
	    	javax.xml.soap.SOAPMessage soapMessage = messageFactory.createMessage();
	    	javax.xml.soap.SOAPPart soapPart = (javax.xml.soap.SOAPPart) soapMessage.getSOAPPart();
	        SOAPEnvelope envelope = soapPart.getEnvelope();
	        //envelope.addNamespaceDeclaration("FECompConsultar", FECompConsultar);
	        envelope.removeNamespaceDeclaration(envelope.getPrefix());
	        envelope.setPrefix("soap12");
	        envelope.removeNamespaceDeclaration("soap12");
	        //envelope.addNamespaceDeclaration("soap","http://schemas.xmlsoap.org/soap/envelope");
	        envelope.addNamespaceDeclaration("ar", "http://ar.gov.afip.dif.FEV1/");       
	        MimeHeaders headers = soapMessage.getMimeHeaders();
	        headers.addHeader("SOAPAction",FECompConsultar);        
	        SOAPHeader header = soapMessage.getSOAPHeader(); 
	        header.setPrefix("soap12");        
	        // SOAP Body
	        SOAPBody soapBody = envelope.getBody();
	        soapBody.setPrefix("soap12");
	        SOAPElement FECompConsultar = soapBody.addChildElement("FECompConsultar","","http://ar.gov.afip.dif.FEV1/");
	        SOAPElement Auth = this.getAuth(FECompConsultar);
	        SOAPElement FeCompConsReq = FECompConsultar.addChildElement("FeCompConsReq");
	        SOAPElement CbteTipo = FeCompConsReq.addChildElement("CbteTipo");
	        SOAPElement CbteNro = FeCompConsReq.addChildElement("CbteNro");
	        SOAPElement PtoVta = FeCompConsReq.addChildElement("PtoVta");
	        CbteTipo.setValue(tipo);
	        CbteNro.setValue(nroco);
	        PtoVta.setValue(ptvta); 
	        soapMessage.saveChanges();
	        return soapMessage;

    	}catch(SOAPException e){
			e.printStackTrace();	
			System.out.println("------------------------------------------");
			System.out.println("ERROR FACTTURACI�N ELECTR�NICA");
			System.out.println("En CompConsultar");			
			System.out.println("error de xml - "+e.getMessage());	
			System.out.println("------------------------------------------");					
    	}catch(Exception e){
			e.printStackTrace();	
			System.out.println("------------------------------------------");
			System.out.println("ERROR FACTTURACI�N ELECTR�NICA");
			System.out.println("En CompConsultar");
			System.out.println("error de sistema - "+e.getMessage());	
			System.out.println("------------------------------------------");			
		}
    	return null;
    }
    
    private SOAPMessage createFECompUltimoAutorizado(String tipo,String ptvta) {
    	try{
	    	this.GetFirma();    	
	    	javax.xml.soap.MessageFactory messageFactory = MessageFactory.newInstance();
	    	javax.xml.soap.SOAPMessage soapMessage = messageFactory.createMessage();
	    	javax.xml.soap.SOAPPart soapPart = (javax.xml.soap.SOAPPart) soapMessage.getSOAPPart();
	        SOAPEnvelope envelope = soapPart.getEnvelope();
	        envelope.removeNamespaceDeclaration(envelope.getPrefix());
	        envelope.setPrefix("soap12");
	        envelope.removeNamespaceDeclaration("soap12");
	        envelope.addNamespaceDeclaration("ar", "http://ar.gov.afip.dif.FEV1/");
	        MimeHeaders headers = soapMessage.getMimeHeaders();
	        headers.addHeader("SOAPAction",FECompUltimoAutorizado);        
	        SOAPHeader header = soapMessage.getSOAPHeader(); 
	        header.setPrefix("soap12");        
	        // SOAP Body
	        SOAPBody soapBody = envelope.getBody();
	        soapBody.setPrefix("soap12");
	        SOAPElement FECompUltimoAutorizado  = soapBody.addChildElement("FECompUltimoAutorizado","","http://ar.gov.afip.dif.FEV1/");
	        SOAPElement Auth = this.getAuth(FECompUltimoAutorizado);
	        SOAPElement PtoVta = FECompUltimoAutorizado.addChildElement("PtoVta");
	        SOAPElement CbteTipo = FECompUltimoAutorizado.addChildElement("CbteTipo");
	        CbteTipo.setValue(tipo);
	        PtoVta.setValue(ptvta);
	        soapMessage.saveChanges();
	        return soapMessage;
    	}catch(SOAPException e){
			e.printStackTrace();	
			System.out.println("------------------------------------------");
			System.out.println("ERROR FACTTURACI�N ELECTR�NICA");
			System.out.println("En CompUltimoAutorizado");			
			System.out.println("error de xml - "+e.getMessage());	
			System.out.println("------------------------------------------");					
    	}catch(Exception e){
			e.printStackTrace();	
			System.out.println("------------------------------------------");
			System.out.println("ERROR FACTTURACI�N ELECTR�NICA");
			System.out.println("En CompUltimoAutorizado");
			System.out.println("error de sistema - "+e.getMessage());	
			System.out.println("------------------------------------------");			
		}
    	return null;
    }
    
    private SOAPElement getAuth(SOAPElement padre) throws SOAPException{
    	SOAPElement Auth;
		Auth = padre.addChildElement("Auth");
    	SOAPElement Token = Auth.addChildElement("Token");
    	SOAPElement Sign = Auth.addChildElement("Sign");
    	SOAPElement Cuit = Auth.addChildElement("Cuit");
        Token.setValue(this.token);
        Sign.setValue(this.sign);
        Cuit.setValue(this.cuit);
    	return Auth;
    }
	
	public static String FECodigoComprobante(String TipCo, String letra){
		
		String cod="0";
	    switch (TipCo) {
		case "F": // Fc
			cod = letra.equals("A")?"1":"6";
			break;
		case "C": // N/C
			cod = letra.equals("A")?"3":"8";
			break;// N/D
		case "D":
			cod = letra.equals("A")?"2":"7";
			break;
		}
	    
	    return cod;	    
	}	
	
	public String FEGetXMLToken(String TextoXML, String Tag){
		/**' Devuelve un texto*/
		String ch="";
		String PalabraClave="";
		String ValorTag="";
	    int p=0;
	    int Ini=0;
	    int Fin=0;
	    int largo=0;
	    int TagIni=0;
	    int TagFin=0;
		boolean TagEncontrado = false;
		boolean GuardandoTag = false;
		boolean EsTag = false;
	    
		largo = TextoXML.length();
	    
		while(!TagEncontrado && p < largo){
			ch = TextoXML.substring(p, p+1);
			switch (ch) {
				case "<":
					if( GuardandoTag ){
					    TagFin = p - 1;
					    ValorTag = TextoXML.substring(TagIni, TagFin  + 1);
					    TagEncontrado = true;
					}
					Ini = p + 1;
					EsTag = true;
					break;
				case ">":
					if( EsTag ){
		                Fin = p - 1;
		                PalabraClave = TextoXML.substring(Ini, Fin  + 1);
		                if( PalabraClave.equals(Tag) ){
		                    GuardandoTag = true;
		                    TagIni = p + 1;
		                }
					}
		            EsTag = false;
					break;
			}
			p++;
		}
		
	    return ValorTag;
	}
	
	
	public  int FEGetVecXMLVec(String XML, String VecNom ,String itemNom ,List<String> vector){
	//funciona solo con un vector en el xml devuelve la cantidad, y por referencia 
	//el vector con cada elmento xml (difiere de minusculas co mayusculas)

		String aux="";
		String[] aux1;
		int largo=0;
		int i=0;
		int veclar=0;
		aux1=XML.split("<" + VecNom + ">"); //divide en 2 con <vector> y toma la parte sig
		if (aux1.length > 1 ){
		    aux = aux1[1];
		    aux1 = aux.split("</" + VecNom + ">"); // divide en 2 con </vec> y toma la anterior
		    
		    if (aux1.length > 0) { // hay <vec><ele></ele><ele></ele></vec> sigue
		        aux = aux1[0];
		        aux1 = aux.split("<" + itemNom + ">"); // los corta por <ele>
		        largo = aux1.length;
		        if (aux1.length > 0) { // si hay alguno los procesa
		            i = 0;
		            veclar = 0;
		            while (largo > i){
		                if (!aux1[i].trim().equals("")){ //xq el primero siempr ers vacio
		                    aux =  (String) aux1[i].subSequence(0, aux1[i].length()- (  "</" + itemNom + ">").length() ) ;//le quita el </ele> del final
		                    vector.add(aux);
		                    veclar++;
		                }
		                i++;
		            }
				}
		    }
		}
		return veclar;
	}
	
	private SOAPMessage createFEGenerarFactura(String NroVe, String mensaje){
		
		/*COSAS QUE NO PUDE PASAR*/
		/**COMENTARIOS EN VISUAL BASIC*/
		
		String Sql="";
		String CodCl="";
		String DatoMal="";
		String ignorado="";
		String nroDoc="";
		String Fecha="";
		String fecha_cbte="";
		String fecha_venc_pago="";
		String fecha_serv_desde="";
		String fecha_serv_hasta="";
		String moneda_id="";
		String moneda_ctz="";
		String imp_total="";
		String imp_nogra="";
		String imp_neto="";
		String imp_iva="";
		String imp_trib="";
		String imp_op_ex="";
	    String Desc="";
		String fecAAAAMMDD="";
		String TextoError="";
	    int condiva=0;
	    String tipoDoc="";
	    String tipocomp="0";
	    String ptVta="";
	    String letra="";
	    String tipo="";
	    String concepto="";
	    String cbteFch="";
	    String impTotal="";
	    String impNeto="";
	    String impTrib="";
	    String impIVA="";
	    String monId="";
	    String monCotiz="";
	    
	    int id=0;
	    double base_imp=0;
	    double Importe=0;
	    double Alic=0;
	    boolean DatosOk=true;
	    boolean DocMal=false;
	    boolean FE_Ok=false;
	    boolean GeneraFE_Factura=false;
	    
	    /** ' Levanto datos del cliente*/	    
	    Sql = "SELECT fac_tipco, fac_letra, fac_ptvta, fac_codcl, fac_cotiz, fac_tipof, "
		+ "fac_tneto, fac_ivain, fac_perib,isnull(fac_peicf, 0) as fac_peicf, "
		+ "isnull(fac_impin, 0) as fac_impin, fac_impor, fac_fecha, fac_fecve, " 
		+ "cli_nomb, cli_domi, cli_loca, cli_razo, cli_rdomi, cli_rloca, " 
		+ "cli_iva, cli_cuit, cli_tdoc, cli_ndoc "
		+ "FROM   dbVentas (NOLOCK) "
		+ "LEFT JOIN dbClientes  (NOLOCK) ON (cli_codi  = fac_codcl) "
		+ "WHERE  fac_nrove = "+NroVe;
	    
	    Connection conexion = fun.conectar();
		try {
			if (this.Dummy()){
				Statement  st= conexion.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE,ResultSet.CONCUR_READ_ONLY);
				ResultSet rs=st.executeQuery(Sql);	
				
			    if (rs.next()){	   
			    	ptVta=rs.getString("fac_ptvta");
			    	letra=rs.getString("fac_letra");
			    	tipo=rs.getString("fac_tipco");
			    	cbteFch= fun.Format(rs.getDate("fac_fecha"), "yyyyMMdd");
			         // Fechas del per�odo del servicio facturado (solo si concepto <> 1)
	
			        monId = this.FE_MON_PES;
			        monCotiz = "1";		         
			    	impTotal=fun.FormatNumber(Math.abs(rs.getDouble("fac_impor")));
			    	impNeto=fun.FormatNumber(Math.abs(rs.getDouble("fac_tneto")));
			    	
			    	impIVA =fun.FormatNumber(Math.abs(rs.getDouble("fac_ivain"))); 
			    			
			    	impTrib = fun.FormatNumber(Math.abs(rs.getDouble("fac_perib"))
			    			+ Math.abs(rs.getDouble("fac_impin"))+ Math.abs(rs.getDouble("fac_peicf")));
			    	imp_iva=fun.FormatNumber(Math.abs(rs.getDouble("fac_ivain")));
			    			
	    	
			    	switch (fun.FormatString(rs.getString("Cli_iva"))) {
						case "01": /**' Resp. Inscripto*/
							condiva = this.FE_TDR_IvaIns;
							break;
						case "02":/**' Monotributo*/
							condiva = this.FE_TDR_Monotributo;			
							break;
						case "03":/**' Consumidor Final*/
							condiva = this.FE_TDR_ConsFinal;
							break;
						case "04":/**' Exento*/
							condiva = this.FE_TDR_IvaExento;
							break;
						default:
							DatosOk = false;
				            DatoMal = "Condici�n IVA";
							break;
					}
			    	if (DatosOk){
				    	tipocomp = this.FECodigoComprobante(rs.getString("fac_tipco"), rs.getString("fac_letra"));
				    	if(tipocomp.equals("0")){
			                DatosOk = false;
			                DatoMal = "Tipo de comprobante inv�lido";
				    	}
				    }
			    	if (DatosOk){
				    	switch (rs.getString("fac_tipof").trim()) {
							case "A":
								concepto = this.FE_CON_PRO;
								break;
							case "I":
								concepto = this.FE_CON_SRV;	
								break;
							case "O":
								concepto = this.FE_CON_PyS;
								break;
							default:
								concepto =this. FE_CON_PyS;
								break;
						}
				         if (concepto.equals(this.FE_CON_PRO)){
		                    fecha_venc_pago = "";
		                    fecha_serv_desde = "";
		                    fecha_serv_hasta = "";
				         }else{
		                    fecha_venc_pago = fun.Format(rs.getDate("fac_fecve"), "yyyyMMdd");
		                    fecha_serv_desde = cbteFch;
		                    fecha_serv_hasta = cbteFch;
		         		}
			    	}
			    	
			    	
			    	
			    	DocMal = true;
			    	if (DatosOk){
				    	
				    	if(condiva == this.FE_TDR_ConsFinal){ /**' Cons Final*/
				    		if (DatosOk){
				    			DocMal = false;
				    			switch (rs.getInt("cli_tdoc")) {
									case 1:/**' DNI*/
										tipoDoc = this.FE_DOC_DNI;
										break;
									case 2:/**' CI*/
										tipoDoc = this.FE_DOC_CIPF;
										break;
									case 3:/**' LE*/
										tipoDoc = this.FE_DOC_LE;
										break;
									case 4:/**' LC*/
										tipoDoc = this.FE_DOC_LC;
										break;
									case 5:/**' PASAPORTE*/
										tipoDoc = this.FE_DOC_PAS;
										break;
									default:
										DocMal = true;
										break;
								}
				    			
				    			if(rs.getInt("cli_ndoc")==0){
				    				DocMal = true;
				    			}else{
				    				nroDoc = rs.getString("cli_ndoc").trim();
				    			}
				    			
				    			if(DocMal){
				    				/*If PedirDni(CodCl) Then
			                        	rs.Requery
				                    Else
				                        DatosOk = False
				                        DatoMal = "Nro. de documento"
				                    End If*/
				    				DatoMal = "Nro. de documento";
				    				System.out.println("------------------------------------------");
				    				System.out.println("ERROR FACTTURACI�N ELECTR�NICA");
				    				System.out.println("En  createFEGenerarFactura");
				    				System.out.println("error - "+DatoMal);	
				    				System.out.println("------------------------------------------");
				    			}
				    			
				    		}
				    	}else{
				    		
				    		tipoDoc = this.FE_DOC_CUIT;
				    		nroDoc = rs.getString("cli_cuit").trim();
				    		
				    		if(nroDoc.equals("0")){
				    			DatosOk = true;
				    	        DatoMal = "CUIT inexistente";
				    		}else{
				    			if (! fun.ValiCUIT(nroDoc)){
				    				DatosOk = false;				    			
				                    DatoMal = "CUIT inv�lido";
				    			}
				    		}
				    	}
			    	}
			    	
			    	/**
			    	se puede hacer notas de credito solo con las percepciones de iibb sin neto
				    'If DatosOk Then
				    '    If rs!fac_perib <> 0 And rs!fac_tneto = 0 Then
				    '        DatosOk = False
				    '        DatoMal = "Percepci�n de IIBB sin Total Neto"
				    '    End If
				    'End If
				    */   
			    	

				    String ultimoAct=this.CompUltimoAutorizado(this.FECodigoComprobante(tipo, letra),ptVta);
			    	String nroco=String.valueOf( Integer.parseInt(ultimoAct) +1);    	
			    	
			    	if (DatosOk && !DocMal){
			        	this.GetFirma();    	
			        	javax.xml.soap.MessageFactory messageFactory = MessageFactory.newInstance();
			        	javax.xml.soap.SOAPMessage soapMessage = messageFactory.createMessage();
			        	javax.xml.soap.SOAPPart soapPart = (javax.xml.soap.SOAPPart) soapMessage.getSOAPPart();
			            SOAPEnvelope envelope = soapPart.getEnvelope();
			            envelope.removeNamespaceDeclaration(envelope.getPrefix());
			            envelope.setPrefix("soap12");
			            envelope.removeNamespaceDeclaration("soap12");
			            envelope.addNamespaceDeclaration("ar", "http://ar.gov.afip.dif.FEV1/");
			            MimeHeaders headers = soapMessage.getMimeHeaders();
			            headers.addHeader("SOAPAction",FECAESolicitar);        
			            SOAPHeader header = soapMessage.getSOAPHeader(); 
			            header.setPrefix("soap12");        
			            // SOAP Body
			            SOAPBody soapBody = envelope.getBody();
			            soapBody.setPrefix("soap12");
			            SOAPElement FECAESolicitar  = soapBody.addChildElement("FECAESolicitar","","http://ar.gov.afip.dif.FEV1/");
				            SOAPElement Auth = this.getAuth(FECAESolicitar);		            
				            SOAPElement FeCAEReq = FECAESolicitar.addChildElement("FeCAEReq");
					            SOAPElement FeCabReq = FeCAEReq.addChildElement("FeCabReq");
					            	SOAPElement CantReg = FeCabReq.addChildElement("CantReg");
					            	CantReg.setValue("1");
					            	SOAPElement PtoVta = FeCabReq.addChildElement("PtoVta");
					            	PtoVta.setValue(ptVta);
					            	SOAPElement CbteTipo = FeCabReq.addChildElement("CbteTipo");		                
					            	CbteTipo.setValue(this.FECodigoComprobante(tipo, letra));
						        SOAPElement FeDetReq = FeCAEReq.addChildElement("FeDetReq");		            
						        	SOAPElement FECAEDetRequest = FeDetReq.addChildElement("FECAEDetRequest");
						            	SOAPElement Concepto = FECAEDetRequest.addChildElement("Concepto");		                
						            	Concepto.setValue(concepto);
						            	SOAPElement DocTipo = FECAEDetRequest.addChildElement("DocTipo");		                
						            	DocTipo.setValue(tipoDoc);
						            	SOAPElement DocNro = FECAEDetRequest.addChildElement("DocNro");		                
						            	DocNro.setValue(nroDoc);
						            	SOAPElement CbteDesde = FECAEDetRequest.addChildElement("CbteDesde");		                
						            	CbteDesde.setValue(nroco);
						            	SOAPElement CbteHasta = FECAEDetRequest.addChildElement("CbteHasta");		                
						            	CbteHasta.setValue(nroco);
						            	SOAPElement CbteFch = FECAEDetRequest.addChildElement("CbteFch");		                
						            	CbteFch.setValue(cbteFch);
						            	SOAPElement ImpTotal = FECAEDetRequest.addChildElement("ImpTotal");		                
						            	ImpTotal.setValue(impTotal);	
						            	SOAPElement ImpTotConc = FECAEDetRequest.addChildElement("ImpTotConc");		                
						            	ImpTotConc.setValue("0.00");	
						            	SOAPElement ImpNeto = FECAEDetRequest.addChildElement("ImpNeto");		                
						            	ImpNeto.setValue(impNeto);		
						            	SOAPElement ImpOpEx = FECAEDetRequest.addChildElement("ImpOpEx");		                
						            	ImpOpEx.setValue("0.00");		
						            	SOAPElement ImpTrib = FECAEDetRequest.addChildElement("ImpTrib");		                
						            	ImpTrib.setValue(impTrib);		
						            	SOAPElement ImpIVA = FECAEDetRequest.addChildElement("ImpIVA");		                
						            	ImpIVA.setValue(impIVA);		
						            	SOAPElement FchServDesde = FECAEDetRequest.addChildElement("FchServDesde");		                
						            	FchServDesde.setValue(fecha_serv_desde);
						            	SOAPElement FchServHasta = FECAEDetRequest.addChildElement("FchServHasta");		                
						            	FchServHasta.setValue(fecha_serv_hasta);
						            	SOAPElement FchVtoPago = FECAEDetRequest.addChildElement("FchVtoPago");		                
						            	FchVtoPago.setValue(fecha_venc_pago);
						            	SOAPElement MonId = FECAEDetRequest.addChildElement("MonId");		                
						            	MonId.setValue(monId);
						            	SOAPElement MonCotiz = FECAEDetRequest.addChildElement("MonCotiz");		                
						            	MonCotiz.setValue(monCotiz);
						            	/*SOAPElement CbtesAsoc = FECAEDetRequest.addChildElement("CbtesAsoc");	
						            		SOAPElement CbteAsoc = CbtesAsoc.addChildElement("CbteAsoc");		
						            			SOAPElement TipoASO = CbteAsoc.addChildElement("Tipo");		                
						            			TipoASO.setValue(tipoASO);
						            			SOAPElement PtoVtaASO = CbteAsoc.addChildElement("PtoVta");		                
						            			PtoVtaASO.setValue(ptoVtASO);
						            			SOAPElement NroASO = CbteAsoc.addChildElement("Nro");		                
						            			NroASO.setValue(nroASO);	*/	
							            	if ((!(rs.getDouble("fac_perib")==0.0)) || (!(rs.getDouble("fac_peicf")==0.0)) || (!(rs.getDouble("fac_impin")==0.0))){
							            		SOAPElement Tributos = FECAEDetRequest.addChildElement("Tributos");	
								                if (!(rs.getDouble("fac_perib")==0.0)){
								                	String provBase_imp = impNeto;
								                    String provImporte = String.valueOf(Math.abs(rs.getDouble("fac_perib")));
								                    String provAlic = "0";
								                    if (!provBase_imp.equals("0")){
								                    	provAlic = String.valueOf(Math.round(Math.abs(rs.getDouble("fac_perib")) / Double.valueOf(impNeto) * 100 *100)/100);
								                    }					                    
								                	SOAPElement fac_perib = Tributos.addChildElement("Tributo");		
								            		SOAPElement IdTri = fac_perib.addChildElement("Id");		                
								            		IdTri.setValue(this.FE_IMP_PRO);
								            		SOAPElement DescTri = fac_perib.addChildElement("Desc");		                
								            		DescTri.setValue("Percepci�n IIBB Pcia Bs As");
								            		SOAPElement BaseImpTri = fac_perib.addChildElement("BaseImp");		                
								            		BaseImpTri.setValue(provBase_imp);	
								            		SOAPElement AlicTri = fac_perib.addChildElement("Alic");		                
								            		AlicTri.setValue(provAlic);
								            		SOAPElement ImporteTri = fac_perib.addChildElement("Importe");		                
								            		ImporteTri.setValue(provImporte);
								                }
								                
								                if (!(rs.getDouble("fac_impin")==0.0)){
								                	String impinBase_imp = impNeto;
								                    String impinImporte = String.valueOf(Math.abs(rs.getDouble("fac_impin")));
								                    String impinAlic = "0";
								                    if (!impinBase_imp.equals("0")){
								                    	impinAlic = String.valueOf(Math.round(Math.abs(rs.getDouble("fac_impin")) / Double.valueOf(impNeto) * 100 *100)/100);
								                    }					                    
								                	SOAPElement fac_impin = Tributos.addChildElement("Tributo");		
								            		SOAPElement IdTri = fac_impin.addChildElement("Id");		                
								            		IdTri.setValue(this.FE_IMP_INT);
								            		SOAPElement DescTri = fac_impin.addChildElement("Desc");		                
								            		DescTri.setValue("Impuesto Interno");
								            		SOAPElement BaseImpTri = fac_impin.addChildElement("BaseImp");		                
								            		BaseImpTri.setValue(impinBase_imp);	
								            		SOAPElement AlicTri = fac_impin.addChildElement("Alic");		                
								            		AlicTri.setValue(impinAlic);
								            		SOAPElement ImporteTri = fac_impin.addChildElement("Importe");		                
								            		ImporteTri.setValue(impinImporte);
								                }	
								                
								                if (!(rs.getDouble("fac_peicf")==0.0)){
								                	String impinBase_imp = impNeto;
								                    String impinImporte = String.valueOf(Math.abs(rs.getDouble("fac_peicf")));
								                    String impinAlic = "0";
								                    if (!impinBase_imp.equals("0")){
								                    	impinAlic = String.valueOf(Math.round(Math.abs(rs.getDouble("fac_peicf")) / Double.valueOf(impNeto) * 100 *100)/100);
								                    }					                    
								                	SOAPElement fac_peicf = Tributos.addChildElement("Tributo");		
								            		SOAPElement IdTri = fac_peicf.addChildElement("Id");		                
								            		IdTri.setValue(this.FE_IMP_PRO);
								            		SOAPElement DescTri = fac_peicf.addChildElement("Desc");		                
								            		DescTri.setValue("Percepci�n IIBB CABA");
								            		SOAPElement BaseImpTri = fac_peicf.addChildElement("BaseImp");		                
								            		BaseImpTri.setValue(impinBase_imp);	
								            		SOAPElement AlicTri = fac_peicf.addChildElement("Alic");		                
								            		AlicTri.setValue(impinAlic);
								            		SOAPElement ImporteTri = fac_peicf.addChildElement("Importe");		                
								            		ImporteTri.setValue(impinImporte);
								                }   
							            	}
						                String ivaBase_imp = impNeto;
						                String importeIva = imp_iva;
									    String idIva = FE_IVA_000;
								        if (!importeIva.equals("0")){
								        	idIva = FE_IVA_210;// 21%
								        }
							            		
							            		
						               //Agrego tasas de IVA
								       SOAPElement Iva = FECAEDetRequest.addChildElement("Iva");	
								            SOAPElement AlicIva = Iva.addChildElement("AlicIva");		
								            	SOAPElement IdIva = AlicIva.addChildElement("Id");		                
								            	IdIva.setValue(idIva);
								            	SOAPElement BaseImpIva = AlicIva.addChildElement("BaseImp");		                
								            	BaseImpIva.setValue(ivaBase_imp);	
								            	SOAPElement ImporteIva = AlicIva.addChildElement("Importe");		                
								            	ImporteIva.setValue(importeIva);					            	
								        /*Opcionales                       	
								       
								       SOAPElement Opcionales = FECAEDetRequest.addChildElement("Opcionales");	
								       		SOAPElement Opcional = Opcionales.addChildElement("Opcional");		
										      	SOAPElement IdOP = Opcional.addChildElement("Id");		                
										      	IdOP.setValue(idOP);	
										      	SOAPElement ValorOp = Opcional.addChildElement("Valor");		                
										      	ValorOp.setValue(valorOp);*/									            
			            
			            soapMessage.saveChanges();		            
			            return soapMessage;
			    	}
			    	
			    	if (DatosOk){
				        DatosOk = false;		
						System.out.println("------------------------------------------");
						System.out.println("ERROR FACTTURACI�N ELECTR�NICA");
						System.out.println("En  createFEGenerarFactura");
						System.out.println("error datos mal - "+DatoMal);	
						System.out.println("------------------------------------------");        
			    	}
			    }else{
					DatosOk = false;
					DatoMal = "No se encontraron los datos del comprobante.";
					System.out.println("------------------------------------------");
					System.out.println("ERROR FACTTURACI�N ELECTR�NICA");
					System.out.println("En  createFEGenerarFactura");
					System.out.println("error - "+DatoMal);	
					System.out.println("------------------------------------------");
			    }
			}else{		
		        DatosOk = false;
		        DatoMal = "Error de acceso.";
				System.out.println("------------------------------------------");
				System.out.println("ERROR FACTTURACI�N ELECTR�NICA");
				System.out.println("En  createFEGenerarFactura");
				System.out.println("error - "+DatoMal);	
				System.out.println("------------------------------------------");
			}
		}catch(SQLException e){
			e.printStackTrace();			
	        DatosOk = false;
	        DatoMal = "Error de Base de datos.";
			System.out.println("------------------------------------------");
			System.out.println("ERROR FACTTURACI�N ELECTR�NICA");
			System.out.println("En  createFEGenerarFactura");
			System.out.println("error - "+DatoMal);	
			System.out.println("------------------------------------------");			
		}catch(SOAPException e){
			e.printStackTrace();
	        DatosOk = false;
	        DatoMal = "Error Al formar el xml.";
			System.out.println("------------------------------------------");
			System.out.println("ERROR FACTTURACI�N ELECTR�NICA");
			System.out.println("En  createFEGenerarFactura");
			System.out.println("error - "+DatoMal);	
			System.out.println("------------------------------------------");
		}catch(Exception e){
				e.printStackTrace();	
				DatosOk = false;
				DatoMal = "Error de systema.";
				System.out.println("------------------------------------------");
				System.out.println("ERROR FACTTURACI�N ELECTR�NICA");
				System.out.println("En  createFEGenerarFactura");
				System.out.println("error - "+DatoMal);					
				System.out.println("error - "+e.getMessage());	
				System.out.println("------------------------------------------");
		} 
		mensaje=DatoMal;
		return null;
	}
	
	private void GetCuit(){
        X509Certificate pCertificate = null;
        String SignerDN = null;        
        try {
            // Create a keystore using keys from the pkcs#12 p12file
            KeyStore ks = KeyStore.getInstance("pkcs12");
            FileInputStream p12stream = new FileInputStream ( this.certPATH ) ;
            ks.load(p12stream, p12pass.toCharArray());
            p12stream.close();
            pCertificate = (X509Certificate)ks.getCertificate(signer);
            SignerDN = pCertificate.getSubjectDN().toString();
            String[] sourceCert=SignerDN.split(",");
            int i=0;
            while (i<sourceCert.length){            	
            	String[] aux=sourceCert[i].split("=");
            	String auxString="";
            	if(aux.length==2){
            		if (aux[0].trim().toUpperCase().equals("SERIALNUMBER")){
            			auxString=aux[1].trim().toUpperCase();
            			aux=auxString.split(" ");
            			if(aux.length==2){
                    		if (aux[0].trim().toUpperCase().equals("CUIT")){
                    			this.cuit=aux[1].trim().toUpperCase();                   			
                    		}
                    	}
            		}
            	}
            	i++;
            }                        
            
            // Create a list of Certificates to include in the final CMS
        }
        catch (Exception e) {
            e.printStackTrace();
			System.out.println("errr 6");
        } 
	}
	
	public boolean GuradarDatos(String datos){
		System.out.println(datos);
		String fichero = getPath()+"\\WSAA-"+fun.Format(fun.today, "yyyy-MM-dd HH_mm_ss")+".XML";
		BufferedWriter writer = null;
		try{
		    writer = new BufferedWriter( new FileWriter( fichero));
		    writer.write( datos);
		    return true;
		}catch( IOException e){		
			e.printStackTrace();
			String DatoMal = "Error al tratar de guardar el xml de registro.";
			System.out.println("------------------------------------------");
			System.out.println("Fichero: "+ fichero);
			System.out.println("ERROR FACTTURACI�N ELECTR�NICA");
			System.out.println("error - "+DatoMal);	
			System.out.println("xml - "+datos);	
			System.out.println("------------------------------------------");
			return false;
		}
		finally{
		    try{
		        if ( writer != null){
		        	writer.close( );
		        }
		    }catch ( IOException e){

				System.out.println("errr8");
		    }
		}		
	}
	
	private String getPath(){
		String path=(this.getClass().getClassLoader().getResource("/").getPath());
		String[] carpetas=path.split("/");
		String npath ="";
		for (int x=1;x<carpetas.length-4;x++){
			npath += carpetas[x] +"\\";
		}
		npath+="conf";
		return npath.replaceAll("%20", " ");
	}
	
	   /** MODOD DE USO
		* Dummy para probar devuelve booelan depedne del sevidoe de afip ( sin parametro)
		*
		*   CompConsultar(Letra="A"/"B"/"C",TipoCo="F"/"C"/"D",ptvta,nroco) 
		*   devuelde el xml con los datos del comprobante
		*   
		*   CompConsultar(TipoCo="CODIGO AFIP DE COMPROBANTES",ptvta,nroco) 
		*   devuelde el xml con los datos del comprobante
		*
		*	CompUltimoAutorizado(Letra="A"/"B"/"C",TipoCo="F"/"C"/"D",ptvta)
		*	Devuelve el numero de comprobante 
		*	
		*	CompUltimoAutorizado(TipoCo="CODIGO AFIP DE COMPROBANTES",ptvta)
		*	Devuelve el numero de comprobante
		*	
		*	GenerarFactura(Nrove)
		*	Genera una factura fe
		*	
		*	devuelve un map
		*	si map.get("err") es que no se pudo generar y ese es el mensaje de error
		*	o devulve los siguientes datos en esa posision		
		*	    		
		*	repuesta.get("NroCAE");
		*	repuesta.get("FecCAE");
		*	repuesta.get("NroCo");
		*	
		*	y si no hubo error tenes q hacer un update de tu comprobante para guardar el nuevo nroco, cae y su fecha de vencimiento 
		*/
	
 }
