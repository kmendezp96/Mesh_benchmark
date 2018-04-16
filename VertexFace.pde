class VertexFace{
  float vx;
  float vy;
  float vz;
  ArrayList <Face> caras= new ArrayList<Face> ();
  VertexFace (float vx,float vy,float vz){
    this.vx = vx;
    this.vy = vy;
    this.vz = vz;
  }
  
  void agregarCara(Face cara){
    this.caras.add(cara);
  }
  
  int numCaras (){
    return this.caras.size();
  }
}