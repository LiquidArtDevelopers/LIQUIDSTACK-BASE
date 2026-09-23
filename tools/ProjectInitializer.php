<?php

declare(strict_types=1);

namespace LiquidStackBase;

use Composer\Json\JsonFile;
use Composer\Script\Event;
use RuntimeException;
use Throwable;

/**
 * One-shot identity initializer for projects created from LiquidStack BASE.
 *
 * It rewrites metadata and removes BASE-only release tooling. It never creates
 * an environment file, invokes npm, connects to a database or initializes a
 * LiquidStack module.
 */
final class ProjectInitializer
{
    private const INITIALIZER_CALLBACK = self::class . '::initialize';

    /** @var list<string> */
    private const BASE_ONLY_ARTIFACTS = [
        'tools/release.php',
        'tools/test-create-project.php',
        'tests/Structure/StarterContractTest.php',
        'tests/Structure/StarterDistributionContractTest.php',
    ];

    private string $root;

    private function __construct(
        string $root,
        private readonly Event $event
    ) {
        $resolved = realpath($root);
        if ($resolved === false || !is_dir($resolved)) {
            throw new RuntimeException(
                'No se pudo resolver la raiz del proyecto creado.'
            );
        }

        $this->root = rtrim($resolved, DIRECTORY_SEPARATOR);
    }

    public static function initialize(Event $event): void
    {
        try {
            (new self(dirname(__DIR__), $event))->run();
        } catch (Throwable $exception) {
            throw new RuntimeException(
                'Inicializacion de proyecto detenida: '
                    . $exception->getMessage(),
                0,
                $exception
            );
        }
    }

    private function run(): void
    {
        $slug = $this->projectSlug(basename($this->root));
        $displayName = ucwords(str_replace('-', ' ', $slug));
        $composerName = 'liquid-art-developers/' . $slug;
        $npmName = 'liquidstack-' . $slug;

        $composerPath = $this->path('composer.json');
        $packagePath = $this->path('package.json');
        $packageLockPath = $this->path('package-lock.json');
        $composerLockPath = $this->path('composer.lock');
        $initializerPath = $this->path('tools/ProjectInitializer.php');

        $composer = $this->readJson($composerPath);
        $package = $this->readJson($packagePath);
        $packageLock = $this->readJson($packageLockPath);

        $this->assertTemplateIdentity(
            $composer,
            $package,
            $packageLock,
            $composerName,
            $npmName
        );

        $composer['name'] = $composerName;
        $composer['description'] = 'Proyecto web de ' . $displayName
            . ' sobre LiquidStack.';
        $composer['license'] = 'proprietary';
        unset($composer['homepage'], $composer['support']);

        if (!isset($composer['scripts']) || !is_array($composer['scripts'])) {
            throw new RuntimeException(
                'composer.json no contiene un bloque scripts valido.'
            );
        }
        unset(
            $composer['scripts']['release:prepare'],
            $composer['scripts']['release'],
            $composer['scripts']['test:create-project']
        );

        $composerWithInitializer = $composer;
        $composer = $this->withoutInitializer($composer);

        $package['name'] = $npmName;
        $package['private'] = true;
        $packageLock['name'] = $npmName;
        $packageLock['packages']['']['name'] = $npmName;

        $mutablePaths = [
            $composerPath,
            $packagePath,
            $packageLockPath,
            $initializerPath,
            ...array_map(
                fn (string $relative): string => $this->path($relative),
                self::BASE_ONLY_ARTIFACTS
            ),
        ];
        if (is_file($composerLockPath)) {
            $mutablePaths[] = $composerLockPath;
        }

        // This is the complete preflight: no byte is written before every
        // required artifact has been resolved, validated and snapshotted.
        foreach ($mutablePaths as $mutablePath) {
            $this->assertRegularFile($mutablePath);
        }
        $originals = $this->snapshots($mutablePaths);

        try {
            $this->writeJson($packagePath, $package);
            $this->writeJson($packageLockPath, $packageLock);
            $this->writeJson($composerPath, $composerWithInitializer);

            foreach (self::BASE_ONLY_ARTIFACTS as $relativePath) {
                $this->removeRequiredFile($this->path($relativePath));
            }

            /*
             * The callback and its classmap remain valid until all preceding
             * mutations succeed. A failure below restores every original byte,
             * including the hook and all removed BASE artifacts.
             */
            $this->writeJson($composerPath, $composer);
            if (is_file($composerLockPath)) {
                $this->event->getComposer()->getLocker()->updateHash(
                    new JsonFile($composerPath)
                );
            }
            $this->removeRequiredFile($initializerPath);
        } catch (Throwable $exception) {
            $restoreFailure = $this->restore($originals);
            $message = 'No se pudo desvincular la identidad de BASE: '
                . $exception->getMessage();
            if ($restoreFailure !== null) {
                $message .= ' La restauracion tambien fallo: ' . $restoreFailure;
            }

            throw new RuntimeException($message, 0, $exception);
        }

        $this->event->getIO()->write(
            '<info>Identidad de proyecto inicializada como '
                . $composerName . '.</info>'
        );
    }

    /**
     * @param array<string, mixed> $composer
     * @param array<string, mixed> $package
     * @param array<string, mixed> $packageLock
     */
    private function assertTemplateIdentity(
        array $composer,
        array $package,
        array $packageLock,
        string $composerName,
        string $npmName
    ): void {
        if (!in_array(
            $composer['name'] ?? null,
            ['liquidstack/base', $composerName],
            true
        )) {
            throw new RuntimeException(
                'composer.json ya pertenece a otra identidad de proyecto.'
            );
        }
        if (!in_array(
            $package['name'] ?? null,
            ['liquidstack-base', $npmName],
            true
        )) {
            throw new RuntimeException(
                'package.json ya pertenece a otra identidad de proyecto.'
            );
        }
        if (!in_array(
            $packageLock['name'] ?? null,
            ['liquidstack-base', $npmName],
            true
        ) || !isset($packageLock['packages'][''])
            || !is_array($packageLock['packages'][''])
            || !in_array(
                $packageLock['packages']['']['name'] ?? null,
                ['liquidstack-base', $npmName],
                true
            )
        ) {
            throw new RuntimeException(
                'package-lock.json no conserva la identidad raiz esperada.'
            );
        }
    }

    /**
     * @param array<string, mixed> $composer
     * @return array<string, mixed>
     */
    private function withoutInitializer(array $composer): array
    {
        $hooks = $composer['scripts']['post-create-project-cmd'] ?? [];
        if (is_string($hooks)) {
            $hooks = [$hooks];
        }
        if (!is_array($hooks)) {
            throw new RuntimeException(
                'post-create-project-cmd no tiene un formato valido.'
            );
        }

        $remaining = array_values(array_filter(
            $hooks,
            static fn (mixed $hook): bool => $hook
                !== self::INITIALIZER_CALLBACK
        ));
        if ($remaining === []) {
            unset($composer['scripts']['post-create-project-cmd']);
        } else {
            $composer['scripts']['post-create-project-cmd'] = $remaining;
        }
        unset($composer['scripts']['project:init']);

        $classmap = $composer['autoload']['classmap'] ?? [];
        if (is_string($classmap)) {
            $classmap = [$classmap];
        }
        if (!is_array($classmap)) {
            throw new RuntimeException(
                'autoload.classmap no tiene un formato valido.'
            );
        }
        $classmap = array_values(array_filter(
            $classmap,
            static fn (mixed $path): bool => $path
                !== 'tools/ProjectInitializer.php'
        ));
        if ($classmap === []) {
            unset($composer['autoload']['classmap']);
        } else {
            $composer['autoload']['classmap'] = $classmap;
        }
        if (($composer['autoload'] ?? []) === []) {
            unset($composer['autoload']);
        }

        return $composer;
    }

    private function projectSlug(string $directoryName): string
    {
        if (
            $directoryName === ''
            || preg_match('/[^\x20-\x7E]/', $directoryName) === 1
        ) {
            throw new RuntimeException(
                'La carpeta debe usar caracteres ASCII para derivar el slug.'
            );
        }

        $slug = strtolower($directoryName);
        $slug = preg_replace('/[^a-z0-9]+/', '-', $slug);
        $slug = is_string($slug) ? trim($slug, '-') : '';

        if (
            $slug === ''
            || strlen($slug) > 100
            || preg_match('/\A[a-z0-9]+(?:-[a-z0-9]+)*\z/D', $slug) !== 1
        ) {
            throw new RuntimeException(
                'El nombre de la carpeta no permite derivar un slug seguro.'
            );
        }

        return $slug;
    }

    /** @return array<string, mixed> */
    private function readJson(string $path): array
    {
        $this->assertRegularFile($path);
        $contents = file_get_contents($path);
        if ($contents === false) {
            throw new RuntimeException(
                'No se pudo leer ' . basename($path) . '.'
            );
        }

        $decoded = json_decode($contents, true, 512, JSON_THROW_ON_ERROR);
        if (!is_array($decoded)) {
            throw new RuntimeException(
                basename($path) . ' no contiene un objeto JSON.'
            );
        }

        return $decoded;
    }

    /** @param array<string, mixed> $data */
    private function writeJson(string $path, array $data): void
    {
        $contents = json_encode(
            $data,
            JSON_PRETTY_PRINT
                | JSON_UNESCAPED_SLASHES
                | JSON_UNESCAPED_UNICODE
                | JSON_THROW_ON_ERROR
        ) . "\n";
        $this->writeFile($path, $contents);
    }

    /**
     * @param list<string> $paths
     * @return array<string, string|null>
     */
    private function snapshots(array $paths): array
    {
        $snapshots = [];
        foreach ($paths as $path) {
            if (!file_exists($path)) {
                $snapshots[$path] = null;
                continue;
            }
            $this->assertRegularFile($path);
            $contents = file_get_contents($path);
            if ($contents === false) {
                throw new RuntimeException(
                    'No se pudo preparar una copia de seguridad temporal.'
                );
            }
            $snapshots[$path] = $contents;
        }

        return $snapshots;
    }

    /** @param array<string, string|null> $snapshots */
    private function restore(array $snapshots): ?string
    {
        try {
            foreach ($snapshots as $path => $contents) {
                if ($contents === null) {
                    if (file_exists($path) && !unlink($path)) {
                        throw new RuntimeException(
                            'No se pudo retirar un fichero creado parcialmente.'
                        );
                    }
                    continue;
                }
                $directory = dirname($path);
                if (!is_dir($directory)
                    && !mkdir($directory, 0777, true)
                    && !is_dir($directory)
                ) {
                    throw new RuntimeException(
                        'No se pudo recrear un directorio durante la restauracion.'
                    );
                }
                $this->writeFile($path, $contents);
            }
        } catch (Throwable $exception) {
            return $exception->getMessage();
        }

        return null;
    }

    private function removeRequiredFile(string $path): void
    {
        $this->assertRegularFile($path);
        if (!unlink($path)) {
            throw new RuntimeException(
                'No se pudo retirar ' . $this->relativePath($path) . '.'
            );
        }
    }

    private function writeFile(string $path, string $contents): void
    {
        if (is_link($path)) {
            throw new RuntimeException('Se rechazo escribir sobre un enlace.');
        }
        $written = file_put_contents($path, $contents, LOCK_EX);
        if ($written !== strlen($contents)) {
            throw new RuntimeException(
                'No se pudo escribir ' . $this->relativePath($path) . '.'
            );
        }
    }

    private function assertRegularFile(string $path): void
    {
        if (!is_file($path) || is_link($path)) {
            throw new RuntimeException(
                $this->relativePath($path) . ' no es un fichero regular.'
            );
        }
        $resolved = realpath($path);
        if (
            $resolved === false
            || !str_starts_with(
                strtolower($resolved),
                strtolower($this->root . DIRECTORY_SEPARATOR)
            )
        ) {
            throw new RuntimeException(
                'Se rechazo un fichero fuera de la raiz del proyecto.'
            );
        }
    }

    private function path(string $relativePath): string
    {
        return $this->root . DIRECTORY_SEPARATOR . str_replace(
            '/',
            DIRECTORY_SEPARATOR,
            $relativePath
        );
    }

    private function relativePath(string $path): string
    {
        return str_replace(
            '\\',
            '/',
            substr($path, strlen($this->root) + 1)
        );
    }
}
