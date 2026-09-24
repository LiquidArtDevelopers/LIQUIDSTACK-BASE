<?php

declare(strict_types=1);

use App\Core\Environment\ProjectEnvironmentLoader;
use App\Core\WebAdmin\Media\MediaException;
use App\Core\WebAdmin\Media\MediaStoredVariant;
use App\Core\WebAdmin\Media\PrivateMediaStorage;

$projectRoot = dirname(__DIR__);
$autoload = $projectRoot . '/vendor/autoload.php';
if (!is_file($autoload)) {
    fwrite(STDERR, "Instalacion demo detenida: ejecuta composer install.\n");
    exit(1);
}
require $autoload;

/** @var array<string, array{source: string,variants: list<array{file: string,width: int,height: int,bytes: int,sha256: string}>}> $manifest */
$manifest = require __DIR__ . '/demo-blog-media-manifest.php';
$sourceRoot = $projectRoot . '/public/assets/img/dummy/responsive';

try {
    foreach ($manifest as $publicId => $asset) {
        foreach ($asset['variants'] as $variant) {
            $source = $sourceRoot . '/' . $variant['file'];
            if (!is_file($source) || is_link($source) || !is_readable($source)) {
                throw new RuntimeException('Falta un AVIF demo versionado.');
            }
            $bytes = filesize($source);
            $sha256 = hash_file('sha256', $source);
            if ($bytes !== $variant['bytes'] || !is_string($sha256)
                || !hash_equals($variant['sha256'], $sha256)) {
                throw new RuntimeException('Un AVIF demo no coincide con su manifiesto.');
            }
        }
    }

    $environment = (new ProjectEnvironmentLoader())->load($projectRoot);
    if (!$environment->isUsable()) {
        throw new RuntimeException('El .env del proyecto no es utilizable.');
    }
    $storage = PrivateMediaStorage::forProject(
        $projectRoot,
        $environment->values()
    );
    $diagnostic = $storage->diagnostic();
    if (($diagnostic['ready'] ?? false) !== true) {
        throw new RuntimeException(
            'Inicializa antes Media con composer liquidstack:media:init --yes --format=json.'
        );
    }

    $pending = [];
    foreach ($manifest as $publicId => $asset) {
        $available = 0;
        $missing = 0;
        foreach ($asset['variants'] as $variant) {
            $stored = new MediaStoredVariant(
                $storage->storageKey($publicId, $variant['width']),
                $variant['width'],
                $variant['height'],
                $variant['bytes'],
                $variant['sha256']
            );
            try {
                $storage->probeVerified($stored);
                ++$available;
            } catch (MediaException $exception) {
                if ($exception->issueCode() !== 'webadmin.media.file_unavailable') {
                    throw $exception;
                }
                ++$missing;
            }
        }
        if ($available === count($asset['variants'])) {
            continue;
        }
        if ($missing !== count($asset['variants'])) {
            throw new RuntimeException(
                'El storage contiene un asset demo parcial; no se sobrescribio.'
            );
        }
        $pending[$publicId] = $asset;
    }

    foreach ($pending as $publicId => $asset) {
        $staging = $storage->createStagingDirectory();
        $promoted = false;
        try {
            foreach ($asset['variants'] as $variant) {
                $source = $sourceRoot . '/' . $variant['file'];
                $target = $staging . DIRECTORY_SEPARATOR
                    . $variant['width'] . '.avif';
                if (!copy($source, $target) || is_link($target)) {
                    throw new RuntimeException('No se pudo preparar un AVIF demo.');
                }
                $bytes = filesize($target);
                $sha256 = hash_file('sha256', $target);
                if ($bytes !== $variant['bytes'] || !is_string($sha256)
                    || !hash_equals($variant['sha256'], $sha256)) {
                    throw new RuntimeException('Fallo la verificacion del staging demo.');
                }
            }
            $storage->promote($staging, $publicId);
            $promoted = true;
        } finally {
            if (!$promoted && is_dir($staging)) {
                $storage->removeStaging($staging);
            }
        }
    }

    fwrite(
        STDOUT,
        $pending === []
            ? "Los 4 assets demo de Blog ya estaban instalados.\n"
            : 'Assets demo de Blog instalados: ' . count($pending) . ".\n"
    );
    exit(0);
} catch (MediaException $exception) {
    fwrite(
        STDERR,
        'Instalacion demo detenida: ' . $exception->issueCode() . ".\n"
    );
    exit(1);
} catch (Throwable $exception) {
    fwrite(STDERR, 'Instalacion demo detenida: ' . $exception->getMessage() . "\n");
    exit(1);
}
