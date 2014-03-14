package kdu_jni;

public class Kdu_client extends Kdu_cache {
  static {
    System.loadLibrary("kdu_jni");
    Native_init_class();
  }
  private static native void Native_init_class();
  protected Kdu_client(long ptr) {
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
  public Kdu_client() {
    this(Native_create());
  }
  public native String Check_compatible_url(String _url, boolean _resource_component_must_exist) throws KduException;
  public native void Install_context_translator(Kdu_client_translator _translator) throws KduException;
  public native void Install_notifier(Kdu_client_notifier _notifier) throws KduException;
  public native int Connect(String _server, String _proxy, String _request, String _channel_transport, String _cache_dir, int _mode, String _compatible_url) throws KduException;
  public int Connect(String _server, String _proxy, String _request, String _channel_transport, String _cache_dir, int _mode) throws KduException
  {
    return Connect(_server,_proxy,_request,_channel_transport,_cache_dir,_mode,null);
  }
  public native boolean Is_interactive() throws KduException;
  public native boolean Is_one_time_request() throws KduException;
  public native boolean Connect_request_has_non_empty_window() throws KduException;
  public native String Get_target_name() throws KduException;
  public native boolean Check_compatible_connection(String _server, String _request, int _mode, String _compatible_url) throws KduException;
  public boolean Check_compatible_connection(String _server, String _request, int _mode) throws KduException
  {
    return Check_compatible_connection(_server,_request,_mode,null);
  }
  public native int Add_queue() throws KduException;
  public native boolean Is_active() throws KduException;
  public native boolean Is_alive(int _queue_id) throws KduException;
  public boolean Is_alive() throws KduException
  {
    return Is_alive((int) -1);
  }
  public native boolean Is_idle(int _queue_id) throws KduException;
  public boolean Is_idle() throws KduException
  {
    return Is_idle((int) -1);
  }
  public native void Disconnect(boolean _keep_transport_open, int _timeout_milliseconds, int _queue_id, boolean _wait_for_completion) throws KduException;
  public void Disconnect() throws KduException
  {
    Disconnect((boolean) false,(int) 2000,(int) -1,(boolean) true);
  }
  public void Disconnect(boolean _keep_transport_open) throws KduException
  {
    Disconnect(_keep_transport_open,(int) 2000,(int) -1,(boolean) true);
  }
  public void Disconnect(boolean _keep_transport_open, int _timeout_milliseconds) throws KduException
  {
    Disconnect(_keep_transport_open,_timeout_milliseconds,(int) -1,(boolean) true);
  }
  public void Disconnect(boolean _keep_transport_open, int _timeout_milliseconds, int _queue_id) throws KduException
  {
    Disconnect(_keep_transport_open,_timeout_milliseconds,_queue_id,(boolean) true);
  }
  public native boolean Post_window(Kdu_window _window, int _queue_id, boolean _preemptive, Kdu_window_prefs _prefs) throws KduException;
  public boolean Post_window(Kdu_window _window) throws KduException
  {
    Kdu_window_prefs prefs = null;
    return Post_window(_window,(int) 0,(boolean) true,prefs);
  }
  public boolean Post_window(Kdu_window _window, int _queue_id) throws KduException
  {
    Kdu_window_prefs prefs = null;
    return Post_window(_window,_queue_id,(boolean) true,prefs);
  }
  public boolean Post_window(Kdu_window _window, int _queue_id, boolean _preemptive) throws KduException
  {
    Kdu_window_prefs prefs = null;
    return Post_window(_window,_queue_id,_preemptive,prefs);
  }
  public native boolean Get_window_in_progress(Kdu_window _window, int _queue_id, int[] _status_flags) throws KduException;
  public boolean Get_window_in_progress(Kdu_window _window) throws KduException
  {
    return Get_window_in_progress(_window,(int) 0,null);
  }
  public boolean Get_window_in_progress(Kdu_window _window, int _queue_id) throws KduException
  {
    return Get_window_in_progress(_window,_queue_id,null);
  }
  public native String Get_status(int _queue_id) throws KduException;
  public String Get_status() throws KduException
  {
    return Get_status((int) 0);
  }
  public native long Get_received_bytes(int _queue_id, double[] _non_idle_seconds, double[] _seconds_since_first_active) throws KduException;
  public long Get_received_bytes() throws KduException
  {
    return Get_received_bytes((int) -1,null,null);
  }
  public long Get_received_bytes(int _queue_id) throws KduException
  {
    return Get_received_bytes(_queue_id,null,null);
  }
  public long Get_received_bytes(int _queue_id, double[] _non_idle_seconds) throws KduException
  {
    return Get_received_bytes(_queue_id,_non_idle_seconds,null);
  }
}
