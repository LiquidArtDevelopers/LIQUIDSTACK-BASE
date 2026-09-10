<?php

declare(strict_types=1);

/**
 * Release gate for LiquidStack BASE.
 *
 * A BASE tag is a version of the project template for future projects. It is
 * never an update channel for projects that were already created from BASE.
 */
final class BaseReleaseGate
{
    private string $root;

    /** @var list<string> */
    private array $composerCommand;

    /** @var list<string> */
    private array $npmCommand;

    public function __construct(string $root)
    {
        $resolved = realpath($root);
        if ($resolved === false) {
            throw new RuntimeException('No se pudo resolver la raíz de BASE.');
        }
        $this->root = $resolved;
        $this->composerCommand = $this->resolveComposerCommand();
        $this->npmCommand = $this->resolveNpmCommand();
    }

    public function run(
        string $version,
        bool $dryRun,
        bool $confirmed
    ): void
    {
        if (!preg_match(
            '/^v(0|[1-9]\d*)\.(0|[1-9]\d*)\.(0|[1-9]\d*)$/D',
            $version
        )) {
            throw new InvalidArgumentException(
                'La versión debe tener formato estable vMAJOR.MINOR.PATCH.'
            );
        }

        if (!$dryRun && !$confirmed) {
            throw new InvalidArgumentException(
                'Publicar requiere confirmacion explicita mediante --yes.'
            );
        }

        $this->assertReleaseMetadata($version);
        $this->assertGitPreflight($version);
        $releaseBranch = trim($this->capture([
            'git', 'branch', '--show-current',
        ]));
        $releaseCommit = trim($this->capture([
            'git', 'rev-parse', '--verify', 'HEAD^{commit}',
        ]));
        $this->execute(['git', 'diff', '--check'], 'git diff --check');
        $this->execute(
            ['git', 'diff', '--cached', '--check'],
            'git diff --cached --check'
        );

        $lockHashes = $this->hashes(['composer.lock', 'package-lock.json']);
        $validationWorkspace = null;
        $failure = null;
        try {
            $this->runComposer([
                'validate', '--strict', '--no-check-publish',
                '--no-interaction', '--no-ansi',
            ]);
            $this->runComposer([
                'audit', '--locked', '--no-interaction', '--no-ansi',
            ]);
            $this->runComposer(['test', '--no-interaction', '--no-ansi']);
            $this->runComposer([
                'test:create-project', '--no-interaction', '--no-ansi',
            ]);
            [$validationWorkspace, $validationProject] =
                $this->createValidationProject($releaseCommit);
            $this->runComposer([
                'install', '--no-interaction', '--no-progress', '--no-ansi',
            ], $validationProject);
            $this->prepareNpmAuthentication($validationProject);
            $this->runNpm(['ci', '--ignore-scripts'], $validationProject);
            $this->runNpm(['audit'], $validationProject);
            $this->runNpm(['run', 'build'], $validationProject);
            if (!is_file(
                $validationProject . '/public/.vite/manifest.json'
            )) {
                throw new RuntimeException(
                    'El build aislado no genero public/.vite/manifest.json.'
                );
            }
        } catch (Throwable $exception) {
            $failure = $exception;
        } finally {
            if (is_string($validationWorkspace)) {
                try {
                    $this->removeValidationWorkspace($validationWorkspace);
                } catch (Throwable $cleanupException) {
                    $failure ??= $cleanupException;
                }
            }
        }

        if ($failure instanceof Throwable) {
            throw $failure;
        }

        $this->assertHashes($lockHashes);
        $this->assertNoCompiledManifest();
        $this->assertCleanWorkingTree();
        $this->assertGitIdentity($releaseBranch, $releaseCommit);
        $this->execute(
            ['git', 'fetch', '--prune', '--tags', 'origin'],
            'git fetch final de origin'
        );
        $this->assertGitIdentity($releaseBranch, $releaseCommit);
        $this->assertTagAvailable($version);

        if ($dryRun) {
            fwrite(
                STDOUT,
                "Dry-run correcto: BASE {$version} está preparado; no se creó "
                    . "ninguna etiqueta ni se publicó nada.\n"
            );
            return;
        }

        $tagCreated = false;
        try {
            $this->execute([
                'git', 'tag', '-a', $version, '-m',
                "LiquidStack BASE {$version}", $releaseCommit,
            ], 'git tag -a ' . $version);
            $tagCreated = true;
            $this->execute([
                'git', 'push', '--atomic', 'origin',
                $releaseCommit . ':refs/heads/main',
                'refs/tags/' . $version,
            ], 'git push --atomic origin main ' . $version);
        } catch (Throwable $exception) {
            if ($tagCreated) {
                try {
                    $this->execute(
                        ['git', 'tag', '-d', $version],
                        'git tag -d ' . $version,
                        false
                    );
                } catch (Throwable) {
                    fwrite(
                        STDERR,
                        "Aviso: no se pudo retirar la etiqueta local {$version}.\n"
                    );
                }
            }
            throw $exception;
        }

        fwrite(
            STDOUT,
            "Release {$version} publicada atómicamente en origin/main.\n"
        );
    }

    private function assertReleaseMetadata(string $version): void
    {
        $composer = $this->readJson('composer.json');
        if (($composer['name'] ?? null) !== 'liquidstack/base'
            || ($composer['type'] ?? null) !== 'project'
        ) {
            throw new RuntimeException(
                'composer.json no declara el proyecto liquidstack/base.'
            );
        }

        foreach (['composer.lock', 'package-lock.json', 'CHANGELOG.md'] as $file) {
            if (!is_file($this->root . '/' . $file)) {
                throw new RuntimeException("Falta el artefacto de release {$file}.");
            }
        }

        $plainVersion = substr($version, 1);
        $changelog = (string) file_get_contents($this->root . '/CHANGELOG.md');
        $pattern = '/^## \[' . preg_quote($plainVersion, '/')
            . '\] - \d{4}-\d{2}-\d{2}\s*$/m';
        if (!preg_match($pattern, $changelog)) {
            throw new RuntimeException(
                "CHANGELOG.md debe cerrar {$plainVersion} con fecha ISO antes "
                    . 'de publicar.'
            );
        }

        $this->assertNoCompiledManifest();
    }

    private function assertGitPreflight(string $version): void
    {
        if (trim($this->capture(['git', 'branch', '--show-current'])) !== 'main') {
            throw new RuntimeException('La release de BASE solo sale desde main.');
        }
        $this->assertCleanWorkingTree();

        $originUrl = trim($this->capture([
            'git', 'remote', 'get-url', 'origin',
        ]));
        if (preg_match(
            '#(?:github\.com[/:])LiquidArtDevelopers/LIQUIDSTACK-BASE(?:\.git)?$#i',
            $originUrl
        ) !== 1) {
            throw new RuntimeException(
                'origin no apunta al repositorio canonico de LiquidStack BASE.'
            );
        }

        foreach (['composer.lock', 'package-lock.json'] as $lock) {
            if (trim($this->capture(['git', 'ls-files', '--', $lock])) !== $lock) {
                throw new RuntimeException("{$lock} debe estar versionado.");
            }
        }
        if (trim($this->capture([
            'git', 'ls-files', '--', 'public/.vite/manifest.json',
        ])) !== '') {
            throw new RuntimeException(
                'public/.vite/manifest.json no puede estar versionado.'
            );
        }

        $this->execute(
            ['git', 'fetch', '--prune', '--tags', 'origin'],
            'git fetch --prune --tags origin'
        );
        $counts = preg_split('/\s+/', trim($this->capture([
            'git', 'rev-list', '--left-right', '--count',
            'origin/main...HEAD',
        ]))) ?: [];
        if (count($counts) !== 2 || (int) $counts[0] !== 0) {
            throw new RuntimeException(
                'main local está por detrás o diverge de origin/main.'
            );
        }

        $this->assertTagAvailable($version);
        foreach (preg_split('/\R/', trim($this->capture([
            'git', 'tag', '--list', 'v*',
        ]))) ?: [] as $tag) {
            if (preg_match(
                '/^v(0|[1-9]\d*)\.(0|[1-9]\d*)\.(0|[1-9]\d*)$/D',
                $tag
            )
                && version_compare(substr($version, 1), substr($tag, 1), '<=')
            ) {
                throw new RuntimeException(
                    "La versión {$version} no es posterior a {$tag}."
                );
            }
        }
    }

    private function assertTagAvailable(string $version): void
    {
        if (trim($this->capture(['git', 'tag', '--list', $version])) !== '') {
            throw new RuntimeException("La etiqueta {$version} ya existe.");
        }
    }

    private function assertCleanWorkingTree(): void
    {
        if (trim($this->capture([
            'git', 'status', '--porcelain=v1', '--untracked-files=all',
        ])) !== '') {
            throw new RuntimeException(
                'El árbol de BASE debe estar limpio antes y después del gate.'
            );
        }
    }

    private function assertGitIdentity(
        string $expectedBranch,
        string $expectedCommit
    ): void {
        $actualBranch = trim($this->capture([
            'git', 'branch', '--show-current',
        ]));
        $actualCommit = trim($this->capture([
            'git', 'rev-parse', '--verify', 'HEAD^{commit}',
        ]));

        if ($actualBranch !== $expectedBranch || $actualCommit !== $expectedCommit) {
            throw new RuntimeException(
                'La rama o el commit cambiaron durante el gate; repite la release.'
            );
        }
    }

    private function assertNoCompiledManifest(): void
    {
        if (is_file($this->root . '/public/.vite/manifest.json')) {
            throw new RuntimeException(
                'Retira public/.vite/manifest.json: es un output de build.'
            );
        }
    }

    /** @return array{0: string, 1: string} */
    private function createValidationProject(string $releaseCommit): array
    {
        if (!class_exists(ZipArchive::class)) {
            throw new RuntimeException(
                'El gate aislado de BASE necesita la extension PHP zip.'
            );
        }

        $temporaryRoot = realpath(sys_get_temp_dir());
        if ($temporaryRoot === false) {
            throw new RuntimeException(
                'No se pudo resolver el directorio temporal del sistema.'
            );
        }
        $workspace = $temporaryRoot . DIRECTORY_SEPARATOR
            . 'liquidstack-base-release-'
            . bin2hex(random_bytes(8));
        $project = $workspace . DIRECTORY_SEPARATOR . 'project';
        $archive = $workspace . DIRECTORY_SEPARATOR . 'base.zip';
        if (!mkdir($workspace, 0700) && !is_dir($workspace)) {
            throw new RuntimeException(
                'No se pudo crear el workspace aislado de release.'
            );
        }

        try {
            $this->execute([
                'git', 'archive', '--format=zip',
                '--output=' . $archive,
                $releaseCommit,
            ], 'git archive del commit de release');

            $zip = new ZipArchive();
            if ($zip->open($archive) !== true) {
                throw new RuntimeException(
                    'No se pudo abrir el archive aislado de BASE.'
                );
            }
            try {
                foreach (['.env', '.npmrc', 'auth.json'] as $privateFile) {
                    if ($zip->locateName($privateFile) !== false) {
                        throw new RuntimeException(
                            "El archive de release contiene {$privateFile}."
                        );
                    }
                }
                if (!mkdir($project, 0700) && !is_dir($project)) {
                    throw new RuntimeException(
                        'No se pudo crear el proyecto aislado de release.'
                    );
                }
                if (!$zip->extractTo($project)) {
                    throw new RuntimeException(
                        'No se pudo extraer el proyecto aislado de release.'
                    );
                }
            } finally {
                $zip->close();
            }

            return [$workspace, $project];
        } catch (Throwable $exception) {
            $this->removeValidationWorkspace($workspace);
            throw $exception;
        }
    }

    private function prepareNpmAuthentication(string $project): void
    {
        $source = $this->root . '/.npmrc';
        if (!file_exists($source)) {
            return;
        }
        if (!is_file($source) || is_link($source)) {
            throw new RuntimeException(
                '.npmrc local debe ser un fichero regular para el build aislado.'
            );
        }
        if (!copy($source, $project . '/.npmrc')) {
            throw new RuntimeException(
                'No se pudo preparar la autenticacion npm aislada.'
            );
        }
    }

    private function removeValidationWorkspace(string $workspace): void
    {
        if (!file_exists($workspace)) {
            return;
        }
        $temporaryRoot = realpath(sys_get_temp_dir());
        $resolved = realpath($workspace);
        if (
            $temporaryRoot === false
            || $resolved === false
            || dirname($resolved) !== $temporaryRoot
            || !str_starts_with(
                basename($resolved),
                'liquidstack-base-release-'
            )
        ) {
            throw new RuntimeException(
                'Se rechazo limpiar un workspace de release no reconocido.'
            );
        }

        $iterator = new RecursiveIteratorIterator(
            new RecursiveDirectoryIterator(
                $resolved,
                FilesystemIterator::SKIP_DOTS
            ),
            RecursiveIteratorIterator::CHILD_FIRST
        );
        foreach ($iterator as $item) {
            $path = $item->getPathname();
            if ($item->isLink() || $item->isFile()) {
                if (!unlink($path)) {
                    throw new RuntimeException(
                        'No se pudo limpiar un fichero del workspace de release.'
                    );
                }
                continue;
            }
            if (!rmdir($path)) {
                throw new RuntimeException(
                    'No se pudo limpiar un directorio del workspace de release.'
                );
            }
        }
        if (!rmdir($resolved)) {
            throw new RuntimeException(
                'No se pudo retirar el workspace aislado de release.'
            );
        }
    }

    /** @param list<string> $relativePaths
     *  @return array<string, string>
     */
    private function hashes(array $relativePaths): array
    {
        $hashes = [];
        foreach ($relativePaths as $relativePath) {
            $hash = hash_file('sha256', $this->root . '/' . $relativePath);
            if ($hash === false) {
                throw new RuntimeException("No se pudo resumir {$relativePath}.");
            }
            $hashes[$relativePath] = $hash;
        }
        return $hashes;
    }

    /** @param array<string, string> $expected */
    private function assertHashes(array $expected): void
    {
        foreach ($expected as $relativePath => $expectedHash) {
            $actual = hash_file('sha256', $this->root . '/' . $relativePath);
            if (!is_string($actual) || !hash_equals($expectedHash, $actual)) {
                throw new RuntimeException(
                    "La validación modificó {$relativePath}; revisa el lock."
                );
            }
        }
    }

    /** @param list<string> $arguments */
    private function runComposer(
        array $arguments,
        ?string $workingDirectory = null
    ): void
    {
        $this->execute(
            [...$this->composerCommand, ...$arguments],
            'composer ' . implode(' ', $arguments),
            true,
            $workingDirectory
        );
    }

    /** @param list<string> $arguments */
    private function runNpm(
        array $arguments,
        ?string $workingDirectory = null
    ): void
    {
        $label = 'npm ' . implode(' ', $arguments);
        $this->execute(
            [...$this->npmCommand, ...$arguments],
            $label,
            true,
            $workingDirectory
        );
    }

    /** @param list<string> $command */
    private function capture(array $command): string
    {
        return $this->execute($command, implode(' ', $command), false);
    }

    /** @param list<string> $command */
    private function execute(
        array $command,
        string $label,
        bool $showOutput = true,
        ?string $workingDirectory = null
    ): string {
        if ($showOutput) {
            fwrite(STDOUT, '> ' . $label . "\n");
        }

        $stdout = tmpfile();
        $stderr = tmpfile();
        if ($stdout === false || $stderr === false) {
            throw new RuntimeException('No se pudieron crear logs temporales.');
        }
        $process = proc_open(
            $command,
            [0 => ['pipe', 'r'], 1 => $stdout, 2 => $stderr],
            $pipes,
            $workingDirectory ?? $this->root,
            null,
            ['bypass_shell' => true]
        );
        if (!is_resource($process)) {
            throw new RuntimeException("No se pudo ejecutar {$label}.");
        }
        fclose($pipes[0]);
        $exitCode = proc_close($process);
        rewind($stdout);
        rewind($stderr);
        $standardOutput = stream_get_contents($stdout) ?: '';
        $standardError = stream_get_contents($stderr) ?: '';
        fclose($stdout);
        fclose($stderr);

        if ($showOutput || $exitCode !== 0) {
            if ($standardOutput !== '') {
                fwrite(STDOUT, $standardOutput);
            }
            if ($standardError !== '') {
                fwrite(STDERR, $standardError);
            }
        }
        if ($exitCode !== 0) {
            throw new RuntimeException(
                "{$label} terminó con código {$exitCode}."
            );
        }
        return $standardOutput;
    }

    /** @return list<string> */
    private function resolveComposerCommand(): array
    {
        $binary = getenv('COMPOSER_BINARY');
        if ($binary === false || trim($binary) === '') {
            throw new RuntimeException(
                'Ejecuta el gate con composer release -- --version=vX.Y.Z.'
            );
        }
        return str_ends_with(strtolower($binary), '.phar')
            ? [PHP_BINARY, $binary]
            : [$binary];
    }

    /** @return list<string> */
    private function resolveNpmCommand(): array
    {
        if (PHP_OS_FAMILY !== 'Windows') {
            return ['npm'];
        }

        $npmLaunchers = preg_split('/\R/', trim($this->execute(
            ['where.exe', 'npm.cmd'],
            'where.exe npm.cmd',
            false
        ))) ?: [];
        $nodeBinaries = preg_split('/\R/', trim($this->execute(
            ['where.exe', 'node.exe'],
            'where.exe node.exe',
            false
        ))) ?: [];

        foreach ($npmLaunchers as $launcher) {
            $launcher = trim($launcher);
            if ($launcher === '' || !is_file($launcher)) {
                continue;
            }
            $directory = dirname($launcher);
            $cli = $directory . DIRECTORY_SEPARATOR . 'node_modules'
                . DIRECTORY_SEPARATOR . 'npm' . DIRECTORY_SEPARATOR . 'bin'
                . DIRECTORY_SEPARATOR . 'npm-cli.js';
            if (!is_file($cli)) {
                continue;
            }

            $localNode = $directory . DIRECTORY_SEPARATOR . 'node.exe';
            if (is_file($localNode)) {
                return [$localNode, $cli];
            }
            foreach ($nodeBinaries as $node) {
                $node = trim($node);
                if ($node !== '' && is_file($node)) {
                    return [$node, $cli];
                }
            }
        }

        throw new RuntimeException(
            'No se pudo resolver npm-cli.js junto a npm.cmd en PATH.'
        );
    }

    /** @return array<string, mixed> */
    private function readJson(string $relativePath): array
    {
        return json_decode(
            (string) file_get_contents($this->root . '/' . $relativePath),
            true,
            512,
            JSON_THROW_ON_ERROR
        );
    }
}

$version = null;
$dryRun = false;
$confirmed = false;
foreach (array_slice($argv, 1) as $argument) {
    if ($argument === '--dry-run') {
        $dryRun = true;
    } elseif ($argument === '--yes' || $argument === '-y') {
        $confirmed = true;
    } elseif (str_starts_with($argument, '--version=')) {
        $version = substr($argument, strlen('--version='));
    } else {
        fwrite(STDERR, "Argumento de release desconocido: {$argument}\n");
        exit(1);
    }
}

if (!is_string($version) || $version === '') {
    fwrite(
        STDERR,
        "Uso: composer release -- --version=vMAJOR.MINOR.PATCH [--dry-run|--yes]\n"
    );
    exit(1);
}

try {
    (new BaseReleaseGate(dirname(__DIR__)))->run(
        $version,
        $dryRun,
        $confirmed
    );
} catch (Throwable $exception) {
    fwrite(STDERR, 'Release BASE detenida: ' . $exception->getMessage() . "\n");
    exit(1);
}
