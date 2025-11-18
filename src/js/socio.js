import '../scss/socio.scss';
import "./_global.js";

// parallax 
import ScrollTrigger from 'gsap/ScrollTrigger';
import gsapParallax from "./resources/_gsapParallaxScroll.js";

import initArtSlider01 from './resources/_artSlider01.js';

const d = document
d.addEventListener("DOMContentLoaded", () => {

  initArtSlider01()

  // GSAP PARALLAX SCROLL--    
    /* ── función que cambia la imagen según ancho ────────────────── */
    function swapBG(){
        const w = innerWidth;
        document.querySelectorAll(".bg[data-bg-mobile]").forEach(el=>{
            const url =
            w < 800  ? el.dataset.bgMobile  :
            w < 1400 ? el.dataset.bgTablet  :
                        el.dataset.bgDesktop;
            el.style.setProperty("background-image", `url(${url})`, "important");
        });
    }                              

    /* --- debounce con delayedCall ----------------------------------- */
    let dc;
    const swapAndRefresh = () => {
        swapBG();
        ScrollTrigger.refresh();   // recalcula tamaños y offsets
    };

    window.addEventListener("resize", () => {
        dc && dc.kill();
        dc = gsap.delayedCall(0.15, swapAndRefresh);
    });

    /* llamada inicial */
    swapAndRefresh();

    /* ── header parallax ────────────────────────────────────────────── */
    gsapParallax({
      container: ".hero00",
      bg: ".bg",
      moveDesktop: 20,
      moveMobile : 20,
      sizeMode   : "cover"
    });    
    // FIN GSAP PARALLAX SCROLL--    

});
