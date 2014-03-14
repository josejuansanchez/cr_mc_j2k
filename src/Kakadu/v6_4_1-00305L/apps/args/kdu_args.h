/*****************************************************************************/
// File: kdu_args.h [scope = APPS/ARGS]
// Version: Kakadu, V6.4.1
// Author: David Taubman
// Last Revised: 6 October, 2010
/******************************************************************************/
// Copyright 2001, David Taubman, The University of New South Wales (UNSW)
// The copyright owner is Unisearch Ltd, Australia (commercial arm of UNSW)
// Neither this copyright statement, nor the licensing details below
// may be removed from this file or dissociated from its contents.
/******************************************************************************/
// Licensee: University of Almeria
// License number: 00305
// The licensee has been granted a UNIVERSITY LIBRARY license to the
// contents of this source file.  A brief summary of this license appears
// below.  This summary is not to be relied upon in preference to the full
// text of the license agreement, accepted at purchase of the license.
// 1. The License is for University libraries which already own a copy of
//    the book, "JPEG2000: Image compression fundamentals, standards and
//    practice," (Taubman and Marcellin) published by Kluwer Academic
//    Publishers.
// 2. The Licensee has the right to distribute copies of the Kakadu software
//    to currently enrolled students and employed staff members of the
//    University, subject to their agreement not to further distribute the
//    software or make it available to unlicensed parties.
// 3. Subject to Clause 2, the enrolled students and employed staff members
//    of the University have the right to install and use the Kakadu software
//    and to develop Applications for their own use, in their capacity as
//    students or staff members of the University.  This right continues
//    only for the duration of enrollment or employment of the students or
//    staff members, as appropriate.
// 4. The enrolled students and employed staff members of the University have the
//    right to Deploy Applications built using the Kakadu software, provided
//    that such Deployment does not result in any direct or indirect financial
//    return to the students and staff members, the Licensee or any other
//    Third Party which further supplies or otherwise uses such Applications.
// 5. The Licensee, its students and staff members have the right to distribute
//    Reusable Code (including source code and dynamically or statically linked
//    libraries) to a Third Party, provided the Third Party possesses a license
//    to use the Kakadu software, and provided such distribution does not
//    result in any direct or indirect financial return to the Licensee,
//    students or staff members.  This right continues only for the
//    duration of enrollment or employment of the students or staff members,
//    as appropriate.
/******************************************************************************
Description:
   Defines handy services for command-line argument processing.
******************************************************************************/

#ifndef KDU_ARGS_H
#define KDU_ARGS_H

#include <stdlib.h>
#include <assert.h>
#include "kdu_elementary.h"

/*****************************************************************************/
/*                                 kdu_args                                  */
/*****************************************************************************/

class kdu_args {
  /* [SYNOPSIS]
       This object provides a convenient set of utilities for digesting
       and processing command-line arguments.  Its convenient features
       include the ability to search for an argument, automatic inclusion
       of arguments from switch files, and detection and reporting of
       unused arguments.
  */
  public: // Member functions
    kdu_args(int argc, char *argv[], const char *switch_pattern = NULL);
      /* [SYNOPSIS]
           Transfers command-line arguments into the internal representation.
           The `argc' and `argv' arguments have identical interpretations to
           the usual arguments supplied to the "C" or "C++" `main' function.
           Note that local copies are made for all of the argument strings
           in the `argv' array.
         [ARG: argc]
           Total number of elements in the `argv' array.
         [ARG: argv]
           Array of character strings.  The first string (argv[0]) is
           expected to hold the program name, while subsequent strings
           correspond to successive arguments.
         [ARG: switch_pattern]
           May be used to identify a particular argument string (usually
           "-s", for "switch") which will be recognized as a request to
           recover additional arguments from a file.  If this pattern is
           found in the list of command line arguments, the next argument
           will be interpreted as the file name and each token in the file
           becomes a new argument, where tokens are delimited by white
           space characters (spaces, new-lines, tabs and carriage returns).
      */
    ~kdu_args();
    char *get_prog_name() { return prog_name; }
      /* [SYNOPSIS]
           Returns a pointer to an internal copy of the first
           string in the `argv' array supplied to the constructor.
           As explained in the description of `kdu_args::kdu_args', this
           is expected to be the name of the program.
      */
    char *get_first();
      /* [SYNOPSIS]
           Returns NULL if there are no arguments left.  Otherwise returns
           the first argument which has not yet been removed, where "first"
           refers to the order of appearance of the arguments in the original
           list.
      */
    char *find(const char *pattern);
      /* [SYNOPSIS]
           Returns NULL unless an argument matching the supplied `pattern'
           string can be found, in which it returns a pointer to the internal
           copy of this argument string.  Currently, only direct string
           matching on the `pattern' string is supported.
           [//]
           Note carefully that the returned string points to an internal
           resource, which might be deleted by the `advance' function.
      */
    char *advance(bool remove_last=true);
      /* [SYNOPSIS]
           Advances to the next argument.  If `remove_last' is true, the most
           recent argument returned via any of `get_first', `find' or
           `advance' is deleted.
           [//]
           The function returns NULL if we try to advance past the last
           argument, or if the most recent call to `get_first', `find' or
           `advance' returned NULL.
      */
    int show_unrecognized(kdu_message &out);
      /* [SYNOPSIS]
           Warns the user of any arguments which have not been deleted
           (arguments are deleted only by the `advance' function),
           presumably because they were not recognized.  The warning
           messages are sent to the `out' object.  The function returns
           a count of the total number of unrecognized arguments.
      */
  private: // Convenience functions
    void new_arg(const char *string);
  private: // Data
    char *prog_name;
    struct kd_arg_list *first, *current, *prev, *removed;
  };

#endif // KDU_ARGS_H
