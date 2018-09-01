public class Enemy {
  
  public PVector Position = new PVector();
  public BoxCollider collBox;
  private Sprite _sptr;
  private PVector _translateVector = new PVector();
  
  
  Enemy(PVector pos, PVector size, Sprite sptr) {    
    Position.set(pos);
    collBox = new BoxCollider(Position, size);
    _sptr = sptr;
  }
  
  public void Move(float x) {
    _translateVector.sub(x, 0);
    Position.add(_translateVector);
    
    collBox.Position.set(Position);
    collBox.Update();
  }
  
  public void Show() {
    _sptr.Position.set(Position);
    _sptr.Show();
  }  
}

public class Bird extends Enemy {
  Bird() {
    super(new PVector(width + 100, height - 85), new PVector(42, 30),
    new Sprite("img/bird", 2, 250));
  }
}

public class CactusAloneBig extends Enemy {
  CactusAloneBig() {
    super(new PVector(width + 100, height - 55), new PVector(23, 46),
    new Sprite("img/cactus_alone_big.png", 1, 0));
  }
}
public class CactusGroupBig extends Enemy {
  CactusGroupBig() {
    super(new PVector(width + 100, height - 55), new PVector(23, 46),
    new Sprite("img/cactus_group_big.png", 1, 0));
  }
}

public class CactusAloneSmall extends Enemy {
  CactusAloneSmall() {
    super(new PVector(width + 100, height - 50), new PVector(23, 46),
    new Sprite("img/cactus_alone_small.png", 1, 0));
  }
}
public class CactusGroupSmall extends Enemy {
  CactusGroupSmall() {
    super(new PVector(width + 100, height - 50), new PVector(23, 46),
    new Sprite("img/cactus_group_small.png", 1, 0));
  }
}
