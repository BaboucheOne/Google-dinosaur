import java.security.*;

public static final class Sat {  
  
  public static class ColliderResult {
    public boolean Intersect = true;
    public boolean WillIntersect = true;
    public PVector MTV = new PVector();
    public PVector Normal = new PVector();
  }
  
  private static class DistanceValues {
    float minA;
    float minB;
    float maxA;
    float maxB;
  }
  
  static ColliderResult Collide(Polygon a, Polygon b, PVector vel) {
    
    ColliderResult result = new ColliderResult();
    
    ArrayList<PVector> edgesA = a.GetEdges();
    ArrayList<PVector> edgesB = b.GetEdges();
    
    int edgeCountA = edgesA.size();
    int edgeCountB = edgesB.size();
    
    float minIntervalDst = 100000;
    PVector translateVector = new PVector();
    PVector edge = new PVector();
    
    for(int i = 0; i < edgeCountA + edgeCountB; i++) {
      if(i < edgeCountA) {
        edge = edgesA.get(i);
      } else {
        edge = edgesB.get(i - edgeCountA);
      }
      
      PVector axis = new PVector(-edge.y, edge.x);
      axis.normalize();
      
      DistanceValues dstValues = new DistanceValues();
      ProjectA(axis, a, dstValues);
      ProjectB(axis, b, dstValues);
      
      if(IntervalDistance(dstValues) > 0) {
        result.Intersect = false;
      }
      
      float velProj = axis.dot(vel);
      if(velProj < 0) {
        dstValues.minA += velProj;
      } else {
        dstValues.maxA += velProj;
      }
      
      float dst = IntervalDistance(dstValues);
      if(dst > 0) {
        result.WillIntersect = false;
      }
      
      if(!result.Intersect && !result.WillIntersect) {
        break;
      }
      
      dst = abs(dst);
      if(dst < minIntervalDst) {
        minIntervalDst = dst;
        translateVector = axis;
        
        PVector d = PVector.sub(a.GetCenter(), b.GetCenter());
        if(d.dot(translateVector) < 0) {
          translateVector.set(translateVector.mult(-1));
        }
      }
    }
    
    if(result.WillIntersect) {
      result.MTV.set(translateVector.mult(minIntervalDst));
      result.Normal.set(-result.MTV.y, result.MTV.x);
    }
    
    return result;
  }
  
  private static float IntervalDistance(DistanceValues val) {
    if(val.minA < val.minB) {
      return val.minB - val.maxA;
    }
    
    return val.minA - val.maxB;
  }
  
  private static void ProjectA(PVector axis, Polygon trans, DistanceValues val) {
    PVector[] points = trans.GetPoints();
    float dotP = axis.dot(points[0]);
    val.minA = dotP;
    val.maxA = dotP;
    
    for(int i = 0; i < points.length; i++) {
      dotP = points[i].dot(axis);
      
      if(dotP < val.minA) {
        val.minA = dotP;
      } else if(dotP > val.maxA) {
        val.maxA = dotP;
      }
    }
  }
  
  private static void ProjectB(PVector axis, Polygon trans, DistanceValues val) {
    PVector[] points = trans.GetPoints();
    float dotP = axis.dot(points[0]);
    val.minB = dotP;
    val.maxB = dotP;
    
    for(int i = 0; i < points.length; i++) {
      dotP = points[i].dot(axis);
      
      if(dotP < val.minB) {
        val.minB = dotP;
      } else if(dotP > val.maxB) {
        val.maxB = dotP;
      }
    }
  }
}

public class BoxCollider extends Polygon {
  
  public PVector Position = new PVector();
  public PVector Scale = new PVector();
  
  BoxCollider(PVector pos, PVector scale) {
    super(4);
    Position.set(pos);
    Scale.set(scale);
    
    Update();
  }
  
  public void Update() {
    _points[0].set(Position.x, Position.y);
    _points[1].set(Position.x + Scale.x, Position.y);
    _points[2].set(Position.x + Scale.x, Position.y + Scale.y);
    _points[3].set(Position.x, Position.y + Scale.y);
    
    SetEdges();
  }
}

public class Polygon {
  
  private PVector _center = new PVector();
  protected PVector[] _points;
  private ArrayList<PVector> _edges = new ArrayList<PVector>();
  
  Polygon(int ptsToInit) {
    if(ptsToInit < 2) {
      throw new InvalidParameterException("Polygon's constructor needs minimum 2 points !");
    }
    
    _points = new PVector[ptsToInit];
    for(int i = 0; i < ptsToInit; i++) {
      _points[i] = new PVector();
    }
    
    SetEdges();
  }
  
  Polygon(PVector[] _pts) {
    if(_pts.length < 2) {
      throw new InvalidParameterException("Polygon's constructor needs minimum 2 points !");
    }
    
    _points = _pts;
    SetEdges();
  }
  
  protected void SetEdges() {
    _edges.clear();
    
    for(int i = 0; i < _points.length; i++) {
      PVector v2 = new PVector();
      
      if(i + 1 >= _points.length) {
        v2 = _points[0];
      } else {
        v2 = _points[i+1];
      }
      
      _edges.add(PVector.sub(v2, _points[i]));
    }
    
    SetCenter();
  }
  
  private void SetCenter() {
    _center.set(0,0,0);
    for(int i  = 0; i < _points.length; i++) {
      _center.add(_points[i]);
    }
    
    _center.div(_points.length);
  }
  
  protected void SetPoints(PVector[] pts) {
    _points = pts;
    SetEdges();
  }
  
  public void Translate(PVector trans) {
    for(int i = 0; i < _points.length; i++) {
      _points[i].add(trans);
    }
    
    SetEdges();
  }
  
  PVector[] GetPoints() {
    return _points;
  }
  
  ArrayList<PVector> GetEdges() {
    return _edges;
  }
  
  PVector GetCenter() {
    return _center;
  }
  
  void Show() {
    PVector lastPoint = new PVector();
    PVector nextPt = new PVector();
    
    lastPoint.set(_points[0]);
    nextPt.set(_points[1]);
    
    stroke(0);
    for(int i = 0; i < _points.length; i++) {
      if(i + 1 >= _points.length) {
        nextPt.set(_points[0]);
      } else {
        nextPt.set(_points[i + 1]);
      }
      
      line(lastPoint.x, lastPoint.y, nextPt.x, nextPt.y);
      lastPoint.set(nextPt);
    }
    
    fill(0,255,0);
    ellipse(_center.x, _center.y, 10, 10);
  }
  
}
