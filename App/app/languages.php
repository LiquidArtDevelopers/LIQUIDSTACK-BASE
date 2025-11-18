<?php

$lang=$_POST["lang"];
$route=$_POST["route"];

$data=file_get_contents(__DIR__."/../config/languages/$route/$lang.json");

echo $data;