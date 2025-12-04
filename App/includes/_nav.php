
<input type="checkbox" name="toggle" id="toggle">
<nav>
    <div>
        <label for="toggle" id="toggleLabel" class="no_select" aria-label="Abrir menú">
            <span></span>
            <span></span>
            <span></span>
        </label>        
        <a class="no_select logoPrimary" data-lang="aImgNav" href="<?= homeUrl($GLOBALS['lang']) ?>" title="<?=$_ENV['VITE_BUSINESS_NAME']?>">
            <img src="<?= $_ENV['RAIZ'] ?>/assets/img/logos/logo-black.svg" alt="<?=$_ENV['VITE_BUSINESS_NAME']?>" title="<?=$_ENV['VITE_BUSINESS_NAME']?>">
        </a>
        <div class="idiomas">            
            <ul>                
                <li><a data-lang="" title="Euskera" id="eu" class="btn_idioma no_select" hreflang="eu" href="<?= $_ENV['RAIZ'] ?><?= getMatchRouteByLang($url, "eu") ?>">EU</a></li>                
                <li><a data-lang="" title="Español" id="es" class="btn_idioma no_select" hreflang="es" href="<?= $_ENV['RAIZ'] ?><?= getMatchRouteByLang($url, "es") ?>">ES</a></li>
            </ul>
        </div>
            
    </div>
    <?php
    // Global megamenu rendered via controller
    echo controller('navMegamenu01', 0);
    ?>
</nav>
