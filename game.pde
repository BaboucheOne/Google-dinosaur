public class Game {
  
  private PFont _fontOver = createFont("font/munro.ttf", 50);
  private PFont _fontScore = createFont("font/munro.ttf", 25);
  private int _gameState = 0; //0: Have to touch an input to start | 1: playing | 2: dead
  
  private Sprite[] _ground = new Sprite[3];
  private float _speed = 1.0f;
  private int _score = 0;
  private int _highScore = 0;
  
  private ArrayList<Sprite> _decors = new ArrayList<Sprite>(); //Maybe replace by array => more menory efficent
  private ArrayList<Enemy> _enemies = new ArrayList<Enemy>();
  
  private double _nextSpawnDecors = 0.0f;
  private double _nextSpawnEnemy = 0.0f;
  private double _nextAddScore = 0.0f;
  
  private Player _ply;
  
  private Sprite _sptrBtnReturn = new Sprite("img/restart.png", 1, 0);
  
  Game() {
    _ply = new Player(30, height - 60);
    
    for(int i = 0; i < _ground.length; i++) {
     _ground[i] = new Sprite("img/ground.png", 1, 0);
     _ground[i].Position.set(0 + i * 544, height-25);
    }
    
    _nextSpawnDecors = millis();
  }
  
  public void Restart() {
    _decors.clear();
    _enemies.clear();
    _highScore = _score;
    _score = 0;
    _speed = 1.0f;
    _gameState = 0;
    _ply.Reset();
    _nextSpawnDecors = millis();
  }
  
  public void Run() {
    
    if(keyPressed && _gameState == 0) {
      _gameState = 1;
    } else if(_gameState != 1) {
      return;
    }
    
    _ply.Move();
    
    if(_nextSpawnEnemy <= millis()) {
       _nextSpawnEnemy = millis() + random(1000, 4000);
       
             switch((int)random(5)) {
        case 0:
          _enemies.add(new Bird());
        break;
        
        case 1:
          _enemies.add(new CactusAloneSmall());
        break;
        
        case 2:
          _enemies.add(new CactusGroupSmall());
        break;
        
        case 3:
          _enemies.add(new CactusAloneBig());
        break;
        
        case 4:
          _enemies.add(new CactusGroupBig());
        break;
      }
    }
    
    if(_nextSpawnDecors <= millis()) {
      _nextSpawnDecors = millis() + random(1000, 4000);
      
      Sprite n;
      
      if(random(1) < 0.5) {
        n = new Sprite("img/cloud.png", 1, 0);
        n.Position.set(width + 100, random(50, height - 150));
      } else {
        n =new Sprite("img/dune.png", 1, 0);
        n.Position.set(width + 100, height - 30);
      }
      
      _decors.add(n);
    }
    
    if(_speed < 5) {
    _speed += 0.0015f;
    }
    
    if(_nextAddScore <= millis()) {
      _nextAddScore = millis() + 150;
      _score += 1;
    }
    
  }
  
  public void Display() {
    
    if(_gameState == 2) {
      WindowGameOver();
    }
    
    fill(0);
    textFont(_fontScore);
    text(_score, width-50, 30);
    if(_highScore != 0) {
      text("HI  " + _highScore, width-150, 30);
    }
    
    for(int i = 0; i < _ground.length; i++) {
      if(_gameState == 1) {
        _ground[i].Position.x -= _speed;
      }
      
      if(_ground[i].Position.x <= -544) {
        _ground[i].Position.set((_ground.length-1) * 544, height-25);
      }
      _ground[i].Show();
    }
    
    for(int i = _decors.size()-1; i >= 0; i--) {
      if(_gameState == 1) {
        _decors.get(i).Position.x -= _speed;
      }
      
      _decors.get(i).Show();
      
      if(_decors.get(i).Position.x <= -200) {
        _decors.remove(i);
      }
    }
    
    for(int i = _enemies.size()-1; i >= 0; i--) {
      if(_gameState == 1) {
        _enemies.get(i).Move(0.025);
      }
      _enemies.get(i).Show();
      
      if(_enemies.get(i).Position.x <= -75) {
        _enemies.remove(i);
      }
    }
    
    _ply.Show(); 
  }
  
  private void WindowGameOver() {
    
    textFont(_fontOver);
    text("game over", width/2 - 100, height/2);
    _sptrBtnReturn.Position.set(width/2, height/2 + 15);
    _sptrBtnReturn.Show();
    
    if(mouseX >= _sptrBtnReturn.Position.x && mouseX <= _sptrBtnReturn.Position.x + 34) {
      if(mouseY >= _sptrBtnReturn.Position.y && mouseY <= _sptrBtnReturn.Position.y + 30) {
        Restart();
      }
    }
  }
  
  
  public void Collide() {
    if(_gameState != 1) { return; }
    
    for(int i = 0; i < _enemies.size(); i++) {
      Sat.ColliderResult r = Sat.Collide(_ply.collBox, _enemies.get(i).collBox, new PVector(0.07, 0));
      if(r.Intersect || r.WillIntersect) {
        _ply.Kill();
        _gameState = 2;
      }
    }
  }
}
