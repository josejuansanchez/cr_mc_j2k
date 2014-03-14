package kdu_jni;

public class Kdu_encoder extends Kdu_push_ifc {
  static {
    System.loadLibrary("kdu_jni");
    Native_init_class();
  }
  private static native void Native_init_class();
  protected Kdu_encoder(long ptr) {
    super(ptr);
  }
  private native void Native_destroy();
  public void finalize() {
    if ((_native_ptr & 1) != 0)
      { // Resource created and not donated
        Native_destroy();
      }
  }
  private static native long Native_create(Kdu_subband _subband, Kdu_sample_allocator _allocator, boolean _use_shorts, float _normalization, Kdu_roi_node _roi, Kdu_thread_env _env, long _env_queue);
  public Kdu_encoder(Kdu_subband _subband, Kdu_sample_allocator _allocator, boolean _use_shorts, float _normalization, Kdu_roi_node _roi, Kdu_thread_env _env, long _env_queue) {
    this(Native_create(_subband, _allocator, _use_shorts, _normalization, _roi, _env, _env_queue));
  }
  private static long Native_create(Kdu_subband _subband, Kdu_sample_allocator _allocator, boolean _use_shorts)
  {
    Kdu_roi_node roi = null;
    Kdu_thread_env env = null;
    return Native_create(_subband,_allocator,_use_shorts,(float) 1.0F,roi,env,0);
  }
  public Kdu_encoder(Kdu_subband _subband, Kdu_sample_allocator _allocator, boolean _use_shorts) {
    this(Native_create(_subband, _allocator, _use_shorts));
  }
  private static long Native_create(Kdu_subband _subband, Kdu_sample_allocator _allocator, boolean _use_shorts, float _normalization)
  {
    Kdu_roi_node roi = null;
    Kdu_thread_env env = null;
    return Native_create(_subband,_allocator,_use_shorts,_normalization,roi,env,0);
  }
  public Kdu_encoder(Kdu_subband _subband, Kdu_sample_allocator _allocator, boolean _use_shorts, float _normalization) {
    this(Native_create(_subband, _allocator, _use_shorts, _normalization));
  }
  private static long Native_create(Kdu_subband _subband, Kdu_sample_allocator _allocator, boolean _use_shorts, float _normalization, Kdu_roi_node _roi)
  {
    Kdu_thread_env env = null;
    return Native_create(_subband,_allocator,_use_shorts,_normalization,_roi,env,0);
  }
  public Kdu_encoder(Kdu_subband _subband, Kdu_sample_allocator _allocator, boolean _use_shorts, float _normalization, Kdu_roi_node _roi) {
    this(Native_create(_subband, _allocator, _use_shorts, _normalization, _roi));
  }
  private static long Native_create(Kdu_subband _subband, Kdu_sample_allocator _allocator, boolean _use_shorts, float _normalization, Kdu_roi_node _roi, Kdu_thread_env _env)
  {
    return Native_create(_subband,_allocator,_use_shorts,_normalization,_roi,_env,0);
  }
  public Kdu_encoder(Kdu_subband _subband, Kdu_sample_allocator _allocator, boolean _use_shorts, float _normalization, Kdu_roi_node _roi, Kdu_thread_env _env) {
    this(Native_create(_subband, _allocator, _use_shorts, _normalization, _roi, _env));
  }
}
