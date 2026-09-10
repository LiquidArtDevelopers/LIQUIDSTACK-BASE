const SECTION_PARTICLES02_DEFAULTS = Object.freeze({
  blackHoleMass: 0.4,
  gravitationalLensing: 2.4,
  dopplerStrength: 1.0,
  diskInnerRadius: 4.1,
  diskOuterRadius: 14.5,
  diskBrightness: 5.0,
  diskTemperature: 50.0,
  temperatureFalloff: 5.22,
  diskEdgeSoftnessInner: 0.18,
  diskEdgeSoftnessOuter: 0.5,
  turbulenceScale: 1.81,
  turbulenceStretch: 0.75,
  turbulenceSharpness: 7.4,
  diskRotationSpeed: -8.7,
  turbulenceCycleTime: 5.0,
  turbulenceLacunarity: 3.0,
  turbulencePersistence: 0.8,
  starsEnabled: true,
  starBackgroundColor: '#000000',
  starDensity: 0.1,
  starSize: 1.2,
  starBrightness: 0.1,
  starDrift: 0.04,
  nebulaEnabled: true,
  nebula1Scale: 2.0,
  nebula1Density: 0.5,
  nebula1Brightness: 0.08,
  nebula1Color: '#113844',
  nebula2Scale: 5.5,
  nebula2Density: 0.05,
  nebula2Brightness: 0.21,
  nebula2Color: '#1b214a',
  bloomStrength: 0.68,
  bloomRadius: 0.2,
  bloomThreshold: 0.4,
  stepSize: 1.0,
  lensChroma: 0.16,
  holeX: 0.68,
  holeY: 0.52,
  mouseInfluence: 0.06,
  maxPixelRatio: 2,
  zoomBase: 20.62,
  yawBase: Math.PI * 0.5,
  pitchBase: -0.245,
});

const activeInstances = [];

export default function initSectionParticles02() {
  const roots = Array.from(document.querySelectorAll('[data-section-particles02]'));
  if (roots.length === 0) {
    return;
  }

  roots.forEach((root) => {
    if (root.dataset.sectionParticles02Init === 'true') {
      return;
    }
    root.dataset.sectionParticles02Init = 'true';

    const canvas = root.querySelector('[data-section-particles02-canvas]');
    if (!canvas) {
      return;
    }

    const instance = createSectionParticles02Instance(root, canvas);
    if (instance) {
      activeInstances.push(instance);
    }
  });
}

if (import.meta.hot) {
  import.meta.hot.dispose(() => {
    activeInstances.forEach((instance) => instance.destroy());
    activeInstances.length = 0;
  });
}

function createSectionParticles02Instance(root, canvas) {
  const gl = canvas.getContext('webgl', {
    alpha: false,
    antialias: false,
    depth: false,
    stencil: false,
    preserveDrawingBuffer: false,
    powerPreference: 'high-performance',
  });

  if (!gl) {
    root.classList.add('sectionParticles02--fallback');
    return null;
  }

  const settings = buildSettings(root);
  const program = createProgram(gl, VERTEX_SHADER, FRAGMENT_SHADER);
  if (!program) {
    root.classList.add('sectionParticles02--fallback');
    return null;
  }

  gl.useProgram(program);

  const locations = {
    aPos: gl.getAttribLocation(program, 'a_pos'),
    uTime: gl.getUniformLocation(program, 'u_time'),
    uRes: gl.getUniformLocation(program, 'u_res'),
    uBhCenter: gl.getUniformLocation(program, 'u_bhCenter'),
    uLensing: gl.getUniformLocation(program, 'u_lensing'),
    uChromatic: gl.getUniformLocation(program, 'u_chromatic'),
    uStarsEnabled: gl.getUniformLocation(program, 'u_starsEnabled'),
    uStarBgColor: gl.getUniformLocation(program, 'u_starBgColor'),
    uStarDensity: gl.getUniformLocation(program, 'u_starDensity'),
    uStarSize: gl.getUniformLocation(program, 'u_starSize'),
    uStarBrightness: gl.getUniformLocation(program, 'u_starBrightness'),
    uStarDrift: gl.getUniformLocation(program, 'u_starDrift'),
    uDiskBrightness: gl.getUniformLocation(program, 'u_diskBrightness'),
    uDiskTemperature: gl.getUniformLocation(program, 'u_diskTemperature'),
    uTempFalloff: gl.getUniformLocation(program, 'u_tempFalloff'),
    uDopplerStrength: gl.getUniformLocation(program, 'u_dopplerStrength'),
    uTurbulenceScale: gl.getUniformLocation(program, 'u_turbulenceScale'),
    uTurbulenceStretch: gl.getUniformLocation(program, 'u_turbulenceStretch'),
    uTurbulenceSharpness: gl.getUniformLocation(program, 'u_turbulenceSharpness'),
    uTurbulenceCycleTime: gl.getUniformLocation(program, 'u_turbulenceCycleTime'),
    uDiskRotationSpeed: gl.getUniformLocation(program, 'u_diskRotationSpeed'),
    uDiskEdgeInner: gl.getUniformLocation(program, 'u_diskEdgeInner'),
    uDiskEdgeOuter: gl.getUniformLocation(program, 'u_diskEdgeOuter'),
    uCamRadius: gl.getUniformLocation(program, 'u_camRadius'),
    uCamYaw: gl.getUniformLocation(program, 'u_camYaw'),
    uCamPitch: gl.getUniformLocation(program, 'u_camPitch'),
    uStepSize: gl.getUniformLocation(program, 'u_stepSize'),
    uDiskInner: gl.getUniformLocation(program, 'u_diskInner'),
    uDiskOuter: gl.getUniformLocation(program, 'u_diskOuter'),
    uMass: gl.getUniformLocation(program, 'u_mass'),
    uTurbLacunarity: gl.getUniformLocation(program, 'u_turbLacunarity'),
    uTurbPersistence: gl.getUniformLocation(program, 'u_turbPersistence'),
    uNebulaEnabled: gl.getUniformLocation(program, 'u_nebulaEnabled'),
    uNebula1Scale: gl.getUniformLocation(program, 'u_nebula1Scale'),
    uNebula1Density: gl.getUniformLocation(program, 'u_nebula1Density'),
    uNebula1Brightness: gl.getUniformLocation(program, 'u_nebula1Brightness'),
    uNebula1Color: gl.getUniformLocation(program, 'u_nebula1Color'),
    uNebula2Scale: gl.getUniformLocation(program, 'u_nebula2Scale'),
    uNebula2Density: gl.getUniformLocation(program, 'u_nebula2Density'),
    uNebula2Brightness: gl.getUniformLocation(program, 'u_nebula2Brightness'),
    uNebula2Color: gl.getUniformLocation(program, 'u_nebula2Color'),
    uBloomStrength: gl.getUniformLocation(program, 'u_bloomStrength'),
    uBloomRadius: gl.getUniformLocation(program, 'u_bloomRadius'),
    uBloomThreshold: gl.getUniformLocation(program, 'u_bloomThreshold'),
  };

  const vertexBuffer = gl.createBuffer();
  gl.bindBuffer(gl.ARRAY_BUFFER, vertexBuffer);
  gl.bufferData(gl.ARRAY_BUFFER, new Float32Array([-1, -1, 3, -1, -1, 3]), gl.STATIC_DRAW);
  gl.enableVertexAttribArray(locations.aPos);
  gl.vertexAttribPointer(locations.aPos, 2, gl.FLOAT, false, 0, 0);

  gl.disable(gl.DEPTH_TEST);
  gl.disable(gl.CULL_FACE);

  const state = {
    width: 1,
    height: 1,
    visible: true,
    dragging: false,
    pointerId: -1,
    lastX: 0,
    lastY: 0,
    yaw: settings.yawBase,
    pitch: settings.pitchBase,
    targetYaw: settings.yawBase,
    targetPitch: settings.pitchBase,
    zoom: settings.zoomBase,
    targetZoom: settings.zoomBase,
  };

  const reducedMotion = window.matchMedia('(prefers-reduced-motion: reduce)').matches;
  const cleanupController = new AbortController();
  const { signal } = cleanupController;

  canvas.addEventListener(
    'pointerdown',
    (event) => {
      state.dragging = true;
      state.pointerId = event.pointerId;
      state.lastX = event.clientX;
      state.lastY = event.clientY;
      canvas.setPointerCapture(event.pointerId);
    },
    { signal, passive: true }
  );

  canvas.addEventListener(
    'pointermove',
    (event) => {
      if (!state.dragging || event.pointerId !== state.pointerId) {
        return;
      }

      const dx = event.clientX - state.lastX;
      const dy = event.clientY - state.lastY;
      state.lastX = event.clientX;
      state.lastY = event.clientY;

      const sensitivity = 0.002 + settings.mouseInfluence * 0.012;
      state.targetYaw -= dx * sensitivity;
      state.targetPitch -= dy * sensitivity * 0.9;
      state.targetPitch = clamp(state.targetPitch, -1.16, 1.16);
    },
    { signal, passive: true }
  );

  const releasePointer = (event) => {
    if (event.pointerId !== state.pointerId) {
      return;
    }
    state.dragging = false;
    if (canvas.hasPointerCapture(event.pointerId)) {
      canvas.releasePointerCapture(event.pointerId);
    }
    state.pointerId = -1;
  };

  canvas.addEventListener('pointerup', releasePointer, { signal, passive: true });
  canvas.addEventListener('pointercancel', releasePointer, { signal, passive: true });

  canvas.addEventListener(
    'pointerleave',
    () => {
      state.dragging = false;
      state.pointerId = -1;
    },
    { signal, passive: true }
  );

  canvas.addEventListener(
    'wheel',
    (event) => {
      event.preventDefault();
      const delta = event.deltaY * 0.015;
      state.targetZoom = clamp(state.targetZoom + delta, settings.zoomMin, settings.zoomMax);
    },
    { signal, passive: false }
  );

  const resizeObserver = new ResizeObserver(() => {
    resize();
  });
  resizeObserver.observe(root);

  const viewportObserver = new IntersectionObserver(
    (entries) => {
      state.visible = entries.some((entry) => entry.isIntersecting);
      if (state.visible && rafId === 0 && !destroyed) {
        lastTime = performance.now();
        rafId = requestAnimationFrame(render);
      }
    },
    { threshold: 0 }
  );
  viewportObserver.observe(root);

  const visibilityHandler = () => {
    if (document.hidden) {
      state.visible = false;
      return;
    }
    state.visible = true;
    if (rafId === 0 && !destroyed) {
      lastTime = performance.now();
      rafId = requestAnimationFrame(render);
    }
  };
  document.addEventListener('visibilitychange', visibilityHandler, { signal });

  resize();

  let destroyed = false;
  let rafId = requestAnimationFrame(render);
  let lastTime = performance.now();

  return {
    destroy() {
      destroyed = true;
      if (rafId !== 0) {
        cancelAnimationFrame(rafId);
      }
      rafId = 0;

      cleanupController.abort();
      resizeObserver.disconnect();
      viewportObserver.disconnect();
      document.removeEventListener('visibilitychange', visibilityHandler);

      gl.bindBuffer(gl.ARRAY_BUFFER, null);
      gl.useProgram(null);
      if (vertexBuffer) {
        gl.deleteBuffer(vertexBuffer);
      }
      if (program) {
        gl.deleteProgram(program);
      }
    },
  };

  function resize() {
    const rect = root.getBoundingClientRect();
    const width = Math.max(1, Math.round(rect.width));
    const height = Math.max(1, Math.round(rect.height));
    state.width = width;
    state.height = height;

    const dpr = Math.min(window.devicePixelRatio || 1, SECTION_PARTICLES02_DEFAULTS.maxPixelRatio);
    const pixelW = Math.max(1, Math.round(width * dpr));
    const pixelH = Math.max(1, Math.round(height * dpr));
    if (canvas.width !== pixelW || canvas.height !== pixelH) {
      canvas.width = pixelW;
      canvas.height = pixelH;
    }
    canvas.style.width = `${width}px`;
    canvas.style.height = `${height}px`;
    gl.viewport(0, 0, pixelW, pixelH);
    gl.uniform2f(locations.uRes, pixelW, pixelH);
  }

  function render(now) {
    if (destroyed) {
      return;
    }

    if (!state.visible) {
      rafId = 0;
      return;
    }

    const deltaMs = Math.min(50, Math.max(0, now - lastTime));
    lastTime = now;
    const smoothing = 1.0 - Math.exp(-deltaMs * 0.016);

    state.yaw += (state.targetYaw - state.yaw) * smoothing;
    state.pitch += (state.targetPitch - state.pitch) * smoothing;
    state.zoom += (state.targetZoom - state.zoom) * smoothing;

    const time = reducedMotion ? 0 : now * 0.001;
    gl.uniform1f(locations.uTime, time);
    gl.uniform2f(locations.uBhCenter, settings.holeX, settings.holeY);
    gl.uniform1f(locations.uLensing, settings.lensingStrength);
    gl.uniform1f(locations.uChromatic, settings.chromaticStrength);
    gl.uniform1f(locations.uStarsEnabled, settings.starsEnabled ? 1 : 0);
    gl.uniform3f(
      locations.uStarBgColor,
      settings.starBackgroundColor[0],
      settings.starBackgroundColor[1],
      settings.starBackgroundColor[2]
    );
    gl.uniform1f(locations.uStarDensity, settings.starDensity);
    gl.uniform1f(locations.uStarSize, settings.starSize);
    gl.uniform1f(locations.uStarBrightness, settings.starBrightness);
    gl.uniform1f(locations.uStarDrift, settings.starDrift);
    gl.uniform1f(locations.uDiskBrightness, settings.diskBrightness);
    gl.uniform1f(locations.uDiskTemperature, settings.diskTemperature);
    gl.uniform1f(locations.uTempFalloff, settings.temperatureFalloff);
    gl.uniform1f(locations.uDopplerStrength, settings.dopplerStrength);
    gl.uniform1f(locations.uTurbulenceScale, settings.turbulenceScale);
    gl.uniform1f(locations.uTurbulenceStretch, settings.turbulenceStretch);
    gl.uniform1f(locations.uTurbulenceSharpness, settings.turbulenceSharpness);
    gl.uniform1f(locations.uTurbulenceCycleTime, settings.turbulenceCycleTime);
    gl.uniform1f(locations.uDiskRotationSpeed, settings.diskRotationSpeed);
    gl.uniform1f(locations.uDiskEdgeInner, settings.diskEdgeSoftnessInner);
    gl.uniform1f(locations.uDiskEdgeOuter, settings.diskEdgeSoftnessOuter);
    gl.uniform1f(locations.uCamRadius, state.zoom);
    gl.uniform1f(locations.uCamYaw, state.yaw);
    gl.uniform1f(locations.uCamPitch, state.pitch);
    gl.uniform1f(locations.uStepSize, settings.stepSize);
    gl.uniform1f(locations.uDiskInner, settings.diskInner);
    gl.uniform1f(locations.uDiskOuter, settings.diskOuter);
    gl.uniform1f(locations.uMass, settings.mass);
    gl.uniform1f(locations.uTurbLacunarity, settings.turbLacunarity);
    gl.uniform1f(locations.uTurbPersistence, settings.turbPersistence);
    gl.uniform1f(locations.uNebulaEnabled, settings.nebulaEnabled ? 1 : 0);
    gl.uniform1f(locations.uNebula1Scale, settings.nebula1Scale);
    gl.uniform1f(locations.uNebula1Density, settings.nebula1Density);
    gl.uniform1f(locations.uNebula1Brightness, settings.nebula1Brightness);
    gl.uniform3f(
      locations.uNebula1Color,
      settings.nebula1Color[0],
      settings.nebula1Color[1],
      settings.nebula1Color[2]
    );
    gl.uniform1f(locations.uNebula2Scale, settings.nebula2Scale);
    gl.uniform1f(locations.uNebula2Density, settings.nebula2Density);
    gl.uniform1f(locations.uNebula2Brightness, settings.nebula2Brightness);
    gl.uniform3f(
      locations.uNebula2Color,
      settings.nebula2Color[0],
      settings.nebula2Color[1],
      settings.nebula2Color[2]
    );
    gl.uniform1f(locations.uBloomStrength, settings.bloomStrength);
    gl.uniform1f(locations.uBloomRadius, settings.bloomRadius);
    gl.uniform1f(locations.uBloomThreshold, settings.bloomThreshold);

    gl.drawArrays(gl.TRIANGLES, 0, 3);
    rafId = requestAnimationFrame(render);
  }
}

const VERTEX_SHADER = `
attribute vec2 a_pos;
void main() {
  gl_Position = vec4(a_pos, 0.0, 1.0);
}
`;

const FRAGMENT_SHADER = `
precision highp float;

uniform float u_time;
uniform vec2 u_res;
uniform vec2 u_bhCenter;
uniform float u_lensing;
uniform float u_chromatic;
uniform float u_starsEnabled;
uniform vec3 u_starBgColor;
uniform float u_starDensity;
uniform float u_starSize;
uniform float u_starBrightness;
uniform float u_starDrift;
uniform float u_diskBrightness;
uniform float u_diskTemperature;
uniform float u_tempFalloff;
uniform float u_dopplerStrength;
uniform float u_turbulenceScale;
uniform float u_turbulenceStretch;
uniform float u_turbulenceSharpness;
uniform float u_turbulenceCycleTime;
uniform float u_diskRotationSpeed;
uniform float u_diskEdgeInner;
uniform float u_diskEdgeOuter;
uniform float u_camRadius;
uniform float u_camYaw;
uniform float u_camPitch;
uniform float u_stepSize;
uniform float u_diskInner;
uniform float u_diskOuter;
uniform float u_mass;
uniform float u_turbLacunarity;
uniform float u_turbPersistence;
uniform float u_nebulaEnabled;
uniform float u_nebula1Scale;
uniform float u_nebula1Density;
uniform float u_nebula1Brightness;
uniform vec3 u_nebula1Color;
uniform float u_nebula2Scale;
uniform float u_nebula2Density;
uniform float u_nebula2Brightness;
uniform vec3 u_nebula2Color;
uniform float u_bloomStrength;
uniform float u_bloomRadius;
uniform float u_bloomThreshold;

const float PI = 3.14159265359;
const float TAU = 6.28318530718;

float hash12(vec2 p) {
  vec3 p3 = fract(vec3(p.xyx) * 0.1031);
  p3 += dot(p3, p3.yzx + 33.33);
  return fract((p3.x + p3.y) * p3.z);
}

float noise3(vec3 p) {
  vec3 i = floor(p);
  vec3 f = fract(p);
  vec3 u = f * f * (3.0 - 2.0 * f);

  float n000 = hash12(i.xy + i.z * 31.7);
  float n100 = hash12((i.xy + vec2(1.0, 0.0)) + i.z * 31.7);
  float n010 = hash12((i.xy + vec2(0.0, 1.0)) + i.z * 31.7);
  float n110 = hash12((i.xy + vec2(1.0, 1.0)) + i.z * 31.7);
  float n001 = hash12(i.xy + (i.z + 1.0) * 31.7);
  float n101 = hash12((i.xy + vec2(1.0, 0.0)) + (i.z + 1.0) * 31.7);
  float n011 = hash12((i.xy + vec2(0.0, 1.0)) + (i.z + 1.0) * 31.7);
  float n111 = hash12((i.xy + vec2(1.0, 1.0)) + (i.z + 1.0) * 31.7);

  float nx00 = mix(n000, n100, u.x);
  float nx10 = mix(n010, n110, u.x);
  float nx01 = mix(n001, n101, u.x);
  float nx11 = mix(n011, n111, u.x);
  float nxy0 = mix(nx00, nx10, u.y);
  float nxy1 = mix(nx01, nx11, u.y);
  return mix(nxy0, nxy1, u.z);
}

float fbm(vec3 p) {
  float value = 0.0;
  float amp = 0.5;
  for (int i = 0; i < 4; i++) {
    value += noise3(p) * amp;
    p = p * 2.1 + vec3(19.0, 41.0, 23.0);
    amp *= 0.48;
  }
  return value;
}

float fbmTuned(vec3 p, float lacunarity, float persistence) {
  float value = 0.0;
  float amp = 0.5;
  for (int i = 0; i < 5; i++) {
    value += noise3(p) * amp;
    p = p * lacunarity + vec3(19.0, 41.0, 23.0);
    amp *= persistence;
  }
  return value;
}

vec3 blackbodyApprox(float tempK) {
  float t = clamp(tempK / 42000.0, 0.0, 1.0);
  vec3 warm = vec3(1.0, 0.8, 0.62);
  vec3 amber = vec3(1.0, 0.96, 0.86);
  vec3 white = vec3(1.0, 1.0, 0.995);
  vec3 col = mix(warm, amber, smoothstep(0.0, 0.55, t));
  return mix(col, white, smoothstep(0.42, 1.0, t));
}

vec3 rotateX3(vec3 p, float angle) {
  float s = sin(angle);
  float c = cos(angle);
  return vec3(p.x, c * p.y - s * p.z, s * p.y + c * p.z);
}

vec3 rotateY3(vec3 p, float angle) {
  float s = sin(angle);
  float c = cos(angle);
  return vec3(c * p.x - s * p.z, p.y, s * p.x + c * p.z);
}

vec3 rotateZ3(vec3 p, float angle) {
  float s = sin(angle);
  float c = cos(angle);
  return vec3(c * p.x - s * p.y, s * p.x + c * p.y, p.z);
}

float cloudMask(vec3 dir, float scale, vec3 offset, float densityBias, float detailBias) {
  vec3 p = normalize(dir) * scale + offset;
  float broad = fbmTuned(p, 2.0, 0.56);
  float detail = fbmTuned(p.zxy * (2.1 + detailBias), 2.24, 0.5);
  float wisps = fbmTuned(p.yzx * (4.1 + detailBias * 0.8), 2.62, 0.46);
  float structure = broad * 0.58 + detail * 0.27 + wisps * 0.15;
  float density = clamp(densityBias * 0.5 + 0.5, 0.0, 1.0);
  float edge0 = mix(0.54, 0.28, density);
  float edge1 = mix(0.86, 0.98, density);
  float mask = smoothstep(edge0, edge1, structure);
  return pow(mask, mix(1.7, 0.88, density));
}

float starMask(vec3 dir, float scale, vec3 offset, float threshold, float sharpness) {
  float n = noise3(normalize(dir) * scale + offset);
  float peak = max(n - threshold, 0.0) / max(0.0001, 1.0 - threshold);
  return pow(clamp(peak, 0.0, 1.0), sharpness);
}

vec3 starField(vec3 dir, float time) {
  float drift = time * 0.0005 * u_starDrift;
  vec3 skyDir = rotateY3(normalize(dir), drift);
  vec3 col = max(u_starBgColor, vec3(0.005, 0.014, 0.034));
  float density = clamp(u_starDensity, 0.004, 0.18);
  float starSizeMul = clamp(u_starSize, 0.6, 2.5);
  float starBright = clamp(u_starBrightness, 0.05, 3.0);
  vec3 skyBaseA = rotateZ3(rotateX3(skyDir, 0.24), -0.42);
  vec3 skyBaseB = rotateX3(rotateY3(skyDir, -0.78), 0.58);
  vec3 skyBaseC = rotateZ3(rotateY3(skyDir, 1.12), -0.38);

  float starVisibility = 1.0;

  if (u_nebulaEnabled > 0.5) {
    float layer1Scale = max(0.001, u_nebula1Scale);
    float layer2Scale = max(0.001, u_nebula2Scale);
    float dens1 = clamp(u_nebula1Density, -1.0, 1.0);
    float dens2 = clamp(u_nebula2Density, -1.0, 1.0);

    float neb1Mask =
      cloudMask(skyBaseA, layer1Scale * 1.7, vec3(1.7 + drift * 1.9, -4.1, 2.8), dens1, 0.0) * 0.44 +
      cloudMask(skyBaseB, layer1Scale * 2.05, vec3(-5.8 + drift * 1.4, 2.9, 4.5), dens1, 0.35) * 0.38 +
      cloudMask(skyBaseC, layer1Scale * 2.35, vec3(4.1 - drift * 1.2, 5.4, -3.6), dens1, 0.55) * 0.36 +
      cloudMask(-skyBaseA, layer1Scale * 1.95, vec3(-3.6, 7.4 - drift * 1.3, 4.8), dens1, 0.2) * 0.32 +
      cloudMask(-skyBaseB, layer1Scale * 2.15, vec3(6.9, -5.1 + drift * 1.1, 2.3), dens1, 0.48) * 0.28 +
      cloudMask(-skyBaseC, layer1Scale * 1.85, vec3(-7.8, -1.8, -5.7 - drift * 0.9), dens1, 0.26) * 0.26;

    float neb2Mask =
      cloudMask(skyBaseB, layer2Scale * 1.1, vec3(7.8 - drift * 0.9, -4.8, 2.5), dens2, 0.15) * 0.42 +
      cloudMask(skyBaseC, layer2Scale * 1.28, vec3(-2.4, 5.8 + drift * 0.7, -8.6), dens2, 0.44) * 0.36 +
      cloudMask(skyBaseA, layer2Scale * 1.45, vec3(9.1, 3.4, 6.3 - drift * 0.7), dens2, 0.62) * 0.32 +
      cloudMask(-skyBaseA, layer2Scale * 1.24, vec3(-6.2, -6.0 + drift * 0.8, 4.2), dens2, 0.34) * 0.28 +
      cloudMask(-skyBaseB, layer2Scale * 1.34, vec3(4.8, 7.2, -2.6 - drift * 0.5), dens2, 0.52) * 0.24 +
      cloudMask(-skyBaseC, layer2Scale * 1.18, vec3(-8.4, -5.7, 3.7 + drift * 0.6), dens2, 0.28) * 0.22;

    float wisps = smoothstep(0.56, 0.92, fbmTuned((skyBaseA + skyBaseB * 0.72 - skyBaseC * 0.54) * 8.6 + vec3(3.6, -7.2, 5.4 + drift * 0.7), 2.34, 0.48));
    float haze = smoothstep(0.48, 0.86, fbmTuned((skyBaseA * 0.78 + skyBaseB * 0.68 - skyBaseC * 0.34) * 3.8 + vec3(1.8, -4.9, 5.2), 2.08, 0.54));
    float puffs = smoothstep(0.62, 0.92, fbmTuned((skyBaseA * 1.14 + skyBaseC * 0.82) * 6.6 + vec3(-7.1 + drift * 0.5, 3.4, -2.3), 2.18, 0.5));
    float filaments = smoothstep(0.58, 0.92, fbmTuned((skyBaseB * 1.36 - skyBaseC * 0.72 + skyBaseA * 0.24) * 10.8 + vec3(4.6, -8.0, 1.4 + drift * 0.5), 2.5, 0.46));

    neb1Mask = pow(clamp(neb1Mask, 0.0, 1.0), mix(1.26, 0.92, dens1 * 0.5 + 0.5));
    neb2Mask = pow(clamp(neb2Mask, 0.0, 1.0), mix(1.32, 0.94, dens2 * 0.5 + 0.5));

    vec3 neb1Tint = mix(u_nebula1Color, vec3(0.24, 0.42, 0.78), 0.22);
    vec3 neb2Tint = mix(u_nebula2Color, vec3(0.1, 0.18, 0.34), 0.16);
    vec3 nebMix = mix(neb1Tint, neb2Tint, clamp(neb2Mask * 0.64 + filaments * 0.18, 0.0, 1.0));

    col += neb1Tint * neb1Mask * clamp(u_nebula1Brightness, 0.0, 1.0) * 1.96;
    col += neb2Tint * neb2Mask * clamp(u_nebula2Brightness, 0.0, 1.0) * 1.82;
    col += nebMix * wisps * 0.12;
    col += mix(neb1Tint, vec3(0.78, 0.87, 1.0), 0.34) * puffs * 0.09;
    col += nebMix * filaments * 0.09;
    col += nebMix * haze * 0.06;

    starVisibility = clamp(1.0 + neb1Mask * 0.22 + neb2Mask * 0.24 + wisps * 0.08 + puffs * 0.07, 0.9, 1.65);
  }

  if (u_starsEnabled < 0.5) {
    return max(col, vec3(0.0));
  }

  {
    float starA = starMask(skyDir, mix(120.0, 260.0, density * 3.0), vec3(17.2, 63.4, 101.7), 0.93 - density * 0.055, mix(20.0, 10.0, starSizeMul * 0.3));
    float starAHalo = pow(starA, 0.42);
    float tintMixA = noise3(skyDir * 24.0 + vec3(19.9, 7.4, 3.2));
    vec3 tintA = mix(vec3(1.0, 0.93, 0.84), vec3(0.78, 0.9, 1.0), tintMixA);
    col += tintA * starA * (0.78 + density * 8.6) * starVisibility * starBright * starSizeMul;
    col += tintA * starAHalo * 0.08 * starVisibility * (0.42 + starBright * 0.54);
  }

  {
    float starB = starMask(rotateX3(skyDir, 0.78), mix(210.0, 520.0, density * 4.2), vec3(8.7, 73.1, 31.8), 0.954 - density * 0.05, mix(24.0, 14.0, starSizeMul * 0.3));
    col += vec3(0.88, 0.93, 1.0) * starB * (0.62 + density * 5.0) * starVisibility * starBright * (0.72 + starSizeMul * 0.18);
  }

  {
    float starC = starMask(rotateY3(skyDir, -0.94), mix(360.0, 860.0, density * 4.4), vec3(121.0, 212.0, 333.0), 0.972 - density * 0.034, mix(28.0, 18.0, starSizeMul * 0.26));
    col += vec3(0.92, 0.95, 1.0) * starC * 0.92 * starVisibility * (0.64 + starBright * 0.34);
  }

  return max(col, vec3(0.0));
}

vec4 shadeDisk(float hitR, float hitAngle, vec3 rayDir, float time, float innerR, float outerR) {
  float normR = clamp((hitR - innerR) / (outerR - innerR), 0.0, 1.0);

  float peakTempK = clamp(u_diskTemperature, 1.0, 80.0) * 1000.0;
  float tempFalloff = clamp(u_tempFalloff, 0.25, 16.0);
  float tempK = peakTempK * pow(innerR / max(hitR, innerR), tempFalloff);
  vec3 diskColor = blackbodyApprox(tempK);

  float rotationSpeed = u_diskRotationSpeed;
  float cycleTime = clamp(u_turbulenceCycleTime, 1.5, 40.0);
  float cycleBlend = fract(time / cycleTime);

  float denom = max(pow(max(hitR, innerR), 1.5), 0.001);
  float phaseA = time * rotationSpeed / denom;
  float phaseB = (time + cycleTime * 0.5) * rotationSpeed / denom;

  float stretch = clamp(u_turbulenceStretch, 0.1, 10.0);
  float turbScale = clamp(u_turbulenceScale, 0.1, 3.0);
  float turbLacunarity = u_turbLacunarity;
  float turbPersistence = u_turbPersistence;
  float turbSharpness = clamp(u_turbulenceSharpness, 0.1, 10.0);
  vec3 noiseCoordA = vec3(
    hitR * turbScale,
    cos(hitAngle + phaseA) / stretch,
    sin(hitAngle + phaseA) / stretch
  );
  vec3 noiseCoordB = vec3(
    hitR * turbScale,
    cos(hitAngle + phaseB) / stretch,
    sin(hitAngle + phaseB) / stretch
  );

  float turbA = fbmTuned(noiseCoordA, turbLacunarity, turbPersistence);
  float turbB = fbmTuned(noiseCoordB, turbLacunarity, turbPersistence);
  float turbulence = mix(turbA, turbB, cycleBlend);
  float ringOpacity = pow(clamp(turbulence, 0.0, 1.0), turbSharpness);
  float edgeInner = max(0.001, clamp(u_diskEdgeInner, 0.0, 0.5));
  float edgeOuter = max(0.001, clamp(u_diskEdgeOuter, 0.0, 0.5));
  float edge = smoothstep(0.0, edgeInner, normR) * smoothstep(1.0, 1.0 - edgeOuter, normR);
  ringOpacity = mix(ringOpacity, 1.0, exp(-normR * 5.2) * 0.14);
  ringOpacity *= edge;

  float rotationSign = sign(rotationSpeed);
  vec3 velocityDir = vec3(-sin(hitAngle) * rotationSign, 0.0, cos(hitAngle) * rotationSign);
  float velocityMag = sqrt(innerR / max(hitR, innerR));
  float beta = clamp(velocityMag * 0.34, 0.0, 0.82);
  float cosTheta = dot(velocityDir, rayDir);
  float doppler = 1.0 / max(0.2, 1.0 - beta * cosTheta);
  float dopplerBoost = mix(1.0, pow(doppler, 2.4), clamp(u_dopplerStrength, 0.0, 2.0) * 0.5);

  vec3 whiteHot = vec3(1.0, 0.995, 0.975);
  vec3 orangeBand = vec3(1.0, 0.72, 0.28);
  vec3 amberBand = vec3(1.0, 0.9, 0.72);
  float hotCore = exp(-normR * 6.5);
  float outerWarm = smoothstep(0.22, 1.0, normR);
  float middleBand = exp(-pow(normR - 0.2, 2.0) * 24.0);
  float outerBand = smoothstep(0.38, 0.98, normR);

  diskColor = mix(diskColor, amberBand, middleBand * 0.22);
  diskColor = mix(diskColor, orangeBand, outerWarm * 0.52);
  diskColor = mix(diskColor, whiteHot, hotCore * 0.86);
  diskColor = mix(diskColor, orangeBand, outerBand * 0.28);

  vec3 finalColor = diskColor * dopplerBoost * u_diskBrightness;
  finalColor *= mix(1.12, 0.72, normR);
  finalColor += whiteHot * exp(-pow(normR - 0.12, 2.0) * 60.0) * 0.22;
  finalColor += amberBand * exp(-pow(normR - 0.24, 2.0) * 18.0) * 0.1;
  finalColor += orangeBand * exp(-pow(normR - 0.88, 2.0) * 10.0) * 0.16;

  float alpha = clamp(ringOpacity * mix(1.06, 0.86, normR), 0.0, 0.995);

  return vec4(finalColor, alpha);
}

void main() {
  vec2 uv = (gl_FragCoord.xy / u_res - u_bhCenter) * 2.0;
  uv.x *= u_res.x / u_res.y;

  vec3 camPos = vec3(
    u_camRadius * cos(u_camPitch) * cos(u_camYaw),
    u_camRadius * sin(u_camPitch),
    u_camRadius * cos(u_camPitch) * sin(u_camYaw)
  );

  vec3 camTarget = vec3(0.0);
  vec3 camForward = normalize(camTarget - camPos);
  vec3 worldUp = vec3(0.0, 1.0, 0.0);
  vec3 camRight = normalize(cross(worldUp, camForward));
  vec3 camUp = cross(camForward, camRight);
  vec3 rayDir = normalize(camForward + camRight * uv.x + camUp * uv.y);

  float rs = u_mass * 2.0;
  float innerR = u_diskInner;
  float outerR = u_diskOuter;

  vec3 rayPos = camPos;
  vec3 prevPos = rayPos;

  vec3 color = vec3(0.0);
  float alpha = 0.0;
  float escaped = 0.0;
  float captured = 0.0;
  float minR = 1e6;

  for (int i = 0; i < 96; i++) {
    if (escaped > 0.5 || captured > 0.5 || alpha > 0.992) {
      break;
    }

    float r = length(rayPos);
    minR = min(minR, r);

    if (r < rs * 1.01) {
      captured = 1.0;
      break;
    }

    if (r > 120.0) {
      escaped = 1.0;
      break;
    }

    vec3 toCenter = -rayPos / max(r, 0.0001);
    float bendStrength = rs / (r * r) * u_stepSize * u_lensing;
    rayDir = normalize(rayDir + toCenter * bendStrength);

    prevPos = rayPos;
    rayPos += rayDir * u_stepSize;

    if (prevPos.y * rayPos.y < 0.0 && alpha < 0.992) {
      float t = prevPos.y / (prevPos.y - rayPos.y);
      vec3 hitPos = mix(prevPos, rayPos, t);
      float hitR = length(hitPos.xz);
      if (hitR > innerR && hitR < outerR) {
        float hitAngle = atan(hitPos.z, hitPos.x);
        vec4 disk = shadeDisk(hitR, hitAngle, rayDir, u_time, innerR, outerR);
        float rem = 1.0 - alpha;
        color += disk.rgb * disk.a * rem;
        alpha += disk.a * rem;
      }
    }
  }

  vec3 holeBase = max(u_starBgColor, vec3(0.0025, 0.008, 0.02));
  float screenR = length(uv);
  float holeUvRadius = (rs / max(u_camRadius, 0.001)) * 4.0;

  if (escaped > 0.5 && alpha < 0.995) {
    vec3 bg = starField(normalize(rayDir), u_time);
    color += bg * (1.0 - alpha);
  }

  float bloomStrength = clamp(u_bloomStrength, 0.0, 3.0);
  float bloomRadius = clamp(u_bloomRadius, 0.0, 1.0);
  float bloomThreshold = clamp(u_bloomThreshold, 0.0, 1.0);

  float holeMask = 1.0 - smoothstep(holeUvRadius * 0.992, holeUvRadius * 1.004, screenR);
  float visibleHoleMask = holeMask * (1.0 - smoothstep(0.004, 0.065, alpha));
  color = mix(color, holeBase, visibleHoleMask);

  float horizonLine = exp(-pow(screenR - holeUvRadius * 1.0012, 2.0) * 92000.0);
  float horizonHalo = exp(-pow(screenR - holeUvRadius * 1.014, 2.0) * 11000.0);
  float horizonWide = exp(-pow(screenR - holeUvRadius * 1.052, 2.0) * 1200.0);
  float darkGap = smoothstep(holeUvRadius * 1.01, holeUvRadius * 1.042, screenR) *
    (1.0 - smoothstep(holeUvRadius * 1.042, holeUvRadius * 1.15, screenR));

  color *= (1.0 - darkGap * 0.68);
  color += vec3(1.0, 0.999, 0.996) * horizonLine * (0.14 + bloomStrength * 0.06);
  color += vec3(1.0, 0.994, 0.978) * horizonHalo * (0.045 + bloomStrength * 0.095);
  color += vec3(1.0, 0.975, 0.93) * horizonWide * (0.012 + bloomStrength * 0.02);

  float ringCore = smoothstep(0.12, 0.98, alpha) * (1.0 - smoothstep(0.985, 1.0, alpha));
  float ringMid = smoothstep(0.04, 0.86, alpha) * (1.0 - smoothstep(0.92, 1.0, alpha));
  float ringOuter = smoothstep(0.01, 0.72, alpha) * (1.0 - smoothstep(0.82, 1.0, alpha));
  float ringHalo = ringCore * 1.28 + ringMid * 0.86 + ringOuter * 0.3;

  color += vec3(1.0, 0.995, 0.972) * ringHalo * (0.18 + bloomStrength * 0.26 + bloomRadius * 0.12);
  color += vec3(1.0, 0.9, 0.66) * ringMid * (0.09 + bloomStrength * 0.14);

  float nearPhotonRing = exp(-pow(minR - rs * 1.014, 2.0) * 16000.0);
  float farPhotonGlow = exp(-pow(minR - rs * 1.08, 2.0) * 640.0);
  color += vec3(1.0, 0.995, 0.984) * nearPhotonRing * (0.05 + bloomStrength * 0.05);
  color += vec3(1.0, 0.94, 0.82) * farPhotonGlow * (0.01 + bloomStrength * 0.025);

  float lum = dot(color, vec3(0.2126, 0.7152, 0.0722));
  float bloomGate = smoothstep(max(0.02, bloomThreshold * 0.6), 0.95 + bloomThreshold * 0.18, lum);
  color += color * bloomGate * (0.12 + bloomRadius * 0.08 + bloomStrength * 0.16);
  color = vec3(1.0) - exp(-color * (1.15 + bloomStrength * 0.62));
  color = pow(color, vec3(0.92));

  gl_FragColor = vec4(clamp(color, 0.0, 1.0), 1.0);
}
`;

function buildSettings(root) {
  const blackHoleMass = clamp(readNumber(root.dataset.bhBlackHoleMass, SECTION_PARTICLES02_DEFAULTS.blackHoleMass), 0.05, 1.25);
  const gravitationalLensing = clamp(
    readNumber(root.dataset.bhGravitationalLensing, SECTION_PARTICLES02_DEFAULTS.gravitationalLensing),
    0.2,
    6.0
  );
  const dopplerStrength = clamp(
    readNumber(root.dataset.bhDopplerStrength, SECTION_PARTICLES02_DEFAULTS.dopplerStrength),
    0.0,
    2.2
  );
  const diskInnerRadius = clamp(
    readNumber(root.dataset.bhDiskInnerRadius, SECTION_PARTICLES02_DEFAULTS.diskInnerRadius),
    1.0,
    12.0
  );
  const diskOuterRadius = clamp(
    readNumber(root.dataset.bhDiskOuterRadius, SECTION_PARTICLES02_DEFAULTS.diskOuterRadius),
    diskInnerRadius + 0.5,
    28.0
  );
  const diskBrightness = clamp(
    readNumber(root.dataset.bhDiskBrightness, SECTION_PARTICLES02_DEFAULTS.diskBrightness),
    0.1,
    12.0
  );
  const diskTemperature = clamp(
    readNumber(root.dataset.bhDiskTemperature, SECTION_PARTICLES02_DEFAULTS.diskTemperature),
    1.0,
    80.0
  );
  const temperatureFalloff = clamp(
    readNumber(root.dataset.bhTemperatureFalloff, SECTION_PARTICLES02_DEFAULTS.temperatureFalloff),
    0.25,
    16.0
  );
  const diskEdgeSoftnessInner = clamp(
    readNumber(root.dataset.bhDiskEdgeSoftnessInner, SECTION_PARTICLES02_DEFAULTS.diskEdgeSoftnessInner),
    0.0,
    0.6
  );
  const diskEdgeSoftnessOuter = clamp(
    readNumber(root.dataset.bhDiskEdgeSoftnessOuter, SECTION_PARTICLES02_DEFAULTS.diskEdgeSoftnessOuter),
    0.0,
    0.7
  );
  const turbulenceScale = clamp(
    readNumber(root.dataset.bhTurbulenceScale, SECTION_PARTICLES02_DEFAULTS.turbulenceScale),
    0.05,
    4.0
  );
  const turbulenceStretch = clamp(
    readNumber(root.dataset.bhTurbulenceStretch, SECTION_PARTICLES02_DEFAULTS.turbulenceStretch),
    0.05,
    4.0
  );
  const turbulenceSharpness = clamp(
    readNumber(root.dataset.bhTurbulenceSharpness, SECTION_PARTICLES02_DEFAULTS.turbulenceSharpness),
    0.1,
    14.0
  );
  const diskRotationSpeed = clamp(
    readNumber(root.dataset.bhDiskRotationSpeed, SECTION_PARTICLES02_DEFAULTS.diskRotationSpeed),
    -24.0,
    24.0
  );
  const turbulenceCycleTime = clamp(
    readNumber(root.dataset.bhTurbulenceCycleTime, SECTION_PARTICLES02_DEFAULTS.turbulenceCycleTime),
    0.25,
    40.0
  );
  const turbulenceLacunarity = clamp(
    readNumber(root.dataset.bhTurbulenceLacunarity, SECTION_PARTICLES02_DEFAULTS.turbulenceLacunarity),
    1.2,
    6.0
  );
  const turbulencePersistence = clamp(
    readNumber(root.dataset.bhTurbulencePersistence, SECTION_PARTICLES02_DEFAULTS.turbulencePersistence),
    0.1,
    0.98
  );
  const starsEnabled = readBool(root.dataset.bhStarsEnabled, SECTION_PARTICLES02_DEFAULTS.starsEnabled);
  const starBackgroundColor = readColorVec3(
    root.dataset.bhStarBackgroundColor,
    SECTION_PARTICLES02_DEFAULTS.starBackgroundColor
  );
  const starDensity = clamp(readNumber(root.dataset.bhStarDensity, SECTION_PARTICLES02_DEFAULTS.starDensity), 0.0, 0.5);
  const starSize = clamp(readNumber(root.dataset.bhStarSize, SECTION_PARTICLES02_DEFAULTS.starSize), 0.2, 4.0);
  const starBrightness = clamp(
    readNumber(root.dataset.bhStarBrightness, SECTION_PARTICLES02_DEFAULTS.starBrightness),
    0.0,
    4.0
  );
  const starDrift = clamp(readNumber(root.dataset.bhStarDrift, SECTION_PARTICLES02_DEFAULTS.starDrift), -1.5, 1.5);
  const nebulaEnabled = readBool(root.dataset.bhNebulaEnabled, SECTION_PARTICLES02_DEFAULTS.nebulaEnabled);
  const nebula1Scale = clamp(readNumber(root.dataset.bhNebula1Scale, SECTION_PARTICLES02_DEFAULTS.nebula1Scale), 0.1, 10.0);
  const nebula1Density = clamp(
    readNumber(root.dataset.bhNebula1Density, SECTION_PARTICLES02_DEFAULTS.nebula1Density),
    -1.0,
    1.0
  );
  const nebula1Brightness = clamp(
    readNumber(root.dataset.bhNebula1Brightness, SECTION_PARTICLES02_DEFAULTS.nebula1Brightness),
    0.0,
    1.0
  );
  const nebula1Color = readColorVec3(root.dataset.bhNebula1Color, SECTION_PARTICLES02_DEFAULTS.nebula1Color);
  const nebula2Scale = clamp(readNumber(root.dataset.bhNebula2Scale, SECTION_PARTICLES02_DEFAULTS.nebula2Scale), 0.1, 12.0);
  const nebula2Density = clamp(
    readNumber(root.dataset.bhNebula2Density, SECTION_PARTICLES02_DEFAULTS.nebula2Density),
    -1.0,
    1.0
  );
  const nebula2Brightness = clamp(
    readNumber(root.dataset.bhNebula2Brightness, SECTION_PARTICLES02_DEFAULTS.nebula2Brightness),
    0.0,
    1.0
  );
  const nebula2Color = readColorVec3(root.dataset.bhNebula2Color, SECTION_PARTICLES02_DEFAULTS.nebula2Color);
  const bloomStrength = clamp(
    readNumber(root.dataset.bhBloomStrength, SECTION_PARTICLES02_DEFAULTS.bloomStrength),
    0.0,
    3.0
  );
  const bloomRadius = clamp(readNumber(root.dataset.bhBloomRadius, SECTION_PARTICLES02_DEFAULTS.bloomRadius), 0.0, 1.0);
  const bloomThreshold = clamp(
    readNumber(root.dataset.bhBloomThreshold, SECTION_PARTICLES02_DEFAULTS.bloomThreshold),
    0.0,
    1.0
  );
  const stepSize = clamp(readNumber(root.dataset.bhStepSize, SECTION_PARTICLES02_DEFAULTS.stepSize), 0.2, 3.0);
  const lensChroma = clamp(readNumber(root.dataset.bhLensChroma, SECTION_PARTICLES02_DEFAULTS.lensChroma), 0.0, 1.0);
  const holeX = clamp(readNumber(root.dataset.bhHoleX, SECTION_PARTICLES02_DEFAULTS.holeX), 0.08, 0.92);
  const holeY = clamp(readNumber(root.dataset.bhHoleY, SECTION_PARTICLES02_DEFAULTS.holeY), 0.08, 0.92);
  const mouseInfluence = clamp(
    readNumber(root.dataset.bhMouseInfluence, SECTION_PARTICLES02_DEFAULTS.mouseInfluence),
    0.0,
    0.2
  );

  const zoomBase = clamp(
    SECTION_PARTICLES02_DEFAULTS.zoomBase * (diskOuterRadius / SECTION_PARTICLES02_DEFAULTS.diskOuterRadius),
    18.0,
    48.0
  );

  return {
    holeX,
    holeY,
    mouseInfluence,
    mass: blackHoleMass,
    lensingStrength: gravitationalLensing,
    chromaticStrength: lensChroma,
    dopplerStrength,
    diskInner: diskInnerRadius,
    diskOuter: diskOuterRadius,
    diskBrightness,
    diskTemperature,
    temperatureFalloff,
    turbulenceScale,
    turbulenceStretch,
    turbulenceSharpness,
    diskRotationSpeed,
    turbulenceCycleTime,
    turbLacunarity: turbulenceLacunarity,
    turbPersistence: turbulencePersistence,
    diskEdgeSoftnessInner,
    diskEdgeSoftnessOuter,
    starsEnabled,
    starBackgroundColor,
    starDensity,
    starSize,
    starBrightness,
    starDrift,
    nebulaEnabled,
    nebula1Scale,
    nebula1Density,
    nebula1Brightness,
    nebula1Color,
    nebula2Scale,
    nebula2Density,
    nebula2Brightness,
    nebula2Color,
    bloomStrength,
    bloomRadius,
    bloomThreshold,
    stepSize,
    zoomBase,
    zoomMin: 10.0,
    zoomMax: 62.0,
    yawBase: SECTION_PARTICLES02_DEFAULTS.yawBase,
    pitchBase: SECTION_PARTICLES02_DEFAULTS.pitchBase,
  };
}

function createProgram(gl, vertexSource, fragmentSource) {
  const vs = compileShader(gl, gl.VERTEX_SHADER, vertexSource);
  const fs = compileShader(gl, gl.FRAGMENT_SHADER, fragmentSource);
  if (!vs || !fs) {
    return null;
  }

  const program = gl.createProgram();
  gl.attachShader(program, vs);
  gl.attachShader(program, fs);
  gl.linkProgram(program);

  gl.deleteShader(vs);
  gl.deleteShader(fs);

  if (!gl.getProgramParameter(program, gl.LINK_STATUS)) {
    console.error('sectionParticles02 program link error:', gl.getProgramInfoLog(program));
    gl.deleteProgram(program);
    return null;
  }

  return program;
}

function compileShader(gl, type, source) {
  const shader = gl.createShader(type);
  gl.shaderSource(shader, source);
  gl.compileShader(shader);

  if (!gl.getShaderParameter(shader, gl.COMPILE_STATUS)) {
    console.error('sectionParticles02 shader compile error:', gl.getShaderInfoLog(shader), '\n', source);
    gl.deleteShader(shader);
    return null;
  }

  return shader;
}

function readNumber(rawValue, fallback) {
  const value = Number(rawValue);
  return Number.isFinite(value) ? value : fallback;
}

function readBool(rawValue, fallback) {
  if (typeof rawValue !== 'string' || rawValue.length === 0) {
    return fallback;
  }

  const value = rawValue.trim().toLowerCase();
  if (value === 'true' || value === '1' || value === 'yes') {
    return true;
  }
  if (value === 'false' || value === '0' || value === 'no') {
    return false;
  }

  return fallback;
}

function readColorVec3(rawValue, fallbackHex) {
  const candidate = typeof rawValue === 'string' ? rawValue.trim() : '';
  return hexToRgb01(isValidHex(candidate) ? candidate : fallbackHex);
}

function hexToRgb01(hex) {
  let normalized = String(hex).trim().replace('#', '');
  if (normalized.length === 3) {
    normalized = normalized
      .split('')
      .map((part) => `${part}${part}`)
      .join('');
  }

  if (!/^[0-9a-fA-F]{6}$/.test(normalized)) {
    normalized = String(SECTION_PARTICLES02_DEFAULTS.starBackgroundColor).trim().replace('#', '');
  }

  return [
    Number.parseInt(normalized.slice(0, 2), 16) / 255,
    Number.parseInt(normalized.slice(2, 4), 16) / 255,
    Number.parseInt(normalized.slice(4, 6), 16) / 255,
  ];
}

function isValidHex(value) {
  const normalized = String(value).trim().replace('#', '');
  return /^[0-9a-fA-F]{3}$/.test(normalized) || /^[0-9a-fA-F]{6}$/.test(normalized);
}

function clamp(value, min, max) {
  return Math.max(min, Math.min(max, value));
}
