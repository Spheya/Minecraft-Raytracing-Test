#if !defined _INCLUDE_SETTINGS_GLSL_
#define _INCLUDE_SETTINGS_GLSL_

#define VOXELIZATION_DISTANCE 1 // [0 1 2 3 4 5]
#define LOD_LEVELS 8 // [1 2 3 4 5 6 7 8]

#ifndef LIMIT_Y_AXIS_VOXELIZATION
#define LIMIT_Y_AXIS_VOXELIZATION
#endif

#if (VOXELIZATION_DISTANCE == 0)

    const int shadowMapResolution = 256;
    const float shadowDistance = 3;

#elif (VOXELIZATION_DISTANCE == 1)

    const int shadowMapResolution = 1024;
    const float shadowDistance = 16;

#elif (VOXELIZATION_DISTANCE == 2)

    const int shadowMapResolution = 1024;
    const float shadowDistance = 32;

#elif (VOXELIZATION_DISTANCE == 3)

    const int shadowMapResolution = 2048;
    const float shadowDistance = 64;

#elif (VOXELIZATION_DISTANCE == 4)

    const int shadowMapResolution = 4096;
    const float shadowDistance = 128;

#elif (VOXELIZATION_DISTANCE == 5)

    const int shadowMapResolution = 8192;
    const float shadowDistance = 256;

#endif

#endif