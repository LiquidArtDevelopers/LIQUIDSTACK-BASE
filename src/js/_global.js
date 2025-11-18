import traduccionClass from "./resources/_traducciones.js";
import initDownloadFiles from './resources/_downloadFiles.js';
import initNavMegamenu01 from './resources/_navMegamenu01.js';

import "./resources/_toggle.js";
import "./resources/_terminos.js";

import "./resources/_gsapScroll.js";
import "./resources/_createCursorRippleEffect.js";
import "./resources/_createCursorTraking.js";
import initInlineEditor from "./resources/_inlineEditor.js";




const d = document;
d.addEventListener("DOMContentLoaded", () => {
  const traduccion = traduccionClass.getInstance();
  traduccion.colorearIdioma();
  initDownloadFiles()
  initNavMegamenu01()
  initInlineEditor();
});
