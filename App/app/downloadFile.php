<?php

$file = $_GET['file'] ?? null;
$path = __DIR__ . '/../files/';

$files = scandir($path);
if ($files) {
    $files = array_filter($files, fn ($candidate) => $candidate === $file);
    $file = array_shift($files);
    if ($file) {
        header('Content-Type: application/pdf');
        header(
            'Content-disposition: attachment; filename="'
            . basename($file)
            . '"'
        );
        readfile($path . '/' . $file);
        flush();
        exit;
    }
}

header('Location: ./');
exit;
