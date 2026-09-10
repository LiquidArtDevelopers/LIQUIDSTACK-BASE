<?php

declare(strict_types=1);

use PHPUnit\Framework\TestCase;

final class StarterContractTest extends TestCase
{
    public function testStarterEnvironmentAndHeadContainNoClientCredentials(): void
    {
        $root = dirname(__DIR__, 2);
        $environment = (string) file_get_contents($root . '/.env.example');
        $head = (string) file_get_contents(
            $root . '/App/includes/_globalHead.php'
        );
        $apache = (string) file_get_contents($root . '/public/.htaccess');
        $neutralPublicMetadata = strtolower(
            (string) file_get_contents($root . '/public/humans.txt')
                . (string) file_get_contents(
                    $root . '/App/config/languages/global/es.json'
                )
                . (string) file_get_contents(
                    $root . '/App/config/languages/global/eu.json'
                )
        );

        self::assertStringContainsString('LANG_SKIP_UPDATE=0', $environment);
        self::assertMatchesRegularExpression(
            '/^COOKIE_LAD_KEY=\s*$/m',
            $environment
        );
        self::assertStringContainsString(
            "\$_ENV['COOKIE_LAD_KEY']",
            $head
        );
        self::assertStringNotContainsString('loader.js?key=1QO', $head);
        self::assertStringNotContainsString('atleticosansebastian', $head);
        self::assertStringNotContainsString('isotipo.svg', $head);
        self::assertStringNotContainsString('atleticosansebastian', $apache);
        self::assertStringNotContainsString('BBDD_PREFIX=', $environment);
        self::assertStringNotContainsString('API_USER_REQUEST=', $environment);
        self::assertStringNotContainsString('API_TOKEN_AUTH=', $environment);
        self::assertStringNotContainsString('dinaserver.com', $environment);
        self::assertStringNotContainsString('infoda.eus', $neutralPublicMetadata);
        self::assertStringNotContainsString(
            'liquid art developers',
            $neutralPublicMetadata
        );
    }

    public function testLegacyMembershipSurfaceIsAbsentFromTheStarter(): void
    {
        $root = dirname(__DIR__, 2);
        $routes = require $root . '/App/config/routes/get.php';
        $postRoutes = require $root . '/App/config/routes/post.php';

        $legacyContent = [
            'login',
            'socio',
            'documentos',
            'comunicados',
            'remember-password',
            'reset-password',
        ];

        foreach (['es', 'eu'] as $language) {
            foreach ($routes[$language] as $path => $route) {
                if (!is_array($route)) {
                    continue;
                }

                self::assertNotContains(
                    $route['content'] ?? null,
                    $legacyContent,
                    "La ruta {$path} no debe recuperar la aplicación de socios."
                );
            }
        }

        foreach ([
            '/form-little',
            '/form-login',
            '/form-reset-password',
            '/form-remember-password',
        ] as $path) {
            self::assertArrayNotHasKey($path, $postRoutes);
        }

        // El descargador pertenece al showroom reutilizable, no al area privada.
        self::assertArrayHasKey('/es/descargar?file={file}', $routes['es']);
        self::assertArrayHasKey('/es/deskargatu?file={file}', $routes['es']);
        self::assertArrayHasKey('/eu/deskargatu?file={file}', $routes['eu']);
        self::assertArrayHasKey('/eu/descargar?file={file}', $routes['eu']);
        foreach ([
            $routes['es']['/es/descargar?file={file}'],
            $routes['es']['/es/deskargatu?file={file}'],
            $routes['eu']['/eu/deskargatu?file={file}'],
            $routes['eu']['/eu/descargar?file={file}'],
        ] as $downloadRoute) {
            self::assertFalse($downloadRoute['session']);
            self::assertFalse($downloadRoute['sitemap']);
        }
        self::assertSame(
            count($routes['es']),
            count($routes['eu']),
            'Las rutas multilingües deben conservar una correspondencia 1:1.'
        );
        self::assertFileExists($root . '/App/app/downloadFile.php');
        $downloadHandler = (string) file_get_contents(
            $root . '/App/app/downloadFile.php'
        );
        self::assertStringNotContainsString('_credencial', $downloadHandler);
        self::assertStringNotContainsString('id_rol', $downloadHandler);

        foreach ([
            'App/app/_conexionBBDD.php',
            'App/app/formLogin.php',
            'App/app/formRememberPassword.php',
            'App/app/formResetPassword.php',
            'App/app/formularioLittle.php',
            'App/app/logout.php',
            'App/app/verifyTokenForResetPassword.php',
            'App/config/languages/comunicados/es.json',
            'App/config/languages/comunicados/eu.json',
            'App/config/languages/documentos/es.json',
            'App/config/languages/documentos/eu.json',
            'App/config/languages/login/es.json',
            'App/config/languages/login/eu.json',
            'App/config/languages/remember-password/es.json',
            'App/config/languages/remember-password/eu.json',
            'App/config/languages/reset-password/es.json',
            'App/config/languages/reset-password/eu.json',
            'App/config/languages/socio/es.json',
            'App/config/languages/socio/eu.json',
            'App/models/_activeRecord.php',
            'App/models/_admins.php',
            'App/models/_credencial.php',
            'App/models/_usuarios.php',
            'App/repositorios/_usersRepository.php',
            'App/views/admin-lad.php',
            'App/views/comunicados.php',
            'App/views/documentos.php',
            'App/views/login.php',
            'App/views/remember-password.php',
            'App/views/reset-password.php',
            'App/views/socio.php',
            'liquid_stack_bbdd.sql',
            'public/assets/img/iconos/socios-icono.svg',
            'src/js/comunicados.js',
            'src/js/documentos.js',
            'src/js/login.js',
            'src/js/remember-password.js',
            'src/js/reset-password.js',
            'src/js/socio.js',
            'src/scss/comunicados.scss',
            'src/scss/documentos.scss',
            'src/scss/login.scss',
            'src/scss/remember-password.scss',
            'src/scss/reset-password.scss',
            'src/scss/socio.scss',
        ] as $legacyFile) {
            self::assertFileDoesNotExist($root . '/' . $legacyFile);
        }

        // Los recursos de formulario distribuidos por CORE son reutilizables
        // y no pertenecen al backend de socios que se ha retirado.
        self::assertFileExists(
            $root . '/App/controllers/moduleFormAuthLogin01.php'
        );
        self::assertFileExists(
            $root . '/src/js/resources/_formLogin.js'
        );
    }

    public function testPublicNavigationExposesOnlyTheStarterLinks(): void
    {
        $root = dirname(__DIR__, 2);
        $routes = require $root . '/App/config/routes/get.php';
        $navigation = (string) file_get_contents(
            $root . '/App/includes/_nav.php'
        );
        $footer = (string) file_get_contents(
            $root . '/App/includes/_footer.php'
        );
        $controller = (string) file_get_contents(
            $root . '/App/controllers/navMegamenu01.php'
        );

        $expected = [
            'es' => [
                'home' => '/',
                'services' => '/es/servicios',
                'blog' => '/es/blog',
                'contact' => '/es/contacto',
                'catalog_hrefs' => [
                    'services' => 'servicios',
                    'blog' => 'blog',
                    'contactLink' => 'contacto',
                ],
            ],
            'eu' => [
                'home' => '/eu',
                'services' => '/eu/serbitzuak',
                'blog' => '/eu/blog',
                'contact' => '/eu/kontaktua',
                'catalog_hrefs' => [
                    'services' => 'serbitzuak',
                    'blog' => 'blog',
                    'contactLink' => 'kontaktua',
                ],
            ],
        ];

        $catalogKeys = [];
        foreach ($expected as $locale => $paths) {
            $catalog = json_decode(
                (string) file_get_contents(
                    $root . "/App/config/languages/global/{$locale}.json"
                ),
                true,
                512,
                JSON_THROW_ON_ERROR
            );
            $catalogKeys[$locale] = array_keys($catalog);

            foreach (array_diff_key($paths, ['catalog_hrefs' => true]) as $path) {
                self::assertArrayHasKey($path, $routes[$locale]);
            }

            foreach ($paths['catalog_hrefs'] as $key => $href) {
                self::assertSame(
                    $href,
                    $catalog["navMegamenu01_00_{$key}"]['href']
                );
            }
            foreach (['login', 'link0', 'link1', 'link2', 'link3', 'link4'] as $legacyKey) {
                self::assertArrayNotHasKey(
                    "navMegamenu01_00_{$legacyKey}",
                    $catalog
                );
            }
        }
        self::assertSame($catalogKeys['es'], $catalogKeys['eu']);

        foreach ([$navigation, $footer] as $publicInclude) {
            self::assertStringContainsString(
                "'show_private_access' => false",
                $publicInclude
            );
            self::assertStringContainsString(
                "'link' => 'navMegamenu01_00_blog'",
                $publicInclude
            );
        }

        self::assertLessThan(
            strpos($controller, 'contactLink'),
            strpos($controller, '$publicLinkKeys')
        );
    }

    public function testHomeCatalogsHaveMatchingNeutralLocalizedContracts(): void
    {
        $root = dirname(__DIR__, 2);
        $spanish = json_decode(
            (string) file_get_contents(
                $root . '/App/config/languages/home/es.json'
            ),
            true,
            512,
            JSON_THROW_ON_ERROR
        );
        $basque = json_decode(
            (string) file_get_contents(
                $root . '/App/config/languages/home/eu.json'
            ),
            true,
            512,
            JSON_THROW_ON_ERROR
        );

        self::assertSame(array_keys($spanish), array_keys($basque));
        self::assertSame(
            'index, follow, max-snippet:-1, max-video-preview:-1, '
                . 'max-image-preview:large',
            $basque['robots']['content']
        );
        self::assertNotSame('', trim($basque['description']['content']));

        $serialized = json_encode(
            $basque,
            JSON_THROW_ON_ERROR | JSON_UNESCAPED_UNICODE
        );
        foreach ([
            'LAD Framework Templates',
            'Nuestro primer comunicado',
            'socios y socias',
            'vida del club',
        ] as $legacyCopy) {
            self::assertStringNotContainsString($legacyCopy, $serialized);
        }
    }

    public function testShowroomCatalogsContainOnlyNeutralStarterIdentity(): void
    {
        $root = dirname(__DIR__, 2);
        $copy = strtolower(
            (string) file_get_contents(
                $root . '/App/config/languages/templates/es.json'
            )
                . (string) file_get_contents(
                    $root . '/App/config/languages/templates/eu.json'
                )
                . (string) file_get_contents(
                    $root . '/App/config/languages/templates/en.json'
                )
                . (string) file_get_contents(
                    $root . '/App/controllers/hero03.php'
                )
        );

        foreach ([
            'liquid art developers',
            'lad framework templates',
            'bizkaia',
            'vida del club',
            'socios y socias',
            'socio',
            'bilbao',
            'barcelona',
            'dni vigente',
            'psicotécnico',
            'prácticas obligatorias',
            'maps.app.goo.gl',
            'ejemplo.com',
        ] as $legacyCopy) {
            self::assertStringNotContainsString($legacyCopy, $copy);
        }
    }

    public function testPublicViewsRenderOnlyOnePrimaryHeading(): void
    {
        $root = dirname(__DIR__, 2);
        foreach (['servicio.php', 'contacto.php'] as $view) {
            $contents = (string) file_get_contents(
                $root . '/App/views/' . $view
            );
            self::assertStringContainsString(
                "'header_level' => 2",
                $contents,
                "{$view} debe degradar el segundo módulo visual a H2."
            );
        }
    }

    public function testWebAdminAndBlogUseTheSameDatabaseProfile(): void
    {
        $root = dirname(__DIR__, 2);
        $webAdmin = require $root . '/App/config/modules/webadmin.php';
        $blog = require $root . '/App/config/modules/blog.php';

        self::assertSame(
            $webAdmin['database']['connection'],
            $blog['database']['connection']
        );
        self::assertSame('shared', $blog['database']['connection']);
        self::assertNotSame(
            $webAdmin['database']['table_prefix'],
            $blog['database']['table_prefix']
        );
    }

    public function testShowroomCategoriesAndLocalExtensionContractExist(): void
    {
        $root = dirname(__DIR__, 2);
        $routes = require $root . '/App/config/routes/get.php';
        $categories = [
            'heroes',
            'particles',
            'gsap-specials',
            'common',
            'cards-grids',
            'media',
            'forms-interactive',
            'modules-sections',
            'blog',
        ];

        foreach (['es', 'eu'] as $language) {
            foreach (['templates', 'showroom'] as $parent) {
                $parentPath = "/{$language}/{$parent}";
                self::assertArrayHasKey($parentPath, $routes[$language]);
                foreach ($categories as $category) {
                    $child = "{$parentPath}/{$category}";
                    self::assertArrayNotHasKey(
                        $child,
                        $routes[$language],
                        'Las subrutas del showroom pertenecen al resolver de CORE.'
                    );
                    $resolved = \App\Core\Routing\ShowroomCategoryRoute::resolve(
                        $child,
                        $routes[$language],
                        $root
                    );
                    self::assertIsArray($resolved);
                    self::assertSame(
                        $category,
                        $resolved['showroom_category']
                    );
                    self::assertSame(
                        $parentPath,
                        $resolved['showroom_base_path']
                    );
                }
            }
        }

        $showroomShell = (string) file_get_contents(
            $root . '/App/views/_showroom.php'
        );
        $showroomEntry = (string) file_get_contents(
            $root . '/src/js/templates.js'
        );
        self::assertStringContainsString(
            "is_file(__DIR__ . '/showroom/_local.php')",
            $showroomShell
        );
        self::assertStringContainsString(
            "import.meta.glob('./showroom/local/*.js')",
            $showroomEntry
        );
        self::assertFileExists(
            $root . '/.liquidstack/core/managed-files.json'
        );
        self::assertFileExists(
            $root . '/.codex/skills/dev-stack/SKILL.md'
        );
    }

    public function testNewProjectsDoNotRenderTheLegacyOffice(): void
    {
        $root = dirname(__DIR__, 2);
        $navigation = (string) file_get_contents(
            $root . '/App/includes/_nav.php'
        );
        $footer = (string) file_get_contents(
            $root . '/App/includes/_footer.php'
        );
        $controller = (string) file_get_contents(
            $root . '/App/controllers/navMegamenu01.php'
        );

        self::assertStringContainsString("'offices' => []", $navigation);
        self::assertStringContainsString("'offices' => []", $footer);
        self::assertStringContainsString(
            "is_array(\$params['offices'] ?? null)",
            $controller
        );
        self::assertStringNotContainsString('maps.app.goo.gl', $controller);
        self::assertStringNotContainsString("'label' =>", $controller);
    }

    public function testBlogIndexIsACompleteProjectOwnedStarterShell(): void
    {
        $root = dirname(__DIR__, 2);
        $routes = require $root . '/App/config/routes/get.php';
        $config = require $root . '/App/config/modules/blog.php';

        foreach ([
            'es' => ['/es/blog', '/es/blog/page/{page}'],
            'eu' => ['/eu/blog', '/eu/blog/page/{page}'],
        ] as $locale => [$basePath, $pagePath]) {
            self::assertArrayHasKey($basePath, $routes[$locale]);
            self::assertArrayHasKey($pagePath, $routes[$locale]);
            self::assertSame('blog', $routes[$locale][$basePath]['resources']);
            self::assertSame('blog', $routes[$locale][$basePath]['content']);
            self::assertFalse($routes[$locale][$basePath]['session']);
            self::assertFalse($routes[$locale][$pagePath]['sitemap']);
            self::assertSame($basePath, $config['public_paths'][$locale]);
            self::assertSame(
                $pagePath,
                $config['public_index']['pagination_paths'][$locale]
            );
            self::assertFileExists(
                $root . "/App/config/languages/blog/{$locale}.json"
            );
        }

        $view = (string) file_get_contents($root . '/App/views/blog.php');
        self::assertLessThan(
            strpos($view, '<!DOCTYPE html>'),
            strpos($view, "_moduleBlogPublicIndex.php")
        );
        self::assertStringContainsString(
            "includes/_globalHead.php",
            str_replace('..', '', $view)
        );
        self::assertStringContainsString("includes/_nav.php", $view);
        self::assertStringContainsString("includes/_footer.php", $view);
        self::assertFileExists($root . '/src/js/blog.js');
        self::assertFileExists($root . '/src/scss/blog.scss');
    }
}
