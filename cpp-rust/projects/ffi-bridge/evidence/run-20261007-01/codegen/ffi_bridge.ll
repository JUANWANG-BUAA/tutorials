; ModuleID = 'ffi_bridge.dc338404eb9fa59a-cgu.0'
source_filename = "ffi_bridge.dc338404eb9fa59a-cgu.0"
target datalayout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx11.0.0"

%"core::sync::atomic::Atomic<usize>" = type { %"core::cell::UnsafeCell<core::sync::atomic::private::Align8<usize>>" }
%"core::cell::UnsafeCell<core::sync::atomic::private::Align8<usize>>" = type { %"core::sync::atomic::private::Align8<usize>" }
%"core::sync::atomic::private::Align8<usize>" = type { i64 }

@vtable.0 = private unnamed_addr constant <{ [24 x i8], ptr, ptr }> <{ [24 x i8] c"\00\00\00\00\00\00\00\00\08\00\00\00\00\00\00\00\08\00\00\00\00\00\00\00", ptr @_RNSNvYNCINvMs0_NtNtCs1SSuMAdGM58_3std4sync4onceNtBd_4Once15call_once_forceNCINvMNtBf_9once_lockINtB1g_8OnceLockINtNtNtBf_6poison5mutex5MutexNtCsiU7OkGI6hgA_10ffi_bridge8RegistryEE10initializeNCINvB1f_11get_or_initNCNvB2g_8registry0E0zE0E0INtNtNtCsjIpoRzUjyHQ_4core3ops8function6FnOnceTRNtBd_9OnceStateEE9call_once6vtableB2g_, ptr @_RNCINvMs0_NtNtCs1SSuMAdGM58_3std4sync4onceNtB8_4Once15call_once_forceNCINvMNtBa_9once_lockINtB1b_8OnceLockINtNtNtBa_6poison5mutex5MutexNtCsiU7OkGI6hgA_10ffi_bridge8RegistryEE10initializeNCINvB1a_11get_or_initNCNvB2b_8registry0E0zE0E0B2b_ }>, align 8, !guid !0
@alloc_42803b9b714e3e00e9cb378c7a639ffd = private unnamed_addr constant [113 x i8] c"/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/std/src/sync/once.rs\00", align 1, !guid !1
@alloc_14b41ca4a8bee6f2e6e20a17309d9f1e = private unnamed_addr constant <{ ptr, [16 x i8] }> <{ ptr @alloc_42803b9b714e3e00e9cb378c7a639ffd, [16 x i8] c"p\00\00\00\00\00\00\00\E2\00\00\00\14\00\00\00" }>, align 8, !guid !2
@alloc_696290a743386ff4d3c84dceb79925aa = private unnamed_addr constant <{ ptr, [16 x i8] }> <{ ptr @alloc_42803b9b714e3e00e9cb378c7a639ffd, [16 x i8] c"p\00\00\00\00\00\00\00\E2\00\00\001\00\00\00" }>, align 8, !guid !3
@alloc_af2cc7126a897d51cc4d6d82b99ccb9c = private unnamed_addr constant [30 x i8] c"intentional FFI boundary probe", align 1, !guid !4
@alloc_466e6e10d4d5a95679ab35d1156aa54e = private unnamed_addr constant [11 x i8] c"src/lib.rs\00", align 1, !guid !5
@alloc_d0a2bb76699ee4f32e1dd71bfe0e2112 = private unnamed_addr constant <{ ptr, [16 x i8] }> <{ ptr @alloc_466e6e10d4d5a95679ab35d1156aa54e, [16 x i8] c"\0A\00\00\00\00\00\00\004\01\00\00\11\00\00\00" }>, align 8, !guid !6
@anon.b10e0b3f9217cb4544b1a69b463540be.0 = private unnamed_addr constant [64 x i8] c"\A7\AB\AA2\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00", align 8, !guid !7
@_RNvCsiU7OkGI6hgA_10ffi_bridge8REGISTRY = internal global <{ [8 x i8], [40 x i8] }> <{ [8 x i8] c"\03\00\00\00\00\00\00\00", [40 x i8] undef }>, align 8, !guid !8
@_RNvNtNtCs1SSuMAdGM58_3std9panicking11panic_count18GLOBAL_PANIC_COUNT = external local_unnamed_addr global %"core::sync::atomic::Atomic<usize>"

; ffi_bridge::boundary::<ffi_bridge::rb_test_panic::{closure#0}>
; Function Attrs: cold nounwind uwtable
define internal fastcc noundef i32 @_RINvCsiU7OkGI6hgA_10ffi_bridge8boundaryNCNvB2_13rb_test_panic0EB2_() unnamed_addr #0 personality ptr @rust_eh_personality !guid !13 {
start:
; invoke core::panicking::panic_fmt
  invoke void @_RNvNtCsjIpoRzUjyHQ_4core9panicking9panic_fmt(ptr noundef nonnull @alloc_af2cc7126a897d51cc4d6d82b99ccb9c, ptr noundef nonnull inttoptr (i64 61 to ptr), ptr noalias nofree noundef readonly align 8 captures(address, read_provenance) dereferenceable(24) @alloc_d0a2bb76699ee4f32e1dd71bfe0e2112) #24
          to label %.noexc unwind label %catch.i

.noexc:                                           ; preds = %start
  unreachable

catch.i:                                          ; preds = %start
  %0 = landingpad { ptr, i32 }
          catch ptr null
  %1 = extractvalue { ptr, i32 } %0, 0
; invoke std::panicking::catch_unwind::cleanup
  %2 = invoke { ptr, ptr } @_RNvNvNtCs1SSuMAdGM58_3std9panicking12catch_unwind7cleanup(ptr noundef %1)
          to label %bb6 unwind label %terminate.i

terminate.i:                                      ; preds = %catch.i
  %3 = landingpad { ptr, i32 }
          filter [0 x ptr] zeroinitializer
; call core::panicking::panic_cannot_unwind
  tail call void @_RNvNtCsjIpoRzUjyHQ_4core9panicking19panic_cannot_unwind() #25
  unreachable

bb6:                                              ; preds = %catch.i
  ret i32 5
}

; <std::sync::once_lock::OnceLock<std::sync::poison::mutex::Mutex<ffi_bridge::Registry>>>::initialize::<<std::sync::once_lock::OnceLock<std::sync::poison::mutex::Mutex<ffi_bridge::Registry>>>::get_or_init<ffi_bridge::registry::{closure#0}>::{closure#0}, !>
; Function Attrs: cold minsize optsize uwtable
define internal fastcc void @_RINvMNtNtCs1SSuMAdGM58_3std4sync9once_lockINtB3_8OnceLockINtNtNtB5_6poison5mutex5MutexNtCsiU7OkGI6hgA_10ffi_bridge8RegistryEE10initializeNCINvB2_11get_or_initNCNvB1o_8registry0E0zEB1o_() unnamed_addr #1 personality ptr @rust_eh_personality !guid !14 {
start:
  %res = alloca [0 x i8], align 1
  %_11.i = alloca [8 x i8], align 8
  %f.i = alloca [16 x i8], align 8
  %0 = load atomic ptr, ptr @_RNvCsiU7OkGI6hgA_10ffi_bridge8REGISTRY acquire, align 8, !noalias !15
  %_3.i = icmp eq ptr %0, null
  br i1 %_3.i, label %_RINvMs0_NtNtCs1SSuMAdGM58_3std4sync4onceNtB6_4Once15call_once_forceNCINvMNtB8_9once_lockINtB19_8OnceLockINtNtNtB8_6poison5mutex5MutexNtCsiU7OkGI6hgA_10ffi_bridge8RegistryEE10initializeNCINvB18_11get_or_initNCNvB29_8registry0E0zE0EB29_.exit, label %bb2.i, !prof !18

bb2.i:                                            ; preds = %start
  call void @llvm.lifetime.start.p0(ptr nonnull %f.i), !noalias !15
  store ptr getelementptr inbounds nuw (i8, ptr @_RNvCsiU7OkGI6hgA_10ffi_bridge8REGISTRY, i64 8), ptr %f.i, align 8, !noalias !15
  %1 = getelementptr inbounds nuw i8, ptr %f.i, i64 8
  store ptr %res, ptr %1, align 8, !noalias !15
  call void @llvm.lifetime.start.p0(ptr nonnull %_11.i), !noalias !15
  store ptr %f.i, ptr %_11.i, align 8, !noalias !15
; call <std::sys::sync::once::queue::Once>::call
  call void @_RNvMNtNtNtNtCs1SSuMAdGM58_3std3sys4sync4once5queueNtB2_4Once4call(ptr noundef nonnull align 8 @_RNvCsiU7OkGI6hgA_10ffi_bridge8REGISTRY, i1 noundef zeroext true, ptr noundef nonnull %_11.i, ptr noalias nofree noundef readonly align 8 captures(address, read_provenance) dereferenceable(40) @vtable.0, ptr noalias nofree noundef readonly align 8 captures(address, read_provenance) dereferenceable(24) @alloc_14b41ca4a8bee6f2e6e20a17309d9f1e)
  call void @llvm.lifetime.end.p0(ptr nonnull %_11.i), !noalias !15
  call void @llvm.lifetime.end.p0(ptr nonnull %f.i), !noalias !15
  br label %_RINvMs0_NtNtCs1SSuMAdGM58_3std4sync4onceNtB6_4Once15call_once_forceNCINvMNtB8_9once_lockINtB19_8OnceLockINtNtNtB8_6poison5mutex5MutexNtCsiU7OkGI6hgA_10ffi_bridge8RegistryEE10initializeNCINvB18_11get_or_initNCNvB29_8registry0E0zE0EB29_.exit

_RINvMs0_NtNtCs1SSuMAdGM58_3std4sync4onceNtB6_4Once15call_once_forceNCINvMNtB8_9once_lockINtB19_8OnceLockINtNtNtB8_6poison5mutex5MutexNtCsiU7OkGI6hgA_10ffi_bridge8RegistryEE10initializeNCINvB18_11get_or_initNCNvB29_8registry0E0zE0EB29_.exit: ; preds = %start, %bb2.i
  ret void
}

; <std::sys::sync::once_box::OnceBox<std::sys::pal::unix::sync::mutex::Mutex>>::initialize::<<std::sys::sync::mutex::pthread::Mutex>::get::{closure#0}>
; Function Attrs: cold uwtable
define internal fastcc noundef nonnull align 8 ptr @_RINvMNtNtNtCs1SSuMAdGM58_3std3sys4sync8once_boxINtB3_7OnceBoxNtNtNtNtNtB7_3pal4unix4sync5mutex5MutexE10initializeNCNvMNtNtB5_5mutex7pthreadNtB1S_5Mutex3get0ECsiU7OkGI6hgA_10ffi_bridge() unnamed_addr #2 personality ptr @rust_eh_personality !guid !19 {
start:
  %x.i = alloca [64 x i8], align 8
  call void @llvm.lifetime.start.p0(ptr nonnull %x.i)
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 8 dereferenceable(64) %x.i, ptr noundef nonnull align 8 dereferenceable(64) @anon.b10e0b3f9217cb4544b1a69b463540be.0, i64 64, i1 false)
; call __rustc::__rust_no_alloc_shim_is_unstable_v2
  tail call void @_RNvCsdtSMxSA38aw_7___rustc35___rust_no_alloc_shim_is_unstable_v2() #26, !noalias !20
; call __rustc::__rust_alloc
  %0 = tail call noundef align 8 dereferenceable_or_null(64) ptr @_RNvCsdtSMxSA38aw_7___rustc12___rust_alloc(i64 noundef 64, i64 noundef 8) #26, !noalias !20
  %1 = icmp eq ptr %0, null
  br i1 %1, label %bb2.i1.i, label %_RNvMNtCs6zY7rJBZy9D_5alloc5boxedINtB2_3BoxNtNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutex5MutexE3newCsiU7OkGI6hgA_10ffi_bridge.exit.i, !prof !23

bb2.i1.i:                                         ; preds = %start
; invoke alloc::alloc::handle_alloc_error
  invoke void @_RNvNtCs6zY7rJBZy9D_5alloc5alloc18handle_alloc_error(i64 noundef 8, i64 noundef 64) #27
          to label %.noexc.i unwind label %cleanup.i.i

.noexc.i:                                         ; preds = %bb2.i1.i
  unreachable

cleanup.i.i:                                      ; preds = %bb2.i1.i
  %2 = landingpad { ptr, i32 }
          cleanup
; invoke <std::sys::pal::unix::sync::mutex::Mutex as core::ops::drop::Drop>::drop
  invoke void @_RNvXs2_NtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutexNtB5_5MutexNtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4drop(ptr noundef nonnull align 8 dereferenceable(64) %x.i)
          to label %common.resume unwind label %terminate.i.i

terminate.i.i:                                    ; preds = %cleanup.i.i
  %3 = landingpad { ptr, i32 }
          filter [0 x ptr] zeroinitializer
; call core::panicking::panic_in_cleanup
  call void @_RNvNtCsjIpoRzUjyHQ_4core9panicking16panic_in_cleanup() #25
  unreachable

common.resume:                                    ; preds = %cleanup.i.i, %cleanup.i, %bb2.i
  %common.resume.op = phi { ptr, i32 } [ %9, %bb2.i ], [ %2, %cleanup.i.i ], [ %4, %cleanup.i ]
  resume { ptr, i32 } %common.resume.op

_RNvMNtCs6zY7rJBZy9D_5alloc5boxedINtB2_3BoxNtNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutex5MutexE3newCsiU7OkGI6hgA_10ffi_bridge.exit.i: ; preds = %start
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 8 dereferenceable(64) %0, ptr noundef nonnull align 8 dereferenceable(64) @anon.b10e0b3f9217cb4544b1a69b463540be.0, i64 64, i1 false)
  call void @llvm.lifetime.end.p0(ptr nonnull %x.i)
; invoke <std::sys::pal::unix::sync::mutex::Mutex>::init
  invoke void @_RNvMNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutexNtB2_5Mutex4init(ptr noundef nonnull align 8 %0)
          to label %_RNCNvMNtNtNtNtCs1SSuMAdGM58_3std3sys4sync5mutex7pthreadNtB4_5Mutex3get0CsiU7OkGI6hgA_10ffi_bridge.exit unwind label %cleanup.i

cleanup.i:                                        ; preds = %_RNvMNtCs6zY7rJBZy9D_5alloc5boxedINtB2_3BoxNtNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutex5MutexE3newCsiU7OkGI6hgA_10ffi_bridge.exit.i
  %4 = landingpad { ptr, i32 }
          cleanup
; invoke core::ptr::drop_glue::<core::pin::Pin<alloc::boxed::Box<std::sys::pal::unix::sync::mutex::Mutex>>>
  invoke fastcc void @_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtB4_3pin3PinINtNtCs6zY7rJBZy9D_5alloc5boxed3BoxNtNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutex5MutexEEECsiU7OkGI6hgA_10ffi_bridge(ptr %0) #28
          to label %common.resume unwind label %terminate.i

terminate.i:                                      ; preds = %cleanup.i
  %5 = landingpad { ptr, i32 }
          filter [0 x ptr] zeroinitializer
; call core::panicking::panic_in_cleanup
  tail call void @_RNvNtCsjIpoRzUjyHQ_4core9panicking16panic_in_cleanup() #25
  unreachable

_RNCNvMNtNtNtNtCs1SSuMAdGM58_3std3sys4sync5mutex7pthreadNtB4_5Mutex3get0CsiU7OkGI6hgA_10ffi_bridge.exit: ; preds = %_RNvMNtCs6zY7rJBZy9D_5alloc5boxedINtB2_3BoxNtNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutex5MutexE3newCsiU7OkGI6hgA_10ffi_bridge.exit.i
  %6 = cmpxchg ptr getelementptr inbounds nuw (i8, ptr @_RNvCsiU7OkGI6hgA_10ffi_bridge8REGISTRY, i64 8), ptr null, ptr %0 release acquire, align 8
  %7 = extractvalue { ptr, i1 } %6, 1
  %8 = extractvalue { ptr, i1 } %6, 0
  br i1 %7, label %bb5, label %bb3

bb3:                                              ; preds = %_RNCNvMNtNtNtNtCs1SSuMAdGM58_3std3sys4sync5mutex7pthreadNtB4_5Mutex3get0CsiU7OkGI6hgA_10ffi_bridge.exit
; invoke <std::sys::pal::unix::sync::mutex::Mutex as core::ops::drop::Drop>::drop
  invoke void @_RNvXs2_NtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutexNtB5_5MutexNtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4drop(ptr noundef nonnull align 8 %0)
          to label %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc5boxed3BoxNtNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutex5MutexEECsiU7OkGI6hgA_10ffi_bridge.exit unwind label %bb2.i

bb2.i:                                            ; preds = %bb3
  %9 = landingpad { ptr, i32 }
          cleanup
; call __rustc::__rust_dealloc
  tail call void @_RNvCsdtSMxSA38aw_7___rustc14___rust_dealloc(ptr noundef nonnull %0, i64 noundef 64, i64 noundef 8) #26
  br label %common.resume

_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc5boxed3BoxNtNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutex5MutexEECsiU7OkGI6hgA_10ffi_bridge.exit: ; preds = %bb3
; call __rustc::__rust_dealloc
  tail call void @_RNvCsdtSMxSA38aw_7___rustc14___rust_dealloc(ptr noundef nonnull %0, i64 noundef 64, i64 noundef 8) #26
  br label %bb5

bb5:                                              ; preds = %_RNCNvMNtNtNtNtCs1SSuMAdGM58_3std3sys4sync5mutex7pthreadNtB4_5Mutex3get0CsiU7OkGI6hgA_10ffi_bridge.exit, %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc5boxed3BoxNtNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutex5MutexEECsiU7OkGI6hgA_10ffi_bridge.exit
  %_0.sroa.0.0 = phi ptr [ %8, %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc5boxed3BoxNtNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutex5MutexEECsiU7OkGI6hgA_10ffi_bridge.exit ], [ %0, %_RNCNvMNtNtNtNtCs1SSuMAdGM58_3std3sys4sync5mutex7pthreadNtB4_5Mutex3get0CsiU7OkGI6hgA_10ffi_bridge.exit ]
  call void @llvm.assume(i1 true) [ "nonnull"(ptr %_0.sroa.0.0) ]
  ret ptr %_0.sroa.0.0
}

; core::ptr::drop_glue::<core::pin::Pin<alloc::boxed::Box<std::sys::pal::unix::sync::mutex::Mutex>>>
; Function Attrs: uwtable
define internal fastcc void @_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtB4_3pin3PinINtNtCs6zY7rJBZy9D_5alloc5boxed3BoxNtNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutex5MutexEEECsiU7OkGI6hgA_10ffi_bridge(ptr nonnull %_1.0.val) unnamed_addr #3 personality ptr @rust_eh_personality !guid !24 {
start:
; invoke <std::sys::pal::unix::sync::mutex::Mutex as core::ops::drop::Drop>::drop
  invoke void @_RNvXs2_NtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutexNtB5_5MutexNtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4drop(ptr noundef nonnull align 8 %_1.0.val)
          to label %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc5boxed3BoxNtNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutex5MutexEECsiU7OkGI6hgA_10ffi_bridge.exit unwind label %bb2.i

bb2.i:                                            ; preds = %start
  %0 = landingpad { ptr, i32 }
          cleanup
; call __rustc::__rust_dealloc
  tail call void @_RNvCsdtSMxSA38aw_7___rustc14___rust_dealloc(ptr noundef nonnull %_1.0.val, i64 noundef 64, i64 noundef 8) #26
  resume { ptr, i32 } %0

_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc5boxed3BoxNtNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutex5MutexEECsiU7OkGI6hgA_10ffi_bridge.exit: ; preds = %start
; call __rustc::__rust_dealloc
  tail call void @_RNvCsdtSMxSA38aw_7___rustc14___rust_dealloc(ptr noundef nonnull %_1.0.val, i64 noundef 64, i64 noundef 8) #26
  ret void
}

; core::ptr::drop_glue::<std::sync::poison::mutex::MutexGuard<ffi_bridge::Registry>>
; Function Attrs: uwtable
define internal fastcc void @_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtNtCs1SSuMAdGM58_3std4sync6poison5mutex10MutexGuardNtCsiU7OkGI6hgA_10ffi_bridge8RegistryEEB1y_(ptr nofree captures(none) %_1.0.val, i8 %_1.8.val) unnamed_addr #3 !guid !25 {
start:
  call void @llvm.assume(i1 true) [ "nonnull"(ptr %_1.0.val) ]
  %_3.i = getelementptr inbounds nuw i8, ptr %_1.0.val, i64 8
  %_3.i.i = trunc nuw i8 %_1.8.val to i1
  br i1 %_3.i.i, label %_RNvXsc_NtNtNtCs1SSuMAdGM58_3std4sync6poison5mutexINtB5_10MutexGuardNtCsiU7OkGI6hgA_10ffi_bridge8RegistryENtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4dropB15_.exit, label %bb1.i.i

bb1.i.i:                                          ; preds = %start
  %0 = load atomic i64, ptr @_RNvNtNtCs1SSuMAdGM58_3std9panicking11panic_count18GLOBAL_PANIC_COUNT monotonic, align 8
  %_7.i.i = and i64 %0, 9223372036854775807
  %1 = icmp eq i64 %_7.i.i, 0
  br i1 %1, label %_RNvXsc_NtNtNtCs1SSuMAdGM58_3std4sync6poison5mutexINtB5_10MutexGuardNtCsiU7OkGI6hgA_10ffi_bridge8RegistryENtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4dropB15_.exit, label %bb6.i.i, !prof !18

bb6.i.i:                                          ; preds = %bb1.i.i
; call std::panicking::panic_count::is_zero_slow_path
  %_6.i.i = tail call noundef zeroext i1 @_RNvNtNtCs1SSuMAdGM58_3std9panicking11panic_count17is_zero_slow_path() #29
  br i1 %_6.i.i, label %_RNvXsc_NtNtNtCs1SSuMAdGM58_3std4sync6poison5mutexINtB5_10MutexGuardNtCsiU7OkGI6hgA_10ffi_bridge8RegistryENtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4dropB15_.exit, label %bb2.i.i

bb2.i.i:                                          ; preds = %bb6.i.i
  store atomic i8 1, ptr %_3.i monotonic, align 1
  br label %_RNvXsc_NtNtNtCs1SSuMAdGM58_3std4sync6poison5mutexINtB5_10MutexGuardNtCsiU7OkGI6hgA_10ffi_bridge8RegistryENtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4dropB15_.exit

_RNvXsc_NtNtNtCs1SSuMAdGM58_3std4sync6poison5mutexINtB5_10MutexGuardNtCsiU7OkGI6hgA_10ffi_bridge8RegistryENtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4dropB15_.exit: ; preds = %start, %bb1.i.i, %bb6.i.i, %bb2.i.i
  %2 = load atomic ptr, ptr %_1.0.val monotonic, align 8
; call <std::sys::pal::unix::sync::mutex::Mutex>::unlock
  tail call void @_RNvMNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutexNtB2_5Mutex6unlock(ptr noundef nonnull align 8 %2)
  ret void
}

; <alloc::raw_vec::RawVecInner<_>>::reserve::do_reserve_and_handle::<alloc::alloc::Global>
; Function Attrs: cold uwtable
define internal fastcc void @_RINvNvMs2_NtCs6zY7rJBZy9D_5alloc7raw_vecINtB8_11RawVecInnerpE7reserve21do_reserve_and_handleNtNtBa_5alloc6GlobalECsiU7OkGI6hgA_10ffi_bridge(ptr noalias nofree noundef nonnull align 8 captures(none) dereferenceable(16) %slf, i64 noundef %len, i64 noundef %additional) unnamed_addr #2 personality ptr @rust_eh_personality !guid !26 {
start:
  %self3.i = alloca [24 x i8], align 8
  tail call void @llvm.experimental.noalias.scope.decl(metadata !27)
  %_25.0.i = add i64 %additional, %len
  %_25.1.i = icmp ult i64 %_25.0.i, %len
  br i1 %_25.1.i, label %bb2, label %bb9.i

bb9.i:                                            ; preds = %start
  %self5.i = load i64, ptr %slf, align 8, !range !30, !alias.scope !27, !noundef !31
  %v16.i = shl nuw i64 %self5.i, 1
  %..i.i = tail call noundef i64 @llvm.umax.i64(i64 %_25.0.i, i64 range(i64 0, -1) %v16.i)
  %..i16.i = tail call noundef i64 @llvm.umax.i64(i64 %..i.i, i64 4)
  call void @llvm.lifetime.start.p0(ptr nonnull %self3.i), !noalias !27
  %0 = getelementptr inbounds nuw i8, ptr %slf, i64 8
  %self.val15.i = load ptr, ptr %0, align 8, !alias.scope !27
; call <alloc::raw_vec::RawVecInner>::finish_grow
  call fastcc void @_RNvMs5_NtCs6zY7rJBZy9D_5alloc7raw_vecNtB5_11RawVecInner11finish_growCsiU7OkGI6hgA_10ffi_bridge(ptr noalias nofree noundef align 8 captures(none) dereferenceable(24) %self3.i, i64 %self5.i, ptr %self.val15.i, i64 noundef %..i16.i, i64 noundef 8)
  %_37.i = load i64, ptr %self3.i, align 8, !range !32, !noalias !27, !noundef !31
  %1 = trunc nuw i64 %_37.i to i1
  %2 = getelementptr inbounds nuw i8, ptr %self3.i, i64 8
  br i1 %1, label %bb18.i, label %bb3

bb18.i:                                           ; preds = %bb9.i
  %e.0.i = load i64, ptr %2, align 8, !range !33, !noalias !27, !noundef !31
  %3 = getelementptr inbounds nuw i8, ptr %self3.i, i64 16
  %e.1.i = load i64, ptr %3, align 8, !noalias !27
  call void @llvm.lifetime.end.p0(ptr nonnull %self3.i), !noalias !27
  br label %bb2

bb2:                                              ; preds = %bb18.i, %start
  %_0.sroa.5.0.i.ph = phi i64 [ undef, %start ], [ %e.1.i, %bb18.i ]
  %_0.sroa.0.0.i.ph = phi i64 [ 0, %start ], [ %e.0.i, %bb18.i ]
; call alloc::raw_vec::handle_error
  tail call void @_RNvNtCs6zY7rJBZy9D_5alloc7raw_vec12handle_error(i64 noundef %_0.sroa.0.0.i.ph, i64 %_0.sroa.5.0.i.ph) #27
  unreachable

bb3:                                              ; preds = %bb9.i
  %v.0.i = load ptr, ptr %2, align 8, !noalias !27, !nonnull !31, !noundef !31
  call void @llvm.lifetime.end.p0(ptr nonnull %self3.i), !noalias !27
  store ptr %v.0.i, ptr %0, align 8, !alias.scope !27
  %4 = icmp sgt i64 %..i16.i, -1
  tail call void @llvm.assume(i1 %4)
  store i64 %..i16.i, ptr %slf, align 8, !alias.scope !27
  ret void
}

; <std::sync::once::Once>::call_once_force::<<std::sync::once_lock::OnceLock<std::sync::poison::mutex::Mutex<ffi_bridge::Registry>>>::initialize<<std::sync::once_lock::OnceLock<std::sync::poison::mutex::Mutex<ffi_bridge::Registry>>>::get_or_init<ffi_bridge::registry::{closure#0}>::{closure#0}, !>::{closure#0}>::{closure#0}
; Function Attrs: inlinehint uwtable
define internal void @_RNCINvMs0_NtNtCs1SSuMAdGM58_3std4sync4onceNtB8_4Once15call_once_forceNCINvMNtBa_9once_lockINtB1b_8OnceLockINtNtNtBa_6poison5mutex5MutexNtCsiU7OkGI6hgA_10ffi_bridge8RegistryEE10initializeNCINvB1a_11get_or_initNCNvB2b_8registry0E0zE0E0B2b_(ptr noalias nofree noundef readonly align 8 captures(none) dereferenceable(8) %_1, ptr nofree nonnull readnone align 8 captures(none) %p) unnamed_addr #4 personality ptr @rust_eh_personality !guid !34 {
start:
  %self1 = load ptr, ptr %_1, align 8, !nonnull !31, !align !35, !noundef !31
  %0 = load ptr, ptr %self1, align 8, !align !35, !noundef !31
  store ptr null, ptr %self1, align 8
  %.not = icmp eq ptr %0, null
  br i1 %.not, label %bb3, label %bb4, !prof !23

bb4:                                              ; preds = %start
  store i64 0, ptr %0, align 8
  %_13.sroa.4.0._1.0.sroa_idx.i = getelementptr inbounds nuw i8, ptr %0, i64 8
  store i8 0, ptr %_13.sroa.4.0._1.0.sroa_idx.i, align 8
  %_13.sroa.6.0._1.0.sroa_idx.i = getelementptr inbounds nuw i8, ptr %0, i64 16
  store i64 0, ptr %_13.sroa.6.0._1.0.sroa_idx.i, align 8
  %_13.sroa.7.0._1.0.sroa_idx.i = getelementptr inbounds nuw i8, ptr %0, i64 24
  store ptr inttoptr (i64 8 to ptr), ptr %_13.sroa.7.0._1.0.sroa_idx.i, align 8
  %_13.sroa.8.0._1.0.sroa_idx.i = getelementptr inbounds nuw i8, ptr %0, i64 32
  store i64 0, ptr %_13.sroa.8.0._1.0.sroa_idx.i, align 8
  ret void

bb3:                                              ; preds = %start
; call core::option::unwrap_failed
  tail call void @_RNvNtCsjIpoRzUjyHQ_4core6option13unwrap_failed(ptr noalias nofree noundef readonly align 8 captures(address, read_provenance) dereferenceable(24) @alloc_696290a743386ff4d3c84dceb79925aa) #24
  unreachable
}

; <<std::sync::once::Once>::call_once_force<<std::sync::once_lock::OnceLock<std::sync::poison::mutex::Mutex<ffi_bridge::Registry>>>::initialize<<std::sync::once_lock::OnceLock<std::sync::poison::mutex::Mutex<ffi_bridge::Registry>>>::get_or_init<ffi_bridge::registry::{closure#0}>::{closure#0}, !>::{closure#0}>::{closure#0} as core::ops::function::FnOnce<(&std::sync::once::OnceState,)>>::call_once::{shim:vtable#0}
; Function Attrs: inlinehint uwtable
define internal void @_RNSNvYNCINvMs0_NtNtCs1SSuMAdGM58_3std4sync4onceNtBd_4Once15call_once_forceNCINvMNtBf_9once_lockINtB1g_8OnceLockINtNtNtBf_6poison5mutex5MutexNtCsiU7OkGI6hgA_10ffi_bridge8RegistryEE10initializeNCINvB1f_11get_or_initNCNvB2g_8registry0E0zE0E0INtNtNtCsjIpoRzUjyHQ_4core3ops8function6FnOnceTRNtBd_9OnceStateEE9call_once6vtableB2g_(ptr nofree noundef readonly captures(none) %_1, ptr nofree nonnull readnone align 8 captures(none) %0) unnamed_addr #4 personality ptr @rust_eh_personality !guid !36 {
start:
  %1 = load ptr, ptr %_1, align 8, !nonnull !31, !align !35, !noundef !31
  tail call void @llvm.experimental.noalias.scope.decl(metadata !37)
  %2 = load ptr, ptr %1, align 8, !alias.scope !37, !noalias !40, !align !35, !noundef !31
  store ptr null, ptr %1, align 8, !alias.scope !37, !noalias !40
  %.not.i.i = icmp eq ptr %2, null
  br i1 %.not.i.i, label %bb3.i.i, label %_RNvYNCINvMs0_NtNtCs1SSuMAdGM58_3std4sync4onceNtBb_4Once15call_once_forceNCINvMNtBd_9once_lockINtB1e_8OnceLockINtNtNtBd_6poison5mutex5MutexNtCsiU7OkGI6hgA_10ffi_bridge8RegistryEE10initializeNCINvB1d_11get_or_initNCNvB2e_8registry0E0zE0E0INtNtNtCsjIpoRzUjyHQ_4core3ops8function6FnOnceTRNtBb_9OnceStateEE9call_onceB2e_.exit, !prof !23

bb3.i.i:                                          ; preds = %start
; call core::option::unwrap_failed
  tail call void @_RNvNtCsjIpoRzUjyHQ_4core6option13unwrap_failed(ptr noalias nofree noundef readonly align 8 captures(address, read_provenance) dereferenceable(24) @alloc_696290a743386ff4d3c84dceb79925aa) #24, !noalias !43
  unreachable

_RNvYNCINvMs0_NtNtCs1SSuMAdGM58_3std4sync4onceNtBb_4Once15call_once_forceNCINvMNtBd_9once_lockINtB1e_8OnceLockINtNtNtBd_6poison5mutex5MutexNtCsiU7OkGI6hgA_10ffi_bridge8RegistryEE10initializeNCINvB1d_11get_or_initNCNvB2e_8registry0E0zE0E0INtNtNtCsjIpoRzUjyHQ_4core3ops8function6FnOnceTRNtBb_9OnceStateEE9call_onceB2e_.exit: ; preds = %start
  store i64 0, ptr %2, align 8, !noalias !43
  %_13.sroa.4.0._1.0.sroa_idx.i.i.i = getelementptr inbounds nuw i8, ptr %2, i64 8
  store i8 0, ptr %_13.sroa.4.0._1.0.sroa_idx.i.i.i, align 8, !noalias !43
  %_13.sroa.6.0._1.0.sroa_idx.i.i.i = getelementptr inbounds nuw i8, ptr %2, i64 16
  store i64 0, ptr %_13.sroa.6.0._1.0.sroa_idx.i.i.i, align 8, !noalias !43
  %_13.sroa.7.0._1.0.sroa_idx.i.i.i = getelementptr inbounds nuw i8, ptr %2, i64 24
  store ptr inttoptr (i64 8 to ptr), ptr %_13.sroa.7.0._1.0.sroa_idx.i.i.i, align 8, !noalias !43
  %_13.sroa.8.0._1.0.sroa_idx.i.i.i = getelementptr inbounds nuw i8, ptr %2, i64 32
  store i64 0, ptr %_13.sroa.8.0._1.0.sroa_idx.i.i.i, align 8, !noalias !43
  ret void
}

; ffi_bridge::checksum
; Function Attrs: nofree norecurse nosync nounwind memory(argmem: read) uwtable
define noundef i64 @_RNvCsiU7OkGI6hgA_10ffi_bridge8checksum(ptr noalias nofree noundef nonnull readonly align 8 captures(none) %values.0, i64 noundef range(i64 0, 1152921504606846976) %values.1) unnamed_addr #5 personality ptr @rust_eh_personality !guid !44 {
start:
  %0 = icmp eq i64 %values.1, 0
  br i1 %0, label %_RINvXs2J_NtNtCsjIpoRzUjyHQ_4core5slice4iterINtB7_4IteryENtNtNtNtBb_4iter6traits8iterator8Iterator4foldyNCNvCsiU7OkGI6hgA_10ffi_bridge8checksum0EB1H_.exit, label %bb8.i.preheader

bb8.i.preheader:                                  ; preds = %start
  %min.iters.check = icmp samesign ult i64 %values.1, 8
  br i1 %min.iters.check, label %bb8.i.preheader9, label %vector.ph

vector.ph:                                        ; preds = %bb8.i.preheader
  %n.vec = and i64 %values.1, 1152921504606846968
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %vector.ph
  %index = phi i64 [ 0, %vector.ph ], [ %index.next, %vector.body ]
  %vec.phi = phi <2 x i64> [ zeroinitializer, %vector.ph ], [ %5, %vector.body ]
  %vec.phi1 = phi <2 x i64> [ zeroinitializer, %vector.ph ], [ %6, %vector.body ]
  %vec.phi2 = phi <2 x i64> [ zeroinitializer, %vector.ph ], [ %7, %vector.body ]
  %vec.phi3 = phi <2 x i64> [ zeroinitializer, %vector.ph ], [ %8, %vector.body ]
  %1 = getelementptr inbounds nuw [8 x i8], ptr %values.0, i64 %index
  %2 = getelementptr inbounds nuw i8, ptr %1, i64 16
  %3 = getelementptr inbounds nuw i8, ptr %1, i64 32
  %4 = getelementptr inbounds nuw i8, ptr %1, i64 48
  %wide.load = load <2 x i64>, ptr %1, align 8
  %wide.load4 = load <2 x i64>, ptr %2, align 8
  %wide.load5 = load <2 x i64>, ptr %3, align 8
  %wide.load6 = load <2 x i64>, ptr %4, align 8
  %5 = add <2 x i64> %wide.load, %vec.phi
  %6 = add <2 x i64> %wide.load4, %vec.phi1
  %7 = add <2 x i64> %wide.load5, %vec.phi2
  %8 = add <2 x i64> %wide.load6, %vec.phi3
  %index.next = add nuw i64 %index, 8
  %9 = icmp eq i64 %index.next, %n.vec
  br i1 %9, label %middle.block, label %vector.body, !llvm.loop !45

middle.block:                                     ; preds = %vector.body
  %bin.rdx = add <2 x i64> %6, %5
  %bin.rdx7 = add <2 x i64> %7, %bin.rdx
  %bin.rdx8 = add <2 x i64> %8, %bin.rdx7
  %10 = tail call i64 @llvm.vector.reduce.add.v2i64(<2 x i64> %bin.rdx8)
  %cmp.n = icmp eq i64 %values.1, %n.vec
  br i1 %cmp.n, label %_RINvXs2J_NtNtCsjIpoRzUjyHQ_4core5slice4iterINtB7_4IteryENtNtNtNtBb_4iter6traits8iterator8Iterator4foldyNCNvCsiU7OkGI6hgA_10ffi_bridge8checksum0EB1H_.exit, label %bb8.i.preheader9

bb8.i.preheader9:                                 ; preds = %bb8.i.preheader, %middle.block
  %i.sroa.0.0.i.ph = phi i64 [ 0, %bb8.i.preheader ], [ %n.vec, %middle.block ]
  %acc.sroa.0.0.i.ph = phi i64 [ 0, %bb8.i.preheader ], [ %10, %middle.block ]
  br label %bb8.i

bb8.i:                                            ; preds = %bb8.i.preheader9, %bb8.i
  %i.sroa.0.0.i = phi i64 [ %_27.i, %bb8.i ], [ %i.sroa.0.0.i.ph, %bb8.i.preheader9 ]
  %acc.sroa.0.0.i = phi i64 [ %_0.i.i, %bb8.i ], [ %acc.sroa.0.0.i.ph, %bb8.i.preheader9 ]
  %_45.i = getelementptr inbounds nuw [8 x i8], ptr %values.0, i64 %i.sroa.0.0.i
  %_45.val.i = load i64, ptr %_45.i, align 8, !noundef !31
  %_0.i.i = add i64 %_45.val.i, %acc.sroa.0.0.i
  %_27.i = add nuw nsw i64 %i.sroa.0.0.i, 1
  %_28.i = icmp eq i64 %_27.i, %values.1
  br i1 %_28.i, label %_RINvXs2J_NtNtCsjIpoRzUjyHQ_4core5slice4iterINtB7_4IteryENtNtNtNtBb_4iter6traits8iterator8Iterator4foldyNCNvCsiU7OkGI6hgA_10ffi_bridge8checksum0EB1H_.exit, label %bb8.i, !llvm.loop !48

_RINvXs2J_NtNtCsjIpoRzUjyHQ_4core5slice4iterINtB7_4IteryENtNtNtNtBb_4iter6traits8iterator8Iterator4foldyNCNvCsiU7OkGI6hgA_10ffi_bridge8checksum0EB1H_.exit: ; preds = %bb8.i, %middle.block, %start
  %_0.sroa.0.0.i = phi i64 [ 0, %start ], [ %10, %middle.block ], [ %_0.i.i, %bb8.i ]
  ret i64 %_0.sroa.0.0.i
}

; ffi_bridge::snapshot
; Function Attrs: uwtable
define internal fastcc void @_RNvCsiU7OkGI6hgA_10ffi_bridge8snapshot(ptr dead_on_unwind noalias nofree noundef nonnull writable writeonly align 8 captures(none) dereferenceable(16) %_0, i64 noundef %handle) unnamed_addr #3 personality ptr @rust_eh_personality !guid !49 {
start:
  %0 = load atomic ptr, ptr @_RNvCsiU7OkGI6hgA_10ffi_bridge8REGISTRY acquire, align 8
  %_11.i.i = icmp eq ptr %0, null
  br i1 %_11.i.i, label %_RNvCsiU7OkGI6hgA_10ffi_bridge8registry.exit, label %bb8.i.i, !prof !18

bb8.i.i:                                          ; preds = %start
; call <std::sync::once_lock::OnceLock<std::sync::poison::mutex::Mutex<ffi_bridge::Registry>>>::initialize::<<std::sync::once_lock::OnceLock<std::sync::poison::mutex::Mutex<ffi_bridge::Registry>>>::get_or_init<ffi_bridge::registry::{closure#0}>::{closure#0}, !>
  tail call fastcc void @_RINvMNtNtCs1SSuMAdGM58_3std4sync9once_lockINtB3_8OnceLockINtNtNtB5_6poison5mutex5MutexNtCsiU7OkGI6hgA_10ffi_bridge8RegistryEE10initializeNCINvB2_11get_or_initNCNvB1o_8registry0E0zEB1o_()
  br label %_RNvCsiU7OkGI6hgA_10ffi_bridge8registry.exit

_RNvCsiU7OkGI6hgA_10ffi_bridge8registry.exit:     ; preds = %start, %bb8.i.i
  %1 = load atomic ptr, ptr getelementptr inbounds nuw (i8, ptr @_RNvCsiU7OkGI6hgA_10ffi_bridge8REGISTRY, i64 8) acquire, align 8, !noalias !50
  %_11.i.i6 = icmp eq ptr %1, null
  br i1 %_11.i.i6, label %bb7.i.i, label %_RINvMNtNtNtCs1SSuMAdGM58_3std3sys4sync8once_boxINtB3_7OnceBoxNtNtNtNtNtB7_3pal4unix4sync5mutex5MutexE11get_or_initNCNvMNtNtB5_5mutex7pthreadNtB1T_5Mutex3get0ECsiU7OkGI6hgA_10ffi_bridge.exit.i, !prof !23

bb7.i.i:                                          ; preds = %_RNvCsiU7OkGI6hgA_10ffi_bridge8registry.exit
; call <std::sys::sync::once_box::OnceBox<std::sys::pal::unix::sync::mutex::Mutex>>::initialize::<<std::sys::sync::mutex::pthread::Mutex>::get::{closure#0}>
  %2 = tail call fastcc noundef nonnull align 8 ptr @_RINvMNtNtNtCs1SSuMAdGM58_3std3sys4sync8once_boxINtB3_7OnceBoxNtNtNtNtNtB7_3pal4unix4sync5mutex5MutexE10initializeNCNvMNtNtB5_5mutex7pthreadNtB1S_5Mutex3get0ECsiU7OkGI6hgA_10ffi_bridge(), !noalias !50
  br label %_RINvMNtNtNtCs1SSuMAdGM58_3std3sys4sync8once_boxINtB3_7OnceBoxNtNtNtNtNtB7_3pal4unix4sync5mutex5MutexE11get_or_initNCNvMNtNtB5_5mutex7pthreadNtB1T_5Mutex3get0ECsiU7OkGI6hgA_10ffi_bridge.exit.i

_RINvMNtNtNtCs1SSuMAdGM58_3std3sys4sync8once_boxINtB3_7OnceBoxNtNtNtNtNtB7_3pal4unix4sync5mutex5MutexE11get_or_initNCNvMNtNtB5_5mutex7pthreadNtB1T_5Mutex3get0ECsiU7OkGI6hgA_10ffi_bridge.exit.i: ; preds = %bb7.i.i, %_RNvCsiU7OkGI6hgA_10ffi_bridge8registry.exit
  %_0.sroa.0.0.i.i = phi ptr [ %2, %bb7.i.i ], [ %1, %_RNvCsiU7OkGI6hgA_10ffi_bridge8registry.exit ]
; call <std::sys::pal::unix::sync::mutex::Mutex>::lock
  tail call void @_RNvMNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutexNtB2_5Mutex4lock(ptr noundef nonnull align 8 %_0.sroa.0.0.i.i), !noalias !50
  %3 = load atomic i64, ptr @_RNvNtNtCs1SSuMAdGM58_3std9panicking11panic_count18GLOBAL_PANIC_COUNT monotonic, align 8, !noalias !50
  %_7.i.i = and i64 %3, 9223372036854775807
  %4 = icmp eq i64 %_7.i.i, 0
  br i1 %4, label %_RNvMs5_NtNtNtCs1SSuMAdGM58_3std4sync6poison5mutexINtB5_5MutexNtCsiU7OkGI6hgA_10ffi_bridge8RegistryE4lockBZ_.exit.thread, label %_RNvMs5_NtNtNtCs1SSuMAdGM58_3std4sync6poison5mutexINtB5_5MutexNtCsiU7OkGI6hgA_10ffi_bridge8RegistryE4lockBZ_.exit, !prof !18

_RNvMs5_NtNtNtCs1SSuMAdGM58_3std4sync6poison5mutexINtB5_5MutexNtCsiU7OkGI6hgA_10ffi_bridge8RegistryE4lockBZ_.exit: ; preds = %_RINvMNtNtNtCs1SSuMAdGM58_3std3sys4sync8once_boxINtB3_7OnceBoxNtNtNtNtNtB7_3pal4unix4sync5mutex5MutexE11get_or_initNCNvMNtNtB5_5mutex7pthreadNtB1T_5Mutex3get0ECsiU7OkGI6hgA_10ffi_bridge.exit.i
; call std::panicking::panic_count::is_zero_slow_path
  %5 = tail call noundef zeroext i1 @_RNvNtNtCs1SSuMAdGM58_3std9panicking11panic_count17is_zero_slow_path() #29, !noalias !50
  %6 = xor i1 %5, true
  %7 = load atomic i8, ptr getelementptr inbounds nuw (i8, ptr @_RNvCsiU7OkGI6hgA_10ffi_bridge8REGISTRY, i64 16) monotonic, align 8, !noalias !50
  %_4.not.i.i.not = icmp eq i8 %7, 0
  br i1 %_4.not.i.i.not, label %bb10, label %bb9

_RNvMs5_NtNtNtCs1SSuMAdGM58_3std4sync6poison5mutexINtB5_5MutexNtCsiU7OkGI6hgA_10ffi_bridge8RegistryE4lockBZ_.exit.thread: ; preds = %_RINvMNtNtNtCs1SSuMAdGM58_3std3sys4sync8once_boxINtB3_7OnceBoxNtNtNtNtNtB7_3pal4unix4sync5mutex5MutexE11get_or_initNCNvMNtNtB5_5mutex7pthreadNtB1T_5Mutex3get0ECsiU7OkGI6hgA_10ffi_bridge.exit.i
  %8 = load atomic i8, ptr getelementptr inbounds nuw (i8, ptr @_RNvCsiU7OkGI6hgA_10ffi_bridge8REGISTRY, i64 16) monotonic, align 8, !noalias !50
  %_4.not.i.i11.not = icmp eq i8 %8, 0
  br i1 %_4.not.i.i11.not, label %bb10, label %bb1.i.i.i.i

bb9:                                              ; preds = %_RNvMs5_NtNtNtCs1SSuMAdGM58_3std4sync6poison5mutexINtB5_5MutexNtCsiU7OkGI6hgA_10ffi_bridge8RegistryE4lockBZ_.exit
  br i1 %5, label %bb1.i.i.i.i, label %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtCs1SSuMAdGM58_3std4sync6poison11PoisonErrorINtNtBE_5mutex10MutexGuardNtCsiU7OkGI6hgA_10ffi_bridge8RegistryEEEB1R_.exit

bb1.i.i.i.i:                                      ; preds = %_RNvMs5_NtNtNtCs1SSuMAdGM58_3std4sync6poison5mutexINtB5_5MutexNtCsiU7OkGI6hgA_10ffi_bridge8RegistryE4lockBZ_.exit.thread, %bb9
  %9 = load atomic i64, ptr @_RNvNtNtCs1SSuMAdGM58_3std9panicking11panic_count18GLOBAL_PANIC_COUNT monotonic, align 8
  %_7.i.i.i.i = and i64 %9, 9223372036854775807
  %10 = icmp eq i64 %_7.i.i.i.i, 0
  br i1 %10, label %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtCs1SSuMAdGM58_3std4sync6poison11PoisonErrorINtNtBE_5mutex10MutexGuardNtCsiU7OkGI6hgA_10ffi_bridge8RegistryEEEB1R_.exit, label %bb6.i.i.i.i, !prof !18

bb6.i.i.i.i:                                      ; preds = %bb1.i.i.i.i
; call std::panicking::panic_count::is_zero_slow_path
  %_6.i.i.i.i = tail call noundef zeroext i1 @_RNvNtNtCs1SSuMAdGM58_3std9panicking11panic_count17is_zero_slow_path() #29
  br i1 %_6.i.i.i.i, label %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtCs1SSuMAdGM58_3std4sync6poison11PoisonErrorINtNtBE_5mutex10MutexGuardNtCsiU7OkGI6hgA_10ffi_bridge8RegistryEEEB1R_.exit, label %bb2.i.i.i.i

bb2.i.i.i.i:                                      ; preds = %bb6.i.i.i.i
  store atomic i8 1, ptr getelementptr inbounds nuw (i8, ptr @_RNvCsiU7OkGI6hgA_10ffi_bridge8REGISTRY, i64 16) monotonic, align 8
  br label %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtCs1SSuMAdGM58_3std4sync6poison11PoisonErrorINtNtBE_5mutex10MutexGuardNtCsiU7OkGI6hgA_10ffi_bridge8RegistryEEEB1R_.exit

_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtCs1SSuMAdGM58_3std4sync6poison11PoisonErrorINtNtBE_5mutex10MutexGuardNtCsiU7OkGI6hgA_10ffi_bridge8RegistryEEEB1R_.exit: ; preds = %bb9, %bb1.i.i.i.i, %bb6.i.i.i.i, %bb2.i.i.i.i
  %11 = load atomic ptr, ptr getelementptr inbounds nuw (i8, ptr @_RNvCsiU7OkGI6hgA_10ffi_bridge8REGISTRY, i64 8) monotonic, align 8
; call <std::sys::pal::unix::sync::mutex::Mutex>::unlock
  tail call void @_RNvMNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutexNtB2_5Mutex6unlock(ptr noundef nonnull align 8 %11)
  %12 = getelementptr inbounds nuw i8, ptr %_0, i64 8
  store i32 6, ptr %12, align 8
  store ptr null, ptr %_0, align 8
  br label %bb6

bb10:                                             ; preds = %_RNvMs5_NtNtNtCs1SSuMAdGM58_3std4sync6poison5mutexINtB5_5MutexNtCsiU7OkGI6hgA_10ffi_bridge8RegistryE4lockBZ_.exit.thread, %_RNvMs5_NtNtNtCs1SSuMAdGM58_3std4sync6poison5mutexINtB5_5MutexNtCsiU7OkGI6hgA_10ffi_bridge8RegistryE4lockBZ_.exit
  %_6.sroa.0.0.off0.i.i15 = phi i1 [ false, %_RNvMs5_NtNtNtCs1SSuMAdGM58_3std4sync6poison5mutexINtB5_5MutexNtCsiU7OkGI6hgA_10ffi_bridge8RegistryE4lockBZ_.exit.thread ], [ %6, %_RNvMs5_NtNtNtCs1SSuMAdGM58_3std4sync6poison5mutexINtB5_5MutexNtCsiU7OkGI6hgA_10ffi_bridge8RegistryE4lockBZ_.exit ]
  %_19.val = load ptr, ptr getelementptr inbounds nuw (i8, ptr @_RNvCsiU7OkGI6hgA_10ffi_bridge8REGISTRY, i64 32), align 8
  %_19.val5 = load i64, ptr getelementptr inbounds nuw (i8, ptr @_RNvCsiU7OkGI6hgA_10ffi_bridge8REGISTRY, i64 40), align 8
  tail call void @llvm.experimental.noalias.scope.decl(metadata !53)
  %13 = and i64 %handle, 4294967295
  %14 = icmp eq i64 %13, 0
  br i1 %14, label %bb4.i, label %bb2.i.i

bb2.i.i:                                          ; preds = %bb10
  %_8.i.i = add nsw i64 %13, -1
  %_21.i.i = icmp ult i64 %_8.i.i, %_19.val5
  br i1 %_21.i.i, label %bb9.i.i, label %bb4.i

bb9.i.i:                                          ; preds = %bb2.i.i
  call void @llvm.assume(i1 true) [ "nonnull"(ptr %_19.val) ]
  %_22.i.i = getelementptr inbounds nuw [24 x i8], ptr %_19.val, i64 %_8.i.i
  %15 = getelementptr inbounds nuw i8, ptr %_22.i.i, i64 16
  %_13.i.i = load i32, ptr %15, align 8, !noalias !56, !noundef !31
  %_15.i.i = lshr i64 %handle, 32
  %_14.i.i = trunc nuw i64 %_15.i.i to i32
  %_12.not.i.i = icmp eq i32 %_13.i.i, %_14.i.i
  br i1 %_12.not.i.i, label %bb4.i.i, label %bb4.i

bb4.i.i:                                          ; preds = %bb9.i.i
  %16 = load ptr, ptr %_22.i.i, align 8, !noalias !56, !noundef !31
  %.not.i.i = icmp eq ptr %16, null
  br i1 %.not.i.i, label %bb4.i, label %bb7.i

bb4.i:                                            ; preds = %bb4.i.i, %bb9.i.i, %bb2.i.i, %bb10
  %17 = getelementptr inbounds nuw i8, ptr %_0, i64 8
  store i32 3, ptr %17, align 8, !alias.scope !53
  store ptr null, ptr %_0, align 8, !alias.scope !53
  br label %bb4

bb7.i:                                            ; preds = %bb4.i.i
  %_20.i = atomicrmw add ptr %16, i64 1 monotonic, align 8, !noalias !53
  %_21.i = icmp slt i64 %_20.i, 0
  br i1 %_21.i, label %bb8.i, label %bb9.i

bb9.i:                                            ; preds = %bb7.i
  %18 = getelementptr inbounds nuw i8, ptr %_22.i.i, i64 8
  %_23.0.i = load ptr, ptr %_22.i.i, align 8, !noalias !53, !nonnull !31, !noundef !31
  %_23.1.i = load i64, ptr %18, align 8, !noalias !53, !noundef !31
  store ptr %_23.0.i, ptr %_0, align 8, !alias.scope !53
  %19 = getelementptr inbounds nuw i8, ptr %_0, i64 8
  store i64 %_23.1.i, ptr %19, align 8, !alias.scope !53
  br label %bb4

bb8.i:                                            ; preds = %bb7.i
  tail call void @llvm.trap()
  unreachable

bb4:                                              ; preds = %bb9.i, %bb4.i
  br i1 %_6.sroa.0.0.off0.i.i15, label %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtNtCs1SSuMAdGM58_3std4sync6poison5mutex10MutexGuardNtCsiU7OkGI6hgA_10ffi_bridge8RegistryEEB1y_.exit, label %bb1.i.i.i

bb1.i.i.i:                                        ; preds = %bb4
  %20 = load atomic i64, ptr @_RNvNtNtCs1SSuMAdGM58_3std9panicking11panic_count18GLOBAL_PANIC_COUNT monotonic, align 8
  %_7.i.i.i = and i64 %20, 9223372036854775807
  %21 = icmp eq i64 %_7.i.i.i, 0
  br i1 %21, label %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtNtCs1SSuMAdGM58_3std4sync6poison5mutex10MutexGuardNtCsiU7OkGI6hgA_10ffi_bridge8RegistryEEB1y_.exit, label %bb6.i.i.i, !prof !18

bb6.i.i.i:                                        ; preds = %bb1.i.i.i
; call std::panicking::panic_count::is_zero_slow_path
  %_6.i.i.i = tail call noundef zeroext i1 @_RNvNtNtCs1SSuMAdGM58_3std9panicking11panic_count17is_zero_slow_path() #29
  br i1 %_6.i.i.i, label %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtNtCs1SSuMAdGM58_3std4sync6poison5mutex10MutexGuardNtCsiU7OkGI6hgA_10ffi_bridge8RegistryEEB1y_.exit, label %bb2.i.i.i

bb2.i.i.i:                                        ; preds = %bb6.i.i.i
  store atomic i8 1, ptr getelementptr inbounds nuw (i8, ptr @_RNvCsiU7OkGI6hgA_10ffi_bridge8REGISTRY, i64 16) monotonic, align 8
  br label %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtNtCs1SSuMAdGM58_3std4sync6poison5mutex10MutexGuardNtCsiU7OkGI6hgA_10ffi_bridge8RegistryEEB1y_.exit

_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtNtCs1SSuMAdGM58_3std4sync6poison5mutex10MutexGuardNtCsiU7OkGI6hgA_10ffi_bridge8RegistryEEB1y_.exit: ; preds = %bb4, %bb1.i.i.i, %bb6.i.i.i, %bb2.i.i.i
  %22 = load atomic ptr, ptr getelementptr inbounds nuw (i8, ptr @_RNvCsiU7OkGI6hgA_10ffi_bridge8REGISTRY, i64 8) monotonic, align 8
; call <std::sys::pal::unix::sync::mutex::Mutex>::unlock
  tail call void @_RNvMNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutexNtB2_5Mutex6unlock(ptr noundef nonnull align 8 %22)
  br label %bb6

bb6:                                              ; preds = %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtCs1SSuMAdGM58_3std4sync6poison11PoisonErrorINtNtBE_5mutex10MutexGuardNtCsiU7OkGI6hgA_10ffi_bridge8RegistryEEEB1R_.exit, %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtNtCs1SSuMAdGM58_3std4sync6poison5mutex10MutexGuardNtCsiU7OkGI6hgA_10ffi_bridge8RegistryEEB1y_.exit
  ret void
}

; ffi_bridge::transform
; Function Attrs: nofree norecurse nosync nounwind memory(argmem: readwrite) uwtable
define { i32, i32 } @_RNvCsiU7OkGI6hgA_10ffi_bridge9transform(ptr noalias nofree noundef nonnull readonly align 8 captures(none) %input.0, i64 noundef range(i64 0, 1152921504606846976) %input.1, ptr noalias nofree noundef nonnull writeonly align 8 captures(none) %output.0, i64 noundef range(i64 0, 1152921504606846976) %output.1) unnamed_addr #6 personality ptr @rust_eh_personality !guid !59 {
start:
  %_3.not = icmp eq i64 %input.1, %output.1
  br i1 %_3.not, label %bb4.preheader, label %bb8

bb4.preheader:                                    ; preds = %start
  %_2.i5.not = icmp eq i64 %input.1, 0
  br i1 %_2.i5.not, label %bb8, label %bb6.preheader

bb6.preheader:                                    ; preds = %bb4.preheader
  %min.iters.check = icmp samesign ult i64 %input.1, 4
  br i1 %min.iters.check, label %bb6.preheader7, label %vector.ph

vector.ph:                                        ; preds = %bb6.preheader
  %n.vec = and i64 %input.1, 1152921504606846972
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %vector.ph
  %index = phi i64 [ 0, %vector.ph ], [ %index.next, %vector.body ]
  %0 = or disjoint i64 %index, 1
  %1 = or disjoint i64 %index, 2
  %2 = or disjoint i64 %index, 3
  %3 = getelementptr inbounds nuw [8 x i8], ptr %input.0, i64 %index
  %4 = getelementptr inbounds nuw [8 x i8], ptr %input.0, i64 %0
  %5 = getelementptr inbounds nuw [8 x i8], ptr %input.0, i64 %1
  %6 = getelementptr inbounds nuw [8 x i8], ptr %input.0, i64 %2
  %7 = getelementptr inbounds nuw [8 x i8], ptr %output.0, i64 %index
  %8 = getelementptr inbounds nuw [8 x i8], ptr %output.0, i64 %0
  %9 = getelementptr inbounds nuw [8 x i8], ptr %output.0, i64 %1
  %10 = getelementptr inbounds nuw [8 x i8], ptr %output.0, i64 %2
  %11 = load i64, ptr %3, align 8, !noundef !31
  %12 = load i64, ptr %4, align 8, !noundef !31
  %13 = load i64, ptr %5, align 8, !noundef !31
  %14 = load i64, ptr %6, align 8, !noundef !31
  %15 = lshr i64 %11, 29
  %16 = lshr i64 %12, 29
  %17 = lshr i64 %13, 29
  %18 = lshr i64 %14, 29
  %19 = xor i64 %15, %11
  %20 = xor i64 %16, %12
  %21 = xor i64 %17, %13
  %22 = xor i64 %18, %14
  %23 = mul i64 %19, -7046029254386353131
  %24 = mul i64 %20, -7046029254386353131
  %25 = mul i64 %21, -7046029254386353131
  %26 = mul i64 %22, -7046029254386353131
  %27 = add i64 %23, 2611923443488327891
  %28 = add i64 %24, 2611923443488327891
  %29 = add i64 %25, 2611923443488327891
  %30 = add i64 %26, 2611923443488327891
  store i64 %27, ptr %7, align 8
  store i64 %28, ptr %8, align 8
  store i64 %29, ptr %9, align 8
  store i64 %30, ptr %10, align 8
  %index.next = add nuw i64 %index, 4
  %31 = icmp eq i64 %index.next, %n.vec
  br i1 %31, label %middle.block, label %vector.body, !llvm.loop !60

middle.block:                                     ; preds = %vector.body
  %cmp.n = icmp eq i64 %input.1, %n.vec
  br i1 %cmp.n, label %bb8, label %bb6.preheader7

bb6.preheader7:                                   ; preds = %bb6.preheader, %middle.block
  %iter.sroa.8.06.ph = phi i64 [ 0, %bb6.preheader ], [ %n.vec, %middle.block ]
  br label %bb6

bb6:                                              ; preds = %bb6.preheader7, %bb6
  %iter.sroa.8.06 = phi i64 [ %32, %bb6 ], [ %iter.sroa.8.06.ph, %bb6.preheader7 ]
  %32 = add nuw nsw i64 %iter.sroa.8.06, 1
  %_3.i.i = getelementptr inbounds nuw [8 x i8], ptr %input.0, i64 %iter.sroa.8.06
  %_3.i1.i = getelementptr inbounds nuw [8 x i8], ptr %output.0, i64 %iter.sroa.8.06
  %_15 = load i64, ptr %_3.i.i, align 8, !noundef !31
  %_26 = lshr i64 %_15, 29
  %_25 = xor i64 %_26, %_15
  %_24 = mul i64 %_25, -7046029254386353131
  %_14 = add i64 %_24, 2611923443488327891
  store i64 %_14, ptr %_3.i1.i, align 8
  %exitcond.not = icmp eq i64 %32, %input.1
  br i1 %exitcond.not, label %bb8, label %bb6, !llvm.loop !61

bb8:                                              ; preds = %bb6, %middle.block, %bb4.preheader, %start
  %_0.sroa.0.0 = phi i32 [ 1, %start ], [ 0, %bb4.preheader ], [ 0, %middle.block ], [ 0, %bb6 ]
  %33 = insertvalue { i32, i32 } poison, i32 %_0.sroa.0.0, 0
  %34 = insertvalue { i32, i32 } %33, i32 4, 1
  ret { i32, i32 } %34
}

; <ffi_bridge::Registry>::insert
; Function Attrs: uwtable
define internal fastcc void @_RNvMCsiU7OkGI6hgA_10ffi_bridgeNtB2_8Registry6insert(ptr dead_on_unwind noalias nofree noundef nonnull writable writeonly align 8 captures(none) dereferenceable(16) %_0, ptr noalias nofree noundef nonnull align 8 captures(none) dereferenceable(24) %self, ptr noundef nonnull %0, i64 noundef %1) unnamed_addr #3 personality ptr @rust_eh_personality !guid !62 {
start:
  %self3.i.i = alloca [24 x i8], align 8
  %_23 = alloca [24 x i8], align 8
  %data = alloca [16 x i8], align 8
  store ptr %0, ptr %data, align 8
  %2 = getelementptr inbounds nuw i8, ptr %data, i64 8
  store i64 %1, ptr %2, align 8
  %3 = getelementptr inbounds nuw i8, ptr %self, i64 8
  %_33 = load ptr, ptr %3, align 8, !nonnull !31, !noundef !31
  %4 = getelementptr inbounds nuw i8, ptr %self, i64 16
  %_32 = load i64, ptr %4, align 8, !noundef !31
  %_36.idx = mul nuw nsw i64 %_32, 24
  %_36 = getelementptr inbounds nuw i8, ptr %_33, i64 %_36.idx
  %_7.i.i32 = icmp eq i64 %_32, 0
  br i1 %_7.i.i32, label %bb12, label %bb3.i

bb1.i:                                            ; preds = %bb3.i
  %_17.i.i = getelementptr inbounds nuw i8, ptr %_17.i5.i34, i64 24
  %_7.i.i = icmp eq ptr %_17.i.i, %_36
  br i1 %_7.i.i, label %bb12, label %bb3.i

bb3.i:                                            ; preds = %start, %bb1.i
  %_17.i5.i34 = phi ptr [ %_17.i.i, %bb1.i ], [ %_33, %start ]
  %_9.0.i6.i33 = phi i64 [ %_9.0.i.i, %bb1.i ], [ 0, %start ]
  %5 = load ptr, ptr %_17.i5.i34, align 8, !alias.scope !63, !noalias !68, !noundef !31
  %.not.i.i.i.i = icmp ne ptr %5, null
  %6 = getelementptr inbounds nuw i8, ptr %_17.i5.i34, i64 16
  %_5.i.i.i.i = load i32, ptr %6, align 8, !alias.scope !63, !noalias !68
  %7 = icmp eq i32 %_5.i.i.i.i, -1
  %or.cond.i.i.not.i = select i1 %.not.i.i.i.i, i1 true, i1 %7
  %_9.0.i.i = add i64 %_9.0.i6.i33, 1
  br i1 %or.cond.i.i.not.i, label %bb1.i, label %bb1

bb12:                                             ; preds = %bb1.i, %start
  %_47 = icmp ult i64 %_32, 384307168202282326
  tail call void @llvm.assume(i1 %_47)
  %8 = icmp eq i64 %_32, 4096
  br i1 %8, label %bb8, label %bb4

bb4:                                              ; preds = %bb12
  tail call void @llvm.experimental.noalias.scope.decl(metadata !72)
  %self4.i = load i64, ptr %self, align 8, !range !30, !alias.scope !72, !noundef !31
  %_5.i = icmp eq i64 %self4.i, %_32
  br i1 %_5.i, label %bb1.i8, label %bb16.thread

bb16.thread:                                      ; preds = %bb4
  call void @llvm.lifetime.start.p0(ptr nonnull %_23)
  %9 = getelementptr inbounds nuw i8, ptr %_23, i64 16
  store i32 1, ptr %9, align 8
  store ptr %0, ptr %_23, align 8
  %10 = getelementptr inbounds nuw i8, ptr %_23, i64 8
  store i64 %1, ptr %10, align 8
  br label %bb17

bb1.i8:                                           ; preds = %bb4
  tail call void @llvm.experimental.noalias.scope.decl(metadata !75)
  %v16.i.i = shl nuw nsw i64 %_32, 1
  %11 = tail call i64 @llvm.umax.i64(i64 %v16.i.i, i64 4)
  call void @llvm.lifetime.start.p0(ptr nonnull %self3.i.i), !noalias !78
; call <alloc::raw_vec::RawVecInner>::finish_grow
  call fastcc void @_RNvMs5_NtCs6zY7rJBZy9D_5alloc7raw_vecNtB5_11RawVecInner11finish_growCsiU7OkGI6hgA_10ffi_bridge(ptr noalias nofree noundef align 8 captures(none) dereferenceable(24) %self3.i.i, i64 range(i64 0, 384307168202282326) %_32, ptr nonnull %_33, i64 noundef %11, i64 noundef 24)
  %_37.i.i = load i64, ptr %self3.i.i, align 8, !range !32, !noalias !78, !noundef !31
  %12 = trunc nuw i64 %_37.i.i to i1
  br i1 %12, label %bb15, label %bb16

bb8:                                              ; preds = %bb12, %bb15
  store <2 x i32> <i32 1, i32 7>, ptr %_0, align 8
  %_2.i.i = atomicrmw sub ptr %0, i64 1 release, align 8, !noalias !79
  %13 = icmp eq i64 %_2.i.i, 1
  br i1 %13, label %bb2.i.i, label %bb6

bb2.i.i:                                          ; preds = %bb8
  fence acquire
; call <alloc::sync::Arc<[u64]>>::drop_slow
  call void @_RNvMsn_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcSyE9drop_slowCsiU7OkGI6hgA_10ffi_bridge(ptr noalias nofree noundef nonnull readonly align 8 dereferenceable(16) %data) #29
  br label %bb6

bb15:                                             ; preds = %bb1.i8
  call void @llvm.lifetime.end.p0(ptr nonnull %self3.i.i), !noalias !78
  br label %bb8

bb16:                                             ; preds = %bb1.i8
  %14 = getelementptr inbounds nuw i8, ptr %self3.i.i, i64 8
  %v.0.i.i = load ptr, ptr %14, align 8, !noalias !78, !nonnull !31, !noundef !31
  call void @llvm.lifetime.end.p0(ptr nonnull %self3.i.i), !noalias !78
  store ptr %v.0.i.i, ptr %3, align 8, !alias.scope !78
  store i64 %11, ptr %self, align 8, !alias.scope !78
  %15 = icmp eq i64 %_32, %11
  call void @llvm.lifetime.start.p0(ptr nonnull %_23)
  %16 = getelementptr inbounds nuw i8, ptr %_23, i64 16
  store i32 1, ptr %16, align 8
  store ptr %0, ptr %_23, align 8
  %17 = getelementptr inbounds nuw i8, ptr %_23, i64 8
  store i64 %1, ptr %17, align 8
  tail call void @llvm.experimental.noalias.scope.decl(metadata !84)
  br i1 %15, label %bb1.i9, label %bb17

bb1.i9:                                           ; preds = %bb16
; invoke <alloc::raw_vec::RawVec<ffi_bridge::Slot>>::grow_one
  invoke void @_RNvMs4_NtCs6zY7rJBZy9D_5alloc7raw_vecINtB5_6RawVecNtCsiU7OkGI6hgA_10ffi_bridge4SlotE8grow_oneBO_(ptr noalias nofree noundef nonnull align 8 dereferenceable(24) %self)
          to label %bb1.i9.bb17_crit_edge unwind label %bb2.i.i.i10, !noalias !87

bb1.i9.bb17_crit_edge:                            ; preds = %bb1.i9
  %_14.i.pre = load ptr, ptr %3, align 8, !alias.scope !84, !noalias !87
  br label %bb17

bb2.i.i.i10:                                      ; preds = %bb1.i9
  %18 = landingpad { ptr, i32 }
          cleanup
  %_2.i.i.i.i.i = atomicrmw sub ptr %0, i64 1 release, align 8, !noalias !89
  %19 = icmp eq i64 %_2.i.i.i.i.i, 1
  br i1 %19, label %bb2.i.i.i.i.i, label %bb7

bb2.i.i.i.i.i:                                    ; preds = %bb2.i.i.i10
  fence acquire
; call <alloc::sync::Arc<[u64]>>::drop_slow
  call void @_RNvMsn_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcSyE9drop_slowCsiU7OkGI6hgA_10ffi_bridge(ptr noalias nofree noundef nonnull readonly align 8 dereferenceable(24) %_23) #29, !noalias !84
  br label %bb7

bb17:                                             ; preds = %bb16.thread, %bb1.i9.bb17_crit_edge, %bb16
  %_14.i = phi ptr [ %_14.i.pre, %bb1.i9.bb17_crit_edge ], [ %v.0.i.i, %bb16 ], [ %_33, %bb16.thread ]
  %end.i = getelementptr inbounds nuw [24 x i8], ptr %_14.i, i64 %_32
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 8 dereferenceable(24) %end.i, ptr noundef nonnull readonly align 8 dereferenceable(24) %_23, i64 24, i1 false), !noalias !84
  %20 = add nuw nsw i64 %_32, 1
  store i64 %20, ptr %4, align 8, !alias.scope !84, !noalias !87
  call void @llvm.lifetime.end.p0(ptr nonnull %_23)
  %_57 = icmp samesign ult i64 %_32, 384307168202282325
  tail call void @llvm.assume(i1 %_57)
  %_26 = or i64 %20, 4294967296
  %21 = getelementptr inbounds nuw i8, ptr %_0, i64 8
  store i64 %_26, ptr %21, align 8
  store i32 0, ptr %_0, align 8
  br label %bb6

bb6:                                              ; preds = %bb2.i.i, %bb8, %bb1, %bb17
  ret void

bb1:                                              ; preds = %bb3.i
  %22 = getelementptr inbounds nuw i8, ptr %_17.i5.i34, i64 16
  %23 = add nuw i32 %_5.i.i.i.i, 1
  store i32 %23, ptr %22, align 8
  store ptr %0, ptr %_17.i5.i34, align 8
  %24 = getelementptr inbounds nuw i8, ptr %_17.i5.i34, i64 8
  store i64 %1, ptr %24, align 8
  %_13 = zext i32 %23 to i64
  %_12 = shl nuw i64 %_13, 32
  %_11 = or i64 %_12, %_9.0.i.i
  %25 = getelementptr inbounds nuw i8, ptr %_0, i64 8
  store i64 %_11, ptr %25, align 8
  store i32 0, ptr %_0, align 8
  br label %bb6

bb7:                                              ; preds = %bb2.i.i.i.i.i, %bb2.i.i.i10
  resume { ptr, i32 } %18
}

; <alloc::raw_vec::RawVecInner>::grow_exact
; Function Attrs: cold nounwind uwtable
define internal fastcc i64 @_RNvMs2_NtCs6zY7rJBZy9D_5alloc7raw_vecNtB5_11RawVecInner10grow_exactCsiU7OkGI6hgA_10ffi_bridge(ptr noalias nofree noundef nonnull align 8 captures(none) dereferenceable(16) %self, i64 noundef range(i64 1, 16777217) %additional) unnamed_addr #0 !guid !98 {
start:
  %self3 = alloca [24 x i8], align 8
  call void @llvm.lifetime.start.p0(ptr nonnull %self3)
  %self.val = load i64, ptr %self, align 8
  %0 = getelementptr inbounds nuw i8, ptr %self, i64 8
  %self.val12 = load ptr, ptr %0, align 8
; call <alloc::raw_vec::RawVecInner>::finish_grow
  call fastcc void @_RNvMs5_NtCs6zY7rJBZy9D_5alloc7raw_vecNtB5_11RawVecInner11finish_growCsiU7OkGI6hgA_10ffi_bridge(ptr noalias nofree noundef align 8 captures(none) dereferenceable(24) %self3, i64 %self.val, ptr %self.val12, i64 noundef %additional, i64 noundef 8)
  %_29 = load i64, ptr %self3, align 8, !range !32, !noundef !31
  %1 = trunc nuw i64 %_29 to i1
  %2 = getelementptr inbounds nuw i8, ptr %self3, i64 8
  br i1 %1, label %bb10, label %bb11

bb6:                                              ; preds = %bb10, %bb11
  %_0.sroa.0.0 = phi i64 [ -1, %bb11 ], [ %e.0, %bb10 ]
  ret i64 %_0.sroa.0.0

bb10:                                             ; preds = %start
  %e.0 = load i64, ptr %2, align 8, !range !33, !noundef !31
  call void @llvm.lifetime.end.p0(ptr nonnull %self3)
  br label %bb6

bb11:                                             ; preds = %start
  %v.0 = load ptr, ptr %2, align 8, !nonnull !31, !noundef !31
  call void @llvm.lifetime.end.p0(ptr nonnull %self3)
  store ptr %v.0, ptr %0, align 8
  store i64 %additional, ptr %self, align 8
  br label %bb6
}

; <alloc::raw_vec::RawVec<ffi_bridge::Slot>>::grow_one
; Function Attrs: cold noinline uwtable
define void @_RNvMs4_NtCs6zY7rJBZy9D_5alloc7raw_vecINtB5_6RawVecNtCsiU7OkGI6hgA_10ffi_bridge4SlotE8grow_oneBO_(ptr noalias nofree noundef align 8 captures(none) dereferenceable(16) %self) unnamed_addr #7 personality ptr @rust_eh_personality !guid !99 {
start:
  %self3.i = alloca [24 x i8], align 8
  %self1 = load i64, ptr %self, align 8, !range !30, !noundef !31
  tail call void @llvm.experimental.noalias.scope.decl(metadata !100)
  %v16.i = shl nuw i64 %self1, 1
  %0 = tail call i64 @llvm.umax.i64(i64 %v16.i, i64 4)
  call void @llvm.lifetime.start.p0(ptr nonnull %self3.i), !noalias !100
  %1 = getelementptr inbounds nuw i8, ptr %self, i64 8
  %self.val15.i = load ptr, ptr %1, align 8, !alias.scope !100
; call <alloc::raw_vec::RawVecInner>::finish_grow
  call fastcc void @_RNvMs5_NtCs6zY7rJBZy9D_5alloc7raw_vecNtB5_11RawVecInner11finish_growCsiU7OkGI6hgA_10ffi_bridge(ptr noalias nofree noundef align 8 captures(none) dereferenceable(24) %self3.i, i64 %self1, ptr %self.val15.i, i64 noundef %0, i64 noundef 24)
  %_37.i = load i64, ptr %self3.i, align 8, !range !32, !noalias !100, !noundef !31
  %2 = trunc nuw i64 %_37.i to i1
  %3 = getelementptr inbounds nuw i8, ptr %self3.i, i64 8
  br i1 %2, label %bb18.i, label %bb3

bb18.i:                                           ; preds = %start
  %e.0.i = load i64, ptr %3, align 8, !range !33, !noalias !100, !noundef !31
  %4 = getelementptr inbounds nuw i8, ptr %self3.i, i64 16
  %e.1.i = load i64, ptr %4, align 8, !noalias !100
  call void @llvm.lifetime.end.p0(ptr nonnull %self3.i), !noalias !100
; call alloc::raw_vec::handle_error
  tail call void @_RNvNtCs6zY7rJBZy9D_5alloc7raw_vec12handle_error(i64 noundef %e.0.i, i64 %e.1.i) #27
  unreachable

bb3:                                              ; preds = %start
  %v.0.i = load ptr, ptr %3, align 8, !noalias !100, !nonnull !31, !noundef !31
  call void @llvm.lifetime.end.p0(ptr nonnull %self3.i), !noalias !100
  store ptr %v.0.i, ptr %1, align 8, !alias.scope !100
  %5 = icmp sgt i64 %0, -1
  tail call void @llvm.assume(i1 %5)
  store i64 %0, ptr %self, align 8, !alias.scope !100
  ret void
}

; <alloc::raw_vec::RawVecInner>::finish_grow
; Function Attrs: cold nounwind uwtable
define internal fastcc void @_RNvMs5_NtCs6zY7rJBZy9D_5alloc7raw_vecNtB5_11RawVecInner11finish_growCsiU7OkGI6hgA_10ffi_bridge(ptr dead_on_unwind noalias nofree noundef nonnull writable writeonly align 8 captures(none) dereferenceable(24) initializes((0, 8)) %_0, i64 %self.0.val, ptr %self.8.val, i64 noundef %cap, i64 noundef range(i64 8, 25) %elem_layout.1) unnamed_addr #0 !guid !103 {
start:
  %0 = tail call { i64, i1 } @llvm.umul.with.overflow.i64(i64 %elem_layout.1, i64 %cap)
  %_32.0 = extractvalue { i64, i1 } %0, 0
  %_32.1 = extractvalue { i64, i1 } %0, 1
  %_37 = icmp ugt i64 %_32.0, 9223372036854775800
  %or.cond.not = or i1 %_32.1, %_37
  br i1 %or.cond.not, label %bb8, label %bb12, !prof !104

bb12:                                             ; preds = %start
  %1 = icmp eq i64 %self.0.val, 0
  br i1 %1, label %bb5, label %bb3

bb3:                                              ; preds = %bb12
  %alloc_size.i = mul nuw i64 %elem_layout.1, %self.0.val
  call void @llvm.assume(i1 true) [ "nonnull"(ptr %self.8.val) ]
  %cond.i.i = icmp uge i64 %_32.0, %alloc_size.i
  tail call void @llvm.assume(i1 %cond.i.i)
; call __rustc::__rust_realloc
  %raw_ptr.i.i = tail call noundef align 8 ptr @_RNvCsdtSMxSA38aw_7___rustc14___rust_realloc(ptr noundef nonnull %self.8.val, i64 noundef %alloc_size.i, i64 noundef 8, i64 noundef range(i64 0, 9223372036854775801) %_32.0) #26
  br label %bb7

bb5:                                              ; preds = %bb12
  %2 = icmp eq i64 %_32.0, 0
  br i1 %2, label %bb19, label %bb4.i.i

bb4.i.i:                                          ; preds = %bb5
; call __rustc::__rust_no_alloc_shim_is_unstable_v2
  tail call void @_RNvCsdtSMxSA38aw_7___rustc35___rust_no_alloc_shim_is_unstable_v2() #26
; call __rustc::__rust_alloc
  %3 = tail call noundef align 8 ptr @_RNvCsdtSMxSA38aw_7___rustc12___rust_alloc(i64 noundef %_32.0, i64 noundef range(i64 1, -9223372036854775807) 8) #26
  br label %bb7

bb7:                                              ; preds = %bb4.i.i, %bb3
  %raw_ptr.i.i.pn = phi ptr [ %raw_ptr.i.i, %bb3 ], [ %3, %bb4.i.i ]
  %4 = icmp eq ptr %raw_ptr.i.i.pn, null
  br i1 %4, label %bb18, label %bb19

bb18:                                             ; preds = %bb7
  %5 = getelementptr inbounds nuw i8, ptr %_0, i64 8
  store i64 8, ptr %5, align 8
  br label %bb8

bb19:                                             ; preds = %bb5, %bb7
  %raw_ptr.i.i.pn8 = phi ptr [ %raw_ptr.i.i.pn, %bb7 ], [ inttoptr (i64 8 to ptr), %bb5 ]
  %6 = getelementptr inbounds nuw i8, ptr %_0, i64 8
  store ptr %raw_ptr.i.i.pn8, ptr %6, align 8
  br label %bb8

bb8:                                              ; preds = %start, %bb19, %bb18
  %.sink10 = phi i64 [ 16, %bb19 ], [ 16, %bb18 ], [ 8, %start ]
  %_32.0.sink = phi i64 [ %_32.0, %bb19 ], [ %_32.0, %bb18 ], [ 0, %start ]
  %.sink = phi i64 [ 0, %bb19 ], [ 1, %bb18 ], [ 1, %start ]
  %7 = getelementptr inbounds nuw i8, ptr %_0, i64 %.sink10
  store i64 %_32.0.sink, ptr %7, align 8
  store i64 %.sink, ptr %_0, align 8
  ret void
}

; <alloc::vec::Vec<u64>>::append_elements
; Function Attrs: inlinehint uwtable
define internal fastcc void @_RNvMs_NtCs6zY7rJBZy9D_5alloc3vecINtB4_3VecyE15append_elementsCsiU7OkGI6hgA_10ffi_bridge(ptr noalias nofree noundef nonnull align 8 captures(none) dereferenceable(24) %self, ptr nofree noundef nonnull readonly captures(none) %other.0, i64 noundef range(i64 0, 2305843009213693952) %other.1) unnamed_addr #4 !guid !105 {
start:
  %0 = getelementptr inbounds nuw i8, ptr %self, i64 16
  %len.i = load i64, ptr %0, align 8, !alias.scope !106, !noundef !31
  %self2.i = load i64, ptr %self, align 8, !range !30, !alias.scope !106, !noundef !31
  %_9.i = sub i64 %self2.i, %len.i
  %_7.i = icmp ugt i64 %other.1, %_9.i
  br i1 %_7.i, label %_RNvMs_NtCs6zY7rJBZy9D_5alloc3vecINtB4_3VecyE7reserveCsiU7OkGI6hgA_10ffi_bridge.exit.thread, label %_RNvMs_NtCs6zY7rJBZy9D_5alloc3vecINtB4_3VecyE7reserveCsiU7OkGI6hgA_10ffi_bridge.exit, !prof !23

_RNvMs_NtCs6zY7rJBZy9D_5alloc3vecINtB4_3VecyE7reserveCsiU7OkGI6hgA_10ffi_bridge.exit.thread: ; preds = %start
; call <alloc::raw_vec::RawVecInner<_>>::reserve::do_reserve_and_handle::<alloc::alloc::Global>
  tail call fastcc void @_RINvNvMs2_NtCs6zY7rJBZy9D_5alloc7raw_vecINtB8_11RawVecInnerpE7reserve21do_reserve_and_handleNtNtBa_5alloc6GlobalECsiU7OkGI6hgA_10ffi_bridge(ptr noalias nofree noundef nonnull align 8 dereferenceable(24) %self, i64 noundef %len.i, i64 noundef %other.1)
  %len1 = load i64, ptr %0, align 8, !noundef !31
  %_102 = icmp ult i64 %len1, 1152921504606846976
  tail call void @llvm.assume(i1 %_102)
  br label %bb2

_RNvMs_NtCs6zY7rJBZy9D_5alloc3vecINtB4_3VecyE7reserveCsiU7OkGI6hgA_10ffi_bridge.exit: ; preds = %start
  %_10 = icmp ult i64 %len.i, 1152921504606846976
  tail call void @llvm.assume(i1 %_10)
  %_6.not = icmp eq i64 %other.1, 0
  br i1 %_6.not, label %bb3, label %bb2

bb3:                                              ; preds = %bb2, %_RNvMs_NtCs6zY7rJBZy9D_5alloc3vecINtB4_3VecyE7reserveCsiU7OkGI6hgA_10ffi_bridge.exit
  %len5 = phi i64 [ %len4, %bb2 ], [ %len.i, %_RNvMs_NtCs6zY7rJBZy9D_5alloc3vecINtB4_3VecyE7reserveCsiU7OkGI6hgA_10ffi_bridge.exit ]
  %1 = add nuw nsw i64 %len5, %other.1
  store i64 %1, ptr %0, align 8
  ret void

bb2:                                              ; preds = %_RNvMs_NtCs6zY7rJBZy9D_5alloc3vecINtB4_3VecyE7reserveCsiU7OkGI6hgA_10ffi_bridge.exit.thread, %_RNvMs_NtCs6zY7rJBZy9D_5alloc3vecINtB4_3VecyE7reserveCsiU7OkGI6hgA_10ffi_bridge.exit
  %len4 = phi i64 [ %len1, %_RNvMs_NtCs6zY7rJBZy9D_5alloc3vecINtB4_3VecyE7reserveCsiU7OkGI6hgA_10ffi_bridge.exit.thread ], [ %len.i, %_RNvMs_NtCs6zY7rJBZy9D_5alloc3vecINtB4_3VecyE7reserveCsiU7OkGI6hgA_10ffi_bridge.exit ]
  %2 = getelementptr inbounds nuw i8, ptr %self, i64 8
  %_11 = load ptr, ptr %2, align 8, !nonnull !31, !noundef !31
  %dst = getelementptr inbounds nuw [8 x i8], ptr %_11, i64 %len4
  %3 = shl nuw nsw i64 %other.1, 3
  tail call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 8 %dst, ptr nonnull align 8 %other.0, i64 %3, i1 false)
  br label %bb3
}

; <alloc::sync::Arc<[u64]>>::drop_slow
; Function Attrs: noinline nounwind uwtable
define void @_RNvMsn_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcSyE9drop_slowCsiU7OkGI6hgA_10ffi_bridge(ptr noalias nofree noundef readonly align 8 captures(none) dereferenceable(16) %self) unnamed_addr #8 personality ptr @rust_eh_personality !guid !109 {
start:
  %_3.0 = load ptr, ptr %self, align 8, !nonnull !31, !noundef !31
  %0 = getelementptr inbounds nuw i8, ptr %self, i64 8
  %_3.1 = load i64, ptr %0, align 8, !noundef !31
  %_16.i.i = icmp eq ptr %_3.0, inttoptr (i64 -1 to ptr)
  br i1 %_16.i.i, label %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc4sync4WeakSyRNtNtBG_5alloc6GlobalEECsiU7OkGI6hgA_10ffi_bridge.exit, label %bb8.i.i

bb8.i.i:                                          ; preds = %start
  %_20.i.i = getelementptr inbounds nuw i8, ptr %_3.0, i64 8
  %_3.i.i = atomicrmw sub ptr %_20.i.i, i64 1 release, align 8
  %1 = icmp eq i64 %_3.i.i, 1
  br i1 %1, label %bb1.i.i, label %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc4sync4WeakSyRNtNtBG_5alloc6GlobalEECsiU7OkGI6hgA_10ffi_bridge.exit

bb1.i.i:                                          ; preds = %bb8.i.i
  fence acquire
  %2 = shl nuw nsw i64 %_3.1, 3
  %3 = add nuw i64 %2, 16
; call __rustc::__rust_dealloc
  tail call void @_RNvCsdtSMxSA38aw_7___rustc14___rust_dealloc(ptr noundef nonnull %_3.0, i64 noundef %3, i64 noundef range(i64 1, -9223372036854775807) 8) #26
  br label %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc4sync4WeakSyRNtNtBG_5alloc6GlobalEECsiU7OkGI6hgA_10ffi_bridge.exit

_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc4sync4WeakSyRNtNtBG_5alloc6GlobalEECsiU7OkGI6hgA_10ffi_bridge.exit: ; preds = %start, %bb8.i.i, %bb1.i.i
  ret void
}

; Function Attrs: nounwind uwtable
define noundef i32 @rb_copy(i64 noundef %0, ptr noundef %1, i64 noundef %2, ptr noundef %3) unnamed_addr #9 personality ptr @rust_eh_personality !guid !110 {
start:
  %_21.i.i.i.i = alloca [16 x i8], align 8
  %data.i.i.i.i = alloca [16 x i8], align 8
  %_43.i.i.i.i = icmp ugt i64 %2, 16777216
  br i1 %_43.i.i.i.i, label %bb7.i, label %bb17.i.i.i.i

bb17.i.i.i.i:                                     ; preds = %start
  %4 = icmp eq i64 %2, 0
  br i1 %4, label %bb19.i.i.i.i, label %bb2.i.i.i.i.i

bb2.i.i.i.i.i:                                    ; preds = %bb17.i.i.i.i
  %_18.i.i.i.i.i = ptrtoint ptr %1 to i64
  %_3.i.i.i.i.i = icmp ne ptr %1, null
  %_19.i.i.i.i.i = and i64 %_18.i.i.i.i.i, 7
  %5 = icmp eq i64 %_19.i.i.i.i.i, 0
  %or.cond.i.i.i.i.i = and i1 %_3.i.i.i.i.i, %5
  br i1 %or.cond.i.i.i.i.i, label %bb4.i.i.i.i.i, label %bb7.i

bb4.i.i.i.i.i:                                    ; preds = %bb2.i.i.i.i.i
  %6 = shl nuw nsw i64 %2, 3
  %_36.0.i.i.i.i.i = add i64 %6, %_18.i.i.i.i.i
  %_36.1.i.i.i.i.i = icmp ult i64 %_36.0.i.i.i.i.i, %_18.i.i.i.i.i
  br i1 %_36.1.i.i.i.i.i, label %bb7.i, label %bb19.i.i.i.i, !prof !23

bb19.i.i.i.i:                                     ; preds = %bb4.i.i.i.i.i, %bb17.i.i.i.i
  %_9.sroa.11.0.i.i.i.i = phi i64 [ 0, %bb17.i.i.i.i ], [ %_18.i.i.i.i.i, %bb4.i.i.i.i.i ]
  %_9.sroa.14.0.i.i.i.i = phi i64 [ 0, %bb17.i.i.i.i ], [ %_36.0.i.i.i.i.i, %bb4.i.i.i.i.i ]
  %_18.i10.i.i.i.i = ptrtoint ptr %3 to i64
  %_3.i11.i.i.i.i = icmp ne ptr %3, null
  %_19.i12.i.i.i.i = and i64 %_18.i10.i.i.i.i, 7
  %7 = icmp eq i64 %_19.i12.i.i.i.i, 0
  %or.cond.i13.i.i.i.i = and i1 %_3.i11.i.i.i.i, %7
  br i1 %or.cond.i13.i.i.i.i, label %bb4.i15.i.i.i.i, label %bb7.i

bb4.i15.i.i.i.i:                                  ; preds = %bb19.i.i.i.i
  %_36.1.i17.i.i.i.i = icmp ugt ptr %3, inttoptr (i64 -9 to ptr)
  br i1 %_36.1.i17.i.i.i.i, label %bb7.i, label %bb21.i.i.i.i, !prof !23

bb21.i.i.i.i:                                     ; preds = %bb4.i15.i.i.i.i
  %_36.0.i16.i.i.i.i = add i64 %_18.i10.i.i.i.i, 8
  %_62.i.i.i.i = icmp ult i64 %_9.sroa.11.0.i.i.i.i, %_36.0.i16.i.i.i.i
  %_63.i.i.i.i = icmp ugt i64 %_9.sroa.14.0.i.i.i.i, %_18.i10.i.i.i.i
  %or.cond.i.i.i.i = and i1 %_62.i.i.i.i, %_63.i.i.i.i
  br i1 %or.cond.i.i.i.i, label %bb7.i, label %bb24.i.i.i.i

bb24.i.i.i.i:                                     ; preds = %bb21.i.i.i.i
  call void @llvm.lifetime.start.p0(ptr nonnull %data.i.i.i.i), !noalias !111
  call void @llvm.lifetime.start.p0(ptr nonnull %_21.i.i.i.i), !noalias !111
; invoke ffi_bridge::snapshot
  invoke fastcc void @_RNvCsiU7OkGI6hgA_10ffi_bridge8snapshot(ptr noalias nofree noundef align 8 captures(address) dereferenceable(16) %_21.i.i.i.i, i64 noundef %0)
          to label %.noexc.i unwind label %catch.i.i, !noalias !118

.noexc.i:                                         ; preds = %bb24.i.i.i.i
  %8 = load ptr, ptr %_21.i.i.i.i, align 8, !noalias !111, !noundef !31
  %9 = icmp eq ptr %8, null
  %10 = getelementptr inbounds nuw i8, ptr %_21.i.i.i.i, i64 8
  br i1 %9, label %bb25.i.i.i.i, label %bb26.i.i.i.i

bb25.i.i.i.i:                                     ; preds = %.noexc.i
  %_74.i.i.i.i = load i32, ptr %10, align 8, !noalias !111, !noundef !31
  call void @llvm.lifetime.end.p0(ptr nonnull %_21.i.i.i.i), !noalias !111
  %11 = zext i32 %_74.i.i.i.i to i64
  %12 = shl nuw i64 %11, 32
  %13 = or disjoint i64 %12, 1
  br label %bb15.sink.split.i.i.i.i

bb26.i.i.i.i:                                     ; preds = %.noexc.i
  %_73.1.i.i.i.i = load i64, ptr %10, align 8, !noalias !111, !noundef !31
  call void @llvm.lifetime.end.p0(ptr nonnull %_21.i.i.i.i), !noalias !111
  store ptr %8, ptr %data.i.i.i.i, align 8, !noalias !111
  %14 = getelementptr inbounds nuw i8, ptr %data.i.i.i.i, i64 8
  store i64 %_73.1.i.i.i.i, ptr %14, align 8, !noalias !111
  %_25.i.i.i.i = icmp ult i64 %2, %_73.1.i.i.i.i
  br i1 %_25.i.i.i.i, label %bb5.i.i.i.i, label %bb6.i.i.i.i

bb6.i.i.i.i:                                      ; preds = %bb26.i.i.i.i
  %_28.i.i.i.i = icmp eq i64 %_73.1.i.i.i.i, 0
  br i1 %_28.i.i.i.i, label %bb9.i.i.i.i, label %bb8.i.i.i.i

bb5.i.i.i.i:                                      ; preds = %bb26.i.i.i.i
  %_2.i.i.i.i.i.i = atomicrmw sub ptr %8, i64 1 release, align 8, !noalias !119
  %15 = icmp eq i64 %_2.i.i.i.i.i.i, 1
  br i1 %15, label %bb2.i.i.i.i.i.i, label %bb15.sink.split.i.i.i.i

bb2.i.i.i.i.i.i:                                  ; preds = %bb5.i.i.i.i
  fence acquire
; call <alloc::sync::Arc<[u64]>>::drop_slow
  call void @_RNvMsn_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcSyE9drop_slowCsiU7OkGI6hgA_10ffi_bridge(ptr noalias nofree noundef nonnull readonly align 8 dereferenceable(16) %data.i.i.i.i) #29, !noalias !111
  br label %bb15.sink.split.i.i.i.i

bb8.i.i.i.i:                                      ; preds = %bb6.i.i.i.i
  %_86.0.i.i.i.i = getelementptr inbounds nuw i8, ptr %8, i64 16
  %16 = shl nuw nsw i64 %_73.1.i.i.i.i, 3
  tail call void @llvm.memcpy.p0.p0.i64(ptr align 8 %1, ptr nonnull align 8 %_86.0.i.i.i.i, i64 %16, i1 false), !noalias !111
  br label %bb9.i.i.i.i

bb9.i.i.i.i:                                      ; preds = %bb8.i.i.i.i, %bb6.i.i.i.i
  store i64 %_73.1.i.i.i.i, ptr %3, align 8, !noalias !111
  %_2.i.i22.i.i.i.i = atomicrmw sub ptr %8, i64 1 release, align 8, !noalias !124
  %17 = icmp eq i64 %_2.i.i22.i.i.i.i, 1
  br i1 %17, label %bb2.i.i23.i.i.i.i, label %bb15.sink.split.i.i.i.i

bb2.i.i23.i.i.i.i:                                ; preds = %bb9.i.i.i.i
  fence acquire
; call <alloc::sync::Arc<[u64]>>::drop_slow
  call void @_RNvMsn_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcSyE9drop_slowCsiU7OkGI6hgA_10ffi_bridge(ptr noalias nofree noundef nonnull readonly align 8 dereferenceable(16) %data.i.i.i.i) #29, !noalias !111
  br label %bb15.sink.split.i.i.i.i

bb15.sink.split.i.i.i.i:                          ; preds = %bb2.i.i23.i.i.i.i, %bb9.i.i.i.i, %bb2.i.i.i.i.i.i, %bb5.i.i.i.i, %bb25.i.i.i.i
  %_0.sroa.0.0.ph.i.i.i.i = phi i64 [ 17179869185, %bb2.i.i.i.i.i.i ], [ %13, %bb25.i.i.i.i ], [ 17179869185, %bb5.i.i.i.i ], [ 0, %bb9.i.i.i.i ], [ 0, %bb2.i.i23.i.i.i.i ]
  call void @llvm.lifetime.end.p0(ptr nonnull %data.i.i.i.i), !noalias !111
  br label %bb7.i

catch.i.i:                                        ; preds = %bb24.i.i.i.i
  %18 = landingpad { ptr, i32 }
          catch ptr null
          filter [0 x ptr] zeroinitializer
  %19 = extractvalue { ptr, i32 } %18, 0
; invoke std::panicking::catch_unwind::cleanup
  %20 = invoke { ptr, ptr } @_RNvNvNtCs1SSuMAdGM58_3std9panicking12catch_unwind7cleanup(ptr noundef %19)
          to label %bb1 unwind label %terminate.i.i, !noalias !118

terminate.i.i:                                    ; preds = %catch.i.i
  %21 = landingpad { ptr, i32 }
          filter [0 x ptr] zeroinitializer
; call core::panicking::panic_cannot_unwind
  tail call void @_RNvNtCsjIpoRzUjyHQ_4core9panicking19panic_cannot_unwind() #25, !noalias !118
  unreachable

bb7.i:                                            ; preds = %bb15.sink.split.i.i.i.i, %bb21.i.i.i.i, %bb4.i15.i.i.i.i, %bb19.i.i.i.i, %bb4.i.i.i.i.i, %bb2.i.i.i.i.i, %start
  %_0.sroa.0.0.i.i.i.i = phi i64 [ 4294967297, %bb19.i.i.i.i ], [ 8589934593, %start ], [ 8589934593, %bb4.i15.i.i.i.i ], [ 4294967297, %bb21.i.i.i.i ], [ 8589934593, %bb4.i.i.i.i.i ], [ 4294967297, %bb2.i.i.i.i.i ], [ %_0.sroa.0.0.ph.i.i.i.i, %bb15.sink.split.i.i.i.i ]
  %_5.sroa.0.4.extract.shift.i = lshr i64 %_0.sroa.0.0.i.i.i.i, 32
  %_5.sroa.0.4.extract.trunc.i = trunc nuw i64 %_5.sroa.0.4.extract.shift.i to i32
  %22 = trunc i64 %_0.sroa.0.0.i.i.i.i to i1
  %..i = select i1 %22, i32 %_5.sroa.0.4.extract.trunc.i, i32 0
  br label %bb1

bb1:                                              ; preds = %bb7.i, %catch.i.i
  %code.sroa.0.0.i = phi i32 [ %..i, %bb7.i ], [ 5, %catch.i.i ]
  ret i32 %code.sroa.0.0.i
}

; Function Attrs: nounwind uwtable
define noundef i32 @rb_create_copy(ptr noundef %0, i64 noundef %1, ptr noundef %2) unnamed_addr #9 personality ptr @rust_eh_personality !guid !129 {
start:
  %data.i.i.i.i = alloca [24 x i8], align 8
  %_26.i.i.i.i = alloca [16 x i8], align 8
  call void @llvm.lifetime.start.p0(ptr nonnull %data.i.i.i.i), !noalias !130
  %_45.i.i.i.i = icmp ugt i64 %1, 16777216
  br i1 %_45.i.i.i.i, label %bb7.i, label %bb22.i.i.i.i

bb22.i.i.i.i:                                     ; preds = %start
  %3 = icmp eq i64 %1, 0
  br i1 %3, label %bb24.i.i.i.i, label %bb2.i.i.i.i.i

bb2.i.i.i.i.i:                                    ; preds = %bb22.i.i.i.i
  %_18.i.i.i.i.i = ptrtoint ptr %0 to i64
  %_3.i.i.i.i.i = icmp ne ptr %0, null
  %_19.i.i.i.i.i = and i64 %_18.i.i.i.i.i, 7
  %4 = icmp eq i64 %_19.i.i.i.i.i, 0
  %or.cond.i.i.i.i.i = and i1 %_3.i.i.i.i.i, %4
  br i1 %or.cond.i.i.i.i.i, label %bb4.i.i.i.i.i, label %bb7.i

bb4.i.i.i.i.i:                                    ; preds = %bb2.i.i.i.i.i
  %5 = shl nuw nsw i64 %1, 3
  %_36.0.i.i.i.i.i = add i64 %5, %_18.i.i.i.i.i
  %_36.1.i.i.i.i.i = icmp ult i64 %_36.0.i.i.i.i.i, %_18.i.i.i.i.i
  br i1 %_36.1.i.i.i.i.i, label %bb7.i, label %bb24.i.i.i.i, !prof !23

bb24.i.i.i.i:                                     ; preds = %bb4.i.i.i.i.i, %bb22.i.i.i.i
  %_9.sroa.11.0.i.i.i.i = phi i64 [ 0, %bb22.i.i.i.i ], [ %_18.i.i.i.i.i, %bb4.i.i.i.i.i ]
  %_9.sroa.14.0.i.i.i.i = phi i64 [ 0, %bb22.i.i.i.i ], [ %_36.0.i.i.i.i.i, %bb4.i.i.i.i.i ]
  %_18.i22.i.i.i.i = ptrtoint ptr %2 to i64
  %_3.i23.i.i.i.i = icmp ne ptr %2, null
  %_19.i24.i.i.i.i = and i64 %_18.i22.i.i.i.i, 7
  %6 = icmp eq i64 %_19.i24.i.i.i.i, 0
  %or.cond.i25.i.i.i.i = and i1 %_3.i23.i.i.i.i, %6
  br i1 %or.cond.i25.i.i.i.i, label %bb4.i27.i.i.i.i, label %bb7.i

bb4.i27.i.i.i.i:                                  ; preds = %bb24.i.i.i.i
  %_36.1.i29.i.i.i.i = icmp ugt ptr %2, inttoptr (i64 -9 to ptr)
  br i1 %_36.1.i29.i.i.i.i, label %bb7.i, label %bb26.i.i.i.i, !prof !23

bb26.i.i.i.i:                                     ; preds = %bb4.i27.i.i.i.i
  %_36.0.i28.i.i.i.i = add i64 %_18.i22.i.i.i.i, 8
  %_64.i.i.i.i = icmp ult i64 %_9.sroa.11.0.i.i.i.i, %_36.0.i28.i.i.i.i
  %_65.i.i.i.i = icmp ugt i64 %_9.sroa.14.0.i.i.i.i, %_18.i22.i.i.i.i
  %or.cond.i.i.i.i = and i1 %_64.i.i.i.i, %_65.i.i.i.i
  br i1 %or.cond.i.i.i.i, label %bb7.i, label %bb29.i.i.i.i

bb29.i.i.i.i:                                     ; preds = %bb26.i.i.i.i
  store i64 0, ptr %data.i.i.i.i, align 8, !noalias !135
  %7 = getelementptr inbounds nuw i8, ptr %data.i.i.i.i, i64 8
  store ptr inttoptr (i64 8 to ptr), ptr %7, align 8, !noalias !135
  %8 = getelementptr inbounds nuw i8, ptr %data.i.i.i.i, i64 16
  store i64 0, ptr %8, align 8, !noalias !135
  br i1 %3, label %bb5.i.i.i.i, label %bb1.i33.i.i.i.i

bb1.i33.i.i.i.i:                                  ; preds = %bb29.i.i.i.i
; call <alloc::raw_vec::RawVecInner>::grow_exact
  %9 = call fastcc i64 @_RNvMs2_NtCs6zY7rJBZy9D_5alloc7raw_vecNtB5_11RawVecInner10grow_exactCsiU7OkGI6hgA_10ffi_bridge(ptr noalias nofree noundef nonnull align 8 dereferenceable(16) %data.i.i.i.i, i64 noundef range(i64 0, 16777217) %1)
  %.not.i.i.i.i.i = icmp eq i64 %9, -1
  br i1 %.not.i.i.i.i.i, label %bb4.i.i.i.i, label %bb18.i.i.i.i

bb5.i.i.i.i:                                      ; preds = %bb4.i.i.i.i, %bb29.i.i.i.i
  call void @llvm.lifetime.start.p0(ptr nonnull %_26.i.i.i.i), !noalias !135
  %10 = load atomic ptr, ptr @_RNvCsiU7OkGI6hgA_10ffi_bridge8REGISTRY acquire, align 8, !noalias !135
  %_11.i.i.i.i.i.i = icmp eq ptr %10, null
  br i1 %_11.i.i.i.i.i.i, label %bb6.i.i.i.i, label %bb8.i.i.i.i.i.i, !prof !18

bb8.i.i.i.i.i.i:                                  ; preds = %bb5.i.i.i.i
; invoke <std::sync::once_lock::OnceLock<std::sync::poison::mutex::Mutex<ffi_bridge::Registry>>>::initialize::<<std::sync::once_lock::OnceLock<std::sync::poison::mutex::Mutex<ffi_bridge::Registry>>>::get_or_init<ffi_bridge::registry::{closure#0}>::{closure#0}, !>
  invoke fastcc void @_RINvMNtNtCs1SSuMAdGM58_3std4sync9once_lockINtB3_8OnceLockINtNtNtB5_6poison5mutex5MutexNtCsiU7OkGI6hgA_10ffi_bridge8RegistryEE10initializeNCINvB2_11get_or_initNCNvB1o_8registry0E0zEB1o_()
          to label %bb6.i.i.i.i unwind label %bb19.i.i.i.i, !noalias !135

bb4.i.i.i.i:                                      ; preds = %bb1.i33.i.i.i.i
  %self5.pre.i.i.i.i.i = load i64, ptr %data.i.i.i.i, align 8, !range !30, !noalias !135
  %11 = icmp samesign ule i64 %1, %self5.pre.i.i.i.i.i
  tail call void @llvm.assume(i1 %11)
  call void @llvm.assume(i1 true) [ "nonnull"(ptr %0) ]
; invoke <alloc::vec::Vec<u64>>::append_elements
  invoke fastcc void @_RNvMs_NtCs6zY7rJBZy9D_5alloc3vecINtB4_3VecyE15append_elementsCsiU7OkGI6hgA_10ffi_bridge(ptr noalias nofree noundef align 8 dereferenceable(24) %data.i.i.i.i, ptr noundef %0, i64 noundef %1)
          to label %bb5.i.i.i.i unwind label %bb19.i.i.i.i, !noalias !135

bb6.i.i.i.i:                                      ; preds = %bb8.i.i.i.i.i.i, %bb5.i.i.i.i
  %12 = load atomic ptr, ptr getelementptr inbounds nuw (i8, ptr @_RNvCsiU7OkGI6hgA_10ffi_bridge8REGISTRY, i64 8) acquire, align 8, !noalias !138
  %_11.i.i34.i.i.i.i = icmp eq ptr %12, null
  br i1 %_11.i.i34.i.i.i.i, label %bb7.i.i.i.i.i.i, label %_RINvMNtNtNtCs1SSuMAdGM58_3std3sys4sync8once_boxINtB3_7OnceBoxNtNtNtNtNtB7_3pal4unix4sync5mutex5MutexE11get_or_initNCNvMNtNtB5_5mutex7pthreadNtB1T_5Mutex3get0ECsiU7OkGI6hgA_10ffi_bridge.exit.i.i.i.i.i, !prof !23

bb7.i.i.i.i.i.i:                                  ; preds = %bb6.i.i.i.i
; invoke <std::sys::sync::once_box::OnceBox<std::sys::pal::unix::sync::mutex::Mutex>>::initialize::<<std::sys::sync::mutex::pthread::Mutex>::get::{closure#0}>
  %13 = invoke fastcc noundef nonnull align 8 ptr @_RINvMNtNtNtCs1SSuMAdGM58_3std3sys4sync8once_boxINtB3_7OnceBoxNtNtNtNtNtB7_3pal4unix4sync5mutex5MutexE10initializeNCNvMNtNtB5_5mutex7pthreadNtB1S_5Mutex3get0ECsiU7OkGI6hgA_10ffi_bridge()
          to label %_RINvMNtNtNtCs1SSuMAdGM58_3std3sys4sync8once_boxINtB3_7OnceBoxNtNtNtNtNtB7_3pal4unix4sync5mutex5MutexE11get_or_initNCNvMNtNtB5_5mutex7pthreadNtB1T_5Mutex3get0ECsiU7OkGI6hgA_10ffi_bridge.exit.i.i.i.i.i unwind label %bb19.i.i.i.i, !noalias !135

_RINvMNtNtNtCs1SSuMAdGM58_3std3sys4sync8once_boxINtB3_7OnceBoxNtNtNtNtNtB7_3pal4unix4sync5mutex5MutexE11get_or_initNCNvMNtNtB5_5mutex7pthreadNtB1T_5Mutex3get0ECsiU7OkGI6hgA_10ffi_bridge.exit.i.i.i.i.i: ; preds = %bb7.i.i.i.i.i.i, %bb6.i.i.i.i
  %_0.sroa.0.0.i.i.i.i.i.i = phi ptr [ %12, %bb6.i.i.i.i ], [ %13, %bb7.i.i.i.i.i.i ]
; invoke <std::sys::pal::unix::sync::mutex::Mutex>::lock
  invoke void @_RNvMNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutexNtB2_5Mutex4lock(ptr noundef nonnull align 8 %_0.sroa.0.0.i.i.i.i.i.i)
          to label %.noexc36.i.i.i.i unwind label %bb19.i.i.i.i, !noalias !135

.noexc36.i.i.i.i:                                 ; preds = %_RINvMNtNtNtCs1SSuMAdGM58_3std3sys4sync8once_boxINtB3_7OnceBoxNtNtNtNtNtB7_3pal4unix4sync5mutex5MutexE11get_or_initNCNvMNtNtB5_5mutex7pthreadNtB1T_5Mutex3get0ECsiU7OkGI6hgA_10ffi_bridge.exit.i.i.i.i.i
  %14 = load atomic i64, ptr @_RNvNtNtCs1SSuMAdGM58_3std9panicking11panic_count18GLOBAL_PANIC_COUNT monotonic, align 8, !noalias !138
  %_7.i.i.i.i.i.i = and i64 %14, 9223372036854775807
  %15 = icmp eq i64 %_7.i.i.i.i.i.i, 0
  br i1 %15, label %bb7.i.thread.i.i.i, label %bb6.i.i.i.i.i.i, !prof !18

bb6.i.i.i.i.i.i:                                  ; preds = %.noexc36.i.i.i.i
; invoke std::panicking::panic_count::is_zero_slow_path
  %16 = invoke noundef zeroext i1 @_RNvNtNtCs1SSuMAdGM58_3std9panicking11panic_count17is_zero_slow_path() #29
          to label %bb7.i.i.i.i unwind label %bb19.i.i.i.i, !noalias !135

bb7.i.i.i.i:                                      ; preds = %bb6.i.i.i.i.i.i
  %17 = xor i1 %16, true
  %18 = load atomic i8, ptr getelementptr inbounds nuw (i8, ptr @_RNvCsiU7OkGI6hgA_10ffi_bridge8REGISTRY, i64 16) monotonic, align 8, !noalias !138
  %_4.not.i.i.not.i.i.i.i = icmp eq i8 %18, 0
  %_0.sroa.3.0.i.i.i.i.i.i = zext i1 %17 to i8
  br i1 %_4.not.i.i.not.i.i.i.i, label %bb36.i.i.i.i, label %bb35.i.i.i.i

bb7.i.thread.i.i.i:                               ; preds = %.noexc36.i.i.i.i
  %19 = load atomic i8, ptr getelementptr inbounds nuw (i8, ptr @_RNvCsiU7OkGI6hgA_10ffi_bridge8REGISTRY, i64 16) monotonic, align 8, !noalias !138
  %_4.not.i.i.not.i7.i.i.i = icmp eq i8 %19, 0
  br i1 %_4.not.i.i.not.i7.i.i.i, label %bb36.i.i.i.i, label %bb1.i.i.i.i.i.i.i

bb35.i.i.i.i:                                     ; preds = %bb7.i.i.i.i
  br i1 %16, label %bb1.i.i.i.i.i.i.i, label %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtNtCs1SSuMAdGM58_3std4sync6poison5mutex10MutexGuardNtCsiU7OkGI6hgA_10ffi_bridge8RegistryEEB1y_.exit.i.i.i.i

bb1.i.i.i.i.i.i.i:                                ; preds = %bb35.i.i.i.i, %bb7.i.thread.i.i.i
  %20 = load atomic i64, ptr @_RNvNtNtCs1SSuMAdGM58_3std9panicking11panic_count18GLOBAL_PANIC_COUNT monotonic, align 8, !noalias !135
  %_7.i.i.i.i.i.i.i = and i64 %20, 9223372036854775807
  %21 = icmp eq i64 %_7.i.i.i.i.i.i.i, 0
  br i1 %21, label %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtNtCs1SSuMAdGM58_3std4sync6poison5mutex10MutexGuardNtCsiU7OkGI6hgA_10ffi_bridge8RegistryEEB1y_.exit.i.i.i.i, label %bb6.i.i.i.i.i.i.i, !prof !18

bb6.i.i.i.i.i.i.i:                                ; preds = %bb1.i.i.i.i.i.i.i
; invoke std::panicking::panic_count::is_zero_slow_path
  %_6.i.i.i.i4.i.i.i = invoke noundef zeroext i1 @_RNvNtNtCs1SSuMAdGM58_3std9panicking11panic_count17is_zero_slow_path() #29
          to label %_6.i.i.i.i.noexc.i.i.i unwind label %bb19.i.i.i.i, !noalias !130

_6.i.i.i.i.noexc.i.i.i:                           ; preds = %bb6.i.i.i.i.i.i.i
  br i1 %_6.i.i.i.i4.i.i.i, label %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtNtCs1SSuMAdGM58_3std4sync6poison5mutex10MutexGuardNtCsiU7OkGI6hgA_10ffi_bridge8RegistryEEB1y_.exit.i.i.i.i, label %bb2.i.i.i.i.i.i.i

bb2.i.i.i.i.i.i.i:                                ; preds = %_6.i.i.i.i.noexc.i.i.i
  store atomic i8 1, ptr getelementptr inbounds nuw (i8, ptr @_RNvCsiU7OkGI6hgA_10ffi_bridge8REGISTRY, i64 16) monotonic, align 8, !noalias !135
  br label %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtNtCs1SSuMAdGM58_3std4sync6poison5mutex10MutexGuardNtCsiU7OkGI6hgA_10ffi_bridge8RegistryEEB1y_.exit.i.i.i.i

_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtNtCs1SSuMAdGM58_3std4sync6poison5mutex10MutexGuardNtCsiU7OkGI6hgA_10ffi_bridge8RegistryEEB1y_.exit.i.i.i.i: ; preds = %bb2.i.i.i.i.i.i.i, %_6.i.i.i.i.noexc.i.i.i, %bb1.i.i.i.i.i.i.i, %bb35.i.i.i.i
  %22 = load atomic ptr, ptr getelementptr inbounds nuw (i8, ptr @_RNvCsiU7OkGI6hgA_10ffi_bridge8REGISTRY, i64 8) monotonic, align 8, !noalias !135
; invoke <std::sys::pal::unix::sync::mutex::Mutex>::unlock
  invoke void @_RNvMNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutexNtB2_5Mutex6unlock(ptr noundef nonnull align 8 %22)
          to label %bb37.i.i.i.i unwind label %bb19.i.i.i.i, !noalias !130

bb36.i.i.i.i:                                     ; preds = %bb7.i.thread.i.i.i, %bb7.i.i.i.i
  %_0.sroa.3.0.i.i.i10.i.i.i = phi i8 [ 0, %bb7.i.thread.i.i.i ], [ %_0.sroa.3.0.i.i.i.i.i.i, %bb7.i.i.i.i ]
  tail call void @llvm.experimental.noalias.scope.decl(metadata !141)
  %_26.sroa.0.0.copyload.i.i.i.i = load i64, ptr %data.i.i.i.i, align 8, !alias.scope !141, !noalias !135
  %_26.sroa.4.0.copyload.i.i.i.i = load ptr, ptr %7, align 8, !alias.scope !141, !noalias !135, !nonnull !31, !noundef !31
  %_26.sroa.5.0.copyload.i.i.i.i = load i64, ptr %8, align 8, !alias.scope !141, !noalias !135
  %_27.i.i.i.i = icmp ult i64 %_26.sroa.5.0.copyload.i.i.i.i, 1152921504606846976
  tail call void @llvm.assume(i1 %_27.i.i.i.i), !noalias !144
  %array_size.i.i.i.i.i = shl nuw nsw i64 %_26.sroa.5.0.copyload.i.i.i.i, 3
; invoke alloc::sync::arcinner_layout_for_value_layout
  %23 = invoke { i64, i64 } @_RNvNtCs6zY7rJBZy9D_5alloc4sync32arcinner_layout_for_value_layout(i64 noundef 8, i64 noundef range(i64 0, 9223372036854775801) %array_size.i.i.i.i.i)
          to label %.noexc.i.i.i unwind label %cleanup4.i.i.i.i, !noalias !130

.noexc.i.i.i:                                     ; preds = %bb36.i.i.i.i
  %layout.0.i.i.i.i.i = extractvalue { i64, i64 } %23, 0
  %layout.1.i.i.i.i.i = extractvalue { i64, i64 } %23, 1
  %24 = icmp eq i64 %layout.1.i.i.i.i.i, 0
  br i1 %24, label %bb2.i.i.i.i.i.i.i.i, label %bb4.i.i.i.i.i.i.i.i

bb2.i.i.i.i.i.i.i.i:                              ; preds = %.noexc.i.i.i
  %self3.i.i.i.i.i.i.i.i = inttoptr i64 %layout.0.i.i.i.i.i to ptr
  br label %_RNCNvMsr_NtCs6zY7rJBZy9D_5alloc4syncINtB7_3ArcSyE21allocate_for_slice_in0CsiU7OkGI6hgA_10ffi_bridge.exit.i.i.i.i.i

bb4.i.i.i.i.i.i.i.i:                              ; preds = %.noexc.i.i.i
; call __rustc::__rust_no_alloc_shim_is_unstable_v2
  tail call void @_RNvCsdtSMxSA38aw_7___rustc35___rust_no_alloc_shim_is_unstable_v2() #26, !noalias !145
; call __rustc::__rust_alloc
  %25 = tail call noundef ptr @_RNvCsdtSMxSA38aw_7___rustc12___rust_alloc(i64 noundef %layout.1.i.i.i.i.i, i64 noundef range(i64 1, -9223372036854775807) %layout.0.i.i.i.i.i) #26, !noalias !145
  br label %_RNCNvMsr_NtCs6zY7rJBZy9D_5alloc4syncINtB7_3ArcSyE21allocate_for_slice_in0CsiU7OkGI6hgA_10ffi_bridge.exit.i.i.i.i.i

_RNCNvMsr_NtCs6zY7rJBZy9D_5alloc4syncINtB7_3ArcSyE21allocate_for_slice_in0CsiU7OkGI6hgA_10ffi_bridge.exit.i.i.i.i.i: ; preds = %bb4.i.i.i.i.i.i.i.i, %bb2.i.i.i.i.i.i.i.i
  %_0.sroa.0.0.i.i.i.i.i.i.i.i = phi ptr [ %self3.i.i.i.i.i.i.i.i, %bb2.i.i.i.i.i.i.i.i ], [ %25, %bb4.i.i.i.i.i.i.i.i ]
  %26 = icmp eq ptr %_0.sroa.0.0.i.i.i.i.i.i.i.i, null
  br i1 %26, label %bb9.i.i.i.i.i, label %_RINvMso_NtCs6zY7rJBZy9D_5alloc4syncINtB6_3ArcSyE19allocate_for_layoutNCNvMsr_B6_Bx_21allocate_for_slice_in0NCB17_s_0ECsiU7OkGI6hgA_10ffi_bridge.exit.i.i.i.i, !prof !23

bb9.i.i.i.i.i:                                    ; preds = %_RNCNvMsr_NtCs6zY7rJBZy9D_5alloc4syncINtB7_3ArcSyE21allocate_for_slice_in0CsiU7OkGI6hgA_10ffi_bridge.exit.i.i.i.i.i
; invoke alloc::alloc::handle_alloc_error
  invoke void @_RNvNtCs6zY7rJBZy9D_5alloc5alloc18handle_alloc_error(i64 noundef %layout.0.i.i.i.i.i, i64 noundef %layout.1.i.i.i.i.i) #27
          to label %.noexc3.i.i.i unwind label %cleanup4.i.i.i.i, !noalias !130

.noexc3.i.i.i:                                    ; preds = %bb9.i.i.i.i.i
  unreachable

_RINvMso_NtCs6zY7rJBZy9D_5alloc4syncINtB6_3ArcSyE19allocate_for_layoutNCNvMsr_B6_Bx_21allocate_for_slice_in0NCB17_s_0ECsiU7OkGI6hgA_10ffi_bridge.exit.i.i.i.i: ; preds = %_RNCNvMsr_NtCs6zY7rJBZy9D_5alloc4syncINtB7_3ArcSyE21allocate_for_slice_in0CsiU7OkGI6hgA_10ffi_bridge.exit.i.i.i.i.i
  store <2 x i64> splat (i64 1), ptr %_0.sroa.0.0.i.i.i.i.i.i.i.i, align 8, !noalias !145
  %_8.0.i.i.i.i = getelementptr inbounds nuw i8, ptr %_0.sroa.0.0.i.i.i.i.i.i.i.i, i64 16
  tail call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 8 %_8.0.i.i.i.i, ptr nonnull align 8 %_26.sroa.4.0.copyload.i.i.i.i, i64 %array_size.i.i.i.i.i, i1 false), !noalias !145
  %27 = icmp eq i64 %_26.sroa.0.0.copyload.i.i.i.i, 0
  br i1 %27, label %bb8.i.i.i.i, label %bb2.i.i.i4.i.i1.i.i.i

bb2.i.i.i4.i.i1.i.i.i:                            ; preds = %_RINvMso_NtCs6zY7rJBZy9D_5alloc4syncINtB6_3ArcSyE19allocate_for_layoutNCNvMsr_B6_Bx_21allocate_for_slice_in0NCB17_s_0ECsiU7OkGI6hgA_10ffi_bridge.exit.i.i.i.i
  %alloc_size.i.i.i.i5.i.i2.i.i.i = shl nuw i64 %_26.sroa.0.0.copyload.i.i.i.i, 3
; call __rustc::__rust_dealloc
  tail call void @_RNvCsdtSMxSA38aw_7___rustc14___rust_dealloc(ptr noundef nonnull %_26.sroa.4.0.copyload.i.i.i.i, i64 noundef %alloc_size.i.i.i.i5.i.i2.i.i.i, i64 noundef range(i64 1, -9223372036854775807) 8) #26, !noalias !145
  br label %bb8.i.i.i.i

cleanup4.i.i.i.i:                                 ; preds = %bb8.i.i.i.i, %bb9.i.i.i.i.i, %bb36.i.i.i.i
  %28 = landingpad { ptr, i32 }
          catch ptr null
          filter [0 x ptr] zeroinitializer
; invoke core::ptr::drop_glue::<std::sync::poison::mutex::MutexGuard<ffi_bridge::Registry>>
  invoke fastcc void @_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtNtCs1SSuMAdGM58_3std4sync6poison5mutex10MutexGuardNtCsiU7OkGI6hgA_10ffi_bridge8RegistryEEB1y_(ptr nonnull getelementptr inbounds nuw (i8, ptr @_RNvCsiU7OkGI6hgA_10ffi_bridge8REGISTRY, i64 8), i8 %_0.sroa.3.0.i.i.i10.i.i.i) #28
          to label %catch.i.body.i unwind label %terminate.i.i.i.i, !noalias !135

bb8.i.i.i.i:                                      ; preds = %bb2.i.i.i4.i.i1.i.i.i, %_RINvMso_NtCs6zY7rJBZy9D_5alloc4syncINtB6_3ArcSyE19allocate_for_layoutNCNvMsr_B6_Bx_21allocate_for_slice_in0NCB17_s_0ECsiU7OkGI6hgA_10ffi_bridge.exit.i.i.i.i
; invoke <ffi_bridge::Registry>::insert
  invoke fastcc void @_RNvMCsiU7OkGI6hgA_10ffi_bridgeNtB2_8Registry6insert(ptr noalias nofree noundef align 8 captures(none) dereferenceable(16) %_26.i.i.i.i, ptr noalias nofree noundef align 8 dereferenceable(24) getelementptr inbounds nuw (i8, ptr @_RNvCsiU7OkGI6hgA_10ffi_bridge8REGISTRY, i64 24), ptr noundef nonnull %_0.sroa.0.0.i.i.i.i.i.i.i.i, i64 noundef %_26.sroa.5.0.copyload.i.i.i.i)
          to label %bb9.i.i.i.i unwind label %cleanup4.i.i.i.i, !noalias !135

bb9.i.i.i.i:                                      ; preds = %bb8.i.i.i.i
  %29 = load i32, ptr %_26.i.i.i.i, align 8, !range !146, !noalias !135, !noundef !31
  %30 = trunc nuw i32 %29 to i1
  br i1 %30, label %bb38.i.i.i.i, label %bb39.i.i.i.i

bb38.i.i.i.i:                                     ; preds = %bb9.i.i.i.i
  %31 = getelementptr inbounds nuw i8, ptr %_26.i.i.i.i, i64 4
  %_112.i.i.i.i = load i32, ptr %31, align 4, !noalias !135, !noundef !31
  call void @llvm.lifetime.end.p0(ptr nonnull %_26.i.i.i.i), !noalias !135
; invoke core::ptr::drop_glue::<std::sync::poison::mutex::MutexGuard<ffi_bridge::Registry>>
  invoke fastcc void @_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtNtCs1SSuMAdGM58_3std4sync6poison5mutex10MutexGuardNtCsiU7OkGI6hgA_10ffi_bridge8RegistryEEB1y_(ptr nonnull getelementptr inbounds nuw (i8, ptr @_RNvCsiU7OkGI6hgA_10ffi_bridge8REGISTRY, i64 8), i8 %_0.sroa.3.0.i.i.i10.i.i.i)
          to label %bb7.i unwind label %catch.i.i, !noalias !147

bb39.i.i.i.i:                                     ; preds = %bb9.i.i.i.i
  %32 = getelementptr inbounds nuw i8, ptr %_26.i.i.i.i, i64 8
  %_111.i.i.i.i = load i64, ptr %32, align 8, !noalias !135, !noundef !31
  call void @llvm.lifetime.end.p0(ptr nonnull %_26.i.i.i.i), !noalias !135
; invoke core::ptr::drop_glue::<std::sync::poison::mutex::MutexGuard<ffi_bridge::Registry>>
  invoke fastcc void @_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtNtCs1SSuMAdGM58_3std4sync6poison5mutex10MutexGuardNtCsiU7OkGI6hgA_10ffi_bridge8RegistryEEB1y_(ptr nonnull getelementptr inbounds nuw (i8, ptr @_RNvCsiU7OkGI6hgA_10ffi_bridge8REGISTRY, i64 8), i8 %_0.sroa.3.0.i.i.i10.i.i.i)
          to label %.noexc4.i unwind label %catch.i.i, !noalias !147

.noexc4.i:                                        ; preds = %bb39.i.i.i.i
  store i64 %_111.i.i.i.i, ptr %2, align 8, !noalias !135
  br label %bb7.i

terminate.i.i.i.i:                                ; preds = %cleanup4.i.i.i.i
  %33 = landingpad { ptr, i32 }
          filter [0 x ptr] zeroinitializer
; call core::panicking::panic_in_cleanup
  tail call void @_RNvNtCsjIpoRzUjyHQ_4core9panicking16panic_in_cleanup() #25, !noalias !135
  unreachable

bb37.i.i.i.i:                                     ; preds = %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtNtCs1SSuMAdGM58_3std4sync6poison5mutex10MutexGuardNtCsiU7OkGI6hgA_10ffi_bridge8RegistryEEB1y_.exit.i.i.i.i
  call void @llvm.lifetime.end.p0(ptr nonnull %_26.i.i.i.i), !noalias !135
  br label %bb18.i.i.i.i

bb18.i.i.i.i:                                     ; preds = %bb37.i.i.i.i, %bb1.i33.i.i.i.i
  %_0.sroa.9.2.i.i.i.i = phi i32 [ 6, %bb37.i.i.i.i ], [ 7, %bb1.i33.i.i.i.i ]
  %data.val19.i.i.i.i = load i64, ptr %data.i.i.i.i, align 8, !noalias !135
  %34 = icmp eq i64 %data.val19.i.i.i.i, 0
  br i1 %34, label %bb7.i, label %bb2.i.i.i4.i.i.i.i.i

bb2.i.i.i4.i.i.i.i.i:                             ; preds = %bb18.i.i.i.i
  %data.val20.i.i.i.i = load ptr, ptr %7, align 8, !noalias !135, !nonnull !31, !noundef !31
  %alloc_size.i.i.i.i5.i.i.i.i.i = shl nuw i64 %data.val19.i.i.i.i, 3
; call __rustc::__rust_dealloc
  tail call void @_RNvCsdtSMxSA38aw_7___rustc14___rust_dealloc(ptr noundef nonnull %data.val20.i.i.i.i, i64 noundef %alloc_size.i.i.i.i5.i.i.i.i.i, i64 noundef range(i64 1, -9223372036854775807) 8) #26, !noalias !135
  br label %bb7.i

bb19.i.i.i.i:                                     ; preds = %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtNtCs1SSuMAdGM58_3std4sync6poison5mutex10MutexGuardNtCsiU7OkGI6hgA_10ffi_bridge8RegistryEEB1y_.exit.i.i.i.i, %bb6.i.i.i.i.i.i.i, %bb6.i.i.i.i.i.i, %_RINvMNtNtNtCs1SSuMAdGM58_3std3sys4sync8once_boxINtB3_7OnceBoxNtNtNtNtNtB7_3pal4unix4sync5mutex5MutexE11get_or_initNCNvMNtNtB5_5mutex7pthreadNtB1T_5Mutex3get0ECsiU7OkGI6hgA_10ffi_bridge.exit.i.i.i.i.i, %bb7.i.i.i.i.i.i, %bb4.i.i.i.i, %bb8.i.i.i.i.i.i
  %lpad.thr_comm.i.i.i.i = landingpad { ptr, i32 }
          catch ptr null
          filter [0 x ptr] zeroinitializer
  %data.val.i.i.i.i = load i64, ptr %data.i.i.i.i, align 8, !noalias !135
  %35 = icmp eq i64 %data.val.i.i.i.i, 0
  br i1 %35, label %catch.i.body.i, label %bb2.i.i.i4.i40.i.i.i.i

bb2.i.i.i4.i40.i.i.i.i:                           ; preds = %bb19.i.i.i.i
  %data.val18.i.i.i.i = load ptr, ptr %7, align 8, !noalias !135, !nonnull !31, !noundef !31
  %alloc_size.i.i.i.i5.i41.i.i.i.i = shl nuw i64 %data.val.i.i.i.i, 3
; call __rustc::__rust_dealloc
  tail call void @_RNvCsdtSMxSA38aw_7___rustc14___rust_dealloc(ptr noundef nonnull %data.val18.i.i.i.i, i64 noundef %alloc_size.i.i.i.i5.i41.i.i.i.i, i64 noundef range(i64 1, -9223372036854775807) 8) #26, !noalias !135
  br label %catch.i.body.i

catch.i.i:                                        ; preds = %bb39.i.i.i.i, %bb38.i.i.i.i
  %36 = landingpad { ptr, i32 }
          catch ptr null
          filter [0 x ptr] zeroinitializer
  br label %catch.i.body.i

catch.i.body.i:                                   ; preds = %catch.i.i, %bb2.i.i.i4.i40.i.i.i.i, %bb19.i.i.i.i, %cleanup4.i.i.i.i
  %eh.lpad-body.i = phi { ptr, i32 } [ %36, %catch.i.i ], [ %lpad.thr_comm.i.i.i.i, %bb2.i.i.i4.i40.i.i.i.i ], [ %28, %cleanup4.i.i.i.i ], [ %lpad.thr_comm.i.i.i.i, %bb19.i.i.i.i ]
  %37 = extractvalue { ptr, i32 } %eh.lpad-body.i, 0
; invoke std::panicking::catch_unwind::cleanup
  %38 = invoke { ptr, ptr } @_RNvNvNtCs1SSuMAdGM58_3std9panicking12catch_unwind7cleanup(ptr noundef %37)
          to label %bb1 unwind label %terminate.i.i, !noalias !147

terminate.i.i:                                    ; preds = %catch.i.body.i
  %39 = landingpad { ptr, i32 }
          filter [0 x ptr] zeroinitializer
; call core::panicking::panic_cannot_unwind
  tail call void @_RNvNtCsjIpoRzUjyHQ_4core9panicking19panic_cannot_unwind() #25, !noalias !147
  unreachable

bb7.i:                                            ; preds = %bb2.i.i.i4.i.i.i.i.i, %bb18.i.i.i.i, %.noexc4.i, %bb38.i.i.i.i, %bb26.i.i.i.i, %bb4.i27.i.i.i.i, %bb24.i.i.i.i, %bb4.i.i.i.i.i, %bb2.i.i.i.i.i, %start
  %_0.sroa.0.0.i.i.i.i = phi i32 [ 0, %.noexc4.i ], [ 2, %start ], [ 2, %bb4.i27.i.i.i.i ], [ 1, %bb26.i.i.i.i ], [ 2, %bb4.i.i.i.i.i ], [ 1, %bb2.i.i.i.i.i ], [ 1, %bb24.i.i.i.i ], [ %_0.sroa.9.2.i.i.i.i, %bb2.i.i.i4.i.i.i.i.i ], [ %_0.sroa.9.2.i.i.i.i, %bb18.i.i.i.i ], [ %_112.i.i.i.i, %bb38.i.i.i.i ]
  call void @llvm.lifetime.end.p0(ptr nonnull %data.i.i.i.i), !noalias !130
  br label %bb1

bb1:                                              ; preds = %bb7.i, %catch.i.body.i
  %code.sroa.0.0.i = phi i32 [ %_0.sroa.0.0.i.i.i.i, %bb7.i ], [ 5, %catch.i.body.i ]
  ret i32 %code.sroa.0.0.i
}

; Function Attrs: nounwind uwtable
define noundef i32 @rb_generate(i64 noundef %0, i64 noundef %1, ptr noundef %2) unnamed_addr #9 personality ptr @rust_eh_personality !guid !148 {
start:
  %_22.i.i.i.i = alloca [16 x i8], align 8
  %data.i.i.i.i = alloca [24 x i8], align 8
  %_18.i.i.i.i.i = ptrtoint ptr %2 to i64
  %_3.i.i.i.i.i = icmp ne ptr %2, null
  %_19.i.i.i.i.i = and i64 %_18.i.i.i.i.i, 7
  %3 = icmp eq i64 %_19.i.i.i.i.i, 0
  %or.cond.i.i.i.i.i = and i1 %_3.i.i.i.i.i, %3
  br i1 %or.cond.i.i.i.i.i, label %bb4.i.i.i.i.i, label %bb7.i

bb4.i.i.i.i.i:                                    ; preds = %start
  %_36.1.i.i.i.i.i = icmp ugt ptr %2, inttoptr (i64 -9 to ptr)
  %_45.i.i.i.i = icmp ugt i64 %1, 16777216
  %or.cond = or i1 %_45.i.i.i.i, %_36.1.i.i.i.i.i
  br i1 %or.cond, label %bb7.i, label %bb19.i.i.i.i, !prof !104

bb19.i.i.i.i:                                     ; preds = %bb4.i.i.i.i.i
  call void @llvm.lifetime.start.p0(ptr nonnull %data.i.i.i.i), !noalias !149
  store i64 0, ptr %data.i.i.i.i, align 8, !noalias !149
  %4 = getelementptr inbounds nuw i8, ptr %data.i.i.i.i, i64 8
  store ptr inttoptr (i64 8 to ptr), ptr %4, align 8, !noalias !149
  %5 = getelementptr inbounds nuw i8, ptr %data.i.i.i.i, i64 16
  store i64 0, ptr %5, align 8, !noalias !149
  %_5.i.not.i.i.i.i = icmp eq i64 %1, 0
  br i1 %_5.i.not.i.i.i.i, label %_RNvMs_NtCs6zY7rJBZy9D_5alloc3vecINtB4_3VecyE7reserveCsiU7OkGI6hgA_10ffi_bridge.exit.i.i.i.i.i, label %bb1.i.i.i.i.i

bb1.i.i.i.i.i:                                    ; preds = %bb19.i.i.i.i
; call <alloc::raw_vec::RawVecInner>::grow_exact
  %6 = call fastcc i64 @_RNvMs2_NtCs6zY7rJBZy9D_5alloc7raw_vecNtB5_11RawVecInner10grow_exactCsiU7OkGI6hgA_10ffi_bridge(ptr noalias nofree noundef nonnull align 8 dereferenceable(16) %data.i.i.i.i, i64 noundef range(i64 0, 16777217) %1)
  %.not.i.i.i.i.i = icmp eq i64 %6, -1
  br i1 %.not.i.i.i.i.i, label %bb22.thread.i.i.i.i, label %bb13.i.i.i.i

bb22.thread.i.i.i.i:                              ; preds = %bb1.i.i.i.i.i
  %self5.pre.i.i.i.i.i = load i64, ptr %data.i.i.i.i, align 8, !range !30, !alias.scope !156, !noalias !149
  %7 = icmp samesign ule i64 %1, %self5.pre.i.i.i.i.i
  %len.i.i.pre.i.i.i.i = load i64, ptr %5, align 8, !alias.scope !159, !noalias !164
  tail call void @llvm.assume(i1 %7)
  %_9.i.i81.i.i.i.i = sub i64 %self5.pre.i.i.i.i.i, %len.i.i.pre.i.i.i.i
  %_7.i.i82.i.i.i.i = icmp ugt i64 %1, %_9.i.i81.i.i.i.i
  br i1 %_7.i.i82.i.i.i.i, label %bb1.i.i.i.i.i.i, label %bb3.i.i.i.i.preheader.i.i.i.i, !prof !23

bb1.i.i.i.i.i.i:                                  ; preds = %bb22.thread.i.i.i.i
; invoke <alloc::raw_vec::RawVecInner<_>>::reserve::do_reserve_and_handle::<alloc::alloc::Global>
  invoke fastcc void @_RINvNvMs2_NtCs6zY7rJBZy9D_5alloc7raw_vecINtB8_11RawVecInnerpE7reserve21do_reserve_and_handleNtNtBa_5alloc6GlobalECsiU7OkGI6hgA_10ffi_bridge(ptr noalias nofree noundef nonnull align 8 dereferenceable(24) %data.i.i.i.i, i64 noundef %len.i.i.pre.i.i.i.i, i64 noundef %1)
          to label %_RNvMs_NtCs6zY7rJBZy9D_5alloc3vecINtB4_3VecyE7reserveCsiU7OkGI6hgA_10ffi_bridge.exit.i.thread.i.i.i.i unwind label %bb14.i.i.i.i

_RNvMs_NtCs6zY7rJBZy9D_5alloc3vecINtB4_3VecyE7reserveCsiU7OkGI6hgA_10ffi_bridge.exit.i.thread.i.i.i.i: ; preds = %bb1.i.i.i.i.i.i
  %_27.pre.i.i.i.i.i = load i64, ptr %5, align 8, !alias.scope !166, !noalias !164
  br label %bb3.i.i.i.i.preheader.i.i.i.i

_RNvMs_NtCs6zY7rJBZy9D_5alloc3vecINtB4_3VecyE7reserveCsiU7OkGI6hgA_10ffi_bridge.exit.i.i.i.i.i: ; preds = %bb19.i.i.i.i
  tail call void @llvm.experimental.noalias.scope.decl(metadata !166)
  br label %bb23.i.i.i.i

bb3.i.i.i.i.preheader.i.i.i.i:                    ; preds = %_RNvMs_NtCs6zY7rJBZy9D_5alloc3vecINtB4_3VecyE7reserveCsiU7OkGI6hgA_10ffi_bridge.exit.i.thread.i.i.i.i, %bb22.thread.i.i.i.i
  %_27.i75.i.i.i.i = phi i64 [ %_27.pre.i.i.i.i.i, %_RNvMs_NtCs6zY7rJBZy9D_5alloc3vecINtB4_3VecyE7reserveCsiU7OkGI6hgA_10ffi_bridge.exit.i.thread.i.i.i.i ], [ %len.i.i.pre.i.i.i.i, %bb22.thread.i.i.i.i ]
  %_26.i90.i.i.i.i = load ptr, ptr %4, align 8, !alias.scope !166, !noalias !164, !nonnull !31, !noundef !31
  %min.iters.check = icmp ult i64 %1, 4
  br i1 %min.iters.check, label %bb3.i.i.i.i.i.i.i.i.preheader, label %vector.ph

vector.ph:                                        ; preds = %bb3.i.i.i.i.preheader.i.i.i.i
  %n.vec = and i64 %1, 33554428
  %8 = add i64 %_27.i75.i.i.i.i, %n.vec
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %vector.ph
  %index = phi i64 [ 0, %vector.ph ], [ %index.next, %vector.body ]
  %9 = add i64 %_27.i75.i.i.i.i, %index
  %10 = or disjoint i64 %index, 1
  %11 = or disjoint i64 %index, 2
  %12 = or disjoint i64 %index, 3
  %13 = add i64 %index, %0
  %14 = add i64 %10, %0
  %15 = add i64 %11, %0
  %16 = add i64 %12, %0
  %17 = lshr i64 %13, 29
  %18 = lshr i64 %14, 29
  %19 = lshr i64 %15, 29
  %20 = lshr i64 %16, 29
  %21 = xor i64 %17, %13
  %22 = xor i64 %18, %14
  %23 = xor i64 %19, %15
  %24 = xor i64 %20, %16
  %25 = mul i64 %21, -7046029254386353131
  %26 = mul i64 %22, -7046029254386353131
  %27 = mul i64 %23, -7046029254386353131
  %28 = mul i64 %24, -7046029254386353131
  %29 = add i64 %25, 2611923443488327891
  %30 = add i64 %26, 2611923443488327891
  %31 = add i64 %27, 2611923443488327891
  %32 = add i64 %28, 2611923443488327891
  %33 = getelementptr inbounds nuw [8 x i8], ptr %_26.i90.i.i.i.i, i64 %9
  %34 = getelementptr [8 x i8], ptr %_26.i90.i.i.i.i, i64 %9
  %35 = getelementptr i8, ptr %34, i64 8
  %36 = getelementptr [8 x i8], ptr %_26.i90.i.i.i.i, i64 %9
  %37 = getelementptr i8, ptr %36, i64 16
  %38 = getelementptr [8 x i8], ptr %_26.i90.i.i.i.i, i64 %9
  %39 = getelementptr i8, ptr %38, i64 24
  store i64 %29, ptr %33, align 8, !noalias !167
  store i64 %30, ptr %35, align 8, !noalias !167
  store i64 %31, ptr %37, align 8, !noalias !167
  store i64 %32, ptr %39, align 8, !noalias !167
  %index.next = add nuw i64 %index, 4
  %40 = icmp eq i64 %index.next, %n.vec
  br i1 %40, label %middle.block, label %vector.body, !llvm.loop !182

middle.block:                                     ; preds = %vector.body
  %cmp.n = icmp eq i64 %1, %n.vec
  br i1 %cmp.n, label %bb23.i.i.i.i, label %bb3.i.i.i.i.i.i.i.i.preheader

bb3.i.i.i.i.i.i.i.i.preheader:                    ; preds = %bb3.i.i.i.i.preheader.i.i.i.i, %middle.block
  %.ph = phi i64 [ %_27.i75.i.i.i.i, %bb3.i.i.i.i.preheader.i.i.i.i ], [ %8, %middle.block ]
  %self.sroa.0.012.i.i.i.i.i.i.i.i.ph = phi i64 [ 0, %bb3.i.i.i.i.preheader.i.i.i.i ], [ %n.vec, %middle.block ]
  br label %bb3.i.i.i.i.i.i.i.i

bb3.i.i.i.i.i.i.i.i:                              ; preds = %bb3.i.i.i.i.i.i.i.i.preheader, %bb3.i.i.i.i.i.i.i.i
  %41 = phi i64 [ %42, %bb3.i.i.i.i.i.i.i.i ], [ %.ph, %bb3.i.i.i.i.i.i.i.i.preheader ]
  %self.sroa.0.012.i.i.i.i.i.i.i.i = phi i64 [ %_0.i1.i.i.i.i.i.i.i.i.i.i, %bb3.i.i.i.i.i.i.i.i ], [ %self.sroa.0.012.i.i.i.i.i.i.i.i.ph, %bb3.i.i.i.i.i.i.i.i.preheader ]
  %_0.i1.i.i.i.i.i.i.i.i.i.i = add nuw i64 %self.sroa.0.012.i.i.i.i.i.i.i.i, 1
  %_3.i.i.i.i.i.i.i.i.i.i = add i64 %self.sroa.0.012.i.i.i.i.i.i.i.i, %0
  %_9.i.i.i.i.i.i.i.i.i.i = lshr i64 %_3.i.i.i.i.i.i.i.i.i.i, 29
  %_8.i.i.i.i.i.i.i.i.i.i = xor i64 %_9.i.i.i.i.i.i.i.i.i.i, %_3.i.i.i.i.i.i.i.i.i.i
  %_7.i.i.i.i.i.i.i.i.i.i = mul i64 %_8.i.i.i.i.i.i.i.i.i.i, -7046029254386353131
  %_0.i.i.i.i.i.i.i.i.i.i = add i64 %_7.i.i.i.i.i.i.i.i.i.i, 2611923443488327891
  %_3.i.i.i7.i.i.i.i.i.i.i.i = getelementptr inbounds nuw [8 x i8], ptr %_26.i90.i.i.i.i, i64 %41
  store i64 %_0.i.i.i.i.i.i.i.i.i.i, ptr %_3.i.i.i7.i.i.i.i.i.i.i.i, align 8, !noalias !167
  %42 = add i64 %41, 1
  %exitcond.not.i.i.i.i.i.i.i.i = icmp eq i64 %_0.i1.i.i.i.i.i.i.i.i.i.i, %1
  br i1 %exitcond.not.i.i.i.i.i.i.i.i, label %bb23.i.i.i.i, label %bb3.i.i.i.i.i.i.i.i, !llvm.loop !183

bb23.i.i.i.i:                                     ; preds = %bb3.i.i.i.i.i.i.i.i, %middle.block, %_RNvMs_NtCs6zY7rJBZy9D_5alloc3vecINtB4_3VecyE7reserveCsiU7OkGI6hgA_10ffi_bridge.exit.i.i.i.i.i
  %f.val4.i.i.i.i.i.i.i.i = phi i64 [ 0, %_RNvMs_NtCs6zY7rJBZy9D_5alloc3vecINtB4_3VecyE7reserveCsiU7OkGI6hgA_10ffi_bridge.exit.i.i.i.i.i ], [ %8, %middle.block ], [ %42, %bb3.i.i.i.i.i.i.i.i ]
  store i64 %f.val4.i.i.i.i.i.i.i.i, ptr %5, align 8, !alias.scope !166, !noalias !184
  call void @llvm.lifetime.start.p0(ptr nonnull %_22.i.i.i.i), !noalias !149
  %43 = load atomic ptr, ptr @_RNvCsiU7OkGI6hgA_10ffi_bridge8REGISTRY acquire, align 8, !noalias !149
  %_11.i.i.i.i.i.i = icmp eq ptr %43, null
  br i1 %_11.i.i.i.i.i.i, label %bb3.i.i.i.i, label %bb8.i.i.i.i.i.i, !prof !18

bb8.i.i.i.i.i.i:                                  ; preds = %bb23.i.i.i.i
; invoke <std::sync::once_lock::OnceLock<std::sync::poison::mutex::Mutex<ffi_bridge::Registry>>>::initialize::<<std::sync::once_lock::OnceLock<std::sync::poison::mutex::Mutex<ffi_bridge::Registry>>>::get_or_init<ffi_bridge::registry::{closure#0}>::{closure#0}, !>
  invoke fastcc void @_RINvMNtNtCs1SSuMAdGM58_3std4sync9once_lockINtB3_8OnceLockINtNtNtB5_6poison5mutex5MutexNtCsiU7OkGI6hgA_10ffi_bridge8RegistryEE10initializeNCINvB2_11get_or_initNCNvB1o_8registry0E0zEB1o_()
          to label %bb3.i.i.i.i unwind label %bb14.i.i.i.i, !noalias !149

bb3.i.i.i.i:                                      ; preds = %bb8.i.i.i.i.i.i, %bb23.i.i.i.i
  %44 = load atomic ptr, ptr getelementptr inbounds nuw (i8, ptr @_RNvCsiU7OkGI6hgA_10ffi_bridge8REGISTRY, i64 8) acquire, align 8, !noalias !185
  %_11.i.i18.i.i.i.i = icmp eq ptr %44, null
  br i1 %_11.i.i18.i.i.i.i, label %bb7.i.i.i.i.i.i, label %_RINvMNtNtNtCs1SSuMAdGM58_3std3sys4sync8once_boxINtB3_7OnceBoxNtNtNtNtNtB7_3pal4unix4sync5mutex5MutexE11get_or_initNCNvMNtNtB5_5mutex7pthreadNtB1T_5Mutex3get0ECsiU7OkGI6hgA_10ffi_bridge.exit.i.i.i.i.i, !prof !23

bb7.i.i.i.i.i.i:                                  ; preds = %bb3.i.i.i.i
; invoke <std::sys::sync::once_box::OnceBox<std::sys::pal::unix::sync::mutex::Mutex>>::initialize::<<std::sys::sync::mutex::pthread::Mutex>::get::{closure#0}>
  %45 = invoke fastcc noundef nonnull align 8 ptr @_RINvMNtNtNtCs1SSuMAdGM58_3std3sys4sync8once_boxINtB3_7OnceBoxNtNtNtNtNtB7_3pal4unix4sync5mutex5MutexE10initializeNCNvMNtNtB5_5mutex7pthreadNtB1S_5Mutex3get0ECsiU7OkGI6hgA_10ffi_bridge()
          to label %_RINvMNtNtNtCs1SSuMAdGM58_3std3sys4sync8once_boxINtB3_7OnceBoxNtNtNtNtNtB7_3pal4unix4sync5mutex5MutexE11get_or_initNCNvMNtNtB5_5mutex7pthreadNtB1T_5Mutex3get0ECsiU7OkGI6hgA_10ffi_bridge.exit.i.i.i.i.i unwind label %bb14.i.i.i.i, !noalias !149

_RINvMNtNtNtCs1SSuMAdGM58_3std3sys4sync8once_boxINtB3_7OnceBoxNtNtNtNtNtB7_3pal4unix4sync5mutex5MutexE11get_or_initNCNvMNtNtB5_5mutex7pthreadNtB1T_5Mutex3get0ECsiU7OkGI6hgA_10ffi_bridge.exit.i.i.i.i.i: ; preds = %bb7.i.i.i.i.i.i, %bb3.i.i.i.i
  %_0.sroa.0.0.i.i.i.i.i.i = phi ptr [ %44, %bb3.i.i.i.i ], [ %45, %bb7.i.i.i.i.i.i ]
; invoke <std::sys::pal::unix::sync::mutex::Mutex>::lock
  invoke void @_RNvMNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutexNtB2_5Mutex4lock(ptr noundef nonnull align 8 %_0.sroa.0.0.i.i.i.i.i.i)
          to label %.noexc21.i.i.i.i unwind label %bb14.i.i.i.i, !noalias !149

.noexc21.i.i.i.i:                                 ; preds = %_RINvMNtNtNtCs1SSuMAdGM58_3std3sys4sync8once_boxINtB3_7OnceBoxNtNtNtNtNtB7_3pal4unix4sync5mutex5MutexE11get_or_initNCNvMNtNtB5_5mutex7pthreadNtB1T_5Mutex3get0ECsiU7OkGI6hgA_10ffi_bridge.exit.i.i.i.i.i
  %46 = load atomic i64, ptr @_RNvNtNtCs1SSuMAdGM58_3std9panicking11panic_count18GLOBAL_PANIC_COUNT monotonic, align 8, !noalias !185
  %_7.i.i19.i.i.i.i = and i64 %46, 9223372036854775807
  %47 = icmp eq i64 %_7.i.i19.i.i.i.i, 0
  br i1 %47, label %bb4.thread.i.i.i.i, label %bb6.i.i.i.i.i.i, !prof !18

bb6.i.i.i.i.i.i:                                  ; preds = %.noexc21.i.i.i.i
; invoke std::panicking::panic_count::is_zero_slow_path
  %48 = invoke noundef zeroext i1 @_RNvNtNtCs1SSuMAdGM58_3std9panicking11panic_count17is_zero_slow_path() #29
          to label %bb4.i.i.i.i unwind label %bb14.i.i.i.i, !noalias !149

bb4.i.i.i.i:                                      ; preds = %bb6.i.i.i.i.i.i
  %49 = xor i1 %48, true
  %50 = load atomic i8, ptr getelementptr inbounds nuw (i8, ptr @_RNvCsiU7OkGI6hgA_10ffi_bridge8REGISTRY, i64 16) monotonic, align 8, !noalias !185
  %_4.not.i.i.not.i.i.i.i = icmp eq i8 %50, 0
  %_0.sroa.3.0.i.i.i.i.i.i = zext i1 %49 to i8
  br i1 %_4.not.i.i.not.i.i.i.i, label %bb25.i.i.i.i, label %bb24.i.i.i.i

bb4.thread.i.i.i.i:                               ; preds = %.noexc21.i.i.i.i
  %51 = load atomic i8, ptr getelementptr inbounds nuw (i8, ptr @_RNvCsiU7OkGI6hgA_10ffi_bridge8REGISTRY, i64 16) monotonic, align 8, !noalias !185
  %_4.not.i.i64.not.i.i.i.i = icmp eq i8 %51, 0
  br i1 %_4.not.i.i64.not.i.i.i.i, label %bb25.i.i.i.i, label %bb1.i.i.i.i.i.i.i.i

bb24.i.i.i.i:                                     ; preds = %bb4.i.i.i.i
  br i1 %48, label %bb1.i.i.i.i.i.i.i.i, label %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtNtCs1SSuMAdGM58_3std4sync6poison5mutex10MutexGuardNtCsiU7OkGI6hgA_10ffi_bridge8RegistryEEB1y_.exit.i.i.i.i.i

bb1.i.i.i.i.i.i.i.i:                              ; preds = %bb24.i.i.i.i, %bb4.thread.i.i.i.i
  %52 = load atomic i64, ptr @_RNvNtNtCs1SSuMAdGM58_3std9panicking11panic_count18GLOBAL_PANIC_COUNT monotonic, align 8, !noalias !149
  %_7.i.i.i.i.i.i.i.i = and i64 %52, 9223372036854775807
  %53 = icmp eq i64 %_7.i.i.i.i.i.i.i.i, 0
  br i1 %53, label %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtNtCs1SSuMAdGM58_3std4sync6poison5mutex10MutexGuardNtCsiU7OkGI6hgA_10ffi_bridge8RegistryEEB1y_.exit.i.i.i.i.i, label %bb6.i.i.i.i.i.i.i.i, !prof !18

bb6.i.i.i.i.i.i.i.i:                              ; preds = %bb1.i.i.i.i.i.i.i.i
; invoke std::panicking::panic_count::is_zero_slow_path
  %_6.i.i.i.i23.i.i.i.i = invoke noundef zeroext i1 @_RNvNtNtCs1SSuMAdGM58_3std9panicking11panic_count17is_zero_slow_path() #29
          to label %_6.i.i.i.i.noexc.i.i.i.i unwind label %bb14.i.i.i.i, !noalias !149

_6.i.i.i.i.noexc.i.i.i.i:                         ; preds = %bb6.i.i.i.i.i.i.i.i
  br i1 %_6.i.i.i.i23.i.i.i.i, label %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtNtCs1SSuMAdGM58_3std4sync6poison5mutex10MutexGuardNtCsiU7OkGI6hgA_10ffi_bridge8RegistryEEB1y_.exit.i.i.i.i.i, label %bb2.i.i.i.i.i.i.i.i

bb2.i.i.i.i.i.i.i.i:                              ; preds = %_6.i.i.i.i.noexc.i.i.i.i
  store atomic i8 1, ptr getelementptr inbounds nuw (i8, ptr @_RNvCsiU7OkGI6hgA_10ffi_bridge8REGISTRY, i64 16) monotonic, align 8, !noalias !149
  br label %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtNtCs1SSuMAdGM58_3std4sync6poison5mutex10MutexGuardNtCsiU7OkGI6hgA_10ffi_bridge8RegistryEEB1y_.exit.i.i.i.i.i

_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtNtCs1SSuMAdGM58_3std4sync6poison5mutex10MutexGuardNtCsiU7OkGI6hgA_10ffi_bridge8RegistryEEB1y_.exit.i.i.i.i.i: ; preds = %bb2.i.i.i.i.i.i.i.i, %_6.i.i.i.i.noexc.i.i.i.i, %bb1.i.i.i.i.i.i.i.i, %bb24.i.i.i.i
  %54 = load atomic ptr, ptr getelementptr inbounds nuw (i8, ptr @_RNvCsiU7OkGI6hgA_10ffi_bridge8REGISTRY, i64 8) monotonic, align 8, !noalias !149
; invoke <std::sys::pal::unix::sync::mutex::Mutex>::unlock
  invoke void @_RNvMNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutexNtB2_5Mutex6unlock(ptr noundef nonnull align 8 %54)
          to label %bb26.i.i.i.i unwind label %bb14.i.i.i.i, !noalias !149

bb25.i.i.i.i:                                     ; preds = %bb4.thread.i.i.i.i, %bb4.i.i.i.i
  %_0.sroa.3.0.i.i69.i.i.i.i = phi i8 [ 0, %bb4.thread.i.i.i.i ], [ %_0.sroa.3.0.i.i.i.i.i.i, %bb4.i.i.i.i ]
  %_6.sroa.0.0.off0.i.i68.i.i.i.i = phi i1 [ false, %bb4.thread.i.i.i.i ], [ %49, %bb4.i.i.i.i ]
  %_32.sroa.0.0.copyload.i.i.i.i = load i64, ptr %data.i.i.i.i, align 8, !noalias !149
  %_32.sroa.4.0.copyload.i.i.i.i = load ptr, ptr %4, align 8, !noalias !149, !nonnull !31, !noundef !31
  %_32.sroa.5.0.copyload.i.i.i.i = load i64, ptr %5, align 8, !noalias !149
  %_27.i25.i.i.i.i = icmp ult i64 %_32.sroa.5.0.copyload.i.i.i.i, 1152921504606846976
  tail call void @llvm.assume(i1 %_27.i25.i.i.i.i)
  %array_size.i.i.i.i.i.i = shl nuw nsw i64 %_32.sroa.5.0.copyload.i.i.i.i, 3
; invoke alloc::sync::arcinner_layout_for_value_layout
  %55 = invoke { i64, i64 } @_RNvNtCs6zY7rJBZy9D_5alloc4sync32arcinner_layout_for_value_layout(i64 noundef 8, i64 noundef range(i64 0, 9223372036854775801) %array_size.i.i.i.i.i.i)
          to label %.noexc26.i.i.i.i unwind label %cleanup2.i.i.i.i, !noalias !149

.noexc26.i.i.i.i:                                 ; preds = %bb25.i.i.i.i
  %layout.0.i.i.i.i.i.i = extractvalue { i64, i64 } %55, 0
  %layout.1.i.i.i.i.i.i = extractvalue { i64, i64 } %55, 1
  %56 = icmp eq i64 %layout.1.i.i.i.i.i.i, 0
  br i1 %56, label %bb2.i.i.i.i.i.i.i.i.i, label %bb4.i.i.i.i.i.i.i.i.i

bb2.i.i.i.i.i.i.i.i.i:                            ; preds = %.noexc26.i.i.i.i
  %self3.i.i.i.i.i.i.i.i.i = inttoptr i64 %layout.0.i.i.i.i.i.i to ptr
  br label %_RNCNvMsr_NtCs6zY7rJBZy9D_5alloc4syncINtB7_3ArcSyE21allocate_for_slice_in0CsiU7OkGI6hgA_10ffi_bridge.exit.i.i.i.i.i.i

bb4.i.i.i.i.i.i.i.i.i:                            ; preds = %.noexc26.i.i.i.i
; call __rustc::__rust_no_alloc_shim_is_unstable_v2
  tail call void @_RNvCsdtSMxSA38aw_7___rustc35___rust_no_alloc_shim_is_unstable_v2() #26, !noalias !188
; call __rustc::__rust_alloc
  %57 = tail call noundef ptr @_RNvCsdtSMxSA38aw_7___rustc12___rust_alloc(i64 noundef %layout.1.i.i.i.i.i.i, i64 noundef range(i64 1, -9223372036854775807) %layout.0.i.i.i.i.i.i) #26, !noalias !188
  br label %_RNCNvMsr_NtCs6zY7rJBZy9D_5alloc4syncINtB7_3ArcSyE21allocate_for_slice_in0CsiU7OkGI6hgA_10ffi_bridge.exit.i.i.i.i.i.i

_RNCNvMsr_NtCs6zY7rJBZy9D_5alloc4syncINtB7_3ArcSyE21allocate_for_slice_in0CsiU7OkGI6hgA_10ffi_bridge.exit.i.i.i.i.i.i: ; preds = %bb4.i.i.i.i.i.i.i.i.i, %bb2.i.i.i.i.i.i.i.i.i
  %_0.sroa.0.0.i.i.i.i.i.i.i.i.i = phi ptr [ %self3.i.i.i.i.i.i.i.i.i, %bb2.i.i.i.i.i.i.i.i.i ], [ %57, %bb4.i.i.i.i.i.i.i.i.i ]
  %58 = icmp eq ptr %_0.sroa.0.0.i.i.i.i.i.i.i.i.i, null
  br i1 %58, label %bb9.i.i.i.i.i.i, label %_RINvMso_NtCs6zY7rJBZy9D_5alloc4syncINtB6_3ArcSyE19allocate_for_layoutNCNvMsr_B6_Bx_21allocate_for_slice_in0NCB17_s_0ECsiU7OkGI6hgA_10ffi_bridge.exit.i.i.i.i.i, !prof !23

bb9.i.i.i.i.i.i:                                  ; preds = %_RNCNvMsr_NtCs6zY7rJBZy9D_5alloc4syncINtB7_3ArcSyE21allocate_for_slice_in0CsiU7OkGI6hgA_10ffi_bridge.exit.i.i.i.i.i.i
; invoke alloc::alloc::handle_alloc_error
  invoke void @_RNvNtCs6zY7rJBZy9D_5alloc5alloc18handle_alloc_error(i64 noundef %layout.0.i.i.i.i.i.i, i64 noundef %layout.1.i.i.i.i.i.i) #27
          to label %.noexc27.i.i.i.i unwind label %cleanup2.i.i.i.i, !noalias !149

.noexc27.i.i.i.i:                                 ; preds = %bb9.i.i.i.i.i.i
  unreachable

_RINvMso_NtCs6zY7rJBZy9D_5alloc4syncINtB6_3ArcSyE19allocate_for_layoutNCNvMsr_B6_Bx_21allocate_for_slice_in0NCB17_s_0ECsiU7OkGI6hgA_10ffi_bridge.exit.i.i.i.i.i: ; preds = %_RNCNvMsr_NtCs6zY7rJBZy9D_5alloc4syncINtB7_3ArcSyE21allocate_for_slice_in0CsiU7OkGI6hgA_10ffi_bridge.exit.i.i.i.i.i.i
  store <2 x i64> splat (i64 1), ptr %_0.sroa.0.0.i.i.i.i.i.i.i.i.i, align 8, !noalias !188
  %_8.0.i.i.i.i.i = getelementptr inbounds nuw i8, ptr %_0.sroa.0.0.i.i.i.i.i.i.i.i.i, i64 16
  tail call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 8 %_8.0.i.i.i.i.i, ptr nonnull align 8 %_32.sroa.4.0.copyload.i.i.i.i, i64 %array_size.i.i.i.i.i.i, i1 false), !noalias !188
  %59 = icmp eq i64 %_32.sroa.0.0.copyload.i.i.i.i, 0
  br i1 %59, label %bb5.i.i.i.i, label %bb2.i.i.i4.i.i.i.i.i.i

bb2.i.i.i4.i.i.i.i.i.i:                           ; preds = %_RINvMso_NtCs6zY7rJBZy9D_5alloc4syncINtB6_3ArcSyE19allocate_for_layoutNCNvMsr_B6_Bx_21allocate_for_slice_in0NCB17_s_0ECsiU7OkGI6hgA_10ffi_bridge.exit.i.i.i.i.i
  %alloc_size.i.i.i.i5.i.i.i.i.i.i = shl nuw i64 %_32.sroa.0.0.copyload.i.i.i.i, 3
; call __rustc::__rust_dealloc
  tail call void @_RNvCsdtSMxSA38aw_7___rustc14___rust_dealloc(ptr noundef nonnull %_32.sroa.4.0.copyload.i.i.i.i, i64 noundef %alloc_size.i.i.i.i5.i.i.i.i.i.i, i64 noundef range(i64 1, -9223372036854775807) 8) #26, !noalias !188
  br label %bb5.i.i.i.i

cleanup2.i.i.i.i:                                 ; preds = %bb5.i.i.i.i, %bb9.i.i.i.i.i.i, %bb25.i.i.i.i
  %60 = landingpad { ptr, i32 }
          catch ptr null
          filter [0 x ptr] zeroinitializer
; invoke core::ptr::drop_glue::<std::sync::poison::mutex::MutexGuard<ffi_bridge::Registry>>
  invoke fastcc void @_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtNtCs1SSuMAdGM58_3std4sync6poison5mutex10MutexGuardNtCsiU7OkGI6hgA_10ffi_bridge8RegistryEEB1y_(ptr nonnull getelementptr inbounds nuw (i8, ptr @_RNvCsiU7OkGI6hgA_10ffi_bridge8REGISTRY, i64 8), i8 %_0.sroa.3.0.i.i69.i.i.i.i) #28
          to label %catch.i.body.i unwind label %terminate.i.i.i.i, !noalias !149

bb5.i.i.i.i:                                      ; preds = %bb2.i.i.i4.i.i.i.i.i.i, %_RINvMso_NtCs6zY7rJBZy9D_5alloc4syncINtB6_3ArcSyE19allocate_for_layoutNCNvMsr_B6_Bx_21allocate_for_slice_in0NCB17_s_0ECsiU7OkGI6hgA_10ffi_bridge.exit.i.i.i.i.i
; invoke <ffi_bridge::Registry>::insert
  invoke fastcc void @_RNvMCsiU7OkGI6hgA_10ffi_bridgeNtB2_8Registry6insert(ptr noalias nofree noundef align 8 captures(none) dereferenceable(16) %_22.i.i.i.i, ptr noalias nofree noundef align 8 dereferenceable(24) getelementptr inbounds nuw (i8, ptr @_RNvCsiU7OkGI6hgA_10ffi_bridge8REGISTRY, i64 24), ptr noundef nonnull %_0.sroa.0.0.i.i.i.i.i.i.i.i.i, i64 noundef %_32.sroa.5.0.copyload.i.i.i.i)
          to label %bb6.i.i.i.i unwind label %cleanup2.i.i.i.i, !noalias !149

bb6.i.i.i.i:                                      ; preds = %bb5.i.i.i.i
  %61 = load i32, ptr %_22.i.i.i.i, align 8, !range !146, !noalias !149, !noundef !31
  %62 = trunc nuw i32 %61 to i1
  br i1 %62, label %bb27.i.i.i.i, label %bb28.i.i.i.i

bb27.i.i.i.i:                                     ; preds = %bb6.i.i.i.i
  %63 = getelementptr inbounds nuw i8, ptr %_22.i.i.i.i, i64 4
  %_79.i.i.i.i = load i32, ptr %63, align 4, !noalias !149, !noundef !31
  call void @llvm.lifetime.end.p0(ptr nonnull %_22.i.i.i.i), !noalias !149
  br i1 %_6.sroa.0.0.off0.i.i68.i.i.i.i, label %_RNvXsc_NtNtNtCs1SSuMAdGM58_3std4sync6poison5mutexINtB5_10MutexGuardNtCsiU7OkGI6hgA_10ffi_bridge8RegistryENtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4dropB15_.exit.i.i.i.i.i, label %bb1.i.i.i.i.i.i.i

bb1.i.i.i.i.i.i.i:                                ; preds = %bb27.i.i.i.i
  %64 = load atomic i64, ptr @_RNvNtNtCs1SSuMAdGM58_3std9panicking11panic_count18GLOBAL_PANIC_COUNT monotonic, align 8, !noalias !149
  %_7.i.i.i.i.i.i.i = and i64 %64, 9223372036854775807
  %65 = icmp eq i64 %_7.i.i.i.i.i.i.i, 0
  br i1 %65, label %_RNvXsc_NtNtNtCs1SSuMAdGM58_3std4sync6poison5mutexINtB5_10MutexGuardNtCsiU7OkGI6hgA_10ffi_bridge8RegistryENtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4dropB15_.exit.i.i.i.i.i, label %bb6.i.i.i.i.i.i.i, !prof !18

bb6.i.i.i.i.i.i.i:                                ; preds = %bb1.i.i.i.i.i.i.i
; invoke std::panicking::panic_count::is_zero_slow_path
  %_6.i.i.i29.i.i.i4.i = invoke noundef zeroext i1 @_RNvNtNtCs1SSuMAdGM58_3std9panicking11panic_count17is_zero_slow_path() #29
          to label %_6.i.i.i29.i.i.i.noexc.i unwind label %catch.i.i, !noalias !191

_6.i.i.i29.i.i.i.noexc.i:                         ; preds = %bb6.i.i.i.i.i.i.i
  br i1 %_6.i.i.i29.i.i.i4.i, label %_RNvXsc_NtNtNtCs1SSuMAdGM58_3std4sync6poison5mutexINtB5_10MutexGuardNtCsiU7OkGI6hgA_10ffi_bridge8RegistryENtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4dropB15_.exit.i.i.i.i.i, label %bb2.i.i.i.i.i.i.i

bb2.i.i.i.i.i.i.i:                                ; preds = %_6.i.i.i29.i.i.i.noexc.i
  store atomic i8 1, ptr getelementptr inbounds nuw (i8, ptr @_RNvCsiU7OkGI6hgA_10ffi_bridge8REGISTRY, i64 16) monotonic, align 8, !noalias !149
  br label %_RNvXsc_NtNtNtCs1SSuMAdGM58_3std4sync6poison5mutexINtB5_10MutexGuardNtCsiU7OkGI6hgA_10ffi_bridge8RegistryENtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4dropB15_.exit.i.i.i.i.i

_RNvXsc_NtNtNtCs1SSuMAdGM58_3std4sync6poison5mutexINtB5_10MutexGuardNtCsiU7OkGI6hgA_10ffi_bridge8RegistryENtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4dropB15_.exit.i.i.i.i.i: ; preds = %bb2.i.i.i.i.i.i.i, %_6.i.i.i29.i.i.i.noexc.i, %bb1.i.i.i.i.i.i.i, %bb27.i.i.i.i
  %66 = load atomic ptr, ptr getelementptr inbounds nuw (i8, ptr @_RNvCsiU7OkGI6hgA_10ffi_bridge8REGISTRY, i64 8) monotonic, align 8, !noalias !149
; invoke <std::sys::pal::unix::sync::mutex::Mutex>::unlock
  invoke void @_RNvMNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutexNtB2_5Mutex6unlock(ptr noundef nonnull align 8 %66)
          to label %bb10.sink.split.i.i.i.i unwind label %catch.i.i, !noalias !191

bb28.i.i.i.i:                                     ; preds = %bb6.i.i.i.i
  %67 = getelementptr inbounds nuw i8, ptr %_22.i.i.i.i, i64 8
  %_78.i.i.i.i = load i64, ptr %67, align 8, !noalias !149, !noundef !31
  call void @llvm.lifetime.end.p0(ptr nonnull %_22.i.i.i.i), !noalias !149
  br i1 %_6.sroa.0.0.off0.i.i68.i.i.i.i, label %_RNvXsc_NtNtNtCs1SSuMAdGM58_3std4sync6poison5mutexINtB5_10MutexGuardNtCsiU7OkGI6hgA_10ffi_bridge8RegistryENtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4dropB15_.exit.i37.i.i.i.i, label %bb1.i.i.i33.i.i.i.i

bb1.i.i.i33.i.i.i.i:                              ; preds = %bb28.i.i.i.i
  %68 = load atomic i64, ptr @_RNvNtNtCs1SSuMAdGM58_3std9panicking11panic_count18GLOBAL_PANIC_COUNT monotonic, align 8, !noalias !149
  %_7.i.i.i34.i.i.i.i = and i64 %68, 9223372036854775807
  %69 = icmp eq i64 %_7.i.i.i34.i.i.i.i, 0
  br i1 %69, label %_RNvXsc_NtNtNtCs1SSuMAdGM58_3std4sync6poison5mutexINtB5_10MutexGuardNtCsiU7OkGI6hgA_10ffi_bridge8RegistryENtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4dropB15_.exit.i37.i.i.i.i, label %bb6.i.i.i35.i.i.i.i, !prof !18

bb6.i.i.i35.i.i.i.i:                              ; preds = %bb1.i.i.i33.i.i.i.i
; invoke std::panicking::panic_count::is_zero_slow_path
  %_6.i.i.i39.i.i.i5.i = invoke noundef zeroext i1 @_RNvNtNtCs1SSuMAdGM58_3std9panicking11panic_count17is_zero_slow_path() #29
          to label %_6.i.i.i39.i.i.i.noexc.i unwind label %catch.i.i, !noalias !191

_6.i.i.i39.i.i.i.noexc.i:                         ; preds = %bb6.i.i.i35.i.i.i.i
  br i1 %_6.i.i.i39.i.i.i5.i, label %_RNvXsc_NtNtNtCs1SSuMAdGM58_3std4sync6poison5mutexINtB5_10MutexGuardNtCsiU7OkGI6hgA_10ffi_bridge8RegistryENtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4dropB15_.exit.i37.i.i.i.i, label %bb2.i.i.i36.i.i.i.i

bb2.i.i.i36.i.i.i.i:                              ; preds = %_6.i.i.i39.i.i.i.noexc.i
  store atomic i8 1, ptr getelementptr inbounds nuw (i8, ptr @_RNvCsiU7OkGI6hgA_10ffi_bridge8REGISTRY, i64 16) monotonic, align 8, !noalias !149
  br label %_RNvXsc_NtNtNtCs1SSuMAdGM58_3std4sync6poison5mutexINtB5_10MutexGuardNtCsiU7OkGI6hgA_10ffi_bridge8RegistryENtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4dropB15_.exit.i37.i.i.i.i

_RNvXsc_NtNtNtCs1SSuMAdGM58_3std4sync6poison5mutexINtB5_10MutexGuardNtCsiU7OkGI6hgA_10ffi_bridge8RegistryENtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4dropB15_.exit.i37.i.i.i.i: ; preds = %bb2.i.i.i36.i.i.i.i, %_6.i.i.i39.i.i.i.noexc.i, %bb1.i.i.i33.i.i.i.i, %bb28.i.i.i.i
  %70 = load atomic ptr, ptr getelementptr inbounds nuw (i8, ptr @_RNvCsiU7OkGI6hgA_10ffi_bridge8REGISTRY, i64 8) monotonic, align 8, !noalias !149
; invoke <std::sys::pal::unix::sync::mutex::Mutex>::unlock
  invoke void @_RNvMNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutexNtB2_5Mutex6unlock(ptr noundef nonnull align 8 %70)
          to label %.noexc6.i unwind label %catch.i.i, !noalias !191

.noexc6.i:                                        ; preds = %_RNvXsc_NtNtNtCs1SSuMAdGM58_3std4sync6poison5mutexINtB5_10MutexGuardNtCsiU7OkGI6hgA_10ffi_bridge8RegistryENtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4dropB15_.exit.i37.i.i.i.i
  store i64 %_78.i.i.i.i, ptr %2, align 8, !noalias !149
  br label %bb10.sink.split.i.i.i.i

bb10.sink.split.i.i.i.i:                          ; preds = %bb2.i.i.i4.i.i.i.i.i, %bb13.i.i.i.i, %.noexc6.i, %_RNvXsc_NtNtNtCs1SSuMAdGM58_3std4sync6poison5mutexINtB5_10MutexGuardNtCsiU7OkGI6hgA_10ffi_bridge8RegistryENtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4dropB15_.exit.i.i.i.i.i
  %_0.sroa.7.0.ph.i.i.i.i = phi i32 [ undef, %.noexc6.i ], [ %_0.sroa.7.2.i.i.i.i, %bb2.i.i.i4.i.i.i.i.i ], [ %_0.sroa.7.2.i.i.i.i, %bb13.i.i.i.i ], [ %_79.i.i.i.i, %_RNvXsc_NtNtNtCs1SSuMAdGM58_3std4sync6poison5mutexINtB5_10MutexGuardNtCsiU7OkGI6hgA_10ffi_bridge8RegistryENtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4dropB15_.exit.i.i.i.i.i ]
  %_0.sroa.0.0.ph.i.i.i.i = phi i64 [ 0, %.noexc6.i ], [ 1, %bb2.i.i.i4.i.i.i.i.i ], [ 1, %bb13.i.i.i.i ], [ 1, %_RNvXsc_NtNtNtCs1SSuMAdGM58_3std4sync6poison5mutexINtB5_10MutexGuardNtCsiU7OkGI6hgA_10ffi_bridge8RegistryENtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4dropB15_.exit.i.i.i.i.i ]
  call void @llvm.lifetime.end.p0(ptr nonnull %data.i.i.i.i), !noalias !149
  %71 = zext i32 %_0.sroa.7.0.ph.i.i.i.i to i64
  %72 = shl nuw i64 %71, 32
  %73 = or disjoint i64 %72, %_0.sroa.0.0.ph.i.i.i.i
  br label %bb7.i

terminate.i.i.i.i:                                ; preds = %cleanup2.i.i.i.i
  %74 = landingpad { ptr, i32 }
          filter [0 x ptr] zeroinitializer
; call core::panicking::panic_in_cleanup
  tail call void @_RNvNtCsjIpoRzUjyHQ_4core9panicking16panic_in_cleanup() #25, !noalias !149
  unreachable

bb26.i.i.i.i:                                     ; preds = %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtNtCs1SSuMAdGM58_3std4sync6poison5mutex10MutexGuardNtCsiU7OkGI6hgA_10ffi_bridge8RegistryEEB1y_.exit.i.i.i.i.i
  call void @llvm.lifetime.end.p0(ptr nonnull %_22.i.i.i.i), !noalias !149
  br label %bb13.i.i.i.i

bb13.i.i.i.i:                                     ; preds = %bb26.i.i.i.i, %bb1.i.i.i.i.i
  %_0.sroa.7.2.i.i.i.i = phi i32 [ 6, %bb26.i.i.i.i ], [ 7, %bb1.i.i.i.i.i ]
  %data.val15.i.i.i.i = load i64, ptr %data.i.i.i.i, align 8, !noalias !149
  %75 = icmp eq i64 %data.val15.i.i.i.i, 0
  br i1 %75, label %bb10.sink.split.i.i.i.i, label %bb2.i.i.i4.i.i.i.i.i

bb2.i.i.i4.i.i.i.i.i:                             ; preds = %bb13.i.i.i.i
  %data.val16.i.i.i.i = load ptr, ptr %4, align 8, !noalias !149, !nonnull !31, !noundef !31
  %alloc_size.i.i.i.i5.i.i.i.i.i = shl nuw i64 %data.val15.i.i.i.i, 3
; call __rustc::__rust_dealloc
  tail call void @_RNvCsdtSMxSA38aw_7___rustc14___rust_dealloc(ptr noundef nonnull %data.val16.i.i.i.i, i64 noundef %alloc_size.i.i.i.i5.i.i.i.i.i, i64 noundef range(i64 1, -9223372036854775807) 8) #26, !noalias !149
  br label %bb10.sink.split.i.i.i.i

bb14.i.i.i.i:                                     ; preds = %bb1.i.i.i.i.i.i, %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtNtCs1SSuMAdGM58_3std4sync6poison5mutex10MutexGuardNtCsiU7OkGI6hgA_10ffi_bridge8RegistryEEB1y_.exit.i.i.i.i.i, %bb6.i.i.i.i.i.i.i.i, %bb6.i.i.i.i.i.i, %_RINvMNtNtNtCs1SSuMAdGM58_3std3sys4sync8once_boxINtB3_7OnceBoxNtNtNtNtNtB7_3pal4unix4sync5mutex5MutexE11get_or_initNCNvMNtNtB5_5mutex7pthreadNtB1T_5Mutex3get0ECsiU7OkGI6hgA_10ffi_bridge.exit.i.i.i.i.i, %bb7.i.i.i.i.i.i, %bb8.i.i.i.i.i.i
  %lpad.thr_comm.i.i.i.i = landingpad { ptr, i32 }
          catch ptr null
          filter [0 x ptr] zeroinitializer
  %data.val.i.i.i.i = load i64, ptr %data.i.i.i.i, align 8, !noalias !149
  %76 = icmp eq i64 %data.val.i.i.i.i, 0
  br i1 %76, label %catch.i.body.i, label %bb2.i.i.i4.i44.i.i.i.i

bb2.i.i.i4.i44.i.i.i.i:                           ; preds = %bb14.i.i.i.i
  %data.val14.i.i.i.i = load ptr, ptr %4, align 8, !noalias !149, !nonnull !31, !noundef !31
  %alloc_size.i.i.i.i5.i45.i.i.i.i = shl nuw i64 %data.val.i.i.i.i, 3
; call __rustc::__rust_dealloc
  tail call void @_RNvCsdtSMxSA38aw_7___rustc14___rust_dealloc(ptr noundef nonnull %data.val14.i.i.i.i, i64 noundef %alloc_size.i.i.i.i5.i45.i.i.i.i, i64 noundef range(i64 1, -9223372036854775807) 8) #26, !noalias !149
  br label %catch.i.body.i

catch.i.i:                                        ; preds = %_RNvXsc_NtNtNtCs1SSuMAdGM58_3std4sync6poison5mutexINtB5_10MutexGuardNtCsiU7OkGI6hgA_10ffi_bridge8RegistryENtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4dropB15_.exit.i37.i.i.i.i, %bb6.i.i.i35.i.i.i.i, %_RNvXsc_NtNtNtCs1SSuMAdGM58_3std4sync6poison5mutexINtB5_10MutexGuardNtCsiU7OkGI6hgA_10ffi_bridge8RegistryENtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4dropB15_.exit.i.i.i.i.i, %bb6.i.i.i.i.i.i.i
  %77 = landingpad { ptr, i32 }
          catch ptr null
          filter [0 x ptr] zeroinitializer
  br label %catch.i.body.i

catch.i.body.i:                                   ; preds = %catch.i.i, %bb2.i.i.i4.i44.i.i.i.i, %bb14.i.i.i.i, %cleanup2.i.i.i.i
  %eh.lpad-body.i = phi { ptr, i32 } [ %77, %catch.i.i ], [ %lpad.thr_comm.i.i.i.i, %bb2.i.i.i4.i44.i.i.i.i ], [ %60, %cleanup2.i.i.i.i ], [ %lpad.thr_comm.i.i.i.i, %bb14.i.i.i.i ]
  %78 = extractvalue { ptr, i32 } %eh.lpad-body.i, 0
; invoke std::panicking::catch_unwind::cleanup
  %79 = invoke { ptr, ptr } @_RNvNvNtCs1SSuMAdGM58_3std9panicking12catch_unwind7cleanup(ptr noundef %78)
          to label %bb1 unwind label %terminate.i.i, !noalias !191

terminate.i.i:                                    ; preds = %catch.i.body.i
  %80 = landingpad { ptr, i32 }
          filter [0 x ptr] zeroinitializer
; call core::panicking::panic_cannot_unwind
  tail call void @_RNvNtCsjIpoRzUjyHQ_4core9panicking19panic_cannot_unwind() #25, !noalias !191
  unreachable

bb7.i:                                            ; preds = %bb10.sink.split.i.i.i.i, %bb4.i.i.i.i.i, %start
  %_0.sroa.0.0.i.i.i.i = phi i64 [ %73, %bb10.sink.split.i.i.i.i ], [ 4294967297, %start ], [ 8589934593, %bb4.i.i.i.i.i ]
  %_5.sroa.0.4.extract.shift.i = lshr i64 %_0.sroa.0.0.i.i.i.i, 32
  %_5.sroa.0.4.extract.trunc.i = trunc nuw i64 %_5.sroa.0.4.extract.shift.i to i32
  %81 = trunc i64 %_0.sroa.0.0.i.i.i.i to i1
  %..i = select i1 %81, i32 %_5.sroa.0.4.extract.trunc.i, i32 0
  br label %bb1

bb1:                                              ; preds = %bb7.i, %catch.i.body.i
  %code.sroa.0.0.i = phi i32 [ %..i, %bb7.i ], [ 5, %catch.i.body.i ]
  ret i32 %code.sroa.0.0.i
}

; Function Attrs: nounwind uwtable
define noundef i32 @rb_info(i64 noundef %0, i32 noundef %1, i32 noundef %2, ptr noundef %3) unnamed_addr #9 personality ptr @rust_eh_personality !guid !192 {
start:
  %_12.i.i.i.i = alloca [16 x i8], align 8
  %data.i.i.i.i = alloca [16 x i8], align 8
  %4 = icmp eq i32 %1, 1
  %5 = icmp eq i32 %2, 24
  %or.cond = and i1 %4, %5
  br i1 %or.cond, label %bb5.i.i.i.i, label %bb7.i

bb5.i.i.i.i:                                      ; preds = %start
  %_18.i.i.i.i.i = ptrtoint ptr %3 to i64
  %_3.i.i.i.i.i = icmp ne ptr %3, null
  %_19.i.i.i.i.i = and i64 %_18.i.i.i.i.i, 7
  %6 = icmp eq i64 %_19.i.i.i.i.i, 0
  %or.cond.i.i.i.i.i = and i1 %_3.i.i.i.i.i, %6
  br i1 %or.cond.i.i.i.i.i, label %bb7.i.i.i.i.i, label %bb7.i

bb7.i.i.i.i.i:                                    ; preds = %bb5.i.i.i.i
  %_36.1.i.i.i.i.i = icmp ugt ptr %3, inttoptr (i64 -25 to ptr)
  br i1 %_36.1.i.i.i.i.i, label %bb7.i, label %bb15.i.i.i.i, !prof !23

bb15.i.i.i.i:                                     ; preds = %bb7.i.i.i.i.i
  call void @llvm.lifetime.start.p0(ptr nonnull %data.i.i.i.i), !noalias !193
  call void @llvm.lifetime.start.p0(ptr nonnull %_12.i.i.i.i), !noalias !193
; invoke ffi_bridge::snapshot
  invoke fastcc void @_RNvCsiU7OkGI6hgA_10ffi_bridge8snapshot(ptr noalias nofree noundef align 8 captures(address) dereferenceable(16) %_12.i.i.i.i, i64 noundef %0)
          to label %.noexc.i unwind label %catch.i.i, !noalias !200

.noexc.i:                                         ; preds = %bb15.i.i.i.i
  %7 = load ptr, ptr %_12.i.i.i.i, align 8, !noalias !193, !noundef !31
  %8 = icmp eq ptr %7, null
  %9 = getelementptr inbounds nuw i8, ptr %_12.i.i.i.i, i64 8
  br i1 %8, label %bb16.i.i.i.i, label %bb17.i.i.i.i

bb16.i.i.i.i:                                     ; preds = %.noexc.i
  %_36.i.i.i.i = load i32, ptr %9, align 8, !noalias !193, !noundef !31
  call void @llvm.lifetime.end.p0(ptr nonnull %_12.i.i.i.i), !noalias !193
  %10 = zext i32 %_36.i.i.i.i to i64
  %11 = shl nuw i64 %10, 32
  %12 = or disjoint i64 %11, 1
  br label %bb11.sink.split.i.i.i.i

bb17.i.i.i.i:                                     ; preds = %.noexc.i
  %_35.1.i.i.i.i = load i64, ptr %9, align 8, !noalias !193, !noundef !31
  call void @llvm.lifetime.end.p0(ptr nonnull %_12.i.i.i.i), !noalias !193
  store ptr %7, ptr %data.i.i.i.i, align 8, !noalias !193
  %13 = getelementptr inbounds nuw i8, ptr %data.i.i.i.i, i64 8
  store i64 %_35.1.i.i.i.i, ptr %13, align 8, !noalias !193
  %_21.0.i.i.i.i = getelementptr inbounds nuw i8, ptr %7, i64 16
  %14 = icmp eq i64 %_35.1.i.i.i.i, 0
  br i1 %14, label %bb9.i.i.i.i, label %bb8.i.i.i.i.i.i.preheader

bb8.i.i.i.i.i.i.preheader:                        ; preds = %bb17.i.i.i.i
  %min.iters.check = icmp ult i64 %_35.1.i.i.i.i, 8
  br i1 %min.iters.check, label %bb8.i.i.i.i.i.i.preheader10, label %vector.ph

vector.ph:                                        ; preds = %bb8.i.i.i.i.i.i.preheader
  %n.vec = and i64 %_35.1.i.i.i.i, -8
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %vector.ph
  %index = phi i64 [ 0, %vector.ph ], [ %index.next, %vector.body ]
  %vec.phi = phi <2 x i64> [ zeroinitializer, %vector.ph ], [ %19, %vector.body ]
  %vec.phi2 = phi <2 x i64> [ zeroinitializer, %vector.ph ], [ %20, %vector.body ]
  %vec.phi3 = phi <2 x i64> [ zeroinitializer, %vector.ph ], [ %21, %vector.body ]
  %vec.phi4 = phi <2 x i64> [ zeroinitializer, %vector.ph ], [ %22, %vector.body ]
  %15 = getelementptr inbounds nuw [8 x i8], ptr %_21.0.i.i.i.i, i64 %index
  %16 = getelementptr inbounds nuw i8, ptr %15, i64 16
  %17 = getelementptr inbounds nuw i8, ptr %15, i64 32
  %18 = getelementptr inbounds nuw i8, ptr %15, i64 48
  %wide.load = load <2 x i64>, ptr %15, align 8, !alias.scope !201, !noalias !193
  %wide.load5 = load <2 x i64>, ptr %16, align 8, !alias.scope !201, !noalias !193
  %wide.load6 = load <2 x i64>, ptr %17, align 8, !alias.scope !201, !noalias !193
  %wide.load7 = load <2 x i64>, ptr %18, align 8, !alias.scope !201, !noalias !193
  %19 = add <2 x i64> %wide.load, %vec.phi
  %20 = add <2 x i64> %wide.load5, %vec.phi2
  %21 = add <2 x i64> %wide.load6, %vec.phi3
  %22 = add <2 x i64> %wide.load7, %vec.phi4
  %index.next = add nuw i64 %index, 8
  %23 = icmp eq i64 %index.next, %n.vec
  br i1 %23, label %middle.block, label %vector.body, !llvm.loop !204

middle.block:                                     ; preds = %vector.body
  %bin.rdx = add <2 x i64> %20, %19
  %bin.rdx8 = add <2 x i64> %21, %bin.rdx
  %bin.rdx9 = add <2 x i64> %22, %bin.rdx8
  %24 = tail call i64 @llvm.vector.reduce.add.v2i64(<2 x i64> %bin.rdx9)
  %cmp.n = icmp eq i64 %_35.1.i.i.i.i, %n.vec
  br i1 %cmp.n, label %bb9.i.i.i.i, label %bb8.i.i.i.i.i.i.preheader10

bb8.i.i.i.i.i.i.preheader10:                      ; preds = %bb8.i.i.i.i.i.i.preheader, %middle.block
  %i.sroa.0.0.i.i.i.i.i.i.ph = phi i64 [ 0, %bb8.i.i.i.i.i.i.preheader ], [ %n.vec, %middle.block ]
  %acc.sroa.0.0.i.i.i.i.i.i.ph = phi i64 [ 0, %bb8.i.i.i.i.i.i.preheader ], [ %24, %middle.block ]
  br label %bb8.i.i.i.i.i.i

bb8.i.i.i.i.i.i:                                  ; preds = %bb8.i.i.i.i.i.i.preheader10, %bb8.i.i.i.i.i.i
  %i.sroa.0.0.i.i.i.i.i.i = phi i64 [ %_27.i.i.i.i.i.i, %bb8.i.i.i.i.i.i ], [ %i.sroa.0.0.i.i.i.i.i.i.ph, %bb8.i.i.i.i.i.i.preheader10 ]
  %acc.sroa.0.0.i.i.i.i.i.i = phi i64 [ %_0.i.i.i.i.i.i.i, %bb8.i.i.i.i.i.i ], [ %acc.sroa.0.0.i.i.i.i.i.i.ph, %bb8.i.i.i.i.i.i.preheader10 ]
  %_45.i.i.i.i.i.i = getelementptr inbounds nuw [8 x i8], ptr %_21.0.i.i.i.i, i64 %i.sroa.0.0.i.i.i.i.i.i
  %_45.val.i.i.i.i.i.i = load i64, ptr %_45.i.i.i.i.i.i, align 8, !alias.scope !201, !noalias !193, !noundef !31
  %_0.i.i.i.i.i.i.i = add i64 %_45.val.i.i.i.i.i.i, %acc.sroa.0.0.i.i.i.i.i.i
  %_27.i.i.i.i.i.i = add nuw nsw i64 %i.sroa.0.0.i.i.i.i.i.i, 1
  %_28.i.i.i.i.i.i = icmp eq i64 %_27.i.i.i.i.i.i, %_35.1.i.i.i.i
  br i1 %_28.i.i.i.i.i.i, label %bb9.i.i.i.i, label %bb8.i.i.i.i.i.i, !llvm.loop !205

bb9.i.i.i.i:                                      ; preds = %bb8.i.i.i.i.i.i, %middle.block, %bb17.i.i.i.i
  %_0.sroa.0.0.i.i.i.i.i.i = phi i64 [ 0, %bb17.i.i.i.i ], [ %24, %middle.block ], [ %_0.i.i.i.i.i.i.i, %bb8.i.i.i.i.i.i ]
  store <2 x i32> <i32 1, i32 24>, ptr %3, align 8, !noalias !193
  %info.sroa.5.0._22.sroa_idx.i.i.i.i = getelementptr inbounds nuw i8, ptr %3, i64 8
  store i64 %_35.1.i.i.i.i, ptr %info.sroa.5.0._22.sroa_idx.i.i.i.i, align 8, !noalias !193
  %info.sroa.6.0._22.sroa_idx.i.i.i.i = getelementptr inbounds nuw i8, ptr %3, i64 16
  store i64 %_0.sroa.0.0.i.i.i.i.i.i, ptr %info.sroa.6.0._22.sroa_idx.i.i.i.i, align 8, !noalias !193
  %_2.i.i5.i.i.i.i = atomicrmw sub ptr %7, i64 1 release, align 8, !noalias !206
  %25 = icmp eq i64 %_2.i.i5.i.i.i.i, 1
  br i1 %25, label %bb2.i.i6.i.i.i.i, label %bb11.sink.split.i.i.i.i

bb2.i.i6.i.i.i.i:                                 ; preds = %bb9.i.i.i.i
  fence acquire
; call <alloc::sync::Arc<[u64]>>::drop_slow
  call void @_RNvMsn_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcSyE9drop_slowCsiU7OkGI6hgA_10ffi_bridge(ptr noalias nofree noundef nonnull readonly align 8 dereferenceable(16) %data.i.i.i.i) #29, !noalias !193
  br label %bb11.sink.split.i.i.i.i

bb11.sink.split.i.i.i.i:                          ; preds = %bb2.i.i6.i.i.i.i, %bb9.i.i.i.i, %bb16.i.i.i.i
  %_0.sroa.0.0.ph.i.i.i.i = phi i64 [ %12, %bb16.i.i.i.i ], [ 0, %bb9.i.i.i.i ], [ 0, %bb2.i.i6.i.i.i.i ]
  call void @llvm.lifetime.end.p0(ptr nonnull %data.i.i.i.i), !noalias !193
  br label %bb7.i

catch.i.i:                                        ; preds = %bb15.i.i.i.i
  %26 = landingpad { ptr, i32 }
          catch ptr null
          filter [0 x ptr] zeroinitializer
  %27 = extractvalue { ptr, i32 } %26, 0
; invoke std::panicking::catch_unwind::cleanup
  %28 = invoke { ptr, ptr } @_RNvNvNtCs1SSuMAdGM58_3std9panicking12catch_unwind7cleanup(ptr noundef %27)
          to label %bb1 unwind label %terminate.i.i, !noalias !200

terminate.i.i:                                    ; preds = %catch.i.i
  %29 = landingpad { ptr, i32 }
          filter [0 x ptr] zeroinitializer
; call core::panicking::panic_cannot_unwind
  tail call void @_RNvNtCsjIpoRzUjyHQ_4core9panicking19panic_cannot_unwind() #25, !noalias !200
  unreachable

bb7.i:                                            ; preds = %bb11.sink.split.i.i.i.i, %bb7.i.i.i.i.i, %bb5.i.i.i.i, %start
  %_0.sroa.0.0.i.i.i.i = phi i64 [ 4294967297, %start ], [ 4294967297, %bb5.i.i.i.i ], [ 8589934593, %bb7.i.i.i.i.i ], [ %_0.sroa.0.0.ph.i.i.i.i, %bb11.sink.split.i.i.i.i ]
  %_5.sroa.0.4.extract.shift.i = lshr i64 %_0.sroa.0.0.i.i.i.i, 32
  %_5.sroa.0.4.extract.trunc.i = trunc nuw i64 %_5.sroa.0.4.extract.shift.i to i32
  %30 = trunc i64 %_0.sroa.0.0.i.i.i.i to i1
  %..i = select i1 %30, i32 %_5.sroa.0.4.extract.trunc.i, i32 0
  br label %bb1

bb1:                                              ; preds = %bb7.i, %catch.i.i
  %code.sroa.0.0.i = phi i32 [ %..i, %bb7.i ], [ 5, %catch.i.i ]
  ret i32 %code.sroa.0.0.i
}

; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: write) uwtable
define noundef range(i32 0, 3) i32 @rb_mix(i64 noundef %0, ptr noundef %1) unnamed_addr #10 personality ptr @rust_eh_personality !guid !211 {
start:
  %_18.i.i.i.i.i = ptrtoint ptr %1 to i64
  %_3.i.i.i.i.i = icmp ne ptr %1, null
  %_19.i.i.i.i.i = and i64 %_18.i.i.i.i.i, 7
  %2 = icmp eq i64 %_19.i.i.i.i.i, 0
  %or.cond.i.i.i.i.i = and i1 %_3.i.i.i.i.i, %2
  br i1 %or.cond.i.i.i.i.i, label %bb4.i.i.i.i.i, label %bb1

bb4.i.i.i.i.i:                                    ; preds = %start
  %_36.1.i.i.i.i.i = icmp ugt ptr %1, inttoptr (i64 -9 to ptr)
  br i1 %_36.1.i.i.i.i.i, label %bb1, label %bb5.i.i.i.i, !prof !23

bb5.i.i.i.i:                                      ; preds = %bb4.i.i.i.i.i
  %_18.i.i.i.i = lshr i64 %0, 29
  %_17.i.i.i.i = xor i64 %_18.i.i.i.i, %0
  %_16.i.i.i.i = mul i64 %_17.i.i.i.i, -7046029254386353131
  %_8.i.i.i.i = add i64 %_16.i.i.i.i, 2611923443488327891
  store i64 %_8.i.i.i.i, ptr %1, align 8, !noalias !212
  br label %bb1

bb1:                                              ; preds = %bb5.i.i.i.i, %bb4.i.i.i.i.i, %start
  %_0.sroa.0.0.i.i.i.i = phi i64 [ 0, %bb5.i.i.i.i ], [ 4294967297, %start ], [ 8589934593, %bb4.i.i.i.i.i ]
  %_5.sroa.0.4.extract.shift.i = lshr i64 %_0.sroa.0.0.i.i.i.i, 32
  %_5.sroa.0.4.extract.trunc.i = trunc nuw nsw i64 %_5.sroa.0.4.extract.shift.i to i32
  %3 = trunc i64 %_0.sroa.0.0.i.i.i.i to i1
  %..i = select i1 %3, i32 %_5.sroa.0.4.extract.trunc.i, i32 0
  ret i32 %..i
}

; Function Attrs: nounwind uwtable
define noundef range(i32 0, 7) i32 @rb_release(i64 noundef %0) unnamed_addr #9 personality ptr @rust_eh_personality !guid !216 {
start:
  %_16.i.i.i.i = alloca [16 x i8], align 8
  %data.i.i.i.i = alloca [16 x i8], align 8
  call void @llvm.lifetime.start.p0(ptr nonnull %data.i.i.i.i), !noalias !217
  %1 = load atomic ptr, ptr @_RNvCsiU7OkGI6hgA_10ffi_bridge8REGISTRY acquire, align 8, !noalias !217
  %_11.i.i.i.i.i.i = icmp eq ptr %1, null
  br i1 %_11.i.i.i.i.i.i, label %_RNvCsiU7OkGI6hgA_10ffi_bridge8registry.exit.i.i.i.i, label %bb8.i.i.i.i.i.i, !prof !18

bb8.i.i.i.i.i.i:                                  ; preds = %start
; invoke <std::sync::once_lock::OnceLock<std::sync::poison::mutex::Mutex<ffi_bridge::Registry>>>::initialize::<<std::sync::once_lock::OnceLock<std::sync::poison::mutex::Mutex<ffi_bridge::Registry>>>::get_or_init<ffi_bridge::registry::{closure#0}>::{closure#0}, !>
  invoke fastcc void @_RINvMNtNtCs1SSuMAdGM58_3std4sync9once_lockINtB3_8OnceLockINtNtNtB5_6poison5mutex5MutexNtCsiU7OkGI6hgA_10ffi_bridge8RegistryEE10initializeNCINvB2_11get_or_initNCNvB1o_8registry0E0zEB1o_()
          to label %_RNvCsiU7OkGI6hgA_10ffi_bridge8registry.exit.i.i.i.i unwind label %catch.i.i, !noalias !224

_RNvCsiU7OkGI6hgA_10ffi_bridge8registry.exit.i.i.i.i: ; preds = %bb8.i.i.i.i.i.i, %start
  %2 = load atomic ptr, ptr getelementptr inbounds nuw (i8, ptr @_RNvCsiU7OkGI6hgA_10ffi_bridge8REGISTRY, i64 8) acquire, align 8, !noalias !225
  %_11.i.i14.i.i.i.i = icmp eq ptr %2, null
  br i1 %_11.i.i14.i.i.i.i, label %bb7.i.i.i.i.i.i, label %_RINvMNtNtNtCs1SSuMAdGM58_3std3sys4sync8once_boxINtB3_7OnceBoxNtNtNtNtNtB7_3pal4unix4sync5mutex5MutexE11get_or_initNCNvMNtNtB5_5mutex7pthreadNtB1T_5Mutex3get0ECsiU7OkGI6hgA_10ffi_bridge.exit.i.i.i.i.i, !prof !23

bb7.i.i.i.i.i.i:                                  ; preds = %_RNvCsiU7OkGI6hgA_10ffi_bridge8registry.exit.i.i.i.i
; invoke <std::sys::sync::once_box::OnceBox<std::sys::pal::unix::sync::mutex::Mutex>>::initialize::<<std::sys::sync::mutex::pthread::Mutex>::get::{closure#0}>
  %3 = invoke fastcc noundef nonnull align 8 ptr @_RINvMNtNtNtCs1SSuMAdGM58_3std3sys4sync8once_boxINtB3_7OnceBoxNtNtNtNtNtB7_3pal4unix4sync5mutex5MutexE10initializeNCNvMNtNtB5_5mutex7pthreadNtB1S_5Mutex3get0ECsiU7OkGI6hgA_10ffi_bridge()
          to label %_RINvMNtNtNtCs1SSuMAdGM58_3std3sys4sync8once_boxINtB3_7OnceBoxNtNtNtNtNtB7_3pal4unix4sync5mutex5MutexE11get_or_initNCNvMNtNtB5_5mutex7pthreadNtB1T_5Mutex3get0ECsiU7OkGI6hgA_10ffi_bridge.exit.i.i.i.i.i unwind label %catch.i.i, !noalias !224

_RINvMNtNtNtCs1SSuMAdGM58_3std3sys4sync8once_boxINtB3_7OnceBoxNtNtNtNtNtB7_3pal4unix4sync5mutex5MutexE11get_or_initNCNvMNtNtB5_5mutex7pthreadNtB1T_5Mutex3get0ECsiU7OkGI6hgA_10ffi_bridge.exit.i.i.i.i.i: ; preds = %bb7.i.i.i.i.i.i, %_RNvCsiU7OkGI6hgA_10ffi_bridge8registry.exit.i.i.i.i
  %_0.sroa.0.0.i.i.i.i.i.i = phi ptr [ %2, %_RNvCsiU7OkGI6hgA_10ffi_bridge8registry.exit.i.i.i.i ], [ %3, %bb7.i.i.i.i.i.i ]
; invoke <std::sys::pal::unix::sync::mutex::Mutex>::lock
  invoke void @_RNvMNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutexNtB2_5Mutex4lock(ptr noundef nonnull align 8 %_0.sroa.0.0.i.i.i.i.i.i)
          to label %.noexc5.i unwind label %catch.i.i, !noalias !224

.noexc5.i:                                        ; preds = %_RINvMNtNtNtCs1SSuMAdGM58_3std3sys4sync8once_boxINtB3_7OnceBoxNtNtNtNtNtB7_3pal4unix4sync5mutex5MutexE11get_or_initNCNvMNtNtB5_5mutex7pthreadNtB1T_5Mutex3get0ECsiU7OkGI6hgA_10ffi_bridge.exit.i.i.i.i.i
  %4 = load atomic i64, ptr @_RNvNtNtCs1SSuMAdGM58_3std9panicking11panic_count18GLOBAL_PANIC_COUNT monotonic, align 8, !noalias !225
  %_7.i.i.i.i.i.i = and i64 %4, 9223372036854775807
  %5 = icmp eq i64 %_7.i.i.i.i.i.i, 0
  br i1 %5, label %_RNvMs5_NtNtNtCs1SSuMAdGM58_3std4sync6poison5mutexINtB5_5MutexNtCsiU7OkGI6hgA_10ffi_bridge8RegistryE4lockBZ_.exit.thread.i.i.i.i, label %_RNvMs5_NtNtNtCs1SSuMAdGM58_3std4sync6poison5mutexINtB5_5MutexNtCsiU7OkGI6hgA_10ffi_bridge8RegistryE4lockBZ_.exit.i.i.i.i, !prof !18

_RNvMs5_NtNtNtCs1SSuMAdGM58_3std4sync6poison5mutexINtB5_5MutexNtCsiU7OkGI6hgA_10ffi_bridge8RegistryE4lockBZ_.exit.i.i.i.i: ; preds = %.noexc5.i
; invoke std::panicking::panic_count::is_zero_slow_path
  %6 = invoke noundef zeroext i1 @_RNvNtNtCs1SSuMAdGM58_3std9panicking11panic_count17is_zero_slow_path() #29
          to label %.noexc6.i unwind label %catch.i.i, !noalias !224

.noexc6.i:                                        ; preds = %_RNvMs5_NtNtNtCs1SSuMAdGM58_3std4sync6poison5mutexINtB5_5MutexNtCsiU7OkGI6hgA_10ffi_bridge8RegistryE4lockBZ_.exit.i.i.i.i
  %7 = xor i1 %6, true
  %8 = load atomic i8, ptr getelementptr inbounds nuw (i8, ptr @_RNvCsiU7OkGI6hgA_10ffi_bridge8REGISTRY, i64 16) monotonic, align 8, !noalias !225
  %_4.not.i.i.not.i.i.i.i = icmp eq i8 %8, 0
  br i1 %_4.not.i.i.not.i.i.i.i, label %bb13.i.i.i.i, label %bb12.i.i.i.i

_RNvMs5_NtNtNtCs1SSuMAdGM58_3std4sync6poison5mutexINtB5_5MutexNtCsiU7OkGI6hgA_10ffi_bridge8RegistryE4lockBZ_.exit.thread.i.i.i.i: ; preds = %.noexc5.i
  %9 = load atomic i8, ptr getelementptr inbounds nuw (i8, ptr @_RNvCsiU7OkGI6hgA_10ffi_bridge8REGISTRY, i64 16) monotonic, align 8, !noalias !225
  %_4.not.i.i35.not.i.i.i.i = icmp eq i8 %9, 0
  br i1 %_4.not.i.i35.not.i.i.i.i, label %bb13.i.i.i.i, label %bb1.i.i.i.i.i.i.i.i

bb12.i.i.i.i:                                     ; preds = %.noexc6.i
  br i1 %6, label %bb1.i.i.i.i.i.i.i.i, label %bb6.i.i.i.i

bb1.i.i.i.i.i.i.i.i:                              ; preds = %bb12.i.i.i.i, %_RNvMs5_NtNtNtCs1SSuMAdGM58_3std4sync6poison5mutexINtB5_5MutexNtCsiU7OkGI6hgA_10ffi_bridge8RegistryE4lockBZ_.exit.thread.i.i.i.i
  %10 = load atomic i64, ptr @_RNvNtNtCs1SSuMAdGM58_3std9panicking11panic_count18GLOBAL_PANIC_COUNT monotonic, align 8, !noalias !217
  %_7.i.i.i.i.i.i.i.i = and i64 %10, 9223372036854775807
  %11 = icmp eq i64 %_7.i.i.i.i.i.i.i.i, 0
  br i1 %11, label %bb6.i.i.i.i, label %bb6.i.i.i.i.i.i.i.i, !prof !18

bb6.i.i.i.i.i.i.i.i:                              ; preds = %bb1.i.i.i.i.i.i.i.i
; invoke std::panicking::panic_count::is_zero_slow_path
  %_6.i.i.i.i.i.i.i7.i = invoke noundef zeroext i1 @_RNvNtNtCs1SSuMAdGM58_3std9panicking11panic_count17is_zero_slow_path() #29
          to label %_6.i.i.i.i.i.i.i.noexc.i unwind label %catch.i.i, !noalias !224

_6.i.i.i.i.i.i.i.noexc.i:                         ; preds = %bb6.i.i.i.i.i.i.i.i
  br i1 %_6.i.i.i.i.i.i.i7.i, label %bb6.i.i.i.i, label %bb6.sink.split.i.i.i.i

bb13.i.i.i.i:                                     ; preds = %_RNvMs5_NtNtNtCs1SSuMAdGM58_3std4sync6poison5mutexINtB5_5MutexNtCsiU7OkGI6hgA_10ffi_bridge8RegistryE4lockBZ_.exit.thread.i.i.i.i, %.noexc6.i
  %_6.sroa.0.0.off0.i.i39.i.i.i.i = phi i1 [ false, %_RNvMs5_NtNtNtCs1SSuMAdGM58_3std4sync6poison5mutexINtB5_5MutexNtCsiU7OkGI6hgA_10ffi_bridge8RegistryE4lockBZ_.exit.thread.i.i.i.i ], [ %7, %.noexc6.i ]
  %_28.val.i.i.i.i = load ptr, ptr getelementptr inbounds nuw (i8, ptr @_RNvCsiU7OkGI6hgA_10ffi_bridge8REGISTRY, i64 32), align 8, !noalias !217
  %12 = and i64 %0, 4294967295
  %13 = icmp eq i64 %12, 0
  br i1 %13, label %bb15.i.i.i.i, label %bb2.i.i.i.i.i.i

bb2.i.i.i.i.i.i:                                  ; preds = %bb13.i.i.i.i
  %_28.val13.i.i.i.i = load i64, ptr getelementptr inbounds nuw (i8, ptr @_RNvCsiU7OkGI6hgA_10ffi_bridge8REGISTRY, i64 40), align 8, !noalias !217
  %_8.i.i.i.i.i.i = add nsw i64 %12, -1
  %_21.i.i.i.i.i.i = icmp ult i64 %_8.i.i.i.i.i.i, %_28.val13.i.i.i.i
  br i1 %_21.i.i.i.i.i.i, label %bb9.i.i.i.i.i.i, label %bb15.i.i.i.i

bb9.i.i.i.i.i.i:                                  ; preds = %bb2.i.i.i.i.i.i
  call void @llvm.assume(i1 true) [ "nonnull"(ptr %_28.val.i.i.i.i) ]
  %_22.i.i.i.i.i.i = getelementptr inbounds nuw [24 x i8], ptr %_28.val.i.i.i.i, i64 %_8.i.i.i.i.i.i
  %14 = getelementptr inbounds nuw i8, ptr %_22.i.i.i.i.i.i, i64 16
  %_13.i.i.i.i.i.i = load i32, ptr %14, align 8, !noalias !228, !noundef !31
  %_15.i.i.i.i.i.i = lshr i64 %0, 32
  %_14.i.i.i.i.i.i = trunc nuw i64 %_15.i.i.i.i.i.i to i32
  %_12.not.i.i.i.i.i.i = icmp eq i32 %_13.i.i.i.i.i.i, %_14.i.i.i.i.i.i
  br i1 %_12.not.i.i.i.i.i.i, label %bb4.i.i.i.i.i.i, label %bb15.i.i.i.i

bb4.i.i.i.i.i.i:                                  ; preds = %bb9.i.i.i.i.i.i
  %15 = load ptr, ptr %_22.i.i.i.i.i.i, align 8, !noalias !228, !noundef !31
  %.not.i.i.i.i.i.i = icmp eq ptr %15, null
  br i1 %.not.i.i.i.i.i.i, label %bb15.i.i.i.i, label %bb16.i.i.i.i

bb15.i.i.i.i:                                     ; preds = %bb4.i.i.i.i.i.i, %bb9.i.i.i.i.i.i, %bb2.i.i.i.i.i.i, %bb13.i.i.i.i
  br i1 %_6.sroa.0.0.off0.i.i39.i.i.i.i, label %bb6.i.i.i.i, label %bb1.i.i.i.i.i.i.i

bb1.i.i.i.i.i.i.i:                                ; preds = %bb15.i.i.i.i
  %16 = load atomic i64, ptr @_RNvNtNtCs1SSuMAdGM58_3std9panicking11panic_count18GLOBAL_PANIC_COUNT monotonic, align 8, !noalias !217
  %_7.i.i.i.i.i.i.i = and i64 %16, 9223372036854775807
  %17 = icmp eq i64 %_7.i.i.i.i.i.i.i, 0
  br i1 %17, label %bb6.i.i.i.i, label %bb6.i.i.i.i.i.i.i, !prof !18

bb6.i.i.i.i.i.i.i:                                ; preds = %bb1.i.i.i.i.i.i.i
; invoke std::panicking::panic_count::is_zero_slow_path
  %_6.i.i.i.i.i.i8.i = invoke noundef zeroext i1 @_RNvNtNtCs1SSuMAdGM58_3std9panicking11panic_count17is_zero_slow_path() #29
          to label %_6.i.i.i.i.i.i.noexc.i unwind label %catch.i.i, !noalias !224

_6.i.i.i.i.i.i.noexc.i:                           ; preds = %bb6.i.i.i.i.i.i.i
  br i1 %_6.i.i.i.i.i.i8.i, label %bb6.i.i.i.i, label %bb6.sink.split.i.i.i.i

bb16.i.i.i.i:                                     ; preds = %bb4.i.i.i.i.i.i
  %18 = getelementptr inbounds nuw i8, ptr %_22.i.i.i.i.i.i, i64 8
  %19 = load i64, ptr %18, align 8, !noalias !233
  store ptr null, ptr %_22.i.i.i.i.i.i, align 8, !noalias !233
  store ptr %15, ptr %data.i.i.i.i, align 8, !noalias !217
  %20 = getelementptr inbounds nuw i8, ptr %data.i.i.i.i, i64 8
  store i64 %19, ptr %20, align 8, !noalias !217
  br i1 %_6.sroa.0.0.off0.i.i39.i.i.i.i, label %_RNvXsc_NtNtNtCs1SSuMAdGM58_3std4sync6poison5mutexINtB5_10MutexGuardNtCsiU7OkGI6hgA_10ffi_bridge8RegistryENtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4dropB15_.exit.i.i.i.i.i, label %bb1.i.i.i18.i.i.i.i

bb1.i.i.i18.i.i.i.i:                              ; preds = %bb16.i.i.i.i
  %21 = load atomic i64, ptr @_RNvNtNtCs1SSuMAdGM58_3std9panicking11panic_count18GLOBAL_PANIC_COUNT monotonic, align 8, !noalias !217
  %_7.i.i.i19.i.i.i.i = and i64 %21, 9223372036854775807
  %22 = icmp eq i64 %_7.i.i.i19.i.i.i.i, 0
  br i1 %22, label %_RNvXsc_NtNtNtCs1SSuMAdGM58_3std4sync6poison5mutexINtB5_10MutexGuardNtCsiU7OkGI6hgA_10ffi_bridge8RegistryENtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4dropB15_.exit.i.i.i.i.i, label %bb6.i.i.i20.i.i.i.i, !prof !18

bb6.i.i.i20.i.i.i.i:                              ; preds = %bb1.i.i.i18.i.i.i.i
; invoke std::panicking::panic_count::is_zero_slow_path
  %_6.i.i.i2123.i.i.i.i = invoke noundef zeroext i1 @_RNvNtNtCs1SSuMAdGM58_3std9panicking11panic_count17is_zero_slow_path() #29
          to label %_6.i.i.i21.noexc.i.i.i.i unwind label %bb10.i.i.i.i, !noalias !217

_6.i.i.i21.noexc.i.i.i.i:                         ; preds = %bb6.i.i.i20.i.i.i.i
  br i1 %_6.i.i.i2123.i.i.i.i, label %_RNvXsc_NtNtNtCs1SSuMAdGM58_3std4sync6poison5mutexINtB5_10MutexGuardNtCsiU7OkGI6hgA_10ffi_bridge8RegistryENtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4dropB15_.exit.i.i.i.i.i, label %bb2.i.i.i22.i.i.i.i

bb2.i.i.i22.i.i.i.i:                              ; preds = %_6.i.i.i21.noexc.i.i.i.i
  store atomic i8 1, ptr getelementptr inbounds nuw (i8, ptr @_RNvCsiU7OkGI6hgA_10ffi_bridge8REGISTRY, i64 16) monotonic, align 8, !noalias !217
  br label %_RNvXsc_NtNtNtCs1SSuMAdGM58_3std4sync6poison5mutexINtB5_10MutexGuardNtCsiU7OkGI6hgA_10ffi_bridge8RegistryENtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4dropB15_.exit.i.i.i.i.i

_RNvXsc_NtNtNtCs1SSuMAdGM58_3std4sync6poison5mutexINtB5_10MutexGuardNtCsiU7OkGI6hgA_10ffi_bridge8RegistryENtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4dropB15_.exit.i.i.i.i.i: ; preds = %bb2.i.i.i22.i.i.i.i, %_6.i.i.i21.noexc.i.i.i.i, %bb1.i.i.i18.i.i.i.i, %bb16.i.i.i.i
  %23 = load atomic ptr, ptr getelementptr inbounds nuw (i8, ptr @_RNvCsiU7OkGI6hgA_10ffi_bridge8REGISTRY, i64 8) monotonic, align 8, !noalias !217
; invoke <std::sys::pal::unix::sync::mutex::Mutex>::unlock
  invoke void @_RNvMNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutexNtB2_5Mutex6unlock(ptr noundef nonnull align 8 %23)
          to label %bb5.i.i.i.i unwind label %bb10.i.i.i.i, !noalias !217

bb5.i.i.i.i:                                      ; preds = %_RNvXsc_NtNtNtCs1SSuMAdGM58_3std4sync6poison5mutexINtB5_10MutexGuardNtCsiU7OkGI6hgA_10ffi_bridge8RegistryENtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4dropB15_.exit.i.i.i.i.i
  call void @llvm.lifetime.start.p0(ptr nonnull %_16.i.i.i.i), !noalias !217
  store ptr %15, ptr %_16.i.i.i.i, align 8, !noalias !217
  %24 = getelementptr inbounds nuw i8, ptr %_16.i.i.i.i, i64 8
  store i64 %19, ptr %24, align 8, !noalias !217
  %_2.i.i.i.i.i.i = atomicrmw sub ptr %15, i64 1 release, align 8, !noalias !234
  %25 = icmp eq i64 %_2.i.i.i.i.i.i, 1
  br i1 %25, label %bb2.i.i25.i.i.i.i, label %bb17.i.i.i.i

bb2.i.i25.i.i.i.i:                                ; preds = %bb5.i.i.i.i
  fence acquire
; call <alloc::sync::Arc<[u64]>>::drop_slow
  call void @_RNvMsn_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcSyE9drop_slowCsiU7OkGI6hgA_10ffi_bridge(ptr noalias nofree noundef nonnull readonly align 8 dereferenceable(16) %_16.i.i.i.i) #29, !noalias !217
  br label %bb17.i.i.i.i

bb17.i.i.i.i:                                     ; preds = %bb2.i.i25.i.i.i.i, %bb5.i.i.i.i
  call void @llvm.lifetime.end.p0(ptr nonnull %_16.i.i.i.i), !noalias !217
  br label %bb7.i

bb10.i.i.i.i:                                     ; preds = %_RNvXsc_NtNtNtCs1SSuMAdGM58_3std4sync6poison5mutexINtB5_10MutexGuardNtCsiU7OkGI6hgA_10ffi_bridge8RegistryENtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4dropB15_.exit.i.i.i.i.i, %bb6.i.i.i20.i.i.i.i
  %26 = landingpad { ptr, i32 }
          catch ptr null
          filter [0 x ptr] zeroinitializer
  %_2.i.i27.i.i.i.i = atomicrmw sub ptr %15, i64 1 release, align 8, !noalias !239
  %27 = icmp eq i64 %_2.i.i27.i.i.i.i, 1
  br i1 %27, label %bb2.i.i28.i.i.i.i, label %catch.i.body.i

bb2.i.i28.i.i.i.i:                                ; preds = %bb10.i.i.i.i
  fence acquire
; call <alloc::sync::Arc<[u64]>>::drop_slow
  call void @_RNvMsn_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcSyE9drop_slowCsiU7OkGI6hgA_10ffi_bridge(ptr noalias nofree noundef nonnull readonly align 8 dereferenceable(16) %data.i.i.i.i) #29, !noalias !217
  br label %catch.i.body.i

bb6.sink.split.i.i.i.i:                           ; preds = %_6.i.i.i.i.i.i.noexc.i, %_6.i.i.i.i.i.i.i.noexc.i
  %_0.sroa.4.1.ph.i.i.i.i = phi i32 [ 6, %_6.i.i.i.i.i.i.i.noexc.i ], [ 3, %_6.i.i.i.i.i.i.noexc.i ]
  store atomic i8 1, ptr getelementptr inbounds nuw (i8, ptr @_RNvCsiU7OkGI6hgA_10ffi_bridge8REGISTRY, i64 16) monotonic, align 8, !noalias !217
  br label %bb6.i.i.i.i

bb6.i.i.i.i:                                      ; preds = %bb6.sink.split.i.i.i.i, %_6.i.i.i.i.i.i.noexc.i, %bb1.i.i.i.i.i.i.i, %bb15.i.i.i.i, %_6.i.i.i.i.i.i.i.noexc.i, %bb1.i.i.i.i.i.i.i.i, %bb12.i.i.i.i
  %_0.sroa.4.1.i.i.i.i = phi i32 [ 3, %_6.i.i.i.i.i.i.noexc.i ], [ 6, %bb12.i.i.i.i ], [ 6, %bb1.i.i.i.i.i.i.i.i ], [ 6, %_6.i.i.i.i.i.i.i.noexc.i ], [ 3, %bb15.i.i.i.i ], [ 3, %bb1.i.i.i.i.i.i.i ], [ %_0.sroa.4.1.ph.i.i.i.i, %bb6.sink.split.i.i.i.i ]
  %28 = load atomic ptr, ptr getelementptr inbounds nuw (i8, ptr @_RNvCsiU7OkGI6hgA_10ffi_bridge8REGISTRY, i64 8) monotonic, align 8, !noalias !217
; invoke <std::sys::pal::unix::sync::mutex::Mutex>::unlock
  invoke void @_RNvMNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutexNtB2_5Mutex6unlock(ptr noundef nonnull align 8 %28)
          to label %bb7.i unwind label %catch.i.i, !noalias !224

catch.i.i:                                        ; preds = %bb6.i.i.i.i, %bb6.i.i.i.i.i.i.i, %bb6.i.i.i.i.i.i.i.i, %_RNvMs5_NtNtNtCs1SSuMAdGM58_3std4sync6poison5mutexINtB5_5MutexNtCsiU7OkGI6hgA_10ffi_bridge8RegistryE4lockBZ_.exit.i.i.i.i, %_RINvMNtNtNtCs1SSuMAdGM58_3std3sys4sync8once_boxINtB3_7OnceBoxNtNtNtNtNtB7_3pal4unix4sync5mutex5MutexE11get_or_initNCNvMNtNtB5_5mutex7pthreadNtB1T_5Mutex3get0ECsiU7OkGI6hgA_10ffi_bridge.exit.i.i.i.i.i, %bb7.i.i.i.i.i.i, %bb8.i.i.i.i.i.i
  %29 = landingpad { ptr, i32 }
          catch ptr null
          filter [0 x ptr] zeroinitializer
  br label %catch.i.body.i

catch.i.body.i:                                   ; preds = %catch.i.i, %bb2.i.i28.i.i.i.i, %bb10.i.i.i.i
  %eh.lpad-body.i = phi { ptr, i32 } [ %29, %catch.i.i ], [ %26, %bb2.i.i28.i.i.i.i ], [ %26, %bb10.i.i.i.i ]
  %30 = extractvalue { ptr, i32 } %eh.lpad-body.i, 0
; invoke std::panicking::catch_unwind::cleanup
  %31 = invoke { ptr, ptr } @_RNvNvNtCs1SSuMAdGM58_3std9panicking12catch_unwind7cleanup(ptr noundef %30)
          to label %bb1 unwind label %terminate.i.i, !noalias !224

terminate.i.i:                                    ; preds = %catch.i.body.i
  %32 = landingpad { ptr, i32 }
          filter [0 x ptr] zeroinitializer
; call core::panicking::panic_cannot_unwind
  tail call void @_RNvNtCsjIpoRzUjyHQ_4core9panicking19panic_cannot_unwind() #25, !noalias !224
  unreachable

bb7.i:                                            ; preds = %bb6.i.i.i.i, %bb17.i.i.i.i
  %_0.sroa.0.0.i.i.i.i = phi i32 [ 0, %bb17.i.i.i.i ], [ %_0.sroa.4.1.i.i.i.i, %bb6.i.i.i.i ]
  call void @llvm.lifetime.end.p0(ptr nonnull %data.i.i.i.i), !noalias !217
  br label %bb1

bb1:                                              ; preds = %bb7.i, %catch.i.body.i
  %code.sroa.0.0.i = phi i32 [ %_0.sroa.0.0.i.i.i.i, %bb7.i ], [ 5, %catch.i.body.i ]
  ret i32 %code.sroa.0.0.i
}

; Function Attrs: cold nounwind uwtable
define noundef i32 @rb_test_panic() unnamed_addr #0 personality ptr @rust_eh_personality !guid !244 {
start:
; call ffi_bridge::boundary::<ffi_bridge::rb_test_panic::{closure#0}>
  %_0 = tail call fastcc noundef i32 @_RINvCsiU7OkGI6hgA_10ffi_bridge8boundaryNCNvB2_13rb_test_panic0EB2_()
  ret i32 %_0
}

; Function Attrs: nofree norecurse nosync nounwind memory(argmem: readwrite, inaccessiblemem: readwrite) uwtable
define noundef range(i32 0, 3) i32 @rb_transform(ptr noundef %0, ptr noundef %1, i64 noundef %2) unnamed_addr #11 personality ptr @rust_eh_personality !guid !245 {
start:
  %_29.i.i.i.i = icmp ugt i64 %2, 16777216
  br i1 %_29.i.i.i.i, label %bb1, label %bb12.i.i.i.i

bb12.i.i.i.i:                                     ; preds = %start
  %3 = icmp eq i64 %2, 0
  br i1 %3, label %bb1, label %bb2.i.i.i.i.i

bb2.i.i.i.i.i:                                    ; preds = %bb12.i.i.i.i
  %_18.i.i.i.i.i = ptrtoint ptr %0 to i64
  %_3.i.i.i.i.i = icmp ne ptr %0, null
  %_19.i.i.i.i.i = and i64 %_18.i.i.i.i.i, 7
  %4 = icmp eq i64 %_19.i.i.i.i.i, 0
  %or.cond.i.i.i.i.i = and i1 %_3.i.i.i.i.i, %4
  br i1 %or.cond.i.i.i.i.i, label %bb4.i.i.i.i.i, label %bb1

bb4.i.i.i.i.i:                                    ; preds = %bb2.i.i.i.i.i
  %5 = shl nuw nsw i64 %2, 3
  %_36.0.i.i.i.i.i = add i64 %5, %_18.i.i.i.i.i
  %_36.1.i.i.i.i.i = icmp ult i64 %_36.0.i.i.i.i.i, %_18.i.i.i.i.i
  br i1 %_36.1.i.i.i.i.i, label %bb1, label %bb2.i10.i.i.i.i, !prof !23

bb2.i10.i.i.i.i:                                  ; preds = %bb4.i.i.i.i.i
  %_18.i11.i.i.i.i = ptrtoint ptr %1 to i64
  %_3.i12.i.i.i.i = icmp ne ptr %1, null
  %_19.i13.i.i.i.i = and i64 %_18.i11.i.i.i.i, 7
  %6 = icmp eq i64 %_19.i13.i.i.i.i, 0
  %or.cond.i14.i.i.i.i = and i1 %_3.i12.i.i.i.i, %6
  br i1 %or.cond.i14.i.i.i.i, label %bb4.i16.i.i.i.i, label %bb1

bb4.i16.i.i.i.i:                                  ; preds = %bb2.i10.i.i.i.i
  %_36.0.i17.i.i.i.i = add i64 %5, %_18.i11.i.i.i.i
  %_36.1.i18.i.i.i.i = icmp ult i64 %_36.0.i17.i.i.i.i, %_18.i11.i.i.i.i
  br i1 %_36.1.i18.i.i.i.i, label %bb1, label %bb16.i.i.i.i, !prof !23

bb16.i.i.i.i:                                     ; preds = %bb4.i16.i.i.i.i
  %_48.i.i.i.i = icmp ugt i64 %_36.0.i17.i.i.i.i, %_18.i.i.i.i.i
  %_49.i.i.i.i = icmp ugt i64 %_36.0.i.i.i.i.i, %_18.i11.i.i.i.i
  %or.cond.i.i.i.i = and i1 %_49.i.i.i.i, %_48.i.i.i.i
  br i1 %or.cond.i.i.i.i, label %bb1, label %bb4.i.i.i.i

bb4.i.i.i.i:                                      ; preds = %bb16.i.i.i.i
  tail call void @llvm.experimental.noalias.scope.decl(metadata !246)
  tail call void @llvm.experimental.noalias.scope.decl(metadata !249)
  %min.iters.check = icmp ult i64 %2, 4
  br i1 %min.iters.check, label %bb6.i.i.i.i.i.preheader, label %vector.ph

vector.ph:                                        ; preds = %bb4.i.i.i.i
  %n.vec = and i64 %2, 33554428
  br label %vector.body

vector.body:                                      ; preds = %vector.body, %vector.ph
  %index = phi i64 [ 0, %vector.ph ], [ %index.next, %vector.body ]
  %7 = or disjoint i64 %index, 1
  %8 = or disjoint i64 %index, 2
  %9 = or disjoint i64 %index, 3
  %10 = getelementptr inbounds nuw [8 x i8], ptr %0, i64 %index
  %11 = getelementptr inbounds nuw [8 x i8], ptr %0, i64 %7
  %12 = getelementptr inbounds nuw [8 x i8], ptr %0, i64 %8
  %13 = getelementptr inbounds nuw [8 x i8], ptr %0, i64 %9
  %14 = getelementptr inbounds nuw [8 x i8], ptr %1, i64 %index
  %15 = getelementptr inbounds nuw [8 x i8], ptr %1, i64 %7
  %16 = getelementptr inbounds nuw [8 x i8], ptr %1, i64 %8
  %17 = getelementptr inbounds nuw [8 x i8], ptr %1, i64 %9
  %18 = load i64, ptr %10, align 8, !alias.scope !246, !noalias !251, !noundef !31
  %19 = load i64, ptr %11, align 8, !alias.scope !246, !noalias !251, !noundef !31
  %20 = load i64, ptr %12, align 8, !alias.scope !246, !noalias !251, !noundef !31
  %21 = load i64, ptr %13, align 8, !alias.scope !246, !noalias !251, !noundef !31
  %22 = lshr i64 %18, 29
  %23 = lshr i64 %19, 29
  %24 = lshr i64 %20, 29
  %25 = lshr i64 %21, 29
  %26 = xor i64 %22, %18
  %27 = xor i64 %23, %19
  %28 = xor i64 %24, %20
  %29 = xor i64 %25, %21
  %30 = mul i64 %26, -7046029254386353131
  %31 = mul i64 %27, -7046029254386353131
  %32 = mul i64 %28, -7046029254386353131
  %33 = mul i64 %29, -7046029254386353131
  %34 = add i64 %30, 2611923443488327891
  %35 = add i64 %31, 2611923443488327891
  %36 = add i64 %32, 2611923443488327891
  %37 = add i64 %33, 2611923443488327891
  store i64 %34, ptr %14, align 8, !alias.scope !249, !noalias !258
  store i64 %35, ptr %15, align 8, !alias.scope !249, !noalias !258
  store i64 %36, ptr %16, align 8, !alias.scope !249, !noalias !258
  store i64 %37, ptr %17, align 8, !alias.scope !249, !noalias !258
  %index.next = add nuw i64 %index, 4
  %38 = icmp eq i64 %index.next, %n.vec
  br i1 %38, label %middle.block, label %vector.body, !llvm.loop !259

middle.block:                                     ; preds = %vector.body
  %cmp.n = icmp eq i64 %2, %n.vec
  br i1 %cmp.n, label %bb1, label %bb6.i.i.i.i.i.preheader

bb6.i.i.i.i.i.preheader:                          ; preds = %bb4.i.i.i.i, %middle.block
  %iter.sroa.8.06.i.i.i.i.i.ph = phi i64 [ 0, %bb4.i.i.i.i ], [ %n.vec, %middle.block ]
  br label %bb6.i.i.i.i.i

bb6.i.i.i.i.i:                                    ; preds = %bb6.i.i.i.i.i.preheader, %bb6.i.i.i.i.i
  %iter.sroa.8.06.i.i.i.i.i = phi i64 [ %39, %bb6.i.i.i.i.i ], [ %iter.sroa.8.06.i.i.i.i.i.ph, %bb6.i.i.i.i.i.preheader ]
  %39 = add nuw nsw i64 %iter.sroa.8.06.i.i.i.i.i, 1
  %_3.i.i.i.i.i.i.i = getelementptr inbounds nuw [8 x i8], ptr %0, i64 %iter.sroa.8.06.i.i.i.i.i
  %_3.i1.i.i.i.i.i.i = getelementptr inbounds nuw [8 x i8], ptr %1, i64 %iter.sroa.8.06.i.i.i.i.i
  %_15.i.i.i.i.i = load i64, ptr %_3.i.i.i.i.i.i.i, align 8, !alias.scope !246, !noalias !251, !noundef !31
  %_26.i.i.i.i.i = lshr i64 %_15.i.i.i.i.i, 29
  %_25.i.i.i.i.i = xor i64 %_26.i.i.i.i.i, %_15.i.i.i.i.i
  %_24.i.i.i.i.i = mul i64 %_25.i.i.i.i.i, -7046029254386353131
  %_14.i.i.i.i.i = add i64 %_24.i.i.i.i.i, 2611923443488327891
  store i64 %_14.i.i.i.i.i, ptr %_3.i1.i.i.i.i.i.i, align 8, !alias.scope !249, !noalias !258
  %exitcond.not.i.i.i.i.i = icmp eq i64 %39, %2
  br i1 %exitcond.not.i.i.i.i.i, label %bb1, label %bb6.i.i.i.i.i, !llvm.loop !260

bb1:                                              ; preds = %bb6.i.i.i.i.i, %middle.block, %bb16.i.i.i.i, %bb4.i16.i.i.i.i, %bb2.i10.i.i.i.i, %bb4.i.i.i.i.i, %bb2.i.i.i.i.i, %bb12.i.i.i.i, %start
  %_0.sroa.0.0.i.i.i.i = phi i64 [ 8589934593, %bb4.i.i.i.i.i ], [ 8589934593, %bb4.i16.i.i.i.i ], [ 8589934593, %start ], [ 4294967297, %bb16.i.i.i.i ], [ 0, %bb12.i.i.i.i ], [ 4294967297, %bb2.i.i.i.i.i ], [ 4294967297, %bb2.i10.i.i.i.i ], [ 0, %middle.block ], [ 0, %bb6.i.i.i.i.i ]
  %_5.sroa.0.4.extract.shift.i = lshr i64 %_0.sroa.0.0.i.i.i.i, 32
  %_5.sroa.0.4.extract.trunc.i = trunc nuw nsw i64 %_5.sroa.0.4.extract.shift.i to i32
  %40 = trunc i64 %_0.sroa.0.0.i.i.i.i to i1
  %..i = select i1 %40, i32 %_5.sroa.0.4.extract.trunc.i, i32 0
  ret i32 %..i
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(ptr captures(none)) #12

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(ptr captures(none)) #12

; Function Attrs: mustprogress nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none)
declare { i64, i1 } @llvm.umul.with.overflow.i64(i64, i64) #13

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(inaccessiblemem: write)
declare void @llvm.assume(i1 noundef) #14

; Function Attrs: nounwind uwtable
declare noundef range(i32 0, 10) i32 @rust_eh_personality(i32 noundef, i32 noundef, i64 noundef, ptr noundef, ptr noundef) unnamed_addr #9

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.memcpy.p0.p0.i64(ptr noalias writeonly captures(none), ptr noalias readonly captures(none), i64, i1 immarg) #12

; Function Attrs: cold noreturn nounwind memory(inaccessiblemem: write)
declare void @llvm.trap() #15

; <std::sys::sync::once::queue::Once>::call
; Function Attrs: cold uwtable
declare void @_RNvMNtNtNtNtCs1SSuMAdGM58_3std3sys4sync4once5queueNtB2_4Once4call(ptr noundef nonnull align 8, i1 noundef zeroext, ptr noundef nonnull, ptr noalias nofree noundef readonly align 8 captures(address, read_provenance) dereferenceable(40), ptr noalias nofree noundef readonly align 8 captures(address, read_provenance) dereferenceable(24)) unnamed_addr #2

; core::panicking::panic_fmt
; Function Attrs: cold noinline noreturn uwtable
declare void @_RNvNtCsjIpoRzUjyHQ_4core9panicking9panic_fmt(ptr noundef nonnull, ptr noundef nonnull, ptr noalias nofree noundef readonly align 8 captures(address, read_provenance) dereferenceable(24)) unnamed_addr #16

; alloc::sync::arcinner_layout_for_value_layout
; Function Attrs: uwtable
declare { i64, i64 } @_RNvNtCs6zY7rJBZy9D_5alloc4sync32arcinner_layout_for_value_layout(i64 noundef range(i64 1, -9223372036854775807), i64 noundef) unnamed_addr #3

; alloc::alloc::handle_alloc_error
; Function Attrs: cold minsize noreturn optsize uwtable
declare void @_RNvNtCs6zY7rJBZy9D_5alloc5alloc18handle_alloc_error(i64 noundef range(i64 1, -9223372036854775807), i64 noundef) unnamed_addr #17

; core::panicking::panic_in_cleanup
; Function Attrs: cold minsize noinline noreturn nounwind optsize uwtable
declare void @_RNvNtCsjIpoRzUjyHQ_4core9panicking16panic_in_cleanup() unnamed_addr #18

; <std::sys::pal::unix::sync::mutex::Mutex as core::ops::drop::Drop>::drop
; Function Attrs: uwtable
declare void @_RNvXs2_NtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutexNtB5_5MutexNtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4drop(ptr noundef nonnull align 8) unnamed_addr #3

; alloc::raw_vec::handle_error
; Function Attrs: cold minsize noreturn optsize uwtable
declare void @_RNvNtCs6zY7rJBZy9D_5alloc7raw_vec12handle_error(i64 noundef range(i64 0, -9223372036854775807), i64) unnamed_addr #17

; std::panicking::catch_unwind::cleanup
; Function Attrs: cold minsize optsize uwtable
declare { ptr, ptr } @_RNvNvNtCs1SSuMAdGM58_3std9panicking12catch_unwind7cleanup(ptr noundef) unnamed_addr #1

; core::panicking::panic_cannot_unwind
; Function Attrs: cold minsize noinline noreturn nounwind optsize uwtable
declare void @_RNvNtCsjIpoRzUjyHQ_4core9panicking19panic_cannot_unwind() unnamed_addr #18

; core::option::unwrap_failed
; Function Attrs: cold noinline noreturn uwtable
declare void @_RNvNtCsjIpoRzUjyHQ_4core6option13unwrap_failed(ptr noalias nofree noundef readonly align 8 captures(address, read_provenance) dereferenceable(24)) unnamed_addr #16

; <std::sys::pal::unix::sync::mutex::Mutex>::init
; Function Attrs: uwtable
declare void @_RNvMNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutexNtB2_5Mutex4init(ptr noundef nonnull align 8) unnamed_addr #3

; std::panicking::panic_count::is_zero_slow_path
; Function Attrs: cold noinline uwtable
declare noundef zeroext i1 @_RNvNtNtCs1SSuMAdGM58_3std9panicking11panic_count17is_zero_slow_path() unnamed_addr #7

; __rustc::__rust_dealloc
; Function Attrs: nounwind allockind("free") uwtable
declare void @_RNvCsdtSMxSA38aw_7___rustc14___rust_dealloc(ptr allocptr noundef nonnull captures(address), i64 noundef, i64 noundef range(i64 1, -9223372036854775807)) unnamed_addr #19

; __rustc::__rust_realloc
; Function Attrs: nounwind allockind("realloc,aligned") allocsize(3) uwtable
declare noalias noundef ptr @_RNvCsdtSMxSA38aw_7___rustc14___rust_realloc(ptr allocptr noundef nonnull, i64 noundef, i64 allocalign noundef range(i64 1, -9223372036854775807), i64 noundef) unnamed_addr #20

; __rustc::__rust_no_alloc_shim_is_unstable_v2
; Function Attrs: nounwind uwtable
declare void @_RNvCsdtSMxSA38aw_7___rustc35___rust_no_alloc_shim_is_unstable_v2() unnamed_addr #9

; __rustc::__rust_alloc
; Function Attrs: nounwind allockind("alloc,uninitialized,aligned") allocsize(0) uwtable
declare noalias noundef ptr @_RNvCsdtSMxSA38aw_7___rustc12___rust_alloc(i64 noundef, i64 allocalign noundef range(i64 1, -9223372036854775807)) unnamed_addr #21

; <std::sys::pal::unix::sync::mutex::Mutex>::lock
; Function Attrs: uwtable
declare void @_RNvMNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutexNtB2_5Mutex4lock(ptr noundef nonnull align 8) unnamed_addr #3

; <std::sys::pal::unix::sync::mutex::Mutex>::unlock
; Function Attrs: uwtable
declare void @_RNvMNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutexNtB2_5Mutex6unlock(ptr noundef nonnull align 8) unnamed_addr #3

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(inaccessiblemem: readwrite)
declare void @llvm.experimental.noalias.scope.decl(metadata) #22

; Function Attrs: nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none)
declare i64 @llvm.umax.i64(i64, i64) #23

; Function Attrs: nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none)
declare i64 @llvm.vector.reduce.add.v2i64(<2 x i64>) #23

attributes #0 = { cold nounwind uwtable "frame-pointer"="non-leaf" "probe-stack"="inline-asm" "target-cpu"="apple-m1" }
attributes #1 = { cold minsize optsize uwtable "frame-pointer"="non-leaf" "probe-stack"="inline-asm" "target-cpu"="apple-m1" }
attributes #2 = { cold uwtable "frame-pointer"="non-leaf" "probe-stack"="inline-asm" "target-cpu"="apple-m1" }
attributes #3 = { uwtable "frame-pointer"="non-leaf" "probe-stack"="inline-asm" "target-cpu"="apple-m1" }
attributes #4 = { inlinehint uwtable "frame-pointer"="non-leaf" "probe-stack"="inline-asm" "target-cpu"="apple-m1" }
attributes #5 = { nofree norecurse nosync nounwind memory(argmem: read) uwtable "frame-pointer"="non-leaf" "probe-stack"="inline-asm" "target-cpu"="apple-m1" }
attributes #6 = { nofree norecurse nosync nounwind memory(argmem: readwrite) uwtable "frame-pointer"="non-leaf" "probe-stack"="inline-asm" "target-cpu"="apple-m1" }
attributes #7 = { cold noinline uwtable "frame-pointer"="non-leaf" "probe-stack"="inline-asm" "target-cpu"="apple-m1" }
attributes #8 = { noinline nounwind uwtable "frame-pointer"="non-leaf" "probe-stack"="inline-asm" "target-cpu"="apple-m1" }
attributes #9 = { nounwind uwtable "frame-pointer"="non-leaf" "probe-stack"="inline-asm" "target-cpu"="apple-m1" }
attributes #10 = { mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: write) uwtable "frame-pointer"="non-leaf" "probe-stack"="inline-asm" "target-cpu"="apple-m1" }
attributes #11 = { nofree norecurse nosync nounwind memory(argmem: readwrite, inaccessiblemem: readwrite) uwtable "frame-pointer"="non-leaf" "probe-stack"="inline-asm" "target-cpu"="apple-m1" }
attributes #12 = { mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #13 = { mustprogress nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none) }
attributes #14 = { mustprogress nocallback nofree nosync nounwind willreturn memory(inaccessiblemem: write) }
attributes #15 = { cold noreturn nounwind memory(inaccessiblemem: write) }
attributes #16 = { cold noinline noreturn uwtable "frame-pointer"="non-leaf" "probe-stack"="inline-asm" "target-cpu"="apple-m1" }
attributes #17 = { cold minsize noreturn optsize uwtable "frame-pointer"="non-leaf" "probe-stack"="inline-asm" "target-cpu"="apple-m1" }
attributes #18 = { cold minsize noinline noreturn nounwind optsize uwtable "frame-pointer"="non-leaf" "probe-stack"="inline-asm" "target-cpu"="apple-m1" }
attributes #19 = { nounwind allockind("free") uwtable "alloc-family"="__rust_alloc" "frame-pointer"="non-leaf" "probe-stack"="inline-asm" "target-cpu"="apple-m1" }
attributes #20 = { nounwind allockind("realloc,aligned") allocsize(3) uwtable "alloc-family"="__rust_alloc" "frame-pointer"="non-leaf" "probe-stack"="inline-asm" "target-cpu"="apple-m1" }
attributes #21 = { nounwind allockind("alloc,uninitialized,aligned") allocsize(0) uwtable "alloc-family"="__rust_alloc" "alloc-variant-zeroed"="_RNvCsdtSMxSA38aw_7___rustc19___rust_alloc_zeroed" "frame-pointer"="non-leaf" "probe-stack"="inline-asm" "target-cpu"="apple-m1" }
attributes #22 = { nocallback nofree nosync nounwind willreturn memory(inaccessiblemem: readwrite) }
attributes #23 = { nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none) }
attributes #24 = { noinline noreturn }
attributes #25 = { cold noreturn nounwind }
attributes #26 = { nounwind }
attributes #27 = { noreturn }
attributes #28 = { cold }
attributes #29 = { noinline }

!llvm.module.flags = !{!9, !10, !11}
!llvm.ident = !{!12}

!0 = !{i64 1238521805045543377}
!1 = !{i64 6264944518710460841}
!2 = !{i64 2617400137515529756}
!3 = !{i64 -209708935422557988}
!4 = !{i64 -3440466877653963266}
!5 = !{i64 441396050938598226}
!6 = !{i64 -8573542955490525963}
!7 = !{i64 6126332949426277119}
!8 = !{i64 8100854743502146909}
!9 = !{i32 8, !"PIC Level", i32 2}
!10 = !{i32 7, !"uwtable", i32 2}
!11 = !{i32 7, !"frame-pointer", i32 1}
!12 = !{!"rustc version 1.99.0 (b940084d7 2026-09-28)"}
!13 = !{i64 3603018913014308309}
!14 = !{i64 -7061795108386987482}
!15 = !{!16}
!16 = distinct !{!16, !17, !"_RINvMs0_NtNtCs1SSuMAdGM58_3std4sync4onceNtB6_4Once15call_once_forceNCINvMNtB8_9once_lockINtB19_8OnceLockINtNtNtB8_6poison5mutex5MutexNtCsiU7OkGI6hgA_10ffi_bridge8RegistryEE10initializeNCINvB18_11get_or_initNCNvB29_8registry0E0zE0EB29_: %f.1"}
!17 = distinct !{!17, !"_RINvMs0_NtNtCs1SSuMAdGM58_3std4sync4onceNtB6_4Once15call_once_forceNCINvMNtB8_9once_lockINtB19_8OnceLockINtNtNtB8_6poison5mutex5MutexNtCsiU7OkGI6hgA_10ffi_bridge8RegistryEE10initializeNCINvB18_11get_or_initNCNvB29_8registry0E0zE0EB29_"}
!18 = !{!"branch_weights", !"expected", i32 2000, i32 1}
!19 = !{i64 8585144792126672439}
!20 = !{!21}
!21 = distinct !{!21, !22, !"_RNvMNtCs6zY7rJBZy9D_5alloc5boxedINtB2_3BoxNtNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutex5MutexE3newCsiU7OkGI6hgA_10ffi_bridge: %x"}
!22 = distinct !{!22, !"_RNvMNtCs6zY7rJBZy9D_5alloc5boxedINtB2_3BoxNtNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutex5MutexE3newCsiU7OkGI6hgA_10ffi_bridge"}
!23 = !{!"branch_weights", !"expected", i32 1, i32 2000}
!24 = !{i64 -2504017507291313290}
!25 = !{i64 5964258023377933716}
!26 = !{i64 -3209306538694661332}
!27 = !{!28}
!28 = distinct !{!28, !29, !"_RNvMs5_NtCs6zY7rJBZy9D_5alloc7raw_vecNtB5_11RawVecInner14grow_amortizedCsiU7OkGI6hgA_10ffi_bridge: %self"}
!29 = distinct !{!29, !"_RNvMs5_NtCs6zY7rJBZy9D_5alloc7raw_vecNtB5_11RawVecInner14grow_amortizedCsiU7OkGI6hgA_10ffi_bridge"}
!30 = !{i64 0, i64 -9223372036854775808}
!31 = !{}
!32 = !{i64 0, i64 2}
!33 = !{i64 0, i64 -9223372036854775807}
!34 = !{i64 -1464713829488847132}
!35 = !{i64 8}
!36 = !{i64 3592362500853653547}
!37 = !{!38}
!38 = distinct !{!38, !39, !"_RNvYNCINvMs0_NtNtCs1SSuMAdGM58_3std4sync4onceNtBb_4Once15call_once_forceNCINvMNtBd_9once_lockINtB1e_8OnceLockINtNtNtBd_6poison5mutex5MutexNtCsiU7OkGI6hgA_10ffi_bridge8RegistryEE10initializeNCINvB1d_11get_or_initNCNvB2e_8registry0E0zE0E0INtNtNtCsjIpoRzUjyHQ_4core3ops8function6FnOnceTRNtBb_9OnceStateEE9call_onceB2e_: argument 0"}
!39 = distinct !{!39, !"_RNvYNCINvMs0_NtNtCs1SSuMAdGM58_3std4sync4onceNtBb_4Once15call_once_forceNCINvMNtBd_9once_lockINtB1e_8OnceLockINtNtNtBd_6poison5mutex5MutexNtCsiU7OkGI6hgA_10ffi_bridge8RegistryEE10initializeNCINvB1d_11get_or_initNCNvB2e_8registry0E0zE0E0INtNtNtCsjIpoRzUjyHQ_4core3ops8function6FnOnceTRNtBb_9OnceStateEE9call_onceB2e_"}
!40 = !{!41}
!41 = distinct !{!41, !42, !"_RNCINvMs0_NtNtCs1SSuMAdGM58_3std4sync4onceNtB8_4Once15call_once_forceNCINvMNtBa_9once_lockINtB1b_8OnceLockINtNtNtBa_6poison5mutex5MutexNtCsiU7OkGI6hgA_10ffi_bridge8RegistryEE10initializeNCINvB1a_11get_or_initNCNvB2b_8registry0E0zE0E0B2b_: %_1"}
!42 = distinct !{!42, !"_RNCINvMs0_NtNtCs1SSuMAdGM58_3std4sync4onceNtB8_4Once15call_once_forceNCINvMNtBa_9once_lockINtB1b_8OnceLockINtNtNtBa_6poison5mutex5MutexNtCsiU7OkGI6hgA_10ffi_bridge8RegistryEE10initializeNCINvB1a_11get_or_initNCNvB2b_8registry0E0zE0E0B2b_"}
!43 = !{!41, !38}
!44 = !{i64 826306718063783164}
!45 = distinct !{!45, !46, !47}
!46 = !{!"llvm.loop.isvectorized", i32 1}
!47 = !{!"llvm.loop.unroll.runtime.disable"}
!48 = distinct !{!48, !47, !46}
!49 = !{i64 3843886674886437190}
!50 = !{!51}
!51 = distinct !{!51, !52, !"_RNvMs5_NtNtNtCs1SSuMAdGM58_3std4sync6poison5mutexINtB5_5MutexNtCsiU7OkGI6hgA_10ffi_bridge8RegistryE4lockBZ_: %_0"}
!52 = distinct !{!52, !"_RNvMs5_NtNtNtCs1SSuMAdGM58_3std4sync6poison5mutexINtB5_5MutexNtCsiU7OkGI6hgA_10ffi_bridge8RegistryE4lockBZ_"}
!53 = !{!54}
!54 = distinct !{!54, !55, !"_RNvMCsiU7OkGI6hgA_10ffi_bridgeNtB2_8Registry8snapshot: %_0"}
!55 = distinct !{!55, !"_RNvMCsiU7OkGI6hgA_10ffi_bridgeNtB2_8Registry8snapshot"}
!56 = !{!57, !54}
!57 = distinct !{!57, !58, !"_RNvMCsiU7OkGI6hgA_10ffi_bridgeNtB2_8Registry6locate: %_0"}
!58 = distinct !{!58, !"_RNvMCsiU7OkGI6hgA_10ffi_bridgeNtB2_8Registry6locate"}
!59 = !{i64 -8974051105480975872}
!60 = distinct !{!60, !46, !47}
!61 = distinct !{!61, !46}
!62 = !{i64 4986664735836755837}
!63 = !{!64, !66}
!64 = distinct !{!64, !65, !"_RNCINvNvNtNtNtNtCsjIpoRzUjyHQ_4core4iter6traits8iterator8Iterator4find5checkTjQNtCsiU7OkGI6hgA_10ffi_bridge4SlotENCNvMB1h_NtB1h_8Registry6insert0E0B1h_: argument 0"}
!65 = distinct !{!65, !"_RNCINvNvNtNtNtNtCsjIpoRzUjyHQ_4core4iter6traits8iterator8Iterator4find5checkTjQNtCsiU7OkGI6hgA_10ffi_bridge4SlotENCNvMB1h_NtB1h_8Registry6insert0E0B1h_"}
!66 = distinct !{!66, !67, !"_RNCINvNvXs_NtNtNtCsjIpoRzUjyHQ_4core4iter8adapters9enumerateINtB9_9EnumeratepENtNtNtBd_6traits8iterator8Iterator8try_fold9enumerateQNtCsiU7OkGI6hgA_10ffi_bridge4SlotuINtNtNtBf_3ops12control_flow11ControlFlowTjB25_EENCINvNvB1e_4find5checkB3j_NCNvMB28_NtB28_8Registry6insert0E0E0B28_: %item"}
!67 = distinct !{!67, !"_RNCINvNvXs_NtNtNtCsjIpoRzUjyHQ_4core4iter8adapters9enumerateINtB9_9EnumeratepENtNtNtBd_6traits8iterator8Iterator8try_fold9enumerateQNtCsiU7OkGI6hgA_10ffi_bridge4SlotuINtNtNtBf_3ops12control_flow11ControlFlowTjB25_EENCINvNvB1e_4find5checkB3j_NCNvMB28_NtB28_8Registry6insert0E0E0B28_"}
!68 = !{!69, !71}
!69 = distinct !{!69, !70, !"_RINvYINtNtNtCsjIpoRzUjyHQ_4core5slice4iter7IterMutNtCsiU7OkGI6hgA_10ffi_bridge4SlotENtNtNtNtBa_4iter6traits8iterator8Iterator8try_folduNCINvNvXs_NtNtB1q_8adapters9enumerateINtB2j_9EnumeratepEB1k_8try_fold9enumerateQBM_uINtNtNtBa_3ops12control_flow11ControlFlowTjB3q_EENCINvNvB1k_4find5checkB4a_NCNvMBO_NtBO_8Registry6insert0E0E0B3v_EBO_: %self"}
!70 = distinct !{!70, !"_RINvYINtNtNtCsjIpoRzUjyHQ_4core5slice4iter7IterMutNtCsiU7OkGI6hgA_10ffi_bridge4SlotENtNtNtNtBa_4iter6traits8iterator8Iterator8try_folduNCINvNvXs_NtNtB1q_8adapters9enumerateINtB2j_9EnumeratepEB1k_8try_fold9enumerateQBM_uINtNtNtBa_3ops12control_flow11ControlFlowTjB3q_EENCINvNvB1k_4find5checkB4a_NCNvMBO_NtBO_8Registry6insert0E0E0B3v_EBO_"}
!71 = distinct !{!71, !70, !"_RINvYINtNtNtCsjIpoRzUjyHQ_4core5slice4iter7IterMutNtCsiU7OkGI6hgA_10ffi_bridge4SlotENtNtNtNtBa_4iter6traits8iterator8Iterator8try_folduNCINvNvXs_NtNtB1q_8adapters9enumerateINtB2j_9EnumeratepEB1k_8try_fold9enumerateQBM_uINtNtNtBa_3ops12control_flow11ControlFlowTjB3q_EENCINvNvB1k_4find5checkB4a_NCNvMBO_NtBO_8Registry6insert0E0E0B3v_EBO_: argument 1"}
!72 = !{!73}
!73 = distinct !{!73, !74, !"_RNvMs2_NtCs6zY7rJBZy9D_5alloc7raw_vecNtB5_11RawVecInner11try_reserveCsiU7OkGI6hgA_10ffi_bridge: %self"}
!74 = distinct !{!74, !"_RNvMs2_NtCs6zY7rJBZy9D_5alloc7raw_vecNtB5_11RawVecInner11try_reserveCsiU7OkGI6hgA_10ffi_bridge"}
!75 = !{!76}
!76 = distinct !{!76, !77, !"_RNvMs5_NtCs6zY7rJBZy9D_5alloc7raw_vecNtB5_11RawVecInner14grow_amortizedCsiU7OkGI6hgA_10ffi_bridge: %self"}
!77 = distinct !{!77, !"_RNvMs5_NtCs6zY7rJBZy9D_5alloc7raw_vecNtB5_11RawVecInner14grow_amortizedCsiU7OkGI6hgA_10ffi_bridge"}
!78 = !{!76, !73}
!79 = !{!80, !82}
!80 = distinct !{!80, !81, !"_RNvXsE_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcSyENtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4dropCsiU7OkGI6hgA_10ffi_bridge: %self"}
!81 = distinct !{!81, !"_RNvXsE_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcSyENtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4dropCsiU7OkGI6hgA_10ffi_bridge"}
!82 = distinct !{!82, !83, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc4sync3ArcSyEECsiU7OkGI6hgA_10ffi_bridge: %_1"}
!83 = distinct !{!83, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc4sync3ArcSyEECsiU7OkGI6hgA_10ffi_bridge"}
!84 = !{!85}
!85 = distinct !{!85, !86, !"_RNvMsG_NtCs6zY7rJBZy9D_5alloc3vecINtB5_3VecNtCsiU7OkGI6hgA_10ffi_bridge4SlotE8push_mutBH_: %self"}
!86 = distinct !{!86, !"_RNvMsG_NtCs6zY7rJBZy9D_5alloc3vecINtB5_3VecNtCsiU7OkGI6hgA_10ffi_bridge4SlotE8push_mutBH_"}
!87 = !{!88}
!88 = distinct !{!88, !86, !"_RNvMsG_NtCs6zY7rJBZy9D_5alloc3vecINtB5_3VecNtCsiU7OkGI6hgA_10ffi_bridge4SlotE8push_mutBH_: %value"}
!89 = !{!90, !92, !94, !96, !85, !88}
!90 = distinct !{!90, !91, !"_RNvXsE_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcSyENtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4dropCsiU7OkGI6hgA_10ffi_bridge: %self"}
!91 = distinct !{!91, !"_RNvXsE_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcSyENtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4dropCsiU7OkGI6hgA_10ffi_bridge"}
!92 = distinct !{!92, !93, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc4sync3ArcSyEECsiU7OkGI6hgA_10ffi_bridge: %_1"}
!93 = distinct !{!93, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc4sync3ArcSyEECsiU7OkGI6hgA_10ffi_bridge"}
!94 = distinct !{!94, !95, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtB4_6option6OptionINtNtCs6zY7rJBZy9D_5alloc4sync3ArcSyEEECsiU7OkGI6hgA_10ffi_bridge: %_1"}
!95 = distinct !{!95, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtB4_6option6OptionINtNtCs6zY7rJBZy9D_5alloc4sync3ArcSyEEECsiU7OkGI6hgA_10ffi_bridge"}
!96 = distinct !{!96, !97, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtCsiU7OkGI6hgA_10ffi_bridge4SlotEBD_: %_1"}
!97 = distinct !{!97, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtCsiU7OkGI6hgA_10ffi_bridge4SlotEBD_"}
!98 = !{i64 -5503307874653506279}
!99 = !{i64 -7880599005645785427}
!100 = !{!101}
!101 = distinct !{!101, !102, !"_RNvMs5_NtCs6zY7rJBZy9D_5alloc7raw_vecNtB5_11RawVecInner14grow_amortizedCsiU7OkGI6hgA_10ffi_bridge: %self"}
!102 = distinct !{!102, !"_RNvMs5_NtCs6zY7rJBZy9D_5alloc7raw_vecNtB5_11RawVecInner14grow_amortizedCsiU7OkGI6hgA_10ffi_bridge"}
!103 = !{i64 4589936443195139389}
!104 = !{!"branch_weights", i32 2002, i32 2000}
!105 = !{i64 -5382030890327426383}
!106 = !{!107}
!107 = distinct !{!107, !108, !"_RNvMs_NtCs6zY7rJBZy9D_5alloc3vecINtB4_3VecyE7reserveCsiU7OkGI6hgA_10ffi_bridge: %self"}
!108 = distinct !{!108, !"_RNvMs_NtCs6zY7rJBZy9D_5alloc3vecINtB4_3VecyE7reserveCsiU7OkGI6hgA_10ffi_bridge"}
!109 = !{i64 -1512931417580804656}
!110 = !{i64 -6517870436595723012}
!111 = !{!112, !114, !116}
!112 = distinct !{!112, !113, !"_RNCNvCsiU7OkGI6hgA_10ffi_bridge7rb_copy0B3_: %_1"}
!113 = distinct !{!113, !"_RNCNvCsiU7OkGI6hgA_10ffi_bridge7rb_copy0B3_"}
!114 = distinct !{!114, !115, !"_RNvXsn_NtNtCsjIpoRzUjyHQ_4core5panic11unwind_safeINtB5_16AssertUnwindSafeNCNvCsiU7OkGI6hgA_10ffi_bridge7rb_copy0EINtNtNtB9_3ops8function6FnOnceuE9call_onceB1d_: %self"}
!115 = distinct !{!115, !"_RNvXsn_NtNtCsjIpoRzUjyHQ_4core5panic11unwind_safeINtB5_16AssertUnwindSafeNCNvCsiU7OkGI6hgA_10ffi_bridge7rb_copy0EINtNtNtB9_3ops8function6FnOnceuE9call_onceB1d_"}
!116 = distinct !{!116, !117, !"_RINvCsiU7OkGI6hgA_10ffi_bridge8boundaryNCNvB2_7rb_copy0EB2_: %f"}
!117 = distinct !{!117, !"_RINvCsiU7OkGI6hgA_10ffi_bridge8boundaryNCNvB2_7rb_copy0EB2_"}
!118 = !{!116}
!119 = !{!120, !122, !112, !114, !116}
!120 = distinct !{!120, !121, !"_RNvXsE_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcSyENtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4dropCsiU7OkGI6hgA_10ffi_bridge: %self"}
!121 = distinct !{!121, !"_RNvXsE_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcSyENtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4dropCsiU7OkGI6hgA_10ffi_bridge"}
!122 = distinct !{!122, !123, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc4sync3ArcSyEECsiU7OkGI6hgA_10ffi_bridge: %_1"}
!123 = distinct !{!123, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc4sync3ArcSyEECsiU7OkGI6hgA_10ffi_bridge"}
!124 = !{!125, !127, !112, !114, !116}
!125 = distinct !{!125, !126, !"_RNvXsE_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcSyENtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4dropCsiU7OkGI6hgA_10ffi_bridge: %self"}
!126 = distinct !{!126, !"_RNvXsE_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcSyENtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4dropCsiU7OkGI6hgA_10ffi_bridge"}
!127 = distinct !{!127, !128, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc4sync3ArcSyEECsiU7OkGI6hgA_10ffi_bridge: %_1"}
!128 = distinct !{!128, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc4sync3ArcSyEECsiU7OkGI6hgA_10ffi_bridge"}
!129 = !{i64 -6217019108990794061}
!130 = !{!131, !133}
!131 = distinct !{!131, !132, !"_RNvXsn_NtNtCsjIpoRzUjyHQ_4core5panic11unwind_safeINtB5_16AssertUnwindSafeNCNvCsiU7OkGI6hgA_10ffi_bridge14rb_create_copy0EINtNtNtB9_3ops8function6FnOnceuE9call_onceB1d_: %self"}
!132 = distinct !{!132, !"_RNvXsn_NtNtCsjIpoRzUjyHQ_4core5panic11unwind_safeINtB5_16AssertUnwindSafeNCNvCsiU7OkGI6hgA_10ffi_bridge14rb_create_copy0EINtNtNtB9_3ops8function6FnOnceuE9call_onceB1d_"}
!133 = distinct !{!133, !134, !"_RINvCsiU7OkGI6hgA_10ffi_bridge8boundaryNCNvB2_14rb_create_copy0EB2_: %f"}
!134 = distinct !{!134, !"_RINvCsiU7OkGI6hgA_10ffi_bridge8boundaryNCNvB2_14rb_create_copy0EB2_"}
!135 = !{!136, !131, !133}
!136 = distinct !{!136, !137, !"_RNCNvCsiU7OkGI6hgA_10ffi_bridge14rb_create_copy0B3_: %_1"}
!137 = distinct !{!137, !"_RNCNvCsiU7OkGI6hgA_10ffi_bridge14rb_create_copy0B3_"}
!138 = !{!139, !136, !131, !133}
!139 = distinct !{!139, !140, !"_RNvMs5_NtNtNtCs1SSuMAdGM58_3std4sync6poison5mutexINtB5_5MutexNtCsiU7OkGI6hgA_10ffi_bridge8RegistryE4lockBZ_: %_0"}
!140 = distinct !{!140, !"_RNvMs5_NtNtNtCs1SSuMAdGM58_3std4sync6poison5mutexINtB5_5MutexNtCsiU7OkGI6hgA_10ffi_bridge8RegistryE4lockBZ_"}
!141 = !{!142}
!142 = distinct !{!142, !143, !"_RNvXs1c_NtCs6zY7rJBZy9D_5alloc4syncINtB6_3ArcSyEINtNtCsjIpoRzUjyHQ_4core7convert4FromINtNtB8_3vec3VecyEE4fromCsiU7OkGI6hgA_10ffi_bridge: %v"}
!143 = distinct !{!143, !"_RNvXs1c_NtCs6zY7rJBZy9D_5alloc4syncINtB6_3ArcSyEINtNtCsjIpoRzUjyHQ_4core7convert4FromINtNtB8_3vec3VecyEE4fromCsiU7OkGI6hgA_10ffi_bridge"}
!144 = !{!136}
!145 = !{!142, !136, !131, !133}
!146 = !{i32 0, i32 2}
!147 = !{!133}
!148 = !{i64 -9122793877129815186}
!149 = !{!150, !152, !154}
!150 = distinct !{!150, !151, !"_RNCNvCsiU7OkGI6hgA_10ffi_bridge11rb_generate0B3_: %_1"}
!151 = distinct !{!151, !"_RNCNvCsiU7OkGI6hgA_10ffi_bridge11rb_generate0B3_"}
!152 = distinct !{!152, !153, !"_RNvXsn_NtNtCsjIpoRzUjyHQ_4core5panic11unwind_safeINtB5_16AssertUnwindSafeNCNvCsiU7OkGI6hgA_10ffi_bridge11rb_generate0EINtNtNtB9_3ops8function6FnOnceuE9call_onceB1d_: %self"}
!153 = distinct !{!153, !"_RNvXsn_NtNtCsjIpoRzUjyHQ_4core5panic11unwind_safeINtB5_16AssertUnwindSafeNCNvCsiU7OkGI6hgA_10ffi_bridge11rb_generate0EINtNtNtB9_3ops8function6FnOnceuE9call_onceB1d_"}
!154 = distinct !{!154, !155, !"_RINvCsiU7OkGI6hgA_10ffi_bridge8boundaryNCNvB2_11rb_generate0EB2_: %f"}
!155 = distinct !{!155, !"_RINvCsiU7OkGI6hgA_10ffi_bridge8boundaryNCNvB2_11rb_generate0EB2_"}
!156 = !{!157}
!157 = distinct !{!157, !158, !"_RNvMs2_NtCs6zY7rJBZy9D_5alloc7raw_vecNtB5_11RawVecInner17try_reserve_exactCsiU7OkGI6hgA_10ffi_bridge: %self"}
!158 = distinct !{!158, !"_RNvMs2_NtCs6zY7rJBZy9D_5alloc7raw_vecNtB5_11RawVecInner17try_reserve_exactCsiU7OkGI6hgA_10ffi_bridge"}
!159 = !{!160, !162}
!160 = distinct !{!160, !161, !"_RNvMs_NtCs6zY7rJBZy9D_5alloc3vecINtB4_3VecyE7reserveCsiU7OkGI6hgA_10ffi_bridge: %self"}
!161 = distinct !{!161, !"_RNvMs_NtCs6zY7rJBZy9D_5alloc3vecINtB4_3VecyE7reserveCsiU7OkGI6hgA_10ffi_bridge"}
!162 = distinct !{!162, !163, !"_RINvMsk_NtCs6zY7rJBZy9D_5alloc3vecINtB6_3VecyE14extend_trustedINtNtNtNtCsjIpoRzUjyHQ_4core4iter8adapters3map3MapINtNtNtB17_3ops5range5RangejENCNCNvCsiU7OkGI6hgA_10ffi_bridge11rb_generate0s_0EEB2l_: %self"}
!163 = distinct !{!163, !"_RINvMsk_NtCs6zY7rJBZy9D_5alloc3vecINtB6_3VecyE14extend_trustedINtNtNtNtCsjIpoRzUjyHQ_4core4iter8adapters3map3MapINtNtNtB17_3ops5range5RangejENCNCNvCsiU7OkGI6hgA_10ffi_bridge11rb_generate0s_0EEB2l_"}
!164 = !{!165, !150, !152, !154}
!165 = distinct !{!165, !163, !"_RINvMsk_NtCs6zY7rJBZy9D_5alloc3vecINtB6_3VecyE14extend_trustedINtNtNtNtCsjIpoRzUjyHQ_4core4iter8adapters3map3MapINtNtNtB17_3ops5range5RangejENCNCNvCsiU7OkGI6hgA_10ffi_bridge11rb_generate0s_0EEB2l_: %iterator"}
!166 = !{!162}
!167 = !{!168, !170, !172, !174, !176, !178, !179, !181, !162, !165, !150, !152, !154}
!168 = distinct !{!168, !169, !"_RNCINvMsk_NtCs6zY7rJBZy9D_5alloc3vecINtB8_3VecyE14extend_trustedINtNtNtNtCsjIpoRzUjyHQ_4core4iter8adapters3map3MapINtNtNtB19_3ops5range5RangejENCNCNvCsiU7OkGI6hgA_10ffi_bridge11rb_generate0s_0EE0B2n_: %_1"}
!169 = distinct !{!169, !"_RNCINvMsk_NtCs6zY7rJBZy9D_5alloc3vecINtB8_3VecyE14extend_trustedINtNtNtNtCsjIpoRzUjyHQ_4core4iter8adapters3map3MapINtNtNtB19_3ops5range5RangejENCNCNvCsiU7OkGI6hgA_10ffi_bridge11rb_generate0s_0EE0B2n_"}
!170 = distinct !{!170, !171, !"_RNCINvNvNtNtNtNtCsjIpoRzUjyHQ_4core4iter6traits8iterator8Iterator8for_each4callyNCINvMsk_NtCs6zY7rJBZy9D_5alloc3vecINtB1p_3VecyE14extend_trustedINtNtNtBc_8adapters3map3MapINtNtNtBe_3ops5range5RangejENCNCNvCsiU7OkGI6hgA_10ffi_bridge11rb_generate0s_0EE0E0B3h_: %_1"}
!171 = distinct !{!171, !"_RNCINvNvNtNtNtNtCsjIpoRzUjyHQ_4core4iter6traits8iterator8Iterator8for_each4callyNCINvMsk_NtCs6zY7rJBZy9D_5alloc3vecINtB1p_3VecyE14extend_trustedINtNtNtBc_8adapters3map3MapINtNtNtBe_3ops5range5RangejENCNCNvCsiU7OkGI6hgA_10ffi_bridge11rb_generate0s_0EE0E0B3h_"}
!172 = distinct !{!172, !173, !"_RNCINvNtNtNtCsjIpoRzUjyHQ_4core4iter8adapters3map8map_foldjyuNCNCNvCsiU7OkGI6hgA_10ffi_bridge11rb_generate0s_0NCINvNvNtNtNtB8_6traits8iterator8Iterator8for_each4callyNCINvMsk_NtCs6zY7rJBZy9D_5alloc3vecINtB2N_3VecyE14extend_trustedINtB4_3MapINtNtNtBa_3ops5range5RangejEBX_EE0E0E0B13_: %_1"}
!173 = distinct !{!173, !"_RNCINvNtNtNtCsjIpoRzUjyHQ_4core4iter8adapters3map8map_foldjyuNCNCNvCsiU7OkGI6hgA_10ffi_bridge11rb_generate0s_0NCINvNvNtNtNtB8_6traits8iterator8Iterator8for_each4callyNCINvMsk_NtCs6zY7rJBZy9D_5alloc3vecINtB2N_3VecyE14extend_trustedINtB4_3MapINtNtNtBa_3ops5range5RangejEBX_EE0E0E0B13_"}
!174 = distinct !{!174, !175, !"_RINvYINtNtNtCsjIpoRzUjyHQ_4core3ops5range5RangejENtNtNtNtBa_4iter6traits8iterator8Iterator4folduNCINvNtNtBR_8adapters3map8map_foldjyuNCNCNvCsiU7OkGI6hgA_10ffi_bridge11rb_generate0s_0NCINvNvBL_8for_each4callyNCINvMsk_NtCs6zY7rJBZy9D_5alloc3vecINtB3s_3VecyE14extend_trustedINtB1B_3MapB3_B27_EE0E0E0EB2d_: %f"}
!175 = distinct !{!175, !"_RINvYINtNtNtCsjIpoRzUjyHQ_4core3ops5range5RangejENtNtNtNtBa_4iter6traits8iterator8Iterator4folduNCINvNtNtBR_8adapters3map8map_foldjyuNCNCNvCsiU7OkGI6hgA_10ffi_bridge11rb_generate0s_0NCINvNvBL_8for_each4callyNCINvMsk_NtCs6zY7rJBZy9D_5alloc3vecINtB3s_3VecyE14extend_trustedINtB1B_3MapB3_B27_EE0E0E0EB2d_"}
!176 = distinct !{!176, !177, !"_RINvXs0_NtNtNtCsjIpoRzUjyHQ_4core4iter8adapters3mapINtB6_3MapINtNtNtBc_3ops5range5RangejENCNCNvCsiU7OkGI6hgA_10ffi_bridge11rb_generate0s_0ENtNtNtBa_6traits8iterator8Iterator4folduNCINvNvB2d_8for_each4callyNCINvMsk_NtCs6zY7rJBZy9D_5alloc3vecINtB3q_3VecyE14extend_trustedBN_E0E0EB1v_: %self"}
!177 = distinct !{!177, !"_RINvXs0_NtNtNtCsjIpoRzUjyHQ_4core4iter8adapters3mapINtB6_3MapINtNtNtBc_3ops5range5RangejENCNCNvCsiU7OkGI6hgA_10ffi_bridge11rb_generate0s_0ENtNtNtBa_6traits8iterator8Iterator4folduNCINvNvB2d_8for_each4callyNCINvMsk_NtCs6zY7rJBZy9D_5alloc3vecINtB3q_3VecyE14extend_trustedBN_E0E0EB1v_"}
!178 = distinct !{!178, !177, !"_RINvXs0_NtNtNtCsjIpoRzUjyHQ_4core4iter8adapters3mapINtB6_3MapINtNtNtBc_3ops5range5RangejENCNCNvCsiU7OkGI6hgA_10ffi_bridge11rb_generate0s_0ENtNtNtBa_6traits8iterator8Iterator4folduNCINvNvB2d_8for_each4callyNCINvMsk_NtCs6zY7rJBZy9D_5alloc3vecINtB3q_3VecyE14extend_trustedBN_E0E0EB1v_: %g"}
!179 = distinct !{!179, !180, !"_RINvYINtNtNtNtCsjIpoRzUjyHQ_4core4iter8adapters3map3MapINtNtNtBc_3ops5range5RangejENCNCNvCsiU7OkGI6hgA_10ffi_bridge11rb_generate0s_0ENtNtNtBa_6traits8iterator8Iterator8for_eachNCINvMsk_NtCs6zY7rJBZy9D_5alloc3vecINtB2X_3VecyE14extend_trustedB3_E0EB1p_: %self"}
!180 = distinct !{!180, !"_RINvYINtNtNtNtCsjIpoRzUjyHQ_4core4iter8adapters3map3MapINtNtNtBc_3ops5range5RangejENCNCNvCsiU7OkGI6hgA_10ffi_bridge11rb_generate0s_0ENtNtNtBa_6traits8iterator8Iterator8for_eachNCINvMsk_NtCs6zY7rJBZy9D_5alloc3vecINtB2X_3VecyE14extend_trustedB3_E0EB1p_"}
!181 = distinct !{!181, !180, !"_RINvYINtNtNtNtCsjIpoRzUjyHQ_4core4iter8adapters3map3MapINtNtNtBc_3ops5range5RangejENCNCNvCsiU7OkGI6hgA_10ffi_bridge11rb_generate0s_0ENtNtNtBa_6traits8iterator8Iterator8for_eachNCINvMsk_NtCs6zY7rJBZy9D_5alloc3vecINtB2X_3VecyE14extend_trustedB3_E0EB1p_: %f"}
!182 = distinct !{!182, !46, !47}
!183 = distinct !{!183, !46}
!184 = !{!174, !176, !178, !179, !181, !165, !150, !152, !154}
!185 = !{!186, !150, !152, !154}
!186 = distinct !{!186, !187, !"_RNvMs5_NtNtNtCs1SSuMAdGM58_3std4sync6poison5mutexINtB5_5MutexNtCsiU7OkGI6hgA_10ffi_bridge8RegistryE4lockBZ_: %_0"}
!187 = distinct !{!187, !"_RNvMs5_NtNtNtCs1SSuMAdGM58_3std4sync6poison5mutexINtB5_5MutexNtCsiU7OkGI6hgA_10ffi_bridge8RegistryE4lockBZ_"}
!188 = !{!189, !150, !152, !154}
!189 = distinct !{!189, !190, !"_RNvXs1c_NtCs6zY7rJBZy9D_5alloc4syncINtB6_3ArcSyEINtNtCsjIpoRzUjyHQ_4core7convert4FromINtNtB8_3vec3VecyEE4fromCsiU7OkGI6hgA_10ffi_bridge: %v"}
!190 = distinct !{!190, !"_RNvXs1c_NtCs6zY7rJBZy9D_5alloc4syncINtB6_3ArcSyEINtNtCsjIpoRzUjyHQ_4core7convert4FromINtNtB8_3vec3VecyEE4fromCsiU7OkGI6hgA_10ffi_bridge"}
!191 = !{!154}
!192 = !{i64 1127281073065169769}
!193 = !{!194, !196, !198}
!194 = distinct !{!194, !195, !"_RNCNvCsiU7OkGI6hgA_10ffi_bridge7rb_info0B3_: %_1"}
!195 = distinct !{!195, !"_RNCNvCsiU7OkGI6hgA_10ffi_bridge7rb_info0B3_"}
!196 = distinct !{!196, !197, !"_RNvXsn_NtNtCsjIpoRzUjyHQ_4core5panic11unwind_safeINtB5_16AssertUnwindSafeNCNvCsiU7OkGI6hgA_10ffi_bridge7rb_info0EINtNtNtB9_3ops8function6FnOnceuE9call_onceB1d_: %self"}
!197 = distinct !{!197, !"_RNvXsn_NtNtCsjIpoRzUjyHQ_4core5panic11unwind_safeINtB5_16AssertUnwindSafeNCNvCsiU7OkGI6hgA_10ffi_bridge7rb_info0EINtNtNtB9_3ops8function6FnOnceuE9call_onceB1d_"}
!198 = distinct !{!198, !199, !"_RINvCsiU7OkGI6hgA_10ffi_bridge8boundaryNCNvB2_7rb_info0EB2_: %f"}
!199 = distinct !{!199, !"_RINvCsiU7OkGI6hgA_10ffi_bridge8boundaryNCNvB2_7rb_info0EB2_"}
!200 = !{!198}
!201 = !{!202}
!202 = distinct !{!202, !203, !"_RNvCsiU7OkGI6hgA_10ffi_bridge8checksum: %values.0"}
!203 = distinct !{!203, !"_RNvCsiU7OkGI6hgA_10ffi_bridge8checksum"}
!204 = distinct !{!204, !46, !47}
!205 = distinct !{!205, !47, !46}
!206 = !{!207, !209, !194, !196, !198}
!207 = distinct !{!207, !208, !"_RNvXsE_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcSyENtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4dropCsiU7OkGI6hgA_10ffi_bridge: %self"}
!208 = distinct !{!208, !"_RNvXsE_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcSyENtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4dropCsiU7OkGI6hgA_10ffi_bridge"}
!209 = distinct !{!209, !210, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc4sync3ArcSyEECsiU7OkGI6hgA_10ffi_bridge: %_1"}
!210 = distinct !{!210, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc4sync3ArcSyEECsiU7OkGI6hgA_10ffi_bridge"}
!211 = !{i64 4735782033797325415}
!212 = !{!213, !215}
!213 = distinct !{!213, !214, !"_RINvCsiU7OkGI6hgA_10ffi_bridge8boundaryNCNvB2_6rb_mix0EB2_: %f.0"}
!214 = distinct !{!214, !"_RINvCsiU7OkGI6hgA_10ffi_bridge8boundaryNCNvB2_6rb_mix0EB2_"}
!215 = distinct !{!215, !214, !"_RINvCsiU7OkGI6hgA_10ffi_bridge8boundaryNCNvB2_6rb_mix0EB2_: %f.1"}
!216 = !{i64 -4432672931204003160}
!217 = !{!218, !220, !222}
!218 = distinct !{!218, !219, !"_RNCNvCsiU7OkGI6hgA_10ffi_bridge10rb_release0B3_: %_1"}
!219 = distinct !{!219, !"_RNCNvCsiU7OkGI6hgA_10ffi_bridge10rb_release0B3_"}
!220 = distinct !{!220, !221, !"_RNvXsn_NtNtCsjIpoRzUjyHQ_4core5panic11unwind_safeINtB5_16AssertUnwindSafeNCNvCsiU7OkGI6hgA_10ffi_bridge10rb_release0EINtNtNtB9_3ops8function6FnOnceuE9call_onceB1d_: %self"}
!221 = distinct !{!221, !"_RNvXsn_NtNtCsjIpoRzUjyHQ_4core5panic11unwind_safeINtB5_16AssertUnwindSafeNCNvCsiU7OkGI6hgA_10ffi_bridge10rb_release0EINtNtNtB9_3ops8function6FnOnceuE9call_onceB1d_"}
!222 = distinct !{!222, !223, !"_RINvCsiU7OkGI6hgA_10ffi_bridge8boundaryNCNvB2_10rb_release0EB2_: %f"}
!223 = distinct !{!223, !"_RINvCsiU7OkGI6hgA_10ffi_bridge8boundaryNCNvB2_10rb_release0EB2_"}
!224 = !{!222}
!225 = !{!226, !218, !220, !222}
!226 = distinct !{!226, !227, !"_RNvMs5_NtNtNtCs1SSuMAdGM58_3std4sync6poison5mutexINtB5_5MutexNtCsiU7OkGI6hgA_10ffi_bridge8RegistryE4lockBZ_: %_0"}
!227 = distinct !{!227, !"_RNvMs5_NtNtNtCs1SSuMAdGM58_3std4sync6poison5mutexINtB5_5MutexNtCsiU7OkGI6hgA_10ffi_bridge8RegistryE4lockBZ_"}
!228 = !{!229, !231, !218, !220, !222}
!229 = distinct !{!229, !230, !"_RNvMCsiU7OkGI6hgA_10ffi_bridgeNtB2_8Registry6locate: %_0"}
!230 = distinct !{!230, !"_RNvMCsiU7OkGI6hgA_10ffi_bridgeNtB2_8Registry6locate"}
!231 = distinct !{!231, !232, !"_RNvMCsiU7OkGI6hgA_10ffi_bridgeNtB2_8Registry7release: %_0"}
!232 = distinct !{!232, !"_RNvMCsiU7OkGI6hgA_10ffi_bridgeNtB2_8Registry7release"}
!233 = !{!231, !218, !220, !222}
!234 = !{!235, !237, !218, !220, !222}
!235 = distinct !{!235, !236, !"_RNvXsE_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcSyENtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4dropCsiU7OkGI6hgA_10ffi_bridge: %self"}
!236 = distinct !{!236, !"_RNvXsE_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcSyENtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4dropCsiU7OkGI6hgA_10ffi_bridge"}
!237 = distinct !{!237, !238, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc4sync3ArcSyEECsiU7OkGI6hgA_10ffi_bridge: %_1"}
!238 = distinct !{!238, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc4sync3ArcSyEECsiU7OkGI6hgA_10ffi_bridge"}
!239 = !{!240, !242, !218, !220, !222}
!240 = distinct !{!240, !241, !"_RNvXsE_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcSyENtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4dropCsiU7OkGI6hgA_10ffi_bridge: %self"}
!241 = distinct !{!241, !"_RNvXsE_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcSyENtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4dropCsiU7OkGI6hgA_10ffi_bridge"}
!242 = distinct !{!242, !243, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc4sync3ArcSyEECsiU7OkGI6hgA_10ffi_bridge: %_1"}
!243 = distinct !{!243, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc4sync3ArcSyEECsiU7OkGI6hgA_10ffi_bridge"}
!244 = !{i64 3548491319780755943}
!245 = !{i64 7196239634006412568}
!246 = !{!247}
!247 = distinct !{!247, !248, !"_RNvCsiU7OkGI6hgA_10ffi_bridge9transform: %input.0"}
!248 = distinct !{!248, !"_RNvCsiU7OkGI6hgA_10ffi_bridge9transform"}
!249 = !{!250}
!250 = distinct !{!250, !248, !"_RNvCsiU7OkGI6hgA_10ffi_bridge9transform: %output.0"}
!251 = !{!250, !252, !254, !256}
!252 = distinct !{!252, !253, !"_RNCNvCsiU7OkGI6hgA_10ffi_bridge12rb_transform0B3_: %_1"}
!253 = distinct !{!253, !"_RNCNvCsiU7OkGI6hgA_10ffi_bridge12rb_transform0B3_"}
!254 = distinct !{!254, !255, !"_RNvXsn_NtNtCsjIpoRzUjyHQ_4core5panic11unwind_safeINtB5_16AssertUnwindSafeNCNvCsiU7OkGI6hgA_10ffi_bridge12rb_transform0EINtNtNtB9_3ops8function6FnOnceuE9call_onceB1d_: %self"}
!255 = distinct !{!255, !"_RNvXsn_NtNtCsjIpoRzUjyHQ_4core5panic11unwind_safeINtB5_16AssertUnwindSafeNCNvCsiU7OkGI6hgA_10ffi_bridge12rb_transform0EINtNtNtB9_3ops8function6FnOnceuE9call_onceB1d_"}
!256 = distinct !{!256, !257, !"_RINvCsiU7OkGI6hgA_10ffi_bridge8boundaryNCNvB2_12rb_transform0EB2_: %f"}
!257 = distinct !{!257, !"_RINvCsiU7OkGI6hgA_10ffi_bridge8boundaryNCNvB2_12rb_transform0EB2_"}
!258 = !{!247, !252, !254, !256}
!259 = distinct !{!259, !46, !47}
!260 = distinct !{!260, !46}
