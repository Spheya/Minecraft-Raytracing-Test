struct Surface {
    vec4 albedo;
    vec3 position;
    vec3 normal;
    vec3 viewDir;
    float emissiveness;
    float reflectiveness;
};

struct Light {
    vec3 color;
    vec3 direction;
};

struct SampleSet {
    vec3 reflection;
    vec3 refraction;
    vec3 indirectLight;
};

vec3 sampleSky(vec3 direction) {
    float d = pow(max(dot(direction, sunDirection), 0.0), 300.0) * 60;

    return vec3(0.8, 0.85, 0.95) + d;
}

float fresnel(float r0, vec3 normal, vec3 viewDir) {
    float a = 1.0 - dot(normal, viewDir);
    return r0 * (r0 + (1.0 - r0) * a * a * a * a * a);
}

Surface rayHitToSurface(Ray ray, HitPoint hit) {
    Surface surface;
    surface.albedo = getAlbedo(hit);
    surface.position = hit.position;
    surface.normal = hit.normal;
    surface.viewDir = ray.direction;
    surface.emissiveness = float(hit.blockId == 2);
    surface.reflectiveness = float(hit.blockId == 4) * 0.5;
    return surface;
}

vec3 calculateSurfaceColor(Surface surface, SampleSet samples) {

    float f = fresnel(surface.reflectiveness, surface.normal, -surface.viewDir);

    return mix(surface.albedo.rgb * mix(samples.indirectLight, vec3(16.0), surface.emissiveness), samples.reflection, f);
}