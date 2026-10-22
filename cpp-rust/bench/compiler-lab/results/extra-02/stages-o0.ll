; ModuleID = 'stages.7013176734082d3a-cgu.0'
source_filename = "stages.7013176734082d3a-cgu.0"
target datalayout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx11.0.0"

@vtable.0 = private unnamed_addr constant <{ [24 x i8], ptr, ptr, ptr }> <{ [24 x i8] c"\00\00\00\00\00\00\00\00\08\00\00\00\00\00\00\00\08\00\00\00\00\00\00\00", ptr @_RNSNvYNCINvNtCs1SSuMAdGM58_3std2rt10lang_startuE0INtNtNtCsjIpoRzUjyHQ_4core3ops8function6FnOnceuE9call_once6vtableCs9CzmnnBYieY_6stages, ptr @_RNCINvNtCs1SSuMAdGM58_3std2rt10lang_startuE0Cs9CzmnnBYieY_6stages, ptr @_RNCINvNtCs1SSuMAdGM58_3std2rt10lang_startuE0Cs9CzmnnBYieY_6stages }>, align 8, !guid !0
@alloc_f85406d658e94b9c37cd2112f10307ee = private unnamed_addr constant [8 x i8] c"\02\00\00\00\00\00\00\00", align 8, !guid !1
@alloc_2ff739fb30955571335d6ded878dde47 = private unnamed_addr constant [79 x i8] c"/Users/juanwang/Desktop/tutorials/cpp-rust/bench/compiler-lab/probes/stages.rs\00", align 1, !guid !2
@alloc_770cfff3e7ea7887b74e74f003c9be9a = private unnamed_addr constant <{ ptr, [16 x i8] }> <{ ptr @alloc_2ff739fb30955571335d6ded878dde47, [16 x i8] c"N\00\00\00\00\00\00\00\14\00\00\00\05\00\00\00" }>, align 8, !guid !3
@alloc_eb3cb0362d4df237f01f3e1e96ae83a3 = private unnamed_addr constant <{ ptr, [16 x i8] }> <{ ptr @alloc_2ff739fb30955571335d6ded878dde47, [16 x i8] c"N\00\00\00\00\00\00\00\06\00\00\00\14\00\00\00" }>, align 8, !guid !4

; std::rt::lang_start::<()>
; Function Attrs: uwtable
define hidden i64 @_RINvNtCs1SSuMAdGM58_3std2rt10lang_startuECs9CzmnnBYieY_6stages(ptr %main, i64 %argc, ptr %argv, i8 %sigpipe) unnamed_addr #0 !guid !10 {
start:
  %_7 = alloca [8 x i8], align 8
  store ptr %main, ptr %_7, align 8
; call std::rt::lang_start_internal
  %_0 = call i64 @_RNvNtCs1SSuMAdGM58_3std2rt19lang_start_internal(ptr %_7, ptr align 8 @vtable.0, i64 %argc, ptr %argv, i8 %sigpipe)
  ret i64 %_0
}

; core::mem::drop::<stages::Guard>
; Function Attrs: inlinehint uwtable
define internal void @_RINvNtCsjIpoRzUjyHQ_4core3mem4dropNtCs9CzmnnBYieY_6stages5GuardEBy_(ptr align 8 %0) unnamed_addr #1 !guid !11 {
start:
  %_x = alloca [8 x i8], align 8
  store ptr %0, ptr %_x, align 8
; call core::ptr::drop_glue::<stages::Guard>
  call void @_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtCs9CzmnnBYieY_6stages5GuardEBD_(ptr align 8 %_x)
  ret void
}

; core::ptr::drop_glue::<stages::Guard>
; Function Attrs: uwtable
define internal void @_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtCs9CzmnnBYieY_6stages5GuardEBD_(ptr align 8 %_1) unnamed_addr #0 !guid !12 {
start:
; call <stages::Guard as core::ops::drop::Drop>::drop
  call void @_RNvXCs9CzmnnBYieY_6stagesNtB2_5GuardNtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4drop(ptr align 8 %_1)
  ret void
}

; core::hint::black_box::<&stages::Guard>
; Function Attrs: inlinehint uwtable
define internal align 8 ptr @_RINvNtCsjIpoRzUjyHQ_4core4hint9black_boxRNtCs9CzmnnBYieY_6stages5GuardEBF_(ptr align 8 %dummy) unnamed_addr #1 !guid !13 {
start:
  %_0 = alloca [8 x i8], align 8
  store ptr %dummy, ptr %_0, align 8
  call void asm sideeffect "", "r,~{memory}"(ptr %_0), !srcloc !14
  %0 = load ptr, ptr %_0, align 8
  ret ptr %0
}

; core::hint::black_box::<bool>
; Function Attrs: inlinehint uwtable
define internal zeroext i1 @_RINvNtCsjIpoRzUjyHQ_4core4hint9black_boxbECs9CzmnnBYieY_6stages(i1 zeroext %dummy) unnamed_addr #1 !guid !15 {
start:
  %_0 = alloca [1 x i8], align 1
  %0 = zext i1 %dummy to i8
  store i8 %0, ptr %_0, align 1
  call void asm sideeffect "", "r,~{memory}"(ptr %_0), !srcloc !14
  %1 = load i8, ptr %_0, align 1
  %2 = trunc nuw i8 %1 to i1
  ret i1 %2
}

; std::sys::backtrace::__rust_begin_short_backtrace::<fn(), ()>
; Function Attrs: noinline uwtable
define internal void @_RINvNtNtCs1SSuMAdGM58_3std3sys9backtrace28___rust_begin_short_backtraceFEuuECs9CzmnnBYieY_6stages(ptr %f) unnamed_addr #2 !guid !16 {
start:
  %_2 = alloca [0 x i8], align 1
; call <fn() as core::ops::function::FnOnce<()>>::call_once
  call void @_RNvYFEuINtNtNtCsjIpoRzUjyHQ_4core3ops8function6FnOnceuE9call_onceCs9CzmnnBYieY_6stages(ptr %f) #8
  call void asm sideeffect "", "~{memory}"(), !srcloc !14
  ret void
}

; std::rt::lang_start::<()>::{closure#0}
; Function Attrs: inlinehint uwtable
define internal i32 @_RNCINvNtCs1SSuMAdGM58_3std2rt10lang_startuE0Cs9CzmnnBYieY_6stages(ptr align 8 %_1) unnamed_addr #1 !guid !17 {
start:
  %_4 = load ptr, ptr %_1, align 8
; call std::sys::backtrace::__rust_begin_short_backtrace::<fn(), ()>
  call void @_RINvNtNtCs1SSuMAdGM58_3std3sys9backtrace28___rust_begin_short_backtraceFEuuECs9CzmnnBYieY_6stages(ptr %_4) #9
; call <() as std::process::Termination>::report
  %self = call i8 @_RNvXsU_NtCs1SSuMAdGM58_3std7processuNtB5_11Termination6reportCs9CzmnnBYieY_6stages() #8
  %_0 = zext i8 %self to i32
  ret i32 %_0
}

; <std::rt::lang_start<()>::{closure#0} as core::ops::function::FnOnce<()>>::call_once::{shim:vtable#0}
; Function Attrs: inlinehint uwtable
define internal i32 @_RNSNvYNCINvNtCs1SSuMAdGM58_3std2rt10lang_startuE0INtNtNtCsjIpoRzUjyHQ_4core3ops8function6FnOnceuE9call_once6vtableCs9CzmnnBYieY_6stages(ptr %_1) unnamed_addr #1 !guid !18 {
start:
  %_2 = alloca [0 x i8], align 1
  %0 = load ptr, ptr %_1, align 8
; call <std::rt::lang_start<()>::{closure#0} as core::ops::function::FnOnce<()>>::call_once
  %_0 = call i32 @_RNvYNCINvNtCs1SSuMAdGM58_3std2rt10lang_startuE0INtNtNtCsjIpoRzUjyHQ_4core3ops8function6FnOnceuE9call_onceCs9CzmnnBYieY_6stages(ptr %0) #8
  ret i32 %_0
}

; stages::conditional
; Function Attrs: uwtable
define internal void @_RNvCs9CzmnnBYieY_6stages11conditional(i1 zeroext %flag, ptr align 8 %count) unnamed_addr #0 personality ptr @rust_eh_personality !guid !19 {
start:
  %0 = alloca [16 x i8], align 8
  %_9 = alloca [1 x i8], align 1
  %b = alloca [8 x i8], align 8
  %a = alloca [8 x i8], align 8
  store i8 0, ptr %_9, align 1
  store i8 1, ptr %_9, align 1
  store ptr %count, ptr %a, align 8
  store ptr %count, ptr %b, align 8
  br i1 %flag, label %bb1, label %bb2

bb2:                                              ; preds = %bb11, %start
; invoke core::hint::black_box::<&stages::Guard>
  %_7 = invoke align 8 ptr @_RINvNtCsjIpoRzUjyHQ_4core4hint9black_boxRNtCs9CzmnnBYieY_6stages5GuardEBF_(ptr align 8 %b)
          to label %bb3 unwind label %cleanup

bb1:                                              ; preds = %start
  store i8 0, ptr %_9, align 1
  %_6 = load ptr, ptr %a, align 8
; invoke core::mem::drop::<stages::Guard>
  invoke void @_RINvNtCsjIpoRzUjyHQ_4core3mem4dropNtCs9CzmnnBYieY_6stages5GuardEBy_(ptr align 8 %_6)
          to label %bb11 unwind label %cleanup

bb6:                                              ; preds = %cleanup
; invoke core::ptr::drop_glue::<stages::Guard>
  invoke void @_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtCs9CzmnnBYieY_6stages5GuardEBD_(ptr align 8 %b) #10
          to label %bb10 unwind label %terminate

cleanup:                                          ; preds = %bb2, %bb1
  %1 = landingpad { ptr, i32 }
          cleanup
  %2 = extractvalue { ptr, i32 } %1, 0
  %3 = extractvalue { ptr, i32 } %1, 1
  store ptr %2, ptr %0, align 8
  %4 = getelementptr inbounds i8, ptr %0, i64 8
  store i32 %3, ptr %4, align 8
  br label %bb6

bb11:                                             ; preds = %bb1
  br label %bb2

bb3:                                              ; preds = %bb2
; invoke core::ptr::drop_glue::<stages::Guard>
  invoke void @_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtCs9CzmnnBYieY_6stages5GuardEBD_(ptr align 8 %b)
          to label %bb4 unwind label %cleanup1

bb10:                                             ; preds = %bb6, %cleanup1
  %5 = load i8, ptr %_9, align 1
  %6 = trunc nuw i8 %5 to i1
  br i1 %6, label %bb9, label %bb7

cleanup1:                                         ; preds = %bb3
  %7 = landingpad { ptr, i32 }
          cleanup
  %8 = extractvalue { ptr, i32 } %7, 0
  %9 = extractvalue { ptr, i32 } %7, 1
  store ptr %8, ptr %0, align 8
  %10 = getelementptr inbounds i8, ptr %0, i64 8
  store i32 %9, ptr %10, align 8
  br label %bb10

bb4:                                              ; preds = %bb3
  %11 = load i8, ptr %_9, align 1
  %12 = trunc nuw i8 %11 to i1
  br i1 %12, label %bb8, label %bb5

bb5:                                              ; preds = %bb8, %bb4
  store i8 0, ptr %_9, align 1
  ret void

bb8:                                              ; preds = %bb4
; call core::ptr::drop_glue::<stages::Guard>
  call void @_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtCs9CzmnnBYieY_6stages5GuardEBD_(ptr align 8 %a)
  br label %bb5

terminate:                                        ; preds = %bb9, %bb6
  %13 = landingpad { ptr, i32 }
          filter [0 x ptr] zeroinitializer
; call core::panicking::panic_in_cleanup
  call void @_RNvNtCsjIpoRzUjyHQ_4core9panicking16panic_in_cleanup() #11
  unreachable

bb7:                                              ; preds = %bb9, %bb10
  %14 = load ptr, ptr %0, align 8
  %15 = getelementptr inbounds i8, ptr %0, i64 8
  %16 = load i32, ptr %15, align 8
  %17 = insertvalue { ptr, i32 } poison, ptr %14, 0
  %18 = insertvalue { ptr, i32 } %17, i32 %16, 1
  resume { ptr, i32 } %18

bb9:                                              ; preds = %bb10
; invoke core::ptr::drop_glue::<stages::Guard>
  invoke void @_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueNtCs9CzmnnBYieY_6stages5GuardEBD_(ptr align 8 %a) #10
          to label %bb7 unwind label %terminate
}

; stages::main
; Function Attrs: uwtable
define hidden void @_RNvCs9CzmnnBYieY_6stages4main() unnamed_addr #0 !guid !20 {
start:
  %_7 = alloca [8 x i8], align 8
  %count = alloca [8 x i8], align 8
; call <core::cell::Cell<u64>>::new
  %0 = call i64 @_RNvMs7_NtCsjIpoRzUjyHQ_4core4cellINtB5_4CellyE3newCs9CzmnnBYieY_6stages(i64 0) #8
  store i64 %0, ptr %count, align 8
; call core::hint::black_box::<bool>
  %_3 = call zeroext i1 @_RINvNtCsjIpoRzUjyHQ_4core4hint9black_boxbECs9CzmnnBYieY_6stages(i1 zeroext true) #8
; call stages::conditional
  call void @_RNvCs9CzmnnBYieY_6stages11conditional(i1 zeroext %_3, ptr align 8 %count)
; call <core::cell::Cell<u64>>::get
  %1 = call i64 @_RNvMs8_NtCsjIpoRzUjyHQ_4core4cellINtB5_4CellyE3getCs9CzmnnBYieY_6stages(ptr align 8 %count) #8
  store i64 %1, ptr %_7, align 8
  %_13 = load i64, ptr %_7, align 8
  %_14 = load i64, ptr @alloc_f85406d658e94b9c37cd2112f10307ee, align 8
  %_12 = icmp eq i64 %_13, %_14
  br i1 %_12, label %bb5, label %bb6

bb6:                                              ; preds = %start
; call core::panicking::assert_failed::<u64, u64>
  call void @_RINvNtCsjIpoRzUjyHQ_4core9panicking13assert_failedyyEB4_(i8 0, ptr align 8 %_7, ptr align 8 @alloc_f85406d658e94b9c37cd2112f10307ee, ptr null, ptr undef, ptr align 8 @alloc_770cfff3e7ea7887b74e74f003c9be9a) #12
  unreachable

bb5:                                              ; preds = %start
  ret void
}

; <core::cell::Cell<u64>>::new
; Function Attrs: inlinehint uwtable
define internal i64 @_RNvMs7_NtCsjIpoRzUjyHQ_4core4cellINtB5_4CellyE3newCs9CzmnnBYieY_6stages(i64 %value) unnamed_addr #1 !guid !21 {
start:
  ret i64 %value
}

; <core::cell::Cell<u64>>::set
; Function Attrs: inlinehint uwtable
define internal void @_RNvMs7_NtCsjIpoRzUjyHQ_4core4cellINtB5_4CellyE3setCs9CzmnnBYieY_6stages(ptr align 8 %self, i64 %val) unnamed_addr #1 !guid !22 {
start:
  %_3 = load i64, ptr %self, align 8
  store i64 %val, ptr %self, align 8
  ret void
}

; <core::cell::Cell<u64>>::get
; Function Attrs: inlinehint uwtable
define internal i64 @_RNvMs8_NtCsjIpoRzUjyHQ_4core4cellINtB5_4CellyE3getCs9CzmnnBYieY_6stages(ptr align 8 %self) unnamed_addr #1 !guid !23 {
start:
  %_0 = load i64, ptr %self, align 8
  ret i64 %_0
}

; <stages::Guard as core::ops::drop::Drop>::drop
; Function Attrs: uwtable
define internal void @_RNvXCs9CzmnnBYieY_6stagesNtB2_5GuardNtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4drop(ptr align 8 %self) unnamed_addr #0 !guid !24 {
start:
  %_6 = load ptr, ptr %self, align 8
  %_7 = load ptr, ptr %self, align 8
; call <core::cell::Cell<u64>>::get
  %_4 = call i64 @_RNvMs8_NtCsjIpoRzUjyHQ_4core4cellINtB5_4CellyE3getCs9CzmnnBYieY_6stages(ptr align 8 %_7) #8
  %_5.0 = add i64 %_4, 1
  %_5.1 = icmp ult i64 %_5.0, %_4
  br i1 %_5.1, label %panic, label %bb2

bb2:                                              ; preds = %start
; call <core::cell::Cell<u64>>::set
  call void @_RNvMs7_NtCsjIpoRzUjyHQ_4core4cellINtB5_4CellyE3setCs9CzmnnBYieY_6stages(ptr align 8 %_6, i64 %_5.0) #8
  ret void

panic:                                            ; preds = %start
; call core::panicking::panic_const::panic_const_add_overflow
  call void @_RNvNtNtCsjIpoRzUjyHQ_4core9panicking11panic_const24panic_const_add_overflow(ptr align 8 @alloc_eb3cb0362d4df237f01f3e1e96ae83a3) #12
  unreachable
}

; <() as std::process::Termination>::report
; Function Attrs: inlinehint uwtable
define internal i8 @_RNvXsU_NtCs1SSuMAdGM58_3std7processuNtB5_11Termination6reportCs9CzmnnBYieY_6stages() unnamed_addr #1 !guid !25 {
start:
  ret i8 0
}

; <fn() as core::ops::function::FnOnce<()>>::call_once
; Function Attrs: inlinehint uwtable
define internal void @_RNvYFEuINtNtNtCsjIpoRzUjyHQ_4core3ops8function6FnOnceuE9call_onceCs9CzmnnBYieY_6stages(ptr %_1) unnamed_addr #1 !guid !26 {
start:
  %_2 = alloca [0 x i8], align 1
  call void %_1()
  ret void
}

; <std::rt::lang_start<()>::{closure#0} as core::ops::function::FnOnce<()>>::call_once
; Function Attrs: inlinehint uwtable
define internal i32 @_RNvYNCINvNtCs1SSuMAdGM58_3std2rt10lang_startuE0INtNtNtCsjIpoRzUjyHQ_4core3ops8function6FnOnceuE9call_onceCs9CzmnnBYieY_6stages(ptr %0) unnamed_addr #1 personality ptr @rust_eh_personality !guid !27 {
start:
  %_2 = alloca [0 x i8], align 1
  %_1 = alloca [8 x i8], align 8
  store ptr %0, ptr %_1, align 8
; call std::rt::lang_start::<()>::{closure#0}
  %_0 = call i32 @_RNCINvNtCs1SSuMAdGM58_3std2rt10lang_startuE0Cs9CzmnnBYieY_6stages(ptr align 8 %_1) #8
  br label %bb1

bb1:                                              ; preds = %start
  ret i32 %_0

bb3:                                              ; No predecessors!
  unreachable

bb4:                                              ; No predecessors!
  unreachable
}

; std::rt::lang_start_internal
; Function Attrs: uwtable
declare i64 @_RNvNtCs1SSuMAdGM58_3std2rt19lang_start_internal(ptr, ptr align 8, i64, ptr, i8) unnamed_addr #0

; Function Attrs: nounwind uwtable
declare i32 @rust_eh_personality(i32, i32, i64, ptr, ptr) unnamed_addr #3

; core::panicking::panic_in_cleanup
; Function Attrs: cold minsize noinline noreturn nounwind optsize uwtable
declare void @_RNvNtCsjIpoRzUjyHQ_4core9panicking16panic_in_cleanup() unnamed_addr #4

; core::panicking::assert_failed::<u64, u64>
; Function Attrs: cold minsize noinline noreturn optsize uwtable
declare void @_RINvNtCsjIpoRzUjyHQ_4core9panicking13assert_failedyyEB4_(i8, ptr align 8, ptr align 8, ptr, ptr, ptr align 8) unnamed_addr #5

; core::panicking::panic_const::panic_const_add_overflow
; Function Attrs: cold noinline noreturn uwtable
declare void @_RNvNtNtCsjIpoRzUjyHQ_4core9panicking11panic_const24panic_const_add_overflow(ptr align 8) unnamed_addr #6

define i32 @main(i32 %0, ptr %1) unnamed_addr #7 !guid !28 {
top:
  %2 = sext i32 %0 to i64
; call std::rt::lang_start::<()>
  %3 = call i64 @_RINvNtCs1SSuMAdGM58_3std2rt10lang_startuECs9CzmnnBYieY_6stages(ptr @_RNvCs9CzmnnBYieY_6stages4main, i64 %2, ptr %1, i8 0)
  %4 = trunc i64 %3 to i32
  ret i32 %4
}

attributes #0 = { uwtable "frame-pointer"="non-leaf" "probe-stack"="inline-asm" "target-cpu"="apple-m1" }
attributes #1 = { inlinehint uwtable "frame-pointer"="non-leaf" "probe-stack"="inline-asm" "target-cpu"="apple-m1" }
attributes #2 = { noinline uwtable "frame-pointer"="non-leaf" "probe-stack"="inline-asm" "target-cpu"="apple-m1" }
attributes #3 = { nounwind uwtable "frame-pointer"="non-leaf" "probe-stack"="inline-asm" "target-cpu"="apple-m1" }
attributes #4 = { cold minsize noinline noreturn nounwind optsize uwtable "frame-pointer"="non-leaf" "probe-stack"="inline-asm" "target-cpu"="apple-m1" }
attributes #5 = { cold minsize noinline noreturn optsize uwtable "frame-pointer"="non-leaf" "probe-stack"="inline-asm" "target-cpu"="apple-m1" }
attributes #6 = { cold noinline noreturn uwtable "frame-pointer"="non-leaf" "probe-stack"="inline-asm" "target-cpu"="apple-m1" }
attributes #7 = { "frame-pointer"="non-leaf" "target-cpu"="apple-m1" }
attributes #8 = { inlinehint }
attributes #9 = { noinline }
attributes #10 = { cold }
attributes #11 = { cold noreturn nounwind }
attributes #12 = { noinline noreturn }

!llvm.module.flags = !{!5, !6, !7, !8}
!llvm.ident = !{!9}

!0 = !{i64 7241113740737168500}
!1 = !{i64 1191005084174333264}
!2 = !{i64 -2741437040774557411}
!3 = !{i64 -752677807500915209}
!4 = !{i64 9042338310449898969}
!5 = !{i32 8, !"PIC Level", i32 2}
!6 = !{i32 7, !"PIE Level", i32 2}
!7 = !{i32 7, !"uwtable", i32 2}
!8 = !{i32 7, !"frame-pointer", i32 1}
!9 = !{!"rustc version 1.99.0 (b940084d7 2026-09-28)"}
!10 = !{i64 6406676792000232129}
!11 = !{i64 1207631716923964307}
!12 = !{i64 3087368733926379268}
!13 = !{i64 814894108721401301}
!14 = !{i64 4980929408905726}
!15 = !{i64 9061923339120079844}
!16 = !{i64 -3551733820733953380}
!17 = !{i64 -8038068757755374469}
!18 = !{i64 -529900651833235189}
!19 = !{i64 -1190894866792440458}
!20 = !{i64 -1173136490817159861}
!21 = !{i64 -137241683689018392}
!22 = !{i64 -7707749903710489223}
!23 = !{i64 -8540634497900852085}
!24 = !{i64 -1545077059062664434}
!25 = !{i64 6976163004151634222}
!26 = !{i64 -77159415957910264}
!27 = !{i64 8743109686557523311}
!28 = !{i64 -2624081020897602054}
