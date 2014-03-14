/*****************************************************************************/
// File: KduRender2.cs [scope = MANAGED/CSHARP_SAMPLES]
// Version: Kakadu, V5.2.2
// Author: David Taubman
// Last Revised: 12 September, 2006
/*****************************************************************************/
// Copyright 2001, David Taubman, The University of New South Wales (UNSW)
// The copyright owner is Unisearch Ltd, Australia (commercial arm of UNSW)
// Neither this copyright statement, nor the licensing details below
// may be removed from this file or dissociated from its contents.
/*****************************************************************************/
// Licensing details:
// In order to use, modify, redistribute or profit from this software in any
// manner, you must obtain an appropriate license from the copyright owner.
// Licenses appropriate for commercial and non-commercial activities may
// be obtained by following the links available at the following URL:
// "http://maestro.ee.unsw.edu.au/~taubman/kakadu".
/******************************************************************************
Description:
   Simple example using Kakadu's managed native interfaces.  This example
is similar to "KduRender", except that it uses the more powerful
`Ckdu_region_compositor' object for rendering, in place of
`Ckdu_region_decompressor'.  This example also demonstrates highly
efficient management of the decompressed surface buffer by means of
derived `Ckdu_region_compositor' and `Ckdu_compositor_buf' classes.
Derivations are performed in C# and take advantage of Kakadu's native
interface bindings for virtual and callback functions.
******************************************************************************/

using System;
using System.Drawing;
using System.Drawing.Imaging;
using System.Collections;
using System.ComponentModel;
using System.Windows.Forms;
using System.Data;
using System.Diagnostics;
using kdu_mni;

namespace KduRender2
{
  /* ======================================================================= */
  /*                           Ckdu_sysout_message                           */
  /* ======================================================================= */
  /// <summary>
  /// Overrides Ckdu_message to implement error and warning message
  /// services.  Objects of this class can be passed to Kakadu's error
  /// and warning message customization functions, to ensure that errors
  /// in the Kakadu native code will be handled correctly in the managed
  /// environment.
  /// </summary>
  class Ckdu_sysout_message : Ckdu_message 
  {
    public Ckdu_sysout_message(bool raise_exception)
    {
      this.raise_exception_on_end_of_message = raise_exception;
    }
    public override void put_text(string text) 
    { // Implements the C++ callback function `Ckdu_message::put_text'
      Console.Out.Write(text);
    }
    public override void flush(bool end_of_message)
    { // Implements the C++ callback function `Ckdu_message::flush'.
      if (end_of_message && raise_exception_on_end_of_message)
        throw new System.Exception(); // Whatever we throw, it will be
                                      // converted to a C++ integer exception
    }
    private bool raise_exception_on_end_of_message;
  }


  /* ======================================================================= */
  /*                            Ckdu_bitmap_buf                              */
  /* ======================================================================= */
  /// <summary>
  /// Derived `Ckdu_compositor_buf' object which manages an embedded
  /// GDI `Bitmap' object as the buffer onto which imagery is written.
  /// Note how the `init' member function is passed a locked pointer to
  /// the actual underlying memory buffer, so that no pixel data copying
  /// is required to access and paint rendered imagery.
  /// </summary>
  class Ckdu_bitmap_buf : Ckdu_compositor_buf
  {
    private Bitmap bitmap;
    private BitmapData bitmap_data;
    private IntPtr buffer_handle;
    private Ckdu_bitmap_buf next; // For building linked lists
    private Ckdu_bitmap_buf prev; // For building doubly linked lists
    private Ckdu_coords size;

    public Ckdu_bitmap_buf(Ckdu_coords size)
    {
      next = null;  prev = null;
      size.y = (size.y < 1)?1:size.y;
      size.x = (size.x < 1)?1:size.x;
      this.size = size; // Note: this does not copy dimensions; it just
                 // creates a new reference to the same internal object.  This
                 // is OK, since the `Ckdu_coords' object was created originally
                 // by passing a `kdu_coords' object by value through
                 // `Ckdu_bitmap_compositor::allocate_buffer', which causes
                 // a new managed instance of the object to be instantiated.
      bitmap = new Bitmap(size.x,size.y,PixelFormat.Format32bppArgb);
      bitmap_data = bitmap.LockBits(new Rectangle(0,0,size.x,size.y),
                                    ImageLockMode.ReadWrite,
                                    PixelFormat.Format32bppArgb);
      buffer_handle = bitmap_data.Scan0;
      int row_gap = bitmap_data.Stride / 4;
      this.init(buffer_handle,row_gap);
      this.set_read_accessibility(true);
    }

    public Ckdu_coords get_size() { return size; }

    /// <summary>
    /// This function unlocks the internal `Bitmap' object and returns it
    /// for use by the application (typically for GID drawing activities).
    /// Be sure to call `release_bitmap' afterwards.  Between these two
    /// calls, you should be doubly sure not to call
    /// `Ckdu_bitmap_compositor.process', since it requires access to a locked
    /// `Bitmap' buffer.
    /// </summary>
    public Bitmap acquire_bitmap()
    {
      if (bitmap_data != null)
        bitmap.UnlockBits(bitmap_data);
      bitmap_data = null;
      this.init(IntPtr.Zero,0);
      return bitmap;
    }

    /// <summary>
    /// Call this function after you have finished with the `Bitmap' object
    /// obtained using `acquire_bitmap'.
    /// </summary>
    public void release_bitmap()
    {
      Debug.Assert(bitmap_data == null);
      if (bitmap_data != null) return;
      bitmap_data = bitmap.LockBits(new Rectangle(0,0,size.x,size.y),
                                    ImageLockMode.ReadWrite,
                                    PixelFormat.Format32bppArgb);
      buffer_handle = bitmap_data.Scan0;
      int row_gap = bitmap_data.Stride / 4;
      this.init(buffer_handle,row_gap);
    }
    
    /// <summary>
    /// Insert the current object into the list headed by `head', returning
    /// the new head of the list.  Note: this function does not check to
    /// see whether the object already belongs to a list, but assumes it
    /// does not.
    /// </summary>
    public Ckdu_bitmap_buf insert(Ckdu_bitmap_buf head)
    {
      Debug.Assert((next == null) && (prev == null));
      next = head;
      prev = null;
      if (head != null)
        head.prev = this;
      return this;
    }

    /// <summary>
    /// Searches in the list to which `this' belongs for the derived
    /// object whose base is aliased to `tgt', returning the result (or
    /// `null', if none can be found).  Normally, `tgt' will be obtained from
    /// one of the `Ckdu_region_compositor' object's functions which supplies
    /// a compositor buffer, but is necessarily unaware of the lineage of
    /// that buffer as an instance of the derived `Ckdu_bitmap_buf' class.
    /// </summary>
    public Ckdu_bitmap_buf find(Ckdu_compositor_buf tgt)
    {
      int tgt_row_gap=0;
      IntPtr tgt_handle = tgt.get_buf(ref tgt_row_gap,true);
      Ckdu_bitmap_buf scan;
      for (scan=this; scan != null; scan=scan.prev)
        if (scan.buffer_handle == tgt_handle)
          return scan;
      for (scan=next; scan != null; scan=scan.next)
        if (scan.buffer_handle == tgt_handle)
          return scan;
      return null;
    }

    /// <summary>
    /// Unlinks the object from any list to which it belongs, returning
    /// the new head of the list.  This function does not call `Dispose'
    /// itself -- you may well want to do this immediately after unlinking.
    /// </summary>
    public Ckdu_bitmap_buf unlink()
    {
      if (next != null)
        next.prev = prev;
      if (prev != null)
        prev.next = next;
      Ckdu_bitmap_buf result = prev;
      if (result == null)
        result = next;
      else
        while (result.prev != null)
          result = result.prev;
      prev = next = null;
      return result;
    }

    /// <summary>
    /// Implements the logic required for disposing the object's resources
    /// as soon as possible -- typically when the base object's `Dispose'
    /// function is called, but otherwise when the garbage collector calls
    /// the object's finalization code.  This function also unlinks the
    /// object from any list to which it belongs, if necessary.
    /// </summary>
    protected override void Dispose(bool in_dispose)
    {
      if (in_dispose)
      {
        if ((next != null) || (prev != null))
          unlink();
        if (bitmap_data != null)
          bitmap.UnlockBits(bitmap_data);
        if (bitmap != null)
          bitmap.Dispose();
        if (size != null)
          size.Dispose();
      }
      next = prev = null;
      bitmap = null;
      bitmap_data = null;
      size = null;
      init(IntPtr.Zero,0); // Make sure no attempt is made by internal native
                           // object to delete the buffer we gave it.
      base.Dispose(in_dispose);
    }
  }

  /* ======================================================================= */
  /*                         Ckdu_bitmap_compositor                          */
  /* ======================================================================= */
  /// <summary>
  /// Overrides `Ckdu_region_compositor' to provide image buffering through the
  /// customized C#-derived object, `Ckdu_bitmap_buf'.
  /// </summary>
  class Ckdu_bitmap_compositor : Ckdu_region_compositor 
  {
    private Ckdu_bitmap_buf buffers; // Points to the head of a list of buffers
    private bool disposed;

    public Ckdu_bitmap_compositor() : base()
        { buffers = null; disposed = false; }

    /// <summary>
    /// Use this function instead of the base object's `get_composition_buffer'
    /// function to access the buffer in its derived form, as the
    /// `Ckdu_bitmap_buf' object which was allocated via `allocate_buffer'.
    /// </summary>
    public Ckdu_bitmap_buf get_composition_bitmap(Ckdu_dims region)
    {
      Ckdu_compositor_buf res = get_composition_buffer(region);
      if (res == null)
        return null;
      Debug.Assert(buffers != null);
      return buffers.find(res);
    }

    /// <summary>
    /// Overrides the base callback function to allocate a derived
    /// `Ckdu_bitmap_buf' object for use in composited image buffering.  This
    /// allows direct access to the composited `Bitmap' data for efficient
    /// rendering.
    /// </summary>
    public override Ckdu_compositor_buf
      allocate_buffer(Ckdu_coords min_size, Ckdu_coords actual_size,
                      bool read_access_required)
    {
      Ckdu_bitmap_buf result = new Ckdu_bitmap_buf(min_size);
      actual_size.assign(min_size);
      buffers = result.insert(buffers);
      return result;
    }

    /// <summary>
    /// Overrides the base callback function to correctly dispose of
    /// buffers which were allocated using the `allocate_buffer' function.
    /// </summary>
    public override void delete_buffer(Ckdu_compositor_buf buf)
    {
      Ckdu_bitmap_buf equiv = null;
      if (buffers != null)
        equiv = buffers.find(buf);
      Debug.Assert(equiv != null);
      if (equiv == null)
        return;
      buffers = equiv.unlink();
      equiv.Dispose();
    }

    /// <summary>
    /// This override is required to invoke the base object's `pre_destroy'
    /// function, which is required of classes which derive from
    /// `Ckdu_region_compositor' -- see docs.
    /// </summary>
    protected override void Dispose(bool in_dispose)
    {
      if (!disposed)
      {
        disposed = true;
        pre_destroy(); // This call should delete all the buffers
        Debug.Assert(buffers==null);
      }
      base.Dispose(in_dispose);
    }
  }

  /* ======================================================================= */
  /*                              MyPictureBox                               */
  /* ======================================================================= */

  class MyPictureBox : System.Windows.Forms.PictureBox
  {
    private Ckdu_bitmap_buf bitmap_buf;
    private Ckdu_coords size;

    public MyPictureBox(Ckdu_bitmap_buf bitmap_buf) : base()
    {
      this.bitmap_buf = bitmap_buf;
      this.size = bitmap_buf.get_size();
      this.ClientSize = new Size(size.x,size.y);
    }

    protected override void OnPaint(PaintEventArgs e)
    {
      Graphics g = e.Graphics;
      Rectangle rect = e.ClipRectangle;
      Bitmap bitmap = bitmap_buf.acquire_bitmap();
      g.DrawImage(bitmap,rect.X,rect.Y,rect,GraphicsUnit.Pixel);
      bitmap_buf.release_bitmap();
    }
  }

  /* ======================================================================= */
  /*                               ImagePanel                                */
  /* ======================================================================= */
  /// <summary>
  /// Derived Windows Form object which does very little, except to place a
  /// `MyPictureBox' object onto the viewing surface and size things
  /// correctly.  The important thing about `MyPictureBox' is that it
  /// provides a custom `OnPaint' implementation to paint the imagery.
  /// </summary>
  class ImagePanel : System.Windows.Forms.Form 
  {
    private MyPictureBox picture_box;

    /// <summary>
    /// Create a window onto which an image of the specified size
    /// (`view_size') can be painted using the `put_region' function.
    /// </summary>
    public ImagePanel(Ckdu_bitmap_buf bitmap_buf)
    {
      Ckdu_coords view_size = bitmap_buf.get_size();
      this.ClientSize = new Size(view_size.x,view_size.y);
      picture_box = new MyPictureBox(bitmap_buf);
      picture_box.Location = new Point(0,0);
      this.Controls.Add(picture_box);
    }

    /// <summary>
    /// Just invalidates the relevant region on the `MyPictureBox' object,
    /// which indirectly results in a call to the `MyPictureBox.OnPaint'
    /// function.
    /// </summary>
    public void repaint_region(Ckdu_dims region)
    {
      int off_x = region.access_pos().x;
      int off_y = region.access_pos().y;
      int width = region.access_size().x;
      int height = region.access_size().y;
      picture_box.Invalidate(new Rectangle(off_x,off_y,width,height));
    }

    protected override void Dispose(bool in_dispose)
    {
      if (in_dispose && (picture_box != null))
        picture_box.Dispose();
      picture_box = null;
      base.Dispose(in_dispose);
    }
  }

  /* ======================================================================= */
  /*                               KduRender2                                */
  /* ======================================================================= */
	class KduRender2
	{
    private ImagePanel panel;
    private Ckdu_bitmap_compositor compositor;
    private Ckdu_dims view_dims;

    /// <summary>
    /// Constructor just stores references to the objects which are used
    /// by `process_strip' to do the processing.
    /// </summary>
    private KduRender2(ImagePanel panel,
                       Ckdu_bitmap_compositor compositor,
                       Ckdu_dims view_dims)
    {
      this.panel = panel;
      this.compositor = compositor;
      this.view_dims = view_dims;
    }

    /// <summary>
    /// Generates another strip of the image and paints it to the panel,
    /// until there is nothing more to be done.
    /// </summary>
    private void process_strip(object sender, System.EventArgs e)
    {
      if (compositor == null)
        return; // All rendering complete
      Ckdu_dims new_region = new Ckdu_dims();
      if (compositor.process(100000,new_region))
      {
        new_region.access_pos().subtract(view_dims.access_pos());
        panel.repaint_region(new_region);
      }
      else
        compositor = null; // All done here
    }

    /*************************************************************************/
    /**                                 Main                                **/
    /*************************************************************************/
    [STAThread]
		static void Main(string[] args)
    {
      // Start by customizing the error and warning services in Kakadu
      Ckdu_sysout_message sysout =
        new Ckdu_sysout_message(false); // Non-throwing message printer
      Ckdu_sysout_message syserr =
        new Ckdu_sysout_message(true); // Exception-throwing message printer
      Ckdu_message_formatter pretty_sysout =
        new Ckdu_message_formatter(sysout); // Non-throwing formatted printer
      Ckdu_message_formatter pretty_syserr =
        new Ckdu_message_formatter(syserr); // Throwing formatted printer

      Ckdu_global.kdu_customize_warnings(pretty_sysout);
      Ckdu_global.kdu_customize_errors(pretty_syserr);

      // Declare objects that we want to be able to dispose in an
      // orderly fashion -- we do this outside the try/catch statement
      // below, since otherwise, the objects will be automatically
      // finalized by the garbage collector in the event of an exception
      // and we would lose control of the order of disposal.
      Ckdu_simple_file_source raw_src = null; // Must be disposed last
      Cjp2_family_src family_src = new Cjp2_family_src(); // Dispose last
      Cjpx_source wrapped_src = new Cjpx_source(); // Dispose in the middle
      Ckdu_bitmap_compositor compositor = null;  // Must be disposed first

      try 
      { // See END NOTE 1 in "KduRender.cs"
        if (args.Length != 1)
          Ckdu_global.kdu_print_error("You must supply a file name " +
                                      "(JP2, JPX or raw codestream)");

        // Open input file as raw codestream or a JP2/JPX file
        string fname = args[0];
        family_src.open(fname); // Generates an error if file doesn't exist
        int success = wrapped_src.open(family_src,true);
        if (success < 0)
        { // Must open as raw file
          family_src.close();
          wrapped_src.close();
          raw_src = new Ckdu_simple_file_source(fname);
        }

        // Create and configure the compositor object
        compositor = new Ckdu_bitmap_compositor();
        if (raw_src != null)
          compositor.create(raw_src);
        else
          compositor.create(wrapped_src);
        compositor.add_ilayer(0,new Ckdu_dims(),new Ckdu_dims());
        compositor.set_scale(false,false,false,1.0F);

        // Determine dimensions for the rendered result & start processing
        Ckdu_dims view_dims = new Ckdu_dims();
        compositor.get_total_composition_dims(view_dims);
        Rectangle display_rect = Screen.PrimaryScreen.Bounds;
        Ckdu_coords view_size = view_dims.access_size();
        // Note: changes in `view_size' will also affect `view_dims'
        if (view_size.x > display_rect.Width)
          view_size.x = display_rect.Width;
        if (view_size.y > display_rect.Height)
          view_size.y = display_rect.Height;
        compositor.set_buffer_surface(view_dims);
        Ckdu_bitmap_buf bitmap_buf =
          compositor.get_composition_bitmap(view_dims);

        // Pop up a window and render the image to it progressively
        ImagePanel panel = new ImagePanel(bitmap_buf);
        KduRender2 render_app = new KduRender2(panel,compositor,view_dims);
        Application.Idle += new EventHandler(render_app.process_strip);
        Application.Run(panel);
      }
      catch (Exception)
      { // See END NOTE 2 in "KduRender.cs"
        Console.Out.Write("[Caught exception]\n");
      }

      // Cleanup: Disposal must happen in the right order
      // See END NOTE 3 in "KduRender.cs" for a discussion of object disposal
      if (compositor != null)
        compositor.Dispose();
      wrapped_src.Dispose();
      family_src.Dispose();
      if (raw_src != null)
        raw_src.Dispose();
    }
	}
}
