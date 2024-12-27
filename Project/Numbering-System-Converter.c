#include <ctype.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define BUFFER_LENGTH 50

char inputBuffer[BUFFER_LENGTH];
char outputBuffer[BUFFER_LENGTH];
int currentSys = 10;
int newSys = 10;

void validateInput(const char* input, int base) {
  for (int i = 0; input[i] && input[i] != '\n'; i++) {
    char c = toupper(input[i]);
    int value;

    if (isdigit(c)) {
      value = c - '0';
    } else if (isalpha(c)) {
      value = c - 'A' + 10;
    } else {
      continue;
    }

    if (value >= base) {
      printf("Error: Invalid number for the system!\n");
      exit(1);
    }
  }
}

void validateSystem(int system) {
  if (system < 2 || system > 16) {
    printf("Error: Invalid system, valid systems are [2, 16]\n");
    exit(1);
  }
}

void copyBuffer(char* source, char* dest) { strcpy(dest, source); }

void decimalToOther(const char* input, int newBase, char* output) {
  int decimal = atoi(input);
  int index = 0;
  char temp[BUFFER_LENGTH];

  while (decimal > 0) {
    int remainder = decimal % newBase;
    temp[index++] = remainder < 10 ? remainder + '0' : remainder + 'A' - 10;
    decimal /= newBase;
  }
  temp[index] = '\0';

  // Reverse the string
  for (int i = 0; i < index / 2; i++) {
    char t = temp[i];
    temp[i] = temp[index - 1 - i];
    temp[index - 1 - i] = t;
  }

  strcpy(output, temp);
  if (index == 0) {
    output[0] = '0';
    output[1] = '\0';
  }
}

void otherToDecimal(const char* input, int currentBase, char* output) {
  int decimal = 0;
  int len = strlen(input);

  for (int i = 0; input[i] && input[i] != '\n'; i++) {
    char c = toupper(input[i]);
    int value;

    if (isdigit(c)) {
      value = c - '0';
    } else if (isalpha(c)) {
      value = c - 'A' + 10;
    } else {
      continue;
    }

    decimal = decimal * currentBase + value;
  }

  sprintf(output, "%d", decimal);
}

int main() {
  printf("Enter the current system: ");
  scanf("%d", &currentSys);
  validateSystem(currentSys);

  printf("Enter the number: ");
  scanf(" %s", inputBuffer);
  validateInput(inputBuffer, currentSys);

  printf("Enter the new system: ");
  scanf("%d", &newSys);
  validateSystem(newSys);

  if (currentSys == newSys) {
    copyBuffer(inputBuffer, outputBuffer);
  } else if (currentSys == 10) {
    decimalToOther(inputBuffer, newSys, outputBuffer);
  } else if (newSys == 10) {
    otherToDecimal(inputBuffer, currentSys, outputBuffer);
  } else {
    otherToDecimal(inputBuffer, currentSys, outputBuffer);
    strcpy(inputBuffer, outputBuffer);
    decimalToOther(inputBuffer, newSys, outputBuffer);
  }

  printf("--------------------------------------\n");
  printf("The number in the new system: %s\n", outputBuffer);

  return 0;
}