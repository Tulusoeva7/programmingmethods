package main

import (
	"fmt"
	"math"
)


func polynomial(x float64, coefficients []float64) float64 {
	sum := 0.0
	n := len(coefficients)
	for i, coef := range coefficients {
		power := float64(n - 1 - i)
		sum += coef * math.Pow(x, power)
	}
	return sum
}

// Метод бисекции для уточнения корня на отрезке [a, b]
func findRoot(a, b, precision float64, coefficients []float64) float64 {
	for math.Abs(b-a) > precision {
		c := (a + b) / 2.0
		fa := polynomial(a, coefficients)
		fc := polynomial(c, coefficients)

		if fa*fc <= 0 {
			b = c
		} else {
			a = c
		}
	}
	return (a + b) / 2.0
}


func solve(rng [2]float64, precision float64, coefficients ...float64) []float64 {
	roots := []float64{}
	step := (rng[1] - rng[0]) / 100.0

	for x := rng[0]; x < rng[1]; x += step {
		xNext := x + step
		y := polynomial(x, coefficients)
		yNext := polynomial(xNext, coefficients)

		if y*yNext <= 0 {
			root := findRoot(x, xNext, precision, coefficients)
			rounded := math.Round(root*math.Pow(10, -math.Log10(precision))) / math.Pow(10, -math.Log10(precision))
			// Проверка на уникальность корня
			isUnique := true
			for _, r := range roots {
				if math.Abs(r-rounded) < precision {
					isUnique = false
					break
				}
			}
			if isUnique {
				roots = append(roots, rounded)
			}
		}
	}
	return roots
}

func main() {
	fmt.Println("Пример 1: x^2 - x - 6 = 0")
	result1 := solve([2]float64{-5, 5}, 0.0001, 1, -1, -6)
	fmt.Printf("Найденные корни: %v\n", result1)
	fmt.Println("Ожидаемый результат: [-2, 3]\n")

	fmt.Println("Пример 2: x^3 = 0")
	result2 := solve([2]float64{-5, 5}, 0.0001, 1, 0, 0, 0)
	fmt.Printf("Найденные корни: %v\n", result2)
	fmt.Println("Ожидаемый результат: [0]")
}
