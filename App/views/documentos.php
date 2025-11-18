<?php
//  Evita cache para que el navegador no guarde vistas protegidas
header("Cache-Control: no-store, no-cache, must-revalidate, max-age=0");
header("Cache-Control: post-check=0, pre-check=0", false);
header("Pragma: no-cache");
header("Expires: 0");

//  Redirección si no hay sesión
if (!isset($_SESSION["id_rol"])) {
    header("Location:" . $_ENV['RAIZ'] . "/" . $lang);
    exit;
}

require_once "../App/models/_usuarios.php";
require_once "../App/models/_admins.php";

$email = $_SESSION["email"] ?? null;
$id_usuario = $_SESSION["id_usuario"] ?? null;

$usuario = $id_usuario ? (Usuario::where("id_usuario", $id_usuario) ?? Admin::where("email", $email)) : null;
$nombre = strtolower($usuario->nombre);
$num_socio = $usuario->num_socio ?? null;

if (!$usuario) {
    header("Location: ./logout");
    exit;
}

if (!function_exists('resolveDocumentHref')) {
    function resolveDocumentHref(?string $href, string $lang): string
    {
        if (!$href) {
            return '#';
        }

        if (preg_match('/^(?:[a-z][a-z0-9+.-]*:|\/\/|\/)/i', $href)) {
            return $href;
        }

        $base = rtrim($_ENV['RAIZ'] ?? '', '/');

        return $base . '/' . $lang . '/' . ltrim($href, '/');
    }
}

?>

<!DOCTYPE html>
<html lang="<?= $lang ?>">

<head>
    <!-- Global & Variant HEAD -->
    <?php include_once __DIR__.'/../includes/_globalHead.php' ?>
</head>

<body>

    <!-- Global BODY -->
    <?php include_once __DIR__.'/../includes/_globalBody.php' ?>

    <!-- NAV -->
    <?php include __DIR__.'/../includes/_nav.php' ?>


    <div id="smooth-wrapper">
        <div id="smooth-content">            
            <main>
                <section class="sectButtons">
                    <h2 data-lang="h2_02"><?= $h2_02->text ?></h2>
                    <p data-lang="p2"><?= $p2->text ?></p>
                    <div class="modButtons">
                        <p>
                            <img src="<?= $_ENV["RAIZ"] ?>/assets/img/logos/attss-icono.svg" alt="ATSS" title="ATSS">
                            <span data-lang="norma01"><?= $norma01->text ?></span>
                        </p>
                        <a data-lang="but01" title="<?= $but01->title ?>" href="<?= resolveDocumentHref($but01->href ?? null, $lang) ?>" class="boton"><?= $but01->text ?></a>

                        <p>
                            <img src="<?= $_ENV["RAIZ"] ?>/assets/img/logos/attss-icono.svg" alt="ATSS" title="ATSS">
                            <span data-lang="norma02"><?= $norma02->text ?></span>
                        </p>
                        <a data-lang="but02" title="<?= $but02->title ?>" href="<?= resolveDocumentHref($but02->href ?? null, $lang) ?>" class="boton"><?= $but02->text ?></a>

                        <p>
                            <img src="<?= $_ENV["RAIZ"] ?>/assets/img/logos/attss-icono.svg" alt="ATSS" title="ATSS">
                            <span data-lang="norma03"><?= $norma03->text ?></span>
                        </p>
                        <a data-lang="but03" title="<?= $but03->title ?>" href="<?= resolveDocumentHref($but03->href ?? null, $lang) ?>" class="boton"><?= $but03->text ?></a>

                        <p>
                            <img src="<?= $_ENV["RAIZ"] ?>/assets/img/logos/attss-icono.svg" alt="ATSS" title="ATSS">
                            <span data-lang="norma04"><?= $norma04->text ?></span>
                        </p>
                        <a data-lang="but04" title="<?= $but04->title ?>" href="<?= resolveDocumentHref($but04->href ?? null, $lang) ?>" class="boton"><?= $but04->text ?></a>

                        <p>
                            <img src="<?= $_ENV["RAIZ"] ?>/assets/img/logos/attss-icono.svg" alt="ATSS" title="ATSS">
                            <span data-lang="norma05"><?= $norma05->text ?></span>
                        </p>
                        <a data-lang="but05" title="<?= $but05->title ?>" href="<?= resolveDocumentHref($but05->href ?? null, $lang) ?>" class="boton"><?= $but05->text ?></a>

                        <p>
                            <img src="<?= $_ENV["RAIZ"] ?>/assets/img/logos/attss-icono.svg" alt="ATSS" title="ATSS">
                            <span data-lang="norma06"><?= $norma06->text ?></span>
                        </p>
                        <a data-lang="but06" title="<?= $but06->title ?>" href="<?= resolveDocumentHref($but06->href ?? null, $lang) ?>" class="boton"><?= $but06->text ?></a>

                        <p>
                            <img src="<?= $_ENV["RAIZ"] ?>/assets/img/logos/attss-icono.svg" alt="ATSS" title="ATSS">
                            <span data-lang="norma07"><?= $norma07->text ?></span>
                        </p>
                        <a data-lang="but07" title="<?= $but07->title ?>" href="<?= resolveDocumentHref($but07->href ?? null, $lang) ?>" class="boton"><?= $but07->text ?></a>

                        <p>
                            <img src="<?= $_ENV["RAIZ"] ?>/assets/img/logos/attss-icono.svg" alt="ATSS" title="ATSS">
                            <span data-lang="norma08"><?= $norma08->text ?></span>
                        </p>
                        <a data-lang="but08" title="<?= $but08->title ?>" href="<?= resolveDocumentHref($but08->href ?? null, $lang) ?>" class="boton"><?= $but08->text ?></a>




                    </div>
                </section>
                <section class="sectTabs">
                    <h2 data-lang="h2"><?= $h2->text ?></h2>
                    <p data-lang="p1"><?= $p1->text ?></p>
                    <div class="tabs-container">
                        <div class="tabs-nav">
                            <div class="nav-item" data-nav="2025"><span>2025</span></div>
                            <div class="nav-item" data-nav="2024"><span>2024</span></div>
                            <div class="nav-item" data-nav="2023"><span>2023</span></div>
                        </div>
                        <div class="nav__line">
                            <div class="line"></div>
                        </div>
                        <div class="tab-containers">
                            <!--  -->
                            <article class="tab-container__item" data-tab="2025">
                                <div class="tab-content">
                                    <h3>2025</h3>
                                    <h4>Noviembre/Azaroa</h4>
                                    <ul>
                                        <h5>06/11/2025</h5>
                                        <li><a data-lang="nov01" title="<?= $nov01->title ?>" href="<?= resolveDocumentHref($nov01->href ?? null, $lang) ?>" class="btn-download"><?= $nov01->text?></a></li>

                                        <li><a data-lang="nov02" title="<?= $nov02->title ?>" href="<?= resolveDocumentHref($nov02->href ?? null, $lang) ?>" class="btn-download"><?= $nov02->text?></a></li>

                                        <li><a data-lang="nov03" title="<?= $nov03->title ?>" href="<?= resolveDocumentHref($nov03->href ?? null, $lang) ?>" class="btn-download"><?= $nov03->text?></a></li>

                                        <li><a data-lang="nov04" title="<?= $nov04->title ?>" href="<?= resolveDocumentHref($nov04->href ?? null, $lang) ?>" class="btn-download"><?= $nov04->text?></a></li>
                                    </ul>
                                    <h4>Octubre/Urria</h4>
                                    <ul>
                                        <h5>10/10/2025</h5>
                                        <li><a data-lang="download" title="<?= $download->title ?>" href="<?= $_ENV["RAIZ"] ?>/es/descargar?file=Convocatoria Junta Directiva-Zuzendaritza batzordearen deialdia 14-10-25.pdf" class="btn-download">Convocatoria Junta Directiva - Zuzendaritza batzordearen deialdia 14-10-25</a></li>
                                    </ul>
                                    <h4>Agosto/Abuztua</h4>
                                    <ul>
                                        <h5>28/08/2025</h5>
                                        <li><a data-lang="download" title="<?= $download->title ?>" href="<?= $_ENV["RAIZ"] ?>/es/descargar?file=Convocatoria Junta Directiva-Zuzendaritza Batzordearen deialdia 28-08-25.pdf" class="btn-download">Convocatoria Junta Directiva - Zuzendaritza Batzordearen deialdia 28-08-2025</a></li>
                                    </ul>

                                    <h4>Junio/Ekaina</h4>
                                    <ul>
                                        <h5>02/06/2025</h5>
                                        <li><a data-lang="download" title="<?= $download->title ?>" href="<?= $_ENV["RAIZ"] ?>/es/descargar?file=TARIFAS 2025.pdf" class="btn-download">Tarifas 2025eko Tarifak</a></li>

                                    </ul>


                                    <h4>Mayo/Maiatza</h4>
                                    <ul>
                                        <h5>15/05/2025</h5>
                                        <li><a data-lang="download" title="<?= $download->title ?>" href="<?= $_ENV["RAIZ"] ?>/es/descargar?file=Convocatoria Asamblea ordinaria 2 junio 2025-Batzar Orokorraren deialdia 2025eko ekainaren 2a.pdf" class="btn-download">Convocatoria Asamblea ordinaria 2 junio 2025-Batzar Orokorraren deialdia 2025eko ekainaren 2a</a></li>

                                        <li><a data-lang="download" title="<?= $download->title ?>" href="<?= $_ENV["RAIZ"] ?>/es/descargar?file=Acta Asamblea General Ordinaria 17.09.24. Ohizko Batzar Orokorraren akta.pdf" class="btn-download">Acta Asamblea General Ordinaria 17.09.24.-Ohizko Batzar Orokorraren akta</a></li>

                                        <li><a data-lang="download" title="<?= $download->title ?>" href="<?= $_ENV["RAIZ"] ?>/es/descargar?file=Cuentas Anuales 2024.pdf" class="btn-download">Cuentas Anuales 2024-2024KO URTEKO KONTUAK</a></li>

                                        <li><a data-lang="download" title="<?= $download->title ?>" href="<?= $_ENV["RAIZ"] ?>/es/descargar?file=PROYECTO PRESUPUESTO 2025.pdf" class="btn-download">PROYECTO PRESUPUESTO 2025-2025EKO AURREKONTUAREN AURREPROIEKTUA</a></li>

                                        <li><a data-lang="download" title="<?= $download->title ?>" href="<?= $_ENV["RAIZ"] ?>/es/descargar?file=TARIFAS.pdf" class="btn-download">TARIFAS-TARIFAK</a></li>

                                        <li><a data-lang="download" title="<?= $download->title ?>" href="<?= $_ENV["RAIZ"] ?>/es/descargar?file=REGLAMENTO DE REGIMEN INTERNO DE LA ZONA SOCIAL DEL CLUB ATLETICO SAN SEBASTIAN 14 05 25.pdf" class="btn-download">REGLAMENTO DE REGIMEN INTERNO DE LA ZONA SOCIAL DEL CLUB ATLETICO SAN SEBASTIAN 14 05 25<br>CLUB ATLÉTICO SAN SEBASTIÁN-EN GIZARTE-GUNERAKO BARNE ARAUDIA — 2025-05-14</a></li>
                                    </ul>
                                    <ul>
                                        <h5>05/05/2025</h5>
                                        <li><a data-lang="download" title="<?= $download->title ?>" href="<?= $_ENV["RAIZ"] ?>/es/descargar?file=convocatoria-Junta-Directiva-5-mayo-2025-Zuzendaritza-Batzordearen-deialdia-1.pdf" class="btn-download">Convocatoria-Junta-Directiva-5-mayo-2025-Zuzendaritza-Batzordearen-deialdia-1.pdf</a></li>
                                    </ul>
                                    <h4>Febrero/Otsaila</h4>
                                    <ul>
                                        <h5>12/02/2025</h5>
                                        <li><a data-lang="download" title="<?= $download->title ?>" href="<?= $_ENV["RAIZ"] ?>/es/descargar?file=Convocatoria-Junta-Directiva-12-de-Febrero-Zuzendaritza-Batzordearen-deialdia-Otsailaren-12an.pdf" class="btn-download">Convocatoria-Junta-Directiva-12-de-Febrero-Zuzendaritza-Batzordearen-deialdia-Otsailaren-12an.pdf</a></li>
                                    </ul>
                                </div>
                            </article>
                            <article class="tab-container__item" data-tab="2024">
                                <div class="tab-content">
                                    <h3>2024</h3>

                                    <h4>Diciembre / Abendua</h4>
                                    <ul>
                                        <h5>16/12/2024</h5>
                                        <li><a data-lang="download" title="<?= $download->title ?>" href="<?= $_ENV["RAIZ"] ?>/es/descargar?file=Presentacion-Junta-Directiva-Zuzendaritza-Batzordearen-aurkezpena.pdf" class="btn-download">Presentacion-Junta-Directiva-Zuzendaritza-Batzordearen-aurkezpena.pdf</a></li>
                                        <h5>05/12/2024</h5>
                                        <li><a data-lang="download" title="<?= $download->title ?>" href="<?= $_ENV["RAIZ"] ?>/es/descargar?file=convocatoria-Junta-Directiva-saliente-de-11-diciembre-2024.pdf" class="btn-download">convocatoria-Junta-Directiva-saliente-de-11-diciembre-2024.pdf</a></li>
                                        <li><a data-lang="download" title="<?= $download->title ?>" href="<?= $_ENV["RAIZ"] ?>/es/descargar?file=convocatoria-Junta-Directiva-entrante-de-11-diciembre-2024.pdf" class="btn-download">convocatoria-Junta-Directiva-entrante-de-11-diciembre-2024.pdf</a></li>
                                    </ul>

                                    <h4>Noviembre / Azaroa</h4>
                                    <ul>
                                        <h5>15/11/2024</h5>
                                        <li><a data-lang="download" title="<?= $download->title ?>" href="<?= $_ENV["RAIZ"] ?>/es/descargar?file=PROCLAMACION-DEFINITIVA-CANDIDATURA-PRESIDENCIA-Y-JUNTA-DIRECTIVA-ASS.-FIN-DEL-PROCESO-ELECTORAL.pdf" class="btn-download">PROCLAMACION-DEFINITIVA-CANDIDATURA-PRESIDENCIA-Y-JUNTA-DIRECTIVA-ASS.-FIN-DEL-PROCESO-ELECTORAL.pdf</a></li>
                                    </ul>

                                    <h4>Octubre / Urria</h4>
                                    <ul>
                                        <h5>30/10/2024</h5>
                                        <li><a data-lang="download" title="<?= $download->title ?>" href="<?= $_ENV["RAIZ"] ?>/es/descargar?file=CANDIDATURA-JAVIER-MENDIBURU.pdf" class="btn-download">CANDIDATURA-JAVIER-MENDIBURU.pdf</a></li>
                                        <li><a data-lang="download" title="<?= $download->title ?>" href="<?= $_ENV["RAIZ"] ?>/es/descargar?file=CANDIDATURA-JUAN-CARLOS-BENAVIDES.pdf" class="btn-download">CANDIDATURA-JUAN-CARLOS-BENAVIDES.pdf</a></li>
                                        <li><a data-lang="download" title="<?= $download->title ?>" href="<?= $_ENV["RAIZ"] ?>/es/descargar?file=PROCLAMACION-PROVISIONAL-CANDIDATURAS-PRESIDENCIA-Y-JUNTA-DIRECTIVA-ASS.pdf" class="btn-download">PROCLAMACION-PROVISIONAL-CANDIDATURAS-PRESIDENCIA-Y-JUNTA-DIRECTIVA-ASS.pdf</a></li>
                                        <h5>04/10/2024</h5>
                                        <li><a data-lang="download" title="<?= $download->title ?>" href="<?= $_ENV["RAIZ"] ?>/es/descargar?file=Comunicado-a-los-Socios-as-del-Club-Atletico-de-San-Sebastian-Jakinarazpena-Atletico-San-Sebastian-Klubeko-bazkideei.pdf" class="btn-download">Comunicado-a-los-Socios-as-del-Club-Atletico-de-San-Sebastian-Jakinarazpena-Atletico-San-Sebastian-Klubeko-bazkideei.pdf</a></li>
                                        <li><a data-lang="download" title="<?= $download->title ?>" href="<?= $_ENV["RAIZ"] ?>/es/descargar?file=convocatoria-Junta-Directiva-de-9-octubre-2024.-2024ko-urriaren-9ko-Zuzendaritza-Batzordearen-deialdia.pdf" class="btn-download">convocatoria-Junta-Directiva-de-9-octubre-2024.-2024ko-urriaren-9ko-Zuzendaritza-Batzordearen-deialdia.pdf</a></li>
                                    </ul>

                                    <h4>Agosto / Abustua</h4>
                                    <ul>
                                        <h5>27/08/2024</h5>
                                        <li><a data-lang="download" title="<?= $download->title ?>" href="<?= $_ENV["RAIZ"] ?>/es/descargar?file=27-08-2024-CONVOCATORIA-ASAMBLEA-GENERAL-ORDINARIA-17-DE-SEPTIEMBRE-EUS-CAST.pdf" class="btn-download">27-08-2024-CONVOCATORIA-ASAMBLEA-GENERAL-ORDINARIA-17-DE-SEPTIEMBRE-EUS-CAST.pdf</a></li>
                                        <h5>15/02/2024</h5>
                                        <li><a data-lang="download" title="<?= $download->title ?>" href="<?= $_ENV["RAIZ"] ?>/es/descargar?file=ACTA-ASAMBLEA-EXTRAORDINARIA-15-de-ferebro-2024.pdf" class="btn-download">ACTA-ASAMBLEA-EXTRAORDINARIA-15-de-ferebro-2024.pdf</a></li>
                                        <h5>--</h5>
                                        <li><a data-lang="download" title="<?= $download->title ?>" href="<?= $_ENV["RAIZ"] ?>/es/descargar?file=CUENTAS-ANUALES-2023.pdf" class="btn-download">CUENTAS-ANUALES-2023.pdf</a></li>
                                        <li><a data-lang="download" title="<?= $download->title ?>" href="<?= $_ENV["RAIZ"] ?>/es/descargar?file=PROYECTO-PRESUPUESTO-2024.pdf" class="btn-download">PROYECTO-PRESUPUESTO-2024.pdf</a></li>
                                        <li><a data-lang="download" title="<?= $download->title ?>" href="<?= $_ENV["RAIZ"] ?>/es/descargar?file=TARIFAS-10-24-Junta-30.05.24.pdf" class="btn-download">TARIFAS-10-24-Junta-30.05.24.pdf</a></li>
                                        <li><a data-lang="download" title="<?= $download->title ?>" href="<?= $_ENV["RAIZ"] ?>/es/descargar?file=COMPOSICION-JUNTA-ELECTORAL-TERCERAS-ELECCIONES-EUS-CAST.pdf" class="btn-download">COMPOSICION-JUNTA-ELECTORAL-TERCERAS-ELECCIONES-EUS-CAST.pdf</a></li>
                                        <li><a data-lang="download" title="<?= $download->title ?>" href="<?= $_ENV["RAIZ"] ?>/es/descargar?file=CALENDARIO-ELECTORAL-BILINGUE-septiembre-diciembre-2024.pdf" class="btn-download">CALENDARIO-ELECTORAL-BILINGUE-septiembre-diciembre-2024.pdf</a></li>
                                    </ul>

                                    <h4>Julio / Uztaila</h4>
                                    <ul>
                                        <h5>08/07/2024</h5>
                                        <li><a data-lang="download" title="<?= $download->title ?>" href="<?= $_ENV["RAIZ"] ?>/es/descargar?file=Convocatoria-Junta-Directiva-11-de-Julio.pdf" class="btn-download">Convocatoria-Junta-Directiva-11-de-Julio.pdf</a></li>
                                    </ul>

                                    <h4>Junio / Ekaina</h4>
                                    <ul>
                                        <h5>--</h5>
                                        <li><a data-lang="download" title="<?= $download->title ?>" href="<?= $_ENV["RAIZ"] ?>/es/descargar?file=CCAA-ATSS-2023.pdf" class="btn-download">CUENTAS ANUALES ATSS 2023 Aprobadas por la Junta Directiva y pendientes de aprobación por la Asamblea General.</a></li>
                                    </ul>

                                    <h4>Mayo / Maiatza</h4>
                                    <ul>
                                        <h5>30/05/2024</h5>
                                        <li><a data-lang="download" title="<?= $download->title ?>" href="<?= $_ENV["RAIZ"] ?>/es/descargar?file=Convocatoria-Junta-Directiva-Zuzedaritza-Batzordea-deialdia-30.05.24-1.pdf" class="btn-download">Convocatoria-Junta-Directiva-Zuzedaritza-Batzordea-deialdia-30.05.24-1.pdf</a></li>
                                    </ul>

                                    <h4>Abril / Apirila</h4>
                                    <ul>
                                        <h5>--</h5>
                                        <li><a data-lang="download" title="<?= $download->title ?>" href="<?= $_ENV["RAIZ"] ?>/es/descargar?file=COMUNICADO-JUNTA-ELECTORAL.pdf" class="btn-download">COMUNICADO-JUNTA-ELECTORAL.pdf</a></li>
                                    </ul>

                                    <h4>Marzo / Martxoa</h4>
                                    <ul>
                                        <h5>20/03/2024</h5>
                                        <li><a data-lang="download" title="<?= $download->title ?>" href="<?= $_ENV["RAIZ"] ?>/es/descargar?file=Convocatoria-Junta-Directiva-20-de-marzo-2024.pdf" class="btn-download">Convocatoria-Junta-Directiva-20-de-marzo-2024.pdf</a></li>
                                    </ul>

                                    <h4>Enero / Urtarrila</h4>
                                    <ul>
                                        <h5>11/01/2024</h5>
                                        <li><a data-lang="download" title="<?= $download->title ?>" href="<?= $_ENV["RAIZ"] ?>/es/descargar?file=CONVOCATORIA-DE-JUNTA-DIRECTIVA-DEL-11-DE-ENERO-DE-2024.pdf" class="btn-download">CONVOCATORIA-DE-JUNTA-DIRECTIVA-DEL-11-DE-ENERO-DE-2024.pdf</a></li>
                                    </ul>


                                </div>
                            </article>
                            <article class="tab-container__item" data-tab="2023">
                                <div class="tab-content">

                                    <h3>2023</h3>

                                    <h4>Diciembre / Abendua</h4>
                                    <ul>
                                        <h5>20/12/2023</h5>
                                        <li><a data-lang="download" title="<?= $download->title ?>" href="<?= $_ENV["RAIZ"] ?>/es/descargar?file=Acta-de-Asamblea-ORDINARIA-29-JUN-2023-1.pdf" class="btn-download">Acta-de-Asamblea-ORDINARIA-29-JUN-2023-1.pdf</a></li>
                                        <li><a data-lang="download" title="<?= $download->title ?>" href="<?= $_ENV["RAIZ"] ?>/es/descargar?file=CONVOCATORIA-ASAMBLEA-EXTRAORDINARIA-DEL-15-FEBRERO-DE-2024.pdf" class="btn-download">CONVOCATORIA-ASAMBLEA-EXTRAORDINARIA-DEL-15-FEBRERO-DE-2024.pdf</a></li>
                                        <li><a data-lang="download" title="<?= $download->title ?>" href="<?= $_ENV["RAIZ"] ?>/es/descargar?file=NORMATIVA-PROCESO-ELECTORAL-2024-CLUB-ATSS.pdf" class="btn-download">NORMATIVA-PROCESO-ELECTORAL-2024-CLUB-ATSS.pdf</a></li>
                                        <li><a data-lang="download" title="<?= $download->title ?>" href="<?= $_ENV["RAIZ"] ?>/es/descargar?file=MODELO-CANDIDATURA-2024.pdf" class="btn-download">MODELO-CANDIDATURA-2024.pdf</a></li>
                                        <li><a data-lang="download" title="<?= $download->title ?>" href="<?= $_ENV["RAIZ"] ?>/es/descargar?file=COMPOSICION-DE-LA-JUNTA-ELECTORAL.pdf" class="btn-download">COMPOSICION-DE-LA-JUNTA-ELECTORAL.pdf</a></li>
                                        <li><a data-lang="download" title="<?= $download->title ?>" href="<?= $_ENV["RAIZ"] ?>/es/descargar?file=CALENDARIO-ELECTORAL-2024.pdf" class="btn-download">CALENDARIO-ELECTORAL-2024.pdf</a></li>
                                    </ul>
                                    <ul>
                                        <h5>11/12/2023</h5>
                                        <li><a data-lang="download" title="<?= $download->title ?>" href="<?= $_ENV["RAIZ"] ?>/es/descargar?file=convocatoria-Junta-Directiva-de-15-diciciembre-2023.pdf" class="btn-download">convocatoria-Junta-Directiva-de-15-diciciembre-2023.pdf</a></li>
                                    </ul>

                                    <h4>Agosto / Abustua</h4>
                                    <ul>
                                        <h5>24/08/2023</h5>
                                        <li><a data-lang="download" title="<?= $download->title ?>" href="<?= $_ENV["RAIZ"] ?>/es/descargar?file=Convocatoria-Junta-Directiva-24-de-agosto-de-2023-1.pdf" class="btn-download">Convocatoria-Junta-Directiva-24-de-agosto-de-2023-1.pdf</a></li>
                                        <h5>04/08/2023</h5>
                                        <li><a data-lang="download" title="<?= $download->title ?>" href="<?= $_ENV["RAIZ"] ?>/es/descargar?file=ACTA-JUNTA-ELECTORAL-1.pdf" class="btn-download">ACTA-JUNTA-ELECTORAL-1.pdf</a></li>
                                    </ul>

                                    <h4>Junio / Ekaina</h4>
                                    <ul>
                                        <h5>12/06/2023</h5>
                                        <li><a data-lang="download" title="<?= $download->title ?>" href="<?= $_ENV["RAIZ"] ?>/es/descargar?file=Convocatoria-Asamblea-Ordinaria-29-junio-2023.pdf" class="btn-download">Convocatoria-Asamblea-Ordinaria-29-junio-2023.pdf</a></li>
                                        <li><a data-lang="download" title="<?= $download->title ?>" href="<?= $_ENV["RAIZ"] ?>/es/descargar?file=Cuenatas-Anuales-2022.pdf" class="btn-download">Cuenatas-Anuales-2022.pdf</a></li>
                                        <li><a data-lang="download" title="<?= $download->title ?>" href="<?= $_ENV["RAIZ"] ?>/es/descargar?file=Proyecto-Presupuesto-2023.pdf" class="btn-download">Proyecto-Presupuesto-2023.pdf</a></li>
                                        <li><a data-lang="download" title="<?= $download->title ?>" href="<?= $_ENV["RAIZ"] ?>/es/descargar?file=Nuevas-tarifas-2023.pdf" class="btn-download">Nuevas-tarifas-2023.pdf</a></li>
                                        <li><a data-lang="download" title="<?= $download->title ?>" href="<?= $_ENV["RAIZ"] ?>/es/descargar?file=Acta-de-Asamblea-ORDINARIA-28-MAR-2022.pdf" class="btn-download">Acta-de-Asamblea-ORDINARIA-28-MAR-2022.pdf</a></li>
                                        <li><a data-lang="download" title="<?= $download->title ?>" href="<?= $_ENV["RAIZ"] ?>/es/descargar?file=Calendario-electoral-2023.pdf" class="btn-download">Calendario-electoral-2023.pdf</a></li>
                                    </ul>

                                    <h4>Mayo / Maiatza</h4>
                                    <ul>
                                        <h5>15/05/2023</h5>
                                        <li><a data-lang="download" title="<?= $download->title ?>" href="<?= $_ENV["RAIZ"] ?>/es/descargar?file=15-05-2023-CONVOCATORIA-JUNTA-DIRECTIVA-18-05-2023.pdf" class="btn-download">15-05-2023-CONVOCATORIA-JUNTA-DIRECTIVA-18-05-2023.pdf</a></li>
                                    </ul>

                                    <h4>Abril / Apirila</h4>
                                    <ul>
                                        <h5>17/04/2023</h5>
                                        <li><a data-lang="download" title="<?= $download->title ?>" href="<?= $_ENV["RAIZ"] ?>/es/descargar?file=Convocatoria-junta-directiva-20-abril-2023.pdf" class="btn-download">Convocatoria-junta-directiva-20-abril-2023.pdf</a></li>
                                    </ul>

                                    <h4>Septiembre / Iraila</h4>
                                    <ul>
                                        <h5>30/09/2022</h5>
                                        <li><a data-lang="download" title="<?= $download->title ?>" href="<?= $_ENV["RAIZ"] ?>/es/descargar?file=convocatoria-junta-directiva-6-octubre-2022.pdf" class="btn-download">convocatoria-junta-directiva-6-octubre-2022.pdf</a></li>
                                    </ul>



                                </div>
                            </article>
                        </div>
                    </div>
                </section>
                <section class="visual">
                </section>
            </main>
            <!-- como el footer no es fixed, lo meto también dentro del smoother -->
            <?php include __DIR__.'/../includes/_footer.php' ?>
        </div>
    </div>


</body>

</html>