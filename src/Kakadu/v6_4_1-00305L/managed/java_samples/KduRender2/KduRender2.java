/*****************************************************************************/
// File: KduRender2.java [scope = MANAGED/JAVA_SAMPLES]
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
   Simple example using the Kakadu Java native interfaces.  This example is
similar to "KduRender", except that it uses the more powerful
`Kdu_region_compositor' object for rendering, in place of
`Kdu_region_decompressor'.
******************************************************************************/

import java.awt.event.*;
import javax.swing.*;
import java.awt.*;
import java.awt.image.*;
import kdu_jni.*;

/* ========================================================================= */
/*                            Kdu_sysout_message                             */
/* ========================================================================= */
  /// <summary>
  /// Overrides Kdu_message to implement error and warning message
  /// services.  Objects of this class can be passed to Kakadu's error
  /// and warning message customization functions, to ensure that errors
  /// in the Kakadu native code will be handled correctly in the managed
  /// environment.
  /// </summary>
class Kdu_sysout_message extends Kdu_message
{
  public Kdu_sysout_message(boolean raise_exception)
  {
    this.raise_exception_on_end_of_message = raise_exception;
  }
  public void Put_text(String text)
  { // Implements the C++ callback function `kdu_message::put_text'
    System.out.print(text);
  }
  public void Flush(boolean end_of_message) throws KduException
  { // Implements the C++ callback function `kdu_message::flush'.
    if (end_of_message && raise_exception_on_end_of_message)
	throw new KduException(Kdu_global.KDU_ERROR_EXCEPTION,
                               "In `Kdu_sysout_message'.");
  }
  private boolean raise_exception_on_end_of_message;
}

/* ========================================================================= */
/*                                 ImagePanel                                */
/* ========================================================================= */
class ImagePanel extends JPanel
{
  private Image img;
  int[] img_buf;
  MemoryImageSource image_source;

  public ImagePanel(Kdu_coords view_size) throws KduException
  {
    if (view_size.Get_x() > 1600)
      view_size.Set_x(1600);
    if (view_size.Get_y() > 1200)
      view_size.Set_y(1200);
    setPreferredSize(new Dimension(view_size.Get_x(),
                                   view_size.Get_y()));
  }

  public void paint(Graphics g)
  {
    if (img != null)
      g.drawImage(img,0,0,this);
  }

  /// <summary>
  /// Copies the supplied region to the `image_source' and updates the
  /// corresponding region on the panel.
  /// </summary>
  public void put_region(int view_width, int view_height,
                         int reg_width, int reg_height,
                         int reg_off_x, int reg_off_y,
                         int[] reg_buf)
  {
    if (img == null)
      {
        setPreferredSize(new Dimension(view_width,view_height));
        img_buf = new int[view_width*view_height];
        image_source = new MemoryImageSource(view_width,view_height,
                                             img_buf,0,view_width);
        image_source.setAnimated(true);
        img = createImage(image_source);
      }

    int dest_idx = reg_off_x + reg_off_y*view_width;
    int src_idx = 0;
    int extra_row_gap = view_width - reg_width;
    int i, j;
    for (j=0; j < reg_height; j++, dest_idx+=extra_row_gap)
      for (i=0; i < reg_width; i++, src_idx++, dest_idx++)
        img_buf[dest_idx] = reg_buf[src_idx];
    image_source.newPixels(reg_off_x,reg_off_y,reg_width,reg_height);
    repaint(reg_off_x,reg_off_y,reg_width,reg_height);
  }
}

/* ========================================================================= */
/*                                 KduRender                                 */
/* ========================================================================= */
public class KduRender2
{
  public static ImagePanel display;

  /***************************************************************************/
  /*                            start_display                                */
  /***************************************************************************/
  public static void start_display(Kdu_coords view_size) throws KduException
  {
    try {
      UIManager.setLookAndFeel(
        UIManager.getCrossPlatformLookAndFeelClassName());
    }
    catch (Exception exc) {
      System.err.println("Error loading L&F: " + exc);
    }
    display = new ImagePanel(view_size);
    JFrame frame = new JFrame("KduRender");
    frame.addWindowListener(new WindowAdapter()
      { public void windowClosing(WindowEvent e) {System.exit(0);} });
    frame.getContentPane().add("Center", display);
    frame.pack();
    frame.setVisible(true);
    frame.repaint();
  }

  /***************************************************************************/
  /* PUBLIC                          main                                    */
  /***************************************************************************/
  public static void main(String[] args)
  {
    try 
    {
      // Start by customizing the error and warning services in Kakadu
      Kdu_sysout_message sysout =
        new Kdu_sysout_message(false); // Non-throwing message printer
      Kdu_sysout_message syserr =
        new Kdu_sysout_message(true); // Exception-throwing message printer
      Kdu_message_formatter pretty_sysout =
        new Kdu_message_formatter(sysout); // Non-throwing formatted printer
      Kdu_message_formatter pretty_syserr =
        new Kdu_message_formatter(syserr); // Throwing formatted printer

      Kdu_global.Kdu_customize_warnings(pretty_sysout);
      Kdu_global.Kdu_customize_errors(pretty_syserr);

      // Declare objects that we want to be able to dispose in an
      // orderly fashion -- we do this outside the try/catch statement
      // below, since otherwise, the objects will be automatically
      // finalized by the garbage collector in the event of an exception
      // and we would lose control of the order of disposal.
      // See END NOTE 3 in "KduRender.java"
      Kdu_simple_file_source raw_src = null; // Must be disposed last
      Jp2_family_src family_src = new Jp2_family_src(); // Dispose last
      Jpx_source wrapped_src = new Jpx_source(); // Dispose in the middle
      Kdu_region_compositor compositor = null;  // Must be disposed first

      try 
      { // See END NOTE 1 in "KduRender.java"
        if (args.length != 1)
          Kdu_global.Kdu_print_error("You must supply a file name " +
            "(JP2, JPX or raw code-stream)");

        // Open input file as raw codestream or a JP2/JPX file
        String fname = args[0];
        family_src.Open(fname); // Generates an error if file doesn't exist
        int success = wrapped_src.Open(family_src,true);
        if (success < 0)
        { // Must open as raw file
          family_src.Close();
          wrapped_src.Close();
          raw_src = new Kdu_simple_file_source(fname);
        }

        // Create and configure the compositor object
        compositor = new Kdu_region_compositor();
        if (raw_src != null)
          compositor.Create(raw_src);
        else
          compositor.Create(wrapped_src);
        compositor.Add_ilayer(0,new Kdu_dims(),new Kdu_dims());
        compositor.Set_scale(false,false,false,1.0F);

        // Determine dimensions for the rendered result & start processing
        Kdu_dims view_dims = new Kdu_dims();
        compositor.Get_total_composition_dims(view_dims);
        Kdu_coords view_size = view_dims.Access_size();
        // Note: changes in `view_size' will also affect `view_dims'
        start_display(view_size);
        Kdu_coords display_size =
          new Kdu_coords(display.getWidth(),display.getHeight());
        if (view_size.Get_x() > display_size.Get_x())
          view_size.Set_x(display_size.Get_x());
        if (view_size.Get_y() > display_size.Get_y())
          view_size.Set_y(display_size.Get_y());
        compositor.Set_buffer_surface(view_dims);
        Kdu_compositor_buf compositor_buf =
          compositor.Get_composition_buffer(view_dims);

        // Render incrementally.
        int region_buf_size = 0;
        int[] region_buf = null; // For getting data out of `compositor_buf'
        Kdu_dims new_region = new Kdu_dims();
        while (compositor.Process(100000,new_region))
        {
          Kdu_coords new_offset = new_region.Access_pos();
          Kdu_coords new_size = new_region.Access_size();
          new_offset.Subtract(view_dims.Access_pos());
                // Above statement affects `new_region', since `new_offset'
                // is just a reference to the position member of `new_region'
          int new_pixels = new_size.Get_x() * new_size.Get_y();
          if (new_pixels == 0) continue;
          if (new_pixels > region_buf_size)
          { // Augment the intermediate buffer as required
            region_buf_size = new_pixels;
            region_buf = new int[region_buf_size];
          }
          compositor_buf.Get_region(new_region,region_buf);
          display.put_region(view_size.Get_x(),view_size.Get_y(),
                             new_size.Get_x(),new_size.Get_y(),
                             new_offset.Get_x(),new_offset.Get_y(),region_buf);
        }

        display.repaint();
      }
      catch (KduException e)
      { // See END NOTE 2 in "KduRender.java"
	  System.out.println("[Caught exception \"" + e.getMessage() +
                           "\" -- code " +
			     Integer.toHexString(e.Get_kdu_exception_code()) +
			     "]");
      }

      // Cleanup: Disposal must happen in the right order
      // See END NOTE 3 in "KduRender.java" for a discussion of object disposal
      if (compositor != null)
        compositor.Native_destroy();
      wrapped_src.Native_destroy();
      family_src.Native_destroy();
      if (raw_src != null)
        raw_src.Native_destroy();
    }
    catch (KduException e)
    { // See END NOTE 2 in "KduRender.java"
      System.out.println("[Caught exception during creation of key objects!]");
    }
  }
}
