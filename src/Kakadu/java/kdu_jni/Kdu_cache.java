package kdu_jni;

public class Kdu_cache extends Kdu_compressed_source {
  static {
    System.loadLibrary("kdu_jni");
    Native_init_class();
  }
  private static native void Native_init_class();
  protected Kdu_cache(long ptr) {
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
  private native void Native_init();
  public Kdu_cache() {
    this(Native_create());
    this.Native_init();
  }
  public native void Attach_to(Kdu_cache _existing) throws KduException;
  public native void Add_to_databin(int _databin_class, long _codestream_id, long _databin_id, byte[] _data, int _offset, int _num_bytes, boolean _is_final, boolean _add_as_most_recent, boolean _mark_if_augmented) throws KduException;
  public void Add_to_databin(int _databin_class, long _codestream_id, long _databin_id, byte[] _data, int _offset, int _num_bytes, boolean _is_final) throws KduException
  {
    Add_to_databin(_databin_class,_codestream_id,_databin_id,_data,_offset,_num_bytes,_is_final,(boolean) true,(boolean) false);
  }
  public void Add_to_databin(int _databin_class, long _codestream_id, long _databin_id, byte[] _data, int _offset, int _num_bytes, boolean _is_final, boolean _add_as_most_recent) throws KduException
  {
    Add_to_databin(_databin_class,_codestream_id,_databin_id,_data,_offset,_num_bytes,_is_final,_add_as_most_recent,(boolean) false);
  }
  public native int Get_databin_length(int _databin_class, long _codestream_id, long _databin_id, boolean[] _is_complete) throws KduException;
  public int Get_databin_length(int _databin_class, long _codestream_id, long _databin_id) throws KduException
  {
    return Get_databin_length(_databin_class,_codestream_id,_databin_id,null);
  }
  public native void Promote_databin(int _databin_class, long _codestream_id, long _databin_id) throws KduException;
  public native void Demote_databin(int _databin_class, long _codestream_id, long _databin_id) throws KduException;
  public native long Get_next_codestream(long _stream_id) throws KduException;
  public native long Get_next_lru_databin(int _databin_class, long _codestream_id, long _databin_id, boolean _only_if_marked) throws KduException;
  public long Get_next_lru_databin(int _databin_class, long _codestream_id, long _databin_id) throws KduException
  {
    return Get_next_lru_databin(_databin_class,_codestream_id,_databin_id,(boolean) false);
  }
  public native long Get_next_mru_databin(int _databin_class, long _codestream_id, long _databin_id, boolean _only_if_marked) throws KduException;
  public long Get_next_mru_databin(int _databin_class, long _codestream_id, long _databin_id) throws KduException
  {
    return Get_next_mru_databin(_databin_class,_codestream_id,_databin_id,(boolean) false);
  }
  public native boolean Mark_databin(int _databin_class, long _codestream_id, long _databin_id, boolean _mark_state) throws KduException;
  public native void Clear_all_marks() throws KduException;
  public native void Set_all_marks() throws KduException;
  public native int Get_databin_prefix(int _databin_class, long _codestream_id, long _databin_id, byte[] _buf, int _max_bytes) throws KduException;
  public native void Set_read_scope(int _databin_class, long _codestream_id, long _databin_id) throws KduException;
  public void Acquire_lock() throws KduException
  {
    // Override in a derived class to respond to the callback
    return;
  }
  public void Release_lock() throws KduException
  {
    // Override in a derived class to respond to the callback
    return;
  }
  public native long Get_peak_cache_memory() throws KduException;
  public native long Get_transferred_bytes(int _databin_class) throws KduException;
}
