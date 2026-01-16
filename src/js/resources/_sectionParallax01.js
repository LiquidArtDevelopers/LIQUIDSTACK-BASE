import gsap from 'gsap';
import ScrollTrigger from 'gsap/ScrollTrigger';

export default function initSectionParallax01() {
  gsap.registerPlugin(ScrollTrigger);

  const sections = Array.from(document.querySelectorAll('.sectionParallax01'));
  if (sections.length === 0) {
    return;
  }

  sections.forEach((section) => {
    const items = Array.from(section.querySelectorAll('[data-parallax-item]'));
    if (items.length === 0) {
      return;
    }

    const prefersReduced = window.matchMedia('(prefers-reduced-motion: reduce)').matches;
    if (prefersReduced) {
      gsap.set(items, { clearProps: 'transform,opacity' });
      return;
    }

    const pinDistance = parseFloat(section.dataset.stackDistance || '100');
    const startPoint = section.dataset.stackStart || 'top top';
    const basePadding = parseFloat(getComputedStyle(section).paddingBottom || '0');

    const updateSectionSpacing = () => {
      section.style.paddingBottom = `${basePadding}px`;
      const baseHeight = section.scrollHeight;
      const pinLength = window.innerHeight * (pinDistance / 100);
      const needed = pinLength * items.length;
      const extra = Math.max(0, needed - baseHeight);
      section.style.paddingBottom = `${basePadding + extra}px`;
    };

    updateSectionSpacing();
    ScrollTrigger.addEventListener('refreshInit', updateSectionSpacing);

    items.forEach((item, index) => {
      item.style.zIndex = String(index + 1);

      gsap.set(item, { autoAlpha: 1 });

      gsap.to(item, {
        autoAlpha: 0,
        ease: 'none',
        scrollTrigger: {
          trigger: item,
          start: startPoint,
          end: () => `+=${window.innerHeight * (pinDistance / 100)}`,
          scrub: true,
          pin: true,
          pinSpacing: false,
          pinType: 'transform',
          anticipatePin: 1,
          invalidateOnRefresh: true,
        },
      });
    });
  });
}
