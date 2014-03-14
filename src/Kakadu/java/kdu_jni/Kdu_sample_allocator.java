package kdu_jni;

public class Kdu_sample_allocator {
  static {
    System.loadLibrary("kdu_jni");
    Native_init_class();
  }
  private static native void Native_init_class();
  public long _native_ptr = 0;
  protected Kdu_sample_allocator(long ptr) {
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
  public Kdu_sample_allocator() {
    this(Native_create());
  }
  public native void Restart() throws KduException;
  public native void Pre_alloc(boolean _use_shorts, int _before, int _after, int _num_requests) throws KduException;
  public native void Finalize() throws KduException;
  public native int Get_size() throws KduException;
}
