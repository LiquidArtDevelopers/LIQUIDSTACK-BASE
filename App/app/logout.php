<?php
session_destroy();
header("Location:" . $_ENV['RAIZ'] . "/" . $lang);
exit;
