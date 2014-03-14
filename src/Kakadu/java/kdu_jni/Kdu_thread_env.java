package kdu_jni;

public class Kdu_thread_env extends Kdu_thread_entity {
  static {
    System.loadLibrary("kdu_jni");
    Native_init_class();
  }
  private static native void Native_init_class();
  protected Kdu_thread_env(long ptr) {
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
  public Kdu_thread_env() {
    this(Native_create());
  }
  public native long Get_state() throws KduException;
  public native Kdu_thread_env Get_current_thread_env() throws KduException;
}
