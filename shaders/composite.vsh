#version 120
#define VSH

varying vec2 textureCoords;

void main() {
	gl_Position = ftransform();
	textureCoords = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
}