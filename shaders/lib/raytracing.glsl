#if !defined _INCLUDE_RAYTRACING_GLSL_
#define _INCLUDE_RAYTRACING_GLSL_

#include "voxel_structure.glsl"
#include "encoding.glsl"

struct Ray {
    vec3 direction;
    vec3 origin;
};

struct HitPoint {
    bool hit;
    vec3 position;
    vec3 normal;

    vec3 color;
    vec2 uv;
    vec2 atlasCoord;
    int blockId;
};

HitPoint traceRay(Ray ray) {
    uvec3 voxelPos = uvec3(floor(ray.origin));

    ivec3 rayStep = ivec3(sign(ray.direction));
    vec3 isRayDirectionPositive = rayStep * 0.5 + 0.5;

    vec3 toHit = (isRayDirectionPositive - fract(ray.origin)) / ray.direction;
    vec3 deltaToHit = abs(vec3(length(ray.direction)) / ray.direction);
    float hitDistance = 0.0;

    bvec3 traversalAxisMask;
    int traversalAxisIndex;

    ivec2 texelCoords;
    vec4 texelLookup = vec4(1.0);

    int steps = 0;

    while(texelLookup.r == 1.0) {
        // Check which axis to traverse on
        traversalAxisMask = lessThanEqual(toHit.xyz, min(toHit.yzx, toHit.zxy));

        traversalAxisIndex = int(dot(ivec3(traversalAxisMask), ivec3(0, 1, 2)));

        // Traverse ray
        voxelPos += ivec3(vec3(traversalAxisMask)) * rayStep;
        hitDistance = toHit[traversalAxisIndex];
        toHit += vec3(traversalAxisMask) * deltaToHit;

        if(voxelOutOfBounds(voxelPos) || ++steps > 512) break;

        // Check for hit
        texelCoords = voxelToTextureSpace(voxelPos, 0);
        texelLookup = texelFetch(shadowcolor0, texelCoords, 0);
    }

    vec3 endRayPos = ray.origin + ray.direction * hitDistance;

    HitPoint hit;

    if (traversalAxisMask.x) {
        hit.uv = fract(endRayPos.zy);
        hit.uv.y = 1.0 - hit.uv.y;
    }
    if (traversalAxisMask.y) {
        hit.uv = fract(endRayPos.xz);
    }
    if (traversalAxisMask.z) {
        hit.uv = fract(endRayPos.xy);
        hit.uv.y = 1.0 - hit.uv.y;
    }

    hit.hit = texelLookup.r != 1.0;
    hit.position = endRayPos;
    hit.normal = -rayStep * vec3(traversalAxisMask);
    hit.atlasCoord = unpackTexcoord(texelFetch(shadowtex0, texelCoords, 0).r);
    hit.color = texelLookup.yzw;
    hit.blockId = int(texelLookup.x * 512.0);
    return hit;
}

#endif