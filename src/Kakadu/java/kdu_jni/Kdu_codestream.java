package kdu_jni;

public class Kdu_codestream {
  static {
    System.loadLibrary("kdu_jni");
    Native_init_class();
  }
  private static native void Native_init_class();
  public long _native_ptr = 0;
  public native boolean Exists() throws KduException;
  public native void Create(Siz_params _siz, Kdu_compressed_target _target, Kdu_dims _fragment_region, int _fragment_tiles_generated, long _fragment_tile_bytes_generated) throws KduException;
  public void Create(Siz_params _siz, Kdu_compressed_target _target, Kdu_dims _fragment_region) throws KduException
  {
    Create(_siz,_target,_fragment_region,(int) 0,(long) 0);
  }
  public void Create(Siz_params _siz, Kdu_compressed_target _target, Kdu_dims _fragment_region, int _fragment_tiles_generated) throws KduException
  {
    Create(_siz,_target,_fragment_region,_fragment_tiles_generated,(long) 0);
  }
  public native void Create(Kdu_compressed_source _source, Kdu_thread_env _env) throws KduException;
  public void Create(Kdu_compressed_source _source) throws KduException
  {
    Kdu_thread_env env = null;
    Create(_source,env);
  }
  public native void Create(Siz_params _siz) throws KduException;
  public native void Restart(Kdu_compressed_target _target) throws KduException;
  public native void Restart(Kdu_compressed_source _source, Kdu_thread_env _env) throws KduException;
  public void Restart(Kdu_compressed_source _source) throws KduException
  {
    Kdu_thread_env env = null;
    Restart(_source,env);
  }
  public native void Share_buffering(Kdu_codestream _existing) throws KduException;
  public native void Destroy() throws KduException;
  public native void Enable_restart() throws KduException;
  public native void Set_persistent() throws KduException;
  public native long Augment_cache_threshold(int _extra_bytes) throws KduException;
  public native int Set_tile_unloading_threshold(int _max_tiles_on_list) throws KduException;
  public native boolean Is_last_fragment() throws KduException;
  public native Siz_params Access_siz() throws KduException;
  public native int Get_num_components(boolean _want_output_comps) throws KduException;
  public int Get_num_components() throws KduException
  {
    return Get_num_components((boolean) false);
  }
  public native int Get_bit_depth(int _comp_idx, boolean _want_output_comps) throws KduException;
  public int Get_bit_depth(int _comp_idx) throws KduException
  {
    return Get_bit_depth(_comp_idx,(boolean) false);
  }
  public native boolean Get_signed(int _comp_idx, boolean _want_output_comps) throws KduException;
  public boolean Get_signed(int _comp_idx) throws KduException
  {
    return Get_signed(_comp_idx,(boolean) false);
  }
  public native void Get_subsampling(int _comp_idx, Kdu_coords _subs, boolean _want_output_comps) throws KduException;
  public void Get_subsampling(int _comp_idx, Kdu_coords _subs) throws KduException
  {
    Get_subsampling(_comp_idx,_subs,(boolean) false);
  }
  public native void Get_registration(int _comp_idx, Kdu_coords _scale, Kdu_coords _crg, boolean _want_output_comps) throws KduException;
  public void Get_registration(int _comp_idx, Kdu_coords _scale, Kdu_coords _crg) throws KduException
  {
    Get_registration(_comp_idx,_scale,_crg,(boolean) false);
  }
  public native void Get_relative_registration(int _comp_idx, int _ref_comp_idx, Kdu_coords _scale, Kdu_coords _crg, boolean _want_output_comps) throws KduException;
  public void Get_relative_registration(int _comp_idx, int _ref_comp_idx, Kdu_coords _scale, Kdu_coords _crg) throws KduException
  {
    Get_relative_registration(_comp_idx,_ref_comp_idx,_scale,_crg,(boolean) false);
  }
  public native void Get_dims(int _comp_idx, Kdu_dims _dims, boolean _want_output_comps) throws KduException;
  public void Get_dims(int _comp_idx, Kdu_dims _dims) throws KduException
  {
    Get_dims(_comp_idx,_dims,(boolean) false);
  }
  public native void Get_tile_partition(Kdu_dims _partition) throws KduException;
  public native void Get_valid_tiles(Kdu_dims _indices) throws KduException;
  public native boolean Find_tile(int _comp_idx, Kdu_coords _loc, Kdu_coords _tile_idx, boolean _want_output_comps) throws KduException;
  public boolean Find_tile(int _comp_idx, Kdu_coords _loc, Kdu_coords _tile_idx) throws KduException
  {
    return Find_tile(_comp_idx,_loc,_tile_idx,(boolean) false);
  }
  public native void Get_tile_dims(Kdu_coords _tile_idx, int _comp_idx, Kdu_dims _dims, boolean _want_output_comps) throws KduException;
  public void Get_tile_dims(Kdu_coords _tile_idx, int _comp_idx, Kdu_dims _dims) throws KduException
  {
    Get_tile_dims(_tile_idx,_comp_idx,_dims,(boolean) false);
  }
  public native int Get_max_tile_layers() throws KduException;
  public native int Get_min_dwt_levels() throws KduException;
  public native boolean Can_flip(boolean _check_current_appearance_only) throws KduException;
  public native void Map_region(int _comp_idx, Kdu_dims _comp_region, Kdu_dims _hires_region, boolean _want_output_comps) throws KduException;
  public void Map_region(int _comp_idx, Kdu_dims _comp_region, Kdu_dims _hires_region) throws KduException
  {
    Map_region(_comp_idx,_comp_region,_hires_region,(boolean) false);
  }
  public native void Set_textualization(Kdu_message _output) throws KduException;
  public native void Set_max_bytes(long _max_bytes, boolean _simulate_parsing, boolean _allow_periodic_trimming) throws KduException;
  public void Set_max_bytes(long _max_bytes) throws KduException
  {
    Set_max_bytes(_max_bytes,(boolean) false,(boolean) true);
  }
  public void Set_max_bytes(long _max_bytes, boolean _simulate_parsing) throws KduException
  {
    Set_max_bytes(_max_bytes,_simulate_parsing,(boolean) true);
  }
  public native void Set_min_slope_threshold(int _min_slope) throws KduException;
  public native void Set_resilient(boolean _expect_ubiquitous_sops) throws KduException;
  public void Set_resilient() throws KduException
  {
    Set_resilient((boolean) false);
  }
  public native void Set_fussy() throws KduException;
  public native void Set_fast() throws KduException;
  public native void Apply_input_restrictions(int _first_component, int _max_components, int _discard_levels, int _max_layers, Kdu_dims _region_of_interest, int _access_mode) throws KduException;
  public native void Apply_input_restrictions(int _num_indices, int[] _component_indices, int _discard_levels, int _max_layers, Kdu_dims _region_of_interest, int _access_mode) throws KduException;
  public native void Change_appearance(boolean _transpose, boolean _vflip, boolean _hflip) throws KduException;
  public native void Set_block_truncation(int _factor) throws KduException;
  public native Kdu_tile Open_tile(Kdu_coords _tile_idx, Kdu_thread_env _env) throws KduException;
  public Kdu_tile Open_tile(Kdu_coords _tile_idx) throws KduException
  {
    Kdu_thread_env env = null;
    return Open_tile(_tile_idx,env);
  }
  public native void Create_tile(Kdu_coords _tile_idx, Kdu_thread_env _env) throws KduException;
  public void Create_tile(Kdu_coords _tile_idx) throws KduException
  {
    Kdu_thread_env env = null;
    Create_tile(_tile_idx,env);
  }
  public native Kdu_codestream_comment Get_comment(Kdu_codestream_comment _prev) throws KduException;
  public native Kdu_codestream_comment Add_comment() throws KduException;
  public native void Flush(long[] _layer_bytes, int _num_layer_specs, int[] _layer_thresholds, boolean _trim_to_rate, boolean _record_in_comseg, double _tolerance, Kdu_thread_env _env) throws KduException;
  public void Flush(long[] _layer_bytes, int _num_layer_specs) throws KduException
  {
    Kdu_thread_env env = null;
    Flush(_layer_bytes,_num_layer_specs,null,(boolean) true,(boolean) true,(double) 0.0,env);
  }
  public void Flush(long[] _layer_bytes, int _num_layer_specs, int[] _layer_thresholds) throws KduException
  {
    Kdu_thread_env env = null;
    Flush(_layer_bytes,_num_layer_specs,_layer_thresholds,(boolean) true,(boolean) true,(double) 0.0,env);
  }
  public void Flush(long[] _layer_bytes, int _num_layer_specs, int[] _layer_thresholds, boolean _trim_to_rate) throws KduException
  {
    Kdu_thread_env env = null;
    Flush(_layer_bytes,_num_layer_specs,_layer_thresholds,_trim_to_rate,(boolean) true,(double) 0.0,env);
  }
  public void Flush(long[] _layer_bytes, int _num_layer_specs, int[] _layer_thresholds, boolean _trim_to_rate, boolean _record_in_comseg) throws KduException
  {
    Kdu_thread_env env = null;
    Flush(_layer_bytes,_num_layer_specs,_layer_thresholds,_trim_to_rate,_record_in_comseg,(double) 0.0,env);
  }
  public void Flush(long[] _layer_bytes, int _num_layer_specs, int[] _layer_thresholds, boolean _trim_to_rate, boolean _record_in_comseg, double _tolerance) throws KduException
  {
    Kdu_thread_env env = null;
    Flush(_layer_bytes,_num_layer_specs,_layer_thresholds,_trim_to_rate,_record_in_comseg,_tolerance,env);
  }
  public native int Trans_out(long _max_bytes, long[] _layer_bytes, int _layer_bytes_entries, boolean _record_in_comseg, Kdu_thread_env _env) throws KduException;
  public int Trans_out(long _max_bytes) throws KduException
  {
    Kdu_thread_env env = null;
    return Trans_out(_max_bytes,null,(int) 0,(boolean) false,env);
  }
  public int Trans_out(long _max_bytes, long[] _layer_bytes) throws KduException
  {
    Kdu_thread_env env = null;
    return Trans_out(_max_bytes,_layer_bytes,(int) 0,(boolean) false,env);
  }
  public int Trans_out(long _max_bytes, long[] _layer_bytes, int _layer_bytes_entries) throws KduException
  {
    Kdu_thread_env env = null;
    return Trans_out(_max_bytes,_layer_bytes,_layer_bytes_entries,(boolean) false,env);
  }
  public int Trans_out(long _max_bytes, long[] _layer_bytes, int _layer_bytes_entries, boolean _record_in_comseg) throws KduException
  {
    Kdu_thread_env env = null;
    return Trans_out(_max_bytes,_layer_bytes,_layer_bytes_entries,_record_in_comseg,env);
  }
  public native boolean Ready_for_flush(Kdu_thread_env _env) throws KduException;
  public boolean Ready_for_flush() throws KduException
  {
    Kdu_thread_env env = null;
    return Ready_for_flush(env);
  }
  public native long Get_total_bytes(boolean _exclude_main_header) throws KduException;
  public long Get_total_bytes() throws KduException
  {
    return Get_total_bytes((boolean) false);
  }
  public native int Get_num_tparts() throws KduException;
  public native void Collect_timing_stats(int _num_coder_iterations) throws KduException;
  public native double Get_timing_stats(long[] _num_samples, boolean _coder_only) throws KduException;
  public double Get_timing_stats(long[] _num_samples) throws KduException
  {
    return Get_timing_stats(_num_samples,(boolean) false);
  }
  public native long Get_compressed_data_memory(boolean _get_peak_allocation) throws KduException;
  public long Get_compressed_data_memory() throws KduException
  {
    return Get_compressed_data_memory((boolean) true);
  }
  public native long Get_compressed_state_memory(boolean _get_peak_allocation) throws KduException;
  public long Get_compressed_state_memory() throws KduException
  {
    return Get_compressed_state_memory((boolean) true);
  }
}
