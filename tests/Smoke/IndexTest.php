<?php

declare(strict_types=1);

use PHPUnit\Framework\TestCase;

final class IndexTest extends TestCase
{
    private array $originalServer = [];
    private array $originalEnv = [];
    private string $originalCwd = '';

    protected function setUp(): void
    {
        $this->originalServer = $_SERVER;
        $this->originalEnv = $_ENV;
        $this->originalCwd = getcwd();

        chdir(__DIR__ . '/../../public');
    }

    protected function tearDown(): void
    {
        $_SERVER = $this->originalServer;
        $_ENV = $this->originalEnv;
        chdir($this->originalCwd);
    }

    public function testIndexSmokeRequestRendersHtml(): void
    {
        $_SERVER['REQUEST_METHOD'] = 'GET';
        $_SERVER['REQUEST_URI'] = '/es/templates';
        $_SERVER['HTTP_ACCEPT_LANGUAGE'] = 'es';
        $_SERVER['QUERY_STRING'] = '';

        $_ENV['RAIZ'] = 'http://localhost:3000';
        $_ENV['LANG_DEFAULT'] = 'es';
        $_ENV['MULTILANG'] = '0';
        $_ENV['ES_SIMPLIFICADO'] = '0';
        $_ENV['DEV_MODE'] = '1';
        $_ENV['DISPLAY_ERROR'] = '1';
        $_ENV['VITE_BUSINESS_NAME'] = 'Bazkide Test';

        $output = $this->runIndex();

        self::assertNotSame('', $output);
        self::assertStringContainsString('<!DOCTYPE html>', $output);
    }

    private function runIndex(): string
    {
        ob_start();
        include __DIR__ . '/../../public/index.php';
        return ob_get_clean() ?: '';
    }
}
