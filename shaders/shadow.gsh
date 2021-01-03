#version 420 compatibility
#define GSH
#include "lib/settings.glsl"

#include "lib/encoding.glsl"

uniform vec3  cameraPosition;
#include "lib/voxel_structure.glsl"

layout(triangles) in;
layout(points, max_vertices = LOD_LEVELS) out;

in vec3 positionPS[];
in vec3 normalWS[];
in vec4 color[];
in int blockId[];
in vec2 texcoord[];
in vec2 midTexcoord[];

out vec4 shadowMapData;

void main() {
    if(blockId[0] == 0) return;

    vec3 triangleCenter = (positionPS[0] + positionPS[1] + positionPS[2]) / 3.0;
    vec3 inVoxelCoord = triangleCenter - normalWS[0] * 0.01;

    vec3 voxelPosition = playerToVoxelSpace(inVoxelCoord);

    if(voxelOutOfBounds(voxelPosition)) return;

    vec2 atlasCoord = midTexcoord[0] - abs(midTexcoord[0] - texcoord[0]);
    float packedTextureCoord = packTexcoord(atlasCoord);

    shadowMapData = vec4(color[0].xyz, 1.0);

    for(int lod = 0; lod < LOD_LEVELS; lod++) {
        vec2 texturePosition = voxelToTextureSpace(uvec3(voxelPosition), lod);
        gl_Position = vec4(((texturePosition + 0.5) / shadowMapResolution) * 2.0 - 1.0, packedTextureCoord, 1.0);
        EmitVertex();
    }
}