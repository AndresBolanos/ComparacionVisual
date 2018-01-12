class Magnifier{
  int defWidth = 300;   // default width of the zoom window
  int defHeight = 300;  // default height "
  float defZoom = 3.0;  // default zoom factor
  int mWidth, mHeight;
  int widthUnzoomed, heightUnzoomed;  // the size of the area which should be magnified
  float zoom;
  color crossColor;
  
  /**  Creates a magnifier. The pixels around the mouse position will be copied and rescaled
  *  to have a better look at them. <p />
  *  The Rescaled image will then be placed at the upper left corner.
  *  Size of the magnifier window: 300px x 300px
  */
  Magnifier(){
    mWidth = defWidth;
    mHeight = defHeight;
    zoom =  defZoom;
    widthUnzoomed = (int)(mWidth/zoom);
    heightUnzoomed = (int)(mHeight/zoom);
    crossColor = color(#65F022);
  }

  /**
  *  Creates a magnifier. The pixels around the mouse position will be copied and rescaled
  *  to have a better look at them. <p />
  *  The Rescaled image will then be placed at the upper left corner.
  *
  *  @param  mWidth  The Width of the magnifier window. (Square window)
  *  @param  zoom    The zoom factor - how much should be zoomed in (default: 3.0)
  */
  Magnifier(int mWidth, float zoom){  //width = height -> square magnifier window
    this.mWidth = mWidth;
    this.mHeight = mWidth;
    this.zoom = zoom;   
    crossColor = color(#65F022);
  }
  
  /**
  *  Displays the zoomed area.
  *  Call this in the end of the draw-function.
  */ 
  void display(){
   if(mouseX>0 || mouseY>0){
      copy((int)(mouseX-widthUnzoomed*0.5), (int)(mouseY-heightUnzoomed*0.5), 
         widthUnzoomed, heightUnzoomed, 0, 0, mWidth, mHeight);
      stroke(crossColor);
      noFill();
      line(mWidth*0.5-3, mHeight*0.5, mWidth*0.5+3, mHeight*0.5);
      line(mWidth*0.5, mHeight*0.5-3, mWidth*0.5, mHeight*0.5+3);  
    }
  }
}