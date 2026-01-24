import gsap from 'gsap';
import ScrollTrigger from 'gsap/ScrollTrigger';
import * as THREE from 'three';

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

  vec2 coverUv(vec2 uv, vec2 resolution) {
    float aspect = resolution.x / max(resolution.y, 1.0);
    vec2 centered = uv - 0.5;
    centered.x *= aspect;
    centered = clamp(centered, vec2(-0.5 * aspect, -0.5), vec2(0.5 * aspect, 0.5));
    centered.x /= aspect;
    return centered + 0.5;
  }

  void main() {
    vec2 uv = coverUv(vUv, uResolution);
    float aspect = uResolution.x / max(uResolution.y, 1.0);
    vec2 centered = uv - 0.5;
    centered.x *= aspect;

    float dist = length(centered);
    float ringOuter = uRadius;
    float ringInner = max(0.05, ringOuter - uRingThickness);
    float outerMask = 1.0 - smoothstep(ringOuter, ringOuter + 0.06, dist);
    float innerMask = smoothstep(ringInner - 0.045, ringInner + 0.02, dist);
    float ringMask = clamp(outerMask * innerMask, 0.0, 1.0);

    float angle = atan(centered.y, centered.x);
    float swirlAngle = angle + (uRotation * uDirection);

    vec2 swirlDir = vec2(cos(swirlAngle), sin(swirlAngle));
    float ripple = sin((dist * 24.0) - (uRotation * 8.0)) * 0.012 * uStrength;
    float twist = sin((swirlAngle * 6.0) + (uProgress * 6.2831)) * 0.02 * uStrength;
    vec2 offset = swirlDir * (ripple + twist) * ringMask;

    vec4 tex0 = texture2D(uTexture0, clamp(uv + offset, 0.0, 1.0));
    vec4 tex1 = texture2D(uTexture1, clamp(uv - offset, 0.0, 1.0));

    float progressMix = smoothstep(0.0, 1.0, uProgress);
    float reveal = progressMix * smoothstep(0.0, 1.0, ringMask + (progressMix * 0.6));
    vec4 ringColor = mix(tex0, tex1, reveal);
    vec4 baseColor = mix(tex0, tex1, progressMix);
    vec4 color = mix(baseColor, ringColor, ringMask);

    float sheen = ringMask * 0.07 * sin((swirlAngle * 10.0) - (uRotation * 5.0));
    color.rgb += sheen;

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
        value: clampFloat(section.dataset.diskRadius, 0.36, 0.6, 0.48),
      },
      uRingThickness: { value: 0.18 },
      uStrength: {
        value: clampFloat(section.dataset.diskStrength, 0.2, 1.4, 0.85),
      },
      uRotation: { value: 0 },
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
    let nextIndex = 1;
    let rawTarget = 0;
    let lastRaw = 0;

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
      nextIndex = safeNext;
      uniforms.uTexture0.value = textures[safeBase];
      uniforms.uTexture1.value = textures[safeNext];
    };

    const stepVh = clampFloat(section.dataset.diskStepVh, 100, 240, 160);
    const scrollPower = clampFloat(section.dataset.diskScrollPower, 0.6, 1.8, 1.1);

    const setRingThickness = () => {
      const minSide = Math.max(1, Math.min(window.innerWidth || 1, window.innerHeight || 1));
      const desired = minSide * 0.11;
      const thickness = Math.min(minSide * 0.2, Math.max(minSide * 0.08, desired));
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
        scrub: 0.8,
        invalidateOnRefresh: true,
        onUpdate: (self) => {
          const maxRaw = segments - 0.0001;
          rawTarget = Math.min(maxRaw, Math.max(0, self.progress * segments));
          const direction = self.direction >= 0 ? 1 : -1;
          uniforms.uDirection.value = direction;
        },
        onRefresh: updateSize,
      });
    };

    const clock = new THREE.Clock();

    const renderLoop = () => {
      const delta = Math.min(0.05, clock.getDelta());

      const rawDiff = rawTarget - lastRaw;
      lastRaw += rawDiff * Math.min(1, delta * 8 * scrollPower);

      const baseIndex = Math.min(textures.length - 2, Math.max(0, Math.floor(lastRaw)));
      const localProgress = lastRaw - baseIndex;

      if (baseIndex !== currentIndex || uniforms.uTexture0.value === null) {
        setSlidePair(baseIndex);
      }

      progressTarget = localProgress;
      uniforms.uProgress.value += (progressTarget - uniforms.uProgress.value) * Math.min(1, delta * 10);

      uniforms.uRotation.value += rawDiff * Math.PI * 1.35;

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
