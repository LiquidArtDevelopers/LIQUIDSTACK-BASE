<?php

declare(strict_types=1);

/**
 * End-to-end smoke test for the distributable LiquidStack BASE package.
 *
 * It installs BASE through Composer's create-project flow (from a local
 * archive, the canonical VCS repository or Packagist), resolves fresh PHP
 * dependencies and runs CORE's synchronizer twice. It deliberately never
 * creates .env, invokes npm or touches migration/onboarding commands. The
 * real post-create identity hook does run and is part of this contract.
 */

final class CreateProjectProbe
{
    /** @var list<string> */
    private const COMMERCE_PROJECT_TARGETS = [
        'App/app/_moduleCommercePublic.php',
        'App/app/commerce/CommercePresentationAdapter.php',
        'App/config/languages/commerce/en.json',
        'App/config/languages/commerce/es.json',
        'App/config/languages/commerce/eu.json',
        'App/config/modules/commerce.php',
        'App/controllers/_moduleCommerceResources.php',
        'App/controllers/artCommerceItem01.php',
        'App/controllers/sectionCommerceCatalog01.php',
        'App/controllers/sectionCommerceInquiry01.php',
        'App/templates/_artCommerceItem01.html',
        'App/templates/_sectionCommerceCatalog01.html',
        'App/templates/_sectionCommerceInquiry01.html',
        'App/views/commerce.php',
        'App/views/commerce-inquiry.php',
        'App/views/commerce-item.php',
        'src/js/commerce.js',
        'src/js/commerceInquiry.js',
        'src/js/commerceItem.js',
        'src/js/resources/_commerce.js',
        'src/scss/commerce.scss',
        'src/scss/commerceInquiry.scss',
        'src/scss/commerceItem.scss',
        'src/scss/resources/_artCommerceItem01.scss',
        'src/scss/resources/_sectionCommerceCatalog01.scss',
        'src/scss/resources/_sectionCommerceInquiry01.scss',
    ];

    private string $root;
    private string $temporaryRoot;
    private string $workspace;

    /** @var list<string> */
    private array $composerCommand;

    public function __construct(
        string $root,
        private readonly string $sourceMode = 'archive',
        private readonly ?string $version = null,
        private readonly ?string $repositoryUrl = null
    ) {
        $resolvedRoot = realpath($root);
        if ($resolvedRoot === false) {
            throw new RuntimeException('No se pudo resolver la raíz de BASE.');
        }

        $this->root = $resolvedRoot;
        $this->temporaryRoot = rtrim(
            (string) realpath(sys_get_temp_dir()),
            DIRECTORY_SEPARATOR
        );
        if ($this->temporaryRoot === '') {
            throw new RuntimeException('No se pudo resolver el directorio temporal.');
        }

        $this->workspace = $this->temporaryRoot . DIRECTORY_SEPARATOR
            . 'liquidstack-base-create-project-'
            . bin2hex(random_bytes(8));
        $this->composerCommand = $this->resolveComposerCommand();
        if (!in_array($this->sourceMode, ['archive', 'vcs', 'packagist'], true)) {
            throw new InvalidArgumentException(
                'El origen E2E debe ser archive, vcs o packagist.'
            );
        }
        if ($this->sourceMode === 'vcs' && $this->repositoryUrl === null) {
            throw new InvalidArgumentException(
                'El modo vcs requiere --repository=https://...'
            );
        }
    }

    public function run(): void
    {
        $artifactDirectory = $this->workspace . '/artifacts';
        $sourceDirectory = $this->workspace . '/source';
        $projectDirectory = $this->workspace . '/client-project';

        $this->makeDirectory($this->workspace);
        $createArguments = [
            'create-project',
            'liquidstack/base',
            $projectDirectory,
        ];
        if ($this->version !== null) {
            $createArguments[] = $this->version;
        }

        if ($this->sourceMode === 'archive') {
            $this->makeDirectory($artifactDirectory);
            $previousRootVersion = getenv('COMPOSER_ROOT_VERSION');
            putenv('COMPOSER_ROOT_VERSION=1.0.0');
            try {
                $this->runComposer([
                    'archive',
                    '--format=zip',
                    '--dir=' . $artifactDirectory,
                    '--file=liquidstack-base-e2e',
                    '--no-interaction',
                    '--no-ansi',
                ], $this->root);
            } finally {
                if ($previousRootVersion === false) {
                    putenv('COMPOSER_ROOT_VERSION');
                } else {
                    putenv('COMPOSER_ROOT_VERSION=' . $previousRootVersion);
                }
            }

            $archives = glob($artifactDirectory . '/*.zip') ?: [];
            $this->assert(
                count($archives) === 1,
                'El archive debe producir un único ZIP.'
            );
            $this->inspectAndExtractArchive($archives[0], $sourceDirectory);
            $repository = json_encode([
                'type' => 'path',
                'url' => str_replace('\\', '/', $sourceDirectory),
                'options' => ['symlink' => false],
            ], JSON_THROW_ON_ERROR | JSON_UNESCAPED_SLASHES);
            $createArguments[] = '--repository=' . $repository;
            $createArguments[] = '--stability=dev';
        } elseif ($this->sourceMode === 'vcs') {
            $repository = json_encode([
                'type' => 'vcs',
                'url' => $this->repositoryUrl,
            ], JSON_THROW_ON_ERROR | JSON_UNESCAPED_SLASHES);
            $createArguments[] = '--repository=' . $repository;
            $createArguments[] = '--prefer-dist';
            $createArguments[] = '--remove-vcs';
        } else {
            $createArguments[] = '--prefer-dist';
            $createArguments[] = '--remove-vcs';
        }
        $recoveryArguments = $createArguments;
        array_push(
            $createArguments,
            '--no-interaction',
            '--no-ansi'
        );

        $this->runComposer($createArguments, $this->workspace);

        $this->assertInitializedIdentity($projectDirectory, 'client-project');
        $protected = $this->protectedHashes($projectDirectory);

        $this->runComposer([
            'validate',
            '--strict',
            '--no-check-publish',
            '--no-check-all',
            '--no-interaction',
            '--no-ansi',
        ], $projectDirectory);

        $this->assert(
            is_file($projectDirectory . '/composer.lock'),
            'create-project no generó el lock propio del nuevo proyecto.'
        );
        $composerLockHash = hash_file(
            'sha256',
            $projectDirectory . '/composer.lock'
        );
        if ($composerLockHash === false) {
            throw new RuntimeException(
                'No se pudo resumir el composer.lock generado.'
            );
        }
        $protected['composer.lock'] = $composerLockHash;

        if ($this->sourceMode === 'archive') {
            $this->assertRecoveryFlow($recoveryArguments);
        }

        $this->assert(is_dir($projectDirectory . '/vendor/liquidstack/core'),
            'composer install no instaló liquidstack/core.');
        $this->assert(is_file(
            $projectDirectory . '/.liquidstack/core/managed-files.json'
        ), 'CORE no dejó su estado de sincronización gestionada.');
        $this->assert(is_file(
            $projectDirectory . '/App/tools/liquidstack-dev.mjs'
        ), 'CORE no instalo el supervisor local gestionado.');
        $this->assert(
            !file_exists($projectDirectory . '/storage'),
            'composer install no debe inicializar storage privado.'
        );
        $this->assertProtectedState($projectDirectory, $protected);

        $projectOwnedShell = $projectDirectory . '/App/views/blog.php';
        $projectOwnedContents = file_get_contents($projectOwnedShell);
        if ($projectOwnedContents === false) {
            throw new RuntimeException(
                'No se pudo preparar la prueba project-owned del Blog.'
            );
        }
        $projectOwnedContents .= "\n<!-- E2E project-owned customization -->\n";
        if (file_put_contents($projectOwnedShell, $projectOwnedContents) === false) {
            throw new RuntimeException(
                'No se pudo escribir la personalización temporal del Blog.'
            );
        }

        $this->applyReviewedSync($projectDirectory);
        $this->assert(
            file_get_contents($projectOwnedShell) === $projectOwnedContents,
            'CORE sobrescribió el shell project-owned del Blog.'
        );
        $firstSync = $this->treeFingerprint($projectDirectory);

        $this->applyReviewedSync($projectDirectory);
        $secondSync = $this->treeFingerprint($projectDirectory);
        $this->assert(
            hash_equals($firstSync, $secondSync),
            'La segunda sincronización de CORE no fue idempotente.'
        );
        $this->assert(
            file_get_contents($projectOwnedShell) === $projectOwnedContents,
            'CORE no preservó el shell project-owned en la segunda sincronización.'
        );
        $this->assertProtectedState($projectDirectory, $protected);

        $this->runComposer(['test', '--no-interaction', '--no-ansi'], $projectDirectory);
        $this->assertProtectedState($projectDirectory, $protected);

        fwrite(
            STDOUT,
            "E2E create-project correcto ({$this->sourceMode}): origen "
                . "saneado, install seguro, ownership preservado y "
                . "sincronización idempotente.\n"
        );
    }

    public function cleanup(): void
    {
        if (!isset($this->workspace) || !is_dir($this->workspace)) {
            return;
        }

        $prefix = $this->temporaryRoot . DIRECTORY_SEPARATOR
            . 'liquidstack-base-create-project-';
        $resolvedWorkspace = realpath($this->workspace);
        if ($resolvedWorkspace === false
            || !str_starts_with($resolvedWorkspace, $prefix)
            || dirname($resolvedWorkspace) !== $this->temporaryRoot
        ) {
            throw new RuntimeException(
                'Se rechazó limpiar un directorio temporal no reconocido.'
            );
        }

        $iterator = new RecursiveIteratorIterator(
            new RecursiveDirectoryIterator(
                $resolvedWorkspace,
                FilesystemIterator::SKIP_DOTS
            ),
            RecursiveIteratorIterator::CHILD_FIRST
        );
        foreach ($iterator as $item) {
            $path = $item->getPathname();
            if ($item->isLink() || $item->isFile()) {
                if (!unlink($path)) {
                    throw new RuntimeException("No se pudo borrar {$path}.");
                }
                continue;
            }
            if (!rmdir($path)) {
                throw new RuntimeException("No se pudo borrar {$path}.");
            }
        }
        if (!rmdir($resolvedWorkspace)) {
            throw new RuntimeException(
                "No se pudo borrar el workspace {$resolvedWorkspace}."
            );
        }
    }

    /** @return list<string> */
    private function resolveComposerCommand(): array
    {
        $binary = getenv('COMPOSER_BINARY');
        if ($binary === false || trim($binary) === '') {
            throw new RuntimeException(
                'Ejecuta esta prueba mediante composer test:create-project.'
            );
        }

        if (str_ends_with(strtolower($binary), '.phar')) {
            return [PHP_BINARY, $binary];
        }

        return [$binary];
    }

    private function applyReviewedSync(string $projectDirectory): void
    {
        $rawPlan = $this->runComposer([
            'liquidstack:sync',
            '--dry-run',
            '--format=json',
            '--no-interaction',
            '--no-ansi',
        ], $projectDirectory, false);
        $plan = json_decode(trim($rawPlan), true, 512, JSON_THROW_ON_ERROR);
        $planHash = $plan['plan_hash'] ?? null;
        $this->assert(
            ($plan['ok'] ?? false) === true
                && ($plan['status'] ?? null) === 'ready'
                && is_string($planHash)
                && preg_match('/^sha256:[a-f0-9]{64}$/D', $planHash) === 1,
            'liquidstack:sync no produjo un plan aplicable.'
        );

        $rawApply = $this->runComposer([
            'liquidstack:sync',
            '--apply',
            '--plan-hash=' . $planHash,
            '--yes',
            '--format=json',
            '--no-interaction',
            '--no-ansi',
        ], $projectDirectory, false);
        $applied = json_decode(trim($rawApply), true, 512, JSON_THROW_ON_ERROR);
        $this->assert(
            ($applied['ok'] ?? false) === true
                && ($applied['status'] ?? null) === 'applied'
                && (($applied['stats']['errors'] ?? null) === 0),
            'liquidstack:sync no aplico el plan revisado limpiamente.'
        );
    }

    /** @param list<string> $arguments */
    private function runComposer(
        array $arguments,
        string $workingDirectory,
        bool $showOutput = true
    ): string
    {
        $command = [...$this->composerCommand, ...$arguments];
        fwrite(STDOUT, '> composer ' . implode(' ', array_map(
            static fn (string $argument): string => escapeshellarg($argument),
            $arguments
        )) . "\n");

        $stdout = tmpfile();
        $stderr = tmpfile();
        if ($stdout === false || $stderr === false) {
            throw new RuntimeException(
                'No se pudieron preparar las salidas temporales de Composer.'
            );
        }

        $process = proc_open(
            $command,
            [
                0 => ['pipe', 'r'],
                1 => $stdout,
                2 => $stderr,
            ],
            $pipes,
            $workingDirectory,
            null,
            ['bypass_shell' => true]
        );
        if (!is_resource($process)) {
            throw new RuntimeException('No se pudo iniciar Composer.');
        }
        fclose($pipes[0]);
        $exitCode = proc_close($process);
        rewind($stdout);
        rewind($stderr);
        $standardOutput = stream_get_contents($stdout);
        $standardError = stream_get_contents($stderr);
        fclose($stdout);
        fclose($stderr);
        if (($showOutput || $exitCode !== 0)
            && is_string($standardOutput)
            && $standardOutput !== ''
        ) {
            fwrite(STDOUT, $standardOutput);
        }
        if (($showOutput || $exitCode !== 0)
            && is_string($standardError)
            && $standardError !== ''
        ) {
            fwrite(STDERR, $standardError);
        }
        if ($exitCode !== 0) {
            throw new RuntimeException(
                "Composer terminó con código {$exitCode}."
            );
        }

        return is_string($standardOutput) ? $standardOutput : '';
    }

    private function inspectAndExtractArchive(
        string $archive,
        string $sourceDirectory
    ): void {
        if (!class_exists(ZipArchive::class)) {
            throw new RuntimeException('La prueba E2E necesita ext-zip.');
        }

        $zip = new ZipArchive();
        if ($zip->open($archive) !== true) {
            throw new RuntimeException('No se pudo abrir el archive generado.');
        }

        $entries = [];
        for ($index = 0; $index < $zip->numFiles; $index++) {
            $name = str_replace('\\', '/', (string) $zip->getNameIndex($index));
            $entries[$name] = true;
        }

        foreach ([
            '.env',
            '.npmrc',
            'auth.json',
            'composer.lock',
            '.phpunit.result.cache',
            'App/bootstrap.php',
        ] as $forbiddenFile) {
            $this->assert(
                !isset($entries[$forbiddenFile]),
                "El archive contiene {$forbiddenFile}."
            );
        }
        foreach ([
            '.git/',
            '.codex/tmp/',
            '.liquidstack/core/sync-transactions/',
            'vendor/',
            'node_modules/',
            'App/tools/',
            'storage/',
            'public/.vite/',
            'public/assets/css/',
            'public/assets/js/',
            'public/assets/video/customer/',
        ] as $forbiddenPrefix) {
            foreach (array_keys($entries) as $entry) {
                $this->assert(
                    !str_starts_with($entry, $forbiddenPrefix),
                    "El archive contiene el prefijo {$forbiddenPrefix}."
                );
            }
        }
        foreach ([
            'composer.json',
            'package.json',
            'package-lock.json',
            '.env.example',
            '.npmrc.example',
            'CHANGELOG.md',
            'example_liquidstack_dev.sql',
            'tools/ProjectInitializer.php',
            'tools/ReleaseScript.php',
            'tools/release.php',
            'tools/test-create-project.php',
            'tools/demo-blog-media-manifest.php',
            'tools/install-demo-blog-media.php',
            'tests/Structure/StarterContractTest.php',
            'tests/Structure/StarterDistributionContractTest.php',
        ] as $requiredFile) {
            $this->assert(
                isset($entries[$requiredFile]),
                "El archive no contiene {$requiredFile}."
            );
        }

        $this->makeDirectory($sourceDirectory);
        if (!$zip->extractTo($sourceDirectory)) {
            $zip->close();
            throw new RuntimeException('No se pudo extraer el archive generado.');
        }
        $zip->close();
    }

    /** @param list<string> $createArguments */
    private function assertRecoveryFlow(array $createArguments): void
    {
        $projectDirectory = $this->workspace . '/recovery-project';
        $createArguments[2] = $projectDirectory;
        array_push(
            $createArguments,
            '--no-install',
            '--no-scripts',
            '--no-interaction',
            '--no-ansi'
        );

        $this->runComposer($createArguments, $this->workspace);

        $composer = $this->readJsonFile(
            $projectDirectory . '/composer.json'
        );
        $this->assert(
            ($composer['name'] ?? null) === 'liquidstack/base',
            'El modo recovery debe conservar BASE hasta ejecutar project:init.'
        );
        foreach ([
            'tools/ProjectInitializer.php',
            'tools/ReleaseScript.php',
            'tools/release.php',
            'tools/test-create-project.php',
            'tests/Structure/StarterContractTest.php',
            'tests/Structure/StarterDistributionContractTest.php',
        ] as $baseArtifact) {
            $this->assert(
                is_file($projectDirectory . '/' . $baseArtifact),
                "El recovery perdió antes de tiempo {$baseArtifact}."
            );
        }
        foreach ([
            'composer.lock',
            'vendor',
            '.env',
            '.npmrc',
            'node_modules',
        ] as $absent) {
            $this->assert(
                !file_exists($projectDirectory . '/' . $absent),
                "create-project --no-install/--no-scripts generó {$absent}."
            );
        }

        $this->runComposer([
            'install',
            '--no-scripts',
            '--no-interaction',
            '--no-progress',
            '--no-ansi',
        ], $projectDirectory);
        $this->runComposer([
            'project:init',
            '--no-interaction',
            '--no-ansi',
        ], $projectDirectory);
        $this->runComposer([
            'validate',
            '--strict',
            '--no-check-publish',
            '--no-check-all',
            '--no-interaction',
            '--no-ansi',
        ], $projectDirectory);

        $this->assertInitializedIdentity(
            $projectDirectory,
            'recovery-project'
        );
        $this->assert(
            is_file($projectDirectory . '/composer.lock'),
            'El recovery no conservó el lock generado antes de project:init.'
        );
    }

    private function assertInitializedIdentity(
        string $projectDirectory,
        string $slug
    ): void
    {
        foreach ([
            '.git',
            '.env',
            '.npmrc',
            'auth.json',
            'node_modules',
            'storage',
            'tools/ProjectInitializer.php',
            'tools/ReleaseScript.php',
            'tools/release.php',
            'tools/test-create-project.php',
            'tests/Structure/StarterContractTest.php',
            'tests/Structure/StarterDistributionContractTest.php',
        ] as $forbidden) {
            $this->assert(
                !file_exists($projectDirectory . '/' . $forbidden),
                "create-project generó {$forbidden} antes del bootstrap manual."
            );
        }
        $requiredFiles = array_merge([
            'composer.json',
            'package.json',
            'package-lock.json',
            '.env.example',
            '.npmrc.example',
            'example_liquidstack_dev.sql',
            'tools/demo-blog-media-manifest.php',
            'tools/install-demo-blog-media.php',
        ], self::COMMERCE_PROJECT_TARGETS);
        $this->assert(
            count(self::COMMERCE_PROJECT_TARGETS) === 26,
            'El contrato Commerce debe enumerar sus 26 destinos canónicos.'
        );
        foreach ($requiredFiles as $required) {
            $this->assert(
                is_file($projectDirectory . '/' . $required),
                "create-project no copió {$required}."
            );
        }

        $composer = $this->readJsonFile(
            $projectDirectory . '/composer.json'
        );
        $package = $this->readJsonFile(
            $projectDirectory . '/package.json'
        );
        $packageLock = $this->readJsonFile(
            $projectDirectory . '/package-lock.json'
        );
        $this->assert(
            ($composer['require']['liquidstack/commerce'] ?? null) === '*',
            'create-project no conservó el selector lógico Commerce.'
        );
        $environmentLines = preg_split(
            '/\R/',
            (string) file_get_contents($projectDirectory . '/.env.example')
        );
        $this->assert(
            is_array($environmentLines),
            'No se pudo inspeccionar el contrato de entorno distribuido.'
        );
        foreach ($environmentLines as $index => $line) {
            if (preg_match('/^([A-Z][A-Z0-9_]*)=/', $line, $match) !== 1) {
                continue;
            }
            $comment = $environmentLines[$index - 1] ?? '';
            $this->assert(
                str_starts_with($comment, '# Función:')
                    && str_contains($comment, 'Ejemplo:'),
                ".env.example no documenta {$match[1]} en el proyecto creado."
            );
        }

        $this->assert(
            ($composer['name'] ?? null)
                === 'liquid-art-developers/' . $slug,
            'El hook no derivó la identidad Composer desde la carpeta destino.'
        );
        $displayName = ucwords(str_replace('-', ' ', $slug));
        $this->assert(
            ($composer['description'] ?? null)
                === "Proyecto web de {$displayName} sobre LiquidStack.",
            'El hook no declaró la descripción del proyecto cliente.'
        );
        $this->assert(
            ($composer['license'] ?? null) === 'proprietary',
            'El proyecto cliente no conserva la licencia propietaria.'
        );
        $this->assert(
            !array_key_exists('homepage', $composer)
                && !array_key_exists('support', $composer),
            'El proyecto cliente conserva URLs de soporte de BASE.'
        );
        foreach ([
            'post-create-project-cmd',
            'project:init',
            'release:prepare',
            'release',
            'test:create-project',
        ] as $baseScript) {
            $this->assert(
                !array_key_exists($baseScript, $composer['scripts'] ?? []),
                "El proyecto cliente conserva el script BASE {$baseScript}."
            );
        }
        $this->assert(
            ($composer['scripts']['liquidstack:demo-blog-media:install'] ?? null)
                === ['@php tools/install-demo-blog-media.php'],
            'El proyecto cliente no conserva el instalador Media demo.'
        );
        $this->assert(
            !isset($composer['autoload']['classmap'])
                || !in_array(
                    'tools/ProjectInitializer.php',
                    $composer['autoload']['classmap'],
                    true
                ),
            'El proyecto cliente conserva el classmap del inicializador.'
        );
        $this->assert(
            ($package['name'] ?? null) === 'liquidstack-' . $slug
                && ($package['private'] ?? null) === true,
            'package.json no quedó identificado como proyecto privado.'
        );
        $this->assert(
            ($packageLock['name'] ?? null) === 'liquidstack-' . $slug
                && ($packageLock['packages']['']['name'] ?? null)
                    === 'liquidstack-' . $slug,
            'package-lock.json no sincronizó su identidad raíz.'
        );
    }

    /** @return array<string, mixed> */
    private function readJsonFile(string $path): array
    {
        $decoded = json_decode(
            (string) file_get_contents($path),
            true,
            512,
            JSON_THROW_ON_ERROR
        );
        if (!is_array($decoded)) {
            throw new RuntimeException(
                basename($path) . ' no contiene un objeto JSON.'
            );
        }

        return $decoded;
    }

    /** @return array<string, string> */
    private function protectedHashes(string $projectDirectory): array
    {
        $hashes = [];
        foreach ([
            'composer.json',
            'package.json',
            'package-lock.json',
            '.env.example',
            '.npmrc.example',
            'example_liquidstack_dev.sql',
        ] as $relativePath) {
            $hash = hash_file('sha256', $projectDirectory . '/' . $relativePath);
            if ($hash === false) {
                throw new RuntimeException("No se pudo resumir {$relativePath}.");
            }
            $hashes[$relativePath] = $hash;
        }

        return $hashes;
    }

    /** @param array<string, string> $expected */
    private function assertProtectedState(
        string $projectDirectory,
        array $expected
    ): void {
        $this->assert(!file_exists($projectDirectory . '/.env'),
            'Composer no debe crear .env.');
        $this->assert(!file_exists($projectDirectory . '/.npmrc'),
            'Composer no debe crear .npmrc.');
        $this->assert(!file_exists($projectDirectory . '/node_modules'),
            'Composer no debe ejecutar npm.');

        foreach ($expected as $relativePath => $expectedHash) {
            $actualHash = hash_file(
                'sha256',
                $projectDirectory . '/' . $relativePath
            );
            $this->assert(
                is_string($actualHash) && hash_equals($expectedHash, $actualHash),
                "Composer modificó {$relativePath}."
            );
        }

        $iterator = new RecursiveIteratorIterator(
            new RecursiveDirectoryIterator(
                $projectDirectory,
                FilesystemIterator::SKIP_DOTS
            )
        );
        foreach ($iterator as $item) {
            if ($item->isFile()
                && in_array(strtolower($item->getExtension()), ['db', 'sqlite'], true)
                && !str_contains(
                    str_replace('\\', '/', $item->getPathname()),
                    '/vendor/'
                )
            ) {
                throw new RuntimeException(
                    'Apareció un fichero de base de datos durante el install: '
                        . $item->getPathname()
                );
            }
        }
    }

    private function treeFingerprint(string $projectDirectory): string
    {
        $entries = [];
        $iterator = new RecursiveIteratorIterator(
            new RecursiveDirectoryIterator(
                $projectDirectory,
                FilesystemIterator::SKIP_DOTS
            )
        );
        foreach ($iterator as $item) {
            if (!$item->isFile()) {
                continue;
            }
            $relative = str_replace(
                '\\',
                '/',
                substr($item->getPathname(), strlen($projectDirectory) + 1)
            );
            if (str_starts_with($relative, 'vendor/')
                || $relative === '.phpunit.result.cache'
            ) {
                continue;
            }
            $hash = hash_file('sha256', $item->getPathname());
            if ($hash === false) {
                throw new RuntimeException("No se pudo resumir {$relative}.");
            }
            $entries[$relative] = $hash;
        }
        ksort($entries, SORT_STRING);

        return hash('sha256', json_encode($entries, JSON_THROW_ON_ERROR));
    }

    private function makeDirectory(string $path): void
    {
        if (!is_dir($path) && !mkdir($path, 0777, true) && !is_dir($path)) {
            throw new RuntimeException("No se pudo crear {$path}.");
        }
    }

    private function assert(bool $condition, string $message): void
    {
        if (!$condition) {
            throw new RuntimeException($message);
        }
    }
}

$sourceMode = 'archive';
$requestedVersion = null;
$repositoryUrl = null;
foreach (array_slice($argv, 1) as $argument) {
    if ($argument === '--') {
        continue;
    }
    if (str_starts_with($argument, '--source=')) {
        $sourceMode = substr($argument, strlen('--source='));
    } elseif (str_starts_with($argument, '--version=')) {
        $requestedVersion = substr($argument, strlen('--version='));
    } elseif (str_starts_with($argument, '--repository=')) {
        $repositoryUrl = substr($argument, strlen('--repository='));
    } else {
        fwrite(STDERR, "Argumento E2E desconocido: {$argument}\n");
        exit(1);
    }
}
if ($requestedVersion === null && $sourceMode === 'archive') {
    $requestedVersion = 'dev-main';
}
if ($sourceMode === 'vcs' && $repositoryUrl === null) {
    $repositoryUrl =
        'https://github.com/LiquidArtDevelopers/LIQUIDSTACK-BASE.git';
}

$probe = null;
$exitCode = 0;
try {
    $probe = new CreateProjectProbe(
        dirname(__DIR__),
        $sourceMode,
        $requestedVersion,
        $repositoryUrl
    );
    $probe->run();
} catch (Throwable $exception) {
    fwrite(STDERR, 'E2E create-project falló: ' . $exception->getMessage() . "\n");
    $exitCode = 1;
} finally {
    if ($probe instanceof CreateProjectProbe) {
        try {
            $probe->cleanup();
        } catch (Throwable $cleanupException) {
            fwrite(
                STDERR,
                'No se pudo limpiar el workspace E2E: '
                    . $cleanupException->getMessage()
                    . "\n"
            );
            $exitCode = 1;
        }
    }
}

exit($exitCode);
