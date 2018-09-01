import java.security.*;

public class Sprite {
  
  private PImage[] _imgs;
  private String _path = "";
  public PVector Position = new PVector();
  private float _frameDuration = 0.0f; //in ms
  
  Sprite() {}
  Sprite(String path, int nframe, float durframe) {
    
    if(nframe < 1) {
      throw new InvalidParameterException("Number of frames must be >= 1");
    }
    
    _frameDuration = durframe;
    _imgs = new PImage[nframe];
    _path = path;
    
    if(nframe > 1) {
      for(int i = 0; i < _imgs.length; i++) {
        _imgs[i] = loadImage(_path + i + ".png");
      }   
    } else {
      _imgs[0] = loadImage(path);
    }
  }
  
  public void Show() {
    image(_imgs[int(Deltatime / _frameDuration % (float)_imgs.length)], Position.x, Position.y);
  }
}
