<?php

declare(strict_types=1);

use PHPUnit\Framework\TestCase;

final class StarterDistributionContractTest extends TestCase
{
    private string $root;

    protected function setUp(): void
    {
        $this->root = dirname(__DIR__, 2);
    }

    public function testComposerDeclaresAnInstallableProjectWithoutAutomaticBootstrap(): void
    {
        $composer = $this->readJson('composer.json');

        self::assertSame('liquidstack/base', $composer['name'] ?? null);
        self::assertSame('project', $composer['type'] ?? null);
        self::assertSame('>=8.1', $composer['require']['php'] ?? null);
        self::assertSame('*', $composer['require']['ext-dom'] ?? null);
        self::assertSame('*', $composer['require']['ext-pdo_mysql'] ?? null);
        $coreConstraint = $composer['require']['liquidstack/core'] ?? null;
        self::assertSame('^1.35', $coreConstraint);
        self::assertStringStartsWith('^', $coreConstraint);
        self::assertSame('*', $composer['require']['liquidstack/webadmin'] ?? null);
        self::assertSame('*', $composer['require']['liquidstack/blog'] ?? null);
        self::assertSame('*', $composer['require']['liquidstack/commerce'] ?? null);
        self::assertTrue(
            $composer['config']['allow-plugins']['liquidstack/core'] ?? false
        );
        self::assertSame(
            [
                'tools/ProjectInitializer.php',
                'tools/ReleaseScript.php',
            ],
            $composer['autoload']['classmap'] ?? null
        );
        self::assertSame(
            ['LiquidStackBase\\ProjectInitializer::initialize'],
            $composer['scripts']['post-create-project-cmd'] ?? null
        );
        self::assertSame(
            ['LiquidStackBase\\ProjectInitializer::initialize'],
            $composer['scripts']['project:init'] ?? null
        );
        self::assertSame(
            [
                'Composer\\Config::disableProcessTimeout',
                '@php tools/test-create-project.php',
            ],
            $composer['scripts']['test:create-project'] ?? null
        );
        self::assertArrayNotHasKey('release:prepare', $composer['scripts']);
        self::assertSame(
            [
                'Composer\\Config::disableProcessTimeout',
                'LiquidStackBase\\ReleaseScript::run',
            ],
            $composer['scripts']['release'] ?? null
        );
        self::assertFileExists($this->root . '/tools/ReleaseScript.php');
        self::assertFileExists($this->root . '/tools/release.php');
        self::assertFileExists(
            $this->root . '/tools/ProjectInitializer.php'
        );

        $initializer = (string) file_get_contents(
            $this->root . '/tools/ProjectInitializer.php'
        );
        foreach ([
            "'liquid-art-developers/' . \$slug",
            "'liquidstack-' . \$slug",
            "unset(\$composer['homepage'], \$composer['support'])",
            "unset(\$composer['scripts']['project:init'])",
            "\$composer['scripts']['release:prepare']",
            "getLocker()->updateHash(",
            "'tools/ReleaseScript.php'",
            "'tools/release.php'",
            "'tools/test-create-project.php'",
            "'tests/Structure/StarterContractTest.php'",
            "'tests/Structure/StarterDistributionContractTest.php'",
        ] as $initializerContract) {
            self::assertStringContainsString(
                $initializerContract,
                $initializer
            );
        }
        foreach ([
            'npm install',
            'npm ci',
            'liquidstack:migrate',
            'liquidstack:webadmin:onboard',
            "file_put_contents(\$this->path('.env')",
        ] as $forbiddenInitializerEffect) {
            self::assertStringNotContainsString(
                $forbiddenInitializerEffect,
                $initializer
            );
        }

        $scripts = strtolower((string) json_encode(
            $composer['scripts'] ?? [],
            JSON_THROW_ON_ERROR | JSON_UNESCAPED_SLASHES
        ));
        foreach ([
            'liquidstack:migrate --apply',
            'liquidstack:media:init',
            'liquidstack:webadmin:bootstrap',
            'liquidstack:webadmin:onboard',
            'npm install',
            'npm ci',
            'copy-item',
            '.env.example .env',
        ] as $forbidden) {
            self::assertStringNotContainsString($forbidden, $scripts);
        }

        $expectedExcludes = [
            '/.git',
            '/.env',
            '/.npmrc',
            '/auth.json',
            '/composer.lock',
            '/.phpunit.result.cache',
            '/.codex/tmp',
            '/.liquidstack/core/sync-transactions',
            '/vendor',
            '/node_modules',
            '/App/tools',
            '/App/bootstrap.php',
            '/storage',
            '/public/.vite',
            '/public/assets/css',
            '/public/assets/js',
            '/public/assets/video/customer',
        ];
        self::assertSame(
            $expectedExcludes,
            $composer['archive']['exclude'] ?? null
        );
    }

    public function testLockfilesAndPrivateRegistryTemplateAreReproducibleAndSafe(): void
    {
        self::assertFileExists($this->root . '/composer.lock');
        self::assertFileExists($this->root . '/package-lock.json');
        self::assertFileExists($this->root . '/.npmrc.example');

        $composerLock = $this->readJson('composer.lock');
        $packages = array_column($composerLock['packages'] ?? [], null, 'name');
        self::assertArrayHasKey('liquidstack/core', $packages);
        $coreVersion = ltrim((string) (
            $packages['liquidstack/core']['version'] ?? ''
        ), 'v');
        self::assertTrue(version_compare($coreVersion, '1.31.0', '>='));
        self::assertTrue(version_compare($coreVersion, '2.0.0', '<'));
        self::assertMatchesRegularExpression(
            '/^[0-9a-f]{40}$/D',
            (string) (
                $packages['liquidstack/core']['source']['reference'] ?? ''
            )
        );

        $package = $this->readJson('package.json');
        $packageLock = $this->readJson('package-lock.json');
        self::assertSame('liquidstack-base', $package['name'] ?? null);
        self::assertSame('liquidstack-base', $packageLock['name'] ?? null);
        self::assertSame(3, $packageLock['lockfileVersion'] ?? null);
        self::assertSame(
            $package['dependencies']['gsap'] ?? null,
            $packageLock['packages']['']['dependencies']['gsap'] ?? null
        );
        $serializedNpmLock = json_encode(
            $packageLock,
            JSON_THROW_ON_ERROR | JSON_UNESCAPED_SLASHES
        );
        self::assertStringNotContainsString('_authToken', $serializedNpmLock);
        self::assertStringNotContainsString('example_pass', $serializedNpmLock);

        $gitignore = (string) file_get_contents($this->root . '/.gitignore');
        self::assertDoesNotMatchRegularExpression(
            '/^\/?(?:composer|package)-lock\.json\s*$/m',
            $gitignore
        );
        self::assertMatchesRegularExpression('/^\.env\s*$/m', $gitignore);
        self::assertMatchesRegularExpression('/^\.npmrc\s*$/m', $gitignore);
        self::assertMatchesRegularExpression('#^/auth\.json\s*$#m', $gitignore);
        self::assertMatchesRegularExpression(
            '#^/public/\.vite/\s*$#m',
            $gitignore
        );

        $npmTemplate = (string) file_get_contents(
            $this->root . '/.npmrc.example'
        );
        self::assertStringContainsString('${GSAP_TOKEN}', $npmTemplate);
        self::assertStringContainsString(
            '@gsap:registry=https://npm.greensock.com',
            $npmTemplate
        );
        self::assertDoesNotMatchRegularExpression(
            '/_authToken=(?!\$\{GSAP_TOKEN\}\s*$).+/m',
            $npmTemplate
        );

        $releaseGate = (string) file_get_contents(
            $this->root . '/tools/release.php'
        );
        foreach ([
            "'git', 'push', '--atomic'",
            "'git', 'archive', '--format=zip'",
            "['ci', '--ignore-scripts']",
            "'test:create-project'",
            "'--no-check-all'",
            "['git', 'diff', '--check']",
            'createValidationProject',
            'detectPendingChangelogVersion',
            'Descripción breve de la release',
            'assertTagAvailable',
            'LiquidArtDevelopers/LIQUIDSTACK-BASE',
            'npm-cli.js',
        ] as $requiredGate) {
            self::assertStringContainsString($requiredGate, $releaseGate);
        }
        foreach ([
            'liquidstack:migrate',
            'liquidstack:media:init',
            'liquidstack:webadmin:onboard',
            'file_put_contents($envPath',
            "['node', 'scripts/clean-manifest.js']",
            "['cmd.exe', '/d', '/s', '/c', \$label]",
        ] as $forbiddenGate) {
            self::assertStringNotContainsString($forbiddenGate, $releaseGate);
        }
    }

    public function testArchiveAndDocumentationKeepOwnershipBoundariesExplicit(): void
    {
        $attributes = (string) file_get_contents(
            $this->root . '/.gitattributes'
        );
        foreach ([
            '/.env export-ignore',
            '/.npmrc export-ignore',
            '/auth.json export-ignore',
            '/composer.lock export-ignore',
            '/.liquidstack/core/sync-transactions export-ignore',
            '/vendor export-ignore',
            '/node_modules export-ignore',
            '/App/tools export-ignore',
            '/App/bootstrap.php export-ignore',
            '/storage export-ignore',
            '/public/.vite export-ignore',
        ] as $rule) {
            self::assertStringContainsString($rule, $attributes);
        }

        $readme = (string) file_get_contents($this->root . '/README.md');
        $changelog = (string) file_get_contents(
            $this->root . '/CHANGELOG.md'
        );
        foreach ([
            'composer create-project liquidstack/base',
            'v1.0.0',
            'no depende de BASE',
            'composer update liquidstack/core',
            'liquidstack/commerce',
            '0001_commerce_catalog',
            'liquidstack:commerce-mail-dispatch --limit=20',
            'public.enabled=true',
            '.npmrc.example',
            'auth.json',
            'public/.vite/manifest.json',
            'Después de confirmar los cambios y dejar el árbol limpio',
            'composer release',
            'BASE `v1.2.0` y CORE',
            'composer test:create-project -- --source=vcs',
            'Desvincular la identidad de la plantilla',
        ] as $contract) {
            self::assertStringContainsString($contract, $readme);
        }
        self::assertStringNotContainsString(
            'mi-proyecto "^1.0"',
            $readme
        );
        self::assertStringContainsString(
            'al atravesar `composer.bat`',
            $readme
        );
        self::assertStringContainsString(
            'BASE tiene un ciclo SemVer independiente de CORE',
            $changelog
        );
        self::assertStringContainsString(
            'detecta la única',
            $changelog
        );
        self::assertMatchesRegularExpression(
            '/un proyecto ya creado no\s+depende después de BASE/u',
            $changelog
        );
    }

    public function testReleaseScriptBridgesComposerIoIntoTheGate(): void
    {
        require_once $this->root . '/tools/release.php';

        $gate = new BaseReleaseGate(
            $this->root,
            static fn (string $message, string $default): string => $default
                . '-composer-io',
            static fn (string $message): bool => true
        );
        $prompt = new ReflectionMethod($gate, 'prompt');
        $prompt->setAccessible(true);
        $confirm = new ReflectionMethod($gate, 'confirm');
        $confirm->setAccessible(true);

        self::assertSame(
            'v1.4.3-composer-io',
            $prompt->invoke($gate, 'Version: ', 'v1.4.3')
        );
        self::assertTrue($confirm->invoke($gate, 'Publish?'));

        $script = (string) file_get_contents(
            $this->root . '/tools/ReleaseScript.php'
        );
        foreach ([
            '$event->getIO()',
            '$event->getArguments()',
            '$io->ask(',
            '$io->askConfirmation(',
        ] as $composerIoContract) {
            self::assertStringContainsString($composerIoContract, $script);
        }
    }

    public function testReleaseDetectsOnePendingChangelogVersionAndRejectsInvalidStates(): void
    {
        require_once $this->root . '/tools/release.php';

        self::assertSame(
            'v1.2.1',
            BaseReleaseGate::detectPendingVersion(
                "# Changelog\n\n## [Unreleased]\n\n"
                    . "## [1.2.1] - 2026-09-21\n\n"
                    . "## [1.2.0] - 2026-09-20\n",
                ['v1.2.0']
            )
        );

        try {
            BaseReleaseGate::detectPendingVersion(
                "# Changelog\n\n## [Unreleased]\n\n"
                    . "## [1.2.0] - 2026-09-20\n",
                ['v1.2.0']
            );
            self::fail('Debía exigir una versión posterior en CHANGELOG.md.');
        } catch (RuntimeException $exception) {
            self::assertStringContainsString(
                'Falta preparar la versión',
                $exception->getMessage()
            );
        }

        try {
            BaseReleaseGate::detectPendingVersion(
                "# Changelog\n\n## [Unreleased]\n\n"
                    . "## [1.3.0] - 2026-09-22\n\n"
                    . "## [1.2.1] - 2026-09-21\n",
                ['v1.2.0']
            );
            self::fail('Debía rechazar dos versiones pendientes.');
        } catch (RuntimeException $exception) {
            self::assertStringContainsString(
                'varias versiones posteriores',
                $exception->getMessage()
            );
        }
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
