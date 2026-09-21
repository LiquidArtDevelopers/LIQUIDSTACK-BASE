<?php

declare(strict_types=1);

use PHPUnit\Framework\TestCase;

final class CommerceContractTest extends TestCase
{
    private string $root;

    protected function setUp(): void
    {
        $this->root = dirname(__DIR__, 2);
    }

    public function testCommerceIsSelectedButItsPublicSurfaceStartsClosed(): void
    {
        $composer = $this->json('composer.json');
        self::assertSame(
            '*',
            $composer['require']['liquidstack/commerce'] ?? null
        );

        $config = require $this->root . '/App/config/modules/commerce.php';
        self::assertFalse($config['public']['enabled'] ?? true);
        self::assertSame('inquiry', $config['transaction_mode'] ?? null);
        self::assertSame(
            'liquidstack',
            $config['database']['connection'] ?? null
        );
        $languages = require $this->root . '/App/config/langs.php';
        self::assertSame(
            array_values($languages),
            array_keys($config['public_paths'] ?? [])
        );
        self::assertSame(
            array_values($languages),
            array_keys($config['inquiry_paths'] ?? [])
        );
        self::assertSame('/es/comercio', $config['public_paths']['es'] ?? null);
        self::assertSame(
            '/eu/merkataritza',
            $config['public_paths']['eu'] ?? null
        );

        $routes = require $this->root . '/App/config/routes/get.php';
        foreach (array_merge(
            $config['public_paths'],
            $config['inquiry_paths']
        ) as $locale => $path) {
            self::assertArrayNotHasKey(
                $path,
                $routes[$locale] ?? [],
                'Las rutas Commerce pertenecen al provider de CORE.'
            );
        }
    }

    public function testCanonicalCommerceResourceBackpackIsComplete(): void
    {
        $files = [
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
            'App/views/showroom/_commerce.php',
            'App/views/commerce.php',
            'App/views/commerce-inquiry.php',
            'App/views/commerce-item.php',
            'src/js/commerce.js',
            'src/js/commerceInquiry.js',
            'src/js/commerceItem.js',
            'src/js/resources/_commerce.js',
            'src/js/showroom/commerce.js',
            'src/scss/commerce.scss',
            'src/scss/commerceInquiry.scss',
            'src/scss/commerceItem.scss',
            'src/scss/resources/_artCommerceItem01.scss',
            'src/scss/resources/_sectionCommerceCatalog01.scss',
            'src/scss/resources/_sectionCommerceInquiry01.scss',
            'src/scss/showroom/commerce.scss',
        ];

        self::assertCount(29, $files);
        foreach ($files as $file) {
            self::assertFileExists($this->root . '/' . $file);
        }
    }

    public function testShowroomFixturesExerciseCommerceWithoutBecomingCatalogData(): void
    {
        $partialPath = $this->root . '/App/views/showroom/_commerce.php';
        $partial = (string) file_get_contents($partialPath);
        $javascript = (string) file_get_contents(
            $this->root . '/src/js/showroom/commerce.js'
        );
        $styles = (string) file_get_contents(
            $this->root . '/src/scss/showroom/commerce.scss'
        );

        preg_match_all(
            "/\['[a-z0-9-]+', 'MX-APP-[0-9]{3}'/",
            $partial,
            $fixtureMatches
        );
        self::assertCount(20, $fixtureMatches[0] ?? []);
        self::assertSame(
            20,
            count(array_unique($fixtureMatches[0] ?? [])),
            'Cada prenda Matrix del showroom debe tener identidad propia.'
        );

        foreach ([
            "'outerwear'",
            "'tops'",
            "'bottoms'",
            "'dresses'",
            "'footwear'",
            "'accessories'",
            "'bags'",
            "'technical'",
            "'unisex'",
            "'urban'",
            "'limited'",
            "'new'",
            "controller('sectionCommerceCatalog01'",
            "controller('artCommerceItem01'",
            "controller('sectionCommerceInquiry01'",
            "'development_fixture' => '1'",
        ] as $contract) {
            self::assertStringContainsString($contract, $partial);
        }

        foreach ([
            'PDO',
            'INSERT INTO',
            'CommercePresentationAdapter',
            '_moduleCommercePublic',
            'ls_commerce_',
        ] as $runtimeDependency) {
            self::assertStringNotContainsString(
                $runtimeDependency,
                $partial,
                'Los ejemplos del showroom no pueden depender del runtime ni de la DB.'
            );
        }

        self::assertStringContainsString(
            "from '../resources/_commerce.js'",
            $javascript
        );
        self::assertStringContainsString('cleanupCommerce();', $javascript);
        foreach ([
            "@use '../resources/artCommerceItem01';",
            "@use '../resources/sectionCommerceCatalog01';",
            "@use '../resources/sectionCommerceInquiry01';",
        ] as $resourceImport) {
            self::assertStringContainsString($resourceImport, $styles);
        }

        $fixtureRealPath = realpath($partialPath);
        self::assertNotFalse($fixtureRealPath);
        $iterator = new RecursiveIteratorIterator(
            new RecursiveDirectoryIterator(
                $this->root . '/App',
                FilesystemIterator::SKIP_DOTS
            )
        );
        foreach ($iterator as $file) {
            if (
                !$file->isFile()
                || realpath($file->getPathname()) === $fixtureRealPath
            ) {
                continue;
            }

            self::assertStringNotContainsString(
                'MX-APP-',
                (string) file_get_contents($file->getPathname()),
                'Las prendas Matrix solo pueden existir en el partial del showroom.'
            );
        }
    }

    public function testCommerceEnvironmentKeysAreDocumented(): void
    {
        $environment = (string) file_get_contents(
            $this->root . '/.env.example'
        );
        foreach ([
            'LIQUIDSTACK_COMMERCE_INQUIRY_RECIPIENT=',
            'LIQUIDSTACK_COMMERCE_PRIVACY_VERSION=',
            'LIQUIDSTACK_COMMERCE_DEVELOPMENT_FIXTURES=0',
        ] as $key) {
            self::assertStringContainsString($key, $environment);
        }
    }

    /** @return array<string, mixed> */
    private function json(string $path): array
    {
        $decoded = json_decode(
            (string) file_get_contents($this->root . '/' . $path),
            true,
            512,
            JSON_THROW_ON_ERROR
        );

        self::assertIsArray($decoded);

        return $decoded;
    }
}
