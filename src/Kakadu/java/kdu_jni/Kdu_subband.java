package kdu_jni;

public class Kdu_subband {
  static {
    System.loadLibrary("kdu_jni");
    Native_init_class();
  }
  private static native void Native_init_class();
  public long _native_ptr = 0;
  public native boolean Exists() throws KduException;
  public native int Get_band_idx() throws KduException;
  public native Kdu_resolution Access_resolution() throws KduException;
  public native int Get_K_max() throws KduException;
  public native int Get_K_max_prime() throws KduException;
  public native boolean Get_reversible() throws KduException;
  public native float Get_delta() throws KduException;
  public native float Get_msb_wmse() throws KduException;
  public native boolean Get_roi_weight(float[] _energy_weight) throws KduException;
  public native void Get_dims(Kdu_dims _dims) throws KduException;
  public native void Get_valid_blocks(Kdu_dims _indices) throws KduException;
  public native void Get_block_size(Kdu_coords _nominal_size, Kdu_coords _first_size) throws KduException;
  public native Kdu_block Open_block(Kdu_coords _block_idx, int[] _return_tpart, Kdu_thread_env _env) throws KduException;
  public Kdu_block Open_block(Kdu_coords _block_idx) throws KduException
  {
    Kdu_thread_env env = null;
    return Open_block(_block_idx,null,env);
  }
  public Kdu_block Open_block(Kdu_coords _block_idx, int[] _return_tpart) throws KduException
  {
    Kdu_thread_env env = null;
    return Open_block(_block_idx,_return_tpart,env);
  }
  public native void Close_block(Kdu_block _block, Kdu_thread_env _env) throws KduException;
  public void Close_block(Kdu_block _block) throws KduException
  {
    Kdu_thread_env env = null;
    Close_block(_block,env);
  }
  public native int Get_conservative_slope_threshold() throws KduException;
}
