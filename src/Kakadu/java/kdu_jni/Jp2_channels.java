package kdu_jni;

public class Jp2_channels {
  static {
    System.loadLibrary("kdu_jni");
    Native_init_class();
  }
  private static native void Native_init_class();
  public long _native_ptr = 0;
  public native boolean Exists() throws KduException;
  public native void Copy(Jp2_channels _src) throws KduException;
  public native void Init(int _num_colours) throws KduException;
  public native void Set_colour_mapping(int _colour_idx, int _codestream_component, int _lut_idx, int _codestream_idx) throws KduException;
  public void Set_colour_mapping(int _colour_idx, int _codestream_component) throws KduException
  {
    Set_colour_mapping(_colour_idx,_codestream_component,(int) -1,(int) 0);
  }
  public void Set_colour_mapping(int _colour_idx, int _codestream_component, int _lut_idx) throws KduException
  {
    Set_colour_mapping(_colour_idx,_codestream_component,_lut_idx,(int) 0);
  }
  public native void Set_opacity_mapping(int _colour_idx, int _codestream_component, int _lut_idx, int _codestream_idx) throws KduException;
  public void Set_opacity_mapping(int _colour_idx, int _codestream_component) throws KduException
  {
    Set_opacity_mapping(_colour_idx,_codestream_component,(int) -1,(int) 0);
  }
  public void Set_opacity_mapping(int _colour_idx, int _codestream_component, int _lut_idx) throws KduException
  {
    Set_opacity_mapping(_colour_idx,_codestream_component,_lut_idx,(int) 0);
  }
  public native void Set_premult_mapping(int _colour_idx, int _codestream_component, int _lut_idx, int _codestream_idx) throws KduException;
  public void Set_premult_mapping(int _colour_idx, int _codestream_component) throws KduException
  {
    Set_premult_mapping(_colour_idx,_codestream_component,(int) -1,(int) 0);
  }
  public void Set_premult_mapping(int _colour_idx, int _codestream_component, int _lut_idx) throws KduException
  {
    Set_premult_mapping(_colour_idx,_codestream_component,_lut_idx,(int) 0);
  }
  public native void Set_chroma_key(int _colour_idx, int _key_val) throws KduException;
  public native int Get_num_colours() throws KduException;
  public native boolean Get_colour_mapping(int _colour_idx, int[] _codestream_component, int[] _lut_idx, int[] _codestream_idx) throws KduException;
  public native boolean Get_opacity_mapping(int _colour_idx, int[] _codestream_component, int[] _lut_idx, int[] _codestream_idx) throws KduException;
  public native boolean Get_premult_mapping(int _colour_idx, int[] _codestream_component, int[] _lut_idx, int[] _codestream_idx) throws KduException;
  public native boolean Get_chroma_key(int _colour_idx, int[] _key_val) throws KduException;
}
