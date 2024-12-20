#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <ctype.h>
#include <math.h>

// Function prototypes
int otherToDecimal(char* number, int base);
int decimalToOther(int decimal, int base);
int isValidNumber(char* number, int base);

// Maximum length for input number
#define MAX_LENGTH 100

int main() {
    int currentBase, newBase;
    char inputNumber[MAX_LENGTH];
    
    // Get the current number system (base)
    printf("Enter the current system: ");
    scanf("%d", &currentBase);
    
    // Validate current base (commonly used bases are 2-16)
    if (currentBase < 2 || currentBase > 16) {
        printf("Error: Base should be between 2 and 16\n");
        return 1;
    }
    
    // Get the number to convert
    printf("Enter the number: ");
    scanf("%s", inputNumber);
    
    // Validate input number for the given base
    if (!isValidNumber(inputNumber, currentBase)) {
        printf("Error: Invalid input for the given number system!\n");
        return 1;
    }
    
    // Get the target number system
    printf("Enter the new system: ");
    scanf("%d", &newBase);
    
    // Validate new base
    if (newBase < 2 || newBase > 16) {
        printf("Error: Base should be between 2 and 16\n");
        return 1;
    }
    
    // First convert to decimal, then to target base
    int decimal = otherToDecimal(inputNumber, currentBase);
    if (decimal == -1) {
        printf("Error: Conversion failed\n");
        return 1;
    }
    
    // Convert decimal to target base
    int result = decimalToOther(decimal, newBase);
    
    // Display result
    printf("The number in the new system: ");
    
    // For bases <= 10, print normally
    if (newBase <= 10) {
        printf("%d\n", result);
    } 
    // For bases > 10, need to handle hex digits (A-F)
    else {
        char hexResult[MAX_LENGTH];
        int index = 0;
        
        // Convert the number to hex representation
        while (result > 0) {
            int remainder = result % 10;
            hexResult[index++] = (remainder < 10) ? 
                                remainder + '0' : 
                                remainder - 10 + 'A';
            result /= 10;
        }
        
        // Print in reverse order (since we built the string backwards)
        for (int i = index - 1; i >= 0; i--) {
            printf("%c", hexResult[i]);
        }
        printf("\n");
    }
    
    return 0;
}

// Function to convert number from any base to decimal
int otherToDecimal(char* number, int base) {
    int decimal = 0;
    int power = 0;
    int len = strlen(number);
    
    // Process each digit from right to left
    for (int i = len - 1; i >= 0; i--) {
        int digit;
        
        // Convert character to numeric value
        if (isdigit(number[i])) {
            digit = number[i] - '0';
        } 
        // Handle hexadecimal letters (A-F)
        else if (isalpha(number[i])) {
            digit = toupper(number[i]) - 'A' + 10;
        } 
        else {
            return -1;  // Invalid character
        }
        
        // Check if digit is valid for given base
        if (digit >= base) {
            return -1;
        }
        
        // Add digit * base^power to result
        decimal += digit * pow(base, power);
        power++;
    }
    
    return decimal;
}

// Function to convert decimal to any base
int decimalToOther(int decimal, int base) {
    int result = 0;
    int multiplier = 1;
    
    // Keep dividing by base and use remainders
    while (decimal > 0) {
        int remainder = decimal % base;
        decimal = decimal / base;
        
        // Build result by placing digits in correct position
        result += remainder * multiplier;
        multiplier *= 10;
    }
    
    return result;
}

// Function to validate if input number is valid for given base
int isValidNumber(char* number, int base) {
    int len = strlen(number);
    
    for (int i = 0; i < len; i++) {
        int digit;
        
        // Convert character to numeric value
        if (isdigit(number[i])) {
            digit = number[i] - '0';
        } 
        // Handle hexadecimal letters
        else if (isalpha(number[i])) {
            digit = toupper(number[i]) - 'A' + 10;
        } 
        else {
            return 0;  // Invalid character
        }
        
        // Check if digit is valid for given base
        if (digit >= base) {
            return 0;
        }
    }
    
    return 1;
}
