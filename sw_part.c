#include <stdio.h>
#include <stdlib.h>

// Comparator for descending order
int cmpfunc (const void * a, const void * b) {
    return (*(int*)b - *(int*)a);
}

int main() {
    int total_inputs, i, j;

    printf("Enter total number of inputs (>200, multiple of 10): ");
    scanf("%d", &total_inputs);

    if (total_inputs < 200 || total_inputs % 10 != 0) {
        printf("Input must be >= 200 and divisible by 10.\n");
        return 1;
    }

    int arr[total_inputs];

    printf("\nEnter %d numbers:\n", total_inputs);
    for (i = 0; i < total_inputs; i++) {
        scanf("%d", &arr[i]);
    }

    // Open file for writing pairs only
    FILE *fp = fopen("pairs.txt", "w");
    if (fp == NULL) {
        printf("Error opening file!\n");
        return 1;
    }

    // Process in batches of 10
    int batch[10];
    int batch_num = 1;
    for (i = 0; i < total_inputs; i += 10) {
        // Copy 10 numbers into batch
        for (j = 0; j < 10; j++) {
            batch[j] = arr[i + j];
        }

        // Sort batch in descending order
        qsort(batch, 10, sizeof(int), cmpfunc);

        // Print sorted batch (console only for checking)
        printf("\nBatch %d sorted (descending): ", batch_num);
        for (j = 0; j < 10; j++) {
            printf("%d ", batch[j]);
        }
        printf("\n");

        // Write only pairs to file
        for (j = 0; j < 9; j++) {
            fprintf(fp, "%d %d\n", batch[j], batch[j+1]);
        }

        batch_num++;
    }

    fclose(fp);
    printf("\nPairs saved to pairs.txt\n");

    return 0;
}
