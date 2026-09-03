#include <stdio.h>

// C written in a way that is easier to translate to Assembly arm7

int main(void)
{
    char input[100];

    int length;
    int left;
    int right;
    int palindrome;

    printf("Enter a string: ");
    fgets(input, 100, stdin);

    /* Find string length manually */
    length = 0;

    while (input[length] != '\0' && input[length] != '\n')
    {
        length++;
    }

    /* Remove newline */
    input[length] = '\0';

    if (length < 4)
    {
        printf("Input must contain at least four characters.\n");
        return 1;
    }

    left = 0;
    right = length - 1;
    palindrome = 1;

    while (left < right)
    {
        /* Skip spaces on left */
        while (input[left] == ' ')
        {
            left++;
        }

        /* Skip spaces on right */
        while (input[right] == ' ')
        {
            right--;
        }

        char a = input[left];
        char b = input[right];

        /* Convert uppercase letters to lowercase */
        if (a >= 'A' && a <= 'Z')
        {
            a = a + 32;
        }

        if (b >= 'A' && b <= 'Z')
        {
            b = b + 32;
        }

        /* Wildcards match any non-space character */
        if (a == '?' || a == '%' ||
            b == '?' || b == '%')
        {
            left++;
            right--;
            continue;
        }

        if (a != b)
        {
            palindrome = 0;
            break;
        }

        left++;
        right--;
    }

    if (palindrome == 1)
    {
        printf("Palindrome\n");
    }
    else
    {
        printf("Not a palindrome\n");
    }

    return 0;
}