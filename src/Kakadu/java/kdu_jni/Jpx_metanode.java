package kdu_jni;

public class Jpx_metanode {
  static {
    System.loadLibrary("kdu_jni");
    Native_init_class();
  }
  private static native void Native_init_class();
  public long _native_ptr = 0;
  public native boolean Exists() throws KduException;
  public native boolean Get_numlist_info(int[] _num_codestreams, int[] _num_layers, boolean[] _applies_to_rendered_result) throws KduException;
  public native long Get_numlist_codestreams() throws KduException;
  public native long Get_numlist_layers() throws KduException;
  public native int Get_numlist_codestream(int _which) throws KduException;
  public native int Get_numlist_layer(int _which) throws KduException;
  public native boolean Test_numlist(int _codestream_idx, int _compositing_layer_idx, boolean _applies_to_rendered_result) throws KduException;
  public native int Get_num_regions() throws KduException;
  public native Jpx_roi Get_region(int _which) throws KduException;
  public native int Get_width() throws KduException;
  public native Kdu_dims Get_bounding_box() throws KduException;
  public native boolean Test_region(Kdu_dims _region) throws KduException;
  public native long Get_box_type() throws KduException;
  public native String Get_label() throws KduException;
  public native boolean Get_uuid(byte[] _uuid) throws KduException;
  public native long Get_cross_reference(Jpx_fragment_list _frags) throws KduException;
  public native Jpx_metanode Get_link(int[] _link_type) throws KduException;
  public native Jpx_metanode Enum_linkers(Jpx_metanode _last_linker) throws KduException;
  public native boolean Open_existing(Jp2_input_box _box) throws KduException;
  public native boolean Count_descendants(int[] _count) throws KduException;
  public native Jpx_metanode Get_descendant(int _which) throws KduException;
  public native Jpx_metanode Find_descendant_by_type(int _which, int _num_box_types_of_interest, long[] _box_types_of_interest) throws KduException;
  public native boolean Check_descendants_complete(int _num_box_types_of_interest, long[] _box_types_of_interest) throws KduException;
  public native long Get_sequence_index() throws KduException;
  public native Jpx_metanode Get_parent() throws KduException;
  public native Jpx_metanode Find_path_to(Jpx_metanode _target, int _descending_flags, int _ascending_flags, int _num_exclusion_categories, long[] _exclusion_box_types, int[] _exclusion_flags, boolean _unify_groups) throws KduException;
  public Jpx_metanode Find_path_to(Jpx_metanode _target, int _descending_flags, int _ascending_flags, int _num_exclusion_categories, long[] _exclusion_box_types, int[] _exclusion_flags) throws KduException
  {
    return Find_path_to(_target,_descending_flags,_ascending_flags,_num_exclusion_categories,_exclusion_box_types,_exclusion_flags,(boolean) false);
  }
  public native boolean Change_parent(Jpx_metanode _new_parent) throws KduException;
  public native Jpx_metanode Add_numlist(int _num_codestreams, int[] _codestream_indices, int _num_compositing_layers, int[] _layer_indices, boolean _applies_to_rendered_result) throws KduException;
  public native Jpx_metanode Add_regions(int _num_regions, Jpx_roi _regions) throws KduException;
  public native Jpx_metanode Add_label(String _text) throws KduException;
  public native void Change_to_label(String _text) throws KduException;
  public native Jpx_metanode Add_link(Jpx_metanode _target, int _link_type, boolean _avoid_duplicates) throws KduException;
  public Jpx_metanode Add_link(Jpx_metanode _target, int _link_type) throws KduException
  {
    return Add_link(_target,_link_type,(boolean) true);
  }
  public native void Change_to_link(Jpx_metanode _target, int _link_type) throws KduException;
  public native Jpx_metanode Add_copy(Jpx_metanode _src, boolean _recursive, boolean _link_to_internal_copies) throws KduException;
  public Jpx_metanode Add_copy(Jpx_metanode _src, boolean _recursive) throws KduException
  {
    return Add_copy(_src,_recursive,(boolean) false);
  }
  public native void Delete_node() throws KduException;
  public native boolean Is_changed() throws KduException;
  public native boolean Ancestor_changed() throws KduException;
  public native boolean Is_deleted() throws KduException;
  public native void Touch() throws KduException;
  public native long Get_state_ref() throws KduException;
  public native int Generate_metareq(Kdu_window _client_window, int _num_box_types_of_interest, long[] _box_types_of_interest, int _num_descend_box_types, long[] _descend_box_types, boolean _priority) throws KduException;
  public native int Generate_link_metareq(Kdu_window _client_window, int _num_box_types_of_interest, long[] _box_types_of_interest, int _num_descend_box_types, long[] _descend_box_types, boolean _priority) throws KduException;
}
