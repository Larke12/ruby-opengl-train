require 'opengl'
require 'glu'
require 'glut'
require "mathn"
include Gl, Glu, Glut

# /*  Initialize material property, light source, and lighting model.
# */
def myinit
    mat_ambient = [ 0.0, 0.0, 0.0, 1.0 ];
#/*   mat_specular and mat_shininess are NOT default values  */
    mat_diffuse = [ 0.4, 0.4, 0.4, 1.0 ];
    mat_specular = [ 1.0, 1.0, 1.0, 1.0 ];
    mat_shininess = [ 15.0 ];

    light_ambient = [ 0.0, 0.0, 0.0, 1.0 ];
    light_diffuse = [ 1.0, 1.0, 1.0, 1.0 ];
    light_specular = [ 1.0, 1.0, 1.0, 1.0 ];
    lmodel_ambient = [ 0.2, 0.2, 0.2, 1.0 ];

    Gl.glMaterial(Gl::GL_FRONT, Gl::GL_AMBIENT, mat_ambient);
    Gl.glMaterial(Gl::GL_FRONT, Gl::GL_DIFFUSE, mat_diffuse);
    Gl.glMaterial(Gl::GL_FRONT, Gl::GL_SPECULAR, mat_specular);
    Gl.glMaterial(Gl::GL_FRONT, Gl::GL_SHININESS, *mat_shininess);
    Gl.glLight(Gl::GL_LIGHT0, Gl::GL_AMBIENT, light_ambient);
    Gl.glLight(Gl::GL_LIGHT0, Gl::GL_DIFFUSE, light_diffuse);
    Gl.glLight(Gl::GL_LIGHT0, Gl::GL_SPECULAR, light_specular);
    Gl.glLightModel(Gl::GL_LIGHT_MODEL_AMBIENT, lmodel_ambient);

    Gl.glEnable(Gl::GL_LIGHTING);
    Gl.glEnable(Gl::GL_LIGHT0);
    Gl.glDepthFunc(Gl::GL_LESS);
    Gl.glEnable(Gl::GL_DEPTH_TEST);
end

def drawPlane
    Gl.glBegin(Gl::GL_QUADS);
    Gl.glNormal(0.0, 0.0, 1.0);
    Gl.glVertex(-1.0, -1.0, 0.0);
    Gl.glVertex(0.0, -1.0, 0.0);
    Gl.glVertex(0.0, 0.0, 0.0);
    Gl.glVertex(-1.0, 0.0, 0.0);

    Gl.glNormal(0.0, 0.0, 1.0);
    Gl.glVertex(0.0, -1.0, 0.0);
    Gl.glVertex(1.0, -1.0, 0.0);
    Gl.glVertex(1.0, 0.0, 0.0);
    Gl.glVertex(0.0, 0.0, 0.0);

    Gl.glNormal(0.0, 0.0, 1.0);
    Gl.glVertex(0.0, 0.0, 0.0);
    Gl.glVertex(1.0, 0.0, 0.0);
    Gl.glVertex(1.0, 1.0, 0.0);
    Gl.glVertex(0.0, 1.0, 0.0);

    Gl.glNormal(0.0, 0.0, 1.0);
    Gl.glVertex(0.0, 0.0, 0.0);
    Gl.glVertex(0.0, 1.0, 0.0);
    Gl.glVertex(-1.0, 1.0, 0.0);
    Gl.glVertex(-1.0, 0.0, 0.0);
    Gl.glEnd();
end

display = Proc.new {
    infinite_light = [ 1.0, 1.0, 1.0, 0.0 ];
    local_light = [ 1.0, 1.0, 1.0, 1.0 ];

    Gl.glClear(Gl::GL_COLOR_BUFFER_BIT | Gl::GL_DEPTH_BUFFER_BIT);

    Gl.glPushMatrix();
    Gl.glTranslate(-1.5, 0.0, 0.0);
    Gl.glLight(Gl::GL_LIGHT0, Gl::GL_POSITION, infinite_light);
    drawPlane();
    Gl.glPopMatrix();

    Gl.glPushMatrix();
    Gl.glTranslate(1.5, 0.0, 0.0);
    Gl.glLight(Gl::GL_LIGHT0, Gl::GL_POSITION, local_light);
    drawPlane();
    Gl.glPopMatrix();
    Gl.glFlush();
}

myReshape = Proc.new {|w, h|
    Gl.glViewport(0, 0, w, h);
    Gl.glMatrixMode(Gl::GL_PROJECTION);
    Gl.glLoadIdentity();
    if (w <= h)
  Gl.glOrtho(-1.5, 1.5, -1.5*h/w, 1.5*h/w, -10.0, 10.0);
    else
  Gl.glOrtho(-1.5*w/h, 1.5*w/h, -1.5, 1.5, -10.0, 10.0);
    end
    Gl.glMatrixMode(Gl::GL_MODELVIEW);
}

# Keyboard handler to exit when ESC is typed
keyboard = lambda do |key, x, y|
  case(key)
  when ?\e
    exit(0)
  end
end

#/*  Main Loop
# *  Open window with initial window size, title bar,
# *  RGBA display mode, and handle input events.
# */
#int main(int argc, char** argv)
#{
    Glut.glutInit
    Glut.glutInitDisplayMode(Glut::GLUT_SINGLE | Glut::GLUT_RGB | Glut::GLUT_DEPTH);
    Glut.glutInitWindowSize(500, 200);
    Glut.glutCreateWindow($0);
    myinit();
    Glut.glutReshapeFunc(myReshape);
    Glut.glutDisplayFunc(display);
    Glut.glutKeyboardFunc(keyboard);
    Glut.glutMainLoop();
