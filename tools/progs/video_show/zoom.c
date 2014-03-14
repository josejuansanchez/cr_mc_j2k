#include <GL/gl.h>
#include <GL/glut.h>
#include <stdlib.h>
#include <stdio.h>
#include <libpgm.h>

#define IMAGEX	512
#define IMAGEY	512

unsigned char *aligned,*aligned2;
pgmImage *img,*img2;
void *pointer;
int width, height;
float zoom=1.0;

void changeImage(int value) {
	if(pointer==aligned)
		pointer=aligned2;
	else
		pointer=aligned;
	
	glutPostRedisplay();
	glutTimerFunc(33,changeImage,0);
}

void changeSize(int w, int h) {
	if(h==0)
		h=1;
	
	glViewport(0,0,w,h);
	
	glMatrixMode(GL_PROJECTION);
	glLoadIdentity();
	
	gluOrtho2D(0.0,(GLfloat) w, 0.0, (GLfloat) h);
	
	glMatrixMode(GL_MODELVIEW);
	glLoadIdentity();
	
	zoom=(float) w/IMAGEX;
	width=w;
	height=(float)(IMAGEX/IMAGEY)*w;
	glutReshapeWindow(width,height);
	glRasterPos2i(0,0);
	glPixelZoom(zoom,zoom);
}

void keysMapper(unsigned char key, int x, int y) {
	if(key=='q')
		exit(EXIT_SUCCESS);
	//if(key=='f')
	//	glutFullScreen();
	if(key=='+') {
		zoom+=0.1;
		glClear(GL_COLOR_BUFFER_BIT);
		width=IMAGEX*zoom;
		height=IMAGEY*zoom;
		glutReshapeWindow(width,height);
		glRasterPos2i(0,0);
		glPixelZoom(zoom,zoom);
	}
	if(key=='-') {
		zoom-=0.1;
		glClear(GL_COLOR_BUFFER_BIT);
		width=IMAGEX*zoom;
		height=IMAGEY*zoom;
		glutReshapeWindow(width,height);
		glRasterPos2i(0,0);
		glPixelZoom(zoom,zoom);
	}
}

void SetupRC() {
	glClearColor(0.0,0.0,0.0,0.0);
	glPixelStorei(GL_UNPACK_ALIGNMENT,1);
}

void RenderScene() {
	glViewport(0,0,width,height);			
	glClear(GL_COLOR_BUFFER_BIT);
	//glWindowPos2iMESA(0,0);
	glRasterPos2i(0,0);
	//glRasterPos2f(-img->xdim/2.0,-img->ydim/2.0);
	//glPixelZoom(1.0,-1.0);	
	//glRasterPos2i(0,0);
	glDrawPixels(IMAGEX,IMAGEY,GL_LUMINANCE,GL_UNSIGNED_BYTE,pointer);

	glutSwapBuffers();
}
int main(int argc, char **argv) {
	int i,j;
	img=readPgm(argv[1]);
	img2=readPgm(argv[2]);
	
	aligned=(unsigned char*)malloc(img->xdim*img->ydim);
	aligned2=(unsigned char*)malloc(img2->xdim*img2->ydim);
	
	for(i=0;i<img->ydim;i++)
		for(j=0;j<img->xdim;j++)
			aligned[(img->ydim-1-i)*img->xdim+j]=img->matrix[i][j];

	for(i=0;i<img2->ydim;i++)
		for(j=0;j<img2->xdim;j++)
			aligned2[(img2->ydim-1-i)*img2->xdim+j]=img2->matrix[i][j];

	pointer=aligned;
	
	width=img->xdim;
	height=img->ydim;
	
	glutInitDisplayMode(GLUT_DOUBLE | GLUT_LUMINANCE);
	glutInitWindowSize(width,height);
	glutCreateWindow("Image");
	glutDisplayFunc(RenderScene);
	glutReshapeFunc(changeSize);
	glutTimerFunc(33,changeImage,0);
	glutKeyboardFunc(keysMapper);
	
	SetupRC();
		
	glutMainLoop();		
			
	return 0;
}
