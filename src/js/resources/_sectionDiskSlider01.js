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
  uniform float uRadius;
  uniform float uInnerRadius;
  uniform float uStrength;
  uniform float uRotation;
  uniform float uArcPadding;
  uniform float uTime;
  uniform float uIdleMix;
  uniform float uEdgeSoftness;

  vec2 coverUv(vec2 uv, vec2 resolution) {
    float aspect = resolution.x / max(resolution.y, 1.0);
    vec2 centered = uv - 0.5;
    centered.x *= aspect;
    centered = clamp(centered, vec2(-0.5 * aspect, -0.5), vec2(0.5 * aspect, 0.5));
    centered.x /= aspect;
    return centered + 0.5;
  }

  float diskMask(vec2 centered, float radius, float softness) {
    float dist = length(centered);
    return smoothstep(radius, radius - softness, dist);
  }

  float ringMask(vec2 centered, float outerRadius, float innerRadius, float softness) {
    float dist = length(centered);
    float outer = smoothstep(outerRadius, outerRadius - softness, dist);
    float inner = smoothstep(innerRadius, innerRadius + softness, dist);
    return outer * inner;
  }

  float arcMask(float angle, float progress, float padding) {
    float clamped = clamp(progress, 0.0, 1.0);
    if (clamped >= 0.9995) {
      return 1.0;
    }
    float sweep = clamped * (6.28318530718 - padding);
    float startAngle = angle - 1.57079632679;
    float wrapped = mod(-startAngle + 6.28318530718, 6.28318530718);
    return step(wrapped, sweep);
  }

  void main() {
    vec2 uv = coverUv(vUv, uResolution);
    float aspect = uResolution.x / max(uResolution.y, 1.0);
    vec2 centered = uv - 0.5;
    centered.x *= aspect;

    float dist = length(centered);
    float ring = ringMask(centered, uRadius, uInnerRadius, uEdgeSoftness);

    float angle = atan(centered.y, centered.x);
    float edgeFactor = smoothstep(0.0, uRadius, dist);
    float idleStrength = mix(0.25, 1.0, uIdleMix);

    vec2 normal = dist > 0.0005 ? centered / dist : vec2(0.0, 0.0);
    vec2 tangent = vec2(-normal.y, normal.x);
    float swirl = dot(normal, vec2(0.78, 0.62));
    float swirl2 = dot(normal, vec2(-0.34, 0.94));
    float wave = sin((dist * 18.0) - (uTime * 1.4) + (uRotation * 0.8) + (swirl * 6.2831853));
    float ripple = sin((dist * 28.0) + (uTime * 1.1) - (uRotation * 1.1) + (swirl2 * 6.2831853));
    vec2 flow = normal * wave * 0.018 + tangent * ripple * 0.012;
    vec2 offset = flow * uStrength * idleStrength * (0.35 + edgeFactor * 0.65) * ring;

    vec4 base0 = texture2D(uTexture0, clamp(uv, 0.0, 1.0));
    vec4 base1 = texture2D(uTexture1, clamp(uv, 0.0, 1.0));
    vec4 distorted0 = texture2D(uTexture0, clamp(uv + offset, 0.0, 1.0));
    vec4 distorted1 = texture2D(uTexture1, clamp(uv + offset, 0.0, 1.0));

    float outsideMix = smoothstep(0.0, 1.0, uProgress);
    vec4 outsideColor = mix(base0, base1, outsideMix);

    float wipe = arcMask(angle, uProgress, uArcPadding);
    vec4 insideColor = mix(distorted0, distorted1, wipe);

    vec4 color = mix(outsideColor, insideColor, ring);

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

function resolveInnerRadius(section, outerRadius) {
  const innerValue = Number.parseFloat(section.dataset.diskInner || '');
  const ratioValue = Number.parseFloat(section.dataset.diskInnerRatio || '');
  const ratio = Number.isFinite(ratioValue) ? ratioValue : 0.62;
  let innerRadius = Number.isFinite(innerValue) ? innerValue : outerRadius * ratio;
  const minThickness = 0.08;
  const maxInner = Math.max(0.12, outerRadius - minThickness);
  innerRadius = Math.min(maxInner, Math.max(0.18, innerRadius));
  return innerRadius;
}

function collectSlides(section) {
  return Array.from(section.querySelectorAll('[data-disk-slide]'))
    .map((slide) => {
      const src = slide.getAttribute('data-disk-slide-src') || '';
      const kicker = slide.getAttribute('data-disk-kicker') || '';
      const title = slide.getAttribute('data-disk-title') || '';
      return {
        element: slide,
        src,
        kicker,
        title,
      };
    })
    .filter((slide) => slide.src !== '');
}

function updateProgressUi(progressValue, ringEl) {
  if (!ringEl) {
    return;
  }
  const radius = Number.parseFloat(ringEl.getAttribute('r') || '0');
  if (!Number.isFinite(radius) || radius <= 0) {
    return;
  }
  const circumference = 2 * Math.PI * radius;
  const clamped = Math.max(0, Math.min(1, progressValue));

  const dash = circumference * clamped;
  ringEl.style.strokeDasharray = `${dash} ${circumference * 2}`;
  ringEl.style.strokeDashoffset = '0';
}

function getNextIndex(index, total) {
  return total > 0 ? (index + 1) % total : 0;
}

function easeInOutQuint(t) {
  if (t < 0.5) {
    return 16 * t * t * t * t * t;
  }
  return 1 - Math.pow(-2 * t + 2, 5) / 2;
}

function inverseEaseInOut(easeFn, p) {
  const clamped = Math.max(0, Math.min(1, p));
  let low = 0;
  let high = 1;
  for (let i = 0; i < 24; i += 1) {
    const mid = (low + high) / 2;
    if (easeFn(mid) < clamped) {
      low = mid;
    } else {
      high = mid;
    }
  }
  return (low + high) / 2;
}

function updateCenterContent(slides, baseIndex, progress, titleEl, kickerEl) {
  if (!titleEl && !kickerEl) {
    return;
  }
  const nextIndex = getNextIndex(baseIndex, slides.length);
  const activeIndex = progress >= 0.5 ? nextIndex : baseIndex;
  const activeSlide = slides[activeIndex];
  if (!activeSlide) {
    return;
  }
  if (titleEl) {
    titleEl.textContent = activeSlide.title || '';
  }
  if (kickerEl) {
    kickerEl.textContent = activeSlide.kicker || '';
    kickerEl.style.display = activeSlide.kicker ? '' : 'none';
  }
}

function markSlideStates(slides, baseIndex, progress) {
  const nextIndex = getNextIndex(baseIndex, slides.length);
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

    const centerTitle = section.querySelector('[data-disk-center-title]');
    const centerKicker = section.querySelector('[data-disk-center-kicker]');
    const progressRing = section.querySelector('[data-disk-progress-ring]');
    const overlayDisk = section.querySelector('.sectionDiskSlider01-overlayDisk');
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
    const initialRadius = clampFloat(section.dataset.diskRadius, 0.4, 0.64, 0.48);
    const initialInnerRadius = resolveInnerRadius(section, initialRadius);
    const uniforms = {
      uTexture0: { value: null },
      uTexture1: { value: null },
      uResolution: { value: new THREE.Vector2(1, 1) },
      uProgress: { value: 0 },
      uRadius: {
        value: initialRadius,
      },
      uInnerRadius: { value: initialInnerRadius },
      uStrength: {
        value: clampFloat(section.dataset.diskStrength, 0.2, 1.4, 0.68),
      },
      uRotation: { value: 0 },
      uArcPadding: { value: 0 },
      uTime: { value: 0 },
      uIdleMix: { value: 1 },
      uEdgeSoftness: {
        value: clampFloat(section.dataset.diskEdgeSoftness, 0.001, 0.02, 0.0035),
      },
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
    let lastRaw = 0;
    let lastActiveTime = performance.now();
    let wasIdle = false;
    let outerRadius = uniforms.uRadius.value;
    let innerRadius = uniforms.uInnerRadius.value;
    let autoIndex = 0;
    let autoPhase = 0;
    let autoProgress = 0;
    let autoHold = 0;
    let lastBaseIndex = 0;

    const updateSize = () => {
      const rect = stage.getBoundingClientRect();
      const width = Math.max(1, rect.width);
      const height = Math.max(1, rect.height);
      renderer.setSize(width, height, false);
      uniforms.uResolution.value.set(width, height);
    };

    const syncDiskSize = () => {
      if (!overlayDisk) {
        return;
      }
      const rect = stage.getBoundingClientRect();
      const minSide = Math.max(1, Math.min(rect.width, rect.height));
      outerRadius = clampFloat(section.dataset.diskRadius, 0.4, 0.64, 0.48);
      innerRadius = resolveInnerRadius(section, outerRadius);
      uniforms.uRadius.value = outerRadius;
      uniforms.uInnerRadius.value = innerRadius;
      const edgeSoftness = clampFloat(
        section.dataset.diskEdgeSoftness,
        0.001,
        0.02,
        Math.max(0.001, 1.25 / minSide)
      );
      uniforms.uEdgeSoftness.value = edgeSoftness;
      const diameter = Math.round(minSide * outerRadius * 2);
      section.style.setProperty('--disk-size', `${diameter}px`);
    };

    const setSlidePair = (baseIndex) => {
      const total = textures.length;
      if (total === 0) {
        return;
      }
      const safeBase = ((baseIndex % total) + total) % total;
      const safeNext = getNextIndex(safeBase, total);
      currentIndex = safeBase;
      uniforms.uTexture0.value = textures[safeBase];
      uniforms.uTexture1.value = textures[safeNext];
    };

    const stepVh = clampFloat(section.dataset.diskStepVh, 110, 280, 175);

    const syncProgressRadius = () => {
      if (!progressRing || !overlayDisk) {
        return;
      }
      const rect = overlayDisk.getBoundingClientRect();
      const size = Math.max(1, Math.min(rect.width, rect.height));
      const ratio = outerRadius > 0 ? innerRadius / outerRadius : 0.62;
      const radiusPx = Math.max(2, size * 0.5 * ratio - 0.5);
      const viewRadius = (radiusPx / size) * 100;
      progressRing.setAttribute('r', viewRadius.toFixed(3));
    };

    let trigger = null;
    const setupScrollTrigger = () => {
      trigger?.kill();
      const totalSlides = textures.length;
      const segments = Math.max(1, totalSlides);
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
          syncDiskSize();
          syncProgressRadius();
        },
      });
    };

    const clock = new THREE.Clock();
    const autoTravel = 1.2;
    const autoHoldDelay = 4;

    const renderLoop = () => {
      const delta = Math.min(0.05, clock.getDelta());
      uniforms.uTime.value += delta;

      const segments = Math.max(1, textures.length);
      const idleFor = (performance.now() - lastActiveTime) / 1000;
      const isIdle = idleFor > 0.6;

      if (isIdle) {
        if (!wasIdle) {
          autoIndex = Math.min(segments - 1, Math.max(0, Math.floor(lastRaw)));
          autoProgress = Math.max(0, Math.min(1, lastRaw - autoIndex));
          autoPhase = inverseEaseInOut(easeInOutQuint, autoProgress);
          autoHold = 0;
        }
        if (autoHold > 0) {
          autoHold = Math.max(0, autoHold - delta);
          if (autoHold === 0 && autoProgress >= 1) {
            autoIndex = (autoIndex + 1) % segments;
            autoPhase = 0;
            autoProgress = 0;
          }
        } else {
          autoPhase = Math.min(1, autoPhase + delta / autoTravel);
          autoProgress = easeInOutQuint(autoPhase);
          if (autoPhase >= 1) {
            autoProgress = 1;
            autoHold = autoHoldDelay;
          }
        }
      } else {
        const maxRaw = Math.max(0, Math.min(segments - 0.0001, scrollRaw));
        autoIndex = Math.min(segments - 1, Math.floor(maxRaw));
        autoProgress = Math.max(0, Math.min(1, maxRaw - autoIndex));
        autoHold = 0;
        autoPhase = inverseEaseInOut(easeInOutQuint, autoProgress);
      }
      wasIdle = isIdle;

      const rawTarget = isIdle ? autoIndex + autoProgress : scrollRaw;
      const rawDiff = rawTarget - lastRaw;
      lastRaw = rawTarget;

      const rawForSlides = Math.min(segments, Math.max(0, lastRaw));
      const rawForRing = rawForSlides;
      const baseIndex = Math.min(segments - 1, Math.floor(rawForSlides));
      const localProgress = rawForSlides - baseIndex;
      const baseChanged = baseIndex !== lastBaseIndex;

      if (baseIndex !== currentIndex || uniforms.uTexture0.value === null) {
        setSlidePair(baseIndex);
      }

      progressTarget = localProgress;
      if (baseChanged) {
        uniforms.uProgress.value = localProgress;
        progressTarget = localProgress;
      } else {
        const progressEase = Math.min(1, delta * 8.6);
        uniforms.uProgress.value += (progressTarget - uniforms.uProgress.value) * progressEase;
      }
      lastBaseIndex = baseIndex;

      uniforms.uIdleMix.value = isIdle ? 0.38 : 1;
      uniforms.uRotation.value += Math.abs(rawDiff) * Math.PI * 1.05 + delta * 0.35;

      const ringProgress = segments > 0 ? rawForRing / segments : 0;
      updateProgressUi(ringProgress, progressRing);

      markSlideStates(slides, currentIndex, uniforms.uProgress.value);
      updateCenterContent(slides, currentIndex, uniforms.uProgress.value, centerTitle, centerKicker);
      renderer.render(scene, camera);
    };

    loadTextures(renderer, slides)
      .then((loadedTextures) => {
        textures = loadedTextures;
        section.classList.add('is-ready');
        updateSize();
        syncDiskSize();
        syncProgressRadius();
        setSlidePair(0);
        markSlideStates(slides, 0, 0);
        updateCenterContent(slides, 0, 0, centerTitle, centerKicker);
        setupScrollTrigger();
        renderer.setAnimationLoop(renderLoop);
      })
      .catch(() => {
        renderer.dispose();
        section.classList.add('is-static');
      });

    const handleResize = () => {
      updateSize();
      syncDiskSize();
      syncProgressRadius();
      trigger?.refresh();
    };

    window.addEventListener('resize', handleResize);
  });
}
