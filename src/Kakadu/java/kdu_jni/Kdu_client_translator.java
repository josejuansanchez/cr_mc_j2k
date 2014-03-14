package kdu_jni;

public class Kdu_client_translator {
  static {
    System.loadLibrary("kdu_jni");
    Native_init_class();
  }
  private static native void Native_init_class();
  public long _native_ptr = 0;
  protected Kdu_client_translator(long ptr) {
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
  public Kdu_client_translator() {
    this(Native_create());
  }
  public native void Init(Kdu_cache _main_cache) throws KduException;
  public native void Close() throws KduException;
  public native boolean Update() throws KduException;
  public native int Get_num_context_members(int _context_type, int _context_idx, int[] _remapping_ids) throws KduException;
  public native int Get_context_codestream(int _context_type, int _context_idx, int[] _remapping_ids, int _member_idx) throws KduException;
  public native long Get_context_components(int _context_type, int _context_idx, int[] _remapping_ids, int _member_idx, int[] _num_components) throws KduException;
  public native boolean Perform_context_remapping(int _context_type, int _context_idx, int[] _remapping_ids, int _member_idx, Kdu_coords _resolution, Kdu_dims _region) throws KduException;
}
