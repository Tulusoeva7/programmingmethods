<?php
//Задание 1
echo "ЗАДАНИЕ 1: Генератор чисел Фибоначчи \n";

function createFib($a, $b) {
    return function() use (&$a, &$b) {
        $result = $a + $b;
        $a = $b;
        $b = $result;
        return $result;
    };
}

echo "Генератор fibA (1, 1):\n";
$fibA = createFib(1, 1);
echo $fibA() . "\n";
echo $fibA() . "\n";
echo $fibA() . "\n";

echo "\nГенератор fibB (0, 2):\n";
$fibB = createFib(0, 2);
echo $fibB() . "\n";
echo $fibB() . "\n";
echo $fibB() . "\n";
echo $fibB() . "\n";

//Задание 2
echo "\nЗАДАНИЕ 2: Генератор случайных чисел от 0 до 10\n";

function createRandom() {
    $numbers = range(0, 10);
    shuffle($numbers);
    return function() use (&$numbers) { 
        if (empty($numbers)) {
            return false;
        }
        return array_pop($numbers);
    };
}

$rnd = createRandom(); 
for ($i = 0; $i < 12; $i++) {
    $value = $rnd();
    if ($value === false) {
        echo "Больше нет уникальных чисел.\n";
    } else {
        echo $value . "\n";
    }
}
?>
