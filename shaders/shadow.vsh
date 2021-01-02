#version 330 compatibility
#define VSH
#include "lib/settings.glsl"

uniform vec3  cameraPosition;
#include "lib/voxel_structure.glsl"

uniform mat4 shadowModelViewInverse;

out vec3 worldPosition;
out vec3 normal;
out vec4 color;

void main() {
    normal = normalize(mat3(shadowModelViewInverse) * gl_NormalMatrix * gl_Normal);
    worldPosition = (shadowModelViewInverse * gl_ModelViewMatrix * gl_Vertex).xyz;
    color = gl_Color;

    gl_Position = vec4(0.0);
}