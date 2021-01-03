#if !defined _INCLUDE_TEXTURING_GLSL_
#define _INCLUDE_TEXTURING_GLSL_

#define TEXTURE_ATLAS depthtex1
#define TEXTURE_ATLAS_N depthtex2
#define TEXTURE_ATLAS_S shadowtex1

vec2 atlasSize = textureSize(TEXTURE_ATLAS, 0).xy;
vec2 atlasUvScale = TEXTURE_RESOLUTION / atlasSize;

vec4 getAlbedo(HitPoint hit) {
    vec2 uv = hit.atlasCoord + hit.uv * atlasUvScale;
    return texture2D(TEXTURE_ATLAS, uv) * vec4(hit.color, 1.0);
}

#endif