/*
 * File: args.h
 * Description: Command-line argument processing.
 * Last modification: 2003, August 8.
 * Programmer: gse.
 *
 * Usage:
 *
 * #include "args.h"
 *
 * int main(int argc, char *argv[]) {
 *   args args(argc,argv);
 *   if(arg.exist_arg("-help") {
 *     std::cout << "...."
 *     ...
 *   }
 *
 *   if(args.exist_arg("-input")) {
 *     const char *str = arg.get_arg();
 *   }
 *
 */
class args {
  int argc;
  char **argv;
  char *ptr;
 public:
  args(int argc, char *argv[]) {
    this->argc = argc;
    this->argv = argv;
  }

  bool exist_arg(char *str_to_find);

  char *get_arg();
};
