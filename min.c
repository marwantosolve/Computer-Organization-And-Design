#include <stdio.h>
int min(int arr[], int n)
{
    int min = arr[0];
    for (int i = 1; i < n; i++)
    {
        if (arr[i] < min)
        {
            min = arr[i];
        }
    }
    return min;
}

int main() {
    int arr[10] = {10, 31, 5, 7, 11, 3, 8, 40, 12, 4};
    int arr2[10] = {11, 2, 3, 7, 5, 10, 9, 22, 6, 1};
    printf("%d \n", min(arr, 10));
    printf("%d \n", min(arr2, 10));
    return 0;
}
