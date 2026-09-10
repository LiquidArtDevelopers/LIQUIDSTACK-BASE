<?php
/**
 * Extensiones locales del showroom de LIQUIDSTACK-BASE.
 *
 * CORE no gestiona este fichero. Cada demo experimental debe limitarse a su
 * categoría para no bloquear la actualización del catálogo canónico.
 */
if (($showroomCategory ?? null) !== 'particles') {
    return;
}

// sectionParticles02 (controles expuestos en el sniper)
// BLACK HOLE
// - {black-hole-mass}: 0.1 - 3.0
// - {gravitational-lensing}: 0.5 - 3.0
// - {doppler-strength}: 0 - 2.0
// GEOMETRY
// - {disk-inner-radius}: 2 - 5
// - {disk-outer-radius}: 6 - 20
// APPEARANCE
// - {disk-brightness}: 0.5 - 5
// - {disk-temperature}: 1 - 50
// - {temperature-falloff}: 0.25 - 15
// - {disk-edge-softness-inner}: 0 - 0.5
// - {disk-edge-softness-outer}: 0 - 0.5
// TURBULENCE
// - {turbulence-scale}: 0.1 - 2
// - {turbulence-stretch}: 0.1 - 10
// - {turbulence-sharpness}: 0.1 - 10
// - {disk-rotation-speed}: -20 - 20
// - {turbulence-cycle-time}: 5 - 30
// - {turbulence-lacunarity}: 1 - 4
// - {turbulence-persistence}: 0.1 - 1
// STARS
// - {stars-enabled}: true/false
// - {star-background-color}: color hex
// - {star-density}: 0.001 - 0.1
// - {star-size}: 0.5 - 5
// - {star-brightness}: 0.1 - 3
// - {star-drift}: -1.5 - 1.5
// NEBULA
// - {nebula-enabled}: true/false
// - {nebula1-scale}: 0.5 - 10
// - {nebula1-density}: -1 - 1
// - {nebula1-brightness}: 0 - 1
// - {nebula1-color}: color hex
// - {nebula2-scale}: 0.5 - 20
// - {nebula2-density}: -1 - 1
// - {nebula2-brightness}: 0 - 1
// - {nebula2-color}: color hex
// BLOOM
// - {bloom-strength}: 0 - 3
// - {bloom-radius}: 0 - 1
// - {bloom-threshold}: 0 - 1
// EXTRA
// - {step-size}: 0.2 - 3
// - {lens-chroma}: 0 - 1
// - {hole-x}: 0.08 - 0.92
// - {hole-y}: 0.08 - 0.92
// - {mouse-influence}: 0 - 0.2
// Resumen: black hole con controles equivalentes al ejemplo de referencia.
// Se mantiene desactivado hasta completar sus claves dummy y validación.
// echo controller('sectionParticles02', 0, [
//     '{black-hole-mass}' => '0.4',
//     '{gravitational-lensing}' => '2.4',
//     '{doppler-strength}' => '1.0',
//     '{disk-inner-radius}' => '4.1',
//     '{disk-outer-radius}' => '14.5',
//     '{disk-brightness}' => '5',
//     '{disk-temperature}' => '50.0',
//     '{temperature-falloff}' => '5.22',
//     '{disk-edge-softness-inner}' => '0.18',
//     '{disk-edge-softness-outer}' => '0.5',
//     '{turbulence-scale}' => '1.81',
//     '{turbulence-stretch}' => '0.75',
//     '{turbulence-sharpness}' => '7.4',
//     '{disk-rotation-speed}' => '-8.7',
//     '{turbulence-cycle-time}' => '5.0',
//     '{turbulence-lacunarity}' => '3.0',
//     '{turbulence-persistence}' => '0.8',
//     '{stars-enabled}' => 'true',
//     '{star-background-color}' => '#020816',
//     '{star-density}' => '0.12',
//     '{star-size}' => '1.35',
//     '{star-brightness}' => '0.12',
//     '{star-drift}' => '0.04',
//     '{nebula-enabled}' => 'true',
//     '{nebula1-scale}' => '2.3',
//     '{nebula1-density}' => '0.65',
//     '{nebula1-brightness}' => '0.12',
//     '{nebula1-color}' => '#153f77',
//     '{nebula2-scale}' => '6.2',
//     '{nebula2-density}' => '0.18',
//     '{nebula2-brightness}' => '0.26',
//     '{nebula2-color}' => '#0d1d3d',
//     '{bloom-strength}' => '0.68',
//     '{bloom-radius}' => '0.20',
//     '{bloom-threshold}' => '0.40',
//     '{step-size}' => '1.0',
//     '{lens-chroma}' => '0.16',
//     '{hole-x}' => '0.68',
//     '{hole-y}' => '0.52',
//     '{mouse-influence}' => '0.06',
// ]);
