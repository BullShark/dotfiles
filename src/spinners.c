// spinners.c
#include <stdio.h>
#include <unistd.h>

void main() {
  float time_to_sleep = 0.80;
  int counter = 0;
  while(1) {
    printf("\b%c", "\\|/-"[counter%4]);
    fflush(stdout);
    sleep(time_to_sleep);
    counter++;
  }
}
