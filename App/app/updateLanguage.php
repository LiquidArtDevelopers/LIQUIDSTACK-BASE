<?php

declare(strict_types=1);

$respond = static function (int $status, array $payload): void {
    header('Content-Type: application/json; charset=utf-8');
    http_response_code($status);
    echo json_encode($payload, JSON_UNESCAPED_SLASHES | JSON_UNESCAPED_UNICODE);
    exit;
};

$normalizeBool = static function ($value): bool {
    if (is_bool($value)) {
        return $value;
    }

    $filtered = filter_var($value, FILTER_VALIDATE_BOOLEAN, FILTER_NULL_ON_FAILURE);
    return $filtered ?? false;
};

$devModeEnv = $_ENV['DEV_MODE'] ?? getenv('DEV_MODE') ?? false;

if (!$normalizeBool($devModeEnv)) {
    $respond(403, [
        'status'  => 'error',
        'message' => 'Language editor is only available in development mode.',
    ]);
}

$rawInput = file_get_contents('php://input');
$data = [];

if ($rawInput !== false && $rawInput !== '') {
    $decoded = json_decode($rawInput, true);
    if (is_array($decoded)) {
        $data = $decoded;
    }
}

if (!$data && $_POST) {
    $data = $_POST;
}

$lang  = isset($data['lang']) ? trim((string) $data['lang']) : '';
$key   = isset($data['key']) ? trim((string) $data['key']) : '';
$scope = isset($data['scope']) ? trim((string) $data['scope']) : '';
$route = isset($data['route']) ? trim((string) $data['route']) : '';
$values = $data['values'] ?? null;

if ($lang === '' || $key === '') {
    $respond(400, [
        'status'  => 'error',
        'message' => 'Missing required parameters.',
    ]);
}

$targetScope = $scope === 'global' ? 'global' : ($scope !== '' ? $scope : $route);
if ($targetScope === '' || $targetScope === null) {
    $respond(400, [
        'status'  => 'error',
        'message' => 'Unable to resolve the language file scope.',
    ]);
}

$baseDir = realpath(__DIR__ . '/../config/languages');
if ($baseDir === false) {
    $respond(500, [
        'status'  => 'error',
        'message' => 'Language directory not found.',
    ]);
}

$langSanitized = preg_replace('/[^a-zA-Z0-9_-]/', '', $lang);
if ($langSanitized === '') {
    $respond(400, [
        'status'  => 'error',
        'message' => 'Invalid language identifier.',
    ]);
}

if ($targetScope === 'global') {
    $scopeDir = realpath($baseDir . '/global');
} else {
    $scopeSanitized = preg_replace('/[^a-zA-Z0-9_-]/', '', $targetScope);
    if ($scopeSanitized === '') {
        $respond(400, [
            'status'  => 'error',
            'message' => 'Invalid route identifier.',
        ]);
    }
    $scopeDir = realpath($baseDir . '/' . $scopeSanitized);
    $targetScope = $scopeSanitized;
}

if ($scopeDir === false) {
    $respond(404, [
        'status'  => 'error',
        'message' => 'Language scope not found.',
    ]);
}

$filePath = $scopeDir . '/' . $langSanitized . '.json';
if (!is_file($filePath) || !is_readable($filePath) || !is_writable($filePath)) {
    $respond(404, [
        'status'  => 'error',
        'message' => 'Language file not accessible.',
    ]);
}

$fileContents = file_get_contents($filePath);
if ($fileContents === false) {
    $respond(500, [
        'status'  => 'error',
        'message' => 'Unable to read language file.',
    ]);
}

$decodedJson = json_decode($fileContents, true);
if (!is_array($decodedJson)) {
    $decodedJson = [];
}

if (is_array($values)) {
    $normalizedValues = [];
    foreach ($values as $attr => $value) {
        if (!is_string($attr) || $attr === '') {
            continue;
        }
        if (is_scalar($value) || $value === null) {
            $normalizedValues[$attr] = $value === null ? '' : (string) $value;
        }
    }
    $decodedJson[$key] = $normalizedValues;
    $finalValue = $normalizedValues;
} else {
    $decodedJson[$key] = is_scalar($values) || $values === null ? (string) $values : '';
    $finalValue = $decodedJson[$key];
}

$encoded = json_encode($decodedJson, JSON_PRETTY_PRINT | JSON_UNESCAPED_UNICODE | JSON_UNESCAPED_SLASHES);
if ($encoded === false) {
    $respond(500, [
        'status'  => 'error',
        'message' => 'Unable to encode language file.',
    ]);
}

if (substr($encoded, -1) !== "\n") {
    $encoded .= "\n";
}

if (file_put_contents($filePath, $encoded, LOCK_EX) === false) {
    $respond(500, [
        'status'  => 'error',
        'message' => 'Unable to write language file.',
    ]);
}

$respond(200, [
    'status' => 'ok',
    'scope'  => $targetScope,
    'key'    => $key,
    'data'   => $finalValue,
]);
