package kdu_jni;

public class Kdu_thread_entity {
  static {
    System.loadLibrary("kdu_jni");
    Native_init_class();
  }
  private static native void Native_init_class();
  public long _native_ptr = 0;
  protected Kdu_thread_entity(long ptr) {
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
  public Kdu_thread_entity() {
    this(Native_create());
  }
  public native void Pre_destroy() throws KduException;
  public native Kdu_thread_entity New_instance() throws KduException;
  public native boolean Exists() throws KduException;
  public native boolean Is_group_owner() throws KduException;
  public native Kdu_thread_entity Get_current_thread_entity() throws KduException;
  public native int Get_num_locks() throws KduException;
  public native void Create(long _cpu_affinity) throws KduException;
  public void Create() throws KduException
  {
    Create((long) 0);
  }
  public native boolean Destroy() throws KduException;
  public native int Get_num_threads() throws KduException;
  public native boolean Add_thread(int _thread_concurrency) throws KduException;
  public boolean Add_thread() throws KduException
  {
    return Add_thread((int) 0);
  }
  public native long Add_queue(Kdu_worker _worker, long _super_queue, String _name, long _queue_bank_idx) throws KduException;
  public long Add_queue(Kdu_worker _worker, long _super_queue) throws KduException
  {
    return Add_queue(_worker,_super_queue,null,(long) 0);
  }
  public long Add_queue(Kdu_worker _worker, long _super_queue, String _name) throws KduException
  {
    return Add_queue(_worker,_super_queue,_name,(long) 0);
  }
  public native void Add_jobs(long _queue, int _num_jobs, boolean _finalize_queue, long _secondary_seq) throws KduException;
  public void Add_jobs(long _queue, int _num_jobs, boolean _finalize_queue) throws KduException
  {
    Add_jobs(_queue,_num_jobs,_finalize_queue,(long) 0);
  }
  public native boolean Synchronize(long _root_queue, boolean _finalize_descendants_when_synchronized, boolean _finalize_root_when_synchronized) throws KduException;
  public boolean Synchronize(long _root_queue) throws KduException
  {
    return Synchronize(_root_queue,(boolean) false,(boolean) false);
  }
  public boolean Synchronize(long _root_queue, boolean _finalize_descendants_when_synchronized) throws KduException
  {
    return Synchronize(_root_queue,_finalize_descendants_when_synchronized,(boolean) false);
  }
  public native boolean Terminate(long _root_queue, boolean _leave_root, int[] _exc_code) throws KduException;
  public boolean Terminate(long _root_queue, boolean _leave_root) throws KduException
  {
    return Terminate(_root_queue,_leave_root,null);
  }
  public native void Register_synchronized_job(Kdu_worker _worker, long _queue, boolean _run_deferred) throws KduException;
  public native boolean Process_jobs(long _wait_queue, boolean _waiting_for_sync, boolean _throw_group_failure) throws KduException;
  public boolean Process_jobs(long _wait_queue) throws KduException
  {
    return Process_jobs(_wait_queue,(boolean) false,(boolean) true);
  }
  public boolean Process_jobs(long _wait_queue, boolean _waiting_for_sync) throws KduException
  {
    return Process_jobs(_wait_queue,_waiting_for_sync,(boolean) true);
  }
  public native void Handle_exception(int _exc_code) throws KduException;
  public native void Acquire_lock(int _lock_id, boolean _allow_exceptions) throws KduException;
  public void Acquire_lock(int _lock_id) throws KduException
  {
    Acquire_lock(_lock_id,(boolean) true);
  }
  public native boolean Try_lock(int _lock_id, boolean _allow_exceptions) throws KduException;
  public boolean Try_lock(int _lock_id) throws KduException
  {
    return Try_lock(_lock_id,(boolean) true);
  }
  public native void Release_lock(int _lock_id) throws KduException;
}
