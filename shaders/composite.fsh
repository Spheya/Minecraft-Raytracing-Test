#version 420 compatibility
#define FSH
#include "lib/settings.glsl"

uniform vec3  cameraPosition;
uniform sampler2D shadowtex0;
uniform sampler2D shadowcolor0;
#include "lib/raytracing.glsl"

uniform sampler2D depthtex1;
uniform sampler2D depthtex2;
uniform sampler2D shadowtex1;
#include "lib/texturing.glsl"

uniform float far;
uniform float near;

uniform mat4 gbufferModelViewInverse;
uniform mat4 gbufferProjectionInverse;

uniform sampler2D colortex0;

in vec2 textureCoords;

void main() {
    Ray ray;
    ray.origin = playerToVoxelSpace(vec3(0.0));
    ray.direction = (gbufferProjectionInverse * vec4((textureCoords * 2.0 - 1.0) * (far - near), far + near, far - near)).xyz;
    ray.direction = mat3(gbufferModelViewInverse) * ray.direction;
    ray.direction = normalize(ray.direction);

    HitPoint hit = traceRay(ray);

    if(hit.hit) {
        gl_FragData[0] = getAlbedo(hit);
    } else {
        gl_FragData[0] = texture2D(colortex0, textureCoords);
    }
}