/*****************************************************************************/
// File: KduRender.java [scope = MANAGED/JAVA_SAMPLES]
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
   Simple example using the Kakadu Java native interfaces.  Similar to the
native C++ application, "kdu_render", except that the rendered image is
painted on the screen.  If the image is too large to fit on the screen only
its upper left hand corner will actually be displayed.  The intent here is
not to replicate the full functionality of a viewer such as "kdu_show"
in Java, although this could certainly be done.
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
public class KduRender
{
  public static ImagePanel display;

  /***************************************************************************/
  /* PRIVATE              determine_reference_expansion                      */
  /***************************************************************************/
  /// <summary>
  /// This function almost invariably returns (1,1), but there can be
  /// some wacky images for which larger expansions are required.  The
  /// need for it arises from the fact that `Kdu_region_decompressor'
  /// performs its decompressed image sizing based upon a single image
  /// component (the `image_component').  Specifically, the size of the
  /// decompressed result is obtained by expanding the dimensions of the
  /// reference component by the x-y values returned by this function.
  /// Reference expansion factors must have the property that when the
  /// first component is expanded by this much, any other components
  /// (typically colour components) are also expanded by an integral
  /// amount.  The `Kdu_region_decompressor' actually does support
  /// rational expansion of individual image components, but we do not
  /// exploit this feature in the present coding example.
  /// </summary>
  private static Kdu_coords
    determine_reference_expansion(int reference_component,
                                  Kdu_channel_mapping channels,
                                  Kdu_codestream codestream)
      throws KduException
  {
    int c;
    Kdu_coords ref_subs = new Kdu_coords();
    Kdu_coords subs = new Kdu_coords();
    codestream.Get_subsampling(reference_component,ref_subs);
    Kdu_coords min_subs = new Kdu_coords(); min_subs.Assign(ref_subs);
    for (c=0; c < channels.Get_num_channels(); c++)
      {
        codestream.Get_subsampling(channels.Get_source_component(c),subs);
        if (subs.Get_x() < min_subs.Get_x())
          min_subs.Set_x(subs.Get_x());
        if (subs.Get_y() < min_subs.Get_y())
          min_subs.Set_y(subs.Get_y());
      }
    Kdu_coords expansion = new Kdu_coords();
    expansion.Set_x(ref_subs.Get_x() / min_subs.Get_x());
    expansion.Set_y(ref_subs.Get_y() / min_subs.Get_y());
    for (c=0; c < channels.Get_num_channels(); c++)
      {
        codestream.Get_subsampling(channels.Get_source_component(c),subs);
        if ((((subs.Get_x() * expansion.Get_x()) % ref_subs.Get_x()) != 0) ||
            (((subs.Get_y() * expansion.Get_y()) % ref_subs.Get_y()) != 0))
          {
            Kdu_global.Kdu_print_error(
              "The supplied JP2 file contains colour channels " +
              "whose sub-sampling factors are not integer " +
              "multiples of one another.");
            codestream.Apply_input_restrictions(0,1,0,0,null,
                                   Kdu_global.KDU_WANT_OUTPUT_COMPONENTS);
            channels.Configure(codestream);
            expansion = new Kdu_coords(1,1);
          }
      }
    return expansion;
  }

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
      // and we would lose control of the order of disposal.  See END NOTE 3.
      Kdu_simple_file_source raw_src = null; // Must be disposed last
      Jp2_family_src family_src = new Jp2_family_src(); // Dispose last
      Jpx_source wrapped_src = new Jpx_source(); // Dispose before codestream
      Kdu_codestream codestream = new Kdu_codestream(); // Needs `destroy'
      Kdu_channel_mapping channels = new Kdu_channel_mapping();
      Kdu_region_decompressor decompressor = new Kdu_region_decompressor();

      try 
      { // See END NOTE 1
        if (args.length != 1)
          Kdu_global.Kdu_print_error("You must supply a file name " +
            "(JP2, JPX or raw code-stream)");

        // Open input file as raw codestream or a JP2/JPX file
        String fname = args[0];
        family_src.Open(fname); // Generates an error if file doesn't exist
        Jpx_layer_source xlayer = null;
        Jpx_codestream_source xstream = null;
        int success = wrapped_src.Open(family_src,true);
        Kdu_compressed_source input=null; // Allows us to refer to compressed
        // data source associated with either a raw codestream
        // file or a JP2/JPX embedded codestream.
        if (success < 0)
        { // Must open as raw file
          family_src.Close();
          wrapped_src.Close();
          raw_src = new Kdu_simple_file_source(fname);
          input = raw_src;
        }
        else
        { // Succeeded in opening as wrapped JP2/JPX source
          xlayer = wrapped_src.Access_layer(0);
          xstream = wrapped_src.Access_codestream(xlayer.Get_codestream_id(0));
          input = xstream.Open_stream();
        }

        // Create the code-stream management machinery
        codestream.Create(input);
        if (xlayer != null)
          channels.Configure(xlayer.Access_colour(0),xlayer.Access_channels(),
                             xstream.Get_codestream_id(),
                             xstream.Access_palette(),
                             xstream.Access_dimensions());
        else
          channels.Configure(codestream);
        int ref_component = channels.Get_source_component(0);
        Kdu_coords ref_expansion =
          determine_reference_expansion(ref_component,channels,codestream);

        // Determine dimensions for the rendered result & start decompressor
        Kdu_dims view_dims =
          decompressor.Get_rendered_image_dims(codestream,channels,-1,
                                    0,ref_expansion,new Kdu_coords(1,1),
                                    Kdu_global.KDU_WANT_OUTPUT_COMPONENTS);
        Kdu_coords view_size = view_dims.Access_size();
            // Note: changes in `view_size' will also affect `view_dims'
        start_display(view_size);
        Kdu_coords display_size =
          new Kdu_coords(display.getWidth(),display.getHeight());
        if (view_size.Get_x() > display_size.Get_x())
          view_size.Set_x(display_size.Get_x());
        if (view_size.Get_y() > display_size.Get_y())
          view_size.Set_y(display_size.Get_y());
        decompressor.Start(codestream,channels,-1,0,16384,view_dims,
                           ref_expansion,new Kdu_coords(1,1),false,
                           Kdu_global.KDU_WANT_OUTPUT_COMPONENTS);

        // Render incrementally.
        int region_buf_size = view_size.Get_x() * 60;
        int[] region_buf = new int[region_buf_size];
        Kdu_dims new_region = new Kdu_dims();
        Kdu_dims incomplete_region = new Kdu_dims();
        incomplete_region.Assign(view_dims);
        while (decompressor.Process(region_buf,view_dims.Access_pos(),
                                    0,0,region_buf_size,
                                    incomplete_region,new_region))
        { // Transfer decompressed region into the main buffer
          Kdu_coords offset =
            new_region.Access_pos().Minus(view_dims.Access_pos());
          display.put_region(view_size.Get_x(),view_size.Get_y(),
                             new_region.Access_size().Get_x(),
                             new_region.Access_size().Get_y(),
                             offset.Get_x(),offset.Get_y(),region_buf);
        }
        decompressor.Finish();
        display.repaint();
      }
      catch (KduException e)
      { // See END NOTE 2
        System.out.println("[Caught exception \"" + e.getMessage() +
                           "\" -- code " +
                           Integer.toHexString(e.Get_kdu_exception_code()) +
                           "]");
      }

      // Cleanup: Disposal must happen in the right order
      // See END NOTE 3 for a discussion of Kakadu object disposal
      decompressor.Native_destroy();
      channels.Native_destroy();
      if (codestream.Exists()) codestream.Destroy();
      if (raw_src != null) raw_src.Native_destroy();
      wrapped_src.Native_destroy();
      family_src.Native_destroy();
    }
    catch (KduException e)
    { // See END NOTE 2
      System.out.println("[Caught exception during creation of key objects!]");
    }
  }
}

/* END NOTE 1:
      Enclosing code in a try/catch clause allows you to catch any errors
      which may be generated by the Kakadu core system (or from elements
      of the Java implementation).  The way this works is worth explaining
      briefly in the sequel.
      
      If internal errors are generated through the core error
      service `kdu_error', they will be routed to the `pretty_syserr'
      object we installed using `kdu_global.kdu_customize_errors' above.
          Note: The simplest way to generate your own `kdu_error' errors
          from Java is to use the `Kdu_global.Kdu_print_error' function.
      When the `kdu_error' object is destroyed at the end of the
      internal error clause, it issues a call to our `pretty_syserr'
      object's `Flush' function, with the `end_of_message' argument
      set to true.  The `pretty_syserr' object issues calls to
      `syserr.Put_text' (for printing the message) and `sysout.Flush'
      (when `pretty_syserr.Flush' is called).  Our `syserr' object
      has been derived from `Kdu_message' in such a way as to override
      the `Kdu_message.Put_text' and `Kdu_message.Flush' functions.
      The latter throws an exception when it receives the end of message
      flush call.  The exception unwinds the execution stack all the
      way back to the catch clause appearing below.  This is designed
      to be robust from the inside to the outside.
      
      When an exception is thrown, the Kakadu Java bindings
      (implemented in "kdu_jni.dll") automatically cleanup any
      temporary resources they have allocated for inter-operability.
      Also, the Kakadu native implementation's exception handling
      should destroy any resources which would otherwise be lost.
      From the catch clause, you should find yourself in a safe
      position to continue interacting with any Kakadu objects you
      have created (e.g., a `Kdu_codestream' interface), but the
      normal response will be to destroy such objects (see END NOTE 3).
*/

/* END NOTE 2:
      Seeming as our implementation of the `Kdu_sysout_message.Flush'
      function throws exceptions, if the Kakadu native code generates
      an error through `kdu_error', we expect that exception to be caught
      by "catch (KduException)".
          Actually, all `KduException' exceptions thrown from Kakadu
      callback functions (functions marked with the [BIND: callback] option
      -- designed to be implemented in a derived object) are automatically
      converted to C++ exceptions of type `kdu_exception' (actually an integer)
      with the value derived from `KduException.Get_kdu_exception_code()'.
      C++ exceptions may also be thrown directly from inside
      Kakadu native objects.
          On the way back out, all C++ exceptions (including those
      which were converted from Java `KduException' exceptions) are
      automatically wrapped by the Java bindings as Java exceptions of type
      `KduException', with the relevant exception code inside.  If a
      `kdu_exception' was caught, that is the code wrapped in the
      Java `KduException'.  Otherwise, the code is 0.
          The one caveat worth mentioning to the above cases is memory
      allocation exceptions.  If these occur within a callback function, they
      are rethrown as a C++ `std::bad_alloc' exception.  Conversely, if a
      `std::bad_alloc' exception is thrown inside the native implementation
      of a Java interface to Kakadu, the exception is thrown as
      `java/lang/OutOfMemoryError'.
*/

/* END NOTE 3:
      By and large, the Java environment automatically garbage
      collects objects you have allocated, including those associated
      with the internal Kakadu system -- this causes the internal
      objects to be destroyed.  However, the garbage collector has
      two important weaknesses: 1) it gives you no control over the
      order of destruction (which is sometimes important for the
      native code); and 2) it will not destroy internal objects
      which are not owned by Java objects.

      To clarify this second point, Kakadu defines a special type of
      class known as an INTERFACE class, whose content is actually a
      reference to an opaque internal entity.  Kakadu allows any
      number of copies of INTERFACE objects to be made, since they
      are all references to the same internal object.  INTERFACE classes
      have no C++ destructor, because the internal object is not intended
      to be destroyed when the INTERFACE object goes out of scope.  For
      this reason, when a Java instance of an INTERFACE class is garbage
      collected, the internal object will also remain untouched (it must,
      for safety).  Although INTERFACE objects have no destructor,
      any INTERFACE object, whose internal representation can be
      explicitly destroyed, also provides an explicit `Destroy'
      member function.  You must call the `Destroy' function
      yourself, to destroy interfaces that you have explicitly
      created, exactly as you would from C++.  An example of this is the
      call to `Kdu_codestream.Destroy' above.
      
      Whether or not an object belongs to a Kakadu INTERFACE class
      should be very clear from the documentation generated by
      "kdu_hyperdoc", which also created the Java bindings for you.
      If in any doubt at all, look for the presence of a `Destroy'
      member function.

      To address the need to control the order of destruction
      of native Kakadu objects (as opposed to just relying on Java
      garbage collection), you will find that the language
      bindings generated by "kdu_hyperdoc" provide a `Native_destroy'
      member function for you.  This destroys the native Kakadu
      object, leaving the garbage collector to cleanup the outer
      shell of the object which you see from Java.  Do not attempt to
      use the object after its `Native_destroy' function has been called.
      Of course, Kakadu INTERFACE classes do not provide `Native_destroy'.
      If the internal resource can be explicitly destroyed, you will find
      a `Destroy' member function, as explained above.
      
      For Kakadu objects which provide a visible public destructor, the
      `Native_destroy' function will be public and may be overridden.  You
      may need to override this function in a Java derived class to make
      sure you clean up its resources as well, or to invoke the
      `Native_destroy' function of other Kakadu-derived objects.
*/
