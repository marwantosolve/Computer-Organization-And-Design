#include <stdio.h>
int countEven(int arr[], int n)
{
    int count = 0;
    for (int i = 0; i < n; i++)
    {
        if (arr[i] % 2 == 0)
        {
            count++;
        }
    }
    return count;
}

int main()
{
    int arr[10] = {10, 31, 5, 7, 11, 3, 8, 40, 12, 4};
    int arr2[10] = {19, 2, 3, 7, 5, 10, 9, 0, 6, 1};
    printf("%d \n", countEven(arr, 10));
    printf("%d \n", countEven(arr2, 10));
    return 0;
}
