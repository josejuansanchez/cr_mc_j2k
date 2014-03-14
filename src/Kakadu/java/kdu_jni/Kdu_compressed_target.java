package kdu_jni;

public class Kdu_compressed_target {
  static {
    System.loadLibrary("kdu_jni");
    Native_init_class();
  }
  private static native void Native_init_class();
  public long _native_ptr = 0;
  protected Kdu_compressed_target(long ptr) {
    _native_ptr = ptr;
  }
  public native void Native_destroy();
  public void finalize() {
    if ((_native_ptr & 1) != 0)
      { // Resource created and not donated
        Native_destroy();
      }
  }
  public native boolean Close() throws KduException;
  public native boolean Start_rewrite(long _backtrack) throws KduException;
  public native boolean End_rewrite() throws KduException;
  public native boolean Write(byte[] _buf, int _num_bytes) throws KduException;
  public native void Set_target_size(long _num_bytes) throws KduException;
}
