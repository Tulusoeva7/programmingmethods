import java.util.Arrays;
import java.util.Comparator;

public class Main {
    public static void main(String[] args) {
        int[] arr = {2, 47, 0, 77, 80, 0, 11, 18, 0};

        sortArray(arr);

        System.out.println(Arrays.toString(arr));
    }

    public static void sortArray(int[] arr) {
        Integer[] evenNumbers = new Integer[arr.length];
        Integer[] oddNumbers = new Integer[arr.length];
        int evenIndex = 0, oddIndex = 0;

        for (int num : arr) {
            if (num == 0) continue;
            if (num % 2 == 0) {
                evenNumbers[evenIndex++] = num;
            } else {
                oddNumbers[oddIndex++] = num;
            }
        }

        Arrays.sort(evenNumbers, 0, evenIndex, (a, b) -> b - a);
        Arrays.sort(oddNumbers, 0, oddIndex, (a, b) -> a - b);

        evenIndex = 0;
        oddIndex = 0;
        for (int i = 0; i < arr.length; i++) {
            if (arr[i] == 0) {
                continue;
            } else if (arr[i] % 2 == 0) {
                arr[i] = evenNumbers[evenIndex++];
            } else {
                arr[i] = oddNumbers[oddIndex++];
            }
        }
    }
}
