<?php
// Script temporal para optimizar el logo (redimensionar y comprimir).
$src = 'C:/xampp/htdocs/don_pan/public/img/logo.png';
$dst = 'C:/xampp/htdocs/don_pan/public/img/logo_opt.png';

$info = getimagesize($src);
echo "Original: {$info[0]}x{$info[1]}, mime={$info['mime']}\n";

$img = imagecreatefrompng($src);
$w = 128;
$h = (int)($info[1] * ($w / $info[0]));
$res = imagecreatetruecolor($w, $h);
imagecopyresampled($res, $img, 0, 0, 0, 0, $w, $h, $info[0], $info[1]);

// Preservar transparencia
imagesavealpha($res, true);
imagepng($res, $dst, 9);
echo "Optimizada: {$w}x{$h} -> " . filesize($dst) . " bytes\n";
echo "OK\n";
