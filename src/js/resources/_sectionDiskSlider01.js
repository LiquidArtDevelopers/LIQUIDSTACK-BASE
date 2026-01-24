import gsap from 'gsap';
import ScrollTrigger from 'gsap/ScrollTrigger';
import * as THREE from 'three';

const TAU = Math.PI * 2;

const VERTEX_SHADER = `
  varying vec2 vUv;

  void main() {
    vUv = uv;
    gl_Position = projectionMatrix * modelViewMatrix * vec4(position, 1.0);
  }
`;

const FRAGMENT_SHADER = `
  varying vec2 vUv;

  uniform sampler2D uTexture0;
  uniform sampler2D uTexture1;
  uniform vec2 uResolution;
  uniform float uProgress;
  uniform float uDirection;
  uniform float uRadius;
  uniform float uRingThickness;
  uniform float uStrength;
  uniform float uRotation;
  uniform float uArcPadding;
  uniform float uBorderPadding;
  uniform float uProgressRing;
  uniform float uTime;
  uniform float uIdleMix;

  vec2 coverUv(vec2 uv, vec2 resolution) {
    float aspect = resolution.x / max(resolution.y, 1.0);
    vec2 centered = uv - 0.5;
    centered.x *= aspect;
    centered = clamp(centered, vec2(-0.5 * aspect, -0.5), vec2(0.5 * aspect, 0.5));
    centered.x /= aspect;
    return centered + 0.5;
  }

  float ringMask(vec2 centered, float outerRadius, float innerRadius) {
    float dist = length(centered);
    float outer = 1.0 - smoothstep(outerRadius, outerRadius + 0.035, dist);
    float inner = smoothstep(innerRadius - 0.03, innerRadius + 0.014, dist);
    return clamp(outer * inner, 0.0, 1.0);
  }

  float arcMask(float angle, float progress, float direction, float padding) {
    float sweep = clamp(progress, 0.0, 0.999) * (TAU - padding);
    float oriented = direction >= 0.0 ? angle : -angle;
    float wrapped = mod(oriented + TAU, TAU);
    float within = step(wrapped, sweep);
    float edge = smoothstep(sweep - 0.16, sweep + 0.02, wrapped);
    return within * (1.0 - edge);
  }

  void main() {
    vec2 uv = coverUv(vUv, uResolution);
    float aspect = uResolution.x / max(uResolution.y, 1.0);
    vec2 centered = uv - 0.5;
    centered.x *= aspect;

    float outerRadius = uRadius - uBorderPadding;
    float innerRadius = max(0.04, outerRadius - uRingThickness + uBorderPadding);
    float ring = ringMask(centered, outerRadius, innerRadius);

    float angle = atan(centered.y, centered.x);
    float dist = length(centered);

    float idleStrength = mix(0.28, 1.0, uIdleMix);
    float wave = sin(((dist - innerRadius) * 26.0) - (uTime * 1.7) - (uRotation * 3.2));
    float drift = sin((angle * 2.6) + (uTime * 0.8) + (uRotation * 1.8));
    vec2 normal = dist > 0.0005 ? centered / dist : vec2(0.0, 0.0);
    vec2 tangent = vec2(-normal.y, normal.x);
    vec2 flow = normal * wave * 0.018 + tangent * drift * 0.012;
    vec2 offset = flow * uStrength * idleStrength * ring;

    vec4 base0 = texture2D(uTexture0, clamp(uv + offset, 0.0, 1.0));
    vec4 base1 = texture2D(uTexture1, clamp(uv - offset * 0.65, 0.0, 1.0));

    float globalMix = smoothstep(0.0, 1.0, uProgress);
    vec4 baseColor = mix(base0, base1, globalMix);

    float arc = arcMask(angle, globalMix, uDirection, uArcPadding) * ring;
    float arcBlend = clamp(arc * 1.2, 0.0, 1.0);
    vec4 ringColor = mix(base0, base1, arcBlend);

    vec4 color = mix(baseColor, ringColor, ring);

    float progressArc = arcMask(angle, clamp(uProgressRing, 0.0, 0.999), 1.0, 0.18);
    float innerEdge = smoothstep(innerRadius - 0.008, innerRadius + 0.01, dist)
      * (1.0 - smoothstep(innerRadius + 0.026, innerRadius + 0.05, dist));
    float progressGlow = progressArc * innerEdge * 0.55;
    color.rgb = mix(color.rgb, vec3(0.97, 0.98, 1.0), progressGlow);

    float highlight = ring * 0.05 * sin((angle * 7.0) - (uTime * 1.2));
    color.rgb += highlight;

    gl_FragColor = color;
  }
`;

function clampFloat(value, min, max, fallback) {
  const parsed = Number.parseFloat(value);
  if (!Number.isFinite(parsed)) {
    return fallback;
  }
  return Math.min(max, Math.max(min, parsed));
}

function collectSlides(section) {
  return Array.from(section.querySelectorAll('[data-disk-slide]'))
    .map((slide) => {
      const src = slide.getAttribute('data-disk-slide-src') || '';
      return {
        element: slide,
        src,
      };
    })
    .filter((slide) => slide.src !== '');
}

function markSlideStates(slides, baseIndex, progress) {
  const nextIndex = Math.min(slides.length - 1, baseIndex + 1);
  const activeIndex = progress >= 0.5 ? nextIndex : baseIndex;
  slides.forEach((slide, index) => {
    const isActive = index === activeIndex;
    slide.element.classList.toggle('is-active', isActive);
    slide.element.setAttribute('aria-hidden', String(!isActive));
  });
}

function loadTextures(renderer, slides) {
  const loader = new THREE.TextureLoader();
  const promises = slides.map(
    (slide) =>
      new Promise((resolve, reject) => {
        loader.load(
          slide.src,
          (texture) => {
            texture.colorSpace = THREE.SRGBColorSpace;
            texture.minFilter = THREE.LinearFilter;
            texture.magFilter = THREE.LinearFilter;
            texture.generateMipmaps = false;
            resolve(texture);
          },
          undefined,
          () => reject(new Error(`No se pudo cargar la textura: ${slide.src}`))
        );
      })
  );

  renderer.outputColorSpace = THREE.SRGBColorSpace;

  return Promise.all(promises);
}

export default function initSectionDiskSlider01() {
  gsap.registerPlugin(ScrollTrigger);

  const sections = Array.from(document.querySelectorAll('[data-disk-slider]'));
  if (sections.length === 0) {
    return;
  }

  const prefersReducedMotion = window.matchMedia('(prefers-reduced-motion: reduce)').matches;

  sections.forEach((section) => {
    if (section.dataset.diskSliderInit === 'true') {
      return;
    }
    section.dataset.diskSliderInit = 'true';

    const slides = collectSlides(section);
    if (slides.length < 2) {
      section.classList.add('is-static');
      return;
    }

    if (prefersReducedMotion) {
      section.classList.add('is-reduced-motion');
      markSlideStates(slides, 0, 0);
      return;
    }

    const canvas = section.querySelector('[data-disk-canvas]');
    const stage = section.querySelector('.sectionDiskSlider01-stage');
    if (!canvas || !stage) {
      section.classList.add('is-static');
      return;
    }

    let renderer;
    try {
      renderer = new THREE.WebGLRenderer({
        canvas,
        antialias: true,
        alpha: true,
        powerPreference: 'high-performance',
      });
    } catch (error) {
      section.classList.add('is-static');
      return;
    }

    const pixelRatio = Math.min(window.devicePixelRatio || 1, 2);
    renderer.setPixelRatio(pixelRatio);
    renderer.setClearColor(0x05070d, 1);

    const scene = new THREE.Scene();
    const camera = new THREE.OrthographicCamera(-1, 1, 1, -1, 0, 1);

    const geometry = new THREE.PlaneGeometry(2, 2, 1, 1);
    const uniforms = {
      uTexture0: { value: null },
      uTexture1: { value: null },
      uResolution: { value: new THREE.Vector2(1, 1) },
      uProgress: { value: 0 },
      uDirection: { value: 1 },
      uRadius: {
        value: clampFloat(section.dataset.diskRadius, 0.4, 0.64, 0.52),
      },
      uRingThickness: { value: 0.25 },
      uStrength: {
        value: clampFloat(section.dataset.diskStrength, 0.2, 1.4, 0.68),
      },
      uRotation: { value: 0 },
      uArcPadding: { value: 0.22 },
      uBorderPadding: { value: 0.012 },
      uProgressRing: { value: 0 },
      uTime: { value: 0 },
      uIdleMix: { value: 1 },
    };

    const material = new THREE.ShaderMaterial({
      uniforms,
      vertexShader: VERTEX_SHADER,
      fragmentShader: FRAGMENT_SHADER,
    });

    const mesh = new THREE.Mesh(geometry, material);
    scene.add(mesh);

    let textures = [];
    let progressTarget = 0;
    let currentIndex = 0;
    let scrollRaw = 0;
    let autoRaw = 0;
    let lastRaw = 0;
    let lastActiveTime = performance.now();

    const updateSize = () => {
      const rect = stage.getBoundingClientRect();
      const width = Math.max(1, rect.width);
      const height = Math.max(1, rect.height);
      renderer.setSize(width, height, false);
      uniforms.uResolution.value.set(width, height);
    };

    const setSlidePair = (baseIndex) => {
      const safeBase = Math.min(textures.length - 2, Math.max(0, baseIndex));
      const safeNext = safeBase + 1;
      currentIndex = safeBase;
      uniforms.uTexture0.value = textures[safeBase];
      uniforms.uTexture1.value = textures[safeNext];
    };

    const stepVh = clampFloat(section.dataset.diskStepVh, 110, 280, 175);
    const scrollPower = clampFloat(section.dataset.diskScrollPower, 0.6, 1.9, 1.16);

    const setRingThickness = () => {
      const minSide = Math.max(1, Math.min(window.innerWidth || 1, window.innerHeight || 1));
      const desired = minSide * 0.165 * 1.5;
      const thickness = Math.min(minSide * 0.34, Math.max(minSide * 0.18, desired));
      uniforms.uRingThickness.value = thickness / minSide;
    };

    let trigger = null;
    const setupScrollTrigger = () => {
      trigger?.kill();
      const totalSlides = textures.length;
      const segments = Math.max(1, totalSlides - 1);
      const endDistance = window.innerHeight * (stepVh / 100) * segments;

      trigger = ScrollTrigger.create({
        trigger: section,
        start: 'top top',
        end: `+=${endDistance}`,
        pin: true,
        scrub: 0.9,
        invalidateOnRefresh: true,
        onUpdate: (self) => {
          const maxRaw = segments - 0.0001;
          scrollRaw = Math.min(maxRaw, Math.max(0, self.progress * segments));
          lastActiveTime = performance.now();
        },
        onRefresh: () => {
          updateSize();
          setRingThickness();
        },
      });
    };

    const clock = new THREE.Clock();
    const autoDelay = 5;

    const renderLoop = () => {
      const delta = Math.min(0.05, clock.getDelta());
      uniforms.uTime.value += delta;

      const segments = Math.max(1, textures.length - 1);
      const idleFor = (performance.now() - lastActiveTime) / 1000;
      const isIdle = idleFor > 0.6;

      if (isIdle) {
        autoRaw = Math.min(segments - 0.0001, autoRaw + delta / autoDelay);
      } else if (autoRaw < scrollRaw) {
        autoRaw = scrollRaw;
      }

      const rawTarget = Math.max(scrollRaw, autoRaw);
      const rawDiff = rawTarget - lastRaw;
      const smoothing = Math.min(1, delta * 7.2 * scrollPower);
      lastRaw += rawDiff * smoothing;

      const baseIndex = Math.min(textures.length - 2, Math.max(0, Math.floor(lastRaw)));
      const localProgress = lastRaw - baseIndex;

      if (baseIndex !== currentIndex || uniforms.uTexture0.value === null) {
        setSlidePair(baseIndex);
      }

      progressTarget = localProgress;
      const progressEase = Math.min(1, delta * 8.6);
      uniforms.uProgress.value += (progressTarget - uniforms.uProgress.value) * progressEase;

      const directionFromDiff = Math.sign(rawDiff);
      if (Math.abs(rawDiff) > 0.00015 && directionFromDiff !== 0) {
        uniforms.uDirection.value = directionFromDiff;
      }

      uniforms.uIdleMix.value = isIdle ? 0.38 : 1;
      uniforms.uRotation.value += rawDiff * Math.PI * 1.05 + delta * 0.35;

      uniforms.uProgressRing.value = segments > 0 ? lastRaw / segments : 0;

      markSlideStates(slides, currentIndex, uniforms.uProgress.value);
      renderer.render(scene, camera);
    };

    loadTextures(renderer, slides)
      .then((loadedTextures) => {
        textures = loadedTextures;
        section.classList.add('is-ready');
        updateSize();
        setRingThickness();
        setSlidePair(0);
        markSlideStates(slides, 0, 0);
        setupScrollTrigger();
        renderer.setAnimationLoop(renderLoop);
      })
      .catch(() => {
        renderer.dispose();
        section.classList.add('is-static');
      });

    const handleResize = () => {
      updateSize();
      setRingThickness();
      trigger?.refresh();
    };

    window.addEventListener('resize', handleResize);
  });
}
