class Vertex{
  float vx;
  float vy;
  float vz;
  ArrayList <Vertex> vertices= new ArrayList<Vertex> ();
  Vertex (float vx,float vy,float vz){
    this.vx = vx;
    this.vy = vy;
    this.vz = vz;
  }
  
  void agregarConexion(float vx,float vy,float vz){
    this.vertices.add(new Vertex (vx,vy,vz));
  }
  
  int numConexiones (){
    return this.vertices.size();
  }
}