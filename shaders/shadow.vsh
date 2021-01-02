#version 330 compatibility
#define VSH
#include "lib/settings.glsl"

uniform vec3  cameraPosition;
#include "lib/voxel_structure.glsl"

uniform mat4 shadowModelViewInverse;

out vec3 positionPS;
out vec3 normalWS;
out vec4 color;

void main() {
    normalWS = normalize(mat3(shadowModelViewInverse) * gl_NormalMatrix * gl_Normal);
    positionPS = (shadowModelViewInverse * gl_ModelViewMatrix * gl_Vertex).xyz;
    color = gl_Color;

    gl_Position = vec4(0.0);
}