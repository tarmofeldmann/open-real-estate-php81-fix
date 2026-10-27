// references.php line 16 fix
// VANA: $$item['style']++;
// UUS:
$styleVar = $item['style'];
if (is_string($styleVar)) {
    ${$styleVar}++;
}
