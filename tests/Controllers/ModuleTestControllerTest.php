<?php

declare(strict_types=1);

use App\Core\Support\Paths;
use PHPUnit\Framework\TestCase;
use function App\Core\Support\controller;

final class ModuleTestControllerTest extends TestCase
{
    private string $originalCwd = '';

    protected function setUp(): void
    {
        $this->originalCwd = getcwd();
        Paths::setProjectRoot(dirname(__DIR__, 2));
        chdir(Paths::publicPath());
    }

    protected function tearDown(): void
    {
        chdir($this->originalCwd);
        unset($GLOBALS['moduleTest_00_h2_text'], $GLOBALS['moduleTest_00_p_text']);
    }

    public function testControllerRendersTemplateWithProvidedGlobals(): void
    {
        $GLOBALS['moduleTest_00_h2_text'] = (object) ['text' => 'Heading de prueba'];
        $GLOBALS['moduleTest_00_p_text']  = (object) ['text' => 'Copia de prueba'];

        $html = controller('moduleTest', 0, ['{test-slot}' => '<span>slot</span>']);

        self::assertStringContainsString('moduleTest_00_classVar', $html);
        self::assertStringContainsString('Heading de prueba', $html);
        self::assertStringContainsString('<span>slot</span>', $html);
    }
}
