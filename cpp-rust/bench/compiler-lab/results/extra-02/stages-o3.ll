; ModuleID = 'stages.7013176734082d3a-cgu.0'
source_filename = "stages.7013176734082d3a-cgu.0"
target datalayout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx11.0.0"

@vtable.0 = private unnamed_addr constant <{ [24 x i8], ptr, ptr, ptr }> <{ [24 x i8] c"\00\00\00\00\00\00\00\00\08\00\00\00\00\00\00\00\08\00\00\00\00\00\00\00", ptr @_RNSNvYNCINvNtCs1SSuMAdGM58_3std2rt10lang_startuE0INtNtNtCsjIpoRzUjyHQ_4core3ops8function6FnOnceuE9call_once6vtableCs9CzmnnBYieY_6stages, ptr @_RNCINvNtCs1SSuMAdGM58_3std2rt10lang_startuE0Cs9CzmnnBYieY_6stages, ptr @_RNCINvNtCs1SSuMAdGM58_3std2rt10lang_startuE0Cs9CzmnnBYieY_6stages }>, align 8, !guid !0
@alloc_f85406d658e94b9c37cd2112f10307ee = private unnamed_addr constant [8 x i8] c"\02\00\00\00\00\00\00\00", align 8, !guid !1
@alloc_2ff739fb30955571335d6ded878dde47 = private unnamed_addr constant [79 x i8] c"/Users/juanwang/Desktop/tutorials/cpp-rust/bench/compiler-lab/probes/stages.rs\00", align 1, !guid !2
@alloc_770cfff3e7ea7887b74e74f003c9be9a = private unnamed_addr constant <{ ptr, [16 x i8] }> <{ ptr @alloc_2ff739fb30955571335d6ded878dde47, [16 x i8] c"N\00\00\00\00\00\00\00\14\00\00\00\05\00\00\00" }>, align 8, !guid !3

; std::rt::lang_start::<()>
; Function Attrs: uwtable
define hidden noundef i64 @_RINvNtCs1SSuMAdGM58_3std2rt10lang_startuECs9CzmnnBYieY_6stages(ptr noundef nonnull %main, i64 noundef %argc, ptr noundef %argv, i8 noundef %sigpipe) unnamed_addr #0 !guid !9 {
start:
  %_7 = alloca [8 x i8], align 8
  call void @llvm.lifetime.start.p0(ptr nonnull %_7)
  store ptr %main, ptr %_7, align 8
; call std::rt::lang_start_internal
  %_0 = call noundef i64 @_RNvNtCs1SSuMAdGM58_3std2rt19lang_start_internal(ptr noundef nonnull %_7, ptr noalias nofree noundef readonly align 8 captures(address, read_provenance) dereferenceable(48) @vtable.0, i64 noundef %argc, ptr noundef %argv, i8 noundef %sigpipe)
  call void @llvm.lifetime.end.p0(ptr nonnull %_7)
  ret i64 %_0
}

; std::sys::backtrace::__rust_begin_short_backtrace::<fn(), ()>
; Function Attrs: noinline uwtable
define internal fastcc void @_RINvNtNtCs1SSuMAdGM58_3std3sys9backtrace28___rust_begin_short_backtraceFEuuECs9CzmnnBYieY_6stages(ptr nofree noundef nonnull readonly captures(none) %f) unnamed_addr #1 !guid !10 {
start:
  tail call void %f(), !inline_history !11
  tail call void asm sideeffect "", "~{memory}"() #7, !srcloc !12
  ret void
}

; std::rt::lang_start::<()>::{closure#0}
; Function Attrs: inlinehint uwtable
define internal noundef i32 @_RNCINvNtCs1SSuMAdGM58_3std2rt10lang_startuE0Cs9CzmnnBYieY_6stages(ptr noalias nofree noundef readonly align 8 captures(none) dereferenceable(8) %_1) unnamed_addr #2 !guid !13 {
start:
  %_4 = load ptr, ptr %_1, align 8, !nonnull !14, !noundef !14
; call std::sys::backtrace::__rust_begin_short_backtrace::<fn(), ()>
  tail call fastcc void @_RINvNtNtCs1SSuMAdGM58_3std3sys9backtrace28___rust_begin_short_backtraceFEuuECs9CzmnnBYieY_6stages(ptr noundef nonnull %_4) #8
  ret i32 0
}

; <std::rt::lang_start<()>::{closure#0} as core::ops::function::FnOnce<()>>::call_once::{shim:vtable#0}
; Function Attrs: inlinehint uwtable
define internal noundef i32 @_RNSNvYNCINvNtCs1SSuMAdGM58_3std2rt10lang_startuE0INtNtNtCsjIpoRzUjyHQ_4core3ops8function6FnOnceuE9call_once6vtableCs9CzmnnBYieY_6stages(ptr nofree noundef readonly captures(none) %_1) unnamed_addr #2 personality ptr @rust_eh_personality !guid !15 {
start:
  %0 = load ptr, ptr %_1, align 8, !nonnull !14, !noundef !14
; call std::sys::backtrace::__rust_begin_short_backtrace::<fn(), ()>
  tail call fastcc void @_RINvNtNtCs1SSuMAdGM58_3std3sys9backtrace28___rust_begin_short_backtraceFEuuECs9CzmnnBYieY_6stages(ptr noundef nonnull readonly %0) #8, !noalias !16
  ret i32 0
}

; stages::main
; Function Attrs: uwtable
define hidden void @_RNvCs9CzmnnBYieY_6stages4main() unnamed_addr #0 personality ptr @rust_eh_personality !guid !19 {
start:
  %_6.i = alloca [8 x i8], align 8
  %b.i = alloca [8 x i8], align 8
  %_6 = alloca [8 x i8], align 8
  %_3 = alloca [1 x i8], align 1
  %count = alloca [8 x i8], align 8
  call void @llvm.lifetime.start.p0(ptr nonnull %count)
  store i64 0, ptr %count, align 8
  call void @llvm.lifetime.start.p0(ptr nonnull %_3)
  store i8 1, ptr %_3, align 1
  call void asm sideeffect "", "r,~{memory}"(ptr nonnull %_3) #7, !srcloc !12
  %0 = load i8, ptr %_3, align 1, !range !20, !noundef !14
  %1 = trunc nuw i8 %0 to i1
  call void @llvm.lifetime.start.p0(ptr nonnull %b.i)
  store ptr %count, ptr %b.i, align 8
  br i1 %1, label %bb10.i, label %bb12.i

bb12.i:                                           ; preds = %start
  call void @llvm.lifetime.start.p0(ptr nonnull %_6.i)
  store ptr %b.i, ptr %_6.i, align 8
  call void asm sideeffect "", "r,~{memory}"(ptr nonnull %_6.i) #7, !srcloc !12
  call void @llvm.lifetime.end.p0(ptr nonnull %_6.i)
  %b.val6.i = load ptr, ptr %b.i, align 8, !nonnull !14, !align !21, !noundef !14
  %_3.i.i.i = load i64, ptr %b.val6.i, align 8, !noundef !14
  %_2.i.i.i = add i64 %_3.i.i.i, 1
  store i64 %_2.i.i.i, ptr %b.val6.i, align 8
  call void @llvm.lifetime.end.p0(ptr nonnull %b.i)
  %_3.i.i9.i = load i64, ptr %count, align 8, !noundef !14
  %_2.i.i10.i = add i64 %_3.i.i9.i, 1
  store i64 %_2.i.i10.i, ptr %count, align 8
  br label %_RNvCs9CzmnnBYieY_6stages11conditional.exit

bb10.i:                                           ; preds = %start
  %_3.i.i7.i = load i64, ptr %count, align 8, !noundef !14
  %_2.i.i8.i = add i64 %_3.i.i7.i, 1
  store i64 %_2.i.i8.i, ptr %count, align 8
  call void @llvm.lifetime.start.p0(ptr nonnull %_6.i)
  store ptr %b.i, ptr %_6.i, align 8
  call void asm sideeffect "", "r,~{memory}"(ptr nonnull %_6.i) #7, !srcloc !12
  call void @llvm.lifetime.end.p0(ptr nonnull %_6.i)
  %b.val4.i = load ptr, ptr %b.i, align 8, !nonnull !14, !align !21, !noundef !14
  %_3.i.i13.i = load i64, ptr %b.val4.i, align 8, !noundef !14
  %_2.i.i14.i = add i64 %_3.i.i13.i, 1
  store i64 %_2.i.i14.i, ptr %b.val4.i, align 8
  call void @llvm.lifetime.end.p0(ptr nonnull %b.i)
  %.pr = load i64, ptr %count, align 8
  br label %_RNvCs9CzmnnBYieY_6stages11conditional.exit

_RNvCs9CzmnnBYieY_6stages11conditional.exit:      ; preds = %bb12.i, %bb10.i
  %2 = phi i64 [ %_2.i.i10.i, %bb12.i ], [ %.pr, %bb10.i ]
  call void @llvm.lifetime.end.p0(ptr nonnull %_3)
  call void @llvm.lifetime.start.p0(ptr nonnull %_6)
  store i64 %2, ptr %_6, align 8
  %3 = icmp eq i64 %2, 2
  br i1 %3, label %bb2, label %bb3, !prof !22

bb2:                                              ; preds = %_RNvCs9CzmnnBYieY_6stages11conditional.exit
  call void @llvm.lifetime.end.p0(ptr nonnull %_6)
  call void @llvm.lifetime.end.p0(ptr nonnull %count)
  ret void

bb3:                                              ; preds = %_RNvCs9CzmnnBYieY_6stages11conditional.exit
; call core::panicking::assert_failed::<u64, u64>
  call void @_RINvNtCsjIpoRzUjyHQ_4core9panicking13assert_failedyyEB4_(i8 noundef 0, ptr noalias nofree noundef nonnull readonly align 8 captures(address, read_provenance) dereferenceable(8) %_6, ptr noalias nofree noundef readonly align 8 captures(address, read_provenance) dereferenceable(8) @alloc_f85406d658e94b9c37cd2112f10307ee, ptr noundef null, ptr undef, ptr noalias nofree noundef readonly align 8 captures(address, read_provenance) dereferenceable(24) @alloc_770cfff3e7ea7887b74e74f003c9be9a) #9
  unreachable
}

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(ptr captures(none)) #3

; std::rt::lang_start_internal
; Function Attrs: uwtable
declare noundef i64 @_RNvNtCs1SSuMAdGM58_3std2rt19lang_start_internal(ptr noundef nonnull, ptr noalias nofree noundef readonly align 8 captures(address, read_provenance) dereferenceable(48), i64 noundef, ptr noundef, i8 noundef) unnamed_addr #0

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(ptr captures(none)) #3

; Function Attrs: nounwind uwtable
declare noundef range(i32 0, 10) i32 @rust_eh_personality(i32 noundef, i32 noundef, i64 noundef, ptr noundef, ptr noundef) unnamed_addr #4

; core::panicking::assert_failed::<u64, u64>
; Function Attrs: cold minsize noinline noreturn optsize uwtable
declare void @_RINvNtCsjIpoRzUjyHQ_4core9panicking13assert_failedyyEB4_(i8 noundef range(i8 0, 3), ptr noalias nofree noundef readonly align 8 captures(address, read_provenance) dereferenceable(8), ptr noalias nofree noundef readonly align 8 captures(address, read_provenance) dereferenceable(8), ptr noundef, ptr, ptr noalias nofree noundef readonly align 8 captures(address, read_provenance) dereferenceable(24)) unnamed_addr #5

define noundef i32 @main(i32 %0, ptr %1) unnamed_addr #6 !guid !23 {
top:
  %_7.i = alloca [8 x i8], align 8
  %2 = sext i32 %0 to i64
  call void @llvm.lifetime.start.p0(ptr nonnull %_7.i)
  store ptr @_RNvCs9CzmnnBYieY_6stages4main, ptr %_7.i, align 8
; call std::rt::lang_start_internal
  %_0.i = call noundef i64 @_RNvNtCs1SSuMAdGM58_3std2rt19lang_start_internal(ptr noundef nonnull %_7.i, ptr noalias nofree noundef readonly align 8 captures(address, read_provenance) dereferenceable(48) @vtable.0, i64 noundef %2, ptr noundef %1, i8 noundef 0)
  call void @llvm.lifetime.end.p0(ptr nonnull %_7.i)
  %3 = trunc i64 %_0.i to i32
  ret i32 %3
}

attributes #0 = { uwtable "frame-pointer"="non-leaf" "probe-stack"="inline-asm" "target-cpu"="apple-m1" }
attributes #1 = { noinline uwtable "frame-pointer"="non-leaf" "probe-stack"="inline-asm" "target-cpu"="apple-m1" }
attributes #2 = { inlinehint uwtable "frame-pointer"="non-leaf" "probe-stack"="inline-asm" "target-cpu"="apple-m1" }
attributes #3 = { mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #4 = { nounwind uwtable "frame-pointer"="non-leaf" "probe-stack"="inline-asm" "target-cpu"="apple-m1" }
attributes #5 = { cold minsize noinline noreturn optsize uwtable "frame-pointer"="non-leaf" "probe-stack"="inline-asm" "target-cpu"="apple-m1" }
attributes #6 = { "frame-pointer"="non-leaf" "probe-stack"="inline-asm" "target-cpu"="apple-m1" }
attributes #7 = { nounwind }
attributes #8 = { noinline }
attributes #9 = { noinline noreturn }

!llvm.module.flags = !{!4, !5, !6, !7}
!llvm.ident = !{!8}

!0 = !{i64 7241113740737168500}
!1 = !{i64 1191005084174333264}
!2 = !{i64 -2741437040774557411}
!3 = !{i64 -752677807500915209}
!4 = !{i32 8, !"PIC Level", i32 2}
!5 = !{i32 7, !"PIE Level", i32 2}
!6 = !{i32 7, !"uwtable", i32 2}
!7 = !{i32 7, !"frame-pointer", i32 1}
!8 = !{!"rustc version 1.99.0 (b940084d7 2026-09-28)"}
!9 = !{i64 6406676792000232129}
!10 = !{i64 -3551733820733953380}
!11 = distinct !{null}
!12 = !{i64 4980929408905726}
!13 = !{i64 -8038068757755374469}
!14 = !{}
!15 = !{i64 -529900651833235189}
!16 = !{!17}
!17 = distinct !{!17, !18, !"_RNCINvNtCs1SSuMAdGM58_3std2rt10lang_startuE0Cs9CzmnnBYieY_6stages: %_1"}
!18 = distinct !{!18, !"_RNCINvNtCs1SSuMAdGM58_3std2rt10lang_startuE0Cs9CzmnnBYieY_6stages"}
!19 = !{i64 -1173136490817159861}
!20 = !{i8 0, i8 2}
!21 = !{i64 8}
!22 = !{!"branch_weights", !"expected", i32 2000, i32 1}
!23 = !{i64 -2624081020897602054}
