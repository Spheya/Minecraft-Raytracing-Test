#if !defined _INCLUDE_RAYTRACING_GLSL_
#define _INCLUDE_RAYTRACING_GLSL_

#include "settings.glsl"
#include "voxel_structure.glsl"

struct Ray {
    vec3 direction;
    vec3 origin;
};

struct HitPoint {
    bool hit;
    vec3 color;
};

HitPoint traceRay(Ray ray) {
    uvec3 voxelPos = uvec3(floor(ray.origin));
    vec3 deltaDist = abs(vec3(length(ray.direction)) / ray.direction);
    ivec3 rayStep = ivec3(sign(ray.direction));
    vec3 sideDist = (sign(ray.direction) * (vec3(voxelPos) - ray.origin) + (sign(ray.direction) * 0.5) + 0.5) * deltaDist;
    bvec3 mask;

    ivec2 texelCoords;
    vec4 texelLookup;

    int lod = 1;

    while(!voxelOutOfBounds(voxelPos)) {
        texelCoords = voxelToTextureSpace(voxelPos, 0);
        texelLookup = 1.0 - texelFetch(shadowcolor0, texelCoords, 0);

        if(texelLookup.r != 0.0) break;

        mask = lessThanEqual(sideDist.xyz, min(sideDist.yzx, sideDist.zxy));

        sideDist += vec3(mask) * deltaDist;
        voxelPos += ivec3(vec3(mask)) * rayStep;
    }

    HitPoint hit;
    hit.hit = texelLookup.r != 0.0;
    hit.color = texelLookup.rgb;
    return hit;
}

#endif