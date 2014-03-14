package kdu_jni;

public class Mj2_target {
  static {
    System.loadLibrary("kdu_jni");
    Native_init_class();
  }
  private static native void Native_init_class();
  public long _native_ptr = 0;
  public native boolean Exists() throws KduException;
  public native void Open(Jp2_family_tgt _tgt) throws KduException;
  public native void Close() throws KduException;
  public native Mj2_video_target Add_video_track() throws KduException;
}
