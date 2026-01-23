<?php
/**
 * Directrices de copy para sectionParticles01:
 * - Contenido opcional: titulo 3-6 palabras, texto 12-20 palabras.
 * - CTA (si aplica): 2-4 palabras.
 */
function controller_sectionParticles01(int $i = 0, array $params = []): string
{
    $pad = sprintf('%02d', $i);

    $vars = [
        '{classVar}'         => "sectionParticles01_{$pad}_classVar",
        '{content}'          => '',
        '{particles-count}'       => '20000',
        '{particles-bg-count}'    => '8000',
        '{particles-size}'        => '1.5',
        '{particles-radius}'      => '28',
        '{particles-depth}'       => '20',
        '{particles-speed}'       => '0.75',
        '{particles-shape-ratio}' => '0.88',
        '{particles-shape-scale}' => '0.8',
        '{particles-step-vh}'      => '100',
    ];

    $vars = array_replace($vars, $params);

    return render('App/templates/_sectionParticles01.html', $vars);
}
?>
