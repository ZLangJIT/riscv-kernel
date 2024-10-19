#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int main(int argc, const char** argv) {
   FILE *fp;
   char *line = NULL;
   size_t len = 0;
   ssize_t read;
   fp = fopen(argv[1], "r");
   if (fp == NULL)
       exit(1);
   while ((read = getline(&line, &len, fp)) != -1) {
       if (read >= 7 && memcmp(line, "CONFIG_", 7) == 0)
         printf("%s", line);
   }
   if (ferror(fp)) {
       /* handle error */
       printf("an error has occured\n");
   }
   free(line);
   fclose(fp);
   return 0;
}