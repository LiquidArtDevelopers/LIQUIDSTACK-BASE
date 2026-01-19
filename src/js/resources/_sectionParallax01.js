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

    const marginRem = parseFloat(section.dataset.stackMarginRem || '2');
    const pinnedItems = items.slice(0, -1);

    const getStartPoint = () => {
      if (section.dataset.stackStart) {
        return section.dataset.stackStart;
      }
      const nav = document.querySelector('nav');
      const navHeight = nav ? nav.getBoundingClientRect().height : 0;
      const remSize = parseFloat(getComputedStyle(document.documentElement).fontSize || '16');
      const offset = navHeight + remSize * marginRem;
      return `top top+=${Math.round(offset)}`;
    };

    items.forEach((item, index) => {
      item.style.zIndex = String(index + 1);

      gsap.set(item, { autoAlpha: 1 });
    });

    pinnedItems.forEach((item, index) => {
      const nextItem = pinnedItems[index + 1] ?? items[items.length - 1];

      gsap.to(item, {
        autoAlpha: 0,
        ease: 'none',
        scrollTrigger: {
          trigger: item,
          start: getStartPoint,
          endTrigger: nextItem,
          end: getStartPoint,
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
