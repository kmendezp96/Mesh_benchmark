class meshFV {
  ArrayList <VertexFace> listaVertices;
  ArrayList <Face> listaCaras;
  PShape s;
  
  meshFV(){
    s = createShape();
    this.listaVertices = new ArrayList<VertexFace> ();
    this.listaCaras = new ArrayList<Face> ();
  }
  
  void agregarVertice (VertexFace nuevo){
    this.listaVertices.add(nuevo);
  
  }  
  
  void agregarCara (Face nueva){
    this.listaCaras.add(nueva);
  
  }  
  

  void immediateDrawing (){
    beginShape(TRIANGLE);
    for (int i=0; i<this.listaCaras.size();i++){     
      vertex(this.listaCaras.get(i).v1.vx,this.listaCaras.get(i).v1.vy,this.listaCaras.get(i).v1.vz);  
      vertex(this.listaCaras.get(i).v2.vx,this.listaCaras.get(i).v2.vy,this.listaCaras.get(i).v2.vz);  
      vertex(this.listaCaras.get(i).v3.vx,this.listaCaras.get(i).v3.vy,this.listaCaras.get(i).v3.vz);  
    }
    endShape();
  }
  void InitialShape(){
    s.beginShape(TRIANGLE);
    for (int i=0; i<this.listaCaras.size();i++){     
      s.vertex(this.listaCaras.get(i).v1.vx,this.listaCaras.get(i).v1.vy,this.listaCaras.get(i).v1.vz);  
      s.vertex(this.listaCaras.get(i).v2.vx,this.listaCaras.get(i).v2.vy,this.listaCaras.get(i).v2.vz);  
      s.vertex(this.listaCaras.get(i).v3.vx,this.listaCaras.get(i).v3.vy,this.listaCaras.get(i).v3.vz);  
    }
    s.endShape();
  
  }
  void retainedDrawing (){
    shape(s, 0, 0);
  }
}