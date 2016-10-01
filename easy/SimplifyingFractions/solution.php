<?php

# Credits go to syholloway ! Find him on -> https://www.reddit.com/user/syholloway

function reduceFraction($a, $b) {
    $gcd = gcd($a, $b);
    return [$a / $gcd, $b / $gcd];
}

function gcd($a, $b) {
    return $a > $b ? gcd($a - $b, $b) : ($a < $b ? gcd($a, $b - $a) : $a);
}

function callReduce($a) {
    return empty($a) ? '' : implode(' ', call_user_func_array('reduceFraction', explode(' ', $a, 2)));
}

echo implode("\n", array_map('callReduce', explode("\n", file_get_contents('php://stdin'))));
