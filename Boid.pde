class Boid {
  Node node;
  int grabsMouseColor;
  int avatarColor;
  // fields
  Vector position, velocity, acceleration, alignment, cohesion, separation; // position, velocity, and acceleration in
  // a vector datatype
  float neighborhoodRadius; // radius in which it looks for fellow boids
  float maxSpeed = 4; // maximum magnitude for the velocity vector
  float maxSteerForce = .1f; // maximum magnitude of the steering vector
  float sc = 3; // scale factor for the render of the boid
  float flap = 0;
  float t = 0;
  
  boolean immediate = false;
  boolean representationVV = false;
  

  Boid(Vector inPos,boolean representationVV, boolean immediate)  {
    this.immediate = immediate;
    this.representationVV = representationVV;
    grabsMouseColor = color(0, 0, 255);
    avatarColor = color(255, 255, 0);
    position = new Vector();
    position.set(inPos);
    node = new Node(scene) {
      // Note that within visit() geometry is defined at the
      // node local coordinate system.
      @Override
      public void visit() {
        if (animate)
          run(flock);
        render();
      }

      // Behaviour: tapping over a boid will select the node as
      // the eye reference and perform an eye interpolation to it.
      @Override
      public void interact(TapEvent event) {
        if (avatar != this && scene.eye().reference() != this) {
          avatar = this;
          scene.eye().setReference(this);
          scene.interpolateTo(this);
        }
      }
    };
    node.setPosition(new Vector(position.x(), position.y(), position.z()));
    velocity = new Vector(random(-1, 1), random(-1, 1), random(1, -1));
    acceleration = new Vector(0, 0, 0);
    neighborhoodRadius = 100;
  }

  public void run(ArrayList<Boid> boids) {
    t += .1;
    flap = 10 * sin(t);
    // acceleration.add(steer(new Vector(mouseX,mouseY,300),true));
    // acceleration.add(new Vector(0,.05,0));
    if (avoidWalls) {
      acceleration.add(Vector.multiply(avoid(new Vector(position.x(), flockHeight, position.z())), 5));
      acceleration.add(Vector.multiply(avoid(new Vector(position.x(), 0, position.z())), 5));
      acceleration.add(Vector.multiply(avoid(new Vector(flockWidth, position.y(), position.z())), 5));
      acceleration.add(Vector.multiply(avoid(new Vector(0, position.y(), position.z())), 5));
      acceleration.add(Vector.multiply(avoid(new Vector(position.x(), position.y(), 0)), 5));
      acceleration.add(Vector.multiply(avoid(new Vector(position.x(), position.y(), flockDepth)), 5));
    }
    flock(boids);
    move();
    checkBounds();
  }

  Vector avoid(Vector target) {
    Vector steer = new Vector(); // creates vector for steering
    steer.set(Vector.subtract(position, target)); // steering vector points away from
    steer.multiply(1 / sq(Vector.distance(position, target)));
    return steer;
  }

  //-----------behaviors---------------

  void flock(ArrayList<Boid> boids) {
    //alignment
    alignment = new Vector(0, 0, 0);
    int alignmentCount = 0;
    //cohesion
    Vector posSum = new Vector();
    int cohesionCount = 0;
    //separation
    separation = new Vector(0, 0, 0);
    Vector repulse;
    for (int i = 0; i < boids.size(); i++) {
      Boid boid = boids.get(i);
      //alignment
      float distance = Vector.distance(position, boid.position);
      if (distance > 0 && distance <= neighborhoodRadius) {
        alignment.add(boid.velocity);
        alignmentCount++;
      }
      //cohesion
      float dist = dist(position.x(), position.y(), boid.position.x(), boid.position.y());
      if (dist > 0 && dist <= neighborhoodRadius) {
        posSum.add(boid.position);
        cohesionCount++;
      }
      //separation
      if (distance > 0 && distance <= neighborhoodRadius) {
        repulse = Vector.subtract(position, boid.position);
        repulse.normalize();
        repulse.divide(distance);
        separation.add(repulse);
      }
    }
    //alignment
    if (alignmentCount > 0) {
      alignment.divide((float) alignmentCount);
      alignment.limit(maxSteerForce);
    }
    //cohesion
    if (cohesionCount > 0)
      posSum.divide((float) cohesionCount);
    cohesion = Vector.subtract(posSum, position);
    cohesion.limit(maxSteerForce);

    acceleration.add(Vector.multiply(alignment, 1));
    acceleration.add(Vector.multiply(cohesion, 3));
    acceleration.add(Vector.multiply(separation, 1));
  }

  void move() {
    velocity.add(acceleration); // add acceleration to velocity
    velocity.limit(maxSpeed); // make sure the velocity vector magnitude does not
    // exceed maxSpeed
    position.add(velocity); // add velocity to position
    node.setPosition(position);
    node.setRotation(Quaternion.multiply(new Quaternion(new Vector(0, 1, 0), atan2(-velocity.z(), velocity.x())),
      new Quaternion(new Vector(0, 0, 1), asin(velocity.y() / velocity.magnitude()))));
    acceleration.multiply(0); // reset acceleration
  }

  void checkBounds() {
    if (position.x() > flockWidth)
      position.setX(0);
    if (position.x() < 0)
      position.setX(flockWidth);
    if (position.y() > flockHeight)
      position.setY(0);
    if (position.y() < 0)
      position.setY(flockHeight);
    if (position.z() > flockDepth)
      position.setZ(0);
    if (position.z() < 0)
      position.setZ(flockDepth);
  }

  void render() {
    pushStyle();

    // uncomment to draw boid axes
    //scene.drawAxes(10);

    int kind = TRIANGLES;
    strokeWeight(2);
    stroke(color(0, 255, 0));
    fill(color(255, 0, 0, 125));

    // visual modes
    switch(mode) {
    case 1:
      noFill();
      break;
    case 2:
      noStroke();
      break;
    case 3:
      strokeWeight(3);
      kind = POINTS;
      break;
    }

    // highlight boids under the mouse
    if (node.track(mouseX, mouseY)) {
      noStroke();
      fill(grabsMouseColor);
    }

    // highlight avatar
    if (node == avatar) {
      noStroke();
      fill(avatarColor);
    }

    //draw boid
    if (representationVV){
      mesh malla = new mesh();
      Vertex ve1 = new Vertex(3 * sc, 0, 0);
      ve1.agregarConexion(-3 * sc, 2 * sc, 0);
      ve1.agregarConexion(-3 * sc, -2 * sc, 0);
      
      Vertex ve2 = new Vertex(-3 * sc, 2 * sc, 0);
      ve2.agregarConexion(3 * sc, 0, 0);
      ve2.agregarConexion(-3 * sc, 0, 2 * sc);
      
      Vertex ve3 = new Vertex(-3 * sc, -2 * sc, 0);
      ve3.agregarConexion(3 * sc, 0, 0);
      ve3.agregarConexion(-3 * sc, 0, 2 * sc);
      
      Vertex ve4 = new Vertex(-3 * sc, 0, 2 * sc);
      ve4.agregarConexion(-3 * sc, 2 * sc, 0);
      ve4.agregarConexion(-3 * sc, -2 * sc, 0);
      
      malla.agregar(ve1);
      malla.agregar(ve2);
      malla.agregar(ve3);
      malla.agregar(ve4);
      if (immediate){
        malla.immediateDrawing();
      }
      else{
        malla.InitialShape();
        malla.retainedDrawing();
      
      }
      
    }else{
        meshFV malla = new meshFV();
      
        VertexFace ve1 = new VertexFace(3 * sc, 0, 0);  
        VertexFace ve2 = new VertexFace(-3 * sc, 2 * sc, 0);     
        VertexFace ve3 = new VertexFace(-3 * sc, -2 * sc, 0);
        VertexFace ve4 = new VertexFace(-3 * sc, 0, 2 * sc);
        Face fa1 = new Face(ve1, ve2, ve3);
        Face fa2 = new Face(ve1, ve2, ve4);
        Face fa3 = new Face(ve1, ve4, ve3);
        Face fa4 = new Face(ve4, ve2, ve3);
        
        ve1.agregarCara(fa1);
        ve1.agregarCara(fa2);
        ve1.agregarCara(fa3);
        
        ve2.agregarCara(fa1);
        ve2.agregarCara(fa2);
        ve2.agregarCara(fa4);
        
        ve3.agregarCara(fa1);
        ve3.agregarCara(fa3);
        ve3.agregarCara(fa4);
        
        ve4.agregarCara(fa2);
        ve4.agregarCara(fa3);
        ve4.agregarCara(fa4);
    
        malla.agregarVertice(ve1);
        malla.agregarVertice(ve2);
        malla.agregarVertice(ve3);
        malla.agregarVertice(ve4);
        
        malla.agregarCara(fa1);
        malla.agregarCara(fa2);
        malla.agregarCara(fa3);
        malla.agregarCara(fa4);
        
        if (immediate){
          malla.immediateDrawing();
        }
        else{
          malla.InitialShape();
          malla.retainedDrawing();
        }
    }
    
    

    /*
    //v1
    vertex(3 * sc, 0, 0); 
    //v2
    vertex(-3 * sc, 2 * sc, 0);
    //v3
    vertex(-3 * sc, -2 * sc, 0);
    
    //v1
    vertex(3 * sc, 0, 0);
    //v2
    vertex(-3 * sc, 2 * sc, 0);
    //v4
    vertex(-3 * sc, 0, 2 * sc);

    //v1
    vertex(3 * sc, 0, 0);
    //v4
    vertex(-3 * sc, 0, 2 * sc);
    //v3
    vertex(-3 * sc, -2 * sc, 0);

    //v4
    vertex(-3 * sc, 0, 2 * sc);
    //v2
    vertex(-3 * sc, 2 * sc, 0);
    //v3
    vertex(-3 * sc, -2 * sc, 0);*/

    popStyle();
  }
}