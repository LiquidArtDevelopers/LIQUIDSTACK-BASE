<?php

declare(strict_types=1);

namespace LiquidStackBase;

use Composer\IO\IOInterface;
use Composer\Script\Event;
use RuntimeException;

final class ReleaseScript
{
    public static function run(Event $event): bool
    {
        require_once __DIR__ . '/release.php';

        $io = $event->getIO();

        return \baseReleaseMain(
            $event->getArguments(),
            static function (
                string $message,
                string $default
            ) use ($io): string {
                self::assertInteractive($io);
                $answer = $io->ask($message, $default);

                return is_string($answer) ? $answer : $default;
            },
            static function (string $message) use ($io): bool {
                self::assertInteractive($io);

                return $io->askConfirmation($message, true);
            }
        ) === 0;
    }

    private static function assertInteractive(IOInterface $io): void
    {
        if ($io->isInteractive()) {
            return;
        }

        throw new RuntimeException(
            'No hay una consola interactiva. Usa --version, --description '
                . 'y --yes en automatizaciones.'
        );
    }
}
