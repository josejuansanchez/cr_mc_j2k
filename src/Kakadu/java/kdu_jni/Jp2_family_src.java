package kdu_jni;

public class Jp2_family_src {
  static {
    System.loadLibrary("kdu_jni");
    Native_init_class();
  }
  private static native void Native_init_class();
  public long _native_ptr = 0;
  protected Jp2_family_src(long ptr) {
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
  public Jp2_family_src() {
    this(Native_create());
  }
  public native boolean Exists() throws KduException;
  public native void Open(String _fname, boolean _allow_seeks) throws KduException;
  public void Open(String _fname) throws KduException
  {
    Open(_fname,(boolean) true);
  }
  public native void Open(Kdu_compressed_source _indirect) throws KduException;
  public native void Open(Kdu_cache _cache) throws KduException;
  public native void Close() throws KduException;
  public native boolean Uses_cache() throws KduException;
  public native boolean Is_top_level_complete() throws KduException;
  public native int Get_id() throws KduException;
  public native String Get_filename() throws KduException;
  public native void Acquire_lock() throws KduException;
  public native void Release_lock() throws KduException;
}
