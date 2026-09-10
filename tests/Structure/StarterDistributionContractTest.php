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
        self::assertSame('^1.29', $composer['require']['liquidstack/core'] ?? null);
        self::assertSame('^1.29', $composer['require']['liquidstack/blog'] ?? null);
        self::assertTrue(
            $composer['config']['allow-plugins']['liquidstack/core'] ?? false
        );
        self::assertSame(
            ['@php tools/test-create-project.php'],
            $composer['scripts']['test:create-project'] ?? null
        );
        self::assertSame(
            ['@php tools/release.php'],
            $composer['scripts']['release'] ?? null
        );
        self::assertFileExists($this->root . '/tools/release.php');

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
        self::assertSame(
            'v1.29.0',
            $packages['liquidstack/core']['version'] ?? null
        );
        self::assertSame(
            'd8d1447764d3f8a41a806dc96bc8cc04d52fd49b',
            $packages['liquidstack/core']['source']['reference'] ?? null
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
            "['git', 'diff', '--check']",
            'createValidationProject',
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
            '.npmrc.example',
            'auth.json',
            'public/.vite/manifest.json',
            'composer release -- --version=v1.0.0 --yes',
            'composer test:create-project -- --source=vcs',
            'Desvincular la identidad de la plantilla',
        ] as $contract) {
            self::assertStringContainsString($contract, $readme);
        }
        self::assertStringContainsString(
            'BASE tiene un ciclo SemVer independiente de CORE',
            $changelog
        );
        self::assertMatchesRegularExpression(
            '/un proyecto ya creado no\s+depende después de BASE/u',
            $changelog
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
