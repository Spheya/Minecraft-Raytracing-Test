#version 330 compatibility
#define GSH
#include "lib/settings.glsl"

uniform vec3  cameraPosition;
#include "lib/voxel_structure.glsl"

layout(triangles) in;
layout(points, max_vertices = 1) out;

in vec3 positionPS[];
in vec3 normalWS[];
in vec4 color[];

out vec4 shadowMapData;

void main() {
    vec3 triangleCenter = (positionPS[0] + positionPS[1] + positionPS[2]) / 3.0;
    vec3 inVoxelCoord = triangleCenter - normalWS[0] * 0.1;

    vec3 voxelPosition = playerToVoxelSpace(inVoxelCoord);

    if(voxelOutOfBounds(voxelPosition)) return;

    vec2 texturePosition = voxelToTextureSpace(uvec3(voxelPosition));

    shadowMapData = vec4(max(voxelPosition / 8.0, 0.5), 1.0);

    gl_Position = vec4(((texturePosition + 0.5) / shadowMapResolution) * 2.0 - 1.0, 0.0, 1.0);
    //gl_Position = vec4(0.0, 0.0, 0.0, 1.0);
    EmitVertex();
}