int unit;
Snake s;
Fruit f;
DigestedFruit d = new DigestedFruit(-1,-1, color(0));
boolean overlap = false;
boolean readyToAdd = false;

void setup(){
  size(500, 500);
  frameRate(60);
  unit = 50;
  stroke(200);
  s = new Snake();
  f = new Fruit();
  f.place();
  s.insert(new Square(3*unit, unit));
  s.insert(new Square(2*unit, unit));
  s.insert(new Square(unit, unit));
  s.insert(new Square(0, unit));
}

void draw(){
  if(frameCount % 10 == 0){
  
  for (int i=1; i<int(width/unit); i++){
    line(unit*i, 0, unit*i, height);
  }
  for (int i=1; i<int(height/unit); i++){
    line(0, unit*i, width, unit*i);
  }
  
  s.move();
  s.changeDir();
  if (s.head.square.equals(f.square)){
    d = new DigestedFruit(f.square);
    f = new Fruit();
  }  
  d.display();
  if (readyToAdd == true){
    s.insert(d.square);
    readyToAdd = false;
  }
  if (s.tail.square.equals(d.square)){
    overlap = true;
    println(d.square.x);
    println(s.tail.square.x);
  }
  if (!s.tail.square.equals(d.square) && overlap == true){
    readyToAdd = true;
    overlap = false;
  }
  
  
  }
  background(180);
  f.display();
  s.display();
}

void keyPressed(){
  if (key == CODED){
    if (keyCode == UP && s.direction != "down"){
      s.direction = "up";
    } 
    else if (keyCode == DOWN && s.direction != "up"){
      s.direction = "down";
    } 
    else if (keyCode == LEFT && s.direction != "right"){
      s.direction = "left";
    }
    else if (keyCode == RIGHT && s.direction != "left"){
      s.direction = "right";
    }
  }
}

class Square{
  int x;
  int y;
  color col;
  Square(int x, int y){
    this.x= x;
    this.y= y;
    this.col = color(255,255,255,100);
  }
  Square(int x, int y, color col){
    this(x,y);
    this.col = col;
  }
  void set(Square input){
    x = input.x;
    y = input.y;
  }
  boolean equals(Square input){
    return (x==input.x && y ==input.y);
  }
}

class LinkedCell{
  Square square;
  LinkedCell next;
  LinkedCell prev;
  LinkedCell(Square square, LinkedCell next, LinkedCell prev){
    this.square = square;
    this.next = next;
    this.prev = prev;
  }
}

class Snake {
  String[] directions = {"up", "right", "down", "left"};
  String direction;
  LinkedCell head;
  LinkedCell tail;
  Snake(){
    head = null;
    direction = directions[(int(random(3)))];
  }
  
  void insert(Square c) {
   if (head==null){
     head = new LinkedCell(c, null, null);
     tail = head;
   } else {
    LinkedCell newNode = new LinkedCell(c, null, tail);
    tail.next = newNode;
    tail = newNode;
    }
  }
  
  void move(){
    Square nextsquare = new Square(0,0);
    Square thissquare = new Square(0,0);
    for (LinkedCell current = head; current != null; current = current.next){
      thissquare.set(current.square);
      if (current.prev==null) {
      }
      else {       
        current.square.set(nextsquare);
      } 
      nextsquare.set(thissquare);
    }
  }
  
  void changeDir(){
    if (direction == "up"){
      head.square.y -= unit;
    } 
    else if (direction == "down"){
      head.square.y += unit;
    } 
    else if (direction == "left"){
      head.square.x -= unit;
    } 
    else if (direction == "right"){
      head.square.x += unit;
    }
  }
  
  void display(){
    
    for (LinkedCell current = head; current != null; current = current.next){
      fill(255,255,255,100);
      rect(current.square.x, current.square.y, unit, unit);
    }
  }
  
  
}

class Fruit{
  Square square;
  String state;
  
  Fruit(){
    square = new Square(int(random(width/unit))*unit, int(random(height/unit))*unit);
    square.col = color(int(random(235,255)), int(random(235,255)), int(random(235,255)),100);
    state = "uneaten";
  }
  
  Fruit(int x, int y, color col){
    square = new Square(x,y,col);
  }
  
  Fruit(Square s){
    square = s;
  }
  
  void set(Square s){
    square.x = s.x;
    square.y = s.y;
  }
  
  void place(){
    square.x = int(random(width/unit))*unit;
    square.y = int(random(height/unit))*unit;
  }
  
  void display(){
    if (state == "uneaten"){
    fill(square.col);
    rect(square.x, square.y, unit, unit);
    }
  }
}

class DigestedFruit extends Fruit{
  DigestedFruit(){
    super();
  }
  DigestedFruit(int x, int y, color col){
    super(x, y, col);
  }
  DigestedFruit(Square s){
    super(s);
  }
}