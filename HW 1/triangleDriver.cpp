#include <stdint.h>
#include <time.h>
#include <stdio.h>

extern "C" double area();

int main()
{
    printf("Welcome to Amazing Triangles programmed Serafina Yu on February 15, 2022\n");

    double calcArea = area();
    
    printf("The driver received this number %f square units", calcArea);
    printf("An integer zero will now be sent to the operating system.  Have a good day.  Bye\n");
    return 0;

}
