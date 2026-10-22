; ModuleID = 'runtime_lab.3fa11a97c2f4d693-cgu.0'
source_filename = "runtime_lab.3fa11a97c2f4d693-cgu.0"
target datalayout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx11.0.0"

%"core::sync::atomic::Atomic<usize>" = type { %"core::cell::UnsafeCell<core::sync::atomic::private::Align8<usize>>" }
%"core::cell::UnsafeCell<core::sync::atomic::private::Align8<usize>>" = type { %"core::sync::atomic::private::Align8<usize>" }
%"core::sync::atomic::private::Align8<usize>" = type { i64 }

@vtable.0 = private unnamed_addr constant <{ [24 x i8], ptr }> <{ [24 x i8] c"\00\00\00\00\00\00\00\00\08\00\00\00\00\00\00\00\08\00\00\00\00\00\00\00", ptr @_RNvXs1g_NtCsjIpoRzUjyHQ_4core3fmtRINtNtB8_6option6OptionINtNtNtB8_3ptr8non_null7NonNullNtNtNtNtCs3EIJ1qnJmKW_5tokio7runtime4task4core6HeaderEENtB6_5Debug3fmtCs5sHeypWcCKR_11runtime_lab }>, align 8, !guid !0
@anon.e8ae8404cb89b4ab1223a5eab00e71d3.0 = private unnamed_addr constant [64 x i8] c"\A7\AB\AA2\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00", align 8, !guid !1
@alloc_8821e7adf2aaedbbe7385d67b31be780 = private unnamed_addr constant [22 x i8] c"capture mutex poisoned", align 1, !guid !2
@alloc_466e6e10d4d5a95679ab35d1156aa54e = private unnamed_addr constant [11 x i8] c"src/lib.rs\00", align 1, !guid !3
@alloc_76a4682140362797ca7b20487d943f78 = private unnamed_addr constant <{ ptr, [16 x i8] }> <{ ptr @alloc_466e6e10d4d5a95679ab35d1156aa54e, [16 x i8] c"\0A\00\00\00\00\00\00\00\0E\00\00\00\0A\00\00\00" }>, align 8, !guid !4
@alloc_80e4d5a6503ea68c559c0291c1b805b6 = private unnamed_addr constant [28 x i8] c"invalid version/flags/length", align 1, !guid !5
@_RNvNtNtCs1SSuMAdGM58_3std9panicking11panic_count18GLOBAL_PANIC_COUNT = external local_unnamed_addr global %"core::sync::atomic::Atomic<usize>"
@alloc_37d2e53432a03a1f90b3e7253015eaf9 = private unnamed_addr constant [4 x i8] c"None", align 1, !guid !6
@vtable.2 = private unnamed_addr constant <{ [24 x i8], ptr }> <{ [24 x i8] c"\00\00\00\00\00\00\00\00\08\00\00\00\00\00\00\00\08\00\00\00\00\00\00\00", ptr @_RNvXs1g_NtCsjIpoRzUjyHQ_4core3fmtRINtNtNtB8_3ptr8non_null7NonNullNtNtNtNtCs3EIJ1qnJmKW_5tokio7runtime4task4core6HeaderENtB6_5Debug3fmtCs5sHeypWcCKR_11runtime_lab }>, align 8, !guid !7
@alloc_9535bf4c204f3eb9b19ec2c83e446e52 = private unnamed_addr constant [4 x i8] c"Some", align 1, !guid !8

; <std::sys::sync::once_box::OnceBox<std::sys::pal::unix::sync::mutex::Mutex>>::initialize::<<std::sys::sync::mutex::pthread::Mutex>::get::{closure#0}>
; Function Attrs: cold uwtable
define internal fastcc noundef nonnull align 8 ptr @_RINvMNtNtNtCs1SSuMAdGM58_3std3sys4sync8once_boxINtB3_7OnceBoxNtNtNtNtNtB7_3pal4unix4sync5mutex5MutexE10initializeNCNvMNtNtB5_5mutex7pthreadNtB1S_5Mutex3get0ECs5sHeypWcCKR_11runtime_lab(ptr nofree noundef nonnull align 8 captures(none) %self) unnamed_addr #0 personality ptr @rust_eh_personality !dbg !17 !guid !26 {
start:
  %x.i = alloca [64 x i8], align 8
  call void @llvm.lifetime.start.p0(ptr nonnull %x.i), !dbg !27
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 8 dereferenceable(64) %x.i, ptr noundef nonnull align 8 dereferenceable(64) @anon.e8ae8404cb89b4ab1223a5eab00e71d3.0, i64 64, i1 false), !dbg !35
; call __rustc::__rust_no_alloc_shim_is_unstable_v2
  tail call void @_RNvCsdtSMxSA38aw_7___rustc35___rust_no_alloc_shim_is_unstable_v2() #14, !dbg !44, !noalias !68
; call __rustc::__rust_alloc
  %0 = tail call noundef align 8 dereferenceable_or_null(64) ptr @_RNvCsdtSMxSA38aw_7___rustc12___rust_alloc(i64 noundef 64, i64 noundef 8) #14, !dbg !71, !noalias !68
  %1 = icmp eq ptr %0, null, !dbg !72
  br i1 %1, label %bb2.i1.i, label %_RNvMNtCs6zY7rJBZy9D_5alloc5boxedINtB2_3BoxNtNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutex5MutexE3newCs5sHeypWcCKR_11runtime_lab.exit.i, !dbg !73, !prof !74

bb2.i1.i:                                         ; preds = %start
; invoke alloc::alloc::handle_alloc_error
  invoke void @_RNvNtCs6zY7rJBZy9D_5alloc5alloc18handle_alloc_error(i64 noundef 8, i64 noundef 64) #15
          to label %.noexc.i unwind label %cleanup.i.i, !dbg !75

.noexc.i:                                         ; preds = %bb2.i1.i
  unreachable, !dbg !75

cleanup.i.i:                                      ; preds = %bb2.i1.i
  %2 = landingpad { ptr, i32 }
          cleanup
; invoke <std::sys::pal::unix::sync::mutex::Mutex as core::ops::drop::Drop>::drop
  invoke void @_RNvXs2_NtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutexNtB5_5MutexNtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4drop(ptr noundef nonnull align 8 dereferenceable(64) %x.i)
          to label %common.resume unwind label %terminate.i.i, !dbg !76

terminate.i.i:                                    ; preds = %cleanup.i.i
  %3 = landingpad { ptr, i32 }
          filter [0 x ptr] zeroinitializer
; call core::panicking::panic_in_cleanup
  call void @_RNvNtCsjIpoRzUjyHQ_4core9panicking16panic_in_cleanup() #16, !dbg !82
  unreachable, !dbg !82

common.resume:                                    ; preds = %cleanup.i.i, %cleanup.i, %bb2.i
  %common.resume.op = phi { ptr, i32 } [ %9, %bb2.i ], [ %2, %cleanup.i.i ], [ %4, %cleanup.i ]
  resume { ptr, i32 } %common.resume.op, !dbg !83

_RNvMNtCs6zY7rJBZy9D_5alloc5boxedINtB2_3BoxNtNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutex5MutexE3newCs5sHeypWcCKR_11runtime_lab.exit.i: ; preds = %start
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 8 dereferenceable(64) %0, ptr noundef nonnull align 8 dereferenceable(64) @anon.e8ae8404cb89b4ab1223a5eab00e71d3.0, i64 64, i1 false), !dbg !84
  call void @llvm.lifetime.end.p0(ptr nonnull %x.i), !dbg !86
; invoke <std::sys::pal::unix::sync::mutex::Mutex>::init
  invoke void @_RNvMNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutexNtB2_5Mutex4init(ptr noundef nonnull align 8 %0)
          to label %_RNCNvMNtNtNtNtCs1SSuMAdGM58_3std3sys4sync5mutex7pthreadNtB4_5Mutex3get0Cs5sHeypWcCKR_11runtime_lab.exit unwind label %cleanup.i, !dbg !87

cleanup.i:                                        ; preds = %_RNvMNtCs6zY7rJBZy9D_5alloc5boxedINtB2_3BoxNtNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutex5MutexE3newCs5sHeypWcCKR_11runtime_lab.exit.i
  %4 = landingpad { ptr, i32 }
          cleanup
; invoke core::ptr::drop_glue::<core::pin::Pin<alloc::boxed::Box<std::sys::pal::unix::sync::mutex::Mutex>>>
  invoke fastcc void @_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtB4_3pin3PinINtNtCs6zY7rJBZy9D_5alloc5boxed3BoxNtNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutex5MutexEEECs5sHeypWcCKR_11runtime_lab(ptr %0) #17
          to label %common.resume unwind label %terminate.i, !dbg !89

terminate.i:                                      ; preds = %cleanup.i
  %5 = landingpad { ptr, i32 }
          filter [0 x ptr] zeroinitializer
; call core::panicking::panic_in_cleanup
  tail call void @_RNvNtCsjIpoRzUjyHQ_4core9panicking16panic_in_cleanup() #16, !dbg !90
  unreachable, !dbg !90

_RNCNvMNtNtNtNtCs1SSuMAdGM58_3std3sys4sync5mutex7pthreadNtB4_5Mutex3get0Cs5sHeypWcCKR_11runtime_lab.exit: ; preds = %_RNvMNtCs6zY7rJBZy9D_5alloc5boxedINtB2_3BoxNtNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutex5MutexE3newCs5sHeypWcCKR_11runtime_lab.exit.i
  %6 = cmpxchg ptr %self, ptr null, ptr %0 release acquire, align 8, !dbg !91
  %7 = extractvalue { ptr, i1 } %6, 1, !dbg !91
  %8 = extractvalue { ptr, i1 } %6, 0, !dbg !91
  br i1 %7, label %bb5, label %bb3, !dbg !102

bb3:                                              ; preds = %_RNCNvMNtNtNtNtCs1SSuMAdGM58_3std3sys4sync5mutex7pthreadNtB4_5Mutex3get0Cs5sHeypWcCKR_11runtime_lab.exit
; invoke <std::sys::pal::unix::sync::mutex::Mutex as core::ops::drop::Drop>::drop
  invoke void @_RNvXs2_NtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutexNtB5_5MutexNtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4drop(ptr noundef nonnull align 8 %0)
          to label %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc5boxed3BoxNtNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutex5MutexEECs5sHeypWcCKR_11runtime_lab.exit unwind label %bb2.i, !dbg !103

bb2.i:                                            ; preds = %bb3
  %9 = landingpad { ptr, i32 }
          cleanup
; call __rustc::__rust_dealloc
  tail call void @_RNvCsdtSMxSA38aw_7___rustc14___rust_dealloc(ptr noundef nonnull %0, i64 noundef 64, i64 noundef 8) #14, !dbg !112
  br label %common.resume, !dbg !126

_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc5boxed3BoxNtNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutex5MutexEECs5sHeypWcCKR_11runtime_lab.exit: ; preds = %bb3
; call __rustc::__rust_dealloc
  tail call void @_RNvCsdtSMxSA38aw_7___rustc14___rust_dealloc(ptr noundef nonnull %0, i64 noundef 64, i64 noundef 8) #14, !dbg !127
  br label %bb5, !dbg !133

bb5:                                              ; preds = %_RNCNvMNtNtNtNtCs1SSuMAdGM58_3std3sys4sync5mutex7pthreadNtB4_5Mutex3get0Cs5sHeypWcCKR_11runtime_lab.exit, %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc5boxed3BoxNtNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutex5MutexEECs5sHeypWcCKR_11runtime_lab.exit
  %_0.sroa.0.0 = phi ptr [ %8, %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc5boxed3BoxNtNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutex5MutexEECs5sHeypWcCKR_11runtime_lab.exit ], [ %0, %_RNCNvMNtNtNtNtCs1SSuMAdGM58_3std3sys4sync5mutex7pthreadNtB4_5Mutex3get0Cs5sHeypWcCKR_11runtime_lab.exit ], !dbg !134
  call void @llvm.assume(i1 true) [ "nonnull"(ptr %_0.sroa.0.0) ]
  ret ptr %_0.sroa.0.0, !dbg !140
}

; core::ptr::drop_glue::<core::pin::Pin<alloc::boxed::Box<std::sys::pal::unix::sync::mutex::Mutex>>>
; Function Attrs: uwtable
define internal fastcc void @_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtB4_3pin3PinINtNtCs6zY7rJBZy9D_5alloc5boxed3BoxNtNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutex5MutexEEECs5sHeypWcCKR_11runtime_lab(ptr nonnull %_1.0.val) unnamed_addr #1 personality ptr @rust_eh_personality !dbg !141 !guid !142 {
start:
; invoke <std::sys::pal::unix::sync::mutex::Mutex as core::ops::drop::Drop>::drop
  invoke void @_RNvXs2_NtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutexNtB5_5MutexNtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4drop(ptr noundef nonnull align 8 %_1.0.val)
          to label %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc5boxed3BoxNtNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutex5MutexEECs5sHeypWcCKR_11runtime_lab.exit unwind label %bb2.i, !dbg !143

bb2.i:                                            ; preds = %start
  %0 = landingpad { ptr, i32 }
          cleanup
; call __rustc::__rust_dealloc
  tail call void @_RNvCsdtSMxSA38aw_7___rustc14___rust_dealloc(ptr noundef nonnull %_1.0.val, i64 noundef 64, i64 noundef 8) #14, !dbg !146
  resume { ptr, i32 } %0, !dbg !152

_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc5boxed3BoxNtNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutex5MutexEECs5sHeypWcCKR_11runtime_lab.exit: ; preds = %start
; call __rustc::__rust_dealloc
  tail call void @_RNvCsdtSMxSA38aw_7___rustc14___rust_dealloc(ptr noundef nonnull %_1.0.val, i64 noundef 64, i64 noundef 8) #14, !dbg !153
  ret void, !dbg !159
}

; core::ptr::drop_glue::<std::sync::poison::PoisonError<std::sync::poison::mutex::MutexGuard<runtime_lab::process::Capture>>>
; Function Attrs: uwtable
define internal fastcc void @_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtCs1SSuMAdGM58_3std4sync6poison11PoisonErrorINtNtBE_5mutex10MutexGuardNtNtCs5sHeypWcCKR_11runtime_lab7process7CaptureEEEB1T_(ptr nofree captures(none) %_1.0.val, i8 %_1.8.val) unnamed_addr #1 !dbg !160 !guid !161 {
start:
  call void @llvm.assume(i1 true) [ "nonnull"(ptr %_1.0.val) ]
  %_3.i.i = getelementptr inbounds nuw i8, ptr %_1.0.val, i64 8, !dbg !162
  %_3.i.i.i = trunc nuw i8 %_1.8.val to i1, !dbg !172
  br i1 %_3.i.i.i, label %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtNtCs1SSuMAdGM58_3std4sync6poison5mutex10MutexGuardNtNtCs5sHeypWcCKR_11runtime_lab7process7CaptureEEB1A_.exit, label %bb1.i.i.i, !dbg !172

bb1.i.i.i:                                        ; preds = %start
  %0 = load atomic i64, ptr @_RNvNtNtCs1SSuMAdGM58_3std9panicking11panic_count18GLOBAL_PANIC_COUNT monotonic, align 8, !dbg !177
  %_7.i.i.i = and i64 %0, 9223372036854775807, !dbg !194
  %1 = icmp eq i64 %_7.i.i.i, 0, !dbg !194
  br i1 %1, label %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtNtCs1SSuMAdGM58_3std4sync6poison5mutex10MutexGuardNtNtCs5sHeypWcCKR_11runtime_lab7process7CaptureEEB1A_.exit, label %bb6.i.i.i, !dbg !194, !prof !195

bb6.i.i.i:                                        ; preds = %bb1.i.i.i
; call std::panicking::panic_count::is_zero_slow_path
  %_6.i.i.i = tail call noundef zeroext i1 @_RNvNtNtCs1SSuMAdGM58_3std9panicking11panic_count17is_zero_slow_path() #18, !dbg !196
  br i1 %_6.i.i.i, label %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtNtCs1SSuMAdGM58_3std4sync6poison5mutex10MutexGuardNtNtCs5sHeypWcCKR_11runtime_lab7process7CaptureEEB1A_.exit, label %bb2.i.i.i, !dbg !197

bb2.i.i.i:                                        ; preds = %bb6.i.i.i
  store atomic i8 1, ptr %_3.i.i monotonic, align 1, !dbg !198
  br label %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtNtCs1SSuMAdGM58_3std4sync6poison5mutex10MutexGuardNtNtCs5sHeypWcCKR_11runtime_lab7process7CaptureEEB1A_.exit, !dbg !203

_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtNtCs1SSuMAdGM58_3std4sync6poison5mutex10MutexGuardNtNtCs5sHeypWcCKR_11runtime_lab7process7CaptureEEB1A_.exit: ; preds = %start, %bb1.i.i.i, %bb6.i.i.i, %bb2.i.i.i
  %2 = load atomic ptr, ptr %_1.0.val monotonic, align 8, !dbg !204
; call <std::sys::pal::unix::sync::mutex::Mutex>::unlock
  tail call void @_RNvMNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutexNtB2_5Mutex6unlock(ptr noundef nonnull align 8 %2), !dbg !214
  ret void, !dbg !215
}

; core::ptr::drop_glue::<std::sys::sync::once_box::OnceBox<std::sys::pal::unix::sync::mutex::Mutex>>
; Function Attrs: uwtable
define internal fastcc void @_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtNtCs1SSuMAdGM58_3std3sys4sync8once_box7OnceBoxNtNtNtNtNtBI_3pal4unix4sync5mutex5MutexEECs5sHeypWcCKR_11runtime_lab(ptr noalias nofree noundef nonnull align 8 captures(none) dereferenceable(8) %_1) unnamed_addr #1 personality ptr @rust_eh_personality !dbg !216 !guid !217 {
start:
  tail call void @llvm.experimental.noalias.scope.decl(metadata !218), !dbg !221
  %ptr.i = load ptr, ptr %_1, align 8, !dbg !222, !alias.scope !218, !noundef !25
  store ptr null, ptr %_1, align 8, !dbg !230, !alias.scope !218
  %_5.i = icmp eq ptr %ptr.i, null, !dbg !232
  br i1 %_5.i, label %_RNvXs1_NtNtNtCs1SSuMAdGM58_3std3sys4sync8once_boxINtB5_7OnceBoxNtNtNtNtNtB9_3pal4unix4sync5mutex5MutexENtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4dropCs5sHeypWcCKR_11runtime_lab.exit, label %bb2.i.i, !dbg !251

bb2.i.i:                                          ; preds = %start
; invoke <std::sys::pal::unix::sync::mutex::Mutex as core::ops::drop::Drop>::drop
  invoke void @_RNvXs2_NtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutexNtB5_5MutexNtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4drop(ptr noundef nonnull align 8 %ptr.i)
          to label %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtB4_3pin3PinINtNtCs6zY7rJBZy9D_5alloc5boxed3BoxNtNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutex5MutexEEECs5sHeypWcCKR_11runtime_lab.exit.i.i unwind label %bb2.i.i.i.i, !dbg !254, !noalias !218

bb2.i.i.i.i:                                      ; preds = %bb2.i.i
  %0 = landingpad { ptr, i32 }
          cleanup
; call __rustc::__rust_dealloc
  tail call void @_RNvCsdtSMxSA38aw_7___rustc14___rust_dealloc(ptr noundef nonnull %ptr.i, i64 noundef 64, i64 noundef 8) #14, !dbg !258, !noalias !218
  resume { ptr, i32 } %0, !dbg !264

_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtB4_3pin3PinINtNtCs6zY7rJBZy9D_5alloc5boxed3BoxNtNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutex5MutexEEECs5sHeypWcCKR_11runtime_lab.exit.i.i: ; preds = %bb2.i.i
; call __rustc::__rust_dealloc
  tail call void @_RNvCsdtSMxSA38aw_7___rustc14___rust_dealloc(ptr noundef nonnull %ptr.i, i64 noundef 64, i64 noundef 8) #14, !dbg !265, !noalias !218
  br label %_RNvXs1_NtNtNtCs1SSuMAdGM58_3std3sys4sync8once_boxINtB5_7OnceBoxNtNtNtNtNtB9_3pal4unix4sync5mutex5MutexENtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4dropCs5sHeypWcCKR_11runtime_lab.exit, !dbg !251

_RNvXs1_NtNtNtCs1SSuMAdGM58_3std3sys4sync8once_boxINtB5_7OnceBoxNtNtNtNtNtB9_3pal4unix4sync5mutex5MutexENtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4dropCs5sHeypWcCKR_11runtime_lab.exit: ; preds = %start, %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtB4_3pin3PinINtNtCs6zY7rJBZy9D_5alloc5boxed3BoxNtNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutex5MutexEEECs5sHeypWcCKR_11runtime_lab.exit.i.i
  ret void, !dbg !221
}

; core::ptr::drop_glue::<tokio::runtime::builder::Builder>
; Function Attrs: uwtable
define internal fastcc void @_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtNtCs3EIJ1qnJmKW_5tokio7runtime7builder7BuilderECs5sHeypWcCKR_11runtime_lab(ptr noalias nofree noundef nonnull align 8 dereferenceable(264) %_1) unnamed_addr #1 personality ptr @rust_eh_personality !dbg !271 !guid !272 {
start:
  %0 = getelementptr inbounds nuw i8, ptr %_1, i64 48, !dbg !273
  %.val = load i64, ptr %0, align 8, !dbg !273, !range !274, !noundef !25
  %1 = icmp sgt i64 %.val, 0, !dbg !275
  br i1 %1, label %_RNvXs1_NtCs6zY7rJBZy9D_5alloc5allocNtB5_6GlobalNtNtCsjIpoRzUjyHQ_4core5alloc9Allocator10deallocate.exit.i.i.i4.i.i.i, label %bb18, !dbg !275

_RNvXs1_NtCs6zY7rJBZy9D_5alloc5allocNtB5_6GlobalNtNtCsjIpoRzUjyHQ_4core5alloc9Allocator10deallocate.exit.i.i.i4.i.i.i: ; preds = %start
  %2 = getelementptr inbounds nuw i8, ptr %_1, i64 56, !dbg !273
  %.val21 = load ptr, ptr %2, align 8, !dbg !273, !nonnull !25, !noundef !25
; call __rustc::__rust_dealloc
  tail call void @_RNvCsdtSMxSA38aw_7___rustc14___rust_dealloc(ptr noundef nonnull %.val21, i64 noundef %.val, i64 noundef range(i64 1, -9223372036854775807) 1) #14, !dbg !278
  br label %bb18, !dbg !298

bb18:                                             ; preds = %_RNvXs1_NtCs6zY7rJBZy9D_5alloc5allocNtB5_6GlobalNtNtCsjIpoRzUjyHQ_4core5alloc9Allocator10deallocate.exit.i.i.i4.i.i.i, %start
  %3 = getelementptr inbounds nuw i8, ptr %_1, i64 96, !dbg !273
  tail call void @llvm.experimental.noalias.scope.decl(metadata !299), !dbg !273
  tail call void @llvm.experimental.noalias.scope.decl(metadata !302), !dbg !305
  %_10.0.i.i22 = load ptr, ptr %3, align 8, !dbg !308, !alias.scope !322, !nonnull !25, !noundef !25
  %_2.i.i23 = atomicrmw sub ptr %_10.0.i.i22, i64 1 release, align 8, !dbg !323, !noalias !322
  %4 = icmp eq i64 %_2.i.i23, 1, !dbg !328
  br i1 %4, label %bb2.i.i24, label %bb17, !dbg !328

bb2.i.i24:                                        ; preds = %bb18
  fence acquire, !dbg !329
; invoke <alloc::sync::Arc<dyn core::ops::function::Fn<(), Output = alloc::string::String> + core::marker::Send + core::marker::Sync>>::drop_slow
  invoke void @_RNvMsn_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcDINtNtNtCsjIpoRzUjyHQ_4core3ops8function2FnuEp6OutputNtNtB7_6string6StringNtNtBO_6marker4SendNtB1U_4SyncEL_E9drop_slowCs3EIJ1qnJmKW_5tokio(ptr noalias nofree noundef nonnull align 8 dereferenceable(16) %3) #18
          to label %bb17 unwind label %cleanup1, !dbg !332

bb2.i:                                            ; preds = %cleanup1
  %_2.i.i.i = atomicrmw sub ptr %8, i64 1 release, align 8, !dbg !333, !noalias !344
  %5 = icmp eq i64 %_2.i.i.i, 1, !dbg !351
  br i1 %5, label %bb2.i.i.i, label %bb8, !dbg !351

bb2.i.i.i:                                        ; preds = %bb2.i
  fence acquire, !dbg !352
; invoke <alloc::sync::Arc<dyn core::ops::function::Fn<(), Output = ()> + core::marker::Send + core::marker::Sync>>::drop_slow
  invoke void @_RNvMsn_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcDINtNtNtCsjIpoRzUjyHQ_4core3ops8function2FnuEp6OutputuNtNtBO_6marker4SendNtB1A_4SyncEL_E9drop_slowCs3EIJ1qnJmKW_5tokio(ptr noalias nofree noundef nonnull align 8 dereferenceable(16) %7) #18
          to label %bb8 unwind label %terminate, !dbg !354

cleanup1:                                         ; preds = %bb2.i.i24
  %6 = landingpad { ptr, i32 }
          cleanup
  %7 = getelementptr inbounds nuw i8, ptr %_1, i64 128, !dbg !273
  tail call void @llvm.experimental.noalias.scope.decl(metadata !355), !dbg !273
  %8 = load ptr, ptr %7, align 8, !dbg !356, !alias.scope !355, !noundef !25
  %9 = icmp eq ptr %8, null, !dbg !356
  br i1 %9, label %bb8, label %bb2.i, !dbg !356

bb17:                                             ; preds = %bb18, %bb2.i.i24
  %10 = getelementptr inbounds nuw i8, ptr %_1, i64 128, !dbg !273
  tail call void @llvm.experimental.noalias.scope.decl(metadata !357), !dbg !273
  %11 = load ptr, ptr %10, align 8, !dbg !360, !alias.scope !357, !noundef !25
  %12 = icmp eq ptr %11, null, !dbg !360
  br i1 %12, label %bb16, label %bb2.i28, !dbg !360

bb2.i28:                                          ; preds = %bb17
  %_2.i.i.i29 = atomicrmw sub ptr %11, i64 1 release, align 8, !dbg !362, !noalias !367
  %13 = icmp eq i64 %_2.i.i.i29, 1, !dbg !372
  br i1 %13, label %bb2.i.i.i30, label %bb16, !dbg !372

bb2.i.i.i30:                                      ; preds = %bb2.i28
  fence acquire, !dbg !373
; invoke <alloc::sync::Arc<dyn core::ops::function::Fn<(), Output = ()> + core::marker::Send + core::marker::Sync>>::drop_slow
  invoke void @_RNvMsn_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcDINtNtNtCsjIpoRzUjyHQ_4core3ops8function2FnuEp6OutputuNtNtBO_6marker4SendNtB1A_4SyncEL_E9drop_slowCs3EIJ1qnJmKW_5tokio(ptr noalias nofree noundef nonnull align 8 dereferenceable(16) %10) #18
          to label %bb16 unwind label %cleanup2, !dbg !375

bb8:                                              ; preds = %bb2.i, %cleanup1, %bb2.i.i.i, %cleanup2
  %.pn9 = phi { ptr, i32 } [ %18, %cleanup2 ], [ %6, %bb2.i.i.i ], [ %6, %cleanup1 ], [ %6, %bb2.i ]
  %14 = getelementptr inbounds nuw i8, ptr %_1, i64 144, !dbg !273
  tail call void @llvm.experimental.noalias.scope.decl(metadata !376), !dbg !273
  %15 = load ptr, ptr %14, align 8, !dbg !379, !alias.scope !376, !noundef !25
  %16 = icmp eq ptr %15, null, !dbg !379
  br i1 %16, label %bb7, label %bb2.i33, !dbg !379

bb2.i33:                                          ; preds = %bb8
  %_2.i.i.i34 = atomicrmw sub ptr %15, i64 1 release, align 8, !dbg !381, !noalias !386
  %17 = icmp eq i64 %_2.i.i.i34, 1, !dbg !391
  br i1 %17, label %bb2.i.i.i35, label %bb7, !dbg !391

bb2.i.i.i35:                                      ; preds = %bb2.i33
  fence acquire, !dbg !392
; invoke <alloc::sync::Arc<dyn core::ops::function::Fn<(), Output = ()> + core::marker::Send + core::marker::Sync>>::drop_slow
  invoke void @_RNvMsn_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcDINtNtNtCsjIpoRzUjyHQ_4core3ops8function2FnuEp6OutputuNtNtBO_6marker4SendNtB1A_4SyncEL_E9drop_slowCs3EIJ1qnJmKW_5tokio(ptr noalias nofree noundef nonnull align 8 dereferenceable(16) %14) #18
          to label %bb7 unwind label %terminate, !dbg !394

cleanup2:                                         ; preds = %bb2.i.i.i30
  %18 = landingpad { ptr, i32 }
          cleanup
  br label %bb8

bb16:                                             ; preds = %bb2.i28, %bb17, %bb2.i.i.i30
  %19 = getelementptr inbounds nuw i8, ptr %_1, i64 144, !dbg !273
  tail call void @llvm.experimental.noalias.scope.decl(metadata !395), !dbg !273
  %20 = load ptr, ptr %19, align 8, !dbg !398, !alias.scope !395, !noundef !25
  %21 = icmp eq ptr %20, null, !dbg !398
  br i1 %21, label %bb15, label %bb2.i38, !dbg !398

bb2.i38:                                          ; preds = %bb16
  %_2.i.i.i39 = atomicrmw sub ptr %20, i64 1 release, align 8, !dbg !400, !noalias !405
  %22 = icmp eq i64 %_2.i.i.i39, 1, !dbg !410
  br i1 %22, label %bb2.i.i.i40, label %bb15, !dbg !410

bb2.i.i.i40:                                      ; preds = %bb2.i38
  fence acquire, !dbg !411
; invoke <alloc::sync::Arc<dyn core::ops::function::Fn<(), Output = ()> + core::marker::Send + core::marker::Sync>>::drop_slow
  invoke void @_RNvMsn_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcDINtNtNtCsjIpoRzUjyHQ_4core3ops8function2FnuEp6OutputuNtNtBO_6marker4SendNtB1A_4SyncEL_E9drop_slowCs3EIJ1qnJmKW_5tokio(ptr noalias nofree noundef nonnull align 8 dereferenceable(16) %19) #18
          to label %bb15 unwind label %cleanup3, !dbg !413

bb7:                                              ; preds = %bb2.i33, %bb8, %bb2.i.i.i35, %cleanup3
  %.pn11 = phi { ptr, i32 } [ %27, %cleanup3 ], [ %.pn9, %bb2.i.i.i35 ], [ %.pn9, %bb8 ], [ %.pn9, %bb2.i33 ]
  %23 = getelementptr inbounds nuw i8, ptr %_1, i64 160, !dbg !273
  tail call void @llvm.experimental.noalias.scope.decl(metadata !414), !dbg !273
  %24 = load ptr, ptr %23, align 8, !dbg !417, !alias.scope !414, !noundef !25
  %25 = icmp eq ptr %24, null, !dbg !417
  br i1 %25, label %bb6, label %bb2.i43, !dbg !417

bb2.i43:                                          ; preds = %bb7
  %_2.i.i.i44 = atomicrmw sub ptr %24, i64 1 release, align 8, !dbg !419, !noalias !424
  %26 = icmp eq i64 %_2.i.i.i44, 1, !dbg !429
  br i1 %26, label %bb2.i.i.i45, label %bb6, !dbg !429

bb2.i.i.i45:                                      ; preds = %bb2.i43
  fence acquire, !dbg !430
; invoke <alloc::sync::Arc<dyn core::ops::function::Fn<(), Output = ()> + core::marker::Send + core::marker::Sync>>::drop_slow
  invoke void @_RNvMsn_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcDINtNtNtCsjIpoRzUjyHQ_4core3ops8function2FnuEp6OutputuNtNtBO_6marker4SendNtB1A_4SyncEL_E9drop_slowCs3EIJ1qnJmKW_5tokio(ptr noalias nofree noundef nonnull align 8 dereferenceable(16) %23) #18
          to label %bb6 unwind label %terminate, !dbg !432

cleanup3:                                         ; preds = %bb2.i.i.i40
  %27 = landingpad { ptr, i32 }
          cleanup
  br label %bb7

bb15:                                             ; preds = %bb2.i38, %bb16, %bb2.i.i.i40
  %28 = getelementptr inbounds nuw i8, ptr %_1, i64 160, !dbg !273
  tail call void @llvm.experimental.noalias.scope.decl(metadata !433), !dbg !273
  %29 = load ptr, ptr %28, align 8, !dbg !436, !alias.scope !433, !noundef !25
  %30 = icmp eq ptr %29, null, !dbg !436
  br i1 %30, label %bb14, label %bb2.i48, !dbg !436

bb2.i48:                                          ; preds = %bb15
  %_2.i.i.i49 = atomicrmw sub ptr %29, i64 1 release, align 8, !dbg !438, !noalias !443
  %31 = icmp eq i64 %_2.i.i.i49, 1, !dbg !448
  br i1 %31, label %bb2.i.i.i50, label %bb14, !dbg !448

bb2.i.i.i50:                                      ; preds = %bb2.i48
  fence acquire, !dbg !449
; invoke <alloc::sync::Arc<dyn core::ops::function::Fn<(), Output = ()> + core::marker::Send + core::marker::Sync>>::drop_slow
  invoke void @_RNvMsn_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcDINtNtNtCsjIpoRzUjyHQ_4core3ops8function2FnuEp6OutputuNtNtBO_6marker4SendNtB1A_4SyncEL_E9drop_slowCs3EIJ1qnJmKW_5tokio(ptr noalias nofree noundef nonnull align 8 dereferenceable(16) %28) #18
          to label %bb14 unwind label %cleanup4, !dbg !451

bb6:                                              ; preds = %bb2.i43, %bb7, %bb2.i.i.i45, %cleanup4
  %.pn13 = phi { ptr, i32 } [ %36, %cleanup4 ], [ %.pn11, %bb2.i.i.i45 ], [ %.pn11, %bb7 ], [ %.pn11, %bb2.i43 ]
  %32 = getelementptr inbounds nuw i8, ptr %_1, i64 176, !dbg !273
  tail call void @llvm.experimental.noalias.scope.decl(metadata !452), !dbg !273
  %33 = load ptr, ptr %32, align 8, !dbg !455, !alias.scope !452, !noundef !25
  %34 = icmp eq ptr %33, null, !dbg !455
  br i1 %34, label %bb5, label %bb2.i53, !dbg !455

bb2.i53:                                          ; preds = %bb6
  %_2.i.i.i54 = atomicrmw sub ptr %33, i64 1 release, align 8, !dbg !457, !noalias !462
  %35 = icmp eq i64 %_2.i.i.i54, 1, !dbg !467
  br i1 %35, label %bb2.i.i.i55, label %bb5, !dbg !467

bb2.i.i.i55:                                      ; preds = %bb2.i53
  fence acquire, !dbg !468
; invoke <alloc::sync::Arc<dyn core::ops::function::Fn<(), Output = ()> + core::marker::Send + core::marker::Sync>>::drop_slow
  invoke void @_RNvMsn_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcDINtNtNtCsjIpoRzUjyHQ_4core3ops8function2FnuEp6OutputuNtNtBO_6marker4SendNtB1A_4SyncEL_E9drop_slowCs3EIJ1qnJmKW_5tokio(ptr noalias nofree noundef nonnull align 8 dereferenceable(16) %32) #18
          to label %bb5 unwind label %terminate, !dbg !470

cleanup4:                                         ; preds = %bb2.i.i.i50
  %36 = landingpad { ptr, i32 }
          cleanup
  br label %bb6

bb14:                                             ; preds = %bb2.i48, %bb15, %bb2.i.i.i50
  %37 = getelementptr inbounds nuw i8, ptr %_1, i64 176, !dbg !273
  tail call void @llvm.experimental.noalias.scope.decl(metadata !471), !dbg !273
  %38 = load ptr, ptr %37, align 8, !dbg !474, !alias.scope !471, !noundef !25
  %39 = icmp eq ptr %38, null, !dbg !474
  br i1 %39, label %bb13, label %bb2.i58, !dbg !474

bb2.i58:                                          ; preds = %bb14
  %_2.i.i.i59 = atomicrmw sub ptr %38, i64 1 release, align 8, !dbg !476, !noalias !481
  %40 = icmp eq i64 %_2.i.i.i59, 1, !dbg !486
  br i1 %40, label %bb2.i.i.i60, label %bb13, !dbg !486

bb2.i.i.i60:                                      ; preds = %bb2.i58
  fence acquire, !dbg !487
; invoke <alloc::sync::Arc<dyn core::ops::function::Fn<(), Output = ()> + core::marker::Send + core::marker::Sync>>::drop_slow
  invoke void @_RNvMsn_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcDINtNtNtCsjIpoRzUjyHQ_4core3ops8function2FnuEp6OutputuNtNtBO_6marker4SendNtB1A_4SyncEL_E9drop_slowCs3EIJ1qnJmKW_5tokio(ptr noalias nofree noundef nonnull align 8 dereferenceable(16) %37) #18
          to label %bb13 unwind label %cleanup5, !dbg !489

bb5:                                              ; preds = %bb2.i53, %bb6, %bb2.i.i.i55, %cleanup5
  %.pn15 = phi { ptr, i32 } [ %45, %cleanup5 ], [ %.pn13, %bb2.i.i.i55 ], [ %.pn13, %bb6 ], [ %.pn13, %bb2.i53 ]
  %41 = getelementptr inbounds nuw i8, ptr %_1, i64 192, !dbg !273
  tail call void @llvm.experimental.noalias.scope.decl(metadata !490), !dbg !273
  %42 = load ptr, ptr %41, align 8, !dbg !493, !alias.scope !490, !noundef !25
  %43 = icmp eq ptr %42, null, !dbg !493
  br i1 %43, label %bb4, label %bb2.i63, !dbg !493

bb2.i63:                                          ; preds = %bb5
  %_2.i.i.i64 = atomicrmw sub ptr %42, i64 1 release, align 8, !dbg !496, !noalias !505
  %44 = icmp eq i64 %_2.i.i.i64, 1, !dbg !510
  br i1 %44, label %bb2.i.i.i65, label %bb4, !dbg !510

bb2.i.i.i65:                                      ; preds = %bb2.i63
  fence acquire, !dbg !511
; invoke <alloc::sync::Arc<dyn for<'a, 'b> core::ops::function::Fn<(&'a tokio::runtime::task_hooks::TaskMeta<'b>,), Output = ()> + core::marker::Send + core::marker::Sync>>::drop_slow
  invoke void @_RNvMsn_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcDG0_INtNtNtCsjIpoRzUjyHQ_4core3ops8function2FnTRL1_INtNtNtCs3EIJ1qnJmKW_5tokio7runtime10task_hooks8TaskMetaL0_EEEp6OutputuNtNtBR_6marker4SendNtB2G_4SyncEL_E9drop_slowB1C_(ptr noalias nofree noundef nonnull align 8 dereferenceable(16) %41) #18
          to label %bb4 unwind label %terminate, !dbg !513

cleanup5:                                         ; preds = %bb2.i.i.i60
  %45 = landingpad { ptr, i32 }
          cleanup
  br label %bb5

bb13:                                             ; preds = %bb2.i58, %bb14, %bb2.i.i.i60
  %46 = getelementptr inbounds nuw i8, ptr %_1, i64 192, !dbg !273
  tail call void @llvm.experimental.noalias.scope.decl(metadata !514), !dbg !273
  %47 = load ptr, ptr %46, align 8, !dbg !517, !alias.scope !514, !noundef !25
  %48 = icmp eq ptr %47, null, !dbg !517
  br i1 %48, label %bb12, label %bb2.i67, !dbg !517

bb2.i67:                                          ; preds = %bb13
  %_2.i.i.i68 = atomicrmw sub ptr %47, i64 1 release, align 8, !dbg !519, !noalias !524
  %49 = icmp eq i64 %_2.i.i.i68, 1, !dbg !529
  br i1 %49, label %bb2.i.i.i69, label %bb12, !dbg !529

bb2.i.i.i69:                                      ; preds = %bb2.i67
  fence acquire, !dbg !530
; invoke <alloc::sync::Arc<dyn for<'a, 'b> core::ops::function::Fn<(&'a tokio::runtime::task_hooks::TaskMeta<'b>,), Output = ()> + core::marker::Send + core::marker::Sync>>::drop_slow
  invoke void @_RNvMsn_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcDG0_INtNtNtCsjIpoRzUjyHQ_4core3ops8function2FnTRL1_INtNtNtCs3EIJ1qnJmKW_5tokio7runtime10task_hooks8TaskMetaL0_EEEp6OutputuNtNtBR_6marker4SendNtB2G_4SyncEL_E9drop_slowB1C_(ptr noalias nofree noundef nonnull align 8 dereferenceable(16) %46) #18
          to label %bb12 unwind label %cleanup6, !dbg !532

bb4:                                              ; preds = %bb2.i63, %bb5, %bb2.i.i.i65, %cleanup6
  %.pn17 = phi { ptr, i32 } [ %54, %cleanup6 ], [ %.pn15, %bb2.i.i.i65 ], [ %.pn15, %bb5 ], [ %.pn15, %bb2.i63 ]
  %50 = getelementptr inbounds nuw i8, ptr %_1, i64 208, !dbg !273
  tail call void @llvm.experimental.noalias.scope.decl(metadata !533), !dbg !273
  %51 = load ptr, ptr %50, align 8, !dbg !536, !alias.scope !533, !noundef !25
  %52 = icmp eq ptr %51, null, !dbg !536
  br i1 %52, label %bb3, label %bb2.i72, !dbg !536

bb2.i72:                                          ; preds = %bb4
  %_2.i.i.i73 = atomicrmw sub ptr %51, i64 1 release, align 8, !dbg !538, !noalias !543
  %53 = icmp eq i64 %_2.i.i.i73, 1, !dbg !548
  br i1 %53, label %bb2.i.i.i74, label %bb3, !dbg !548

bb2.i.i.i74:                                      ; preds = %bb2.i72
  fence acquire, !dbg !549
; invoke <alloc::sync::Arc<dyn for<'a, 'b> core::ops::function::Fn<(&'a tokio::runtime::task_hooks::TaskMeta<'b>,), Output = ()> + core::marker::Send + core::marker::Sync>>::drop_slow
  invoke void @_RNvMsn_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcDG0_INtNtNtCsjIpoRzUjyHQ_4core3ops8function2FnTRL1_INtNtNtCs3EIJ1qnJmKW_5tokio7runtime10task_hooks8TaskMetaL0_EEEp6OutputuNtNtBR_6marker4SendNtB2G_4SyncEL_E9drop_slowB1C_(ptr noalias nofree noundef nonnull align 8 dereferenceable(16) %50) #18
          to label %bb3 unwind label %terminate, !dbg !551

cleanup6:                                         ; preds = %bb2.i.i.i69
  %54 = landingpad { ptr, i32 }
          cleanup
  br label %bb4

bb12:                                             ; preds = %bb2.i67, %bb13, %bb2.i.i.i69
  %55 = getelementptr inbounds nuw i8, ptr %_1, i64 208, !dbg !273
  tail call void @llvm.experimental.noalias.scope.decl(metadata !552), !dbg !273
  %56 = load ptr, ptr %55, align 8, !dbg !555, !alias.scope !552, !noundef !25
  %57 = icmp eq ptr %56, null, !dbg !555
  br i1 %57, label %bb11, label %bb2.i77, !dbg !555

bb2.i77:                                          ; preds = %bb12
  %_2.i.i.i78 = atomicrmw sub ptr %56, i64 1 release, align 8, !dbg !557, !noalias !562
  %58 = icmp eq i64 %_2.i.i.i78, 1, !dbg !567
  br i1 %58, label %bb2.i.i.i79, label %bb11, !dbg !567

bb2.i.i.i79:                                      ; preds = %bb2.i77
  fence acquire, !dbg !568
; invoke <alloc::sync::Arc<dyn for<'a, 'b> core::ops::function::Fn<(&'a tokio::runtime::task_hooks::TaskMeta<'b>,), Output = ()> + core::marker::Send + core::marker::Sync>>::drop_slow
  invoke void @_RNvMsn_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcDG0_INtNtNtCsjIpoRzUjyHQ_4core3ops8function2FnTRL1_INtNtNtCs3EIJ1qnJmKW_5tokio7runtime10task_hooks8TaskMetaL0_EEEp6OutputuNtNtBR_6marker4SendNtB2G_4SyncEL_E9drop_slowB1C_(ptr noalias nofree noundef nonnull align 8 dereferenceable(16) %55) #18
          to label %bb11 unwind label %cleanup7, !dbg !570

bb3:                                              ; preds = %bb2.i72, %bb4, %bb2.i.i.i74, %cleanup7
  %.pn19 = phi { ptr, i32 } [ %60, %cleanup7 ], [ %.pn17, %bb2.i.i.i74 ], [ %.pn17, %bb4 ], [ %.pn17, %bb2.i72 ]
  %59 = getelementptr inbounds nuw i8, ptr %_1, i64 224, !dbg !273
; invoke core::ptr::drop_glue::<tokio::util::rand::rt::RngSeedGenerator>
  invoke fastcc void @_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtNtNtCs3EIJ1qnJmKW_5tokio4util4rand2rt16RngSeedGeneratorECs5sHeypWcCKR_11runtime_lab(ptr noalias nofree noundef align 8 dereferenceable(24) %59) #17
          to label %common.resume unwind label %terminate, !dbg !273

cleanup7:                                         ; preds = %bb2.i.i.i79
  %60 = landingpad { ptr, i32 }
          cleanup
  br label %bb3

bb11:                                             ; preds = %bb2.i77, %bb12, %bb2.i.i.i79
  %61 = getelementptr inbounds nuw i8, ptr %_1, i64 224, !dbg !273
; invoke <std::sys::sync::mutex::pthread::Mutex as core::ops::drop::Drop>::drop
  invoke void @_RNvXs_NtNtNtNtCs1SSuMAdGM58_3std3sys4sync5mutex7pthreadNtB4_5MutexNtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4drop(ptr noalias nofree noundef nonnull align 8 dereferenceable(24) %61)
          to label %bb4.i.i.i unwind label %cleanup.i.i.i, !dbg !571

cleanup.i.i.i:                                    ; preds = %bb11
  %62 = landingpad { ptr, i32 }
          cleanup
; invoke core::ptr::drop_glue::<std::sys::sync::once_box::OnceBox<std::sys::pal::unix::sync::mutex::Mutex>>
  invoke fastcc void @_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtNtCs1SSuMAdGM58_3std3sys4sync8once_box7OnceBoxNtNtNtNtNtBI_3pal4unix4sync5mutex5MutexEECs5sHeypWcCKR_11runtime_lab(ptr noalias nofree noundef nonnull align 8 dereferenceable(24) %61) #17
          to label %common.resume unwind label %terminate.i.i.i, !dbg !571

bb4.i.i.i:                                        ; preds = %bb11
  tail call void @llvm.experimental.noalias.scope.decl(metadata !578), !dbg !571
  tail call void @llvm.experimental.noalias.scope.decl(metadata !581), !dbg !584
  %ptr.i.i.i.i.i = load ptr, ptr %61, align 8, !dbg !586, !alias.scope !590, !noundef !25
  store ptr null, ptr %61, align 8, !dbg !597, !alias.scope !590
  %_5.i.i.i.i.i = icmp eq ptr %ptr.i.i.i.i.i, null, !dbg !598
  br i1 %_5.i.i.i.i.i, label %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtNtNtCs3EIJ1qnJmKW_5tokio4util4rand2rt16RngSeedGeneratorECs5sHeypWcCKR_11runtime_lab.exit, label %bb2.i.i.i.i.i.i, !dbg !602

bb2.i.i.i.i.i.i:                                  ; preds = %bb4.i.i.i
; invoke <std::sys::pal::unix::sync::mutex::Mutex as core::ops::drop::Drop>::drop
  invoke void @_RNvXs2_NtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutexNtB5_5MutexNtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4drop(ptr noundef nonnull align 8 %ptr.i.i.i.i.i)
          to label %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtB4_3pin3PinINtNtCs6zY7rJBZy9D_5alloc5boxed3BoxNtNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutex5MutexEEECs5sHeypWcCKR_11runtime_lab.exit.i.i.i.i.i.i unwind label %bb2.i.i.i.i.i.i.i.i, !dbg !604, !noalias !608

common.resume:                                    ; preds = %bb3, %cleanup.i.i.i, %bb2.i.i.i.i.i.i.i.i
  %common.resume.op = phi { ptr, i32 } [ %62, %cleanup.i.i.i ], [ %63, %bb2.i.i.i.i.i.i.i.i ], [ %.pn19, %bb3 ]
  resume { ptr, i32 } %common.resume.op, !dbg !273

bb2.i.i.i.i.i.i.i.i:                              ; preds = %bb2.i.i.i.i.i.i
  %63 = landingpad { ptr, i32 }
          cleanup
; call __rustc::__rust_dealloc
  tail call void @_RNvCsdtSMxSA38aw_7___rustc14___rust_dealloc(ptr noundef nonnull %ptr.i.i.i.i.i, i64 noundef 64, i64 noundef 8) #14, !dbg !609, !noalias !608
  br label %common.resume, !dbg !615

_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtB4_3pin3PinINtNtCs6zY7rJBZy9D_5alloc5boxed3BoxNtNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutex5MutexEEECs5sHeypWcCKR_11runtime_lab.exit.i.i.i.i.i.i: ; preds = %bb2.i.i.i.i.i.i
; call __rustc::__rust_dealloc
  tail call void @_RNvCsdtSMxSA38aw_7___rustc14___rust_dealloc(ptr noundef nonnull %ptr.i.i.i.i.i, i64 noundef 64, i64 noundef 8) #14, !dbg !616, !noalias !608
  br label %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtNtNtCs3EIJ1qnJmKW_5tokio4util4rand2rt16RngSeedGeneratorECs5sHeypWcCKR_11runtime_lab.exit, !dbg !602

terminate.i.i.i:                                  ; preds = %cleanup.i.i.i
  %64 = landingpad { ptr, i32 }
          filter [0 x ptr] zeroinitializer
; call core::panicking::panic_in_cleanup
  tail call void @_RNvNtCsjIpoRzUjyHQ_4core9panicking16panic_in_cleanup() #16, !dbg !571
  unreachable, !dbg !571

_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtNtNtCs3EIJ1qnJmKW_5tokio4util4rand2rt16RngSeedGeneratorECs5sHeypWcCKR_11runtime_lab.exit: ; preds = %bb4.i.i.i, %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtB4_3pin3PinINtNtCs6zY7rJBZy9D_5alloc5boxed3BoxNtNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutex5MutexEEECs5sHeypWcCKR_11runtime_lab.exit.i.i.i.i.i.i
  ret void, !dbg !273

terminate:                                        ; preds = %bb2.i.i.i74, %bb2.i.i.i65, %bb2.i.i.i55, %bb2.i.i.i45, %bb2.i.i.i35, %bb2.i.i.i, %bb3
  %65 = landingpad { ptr, i32 }
          filter [0 x ptr] zeroinitializer
; call core::panicking::panic_in_cleanup
  tail call void @_RNvNtCsjIpoRzUjyHQ_4core9panicking16panic_in_cleanup() #16, !dbg !273
  unreachable, !dbg !273
}

; core::ptr::drop_glue::<tokio::util::rand::rt::RngSeedGenerator>
; Function Attrs: uwtable
define internal fastcc void @_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtNtNtCs3EIJ1qnJmKW_5tokio4util4rand2rt16RngSeedGeneratorECs5sHeypWcCKR_11runtime_lab(ptr noalias nofree noundef nonnull align 8 dereferenceable(24) %_1) unnamed_addr #1 personality ptr @rust_eh_personality !dbg !576 !guid !622 {
start:
; invoke <std::sys::sync::mutex::pthread::Mutex as core::ops::drop::Drop>::drop
  invoke void @_RNvXs_NtNtNtNtCs1SSuMAdGM58_3std3sys4sync5mutex7pthreadNtB4_5MutexNtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4drop(ptr noalias nofree noundef nonnull align 8 dereferenceable(24) %_1)
          to label %bb4.i.i unwind label %cleanup.i.i, !dbg !623

cleanup.i.i:                                      ; preds = %start
  %0 = landingpad { ptr, i32 }
          cleanup
; invoke core::ptr::drop_glue::<std::sys::sync::once_box::OnceBox<std::sys::pal::unix::sync::mutex::Mutex>>
  invoke fastcc void @_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtNtCs1SSuMAdGM58_3std3sys4sync8once_box7OnceBoxNtNtNtNtNtBI_3pal4unix4sync5mutex5MutexEECs5sHeypWcCKR_11runtime_lab(ptr noalias nofree noundef nonnull align 8 dereferenceable(24) %_1) #17
          to label %common.resume.i.i unwind label %terminate.i.i, !dbg !623

bb4.i.i:                                          ; preds = %start
  tail call void @llvm.experimental.noalias.scope.decl(metadata !626), !dbg !623
  tail call void @llvm.experimental.noalias.scope.decl(metadata !629), !dbg !632
  %ptr.i.i.i.i = load ptr, ptr %_1, align 8, !dbg !634, !alias.scope !638, !noundef !25
  store ptr null, ptr %_1, align 8, !dbg !643, !alias.scope !638
  %_5.i.i.i.i = icmp eq ptr %ptr.i.i.i.i, null, !dbg !644
  br i1 %_5.i.i.i.i, label %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtNtCs1SSuMAdGM58_3std4sync6poison5mutex5MutexNtNtNtCs3EIJ1qnJmKW_5tokio4util4rand8FastRandEECs5sHeypWcCKR_11runtime_lab.exit, label %bb2.i.i.i.i.i, !dbg !648

bb2.i.i.i.i.i:                                    ; preds = %bb4.i.i
; invoke <std::sys::pal::unix::sync::mutex::Mutex as core::ops::drop::Drop>::drop
  invoke void @_RNvXs2_NtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutexNtB5_5MutexNtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4drop(ptr noundef nonnull align 8 %ptr.i.i.i.i)
          to label %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtB4_3pin3PinINtNtCs6zY7rJBZy9D_5alloc5boxed3BoxNtNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutex5MutexEEECs5sHeypWcCKR_11runtime_lab.exit.i.i.i.i.i unwind label %bb2.i.i.i.i.i.i.i, !dbg !650, !noalias !654

common.resume.i.i:                                ; preds = %bb2.i.i.i.i.i.i.i, %cleanup.i.i
  %common.resume.op.i.i = phi { ptr, i32 } [ %1, %bb2.i.i.i.i.i.i.i ], [ %0, %cleanup.i.i ]
  resume { ptr, i32 } %common.resume.op.i.i, !dbg !623

bb2.i.i.i.i.i.i.i:                                ; preds = %bb2.i.i.i.i.i
  %1 = landingpad { ptr, i32 }
          cleanup
; call __rustc::__rust_dealloc
  tail call void @_RNvCsdtSMxSA38aw_7___rustc14___rust_dealloc(ptr noundef nonnull %ptr.i.i.i.i, i64 noundef 64, i64 noundef 8) #14, !dbg !655, !noalias !654
  br label %common.resume.i.i, !dbg !661

_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtB4_3pin3PinINtNtCs6zY7rJBZy9D_5alloc5boxed3BoxNtNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutex5MutexEEECs5sHeypWcCKR_11runtime_lab.exit.i.i.i.i.i: ; preds = %bb2.i.i.i.i.i
; call __rustc::__rust_dealloc
  tail call void @_RNvCsdtSMxSA38aw_7___rustc14___rust_dealloc(ptr noundef nonnull %ptr.i.i.i.i, i64 noundef 64, i64 noundef 8) #14, !dbg !662, !noalias !654
  br label %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtNtCs1SSuMAdGM58_3std4sync6poison5mutex5MutexNtNtNtCs3EIJ1qnJmKW_5tokio4util4rand8FastRandEECs5sHeypWcCKR_11runtime_lab.exit, !dbg !648

terminate.i.i:                                    ; preds = %cleanup.i.i
  %2 = landingpad { ptr, i32 }
          filter [0 x ptr] zeroinitializer
; call core::panicking::panic_in_cleanup
  tail call void @_RNvNtCsjIpoRzUjyHQ_4core9panicking16panic_in_cleanup() #16, !dbg !623
  unreachable, !dbg !623

_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtNtCs1SSuMAdGM58_3std4sync6poison5mutex5MutexNtNtNtCs3EIJ1qnJmKW_5tokio4util4rand8FastRandEECs5sHeypWcCKR_11runtime_lab.exit: ; preds = %bb4.i.i, %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtB4_3pin3PinINtNtCs6zY7rJBZy9D_5alloc5boxed3BoxNtNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutex5MutexEEECs5sHeypWcCKR_11runtime_lab.exit.i.i.i.i.i
  ret void, !dbg !668
}

; core::panicking::assert_failed::<core::option::Option<core::ptr::non_null::NonNull<tokio::runtime::task::core::Header>>, core::option::Option<core::ptr::non_null::NonNull<tokio::runtime::task::core::Header>>>
; Function Attrs: cold minsize noinline noreturn optsize uwtable
define void @_RINvNtCsjIpoRzUjyHQ_4core9panicking13assert_failedINtNtB4_6option6OptionINtNtNtB4_3ptr8non_null7NonNullNtNtNtNtCs3EIJ1qnJmKW_5tokio7runtime4task4core6HeaderEEBM_ECs5sHeypWcCKR_11runtime_lab(i8 noundef range(i8 0, 3) %kind, ptr noalias nofree noundef readonly align 8 captures(address, read_provenance) dereferenceable(8) %0, ptr noalias nofree noundef readonly align 8 captures(address, read_provenance) dereferenceable(8) %1, ptr noundef %args.0, ptr %args.1, ptr noalias nofree noundef readonly align 8 captures(address, read_provenance) dereferenceable(24) %2) unnamed_addr #2 !dbg !669 !guid !672 {
start:
  %right = alloca [8 x i8], align 8
  %left = alloca [8 x i8], align 8
  store ptr %0, ptr %left, align 8
  store ptr %1, ptr %right, align 8
; call core::panicking::assert_failed_inner
  call void @_RNvNtCsjIpoRzUjyHQ_4core9panicking19assert_failed_inner(i8 noundef %kind, ptr noundef nonnull %left, ptr noalias nofree noundef readonly align 8 captures(address, read_provenance) dereferenceable(32) @vtable.0, ptr noundef nonnull %right, ptr noalias nofree noundef readonly align 8 captures(address, read_provenance) dereferenceable(32) @vtable.0, ptr noundef %args.0, ptr %args.1, ptr noalias nofree noundef nonnull readonly align 8 captures(address, read_provenance) dereferenceable(24) %2) #19, !dbg !673
  unreachable, !dbg !673
}

; runtime_lab::multi_runtime
; Function Attrs: uwtable
define void @_RNvCs5sHeypWcCKR_11runtime_lab13multi_runtime(ptr dead_on_unwind noalias nofree noundef writable sret([88 x i8]) align 8 captures(address) dereferenceable(88) %_0, i64 noundef %workers) unnamed_addr #1 personality ptr @rust_eh_personality !dbg !674 !guid !677 {
start:
  %_4 = alloca [264 x i8], align 8
  call void @llvm.lifetime.start.p0(ptr nonnull %_4), !dbg !678
; call <tokio::runtime::builder::Builder>::new_multi_thread
  call void @_RNvMNtNtCs3EIJ1qnJmKW_5tokio7runtime7builderNtB2_7Builder16new_multi_thread(ptr noalias nofree noundef nonnull sret([264 x i8]) align 8 captures(address) dereferenceable(264) %_4), !dbg !678
; invoke <tokio::runtime::builder::Builder>::worker_threads
  %_2 = invoke noundef nonnull align 8 ptr @_RNvMNtNtCs3EIJ1qnJmKW_5tokio7runtime7builderNtB2_7Builder14worker_threads(ptr noalias nofree noundef nonnull align 8 dereferenceable(264) %_4, i64 noundef %workers, ptr noalias nofree noundef readonly align 8 captures(address, read_provenance) dereferenceable(24) @alloc_76a4682140362797ca7b20487d943f78)
          to label %bb2 unwind label %cleanup, !dbg !679

cleanup:                                          ; preds = %bb2, %start
  %0 = landingpad { ptr, i32 }
          cleanup
; invoke core::ptr::drop_glue::<tokio::runtime::builder::Builder>
  invoke fastcc void @_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtNtCs3EIJ1qnJmKW_5tokio7runtime7builder7BuilderECs5sHeypWcCKR_11runtime_lab(ptr noalias nofree noundef align 8 dereferenceable(264) %_4) #17
          to label %bb6 unwind label %terminate, !dbg !680

bb2:                                              ; preds = %start
  %1 = getelementptr inbounds nuw i8, ptr %_2, i64 253, !dbg !681
  store i8 1, ptr %1, align 1, !dbg !681
  %2 = getelementptr inbounds nuw i8, ptr %_2, i64 254, !dbg !691
  store i8 1, ptr %2, align 2, !dbg !691
; invoke <tokio::runtime::builder::Builder>::build
  invoke void @_RNvMNtNtCs3EIJ1qnJmKW_5tokio7runtime7builderNtB2_7Builder5build(ptr noalias nofree noundef nonnull sret([88 x i8]) align 8 captures(address) dereferenceable(88) %_0, ptr noalias nofree noundef nonnull align 8 dereferenceable(264) %_2)
          to label %bb3 unwind label %cleanup, !dbg !694

bb3:                                              ; preds = %bb2
; call core::ptr::drop_glue::<tokio::runtime::builder::Builder>
  call fastcc void @_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtNtCs3EIJ1qnJmKW_5tokio7runtime7builder7BuilderECs5sHeypWcCKR_11runtime_lab(ptr noalias nofree noundef align 8 dereferenceable(264) %_4), !dbg !680
  call void @llvm.lifetime.end.p0(ptr nonnull %_4), !dbg !680
  ret void, !dbg !695

terminate:                                        ; preds = %cleanup
  %3 = landingpad { ptr, i32 }
          filter [0 x ptr] zeroinitializer
; call core::panicking::panic_in_cleanup
  call void @_RNvNtCsjIpoRzUjyHQ_4core9panicking16panic_in_cleanup() #16, !dbg !696
  unreachable, !dbg !696

bb6:                                              ; preds = %cleanup
  resume { ptr, i32 } %0, !dbg !696
}

; runtime_lab::current_runtime
; Function Attrs: uwtable
define void @_RNvCs5sHeypWcCKR_11runtime_lab15current_runtime(ptr dead_on_unwind noalias nofree noundef writable sret([88 x i8]) align 8 captures(address) dereferenceable(88) %_0) unnamed_addr #1 personality ptr @rust_eh_personality !dbg !697 !guid !698 {
start:
  %_2 = alloca [264 x i8], align 8
  call void @llvm.lifetime.start.p0(ptr nonnull %_2), !dbg !699
; call <tokio::runtime::builder::Builder>::new_current_thread
  call void @_RNvMNtNtCs3EIJ1qnJmKW_5tokio7runtime7builderNtB2_7Builder18new_current_thread(ptr noalias nofree noundef nonnull sret([264 x i8]) align 8 captures(address) dereferenceable(264) %_2), !dbg !699
  %0 = getelementptr inbounds nuw i8, ptr %_2, i64 253, !dbg !700
  store i8 1, ptr %0, align 1, !dbg !700
  %1 = getelementptr inbounds nuw i8, ptr %_2, i64 254, !dbg !705
  store i8 1, ptr %1, align 2, !dbg !705
; invoke <tokio::runtime::builder::Builder>::build
  invoke void @_RNvMNtNtCs3EIJ1qnJmKW_5tokio7runtime7builderNtB2_7Builder5build(ptr noalias nofree noundef nonnull sret([88 x i8]) align 8 captures(address) dereferenceable(88) %_0, ptr noalias nofree noundef nonnull align 8 dereferenceable(264) %_2)
          to label %bb2 unwind label %cleanup, !dbg !708

cleanup:                                          ; preds = %start
  %2 = landingpad { ptr, i32 }
          cleanup
; invoke core::ptr::drop_glue::<tokio::runtime::builder::Builder>
  invoke fastcc void @_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtNtCs3EIJ1qnJmKW_5tokio7runtime7builder7BuilderECs5sHeypWcCKR_11runtime_lab(ptr noalias nofree noundef align 8 dereferenceable(264) %_2) #17
          to label %bb5 unwind label %terminate, !dbg !709

bb2:                                              ; preds = %start
; call core::ptr::drop_glue::<tokio::runtime::builder::Builder>
  call fastcc void @_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtNtCs3EIJ1qnJmKW_5tokio7runtime7builder7BuilderECs5sHeypWcCKR_11runtime_lab(ptr noalias nofree noundef align 8 dereferenceable(264) %_2), !dbg !709
  call void @llvm.lifetime.end.p0(ptr nonnull %_2), !dbg !709
  ret void, !dbg !710

terminate:                                        ; preds = %cleanup
  %3 = landingpad { ptr, i32 }
          filter [0 x ptr] zeroinitializer
; call core::panicking::panic_in_cleanup
  call void @_RNvNtCsjIpoRzUjyHQ_4core9panicking16panic_in_cleanup() #16, !dbg !711
  unreachable, !dbg !711

bb5:                                              ; preds = %cleanup
  resume { ptr, i32 } %2, !dbg !711
}

; <runtime_lab::wire::Frame>::decode
; Function Attrs: uwtable
define void @_RNvMNtCs5sHeypWcCKR_11runtime_lab4wireNtB2_5Frame6decode(ptr dead_on_unwind noalias nofree noundef writable writeonly sret([24 x i8]) align 8 captures(none) dereferenceable(24) initializes((0, 16)) %_0, ptr noalias nofree noundef readonly align 1 captures(none) dead_on_return dereferenceable(24) %bytes) unnamed_addr #1 !dbg !712 !guid !716 {
start:
  %_62 = load i16, ptr %bytes, align 1, !dbg !717, !noundef !25
  %_33.not = icmp eq i16 %_62, 1, !dbg !717
  %_38 = getelementptr inbounds nuw i8, ptr %bytes, i64 2
  %_63 = load i16, ptr %_38, align 1
  %_42.not = icmp eq i16 %_63, 0
  %or.cond = select i1 %_33.not, i1 %_42.not, i1 false, !dbg !732
  %_47 = getelementptr inbounds nuw i8, ptr %bytes, i64 4
  %_64 = load i32, ptr %_47, align 1
  %_51.not = icmp eq i32 %_64, 24
  %or.cond1 = select i1 %or.cond, i1 %_51.not, i1 false, !dbg !732
  br i1 %or.cond1, label %bb5, label %bb3, !dbg !732

bb3:                                              ; preds = %start
; call <core::io::error::Error>::new::<&str>
  %_8 = tail call noundef nonnull ptr @_RINvMNtNtCs6zY7rJBZy9D_5alloc2io5errorNtNtNtCsjIpoRzUjyHQ_4core2io5error5Error3newReECs1SSuMAdGM58_3std(i8 noundef 21, ptr noalias nofree noundef nonnull readonly captures(address, read_provenance) @alloc_80e4d5a6503ea68c559c0291c1b805b6, i64 noundef 28) #18, !dbg !733
  br label %bb6, !dbg !734

bb5:                                              ; preds = %start
  %_56 = getelementptr inbounds nuw i8, ptr %bytes, i64 8, !dbg !735
  %id.sroa.0.0.copyload = load i64, ptr %_56, align 1, !dbg !756, !alias.scope !765, !noalias !769
  %_61 = getelementptr inbounds nuw i8, ptr %bytes, i64 16, !dbg !771
  %value.sroa.0.0.copyload = load i64, ptr %_61, align 1, !dbg !781, !alias.scope !785, !noalias !789
  %0 = inttoptr i64 %id.sroa.0.0.copyload to ptr, !dbg !791
  %1 = getelementptr inbounds nuw i8, ptr %_0, i64 16, !dbg !792
  store i64 %value.sroa.0.0.copyload, ptr %1, align 8, !dbg !792
  br label %bb6, !dbg !734

bb6:                                              ; preds = %bb3, %bb5
  %_8.sink = phi ptr [ %0, %bb5 ], [ %_8, %bb3 ], !dbg !791
  %storemerge = phi i64 [ 0, %bb5 ], [ 1, %bb3 ], !dbg !791
  %2 = getelementptr inbounds nuw i8, ptr %_0, i64 8, !dbg !791
  store ptr %_8.sink, ptr %2, align 8, !dbg !791
  store i64 %storemerge, ptr %_0, align 8, !dbg !791
  ret void, !dbg !734
}

; <runtime_lab::wire::Frame>::encode
; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: write) uwtable
define void @_RNvMNtCs5sHeypWcCKR_11runtime_lab4wireNtB2_5Frame6encode(ptr dead_on_unwind noalias nofree noundef writable writeonly sret([24 x i8]) align 1 captures(none) dereferenceable(24) initializes((0, 24)) %_0, i64 noundef %self.0, i64 noundef %self.1) unnamed_addr #3 !dbg !793 !guid !794 {
start:
  store i16 1, ptr %_0, align 1, !dbg !795
  %bytes.sroa.5.0._0.sroa_idx = getelementptr inbounds nuw i8, ptr %_0, i64 2, !dbg !795
  store i16 0, ptr %bytes.sroa.5.0._0.sroa_idx, align 1, !dbg !795
  %bytes.sroa.5.sroa.4.0.bytes.sroa.5.0._0.sroa_idx.sroa_idx = getelementptr inbounds nuw i8, ptr %_0, i64 4, !dbg !795
  store i32 24, ptr %bytes.sroa.5.sroa.4.0.bytes.sroa.5.0._0.sroa_idx.sroa_idx, align 1, !dbg !795
  %bytes.sroa.6.0._0.sroa_idx = getelementptr inbounds nuw i8, ptr %_0, i64 8, !dbg !795
  store i64 %self.0, ptr %bytes.sroa.6.0._0.sroa_idx, align 1, !dbg !795
  %bytes.sroa.7.0._0.sroa_idx = getelementptr inbounds nuw i8, ptr %_0, i64 16, !dbg !795
  store i64 %self.1, ptr %bytes.sroa.7.0._0.sroa_idx, align 1, !dbg !795
  ret void, !dbg !797
}

; <alloc::sync::Arc<std::sync::poison::mutex::Mutex<runtime_lab::process::Capture>>>::drop_slow
; Function Attrs: noinline uwtable
define void @_RNvMsn_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcINtNtNtNtCs1SSuMAdGM58_3std4sync6poison5mutex5MutexNtNtCs5sHeypWcCKR_11runtime_lab7process7CaptureEE9drop_slowB1z_(ptr noalias nofree noundef readonly align 8 captures(none) dereferenceable(8) %self) unnamed_addr #4 personality ptr @rust_eh_personality !dbg !798 !guid !799 {
start:
  %_3 = load ptr, ptr %self, align 8, !dbg !800, !nonnull !25, !noundef !25
  %_9 = getelementptr inbounds nuw i8, ptr %_3, i64 16, !dbg !801
; invoke <std::sys::sync::mutex::pthread::Mutex as core::ops::drop::Drop>::drop
  invoke void @_RNvXs_NtNtNtNtCs1SSuMAdGM58_3std3sys4sync5mutex7pthreadNtB4_5MutexNtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4drop(ptr noalias nofree noundef nonnull align 8 dereferenceable(56) %_9)
          to label %bb4.i.i unwind label %cleanup.i.i, !dbg !805

cleanup.i.i:                                      ; preds = %start
  %0 = landingpad { ptr, i32 }
          cleanup
; invoke core::ptr::drop_glue::<std::sys::sync::once_box::OnceBox<std::sys::pal::unix::sync::mutex::Mutex>>
  invoke fastcc void @_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtNtCs1SSuMAdGM58_3std3sys4sync8once_box7OnceBoxNtNtNtNtNtBI_3pal4unix4sync5mutex5MutexEECs5sHeypWcCKR_11runtime_lab(ptr noalias nofree noundef nonnull align 8 dereferenceable(56) %_9) #17
          to label %cleanup.body.i unwind label %terminate.i.i, !dbg !805

bb4.i.i:                                          ; preds = %start
  tail call void @llvm.experimental.noalias.scope.decl(metadata !809), !dbg !805
  tail call void @llvm.experimental.noalias.scope.decl(metadata !812), !dbg !815
  %ptr.i.i.i.i = load ptr, ptr %_9, align 8, !dbg !817, !alias.scope !821, !noundef !25
  store ptr null, ptr %_9, align 8, !dbg !826, !alias.scope !821
  %_5.i.i.i.i = icmp eq ptr %ptr.i.i.i.i, null, !dbg !827
  br i1 %_5.i.i.i.i, label %bb4.i, label %bb2.i.i.i.i.i, !dbg !831

bb2.i.i.i.i.i:                                    ; preds = %bb4.i.i
; invoke <std::sys::pal::unix::sync::mutex::Mutex as core::ops::drop::Drop>::drop
  invoke void @_RNvXs2_NtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutexNtB5_5MutexNtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4drop(ptr noundef nonnull align 8 %ptr.i.i.i.i)
          to label %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtB4_3pin3PinINtNtCs6zY7rJBZy9D_5alloc5boxed3BoxNtNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutex5MutexEEECs5sHeypWcCKR_11runtime_lab.exit.i.i.i.i.i unwind label %bb2.i.i.i.i.i.i.i, !dbg !833, !noalias !837

bb2.i.i.i.i.i.i.i:                                ; preds = %bb2.i.i.i.i.i
  %1 = landingpad { ptr, i32 }
          cleanup
; call __rustc::__rust_dealloc
  tail call void @_RNvCsdtSMxSA38aw_7___rustc14___rust_dealloc(ptr noundef nonnull %ptr.i.i.i.i, i64 noundef 64, i64 noundef 8) #14, !dbg !838, !noalias !837
  br label %cleanup.body.i, !dbg !844

_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtB4_3pin3PinINtNtCs6zY7rJBZy9D_5alloc5boxed3BoxNtNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutex5MutexEEECs5sHeypWcCKR_11runtime_lab.exit.i.i.i.i.i: ; preds = %bb2.i.i.i.i.i
; call __rustc::__rust_dealloc
  tail call void @_RNvCsdtSMxSA38aw_7___rustc14___rust_dealloc(ptr noundef nonnull %ptr.i.i.i.i, i64 noundef 64, i64 noundef 8) #14, !dbg !845, !noalias !837
  br label %bb4.i, !dbg !831

terminate.i.i:                                    ; preds = %cleanup.i.i
  %2 = landingpad { ptr, i32 }
          filter [0 x ptr] zeroinitializer
; call core::panicking::panic_in_cleanup
  tail call void @_RNvNtCsjIpoRzUjyHQ_4core9panicking16panic_in_cleanup() #16, !dbg !805
  unreachable, !dbg !805

cleanup.body.i:                                   ; preds = %bb2.i.i.i.i.i.i.i, %cleanup.i.i
  %eh.lpad-body.i = phi { ptr, i32 } [ %0, %cleanup.i.i ], [ %1, %bb2.i.i.i.i.i.i.i ]
  %3 = getelementptr inbounds nuw i8, ptr %_3, i64 32, !dbg !851
  %.val.i = load i64, ptr %3, align 8, !dbg !851, !alias.scope !852
  %4 = icmp eq i64 %.val.i, 0, !dbg !853
  br i1 %4, label %cleanup.body, label %_RNvXs1_NtCs6zY7rJBZy9D_5alloc5allocNtB5_6GlobalNtNtCsjIpoRzUjyHQ_4core5alloc9Allocator10deallocate.exit.i.i.i4.i.i.i.i, !dbg !853

_RNvXs1_NtCs6zY7rJBZy9D_5alloc5allocNtB5_6GlobalNtNtCsjIpoRzUjyHQ_4core5alloc9Allocator10deallocate.exit.i.i.i4.i.i.i.i: ; preds = %cleanup.body.i
  %5 = getelementptr inbounds nuw i8, ptr %_3, i64 40, !dbg !851
  %.val1.i = load ptr, ptr %5, align 8, !dbg !851, !alias.scope !852, !nonnull !25, !noundef !25
; call __rustc::__rust_dealloc
  tail call void @_RNvCsdtSMxSA38aw_7___rustc14___rust_dealloc(ptr noundef nonnull %.val1.i, i64 noundef %.val.i, i64 noundef range(i64 1, -9223372036854775807) 1) #14, !dbg !864
  br label %cleanup.body, !dbg !869

bb4.i:                                            ; preds = %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtB4_3pin3PinINtNtCs6zY7rJBZy9D_5alloc5boxed3BoxNtNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutex5MutexEEECs5sHeypWcCKR_11runtime_lab.exit.i.i.i.i.i, %bb4.i.i
  %6 = getelementptr inbounds nuw i8, ptr %_3, i64 32, !dbg !851
  %.val2.i = load i64, ptr %6, align 8, !dbg !851, !alias.scope !852
  %7 = icmp eq i64 %.val2.i, 0, !dbg !870
  br i1 %7, label %bb4, label %_RNvXs1_NtCs6zY7rJBZy9D_5alloc5allocNtB5_6GlobalNtNtCsjIpoRzUjyHQ_4core5alloc9Allocator10deallocate.exit.i.i.i4.i.i.i4.i, !dbg !870

_RNvXs1_NtCs6zY7rJBZy9D_5alloc5allocNtB5_6GlobalNtNtCsjIpoRzUjyHQ_4core5alloc9Allocator10deallocate.exit.i.i.i4.i.i.i4.i: ; preds = %bb4.i
  %8 = getelementptr inbounds nuw i8, ptr %_3, i64 40, !dbg !851
  %.val3.i = load ptr, ptr %8, align 8, !dbg !851, !alias.scope !852, !nonnull !25, !noundef !25
; call __rustc::__rust_dealloc
  tail call void @_RNvCsdtSMxSA38aw_7___rustc14___rust_dealloc(ptr noundef nonnull %.val3.i, i64 noundef %.val2.i, i64 noundef range(i64 1, -9223372036854775807) 1) #14, !dbg !878
  br label %bb4, !dbg !883

cleanup.body:                                     ; preds = %cleanup.body.i, %_RNvXs1_NtCs6zY7rJBZy9D_5alloc5allocNtB5_6GlobalNtNtCsjIpoRzUjyHQ_4core5alloc9Allocator10deallocate.exit.i.i.i4.i.i.i.i
  %_16.i.i = icmp eq ptr %_3, inttoptr (i64 -1 to ptr), !dbg !884
  br i1 %_16.i.i, label %bb3, label %bb8.i.i, !dbg !899

bb8.i.i:                                          ; preds = %cleanup.body
  %_20.i.i = getelementptr inbounds nuw i8, ptr %_3, i64 8, !dbg !900
  %_3.i.i = atomicrmw sub ptr %_20.i.i, i64 1 release, align 8, !dbg !901
  %9 = icmp eq i64 %_3.i.i, 1, !dbg !907
  br i1 %9, label %bb1.i.i, label %bb3, !dbg !907

bb1.i.i:                                          ; preds = %bb8.i.i
  fence acquire, !dbg !908
; call __rustc::__rust_dealloc
  tail call void @_RNvCsdtSMxSA38aw_7___rustc14___rust_dealloc(ptr noundef nonnull %_3, i64 noundef 72, i64 noundef 8) #14, !dbg !910
  br label %bb3, !dbg !920

bb4:                                              ; preds = %_RNvXs1_NtCs6zY7rJBZy9D_5alloc5allocNtB5_6GlobalNtNtCsjIpoRzUjyHQ_4core5alloc9Allocator10deallocate.exit.i.i.i4.i.i.i4.i, %bb4.i
  %_16.i.i3 = icmp eq ptr %_3, inttoptr (i64 -1 to ptr), !dbg !921
  br i1 %_16.i.i3, label %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc4sync4WeakINtNtNtNtCs1SSuMAdGM58_3std4sync6poison5mutex5MutexNtNtCs5sHeypWcCKR_11runtime_lab7process7CaptureERNtNtBG_5alloc6GlobalEEB23_.exit8, label %bb8.i.i4, !dbg !926

bb8.i.i4:                                         ; preds = %bb4
  %_20.i.i5 = getelementptr inbounds nuw i8, ptr %_3, i64 8, !dbg !927
  %_3.i.i6 = atomicrmw sub ptr %_20.i.i5, i64 1 release, align 8, !dbg !928
  %10 = icmp eq i64 %_3.i.i6, 1, !dbg !931
  br i1 %10, label %bb1.i.i7, label %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc4sync4WeakINtNtNtNtCs1SSuMAdGM58_3std4sync6poison5mutex5MutexNtNtCs5sHeypWcCKR_11runtime_lab7process7CaptureERNtNtBG_5alloc6GlobalEEB23_.exit8, !dbg !931

bb1.i.i7:                                         ; preds = %bb8.i.i4
  fence acquire, !dbg !932
; call __rustc::__rust_dealloc
  tail call void @_RNvCsdtSMxSA38aw_7___rustc14___rust_dealloc(ptr noundef nonnull %_3, i64 noundef 72, i64 noundef 8) #14, !dbg !934
  br label %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc4sync4WeakINtNtNtNtCs1SSuMAdGM58_3std4sync6poison5mutex5MutexNtNtCs5sHeypWcCKR_11runtime_lab7process7CaptureERNtNtBG_5alloc6GlobalEEB23_.exit8, !dbg !940

_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc4sync4WeakINtNtNtNtCs1SSuMAdGM58_3std4sync6poison5mutex5MutexNtNtCs5sHeypWcCKR_11runtime_lab7process7CaptureERNtNtBG_5alloc6GlobalEEB23_.exit8: ; preds = %bb4, %bb8.i.i4, %bb1.i.i7
  ret void, !dbg !941

bb3:                                              ; preds = %bb1.i.i, %bb8.i.i, %cleanup.body
  resume { ptr, i32 } %eh.lpad-body.i, !dbg !942
}

; runtime_lab::process::state_lock
; Function Attrs: uwtable
define void @_RNvNtCs5sHeypWcCKR_11runtime_lab7process10state_lock(ptr dead_on_unwind noalias nofree noundef writable writeonly sret([16 x i8]) align 8 captures(none) dereferenceable(16) %_0, ptr noundef nonnull align 8 %state) unnamed_addr #1 personality ptr @rust_eh_personality !dbg !943 !guid !946 {
start:
  %0 = load atomic ptr, ptr %state acquire, align 8, !dbg !947, !noalias !960
  %_11.i.i = icmp eq ptr %0, null, !dbg !963
  br i1 %_11.i.i, label %bb7.i.i, label %_RINvMNtNtNtCs1SSuMAdGM58_3std3sys4sync8once_boxINtB3_7OnceBoxNtNtNtNtNtB7_3pal4unix4sync5mutex5MutexE11get_or_initNCNvMNtNtB5_5mutex7pthreadNtB1T_5Mutex3get0ECs5sHeypWcCKR_11runtime_lab.exit.i, !dbg !976, !prof !74

bb7.i.i:                                          ; preds = %start
; call <std::sys::sync::once_box::OnceBox<std::sys::pal::unix::sync::mutex::Mutex>>::initialize::<<std::sys::sync::mutex::pthread::Mutex>::get::{closure#0}>
  %1 = tail call fastcc noundef nonnull align 8 ptr @_RINvMNtNtNtCs1SSuMAdGM58_3std3sys4sync8once_boxINtB3_7OnceBoxNtNtNtNtNtB7_3pal4unix4sync5mutex5MutexE10initializeNCNvMNtNtB5_5mutex7pthreadNtB1S_5Mutex3get0ECs5sHeypWcCKR_11runtime_lab(ptr noundef nonnull align 8 %state), !dbg !977, !noalias !960
  br label %_RINvMNtNtNtCs1SSuMAdGM58_3std3sys4sync8once_boxINtB3_7OnceBoxNtNtNtNtNtB7_3pal4unix4sync5mutex5MutexE11get_or_initNCNvMNtNtB5_5mutex7pthreadNtB1T_5Mutex3get0ECs5sHeypWcCKR_11runtime_lab.exit.i, !dbg !978

_RINvMNtNtNtCs1SSuMAdGM58_3std3sys4sync8once_boxINtB3_7OnceBoxNtNtNtNtNtB7_3pal4unix4sync5mutex5MutexE11get_or_initNCNvMNtNtB5_5mutex7pthreadNtB1T_5Mutex3get0ECs5sHeypWcCKR_11runtime_lab.exit.i: ; preds = %bb7.i.i, %start
  %_0.sroa.0.0.i.i = phi ptr [ %1, %bb7.i.i ], [ %0, %start ], !dbg !979
; call <std::sys::pal::unix::sync::mutex::Mutex>::lock
  tail call void @_RNvMNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutexNtB2_5Mutex4lock(ptr noundef nonnull align 8 %_0.sroa.0.0.i.i), !dbg !980, !noalias !960
  %2 = load atomic i64, ptr @_RNvNtNtCs1SSuMAdGM58_3std9panicking11panic_count18GLOBAL_PANIC_COUNT monotonic, align 8, !dbg !981, !noalias !960
  %_7.i.i = and i64 %2, 9223372036854775807, !dbg !996
  %3 = icmp eq i64 %_7.i.i, 0, !dbg !996
  br i1 %3, label %_RNvMs5_NtNtNtCs1SSuMAdGM58_3std4sync6poison5mutexINtB5_5MutexNtNtCs5sHeypWcCKR_11runtime_lab7process7CaptureE4lockB11_.exit, label %bb6.i.i, !dbg !996, !prof !195

bb6.i.i:                                          ; preds = %_RINvMNtNtNtCs1SSuMAdGM58_3std3sys4sync8once_boxINtB3_7OnceBoxNtNtNtNtNtB7_3pal4unix4sync5mutex5MutexE11get_or_initNCNvMNtNtB5_5mutex7pthreadNtB1T_5Mutex3get0ECs5sHeypWcCKR_11runtime_lab.exit.i
; call std::panicking::panic_count::is_zero_slow_path
  %4 = tail call noundef zeroext i1 @_RNvNtNtCs1SSuMAdGM58_3std9panicking11panic_count17is_zero_slow_path() #18, !dbg !997, !noalias !960
  %5 = xor i1 %4, true, !dbg !998
  br label %_RNvMs5_NtNtNtCs1SSuMAdGM58_3std4sync6poison5mutexINtB5_5MutexNtNtCs5sHeypWcCKR_11runtime_lab7process7CaptureE4lockB11_.exit, !dbg !997

_RNvMs5_NtNtNtCs1SSuMAdGM58_3std4sync6poison5mutexINtB5_5MutexNtNtCs5sHeypWcCKR_11runtime_lab7process7CaptureE4lockB11_.exit: ; preds = %_RINvMNtNtNtCs1SSuMAdGM58_3std3sys4sync8once_boxINtB3_7OnceBoxNtNtNtNtNtB7_3pal4unix4sync5mutex5MutexE11get_or_initNCNvMNtNtB5_5mutex7pthreadNtB1T_5Mutex3get0ECs5sHeypWcCKR_11runtime_lab.exit.i, %bb6.i.i
  %_6.sroa.0.0.off0.i.i = phi i1 [ %5, %bb6.i.i ], [ false, %_RINvMNtNtNtCs1SSuMAdGM58_3std3sys4sync8once_boxINtB3_7OnceBoxNtNtNtNtNtB7_3pal4unix4sync5mutex5MutexE11get_or_initNCNvMNtNtB5_5mutex7pthreadNtB1T_5Mutex3get0ECs5sHeypWcCKR_11runtime_lab.exit.i ]
  %_7.i = getelementptr inbounds nuw i8, ptr %state, i64 8, !dbg !999
  %6 = load atomic i8, ptr %_7.i monotonic, align 8, !dbg !1000, !noalias !960
  %_4.not.i.i.not = icmp eq i8 %6, 0, !dbg !1008
  %_0.sroa.3.0.i.i = zext i1 %_6.sroa.0.0.off0.i.i to i8, !dbg !1009
  br i1 %_4.not.i.i.not, label %bb2, label %bb4, !dbg !1010

bb4:                                              ; preds = %_RNvMs5_NtNtNtCs1SSuMAdGM58_3std4sync6poison5mutexINtB5_5MutexNtNtCs5sHeypWcCKR_11runtime_lab7process7CaptureE4lockB11_.exit
; invoke <core::io::error::Error>::new::<&str>
  %_0.i = invoke noundef nonnull ptr @_RINvMNtNtCs6zY7rJBZy9D_5alloc2io5errorNtNtNtCsjIpoRzUjyHQ_4core2io5error5Error3newReECs1SSuMAdGM58_3std(i8 noundef 42, ptr noalias nofree noundef nonnull readonly captures(address, read_provenance) @alloc_8821e7adf2aaedbbe7385d67b31be780, i64 noundef 22)
          to label %bb4.i unwind label %cleanup.i, !dbg !1016

cleanup.i:                                        ; preds = %bb4
  %7 = landingpad { ptr, i32 }
          cleanup
; invoke core::ptr::drop_glue::<std::sync::poison::PoisonError<std::sync::poison::mutex::MutexGuard<runtime_lab::process::Capture>>>
  invoke fastcc void @_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtCs1SSuMAdGM58_3std4sync6poison11PoisonErrorINtNtBE_5mutex10MutexGuardNtNtCs5sHeypWcCKR_11runtime_lab7process7CaptureEEEB1T_(ptr nonnull align 8 %state, i8 %_0.sroa.3.0.i.i) #17
          to label %bb3.i unwind label %terminate.i, !dbg !1027

bb4.i:                                            ; preds = %bb4
  br i1 %_6.sroa.0.0.off0.i.i, label %_RNCNvNtCs5sHeypWcCKR_11runtime_lab7process10state_lock0B5_.exit, label %bb1.i.i.i.i.i, !dbg !1028

bb1.i.i.i.i.i:                                    ; preds = %bb4.i
  %8 = load atomic i64, ptr @_RNvNtNtCs1SSuMAdGM58_3std9panicking11panic_count18GLOBAL_PANIC_COUNT monotonic, align 8, !dbg !1033
  %_7.i.i.i.i.i = and i64 %8, 9223372036854775807, !dbg !1039
  %9 = icmp eq i64 %_7.i.i.i.i.i, 0, !dbg !1039
  br i1 %9, label %_RNCNvNtCs5sHeypWcCKR_11runtime_lab7process10state_lock0B5_.exit, label %bb6.i.i.i.i.i, !dbg !1039, !prof !195

bb6.i.i.i.i.i:                                    ; preds = %bb1.i.i.i.i.i
; call std::panicking::panic_count::is_zero_slow_path
  %_6.i.i.i.i.i = tail call noundef zeroext i1 @_RNvNtNtCs1SSuMAdGM58_3std9panicking11panic_count17is_zero_slow_path() #18, !dbg !1040
  br i1 %_6.i.i.i.i.i, label %_RNCNvNtCs5sHeypWcCKR_11runtime_lab7process10state_lock0B5_.exit, label %bb2.i.i.i.i.i, !dbg !1041

bb2.i.i.i.i.i:                                    ; preds = %bb6.i.i.i.i.i
  store atomic i8 1, ptr %_7.i monotonic, align 8, !dbg !1042
  br label %_RNCNvNtCs5sHeypWcCKR_11runtime_lab7process10state_lock0B5_.exit, !dbg !1045

terminate.i:                                      ; preds = %cleanup.i
  %10 = landingpad { ptr, i32 }
          filter [0 x ptr] zeroinitializer
; call core::panicking::panic_in_cleanup
  tail call void @_RNvNtCsjIpoRzUjyHQ_4core9panicking16panic_in_cleanup() #16, !dbg !1046
  unreachable, !dbg !1046

bb3.i:                                            ; preds = %cleanup.i
  resume { ptr, i32 } %7, !dbg !1046

_RNCNvNtCs5sHeypWcCKR_11runtime_lab7process10state_lock0B5_.exit: ; preds = %bb4.i, %bb1.i.i.i.i.i, %bb6.i.i.i.i.i, %bb2.i.i.i.i.i
  %11 = load atomic ptr, ptr %state monotonic, align 8, !dbg !1047
; call <std::sys::pal::unix::sync::mutex::Mutex>::unlock
  tail call void @_RNvMNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutexNtB2_5Mutex6unlock(ptr noundef nonnull align 8 %11), !dbg !1052
  br label %bb2, !dbg !1053

bb2:                                              ; preds = %_RNvMs5_NtNtNtCs1SSuMAdGM58_3std4sync6poison5mutexINtB5_5MutexNtNtCs5sHeypWcCKR_11runtime_lab7process7CaptureE4lockB11_.exit, %_RNCNvNtCs5sHeypWcCKR_11runtime_lab7process10state_lock0B5_.exit
  %_0.i.sink = phi ptr [ %_0.i, %_RNCNvNtCs5sHeypWcCKR_11runtime_lab7process10state_lock0B5_.exit ], [ %state, %_RNvMs5_NtNtNtCs1SSuMAdGM58_3std4sync6poison5mutexINtB5_5MutexNtNtCs5sHeypWcCKR_11runtime_lab7process7CaptureE4lockB11_.exit ]
  %.sink = phi i8 [ 2, %_RNCNvNtCs5sHeypWcCKR_11runtime_lab7process10state_lock0B5_.exit ], [ %_0.sroa.3.0.i.i, %_RNvMs5_NtNtNtCs1SSuMAdGM58_3std4sync6poison5mutexINtB5_5MutexNtNtCs5sHeypWcCKR_11runtime_lab7process7CaptureE4lockB11_.exit ]
  store ptr %_0.i.sink, ptr %_0, align 8, !dbg !1054
  %12 = getelementptr inbounds nuw i8, ptr %_0, i64 8, !dbg !1054
  store i8 %.sink, ptr %12, align 8, !dbg !1054
  ret void, !dbg !1055
}

; <&core::option::Option<core::ptr::non_null::NonNull<tokio::runtime::task::core::Header>> as core::fmt::Debug>::fmt
; Function Attrs: uwtable
define internal noundef zeroext i1 @_RNvXs1g_NtCsjIpoRzUjyHQ_4core3fmtRINtNtB8_6option6OptionINtNtNtB8_3ptr8non_null7NonNullNtNtNtNtCs3EIJ1qnJmKW_5tokio7runtime4task4core6HeaderEENtB6_5Debug3fmtCs5sHeypWcCKR_11runtime_lab(ptr noalias nofree noundef readonly align 8 captures(none) dereferenceable(8) %self, ptr noalias nofree noundef align 8 dereferenceable(24) %f) unnamed_addr #1 !dbg !1056 !guid !1060 {
start:
  %__self_0.i = alloca [8 x i8], align 8
  %_3 = load ptr, ptr %self, align 8, !dbg !1061, !nonnull !25, !align !1062, !noundef !25
  tail call void @llvm.experimental.noalias.scope.decl(metadata !1063), !dbg !1066
  %0 = load ptr, ptr %_3, align 8, !dbg !1067, !alias.scope !1063, !noalias !1073, !noundef !25
  %.not.i = icmp eq ptr %0, null, !dbg !1067
  br i1 %.not.i, label %bb3.i, label %bb2.i, !dbg !1067

bb2.i:                                            ; preds = %start
  call void @llvm.lifetime.start.p0(ptr nonnull %__self_0.i), !dbg !1075, !noalias !1076
  store ptr %_3, ptr %__self_0.i, align 8, !dbg !1075, !noalias !1076
; call <core::fmt::Formatter>::debug_tuple_field1_finish
  %1 = call noundef zeroext i1 @_RNvMsa_NtCsjIpoRzUjyHQ_4core3fmtNtB5_9Formatter25debug_tuple_field1_finish(ptr noalias nofree noundef nonnull align 8 dereferenceable(24) %f, ptr noalias nofree noundef nonnull readonly captures(address, read_provenance) @alloc_9535bf4c204f3eb9b19ec2c83e446e52, i64 noundef 4, ptr noundef nonnull %__self_0.i, ptr noalias nofree noundef readonly align 8 captures(address, read_provenance) dereferenceable(32) @vtable.2), !dbg !1077
  call void @llvm.lifetime.end.p0(ptr nonnull %__self_0.i), !dbg !1079, !noalias !1076
  br label %_RNvXsR_NtCsjIpoRzUjyHQ_4core6optionINtB5_6OptionINtNtNtB7_3ptr8non_null7NonNullNtNtNtNtCs3EIJ1qnJmKW_5tokio7runtime4task4core6HeaderEENtNtB7_3fmt5Debug3fmtCs5sHeypWcCKR_11runtime_lab.exit, !dbg !1079

bb3.i:                                            ; preds = %start
; call <core::fmt::Formatter>::write_str
  %2 = tail call noundef zeroext i1 @_RNvMsa_NtCsjIpoRzUjyHQ_4core3fmtNtB5_9Formatter9write_str(ptr noalias nofree noundef nonnull align 8 dereferenceable(24) %f, ptr noalias nofree noundef nonnull readonly captures(address, read_provenance) @alloc_37d2e53432a03a1f90b3e7253015eaf9, i64 noundef 4), !dbg !1067, !noalias !1063
  br label %_RNvXsR_NtCsjIpoRzUjyHQ_4core6optionINtB5_6OptionINtNtNtB7_3ptr8non_null7NonNullNtNtNtNtCs3EIJ1qnJmKW_5tokio7runtime4task4core6HeaderEENtNtB7_3fmt5Debug3fmtCs5sHeypWcCKR_11runtime_lab.exit, !dbg !1067

_RNvXsR_NtCsjIpoRzUjyHQ_4core6optionINtB5_6OptionINtNtNtB7_3ptr8non_null7NonNullNtNtNtNtCs3EIJ1qnJmKW_5tokio7runtime4task4core6HeaderEENtNtB7_3fmt5Debug3fmtCs5sHeypWcCKR_11runtime_lab.exit: ; preds = %bb2.i, %bb3.i
  %_0.sroa.0.0.in.i = phi i1 [ %1, %bb2.i ], [ %2, %bb3.i ]
  ret i1 %_0.sroa.0.0.in.i, !dbg !1080
}

; <&core::ptr::non_null::NonNull<tokio::runtime::task::core::Header> as core::fmt::Debug>::fmt
; Function Attrs: uwtable
define internal noundef zeroext i1 @_RNvXs1g_NtCsjIpoRzUjyHQ_4core3fmtRINtNtNtB8_3ptr8non_null7NonNullNtNtNtNtCs3EIJ1qnJmKW_5tokio7runtime4task4core6HeaderENtB6_5Debug3fmtCs5sHeypWcCKR_11runtime_lab(ptr noalias nofree noundef readonly align 8 captures(none) dereferenceable(8) %self, ptr noalias nofree noundef align 8 dereferenceable(24) %f) unnamed_addr #1 !dbg !1081 !guid !1082 {
start:
  %_3 = load ptr, ptr %self, align 8, !dbg !1083, !nonnull !25, !align !1062, !noundef !25
  %_3.val = load ptr, ptr %_3, align 8, !dbg !1084, !nonnull !25, !noundef !25
  %ptr_addr.i.i = ptrtoint ptr %_3.val to i64, !dbg !1085
; call core::fmt::pointer_fmt_inner
  %0 = tail call noundef zeroext i1 @_RNvNtCsjIpoRzUjyHQ_4core3fmt17pointer_fmt_inner(i64 noundef %ptr_addr.i.i, ptr noalias nofree noundef nonnull align 8 dereferenceable(24) %f), !dbg !1098
  ret i1 %0, !dbg !1100
}

; <runtime_lab::process::ReaderTask as core::ops::drop::Drop>::drop
; Function Attrs: uwtable
define void @_RNvXs_NtCs5sHeypWcCKR_11runtime_lab7processNtB4_10ReaderTaskNtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4drop(ptr noalias nofree noundef readonly align 8 captures(address, read_provenance) dereferenceable(8) %self) unnamed_addr #1 !dbg !1101 !guid !1103 {
start:
; call <tokio::runtime::task::raw::RawTask>::remote_abort
  tail call void @_RNvMs_NtNtNtCs3EIJ1qnJmKW_5tokio7runtime4task7harnessNtNtB6_3raw7RawTask12remote_abort(ptr noalias nofree noundef nonnull readonly align 8 captures(address, read_provenance) dereferenceable(8) %self), !dbg !1104
  ret void, !dbg !1111
}

; Function Attrs: nounwind uwtable
declare noundef range(i32 0, 10) i32 @rust_eh_personality(i32 noundef, i32 noundef, i64 noundef, ptr noundef, ptr noundef) unnamed_addr #5

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(ptr captures(none)) #6

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(inaccessiblemem: write)
declare void @llvm.assume(i1 noundef) #7

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.memcpy.p0.p0.i64(ptr noalias writeonly captures(none), ptr noalias readonly captures(none), i64, i1 immarg) #6

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(ptr captures(none)) #6

; core::panicking::panic_in_cleanup
; Function Attrs: cold minsize noinline noreturn nounwind optsize uwtable
declare void @_RNvNtCsjIpoRzUjyHQ_4core9panicking16panic_in_cleanup() unnamed_addr #8

; <std::sys::sync::mutex::pthread::Mutex as core::ops::drop::Drop>::drop
; Function Attrs: uwtable
declare void @_RNvXs_NtNtNtNtCs1SSuMAdGM58_3std3sys4sync5mutex7pthreadNtB4_5MutexNtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4drop(ptr noalias nofree noundef align 8 dereferenceable(8)) unnamed_addr #1

; <std::sys::pal::unix::sync::mutex::Mutex as core::ops::drop::Drop>::drop
; Function Attrs: uwtable
declare void @_RNvXs2_NtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutexNtB5_5MutexNtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4drop(ptr noundef nonnull align 8) unnamed_addr #1

; core::panicking::assert_failed_inner
; Function Attrs: cold minsize noinline noreturn optsize uwtable
declare void @_RNvNtCsjIpoRzUjyHQ_4core9panicking19assert_failed_inner(i8 noundef range(i8 0, 3), ptr noundef nonnull, ptr noalias nofree noundef readonly align 8 captures(address, read_provenance) dereferenceable(32), ptr noundef nonnull, ptr noalias nofree noundef readonly align 8 captures(address, read_provenance) dereferenceable(32), ptr noundef, ptr, ptr noalias nofree noundef readonly align 8 captures(address, read_provenance) dereferenceable(24)) unnamed_addr #2

; <core::io::error::Error>::new::<&str>
; Function Attrs: noinline uwtable
declare noundef nonnull ptr @_RINvMNtNtCs6zY7rJBZy9D_5alloc2io5errorNtNtNtCsjIpoRzUjyHQ_4core2io5error5Error3newReECs1SSuMAdGM58_3std(i8 noundef range(i8 0, 44), ptr noalias nofree noundef nonnull readonly captures(address, read_provenance), i64 noundef) unnamed_addr #4

; <std::sys::pal::unix::sync::mutex::Mutex>::init
; Function Attrs: uwtable
declare void @_RNvMNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutexNtB2_5Mutex4init(ptr noundef nonnull align 8) unnamed_addr #1

; <tokio::runtime::builder::Builder>::new_multi_thread
; Function Attrs: uwtable
declare void @_RNvMNtNtCs3EIJ1qnJmKW_5tokio7runtime7builderNtB2_7Builder16new_multi_thread(ptr dead_on_unwind noalias nofree noundef writable sret([264 x i8]) align 8 captures(address) dereferenceable(264)) unnamed_addr #1

; <tokio::runtime::builder::Builder>::worker_threads
; Function Attrs: uwtable
declare noundef nonnull align 8 ptr @_RNvMNtNtCs3EIJ1qnJmKW_5tokio7runtime7builderNtB2_7Builder14worker_threads(ptr noalias nofree noundef align 8 dereferenceable(264), i64 noundef, ptr noalias nofree noundef readonly align 8 captures(address, read_provenance) dereferenceable(24)) unnamed_addr #1

; <tokio::runtime::builder::Builder>::build
; Function Attrs: uwtable
declare void @_RNvMNtNtCs3EIJ1qnJmKW_5tokio7runtime7builderNtB2_7Builder5build(ptr dead_on_unwind noalias nofree noundef writable sret([88 x i8]) align 8 captures(address) dereferenceable(88), ptr noalias nofree noundef align 8 dereferenceable(264)) unnamed_addr #1

; <tokio::runtime::builder::Builder>::new_current_thread
; Function Attrs: uwtable
declare void @_RNvMNtNtCs3EIJ1qnJmKW_5tokio7runtime7builderNtB2_7Builder18new_current_thread(ptr dead_on_unwind noalias nofree noundef writable sret([264 x i8]) align 8 captures(address) dereferenceable(264)) unnamed_addr #1

; std::panicking::panic_count::is_zero_slow_path
; Function Attrs: cold noinline uwtable
declare noundef zeroext i1 @_RNvNtNtCs1SSuMAdGM58_3std9panicking11panic_count17is_zero_slow_path() unnamed_addr #9

; __rustc::__rust_dealloc
; Function Attrs: nounwind allockind("free") uwtable
declare void @_RNvCsdtSMxSA38aw_7___rustc14___rust_dealloc(ptr allocptr noundef nonnull captures(address), i64 noundef, i64 noundef range(i64 1, -9223372036854775807)) unnamed_addr #10

; __rustc::__rust_no_alloc_shim_is_unstable_v2
; Function Attrs: nounwind uwtable
declare void @_RNvCsdtSMxSA38aw_7___rustc35___rust_no_alloc_shim_is_unstable_v2() unnamed_addr #5

; __rustc::__rust_alloc
; Function Attrs: nounwind allockind("alloc,uninitialized,aligned") allocsize(0) uwtable
declare noalias noundef ptr @_RNvCsdtSMxSA38aw_7___rustc12___rust_alloc(i64 noundef, i64 allocalign noundef range(i64 1, -9223372036854775807)) unnamed_addr #11

; <tokio::runtime::task::raw::RawTask>::remote_abort
; Function Attrs: uwtable
declare void @_RNvMs_NtNtNtCs3EIJ1qnJmKW_5tokio7runtime4task7harnessNtNtB6_3raw7RawTask12remote_abort(ptr noalias nofree noundef readonly align 8 captures(address, read_provenance) dereferenceable(8)) unnamed_addr #1

; <std::sys::pal::unix::sync::mutex::Mutex>::lock
; Function Attrs: uwtable
declare void @_RNvMNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutexNtB2_5Mutex4lock(ptr noundef nonnull align 8) unnamed_addr #1

; alloc::alloc::handle_alloc_error
; Function Attrs: cold minsize noreturn optsize uwtable
declare void @_RNvNtCs6zY7rJBZy9D_5alloc5alloc18handle_alloc_error(i64 noundef range(i64 1, -9223372036854775807), i64 noundef) unnamed_addr #12

; <alloc::sync::Arc<dyn for<'a, 'b> core::ops::function::Fn<(&'a tokio::runtime::task_hooks::TaskMeta<'b>,), Output = ()> + core::marker::Send + core::marker::Sync>>::drop_slow
; Function Attrs: noinline uwtable
declare void @_RNvMsn_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcDG0_INtNtNtCsjIpoRzUjyHQ_4core3ops8function2FnTRL1_INtNtNtCs3EIJ1qnJmKW_5tokio7runtime10task_hooks8TaskMetaL0_EEEp6OutputuNtNtBR_6marker4SendNtB2G_4SyncEL_E9drop_slowB1C_(ptr noalias nofree noundef align 8 dereferenceable(16)) unnamed_addr #4

; <alloc::sync::Arc<dyn core::ops::function::Fn<(), Output = alloc::string::String> + core::marker::Send + core::marker::Sync>>::drop_slow
; Function Attrs: noinline uwtable
declare void @_RNvMsn_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcDINtNtNtCsjIpoRzUjyHQ_4core3ops8function2FnuEp6OutputNtNtB7_6string6StringNtNtBO_6marker4SendNtB1U_4SyncEL_E9drop_slowCs3EIJ1qnJmKW_5tokio(ptr noalias nofree noundef align 8 dereferenceable(16)) unnamed_addr #4

; <alloc::sync::Arc<dyn core::ops::function::Fn<(), Output = ()> + core::marker::Send + core::marker::Sync>>::drop_slow
; Function Attrs: noinline uwtable
declare void @_RNvMsn_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcDINtNtNtCsjIpoRzUjyHQ_4core3ops8function2FnuEp6OutputuNtNtBO_6marker4SendNtB1A_4SyncEL_E9drop_slowCs3EIJ1qnJmKW_5tokio(ptr noalias nofree noundef align 8 dereferenceable(16)) unnamed_addr #4

; <core::fmt::Formatter>::write_str
; Function Attrs: uwtable
declare noundef zeroext i1 @_RNvMsa_NtCsjIpoRzUjyHQ_4core3fmtNtB5_9Formatter9write_str(ptr noalias nofree noundef align 8 dereferenceable(24), ptr noalias nofree noundef nonnull readonly captures(address, read_provenance), i64 noundef) unnamed_addr #1

; <core::fmt::Formatter>::debug_tuple_field1_finish
; Function Attrs: uwtable
declare noundef zeroext i1 @_RNvMsa_NtCsjIpoRzUjyHQ_4core3fmtNtB5_9Formatter25debug_tuple_field1_finish(ptr noalias nofree noundef align 8 dereferenceable(24), ptr noalias nofree noundef nonnull readonly captures(address, read_provenance), i64 noundef, ptr noundef nonnull, ptr noalias nofree noundef readonly align 8 captures(address, read_provenance) dereferenceable(32)) unnamed_addr #1

; <std::sys::pal::unix::sync::mutex::Mutex>::unlock
; Function Attrs: uwtable
declare void @_RNvMNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutexNtB2_5Mutex6unlock(ptr noundef nonnull align 8) unnamed_addr #1

; core::fmt::pointer_fmt_inner
; Function Attrs: uwtable
declare noundef zeroext i1 @_RNvNtCsjIpoRzUjyHQ_4core3fmt17pointer_fmt_inner(i64 noundef, ptr noalias nofree noundef align 8 dereferenceable(24)) unnamed_addr #1

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(inaccessiblemem: readwrite)
declare void @llvm.experimental.noalias.scope.decl(metadata) #13

attributes #0 = { cold uwtable "frame-pointer"="non-leaf" "probe-stack"="inline-asm" "target-cpu"="apple-m1" }
attributes #1 = { uwtable "frame-pointer"="non-leaf" "probe-stack"="inline-asm" "target-cpu"="apple-m1" }
attributes #2 = { cold minsize noinline noreturn optsize uwtable "frame-pointer"="non-leaf" "probe-stack"="inline-asm" "target-cpu"="apple-m1" }
attributes #3 = { mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: write) uwtable "frame-pointer"="non-leaf" "probe-stack"="inline-asm" "target-cpu"="apple-m1" }
attributes #4 = { noinline uwtable "frame-pointer"="non-leaf" "probe-stack"="inline-asm" "target-cpu"="apple-m1" }
attributes #5 = { nounwind uwtable "frame-pointer"="non-leaf" "probe-stack"="inline-asm" "target-cpu"="apple-m1" }
attributes #6 = { mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #7 = { mustprogress nocallback nofree nosync nounwind willreturn memory(inaccessiblemem: write) }
attributes #8 = { cold minsize noinline noreturn nounwind optsize uwtable "frame-pointer"="non-leaf" "probe-stack"="inline-asm" "target-cpu"="apple-m1" }
attributes #9 = { cold noinline uwtable "frame-pointer"="non-leaf" "probe-stack"="inline-asm" "target-cpu"="apple-m1" }
attributes #10 = { nounwind allockind("free") uwtable "alloc-family"="__rust_alloc" "frame-pointer"="non-leaf" "probe-stack"="inline-asm" "target-cpu"="apple-m1" }
attributes #11 = { nounwind allockind("alloc,uninitialized,aligned") allocsize(0) uwtable "alloc-family"="__rust_alloc" "alloc-variant-zeroed"="_RNvCsdtSMxSA38aw_7___rustc19___rust_alloc_zeroed" "frame-pointer"="non-leaf" "probe-stack"="inline-asm" "target-cpu"="apple-m1" }
attributes #12 = { cold minsize noreturn optsize uwtable "frame-pointer"="non-leaf" "probe-stack"="inline-asm" "target-cpu"="apple-m1" }
attributes #13 = { nocallback nofree nosync nounwind willreturn memory(inaccessiblemem: readwrite) }
attributes #14 = { nounwind }
attributes #15 = { noreturn }
attributes #16 = { cold noreturn nounwind }
attributes #17 = { cold }
attributes #18 = { noinline }
attributes #19 = { noinline noreturn }

!llvm.module.flags = !{!9, !10, !11, !12, !13}
!llvm.ident = !{!14}
!llvm.dbg.cu = !{!15}

!0 = !{i64 657940761162781628}
!1 = !{i64 3682150196475547231}
!2 = !{i64 2614949129242066116}
!3 = !{i64 -8039224064211202245}
!4 = !{i64 -6031758357216243151}
!5 = !{i64 -5020863954698219228}
!6 = !{i64 -6490102129869979162}
!7 = !{i64 -8535941138024625122}
!8 = !{i64 -7034992018264122642}
!9 = !{i32 8, !"PIC Level", i32 2}
!10 = !{i32 7, !"uwtable", i32 2}
!11 = !{i32 7, !"frame-pointer", i32 1}
!12 = !{i32 7, !"Dwarf Version", i32 4}
!13 = !{i32 2, !"Debug Info Version", i32 3}
!14 = !{!"rustc version 1.99.0 (b940084d7 2026-09-28)"}
!15 = distinct !DICompileUnit(language: DW_LANG_Rust, file: !16, producer: "clang LLVM (rustc version 1.99.0 (b940084d7 2026-09-28))", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, splitDebugInlining: false, nameTableKind: None)
!16 = !DIFile(filename: "src/lib.rs/@/runtime_lab.3fa11a97c2f4d693-cgu.0", directory: "/Users/juanwang/Desktop/tutorials/cpp-rust/bench/runtime-lab")
!17 = distinct !DISubprogram(name: "initialize<std::sys::pal::unix::sync::mutex::Mutex, std::sys::sync::mutex::pthread::{impl#0}::get::{closure_env#0}>", linkageName: "_RINvMNtNtNtCs1SSuMAdGM58_3std3sys4sync8once_boxINtB3_7OnceBoxNtNtNtNtNtB7_3pal4unix4sync5mutex5MutexE10initializeNCNvMNtNtB5_5mutex7pthreadNtB1S_5Mutex3get0ECs5sHeypWcCKR_11runtime_lab", scope: !19, file: !18, line: 62, type: !24, scopeLine: 62, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !25)
!18 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/std/src/sys/sync/once_box.rs", directory: "", checksumkind: CSK_MD5, checksum: "f1000a4c21cf79dde92428b81bc214bf")
!19 = !DINamespace(name: "OnceBox", scope: !20)
!20 = !DINamespace(name: "once_box", scope: !21)
!21 = !DINamespace(name: "sync", scope: !22)
!22 = !DINamespace(name: "sys", scope: !23)
!23 = !DINamespace(name: "std", scope: null)
!24 = !DISubroutineType(types: !25)
!25 = !{}
!26 = !{i64 -1274460306778932815}
!27 = !DILocation(line: 23, column: 36, scope: !28, inlinedAt: !34)
!28 = distinct !DISubprogram(name: "{closure#0}", linkageName: "_RNCNvMNtNtNtNtCs1SSuMAdGM58_3std3sys4sync5mutex7pthreadNtB4_5Mutex3get0Cs5sHeypWcCKR_11runtime_lab", scope: !30, file: !29, line: 22, type: !24, scopeLine: 22, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !25)
!29 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/std/src/sys/sync/mutex/pthread.rs", directory: "", checksumkind: CSK_MD5, checksum: "868c5ca80a36ed03df9b889476107b5b")
!30 = !DINamespace(name: "get", scope: !31)
!31 = !DINamespace(name: "{impl#0}", scope: !32)
!32 = !DINamespace(name: "pthread", scope: !33)
!33 = !DINamespace(name: "mutex", scope: !21)
!34 = distinct !DILocation(line: 63, column: 72, scope: !17)
!35 = !DILocation(line: 13, column: 9, scope: !36, inlinedAt: !43)
!36 = distinct !DISubprogram(name: "new", linkageName: "_RNvMNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutexNtB2_5Mutex3new", scope: !38, file: !37, line: 12, type: !24, scopeLine: 12, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !25)
!37 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/std/src/sys/pal/unix/sync/mutex.rs", directory: "", checksumkind: CSK_MD5, checksum: "b83d52c9b44a6ebaddfc550875bb2635")
!38 = !DINamespace(name: "Mutex", scope: !39)
!39 = !DINamespace(name: "mutex", scope: !40)
!40 = !DINamespace(name: "sync", scope: !41)
!41 = !DINamespace(name: "unix", scope: !42)
!42 = !DINamespace(name: "pal", scope: !22)
!43 = distinct !DILocation(line: 23, column: 36, scope: !28, inlinedAt: !34)
!44 = !DILocation(line: 128, column: 9, scope: !45, inlinedAt: !49)
!45 = distinct !DISubprogram(name: "alloc", linkageName: "_RNvNtCs6zY7rJBZy9D_5alloc5alloc5alloc", scope: !47, file: !46, line: 124, type: !24, scopeLine: 124, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !25)
!46 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/alloc/src/alloc.rs", directory: "", checksumkind: CSK_MD5, checksum: "87b4d0ba26e1dfe94542079de6981d97")
!47 = !DINamespace(name: "alloc", scope: !48)
!48 = !DINamespace(name: "alloc", scope: null)
!49 = distinct !DILocation(line: 302, column: 73, scope: !50, inlinedAt: !53)
!50 = distinct !DILexicalBlock(scope: !51, file: !46, line: 301, column: 13)
!51 = distinct !DISubprogram(name: "alloc_impl_runtime", linkageName: "_RNvMs0_NtCs6zY7rJBZy9D_5alloc5allocNtB5_6Global18alloc_impl_runtime", scope: !52, file: !46, line: 297, type: !24, scopeLine: 297, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !25)
!52 = !DINamespace(name: "Global", scope: !47)
!53 = distinct !DILocation(line: 424, column: 9, scope: !54, inlinedAt: !55)
!54 = distinct !DISubprogram(name: "alloc_impl", linkageName: "_RNvMs0_NtCs6zY7rJBZy9D_5alloc5allocNtB5_6Global10alloc_impl", scope: !52, file: !46, line: 423, type: !24, scopeLine: 423, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !25)
!55 = distinct !DILocation(line: 541, column: 14, scope: !56, inlinedAt: !58)
!56 = distinct !DISubprogram(name: "allocate", linkageName: "_RNvXs1_NtCs6zY7rJBZy9D_5alloc5allocNtB5_6GlobalNtNtCsjIpoRzUjyHQ_4core5alloc9Allocator8allocate", scope: !57, file: !46, line: 540, type: !24, scopeLine: 540, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !25)
!57 = !DINamespace(name: "{impl#3}", scope: !47)
!58 = distinct !DILocation(line: 251, column: 18, scope: !59, inlinedAt: !62)
!59 = distinct !DISubprogram(name: "box_new_uninit", linkageName: "_RNvNtCs6zY7rJBZy9D_5alloc5boxed14box_new_uninit", scope: !61, file: !60, line: 250, type: !24, scopeLine: 250, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !25)
!60 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/alloc/src/boxed.rs", directory: "", checksumkind: CSK_MD5, checksum: "d08167ce38615623852d82b0b0764c28")
!61 = !DINamespace(name: "boxed", scope: !48)
!62 = distinct !DILocation(line: 290, column: 19, scope: !63, inlinedAt: !65)
!63 = distinct !DISubprogram(name: "new<std::sys::pal::unix::sync::mutex::Mutex>", linkageName: "_RNvMNtCs6zY7rJBZy9D_5alloc5boxedINtB2_3BoxNtNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutex5MutexE3newCs5sHeypWcCKR_11runtime_lab", scope: !64, file: !60, line: 288, type: !24, scopeLine: 288, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !25)
!64 = !DINamespace(name: "{impl#0}", scope: !61)
!65 = distinct !DILocation(line: 361, column: 9, scope: !66, inlinedAt: !67)
!66 = distinct !DISubprogram(name: "pin<std::sys::pal::unix::sync::mutex::Mutex>", linkageName: "_RNvMNtCs6zY7rJBZy9D_5alloc5boxedINtB2_3BoxNtNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutex5MutexE3pinCs5sHeypWcCKR_11runtime_lab", scope: !64, file: !60, line: 360, type: !24, scopeLine: 360, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !25)
!67 = distinct !DILocation(line: 23, column: 27, scope: !28, inlinedAt: !34)
!68 = !{!69}
!69 = distinct !{!69, !70, !"_RNvMNtCs6zY7rJBZy9D_5alloc5boxedINtB2_3BoxNtNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutex5MutexE3newCs5sHeypWcCKR_11runtime_lab: %x"}
!70 = distinct !{!70, !"_RNvMNtCs6zY7rJBZy9D_5alloc5boxedINtB2_3BoxNtNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutex5MutexE3newCs5sHeypWcCKR_11runtime_lab"}
!71 = !DILocation(line: 130, column: 9, scope: !45, inlinedAt: !49)
!72 = !DILocation(line: 251, column: 11, scope: !59, inlinedAt: !62)
!73 = !DILocation(line: 251, column: 5, scope: !59, inlinedAt: !62)
!74 = !{!"branch_weights", !"expected", i32 1, i32 2000}
!75 = !DILocation(line: 253, column: 19, scope: !59, inlinedAt: !62)
!76 = !DILocation(line: 847, column: 1, scope: !77, inlinedAt: !81)
!77 = distinct !DISubprogram(name: "drop_glue<std::sys::pal::unix::sync::mutex::Mutex>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutex5MutexECs5sHeypWcCKR_11runtime_lab", scope: !79, file: !78, line: 847, type: !24, scopeLine: 847, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !25)
!78 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/ptr/mod.rs", directory: "", checksumkind: CSK_MD5, checksum: "59033ebc630da002040513c25c9de121")
!79 = !DINamespace(name: "ptr", scope: !80)
!80 = !DINamespace(name: "core", scope: null)
!81 = distinct !DILocation(line: 296, column: 5, scope: !63, inlinedAt: !65)
!82 = !DILocation(line: 288, column: 5, scope: !63, inlinedAt: !65)
!83 = !DILocation(line: 0, scope: !17)
!84 = !DILocation(line: 293, column: 56, scope: !85, inlinedAt: !65)
!85 = distinct !DILexicalBlock(scope: !63, file: !60, line: 290, column: 9)
!86 = !DILocation(line: 23, column: 53, scope: !28, inlinedAt: !34)
!87 = !DILocation(line: 25, column: 35, scope: !88, inlinedAt: !34)
!88 = distinct !DILexicalBlock(scope: !28, file: !29, line: 23, column: 13)
!89 = !DILocation(line: 27, column: 9, scope: !28, inlinedAt: !34)
!90 = !DILocation(line: 22, column: 30, scope: !28, inlinedAt: !34)
!91 = !DILocation(line: 4095, column: 17, scope: !92, inlinedAt: !97)
!92 = distinct !DISubprogram(name: "atomic_compare_exchange<*mut std::sys::pal::unix::sync::mutex::Mutex>", linkageName: "_RINvNtNtCsjIpoRzUjyHQ_4core4sync6atomic23atomic_compare_exchangeONtNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutex5MutexECs5sHeypWcCKR_11runtime_lab", scope: !94, file: !93, line: 4063, type: !96, scopeLine: 4063, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !25)
!93 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/sync/atomic.rs", directory: "", checksumkind: CSK_MD5, checksum: "51c6a96ef01c6a3d76d0125641245f4c")
!94 = !DINamespace(name: "atomic", scope: !95)
!95 = !DINamespace(name: "sync", scope: !80)
!96 = !DISubroutineType(cc: DW_CC_nocall, types: !25)
!97 = distinct !DILocation(line: 1955, column: 18, scope: !98, inlinedAt: !100)
!98 = distinct !DISubprogram(name: "compare_exchange<std::sys::pal::unix::sync::mutex::Mutex>", linkageName: "_RNvMs3_NtNtCsjIpoRzUjyHQ_4core4sync6atomicINtB5_6AtomicONtNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutex5MutexE16compare_exchangeCs5sHeypWcCKR_11runtime_lab", scope: !99, file: !93, line: 1947, type: !24, scopeLine: 1947, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !25)
!99 = !DINamespace(name: "Atomic", scope: !94)
!100 = !DILocation(line: 64, column: 24, scope: !101)
!101 = distinct !DILexicalBlock(scope: !17, file: !18, line: 63, column: 9)
!102 = !DILocation(line: 64, column: 9, scope: !101)
!103 = !DILocation(line: 847, column: 1, scope: !77, inlinedAt: !104)
!104 = distinct !DILocation(line: 847, column: 1, scope: !105, inlinedAt: !106)
!105 = distinct !DISubprogram(name: "drop_glue<alloc::boxed::Box<std::sys::pal::unix::sync::mutex::Mutex, alloc::alloc::Global>>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc5boxed3BoxNtNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutex5MutexEECs5sHeypWcCKR_11runtime_lab", scope: !79, file: !78, line: 847, type: !96, scopeLine: 847, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !25)
!106 = distinct !DILocation(line: 1049, column: 1, scope: !107, inlinedAt: !110)
!107 = distinct !DISubprogram(name: "drop<alloc::boxed::Box<std::sys::pal::unix::sync::mutex::Mutex, alloc::alloc::Global>>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3mem4dropINtNtCs6zY7rJBZy9D_5alloc5boxed3BoxNtNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutex5MutexEECs5sHeypWcCKR_11runtime_lab", scope: !109, file: !108, line: 1045, type: !24, scopeLine: 1045, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !25)
!108 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/mem/mod.rs", directory: "", checksumkind: CSK_MD5, checksum: "1dbabb11724cf003c9a4ded983e1d0cd")
!109 = !DINamespace(name: "mem", scope: !80)
!110 = !DILocation(line: 69, column: 17, scope: !111)
!111 = distinct !DILexicalBlock(scope: !101, file: !18, line: 66, column: 13)
!112 = !DILocation(line: 175, column: 14, scope: !113, inlinedAt: !114)
!113 = distinct !DISubprogram(name: "dealloc_nonnull", linkageName: "_RNvNtCs6zY7rJBZy9D_5alloc5alloc15dealloc_nonnull", scope: !47, file: !46, line: 174, type: !24, scopeLine: 174, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !25)
!114 = distinct !DILocation(line: 321, column: 22, scope: !115, inlinedAt: !116)
!115 = distinct !DISubprogram(name: "deallocate_impl_runtime", linkageName: "_RNvMs0_NtCs6zY7rJBZy9D_5alloc5allocNtB5_6Global23deallocate_impl_runtime", scope: !52, file: !46, line: 311, type: !24, scopeLine: 311, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !25)
!116 = distinct !DILocation(line: 436, column: 9, scope: !117, inlinedAt: !118)
!117 = distinct !DISubprogram(name: "deallocate_impl", linkageName: "_RNvMs0_NtCs6zY7rJBZy9D_5alloc5allocNtB5_6Global15deallocate_impl", scope: !52, file: !46, line: 435, type: !24, scopeLine: 435, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !25)
!118 = distinct !DILocation(line: 554, column: 23, scope: !119, inlinedAt: !120)
!119 = distinct !DISubprogram(name: "deallocate", linkageName: "_RNvXs1_NtCs6zY7rJBZy9D_5alloc5allocNtB5_6GlobalNtNtCsjIpoRzUjyHQ_4core5alloc9Allocator10deallocate", scope: !57, file: !46, line: 552, type: !96, scopeLine: 552, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !25)
!120 = distinct !DILocation(line: 2000, column: 24, scope: !121, inlinedAt: !125)
!121 = distinct !DILexicalBlock(scope: !122, file: !60, line: 1998, column: 13)
!122 = distinct !DILexicalBlock(scope: !123, file: !60, line: 1995, column: 9)
!123 = distinct !DISubprogram(name: "drop<std::sys::pal::unix::sync::mutex::Mutex, alloc::alloc::Global>", linkageName: "_RNvXs8_NtCs6zY7rJBZy9D_5alloc5boxedINtB5_3BoxNtNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutex5MutexENtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4dropCs5sHeypWcCKR_11runtime_lab", scope: !124, file: !60, line: 1992, type: !96, scopeLine: 1992, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !25)
!124 = !DINamespace(name: "{impl#10}", scope: !61)
!125 = distinct !DILocation(line: 847, column: 1, scope: !105, inlinedAt: !106)
!126 = !DILocation(line: 847, column: 1, scope: !105, inlinedAt: !106)
!127 = !DILocation(line: 175, column: 14, scope: !113, inlinedAt: !128)
!128 = distinct !DILocation(line: 321, column: 22, scope: !115, inlinedAt: !129)
!129 = distinct !DILocation(line: 436, column: 9, scope: !117, inlinedAt: !130)
!130 = distinct !DILocation(line: 554, column: 23, scope: !119, inlinedAt: !131)
!131 = distinct !DILocation(line: 2000, column: 24, scope: !121, inlinedAt: !132)
!132 = distinct !DILocation(line: 847, column: 1, scope: !105, inlinedAt: !106)
!133 = !DILocation(line: 71, column: 13, scope: !101)
!134 = !DILocation(line: 1352, column: 9, scope: !135, inlinedAt: !139)
!135 = distinct !DISubprogram(name: "new_unchecked<&std::sys::pal::unix::sync::mutex::Mutex>", linkageName: "_RNvMs4_NtCsjIpoRzUjyHQ_4core3pinINtB5_3PinRNtNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutex5MutexE13new_uncheckedCs5sHeypWcCKR_11runtime_lab", scope: !137, file: !136, line: 1351, type: !24, scopeLine: 1351, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !25)
!136 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/pin.rs", directory: "", checksumkind: CSK_MD5, checksum: "89fa63aed274c2b31ade6f589f98d9de")
!137 = !DINamespace(name: "Pin", scope: !138)
!138 = !DINamespace(name: "pin", scope: !80)
!139 = !DILocation(line: 0, scope: !101)
!140 = !DILocation(line: 73, column: 6, scope: !17)
!141 = distinct !DISubprogram(name: "drop_glue<core::pin::Pin<alloc::boxed::Box<std::sys::pal::unix::sync::mutex::Mutex, alloc::alloc::Global>>>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtB4_3pin3PinINtNtCs6zY7rJBZy9D_5alloc5boxed3BoxNtNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutex5MutexEEECs5sHeypWcCKR_11runtime_lab", scope: !79, file: !78, line: 847, type: !96, scopeLine: 847, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !25)
!142 = !{i64 -6288517974518096644}
!143 = !DILocation(line: 847, column: 1, scope: !77, inlinedAt: !144)
!144 = distinct !DILocation(line: 847, column: 1, scope: !105, inlinedAt: !145)
!145 = distinct !DILocation(line: 847, column: 1, scope: !141)
!146 = !DILocation(line: 175, column: 14, scope: !113, inlinedAt: !147)
!147 = distinct !DILocation(line: 321, column: 22, scope: !115, inlinedAt: !148)
!148 = distinct !DILocation(line: 436, column: 9, scope: !117, inlinedAt: !149)
!149 = distinct !DILocation(line: 554, column: 23, scope: !119, inlinedAt: !150)
!150 = distinct !DILocation(line: 2000, column: 24, scope: !121, inlinedAt: !151)
!151 = distinct !DILocation(line: 847, column: 1, scope: !105, inlinedAt: !145)
!152 = !DILocation(line: 847, column: 1, scope: !105, inlinedAt: !145)
!153 = !DILocation(line: 175, column: 14, scope: !113, inlinedAt: !154)
!154 = distinct !DILocation(line: 321, column: 22, scope: !115, inlinedAt: !155)
!155 = distinct !DILocation(line: 436, column: 9, scope: !117, inlinedAt: !156)
!156 = distinct !DILocation(line: 554, column: 23, scope: !119, inlinedAt: !157)
!157 = distinct !DILocation(line: 2000, column: 24, scope: !121, inlinedAt: !158)
!158 = distinct !DILocation(line: 847, column: 1, scope: !105, inlinedAt: !145)
!159 = !DILocation(line: 847, column: 1, scope: !141)
!160 = distinct !DISubprogram(name: "drop_glue<std::sync::poison::PoisonError<std::sync::poison::mutex::MutexGuard<runtime_lab::process::Capture>>>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtCs1SSuMAdGM58_3std4sync6poison11PoisonErrorINtNtBE_5mutex10MutexGuardNtNtCs5sHeypWcCKR_11runtime_lab7process7CaptureEEEB1T_", scope: !79, file: !78, line: 847, type: !96, scopeLine: 847, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !25)
!161 = !{i64 -8389457827676883579}
!162 = !DILocation(line: 745, column: 13, scope: !163, inlinedAt: !169)
!163 = distinct !DISubprogram(name: "drop<runtime_lab::process::Capture>", linkageName: "_RNvXsc_NtNtNtCs1SSuMAdGM58_3std4sync6poison5mutexINtB5_10MutexGuardNtNtCs5sHeypWcCKR_11runtime_lab7process7CaptureENtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4dropB17_", scope: !165, file: !164, line: 743, type: !96, scopeLine: 743, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !25)
!164 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/std/src/sync/poison/mutex.rs", directory: "", checksumkind: CSK_MD5, checksum: "78bfced6bc07033bbd081e9ae0e8ed7e")
!165 = !DINamespace(name: "{impl#14}", scope: !166)
!166 = !DINamespace(name: "mutex", scope: !167)
!167 = !DINamespace(name: "poison", scope: !168)
!168 = !DINamespace(name: "sync", scope: !23)
!169 = distinct !DILocation(line: 847, column: 1, scope: !170, inlinedAt: !171)
!170 = distinct !DISubprogram(name: "drop_glue<std::sync::poison::mutex::MutexGuard<runtime_lab::process::Capture>>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtNtCs1SSuMAdGM58_3std4sync6poison5mutex10MutexGuardNtNtCs5sHeypWcCKR_11runtime_lab7process7CaptureEEB1A_", scope: !79, file: !78, line: 847, type: !96, scopeLine: 847, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !25)
!171 = distinct !DILocation(line: 847, column: 1, scope: !160)
!172 = !DILocation(line: 126, column: 13, scope: !173, inlinedAt: !176)
!173 = distinct !DISubprogram(name: "done", linkageName: "_RNvMNtNtCs1SSuMAdGM58_3std4sync6poisonNtB2_4Flag4done", scope: !175, file: !174, line: 125, type: !96, scopeLine: 125, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !25)
!174 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/std/src/sync/poison.rs", directory: "", checksumkind: CSK_MD5, checksum: "355e7733b3796b99069efee3729cec38")
!175 = !DINamespace(name: "Flag", scope: !167)
!176 = distinct !DILocation(line: 745, column: 30, scope: !163, inlinedAt: !169)
!177 = !DILocation(line: 3994, column: 24, scope: !178, inlinedAt: !179)
!178 = distinct !DISubprogram(name: "atomic_load<usize>", linkageName: "_RINvNtNtCsjIpoRzUjyHQ_4core4sync6atomic11atomic_loadjECs5sHeypWcCKR_11runtime_lab", scope: !94, file: !93, line: 3990, type: !96, scopeLine: 3990, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !25)
!179 = distinct !DILocation(line: 2916, column: 26, scope: !180, inlinedAt: !181)
!180 = distinct !DISubprogram(name: "load", linkageName: "_RNvMs1g_NtNtCsjIpoRzUjyHQ_4core4sync6atomicINtB6_6AtomicjE4load", scope: !99, file: !93, line: 2914, type: !24, scopeLine: 2914, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !25)
!181 = distinct !DILocation(line: 465, column: 31, scope: !182, inlinedAt: !186)
!182 = distinct !DISubprogram(name: "count_is_zero", linkageName: "_RNvNtNtCs1SSuMAdGM58_3std9panicking11panic_count13count_is_zero", scope: !184, file: !183, line: 464, type: !24, scopeLine: 464, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !25)
!183 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/std/src/panicking.rs", directory: "", checksumkind: CSK_MD5, checksum: "ccf6489229275477729282fe1b676b41")
!184 = !DINamespace(name: "panic_count", scope: !185)
!185 = !DINamespace(name: "panicking", scope: !23)
!186 = distinct !DILocation(line: 606, column: 6, scope: !187, inlinedAt: !188)
!187 = distinct !DISubprogram(name: "panicking", linkageName: "_RNvNtCs1SSuMAdGM58_3std9panicking9panicking", scope: !185, file: !183, line: 605, type: !24, scopeLine: 605, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !25)
!188 = distinct !DILocation(line: 221, column: 5, scope: !189, inlinedAt: !193)
!189 = distinct !DISubprogram(name: "panicking", linkageName: "_RNvNtNtCs1SSuMAdGM58_3std6thread9functions9panicking", scope: !191, file: !190, line: 220, type: !24, scopeLine: 220, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !25)
!190 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/std/src/thread/functions.rs", directory: "", checksumkind: CSK_MD5, checksum: "9b7a310fdb374e17e7524a15cd4faa45")
!191 = !DINamespace(name: "functions", scope: !192)
!192 = !DINamespace(name: "thread", scope: !23)
!193 = distinct !DILocation(line: 126, column: 32, scope: !173, inlinedAt: !176)
!194 = !DILocation(line: 465, column: 12, scope: !182, inlinedAt: !186)
!195 = !{!"branch_weights", !"expected", i32 2000, i32 1}
!196 = !DILocation(line: 477, column: 13, scope: !182, inlinedAt: !186)
!197 = !DILocation(line: 126, column: 32, scope: !173, inlinedAt: !176)
!198 = !DILocation(line: 3978, column: 24, scope: !199, inlinedAt: !200)
!199 = distinct !DISubprogram(name: "atomic_store<u8>", linkageName: "_RINvNtNtCsjIpoRzUjyHQ_4core4sync6atomic12atomic_storehECs5sHeypWcCKR_11runtime_lab", scope: !94, file: !93, line: 3974, type: !24, scopeLine: 3974, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !25)
!200 = distinct !DILocation(line: 793, column: 13, scope: !201, inlinedAt: !202)
!201 = distinct !DISubprogram(name: "store", linkageName: "_RNvMs2_NtNtCsjIpoRzUjyHQ_4core4sync6atomicINtB5_6AtomicbE5store", scope: !99, file: !93, line: 789, type: !24, scopeLine: 789, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !25)
!202 = distinct !DILocation(line: 127, column: 25, scope: !173, inlinedAt: !176)
!203 = !DILocation(line: 126, column: 9, scope: !173, inlinedAt: !176)
!204 = !DILocation(line: 3994, column: 24, scope: !205, inlinedAt: !206)
!205 = distinct !DISubprogram(name: "atomic_load<*mut std::sys::pal::unix::sync::mutex::Mutex>", linkageName: "_RINvNtNtCsjIpoRzUjyHQ_4core4sync6atomic11atomic_loadONtNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutex5MutexECs5sHeypWcCKR_11runtime_lab", scope: !94, file: !93, line: 3990, type: !24, scopeLine: 3990, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !25)
!206 = distinct !DILocation(line: 1765, column: 18, scope: !207, inlinedAt: !208)
!207 = distinct !DISubprogram(name: "load<std::sys::pal::unix::sync::mutex::Mutex>", linkageName: "_RNvMs3_NtNtCsjIpoRzUjyHQ_4core4sync6atomicINtB5_6AtomicONtNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutex5MutexE4loadCs5sHeypWcCKR_11runtime_lab", scope: !99, file: !93, line: 1763, type: !24, scopeLine: 1763, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !25)
!208 = distinct !DILocation(line: 43, column: 48, scope: !209, inlinedAt: !210)
!209 = distinct !DISubprogram(name: "get_unchecked<std::sys::pal::unix::sync::mutex::Mutex>", linkageName: "_RNvMNtNtNtCs1SSuMAdGM58_3std3sys4sync8once_boxINtB2_7OnceBoxNtNtNtNtNtB6_3pal4unix4sync5mutex5MutexE13get_uncheckedCs5sHeypWcCKR_11runtime_lab", scope: !19, file: !18, line: 42, type: !24, scopeLine: 42, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !25)
!210 = distinct !DILocation(line: 45, column: 27, scope: !211, inlinedAt: !213)
!211 = distinct !DISubprogram(name: "unlock", linkageName: "_RNvMNtNtNtNtCs1SSuMAdGM58_3std3sys4sync5mutex7pthreadNtB2_5Mutex6unlock", scope: !212, file: !29, line: 42, type: !24, scopeLine: 42, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !25)
!212 = !DINamespace(name: "Mutex", scope: !32)
!213 = distinct !DILocation(line: 746, column: 29, scope: !163, inlinedAt: !169)
!214 = !DILocation(line: 45, column: 43, scope: !211, inlinedAt: !213)
!215 = !DILocation(line: 847, column: 1, scope: !160)
!216 = distinct !DISubprogram(name: "drop_glue<std::sys::sync::once_box::OnceBox<std::sys::pal::unix::sync::mutex::Mutex>>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtNtCs1SSuMAdGM58_3std3sys4sync8once_box7OnceBoxNtNtNtNtNtBI_3pal4unix4sync5mutex5MutexEECs5sHeypWcCKR_11runtime_lab", scope: !79, file: !78, line: 847, type: !24, scopeLine: 847, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !25)
!217 = !{i64 7949401378814284806}
!218 = !{!219}
!219 = distinct !{!219, !220, !"_RNvXs1_NtNtNtCs1SSuMAdGM58_3std3sys4sync8once_boxINtB5_7OnceBoxNtNtNtNtNtB9_3pal4unix4sync5mutex5MutexENtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4dropCs5sHeypWcCKR_11runtime_lab: %self"}
!220 = distinct !{!220, !"_RNvXs1_NtNtNtCs1SSuMAdGM58_3std3sys4sync8once_boxINtB5_7OnceBoxNtNtNtNtNtB9_3pal4unix4sync5mutex5MutexENtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4dropCs5sHeypWcCKR_11runtime_lab"}
!221 = !DILocation(line: 847, column: 1, scope: !216)
!222 = !DILocation(line: 975, column: 22, scope: !223, inlinedAt: !224)
!223 = distinct !DISubprogram(name: "replace<*mut std::sys::pal::unix::sync::mutex::Mutex>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3mem7replaceONtNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutex5MutexECs5sHeypWcCKR_11runtime_lab", scope: !109, file: !108, line: 961, type: !24, scopeLine: 961, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !25)
!224 = distinct !DILocation(line: 57, column: 19, scope: !225, inlinedAt: !226)
!225 = distinct !DISubprogram(name: "take<std::sys::pal::unix::sync::mutex::Mutex>", linkageName: "_RNvMNtNtNtCs1SSuMAdGM58_3std3sys4sync8once_boxINtB2_7OnceBoxNtNtNtNtNtB6_3pal4unix4sync5mutex5MutexE4takeCs5sHeypWcCKR_11runtime_lab", scope: !19, file: !18, line: 56, type: !24, scopeLine: 56, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !25)
!226 = distinct !DILocation(line: 81, column: 14, scope: !227, inlinedAt: !229)
!227 = distinct !DISubprogram(name: "drop<std::sys::pal::unix::sync::mutex::Mutex>", linkageName: "_RNvXs1_NtNtNtCs1SSuMAdGM58_3std3sys4sync8once_boxINtB5_7OnceBoxNtNtNtNtNtB9_3pal4unix4sync5mutex5MutexENtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4dropCs5sHeypWcCKR_11runtime_lab", scope: !228, file: !18, line: 80, type: !24, scopeLine: 80, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !25)
!228 = !DINamespace(name: "{impl#3}", scope: !20)
!229 = distinct !DILocation(line: 847, column: 1, scope: !216)
!230 = !DILocation(line: 976, column: 49, scope: !231, inlinedAt: !224)
!231 = distinct !DILexicalBlock(scope: !223, file: !108, line: 975, column: 9)
!232 = !DILocation(line: 38, column: 17, scope: !233, inlinedAt: !240)
!233 = !DILexicalBlockFile(scope: !235, file: !234, discriminator: 0)
!234 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/ptr/const_ptr.rs", directory: "", checksumkind: CSK_MD5, checksum: "25118ae25e729b7c815218b31622724c")
!235 = distinct !DISubprogram(name: "runtime", linkageName: "_RNvNvMNtNtCsjIpoRzUjyHQ_4core3ptr9const_ptrPp7is_null7runtime", scope: !237, file: !236, line: 2623, type: !24, scopeLine: 2623, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !25)
!236 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/intrinsics/mod.rs", directory: "", checksumkind: CSK_MD5, checksum: "95f29c0132b18aca34fbfb798048cc68")
!237 = !DINamespace(name: "is_null", scope: !238)
!238 = !DINamespace(name: "{impl#0}", scope: !239)
!239 = !DINamespace(name: "const_ptr", scope: !79)
!240 = distinct !DILocation(line: 2636, column: 9, scope: !241, inlinedAt: !244)
!241 = !DILexicalBlockFile(scope: !242, file: !236, discriminator: 0)
!242 = distinct !DILexicalBlock(scope: !243, file: !234, line: 25, column: 9)
!243 = distinct !DISubprogram(name: "is_null<std::sys::pal::unix::sync::mutex::Mutex>", linkageName: "_RNvMNtNtCsjIpoRzUjyHQ_4core3ptr9const_ptrPNtNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutex5Mutex7is_nullCs5sHeypWcCKR_11runtime_lab", scope: !238, file: !234, line: 22, type: !24, scopeLine: 22, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !25)
!244 = distinct !DILocation(line: 23, column: 27, scope: !245, inlinedAt: !249)
!245 = distinct !DISubprogram(name: "is_null<std::sys::pal::unix::sync::mutex::Mutex>", linkageName: "_RNvMNtNtCsjIpoRzUjyHQ_4core3ptr7mut_ptrONtNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutex5Mutex7is_nullCs5sHeypWcCKR_11runtime_lab", scope: !247, file: !246, line: 22, type: !24, scopeLine: 22, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !25)
!246 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/ptr/mut_ptr.rs", directory: "", checksumkind: CSK_MD5, checksum: "0a9a444e8d978ea2fd7622da49f95724")
!247 = !DINamespace(name: "{impl#0}", scope: !248)
!248 = !DINamespace(name: "mut_ptr", scope: !79)
!249 = distinct !DILocation(line: 58, column: 17, scope: !250, inlinedAt: !226)
!250 = distinct !DILexicalBlock(scope: !225, file: !18, line: 57, column: 9)
!251 = !DILocation(line: 847, column: 1, scope: !252, inlinedAt: !253)
!252 = distinct !DISubprogram(name: "drop_glue<core::option::Option<core::pin::Pin<alloc::boxed::Box<std::sys::pal::unix::sync::mutex::Mutex, alloc::alloc::Global>>>>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtB4_6option6OptionINtNtB4_3pin3PinINtNtCs6zY7rJBZy9D_5alloc5boxed3BoxNtNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutex5MutexEEEECs5sHeypWcCKR_11runtime_lab", scope: !79, file: !78, line: 847, type: !96, scopeLine: 847, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !25)
!253 = distinct !DILocation(line: 81, column: 20, scope: !227, inlinedAt: !229)
!254 = !DILocation(line: 847, column: 1, scope: !77, inlinedAt: !255)
!255 = distinct !DILocation(line: 847, column: 1, scope: !105, inlinedAt: !256)
!256 = distinct !DILocation(line: 847, column: 1, scope: !141, inlinedAt: !257)
!257 = distinct !DILocation(line: 847, column: 1, scope: !252, inlinedAt: !253)
!258 = !DILocation(line: 175, column: 14, scope: !113, inlinedAt: !259)
!259 = distinct !DILocation(line: 321, column: 22, scope: !115, inlinedAt: !260)
!260 = distinct !DILocation(line: 436, column: 9, scope: !117, inlinedAt: !261)
!261 = distinct !DILocation(line: 554, column: 23, scope: !119, inlinedAt: !262)
!262 = distinct !DILocation(line: 2000, column: 24, scope: !121, inlinedAt: !263)
!263 = distinct !DILocation(line: 847, column: 1, scope: !105, inlinedAt: !256)
!264 = !DILocation(line: 847, column: 1, scope: !105, inlinedAt: !256)
!265 = !DILocation(line: 175, column: 14, scope: !113, inlinedAt: !266)
!266 = distinct !DILocation(line: 321, column: 22, scope: !115, inlinedAt: !267)
!267 = distinct !DILocation(line: 436, column: 9, scope: !117, inlinedAt: !268)
!268 = distinct !DILocation(line: 554, column: 23, scope: !119, inlinedAt: !269)
!269 = distinct !DILocation(line: 2000, column: 24, scope: !121, inlinedAt: !270)
!270 = distinct !DILocation(line: 847, column: 1, scope: !105, inlinedAt: !256)
!271 = distinct !DISubprogram(name: "drop_glue<tokio::runtime::builder::Builder>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtNtCs3EIJ1qnJmKW_5tokio7runtime7builder7BuilderECs5sHeypWcCKR_11runtime_lab", scope: !79, file: !78, line: 847, type: !24, scopeLine: 847, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !25)
!272 = !{i64 -8481793212453670731}
!273 = !DILocation(line: 847, column: 1, scope: !271)
!274 = !{i64 -1, i64 -9223372036854775808}
!275 = !DILocation(line: 847, column: 1, scope: !276, inlinedAt: !277)
!276 = distinct !DISubprogram(name: "drop_glue<core::option::Option<alloc::string::String>>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtB4_6option6OptionNtNtCs6zY7rJBZy9D_5alloc6string6StringEECs5sHeypWcCKR_11runtime_lab", scope: !79, file: !78, line: 847, type: !96, scopeLine: 847, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !25)
!277 = distinct !DILocation(line: 847, column: 1, scope: !271)
!278 = !DILocation(line: 175, column: 14, scope: !113, inlinedAt: !279)
!279 = distinct !DILocation(line: 321, column: 22, scope: !115, inlinedAt: !280)
!280 = distinct !DILocation(line: 436, column: 9, scope: !117, inlinedAt: !281)
!281 = distinct !DILocation(line: 554, column: 23, scope: !119, inlinedAt: !282)
!282 = distinct !DILocation(line: 876, column: 28, scope: !283, inlinedAt: !288)
!283 = distinct !DILexicalBlock(scope: !285, file: !284, line: 874, column: 82)
!284 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/alloc/src/raw_vec/mod.rs", directory: "", checksumkind: CSK_MD5, checksum: "acd4dae5e7aaaaf06aa0208ebac37ff5")
!285 = distinct !DISubprogram(name: "deallocate<alloc::alloc::Global>", linkageName: "_RNvMs3_NtCs6zY7rJBZy9D_5alloc7raw_vecNtB5_11RawVecInner10deallocateCs5sHeypWcCKR_11runtime_lab", scope: !286, file: !284, line: 872, type: !96, scopeLine: 872, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !25)
!286 = !DINamespace(name: "RawVecInner", scope: !287)
!287 = !DINamespace(name: "raw_vec", scope: !48)
!288 = distinct !DILocation(line: 425, column: 29, scope: !289, inlinedAt: !291)
!289 = distinct !DISubprogram(name: "drop<u8, alloc::alloc::Global>", linkageName: "_RNvXs1_NtCs6zY7rJBZy9D_5alloc7raw_vecINtB5_6RawVechENtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4dropCs5sHeypWcCKR_11runtime_lab", scope: !290, file: !284, line: 423, type: !96, scopeLine: 423, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !25)
!290 = !DINamespace(name: "{impl#3}", scope: !287)
!291 = distinct !DILocation(line: 847, column: 1, scope: !292, inlinedAt: !293)
!292 = distinct !DISubprogram(name: "drop_glue<alloc::raw_vec::RawVec<u8, alloc::alloc::Global>>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc7raw_vec6RawVechEECs5sHeypWcCKR_11runtime_lab", scope: !79, file: !78, line: 847, type: !96, scopeLine: 847, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !25)
!293 = distinct !DILocation(line: 847, column: 1, scope: !294, inlinedAt: !295)
!294 = distinct !DISubprogram(name: "drop_glue<alloc::vec::Vec<u8, alloc::alloc::Global>>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc3vec3VechEECs5sHeypWcCKR_11runtime_lab", scope: !79, file: !78, line: 847, type: !96, scopeLine: 847, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !25)
!295 = distinct !DILocation(line: 847, column: 1, scope: !296, inlinedAt: !297)
!296 = distinct !DISubprogram(name: "drop_glue<alloc::string::String>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtCs6zY7rJBZy9D_5alloc6string6StringECs5sHeypWcCKR_11runtime_lab", scope: !79, file: !78, line: 847, type: !96, scopeLine: 847, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !25)
!297 = distinct !DILocation(line: 847, column: 1, scope: !276, inlinedAt: !277)
!298 = !DILocation(line: 874, column: 9, scope: !285, inlinedAt: !288)
!299 = !{!300}
!300 = distinct !{!300, !301, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc4sync3ArcDINtNtNtB4_3ops8function2FnuEp6OutputNtNtBG_6string6StringNtNtB4_6marker4SendNtB27_4SyncEL_EECs5sHeypWcCKR_11runtime_lab: %_1"}
!301 = distinct !{!301, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc4sync3ArcDINtNtNtB4_3ops8function2FnuEp6OutputNtNtBG_6string6StringNtNtB4_6marker4SendNtB27_4SyncEL_EECs5sHeypWcCKR_11runtime_lab"}
!302 = !{!303}
!303 = distinct !{!303, !304, !"_RNvXsE_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcDINtNtNtCsjIpoRzUjyHQ_4core3ops8function2FnuEp6OutputNtNtB7_6string6StringNtNtBO_6marker4SendNtB1U_4SyncEL_ENtNtBM_4drop4Drop4dropCs5sHeypWcCKR_11runtime_lab: %self"}
!304 = distinct !{!304, !"_RNvXsE_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcDINtNtNtCsjIpoRzUjyHQ_4core3ops8function2FnuEp6OutputNtNtB7_6string6StringNtNtBO_6marker4SendNtB1U_4SyncEL_ENtNtBM_4drop4Drop4dropCs5sHeypWcCKR_11runtime_lab"}
!305 = !DILocation(line: 847, column: 1, scope: !306, inlinedAt: !307)
!306 = distinct !DISubprogram(name: "drop_glue<alloc::sync::Arc<(dyn core::ops::function::Fn<(), Output=alloc::string::String> + core::marker::Send + core::marker::Sync), alloc::alloc::Global>>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc4sync3ArcDINtNtNtB4_3ops8function2FnuEp6OutputNtNtBG_6string6StringNtNtB4_6marker4SendNtB27_4SyncEL_EECs5sHeypWcCKR_11runtime_lab", scope: !79, file: !78, line: 847, type: !24, scopeLine: 847, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !25)
!307 = distinct !DILocation(line: 847, column: 1, scope: !271)
!308 = !DILocation(line: 454, column: 20, scope: !309, inlinedAt: !313)
!309 = distinct !DISubprogram(name: "as_ref<alloc::sync::ArcInner<(dyn core::ops::function::Fn<(), Output=alloc::string::String> + core::marker::Send + core::marker::Sync)>>", linkageName: "_RNvMs1_NtNtCsjIpoRzUjyHQ_4core3ptr8non_nullINtB5_7NonNullINtNtCs6zY7rJBZy9D_5alloc4sync8ArcInnerDINtNtNtB9_3ops8function2FnuEp6OutputNtNtBY_6string6StringNtNtB9_6marker4SendNtB2u_4SyncEL_EE6as_refCs5sHeypWcCKR_11runtime_lab", scope: !311, file: !310, line: 450, type: !24, scopeLine: 450, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !25)
!310 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/ptr/non_null.rs", directory: "", checksumkind: CSK_MD5, checksum: "accc742d53c125b723531f778524eec8")
!311 = !DINamespace(name: "NonNull", scope: !312)
!312 = !DINamespace(name: "non_null", scope: !79)
!313 = distinct !DILocation(line: 2133, column: 27, scope: !314, inlinedAt: !318)
!314 = distinct !DISubprogram(name: "inner<(dyn core::ops::function::Fn<(), Output=alloc::string::String> + core::marker::Send + core::marker::Sync), alloc::alloc::Global>", linkageName: "_RNvMsn_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcDINtNtNtCsjIpoRzUjyHQ_4core3ops8function2FnuEp6OutputNtNtB7_6string6StringNtNtBO_6marker4SendNtB1U_4SyncEL_E5innerCs5sHeypWcCKR_11runtime_lab", scope: !316, file: !315, line: 2127, type: !24, scopeLine: 2127, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !25)
!315 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/alloc/src/sync.rs", directory: "", checksumkind: CSK_MD5, checksum: "8b43a53dcc02e6dca0e12f2ab1ca948e")
!316 = !DINamespace(name: "Arc", scope: !317)
!317 = !DINamespace(name: "sync", scope: !48)
!318 = distinct !DILocation(line: 2868, column: 17, scope: !319, inlinedAt: !321)
!319 = distinct !DISubprogram(name: "drop<(dyn core::ops::function::Fn<(), Output=alloc::string::String> + core::marker::Send + core::marker::Sync), alloc::alloc::Global>", linkageName: "_RNvXsE_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcDINtNtNtCsjIpoRzUjyHQ_4core3ops8function2FnuEp6OutputNtNtB7_6string6StringNtNtBO_6marker4SendNtB1U_4SyncEL_ENtNtBM_4drop4Drop4dropCs5sHeypWcCKR_11runtime_lab", scope: !320, file: !315, line: 2864, type: !24, scopeLine: 2864, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !25)
!320 = !DINamespace(name: "{impl#42}", scope: !317)
!321 = distinct !DILocation(line: 847, column: 1, scope: !306, inlinedAt: !307)
!322 = !{!303, !300}
!323 = !DILocation(line: 4049, column: 24, scope: !324, inlinedAt: !325)
!324 = distinct !DISubprogram(name: "atomic_sub<usize, usize>", linkageName: "_RINvNtNtCsjIpoRzUjyHQ_4core4sync6atomic10atomic_subjjECs5sHeypWcCKR_11runtime_lab", scope: !94, file: !93, line: 4043, type: !24, scopeLine: 4043, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !25)
!325 = distinct !DILocation(line: 3253, column: 26, scope: !326, inlinedAt: !327)
!326 = distinct !DISubprogram(name: "fetch_sub", linkageName: "_RNvMs1g_NtNtCsjIpoRzUjyHQ_4core4sync6atomicINtB6_6AtomicjE9fetch_sub", scope: !99, file: !93, line: 3251, type: !24, scopeLine: 3251, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !25)
!327 = distinct !DILocation(line: 2868, column: 32, scope: !319, inlinedAt: !321)
!328 = !DILocation(line: 2868, column: 12, scope: !319, inlinedAt: !321)
!329 = !DILocation(line: 4493, column: 24, scope: !330, inlinedAt: !331)
!330 = distinct !DISubprogram(name: "fence", linkageName: "_RNvNtNtCsjIpoRzUjyHQ_4core4sync6atomic5fence", scope: !94, file: !93, line: 4489, type: !24, scopeLine: 4489, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !25)
!331 = distinct !DILocation(line: 69, column: 9, scope: !319, inlinedAt: !321)
!332 = !DILocation(line: 2911, column: 18, scope: !319, inlinedAt: !321)
!333 = !DILocation(line: 4049, column: 24, scope: !334, inlinedAt: !335)
!334 = distinct !DISubprogram(name: "atomic_sub<usize, usize>", linkageName: "_RINvNtNtCsjIpoRzUjyHQ_4core4sync6atomic10atomic_subjjECs5sHeypWcCKR_11runtime_lab", scope: !94, file: !93, line: 4043, type: !24, scopeLine: 4043, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !25)
!335 = distinct !DILocation(line: 3253, column: 26, scope: !336, inlinedAt: !337)
!336 = distinct !DISubprogram(name: "fetch_sub", linkageName: "_RNvMs1g_NtNtCsjIpoRzUjyHQ_4core4sync6atomicINtB6_6AtomicjE9fetch_sub", scope: !99, file: !93, line: 3251, type: !24, scopeLine: 3251, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !25)
!337 = distinct !DILocation(line: 2868, column: 32, scope: !338, inlinedAt: !339)
!338 = distinct !DISubprogram(name: "drop<(dyn core::ops::function::Fn<(), Output=()> + core::marker::Send + core::marker::Sync), alloc::alloc::Global>", linkageName: "_RNvXsE_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcDINtNtNtCsjIpoRzUjyHQ_4core3ops8function2FnuEp6OutputuNtNtBO_6marker4SendNtB1A_4SyncEL_ENtNtBM_4drop4Drop4dropCs5sHeypWcCKR_11runtime_lab", scope: !320, file: !315, line: 2864, type: !24, scopeLine: 2864, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !25)
!339 = distinct !DILocation(line: 847, column: 1, scope: !340, inlinedAt: !341)
!340 = distinct !DISubprogram(name: "drop_glue<alloc::sync::Arc<(dyn core::ops::function::Fn<(), Output=()> + core::marker::Send + core::marker::Sync), alloc::alloc::Global>>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc4sync3ArcDINtNtNtB4_3ops8function2FnuEp6OutputuNtNtB4_6marker4SendNtB1N_4SyncEL_EECs5sHeypWcCKR_11runtime_lab", scope: !79, file: !78, line: 847, type: !24, scopeLine: 847, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !25)
!341 = distinct !DILocation(line: 847, column: 1, scope: !342, inlinedAt: !343)
!342 = distinct !DISubprogram(name: "drop_glue<core::option::Option<alloc::sync::Arc<(dyn core::ops::function::Fn<(), Output=()> + core::marker::Send + core::marker::Sync), alloc::alloc::Global>>>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtB4_6option6OptionINtNtCs6zY7rJBZy9D_5alloc4sync3ArcDINtNtNtB4_3ops8function2FnuEp6OutputuNtNtB4_6marker4SendNtB29_4SyncEL_EEECs5sHeypWcCKR_11runtime_lab", scope: !79, file: !78, line: 847, type: !24, scopeLine: 847, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !25)
!343 = distinct !DILocation(line: 847, column: 1, scope: !271)
!344 = !{!345, !347, !349}
!345 = distinct !{!345, !346, !"_RNvXsE_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcDINtNtNtCsjIpoRzUjyHQ_4core3ops8function2FnuEp6OutputuNtNtBO_6marker4SendNtB1A_4SyncEL_ENtNtBM_4drop4Drop4dropCs5sHeypWcCKR_11runtime_lab: %self"}
!346 = distinct !{!346, !"_RNvXsE_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcDINtNtNtCsjIpoRzUjyHQ_4core3ops8function2FnuEp6OutputuNtNtBO_6marker4SendNtB1A_4SyncEL_ENtNtBM_4drop4Drop4dropCs5sHeypWcCKR_11runtime_lab"}
!347 = distinct !{!347, !348, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc4sync3ArcDINtNtNtB4_3ops8function2FnuEp6OutputuNtNtB4_6marker4SendNtB1N_4SyncEL_EECs5sHeypWcCKR_11runtime_lab: %_1"}
!348 = distinct !{!348, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc4sync3ArcDINtNtNtB4_3ops8function2FnuEp6OutputuNtNtB4_6marker4SendNtB1N_4SyncEL_EECs5sHeypWcCKR_11runtime_lab"}
!349 = distinct !{!349, !350, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtB4_6option6OptionINtNtCs6zY7rJBZy9D_5alloc4sync3ArcDINtNtNtB4_3ops8function2FnuEp6OutputuNtNtB4_6marker4SendNtB29_4SyncEL_EEECs5sHeypWcCKR_11runtime_lab: %_1"}
!350 = distinct !{!350, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtB4_6option6OptionINtNtCs6zY7rJBZy9D_5alloc4sync3ArcDINtNtNtB4_3ops8function2FnuEp6OutputuNtNtB4_6marker4SendNtB29_4SyncEL_EEECs5sHeypWcCKR_11runtime_lab"}
!351 = !DILocation(line: 2868, column: 12, scope: !338, inlinedAt: !339)
!352 = !DILocation(line: 4493, column: 24, scope: !330, inlinedAt: !353)
!353 = distinct !DILocation(line: 69, column: 9, scope: !338, inlinedAt: !339)
!354 = !DILocation(line: 2911, column: 18, scope: !338, inlinedAt: !339)
!355 = !{!349}
!356 = !DILocation(line: 847, column: 1, scope: !342, inlinedAt: !343)
!357 = !{!358}
!358 = distinct !{!358, !359, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtB4_6option6OptionINtNtCs6zY7rJBZy9D_5alloc4sync3ArcDINtNtNtB4_3ops8function2FnuEp6OutputuNtNtB4_6marker4SendNtB29_4SyncEL_EEECs5sHeypWcCKR_11runtime_lab: %_1"}
!359 = distinct !{!359, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtB4_6option6OptionINtNtCs6zY7rJBZy9D_5alloc4sync3ArcDINtNtNtB4_3ops8function2FnuEp6OutputuNtNtB4_6marker4SendNtB29_4SyncEL_EEECs5sHeypWcCKR_11runtime_lab"}
!360 = !DILocation(line: 847, column: 1, scope: !342, inlinedAt: !361)
!361 = distinct !DILocation(line: 847, column: 1, scope: !271)
!362 = !DILocation(line: 4049, column: 24, scope: !334, inlinedAt: !363)
!363 = distinct !DILocation(line: 3253, column: 26, scope: !336, inlinedAt: !364)
!364 = distinct !DILocation(line: 2868, column: 32, scope: !338, inlinedAt: !365)
!365 = distinct !DILocation(line: 847, column: 1, scope: !340, inlinedAt: !366)
!366 = distinct !DILocation(line: 847, column: 1, scope: !342, inlinedAt: !361)
!367 = !{!368, !370, !358}
!368 = distinct !{!368, !369, !"_RNvXsE_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcDINtNtNtCsjIpoRzUjyHQ_4core3ops8function2FnuEp6OutputuNtNtBO_6marker4SendNtB1A_4SyncEL_ENtNtBM_4drop4Drop4dropCs5sHeypWcCKR_11runtime_lab: %self"}
!369 = distinct !{!369, !"_RNvXsE_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcDINtNtNtCsjIpoRzUjyHQ_4core3ops8function2FnuEp6OutputuNtNtBO_6marker4SendNtB1A_4SyncEL_ENtNtBM_4drop4Drop4dropCs5sHeypWcCKR_11runtime_lab"}
!370 = distinct !{!370, !371, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc4sync3ArcDINtNtNtB4_3ops8function2FnuEp6OutputuNtNtB4_6marker4SendNtB1N_4SyncEL_EECs5sHeypWcCKR_11runtime_lab: %_1"}
!371 = distinct !{!371, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc4sync3ArcDINtNtNtB4_3ops8function2FnuEp6OutputuNtNtB4_6marker4SendNtB1N_4SyncEL_EECs5sHeypWcCKR_11runtime_lab"}
!372 = !DILocation(line: 2868, column: 12, scope: !338, inlinedAt: !365)
!373 = !DILocation(line: 4493, column: 24, scope: !330, inlinedAt: !374)
!374 = distinct !DILocation(line: 69, column: 9, scope: !338, inlinedAt: !365)
!375 = !DILocation(line: 2911, column: 18, scope: !338, inlinedAt: !365)
!376 = !{!377}
!377 = distinct !{!377, !378, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtB4_6option6OptionINtNtCs6zY7rJBZy9D_5alloc4sync3ArcDINtNtNtB4_3ops8function2FnuEp6OutputuNtNtB4_6marker4SendNtB29_4SyncEL_EEECs5sHeypWcCKR_11runtime_lab: %_1"}
!378 = distinct !{!378, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtB4_6option6OptionINtNtCs6zY7rJBZy9D_5alloc4sync3ArcDINtNtNtB4_3ops8function2FnuEp6OutputuNtNtB4_6marker4SendNtB29_4SyncEL_EEECs5sHeypWcCKR_11runtime_lab"}
!379 = !DILocation(line: 847, column: 1, scope: !342, inlinedAt: !380)
!380 = distinct !DILocation(line: 847, column: 1, scope: !271)
!381 = !DILocation(line: 4049, column: 24, scope: !334, inlinedAt: !382)
!382 = distinct !DILocation(line: 3253, column: 26, scope: !336, inlinedAt: !383)
!383 = distinct !DILocation(line: 2868, column: 32, scope: !338, inlinedAt: !384)
!384 = distinct !DILocation(line: 847, column: 1, scope: !340, inlinedAt: !385)
!385 = distinct !DILocation(line: 847, column: 1, scope: !342, inlinedAt: !380)
!386 = !{!387, !389, !377}
!387 = distinct !{!387, !388, !"_RNvXsE_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcDINtNtNtCsjIpoRzUjyHQ_4core3ops8function2FnuEp6OutputuNtNtBO_6marker4SendNtB1A_4SyncEL_ENtNtBM_4drop4Drop4dropCs5sHeypWcCKR_11runtime_lab: %self"}
!388 = distinct !{!388, !"_RNvXsE_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcDINtNtNtCsjIpoRzUjyHQ_4core3ops8function2FnuEp6OutputuNtNtBO_6marker4SendNtB1A_4SyncEL_ENtNtBM_4drop4Drop4dropCs5sHeypWcCKR_11runtime_lab"}
!389 = distinct !{!389, !390, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc4sync3ArcDINtNtNtB4_3ops8function2FnuEp6OutputuNtNtB4_6marker4SendNtB1N_4SyncEL_EECs5sHeypWcCKR_11runtime_lab: %_1"}
!390 = distinct !{!390, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc4sync3ArcDINtNtNtB4_3ops8function2FnuEp6OutputuNtNtB4_6marker4SendNtB1N_4SyncEL_EECs5sHeypWcCKR_11runtime_lab"}
!391 = !DILocation(line: 2868, column: 12, scope: !338, inlinedAt: !384)
!392 = !DILocation(line: 4493, column: 24, scope: !330, inlinedAt: !393)
!393 = distinct !DILocation(line: 69, column: 9, scope: !338, inlinedAt: !384)
!394 = !DILocation(line: 2911, column: 18, scope: !338, inlinedAt: !384)
!395 = !{!396}
!396 = distinct !{!396, !397, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtB4_6option6OptionINtNtCs6zY7rJBZy9D_5alloc4sync3ArcDINtNtNtB4_3ops8function2FnuEp6OutputuNtNtB4_6marker4SendNtB29_4SyncEL_EEECs5sHeypWcCKR_11runtime_lab: %_1"}
!397 = distinct !{!397, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtB4_6option6OptionINtNtCs6zY7rJBZy9D_5alloc4sync3ArcDINtNtNtB4_3ops8function2FnuEp6OutputuNtNtB4_6marker4SendNtB29_4SyncEL_EEECs5sHeypWcCKR_11runtime_lab"}
!398 = !DILocation(line: 847, column: 1, scope: !342, inlinedAt: !399)
!399 = distinct !DILocation(line: 847, column: 1, scope: !271)
!400 = !DILocation(line: 4049, column: 24, scope: !334, inlinedAt: !401)
!401 = distinct !DILocation(line: 3253, column: 26, scope: !336, inlinedAt: !402)
!402 = distinct !DILocation(line: 2868, column: 32, scope: !338, inlinedAt: !403)
!403 = distinct !DILocation(line: 847, column: 1, scope: !340, inlinedAt: !404)
!404 = distinct !DILocation(line: 847, column: 1, scope: !342, inlinedAt: !399)
!405 = !{!406, !408, !396}
!406 = distinct !{!406, !407, !"_RNvXsE_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcDINtNtNtCsjIpoRzUjyHQ_4core3ops8function2FnuEp6OutputuNtNtBO_6marker4SendNtB1A_4SyncEL_ENtNtBM_4drop4Drop4dropCs5sHeypWcCKR_11runtime_lab: %self"}
!407 = distinct !{!407, !"_RNvXsE_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcDINtNtNtCsjIpoRzUjyHQ_4core3ops8function2FnuEp6OutputuNtNtBO_6marker4SendNtB1A_4SyncEL_ENtNtBM_4drop4Drop4dropCs5sHeypWcCKR_11runtime_lab"}
!408 = distinct !{!408, !409, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc4sync3ArcDINtNtNtB4_3ops8function2FnuEp6OutputuNtNtB4_6marker4SendNtB1N_4SyncEL_EECs5sHeypWcCKR_11runtime_lab: %_1"}
!409 = distinct !{!409, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc4sync3ArcDINtNtNtB4_3ops8function2FnuEp6OutputuNtNtB4_6marker4SendNtB1N_4SyncEL_EECs5sHeypWcCKR_11runtime_lab"}
!410 = !DILocation(line: 2868, column: 12, scope: !338, inlinedAt: !403)
!411 = !DILocation(line: 4493, column: 24, scope: !330, inlinedAt: !412)
!412 = distinct !DILocation(line: 69, column: 9, scope: !338, inlinedAt: !403)
!413 = !DILocation(line: 2911, column: 18, scope: !338, inlinedAt: !403)
!414 = !{!415}
!415 = distinct !{!415, !416, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtB4_6option6OptionINtNtCs6zY7rJBZy9D_5alloc4sync3ArcDINtNtNtB4_3ops8function2FnuEp6OutputuNtNtB4_6marker4SendNtB29_4SyncEL_EEECs5sHeypWcCKR_11runtime_lab: %_1"}
!416 = distinct !{!416, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtB4_6option6OptionINtNtCs6zY7rJBZy9D_5alloc4sync3ArcDINtNtNtB4_3ops8function2FnuEp6OutputuNtNtB4_6marker4SendNtB29_4SyncEL_EEECs5sHeypWcCKR_11runtime_lab"}
!417 = !DILocation(line: 847, column: 1, scope: !342, inlinedAt: !418)
!418 = distinct !DILocation(line: 847, column: 1, scope: !271)
!419 = !DILocation(line: 4049, column: 24, scope: !334, inlinedAt: !420)
!420 = distinct !DILocation(line: 3253, column: 26, scope: !336, inlinedAt: !421)
!421 = distinct !DILocation(line: 2868, column: 32, scope: !338, inlinedAt: !422)
!422 = distinct !DILocation(line: 847, column: 1, scope: !340, inlinedAt: !423)
!423 = distinct !DILocation(line: 847, column: 1, scope: !342, inlinedAt: !418)
!424 = !{!425, !427, !415}
!425 = distinct !{!425, !426, !"_RNvXsE_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcDINtNtNtCsjIpoRzUjyHQ_4core3ops8function2FnuEp6OutputuNtNtBO_6marker4SendNtB1A_4SyncEL_ENtNtBM_4drop4Drop4dropCs5sHeypWcCKR_11runtime_lab: %self"}
!426 = distinct !{!426, !"_RNvXsE_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcDINtNtNtCsjIpoRzUjyHQ_4core3ops8function2FnuEp6OutputuNtNtBO_6marker4SendNtB1A_4SyncEL_ENtNtBM_4drop4Drop4dropCs5sHeypWcCKR_11runtime_lab"}
!427 = distinct !{!427, !428, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc4sync3ArcDINtNtNtB4_3ops8function2FnuEp6OutputuNtNtB4_6marker4SendNtB1N_4SyncEL_EECs5sHeypWcCKR_11runtime_lab: %_1"}
!428 = distinct !{!428, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc4sync3ArcDINtNtNtB4_3ops8function2FnuEp6OutputuNtNtB4_6marker4SendNtB1N_4SyncEL_EECs5sHeypWcCKR_11runtime_lab"}
!429 = !DILocation(line: 2868, column: 12, scope: !338, inlinedAt: !422)
!430 = !DILocation(line: 4493, column: 24, scope: !330, inlinedAt: !431)
!431 = distinct !DILocation(line: 69, column: 9, scope: !338, inlinedAt: !422)
!432 = !DILocation(line: 2911, column: 18, scope: !338, inlinedAt: !422)
!433 = !{!434}
!434 = distinct !{!434, !435, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtB4_6option6OptionINtNtCs6zY7rJBZy9D_5alloc4sync3ArcDINtNtNtB4_3ops8function2FnuEp6OutputuNtNtB4_6marker4SendNtB29_4SyncEL_EEECs5sHeypWcCKR_11runtime_lab: %_1"}
!435 = distinct !{!435, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtB4_6option6OptionINtNtCs6zY7rJBZy9D_5alloc4sync3ArcDINtNtNtB4_3ops8function2FnuEp6OutputuNtNtB4_6marker4SendNtB29_4SyncEL_EEECs5sHeypWcCKR_11runtime_lab"}
!436 = !DILocation(line: 847, column: 1, scope: !342, inlinedAt: !437)
!437 = distinct !DILocation(line: 847, column: 1, scope: !271)
!438 = !DILocation(line: 4049, column: 24, scope: !334, inlinedAt: !439)
!439 = distinct !DILocation(line: 3253, column: 26, scope: !336, inlinedAt: !440)
!440 = distinct !DILocation(line: 2868, column: 32, scope: !338, inlinedAt: !441)
!441 = distinct !DILocation(line: 847, column: 1, scope: !340, inlinedAt: !442)
!442 = distinct !DILocation(line: 847, column: 1, scope: !342, inlinedAt: !437)
!443 = !{!444, !446, !434}
!444 = distinct !{!444, !445, !"_RNvXsE_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcDINtNtNtCsjIpoRzUjyHQ_4core3ops8function2FnuEp6OutputuNtNtBO_6marker4SendNtB1A_4SyncEL_ENtNtBM_4drop4Drop4dropCs5sHeypWcCKR_11runtime_lab: %self"}
!445 = distinct !{!445, !"_RNvXsE_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcDINtNtNtCsjIpoRzUjyHQ_4core3ops8function2FnuEp6OutputuNtNtBO_6marker4SendNtB1A_4SyncEL_ENtNtBM_4drop4Drop4dropCs5sHeypWcCKR_11runtime_lab"}
!446 = distinct !{!446, !447, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc4sync3ArcDINtNtNtB4_3ops8function2FnuEp6OutputuNtNtB4_6marker4SendNtB1N_4SyncEL_EECs5sHeypWcCKR_11runtime_lab: %_1"}
!447 = distinct !{!447, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc4sync3ArcDINtNtNtB4_3ops8function2FnuEp6OutputuNtNtB4_6marker4SendNtB1N_4SyncEL_EECs5sHeypWcCKR_11runtime_lab"}
!448 = !DILocation(line: 2868, column: 12, scope: !338, inlinedAt: !441)
!449 = !DILocation(line: 4493, column: 24, scope: !330, inlinedAt: !450)
!450 = distinct !DILocation(line: 69, column: 9, scope: !338, inlinedAt: !441)
!451 = !DILocation(line: 2911, column: 18, scope: !338, inlinedAt: !441)
!452 = !{!453}
!453 = distinct !{!453, !454, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtB4_6option6OptionINtNtCs6zY7rJBZy9D_5alloc4sync3ArcDINtNtNtB4_3ops8function2FnuEp6OutputuNtNtB4_6marker4SendNtB29_4SyncEL_EEECs5sHeypWcCKR_11runtime_lab: %_1"}
!454 = distinct !{!454, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtB4_6option6OptionINtNtCs6zY7rJBZy9D_5alloc4sync3ArcDINtNtNtB4_3ops8function2FnuEp6OutputuNtNtB4_6marker4SendNtB29_4SyncEL_EEECs5sHeypWcCKR_11runtime_lab"}
!455 = !DILocation(line: 847, column: 1, scope: !342, inlinedAt: !456)
!456 = distinct !DILocation(line: 847, column: 1, scope: !271)
!457 = !DILocation(line: 4049, column: 24, scope: !334, inlinedAt: !458)
!458 = distinct !DILocation(line: 3253, column: 26, scope: !336, inlinedAt: !459)
!459 = distinct !DILocation(line: 2868, column: 32, scope: !338, inlinedAt: !460)
!460 = distinct !DILocation(line: 847, column: 1, scope: !340, inlinedAt: !461)
!461 = distinct !DILocation(line: 847, column: 1, scope: !342, inlinedAt: !456)
!462 = !{!463, !465, !453}
!463 = distinct !{!463, !464, !"_RNvXsE_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcDINtNtNtCsjIpoRzUjyHQ_4core3ops8function2FnuEp6OutputuNtNtBO_6marker4SendNtB1A_4SyncEL_ENtNtBM_4drop4Drop4dropCs5sHeypWcCKR_11runtime_lab: %self"}
!464 = distinct !{!464, !"_RNvXsE_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcDINtNtNtCsjIpoRzUjyHQ_4core3ops8function2FnuEp6OutputuNtNtBO_6marker4SendNtB1A_4SyncEL_ENtNtBM_4drop4Drop4dropCs5sHeypWcCKR_11runtime_lab"}
!465 = distinct !{!465, !466, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc4sync3ArcDINtNtNtB4_3ops8function2FnuEp6OutputuNtNtB4_6marker4SendNtB1N_4SyncEL_EECs5sHeypWcCKR_11runtime_lab: %_1"}
!466 = distinct !{!466, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc4sync3ArcDINtNtNtB4_3ops8function2FnuEp6OutputuNtNtB4_6marker4SendNtB1N_4SyncEL_EECs5sHeypWcCKR_11runtime_lab"}
!467 = !DILocation(line: 2868, column: 12, scope: !338, inlinedAt: !460)
!468 = !DILocation(line: 4493, column: 24, scope: !330, inlinedAt: !469)
!469 = distinct !DILocation(line: 69, column: 9, scope: !338, inlinedAt: !460)
!470 = !DILocation(line: 2911, column: 18, scope: !338, inlinedAt: !460)
!471 = !{!472}
!472 = distinct !{!472, !473, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtB4_6option6OptionINtNtCs6zY7rJBZy9D_5alloc4sync3ArcDINtNtNtB4_3ops8function2FnuEp6OutputuNtNtB4_6marker4SendNtB29_4SyncEL_EEECs5sHeypWcCKR_11runtime_lab: %_1"}
!473 = distinct !{!473, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtB4_6option6OptionINtNtCs6zY7rJBZy9D_5alloc4sync3ArcDINtNtNtB4_3ops8function2FnuEp6OutputuNtNtB4_6marker4SendNtB29_4SyncEL_EEECs5sHeypWcCKR_11runtime_lab"}
!474 = !DILocation(line: 847, column: 1, scope: !342, inlinedAt: !475)
!475 = distinct !DILocation(line: 847, column: 1, scope: !271)
!476 = !DILocation(line: 4049, column: 24, scope: !334, inlinedAt: !477)
!477 = distinct !DILocation(line: 3253, column: 26, scope: !336, inlinedAt: !478)
!478 = distinct !DILocation(line: 2868, column: 32, scope: !338, inlinedAt: !479)
!479 = distinct !DILocation(line: 847, column: 1, scope: !340, inlinedAt: !480)
!480 = distinct !DILocation(line: 847, column: 1, scope: !342, inlinedAt: !475)
!481 = !{!482, !484, !472}
!482 = distinct !{!482, !483, !"_RNvXsE_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcDINtNtNtCsjIpoRzUjyHQ_4core3ops8function2FnuEp6OutputuNtNtBO_6marker4SendNtB1A_4SyncEL_ENtNtBM_4drop4Drop4dropCs5sHeypWcCKR_11runtime_lab: %self"}
!483 = distinct !{!483, !"_RNvXsE_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcDINtNtNtCsjIpoRzUjyHQ_4core3ops8function2FnuEp6OutputuNtNtBO_6marker4SendNtB1A_4SyncEL_ENtNtBM_4drop4Drop4dropCs5sHeypWcCKR_11runtime_lab"}
!484 = distinct !{!484, !485, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc4sync3ArcDINtNtNtB4_3ops8function2FnuEp6OutputuNtNtB4_6marker4SendNtB1N_4SyncEL_EECs5sHeypWcCKR_11runtime_lab: %_1"}
!485 = distinct !{!485, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc4sync3ArcDINtNtNtB4_3ops8function2FnuEp6OutputuNtNtB4_6marker4SendNtB1N_4SyncEL_EECs5sHeypWcCKR_11runtime_lab"}
!486 = !DILocation(line: 2868, column: 12, scope: !338, inlinedAt: !479)
!487 = !DILocation(line: 4493, column: 24, scope: !330, inlinedAt: !488)
!488 = distinct !DILocation(line: 69, column: 9, scope: !338, inlinedAt: !479)
!489 = !DILocation(line: 2911, column: 18, scope: !338, inlinedAt: !479)
!490 = !{!491}
!491 = distinct !{!491, !492, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtB4_6option6OptionINtNtCs6zY7rJBZy9D_5alloc4sync3ArcDG0_INtNtNtB4_3ops8function2FnTRL1_INtNtNtCs3EIJ1qnJmKW_5tokio7runtime10task_hooks8TaskMetaL0_EEEp6OutputuNtNtB4_6marker4SendNtB3f_4SyncEL_EEECs5sHeypWcCKR_11runtime_lab: %_1"}
!492 = distinct !{!492, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtB4_6option6OptionINtNtCs6zY7rJBZy9D_5alloc4sync3ArcDG0_INtNtNtB4_3ops8function2FnTRL1_INtNtNtCs3EIJ1qnJmKW_5tokio7runtime10task_hooks8TaskMetaL0_EEEp6OutputuNtNtB4_6marker4SendNtB3f_4SyncEL_EEECs5sHeypWcCKR_11runtime_lab"}
!493 = !DILocation(line: 847, column: 1, scope: !494, inlinedAt: !495)
!494 = distinct !DISubprogram(name: "drop_glue<core::option::Option<alloc::sync::Arc<(dyn core::ops::function::Fn<(&tokio::runtime::task_hooks::TaskMeta), Output=()> + core::marker::Send + core::marker::Sync), alloc::alloc::Global>>>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtB4_6option6OptionINtNtCs6zY7rJBZy9D_5alloc4sync3ArcDG0_INtNtNtB4_3ops8function2FnTRL1_INtNtNtCs3EIJ1qnJmKW_5tokio7runtime10task_hooks8TaskMetaL0_EEEp6OutputuNtNtB4_6marker4SendNtB3f_4SyncEL_EEECs5sHeypWcCKR_11runtime_lab", scope: !79, file: !78, line: 847, type: !24, scopeLine: 847, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !25)
!495 = distinct !DILocation(line: 847, column: 1, scope: !271)
!496 = !DILocation(line: 4049, column: 24, scope: !497, inlinedAt: !498)
!497 = distinct !DISubprogram(name: "atomic_sub<usize, usize>", linkageName: "_RINvNtNtCsjIpoRzUjyHQ_4core4sync6atomic10atomic_subjjECs5sHeypWcCKR_11runtime_lab", scope: !94, file: !93, line: 4043, type: !24, scopeLine: 4043, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !25)
!498 = distinct !DILocation(line: 3253, column: 26, scope: !499, inlinedAt: !500)
!499 = distinct !DISubprogram(name: "fetch_sub", linkageName: "_RNvMs1g_NtNtCsjIpoRzUjyHQ_4core4sync6atomicINtB6_6AtomicjE9fetch_sub", scope: !99, file: !93, line: 3251, type: !24, scopeLine: 3251, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !25)
!500 = distinct !DILocation(line: 2868, column: 32, scope: !501, inlinedAt: !502)
!501 = distinct !DISubprogram(name: "drop<(dyn core::ops::function::Fn<(&tokio::runtime::task_hooks::TaskMeta), Output=()> + core::marker::Send + core::marker::Sync), alloc::alloc::Global>", linkageName: "_RNvXsE_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcDG0_INtNtNtCsjIpoRzUjyHQ_4core3ops8function2FnTRL1_INtNtNtCs3EIJ1qnJmKW_5tokio7runtime10task_hooks8TaskMetaL0_EEEp6OutputuNtNtBR_6marker4SendNtB2G_4SyncEL_ENtNtBP_4drop4Drop4dropCs5sHeypWcCKR_11runtime_lab", scope: !320, file: !315, line: 2864, type: !24, scopeLine: 2864, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !25)
!502 = distinct !DILocation(line: 847, column: 1, scope: !503, inlinedAt: !504)
!503 = distinct !DISubprogram(name: "drop_glue<alloc::sync::Arc<(dyn core::ops::function::Fn<(&tokio::runtime::task_hooks::TaskMeta), Output=()> + core::marker::Send + core::marker::Sync), alloc::alloc::Global>>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc4sync3ArcDG0_INtNtNtB4_3ops8function2FnTRL1_INtNtNtCs3EIJ1qnJmKW_5tokio7runtime10task_hooks8TaskMetaL0_EEEp6OutputuNtNtB4_6marker4SendNtB2T_4SyncEL_EECs5sHeypWcCKR_11runtime_lab", scope: !79, file: !78, line: 847, type: !24, scopeLine: 847, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !25)
!504 = distinct !DILocation(line: 847, column: 1, scope: !494, inlinedAt: !495)
!505 = !{!506, !508, !491}
!506 = distinct !{!506, !507, !"_RNvXsE_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcDG0_INtNtNtCsjIpoRzUjyHQ_4core3ops8function2FnTRL1_INtNtNtCs3EIJ1qnJmKW_5tokio7runtime10task_hooks8TaskMetaL0_EEEp6OutputuNtNtBR_6marker4SendNtB2G_4SyncEL_ENtNtBP_4drop4Drop4dropCs5sHeypWcCKR_11runtime_lab: %self"}
!507 = distinct !{!507, !"_RNvXsE_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcDG0_INtNtNtCsjIpoRzUjyHQ_4core3ops8function2FnTRL1_INtNtNtCs3EIJ1qnJmKW_5tokio7runtime10task_hooks8TaskMetaL0_EEEp6OutputuNtNtBR_6marker4SendNtB2G_4SyncEL_ENtNtBP_4drop4Drop4dropCs5sHeypWcCKR_11runtime_lab"}
!508 = distinct !{!508, !509, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc4sync3ArcDG0_INtNtNtB4_3ops8function2FnTRL1_INtNtNtCs3EIJ1qnJmKW_5tokio7runtime10task_hooks8TaskMetaL0_EEEp6OutputuNtNtB4_6marker4SendNtB2T_4SyncEL_EECs5sHeypWcCKR_11runtime_lab: %_1"}
!509 = distinct !{!509, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc4sync3ArcDG0_INtNtNtB4_3ops8function2FnTRL1_INtNtNtCs3EIJ1qnJmKW_5tokio7runtime10task_hooks8TaskMetaL0_EEEp6OutputuNtNtB4_6marker4SendNtB2T_4SyncEL_EECs5sHeypWcCKR_11runtime_lab"}
!510 = !DILocation(line: 2868, column: 12, scope: !501, inlinedAt: !502)
!511 = !DILocation(line: 4493, column: 24, scope: !330, inlinedAt: !512)
!512 = distinct !DILocation(line: 69, column: 9, scope: !501, inlinedAt: !502)
!513 = !DILocation(line: 2911, column: 18, scope: !501, inlinedAt: !502)
!514 = !{!515}
!515 = distinct !{!515, !516, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtB4_6option6OptionINtNtCs6zY7rJBZy9D_5alloc4sync3ArcDG0_INtNtNtB4_3ops8function2FnTRL1_INtNtNtCs3EIJ1qnJmKW_5tokio7runtime10task_hooks8TaskMetaL0_EEEp6OutputuNtNtB4_6marker4SendNtB3f_4SyncEL_EEECs5sHeypWcCKR_11runtime_lab: %_1"}
!516 = distinct !{!516, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtB4_6option6OptionINtNtCs6zY7rJBZy9D_5alloc4sync3ArcDG0_INtNtNtB4_3ops8function2FnTRL1_INtNtNtCs3EIJ1qnJmKW_5tokio7runtime10task_hooks8TaskMetaL0_EEEp6OutputuNtNtB4_6marker4SendNtB3f_4SyncEL_EEECs5sHeypWcCKR_11runtime_lab"}
!517 = !DILocation(line: 847, column: 1, scope: !494, inlinedAt: !518)
!518 = distinct !DILocation(line: 847, column: 1, scope: !271)
!519 = !DILocation(line: 4049, column: 24, scope: !497, inlinedAt: !520)
!520 = distinct !DILocation(line: 3253, column: 26, scope: !499, inlinedAt: !521)
!521 = distinct !DILocation(line: 2868, column: 32, scope: !501, inlinedAt: !522)
!522 = distinct !DILocation(line: 847, column: 1, scope: !503, inlinedAt: !523)
!523 = distinct !DILocation(line: 847, column: 1, scope: !494, inlinedAt: !518)
!524 = !{!525, !527, !515}
!525 = distinct !{!525, !526, !"_RNvXsE_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcDG0_INtNtNtCsjIpoRzUjyHQ_4core3ops8function2FnTRL1_INtNtNtCs3EIJ1qnJmKW_5tokio7runtime10task_hooks8TaskMetaL0_EEEp6OutputuNtNtBR_6marker4SendNtB2G_4SyncEL_ENtNtBP_4drop4Drop4dropCs5sHeypWcCKR_11runtime_lab: %self"}
!526 = distinct !{!526, !"_RNvXsE_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcDG0_INtNtNtCsjIpoRzUjyHQ_4core3ops8function2FnTRL1_INtNtNtCs3EIJ1qnJmKW_5tokio7runtime10task_hooks8TaskMetaL0_EEEp6OutputuNtNtBR_6marker4SendNtB2G_4SyncEL_ENtNtBP_4drop4Drop4dropCs5sHeypWcCKR_11runtime_lab"}
!527 = distinct !{!527, !528, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc4sync3ArcDG0_INtNtNtB4_3ops8function2FnTRL1_INtNtNtCs3EIJ1qnJmKW_5tokio7runtime10task_hooks8TaskMetaL0_EEEp6OutputuNtNtB4_6marker4SendNtB2T_4SyncEL_EECs5sHeypWcCKR_11runtime_lab: %_1"}
!528 = distinct !{!528, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc4sync3ArcDG0_INtNtNtB4_3ops8function2FnTRL1_INtNtNtCs3EIJ1qnJmKW_5tokio7runtime10task_hooks8TaskMetaL0_EEEp6OutputuNtNtB4_6marker4SendNtB2T_4SyncEL_EECs5sHeypWcCKR_11runtime_lab"}
!529 = !DILocation(line: 2868, column: 12, scope: !501, inlinedAt: !522)
!530 = !DILocation(line: 4493, column: 24, scope: !330, inlinedAt: !531)
!531 = distinct !DILocation(line: 69, column: 9, scope: !501, inlinedAt: !522)
!532 = !DILocation(line: 2911, column: 18, scope: !501, inlinedAt: !522)
!533 = !{!534}
!534 = distinct !{!534, !535, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtB4_6option6OptionINtNtCs6zY7rJBZy9D_5alloc4sync3ArcDG0_INtNtNtB4_3ops8function2FnTRL1_INtNtNtCs3EIJ1qnJmKW_5tokio7runtime10task_hooks8TaskMetaL0_EEEp6OutputuNtNtB4_6marker4SendNtB3f_4SyncEL_EEECs5sHeypWcCKR_11runtime_lab: %_1"}
!535 = distinct !{!535, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtB4_6option6OptionINtNtCs6zY7rJBZy9D_5alloc4sync3ArcDG0_INtNtNtB4_3ops8function2FnTRL1_INtNtNtCs3EIJ1qnJmKW_5tokio7runtime10task_hooks8TaskMetaL0_EEEp6OutputuNtNtB4_6marker4SendNtB3f_4SyncEL_EEECs5sHeypWcCKR_11runtime_lab"}
!536 = !DILocation(line: 847, column: 1, scope: !494, inlinedAt: !537)
!537 = distinct !DILocation(line: 847, column: 1, scope: !271)
!538 = !DILocation(line: 4049, column: 24, scope: !497, inlinedAt: !539)
!539 = distinct !DILocation(line: 3253, column: 26, scope: !499, inlinedAt: !540)
!540 = distinct !DILocation(line: 2868, column: 32, scope: !501, inlinedAt: !541)
!541 = distinct !DILocation(line: 847, column: 1, scope: !503, inlinedAt: !542)
!542 = distinct !DILocation(line: 847, column: 1, scope: !494, inlinedAt: !537)
!543 = !{!544, !546, !534}
!544 = distinct !{!544, !545, !"_RNvXsE_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcDG0_INtNtNtCsjIpoRzUjyHQ_4core3ops8function2FnTRL1_INtNtNtCs3EIJ1qnJmKW_5tokio7runtime10task_hooks8TaskMetaL0_EEEp6OutputuNtNtBR_6marker4SendNtB2G_4SyncEL_ENtNtBP_4drop4Drop4dropCs5sHeypWcCKR_11runtime_lab: %self"}
!545 = distinct !{!545, !"_RNvXsE_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcDG0_INtNtNtCsjIpoRzUjyHQ_4core3ops8function2FnTRL1_INtNtNtCs3EIJ1qnJmKW_5tokio7runtime10task_hooks8TaskMetaL0_EEEp6OutputuNtNtBR_6marker4SendNtB2G_4SyncEL_ENtNtBP_4drop4Drop4dropCs5sHeypWcCKR_11runtime_lab"}
!546 = distinct !{!546, !547, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc4sync3ArcDG0_INtNtNtB4_3ops8function2FnTRL1_INtNtNtCs3EIJ1qnJmKW_5tokio7runtime10task_hooks8TaskMetaL0_EEEp6OutputuNtNtB4_6marker4SendNtB2T_4SyncEL_EECs5sHeypWcCKR_11runtime_lab: %_1"}
!547 = distinct !{!547, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc4sync3ArcDG0_INtNtNtB4_3ops8function2FnTRL1_INtNtNtCs3EIJ1qnJmKW_5tokio7runtime10task_hooks8TaskMetaL0_EEEp6OutputuNtNtB4_6marker4SendNtB2T_4SyncEL_EECs5sHeypWcCKR_11runtime_lab"}
!548 = !DILocation(line: 2868, column: 12, scope: !501, inlinedAt: !541)
!549 = !DILocation(line: 4493, column: 24, scope: !330, inlinedAt: !550)
!550 = distinct !DILocation(line: 69, column: 9, scope: !501, inlinedAt: !541)
!551 = !DILocation(line: 2911, column: 18, scope: !501, inlinedAt: !541)
!552 = !{!553}
!553 = distinct !{!553, !554, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtB4_6option6OptionINtNtCs6zY7rJBZy9D_5alloc4sync3ArcDG0_INtNtNtB4_3ops8function2FnTRL1_INtNtNtCs3EIJ1qnJmKW_5tokio7runtime10task_hooks8TaskMetaL0_EEEp6OutputuNtNtB4_6marker4SendNtB3f_4SyncEL_EEECs5sHeypWcCKR_11runtime_lab: %_1"}
!554 = distinct !{!554, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtB4_6option6OptionINtNtCs6zY7rJBZy9D_5alloc4sync3ArcDG0_INtNtNtB4_3ops8function2FnTRL1_INtNtNtCs3EIJ1qnJmKW_5tokio7runtime10task_hooks8TaskMetaL0_EEEp6OutputuNtNtB4_6marker4SendNtB3f_4SyncEL_EEECs5sHeypWcCKR_11runtime_lab"}
!555 = !DILocation(line: 847, column: 1, scope: !494, inlinedAt: !556)
!556 = distinct !DILocation(line: 847, column: 1, scope: !271)
!557 = !DILocation(line: 4049, column: 24, scope: !497, inlinedAt: !558)
!558 = distinct !DILocation(line: 3253, column: 26, scope: !499, inlinedAt: !559)
!559 = distinct !DILocation(line: 2868, column: 32, scope: !501, inlinedAt: !560)
!560 = distinct !DILocation(line: 847, column: 1, scope: !503, inlinedAt: !561)
!561 = distinct !DILocation(line: 847, column: 1, scope: !494, inlinedAt: !556)
!562 = !{!563, !565, !553}
!563 = distinct !{!563, !564, !"_RNvXsE_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcDG0_INtNtNtCsjIpoRzUjyHQ_4core3ops8function2FnTRL1_INtNtNtCs3EIJ1qnJmKW_5tokio7runtime10task_hooks8TaskMetaL0_EEEp6OutputuNtNtBR_6marker4SendNtB2G_4SyncEL_ENtNtBP_4drop4Drop4dropCs5sHeypWcCKR_11runtime_lab: %self"}
!564 = distinct !{!564, !"_RNvXsE_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcDG0_INtNtNtCsjIpoRzUjyHQ_4core3ops8function2FnTRL1_INtNtNtCs3EIJ1qnJmKW_5tokio7runtime10task_hooks8TaskMetaL0_EEEp6OutputuNtNtBR_6marker4SendNtB2G_4SyncEL_ENtNtBP_4drop4Drop4dropCs5sHeypWcCKR_11runtime_lab"}
!565 = distinct !{!565, !566, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc4sync3ArcDG0_INtNtNtB4_3ops8function2FnTRL1_INtNtNtCs3EIJ1qnJmKW_5tokio7runtime10task_hooks8TaskMetaL0_EEEp6OutputuNtNtB4_6marker4SendNtB2T_4SyncEL_EECs5sHeypWcCKR_11runtime_lab: %_1"}
!566 = distinct !{!566, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc4sync3ArcDG0_INtNtNtB4_3ops8function2FnTRL1_INtNtNtCs3EIJ1qnJmKW_5tokio7runtime10task_hooks8TaskMetaL0_EEEp6OutputuNtNtB4_6marker4SendNtB2T_4SyncEL_EECs5sHeypWcCKR_11runtime_lab"}
!567 = !DILocation(line: 2868, column: 12, scope: !501, inlinedAt: !560)
!568 = !DILocation(line: 4493, column: 24, scope: !330, inlinedAt: !569)
!569 = distinct !DILocation(line: 69, column: 9, scope: !501, inlinedAt: !560)
!570 = !DILocation(line: 2911, column: 18, scope: !501, inlinedAt: !560)
!571 = !DILocation(line: 847, column: 1, scope: !572, inlinedAt: !573)
!572 = distinct !DISubprogram(name: "drop_glue<std::sys::sync::mutex::pthread::Mutex>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtNtNtNtCs1SSuMAdGM58_3std3sys4sync5mutex7pthread5MutexECs5sHeypWcCKR_11runtime_lab", scope: !79, file: !78, line: 847, type: !24, scopeLine: 847, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !25)
!573 = distinct !DILocation(line: 847, column: 1, scope: !574, inlinedAt: !575)
!574 = distinct !DISubprogram(name: "drop_glue<std::sync::poison::mutex::Mutex<tokio::util::rand::FastRand>>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtNtCs1SSuMAdGM58_3std4sync6poison5mutex5MutexNtNtNtCs3EIJ1qnJmKW_5tokio4util4rand8FastRandEECs5sHeypWcCKR_11runtime_lab", scope: !79, file: !78, line: 847, type: !24, scopeLine: 847, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !25)
!575 = distinct !DILocation(line: 847, column: 1, scope: !576, inlinedAt: !577)
!576 = distinct !DISubprogram(name: "drop_glue<tokio::util::rand::rt::RngSeedGenerator>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtNtNtCs3EIJ1qnJmKW_5tokio4util4rand2rt16RngSeedGeneratorECs5sHeypWcCKR_11runtime_lab", scope: !79, file: !78, line: 847, type: !24, scopeLine: 847, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !25)
!577 = distinct !DILocation(line: 847, column: 1, scope: !271)
!578 = !{!579}
!579 = distinct !{!579, !580, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtNtCs1SSuMAdGM58_3std3sys4sync8once_box7OnceBoxNtNtNtNtNtBI_3pal4unix4sync5mutex5MutexEECs5sHeypWcCKR_11runtime_lab: %_1"}
!580 = distinct !{!580, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtNtCs1SSuMAdGM58_3std3sys4sync8once_box7OnceBoxNtNtNtNtNtBI_3pal4unix4sync5mutex5MutexEECs5sHeypWcCKR_11runtime_lab"}
!581 = !{!582}
!582 = distinct !{!582, !583, !"_RNvXs1_NtNtNtCs1SSuMAdGM58_3std3sys4sync8once_boxINtB5_7OnceBoxNtNtNtNtNtB9_3pal4unix4sync5mutex5MutexENtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4dropCs5sHeypWcCKR_11runtime_lab: %self"}
!583 = distinct !{!583, !"_RNvXs1_NtNtNtCs1SSuMAdGM58_3std3sys4sync8once_boxINtB5_7OnceBoxNtNtNtNtNtB9_3pal4unix4sync5mutex5MutexENtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4dropCs5sHeypWcCKR_11runtime_lab"}
!584 = !DILocation(line: 847, column: 1, scope: !216, inlinedAt: !585)
!585 = distinct !DILocation(line: 847, column: 1, scope: !572, inlinedAt: !573)
!586 = !DILocation(line: 975, column: 22, scope: !223, inlinedAt: !587)
!587 = distinct !DILocation(line: 57, column: 19, scope: !225, inlinedAt: !588)
!588 = distinct !DILocation(line: 81, column: 14, scope: !227, inlinedAt: !589)
!589 = distinct !DILocation(line: 847, column: 1, scope: !216, inlinedAt: !585)
!590 = !{!582, !579, !591, !593, !595}
!591 = distinct !{!591, !592, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtNtNtNtCs1SSuMAdGM58_3std3sys4sync5mutex7pthread5MutexECs5sHeypWcCKR_11runtime_lab: %_1"}
!592 = distinct !{!592, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtNtNtNtCs1SSuMAdGM58_3std3sys4sync5mutex7pthread5MutexECs5sHeypWcCKR_11runtime_lab"}
!593 = distinct !{!593, !594, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtNtCs1SSuMAdGM58_3std4sync6poison5mutex5MutexNtNtNtCs3EIJ1qnJmKW_5tokio4util4rand8FastRandEECs5sHeypWcCKR_11runtime_lab: %_1"}
!594 = distinct !{!594, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtNtCs1SSuMAdGM58_3std4sync6poison5mutex5MutexNtNtNtCs3EIJ1qnJmKW_5tokio4util4rand8FastRandEECs5sHeypWcCKR_11runtime_lab"}
!595 = distinct !{!595, !596, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtNtNtCs3EIJ1qnJmKW_5tokio4util4rand2rt16RngSeedGeneratorECs5sHeypWcCKR_11runtime_lab: %_1"}
!596 = distinct !{!596, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtNtNtCs3EIJ1qnJmKW_5tokio4util4rand2rt16RngSeedGeneratorECs5sHeypWcCKR_11runtime_lab"}
!597 = !DILocation(line: 976, column: 49, scope: !231, inlinedAt: !587)
!598 = !DILocation(line: 38, column: 17, scope: !233, inlinedAt: !599)
!599 = distinct !DILocation(line: 2636, column: 9, scope: !241, inlinedAt: !600)
!600 = distinct !DILocation(line: 23, column: 27, scope: !245, inlinedAt: !601)
!601 = distinct !DILocation(line: 58, column: 17, scope: !250, inlinedAt: !588)
!602 = !DILocation(line: 847, column: 1, scope: !252, inlinedAt: !603)
!603 = distinct !DILocation(line: 81, column: 20, scope: !227, inlinedAt: !589)
!604 = !DILocation(line: 847, column: 1, scope: !77, inlinedAt: !605)
!605 = distinct !DILocation(line: 847, column: 1, scope: !105, inlinedAt: !606)
!606 = distinct !DILocation(line: 847, column: 1, scope: !141, inlinedAt: !607)
!607 = distinct !DILocation(line: 847, column: 1, scope: !252, inlinedAt: !603)
!608 = !{!582, !579}
!609 = !DILocation(line: 175, column: 14, scope: !113, inlinedAt: !610)
!610 = distinct !DILocation(line: 321, column: 22, scope: !115, inlinedAt: !611)
!611 = distinct !DILocation(line: 436, column: 9, scope: !117, inlinedAt: !612)
!612 = distinct !DILocation(line: 554, column: 23, scope: !119, inlinedAt: !613)
!613 = distinct !DILocation(line: 2000, column: 24, scope: !121, inlinedAt: !614)
!614 = distinct !DILocation(line: 847, column: 1, scope: !105, inlinedAt: !606)
!615 = !DILocation(line: 847, column: 1, scope: !105, inlinedAt: !606)
!616 = !DILocation(line: 175, column: 14, scope: !113, inlinedAt: !617)
!617 = distinct !DILocation(line: 321, column: 22, scope: !115, inlinedAt: !618)
!618 = distinct !DILocation(line: 436, column: 9, scope: !117, inlinedAt: !619)
!619 = distinct !DILocation(line: 554, column: 23, scope: !119, inlinedAt: !620)
!620 = distinct !DILocation(line: 2000, column: 24, scope: !121, inlinedAt: !621)
!621 = distinct !DILocation(line: 847, column: 1, scope: !105, inlinedAt: !606)
!622 = !{i64 2959862169947899045}
!623 = !DILocation(line: 847, column: 1, scope: !572, inlinedAt: !624)
!624 = distinct !DILocation(line: 847, column: 1, scope: !574, inlinedAt: !625)
!625 = distinct !DILocation(line: 847, column: 1, scope: !576)
!626 = !{!627}
!627 = distinct !{!627, !628, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtNtCs1SSuMAdGM58_3std3sys4sync8once_box7OnceBoxNtNtNtNtNtBI_3pal4unix4sync5mutex5MutexEECs5sHeypWcCKR_11runtime_lab: %_1"}
!628 = distinct !{!628, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtNtCs1SSuMAdGM58_3std3sys4sync8once_box7OnceBoxNtNtNtNtNtBI_3pal4unix4sync5mutex5MutexEECs5sHeypWcCKR_11runtime_lab"}
!629 = !{!630}
!630 = distinct !{!630, !631, !"_RNvXs1_NtNtNtCs1SSuMAdGM58_3std3sys4sync8once_boxINtB5_7OnceBoxNtNtNtNtNtB9_3pal4unix4sync5mutex5MutexENtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4dropCs5sHeypWcCKR_11runtime_lab: %self"}
!631 = distinct !{!631, !"_RNvXs1_NtNtNtCs1SSuMAdGM58_3std3sys4sync8once_boxINtB5_7OnceBoxNtNtNtNtNtB9_3pal4unix4sync5mutex5MutexENtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4dropCs5sHeypWcCKR_11runtime_lab"}
!632 = !DILocation(line: 847, column: 1, scope: !216, inlinedAt: !633)
!633 = distinct !DILocation(line: 847, column: 1, scope: !572, inlinedAt: !624)
!634 = !DILocation(line: 975, column: 22, scope: !223, inlinedAt: !635)
!635 = distinct !DILocation(line: 57, column: 19, scope: !225, inlinedAt: !636)
!636 = distinct !DILocation(line: 81, column: 14, scope: !227, inlinedAt: !637)
!637 = distinct !DILocation(line: 847, column: 1, scope: !216, inlinedAt: !633)
!638 = !{!630, !627, !639, !641}
!639 = distinct !{!639, !640, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtNtNtNtCs1SSuMAdGM58_3std3sys4sync5mutex7pthread5MutexECs5sHeypWcCKR_11runtime_lab: %_1"}
!640 = distinct !{!640, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtNtNtNtCs1SSuMAdGM58_3std3sys4sync5mutex7pthread5MutexECs5sHeypWcCKR_11runtime_lab"}
!641 = distinct !{!641, !642, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtNtCs1SSuMAdGM58_3std4sync6poison5mutex5MutexNtNtNtCs3EIJ1qnJmKW_5tokio4util4rand8FastRandEECs5sHeypWcCKR_11runtime_lab: %_1"}
!642 = distinct !{!642, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtNtCs1SSuMAdGM58_3std4sync6poison5mutex5MutexNtNtNtCs3EIJ1qnJmKW_5tokio4util4rand8FastRandEECs5sHeypWcCKR_11runtime_lab"}
!643 = !DILocation(line: 976, column: 49, scope: !231, inlinedAt: !635)
!644 = !DILocation(line: 38, column: 17, scope: !233, inlinedAt: !645)
!645 = distinct !DILocation(line: 2636, column: 9, scope: !241, inlinedAt: !646)
!646 = distinct !DILocation(line: 23, column: 27, scope: !245, inlinedAt: !647)
!647 = distinct !DILocation(line: 58, column: 17, scope: !250, inlinedAt: !636)
!648 = !DILocation(line: 847, column: 1, scope: !252, inlinedAt: !649)
!649 = distinct !DILocation(line: 81, column: 20, scope: !227, inlinedAt: !637)
!650 = !DILocation(line: 847, column: 1, scope: !77, inlinedAt: !651)
!651 = distinct !DILocation(line: 847, column: 1, scope: !105, inlinedAt: !652)
!652 = distinct !DILocation(line: 847, column: 1, scope: !141, inlinedAt: !653)
!653 = distinct !DILocation(line: 847, column: 1, scope: !252, inlinedAt: !649)
!654 = !{!630, !627}
!655 = !DILocation(line: 175, column: 14, scope: !113, inlinedAt: !656)
!656 = distinct !DILocation(line: 321, column: 22, scope: !115, inlinedAt: !657)
!657 = distinct !DILocation(line: 436, column: 9, scope: !117, inlinedAt: !658)
!658 = distinct !DILocation(line: 554, column: 23, scope: !119, inlinedAt: !659)
!659 = distinct !DILocation(line: 2000, column: 24, scope: !121, inlinedAt: !660)
!660 = distinct !DILocation(line: 847, column: 1, scope: !105, inlinedAt: !652)
!661 = !DILocation(line: 847, column: 1, scope: !105, inlinedAt: !652)
!662 = !DILocation(line: 175, column: 14, scope: !113, inlinedAt: !663)
!663 = distinct !DILocation(line: 321, column: 22, scope: !115, inlinedAt: !664)
!664 = distinct !DILocation(line: 436, column: 9, scope: !117, inlinedAt: !665)
!665 = distinct !DILocation(line: 554, column: 23, scope: !119, inlinedAt: !666)
!666 = distinct !DILocation(line: 2000, column: 24, scope: !121, inlinedAt: !667)
!667 = distinct !DILocation(line: 847, column: 1, scope: !105, inlinedAt: !652)
!668 = !DILocation(line: 847, column: 1, scope: !576)
!669 = distinct !DISubprogram(name: "assert_failed<core::option::Option<core::ptr::non_null::NonNull<tokio::runtime::task::core::Header>>, core::option::Option<core::ptr::non_null::NonNull<tokio::runtime::task::core::Header>>>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core9panicking13assert_failedINtNtB4_6option6OptionINtNtNtB4_3ptr8non_null7NonNullNtNtNtNtCs3EIJ1qnJmKW_5tokio7runtime4task4core6HeaderEEBM_ECs5sHeypWcCKR_11runtime_lab", scope: !671, file: !670, line: 397, type: !24, scopeLine: 397, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !25)
!670 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/panicking.rs", directory: "", checksumkind: CSK_MD5, checksum: "e7c8cdef070824bb84944b59182595c2")
!671 = !DINamespace(name: "panicking", scope: !80)
!672 = !{i64 -1464781339998456473}
!673 = !DILocation(line: 407, column: 5, scope: !669)
!674 = distinct !DISubprogram(name: "multi_runtime", linkageName: "_RNvCs5sHeypWcCKR_11runtime_lab13multi_runtime", scope: !676, file: !675, line: 12, type: !24, scopeLine: 12, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !25)
!675 = !DIFile(filename: "src/lib.rs", directory: "/Users/juanwang/Desktop/tutorials/cpp-rust/bench/runtime-lab", checksumkind: CSK_MD5, checksum: "5f9758c4b643e050462ae4ab87116146")
!676 = !DINamespace(name: "runtime_lab", scope: null)
!677 = !{i64 818074586474387610}
!678 = !DILocation(line: 13, column: 5, scope: !674)
!679 = !DILocation(line: 14, column: 10, scope: !674)
!680 = !DILocation(line: 17, column: 1, scope: !674)
!681 = !DILocation(line: 1852, column: 9, scope: !682, inlinedAt: !688)
!682 = distinct !DISubprogram(name: "enable_io", linkageName: "_RNvMNtNtCs3EIJ1qnJmKW_5tokio7runtime7builderNtB2_7Builder9enable_io", scope: !684, file: !683, line: 1851, type: !24, scopeLine: 1851, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !25)
!683 = !DIFile(filename: "src/runtime/builder.rs", directory: "/Users/juanwang/.cargo/registry/src/mirrors.bfsu.edu.cn-eb00624c53167367/tokio-1.54.0", checksumkind: CSK_MD5, checksum: "e72aaf31387e8751c856feceaa4ef6b3")
!684 = !DINamespace(name: "Builder", scope: !685)
!685 = !DINamespace(name: "builder", scope: !686)
!686 = !DINamespace(name: "runtime", scope: !687)
!687 = !DINamespace(name: "tokio", scope: null)
!688 = !DILocation(line: 404, column: 14, scope: !689, inlinedAt: !690)
!689 = distinct !DISubprogram(name: "enable_all", linkageName: "_RNvMNtNtCs3EIJ1qnJmKW_5tokio7runtime7builderNtB2_7Builder10enable_all", scope: !684, file: !683, line: 398, type: !24, scopeLine: 398, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !25)
!690 = !DILocation(line: 15, column: 10, scope: !674)
!691 = !DILocation(line: 1952, column: 13, scope: !692, inlinedAt: !693)
!692 = distinct !DISubprogram(name: "enable_time", linkageName: "_RNvMs3_NtNtCs3EIJ1qnJmKW_5tokio7runtime7builderNtB5_7Builder11enable_time", scope: !684, file: !683, line: 1951, type: !24, scopeLine: 1951, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !25)
!693 = !DILocation(line: 416, column: 14, scope: !689, inlinedAt: !690)
!694 = !DILocation(line: 16, column: 10, scope: !674)
!695 = !DILocation(line: 17, column: 2, scope: !674)
!696 = !DILocation(line: 12, column: 1, scope: !674)
!697 = distinct !DISubprogram(name: "current_runtime", linkageName: "_RNvCs5sHeypWcCKR_11runtime_lab15current_runtime", scope: !676, file: !675, line: 8, type: !24, scopeLine: 8, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !25)
!698 = !{i64 7615424065366290682}
!699 = !DILocation(line: 9, column: 5, scope: !697)
!700 = !DILocation(line: 1852, column: 9, scope: !701, inlinedAt: !702)
!701 = distinct !DISubprogram(name: "enable_io", linkageName: "_RNvMNtNtCs3EIJ1qnJmKW_5tokio7runtime7builderNtB2_7Builder9enable_io", scope: !684, file: !683, line: 1851, type: !24, scopeLine: 1851, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !25)
!702 = !DILocation(line: 404, column: 14, scope: !703, inlinedAt: !704)
!703 = distinct !DISubprogram(name: "enable_all", linkageName: "_RNvMNtNtCs3EIJ1qnJmKW_5tokio7runtime7builderNtB2_7Builder10enable_all", scope: !684, file: !683, line: 398, type: !24, scopeLine: 398, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !25)
!704 = !DILocation(line: 9, column: 35, scope: !697)
!705 = !DILocation(line: 1952, column: 13, scope: !706, inlinedAt: !707)
!706 = distinct !DISubprogram(name: "enable_time", linkageName: "_RNvMs3_NtNtCs3EIJ1qnJmKW_5tokio7runtime7builderNtB5_7Builder11enable_time", scope: !684, file: !683, line: 1951, type: !24, scopeLine: 1951, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !25)
!707 = !DILocation(line: 416, column: 14, scope: !703, inlinedAt: !704)
!708 = !DILocation(line: 9, column: 48, scope: !697)
!709 = !DILocation(line: 10, column: 1, scope: !697)
!710 = !DILocation(line: 10, column: 2, scope: !697)
!711 = !DILocation(line: 8, column: 1, scope: !697)
!712 = distinct !DISubprogram(name: "decode", linkageName: "_RNvMNtCs5sHeypWcCKR_11runtime_lab4wireNtB2_5Frame6decode", scope: !714, file: !713, line: 22, type: !24, scopeLine: 22, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !25)
!713 = !DIFile(filename: "src/wire.rs", directory: "/Users/juanwang/Desktop/tutorials/cpp-rust/bench/runtime-lab", checksumkind: CSK_MD5, checksum: "dbc5ac82426548902fbe72228fde1078")
!714 = !DINamespace(name: "Frame", scope: !715)
!715 = !DINamespace(name: "wire", scope: !676)
!716 = !{i64 -2988267662494967957}
!717 = !DILocation(line: 157, column: 18, scope: !718, inlinedAt: !723)
!718 = distinct !DISubprogram(name: "spec_eq<u8, u8, 2>", linkageName: "_RNvXs7_NtNtCsjIpoRzUjyHQ_4core5array8equalityhINtB5_11SpecArrayEqhKj2_E7spec_eqCs5sHeypWcCKR_11runtime_lab", scope: !720, file: !719, line: 153, type: !24, scopeLine: 153, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !25)
!719 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/array/equality.rs", directory: "", checksumkind: CSK_MD5, checksum: "2e8ad1e2d89117c8c3eff8a826c8ea1c")
!720 = !DINamespace(name: "{impl#9}", scope: !721)
!721 = !DINamespace(name: "equality", scope: !722)
!722 = !DINamespace(name: "array", scope: !80)
!723 = !DILocation(line: 160, column: 10, scope: !724, inlinedAt: !725)
!724 = distinct !DISubprogram(name: "spec_ne<u8, u8, 2>", linkageName: "_RNvXs7_NtNtCsjIpoRzUjyHQ_4core5array8equalityhINtB5_11SpecArrayEqhKj2_E7spec_neCs5sHeypWcCKR_11runtime_lab", scope: !720, file: !719, line: 159, type: !24, scopeLine: 159, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !25)
!725 = !DILocation(line: 15, column: 9, scope: !726, inlinedAt: !728)
!726 = distinct !DISubprogram(name: "ne<u8, u8, 2>", linkageName: "_RNvXNtNtCsjIpoRzUjyHQ_4core5array8equalityAhj2_NtNtB6_3cmp9PartialEq2neCs5sHeypWcCKR_11runtime_lab", scope: !727, file: !719, line: 14, type: !24, scopeLine: 14, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !25)
!727 = !DINamespace(name: "{impl#0}", scope: !721)
!728 = !DILocation(line: 57, column: 24, scope: !729, inlinedAt: !732)
!729 = distinct !DILexicalBlock(scope: !730, file: !719, line: 57, column: 13)
!730 = distinct !DISubprogram(name: "ne<u8, u8, 2>", linkageName: "_RNvXs0_NtNtCsjIpoRzUjyHQ_4core5array8equalityShINtNtB9_3cmp9PartialEqAhj2_E2neCs5sHeypWcCKR_11runtime_lab", scope: !731, file: !719, line: 55, type: !24, scopeLine: 55, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !25)
!731 = !DINamespace(name: "{impl#2}", scope: !721)
!732 = !DILocation(line: 23, column: 12, scope: !712)
!733 = !DILocation(line: 27, column: 24, scope: !712)
!734 = !DILocation(line: 40, column: 6, scope: !712)
!735 = !DILocation(line: 90, column: 24, scope: !736, inlinedAt: !741)
!736 = distinct !DILexicalBlock(scope: !738, file: !737, line: 88, column: 5)
!737 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/slice/index.rs", directory: "", checksumkind: CSK_MD5, checksum: "a6478e6d30216db9f8cdcb9288808b92")
!738 = distinct !DISubprogram(name: "get_offset_len_noubcheck<u8>", linkageName: "_RINvNtNtCsjIpoRzUjyHQ_4core5slice5index24get_offset_len_noubcheckhECs5sHeypWcCKR_11runtime_lab", scope: !739, file: !737, line: 83, type: !24, scopeLine: 83, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !25)
!739 = !DINamespace(name: "index", scope: !740)
!740 = !DINamespace(name: "slice", scope: !80)
!741 = !DILocation(line: 411, column: 24, scope: !742, inlinedAt: !745)
!742 = !DILexicalBlockFile(scope: !743, file: !737, discriminator: 6)
!743 = distinct !DISubprogram(name: "index<u8>", linkageName: "_RNvXs2_NtNtCsjIpoRzUjyHQ_4core5slice5indexINtNtNtB9_3ops5range5RangejEINtB5_10SliceIndexShE5indexCs5sHeypWcCKR_11runtime_lab", scope: !744, file: !737, line: 405, type: !24, scopeLine: 405, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !25)
!744 = !DINamespace(name: "{impl#4}", scope: !739)
!745 = !DILocation(line: 19, column: 15, scope: !746, inlinedAt: !749)
!746 = !DILexicalBlockFile(scope: !747, file: !737, discriminator: 6)
!747 = distinct !DISubprogram(name: "index<u8, core::ops::range::Range<usize>>", linkageName: "_RNvXNtNtCsjIpoRzUjyHQ_4core5slice5indexShINtNtNtB6_3ops5index5IndexINtNtBI_5range5RangejEE5indexCs5sHeypWcCKR_11runtime_lab", scope: !748, file: !737, line: 18, type: !24, scopeLine: 18, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !25)
!748 = !DINamespace(name: "{impl#0}", scope: !739)
!749 = !DILocation(line: 391, column: 9, scope: !750, inlinedAt: !754)
!750 = !DILexicalBlockFile(scope: !752, file: !751, discriminator: 6)
!751 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/array/mod.rs", directory: "", checksumkind: CSK_MD5, checksum: "7a70bfbf63cdead6b6acc4823ebb6443")
!752 = distinct !DISubprogram(name: "index<u8, core::ops::range::Range<usize>, 24>", linkageName: "_RNvXsd_NtCsjIpoRzUjyHQ_4core5arrayAhj18_INtNtNtB7_3ops5index5IndexINtNtBH_5range5RangejEE5indexCs5sHeypWcCKR_11runtime_lab", scope: !753, file: !751, line: 390, type: !24, scopeLine: 390, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !25)
!753 = !DINamespace(name: "{impl#15}", scope: !722)
!754 = !DILocation(line: 33, column: 34, scope: !755)
!755 = distinct !DILexicalBlock(scope: !712, file: !713, line: 32, column: 9)
!756 = !DILocation(line: 573, column: 14, scope: !757, inlinedAt: !758)
!757 = distinct !DISubprogram(name: "copy_nonoverlapping<u8>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3ptr19copy_nonoverlappinghECs5sHeypWcCKR_11runtime_lab", scope: !79, file: !78, line: 552, type: !24, scopeLine: 552, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !25)
!758 = distinct !DILocation(line: 5605, column: 9, scope: !759, inlinedAt: !761)
!759 = distinct !DISubprogram(name: "copy_from_slice_impl<u8>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core5slice20copy_from_slice_implhECs5sHeypWcCKR_11runtime_lab", scope: !740, file: !760, line: 5582, type: !24, scopeLine: 5582, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !25)
!760 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/slice/mod.rs", directory: "", checksumkind: CSK_MD5, checksum: "3864a87bb6bc29c76dd67717f51013ca")
!761 = distinct !DILocation(line: 4344, column: 18, scope: !762, inlinedAt: !764)
!762 = distinct !DISubprogram(name: "copy_from_slice<u8>", linkageName: "_RNvMNtCsjIpoRzUjyHQ_4core5sliceSh15copy_from_sliceCs5sHeypWcCKR_11runtime_lab", scope: !763, file: !760, line: 4339, type: !24, scopeLine: 4339, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !25)
!763 = !DINamespace(name: "{impl#0}", scope: !740)
!764 = !DILocation(line: 33, column: 12, scope: !755)
!765 = !{!766, !768}
!766 = distinct !{!766, !767, !"_RINvNtCsjIpoRzUjyHQ_4core5slice20copy_from_slice_implhECs5sHeypWcCKR_11runtime_lab: %dest.0"}
!767 = distinct !{!767, !"_RINvNtCsjIpoRzUjyHQ_4core5slice20copy_from_slice_implhECs5sHeypWcCKR_11runtime_lab"}
!768 = distinct !{!768, !767, !"_RINvNtCsjIpoRzUjyHQ_4core5slice20copy_from_slice_implhECs5sHeypWcCKR_11runtime_lab: %src.0"}
!769 = !{!770}
!770 = distinct !{!770, !767, !"_RINvNtCsjIpoRzUjyHQ_4core5slice20copy_from_slice_implhECs5sHeypWcCKR_11runtime_lab: argument 2"}
!771 = !DILocation(line: 90, column: 24, scope: !772, inlinedAt: !773)
!772 = distinct !DILexicalBlock(scope: !738, file: !737, line: 88, column: 5)
!773 = !DILocation(line: 411, column: 24, scope: !774, inlinedAt: !775)
!774 = !DILexicalBlockFile(scope: !743, file: !737, discriminator: 8)
!775 = !DILocation(line: 19, column: 15, scope: !776, inlinedAt: !777)
!776 = !DILexicalBlockFile(scope: !747, file: !737, discriminator: 8)
!777 = !DILocation(line: 391, column: 9, scope: !778, inlinedAt: !779)
!778 = !DILexicalBlockFile(scope: !752, file: !751, discriminator: 8)
!779 = !DILocation(line: 35, column: 37, scope: !780)
!780 = distinct !DILexicalBlock(scope: !755, file: !713, line: 34, column: 9)
!781 = !DILocation(line: 573, column: 14, scope: !757, inlinedAt: !782)
!782 = distinct !DILocation(line: 5605, column: 9, scope: !759, inlinedAt: !783)
!783 = distinct !DILocation(line: 4344, column: 18, scope: !762, inlinedAt: !784)
!784 = !DILocation(line: 35, column: 15, scope: !780)
!785 = !{!786, !788}
!786 = distinct !{!786, !787, !"_RINvNtCsjIpoRzUjyHQ_4core5slice20copy_from_slice_implhECs5sHeypWcCKR_11runtime_lab: %dest.0"}
!787 = distinct !{!787, !"_RINvNtCsjIpoRzUjyHQ_4core5slice20copy_from_slice_implhECs5sHeypWcCKR_11runtime_lab"}
!788 = distinct !{!788, !787, !"_RINvNtCsjIpoRzUjyHQ_4core5slice20copy_from_slice_implhECs5sHeypWcCKR_11runtime_lab: %src.0"}
!789 = !{!790}
!790 = distinct !{!790, !787, !"_RINvNtCsjIpoRzUjyHQ_4core5slice20copy_from_slice_implhECs5sHeypWcCKR_11runtime_lab: argument 2"}
!791 = !DILocation(line: 0, scope: !712)
!792 = !DILocation(line: 36, column: 9, scope: !780)
!793 = distinct !DISubprogram(name: "encode", linkageName: "_RNvMNtCs5sHeypWcCKR_11runtime_lab4wireNtB2_5Frame6encode", scope: !714, file: !713, line: 13, type: !24, scopeLine: 13, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !25)
!794 = !{i64 6891574293530224911}
!795 = !DILocation(line: 19, column: 9, scope: !796)
!796 = distinct !DILexicalBlock(scope: !793, file: !713, line: 14, column: 9)
!797 = !DILocation(line: 20, column: 6, scope: !793)
!798 = distinct !DISubprogram(name: "drop_slow<std::sync::poison::mutex::Mutex<runtime_lab::process::Capture>, alloc::alloc::Global>", linkageName: "_RNvMsn_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcINtNtNtNtCs1SSuMAdGM58_3std4sync6poison5mutex5MutexNtNtCs5sHeypWcCKR_11runtime_lab7process7CaptureEE9drop_slowB1z_", scope: !316, file: !315, line: 2138, type: !24, scopeLine: 2138, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !25)
!799 = !{i64 7964022877685939007}
!800 = !DILocation(line: 2144, column: 33, scope: !798)
!801 = !DILocation(line: 842, column: 24, scope: !802, inlinedAt: !803)
!802 = distinct !DISubprogram(name: "drop_in_place<std::sync::poison::mutex::Mutex<runtime_lab::process::Capture>>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3ptr13drop_in_placeINtNtNtNtCs1SSuMAdGM58_3std4sync6poison5mutex5MutexNtNtCs5sHeypWcCKR_11runtime_lab7process7CaptureEEB1z_", scope: !79, file: !78, line: 830, type: !24, scopeLine: 830, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !25)
!803 = !DILocation(line: 2149, column: 18, scope: !804)
!804 = distinct !DILexicalBlock(scope: !798, file: !315, line: 2144, column: 9)
!805 = !DILocation(line: 847, column: 1, scope: !572, inlinedAt: !806)
!806 = distinct !DILocation(line: 847, column: 1, scope: !807, inlinedAt: !808)
!807 = distinct !DISubprogram(name: "drop_glue<std::sync::poison::mutex::Mutex<runtime_lab::process::Capture>>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtNtCs1SSuMAdGM58_3std4sync6poison5mutex5MutexNtNtCs5sHeypWcCKR_11runtime_lab7process7CaptureEEB1u_", scope: !79, file: !78, line: 847, type: !24, scopeLine: 847, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !25)
!808 = distinct !DILocation(line: 842, column: 14, scope: !802, inlinedAt: !803)
!809 = !{!810}
!810 = distinct !{!810, !811, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtNtCs1SSuMAdGM58_3std3sys4sync8once_box7OnceBoxNtNtNtNtNtBI_3pal4unix4sync5mutex5MutexEECs5sHeypWcCKR_11runtime_lab: %_1"}
!811 = distinct !{!811, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtNtCs1SSuMAdGM58_3std3sys4sync8once_box7OnceBoxNtNtNtNtNtBI_3pal4unix4sync5mutex5MutexEECs5sHeypWcCKR_11runtime_lab"}
!812 = !{!813}
!813 = distinct !{!813, !814, !"_RNvXs1_NtNtNtCs1SSuMAdGM58_3std3sys4sync8once_boxINtB5_7OnceBoxNtNtNtNtNtB9_3pal4unix4sync5mutex5MutexENtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4dropCs5sHeypWcCKR_11runtime_lab: %self"}
!814 = distinct !{!814, !"_RNvXs1_NtNtNtCs1SSuMAdGM58_3std3sys4sync8once_boxINtB5_7OnceBoxNtNtNtNtNtB9_3pal4unix4sync5mutex5MutexENtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4dropCs5sHeypWcCKR_11runtime_lab"}
!815 = !DILocation(line: 847, column: 1, scope: !216, inlinedAt: !816)
!816 = distinct !DILocation(line: 847, column: 1, scope: !572, inlinedAt: !806)
!817 = !DILocation(line: 975, column: 22, scope: !223, inlinedAt: !818)
!818 = distinct !DILocation(line: 57, column: 19, scope: !225, inlinedAt: !819)
!819 = distinct !DILocation(line: 81, column: 14, scope: !227, inlinedAt: !820)
!820 = distinct !DILocation(line: 847, column: 1, scope: !216, inlinedAt: !816)
!821 = !{!813, !810, !822, !824}
!822 = distinct !{!822, !823, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtNtNtNtCs1SSuMAdGM58_3std3sys4sync5mutex7pthread5MutexECs5sHeypWcCKR_11runtime_lab: %_1"}
!823 = distinct !{!823, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtNtNtNtCs1SSuMAdGM58_3std3sys4sync5mutex7pthread5MutexECs5sHeypWcCKR_11runtime_lab"}
!824 = distinct !{!824, !825, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtNtCs1SSuMAdGM58_3std4sync6poison5mutex5MutexNtNtCs5sHeypWcCKR_11runtime_lab7process7CaptureEEB1u_: %_1"}
!825 = distinct !{!825, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtNtCs1SSuMAdGM58_3std4sync6poison5mutex5MutexNtNtCs5sHeypWcCKR_11runtime_lab7process7CaptureEEB1u_"}
!826 = !DILocation(line: 976, column: 49, scope: !231, inlinedAt: !818)
!827 = !DILocation(line: 38, column: 17, scope: !233, inlinedAt: !828)
!828 = distinct !DILocation(line: 2636, column: 9, scope: !241, inlinedAt: !829)
!829 = distinct !DILocation(line: 23, column: 27, scope: !245, inlinedAt: !830)
!830 = distinct !DILocation(line: 58, column: 17, scope: !250, inlinedAt: !819)
!831 = !DILocation(line: 847, column: 1, scope: !252, inlinedAt: !832)
!832 = distinct !DILocation(line: 81, column: 20, scope: !227, inlinedAt: !820)
!833 = !DILocation(line: 847, column: 1, scope: !77, inlinedAt: !834)
!834 = distinct !DILocation(line: 847, column: 1, scope: !105, inlinedAt: !835)
!835 = distinct !DILocation(line: 847, column: 1, scope: !141, inlinedAt: !836)
!836 = distinct !DILocation(line: 847, column: 1, scope: !252, inlinedAt: !832)
!837 = !{!813, !810}
!838 = !DILocation(line: 175, column: 14, scope: !113, inlinedAt: !839)
!839 = distinct !DILocation(line: 321, column: 22, scope: !115, inlinedAt: !840)
!840 = distinct !DILocation(line: 436, column: 9, scope: !117, inlinedAt: !841)
!841 = distinct !DILocation(line: 554, column: 23, scope: !119, inlinedAt: !842)
!842 = distinct !DILocation(line: 2000, column: 24, scope: !121, inlinedAt: !843)
!843 = distinct !DILocation(line: 847, column: 1, scope: !105, inlinedAt: !835)
!844 = !DILocation(line: 847, column: 1, scope: !105, inlinedAt: !835)
!845 = !DILocation(line: 175, column: 14, scope: !113, inlinedAt: !846)
!846 = distinct !DILocation(line: 321, column: 22, scope: !115, inlinedAt: !847)
!847 = distinct !DILocation(line: 436, column: 9, scope: !117, inlinedAt: !848)
!848 = distinct !DILocation(line: 554, column: 23, scope: !119, inlinedAt: !849)
!849 = distinct !DILocation(line: 2000, column: 24, scope: !121, inlinedAt: !850)
!850 = distinct !DILocation(line: 847, column: 1, scope: !105, inlinedAt: !835)
!851 = !DILocation(line: 847, column: 1, scope: !807, inlinedAt: !808)
!852 = !{!824}
!853 = !DILocation(line: 631, column: 39, scope: !854, inlinedAt: !855)
!854 = distinct !DISubprogram(name: "current_memory<alloc::alloc::Global>", linkageName: "_RNvMs2_NtCs6zY7rJBZy9D_5alloc7raw_vecNtB5_11RawVecInner14current_memoryCs5sHeypWcCKR_11runtime_lab", scope: !286, file: !284, line: 630, type: !96, scopeLine: 630, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !25)
!855 = distinct !DILocation(line: 874, column: 52, scope: !283, inlinedAt: !856)
!856 = distinct !DILocation(line: 425, column: 29, scope: !289, inlinedAt: !857)
!857 = distinct !DILocation(line: 847, column: 1, scope: !292, inlinedAt: !858)
!858 = distinct !DILocation(line: 847, column: 1, scope: !294, inlinedAt: !859)
!859 = distinct !DILocation(line: 847, column: 1, scope: !860, inlinedAt: !861)
!860 = distinct !DISubprogram(name: "drop_glue<runtime_lab::process::Capture>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtCs5sHeypWcCKR_11runtime_lab7process7CaptureEBF_", scope: !79, file: !78, line: 847, type: !96, scopeLine: 847, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !25)
!861 = distinct !DILocation(line: 847, column: 1, scope: !862, inlinedAt: !863)
!862 = distinct !DISubprogram(name: "drop_glue<core::cell::UnsafeCell<runtime_lab::process::Capture>>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtB4_4cell10UnsafeCellNtNtCs5sHeypWcCKR_11runtime_lab7process7CaptureEEB14_", scope: !79, file: !78, line: 847, type: !96, scopeLine: 847, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !25)
!863 = distinct !DILocation(line: 847, column: 1, scope: !807, inlinedAt: !808)
!864 = !DILocation(line: 175, column: 14, scope: !113, inlinedAt: !865)
!865 = distinct !DILocation(line: 321, column: 22, scope: !115, inlinedAt: !866)
!866 = distinct !DILocation(line: 436, column: 9, scope: !117, inlinedAt: !867)
!867 = distinct !DILocation(line: 554, column: 23, scope: !119, inlinedAt: !868)
!868 = distinct !DILocation(line: 876, column: 28, scope: !283, inlinedAt: !856)
!869 = !DILocation(line: 874, column: 9, scope: !285, inlinedAt: !856)
!870 = !DILocation(line: 631, column: 39, scope: !854, inlinedAt: !871)
!871 = distinct !DILocation(line: 874, column: 52, scope: !283, inlinedAt: !872)
!872 = distinct !DILocation(line: 425, column: 29, scope: !289, inlinedAt: !873)
!873 = distinct !DILocation(line: 847, column: 1, scope: !292, inlinedAt: !874)
!874 = distinct !DILocation(line: 847, column: 1, scope: !294, inlinedAt: !875)
!875 = distinct !DILocation(line: 847, column: 1, scope: !860, inlinedAt: !876)
!876 = distinct !DILocation(line: 847, column: 1, scope: !862, inlinedAt: !877)
!877 = distinct !DILocation(line: 847, column: 1, scope: !807, inlinedAt: !808)
!878 = !DILocation(line: 175, column: 14, scope: !113, inlinedAt: !879)
!879 = distinct !DILocation(line: 321, column: 22, scope: !115, inlinedAt: !880)
!880 = distinct !DILocation(line: 436, column: 9, scope: !117, inlinedAt: !881)
!881 = distinct !DILocation(line: 554, column: 23, scope: !119, inlinedAt: !882)
!882 = distinct !DILocation(line: 876, column: 28, scope: !283, inlinedAt: !872)
!883 = !DILocation(line: 874, column: 9, scope: !285, inlinedAt: !872)
!884 = !DILocation(line: 3277, column: 5, scope: !885, inlinedAt: !888)
!885 = distinct !DISubprogram(name: "is_dangling<alloc::sync::ArcInner<std::sync::poison::mutex::Mutex<runtime_lab::process::Capture>>>", linkageName: "_RINvNtCs6zY7rJBZy9D_5alloc2rc11is_danglingINtNtB4_4sync8ArcInnerINtNtNtNtCs1SSuMAdGM58_3std4sync6poison5mutex5MutexNtNtCs5sHeypWcCKR_11runtime_lab7process7CaptureEEEB1T_", scope: !887, file: !886, line: 3276, type: !24, scopeLine: 3276, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !25)
!886 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/alloc/src/rc.rs", directory: "", checksumkind: CSK_MD5, checksum: "a6f930e5de5e5db13ac0efed74f8947a")
!887 = !DINamespace(name: "rc", scope: !48)
!888 = distinct !DILocation(line: 3392, column: 12, scope: !889, inlinedAt: !892)
!889 = distinct !DILexicalBlock(scope: !890, file: !315, line: 3391, column: 9)
!890 = distinct !DISubprogram(name: "inner<std::sync::poison::mutex::Mutex<runtime_lab::process::Capture>, &alloc::alloc::Global>", linkageName: "_RNvMsK_NtCs6zY7rJBZy9D_5alloc4syncINtB5_4WeakINtNtNtNtCs1SSuMAdGM58_3std4sync6poison5mutex5MutexNtNtCs5sHeypWcCKR_11runtime_lab7process7CaptureERNtNtB7_5alloc6GlobalE5innerB1A_", scope: !891, file: !315, line: 3390, type: !24, scopeLine: 3390, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !25)
!891 = !DINamespace(name: "Weak", scope: !317)
!892 = distinct !DILocation(line: 3542, column: 47, scope: !893, inlinedAt: !896)
!893 = distinct !DILexicalBlock(scope: !894, file: !315, line: 3542, column: 55)
!894 = distinct !DISubprogram(name: "drop<std::sync::poison::mutex::Mutex<runtime_lab::process::Capture>, &alloc::alloc::Global>", linkageName: "_RNvXsO_NtCs6zY7rJBZy9D_5alloc4syncINtB5_4WeakINtNtNtNtCs1SSuMAdGM58_3std4sync6poison5mutex5MutexNtNtCs5sHeypWcCKR_11runtime_lab7process7CaptureERNtNtB7_5alloc6GlobalENtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4dropB1A_", scope: !895, file: !315, line: 3533, type: !96, scopeLine: 3533, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !25)
!895 = !DINamespace(name: "{impl#52}", scope: !317)
!896 = distinct !DILocation(line: 847, column: 1, scope: !897, inlinedAt: !898)
!897 = distinct !DISubprogram(name: "drop_glue<alloc::sync::Weak<std::sync::poison::mutex::Mutex<runtime_lab::process::Capture>, &alloc::alloc::Global>>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc4sync4WeakINtNtNtNtCs1SSuMAdGM58_3std4sync6poison5mutex5MutexNtNtCs5sHeypWcCKR_11runtime_lab7process7CaptureERNtNtBG_5alloc6GlobalEEB23_", scope: !79, file: !78, line: 847, type: !96, scopeLine: 847, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !25)
!898 = distinct !DILocation(line: 2150, column: 5, scope: !798)
!899 = !DILocation(line: 3392, column: 12, scope: !889, inlinedAt: !892)
!900 = !DILocation(line: 3398, column: 69, scope: !889, inlinedAt: !892)
!901 = !DILocation(line: 4049, column: 24, scope: !902, inlinedAt: !903)
!902 = distinct !DISubprogram(name: "atomic_sub<usize, usize>", linkageName: "_RINvNtNtCsjIpoRzUjyHQ_4core4sync6atomic10atomic_subjjECs5sHeypWcCKR_11runtime_lab", scope: !94, file: !93, line: 4043, type: !24, scopeLine: 4043, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !25)
!903 = distinct !DILocation(line: 3253, column: 26, scope: !904, inlinedAt: !905)
!904 = distinct !DISubprogram(name: "fetch_sub", linkageName: "_RNvMs1g_NtNtCsjIpoRzUjyHQ_4core4sync6atomicINtB6_6AtomicjE9fetch_sub", scope: !99, file: !93, line: 3251, type: !24, scopeLine: 3251, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !25)
!905 = distinct !DILocation(line: 3544, column: 23, scope: !906, inlinedAt: !896)
!906 = distinct !DILexicalBlock(scope: !894, file: !315, line: 3542, column: 9)
!907 = !DILocation(line: 3544, column: 12, scope: !906, inlinedAt: !896)
!908 = !DILocation(line: 4493, column: 24, scope: !330, inlinedAt: !909)
!909 = distinct !DILocation(line: 69, column: 9, scope: !906, inlinedAt: !896)
!910 = !DILocation(line: 175, column: 14, scope: !113, inlinedAt: !911)
!911 = distinct !DILocation(line: 321, column: 22, scope: !115, inlinedAt: !912)
!912 = distinct !DILocation(line: 436, column: 9, scope: !117, inlinedAt: !913)
!913 = distinct !DILocation(line: 554, column: 23, scope: !119, inlinedAt: !914)
!914 = distinct !DILocation(line: 582, column: 27, scope: !915, inlinedAt: !919)
!915 = distinct !DISubprogram(name: "deallocate<alloc::alloc::Global>", linkageName: "_RNvXs0_NtCsjIpoRzUjyHQ_4core5allocRNtNtCs6zY7rJBZy9D_5alloc5alloc6GlobalNtB5_9Allocator10deallocateCs5sHeypWcCKR_11runtime_lab", scope: !917, file: !916, line: 580, type: !96, scopeLine: 580, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !25)
!916 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/alloc/mod.rs", directory: "", checksumkind: CSK_MD5, checksum: "38c8aeed2125a53c1a785ff85780c84e")
!917 = !DINamespace(name: "{impl#2}", scope: !918)
!918 = !DINamespace(name: "alloc", scope: !80)
!919 = distinct !DILocation(line: 3556, column: 28, scope: !906, inlinedAt: !896)
!920 = !DILocation(line: 3544, column: 9, scope: !906, inlinedAt: !896)
!921 = !DILocation(line: 3277, column: 5, scope: !885, inlinedAt: !922)
!922 = distinct !DILocation(line: 3392, column: 12, scope: !889, inlinedAt: !923)
!923 = distinct !DILocation(line: 3542, column: 47, scope: !893, inlinedAt: !924)
!924 = distinct !DILocation(line: 847, column: 1, scope: !897, inlinedAt: !925)
!925 = distinct !DILocation(line: 2150, column: 5, scope: !798)
!926 = !DILocation(line: 3392, column: 12, scope: !889, inlinedAt: !923)
!927 = !DILocation(line: 3398, column: 69, scope: !889, inlinedAt: !923)
!928 = !DILocation(line: 4049, column: 24, scope: !902, inlinedAt: !929)
!929 = distinct !DILocation(line: 3253, column: 26, scope: !904, inlinedAt: !930)
!930 = distinct !DILocation(line: 3544, column: 23, scope: !906, inlinedAt: !924)
!931 = !DILocation(line: 3544, column: 12, scope: !906, inlinedAt: !924)
!932 = !DILocation(line: 4493, column: 24, scope: !330, inlinedAt: !933)
!933 = distinct !DILocation(line: 69, column: 9, scope: !906, inlinedAt: !924)
!934 = !DILocation(line: 175, column: 14, scope: !113, inlinedAt: !935)
!935 = distinct !DILocation(line: 321, column: 22, scope: !115, inlinedAt: !936)
!936 = distinct !DILocation(line: 436, column: 9, scope: !117, inlinedAt: !937)
!937 = distinct !DILocation(line: 554, column: 23, scope: !119, inlinedAt: !938)
!938 = distinct !DILocation(line: 582, column: 27, scope: !915, inlinedAt: !939)
!939 = distinct !DILocation(line: 3556, column: 28, scope: !906, inlinedAt: !924)
!940 = !DILocation(line: 3544, column: 9, scope: !906, inlinedAt: !924)
!941 = !DILocation(line: 2150, column: 6, scope: !798)
!942 = !DILocation(line: 2138, column: 5, scope: !798)
!943 = distinct !DISubprogram(name: "state_lock", linkageName: "_RNvNtCs5sHeypWcCKR_11runtime_lab7process10state_lock", scope: !945, file: !944, line: 33, type: !24, scopeLine: 33, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !25)
!944 = !DIFile(filename: "src/process.rs", directory: "/Users/juanwang/Desktop/tutorials/cpp-rust/bench/runtime-lab", checksumkind: CSK_MD5, checksum: "508148f879a1d3fdcd20da2e2dab8b10")
!945 = !DINamespace(name: "process", scope: !676)
!946 = !{i64 6800201214412990428}
!947 = !DILocation(line: 3995, column: 24, scope: !205, inlinedAt: !948)
!948 = distinct !DILocation(line: 1765, column: 18, scope: !949, inlinedAt: !950)
!949 = distinct !DISubprogram(name: "load<std::sys::pal::unix::sync::mutex::Mutex>", linkageName: "_RNvMs3_NtNtCsjIpoRzUjyHQ_4core4sync6atomicINtB5_6AtomicONtNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutex5MutexE4loadCs5sHeypWcCKR_11runtime_lab", scope: !99, file: !93, line: 1763, type: !24, scopeLine: 1763, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !25)
!950 = distinct !DILocation(line: 48, column: 28, scope: !951, inlinedAt: !952)
!951 = distinct !DISubprogram(name: "get_or_init<std::sys::pal::unix::sync::mutex::Mutex, std::sys::sync::mutex::pthread::{impl#0}::get::{closure_env#0}>", linkageName: "_RINvMNtNtNtCs1SSuMAdGM58_3std3sys4sync8once_boxINtB3_7OnceBoxNtNtNtNtNtB7_3pal4unix4sync5mutex5MutexE11get_or_initNCNvMNtNtB5_5mutex7pthreadNtB1T_5Mutex3get0ECs5sHeypWcCKR_11runtime_lab", scope: !19, file: !18, line: 47, type: !24, scopeLine: 47, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !25)
!952 = distinct !DILocation(line: 22, column: 18, scope: !953, inlinedAt: !954)
!953 = distinct !DISubprogram(name: "get", linkageName: "_RNvMNtNtNtNtCs1SSuMAdGM58_3std3sys4sync5mutex7pthreadNtB2_5Mutex3get", scope: !212, file: !29, line: 19, type: !24, scopeLine: 19, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !25)
!954 = distinct !DILocation(line: 36, column: 23, scope: !955, inlinedAt: !956)
!955 = distinct !DISubprogram(name: "lock", linkageName: "_RNvMNtNtNtNtCs1SSuMAdGM58_3std3sys4sync5mutex7pthreadNtB2_5Mutex4lock", scope: !212, file: !29, line: 33, type: !24, scopeLine: 33, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !25)
!956 = distinct !DILocation(line: 492, column: 24, scope: !957, inlinedAt: !959)
!957 = distinct !DISubprogram(name: "lock<runtime_lab::process::Capture>", linkageName: "_RNvMs5_NtNtNtCs1SSuMAdGM58_3std4sync6poison5mutexINtB5_5MutexNtNtCs5sHeypWcCKR_11runtime_lab7process7CaptureE4lockB11_", scope: !958, file: !164, line: 490, type: !24, scopeLine: 490, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !25)
!958 = !DINamespace(name: "Mutex", scope: !166)
!959 = distinct !DILocation(line: 35, column: 10, scope: !943)
!960 = !{!961}
!961 = distinct !{!961, !962, !"_RNvMs5_NtNtNtCs1SSuMAdGM58_3std4sync6poison5mutexINtB5_5MutexNtNtCs5sHeypWcCKR_11runtime_lab7process7CaptureE4lockB11_: %_0"}
!962 = distinct !{!962, !"_RNvMs5_NtNtNtCs1SSuMAdGM58_3std4sync6poison5mutexINtB5_5MutexNtNtCs5sHeypWcCKR_11runtime_lab7process7CaptureE4lockB11_"}
!963 = !DILocation(line: 38, column: 17, scope: !964, inlinedAt: !966)
!964 = !DILexicalBlockFile(scope: !965, file: !234, discriminator: 0)
!965 = distinct !DISubprogram(name: "runtime", linkageName: "_RNvNvMNtNtCsjIpoRzUjyHQ_4core3ptr9const_ptrPp7is_null7runtime", scope: !237, file: !236, line: 2623, type: !24, scopeLine: 2623, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !25)
!966 = distinct !DILocation(line: 2636, column: 9, scope: !967, inlinedAt: !970)
!967 = !DILexicalBlockFile(scope: !968, file: !236, discriminator: 0)
!968 = distinct !DILexicalBlock(scope: !969, file: !234, line: 25, column: 9)
!969 = distinct !DISubprogram(name: "is_null<std::sys::pal::unix::sync::mutex::Mutex>", linkageName: "_RNvMNtNtCsjIpoRzUjyHQ_4core3ptr9const_ptrPNtNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutex5Mutex7is_nullCs5sHeypWcCKR_11runtime_lab", scope: !238, file: !234, line: 22, type: !24, scopeLine: 22, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !25)
!970 = distinct !DILocation(line: 23, column: 27, scope: !971, inlinedAt: !972)
!971 = distinct !DISubprogram(name: "is_null<std::sys::pal::unix::sync::mutex::Mutex>", linkageName: "_RNvMNtNtCsjIpoRzUjyHQ_4core3ptr7mut_ptrONtNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutex5Mutex7is_nullCs5sHeypWcCKR_11runtime_lab", scope: !247, file: !246, line: 22, type: !24, scopeLine: 22, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !25)
!972 = distinct !DILocation(line: 265, column: 17, scope: !973, inlinedAt: !974)
!973 = distinct !DISubprogram(name: "as_ref<std::sys::pal::unix::sync::mutex::Mutex>", linkageName: "_RNvMNtNtCsjIpoRzUjyHQ_4core3ptr7mut_ptrONtNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutex5Mutex6as_refCs5sHeypWcCKR_11runtime_lab", scope: !247, file: !246, line: 262, type: !24, scopeLine: 262, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !25)
!974 = distinct !DILocation(line: 49, column: 28, scope: !975, inlinedAt: !952)
!975 = distinct !DILexicalBlock(scope: !951, file: !18, line: 48, column: 9)
!976 = !DILocation(line: 265, column: 12, scope: !973, inlinedAt: !974)
!977 = !DILocation(line: 51, column: 26, scope: !975, inlinedAt: !952)
!978 = !DILocation(line: 53, column: 5, scope: !951, inlinedAt: !952)
!979 = !DILocation(line: 0, scope: !975, inlinedAt: !952)
!980 = !DILocation(line: 36, column: 29, scope: !955, inlinedAt: !956)
!981 = !DILocation(line: 3994, column: 24, scope: !178, inlinedAt: !982)
!982 = distinct !DILocation(line: 2916, column: 26, scope: !983, inlinedAt: !984)
!983 = distinct !DISubprogram(name: "load", linkageName: "_RNvMs1g_NtNtCsjIpoRzUjyHQ_4core4sync6atomicINtB6_6AtomicjE4load", scope: !99, file: !93, line: 2914, type: !24, scopeLine: 2914, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !25)
!984 = distinct !DILocation(line: 465, column: 31, scope: !985, inlinedAt: !986)
!985 = distinct !DISubprogram(name: "count_is_zero", linkageName: "_RNvNtNtCs1SSuMAdGM58_3std9panicking11panic_count13count_is_zero", scope: !184, file: !183, line: 464, type: !24, scopeLine: 464, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !25)
!986 = distinct !DILocation(line: 606, column: 6, scope: !987, inlinedAt: !988)
!987 = distinct !DISubprogram(name: "panicking", linkageName: "_RNvNtCs1SSuMAdGM58_3std9panicking9panicking", scope: !185, file: !183, line: 605, type: !24, scopeLine: 605, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !25)
!988 = distinct !DILocation(line: 221, column: 5, scope: !989, inlinedAt: !990)
!989 = distinct !DISubprogram(name: "panicking", linkageName: "_RNvNtNtCs1SSuMAdGM58_3std6thread9functions9panicking", scope: !191, file: !190, line: 220, type: !24, scopeLine: 220, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !25)
!990 = distinct !DILocation(line: 118, column: 24, scope: !991, inlinedAt: !992)
!991 = distinct !DISubprogram(name: "guard", linkageName: "_RNvMNtNtCs1SSuMAdGM58_3std4sync6poisonNtB2_4Flag5guard", scope: !175, file: !174, line: 115, type: !24, scopeLine: 115, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !25)
!992 = distinct !DILocation(line: 720, column: 40, scope: !993, inlinedAt: !995)
!993 = distinct !DISubprogram(name: "new<runtime_lab::process::Capture>", linkageName: "_RNvMs9_NtNtNtCs1SSuMAdGM58_3std4sync6poison5mutexINtB5_10MutexGuardNtNtCs5sHeypWcCKR_11runtime_lab7process7CaptureE3newB17_", scope: !994, file: !164, line: 719, type: !24, scopeLine: 719, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !25)
!994 = !DINamespace(name: "MutexGuard", scope: !166)
!995 = distinct !DILocation(line: 493, column: 13, scope: !957, inlinedAt: !959)
!996 = !DILocation(line: 465, column: 12, scope: !985, inlinedAt: !986)
!997 = !DILocation(line: 477, column: 13, scope: !985, inlinedAt: !986)
!998 = !DILocation(line: 606, column: 5, scope: !987, inlinedAt: !988)
!999 = !DILocation(line: 720, column: 28, scope: !993, inlinedAt: !995)
!1000 = !DILocation(line: 3994, column: 24, scope: !1001, inlinedAt: !1002)
!1001 = distinct !DISubprogram(name: "atomic_load<u8>", linkageName: "_RINvNtNtCsjIpoRzUjyHQ_4core4sync6atomic11atomic_loadhECs5sHeypWcCKR_11runtime_lab", scope: !94, file: !93, line: 3990, type: !24, scopeLine: 3990, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !25)
!1002 = distinct !DILocation(line: 762, column: 18, scope: !1003, inlinedAt: !1004)
!1003 = distinct !DISubprogram(name: "load", linkageName: "_RNvMs2_NtNtCsjIpoRzUjyHQ_4core4sync6atomicINtB5_6AtomicbE4load", scope: !99, file: !93, line: 759, type: !24, scopeLine: 759, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !25)
!1004 = distinct !DILocation(line: 138, column: 21, scope: !1005, inlinedAt: !1006)
!1005 = distinct !DISubprogram(name: "get", linkageName: "_RNvMNtNtCs1SSuMAdGM58_3std4sync6poisonNtB2_4Flag3get", scope: !175, file: !174, line: 137, type: !24, scopeLine: 137, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !25)
!1006 = distinct !DILocation(line: 120, column: 17, scope: !1007, inlinedAt: !992)
!1007 = distinct !DILexicalBlock(scope: !991, file: !174, line: 116, column: 9)
!1008 = !DILocation(line: 762, column: 18, scope: !1003, inlinedAt: !1004)
!1009 = !DILocation(line: 120, scope: !1007, inlinedAt: !992)
!1010 = !DILocation(line: 965, column: 9, scope: !1011, inlinedAt: !1015)
!1011 = distinct !DISubprogram(name: "map_err<std::sync::poison::mutex::MutexGuard<runtime_lab::process::Capture>, std::sync::poison::PoisonError<std::sync::poison::mutex::MutexGuard<runtime_lab::process::Capture>>, core::io::error::Error, runtime_lab::process::state_lock::{closure_env#0}>", linkageName: "_RINvMNtCsjIpoRzUjyHQ_4core6resultINtB3_6ResultINtNtNtNtCs1SSuMAdGM58_3std4sync6poison5mutex10MutexGuardNtNtCs5sHeypWcCKR_11runtime_lab7process7CaptureEINtBN_11PoisonErrorBI_EE7map_errNtNtNtB5_2io5error5ErrorNCNvB1F_10state_lock0EB1H_", scope: !1013, file: !1012, line: 961, type: !24, scopeLine: 961, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !25)
!1012 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/result.rs", directory: "", checksumkind: CSK_MD5, checksum: "d01c390c1644b468299b560eda4cb25a")
!1013 = !DINamespace(name: "Result", scope: !1014)
!1014 = !DINamespace(name: "result", scope: !80)
!1015 = !DILocation(line: 36, column: 10, scope: !943)
!1016 = !DILocation(line: 79, column: 9, scope: !1017, inlinedAt: !1022)
!1017 = distinct !DISubprogram(name: "other<&str>", linkageName: "_RINvMNtNtCs6zY7rJBZy9D_5alloc2io5errorNtNtNtCsjIpoRzUjyHQ_4core2io5error5Error5otherReECs5sHeypWcCKR_11runtime_lab", scope: !1019, file: !1018, line: 75, type: !24, scopeLine: 75, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !25)
!1018 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/alloc/src/io/error.rs", directory: "", checksumkind: CSK_MD5, checksum: "3740f3ea3b24719182b5b1f7e4b8ad78")
!1019 = !DINamespace(name: "Error", scope: !1020)
!1020 = !DINamespace(name: "error", scope: !1021)
!1021 = !DINamespace(name: "io", scope: !80)
!1022 = distinct !DILocation(line: 36, column: 22, scope: !1023, inlinedAt: !1025)
!1023 = distinct !DISubprogram(name: "{closure#0}", linkageName: "_RNCNvNtCs5sHeypWcCKR_11runtime_lab7process10state_lock0B5_", scope: !1024, file: !944, line: 36, type: !24, scopeLine: 36, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !25)
!1024 = !DINamespace(name: "state_lock", scope: !945)
!1025 = distinct !DILocation(line: 967, column: 27, scope: !1026, inlinedAt: !1015)
!1026 = distinct !DILexicalBlock(scope: !1011, file: !1012, line: 967, column: 13)
!1027 = !DILocation(line: 36, column: 63, scope: !1023, inlinedAt: !1025)
!1028 = !DILocation(line: 126, column: 13, scope: !173, inlinedAt: !1029)
!1029 = distinct !DILocation(line: 745, column: 30, scope: !163, inlinedAt: !1030)
!1030 = distinct !DILocation(line: 847, column: 1, scope: !170, inlinedAt: !1031)
!1031 = distinct !DILocation(line: 847, column: 1, scope: !160, inlinedAt: !1032)
!1032 = distinct !DILocation(line: 36, column: 63, scope: !1023, inlinedAt: !1025)
!1033 = !DILocation(line: 3994, column: 24, scope: !178, inlinedAt: !1034)
!1034 = distinct !DILocation(line: 2916, column: 26, scope: !180, inlinedAt: !1035)
!1035 = distinct !DILocation(line: 465, column: 31, scope: !182, inlinedAt: !1036)
!1036 = distinct !DILocation(line: 606, column: 6, scope: !187, inlinedAt: !1037)
!1037 = distinct !DILocation(line: 221, column: 5, scope: !189, inlinedAt: !1038)
!1038 = distinct !DILocation(line: 126, column: 32, scope: !173, inlinedAt: !1029)
!1039 = !DILocation(line: 465, column: 12, scope: !182, inlinedAt: !1036)
!1040 = !DILocation(line: 477, column: 13, scope: !182, inlinedAt: !1036)
!1041 = !DILocation(line: 126, column: 32, scope: !173, inlinedAt: !1029)
!1042 = !DILocation(line: 3978, column: 24, scope: !199, inlinedAt: !1043)
!1043 = distinct !DILocation(line: 793, column: 13, scope: !201, inlinedAt: !1044)
!1044 = distinct !DILocation(line: 127, column: 25, scope: !173, inlinedAt: !1029)
!1045 = !DILocation(line: 126, column: 9, scope: !173, inlinedAt: !1029)
!1046 = !DILocation(line: 36, column: 18, scope: !1023, inlinedAt: !1025)
!1047 = !DILocation(line: 3994, column: 24, scope: !205, inlinedAt: !1048)
!1048 = distinct !DILocation(line: 1765, column: 18, scope: !207, inlinedAt: !1049)
!1049 = distinct !DILocation(line: 43, column: 48, scope: !209, inlinedAt: !1050)
!1050 = distinct !DILocation(line: 45, column: 27, scope: !211, inlinedAt: !1051)
!1051 = distinct !DILocation(line: 746, column: 29, scope: !163, inlinedAt: !1030)
!1052 = !DILocation(line: 45, column: 43, scope: !211, inlinedAt: !1051)
!1053 = !DILocation(line: 967, column: 32, scope: !1011, inlinedAt: !1015)
!1054 = !DILocation(line: 0, scope: !1011, inlinedAt: !1015)
!1055 = !DILocation(line: 37, column: 2, scope: !943)
!1056 = distinct !DISubprogram(name: "fmt<core::option::Option<core::ptr::non_null::NonNull<tokio::runtime::task::core::Header>>>", linkageName: "_RNvXs1g_NtCsjIpoRzUjyHQ_4core3fmtRINtNtB8_6option6OptionINtNtNtB8_3ptr8non_null7NonNullNtNtNtNtCs3EIJ1qnJmKW_5tokio7runtime4task4core6HeaderEENtB6_5Debug3fmtCs5sHeypWcCKR_11runtime_lab", scope: !1058, file: !1057, line: 2872, type: !24, scopeLine: 2872, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !25)
!1057 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/fmt/mod.rs", directory: "", checksumkind: CSK_MD5, checksum: "363229db3a4a2c778c00c76c7b1385ee")
!1058 = !DINamespace(name: "{impl#80}", scope: !1059)
!1059 = !DINamespace(name: "fmt", scope: !80)
!1060 = !{i64 -3112109100154990336}
!1061 = !DILocation(line: 2872, column: 71, scope: !1056)
!1062 = !{i64 8}
!1063 = !{!1064}
!1064 = distinct !{!1064, !1065, !"_RNvXsR_NtCsjIpoRzUjyHQ_4core6optionINtB5_6OptionINtNtNtB7_3ptr8non_null7NonNullNtNtNtNtCs3EIJ1qnJmKW_5tokio7runtime4task4core6HeaderEENtNtB7_3fmt5Debug3fmtCs5sHeypWcCKR_11runtime_lab: %self"}
!1065 = distinct !{!1065, !"_RNvXsR_NtCsjIpoRzUjyHQ_4core6optionINtB5_6OptionINtNtNtB7_3ptr8non_null7NonNullNtNtNtNtCs3EIJ1qnJmKW_5tokio7runtime4task4core6HeaderEENtNtB7_3fmt5Debug3fmtCs5sHeypWcCKR_11runtime_lab"}
!1066 = !DILocation(line: 2872, column: 62, scope: !1056)
!1067 = !DILocation(line: 592, column: 16, scope: !1068, inlinedAt: !1072)
!1068 = distinct !DISubprogram(name: "fmt<core::ptr::non_null::NonNull<tokio::runtime::task::core::Header>>", linkageName: "_RNvXsR_NtCsjIpoRzUjyHQ_4core6optionINtB5_6OptionINtNtNtB7_3ptr8non_null7NonNullNtNtNtNtCs3EIJ1qnJmKW_5tokio7runtime4task4core6HeaderEENtNtB7_3fmt5Debug3fmtCs5sHeypWcCKR_11runtime_lab", scope: !1070, file: !1069, line: 592, type: !24, scopeLine: 592, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !25)
!1069 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/option.rs", directory: "", checksumkind: CSK_MD5, checksum: "6b6523786d7acedb57d33f9868027e9f")
!1070 = !DINamespace(name: "{impl#55}", scope: !1071)
!1071 = !DINamespace(name: "option", scope: !80)
!1072 = distinct !DILocation(line: 2872, column: 62, scope: !1056)
!1073 = !{!1074}
!1074 = distinct !{!1074, !1065, !"_RNvXsR_NtCsjIpoRzUjyHQ_4core6optionINtB5_6OptionINtNtNtB7_3ptr8non_null7NonNullNtNtNtNtCs3EIJ1qnJmKW_5tokio7runtime4task4core6HeaderEENtNtB7_3fmt5Debug3fmtCs5sHeypWcCKR_11runtime_lab: %f"}
!1075 = !DILocation(line: 606, column: 56, scope: !1068, inlinedAt: !1072)
!1076 = !{!1064, !1074}
!1077 = !DILocation(line: 592, column: 16, scope: !1078, inlinedAt: !1072)
!1078 = distinct !DILexicalBlock(scope: !1068, file: !1069, line: 592, column: 16)
!1079 = !DILocation(line: 592, column: 20, scope: !1068, inlinedAt: !1072)
!1080 = !DILocation(line: 2872, column: 84, scope: !1056)
!1081 = distinct !DISubprogram(name: "fmt<core::ptr::non_null::NonNull<tokio::runtime::task::core::Header>>", linkageName: "_RNvXs1g_NtCsjIpoRzUjyHQ_4core3fmtRINtNtNtB8_3ptr8non_null7NonNullNtNtNtNtCs3EIJ1qnJmKW_5tokio7runtime4task4core6HeaderENtB6_5Debug3fmtCs5sHeypWcCKR_11runtime_lab", scope: !1058, file: !1057, line: 2872, type: !24, scopeLine: 2872, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !25)
!1082 = !{i64 -3621280192629951113}
!1083 = !DILocation(line: 2872, column: 71, scope: !1081)
!1084 = !DILocation(line: 2872, column: 62, scope: !1081)
!1085 = !DILocation(line: 188, column: 9, scope: !1086, inlinedAt: !1087)
!1086 = distinct !DISubprogram(name: "expose_provenance<tokio::runtime::task::core::Header>", linkageName: "_RNvMNtNtCsjIpoRzUjyHQ_4core3ptr9const_ptrPNtNtNtNtCs3EIJ1qnJmKW_5tokio7runtime4task4core6Header17expose_provenanceCs5sHeypWcCKR_11runtime_lab", scope: !238, file: !234, line: 187, type: !24, scopeLine: 187, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !25)
!1087 = distinct !DILocation(line: 3002, column: 28, scope: !1088, inlinedAt: !1091)
!1088 = distinct !DILexicalBlock(scope: !1089, file: !1057, line: 3001, column: 9)
!1089 = distinct !DISubprogram(name: "fmt<tokio::runtime::task::core::Header>", linkageName: "_RNvXsl_NtCsjIpoRzUjyHQ_4core3fmtPNtNtNtNtCs3EIJ1qnJmKW_5tokio7runtime4task4core6HeaderNtB5_7Pointer3fmtCs5sHeypWcCKR_11runtime_lab", scope: !1090, file: !1057, line: 2998, type: !96, scopeLine: 2998, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !25)
!1090 = !DINamespace(name: "{impl#23}", scope: !1059)
!1091 = distinct !DILocation(line: 3051, column: 9, scope: !1092, inlinedAt: !1094)
!1092 = distinct !DISubprogram(name: "fmt<tokio::runtime::task::core::Header>", linkageName: "_RNvXsm_NtCsjIpoRzUjyHQ_4core3fmtONtNtNtNtCs3EIJ1qnJmKW_5tokio7runtime4task4core6HeaderNtB5_7Pointer3fmtCs5sHeypWcCKR_11runtime_lab", scope: !1093, file: !1057, line: 3050, type: !24, scopeLine: 3050, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !25)
!1093 = !DINamespace(name: "{impl#24}", scope: !1059)
!1094 = distinct !DILocation(line: 1644, column: 9, scope: !1095, inlinedAt: !1097)
!1095 = distinct !DISubprogram(name: "fmt<tokio::runtime::task::core::Header>", linkageName: "_RNvXsa_NtNtCsjIpoRzUjyHQ_4core3ptr8non_nullINtB5_7NonNullNtNtNtNtCs3EIJ1qnJmKW_5tokio7runtime4task4core6HeaderENtNtB9_3fmt5Debug3fmtCs5sHeypWcCKR_11runtime_lab", scope: !1096, file: !310, line: 1643, type: !96, scopeLine: 1643, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !25)
!1096 = !DINamespace(name: "{impl#12}", scope: !312)
!1097 = distinct !DILocation(line: 2872, column: 62, scope: !1081)
!1098 = !DILocation(line: 3004, column: 13, scope: !1099, inlinedAt: !1091)
!1099 = distinct !DILexicalBlock(scope: !1088, file: !1057, line: 3002, column: 9)
!1100 = !DILocation(line: 2872, column: 84, scope: !1081)
!1101 = distinct !DISubprogram(name: "drop", linkageName: "_RNvXs_NtCs5sHeypWcCKR_11runtime_lab7processNtB4_10ReaderTaskNtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4drop", scope: !1102, file: !944, line: 66, type: !24, scopeLine: 66, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !25)
!1102 = !DINamespace(name: "{impl#1}", scope: !945)
!1103 = !{i64 7165574234433847119}
!1104 = !DILocation(line: 228, column: 18, scope: !1105, inlinedAt: !1110)
!1105 = distinct !DISubprogram(name: "abort<core::result::Result<(), core::io::error::Error>>", linkageName: "_RNvMs2_NtNtNtCs3EIJ1qnJmKW_5tokio7runtime4task4joinINtB5_10JoinHandleINtNtCsjIpoRzUjyHQ_4core6result6ResultuNtNtNtB1a_2io5error5ErrorEE5abortCs5sHeypWcCKR_11runtime_lab", scope: !1107, file: !1106, line: 227, type: !24, scopeLine: 227, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !25)
!1106 = !DIFile(filename: "src/runtime/task/join.rs", directory: "/Users/juanwang/.cargo/registry/src/mirrors.bfsu.edu.cn-eb00624c53167367/tokio-1.54.0", checksumkind: CSK_MD5, checksum: "1f6622edd24f07780d916100856a2ffd")
!1107 = !DINamespace(name: "JoinHandle", scope: !1108)
!1108 = !DINamespace(name: "join", scope: !1109)
!1109 = !DINamespace(name: "task", scope: !686)
!1110 = !DILocation(line: 67, column: 21, scope: !1101)
!1111 = !DILocation(line: 68, column: 6, scope: !1101)
