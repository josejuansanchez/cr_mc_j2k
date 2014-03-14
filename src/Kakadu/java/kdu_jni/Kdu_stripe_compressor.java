package kdu_jni;

public class Kdu_stripe_compressor {
  static {
    System.loadLibrary("kdu_jni");
    Native_init_class();
  }
  private static native void Native_init_class();
  public long _native_ptr = 0;
  protected Kdu_stripe_compressor(long ptr) {
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
  public Kdu_stripe_compressor() {
    this(Native_create());
  }
  public native void Start(Kdu_codestream _codestream, int _num_layer_specs, long[] _layer_sizes, int[] _layer_slopes, int _min_slope_threshold, boolean _no_prediction, boolean _force_precise, boolean _record_layer_info_in_comment, double _size_tolerance, int _num_components, boolean _want_fastest, Kdu_thread_env _env, long _env_queue, int _env_dbuf_height) throws KduException;
  public void Start(Kdu_codestream _codestream) throws KduException
  {
    Kdu_thread_env env = null;
    Start(_codestream,(int) 0,null,null,(int) 0,(boolean) false,(boolean) false,(boolean) true,(double) 0.0,(int) 0,(boolean) false,env,0,(int) 0);
  }
  public void Start(Kdu_codestream _codestream, int _num_layer_specs) throws KduException
  {
    Kdu_thread_env env = null;
    Start(_codestream,_num_layer_specs,null,null,(int) 0,(boolean) false,(boolean) false,(boolean) true,(double) 0.0,(int) 0,(boolean) false,env,0,(int) 0);
  }
  public void Start(Kdu_codestream _codestream, int _num_layer_specs, long[] _layer_sizes) throws KduException
  {
    Kdu_thread_env env = null;
    Start(_codestream,_num_layer_specs,_layer_sizes,null,(int) 0,(boolean) false,(boolean) false,(boolean) true,(double) 0.0,(int) 0,(boolean) false,env,0,(int) 0);
  }
  public void Start(Kdu_codestream _codestream, int _num_layer_specs, long[] _layer_sizes, int[] _layer_slopes) throws KduException
  {
    Kdu_thread_env env = null;
    Start(_codestream,_num_layer_specs,_layer_sizes,_layer_slopes,(int) 0,(boolean) false,(boolean) false,(boolean) true,(double) 0.0,(int) 0,(boolean) false,env,0,(int) 0);
  }
  public void Start(Kdu_codestream _codestream, int _num_layer_specs, long[] _layer_sizes, int[] _layer_slopes, int _min_slope_threshold) throws KduException
  {
    Kdu_thread_env env = null;
    Start(_codestream,_num_layer_specs,_layer_sizes,_layer_slopes,_min_slope_threshold,(boolean) false,(boolean) false,(boolean) true,(double) 0.0,(int) 0,(boolean) false,env,0,(int) 0);
  }
  public void Start(Kdu_codestream _codestream, int _num_layer_specs, long[] _layer_sizes, int[] _layer_slopes, int _min_slope_threshold, boolean _no_prediction) throws KduException
  {
    Kdu_thread_env env = null;
    Start(_codestream,_num_layer_specs,_layer_sizes,_layer_slopes,_min_slope_threshold,_no_prediction,(boolean) false,(boolean) true,(double) 0.0,(int) 0,(boolean) false,env,0,(int) 0);
  }
  public void Start(Kdu_codestream _codestream, int _num_layer_specs, long[] _layer_sizes, int[] _layer_slopes, int _min_slope_threshold, boolean _no_prediction, boolean _force_precise) throws KduException
  {
    Kdu_thread_env env = null;
    Start(_codestream,_num_layer_specs,_layer_sizes,_layer_slopes,_min_slope_threshold,_no_prediction,_force_precise,(boolean) true,(double) 0.0,(int) 0,(boolean) false,env,0,(int) 0);
  }
  public void Start(Kdu_codestream _codestream, int _num_layer_specs, long[] _layer_sizes, int[] _layer_slopes, int _min_slope_threshold, boolean _no_prediction, boolean _force_precise, boolean _record_layer_info_in_comment) throws KduException
  {
    Kdu_thread_env env = null;
    Start(_codestream,_num_layer_specs,_layer_sizes,_layer_slopes,_min_slope_threshold,_no_prediction,_force_precise,_record_layer_info_in_comment,(double) 0.0,(int) 0,(boolean) false,env,0,(int) 0);
  }
  public void Start(Kdu_codestream _codestream, int _num_layer_specs, long[] _layer_sizes, int[] _layer_slopes, int _min_slope_threshold, boolean _no_prediction, boolean _force_precise, boolean _record_layer_info_in_comment, double _size_tolerance) throws KduException
  {
    Kdu_thread_env env = null;
    Start(_codestream,_num_layer_specs,_layer_sizes,_layer_slopes,_min_slope_threshold,_no_prediction,_force_precise,_record_layer_info_in_comment,_size_tolerance,(int) 0,(boolean) false,env,0,(int) 0);
  }
  public void Start(Kdu_codestream _codestream, int _num_layer_specs, long[] _layer_sizes, int[] _layer_slopes, int _min_slope_threshold, boolean _no_prediction, boolean _force_precise, boolean _record_layer_info_in_comment, double _size_tolerance, int _num_components) throws KduException
  {
    Kdu_thread_env env = null;
    Start(_codestream,_num_layer_specs,_layer_sizes,_layer_slopes,_min_slope_threshold,_no_prediction,_force_precise,_record_layer_info_in_comment,_size_tolerance,_num_components,(boolean) false,env,0,(int) 0);
  }
  public void Start(Kdu_codestream _codestream, int _num_layer_specs, long[] _layer_sizes, int[] _layer_slopes, int _min_slope_threshold, boolean _no_prediction, boolean _force_precise, boolean _record_layer_info_in_comment, double _size_tolerance, int _num_components, boolean _want_fastest) throws KduException
  {
    Kdu_thread_env env = null;
    Start(_codestream,_num_layer_specs,_layer_sizes,_layer_slopes,_min_slope_threshold,_no_prediction,_force_precise,_record_layer_info_in_comment,_size_tolerance,_num_components,_want_fastest,env,0,(int) 0);
  }
  public void Start(Kdu_codestream _codestream, int _num_layer_specs, long[] _layer_sizes, int[] _layer_slopes, int _min_slope_threshold, boolean _no_prediction, boolean _force_precise, boolean _record_layer_info_in_comment, double _size_tolerance, int _num_components, boolean _want_fastest, Kdu_thread_env _env) throws KduException
  {
    Start(_codestream,_num_layer_specs,_layer_sizes,_layer_slopes,_min_slope_threshold,_no_prediction,_force_precise,_record_layer_info_in_comment,_size_tolerance,_num_components,_want_fastest,_env,0,(int) 0);
  }
  public void Start(Kdu_codestream _codestream, int _num_layer_specs, long[] _layer_sizes, int[] _layer_slopes, int _min_slope_threshold, boolean _no_prediction, boolean _force_precise, boolean _record_layer_info_in_comment, double _size_tolerance, int _num_components, boolean _want_fastest, Kdu_thread_env _env, long _env_queue) throws KduException
  {
    Start(_codestream,_num_layer_specs,_layer_sizes,_layer_slopes,_min_slope_threshold,_no_prediction,_force_precise,_record_layer_info_in_comment,_size_tolerance,_num_components,_want_fastest,_env,_env_queue,(int) 0);
  }
  public native boolean Finish(int _num_layer_specs, long[] _layer_sizes, int[] _layer_slopes) throws KduException;
  public boolean Finish() throws KduException
  {
    return Finish((int) 0,null,null);
  }
  public boolean Finish(int _num_layer_specs) throws KduException
  {
    return Finish(_num_layer_specs,null,null);
  }
  public boolean Finish(int _num_layer_specs, long[] _layer_sizes) throws KduException
  {
    return Finish(_num_layer_specs,_layer_sizes,null);
  }
  public native boolean Get_recommended_stripe_heights(int _preferred_min_height, int _absolute_max_height, int[] _stripe_heights, int[] _max_stripe_heights) throws KduException;
  public native boolean Push_stripe(byte[] _buffer, int[] _stripe_heights, int[] _sample_offsets, int[] _sample_gaps, int[] _row_gaps, int[] _precisions, int _flush_period) throws KduException;
  public boolean Push_stripe(byte[] _buffer, int[] _stripe_heights) throws KduException
  {
    return Push_stripe(_buffer,_stripe_heights,null,null,null,null,(int) 0);
  }
  public boolean Push_stripe(byte[] _buffer, int[] _stripe_heights, int[] _sample_offsets) throws KduException
  {
    return Push_stripe(_buffer,_stripe_heights,_sample_offsets,null,null,null,(int) 0);
  }
  public boolean Push_stripe(byte[] _buffer, int[] _stripe_heights, int[] _sample_offsets, int[] _sample_gaps) throws KduException
  {
    return Push_stripe(_buffer,_stripe_heights,_sample_offsets,_sample_gaps,null,null,(int) 0);
  }
  public boolean Push_stripe(byte[] _buffer, int[] _stripe_heights, int[] _sample_offsets, int[] _sample_gaps, int[] _row_gaps) throws KduException
  {
    return Push_stripe(_buffer,_stripe_heights,_sample_offsets,_sample_gaps,_row_gaps,null,(int) 0);
  }
  public boolean Push_stripe(byte[] _buffer, int[] _stripe_heights, int[] _sample_offsets, int[] _sample_gaps, int[] _row_gaps, int[] _precisions) throws KduException
  {
    return Push_stripe(_buffer,_stripe_heights,_sample_offsets,_sample_gaps,_row_gaps,_precisions,(int) 0);
  }
  public native boolean Push_stripe(short[] _buffer, int[] _stripe_heights, int[] _sample_offsets, int[] _sample_gaps, int[] _row_gaps, int[] _precisions, boolean[] _is_signed, int _flush_period) throws KduException;
  public boolean Push_stripe(short[] _buffer, int[] _stripe_heights) throws KduException
  {
    return Push_stripe(_buffer,_stripe_heights,null,null,null,null,null,(int) 0);
  }
  public boolean Push_stripe(short[] _buffer, int[] _stripe_heights, int[] _sample_offsets) throws KduException
  {
    return Push_stripe(_buffer,_stripe_heights,_sample_offsets,null,null,null,null,(int) 0);
  }
  public boolean Push_stripe(short[] _buffer, int[] _stripe_heights, int[] _sample_offsets, int[] _sample_gaps) throws KduException
  {
    return Push_stripe(_buffer,_stripe_heights,_sample_offsets,_sample_gaps,null,null,null,(int) 0);
  }
  public boolean Push_stripe(short[] _buffer, int[] _stripe_heights, int[] _sample_offsets, int[] _sample_gaps, int[] _row_gaps) throws KduException
  {
    return Push_stripe(_buffer,_stripe_heights,_sample_offsets,_sample_gaps,_row_gaps,null,null,(int) 0);
  }
  public boolean Push_stripe(short[] _buffer, int[] _stripe_heights, int[] _sample_offsets, int[] _sample_gaps, int[] _row_gaps, int[] _precisions) throws KduException
  {
    return Push_stripe(_buffer,_stripe_heights,_sample_offsets,_sample_gaps,_row_gaps,_precisions,null,(int) 0);
  }
  public boolean Push_stripe(short[] _buffer, int[] _stripe_heights, int[] _sample_offsets, int[] _sample_gaps, int[] _row_gaps, int[] _precisions, boolean[] _is_signed) throws KduException
  {
    return Push_stripe(_buffer,_stripe_heights,_sample_offsets,_sample_gaps,_row_gaps,_precisions,_is_signed,(int) 0);
  }
  public native boolean Push_stripe(int[] _buffer, int[] _stripe_heights, int[] _sample_offsets, int[] _sample_gaps, int[] _row_gaps, int[] _precisions, boolean[] _is_signed, int _flush_period) throws KduException;
  public boolean Push_stripe(int[] _buffer, int[] _stripe_heights) throws KduException
  {
    return Push_stripe(_buffer,_stripe_heights,null,null,null,null,null,(int) 0);
  }
  public boolean Push_stripe(int[] _buffer, int[] _stripe_heights, int[] _sample_offsets) throws KduException
  {
    return Push_stripe(_buffer,_stripe_heights,_sample_offsets,null,null,null,null,(int) 0);
  }
  public boolean Push_stripe(int[] _buffer, int[] _stripe_heights, int[] _sample_offsets, int[] _sample_gaps) throws KduException
  {
    return Push_stripe(_buffer,_stripe_heights,_sample_offsets,_sample_gaps,null,null,null,(int) 0);
  }
  public boolean Push_stripe(int[] _buffer, int[] _stripe_heights, int[] _sample_offsets, int[] _sample_gaps, int[] _row_gaps) throws KduException
  {
    return Push_stripe(_buffer,_stripe_heights,_sample_offsets,_sample_gaps,_row_gaps,null,null,(int) 0);
  }
  public boolean Push_stripe(int[] _buffer, int[] _stripe_heights, int[] _sample_offsets, int[] _sample_gaps, int[] _row_gaps, int[] _precisions) throws KduException
  {
    return Push_stripe(_buffer,_stripe_heights,_sample_offsets,_sample_gaps,_row_gaps,_precisions,null,(int) 0);
  }
  public boolean Push_stripe(int[] _buffer, int[] _stripe_heights, int[] _sample_offsets, int[] _sample_gaps, int[] _row_gaps, int[] _precisions, boolean[] _is_signed) throws KduException
  {
    return Push_stripe(_buffer,_stripe_heights,_sample_offsets,_sample_gaps,_row_gaps,_precisions,_is_signed,(int) 0);
  }
  public native boolean Push_stripe(float[] _buffer, int[] _stripe_heights, int[] _sample_offsets, int[] _sample_gaps, int[] _row_gaps, int[] _precisions, boolean[] _is_signed, int _flush_period) throws KduException;
  public boolean Push_stripe(float[] _buffer, int[] _stripe_heights) throws KduException
  {
    return Push_stripe(_buffer,_stripe_heights,null,null,null,null,null,(int) 0);
  }
  public boolean Push_stripe(float[] _buffer, int[] _stripe_heights, int[] _sample_offsets) throws KduException
  {
    return Push_stripe(_buffer,_stripe_heights,_sample_offsets,null,null,null,null,(int) 0);
  }
  public boolean Push_stripe(float[] _buffer, int[] _stripe_heights, int[] _sample_offsets, int[] _sample_gaps) throws KduException
  {
    return Push_stripe(_buffer,_stripe_heights,_sample_offsets,_sample_gaps,null,null,null,(int) 0);
  }
  public boolean Push_stripe(float[] _buffer, int[] _stripe_heights, int[] _sample_offsets, int[] _sample_gaps, int[] _row_gaps) throws KduException
  {
    return Push_stripe(_buffer,_stripe_heights,_sample_offsets,_sample_gaps,_row_gaps,null,null,(int) 0);
  }
  public boolean Push_stripe(float[] _buffer, int[] _stripe_heights, int[] _sample_offsets, int[] _sample_gaps, int[] _row_gaps, int[] _precisions) throws KduException
  {
    return Push_stripe(_buffer,_stripe_heights,_sample_offsets,_sample_gaps,_row_gaps,_precisions,null,(int) 0);
  }
  public boolean Push_stripe(float[] _buffer, int[] _stripe_heights, int[] _sample_offsets, int[] _sample_gaps, int[] _row_gaps, int[] _precisions, boolean[] _is_signed) throws KduException
  {
    return Push_stripe(_buffer,_stripe_heights,_sample_offsets,_sample_gaps,_row_gaps,_precisions,_is_signed,(int) 0);
  }
}
