package kdu_jni;

public class Jpx_codestream_source {
  static {
    System.loadLibrary("kdu_jni");
    Native_init_class();
  }
  private static native void Native_init_class();
  public long _native_ptr = 0;
  public native boolean Exists() throws KduException;
  public native int Get_codestream_id() throws KduException;
  public native Jp2_locator Get_header_loc() throws KduException;
  public native Jp2_dimensions Access_dimensions(boolean _finalize_compatibility) throws KduException;
  public Jp2_dimensions Access_dimensions() throws KduException
  {
    return Access_dimensions((boolean) false);
  }
  public native Jp2_palette Access_palette() throws KduException;
  public native Jp2_locator Get_stream_loc() throws KduException;
  public native boolean Stream_ready() throws KduException;
  public native Jpx_fragment_list Access_fragment_list() throws KduException;
  public native Jpx_input_box Open_stream(Jpx_input_box _my_resource) throws KduException;
  public Jpx_input_box Open_stream() throws KduException
  {
    Jpx_input_box my_resource = null;
    return Open_stream(my_resource);
  }
}
