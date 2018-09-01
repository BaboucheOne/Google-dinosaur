public class Player {
  
  private PVector _position = new PVector();
  private PVector _velocity = new PVector();
  private PVector _acceleration = new PVector();
  
  private final PVector _gravity = new PVector(0, 0.25);
  private final PVector _jumpForce = new PVector(0, -6.75);
  
  private boolean _dead = false;
  private boolean _duck = false;
  private boolean _grounded = true;
  
  private Sprite _sptrDuck;
  private Sprite _sptrWalk;
  private Sprite _sptrDead;
  
  public BoxCollider collBox;
  private final PVector _scaleWalk = new PVector(40, 43);
  private final PVector _scaleDuck = new PVector(55, 20);
  
  Player(float x, float y) {
    _sptrWalk = new Sprite("img/walk", 2, 250);
    _sptrDuck = new Sprite("img/duck", 2, 250);
    _sptrDead = new Sprite("img/dead.png", 1, 0);
    
    _position.set(x, y);
    collBox = new BoxCollider(_position, new PVector(40, 43));
  }
  
  public void Kill() {
    _sptrDead.Position.set(_position);
    _dead = true;
  }
  
  public void Reset() {
    _dead = false;
    _duck = false;
    _position.set(_position.x, height-60);
  }
  
  public void Show() {    
    if(!_dead) {
      if(_duck) {
        _sptrDuck.Position.set(_position);
        _sptrDuck.Show();
        
        if(!_grounded) {
          _acceleration.add(new PVector(0, 0.25));
        }
      } else {
        _sptrWalk.Position.set(_position);
        _sptrWalk.Show();
      }
    } else {
      _sptrDead.Show();
    }
  }
  
  public void Move() {  
    if(_dead) { return; }
    
    if(keyPressed) {
      if(keyCode == UP && _grounded) {
        _acceleration.add(_jumpForce);
        _duck = false;
      }
      
      if(keyCode == DOWN) {
        _duck = true;
      }
    } else {
      _duck = false;
    }
    
    _acceleration.add(_gravity);
    
    
    _velocity.add(_acceleration);
    _position.add(_velocity);
    _acceleration.mult(0);
    
    if(_position.y >= height - 60) {
      _position.y = height - 60;
      _velocity.mult(0);
      _grounded = true;
    }
    
    if(_position.y < height - 60) {
      _grounded = false;
    }
    
    if(!_duck) {
      collBox.Scale.set(_scaleWalk);
      collBox.Position.set(_position);
    } else {
      collBox.Scale.set(_scaleDuck);
      collBox.Position.set(PVector.add(_position, new PVector(0, 20)));
    }
    
    collBox.Update();
  }
}
