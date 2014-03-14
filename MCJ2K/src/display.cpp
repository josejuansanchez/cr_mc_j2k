void info(const char *args, ...) {
  va_list ap;
  va_start(ap, args);
  vfprintf(stdout, args, ap);
  fflush(stdout);
}

void error(const char *args, ...) {
  va_list ap;
  va_start(ap, args);
  fprintf(stderr,"[0;32m");
  vfprintf(stderr, args, ap);
  fprintf(stderr,"[1;0m");
  fflush(stderr);
}

void info_flush() {
  fflush(stdout);
}

void error_flush() {
  fflush(stderr);
}
