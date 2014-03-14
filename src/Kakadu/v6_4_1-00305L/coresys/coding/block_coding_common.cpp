/*****************************************************************************/
// File: block_coding_common.cpp [scope = CORESYS/CODING]
// Version: Kakadu, V6.4.1
// Author: David Taubman
// Last Revised: 6 October, 2010
/*****************************************************************************/
// Copyright 2001, David Taubman, The University of New South Wales (UNSW)
// The copyright owner is Unisearch Ltd, Australia (commercial arm of UNSW)
// Neither this copyright statement, nor the licensing details below
// may be removed from this file or dissociated from its contents.
/*****************************************************************************/
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
   Implements common elements of the block encoder and block decoder.  In
particular, sets up lookup tables for efficient generation of significance
and sign coding context labels, based on the context word structure defined
in "block_coding_common.h".
******************************************************************************/

#include <assert.h>
#include "block_coding_common.h"

kdu_byte hl_sig_lut[512];
kdu_byte lh_sig_lut[512];
kdu_byte hh_sig_lut[512];
kdu_byte sign_lut[256];

static void initialize_significance_luts();
static void initialize_sign_lut();
static class coding_common_local_init {
    public: coding_common_local_init()
              { initialize_significance_luts();
                initialize_sign_lut(); }
  } _do_it;

/*****************************************************************************/
/* STATIC                initialize_significance_luts                        */
/*****************************************************************************/

void
  initialize_significance_luts()
{
  kdu_int32 idx, kappa, v1, v2, v3;

  for (idx=0; idx < 512; idx++)
    {
      // Start with the context map for the HL (horizontally high-pass) band

      v1 = ((idx>>SIGMA_TC_POS)&1) + ((idx>>SIGMA_BC_POS)&1);
      v2 = ((idx>>SIGMA_CL_POS)&1) + ((idx>>SIGMA_CR_POS)&1);
      v3 = ((idx>>SIGMA_TL_POS)&1) + ((idx>>SIGMA_TR_POS)&1) +
           ((idx>>SIGMA_BL_POS)&1) + ((idx>>SIGMA_BR_POS)&1);
      if (v1 == 2)
        kappa = 8;
      else if (v1 == 1)
        {
          if (v2)
            kappa = 7;
          else if (v3)
            kappa = 6;
          else
            kappa = 5;
        }
      else
        {
          if (v2)
            kappa = 2+v2;
          else
            kappa = 0 + ((v3>2)?2:v3);
        }
      hl_sig_lut[idx] = (kdu_byte) kappa;
    
    //  Now build the context map for the LH (vertically high-pass) band

      v1 = ((idx>>SIGMA_CL_POS)&1) + ((idx>>SIGMA_CR_POS)&1);
      v2 = ((idx>>SIGMA_TC_POS)&1) + ((idx>>SIGMA_BC_POS)&1);
      v3 = ((idx>>SIGMA_TL_POS)&1) + ((idx>>SIGMA_TR_POS)&1) +
           ((idx>>SIGMA_BL_POS)&1) + ((idx>>SIGMA_BR_POS)&1);
      if (v1 == 2)
        kappa = 8;
      else if (v1 == 1)
        {
          if (v2)
            kappa = 7;
          else if (v3)
            kappa = 6;
          else
            kappa = 5;
        }
      else
        {
          if (v2)
            kappa = 2+v2;
          else
            kappa = 0 + ((v3>2)?2:v3);
        }
      lh_sig_lut[idx] = (kdu_byte) kappa;
      
      // Finally, build the context map for the HH band

      v1 = ((idx>>SIGMA_TL_POS)&1) + ((idx>>SIGMA_TR_POS)&1) +
           ((idx>>SIGMA_BL_POS)&1) + ((idx>>SIGMA_BR_POS)&1);
      v2 = ((idx>>SIGMA_CL_POS)&1) + ((idx>>SIGMA_CR_POS)&1) +
           ((idx>>SIGMA_TC_POS)&1) + ((idx>>SIGMA_BC_POS)&1);

      if (v1 >= 3)
        kappa = 8;
      else if (v1 == 2)
        {
          if (v2 >= 1)
            kappa = 7;
          else
            kappa = 6;
        }
      else if (v1 == 1)
        kappa = 3 + ((v2>2)?2:v2);
      else
        kappa = 0 + ((v2>2)?2:v2);
      hh_sig_lut[idx] = (kdu_byte) kappa;
    }
}

/*****************************************************************************/
/* STATIC                    initialize_sign_lut                             */
/*****************************************************************************/

void
  initialize_sign_lut()
{
  kdu_int32 idx, vpos, vneg, hpos, hneg, kappa, predict, v1, v2;

  for (idx=0; idx < 256; idx++)
    {
      vpos = vneg = hpos = hneg = 0;
      if ((idx >> UP_NBR_SIGMA_POS) & 1)
        {
          kappa = (idx >> UP_NBR_CHI_POS) & 1;
          vneg |= kappa;
          vpos |= 1-kappa;
        }
      if ((idx >> DOWN_NBR_SIGMA_POS) & 1)
        {
          kappa = (idx >> DOWN_NBR_CHI_POS) & 1;
          vneg |= kappa;
          vpos |= 1-kappa;
        }
      if ((idx >> LEFT_NBR_SIGMA_POS) & 1)
        {
          kappa = (idx >> LEFT_NBR_CHI_POS) & 1;
          hneg |= kappa;
          hpos |= 1-kappa;
        }
      if ((idx >> RIGHT_NBR_SIGMA_POS) & 1)
        {
          kappa = (idx >> RIGHT_NBR_CHI_POS) & 1;
          hneg |= kappa;
          hpos |= 1-kappa;
        }
      v1 = hpos-hneg;
      v2 = vpos-vneg;
      predict = 0;
      if (v1 < 0)
        {
          predict = 1;
          v1 = -v1;
          v2 = -v2;
        }
      if (v1 == 0)
        {
          if (v2 < 0)
            {
              predict = 1;
              v2 = -v2;
            }
          kappa = v2;
        }
      else
        kappa = 3 + v2;

      sign_lut[idx] = (kdu_byte)((kappa<<1) | predict);
    }
}
