/*****************************************************************************/
// File: server_local.h [scope = APPS/SERVER]
// Version: Kakadu, V6.4.1
// Author: David Taubman
// Last Revised: 6 October, 2010
/*****************************************************************************/
// Copyright 2001, David Taubman, The University of New South Wales (UNSW)
// The copyright owner is Unisearch Ltd, Australia (commercial arm of UNSW)
// Neither this copyright statement, nor the licensing details below
// may be removed from this file or dissociated from its contents.
/*****************************************************************************/
// Licensee: University of Almeria
// License number: 00305
// The licensee has been granted a UNIVERSITY LIBRARY license to the
// contents of this source file.  A brief summary of this license appears
// below.  This summary is not to be relied upon in preference to the full
// text of the license agreement, accepted at purchase of the license.
// 1. The License is for University libraries which already own a copy of
//    the book, "JPEG2000: Image compression fundamentals, standards and
//    practice," (Taubman and Marcellin) published by Kluwer Academic
//    Publishers.
// 2. The Licensee has the right to distribute copies of the Kakadu software
//    to currently enrolled students and employed staff members of the
//    University, subject to their agreement not to further distribute the
//    software or make it available to unlicensed parties.
// 3. Subject to Clause 2, the enrolled students and employed staff members
//    of the University have the right to install and use the Kakadu software
//    and to develop Applications for their own use, in their capacity as
//    students or staff members of the University.  This right continues
//    only for the duration of enrollment or employment of the students or
//    staff members, as appropriate.
// 4. The enrolled students and employed staff members of the University have the
//    right to Deploy Applications built using the Kakadu software, provided
//    that such Deployment does not result in any direct or indirect financial
//    return to the students and staff members, the Licensee or any other
//    Third Party which further supplies or otherwise uses such Applications.
// 5. The Licensee, its students and staff members have the right to distribute
//    Reusable Code (including source code and dynamically or statically linked
//    libraries) to a Third Party, provided the Third Party possesses a license
//    to use the Kakadu software, and provided such distribution does not
//    result in any direct or indirect financial return to the Licensee,
//    students or staff members.  This right continues only for the
//    duration of enrollment or employment of the students or staff members,
//    as appropriate.
/******************************************************************************
Description:
   Local header file for the "kdu_server" application.  Imported by
"kdu_server.cpp".
******************************************************************************/

#ifndef SERVER_LOCAL_H
#define SERVER_LOCAL_H

#include "kdcs_comms.h"
#include "kdu_serve.h"
#include "kdu_servex.h"
#include "kdu_security.h"

#define KD_MY_RESOURCE_NAME "jpip" // Resource name used by server for sessions
                                   // Note that the name must be lower-case.
#define KD_CHANNEL_ID_LEN 24 // Max length of any channel-ID assigned here

// Defined here:
class kd_message_lock;               // All in-line
class kd_message_sink;               // All in-line
class kd_message_log;                // All in-line

struct kd_request_fields;            // Implemented in "connection.cpp"
struct kd_request;                   // Implemented in "connection.cpp"
class kd_request_queue;              // Implemented in "connection.cpp"
class kds_jpip_channel;              // Implemented in "connection.cpp"
struct kd_target_description;        // Implemented in "connection.cpp"
class kd_connection_thread;          // Implemented in "connection.cpp"
class kd_connection_server;          // Implemented in "connection.cpp"
struct kd_delegation_host;           // Implemented in "connection.cpp"
class kd_delegator;                  // Implemented in "connection.cpp"

struct kds_primary_channel;          // Implemented in-line
struct kds_cid;                      // Implemented in-line
class kd_source_thread;              // Implemented in "source.cpp"
struct kd_source;                    // Implemented in "source.cpp"
struct kd_client_history;            // Implemented in "source.cpp"
class kd_source_manager;             // Implemented in "source.cpp"

extern kdu_message_formatter kd_msg; // Common text output device
extern kd_message_log kd_msg_log;    // Logging device which may go nowhere

#define KD_DELEGATE_RESOLUTION_INTERVAL 20
       // Number of times we connect to known good hosts before we are prepared
       // to retry address resolution of a host which had a problem.

/*****************************************************************************/
/*                            kd_message_lock                                */
/*****************************************************************************/

class kd_message_lock {
  public: // Member functions
    kd_message_lock() { mutex.create(); }
    ~kd_message_lock() { mutex.destroy(); }
    void acquire() { mutex.lock(); }
    void release() { mutex.unlock(); }
  private: // Data
    kdu_mutex mutex;
  };

/*****************************************************************************/
/*                             kd_message_sink                               */
/*****************************************************************************/

  /* Objects of this class are the ultimate destinations for all text messages
   generated by the system.  When used to customize `kdu_error' and
   `kdu_warning', the object's `start_message' and `flush' functions
   employ the `kd_message_lock' object to protect the entire message
   against inter-thread conflicts. */
class kd_message_sink : public kdu_message {
  public: // Member functions
    kd_message_sink(FILE *dest, kd_message_lock *message_lock,
                    bool throw_end_of_message_exception)
      { this->dest = dest; this->lock = message_lock;
        this->throw_eom_exception = throw_end_of_message_exception; }
    void redirect(FILE *dest)
      { this->dest = dest; }
    void put_text(const char *string)
      { fprintf(dest,"%s",string); }
    void flush(bool end_of_message=false)
      {
        fflush(dest);
        if (end_of_message)
          {
            lock->release();
            if (throw_eom_exception)
              throw KDU_ERROR_EXCEPTION;
          }
      }
    void start_message()
      { lock->acquire(); }
  private: // Data
    FILE *dest;
    kd_message_lock *lock;
    bool throw_eom_exception;
  };

/*****************************************************************************/
/*                               kd_message_log                              */
/*****************************************************************************/

  /* The purpose of this class is to provide a global logging facility for
   recording the ASCII text transactions flowing over TCP channels. */

class kd_message_log {
  public: // Member functions
    kd_message_log()
      { output = NULL; buf = NULL; buf_len = 0; }
    ~kd_message_log()
      { if (buf != NULL) delete[] buf; }
    void init(kdu_message *output)
      { this->output = output; }
    void print(const char *buffer, int num_chars, const char *prefix,
               bool leave_blank_line=true);
      /* Prints the first `num_chars' characters of `buffer' in lines, with
         each line prefixed by the supplied `prefix' string.  If
         `leave_blank_line' is true, a blank line is printed before the block
         of text; the blank line will not have  the `prefix' string
         prepended.
      */
    void print(const char *text, const char *prefix,
               bool leave_blank_line=true)
      { /* Same as above, but `text' is a null-terminated string. */
        if (output != NULL)
          print(text,(int) strlen(text),prefix,leave_blank_line);
      }
    void print(kdcs_message_block &block, const char *prefix,
               bool leave_blank_line=true)
      { /* Same as above, but prints the text currently held in the supplied
           message block. */
        if (output != NULL)
          print((char *) block.peek_block(),block.get_remaining_bytes(),prefix,
                leave_blank_line);
      }
  private: // Data
    kdu_message *output;
    char *buf;
    int buf_len; // Num chars which `buf' can hold.
  };

/*****************************************************************************/
/*                            kd_request_fields                              */
/*****************************************************************************/

  // This structure is embedded inside `kd_request'.  It contains pointers to
  // pre-parsed null-terminated strings, representing the bodies of each
  // possible request field.  If any pointer is NULL, the corresponding
  // request field was not encountered in the request.

struct kd_request_fields {
  public: // Functions
    void write_query(kdcs_message_block &block) const;
      /* Writes a JPIP query string containing the same information as this
         structure. */
  public: // Data
    const char *target;
    const char *sub_target;
    const char *target_id;
    const char *channel_id;

    const char *channel_new;
    const char *channel_close;
    const char *request_id;

    const char *full_size;
    const char *region_size;
    const char *region_offset;
    const char *components;
    const char *codestreams;
    const char *contexts;
    const char *roi;
    const char *layers;
    const char *source_rate;

    const char *meta_request;

    const char *max_length;
    const char *max_quality;

    const char *align;
    const char *type;
    const char *delivery_rate;

    const char *model;
    const char *tp_model;
    const char *need;

    const char *capabilities;
    const char *preferences;

    const char *upload;
    const char *xpath_box;
    const char *xpath_bin;
    const char *xpath_query;

    const char *admin_key;
    const char *admin_command;
    const char *unrecognized; // Holds full text of any unrecognized field
  };

/*****************************************************************************/
/*                                kd_request                                 */
/*****************************************************************************/

struct kd_request {
  public:
    kd_request()
      { max_buf_len=0; buf=NULL; init(); }
    ~kd_request()
      { if (buf != NULL) delete[] buf; }
    void init()
      {
        method=resource=query=http_accept=NULL;
        close_connection=preemptive=false;
        memset(&fields,0,sizeof(fields));
        cur_buf_len = 0;
        next=NULL;
      }
    void copy(const kd_request *src);
  public: // Data
    const char *method; // Always points to first token in the request
    const char *resource; // non-NULL if and only if method is GET or POST
    bool close_connection; // If connection to be closed after responding
    bool preemptive; // True unless we parsed a "wait=yes" request field
    kd_request_fields fields; // All parsed request fields
  private: // Helper functions
    void write_method(const char *string, int string_len);
      /* Write this immediately after calling `init'. */
    void write_resource(const char *string, int string_len);
      /* Write this immediately after the method string. */
    void write_query(const char *string, int string_len);
      /* Write this any time after resource. */
    void write_http_accept(const char *string, int string_len);
      /* Write this any time after resource. */
    void set_cur_buf_len(int len)
      {
        if (len > max_buf_len)
          {
            char *existing = buf;
            max_buf_len = len + 100;
            buf = new char[max_buf_len];
            if (cur_buf_len > 0) memcpy(buf,existing,cur_buf_len);
            if (existing != NULL) delete[] existing;
          }
        cur_buf_len = len;
      }
  private: // Data
    friend class kd_request_queue;
    const char *query; // Private, because we will break it apart later
    const char *http_accept; // NULL or points to body of HTTP "Accept:" header
    int cur_buf_len;
    int max_buf_len;
    char *buf;
    kd_request *next;
  };

/*****************************************************************************/
/*                             kd_request_queue                              */
/*****************************************************************************/

  /* Provides all the functionality needed to parse HTTP GET and HTTP POST
     requests, extract their query strings (either in the query component
     of the HTTP GET request line, or in the body of a POST requst), and
     manage a queue of such requests. */

class kd_request_queue {
  public: // Member functions
    kd_request_queue()
      { head=tail=pending=free_list = NULL; init(); }
    ~kd_request_queue();
    void init();
      /* Sets to the uninitialized state, except that any allocated
         `kd_request' structures are moved to the free list, rather than
         being destroyed. */
    bool read_request(kdcs_tcp_channel *channel);
      /* This function plays a similar role to
         `kdcs_tcp_channel::read_paragraph', which it uses.  The function
         reads an initial request paragraph, checking to see if it corresponds
         to an HTTP GET or POST.  For GET paragraphs, the function creates a
         complete new `kd_request' structure immediately.  For POST
         requests, the function also reads the entity body to recover the
         query string, if any.
         [//]
         The function does not block the caller; if insufficient data is
         available to completely parse the request, it returns false, but may
         be called again any number of times until the operation has been
         completed.  As with `kdcs_tcp_channel::read_paragraph' (which it uses)
         error conditions (e.g. failure of the TCP channel) will result in
         an exception being thrown, of type `kdu_exception'.
         [//]
         Upon success (i.e., whenever the function returns true), a
         new `kd_request' entry is always created and appended to the queue.
         If the request did not correspond to a recognized HTTP request,
         the request's `resource' string is set to NULL and all members of
         the `fields' structure will be NULL.  Otherwise, `resource' points
         to the original resource string (hex-hex decoded, if necessary) and
         the members of the `fields' structure are each set either to NULL
         (if the request field was not found) or to point to a pre-parsed
         null-terminated string, which has been hex-hex decoded if necessary.
         [//]
         Note that the `kd_request_fields.type' member may be derived
         either from an HTTP "Accept:" header line, or from a JPIP "type="
         request field in the query string.  The `kd_request_fields.target'
         member may be derived either from the resource string (after
         skipping over protocol prefixes) or from a JPIP "target=" request
         field in the query string.
         [//]
         If the request suggests that the TCP connection should be closed
         after the response is complete, the `kd_request::close_connection'
         member is set to true.  This is done if the request contained
         a "Connection: close" header or an HTTP version less than HTTP/1.1.
         [//]
         Exceptions thrown while trying to read the channel are not
         caught inside this function; the caller should generally catch
         them and close the channel.
      */
    void push_copy(const kd_request *src);
      /* Copies the `src' object to form an entry which is pushed onto the
         queue. */
    const kd_request *peek_head() { return head; }
      /* This function returns NULL or a pointer to the first complete
         request in the queue. */
    const kd_request *pop_head();
      /* Returns the least recent (head) request in the queue, or NULL if
         the queue is empty.  The returned record may cease to be valid if
         you perform further operations on the request queue. */
    void replace_head(const kd_request *hd)
      { /* You can use this function to return the request previously fetched
           using `pop_head' back to the head of the request queue.  You
           can only return the most recently popped head. */
        kd_request *tmp = free_list;
        assert(hd == tmp);
        free_list = tmp->next;
        tmp->next = head;
        head = tmp;
        if (tail == NULL)
          tail = tmp;
      }
    bool have_preempting_request(const char *channel_id);
      /* This function scans the list of requests currently on the queue
         for one which would pre-empt a current request with the indicated
         JPIP channel-ID.  A pre-empting request is any request issued
         with the same channel-ID which does not specify WAIT, except
         for requests which ask for the allocation of a new channel. */
    void transfer_state(kd_request_queue *src);
      /* This function appends all fully parsed requests, plus the state of
         any partially parsed request to the current object, as though the
         requsts had been read into this object instead of `src'.  The
         function leaves `src' in the initialized state (as though `src->init'
         had just been called).  The function MUST NOT BE USED unless you are
         sure that the current object contains no partially parsed requests of
         its own, since at most one request can be in a partially parsed
         state. */
  private: // Helper functions
    kd_request *get_empty_request()
      {
        kd_request *req = free_list;
        if (req == NULL) req = new kd_request;
        free_list = req->next;
        req->init();
        return req;
      }
    void return_request(kd_request *req)
      {
        req->next = free_list;
        free_list = req;
      }
    void complete_pending_request();
      /* Called when `pending' points to a completed request.  Starts by
         hex-hex decoding the resource and query strings.  Then scans through
         the query string (and possibly the `resource' and `http_accept'
         strings) in order to complete all the various members of the
         `kd_request::fields' structure.  Also determines whether or not the
         JPIP "wait=" request field is present, setting the `preemptive'
         member accordingly.  Finally appends the pending request to the end
         of the queue and resets `pending' to NULL. */
  private: // Data
    kd_request *head, *tail;
    kd_request *free_list;
    int pending_body_bytes;
    kd_request *pending; // Partially created request
  };

/*****************************************************************************/
/*                             kds_jpip_channel                              */
/*****************************************************************************/

class kds_jpip_channel : public kdcs_channel_servicer {
  protected: // You cannot invoke the destructor explicitly -- use `release'
    virtual ~kds_jpip_channel()
      {
        mutex.destroy();
        internal_event.destroy();
        assert((holding_head == NULL) && (transmitted_head == NULL));
        while ((completed_tail = completed_head) != NULL)
          {
            completed_head = completed_tail->next;
            return_to_free_list(completed_tail);
          }
        kd_queue_elt *qelt;
        while ((qelt=free_list) != NULL)
          { free_list = qelt->next;  delete qelt; }
      }
  public: // Member functions which apply to primary and auxiliary channels
    kds_jpip_channel(kdcs_channel_monitor *monitor,
                     kdcs_tcp_channel *channel,
                     int max_chunk_bytes,
                     float max_bytes_per_second);
      /* Here, `monitor' is the global channel monitor object which is
         used to service all channel I/O which would otherwise block
         data processing threads.  It is used to synchronize an internal
         timer.  The `channel' object is used for all communication.  It
         is normally obtained directly from a call to
         `kdcs_channel_monitor::accept'.
         [//]
         The `max_chunk_bytes' argument provides an upper bound on the
         size of any chunk pushed into the `push_chunks' function.  This
         parameter is used both for flow control and to allocate buffers
         with a consistent size, where chunks must be internally buffered
         up.
      */
    void release() { close(false); release_ref(); }
      /* You must use this function in place of the destructor. */
    void set_bandwidth_limit(float max_bytes_per_second);
      /* This function provides you with a way of temporarily reducing the
         maximum bandwidth associated with a channel, below the limit
         imposed by the `max_bytes_per_second' argument supplied to the
         object's constructor.  You can call this function as often as
         you like.  You can also call this function with a value <= 0 to
         restore the bandwidth restriction to that supplied to the
         constructor.  This function can be very useful in implementing
         custom bandwidth restrictions within JPIP channels, since the
         machinery for estimating bandwidth and using bandwidth estimates
         is complex to reproduce elsewhere, and carefully implemented within
         the present object. */
    void set_timeout(float seconds);
      /* [SYNOPSIS]
           Sets a deadline, the indicated number of `seconds' in the future
           (relative to the current time) at which blocking calls on this
           object will timeout.
           [//]
           There is no default timeout.  You can set a new timeout any time
           you like, even after a previous one has expired, causing a
           blocking call to fail.  In fact, timeouts do not prevent the object
           from continuing to transmit data on its internal holding queue.
           They are used only to unblock potentially blocking calls.
           [//]
           The present object only provides three blocking calls:
           [>>] `close' may need to block the caller until the internal holding
                queue has been emptied.
           [>>] `get_suggested_bytes' may block the caller until the holding
                queue is sufficiently empty to avoid excessive channel delays.
           [>>] `retrieve_requests' may block the caller until new requests
                are received.
           [//]
           The internal implementation currently allows for only a single
           thread to use these blocking calls at any given time, but this
           should not represent any limitation in practice.  The present
           function, however, may be called by a different thread.  This
           allows blocked source threads to be woken up from another thread
           by setting a timeout of 0 (or even a negative value).
         [ARG: seconds]
           If this argument is negative, timeouts are cancelled.
      */
    bool timeout_has_occurred()
      { return ((timeout_gate >= 0) && (cur_time >= timeout_gate)); }
      /* Returns true if a timeout has occurred.  This function does not
         recalculate the current time, so it may return false even if a
         set timeout has been passed.  However, if any call to `close',
         `retrieve_requests' or `get_recommended_bytes' encountered a
         timeout, the present function will return true.
      */
    bool close(bool send_queued_data_first=true);
      /* If `send_queued_data_first' is true, this function attempts to
         transmit all data on the internal holding queue before closing
         the internal `kdcs_tcp_channel'.  This may potentially block the
         caller.  If a timeout occurs while the caller is blocked (or if
         the timeout has already occurred prior to entering), the function
         returns false and leaves the channel open (`is_active' will report
         true).  The caller may then either adjust the timeout (see
         `set_timeout') and try again, or call the function with
         `send_queued_data_first' equal to false, in which case all queued
         data is treated as if it had been transmitted and the function
         returns true.
         [//]
         The function also succeeds, returning true, if the channel is
         unexpectedly closed due to some error or a client disconnection.
         [//]
         After calling this function, you can still invoke
         `retrieve_completed_chunks' to retrieve the `kds_chunk' objects
         associated with data chunks that have been transmitted (or
         passed over if `send_queued_data_first' was false).
      */
    bool is_active() { return (channel != NULL); }
      /* Returns false after a successful call to `close'.  Also returns false
         if the channel has been unexpectedly shut down (e.g., due to some
         unexpected failure, or client disconnection).
      */
    void set_auxiliary(float min_rtt_target, float max_rtt_target);
      /* Call this function to convert an object initially set up to
         communicate as a primary channel into an auxiliary TCP channel
         for use with the HTTP-TCP transport protocol.
         [//]
         The complete HTTP-TCP protocol involves at least two channels
         (a primary channel for HTTP requests and responses, and an
         auxiliary channel for chunked data).
         [//]
         More generally, it is possible to manage a single JPIP session
         with N JPIP channels, where any or all of the N JPIP channels might
         have their own auxiliary channel for chunked data and
         requests/responses for the JPIP channels might be handled by
         anywhere from 1 to N primary HTTP channels.  You can use the
         `event_to_signal' arguments offered by `retrieve_requests' and
         `get_recommended_bytes' to jointly wait for the conditions
         required to generate and/or transmit data for any or all of the
         JPIP channels.
         [//]
         You should note that this function may need to block the caller
         until queued data in the original HTTP cannel can be transmitted.
         It is hard to imagine why this would not happen immediately, but
         just in case, you should be aware that clearing of the holding
         queue is subject to any pre-existing timeout.  If the timeout
         expires, the channel will be closed before the function returns.
         If this concerns you, you might like to set a suitable timeout
         before calling this function.
      */
    int get_suggested_bytes(bool blocking=true,
                            kdu_event *event_to_signal=NULL);
      /* Returns a suggested number of bytes for the application to prepare
         for transmission and push in via `push_chunks', while keeping the
         communication channel responsive to requests which might
         indicate a change in the client's window of interest.
         [//]
         The function returns 0 if the holding queue is deemed to be too
         full, so that pushing additional data via `push_chunks' or
         `push_reply' would cause the channel delay to grow unacceptably
         (our objective is to keep the communication channel responsive).
         [//]
         If `blocking' is true, the function blocks the caller until the
         queue becomes sufficient empty for the function to return non-zero,
         or a timeout occurs (see `set_timeout').
         [//]
         If `event_to_signal' is non-NULL, the function does not block
         (regardless of the value of the `blocking' argument).  Instead, it
         stores the reference to this `kdu_event' object internally, so that
         `kdu_event::set' can be called once a blocking call to this function
         would proceed immediately.  The internal reference to the
         `event_to_signal' object is maintained only up until the point when
         the condition occurs (i.e., when the holding queue becomes
         sufficiently empty for a non-zero return or a timeout occurs).
         The internal reference to the `event_to_signal' object is also
         removed if the present function is called again with a different
         (possibly NULL) `event_to_signal' argument.  The event itself is
         not set inside this function, so a successful return will leave
         `event_to_signal' untouched.
      */
    kds_chunk *push_chunks(kds_chunk *chunks, const char *content_type,
                           bool finished_using_channel=false);
      /* This function enters a list of new data chunks into a temporary
         holding queue, from which they will be taken into the transmission
         queue as slots become available.  If the transmission queue is
         held up, the holding queue may grow indefinitely, which is not
         advisable for many reasons.  As a result, you are strongly
         advised to use `get_suggested_bytes' to check that the holding
         queue is not too full, before generating data chunks to push
         into this function.
         [//]
         If this is an auxiliary TCP channel (i.e., `set_auxiliary' has been
         called), the `kds_chunk::prefix_bytes' members should all equal 8
         and the `content_type' argument is ignored.
         [//]
         If this is an HTTP channel (i.e., `set_auxiliary' has been called),
         the `kds_chunk::prefix_bytes' portion of each chunk is discarded and
         the chunk byte counts are adjusted accordingly, but `content_type'
         should identify the MIME media type, or any valid string which
         may appear within an HTTP content-type header.
         [//]
         This function can safely be called at any time, regardless of whether
         the channel has been closed or a timeout has occurred.  It always
         succeeds, regardless of whether the return value is NULL or not.
         A non-NULL return value is used to return chunks which the caller
         must recycle immediately -- which may include those chunks just
         pushed in.  The caller should also use `retrieve_completed_chunks'
         to retrieve chunks which later become available for recycling.
         [//]
         For HTTP channels, the function always returns the list of chunks
         which are pushed in, copying them internally; this alows the channel
         to be passed around from session to session without blocking on the
         transmission of existing data.  Even for auxiliary TCP channels, the
         caller must be prepared to recycle chunks immediately in case the
         function returns non-NULL; it may do this if the channel has
         already closed down for some reason.
         [//]
         The `finished_using_channel' argument is meaningful only with
         auxiliary channels.  If true, it means that there will be no more
         chunks pushed into the channel, so the internal machinery should
         stop looking for acknowledgement messages once all chunks have
         been transmitted and acknowledged.  Otherwise, the internal
         machinery still checks for acknowledgements which might be
         sent by the client as a means of verifying that the client
         is using the channel correctly.  This funcionality is not really
         necessary, since if the channel dies while looking for an
         acknowledgement message, it will be shut down.  However, the
         additional information provided by this argument helps in debugging.
      */
    void terminate_chunked_data(kdu_byte eor_code=0);
      /* For a primary (HTTP) channel (one for which `set_auxiliary' has not
         been called), chunked data is delivered together with HTTP replies.
         In this case, you should invoke this function once you know that the
         chunks most recently pushed into `push_chunks' constitute a complete
         response to the relevant request and that no further chunks
         will be pushed in until after a new reply has been pushed via
         `push_reply'.
         [//]
         The function terminates the chunked transfer encoding associated
         with the current response.  If the existing collection of chunks
         do not already contain a JPIP EOR (End-Of-Response) message, you
         can force the current function to synthesize one by specifying a
         non-zero `eor_code' argument.  In that case, `eor_code' should be
         one of the codes defined by the macros JPIP_EOR_... in
         "kdcs_comms.h".
         [//]
         For an auxiliary TCP channel (one for which `set_auxiliary' has been
         called), chunked data is delivered all by itself but the JPIP
         standard requires each and every request to have a corresponding
         EOR (End-Of-Response) message.  If a request is completed, its
         chunk list might contain an EOR message when supplied to
         `push_chunks'. For all other cases, including requests which
         are pre-empted so that no chunk list is ever generated, the
         present function may be used to queue the transmission of an
         isolated data chunk containing a single EOR message with the
         `eor_code' reason code.  Calling this function with `eor_code'=0
         does nothing at all for auxiliary channels.
      */       
    kds_chunk *retrieve_completed_chunks();
      /* This function returns a list of previously pushed chunks which
         are no longer needed by the transmission mechanism.  Since
         transmission is asynchronous with calls to the `push_chunks' function,
         the caller must not recycle any pushed chunks until it gets the
         go-ahead from this function, unless the call to `push_chunks'
         returned a non-NULL list of chunks which must be recycled
         immediately (as explained with `push_chunks', the caller of that
         function must be prepared to recycle chunks immediately).
         [//]
         Applications need only call this function once to retrieve all
         completed chunks; typically, this should be done shortly before
         a call to `push_chunks' so as to minimize needless storage.
         [//]
         In practice, you will never need to call this function with an
         HTTP channel, since `push_chunks' always returns the chunks that
         are pushed in that case.  Nevertheless, there is no harm in calling
         the function, regardless of whether the channel is an auxiliary TCP
         channel or an HTTP channel, and this probably provides the best
         protection against internal implementation changes.  In fact, it is
         safe to call the function at any time, regardless of whether the
         channel has been closed or a timeout has occurred.
      */
  public: // Member functions used only with a primary HTTP channel
    void push_reply(kdcs_message_block &block, int body_bytes);   
      /* Use this function only with a primary HTTP channel.  Auxiliary
         channels push chunks only; if invoked on an auxiliary channel, the
         function will generate an error through `kdu_error' -- you should
         not do this.
         [//]
         Similar to `push_chunks', but pushes HTTP reply text stored in
         `block'.  As with `push_chunks', this function does not block the
         caller.  It just enters the pushed reply text into a holding queue
         until it can be transmitted.
         [//]
         The `body_bytes' argument can take three different types of values
         as follows:
         [>>] If 0, the message `block' is an HTTP reply paragraph that is
              not followed by any body data.  The reply paragraph should
              terminate with a blank line, where each line terminates with
              a CRLF pair.
         [>>] If positive, the message `block' contains an HTTP reply
              paragraph that is followed by `body_bytes' of body data.
              The reply paragraph itself should terminate with a blank line.
              The body data appears within the message `block' as well, so
              the entire thing can be transmitted as a single entity.  The
              initial reply paragraph portion in `block' should contain all
              relevant Content-Length, Transfer-encoding and Content-Type
              headers for a legitimate HTTP response.  Either chunked or
              contiguous transfer encodings may be used so long as all
              headers are data appear within `block'.  The reason for
              supplying the `body_bytes' value in this case is only to help
              logging services record only the reply text, skipping the
              body data.
         [>>] If negative, the implementation associates the reply text
              supplied here with the data chunks pushed in via `push_chunks'.
              In this case, the reply text will not be delivered until
              the next data chunk is pushed in via `push_chunks'.  At that
              time, the implementation automatically adds the relevant
              Content-Type and Transfer-encoding HTTP headers, so they
              should not appear in the reply text passed in via the
              `block' argument.  In this case, as with both cases discussed
              above, the reply paragraph itself must conclude with a blank
              line.
         [//]
         As with all the push functions, it is fine to call this function
         at any time, even after the channel has been closed or a timeout
         has occurred.  Of course, if the channel has indeed been closed
         already, there is no hope of ever delivery anything, so reply
         text is immediately discarded.  You can use the `is_active'
         function to determine whether or not the channel has been closed.
      */
    bool retrieve_requests(kd_request_queue *queue, bool blocking=true,
                           kdu_event *event_to_signal=NULL);
      /* Use this function only with a primary HTTP channel.  Auxiliary
         channels push chunks only; if invoked on an auxiliary channel, the
         function will return false immediately, but it makes little or
         no sense ever to invoke the function on an auxiliary channel.
         [//]
         Retrieves requests which have been received on the underlying
         `kdcs_channel' object, appending them to the supplied queue.
         [//]
         The function returns true if one or more new requests are appended to
         the `queue' and false otherwise.
         [//]
         If `blocking' is true, the caller is blocked until the function can
         return true, the channel is closed or a timeout occurs.  Premature
         closure of the channel may be detected by calling `is_active'.
         If the function fails due to a timeout, you can always set a
         new timeout (see `set_timeout') and continue processing.
         [//]
         If `event_to_signal' is non-NULL, the function does not block
         (regardless of the value of the `blocking' argument).  Instead, it
         stores the reference to this `kdu_event' object internally, so that
         `kdu_event::set' can be called once a blocking call to this function
         would proceed immediately.  The internal reference to the
         `event_to_signal' object is maintained only up until the point when
         the condition occurs (i.e., when a request arrives or a timeout
         occurs).  The internal reference to the `event_to_signal' object
         is also removed if the present function is called again with a
         different (possibly NULL) `event_to_signal' argument.  The event
         itself is not set inside this function, so a successful return will
         leave `event_to_signal' untouched.
         [//]
         If the channel is closed (even if unexpectedly), the function does
         not return false unless the internal request queue is empty; in that
         case, the function returns false without blocking the caller, or
         taking any notice of `event_to_signal', so you should check the
         status of the channel by calling the `is_active' function after a
         false return.
      */
    void return_requests(kd_request_queue *queue);
      /* Puts the requests in the supplied `queue' back onto the head of
         the object's internal request queue, emptying the supplied `queue'
         in the process.  This is important if the object needs to be
         passed from one domain (e.g. a source handling thread) to another,
         based on the parsing of a request.
         [//]
         Use this function only with a primary HTTP channel.  Auxiliary
         channels push chunks only; if invoked on an auxiliary channel, the
         function will generate an error through `kdu_error'.
      */
  public: // Statistics reporting functions
    double get_ellapsed_seconds()
      { /* Returns the number of seconds which have ellapsed since the
           object was constructed. */
        mutex.lock();
        cur_time = timer.get_ellapsed_microseconds();
        kdu_long usecs = cur_time-start_time;
        mutex.unlock();
        return ((double) usecs) * 0.000001; 
      }
    double get_active_seconds()
      {
        mutex.lock();
        cur_time = timer.get_ellapsed_microseconds();
        kdu_long usecs =
          (idle_start < 0)?(cur_time-start_time):(idle_start-start_time);
        usecs -= idle_usecs;
        mutex.unlock();
        return ((double) usecs) * 0.000001;
      }
      /* Returns the number of seconds since the object was constructed,
         during which the channel has not been idle.  The channel is
         considered to be idle when the internal transmission and
         holding queues are empty.
         [//]
         In practice, there is no reliable way to measure activity for a
         primary HTTP channel and this function wll tend to under-report
         active time in this case.
         [//]
         For an auxiliary TCP channel, however, activity reporting can be
         reasonably reliable, due to the presence of acknowledgement
         feedback from the client, which allows us to assess whether
         the communication pipe is empty. */
    kdu_long get_total_transmitted_bytes(bool include_holding_bytes=false)
      { kdu_long result = total_transmitted_bytes;
        if (include_holding_bytes)
          { mutex.lock(); result = total_transmitted_bytes;
            result += holding_bytes; mutex.unlock(); }
        return result;
      }
      /* Returns the total number of bytes which have been transmitted
         by this object since it was constructed. */
    kdu_long get_num_acknowledged_bytes() { return total_acknowledged_bytes; }
      /* Returns the total number of bytes which have been transmitted and
         acknowledged, since this object was constructed. */
    kdu_long get_total_rtt_events() { return total_rtt_events; }
      /* Returns the number of round-trip-times counted for auxiliary TCP
         channels (0 for primary HTTP channels). */
    float get_total_rtt_seconds() { return (total_rtt_usecs * 0.000001F); }
      /* Returns the total amount of time associated with all counted
         round-trip-times for auxiliary TCP channels (0 for primary HTTP
         channels). */
  protected: // Implementation of `kdcs_channel_servicer'
    void service_channel(kdcs_channel_monitor *monitor,
                         kdcs_channel *channel, int cond_flags);
      /* Implements the pure virtual `kdcs_channel_servicer::service_channel'
         function, which is invoked from the `kdcs_channel_monitor'
         object when one or more registered channel I/O conditions occur.
      */
  private: // Private definitions
    struct kd_queue_elt {
      kd_queue_elt() { chunk_copy = NULL; }
      ~kd_queue_elt() { if (chunk_copy != NULL) delete[] chunk_copy; }
      kd_queue_elt *next;
      kdcs_message_block reply; // HTTP reply text, if any
      int reply_body_bytes; // -ve if waiting for chunk; +ve if reply has body
      kds_chunk *chunk; // May be NULL if the reply has no body
      int reply_bytes; // Num bytes in `reply' before any adjustments
      int num_eor_chunks; // Number of isolated EOR messages to send first
      int num_pending_eor_chunk_acks; // Number of EOR-chunk acks unreceived
      bool pending_chunk_ack; // True if waiting for ack from main chunk
      int chunk_bytes; // See below
      kdu_byte *chunk_copy; // NULL for auxiliary channels
      kdu_byte eor_chunk[11]; // Used for sending isolated EOR messages
      int started_bytes; // See below
      kdu_long transmit_time; // Time at which this record was transmitted
      int window_bytes; // Unacknowledged bytes right after transmitting this
      kdu_long interval_start_time; // See below
      int interval_bytes; // See below
    };
      /* Notes:
             `chunk_bytes' is equal to the number of bytes from `chunk'
           which have still to be transmitted (0 if `chunk' is NULL).
             `reply_bytes' is equal to the number of bytes from `reply'
           which have still to be transmitted.
             `num_eor_chunks' is the number of times the 11-byte `eor_chunk'
           should be sent before `chunk' data can be sent.  This is applicable
           only for auxiliary channels.
             `started_bytes' is 0 before anything is transmitted for this
           element.  Once transmission starts, `started_bytes' is set to
           the number of bytes we need to transmit.  It may be increased if
           we discover the need to send more data. Once all transmission is
           complete, `started_bytes' holds the number of bytes we have
           transmitted.
           [//]
           The quantities `interval_start_time' and `interval_bytes' are used
           to estimate network transmission rate R.  For HTTP-only transports,
           there is no explicit feedback channel from the client, so we
           can only estimate the network rate during periods when the TCP
           queue is full.  At these times, the holding queue will be
           non-empty for an extended period of time.  We estimate the
           network rate during these periods as follows.  When a holding
           element cannot be transmitted due to the TCP queue being too
           full, we set that element's `interval_start_time' member to
           the current time (otherwise, it is left equal to -1) and we
           set the element's `interval_bytes' member equal to the sum of
           its `reply_bytes' and `chunk_bytes' members.  From this point
           until the holding queue is finally emptied, we arrange for each
           element to be assigned the same `interval_start_time' and
           accumulate the total number of bytes transmitted from the
           interval start time in each element's `interval_bytes' member.  In
           this way, when an element is finally transmitted, having a
           non-negative `interval_start_time', the network rate can be
           estimated by dividing `interval_bytes' by `interval_start_time'.
           We apply a recursive filter to such network rate observations.
           In between such observations (when the TCP queue is not overflowing)
           we progressively increase our estimates of the network rate so
           as to encourage more and more data to be pushed into the holding
           queue, so that TCP overflow has a chance of occurring.
           [//]
           For auxiliary TCP channels, we use `interval_start_time' and
           `interval_bytes' to estimate the queueing delay, D, and
           transmission rate, R.  To understand how this works, consider the
           analogy of a leaky bucket which is filled with data in a sporadic
           manner but leaks (transmits) this data in a comaratively continuous
           manner at rate R.  Let QP denote an element on the transmission
           queue.  Let QP_T denote the time at which the element is pushed
           into the bucket (i.e., `transmit_time') and let QP_A denote the
           time at which the element's acknowledgement comes back from the
           client.  Finally, let QP_F denote the fullness of the leaky
           bucket right after QP is pushed in.  It follows that we should
           have QP_A - QP_T = D + QP_F / R.  The problem for channel
           state estimation lies in estimating QP_F.  We could use
           `window_bytes' as an estimate for QP_F, but this works well only if
           the entire burst of chunks to transmit are dumped onto the queue
           almost instantaneously, so that all unacknowledged bytes (this is
           the meaning of `window_bytes') are sitting in the bucket and no
           significant transmission occurs until after all chunks in the
           transmission burst have been pushed in (thereafter, we have to
           assume that no more data is pushed in until the bucket completely
           empties).
           [//]
           The policy implemented here is slightly more general.  It imposes
           the "instantaneous transmission" assumption only on the set of
           chunks pushed into the bucket from the start of the burst up until
           the point at which the XH element is pushed in, where XH denotes
           the `transmitted_head' element at the time when `QP' is pushed in.
           In this case, the total number of bytes which leak out of the
           bucket from the time XH_T until the time QP's bytes have all
           leaked out can be estimated by adding the `window_bytes' member
           of element XH to the number of bytes in all elements after XH up
           to and including QP.  This is the value of the `interval_bytes'
           member of the element QP.  The time taken for these bytes to all
           leak out and for the acknowledgement to come back is QP_A - XH_T.
           Accordingly, we estimate: QP_A - XH_T = D + `interval_bytes' / R.
           This method is the same as the first if XH actually contains the
           first chunk in the transmission burst.  The `interval_start_time'
           member holds the value of XH_T.
      */
  private: // Helper functions, all called with the `mutex' locked
    void send_data();
      /* This function is called when the holding queue has something to
         send and we have reason to believe we could send it.  If the
         function cannot yet transmit everything that is ready to transmit,
         it sets `waiting_to_transmit' before returning.  Note that the
         `channel' member could potentially be NULL when this function
         enters; this means that the channel has been closed, in which
         case the function does nothing. */
    bool process_acknowledgements();
      /* This function reads as many acknowledgement messages as it can
         from an auxiliary channel's receive queue, moving transmitted
         queue elements to the completed list as appropriate, and
         updating channel estimates as it goes.  The function returns true
         if one or more acknowledgement messages were received, which 
         indicates to the caller that it may now be possible to transmit
         more data from the holding queue. */
    void update_windowing_parameters(kdu_long interval_usecs,
                                     int interval_bytes,
                                     kdu_long acknowledgement_usecs,
                                     int acknowledgement_window);
      /* This function implements the adaptive algorithms which adjust the
         window threshold in order to achieve the target RTT, and also adjust
         the target RTT itself.  The first two arguments identify the time
         from the point at which the current acknowledgement interval started
         until the present record is acknowledged, and the number of bytes
         pushed into the queue since the acknowledgement window started, up to
         and including the point at which the current record was pushed into
         the queue.  The second two arguments indicate the round-trip-time
         for the current record and the number of outstanding bytes in the
         transmission queue (window) immediately after the current record
         was transmitted. */
    kd_queue_elt *get_new_element()
      {
        kd_queue_elt *qelt = free_list;
        if (qelt == NULL)
          qelt = new kd_queue_elt;
        else
          free_list = qelt->next;
        qelt->next = NULL;
        qelt->reply.restart();
        qelt->reply_body_bytes = 0; qelt->chunk = NULL;
        qelt->num_eor_chunks = 0; qelt->num_pending_eor_chunk_acks = 0;
        qelt->pending_chunk_ack = false;
        qelt->reply_bytes = qelt->chunk_bytes = qelt->started_bytes = 0;
        qelt->transmit_time = qelt->interval_start_time = -1;
        qelt->window_bytes = qelt->interval_bytes = 0;
        return qelt;
      }
    kd_queue_elt *append_to_completed_list(kd_queue_elt *elt)
      {
        elt->next = NULL;
        if (completed_tail == NULL)
          completed_tail = completed_head = elt;
        else
          completed_tail = completed_tail->next = elt;
        return elt;
      }
    kd_queue_elt *append_to_holding_list(kd_queue_elt *elt)
      {
        elt->next = NULL;
        if (holding_tail == NULL)
          holding_tail = holding_head = elt;
        else
          holding_tail = holding_tail->next = elt;
        return elt;
      }
    kd_queue_elt *append_to_transmitted_list(kd_queue_elt *elt)
      {
        elt->next = NULL;
        if (transmitted_tail == NULL)
          transmitted_tail = transmitted_head = elt;
        else
          transmitted_tail = transmitted_tail->next = elt;
        return elt;
      }
    void return_to_free_list(kd_queue_elt *elt)
      { elt->chunk = NULL; elt->next = free_list; free_list = elt; }
    void wake_all_blocked_calls()
      {
        if (request_ready_event != NULL) request_ready_event->set();
        if (queue_ready_event != NULL) queue_ready_event->set();
        if (idle_ready_event != NULL) idle_ready_event->set();
        request_ready_event = queue_ready_event = idle_ready_event = NULL;
      }
    void close_channel();
      /* Called if the channel is found to be unusable (e.g., due to closure
         at the client side, closure of the `monitor' object, or some other
         communications error.  Closes and deletes the `channel' object,
         moves all queue elements to the completed list, resets the request
         queue and unblocks any blocked functions.  As with all the private
         helper functions, the mutex must be locked when this function is
         called. */
  private: // Data
    kdcs_channel_monitor *monitor;
    kdcs_tcp_channel *channel; // Becomes NULL when channel is closed
    int max_chunk_bytes;
    float original_max_bytes_per_second; // Value passed to constructor
    float max_bytes_per_second; // Affected by `set_bandwidth_limit'.
    kd_queue_elt *free_list; // List of unused `kd_queue_elt' structures
    kd_queue_elt *holding_head; // Queue of msgs waiting for transmission
    kd_queue_elt *holding_tail;
    kd_queue_elt *completed_head; // Queue of msgs transmitted & acknowledged
    kd_queue_elt *completed_tail;
    kd_queue_elt *transmitted_head; // Queue of msgs transmitted but not yet
    kd_queue_elt *transmitted_tail; // acknowledged
    int num_unprocessed_eor_acks; // See below
    int holding_bytes; // Total bytes in holding queue
    int window_bytes; // Total number of bytes transmitted but not acknowledged
    int window_threshold; // Can't xmit until `window_bytes'<`window_threshold'
    bool need_chunk_trailer; // If no trailer included in text since last chunk
    bool waiting_to_transmit; // Waiting for deliv. gate or space on TCP queue
    bool is_auxiliary; // True if this is a TCP auxiliary channel
    bool no_more_data_expected; // If we expect all data has been pushed in
    kd_request_queue requests; // Collects requests sent by client
  private: // Synchronization objects
    kdu_mutex mutex;
    kdu_event internal_event;
    kdu_event *request_ready_event; // Event to signal, if any,  when
                      // `requests' becomes non-empty (see `retrieve_requests')
    kdu_event *queue_ready_event; // Event to signal, if any, when the holding
              // queue becomes sufficiently empty (see `get_recommended_bytes')
    kdu_event *idle_ready_event; // Event to signal, if any, when the
              // transmission and holding queues are both empty.
  private: // Timing information (all measured in microseconds)
    kdcs_timer timer; // Synchronized to the `monitor' object in `configure'
    kdu_long start_time; // Reported by `timer' after synchronization
    kdu_long delivery_gate; // Scheduled time to delivery next data chunk
    kdu_long bunching_usecs; // Amount delivery gate can get behind cur time
    kdu_long timeout_gate; // Time at which timeout occurs (or -1 if none)
    kdu_long cur_time; // Set by `service_channel' & before calling `send_data'
    bool delivery_wakeup_scheduled; // If `delivery_gate' used to schedule wake
    bool timeout_wakeup_scheduled; // If `timeout_gate' used to schedule wakeup
    float estimated_network_rate; // Measured in bytes per second
    int suggested_epoch_bytes; // Non-zero result from `get_suggested_bytes'
  private: // Members used only to estimate primary HTTP channel conditions
    double avg_ht; // Local average of holding interval time
    double avg_hb; // Local average of holding interval bytes
  private: // Members used only to estimate auxiliary TCP channel conditions
    float max_rtt_target; // Min/max set by `configure'. Need min long enough
    float min_rtt_target; // to get bursty queuing; max keeps things responsive
    float rtt_target; // Current target determined by flow control algorithm
    double avg_1; // Sum of the local averaging weights
    double avg_t; // Local average of the acknowledgement interval time
    double avg_b; // Local avg of the acknowledgement interval bytes
    double avg_bb; // Local avg of squared interval bytes
    double avg_tb; // Local avg correlation between interval bytes and time.
    float estimated_network_delay; // Measured in seconds
    int nominal_window_threshold; // `window_threshold' minus `window_jitter'
    int window_jitter;  // Jitter added to force variation in window size to
                        // get useful network statistics
  private: // Statistics
    kdu_long total_transmitted_bytes;
    kdu_long total_acknowledged_bytes;
    kdu_long idle_start; // Time holding & xmit queues were last empty (or -1)
    kdu_long idle_usecs; // Accumulated time spent while idle
    kdu_long total_rtt_usecs; // Cumulative transmit to acknowledge times
    kdu_long total_rtt_events; // Increments when an acknowledgement arrives  
  public: // Publically available state variables
    kds_jpip_channel *next; // Used to build a linked list
  };
  /* Notes:
        The list of transmitted data chunks headed by `transmitted_head' is
     ordered by transmission time, with the least recently transmitted chunk
     appearing at the head of the queue.
        The temporary holding queue has the same order.  Chunks are pushed
     onto the end of the queue and moved from the start of the queue onto the
     end of the transmission queue.
        Once a chunk has been acknowledged, it is moved onto the completed
     list from which it will be removed by subsequent calls to
     `retrieve_completed_chunks'.  For auxiliary channels, it can happen that
     EOR-only chunks are sent in advance from an element which is still on
     the holding queue, before the element has a chance to enter the
     transmitted list.  If acknowledgements arrive before the element
     enters the transmitted list, they are accumulated in the
     `num_unprocessed_eor_acks' member.
        For an HTTP-only channel, all transmitted chunks are considered to
     be acknowledged immediately.  With this interpretation, most of the
     fields defined by this structure may be assigned meaningful values
     for a single primary channel or for an auxiliary TCP channel.
  */

/*****************************************************************************/
/*                            kd_target_description                          */
/*****************************************************************************/

struct kd_target_description {
  public: // Member functions
    kd_target_description()
      { filename[0]=byte_range[0]='\0'; range_start=0; range_lim=KDU_LONG_MAX;}
    bool parse_byte_range();
      /* Converts the `byte_range' string to numeric values writing them
         to the `range_start' and `range_lim' members.  If the `byte_range'
         string is empty, the ranges are from 0 to KDU_LONG_MAX.  If an
         error occurs, the function returns false. */
  public: // Data
    char filename[256];
    char byte_range[80]; // Holds the
    kdu_long range_start;
    kdu_long range_lim;
  };

/*****************************************************************************/
/*                        kd_synchronized_serve_target                       */
/*****************************************************************************/

class kd_synchronized_serve_target : public kdu_servex {
  public: // Member functions
    kd_synchronized_serve_target()
      { mutex_ref = NULL; }
    void install_mutex(kdu_mutex *mutex_ref)
      { this->mutex_ref = mutex_ref; }
    virtual void acquire_lock() { mutex_ref->lock(); }
    virtual void release_lock() { mutex_ref->unlock(); }
  private: // Data
    kdu_mutex *mutex_ref;
  };

/*****************************************************************************/
/*                                kd_source                                  */
/*****************************************************************************/

struct kd_source {
  public: // Member functions
    kd_source()
    {
      threads = NULL; manager = NULL; prev = next = NULL;
      target_id[0] = '\0'; source_id = 0; failed = false;
    }
    ~kd_source()
      { // Note: you may need to call `unlink' first.
        assert(manager == NULL);
        serve_target.close();
      }
    void unlink();
      /* Unlinks the source from any source manager's queue, decrementing
         the manager's source count.  Does nothing unless there is a source
         manager.  Note that this function DOES NOT ACQUIRE the source
         manager's mutex.  This must be done by the caller. */
    bool open(kd_target_description &target, bool caseless_target,
              kdcs_message_block &explanation, int phld_threshold,
              int per_client_cache, const char *cache_directory,
              const kdu_byte *sys_address);
      /* Called after construction to open the source file, read any file
         format preamble, and create the `codestream' object.  If an
         error occurs, an explanatory HTML status line (starting from the
         error code) is written to `explanation', without any new-line
         character, and the function returns false.  Otherwise, the function
         returns true without writing any explanation.  The implementation
         of this function must be careful to catch exceptions which may be
         generated during the file opening process. */
    bool generate_target_id(const kdu_byte *sys_address);
      /* Attempts to generate the target-id string from the filename and
         byte range.  Returns false, leaving `target_id' as an empty string
         if this cannot be achieved.  Otherwise, generates a unique target
         ID string which is exactly 32 characters long.  The `sys_address'
         argument is a 6-byte array, which might hold the Ethernet MAC
         address or a host-id, depending on the platform. */
  public: // Data
    kd_target_description target;
    char target_id[33]; // 128-bit quantity expressed as an ASCII hex string
    kdu_uint32 source_id; // For rapid identification
    kdu_servex serve_target;
    kd_source_thread *threads; // Doubly linked list of sources using me
    kd_source_manager *manager; // My manager
    kd_source *prev, *next; // To build doubly linked list inside manager
    bool failed;
  };

/*****************************************************************************/
/*                              kd_client_history                            */
/*****************************************************************************/

struct kd_client_history {
  public: // generic data
    bool is_stateless;
    int num_jpip_ht_channels;
    int num_jpip_h_channels;
    kd_target_description target;
    kdu_long total_transmitted_bytes;
    int num_requests;
    int num_primary_connections; // Number of channel attachment operations
    float connected_seconds;
    kd_client_history *next, *prev;
  public: // "jpip-ht" specific data
    kdu_long rtt_events;
    float average_rtt;
    float approximate_auxiliary_channel_rate;
  public: // "jpip-h" specific data
    float average_serviced_byte_limit; // Average byte limit specified in
                                       // requests which were not pre-empted
    float average_service_bytes; // Average bytes actually served for requests
                                 // which were not pre-empted
  };

/*****************************************************************************/
/* ENUM                       kd_jpip_channel_type                           */
/*****************************************************************************/

enum kd_jpip_channel_type {
  KD_CHANNEL_STATELESS=0,
  KD_CHANNEL_HTTP, // Channel using HTTP transport
  KD_CHANNEL_HTTP_TCP // Channel using HTTP-TCP transport
};

/*****************************************************************************/
/*                            kds_primary_channel                            */
/*****************************************************************************/

struct kds_primary_channel {
    kds_primary_channel()
      { channel=NULL; initial_transmitted_bytes=0; next = NULL;
        request_cid = NULL; request_qid = -1;
        request_preemptive = request_processed = reply_generated = false; }
  public: // Basic communication and link members
    kds_jpip_channel *channel;
    kdu_long initial_transmitted_bytes; // When channel was first installed
    kd_request_queue pending_requests;
    kds_primary_channel *next;
  public: // Request association parameters
    kds_cid *request_cid; // CID to which head of the request queue belongs
    kdu_long request_qid; // -1 if request does not specify a QID value
    bool request_preemptive; // True if this request can preempt earlier ones
    bool request_processed; // False until we actually process the request;
        // we don't process requests until the CID is available (i.e., not
        // being used by another request).
  public: // Processed window request information
    kdu_window window;
    kdu_window_model model;
    kdu_window_prefs window_prefs; // Holds new window preferences
    int requested_max_bytes;
    bool requested_align;
    bool requested_extended_headers;
    bool requested_target_compatible;
    bool reply_needs_target_id;
    bool reply_needs_jpip_channel_id;
    bool reply_needs_roi_index;
    int reply_roi_index;
    bool reply_needs_quality_value;
    bool reply_needs_min_len; // If requested length limit too small
    bool release_channel_after_response;
    bool reply_generated; // False until `generate_reply' is called
  };
  /* Notes:
       Requests which arrive on a primary channel go through the following
     stages:
     1) The request is associated with a JPIP channel (CID) by setting the
        `request_cid' member to non-NULL and filling in the `request_qid'
        and `request_preemptive' members.  At the end of this stage,
        `request_cid' is non-NULL and `request_processed' is false.
     2) The JPIP channel (CID) becomes available to handle the request; this
        may depend on the `request_qid' value along with whether or not there
        are other primary channels which, for one reason or another, refer
        to the same CID.  Once the channel is available, the request is
        processed.  This means, in particular, that the request is parsed
        for a window of interest and related parameters, any cache model
        manipulation commands are processed and reflected to the server's
        cache model, and `cclose' commands are used to mark the relevant
        `kds_cid' records for closure after the request in progress
        completes (or would be preempted).  At the end of this stage,
        `request_cid' is non-NULL, `request_processed' is true but
        `reply_generated' is false.  If the request cannot be handled
        properly, a suitable error reply is generated immediately during
        this phase and the request is popped from the head of the queue,
        restoring `request_cid' to NULL and `request_processed' to false.
        Otherwise, we move on to the next stage.  In either case, the
        request is popped from the head of the `pending_requests' queue.
     3) The request is either pre-empted, or used to generate chunks of
        data in one or more epochs.  In either case, an HTTP 200 or 202
        response code must be generated, the `reply_generated' member
        becomes true.  If the JPIP channel uses an auxiliary return channel
        (HTTP-TCP), the `request_cid' member is reset to NULL (and
        `request_processed' and `reply_generated' are also reset to
        false), while possibly leaving the relevant `kds_cid::is_active'
        member true.
     4) For HTTP-only JPIP channels, the `request_cid' member is left
        non-NULL after stage 3, with `reply_generated' true until the
        relevant JPIP channel (as identified by the `request_cid' member) is
        finished responding to the request.  During this time, the relevant
        `kds_cid::is_active' flag remains true and `kds_cid::primary' points
        back to this channel.  Only once the response process for that
        CID is complete or preempted, leaving `kds_cid::is_active' false,
        does the `request_cid' member get reset to NULL and the
        `reply_generated' flag (and the other stage flags) is reset to
        false. */

/*****************************************************************************/
/*                                 kds_cid                                   */
/*****************************************************************************/

struct kds_cid {
  public: // Member functions
    kds_cid()
      { active_window=NULL; active_model=NULL; active_prefs=NULL; init(); }
    ~kds_cid()
      { 
        if (active_window != NULL) delete active_window;
        if (active_model != NULL) delete active_model;
        if (active_prefs != NULL) delete active_prefs;
      }
    void init()
      {
        just_allocated=true; channel_type=KD_CHANNEL_STATELESS;
        aux_channel=NULL; memset(channel_id,0,KD_CHANNEL_ID_LEN+1);
        aux_timeout=qid_timeout=-1; pref_bw_slice=1; bw_slice=1.0F;
        bucket_fulness=0.0F; bucket_threshold=1.0F;
        window_id=-1; next_qid=1; is_active=false;
        close_when_inactive=close_immediately=false;
        active_chn=NULL; active_chunks=NULL;
        active_extended_headers=active_align=false;
        active_remaining_bytes=0; response_complete=false;
        if (active_window != NULL) delete active_window;
        active_window = NULL;
        if (active_model != NULL) delete active_model;
        active_model = NULL;
        if (active_prefs != NULL) delete active_prefs;
        active_prefs = NULL;
      }
  public: // Basic communication members
    kd_jpip_channel_type channel_type;
    char channel_id[KD_CHANNEL_ID_LEN+1];
    kds_jpip_channel *aux_channel; // NULL if not JPIP-HT transport
    bool just_allocated; // True until a request is first processed
  public: // Members related to flow control and timing
    kdu_long aux_timeout; // Used to time waits for `aux_channel' connection.
    kdu_long qid_timeout; // Used to time waits for out of order requests
    int pref_bw_slice; // Value supplied via JPIP preferences fields
    float bw_slice; // Normalized `pref_bw_slice' value (values sum to 1)
    float bucket_fulness; // Leaky bucket transmission model: increases by
      // by number of bytes we transmit; decreases by total transmitted bytes
      // (actual, or as allowed by preferences) times `bw_slice'.  In this
      // algorithm, once an inactive channel's bucket_fulness reaches 0, we
      // redistribute its `bw_slice' share to the other channels.
    float bucket_threshold; // Can xmit if `bucket_fulness'<`bucket_threshold'
  public: // Members related to the processing of requests
    int window_id; // Passed to `kdu_serve::set_window'
    kdu_uint32 next_qid; // Starts out as 1; 0 if QID should be disrespected
    bool is_active; // True if we have a request to be (or being) serviced
    bool close_when_inactive; // Set by `cclose' in side-effect processing
    bool close_immediately; // Set if a timeout occurs
    kds_primary_channel *active_chn; // Non-NULL if `is_active' is true and
       // a reply has not yet been sent, or the HTTP-only transport is
       // being used, so that response data also goes back over `primary'
    kds_chunk *active_chunks; // List of chunks waiting to be pushed into the
       // appropriate `kds_jpip_channel' object's `push_chunks' function.
    kdu_window *active_window;       // These six members are all copied
    kdu_window_model *active_model;  // (content tranferred) from members
    kdu_window_prefs *active_prefs;  // in `active_chn' when `is_active'
    bool active_extended_headers;    // becomes true inside `process_requests'.
    bool active_align;               // ...
    int active_remaining_bytes;      // ...
    bool response_complete; // Set once all data for active request generated
  };

/*****************************************************************************/
/*                              kd_source_thread                             */
/*****************************************************************************/

class kd_source_thread : private kdu_serve {
  public: // Member function
    kd_source_thread(kd_source *source, kd_source_manager *manager,
                     kd_connection_server *cserver,
                     kdu_uint16 aux_listen_port, int max_cids,
                     int max_chunk_bytes, bool ignore_relevance_info,
                     float max_session_idle_seconds,
                     float max_completion_seconds,
                     float max_establishment_seconds,
                     bool caseless_targets);
    ~kd_source_thread();
      /* Must not be called from within the thread itself. */
    static kd_jpip_channel_type translate_cnew_string(const char *string);
      /* Returns KD_CHANNEL_STATELESS unless the `string' is non-NULL and
         can be interpreted as requesting an HTTP or HTTP-TCP channel
         transport, in which case the return value is one of
         KD_CHANNEL_HTTP or KD_CHANNEL_HTTP_TCP, as appropriate. */
    const char *assign_new_cid(kd_jpip_channel_type channel_type,
                               kds_cid *requesting_cid=NULL);
      /* This function adds a new entry to the `cids' array, increasing
         `num_cids' and assigning a unique channel-ID, based on the
         indicated `channel_type'.  If a new channel cannot be assigned,
         the function returns NULL.  This may happen if the `max_cids'
         limit has been reached, or if a new channel is being added to
         a source thread which was created to serve a stateless request.
            The function temporarily locks the `kd_source_manager' object's
         mutex, in order to access its list of source threads so as to
         determine uniqueness.  Since this function may be called with
         the current object's mutex locked, it is imperative that no
         function ever attempts to lock the current object's mutex while
         already holding the source manager's mutex (otherwise deadlock
         may occur).
            The `requesting_cid' argument identifies an existing JPIP
         channel on which the `cnew' request arrived.  If non-NULL, this
         channel's preferences are copied to the new channel, as required
         by the JPIP standard.
            If successful, the function returns a pointer to the internal
         `kds_cid::channel_id' string. */
    int find_channel_id(const char *string)
      { /* Called with the `manager's mutex locked.  Returns -1 if the
           supplied `string' does not match any of the object's current
           channel-id's. */
        int p;
        for (p=0; p < num_cids; p++)
          if (strcmp(string,cids[p].channel_id) == 0)
            return p;
        return -1;
      }
    void start();
      /* Starts the thread running.  If this function fails, the `closing'
         function will be called immediately from the present thread. */
    void run();
      /* Main thread entry point function for this object. */
    void closing();
      /* Called from thread start procedure, right before exiting.  This
         function may recycle primary channels back to the connection
         server, depending on their state, or else it releases them.  It
         also releases all auxiliary channels.  Releasing channels involves
         blocking for at most `max_completion_seconds' to allow them
         to transmit any queued data.  After closing down or recycling all
         communication channels, the statistics are updated and the source
         thread unlinks itself, trimming the source manager's resources as
         it does so. */
    void request_shutdown();
      /* Called from the source manager, while its mutex is locked, this
         function requests an orderly shutdown of operations on this
         source thread.  Once `closing' has completed, it will signal the
         `manager's event. */
    int get_num_available_stateless_channels()
      { return (is_stateless)?(max_cids-num_primary_channels):0; }
      /* Returns 0 unless the source thread was created for handling stateless
         communication.  In that event, the function returns the number of
         additional primary channels which the `install_channel' function can
         accept, when called with `auxiliary'=false and `which'=0. */
    bool install_channel(kds_jpip_channel *channel,
                         kd_request_queue *transfer_queue,
                         const char *auxiliary_channel_id);
      /* Does the handoff for `kd_source_manager::install_channel'.
         If this is a primary HTTP channel, it is not associated with any
         JPIP channel in particular, so there is no need to supply any
         CID-identifying information (in particular, `auxiliary_channel_id'
         should be NULL).  If it is an auxiliary channel, the
         `auxiliary_channel_id' argument should be non-NULL and it is used
         to find the correct CID into which the channel should be installed.
         The function must be called from a context in which the `manager's
         mutex is NOT locked, or else the interaction between this function
         and `assign_new_cid' may create a deadlock.  For this reason, the
         caller may not reliably use the CID index returned by a call to
         `find_channel_id', since it may have changed; this is why we pass
         the full `channel_id' in again for auxiliary channels which must
         be associated with a particular CID. */
  private: // Helper functions
    void process_requests();
      /* This function works through all primary channel request queues,
         advancing pending requests through the various stages identified
         in the notes following the `kds_primary_channel' structure, until
         it reaches a point at which each channel either has no more
         requests, or a request which must be serviced by generating data
         for the relevant JPIP channel (i.e., the associated `kds_cid'
         strucure).  In the latter case, the `kds_cid' structure is modified
         to reflect the fact that it is now in the active state, with
         `kds_cid::is_active' set to true and the other `kds_cid::active...'
         members correctly filled out to reflect the request.  As this
         function executes, it is possible that requests will be
         pre-empted and as-yet unsent replies will be generated
         to that effect.  It is also possible that new CID's get
         created, existing ones get closed, or one or more primary
         channels are found to belong to a different session/source and
         are recycled back to the connection manager.
         [//]
         This function is also responsible for updating the
         `total_received_requests' statistic. */
    bool process_requests_to_stage_1(kds_primary_channel *chn);
      /* This function reads requests from the supplied channel and
         processes them to the point referred to as Stage 1 in the
         comments following the `kds_primary_channel' structure.  It
         returns true if successful, meaning that the `chn' object is
         left with its `request_cid' member non-NULL and the other
         stage flags (i.e., `request_processed' and `reply_generated')
         false.  Along the way, the function may encounter requests which
         cannot be processed, in which case a reply is generated.  It is
         also possible that the channel is recycled or released.  For
         this reason, if the function returns false, you must not attempt
         to access the `chn' object again. */
    bool process_request_to_stage_2(kds_primary_channel *chn);
      /* This function is called only when a request is able to become
         the one which is served on a JPIP channel.  It processes the
         request in order to recover the window-of-interest, any preference
         updates, and all other parameters, writing them into the various
         members of the supplied `kds_primary_channel' object.  If the request
         has side-effects (e.g., cclose or cache model manipulation
         statements), these are performed here.  On entry, `chn->request_cid'
         must be non-NULL.  If successful, the function returns true, leaving
         `chn->request_processed' equal to true, but `chn->reply_generated'
         still false.  If an error is encountered, the function returns
         false, after delivering an appropriate HTTP reply message,
         popping the head of the request queue and recycling the primary
         channel back to the connection manager.  Errors are processed
         using `generate_error_reply' which also marks the JPIP channel for
         closure.
         [//]
         The function may allocate a new JPIP channel if the request
         contains a `cnew' field.  In this case, the function returns true
         but leaves `chn->request_cid' pointing to the new channel.  The
         caller should check for this condition.
         [//]
         In all cases, the request which is processed is popped from the
         head of the `chn->pending_requests' queue. */
    void generate_error_reply(kds_primary_channel *chn,
                              const kd_request *req);
      /* Called if an error is detected while processing a request.  If
         the request has already been associated with a channel (`request_cid'
         is non-NULL), the channel has is `kds_cid::close_when_inactive'
         flag set to true, since it is not generally safe to process beyond
         an erroneous request. If `req->close_connection' is true, the
         supplied primary channel is released.  Otherwise, the channel is
         recycled back to the connection manager.  The function also takes
         care of popping the `req' request from the pending requests queue
         if this has not already been done. */
    bool handle_unsupported_prefs(kds_primary_channel *chn,
                                  const kd_request *req);
      /* This function is called if we processed a JPIP `pref' request inside
         `process_request_to_stage_2'.  If there are no required preferences
         or any required preferences are supported, the function returns
         false without doing anything.  If a required preference is not
         supported, the function generates an HTTP error reply, returning
         true.  The behaviour in this latter case is very similar to
         `generate_error_reply', except that we do not close the JPIP
         channel and we add a JPIP-pref return header to let the client
         know which required preferences are not supported. */
    bool process_cache_specifiers(const char *string,
                                  kdu_window_model &model, bool need);
      /* Used by `process_request_to_stage_2' to parse the bodies of JPIP
         request fields "need=" and "model=". If `need' is true, the
         cache model manipulation instructions are interpreted as subtractive.
         If a parsing error occurs, the function returns false. */
    void preempt_request(kds_cid *cid);
      /* This function is called to pre-empt the request which is currently
         associated with the JPIP channel identified by `cid'.  If a reply
         has not already been generated (`cid->active' != NULL and
         `cid->active_chn->reply_generated' = false), an HTTP/1.1 reply is
         generated with return code 202.  Otherwise, the response which is
         in progress is terminated, sending the EOR (End-Of-Response)
         termination code.  Upon return, the `cid' is idle, having
         `cid->is_active' false and `cid->active_chn' NULL.  This function
         does not itself close any channel, even if it is marked with the
         `cid->close_after_repsonse' flag.  Channel closure is processed
         at the end of each iteration in the `run' loop. */
    bool generate_data_chunks(kds_cid *cid, int suggested_bytes);
      /* This function is invoked only on an active `cid' object.  It
         invokes `set_window' and `generate_increments' storing the
         resulting list of data chunks in the `cid->active_chunks'
         member, to be delivered to the client by the caller.  The
         function prepends any outstanding EOR messages from previous
         pre-empted requests (only for the HTTP-TCP) transport.  It
         also invokes `get_window' after calling `generate_increments',
         updating the `cid->active_window' member accordingly, and
         appending an appropriate EOR message to the current response.
         The function sets the `cid->response_complete' flag to
         true if the `cid' object should become inactive after any
         generated data has been delivered.
         [//]
         In the special case of an HTTP channel, for which the value of
         `cid->active_remaining_bytes' is 0 on entry, the function returns
         with a NULL `cid->active_chunks' member, so that no data will
         be pushed in.  This satisfies the JPIP requirement that a
         "len=0" request should not be associated with HTTP response
         data.  In this special case, the `cid->response_complete' flag
         must necessarily be set and the `generate_reply' function will
         finish up leaving the `cid' object in the inactive state.
         [//]
         The function returns false if an exception occurred while trying to
         generate data.  In this case, the object leaves the `cid' object
         unaltered, but the caller should generally issue an appropriate
         reply message (if a request is waiting for one) and close down the
         session.
      */
    void generate_reply(kds_cid *cid);
      /* Generates the reply text for a JPIP channel which is currently
         active.  The reply is delivered over the `cid->active_chn'
         primary channel, based on the information found in `cid' and
         `cid->active_chn'.  The `cid->active_window' object should have
         been updated to reflect the window actually being served, through
         a call to `get_window' within `generate_data_chunks'.
         [//]
         Since `generate_data_chunks' has supposedly been called already,
         the `cid->active_chunks' list should generally be non-NULL.  The
         only exception to this is in the special case where an HTTP-only
         transport is being used and the `cid->active_remaining_bytes'
         value was zero when `generate_data_chunks' entered.  In this
         case, `cid->active_chunks' will be NULL and the reply text is
         pushed back to the primary channel without any expectation of
         the delivery of chunked data, so the present function also
         leaves the `cid' object in the inactive state.
         [//]
         This function is responsible for calling `detach_active_chn' if
         the current channel type is HTTP-TCP.
         [//]
         This function is also responsible for incrementing the
         `total_serviced_requests' statistic. */
    void detach_active_chn(kds_cid *cid);
      /* This function is called when the `cid->active_chn' member needs
         to become NULL, either because an HTTP JPIP channel is becoming active
         after completing a response, or because an HTTP-TCP has issued its
         reply so that the channel can be unlocked.  The function releases
         all reference to `cid' from the `cid->active_chn' object.  Also,
         if the primary channel required closure after its response, it
         is released here, with an appropriate timeout. */
    void normalize_channel_bandwidths();
      /* This function adjusts all the `kds_cid::bw_slice' members to that
         they are proportional to the respective `kds_cid::pref_bw_slice'
         values and sum to 1.  If `pref_max_bandwidth' is non-negative, the
         function also sets a local bandwidth limit for every auxiliary
         channel, based on the corresponding slice value.  Bandwidth limits
         for primary channels are set only at the point when we need to
         use the primary channel to return response data. */
    int update_flow_control();
      /* This function adjusts all the `kds_cid::bucket_fulness' members so
         that they sum to 0.  This adjustment proceeds in accordance with the
         following policy:
           1) the adjustment is made in proportion to each channel's
              `kds_cid::bw_slice' member;
           2) inactive channels' bucket fulness values are not adjusted
              downward if they are already 0 or negative;
           3) if there are any active channels, at least one of them must be
              left with a bucket fulness which is less than its bucket
              threshold, which might require redistribution of the bucket
              fulness from inactive channels with negative
              `kds_cid::bucket_fulness' members;
           4) if all channels are inactive, they must all be left with bucket
              fulness values which are less than their respective bucket
              thresholds, which may also require redistribution of some
              negative bucket fulness values.
         These policies act to distribute bandwidth according to the
         `kds_cid::bw_slice' values, while ensuring that transmission never
         becomes suspended by an inactive channel which has not used its
         nominal share of the bandwidth.
         [//]
         The function returns the number of active objects in the `cids'
         array (i.e., those for which `kds_cid::is_active' is true).
      */
    void release_primary_channel(kds_primary_channel *chn,
                                 bool send_queued_data_first);
      /* If `send_queued_data_first' is true, this function first performs
         a soft close on the channel, blocking until all data is sent, or
         a timeout occurs (relies upon the caller to first invoke the
         `kds_jpip_channel::set_timer' function).  Otherwise, the function
         performs a hard (non-blocking) close on the channel.  The function
         then updates the transmission statistics relevant to this channel,
         along with the amount of remaining channel time, and then releases
         the channel and deletes the `chn' object, after unlinking it from
         the `primary_channels' list. */
    void recycle_primary_channel(kds_primary_channel *chn);
      /* This function is similar to `release_primary_channel' except that
         the channel is returned to the connection server, rather than
         being deleted.  There is no need to wait until the holding queue
         clears within the underling `kds_jpip_channel' object, since the
         connection server will keep the channel alive.  However, the
         function is careful to consider all data on the holding queue to
         have been transmitted already. */
    void release_auxiliary_channel(kds_cid *cid, bool send_queued_data_first);
      /* Similar to the above function, but for auxiliary channels.  Does
         nothing if `cid->aux_channel' is NULL.  Returns with
         `cid->aux_channel' equal to NULL. */
    void close_cid(int which, kdu_byte eor_code);
      /* This function closes the JPIP channel and reshuffles the
         entries of the `cids' array, while preserving the `window_id'
         values and fixing up `kd_cid' references from the list of
         primary channels.  The function temporarily locks the source
         manager's mutex.
         [//]
         Normally, this function is not called until the channel becomes
         inactive.  In the rare event that the `cid->close_immediately' flag
         is set, the function may have been called while the channel is
         still active.  In this case, the function may need to generate a
         reply, detach an active primary channel and/or insert an appropriate
         EOR message (using the supplied `eor_code') onto the relevant
         channel before closing. */
  private: // Synchronization objects
    kdu_thread thread;
    kdu_mutex mutex; // Used to guard access to communication members
    kdu_event event; // All blocking calls use this auto-reset event
  private: // References to other major objects in the server
    kd_source *source; // NULL if the thread has died
    kd_source_manager *manager; // Used for entering on dead threads list
    kd_connection_server *cserver;
  private: // Fixed parameters
    float max_completion_seconds;
    float max_establishment_seconds;
    int max_chunk_bytes;
    bool ignore_relevance_info;
    bool caseless_targets;
  private: // Timing and flow control
    kdcs_timer timer;
    kdu_long ellapsed_microseconds; // Updated periodically from `timer'
    kdu_long max_idle_microseconds; // Session lifetime
    kdu_long last_idle_time; // `ellapsed_microseconds' when session went idle
    float pref_max_bytes_per_second; // -ve if no preference requested
  private: // Communication members
    bool finished; // Set to true before calling `closing'
    bool shutdown_requested; // Set by `request_shutdown'
    bool is_stateless;
    kdcs_message_block replies;
    int num_primary_channels;
    kds_primary_channel *primary_channels; // Linked list
    kdu_uint16 aux_listen_port; // For writing "JPIP-cnew" headers.
    int max_cids;   // Changing any of `max_cids', `num_cids' or the `cids'
    int num_cids;   // array's channel-id entries requires a lock on the
    kds_cid *cids;  // `manager's mutex.  `cids' can hold `max_cids' entries.
  private: // Statistics
    bool connection_established; // Becomes true when all required channels
                                 // have connected (at least at some point)
    int num_primary_connections; // Num times a primary channel was installed
    int num_jpip_h_cids; // Number of times a JPIP_H channel ID was assigned
    int num_jpip_ht_cids; // Number of times a JPIP_HT channel ID was assigned
    int total_received_requests;
    int total_serviced_requests;
    int num_serviced_with_byte_limits; // Requests with byte limits (jpip-h)
    kdu_long cumulative_byte_limit; // Sum of limits for above (jpip-h only)
    kdu_long total_transmitted_bytes;
    kdu_long total_unacknowledged_bytes;
    kdu_long total_rtt_events;
    float total_rtt_seconds;
    kdu_long auxiliary_channel_transmitted_bytes;
    float auxiliary_channel_active_seconds;
    
  public: // Links and identification; these are protected by `manager's mutex
    kd_source_thread *next, *prev; // source threads list is doubly linked
    bool allow_dead_thread_delete; // False only for the briefest time while
        // the manager calls `install_channel' to prevent a thread's memory
        // from being completely deleted while the manager's mutex is unlocked,
        // which it must be to call `install_channel' without running the
        // risk of deadlock.  Threads are only deleted by the
        // `kd_source_manager::delete_dead_threads' function which does
        // not need to delete all dead threads whenever it is run; that
        // function checks this flag before actually deleting a thread.
};

/*****************************************************************************/
/*                              kd_source_manager                            */
/*****************************************************************************/

class kd_source_manager {
  public: // Member functions
    kd_source_manager(kdu_uint16 aux_listen_port,
                      int  max_sources, int max_threads,
                      int max_cids_per_client, int max_chunk_bytes,
                      bool ignore_relevance_info, int phld_threshold,
                      int per_client_cache, int max_history_records,
                      float max_session_idle_seconds,
                      float max_completion_seconds,
                      float max_establishment_seconds,
                      float min_rtt_target, float max_rtt_target,
                      const char *password, const char *cache_directory,
                      bool caseless_targets);
      /* Here is an explanation of some of the less obvious parameters:
           `max_sources' is the maximum number of source files that can be
         accessed at any given time.
           `max_threads' is the maximum number of source threads which
         can be launched to handle client requests.  In practice, each
         stateless request requires a source thread and each stateful session
         requires a source thread.
           `max_cids_per_client' is the maximum number of stateful channel
         ID's which can be allocated to any given client (i.e., by any
         source thread).  In most cases, only one channel-ID will be used
         for stateful communication, but multiple channel-ID's are now
         supported by the "kdu_server" application.
           `max_chunk_bytes' constrains the size of data chunks used to
         deliver JPIP messages to the client.  These are the chunks used for
         chunked transfer in the HTTP-only transport mode, while they are the
         chunks on which flow control is built in the HTTP-TCP transport
         mode.
           `ignore_relevance_info' forces the server to use a naive (uniform)
         policy for allocating JPEG2000 packets to the transmission queue,
         rather than considering the relevance of different precincts to the
         request being processed.  You might use this if you doubt the
         reliability of any log-slope information in the codestreams being
         served (it is mostly for experimental purposes).
           `phld_threshold' determines the granularity with which JP2/JPX
         metadata boxes are replaced by placeholder boxes, for incremental
         transfer.
           If `password' is NULL, no external administration access will be
         allowed.
           If `caseless_targets' is true, the file system is assumed to be
         case insensitive and all filenames are converted to lowercase before
         passing them to `kd_source' -- moreover, when checking for sources
         which are already open (and hence can potentially be shared),
         a caseless comparison is performed.
      */        
    ~kd_source_manager();
    void delete_dead_threads()
      {
        kd_source_thread *tmp;
        mutex.lock();
        while (((tmp=dead_threads) != NULL) && tmp->allow_dead_thread_delete)
          { dead_threads = tmp->next;  delete tmp;  }
        mutex.unlock();
      }
    bool create_source_thread(kd_target_description &target,
                              const char *jpip_channel_type,
                              kd_connection_server *cserver,
                              char channel_id[],
                              kdcs_message_block &explanation);
      /* This key function attempts to locate an open source for the
         indicated image target.  If one cannot be found, a new source is
         created.  Before successful return, the function creates
         and attaches a dedicated service thread, which will wait for the
         required `kd_jpip_channel' objects to be supplied via
         `install_channel' and then proceed to handle window requests.
         The first channel ID string associated with the newly created
         source thread is returned via the `channel_id' buffer
         which must be at least KD_CHANNEL_ID_LEN+1 characters in length
         (KD_CHANNEL_ID_LEN characters, plus one for the null terminator).
         Note that the `target' object must already have had its
         `kd_target_description::parse_byte_range' function successfully
         invoked.
         [//]
         As might be expected, various error conditions might occur.  If
         the maximum thread count or the maximum source count is reached, or
         the image does not exist, or the file exists but cannot be opened as
         a valid JPEG2000 file, the function returns false.  In this case,
         a text explanation is written to the `explanation' object.  The text
         explanation is a valid HTTP status line starting with the status
         code (not 200) and finishing with the human readable explanatory
         message; no new-line character should be used, and the message
         should be no longer than a couple of hundred characters at most.
         If the function returns true, no text message is written to
         `explanation'.
         [//]
         If `jpip_channel_type' is NULL, the created source thread operates
         in the stateless mode, deliberately not keeping track of the
         information which has been sent to the client between requests.
         Apart from this, the source thread created in this case behaves in
         exactly the same way as if `jpip_channel_type' were "http".  The only
         two channel type strings currently recognized are "http" and
         "http-tcp", but `jpip_channel_type' may hold a list containing
         either or both of these.
      */
    bool install_channel(const char *channel_id, bool auxiliary,
                         kds_jpip_channel *channel,
                         kd_request_queue *requests,
                         kdcs_message_block &explanation);
      /* Used by connection threads to hand a socket and associated channel
         management machinery to a source thread.  If `auxiliary is true,
         the new channel corresponds to the auxiliary TCP channel required
         by the HTTP-TCP transport protocol.  In that case, the
         `channel->set_auxiliary' function is called within the present
         function, if it is determined that the channel can be accepted
         (i.e., if the function returns true).  If `auxiliary' is false,
         the supplied `channel' represents a primary HTTP channel for
         requests and replies.
         [//]
         The `requests' object passes requests which have already been
         retrieved from the channel but not yet fully processed to the
         source manager so that these requests can be processed by the
         relevant source thread.  This argument should be NULL for
         auxiliary channels.  For primary channels, the first request on
         the supplied queue will be the one which was used to obtain
         the `channel_id' itself.
         [//]
         If an active thread with the indicated `channel_id' cannot be
         found, the function returns false, in which case it is the caller's
         responsibility to respond to the client and/or close the channel.  If
         the function returns false, it must write the reason to the
         `explanation' object; the reason must commence with an HTTP error
         code, followed by a text description and a single CRLF pair.  This
         is used by the caller to construct an appropriate error response
         to the client.
      */
    bool install_stateless_channel(kd_target_description &target,
                                   kds_jpip_channel *channel,
                                   kd_request_queue *requests);

      /* This function is used only for managing the arrival of stateless
         requests on new channels.  Rather than first creating a new source
         thread to manage the stateless request and then using
         `install_channel' to pass the request channel to this new source
         thread, the present function checks for source threads which
         already exist, managing the indicated `tgt', which are set up for
         stateless communication and are able to accept an additional
         primary request channel.  If one exists, the channel is installed
         and the function returns true.  Otherwise, the function returns
         false and the caller should create a new source thread and install
         the channel.  If there are currently multiple source threads
         which are compatible with the `tgt', the function finds the one
         which is currently handling the smallest number of HTTP request
         channels. */
    void close_gracefully();
      /* This function attempts to close all source threads gracefully.  It
         blocks the caller until they have all exited. */
    bool write_admin_id(kdcs_message_block &block);
      /* Advances the admin id and writes it as a 32 character hexadecimal
         string to `block'.  Returns false if remote administration is
         not allowed. */
    bool compare_admin_id(const char *string);
      /* Advances the admin id and compares it with `string'.  Returns
         true if the comparison is successful. */
    void write_stats(kdcs_message_block &block);
      /* Writes statistical information to the supplied message block, for
         reporting in response to a remote administration call. */
    void write_history(kdcs_message_block &block, int max_records);
      /* Writes client connection history to the supplied message block,
         for reporting in response to a remote administration call. */
  private: // Helper functions
    friend class kd_source_thread;
    kd_client_history *get_new_history_entry();
      /* Used by `kd_source_thread::closing' to get a new history record
         to fill with information about the connection which is closing.
         The caller must have called locked the `mutex' before calling
         this function.  Returns NULL if the history feature is not
         enabled. */
  private: // Permanent data
    friend struct kd_source;
    kdu_mutex mutex;
    kdu_event event; // This is a manual reset event
    kdu_byte sys_address[6]; // See `kd_source::generate_target_key'
    kdu_uint16 aux_listen_port;
    int max_chunk_bytes;
    bool ignore_relevance_info;
    int phld_threshold;
    int per_client_cache;
    int max_per_client_cids;
    float max_session_idle_seconds;
    float max_completion_seconds;
    float max_establishment_seconds;
    float min_rtt_target;
    float max_rtt_target;
    bool shutdown_requested; // If `close_gracefully' has been called
    const char *cache_directory; // NULL if ".cache" files go in same
                                 // directory as the source image files
    bool caseless_targets;
  private: // Links
    int max_sources;
    int num_sources;
    kd_source *sources; // Doubly linked list
    int max_threads;
    int num_threads;
    kd_source_thread *dead_threads; // Singly linked list
  
  private: // Statistics
    int total_clients;
    kdu_long total_transmitted_bytes; // Updated when source thread is closing
    int completed_connections; // Num clients successfully connected & closed
    int terminated_connections; // Num terminated before connecting channels
    int num_history_records;
    int max_history_records;
    kd_client_history *history_head, *history_tail;
    kdu_byte admin_id[16];
    kdu_rijndael admin_cipher;
  };

/*****************************************************************************/
/*                             kd_delegation_host                            */
/*****************************************************************************/

struct kd_delegation_host {
public: // Member functions
  kd_delegation_host()
  {
    hostname = hostname_with_port = NULL;
    resolution_counter = 1; lookup_in_progress = false;
    prev = next = NULL; load_counter = load_share = 0;
  }
  ~kd_delegation_host()
  {
    if (hostname != NULL) delete[] hostname;
    if (hostname_with_port != NULL) delete[] hostname_with_port;
  }
public: // Data
  char *hostname_with_port;
  char *hostname;
  kdu_uint16 port;
  kdcs_sockaddr address;
  int resolution_counter; // 0 if address already translated
  bool lookup_in_progress; // True if address resolution is in progress
  int load_share; // Relative number of clients we try to send to this host.
  int load_counter; // Counts down from `load_share'.
  kd_delegation_host *prev, *next;
};

/*****************************************************************************/
/*                                kd_delegator                               */
/*****************************************************************************/

class kd_delegator {
public: // Member functions
  kd_delegator()
  {
    head = tail = NULL;
    num_delegation_hosts = 0;
    mutex.create();
  }
  ~kd_delegator()
  {
    while ((tail=head) != NULL)
      { head=tail->next; delete tail; }
    mutex.destroy();
  }
  void add_host(const char *hostname);
  const char *delegate(const kd_request *request,
                       kds_jpip_channel *response_channel,
                       kdcs_channel_monitor *monitor,
                       float max_establishment_seconds,
                       kdcs_message_block &send_par,
                       kdcs_message_block &body_data);
    /* If the request can be delegated to another server, the function
       returns the name of the delegated server, after forwarding the
       delegated server's initial response to the `response_channel', adding
       "Connection: close" to the header if necessary.
          The `monitor' object is provided so that the implementation can
       construct new TCP channels to communicate with delegates.
          The `max_establishment_seconds' provides a time limit for
       communication with delegation hosts.
          The `par_block' and `data_block' objects are provided as a
       convenience, to facilitate construction of request and response
       paragraphs.
          If a delegated server encounters an error which is likely to
       apply across all possible servers (e.g., the requested file might
       exist but have an invalid format), the function behaves in the same
       way as normal, passing the error along to the client via the
       `response_channel'.  Otherwise, the function returns NULL, writing
       nothing to the `response_channel', leaving the caller to handle the
       request locally. */
private: // Data
  kdu_mutex mutex;
  int num_delegation_hosts;
  kd_delegation_host *head, *tail; // The most likely candidate is always
                                   // at the head of the list.
};

/*****************************************************************************/
/*                            kd_connection_thread                           */
/*****************************************************************************/

class kd_connection_thread {
  public: // Member functions
    kd_connection_thread(kd_connection_server *owner,
                         kdcs_channel_monitor *monitor,
                         kd_delegator *delegator,
                         kd_source_manager *source_manager,
                         int max_chunk_bytes,
                         float max_bytes_per_second,
                         float max_establishment_seconds,
                         bool restrict_access);
      /* Constructs the object.  You still need to call `start' to run the
         new thread though. */
    ~kd_connection_thread()
      {
        thread.destroy();
      }
    bool start();
      /* Called after construction to start the new thread running.  Returns
         false if the thread could not be started for some reason. */
    void thread_entry(); // Called from the thread start procedure
  private: // Helper functions
    bool process_channel(kds_jpip_channel *channel);
      /* This function reads requests and sends replies, until the channel
         can be handed off to a dedicated source thread or the
         connection is severed.  If the function returns false, the channel
         was not handed off, so the caller takes care of closing it down and
         releasing it. */
    void process_admin_request(const kd_request *req,
                               kds_jpip_channel *channel);
      /* Scans the `req->fields.admin_command' string to determine how to
         process the remote administration request, using
         `channel->push_reply' to push the reply text back. */
    bool process_stateless_request(kd_target_description &target,
                                   const kd_request *request,
                                   kds_jpip_channel *channel);
      /* Used to satisfy calls which involve no session.  If successful, the
         channel is passed to the source thread and the function returns
         NULL.  Otherwise, an error message is returned via the channel
         and the function returns false. */
    bool process_new_session_request(kd_target_description &target,
                                     const kd_request *request,
                                     kds_jpip_channel *channel);
      /* Attempts to create a new session for the indicated image target,
         using the channel transport type in `request->fields.channel_new'
         (one of "http" or "http-tcp").  If delegation hosts are available,
         this function first attempts to delegate the session request.  If
         the request is handled locally, the channel is passed to the source
         thread which will manage the session and the function returns true.
         If the request is successfully delegated, the function passes
         the delegated host's response to the client and then closes down
         the `channel', again returning true.  If the request could not
         be delegated and could not be handled internally, the function
         delivers an appropriate error message on the channel and returns
         false, whereupon further communication may or may not occur on
         the channel. */
  private: // Permanent state
    kd_connection_server *owner;
    kdcs_channel_monitor *monitor;
    kd_delegator *delegator;
    kd_source_manager *source_manager;
    int max_chunk_bytes;
    float max_bytes_per_second;
    float max_establishment_seconds;
    bool restrict_access;
  private: // Working state
    kdu_thread thread;
    kd_request_queue request_queue;
    kdcs_message_block send_par; // Used to accumulate reply text
    kdcs_message_block body_data; // Used to accumulate reply body data
  public: // Links
    kd_connection_thread *next; // For list managed by connection server
};

/*****************************************************************************/
/*                            kd_connection_server                           */
/*****************************************************************************/

/* This class manages the connection establishment process, which is
 performed over HTTP.  It manages a pool of threads which are used
 to perform the connection establishment signalling.  The presence
 of multiple threads allows any single client to take some time connecting
 (possibly over a slow link), without preventing the server from
 connecting other clients.  TCP connections which have been used to
 service a JPIP session may be returned to the connection server if
 the client did not close them when it closed the JPIP session. */

class kd_connection_server : public kdcs_channel_servicer {
  protected: // Destructor may not be invoked directly
    virtual ~kd_connection_server()
      {
        finish();
        thread_event.destroy();
        finish_event.destroy();
        mutex.destroy();
        if (listener != NULL)
          delete listener;
      }
  public: // Member functions
    kd_connection_server()
      {
        mutex.create();
        thread_event.create(true);
        finish_event.create(true);
        listener = NULL; threads = NULL;
        num_active_threads = num_idle_threads = 0;
        finish_requested = shutdown_in_progress = false;
        returned_head = returned_tail = NULL;
      }
    void release() { finish(); release_ref(); }
      /* Call this function in place of the destructor. */
    void start(kdcs_sockaddr &listen_address,
               kdcs_channel_monitor *monitor,
               kd_delegator *delegator,
               kd_source_manager *source_manager,
               int num_threads, int max_chunk_bytes,
               float max_bytes_per_second, float max_establishment_seconds,
               bool restrict_access);
    void finish();
      /* Waits for all the threads to delete themselves.  This means you
         should not call this function until after `monitor->request_closure'
         has been called. */
    void return_channel(kds_jpip_channel *channel);
      /* This function is called once a source thread has finished using a
         primary HTTP channel, but has not seen fit to close the physical
         connection. */
  protected: // Implementation of `kdcs_channel_servicer' interface
    virtual void service_channel(kdcs_channel_monitor *monitor,
                                 kdcs_channel *channel, int cond_flags);
  private: // Data
    friend class kd_connection_thread;
    kdu_mutex mutex;
    kdu_event thread_event; // Connection threads wait on this for new work
    kdu_event finish_event; // Other threads wait on this event
    int num_active_threads;
    int num_idle_threads;
    kd_connection_thread *threads; // Linked list
    kdcs_tcp_channel *listener;
    bool finish_requested; // If `finish' is waiting for threads to terminate
    bool shutdown_in_progress; // If `source_manager->close_gracefully' called
    kds_jpip_channel *returned_head; // Head and tail of a linked list of
    kds_jpip_channel *returned_tail; // channels returned by source threads
};

#endif // SERVER_LOCAL_H
