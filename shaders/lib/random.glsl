vec2 WangHash(uvec2 seed) {
	seed = (seed ^ 61) ^ (seed >> 16);
	seed *= 9;
	seed = seed ^ (seed >> 4);
	seed *= 0x27d4eb2d;
	seed = seed ^ (seed >> 15);
	return vec2(seed) / 4294967296.0;
}


vec2 random(vec2 seed) {
    return WangHash(uvec2(seed * 10007 + randomNum * 5651.0));//texture2D(NOISE_TEX, (seed + randomNum * 0.01) * 5651.0);
}

vec3 randomPointOnSphere(vec2 seed) {
    vec2 rand = random(seed);

    float theta = 2 * PI * rand.x;
    float phi = acos(1 - 2 * rand.y);
    float sinPhi = sin(phi);

    return vec3(sinPhi * cos(theta), sinPhi * sin(theta), cos(phi)) + 0.0001;
}

vec3 randomPointOnSemiSphere(vec2 seed, vec3 normal) {
    vec3 point = randomPointOnSphere(seed);
    point *= sign(dot(point, normal));
    return point;
}