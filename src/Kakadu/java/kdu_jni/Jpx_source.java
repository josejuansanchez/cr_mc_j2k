package kdu_jni;

public class Jpx_source {
  static {
    System.loadLibrary("kdu_jni");
    Native_init_class();
  }
  private static native void Native_init_class();
  public long _native_ptr = 0;
  protected Jpx_source(long ptr) {
    _native_ptr = ptr;
  }
  public native void Native_destroy();
  public void finalize() {
    if ((_native_ptr & 1) != 0)
      { // Resource created and not donated
        Native_destroy();
      }
  }
  private static native long Native_create();
  public Jpx_source() {
    this(Native_create());
  }
  public native boolean Exists() throws KduException;
  public native int Open(Jp2_family_src _src, boolean _return_if_incompatible) throws KduException;
  public native Jp2_family_src Get_ultimate_src() throws KduException;
  public native Jpx_compatibility Access_compatibility() throws KduException;
  public native Jp2_data_references Access_data_references() throws KduException;
  public native boolean Count_codestreams(int[] _count) throws KduException;
  public native boolean Count_compositing_layers(int[] _count) throws KduException;
  public native Jpx_codestream_source Access_codestream(int _which, boolean _need_main_header) throws KduException;
  public Jpx_codestream_source Access_codestream(int _which) throws KduException
  {
    return Access_codestream(_which,(boolean) true);
  }
  public native Jpx_layer_source Access_layer(int _which, boolean _need_stream_headers) throws KduException;
  public Jpx_layer_source Access_layer(int _which) throws KduException
  {
    return Access_layer(_which,(boolean) true);
  }
  public native int Get_num_layer_codestreams(int _which_layer) throws KduException;
  public native int Get_layer_codestream_id(int _which_layer, int _which_stream) throws KduException;
  public native Jpx_composition Access_composition() throws KduException;
  public native Jpx_meta_manager Access_meta_manager() throws KduException;
  public native boolean Close() throws KduException;
}
