import '../scss/documentos.scss';
import "./_global.js";
import initSectTabs01 from './resources/_sectTabs01.js'


document.addEventListener("DOMContentLoaded", () => {
  
  initSectTabs01()

  const btnsDownload = document.querySelectorAll(".btn-download");
  btnsDownload.forEach((btnDownload) => {
    btnDownload.addEventListener("click", async (e) => {
      e.preventDefault();
      const url = e.target.href;
      const response = await fetch(url);
      const blob = await response.blob();
      const fileURL = URL.createObjectURL(blob);
      window.open(fileURL, "_blank"); // Abrir en una nueva pestaña
    });
  });
});

window.addEventListener("pageshow", function (event) {
  if (event.persisted || window.performance.getEntriesByType("navigation")[0].type === "back_forward") {
    // Esto viene del historial, forzar recarga desde el servidor
    window.location.reload();
  }
});
