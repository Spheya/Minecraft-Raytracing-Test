#ifndef _INCLUDE_VOXEL_STRUCTURE_GLSL_
#define _INCLUDE_VOXEL_STRUCTURE_GLSL_

#include "settings.glsl"

const int voxelRadius = int(shadowDistance);
ivec3 voxelDimensions = ivec3(2 * voxelRadius, 256, 2 * voxelRadius);
ivec3 center = voxelDimensions / 2;

bool voxelOutOfBounds(vec3 voxelSpaceCoord) {
    return any(greaterThanEqual(abs(voxelSpaceCoord - center), center-vec3(0.001)));
}

vec3 playerToVoxelSpace(vec3 playerSpaceCoord) {
    return playerSpaceCoord + vec3(voxelRadius, cameraPosition.y, voxelRadius);
}

ivec2 voxelToTextureSpace(uvec3 voxelSpaceCoord) {
    uint index = voxelSpaceCoord.x + 
                 voxelSpaceCoord.z * uint(2 * voxelRadius) +
                 voxelSpaceCoord.y * uint(4 * voxelRadius * voxelRadius);

    return ivec2(index % uint(shadowMapResolution), index / uint(shadowMapResolution));
}

#endif