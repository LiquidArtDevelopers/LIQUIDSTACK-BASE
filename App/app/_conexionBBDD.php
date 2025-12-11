<?php

$con = mysqli_connect($_ENV['BBDD_SERVER'], $_ENV['BBDD_USER'], $_ENV['BBDD_PASS'], $_ENV['BBDD_NAME']); //local
$con->set_charset('utf8');
