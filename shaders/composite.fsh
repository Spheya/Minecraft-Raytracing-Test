#version 120
#define FSH

uniform sampler2D colortex0;

uniform sampler2D shadowtex0;
uniform sampler2D shadowcolor0;

varying vec2 textureCoords;

void main() {
    if(textureCoords.x > 0.5 || textureCoords.y > 0.5) {
        gl_FragData[0] = texture2D(colortex0, textureCoords);
    }else {
        gl_FragData[0] = vec4(1.0 - texture2D(shadowcolor0, textureCoords * 2).rgb, 1.0);
    }
}