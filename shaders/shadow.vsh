#version 420 compatibility
#define VSH
#include "lib/settings.glsl"

uniform vec3  cameraPosition;
#include "lib/voxel_structure.glsl"

attribute vec3 mc_Entity;
attribute vec2 mc_midTexCoord;

uniform mat4 shadowModelViewInverse;

out vec3 positionPS;
out vec3 normalWS;
out vec4 color;
out vec2 texcoord;
out vec2 midTexcoord;

out int blockId;

void main() {
    normalWS = normalize(mat3(shadowModelViewInverse) * gl_NormalMatrix * gl_Normal);
    positionPS = (shadowModelViewInverse * gl_ModelViewMatrix * gl_Vertex).xyz;
    color = gl_Color;
    blockId = int(mc_Entity.x);

    texcoord = gl_MultiTexCoord0.st;
    midTexcoord = mc_midTexCoord.st;

    gl_Position = vec4(0.0);
}