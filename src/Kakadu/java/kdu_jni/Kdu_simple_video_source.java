package kdu_jni;

public class Kdu_simple_video_source extends Kdu_compressed_video_source {
  static {
    System.loadLibrary("kdu_jni");
    Native_init_class();
  }
  private static native void Native_init_class();
  protected Kdu_simple_video_source(long ptr) {
    super(ptr);
  }
  public native void Native_destroy();
  public void finalize() {
    if ((_native_ptr & 1) != 0)
      { // Resource created and not donated
        Native_destroy();
      }
  }
  private static native long Native_create();
  public Kdu_simple_video_source() {
    this(Native_create());
  }
  private static native long Native_create(String _fname, long[] _flags);
  public Kdu_simple_video_source(String _fname, long[] _flags) {
    this(Native_create(_fname, _flags));
  }
  public native boolean Exists() throws KduException;
  public native void Open(String _fname, long[] _flags) throws KduException;
}
