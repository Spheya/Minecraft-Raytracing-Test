#version 420 compatibility
#define FSH
#include "lib/settings.glsl"

/* DRAWBUFFERS:06 */

uniform vec3  cameraPosition;
uniform sampler2D shadowtex0;
uniform sampler2D shadowcolor0;
#include "lib/raytracing.glsl"

uniform sampler2D depthtex1;
uniform sampler2D depthtex2;
uniform sampler2D shadowtex1;
#include "lib/texturing.glsl"


uniform vec3 sunDirection;
uniform float randomNum;
uniform sampler2D colortex7;
#define NOISE_TEX colortex7
#include "lib/random.glsl"
#include "lib/pbr.glsl"
#include "lib/sampling.glsl"

uniform float far;
uniform float near;

uniform mat4 gbufferModelViewInverse;
uniform mat4 gbufferProjectionInverse;

uniform sampler2D colortex0;

uniform sampler2D colortex6;

in vec2 textureCoords;

#ifndef RENDER_IMAGE
#define RENDER_IMAGE
#endif

void main() {
    Ray ray;
    ray.origin = playerToVoxelSpace(vec3(0.0));
    ray.direction = (gbufferProjectionInverse * vec4((textureCoords * 2.0 - 1.0) * (far - near), far + near, far - near)).xyz;
    ray.direction = mat3(gbufferModelViewInverse) * ray.direction;
    ray.direction = normalize(ray.direction);

    HitPoint hit = traceRay(ray);

    if(hit.hit) {
        Surface surface = rayHitToSurface(ray, hit);
        vec3 color = calculateSurfaceColor(surface, getSamples(surface));

        vec2 seed = surface.position.xz + surface.position.y;

        vec4 prevColor = texture2D(colortex6, textureCoords);
        #ifndef RENDER_IMAGE
        prevColor = mix(prevColor, vec4(color, 1.0), 0.9);
        #else
        prevColor = mix(prevColor, vec4(color, 1.0), 0.02);
        #endif

        gl_FragData[0] = prevColor;
        gl_FragData[1] = prevColor;
    } else {
        gl_FragData[0] = texture2D(colortex0, textureCoords);
        gl_FragData[1] = texture2D(colortex0, textureCoords);
    }
}