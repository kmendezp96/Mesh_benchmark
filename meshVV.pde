class mesh {
  ArrayList <Vertex> lista;
  PShape s;
  
  mesh(){
    s = createShape();
    this.lista = new ArrayList<Vertex> ();
  }
  
  void agregar (Vertex nuevo){
    this.lista.add(nuevo);
  
  }  
  int tam (){
    return this.lista.size();
  }
  void immediateDrawing (){
    beginShape(TRIANGLE);
    for (int i=0; i<this.lista.size();i++){
      vertex(this.lista.get(i).vx, this.lista.get(i).vy, this.lista.get(i).vz);
      for (int j=0;j<this.lista.get(i).vertices.size();j++){
        vertex(this.lista.get(i).vertices.get(j).vx, this.lista.get(i).vertices.get(j).vy, this.lista.get(i).vertices.get(j).vz);  
      }
    
    }
    endShape();
  }
  void InitialShape(){
    s.beginShape(TRIANGLE);
    for (int i=0; i<this.lista.size();i++){
      s.vertex(this.lista.get(i).vx, this.lista.get(i).vy, this.lista.get(i).vz);
      for (int j=0;j<this.lista.get(i).vertices.size();j++){
        s.vertex(this.lista.get(i).vertices.get(j).vx, this.lista.get(i).vertices.get(j).vy, this.lista.get(i).vertices.get(j).vz);  
      }
    
    }
    s.endShape();
  
  }
  void retainedDrawing (){
    shape(s, 0, 0);
  }
}