<?php
/**
 * Directrices de copy para artMarquee01:
 * - Items por fila: 1-4 palabras en tono imperativo o declarativo.
 * - Usa frases cortas y repetibles para lectura en loop.
 */
function controller_artMarquee01(int $i = 0, array $params = []): string
{
    $pad     = sprintf('%02d', $i);
    $letters = range('a', 'z');

    $getTemplateLang = static function (string $key) {
        static $templateLang = null;

        if ($templateLang === null) {
            $lang         = $_ENV['LANG_DEFAULT'] ?? 'es';
            $file         = __DIR__ . '/../config/languages/templates/' . $lang . '.json';
            $json         = is_readable($file) ? file_get_contents($file) : '{}';
            $decoded      = json_decode($json);
            $templateLang = is_object($decoded) ? $decoded : new stdClass();
        }

        return $templateLang->{$key} ?? null;
    };

    $row1Pool = [];
    $row2Pool = [];

    foreach ($letters as $letter) {
        $row1Key = "artMarquee01_{$pad}_row1_item_{$letter}";
        $row2Key = "artMarquee01_{$pad}_row2_item_{$letter}";

        $row1Obj = $GLOBALS[$row1Key] ?? $getTemplateLang($row1Key);
        $row2Obj = $GLOBALS[$row2Key] ?? $getTemplateLang($row2Key);

        if (is_object($row1Obj)) {
            $row1Pool[] = $row1Obj;
        }

        if (is_object($row2Obj)) {
            $row2Pool[] = $row2Obj;
        }
    }

    $row1Count = isset($params['items_row1']) ? (int) $params['items_row1'] : (int) ($params['items'] ?? 0);
    $row2Count = isset($params['items_row2']) ? (int) $params['items_row2'] : 0;

    if ($row1Count === 0) {
        $row1Count = count($row1Pool);
        $row1Count = $row1Count > 0 ? $row1Count : 6;
    }

    if ($row2Count === 0) {
        $row2Count = count($row2Pool);
        $row2Count = $row2Count > 0 ? $row2Count : $row1Count;
    }

    $row1Count = max(0, min($row1Count, count($letters)));
    $row2Count = max(0, min($row2Count, count($letters)));

    unset($params['items'], $params['items_row1'], $params['items_row2']);

    $itemTpl = '<span class="marquee-item" data-lang="{X-dl}">{X-text}</span>';

    $row1Items = '';
    for ($index = 0; $index < $row1Count; $index++) {
        $letter = $letters[$index];
        $key    = "artMarquee01_{$pad}_row1_item_{$letter}";
        $obj    = $GLOBALS[$key] ?? $getTemplateLang($key);

        if (!is_object($obj) && count($row1Pool) > 0) {
            $obj = $row1Pool[$index % count($row1Pool)];
        }
        if (!is_object($obj)) {
            $obj = (object) ['text' => ''];
        }

        $row1Items .= str_replace(
            ['{X-dl}', '{X-text}'],
            [$key, $obj->text ?? ''],
            $itemTpl
        );
    }

    $row2Items = '';
    for ($index = 0; $index < $row2Count; $index++) {
        $letter = $letters[$index];
        $key    = "artMarquee01_{$pad}_row2_item_{$letter}";
        $obj    = $GLOBALS[$key] ?? $getTemplateLang($key);

        if (!is_object($obj) && count($row2Pool) > 0) {
            $obj = $row2Pool[$index % count($row2Pool)];
        }
        if (!is_object($obj)) {
            $obj = (object) ['text' => ''];
        }

        $row2Items .= str_replace(
            ['{X-dl}', '{X-text}'],
            [$key, $obj->text ?? ''],
            $itemTpl
        );
    }

    $vars = [
        '{classVar}'   => "artMarquee01_{$pad}_classVar",
        '{row1-items}' => $row1Items,
        '{row2-items}' => $row2Items,
    ];

    $vars = array_replace($vars, $params);

    return render('App/templates/_artMarquee01.html', $vars);
}
?>
