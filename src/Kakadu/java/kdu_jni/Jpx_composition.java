package kdu_jni;

public class Jpx_composition {
  static {
    System.loadLibrary("kdu_jni");
    Native_init_class();
  }
  private static native void Native_init_class();
  public long _native_ptr = 0;
  public native boolean Exists() throws KduException;
  public native void Copy(Jpx_composition _src) throws KduException;
  public native int Get_global_info(Kdu_coords _size) throws KduException;
  public native long Get_next_frame(long _last_frame) throws KduException;
  public native long Get_prev_frame(long _last_frame) throws KduException;
  public native void Get_frame_info(long _frame_ref, int[] _num_instructions, int[] _duration, int[] _repeat_count, boolean[] _is_persistent) throws KduException;
  public native long Get_last_persistent_frame(long _frame_ref) throws KduException;
  public native boolean Get_instruction(long _frame_ref, int _instruction_idx, int[] _layer_idx, int[] _increment, boolean[] _is_reused, Kdu_dims _source_dims, Kdu_dims _target_dims) throws KduException;
  public native boolean Get_original_iset(long _frame_ref, int _instruction_idx, int[] _iset_idx, int[] _inum_idx) throws KduException;
  public native long Add_frame(int _duration, int _repeat_count, boolean _is_persistent) throws KduException;
  public native int Add_instruction(long _frame_ref, int _layer_idx, int _increment, Kdu_dims _source_dims, Kdu_dims _target_dims) throws KduException;
  public native void Set_loop_count(int _count) throws KduException;
}
