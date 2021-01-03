#version 420 compatibility
#define VSH
#include "lib/settings.glsl"

out vec2 textureCoords;

void main() {
	gl_Position = ftransform();
	textureCoords = (gl_TextureMatrix[0] * gl_MultiTexCoord0).xy;
}