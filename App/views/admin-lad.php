<?php
//Si el rol de la sessión no es dev rederigimos a la página de inicio
if (!isset($_SESSION["id_rol"]) || $_SESSION["id_rol"] !=  ROLES::ADMIN->value) {
    header("Location: ./");
}
?>

<!DOCTYPE html>
<html lang="<?= $lang ?>">

<!-- TRADUCIR TODAS LAS VISTAS Y VARIABILIZARLAS (TODAS MENOS 404 QUE YA ESTÁ) -->

<head>
    <!-- Global & Variant HEAD -->
    <?php include_once __DIR__.'/../includes/_globalHead.php'?>
</head>

<body>

    <!-- Global BODY -->
    <?php include_once __DIR__.'/../includes/_globalBody.php'?>
    
    <?php include __DIR__.'/../includes/_nav.php' ?>


    <div id="smooth-wrapper">
        <div id="smooth-content">
            <header class="header01">
            </header>
            <main>
                <section>
                    <h2>Formularios de gestión</h2>
                    <article class="art03">
                        <h3>Inserción de turnos</h3>
                        <p>Meter los datos como string, en formato ejemplo: 10 de enero en el caso de fecha, y 10h en caso de hora (formato 24h)</p>
                        <div>
                            <div>
                                <form id="formTurnos" method="post">
                                    <h4>Crear nuevos turnos genéricos (fecha y horarios de inicio y fin)</h4>
                                    <input type="text" name="fecha" placeholder="Fecha ejemplo: 10 de enero, o 10/01/25" required>
                                    <input type="text" name="horaini" placeholder="Hora de inicio, ejemplo: 10h o 10:00" required>
                                    <input type="text" name="horafin" placeholder="Hora final, ejemplo: 16h o 16:00" required>
                                    <input type="submit" value="Guardar" id="submitTurnos" class="boton">
                                </form>
                            </div>
                            <div>
                                <table>
                                    <thead>
                                        <tr>
                                            <td>id_turno</td>
                                            <td>fecha</td>
                                            <td>hora_ini</td>
                                            <td>hora_fin</td>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <!-- Contenido dinámico -->
                                        <?php
                                        include "./php/app/_conexionBBDD.php";
                                        $sql = "SELECT * FROM `hyegb7_turnos` ORDER BY `fecha`, `hora_ini` asc";
                                        $resultado = mysqli_query($con, $sql);
                                        if (mysqli_num_rows($resultado) > 0) {
                                            while ($fila = mysqli_fetch_array($resultado)) {
                                        ?>
                                                <tr>
                                                    <td><?= $fila["id_turno"] ?></td>
                                                    <td><?= $fila["fecha"] ?></td>
                                                    <td><?= $fila["hora_ini"] ?></td>
                                                    <td><?= $fila["hora_fin"] ?></td>
                                                </tr>
                                        <?php
                                            }
                                        }
                                        unset($sql, $resultado, $fila);
                                        mysqli_close($con);
                                        ?>
                                        <!-- fin contenido dinámico -->
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </article>
                    <article class="art03">
                        <h3>Asignación de turnos a distribuidores y activación</h3>
                        <p>Seleccionamos el distribuidor y el turno que le queremos asignar</p>
                        <div>
                            <div>
                                <form id="formdistribuidoresTurnos" method="post">
                                    <h4>Asignación de turnos a distribuidores</h4>
                                    <select name="selectdistribuidoresTurnos">
                                        <option value="nulo"></option>
                                        <?php
                                        // Contenido dinámico: listado de localidades en el select
                                        include "./php/app/_conexionBBDD.php";
                                        $sql = "SELECT * FROM `hyegb7_distribuidores` ORDER BY `id_distribuidor` asc";
                                        $resultado = mysqli_query($con, $sql);
                                        if (mysqli_num_rows($resultado) > 0) {
                                            while ($fila = mysqli_fetch_array($resultado)) {
                                        ?>
                                                <option data-activa="<?= $fila["activa"] ?>" value="<?= $fila["id_distribuidor"] ?>"><?= $fila["nombre_comercial"] ?></option>
                                        <?php
                                            }
                                        }
                                        unset($sql, $resultado, $fila);
                                        mysqli_close($con);
                                        ?>
                                    </select>
                                    <select name="selectTurnos" id="">
                                        <?php
                                        // Contenido dinámico: listado de localidades en el select
                                        include "./php/app/_conexionBBDD.php";
                                        $sql = "SELECT * FROM `hyegb7_turnos` ORDER BY `fecha`, `hora_ini` asc";
                                        $resultado = mysqli_query($con, $sql);
                                        if (mysqli_num_rows($resultado) > 0) {
                                            while ($fila = mysqli_fetch_array($resultado)) {
                                        ?>
                                                <option value="<?= $fila["id_turno"] ?>"><?= $fila["fecha"] ?> (de <?= $fila["hora_ini"] ?> a <?= $fila["hora_fin"] ?>)</option>
                                        <?php
                                            }
                                        }
                                        unset($sql, $resultado, $fila);
                                        mysqli_close($con);
                                        ?>
                                    </select>

                                    <input type="submit" value="Guardar" id="submitdistribuidoresTurnos" class="boton" style="pointer-events: none;opacity:0.2;">
                                </form>

                                <form id="formdistribuidoresActivas" method="post">
                                    <h4>Activar o desactivar distribuidores</h4>
                                    <select name="selectDistribuidoraActivas">
                                        <option value="nulo"></option>
                                        <?php
                                        // Contenido dinámico: listado de localidades en el select
                                        include "./php/app/_conexionBBDD.php";
                                        $sql = "SELECT * FROM `hyegb7_distribuidores` ORDER BY `id_distribuidor` asc";
                                        $resultado = mysqli_query($con, $sql);
                                        if (mysqli_num_rows($resultado) > 0) {
                                            while ($fila = mysqli_fetch_array($resultado)) {
                                        ?>
                                                <option data-activa="<?= $fila["activa"] ?>" value="<?= $fila["id_distribuidor"] ?>"><?= $fila["nombre_comercial"] ?></option>
                                        <?php
                                            }
                                        }
                                        unset($sql, $resultado, $fila);
                                        mysqli_close($con);
                                        ?>
                                    </select>
                                    <p for="checkboxdistribuidoresActivas">Activar distribuidor si tiene evento</p>
                                    <input type="checkbox" name="checkboxdistribuidoresActivas" id="checkboxdistribuidoresActivas" value="">
                                    <input type="submit" value="Guardar" id="submitdistribuidoresActivas" class="boton" style="pointer-events: none;opacity:0.2;">
                                </form>

                                <a href="" class="boton">DESCARGAR TARIFAS</a>
                            </div>
                            <div>
                                <table>
                                    <thead>
                                        <tr>
                                            <td>id_distribuidor_turno</td>
                                            <td>distribuidor</td>
                                            <td>Activa</td>
                                            <td>Fecha</td>
                                            <td>hora_ini</td>
                                            <td>hora_fin</td>
                                        </tr>
                                    </thead>
                                    <tbody>
                                        <!-- Contenido dinámico -->
                                        <?php
                                        include "./php/app/_conexionBBDD.php";
                                        $sql = "SELECT * FROM `hyegb7_distribuidores_turnos`
                                            INNER JOIN `hyegb7_turnos`, `hyegb7_distribuidores` 
                                            WHERE hyegb7_distribuidores_turnos.id_distribuidor=hyegb7_distribuidores.id_distribuidor 
                                            AND hyegb7_distribuidores_turnos.id_turno=hyegb7_turnos.id_turno 
                                            ORDER BY hyegb7_distribuidores.id_distribuidor, `fecha`, `hora_ini` asc";

                                        $resultado = mysqli_query($con, $sql);
                                        if (mysqli_num_rows($resultado) > 0) {
                                            while ($fila = mysqli_fetch_array($resultado)) {
                                                if ($fila["activa"] == 1) {
                                                    $activa = "Activa";
                                                    $colorActiva = "color:green;";
                                                } else {
                                                    $activa = "No";
                                                    $colorActiva = "color:red;";
                                                }
                                        ?>
                                                <tr>
                                                    <td><?= $fila["id_distribuidor_turno"] ?></td>
                                                    <td><?= $fila["nombre_comercial"] ?></td>
                                                    <td style="<?= $colorActiva ?>"><?= $activa ?></td>
                                                    <td><?= $fila["fecha"] ?></td>
                                                    <td><?= $fila["hora_ini"] ?></td>
                                                    <td><?= $fila["hora_fin"] ?></td>
                                                </tr>
                                        <?php
                                            }
                                        }
                                        unset($sql, $resultado, $fila);
                                        mysqli_close($con);
                                        ?>
                                        <!-- fin contenido dinámico -->
                                    </tbody>
                                </table>
                            </div>
                        </div>
                    </article>
                </section>
                <!--    <section>
                    <h2>Genererar descarga de tarifas</h2>
                    <div>
                        <label>
                            Ingresa los id de distribuidores separado por comas: &nbsp;
                            <input type="text" id="text_generete" style="border:1px solid #000">
                        </label>
                        <button style="color:green;text-align:center;padding:10px;" id="btn_generate">Generate</button>
                        <br><br>
                        <a id="download" style="color:green;text-align:center;width: 100%;display:block;visibility:hidden;">Descargar</a>
                        <script>
                            const $text_generete = document.getElementById("text_generete")
                            btn_generate.addEventListener("click", async () => {
                                const $number_ids = $text_generete.value.split(",").map(num => num.trim());
                                if ($number_ids.some(id => isNaN(Number(id)))) {
                                    alert("Los ids solo pueden ser formato númerico")
                                    return
                                }
                                download.style.visibility = "hidden"
                                const newURL = await fetch(`./generete_url.php?ids=[${$number_ids.join(",")}]`).then(resp => resp.text())
                                download.href = newURL
                                download.style.visibility = "visible"
                            })
                        </script>
                    </div>
                </section> -->
            </main>

            <?php include_once __DIR__.'/../includes/_footer.php' ?>
        </div>
    </div>


</body>

</html>