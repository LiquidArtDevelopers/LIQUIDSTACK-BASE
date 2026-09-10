<?php
/**
 * Directrices de copy para sectionParticles02:
 * - Encabezado principal: 3-8 palabras.
 * - Texto descriptivo: 14-30 palabras.
 * - CTA opcional (si se inyecta en {content}): 2-4 palabras.
 */
function controller_sectionParticles02(int $i = 0, array $params = []): string
{
    $pad = sprintf('%02d', $i);

    $headerLevels = resolve_header_levels($params, '{header-primary}', 2);
    $baseLevel = $headerLevels['base'];

    $titleKey = "sectionParticles02_{$pad}_headerPrimary";
    $textKey = "sectionParticles02_{$pad}_p";

    $titleObj = $GLOBALS[$titleKey] ?? null;
    $textObj = $GLOBALS[$textKey] ?? null;

    $titleText = is_object($titleObj) && isset($titleObj->text)
        ? trim((string) $titleObj->text)
        : '';
    $textText = is_object($textObj) && isset($textObj->text)
        ? trim((string) $textObj->text)
        : '';

    if ($titleText === '') {
        $titleText = 'Gravedad que curva la luz';
    }
    if ($textText === '') {
        $textText = 'Campo estelar en tiempo real con lente gravitatoria reactiva al raton y micro giros del horizonte para un fondo atmosferico, sobrio y tecnologico.';
    }

    $defaultContent = '<h' . $baseLevel . ' class="sectionParticles02-title" data-lang="' . $titleKey . '">'
        . $titleText
        . '</h' . $baseLevel . '>'
        . '<p class="sectionParticles02-text" data-lang="' . $textKey . '">'
        . $textText
        . '</p>';

    $vars = [
        '{classVar}' => "sectionParticles02_{$pad}_classVar",
        '{content}' => $defaultContent,
    ];

    $configPlaceholders = [
        '{black-hole-mass}',
        '{gravitational-lensing}',
        '{doppler-strength}',
        '{disk-inner-radius}',
        '{disk-outer-radius}',
        '{disk-brightness}',
        '{disk-temperature}',
        '{temperature-falloff}',
        '{disk-edge-softness-inner}',
        '{disk-edge-softness-outer}',
        '{turbulence-scale}',
        '{turbulence-stretch}',
        '{turbulence-sharpness}',
        '{disk-rotation-speed}',
        '{turbulence-cycle-time}',
        '{turbulence-lacunarity}',
        '{turbulence-persistence}',
        '{stars-enabled}',
        '{star-background-color}',
        '{star-density}',
        '{star-size}',
        '{star-brightness}',
        '{star-drift}',
        '{nebula-enabled}',
        '{nebula1-scale}',
        '{nebula1-density}',
        '{nebula1-brightness}',
        '{nebula1-color}',
        '{nebula2-scale}',
        '{nebula2-density}',
        '{nebula2-brightness}',
        '{nebula2-color}',
        '{bloom-strength}',
        '{bloom-radius}',
        '{bloom-threshold}',
        '{step-size}',
        '{lens-chroma}',
        '{hole-x}',
        '{hole-y}',
        '{mouse-influence}',
    ];

    foreach ($configPlaceholders as $placeholder) {
        $vars[$placeholder] = '';
    }

    if (isset($params['content'])) {
        $vars['{content}'] = (string) $params['content'];
        unset($params['content']);
    }
    if (isset($params['{content}'])) {
        $vars['{content}'] = (string) $params['{content}'];
        unset($params['{content}']);
    }

    $vars = array_replace($vars, $params);

    return render('App/templates/_sectionParticles02.html', $vars);
}
?>
