Game game;

public float Deltatime = 0.0f;

void setup() {
  size(1000, 300, P2D);
  game = new Game();
}

void draw() {
  frameRate(60);
  
  float startDelta = millis();
  background(255);
  
  game.Run();
  game.Collide();
  game.Display();
  
  Deltatime = startDelta - Deltatime;
}
