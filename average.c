#include <stdio.h>
float average(int arr[], int n)
{
    int sum = 0;
    for (int i = 0; i < n; i++)
    {
        sum += arr[i];
    }
    return (float)sum / (float)n;
}

int main()
{
    int arr[10] = {1, 2, 3, 4, 5, 6, 7, 8, 9, 10};
    int arr2[10] = {7, 2, 5, 11, 4, 6, 1, 1, 8, 3};
    
    printf("%.1f \n", average(arr, 10));
    printf("%.1f \n", average(arr2, 10));
    return 0;
}
