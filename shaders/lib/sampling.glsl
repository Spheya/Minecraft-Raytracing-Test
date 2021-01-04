SampleSet getEmptySampleSet(Surface surface) {
    SampleSet samples;
    samples.reflection = sampleSky(reflect(surface.viewDir, surface.normal));
    samples.refraction = vec3(0.0);
    samples.indirectLight = vec3(0.0);
    return samples;
}

SampleSet getReflectionSampleSet(vec3 reflectionColor) {
    SampleSet samples;
    samples.reflection = reflectionColor;
    samples.refraction = vec3(0.0);
    samples.indirectLight = vec3(1.0);
    return samples;
}

#define REFLECTION_RECURSION 1 //[1 2 3 4 5 6 7 8 9 10]

vec3 sampleReflection(Surface surface) {
    int sampleCount = REFLECTION_RECURSION;
    Surface hitpoints[REFLECTION_RECURSION];

    Ray ray;
    ray.origin = surface.position + surface.normal * 0.001;
    ray.direction = reflect(surface.viewDir, surface.normal); 

    // Get all the hitpoints
    for(int i = 0; i < REFLECTION_RECURSION; ++i) {
        HitPoint hit = traceRay(ray);

        if(!hit.hit){
            sampleCount = i;
            break;
        }

        hitpoints[i] = rayHitToSurface(ray, hit);
        
        ray.origin = hitpoints[i].position + hitpoints[i].normal * 0.001;
        ray.direction = reflect(hitpoints[i].viewDir, hitpoints[i].normal);
    }

    // Go backwards through the hitpoints to calculate the color
    vec3 reflectionSample = sampleSky(ray.direction);
    for(int i = sampleCount - 1; i >= 0; --i) {
        reflectionSample = calculateSurfaceColor(hitpoints[i], getReflectionSampleSet(reflectionSample));
    }

    return reflectionSample;
}

#define INDIRECT_LIGHT_SAMPLES 5 //[5 10 15 20 25 30 100 200]

vec3 sampleIndirectLight(Surface surface) {
    vec2 seed = surface.position.xy + surface.position.z;

    vec3 giSample = vec3(0.0);

    Ray ray;
    ray.origin = surface.position + surface.normal * 0.001;

    for(int i = 0; i < INDIRECT_LIGHT_SAMPLES; ++i) {
        ray.direction = normalize(randomPointOnSphere(seed) + surface.normal + 0.001);

        HitPoint hit = traceRay(ray);
        if(!hit.hit){ 
            giSample += sampleSky(ray.direction) * 1.7;
        }else{
            float emissive = float(hit.blockId == 2);
            giSample += getAlbedo(hit).rgb * mix(1.0, 16.0, emissive);
        }

        seed.x += 0.001;
    }

    return giSample / INDIRECT_LIGHT_SAMPLES;
}

SampleSet getSamples(Surface surface) {
    SampleSet samples;
    samples.reflection = sampleReflection(surface);
    samples.refraction = vec3(0.0);
    samples.indirectLight = sampleIndirectLight(surface);
    return samples;
}