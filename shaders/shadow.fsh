#version 420 compatibility
#define FSH
#include "lib/settings.glsl"

in vec4 shadowMapData;

void main() {
    gl_FragData[0] = shadowMapData;
}