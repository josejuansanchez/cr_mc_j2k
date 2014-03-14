package kdu_jni;

public class Jp2_output_box extends Kdu_compressed_target {
  static {
    System.loadLibrary("kdu_jni");
    Native_init_class();
  }
  private static native void Native_init_class();
  protected Jp2_output_box(long ptr) {
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
  public Jp2_output_box() {
    this(Native_create());
  }
  public native boolean Exists() throws KduException;
  public native void Open(Jp2_family_tgt _tgt, long _box_type, boolean _rubber_length) throws KduException;
  public void Open(Jp2_family_tgt _tgt, long _box_type) throws KduException
  {
    Open(_tgt,_box_type,(boolean) false);
  }
  public native void Open(Jp2_output_box _super_box, long _box_type, boolean _rubber_length) throws KduException;
  public void Open(Jp2_output_box _super_box, long _box_type) throws KduException
  {
    Open(_super_box,_box_type,(boolean) false);
  }
  public native void Open(long _box_type) throws KduException;
  public native void Open_next(long _box_type, boolean _rubber_length) throws KduException;
  public void Open_next(long _box_type) throws KduException
  {
    Open_next(_box_type,(boolean) false);
  }
  public native long Get_box_type() throws KduException;
  public native long Get_box_length() throws KduException;
  public native int Get_header_length() throws KduException;
  public native long Get_contents(long[] _contents_length) throws KduException;
  public native void Set_rubber_length() throws KduException;
  public native void Write_header_last() throws KduException;
  public native boolean Write(long _dword) throws KduException;
  public native boolean Write(int _dword) throws KduException;
  public native boolean Write(short _word) throws KduException;
  public native boolean Write(byte _byte) throws KduException;
}
