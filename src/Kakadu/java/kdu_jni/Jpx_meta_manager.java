package kdu_jni;

public class Jpx_meta_manager {
  static {
    System.loadLibrary("kdu_jni");
    Native_init_class();
  }
  private static native void Native_init_class();
  public long _native_ptr = 0;
  public native boolean Exists() throws KduException;
  public native void Set_box_filter(int _num_box_types, long[] _box_types) throws KduException;
  public native Jpx_metanode Access_root() throws KduException;
  public native Jpx_metanode Locate_node(long _file_pos) throws KduException;
  public native Jpx_metanode Get_touched_nodes() throws KduException;
  public native Jpx_metanode Peek_touched_nodes(long _box_type, Jpx_metanode _last_peeked) throws KduException;
  public native void Copy(Jpx_meta_manager _src) throws KduException;
  public native void Reset_copy_locators(Jpx_metanode _src, boolean _recursive, boolean _fixup_unresolved_links) throws KduException;
  public void Reset_copy_locators(Jpx_metanode _src, boolean _recursive) throws KduException
  {
    Reset_copy_locators(_src,_recursive,(boolean) false);
  }
  public native boolean Load_matches(int _num_codestreams, int[] _codestream_indices, int _num_compositing_layers, int[] _layer_indices) throws KduException;
  public native Jpx_metanode Enumerate_matches(Jpx_metanode _last_node, int _codestream_idx, int _compositing_layer_idx, boolean _applies_to_rendered_result, Kdu_dims _region, int _min_size, boolean _exclude_region_numlists, boolean _ignore_missing_numlist_categories) throws KduException;
  public Jpx_metanode Enumerate_matches(Jpx_metanode _last_node, int _codestream_idx, int _compositing_layer_idx, boolean _applies_to_rendered_result, Kdu_dims _region, int _min_size) throws KduException
  {
    return Enumerate_matches(_last_node,_codestream_idx,_compositing_layer_idx,_applies_to_rendered_result,_region,_min_size,(boolean) false,(boolean) false);
  }
  public Jpx_metanode Enumerate_matches(Jpx_metanode _last_node, int _codestream_idx, int _compositing_layer_idx, boolean _applies_to_rendered_result, Kdu_dims _region, int _min_size, boolean _exclude_region_numlists) throws KduException
  {
    return Enumerate_matches(_last_node,_codestream_idx,_compositing_layer_idx,_applies_to_rendered_result,_region,_min_size,_exclude_region_numlists,(boolean) false);
  }
  public native Jpx_metanode Insert_node(int _num_codestreams, int[] _codestream_indices, int _num_compositing_layers, int[] _layer_indices, boolean _applies_to_rendered_result, int _num_regions, Jpx_roi _regions) throws KduException;
}
