; ModuleID = 'runtime_lab.cc52c9ff3ada741f-cgu.0'
source_filename = "runtime_lab.cc52c9ff3ada741f-cgu.0"
target datalayout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx11.0.0"

%"core::sync::atomic::Atomic<usize>" = type { %"core::cell::UnsafeCell<core::sync::atomic::private::Align8<usize>>" }
%"core::cell::UnsafeCell<core::sync::atomic::private::Align8<usize>>" = type { %"core::sync::atomic::private::Align8<usize>" }
%"core::sync::atomic::private::Align8<usize>" = type { i64 }
%"core::sync::atomic::Atomic<*mut core::io::error::OsFunctions>" = type { %"core::cell::UnsafeCell<core::sync::atomic::private::Align8<*mut core::io::error::OsFunctions>>" }
%"core::cell::UnsafeCell<core::sync::atomic::private::Align8<*mut core::io::error::OsFunctions>>" = type { %"core::sync::atomic::private::Align8<*mut core::io::error::OsFunctions>" }
%"core::sync::atomic::private::Align8<*mut core::io::error::OsFunctions>" = type { ptr }

@vtable.0 = private unnamed_addr constant <{ [24 x i8], ptr, ptr }> <{ [24 x i8] c"\00\00\00\00\00\00\00\00\08\00\00\00\00\00\00\00\08\00\00\00\00\00\00\00", ptr @_RNSNvYNCINvMs0_NtNtCs1SSuMAdGM58_3std4sync4onceNtBd_4Once15call_once_forceNCINvMNtBf_9once_lockINtB1g_8OnceLockINtNtCsjIpoRzUjyHQ_4core6option6OptionFUKCOllElEE10initializeNCINvB1f_11get_or_initNCNvNtNtCshxBJAVx362N_11runtime_lab7process5macos12pipe_cloexec0E0zE0E0INtNtNtB1Q_3ops8function6FnOnceTRNtBd_9OnceStateEE9call_once6vtableB3e_, ptr @_RNCINvMs0_NtNtCs1SSuMAdGM58_3std4sync4onceNtB8_4Once15call_once_forceNCINvMNtBa_9once_lockINtB1b_8OnceLockINtNtCsjIpoRzUjyHQ_4core6option6OptionFUKCOllElEE10initializeNCINvB1a_11get_or_initNCNvNtNtCshxBJAVx362N_11runtime_lab7process5macos12pipe_cloexec0E0zE0E0B39_ }>, align 8, !guid !0
@alloc_42803b9b714e3e00e9cb378c7a639ffd = private unnamed_addr constant [113 x i8] c"/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/std/src/sync/once.rs\00", align 1, !guid !1
@alloc_14b41ca4a8bee6f2e6e20a17309d9f1e = private unnamed_addr constant <{ ptr, [16 x i8] }> <{ ptr @alloc_42803b9b714e3e00e9cb378c7a639ffd, [16 x i8] c"p\00\00\00\00\00\00\00\E2\00\00\00\14\00\00\00" }>, align 8, !guid !2
@vtable.1 = private unnamed_addr constant <{ [24 x i8], ptr }> <{ [24 x i8] c"\00\00\00\00\00\00\00\00\08\00\00\00\00\00\00\00\08\00\00\00\00\00\00\00", ptr @_RNvXs1g_NtCsjIpoRzUjyHQ_4core3fmtRINtNtB8_6option6OptionINtNtNtB8_3ptr8non_null7NonNullNtNtNtNtCs3EIJ1qnJmKW_5tokio7runtime4task4core6HeaderEENtB6_5Debug3fmtCshxBJAVx362N_11runtime_lab }>, align 8, !guid !3
@alloc_696290a743386ff4d3c84dceb79925aa = private unnamed_addr constant <{ ptr, [16 x i8] }> <{ ptr @alloc_42803b9b714e3e00e9cb378c7a639ffd, [16 x i8] c"p\00\00\00\00\00\00\00\E2\00\00\001\00\00\00" }>, align 8, !guid !4
@anon.0fe3dc0744e906bfec0abb2f1239609f.0 = private unnamed_addr constant [64 x i8] c"\A7\AB\AA2\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00\00", align 8, !guid !5
@alloc_8821e7adf2aaedbbe7385d67b31be780 = private unnamed_addr constant [22 x i8] c"capture mutex poisoned", align 1, !guid !6
@alloc_99fa3dadd3dc410db62b2449899e8038 = private unnamed_addr constant [6 x i8] c"pipe2\00", align 1, !guid !7
@alloc_466e6e10d4d5a95679ab35d1156aa54e = private unnamed_addr constant [11 x i8] c"src/lib.rs\00", align 1, !guid !8
@alloc_76a4682140362797ca7b20487d943f78 = private unnamed_addr constant <{ ptr, [16 x i8] }> <{ ptr @alloc_466e6e10d4d5a95679ab35d1156aa54e, [16 x i8] c"\0A\00\00\00\00\00\00\00\0E\00\00\00\0A\00\00\00" }>, align 8, !guid !9
@alloc_80e4d5a6503ea68c559c0291c1b805b6 = private unnamed_addr constant [28 x i8] c"invalid version/flags/length", align 1, !guid !10
@_RNvNtNtCs1SSuMAdGM58_3std9panicking11panic_count18GLOBAL_PANIC_COUNT = external local_unnamed_addr global %"core::sync::atomic::Atomic<usize>"
@_RNvNtNtNtCsjIpoRzUjyHQ_4core2io5error12os_functions12OS_FUNCTIONS = external local_unnamed_addr global %"core::sync::atomic::Atomic<*mut core::io::error::OsFunctions>"
@alloc_9fa17d48c70567c41855e0f822a97df6 = private unnamed_addr constant [82 x i8] c"atomic capture requires macOS pipe2 (macOS 27+); refusing racy pipe/fcntl fallback", align 1, !guid !11
@alloc_1a77a6ec3c99855082ffa167c1e43f36 = private unnamed_addr constant [8 x i8] c"fd != -1", align 1, !guid !12
@alloc_3490d264c0d756140d316f1476e604c9 = private unnamed_addr constant [21 x i8] c"src/process_macos.rs\00", align 1, !guid !13
@alloc_d4e874c5950a4dd077eda449f242ad2c = private unnamed_addr constant <{ ptr, [16 x i8] }> <{ ptr @alloc_3490d264c0d756140d316f1476e604c9, [16 x i8] c"\14\00\00\00\00\00\00\00+\00\00\00\12\00\00\00" }>, align 8, !guid !14
@alloc_444886716b65ec0b4507f0f9552978e5 = private unnamed_addr constant <{ ptr, [16 x i8] }> <{ ptr @alloc_3490d264c0d756140d316f1476e604c9, [16 x i8] c"\14\00\00\00\00\00\00\00+\00\00\000\00\00\00" }>, align 8, !guid !15
@alloc_b51bd8077bfd6b0e033a5c3453ced731 = private unnamed_addr constant <{ ptr, ptr, ptr }> <{ ptr @_RNvYNCNvNvMNtNtCs1SSuMAdGM58_3std2io5errorNtNtNtCsjIpoRzUjyHQ_4core2io5error5Error17from_raw_os_error9FUNCTIONS0INtNtNtBK_3ops8function6FnOnceTlQNtNtBK_3fmt9FormatterEE9call_onceCshxBJAVx362N_11runtime_lab, ptr @_RNvNtNtNtNtCs1SSuMAdGM58_3std3sys2io5error4unix17decode_error_kind, ptr @_RNvNtNtNtNtCs1SSuMAdGM58_3std3sys2io5error4unix14is_interrupted }>, align 8, !guid !16
@_RNvNvNtNtCshxBJAVx362N_11runtime_lab7process5macos12pipe_cloexec5PIPE2 = internal global <{ [8 x i8], [8 x i8] }> <{ [8 x i8] c"\03\00\00\00\00\00\00\00", [8 x i8] undef }>, align 8, !guid !17
@alloc_6d2adbdab4a04e94478bf10d501f3011 = private unnamed_addr constant [19 x i8] c"inner has gone away", align 1, !guid !18
@alloc_514864c1c2b6ce9d83b946af71d6cbb7 = private unnamed_addr constant [111 x i8] c"/Users/juanwang/.cargo/registry/src/mirrors.bfsu.edu.cn-eb00624c53167367/tokio-1.54.0/src/process/unix/reap.rs\00", align 1, !guid !19
@alloc_cfb3a9de3693f4818ff78ea1dbe39949 = private unnamed_addr constant <{ ptr, [16 x i8] }> <{ ptr @alloc_514864c1c2b6ce9d83b946af71d6cbb7, [16 x i8] c"n\00\00\00\00\00\00\008\00\00\00\1D\00\00\00" }>, align 8, !guid !20
@alloc_e136e920a9e7286d7bfd1eaa7a373778 = private unnamed_addr constant <{ ptr, [16 x i8] }> <{ ptr @alloc_514864c1c2b6ce9d83b946af71d6cbb7, [16 x i8] c"n\00\00\00\00\00\00\00\7F\00\00\00(\00\00\00" }>, align 8, !guid !21
@alloc_37d2e53432a03a1f90b3e7253015eaf9 = private unnamed_addr constant [4 x i8] c"None", align 1, !guid !22
@vtable.3 = private unnamed_addr constant <{ [24 x i8], ptr }> <{ [24 x i8] c"\00\00\00\00\00\00\00\00\08\00\00\00\00\00\00\00\08\00\00\00\00\00\00\00", ptr @_RNvXs1g_NtCsjIpoRzUjyHQ_4core3fmtRINtNtNtB8_3ptr8non_null7NonNullNtNtNtNtCs3EIJ1qnJmKW_5tokio7runtime4task4core6HeaderENtB6_5Debug3fmtCshxBJAVx362N_11runtime_lab }>, align 8, !guid !23
@alloc_9535bf4c204f3eb9b19ec2c83e446e52 = private unnamed_addr constant [4 x i8] c"Some", align 1, !guid !24
@switch.table._RNvNtNtNtNtCs1SSuMAdGM58_3std3sys2io5error4unix17decode_error_kind = private unnamed_addr constant [102 x i8] c"\01\00+#)+\22+++\1E&\01++\1C\0C\1F+\0E\0F\14((+\1D\1B\18\19\11 \0B++\0D'+++++++++++\08\09\0A\05+\06\03++\07++\16\02\12!+\04\10++\1A\13+++++++$+++++++++++++++++++++++$", align 1, !guid !25

; <std::sync::once_lock::OnceLock<core::option::Option<unsafe extern "C" fn(*mut i32, i32) -> i32>>>::initialize::<<std::sync::once_lock::OnceLock<core::option::Option<unsafe extern "C" fn(*mut i32, i32) -> i32>>>::get_or_init<runtime_lab::process::macos::pipe_cloexec::{closure#0}>::{closure#0}, !>
; Function Attrs: cold minsize optsize uwtable
define internal fastcc void @_RINvMNtNtCs1SSuMAdGM58_3std4sync9once_lockINtB3_8OnceLockINtNtCsjIpoRzUjyHQ_4core6option6OptionFUKCOllElEE10initializeNCINvB2_11get_or_initNCNvNtNtCshxBJAVx362N_11runtime_lab7process5macos12pipe_cloexec0E0zEB2l_() unnamed_addr #0 personality ptr @rust_eh_personality !dbg !34 !guid !42 {
start:
  %res = alloca [0 x i8], align 1
  %_11.i = alloca [8 x i8], align 8
  %f.i = alloca [16 x i8], align 8
  %0 = load atomic ptr, ptr @_RNvNvNtNtCshxBJAVx362N_11runtime_lab7process5macos12pipe_cloexec5PIPE2 acquire, align 8, !dbg !43, !noalias !69
  %_3.i = icmp eq ptr %0, null, !dbg !72
  br i1 %_3.i, label %_RINvMs0_NtNtCs1SSuMAdGM58_3std4sync4onceNtB6_4Once15call_once_forceNCINvMNtB8_9once_lockINtB19_8OnceLockINtNtCsjIpoRzUjyHQ_4core6option6OptionFUKCOllElEE10initializeNCINvB18_11get_or_initNCNvNtNtCshxBJAVx362N_11runtime_lab7process5macos12pipe_cloexec0E0zE0EB37_.exit, label %bb2.i, !dbg !73, !prof !74

bb2.i:                                            ; preds = %start
  call void @llvm.lifetime.start.p0(ptr nonnull %f.i), !dbg !75, !noalias !69
  store ptr getelementptr inbounds nuw (i8, ptr @_RNvNvNtNtCshxBJAVx362N_11runtime_lab7process5macos12pipe_cloexec5PIPE2, i64 8), ptr %f.i, align 8, !dbg !76, !noalias !69
  %1 = getelementptr inbounds nuw i8, ptr %f.i, i64 8, !dbg !76
  store ptr %res, ptr %1, align 8, !dbg !76, !noalias !69
  call void @llvm.lifetime.start.p0(ptr nonnull %_11.i), !dbg !77, !noalias !69
  store ptr %f.i, ptr %_11.i, align 8, !dbg !77, !noalias !69
; call <std::sys::sync::once::queue::Once>::call
  call void @_RNvMNtNtNtNtCs1SSuMAdGM58_3std3sys4sync4once5queueNtB2_4Once4call(ptr noundef nonnull align 8 @_RNvNvNtNtCshxBJAVx362N_11runtime_lab7process5macos12pipe_cloexec5PIPE2, i1 noundef zeroext true, ptr noundef nonnull %_11.i, ptr noalias nofree noundef readonly align 8 captures(address, read_provenance) dereferenceable(40) @vtable.0, ptr noalias nofree noundef readonly align 8 captures(address, read_provenance) dereferenceable(24) @alloc_14b41ca4a8bee6f2e6e20a17309d9f1e), !dbg !79
  call void @llvm.lifetime.end.p0(ptr nonnull %_11.i), !dbg !80, !noalias !69
  call void @llvm.lifetime.end.p0(ptr nonnull %f.i), !dbg !81, !noalias !69
  br label %_RINvMs0_NtNtCs1SSuMAdGM58_3std4sync4onceNtB6_4Once15call_once_forceNCINvMNtB8_9once_lockINtB19_8OnceLockINtNtCsjIpoRzUjyHQ_4core6option6OptionFUKCOllElEE10initializeNCINvB18_11get_or_initNCNvNtNtCshxBJAVx362N_11runtime_lab7process5macos12pipe_cloexec0E0zE0EB37_.exit, !dbg !81

_RINvMs0_NtNtCs1SSuMAdGM58_3std4sync4onceNtB6_4Once15call_once_forceNCINvMNtB8_9once_lockINtB19_8OnceLockINtNtCsjIpoRzUjyHQ_4core6option6OptionFUKCOllElEE10initializeNCINvB18_11get_or_initNCNvNtNtCshxBJAVx362N_11runtime_lab7process5macos12pipe_cloexec0E0zE0EB37_.exit: ; preds = %start, %bb2.i
  ret void, !dbg !82
}

; <std::sys::sync::once_box::OnceBox<std::sys::pal::unix::sync::mutex::Mutex>>::initialize::<<std::sys::sync::mutex::pthread::Mutex>::get::{closure#0}>
; Function Attrs: cold uwtable
define internal fastcc noundef nonnull align 8 ptr @_RINvMNtNtNtCs1SSuMAdGM58_3std3sys4sync8once_boxINtB3_7OnceBoxNtNtNtNtNtB7_3pal4unix4sync5mutex5MutexE10initializeNCNvMNtNtB5_5mutex7pthreadNtB1S_5Mutex3get0ECshxBJAVx362N_11runtime_lab(ptr nofree noundef nonnull align 8 captures(none) %self) unnamed_addr #1 personality ptr @rust_eh_personality !dbg !83 !guid !87 {
start:
  %x.i = alloca [64 x i8], align 8
  call void @llvm.lifetime.start.p0(ptr nonnull %x.i), !dbg !88
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 8 dereferenceable(64) %x.i, ptr noundef nonnull align 8 dereferenceable(64) @anon.0fe3dc0744e906bfec0abb2f1239609f.0, i64 64, i1 false), !dbg !96
; call __rustc::__rust_no_alloc_shim_is_unstable_v2
  tail call void @_RNvCsdtSMxSA38aw_7___rustc35___rust_no_alloc_shim_is_unstable_v2() #20, !dbg !105, !noalias !129
; call __rustc::__rust_alloc
  %0 = tail call noundef align 8 dereferenceable_or_null(64) ptr @_RNvCsdtSMxSA38aw_7___rustc12___rust_alloc(i64 noundef 64, i64 noundef 8) #20, !dbg !132, !noalias !129
  %1 = icmp eq ptr %0, null, !dbg !133
  br i1 %1, label %bb2.i1.i, label %_RNvMNtCs6zY7rJBZy9D_5alloc5boxedINtB2_3BoxNtNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutex5MutexE3newCshxBJAVx362N_11runtime_lab.exit.i, !dbg !134, !prof !135

bb2.i1.i:                                         ; preds = %start
; invoke alloc::alloc::handle_alloc_error
  invoke void @_RNvNtCs6zY7rJBZy9D_5alloc5alloc18handle_alloc_error(i64 noundef 8, i64 noundef 64) #21
          to label %.noexc.i unwind label %cleanup.i.i, !dbg !136

.noexc.i:                                         ; preds = %bb2.i1.i
  unreachable, !dbg !136

cleanup.i.i:                                      ; preds = %bb2.i1.i
  %2 = landingpad { ptr, i32 }
          cleanup
; invoke <std::sys::pal::unix::sync::mutex::Mutex as core::ops::drop::Drop>::drop
  invoke void @_RNvXs2_NtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutexNtB5_5MutexNtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4drop(ptr noundef nonnull align 8 dereferenceable(64) %x.i)
          to label %common.resume unwind label %terminate.i.i, !dbg !137

terminate.i.i:                                    ; preds = %cleanup.i.i
  %3 = landingpad { ptr, i32 }
          filter [0 x ptr] zeroinitializer
; call core::panicking::panic_in_cleanup
  call void @_RNvNtCsjIpoRzUjyHQ_4core9panicking16panic_in_cleanup() #22, !dbg !142
  unreachable, !dbg !142

common.resume:                                    ; preds = %cleanup.i.i, %cleanup.i, %bb2.i
  %common.resume.op = phi { ptr, i32 } [ %9, %bb2.i ], [ %2, %cleanup.i.i ], [ %4, %cleanup.i ]
  resume { ptr, i32 } %common.resume.op, !dbg !143

_RNvMNtCs6zY7rJBZy9D_5alloc5boxedINtB2_3BoxNtNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutex5MutexE3newCshxBJAVx362N_11runtime_lab.exit.i: ; preds = %start
  tail call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 8 dereferenceable(64) %0, ptr noundef nonnull align 8 dereferenceable(64) @anon.0fe3dc0744e906bfec0abb2f1239609f.0, i64 64, i1 false), !dbg !144
  call void @llvm.lifetime.end.p0(ptr nonnull %x.i), !dbg !146
; invoke <std::sys::pal::unix::sync::mutex::Mutex>::init
  invoke void @_RNvMNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutexNtB2_5Mutex4init(ptr noundef nonnull align 8 %0)
          to label %_RNCNvMNtNtNtNtCs1SSuMAdGM58_3std3sys4sync5mutex7pthreadNtB4_5Mutex3get0CshxBJAVx362N_11runtime_lab.exit unwind label %cleanup.i, !dbg !147

cleanup.i:                                        ; preds = %_RNvMNtCs6zY7rJBZy9D_5alloc5boxedINtB2_3BoxNtNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutex5MutexE3newCshxBJAVx362N_11runtime_lab.exit.i
  %4 = landingpad { ptr, i32 }
          cleanup
; invoke core::ptr::drop_glue::<core::pin::Pin<alloc::boxed::Box<std::sys::pal::unix::sync::mutex::Mutex>>>
  invoke fastcc void @_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtB4_3pin3PinINtNtCs6zY7rJBZy9D_5alloc5boxed3BoxNtNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutex5MutexEEECshxBJAVx362N_11runtime_lab(ptr %0) #23
          to label %common.resume unwind label %terminate.i, !dbg !149

terminate.i:                                      ; preds = %cleanup.i
  %5 = landingpad { ptr, i32 }
          filter [0 x ptr] zeroinitializer
; call core::panicking::panic_in_cleanup
  tail call void @_RNvNtCsjIpoRzUjyHQ_4core9panicking16panic_in_cleanup() #22, !dbg !150
  unreachable, !dbg !150

_RNCNvMNtNtNtNtCs1SSuMAdGM58_3std3sys4sync5mutex7pthreadNtB4_5Mutex3get0CshxBJAVx362N_11runtime_lab.exit: ; preds = %_RNvMNtCs6zY7rJBZy9D_5alloc5boxedINtB2_3BoxNtNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutex5MutexE3newCshxBJAVx362N_11runtime_lab.exit.i
  %6 = cmpxchg ptr %self, ptr null, ptr %0 release acquire, align 8, !dbg !151
  %7 = extractvalue { ptr, i1 } %6, 1, !dbg !151
  %8 = extractvalue { ptr, i1 } %6, 0, !dbg !151
  br i1 %7, label %bb5, label %bb3, !dbg !157

bb3:                                              ; preds = %_RNCNvMNtNtNtNtCs1SSuMAdGM58_3std3sys4sync5mutex7pthreadNtB4_5Mutex3get0CshxBJAVx362N_11runtime_lab.exit
; invoke <std::sys::pal::unix::sync::mutex::Mutex as core::ops::drop::Drop>::drop
  invoke void @_RNvXs2_NtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutexNtB5_5MutexNtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4drop(ptr noundef nonnull align 8 %0)
          to label %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc5boxed3BoxNtNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutex5MutexEECshxBJAVx362N_11runtime_lab.exit unwind label %bb2.i, !dbg !158

bb2.i:                                            ; preds = %bb3
  %9 = landingpad { ptr, i32 }
          cleanup
; call __rustc::__rust_dealloc
  tail call void @_RNvCsdtSMxSA38aw_7___rustc14___rust_dealloc(ptr noundef nonnull %0, i64 noundef 64, i64 noundef 8) #20, !dbg !167
  br label %common.resume, !dbg !181

_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc5boxed3BoxNtNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutex5MutexEECshxBJAVx362N_11runtime_lab.exit: ; preds = %bb3
; call __rustc::__rust_dealloc
  tail call void @_RNvCsdtSMxSA38aw_7___rustc14___rust_dealloc(ptr noundef nonnull %0, i64 noundef 64, i64 noundef 8) #20, !dbg !182
  br label %bb5, !dbg !188

bb5:                                              ; preds = %_RNCNvMNtNtNtNtCs1SSuMAdGM58_3std3sys4sync5mutex7pthreadNtB4_5Mutex3get0CshxBJAVx362N_11runtime_lab.exit, %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc5boxed3BoxNtNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutex5MutexEECshxBJAVx362N_11runtime_lab.exit
  %_0.sroa.0.0 = phi ptr [ %8, %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc5boxed3BoxNtNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutex5MutexEECshxBJAVx362N_11runtime_lab.exit ], [ %0, %_RNCNvMNtNtNtNtCs1SSuMAdGM58_3std3sys4sync5mutex7pthreadNtB4_5Mutex3get0CshxBJAVx362N_11runtime_lab.exit ], !dbg !189
  call void @llvm.assume(i1 true) [ "nonnull"(ptr %_0.sroa.0.0) ]
  ret ptr %_0.sroa.0.0, !dbg !195
}

; core::ptr::drop_glue::<core::pin::Pin<alloc::boxed::Box<std::sys::pal::unix::sync::mutex::Mutex>>>
; Function Attrs: uwtable
define internal fastcc void @_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtB4_3pin3PinINtNtCs6zY7rJBZy9D_5alloc5boxed3BoxNtNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutex5MutexEEECshxBJAVx362N_11runtime_lab(ptr nonnull %_1.0.val) unnamed_addr #2 personality ptr @rust_eh_personality !dbg !196 !guid !197 {
start:
; invoke <std::sys::pal::unix::sync::mutex::Mutex as core::ops::drop::Drop>::drop
  invoke void @_RNvXs2_NtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutexNtB5_5MutexNtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4drop(ptr noundef nonnull align 8 %_1.0.val)
          to label %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc5boxed3BoxNtNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutex5MutexEECshxBJAVx362N_11runtime_lab.exit unwind label %bb2.i, !dbg !198

bb2.i:                                            ; preds = %start
  %0 = landingpad { ptr, i32 }
          cleanup
; call __rustc::__rust_dealloc
  tail call void @_RNvCsdtSMxSA38aw_7___rustc14___rust_dealloc(ptr noundef nonnull %_1.0.val, i64 noundef 64, i64 noundef 8) #20, !dbg !201
  resume { ptr, i32 } %0, !dbg !207

_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc5boxed3BoxNtNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutex5MutexEECshxBJAVx362N_11runtime_lab.exit: ; preds = %start
; call __rustc::__rust_dealloc
  tail call void @_RNvCsdtSMxSA38aw_7___rustc14___rust_dealloc(ptr noundef nonnull %_1.0.val, i64 noundef 64, i64 noundef 8) #20, !dbg !208
  ret void, !dbg !214
}

; core::ptr::drop_glue::<core::cell::UnsafeCell<runtime_lab::process::Capture>>
; Function Attrs: nounwind uwtable
define internal fastcc void @_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtB4_4cell10UnsafeCellNtNtCshxBJAVx362N_11runtime_lab7process7CaptureEEB14_(ptr noalias nofree noundef nonnull readonly align 8 captures(none) dereferenceable(152) %_1) unnamed_addr #3 personality ptr @rust_eh_personality !dbg !215 !guid !216 {
start:
  tail call void @llvm.experimental.noalias.scope.decl(metadata !217), !dbg !220
  %_1.val.i = load i64, ptr %_1, align 8, !dbg !221, !alias.scope !217
  %0 = icmp eq i64 %_1.val.i, 0, !dbg !224
  br i1 %0, label %bb4.i, label %_RNvXs1_NtCs6zY7rJBZy9D_5alloc5allocNtB5_6GlobalNtNtCsjIpoRzUjyHQ_4core5alloc9Allocator10deallocate.exit.i.i.i4.i.i, !dbg !224

_RNvXs1_NtCs6zY7rJBZy9D_5alloc5allocNtB5_6GlobalNtNtCsjIpoRzUjyHQ_4core5alloc9Allocator10deallocate.exit.i.i.i4.i.i: ; preds = %start
  %1 = getelementptr inbounds nuw i8, ptr %_1, i64 8, !dbg !221
  %_1.val1.i = load ptr, ptr %1, align 8, !dbg !221, !alias.scope !217, !nonnull !41, !noundef !41
; call __rustc::__rust_dealloc
  tail call void @_RNvCsdtSMxSA38aw_7___rustc14___rust_dealloc(ptr noundef nonnull %_1.val1.i, i64 noundef %_1.val.i, i64 noundef range(i64 1, -9223372036854775807) 1) #20, !dbg !240, !noalias !217
  br label %bb4.i, !dbg !245

bb4.i:                                            ; preds = %_RNvXs1_NtCs6zY7rJBZy9D_5alloc5allocNtB5_6GlobalNtNtCsjIpoRzUjyHQ_4core5alloc9Allocator10deallocate.exit.i.i.i4.i.i, %start
  %2 = getelementptr inbounds nuw i8, ptr %_1, i64 24, !dbg !221
  %.val3.i = load i64, ptr %2, align 8, !dbg !221, !range !246, !alias.scope !217, !noundef !41
  %3 = icmp sgt i64 %.val3.i, 0, !dbg !247
  br i1 %3, label %_RNvXs1_NtCs6zY7rJBZy9D_5alloc5allocNtB5_6GlobalNtNtCsjIpoRzUjyHQ_4core5alloc9Allocator10deallocate.exit.i.i.i4.i.i.i.i7.i, label %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtCshxBJAVx362N_11runtime_lab7process7CaptureEBF_.exit, !dbg !247

_RNvXs1_NtCs6zY7rJBZy9D_5alloc5allocNtB5_6GlobalNtNtCsjIpoRzUjyHQ_4core5alloc9Allocator10deallocate.exit.i.i.i4.i.i.i.i7.i: ; preds = %bb4.i
  %4 = getelementptr inbounds nuw i8, ptr %_1, i64 32, !dbg !221
  %.val4.i = load ptr, ptr %4, align 8, !dbg !221, !alias.scope !217, !nonnull !41, !noundef !41
; call __rustc::__rust_dealloc
  tail call void @_RNvCsdtSMxSA38aw_7___rustc14___rust_dealloc(ptr noundef nonnull %.val4.i, i64 noundef %.val3.i, i64 noundef range(i64 1, -9223372036854775807) 1) #20, !dbg !252, !noalias !217
  br label %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtCshxBJAVx362N_11runtime_lab7process7CaptureEBF_.exit, !dbg !263

_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtCshxBJAVx362N_11runtime_lab7process7CaptureEBF_.exit: ; preds = %bb4.i, %_RNvXs1_NtCs6zY7rJBZy9D_5alloc5allocNtB5_6GlobalNtNtCsjIpoRzUjyHQ_4core5alloc9Allocator10deallocate.exit.i.i.i4.i.i.i.i7.i
  ret void, !dbg !220
}

; core::ptr::drop_glue::<core::option::Option<std::process::Child>>
; Function Attrs: nounwind uwtable
define internal fastcc void @_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtB4_6option6OptionNtNtCs1SSuMAdGM58_3std7process5ChildEECshxBJAVx362N_11runtime_lab(ptr noalias nofree noundef nonnull readonly align 4 captures(none) dereferenceable(24) %_1) unnamed_addr #3 personality ptr @rust_eh_personality !dbg !264 !guid !265 {
start:
  %0 = load i32, ptr %_1, align 4, !dbg !266, !range !267, !noundef !41
  %1 = icmp eq i32 %0, 2, !dbg !266
  br i1 %1, label %bb1, label %bb2, !dbg !266

bb1:                                              ; preds = %bb2.i14.i, %bb5.i, %start
  ret void, !dbg !266

bb2:                                              ; preds = %start
  tail call void @llvm.experimental.noalias.scope.decl(metadata !268), !dbg !266
  %2 = getelementptr inbounds nuw i8, ptr %_1, i64 12, !dbg !271
  %.val.i = load i32, ptr %2, align 4, !dbg !271, !alias.scope !268, !noundef !41
  %3 = icmp eq i32 %.val.i, -1, !dbg !274
  br i1 %3, label %bb6.i, label %bb2.i.i, !dbg !274

bb2.i.i:                                          ; preds = %bb2
  %_5.i.i.i.i.i.i = tail call noundef i32 @close(i32 noundef %.val.i) #20, !dbg !277, !noalias !268
  br label %bb6.i, !dbg !274

bb6.i:                                            ; preds = %bb2.i.i, %bb2
  %4 = getelementptr inbounds nuw i8, ptr %_1, i64 16, !dbg !271
  %.val4.i = load i32, ptr %4, align 4, !dbg !271, !alias.scope !268, !noundef !41
  %5 = icmp eq i32 %.val4.i, -1, !dbg !291
  br i1 %5, label %bb5.i, label %bb2.i9.i, !dbg !291

bb2.i9.i:                                         ; preds = %bb6.i
  %_5.i.i.i.i.i10.i = tail call noundef i32 @close(i32 noundef %.val4.i) #20, !dbg !294, !noalias !268
  br label %bb5.i, !dbg !291

bb5.i:                                            ; preds = %bb2.i9.i, %bb6.i
  %6 = getelementptr inbounds nuw i8, ptr %_1, i64 20, !dbg !271
  %.val6.i = load i32, ptr %6, align 4, !dbg !271, !alias.scope !268, !noundef !41
  %7 = icmp eq i32 %.val6.i, -1, !dbg !300
  br i1 %7, label %bb1, label %bb2.i14.i, !dbg !300

bb2.i14.i:                                        ; preds = %bb5.i
  %_5.i.i.i.i.i15.i = tail call noundef i32 @close(i32 noundef %.val6.i) #20, !dbg !303, !noalias !268
  br label %bb1, !dbg !300
}

; core::ptr::drop_glue::<core::option::Option<tokio::process::ChildStdin>>
; Function Attrs: uwtable
define internal fastcc void @_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtB4_6option6OptionNtNtCs3EIJ1qnJmKW_5tokio7process10ChildStdinEECshxBJAVx362N_11runtime_lab(ptr noalias nofree noundef nonnull align 8 dereferenceable(32) %_1) unnamed_addr #2 personality ptr @rust_eh_personality !dbg !309 !guid !310 {
start:
  %_2.i.i.i.i.i.i.i.i = alloca [16 x i8], align 8
  %io.i.i.i.i = alloca [4 x i8], align 4
  %0 = load i64, ptr %_1, align 8, !dbg !311, !range !312, !noundef !41
  %1 = icmp eq i64 %0, 2, !dbg !311
  br i1 %1, label %bb1, label %bb2, !dbg !311

bb1:                                              ; preds = %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtCs3EIJ1qnJmKW_5tokio7process10ChildStdinECshxBJAVx362N_11runtime_lab.exit, %start
  ret void, !dbg !311

bb2:                                              ; preds = %start
  tail call void @llvm.experimental.noalias.scope.decl(metadata !313), !dbg !311
  tail call void @llvm.experimental.noalias.scope.decl(metadata !316), !dbg !319
  tail call void @llvm.experimental.noalias.scope.decl(metadata !322), !dbg !325
  tail call void @llvm.experimental.noalias.scope.decl(metadata !328), !dbg !331
  %2 = getelementptr inbounds nuw i8, ptr %_1, i64 24, !dbg !334
  %3 = load i32, ptr %2, align 8, !dbg !334, !alias.scope !350, !noundef !41
  store i32 -1, ptr %2, align 8, !dbg !351, !alias.scope !350
  %.not.i.i.i.i = icmp eq i32 %3, -1, !dbg !353
  br i1 %.not.i.i.i.i, label %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtCs3EIJ1qnJmKW_5tokio7process10ChildStdinECshxBJAVx362N_11runtime_lab.exit, label %bb1.i.i.i.i, !dbg !354

bb1.i.i.i.i:                                      ; preds = %bb2
  call void @llvm.lifetime.start.p0(ptr nonnull %io.i.i.i.i), !dbg !355, !noalias !350
  store i32 %3, ptr %io.i.i.i.i, align 4, !dbg !355, !noalias !350
; invoke <tokio::runtime::io::registration::Registration>::handle
  %_8.i.i.i.i = invoke noundef nonnull align 8 ptr @_RNvMs0_NtNtNtCs3EIJ1qnJmKW_5tokio7runtime2io12registrationNtB5_12Registration6handle(ptr noalias nofree noundef nonnull readonly align 8 captures(address, read_provenance) dereferenceable(32) %_1)
          to label %bb7.i.i.i.i unwind label %cleanup.i.i.i.i, !dbg !356

cleanup.i.i.i.i:                                  ; preds = %bb2.i1.i.i.i.i.i.i.i.i, %.noexc9.i.i.i.i, %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtNtCs1SSuMAdGM58_3std4sync6poison5mutex10MutexGuardNtNtNtNtCs3EIJ1qnJmKW_5tokio7runtime2io16registration_set6SyncedEECshxBJAVx362N_11runtime_lab.exit13.i.i.i.i.i, %bb6.i.i.i10.i.i.i.i.i, %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtNtCs1SSuMAdGM58_3std4sync6poison5mutex10MutexGuardNtNtNtNtCs3EIJ1qnJmKW_5tokio7runtime2io16registration_set6SyncedEECshxBJAVx362N_11runtime_lab.exit.i.i.i.i.i, %bb6.i.i.i.i.i.i.i.i, %bb6.i.i.i.i.i.i.i, %_RINvMNtNtNtCs1SSuMAdGM58_3std3sys4sync8once_boxINtB3_7OnceBoxNtNtNtNtNtB7_3pal4unix4sync5mutex5MutexE11get_or_initNCNvMNtNtB5_5mutex7pthreadNtB1T_5Mutex3get0ECshxBJAVx362N_11runtime_lab.exit.i.i.i.i.i.i, %bb7.i.i.i.i.i.i.i, %bb7.i.i.i.i, %bb1.i.i.i.i
  %4 = landingpad { ptr, i32 }
          cleanup
  br label %bb6.i.i.i.i, !dbg !364

bb7.i.i.i.i:                                      ; preds = %bb1.i.i.i.i
  %_10.i.i.i.i = getelementptr inbounds nuw i8, ptr %_1, i64 16, !dbg !365
  %_6.i.i.i.i.i = getelementptr inbounds nuw i8, ptr %_8.i.i.i.i, i64 88, !dbg !366
; invoke <mio::sys::unix::pipe::Sender as mio::event::source::Source>::deregister
  %5 = invoke noundef ptr @_RNvXs_NtNtNtCsiDZg47dpzEY_3mio3sys4unix4pipeNtB4_6SenderNtNtNtBa_5event6source6Source10deregister(ptr noalias nofree noundef nonnull align 4 dereferenceable(4) %io.i.i.i.i, ptr noalias nofree noundef nonnull readonly align 4 captures(address, read_provenance) dereferenceable(4) %_6.i.i.i.i.i)
          to label %.noexc.i.i.i.i unwind label %cleanup.i.i.i.i, !dbg !372

.noexc.i.i.i.i:                                   ; preds = %bb7.i.i.i.i
  %.not.i.i.i.i.i = icmp eq ptr %5, null, !dbg !379
  br i1 %.not.i.i.i.i.i, label %bb13.i.i.i.i.i, label %bb2.i11.i.i.i.i, !dbg !385

bb13.i.i.i.i.i:                                   ; preds = %.noexc.i.i.i.i
  %_9.i.i.i.i.i = getelementptr inbounds nuw i8, ptr %_8.i.i.i.i, i64 64, !dbg !386
  %6 = load atomic ptr, ptr %_8.i.i.i.i acquire, align 8, !dbg !387, !noalias !412
  %_11.i.i.i.i.i.i.i = icmp eq ptr %6, null, !dbg !418
  br i1 %_11.i.i.i.i.i.i.i, label %bb7.i.i.i.i.i.i.i, label %_RINvMNtNtNtCs1SSuMAdGM58_3std3sys4sync8once_boxINtB3_7OnceBoxNtNtNtNtNtB7_3pal4unix4sync5mutex5MutexE11get_or_initNCNvMNtNtB5_5mutex7pthreadNtB1T_5Mutex3get0ECshxBJAVx362N_11runtime_lab.exit.i.i.i.i.i.i, !dbg !439, !prof !135

bb7.i.i.i.i.i.i.i:                                ; preds = %bb13.i.i.i.i.i
; invoke <std::sys::sync::once_box::OnceBox<std::sys::pal::unix::sync::mutex::Mutex>>::initialize::<<std::sys::sync::mutex::pthread::Mutex>::get::{closure#0}>
  %7 = invoke fastcc noundef nonnull align 8 ptr @_RINvMNtNtNtCs1SSuMAdGM58_3std3sys4sync8once_boxINtB3_7OnceBoxNtNtNtNtNtB7_3pal4unix4sync5mutex5MutexE10initializeNCNvMNtNtB5_5mutex7pthreadNtB1S_5Mutex3get0ECshxBJAVx362N_11runtime_lab(ptr noundef nonnull align 8 %_8.i.i.i.i)
          to label %_RINvMNtNtNtCs1SSuMAdGM58_3std3sys4sync8once_boxINtB3_7OnceBoxNtNtNtNtNtB7_3pal4unix4sync5mutex5MutexE11get_or_initNCNvMNtNtB5_5mutex7pthreadNtB1T_5Mutex3get0ECshxBJAVx362N_11runtime_lab.exit.i.i.i.i.i.i unwind label %cleanup.i.i.i.i, !dbg !440

_RINvMNtNtNtCs1SSuMAdGM58_3std3sys4sync8once_boxINtB3_7OnceBoxNtNtNtNtNtB7_3pal4unix4sync5mutex5MutexE11get_or_initNCNvMNtNtB5_5mutex7pthreadNtB1T_5Mutex3get0ECshxBJAVx362N_11runtime_lab.exit.i.i.i.i.i.i: ; preds = %bb7.i.i.i.i.i.i.i, %bb13.i.i.i.i.i
  %_0.sroa.0.0.i.i.i.i.i.i.i = phi ptr [ %6, %bb13.i.i.i.i.i ], [ %7, %bb7.i.i.i.i.i.i.i ], !dbg !441
; invoke <std::sys::pal::unix::sync::mutex::Mutex>::lock
  invoke void @_RNvMNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutexNtB2_5Mutex4lock(ptr noundef nonnull align 8 %_0.sroa.0.0.i.i.i.i.i.i.i)
          to label %.noexc4.i.i.i.i unwind label %cleanup.i.i.i.i, !dbg !442

.noexc4.i.i.i.i:                                  ; preds = %_RINvMNtNtNtCs1SSuMAdGM58_3std3sys4sync8once_boxINtB3_7OnceBoxNtNtNtNtNtB7_3pal4unix4sync5mutex5MutexE11get_or_initNCNvMNtNtB5_5mutex7pthreadNtB1T_5Mutex3get0ECshxBJAVx362N_11runtime_lab.exit.i.i.i.i.i.i
  %8 = load atomic i64, ptr @_RNvNtNtCs1SSuMAdGM58_3std9panicking11panic_count18GLOBAL_PANIC_COUNT monotonic, align 8, !dbg !443, !noalias !467
  %_7.i.i.i.i.i.i.i = and i64 %8, 9223372036854775807, !dbg !468
  %9 = icmp eq i64 %_7.i.i.i.i.i.i.i, 0, !dbg !468
  br i1 %9, label %_RNvMs5_NtNtNtCs1SSuMAdGM58_3std4sync6poison5mutexINtB5_5MutexNtNtNtNtCs3EIJ1qnJmKW_5tokio7runtime2io16registration_set6SyncedE4lockCshxBJAVx362N_11runtime_lab.exit.i.i.i.i.i, label %bb6.i.i.i.i.i.i.i, !dbg !468, !prof !74

bb6.i.i.i.i.i.i.i:                                ; preds = %.noexc4.i.i.i.i
; invoke std::panicking::panic_count::is_zero_slow_path
  %10 = invoke noundef zeroext i1 @_RNvNtNtCs1SSuMAdGM58_3std9panicking11panic_count17is_zero_slow_path() #24
          to label %.noexc5.i.i.i.i unwind label %cleanup.i.i.i.i, !dbg !469

.noexc5.i.i.i.i:                                  ; preds = %bb6.i.i.i.i.i.i.i
  %11 = xor i1 %10, true, !dbg !470
  br label %_RNvMs5_NtNtNtCs1SSuMAdGM58_3std4sync6poison5mutexINtB5_5MutexNtNtNtNtCs3EIJ1qnJmKW_5tokio7runtime2io16registration_set6SyncedE4lockCshxBJAVx362N_11runtime_lab.exit.i.i.i.i.i, !dbg !469

_RNvMs5_NtNtNtCs1SSuMAdGM58_3std4sync6poison5mutexINtB5_5MutexNtNtNtNtCs3EIJ1qnJmKW_5tokio7runtime2io16registration_set6SyncedE4lockCshxBJAVx362N_11runtime_lab.exit.i.i.i.i.i: ; preds = %.noexc5.i.i.i.i, %.noexc4.i.i.i.i
  %_6.sroa.0.0.off0.i.i.i.i.i.i.i = phi i1 [ %11, %.noexc5.i.i.i.i ], [ false, %.noexc4.i.i.i.i ]
  %_7.i.i.i.i.i.i = getelementptr inbounds nuw i8, ptr %_8.i.i.i.i, i64 8, !dbg !471
  %12 = load atomic i8, ptr %_7.i.i.i.i.i.i monotonic, align 8, !dbg !472, !noalias !412
  %_24.i.i.i.i.i = getelementptr inbounds nuw i8, ptr %_8.i.i.i.i, i64 16, !dbg !480
; invoke <tokio::runtime::io::registration_set::RegistrationSet>::deregister
  %_8.i.i.i.i.i = invoke noundef zeroext i1 @_RNvMNtNtNtCs3EIJ1qnJmKW_5tokio7runtime2io16registration_setNtB2_15RegistrationSet10deregister(ptr noundef nonnull align 8 %_9.i.i.i.i.i, ptr noalias nofree noundef nonnull align 8 dereferenceable(48) %_24.i.i.i.i.i, ptr noalias nofree noundef nonnull readonly align 8 captures(address, read_provenance) dereferenceable(8) %_10.i.i.i.i)
          to label %bb2.i.i.i.i.i unwind label %cleanup.i.i.i.i.i, !dbg !489

cleanup.i.i.i.i.i:                                ; preds = %_RNvMs5_NtNtNtCs1SSuMAdGM58_3std4sync6poison5mutexINtB5_5MutexNtNtNtNtCs3EIJ1qnJmKW_5tokio7runtime2io16registration_set6SyncedE4lockCshxBJAVx362N_11runtime_lab.exit.i.i.i.i.i
  %13 = landingpad { ptr, i32 }
          cleanup
  %_0.sroa.3.0.i.i.i.i.i.i.i = zext i1 %_6.sroa.0.0.off0.i.i.i.i.i.i.i to i8, !dbg !490
; invoke core::ptr::drop_glue::<std::sync::poison::PoisonError<std::sync::poison::mutex::MutexGuard<runtime_lab::process::Capture>>>
  invoke fastcc void @_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtCs1SSuMAdGM58_3std4sync6poison11PoisonErrorINtNtBE_5mutex10MutexGuardNtNtCshxBJAVx362N_11runtime_lab7process7CaptureEEEB1T_(ptr nonnull align 8 %_8.i.i.i.i, i8 %_0.sroa.3.0.i.i.i.i.i.i.i) #23
          to label %bb6.i.i.i.i unwind label %terminate.i.i.i.i.i, !dbg !491

bb2.i.i.i.i.i:                                    ; preds = %_RNvMs5_NtNtNtCs1SSuMAdGM58_3std4sync6poison5mutexINtB5_5MutexNtNtNtNtCs3EIJ1qnJmKW_5tokio7runtime2io16registration_set6SyncedE4lockCshxBJAVx362N_11runtime_lab.exit.i.i.i.i.i
  br i1 %_8.i.i.i.i.i, label %bb3.i.i.i.i.i, label %bb5.i.i.i.i.i, !dbg !386

bb5.i.i.i.i.i:                                    ; preds = %bb2.i.i.i.i.i
  br i1 %_6.sroa.0.0.off0.i.i.i.i.i.i.i, label %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtNtCs1SSuMAdGM58_3std4sync6poison5mutex10MutexGuardNtNtNtNtCs3EIJ1qnJmKW_5tokio7runtime2io16registration_set6SyncedEECshxBJAVx362N_11runtime_lab.exit.i.i.i.i.i, label %bb1.i.i.i.i.i.i.i.i, !dbg !492

bb1.i.i.i.i.i.i.i.i:                              ; preds = %bb5.i.i.i.i.i
  %14 = load atomic i64, ptr @_RNvNtNtCs1SSuMAdGM58_3std9panicking11panic_count18GLOBAL_PANIC_COUNT monotonic, align 8, !dbg !500, !noalias !510
  %_7.i.i.i.i.i.i.i.i = and i64 %14, 9223372036854775807, !dbg !511
  %15 = icmp eq i64 %_7.i.i.i.i.i.i.i.i, 0, !dbg !511
  br i1 %15, label %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtNtCs1SSuMAdGM58_3std4sync6poison5mutex10MutexGuardNtNtNtNtCs3EIJ1qnJmKW_5tokio7runtime2io16registration_set6SyncedEECshxBJAVx362N_11runtime_lab.exit.i.i.i.i.i, label %bb6.i.i.i.i.i.i.i.i, !dbg !511, !prof !74

bb6.i.i.i.i.i.i.i.i:                              ; preds = %bb1.i.i.i.i.i.i.i.i
; invoke std::panicking::panic_count::is_zero_slow_path
  %_6.i.i.i.i6.i.i.i.i = invoke noundef zeroext i1 @_RNvNtNtCs1SSuMAdGM58_3std9panicking11panic_count17is_zero_slow_path() #24
          to label %_6.i.i.i.i.noexc.i.i.i.i unwind label %cleanup.i.i.i.i, !dbg !512

_6.i.i.i.i.noexc.i.i.i.i:                         ; preds = %bb6.i.i.i.i.i.i.i.i
  br i1 %_6.i.i.i.i6.i.i.i.i, label %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtNtCs1SSuMAdGM58_3std4sync6poison5mutex10MutexGuardNtNtNtNtCs3EIJ1qnJmKW_5tokio7runtime2io16registration_set6SyncedEECshxBJAVx362N_11runtime_lab.exit.i.i.i.i.i, label %bb2.i.i.i.i.i.i.i.i, !dbg !513

bb2.i.i.i.i.i.i.i.i:                              ; preds = %_6.i.i.i.i.noexc.i.i.i.i
  store atomic i8 1, ptr %_7.i.i.i.i.i.i monotonic, align 8, !dbg !514, !noalias !519
  br label %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtNtCs1SSuMAdGM58_3std4sync6poison5mutex10MutexGuardNtNtNtNtCs3EIJ1qnJmKW_5tokio7runtime2io16registration_set6SyncedEECshxBJAVx362N_11runtime_lab.exit.i.i.i.i.i, !dbg !520

_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtNtCs1SSuMAdGM58_3std4sync6poison5mutex10MutexGuardNtNtNtNtCs3EIJ1qnJmKW_5tokio7runtime2io16registration_set6SyncedEECshxBJAVx362N_11runtime_lab.exit.i.i.i.i.i: ; preds = %bb2.i.i.i.i.i.i.i.i, %_6.i.i.i.i.noexc.i.i.i.i, %bb1.i.i.i.i.i.i.i.i, %bb5.i.i.i.i.i
  %16 = load atomic ptr, ptr %_8.i.i.i.i monotonic, align 8, !dbg !521, !noalias !519
; invoke <std::sys::pal::unix::sync::mutex::Mutex>::unlock
  invoke void @_RNvMNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutexNtB2_5Mutex6unlock(ptr noundef nonnull align 8 %16)
          to label %bb6.i.i.i unwind label %cleanup.i.i.i.i, !dbg !529

bb3.i.i.i.i.i:                                    ; preds = %bb2.i.i.i.i.i
  br i1 %_6.sroa.0.0.off0.i.i.i.i.i.i.i, label %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtNtCs1SSuMAdGM58_3std4sync6poison5mutex10MutexGuardNtNtNtNtCs3EIJ1qnJmKW_5tokio7runtime2io16registration_set6SyncedEECshxBJAVx362N_11runtime_lab.exit13.i.i.i.i.i, label %bb1.i.i.i8.i.i.i.i.i, !dbg !530

bb1.i.i.i8.i.i.i.i.i:                             ; preds = %bb3.i.i.i.i.i
  %17 = load atomic i64, ptr @_RNvNtNtCs1SSuMAdGM58_3std9panicking11panic_count18GLOBAL_PANIC_COUNT monotonic, align 8, !dbg !534, !noalias !510
  %_7.i.i.i9.i.i.i.i.i = and i64 %17, 9223372036854775807, !dbg !540
  %18 = icmp eq i64 %_7.i.i.i9.i.i.i.i.i, 0, !dbg !540
  br i1 %18, label %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtNtCs1SSuMAdGM58_3std4sync6poison5mutex10MutexGuardNtNtNtNtCs3EIJ1qnJmKW_5tokio7runtime2io16registration_set6SyncedEECshxBJAVx362N_11runtime_lab.exit13.i.i.i.i.i, label %bb6.i.i.i10.i.i.i.i.i, !dbg !540, !prof !74

bb6.i.i.i10.i.i.i.i.i:                            ; preds = %bb1.i.i.i8.i.i.i.i.i
; invoke std::panicking::panic_count::is_zero_slow_path
  %_6.i.i.i11.i8.i.i.i.i = invoke noundef zeroext i1 @_RNvNtNtCs1SSuMAdGM58_3std9panicking11panic_count17is_zero_slow_path() #24
          to label %_6.i.i.i11.i.noexc.i.i.i.i unwind label %cleanup.i.i.i.i, !dbg !541

_6.i.i.i11.i.noexc.i.i.i.i:                       ; preds = %bb6.i.i.i10.i.i.i.i.i
  br i1 %_6.i.i.i11.i8.i.i.i.i, label %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtNtCs1SSuMAdGM58_3std4sync6poison5mutex10MutexGuardNtNtNtNtCs3EIJ1qnJmKW_5tokio7runtime2io16registration_set6SyncedEECshxBJAVx362N_11runtime_lab.exit13.i.i.i.i.i, label %bb2.i.i.i12.i.i.i.i.i, !dbg !542

bb2.i.i.i12.i.i.i.i.i:                            ; preds = %_6.i.i.i11.i.noexc.i.i.i.i
  store atomic i8 1, ptr %_7.i.i.i.i.i.i monotonic, align 8, !dbg !543, !noalias !519
  br label %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtNtCs1SSuMAdGM58_3std4sync6poison5mutex10MutexGuardNtNtNtNtCs3EIJ1qnJmKW_5tokio7runtime2io16registration_set6SyncedEECshxBJAVx362N_11runtime_lab.exit13.i.i.i.i.i, !dbg !546

_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtNtCs1SSuMAdGM58_3std4sync6poison5mutex10MutexGuardNtNtNtNtCs3EIJ1qnJmKW_5tokio7runtime2io16registration_set6SyncedEECshxBJAVx362N_11runtime_lab.exit13.i.i.i.i.i: ; preds = %bb2.i.i.i12.i.i.i.i.i, %_6.i.i.i11.i.noexc.i.i.i.i, %bb1.i.i.i8.i.i.i.i.i, %bb3.i.i.i.i.i
  %19 = load atomic ptr, ptr %_8.i.i.i.i monotonic, align 8, !dbg !547, !noalias !519
; invoke <std::sys::pal::unix::sync::mutex::Mutex>::unlock
  invoke void @_RNvMNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutexNtB2_5Mutex6unlock(ptr noundef nonnull align 8 %19)
          to label %.noexc9.i.i.i.i unwind label %cleanup.i.i.i.i, !dbg !552

.noexc9.i.i.i.i:                                  ; preds = %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtNtCs1SSuMAdGM58_3std4sync6poison5mutex10MutexGuardNtNtNtNtCs3EIJ1qnJmKW_5tokio7runtime2io16registration_set6SyncedEECshxBJAVx362N_11runtime_lab.exit13.i.i.i.i.i
; invoke <tokio::runtime::io::driver::Handle>::unpark
  invoke void @_RNvMs0_NtNtNtCs3EIJ1qnJmKW_5tokio7runtime2io6driverNtB5_6Handle6unpark(ptr noundef nonnull align 8 %_8.i.i.i.i)
          to label %bb6.i.i.i unwind label %cleanup.i.i.i.i, !dbg !553

terminate.i.i.i.i.i:                              ; preds = %cleanup.i.i.i.i.i
  %20 = landingpad { ptr, i32 }
          filter [0 x ptr] zeroinitializer
; call core::panicking::panic_in_cleanup
  call void @_RNvNtCsjIpoRzUjyHQ_4core9panicking16panic_in_cleanup() #22, !dbg !554
  unreachable, !dbg !554

bb2.i11.i.i.i.i:                                  ; preds = %.noexc.i.i.i.i
  call void @llvm.lifetime.start.p0(ptr nonnull %_2.i.i.i.i.i.i.i.i), !dbg !555, !noalias !350
  %bits.i.i.i.i.i.i.i.i.i = ptrtoint ptr %5 to i64, !dbg !569
  %_5.i.i.i.i.i.i.i.i.i = and i64 %bits.i.i.i.i.i.i.i.i.i, 3, !dbg !574
  switch i64 %_5.i.i.i.i.i.i.i.i.i, label %default.unreachable [
    i64 2, label %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtNtB4_2io5error5ErrorECshxBJAVx362N_11runtime_lab.exit.i.i.i.i.i
    i64 3, label %bb4.i.i.i.i.i.i.i.i.i
    i64 0, label %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtNtB4_2io5error5ErrorECshxBJAVx362N_11runtime_lab.exit.i.i.i.i.i
    i64 1, label %bb2.i1.i.i.i.i.i.i.i.i
  ], !dbg !576, !prof !577

default.unreachable:                              ; preds = %bb2.i11.i.i.i.i
  unreachable

bb4.i.i.i.i.i.i.i.i.i:                            ; preds = %bb2.i11.i.i.i.i
  %21 = icmp ult ptr %5, inttoptr (i64 188978561024 to ptr), !dbg !578
  %22 = and i64 %bits.i.i.i.i.i.i.i.i.i, 1095216660480, !dbg !584
  %23 = icmp ne i64 %22, 1095216660480, !dbg !584
  call void @llvm.assume(i1 %21), !dbg !587
  call void @llvm.assume(i1 %23), !dbg !587
  br label %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtNtB4_2io5error5ErrorECshxBJAVx362N_11runtime_lab.exit.i.i.i.i.i, !dbg !588

bb2.i1.i.i.i.i.i.i.i.i:                           ; preds = %bb2.i11.i.i.i.i
  %_33.i.i.i.i.i.i.i.i.i = getelementptr i8, ptr %5, i64 -1, !dbg !589
  call void @llvm.assume(i1 true) [ "nonnull"(ptr %_33.i.i.i.i.i.i.i.i.i) ], !dbg !596
  %24 = getelementptr inbounds nuw i8, ptr %_2.i.i.i.i.i.i.i.i, i64 8, !dbg !606
  store ptr %_33.i.i.i.i.i.i.i.i.i, ptr %24, align 8, !dbg !606, !alias.scope !607, !noalias !350
  store i8 3, ptr %_2.i.i.i.i.i.i.i.i, align 8, !dbg !610, !alias.scope !607, !noalias !350
; invoke <core::io::error::CustomOwner as core::ops::drop::Drop>::drop
  invoke void @_RNvXsd_NtNtCsjIpoRzUjyHQ_4core2io5errorNtB5_11CustomOwnerNtNtNtB9_3ops4drop4Drop4drop(ptr noalias nofree noundef nonnull align 8 dereferenceable(8) %24)
          to label %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtNtB4_2io5error5ErrorECshxBJAVx362N_11runtime_lab.exit.i.i.i.i.i unwind label %cleanup.i.i.i.i, !dbg !611

_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtNtB4_2io5error5ErrorECshxBJAVx362N_11runtime_lab.exit.i.i.i.i.i: ; preds = %bb2.i1.i.i.i.i.i.i.i.i, %bb4.i.i.i.i.i.i.i.i.i, %bb2.i11.i.i.i.i, %bb2.i11.i.i.i.i
  call void @llvm.lifetime.end.p0(ptr nonnull %_2.i.i.i.i.i.i.i.i), !dbg !616, !noalias !350
  br label %bb6.i.i.i, !dbg !617

bb6.i.i.i.i:                                      ; preds = %cleanup.i.i.i.i.i, %cleanup.i.i.i.i
  %eh.lpad-body.i.i.i.i = phi { ptr, i32 } [ %4, %cleanup.i.i.i.i ], [ %13, %cleanup.i.i.i.i.i ]
  %io.val.i.i.i.i = load i32, ptr %io.i.i.i.i, align 4, !dbg !364, !range !618, !noalias !350, !noundef !41
  %_5.i.i.i.i.i.i.i.i.i.i.i = call noundef i32 @close(i32 noundef %io.val.i.i.i.i) #20, !dbg !619
  %.val.i.i.i = load i32, ptr %2, align 8, !dbg !331, !alias.scope !631, !noundef !41
  %25 = icmp eq i32 %.val.i.i.i, -1, !dbg !632
  br i1 %25, label %bb3.i.i.i, label %bb2.i4.i.i.i, !dbg !632

bb2.i4.i.i.i:                                     ; preds = %bb6.i.i.i.i
  %_5.i.i.i.i.i.i.i.i5.i.i.i = call noundef i32 @close(i32 noundef %.val.i.i.i) #20, !dbg !635
  br label %bb3.i.i.i, !dbg !632

bb6.i.i.i:                                        ; preds = %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtNtB4_2io5error5ErrorECshxBJAVx362N_11runtime_lab.exit.i.i.i.i.i, %.noexc9.i.i.i.i, %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtNtCs1SSuMAdGM58_3std4sync6poison5mutex10MutexGuardNtNtNtNtCs3EIJ1qnJmKW_5tokio7runtime2io16registration_set6SyncedEECshxBJAVx362N_11runtime_lab.exit.i.i.i.i.i
  %io.val2.i.i.i.i = load i32, ptr %io.i.i.i.i, align 4, !dbg !364, !range !618, !noalias !350, !noundef !41
  %_5.i.i.i.i.i.i.i13.i.i.i.i = call noundef i32 @close(i32 noundef %io.val2.i.i.i.i) #20, !dbg !643
  call void @llvm.lifetime.end.p0(ptr nonnull %io.i.i.i.i), !dbg !364, !noalias !350
  %.val3.pr.i.i.i = load i32, ptr %2, align 8, !dbg !331, !alias.scope !631
  %26 = icmp eq i32 %.val3.pr.i.i.i, -1, !dbg !651
  br i1 %26, label %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtCs3EIJ1qnJmKW_5tokio7process10ChildStdinECshxBJAVx362N_11runtime_lab.exit, label %bb2.i7.i.i.i, !dbg !651

bb2.i7.i.i.i:                                     ; preds = %bb6.i.i.i
  %_5.i.i.i.i.i.i.i.i8.i.i.i = call noundef i32 @close(i32 noundef %.val3.pr.i.i.i) #20, !dbg !653
  br label %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtCs3EIJ1qnJmKW_5tokio7process10ChildStdinECshxBJAVx362N_11runtime_lab.exit, !dbg !651

bb3.i.i.i:                                        ; preds = %bb2.i4.i.i.i, %bb6.i.i.i.i
; invoke core::ptr::drop_glue::<tokio::runtime::io::registration::Registration>
  invoke fastcc void @_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtNtNtCs3EIJ1qnJmKW_5tokio7runtime2io12registration12RegistrationECshxBJAVx362N_11runtime_lab(ptr noalias nofree noundef nonnull align 8 dereferenceable(32) %_1) #23
          to label %bb2.i.i.i unwind label %terminate.i.i.i, !dbg !331

terminate.i.i.i:                                  ; preds = %bb3.i.i.i
  %27 = landingpad { ptr, i32 }
          filter [0 x ptr] zeroinitializer
; call core::panicking::panic_in_cleanup
  call void @_RNvNtCsjIpoRzUjyHQ_4core9panicking16panic_in_cleanup() #22, !dbg !331
  unreachable, !dbg !331

bb2.i.i.i:                                        ; preds = %bb3.i.i.i
  resume { ptr, i32 } %eh.lpad-body.i.i.i.i, !dbg !331

_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtCs3EIJ1qnJmKW_5tokio7process10ChildStdinECshxBJAVx362N_11runtime_lab.exit: ; preds = %bb2, %bb6.i.i.i, %bb2.i7.i.i.i
; call core::ptr::drop_glue::<tokio::runtime::io::registration::Registration>
  call fastcc void @_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtNtNtCs3EIJ1qnJmKW_5tokio7runtime2io12registration12RegistrationECshxBJAVx362N_11runtime_lab(ptr noalias nofree noundef nonnull align 8 dereferenceable(32) %_1), !dbg !331
  br label %bb1, !dbg !311
}

; core::ptr::drop_glue::<core::result::Result<tokio::process::Child, core::io::error::Error>>
; Function Attrs: uwtable
define internal fastcc void @_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtB4_6result6ResultNtNtCs3EIJ1qnJmKW_5tokio7process5ChildNtNtNtB4_2io5error5ErrorEECshxBJAVx362N_11runtime_lab(ptr noalias nofree noundef nonnull align 8 dereferenceable(144) %_1) unnamed_addr #2 personality ptr @rust_eh_personality !dbg !661 !guid !662 {
start:
  %_2.i.i.i = alloca [16 x i8], align 8
  %_2.i.i.i.i.i.i.i.i = alloca [16 x i8], align 8
  %0 = load i64, ptr %_1, align 8, !dbg !663, !range !664, !noundef !41
  %.not = icmp eq i64 %0, -1, !dbg !663
  br i1 %.not, label %bb3, label %bb2, !dbg !663

bb2:                                              ; preds = %start
  tail call void @llvm.experimental.noalias.scope.decl(metadata !665), !dbg !663
  %1 = getelementptr inbounds nuw i8, ptr %_1, i64 96, !dbg !668
  tail call void @llvm.experimental.noalias.scope.decl(metadata !671), !dbg !668
  %2 = load i32, ptr %1, align 8, !dbg !674, !range !677, !alias.scope !678, !noundef !41
  %.not.i.i = icmp eq i32 %2, -1, !dbg !674
  br i1 %.not.i.i, label %bb8.i, label %bb2.i.i, !dbg !674

bb2.i.i:                                          ; preds = %bb2
  tail call void @llvm.experimental.noalias.scope.decl(metadata !679), !dbg !674
  tail call void @llvm.experimental.noalias.scope.decl(metadata !682), !dbg !685
  %3 = getelementptr inbounds nuw i8, ptr %_1, i64 136, !dbg !688
  %4 = load i8, ptr %3, align 8, !dbg !688, !range !694, !alias.scope !695, !noundef !41
  %_2.i.i.i.i = trunc nuw i8 %4 to i1, !dbg !688
  br i1 %_2.i.i.i.i, label %bb1.i.i.i.i, label %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs3EIJ1qnJmKW_5tokio7process14ChildDropGuardNtNtBE_3imp5ChildEECshxBJAVx362N_11runtime_lab.exit.i.i, !dbg !688

bb1.i.i.i.i:                                      ; preds = %bb2.i.i
; invoke <tokio::process::imp::Child as tokio::process::kill::Kill>::kill
  %5 = invoke noundef ptr @_RNvXs5_NtNtCs3EIJ1qnJmKW_5tokio7process3impNtB5_5ChildNtNtB7_4kill4Kill4kill(ptr noalias nofree noundef nonnull align 8 dereferenceable(48) %1)
          to label %.noexc.i.i.i unwind label %cleanup.i.i.i, !dbg !696

.noexc.i.i.i:                                     ; preds = %bb1.i.i.i.i
  %6 = icmp eq ptr %5, null, !dbg !700
  br i1 %6, label %bb5.thread.i.i.i.i, label %bb2.i.i.i.i.i, !dbg !708

bb2.i.i.i.i.i:                                    ; preds = %.noexc.i.i.i
  call void @llvm.lifetime.start.p0(ptr nonnull %_2.i.i.i.i.i.i.i.i), !dbg !709, !noalias !695
  %bits.i.i.i.i.i.i.i.i.i = ptrtoint ptr %5 to i64, !dbg !716
  %_5.i.i.i.i.i.i.i.i.i = and i64 %bits.i.i.i.i.i.i.i.i.i, 3, !dbg !719
  switch i64 %_5.i.i.i.i.i.i.i.i.i, label %default.unreachable [
    i64 2, label %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtNtB4_2io5error5ErrorECshxBJAVx362N_11runtime_lab.exit.i.i.i.i.i
    i64 3, label %bb4.i.i.i.i.i.i.i.i.i
    i64 0, label %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtNtB4_2io5error5ErrorECshxBJAVx362N_11runtime_lab.exit.i.i.i.i.i
    i64 1, label %bb2.i1.i.i.i.i.i.i.i.i
  ], !dbg !720, !prof !577

default.unreachable:                              ; preds = %bb3, %bb2.i.i.i.i.i
  unreachable

bb4.i.i.i.i.i.i.i.i.i:                            ; preds = %bb2.i.i.i.i.i
  %7 = icmp ult ptr %5, inttoptr (i64 188978561024 to ptr), !dbg !721
  %8 = and i64 %bits.i.i.i.i.i.i.i.i.i, 1095216660480, !dbg !723
  %9 = icmp ne i64 %8, 1095216660480, !dbg !723
  tail call void @llvm.assume(i1 %7), !dbg !725
  tail call void @llvm.assume(i1 %9), !dbg !725
  br label %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtNtB4_2io5error5ErrorECshxBJAVx362N_11runtime_lab.exit.i.i.i.i.i, !dbg !726

bb2.i1.i.i.i.i.i.i.i.i:                           ; preds = %bb2.i.i.i.i.i
  %_33.i.i.i.i.i.i.i.i.i = getelementptr i8, ptr %5, i64 -1, !dbg !727
  call void @llvm.assume(i1 true) [ "nonnull"(ptr %_33.i.i.i.i.i.i.i.i.i) ], !dbg !731
  %10 = getelementptr inbounds nuw i8, ptr %_2.i.i.i.i.i.i.i.i, i64 8, !dbg !734
  store ptr %_33.i.i.i.i.i.i.i.i.i, ptr %10, align 8, !dbg !734, !alias.scope !735, !noalias !695
  store i8 3, ptr %_2.i.i.i.i.i.i.i.i, align 8, !dbg !738, !alias.scope !735, !noalias !695
; invoke <core::io::error::CustomOwner as core::ops::drop::Drop>::drop
  invoke void @_RNvXsd_NtNtCsjIpoRzUjyHQ_4core2io5errorNtB5_11CustomOwnerNtNtNtB9_3ops4drop4Drop4drop(ptr noalias nofree noundef nonnull align 8 dereferenceable(8) %10)
          to label %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtNtB4_2io5error5ErrorECshxBJAVx362N_11runtime_lab.exit.i.i.i.i.i unwind label %cleanup.i.i.i, !dbg !739

_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtNtB4_2io5error5ErrorECshxBJAVx362N_11runtime_lab.exit.i.i.i.i.i: ; preds = %bb2.i1.i.i.i.i.i.i.i.i, %bb4.i.i.i.i.i.i.i.i.i, %bb2.i.i.i.i.i, %bb2.i.i.i.i.i
  call void @llvm.lifetime.end.p0(ptr nonnull %_2.i.i.i.i.i.i.i.i), !dbg !742, !noalias !695
  br label %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs3EIJ1qnJmKW_5tokio7process14ChildDropGuardNtNtBE_3imp5ChildEECshxBJAVx362N_11runtime_lab.exit.i.i, !dbg !743

bb5.thread.i.i.i.i:                               ; preds = %.noexc.i.i.i
  store i8 0, ptr %3, align 8, !dbg !744, !alias.scope !695
  br label %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs3EIJ1qnJmKW_5tokio7process14ChildDropGuardNtNtBE_3imp5ChildEECshxBJAVx362N_11runtime_lab.exit.i.i, !dbg !743

cleanup.i.i.i:                                    ; preds = %bb2.i1.i.i.i.i.i.i.i.i, %bb1.i.i.i.i
  %11 = landingpad { ptr, i32 }
          cleanup
; invoke core::ptr::drop_glue::<tokio::process::imp::Child>
  invoke fastcc void @_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtNtCs3EIJ1qnJmKW_5tokio7process3imp5ChildECshxBJAVx362N_11runtime_lab(ptr noalias nofree noundef nonnull align 8 dereferenceable(48) %1) #23
          to label %cleanup.body.i unwind label %terminate.i.i.i, !dbg !685

terminate.i.i.i:                                  ; preds = %cleanup.i.i.i
  %12 = landingpad { ptr, i32 }
          filter [0 x ptr] zeroinitializer
; call core::panicking::panic_in_cleanup
  call void @_RNvNtCsjIpoRzUjyHQ_4core9panicking16panic_in_cleanup() #22, !dbg !685
  unreachable, !dbg !685

_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs3EIJ1qnJmKW_5tokio7process14ChildDropGuardNtNtBE_3imp5ChildEECshxBJAVx362N_11runtime_lab.exit.i.i: ; preds = %bb5.thread.i.i.i.i, %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtNtB4_2io5error5ErrorECshxBJAVx362N_11runtime_lab.exit.i.i.i.i.i, %bb2.i.i
; invoke core::ptr::drop_glue::<tokio::process::imp::Child>
  invoke fastcc void @_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtNtCs3EIJ1qnJmKW_5tokio7process3imp5ChildECshxBJAVx362N_11runtime_lab(ptr noalias nofree noundef nonnull align 8 dereferenceable(48) %1)
          to label %bb8.i unwind label %cleanup.i, !dbg !685

cleanup.i:                                        ; preds = %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs3EIJ1qnJmKW_5tokio7process14ChildDropGuardNtNtBE_3imp5ChildEECshxBJAVx362N_11runtime_lab.exit.i.i
  %13 = landingpad { ptr, i32 }
          cleanup
  br label %cleanup.body.i, !dbg !668

cleanup.body.i:                                   ; preds = %cleanup.i, %cleanup.i.i.i
  %eh.lpad-body.i = phi { ptr, i32 } [ %13, %cleanup.i ], [ %11, %cleanup.i.i.i ]
; invoke core::ptr::drop_glue::<core::option::Option<tokio::process::ChildStdin>>
  invoke fastcc void @_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtB4_6option6OptionNtNtCs3EIJ1qnJmKW_5tokio7process10ChildStdinEECshxBJAVx362N_11runtime_lab(ptr noalias nofree noundef nonnull align 8 dereferenceable(144) %_1) #23
          to label %bb4.i unwind label %terminate.i, !dbg !668

bb8.i:                                            ; preds = %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs3EIJ1qnJmKW_5tokio7process14ChildDropGuardNtNtBE_3imp5ChildEECshxBJAVx362N_11runtime_lab.exit.i.i, %bb2
; invoke core::ptr::drop_glue::<core::option::Option<tokio::process::ChildStdin>>
  invoke fastcc void @_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtB4_6option6OptionNtNtCs3EIJ1qnJmKW_5tokio7process10ChildStdinEECshxBJAVx362N_11runtime_lab(ptr noalias nofree noundef nonnull align 8 dereferenceable(144) %_1)
          to label %bb7.i unwind label %cleanup1.i, !dbg !668

bb4.i:                                            ; preds = %cleanup1.i, %cleanup.body.i
  %.pn.i = phi { ptr, i32 } [ %17, %cleanup1.i ], [ %eh.lpad-body.i, %cleanup.body.i ]
  %14 = getelementptr inbounds nuw i8, ptr %_1, i64 32, !dbg !668
  %15 = load i64, ptr %14, align 8, !dbg !745, !range !312, !alias.scope !748, !noundef !41
  %16 = icmp eq i64 %15, 2, !dbg !745
  br i1 %16, label %bb3.i, label %bb2.i6.i, !dbg !745

bb2.i6.i:                                         ; preds = %bb4.i
; invoke core::ptr::drop_glue::<tokio::process::imp::ChildStdout>
  invoke fastcc void @_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtNtCs3EIJ1qnJmKW_5tokio7process3imp11ChildStdoutECshxBJAVx362N_11runtime_lab(ptr noalias nofree noundef nonnull align 8 dereferenceable(32) %14)
          to label %bb3.i unwind label %terminate.i, !dbg !751

cleanup1.i:                                       ; preds = %bb8.i
  %17 = landingpad { ptr, i32 }
          cleanup
  br label %bb4.i

bb7.i:                                            ; preds = %bb8.i
  %18 = getelementptr inbounds nuw i8, ptr %_1, i64 32, !dbg !668
  %19 = load i64, ptr %18, align 8, !dbg !754, !range !312, !alias.scope !756, !noundef !41
  %20 = icmp eq i64 %19, 2, !dbg !754
  br i1 %20, label %bb6.i, label %bb2.i8.i, !dbg !754

bb2.i8.i:                                         ; preds = %bb7.i
; invoke core::ptr::drop_glue::<tokio::process::imp::ChildStdout>
  invoke fastcc void @_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtNtCs3EIJ1qnJmKW_5tokio7process3imp11ChildStdoutECshxBJAVx362N_11runtime_lab(ptr noalias nofree noundef nonnull align 8 dereferenceable(32) %18)
          to label %bb6.i unwind label %cleanup2.i, !dbg !759

bb3.i:                                            ; preds = %cleanup2.i, %bb2.i6.i, %bb4.i
  %.pn4.i = phi { ptr, i32 } [ %24, %cleanup2.i ], [ %.pn.i, %bb2.i6.i ], [ %.pn.i, %bb4.i ]
  %21 = getelementptr inbounds nuw i8, ptr %_1, i64 64, !dbg !668
  %22 = load i64, ptr %21, align 8, !dbg !761, !range !312, !alias.scope !764, !noundef !41
  %23 = icmp eq i64 %22, 2, !dbg !761
  br i1 %23, label %bb2.i, label %bb2.i11.i, !dbg !761

bb2.i11.i:                                        ; preds = %bb3.i
; invoke core::ptr::drop_glue::<tokio::process::imp::ChildStdout>
  invoke fastcc void @_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtNtCs3EIJ1qnJmKW_5tokio7process3imp11ChildStdoutECshxBJAVx362N_11runtime_lab(ptr noalias nofree noundef nonnull align 8 dereferenceable(32) %21)
          to label %bb2.i unwind label %terminate.i, !dbg !767

cleanup2.i:                                       ; preds = %bb2.i8.i
  %24 = landingpad { ptr, i32 }
          cleanup
  br label %bb3.i

bb6.i:                                            ; preds = %bb2.i8.i, %bb7.i
  %25 = getelementptr inbounds nuw i8, ptr %_1, i64 64, !dbg !668
  %26 = load i64, ptr %25, align 8, !dbg !770, !range !312, !alias.scope !772, !noundef !41
  %27 = icmp eq i64 %26, 2, !dbg !770
  br i1 %27, label %bb1, label %bb2.i13.i, !dbg !770

bb2.i13.i:                                        ; preds = %bb6.i
; call core::ptr::drop_glue::<tokio::process::imp::ChildStdout>
  call fastcc void @_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtNtCs3EIJ1qnJmKW_5tokio7process3imp11ChildStdoutECshxBJAVx362N_11runtime_lab(ptr noalias nofree noundef nonnull align 8 dereferenceable(32) %25), !dbg !775
  br label %bb1, !dbg !770

terminate.i:                                      ; preds = %bb2.i11.i, %bb2.i6.i, %cleanup.body.i
  %28 = landingpad { ptr, i32 }
          filter [0 x ptr] zeroinitializer
; call core::panicking::panic_in_cleanup
  call void @_RNvNtCsjIpoRzUjyHQ_4core9panicking16panic_in_cleanup() #22, !dbg !668
  unreachable, !dbg !668

bb2.i:                                            ; preds = %bb2.i11.i, %bb3.i
  resume { ptr, i32 } %.pn4.i, !dbg !668

bb3:                                              ; preds = %start
  %29 = getelementptr inbounds nuw i8, ptr %_1, i64 8, !dbg !663
  %.val = load ptr, ptr %29, align 8, !dbg !663, !nonnull !41, !noundef !41
  call void @llvm.lifetime.start.p0(ptr nonnull %_2.i.i.i), !dbg !777
  %bits.i.i.i.i = ptrtoint ptr %.val to i64, !dbg !781
  %_5.i.i.i.i = and i64 %bits.i.i.i.i, 3, !dbg !784
  switch i64 %_5.i.i.i.i, label %default.unreachable [
    i64 2, label %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtNtB4_2io5error5ErrorECshxBJAVx362N_11runtime_lab.exit
    i64 3, label %bb4.i.i.i.i
    i64 0, label %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtNtB4_2io5error5ErrorECshxBJAVx362N_11runtime_lab.exit
    i64 1, label %bb2.i1.i.i.i
  ], !dbg !785, !prof !577

bb4.i.i.i.i:                                      ; preds = %bb3
  %30 = icmp ult ptr %.val, inttoptr (i64 188978561024 to ptr), !dbg !786
  %31 = and i64 %bits.i.i.i.i, 1095216660480, !dbg !788
  %32 = icmp ne i64 %31, 1095216660480, !dbg !788
  tail call void @llvm.assume(i1 %30), !dbg !790
  tail call void @llvm.assume(i1 %32), !dbg !790
  br label %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtNtB4_2io5error5ErrorECshxBJAVx362N_11runtime_lab.exit, !dbg !791

bb2.i1.i.i.i:                                     ; preds = %bb3
  %_33.i.i.i.i = getelementptr i8, ptr %.val, i64 -1, !dbg !792
  call void @llvm.assume(i1 true) [ "nonnull"(ptr %_33.i.i.i.i) ], !dbg !796
  %33 = getelementptr inbounds nuw i8, ptr %_2.i.i.i, i64 8, !dbg !799
  store ptr %_33.i.i.i.i, ptr %33, align 8, !dbg !799, !alias.scope !800
  store i8 3, ptr %_2.i.i.i, align 8, !dbg !803, !alias.scope !800
; call <core::io::error::CustomOwner as core::ops::drop::Drop>::drop
  call void @_RNvXsd_NtNtCsjIpoRzUjyHQ_4core2io5errorNtB5_11CustomOwnerNtNtNtB9_3ops4drop4Drop4drop(ptr noalias nofree noundef nonnull align 8 dereferenceable(8) %33), !dbg !804
  br label %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtNtB4_2io5error5ErrorECshxBJAVx362N_11runtime_lab.exit, !dbg !807

_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtNtB4_2io5error5ErrorECshxBJAVx362N_11runtime_lab.exit: ; preds = %bb3, %bb3, %bb4.i.i.i.i, %bb2.i1.i.i.i
  call void @llvm.lifetime.end.p0(ptr nonnull %_2.i.i.i), !dbg !808
  br label %bb1, !dbg !663

bb1:                                              ; preds = %bb2.i13.i, %bb6.i, %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtNtB4_2io5error5ErrorECshxBJAVx362N_11runtime_lab.exit
  ret void, !dbg !663
}

; core::ptr::drop_glue::<std::sync::poison::PoisonError<std::sync::poison::mutex::MutexGuard<runtime_lab::process::Capture>>>
; Function Attrs: uwtable
define internal fastcc void @_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtCs1SSuMAdGM58_3std4sync6poison11PoisonErrorINtNtBE_5mutex10MutexGuardNtNtCshxBJAVx362N_11runtime_lab7process7CaptureEEEB1T_(ptr nofree captures(none) %_1.0.val, i8 %_1.8.val) unnamed_addr #2 !dbg !809 !guid !810 {
start:
  call void @llvm.assume(i1 true) [ "nonnull"(ptr %_1.0.val) ]
  %_3.i.i = getelementptr inbounds nuw i8, ptr %_1.0.val, i64 8, !dbg !811
  %_3.i.i.i = trunc nuw i8 %_1.8.val to i1, !dbg !816
  br i1 %_3.i.i.i, label %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtNtCs1SSuMAdGM58_3std4sync6poison5mutex10MutexGuardNtNtCshxBJAVx362N_11runtime_lab7process7CaptureEEB1A_.exit, label %bb1.i.i.i, !dbg !816

bb1.i.i.i:                                        ; preds = %start
  %0 = load atomic i64, ptr @_RNvNtNtCs1SSuMAdGM58_3std9panicking11panic_count18GLOBAL_PANIC_COUNT monotonic, align 8, !dbg !818
  %_7.i.i.i = and i64 %0, 9223372036854775807, !dbg !824
  %1 = icmp eq i64 %_7.i.i.i, 0, !dbg !824
  br i1 %1, label %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtNtCs1SSuMAdGM58_3std4sync6poison5mutex10MutexGuardNtNtCshxBJAVx362N_11runtime_lab7process7CaptureEEB1A_.exit, label %bb6.i.i.i, !dbg !824, !prof !74

bb6.i.i.i:                                        ; preds = %bb1.i.i.i
; call std::panicking::panic_count::is_zero_slow_path
  %_6.i.i.i = tail call noundef zeroext i1 @_RNvNtNtCs1SSuMAdGM58_3std9panicking11panic_count17is_zero_slow_path() #24, !dbg !825
  br i1 %_6.i.i.i, label %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtNtCs1SSuMAdGM58_3std4sync6poison5mutex10MutexGuardNtNtCshxBJAVx362N_11runtime_lab7process7CaptureEEB1A_.exit, label %bb2.i.i.i, !dbg !826

bb2.i.i.i:                                        ; preds = %bb6.i.i.i
  store atomic i8 1, ptr %_3.i.i monotonic, align 1, !dbg !827
  br label %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtNtCs1SSuMAdGM58_3std4sync6poison5mutex10MutexGuardNtNtCshxBJAVx362N_11runtime_lab7process7CaptureEEB1A_.exit, !dbg !830

_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtNtCs1SSuMAdGM58_3std4sync6poison5mutex10MutexGuardNtNtCshxBJAVx362N_11runtime_lab7process7CaptureEEB1A_.exit: ; preds = %start, %bb1.i.i.i, %bb6.i.i.i, %bb2.i.i.i
  %2 = load atomic ptr, ptr %_1.0.val monotonic, align 8, !dbg !831
; call <std::sys::pal::unix::sync::mutex::Mutex>::unlock
  tail call void @_RNvMNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutexNtB2_5Mutex6unlock(ptr noundef nonnull align 8 %2), !dbg !839
  ret void, !dbg !840
}

; core::ptr::drop_glue::<std::sys::sync::once_box::OnceBox<std::sys::pal::unix::sync::mutex::Mutex>>
; Function Attrs: uwtable
define internal fastcc void @_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtNtCs1SSuMAdGM58_3std3sys4sync8once_box7OnceBoxNtNtNtNtNtBI_3pal4unix4sync5mutex5MutexEECshxBJAVx362N_11runtime_lab(ptr noalias nofree noundef nonnull align 8 captures(none) dereferenceable(8) %_1) unnamed_addr #2 personality ptr @rust_eh_personality !dbg !841 !guid !842 {
start:
  tail call void @llvm.experimental.noalias.scope.decl(metadata !843), !dbg !846
  %ptr.i = load ptr, ptr %_1, align 8, !dbg !847, !alias.scope !843, !noundef !41
  store ptr null, ptr %_1, align 8, !dbg !855, !alias.scope !843
  %_5.i = icmp eq ptr %ptr.i, null, !dbg !857
  br i1 %_5.i, label %_RNvXs1_NtNtNtCs1SSuMAdGM58_3std3sys4sync8once_boxINtB5_7OnceBoxNtNtNtNtNtB9_3pal4unix4sync5mutex5MutexENtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4dropCshxBJAVx362N_11runtime_lab.exit, label %bb2.i.i, !dbg !868

bb2.i.i:                                          ; preds = %start
; invoke <std::sys::pal::unix::sync::mutex::Mutex as core::ops::drop::Drop>::drop
  invoke void @_RNvXs2_NtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutexNtB5_5MutexNtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4drop(ptr noundef nonnull align 8 %ptr.i)
          to label %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtB4_3pin3PinINtNtCs6zY7rJBZy9D_5alloc5boxed3BoxNtNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutex5MutexEEECshxBJAVx362N_11runtime_lab.exit.i.i unwind label %bb2.i.i.i.i, !dbg !871, !noalias !843

bb2.i.i.i.i:                                      ; preds = %bb2.i.i
  %0 = landingpad { ptr, i32 }
          cleanup
; call __rustc::__rust_dealloc
  tail call void @_RNvCsdtSMxSA38aw_7___rustc14___rust_dealloc(ptr noundef nonnull %ptr.i, i64 noundef 64, i64 noundef 8) #20, !dbg !875, !noalias !843
  resume { ptr, i32 } %0, !dbg !881

_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtB4_3pin3PinINtNtCs6zY7rJBZy9D_5alloc5boxed3BoxNtNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutex5MutexEEECshxBJAVx362N_11runtime_lab.exit.i.i: ; preds = %bb2.i.i
; call __rustc::__rust_dealloc
  tail call void @_RNvCsdtSMxSA38aw_7___rustc14___rust_dealloc(ptr noundef nonnull %ptr.i, i64 noundef 64, i64 noundef 8) #20, !dbg !882, !noalias !843
  br label %_RNvXs1_NtNtNtCs1SSuMAdGM58_3std3sys4sync8once_boxINtB5_7OnceBoxNtNtNtNtNtB9_3pal4unix4sync5mutex5MutexENtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4dropCshxBJAVx362N_11runtime_lab.exit, !dbg !868

_RNvXs1_NtNtNtCs1SSuMAdGM58_3std3sys4sync8once_boxINtB5_7OnceBoxNtNtNtNtNtB9_3pal4unix4sync5mutex5MutexENtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4dropCshxBJAVx362N_11runtime_lab.exit: ; preds = %start, %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtB4_3pin3PinINtNtCs6zY7rJBZy9D_5alloc5boxed3BoxNtNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutex5MutexEEECshxBJAVx362N_11runtime_lab.exit.i.i
  ret void, !dbg !846
}

; core::ptr::drop_glue::<tokio::signal::unix::Signal>
; Function Attrs: uwtable
define internal fastcc void @_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtNtCs3EIJ1qnJmKW_5tokio6signal4unix6SignalECshxBJAVx362N_11runtime_lab(ptr %_1.0.val, ptr nofree readonly captures(none) %_1.8.val) unnamed_addr #2 personality ptr @rust_eh_personality !dbg !888 !guid !889 {
start:
  call void @llvm.assume(i1 true) [ "nonnull"(ptr %_1.0.val) ]
  call void @llvm.assume(i1 true) [ "nonnull"(ptr %_1.8.val) ]
  %0 = load ptr, ptr %_1.8.val, align 8, !dbg !890, !invariant.load !41
  %.not.i.i.i.i = icmp eq ptr %0, null, !dbg !890
  br i1 %.not.i.i.i.i, label %bb3.i.i.i.i, label %is_not_null.i.i.i.i, !dbg !890

is_not_null.i.i.i.i:                              ; preds = %start
  invoke void %0(ptr noundef nonnull %_1.0.val)
          to label %bb3.i.i.i.i unwind label %cleanup.i.i.i.i, !dbg !890

bb3.i.i.i.i:                                      ; preds = %is_not_null.i.i.i.i, %start
  %1 = getelementptr inbounds nuw i8, ptr %_1.8.val, i64 8, !dbg !905
  %size.i.i.i.i.i = load i64, ptr %1, align 8, !dbg !905, !range !917, !invariant.load !41
  %2 = icmp eq i64 %size.i.i.i.i.i, 0, !dbg !918
  br i1 %2, label %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtCs3EIJ1qnJmKW_5tokio6signal8RxFutureECshxBJAVx362N_11runtime_lab.exit, label %_RNvXs1_NtCs6zY7rJBZy9D_5alloc5allocNtB5_6GlobalNtNtCsjIpoRzUjyHQ_4core5alloc9Allocator10deallocate.exit.i.i.i.i.i, !dbg !918

_RNvXs1_NtCs6zY7rJBZy9D_5alloc5allocNtB5_6GlobalNtNtCsjIpoRzUjyHQ_4core5alloc9Allocator10deallocate.exit.i.i.i.i.i: ; preds = %bb3.i.i.i.i
  %3 = getelementptr inbounds nuw i8, ptr %_1.8.val, i64 16, !dbg !905
  %align.i.i.i.i.i = load i64, ptr %3, align 8, !dbg !920, !range !928, !invariant.load !41
; call __rustc::__rust_dealloc
  tail call void @_RNvCsdtSMxSA38aw_7___rustc14___rust_dealloc(ptr noundef nonnull %_1.0.val, i64 noundef %size.i.i.i.i.i, i64 noundef range(i64 1, -9223372036854775807) %align.i.i.i.i.i) #20, !dbg !929
  br label %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtCs3EIJ1qnJmKW_5tokio6signal8RxFutureECshxBJAVx362N_11runtime_lab.exit, !dbg !934

cleanup.i.i.i.i:                                  ; preds = %is_not_null.i.i.i.i
  %4 = landingpad { ptr, i32 }
          cleanup
  %5 = getelementptr inbounds nuw i8, ptr %_1.8.val, i64 8, !dbg !935
  %size.i4.i.i.i.i = load i64, ptr %5, align 8, !dbg !935, !range !917, !invariant.load !41
  %6 = icmp eq i64 %size.i4.i.i.i.i, 0, !dbg !939
  br i1 %6, label %bb2.i.i.i.i, label %_RNvXs1_NtCs6zY7rJBZy9D_5alloc5allocNtB5_6GlobalNtNtCsjIpoRzUjyHQ_4core5alloc9Allocator10deallocate.exit.i5.i.i.i.i, !dbg !939

_RNvXs1_NtCs6zY7rJBZy9D_5alloc5allocNtB5_6GlobalNtNtCsjIpoRzUjyHQ_4core5alloc9Allocator10deallocate.exit.i5.i.i.i.i: ; preds = %cleanup.i.i.i.i
  %7 = getelementptr inbounds nuw i8, ptr %_1.8.val, i64 16, !dbg !935
  %align.i6.i.i.i.i = load i64, ptr %7, align 8, !dbg !940, !range !928, !invariant.load !41
; call __rustc::__rust_dealloc
  tail call void @_RNvCsdtSMxSA38aw_7___rustc14___rust_dealloc(ptr noundef nonnull %_1.0.val, i64 noundef %size.i4.i.i.i.i, i64 noundef range(i64 1, -9223372036854775807) %align.i6.i.i.i.i) #20, !dbg !943
  br label %bb2.i.i.i.i, !dbg !948

bb2.i.i.i.i:                                      ; preds = %_RNvXs1_NtCs6zY7rJBZy9D_5alloc5allocNtB5_6GlobalNtNtCsjIpoRzUjyHQ_4core5alloc9Allocator10deallocate.exit.i5.i.i.i.i, %cleanup.i.i.i.i
  resume { ptr, i32 } %4, !dbg !890

_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtCs3EIJ1qnJmKW_5tokio6signal8RxFutureECshxBJAVx362N_11runtime_lab.exit: ; preds = %bb3.i.i.i.i, %_RNvXs1_NtCs6zY7rJBZy9D_5alloc5allocNtB5_6GlobalNtNtCsjIpoRzUjyHQ_4core5alloc9Allocator10deallocate.exit.i.i.i.i.i
  ret void, !dbg !949
}

; core::ptr::drop_glue::<tokio::process::imp::ChildStdout>
; Function Attrs: uwtable
define internal fastcc void @_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtNtCs3EIJ1qnJmKW_5tokio7process3imp11ChildStdoutECshxBJAVx362N_11runtime_lab(ptr noalias nofree noundef nonnull align 8 dereferenceable(32) %_1) unnamed_addr #2 personality ptr @rust_eh_personality !dbg !950 !guid !951 {
start:
  %_2.i.i.i.i.i.i = alloca [16 x i8], align 8
  %io.i.i = alloca [4 x i8], align 4
  tail call void @llvm.experimental.noalias.scope.decl(metadata !952), !dbg !955
  tail call void @llvm.experimental.noalias.scope.decl(metadata !956), !dbg !959
  %0 = getelementptr inbounds nuw i8, ptr %_1, i64 24, !dbg !962
  %1 = load i32, ptr %0, align 8, !dbg !962, !alias.scope !970, !noundef !41
  store i32 -1, ptr %0, align 8, !dbg !971, !alias.scope !970
  %.not.i.i = icmp eq i32 %1, -1, !dbg !973
  br i1 %.not.i.i, label %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtCs3EIJ1qnJmKW_5tokio2io12poll_evented11PollEventedNtNtNtNtCsiDZg47dpzEY_3mio3sys4unix4pipe8ReceiverEECshxBJAVx362N_11runtime_lab.exit, label %bb1.i.i, !dbg !974

bb1.i.i:                                          ; preds = %start
  call void @llvm.lifetime.start.p0(ptr nonnull %io.i.i), !dbg !975, !noalias !970
  store i32 %1, ptr %io.i.i, align 4, !dbg !975, !noalias !970
; invoke <tokio::runtime::io::registration::Registration>::handle
  %_8.i.i = invoke noundef nonnull align 8 ptr @_RNvMs0_NtNtNtCs3EIJ1qnJmKW_5tokio7runtime2io12registrationNtB5_12Registration6handle(ptr noalias nofree noundef nonnull readonly align 8 captures(address, read_provenance) dereferenceable(32) %_1)
          to label %bb7.i.i unwind label %cleanup.i.i, !dbg !976

cleanup.i.i:                                      ; preds = %bb2.i1.i.i.i.i.i.i, %.noexc9.i.i, %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtNtCs1SSuMAdGM58_3std4sync6poison5mutex10MutexGuardNtNtNtNtCs3EIJ1qnJmKW_5tokio7runtime2io16registration_set6SyncedEECshxBJAVx362N_11runtime_lab.exit13.i.i.i, %bb6.i.i.i10.i.i.i, %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtNtCs1SSuMAdGM58_3std4sync6poison5mutex10MutexGuardNtNtNtNtCs3EIJ1qnJmKW_5tokio7runtime2io16registration_set6SyncedEECshxBJAVx362N_11runtime_lab.exit.i.i.i, %bb6.i.i.i.i.i.i, %bb6.i.i.i.i.i, %_RINvMNtNtNtCs1SSuMAdGM58_3std3sys4sync8once_boxINtB3_7OnceBoxNtNtNtNtNtB7_3pal4unix4sync5mutex5MutexE11get_or_initNCNvMNtNtB5_5mutex7pthreadNtB1T_5Mutex3get0ECshxBJAVx362N_11runtime_lab.exit.i.i.i.i, %bb7.i.i.i.i.i, %bb7.i.i, %bb1.i.i
  %2 = landingpad { ptr, i32 }
          cleanup
  br label %bb6.i.i, !dbg !979

bb7.i.i:                                          ; preds = %bb1.i.i
  %_10.i.i = getelementptr inbounds nuw i8, ptr %_1, i64 16, !dbg !980
  %_6.i.i.i = getelementptr inbounds nuw i8, ptr %_8.i.i, i64 88, !dbg !981
; invoke <mio::sys::unix::pipe::Receiver as mio::event::source::Source>::deregister
  %3 = invoke noundef ptr @_RNvXsa_NtNtNtCsiDZg47dpzEY_3mio3sys4unix4pipeNtB5_8ReceiverNtNtNtBb_5event6source6Source10deregister(ptr noalias nofree noundef nonnull align 4 dereferenceable(4) %io.i.i, ptr noalias nofree noundef nonnull readonly align 4 captures(address, read_provenance) dereferenceable(4) %_6.i.i.i)
          to label %.noexc.i.i unwind label %cleanup.i.i, !dbg !984

.noexc.i.i:                                       ; preds = %bb7.i.i
  %.not.i.i.i = icmp eq ptr %3, null, !dbg !987
  br i1 %.not.i.i.i, label %bb13.i.i.i, label %bb2.i11.i.i, !dbg !990

bb13.i.i.i:                                       ; preds = %.noexc.i.i
  %_9.i.i.i = getelementptr inbounds nuw i8, ptr %_8.i.i, i64 64, !dbg !991
  %4 = load atomic ptr, ptr %_8.i.i acquire, align 8, !dbg !992, !noalias !1001
  %_11.i.i.i.i.i = icmp eq ptr %4, null, !dbg !1007
  br i1 %_11.i.i.i.i.i, label %bb7.i.i.i.i.i, label %_RINvMNtNtNtCs1SSuMAdGM58_3std3sys4sync8once_boxINtB3_7OnceBoxNtNtNtNtNtB7_3pal4unix4sync5mutex5MutexE11get_or_initNCNvMNtNtB5_5mutex7pthreadNtB1T_5Mutex3get0ECshxBJAVx362N_11runtime_lab.exit.i.i.i.i, !dbg !1012, !prof !135

bb7.i.i.i.i.i:                                    ; preds = %bb13.i.i.i
; invoke <std::sys::sync::once_box::OnceBox<std::sys::pal::unix::sync::mutex::Mutex>>::initialize::<<std::sys::sync::mutex::pthread::Mutex>::get::{closure#0}>
  %5 = invoke fastcc noundef nonnull align 8 ptr @_RINvMNtNtNtCs1SSuMAdGM58_3std3sys4sync8once_boxINtB3_7OnceBoxNtNtNtNtNtB7_3pal4unix4sync5mutex5MutexE10initializeNCNvMNtNtB5_5mutex7pthreadNtB1S_5Mutex3get0ECshxBJAVx362N_11runtime_lab(ptr noundef nonnull align 8 %_8.i.i)
          to label %_RINvMNtNtNtCs1SSuMAdGM58_3std3sys4sync8once_boxINtB3_7OnceBoxNtNtNtNtNtB7_3pal4unix4sync5mutex5MutexE11get_or_initNCNvMNtNtB5_5mutex7pthreadNtB1T_5Mutex3get0ECshxBJAVx362N_11runtime_lab.exit.i.i.i.i unwind label %cleanup.i.i, !dbg !1013

_RINvMNtNtNtCs1SSuMAdGM58_3std3sys4sync8once_boxINtB3_7OnceBoxNtNtNtNtNtB7_3pal4unix4sync5mutex5MutexE11get_or_initNCNvMNtNtB5_5mutex7pthreadNtB1T_5Mutex3get0ECshxBJAVx362N_11runtime_lab.exit.i.i.i.i: ; preds = %bb7.i.i.i.i.i, %bb13.i.i.i
  %_0.sroa.0.0.i.i.i.i.i = phi ptr [ %4, %bb13.i.i.i ], [ %5, %bb7.i.i.i.i.i ], !dbg !1014
; invoke <std::sys::pal::unix::sync::mutex::Mutex>::lock
  invoke void @_RNvMNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutexNtB2_5Mutex4lock(ptr noundef nonnull align 8 %_0.sroa.0.0.i.i.i.i.i)
          to label %.noexc4.i.i unwind label %cleanup.i.i, !dbg !1015

.noexc4.i.i:                                      ; preds = %_RINvMNtNtNtCs1SSuMAdGM58_3std3sys4sync8once_boxINtB3_7OnceBoxNtNtNtNtNtB7_3pal4unix4sync5mutex5MutexE11get_or_initNCNvMNtNtB5_5mutex7pthreadNtB1T_5Mutex3get0ECshxBJAVx362N_11runtime_lab.exit.i.i.i.i
  %6 = load atomic i64, ptr @_RNvNtNtCs1SSuMAdGM58_3std9panicking11panic_count18GLOBAL_PANIC_COUNT monotonic, align 8, !dbg !1016, !noalias !1024
  %_7.i.i.i.i.i = and i64 %6, 9223372036854775807, !dbg !1025
  %7 = icmp eq i64 %_7.i.i.i.i.i, 0, !dbg !1025
  br i1 %7, label %_RNvMs5_NtNtNtCs1SSuMAdGM58_3std4sync6poison5mutexINtB5_5MutexNtNtNtNtCs3EIJ1qnJmKW_5tokio7runtime2io16registration_set6SyncedE4lockCshxBJAVx362N_11runtime_lab.exit.i.i.i, label %bb6.i.i.i.i.i, !dbg !1025, !prof !74

bb6.i.i.i.i.i:                                    ; preds = %.noexc4.i.i
; invoke std::panicking::panic_count::is_zero_slow_path
  %8 = invoke noundef zeroext i1 @_RNvNtNtCs1SSuMAdGM58_3std9panicking11panic_count17is_zero_slow_path() #24
          to label %.noexc5.i.i unwind label %cleanup.i.i, !dbg !1026

.noexc5.i.i:                                      ; preds = %bb6.i.i.i.i.i
  %9 = xor i1 %8, true, !dbg !1027
  br label %_RNvMs5_NtNtNtCs1SSuMAdGM58_3std4sync6poison5mutexINtB5_5MutexNtNtNtNtCs3EIJ1qnJmKW_5tokio7runtime2io16registration_set6SyncedE4lockCshxBJAVx362N_11runtime_lab.exit.i.i.i, !dbg !1026

_RNvMs5_NtNtNtCs1SSuMAdGM58_3std4sync6poison5mutexINtB5_5MutexNtNtNtNtCs3EIJ1qnJmKW_5tokio7runtime2io16registration_set6SyncedE4lockCshxBJAVx362N_11runtime_lab.exit.i.i.i: ; preds = %.noexc5.i.i, %.noexc4.i.i
  %_6.sroa.0.0.off0.i.i.i.i.i = phi i1 [ %9, %.noexc5.i.i ], [ false, %.noexc4.i.i ]
  %_7.i.i.i.i = getelementptr inbounds nuw i8, ptr %_8.i.i, i64 8, !dbg !1028
  %10 = load atomic i8, ptr %_7.i.i.i.i monotonic, align 8, !dbg !1029, !noalias !1001
  %_24.i.i.i = getelementptr inbounds nuw i8, ptr %_8.i.i, i64 16, !dbg !1033
; invoke <tokio::runtime::io::registration_set::RegistrationSet>::deregister
  %_8.i.i.i = invoke noundef zeroext i1 @_RNvMNtNtNtCs3EIJ1qnJmKW_5tokio7runtime2io16registration_setNtB2_15RegistrationSet10deregister(ptr noundef nonnull align 8 %_9.i.i.i, ptr noalias nofree noundef nonnull align 8 dereferenceable(48) %_24.i.i.i, ptr noalias nofree noundef nonnull readonly align 8 captures(address, read_provenance) dereferenceable(8) %_10.i.i)
          to label %bb2.i.i.i unwind label %cleanup.i.i.i, !dbg !1038

cleanup.i.i.i:                                    ; preds = %_RNvMs5_NtNtNtCs1SSuMAdGM58_3std4sync6poison5mutexINtB5_5MutexNtNtNtNtCs3EIJ1qnJmKW_5tokio7runtime2io16registration_set6SyncedE4lockCshxBJAVx362N_11runtime_lab.exit.i.i.i
  %11 = landingpad { ptr, i32 }
          cleanup
  %_0.sroa.3.0.i.i.i.i.i = zext i1 %_6.sroa.0.0.off0.i.i.i.i.i to i8, !dbg !1039
; invoke core::ptr::drop_glue::<std::sync::poison::PoisonError<std::sync::poison::mutex::MutexGuard<runtime_lab::process::Capture>>>
  invoke fastcc void @_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtCs1SSuMAdGM58_3std4sync6poison11PoisonErrorINtNtBE_5mutex10MutexGuardNtNtCshxBJAVx362N_11runtime_lab7process7CaptureEEEB1T_(ptr nonnull align 8 %_8.i.i, i8 %_0.sroa.3.0.i.i.i.i.i) #23
          to label %bb6.i.i unwind label %terminate.i.i.i, !dbg !1040

bb2.i.i.i:                                        ; preds = %_RNvMs5_NtNtNtCs1SSuMAdGM58_3std4sync6poison5mutexINtB5_5MutexNtNtNtNtCs3EIJ1qnJmKW_5tokio7runtime2io16registration_set6SyncedE4lockCshxBJAVx362N_11runtime_lab.exit.i.i.i
  br i1 %_8.i.i.i, label %bb3.i.i.i, label %bb5.i.i.i, !dbg !991

bb5.i.i.i:                                        ; preds = %bb2.i.i.i
  br i1 %_6.sroa.0.0.off0.i.i.i.i.i, label %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtNtCs1SSuMAdGM58_3std4sync6poison5mutex10MutexGuardNtNtNtNtCs3EIJ1qnJmKW_5tokio7runtime2io16registration_set6SyncedEECshxBJAVx362N_11runtime_lab.exit.i.i.i, label %bb1.i.i.i.i.i.i, !dbg !1041

bb1.i.i.i.i.i.i:                                  ; preds = %bb5.i.i.i
  %12 = load atomic i64, ptr @_RNvNtNtCs1SSuMAdGM58_3std9panicking11panic_count18GLOBAL_PANIC_COUNT monotonic, align 8, !dbg !1045, !noalias !1051
  %_7.i.i.i.i.i.i = and i64 %12, 9223372036854775807, !dbg !1052
  %13 = icmp eq i64 %_7.i.i.i.i.i.i, 0, !dbg !1052
  br i1 %13, label %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtNtCs1SSuMAdGM58_3std4sync6poison5mutex10MutexGuardNtNtNtNtCs3EIJ1qnJmKW_5tokio7runtime2io16registration_set6SyncedEECshxBJAVx362N_11runtime_lab.exit.i.i.i, label %bb6.i.i.i.i.i.i, !dbg !1052, !prof !74

bb6.i.i.i.i.i.i:                                  ; preds = %bb1.i.i.i.i.i.i
; invoke std::panicking::panic_count::is_zero_slow_path
  %_6.i.i.i.i6.i.i = invoke noundef zeroext i1 @_RNvNtNtCs1SSuMAdGM58_3std9panicking11panic_count17is_zero_slow_path() #24
          to label %_6.i.i.i.i.noexc.i.i unwind label %cleanup.i.i, !dbg !1053

_6.i.i.i.i.noexc.i.i:                             ; preds = %bb6.i.i.i.i.i.i
  br i1 %_6.i.i.i.i6.i.i, label %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtNtCs1SSuMAdGM58_3std4sync6poison5mutex10MutexGuardNtNtNtNtCs3EIJ1qnJmKW_5tokio7runtime2io16registration_set6SyncedEECshxBJAVx362N_11runtime_lab.exit.i.i.i, label %bb2.i.i.i.i.i.i, !dbg !1054

bb2.i.i.i.i.i.i:                                  ; preds = %_6.i.i.i.i.noexc.i.i
  store atomic i8 1, ptr %_7.i.i.i.i monotonic, align 8, !dbg !1055, !noalias !1058
  br label %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtNtCs1SSuMAdGM58_3std4sync6poison5mutex10MutexGuardNtNtNtNtCs3EIJ1qnJmKW_5tokio7runtime2io16registration_set6SyncedEECshxBJAVx362N_11runtime_lab.exit.i.i.i, !dbg !1059

_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtNtCs1SSuMAdGM58_3std4sync6poison5mutex10MutexGuardNtNtNtNtCs3EIJ1qnJmKW_5tokio7runtime2io16registration_set6SyncedEECshxBJAVx362N_11runtime_lab.exit.i.i.i: ; preds = %bb2.i.i.i.i.i.i, %_6.i.i.i.i.noexc.i.i, %bb1.i.i.i.i.i.i, %bb5.i.i.i
  %14 = load atomic ptr, ptr %_8.i.i monotonic, align 8, !dbg !1060, !noalias !1058
; invoke <std::sys::pal::unix::sync::mutex::Mutex>::unlock
  invoke void @_RNvMNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutexNtB2_5Mutex6unlock(ptr noundef nonnull align 8 %14)
          to label %bb6.i unwind label %cleanup.i.i, !dbg !1065

bb3.i.i.i:                                        ; preds = %bb2.i.i.i
  br i1 %_6.sroa.0.0.off0.i.i.i.i.i, label %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtNtCs1SSuMAdGM58_3std4sync6poison5mutex10MutexGuardNtNtNtNtCs3EIJ1qnJmKW_5tokio7runtime2io16registration_set6SyncedEECshxBJAVx362N_11runtime_lab.exit13.i.i.i, label %bb1.i.i.i8.i.i.i, !dbg !1066

bb1.i.i.i8.i.i.i:                                 ; preds = %bb3.i.i.i
  %15 = load atomic i64, ptr @_RNvNtNtCs1SSuMAdGM58_3std9panicking11panic_count18GLOBAL_PANIC_COUNT monotonic, align 8, !dbg !1070, !noalias !1051
  %_7.i.i.i9.i.i.i = and i64 %15, 9223372036854775807, !dbg !1076
  %16 = icmp eq i64 %_7.i.i.i9.i.i.i, 0, !dbg !1076
  br i1 %16, label %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtNtCs1SSuMAdGM58_3std4sync6poison5mutex10MutexGuardNtNtNtNtCs3EIJ1qnJmKW_5tokio7runtime2io16registration_set6SyncedEECshxBJAVx362N_11runtime_lab.exit13.i.i.i, label %bb6.i.i.i10.i.i.i, !dbg !1076, !prof !74

bb6.i.i.i10.i.i.i:                                ; preds = %bb1.i.i.i8.i.i.i
; invoke std::panicking::panic_count::is_zero_slow_path
  %_6.i.i.i11.i8.i.i = invoke noundef zeroext i1 @_RNvNtNtCs1SSuMAdGM58_3std9panicking11panic_count17is_zero_slow_path() #24
          to label %_6.i.i.i11.i.noexc.i.i unwind label %cleanup.i.i, !dbg !1077

_6.i.i.i11.i.noexc.i.i:                           ; preds = %bb6.i.i.i10.i.i.i
  br i1 %_6.i.i.i11.i8.i.i, label %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtNtCs1SSuMAdGM58_3std4sync6poison5mutex10MutexGuardNtNtNtNtCs3EIJ1qnJmKW_5tokio7runtime2io16registration_set6SyncedEECshxBJAVx362N_11runtime_lab.exit13.i.i.i, label %bb2.i.i.i12.i.i.i, !dbg !1078

bb2.i.i.i12.i.i.i:                                ; preds = %_6.i.i.i11.i.noexc.i.i
  store atomic i8 1, ptr %_7.i.i.i.i monotonic, align 8, !dbg !1079, !noalias !1058
  br label %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtNtCs1SSuMAdGM58_3std4sync6poison5mutex10MutexGuardNtNtNtNtCs3EIJ1qnJmKW_5tokio7runtime2io16registration_set6SyncedEECshxBJAVx362N_11runtime_lab.exit13.i.i.i, !dbg !1082

_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtNtCs1SSuMAdGM58_3std4sync6poison5mutex10MutexGuardNtNtNtNtCs3EIJ1qnJmKW_5tokio7runtime2io16registration_set6SyncedEECshxBJAVx362N_11runtime_lab.exit13.i.i.i: ; preds = %bb2.i.i.i12.i.i.i, %_6.i.i.i11.i.noexc.i.i, %bb1.i.i.i8.i.i.i, %bb3.i.i.i
  %17 = load atomic ptr, ptr %_8.i.i monotonic, align 8, !dbg !1083, !noalias !1058
; invoke <std::sys::pal::unix::sync::mutex::Mutex>::unlock
  invoke void @_RNvMNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutexNtB2_5Mutex6unlock(ptr noundef nonnull align 8 %17)
          to label %.noexc9.i.i unwind label %cleanup.i.i, !dbg !1088

.noexc9.i.i:                                      ; preds = %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtNtCs1SSuMAdGM58_3std4sync6poison5mutex10MutexGuardNtNtNtNtCs3EIJ1qnJmKW_5tokio7runtime2io16registration_set6SyncedEECshxBJAVx362N_11runtime_lab.exit13.i.i.i
; invoke <tokio::runtime::io::driver::Handle>::unpark
  invoke void @_RNvMs0_NtNtNtCs3EIJ1qnJmKW_5tokio7runtime2io6driverNtB5_6Handle6unpark(ptr noundef nonnull align 8 %_8.i.i)
          to label %bb6.i unwind label %cleanup.i.i, !dbg !1089

terminate.i.i.i:                                  ; preds = %cleanup.i.i.i
  %18 = landingpad { ptr, i32 }
          filter [0 x ptr] zeroinitializer
; call core::panicking::panic_in_cleanup
  call void @_RNvNtCsjIpoRzUjyHQ_4core9panicking16panic_in_cleanup() #22, !dbg !1090
  unreachable, !dbg !1090

bb2.i11.i.i:                                      ; preds = %.noexc.i.i
  call void @llvm.lifetime.start.p0(ptr nonnull %_2.i.i.i.i.i.i), !dbg !1091, !noalias !970
  %bits.i.i.i.i.i.i.i = ptrtoint ptr %3 to i64, !dbg !1096
  %_5.i.i.i.i.i.i.i = and i64 %bits.i.i.i.i.i.i.i, 3, !dbg !1099
  switch i64 %_5.i.i.i.i.i.i.i, label %default.unreachable [
    i64 2, label %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtNtB4_2io5error5ErrorECshxBJAVx362N_11runtime_lab.exit.i.i.i
    i64 3, label %bb4.i.i.i.i.i.i.i
    i64 0, label %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtNtB4_2io5error5ErrorECshxBJAVx362N_11runtime_lab.exit.i.i.i
    i64 1, label %bb2.i1.i.i.i.i.i.i
  ], !dbg !1100, !prof !577

default.unreachable:                              ; preds = %bb2.i11.i.i
  unreachable

bb4.i.i.i.i.i.i.i:                                ; preds = %bb2.i11.i.i
  %19 = icmp ult ptr %3, inttoptr (i64 188978561024 to ptr), !dbg !1101
  %20 = and i64 %bits.i.i.i.i.i.i.i, 1095216660480, !dbg !1103
  %21 = icmp ne i64 %20, 1095216660480, !dbg !1103
  call void @llvm.assume(i1 %19), !dbg !1105
  call void @llvm.assume(i1 %21), !dbg !1105
  br label %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtNtB4_2io5error5ErrorECshxBJAVx362N_11runtime_lab.exit.i.i.i, !dbg !1106

bb2.i1.i.i.i.i.i.i:                               ; preds = %bb2.i11.i.i
  %_33.i.i.i.i.i.i.i = getelementptr i8, ptr %3, i64 -1, !dbg !1107
  call void @llvm.assume(i1 true) [ "nonnull"(ptr %_33.i.i.i.i.i.i.i) ], !dbg !1111
  %22 = getelementptr inbounds nuw i8, ptr %_2.i.i.i.i.i.i, i64 8, !dbg !1114
  store ptr %_33.i.i.i.i.i.i.i, ptr %22, align 8, !dbg !1114, !alias.scope !1115, !noalias !970
  store i8 3, ptr %_2.i.i.i.i.i.i, align 8, !dbg !1118, !alias.scope !1115, !noalias !970
; invoke <core::io::error::CustomOwner as core::ops::drop::Drop>::drop
  invoke void @_RNvXsd_NtNtCsjIpoRzUjyHQ_4core2io5errorNtB5_11CustomOwnerNtNtNtB9_3ops4drop4Drop4drop(ptr noalias nofree noundef nonnull align 8 dereferenceable(8) %22)
          to label %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtNtB4_2io5error5ErrorECshxBJAVx362N_11runtime_lab.exit.i.i.i unwind label %cleanup.i.i, !dbg !1119

_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtNtB4_2io5error5ErrorECshxBJAVx362N_11runtime_lab.exit.i.i.i: ; preds = %bb2.i1.i.i.i.i.i.i, %bb4.i.i.i.i.i.i.i, %bb2.i11.i.i, %bb2.i11.i.i
  call void @llvm.lifetime.end.p0(ptr nonnull %_2.i.i.i.i.i.i), !dbg !1122, !noalias !970
  br label %bb6.i, !dbg !1123

bb6.i.i:                                          ; preds = %cleanup.i.i.i, %cleanup.i.i
  %eh.lpad-body.i.i = phi { ptr, i32 } [ %2, %cleanup.i.i ], [ %11, %cleanup.i.i.i ]
  %io.val.i.i = load i32, ptr %io.i.i, align 4, !dbg !979, !range !618, !noalias !970, !noundef !41
  %_5.i.i.i.i.i.i.i.i.i = call noundef i32 @close(i32 noundef %io.val.i.i) #20, !dbg !1124
  %.val.i = load i32, ptr %0, align 8, !dbg !959, !alias.scope !952, !noundef !41
  %23 = icmp eq i32 %.val.i, -1, !dbg !1133
  br i1 %23, label %bb3.i, label %bb2.i4.i, !dbg !1133

bb2.i4.i:                                         ; preds = %bb6.i.i
  %_5.i.i.i.i.i.i.i.i5.i = call noundef i32 @close(i32 noundef %.val.i) #20, !dbg !1136
  br label %bb3.i, !dbg !1133

bb6.i:                                            ; preds = %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtNtB4_2io5error5ErrorECshxBJAVx362N_11runtime_lab.exit.i.i.i, %.noexc9.i.i, %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtNtCs1SSuMAdGM58_3std4sync6poison5mutex10MutexGuardNtNtNtNtCs3EIJ1qnJmKW_5tokio7runtime2io16registration_set6SyncedEECshxBJAVx362N_11runtime_lab.exit.i.i.i
  %io.val2.i.i = load i32, ptr %io.i.i, align 4, !dbg !979, !range !618, !noalias !970, !noundef !41
  %_5.i.i.i.i.i.i.i13.i.i = call noundef i32 @close(i32 noundef %io.val2.i.i) #20, !dbg !1144
  call void @llvm.lifetime.end.p0(ptr nonnull %io.i.i), !dbg !979, !noalias !970
  %.val3.pr.i = load i32, ptr %0, align 8, !dbg !959, !alias.scope !952
  %24 = icmp eq i32 %.val3.pr.i, -1, !dbg !1152
  br i1 %24, label %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtCs3EIJ1qnJmKW_5tokio2io12poll_evented11PollEventedNtNtNtNtCsiDZg47dpzEY_3mio3sys4unix4pipe8ReceiverEECshxBJAVx362N_11runtime_lab.exit, label %bb2.i7.i, !dbg !1152

bb2.i7.i:                                         ; preds = %bb6.i
  %_5.i.i.i.i.i.i.i.i8.i = call noundef i32 @close(i32 noundef %.val3.pr.i) #20, !dbg !1154
  br label %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtCs3EIJ1qnJmKW_5tokio2io12poll_evented11PollEventedNtNtNtNtCsiDZg47dpzEY_3mio3sys4unix4pipe8ReceiverEECshxBJAVx362N_11runtime_lab.exit, !dbg !1152

bb3.i:                                            ; preds = %bb2.i4.i, %bb6.i.i
; invoke core::ptr::drop_glue::<tokio::runtime::io::registration::Registration>
  invoke fastcc void @_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtNtNtCs3EIJ1qnJmKW_5tokio7runtime2io12registration12RegistrationECshxBJAVx362N_11runtime_lab(ptr noalias nofree noundef nonnull align 8 dereferenceable(32) %_1) #23
          to label %bb2.i unwind label %terminate.i, !dbg !959

terminate.i:                                      ; preds = %bb3.i
  %25 = landingpad { ptr, i32 }
          filter [0 x ptr] zeroinitializer
; call core::panicking::panic_in_cleanup
  call void @_RNvNtCsjIpoRzUjyHQ_4core9panicking16panic_in_cleanup() #22, !dbg !959
  unreachable, !dbg !959

bb2.i:                                            ; preds = %bb3.i
  resume { ptr, i32 } %eh.lpad-body.i.i, !dbg !959

_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtCs3EIJ1qnJmKW_5tokio2io12poll_evented11PollEventedNtNtNtNtCsiDZg47dpzEY_3mio3sys4unix4pipe8ReceiverEECshxBJAVx362N_11runtime_lab.exit: ; preds = %start, %bb6.i, %bb2.i7.i
; call core::ptr::drop_glue::<tokio::runtime::io::registration::Registration>
  call fastcc void @_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtNtNtCs3EIJ1qnJmKW_5tokio7runtime2io12registration12RegistrationECshxBJAVx362N_11runtime_lab(ptr noalias nofree noundef nonnull align 8 dereferenceable(32) %_1), !dbg !959
  ret void, !dbg !955
}

; core::ptr::drop_glue::<tokio::process::imp::Child>
; Function Attrs: uwtable
define internal fastcc void @_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtNtCs3EIJ1qnJmKW_5tokio7process3imp5ChildECshxBJAVx362N_11runtime_lab(ptr noalias nofree noundef nonnull align 8 dereferenceable(40) %_1) unnamed_addr #2 personality ptr @rust_eh_personality !dbg !1162 !guid !1163 {
start:
  %_2.i.i.i.i.i.i = alloca [16 x i8], align 8
  %orphan.i.i = alloca [24 x i8], align 4
  %_2.i.i = alloca [16 x i8], align 8
  tail call void @llvm.experimental.noalias.scope.decl(metadata !1164), !dbg !1167
  tail call void @llvm.experimental.noalias.scope.decl(metadata !1168), !dbg !1171
  call void @llvm.lifetime.start.p0(ptr nonnull %_2.i.i), !dbg !1174, !noalias !1182
  %0 = load i32, ptr %_1, align 8, !dbg !1183, !range !267, !alias.scope !1182, !noundef !41
  %.not.i.i = icmp eq i32 %0, 2, !dbg !1183
  br i1 %.not.i.i, label %bb10.i.i, label %bb11.i.i, !dbg !1189, !prof !135

bb11.i.i:                                         ; preds = %start
; invoke <std::process::Child as tokio::process::imp::orphan::Wait>::try_wait
  invoke void @_RNvXNtNtCs3EIJ1qnJmKW_5tokio7process3impNtNtCs1SSuMAdGM58_3std7process5ChildNtNtB2_6orphan4Wait8try_wait(ptr noalias nofree noundef nonnull sret([16 x i8]) align 8 captures(address) dereferenceable(16) %_2.i.i, ptr noalias nofree noundef nonnull align 8 dereferenceable(40) %_1)
          to label %.noexc.i unwind label %cleanup.i, !dbg !1190

.noexc.i:                                         ; preds = %bb11.i.i
  %1 = load i32, ptr %_2.i.i, align 8, !dbg !1174, !range !1191, !noalias !1182, !noundef !41
  %2 = trunc nuw i32 %1 to i1, !dbg !1192
  %.not3.i.i = xor i1 %2, true, !dbg !1192
  %3 = getelementptr inbounds nuw i8, ptr %_2.i.i, i64 4
  %4 = load i32, ptr %3, align 4, !range !1191, !noalias !1182
  %5 = trunc nuw i32 %4 to i1, !dbg !1192
  %or.cond.i.i = select i1 %.not3.i.i, i1 %5, i1 false, !dbg !1192
  br i1 %or.cond.i.i, label %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtB4_6result6ResultINtNtB4_6option6OptionNtNtCs1SSuMAdGM58_3std7process10ExitStatusENtNtNtB4_2io5error5ErrorEECshxBJAVx362N_11runtime_lab.exit18.i.i, label %bb4.i.i, !dbg !1192

bb10.i.i:                                         ; preds = %start
; invoke core::option::expect_failed
  invoke void @_RNvNtCsjIpoRzUjyHQ_4core6option13expect_failed(ptr noalias nofree noundef nonnull readonly captures(address, read_provenance) @alloc_6d2adbdab4a04e94478bf10d501f3011, i64 noundef 19, ptr noalias nofree noundef readonly align 8 captures(address, read_provenance) dereferenceable(24) @alloc_cfb3a9de3693f4818ff78ea1dbe39949) #25
          to label %.noexc6.i unwind label %cleanup.i, !dbg !1193, !noalias !1164

.noexc6.i:                                        ; preds = %bb10.i.i
  unreachable, !dbg !1193

bb4.i.i:                                          ; preds = %.noexc.i
  %6 = getelementptr inbounds nuw i8, ptr %_2.i.i, i64 8, !dbg !1196
  %_2.val6.i.i = load ptr, ptr %6, align 8, !dbg !1196, !noalias !1182
  %7 = icmp eq i32 %1, 0, !dbg !1197
  br i1 %7, label %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtB4_6result6ResultINtNtB4_6option6OptionNtNtCs1SSuMAdGM58_3std7process10ExitStatusENtNtNtB4_2io5error5ErrorEECshxBJAVx362N_11runtime_lab.exit.i.i, label %bb2.i.i.i, !dbg !1197

bb2.i.i.i:                                        ; preds = %bb4.i.i
  call void @llvm.lifetime.start.p0(ptr nonnull %_2.i.i.i.i.i.i), !dbg !1200, !noalias !1182
  call void @llvm.assume(i1 true) [ "nonnull"(ptr %_2.val6.i.i) ]
  %bits.i.i.i.i.i.i.i = ptrtoint ptr %_2.val6.i.i to i64, !dbg !1204
  %_5.i.i.i.i.i.i.i = and i64 %bits.i.i.i.i.i.i.i, 3, !dbg !1207
  switch i64 %_5.i.i.i.i.i.i.i, label %default.unreachable [
    i64 2, label %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtNtB4_2io5error5ErrorECshxBJAVx362N_11runtime_lab.exit.i.i.i
    i64 3, label %bb4.i.i.i.i.i.i.i
    i64 0, label %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtNtB4_2io5error5ErrorECshxBJAVx362N_11runtime_lab.exit.i.i.i
    i64 1, label %bb2.i1.i.i.i.i.i.i
  ], !dbg !1208, !prof !577

default.unreachable:                              ; preds = %bb2.i.i.i
  unreachable

bb4.i.i.i.i.i.i.i:                                ; preds = %bb2.i.i.i
  %8 = icmp ult ptr %_2.val6.i.i, inttoptr (i64 188978561024 to ptr), !dbg !1209
  %9 = and i64 %bits.i.i.i.i.i.i.i, 1095216660480, !dbg !1211
  %10 = icmp ne i64 %9, 1095216660480, !dbg !1211
  call void @llvm.assume(i1 %8), !dbg !1213
  call void @llvm.assume(i1 %10), !dbg !1213
  br label %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtNtB4_2io5error5ErrorECshxBJAVx362N_11runtime_lab.exit.i.i.i, !dbg !1214

bb2.i1.i.i.i.i.i.i:                               ; preds = %bb2.i.i.i
  %_33.i.i.i.i.i.i.i = getelementptr i8, ptr %_2.val6.i.i, i64 -1, !dbg !1215
  call void @llvm.assume(i1 true) [ "nonnull"(ptr %_33.i.i.i.i.i.i.i) ], !dbg !1219
  %11 = getelementptr inbounds nuw i8, ptr %_2.i.i.i.i.i.i, i64 8, !dbg !1222
  store ptr %_33.i.i.i.i.i.i.i, ptr %11, align 8, !dbg !1222, !alias.scope !1223, !noalias !1182
  store i8 3, ptr %_2.i.i.i.i.i.i, align 8, !dbg !1226, !alias.scope !1223, !noalias !1182
; invoke <core::io::error::CustomOwner as core::ops::drop::Drop>::drop
  invoke void @_RNvXsd_NtNtCsjIpoRzUjyHQ_4core2io5errorNtB5_11CustomOwnerNtNtNtB9_3ops4drop4Drop4drop(ptr noalias nofree noundef nonnull align 8 dereferenceable(8) %11)
          to label %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtNtB4_2io5error5ErrorECshxBJAVx362N_11runtime_lab.exit.i.i.i unwind label %cleanup.i, !dbg !1227

_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtNtB4_2io5error5ErrorECshxBJAVx362N_11runtime_lab.exit.i.i.i: ; preds = %bb2.i1.i.i.i.i.i.i, %bb4.i.i.i.i.i.i.i, %bb2.i.i.i, %bb2.i.i.i
  call void @llvm.lifetime.end.p0(ptr nonnull %_2.i.i.i.i.i.i), !dbg !1230, !noalias !1182
  br label %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtB4_6result6ResultINtNtB4_6option6OptionNtNtCs1SSuMAdGM58_3std7process10ExitStatusENtNtNtB4_2io5error5ErrorEECshxBJAVx362N_11runtime_lab.exit.i.i, !dbg !1197

_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtB4_6result6ResultINtNtB4_6option6OptionNtNtCs1SSuMAdGM58_3std7process10ExitStatusENtNtNtB4_2io5error5ErrorEECshxBJAVx362N_11runtime_lab.exit.i.i: ; preds = %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtNtB4_2io5error5ErrorECshxBJAVx362N_11runtime_lab.exit.i.i.i, %bb4.i.i
  call void @llvm.lifetime.end.p0(ptr nonnull %_2.i.i), !dbg !1196, !noalias !1182
  call void @llvm.lifetime.start.p0(ptr nonnull %orphan.i.i), !dbg !1231, !noalias !1182
  %_6.sroa.0.0.copyload.i.i = load i32, ptr %_1, align 8, !dbg !1232, !alias.scope !1182
  store i32 2, ptr %_1, align 8, !dbg !1237, !alias.scope !1182
  %.not2.i.i = icmp eq i32 %_6.sroa.0.0.copyload.i.i, 2, !dbg !1239
  br i1 %.not2.i.i, label %bb12.i.i, label %bb13.i.i, !dbg !1242, !prof !135

_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtB4_6result6ResultINtNtB4_6option6OptionNtNtCs1SSuMAdGM58_3std7process10ExitStatusENtNtNtB4_2io5error5ErrorEECshxBJAVx362N_11runtime_lab.exit18.i.i: ; preds = %.noexc.i
  call void @llvm.lifetime.end.p0(ptr nonnull %_2.i.i), !dbg !1196, !noalias !1182
  br label %bb6.i, !dbg !1243

bb13.i.i:                                         ; preds = %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtB4_6result6ResultINtNtB4_6option6OptionNtNtCs1SSuMAdGM58_3std7process10ExitStatusENtNtNtB4_2io5error5ErrorEECshxBJAVx362N_11runtime_lab.exit.i.i
  %_6.sroa.5.0.self.sroa_idx.i.i = getelementptr inbounds nuw i8, ptr %_1, i64 4, !dbg !1232
  store i32 %_6.sroa.0.0.copyload.i.i, ptr %orphan.i.i, align 4, !dbg !1244, !noalias !1182
  %_6.sroa.5.0.orphan.sroa_idx.i.i = getelementptr inbounds nuw i8, ptr %orphan.i.i, i64 4, !dbg !1244
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 4 dereferenceable(20) %_6.sroa.5.0.orphan.sroa_idx.i.i, ptr noundef nonnull align 4 dereferenceable(20) %_6.sroa.5.0.self.sroa_idx.i.i, i64 20, i1 false), !dbg !1244
  %_8.i.i = getelementptr inbounds nuw i8, ptr %_1, i64 40, !dbg !1245
; invoke <tokio::process::imp::GlobalOrphanQueue as tokio::process::imp::orphan::OrphanQueue<std::process::Child>>::push_orphan
  invoke void @_RNvXs2_NtNtCs3EIJ1qnJmKW_5tokio7process3impNtB5_17GlobalOrphanQueueINtNtB5_6orphan11OrphanQueueNtNtCs1SSuMAdGM58_3std7process5ChildE11push_orphan(ptr noalias nofree noundef nonnull readonly captures(address, read_provenance) %_8.i.i, ptr noalias nofree noundef nonnull align 4 captures(address) dereferenceable(24) %orphan.i.i)
          to label %.noexc8.i unwind label %cleanup.i, !dbg !1247

.noexc8.i:                                        ; preds = %bb13.i.i
  call void @llvm.lifetime.end.p0(ptr nonnull %orphan.i.i), !dbg !1248, !noalias !1182
  br label %bb6.i, !dbg !1243

bb12.i.i:                                         ; preds = %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtB4_6result6ResultINtNtB4_6option6OptionNtNtCs1SSuMAdGM58_3std7process10ExitStatusENtNtNtB4_2io5error5ErrorEECshxBJAVx362N_11runtime_lab.exit.i.i
; invoke core::option::unwrap_failed
  invoke void @_RNvNtCsjIpoRzUjyHQ_4core6option13unwrap_failed(ptr noalias nofree noundef readonly align 8 captures(address, read_provenance) dereferenceable(24) @alloc_e136e920a9e7286d7bfd1eaa7a373778) #25
          to label %.noexc9.i unwind label %cleanup.i, !dbg !1249

.noexc9.i:                                        ; preds = %bb12.i.i
  unreachable, !dbg !1249

cleanup.i:                                        ; preds = %bb12.i.i, %bb13.i.i, %bb2.i1.i.i.i.i.i.i, %bb10.i.i, %bb11.i.i
  %12 = landingpad { ptr, i32 }
          cleanup
; call core::ptr::drop_glue::<core::option::Option<std::process::Child>>
  call fastcc void @_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtB4_6option6OptionNtNtCs1SSuMAdGM58_3std7process5ChildEECshxBJAVx362N_11runtime_lab(ptr noalias nofree noundef nonnull align 8 dereferenceable(40) %_1) #23, !dbg !1171
  %13 = getelementptr inbounds nuw i8, ptr %_1, i64 24, !dbg !1171
  %.val.i = load ptr, ptr %13, align 8, !dbg !1171, !alias.scope !1164, !nonnull !41, !noundef !41
  %14 = getelementptr inbounds nuw i8, ptr %_1, i64 32, !dbg !1171
  %.val3.i = load ptr, ptr %14, align 8, !dbg !1171, !alias.scope !1164, !nonnull !41, !align !1250, !noundef !41
; invoke core::ptr::drop_glue::<tokio::signal::unix::Signal>
  invoke fastcc void @_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtNtCs3EIJ1qnJmKW_5tokio6signal4unix6SignalECshxBJAVx362N_11runtime_lab(ptr nonnull %.val.i, ptr nonnull %.val3.i) #23
          to label %common.resume.i unwind label %terminate.i, !dbg !1171

bb6.i:                                            ; preds = %.noexc8.i, %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtB4_6result6ResultINtNtB4_6option6OptionNtNtCs1SSuMAdGM58_3std7process10ExitStatusENtNtNtB4_2io5error5ErrorEECshxBJAVx362N_11runtime_lab.exit18.i.i
  call void @llvm.experimental.noalias.scope.decl(metadata !1251), !dbg !1171
  %15 = load i32, ptr %_1, align 8, !dbg !1254, !range !267, !alias.scope !1256, !noundef !41
  %16 = icmp eq i32 %15, 2, !dbg !1254
  br i1 %16, label %bb5.i, label %bb2.i.i, !dbg !1254

bb2.i.i:                                          ; preds = %bb6.i
  call void @llvm.experimental.noalias.scope.decl(metadata !1257), !dbg !1254
  %17 = getelementptr inbounds nuw i8, ptr %_1, i64 12, !dbg !1260
  %.val.i.i.i = load i32, ptr %17, align 4, !dbg !1260, !alias.scope !1262, !noundef !41
  %18 = icmp eq i32 %.val.i.i.i, -1, !dbg !1263
  br i1 %18, label %bb6.i.i.i, label %bb2.i.i.i.i, !dbg !1263

bb2.i.i.i.i:                                      ; preds = %bb2.i.i
  %_5.i.i.i.i.i.i.i.i = call noundef i32 @close(i32 noundef %.val.i.i.i) #20, !dbg !1265, !noalias !1270
  br label %bb6.i.i.i, !dbg !1263

bb6.i.i.i:                                        ; preds = %bb2.i.i.i.i, %bb2.i.i
  %19 = getelementptr inbounds nuw i8, ptr %_1, i64 16, !dbg !1260
  %.val4.i.i.i = load i32, ptr %19, align 8, !dbg !1260, !alias.scope !1262, !noundef !41
  %20 = icmp eq i32 %.val4.i.i.i, -1, !dbg !1271
  br i1 %20, label %bb5.i.i.i, label %bb2.i9.i.i.i, !dbg !1271

bb2.i9.i.i.i:                                     ; preds = %bb6.i.i.i
  %_5.i.i.i.i.i10.i.i.i = call noundef i32 @close(i32 noundef %.val4.i.i.i) #20, !dbg !1273, !noalias !1270
  br label %bb5.i.i.i, !dbg !1271

bb5.i.i.i:                                        ; preds = %bb2.i9.i.i.i, %bb6.i.i.i
  %21 = getelementptr inbounds nuw i8, ptr %_1, i64 20, !dbg !1260
  %.val6.i.i.i = load i32, ptr %21, align 4, !dbg !1260, !alias.scope !1262, !noundef !41
  %22 = icmp eq i32 %.val6.i.i.i, -1, !dbg !1278
  br i1 %22, label %bb5.i, label %bb2.i14.i.i.i, !dbg !1278

bb2.i14.i.i.i:                                    ; preds = %bb5.i.i.i
  %_5.i.i.i.i.i15.i.i.i = call noundef i32 @close(i32 noundef %.val6.i.i.i) #20, !dbg !1280, !noalias !1270
  br label %bb5.i, !dbg !1278

bb5.i:                                            ; preds = %bb2.i14.i.i.i, %bb5.i.i.i, %bb6.i
  %23 = getelementptr inbounds nuw i8, ptr %_1, i64 24, !dbg !1171
  %.val4.i = load ptr, ptr %23, align 8, !dbg !1171, !alias.scope !1164, !nonnull !41, !noundef !41
  %24 = getelementptr inbounds nuw i8, ptr %_1, i64 32, !dbg !1171
  %.val5.i = load ptr, ptr %24, align 8, !dbg !1171, !alias.scope !1164, !nonnull !41, !align !1250, !noundef !41
  %25 = load ptr, ptr %.val5.i, align 8, !dbg !1285, !invariant.load !41
  %.not.i.i.i.i.i.i = icmp eq ptr %25, null, !dbg !1285
  br i1 %.not.i.i.i.i.i.i, label %bb3.i.i.i.i.i.i, label %is_not_null.i.i.i.i.i.i, !dbg !1285

is_not_null.i.i.i.i.i.i:                          ; preds = %bb5.i
  invoke void %25(ptr noundef nonnull %.val4.i)
          to label %bb3.i.i.i.i.i.i unwind label %cleanup.i.i.i.i.i.i, !dbg !1285

bb3.i.i.i.i.i.i:                                  ; preds = %is_not_null.i.i.i.i.i.i, %bb5.i
  %26 = getelementptr inbounds nuw i8, ptr %.val5.i, i64 8, !dbg !1292
  %size.i.i.i.i.i.i.i = load i64, ptr %26, align 8, !dbg !1292, !range !917, !invariant.load !41
  %27 = icmp eq i64 %size.i.i.i.i.i.i.i, 0, !dbg !1296
  br i1 %27, label %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtNtCs3EIJ1qnJmKW_5tokio7process3imp4reap6ReaperNtNtCs1SSuMAdGM58_3std7process5ChildNtBG_17GlobalOrphanQueueNtNtNtBK_6signal4unix6SignalEECshxBJAVx362N_11runtime_lab.exit, label %_RNvXs1_NtCs6zY7rJBZy9D_5alloc5allocNtB5_6GlobalNtNtCsjIpoRzUjyHQ_4core5alloc9Allocator10deallocate.exit.i.i.i.i.i.i.i, !dbg !1296

_RNvXs1_NtCs6zY7rJBZy9D_5alloc5allocNtB5_6GlobalNtNtCsjIpoRzUjyHQ_4core5alloc9Allocator10deallocate.exit.i.i.i.i.i.i.i: ; preds = %bb3.i.i.i.i.i.i
  %28 = getelementptr inbounds nuw i8, ptr %.val5.i, i64 16, !dbg !1292
  %align.i.i.i.i.i.i.i = load i64, ptr %28, align 8, !dbg !1297, !range !928, !invariant.load !41
; call __rustc::__rust_dealloc
  call void @_RNvCsdtSMxSA38aw_7___rustc14___rust_dealloc(ptr noundef nonnull %.val4.i, i64 noundef %size.i.i.i.i.i.i.i, i64 noundef range(i64 1, -9223372036854775807) %align.i.i.i.i.i.i.i) #20, !dbg !1300
  br label %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtNtCs3EIJ1qnJmKW_5tokio7process3imp4reap6ReaperNtNtCs1SSuMAdGM58_3std7process5ChildNtBG_17GlobalOrphanQueueNtNtNtBK_6signal4unix6SignalEECshxBJAVx362N_11runtime_lab.exit, !dbg !1305

cleanup.i.i.i.i.i.i:                              ; preds = %is_not_null.i.i.i.i.i.i
  %29 = landingpad { ptr, i32 }
          cleanup
  %30 = getelementptr inbounds nuw i8, ptr %.val5.i, i64 8, !dbg !1306
  %size.i4.i.i.i.i.i.i = load i64, ptr %30, align 8, !dbg !1306, !range !917, !invariant.load !41
  %31 = icmp eq i64 %size.i4.i.i.i.i.i.i, 0, !dbg !1310
  br i1 %31, label %common.resume.i, label %_RNvXs1_NtCs6zY7rJBZy9D_5alloc5allocNtB5_6GlobalNtNtCsjIpoRzUjyHQ_4core5alloc9Allocator10deallocate.exit.i5.i.i.i.i.i.i, !dbg !1310

_RNvXs1_NtCs6zY7rJBZy9D_5alloc5allocNtB5_6GlobalNtNtCsjIpoRzUjyHQ_4core5alloc9Allocator10deallocate.exit.i5.i.i.i.i.i.i: ; preds = %cleanup.i.i.i.i.i.i
  %32 = getelementptr inbounds nuw i8, ptr %.val5.i, i64 16, !dbg !1306
  %align.i6.i.i.i.i.i.i = load i64, ptr %32, align 8, !dbg !1311, !range !928, !invariant.load !41
; call __rustc::__rust_dealloc
  call void @_RNvCsdtSMxSA38aw_7___rustc14___rust_dealloc(ptr noundef nonnull %.val4.i, i64 noundef %size.i4.i.i.i.i.i.i, i64 noundef range(i64 1, -9223372036854775807) %align.i6.i.i.i.i.i.i) #20, !dbg !1314
  br label %common.resume.i, !dbg !1319

common.resume.i:                                  ; preds = %_RNvXs1_NtCs6zY7rJBZy9D_5alloc5allocNtB5_6GlobalNtNtCsjIpoRzUjyHQ_4core5alloc9Allocator10deallocate.exit.i5.i.i.i.i.i.i, %cleanup.i.i.i.i.i.i, %cleanup.i
  %common.resume.op.i = phi { ptr, i32 } [ %29, %cleanup.i.i.i.i.i.i ], [ %29, %_RNvXs1_NtCs6zY7rJBZy9D_5alloc5allocNtB5_6GlobalNtNtCsjIpoRzUjyHQ_4core5alloc9Allocator10deallocate.exit.i5.i.i.i.i.i.i ], [ %12, %cleanup.i ]
  resume { ptr, i32 } %common.resume.op.i, !dbg !1171

terminate.i:                                      ; preds = %cleanup.i
  %33 = landingpad { ptr, i32 }
          filter [0 x ptr] zeroinitializer
; call core::panicking::panic_in_cleanup
  call void @_RNvNtCsjIpoRzUjyHQ_4core9panicking16panic_in_cleanup() #22, !dbg !1171
  unreachable, !dbg !1171

_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtNtCs3EIJ1qnJmKW_5tokio7process3imp4reap6ReaperNtNtCs1SSuMAdGM58_3std7process5ChildNtBG_17GlobalOrphanQueueNtNtNtBK_6signal4unix6SignalEECshxBJAVx362N_11runtime_lab.exit: ; preds = %bb3.i.i.i.i.i.i, %_RNvXs1_NtCs6zY7rJBZy9D_5alloc5allocNtB5_6GlobalNtNtCsjIpoRzUjyHQ_4core5alloc9Allocator10deallocate.exit.i.i.i.i.i.i.i
  ret void, !dbg !1167
}

; core::ptr::drop_glue::<tokio::runtime::builder::Builder>
; Function Attrs: uwtable
define internal fastcc void @_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtNtCs3EIJ1qnJmKW_5tokio7runtime7builder7BuilderECshxBJAVx362N_11runtime_lab(ptr noalias nofree noundef nonnull align 8 dereferenceable(264) %_1) unnamed_addr #2 personality ptr @rust_eh_personality !dbg !1320 !guid !1321 {
start:
  %0 = getelementptr inbounds nuw i8, ptr %_1, i64 48, !dbg !1322
  %.val = load i64, ptr %0, align 8, !dbg !1322, !range !246, !noundef !41
  %1 = icmp sgt i64 %.val, 0, !dbg !1323
  br i1 %1, label %_RNvXs1_NtCs6zY7rJBZy9D_5alloc5allocNtB5_6GlobalNtNtCsjIpoRzUjyHQ_4core5alloc9Allocator10deallocate.exit.i.i.i4.i.i.i, label %bb18, !dbg !1323

_RNvXs1_NtCs6zY7rJBZy9D_5alloc5allocNtB5_6GlobalNtNtCsjIpoRzUjyHQ_4core5alloc9Allocator10deallocate.exit.i.i.i4.i.i.i: ; preds = %start
  %2 = getelementptr inbounds nuw i8, ptr %_1, i64 56, !dbg !1322
  %.val21 = load ptr, ptr %2, align 8, !dbg !1322, !nonnull !41, !noundef !41
; call __rustc::__rust_dealloc
  tail call void @_RNvCsdtSMxSA38aw_7___rustc14___rust_dealloc(ptr noundef nonnull %.val21, i64 noundef %.val, i64 noundef range(i64 1, -9223372036854775807) 1) #20, !dbg !1325
  br label %bb18, !dbg !1335

bb18:                                             ; preds = %_RNvXs1_NtCs6zY7rJBZy9D_5alloc5allocNtB5_6GlobalNtNtCsjIpoRzUjyHQ_4core5alloc9Allocator10deallocate.exit.i.i.i4.i.i.i, %start
  %3 = getelementptr inbounds nuw i8, ptr %_1, i64 96, !dbg !1322
  tail call void @llvm.experimental.noalias.scope.decl(metadata !1336), !dbg !1322
  tail call void @llvm.experimental.noalias.scope.decl(metadata !1339), !dbg !1342
  %_10.0.i.i22 = load ptr, ptr %3, align 8, !dbg !1345, !alias.scope !1356, !nonnull !41, !noundef !41
  %_2.i.i23 = atomicrmw sub ptr %_10.0.i.i22, i64 1 release, align 8, !dbg !1357, !noalias !1356
  %4 = icmp eq i64 %_2.i.i23, 1, !dbg !1362
  br i1 %4, label %bb2.i.i24, label %bb17, !dbg !1362

bb2.i.i24:                                        ; preds = %bb18
  fence acquire, !dbg !1363
; invoke <alloc::sync::Arc<dyn core::ops::function::Fn<(), Output = alloc::string::String> + core::marker::Send + core::marker::Sync>>::drop_slow
  invoke void @_RNvMsn_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcDINtNtNtCsjIpoRzUjyHQ_4core3ops8function2FnuEp6OutputNtNtB7_6string6StringNtNtBO_6marker4SendNtB1U_4SyncEL_E9drop_slowCs3EIJ1qnJmKW_5tokio(ptr noalias nofree noundef nonnull align 8 dereferenceable(16) %3) #24
          to label %bb17 unwind label %cleanup1, !dbg !1366

bb2.i:                                            ; preds = %cleanup1
  %_2.i.i.i = atomicrmw sub ptr %8, i64 1 release, align 8, !dbg !1367, !noalias !1378
  %5 = icmp eq i64 %_2.i.i.i, 1, !dbg !1385
  br i1 %5, label %bb2.i.i.i, label %bb8, !dbg !1385

bb2.i.i.i:                                        ; preds = %bb2.i
  fence acquire, !dbg !1386
; invoke <alloc::sync::Arc<dyn core::ops::function::Fn<(), Output = ()> + core::marker::Send + core::marker::Sync>>::drop_slow
  invoke void @_RNvMsn_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcDINtNtNtCsjIpoRzUjyHQ_4core3ops8function2FnuEp6OutputuNtNtBO_6marker4SendNtB1A_4SyncEL_E9drop_slowCs3EIJ1qnJmKW_5tokio(ptr noalias nofree noundef nonnull align 8 dereferenceable(16) %7) #24
          to label %bb8 unwind label %terminate, !dbg !1388

cleanup1:                                         ; preds = %bb2.i.i24
  %6 = landingpad { ptr, i32 }
          cleanup
  %7 = getelementptr inbounds nuw i8, ptr %_1, i64 128, !dbg !1322
  tail call void @llvm.experimental.noalias.scope.decl(metadata !1389), !dbg !1322
  %8 = load ptr, ptr %7, align 8, !dbg !1390, !alias.scope !1389, !noundef !41
  %9 = icmp eq ptr %8, null, !dbg !1390
  br i1 %9, label %bb8, label %bb2.i, !dbg !1390

bb17:                                             ; preds = %bb18, %bb2.i.i24
  %10 = getelementptr inbounds nuw i8, ptr %_1, i64 128, !dbg !1322
  tail call void @llvm.experimental.noalias.scope.decl(metadata !1391), !dbg !1322
  %11 = load ptr, ptr %10, align 8, !dbg !1394, !alias.scope !1391, !noundef !41
  %12 = icmp eq ptr %11, null, !dbg !1394
  br i1 %12, label %bb16, label %bb2.i28, !dbg !1394

bb2.i28:                                          ; preds = %bb17
  %_2.i.i.i29 = atomicrmw sub ptr %11, i64 1 release, align 8, !dbg !1396, !noalias !1401
  %13 = icmp eq i64 %_2.i.i.i29, 1, !dbg !1406
  br i1 %13, label %bb2.i.i.i30, label %bb16, !dbg !1406

bb2.i.i.i30:                                      ; preds = %bb2.i28
  fence acquire, !dbg !1407
; invoke <alloc::sync::Arc<dyn core::ops::function::Fn<(), Output = ()> + core::marker::Send + core::marker::Sync>>::drop_slow
  invoke void @_RNvMsn_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcDINtNtNtCsjIpoRzUjyHQ_4core3ops8function2FnuEp6OutputuNtNtBO_6marker4SendNtB1A_4SyncEL_E9drop_slowCs3EIJ1qnJmKW_5tokio(ptr noalias nofree noundef nonnull align 8 dereferenceable(16) %10) #24
          to label %bb16 unwind label %cleanup2, !dbg !1409

bb8:                                              ; preds = %bb2.i, %cleanup1, %bb2.i.i.i, %cleanup2
  %.pn9 = phi { ptr, i32 } [ %18, %cleanup2 ], [ %6, %bb2.i.i.i ], [ %6, %cleanup1 ], [ %6, %bb2.i ]
  %14 = getelementptr inbounds nuw i8, ptr %_1, i64 144, !dbg !1322
  tail call void @llvm.experimental.noalias.scope.decl(metadata !1410), !dbg !1322
  %15 = load ptr, ptr %14, align 8, !dbg !1413, !alias.scope !1410, !noundef !41
  %16 = icmp eq ptr %15, null, !dbg !1413
  br i1 %16, label %bb7, label %bb2.i33, !dbg !1413

bb2.i33:                                          ; preds = %bb8
  %_2.i.i.i34 = atomicrmw sub ptr %15, i64 1 release, align 8, !dbg !1415, !noalias !1420
  %17 = icmp eq i64 %_2.i.i.i34, 1, !dbg !1425
  br i1 %17, label %bb2.i.i.i35, label %bb7, !dbg !1425

bb2.i.i.i35:                                      ; preds = %bb2.i33
  fence acquire, !dbg !1426
; invoke <alloc::sync::Arc<dyn core::ops::function::Fn<(), Output = ()> + core::marker::Send + core::marker::Sync>>::drop_slow
  invoke void @_RNvMsn_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcDINtNtNtCsjIpoRzUjyHQ_4core3ops8function2FnuEp6OutputuNtNtBO_6marker4SendNtB1A_4SyncEL_E9drop_slowCs3EIJ1qnJmKW_5tokio(ptr noalias nofree noundef nonnull align 8 dereferenceable(16) %14) #24
          to label %bb7 unwind label %terminate, !dbg !1428

cleanup2:                                         ; preds = %bb2.i.i.i30
  %18 = landingpad { ptr, i32 }
          cleanup
  br label %bb8

bb16:                                             ; preds = %bb2.i28, %bb17, %bb2.i.i.i30
  %19 = getelementptr inbounds nuw i8, ptr %_1, i64 144, !dbg !1322
  tail call void @llvm.experimental.noalias.scope.decl(metadata !1429), !dbg !1322
  %20 = load ptr, ptr %19, align 8, !dbg !1432, !alias.scope !1429, !noundef !41
  %21 = icmp eq ptr %20, null, !dbg !1432
  br i1 %21, label %bb15, label %bb2.i38, !dbg !1432

bb2.i38:                                          ; preds = %bb16
  %_2.i.i.i39 = atomicrmw sub ptr %20, i64 1 release, align 8, !dbg !1434, !noalias !1439
  %22 = icmp eq i64 %_2.i.i.i39, 1, !dbg !1444
  br i1 %22, label %bb2.i.i.i40, label %bb15, !dbg !1444

bb2.i.i.i40:                                      ; preds = %bb2.i38
  fence acquire, !dbg !1445
; invoke <alloc::sync::Arc<dyn core::ops::function::Fn<(), Output = ()> + core::marker::Send + core::marker::Sync>>::drop_slow
  invoke void @_RNvMsn_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcDINtNtNtCsjIpoRzUjyHQ_4core3ops8function2FnuEp6OutputuNtNtBO_6marker4SendNtB1A_4SyncEL_E9drop_slowCs3EIJ1qnJmKW_5tokio(ptr noalias nofree noundef nonnull align 8 dereferenceable(16) %19) #24
          to label %bb15 unwind label %cleanup3, !dbg !1447

bb7:                                              ; preds = %bb2.i33, %bb8, %bb2.i.i.i35, %cleanup3
  %.pn11 = phi { ptr, i32 } [ %27, %cleanup3 ], [ %.pn9, %bb2.i.i.i35 ], [ %.pn9, %bb8 ], [ %.pn9, %bb2.i33 ]
  %23 = getelementptr inbounds nuw i8, ptr %_1, i64 160, !dbg !1322
  tail call void @llvm.experimental.noalias.scope.decl(metadata !1448), !dbg !1322
  %24 = load ptr, ptr %23, align 8, !dbg !1451, !alias.scope !1448, !noundef !41
  %25 = icmp eq ptr %24, null, !dbg !1451
  br i1 %25, label %bb6, label %bb2.i43, !dbg !1451

bb2.i43:                                          ; preds = %bb7
  %_2.i.i.i44 = atomicrmw sub ptr %24, i64 1 release, align 8, !dbg !1453, !noalias !1458
  %26 = icmp eq i64 %_2.i.i.i44, 1, !dbg !1463
  br i1 %26, label %bb2.i.i.i45, label %bb6, !dbg !1463

bb2.i.i.i45:                                      ; preds = %bb2.i43
  fence acquire, !dbg !1464
; invoke <alloc::sync::Arc<dyn core::ops::function::Fn<(), Output = ()> + core::marker::Send + core::marker::Sync>>::drop_slow
  invoke void @_RNvMsn_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcDINtNtNtCsjIpoRzUjyHQ_4core3ops8function2FnuEp6OutputuNtNtBO_6marker4SendNtB1A_4SyncEL_E9drop_slowCs3EIJ1qnJmKW_5tokio(ptr noalias nofree noundef nonnull align 8 dereferenceable(16) %23) #24
          to label %bb6 unwind label %terminate, !dbg !1466

cleanup3:                                         ; preds = %bb2.i.i.i40
  %27 = landingpad { ptr, i32 }
          cleanup
  br label %bb7

bb15:                                             ; preds = %bb2.i38, %bb16, %bb2.i.i.i40
  %28 = getelementptr inbounds nuw i8, ptr %_1, i64 160, !dbg !1322
  tail call void @llvm.experimental.noalias.scope.decl(metadata !1467), !dbg !1322
  %29 = load ptr, ptr %28, align 8, !dbg !1470, !alias.scope !1467, !noundef !41
  %30 = icmp eq ptr %29, null, !dbg !1470
  br i1 %30, label %bb14, label %bb2.i48, !dbg !1470

bb2.i48:                                          ; preds = %bb15
  %_2.i.i.i49 = atomicrmw sub ptr %29, i64 1 release, align 8, !dbg !1472, !noalias !1477
  %31 = icmp eq i64 %_2.i.i.i49, 1, !dbg !1482
  br i1 %31, label %bb2.i.i.i50, label %bb14, !dbg !1482

bb2.i.i.i50:                                      ; preds = %bb2.i48
  fence acquire, !dbg !1483
; invoke <alloc::sync::Arc<dyn core::ops::function::Fn<(), Output = ()> + core::marker::Send + core::marker::Sync>>::drop_slow
  invoke void @_RNvMsn_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcDINtNtNtCsjIpoRzUjyHQ_4core3ops8function2FnuEp6OutputuNtNtBO_6marker4SendNtB1A_4SyncEL_E9drop_slowCs3EIJ1qnJmKW_5tokio(ptr noalias nofree noundef nonnull align 8 dereferenceable(16) %28) #24
          to label %bb14 unwind label %cleanup4, !dbg !1485

bb6:                                              ; preds = %bb2.i43, %bb7, %bb2.i.i.i45, %cleanup4
  %.pn13 = phi { ptr, i32 } [ %36, %cleanup4 ], [ %.pn11, %bb2.i.i.i45 ], [ %.pn11, %bb7 ], [ %.pn11, %bb2.i43 ]
  %32 = getelementptr inbounds nuw i8, ptr %_1, i64 176, !dbg !1322
  tail call void @llvm.experimental.noalias.scope.decl(metadata !1486), !dbg !1322
  %33 = load ptr, ptr %32, align 8, !dbg !1489, !alias.scope !1486, !noundef !41
  %34 = icmp eq ptr %33, null, !dbg !1489
  br i1 %34, label %bb5, label %bb2.i53, !dbg !1489

bb2.i53:                                          ; preds = %bb6
  %_2.i.i.i54 = atomicrmw sub ptr %33, i64 1 release, align 8, !dbg !1491, !noalias !1496
  %35 = icmp eq i64 %_2.i.i.i54, 1, !dbg !1501
  br i1 %35, label %bb2.i.i.i55, label %bb5, !dbg !1501

bb2.i.i.i55:                                      ; preds = %bb2.i53
  fence acquire, !dbg !1502
; invoke <alloc::sync::Arc<dyn core::ops::function::Fn<(), Output = ()> + core::marker::Send + core::marker::Sync>>::drop_slow
  invoke void @_RNvMsn_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcDINtNtNtCsjIpoRzUjyHQ_4core3ops8function2FnuEp6OutputuNtNtBO_6marker4SendNtB1A_4SyncEL_E9drop_slowCs3EIJ1qnJmKW_5tokio(ptr noalias nofree noundef nonnull align 8 dereferenceable(16) %32) #24
          to label %bb5 unwind label %terminate, !dbg !1504

cleanup4:                                         ; preds = %bb2.i.i.i50
  %36 = landingpad { ptr, i32 }
          cleanup
  br label %bb6

bb14:                                             ; preds = %bb2.i48, %bb15, %bb2.i.i.i50
  %37 = getelementptr inbounds nuw i8, ptr %_1, i64 176, !dbg !1322
  tail call void @llvm.experimental.noalias.scope.decl(metadata !1505), !dbg !1322
  %38 = load ptr, ptr %37, align 8, !dbg !1508, !alias.scope !1505, !noundef !41
  %39 = icmp eq ptr %38, null, !dbg !1508
  br i1 %39, label %bb13, label %bb2.i58, !dbg !1508

bb2.i58:                                          ; preds = %bb14
  %_2.i.i.i59 = atomicrmw sub ptr %38, i64 1 release, align 8, !dbg !1510, !noalias !1515
  %40 = icmp eq i64 %_2.i.i.i59, 1, !dbg !1520
  br i1 %40, label %bb2.i.i.i60, label %bb13, !dbg !1520

bb2.i.i.i60:                                      ; preds = %bb2.i58
  fence acquire, !dbg !1521
; invoke <alloc::sync::Arc<dyn core::ops::function::Fn<(), Output = ()> + core::marker::Send + core::marker::Sync>>::drop_slow
  invoke void @_RNvMsn_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcDINtNtNtCsjIpoRzUjyHQ_4core3ops8function2FnuEp6OutputuNtNtBO_6marker4SendNtB1A_4SyncEL_E9drop_slowCs3EIJ1qnJmKW_5tokio(ptr noalias nofree noundef nonnull align 8 dereferenceable(16) %37) #24
          to label %bb13 unwind label %cleanup5, !dbg !1523

bb5:                                              ; preds = %bb2.i53, %bb6, %bb2.i.i.i55, %cleanup5
  %.pn15 = phi { ptr, i32 } [ %45, %cleanup5 ], [ %.pn13, %bb2.i.i.i55 ], [ %.pn13, %bb6 ], [ %.pn13, %bb2.i53 ]
  %41 = getelementptr inbounds nuw i8, ptr %_1, i64 192, !dbg !1322
  tail call void @llvm.experimental.noalias.scope.decl(metadata !1524), !dbg !1322
  %42 = load ptr, ptr %41, align 8, !dbg !1527, !alias.scope !1524, !noundef !41
  %43 = icmp eq ptr %42, null, !dbg !1527
  br i1 %43, label %bb4, label %bb2.i63, !dbg !1527

bb2.i63:                                          ; preds = %bb5
  %_2.i.i.i64 = atomicrmw sub ptr %42, i64 1 release, align 8, !dbg !1530, !noalias !1539
  %44 = icmp eq i64 %_2.i.i.i64, 1, !dbg !1544
  br i1 %44, label %bb2.i.i.i65, label %bb4, !dbg !1544

bb2.i.i.i65:                                      ; preds = %bb2.i63
  fence acquire, !dbg !1545
; invoke <alloc::sync::Arc<dyn for<'a, 'b> core::ops::function::Fn<(&'a tokio::runtime::task_hooks::TaskMeta<'b>,), Output = ()> + core::marker::Send + core::marker::Sync>>::drop_slow
  invoke void @_RNvMsn_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcDG0_INtNtNtCsjIpoRzUjyHQ_4core3ops8function2FnTRL1_INtNtNtCs3EIJ1qnJmKW_5tokio7runtime10task_hooks8TaskMetaL0_EEEp6OutputuNtNtBR_6marker4SendNtB2G_4SyncEL_E9drop_slowB1C_(ptr noalias nofree noundef nonnull align 8 dereferenceable(16) %41) #24
          to label %bb4 unwind label %terminate, !dbg !1547

cleanup5:                                         ; preds = %bb2.i.i.i60
  %45 = landingpad { ptr, i32 }
          cleanup
  br label %bb5

bb13:                                             ; preds = %bb2.i58, %bb14, %bb2.i.i.i60
  %46 = getelementptr inbounds nuw i8, ptr %_1, i64 192, !dbg !1322
  tail call void @llvm.experimental.noalias.scope.decl(metadata !1548), !dbg !1322
  %47 = load ptr, ptr %46, align 8, !dbg !1551, !alias.scope !1548, !noundef !41
  %48 = icmp eq ptr %47, null, !dbg !1551
  br i1 %48, label %bb12, label %bb2.i67, !dbg !1551

bb2.i67:                                          ; preds = %bb13
  %_2.i.i.i68 = atomicrmw sub ptr %47, i64 1 release, align 8, !dbg !1553, !noalias !1558
  %49 = icmp eq i64 %_2.i.i.i68, 1, !dbg !1563
  br i1 %49, label %bb2.i.i.i69, label %bb12, !dbg !1563

bb2.i.i.i69:                                      ; preds = %bb2.i67
  fence acquire, !dbg !1564
; invoke <alloc::sync::Arc<dyn for<'a, 'b> core::ops::function::Fn<(&'a tokio::runtime::task_hooks::TaskMeta<'b>,), Output = ()> + core::marker::Send + core::marker::Sync>>::drop_slow
  invoke void @_RNvMsn_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcDG0_INtNtNtCsjIpoRzUjyHQ_4core3ops8function2FnTRL1_INtNtNtCs3EIJ1qnJmKW_5tokio7runtime10task_hooks8TaskMetaL0_EEEp6OutputuNtNtBR_6marker4SendNtB2G_4SyncEL_E9drop_slowB1C_(ptr noalias nofree noundef nonnull align 8 dereferenceable(16) %46) #24
          to label %bb12 unwind label %cleanup6, !dbg !1566

bb4:                                              ; preds = %bb2.i63, %bb5, %bb2.i.i.i65, %cleanup6
  %.pn17 = phi { ptr, i32 } [ %54, %cleanup6 ], [ %.pn15, %bb2.i.i.i65 ], [ %.pn15, %bb5 ], [ %.pn15, %bb2.i63 ]
  %50 = getelementptr inbounds nuw i8, ptr %_1, i64 208, !dbg !1322
  tail call void @llvm.experimental.noalias.scope.decl(metadata !1567), !dbg !1322
  %51 = load ptr, ptr %50, align 8, !dbg !1570, !alias.scope !1567, !noundef !41
  %52 = icmp eq ptr %51, null, !dbg !1570
  br i1 %52, label %bb3, label %bb2.i72, !dbg !1570

bb2.i72:                                          ; preds = %bb4
  %_2.i.i.i73 = atomicrmw sub ptr %51, i64 1 release, align 8, !dbg !1572, !noalias !1577
  %53 = icmp eq i64 %_2.i.i.i73, 1, !dbg !1582
  br i1 %53, label %bb2.i.i.i74, label %bb3, !dbg !1582

bb2.i.i.i74:                                      ; preds = %bb2.i72
  fence acquire, !dbg !1583
; invoke <alloc::sync::Arc<dyn for<'a, 'b> core::ops::function::Fn<(&'a tokio::runtime::task_hooks::TaskMeta<'b>,), Output = ()> + core::marker::Send + core::marker::Sync>>::drop_slow
  invoke void @_RNvMsn_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcDG0_INtNtNtCsjIpoRzUjyHQ_4core3ops8function2FnTRL1_INtNtNtCs3EIJ1qnJmKW_5tokio7runtime10task_hooks8TaskMetaL0_EEEp6OutputuNtNtBR_6marker4SendNtB2G_4SyncEL_E9drop_slowB1C_(ptr noalias nofree noundef nonnull align 8 dereferenceable(16) %50) #24
          to label %bb3 unwind label %terminate, !dbg !1585

cleanup6:                                         ; preds = %bb2.i.i.i69
  %54 = landingpad { ptr, i32 }
          cleanup
  br label %bb4

bb12:                                             ; preds = %bb2.i67, %bb13, %bb2.i.i.i69
  %55 = getelementptr inbounds nuw i8, ptr %_1, i64 208, !dbg !1322
  tail call void @llvm.experimental.noalias.scope.decl(metadata !1586), !dbg !1322
  %56 = load ptr, ptr %55, align 8, !dbg !1589, !alias.scope !1586, !noundef !41
  %57 = icmp eq ptr %56, null, !dbg !1589
  br i1 %57, label %bb11, label %bb2.i77, !dbg !1589

bb2.i77:                                          ; preds = %bb12
  %_2.i.i.i78 = atomicrmw sub ptr %56, i64 1 release, align 8, !dbg !1591, !noalias !1596
  %58 = icmp eq i64 %_2.i.i.i78, 1, !dbg !1601
  br i1 %58, label %bb2.i.i.i79, label %bb11, !dbg !1601

bb2.i.i.i79:                                      ; preds = %bb2.i77
  fence acquire, !dbg !1602
; invoke <alloc::sync::Arc<dyn for<'a, 'b> core::ops::function::Fn<(&'a tokio::runtime::task_hooks::TaskMeta<'b>,), Output = ()> + core::marker::Send + core::marker::Sync>>::drop_slow
  invoke void @_RNvMsn_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcDG0_INtNtNtCsjIpoRzUjyHQ_4core3ops8function2FnTRL1_INtNtNtCs3EIJ1qnJmKW_5tokio7runtime10task_hooks8TaskMetaL0_EEEp6OutputuNtNtBR_6marker4SendNtB2G_4SyncEL_E9drop_slowB1C_(ptr noalias nofree noundef nonnull align 8 dereferenceable(16) %55) #24
          to label %bb11 unwind label %cleanup7, !dbg !1604

bb3:                                              ; preds = %bb2.i72, %bb4, %bb2.i.i.i74, %cleanup7
  %.pn19 = phi { ptr, i32 } [ %60, %cleanup7 ], [ %.pn17, %bb2.i.i.i74 ], [ %.pn17, %bb4 ], [ %.pn17, %bb2.i72 ]
  %59 = getelementptr inbounds nuw i8, ptr %_1, i64 224, !dbg !1322
; invoke core::ptr::drop_glue::<tokio::util::rand::rt::RngSeedGenerator>
  invoke fastcc void @_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtNtNtCs3EIJ1qnJmKW_5tokio4util4rand2rt16RngSeedGeneratorECshxBJAVx362N_11runtime_lab(ptr noalias nofree noundef align 8 dereferenceable(24) %59) #23
          to label %common.resume unwind label %terminate, !dbg !1322

cleanup7:                                         ; preds = %bb2.i.i.i79
  %60 = landingpad { ptr, i32 }
          cleanup
  br label %bb3

bb11:                                             ; preds = %bb2.i77, %bb12, %bb2.i.i.i79
  %61 = getelementptr inbounds nuw i8, ptr %_1, i64 224, !dbg !1322
; invoke <std::sys::sync::mutex::pthread::Mutex as core::ops::drop::Drop>::drop
  invoke void @_RNvXs_NtNtNtNtCs1SSuMAdGM58_3std3sys4sync5mutex7pthreadNtB4_5MutexNtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4drop(ptr noalias nofree noundef nonnull align 8 dereferenceable(24) %61)
          to label %bb4.i.i.i unwind label %cleanup.i.i.i, !dbg !1605

cleanup.i.i.i:                                    ; preds = %bb11
  %62 = landingpad { ptr, i32 }
          cleanup
; invoke core::ptr::drop_glue::<std::sys::sync::once_box::OnceBox<std::sys::pal::unix::sync::mutex::Mutex>>
  invoke fastcc void @_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtNtCs1SSuMAdGM58_3std3sys4sync8once_box7OnceBoxNtNtNtNtNtBI_3pal4unix4sync5mutex5MutexEECshxBJAVx362N_11runtime_lab(ptr noalias nofree noundef nonnull align 8 dereferenceable(24) %61) #23
          to label %common.resume unwind label %terminate.i.i.i, !dbg !1605

bb4.i.i.i:                                        ; preds = %bb11
  tail call void @llvm.experimental.noalias.scope.decl(metadata !1612), !dbg !1605
  tail call void @llvm.experimental.noalias.scope.decl(metadata !1615), !dbg !1618
  %ptr.i.i.i.i.i = load ptr, ptr %61, align 8, !dbg !1620, !alias.scope !1624, !noundef !41
  store ptr null, ptr %61, align 8, !dbg !1631, !alias.scope !1624
  %_5.i.i.i.i.i = icmp eq ptr %ptr.i.i.i.i.i, null, !dbg !1632
  br i1 %_5.i.i.i.i.i, label %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtNtNtCs3EIJ1qnJmKW_5tokio4util4rand2rt16RngSeedGeneratorECshxBJAVx362N_11runtime_lab.exit, label %bb2.i.i.i.i.i.i, !dbg !1636

bb2.i.i.i.i.i.i:                                  ; preds = %bb4.i.i.i
; invoke <std::sys::pal::unix::sync::mutex::Mutex as core::ops::drop::Drop>::drop
  invoke void @_RNvXs2_NtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutexNtB5_5MutexNtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4drop(ptr noundef nonnull align 8 %ptr.i.i.i.i.i)
          to label %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtB4_3pin3PinINtNtCs6zY7rJBZy9D_5alloc5boxed3BoxNtNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutex5MutexEEECshxBJAVx362N_11runtime_lab.exit.i.i.i.i.i.i unwind label %bb2.i.i.i.i.i.i.i.i, !dbg !1638, !noalias !1642

common.resume:                                    ; preds = %bb3, %cleanup.i.i.i, %bb2.i.i.i.i.i.i.i.i
  %common.resume.op = phi { ptr, i32 } [ %62, %cleanup.i.i.i ], [ %63, %bb2.i.i.i.i.i.i.i.i ], [ %.pn19, %bb3 ]
  resume { ptr, i32 } %common.resume.op, !dbg !1322

bb2.i.i.i.i.i.i.i.i:                              ; preds = %bb2.i.i.i.i.i.i
  %63 = landingpad { ptr, i32 }
          cleanup
; call __rustc::__rust_dealloc
  tail call void @_RNvCsdtSMxSA38aw_7___rustc14___rust_dealloc(ptr noundef nonnull %ptr.i.i.i.i.i, i64 noundef 64, i64 noundef 8) #20, !dbg !1643, !noalias !1642
  br label %common.resume, !dbg !1649

_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtB4_3pin3PinINtNtCs6zY7rJBZy9D_5alloc5boxed3BoxNtNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutex5MutexEEECshxBJAVx362N_11runtime_lab.exit.i.i.i.i.i.i: ; preds = %bb2.i.i.i.i.i.i
; call __rustc::__rust_dealloc
  tail call void @_RNvCsdtSMxSA38aw_7___rustc14___rust_dealloc(ptr noundef nonnull %ptr.i.i.i.i.i, i64 noundef 64, i64 noundef 8) #20, !dbg !1650, !noalias !1642
  br label %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtNtNtCs3EIJ1qnJmKW_5tokio4util4rand2rt16RngSeedGeneratorECshxBJAVx362N_11runtime_lab.exit, !dbg !1636

terminate.i.i.i:                                  ; preds = %cleanup.i.i.i
  %64 = landingpad { ptr, i32 }
          filter [0 x ptr] zeroinitializer
; call core::panicking::panic_in_cleanup
  tail call void @_RNvNtCsjIpoRzUjyHQ_4core9panicking16panic_in_cleanup() #22, !dbg !1605
  unreachable, !dbg !1605

_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtNtNtCs3EIJ1qnJmKW_5tokio4util4rand2rt16RngSeedGeneratorECshxBJAVx362N_11runtime_lab.exit: ; preds = %bb4.i.i.i, %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtB4_3pin3PinINtNtCs6zY7rJBZy9D_5alloc5boxed3BoxNtNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutex5MutexEEECshxBJAVx362N_11runtime_lab.exit.i.i.i.i.i.i
  ret void, !dbg !1322

terminate:                                        ; preds = %bb2.i.i.i74, %bb2.i.i.i65, %bb2.i.i.i55, %bb2.i.i.i45, %bb2.i.i.i35, %bb2.i.i.i, %bb3
  %65 = landingpad { ptr, i32 }
          filter [0 x ptr] zeroinitializer
; call core::panicking::panic_in_cleanup
  tail call void @_RNvNtCsjIpoRzUjyHQ_4core9panicking16panic_in_cleanup() #22, !dbg !1322
  unreachable, !dbg !1322
}

; core::ptr::drop_glue::<tokio::runtime::scheduler::Handle>
; Function Attrs: uwtable
define internal fastcc void @_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtNtCs3EIJ1qnJmKW_5tokio7runtime9scheduler6HandleECshxBJAVx362N_11runtime_lab(ptr noalias nofree noundef nonnull align 8 dereferenceable(16) %_1) unnamed_addr #2 !dbg !1656 !guid !1657 {
start:
  %_2 = load i64, ptr %_1, align 8, !dbg !1658, !range !1659, !noundef !41
  %0 = getelementptr inbounds nuw i8, ptr %_1, i64 8, !dbg !1658
  %1 = icmp eq i64 %_2, 0, !dbg !1658
  br i1 %1, label %bb2, label %bb3, !dbg !1658

bb2:                                              ; preds = %start
  tail call void @llvm.experimental.noalias.scope.decl(metadata !1660), !dbg !1658
  tail call void @llvm.experimental.noalias.scope.decl(metadata !1663), !dbg !1666
  %_10.i.i = load ptr, ptr %0, align 8, !dbg !1669, !alias.scope !1676, !nonnull !41, !noundef !41
  %_2.i.i = atomicrmw sub ptr %_10.i.i, i64 1 release, align 8, !dbg !1677, !noalias !1676
  %2 = icmp eq i64 %_2.i.i, 1, !dbg !1682
  br i1 %2, label %bb2.i.i, label %bb1, !dbg !1682

bb2.i.i:                                          ; preds = %bb2
  fence acquire, !dbg !1683
; call <alloc::sync::Arc<tokio::runtime::scheduler::current_thread::Handle>>::drop_slow
  tail call void @_RNvMsn_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcNtNtNtNtCs3EIJ1qnJmKW_5tokio7runtime9scheduler14current_thread6HandleE9drop_slowBO_(ptr noalias nofree noundef nonnull align 8 dereferenceable(8) %0) #24, !dbg !1685
  br label %bb1, !dbg !1685

bb3:                                              ; preds = %start
  tail call void @llvm.experimental.noalias.scope.decl(metadata !1686), !dbg !1658
  tail call void @llvm.experimental.noalias.scope.decl(metadata !1689), !dbg !1692
  %_10.i.i1 = load ptr, ptr %0, align 8, !dbg !1695, !alias.scope !1702, !nonnull !41, !noundef !41
  %_2.i.i2 = atomicrmw sub ptr %_10.i.i1, i64 1 release, align 8, !dbg !1703, !noalias !1702
  %3 = icmp eq i64 %_2.i.i2, 1, !dbg !1708
  br i1 %3, label %bb2.i.i3, label %bb1, !dbg !1708

bb2.i.i3:                                         ; preds = %bb3
  fence acquire, !dbg !1709
; call <alloc::sync::Arc<tokio::runtime::scheduler::multi_thread::handle::Handle>>::drop_slow
  tail call void @_RNvMsn_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcNtNtNtNtNtCs3EIJ1qnJmKW_5tokio7runtime9scheduler12multi_thread6handle6HandleE9drop_slowBQ_(ptr noalias nofree noundef nonnull align 8 dereferenceable(8) %0) #24, !dbg !1711
  br label %bb1, !dbg !1711

bb1:                                              ; preds = %bb2.i.i3, %bb3, %bb2.i.i, %bb2
  ret void, !dbg !1658
}

; core::ptr::drop_glue::<tokio::util::rand::rt::RngSeedGenerator>
; Function Attrs: uwtable
define internal fastcc void @_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtNtNtCs3EIJ1qnJmKW_5tokio4util4rand2rt16RngSeedGeneratorECshxBJAVx362N_11runtime_lab(ptr noalias nofree noundef nonnull align 8 dereferenceable(24) %_1) unnamed_addr #2 personality ptr @rust_eh_personality !dbg !1610 !guid !1712 {
start:
; invoke <std::sys::sync::mutex::pthread::Mutex as core::ops::drop::Drop>::drop
  invoke void @_RNvXs_NtNtNtNtCs1SSuMAdGM58_3std3sys4sync5mutex7pthreadNtB4_5MutexNtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4drop(ptr noalias nofree noundef nonnull align 8 dereferenceable(24) %_1)
          to label %bb4.i.i unwind label %cleanup.i.i, !dbg !1713

cleanup.i.i:                                      ; preds = %start
  %0 = landingpad { ptr, i32 }
          cleanup
; invoke core::ptr::drop_glue::<std::sys::sync::once_box::OnceBox<std::sys::pal::unix::sync::mutex::Mutex>>
  invoke fastcc void @_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtNtCs1SSuMAdGM58_3std3sys4sync8once_box7OnceBoxNtNtNtNtNtBI_3pal4unix4sync5mutex5MutexEECshxBJAVx362N_11runtime_lab(ptr noalias nofree noundef nonnull align 8 dereferenceable(24) %_1) #23
          to label %common.resume.i.i unwind label %terminate.i.i, !dbg !1713

bb4.i.i:                                          ; preds = %start
  tail call void @llvm.experimental.noalias.scope.decl(metadata !1716), !dbg !1713
  tail call void @llvm.experimental.noalias.scope.decl(metadata !1719), !dbg !1722
  %ptr.i.i.i.i = load ptr, ptr %_1, align 8, !dbg !1724, !alias.scope !1728, !noundef !41
  store ptr null, ptr %_1, align 8, !dbg !1733, !alias.scope !1728
  %_5.i.i.i.i = icmp eq ptr %ptr.i.i.i.i, null, !dbg !1734
  br i1 %_5.i.i.i.i, label %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtNtCs1SSuMAdGM58_3std4sync6poison5mutex5MutexNtNtNtCs3EIJ1qnJmKW_5tokio4util4rand8FastRandEECshxBJAVx362N_11runtime_lab.exit, label %bb2.i.i.i.i.i, !dbg !1738

bb2.i.i.i.i.i:                                    ; preds = %bb4.i.i
; invoke <std::sys::pal::unix::sync::mutex::Mutex as core::ops::drop::Drop>::drop
  invoke void @_RNvXs2_NtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutexNtB5_5MutexNtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4drop(ptr noundef nonnull align 8 %ptr.i.i.i.i)
          to label %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtB4_3pin3PinINtNtCs6zY7rJBZy9D_5alloc5boxed3BoxNtNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutex5MutexEEECshxBJAVx362N_11runtime_lab.exit.i.i.i.i.i unwind label %bb2.i.i.i.i.i.i.i, !dbg !1740, !noalias !1744

common.resume.i.i:                                ; preds = %bb2.i.i.i.i.i.i.i, %cleanup.i.i
  %common.resume.op.i.i = phi { ptr, i32 } [ %1, %bb2.i.i.i.i.i.i.i ], [ %0, %cleanup.i.i ]
  resume { ptr, i32 } %common.resume.op.i.i, !dbg !1713

bb2.i.i.i.i.i.i.i:                                ; preds = %bb2.i.i.i.i.i
  %1 = landingpad { ptr, i32 }
          cleanup
; call __rustc::__rust_dealloc
  tail call void @_RNvCsdtSMxSA38aw_7___rustc14___rust_dealloc(ptr noundef nonnull %ptr.i.i.i.i, i64 noundef 64, i64 noundef 8) #20, !dbg !1745, !noalias !1744
  br label %common.resume.i.i, !dbg !1751

_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtB4_3pin3PinINtNtCs6zY7rJBZy9D_5alloc5boxed3BoxNtNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutex5MutexEEECshxBJAVx362N_11runtime_lab.exit.i.i.i.i.i: ; preds = %bb2.i.i.i.i.i
; call __rustc::__rust_dealloc
  tail call void @_RNvCsdtSMxSA38aw_7___rustc14___rust_dealloc(ptr noundef nonnull %ptr.i.i.i.i, i64 noundef 64, i64 noundef 8) #20, !dbg !1752, !noalias !1744
  br label %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtNtCs1SSuMAdGM58_3std4sync6poison5mutex5MutexNtNtNtCs3EIJ1qnJmKW_5tokio4util4rand8FastRandEECshxBJAVx362N_11runtime_lab.exit, !dbg !1738

terminate.i.i:                                    ; preds = %cleanup.i.i
  %2 = landingpad { ptr, i32 }
          filter [0 x ptr] zeroinitializer
; call core::panicking::panic_in_cleanup
  tail call void @_RNvNtCsjIpoRzUjyHQ_4core9panicking16panic_in_cleanup() #22, !dbg !1713
  unreachable, !dbg !1713

_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtNtCs1SSuMAdGM58_3std4sync6poison5mutex5MutexNtNtNtCs3EIJ1qnJmKW_5tokio4util4rand8FastRandEECshxBJAVx362N_11runtime_lab.exit: ; preds = %bb4.i.i, %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtB4_3pin3PinINtNtCs6zY7rJBZy9D_5alloc5boxed3BoxNtNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutex5MutexEEECshxBJAVx362N_11runtime_lab.exit.i.i.i.i.i
  ret void, !dbg !1758
}

; core::ptr::drop_glue::<tokio::runtime::io::registration::Registration>
; Function Attrs: uwtable
define internal fastcc void @_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtNtNtCs3EIJ1qnJmKW_5tokio7runtime2io12registration12RegistrationECshxBJAVx362N_11runtime_lab(ptr noalias nofree noundef nonnull align 8 dereferenceable(24) %_1) unnamed_addr #2 personality ptr @rust_eh_personality !dbg !1759 !guid !1760 {
start:
; invoke <tokio::runtime::io::registration::Registration as core::ops::drop::Drop>::drop
  invoke void @_RNvXs1_NtNtNtCs3EIJ1qnJmKW_5tokio7runtime2io12registrationNtB5_12RegistrationNtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4drop(ptr noalias nofree noundef nonnull align 8 dereferenceable(24) %_1)
          to label %bb6 unwind label %cleanup, !dbg !1761

cleanup:                                          ; preds = %start
  %0 = landingpad { ptr, i32 }
          cleanup
; invoke core::ptr::drop_glue::<tokio::runtime::scheduler::Handle>
  invoke fastcc void @_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtNtCs3EIJ1qnJmKW_5tokio7runtime9scheduler6HandleECshxBJAVx362N_11runtime_lab(ptr noalias nofree noundef align 8 dereferenceable(16) %_1) #23
          to label %bb3 unwind label %terminate, !dbg !1761

bb6:                                              ; preds = %start
  tail call void @llvm.experimental.noalias.scope.decl(metadata !1762), !dbg !1761
  %_2.i = load i64, ptr %_1, align 8, !dbg !1765, !range !1659, !alias.scope !1762, !noundef !41
  %1 = getelementptr inbounds nuw i8, ptr %_1, i64 8, !dbg !1765
  %2 = icmp eq i64 %_2.i, 0, !dbg !1765
  br i1 %2, label %bb2.i, label %bb3.i, !dbg !1765

bb2.i:                                            ; preds = %bb6
  tail call void @llvm.experimental.noalias.scope.decl(metadata !1767), !dbg !1765
  tail call void @llvm.experimental.noalias.scope.decl(metadata !1770), !dbg !1773
  %_10.i.i.i = load ptr, ptr %1, align 8, !dbg !1775, !alias.scope !1779, !nonnull !41, !noundef !41
  %_2.i.i.i = atomicrmw sub ptr %_10.i.i.i, i64 1 release, align 8, !dbg !1780, !noalias !1779
  %3 = icmp eq i64 %_2.i.i.i, 1, !dbg !1783
  br i1 %3, label %bb2.i.i.i, label %bb5, !dbg !1783

bb2.i.i.i:                                        ; preds = %bb2.i
  fence acquire, !dbg !1784
; invoke <alloc::sync::Arc<tokio::runtime::scheduler::current_thread::Handle>>::drop_slow
  invoke void @_RNvMsn_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcNtNtNtNtCs3EIJ1qnJmKW_5tokio7runtime9scheduler14current_thread6HandleE9drop_slowBO_(ptr noalias nofree noundef nonnull align 8 dereferenceable(8) %1) #24
          to label %bb5 unwind label %cleanup1, !dbg !1786

bb3.i:                                            ; preds = %bb6
  tail call void @llvm.experimental.noalias.scope.decl(metadata !1787), !dbg !1765
  tail call void @llvm.experimental.noalias.scope.decl(metadata !1790), !dbg !1793
  %_10.i.i1.i = load ptr, ptr %1, align 8, !dbg !1795, !alias.scope !1799, !nonnull !41, !noundef !41
  %_2.i.i2.i = atomicrmw sub ptr %_10.i.i1.i, i64 1 release, align 8, !dbg !1800, !noalias !1799
  %4 = icmp eq i64 %_2.i.i2.i, 1, !dbg !1803
  br i1 %4, label %bb2.i.i3.i, label %bb5, !dbg !1803

bb2.i.i3.i:                                       ; preds = %bb3.i
  fence acquire, !dbg !1804
; invoke <alloc::sync::Arc<tokio::runtime::scheduler::multi_thread::handle::Handle>>::drop_slow
  invoke void @_RNvMsn_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcNtNtNtNtNtCs3EIJ1qnJmKW_5tokio7runtime9scheduler12multi_thread6handle6HandleE9drop_slowBQ_(ptr noalias nofree noundef nonnull align 8 dereferenceable(8) %1) #24
          to label %bb5 unwind label %cleanup1, !dbg !1806

bb3:                                              ; preds = %cleanup, %cleanup1
  %.pn = phi { ptr, i32 } [ %7, %cleanup1 ], [ %0, %cleanup ]
  %5 = getelementptr inbounds nuw i8, ptr %_1, i64 16, !dbg !1761
  tail call void @llvm.experimental.noalias.scope.decl(metadata !1807), !dbg !1761
  tail call void @llvm.experimental.noalias.scope.decl(metadata !1810), !dbg !1813
  %_10.i.i = load ptr, ptr %5, align 8, !dbg !1816, !alias.scope !1823, !nonnull !41, !noundef !41
  %_2.i.i = atomicrmw sub ptr %_10.i.i, i64 1 release, align 8, !dbg !1824, !noalias !1823
  %6 = icmp eq i64 %_2.i.i, 1, !dbg !1829
  br i1 %6, label %bb2.i.i, label %bb2, !dbg !1829

bb2.i.i:                                          ; preds = %bb3
  fence acquire, !dbg !1830
; invoke <alloc::sync::Arc<tokio::runtime::io::scheduled_io::ScheduledIo>>::drop_slow
  invoke void @_RNvMsn_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcNtNtNtNtCs3EIJ1qnJmKW_5tokio7runtime2io12scheduled_io11ScheduledIoE9drop_slowBO_(ptr noalias nofree noundef nonnull align 8 dereferenceable(8) %5) #24
          to label %bb2 unwind label %terminate, !dbg !1832

cleanup1:                                         ; preds = %bb2.i.i3.i, %bb2.i.i.i
  %7 = landingpad { ptr, i32 }
          cleanup
  br label %bb3

bb5:                                              ; preds = %bb3.i, %bb2.i, %bb2.i.i.i, %bb2.i.i3.i
  %8 = getelementptr inbounds nuw i8, ptr %_1, i64 16, !dbg !1761
  tail call void @llvm.experimental.noalias.scope.decl(metadata !1833), !dbg !1761
  tail call void @llvm.experimental.noalias.scope.decl(metadata !1836), !dbg !1839
  %_10.i.i5 = load ptr, ptr %8, align 8, !dbg !1841, !alias.scope !1845, !nonnull !41, !noundef !41
  %_2.i.i6 = atomicrmw sub ptr %_10.i.i5, i64 1 release, align 8, !dbg !1846, !noalias !1845
  %9 = icmp eq i64 %_2.i.i6, 1, !dbg !1849
  br i1 %9, label %bb2.i.i7, label %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc4sync3ArcNtNtNtNtCs3EIJ1qnJmKW_5tokio7runtime2io12scheduled_io11ScheduledIoEECshxBJAVx362N_11runtime_lab.exit8, !dbg !1849

bb2.i.i7:                                         ; preds = %bb5
  fence acquire, !dbg !1850
; call <alloc::sync::Arc<tokio::runtime::io::scheduled_io::ScheduledIo>>::drop_slow
  tail call void @_RNvMsn_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcNtNtNtNtCs3EIJ1qnJmKW_5tokio7runtime2io12scheduled_io11ScheduledIoE9drop_slowBO_(ptr noalias nofree noundef nonnull align 8 dereferenceable(8) %8) #24, !dbg !1852
  br label %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc4sync3ArcNtNtNtNtCs3EIJ1qnJmKW_5tokio7runtime2io12scheduled_io11ScheduledIoEECshxBJAVx362N_11runtime_lab.exit8, !dbg !1852

_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc4sync3ArcNtNtNtNtCs3EIJ1qnJmKW_5tokio7runtime2io12scheduled_io11ScheduledIoEECshxBJAVx362N_11runtime_lab.exit8: ; preds = %bb5, %bb2.i.i7
  ret void, !dbg !1761

terminate:                                        ; preds = %bb2.i.i, %cleanup
  %10 = landingpad { ptr, i32 }
          filter [0 x ptr] zeroinitializer
; call core::panicking::panic_in_cleanup
  tail call void @_RNvNtCsjIpoRzUjyHQ_4core9panicking16panic_in_cleanup() #22, !dbg !1761
  unreachable, !dbg !1761

bb2:                                              ; preds = %bb3, %bb2.i.i
  resume { ptr, i32 } %.pn, !dbg !1761
}

; core::panicking::assert_failed::<core::option::Option<core::ptr::non_null::NonNull<tokio::runtime::task::core::Header>>, core::option::Option<core::ptr::non_null::NonNull<tokio::runtime::task::core::Header>>>
; Function Attrs: cold minsize noinline noreturn optsize uwtable
define void @_RINvNtCsjIpoRzUjyHQ_4core9panicking13assert_failedINtNtB4_6option6OptionINtNtNtB4_3ptr8non_null7NonNullNtNtNtNtCs3EIJ1qnJmKW_5tokio7runtime4task4core6HeaderEEBM_ECshxBJAVx362N_11runtime_lab(i8 noundef range(i8 0, 3) %kind, ptr noalias nofree noundef readonly align 8 captures(address, read_provenance) dereferenceable(8) %0, ptr noalias nofree noundef readonly align 8 captures(address, read_provenance) dereferenceable(8) %1, ptr noundef %args.0, ptr %args.1, ptr noalias nofree noundef readonly align 8 captures(address, read_provenance) dereferenceable(24) %2) unnamed_addr #4 !dbg !1853 !guid !1856 {
start:
  %right = alloca [8 x i8], align 8
  %left = alloca [8 x i8], align 8
  store ptr %0, ptr %left, align 8
  store ptr %1, ptr %right, align 8
; call core::panicking::assert_failed_inner
  call void @_RNvNtCsjIpoRzUjyHQ_4core9panicking19assert_failed_inner(i8 noundef %kind, ptr noundef nonnull %left, ptr noalias nofree noundef readonly align 8 captures(address, read_provenance) dereferenceable(32) @vtable.1, ptr noundef nonnull %right, ptr noalias nofree noundef readonly align 8 captures(address, read_provenance) dereferenceable(32) @vtable.1, ptr noundef %args.0, ptr %args.1, ptr noalias nofree noundef nonnull readonly align 8 captures(address, read_provenance) dereferenceable(24) %2) #25, !dbg !1857
  unreachable, !dbg !1857
}

; <std::sync::once::Once>::call_once_force::<<std::sync::once_lock::OnceLock<core::option::Option<unsafe extern "C" fn(*mut i32, i32) -> i32>>>::initialize<<std::sync::once_lock::OnceLock<core::option::Option<unsafe extern "C" fn(*mut i32, i32) -> i32>>>::get_or_init<runtime_lab::process::macos::pipe_cloexec::{closure#0}>::{closure#0}, !>::{closure#0}>::{closure#0}
; Function Attrs: inlinehint uwtable
define internal void @_RNCINvMs0_NtNtCs1SSuMAdGM58_3std4sync4onceNtB8_4Once15call_once_forceNCINvMNtBa_9once_lockINtB1b_8OnceLockINtNtCsjIpoRzUjyHQ_4core6option6OptionFUKCOllElEE10initializeNCINvB1a_11get_or_initNCNvNtNtCshxBJAVx362N_11runtime_lab7process5macos12pipe_cloexec0E0zE0E0B39_(ptr noalias nofree noundef readonly align 8 captures(none) dereferenceable(8) %_1, ptr nofree nonnull readnone align 8 captures(none) %p) unnamed_addr #5 personality ptr @rust_eh_personality !dbg !1858 !guid !1861 {
start:
  %self1 = load ptr, ptr %_1, align 8, !dbg !1862, !nonnull !41, !align !1250, !noundef !41
  %0 = load ptr, ptr %self1, align 8, !dbg !1863, !align !1250, !noundef !41
  store ptr null, ptr %self1, align 8, !dbg !1868
  %.not = icmp eq ptr %0, null, !dbg !1870
  br i1 %.not, label %bb3, label %bb4, !dbg !1873, !prof !135

bb4:                                              ; preds = %start
  %symbol.i.i.i = tail call noundef ptr @dlsym(ptr noundef nonnull inttoptr (i64 -2 to ptr), ptr noundef nonnull @alloc_99fa3dadd3dc410db62b2449899e8038) #20, !dbg !1874
  store ptr %symbol.i.i.i, ptr %0, align 8, !dbg !1889
  ret void, !dbg !1896

bb3:                                              ; preds = %start
; call core::option::unwrap_failed
  tail call void @_RNvNtCsjIpoRzUjyHQ_4core6option13unwrap_failed(ptr noalias nofree noundef readonly align 8 captures(address, read_provenance) dereferenceable(24) @alloc_696290a743386ff4d3c84dceb79925aa) #25, !dbg !1897
  unreachable, !dbg !1897
}

; <<std::sync::once::Once>::call_once_force<<std::sync::once_lock::OnceLock<core::option::Option<unsafe extern "C" fn(*mut i32, i32) -> i32>>>::initialize<<std::sync::once_lock::OnceLock<core::option::Option<unsafe extern "C" fn(*mut i32, i32) -> i32>>>::get_or_init<runtime_lab::process::macos::pipe_cloexec::{closure#0}>::{closure#0}, !>::{closure#0}>::{closure#0} as core::ops::function::FnOnce<(&std::sync::once::OnceState,)>>::call_once::{shim:vtable#0}
; Function Attrs: inlinehint uwtable
define internal void @_RNSNvYNCINvMs0_NtNtCs1SSuMAdGM58_3std4sync4onceNtBd_4Once15call_once_forceNCINvMNtBf_9once_lockINtB1g_8OnceLockINtNtCsjIpoRzUjyHQ_4core6option6OptionFUKCOllElEE10initializeNCINvB1f_11get_or_initNCNvNtNtCshxBJAVx362N_11runtime_lab7process5macos12pipe_cloexec0E0zE0E0INtNtNtB1Q_3ops8function6FnOnceTRNtBd_9OnceStateEE9call_once6vtableB3e_(ptr nofree noundef readonly captures(none) %_1, ptr nofree nonnull readnone align 8 captures(none) %0) unnamed_addr #5 personality ptr @rust_eh_personality !dbg !1898 !guid !1903 {
start:
  %1 = load ptr, ptr %_1, align 8, !dbg !1904, !nonnull !41, !align !1250, !noundef !41
  tail call void @llvm.experimental.noalias.scope.decl(metadata !1905), !dbg !1904
  %2 = load ptr, ptr %1, align 8, !dbg !1908, !alias.scope !1905, !noalias !1914, !align !1250, !noundef !41
  store ptr null, ptr %1, align 8, !dbg !1917, !alias.scope !1905, !noalias !1914
  %.not.i.i = icmp eq ptr %2, null, !dbg !1918
  br i1 %.not.i.i, label %bb3.i.i, label %_RNvYNCINvMs0_NtNtCs1SSuMAdGM58_3std4sync4onceNtBb_4Once15call_once_forceNCINvMNtBd_9once_lockINtB1e_8OnceLockINtNtCsjIpoRzUjyHQ_4core6option6OptionFUKCOllElEE10initializeNCINvB1d_11get_or_initNCNvNtNtCshxBJAVx362N_11runtime_lab7process5macos12pipe_cloexec0E0zE0E0INtNtNtB1O_3ops8function6FnOnceTRNtBb_9OnceStateEE9call_onceB3c_.exit, !dbg !1920, !prof !135

bb3.i.i:                                          ; preds = %start
; call core::option::unwrap_failed
  tail call void @_RNvNtCsjIpoRzUjyHQ_4core6option13unwrap_failed(ptr noalias nofree noundef readonly align 8 captures(address, read_provenance) dereferenceable(24) @alloc_696290a743386ff4d3c84dceb79925aa) #25, !dbg !1921, !noalias !1922
  unreachable, !dbg !1921

_RNvYNCINvMs0_NtNtCs1SSuMAdGM58_3std4sync4onceNtBb_4Once15call_once_forceNCINvMNtBd_9once_lockINtB1e_8OnceLockINtNtCsjIpoRzUjyHQ_4core6option6OptionFUKCOllElEE10initializeNCINvB1d_11get_or_initNCNvNtNtCshxBJAVx362N_11runtime_lab7process5macos12pipe_cloexec0E0zE0E0INtNtNtB1O_3ops8function6FnOnceTRNtBb_9OnceStateEE9call_onceB3c_.exit: ; preds = %start
  %symbol.i.i.i.i.i = tail call noundef ptr @dlsym(ptr noundef nonnull inttoptr (i64 -2 to ptr), ptr noundef nonnull @alloc_99fa3dadd3dc410db62b2449899e8038) #20, !dbg !1923, !noalias !1922
  store ptr %symbol.i.i.i.i.i, ptr %2, align 8, !dbg !1927, !noalias !1922
  ret void, !dbg !1904
}

; runtime_lab::multi_runtime
; Function Attrs: uwtable
define void @_RNvCshxBJAVx362N_11runtime_lab13multi_runtime(ptr dead_on_unwind noalias nofree noundef writable sret([88 x i8]) align 8 captures(address) dereferenceable(88) %_0, i64 noundef %workers) unnamed_addr #2 personality ptr @rust_eh_personality !dbg !1929 !guid !1931 {
start:
  %_4 = alloca [264 x i8], align 8
  call void @llvm.lifetime.start.p0(ptr nonnull %_4), !dbg !1932
; call <tokio::runtime::builder::Builder>::new_multi_thread
  call void @_RNvMNtNtCs3EIJ1qnJmKW_5tokio7runtime7builderNtB2_7Builder16new_multi_thread(ptr noalias nofree noundef nonnull sret([264 x i8]) align 8 captures(address) dereferenceable(264) %_4), !dbg !1932
; invoke <tokio::runtime::builder::Builder>::worker_threads
  %_2 = invoke noundef nonnull align 8 ptr @_RNvMNtNtCs3EIJ1qnJmKW_5tokio7runtime7builderNtB2_7Builder14worker_threads(ptr noalias nofree noundef nonnull align 8 dereferenceable(264) %_4, i64 noundef %workers, ptr noalias nofree noundef readonly align 8 captures(address, read_provenance) dereferenceable(24) @alloc_76a4682140362797ca7b20487d943f78)
          to label %bb2 unwind label %cleanup, !dbg !1933

cleanup:                                          ; preds = %bb2, %start
  %0 = landingpad { ptr, i32 }
          cleanup
; invoke core::ptr::drop_glue::<tokio::runtime::builder::Builder>
  invoke fastcc void @_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtNtCs3EIJ1qnJmKW_5tokio7runtime7builder7BuilderECshxBJAVx362N_11runtime_lab(ptr noalias nofree noundef align 8 dereferenceable(264) %_4) #23
          to label %bb6 unwind label %terminate, !dbg !1934

bb2:                                              ; preds = %start
  %1 = getelementptr inbounds nuw i8, ptr %_2, i64 253, !dbg !1935
  store i8 1, ptr %1, align 1, !dbg !1935
  %2 = getelementptr inbounds nuw i8, ptr %_2, i64 254, !dbg !1943
  store i8 1, ptr %2, align 2, !dbg !1943
; invoke <tokio::runtime::builder::Builder>::build
  invoke void @_RNvMNtNtCs3EIJ1qnJmKW_5tokio7runtime7builderNtB2_7Builder5build(ptr noalias nofree noundef nonnull sret([88 x i8]) align 8 captures(address) dereferenceable(88) %_0, ptr noalias nofree noundef nonnull align 8 dereferenceable(264) %_2)
          to label %bb3 unwind label %cleanup, !dbg !1946

bb3:                                              ; preds = %bb2
; call core::ptr::drop_glue::<tokio::runtime::builder::Builder>
  call fastcc void @_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtNtCs3EIJ1qnJmKW_5tokio7runtime7builder7BuilderECshxBJAVx362N_11runtime_lab(ptr noalias nofree noundef align 8 dereferenceable(264) %_4), !dbg !1934
  call void @llvm.lifetime.end.p0(ptr nonnull %_4), !dbg !1934
  ret void, !dbg !1947

terminate:                                        ; preds = %cleanup
  %3 = landingpad { ptr, i32 }
          filter [0 x ptr] zeroinitializer
; call core::panicking::panic_in_cleanup
  call void @_RNvNtCsjIpoRzUjyHQ_4core9panicking16panic_in_cleanup() #22, !dbg !1948
  unreachable, !dbg !1948

bb6:                                              ; preds = %cleanup
  resume { ptr, i32 } %0, !dbg !1948
}

; runtime_lab::current_runtime
; Function Attrs: uwtable
define void @_RNvCshxBJAVx362N_11runtime_lab15current_runtime(ptr dead_on_unwind noalias nofree noundef writable sret([88 x i8]) align 8 captures(address) dereferenceable(88) %_0) unnamed_addr #2 personality ptr @rust_eh_personality !dbg !1949 !guid !1950 {
start:
  %_2 = alloca [264 x i8], align 8
  call void @llvm.lifetime.start.p0(ptr nonnull %_2), !dbg !1951
; call <tokio::runtime::builder::Builder>::new_current_thread
  call void @_RNvMNtNtCs3EIJ1qnJmKW_5tokio7runtime7builderNtB2_7Builder18new_current_thread(ptr noalias nofree noundef nonnull sret([264 x i8]) align 8 captures(address) dereferenceable(264) %_2), !dbg !1951
  %0 = getelementptr inbounds nuw i8, ptr %_2, i64 253, !dbg !1952
  store i8 1, ptr %0, align 1, !dbg !1952
  %1 = getelementptr inbounds nuw i8, ptr %_2, i64 254, !dbg !1957
  store i8 1, ptr %1, align 2, !dbg !1957
; invoke <tokio::runtime::builder::Builder>::build
  invoke void @_RNvMNtNtCs3EIJ1qnJmKW_5tokio7runtime7builderNtB2_7Builder5build(ptr noalias nofree noundef nonnull sret([88 x i8]) align 8 captures(address) dereferenceable(88) %_0, ptr noalias nofree noundef nonnull align 8 dereferenceable(264) %_2)
          to label %bb2 unwind label %cleanup, !dbg !1960

cleanup:                                          ; preds = %start
  %2 = landingpad { ptr, i32 }
          cleanup
; invoke core::ptr::drop_glue::<tokio::runtime::builder::Builder>
  invoke fastcc void @_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtNtCs3EIJ1qnJmKW_5tokio7runtime7builder7BuilderECshxBJAVx362N_11runtime_lab(ptr noalias nofree noundef align 8 dereferenceable(264) %_2) #23
          to label %bb5 unwind label %terminate, !dbg !1961

bb2:                                              ; preds = %start
; call core::ptr::drop_glue::<tokio::runtime::builder::Builder>
  call fastcc void @_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtNtCs3EIJ1qnJmKW_5tokio7runtime7builder7BuilderECshxBJAVx362N_11runtime_lab(ptr noalias nofree noundef align 8 dereferenceable(264) %_2), !dbg !1961
  call void @llvm.lifetime.end.p0(ptr nonnull %_2), !dbg !1961
  ret void, !dbg !1962

terminate:                                        ; preds = %cleanup
  %3 = landingpad { ptr, i32 }
          filter [0 x ptr] zeroinitializer
; call core::panicking::panic_in_cleanup
  call void @_RNvNtCsjIpoRzUjyHQ_4core9panicking16panic_in_cleanup() #22, !dbg !1963
  unreachable, !dbg !1963

bb5:                                              ; preds = %cleanup
  resume { ptr, i32 } %2, !dbg !1963
}

; <runtime_lab::wire::Frame>::decode
; Function Attrs: uwtable
define void @_RNvMNtCshxBJAVx362N_11runtime_lab4wireNtB2_5Frame6decode(ptr dead_on_unwind noalias nofree noundef writable writeonly sret([24 x i8]) align 8 captures(none) dereferenceable(24) initializes((0, 16)) %_0, ptr noalias nofree noundef readonly align 1 captures(none) dead_on_return dereferenceable(24) %bytes) unnamed_addr #2 !dbg !1964 !guid !1968 {
start:
  %_62 = load i16, ptr %bytes, align 1, !dbg !1969, !noundef !41
  %_33.not = icmp eq i16 %_62, 1, !dbg !1969
  %_38 = getelementptr inbounds nuw i8, ptr %bytes, i64 2
  %_63 = load i16, ptr %_38, align 1
  %_42.not = icmp eq i16 %_63, 0
  %or.cond = select i1 %_33.not, i1 %_42.not, i1 false, !dbg !1984
  %_47 = getelementptr inbounds nuw i8, ptr %bytes, i64 4
  %_64 = load i32, ptr %_47, align 1
  %_51.not = icmp eq i32 %_64, 24
  %or.cond1 = select i1 %or.cond, i1 %_51.not, i1 false, !dbg !1984
  br i1 %or.cond1, label %bb5, label %bb3, !dbg !1984

bb3:                                              ; preds = %start
; call <core::io::error::Error>::new::<&str>
  %_8 = tail call noundef nonnull ptr @_RINvMNtNtCs6zY7rJBZy9D_5alloc2io5errorNtNtNtCsjIpoRzUjyHQ_4core2io5error5Error3newReECs1SSuMAdGM58_3std(i8 noundef 21, ptr noalias nofree noundef nonnull readonly captures(address, read_provenance) @alloc_80e4d5a6503ea68c559c0291c1b805b6, i64 noundef 28) #24, !dbg !1985
  br label %bb6, !dbg !1986

bb5:                                              ; preds = %start
  %_56 = getelementptr inbounds nuw i8, ptr %bytes, i64 8, !dbg !1987
  %id.sroa.0.0.copyload = load i64, ptr %_56, align 1, !dbg !2008, !alias.scope !2017, !noalias !2021
  %_61 = getelementptr inbounds nuw i8, ptr %bytes, i64 16, !dbg !2023
  %value.sroa.0.0.copyload = load i64, ptr %_61, align 1, !dbg !2033, !alias.scope !2037, !noalias !2041
  %0 = inttoptr i64 %id.sroa.0.0.copyload to ptr, !dbg !2043
  %1 = getelementptr inbounds nuw i8, ptr %_0, i64 16, !dbg !2044
  store i64 %value.sroa.0.0.copyload, ptr %1, align 8, !dbg !2044
  br label %bb6, !dbg !1986

bb6:                                              ; preds = %bb3, %bb5
  %_8.sink = phi ptr [ %0, %bb5 ], [ %_8, %bb3 ], !dbg !2043
  %storemerge = phi i64 [ 0, %bb5 ], [ 1, %bb3 ], !dbg !2043
  %2 = getelementptr inbounds nuw i8, ptr %_0, i64 8, !dbg !2043
  store ptr %_8.sink, ptr %2, align 8, !dbg !2043
  store i64 %storemerge, ptr %_0, align 8, !dbg !2043
  ret void, !dbg !1986
}

; <runtime_lab::wire::Frame>::encode
; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: write) uwtable
define void @_RNvMNtCshxBJAVx362N_11runtime_lab4wireNtB2_5Frame6encode(ptr dead_on_unwind noalias nofree noundef writable writeonly sret([24 x i8]) align 1 captures(none) dereferenceable(24) initializes((0, 24)) %_0, i64 noundef %self.0, i64 noundef %self.1) unnamed_addr #6 !dbg !2045 !guid !2046 {
start:
  store i16 1, ptr %_0, align 1, !dbg !2047
  %bytes.sroa.5.0._0.sroa_idx = getelementptr inbounds nuw i8, ptr %_0, i64 2, !dbg !2047
  store i16 0, ptr %bytes.sroa.5.0._0.sroa_idx, align 1, !dbg !2047
  %bytes.sroa.5.sroa.4.0.bytes.sroa.5.0._0.sroa_idx.sroa_idx = getelementptr inbounds nuw i8, ptr %_0, i64 4, !dbg !2047
  store i32 24, ptr %bytes.sroa.5.sroa.4.0.bytes.sroa.5.0._0.sroa_idx.sroa_idx, align 1, !dbg !2047
  %bytes.sroa.6.0._0.sroa_idx = getelementptr inbounds nuw i8, ptr %_0, i64 8, !dbg !2047
  store i64 %self.0, ptr %bytes.sroa.6.0._0.sroa_idx, align 1, !dbg !2047
  %bytes.sroa.7.0._0.sroa_idx = getelementptr inbounds nuw i8, ptr %_0, i64 16, !dbg !2047
  store i64 %self.1, ptr %bytes.sroa.7.0._0.sroa_idx, align 1, !dbg !2047
  ret void, !dbg !2049
}

; <alloc::sync::Arc<std::sync::poison::mutex::Mutex<runtime_lab::process::Capture>>>::drop_slow
; Function Attrs: noinline uwtable
define void @_RNvMsn_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcINtNtNtNtCs1SSuMAdGM58_3std4sync6poison5mutex5MutexNtNtCshxBJAVx362N_11runtime_lab7process7CaptureEE9drop_slowB1z_(ptr noalias nofree noundef readonly align 8 captures(none) dereferenceable(8) %self) unnamed_addr #7 personality ptr @rust_eh_personality !dbg !2050 !guid !2051 {
start:
  %_3 = load ptr, ptr %self, align 8, !dbg !2052, !nonnull !41, !noundef !41
  %_9 = getelementptr inbounds nuw i8, ptr %_3, i64 16, !dbg !2053
; invoke <std::sys::sync::mutex::pthread::Mutex as core::ops::drop::Drop>::drop
  invoke void @_RNvXs_NtNtNtNtCs1SSuMAdGM58_3std3sys4sync5mutex7pthreadNtB4_5MutexNtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4drop(ptr noalias nofree noundef nonnull align 8 dereferenceable(168) %_9)
          to label %bb4.i.i unwind label %cleanup.i.i, !dbg !2057

cleanup.i.i:                                      ; preds = %start
  %0 = landingpad { ptr, i32 }
          cleanup
; invoke core::ptr::drop_glue::<std::sys::sync::once_box::OnceBox<std::sys::pal::unix::sync::mutex::Mutex>>
  invoke fastcc void @_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtNtCs1SSuMAdGM58_3std3sys4sync8once_box7OnceBoxNtNtNtNtNtBI_3pal4unix4sync5mutex5MutexEECshxBJAVx362N_11runtime_lab(ptr noalias nofree noundef nonnull align 8 dereferenceable(168) %_9) #23
          to label %cleanup.body.i unwind label %terminate.i.i, !dbg !2057

bb4.i.i:                                          ; preds = %start
  tail call void @llvm.experimental.noalias.scope.decl(metadata !2061), !dbg !2057
  tail call void @llvm.experimental.noalias.scope.decl(metadata !2064), !dbg !2067
  %ptr.i.i.i.i = load ptr, ptr %_9, align 8, !dbg !2069, !alias.scope !2073, !noundef !41
  store ptr null, ptr %_9, align 8, !dbg !2078, !alias.scope !2073
  %_5.i.i.i.i = icmp eq ptr %ptr.i.i.i.i, null, !dbg !2079
  br i1 %_5.i.i.i.i, label %bb4.i, label %bb2.i.i.i.i.i, !dbg !2083

bb2.i.i.i.i.i:                                    ; preds = %bb4.i.i
; invoke <std::sys::pal::unix::sync::mutex::Mutex as core::ops::drop::Drop>::drop
  invoke void @_RNvXs2_NtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutexNtB5_5MutexNtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4drop(ptr noundef nonnull align 8 %ptr.i.i.i.i)
          to label %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtB4_3pin3PinINtNtCs6zY7rJBZy9D_5alloc5boxed3BoxNtNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutex5MutexEEECshxBJAVx362N_11runtime_lab.exit.i.i.i.i.i unwind label %bb2.i.i.i.i.i.i.i, !dbg !2085, !noalias !2089

bb2.i.i.i.i.i.i.i:                                ; preds = %bb2.i.i.i.i.i
  %1 = landingpad { ptr, i32 }
          cleanup
; call __rustc::__rust_dealloc
  tail call void @_RNvCsdtSMxSA38aw_7___rustc14___rust_dealloc(ptr noundef nonnull %ptr.i.i.i.i, i64 noundef 64, i64 noundef 8) #20, !dbg !2090, !noalias !2089
  br label %cleanup.body.i, !dbg !2096

_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtB4_3pin3PinINtNtCs6zY7rJBZy9D_5alloc5boxed3BoxNtNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutex5MutexEEECshxBJAVx362N_11runtime_lab.exit.i.i.i.i.i: ; preds = %bb2.i.i.i.i.i
; call __rustc::__rust_dealloc
  tail call void @_RNvCsdtSMxSA38aw_7___rustc14___rust_dealloc(ptr noundef nonnull %ptr.i.i.i.i, i64 noundef 64, i64 noundef 8) #20, !dbg !2097, !noalias !2089
  br label %bb4.i, !dbg !2083

terminate.i.i:                                    ; preds = %cleanup.i.i
  %2 = landingpad { ptr, i32 }
          filter [0 x ptr] zeroinitializer
; call core::panicking::panic_in_cleanup
  tail call void @_RNvNtCsjIpoRzUjyHQ_4core9panicking16panic_in_cleanup() #22, !dbg !2057
  unreachable, !dbg !2057

cleanup.body.i:                                   ; preds = %bb2.i.i.i.i.i.i.i, %cleanup.i.i
  %eh.lpad-body.i = phi { ptr, i32 } [ %0, %cleanup.i.i ], [ %1, %bb2.i.i.i.i.i.i.i ]
  %3 = getelementptr inbounds nuw i8, ptr %_3, i64 32, !dbg !2103
; call core::ptr::drop_glue::<core::cell::UnsafeCell<runtime_lab::process::Capture>>
  tail call fastcc void @_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtB4_4cell10UnsafeCellNtNtCshxBJAVx362N_11runtime_lab7process7CaptureEEB14_(ptr noalias nofree noundef align 8 dereferenceable(152) %3) #23, !dbg !2103
  %_16.i.i = icmp eq ptr %_3, inttoptr (i64 -1 to ptr), !dbg !2104
  br i1 %_16.i.i, label %bb3, label %bb8.i.i, !dbg !2119

bb4.i:                                            ; preds = %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtB4_3pin3PinINtNtCs6zY7rJBZy9D_5alloc5boxed3BoxNtNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutex5MutexEEECshxBJAVx362N_11runtime_lab.exit.i.i.i.i.i, %bb4.i.i
  %4 = getelementptr inbounds nuw i8, ptr %_3, i64 32, !dbg !2103
  tail call void @llvm.experimental.noalias.scope.decl(metadata !2120), !dbg !2103
  tail call void @llvm.experimental.noalias.scope.decl(metadata !2123), !dbg !2126
  %_1.val.i.i.i = load i64, ptr %4, align 8, !dbg !2128, !alias.scope !2130
  %5 = icmp eq i64 %_1.val.i.i.i, 0, !dbg !2131
  br i1 %5, label %bb4.i.i.i, label %_RNvXs1_NtCs6zY7rJBZy9D_5alloc5allocNtB5_6GlobalNtNtCsjIpoRzUjyHQ_4core5alloc9Allocator10deallocate.exit.i.i.i4.i.i.i.i, !dbg !2131

_RNvXs1_NtCs6zY7rJBZy9D_5alloc5allocNtB5_6GlobalNtNtCsjIpoRzUjyHQ_4core5alloc9Allocator10deallocate.exit.i.i.i4.i.i.i.i: ; preds = %bb4.i
  %6 = getelementptr inbounds nuw i8, ptr %_3, i64 40, !dbg !2128
  %_1.val1.i.i.i = load ptr, ptr %6, align 8, !dbg !2128, !alias.scope !2130, !nonnull !41, !noundef !41
; call __rustc::__rust_dealloc
  tail call void @_RNvCsdtSMxSA38aw_7___rustc14___rust_dealloc(ptr noundef nonnull %_1.val1.i.i.i, i64 noundef %_1.val.i.i.i, i64 noundef range(i64 1, -9223372036854775807) 1) #20, !dbg !2137, !noalias !2142
  br label %bb4.i.i.i, !dbg !2143

bb4.i.i.i:                                        ; preds = %_RNvXs1_NtCs6zY7rJBZy9D_5alloc5allocNtB5_6GlobalNtNtCsjIpoRzUjyHQ_4core5alloc9Allocator10deallocate.exit.i.i.i4.i.i.i.i, %bb4.i
  %7 = getelementptr inbounds nuw i8, ptr %_3, i64 56, !dbg !2128
  %.val3.i.i.i = load i64, ptr %7, align 8, !dbg !2128, !range !246, !alias.scope !2130, !noundef !41
  %8 = icmp sgt i64 %.val3.i.i.i, 0, !dbg !2144
  br i1 %8, label %_RNvXs1_NtCs6zY7rJBZy9D_5alloc5allocNtB5_6GlobalNtNtCsjIpoRzUjyHQ_4core5alloc9Allocator10deallocate.exit.i.i.i4.i.i.i.i7.i.i.i, label %bb4, !dbg !2144

_RNvXs1_NtCs6zY7rJBZy9D_5alloc5allocNtB5_6GlobalNtNtCsjIpoRzUjyHQ_4core5alloc9Allocator10deallocate.exit.i.i.i4.i.i.i.i7.i.i.i: ; preds = %bb4.i.i.i
  %9 = getelementptr inbounds nuw i8, ptr %_3, i64 64, !dbg !2128
  %.val4.i.i.i = load ptr, ptr %9, align 8, !dbg !2128, !alias.scope !2130, !nonnull !41, !noundef !41
; call __rustc::__rust_dealloc
  tail call void @_RNvCsdtSMxSA38aw_7___rustc14___rust_dealloc(ptr noundef nonnull %.val4.i.i.i, i64 noundef %.val3.i.i.i, i64 noundef range(i64 1, -9223372036854775807) 1) #20, !dbg !2147, !noalias !2142
  br label %bb4, !dbg !2157

bb8.i.i:                                          ; preds = %cleanup.body.i
  %_20.i.i = getelementptr inbounds nuw i8, ptr %_3, i64 8, !dbg !2158
  %_3.i.i = atomicrmw sub ptr %_20.i.i, i64 1 release, align 8, !dbg !2159
  %10 = icmp eq i64 %_3.i.i, 1, !dbg !2165
  br i1 %10, label %bb1.i.i, label %bb3, !dbg !2165

bb1.i.i:                                          ; preds = %bb8.i.i
  fence acquire, !dbg !2166
; call __rustc::__rust_dealloc
  tail call void @_RNvCsdtSMxSA38aw_7___rustc14___rust_dealloc(ptr noundef nonnull %_3, i64 noundef 184, i64 noundef 8) #20, !dbg !2168
  br label %bb3, !dbg !2177

bb4:                                              ; preds = %_RNvXs1_NtCs6zY7rJBZy9D_5alloc5allocNtB5_6GlobalNtNtCsjIpoRzUjyHQ_4core5alloc9Allocator10deallocate.exit.i.i.i4.i.i.i.i7.i.i.i, %bb4.i.i.i
  %_16.i.i3 = icmp eq ptr %_3, inttoptr (i64 -1 to ptr), !dbg !2178
  br i1 %_16.i.i3, label %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc4sync4WeakINtNtNtNtCs1SSuMAdGM58_3std4sync6poison5mutex5MutexNtNtCshxBJAVx362N_11runtime_lab7process7CaptureERNtNtBG_5alloc6GlobalEEB23_.exit8, label %bb8.i.i4, !dbg !2183

bb8.i.i4:                                         ; preds = %bb4
  %_20.i.i5 = getelementptr inbounds nuw i8, ptr %_3, i64 8, !dbg !2184
  %_3.i.i6 = atomicrmw sub ptr %_20.i.i5, i64 1 release, align 8, !dbg !2185
  %11 = icmp eq i64 %_3.i.i6, 1, !dbg !2188
  br i1 %11, label %bb1.i.i7, label %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc4sync4WeakINtNtNtNtCs1SSuMAdGM58_3std4sync6poison5mutex5MutexNtNtCshxBJAVx362N_11runtime_lab7process7CaptureERNtNtBG_5alloc6GlobalEEB23_.exit8, !dbg !2188

bb1.i.i7:                                         ; preds = %bb8.i.i4
  fence acquire, !dbg !2189
; call __rustc::__rust_dealloc
  tail call void @_RNvCsdtSMxSA38aw_7___rustc14___rust_dealloc(ptr noundef nonnull %_3, i64 noundef 184, i64 noundef 8) #20, !dbg !2191
  br label %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc4sync4WeakINtNtNtNtCs1SSuMAdGM58_3std4sync6poison5mutex5MutexNtNtCshxBJAVx362N_11runtime_lab7process7CaptureERNtNtBG_5alloc6GlobalEEB23_.exit8, !dbg !2197

_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc4sync4WeakINtNtNtNtCs1SSuMAdGM58_3std4sync6poison5mutex5MutexNtNtCshxBJAVx362N_11runtime_lab7process7CaptureERNtNtBG_5alloc6GlobalEEB23_.exit8: ; preds = %bb4, %bb8.i.i4, %bb1.i.i7
  ret void, !dbg !2198

bb3:                                              ; preds = %bb1.i.i, %bb8.i.i, %cleanup.body.i
  resume { ptr, i32 } %eh.lpad-body.i, !dbg !2199
}

; runtime_lab::process::state_lock
; Function Attrs: uwtable
define void @_RNvNtCshxBJAVx362N_11runtime_lab7process10state_lock(ptr dead_on_unwind noalias nofree noundef writable writeonly sret([16 x i8]) align 8 captures(none) dereferenceable(16) %_0, ptr noundef nonnull align 8 %state) unnamed_addr #2 personality ptr @rust_eh_personality !dbg !2200 !guid !2202 {
start:
  %0 = load atomic ptr, ptr %state acquire, align 8, !dbg !2203, !noalias !2213
  %_11.i.i = icmp eq ptr %0, null, !dbg !2216
  br i1 %_11.i.i, label %bb7.i.i, label %_RINvMNtNtNtCs1SSuMAdGM58_3std3sys4sync8once_boxINtB3_7OnceBoxNtNtNtNtNtB7_3pal4unix4sync5mutex5MutexE11get_or_initNCNvMNtNtB5_5mutex7pthreadNtB1T_5Mutex3get0ECshxBJAVx362N_11runtime_lab.exit.i, !dbg !2221, !prof !135

bb7.i.i:                                          ; preds = %start
; call <std::sys::sync::once_box::OnceBox<std::sys::pal::unix::sync::mutex::Mutex>>::initialize::<<std::sys::sync::mutex::pthread::Mutex>::get::{closure#0}>
  %1 = tail call fastcc noundef nonnull align 8 ptr @_RINvMNtNtNtCs1SSuMAdGM58_3std3sys4sync8once_boxINtB3_7OnceBoxNtNtNtNtNtB7_3pal4unix4sync5mutex5MutexE10initializeNCNvMNtNtB5_5mutex7pthreadNtB1S_5Mutex3get0ECshxBJAVx362N_11runtime_lab(ptr noundef nonnull align 8 %state), !dbg !2222, !noalias !2213
  br label %_RINvMNtNtNtCs1SSuMAdGM58_3std3sys4sync8once_boxINtB3_7OnceBoxNtNtNtNtNtB7_3pal4unix4sync5mutex5MutexE11get_or_initNCNvMNtNtB5_5mutex7pthreadNtB1T_5Mutex3get0ECshxBJAVx362N_11runtime_lab.exit.i, !dbg !2223

_RINvMNtNtNtCs1SSuMAdGM58_3std3sys4sync8once_boxINtB3_7OnceBoxNtNtNtNtNtB7_3pal4unix4sync5mutex5MutexE11get_or_initNCNvMNtNtB5_5mutex7pthreadNtB1T_5Mutex3get0ECshxBJAVx362N_11runtime_lab.exit.i: ; preds = %bb7.i.i, %start
  %_0.sroa.0.0.i.i = phi ptr [ %1, %bb7.i.i ], [ %0, %start ], !dbg !2224
; call <std::sys::pal::unix::sync::mutex::Mutex>::lock
  tail call void @_RNvMNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutexNtB2_5Mutex4lock(ptr noundef nonnull align 8 %_0.sroa.0.0.i.i), !dbg !2225, !noalias !2213
  %2 = load atomic i64, ptr @_RNvNtNtCs1SSuMAdGM58_3std9panicking11panic_count18GLOBAL_PANIC_COUNT monotonic, align 8, !dbg !2226, !noalias !2213
  %_7.i.i = and i64 %2, 9223372036854775807, !dbg !2235
  %3 = icmp eq i64 %_7.i.i, 0, !dbg !2235
  br i1 %3, label %_RNvMs5_NtNtNtCs1SSuMAdGM58_3std4sync6poison5mutexINtB5_5MutexNtNtCshxBJAVx362N_11runtime_lab7process7CaptureE4lockB11_.exit, label %bb6.i.i, !dbg !2235, !prof !74

bb6.i.i:                                          ; preds = %_RINvMNtNtNtCs1SSuMAdGM58_3std3sys4sync8once_boxINtB3_7OnceBoxNtNtNtNtNtB7_3pal4unix4sync5mutex5MutexE11get_or_initNCNvMNtNtB5_5mutex7pthreadNtB1T_5Mutex3get0ECshxBJAVx362N_11runtime_lab.exit.i
; call std::panicking::panic_count::is_zero_slow_path
  %4 = tail call noundef zeroext i1 @_RNvNtNtCs1SSuMAdGM58_3std9panicking11panic_count17is_zero_slow_path() #24, !dbg !2236, !noalias !2213
  %5 = xor i1 %4, true, !dbg !2237
  br label %_RNvMs5_NtNtNtCs1SSuMAdGM58_3std4sync6poison5mutexINtB5_5MutexNtNtCshxBJAVx362N_11runtime_lab7process7CaptureE4lockB11_.exit, !dbg !2236

_RNvMs5_NtNtNtCs1SSuMAdGM58_3std4sync6poison5mutexINtB5_5MutexNtNtCshxBJAVx362N_11runtime_lab7process7CaptureE4lockB11_.exit: ; preds = %_RINvMNtNtNtCs1SSuMAdGM58_3std3sys4sync8once_boxINtB3_7OnceBoxNtNtNtNtNtB7_3pal4unix4sync5mutex5MutexE11get_or_initNCNvMNtNtB5_5mutex7pthreadNtB1T_5Mutex3get0ECshxBJAVx362N_11runtime_lab.exit.i, %bb6.i.i
  %_6.sroa.0.0.off0.i.i = phi i1 [ %5, %bb6.i.i ], [ false, %_RINvMNtNtNtCs1SSuMAdGM58_3std3sys4sync8once_boxINtB3_7OnceBoxNtNtNtNtNtB7_3pal4unix4sync5mutex5MutexE11get_or_initNCNvMNtNtB5_5mutex7pthreadNtB1T_5Mutex3get0ECshxBJAVx362N_11runtime_lab.exit.i ]
  %_7.i = getelementptr inbounds nuw i8, ptr %state, i64 8, !dbg !2238
  %6 = load atomic i8, ptr %_7.i monotonic, align 8, !dbg !2239, !noalias !2213
  %_4.not.i.i.not = icmp eq i8 %6, 0, !dbg !2243
  %_0.sroa.3.0.i.i = zext i1 %_6.sroa.0.0.off0.i.i to i8, !dbg !2244
  br i1 %_4.not.i.i.not, label %bb2, label %bb4, !dbg !2245

bb4:                                              ; preds = %_RNvMs5_NtNtNtCs1SSuMAdGM58_3std4sync6poison5mutexINtB5_5MutexNtNtCshxBJAVx362N_11runtime_lab7process7CaptureE4lockB11_.exit
; invoke <core::io::error::Error>::new::<&str>
  %_0.i = invoke noundef nonnull ptr @_RINvMNtNtCs6zY7rJBZy9D_5alloc2io5errorNtNtNtCsjIpoRzUjyHQ_4core2io5error5Error3newReECs1SSuMAdGM58_3std(i8 noundef 42, ptr noalias nofree noundef nonnull readonly captures(address, read_provenance) @alloc_8821e7adf2aaedbbe7385d67b31be780, i64 noundef 22)
          to label %bb4.i unwind label %cleanup.i, !dbg !2248

cleanup.i:                                        ; preds = %bb4
  %7 = landingpad { ptr, i32 }
          cleanup
; invoke core::ptr::drop_glue::<std::sync::poison::PoisonError<std::sync::poison::mutex::MutexGuard<runtime_lab::process::Capture>>>
  invoke fastcc void @_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtCs1SSuMAdGM58_3std4sync6poison11PoisonErrorINtNtBE_5mutex10MutexGuardNtNtCshxBJAVx362N_11runtime_lab7process7CaptureEEEB1T_(ptr nonnull align 8 %state, i8 %_0.sroa.3.0.i.i) #23
          to label %bb3.i unwind label %terminate.i, !dbg !2257

bb4.i:                                            ; preds = %bb4
  br i1 %_6.sroa.0.0.off0.i.i, label %_RNCNvNtCshxBJAVx362N_11runtime_lab7process10state_lock0B5_.exit, label %bb1.i.i.i.i.i, !dbg !2258

bb1.i.i.i.i.i:                                    ; preds = %bb4.i
  %8 = load atomic i64, ptr @_RNvNtNtCs1SSuMAdGM58_3std9panicking11panic_count18GLOBAL_PANIC_COUNT monotonic, align 8, !dbg !2263
  %_7.i.i.i.i.i = and i64 %8, 9223372036854775807, !dbg !2269
  %9 = icmp eq i64 %_7.i.i.i.i.i, 0, !dbg !2269
  br i1 %9, label %_RNCNvNtCshxBJAVx362N_11runtime_lab7process10state_lock0B5_.exit, label %bb6.i.i.i.i.i, !dbg !2269, !prof !74

bb6.i.i.i.i.i:                                    ; preds = %bb1.i.i.i.i.i
; call std::panicking::panic_count::is_zero_slow_path
  %_6.i.i.i.i.i = tail call noundef zeroext i1 @_RNvNtNtCs1SSuMAdGM58_3std9panicking11panic_count17is_zero_slow_path() #24, !dbg !2270
  br i1 %_6.i.i.i.i.i, label %_RNCNvNtCshxBJAVx362N_11runtime_lab7process10state_lock0B5_.exit, label %bb2.i.i.i.i.i, !dbg !2271

bb2.i.i.i.i.i:                                    ; preds = %bb6.i.i.i.i.i
  store atomic i8 1, ptr %_7.i monotonic, align 8, !dbg !2272
  br label %_RNCNvNtCshxBJAVx362N_11runtime_lab7process10state_lock0B5_.exit, !dbg !2275

terminate.i:                                      ; preds = %cleanup.i
  %10 = landingpad { ptr, i32 }
          filter [0 x ptr] zeroinitializer
; call core::panicking::panic_in_cleanup
  tail call void @_RNvNtCsjIpoRzUjyHQ_4core9panicking16panic_in_cleanup() #22, !dbg !2276
  unreachable, !dbg !2276

bb3.i:                                            ; preds = %cleanup.i
  resume { ptr, i32 } %7, !dbg !2276

_RNCNvNtCshxBJAVx362N_11runtime_lab7process10state_lock0B5_.exit: ; preds = %bb4.i, %bb1.i.i.i.i.i, %bb6.i.i.i.i.i, %bb2.i.i.i.i.i
  %11 = load atomic ptr, ptr %state monotonic, align 8, !dbg !2277
; call <std::sys::pal::unix::sync::mutex::Mutex>::unlock
  tail call void @_RNvMNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutexNtB2_5Mutex6unlock(ptr noundef nonnull align 8 %11), !dbg !2282
  br label %bb2, !dbg !2283

bb2:                                              ; preds = %_RNvMs5_NtNtNtCs1SSuMAdGM58_3std4sync6poison5mutexINtB5_5MutexNtNtCshxBJAVx362N_11runtime_lab7process7CaptureE4lockB11_.exit, %_RNCNvNtCshxBJAVx362N_11runtime_lab7process10state_lock0B5_.exit
  %_0.i.sink = phi ptr [ %_0.i, %_RNCNvNtCshxBJAVx362N_11runtime_lab7process10state_lock0B5_.exit ], [ %state, %_RNvMs5_NtNtNtCs1SSuMAdGM58_3std4sync6poison5mutexINtB5_5MutexNtNtCshxBJAVx362N_11runtime_lab7process7CaptureE4lockB11_.exit ]
  %.sink = phi i8 [ 2, %_RNCNvNtCshxBJAVx362N_11runtime_lab7process10state_lock0B5_.exit ], [ %_0.sroa.3.0.i.i, %_RNvMs5_NtNtNtCs1SSuMAdGM58_3std4sync6poison5mutexINtB5_5MutexNtNtCshxBJAVx362N_11runtime_lab7process7CaptureE4lockB11_.exit ]
  store ptr %_0.i.sink, ptr %_0, align 8, !dbg !2284
  %12 = getelementptr inbounds nuw i8, ptr %_0, i64 8, !dbg !2284
  store i8 %.sink, ptr %12, align 8, !dbg !2284
  ret void, !dbg !2285
}

; runtime_lab::process::macos::pipe_cloexec
; Function Attrs: uwtable
define internal fastcc void @_RNvNtNtCshxBJAVx362N_11runtime_lab7process5macos12pipe_cloexec(ptr dead_on_unwind noalias nofree noundef nonnull writable writeonly align 8 captures(none) dereferenceable(16) %_0) unnamed_addr #2 personality ptr @rust_eh_personality !dbg !2286 !guid !2287 {
start:
  %fds = alloca [8 x i8], align 8
  %0 = load atomic ptr, ptr @_RNvNvNtNtCshxBJAVx362N_11runtime_lab7process5macos12pipe_cloexec5PIPE2 acquire, align 8, !dbg !2288
  %_11.i = icmp eq ptr %0, null, !dbg !2305
  br i1 %_11.i, label %_RINvMNtNtCs1SSuMAdGM58_3std4sync9once_lockINtB3_8OnceLockINtNtCsjIpoRzUjyHQ_4core6option6OptionFUKCOllElEE15get_or_try_initNCINvB2_11get_or_initNCNvNtNtCshxBJAVx362N_11runtime_lab7process5macos12pipe_cloexec0E0zEB2q_.exit, label %bb8.i, !dbg !2306, !prof !74

bb8.i:                                            ; preds = %start
; call <std::sync::once_lock::OnceLock<core::option::Option<unsafe extern "C" fn(*mut i32, i32) -> i32>>>::initialize::<<std::sync::once_lock::OnceLock<core::option::Option<unsafe extern "C" fn(*mut i32, i32) -> i32>>>::get_or_init<runtime_lab::process::macos::pipe_cloexec::{closure#0}>::{closure#0}, !>
  tail call fastcc void @_RINvMNtNtCs1SSuMAdGM58_3std4sync9once_lockINtB3_8OnceLockINtNtCsjIpoRzUjyHQ_4core6option6OptionFUKCOllElEE10initializeNCINvB2_11get_or_initNCNvNtNtCshxBJAVx362N_11runtime_lab7process5macos12pipe_cloexec0E0zEB2l_(), !dbg !2307
  br label %_RINvMNtNtCs1SSuMAdGM58_3std4sync9once_lockINtB3_8OnceLockINtNtCsjIpoRzUjyHQ_4core6option6OptionFUKCOllElEE15get_or_try_initNCINvB2_11get_or_initNCNvNtNtCshxBJAVx362N_11runtime_lab7process5macos12pipe_cloexec0E0zEB2q_.exit, !dbg !2308

_RINvMNtNtCs1SSuMAdGM58_3std4sync9once_lockINtB3_8OnceLockINtNtCsjIpoRzUjyHQ_4core6option6OptionFUKCOllElEE15get_or_try_initNCINvB2_11get_or_initNCNvNtNtCshxBJAVx362N_11runtime_lab7process5macos12pipe_cloexec0E0zEB2q_.exit: ; preds = %start, %bb8.i
  %1 = load ptr, ptr getelementptr inbounds nuw (i8, ptr @_RNvNvNtNtCshxBJAVx362N_11runtime_lab7process5macos12pipe_cloexec5PIPE2, i64 8), align 8, !dbg !2309, !noundef !41
  %.not = icmp eq ptr %1, null, !dbg !2310
  br i1 %.not, label %bb9, label %bb10, !dbg !2313

bb10:                                             ; preds = %_RINvMNtNtCs1SSuMAdGM58_3std4sync9once_lockINtB3_8OnceLockINtNtCsjIpoRzUjyHQ_4core6option6OptionFUKCOllElEE15get_or_try_initNCINvB2_11get_or_initNCNvNtNtCshxBJAVx362N_11runtime_lab7process5macos12pipe_cloexec0E0zEB2q_.exit
  call void @llvm.lifetime.start.p0(ptr nonnull %fds), !dbg !2314
  store i64 -1, ptr %fds, align 8, !dbg !2316
  %_8 = call noundef i32 %1(ptr noundef nonnull %fds, i32 noundef 16777216) #20, !dbg !2317
  %2 = icmp eq i32 %_8, 0, !dbg !2319
  br i1 %2, label %bb4, label %bb3, !dbg !2319

bb9:                                              ; preds = %_RINvMNtNtCs1SSuMAdGM58_3std4sync9once_lockINtB3_8OnceLockINtNtCsjIpoRzUjyHQ_4core6option6OptionFUKCOllElEE15get_or_try_initNCINvB2_11get_or_initNCNvNtNtCshxBJAVx362N_11runtime_lab7process5macos12pipe_cloexec0E0zEB2q_.exit
; call <core::io::error::Error>::new::<&str>
  %_23 = tail call noundef nonnull ptr @_RINvMNtNtCs6zY7rJBZy9D_5alloc2io5errorNtNtNtCsjIpoRzUjyHQ_4core2io5error5Error3newReECs1SSuMAdGM58_3std(i8 noundef 36, ptr noalias nofree noundef nonnull readonly captures(address, read_provenance) @alloc_9fa17d48c70567c41855e0f822a97df6, i64 noundef 82) #24, !dbg !2320
  %3 = getelementptr inbounds nuw i8, ptr %_0, i64 8, !dbg !2323
  store ptr %_23, ptr %3, align 8, !dbg !2323
  store i32 1, ptr %_0, align 8, !dbg !2323
  br label %bb5, !dbg !2331

bb5:                                              ; preds = %_RNvMs1_NtNtCsjIpoRzUjyHQ_4core2io5errorNtB5_5Error32from_raw_os_error_with_functions.exit, %bb19, %bb9
  ret void, !dbg !2333

bb4:                                              ; preds = %bb10
  %_15 = load i32, ptr %fds, align 8, !dbg !2334, !noundef !41
  %or.cond.not = icmp eq i32 %_15, -1, !dbg !2335
  br i1 %or.cond.not, label %bb14, label %bb16, !dbg !2335, !prof !2347

bb3:                                              ; preds = %bb10
  %_32 = tail call noundef ptr @__error() #20, !dbg !2348
  %_31 = load i32, ptr %_32, align 4, !dbg !2358, !noundef !41
  %4 = load atomic ptr, ptr @_RNvNtNtNtCsjIpoRzUjyHQ_4core2io5error12os_functions12OS_FUNCTIONS monotonic, align 8, !dbg !2359
  %_4.not.i = icmp eq ptr %4, @alloc_b51bd8077bfd6b0e033a5c3453ced731, !dbg !2372
  br i1 %_4.not.i, label %_RNvMs1_NtNtCsjIpoRzUjyHQ_4core2io5errorNtB5_5Error32from_raw_os_error_with_functions.exit, label %bb1.i, !dbg !2372, !prof !74

bb1.i:                                            ; preds = %bb3
; call core::io::error::os_functions::set_functions::set_functions_inner
  call void @_RNvNvNtNtNtCsjIpoRzUjyHQ_4core2io5error12os_functions13set_functions19set_functions_inner(ptr noalias nofree noundef readonly align 8 captures(address, read_provenance) dereferenceable(24) @alloc_b51bd8077bfd6b0e033a5c3453ced731), !dbg !2373
  br label %_RNvMs1_NtNtCsjIpoRzUjyHQ_4core2io5errorNtB5_5Error32from_raw_os_error_with_functions.exit, !dbg !2373

_RNvMs1_NtNtCsjIpoRzUjyHQ_4core2io5errorNtB5_5Error32from_raw_os_error_with_functions.exit: ; preds = %bb3, %bb1.i
  %_14.i = sext i32 %_31 to i64, !dbg !2374
  %_13.i = shl nsw i64 %_14.i, 32, !dbg !2378
  %utagged.i = or disjoint i64 %_13.i, 2, !dbg !2378
  %_16.i = inttoptr i64 %utagged.i to ptr, !dbg !2379
  %5 = getelementptr inbounds nuw i8, ptr %_0, i64 8, !dbg !2384
  store ptr %_16.i, ptr %5, align 8, !dbg !2384
  store i32 1, ptr %_0, align 8, !dbg !2384
  call void @llvm.lifetime.end.p0(ptr nonnull %fds), !dbg !2385
  br label %bb5, !dbg !2386

bb16:                                             ; preds = %bb4
  %6 = getelementptr inbounds nuw i8, ptr %fds, i64 4, !dbg !2388
  %_17 = load i32, ptr %6, align 4, !dbg !2388, !noundef !41
  %or.cond1.not = icmp eq i32 %_17, -1, !dbg !2389
  br i1 %or.cond1.not, label %bb17, label %bb19, !dbg !2389, !prof !2347

bb14:                                             ; preds = %bb4
; call core::option::expect_failed
  call void @_RNvNtCsjIpoRzUjyHQ_4core6option13expect_failed(ptr noalias nofree noundef nonnull readonly captures(address, read_provenance) @alloc_1a77a6ec3c99855082ffa167c1e43f36, i64 noundef 8, ptr noalias nofree noundef readonly align 8 captures(address, read_provenance) dereferenceable(24) @alloc_d4e874c5950a4dd077eda449f242ad2c) #25, !dbg !2395
  unreachable, !dbg !2395

bb19:                                             ; preds = %bb16
  %7 = getelementptr inbounds nuw i8, ptr %_0, i64 4, !dbg !2398
  store i32 %_15, ptr %7, align 4, !dbg !2398
  %8 = getelementptr inbounds nuw i8, ptr %_0, i64 8, !dbg !2398
  store i32 %_17, ptr %8, align 8, !dbg !2398
  store i32 0, ptr %_0, align 8, !dbg !2398
  call void @llvm.lifetime.end.p0(ptr nonnull %fds), !dbg !2385
  br label %bb5, !dbg !2333

bb17:                                             ; preds = %bb16
; invoke core::option::expect_failed
  invoke void @_RNvNtCsjIpoRzUjyHQ_4core6option13expect_failed(ptr noalias nofree noundef nonnull readonly captures(address, read_provenance) @alloc_1a77a6ec3c99855082ffa167c1e43f36, i64 noundef 8, ptr noalias nofree noundef readonly align 8 captures(address, read_provenance) dereferenceable(24) @alloc_444886716b65ec0b4507f0f9552978e5) #21
          to label %unreachable unwind label %bb7, !dbg !2399

unreachable:                                      ; preds = %bb17
  unreachable

bb7:                                              ; preds = %bb17
  %9 = landingpad { ptr, i32 }
          cleanup
  %_5.i.i = call noundef i32 @close(i32 noundef %_15) #20, !dbg !2401
  resume { ptr, i32 } %9, !dbg !2404
}

; runtime_lab::process::macos::spawn_captured
; Function Attrs: uwtable
define void @_RNvNtNtCshxBJAVx362N_11runtime_lab7process5macos14spawn_captured(ptr dead_on_unwind noalias nofree noundef writable writeonly sret([208 x i8]) align 8 captures(none) dereferenceable(208) %_0, ptr noalias nofree noundef align 8 dereferenceable(208) %command) unnamed_addr #2 personality ptr @rust_eh_personality !dbg !2405 !guid !2406 {
start:
  %child.i = alloca [24 x i8], align 4
  %_3.i = alloca [24 x i8], align 8
  %result = alloca [144 x i8], align 8
  %_21 = alloca [32 x i8], align 8
  %err = alloca [32 x i8], align 8
  %_14 = alloca [32 x i8], align 8
  %out = alloca [32 x i8], align 8
  %_10 = alloca [16 x i8], align 8
  %_5 = alloca [16 x i8], align 8
  call void @llvm.lifetime.start.p0(ptr nonnull %_5), !dbg !2407
; call runtime_lab::process::macos::pipe_cloexec
  call fastcc void @_RNvNtNtCshxBJAVx362N_11runtime_lab7process5macos12pipe_cloexec(ptr noalias nofree noundef align 8 captures(none) dereferenceable(16) %_5), !dbg !2407
  %0 = load i32, ptr %_5, align 8, !dbg !2408, !range !1191, !noundef !41
  %1 = trunc nuw i32 %0 to i1, !dbg !2410
  br i1 %1, label %bb25, label %bb26, !dbg !2410

bb25:                                             ; preds = %start
  %2 = getelementptr inbounds nuw i8, ptr %_5, i64 8, !dbg !2411
  %_42 = load ptr, ptr %2, align 8, !dbg !2411, !nonnull !41, !noundef !41
  call void @llvm.lifetime.end.p0(ptr nonnull %_5), !dbg !2412
  %3 = getelementptr inbounds nuw i8, ptr %_0, i64 8, !dbg !2413
  store ptr %_42, ptr %3, align 8, !dbg !2413
  store i64 2, ptr %_0, align 8, !dbg !2413
  br label %bb11, !dbg !2420

bb26:                                             ; preds = %start
  %4 = getelementptr inbounds nuw i8, ptr %_5, i64 4, !dbg !2422
  %_41.0 = load i32, ptr %4, align 4, !dbg !2422, !range !618, !noundef !41
  %5 = getelementptr inbounds nuw i8, ptr %_5, i64 8, !dbg !2422
  %_41.1 = load i32, ptr %5, align 8, !dbg !2422, !range !618, !noundef !41
  call void @llvm.lifetime.end.p0(ptr nonnull %_5), !dbg !2412
  call void @llvm.lifetime.start.p0(ptr nonnull %_10), !dbg !2423
; invoke runtime_lab::process::macos::pipe_cloexec
  invoke fastcc void @_RNvNtNtCshxBJAVx362N_11runtime_lab7process5macos12pipe_cloexec(ptr noalias nofree noundef align 8 captures(none) dereferenceable(16) %_10)
          to label %bb3 unwind label %bb23, !dbg !2423

bb22:                                             ; preds = %bb18
  br i1 %_39.sroa.0.2.off0, label %bb24.thread108, label %bb15, !dbg !2425

bb3:                                              ; preds = %bb26
  %6 = load i32, ptr %_10, align 8, !dbg !2426, !range !1191, !noundef !41
  %7 = trunc nuw i32 %6 to i1, !dbg !2427
  br i1 %7, label %bb39, label %bb28, !dbg !2427

bb28:                                             ; preds = %bb3
  %8 = getelementptr inbounds nuw i8, ptr %_10, i64 4, !dbg !2428
  %_48.0 = load i32, ptr %8, align 4, !dbg !2428, !range !618, !noundef !41
  %9 = getelementptr inbounds nuw i8, ptr %_10, i64 8, !dbg !2428
  %_48.1 = load i32, ptr %9, align 8, !dbg !2428, !range !618, !noundef !41
  call void @llvm.lifetime.end.p0(ptr nonnull %_10), !dbg !2429
  call void @llvm.lifetime.start.p0(ptr nonnull %out), !dbg !2430
  call void @llvm.lifetime.start.p0(ptr nonnull %_14), !dbg !2432
; invoke <tokio::process::ChildStdout>::from_std
  invoke void @_RNvMs5_NtCs3EIJ1qnJmKW_5tokio7processNtB5_11ChildStdout8from_std(ptr noalias nofree noundef nonnull sret([32 x i8]) align 8 captures(none) dereferenceable(32) %_14, i32 noundef %_41.0)
          to label %bb4 unwind label %bb19, !dbg !2432

bb18:                                             ; preds = %bb14
  br i1 %_38.sroa.0.1.off0, label %bb20.thread97, label %bb22, !dbg !2433

bb20.thread97:                                    ; preds = %bb18
  %_5.i.i67101 = call noundef i32 @close(i32 noundef %_48.1) #20, !dbg !2434
  br i1 %_39.sroa.0.2.off0, label %bb24.thread108, label %bb15, !dbg !2425

bb4:                                              ; preds = %bb28
  %10 = load i64, ptr %_14, align 8, !dbg !2437, !range !312, !noundef !41
  %11 = icmp eq i64 %10, 2, !dbg !2437
  %12 = getelementptr inbounds nuw i8, ptr %_14, i64 8, !dbg !2439
  %_57 = load ptr, ptr %12, align 8, !dbg !2439
  br i1 %11, label %bb40, label %bb30, !dbg !2440

bb30:                                             ; preds = %bb4
  %_56.sroa.5.0._14.sroa_idx = getelementptr inbounds nuw i8, ptr %_14, i64 16, !dbg !2441
  %val.sroa.5.0.out.sroa_idx = getelementptr inbounds nuw i8, ptr %out, i64 16, !dbg !2442
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %val.sroa.5.0.out.sroa_idx, ptr noundef nonnull align 8 dereferenceable(16) %_56.sroa.5.0._14.sroa_idx, i64 16, i1 false), !dbg !2441
  call void @llvm.lifetime.end.p0(ptr nonnull %_14), !dbg !2445
  store i64 %10, ptr %out, align 8, !dbg !2442
  %val.sroa.4.0.out.sroa_idx = getelementptr inbounds nuw i8, ptr %out, i64 8, !dbg !2442
  store ptr %_57, ptr %val.sroa.4.0.out.sroa_idx, align 8, !dbg !2442
  call void @llvm.lifetime.start.p0(ptr nonnull %err), !dbg !2446
  call void @llvm.lifetime.start.p0(ptr nonnull %_21), !dbg !2448
; invoke <tokio::process::ChildStderr>::from_std
  invoke void @_RNvMs6_NtCs3EIJ1qnJmKW_5tokio7processNtB5_11ChildStderr8from_std(ptr noalias nofree noundef nonnull sret([32 x i8]) align 8 captures(none) dereferenceable(32) %_21, i32 noundef %_48.0)
          to label %bb5 unwind label %cleanup8, !dbg !2448

bb14:                                             ; preds = %bb13, %cleanup8
  %_38.sroa.0.1.off0 = phi i1 [ true, %cleanup8 ], [ %_38.sroa.0.2.off0, %bb13 ]
  %_39.sroa.0.2.off0 = phi i1 [ true, %cleanup8 ], [ false, %bb13 ]
  %.pn.pn = phi { ptr, i32 } [ %13, %cleanup8 ], [ %.pn, %bb13 ]
; invoke core::ptr::drop_glue::<tokio::process::imp::ChildStdout>
  invoke fastcc void @_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtNtCs3EIJ1qnJmKW_5tokio7process3imp11ChildStdoutECshxBJAVx362N_11runtime_lab(ptr noalias nofree noundef nonnull align 8 dereferenceable(32) %out)
          to label %bb18 unwind label %terminate, !dbg !2449

cleanup8:                                         ; preds = %bb30
  %13 = landingpad { ptr, i32 }
          cleanup
  br label %bb14

bb5:                                              ; preds = %bb30
  %14 = load i64, ptr %_21, align 8, !dbg !2451, !range !312, !noundef !41
  %15 = icmp eq i64 %14, 2, !dbg !2451
  %16 = getelementptr inbounds nuw i8, ptr %_21, i64 8, !dbg !2453
  %_65 = load ptr, ptr %16, align 8, !dbg !2453
  br i1 %15, label %bb31, label %bb32, !dbg !2454

bb31:                                             ; preds = %bb5
  call void @llvm.lifetime.end.p0(ptr nonnull %_21), !dbg !2455
  %17 = getelementptr inbounds nuw i8, ptr %_0, i64 8, !dbg !2456
  store ptr %_65, ptr %17, align 8, !dbg !2456
  store i64 2, ptr %_0, align 8, !dbg !2456
  call void @llvm.lifetime.end.p0(ptr nonnull %err), !dbg !2462
; invoke core::ptr::drop_glue::<tokio::process::imp::ChildStdout>
  invoke fastcc void @_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtNtCs3EIJ1qnJmKW_5tokio7process3imp11ChildStdoutECshxBJAVx362N_11runtime_lab(ptr noalias nofree noundef nonnull align 8 dereferenceable(32) %out)
          to label %bb43 unwind label %bb22.thread112, !dbg !2463

bb32:                                             ; preds = %bb5
  %_64.sroa.5.0._21.sroa_idx = getelementptr inbounds nuw i8, ptr %_21, i64 16, !dbg !2465
  %val1.sroa.5.0.err.sroa_idx = getelementptr inbounds nuw i8, ptr %err, i64 16, !dbg !2466
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 8 dereferenceable(16) %val1.sroa.5.0.err.sroa_idx, ptr noundef nonnull align 8 dereferenceable(16) %_64.sroa.5.0._21.sroa_idx, i64 16, i1 false), !dbg !2465
  call void @llvm.lifetime.end.p0(ptr nonnull %_21), !dbg !2455
  store i64 %14, ptr %err, align 8, !dbg !2466
  %val1.sroa.4.0.err.sroa_idx = getelementptr inbounds nuw i8, ptr %err, i64 8, !dbg !2466
  store ptr %_65, ptr %val1.sroa.4.0.err.sroa_idx, align 8, !dbg !2466
; invoke <std::sys::process::unix::common::Command>::stdout
  invoke void @_RNvMs_NtNtNtNtCs1SSuMAdGM58_3std3sys7process4unix6commonNtB4_7Command6stdout(ptr noalias nofree noundef nonnull align 8 dereferenceable(200) %command, i32 noundef 3, i32 range(i32 0, -1) %_41.1)
          to label %bb33 unwind label %cleanup9, !dbg !2469

bb13:                                             ; preds = %cleanup10, %cleanup9
  %_38.sroa.0.2.off0 = phi i1 [ false, %cleanup10 ], [ %_38.sroa.0.3.off0, %cleanup9 ]
  %.pn = phi { ptr, i32 } [ %23, %cleanup10 ], [ %18, %cleanup9 ]
; invoke core::ptr::drop_glue::<tokio::process::imp::ChildStdout>
  invoke fastcc void @_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtNtCs3EIJ1qnJmKW_5tokio7process3imp11ChildStdoutECshxBJAVx362N_11runtime_lab(ptr noalias nofree noundef nonnull align 8 dereferenceable(32) %err)
          to label %bb14 unwind label %terminate, !dbg !2479

cleanup9:                                         ; preds = %bb6.i, %bb34, %bb33, %bb32
  %_38.sroa.0.3.off0 = phi i1 [ false, %bb6.i ], [ false, %bb33 ], [ true, %bb32 ], [ false, %bb34 ]
  %18 = landingpad { ptr, i32 }
          cleanup
  br label %bb13

bb33:                                             ; preds = %bb32
; invoke <std::sys::process::unix::common::Command>::stderr
  invoke void @_RNvMs_NtNtNtNtCs1SSuMAdGM58_3std3sys7process4unix6commonNtB4_7Command6stderr(ptr noalias nofree noundef nonnull align 8 dereferenceable(200) %command, i32 noundef 3, i32 range(i32 0, -1) %_48.1)
          to label %bb34 unwind label %cleanup9, !dbg !2481

bb34:                                             ; preds = %bb33
  call void @llvm.lifetime.start.p0(ptr nonnull %result), !dbg !2486
  tail call void @llvm.experimental.noalias.scope.decl(metadata !2487), !dbg !2490
  call void @llvm.lifetime.start.p0(ptr nonnull %child.i), !dbg !2491
  call void @llvm.lifetime.start.p0(ptr nonnull %_3.i), !dbg !2491, !noalias !2494
; invoke <std::process::Command>::spawn
  invoke void @_RNvMsi_NtCs1SSuMAdGM58_3std7processNtB5_7Command5spawn(ptr noalias nofree noundef nonnull sret([24 x i8]) align 8 captures(none) dereferenceable(24) %_3.i, ptr noalias nofree noundef nonnull align 8 dereferenceable(208) %command)
          to label %.noexc unwind label %cleanup9, !dbg !2496

.noexc:                                           ; preds = %bb34
  %19 = load i32, ptr %_3.i, align 8, !dbg !2497, !range !267, !noalias !2494, !noundef !41
  %20 = icmp eq i32 %19, 2, !dbg !2497
  br i1 %20, label %bb5.i, label %bb6.i, !dbg !2500

bb5.i:                                            ; preds = %.noexc
  %21 = getelementptr inbounds nuw i8, ptr %_3.i, i64 8, !dbg !2501
  %_10.i = load ptr, ptr %21, align 8, !dbg !2501, !noalias !2494, !nonnull !41, !noundef !41
  call void @llvm.lifetime.end.p0(ptr nonnull %_3.i), !dbg !2502, !noalias !2494
  %22 = getelementptr inbounds nuw i8, ptr %result, i64 8, !dbg !2503
  store ptr %_10.i, ptr %22, align 8, !dbg !2503, !alias.scope !2487, !noalias !2510
  store i64 -1, ptr %result, align 8, !dbg !2503, !alias.scope !2487, !noalias !2510
  br label %bb6, !dbg !2511

bb6.i:                                            ; preds = %.noexc
  %_9.sroa.4.0._3.sroa_idx.i = getelementptr inbounds nuw i8, ptr %_3.i, i64 4, !dbg !2512
  %_9.sroa.4.0.copyload.i = load i32, ptr %_9.sroa.4.0._3.sroa_idx.i, align 4, !dbg !2512, !noalias !2494
  %_9.sroa.5.0._3.sroa_idx.i = getelementptr inbounds nuw i8, ptr %_3.i, i64 8, !dbg !2512
  %_9.sroa.5.0.copyload.i = load ptr, ptr %_9.sroa.5.0._3.sroa_idx.i, align 8, !dbg !2512, !noalias !2494
  %_9.sroa.6.0._3.sroa_idx.i = getelementptr inbounds nuw i8, ptr %_3.i, i64 16, !dbg !2512
  %_9.sroa.6.0.copyload.i = load i64, ptr %_9.sroa.6.0._3.sroa_idx.i, align 8, !dbg !2512, !noalias !2494
  call void @llvm.lifetime.end.p0(ptr nonnull %_3.i), !dbg !2502, !noalias !2494
  store i32 %19, ptr %child.i, align 4, !dbg !2491, !noalias !2494
  %_2.sroa.6.0.child.sroa_idx.i = getelementptr inbounds nuw i8, ptr %child.i, i64 4, !dbg !2491
  store i32 %_9.sroa.4.0.copyload.i, ptr %_2.sroa.6.0.child.sroa_idx.i, align 4, !dbg !2491, !noalias !2494
  %_2.sroa.63.0.child.sroa_idx.i = getelementptr inbounds nuw i8, ptr %child.i, i64 8, !dbg !2491
  store ptr %_9.sroa.5.0.copyload.i, ptr %_2.sroa.63.0.child.sroa_idx.i, align 4, !dbg !2491, !noalias !2494
  %_2.sroa.8.0.child.sroa_idx.i = getelementptr inbounds nuw i8, ptr %child.i, i64 16, !dbg !2491
  store i64 %_9.sroa.6.0.copyload.i, ptr %_2.sroa.8.0.child.sroa_idx.i, align 4, !dbg !2491, !noalias !2494
; invoke <tokio::process::Command>::build_child
  invoke void @_RNvMNtCs3EIJ1qnJmKW_5tokio7processNtB2_7Command11build_child(ptr noalias nofree noundef nonnull sret([144 x i8]) align 8 captures(none) dereferenceable(144) %result, ptr noalias nofree noundef nonnull readonly align 8 captures(address, read_provenance) dereferenceable(208) %command, ptr noalias nofree noundef nonnull align 4 captures(address) dereferenceable(24) %child.i)
          to label %bb6 unwind label %cleanup9, !dbg !2513

bb6:                                              ; preds = %bb5.i, %bb6.i
  call void @llvm.lifetime.end.p0(ptr nonnull %child.i), !dbg !2511
; invoke <std::sys::process::unix::common::Command>::stdout
  invoke void @_RNvMs_NtNtNtNtCs1SSuMAdGM58_3std3sys7process4unix6commonNtB4_7Command6stdout(ptr noalias nofree noundef nonnull align 8 dereferenceable(200) %command, i32 noundef 1, i32 undef)
          to label %bb35 unwind label %cleanup10, !dbg !2515

cleanup10:                                        ; preds = %bb35, %bb6
  %23 = landingpad { ptr, i32 }
          cleanup
; invoke core::ptr::drop_glue::<core::result::Result<tokio::process::Child, core::io::error::Error>>
  invoke fastcc void @_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtB4_6result6ResultNtNtCs3EIJ1qnJmKW_5tokio7process5ChildNtNtNtB4_2io5error5ErrorEECshxBJAVx362N_11runtime_lab(ptr noalias nofree noundef align 8 dereferenceable(144) %result) #23
          to label %bb13 unwind label %terminate, !dbg !2521

bb35:                                             ; preds = %bb6
; invoke <std::sys::process::unix::common::Command>::stderr
  invoke void @_RNvMs_NtNtNtNtCs1SSuMAdGM58_3std3sys7process4unix6commonNtB4_7Command6stderr(ptr noalias nofree noundef nonnull align 8 dereferenceable(200) %command, i32 noundef 1, i32 undef)
          to label %bb36 unwind label %cleanup10, !dbg !2522

bb36:                                             ; preds = %bb35
  %_31.sroa.0.0.copyload = load i64, ptr %result, align 8, !dbg !2527
  %_31.sroa.6.0.result.sroa_idx = getelementptr inbounds nuw i8, ptr %result, i64 8, !dbg !2527
  %_31.sroa.6.0.copyload = load ptr, ptr %_31.sroa.6.0.result.sroa_idx, align 8, !dbg !2527
  %24 = icmp eq i64 %_31.sroa.0.0.copyload, -1, !dbg !2528
  br i1 %24, label %bb37, label %bb38, !dbg !2530

bb37:                                             ; preds = %bb36
  call void @llvm.assume(i1 true) [ "nonnull"(ptr %_31.sroa.6.0.copyload) ]
  %25 = getelementptr inbounds nuw i8, ptr %_0, i64 8, !dbg !2531
  store ptr %_31.sroa.6.0.copyload, ptr %25, align 8, !dbg !2531
  store i64 2, ptr %_0, align 8, !dbg !2531
  call void @llvm.lifetime.end.p0(ptr nonnull %result), !dbg !2521
; invoke core::ptr::drop_glue::<tokio::process::imp::ChildStdout>
  invoke fastcc void @_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtNtCs3EIJ1qnJmKW_5tokio7process3imp11ChildStdoutECshxBJAVx362N_11runtime_lab(ptr noalias nofree noundef nonnull align 8 dereferenceable(32) %err)
          to label %bb7 unwind label %cleanup11, !dbg !2537

bb38:                                             ; preds = %bb36
  %_31.sroa.7.0.result.sroa_idx = getelementptr inbounds nuw i8, ptr %result, i64 16, !dbg !2527
  %_29.sroa.7.0._0.sroa_idx = getelementptr inbounds nuw i8, ptr %_0, i64 48, !dbg !2539
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 8 dereferenceable(128) %_29.sroa.7.0._0.sroa_idx, ptr noundef nonnull align 8 dereferenceable(128) %_31.sroa.7.0.result.sroa_idx, i64 128, i1 false), !dbg !2540
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 8 dereferenceable(32) %_0, ptr noundef nonnull align 8 dereferenceable(32) %out, i64 32, i1 false), !dbg !2541
  %_29.sroa.8.0._0.sroa_idx = getelementptr inbounds nuw i8, ptr %_0, i64 176, !dbg !2539
  call void @llvm.memcpy.p0.p0.i64(ptr noundef nonnull align 8 dereferenceable(32) %_29.sroa.8.0._0.sroa_idx, ptr noundef nonnull align 8 dereferenceable(32) %err, i64 32, i1 false), !dbg !2542
  %_29.sroa.5.0._0.sroa_idx = getelementptr inbounds nuw i8, ptr %_0, i64 32, !dbg !2539
  store i64 %_31.sroa.0.0.copyload, ptr %_29.sroa.5.0._0.sroa_idx, align 8, !dbg !2539
  %_29.sroa.6.0._0.sroa_idx = getelementptr inbounds nuw i8, ptr %_0, i64 40, !dbg !2539
  store ptr %_31.sroa.6.0.copyload, ptr %_29.sroa.6.0._0.sroa_idx, align 8, !dbg !2539
  call void @llvm.lifetime.end.p0(ptr nonnull %result), !dbg !2521
  call void @llvm.lifetime.end.p0(ptr nonnull %err), !dbg !2462
  call void @llvm.lifetime.end.p0(ptr nonnull %out), !dbg !2543
  br label %bb11, !dbg !2544

bb11:                                             ; preds = %bb41, %bb39, %bb25, %bb7, %bb38
  ret void, !dbg !2544

cleanup11:                                        ; preds = %bb37
  %26 = landingpad { ptr, i32 }
          cleanup
; invoke core::ptr::drop_glue::<tokio::process::imp::ChildStdout>
  invoke fastcc void @_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtNtCs3EIJ1qnJmKW_5tokio7process3imp11ChildStdoutECshxBJAVx362N_11runtime_lab(ptr noalias nofree noundef nonnull align 8 dereferenceable(32) %out)
          to label %bb15 unwind label %terminate, !dbg !2545

bb7:                                              ; preds = %bb37
  call void @llvm.lifetime.end.p0(ptr nonnull %err), !dbg !2462
; call core::ptr::drop_glue::<tokio::process::imp::ChildStdout>
  call fastcc void @_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtNtCs3EIJ1qnJmKW_5tokio7process3imp11ChildStdoutECshxBJAVx362N_11runtime_lab(ptr noalias nofree noundef nonnull align 8 dereferenceable(32) %out), !dbg !2547
  call void @llvm.lifetime.end.p0(ptr nonnull %out), !dbg !2543
  br label %bb11, !dbg !2420

terminate:                                        ; preds = %cleanup11, %bb13, %bb14, %cleanup10
  %27 = landingpad { ptr, i32 }
          filter [0 x ptr] zeroinitializer
; call core::panicking::panic_in_cleanup
  call void @_RNvNtCsjIpoRzUjyHQ_4core9panicking16panic_in_cleanup() #22, !dbg !2549
  unreachable, !dbg !2549

bb15:                                             ; preds = %bb20.thread97, %bb22, %bb24.thread108, %cleanup11, %bb23
  %.pn46.pn = phi { ptr, i32 } [ %33, %bb23 ], [ %.pn4486.ph, %bb24.thread108 ], [ %26, %cleanup11 ], [ %.pn.pn, %bb20.thread97 ], [ %.pn.pn, %bb22 ]
  resume { ptr, i32 } %.pn46.pn, !dbg !2549

bb22.thread112:                                   ; preds = %bb31
  %28 = landingpad { ptr, i32 }
          cleanup
  %_5.i.i67 = call noundef i32 @close(i32 noundef %_48.1) #20, !dbg !2434
  br label %bb24.thread108, !dbg !2425

bb43:                                             ; preds = %bb31
  call void @llvm.lifetime.end.p0(ptr nonnull %out), !dbg !2543
  %_5.i.i64 = call noundef i32 @close(i32 noundef %_48.1) #20, !dbg !2550
  br label %bb41, !dbg !2433

bb40:                                             ; preds = %bb4
  call void @llvm.lifetime.end.p0(ptr nonnull %_14), !dbg !2445
  %29 = getelementptr inbounds nuw i8, ptr %_0, i64 8, !dbg !2553
  store ptr %_57, ptr %29, align 8, !dbg !2553
  store i64 2, ptr %_0, align 8, !dbg !2553
  call void @llvm.lifetime.end.p0(ptr nonnull %out), !dbg !2543
  %_5.i.i55 = tail call noundef i32 @close(i32 noundef %_48.1) #20, !dbg !2559
  %_5.i.i66 = tail call noundef i32 @close(i32 noundef %_48.0) #20, !dbg !2562
  br label %bb41, !dbg !2565

bb24.thread108:                                   ; preds = %bb22, %bb19, %bb22.thread112, %bb20.thread97
  %.pn4486.ph = phi { ptr, i32 } [ %30, %bb19 ], [ %.pn.pn, %bb22 ], [ %28, %bb22.thread112 ], [ %.pn.pn, %bb20.thread97 ]
  %_5.i.i70111 = call noundef i32 @close(i32 noundef %_41.1) #20, !dbg !2566
  br label %bb15, !dbg !2425

bb41:                                             ; preds = %bb43, %bb40
  %_5.i.i65 = call noundef i32 @close(i32 noundef %_41.1) #20, !dbg !2569
  br label %bb11, !dbg !2425

bb19:                                             ; preds = %bb28
  %30 = landingpad { ptr, i32 }
          cleanup
  %_5.i.i67104 = tail call noundef i32 @close(i32 noundef %_48.1) #20, !dbg !2434
  %_5.i.i68 = tail call noundef i32 @close(i32 noundef %_48.0) #20, !dbg !2572
  br label %bb24.thread108, !dbg !2425

bb39:                                             ; preds = %bb3
  %31 = getelementptr inbounds nuw i8, ptr %_10, i64 8, !dbg !2575
  %_49 = load ptr, ptr %31, align 8, !dbg !2575, !nonnull !41, !noundef !41
  call void @llvm.lifetime.end.p0(ptr nonnull %_10), !dbg !2429
  %32 = getelementptr inbounds nuw i8, ptr %_0, i64 8, !dbg !2576
  store ptr %_49, ptr %32, align 8, !dbg !2576
  store i64 2, ptr %_0, align 8, !dbg !2576
  %_5.i.i = tail call noundef i32 @close(i32 noundef %_41.1) #20, !dbg !2582
  %_5.i.i69 = tail call noundef i32 @close(i32 noundef %_41.0) #20, !dbg !2585
  br label %bb11, !dbg !2425

bb23:                                             ; preds = %bb26
  %33 = landingpad { ptr, i32 }
          cleanup
  %_5.i.i70 = tail call noundef i32 @close(i32 noundef %_41.1) #20, !dbg !2566
  %_5.i.i71 = tail call noundef i32 @close(i32 noundef %_41.0) #20, !dbg !2588
  br label %bb15, !dbg !2591
}

; std::sys::io::error::unix::is_interrupted
; Function Attrs: inlinehint mustprogress nofree norecurse nosync nounwind willreturn memory(none) uwtable
define internal noundef zeroext i1 @_RNvNtNtNtNtCs1SSuMAdGM58_3std3sys2io5error4unix14is_interrupted(i32 noundef %errno) unnamed_addr #8 !dbg !2592 !guid !2593 {
start:
  %_0 = icmp eq i32 %errno, 4, !dbg !2594
  ret i1 %_0, !dbg !2595
}

; std::sys::io::error::unix::decode_error_kind
; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(none) uwtable
define internal noundef range(i8 0, 44) i8 @_RNvNtNtNtNtCs1SSuMAdGM58_3std3sys2io5error4unix17decode_error_kind(i32 noundef %errno) unnamed_addr #9 !dbg !2596 !guid !2597 {
start:
  %switch.tableidx = add i32 %errno, -1, !dbg !2598
  %0 = icmp ult i32 %switch.tableidx, 102, !dbg !2598
  br i1 %0, label %switch.lookup, label %bb46, !dbg !2598

switch.lookup:                                    ; preds = %start
  %1 = zext nneg i32 %switch.tableidx to i64, !dbg !2598
  %switch.gep = getelementptr inbounds nuw i8, ptr @switch.table._RNvNtNtNtNtCs1SSuMAdGM58_3std3sys2io5error4unix17decode_error_kind, i64 %1, !dbg !2598
  %switch.load = load i8, ptr %switch.gep, align 1, !dbg !2598
  br label %bb46, !dbg !2598

bb46:                                             ; preds = %start, %switch.lookup
  %_0.sroa.0.0 = phi i8 [ %switch.load, %switch.lookup ], [ 43, %start ], !dbg !2599
  ret i8 %_0.sroa.0.0, !dbg !2600
}

; <runtime_lab::process::ReaderTask as core::ops::drop::Drop>::drop
; Function Attrs: uwtable
define void @_RNvXs0_NtCshxBJAVx362N_11runtime_lab7processNtB5_10ReaderTaskNtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4drop(ptr noalias nofree noundef readonly align 8 captures(address, read_provenance) dereferenceable(8) %self) unnamed_addr #2 !dbg !2601 !guid !2603 {
start:
; call <tokio::runtime::task::raw::RawTask>::remote_abort
  tail call void @_RNvMs_NtNtNtCs3EIJ1qnJmKW_5tokio7runtime4task7harnessNtNtB6_3raw7RawTask12remote_abort(ptr noalias nofree noundef nonnull readonly align 8 captures(address, read_provenance) dereferenceable(8) %self), !dbg !2604
  ret void, !dbg !2611
}

; <&core::option::Option<core::ptr::non_null::NonNull<tokio::runtime::task::core::Header>> as core::fmt::Debug>::fmt
; Function Attrs: uwtable
define internal noundef zeroext i1 @_RNvXs1g_NtCsjIpoRzUjyHQ_4core3fmtRINtNtB8_6option6OptionINtNtNtB8_3ptr8non_null7NonNullNtNtNtNtCs3EIJ1qnJmKW_5tokio7runtime4task4core6HeaderEENtB6_5Debug3fmtCshxBJAVx362N_11runtime_lab(ptr noalias nofree noundef readonly align 8 captures(none) dereferenceable(8) %self, ptr noalias nofree noundef align 8 dereferenceable(24) %f) unnamed_addr #2 !dbg !2612 !guid !2616 {
start:
  %__self_0.i = alloca [8 x i8], align 8
  %_3 = load ptr, ptr %self, align 8, !dbg !2617, !nonnull !41, !align !1250, !noundef !41
  tail call void @llvm.experimental.noalias.scope.decl(metadata !2618), !dbg !2621
  %0 = load ptr, ptr %_3, align 8, !dbg !2622, !alias.scope !2618, !noalias !2626, !noundef !41
  %.not.i = icmp eq ptr %0, null, !dbg !2622
  br i1 %.not.i, label %bb3.i, label %bb2.i, !dbg !2622

bb2.i:                                            ; preds = %start
  call void @llvm.lifetime.start.p0(ptr nonnull %__self_0.i), !dbg !2628, !noalias !2629
  store ptr %_3, ptr %__self_0.i, align 8, !dbg !2628, !noalias !2629
; call <core::fmt::Formatter>::debug_tuple_field1_finish
  %1 = call noundef zeroext i1 @_RNvMsa_NtCsjIpoRzUjyHQ_4core3fmtNtB5_9Formatter25debug_tuple_field1_finish(ptr noalias nofree noundef nonnull align 8 dereferenceable(24) %f, ptr noalias nofree noundef nonnull readonly captures(address, read_provenance) @alloc_9535bf4c204f3eb9b19ec2c83e446e52, i64 noundef 4, ptr noundef nonnull %__self_0.i, ptr noalias nofree noundef readonly align 8 captures(address, read_provenance) dereferenceable(32) @vtable.3), !dbg !2630
  call void @llvm.lifetime.end.p0(ptr nonnull %__self_0.i), !dbg !2632, !noalias !2629
  br label %_RNvXsR_NtCsjIpoRzUjyHQ_4core6optionINtB5_6OptionINtNtNtB7_3ptr8non_null7NonNullNtNtNtNtCs3EIJ1qnJmKW_5tokio7runtime4task4core6HeaderEENtNtB7_3fmt5Debug3fmtCshxBJAVx362N_11runtime_lab.exit, !dbg !2632

bb3.i:                                            ; preds = %start
; call <core::fmt::Formatter>::write_str
  %2 = tail call noundef zeroext i1 @_RNvMsa_NtCsjIpoRzUjyHQ_4core3fmtNtB5_9Formatter9write_str(ptr noalias nofree noundef nonnull align 8 dereferenceable(24) %f, ptr noalias nofree noundef nonnull readonly captures(address, read_provenance) @alloc_37d2e53432a03a1f90b3e7253015eaf9, i64 noundef 4), !dbg !2622, !noalias !2618
  br label %_RNvXsR_NtCsjIpoRzUjyHQ_4core6optionINtB5_6OptionINtNtNtB7_3ptr8non_null7NonNullNtNtNtNtCs3EIJ1qnJmKW_5tokio7runtime4task4core6HeaderEENtNtB7_3fmt5Debug3fmtCshxBJAVx362N_11runtime_lab.exit, !dbg !2622

_RNvXsR_NtCsjIpoRzUjyHQ_4core6optionINtB5_6OptionINtNtNtB7_3ptr8non_null7NonNullNtNtNtNtCs3EIJ1qnJmKW_5tokio7runtime4task4core6HeaderEENtNtB7_3fmt5Debug3fmtCshxBJAVx362N_11runtime_lab.exit: ; preds = %bb2.i, %bb3.i
  %_0.sroa.0.0.in.i = phi i1 [ %1, %bb2.i ], [ %2, %bb3.i ]
  ret i1 %_0.sroa.0.0.in.i, !dbg !2633
}

; <&core::ptr::non_null::NonNull<tokio::runtime::task::core::Header> as core::fmt::Debug>::fmt
; Function Attrs: uwtable
define internal noundef zeroext i1 @_RNvXs1g_NtCsjIpoRzUjyHQ_4core3fmtRINtNtNtB8_3ptr8non_null7NonNullNtNtNtNtCs3EIJ1qnJmKW_5tokio7runtime4task4core6HeaderENtB6_5Debug3fmtCshxBJAVx362N_11runtime_lab(ptr noalias nofree noundef readonly align 8 captures(none) dereferenceable(8) %self, ptr noalias nofree noundef align 8 dereferenceable(24) %f) unnamed_addr #2 !dbg !2634 !guid !2635 {
start:
  %_3 = load ptr, ptr %self, align 8, !dbg !2636, !nonnull !41, !align !1250, !noundef !41
  %_3.val = load ptr, ptr %_3, align 8, !dbg !2637, !nonnull !41, !noundef !41
  %ptr_addr.i.i = ptrtoint ptr %_3.val to i64, !dbg !2638
; call core::fmt::pointer_fmt_inner
  %0 = tail call noundef zeroext i1 @_RNvNtCsjIpoRzUjyHQ_4core3fmt17pointer_fmt_inner(i64 noundef %ptr_addr.i.i, ptr noalias nofree noundef nonnull align 8 dereferenceable(24) %f), !dbg !2651
  ret i1 %0, !dbg !2653
}

; <runtime_lab::process::DrainLifetime as core::ops::drop::Drop>::drop
; Function Attrs: uwtable
define void @_RNvXs_NtCshxBJAVx362N_11runtime_lab7processNtB4_13DrainLifetimeNtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4drop(ptr noalias nofree noundef align 8 captures(address, read_provenance) dereferenceable(24) %self) unnamed_addr #2 personality ptr @rust_eh_personality !dbg !2654 !guid !2656 {
start:
  %_12 = load ptr, ptr %self, align 8, !dbg !2657, !nonnull !41, !noundef !41
  %_3 = getelementptr inbounds nuw i8, ptr %_12, i64 16, !dbg !2666
  %0 = load atomic ptr, ptr %_3 acquire, align 8, !dbg !2667, !noalias !2674
  %_11.i.i = icmp eq ptr %0, null, !dbg !2677
  br i1 %_11.i.i, label %bb7.i.i, label %_RINvMNtNtNtCs1SSuMAdGM58_3std3sys4sync8once_boxINtB3_7OnceBoxNtNtNtNtNtB7_3pal4unix4sync5mutex5MutexE11get_or_initNCNvMNtNtB5_5mutex7pthreadNtB1T_5Mutex3get0ECshxBJAVx362N_11runtime_lab.exit.i, !dbg !2682, !prof !135

bb7.i.i:                                          ; preds = %start
; call <std::sys::sync::once_box::OnceBox<std::sys::pal::unix::sync::mutex::Mutex>>::initialize::<<std::sys::sync::mutex::pthread::Mutex>::get::{closure#0}>
  %1 = tail call fastcc noundef nonnull align 8 ptr @_RINvMNtNtNtCs1SSuMAdGM58_3std3sys4sync8once_boxINtB3_7OnceBoxNtNtNtNtNtB7_3pal4unix4sync5mutex5MutexE10initializeNCNvMNtNtB5_5mutex7pthreadNtB1S_5Mutex3get0ECshxBJAVx362N_11runtime_lab(ptr noundef nonnull align 8 %_3), !dbg !2683, !noalias !2674
  br label %_RINvMNtNtNtCs1SSuMAdGM58_3std3sys4sync8once_boxINtB3_7OnceBoxNtNtNtNtNtB7_3pal4unix4sync5mutex5MutexE11get_or_initNCNvMNtNtB5_5mutex7pthreadNtB1T_5Mutex3get0ECshxBJAVx362N_11runtime_lab.exit.i, !dbg !2684

_RINvMNtNtNtCs1SSuMAdGM58_3std3sys4sync8once_boxINtB3_7OnceBoxNtNtNtNtNtB7_3pal4unix4sync5mutex5MutexE11get_or_initNCNvMNtNtB5_5mutex7pthreadNtB1T_5Mutex3get0ECshxBJAVx362N_11runtime_lab.exit.i: ; preds = %bb7.i.i, %start
  %_0.sroa.0.0.i.i = phi ptr [ %1, %bb7.i.i ], [ %0, %start ], !dbg !2685
; call <std::sys::pal::unix::sync::mutex::Mutex>::lock
  tail call void @_RNvMNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutexNtB2_5Mutex4lock(ptr noundef nonnull align 8 %_0.sroa.0.0.i.i), !dbg !2686, !noalias !2674
  %2 = load atomic i64, ptr @_RNvNtNtCs1SSuMAdGM58_3std9panicking11panic_count18GLOBAL_PANIC_COUNT monotonic, align 8, !dbg !2687, !noalias !2674
  %_7.i.i = and i64 %2, 9223372036854775807, !dbg !2695
  %3 = icmp eq i64 %_7.i.i, 0, !dbg !2695
  br i1 %3, label %_RNvMs5_NtNtNtCs1SSuMAdGM58_3std4sync6poison5mutexINtB5_5MutexNtNtCshxBJAVx362N_11runtime_lab7process7CaptureE4lockB11_.exit.thread, label %_RNvMs5_NtNtNtCs1SSuMAdGM58_3std4sync6poison5mutexINtB5_5MutexNtNtCshxBJAVx362N_11runtime_lab7process7CaptureE4lockB11_.exit, !dbg !2695, !prof !74

_RNvMs5_NtNtNtCs1SSuMAdGM58_3std4sync6poison5mutexINtB5_5MutexNtNtCshxBJAVx362N_11runtime_lab7process7CaptureE4lockB11_.exit: ; preds = %_RINvMNtNtNtCs1SSuMAdGM58_3std3sys4sync8once_boxINtB3_7OnceBoxNtNtNtNtNtB7_3pal4unix4sync5mutex5MutexE11get_or_initNCNvMNtNtB5_5mutex7pthreadNtB1T_5Mutex3get0ECshxBJAVx362N_11runtime_lab.exit.i
; call std::panicking::panic_count::is_zero_slow_path
  %4 = tail call noundef zeroext i1 @_RNvNtNtCs1SSuMAdGM58_3std9panicking11panic_count17is_zero_slow_path() #24, !dbg !2696, !noalias !2674
  %5 = xor i1 %4, true, !dbg !2697
  %_7.i = getelementptr inbounds nuw i8, ptr %_12, i64 24, !dbg !2698
  %6 = load atomic i8, ptr %_7.i monotonic, align 8, !dbg !2699, !noalias !2674
  %_4.not.i.i.not = icmp eq i8 %6, 0, !dbg !2703
  %_0.sroa.3.0.i.i = zext i1 %5 to i8, !dbg !2704
  br i1 %_4.not.i.i.not, label %bb2, label %bb3.i, !dbg !2705

_RNvMs5_NtNtNtCs1SSuMAdGM58_3std4sync6poison5mutexINtB5_5MutexNtNtCshxBJAVx362N_11runtime_lab7process7CaptureE4lockB11_.exit.thread: ; preds = %_RINvMNtNtNtCs1SSuMAdGM58_3std3sys4sync8once_boxINtB3_7OnceBoxNtNtNtNtNtB7_3pal4unix4sync5mutex5MutexE11get_or_initNCNvMNtNtB5_5mutex7pthreadNtB1T_5Mutex3get0ECshxBJAVx362N_11runtime_lab.exit.i
  %_7.i10 = getelementptr inbounds nuw i8, ptr %_12, i64 24, !dbg !2698
  %7 = load atomic i8, ptr %_7.i10 monotonic, align 8, !dbg !2699, !noalias !2674
  %_4.not.i.i11.not = icmp eq i8 %7, 0, !dbg !2703
  br i1 %_4.not.i.i11.not, label %bb2, label %bb1.i.i.i.i.i, !dbg !2705

bb2:                                              ; preds = %_RNvMs5_NtNtNtCs1SSuMAdGM58_3std4sync6poison5mutexINtB5_5MutexNtNtCshxBJAVx362N_11runtime_lab7process7CaptureE4lockB11_.exit.thread, %_RNvMs5_NtNtNtCs1SSuMAdGM58_3std4sync6poison5mutexINtB5_5MutexNtNtCshxBJAVx362N_11runtime_lab7process7CaptureE4lockB11_.exit
  %_0.sroa.3.0.i.i18 = phi i8 [ 0, %_RNvMs5_NtNtNtCs1SSuMAdGM58_3std4sync6poison5mutexINtB5_5MutexNtNtCshxBJAVx362N_11runtime_lab7process7CaptureE4lockB11_.exit.thread ], [ %_0.sroa.3.0.i.i, %_RNvMs5_NtNtNtCs1SSuMAdGM58_3std4sync6poison5mutexINtB5_5MutexNtNtCshxBJAVx362N_11runtime_lab7process7CaptureE4lockB11_.exit ]
  %_7.i17 = phi ptr [ %_7.i10, %_RNvMs5_NtNtNtCs1SSuMAdGM58_3std4sync6poison5mutexINtB5_5MutexNtNtCshxBJAVx362N_11runtime_lab7process7CaptureE4lockB11_.exit.thread ], [ %_7.i, %_RNvMs5_NtNtNtCs1SSuMAdGM58_3std4sync6poison5mutexINtB5_5MutexNtNtCshxBJAVx362N_11runtime_lab7process7CaptureE4lockB11_.exit ]
  %_6.sroa.0.0.off0.i.i15 = phi i1 [ false, %_RNvMs5_NtNtNtCs1SSuMAdGM58_3std4sync6poison5mutexINtB5_5MutexNtNtCshxBJAVx362N_11runtime_lab7process7CaptureE4lockB11_.exit.thread ], [ %5, %_RNvMs5_NtNtNtCs1SSuMAdGM58_3std4sync6poison5mutexINtB5_5MutexNtNtCshxBJAVx362N_11runtime_lab7process7CaptureE4lockB11_.exit ]
  %_8 = getelementptr inbounds nuw i8, ptr %self, i64 8, !dbg !2706
; invoke <std::time::Instant>::elapsed
  %8 = invoke { i64, i32 } @_RNvMNtCs1SSuMAdGM58_3std4timeNtB2_7Instant7elapsed(ptr noalias nofree noundef nonnull readonly align 8 captures(address, read_provenance) dereferenceable(16) %_8)
          to label %bb3 unwind label %cleanup, !dbg !2707

cleanup:                                          ; preds = %bb2
  %9 = landingpad { ptr, i32 }
          cleanup
; invoke core::ptr::drop_glue::<std::sync::poison::PoisonError<std::sync::poison::mutex::MutexGuard<runtime_lab::process::Capture>>>
  invoke fastcc void @_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtCs1SSuMAdGM58_3std4sync6poison11PoisonErrorINtNtBE_5mutex10MutexGuardNtNtCshxBJAVx362N_11runtime_lab7process7CaptureEEEB1T_(ptr nonnull %_3, i8 %_0.sroa.3.0.i.i18) #23
          to label %bb7 unwind label %terminate, !dbg !2708

bb3:                                              ; preds = %bb2
  %_7.0 = extractvalue { i64, i32 } %8, 0, !dbg !2706
  %_7.1 = extractvalue { i64, i32 } %8, 1, !dbg !2706
  %10 = icmp ult i32 %_7.1, 1000000000, !dbg !2709
  tail call void @llvm.assume(i1 %10), !dbg !2709
  %11 = getelementptr inbounds nuw i8, ptr %_12, i64 128, !dbg !2710
  store i64 %_7.0, ptr %11, align 8, !dbg !2710
  %12 = getelementptr inbounds nuw i8, ptr %_12, i64 136, !dbg !2710
  store i32 %_7.1, ptr %12, align 8, !dbg !2710
  br i1 %_6.sroa.0.0.off0.i.i15, label %bb5, label %bb1.i.i.i, !dbg !2711

bb1.i.i.i:                                        ; preds = %bb3
  %13 = load atomic i64, ptr @_RNvNtNtCs1SSuMAdGM58_3std9panicking11panic_count18GLOBAL_PANIC_COUNT monotonic, align 8, !dbg !2715
  %_7.i.i.i = and i64 %13, 9223372036854775807, !dbg !2721
  %14 = icmp eq i64 %_7.i.i.i, 0, !dbg !2721
  br i1 %14, label %bb5, label %bb6.i.i.i, !dbg !2721, !prof !74

bb6.i.i.i:                                        ; preds = %bb1.i.i.i
; call std::panicking::panic_count::is_zero_slow_path
  %_6.i.i.i6 = tail call noundef zeroext i1 @_RNvNtNtCs1SSuMAdGM58_3std9panicking11panic_count17is_zero_slow_path() #24, !dbg !2722
  br i1 %_6.i.i.i6, label %bb5, label %bb5.sink.split, !dbg !2723

terminate:                                        ; preds = %cleanup
  %15 = landingpad { ptr, i32 }
          filter [0 x ptr] zeroinitializer
; call core::panicking::panic_in_cleanup
  tail call void @_RNvNtCsjIpoRzUjyHQ_4core9panicking16panic_in_cleanup() #22, !dbg !2724
  unreachable, !dbg !2724

bb7:                                              ; preds = %cleanup
  resume { ptr, i32 } %9, !dbg !2724

bb3.i:                                            ; preds = %_RNvMs5_NtNtNtCs1SSuMAdGM58_3std4sync6poison5mutexINtB5_5MutexNtNtCshxBJAVx362N_11runtime_lab7process7CaptureE4lockB11_.exit
  br i1 %4, label %bb1.i.i.i.i.i, label %bb5, !dbg !2725

bb1.i.i.i.i.i:                                    ; preds = %_RNvMs5_NtNtNtCs1SSuMAdGM58_3std4sync6poison5mutexINtB5_5MutexNtNtCshxBJAVx362N_11runtime_lab7process7CaptureE4lockB11_.exit.thread, %bb3.i
  %_7.i1621 = phi ptr [ %_7.i, %bb3.i ], [ %_7.i10, %_RNvMs5_NtNtNtCs1SSuMAdGM58_3std4sync6poison5mutexINtB5_5MutexNtNtCshxBJAVx362N_11runtime_lab7process7CaptureE4lockB11_.exit.thread ]
  %16 = load atomic i64, ptr @_RNvNtNtCs1SSuMAdGM58_3std9panicking11panic_count18GLOBAL_PANIC_COUNT monotonic, align 8, !dbg !2732, !noalias !2738
  %_7.i.i.i.i.i = and i64 %16, 9223372036854775807, !dbg !2741
  %17 = icmp eq i64 %_7.i.i.i.i.i, 0, !dbg !2741
  br i1 %17, label %bb5, label %bb6.i.i.i.i.i, !dbg !2741, !prof !74

bb6.i.i.i.i.i:                                    ; preds = %bb1.i.i.i.i.i
; call std::panicking::panic_count::is_zero_slow_path
  %_6.i.i.i.i.i = tail call noundef zeroext i1 @_RNvNtNtCs1SSuMAdGM58_3std9panicking11panic_count17is_zero_slow_path() #24, !dbg !2742, !noalias !2738
  br i1 %_6.i.i.i.i.i, label %bb5, label %bb5.sink.split, !dbg !2743

bb5.sink.split:                                   ; preds = %bb6.i.i.i.i.i, %bb6.i.i.i
  %_7.i1621.sink = phi ptr [ %_7.i17, %bb6.i.i.i ], [ %_7.i1621, %bb6.i.i.i.i.i ]
  store atomic i8 1, ptr %_7.i1621.sink monotonic, align 1, !dbg !2744
  br label %bb5, !dbg !2744

bb5:                                              ; preds = %bb5.sink.split, %bb6.i.i.i.i.i, %bb1.i.i.i.i.i, %bb3.i, %bb3, %bb1.i.i.i, %bb6.i.i.i
  %18 = load atomic ptr, ptr %_3 monotonic, align 8, !dbg !2744
; call <std::sys::pal::unix::sync::mutex::Mutex>::unlock
  tail call void @_RNvMNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutexNtB2_5Mutex6unlock(ptr noundef nonnull align 8 %18), !dbg !2744
  ret void, !dbg !2745
}

; <<core::io::error::Error>::from_raw_os_error::FUNCTIONS::{closure#0} as core::ops::function::FnOnce<(i32, &mut core::fmt::Formatter)>>::call_once
; Function Attrs: inlinehint uwtable
define internal noundef zeroext i1 @_RNvYNCNvNvMNtNtCs1SSuMAdGM58_3std2io5errorNtNtNtCsjIpoRzUjyHQ_4core2io5error5Error17from_raw_os_error9FUNCTIONS0INtNtNtBK_3ops8function6FnOnceTlQNtNtBK_3fmt9FormatterEE9call_onceCshxBJAVx362N_11runtime_lab(i32 noundef %0, ptr noalias nofree noundef align 8 dereferenceable(24) %1) unnamed_addr #5 personality ptr @rust_eh_personality !dbg !2746 !guid !2747 {
start:
  %_6.i = alloca [24 x i8], align 8
  call void @llvm.lifetime.start.p0(ptr nonnull %_6.i), !dbg !2748, !noalias !2756
; call std::sys::io::error::unix::error_string
  call void @_RNvNtNtNtNtCs1SSuMAdGM58_3std3sys2io5error4unix12error_string(ptr noalias nofree noundef nonnull sret([24 x i8]) align 8 captures(address) dereferenceable(24) %_6.i, i32 noundef %0), !dbg !2748, !noalias !2756
  %2 = getelementptr inbounds nuw i8, ptr %_6.i, i64 8, !dbg !2759
  %_11.i = load ptr, ptr %2, align 8, !dbg !2759, !noalias !2756, !nonnull !41, !noundef !41
  %3 = getelementptr inbounds nuw i8, ptr %_6.i, i64 16, !dbg !2782
  %_10.i = load i64, ptr %3, align 8, !dbg !2782, !noalias !2756, !noundef !41
; invoke <core::fmt::Formatter>::write_str
  %_0.i = invoke noundef zeroext i1 @_RNvMsa_NtCsjIpoRzUjyHQ_4core3fmtNtB5_9Formatter9write_str(ptr noalias nofree noundef nonnull align 8 dereferenceable(24) %1, ptr noalias nofree noundef nonnull readonly captures(address, read_provenance) %_11.i, i64 noundef %_10.i)
          to label %bb2.i unwind label %cleanup.i, !dbg !2783

cleanup.i:                                        ; preds = %start
  %4 = landingpad { ptr, i32 }
          cleanup
  %_6.val.i = load i64, ptr %_6.i, align 8, !dbg !2784, !noalias !2756
  %5 = icmp eq i64 %_6.val.i, 0, !dbg !2785
  br i1 %5, label %bb5.i, label %_RNvXs1_NtCs6zY7rJBZy9D_5alloc5allocNtB5_6GlobalNtNtCsjIpoRzUjyHQ_4core5alloc9Allocator10deallocate.exit.i.i.i4.i.i.i, !dbg !2785

_RNvXs1_NtCs6zY7rJBZy9D_5alloc5allocNtB5_6GlobalNtNtCsjIpoRzUjyHQ_4core5alloc9Allocator10deallocate.exit.i.i.i4.i.i.i: ; preds = %cleanup.i
; call __rustc::__rust_dealloc
  call void @_RNvCsdtSMxSA38aw_7___rustc14___rust_dealloc(ptr noundef nonnull %_11.i, i64 noundef %_6.val.i, i64 noundef range(i64 1, -9223372036854775807) 1) #20, !dbg !2792
  br label %bb5.i, !dbg !2797

bb2.i:                                            ; preds = %start
  %_6.val2.i = load i64, ptr %_6.i, align 8, !dbg !2784, !noalias !2756
  %6 = icmp eq i64 %_6.val2.i, 0, !dbg !2798
  br i1 %6, label %_RNCNvNvMNtNtCs1SSuMAdGM58_3std2io5errorNtNtNtCsjIpoRzUjyHQ_4core2io5error5Error17from_raw_os_error9FUNCTIONS0CshxBJAVx362N_11runtime_lab.exit, label %_RNvXs1_NtCs6zY7rJBZy9D_5alloc5allocNtB5_6GlobalNtNtCsjIpoRzUjyHQ_4core5alloc9Allocator10deallocate.exit.i.i.i4.i.i4.i, !dbg !2798

_RNvXs1_NtCs6zY7rJBZy9D_5alloc5allocNtB5_6GlobalNtNtCsjIpoRzUjyHQ_4core5alloc9Allocator10deallocate.exit.i.i.i4.i.i4.i: ; preds = %bb2.i
; call __rustc::__rust_dealloc
  call void @_RNvCsdtSMxSA38aw_7___rustc14___rust_dealloc(ptr noundef nonnull %_11.i, i64 noundef %_6.val2.i, i64 noundef range(i64 1, -9223372036854775807) 1) #20, !dbg !2805
  br label %_RNCNvNvMNtNtCs1SSuMAdGM58_3std2io5errorNtNtNtCsjIpoRzUjyHQ_4core2io5error5Error17from_raw_os_error9FUNCTIONS0CshxBJAVx362N_11runtime_lab.exit, !dbg !2810

bb5.i:                                            ; preds = %_RNvXs1_NtCs6zY7rJBZy9D_5alloc5allocNtB5_6GlobalNtNtCsjIpoRzUjyHQ_4core5alloc9Allocator10deallocate.exit.i.i.i4.i.i.i, %cleanup.i
  resume { ptr, i32 } %4, !dbg !2811

_RNCNvNvMNtNtCs1SSuMAdGM58_3std2io5errorNtNtNtCsjIpoRzUjyHQ_4core2io5error5Error17from_raw_os_error9FUNCTIONS0CshxBJAVx362N_11runtime_lab.exit: ; preds = %bb2.i, %_RNvXs1_NtCs6zY7rJBZy9D_5alloc5allocNtB5_6GlobalNtNtCsjIpoRzUjyHQ_4core5alloc9Allocator10deallocate.exit.i.i.i4.i.i4.i
  call void @llvm.lifetime.end.p0(ptr nonnull %_6.i), !dbg !2784, !noalias !2756
  ret i1 %_0.i, !dbg !2812
}

; Function Attrs: nounwind uwtable
declare noundef range(i32 0, 10) i32 @rust_eh_personality(i32 noundef, i32 noundef, i64 noundef, ptr noundef, ptr noundef) unnamed_addr #3

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(ptr captures(none)) #10

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(ptr captures(none)) #10

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(inaccessiblemem: write)
declare void @llvm.assume(i1 noundef) #11

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.memcpy.p0.p0.i64(ptr noalias writeonly captures(none), ptr noalias readonly captures(none), i64, i1 immarg) #10

; core::panicking::panic_in_cleanup
; Function Attrs: cold minsize noinline noreturn nounwind optsize uwtable
declare void @_RNvNtCsjIpoRzUjyHQ_4core9panicking16panic_in_cleanup() unnamed_addr #12

; <std::sys::sync::once::queue::Once>::call
; Function Attrs: cold uwtable
declare void @_RNvMNtNtNtNtCs1SSuMAdGM58_3std3sys4sync4once5queueNtB2_4Once4call(ptr noundef nonnull align 8, i1 noundef zeroext, ptr noundef nonnull, ptr noalias nofree noundef readonly align 8 captures(address, read_provenance) dereferenceable(40), ptr noalias nofree noundef readonly align 8 captures(address, read_provenance) dereferenceable(24)) unnamed_addr #1

; <mio::sys::unix::pipe::Sender as mio::event::source::Source>::deregister
; Function Attrs: uwtable
declare noundef ptr @_RNvXs_NtNtNtCsiDZg47dpzEY_3mio3sys4unix4pipeNtB4_6SenderNtNtNtBa_5event6source6Source10deregister(ptr noalias nofree noundef align 4 dereferenceable(4), ptr noalias nofree noundef readonly align 4 captures(address, read_provenance) dereferenceable(4)) unnamed_addr #2

; <tokio::runtime::io::registration_set::RegistrationSet>::deregister
; Function Attrs: uwtable
declare noundef zeroext i1 @_RNvMNtNtNtCs3EIJ1qnJmKW_5tokio7runtime2io16registration_setNtB2_15RegistrationSet10deregister(ptr noundef nonnull align 8, ptr noalias nofree noundef align 8 dereferenceable(48), ptr noalias nofree noundef readonly align 8 captures(address, read_provenance) dereferenceable(8)) unnamed_addr #2

; <tokio::runtime::io::driver::Handle>::unpark
; Function Attrs: uwtable
declare void @_RNvMs0_NtNtNtCs3EIJ1qnJmKW_5tokio7runtime2io6driverNtB5_6Handle6unpark(ptr noundef nonnull align 8) unnamed_addr #2

; <mio::sys::unix::pipe::Receiver as mio::event::source::Source>::deregister
; Function Attrs: uwtable
declare noundef ptr @_RNvXsa_NtNtNtCsiDZg47dpzEY_3mio3sys4unix4pipeNtB5_8ReceiverNtNtNtBb_5event6source6Source10deregister(ptr noalias nofree noundef align 4 dereferenceable(4), ptr noalias nofree noundef readonly align 4 captures(address, read_provenance) dereferenceable(4)) unnamed_addr #2

; <std::sys::process::unix::common::Command>::stderr
; Function Attrs: uwtable
declare void @_RNvMs_NtNtNtNtCs1SSuMAdGM58_3std3sys7process4unix6commonNtB4_7Command6stderr(ptr noalias nofree noundef align 8 dereferenceable(200), i32 noundef range(i32 0, 5), i32) unnamed_addr #2

; <std::sys::process::unix::common::Command>::stdout
; Function Attrs: uwtable
declare void @_RNvMs_NtNtNtNtCs1SSuMAdGM58_3std3sys7process4unix6commonNtB4_7Command6stdout(ptr noalias nofree noundef align 8 dereferenceable(200), i32 noundef range(i32 0, 5), i32) unnamed_addr #2

; <core::io::error::CustomOwner as core::ops::drop::Drop>::drop
; Function Attrs: uwtable
declare void @_RNvXsd_NtNtCsjIpoRzUjyHQ_4core2io5errorNtB5_11CustomOwnerNtNtNtB9_3ops4drop4Drop4drop(ptr noalias nofree noundef align 8 dereferenceable(8)) unnamed_addr #2

; <tokio::runtime::io::registration::Registration as core::ops::drop::Drop>::drop
; Function Attrs: uwtable
declare void @_RNvXs1_NtNtNtCs3EIJ1qnJmKW_5tokio7runtime2io12registrationNtB5_12RegistrationNtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4drop(ptr noalias nofree noundef align 8 dereferenceable(24)) unnamed_addr #2

; <std::sys::sync::mutex::pthread::Mutex as core::ops::drop::Drop>::drop
; Function Attrs: uwtable
declare void @_RNvXs_NtNtNtNtCs1SSuMAdGM58_3std3sys4sync5mutex7pthreadNtB4_5MutexNtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4drop(ptr noalias nofree noundef align 8 dereferenceable(8)) unnamed_addr #2

; <std::sys::pal::unix::sync::mutex::Mutex as core::ops::drop::Drop>::drop
; Function Attrs: uwtable
declare void @_RNvXs2_NtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutexNtB5_5MutexNtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4drop(ptr noundef nonnull align 8) unnamed_addr #2

; core::panicking::assert_failed_inner
; Function Attrs: cold minsize noinline noreturn optsize uwtable
declare void @_RNvNtCsjIpoRzUjyHQ_4core9panicking19assert_failed_inner(i8 noundef range(i8 0, 3), ptr noundef nonnull, ptr noalias nofree noundef readonly align 8 captures(address, read_provenance) dereferenceable(32), ptr noundef nonnull, ptr noalias nofree noundef readonly align 8 captures(address, read_provenance) dereferenceable(32), ptr noundef, ptr, ptr noalias nofree noundef readonly align 8 captures(address, read_provenance) dereferenceable(24)) unnamed_addr #4

; core::option::unwrap_failed
; Function Attrs: cold noinline noreturn uwtable
declare void @_RNvNtCsjIpoRzUjyHQ_4core6option13unwrap_failed(ptr noalias nofree noundef readonly align 8 captures(address, read_provenance) dereferenceable(24)) unnamed_addr #13

; <std::time::Instant>::elapsed
; Function Attrs: uwtable
declare { i64, i32 } @_RNvMNtCs1SSuMAdGM58_3std4timeNtB2_7Instant7elapsed(ptr noalias nofree noundef readonly align 8 captures(address, read_provenance) dereferenceable(16)) unnamed_addr #2

; <core::io::error::Error>::new::<&str>
; Function Attrs: noinline uwtable
declare noundef nonnull ptr @_RINvMNtNtCs6zY7rJBZy9D_5alloc2io5errorNtNtNtCsjIpoRzUjyHQ_4core2io5error5Error3newReECs1SSuMAdGM58_3std(i8 noundef range(i8 0, 44), ptr noalias nofree noundef nonnull readonly captures(address, read_provenance), i64 noundef) unnamed_addr #7

; core::option::expect_failed
; Function Attrs: cold noinline noreturn uwtable
declare void @_RNvNtCsjIpoRzUjyHQ_4core6option13expect_failed(ptr noalias nofree noundef nonnull readonly captures(address, read_provenance), i64 noundef, ptr noalias nofree noundef readonly align 8 captures(address, read_provenance) dereferenceable(24)) unnamed_addr #13

; <std::sys::pal::unix::sync::mutex::Mutex>::init
; Function Attrs: uwtable
declare void @_RNvMNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutexNtB2_5Mutex4init(ptr noundef nonnull align 8) unnamed_addr #2

; Function Attrs: nounwind uwtable
declare noundef ptr @dlsym(ptr noundef, ptr noundef) unnamed_addr #3

; std::sys::io::error::unix::error_string
; Function Attrs: uwtable
declare void @_RNvNtNtNtNtCs1SSuMAdGM58_3std3sys2io5error4unix12error_string(ptr dead_on_unwind noalias nofree noundef writable sret([24 x i8]) align 8 captures(address) dereferenceable(24), i32 noundef) unnamed_addr #2

; <core::fmt::Formatter>::write_str
; Function Attrs: uwtable
declare noundef zeroext i1 @_RNvMsa_NtCsjIpoRzUjyHQ_4core3fmtNtB5_9Formatter9write_str(ptr noalias nofree noundef align 8 dereferenceable(24), ptr noalias nofree noundef nonnull readonly captures(address, read_provenance), i64 noundef) unnamed_addr #2

; <tokio::runtime::builder::Builder>::new_multi_thread
; Function Attrs: uwtable
declare void @_RNvMNtNtCs3EIJ1qnJmKW_5tokio7runtime7builderNtB2_7Builder16new_multi_thread(ptr dead_on_unwind noalias nofree noundef writable sret([264 x i8]) align 8 captures(address) dereferenceable(264)) unnamed_addr #2

; <tokio::runtime::builder::Builder>::worker_threads
; Function Attrs: uwtable
declare noundef nonnull align 8 ptr @_RNvMNtNtCs3EIJ1qnJmKW_5tokio7runtime7builderNtB2_7Builder14worker_threads(ptr noalias nofree noundef align 8 dereferenceable(264), i64 noundef, ptr noalias nofree noundef readonly align 8 captures(address, read_provenance) dereferenceable(24)) unnamed_addr #2

; <tokio::runtime::builder::Builder>::build
; Function Attrs: uwtable
declare void @_RNvMNtNtCs3EIJ1qnJmKW_5tokio7runtime7builderNtB2_7Builder5build(ptr dead_on_unwind noalias nofree noundef writable sret([88 x i8]) align 8 captures(address) dereferenceable(88), ptr noalias nofree noundef align 8 dereferenceable(264)) unnamed_addr #2

; <tokio::runtime::builder::Builder>::new_current_thread
; Function Attrs: uwtable
declare void @_RNvMNtNtCs3EIJ1qnJmKW_5tokio7runtime7builderNtB2_7Builder18new_current_thread(ptr dead_on_unwind noalias nofree noundef writable sret([264 x i8]) align 8 captures(address) dereferenceable(264)) unnamed_addr #2

; <std::process::Command>::spawn
; Function Attrs: uwtable
declare void @_RNvMsi_NtCs1SSuMAdGM58_3std7processNtB5_7Command5spawn(ptr dead_on_unwind noalias nofree noundef writable sret([24 x i8]) align 8 captures(none) dereferenceable(24), ptr noalias nofree noundef align 8 dereferenceable(200)) unnamed_addr #2

; <tokio::process::Command>::build_child
; Function Attrs: uwtable
declare void @_RNvMNtCs3EIJ1qnJmKW_5tokio7processNtB2_7Command11build_child(ptr dead_on_unwind noalias nofree noundef writable sret([144 x i8]) align 8 captures(none) dereferenceable(144), ptr noalias nofree noundef readonly align 8 captures(address, read_provenance) dereferenceable(208), ptr noalias nofree noundef align 4 captures(address) dead_on_return dereferenceable(24)) unnamed_addr #2

; std::panicking::panic_count::is_zero_slow_path
; Function Attrs: cold noinline uwtable
declare noundef zeroext i1 @_RNvNtNtCs1SSuMAdGM58_3std9panicking11panic_count17is_zero_slow_path() unnamed_addr #14

; __rustc::__rust_dealloc
; Function Attrs: nounwind allockind("free") uwtable
declare void @_RNvCsdtSMxSA38aw_7___rustc14___rust_dealloc(ptr allocptr noundef nonnull captures(address), i64 noundef, i64 noundef range(i64 1, -9223372036854775807)) unnamed_addr #15

; __rustc::__rust_no_alloc_shim_is_unstable_v2
; Function Attrs: nounwind uwtable
declare void @_RNvCsdtSMxSA38aw_7___rustc35___rust_no_alloc_shim_is_unstable_v2() unnamed_addr #3

; __rustc::__rust_alloc
; Function Attrs: nounwind allockind("alloc,uninitialized,aligned") allocsize(0) uwtable
declare noalias noundef ptr @_RNvCsdtSMxSA38aw_7___rustc12___rust_alloc(i64 noundef, i64 allocalign noundef range(i64 1, -9223372036854775807)) unnamed_addr #16

; core::io::error::os_functions::set_functions::set_functions_inner
; Function Attrs: cold uwtable
declare void @_RNvNvNtNtNtCsjIpoRzUjyHQ_4core2io5error12os_functions13set_functions19set_functions_inner(ptr noalias nofree noundef readonly align 8 captures(address, read_provenance) dereferenceable(24)) unnamed_addr #1

; <tokio::runtime::task::raw::RawTask>::remote_abort
; Function Attrs: uwtable
declare void @_RNvMs_NtNtNtCs3EIJ1qnJmKW_5tokio7runtime4task7harnessNtNtB6_3raw7RawTask12remote_abort(ptr noalias nofree noundef readonly align 8 captures(address, read_provenance) dereferenceable(8)) unnamed_addr #2

; <std::sys::pal::unix::sync::mutex::Mutex>::lock
; Function Attrs: uwtable
declare void @_RNvMNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutexNtB2_5Mutex4lock(ptr noundef nonnull align 8) unnamed_addr #2

; alloc::alloc::handle_alloc_error
; Function Attrs: cold minsize noreturn optsize uwtable
declare void @_RNvNtCs6zY7rJBZy9D_5alloc5alloc18handle_alloc_error(i64 noundef range(i64 1, -9223372036854775807), i64 noundef) unnamed_addr #17

; Function Attrs: nofree nosync nounwind memory(none) uwtable
declare noundef ptr @__error() unnamed_addr #18

; <tokio::process::ChildStdout>::from_std
; Function Attrs: uwtable
declare void @_RNvMs5_NtCs3EIJ1qnJmKW_5tokio7processNtB5_11ChildStdout8from_std(ptr dead_on_unwind noalias nofree noundef writable sret([32 x i8]) align 8 captures(none) dereferenceable(32), i32 noundef range(i32 0, -1)) unnamed_addr #2

; <tokio::process::ChildStderr>::from_std
; Function Attrs: uwtable
declare void @_RNvMs6_NtCs3EIJ1qnJmKW_5tokio7processNtB5_11ChildStderr8from_std(ptr dead_on_unwind noalias nofree noundef writable sret([32 x i8]) align 8 captures(none) dereferenceable(32), i32 noundef range(i32 0, -1)) unnamed_addr #2

; <tokio::process::imp::Child as tokio::process::kill::Kill>::kill
; Function Attrs: uwtable
declare noundef ptr @_RNvXs5_NtNtCs3EIJ1qnJmKW_5tokio7process3impNtB5_5ChildNtNtB7_4kill4Kill4kill(ptr noalias nofree noundef align 8 dereferenceable(40)) unnamed_addr #2

; <std::process::Child as tokio::process::imp::orphan::Wait>::try_wait
; Function Attrs: uwtable
declare void @_RNvXNtNtCs3EIJ1qnJmKW_5tokio7process3impNtNtCs1SSuMAdGM58_3std7process5ChildNtNtB2_6orphan4Wait8try_wait(ptr dead_on_unwind noalias nofree noundef writable sret([16 x i8]) align 8 captures(address) dereferenceable(16), ptr noalias nofree noundef align 4 dereferenceable(24)) unnamed_addr #2

; <tokio::process::imp::GlobalOrphanQueue as tokio::process::imp::orphan::OrphanQueue<std::process::Child>>::push_orphan
; Function Attrs: uwtable
declare void @_RNvXs2_NtNtCs3EIJ1qnJmKW_5tokio7process3impNtB5_17GlobalOrphanQueueINtNtB5_6orphan11OrphanQueueNtNtCs1SSuMAdGM58_3std7process5ChildE11push_orphan(ptr noalias nofree noundef nonnull readonly captures(address, read_provenance), ptr noalias nofree noundef align 4 captures(address) dead_on_return dereferenceable(24)) unnamed_addr #2

; <tokio::runtime::io::registration::Registration>::handle
; Function Attrs: uwtable
declare noundef nonnull align 8 ptr @_RNvMs0_NtNtNtCs3EIJ1qnJmKW_5tokio7runtime2io12registrationNtB5_12Registration6handle(ptr noalias nofree noundef readonly align 8 captures(address, read_provenance) dereferenceable(24)) unnamed_addr #2

; Function Attrs: nounwind uwtable
declare noundef i32 @close(i32 noundef) unnamed_addr #3

; <alloc::sync::Arc<dyn for<'a, 'b> core::ops::function::Fn<(&'a tokio::runtime::task_hooks::TaskMeta<'b>,), Output = ()> + core::marker::Send + core::marker::Sync>>::drop_slow
; Function Attrs: noinline uwtable
declare void @_RNvMsn_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcDG0_INtNtNtCsjIpoRzUjyHQ_4core3ops8function2FnTRL1_INtNtNtCs3EIJ1qnJmKW_5tokio7runtime10task_hooks8TaskMetaL0_EEEp6OutputuNtNtBR_6marker4SendNtB2G_4SyncEL_E9drop_slowB1C_(ptr noalias nofree noundef align 8 dereferenceable(16)) unnamed_addr #7

; <alloc::sync::Arc<dyn core::ops::function::Fn<(), Output = alloc::string::String> + core::marker::Send + core::marker::Sync>>::drop_slow
; Function Attrs: noinline uwtable
declare void @_RNvMsn_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcDINtNtNtCsjIpoRzUjyHQ_4core3ops8function2FnuEp6OutputNtNtB7_6string6StringNtNtBO_6marker4SendNtB1U_4SyncEL_E9drop_slowCs3EIJ1qnJmKW_5tokio(ptr noalias nofree noundef align 8 dereferenceable(16)) unnamed_addr #7

; <alloc::sync::Arc<dyn core::ops::function::Fn<(), Output = ()> + core::marker::Send + core::marker::Sync>>::drop_slow
; Function Attrs: noinline uwtable
declare void @_RNvMsn_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcDINtNtNtCsjIpoRzUjyHQ_4core3ops8function2FnuEp6OutputuNtNtBO_6marker4SendNtB1A_4SyncEL_E9drop_slowCs3EIJ1qnJmKW_5tokio(ptr noalias nofree noundef align 8 dereferenceable(16)) unnamed_addr #7

; <alloc::sync::Arc<tokio::runtime::io::scheduled_io::ScheduledIo>>::drop_slow
; Function Attrs: noinline uwtable
declare void @_RNvMsn_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcNtNtNtNtCs3EIJ1qnJmKW_5tokio7runtime2io12scheduled_io11ScheduledIoE9drop_slowBO_(ptr noalias nofree noundef align 8 dereferenceable(8)) unnamed_addr #7

; <alloc::sync::Arc<tokio::runtime::scheduler::current_thread::Handle>>::drop_slow
; Function Attrs: noinline uwtable
declare void @_RNvMsn_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcNtNtNtNtCs3EIJ1qnJmKW_5tokio7runtime9scheduler14current_thread6HandleE9drop_slowBO_(ptr noalias nofree noundef align 8 dereferenceable(8)) unnamed_addr #7

; <alloc::sync::Arc<tokio::runtime::scheduler::multi_thread::handle::Handle>>::drop_slow
; Function Attrs: noinline uwtable
declare void @_RNvMsn_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcNtNtNtNtNtCs3EIJ1qnJmKW_5tokio7runtime9scheduler12multi_thread6handle6HandleE9drop_slowBQ_(ptr noalias nofree noundef align 8 dereferenceable(8)) unnamed_addr #7

; <core::fmt::Formatter>::debug_tuple_field1_finish
; Function Attrs: uwtable
declare noundef zeroext i1 @_RNvMsa_NtCsjIpoRzUjyHQ_4core3fmtNtB5_9Formatter25debug_tuple_field1_finish(ptr noalias nofree noundef align 8 dereferenceable(24), ptr noalias nofree noundef nonnull readonly captures(address, read_provenance), i64 noundef, ptr noundef nonnull, ptr noalias nofree noundef readonly align 8 captures(address, read_provenance) dereferenceable(32)) unnamed_addr #2

; <std::sys::pal::unix::sync::mutex::Mutex>::unlock
; Function Attrs: uwtable
declare void @_RNvMNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutexNtB2_5Mutex6unlock(ptr noundef nonnull align 8) unnamed_addr #2

; core::fmt::pointer_fmt_inner
; Function Attrs: uwtable
declare noundef zeroext i1 @_RNvNtCsjIpoRzUjyHQ_4core3fmt17pointer_fmt_inner(i64 noundef, ptr noalias nofree noundef align 8 dereferenceable(24)) unnamed_addr #2

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(inaccessiblemem: readwrite)
declare void @llvm.experimental.noalias.scope.decl(metadata) #19

attributes #0 = { cold minsize optsize uwtable "frame-pointer"="non-leaf" "probe-stack"="inline-asm" "target-cpu"="apple-m1" }
attributes #1 = { cold uwtable "frame-pointer"="non-leaf" "probe-stack"="inline-asm" "target-cpu"="apple-m1" }
attributes #2 = { uwtable "frame-pointer"="non-leaf" "probe-stack"="inline-asm" "target-cpu"="apple-m1" }
attributes #3 = { nounwind uwtable "frame-pointer"="non-leaf" "probe-stack"="inline-asm" "target-cpu"="apple-m1" }
attributes #4 = { cold minsize noinline noreturn optsize uwtable "frame-pointer"="non-leaf" "probe-stack"="inline-asm" "target-cpu"="apple-m1" }
attributes #5 = { inlinehint uwtable "frame-pointer"="non-leaf" "probe-stack"="inline-asm" "target-cpu"="apple-m1" }
attributes #6 = { mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: write) uwtable "frame-pointer"="non-leaf" "probe-stack"="inline-asm" "target-cpu"="apple-m1" }
attributes #7 = { noinline uwtable "frame-pointer"="non-leaf" "probe-stack"="inline-asm" "target-cpu"="apple-m1" }
attributes #8 = { inlinehint mustprogress nofree norecurse nosync nounwind willreturn memory(none) uwtable "frame-pointer"="non-leaf" "probe-stack"="inline-asm" "target-cpu"="apple-m1" }
attributes #9 = { mustprogress nofree norecurse nosync nounwind willreturn memory(none) uwtable "frame-pointer"="non-leaf" "probe-stack"="inline-asm" "target-cpu"="apple-m1" }
attributes #10 = { mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #11 = { mustprogress nocallback nofree nosync nounwind willreturn memory(inaccessiblemem: write) }
attributes #12 = { cold minsize noinline noreturn nounwind optsize uwtable "frame-pointer"="non-leaf" "probe-stack"="inline-asm" "target-cpu"="apple-m1" }
attributes #13 = { cold noinline noreturn uwtable "frame-pointer"="non-leaf" "probe-stack"="inline-asm" "target-cpu"="apple-m1" }
attributes #14 = { cold noinline uwtable "frame-pointer"="non-leaf" "probe-stack"="inline-asm" "target-cpu"="apple-m1" }
attributes #15 = { nounwind allockind("free") uwtable "alloc-family"="__rust_alloc" "frame-pointer"="non-leaf" "probe-stack"="inline-asm" "target-cpu"="apple-m1" }
attributes #16 = { nounwind allockind("alloc,uninitialized,aligned") allocsize(0) uwtable "alloc-family"="__rust_alloc" "alloc-variant-zeroed"="_RNvCsdtSMxSA38aw_7___rustc19___rust_alloc_zeroed" "frame-pointer"="non-leaf" "probe-stack"="inline-asm" "target-cpu"="apple-m1" }
attributes #17 = { cold minsize noreturn optsize uwtable "frame-pointer"="non-leaf" "probe-stack"="inline-asm" "target-cpu"="apple-m1" }
attributes #18 = { nofree nosync nounwind memory(none) uwtable "frame-pointer"="non-leaf" "probe-stack"="inline-asm" "target-cpu"="apple-m1" }
attributes #19 = { nocallback nofree nosync nounwind willreturn memory(inaccessiblemem: readwrite) }
attributes #20 = { nounwind }
attributes #21 = { noreturn }
attributes #22 = { cold noreturn nounwind }
attributes #23 = { cold }
attributes #24 = { noinline }
attributes #25 = { noinline noreturn }

!llvm.module.flags = !{!26, !27, !28, !29, !30}
!llvm.ident = !{!31}
!llvm.dbg.cu = !{!32}

!0 = !{i64 5157828037158130225}
!1 = !{i64 -1146204364948043851}
!2 = !{i64 -7187220275227472462}
!3 = !{i64 -6237460402666962361}
!4 = !{i64 4578062539082098783}
!5 = !{i64 -2638136314530533401}
!6 = !{i64 6611611016138452785}
!7 = !{i64 8807579568345343267}
!8 = !{i64 -179722006026988426}
!9 = !{i64 582806719783231732}
!10 = !{i64 5831618968589220188}
!11 = !{i64 -6401069912850818960}
!12 = !{i64 4634215729799061647}
!13 = !{i64 6628543358185884303}
!14 = !{i64 9159108642533824166}
!15 = !{i64 -2155058638088882439}
!16 = !{i64 6928767421859276133}
!17 = !{i64 5925542265798811715}
!18 = !{i64 -4680761897170101610}
!19 = !{i64 -8478752654069839738}
!20 = !{i64 3216178124372076435}
!21 = !{i64 -538937289525885596}
!22 = !{i64 4575597260304633441}
!23 = !{i64 -7923099821505319923}
!24 = !{i64 -528733081429980904}
!25 = !{i64 -6188443799819338388}
!26 = !{i32 8, !"PIC Level", i32 2}
!27 = !{i32 7, !"uwtable", i32 2}
!28 = !{i32 7, !"frame-pointer", i32 1}
!29 = !{i32 7, !"Dwarf Version", i32 4}
!30 = !{i32 2, !"Debug Info Version", i32 3}
!31 = !{!"rustc version 1.99.0 (b940084d7 2026-09-28)"}
!32 = distinct !DICompileUnit(language: DW_LANG_Rust, file: !33, producer: "clang LLVM (rustc version 1.99.0 (b940084d7 2026-09-28))", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, splitDebugInlining: false, nameTableKind: None)
!33 = !DIFile(filename: "src/lib.rs/@/runtime_lab.cc52c9ff3ada741f-cgu.0", directory: "/Users/juanwang/Desktop/tutorials/cpp-rust/bench/runtime-lab")
!34 = distinct !DISubprogram(name: "initialize<core::option::Option<unsafe extern \22C\22 fn(*mut i32, i32) -> i32>, std::sync::once_lock::{impl#0}::get_or_init::{closure_env#0}<core::option::Option<unsafe extern \22C\22 fn(*mut i32, i32) -> i32>, runtime_lab::process::macos::pipe_cloexec::{closure_env#0}>, !>", linkageName: "_RINvMNtNtCs1SSuMAdGM58_3std4sync9once_lockINtB3_8OnceLockINtNtCsjIpoRzUjyHQ_4core6option6OptionFUKCOllElEE10initializeNCINvB2_11get_or_initNCNvNtNtCshxBJAVx362N_11runtime_lab7process5macos12pipe_cloexec0E0zEB2l_", scope: !36, file: !35, line: 562, type: !40, scopeLine: 562, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!35 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/std/src/sync/once_lock.rs", directory: "", checksumkind: CSK_MD5, checksum: "947ef8fbee3ea4dc0fcab53d479aa453")
!36 = !DINamespace(name: "OnceLock", scope: !37)
!37 = !DINamespace(name: "once_lock", scope: !38)
!38 = !DINamespace(name: "sync", scope: !39)
!39 = !DINamespace(name: "std", scope: null)
!40 = !DISubroutineType(cc: DW_CC_nocall, types: !41)
!41 = !{}
!42 = !{i64 867232755910545139}
!43 = !DILocation(line: 3995, column: 24, scope: !44, inlinedAt: !49)
!44 = distinct !DISubprogram(name: "atomic_load<*mut ()>", linkageName: "_RINvNtNtCsjIpoRzUjyHQ_4core4sync6atomic11atomic_loadOuECshxBJAVx362N_11runtime_lab", scope: !46, file: !45, line: 3990, type: !40, scopeLine: 3990, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!45 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/sync/atomic.rs", directory: "", checksumkind: CSK_MD5, checksum: "51c6a96ef01c6a3d76d0125641245f4c")
!46 = !DINamespace(name: "atomic", scope: !47)
!47 = !DINamespace(name: "sync", scope: !48)
!48 = !DINamespace(name: "core", scope: null)
!49 = distinct !DILocation(line: 1765, column: 18, scope: !50, inlinedAt: !53)
!50 = distinct !DISubprogram(name: "load<()>", linkageName: "_RNvMs3_NtNtCsjIpoRzUjyHQ_4core4sync6atomicINtB5_6AtomicOuE4loadCshxBJAVx362N_11runtime_lab", scope: !51, file: !45, line: 1763, type: !52, scopeLine: 1763, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!51 = !DINamespace(name: "Atomic", scope: !46)
!52 = !DISubroutineType(types: !41)
!53 = distinct !DILocation(line: 135, column: 30, scope: !54, inlinedAt: !61)
!54 = distinct !DISubprogram(name: "is_completed", linkageName: "_RNvMNtNtNtNtCs1SSuMAdGM58_3std3sys4sync4once5queueNtB2_4Once12is_completed", scope: !56, file: !55, line: 130, type: !52, scopeLine: 130, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!55 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/std/src/sys/sync/once/queue.rs", directory: "", checksumkind: CSK_MD5, checksum: "8cb740b86fd30f0d58617572e5ced205")
!56 = !DINamespace(name: "Once", scope: !57)
!57 = !DINamespace(name: "queue", scope: !58)
!58 = !DINamespace(name: "once", scope: !59)
!59 = !DINamespace(name: "sync", scope: !60)
!60 = !DINamespace(name: "sys", scope: !39)
!61 = distinct !DILocation(line: 221, column: 23, scope: !62, inlinedAt: !66)
!62 = distinct !DISubprogram(name: "call_once_force<std::sync::once_lock::{impl#0}::initialize::{closure_env#0}<core::option::Option<unsafe extern \22C\22 fn(*mut i32, i32) -> i32>, std::sync::once_lock::{impl#0}::get_or_init::{closure_env#0}<core::option::Option<unsafe extern \22C\22 fn(*mut i32, i32) -> i32>, runtime_lab::process::macos::pipe_cloexec::{closure_env#0}>, !>>", linkageName: "_RINvMs0_NtNtCs1SSuMAdGM58_3std4sync4onceNtB6_4Once15call_once_forceNCINvMNtB8_9once_lockINtB19_8OnceLockINtNtCsjIpoRzUjyHQ_4core6option6OptionFUKCOllElEE10initializeNCINvB18_11get_or_initNCNvNtNtCshxBJAVx362N_11runtime_lab7process5macos12pipe_cloexec0E0zE0EB37_", scope: !64, file: !63, line: 216, type: !40, scopeLine: 216, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!63 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/std/src/sync/once.rs", directory: "", checksumkind: CSK_MD5, checksum: "e704aed927c6d1f681aa4aa4aa72f910")
!64 = !DINamespace(name: "Once", scope: !65)
!65 = !DINamespace(name: "once", scope: !38)
!66 = distinct !DILocation(line: 571, column: 19, scope: !67)
!67 = distinct !DILexicalBlock(scope: !68, file: !35, line: 567, column: 9)
!68 = distinct !DILexicalBlock(scope: !34, file: !35, line: 566, column: 9)
!69 = !{!70}
!70 = distinct !{!70, !71, !"_RINvMs0_NtNtCs1SSuMAdGM58_3std4sync4onceNtB6_4Once15call_once_forceNCINvMNtB8_9once_lockINtB19_8OnceLockINtNtCsjIpoRzUjyHQ_4core6option6OptionFUKCOllElEE10initializeNCINvB18_11get_or_initNCNvNtNtCshxBJAVx362N_11runtime_lab7process5macos12pipe_cloexec0E0zE0EB37_: %f.1"}
!71 = distinct !{!71, !"_RINvMs0_NtNtCs1SSuMAdGM58_3std4sync4onceNtB6_4Once15call_once_forceNCINvMNtB8_9once_lockINtB19_8OnceLockINtNtCsjIpoRzUjyHQ_4core6option6OptionFUKCOllElEE10initializeNCINvB18_11get_or_initNCNvNtNtCshxBJAVx362N_11runtime_lab7process5macos12pipe_cloexec0E0zE0EB37_"}
!72 = !DILocation(line: 135, column: 9, scope: !54, inlinedAt: !61)
!73 = !DILocation(line: 221, column: 12, scope: !62, inlinedAt: !66)
!74 = !{!"branch_weights", !"expected", i32 2000, i32 1}
!75 = !DILocation(line: 225, column: 13, scope: !62, inlinedAt: !66)
!76 = !DILocation(line: 225, column: 21, scope: !62, inlinedAt: !66)
!77 = !DILocation(line: 226, column: 36, scope: !78, inlinedAt: !66)
!78 = distinct !DILexicalBlock(scope: !62, file: !63, line: 225, column: 9)
!79 = !DILocation(line: 226, column: 20, scope: !78, inlinedAt: !66)
!80 = !DILocation(line: 226, column: 61, scope: !78, inlinedAt: !66)
!81 = !DILocation(line: 227, column: 5, scope: !62, inlinedAt: !66)
!82 = !DILocation(line: 586, column: 6, scope: !34)
!83 = distinct !DISubprogram(name: "initialize<std::sys::pal::unix::sync::mutex::Mutex, std::sys::sync::mutex::pthread::{impl#0}::get::{closure_env#0}>", linkageName: "_RINvMNtNtNtCs1SSuMAdGM58_3std3sys4sync8once_boxINtB3_7OnceBoxNtNtNtNtNtB7_3pal4unix4sync5mutex5MutexE10initializeNCNvMNtNtB5_5mutex7pthreadNtB1S_5Mutex3get0ECshxBJAVx362N_11runtime_lab", scope: !85, file: !84, line: 62, type: !52, scopeLine: 62, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!84 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/std/src/sys/sync/once_box.rs", directory: "", checksumkind: CSK_MD5, checksum: "f1000a4c21cf79dde92428b81bc214bf")
!85 = !DINamespace(name: "OnceBox", scope: !86)
!86 = !DINamespace(name: "once_box", scope: !59)
!87 = !{i64 6803213169676030158}
!88 = !DILocation(line: 23, column: 36, scope: !89, inlinedAt: !95)
!89 = distinct !DISubprogram(name: "{closure#0}", linkageName: "_RNCNvMNtNtNtNtCs1SSuMAdGM58_3std3sys4sync5mutex7pthreadNtB4_5Mutex3get0CshxBJAVx362N_11runtime_lab", scope: !91, file: !90, line: 22, type: !52, scopeLine: 22, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!90 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/std/src/sys/sync/mutex/pthread.rs", directory: "", checksumkind: CSK_MD5, checksum: "868c5ca80a36ed03df9b889476107b5b")
!91 = !DINamespace(name: "get", scope: !92)
!92 = !DINamespace(name: "{impl#0}", scope: !93)
!93 = !DINamespace(name: "pthread", scope: !94)
!94 = !DINamespace(name: "mutex", scope: !59)
!95 = distinct !DILocation(line: 63, column: 72, scope: !83)
!96 = !DILocation(line: 13, column: 9, scope: !97, inlinedAt: !104)
!97 = distinct !DISubprogram(name: "new", linkageName: "_RNvMNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutexNtB2_5Mutex3new", scope: !99, file: !98, line: 12, type: !52, scopeLine: 12, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!98 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/std/src/sys/pal/unix/sync/mutex.rs", directory: "", checksumkind: CSK_MD5, checksum: "b83d52c9b44a6ebaddfc550875bb2635")
!99 = !DINamespace(name: "Mutex", scope: !100)
!100 = !DINamespace(name: "mutex", scope: !101)
!101 = !DINamespace(name: "sync", scope: !102)
!102 = !DINamespace(name: "unix", scope: !103)
!103 = !DINamespace(name: "pal", scope: !60)
!104 = distinct !DILocation(line: 23, column: 36, scope: !89, inlinedAt: !95)
!105 = !DILocation(line: 128, column: 9, scope: !106, inlinedAt: !110)
!106 = distinct !DISubprogram(name: "alloc", linkageName: "_RNvNtCs6zY7rJBZy9D_5alloc5alloc5alloc", scope: !108, file: !107, line: 124, type: !52, scopeLine: 124, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!107 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/alloc/src/alloc.rs", directory: "", checksumkind: CSK_MD5, checksum: "87b4d0ba26e1dfe94542079de6981d97")
!108 = !DINamespace(name: "alloc", scope: !109)
!109 = !DINamespace(name: "alloc", scope: null)
!110 = distinct !DILocation(line: 302, column: 73, scope: !111, inlinedAt: !114)
!111 = distinct !DILexicalBlock(scope: !112, file: !107, line: 301, column: 13)
!112 = distinct !DISubprogram(name: "alloc_impl_runtime", linkageName: "_RNvMs0_NtCs6zY7rJBZy9D_5alloc5allocNtB5_6Global18alloc_impl_runtime", scope: !113, file: !107, line: 297, type: !52, scopeLine: 297, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!113 = !DINamespace(name: "Global", scope: !108)
!114 = distinct !DILocation(line: 424, column: 9, scope: !115, inlinedAt: !116)
!115 = distinct !DISubprogram(name: "alloc_impl", linkageName: "_RNvMs0_NtCs6zY7rJBZy9D_5alloc5allocNtB5_6Global10alloc_impl", scope: !113, file: !107, line: 423, type: !52, scopeLine: 423, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!116 = distinct !DILocation(line: 541, column: 14, scope: !117, inlinedAt: !119)
!117 = distinct !DISubprogram(name: "allocate", linkageName: "_RNvXs1_NtCs6zY7rJBZy9D_5alloc5allocNtB5_6GlobalNtNtCsjIpoRzUjyHQ_4core5alloc9Allocator8allocate", scope: !118, file: !107, line: 540, type: !52, scopeLine: 540, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!118 = !DINamespace(name: "{impl#3}", scope: !108)
!119 = distinct !DILocation(line: 251, column: 18, scope: !120, inlinedAt: !123)
!120 = distinct !DISubprogram(name: "box_new_uninit", linkageName: "_RNvNtCs6zY7rJBZy9D_5alloc5boxed14box_new_uninit", scope: !122, file: !121, line: 250, type: !52, scopeLine: 250, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!121 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/alloc/src/boxed.rs", directory: "", checksumkind: CSK_MD5, checksum: "d08167ce38615623852d82b0b0764c28")
!122 = !DINamespace(name: "boxed", scope: !109)
!123 = distinct !DILocation(line: 290, column: 19, scope: !124, inlinedAt: !126)
!124 = distinct !DISubprogram(name: "new<std::sys::pal::unix::sync::mutex::Mutex>", linkageName: "_RNvMNtCs6zY7rJBZy9D_5alloc5boxedINtB2_3BoxNtNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutex5MutexE3newCshxBJAVx362N_11runtime_lab", scope: !125, file: !121, line: 288, type: !52, scopeLine: 288, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!125 = !DINamespace(name: "{impl#0}", scope: !122)
!126 = distinct !DILocation(line: 361, column: 9, scope: !127, inlinedAt: !128)
!127 = distinct !DISubprogram(name: "pin<std::sys::pal::unix::sync::mutex::Mutex>", linkageName: "_RNvMNtCs6zY7rJBZy9D_5alloc5boxedINtB2_3BoxNtNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutex5MutexE3pinCshxBJAVx362N_11runtime_lab", scope: !125, file: !121, line: 360, type: !52, scopeLine: 360, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!128 = distinct !DILocation(line: 23, column: 27, scope: !89, inlinedAt: !95)
!129 = !{!130}
!130 = distinct !{!130, !131, !"_RNvMNtCs6zY7rJBZy9D_5alloc5boxedINtB2_3BoxNtNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutex5MutexE3newCshxBJAVx362N_11runtime_lab: %x"}
!131 = distinct !{!131, !"_RNvMNtCs6zY7rJBZy9D_5alloc5boxedINtB2_3BoxNtNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutex5MutexE3newCshxBJAVx362N_11runtime_lab"}
!132 = !DILocation(line: 130, column: 9, scope: !106, inlinedAt: !110)
!133 = !DILocation(line: 251, column: 11, scope: !120, inlinedAt: !123)
!134 = !DILocation(line: 251, column: 5, scope: !120, inlinedAt: !123)
!135 = !{!"branch_weights", !"expected", i32 1, i32 2000}
!136 = !DILocation(line: 253, column: 19, scope: !120, inlinedAt: !123)
!137 = !DILocation(line: 847, column: 1, scope: !138, inlinedAt: !141)
!138 = distinct !DISubprogram(name: "drop_glue<std::sys::pal::unix::sync::mutex::Mutex>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutex5MutexECshxBJAVx362N_11runtime_lab", scope: !140, file: !139, line: 847, type: !52, scopeLine: 847, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!139 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/ptr/mod.rs", directory: "", checksumkind: CSK_MD5, checksum: "59033ebc630da002040513c25c9de121")
!140 = !DINamespace(name: "ptr", scope: !48)
!141 = distinct !DILocation(line: 296, column: 5, scope: !124, inlinedAt: !126)
!142 = !DILocation(line: 288, column: 5, scope: !124, inlinedAt: !126)
!143 = !DILocation(line: 0, scope: !83)
!144 = !DILocation(line: 293, column: 56, scope: !145, inlinedAt: !126)
!145 = distinct !DILexicalBlock(scope: !124, file: !121, line: 290, column: 9)
!146 = !DILocation(line: 23, column: 53, scope: !89, inlinedAt: !95)
!147 = !DILocation(line: 25, column: 35, scope: !148, inlinedAt: !95)
!148 = distinct !DILexicalBlock(scope: !89, file: !90, line: 23, column: 13)
!149 = !DILocation(line: 27, column: 9, scope: !89, inlinedAt: !95)
!150 = !DILocation(line: 22, column: 30, scope: !89, inlinedAt: !95)
!151 = !DILocation(line: 4095, column: 17, scope: !152, inlinedAt: !153)
!152 = distinct !DISubprogram(name: "atomic_compare_exchange<*mut std::sys::pal::unix::sync::mutex::Mutex>", linkageName: "_RINvNtNtCsjIpoRzUjyHQ_4core4sync6atomic23atomic_compare_exchangeONtNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutex5MutexECshxBJAVx362N_11runtime_lab", scope: !46, file: !45, line: 4063, type: !40, scopeLine: 4063, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!153 = distinct !DILocation(line: 1955, column: 18, scope: !154, inlinedAt: !155)
!154 = distinct !DISubprogram(name: "compare_exchange<std::sys::pal::unix::sync::mutex::Mutex>", linkageName: "_RNvMs3_NtNtCsjIpoRzUjyHQ_4core4sync6atomicINtB5_6AtomicONtNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutex5MutexE16compare_exchangeCshxBJAVx362N_11runtime_lab", scope: !51, file: !45, line: 1947, type: !52, scopeLine: 1947, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!155 = !DILocation(line: 64, column: 24, scope: !156)
!156 = distinct !DILexicalBlock(scope: !83, file: !84, line: 63, column: 9)
!157 = !DILocation(line: 64, column: 9, scope: !156)
!158 = !DILocation(line: 847, column: 1, scope: !138, inlinedAt: !159)
!159 = distinct !DILocation(line: 847, column: 1, scope: !160, inlinedAt: !161)
!160 = distinct !DISubprogram(name: "drop_glue<alloc::boxed::Box<std::sys::pal::unix::sync::mutex::Mutex, alloc::alloc::Global>>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc5boxed3BoxNtNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutex5MutexEECshxBJAVx362N_11runtime_lab", scope: !140, file: !139, line: 847, type: !40, scopeLine: 847, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!161 = distinct !DILocation(line: 1049, column: 1, scope: !162, inlinedAt: !165)
!162 = distinct !DISubprogram(name: "drop<alloc::boxed::Box<std::sys::pal::unix::sync::mutex::Mutex, alloc::alloc::Global>>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3mem4dropINtNtCs6zY7rJBZy9D_5alloc5boxed3BoxNtNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutex5MutexEECshxBJAVx362N_11runtime_lab", scope: !164, file: !163, line: 1045, type: !52, scopeLine: 1045, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!163 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/mem/mod.rs", directory: "", checksumkind: CSK_MD5, checksum: "1dbabb11724cf003c9a4ded983e1d0cd")
!164 = !DINamespace(name: "mem", scope: !48)
!165 = !DILocation(line: 69, column: 17, scope: !166)
!166 = distinct !DILexicalBlock(scope: !156, file: !84, line: 66, column: 13)
!167 = !DILocation(line: 175, column: 14, scope: !168, inlinedAt: !169)
!168 = distinct !DISubprogram(name: "dealloc_nonnull", linkageName: "_RNvNtCs6zY7rJBZy9D_5alloc5alloc15dealloc_nonnull", scope: !108, file: !107, line: 174, type: !52, scopeLine: 174, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!169 = distinct !DILocation(line: 321, column: 22, scope: !170, inlinedAt: !171)
!170 = distinct !DISubprogram(name: "deallocate_impl_runtime", linkageName: "_RNvMs0_NtCs6zY7rJBZy9D_5alloc5allocNtB5_6Global23deallocate_impl_runtime", scope: !113, file: !107, line: 311, type: !52, scopeLine: 311, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!171 = distinct !DILocation(line: 436, column: 9, scope: !172, inlinedAt: !173)
!172 = distinct !DISubprogram(name: "deallocate_impl", linkageName: "_RNvMs0_NtCs6zY7rJBZy9D_5alloc5allocNtB5_6Global15deallocate_impl", scope: !113, file: !107, line: 435, type: !52, scopeLine: 435, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!173 = distinct !DILocation(line: 554, column: 23, scope: !174, inlinedAt: !175)
!174 = distinct !DISubprogram(name: "deallocate", linkageName: "_RNvXs1_NtCs6zY7rJBZy9D_5alloc5allocNtB5_6GlobalNtNtCsjIpoRzUjyHQ_4core5alloc9Allocator10deallocate", scope: !118, file: !107, line: 552, type: !40, scopeLine: 552, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!175 = distinct !DILocation(line: 2000, column: 24, scope: !176, inlinedAt: !180)
!176 = distinct !DILexicalBlock(scope: !177, file: !121, line: 1998, column: 13)
!177 = distinct !DILexicalBlock(scope: !178, file: !121, line: 1995, column: 9)
!178 = distinct !DISubprogram(name: "drop<std::sys::pal::unix::sync::mutex::Mutex, alloc::alloc::Global>", linkageName: "_RNvXs8_NtCs6zY7rJBZy9D_5alloc5boxedINtB5_3BoxNtNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutex5MutexENtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4dropCshxBJAVx362N_11runtime_lab", scope: !179, file: !121, line: 1992, type: !40, scopeLine: 1992, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!179 = !DINamespace(name: "{impl#10}", scope: !122)
!180 = distinct !DILocation(line: 847, column: 1, scope: !160, inlinedAt: !161)
!181 = !DILocation(line: 847, column: 1, scope: !160, inlinedAt: !161)
!182 = !DILocation(line: 175, column: 14, scope: !168, inlinedAt: !183)
!183 = distinct !DILocation(line: 321, column: 22, scope: !170, inlinedAt: !184)
!184 = distinct !DILocation(line: 436, column: 9, scope: !172, inlinedAt: !185)
!185 = distinct !DILocation(line: 554, column: 23, scope: !174, inlinedAt: !186)
!186 = distinct !DILocation(line: 2000, column: 24, scope: !176, inlinedAt: !187)
!187 = distinct !DILocation(line: 847, column: 1, scope: !160, inlinedAt: !161)
!188 = !DILocation(line: 71, column: 13, scope: !156)
!189 = !DILocation(line: 1352, column: 9, scope: !190, inlinedAt: !194)
!190 = distinct !DISubprogram(name: "new_unchecked<&std::sys::pal::unix::sync::mutex::Mutex>", linkageName: "_RNvMs4_NtCsjIpoRzUjyHQ_4core3pinINtB5_3PinRNtNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutex5MutexE13new_uncheckedCshxBJAVx362N_11runtime_lab", scope: !192, file: !191, line: 1351, type: !52, scopeLine: 1351, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!191 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/pin.rs", directory: "", checksumkind: CSK_MD5, checksum: "89fa63aed274c2b31ade6f589f98d9de")
!192 = !DINamespace(name: "Pin", scope: !193)
!193 = !DINamespace(name: "pin", scope: !48)
!194 = !DILocation(line: 0, scope: !156)
!195 = !DILocation(line: 73, column: 6, scope: !83)
!196 = distinct !DISubprogram(name: "drop_glue<core::pin::Pin<alloc::boxed::Box<std::sys::pal::unix::sync::mutex::Mutex, alloc::alloc::Global>>>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtB4_3pin3PinINtNtCs6zY7rJBZy9D_5alloc5boxed3BoxNtNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutex5MutexEEECshxBJAVx362N_11runtime_lab", scope: !140, file: !139, line: 847, type: !40, scopeLine: 847, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!197 = !{i64 3582889337554472505}
!198 = !DILocation(line: 847, column: 1, scope: !138, inlinedAt: !199)
!199 = distinct !DILocation(line: 847, column: 1, scope: !160, inlinedAt: !200)
!200 = distinct !DILocation(line: 847, column: 1, scope: !196)
!201 = !DILocation(line: 175, column: 14, scope: !168, inlinedAt: !202)
!202 = distinct !DILocation(line: 321, column: 22, scope: !170, inlinedAt: !203)
!203 = distinct !DILocation(line: 436, column: 9, scope: !172, inlinedAt: !204)
!204 = distinct !DILocation(line: 554, column: 23, scope: !174, inlinedAt: !205)
!205 = distinct !DILocation(line: 2000, column: 24, scope: !176, inlinedAt: !206)
!206 = distinct !DILocation(line: 847, column: 1, scope: !160, inlinedAt: !200)
!207 = !DILocation(line: 847, column: 1, scope: !160, inlinedAt: !200)
!208 = !DILocation(line: 175, column: 14, scope: !168, inlinedAt: !209)
!209 = distinct !DILocation(line: 321, column: 22, scope: !170, inlinedAt: !210)
!210 = distinct !DILocation(line: 436, column: 9, scope: !172, inlinedAt: !211)
!211 = distinct !DILocation(line: 554, column: 23, scope: !174, inlinedAt: !212)
!212 = distinct !DILocation(line: 2000, column: 24, scope: !176, inlinedAt: !213)
!213 = distinct !DILocation(line: 847, column: 1, scope: !160, inlinedAt: !200)
!214 = !DILocation(line: 847, column: 1, scope: !196)
!215 = distinct !DISubprogram(name: "drop_glue<core::cell::UnsafeCell<runtime_lab::process::Capture>>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtB4_4cell10UnsafeCellNtNtCshxBJAVx362N_11runtime_lab7process7CaptureEEB14_", scope: !140, file: !139, line: 847, type: !52, scopeLine: 847, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!216 = !{i64 -3795599549503557971}
!217 = !{!218}
!218 = distinct !{!218, !219, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtCshxBJAVx362N_11runtime_lab7process7CaptureEBF_: %_1"}
!219 = distinct !{!219, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtCshxBJAVx362N_11runtime_lab7process7CaptureEBF_"}
!220 = !DILocation(line: 847, column: 1, scope: !215)
!221 = !DILocation(line: 847, column: 1, scope: !222, inlinedAt: !223)
!222 = distinct !DISubprogram(name: "drop_glue<runtime_lab::process::Capture>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtCshxBJAVx362N_11runtime_lab7process7CaptureEBF_", scope: !140, file: !139, line: 847, type: !52, scopeLine: 847, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!223 = distinct !DILocation(line: 847, column: 1, scope: !215)
!224 = !DILocation(line: 631, column: 39, scope: !225, inlinedAt: !229)
!225 = distinct !DISubprogram(name: "current_memory<alloc::alloc::Global>", linkageName: "_RNvMs2_NtCs6zY7rJBZy9D_5alloc7raw_vecNtB5_11RawVecInner14current_memoryCshxBJAVx362N_11runtime_lab", scope: !227, file: !226, line: 630, type: !40, scopeLine: 630, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!226 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/alloc/src/raw_vec/mod.rs", directory: "", checksumkind: CSK_MD5, checksum: "acd4dae5e7aaaaf06aa0208ebac37ff5")
!227 = !DINamespace(name: "RawVecInner", scope: !228)
!228 = !DINamespace(name: "raw_vec", scope: !109)
!229 = distinct !DILocation(line: 874, column: 52, scope: !230, inlinedAt: !232)
!230 = distinct !DILexicalBlock(scope: !231, file: !226, line: 874, column: 82)
!231 = distinct !DISubprogram(name: "deallocate<alloc::alloc::Global>", linkageName: "_RNvMs3_NtCs6zY7rJBZy9D_5alloc7raw_vecNtB5_11RawVecInner10deallocateCshxBJAVx362N_11runtime_lab", scope: !227, file: !226, line: 872, type: !40, scopeLine: 872, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!232 = distinct !DILocation(line: 425, column: 29, scope: !233, inlinedAt: !235)
!233 = distinct !DISubprogram(name: "drop<u8, alloc::alloc::Global>", linkageName: "_RNvXs1_NtCs6zY7rJBZy9D_5alloc7raw_vecINtB5_6RawVechENtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4dropCshxBJAVx362N_11runtime_lab", scope: !234, file: !226, line: 423, type: !40, scopeLine: 423, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!234 = !DINamespace(name: "{impl#3}", scope: !228)
!235 = distinct !DILocation(line: 847, column: 1, scope: !236, inlinedAt: !237)
!236 = distinct !DISubprogram(name: "drop_glue<alloc::raw_vec::RawVec<u8, alloc::alloc::Global>>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc7raw_vec6RawVechEECshxBJAVx362N_11runtime_lab", scope: !140, file: !139, line: 847, type: !40, scopeLine: 847, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!237 = distinct !DILocation(line: 847, column: 1, scope: !238, inlinedAt: !239)
!238 = distinct !DISubprogram(name: "drop_glue<alloc::vec::Vec<u8, alloc::alloc::Global>>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc3vec3VechEECshxBJAVx362N_11runtime_lab", scope: !140, file: !139, line: 847, type: !40, scopeLine: 847, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!239 = distinct !DILocation(line: 847, column: 1, scope: !222, inlinedAt: !223)
!240 = !DILocation(line: 175, column: 14, scope: !168, inlinedAt: !241)
!241 = distinct !DILocation(line: 321, column: 22, scope: !170, inlinedAt: !242)
!242 = distinct !DILocation(line: 436, column: 9, scope: !172, inlinedAt: !243)
!243 = distinct !DILocation(line: 554, column: 23, scope: !174, inlinedAt: !244)
!244 = distinct !DILocation(line: 876, column: 28, scope: !230, inlinedAt: !232)
!245 = !DILocation(line: 874, column: 9, scope: !231, inlinedAt: !232)
!246 = !{i64 -1, i64 -9223372036854775808}
!247 = !DILocation(line: 847, column: 1, scope: !248, inlinedAt: !249)
!248 = distinct !DISubprogram(name: "drop_glue<core::option::Option<alloc::string::String>>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtB4_6option6OptionNtNtCs6zY7rJBZy9D_5alloc6string6StringEECshxBJAVx362N_11runtime_lab", scope: !140, file: !139, line: 847, type: !40, scopeLine: 847, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!249 = distinct !DILocation(line: 847, column: 1, scope: !250, inlinedAt: !251)
!250 = distinct !DISubprogram(name: "drop_glue<runtime_lab::process::ReaderDiagnostics>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtCshxBJAVx362N_11runtime_lab7process17ReaderDiagnosticsEBF_", scope: !140, file: !139, line: 847, type: !40, scopeLine: 847, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!251 = distinct !DILocation(line: 847, column: 1, scope: !222, inlinedAt: !223)
!252 = !DILocation(line: 175, column: 14, scope: !168, inlinedAt: !253)
!253 = distinct !DILocation(line: 321, column: 22, scope: !170, inlinedAt: !254)
!254 = distinct !DILocation(line: 436, column: 9, scope: !172, inlinedAt: !255)
!255 = distinct !DILocation(line: 554, column: 23, scope: !174, inlinedAt: !256)
!256 = distinct !DILocation(line: 876, column: 28, scope: !230, inlinedAt: !257)
!257 = distinct !DILocation(line: 425, column: 29, scope: !233, inlinedAt: !258)
!258 = distinct !DILocation(line: 847, column: 1, scope: !236, inlinedAt: !259)
!259 = distinct !DILocation(line: 847, column: 1, scope: !238, inlinedAt: !260)
!260 = distinct !DILocation(line: 847, column: 1, scope: !261, inlinedAt: !262)
!261 = distinct !DISubprogram(name: "drop_glue<alloc::string::String>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtCs6zY7rJBZy9D_5alloc6string6StringECshxBJAVx362N_11runtime_lab", scope: !140, file: !139, line: 847, type: !40, scopeLine: 847, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!262 = distinct !DILocation(line: 847, column: 1, scope: !248, inlinedAt: !249)
!263 = !DILocation(line: 874, column: 9, scope: !231, inlinedAt: !257)
!264 = distinct !DISubprogram(name: "drop_glue<core::option::Option<std::process::Child>>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtB4_6option6OptionNtNtCs1SSuMAdGM58_3std7process5ChildEECshxBJAVx362N_11runtime_lab", scope: !140, file: !139, line: 847, type: !52, scopeLine: 847, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!265 = !{i64 9094449008740321207}
!266 = !DILocation(line: 847, column: 1, scope: !264)
!267 = !{i32 0, i32 3}
!268 = !{!269}
!269 = distinct !{!269, !270, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtCs1SSuMAdGM58_3std7process5ChildECshxBJAVx362N_11runtime_lab: %_1"}
!270 = distinct !{!270, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtCs1SSuMAdGM58_3std7process5ChildECshxBJAVx362N_11runtime_lab"}
!271 = !DILocation(line: 847, column: 1, scope: !272, inlinedAt: !273)
!272 = distinct !DISubprogram(name: "drop_glue<std::process::Child>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtCs1SSuMAdGM58_3std7process5ChildECshxBJAVx362N_11runtime_lab", scope: !140, file: !139, line: 847, type: !52, scopeLine: 847, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!273 = distinct !DILocation(line: 847, column: 1, scope: !264)
!274 = !DILocation(line: 847, column: 1, scope: !275, inlinedAt: !276)
!275 = distinct !DISubprogram(name: "drop_glue<core::option::Option<std::process::ChildStdin>>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtB4_6option6OptionNtNtCs1SSuMAdGM58_3std7process10ChildStdinEECshxBJAVx362N_11runtime_lab", scope: !140, file: !139, line: 847, type: !40, scopeLine: 847, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!276 = distinct !DILocation(line: 847, column: 1, scope: !272, inlinedAt: !273)
!277 = !DILocation(line: 220, column: 25, scope: !278, inlinedAt: !284)
!278 = distinct !DISubprogram(name: "drop", linkageName: "_RNvXs5_NtNtNtCs1SSuMAdGM58_3std2os2fd5ownedNtB5_7OwnedFdNtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4drop", scope: !280, file: !279, line: 202, type: !40, scopeLine: 202, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!279 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/std/src/os/fd/owned.rs", directory: "", checksumkind: CSK_MD5, checksum: "f74e7a955ee03d3147b979f66430a3de")
!280 = !DINamespace(name: "{impl#7}", scope: !281)
!281 = !DINamespace(name: "owned", scope: !282)
!282 = !DINamespace(name: "fd", scope: !283)
!283 = !DINamespace(name: "os", scope: !39)
!284 = distinct !DILocation(line: 847, column: 1, scope: !285, inlinedAt: !286)
!285 = distinct !DISubprogram(name: "drop_glue<std::os::fd::owned::OwnedFd>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtNtNtCs1SSuMAdGM58_3std2os2fd5owned7OwnedFdECshxBJAVx362N_11runtime_lab", scope: !140, file: !139, line: 847, type: !40, scopeLine: 847, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!286 = distinct !DILocation(line: 847, column: 1, scope: !287, inlinedAt: !288)
!287 = distinct !DISubprogram(name: "drop_glue<std::sys::fd::unix::FileDesc>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtNtNtCs1SSuMAdGM58_3std3sys2fd4unix8FileDescECshxBJAVx362N_11runtime_lab", scope: !140, file: !139, line: 847, type: !40, scopeLine: 847, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!288 = distinct !DILocation(line: 847, column: 1, scope: !289, inlinedAt: !290)
!289 = distinct !DISubprogram(name: "drop_glue<std::process::ChildStdin>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtCs1SSuMAdGM58_3std7process10ChildStdinECshxBJAVx362N_11runtime_lab", scope: !140, file: !139, line: 847, type: !40, scopeLine: 847, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!290 = distinct !DILocation(line: 847, column: 1, scope: !275, inlinedAt: !276)
!291 = !DILocation(line: 847, column: 1, scope: !292, inlinedAt: !293)
!292 = distinct !DISubprogram(name: "drop_glue<core::option::Option<std::process::ChildStdout>>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtB4_6option6OptionNtNtCs1SSuMAdGM58_3std7process11ChildStdoutEECshxBJAVx362N_11runtime_lab", scope: !140, file: !139, line: 847, type: !40, scopeLine: 847, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!293 = distinct !DILocation(line: 847, column: 1, scope: !272, inlinedAt: !273)
!294 = !DILocation(line: 220, column: 25, scope: !278, inlinedAt: !295)
!295 = distinct !DILocation(line: 847, column: 1, scope: !285, inlinedAt: !296)
!296 = distinct !DILocation(line: 847, column: 1, scope: !287, inlinedAt: !297)
!297 = distinct !DILocation(line: 847, column: 1, scope: !298, inlinedAt: !299)
!298 = distinct !DISubprogram(name: "drop_glue<std::process::ChildStdout>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtCs1SSuMAdGM58_3std7process11ChildStdoutECshxBJAVx362N_11runtime_lab", scope: !140, file: !139, line: 847, type: !40, scopeLine: 847, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!299 = distinct !DILocation(line: 847, column: 1, scope: !292, inlinedAt: !293)
!300 = !DILocation(line: 847, column: 1, scope: !301, inlinedAt: !302)
!301 = distinct !DISubprogram(name: "drop_glue<core::option::Option<std::process::ChildStderr>>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtB4_6option6OptionNtNtCs1SSuMAdGM58_3std7process11ChildStderrEECshxBJAVx362N_11runtime_lab", scope: !140, file: !139, line: 847, type: !40, scopeLine: 847, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!302 = distinct !DILocation(line: 847, column: 1, scope: !272, inlinedAt: !273)
!303 = !DILocation(line: 220, column: 25, scope: !278, inlinedAt: !304)
!304 = distinct !DILocation(line: 847, column: 1, scope: !285, inlinedAt: !305)
!305 = distinct !DILocation(line: 847, column: 1, scope: !287, inlinedAt: !306)
!306 = distinct !DILocation(line: 847, column: 1, scope: !307, inlinedAt: !308)
!307 = distinct !DISubprogram(name: "drop_glue<std::process::ChildStderr>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtCs1SSuMAdGM58_3std7process11ChildStderrECshxBJAVx362N_11runtime_lab", scope: !140, file: !139, line: 847, type: !40, scopeLine: 847, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!308 = distinct !DILocation(line: 847, column: 1, scope: !301, inlinedAt: !302)
!309 = distinct !DISubprogram(name: "drop_glue<core::option::Option<tokio::process::ChildStdin>>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtB4_6option6OptionNtNtCs3EIJ1qnJmKW_5tokio7process10ChildStdinEECshxBJAVx362N_11runtime_lab", scope: !140, file: !139, line: 847, type: !52, scopeLine: 847, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!310 = !{i64 -1728937586569015151}
!311 = !DILocation(line: 847, column: 1, scope: !309)
!312 = !{i64 0, i64 3}
!313 = !{!314}
!314 = distinct !{!314, !315, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtCs3EIJ1qnJmKW_5tokio7process10ChildStdinECshxBJAVx362N_11runtime_lab: %_1"}
!315 = distinct !{!315, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtCs3EIJ1qnJmKW_5tokio7process10ChildStdinECshxBJAVx362N_11runtime_lab"}
!316 = !{!317}
!317 = distinct !{!317, !318, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtNtCs3EIJ1qnJmKW_5tokio7process3imp10ChildStdinECshxBJAVx362N_11runtime_lab: %_1"}
!318 = distinct !{!318, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtNtCs3EIJ1qnJmKW_5tokio7process3imp10ChildStdinECshxBJAVx362N_11runtime_lab"}
!319 = !DILocation(line: 847, column: 1, scope: !320, inlinedAt: !321)
!320 = distinct !DISubprogram(name: "drop_glue<tokio::process::ChildStdin>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtCs3EIJ1qnJmKW_5tokio7process10ChildStdinECshxBJAVx362N_11runtime_lab", scope: !140, file: !139, line: 847, type: !52, scopeLine: 847, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!321 = distinct !DILocation(line: 847, column: 1, scope: !309)
!322 = !{!323}
!323 = distinct !{!323, !324, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtCs3EIJ1qnJmKW_5tokio2io12poll_evented11PollEventedNtNtNtNtCsiDZg47dpzEY_3mio3sys4unix4pipe6SenderEECshxBJAVx362N_11runtime_lab: %_1"}
!324 = distinct !{!324, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtCs3EIJ1qnJmKW_5tokio2io12poll_evented11PollEventedNtNtNtNtCsiDZg47dpzEY_3mio3sys4unix4pipe6SenderEECshxBJAVx362N_11runtime_lab"}
!325 = !DILocation(line: 847, column: 1, scope: !326, inlinedAt: !327)
!326 = distinct !DISubprogram(name: "drop_glue<tokio::process::imp::ChildStdin>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtNtCs3EIJ1qnJmKW_5tokio7process3imp10ChildStdinECshxBJAVx362N_11runtime_lab", scope: !140, file: !139, line: 847, type: !52, scopeLine: 847, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!327 = distinct !DILocation(line: 847, column: 1, scope: !320, inlinedAt: !321)
!328 = !{!329}
!329 = distinct !{!329, !330, !"_RNvXs3_NtNtCs3EIJ1qnJmKW_5tokio2io12poll_eventedINtB5_11PollEventedNtNtNtNtCsiDZg47dpzEY_3mio3sys4unix4pipe6SenderENtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4dropCshxBJAVx362N_11runtime_lab: %self"}
!330 = distinct !{!330, !"_RNvXs3_NtNtCs3EIJ1qnJmKW_5tokio2io12poll_eventedINtB5_11PollEventedNtNtNtNtCsiDZg47dpzEY_3mio3sys4unix4pipe6SenderENtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4dropCshxBJAVx362N_11runtime_lab"}
!331 = !DILocation(line: 847, column: 1, scope: !332, inlinedAt: !333)
!332 = distinct !DISubprogram(name: "drop_glue<tokio::io::poll_evented::PollEvented<mio::sys::unix::pipe::Sender>>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtCs3EIJ1qnJmKW_5tokio2io12poll_evented11PollEventedNtNtNtNtCsiDZg47dpzEY_3mio3sys4unix4pipe6SenderEECshxBJAVx362N_11runtime_lab", scope: !140, file: !139, line: 847, type: !52, scopeLine: 847, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!333 = distinct !DILocation(line: 847, column: 1, scope: !326, inlinedAt: !327)
!334 = !DILocation(line: 975, column: 22, scope: !335, inlinedAt: !336)
!335 = distinct !DISubprogram(name: "replace<core::option::Option<mio::sys::unix::pipe::Sender>>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3mem7replaceINtNtB4_6option6OptionNtNtNtNtCsiDZg47dpzEY_3mio3sys4unix4pipe6SenderEECshxBJAVx362N_11runtime_lab", scope: !164, file: !163, line: 961, type: !52, scopeLine: 961, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!336 = distinct !DILocation(line: 1901, column: 9, scope: !337, inlinedAt: !341)
!337 = distinct !DISubprogram(name: "take<mio::sys::unix::pipe::Sender>", linkageName: "_RNvMNtCsjIpoRzUjyHQ_4core6optionINtB2_6OptionNtNtNtNtCsiDZg47dpzEY_3mio3sys4unix4pipe6SenderE4takeCshxBJAVx362N_11runtime_lab", scope: !339, file: !338, line: 1899, type: !52, scopeLine: 1899, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!338 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/option.rs", directory: "", checksumkind: CSK_MD5, checksum: "6b6523786d7acedb57d33f9868027e9f")
!339 = !DINamespace(name: "Option", scope: !340)
!340 = !DINamespace(name: "option", scope: !48)
!341 = distinct !DILocation(line: 314, column: 39, scope: !342, inlinedAt: !349)
!342 = distinct !DILexicalBlock(scope: !344, file: !343, line: 314, column: 46)
!343 = !DIFile(filename: "src/io/poll_evented.rs", directory: "/Users/juanwang/.cargo/registry/src/mirrors.bfsu.edu.cn-eb00624c53167367/tokio-1.54.0", checksumkind: CSK_MD5, checksum: "920905182c78c2bdab46b57c152ddfc8")
!344 = distinct !DISubprogram(name: "drop<mio::sys::unix::pipe::Sender>", linkageName: "_RNvXs3_NtNtCs3EIJ1qnJmKW_5tokio2io12poll_eventedINtB5_11PollEventedNtNtNtNtCsiDZg47dpzEY_3mio3sys4unix4pipe6SenderENtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4dropCshxBJAVx362N_11runtime_lab", scope: !345, file: !343, line: 313, type: !52, scopeLine: 313, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!345 = !DINamespace(name: "{impl#5}", scope: !346)
!346 = !DINamespace(name: "poll_evented", scope: !347)
!347 = !DINamespace(name: "io", scope: !348)
!348 = !DINamespace(name: "tokio", scope: null)
!349 = distinct !DILocation(line: 847, column: 1, scope: !332, inlinedAt: !333)
!350 = !{!329, !323, !317, !314}
!351 = !DILocation(line: 976, column: 49, scope: !352, inlinedAt: !336)
!352 = distinct !DILexicalBlock(scope: !335, file: !163, line: 975, column: 9)
!353 = !DILocation(line: 314, column: 31, scope: !342, inlinedAt: !349)
!354 = !DILocation(line: 314, column: 16, scope: !342, inlinedAt: !349)
!355 = !DILocation(line: 314, column: 21, scope: !342, inlinedAt: !349)
!356 = !DILocation(line: 100, column: 14, scope: !357, inlinedAt: !363)
!357 = distinct !DISubprogram(name: "deregister<mio::sys::unix::pipe::Sender>", linkageName: "_RINvMs0_NtNtNtCs3EIJ1qnJmKW_5tokio7runtime2io12registrationNtB6_12Registration10deregisterNtNtNtNtCsiDZg47dpzEY_3mio3sys4unix4pipe6SenderECshxBJAVx362N_11runtime_lab", scope: !359, file: !358, line: 99, type: !52, scopeLine: 99, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!358 = !DIFile(filename: "src/runtime/io/registration.rs", directory: "/Users/juanwang/.cargo/registry/src/mirrors.bfsu.edu.cn-eb00624c53167367/tokio-1.54.0", checksumkind: CSK_MD5, checksum: "d52693db7a787a2775a3e8bd3b82be92")
!359 = !DINamespace(name: "Registration", scope: !360)
!360 = !DINamespace(name: "registration", scope: !361)
!361 = !DINamespace(name: "io", scope: !362)
!362 = !DINamespace(name: "runtime", scope: !348)
!363 = distinct !DILocation(line: 316, column: 39, scope: !342, inlinedAt: !349)
!364 = !DILocation(line: 317, column: 9, scope: !344, inlinedAt: !349)
!365 = !DILocation(line: 100, column: 41, scope: !357, inlinedAt: !363)
!366 = !DILocation(line: 325, column: 9, scope: !367, inlinedAt: !371)
!367 = distinct !DISubprogram(name: "deregister_source<mio::sys::unix::pipe::Sender>", linkageName: "_RINvMs0_NtNtNtCs3EIJ1qnJmKW_5tokio7runtime2io6driverNtB6_6Handle17deregister_sourceNtNtNtNtCsiDZg47dpzEY_3mio3sys4unix4pipe6SenderECshxBJAVx362N_11runtime_lab", scope: !369, file: !368, line: 312, type: !52, scopeLine: 312, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!368 = !DIFile(filename: "src/runtime/io/driver.rs", directory: "/Users/juanwang/.cargo/registry/src/mirrors.bfsu.edu.cn-eb00624c53167367/tokio-1.54.0", checksumkind: CSK_MD5, checksum: "c563b0ff0d4c1ce8037deced666e6c84")
!369 = !DINamespace(name: "Handle", scope: !370)
!370 = !DINamespace(name: "driver", scope: !361)
!371 = distinct !DILocation(line: 100, column: 23, scope: !357, inlinedAt: !363)
!372 = !DILocation(line: 708, column: 16, scope: !373, inlinedAt: !378)
!373 = distinct !DISubprogram(name: "deregister<mio::sys::unix::pipe::Sender>", linkageName: "_RINvMs1_NtCsiDZg47dpzEY_3mio4pollNtB6_8Registry10deregisterNtNtNtNtB8_3sys4unix4pipe6SenderECshxBJAVx362N_11runtime_lab", scope: !375, file: !374, line: 703, type: !52, scopeLine: 703, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!374 = !DIFile(filename: "src/poll.rs", directory: "/Users/juanwang/.cargo/registry/src/mirrors.bfsu.edu.cn-eb00624c53167367/mio-1.2.4", checksumkind: CSK_MD5, checksum: "63f8009a2b204c4b3b223ad29125f5da")
!375 = !DINamespace(name: "Registry", scope: !376)
!376 = !DINamespace(name: "poll", scope: !377)
!377 = !DINamespace(name: "mio", scope: null)
!378 = distinct !DILocation(line: 325, column: 23, scope: !367, inlinedAt: !371)
!379 = !DILocation(line: 2177, column: 15, scope: !380, inlinedAt: !384)
!380 = distinct !DISubprogram(name: "branch<(), core::io::error::Error>", linkageName: "_RNvXsp_NtCsjIpoRzUjyHQ_4core6resultINtB5_6ResultuNtNtNtB7_2io5error5ErrorENtNtNtB7_3ops9try_trait3Try6branchCshxBJAVx362N_11runtime_lab", scope: !382, file: !381, line: 2176, type: !52, scopeLine: 2176, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!381 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/result.rs", directory: "", checksumkind: CSK_MD5, checksum: "d01c390c1644b468299b560eda4cb25a")
!382 = !DINamespace(name: "{impl#27}", scope: !383)
!383 = !DINamespace(name: "result", scope: !48)
!384 = distinct !DILocation(line: 325, column: 9, scope: !367, inlinedAt: !371)
!385 = !DILocation(line: 2177, column: 9, scope: !380, inlinedAt: !384)
!386 = !DILocation(line: 327, column: 12, scope: !367, inlinedAt: !371)
!387 = !DILocation(line: 3995, column: 24, scope: !388, inlinedAt: !389)
!388 = distinct !DISubprogram(name: "atomic_load<*mut std::sys::pal::unix::sync::mutex::Mutex>", linkageName: "_RINvNtNtCsjIpoRzUjyHQ_4core4sync6atomic11atomic_loadONtNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutex5MutexECshxBJAVx362N_11runtime_lab", scope: !46, file: !45, line: 3990, type: !52, scopeLine: 3990, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!389 = distinct !DILocation(line: 1765, column: 18, scope: !390, inlinedAt: !391)
!390 = distinct !DISubprogram(name: "load<std::sys::pal::unix::sync::mutex::Mutex>", linkageName: "_RNvMs3_NtNtCsjIpoRzUjyHQ_4core4sync6atomicINtB5_6AtomicONtNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutex5MutexE4loadCshxBJAVx362N_11runtime_lab", scope: !51, file: !45, line: 1763, type: !52, scopeLine: 1763, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!391 = distinct !DILocation(line: 48, column: 28, scope: !392, inlinedAt: !393)
!392 = distinct !DISubprogram(name: "get_or_init<std::sys::pal::unix::sync::mutex::Mutex, std::sys::sync::mutex::pthread::{impl#0}::get::{closure_env#0}>", linkageName: "_RINvMNtNtNtCs1SSuMAdGM58_3std3sys4sync8once_boxINtB3_7OnceBoxNtNtNtNtNtB7_3pal4unix4sync5mutex5MutexE11get_or_initNCNvMNtNtB5_5mutex7pthreadNtB1T_5Mutex3get0ECshxBJAVx362N_11runtime_lab", scope: !85, file: !84, line: 47, type: !52, scopeLine: 47, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!393 = distinct !DILocation(line: 22, column: 18, scope: !394, inlinedAt: !396)
!394 = distinct !DISubprogram(name: "get", linkageName: "_RNvMNtNtNtNtCs1SSuMAdGM58_3std3sys4sync5mutex7pthreadNtB2_5Mutex3get", scope: !395, file: !90, line: 19, type: !52, scopeLine: 19, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!395 = !DINamespace(name: "Mutex", scope: !93)
!396 = distinct !DILocation(line: 36, column: 23, scope: !397, inlinedAt: !398)
!397 = distinct !DISubprogram(name: "lock", linkageName: "_RNvMNtNtNtNtCs1SSuMAdGM58_3std3sys4sync5mutex7pthreadNtB2_5Mutex4lock", scope: !395, file: !90, line: 33, type: !52, scopeLine: 33, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!398 = distinct !DILocation(line: 492, column: 24, scope: !399, inlinedAt: !404)
!399 = distinct !DISubprogram(name: "lock<tokio::runtime::io::registration_set::Synced>", linkageName: "_RNvMs5_NtNtNtCs1SSuMAdGM58_3std4sync6poison5mutexINtB5_5MutexNtNtNtNtCs3EIJ1qnJmKW_5tokio7runtime2io16registration_set6SyncedE4lockCshxBJAVx362N_11runtime_lab", scope: !401, file: !400, line: 490, type: !52, scopeLine: 490, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!400 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/std/src/sync/poison/mutex.rs", directory: "", checksumkind: CSK_MD5, checksum: "78bfced6bc07033bbd081e9ae0e8ed7e")
!401 = !DINamespace(name: "Mutex", scope: !402)
!402 = !DINamespace(name: "mutex", scope: !403)
!403 = !DINamespace(name: "poison", scope: !38)
!404 = distinct !DILocation(line: 22, column: 22, scope: !405, inlinedAt: !411)
!405 = distinct !DISubprogram(name: "lock<tokio::runtime::io::registration_set::Synced>", linkageName: "_RNvMNtNtNtCs3EIJ1qnJmKW_5tokio4loom3std5mutexINtB2_5MutexNtNtNtNtB8_7runtime2io16registration_set6SyncedE4lockCshxBJAVx362N_11runtime_lab", scope: !407, file: !406, line: 21, type: !52, scopeLine: 21, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!406 = !DIFile(filename: "src/loom/std/mutex.rs", directory: "/Users/juanwang/.cargo/registry/src/mirrors.bfsu.edu.cn-eb00624c53167367/tokio-1.54.0", checksumkind: CSK_MD5, checksum: "e297f8d83a9482fdd24aa62c0153d109")
!407 = !DINamespace(name: "Mutex", scope: !408)
!408 = !DINamespace(name: "mutex", scope: !409)
!409 = !DINamespace(name: "std", scope: !410)
!410 = !DINamespace(name: "loom", scope: !348)
!411 = distinct !DILocation(line: 329, column: 42, scope: !367, inlinedAt: !371)
!412 = !{!413, !415, !417}
!413 = distinct !{!413, !414, !"_RNvMs5_NtNtNtCs1SSuMAdGM58_3std4sync6poison5mutexINtB5_5MutexNtNtNtNtCs3EIJ1qnJmKW_5tokio7runtime2io16registration_set6SyncedE4lockCshxBJAVx362N_11runtime_lab: %_0"}
!414 = distinct !{!414, !"_RNvMs5_NtNtNtCs1SSuMAdGM58_3std4sync6poison5mutexINtB5_5MutexNtNtNtNtCs3EIJ1qnJmKW_5tokio7runtime2io16registration_set6SyncedE4lockCshxBJAVx362N_11runtime_lab"}
!415 = distinct !{!415, !416, !"_RINvMs0_NtNtNtCs3EIJ1qnJmKW_5tokio7runtime2io6driverNtB6_6Handle17deregister_sourceNtNtNtNtCsiDZg47dpzEY_3mio3sys4unix4pipe6SenderECshxBJAVx362N_11runtime_lab: %registration"}
!416 = distinct !{!416, !"_RINvMs0_NtNtNtCs3EIJ1qnJmKW_5tokio7runtime2io6driverNtB6_6Handle17deregister_sourceNtNtNtNtCsiDZg47dpzEY_3mio3sys4unix4pipe6SenderECshxBJAVx362N_11runtime_lab"}
!417 = distinct !{!417, !416, !"_RINvMs0_NtNtNtCs3EIJ1qnJmKW_5tokio7runtime2io6driverNtB6_6Handle17deregister_sourceNtNtNtNtCsiDZg47dpzEY_3mio3sys4unix4pipe6SenderECshxBJAVx362N_11runtime_lab: %source"}
!418 = !DILocation(line: 38, column: 17, scope: !419, inlinedAt: !426)
!419 = !DILexicalBlockFile(scope: !421, file: !420, discriminator: 0)
!420 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/ptr/const_ptr.rs", directory: "", checksumkind: CSK_MD5, checksum: "25118ae25e729b7c815218b31622724c")
!421 = distinct !DISubprogram(name: "runtime", linkageName: "_RNvNvMNtNtCsjIpoRzUjyHQ_4core3ptr9const_ptrPp7is_null7runtime", scope: !423, file: !422, line: 2623, type: !52, scopeLine: 2623, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!422 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/intrinsics/mod.rs", directory: "", checksumkind: CSK_MD5, checksum: "95f29c0132b18aca34fbfb798048cc68")
!423 = !DINamespace(name: "is_null", scope: !424)
!424 = !DINamespace(name: "{impl#0}", scope: !425)
!425 = !DINamespace(name: "const_ptr", scope: !140)
!426 = distinct !DILocation(line: 2636, column: 9, scope: !427, inlinedAt: !430)
!427 = !DILexicalBlockFile(scope: !428, file: !422, discriminator: 0)
!428 = distinct !DILexicalBlock(scope: !429, file: !420, line: 25, column: 9)
!429 = distinct !DISubprogram(name: "is_null<std::sys::pal::unix::sync::mutex::Mutex>", linkageName: "_RNvMNtNtCsjIpoRzUjyHQ_4core3ptr9const_ptrPNtNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutex5Mutex7is_nullCshxBJAVx362N_11runtime_lab", scope: !424, file: !420, line: 22, type: !52, scopeLine: 22, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!430 = distinct !DILocation(line: 23, column: 27, scope: !431, inlinedAt: !435)
!431 = distinct !DISubprogram(name: "is_null<std::sys::pal::unix::sync::mutex::Mutex>", linkageName: "_RNvMNtNtCsjIpoRzUjyHQ_4core3ptr7mut_ptrONtNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutex5Mutex7is_nullCshxBJAVx362N_11runtime_lab", scope: !433, file: !432, line: 22, type: !52, scopeLine: 22, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!432 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/ptr/mut_ptr.rs", directory: "", checksumkind: CSK_MD5, checksum: "0a9a444e8d978ea2fd7622da49f95724")
!433 = !DINamespace(name: "{impl#0}", scope: !434)
!434 = !DINamespace(name: "mut_ptr", scope: !140)
!435 = distinct !DILocation(line: 265, column: 17, scope: !436, inlinedAt: !437)
!436 = distinct !DISubprogram(name: "as_ref<std::sys::pal::unix::sync::mutex::Mutex>", linkageName: "_RNvMNtNtCsjIpoRzUjyHQ_4core3ptr7mut_ptrONtNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutex5Mutex6as_refCshxBJAVx362N_11runtime_lab", scope: !433, file: !432, line: 262, type: !52, scopeLine: 262, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!437 = distinct !DILocation(line: 49, column: 28, scope: !438, inlinedAt: !393)
!438 = distinct !DILexicalBlock(scope: !392, file: !84, line: 48, column: 9)
!439 = !DILocation(line: 265, column: 12, scope: !436, inlinedAt: !437)
!440 = !DILocation(line: 51, column: 26, scope: !438, inlinedAt: !393)
!441 = !DILocation(line: 0, scope: !438, inlinedAt: !393)
!442 = !DILocation(line: 36, column: 29, scope: !397, inlinedAt: !398)
!443 = !DILocation(line: 3994, column: 24, scope: !444, inlinedAt: !445)
!444 = distinct !DISubprogram(name: "atomic_load<usize>", linkageName: "_RINvNtNtCsjIpoRzUjyHQ_4core4sync6atomic11atomic_loadjECshxBJAVx362N_11runtime_lab", scope: !46, file: !45, line: 3990, type: !40, scopeLine: 3990, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!445 = distinct !DILocation(line: 2916, column: 26, scope: !446, inlinedAt: !447)
!446 = distinct !DISubprogram(name: "load", linkageName: "_RNvMs1g_NtNtCsjIpoRzUjyHQ_4core4sync6atomicINtB6_6AtomicjE4load", scope: !51, file: !45, line: 2914, type: !52, scopeLine: 2914, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!447 = distinct !DILocation(line: 465, column: 31, scope: !448, inlinedAt: !452)
!448 = distinct !DISubprogram(name: "count_is_zero", linkageName: "_RNvNtNtCs1SSuMAdGM58_3std9panicking11panic_count13count_is_zero", scope: !450, file: !449, line: 464, type: !52, scopeLine: 464, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!449 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/std/src/panicking.rs", directory: "", checksumkind: CSK_MD5, checksum: "ccf6489229275477729282fe1b676b41")
!450 = !DINamespace(name: "panic_count", scope: !451)
!451 = !DINamespace(name: "panicking", scope: !39)
!452 = distinct !DILocation(line: 606, column: 6, scope: !453, inlinedAt: !454)
!453 = distinct !DISubprogram(name: "panicking", linkageName: "_RNvNtCs1SSuMAdGM58_3std9panicking9panicking", scope: !451, file: !449, line: 605, type: !52, scopeLine: 605, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!454 = distinct !DILocation(line: 221, column: 5, scope: !455, inlinedAt: !459)
!455 = distinct !DISubprogram(name: "panicking", linkageName: "_RNvNtNtCs1SSuMAdGM58_3std6thread9functions9panicking", scope: !457, file: !456, line: 220, type: !52, scopeLine: 220, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!456 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/std/src/thread/functions.rs", directory: "", checksumkind: CSK_MD5, checksum: "9b7a310fdb374e17e7524a15cd4faa45")
!457 = !DINamespace(name: "functions", scope: !458)
!458 = !DINamespace(name: "thread", scope: !39)
!459 = distinct !DILocation(line: 118, column: 24, scope: !460, inlinedAt: !463)
!460 = distinct !DISubprogram(name: "guard", linkageName: "_RNvMNtNtCs1SSuMAdGM58_3std4sync6poisonNtB2_4Flag5guard", scope: !462, file: !461, line: 115, type: !52, scopeLine: 115, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!461 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/std/src/sync/poison.rs", directory: "", checksumkind: CSK_MD5, checksum: "355e7733b3796b99069efee3729cec38")
!462 = !DINamespace(name: "Flag", scope: !403)
!463 = distinct !DILocation(line: 720, column: 40, scope: !464, inlinedAt: !466)
!464 = distinct !DISubprogram(name: "new<tokio::runtime::io::registration_set::Synced>", linkageName: "_RNvMs9_NtNtNtCs1SSuMAdGM58_3std4sync6poison5mutexINtB5_10MutexGuardNtNtNtNtCs3EIJ1qnJmKW_5tokio7runtime2io16registration_set6SyncedE3newCshxBJAVx362N_11runtime_lab", scope: !465, file: !400, line: 719, type: !52, scopeLine: 719, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!465 = !DINamespace(name: "MutexGuard", scope: !402)
!466 = distinct !DILocation(line: 493, column: 13, scope: !399, inlinedAt: !404)
!467 = !{!413, !415, !417, !329, !323, !317, !314}
!468 = !DILocation(line: 465, column: 12, scope: !448, inlinedAt: !452)
!469 = !DILocation(line: 477, column: 13, scope: !448, inlinedAt: !452)
!470 = !DILocation(line: 606, column: 5, scope: !453, inlinedAt: !454)
!471 = !DILocation(line: 720, column: 28, scope: !464, inlinedAt: !466)
!472 = !DILocation(line: 3994, column: 24, scope: !473, inlinedAt: !474)
!473 = distinct !DISubprogram(name: "atomic_load<u8>", linkageName: "_RINvNtNtCsjIpoRzUjyHQ_4core4sync6atomic11atomic_loadhECshxBJAVx362N_11runtime_lab", scope: !46, file: !45, line: 3990, type: !52, scopeLine: 3990, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!474 = distinct !DILocation(line: 762, column: 18, scope: !475, inlinedAt: !476)
!475 = distinct !DISubprogram(name: "load", linkageName: "_RNvMs2_NtNtCsjIpoRzUjyHQ_4core4sync6atomicINtB5_6AtomicbE4load", scope: !51, file: !45, line: 759, type: !52, scopeLine: 759, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!476 = distinct !DILocation(line: 138, column: 21, scope: !477, inlinedAt: !478)
!477 = distinct !DISubprogram(name: "get", linkageName: "_RNvMNtNtCs1SSuMAdGM58_3std4sync6poisonNtB2_4Flag3get", scope: !462, file: !461, line: 137, type: !52, scopeLine: 137, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!478 = distinct !DILocation(line: 120, column: 17, scope: !479, inlinedAt: !463)
!479 = distinct !DILexicalBlock(scope: !460, file: !461, line: 116, column: 9)
!480 = !DILocation(line: 2437, column: 9, scope: !481, inlinedAt: !485)
!481 = distinct !DISubprogram(name: "get<tokio::runtime::io::registration_set::Synced>", linkageName: "_RNvMsX_NtCsjIpoRzUjyHQ_4core4cellINtB5_10UnsafeCellNtNtNtNtCs3EIJ1qnJmKW_5tokio7runtime2io16registration_set6SyncedE3getCshxBJAVx362N_11runtime_lab", scope: !483, file: !482, line: 2434, type: !52, scopeLine: 2434, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!482 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/cell.rs", directory: "", checksumkind: CSK_MD5, checksum: "474a8d396fa87cfaeca923c1fd1a48f3")
!483 = !DINamespace(name: "UnsafeCell", scope: !484)
!484 = !DINamespace(name: "cell", scope: !48)
!485 = distinct !DILocation(line: 736, column: 39, scope: !486, inlinedAt: !488)
!486 = distinct !DISubprogram(name: "deref_mut<tokio::runtime::io::registration_set::Synced>", linkageName: "_RNvXsb_NtNtNtCs1SSuMAdGM58_3std4sync6poison5mutexINtB5_10MutexGuardNtNtNtNtCs3EIJ1qnJmKW_5tokio7runtime2io16registration_set6SyncedENtNtNtCsjIpoRzUjyHQ_4core3ops5deref8DerefMut9deref_mutCshxBJAVx362N_11runtime_lab", scope: !487, file: !400, line: 735, type: !52, scopeLine: 735, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!487 = !DINamespace(name: "{impl#13}", scope: !402)
!488 = distinct !DILocation(line: 329, column: 25, scope: !367, inlinedAt: !371)
!489 = !DILocation(line: 329, column: 14, scope: !367, inlinedAt: !371)
!490 = !DILocation(line: 120, scope: !479, inlinedAt: !463)
!491 = !DILocation(line: 329, column: 62, scope: !367, inlinedAt: !371)
!492 = !DILocation(line: 126, column: 13, scope: !493, inlinedAt: !494)
!493 = distinct !DISubprogram(name: "done", linkageName: "_RNvMNtNtCs1SSuMAdGM58_3std4sync6poisonNtB2_4Flag4done", scope: !462, file: !461, line: 125, type: !40, scopeLine: 125, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!494 = distinct !DILocation(line: 745, column: 30, scope: !495, inlinedAt: !497)
!495 = distinct !DISubprogram(name: "drop<tokio::runtime::io::registration_set::Synced>", linkageName: "_RNvXsc_NtNtNtCs1SSuMAdGM58_3std4sync6poison5mutexINtB5_10MutexGuardNtNtNtNtCs3EIJ1qnJmKW_5tokio7runtime2io16registration_set6SyncedENtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4dropCshxBJAVx362N_11runtime_lab", scope: !496, file: !400, line: 743, type: !40, scopeLine: 743, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!496 = !DINamespace(name: "{impl#14}", scope: !402)
!497 = distinct !DILocation(line: 847, column: 1, scope: !498, inlinedAt: !499)
!498 = distinct !DISubprogram(name: "drop_glue<std::sync::poison::mutex::MutexGuard<tokio::runtime::io::registration_set::Synced>>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtNtCs1SSuMAdGM58_3std4sync6poison5mutex10MutexGuardNtNtNtNtCs3EIJ1qnJmKW_5tokio7runtime2io16registration_set6SyncedEECshxBJAVx362N_11runtime_lab", scope: !140, file: !139, line: 847, type: !40, scopeLine: 847, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!499 = distinct !DILocation(line: 329, column: 62, scope: !367, inlinedAt: !371)
!500 = !DILocation(line: 3994, column: 24, scope: !444, inlinedAt: !501)
!501 = distinct !DILocation(line: 2916, column: 26, scope: !502, inlinedAt: !503)
!502 = distinct !DISubprogram(name: "load", linkageName: "_RNvMs1g_NtNtCsjIpoRzUjyHQ_4core4sync6atomicINtB6_6AtomicjE4load", scope: !51, file: !45, line: 2914, type: !52, scopeLine: 2914, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!503 = distinct !DILocation(line: 465, column: 31, scope: !504, inlinedAt: !505)
!504 = distinct !DISubprogram(name: "count_is_zero", linkageName: "_RNvNtNtCs1SSuMAdGM58_3std9panicking11panic_count13count_is_zero", scope: !450, file: !449, line: 464, type: !52, scopeLine: 464, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!505 = distinct !DILocation(line: 606, column: 6, scope: !506, inlinedAt: !507)
!506 = distinct !DISubprogram(name: "panicking", linkageName: "_RNvNtCs1SSuMAdGM58_3std9panicking9panicking", scope: !451, file: !449, line: 605, type: !52, scopeLine: 605, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!507 = distinct !DILocation(line: 221, column: 5, scope: !508, inlinedAt: !509)
!508 = distinct !DISubprogram(name: "panicking", linkageName: "_RNvNtNtCs1SSuMAdGM58_3std6thread9functions9panicking", scope: !457, file: !456, line: 220, type: !52, scopeLine: 220, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!509 = distinct !DILocation(line: 126, column: 32, scope: !493, inlinedAt: !494)
!510 = !{!415, !417, !329, !323, !317, !314}
!511 = !DILocation(line: 465, column: 12, scope: !504, inlinedAt: !505)
!512 = !DILocation(line: 477, column: 13, scope: !504, inlinedAt: !505)
!513 = !DILocation(line: 126, column: 32, scope: !493, inlinedAt: !494)
!514 = !DILocation(line: 3978, column: 24, scope: !515, inlinedAt: !516)
!515 = distinct !DISubprogram(name: "atomic_store<u8>", linkageName: "_RINvNtNtCsjIpoRzUjyHQ_4core4sync6atomic12atomic_storehECshxBJAVx362N_11runtime_lab", scope: !46, file: !45, line: 3974, type: !52, scopeLine: 3974, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!516 = distinct !DILocation(line: 793, column: 13, scope: !517, inlinedAt: !518)
!517 = distinct !DISubprogram(name: "store", linkageName: "_RNvMs2_NtNtCsjIpoRzUjyHQ_4core4sync6atomicINtB5_6AtomicbE5store", scope: !51, file: !45, line: 789, type: !52, scopeLine: 789, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!518 = distinct !DILocation(line: 127, column: 25, scope: !493, inlinedAt: !494)
!519 = !{!415, !417}
!520 = !DILocation(line: 126, column: 9, scope: !493, inlinedAt: !494)
!521 = !DILocation(line: 3994, column: 24, scope: !388, inlinedAt: !522)
!522 = distinct !DILocation(line: 1765, column: 18, scope: !523, inlinedAt: !524)
!523 = distinct !DISubprogram(name: "load<std::sys::pal::unix::sync::mutex::Mutex>", linkageName: "_RNvMs3_NtNtCsjIpoRzUjyHQ_4core4sync6atomicINtB5_6AtomicONtNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutex5MutexE4loadCshxBJAVx362N_11runtime_lab", scope: !51, file: !45, line: 1763, type: !52, scopeLine: 1763, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!524 = distinct !DILocation(line: 43, column: 48, scope: !525, inlinedAt: !526)
!525 = distinct !DISubprogram(name: "get_unchecked<std::sys::pal::unix::sync::mutex::Mutex>", linkageName: "_RNvMNtNtNtCs1SSuMAdGM58_3std3sys4sync8once_boxINtB2_7OnceBoxNtNtNtNtNtB6_3pal4unix4sync5mutex5MutexE13get_uncheckedCshxBJAVx362N_11runtime_lab", scope: !85, file: !84, line: 42, type: !52, scopeLine: 42, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!526 = distinct !DILocation(line: 45, column: 27, scope: !527, inlinedAt: !528)
!527 = distinct !DISubprogram(name: "unlock", linkageName: "_RNvMNtNtNtNtCs1SSuMAdGM58_3std3sys4sync5mutex7pthreadNtB2_5Mutex6unlock", scope: !395, file: !90, line: 42, type: !52, scopeLine: 42, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!528 = distinct !DILocation(line: 746, column: 29, scope: !495, inlinedAt: !497)
!529 = !DILocation(line: 45, column: 43, scope: !527, inlinedAt: !528)
!530 = !DILocation(line: 126, column: 13, scope: !493, inlinedAt: !531)
!531 = distinct !DILocation(line: 745, column: 30, scope: !495, inlinedAt: !532)
!532 = distinct !DILocation(line: 847, column: 1, scope: !498, inlinedAt: !533)
!533 = distinct !DILocation(line: 329, column: 62, scope: !367, inlinedAt: !371)
!534 = !DILocation(line: 3994, column: 24, scope: !444, inlinedAt: !535)
!535 = distinct !DILocation(line: 2916, column: 26, scope: !502, inlinedAt: !536)
!536 = distinct !DILocation(line: 465, column: 31, scope: !504, inlinedAt: !537)
!537 = distinct !DILocation(line: 606, column: 6, scope: !506, inlinedAt: !538)
!538 = distinct !DILocation(line: 221, column: 5, scope: !508, inlinedAt: !539)
!539 = distinct !DILocation(line: 126, column: 32, scope: !493, inlinedAt: !531)
!540 = !DILocation(line: 465, column: 12, scope: !504, inlinedAt: !537)
!541 = !DILocation(line: 477, column: 13, scope: !504, inlinedAt: !537)
!542 = !DILocation(line: 126, column: 32, scope: !493, inlinedAt: !531)
!543 = !DILocation(line: 3978, column: 24, scope: !515, inlinedAt: !544)
!544 = distinct !DILocation(line: 793, column: 13, scope: !517, inlinedAt: !545)
!545 = distinct !DILocation(line: 127, column: 25, scope: !493, inlinedAt: !531)
!546 = !DILocation(line: 126, column: 9, scope: !493, inlinedAt: !531)
!547 = !DILocation(line: 3994, column: 24, scope: !388, inlinedAt: !548)
!548 = distinct !DILocation(line: 1765, column: 18, scope: !523, inlinedAt: !549)
!549 = distinct !DILocation(line: 43, column: 48, scope: !525, inlinedAt: !550)
!550 = distinct !DILocation(line: 45, column: 27, scope: !527, inlinedAt: !551)
!551 = distinct !DILocation(line: 746, column: 29, scope: !495, inlinedAt: !532)
!552 = !DILocation(line: 45, column: 43, scope: !527, inlinedAt: !551)
!553 = !DILocation(line: 331, column: 18, scope: !367, inlinedAt: !371)
!554 = !DILocation(line: 312, column: 5, scope: !367, inlinedAt: !371)
!555 = !DILocation(line: 235, column: 21, scope: !556, inlinedAt: !562)
!556 = distinct !DISubprogram(name: "drop", linkageName: "_RNvXs1_NtNtNtCsjIpoRzUjyHQ_4core2io5error4reprNtB5_4ReprNtNtNtBb_3ops4drop4Drop4drop", scope: !558, file: !557, line: 231, type: !40, scopeLine: 231, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!557 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/io/error/repr_bitpacked.rs", directory: "", checksumkind: CSK_MD5, checksum: "017629f0cc661e5f230239fe43364116")
!558 = !DINamespace(name: "{impl#3}", scope: !559)
!559 = !DINamespace(name: "repr", scope: !560)
!560 = !DINamespace(name: "error", scope: !561)
!561 = !DINamespace(name: "io", scope: !48)
!562 = distinct !DILocation(line: 847, column: 1, scope: !563, inlinedAt: !564)
!563 = distinct !DISubprogram(name: "drop_glue<core::io::error::repr::Repr>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtNtNtB4_2io5error4repr4ReprECshxBJAVx362N_11runtime_lab", scope: !140, file: !139, line: 847, type: !40, scopeLine: 847, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!564 = distinct !DILocation(line: 847, column: 1, scope: !565, inlinedAt: !566)
!565 = distinct !DISubprogram(name: "drop_glue<core::io::error::Error>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtNtB4_2io5error5ErrorECshxBJAVx362N_11runtime_lab", scope: !140, file: !139, line: 847, type: !40, scopeLine: 847, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!566 = distinct !DILocation(line: 847, column: 1, scope: !567, inlinedAt: !568)
!567 = distinct !DISubprogram(name: "drop_glue<core::result::Result<(), core::io::error::Error>>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtB4_6result6ResultuNtNtNtB4_2io5error5ErrorEECshxBJAVx362N_11runtime_lab", scope: !140, file: !139, line: 847, type: !40, scopeLine: 847, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!568 = distinct !DILocation(line: 316, column: 58, scope: !342, inlinedAt: !349)
!569 = !DILocation(line: 150, column: 18, scope: !570, inlinedAt: !571)
!570 = distinct !DISubprogram(name: "addr<()>", linkageName: "_RNvMNtNtCsjIpoRzUjyHQ_4core3ptr7mut_ptrOu4addrCshxBJAVx362N_11runtime_lab", scope: !433, file: !432, line: 144, type: !52, scopeLine: 144, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!571 = distinct !DILocation(line: 251, column: 29, scope: !572, inlinedAt: !573)
!572 = distinct !DISubprogram(name: "decode_repr<core::io::error::CustomOwner, core::io::error::repr::{impl#3}::drop::{closure_env#0}>", linkageName: "_RINvNtNtNtCsjIpoRzUjyHQ_4core2io5error4repr11decode_reprNtB4_11CustomOwnerNCNvXs1_B2_NtB2_4ReprNtNtNtB8_3ops4drop4Drop4drop0ECshxBJAVx362N_11runtime_lab", scope: !559, file: !557, line: 247, type: !52, scopeLine: 247, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!573 = distinct !DILocation(line: 235, column: 21, scope: !556, inlinedAt: !562)
!574 = !DILocation(line: 252, column: 11, scope: !575, inlinedAt: !573)
!575 = distinct !DILexicalBlock(scope: !572, file: !557, line: 251, column: 5)
!576 = !DILocation(line: 252, column: 5, scope: !575, inlinedAt: !573)
!577 = !{!"branch_weights", i32 1, i32 2000, i32 2000, i32 2000, i32 2000}
!578 = !DILocation(line: 1074, column: 28, scope: !579, inlinedAt: !582)
!579 = distinct !DISubprogram(name: "from_prim", linkageName: "_RNvMsf_NtNtCsjIpoRzUjyHQ_4core2io5errorNtB5_9ErrorKind9from_prim", scope: !581, file: !580, line: 1066, type: !52, scopeLine: 1066, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!580 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/io/error.rs", directory: "", checksumkind: CSK_MD5, checksum: "a5c0f6fcd996d3da8046213e686ffb8b")
!581 = !DINamespace(name: "ErrorKind", scope: !560)
!582 = distinct !DILocation(line: 259, column: 24, scope: !583, inlinedAt: !573)
!583 = distinct !DILexicalBlock(scope: !575, file: !557, line: 258, column: 13)
!584 = !DILocation(line: 1063, column: 15, scope: !585, inlinedAt: !586)
!585 = distinct !DISubprogram(name: "unwrap_or_else<core::io::error::ErrorKind, core::io::error::repr::decode_repr::{closure_env#0}<core::io::error::CustomOwner, core::io::error::repr::{impl#3}::drop::{closure_env#0}>>", linkageName: "_RINvMNtCsjIpoRzUjyHQ_4core6optionINtB3_6OptionNtNtNtB5_2io5error9ErrorKindE14unwrap_or_elseNCINvNtBK_4repr11decode_reprNtBK_11CustomOwnerNCNvXs1_B1w_NtB1w_4ReprNtNtNtB5_3ops4drop4Drop4drop0E0ECshxBJAVx362N_11runtime_lab", scope: !339, file: !338, line: 1059, type: !52, scopeLine: 1059, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!586 = distinct !DILocation(line: 259, column: 56, scope: !583, inlinedAt: !573)
!587 = !DILocation(line: 1063, column: 9, scope: !585, inlinedAt: !586)
!588 = !DILocation(line: 270, column: 9, scope: !575, inlinedAt: !573)
!589 = !DILocation(line: 474, column: 18, scope: !590, inlinedAt: !591)
!590 = distinct !DISubprogram(name: "wrapping_offset<u8>", linkageName: "_RNvMNtNtCsjIpoRzUjyHQ_4core3ptr7mut_ptrOh15wrapping_offsetCshxBJAVx362N_11runtime_lab", scope: !433, file: !432, line: 469, type: !52, scopeLine: 469, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!591 = distinct !DILocation(line: 1211, column: 14, scope: !592, inlinedAt: !593)
!592 = distinct !DISubprogram(name: "wrapping_sub<u8>", linkageName: "_RNvMNtNtCsjIpoRzUjyHQ_4core3ptr7mut_ptrOh12wrapping_subCshxBJAVx362N_11runtime_lab", scope: !433, file: !432, line: 1207, type: !52, scopeLine: 1207, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!593 = distinct !DILocation(line: 1228, column: 27, scope: !594, inlinedAt: !595)
!594 = distinct !DISubprogram(name: "wrapping_byte_sub<()>", linkageName: "_RNvMNtNtCsjIpoRzUjyHQ_4core3ptr7mut_ptrOu17wrapping_byte_subCshxBJAVx362N_11runtime_lab", scope: !433, file: !432, line: 1227, type: !52, scopeLine: 1227, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!595 = distinct !DILocation(line: 279, column: 39, scope: !575, inlinedAt: !573)
!596 = !DILocation(line: 247, column: 13, scope: !597, inlinedAt: !601)
!597 = distinct !DISubprogram(name: "new_unchecked<core::io::error::Custom>", linkageName: "_RNvMs1_NtNtCsjIpoRzUjyHQ_4core3ptr8non_nullINtB5_7NonNullNtNtNtB9_2io5error6CustomE13new_uncheckedCshxBJAVx362N_11runtime_lab", scope: !599, file: !598, line: 239, type: !52, scopeLine: 239, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!598 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/ptr/non_null.rs", directory: "", checksumkind: CSK_MD5, checksum: "accc742d53c125b723531f778524eec8")
!599 = !DINamespace(name: "NonNull", scope: !600)
!600 = !DINamespace(name: "non_null", scope: !140)
!601 = distinct !DILocation(line: 236, column: 39, scope: !602, inlinedAt: !604)
!602 = distinct !DISubprogram(name: "{closure#0}", linkageName: "_RNCNvXs1_NtNtNtCsjIpoRzUjyHQ_4core2io5error4reprNtB7_4ReprNtNtNtBd_3ops4drop4Drop4drop0CshxBJAVx362N_11runtime_lab", scope: !603, file: !557, line: 235, type: !52, scopeLine: 235, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!603 = !DINamespace(name: "drop", scope: !558)
!604 = distinct !DILocation(line: 280, column: 31, scope: !605, inlinedAt: !573)
!605 = distinct !DILexicalBlock(scope: !575, file: !557, line: 279, column: 13)
!606 = !DILocation(line: 280, column: 13, scope: !605, inlinedAt: !573)
!607 = !{!608}
!608 = distinct !{!608, !609, !"_RINvNtNtNtCsjIpoRzUjyHQ_4core2io5error4repr11decode_reprNtB4_11CustomOwnerNCNvXs1_B2_NtB2_4ReprNtNtNtB8_3ops4drop4Drop4drop0ECshxBJAVx362N_11runtime_lab: %_0"}
!609 = distinct !{!609, !"_RINvNtNtNtCsjIpoRzUjyHQ_4core2io5error4repr11decode_reprNtB4_11CustomOwnerNCNvXs1_B2_NtB2_4ReprNtNtNtB8_3ops4drop4Drop4drop0ECshxBJAVx362N_11runtime_lab"}
!610 = !DILocation(line: 0, scope: !575, inlinedAt: !573)
!611 = !DILocation(line: 847, column: 1, scope: !612, inlinedAt: !613)
!612 = distinct !DISubprogram(name: "drop_glue<core::io::error::CustomOwner>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtNtB4_2io5error11CustomOwnerECshxBJAVx362N_11runtime_lab", scope: !140, file: !139, line: 847, type: !52, scopeLine: 847, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!613 = distinct !DILocation(line: 847, column: 1, scope: !614, inlinedAt: !615)
!614 = distinct !DISubprogram(name: "drop_glue<core::io::error::ErrorData<core::io::error::CustomOwner>>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtB4_2io5error9ErrorDataNtBE_11CustomOwnerEECshxBJAVx362N_11runtime_lab", scope: !140, file: !139, line: 847, type: !52, scopeLine: 847, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!615 = distinct !DILocation(line: 237, column: 15, scope: !556, inlinedAt: !562)
!616 = !DILocation(line: 237, column: 15, scope: !556, inlinedAt: !562)
!617 = !DILocation(line: 847, column: 1, scope: !567, inlinedAt: !568)
!618 = !{i32 0, i32 -1}
!619 = !DILocation(line: 220, column: 25, scope: !278, inlinedAt: !620)
!620 = distinct !DILocation(line: 847, column: 1, scope: !285, inlinedAt: !621)
!621 = distinct !DILocation(line: 847, column: 1, scope: !287, inlinedAt: !622)
!622 = distinct !DILocation(line: 847, column: 1, scope: !623, inlinedAt: !624)
!623 = distinct !DISubprogram(name: "drop_glue<std::sys::fs::unix::File>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtNtNtCs1SSuMAdGM58_3std3sys2fs4unix4FileECshxBJAVx362N_11runtime_lab", scope: !140, file: !139, line: 847, type: !40, scopeLine: 847, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!624 = distinct !DILocation(line: 847, column: 1, scope: !625, inlinedAt: !626)
!625 = distinct !DISubprogram(name: "drop_glue<std::fs::File>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtCs1SSuMAdGM58_3std2fs4FileECshxBJAVx362N_11runtime_lab", scope: !140, file: !139, line: 847, type: !40, scopeLine: 847, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!626 = distinct !DILocation(line: 847, column: 1, scope: !627, inlinedAt: !628)
!627 = distinct !DISubprogram(name: "drop_glue<mio::io_source::IoSource<std::fs::File>>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCsiDZg47dpzEY_3mio9io_source8IoSourceNtNtCs1SSuMAdGM58_3std2fs4FileEECshxBJAVx362N_11runtime_lab", scope: !140, file: !139, line: 847, type: !40, scopeLine: 847, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!628 = distinct !DILocation(line: 847, column: 1, scope: !629, inlinedAt: !630)
!629 = distinct !DISubprogram(name: "drop_glue<mio::sys::unix::pipe::Sender>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtNtNtCsiDZg47dpzEY_3mio3sys4unix4pipe6SenderECshxBJAVx362N_11runtime_lab", scope: !140, file: !139, line: 847, type: !40, scopeLine: 847, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!630 = distinct !DILocation(line: 317, column: 9, scope: !344, inlinedAt: !349)
!631 = !{!323, !317, !314}
!632 = !DILocation(line: 847, column: 1, scope: !633, inlinedAt: !634)
!633 = distinct !DISubprogram(name: "drop_glue<core::option::Option<mio::sys::unix::pipe::Sender>>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtB4_6option6OptionNtNtNtNtCsiDZg47dpzEY_3mio3sys4unix4pipe6SenderEECshxBJAVx362N_11runtime_lab", scope: !140, file: !139, line: 847, type: !40, scopeLine: 847, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!634 = distinct !DILocation(line: 847, column: 1, scope: !332, inlinedAt: !333)
!635 = !DILocation(line: 220, column: 25, scope: !278, inlinedAt: !636)
!636 = distinct !DILocation(line: 847, column: 1, scope: !285, inlinedAt: !637)
!637 = distinct !DILocation(line: 847, column: 1, scope: !287, inlinedAt: !638)
!638 = distinct !DILocation(line: 847, column: 1, scope: !623, inlinedAt: !639)
!639 = distinct !DILocation(line: 847, column: 1, scope: !625, inlinedAt: !640)
!640 = distinct !DILocation(line: 847, column: 1, scope: !627, inlinedAt: !641)
!641 = distinct !DILocation(line: 847, column: 1, scope: !629, inlinedAt: !642)
!642 = distinct !DILocation(line: 847, column: 1, scope: !633, inlinedAt: !634)
!643 = !DILocation(line: 220, column: 25, scope: !278, inlinedAt: !644)
!644 = distinct !DILocation(line: 847, column: 1, scope: !285, inlinedAt: !645)
!645 = distinct !DILocation(line: 847, column: 1, scope: !287, inlinedAt: !646)
!646 = distinct !DILocation(line: 847, column: 1, scope: !623, inlinedAt: !647)
!647 = distinct !DILocation(line: 847, column: 1, scope: !625, inlinedAt: !648)
!648 = distinct !DILocation(line: 847, column: 1, scope: !627, inlinedAt: !649)
!649 = distinct !DILocation(line: 847, column: 1, scope: !629, inlinedAt: !650)
!650 = distinct !DILocation(line: 317, column: 9, scope: !344, inlinedAt: !349)
!651 = !DILocation(line: 847, column: 1, scope: !633, inlinedAt: !652)
!652 = distinct !DILocation(line: 847, column: 1, scope: !332, inlinedAt: !333)
!653 = !DILocation(line: 220, column: 25, scope: !278, inlinedAt: !654)
!654 = distinct !DILocation(line: 847, column: 1, scope: !285, inlinedAt: !655)
!655 = distinct !DILocation(line: 847, column: 1, scope: !287, inlinedAt: !656)
!656 = distinct !DILocation(line: 847, column: 1, scope: !623, inlinedAt: !657)
!657 = distinct !DILocation(line: 847, column: 1, scope: !625, inlinedAt: !658)
!658 = distinct !DILocation(line: 847, column: 1, scope: !627, inlinedAt: !659)
!659 = distinct !DILocation(line: 847, column: 1, scope: !629, inlinedAt: !660)
!660 = distinct !DILocation(line: 847, column: 1, scope: !633, inlinedAt: !652)
!661 = distinct !DISubprogram(name: "drop_glue<core::result::Result<tokio::process::Child, core::io::error::Error>>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtB4_6result6ResultNtNtCs3EIJ1qnJmKW_5tokio7process5ChildNtNtNtB4_2io5error5ErrorEECshxBJAVx362N_11runtime_lab", scope: !140, file: !139, line: 847, type: !52, scopeLine: 847, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!662 = !{i64 -2848050491820181563}
!663 = !DILocation(line: 847, column: 1, scope: !661)
!664 = !{i64 -1, i64 3}
!665 = !{!666}
!666 = distinct !{!666, !667, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtCs3EIJ1qnJmKW_5tokio7process5ChildECshxBJAVx362N_11runtime_lab: %_1"}
!667 = distinct !{!667, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtCs3EIJ1qnJmKW_5tokio7process5ChildECshxBJAVx362N_11runtime_lab"}
!668 = !DILocation(line: 847, column: 1, scope: !669, inlinedAt: !670)
!669 = distinct !DISubprogram(name: "drop_glue<tokio::process::Child>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtCs3EIJ1qnJmKW_5tokio7process5ChildECshxBJAVx362N_11runtime_lab", scope: !140, file: !139, line: 847, type: !52, scopeLine: 847, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!670 = distinct !DILocation(line: 847, column: 1, scope: !661)
!671 = !{!672}
!672 = distinct !{!672, !673, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtCs3EIJ1qnJmKW_5tokio7process10FusedChildECshxBJAVx362N_11runtime_lab: %_1"}
!673 = distinct !{!673, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtCs3EIJ1qnJmKW_5tokio7process10FusedChildECshxBJAVx362N_11runtime_lab"}
!674 = !DILocation(line: 847, column: 1, scope: !675, inlinedAt: !676)
!675 = distinct !DISubprogram(name: "drop_glue<tokio::process::FusedChild>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtCs3EIJ1qnJmKW_5tokio7process10FusedChildECshxBJAVx362N_11runtime_lab", scope: !140, file: !139, line: 847, type: !52, scopeLine: 847, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!676 = distinct !DILocation(line: 847, column: 1, scope: !669, inlinedAt: !670)
!677 = !{i32 -1, i32 3}
!678 = !{!672, !666}
!679 = !{!680}
!680 = distinct !{!680, !681, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs3EIJ1qnJmKW_5tokio7process14ChildDropGuardNtNtBE_3imp5ChildEECshxBJAVx362N_11runtime_lab: %_1"}
!681 = distinct !{!681, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs3EIJ1qnJmKW_5tokio7process14ChildDropGuardNtNtBE_3imp5ChildEECshxBJAVx362N_11runtime_lab"}
!682 = !{!683}
!683 = distinct !{!683, !684, !"_RNvXs1_NtCs3EIJ1qnJmKW_5tokio7processINtB5_14ChildDropGuardNtNtB5_3imp5ChildENtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4dropCshxBJAVx362N_11runtime_lab: %self"}
!684 = distinct !{!684, !"_RNvXs1_NtCs3EIJ1qnJmKW_5tokio7processINtB5_14ChildDropGuardNtNtB5_3imp5ChildENtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4dropCshxBJAVx362N_11runtime_lab"}
!685 = !DILocation(line: 847, column: 1, scope: !686, inlinedAt: !687)
!686 = distinct !DISubprogram(name: "drop_glue<tokio::process::ChildDropGuard<tokio::process::imp::Child>>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs3EIJ1qnJmKW_5tokio7process14ChildDropGuardNtNtBE_3imp5ChildEECshxBJAVx362N_11runtime_lab", scope: !140, file: !139, line: 847, type: !52, scopeLine: 847, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!687 = distinct !DILocation(line: 847, column: 1, scope: !675, inlinedAt: !676)
!688 = !DILocation(line: 1125, column: 12, scope: !689, inlinedAt: !693)
!689 = distinct !DISubprogram(name: "drop<tokio::process::imp::Child>", linkageName: "_RNvXs1_NtCs3EIJ1qnJmKW_5tokio7processINtB5_14ChildDropGuardNtNtB5_3imp5ChildENtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4dropCshxBJAVx362N_11runtime_lab", scope: !691, file: !690, line: 1124, type: !52, scopeLine: 1124, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!690 = !DIFile(filename: "src/process/mod.rs", directory: "/Users/juanwang/.cargo/registry/src/mirrors.bfsu.edu.cn-eb00624c53167367/tokio-1.54.0", checksumkind: CSK_MD5, checksum: "2a19f8684a29daf6bf582e63cda1898a")
!691 = !DINamespace(name: "{impl#3}", scope: !692)
!692 = !DINamespace(name: "process", scope: !348)
!693 = distinct !DILocation(line: 847, column: 1, scope: !686, inlinedAt: !687)
!694 = !{i8 0, i8 2}
!695 = !{!683, !680, !672, !666}
!696 = !DILocation(line: 1113, column: 30, scope: !697, inlinedAt: !699)
!697 = distinct !DISubprogram(name: "kill<tokio::process::imp::Child>", linkageName: "_RNvXs0_NtCs3EIJ1qnJmKW_5tokio7processINtB5_14ChildDropGuardNtNtB5_3imp5ChildENtNtB5_4kill4Kill4killCshxBJAVx362N_11runtime_lab", scope: !698, file: !690, line: 1112, type: !52, scopeLine: 1112, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!698 = !DINamespace(name: "{impl#2}", scope: !692)
!699 = distinct !DILocation(line: 1126, column: 23, scope: !689, inlinedAt: !693)
!700 = !DILocation(line: 595, column: 18, scope: !701, inlinedAt: !706)
!701 = !DILexicalBlockFile(scope: !702, file: !381, discriminator: 0)
!702 = distinct !DILexicalBlock(scope: !704, file: !703, line: 434, column: 9)
!703 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/macros/mod.rs", directory: "", checksumkind: CSK_MD5, checksum: "2f18ff6bcbb078f77779c8f14def2c67")
!704 = distinct !DISubprogram(name: "is_ok<(), core::io::error::Error>", linkageName: "_RNvMNtCsjIpoRzUjyHQ_4core6resultINtB2_6ResultuNtNtNtB4_2io5error5ErrorE5is_okCshxBJAVx362N_11runtime_lab", scope: !705, file: !381, line: 594, type: !52, scopeLine: 594, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!705 = !DINamespace(name: "Result", scope: !383)
!706 = distinct !DILocation(line: 1115, column: 16, scope: !707, inlinedAt: !699)
!707 = distinct !DILexicalBlock(scope: !697, file: !690, line: 1113, column: 9)
!708 = !DILocation(line: 1115, column: 12, scope: !707, inlinedAt: !699)
!709 = !DILocation(line: 235, column: 21, scope: !556, inlinedAt: !710)
!710 = distinct !DILocation(line: 847, column: 1, scope: !563, inlinedAt: !711)
!711 = distinct !DILocation(line: 847, column: 1, scope: !565, inlinedAt: !712)
!712 = distinct !DILocation(line: 847, column: 1, scope: !567, inlinedAt: !713)
!713 = distinct !DILocation(line: 1049, column: 1, scope: !714, inlinedAt: !715)
!714 = distinct !DISubprogram(name: "drop<core::result::Result<(), core::io::error::Error>>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3mem4dropINtNtB4_6result6ResultuNtNtNtB4_2io5error5ErrorEECshxBJAVx362N_11runtime_lab", scope: !164, file: !163, line: 1045, type: !52, scopeLine: 1045, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!715 = distinct !DILocation(line: 1126, column: 13, scope: !689, inlinedAt: !693)
!716 = !DILocation(line: 150, column: 18, scope: !570, inlinedAt: !717)
!717 = distinct !DILocation(line: 251, column: 29, scope: !572, inlinedAt: !718)
!718 = distinct !DILocation(line: 235, column: 21, scope: !556, inlinedAt: !710)
!719 = !DILocation(line: 252, column: 11, scope: !575, inlinedAt: !718)
!720 = !DILocation(line: 252, column: 5, scope: !575, inlinedAt: !718)
!721 = !DILocation(line: 1074, column: 28, scope: !579, inlinedAt: !722)
!722 = distinct !DILocation(line: 259, column: 24, scope: !583, inlinedAt: !718)
!723 = !DILocation(line: 1063, column: 15, scope: !585, inlinedAt: !724)
!724 = distinct !DILocation(line: 259, column: 56, scope: !583, inlinedAt: !718)
!725 = !DILocation(line: 1063, column: 9, scope: !585, inlinedAt: !724)
!726 = !DILocation(line: 270, column: 9, scope: !575, inlinedAt: !718)
!727 = !DILocation(line: 474, column: 18, scope: !590, inlinedAt: !728)
!728 = distinct !DILocation(line: 1211, column: 14, scope: !592, inlinedAt: !729)
!729 = distinct !DILocation(line: 1228, column: 27, scope: !594, inlinedAt: !730)
!730 = distinct !DILocation(line: 279, column: 39, scope: !575, inlinedAt: !718)
!731 = !DILocation(line: 247, column: 13, scope: !597, inlinedAt: !732)
!732 = distinct !DILocation(line: 236, column: 39, scope: !602, inlinedAt: !733)
!733 = distinct !DILocation(line: 280, column: 31, scope: !605, inlinedAt: !718)
!734 = !DILocation(line: 280, column: 13, scope: !605, inlinedAt: !718)
!735 = !{!736}
!736 = distinct !{!736, !737, !"_RINvNtNtNtCsjIpoRzUjyHQ_4core2io5error4repr11decode_reprNtB4_11CustomOwnerNCNvXs1_B2_NtB2_4ReprNtNtNtB8_3ops4drop4Drop4drop0ECshxBJAVx362N_11runtime_lab: %_0"}
!737 = distinct !{!737, !"_RINvNtNtNtCsjIpoRzUjyHQ_4core2io5error4repr11decode_reprNtB4_11CustomOwnerNCNvXs1_B2_NtB2_4ReprNtNtNtB8_3ops4drop4Drop4drop0ECshxBJAVx362N_11runtime_lab"}
!738 = !DILocation(line: 0, scope: !575, inlinedAt: !718)
!739 = !DILocation(line: 847, column: 1, scope: !612, inlinedAt: !740)
!740 = distinct !DILocation(line: 847, column: 1, scope: !614, inlinedAt: !741)
!741 = distinct !DILocation(line: 237, column: 15, scope: !556, inlinedAt: !710)
!742 = !DILocation(line: 237, column: 15, scope: !556, inlinedAt: !710)
!743 = !DILocation(line: 847, column: 1, scope: !567, inlinedAt: !713)
!744 = !DILocation(line: 1116, column: 13, scope: !707, inlinedAt: !699)
!745 = !DILocation(line: 847, column: 1, scope: !746, inlinedAt: !747)
!746 = distinct !DISubprogram(name: "drop_glue<core::option::Option<tokio::process::ChildStdout>>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtB4_6option6OptionNtNtCs3EIJ1qnJmKW_5tokio7process11ChildStdoutEECshxBJAVx362N_11runtime_lab", scope: !140, file: !139, line: 847, type: !52, scopeLine: 847, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!747 = distinct !DILocation(line: 847, column: 1, scope: !669, inlinedAt: !670)
!748 = !{!749, !666}
!749 = distinct !{!749, !750, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtB4_6option6OptionNtNtCs3EIJ1qnJmKW_5tokio7process11ChildStdoutEECshxBJAVx362N_11runtime_lab: %_1"}
!750 = distinct !{!750, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtB4_6option6OptionNtNtCs3EIJ1qnJmKW_5tokio7process11ChildStdoutEECshxBJAVx362N_11runtime_lab"}
!751 = !DILocation(line: 847, column: 1, scope: !752, inlinedAt: !753)
!752 = distinct !DISubprogram(name: "drop_glue<tokio::process::ChildStdout>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtCs3EIJ1qnJmKW_5tokio7process11ChildStdoutECshxBJAVx362N_11runtime_lab", scope: !140, file: !139, line: 847, type: !52, scopeLine: 847, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!753 = distinct !DILocation(line: 847, column: 1, scope: !746, inlinedAt: !747)
!754 = !DILocation(line: 847, column: 1, scope: !746, inlinedAt: !755)
!755 = distinct !DILocation(line: 847, column: 1, scope: !669, inlinedAt: !670)
!756 = !{!757, !666}
!757 = distinct !{!757, !758, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtB4_6option6OptionNtNtCs3EIJ1qnJmKW_5tokio7process11ChildStdoutEECshxBJAVx362N_11runtime_lab: %_1"}
!758 = distinct !{!758, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtB4_6option6OptionNtNtCs3EIJ1qnJmKW_5tokio7process11ChildStdoutEECshxBJAVx362N_11runtime_lab"}
!759 = !DILocation(line: 847, column: 1, scope: !752, inlinedAt: !760)
!760 = distinct !DILocation(line: 847, column: 1, scope: !746, inlinedAt: !755)
!761 = !DILocation(line: 847, column: 1, scope: !762, inlinedAt: !763)
!762 = distinct !DISubprogram(name: "drop_glue<core::option::Option<tokio::process::ChildStderr>>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtB4_6option6OptionNtNtCs3EIJ1qnJmKW_5tokio7process11ChildStderrEECshxBJAVx362N_11runtime_lab", scope: !140, file: !139, line: 847, type: !52, scopeLine: 847, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!763 = distinct !DILocation(line: 847, column: 1, scope: !669, inlinedAt: !670)
!764 = !{!765, !666}
!765 = distinct !{!765, !766, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtB4_6option6OptionNtNtCs3EIJ1qnJmKW_5tokio7process11ChildStderrEECshxBJAVx362N_11runtime_lab: %_1"}
!766 = distinct !{!766, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtB4_6option6OptionNtNtCs3EIJ1qnJmKW_5tokio7process11ChildStderrEECshxBJAVx362N_11runtime_lab"}
!767 = !DILocation(line: 847, column: 1, scope: !768, inlinedAt: !769)
!768 = distinct !DISubprogram(name: "drop_glue<tokio::process::ChildStderr>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtCs3EIJ1qnJmKW_5tokio7process11ChildStderrECshxBJAVx362N_11runtime_lab", scope: !140, file: !139, line: 847, type: !52, scopeLine: 847, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!769 = distinct !DILocation(line: 847, column: 1, scope: !762, inlinedAt: !763)
!770 = !DILocation(line: 847, column: 1, scope: !762, inlinedAt: !771)
!771 = distinct !DILocation(line: 847, column: 1, scope: !669, inlinedAt: !670)
!772 = !{!773, !666}
!773 = distinct !{!773, !774, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtB4_6option6OptionNtNtCs3EIJ1qnJmKW_5tokio7process11ChildStderrEECshxBJAVx362N_11runtime_lab: %_1"}
!774 = distinct !{!774, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtB4_6option6OptionNtNtCs3EIJ1qnJmKW_5tokio7process11ChildStderrEECshxBJAVx362N_11runtime_lab"}
!775 = !DILocation(line: 847, column: 1, scope: !768, inlinedAt: !776)
!776 = distinct !DILocation(line: 847, column: 1, scope: !762, inlinedAt: !771)
!777 = !DILocation(line: 235, column: 21, scope: !556, inlinedAt: !778)
!778 = distinct !DILocation(line: 847, column: 1, scope: !563, inlinedAt: !779)
!779 = distinct !DILocation(line: 847, column: 1, scope: !565, inlinedAt: !780)
!780 = distinct !DILocation(line: 847, column: 1, scope: !661)
!781 = !DILocation(line: 150, column: 18, scope: !570, inlinedAt: !782)
!782 = distinct !DILocation(line: 251, column: 29, scope: !572, inlinedAt: !783)
!783 = distinct !DILocation(line: 235, column: 21, scope: !556, inlinedAt: !778)
!784 = !DILocation(line: 252, column: 11, scope: !575, inlinedAt: !783)
!785 = !DILocation(line: 252, column: 5, scope: !575, inlinedAt: !783)
!786 = !DILocation(line: 1074, column: 28, scope: !579, inlinedAt: !787)
!787 = distinct !DILocation(line: 259, column: 24, scope: !583, inlinedAt: !783)
!788 = !DILocation(line: 1063, column: 15, scope: !585, inlinedAt: !789)
!789 = distinct !DILocation(line: 259, column: 56, scope: !583, inlinedAt: !783)
!790 = !DILocation(line: 1063, column: 9, scope: !585, inlinedAt: !789)
!791 = !DILocation(line: 270, column: 9, scope: !575, inlinedAt: !783)
!792 = !DILocation(line: 474, column: 18, scope: !590, inlinedAt: !793)
!793 = distinct !DILocation(line: 1211, column: 14, scope: !592, inlinedAt: !794)
!794 = distinct !DILocation(line: 1228, column: 27, scope: !594, inlinedAt: !795)
!795 = distinct !DILocation(line: 279, column: 39, scope: !575, inlinedAt: !783)
!796 = !DILocation(line: 247, column: 13, scope: !597, inlinedAt: !797)
!797 = distinct !DILocation(line: 236, column: 39, scope: !602, inlinedAt: !798)
!798 = distinct !DILocation(line: 280, column: 31, scope: !605, inlinedAt: !783)
!799 = !DILocation(line: 280, column: 13, scope: !605, inlinedAt: !783)
!800 = !{!801}
!801 = distinct !{!801, !802, !"_RINvNtNtNtCsjIpoRzUjyHQ_4core2io5error4repr11decode_reprNtB4_11CustomOwnerNCNvXs1_B2_NtB2_4ReprNtNtNtB8_3ops4drop4Drop4drop0ECshxBJAVx362N_11runtime_lab: %_0"}
!802 = distinct !{!802, !"_RINvNtNtNtCsjIpoRzUjyHQ_4core2io5error4repr11decode_reprNtB4_11CustomOwnerNCNvXs1_B2_NtB2_4ReprNtNtNtB8_3ops4drop4Drop4drop0ECshxBJAVx362N_11runtime_lab"}
!803 = !DILocation(line: 0, scope: !575, inlinedAt: !783)
!804 = !DILocation(line: 847, column: 1, scope: !612, inlinedAt: !805)
!805 = distinct !DILocation(line: 847, column: 1, scope: !614, inlinedAt: !806)
!806 = distinct !DILocation(line: 237, column: 15, scope: !556, inlinedAt: !778)
!807 = !DILocation(line: 847, column: 1, scope: !614, inlinedAt: !806)
!808 = !DILocation(line: 237, column: 15, scope: !556, inlinedAt: !778)
!809 = distinct !DISubprogram(name: "drop_glue<std::sync::poison::PoisonError<std::sync::poison::mutex::MutexGuard<runtime_lab::process::Capture>>>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtCs1SSuMAdGM58_3std4sync6poison11PoisonErrorINtNtBE_5mutex10MutexGuardNtNtCshxBJAVx362N_11runtime_lab7process7CaptureEEEB1T_", scope: !140, file: !139, line: 847, type: !40, scopeLine: 847, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!810 = !{i64 3412792399468670912}
!811 = !DILocation(line: 745, column: 13, scope: !812, inlinedAt: !813)
!812 = distinct !DISubprogram(name: "drop<runtime_lab::process::Capture>", linkageName: "_RNvXsc_NtNtNtCs1SSuMAdGM58_3std4sync6poison5mutexINtB5_10MutexGuardNtNtCshxBJAVx362N_11runtime_lab7process7CaptureENtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4dropB17_", scope: !496, file: !400, line: 743, type: !40, scopeLine: 743, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!813 = distinct !DILocation(line: 847, column: 1, scope: !814, inlinedAt: !815)
!814 = distinct !DISubprogram(name: "drop_glue<std::sync::poison::mutex::MutexGuard<runtime_lab::process::Capture>>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtNtCs1SSuMAdGM58_3std4sync6poison5mutex10MutexGuardNtNtCshxBJAVx362N_11runtime_lab7process7CaptureEEB1A_", scope: !140, file: !139, line: 847, type: !40, scopeLine: 847, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!815 = distinct !DILocation(line: 847, column: 1, scope: !809)
!816 = !DILocation(line: 126, column: 13, scope: !493, inlinedAt: !817)
!817 = distinct !DILocation(line: 745, column: 30, scope: !812, inlinedAt: !813)
!818 = !DILocation(line: 3994, column: 24, scope: !444, inlinedAt: !819)
!819 = distinct !DILocation(line: 2916, column: 26, scope: !502, inlinedAt: !820)
!820 = distinct !DILocation(line: 465, column: 31, scope: !504, inlinedAt: !821)
!821 = distinct !DILocation(line: 606, column: 6, scope: !506, inlinedAt: !822)
!822 = distinct !DILocation(line: 221, column: 5, scope: !508, inlinedAt: !823)
!823 = distinct !DILocation(line: 126, column: 32, scope: !493, inlinedAt: !817)
!824 = !DILocation(line: 465, column: 12, scope: !504, inlinedAt: !821)
!825 = !DILocation(line: 477, column: 13, scope: !504, inlinedAt: !821)
!826 = !DILocation(line: 126, column: 32, scope: !493, inlinedAt: !817)
!827 = !DILocation(line: 3978, column: 24, scope: !515, inlinedAt: !828)
!828 = distinct !DILocation(line: 793, column: 13, scope: !517, inlinedAt: !829)
!829 = distinct !DILocation(line: 127, column: 25, scope: !493, inlinedAt: !817)
!830 = !DILocation(line: 126, column: 9, scope: !493, inlinedAt: !817)
!831 = !DILocation(line: 3994, column: 24, scope: !388, inlinedAt: !832)
!832 = distinct !DILocation(line: 1765, column: 18, scope: !833, inlinedAt: !834)
!833 = distinct !DISubprogram(name: "load<std::sys::pal::unix::sync::mutex::Mutex>", linkageName: "_RNvMs3_NtNtCsjIpoRzUjyHQ_4core4sync6atomicINtB5_6AtomicONtNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutex5MutexE4loadCshxBJAVx362N_11runtime_lab", scope: !51, file: !45, line: 1763, type: !52, scopeLine: 1763, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!834 = distinct !DILocation(line: 43, column: 48, scope: !835, inlinedAt: !836)
!835 = distinct !DISubprogram(name: "get_unchecked<std::sys::pal::unix::sync::mutex::Mutex>", linkageName: "_RNvMNtNtNtCs1SSuMAdGM58_3std3sys4sync8once_boxINtB2_7OnceBoxNtNtNtNtNtB6_3pal4unix4sync5mutex5MutexE13get_uncheckedCshxBJAVx362N_11runtime_lab", scope: !85, file: !84, line: 42, type: !52, scopeLine: 42, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!836 = distinct !DILocation(line: 45, column: 27, scope: !837, inlinedAt: !838)
!837 = distinct !DISubprogram(name: "unlock", linkageName: "_RNvMNtNtNtNtCs1SSuMAdGM58_3std3sys4sync5mutex7pthreadNtB2_5Mutex6unlock", scope: !395, file: !90, line: 42, type: !52, scopeLine: 42, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!838 = distinct !DILocation(line: 746, column: 29, scope: !812, inlinedAt: !813)
!839 = !DILocation(line: 45, column: 43, scope: !837, inlinedAt: !838)
!840 = !DILocation(line: 847, column: 1, scope: !809)
!841 = distinct !DISubprogram(name: "drop_glue<std::sys::sync::once_box::OnceBox<std::sys::pal::unix::sync::mutex::Mutex>>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtNtCs1SSuMAdGM58_3std3sys4sync8once_box7OnceBoxNtNtNtNtNtBI_3pal4unix4sync5mutex5MutexEECshxBJAVx362N_11runtime_lab", scope: !140, file: !139, line: 847, type: !52, scopeLine: 847, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!842 = !{i64 3280314436946794708}
!843 = !{!844}
!844 = distinct !{!844, !845, !"_RNvXs1_NtNtNtCs1SSuMAdGM58_3std3sys4sync8once_boxINtB5_7OnceBoxNtNtNtNtNtB9_3pal4unix4sync5mutex5MutexENtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4dropCshxBJAVx362N_11runtime_lab: %self"}
!845 = distinct !{!845, !"_RNvXs1_NtNtNtCs1SSuMAdGM58_3std3sys4sync8once_boxINtB5_7OnceBoxNtNtNtNtNtB9_3pal4unix4sync5mutex5MutexENtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4dropCshxBJAVx362N_11runtime_lab"}
!846 = !DILocation(line: 847, column: 1, scope: !841)
!847 = !DILocation(line: 975, column: 22, scope: !848, inlinedAt: !849)
!848 = distinct !DISubprogram(name: "replace<*mut std::sys::pal::unix::sync::mutex::Mutex>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3mem7replaceONtNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutex5MutexECshxBJAVx362N_11runtime_lab", scope: !164, file: !163, line: 961, type: !52, scopeLine: 961, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!849 = distinct !DILocation(line: 57, column: 19, scope: !850, inlinedAt: !851)
!850 = distinct !DISubprogram(name: "take<std::sys::pal::unix::sync::mutex::Mutex>", linkageName: "_RNvMNtNtNtCs1SSuMAdGM58_3std3sys4sync8once_boxINtB2_7OnceBoxNtNtNtNtNtB6_3pal4unix4sync5mutex5MutexE4takeCshxBJAVx362N_11runtime_lab", scope: !85, file: !84, line: 56, type: !52, scopeLine: 56, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!851 = distinct !DILocation(line: 81, column: 14, scope: !852, inlinedAt: !854)
!852 = distinct !DISubprogram(name: "drop<std::sys::pal::unix::sync::mutex::Mutex>", linkageName: "_RNvXs1_NtNtNtCs1SSuMAdGM58_3std3sys4sync8once_boxINtB5_7OnceBoxNtNtNtNtNtB9_3pal4unix4sync5mutex5MutexENtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4dropCshxBJAVx362N_11runtime_lab", scope: !853, file: !84, line: 80, type: !52, scopeLine: 80, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!853 = !DINamespace(name: "{impl#3}", scope: !86)
!854 = distinct !DILocation(line: 847, column: 1, scope: !841)
!855 = !DILocation(line: 976, column: 49, scope: !856, inlinedAt: !849)
!856 = distinct !DILexicalBlock(scope: !848, file: !163, line: 975, column: 9)
!857 = !DILocation(line: 38, column: 17, scope: !858, inlinedAt: !860)
!858 = !DILexicalBlockFile(scope: !859, file: !420, discriminator: 0)
!859 = distinct !DISubprogram(name: "runtime", linkageName: "_RNvNvMNtNtCsjIpoRzUjyHQ_4core3ptr9const_ptrPp7is_null7runtime", scope: !423, file: !422, line: 2623, type: !52, scopeLine: 2623, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!860 = distinct !DILocation(line: 2636, column: 9, scope: !861, inlinedAt: !864)
!861 = !DILexicalBlockFile(scope: !862, file: !422, discriminator: 0)
!862 = distinct !DILexicalBlock(scope: !863, file: !420, line: 25, column: 9)
!863 = distinct !DISubprogram(name: "is_null<std::sys::pal::unix::sync::mutex::Mutex>", linkageName: "_RNvMNtNtCsjIpoRzUjyHQ_4core3ptr9const_ptrPNtNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutex5Mutex7is_nullCshxBJAVx362N_11runtime_lab", scope: !424, file: !420, line: 22, type: !52, scopeLine: 22, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!864 = distinct !DILocation(line: 23, column: 27, scope: !865, inlinedAt: !866)
!865 = distinct !DISubprogram(name: "is_null<std::sys::pal::unix::sync::mutex::Mutex>", linkageName: "_RNvMNtNtCsjIpoRzUjyHQ_4core3ptr7mut_ptrONtNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutex5Mutex7is_nullCshxBJAVx362N_11runtime_lab", scope: !433, file: !432, line: 22, type: !52, scopeLine: 22, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!866 = distinct !DILocation(line: 58, column: 17, scope: !867, inlinedAt: !851)
!867 = distinct !DILexicalBlock(scope: !850, file: !84, line: 57, column: 9)
!868 = !DILocation(line: 847, column: 1, scope: !869, inlinedAt: !870)
!869 = distinct !DISubprogram(name: "drop_glue<core::option::Option<core::pin::Pin<alloc::boxed::Box<std::sys::pal::unix::sync::mutex::Mutex, alloc::alloc::Global>>>>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtB4_6option6OptionINtNtB4_3pin3PinINtNtCs6zY7rJBZy9D_5alloc5boxed3BoxNtNtNtNtNtNtCs1SSuMAdGM58_3std3sys3pal4unix4sync5mutex5MutexEEEECshxBJAVx362N_11runtime_lab", scope: !140, file: !139, line: 847, type: !40, scopeLine: 847, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!870 = distinct !DILocation(line: 81, column: 20, scope: !852, inlinedAt: !854)
!871 = !DILocation(line: 847, column: 1, scope: !138, inlinedAt: !872)
!872 = distinct !DILocation(line: 847, column: 1, scope: !160, inlinedAt: !873)
!873 = distinct !DILocation(line: 847, column: 1, scope: !196, inlinedAt: !874)
!874 = distinct !DILocation(line: 847, column: 1, scope: !869, inlinedAt: !870)
!875 = !DILocation(line: 175, column: 14, scope: !168, inlinedAt: !876)
!876 = distinct !DILocation(line: 321, column: 22, scope: !170, inlinedAt: !877)
!877 = distinct !DILocation(line: 436, column: 9, scope: !172, inlinedAt: !878)
!878 = distinct !DILocation(line: 554, column: 23, scope: !174, inlinedAt: !879)
!879 = distinct !DILocation(line: 2000, column: 24, scope: !176, inlinedAt: !880)
!880 = distinct !DILocation(line: 847, column: 1, scope: !160, inlinedAt: !873)
!881 = !DILocation(line: 847, column: 1, scope: !160, inlinedAt: !873)
!882 = !DILocation(line: 175, column: 14, scope: !168, inlinedAt: !883)
!883 = distinct !DILocation(line: 321, column: 22, scope: !170, inlinedAt: !884)
!884 = distinct !DILocation(line: 436, column: 9, scope: !172, inlinedAt: !885)
!885 = distinct !DILocation(line: 554, column: 23, scope: !174, inlinedAt: !886)
!886 = distinct !DILocation(line: 2000, column: 24, scope: !176, inlinedAt: !887)
!887 = distinct !DILocation(line: 847, column: 1, scope: !160, inlinedAt: !873)
!888 = distinct !DISubprogram(name: "drop_glue<tokio::signal::unix::Signal>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtNtCs3EIJ1qnJmKW_5tokio6signal4unix6SignalECshxBJAVx362N_11runtime_lab", scope: !140, file: !139, line: 847, type: !40, scopeLine: 847, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!889 = !{i64 2735012989910580218}
!890 = !DILocation(line: 847, column: 1, scope: !891, inlinedAt: !892)
!891 = distinct !DISubprogram(name: "drop_glue<alloc::boxed::Box<(dyn core::future::future::Future<Output=tokio::sync::watch::Receiver<()>> + core::marker::Send), alloc::alloc::Global>>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc5boxed3BoxDNtNtNtB4_6future6future6Futurep6OutputINtNtNtCs3EIJ1qnJmKW_5tokio4sync5watch8ReceiveruENtNtB4_6marker4SendEL_EECshxBJAVx362N_11runtime_lab", scope: !140, file: !139, line: 847, type: !40, scopeLine: 847, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!892 = distinct !DILocation(line: 1049, column: 1, scope: !893, inlinedAt: !894)
!893 = distinct !DISubprogram(name: "drop<alloc::boxed::Box<(dyn core::future::future::Future<Output=tokio::sync::watch::Receiver<()>> + core::marker::Send), alloc::alloc::Global>>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3mem4dropINtNtCs6zY7rJBZy9D_5alloc5boxed3BoxDNtNtNtB4_6future6future6Futurep6OutputINtNtNtCs3EIJ1qnJmKW_5tokio4sync5watch8ReceiveruENtNtB4_6marker4SendEL_EECshxBJAVx362N_11runtime_lab", scope: !164, file: !163, line: 1045, type: !52, scopeLine: 1045, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!894 = distinct !DILocation(line: 145, column: 13, scope: !895, inlinedAt: !900)
!895 = distinct !DISubprogram(name: "drop<tokio::sync::watch::Receiver<()>>", linkageName: "_RNvXs3_NtNtCs3EIJ1qnJmKW_5tokio6signal12reusable_boxINtB5_17ReusableBoxFutureINtNtNtB9_4sync5watch8ReceiveruEENtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4dropCshxBJAVx362N_11runtime_lab", scope: !897, file: !896, line: 143, type: !40, scopeLine: 143, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!896 = !DIFile(filename: "src/signal/reusable_box.rs", directory: "/Users/juanwang/.cargo/registry/src/mirrors.bfsu.edu.cn-eb00624c53167367/tokio-1.54.0", checksumkind: CSK_MD5, checksum: "7a60b808eaa4cb08eecc40a6e0071657")
!897 = !DINamespace(name: "{impl#5}", scope: !898)
!898 = !DINamespace(name: "reusable_box", scope: !899)
!899 = !DINamespace(name: "signal", scope: !348)
!900 = distinct !DILocation(line: 847, column: 1, scope: !901, inlinedAt: !902)
!901 = distinct !DISubprogram(name: "drop_glue<tokio::signal::reusable_box::ReusableBoxFuture<tokio::sync::watch::Receiver<()>>>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtCs3EIJ1qnJmKW_5tokio6signal12reusable_box17ReusableBoxFutureINtNtNtBI_4sync5watch8ReceiveruEEECshxBJAVx362N_11runtime_lab", scope: !140, file: !139, line: 847, type: !40, scopeLine: 847, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!902 = distinct !DILocation(line: 847, column: 1, scope: !903, inlinedAt: !904)
!903 = distinct !DISubprogram(name: "drop_glue<tokio::signal::RxFuture>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtCs3EIJ1qnJmKW_5tokio6signal8RxFutureECshxBJAVx362N_11runtime_lab", scope: !140, file: !139, line: 847, type: !40, scopeLine: 847, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!904 = distinct !DILocation(line: 847, column: 1, scope: !888)
!905 = !DILocation(line: 468, column: 14, scope: !906, inlinedAt: !907)
!906 = distinct !DISubprogram(name: "size_of_val_raw<(dyn core::future::future::Future<Output=tokio::sync::watch::Receiver<()>> + core::marker::Send)>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3mem15size_of_val_rawDNtNtNtB4_6future6future6Futurep6OutputINtNtNtCs3EIJ1qnJmKW_5tokio4sync5watch8ReceiveruENtNtB4_6marker4SendEL_ECshxBJAVx362N_11runtime_lab", scope: !164, file: !163, line: 466, type: !52, scopeLine: 466, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!907 = distinct !DILocation(line: 261, column: 43, scope: !908, inlinedAt: !913)
!908 = distinct !DISubprogram(name: "for_value_raw<(dyn core::future::future::Future<Output=tokio::sync::watch::Receiver<()>> + core::marker::Send)>", linkageName: "_RINvMNtNtCsjIpoRzUjyHQ_4core5alloc6layoutNtB3_6Layout13for_value_rawDNtNtNtB7_6future6future6Futurep6OutputINtNtNtCs3EIJ1qnJmKW_5tokio4sync5watch8ReceiveruENtNtB7_6marker4SendEL_ECshxBJAVx362N_11runtime_lab", scope: !910, file: !909, line: 259, type: !52, scopeLine: 259, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!909 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/alloc/layout.rs", directory: "", checksumkind: CSK_MD5, checksum: "044b929685d8564035fcb902806519e4")
!910 = !DINamespace(name: "Layout", scope: !911)
!911 = !DINamespace(name: "layout", scope: !912)
!912 = !DINamespace(name: "alloc", scope: !48)
!913 = distinct !DILocation(line: 1998, column: 26, scope: !914, inlinedAt: !916)
!914 = distinct !DILexicalBlock(scope: !915, file: !121, line: 1995, column: 9)
!915 = distinct !DISubprogram(name: "drop<(dyn core::future::future::Future<Output=tokio::sync::watch::Receiver<()>> + core::marker::Send), alloc::alloc::Global>", linkageName: "_RNvXs8_NtCs6zY7rJBZy9D_5alloc5boxedINtB5_3BoxDNtNtNtCsjIpoRzUjyHQ_4core6future6future6Futurep6OutputINtNtNtCs3EIJ1qnJmKW_5tokio4sync5watch8ReceiveruENtNtBO_6marker4SendEL_ENtNtNtBO_3ops4drop4Drop4dropCshxBJAVx362N_11runtime_lab", scope: !179, file: !121, line: 1992, type: !40, scopeLine: 1992, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!916 = distinct !DILocation(line: 847, column: 1, scope: !891, inlinedAt: !892)
!917 = !{i64 0, i64 -9223372036854775808}
!918 = !DILocation(line: 1999, column: 16, scope: !919, inlinedAt: !916)
!919 = distinct !DILexicalBlock(scope: !914, file: !121, line: 1998, column: 13)
!920 = !DILocation(line: 642, column: 14, scope: !921, inlinedAt: !922)
!921 = distinct !DISubprogram(name: "align_of_val_raw<(dyn core::future::future::Future<Output=tokio::sync::watch::Receiver<()>> + core::marker::Send)>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3mem16align_of_val_rawDNtNtNtB4_6future6future6Futurep6OutputINtNtNtCs3EIJ1qnJmKW_5tokio4sync5watch8ReceiveruENtNtB4_6marker4SendEL_ECshxBJAVx362N_11runtime_lab", scope: !164, file: !163, line: 640, type: !52, scopeLine: 640, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!922 = distinct !DILocation(line: 159, column: 30, scope: !923, inlinedAt: !927)
!923 = distinct !DISubprogram(name: "of_val_raw<(dyn core::future::future::Future<Output=tokio::sync::watch::Receiver<()>> + core::marker::Send)>", linkageName: "_RINvMNtNtCsjIpoRzUjyHQ_4core3mem9alignmentNtB3_9Alignment10of_val_rawDNtNtNtB7_6future6future6Futurep6OutputINtNtNtCs3EIJ1qnJmKW_5tokio4sync5watch8ReceiveruENtNtB7_6marker4SendEL_ECshxBJAVx362N_11runtime_lab", scope: !925, file: !924, line: 157, type: !52, scopeLine: 157, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!924 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/mem/alignment.rs", directory: "", checksumkind: CSK_MD5, checksum: "a4e1b46f32511e964757f2024f38c90f")
!925 = !DINamespace(name: "Alignment", scope: !926)
!926 = !DINamespace(name: "alignment", scope: !164)
!927 = distinct !DILocation(line: 261, column: 70, scope: !908, inlinedAt: !913)
!928 = !{i64 1, i64 536870913}
!929 = !DILocation(line: 175, column: 14, scope: !168, inlinedAt: !930)
!930 = distinct !DILocation(line: 321, column: 22, scope: !170, inlinedAt: !931)
!931 = distinct !DILocation(line: 436, column: 9, scope: !172, inlinedAt: !932)
!932 = distinct !DILocation(line: 554, column: 23, scope: !174, inlinedAt: !933)
!933 = distinct !DILocation(line: 2000, column: 24, scope: !919, inlinedAt: !916)
!934 = !DILocation(line: 1999, column: 13, scope: !919, inlinedAt: !916)
!935 = !DILocation(line: 468, column: 14, scope: !906, inlinedAt: !936)
!936 = distinct !DILocation(line: 261, column: 43, scope: !908, inlinedAt: !937)
!937 = distinct !DILocation(line: 1998, column: 26, scope: !914, inlinedAt: !938)
!938 = distinct !DILocation(line: 847, column: 1, scope: !891, inlinedAt: !892)
!939 = !DILocation(line: 1999, column: 16, scope: !919, inlinedAt: !938)
!940 = !DILocation(line: 642, column: 14, scope: !921, inlinedAt: !941)
!941 = distinct !DILocation(line: 159, column: 30, scope: !923, inlinedAt: !942)
!942 = distinct !DILocation(line: 261, column: 70, scope: !908, inlinedAt: !937)
!943 = !DILocation(line: 175, column: 14, scope: !168, inlinedAt: !944)
!944 = distinct !DILocation(line: 321, column: 22, scope: !170, inlinedAt: !945)
!945 = distinct !DILocation(line: 436, column: 9, scope: !172, inlinedAt: !946)
!946 = distinct !DILocation(line: 554, column: 23, scope: !174, inlinedAt: !947)
!947 = distinct !DILocation(line: 2000, column: 24, scope: !919, inlinedAt: !938)
!948 = !DILocation(line: 1999, column: 13, scope: !919, inlinedAt: !938)
!949 = !DILocation(line: 847, column: 1, scope: !888)
!950 = distinct !DISubprogram(name: "drop_glue<tokio::process::imp::ChildStdout>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtNtCs3EIJ1qnJmKW_5tokio7process3imp11ChildStdoutECshxBJAVx362N_11runtime_lab", scope: !140, file: !139, line: 847, type: !52, scopeLine: 847, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!951 = !{i64 -2190362274723223168}
!952 = !{!953}
!953 = distinct !{!953, !954, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtCs3EIJ1qnJmKW_5tokio2io12poll_evented11PollEventedNtNtNtNtCsiDZg47dpzEY_3mio3sys4unix4pipe8ReceiverEECshxBJAVx362N_11runtime_lab: %_1"}
!954 = distinct !{!954, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtCs3EIJ1qnJmKW_5tokio2io12poll_evented11PollEventedNtNtNtNtCsiDZg47dpzEY_3mio3sys4unix4pipe8ReceiverEECshxBJAVx362N_11runtime_lab"}
!955 = !DILocation(line: 847, column: 1, scope: !950)
!956 = !{!957}
!957 = distinct !{!957, !958, !"_RNvXs3_NtNtCs3EIJ1qnJmKW_5tokio2io12poll_eventedINtB5_11PollEventedNtNtNtNtCsiDZg47dpzEY_3mio3sys4unix4pipe8ReceiverENtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4dropCshxBJAVx362N_11runtime_lab: %self"}
!958 = distinct !{!958, !"_RNvXs3_NtNtCs3EIJ1qnJmKW_5tokio2io12poll_eventedINtB5_11PollEventedNtNtNtNtCsiDZg47dpzEY_3mio3sys4unix4pipe8ReceiverENtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4dropCshxBJAVx362N_11runtime_lab"}
!959 = !DILocation(line: 847, column: 1, scope: !960, inlinedAt: !961)
!960 = distinct !DISubprogram(name: "drop_glue<tokio::io::poll_evented::PollEvented<mio::sys::unix::pipe::Receiver>>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtCs3EIJ1qnJmKW_5tokio2io12poll_evented11PollEventedNtNtNtNtCsiDZg47dpzEY_3mio3sys4unix4pipe8ReceiverEECshxBJAVx362N_11runtime_lab", scope: !140, file: !139, line: 847, type: !52, scopeLine: 847, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!961 = distinct !DILocation(line: 847, column: 1, scope: !950)
!962 = !DILocation(line: 975, column: 22, scope: !963, inlinedAt: !964)
!963 = distinct !DISubprogram(name: "replace<core::option::Option<mio::sys::unix::pipe::Receiver>>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3mem7replaceINtNtB4_6option6OptionNtNtNtNtCsiDZg47dpzEY_3mio3sys4unix4pipe8ReceiverEECshxBJAVx362N_11runtime_lab", scope: !164, file: !163, line: 961, type: !52, scopeLine: 961, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!964 = distinct !DILocation(line: 1901, column: 9, scope: !965, inlinedAt: !966)
!965 = distinct !DISubprogram(name: "take<mio::sys::unix::pipe::Receiver>", linkageName: "_RNvMNtCsjIpoRzUjyHQ_4core6optionINtB2_6OptionNtNtNtNtCsiDZg47dpzEY_3mio3sys4unix4pipe8ReceiverE4takeCshxBJAVx362N_11runtime_lab", scope: !339, file: !338, line: 1899, type: !52, scopeLine: 1899, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!966 = distinct !DILocation(line: 314, column: 39, scope: !967, inlinedAt: !969)
!967 = distinct !DILexicalBlock(scope: !968, file: !343, line: 314, column: 46)
!968 = distinct !DISubprogram(name: "drop<mio::sys::unix::pipe::Receiver>", linkageName: "_RNvXs3_NtNtCs3EIJ1qnJmKW_5tokio2io12poll_eventedINtB5_11PollEventedNtNtNtNtCsiDZg47dpzEY_3mio3sys4unix4pipe8ReceiverENtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4dropCshxBJAVx362N_11runtime_lab", scope: !345, file: !343, line: 313, type: !52, scopeLine: 313, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!969 = distinct !DILocation(line: 847, column: 1, scope: !960, inlinedAt: !961)
!970 = !{!957, !953}
!971 = !DILocation(line: 976, column: 49, scope: !972, inlinedAt: !964)
!972 = distinct !DILexicalBlock(scope: !963, file: !163, line: 975, column: 9)
!973 = !DILocation(line: 314, column: 31, scope: !967, inlinedAt: !969)
!974 = !DILocation(line: 314, column: 16, scope: !967, inlinedAt: !969)
!975 = !DILocation(line: 314, column: 21, scope: !967, inlinedAt: !969)
!976 = !DILocation(line: 100, column: 14, scope: !977, inlinedAt: !978)
!977 = distinct !DISubprogram(name: "deregister<mio::sys::unix::pipe::Receiver>", linkageName: "_RINvMs0_NtNtNtCs3EIJ1qnJmKW_5tokio7runtime2io12registrationNtB6_12Registration10deregisterNtNtNtNtCsiDZg47dpzEY_3mio3sys4unix4pipe8ReceiverECshxBJAVx362N_11runtime_lab", scope: !359, file: !358, line: 99, type: !52, scopeLine: 99, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!978 = distinct !DILocation(line: 316, column: 39, scope: !967, inlinedAt: !969)
!979 = !DILocation(line: 317, column: 9, scope: !968, inlinedAt: !969)
!980 = !DILocation(line: 100, column: 41, scope: !977, inlinedAt: !978)
!981 = !DILocation(line: 325, column: 9, scope: !982, inlinedAt: !983)
!982 = distinct !DISubprogram(name: "deregister_source<mio::sys::unix::pipe::Receiver>", linkageName: "_RINvMs0_NtNtNtCs3EIJ1qnJmKW_5tokio7runtime2io6driverNtB6_6Handle17deregister_sourceNtNtNtNtCsiDZg47dpzEY_3mio3sys4unix4pipe8ReceiverECshxBJAVx362N_11runtime_lab", scope: !369, file: !368, line: 312, type: !52, scopeLine: 312, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!983 = distinct !DILocation(line: 100, column: 23, scope: !977, inlinedAt: !978)
!984 = !DILocation(line: 708, column: 16, scope: !985, inlinedAt: !986)
!985 = distinct !DISubprogram(name: "deregister<mio::sys::unix::pipe::Receiver>", linkageName: "_RINvMs1_NtCsiDZg47dpzEY_3mio4pollNtB6_8Registry10deregisterNtNtNtNtB8_3sys4unix4pipe8ReceiverECshxBJAVx362N_11runtime_lab", scope: !375, file: !374, line: 703, type: !52, scopeLine: 703, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!986 = distinct !DILocation(line: 325, column: 23, scope: !982, inlinedAt: !983)
!987 = !DILocation(line: 2177, column: 15, scope: !988, inlinedAt: !989)
!988 = distinct !DISubprogram(name: "branch<(), core::io::error::Error>", linkageName: "_RNvXsp_NtCsjIpoRzUjyHQ_4core6resultINtB5_6ResultuNtNtNtB7_2io5error5ErrorENtNtNtB7_3ops9try_trait3Try6branchCshxBJAVx362N_11runtime_lab", scope: !382, file: !381, line: 2176, type: !52, scopeLine: 2176, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!989 = distinct !DILocation(line: 325, column: 9, scope: !982, inlinedAt: !983)
!990 = !DILocation(line: 2177, column: 9, scope: !988, inlinedAt: !989)
!991 = !DILocation(line: 327, column: 12, scope: !982, inlinedAt: !983)
!992 = !DILocation(line: 3995, column: 24, scope: !388, inlinedAt: !993)
!993 = distinct !DILocation(line: 1765, column: 18, scope: !390, inlinedAt: !994)
!994 = distinct !DILocation(line: 48, column: 28, scope: !392, inlinedAt: !995)
!995 = distinct !DILocation(line: 22, column: 18, scope: !394, inlinedAt: !996)
!996 = distinct !DILocation(line: 36, column: 23, scope: !397, inlinedAt: !997)
!997 = distinct !DILocation(line: 492, column: 24, scope: !399, inlinedAt: !998)
!998 = distinct !DILocation(line: 22, column: 22, scope: !999, inlinedAt: !1000)
!999 = distinct !DISubprogram(name: "lock<tokio::runtime::io::registration_set::Synced>", linkageName: "_RNvMNtNtNtCs3EIJ1qnJmKW_5tokio4loom3std5mutexINtB2_5MutexNtNtNtNtB8_7runtime2io16registration_set6SyncedE4lockCshxBJAVx362N_11runtime_lab", scope: !407, file: !406, line: 21, type: !52, scopeLine: 21, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!1000 = distinct !DILocation(line: 329, column: 42, scope: !982, inlinedAt: !983)
!1001 = !{!1002, !1004, !1006}
!1002 = distinct !{!1002, !1003, !"_RNvMs5_NtNtNtCs1SSuMAdGM58_3std4sync6poison5mutexINtB5_5MutexNtNtNtNtCs3EIJ1qnJmKW_5tokio7runtime2io16registration_set6SyncedE4lockCshxBJAVx362N_11runtime_lab: %_0"}
!1003 = distinct !{!1003, !"_RNvMs5_NtNtNtCs1SSuMAdGM58_3std4sync6poison5mutexINtB5_5MutexNtNtNtNtCs3EIJ1qnJmKW_5tokio7runtime2io16registration_set6SyncedE4lockCshxBJAVx362N_11runtime_lab"}
!1004 = distinct !{!1004, !1005, !"_RINvMs0_NtNtNtCs3EIJ1qnJmKW_5tokio7runtime2io6driverNtB6_6Handle17deregister_sourceNtNtNtNtCsiDZg47dpzEY_3mio3sys4unix4pipe8ReceiverECshxBJAVx362N_11runtime_lab: %registration"}
!1005 = distinct !{!1005, !"_RINvMs0_NtNtNtCs3EIJ1qnJmKW_5tokio7runtime2io6driverNtB6_6Handle17deregister_sourceNtNtNtNtCsiDZg47dpzEY_3mio3sys4unix4pipe8ReceiverECshxBJAVx362N_11runtime_lab"}
!1006 = distinct !{!1006, !1005, !"_RINvMs0_NtNtNtCs3EIJ1qnJmKW_5tokio7runtime2io6driverNtB6_6Handle17deregister_sourceNtNtNtNtCsiDZg47dpzEY_3mio3sys4unix4pipe8ReceiverECshxBJAVx362N_11runtime_lab: %source"}
!1007 = !DILocation(line: 38, column: 17, scope: !419, inlinedAt: !1008)
!1008 = distinct !DILocation(line: 2636, column: 9, scope: !427, inlinedAt: !1009)
!1009 = distinct !DILocation(line: 23, column: 27, scope: !431, inlinedAt: !1010)
!1010 = distinct !DILocation(line: 265, column: 17, scope: !436, inlinedAt: !1011)
!1011 = distinct !DILocation(line: 49, column: 28, scope: !438, inlinedAt: !995)
!1012 = !DILocation(line: 265, column: 12, scope: !436, inlinedAt: !1011)
!1013 = !DILocation(line: 51, column: 26, scope: !438, inlinedAt: !995)
!1014 = !DILocation(line: 0, scope: !438, inlinedAt: !995)
!1015 = !DILocation(line: 36, column: 29, scope: !397, inlinedAt: !997)
!1016 = !DILocation(line: 3994, column: 24, scope: !444, inlinedAt: !1017)
!1017 = distinct !DILocation(line: 2916, column: 26, scope: !446, inlinedAt: !1018)
!1018 = distinct !DILocation(line: 465, column: 31, scope: !448, inlinedAt: !1019)
!1019 = distinct !DILocation(line: 606, column: 6, scope: !453, inlinedAt: !1020)
!1020 = distinct !DILocation(line: 221, column: 5, scope: !455, inlinedAt: !1021)
!1021 = distinct !DILocation(line: 118, column: 24, scope: !460, inlinedAt: !1022)
!1022 = distinct !DILocation(line: 720, column: 40, scope: !464, inlinedAt: !1023)
!1023 = distinct !DILocation(line: 493, column: 13, scope: !399, inlinedAt: !998)
!1024 = !{!1002, !1004, !1006, !957, !953}
!1025 = !DILocation(line: 465, column: 12, scope: !448, inlinedAt: !1019)
!1026 = !DILocation(line: 477, column: 13, scope: !448, inlinedAt: !1019)
!1027 = !DILocation(line: 606, column: 5, scope: !453, inlinedAt: !1020)
!1028 = !DILocation(line: 720, column: 28, scope: !464, inlinedAt: !1023)
!1029 = !DILocation(line: 3994, column: 24, scope: !473, inlinedAt: !1030)
!1030 = distinct !DILocation(line: 762, column: 18, scope: !475, inlinedAt: !1031)
!1031 = distinct !DILocation(line: 138, column: 21, scope: !477, inlinedAt: !1032)
!1032 = distinct !DILocation(line: 120, column: 17, scope: !479, inlinedAt: !1022)
!1033 = !DILocation(line: 2437, column: 9, scope: !1034, inlinedAt: !1035)
!1034 = distinct !DISubprogram(name: "get<tokio::runtime::io::registration_set::Synced>", linkageName: "_RNvMsX_NtCsjIpoRzUjyHQ_4core4cellINtB5_10UnsafeCellNtNtNtNtCs3EIJ1qnJmKW_5tokio7runtime2io16registration_set6SyncedE3getCshxBJAVx362N_11runtime_lab", scope: !483, file: !482, line: 2434, type: !52, scopeLine: 2434, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!1035 = distinct !DILocation(line: 736, column: 39, scope: !1036, inlinedAt: !1037)
!1036 = distinct !DISubprogram(name: "deref_mut<tokio::runtime::io::registration_set::Synced>", linkageName: "_RNvXsb_NtNtNtCs1SSuMAdGM58_3std4sync6poison5mutexINtB5_10MutexGuardNtNtNtNtCs3EIJ1qnJmKW_5tokio7runtime2io16registration_set6SyncedENtNtNtCsjIpoRzUjyHQ_4core3ops5deref8DerefMut9deref_mutCshxBJAVx362N_11runtime_lab", scope: !487, file: !400, line: 735, type: !52, scopeLine: 735, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!1037 = distinct !DILocation(line: 329, column: 25, scope: !982, inlinedAt: !983)
!1038 = !DILocation(line: 329, column: 14, scope: !982, inlinedAt: !983)
!1039 = !DILocation(line: 120, scope: !479, inlinedAt: !1022)
!1040 = !DILocation(line: 329, column: 62, scope: !982, inlinedAt: !983)
!1041 = !DILocation(line: 126, column: 13, scope: !493, inlinedAt: !1042)
!1042 = distinct !DILocation(line: 745, column: 30, scope: !495, inlinedAt: !1043)
!1043 = distinct !DILocation(line: 847, column: 1, scope: !498, inlinedAt: !1044)
!1044 = distinct !DILocation(line: 329, column: 62, scope: !982, inlinedAt: !983)
!1045 = !DILocation(line: 3994, column: 24, scope: !444, inlinedAt: !1046)
!1046 = distinct !DILocation(line: 2916, column: 26, scope: !502, inlinedAt: !1047)
!1047 = distinct !DILocation(line: 465, column: 31, scope: !504, inlinedAt: !1048)
!1048 = distinct !DILocation(line: 606, column: 6, scope: !506, inlinedAt: !1049)
!1049 = distinct !DILocation(line: 221, column: 5, scope: !508, inlinedAt: !1050)
!1050 = distinct !DILocation(line: 126, column: 32, scope: !493, inlinedAt: !1042)
!1051 = !{!1004, !1006, !957, !953}
!1052 = !DILocation(line: 465, column: 12, scope: !504, inlinedAt: !1048)
!1053 = !DILocation(line: 477, column: 13, scope: !504, inlinedAt: !1048)
!1054 = !DILocation(line: 126, column: 32, scope: !493, inlinedAt: !1042)
!1055 = !DILocation(line: 3978, column: 24, scope: !515, inlinedAt: !1056)
!1056 = distinct !DILocation(line: 793, column: 13, scope: !517, inlinedAt: !1057)
!1057 = distinct !DILocation(line: 127, column: 25, scope: !493, inlinedAt: !1042)
!1058 = !{!1004, !1006}
!1059 = !DILocation(line: 126, column: 9, scope: !493, inlinedAt: !1042)
!1060 = !DILocation(line: 3994, column: 24, scope: !388, inlinedAt: !1061)
!1061 = distinct !DILocation(line: 1765, column: 18, scope: !523, inlinedAt: !1062)
!1062 = distinct !DILocation(line: 43, column: 48, scope: !525, inlinedAt: !1063)
!1063 = distinct !DILocation(line: 45, column: 27, scope: !527, inlinedAt: !1064)
!1064 = distinct !DILocation(line: 746, column: 29, scope: !495, inlinedAt: !1043)
!1065 = !DILocation(line: 45, column: 43, scope: !527, inlinedAt: !1064)
!1066 = !DILocation(line: 126, column: 13, scope: !493, inlinedAt: !1067)
!1067 = distinct !DILocation(line: 745, column: 30, scope: !495, inlinedAt: !1068)
!1068 = distinct !DILocation(line: 847, column: 1, scope: !498, inlinedAt: !1069)
!1069 = distinct !DILocation(line: 329, column: 62, scope: !982, inlinedAt: !983)
!1070 = !DILocation(line: 3994, column: 24, scope: !444, inlinedAt: !1071)
!1071 = distinct !DILocation(line: 2916, column: 26, scope: !502, inlinedAt: !1072)
!1072 = distinct !DILocation(line: 465, column: 31, scope: !504, inlinedAt: !1073)
!1073 = distinct !DILocation(line: 606, column: 6, scope: !506, inlinedAt: !1074)
!1074 = distinct !DILocation(line: 221, column: 5, scope: !508, inlinedAt: !1075)
!1075 = distinct !DILocation(line: 126, column: 32, scope: !493, inlinedAt: !1067)
!1076 = !DILocation(line: 465, column: 12, scope: !504, inlinedAt: !1073)
!1077 = !DILocation(line: 477, column: 13, scope: !504, inlinedAt: !1073)
!1078 = !DILocation(line: 126, column: 32, scope: !493, inlinedAt: !1067)
!1079 = !DILocation(line: 3978, column: 24, scope: !515, inlinedAt: !1080)
!1080 = distinct !DILocation(line: 793, column: 13, scope: !517, inlinedAt: !1081)
!1081 = distinct !DILocation(line: 127, column: 25, scope: !493, inlinedAt: !1067)
!1082 = !DILocation(line: 126, column: 9, scope: !493, inlinedAt: !1067)
!1083 = !DILocation(line: 3994, column: 24, scope: !388, inlinedAt: !1084)
!1084 = distinct !DILocation(line: 1765, column: 18, scope: !523, inlinedAt: !1085)
!1085 = distinct !DILocation(line: 43, column: 48, scope: !525, inlinedAt: !1086)
!1086 = distinct !DILocation(line: 45, column: 27, scope: !527, inlinedAt: !1087)
!1087 = distinct !DILocation(line: 746, column: 29, scope: !495, inlinedAt: !1068)
!1088 = !DILocation(line: 45, column: 43, scope: !527, inlinedAt: !1087)
!1089 = !DILocation(line: 331, column: 18, scope: !982, inlinedAt: !983)
!1090 = !DILocation(line: 312, column: 5, scope: !982, inlinedAt: !983)
!1091 = !DILocation(line: 235, column: 21, scope: !556, inlinedAt: !1092)
!1092 = distinct !DILocation(line: 847, column: 1, scope: !563, inlinedAt: !1093)
!1093 = distinct !DILocation(line: 847, column: 1, scope: !565, inlinedAt: !1094)
!1094 = distinct !DILocation(line: 847, column: 1, scope: !567, inlinedAt: !1095)
!1095 = distinct !DILocation(line: 316, column: 58, scope: !967, inlinedAt: !969)
!1096 = !DILocation(line: 150, column: 18, scope: !570, inlinedAt: !1097)
!1097 = distinct !DILocation(line: 251, column: 29, scope: !572, inlinedAt: !1098)
!1098 = distinct !DILocation(line: 235, column: 21, scope: !556, inlinedAt: !1092)
!1099 = !DILocation(line: 252, column: 11, scope: !575, inlinedAt: !1098)
!1100 = !DILocation(line: 252, column: 5, scope: !575, inlinedAt: !1098)
!1101 = !DILocation(line: 1074, column: 28, scope: !579, inlinedAt: !1102)
!1102 = distinct !DILocation(line: 259, column: 24, scope: !583, inlinedAt: !1098)
!1103 = !DILocation(line: 1063, column: 15, scope: !585, inlinedAt: !1104)
!1104 = distinct !DILocation(line: 259, column: 56, scope: !583, inlinedAt: !1098)
!1105 = !DILocation(line: 1063, column: 9, scope: !585, inlinedAt: !1104)
!1106 = !DILocation(line: 270, column: 9, scope: !575, inlinedAt: !1098)
!1107 = !DILocation(line: 474, column: 18, scope: !590, inlinedAt: !1108)
!1108 = distinct !DILocation(line: 1211, column: 14, scope: !592, inlinedAt: !1109)
!1109 = distinct !DILocation(line: 1228, column: 27, scope: !594, inlinedAt: !1110)
!1110 = distinct !DILocation(line: 279, column: 39, scope: !575, inlinedAt: !1098)
!1111 = !DILocation(line: 247, column: 13, scope: !597, inlinedAt: !1112)
!1112 = distinct !DILocation(line: 236, column: 39, scope: !602, inlinedAt: !1113)
!1113 = distinct !DILocation(line: 280, column: 31, scope: !605, inlinedAt: !1098)
!1114 = !DILocation(line: 280, column: 13, scope: !605, inlinedAt: !1098)
!1115 = !{!1116}
!1116 = distinct !{!1116, !1117, !"_RINvNtNtNtCsjIpoRzUjyHQ_4core2io5error4repr11decode_reprNtB4_11CustomOwnerNCNvXs1_B2_NtB2_4ReprNtNtNtB8_3ops4drop4Drop4drop0ECshxBJAVx362N_11runtime_lab: %_0"}
!1117 = distinct !{!1117, !"_RINvNtNtNtCsjIpoRzUjyHQ_4core2io5error4repr11decode_reprNtB4_11CustomOwnerNCNvXs1_B2_NtB2_4ReprNtNtNtB8_3ops4drop4Drop4drop0ECshxBJAVx362N_11runtime_lab"}
!1118 = !DILocation(line: 0, scope: !575, inlinedAt: !1098)
!1119 = !DILocation(line: 847, column: 1, scope: !612, inlinedAt: !1120)
!1120 = distinct !DILocation(line: 847, column: 1, scope: !614, inlinedAt: !1121)
!1121 = distinct !DILocation(line: 237, column: 15, scope: !556, inlinedAt: !1092)
!1122 = !DILocation(line: 237, column: 15, scope: !556, inlinedAt: !1092)
!1123 = !DILocation(line: 847, column: 1, scope: !567, inlinedAt: !1095)
!1124 = !DILocation(line: 220, column: 25, scope: !278, inlinedAt: !1125)
!1125 = distinct !DILocation(line: 847, column: 1, scope: !285, inlinedAt: !1126)
!1126 = distinct !DILocation(line: 847, column: 1, scope: !287, inlinedAt: !1127)
!1127 = distinct !DILocation(line: 847, column: 1, scope: !623, inlinedAt: !1128)
!1128 = distinct !DILocation(line: 847, column: 1, scope: !625, inlinedAt: !1129)
!1129 = distinct !DILocation(line: 847, column: 1, scope: !627, inlinedAt: !1130)
!1130 = distinct !DILocation(line: 847, column: 1, scope: !1131, inlinedAt: !1132)
!1131 = distinct !DISubprogram(name: "drop_glue<mio::sys::unix::pipe::Receiver>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtNtNtCsiDZg47dpzEY_3mio3sys4unix4pipe8ReceiverECshxBJAVx362N_11runtime_lab", scope: !140, file: !139, line: 847, type: !40, scopeLine: 847, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!1132 = distinct !DILocation(line: 317, column: 9, scope: !968, inlinedAt: !969)
!1133 = !DILocation(line: 847, column: 1, scope: !1134, inlinedAt: !1135)
!1134 = distinct !DISubprogram(name: "drop_glue<core::option::Option<mio::sys::unix::pipe::Receiver>>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtB4_6option6OptionNtNtNtNtCsiDZg47dpzEY_3mio3sys4unix4pipe8ReceiverEECshxBJAVx362N_11runtime_lab", scope: !140, file: !139, line: 847, type: !40, scopeLine: 847, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!1135 = distinct !DILocation(line: 847, column: 1, scope: !960, inlinedAt: !961)
!1136 = !DILocation(line: 220, column: 25, scope: !278, inlinedAt: !1137)
!1137 = distinct !DILocation(line: 847, column: 1, scope: !285, inlinedAt: !1138)
!1138 = distinct !DILocation(line: 847, column: 1, scope: !287, inlinedAt: !1139)
!1139 = distinct !DILocation(line: 847, column: 1, scope: !623, inlinedAt: !1140)
!1140 = distinct !DILocation(line: 847, column: 1, scope: !625, inlinedAt: !1141)
!1141 = distinct !DILocation(line: 847, column: 1, scope: !627, inlinedAt: !1142)
!1142 = distinct !DILocation(line: 847, column: 1, scope: !1131, inlinedAt: !1143)
!1143 = distinct !DILocation(line: 847, column: 1, scope: !1134, inlinedAt: !1135)
!1144 = !DILocation(line: 220, column: 25, scope: !278, inlinedAt: !1145)
!1145 = distinct !DILocation(line: 847, column: 1, scope: !285, inlinedAt: !1146)
!1146 = distinct !DILocation(line: 847, column: 1, scope: !287, inlinedAt: !1147)
!1147 = distinct !DILocation(line: 847, column: 1, scope: !623, inlinedAt: !1148)
!1148 = distinct !DILocation(line: 847, column: 1, scope: !625, inlinedAt: !1149)
!1149 = distinct !DILocation(line: 847, column: 1, scope: !627, inlinedAt: !1150)
!1150 = distinct !DILocation(line: 847, column: 1, scope: !1131, inlinedAt: !1151)
!1151 = distinct !DILocation(line: 317, column: 9, scope: !968, inlinedAt: !969)
!1152 = !DILocation(line: 847, column: 1, scope: !1134, inlinedAt: !1153)
!1153 = distinct !DILocation(line: 847, column: 1, scope: !960, inlinedAt: !961)
!1154 = !DILocation(line: 220, column: 25, scope: !278, inlinedAt: !1155)
!1155 = distinct !DILocation(line: 847, column: 1, scope: !285, inlinedAt: !1156)
!1156 = distinct !DILocation(line: 847, column: 1, scope: !287, inlinedAt: !1157)
!1157 = distinct !DILocation(line: 847, column: 1, scope: !623, inlinedAt: !1158)
!1158 = distinct !DILocation(line: 847, column: 1, scope: !625, inlinedAt: !1159)
!1159 = distinct !DILocation(line: 847, column: 1, scope: !627, inlinedAt: !1160)
!1160 = distinct !DILocation(line: 847, column: 1, scope: !1131, inlinedAt: !1161)
!1161 = distinct !DILocation(line: 847, column: 1, scope: !1134, inlinedAt: !1153)
!1162 = distinct !DISubprogram(name: "drop_glue<tokio::process::imp::Child>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtNtCs3EIJ1qnJmKW_5tokio7process3imp5ChildECshxBJAVx362N_11runtime_lab", scope: !140, file: !139, line: 847, type: !52, scopeLine: 847, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!1163 = !{i64 2896259912816447259}
!1164 = !{!1165}
!1165 = distinct !{!1165, !1166, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtNtCs3EIJ1qnJmKW_5tokio7process3imp4reap6ReaperNtNtCs1SSuMAdGM58_3std7process5ChildNtBG_17GlobalOrphanQueueNtNtNtBK_6signal4unix6SignalEECshxBJAVx362N_11runtime_lab: %_1"}
!1166 = distinct !{!1166, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtNtCs3EIJ1qnJmKW_5tokio7process3imp4reap6ReaperNtNtCs1SSuMAdGM58_3std7process5ChildNtBG_17GlobalOrphanQueueNtNtNtBK_6signal4unix6SignalEECshxBJAVx362N_11runtime_lab"}
!1167 = !DILocation(line: 847, column: 1, scope: !1162)
!1168 = !{!1169}
!1169 = distinct !{!1169, !1170, !"_RNvXs2_NtNtNtCs3EIJ1qnJmKW_5tokio7process3imp4reapINtB5_6ReaperNtNtCs1SSuMAdGM58_3std7process5ChildNtB7_17GlobalOrphanQueueNtNtNtBb_6signal4unix6SignalENtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4dropCshxBJAVx362N_11runtime_lab: %self"}
!1170 = distinct !{!1170, !"_RNvXs2_NtNtNtCs3EIJ1qnJmKW_5tokio7process3imp4reapINtB5_6ReaperNtNtCs1SSuMAdGM58_3std7process5ChildNtB7_17GlobalOrphanQueueNtNtNtBb_6signal4unix6SignalENtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4dropCshxBJAVx362N_11runtime_lab"}
!1171 = !DILocation(line: 847, column: 1, scope: !1172, inlinedAt: !1173)
!1172 = distinct !DISubprogram(name: "drop_glue<tokio::process::imp::reap::Reaper<std::process::Child, tokio::process::imp::GlobalOrphanQueue, tokio::signal::unix::Signal>>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtNtCs3EIJ1qnJmKW_5tokio7process3imp4reap6ReaperNtNtCs1SSuMAdGM58_3std7process5ChildNtBG_17GlobalOrphanQueueNtNtNtBK_6signal4unix6SignalEECshxBJAVx362N_11runtime_lab", scope: !140, file: !139, line: 847, type: !52, scopeLine: 847, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!1173 = distinct !DILocation(line: 847, column: 1, scope: !1162)
!1174 = !DILocation(line: 123, column: 30, scope: !1175, inlinedAt: !1181)
!1175 = distinct !DILexicalBlock(scope: !1177, file: !1176, line: 123, column: 58)
!1176 = !DIFile(filename: "src/process/unix/reap.rs", directory: "/Users/juanwang/.cargo/registry/src/mirrors.bfsu.edu.cn-eb00624c53167367/tokio-1.54.0", checksumkind: CSK_MD5, checksum: "b69ae1158d0b606ead9f26de28758cd7")
!1177 = distinct !DISubprogram(name: "drop<std::process::Child, tokio::process::imp::GlobalOrphanQueue, tokio::signal::unix::Signal>", linkageName: "_RNvXs2_NtNtNtCs3EIJ1qnJmKW_5tokio7process3imp4reapINtB5_6ReaperNtNtCs1SSuMAdGM58_3std7process5ChildNtB7_17GlobalOrphanQueueNtNtNtBb_6signal4unix6SignalENtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4dropCshxBJAVx362N_11runtime_lab", scope: !1178, file: !1176, line: 122, type: !52, scopeLine: 122, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!1178 = !DINamespace(name: "{impl#4}", scope: !1179)
!1179 = !DINamespace(name: "reap", scope: !1180)
!1180 = !DINamespace(name: "imp", scope: !692)
!1181 = distinct !DILocation(line: 847, column: 1, scope: !1172, inlinedAt: !1173)
!1182 = !{!1169, !1165}
!1183 = !DILocation(line: 765, column: 15, scope: !1184, inlinedAt: !1185)
!1184 = distinct !DISubprogram(name: "as_mut<std::process::Child>", linkageName: "_RNvMNtCsjIpoRzUjyHQ_4core6optionINtB2_6OptionNtNtCs1SSuMAdGM58_3std7process5ChildE6as_mutCshxBJAVx362N_11runtime_lab", scope: !339, file: !338, line: 764, type: !52, scopeLine: 764, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!1185 = distinct !DILocation(line: 56, column: 20, scope: !1186, inlinedAt: !1188)
!1186 = distinct !DISubprogram(name: "inner_mut<std::process::Child, tokio::process::imp::GlobalOrphanQueue, tokio::signal::unix::Signal>", linkageName: "_RNvMs_NtNtNtCs3EIJ1qnJmKW_5tokio7process3imp4reapINtB4_6ReaperNtNtCs1SSuMAdGM58_3std7process5ChildNtB6_17GlobalOrphanQueueNtNtNtBa_6signal4unix6SignalE9inner_mutCshxBJAVx362N_11runtime_lab", scope: !1187, file: !1176, line: 55, type: !52, scopeLine: 55, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!1187 = !DINamespace(name: "Reaper", scope: !1179)
!1188 = distinct !DILocation(line: 123, column: 35, scope: !1175, inlinedAt: !1181)
!1189 = !DILocation(line: 765, column: 9, scope: !1184, inlinedAt: !1185)
!1190 = !DILocation(line: 123, column: 47, scope: !1175, inlinedAt: !1181)
!1191 = !{i32 0, i32 2}
!1192 = !DILocation(line: 123, column: 16, scope: !1175, inlinedAt: !1181)
!1193 = !DILocation(line: 969, column: 21, scope: !1194, inlinedAt: !1195)
!1194 = distinct !DISubprogram(name: "expect<&mut std::process::Child>", linkageName: "_RNvMNtCsjIpoRzUjyHQ_4core6optionINtB2_6OptionQNtNtCs1SSuMAdGM58_3std7process5ChildE6expectCshxBJAVx362N_11runtime_lab", scope: !339, file: !338, line: 966, type: !52, scopeLine: 966, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!1195 = distinct !DILocation(line: 56, column: 29, scope: !1186, inlinedAt: !1188)
!1196 = !DILocation(line: 125, column: 9, scope: !1177, inlinedAt: !1181)
!1197 = !DILocation(line: 847, column: 1, scope: !1198, inlinedAt: !1199)
!1198 = distinct !DISubprogram(name: "drop_glue<core::result::Result<core::option::Option<std::process::ExitStatus>, core::io::error::Error>>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtB4_6result6ResultINtNtB4_6option6OptionNtNtCs1SSuMAdGM58_3std7process10ExitStatusENtNtNtB4_2io5error5ErrorEECshxBJAVx362N_11runtime_lab", scope: !140, file: !139, line: 847, type: !40, scopeLine: 847, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!1199 = distinct !DILocation(line: 125, column: 9, scope: !1177, inlinedAt: !1181)
!1200 = !DILocation(line: 235, column: 21, scope: !556, inlinedAt: !1201)
!1201 = distinct !DILocation(line: 847, column: 1, scope: !563, inlinedAt: !1202)
!1202 = distinct !DILocation(line: 847, column: 1, scope: !565, inlinedAt: !1203)
!1203 = distinct !DILocation(line: 847, column: 1, scope: !1198, inlinedAt: !1199)
!1204 = !DILocation(line: 150, column: 18, scope: !570, inlinedAt: !1205)
!1205 = distinct !DILocation(line: 251, column: 29, scope: !572, inlinedAt: !1206)
!1206 = distinct !DILocation(line: 235, column: 21, scope: !556, inlinedAt: !1201)
!1207 = !DILocation(line: 252, column: 11, scope: !575, inlinedAt: !1206)
!1208 = !DILocation(line: 252, column: 5, scope: !575, inlinedAt: !1206)
!1209 = !DILocation(line: 1074, column: 28, scope: !579, inlinedAt: !1210)
!1210 = distinct !DILocation(line: 259, column: 24, scope: !583, inlinedAt: !1206)
!1211 = !DILocation(line: 1063, column: 15, scope: !585, inlinedAt: !1212)
!1212 = distinct !DILocation(line: 259, column: 56, scope: !583, inlinedAt: !1206)
!1213 = !DILocation(line: 1063, column: 9, scope: !585, inlinedAt: !1212)
!1214 = !DILocation(line: 270, column: 9, scope: !575, inlinedAt: !1206)
!1215 = !DILocation(line: 474, column: 18, scope: !590, inlinedAt: !1216)
!1216 = distinct !DILocation(line: 1211, column: 14, scope: !592, inlinedAt: !1217)
!1217 = distinct !DILocation(line: 1228, column: 27, scope: !594, inlinedAt: !1218)
!1218 = distinct !DILocation(line: 279, column: 39, scope: !575, inlinedAt: !1206)
!1219 = !DILocation(line: 247, column: 13, scope: !597, inlinedAt: !1220)
!1220 = distinct !DILocation(line: 236, column: 39, scope: !602, inlinedAt: !1221)
!1221 = distinct !DILocation(line: 280, column: 31, scope: !605, inlinedAt: !1206)
!1222 = !DILocation(line: 280, column: 13, scope: !605, inlinedAt: !1206)
!1223 = !{!1224}
!1224 = distinct !{!1224, !1225, !"_RINvNtNtNtCsjIpoRzUjyHQ_4core2io5error4repr11decode_reprNtB4_11CustomOwnerNCNvXs1_B2_NtB2_4ReprNtNtNtB8_3ops4drop4Drop4drop0ECshxBJAVx362N_11runtime_lab: %_0"}
!1225 = distinct !{!1225, !"_RINvNtNtNtCsjIpoRzUjyHQ_4core2io5error4repr11decode_reprNtB4_11CustomOwnerNCNvXs1_B2_NtB2_4ReprNtNtNtB8_3ops4drop4Drop4drop0ECshxBJAVx362N_11runtime_lab"}
!1226 = !DILocation(line: 0, scope: !575, inlinedAt: !1206)
!1227 = !DILocation(line: 847, column: 1, scope: !612, inlinedAt: !1228)
!1228 = distinct !DILocation(line: 847, column: 1, scope: !614, inlinedAt: !1229)
!1229 = distinct !DILocation(line: 237, column: 15, scope: !556, inlinedAt: !1201)
!1230 = !DILocation(line: 237, column: 15, scope: !556, inlinedAt: !1201)
!1231 = !DILocation(line: 127, column: 13, scope: !1177, inlinedAt: !1181)
!1232 = !DILocation(line: 975, column: 22, scope: !1233, inlinedAt: !1234)
!1233 = distinct !DISubprogram(name: "replace<core::option::Option<std::process::Child>>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3mem7replaceINtNtB4_6option6OptionNtNtCs1SSuMAdGM58_3std7process5ChildEECshxBJAVx362N_11runtime_lab", scope: !164, file: !163, line: 961, type: !52, scopeLine: 961, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!1234 = distinct !DILocation(line: 1901, column: 9, scope: !1235, inlinedAt: !1236)
!1235 = distinct !DISubprogram(name: "take<std::process::Child>", linkageName: "_RNvMNtCsjIpoRzUjyHQ_4core6optionINtB2_6OptionNtNtCs1SSuMAdGM58_3std7process5ChildE4takeCshxBJAVx362N_11runtime_lab", scope: !339, file: !338, line: 1899, type: !52, scopeLine: 1899, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!1236 = distinct !DILocation(line: 127, column: 33, scope: !1177, inlinedAt: !1181)
!1237 = !DILocation(line: 976, column: 49, scope: !1238, inlinedAt: !1234)
!1238 = distinct !DILexicalBlock(scope: !1233, file: !163, line: 975, column: 9)
!1239 = !DILocation(line: 1012, column: 15, scope: !1240, inlinedAt: !1241)
!1240 = distinct !DISubprogram(name: "unwrap<std::process::Child>", linkageName: "_RNvMNtCsjIpoRzUjyHQ_4core6optionINtB2_6OptionNtNtCs1SSuMAdGM58_3std7process5ChildE6unwrapCshxBJAVx362N_11runtime_lab", scope: !339, file: !338, line: 1011, type: !52, scopeLine: 1011, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!1241 = distinct !DILocation(line: 127, column: 40, scope: !1177, inlinedAt: !1181)
!1242 = !DILocation(line: 1012, column: 9, scope: !1240, inlinedAt: !1241)
!1243 = !DILocation(line: 129, column: 6, scope: !1177, inlinedAt: !1181)
!1244 = !DILocation(line: 1013, column: 18, scope: !1240, inlinedAt: !1241)
!1245 = !DILocation(line: 128, column: 9, scope: !1246, inlinedAt: !1181)
!1246 = distinct !DILexicalBlock(scope: !1177, file: !1176, line: 127, column: 9)
!1247 = !DILocation(line: 128, column: 27, scope: !1246, inlinedAt: !1181)
!1248 = !DILocation(line: 129, column: 5, scope: !1177, inlinedAt: !1181)
!1249 = !DILocation(line: 1014, column: 21, scope: !1240, inlinedAt: !1241)
!1250 = !{i64 8}
!1251 = !{!1252}
!1252 = distinct !{!1252, !1253, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtB4_6option6OptionNtNtCs1SSuMAdGM58_3std7process5ChildEECshxBJAVx362N_11runtime_lab: %_1"}
!1253 = distinct !{!1253, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtB4_6option6OptionNtNtCs1SSuMAdGM58_3std7process5ChildEECshxBJAVx362N_11runtime_lab"}
!1254 = !DILocation(line: 847, column: 1, scope: !264, inlinedAt: !1255)
!1255 = distinct !DILocation(line: 847, column: 1, scope: !1172, inlinedAt: !1173)
!1256 = !{!1252, !1165}
!1257 = !{!1258}
!1258 = distinct !{!1258, !1259, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtCs1SSuMAdGM58_3std7process5ChildECshxBJAVx362N_11runtime_lab: %_1"}
!1259 = distinct !{!1259, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtCs1SSuMAdGM58_3std7process5ChildECshxBJAVx362N_11runtime_lab"}
!1260 = !DILocation(line: 847, column: 1, scope: !272, inlinedAt: !1261)
!1261 = distinct !DILocation(line: 847, column: 1, scope: !264, inlinedAt: !1255)
!1262 = !{!1258, !1252, !1165}
!1263 = !DILocation(line: 847, column: 1, scope: !275, inlinedAt: !1264)
!1264 = distinct !DILocation(line: 847, column: 1, scope: !272, inlinedAt: !1261)
!1265 = !DILocation(line: 220, column: 25, scope: !278, inlinedAt: !1266)
!1266 = distinct !DILocation(line: 847, column: 1, scope: !285, inlinedAt: !1267)
!1267 = distinct !DILocation(line: 847, column: 1, scope: !287, inlinedAt: !1268)
!1268 = distinct !DILocation(line: 847, column: 1, scope: !289, inlinedAt: !1269)
!1269 = distinct !DILocation(line: 847, column: 1, scope: !275, inlinedAt: !1264)
!1270 = !{!1258, !1252}
!1271 = !DILocation(line: 847, column: 1, scope: !292, inlinedAt: !1272)
!1272 = distinct !DILocation(line: 847, column: 1, scope: !272, inlinedAt: !1261)
!1273 = !DILocation(line: 220, column: 25, scope: !278, inlinedAt: !1274)
!1274 = distinct !DILocation(line: 847, column: 1, scope: !285, inlinedAt: !1275)
!1275 = distinct !DILocation(line: 847, column: 1, scope: !287, inlinedAt: !1276)
!1276 = distinct !DILocation(line: 847, column: 1, scope: !298, inlinedAt: !1277)
!1277 = distinct !DILocation(line: 847, column: 1, scope: !292, inlinedAt: !1272)
!1278 = !DILocation(line: 847, column: 1, scope: !301, inlinedAt: !1279)
!1279 = distinct !DILocation(line: 847, column: 1, scope: !272, inlinedAt: !1261)
!1280 = !DILocation(line: 220, column: 25, scope: !278, inlinedAt: !1281)
!1281 = distinct !DILocation(line: 847, column: 1, scope: !285, inlinedAt: !1282)
!1282 = distinct !DILocation(line: 847, column: 1, scope: !287, inlinedAt: !1283)
!1283 = distinct !DILocation(line: 847, column: 1, scope: !307, inlinedAt: !1284)
!1284 = distinct !DILocation(line: 847, column: 1, scope: !301, inlinedAt: !1279)
!1285 = !DILocation(line: 847, column: 1, scope: !891, inlinedAt: !1286)
!1286 = distinct !DILocation(line: 1049, column: 1, scope: !893, inlinedAt: !1287)
!1287 = distinct !DILocation(line: 145, column: 13, scope: !895, inlinedAt: !1288)
!1288 = distinct !DILocation(line: 847, column: 1, scope: !901, inlinedAt: !1289)
!1289 = distinct !DILocation(line: 847, column: 1, scope: !903, inlinedAt: !1290)
!1290 = distinct !DILocation(line: 847, column: 1, scope: !888, inlinedAt: !1291)
!1291 = distinct !DILocation(line: 847, column: 1, scope: !1172, inlinedAt: !1173)
!1292 = !DILocation(line: 468, column: 14, scope: !906, inlinedAt: !1293)
!1293 = distinct !DILocation(line: 261, column: 43, scope: !908, inlinedAt: !1294)
!1294 = distinct !DILocation(line: 1998, column: 26, scope: !914, inlinedAt: !1295)
!1295 = distinct !DILocation(line: 847, column: 1, scope: !891, inlinedAt: !1286)
!1296 = !DILocation(line: 1999, column: 16, scope: !919, inlinedAt: !1295)
!1297 = !DILocation(line: 642, column: 14, scope: !921, inlinedAt: !1298)
!1298 = distinct !DILocation(line: 159, column: 30, scope: !923, inlinedAt: !1299)
!1299 = distinct !DILocation(line: 261, column: 70, scope: !908, inlinedAt: !1294)
!1300 = !DILocation(line: 175, column: 14, scope: !168, inlinedAt: !1301)
!1301 = distinct !DILocation(line: 321, column: 22, scope: !170, inlinedAt: !1302)
!1302 = distinct !DILocation(line: 436, column: 9, scope: !172, inlinedAt: !1303)
!1303 = distinct !DILocation(line: 554, column: 23, scope: !174, inlinedAt: !1304)
!1304 = distinct !DILocation(line: 2000, column: 24, scope: !919, inlinedAt: !1295)
!1305 = !DILocation(line: 1999, column: 13, scope: !919, inlinedAt: !1295)
!1306 = !DILocation(line: 468, column: 14, scope: !906, inlinedAt: !1307)
!1307 = distinct !DILocation(line: 261, column: 43, scope: !908, inlinedAt: !1308)
!1308 = distinct !DILocation(line: 1998, column: 26, scope: !914, inlinedAt: !1309)
!1309 = distinct !DILocation(line: 847, column: 1, scope: !891, inlinedAt: !1286)
!1310 = !DILocation(line: 1999, column: 16, scope: !919, inlinedAt: !1309)
!1311 = !DILocation(line: 642, column: 14, scope: !921, inlinedAt: !1312)
!1312 = distinct !DILocation(line: 159, column: 30, scope: !923, inlinedAt: !1313)
!1313 = distinct !DILocation(line: 261, column: 70, scope: !908, inlinedAt: !1308)
!1314 = !DILocation(line: 175, column: 14, scope: !168, inlinedAt: !1315)
!1315 = distinct !DILocation(line: 321, column: 22, scope: !170, inlinedAt: !1316)
!1316 = distinct !DILocation(line: 436, column: 9, scope: !172, inlinedAt: !1317)
!1317 = distinct !DILocation(line: 554, column: 23, scope: !174, inlinedAt: !1318)
!1318 = distinct !DILocation(line: 2000, column: 24, scope: !919, inlinedAt: !1309)
!1319 = !DILocation(line: 1999, column: 13, scope: !919, inlinedAt: !1309)
!1320 = distinct !DISubprogram(name: "drop_glue<tokio::runtime::builder::Builder>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtNtCs3EIJ1qnJmKW_5tokio7runtime7builder7BuilderECshxBJAVx362N_11runtime_lab", scope: !140, file: !139, line: 847, type: !52, scopeLine: 847, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!1321 = !{i64 8012794103947387591}
!1322 = !DILocation(line: 847, column: 1, scope: !1320)
!1323 = !DILocation(line: 847, column: 1, scope: !248, inlinedAt: !1324)
!1324 = distinct !DILocation(line: 847, column: 1, scope: !1320)
!1325 = !DILocation(line: 175, column: 14, scope: !168, inlinedAt: !1326)
!1326 = distinct !DILocation(line: 321, column: 22, scope: !170, inlinedAt: !1327)
!1327 = distinct !DILocation(line: 436, column: 9, scope: !172, inlinedAt: !1328)
!1328 = distinct !DILocation(line: 554, column: 23, scope: !174, inlinedAt: !1329)
!1329 = distinct !DILocation(line: 876, column: 28, scope: !230, inlinedAt: !1330)
!1330 = distinct !DILocation(line: 425, column: 29, scope: !233, inlinedAt: !1331)
!1331 = distinct !DILocation(line: 847, column: 1, scope: !236, inlinedAt: !1332)
!1332 = distinct !DILocation(line: 847, column: 1, scope: !238, inlinedAt: !1333)
!1333 = distinct !DILocation(line: 847, column: 1, scope: !261, inlinedAt: !1334)
!1334 = distinct !DILocation(line: 847, column: 1, scope: !248, inlinedAt: !1324)
!1335 = !DILocation(line: 874, column: 9, scope: !231, inlinedAt: !1330)
!1336 = !{!1337}
!1337 = distinct !{!1337, !1338, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc4sync3ArcDINtNtNtB4_3ops8function2FnuEp6OutputNtNtBG_6string6StringNtNtB4_6marker4SendNtB27_4SyncEL_EECshxBJAVx362N_11runtime_lab: %_1"}
!1338 = distinct !{!1338, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc4sync3ArcDINtNtNtB4_3ops8function2FnuEp6OutputNtNtBG_6string6StringNtNtB4_6marker4SendNtB27_4SyncEL_EECshxBJAVx362N_11runtime_lab"}
!1339 = !{!1340}
!1340 = distinct !{!1340, !1341, !"_RNvXsE_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcDINtNtNtCsjIpoRzUjyHQ_4core3ops8function2FnuEp6OutputNtNtB7_6string6StringNtNtBO_6marker4SendNtB1U_4SyncEL_ENtNtBM_4drop4Drop4dropCshxBJAVx362N_11runtime_lab: %self"}
!1341 = distinct !{!1341, !"_RNvXsE_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcDINtNtNtCsjIpoRzUjyHQ_4core3ops8function2FnuEp6OutputNtNtB7_6string6StringNtNtBO_6marker4SendNtB1U_4SyncEL_ENtNtBM_4drop4Drop4dropCshxBJAVx362N_11runtime_lab"}
!1342 = !DILocation(line: 847, column: 1, scope: !1343, inlinedAt: !1344)
!1343 = distinct !DISubprogram(name: "drop_glue<alloc::sync::Arc<(dyn core::ops::function::Fn<(), Output=alloc::string::String> + core::marker::Send + core::marker::Sync), alloc::alloc::Global>>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc4sync3ArcDINtNtNtB4_3ops8function2FnuEp6OutputNtNtBG_6string6StringNtNtB4_6marker4SendNtB27_4SyncEL_EECshxBJAVx362N_11runtime_lab", scope: !140, file: !139, line: 847, type: !52, scopeLine: 847, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!1344 = distinct !DILocation(line: 847, column: 1, scope: !1320)
!1345 = !DILocation(line: 454, column: 20, scope: !1346, inlinedAt: !1347)
!1346 = distinct !DISubprogram(name: "as_ref<alloc::sync::ArcInner<(dyn core::ops::function::Fn<(), Output=alloc::string::String> + core::marker::Send + core::marker::Sync)>>", linkageName: "_RNvMs1_NtNtCsjIpoRzUjyHQ_4core3ptr8non_nullINtB5_7NonNullINtNtCs6zY7rJBZy9D_5alloc4sync8ArcInnerDINtNtNtB9_3ops8function2FnuEp6OutputNtNtBY_6string6StringNtNtB9_6marker4SendNtB2u_4SyncEL_EE6as_refCshxBJAVx362N_11runtime_lab", scope: !599, file: !598, line: 450, type: !52, scopeLine: 450, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!1347 = distinct !DILocation(line: 2133, column: 27, scope: !1348, inlinedAt: !1352)
!1348 = distinct !DISubprogram(name: "inner<(dyn core::ops::function::Fn<(), Output=alloc::string::String> + core::marker::Send + core::marker::Sync), alloc::alloc::Global>", linkageName: "_RNvMsn_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcDINtNtNtCsjIpoRzUjyHQ_4core3ops8function2FnuEp6OutputNtNtB7_6string6StringNtNtBO_6marker4SendNtB1U_4SyncEL_E5innerCshxBJAVx362N_11runtime_lab", scope: !1350, file: !1349, line: 2127, type: !52, scopeLine: 2127, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!1349 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/alloc/src/sync.rs", directory: "", checksumkind: CSK_MD5, checksum: "8b43a53dcc02e6dca0e12f2ab1ca948e")
!1350 = !DINamespace(name: "Arc", scope: !1351)
!1351 = !DINamespace(name: "sync", scope: !109)
!1352 = distinct !DILocation(line: 2868, column: 17, scope: !1353, inlinedAt: !1355)
!1353 = distinct !DISubprogram(name: "drop<(dyn core::ops::function::Fn<(), Output=alloc::string::String> + core::marker::Send + core::marker::Sync), alloc::alloc::Global>", linkageName: "_RNvXsE_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcDINtNtNtCsjIpoRzUjyHQ_4core3ops8function2FnuEp6OutputNtNtB7_6string6StringNtNtBO_6marker4SendNtB1U_4SyncEL_ENtNtBM_4drop4Drop4dropCshxBJAVx362N_11runtime_lab", scope: !1354, file: !1349, line: 2864, type: !52, scopeLine: 2864, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!1354 = !DINamespace(name: "{impl#42}", scope: !1351)
!1355 = distinct !DILocation(line: 847, column: 1, scope: !1343, inlinedAt: !1344)
!1356 = !{!1340, !1337}
!1357 = !DILocation(line: 4049, column: 24, scope: !1358, inlinedAt: !1359)
!1358 = distinct !DISubprogram(name: "atomic_sub<usize, usize>", linkageName: "_RINvNtNtCsjIpoRzUjyHQ_4core4sync6atomic10atomic_subjjECshxBJAVx362N_11runtime_lab", scope: !46, file: !45, line: 4043, type: !52, scopeLine: 4043, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!1359 = distinct !DILocation(line: 3253, column: 26, scope: !1360, inlinedAt: !1361)
!1360 = distinct !DISubprogram(name: "fetch_sub", linkageName: "_RNvMs1g_NtNtCsjIpoRzUjyHQ_4core4sync6atomicINtB6_6AtomicjE9fetch_sub", scope: !51, file: !45, line: 3251, type: !52, scopeLine: 3251, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!1361 = distinct !DILocation(line: 2868, column: 32, scope: !1353, inlinedAt: !1355)
!1362 = !DILocation(line: 2868, column: 12, scope: !1353, inlinedAt: !1355)
!1363 = !DILocation(line: 4493, column: 24, scope: !1364, inlinedAt: !1365)
!1364 = distinct !DISubprogram(name: "fence", linkageName: "_RNvNtNtCsjIpoRzUjyHQ_4core4sync6atomic5fence", scope: !46, file: !45, line: 4489, type: !52, scopeLine: 4489, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!1365 = distinct !DILocation(line: 69, column: 9, scope: !1353, inlinedAt: !1355)
!1366 = !DILocation(line: 2911, column: 18, scope: !1353, inlinedAt: !1355)
!1367 = !DILocation(line: 4049, column: 24, scope: !1368, inlinedAt: !1369)
!1368 = distinct !DISubprogram(name: "atomic_sub<usize, usize>", linkageName: "_RINvNtNtCsjIpoRzUjyHQ_4core4sync6atomic10atomic_subjjECshxBJAVx362N_11runtime_lab", scope: !46, file: !45, line: 4043, type: !52, scopeLine: 4043, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!1369 = distinct !DILocation(line: 3253, column: 26, scope: !1370, inlinedAt: !1371)
!1370 = distinct !DISubprogram(name: "fetch_sub", linkageName: "_RNvMs1g_NtNtCsjIpoRzUjyHQ_4core4sync6atomicINtB6_6AtomicjE9fetch_sub", scope: !51, file: !45, line: 3251, type: !52, scopeLine: 3251, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!1371 = distinct !DILocation(line: 2868, column: 32, scope: !1372, inlinedAt: !1373)
!1372 = distinct !DISubprogram(name: "drop<(dyn core::ops::function::Fn<(), Output=()> + core::marker::Send + core::marker::Sync), alloc::alloc::Global>", linkageName: "_RNvXsE_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcDINtNtNtCsjIpoRzUjyHQ_4core3ops8function2FnuEp6OutputuNtNtBO_6marker4SendNtB1A_4SyncEL_ENtNtBM_4drop4Drop4dropCshxBJAVx362N_11runtime_lab", scope: !1354, file: !1349, line: 2864, type: !52, scopeLine: 2864, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!1373 = distinct !DILocation(line: 847, column: 1, scope: !1374, inlinedAt: !1375)
!1374 = distinct !DISubprogram(name: "drop_glue<alloc::sync::Arc<(dyn core::ops::function::Fn<(), Output=()> + core::marker::Send + core::marker::Sync), alloc::alloc::Global>>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc4sync3ArcDINtNtNtB4_3ops8function2FnuEp6OutputuNtNtB4_6marker4SendNtB1N_4SyncEL_EECshxBJAVx362N_11runtime_lab", scope: !140, file: !139, line: 847, type: !52, scopeLine: 847, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!1375 = distinct !DILocation(line: 847, column: 1, scope: !1376, inlinedAt: !1377)
!1376 = distinct !DISubprogram(name: "drop_glue<core::option::Option<alloc::sync::Arc<(dyn core::ops::function::Fn<(), Output=()> + core::marker::Send + core::marker::Sync), alloc::alloc::Global>>>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtB4_6option6OptionINtNtCs6zY7rJBZy9D_5alloc4sync3ArcDINtNtNtB4_3ops8function2FnuEp6OutputuNtNtB4_6marker4SendNtB29_4SyncEL_EEECshxBJAVx362N_11runtime_lab", scope: !140, file: !139, line: 847, type: !52, scopeLine: 847, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!1377 = distinct !DILocation(line: 847, column: 1, scope: !1320)
!1378 = !{!1379, !1381, !1383}
!1379 = distinct !{!1379, !1380, !"_RNvXsE_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcDINtNtNtCsjIpoRzUjyHQ_4core3ops8function2FnuEp6OutputuNtNtBO_6marker4SendNtB1A_4SyncEL_ENtNtBM_4drop4Drop4dropCshxBJAVx362N_11runtime_lab: %self"}
!1380 = distinct !{!1380, !"_RNvXsE_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcDINtNtNtCsjIpoRzUjyHQ_4core3ops8function2FnuEp6OutputuNtNtBO_6marker4SendNtB1A_4SyncEL_ENtNtBM_4drop4Drop4dropCshxBJAVx362N_11runtime_lab"}
!1381 = distinct !{!1381, !1382, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc4sync3ArcDINtNtNtB4_3ops8function2FnuEp6OutputuNtNtB4_6marker4SendNtB1N_4SyncEL_EECshxBJAVx362N_11runtime_lab: %_1"}
!1382 = distinct !{!1382, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc4sync3ArcDINtNtNtB4_3ops8function2FnuEp6OutputuNtNtB4_6marker4SendNtB1N_4SyncEL_EECshxBJAVx362N_11runtime_lab"}
!1383 = distinct !{!1383, !1384, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtB4_6option6OptionINtNtCs6zY7rJBZy9D_5alloc4sync3ArcDINtNtNtB4_3ops8function2FnuEp6OutputuNtNtB4_6marker4SendNtB29_4SyncEL_EEECshxBJAVx362N_11runtime_lab: %_1"}
!1384 = distinct !{!1384, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtB4_6option6OptionINtNtCs6zY7rJBZy9D_5alloc4sync3ArcDINtNtNtB4_3ops8function2FnuEp6OutputuNtNtB4_6marker4SendNtB29_4SyncEL_EEECshxBJAVx362N_11runtime_lab"}
!1385 = !DILocation(line: 2868, column: 12, scope: !1372, inlinedAt: !1373)
!1386 = !DILocation(line: 4493, column: 24, scope: !1364, inlinedAt: !1387)
!1387 = distinct !DILocation(line: 69, column: 9, scope: !1372, inlinedAt: !1373)
!1388 = !DILocation(line: 2911, column: 18, scope: !1372, inlinedAt: !1373)
!1389 = !{!1383}
!1390 = !DILocation(line: 847, column: 1, scope: !1376, inlinedAt: !1377)
!1391 = !{!1392}
!1392 = distinct !{!1392, !1393, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtB4_6option6OptionINtNtCs6zY7rJBZy9D_5alloc4sync3ArcDINtNtNtB4_3ops8function2FnuEp6OutputuNtNtB4_6marker4SendNtB29_4SyncEL_EEECshxBJAVx362N_11runtime_lab: %_1"}
!1393 = distinct !{!1393, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtB4_6option6OptionINtNtCs6zY7rJBZy9D_5alloc4sync3ArcDINtNtNtB4_3ops8function2FnuEp6OutputuNtNtB4_6marker4SendNtB29_4SyncEL_EEECshxBJAVx362N_11runtime_lab"}
!1394 = !DILocation(line: 847, column: 1, scope: !1376, inlinedAt: !1395)
!1395 = distinct !DILocation(line: 847, column: 1, scope: !1320)
!1396 = !DILocation(line: 4049, column: 24, scope: !1368, inlinedAt: !1397)
!1397 = distinct !DILocation(line: 3253, column: 26, scope: !1370, inlinedAt: !1398)
!1398 = distinct !DILocation(line: 2868, column: 32, scope: !1372, inlinedAt: !1399)
!1399 = distinct !DILocation(line: 847, column: 1, scope: !1374, inlinedAt: !1400)
!1400 = distinct !DILocation(line: 847, column: 1, scope: !1376, inlinedAt: !1395)
!1401 = !{!1402, !1404, !1392}
!1402 = distinct !{!1402, !1403, !"_RNvXsE_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcDINtNtNtCsjIpoRzUjyHQ_4core3ops8function2FnuEp6OutputuNtNtBO_6marker4SendNtB1A_4SyncEL_ENtNtBM_4drop4Drop4dropCshxBJAVx362N_11runtime_lab: %self"}
!1403 = distinct !{!1403, !"_RNvXsE_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcDINtNtNtCsjIpoRzUjyHQ_4core3ops8function2FnuEp6OutputuNtNtBO_6marker4SendNtB1A_4SyncEL_ENtNtBM_4drop4Drop4dropCshxBJAVx362N_11runtime_lab"}
!1404 = distinct !{!1404, !1405, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc4sync3ArcDINtNtNtB4_3ops8function2FnuEp6OutputuNtNtB4_6marker4SendNtB1N_4SyncEL_EECshxBJAVx362N_11runtime_lab: %_1"}
!1405 = distinct !{!1405, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc4sync3ArcDINtNtNtB4_3ops8function2FnuEp6OutputuNtNtB4_6marker4SendNtB1N_4SyncEL_EECshxBJAVx362N_11runtime_lab"}
!1406 = !DILocation(line: 2868, column: 12, scope: !1372, inlinedAt: !1399)
!1407 = !DILocation(line: 4493, column: 24, scope: !1364, inlinedAt: !1408)
!1408 = distinct !DILocation(line: 69, column: 9, scope: !1372, inlinedAt: !1399)
!1409 = !DILocation(line: 2911, column: 18, scope: !1372, inlinedAt: !1399)
!1410 = !{!1411}
!1411 = distinct !{!1411, !1412, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtB4_6option6OptionINtNtCs6zY7rJBZy9D_5alloc4sync3ArcDINtNtNtB4_3ops8function2FnuEp6OutputuNtNtB4_6marker4SendNtB29_4SyncEL_EEECshxBJAVx362N_11runtime_lab: %_1"}
!1412 = distinct !{!1412, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtB4_6option6OptionINtNtCs6zY7rJBZy9D_5alloc4sync3ArcDINtNtNtB4_3ops8function2FnuEp6OutputuNtNtB4_6marker4SendNtB29_4SyncEL_EEECshxBJAVx362N_11runtime_lab"}
!1413 = !DILocation(line: 847, column: 1, scope: !1376, inlinedAt: !1414)
!1414 = distinct !DILocation(line: 847, column: 1, scope: !1320)
!1415 = !DILocation(line: 4049, column: 24, scope: !1368, inlinedAt: !1416)
!1416 = distinct !DILocation(line: 3253, column: 26, scope: !1370, inlinedAt: !1417)
!1417 = distinct !DILocation(line: 2868, column: 32, scope: !1372, inlinedAt: !1418)
!1418 = distinct !DILocation(line: 847, column: 1, scope: !1374, inlinedAt: !1419)
!1419 = distinct !DILocation(line: 847, column: 1, scope: !1376, inlinedAt: !1414)
!1420 = !{!1421, !1423, !1411}
!1421 = distinct !{!1421, !1422, !"_RNvXsE_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcDINtNtNtCsjIpoRzUjyHQ_4core3ops8function2FnuEp6OutputuNtNtBO_6marker4SendNtB1A_4SyncEL_ENtNtBM_4drop4Drop4dropCshxBJAVx362N_11runtime_lab: %self"}
!1422 = distinct !{!1422, !"_RNvXsE_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcDINtNtNtCsjIpoRzUjyHQ_4core3ops8function2FnuEp6OutputuNtNtBO_6marker4SendNtB1A_4SyncEL_ENtNtBM_4drop4Drop4dropCshxBJAVx362N_11runtime_lab"}
!1423 = distinct !{!1423, !1424, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc4sync3ArcDINtNtNtB4_3ops8function2FnuEp6OutputuNtNtB4_6marker4SendNtB1N_4SyncEL_EECshxBJAVx362N_11runtime_lab: %_1"}
!1424 = distinct !{!1424, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc4sync3ArcDINtNtNtB4_3ops8function2FnuEp6OutputuNtNtB4_6marker4SendNtB1N_4SyncEL_EECshxBJAVx362N_11runtime_lab"}
!1425 = !DILocation(line: 2868, column: 12, scope: !1372, inlinedAt: !1418)
!1426 = !DILocation(line: 4493, column: 24, scope: !1364, inlinedAt: !1427)
!1427 = distinct !DILocation(line: 69, column: 9, scope: !1372, inlinedAt: !1418)
!1428 = !DILocation(line: 2911, column: 18, scope: !1372, inlinedAt: !1418)
!1429 = !{!1430}
!1430 = distinct !{!1430, !1431, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtB4_6option6OptionINtNtCs6zY7rJBZy9D_5alloc4sync3ArcDINtNtNtB4_3ops8function2FnuEp6OutputuNtNtB4_6marker4SendNtB29_4SyncEL_EEECshxBJAVx362N_11runtime_lab: %_1"}
!1431 = distinct !{!1431, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtB4_6option6OptionINtNtCs6zY7rJBZy9D_5alloc4sync3ArcDINtNtNtB4_3ops8function2FnuEp6OutputuNtNtB4_6marker4SendNtB29_4SyncEL_EEECshxBJAVx362N_11runtime_lab"}
!1432 = !DILocation(line: 847, column: 1, scope: !1376, inlinedAt: !1433)
!1433 = distinct !DILocation(line: 847, column: 1, scope: !1320)
!1434 = !DILocation(line: 4049, column: 24, scope: !1368, inlinedAt: !1435)
!1435 = distinct !DILocation(line: 3253, column: 26, scope: !1370, inlinedAt: !1436)
!1436 = distinct !DILocation(line: 2868, column: 32, scope: !1372, inlinedAt: !1437)
!1437 = distinct !DILocation(line: 847, column: 1, scope: !1374, inlinedAt: !1438)
!1438 = distinct !DILocation(line: 847, column: 1, scope: !1376, inlinedAt: !1433)
!1439 = !{!1440, !1442, !1430}
!1440 = distinct !{!1440, !1441, !"_RNvXsE_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcDINtNtNtCsjIpoRzUjyHQ_4core3ops8function2FnuEp6OutputuNtNtBO_6marker4SendNtB1A_4SyncEL_ENtNtBM_4drop4Drop4dropCshxBJAVx362N_11runtime_lab: %self"}
!1441 = distinct !{!1441, !"_RNvXsE_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcDINtNtNtCsjIpoRzUjyHQ_4core3ops8function2FnuEp6OutputuNtNtBO_6marker4SendNtB1A_4SyncEL_ENtNtBM_4drop4Drop4dropCshxBJAVx362N_11runtime_lab"}
!1442 = distinct !{!1442, !1443, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc4sync3ArcDINtNtNtB4_3ops8function2FnuEp6OutputuNtNtB4_6marker4SendNtB1N_4SyncEL_EECshxBJAVx362N_11runtime_lab: %_1"}
!1443 = distinct !{!1443, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc4sync3ArcDINtNtNtB4_3ops8function2FnuEp6OutputuNtNtB4_6marker4SendNtB1N_4SyncEL_EECshxBJAVx362N_11runtime_lab"}
!1444 = !DILocation(line: 2868, column: 12, scope: !1372, inlinedAt: !1437)
!1445 = !DILocation(line: 4493, column: 24, scope: !1364, inlinedAt: !1446)
!1446 = distinct !DILocation(line: 69, column: 9, scope: !1372, inlinedAt: !1437)
!1447 = !DILocation(line: 2911, column: 18, scope: !1372, inlinedAt: !1437)
!1448 = !{!1449}
!1449 = distinct !{!1449, !1450, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtB4_6option6OptionINtNtCs6zY7rJBZy9D_5alloc4sync3ArcDINtNtNtB4_3ops8function2FnuEp6OutputuNtNtB4_6marker4SendNtB29_4SyncEL_EEECshxBJAVx362N_11runtime_lab: %_1"}
!1450 = distinct !{!1450, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtB4_6option6OptionINtNtCs6zY7rJBZy9D_5alloc4sync3ArcDINtNtNtB4_3ops8function2FnuEp6OutputuNtNtB4_6marker4SendNtB29_4SyncEL_EEECshxBJAVx362N_11runtime_lab"}
!1451 = !DILocation(line: 847, column: 1, scope: !1376, inlinedAt: !1452)
!1452 = distinct !DILocation(line: 847, column: 1, scope: !1320)
!1453 = !DILocation(line: 4049, column: 24, scope: !1368, inlinedAt: !1454)
!1454 = distinct !DILocation(line: 3253, column: 26, scope: !1370, inlinedAt: !1455)
!1455 = distinct !DILocation(line: 2868, column: 32, scope: !1372, inlinedAt: !1456)
!1456 = distinct !DILocation(line: 847, column: 1, scope: !1374, inlinedAt: !1457)
!1457 = distinct !DILocation(line: 847, column: 1, scope: !1376, inlinedAt: !1452)
!1458 = !{!1459, !1461, !1449}
!1459 = distinct !{!1459, !1460, !"_RNvXsE_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcDINtNtNtCsjIpoRzUjyHQ_4core3ops8function2FnuEp6OutputuNtNtBO_6marker4SendNtB1A_4SyncEL_ENtNtBM_4drop4Drop4dropCshxBJAVx362N_11runtime_lab: %self"}
!1460 = distinct !{!1460, !"_RNvXsE_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcDINtNtNtCsjIpoRzUjyHQ_4core3ops8function2FnuEp6OutputuNtNtBO_6marker4SendNtB1A_4SyncEL_ENtNtBM_4drop4Drop4dropCshxBJAVx362N_11runtime_lab"}
!1461 = distinct !{!1461, !1462, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc4sync3ArcDINtNtNtB4_3ops8function2FnuEp6OutputuNtNtB4_6marker4SendNtB1N_4SyncEL_EECshxBJAVx362N_11runtime_lab: %_1"}
!1462 = distinct !{!1462, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc4sync3ArcDINtNtNtB4_3ops8function2FnuEp6OutputuNtNtB4_6marker4SendNtB1N_4SyncEL_EECshxBJAVx362N_11runtime_lab"}
!1463 = !DILocation(line: 2868, column: 12, scope: !1372, inlinedAt: !1456)
!1464 = !DILocation(line: 4493, column: 24, scope: !1364, inlinedAt: !1465)
!1465 = distinct !DILocation(line: 69, column: 9, scope: !1372, inlinedAt: !1456)
!1466 = !DILocation(line: 2911, column: 18, scope: !1372, inlinedAt: !1456)
!1467 = !{!1468}
!1468 = distinct !{!1468, !1469, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtB4_6option6OptionINtNtCs6zY7rJBZy9D_5alloc4sync3ArcDINtNtNtB4_3ops8function2FnuEp6OutputuNtNtB4_6marker4SendNtB29_4SyncEL_EEECshxBJAVx362N_11runtime_lab: %_1"}
!1469 = distinct !{!1469, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtB4_6option6OptionINtNtCs6zY7rJBZy9D_5alloc4sync3ArcDINtNtNtB4_3ops8function2FnuEp6OutputuNtNtB4_6marker4SendNtB29_4SyncEL_EEECshxBJAVx362N_11runtime_lab"}
!1470 = !DILocation(line: 847, column: 1, scope: !1376, inlinedAt: !1471)
!1471 = distinct !DILocation(line: 847, column: 1, scope: !1320)
!1472 = !DILocation(line: 4049, column: 24, scope: !1368, inlinedAt: !1473)
!1473 = distinct !DILocation(line: 3253, column: 26, scope: !1370, inlinedAt: !1474)
!1474 = distinct !DILocation(line: 2868, column: 32, scope: !1372, inlinedAt: !1475)
!1475 = distinct !DILocation(line: 847, column: 1, scope: !1374, inlinedAt: !1476)
!1476 = distinct !DILocation(line: 847, column: 1, scope: !1376, inlinedAt: !1471)
!1477 = !{!1478, !1480, !1468}
!1478 = distinct !{!1478, !1479, !"_RNvXsE_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcDINtNtNtCsjIpoRzUjyHQ_4core3ops8function2FnuEp6OutputuNtNtBO_6marker4SendNtB1A_4SyncEL_ENtNtBM_4drop4Drop4dropCshxBJAVx362N_11runtime_lab: %self"}
!1479 = distinct !{!1479, !"_RNvXsE_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcDINtNtNtCsjIpoRzUjyHQ_4core3ops8function2FnuEp6OutputuNtNtBO_6marker4SendNtB1A_4SyncEL_ENtNtBM_4drop4Drop4dropCshxBJAVx362N_11runtime_lab"}
!1480 = distinct !{!1480, !1481, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc4sync3ArcDINtNtNtB4_3ops8function2FnuEp6OutputuNtNtB4_6marker4SendNtB1N_4SyncEL_EECshxBJAVx362N_11runtime_lab: %_1"}
!1481 = distinct !{!1481, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc4sync3ArcDINtNtNtB4_3ops8function2FnuEp6OutputuNtNtB4_6marker4SendNtB1N_4SyncEL_EECshxBJAVx362N_11runtime_lab"}
!1482 = !DILocation(line: 2868, column: 12, scope: !1372, inlinedAt: !1475)
!1483 = !DILocation(line: 4493, column: 24, scope: !1364, inlinedAt: !1484)
!1484 = distinct !DILocation(line: 69, column: 9, scope: !1372, inlinedAt: !1475)
!1485 = !DILocation(line: 2911, column: 18, scope: !1372, inlinedAt: !1475)
!1486 = !{!1487}
!1487 = distinct !{!1487, !1488, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtB4_6option6OptionINtNtCs6zY7rJBZy9D_5alloc4sync3ArcDINtNtNtB4_3ops8function2FnuEp6OutputuNtNtB4_6marker4SendNtB29_4SyncEL_EEECshxBJAVx362N_11runtime_lab: %_1"}
!1488 = distinct !{!1488, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtB4_6option6OptionINtNtCs6zY7rJBZy9D_5alloc4sync3ArcDINtNtNtB4_3ops8function2FnuEp6OutputuNtNtB4_6marker4SendNtB29_4SyncEL_EEECshxBJAVx362N_11runtime_lab"}
!1489 = !DILocation(line: 847, column: 1, scope: !1376, inlinedAt: !1490)
!1490 = distinct !DILocation(line: 847, column: 1, scope: !1320)
!1491 = !DILocation(line: 4049, column: 24, scope: !1368, inlinedAt: !1492)
!1492 = distinct !DILocation(line: 3253, column: 26, scope: !1370, inlinedAt: !1493)
!1493 = distinct !DILocation(line: 2868, column: 32, scope: !1372, inlinedAt: !1494)
!1494 = distinct !DILocation(line: 847, column: 1, scope: !1374, inlinedAt: !1495)
!1495 = distinct !DILocation(line: 847, column: 1, scope: !1376, inlinedAt: !1490)
!1496 = !{!1497, !1499, !1487}
!1497 = distinct !{!1497, !1498, !"_RNvXsE_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcDINtNtNtCsjIpoRzUjyHQ_4core3ops8function2FnuEp6OutputuNtNtBO_6marker4SendNtB1A_4SyncEL_ENtNtBM_4drop4Drop4dropCshxBJAVx362N_11runtime_lab: %self"}
!1498 = distinct !{!1498, !"_RNvXsE_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcDINtNtNtCsjIpoRzUjyHQ_4core3ops8function2FnuEp6OutputuNtNtBO_6marker4SendNtB1A_4SyncEL_ENtNtBM_4drop4Drop4dropCshxBJAVx362N_11runtime_lab"}
!1499 = distinct !{!1499, !1500, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc4sync3ArcDINtNtNtB4_3ops8function2FnuEp6OutputuNtNtB4_6marker4SendNtB1N_4SyncEL_EECshxBJAVx362N_11runtime_lab: %_1"}
!1500 = distinct !{!1500, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc4sync3ArcDINtNtNtB4_3ops8function2FnuEp6OutputuNtNtB4_6marker4SendNtB1N_4SyncEL_EECshxBJAVx362N_11runtime_lab"}
!1501 = !DILocation(line: 2868, column: 12, scope: !1372, inlinedAt: !1494)
!1502 = !DILocation(line: 4493, column: 24, scope: !1364, inlinedAt: !1503)
!1503 = distinct !DILocation(line: 69, column: 9, scope: !1372, inlinedAt: !1494)
!1504 = !DILocation(line: 2911, column: 18, scope: !1372, inlinedAt: !1494)
!1505 = !{!1506}
!1506 = distinct !{!1506, !1507, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtB4_6option6OptionINtNtCs6zY7rJBZy9D_5alloc4sync3ArcDINtNtNtB4_3ops8function2FnuEp6OutputuNtNtB4_6marker4SendNtB29_4SyncEL_EEECshxBJAVx362N_11runtime_lab: %_1"}
!1507 = distinct !{!1507, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtB4_6option6OptionINtNtCs6zY7rJBZy9D_5alloc4sync3ArcDINtNtNtB4_3ops8function2FnuEp6OutputuNtNtB4_6marker4SendNtB29_4SyncEL_EEECshxBJAVx362N_11runtime_lab"}
!1508 = !DILocation(line: 847, column: 1, scope: !1376, inlinedAt: !1509)
!1509 = distinct !DILocation(line: 847, column: 1, scope: !1320)
!1510 = !DILocation(line: 4049, column: 24, scope: !1368, inlinedAt: !1511)
!1511 = distinct !DILocation(line: 3253, column: 26, scope: !1370, inlinedAt: !1512)
!1512 = distinct !DILocation(line: 2868, column: 32, scope: !1372, inlinedAt: !1513)
!1513 = distinct !DILocation(line: 847, column: 1, scope: !1374, inlinedAt: !1514)
!1514 = distinct !DILocation(line: 847, column: 1, scope: !1376, inlinedAt: !1509)
!1515 = !{!1516, !1518, !1506}
!1516 = distinct !{!1516, !1517, !"_RNvXsE_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcDINtNtNtCsjIpoRzUjyHQ_4core3ops8function2FnuEp6OutputuNtNtBO_6marker4SendNtB1A_4SyncEL_ENtNtBM_4drop4Drop4dropCshxBJAVx362N_11runtime_lab: %self"}
!1517 = distinct !{!1517, !"_RNvXsE_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcDINtNtNtCsjIpoRzUjyHQ_4core3ops8function2FnuEp6OutputuNtNtBO_6marker4SendNtB1A_4SyncEL_ENtNtBM_4drop4Drop4dropCshxBJAVx362N_11runtime_lab"}
!1518 = distinct !{!1518, !1519, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc4sync3ArcDINtNtNtB4_3ops8function2FnuEp6OutputuNtNtB4_6marker4SendNtB1N_4SyncEL_EECshxBJAVx362N_11runtime_lab: %_1"}
!1519 = distinct !{!1519, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc4sync3ArcDINtNtNtB4_3ops8function2FnuEp6OutputuNtNtB4_6marker4SendNtB1N_4SyncEL_EECshxBJAVx362N_11runtime_lab"}
!1520 = !DILocation(line: 2868, column: 12, scope: !1372, inlinedAt: !1513)
!1521 = !DILocation(line: 4493, column: 24, scope: !1364, inlinedAt: !1522)
!1522 = distinct !DILocation(line: 69, column: 9, scope: !1372, inlinedAt: !1513)
!1523 = !DILocation(line: 2911, column: 18, scope: !1372, inlinedAt: !1513)
!1524 = !{!1525}
!1525 = distinct !{!1525, !1526, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtB4_6option6OptionINtNtCs6zY7rJBZy9D_5alloc4sync3ArcDG0_INtNtNtB4_3ops8function2FnTRL1_INtNtNtCs3EIJ1qnJmKW_5tokio7runtime10task_hooks8TaskMetaL0_EEEp6OutputuNtNtB4_6marker4SendNtB3f_4SyncEL_EEECshxBJAVx362N_11runtime_lab: %_1"}
!1526 = distinct !{!1526, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtB4_6option6OptionINtNtCs6zY7rJBZy9D_5alloc4sync3ArcDG0_INtNtNtB4_3ops8function2FnTRL1_INtNtNtCs3EIJ1qnJmKW_5tokio7runtime10task_hooks8TaskMetaL0_EEEp6OutputuNtNtB4_6marker4SendNtB3f_4SyncEL_EEECshxBJAVx362N_11runtime_lab"}
!1527 = !DILocation(line: 847, column: 1, scope: !1528, inlinedAt: !1529)
!1528 = distinct !DISubprogram(name: "drop_glue<core::option::Option<alloc::sync::Arc<(dyn core::ops::function::Fn<(&tokio::runtime::task_hooks::TaskMeta), Output=()> + core::marker::Send + core::marker::Sync), alloc::alloc::Global>>>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtB4_6option6OptionINtNtCs6zY7rJBZy9D_5alloc4sync3ArcDG0_INtNtNtB4_3ops8function2FnTRL1_INtNtNtCs3EIJ1qnJmKW_5tokio7runtime10task_hooks8TaskMetaL0_EEEp6OutputuNtNtB4_6marker4SendNtB3f_4SyncEL_EEECshxBJAVx362N_11runtime_lab", scope: !140, file: !139, line: 847, type: !52, scopeLine: 847, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!1529 = distinct !DILocation(line: 847, column: 1, scope: !1320)
!1530 = !DILocation(line: 4049, column: 24, scope: !1531, inlinedAt: !1532)
!1531 = distinct !DISubprogram(name: "atomic_sub<usize, usize>", linkageName: "_RINvNtNtCsjIpoRzUjyHQ_4core4sync6atomic10atomic_subjjECshxBJAVx362N_11runtime_lab", scope: !46, file: !45, line: 4043, type: !52, scopeLine: 4043, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!1532 = distinct !DILocation(line: 3253, column: 26, scope: !1533, inlinedAt: !1534)
!1533 = distinct !DISubprogram(name: "fetch_sub", linkageName: "_RNvMs1g_NtNtCsjIpoRzUjyHQ_4core4sync6atomicINtB6_6AtomicjE9fetch_sub", scope: !51, file: !45, line: 3251, type: !52, scopeLine: 3251, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!1534 = distinct !DILocation(line: 2868, column: 32, scope: !1535, inlinedAt: !1536)
!1535 = distinct !DISubprogram(name: "drop<(dyn core::ops::function::Fn<(&tokio::runtime::task_hooks::TaskMeta), Output=()> + core::marker::Send + core::marker::Sync), alloc::alloc::Global>", linkageName: "_RNvXsE_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcDG0_INtNtNtCsjIpoRzUjyHQ_4core3ops8function2FnTRL1_INtNtNtCs3EIJ1qnJmKW_5tokio7runtime10task_hooks8TaskMetaL0_EEEp6OutputuNtNtBR_6marker4SendNtB2G_4SyncEL_ENtNtBP_4drop4Drop4dropCshxBJAVx362N_11runtime_lab", scope: !1354, file: !1349, line: 2864, type: !52, scopeLine: 2864, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!1536 = distinct !DILocation(line: 847, column: 1, scope: !1537, inlinedAt: !1538)
!1537 = distinct !DISubprogram(name: "drop_glue<alloc::sync::Arc<(dyn core::ops::function::Fn<(&tokio::runtime::task_hooks::TaskMeta), Output=()> + core::marker::Send + core::marker::Sync), alloc::alloc::Global>>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc4sync3ArcDG0_INtNtNtB4_3ops8function2FnTRL1_INtNtNtCs3EIJ1qnJmKW_5tokio7runtime10task_hooks8TaskMetaL0_EEEp6OutputuNtNtB4_6marker4SendNtB2T_4SyncEL_EECshxBJAVx362N_11runtime_lab", scope: !140, file: !139, line: 847, type: !52, scopeLine: 847, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!1538 = distinct !DILocation(line: 847, column: 1, scope: !1528, inlinedAt: !1529)
!1539 = !{!1540, !1542, !1525}
!1540 = distinct !{!1540, !1541, !"_RNvXsE_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcDG0_INtNtNtCsjIpoRzUjyHQ_4core3ops8function2FnTRL1_INtNtNtCs3EIJ1qnJmKW_5tokio7runtime10task_hooks8TaskMetaL0_EEEp6OutputuNtNtBR_6marker4SendNtB2G_4SyncEL_ENtNtBP_4drop4Drop4dropCshxBJAVx362N_11runtime_lab: %self"}
!1541 = distinct !{!1541, !"_RNvXsE_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcDG0_INtNtNtCsjIpoRzUjyHQ_4core3ops8function2FnTRL1_INtNtNtCs3EIJ1qnJmKW_5tokio7runtime10task_hooks8TaskMetaL0_EEEp6OutputuNtNtBR_6marker4SendNtB2G_4SyncEL_ENtNtBP_4drop4Drop4dropCshxBJAVx362N_11runtime_lab"}
!1542 = distinct !{!1542, !1543, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc4sync3ArcDG0_INtNtNtB4_3ops8function2FnTRL1_INtNtNtCs3EIJ1qnJmKW_5tokio7runtime10task_hooks8TaskMetaL0_EEEp6OutputuNtNtB4_6marker4SendNtB2T_4SyncEL_EECshxBJAVx362N_11runtime_lab: %_1"}
!1543 = distinct !{!1543, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc4sync3ArcDG0_INtNtNtB4_3ops8function2FnTRL1_INtNtNtCs3EIJ1qnJmKW_5tokio7runtime10task_hooks8TaskMetaL0_EEEp6OutputuNtNtB4_6marker4SendNtB2T_4SyncEL_EECshxBJAVx362N_11runtime_lab"}
!1544 = !DILocation(line: 2868, column: 12, scope: !1535, inlinedAt: !1536)
!1545 = !DILocation(line: 4493, column: 24, scope: !1364, inlinedAt: !1546)
!1546 = distinct !DILocation(line: 69, column: 9, scope: !1535, inlinedAt: !1536)
!1547 = !DILocation(line: 2911, column: 18, scope: !1535, inlinedAt: !1536)
!1548 = !{!1549}
!1549 = distinct !{!1549, !1550, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtB4_6option6OptionINtNtCs6zY7rJBZy9D_5alloc4sync3ArcDG0_INtNtNtB4_3ops8function2FnTRL1_INtNtNtCs3EIJ1qnJmKW_5tokio7runtime10task_hooks8TaskMetaL0_EEEp6OutputuNtNtB4_6marker4SendNtB3f_4SyncEL_EEECshxBJAVx362N_11runtime_lab: %_1"}
!1550 = distinct !{!1550, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtB4_6option6OptionINtNtCs6zY7rJBZy9D_5alloc4sync3ArcDG0_INtNtNtB4_3ops8function2FnTRL1_INtNtNtCs3EIJ1qnJmKW_5tokio7runtime10task_hooks8TaskMetaL0_EEEp6OutputuNtNtB4_6marker4SendNtB3f_4SyncEL_EEECshxBJAVx362N_11runtime_lab"}
!1551 = !DILocation(line: 847, column: 1, scope: !1528, inlinedAt: !1552)
!1552 = distinct !DILocation(line: 847, column: 1, scope: !1320)
!1553 = !DILocation(line: 4049, column: 24, scope: !1531, inlinedAt: !1554)
!1554 = distinct !DILocation(line: 3253, column: 26, scope: !1533, inlinedAt: !1555)
!1555 = distinct !DILocation(line: 2868, column: 32, scope: !1535, inlinedAt: !1556)
!1556 = distinct !DILocation(line: 847, column: 1, scope: !1537, inlinedAt: !1557)
!1557 = distinct !DILocation(line: 847, column: 1, scope: !1528, inlinedAt: !1552)
!1558 = !{!1559, !1561, !1549}
!1559 = distinct !{!1559, !1560, !"_RNvXsE_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcDG0_INtNtNtCsjIpoRzUjyHQ_4core3ops8function2FnTRL1_INtNtNtCs3EIJ1qnJmKW_5tokio7runtime10task_hooks8TaskMetaL0_EEEp6OutputuNtNtBR_6marker4SendNtB2G_4SyncEL_ENtNtBP_4drop4Drop4dropCshxBJAVx362N_11runtime_lab: %self"}
!1560 = distinct !{!1560, !"_RNvXsE_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcDG0_INtNtNtCsjIpoRzUjyHQ_4core3ops8function2FnTRL1_INtNtNtCs3EIJ1qnJmKW_5tokio7runtime10task_hooks8TaskMetaL0_EEEp6OutputuNtNtBR_6marker4SendNtB2G_4SyncEL_ENtNtBP_4drop4Drop4dropCshxBJAVx362N_11runtime_lab"}
!1561 = distinct !{!1561, !1562, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc4sync3ArcDG0_INtNtNtB4_3ops8function2FnTRL1_INtNtNtCs3EIJ1qnJmKW_5tokio7runtime10task_hooks8TaskMetaL0_EEEp6OutputuNtNtB4_6marker4SendNtB2T_4SyncEL_EECshxBJAVx362N_11runtime_lab: %_1"}
!1562 = distinct !{!1562, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc4sync3ArcDG0_INtNtNtB4_3ops8function2FnTRL1_INtNtNtCs3EIJ1qnJmKW_5tokio7runtime10task_hooks8TaskMetaL0_EEEp6OutputuNtNtB4_6marker4SendNtB2T_4SyncEL_EECshxBJAVx362N_11runtime_lab"}
!1563 = !DILocation(line: 2868, column: 12, scope: !1535, inlinedAt: !1556)
!1564 = !DILocation(line: 4493, column: 24, scope: !1364, inlinedAt: !1565)
!1565 = distinct !DILocation(line: 69, column: 9, scope: !1535, inlinedAt: !1556)
!1566 = !DILocation(line: 2911, column: 18, scope: !1535, inlinedAt: !1556)
!1567 = !{!1568}
!1568 = distinct !{!1568, !1569, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtB4_6option6OptionINtNtCs6zY7rJBZy9D_5alloc4sync3ArcDG0_INtNtNtB4_3ops8function2FnTRL1_INtNtNtCs3EIJ1qnJmKW_5tokio7runtime10task_hooks8TaskMetaL0_EEEp6OutputuNtNtB4_6marker4SendNtB3f_4SyncEL_EEECshxBJAVx362N_11runtime_lab: %_1"}
!1569 = distinct !{!1569, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtB4_6option6OptionINtNtCs6zY7rJBZy9D_5alloc4sync3ArcDG0_INtNtNtB4_3ops8function2FnTRL1_INtNtNtCs3EIJ1qnJmKW_5tokio7runtime10task_hooks8TaskMetaL0_EEEp6OutputuNtNtB4_6marker4SendNtB3f_4SyncEL_EEECshxBJAVx362N_11runtime_lab"}
!1570 = !DILocation(line: 847, column: 1, scope: !1528, inlinedAt: !1571)
!1571 = distinct !DILocation(line: 847, column: 1, scope: !1320)
!1572 = !DILocation(line: 4049, column: 24, scope: !1531, inlinedAt: !1573)
!1573 = distinct !DILocation(line: 3253, column: 26, scope: !1533, inlinedAt: !1574)
!1574 = distinct !DILocation(line: 2868, column: 32, scope: !1535, inlinedAt: !1575)
!1575 = distinct !DILocation(line: 847, column: 1, scope: !1537, inlinedAt: !1576)
!1576 = distinct !DILocation(line: 847, column: 1, scope: !1528, inlinedAt: !1571)
!1577 = !{!1578, !1580, !1568}
!1578 = distinct !{!1578, !1579, !"_RNvXsE_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcDG0_INtNtNtCsjIpoRzUjyHQ_4core3ops8function2FnTRL1_INtNtNtCs3EIJ1qnJmKW_5tokio7runtime10task_hooks8TaskMetaL0_EEEp6OutputuNtNtBR_6marker4SendNtB2G_4SyncEL_ENtNtBP_4drop4Drop4dropCshxBJAVx362N_11runtime_lab: %self"}
!1579 = distinct !{!1579, !"_RNvXsE_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcDG0_INtNtNtCsjIpoRzUjyHQ_4core3ops8function2FnTRL1_INtNtNtCs3EIJ1qnJmKW_5tokio7runtime10task_hooks8TaskMetaL0_EEEp6OutputuNtNtBR_6marker4SendNtB2G_4SyncEL_ENtNtBP_4drop4Drop4dropCshxBJAVx362N_11runtime_lab"}
!1580 = distinct !{!1580, !1581, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc4sync3ArcDG0_INtNtNtB4_3ops8function2FnTRL1_INtNtNtCs3EIJ1qnJmKW_5tokio7runtime10task_hooks8TaskMetaL0_EEEp6OutputuNtNtB4_6marker4SendNtB2T_4SyncEL_EECshxBJAVx362N_11runtime_lab: %_1"}
!1581 = distinct !{!1581, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc4sync3ArcDG0_INtNtNtB4_3ops8function2FnTRL1_INtNtNtCs3EIJ1qnJmKW_5tokio7runtime10task_hooks8TaskMetaL0_EEEp6OutputuNtNtB4_6marker4SendNtB2T_4SyncEL_EECshxBJAVx362N_11runtime_lab"}
!1582 = !DILocation(line: 2868, column: 12, scope: !1535, inlinedAt: !1575)
!1583 = !DILocation(line: 4493, column: 24, scope: !1364, inlinedAt: !1584)
!1584 = distinct !DILocation(line: 69, column: 9, scope: !1535, inlinedAt: !1575)
!1585 = !DILocation(line: 2911, column: 18, scope: !1535, inlinedAt: !1575)
!1586 = !{!1587}
!1587 = distinct !{!1587, !1588, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtB4_6option6OptionINtNtCs6zY7rJBZy9D_5alloc4sync3ArcDG0_INtNtNtB4_3ops8function2FnTRL1_INtNtNtCs3EIJ1qnJmKW_5tokio7runtime10task_hooks8TaskMetaL0_EEEp6OutputuNtNtB4_6marker4SendNtB3f_4SyncEL_EEECshxBJAVx362N_11runtime_lab: %_1"}
!1588 = distinct !{!1588, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtB4_6option6OptionINtNtCs6zY7rJBZy9D_5alloc4sync3ArcDG0_INtNtNtB4_3ops8function2FnTRL1_INtNtNtCs3EIJ1qnJmKW_5tokio7runtime10task_hooks8TaskMetaL0_EEEp6OutputuNtNtB4_6marker4SendNtB3f_4SyncEL_EEECshxBJAVx362N_11runtime_lab"}
!1589 = !DILocation(line: 847, column: 1, scope: !1528, inlinedAt: !1590)
!1590 = distinct !DILocation(line: 847, column: 1, scope: !1320)
!1591 = !DILocation(line: 4049, column: 24, scope: !1531, inlinedAt: !1592)
!1592 = distinct !DILocation(line: 3253, column: 26, scope: !1533, inlinedAt: !1593)
!1593 = distinct !DILocation(line: 2868, column: 32, scope: !1535, inlinedAt: !1594)
!1594 = distinct !DILocation(line: 847, column: 1, scope: !1537, inlinedAt: !1595)
!1595 = distinct !DILocation(line: 847, column: 1, scope: !1528, inlinedAt: !1590)
!1596 = !{!1597, !1599, !1587}
!1597 = distinct !{!1597, !1598, !"_RNvXsE_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcDG0_INtNtNtCsjIpoRzUjyHQ_4core3ops8function2FnTRL1_INtNtNtCs3EIJ1qnJmKW_5tokio7runtime10task_hooks8TaskMetaL0_EEEp6OutputuNtNtBR_6marker4SendNtB2G_4SyncEL_ENtNtBP_4drop4Drop4dropCshxBJAVx362N_11runtime_lab: %self"}
!1598 = distinct !{!1598, !"_RNvXsE_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcDG0_INtNtNtCsjIpoRzUjyHQ_4core3ops8function2FnTRL1_INtNtNtCs3EIJ1qnJmKW_5tokio7runtime10task_hooks8TaskMetaL0_EEEp6OutputuNtNtBR_6marker4SendNtB2G_4SyncEL_ENtNtBP_4drop4Drop4dropCshxBJAVx362N_11runtime_lab"}
!1599 = distinct !{!1599, !1600, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc4sync3ArcDG0_INtNtNtB4_3ops8function2FnTRL1_INtNtNtCs3EIJ1qnJmKW_5tokio7runtime10task_hooks8TaskMetaL0_EEEp6OutputuNtNtB4_6marker4SendNtB2T_4SyncEL_EECshxBJAVx362N_11runtime_lab: %_1"}
!1600 = distinct !{!1600, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc4sync3ArcDG0_INtNtNtB4_3ops8function2FnTRL1_INtNtNtCs3EIJ1qnJmKW_5tokio7runtime10task_hooks8TaskMetaL0_EEEp6OutputuNtNtB4_6marker4SendNtB2T_4SyncEL_EECshxBJAVx362N_11runtime_lab"}
!1601 = !DILocation(line: 2868, column: 12, scope: !1535, inlinedAt: !1594)
!1602 = !DILocation(line: 4493, column: 24, scope: !1364, inlinedAt: !1603)
!1603 = distinct !DILocation(line: 69, column: 9, scope: !1535, inlinedAt: !1594)
!1604 = !DILocation(line: 2911, column: 18, scope: !1535, inlinedAt: !1594)
!1605 = !DILocation(line: 847, column: 1, scope: !1606, inlinedAt: !1607)
!1606 = distinct !DISubprogram(name: "drop_glue<std::sys::sync::mutex::pthread::Mutex>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtNtNtNtCs1SSuMAdGM58_3std3sys4sync5mutex7pthread5MutexECshxBJAVx362N_11runtime_lab", scope: !140, file: !139, line: 847, type: !52, scopeLine: 847, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!1607 = distinct !DILocation(line: 847, column: 1, scope: !1608, inlinedAt: !1609)
!1608 = distinct !DISubprogram(name: "drop_glue<std::sync::poison::mutex::Mutex<tokio::util::rand::FastRand>>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtNtCs1SSuMAdGM58_3std4sync6poison5mutex5MutexNtNtNtCs3EIJ1qnJmKW_5tokio4util4rand8FastRandEECshxBJAVx362N_11runtime_lab", scope: !140, file: !139, line: 847, type: !52, scopeLine: 847, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!1609 = distinct !DILocation(line: 847, column: 1, scope: !1610, inlinedAt: !1611)
!1610 = distinct !DISubprogram(name: "drop_glue<tokio::util::rand::rt::RngSeedGenerator>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtNtNtCs3EIJ1qnJmKW_5tokio4util4rand2rt16RngSeedGeneratorECshxBJAVx362N_11runtime_lab", scope: !140, file: !139, line: 847, type: !52, scopeLine: 847, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!1611 = distinct !DILocation(line: 847, column: 1, scope: !1320)
!1612 = !{!1613}
!1613 = distinct !{!1613, !1614, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtNtCs1SSuMAdGM58_3std3sys4sync8once_box7OnceBoxNtNtNtNtNtBI_3pal4unix4sync5mutex5MutexEECshxBJAVx362N_11runtime_lab: %_1"}
!1614 = distinct !{!1614, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtNtCs1SSuMAdGM58_3std3sys4sync8once_box7OnceBoxNtNtNtNtNtBI_3pal4unix4sync5mutex5MutexEECshxBJAVx362N_11runtime_lab"}
!1615 = !{!1616}
!1616 = distinct !{!1616, !1617, !"_RNvXs1_NtNtNtCs1SSuMAdGM58_3std3sys4sync8once_boxINtB5_7OnceBoxNtNtNtNtNtB9_3pal4unix4sync5mutex5MutexENtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4dropCshxBJAVx362N_11runtime_lab: %self"}
!1617 = distinct !{!1617, !"_RNvXs1_NtNtNtCs1SSuMAdGM58_3std3sys4sync8once_boxINtB5_7OnceBoxNtNtNtNtNtB9_3pal4unix4sync5mutex5MutexENtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4dropCshxBJAVx362N_11runtime_lab"}
!1618 = !DILocation(line: 847, column: 1, scope: !841, inlinedAt: !1619)
!1619 = distinct !DILocation(line: 847, column: 1, scope: !1606, inlinedAt: !1607)
!1620 = !DILocation(line: 975, column: 22, scope: !848, inlinedAt: !1621)
!1621 = distinct !DILocation(line: 57, column: 19, scope: !850, inlinedAt: !1622)
!1622 = distinct !DILocation(line: 81, column: 14, scope: !852, inlinedAt: !1623)
!1623 = distinct !DILocation(line: 847, column: 1, scope: !841, inlinedAt: !1619)
!1624 = !{!1616, !1613, !1625, !1627, !1629}
!1625 = distinct !{!1625, !1626, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtNtNtNtCs1SSuMAdGM58_3std3sys4sync5mutex7pthread5MutexECshxBJAVx362N_11runtime_lab: %_1"}
!1626 = distinct !{!1626, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtNtNtNtCs1SSuMAdGM58_3std3sys4sync5mutex7pthread5MutexECshxBJAVx362N_11runtime_lab"}
!1627 = distinct !{!1627, !1628, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtNtCs1SSuMAdGM58_3std4sync6poison5mutex5MutexNtNtNtCs3EIJ1qnJmKW_5tokio4util4rand8FastRandEECshxBJAVx362N_11runtime_lab: %_1"}
!1628 = distinct !{!1628, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtNtCs1SSuMAdGM58_3std4sync6poison5mutex5MutexNtNtNtCs3EIJ1qnJmKW_5tokio4util4rand8FastRandEECshxBJAVx362N_11runtime_lab"}
!1629 = distinct !{!1629, !1630, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtNtNtCs3EIJ1qnJmKW_5tokio4util4rand2rt16RngSeedGeneratorECshxBJAVx362N_11runtime_lab: %_1"}
!1630 = distinct !{!1630, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtNtNtCs3EIJ1qnJmKW_5tokio4util4rand2rt16RngSeedGeneratorECshxBJAVx362N_11runtime_lab"}
!1631 = !DILocation(line: 976, column: 49, scope: !856, inlinedAt: !1621)
!1632 = !DILocation(line: 38, column: 17, scope: !858, inlinedAt: !1633)
!1633 = distinct !DILocation(line: 2636, column: 9, scope: !861, inlinedAt: !1634)
!1634 = distinct !DILocation(line: 23, column: 27, scope: !865, inlinedAt: !1635)
!1635 = distinct !DILocation(line: 58, column: 17, scope: !867, inlinedAt: !1622)
!1636 = !DILocation(line: 847, column: 1, scope: !869, inlinedAt: !1637)
!1637 = distinct !DILocation(line: 81, column: 20, scope: !852, inlinedAt: !1623)
!1638 = !DILocation(line: 847, column: 1, scope: !138, inlinedAt: !1639)
!1639 = distinct !DILocation(line: 847, column: 1, scope: !160, inlinedAt: !1640)
!1640 = distinct !DILocation(line: 847, column: 1, scope: !196, inlinedAt: !1641)
!1641 = distinct !DILocation(line: 847, column: 1, scope: !869, inlinedAt: !1637)
!1642 = !{!1616, !1613}
!1643 = !DILocation(line: 175, column: 14, scope: !168, inlinedAt: !1644)
!1644 = distinct !DILocation(line: 321, column: 22, scope: !170, inlinedAt: !1645)
!1645 = distinct !DILocation(line: 436, column: 9, scope: !172, inlinedAt: !1646)
!1646 = distinct !DILocation(line: 554, column: 23, scope: !174, inlinedAt: !1647)
!1647 = distinct !DILocation(line: 2000, column: 24, scope: !176, inlinedAt: !1648)
!1648 = distinct !DILocation(line: 847, column: 1, scope: !160, inlinedAt: !1640)
!1649 = !DILocation(line: 847, column: 1, scope: !160, inlinedAt: !1640)
!1650 = !DILocation(line: 175, column: 14, scope: !168, inlinedAt: !1651)
!1651 = distinct !DILocation(line: 321, column: 22, scope: !170, inlinedAt: !1652)
!1652 = distinct !DILocation(line: 436, column: 9, scope: !172, inlinedAt: !1653)
!1653 = distinct !DILocation(line: 554, column: 23, scope: !174, inlinedAt: !1654)
!1654 = distinct !DILocation(line: 2000, column: 24, scope: !176, inlinedAt: !1655)
!1655 = distinct !DILocation(line: 847, column: 1, scope: !160, inlinedAt: !1640)
!1656 = distinct !DISubprogram(name: "drop_glue<tokio::runtime::scheduler::Handle>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtNtCs3EIJ1qnJmKW_5tokio7runtime9scheduler6HandleECshxBJAVx362N_11runtime_lab", scope: !140, file: !139, line: 847, type: !52, scopeLine: 847, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!1657 = !{i64 -2876470403330276452}
!1658 = !DILocation(line: 847, column: 1, scope: !1656)
!1659 = !{i64 0, i64 2}
!1660 = !{!1661}
!1661 = distinct !{!1661, !1662, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc4sync3ArcNtNtNtNtCs3EIJ1qnJmKW_5tokio7runtime9scheduler14current_thread6HandleEECshxBJAVx362N_11runtime_lab: %_1"}
!1662 = distinct !{!1662, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc4sync3ArcNtNtNtNtCs3EIJ1qnJmKW_5tokio7runtime9scheduler14current_thread6HandleEECshxBJAVx362N_11runtime_lab"}
!1663 = !{!1664}
!1664 = distinct !{!1664, !1665, !"_RNvXsE_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcNtNtNtNtCs3EIJ1qnJmKW_5tokio7runtime9scheduler14current_thread6HandleENtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4dropCshxBJAVx362N_11runtime_lab: %self"}
!1665 = distinct !{!1665, !"_RNvXsE_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcNtNtNtNtCs3EIJ1qnJmKW_5tokio7runtime9scheduler14current_thread6HandleENtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4dropCshxBJAVx362N_11runtime_lab"}
!1666 = !DILocation(line: 847, column: 1, scope: !1667, inlinedAt: !1668)
!1667 = distinct !DISubprogram(name: "drop_glue<alloc::sync::Arc<tokio::runtime::scheduler::current_thread::Handle, alloc::alloc::Global>>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc4sync3ArcNtNtNtNtCs3EIJ1qnJmKW_5tokio7runtime9scheduler14current_thread6HandleEECshxBJAVx362N_11runtime_lab", scope: !140, file: !139, line: 847, type: !52, scopeLine: 847, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!1668 = distinct !DILocation(line: 847, column: 1, scope: !1656)
!1669 = !DILocation(line: 454, column: 20, scope: !1670, inlinedAt: !1671)
!1670 = distinct !DISubprogram(name: "as_ref<alloc::sync::ArcInner<tokio::runtime::scheduler::current_thread::Handle>>", linkageName: "_RNvMs1_NtNtCsjIpoRzUjyHQ_4core3ptr8non_nullINtB5_7NonNullINtNtCs6zY7rJBZy9D_5alloc4sync8ArcInnerNtNtNtNtCs3EIJ1qnJmKW_5tokio7runtime9scheduler14current_thread6HandleEE6as_refCshxBJAVx362N_11runtime_lab", scope: !599, file: !598, line: 450, type: !52, scopeLine: 450, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!1671 = distinct !DILocation(line: 2133, column: 27, scope: !1672, inlinedAt: !1673)
!1672 = distinct !DISubprogram(name: "inner<tokio::runtime::scheduler::current_thread::Handle, alloc::alloc::Global>", linkageName: "_RNvMsn_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcNtNtNtNtCs3EIJ1qnJmKW_5tokio7runtime9scheduler14current_thread6HandleE5innerCshxBJAVx362N_11runtime_lab", scope: !1350, file: !1349, line: 2127, type: !52, scopeLine: 2127, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!1673 = distinct !DILocation(line: 2868, column: 17, scope: !1674, inlinedAt: !1675)
!1674 = distinct !DISubprogram(name: "drop<tokio::runtime::scheduler::current_thread::Handle, alloc::alloc::Global>", linkageName: "_RNvXsE_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcNtNtNtNtCs3EIJ1qnJmKW_5tokio7runtime9scheduler14current_thread6HandleENtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4dropCshxBJAVx362N_11runtime_lab", scope: !1354, file: !1349, line: 2864, type: !52, scopeLine: 2864, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!1675 = distinct !DILocation(line: 847, column: 1, scope: !1667, inlinedAt: !1668)
!1676 = !{!1664, !1661}
!1677 = !DILocation(line: 4049, column: 24, scope: !1678, inlinedAt: !1679)
!1678 = distinct !DISubprogram(name: "atomic_sub<usize, usize>", linkageName: "_RINvNtNtCsjIpoRzUjyHQ_4core4sync6atomic10atomic_subjjECshxBJAVx362N_11runtime_lab", scope: !46, file: !45, line: 4043, type: !52, scopeLine: 4043, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!1679 = distinct !DILocation(line: 3253, column: 26, scope: !1680, inlinedAt: !1681)
!1680 = distinct !DISubprogram(name: "fetch_sub", linkageName: "_RNvMs1g_NtNtCsjIpoRzUjyHQ_4core4sync6atomicINtB6_6AtomicjE9fetch_sub", scope: !51, file: !45, line: 3251, type: !52, scopeLine: 3251, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!1681 = distinct !DILocation(line: 2868, column: 32, scope: !1674, inlinedAt: !1675)
!1682 = !DILocation(line: 2868, column: 12, scope: !1674, inlinedAt: !1675)
!1683 = !DILocation(line: 4493, column: 24, scope: !1364, inlinedAt: !1684)
!1684 = distinct !DILocation(line: 69, column: 9, scope: !1674, inlinedAt: !1675)
!1685 = !DILocation(line: 2911, column: 18, scope: !1674, inlinedAt: !1675)
!1686 = !{!1687}
!1687 = distinct !{!1687, !1688, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc4sync3ArcNtNtNtNtNtCs3EIJ1qnJmKW_5tokio7runtime9scheduler12multi_thread6handle6HandleEECshxBJAVx362N_11runtime_lab: %_1"}
!1688 = distinct !{!1688, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc4sync3ArcNtNtNtNtNtCs3EIJ1qnJmKW_5tokio7runtime9scheduler12multi_thread6handle6HandleEECshxBJAVx362N_11runtime_lab"}
!1689 = !{!1690}
!1690 = distinct !{!1690, !1691, !"_RNvXsE_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcNtNtNtNtNtCs3EIJ1qnJmKW_5tokio7runtime9scheduler12multi_thread6handle6HandleENtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4dropCshxBJAVx362N_11runtime_lab: %self"}
!1691 = distinct !{!1691, !"_RNvXsE_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcNtNtNtNtNtCs3EIJ1qnJmKW_5tokio7runtime9scheduler12multi_thread6handle6HandleENtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4dropCshxBJAVx362N_11runtime_lab"}
!1692 = !DILocation(line: 847, column: 1, scope: !1693, inlinedAt: !1694)
!1693 = distinct !DISubprogram(name: "drop_glue<alloc::sync::Arc<tokio::runtime::scheduler::multi_thread::handle::Handle, alloc::alloc::Global>>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc4sync3ArcNtNtNtNtNtCs3EIJ1qnJmKW_5tokio7runtime9scheduler12multi_thread6handle6HandleEECshxBJAVx362N_11runtime_lab", scope: !140, file: !139, line: 847, type: !52, scopeLine: 847, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!1694 = distinct !DILocation(line: 847, column: 1, scope: !1656)
!1695 = !DILocation(line: 454, column: 20, scope: !1696, inlinedAt: !1697)
!1696 = distinct !DISubprogram(name: "as_ref<alloc::sync::ArcInner<tokio::runtime::scheduler::multi_thread::handle::Handle>>", linkageName: "_RNvMs1_NtNtCsjIpoRzUjyHQ_4core3ptr8non_nullINtB5_7NonNullINtNtCs6zY7rJBZy9D_5alloc4sync8ArcInnerNtNtNtNtNtCs3EIJ1qnJmKW_5tokio7runtime9scheduler12multi_thread6handle6HandleEE6as_refCshxBJAVx362N_11runtime_lab", scope: !599, file: !598, line: 450, type: !52, scopeLine: 450, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!1697 = distinct !DILocation(line: 2133, column: 27, scope: !1698, inlinedAt: !1699)
!1698 = distinct !DISubprogram(name: "inner<tokio::runtime::scheduler::multi_thread::handle::Handle, alloc::alloc::Global>", linkageName: "_RNvMsn_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcNtNtNtNtNtCs3EIJ1qnJmKW_5tokio7runtime9scheduler12multi_thread6handle6HandleE5innerCshxBJAVx362N_11runtime_lab", scope: !1350, file: !1349, line: 2127, type: !52, scopeLine: 2127, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!1699 = distinct !DILocation(line: 2868, column: 17, scope: !1700, inlinedAt: !1701)
!1700 = distinct !DISubprogram(name: "drop<tokio::runtime::scheduler::multi_thread::handle::Handle, alloc::alloc::Global>", linkageName: "_RNvXsE_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcNtNtNtNtNtCs3EIJ1qnJmKW_5tokio7runtime9scheduler12multi_thread6handle6HandleENtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4dropCshxBJAVx362N_11runtime_lab", scope: !1354, file: !1349, line: 2864, type: !52, scopeLine: 2864, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!1701 = distinct !DILocation(line: 847, column: 1, scope: !1693, inlinedAt: !1694)
!1702 = !{!1690, !1687}
!1703 = !DILocation(line: 4049, column: 24, scope: !1704, inlinedAt: !1705)
!1704 = distinct !DISubprogram(name: "atomic_sub<usize, usize>", linkageName: "_RINvNtNtCsjIpoRzUjyHQ_4core4sync6atomic10atomic_subjjECshxBJAVx362N_11runtime_lab", scope: !46, file: !45, line: 4043, type: !52, scopeLine: 4043, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!1705 = distinct !DILocation(line: 3253, column: 26, scope: !1706, inlinedAt: !1707)
!1706 = distinct !DISubprogram(name: "fetch_sub", linkageName: "_RNvMs1g_NtNtCsjIpoRzUjyHQ_4core4sync6atomicINtB6_6AtomicjE9fetch_sub", scope: !51, file: !45, line: 3251, type: !52, scopeLine: 3251, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!1707 = distinct !DILocation(line: 2868, column: 32, scope: !1700, inlinedAt: !1701)
!1708 = !DILocation(line: 2868, column: 12, scope: !1700, inlinedAt: !1701)
!1709 = !DILocation(line: 4493, column: 24, scope: !1364, inlinedAt: !1710)
!1710 = distinct !DILocation(line: 69, column: 9, scope: !1700, inlinedAt: !1701)
!1711 = !DILocation(line: 2911, column: 18, scope: !1700, inlinedAt: !1701)
!1712 = !{i64 8921626269426856984}
!1713 = !DILocation(line: 847, column: 1, scope: !1606, inlinedAt: !1714)
!1714 = distinct !DILocation(line: 847, column: 1, scope: !1608, inlinedAt: !1715)
!1715 = distinct !DILocation(line: 847, column: 1, scope: !1610)
!1716 = !{!1717}
!1717 = distinct !{!1717, !1718, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtNtCs1SSuMAdGM58_3std3sys4sync8once_box7OnceBoxNtNtNtNtNtBI_3pal4unix4sync5mutex5MutexEECshxBJAVx362N_11runtime_lab: %_1"}
!1718 = distinct !{!1718, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtNtCs1SSuMAdGM58_3std3sys4sync8once_box7OnceBoxNtNtNtNtNtBI_3pal4unix4sync5mutex5MutexEECshxBJAVx362N_11runtime_lab"}
!1719 = !{!1720}
!1720 = distinct !{!1720, !1721, !"_RNvXs1_NtNtNtCs1SSuMAdGM58_3std3sys4sync8once_boxINtB5_7OnceBoxNtNtNtNtNtB9_3pal4unix4sync5mutex5MutexENtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4dropCshxBJAVx362N_11runtime_lab: %self"}
!1721 = distinct !{!1721, !"_RNvXs1_NtNtNtCs1SSuMAdGM58_3std3sys4sync8once_boxINtB5_7OnceBoxNtNtNtNtNtB9_3pal4unix4sync5mutex5MutexENtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4dropCshxBJAVx362N_11runtime_lab"}
!1722 = !DILocation(line: 847, column: 1, scope: !841, inlinedAt: !1723)
!1723 = distinct !DILocation(line: 847, column: 1, scope: !1606, inlinedAt: !1714)
!1724 = !DILocation(line: 975, column: 22, scope: !848, inlinedAt: !1725)
!1725 = distinct !DILocation(line: 57, column: 19, scope: !850, inlinedAt: !1726)
!1726 = distinct !DILocation(line: 81, column: 14, scope: !852, inlinedAt: !1727)
!1727 = distinct !DILocation(line: 847, column: 1, scope: !841, inlinedAt: !1723)
!1728 = !{!1720, !1717, !1729, !1731}
!1729 = distinct !{!1729, !1730, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtNtNtNtCs1SSuMAdGM58_3std3sys4sync5mutex7pthread5MutexECshxBJAVx362N_11runtime_lab: %_1"}
!1730 = distinct !{!1730, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtNtNtNtCs1SSuMAdGM58_3std3sys4sync5mutex7pthread5MutexECshxBJAVx362N_11runtime_lab"}
!1731 = distinct !{!1731, !1732, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtNtCs1SSuMAdGM58_3std4sync6poison5mutex5MutexNtNtNtCs3EIJ1qnJmKW_5tokio4util4rand8FastRandEECshxBJAVx362N_11runtime_lab: %_1"}
!1732 = distinct !{!1732, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtNtCs1SSuMAdGM58_3std4sync6poison5mutex5MutexNtNtNtCs3EIJ1qnJmKW_5tokio4util4rand8FastRandEECshxBJAVx362N_11runtime_lab"}
!1733 = !DILocation(line: 976, column: 49, scope: !856, inlinedAt: !1725)
!1734 = !DILocation(line: 38, column: 17, scope: !858, inlinedAt: !1735)
!1735 = distinct !DILocation(line: 2636, column: 9, scope: !861, inlinedAt: !1736)
!1736 = distinct !DILocation(line: 23, column: 27, scope: !865, inlinedAt: !1737)
!1737 = distinct !DILocation(line: 58, column: 17, scope: !867, inlinedAt: !1726)
!1738 = !DILocation(line: 847, column: 1, scope: !869, inlinedAt: !1739)
!1739 = distinct !DILocation(line: 81, column: 20, scope: !852, inlinedAt: !1727)
!1740 = !DILocation(line: 847, column: 1, scope: !138, inlinedAt: !1741)
!1741 = distinct !DILocation(line: 847, column: 1, scope: !160, inlinedAt: !1742)
!1742 = distinct !DILocation(line: 847, column: 1, scope: !196, inlinedAt: !1743)
!1743 = distinct !DILocation(line: 847, column: 1, scope: !869, inlinedAt: !1739)
!1744 = !{!1720, !1717}
!1745 = !DILocation(line: 175, column: 14, scope: !168, inlinedAt: !1746)
!1746 = distinct !DILocation(line: 321, column: 22, scope: !170, inlinedAt: !1747)
!1747 = distinct !DILocation(line: 436, column: 9, scope: !172, inlinedAt: !1748)
!1748 = distinct !DILocation(line: 554, column: 23, scope: !174, inlinedAt: !1749)
!1749 = distinct !DILocation(line: 2000, column: 24, scope: !176, inlinedAt: !1750)
!1750 = distinct !DILocation(line: 847, column: 1, scope: !160, inlinedAt: !1742)
!1751 = !DILocation(line: 847, column: 1, scope: !160, inlinedAt: !1742)
!1752 = !DILocation(line: 175, column: 14, scope: !168, inlinedAt: !1753)
!1753 = distinct !DILocation(line: 321, column: 22, scope: !170, inlinedAt: !1754)
!1754 = distinct !DILocation(line: 436, column: 9, scope: !172, inlinedAt: !1755)
!1755 = distinct !DILocation(line: 554, column: 23, scope: !174, inlinedAt: !1756)
!1756 = distinct !DILocation(line: 2000, column: 24, scope: !176, inlinedAt: !1757)
!1757 = distinct !DILocation(line: 847, column: 1, scope: !160, inlinedAt: !1742)
!1758 = !DILocation(line: 847, column: 1, scope: !1610)
!1759 = distinct !DISubprogram(name: "drop_glue<tokio::runtime::io::registration::Registration>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtNtNtCs3EIJ1qnJmKW_5tokio7runtime2io12registration12RegistrationECshxBJAVx362N_11runtime_lab", scope: !140, file: !139, line: 847, type: !52, scopeLine: 847, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!1760 = !{i64 -3460779292917948527}
!1761 = !DILocation(line: 847, column: 1, scope: !1759)
!1762 = !{!1763}
!1763 = distinct !{!1763, !1764, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtNtCs3EIJ1qnJmKW_5tokio7runtime9scheduler6HandleECshxBJAVx362N_11runtime_lab: %_1"}
!1764 = distinct !{!1764, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtNtCs3EIJ1qnJmKW_5tokio7runtime9scheduler6HandleECshxBJAVx362N_11runtime_lab"}
!1765 = !DILocation(line: 847, column: 1, scope: !1656, inlinedAt: !1766)
!1766 = distinct !DILocation(line: 847, column: 1, scope: !1759)
!1767 = !{!1768}
!1768 = distinct !{!1768, !1769, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc4sync3ArcNtNtNtNtCs3EIJ1qnJmKW_5tokio7runtime9scheduler14current_thread6HandleEECshxBJAVx362N_11runtime_lab: %_1"}
!1769 = distinct !{!1769, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc4sync3ArcNtNtNtNtCs3EIJ1qnJmKW_5tokio7runtime9scheduler14current_thread6HandleEECshxBJAVx362N_11runtime_lab"}
!1770 = !{!1771}
!1771 = distinct !{!1771, !1772, !"_RNvXsE_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcNtNtNtNtCs3EIJ1qnJmKW_5tokio7runtime9scheduler14current_thread6HandleENtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4dropCshxBJAVx362N_11runtime_lab: %self"}
!1772 = distinct !{!1772, !"_RNvXsE_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcNtNtNtNtCs3EIJ1qnJmKW_5tokio7runtime9scheduler14current_thread6HandleENtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4dropCshxBJAVx362N_11runtime_lab"}
!1773 = !DILocation(line: 847, column: 1, scope: !1667, inlinedAt: !1774)
!1774 = distinct !DILocation(line: 847, column: 1, scope: !1656, inlinedAt: !1766)
!1775 = !DILocation(line: 454, column: 20, scope: !1670, inlinedAt: !1776)
!1776 = distinct !DILocation(line: 2133, column: 27, scope: !1672, inlinedAt: !1777)
!1777 = distinct !DILocation(line: 2868, column: 17, scope: !1674, inlinedAt: !1778)
!1778 = distinct !DILocation(line: 847, column: 1, scope: !1667, inlinedAt: !1774)
!1779 = !{!1771, !1768, !1763}
!1780 = !DILocation(line: 4049, column: 24, scope: !1678, inlinedAt: !1781)
!1781 = distinct !DILocation(line: 3253, column: 26, scope: !1680, inlinedAt: !1782)
!1782 = distinct !DILocation(line: 2868, column: 32, scope: !1674, inlinedAt: !1778)
!1783 = !DILocation(line: 2868, column: 12, scope: !1674, inlinedAt: !1778)
!1784 = !DILocation(line: 4493, column: 24, scope: !1364, inlinedAt: !1785)
!1785 = distinct !DILocation(line: 69, column: 9, scope: !1674, inlinedAt: !1778)
!1786 = !DILocation(line: 2911, column: 18, scope: !1674, inlinedAt: !1778)
!1787 = !{!1788}
!1788 = distinct !{!1788, !1789, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc4sync3ArcNtNtNtNtNtCs3EIJ1qnJmKW_5tokio7runtime9scheduler12multi_thread6handle6HandleEECshxBJAVx362N_11runtime_lab: %_1"}
!1789 = distinct !{!1789, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc4sync3ArcNtNtNtNtNtCs3EIJ1qnJmKW_5tokio7runtime9scheduler12multi_thread6handle6HandleEECshxBJAVx362N_11runtime_lab"}
!1790 = !{!1791}
!1791 = distinct !{!1791, !1792, !"_RNvXsE_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcNtNtNtNtNtCs3EIJ1qnJmKW_5tokio7runtime9scheduler12multi_thread6handle6HandleENtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4dropCshxBJAVx362N_11runtime_lab: %self"}
!1792 = distinct !{!1792, !"_RNvXsE_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcNtNtNtNtNtCs3EIJ1qnJmKW_5tokio7runtime9scheduler12multi_thread6handle6HandleENtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4dropCshxBJAVx362N_11runtime_lab"}
!1793 = !DILocation(line: 847, column: 1, scope: !1693, inlinedAt: !1794)
!1794 = distinct !DILocation(line: 847, column: 1, scope: !1656, inlinedAt: !1766)
!1795 = !DILocation(line: 454, column: 20, scope: !1696, inlinedAt: !1796)
!1796 = distinct !DILocation(line: 2133, column: 27, scope: !1698, inlinedAt: !1797)
!1797 = distinct !DILocation(line: 2868, column: 17, scope: !1700, inlinedAt: !1798)
!1798 = distinct !DILocation(line: 847, column: 1, scope: !1693, inlinedAt: !1794)
!1799 = !{!1791, !1788, !1763}
!1800 = !DILocation(line: 4049, column: 24, scope: !1704, inlinedAt: !1801)
!1801 = distinct !DILocation(line: 3253, column: 26, scope: !1706, inlinedAt: !1802)
!1802 = distinct !DILocation(line: 2868, column: 32, scope: !1700, inlinedAt: !1798)
!1803 = !DILocation(line: 2868, column: 12, scope: !1700, inlinedAt: !1798)
!1804 = !DILocation(line: 4493, column: 24, scope: !1364, inlinedAt: !1805)
!1805 = distinct !DILocation(line: 69, column: 9, scope: !1700, inlinedAt: !1798)
!1806 = !DILocation(line: 2911, column: 18, scope: !1700, inlinedAt: !1798)
!1807 = !{!1808}
!1808 = distinct !{!1808, !1809, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc4sync3ArcNtNtNtNtCs3EIJ1qnJmKW_5tokio7runtime2io12scheduled_io11ScheduledIoEECshxBJAVx362N_11runtime_lab: %_1"}
!1809 = distinct !{!1809, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc4sync3ArcNtNtNtNtCs3EIJ1qnJmKW_5tokio7runtime2io12scheduled_io11ScheduledIoEECshxBJAVx362N_11runtime_lab"}
!1810 = !{!1811}
!1811 = distinct !{!1811, !1812, !"_RNvXsE_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcNtNtNtNtCs3EIJ1qnJmKW_5tokio7runtime2io12scheduled_io11ScheduledIoENtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4dropCshxBJAVx362N_11runtime_lab: %self"}
!1812 = distinct !{!1812, !"_RNvXsE_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcNtNtNtNtCs3EIJ1qnJmKW_5tokio7runtime2io12scheduled_io11ScheduledIoENtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4dropCshxBJAVx362N_11runtime_lab"}
!1813 = !DILocation(line: 847, column: 1, scope: !1814, inlinedAt: !1815)
!1814 = distinct !DISubprogram(name: "drop_glue<alloc::sync::Arc<tokio::runtime::io::scheduled_io::ScheduledIo, alloc::alloc::Global>>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc4sync3ArcNtNtNtNtCs3EIJ1qnJmKW_5tokio7runtime2io12scheduled_io11ScheduledIoEECshxBJAVx362N_11runtime_lab", scope: !140, file: !139, line: 847, type: !52, scopeLine: 847, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!1815 = distinct !DILocation(line: 847, column: 1, scope: !1759)
!1816 = !DILocation(line: 454, column: 20, scope: !1817, inlinedAt: !1818)
!1817 = distinct !DISubprogram(name: "as_ref<alloc::sync::ArcInner<tokio::runtime::io::scheduled_io::ScheduledIo>>", linkageName: "_RNvMs1_NtNtCsjIpoRzUjyHQ_4core3ptr8non_nullINtB5_7NonNullINtNtCs6zY7rJBZy9D_5alloc4sync8ArcInnerNtNtNtNtCs3EIJ1qnJmKW_5tokio7runtime2io12scheduled_io11ScheduledIoEE6as_refCshxBJAVx362N_11runtime_lab", scope: !599, file: !598, line: 450, type: !52, scopeLine: 450, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!1818 = distinct !DILocation(line: 2133, column: 27, scope: !1819, inlinedAt: !1820)
!1819 = distinct !DISubprogram(name: "inner<tokio::runtime::io::scheduled_io::ScheduledIo, alloc::alloc::Global>", linkageName: "_RNvMsn_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcNtNtNtNtCs3EIJ1qnJmKW_5tokio7runtime2io12scheduled_io11ScheduledIoE5innerCshxBJAVx362N_11runtime_lab", scope: !1350, file: !1349, line: 2127, type: !52, scopeLine: 2127, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!1820 = distinct !DILocation(line: 2868, column: 17, scope: !1821, inlinedAt: !1822)
!1821 = distinct !DISubprogram(name: "drop<tokio::runtime::io::scheduled_io::ScheduledIo, alloc::alloc::Global>", linkageName: "_RNvXsE_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcNtNtNtNtCs3EIJ1qnJmKW_5tokio7runtime2io12scheduled_io11ScheduledIoENtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4dropCshxBJAVx362N_11runtime_lab", scope: !1354, file: !1349, line: 2864, type: !52, scopeLine: 2864, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!1822 = distinct !DILocation(line: 847, column: 1, scope: !1814, inlinedAt: !1815)
!1823 = !{!1811, !1808}
!1824 = !DILocation(line: 4049, column: 24, scope: !1825, inlinedAt: !1826)
!1825 = distinct !DISubprogram(name: "atomic_sub<usize, usize>", linkageName: "_RINvNtNtCsjIpoRzUjyHQ_4core4sync6atomic10atomic_subjjECshxBJAVx362N_11runtime_lab", scope: !46, file: !45, line: 4043, type: !52, scopeLine: 4043, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!1826 = distinct !DILocation(line: 3253, column: 26, scope: !1827, inlinedAt: !1828)
!1827 = distinct !DISubprogram(name: "fetch_sub", linkageName: "_RNvMs1g_NtNtCsjIpoRzUjyHQ_4core4sync6atomicINtB6_6AtomicjE9fetch_sub", scope: !51, file: !45, line: 3251, type: !52, scopeLine: 3251, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!1828 = distinct !DILocation(line: 2868, column: 32, scope: !1821, inlinedAt: !1822)
!1829 = !DILocation(line: 2868, column: 12, scope: !1821, inlinedAt: !1822)
!1830 = !DILocation(line: 4493, column: 24, scope: !1364, inlinedAt: !1831)
!1831 = distinct !DILocation(line: 69, column: 9, scope: !1821, inlinedAt: !1822)
!1832 = !DILocation(line: 2911, column: 18, scope: !1821, inlinedAt: !1822)
!1833 = !{!1834}
!1834 = distinct !{!1834, !1835, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc4sync3ArcNtNtNtNtCs3EIJ1qnJmKW_5tokio7runtime2io12scheduled_io11ScheduledIoEECshxBJAVx362N_11runtime_lab: %_1"}
!1835 = distinct !{!1835, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc4sync3ArcNtNtNtNtCs3EIJ1qnJmKW_5tokio7runtime2io12scheduled_io11ScheduledIoEECshxBJAVx362N_11runtime_lab"}
!1836 = !{!1837}
!1837 = distinct !{!1837, !1838, !"_RNvXsE_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcNtNtNtNtCs3EIJ1qnJmKW_5tokio7runtime2io12scheduled_io11ScheduledIoENtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4dropCshxBJAVx362N_11runtime_lab: %self"}
!1838 = distinct !{!1838, !"_RNvXsE_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcNtNtNtNtCs3EIJ1qnJmKW_5tokio7runtime2io12scheduled_io11ScheduledIoENtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4dropCshxBJAVx362N_11runtime_lab"}
!1839 = !DILocation(line: 847, column: 1, scope: !1814, inlinedAt: !1840)
!1840 = distinct !DILocation(line: 847, column: 1, scope: !1759)
!1841 = !DILocation(line: 454, column: 20, scope: !1817, inlinedAt: !1842)
!1842 = distinct !DILocation(line: 2133, column: 27, scope: !1819, inlinedAt: !1843)
!1843 = distinct !DILocation(line: 2868, column: 17, scope: !1821, inlinedAt: !1844)
!1844 = distinct !DILocation(line: 847, column: 1, scope: !1814, inlinedAt: !1840)
!1845 = !{!1837, !1834}
!1846 = !DILocation(line: 4049, column: 24, scope: !1825, inlinedAt: !1847)
!1847 = distinct !DILocation(line: 3253, column: 26, scope: !1827, inlinedAt: !1848)
!1848 = distinct !DILocation(line: 2868, column: 32, scope: !1821, inlinedAt: !1844)
!1849 = !DILocation(line: 2868, column: 12, scope: !1821, inlinedAt: !1844)
!1850 = !DILocation(line: 4493, column: 24, scope: !1364, inlinedAt: !1851)
!1851 = distinct !DILocation(line: 69, column: 9, scope: !1821, inlinedAt: !1844)
!1852 = !DILocation(line: 2911, column: 18, scope: !1821, inlinedAt: !1844)
!1853 = distinct !DISubprogram(name: "assert_failed<core::option::Option<core::ptr::non_null::NonNull<tokio::runtime::task::core::Header>>, core::option::Option<core::ptr::non_null::NonNull<tokio::runtime::task::core::Header>>>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core9panicking13assert_failedINtNtB4_6option6OptionINtNtNtB4_3ptr8non_null7NonNullNtNtNtNtCs3EIJ1qnJmKW_5tokio7runtime4task4core6HeaderEEBM_ECshxBJAVx362N_11runtime_lab", scope: !1855, file: !1854, line: 397, type: !52, scopeLine: 397, flags: DIFlagPrototyped | DIFlagNoReturn, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!1854 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/panicking.rs", directory: "", checksumkind: CSK_MD5, checksum: "e7c8cdef070824bb84944b59182595c2")
!1855 = !DINamespace(name: "panicking", scope: !48)
!1856 = !{i64 6512935630990687859}
!1857 = !DILocation(line: 407, column: 5, scope: !1853)
!1858 = distinct !DISubprogram(name: "{closure#0}<std::sync::once_lock::{impl#0}::initialize::{closure_env#0}<core::option::Option<unsafe extern \22C\22 fn(*mut i32, i32) -> i32>, std::sync::once_lock::{impl#0}::get_or_init::{closure_env#0}<core::option::Option<unsafe extern \22C\22 fn(*mut i32, i32) -> i32>, runtime_lab::process::macos::pipe_cloexec::{closure_env#0}>, !>>", linkageName: "_RNCINvMs0_NtNtCs1SSuMAdGM58_3std4sync4onceNtB8_4Once15call_once_forceNCINvMNtBa_9once_lockINtB1b_8OnceLockINtNtCsjIpoRzUjyHQ_4core6option6OptionFUKCOllElEE10initializeNCINvB1a_11get_or_initNCNvNtNtCshxBJAVx362N_11runtime_lab7process5macos12pipe_cloexec0E0zE0E0B39_", scope: !1859, file: !63, line: 226, type: !52, scopeLine: 226, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!1859 = !DINamespace(name: "call_once_force", scope: !1860)
!1860 = !DINamespace(name: "{impl#2}", scope: !65)
!1861 = !{i64 6633436016491467898}
!1862 = !DILocation(line: 226, column: 40, scope: !1858)
!1863 = !DILocation(line: 975, column: 22, scope: !1864, inlinedAt: !1865)
!1864 = distinct !DISubprogram(name: "replace<core::option::Option<std::sync::once_lock::{impl#0}::initialize::{closure_env#0}<core::option::Option<unsafe extern \22C\22 fn(*mut i32, i32) -> i32>, std::sync::once_lock::{impl#0}::get_or_init::{closure_env#0}<core::option::Option<unsafe extern \22C\22 fn(*mut i32, i32) -> i32>, runtime_lab::process::macos::pipe_cloexec::{closure_env#0}>, !>>>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3mem7replaceINtNtB4_6option6OptionNCINvMNtNtCs1SSuMAdGM58_3std4sync9once_lockINtB11_8OnceLockIBA_FUKCOllElEE10initializeNCINvB10_11get_or_initNCNvNtNtCshxBJAVx362N_11runtime_lab7process5macos12pipe_cloexec0E0zE0EEB2N_", scope: !164, file: !163, line: 961, type: !52, scopeLine: 961, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!1865 = !DILocation(line: 1901, column: 9, scope: !1866, inlinedAt: !1867)
!1866 = distinct !DISubprogram(name: "take<std::sync::once_lock::{impl#0}::initialize::{closure_env#0}<core::option::Option<unsafe extern \22C\22 fn(*mut i32, i32) -> i32>, std::sync::once_lock::{impl#0}::get_or_init::{closure_env#0}<core::option::Option<unsafe extern \22C\22 fn(*mut i32, i32) -> i32>, runtime_lab::process::macos::pipe_cloexec::{closure_env#0}>, !>>", linkageName: "_RNvMNtCsjIpoRzUjyHQ_4core6optionINtB2_6OptionNCINvMNtNtCs1SSuMAdGM58_3std4sync9once_lockINtBN_8OnceLockIBv_FUKCOllElEE10initializeNCINvBM_11get_or_initNCNvNtNtCshxBJAVx362N_11runtime_lab7process5macos12pipe_cloexec0E0zE0E4takeB2x_", scope: !339, file: !338, line: 1899, type: !52, scopeLine: 1899, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!1867 = !DILocation(line: 226, column: 42, scope: !1858)
!1868 = !DILocation(line: 976, column: 49, scope: !1869, inlinedAt: !1865)
!1869 = distinct !DILexicalBlock(scope: !1864, file: !163, line: 975, column: 9)
!1870 = !DILocation(line: 1012, column: 15, scope: !1871, inlinedAt: !1872)
!1871 = distinct !DISubprogram(name: "unwrap<std::sync::once_lock::{impl#0}::initialize::{closure_env#0}<core::option::Option<unsafe extern \22C\22 fn(*mut i32, i32) -> i32>, std::sync::once_lock::{impl#0}::get_or_init::{closure_env#0}<core::option::Option<unsafe extern \22C\22 fn(*mut i32, i32) -> i32>, runtime_lab::process::macos::pipe_cloexec::{closure_env#0}>, !>>", linkageName: "_RNvMNtCsjIpoRzUjyHQ_4core6optionINtB2_6OptionNCINvMNtNtCs1SSuMAdGM58_3std4sync9once_lockINtBN_8OnceLockIBv_FUKCOllElEE10initializeNCINvBM_11get_or_initNCNvNtNtCshxBJAVx362N_11runtime_lab7process5macos12pipe_cloexec0E0zE0E6unwrapB2x_", scope: !339, file: !338, line: 1011, type: !52, scopeLine: 1011, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!1872 = !DILocation(line: 226, column: 49, scope: !1858)
!1873 = !DILocation(line: 1012, column: 9, scope: !1871, inlinedAt: !1872)
!1874 = !DILocation(line: 22, column: 35, scope: !1875, inlinedAt: !1881)
!1875 = distinct !DISubprogram(name: "{closure#0}", linkageName: "_RNCNvNtNtCshxBJAVx362N_11runtime_lab7process5macos12pipe_cloexec0B7_", scope: !1877, file: !1876, line: 19, type: !52, scopeLine: 19, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!1876 = !DIFile(filename: "src/process_macos.rs", directory: "/Users/juanwang/Desktop/tutorials/cpp-rust/bench/runtime-lab", checksumkind: CSK_MD5, checksum: "203618f6e42b79cf14017de7207c6451")
!1877 = !DINamespace(name: "pipe_cloexec", scope: !1878)
!1878 = !DINamespace(name: "macos", scope: !1879)
!1879 = !DINamespace(name: "process", scope: !1880)
!1880 = !DINamespace(name: "runtime_lab", scope: null)
!1881 = distinct !DILocation(line: 350, column: 50, scope: !1882, inlinedAt: !1885)
!1882 = distinct !DISubprogram(name: "{closure#0}<core::option::Option<unsafe extern \22C\22 fn(*mut i32, i32) -> i32>, runtime_lab::process::macos::pipe_cloexec::{closure_env#0}>", linkageName: "_RNCINvMNtNtCs1SSuMAdGM58_3std4sync9once_lockINtB5_8OnceLockINtNtCsjIpoRzUjyHQ_4core6option6OptionFUKCOllElEE11get_or_initNCNvNtNtCshxBJAVx362N_11runtime_lab7process5macos12pipe_cloexec0E0B23_", scope: !1883, file: !35, line: 350, type: !52, scopeLine: 350, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!1883 = !DINamespace(name: "get_or_init", scope: !1884)
!1884 = !DINamespace(name: "{impl#0}", scope: !37)
!1885 = distinct !DILocation(line: 572, column: 19, scope: !1886, inlinedAt: !1888)
!1886 = distinct !DISubprogram(name: "{closure#0}<core::option::Option<unsafe extern \22C\22 fn(*mut i32, i32) -> i32>, std::sync::once_lock::{impl#0}::get_or_init::{closure_env#0}<core::option::Option<unsafe extern \22C\22 fn(*mut i32, i32) -> i32>, runtime_lab::process::macos::pipe_cloexec::{closure_env#0}>, !>", linkageName: "_RNCINvMNtNtCs1SSuMAdGM58_3std4sync9once_lockINtB5_8OnceLockINtNtCsjIpoRzUjyHQ_4core6option6OptionFUKCOllElEE10initializeNCINvB4_11get_or_initNCNvNtNtCshxBJAVx362N_11runtime_lab7process5macos12pipe_cloexec0E0zE0B2n_", scope: !1887, file: !35, line: 571, type: !40, scopeLine: 571, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!1887 = !DINamespace(name: "initialize", scope: !1884)
!1888 = distinct !DILocation(line: 226, column: 40, scope: !1858)
!1889 = !DILocation(line: 575, column: 9, scope: !1890, inlinedAt: !1894)
!1890 = distinct !DISubprogram(name: "write<core::option::Option<unsafe extern \22C\22 fn(*mut i32, i32) -> i32>>", linkageName: "_RNvMs1_NtNtCsjIpoRzUjyHQ_4core3mem12maybe_uninitINtB5_11MaybeUninitINtNtB9_6option6OptionFUKCOllElEE5writeCshxBJAVx362N_11runtime_lab", scope: !1892, file: !1891, line: 574, type: !52, scopeLine: 574, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!1891 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/mem/maybe_uninit.rs", directory: "", checksumkind: CSK_MD5, checksum: "9a42a2628cac802dc356862faf606a36")
!1892 = !DINamespace(name: "MaybeUninit", scope: !1893)
!1893 = !DINamespace(name: "maybe_uninit", scope: !164)
!1894 = distinct !DILocation(line: 574, column: 49, scope: !1895, inlinedAt: !1888)
!1895 = distinct !DILexicalBlock(scope: !1886, file: !35, line: 573, column: 17)
!1896 = !DILocation(line: 226, column: 60, scope: !1858)
!1897 = !DILocation(line: 1014, column: 21, scope: !1871, inlinedAt: !1872)
!1898 = distinct !DISubprogram(name: "call_once<std::sync::once::{impl#2}::call_once_force::{closure_env#0}<std::sync::once_lock::{impl#0}::initialize::{closure_env#0}<core::option::Option<unsafe extern \22C\22 fn(*mut i32, i32) -> i32>, std::sync::once_lock::{impl#0}::get_or_init::{closure_env#0}<core::option::Option<unsafe extern \22C\22 fn(*mut i32, i32) -> i32>, runtime_lab::process::macos::pipe_cloexec::{closure_env#0}>, !>>, (&std::sync::once::OnceState)>", linkageName: "_RNSNvYNCINvMs0_NtNtCs1SSuMAdGM58_3std4sync4onceNtBd_4Once15call_once_forceNCINvMNtBf_9once_lockINtB1g_8OnceLockINtNtCsjIpoRzUjyHQ_4core6option6OptionFUKCOllElEE10initializeNCINvB1f_11get_or_initNCNvNtNtCshxBJAVx362N_11runtime_lab7process5macos12pipe_cloexec0E0zE0E0INtNtNtB1Q_3ops8function6FnOnceTRNtBd_9OnceStateEE9call_once6vtableB3e_", scope: !1900, file: !1899, line: 250, type: !52, scopeLine: 250, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!1899 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/ops/function.rs", directory: "", checksumkind: CSK_MD5, checksum: "ae01f833f82cd27aa916c99d95502941")
!1900 = !DINamespace(name: "FnOnce", scope: !1901)
!1901 = !DINamespace(name: "function", scope: !1902)
!1902 = !DINamespace(name: "ops", scope: !48)
!1903 = !{i64 5160409792168330971}
!1904 = !DILocation(line: 250, column: 5, scope: !1898)
!1905 = !{!1906}
!1906 = distinct !{!1906, !1907, !"_RNvYNCINvMs0_NtNtCs1SSuMAdGM58_3std4sync4onceNtBb_4Once15call_once_forceNCINvMNtBd_9once_lockINtB1e_8OnceLockINtNtCsjIpoRzUjyHQ_4core6option6OptionFUKCOllElEE10initializeNCINvB1d_11get_or_initNCNvNtNtCshxBJAVx362N_11runtime_lab7process5macos12pipe_cloexec0E0zE0E0INtNtNtB1O_3ops8function6FnOnceTRNtBb_9OnceStateEE9call_onceB3c_: argument 0"}
!1907 = distinct !{!1907, !"_RNvYNCINvMs0_NtNtCs1SSuMAdGM58_3std4sync4onceNtBb_4Once15call_once_forceNCINvMNtBd_9once_lockINtB1e_8OnceLockINtNtCsjIpoRzUjyHQ_4core6option6OptionFUKCOllElEE10initializeNCINvB1d_11get_or_initNCNvNtNtCshxBJAVx362N_11runtime_lab7process5macos12pipe_cloexec0E0zE0E0INtNtNtB1O_3ops8function6FnOnceTRNtBb_9OnceStateEE9call_onceB3c_"}
!1908 = !DILocation(line: 975, column: 22, scope: !1864, inlinedAt: !1909)
!1909 = distinct !DILocation(line: 1901, column: 9, scope: !1866, inlinedAt: !1910)
!1910 = distinct !DILocation(line: 226, column: 42, scope: !1858, inlinedAt: !1911)
!1911 = distinct !DILocation(line: 250, column: 5, scope: !1912, inlinedAt: !1913)
!1912 = distinct !DISubprogram(name: "call_once<std::sync::once::{impl#2}::call_once_force::{closure_env#0}<std::sync::once_lock::{impl#0}::initialize::{closure_env#0}<core::option::Option<unsafe extern \22C\22 fn(*mut i32, i32) -> i32>, std::sync::once_lock::{impl#0}::get_or_init::{closure_env#0}<core::option::Option<unsafe extern \22C\22 fn(*mut i32, i32) -> i32>, runtime_lab::process::macos::pipe_cloexec::{closure_env#0}>, !>>, (&std::sync::once::OnceState)>", linkageName: "_RNvYNCINvMs0_NtNtCs1SSuMAdGM58_3std4sync4onceNtBb_4Once15call_once_forceNCINvMNtBd_9once_lockINtB1e_8OnceLockINtNtCsjIpoRzUjyHQ_4core6option6OptionFUKCOllElEE10initializeNCINvB1d_11get_or_initNCNvNtNtCshxBJAVx362N_11runtime_lab7process5macos12pipe_cloexec0E0zE0E0INtNtNtB1O_3ops8function6FnOnceTRNtBb_9OnceStateEE9call_onceB3c_", scope: !1900, file: !1899, line: 250, type: !40, scopeLine: 250, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!1913 = distinct !DILocation(line: 250, column: 5, scope: !1898)
!1914 = !{!1915}
!1915 = distinct !{!1915, !1916, !"_RNCINvMs0_NtNtCs1SSuMAdGM58_3std4sync4onceNtB8_4Once15call_once_forceNCINvMNtBa_9once_lockINtB1b_8OnceLockINtNtCsjIpoRzUjyHQ_4core6option6OptionFUKCOllElEE10initializeNCINvB1a_11get_or_initNCNvNtNtCshxBJAVx362N_11runtime_lab7process5macos12pipe_cloexec0E0zE0E0B39_: %_1"}
!1916 = distinct !{!1916, !"_RNCINvMs0_NtNtCs1SSuMAdGM58_3std4sync4onceNtB8_4Once15call_once_forceNCINvMNtBa_9once_lockINtB1b_8OnceLockINtNtCsjIpoRzUjyHQ_4core6option6OptionFUKCOllElEE10initializeNCINvB1a_11get_or_initNCNvNtNtCshxBJAVx362N_11runtime_lab7process5macos12pipe_cloexec0E0zE0E0B39_"}
!1917 = !DILocation(line: 976, column: 49, scope: !1869, inlinedAt: !1909)
!1918 = !DILocation(line: 1012, column: 15, scope: !1871, inlinedAt: !1919)
!1919 = distinct !DILocation(line: 226, column: 49, scope: !1858, inlinedAt: !1911)
!1920 = !DILocation(line: 1012, column: 9, scope: !1871, inlinedAt: !1919)
!1921 = !DILocation(line: 1014, column: 21, scope: !1871, inlinedAt: !1919)
!1922 = !{!1915, !1906}
!1923 = !DILocation(line: 22, column: 35, scope: !1875, inlinedAt: !1924)
!1924 = distinct !DILocation(line: 350, column: 50, scope: !1882, inlinedAt: !1925)
!1925 = distinct !DILocation(line: 572, column: 19, scope: !1886, inlinedAt: !1926)
!1926 = distinct !DILocation(line: 226, column: 40, scope: !1858, inlinedAt: !1911)
!1927 = !DILocation(line: 575, column: 9, scope: !1890, inlinedAt: !1928)
!1928 = distinct !DILocation(line: 574, column: 49, scope: !1895, inlinedAt: !1926)
!1929 = distinct !DISubprogram(name: "multi_runtime", linkageName: "_RNvCshxBJAVx362N_11runtime_lab13multi_runtime", scope: !1880, file: !1930, line: 12, type: !52, scopeLine: 12, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!1930 = !DIFile(filename: "src/lib.rs", directory: "/Users/juanwang/Desktop/tutorials/cpp-rust/bench/runtime-lab", checksumkind: CSK_MD5, checksum: "5f9758c4b643e050462ae4ab87116146")
!1931 = !{i64 -6375091666074397830}
!1932 = !DILocation(line: 13, column: 5, scope: !1929)
!1933 = !DILocation(line: 14, column: 10, scope: !1929)
!1934 = !DILocation(line: 17, column: 1, scope: !1929)
!1935 = !DILocation(line: 1852, column: 9, scope: !1936, inlinedAt: !1940)
!1936 = distinct !DISubprogram(name: "enable_io", linkageName: "_RNvMNtNtCs3EIJ1qnJmKW_5tokio7runtime7builderNtB2_7Builder9enable_io", scope: !1938, file: !1937, line: 1851, type: !52, scopeLine: 1851, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!1937 = !DIFile(filename: "src/runtime/builder.rs", directory: "/Users/juanwang/.cargo/registry/src/mirrors.bfsu.edu.cn-eb00624c53167367/tokio-1.54.0", checksumkind: CSK_MD5, checksum: "e72aaf31387e8751c856feceaa4ef6b3")
!1938 = !DINamespace(name: "Builder", scope: !1939)
!1939 = !DINamespace(name: "builder", scope: !362)
!1940 = !DILocation(line: 404, column: 14, scope: !1941, inlinedAt: !1942)
!1941 = distinct !DISubprogram(name: "enable_all", linkageName: "_RNvMNtNtCs3EIJ1qnJmKW_5tokio7runtime7builderNtB2_7Builder10enable_all", scope: !1938, file: !1937, line: 398, type: !52, scopeLine: 398, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!1942 = !DILocation(line: 15, column: 10, scope: !1929)
!1943 = !DILocation(line: 1952, column: 13, scope: !1944, inlinedAt: !1945)
!1944 = distinct !DISubprogram(name: "enable_time", linkageName: "_RNvMs3_NtNtCs3EIJ1qnJmKW_5tokio7runtime7builderNtB5_7Builder11enable_time", scope: !1938, file: !1937, line: 1951, type: !52, scopeLine: 1951, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!1945 = !DILocation(line: 416, column: 14, scope: !1941, inlinedAt: !1942)
!1946 = !DILocation(line: 16, column: 10, scope: !1929)
!1947 = !DILocation(line: 17, column: 2, scope: !1929)
!1948 = !DILocation(line: 12, column: 1, scope: !1929)
!1949 = distinct !DISubprogram(name: "current_runtime", linkageName: "_RNvCshxBJAVx362N_11runtime_lab15current_runtime", scope: !1880, file: !1930, line: 8, type: !52, scopeLine: 8, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!1950 = !{i64 6554420682105550994}
!1951 = !DILocation(line: 9, column: 5, scope: !1949)
!1952 = !DILocation(line: 1852, column: 9, scope: !1953, inlinedAt: !1954)
!1953 = distinct !DISubprogram(name: "enable_io", linkageName: "_RNvMNtNtCs3EIJ1qnJmKW_5tokio7runtime7builderNtB2_7Builder9enable_io", scope: !1938, file: !1937, line: 1851, type: !52, scopeLine: 1851, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!1954 = !DILocation(line: 404, column: 14, scope: !1955, inlinedAt: !1956)
!1955 = distinct !DISubprogram(name: "enable_all", linkageName: "_RNvMNtNtCs3EIJ1qnJmKW_5tokio7runtime7builderNtB2_7Builder10enable_all", scope: !1938, file: !1937, line: 398, type: !52, scopeLine: 398, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!1956 = !DILocation(line: 9, column: 35, scope: !1949)
!1957 = !DILocation(line: 1952, column: 13, scope: !1958, inlinedAt: !1959)
!1958 = distinct !DISubprogram(name: "enable_time", linkageName: "_RNvMs3_NtNtCs3EIJ1qnJmKW_5tokio7runtime7builderNtB5_7Builder11enable_time", scope: !1938, file: !1937, line: 1951, type: !52, scopeLine: 1951, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!1959 = !DILocation(line: 416, column: 14, scope: !1955, inlinedAt: !1956)
!1960 = !DILocation(line: 9, column: 48, scope: !1949)
!1961 = !DILocation(line: 10, column: 1, scope: !1949)
!1962 = !DILocation(line: 10, column: 2, scope: !1949)
!1963 = !DILocation(line: 8, column: 1, scope: !1949)
!1964 = distinct !DISubprogram(name: "decode", linkageName: "_RNvMNtCshxBJAVx362N_11runtime_lab4wireNtB2_5Frame6decode", scope: !1966, file: !1965, line: 22, type: !52, scopeLine: 22, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!1965 = !DIFile(filename: "src/wire.rs", directory: "/Users/juanwang/Desktop/tutorials/cpp-rust/bench/runtime-lab", checksumkind: CSK_MD5, checksum: "dbc5ac82426548902fbe72228fde1078")
!1966 = !DINamespace(name: "Frame", scope: !1967)
!1967 = !DINamespace(name: "wire", scope: !1880)
!1968 = !{i64 -6741768562149941493}
!1969 = !DILocation(line: 157, column: 18, scope: !1970, inlinedAt: !1975)
!1970 = distinct !DISubprogram(name: "spec_eq<u8, u8, 2>", linkageName: "_RNvXs7_NtNtCsjIpoRzUjyHQ_4core5array8equalityhINtB5_11SpecArrayEqhKj2_E7spec_eqCshxBJAVx362N_11runtime_lab", scope: !1972, file: !1971, line: 153, type: !52, scopeLine: 153, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!1971 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/array/equality.rs", directory: "", checksumkind: CSK_MD5, checksum: "2e8ad1e2d89117c8c3eff8a826c8ea1c")
!1972 = !DINamespace(name: "{impl#9}", scope: !1973)
!1973 = !DINamespace(name: "equality", scope: !1974)
!1974 = !DINamespace(name: "array", scope: !48)
!1975 = !DILocation(line: 160, column: 10, scope: !1976, inlinedAt: !1977)
!1976 = distinct !DISubprogram(name: "spec_ne<u8, u8, 2>", linkageName: "_RNvXs7_NtNtCsjIpoRzUjyHQ_4core5array8equalityhINtB5_11SpecArrayEqhKj2_E7spec_neCshxBJAVx362N_11runtime_lab", scope: !1972, file: !1971, line: 159, type: !52, scopeLine: 159, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!1977 = !DILocation(line: 15, column: 9, scope: !1978, inlinedAt: !1980)
!1978 = distinct !DISubprogram(name: "ne<u8, u8, 2>", linkageName: "_RNvXNtNtCsjIpoRzUjyHQ_4core5array8equalityAhj2_NtNtB6_3cmp9PartialEq2neCshxBJAVx362N_11runtime_lab", scope: !1979, file: !1971, line: 14, type: !52, scopeLine: 14, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!1979 = !DINamespace(name: "{impl#0}", scope: !1973)
!1980 = !DILocation(line: 57, column: 24, scope: !1981, inlinedAt: !1984)
!1981 = distinct !DILexicalBlock(scope: !1982, file: !1971, line: 57, column: 13)
!1982 = distinct !DISubprogram(name: "ne<u8, u8, 2>", linkageName: "_RNvXs0_NtNtCsjIpoRzUjyHQ_4core5array8equalityShINtNtB9_3cmp9PartialEqAhj2_E2neCshxBJAVx362N_11runtime_lab", scope: !1983, file: !1971, line: 55, type: !52, scopeLine: 55, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!1983 = !DINamespace(name: "{impl#2}", scope: !1973)
!1984 = !DILocation(line: 23, column: 12, scope: !1964)
!1985 = !DILocation(line: 27, column: 24, scope: !1964)
!1986 = !DILocation(line: 40, column: 6, scope: !1964)
!1987 = !DILocation(line: 90, column: 24, scope: !1988, inlinedAt: !1993)
!1988 = distinct !DILexicalBlock(scope: !1990, file: !1989, line: 88, column: 5)
!1989 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/slice/index.rs", directory: "", checksumkind: CSK_MD5, checksum: "a6478e6d30216db9f8cdcb9288808b92")
!1990 = distinct !DISubprogram(name: "get_offset_len_noubcheck<u8>", linkageName: "_RINvNtNtCsjIpoRzUjyHQ_4core5slice5index24get_offset_len_noubcheckhECshxBJAVx362N_11runtime_lab", scope: !1991, file: !1989, line: 83, type: !52, scopeLine: 83, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!1991 = !DINamespace(name: "index", scope: !1992)
!1992 = !DINamespace(name: "slice", scope: !48)
!1993 = !DILocation(line: 411, column: 24, scope: !1994, inlinedAt: !1997)
!1994 = !DILexicalBlockFile(scope: !1995, file: !1989, discriminator: 6)
!1995 = distinct !DISubprogram(name: "index<u8>", linkageName: "_RNvXs2_NtNtCsjIpoRzUjyHQ_4core5slice5indexINtNtNtB9_3ops5range5RangejEINtB5_10SliceIndexShE5indexCshxBJAVx362N_11runtime_lab", scope: !1996, file: !1989, line: 405, type: !52, scopeLine: 405, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!1996 = !DINamespace(name: "{impl#4}", scope: !1991)
!1997 = !DILocation(line: 19, column: 15, scope: !1998, inlinedAt: !2001)
!1998 = !DILexicalBlockFile(scope: !1999, file: !1989, discriminator: 6)
!1999 = distinct !DISubprogram(name: "index<u8, core::ops::range::Range<usize>>", linkageName: "_RNvXNtNtCsjIpoRzUjyHQ_4core5slice5indexShINtNtNtB6_3ops5index5IndexINtNtBI_5range5RangejEE5indexCshxBJAVx362N_11runtime_lab", scope: !2000, file: !1989, line: 18, type: !52, scopeLine: 18, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!2000 = !DINamespace(name: "{impl#0}", scope: !1991)
!2001 = !DILocation(line: 391, column: 9, scope: !2002, inlinedAt: !2006)
!2002 = !DILexicalBlockFile(scope: !2004, file: !2003, discriminator: 6)
!2003 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/array/mod.rs", directory: "", checksumkind: CSK_MD5, checksum: "7a70bfbf63cdead6b6acc4823ebb6443")
!2004 = distinct !DISubprogram(name: "index<u8, core::ops::range::Range<usize>, 24>", linkageName: "_RNvXsd_NtCsjIpoRzUjyHQ_4core5arrayAhj18_INtNtNtB7_3ops5index5IndexINtNtBH_5range5RangejEE5indexCshxBJAVx362N_11runtime_lab", scope: !2005, file: !2003, line: 390, type: !52, scopeLine: 390, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!2005 = !DINamespace(name: "{impl#15}", scope: !1974)
!2006 = !DILocation(line: 33, column: 34, scope: !2007)
!2007 = distinct !DILexicalBlock(scope: !1964, file: !1965, line: 32, column: 9)
!2008 = !DILocation(line: 573, column: 14, scope: !2009, inlinedAt: !2010)
!2009 = distinct !DISubprogram(name: "copy_nonoverlapping<u8>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3ptr19copy_nonoverlappinghECshxBJAVx362N_11runtime_lab", scope: !140, file: !139, line: 552, type: !52, scopeLine: 552, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!2010 = distinct !DILocation(line: 5605, column: 9, scope: !2011, inlinedAt: !2013)
!2011 = distinct !DISubprogram(name: "copy_from_slice_impl<u8>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core5slice20copy_from_slice_implhECshxBJAVx362N_11runtime_lab", scope: !1992, file: !2012, line: 5582, type: !52, scopeLine: 5582, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!2012 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/slice/mod.rs", directory: "", checksumkind: CSK_MD5, checksum: "3864a87bb6bc29c76dd67717f51013ca")
!2013 = distinct !DILocation(line: 4344, column: 18, scope: !2014, inlinedAt: !2016)
!2014 = distinct !DISubprogram(name: "copy_from_slice<u8>", linkageName: "_RNvMNtCsjIpoRzUjyHQ_4core5sliceSh15copy_from_sliceCshxBJAVx362N_11runtime_lab", scope: !2015, file: !2012, line: 4339, type: !52, scopeLine: 4339, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!2015 = !DINamespace(name: "{impl#0}", scope: !1992)
!2016 = !DILocation(line: 33, column: 12, scope: !2007)
!2017 = !{!2018, !2020}
!2018 = distinct !{!2018, !2019, !"_RINvNtCsjIpoRzUjyHQ_4core5slice20copy_from_slice_implhECshxBJAVx362N_11runtime_lab: %dest.0"}
!2019 = distinct !{!2019, !"_RINvNtCsjIpoRzUjyHQ_4core5slice20copy_from_slice_implhECshxBJAVx362N_11runtime_lab"}
!2020 = distinct !{!2020, !2019, !"_RINvNtCsjIpoRzUjyHQ_4core5slice20copy_from_slice_implhECshxBJAVx362N_11runtime_lab: %src.0"}
!2021 = !{!2022}
!2022 = distinct !{!2022, !2019, !"_RINvNtCsjIpoRzUjyHQ_4core5slice20copy_from_slice_implhECshxBJAVx362N_11runtime_lab: argument 2"}
!2023 = !DILocation(line: 90, column: 24, scope: !2024, inlinedAt: !2025)
!2024 = distinct !DILexicalBlock(scope: !1990, file: !1989, line: 88, column: 5)
!2025 = !DILocation(line: 411, column: 24, scope: !2026, inlinedAt: !2027)
!2026 = !DILexicalBlockFile(scope: !1995, file: !1989, discriminator: 8)
!2027 = !DILocation(line: 19, column: 15, scope: !2028, inlinedAt: !2029)
!2028 = !DILexicalBlockFile(scope: !1999, file: !1989, discriminator: 8)
!2029 = !DILocation(line: 391, column: 9, scope: !2030, inlinedAt: !2031)
!2030 = !DILexicalBlockFile(scope: !2004, file: !2003, discriminator: 8)
!2031 = !DILocation(line: 35, column: 37, scope: !2032)
!2032 = distinct !DILexicalBlock(scope: !2007, file: !1965, line: 34, column: 9)
!2033 = !DILocation(line: 573, column: 14, scope: !2009, inlinedAt: !2034)
!2034 = distinct !DILocation(line: 5605, column: 9, scope: !2011, inlinedAt: !2035)
!2035 = distinct !DILocation(line: 4344, column: 18, scope: !2014, inlinedAt: !2036)
!2036 = !DILocation(line: 35, column: 15, scope: !2032)
!2037 = !{!2038, !2040}
!2038 = distinct !{!2038, !2039, !"_RINvNtCsjIpoRzUjyHQ_4core5slice20copy_from_slice_implhECshxBJAVx362N_11runtime_lab: %dest.0"}
!2039 = distinct !{!2039, !"_RINvNtCsjIpoRzUjyHQ_4core5slice20copy_from_slice_implhECshxBJAVx362N_11runtime_lab"}
!2040 = distinct !{!2040, !2039, !"_RINvNtCsjIpoRzUjyHQ_4core5slice20copy_from_slice_implhECshxBJAVx362N_11runtime_lab: %src.0"}
!2041 = !{!2042}
!2042 = distinct !{!2042, !2039, !"_RINvNtCsjIpoRzUjyHQ_4core5slice20copy_from_slice_implhECshxBJAVx362N_11runtime_lab: argument 2"}
!2043 = !DILocation(line: 0, scope: !1964)
!2044 = !DILocation(line: 36, column: 9, scope: !2032)
!2045 = distinct !DISubprogram(name: "encode", linkageName: "_RNvMNtCshxBJAVx362N_11runtime_lab4wireNtB2_5Frame6encode", scope: !1966, file: !1965, line: 13, type: !52, scopeLine: 13, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!2046 = !{i64 -6356396769689759645}
!2047 = !DILocation(line: 19, column: 9, scope: !2048)
!2048 = distinct !DILexicalBlock(scope: !2045, file: !1965, line: 14, column: 9)
!2049 = !DILocation(line: 20, column: 6, scope: !2045)
!2050 = distinct !DISubprogram(name: "drop_slow<std::sync::poison::mutex::Mutex<runtime_lab::process::Capture>, alloc::alloc::Global>", linkageName: "_RNvMsn_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcINtNtNtNtCs1SSuMAdGM58_3std4sync6poison5mutex5MutexNtNtCshxBJAVx362N_11runtime_lab7process7CaptureEE9drop_slowB1z_", scope: !1350, file: !1349, line: 2138, type: !52, scopeLine: 2138, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!2051 = !{i64 -5424813617403639701}
!2052 = !DILocation(line: 2144, column: 33, scope: !2050)
!2053 = !DILocation(line: 842, column: 24, scope: !2054, inlinedAt: !2055)
!2054 = distinct !DISubprogram(name: "drop_in_place<std::sync::poison::mutex::Mutex<runtime_lab::process::Capture>>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3ptr13drop_in_placeINtNtNtNtCs1SSuMAdGM58_3std4sync6poison5mutex5MutexNtNtCshxBJAVx362N_11runtime_lab7process7CaptureEEB1z_", scope: !140, file: !139, line: 830, type: !52, scopeLine: 830, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!2055 = !DILocation(line: 2149, column: 18, scope: !2056)
!2056 = distinct !DILexicalBlock(scope: !2050, file: !1349, line: 2144, column: 9)
!2057 = !DILocation(line: 847, column: 1, scope: !1606, inlinedAt: !2058)
!2058 = distinct !DILocation(line: 847, column: 1, scope: !2059, inlinedAt: !2060)
!2059 = distinct !DISubprogram(name: "drop_glue<std::sync::poison::mutex::Mutex<runtime_lab::process::Capture>>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtNtCs1SSuMAdGM58_3std4sync6poison5mutex5MutexNtNtCshxBJAVx362N_11runtime_lab7process7CaptureEEB1u_", scope: !140, file: !139, line: 847, type: !52, scopeLine: 847, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!2060 = distinct !DILocation(line: 842, column: 14, scope: !2054, inlinedAt: !2055)
!2061 = !{!2062}
!2062 = distinct !{!2062, !2063, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtNtCs1SSuMAdGM58_3std3sys4sync8once_box7OnceBoxNtNtNtNtNtBI_3pal4unix4sync5mutex5MutexEECshxBJAVx362N_11runtime_lab: %_1"}
!2063 = distinct !{!2063, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtNtCs1SSuMAdGM58_3std3sys4sync8once_box7OnceBoxNtNtNtNtNtBI_3pal4unix4sync5mutex5MutexEECshxBJAVx362N_11runtime_lab"}
!2064 = !{!2065}
!2065 = distinct !{!2065, !2066, !"_RNvXs1_NtNtNtCs1SSuMAdGM58_3std3sys4sync8once_boxINtB5_7OnceBoxNtNtNtNtNtB9_3pal4unix4sync5mutex5MutexENtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4dropCshxBJAVx362N_11runtime_lab: %self"}
!2066 = distinct !{!2066, !"_RNvXs1_NtNtNtCs1SSuMAdGM58_3std3sys4sync8once_boxINtB5_7OnceBoxNtNtNtNtNtB9_3pal4unix4sync5mutex5MutexENtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4dropCshxBJAVx362N_11runtime_lab"}
!2067 = !DILocation(line: 847, column: 1, scope: !841, inlinedAt: !2068)
!2068 = distinct !DILocation(line: 847, column: 1, scope: !1606, inlinedAt: !2058)
!2069 = !DILocation(line: 975, column: 22, scope: !848, inlinedAt: !2070)
!2070 = distinct !DILocation(line: 57, column: 19, scope: !850, inlinedAt: !2071)
!2071 = distinct !DILocation(line: 81, column: 14, scope: !852, inlinedAt: !2072)
!2072 = distinct !DILocation(line: 847, column: 1, scope: !841, inlinedAt: !2068)
!2073 = !{!2065, !2062, !2074, !2076}
!2074 = distinct !{!2074, !2075, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtNtNtNtCs1SSuMAdGM58_3std3sys4sync5mutex7pthread5MutexECshxBJAVx362N_11runtime_lab: %_1"}
!2075 = distinct !{!2075, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtNtNtNtCs1SSuMAdGM58_3std3sys4sync5mutex7pthread5MutexECshxBJAVx362N_11runtime_lab"}
!2076 = distinct !{!2076, !2077, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtNtCs1SSuMAdGM58_3std4sync6poison5mutex5MutexNtNtCshxBJAVx362N_11runtime_lab7process7CaptureEEB1u_: %_1"}
!2077 = distinct !{!2077, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtNtCs1SSuMAdGM58_3std4sync6poison5mutex5MutexNtNtCshxBJAVx362N_11runtime_lab7process7CaptureEEB1u_"}
!2078 = !DILocation(line: 976, column: 49, scope: !856, inlinedAt: !2070)
!2079 = !DILocation(line: 38, column: 17, scope: !858, inlinedAt: !2080)
!2080 = distinct !DILocation(line: 2636, column: 9, scope: !861, inlinedAt: !2081)
!2081 = distinct !DILocation(line: 23, column: 27, scope: !865, inlinedAt: !2082)
!2082 = distinct !DILocation(line: 58, column: 17, scope: !867, inlinedAt: !2071)
!2083 = !DILocation(line: 847, column: 1, scope: !869, inlinedAt: !2084)
!2084 = distinct !DILocation(line: 81, column: 20, scope: !852, inlinedAt: !2072)
!2085 = !DILocation(line: 847, column: 1, scope: !138, inlinedAt: !2086)
!2086 = distinct !DILocation(line: 847, column: 1, scope: !160, inlinedAt: !2087)
!2087 = distinct !DILocation(line: 847, column: 1, scope: !196, inlinedAt: !2088)
!2088 = distinct !DILocation(line: 847, column: 1, scope: !869, inlinedAt: !2084)
!2089 = !{!2065, !2062}
!2090 = !DILocation(line: 175, column: 14, scope: !168, inlinedAt: !2091)
!2091 = distinct !DILocation(line: 321, column: 22, scope: !170, inlinedAt: !2092)
!2092 = distinct !DILocation(line: 436, column: 9, scope: !172, inlinedAt: !2093)
!2093 = distinct !DILocation(line: 554, column: 23, scope: !174, inlinedAt: !2094)
!2094 = distinct !DILocation(line: 2000, column: 24, scope: !176, inlinedAt: !2095)
!2095 = distinct !DILocation(line: 847, column: 1, scope: !160, inlinedAt: !2087)
!2096 = !DILocation(line: 847, column: 1, scope: !160, inlinedAt: !2087)
!2097 = !DILocation(line: 175, column: 14, scope: !168, inlinedAt: !2098)
!2098 = distinct !DILocation(line: 321, column: 22, scope: !170, inlinedAt: !2099)
!2099 = distinct !DILocation(line: 436, column: 9, scope: !172, inlinedAt: !2100)
!2100 = distinct !DILocation(line: 554, column: 23, scope: !174, inlinedAt: !2101)
!2101 = distinct !DILocation(line: 2000, column: 24, scope: !176, inlinedAt: !2102)
!2102 = distinct !DILocation(line: 847, column: 1, scope: !160, inlinedAt: !2087)
!2103 = !DILocation(line: 847, column: 1, scope: !2059, inlinedAt: !2060)
!2104 = !DILocation(line: 3277, column: 5, scope: !2105, inlinedAt: !2108)
!2105 = distinct !DISubprogram(name: "is_dangling<alloc::sync::ArcInner<std::sync::poison::mutex::Mutex<runtime_lab::process::Capture>>>", linkageName: "_RINvNtCs6zY7rJBZy9D_5alloc2rc11is_danglingINtNtB4_4sync8ArcInnerINtNtNtNtCs1SSuMAdGM58_3std4sync6poison5mutex5MutexNtNtCshxBJAVx362N_11runtime_lab7process7CaptureEEEB1T_", scope: !2107, file: !2106, line: 3276, type: !52, scopeLine: 3276, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!2106 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/alloc/src/rc.rs", directory: "", checksumkind: CSK_MD5, checksum: "a6f930e5de5e5db13ac0efed74f8947a")
!2107 = !DINamespace(name: "rc", scope: !109)
!2108 = distinct !DILocation(line: 3392, column: 12, scope: !2109, inlinedAt: !2112)
!2109 = distinct !DILexicalBlock(scope: !2110, file: !1349, line: 3391, column: 9)
!2110 = distinct !DISubprogram(name: "inner<std::sync::poison::mutex::Mutex<runtime_lab::process::Capture>, &alloc::alloc::Global>", linkageName: "_RNvMsK_NtCs6zY7rJBZy9D_5alloc4syncINtB5_4WeakINtNtNtNtCs1SSuMAdGM58_3std4sync6poison5mutex5MutexNtNtCshxBJAVx362N_11runtime_lab7process7CaptureERNtNtB7_5alloc6GlobalE5innerB1A_", scope: !2111, file: !1349, line: 3390, type: !52, scopeLine: 3390, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!2111 = !DINamespace(name: "Weak", scope: !1351)
!2112 = distinct !DILocation(line: 3542, column: 47, scope: !2113, inlinedAt: !2116)
!2113 = distinct !DILexicalBlock(scope: !2114, file: !1349, line: 3542, column: 55)
!2114 = distinct !DISubprogram(name: "drop<std::sync::poison::mutex::Mutex<runtime_lab::process::Capture>, &alloc::alloc::Global>", linkageName: "_RNvXsO_NtCs6zY7rJBZy9D_5alloc4syncINtB5_4WeakINtNtNtNtCs1SSuMAdGM58_3std4sync6poison5mutex5MutexNtNtCshxBJAVx362N_11runtime_lab7process7CaptureERNtNtB7_5alloc6GlobalENtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4dropB1A_", scope: !2115, file: !1349, line: 3533, type: !40, scopeLine: 3533, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!2115 = !DINamespace(name: "{impl#52}", scope: !1351)
!2116 = distinct !DILocation(line: 847, column: 1, scope: !2117, inlinedAt: !2118)
!2117 = distinct !DISubprogram(name: "drop_glue<alloc::sync::Weak<std::sync::poison::mutex::Mutex<runtime_lab::process::Capture>, &alloc::alloc::Global>>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc4sync4WeakINtNtNtNtCs1SSuMAdGM58_3std4sync6poison5mutex5MutexNtNtCshxBJAVx362N_11runtime_lab7process7CaptureERNtNtBG_5alloc6GlobalEEB23_", scope: !140, file: !139, line: 847, type: !40, scopeLine: 847, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!2118 = distinct !DILocation(line: 2150, column: 5, scope: !2050)
!2119 = !DILocation(line: 3392, column: 12, scope: !2109, inlinedAt: !2112)
!2120 = !{!2121}
!2121 = distinct !{!2121, !2122, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtB4_4cell10UnsafeCellNtNtCshxBJAVx362N_11runtime_lab7process7CaptureEEB14_: %_1"}
!2122 = distinct !{!2122, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtB4_4cell10UnsafeCellNtNtCshxBJAVx362N_11runtime_lab7process7CaptureEEB14_"}
!2123 = !{!2124}
!2124 = distinct !{!2124, !2125, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtCshxBJAVx362N_11runtime_lab7process7CaptureEBF_: %_1"}
!2125 = distinct !{!2125, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtNtCshxBJAVx362N_11runtime_lab7process7CaptureEBF_"}
!2126 = !DILocation(line: 847, column: 1, scope: !215, inlinedAt: !2127)
!2127 = distinct !DILocation(line: 847, column: 1, scope: !2059, inlinedAt: !2060)
!2128 = !DILocation(line: 847, column: 1, scope: !222, inlinedAt: !2129)
!2129 = distinct !DILocation(line: 847, column: 1, scope: !215, inlinedAt: !2127)
!2130 = !{!2124, !2121, !2076}
!2131 = !DILocation(line: 631, column: 39, scope: !225, inlinedAt: !2132)
!2132 = distinct !DILocation(line: 874, column: 52, scope: !230, inlinedAt: !2133)
!2133 = distinct !DILocation(line: 425, column: 29, scope: !233, inlinedAt: !2134)
!2134 = distinct !DILocation(line: 847, column: 1, scope: !236, inlinedAt: !2135)
!2135 = distinct !DILocation(line: 847, column: 1, scope: !238, inlinedAt: !2136)
!2136 = distinct !DILocation(line: 847, column: 1, scope: !222, inlinedAt: !2129)
!2137 = !DILocation(line: 175, column: 14, scope: !168, inlinedAt: !2138)
!2138 = distinct !DILocation(line: 321, column: 22, scope: !170, inlinedAt: !2139)
!2139 = distinct !DILocation(line: 436, column: 9, scope: !172, inlinedAt: !2140)
!2140 = distinct !DILocation(line: 554, column: 23, scope: !174, inlinedAt: !2141)
!2141 = distinct !DILocation(line: 876, column: 28, scope: !230, inlinedAt: !2133)
!2142 = !{!2124, !2121}
!2143 = !DILocation(line: 874, column: 9, scope: !231, inlinedAt: !2133)
!2144 = !DILocation(line: 847, column: 1, scope: !248, inlinedAt: !2145)
!2145 = distinct !DILocation(line: 847, column: 1, scope: !250, inlinedAt: !2146)
!2146 = distinct !DILocation(line: 847, column: 1, scope: !222, inlinedAt: !2129)
!2147 = !DILocation(line: 175, column: 14, scope: !168, inlinedAt: !2148)
!2148 = distinct !DILocation(line: 321, column: 22, scope: !170, inlinedAt: !2149)
!2149 = distinct !DILocation(line: 436, column: 9, scope: !172, inlinedAt: !2150)
!2150 = distinct !DILocation(line: 554, column: 23, scope: !174, inlinedAt: !2151)
!2151 = distinct !DILocation(line: 876, column: 28, scope: !230, inlinedAt: !2152)
!2152 = distinct !DILocation(line: 425, column: 29, scope: !233, inlinedAt: !2153)
!2153 = distinct !DILocation(line: 847, column: 1, scope: !236, inlinedAt: !2154)
!2154 = distinct !DILocation(line: 847, column: 1, scope: !238, inlinedAt: !2155)
!2155 = distinct !DILocation(line: 847, column: 1, scope: !261, inlinedAt: !2156)
!2156 = distinct !DILocation(line: 847, column: 1, scope: !248, inlinedAt: !2145)
!2157 = !DILocation(line: 874, column: 9, scope: !231, inlinedAt: !2152)
!2158 = !DILocation(line: 3398, column: 69, scope: !2109, inlinedAt: !2112)
!2159 = !DILocation(line: 4049, column: 24, scope: !2160, inlinedAt: !2161)
!2160 = distinct !DISubprogram(name: "atomic_sub<usize, usize>", linkageName: "_RINvNtNtCsjIpoRzUjyHQ_4core4sync6atomic10atomic_subjjECshxBJAVx362N_11runtime_lab", scope: !46, file: !45, line: 4043, type: !52, scopeLine: 4043, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!2161 = distinct !DILocation(line: 3253, column: 26, scope: !2162, inlinedAt: !2163)
!2162 = distinct !DISubprogram(name: "fetch_sub", linkageName: "_RNvMs1g_NtNtCsjIpoRzUjyHQ_4core4sync6atomicINtB6_6AtomicjE9fetch_sub", scope: !51, file: !45, line: 3251, type: !52, scopeLine: 3251, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!2163 = distinct !DILocation(line: 3544, column: 23, scope: !2164, inlinedAt: !2116)
!2164 = distinct !DILexicalBlock(scope: !2114, file: !1349, line: 3542, column: 9)
!2165 = !DILocation(line: 3544, column: 12, scope: !2164, inlinedAt: !2116)
!2166 = !DILocation(line: 4493, column: 24, scope: !1364, inlinedAt: !2167)
!2167 = distinct !DILocation(line: 69, column: 9, scope: !2164, inlinedAt: !2116)
!2168 = !DILocation(line: 175, column: 14, scope: !168, inlinedAt: !2169)
!2169 = distinct !DILocation(line: 321, column: 22, scope: !170, inlinedAt: !2170)
!2170 = distinct !DILocation(line: 436, column: 9, scope: !172, inlinedAt: !2171)
!2171 = distinct !DILocation(line: 554, column: 23, scope: !174, inlinedAt: !2172)
!2172 = distinct !DILocation(line: 582, column: 27, scope: !2173, inlinedAt: !2176)
!2173 = distinct !DISubprogram(name: "deallocate<alloc::alloc::Global>", linkageName: "_RNvXs0_NtCsjIpoRzUjyHQ_4core5allocRNtNtCs6zY7rJBZy9D_5alloc5alloc6GlobalNtB5_9Allocator10deallocateCshxBJAVx362N_11runtime_lab", scope: !2175, file: !2174, line: 580, type: !40, scopeLine: 580, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!2174 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/alloc/mod.rs", directory: "", checksumkind: CSK_MD5, checksum: "38c8aeed2125a53c1a785ff85780c84e")
!2175 = !DINamespace(name: "{impl#2}", scope: !912)
!2176 = distinct !DILocation(line: 3556, column: 28, scope: !2164, inlinedAt: !2116)
!2177 = !DILocation(line: 3544, column: 9, scope: !2164, inlinedAt: !2116)
!2178 = !DILocation(line: 3277, column: 5, scope: !2105, inlinedAt: !2179)
!2179 = distinct !DILocation(line: 3392, column: 12, scope: !2109, inlinedAt: !2180)
!2180 = distinct !DILocation(line: 3542, column: 47, scope: !2113, inlinedAt: !2181)
!2181 = distinct !DILocation(line: 847, column: 1, scope: !2117, inlinedAt: !2182)
!2182 = distinct !DILocation(line: 2150, column: 5, scope: !2050)
!2183 = !DILocation(line: 3392, column: 12, scope: !2109, inlinedAt: !2180)
!2184 = !DILocation(line: 3398, column: 69, scope: !2109, inlinedAt: !2180)
!2185 = !DILocation(line: 4049, column: 24, scope: !2160, inlinedAt: !2186)
!2186 = distinct !DILocation(line: 3253, column: 26, scope: !2162, inlinedAt: !2187)
!2187 = distinct !DILocation(line: 3544, column: 23, scope: !2164, inlinedAt: !2181)
!2188 = !DILocation(line: 3544, column: 12, scope: !2164, inlinedAt: !2181)
!2189 = !DILocation(line: 4493, column: 24, scope: !1364, inlinedAt: !2190)
!2190 = distinct !DILocation(line: 69, column: 9, scope: !2164, inlinedAt: !2181)
!2191 = !DILocation(line: 175, column: 14, scope: !168, inlinedAt: !2192)
!2192 = distinct !DILocation(line: 321, column: 22, scope: !170, inlinedAt: !2193)
!2193 = distinct !DILocation(line: 436, column: 9, scope: !172, inlinedAt: !2194)
!2194 = distinct !DILocation(line: 554, column: 23, scope: !174, inlinedAt: !2195)
!2195 = distinct !DILocation(line: 582, column: 27, scope: !2173, inlinedAt: !2196)
!2196 = distinct !DILocation(line: 3556, column: 28, scope: !2164, inlinedAt: !2181)
!2197 = !DILocation(line: 3544, column: 9, scope: !2164, inlinedAt: !2181)
!2198 = !DILocation(line: 2150, column: 6, scope: !2050)
!2199 = !DILocation(line: 2138, column: 5, scope: !2050)
!2200 = distinct !DISubprogram(name: "state_lock", linkageName: "_RNvNtCshxBJAVx362N_11runtime_lab7process10state_lock", scope: !1879, file: !2201, line: 55, type: !52, scopeLine: 55, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!2201 = !DIFile(filename: "src/process.rs", directory: "/Users/juanwang/Desktop/tutorials/cpp-rust/bench/runtime-lab", checksumkind: CSK_MD5, checksum: "1c223385d8a131cfd886bd793e2f4242")
!2202 = !{i64 7704678774611562527}
!2203 = !DILocation(line: 3995, column: 24, scope: !388, inlinedAt: !2204)
!2204 = distinct !DILocation(line: 1765, column: 18, scope: !390, inlinedAt: !2205)
!2205 = distinct !DILocation(line: 48, column: 28, scope: !392, inlinedAt: !2206)
!2206 = distinct !DILocation(line: 22, column: 18, scope: !2207, inlinedAt: !2208)
!2207 = distinct !DISubprogram(name: "get", linkageName: "_RNvMNtNtNtNtCs1SSuMAdGM58_3std3sys4sync5mutex7pthreadNtB2_5Mutex3get", scope: !395, file: !90, line: 19, type: !52, scopeLine: 19, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!2208 = distinct !DILocation(line: 36, column: 23, scope: !2209, inlinedAt: !2210)
!2209 = distinct !DISubprogram(name: "lock", linkageName: "_RNvMNtNtNtNtCs1SSuMAdGM58_3std3sys4sync5mutex7pthreadNtB2_5Mutex4lock", scope: !395, file: !90, line: 33, type: !52, scopeLine: 33, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!2210 = distinct !DILocation(line: 492, column: 24, scope: !2211, inlinedAt: !2212)
!2211 = distinct !DISubprogram(name: "lock<runtime_lab::process::Capture>", linkageName: "_RNvMs5_NtNtNtCs1SSuMAdGM58_3std4sync6poison5mutexINtB5_5MutexNtNtCshxBJAVx362N_11runtime_lab7process7CaptureE4lockB11_", scope: !401, file: !400, line: 490, type: !52, scopeLine: 490, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!2212 = distinct !DILocation(line: 57, column: 10, scope: !2200)
!2213 = !{!2214}
!2214 = distinct !{!2214, !2215, !"_RNvMs5_NtNtNtCs1SSuMAdGM58_3std4sync6poison5mutexINtB5_5MutexNtNtCshxBJAVx362N_11runtime_lab7process7CaptureE4lockB11_: %_0"}
!2215 = distinct !{!2215, !"_RNvMs5_NtNtNtCs1SSuMAdGM58_3std4sync6poison5mutexINtB5_5MutexNtNtCshxBJAVx362N_11runtime_lab7process7CaptureE4lockB11_"}
!2216 = !DILocation(line: 38, column: 17, scope: !419, inlinedAt: !2217)
!2217 = distinct !DILocation(line: 2636, column: 9, scope: !427, inlinedAt: !2218)
!2218 = distinct !DILocation(line: 23, column: 27, scope: !431, inlinedAt: !2219)
!2219 = distinct !DILocation(line: 265, column: 17, scope: !436, inlinedAt: !2220)
!2220 = distinct !DILocation(line: 49, column: 28, scope: !438, inlinedAt: !2206)
!2221 = !DILocation(line: 265, column: 12, scope: !436, inlinedAt: !2220)
!2222 = !DILocation(line: 51, column: 26, scope: !438, inlinedAt: !2206)
!2223 = !DILocation(line: 53, column: 5, scope: !392, inlinedAt: !2206)
!2224 = !DILocation(line: 0, scope: !438, inlinedAt: !2206)
!2225 = !DILocation(line: 36, column: 29, scope: !2209, inlinedAt: !2210)
!2226 = !DILocation(line: 3994, column: 24, scope: !444, inlinedAt: !2227)
!2227 = distinct !DILocation(line: 2916, column: 26, scope: !446, inlinedAt: !2228)
!2228 = distinct !DILocation(line: 465, column: 31, scope: !448, inlinedAt: !2229)
!2229 = distinct !DILocation(line: 606, column: 6, scope: !453, inlinedAt: !2230)
!2230 = distinct !DILocation(line: 221, column: 5, scope: !455, inlinedAt: !2231)
!2231 = distinct !DILocation(line: 118, column: 24, scope: !460, inlinedAt: !2232)
!2232 = distinct !DILocation(line: 720, column: 40, scope: !2233, inlinedAt: !2234)
!2233 = distinct !DISubprogram(name: "new<runtime_lab::process::Capture>", linkageName: "_RNvMs9_NtNtNtCs1SSuMAdGM58_3std4sync6poison5mutexINtB5_10MutexGuardNtNtCshxBJAVx362N_11runtime_lab7process7CaptureE3newB17_", scope: !465, file: !400, line: 719, type: !52, scopeLine: 719, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!2234 = distinct !DILocation(line: 493, column: 13, scope: !2211, inlinedAt: !2212)
!2235 = !DILocation(line: 465, column: 12, scope: !448, inlinedAt: !2229)
!2236 = !DILocation(line: 477, column: 13, scope: !448, inlinedAt: !2229)
!2237 = !DILocation(line: 606, column: 5, scope: !453, inlinedAt: !2230)
!2238 = !DILocation(line: 720, column: 28, scope: !2233, inlinedAt: !2234)
!2239 = !DILocation(line: 3994, column: 24, scope: !473, inlinedAt: !2240)
!2240 = distinct !DILocation(line: 762, column: 18, scope: !475, inlinedAt: !2241)
!2241 = distinct !DILocation(line: 138, column: 21, scope: !477, inlinedAt: !2242)
!2242 = distinct !DILocation(line: 120, column: 17, scope: !479, inlinedAt: !2232)
!2243 = !DILocation(line: 762, column: 18, scope: !475, inlinedAt: !2241)
!2244 = !DILocation(line: 120, scope: !479, inlinedAt: !2232)
!2245 = !DILocation(line: 965, column: 9, scope: !2246, inlinedAt: !2247)
!2246 = distinct !DISubprogram(name: "map_err<std::sync::poison::mutex::MutexGuard<runtime_lab::process::Capture>, std::sync::poison::PoisonError<std::sync::poison::mutex::MutexGuard<runtime_lab::process::Capture>>, core::io::error::Error, runtime_lab::process::state_lock::{closure_env#0}>", linkageName: "_RINvMNtCsjIpoRzUjyHQ_4core6resultINtB3_6ResultINtNtNtNtCs1SSuMAdGM58_3std4sync6poison5mutex10MutexGuardNtNtCshxBJAVx362N_11runtime_lab7process7CaptureEINtBN_11PoisonErrorBI_EE7map_errNtNtNtB5_2io5error5ErrorNCNvB1F_10state_lock0EB1H_", scope: !705, file: !381, line: 961, type: !52, scopeLine: 961, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!2247 = !DILocation(line: 58, column: 10, scope: !2200)
!2248 = !DILocation(line: 79, column: 9, scope: !2249, inlinedAt: !2252)
!2249 = distinct !DISubprogram(name: "other<&str>", linkageName: "_RINvMNtNtCs6zY7rJBZy9D_5alloc2io5errorNtNtNtCsjIpoRzUjyHQ_4core2io5error5Error5otherReECshxBJAVx362N_11runtime_lab", scope: !2251, file: !2250, line: 75, type: !52, scopeLine: 75, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!2250 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/alloc/src/io/error.rs", directory: "", checksumkind: CSK_MD5, checksum: "3740f3ea3b24719182b5b1f7e4b8ad78")
!2251 = !DINamespace(name: "Error", scope: !560)
!2252 = distinct !DILocation(line: 58, column: 22, scope: !2253, inlinedAt: !2255)
!2253 = distinct !DISubprogram(name: "{closure#0}", linkageName: "_RNCNvNtCshxBJAVx362N_11runtime_lab7process10state_lock0B5_", scope: !2254, file: !2201, line: 58, type: !52, scopeLine: 58, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!2254 = !DINamespace(name: "state_lock", scope: !1879)
!2255 = distinct !DILocation(line: 967, column: 27, scope: !2256, inlinedAt: !2247)
!2256 = distinct !DILexicalBlock(scope: !2246, file: !381, line: 967, column: 13)
!2257 = !DILocation(line: 58, column: 63, scope: !2253, inlinedAt: !2255)
!2258 = !DILocation(line: 126, column: 13, scope: !493, inlinedAt: !2259)
!2259 = distinct !DILocation(line: 745, column: 30, scope: !812, inlinedAt: !2260)
!2260 = distinct !DILocation(line: 847, column: 1, scope: !814, inlinedAt: !2261)
!2261 = distinct !DILocation(line: 847, column: 1, scope: !809, inlinedAt: !2262)
!2262 = distinct !DILocation(line: 58, column: 63, scope: !2253, inlinedAt: !2255)
!2263 = !DILocation(line: 3994, column: 24, scope: !444, inlinedAt: !2264)
!2264 = distinct !DILocation(line: 2916, column: 26, scope: !502, inlinedAt: !2265)
!2265 = distinct !DILocation(line: 465, column: 31, scope: !504, inlinedAt: !2266)
!2266 = distinct !DILocation(line: 606, column: 6, scope: !506, inlinedAt: !2267)
!2267 = distinct !DILocation(line: 221, column: 5, scope: !508, inlinedAt: !2268)
!2268 = distinct !DILocation(line: 126, column: 32, scope: !493, inlinedAt: !2259)
!2269 = !DILocation(line: 465, column: 12, scope: !504, inlinedAt: !2266)
!2270 = !DILocation(line: 477, column: 13, scope: !504, inlinedAt: !2266)
!2271 = !DILocation(line: 126, column: 32, scope: !493, inlinedAt: !2259)
!2272 = !DILocation(line: 3978, column: 24, scope: !515, inlinedAt: !2273)
!2273 = distinct !DILocation(line: 793, column: 13, scope: !517, inlinedAt: !2274)
!2274 = distinct !DILocation(line: 127, column: 25, scope: !493, inlinedAt: !2259)
!2275 = !DILocation(line: 126, column: 9, scope: !493, inlinedAt: !2259)
!2276 = !DILocation(line: 58, column: 18, scope: !2253, inlinedAt: !2255)
!2277 = !DILocation(line: 3994, column: 24, scope: !388, inlinedAt: !2278)
!2278 = distinct !DILocation(line: 1765, column: 18, scope: !833, inlinedAt: !2279)
!2279 = distinct !DILocation(line: 43, column: 48, scope: !835, inlinedAt: !2280)
!2280 = distinct !DILocation(line: 45, column: 27, scope: !837, inlinedAt: !2281)
!2281 = distinct !DILocation(line: 746, column: 29, scope: !812, inlinedAt: !2260)
!2282 = !DILocation(line: 45, column: 43, scope: !837, inlinedAt: !2281)
!2283 = !DILocation(line: 967, column: 32, scope: !2246, inlinedAt: !2247)
!2284 = !DILocation(line: 0, scope: !2246, inlinedAt: !2247)
!2285 = !DILocation(line: 59, column: 2, scope: !2200)
!2286 = distinct !DISubprogram(name: "pipe_cloexec", linkageName: "_RNvNtNtCshxBJAVx362N_11runtime_lab7process5macos12pipe_cloexec", scope: !1878, file: !1876, line: 16, type: !52, scopeLine: 16, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!2287 = !{i64 -7491267980566946713}
!2288 = !DILocation(line: 3995, column: 24, scope: !44, inlinedAt: !2289)
!2289 = distinct !DILocation(line: 1765, column: 18, scope: !2290, inlinedAt: !2291)
!2290 = distinct !DISubprogram(name: "load<()>", linkageName: "_RNvMs3_NtNtCsjIpoRzUjyHQ_4core4sync6atomicINtB5_6AtomicOuE4loadCshxBJAVx362N_11runtime_lab", scope: !51, file: !45, line: 1763, type: !52, scopeLine: 1763, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!2291 = distinct !DILocation(line: 135, column: 30, scope: !2292, inlinedAt: !2293)
!2292 = distinct !DISubprogram(name: "is_completed", linkageName: "_RNvMNtNtNtNtCs1SSuMAdGM58_3std3sys4sync4once5queueNtB2_4Once12is_completed", scope: !56, file: !55, line: 130, type: !52, scopeLine: 130, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!2293 = distinct !DILocation(line: 273, column: 20, scope: !2294, inlinedAt: !2295)
!2294 = distinct !DISubprogram(name: "is_completed", linkageName: "_RNvMs0_NtNtCs1SSuMAdGM58_3std4sync4onceNtB5_4Once12is_completed", scope: !64, file: !63, line: 272, type: !52, scopeLine: 272, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!2295 = distinct !DILocation(line: 547, column: 19, scope: !2296, inlinedAt: !2297)
!2296 = distinct !DISubprogram(name: "initialized<core::option::Option<unsafe extern \22C\22 fn(*mut i32, i32) -> i32>>", linkageName: "_RNvMNtNtCs1SSuMAdGM58_3std4sync9once_lockINtB2_8OnceLockINtNtCsjIpoRzUjyHQ_4core6option6OptionFUKCOllElEE11initializedCshxBJAVx362N_11runtime_lab", scope: !36, file: !35, line: 546, type: !52, scopeLine: 546, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!2297 = distinct !DILocation(line: 185, column: 17, scope: !2298, inlinedAt: !2299)
!2298 = distinct !DISubprogram(name: "get<core::option::Option<unsafe extern \22C\22 fn(*mut i32, i32) -> i32>>", linkageName: "_RNvMNtNtCs1SSuMAdGM58_3std4sync9once_lockINtB2_8OnceLockINtNtCsjIpoRzUjyHQ_4core6option6OptionFUKCOllElEE3getCshxBJAVx362N_11runtime_lab", scope: !36, file: !35, line: 184, type: !52, scopeLine: 184, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!2299 = distinct !DILocation(line: 436, column: 35, scope: !2300, inlinedAt: !2302)
!2300 = distinct !DILexicalBlock(scope: !2301, file: !35, line: 436, column: 41)
!2301 = distinct !DISubprogram(name: "get_or_try_init<core::option::Option<unsafe extern \22C\22 fn(*mut i32, i32) -> i32>, std::sync::once_lock::{impl#0}::get_or_init::{closure_env#0}<core::option::Option<unsafe extern \22C\22 fn(*mut i32, i32) -> i32>, runtime_lab::process::macos::pipe_cloexec::{closure_env#0}>, !>", linkageName: "_RINvMNtNtCs1SSuMAdGM58_3std4sync9once_lockINtB3_8OnceLockINtNtCsjIpoRzUjyHQ_4core6option6OptionFUKCOllElEE15get_or_try_initNCINvB2_11get_or_initNCNvNtNtCshxBJAVx362N_11runtime_lab7process5macos12pipe_cloexec0E0zEB2q_", scope: !36, file: !35, line: 427, type: !40, scopeLine: 427, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!2302 = distinct !DILocation(line: 350, column: 20, scope: !2303, inlinedAt: !2304)
!2303 = distinct !DISubprogram(name: "get_or_init<core::option::Option<unsafe extern \22C\22 fn(*mut i32, i32) -> i32>, runtime_lab::process::macos::pipe_cloexec::{closure_env#0}>", linkageName: "_RINvMNtNtCs1SSuMAdGM58_3std4sync9once_lockINtB3_8OnceLockINtNtCsjIpoRzUjyHQ_4core6option6OptionFUKCOllElEE11get_or_initNCNvNtNtCshxBJAVx362N_11runtime_lab7process5macos12pipe_cloexec0EB21_", scope: !36, file: !35, line: 346, type: !52, scopeLine: 346, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!2304 = !DILocation(line: 19, column: 10, scope: !2286)
!2305 = !DILocation(line: 135, column: 9, scope: !2292, inlinedAt: !2293)
!2306 = !DILocation(line: 185, column: 12, scope: !2298, inlinedAt: !2299)
!2307 = !DILocation(line: 439, column: 14, scope: !2301, inlinedAt: !2302)
!2308 = !DILocation(line: 443, column: 5, scope: !2301, inlinedAt: !2302)
!2309 = !DILocation(line: 18, column: 17, scope: !2286)
!2310 = !DILocation(line: 1363, column: 15, scope: !2311, inlinedAt: !2312)
!2311 = distinct !DISubprogram(name: "ok_or_else<unsafe extern \22C\22 fn(*mut i32, i32) -> i32, core::io::error::Error, runtime_lab::process::macos::pipe_cloexec::{closure_env#1}>", linkageName: "_RINvMNtCsjIpoRzUjyHQ_4core6optionINtB3_6OptionFUKCOllElE10ok_or_elseNtNtNtB5_2io5error5ErrorNCNvNtNtCshxBJAVx362N_11runtime_lab7process5macos12pipe_cloexecs_0EB1A_", scope: !339, file: !338, line: 1359, type: !52, scopeLine: 1359, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!2312 = !DILocation(line: 31, column: 10, scope: !2286)
!2313 = !DILocation(line: 1363, column: 9, scope: !2311, inlinedAt: !2312)
!2314 = !DILocation(line: 35, column: 9, scope: !2315)
!2315 = distinct !DILexicalBlock(scope: !2286, file: !1876, line: 18, column: 5)
!2316 = !DILocation(line: 35, column: 19, scope: !2315)
!2317 = !DILocation(line: 38, column: 17, scope: !2318)
!2318 = distinct !DILexicalBlock(scope: !2315, file: !1876, line: 35, column: 5)
!2319 = !DILocation(line: 38, column: 8, scope: !2318)
!2320 = !DILocation(line: 32, column: 13, scope: !2321, inlinedAt: !2322)
!2321 = distinct !DISubprogram(name: "{closure#1}", linkageName: "_RNCNvNtNtCshxBJAVx362N_11runtime_lab7process5macos12pipe_cloexecs_0B7_", scope: !1877, file: !1876, line: 31, type: !52, scopeLine: 31, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!2322 = !DILocation(line: 1365, column: 25, scope: !2311, inlinedAt: !2312)
!2323 = !DILocation(line: 2193, column: 23, scope: !2324, inlinedAt: !2327)
!2324 = distinct !DILexicalBlock(scope: !2325, file: !381, line: 2193, column: 13)
!2325 = distinct !DISubprogram(name: "from_residual<(std::os::fd::owned::OwnedFd, std::os::fd::owned::OwnedFd), core::io::error::Error, core::io::error::Error>", linkageName: "_RNvXsq_NtCsjIpoRzUjyHQ_4core6resultINtB5_6ResultTNtNtNtNtCs1SSuMAdGM58_3std2os2fd5owned7OwnedFdBL_ENtNtNtB7_2io5error5ErrorEINtNtNtB7_3ops9try_trait12FromResidualIBy_NtNtB7_7convert10InfallibleB1z_EE13from_residualCshxBJAVx362N_11runtime_lab", scope: !2326, file: !381, line: 2191, type: !52, scopeLine: 2191, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!2326 = !DINamespace(name: "{impl#28}", scope: !383)
!2327 = !DILocation(line: 18, column: 17, scope: !2328)
!2328 = !DILexicalBlockFile(scope: !2329, file: !1876, discriminator: 2)
!2329 = distinct !DILexicalBlock(scope: !2330, file: !1876, line: 34, column: 11)
!2330 = distinct !DILexicalBlock(scope: !2286, file: !1876, line: 34, column: 11)
!2331 = !DILocation(line: 0, scope: !2332)
!2332 = !DILexicalBlockFile(scope: !2286, file: !1930, discriminator: 0)
!2333 = !DILocation(line: 44, column: 2, scope: !2286)
!2334 = !DILocation(line: 43, column: 39, scope: !2318)
!2335 = !DILocation(line: 133, column: 37, scope: !2336, inlinedAt: !2343)
!2336 = distinct !DILexicalBlock(scope: !2338, file: !2337, line: 25, column: 35)
!2337 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/num/niche_types.rs", directory: "", checksumkind: CSK_MD5, checksum: "489873530aeeab72b6610b8d531aed40")
!2338 = distinct !DILexicalBlock(scope: !2339, file: !2337, line: 25, column: 17)
!2339 = distinct !DISubprogram(name: "new", linkageName: "_RNvMs25_NtNtCsjIpoRzUjyHQ_4core3num11niche_typesNtB6_13I32NotAllOnes3new", scope: !2340, file: !2337, line: 23, type: !52, scopeLine: 23, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!2340 = !DINamespace(name: "I32NotAllOnes", scope: !2341)
!2341 = !DINamespace(name: "niche_types", scope: !2342)
!2342 = !DINamespace(name: "num", scope: !48)
!2343 = !DILocation(line: 195, column: 20, scope: !2344, inlinedAt: !2346)
!2344 = distinct !DISubprogram(name: "from_raw_fd", linkageName: "_RNvXs4_NtNtNtCs1SSuMAdGM58_3std2os2fd5ownedNtB5_7OwnedFdNtNtB7_3raw9FromRawFd11from_raw_fd", scope: !2345, file: !279, line: 194, type: !52, scopeLine: 194, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!2345 = !DINamespace(name: "{impl#6}", scope: !281)
!2346 = !DILocation(line: 43, column: 18, scope: !2318)
!2347 = !{!"branch_weights", i32 1, i32 4001}
!2348 = !DILocation(line: 56, column: 16, scope: !2349, inlinedAt: !2354)
!2349 = distinct !DISubprogram(name: "errno", linkageName: "_RNvNtNtNtNtCs1SSuMAdGM58_3std3sys2io5error4unix5errno", scope: !2351, file: !2350, line: 55, type: !52, scopeLine: 55, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!2350 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/std/src/sys/io/error/unix.rs", directory: "", checksumkind: CSK_MD5, checksum: "df3d6a0d610f645b14fc2fc4b35c4f94")
!2351 = !DINamespace(name: "unix", scope: !2352)
!2352 = !DINamespace(name: "error", scope: !2353)
!2353 = !DINamespace(name: "io", scope: !60)
!2354 = !DILocation(line: 44, column: 34, scope: !2355, inlinedAt: !2357)
!2355 = distinct !DISubprogram(name: "last_os_error", linkageName: "_RNvMNtNtCs1SSuMAdGM58_3std2io5errorNtNtNtCsjIpoRzUjyHQ_4core2io5error5Error13last_os_error", scope: !2251, file: !2356, line: 43, type: !52, scopeLine: 43, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!2356 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/std/src/io/error.rs", directory: "", checksumkind: CSK_MD5, checksum: "daeb13ce1046508a4481f800e91c06a4")
!2357 = !DILocation(line: 39, column: 20, scope: !2318)
!2358 = !DILocation(line: 56, column: 14, scope: !2349, inlinedAt: !2354)
!2359 = !DILocation(line: 3994, column: 24, scope: !2360, inlinedAt: !2361)
!2360 = distinct !DISubprogram(name: "atomic_load<*mut core::io::error::OsFunctions>", linkageName: "_RINvNtNtCsjIpoRzUjyHQ_4core4sync6atomic11atomic_loadONtNtNtB6_2io5error11OsFunctionsECshxBJAVx362N_11runtime_lab", scope: !46, file: !45, line: 3990, type: !40, scopeLine: 3990, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!2361 = distinct !DILocation(line: 1765, column: 18, scope: !2362, inlinedAt: !2363)
!2362 = distinct !DISubprogram(name: "load<core::io::error::OsFunctions>", linkageName: "_RNvMs3_NtNtCsjIpoRzUjyHQ_4core4sync6atomicINtB5_6AtomicONtNtNtB9_2io5error11OsFunctionsE4loadCshxBJAVx362N_11runtime_lab", scope: !51, file: !45, line: 1763, type: !52, scopeLine: 1763, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!2363 = distinct !DILocation(line: 40, column: 21, scope: !2364, inlinedAt: !2367)
!2364 = distinct !DISubprogram(name: "set_functions", linkageName: "_RNvNtNtNtCsjIpoRzUjyHQ_4core2io5error12os_functions13set_functions", scope: !2366, file: !2365, line: 34, type: !52, scopeLine: 34, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!2365 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/io/error/os_functions_atomic.rs", directory: "", checksumkind: CSK_MD5, checksum: "21ca2a08ac60b43a452e86fbbda8435c")
!2366 = !DINamespace(name: "os_functions", scope: !560)
!2367 = distinct !DILocation(line: 282, column: 13, scope: !2368, inlinedAt: !2369)
!2368 = distinct !DISubprogram(name: "from_raw_os_error_with_functions", linkageName: "_RNvMs1_NtNtCsjIpoRzUjyHQ_4core2io5errorNtB5_5Error32from_raw_os_error_with_functions", scope: !2251, file: !580, line: 276, type: !40, scopeLine: 276, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!2369 = distinct !DILocation(line: 84, column: 18, scope: !2370, inlinedAt: !2371)
!2370 = distinct !DISubprogram(name: "from_raw_os_error", linkageName: "_RNvMNtNtCs1SSuMAdGM58_3std2io5errorNtNtNtCsjIpoRzUjyHQ_4core2io5error5Error17from_raw_os_error", scope: !2251, file: !2356, line: 76, type: !52, scopeLine: 76, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!2371 = !DILocation(line: 44, column: 9, scope: !2355, inlinedAt: !2357)
!2372 = !DILocation(line: 40, column: 8, scope: !2364, inlinedAt: !2367)
!2373 = !DILocation(line: 41, column: 9, scope: !2364, inlinedAt: !2367)
!2374 = !DILocation(line: 170, column: 24, scope: !2375, inlinedAt: !2377)
!2375 = distinct !DISubprogram(name: "new_os", linkageName: "_RNvMs0_NtNtNtCsjIpoRzUjyHQ_4core2io5error4reprNtB5_4Repr6new_os", scope: !2376, file: !557, line: 169, type: !52, scopeLine: 169, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!2376 = !DINamespace(name: "Repr", scope: !559)
!2377 = distinct !DILocation(line: 284, column: 23, scope: !2368, inlinedAt: !2369)
!2378 = !DILocation(line: 170, column: 23, scope: !2375, inlinedAt: !2377)
!2379 = !DILocation(line: 105, column: 18, scope: !2380, inlinedAt: !2381)
!2380 = distinct !DISubprogram(name: "without_provenance<()>", linkageName: "_RNvMs0_NtNtCsjIpoRzUjyHQ_4core3ptr8non_nullINtB5_7NonNulluE18without_provenanceCshxBJAVx362N_11runtime_lab", scope: !599, file: !598, line: 103, type: !52, scopeLine: 103, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!2381 = distinct !DILocation(line: 173, column: 24, scope: !2382, inlinedAt: !2377)
!2382 = distinct !DILexicalBlock(scope: !2383, file: !557, line: 172, column: 9)
!2383 = distinct !DILexicalBlock(scope: !2375, file: !557, line: 170, column: 9)
!2384 = !DILocation(line: 39, column: 16, scope: !2318)
!2385 = !DILocation(line: 44, column: 1, scope: !2315)
!2386 = !DILocation(line: 0, scope: !2387)
!2387 = !DILexicalBlockFile(scope: !2315, file: !1930, discriminator: 0)
!2388 = !DILocation(line: 43, column: 69, scope: !2318)
!2389 = !DILocation(line: 133, column: 37, scope: !2390, inlinedAt: !2392)
!2390 = distinct !DILexicalBlock(scope: !2391, file: !2337, line: 25, column: 35)
!2391 = distinct !DILexicalBlock(scope: !2339, file: !2337, line: 25, column: 17)
!2392 = !DILocation(line: 195, column: 20, scope: !2393, inlinedAt: !2394)
!2393 = !DILexicalBlockFile(scope: !2344, file: !279, discriminator: 2)
!2394 = !DILocation(line: 43, column: 48, scope: !2318)
!2395 = !DILocation(line: 969, column: 21, scope: !2396, inlinedAt: !2397)
!2396 = distinct !DISubprogram(name: "expect<core::num::niche_types::I32NotAllOnes>", linkageName: "_RNvMNtCsjIpoRzUjyHQ_4core6optionINtB2_6OptionNtNtNtB4_3num11niche_types13I32NotAllOnesE6expectCshxBJAVx362N_11runtime_lab", scope: !339, file: !338, line: 966, type: !52, scopeLine: 966, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!2397 = !DILocation(line: 195, column: 40, scope: !2344, inlinedAt: !2346)
!2398 = !DILocation(line: 43, column: 5, scope: !2318)
!2399 = !DILocation(line: 969, column: 21, scope: !2396, inlinedAt: !2400)
!2400 = !DILocation(line: 195, column: 40, scope: !2393, inlinedAt: !2394)
!2401 = !DILocation(line: 220, column: 25, scope: !278, inlinedAt: !2402)
!2402 = distinct !DILocation(line: 847, column: 1, scope: !285, inlinedAt: !2403)
!2403 = distinct !DILocation(line: 43, column: 76, scope: !2318)
!2404 = !DILocation(line: 16, column: 1, scope: !2286)
!2405 = distinct !DISubprogram(name: "spawn_captured", linkageName: "_RNvNtNtCshxBJAVx362N_11runtime_lab7process5macos14spawn_captured", scope: !1878, file: !1876, line: 46, type: !52, scopeLine: 46, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!2406 = !{i64 2433378237877807608}
!2407 = !DILocation(line: 49, column: 33, scope: !2405)
!2408 = !DILocation(line: 2177, column: 15, scope: !2409, inlinedAt: !2407)
!2409 = distinct !DISubprogram(name: "branch<(std::os::fd::owned::OwnedFd, std::os::fd::owned::OwnedFd), core::io::error::Error>", linkageName: "_RNvXsp_NtCsjIpoRzUjyHQ_4core6resultINtB5_6ResultTNtNtNtNtCs1SSuMAdGM58_3std2os2fd5owned7OwnedFdBL_ENtNtNtB7_2io5error5ErrorENtNtNtB7_3ops9try_trait3Try6branchCshxBJAVx362N_11runtime_lab", scope: !382, file: !381, line: 2176, type: !52, scopeLine: 2176, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!2410 = !DILocation(line: 2177, column: 9, scope: !2409, inlinedAt: !2407)
!2411 = !DILocation(line: 2179, column: 17, scope: !2409, inlinedAt: !2407)
!2412 = !DILocation(line: 49, column: 47, scope: !2405)
!2413 = !DILocation(line: 2193, column: 23, scope: !2414, inlinedAt: !2416)
!2414 = distinct !DILexicalBlock(scope: !2415, file: !381, line: 2193, column: 13)
!2415 = distinct !DISubprogram(name: "from_residual<(tokio::process::Child, tokio::process::ChildStdout, tokio::process::ChildStderr), core::io::error::Error, core::io::error::Error>", linkageName: "_RNvXsq_NtCsjIpoRzUjyHQ_4core6resultINtB5_6ResultTNtNtCs3EIJ1qnJmKW_5tokio7process5ChildNtBN_11ChildStdoutNtBN_11ChildStderrENtNtNtB7_2io5error5ErrorEINtNtNtB7_3ops9try_trait12FromResidualIBy_NtNtB7_7convert10InfallibleB1Y_EE13from_residualCshxBJAVx362N_11runtime_lab", scope: !2326, file: !381, line: 2191, type: !52, scopeLine: 2191, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!2416 = !DILocation(line: 49, column: 33, scope: !2417)
!2417 = !DILexicalBlockFile(scope: !2418, file: !1876, discriminator: 2)
!2418 = distinct !DILexicalBlock(scope: !2419, file: !1876, line: 49, column: 47)
!2419 = distinct !DILexicalBlock(scope: !2405, file: !1876, line: 49, column: 47)
!2420 = !DILocation(line: 0, scope: !2421)
!2421 = !DILexicalBlockFile(scope: !2405, file: !1930, discriminator: 0)
!2422 = !DILocation(line: 2178, column: 16, scope: !2409, inlinedAt: !2407)
!2423 = !DILocation(line: 50, column: 33, scope: !2424)
!2424 = distinct !DILexicalBlock(scope: !2405, file: !1876, line: 49, column: 5)
!2425 = !DILocation(line: 62, column: 1, scope: !2405)
!2426 = !DILocation(line: 2177, column: 15, scope: !2409, inlinedAt: !2423)
!2427 = !DILocation(line: 2177, column: 9, scope: !2409, inlinedAt: !2423)
!2428 = !DILocation(line: 2178, column: 16, scope: !2409, inlinedAt: !2423)
!2429 = !DILocation(line: 50, column: 47, scope: !2424)
!2430 = !DILocation(line: 52, column: 9, scope: !2431)
!2431 = distinct !DILexicalBlock(scope: !2424, file: !1876, line: 50, column: 5)
!2432 = !DILocation(line: 52, column: 15, scope: !2431)
!2433 = !DILocation(line: 62, column: 1, scope: !2424)
!2434 = !DILocation(line: 220, column: 25, scope: !278, inlinedAt: !2435)
!2435 = distinct !DILocation(line: 847, column: 1, scope: !285, inlinedAt: !2436)
!2436 = distinct !DILocation(line: 62, column: 1, scope: !2424)
!2437 = !DILocation(line: 2177, column: 15, scope: !2438, inlinedAt: !2432)
!2438 = distinct !DISubprogram(name: "branch<tokio::process::ChildStdout, core::io::error::Error>", linkageName: "_RNvXsp_NtCsjIpoRzUjyHQ_4core6resultINtB5_6ResultNtNtCs3EIJ1qnJmKW_5tokio7process11ChildStdoutNtNtNtB7_2io5error5ErrorENtNtNtB7_3ops9try_trait3Try6branchCshxBJAVx362N_11runtime_lab", scope: !382, file: !381, line: 2176, type: !52, scopeLine: 2176, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!2439 = !DILocation(line: 0, scope: !2438, inlinedAt: !2432)
!2440 = !DILocation(line: 2177, column: 9, scope: !2438, inlinedAt: !2432)
!2441 = !DILocation(line: 2178, column: 16, scope: !2438, inlinedAt: !2432)
!2442 = !DILocation(line: 52, column: 15, scope: !2443)
!2443 = distinct !DILexicalBlock(scope: !2444, file: !1876, line: 52, column: 15)
!2444 = distinct !DILexicalBlock(scope: !2431, file: !1876, line: 52, column: 79)
!2445 = !DILocation(line: 52, column: 79, scope: !2431)
!2446 = !DILocation(line: 53, column: 9, scope: !2447)
!2447 = distinct !DILexicalBlock(scope: !2431, file: !1876, line: 52, column: 5)
!2448 = !DILocation(line: 53, column: 15, scope: !2447)
!2449 = !DILocation(line: 847, column: 1, scope: !752, inlinedAt: !2450)
!2450 = distinct !DILocation(line: 62, column: 1, scope: !2431)
!2451 = !DILocation(line: 2177, column: 15, scope: !2452, inlinedAt: !2448)
!2452 = distinct !DISubprogram(name: "branch<tokio::process::ChildStderr, core::io::error::Error>", linkageName: "_RNvXsp_NtCsjIpoRzUjyHQ_4core6resultINtB5_6ResultNtNtCs3EIJ1qnJmKW_5tokio7process11ChildStderrNtNtNtB7_2io5error5ErrorENtNtNtB7_3ops9try_trait3Try6branchCshxBJAVx362N_11runtime_lab", scope: !382, file: !381, line: 2176, type: !52, scopeLine: 2176, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!2453 = !DILocation(line: 0, scope: !2452, inlinedAt: !2448)
!2454 = !DILocation(line: 2177, column: 9, scope: !2452, inlinedAt: !2448)
!2455 = !DILocation(line: 53, column: 79, scope: !2447)
!2456 = !DILocation(line: 2193, column: 23, scope: !2457, inlinedAt: !2458)
!2457 = distinct !DILexicalBlock(scope: !2415, file: !381, line: 2193, column: 13)
!2458 = !DILocation(line: 53, column: 15, scope: !2459)
!2459 = !DILexicalBlockFile(scope: !2460, file: !1876, discriminator: 2)
!2460 = distinct !DILexicalBlock(scope: !2461, file: !1876, line: 53, column: 79)
!2461 = distinct !DILexicalBlock(scope: !2447, file: !1876, line: 53, column: 79)
!2462 = !DILocation(line: 62, column: 1, scope: !2447)
!2463 = !DILocation(line: 847, column: 1, scope: !752, inlinedAt: !2464)
!2464 = distinct !DILocation(line: 62, column: 1, scope: !2431)
!2465 = !DILocation(line: 2178, column: 16, scope: !2452, inlinedAt: !2448)
!2466 = !DILocation(line: 53, column: 15, scope: !2467)
!2467 = distinct !DILexicalBlock(scope: !2468, file: !1876, line: 53, column: 15)
!2468 = distinct !DILexicalBlock(scope: !2447, file: !1876, line: 53, column: 79)
!2469 = !DILocation(line: 1031, column: 20, scope: !2470, inlinedAt: !2474)
!2470 = distinct !DISubprogram(name: "stdout<std::os::fd::owned::OwnedFd>", linkageName: "_RINvMsi_NtCs1SSuMAdGM58_3std7processNtB6_7Command6stdoutNtNtNtNtB8_2os2fd5owned7OwnedFdECshxBJAVx362N_11runtime_lab", scope: !2472, file: !2471, line: 1030, type: !52, scopeLine: 1030, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!2471 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/std/src/process.rs", directory: "", checksumkind: CSK_MD5, checksum: "d0cb31a0cc6fab21e82717ff08551f66")
!2472 = !DINamespace(name: "Command", scope: !2473)
!2473 = !DINamespace(name: "process", scope: !39)
!2474 = distinct !DILocation(line: 607, column: 18, scope: !2475, inlinedAt: !2477)
!2475 = distinct !DISubprogram(name: "stdout<std::os::fd::owned::OwnedFd>", linkageName: "_RINvMNtCs3EIJ1qnJmKW_5tokio7processNtB3_7Command6stdoutNtNtNtNtCs1SSuMAdGM58_3std2os2fd5owned7OwnedFdECshxBJAVx362N_11runtime_lab", scope: !2476, file: !690, line: 606, type: !52, scopeLine: 606, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!2476 = !DINamespace(name: "Command", scope: !692)
!2477 = !DILocation(line: 54, column: 13, scope: !2478)
!2478 = distinct !DILexicalBlock(scope: !2447, file: !1876, line: 53, column: 5)
!2479 = !DILocation(line: 847, column: 1, scope: !768, inlinedAt: !2480)
!2480 = distinct !DILocation(line: 62, column: 1, scope: !2447)
!2481 = !DILocation(line: 1058, column: 20, scope: !2482, inlinedAt: !2483)
!2482 = distinct !DISubprogram(name: "stderr<std::os::fd::owned::OwnedFd>", linkageName: "_RINvMsi_NtCs1SSuMAdGM58_3std7processNtB6_7Command6stderrNtNtNtNtB8_2os2fd5owned7OwnedFdECshxBJAVx362N_11runtime_lab", scope: !2472, file: !2471, line: 1057, type: !52, scopeLine: 1057, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!2483 = distinct !DILocation(line: 634, column: 18, scope: !2484, inlinedAt: !2485)
!2484 = distinct !DISubprogram(name: "stderr<std::os::fd::owned::OwnedFd>", linkageName: "_RINvMNtCs3EIJ1qnJmKW_5tokio7processNtB3_7Command6stderrNtNtNtNtCs1SSuMAdGM58_3std2os2fd5owned7OwnedFdECshxBJAVx362N_11runtime_lab", scope: !2476, file: !690, line: 633, type: !52, scopeLine: 633, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!2485 = !DILocation(line: 54, column: 31, scope: !2478)
!2486 = !DILocation(line: 55, column: 9, scope: !2478)
!2487 = !{!2488}
!2488 = distinct !{!2488, !2489, !"_RNvMNtCs3EIJ1qnJmKW_5tokio7processNtB2_7Command5spawn: %_0"}
!2489 = distinct !{!2489, !"_RNvMNtCs3EIJ1qnJmKW_5tokio7processNtB2_7Command5spawn"}
!2490 = !DILocation(line: 55, column: 26, scope: !2478)
!2491 = !DILocation(line: 865, column: 21, scope: !2492, inlinedAt: !2493)
!2492 = distinct !DISubprogram(name: "spawn", linkageName: "_RNvMNtCs3EIJ1qnJmKW_5tokio7processNtB2_7Command5spawn", scope: !2476, file: !690, line: 863, type: !52, scopeLine: 863, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!2493 = distinct !DILocation(line: 55, column: 26, scope: !2478)
!2494 = !{!2488, !2495}
!2495 = distinct !{!2495, !2489, !"_RNvMNtCs3EIJ1qnJmKW_5tokio7processNtB2_7Command5spawn: %self"}
!2496 = !DILocation(line: 865, column: 30, scope: !2492, inlinedAt: !2493)
!2497 = !DILocation(line: 2177, column: 15, scope: !2498, inlinedAt: !2499)
!2498 = distinct !DISubprogram(name: "branch<std::process::Child, core::io::error::Error>", linkageName: "_RNvXsp_NtCsjIpoRzUjyHQ_4core6resultINtB5_6ResultNtNtCs1SSuMAdGM58_3std7process5ChildNtNtNtB7_2io5error5ErrorENtNtNtB7_3ops9try_trait3Try6branchCshxBJAVx362N_11runtime_lab", scope: !382, file: !381, line: 2176, type: !52, scopeLine: 2176, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!2499 = distinct !DILocation(line: 865, column: 21, scope: !2492, inlinedAt: !2493)
!2500 = !DILocation(line: 2177, column: 9, scope: !2498, inlinedAt: !2499)
!2501 = !DILocation(line: 2179, column: 17, scope: !2498, inlinedAt: !2499)
!2502 = !DILocation(line: 865, column: 37, scope: !2492, inlinedAt: !2493)
!2503 = !DILocation(line: 2193, column: 23, scope: !2504, inlinedAt: !2506)
!2504 = distinct !DILexicalBlock(scope: !2505, file: !381, line: 2193, column: 13)
!2505 = distinct !DISubprogram(name: "from_residual<tokio::process::Child, core::io::error::Error, core::io::error::Error>", linkageName: "_RNvXsq_NtCsjIpoRzUjyHQ_4core6resultINtB5_6ResultNtNtCs3EIJ1qnJmKW_5tokio7process5ChildNtNtNtB7_2io5error5ErrorEINtNtNtB7_3ops9try_trait12FromResidualIBy_NtNtB7_7convert10InfallibleB1m_EE13from_residualCshxBJAVx362N_11runtime_lab", scope: !2326, file: !381, line: 2191, type: !52, scopeLine: 2191, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!2506 = distinct !DILocation(line: 865, column: 21, scope: !2507, inlinedAt: !2493)
!2507 = !DILexicalBlockFile(scope: !2508, file: !690, discriminator: 2)
!2508 = distinct !DILexicalBlock(scope: !2509, file: !690, line: 865, column: 37)
!2509 = distinct !DILexicalBlock(scope: !2492, file: !690, line: 865, column: 37)
!2510 = !{!2495}
!2511 = !DILocation(line: 867, column: 6, scope: !2492, inlinedAt: !2493)
!2512 = !DILocation(line: 2178, column: 16, scope: !2498, inlinedAt: !2499)
!2513 = !DILocation(line: 866, column: 14, scope: !2514, inlinedAt: !2493)
!2514 = distinct !DILexicalBlock(scope: !2492, file: !690, line: 865, column: 9)
!2515 = !DILocation(line: 1031, column: 20, scope: !2516, inlinedAt: !2517)
!2516 = distinct !DISubprogram(name: "stdout<std::process::Stdio>", linkageName: "_RINvMsi_NtCs1SSuMAdGM58_3std7processNtB6_7Command6stdoutNtB6_5StdioECshxBJAVx362N_11runtime_lab", scope: !2472, file: !2471, line: 1030, type: !52, scopeLine: 1030, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!2517 = distinct !DILocation(line: 607, column: 18, scope: !2518, inlinedAt: !2519)
!2518 = distinct !DISubprogram(name: "stdout<std::process::Stdio>", linkageName: "_RINvMNtCs3EIJ1qnJmKW_5tokio7processNtB3_7Command6stdoutNtNtCs1SSuMAdGM58_3std7process5StdioECshxBJAVx362N_11runtime_lab", scope: !2476, file: !690, line: 606, type: !52, scopeLine: 606, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!2519 = !DILocation(line: 59, column: 10, scope: !2520)
!2520 = distinct !DILexicalBlock(scope: !2478, file: !1876, line: 55, column: 5)
!2521 = !DILocation(line: 62, column: 1, scope: !2478)
!2522 = !DILocation(line: 1058, column: 20, scope: !2523, inlinedAt: !2524)
!2523 = distinct !DISubprogram(name: "stderr<std::process::Stdio>", linkageName: "_RINvMsi_NtCs1SSuMAdGM58_3std7processNtB6_7Command6stderrNtB6_5StdioECshxBJAVx362N_11runtime_lab", scope: !2472, file: !2471, line: 1057, type: !52, scopeLine: 1057, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!2524 = distinct !DILocation(line: 634, column: 18, scope: !2525, inlinedAt: !2526)
!2525 = distinct !DISubprogram(name: "stderr<std::process::Stdio>", linkageName: "_RINvMNtCs3EIJ1qnJmKW_5tokio7processNtB3_7Command6stderrNtNtCs1SSuMAdGM58_3std7process5StdioECshxBJAVx362N_11runtime_lab", scope: !2476, file: !690, line: 633, type: !52, scopeLine: 633, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!2526 = !DILocation(line: 60, column: 10, scope: !2520)
!2527 = !DILocation(line: 61, column: 9, scope: !2520)
!2528 = !DILocation(line: 2177, column: 15, scope: !2529, inlinedAt: !2527)
!2529 = distinct !DISubprogram(name: "branch<tokio::process::Child, core::io::error::Error>", linkageName: "_RNvXsp_NtCsjIpoRzUjyHQ_4core6resultINtB5_6ResultNtNtCs3EIJ1qnJmKW_5tokio7process5ChildNtNtNtB7_2io5error5ErrorENtNtNtB7_3ops9try_trait3Try6branchCshxBJAVx362N_11runtime_lab", scope: !382, file: !381, line: 2176, type: !52, scopeLine: 2176, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!2530 = !DILocation(line: 2177, column: 9, scope: !2529, inlinedAt: !2527)
!2531 = !DILocation(line: 2193, column: 23, scope: !2532, inlinedAt: !2533)
!2532 = distinct !DILexicalBlock(scope: !2415, file: !381, line: 2193, column: 13)
!2533 = !DILocation(line: 61, column: 9, scope: !2534)
!2534 = !DILexicalBlockFile(scope: !2535, file: !1876, discriminator: 2)
!2535 = distinct !DILexicalBlock(scope: !2536, file: !1876, line: 61, column: 15)
!2536 = distinct !DILexicalBlock(scope: !2520, file: !1876, line: 61, column: 15)
!2537 = !DILocation(line: 847, column: 1, scope: !768, inlinedAt: !2538)
!2538 = distinct !DILocation(line: 62, column: 1, scope: !2447)
!2539 = !DILocation(line: 61, column: 5, scope: !2520)
!2540 = !DILocation(line: 2178, column: 16, scope: !2529, inlinedAt: !2527)
!2541 = !DILocation(line: 61, column: 18, scope: !2520)
!2542 = !DILocation(line: 61, column: 23, scope: !2520)
!2543 = !DILocation(line: 62, column: 1, scope: !2431)
!2544 = !DILocation(line: 62, column: 2, scope: !2405)
!2545 = !DILocation(line: 847, column: 1, scope: !752, inlinedAt: !2546)
!2546 = distinct !DILocation(line: 62, column: 1, scope: !2431)
!2547 = !DILocation(line: 847, column: 1, scope: !752, inlinedAt: !2548)
!2548 = distinct !DILocation(line: 62, column: 1, scope: !2431)
!2549 = !DILocation(line: 46, column: 1, scope: !2405)
!2550 = !DILocation(line: 220, column: 25, scope: !278, inlinedAt: !2551)
!2551 = distinct !DILocation(line: 847, column: 1, scope: !285, inlinedAt: !2552)
!2552 = distinct !DILocation(line: 62, column: 1, scope: !2424)
!2553 = !DILocation(line: 2193, column: 23, scope: !2554, inlinedAt: !2555)
!2554 = distinct !DILexicalBlock(scope: !2415, file: !381, line: 2193, column: 13)
!2555 = !DILocation(line: 52, column: 15, scope: !2556)
!2556 = !DILexicalBlockFile(scope: !2557, file: !1876, discriminator: 2)
!2557 = distinct !DILexicalBlock(scope: !2558, file: !1876, line: 52, column: 79)
!2558 = distinct !DILexicalBlock(scope: !2431, file: !1876, line: 52, column: 79)
!2559 = !DILocation(line: 220, column: 25, scope: !278, inlinedAt: !2560)
!2560 = distinct !DILocation(line: 847, column: 1, scope: !285, inlinedAt: !2561)
!2561 = distinct !DILocation(line: 62, column: 1, scope: !2424)
!2562 = !DILocation(line: 220, column: 25, scope: !278, inlinedAt: !2563)
!2563 = distinct !DILocation(line: 847, column: 1, scope: !285, inlinedAt: !2564)
!2564 = distinct !DILocation(line: 62, column: 1, scope: !2424)
!2565 = !DILocation(line: 847, column: 1, scope: !285, inlinedAt: !2564)
!2566 = !DILocation(line: 220, column: 25, scope: !278, inlinedAt: !2567)
!2567 = distinct !DILocation(line: 847, column: 1, scope: !285, inlinedAt: !2568)
!2568 = distinct !DILocation(line: 62, column: 1, scope: !2405)
!2569 = !DILocation(line: 220, column: 25, scope: !278, inlinedAt: !2570)
!2570 = distinct !DILocation(line: 847, column: 1, scope: !285, inlinedAt: !2571)
!2571 = distinct !DILocation(line: 62, column: 1, scope: !2405)
!2572 = !DILocation(line: 220, column: 25, scope: !278, inlinedAt: !2573)
!2573 = distinct !DILocation(line: 847, column: 1, scope: !285, inlinedAt: !2574)
!2574 = distinct !DILocation(line: 62, column: 1, scope: !2424)
!2575 = !DILocation(line: 2179, column: 17, scope: !2409, inlinedAt: !2423)
!2576 = !DILocation(line: 2193, column: 23, scope: !2577, inlinedAt: !2578)
!2577 = distinct !DILexicalBlock(scope: !2415, file: !381, line: 2193, column: 13)
!2578 = !DILocation(line: 50, column: 33, scope: !2579)
!2579 = !DILexicalBlockFile(scope: !2580, file: !1876, discriminator: 2)
!2580 = distinct !DILexicalBlock(scope: !2581, file: !1876, line: 50, column: 47)
!2581 = distinct !DILexicalBlock(scope: !2424, file: !1876, line: 50, column: 47)
!2582 = !DILocation(line: 220, column: 25, scope: !278, inlinedAt: !2583)
!2583 = distinct !DILocation(line: 847, column: 1, scope: !285, inlinedAt: !2584)
!2584 = distinct !DILocation(line: 62, column: 1, scope: !2405)
!2585 = !DILocation(line: 220, column: 25, scope: !278, inlinedAt: !2586)
!2586 = distinct !DILocation(line: 847, column: 1, scope: !285, inlinedAt: !2587)
!2587 = distinct !DILocation(line: 62, column: 1, scope: !2405)
!2588 = !DILocation(line: 220, column: 25, scope: !278, inlinedAt: !2589)
!2589 = distinct !DILocation(line: 847, column: 1, scope: !285, inlinedAt: !2590)
!2590 = distinct !DILocation(line: 62, column: 1, scope: !2405)
!2591 = !DILocation(line: 847, column: 1, scope: !285, inlinedAt: !2590)
!2592 = distinct !DISubprogram(name: "is_interrupted", linkageName: "_RNvNtNtNtNtCs1SSuMAdGM58_3std3sys2io5error4unix14is_interrupted", scope: !2351, file: !2350, line: 134, type: !52, scopeLine: 134, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!2593 = !{i64 150109334025631115}
!2594 = !DILocation(line: 135, column: 5, scope: !2592)
!2595 = !DILocation(line: 136, column: 2, scope: !2592)
!2596 = distinct !DISubprogram(name: "decode_error_kind", linkageName: "_RNvNtNtNtNtCs1SSuMAdGM58_3std3sys2io5error4unix17decode_error_kind", scope: !2351, file: !2350, line: 138, type: !52, scopeLine: 138, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!2597 = !{i64 4926552106267309646}
!2598 = !DILocation(line: 140, column: 5, scope: !2596)
!2599 = !DILocation(line: 0, scope: !2596)
!2600 = !DILocation(line: 190, column: 2, scope: !2596)
!2601 = distinct !DISubprogram(name: "drop", linkageName: "_RNvXs0_NtCshxBJAVx362N_11runtime_lab7processNtB5_10ReaderTaskNtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4drop", scope: !2602, file: !2201, line: 131, type: !52, scopeLine: 131, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!2602 = !DINamespace(name: "{impl#2}", scope: !1879)
!2603 = !{i64 5171286569910398513}
!2604 = !DILocation(line: 228, column: 18, scope: !2605, inlinedAt: !2610)
!2605 = distinct !DISubprogram(name: "abort<core::result::Result<(), core::io::error::Error>>", linkageName: "_RNvMs2_NtNtNtCs3EIJ1qnJmKW_5tokio7runtime4task4joinINtB5_10JoinHandleINtNtCsjIpoRzUjyHQ_4core6result6ResultuNtNtNtB1a_2io5error5ErrorEE5abortCshxBJAVx362N_11runtime_lab", scope: !2607, file: !2606, line: 227, type: !52, scopeLine: 227, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!2606 = !DIFile(filename: "src/runtime/task/join.rs", directory: "/Users/juanwang/.cargo/registry/src/mirrors.bfsu.edu.cn-eb00624c53167367/tokio-1.54.0", checksumkind: CSK_MD5, checksum: "1f6622edd24f07780d916100856a2ffd")
!2607 = !DINamespace(name: "JoinHandle", scope: !2608)
!2608 = !DINamespace(name: "join", scope: !2609)
!2609 = !DINamespace(name: "task", scope: !362)
!2610 = !DILocation(line: 132, column: 21, scope: !2601)
!2611 = !DILocation(line: 133, column: 6, scope: !2601)
!2612 = distinct !DISubprogram(name: "fmt<core::option::Option<core::ptr::non_null::NonNull<tokio::runtime::task::core::Header>>>", linkageName: "_RNvXs1g_NtCsjIpoRzUjyHQ_4core3fmtRINtNtB8_6option6OptionINtNtNtB8_3ptr8non_null7NonNullNtNtNtNtCs3EIJ1qnJmKW_5tokio7runtime4task4core6HeaderEENtB6_5Debug3fmtCshxBJAVx362N_11runtime_lab", scope: !2614, file: !2613, line: 2872, type: !52, scopeLine: 2872, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!2613 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/fmt/mod.rs", directory: "", checksumkind: CSK_MD5, checksum: "363229db3a4a2c778c00c76c7b1385ee")
!2614 = !DINamespace(name: "{impl#80}", scope: !2615)
!2615 = !DINamespace(name: "fmt", scope: !48)
!2616 = !{i64 5937752820466983898}
!2617 = !DILocation(line: 2872, column: 71, scope: !2612)
!2618 = !{!2619}
!2619 = distinct !{!2619, !2620, !"_RNvXsR_NtCsjIpoRzUjyHQ_4core6optionINtB5_6OptionINtNtNtB7_3ptr8non_null7NonNullNtNtNtNtCs3EIJ1qnJmKW_5tokio7runtime4task4core6HeaderEENtNtB7_3fmt5Debug3fmtCshxBJAVx362N_11runtime_lab: %self"}
!2620 = distinct !{!2620, !"_RNvXsR_NtCsjIpoRzUjyHQ_4core6optionINtB5_6OptionINtNtNtB7_3ptr8non_null7NonNullNtNtNtNtCs3EIJ1qnJmKW_5tokio7runtime4task4core6HeaderEENtNtB7_3fmt5Debug3fmtCshxBJAVx362N_11runtime_lab"}
!2621 = !DILocation(line: 2872, column: 62, scope: !2612)
!2622 = !DILocation(line: 592, column: 16, scope: !2623, inlinedAt: !2625)
!2623 = distinct !DISubprogram(name: "fmt<core::ptr::non_null::NonNull<tokio::runtime::task::core::Header>>", linkageName: "_RNvXsR_NtCsjIpoRzUjyHQ_4core6optionINtB5_6OptionINtNtNtB7_3ptr8non_null7NonNullNtNtNtNtCs3EIJ1qnJmKW_5tokio7runtime4task4core6HeaderEENtNtB7_3fmt5Debug3fmtCshxBJAVx362N_11runtime_lab", scope: !2624, file: !338, line: 592, type: !52, scopeLine: 592, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!2624 = !DINamespace(name: "{impl#55}", scope: !340)
!2625 = distinct !DILocation(line: 2872, column: 62, scope: !2612)
!2626 = !{!2627}
!2627 = distinct !{!2627, !2620, !"_RNvXsR_NtCsjIpoRzUjyHQ_4core6optionINtB5_6OptionINtNtNtB7_3ptr8non_null7NonNullNtNtNtNtCs3EIJ1qnJmKW_5tokio7runtime4task4core6HeaderEENtNtB7_3fmt5Debug3fmtCshxBJAVx362N_11runtime_lab: %f"}
!2628 = !DILocation(line: 606, column: 56, scope: !2623, inlinedAt: !2625)
!2629 = !{!2619, !2627}
!2630 = !DILocation(line: 592, column: 16, scope: !2631, inlinedAt: !2625)
!2631 = distinct !DILexicalBlock(scope: !2623, file: !338, line: 592, column: 16)
!2632 = !DILocation(line: 592, column: 20, scope: !2623, inlinedAt: !2625)
!2633 = !DILocation(line: 2872, column: 84, scope: !2612)
!2634 = distinct !DISubprogram(name: "fmt<core::ptr::non_null::NonNull<tokio::runtime::task::core::Header>>", linkageName: "_RNvXs1g_NtCsjIpoRzUjyHQ_4core3fmtRINtNtNtB8_3ptr8non_null7NonNullNtNtNtNtCs3EIJ1qnJmKW_5tokio7runtime4task4core6HeaderENtB6_5Debug3fmtCshxBJAVx362N_11runtime_lab", scope: !2614, file: !2613, line: 2872, type: !52, scopeLine: 2872, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!2635 = !{i64 84573914036644702}
!2636 = !DILocation(line: 2872, column: 71, scope: !2634)
!2637 = !DILocation(line: 2872, column: 62, scope: !2634)
!2638 = !DILocation(line: 188, column: 9, scope: !2639, inlinedAt: !2640)
!2639 = distinct !DISubprogram(name: "expose_provenance<tokio::runtime::task::core::Header>", linkageName: "_RNvMNtNtCsjIpoRzUjyHQ_4core3ptr9const_ptrPNtNtNtNtCs3EIJ1qnJmKW_5tokio7runtime4task4core6Header17expose_provenanceCshxBJAVx362N_11runtime_lab", scope: !424, file: !420, line: 187, type: !52, scopeLine: 187, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!2640 = distinct !DILocation(line: 3002, column: 28, scope: !2641, inlinedAt: !2644)
!2641 = distinct !DILexicalBlock(scope: !2642, file: !2613, line: 3001, column: 9)
!2642 = distinct !DISubprogram(name: "fmt<tokio::runtime::task::core::Header>", linkageName: "_RNvXsl_NtCsjIpoRzUjyHQ_4core3fmtPNtNtNtNtCs3EIJ1qnJmKW_5tokio7runtime4task4core6HeaderNtB5_7Pointer3fmtCshxBJAVx362N_11runtime_lab", scope: !2643, file: !2613, line: 2998, type: !40, scopeLine: 2998, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!2643 = !DINamespace(name: "{impl#23}", scope: !2615)
!2644 = distinct !DILocation(line: 3051, column: 9, scope: !2645, inlinedAt: !2647)
!2645 = distinct !DISubprogram(name: "fmt<tokio::runtime::task::core::Header>", linkageName: "_RNvXsm_NtCsjIpoRzUjyHQ_4core3fmtONtNtNtNtCs3EIJ1qnJmKW_5tokio7runtime4task4core6HeaderNtB5_7Pointer3fmtCshxBJAVx362N_11runtime_lab", scope: !2646, file: !2613, line: 3050, type: !52, scopeLine: 3050, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!2646 = !DINamespace(name: "{impl#24}", scope: !2615)
!2647 = distinct !DILocation(line: 1644, column: 9, scope: !2648, inlinedAt: !2650)
!2648 = distinct !DISubprogram(name: "fmt<tokio::runtime::task::core::Header>", linkageName: "_RNvXsa_NtNtCsjIpoRzUjyHQ_4core3ptr8non_nullINtB5_7NonNullNtNtNtNtCs3EIJ1qnJmKW_5tokio7runtime4task4core6HeaderENtNtB9_3fmt5Debug3fmtCshxBJAVx362N_11runtime_lab", scope: !2649, file: !598, line: 1643, type: !40, scopeLine: 1643, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!2649 = !DINamespace(name: "{impl#12}", scope: !600)
!2650 = distinct !DILocation(line: 2872, column: 62, scope: !2634)
!2651 = !DILocation(line: 3004, column: 13, scope: !2652, inlinedAt: !2644)
!2652 = distinct !DILexicalBlock(scope: !2641, file: !2613, line: 3002, column: 9)
!2653 = !DILocation(line: 2872, column: 84, scope: !2634)
!2654 = distinct !DISubprogram(name: "drop", linkageName: "_RNvXs_NtCshxBJAVx362N_11runtime_lab7processNtB4_13DrainLifetimeNtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4drop", scope: !2655, file: !2201, line: 66, type: !52, scopeLine: 66, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!2655 = !DINamespace(name: "{impl#1}", scope: !1879)
!2656 = !{i64 -6440183797682295062}
!2657 = !DILocation(line: 454, column: 20, scope: !2658, inlinedAt: !2659)
!2658 = distinct !DISubprogram(name: "as_ref<alloc::sync::ArcInner<std::sync::poison::mutex::Mutex<runtime_lab::process::Capture>>>", linkageName: "_RNvMs1_NtNtCsjIpoRzUjyHQ_4core3ptr8non_nullINtB5_7NonNullINtNtCs6zY7rJBZy9D_5alloc4sync8ArcInnerINtNtNtNtCs1SSuMAdGM58_3std4sync6poison5mutex5MutexNtNtCshxBJAVx362N_11runtime_lab7process7CaptureEEE6as_refB2p_", scope: !599, file: !598, line: 450, type: !52, scopeLine: 450, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!2659 = !DILocation(line: 2133, column: 27, scope: !2660, inlinedAt: !2661)
!2660 = distinct !DISubprogram(name: "inner<std::sync::poison::mutex::Mutex<runtime_lab::process::Capture>, alloc::alloc::Global>", linkageName: "_RNvMsn_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcINtNtNtNtCs1SSuMAdGM58_3std4sync6poison5mutex5MutexNtNtCshxBJAVx362N_11runtime_lab7process7CaptureEE5innerB1z_", scope: !1350, file: !1349, line: 2127, type: !52, scopeLine: 2127, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!2661 = !DILocation(line: 2454, column: 15, scope: !2662, inlinedAt: !2664)
!2662 = distinct !DISubprogram(name: "deref<std::sync::poison::mutex::Mutex<runtime_lab::process::Capture>, alloc::alloc::Global>", linkageName: "_RNvXsx_NtCs6zY7rJBZy9D_5alloc4syncINtB5_3ArcINtNtNtNtCs1SSuMAdGM58_3std4sync6poison5mutex5MutexNtNtCshxBJAVx362N_11runtime_lab7process7CaptureEENtNtNtCsjIpoRzUjyHQ_4core3ops5deref5Deref5derefB1z_", scope: !2663, file: !1349, line: 2453, type: !52, scopeLine: 2453, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!2663 = !DINamespace(name: "{impl#35}", scope: !1351)
!2664 = !DILocation(line: 67, column: 28, scope: !2665)
!2665 = distinct !DILexicalBlock(scope: !2654, file: !2201, line: 67, column: 46)
!2666 = !DILocation(line: 2454, column: 9, scope: !2662, inlinedAt: !2664)
!2667 = !DILocation(line: 3995, column: 24, scope: !388, inlinedAt: !2668)
!2668 = distinct !DILocation(line: 1765, column: 18, scope: !390, inlinedAt: !2669)
!2669 = distinct !DILocation(line: 48, column: 28, scope: !392, inlinedAt: !2670)
!2670 = distinct !DILocation(line: 22, column: 18, scope: !2207, inlinedAt: !2671)
!2671 = distinct !DILocation(line: 36, column: 23, scope: !2209, inlinedAt: !2672)
!2672 = distinct !DILocation(line: 492, column: 24, scope: !2211, inlinedAt: !2673)
!2673 = distinct !DILocation(line: 67, column: 39, scope: !2665)
!2674 = !{!2675}
!2675 = distinct !{!2675, !2676, !"_RNvMs5_NtNtNtCs1SSuMAdGM58_3std4sync6poison5mutexINtB5_5MutexNtNtCshxBJAVx362N_11runtime_lab7process7CaptureE4lockB11_: %_0"}
!2676 = distinct !{!2676, !"_RNvMs5_NtNtNtCs1SSuMAdGM58_3std4sync6poison5mutexINtB5_5MutexNtNtCshxBJAVx362N_11runtime_lab7process7CaptureE4lockB11_"}
!2677 = !DILocation(line: 38, column: 17, scope: !419, inlinedAt: !2678)
!2678 = distinct !DILocation(line: 2636, column: 9, scope: !427, inlinedAt: !2679)
!2679 = distinct !DILocation(line: 23, column: 27, scope: !431, inlinedAt: !2680)
!2680 = distinct !DILocation(line: 265, column: 17, scope: !436, inlinedAt: !2681)
!2681 = distinct !DILocation(line: 49, column: 28, scope: !438, inlinedAt: !2670)
!2682 = !DILocation(line: 265, column: 12, scope: !436, inlinedAt: !2681)
!2683 = !DILocation(line: 51, column: 26, scope: !438, inlinedAt: !2670)
!2684 = !DILocation(line: 53, column: 5, scope: !392, inlinedAt: !2670)
!2685 = !DILocation(line: 0, scope: !438, inlinedAt: !2670)
!2686 = !DILocation(line: 36, column: 29, scope: !2209, inlinedAt: !2672)
!2687 = !DILocation(line: 3994, column: 24, scope: !444, inlinedAt: !2688)
!2688 = distinct !DILocation(line: 2916, column: 26, scope: !446, inlinedAt: !2689)
!2689 = distinct !DILocation(line: 465, column: 31, scope: !448, inlinedAt: !2690)
!2690 = distinct !DILocation(line: 606, column: 6, scope: !453, inlinedAt: !2691)
!2691 = distinct !DILocation(line: 221, column: 5, scope: !455, inlinedAt: !2692)
!2692 = distinct !DILocation(line: 118, column: 24, scope: !460, inlinedAt: !2693)
!2693 = distinct !DILocation(line: 720, column: 40, scope: !2233, inlinedAt: !2694)
!2694 = distinct !DILocation(line: 493, column: 13, scope: !2211, inlinedAt: !2673)
!2695 = !DILocation(line: 465, column: 12, scope: !448, inlinedAt: !2690)
!2696 = !DILocation(line: 477, column: 13, scope: !448, inlinedAt: !2690)
!2697 = !DILocation(line: 606, column: 5, scope: !453, inlinedAt: !2691)
!2698 = !DILocation(line: 720, column: 28, scope: !2233, inlinedAt: !2694)
!2699 = !DILocation(line: 3994, column: 24, scope: !473, inlinedAt: !2700)
!2700 = distinct !DILocation(line: 762, column: 18, scope: !475, inlinedAt: !2701)
!2701 = distinct !DILocation(line: 138, column: 21, scope: !477, inlinedAt: !2702)
!2702 = distinct !DILocation(line: 120, column: 17, scope: !479, inlinedAt: !2693)
!2703 = !DILocation(line: 762, column: 18, scope: !475, inlinedAt: !2701)
!2704 = !DILocation(line: 120, scope: !479, inlinedAt: !2693)
!2705 = !DILocation(line: 67, column: 16, scope: !2665)
!2706 = !DILocation(line: 68, column: 48, scope: !2665)
!2707 = !DILocation(line: 68, column: 59, scope: !2665)
!2708 = !DILocation(line: 69, column: 9, scope: !2654)
!2709 = !DILocation(line: 68, column: 43, scope: !2665)
!2710 = !DILocation(line: 68, column: 13, scope: !2665)
!2711 = !DILocation(line: 126, column: 13, scope: !493, inlinedAt: !2712)
!2712 = distinct !DILocation(line: 745, column: 30, scope: !812, inlinedAt: !2713)
!2713 = distinct !DILocation(line: 847, column: 1, scope: !814, inlinedAt: !2714)
!2714 = distinct !DILocation(line: 69, column: 9, scope: !2654)
!2715 = !DILocation(line: 3994, column: 24, scope: !444, inlinedAt: !2716)
!2716 = distinct !DILocation(line: 2916, column: 26, scope: !502, inlinedAt: !2717)
!2717 = distinct !DILocation(line: 465, column: 31, scope: !504, inlinedAt: !2718)
!2718 = distinct !DILocation(line: 606, column: 6, scope: !506, inlinedAt: !2719)
!2719 = distinct !DILocation(line: 221, column: 5, scope: !508, inlinedAt: !2720)
!2720 = distinct !DILocation(line: 126, column: 32, scope: !493, inlinedAt: !2712)
!2721 = !DILocation(line: 465, column: 12, scope: !504, inlinedAt: !2718)
!2722 = !DILocation(line: 477, column: 13, scope: !504, inlinedAt: !2718)
!2723 = !DILocation(line: 126, column: 32, scope: !493, inlinedAt: !2712)
!2724 = !DILocation(line: 66, column: 5, scope: !2654)
!2725 = !DILocation(line: 126, column: 13, scope: !493, inlinedAt: !2726)
!2726 = distinct !DILocation(line: 745, column: 30, scope: !812, inlinedAt: !2727)
!2727 = distinct !DILocation(line: 847, column: 1, scope: !814, inlinedAt: !2728)
!2728 = distinct !DILocation(line: 847, column: 1, scope: !809, inlinedAt: !2729)
!2729 = distinct !DILocation(line: 847, column: 1, scope: !2730, inlinedAt: !2731)
!2730 = distinct !DISubprogram(name: "drop_glue<core::result::Result<std::sync::poison::mutex::MutexGuard<runtime_lab::process::Capture>, std::sync::poison::PoisonError<std::sync::poison::mutex::MutexGuard<runtime_lab::process::Capture>>>>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtB4_6result6ResultINtNtNtNtCs1SSuMAdGM58_3std4sync6poison5mutex10MutexGuardNtNtCshxBJAVx362N_11runtime_lab7process7CaptureEINtB12_11PoisonErrorBX_EEEB1W_", scope: !140, file: !139, line: 847, type: !52, scopeLine: 847, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!2731 = distinct !DILocation(line: 70, column: 5, scope: !2654)
!2732 = !DILocation(line: 3994, column: 24, scope: !444, inlinedAt: !2733)
!2733 = distinct !DILocation(line: 2916, column: 26, scope: !502, inlinedAt: !2734)
!2734 = distinct !DILocation(line: 465, column: 31, scope: !504, inlinedAt: !2735)
!2735 = distinct !DILocation(line: 606, column: 6, scope: !506, inlinedAt: !2736)
!2736 = distinct !DILocation(line: 221, column: 5, scope: !508, inlinedAt: !2737)
!2737 = distinct !DILocation(line: 126, column: 32, scope: !493, inlinedAt: !2726)
!2738 = !{!2739}
!2739 = distinct !{!2739, !2740, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtB4_6result6ResultINtNtNtNtCs1SSuMAdGM58_3std4sync6poison5mutex10MutexGuardNtNtCshxBJAVx362N_11runtime_lab7process7CaptureEINtB12_11PoisonErrorBX_EEEB1W_: %_1"}
!2740 = distinct !{!2740, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtB4_6result6ResultINtNtNtNtCs1SSuMAdGM58_3std4sync6poison5mutex10MutexGuardNtNtCshxBJAVx362N_11runtime_lab7process7CaptureEINtB12_11PoisonErrorBX_EEEB1W_"}
!2741 = !DILocation(line: 465, column: 12, scope: !504, inlinedAt: !2735)
!2742 = !DILocation(line: 477, column: 13, scope: !504, inlinedAt: !2735)
!2743 = !DILocation(line: 126, column: 32, scope: !493, inlinedAt: !2726)
!2744 = !DILocation(line: 0, scope: !2654)
!2745 = !DILocation(line: 70, column: 6, scope: !2654)
!2746 = distinct !DISubprogram(name: "call_once<std::io::error::{impl#0}::from_raw_os_error::FUNCTIONS::{closure_env#0}, (i32, &mut core::fmt::Formatter)>", linkageName: "_RNvYNCNvNvMNtNtCs1SSuMAdGM58_3std2io5errorNtNtNtCsjIpoRzUjyHQ_4core2io5error5Error17from_raw_os_error9FUNCTIONS0INtNtNtBK_3ops8function6FnOnceTlQNtNtBK_3fmt9FormatterEE9call_onceCshxBJAVx362N_11runtime_lab", scope: !1900, file: !1899, line: 250, type: !52, scopeLine: 250, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!2747 = !{i64 -4222238571457764751}
!2748 = !DILocation(line: 78, column: 57, scope: !2749, inlinedAt: !2755)
!2749 = distinct !DISubprogram(name: "{closure#0}", linkageName: "_RNCNvNvMNtNtCs1SSuMAdGM58_3std2io5errorNtNtNtCsjIpoRzUjyHQ_4core2io5error5Error17from_raw_os_error9FUNCTIONS0CshxBJAVx362N_11runtime_lab", scope: !2750, file: !2356, line: 78, type: !40, scopeLine: 78, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!2750 = !DINamespace(name: "FUNCTIONS", scope: !2751)
!2751 = !DINamespace(name: "from_raw_os_error", scope: !2752)
!2752 = !DINamespace(name: "{impl#0}", scope: !2753)
!2753 = !DINamespace(name: "error", scope: !2754)
!2754 = !DINamespace(name: "io", scope: !39)
!2755 = distinct !DILocation(line: 250, column: 5, scope: !2746)
!2756 = !{!2757}
!2757 = distinct !{!2757, !2758, !"_RNCNvNvMNtNtCs1SSuMAdGM58_3std2io5errorNtNtNtCsjIpoRzUjyHQ_4core2io5error5Error17from_raw_os_error9FUNCTIONS0CshxBJAVx362N_11runtime_lab: %fmt"}
!2758 = distinct !{!2758, !"_RNCNvNvMNtNtCs1SSuMAdGM58_3std2io5errorNtNtNtCsjIpoRzUjyHQ_4core2io5error5Error17from_raw_os_error9FUNCTIONS0CshxBJAVx362N_11runtime_lab"}
!2759 = !DILocation(line: 611, column: 9, scope: !2760, inlinedAt: !2761)
!2760 = distinct !DISubprogram(name: "non_null<alloc::alloc::Global, u8>", linkageName: "_RINvMs2_NtCs6zY7rJBZy9D_5alloc7raw_vecNtB6_11RawVecInner8non_nullhECshxBJAVx362N_11runtime_lab", scope: !227, file: !226, line: 610, type: !52, scopeLine: 610, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!2761 = distinct !DILocation(line: 606, column: 14, scope: !2762, inlinedAt: !2763)
!2762 = distinct !DISubprogram(name: "ptr<alloc::alloc::Global, u8>", linkageName: "_RINvMs2_NtCs6zY7rJBZy9D_5alloc7raw_vecNtB6_11RawVecInner3ptrhECshxBJAVx362N_11runtime_lab", scope: !227, file: !226, line: 605, type: !52, scopeLine: 605, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!2763 = distinct !DILocation(line: 296, column: 20, scope: !2764, inlinedAt: !2766)
!2764 = distinct !DISubprogram(name: "ptr<u8, alloc::alloc::Global>", linkageName: "_RNvMs0_NtCs6zY7rJBZy9D_5alloc7raw_vecINtB5_6RawVechE3ptrCshxBJAVx362N_11runtime_lab", scope: !2765, file: !226, line: 295, type: !52, scopeLine: 295, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!2765 = !DINamespace(name: "RawVec", scope: !228)
!2766 = distinct !DILocation(line: 1969, column: 18, scope: !2767, inlinedAt: !2771)
!2767 = distinct !DISubprogram(name: "as_ptr<u8, alloc::alloc::Global>", linkageName: "_RNvMs_NtCs6zY7rJBZy9D_5alloc3vecINtB4_3VechE6as_ptrCshxBJAVx362N_11runtime_lab", scope: !2769, file: !2768, line: 1966, type: !52, scopeLine: 1966, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!2768 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/alloc/src/vec/mod.rs", directory: "", checksumkind: CSK_MD5, checksum: "a93d3a7d4a1d55c9887c540882057a4f")
!2769 = !DINamespace(name: "Vec", scope: !2770)
!2770 = !DINamespace(name: "vec", scope: !109)
!2771 = distinct !DILocation(line: 1865, column: 76, scope: !2772, inlinedAt: !2773)
!2772 = distinct !DISubprogram(name: "as_slice<u8, alloc::alloc::Global>", linkageName: "_RNvMs_NtCs6zY7rJBZy9D_5alloc3vecINtB4_3VechE8as_sliceCshxBJAVx362N_11runtime_lab", scope: !2769, file: !2768, line: 1848, type: !52, scopeLine: 1848, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!2773 = distinct !DILocation(line: 1058, column: 52, scope: !2774, inlinedAt: !2778)
!2774 = distinct !DISubprogram(name: "as_str", linkageName: "_RNvMNtCs6zY7rJBZy9D_5alloc6stringNtB2_6String6as_str", scope: !2776, file: !2775, line: 1055, type: !52, scopeLine: 1055, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!2775 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/alloc/src/string.rs", directory: "", checksumkind: CSK_MD5, checksum: "247ce5793564961cdf9d3444680d9f4b")
!2776 = !DINamespace(name: "String", scope: !2777)
!2777 = !DINamespace(name: "string", scope: !109)
!2778 = distinct !DILocation(line: 2860, column: 14, scope: !2779, inlinedAt: !2781)
!2779 = distinct !DISubprogram(name: "deref", linkageName: "_RNvXsx_NtCs6zY7rJBZy9D_5alloc6stringNtB5_6StringNtNtNtCsjIpoRzUjyHQ_4core3ops5deref5Deref5deref", scope: !2780, file: !2775, line: 2859, type: !52, scopeLine: 2859, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !32, templateParams: !41)
!2780 = !DINamespace(name: "{impl#35}", scope: !2777)
!2781 = distinct !DILocation(line: 78, column: 56, scope: !2749, inlinedAt: !2755)
!2782 = !DILocation(line: 1865, column: 86, scope: !2772, inlinedAt: !2773)
!2783 = !DILocation(line: 78, column: 46, scope: !2749, inlinedAt: !2755)
!2784 = !DILocation(line: 78, column: 75, scope: !2749, inlinedAt: !2755)
!2785 = !DILocation(line: 631, column: 39, scope: !225, inlinedAt: !2786)
!2786 = distinct !DILocation(line: 874, column: 52, scope: !230, inlinedAt: !2787)
!2787 = distinct !DILocation(line: 425, column: 29, scope: !233, inlinedAt: !2788)
!2788 = distinct !DILocation(line: 847, column: 1, scope: !236, inlinedAt: !2789)
!2789 = distinct !DILocation(line: 847, column: 1, scope: !238, inlinedAt: !2790)
!2790 = distinct !DILocation(line: 847, column: 1, scope: !261, inlinedAt: !2791)
!2791 = distinct !DILocation(line: 78, column: 75, scope: !2749, inlinedAt: !2755)
!2792 = !DILocation(line: 175, column: 14, scope: !168, inlinedAt: !2793)
!2793 = distinct !DILocation(line: 321, column: 22, scope: !170, inlinedAt: !2794)
!2794 = distinct !DILocation(line: 436, column: 9, scope: !172, inlinedAt: !2795)
!2795 = distinct !DILocation(line: 554, column: 23, scope: !174, inlinedAt: !2796)
!2796 = distinct !DILocation(line: 876, column: 28, scope: !230, inlinedAt: !2787)
!2797 = !DILocation(line: 874, column: 9, scope: !231, inlinedAt: !2787)
!2798 = !DILocation(line: 631, column: 39, scope: !225, inlinedAt: !2799)
!2799 = distinct !DILocation(line: 874, column: 52, scope: !230, inlinedAt: !2800)
!2800 = distinct !DILocation(line: 425, column: 29, scope: !233, inlinedAt: !2801)
!2801 = distinct !DILocation(line: 847, column: 1, scope: !236, inlinedAt: !2802)
!2802 = distinct !DILocation(line: 847, column: 1, scope: !238, inlinedAt: !2803)
!2803 = distinct !DILocation(line: 847, column: 1, scope: !261, inlinedAt: !2804)
!2804 = distinct !DILocation(line: 78, column: 75, scope: !2749, inlinedAt: !2755)
!2805 = !DILocation(line: 175, column: 14, scope: !168, inlinedAt: !2806)
!2806 = distinct !DILocation(line: 321, column: 22, scope: !170, inlinedAt: !2807)
!2807 = distinct !DILocation(line: 436, column: 9, scope: !172, inlinedAt: !2808)
!2808 = distinct !DILocation(line: 554, column: 23, scope: !174, inlinedAt: !2809)
!2809 = distinct !DILocation(line: 876, column: 28, scope: !230, inlinedAt: !2800)
!2810 = !DILocation(line: 874, column: 9, scope: !231, inlinedAt: !2800)
!2811 = !DILocation(line: 78, column: 30, scope: !2749, inlinedAt: !2755)
!2812 = !DILocation(line: 250, column: 5, scope: !2746)
