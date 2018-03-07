package funciones;

public class Columna {
	private String titulo="";
	private String name="";
	private String index="";
	private String ancho="0 px";
	private String align="left";
	private Boolean hidden=false;

	public Columna(){}

	public Columna(String titulo,String name,String index,String ancho,String align,Boolean hidden){
		this.titulo=titulo;
		this.name=name;
		this.index=index;
		this.ancho=ancho;
		this.align=align;
		this.hidden=hidden;	
	}


	public void setTitulo(String titulo){
		this.titulo=titulo;
	}
	public void setName(String name){
		this.name=name;
	}
	public void setIndex(String index){
		this.index=index;
	}
	public void setAncho(String ancho){
		this.ancho=ancho;
	}
	public void setAlign(String align){
		this.align=align;
	}	
	public void setHidden(Boolean hidden){
		this.hidden=hidden;
	}

	public String getTitulo(){
		return this.titulo;
	}
	public String getName(){
		return this.name;
	}
	public String getIndex(){
		return this.index;
	}
	public String getAncho(){
		return this.ancho;
	}
	public String getAlign(){
		return this.align;
	}	
	public Boolean getHidden(){
		return this.hidden;
	}
	public String getColModel(){
		return "{ name : \""+this.name+"\", index: \""+this.index+"\",width : "+this.ancho+", align:\""+this.align+"\", hidden:"+(this.hidden?"true":"false")+" }";
	}
	

}
