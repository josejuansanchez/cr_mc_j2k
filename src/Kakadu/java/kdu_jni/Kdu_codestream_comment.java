package kdu_jni;

public class Kdu_codestream_comment {
  static {
    System.loadLibrary("kdu_jni");
    Native_init_class();
  }
  private static native void Native_init_class();
  public long _native_ptr = 0;
  public native boolean Exists() throws KduException;
  public native String Get_text() throws KduException;
  public native int Get_data(byte[] _buf, int _offset, int _length) throws KduException;
  public native boolean Check_readonly() throws KduException;
  public native boolean Put_data(byte[] _data, int _num_bytes) throws KduException;
  public native boolean Put_text(String _string) throws KduException;
}
