; ModuleID = 'evidence_lab.4789476f54c908b2-cgu.06'
source_filename = "evidence_lab.4789476f54c908b2-cgu.06"
target datalayout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx11.0.0"

; core::slice::sort::stable::driftsort_main::<f64, <[f64]>::sort_by<<f64>::total_cmp>::{closure#0}, alloc::vec::Vec<f64>>
; Function Attrs: noinline uwtable
define void @_RINvNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6stable14driftsort_maindNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtB8_3f64d9total_cmpE0INtNtB18_3vec3VecdEECs68MIsFmw01O_12evidence_lab(ptr noalias nofree noundef nonnull align 8 %v.0, i64 noundef range(i64 0, 1152921504606846976) %v.1, ptr noalias nofree noundef align 8 dereferenceable(8) %is_less) unnamed_addr #0 personality ptr @rust_eh_personality !dbg !12 !guid !20 {
start:
  %stack_buf = alloca [4096 x i8], align 8
  %_95 = lshr i64 %v.1, 1, !dbg !21
  %v1 = sub nsw i64 %v.1, %_95, !dbg !24
  %..i = tail call noundef range(i64 0, 1000001) i64 @llvm.umin.i64(i64 range(i64 0, 1152921504606846976) %v.1, i64 1000000), !dbg !25
  %..i7 = tail call noundef range(i64 -576460752303423487, 1152921504606846976) i64 @llvm.umax.i64(i64 range(i64 0, 1152921504606846976) %..i, i64 range(i64 -576460752303423487, 1152921504606846976) %v1), !dbg !33
  call void @llvm.lifetime.start.p0(ptr nonnull %stack_buf), !dbg !38
  %_14 = icmp ult i64 %..i7, 513, !dbg !40
  br i1 %_14, label %bb8, label %bb4, !dbg !40

bb4:                                              ; preds = %start
  %_34.0.i.i = shl nsw i64 %..i7, 3, !dbg !44
  %_34.1.i.i = icmp ugt i64 %v1, 2305843009213693951, !dbg !44
  %_39.not.i.i = icmp ugt i64 %_34.0.i.i, 9223372036854775800
  %or.cond.i.i = or i1 %_34.1.i.i, %_39.not.i.i, !dbg !84
  br i1 %or.cond.i.i, label %bb3.i.i, label %bb3.i1.i, !dbg !84, !prof !90

bb3.i1.i:                                         ; preds = %bb4
; call __rustc::__rust_no_alloc_shim_is_unstable_v2
  tail call void @_RNvCsdtSMxSA38aw_7___rustc35___rust_no_alloc_shim_is_unstable_v2() #9, !dbg !91, !noalias !93
; call __rustc::__rust_alloc
  %0 = tail call noundef align 8 ptr @_RNvCsdtSMxSA38aw_7___rustc12___rust_alloc(i64 noundef range(i64 1, -9223372036854775808) %_34.0.i.i, i64 noundef range(i64 1, -9223372036854775807) 8) #9, !dbg !98, !noalias !93
  %1 = icmp eq ptr %0, null, !dbg !113
  br i1 %1, label %bb3.i.i, label %bb8, !dbg !115

bb3.i.i:                                          ; preds = %bb3.i1.i, %bb4
  %_4.i.sroa.4.0.ph.i = phi i64 [ 8, %bb3.i1.i ], [ 0, %bb4 ]
; call alloc::raw_vec::handle_error
  tail call void @_RNvNtCs6zY7rJBZy9D_5alloc7raw_vec12handle_error(i64 noundef %_4.i.sroa.4.0.ph.i, i64 %_34.0.i.i) #10, !dbg !116, !noalias !118
  unreachable, !dbg !116

cleanup:                                          ; preds = %bb8
  %2 = landingpad { ptr, i32 }
          cleanup
  br i1 %_14, label %common.resume, label %bb2.i.i.i, !dbg !119

bb8:                                              ; preds = %bb3.i1.i, %start
  %heap_buf.sroa.6.0 = phi ptr [ undef, %start ], [ %0, %bb3.i1.i ]
  %stack_scratch.sroa.4.0 = phi i64 [ 512, %start ], [ %..i7, %bb3.i1.i ], !dbg !120
  %.pn = phi ptr [ %stack_buf, %start ], [ %0, %bb3.i1.i ]
  %eager_sort = icmp samesign ult i64 %v.1, 65, !dbg !121
; invoke core::slice::sort::stable::drift::sort::<f64, <[f64]>::sort_by<<f64>::total_cmp>::{closure#0}>
  invoke void @_RINvNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6stable5drift4sortdNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtBa_3f64d9total_cmpE0ECs68MIsFmw01O_12evidence_lab(ptr noalias nofree noundef nonnull align 8 %v.0, i64 noundef %v.1, ptr noalias nofree noundef nonnull align 8 %.pn, i64 noundef %stack_scratch.sroa.4.0, i1 noundef zeroext %eager_sort, ptr noalias nofree noundef nonnull align 8 dereferenceable(8) %is_less)
          to label %bb9 unwind label %cleanup, !dbg !123

bb9:                                              ; preds = %bb8
  br i1 %_14, label %bb10, label %bb2.i.i, !dbg !119

bb10:                                             ; preds = %bb2.i.i, %bb9
  call void @llvm.lifetime.end.p0(ptr nonnull %stack_buf), !dbg !125
  ret void, !dbg !126

common.resume:                                    ; preds = %bb2.i.i.i, %cleanup
  resume { ptr, i32 } %2, !dbg !127

bb2.i.i:                                          ; preds = %bb9
  %alloc_size.i.i.i = shl nuw nsw i64 %..i7, 3, !dbg !128
; call __rustc::__rust_dealloc
  call void @_RNvCsdtSMxSA38aw_7___rustc14___rust_dealloc(ptr noundef nonnull %heap_buf.sroa.6.0, i64 noundef %alloc_size.i.i.i, i64 noundef range(i64 1, -9223372036854775807) 8) #9, !dbg !145, !noalias !154
  br label %bb10, !dbg !157

bb2.i.i.i:                                        ; preds = %cleanup
  call void @llvm.assume(i1 true) [ "nonnull"(ptr %heap_buf.sroa.6.0) ]
  %alloc_size.i.i.i.i = shl nuw nsw i64 %..i7, 3, !dbg !158
; call __rustc::__rust_dealloc
  call void @_RNvCsdtSMxSA38aw_7___rustc14___rust_dealloc(ptr noundef nonnull %heap_buf.sroa.6.0, i64 noundef %alloc_size.i.i.i.i, i64 noundef range(i64 1, -9223372036854775807) 8) #9, !dbg !165, !noalias !170
  br label %common.resume, !dbg !173
}

; Function Attrs: nounwind uwtable
declare noundef range(i32 0, 10) i32 @rust_eh_personality(i32 noundef, i32 noundef, i64 noundef, ptr noundef, ptr noundef) unnamed_addr #1

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(ptr captures(none)) #2

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(ptr captures(none)) #2

; core::slice::sort::stable::drift::sort::<f64, <[f64]>::sort_by<<f64>::total_cmp>::{closure#0}>
; Function Attrs: uwtable
declare hidden void @_RINvNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6stable5drift4sortdNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtBa_3f64d9total_cmpE0ECs68MIsFmw01O_12evidence_lab(ptr noalias nofree noundef nonnull align 8, i64 noundef range(i64 0, 1152921504606846976), ptr noalias nofree noundef nonnull align 8, i64 noundef range(i64 0, 1152921504606846976), i1 noundef zeroext, ptr noalias nofree noundef align 8 dereferenceable(8)) unnamed_addr #3

; Function Attrs: nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none)
declare i64 @llvm.umin.i64(i64, i64) #4

; Function Attrs: nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none)
declare i64 @llvm.umax.i64(i64, i64) #4

; __rustc::__rust_no_alloc_shim_is_unstable_v2
; Function Attrs: nounwind uwtable
declare void @_RNvCsdtSMxSA38aw_7___rustc35___rust_no_alloc_shim_is_unstable_v2() unnamed_addr #1

; __rustc::__rust_alloc
; Function Attrs: nounwind allockind("alloc,uninitialized,aligned") allocsize(0) uwtable
declare noalias noundef ptr @_RNvCsdtSMxSA38aw_7___rustc12___rust_alloc(i64 noundef, i64 allocalign noundef range(i64 1, -9223372036854775807)) unnamed_addr #5

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(inaccessiblemem: write)
declare void @llvm.assume(i1 noundef) #6

; __rustc::__rust_dealloc
; Function Attrs: nounwind allockind("free") uwtable
declare void @_RNvCsdtSMxSA38aw_7___rustc14___rust_dealloc(ptr allocptr noundef nonnull captures(address), i64 noundef, i64 noundef range(i64 1, -9223372036854775807)) unnamed_addr #7

; alloc::raw_vec::handle_error
; Function Attrs: cold minsize noreturn optsize uwtable
declare void @_RNvNtCs6zY7rJBZy9D_5alloc7raw_vec12handle_error(i64 noundef range(i64 0, -9223372036854775807), i64) unnamed_addr #8

attributes #0 = { noinline uwtable "frame-pointer"="non-leaf" "probe-stack"="inline-asm" "target-cpu"="apple-m1" }
attributes #1 = { nounwind uwtable "frame-pointer"="non-leaf" "probe-stack"="inline-asm" "target-cpu"="apple-m1" }
attributes #2 = { nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #3 = { uwtable "frame-pointer"="non-leaf" "probe-stack"="inline-asm" "target-cpu"="apple-m1" }
attributes #4 = { nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none) }
attributes #5 = { nounwind allockind("alloc,uninitialized,aligned") allocsize(0) uwtable "alloc-family"="__rust_alloc" "alloc-variant-zeroed"="_RNvCsdtSMxSA38aw_7___rustc19___rust_alloc_zeroed" "frame-pointer"="non-leaf" "probe-stack"="inline-asm" "target-cpu"="apple-m1" }
attributes #6 = { nocallback nofree nosync nounwind willreturn memory(inaccessiblemem: write) }
attributes #7 = { nounwind allockind("free") uwtable "alloc-family"="__rust_alloc" "frame-pointer"="non-leaf" "probe-stack"="inline-asm" "target-cpu"="apple-m1" }
attributes #8 = { cold minsize noreturn optsize uwtable "frame-pointer"="non-leaf" "probe-stack"="inline-asm" "target-cpu"="apple-m1" }
attributes #9 = { nounwind }
attributes #10 = { noreturn }

!llvm.module.flags = !{!0, !1, !2, !3, !4}
!llvm.ident = !{!5}
!llvm.dbg.cu = !{!6, !8, !10}

!0 = !{i32 8, !"PIC Level", i32 2}
!1 = !{i32 7, !"uwtable", i32 2}
!2 = !{i32 7, !"frame-pointer", i32 1}
!3 = !{i32 7, !"Dwarf Version", i32 4}
!4 = !{i32 2, !"Debug Info Version", i32 3}
!5 = !{!"rustc version 1.99.0 (b940084d7 2026-09-28)"}
!6 = distinct !DICompileUnit(language: DW_LANG_Rust, file: !7, producer: "clang LLVM (rustc version 1.99.0 (b940084d7 2026-09-28))", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, splitDebugInlining: false, nameTableKind: None)
!7 = !DIFile(filename: "src/lib.rs/@/evidence_lab.4789476f54c908b2-cgu.06", directory: "/Users/juanwang/Desktop/tutorials/cpp-rust/bench/evidence-lab")
!8 = distinct !DICompileUnit(language: DW_LANG_Rust, file: !9, producer: "clang LLVM (rustc version 1.99.0 (b940084d7 2026-09-28))", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, splitDebugInlining: false, nameTableKind: None)
!9 = !DIFile(filename: "src/lib.rs/@/evidence_lab.4789476f54c908b2-cgu.05", directory: "/Users/juanwang/Desktop/tutorials/cpp-rust/bench/evidence-lab")
!10 = distinct !DICompileUnit(language: DW_LANG_Rust, file: !11, producer: "clang LLVM (rustc version 1.99.0 (b940084d7 2026-09-28))", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, splitDebugInlining: false, nameTableKind: None)
!11 = !DIFile(filename: "src/lib.rs/@/evidence_lab.4789476f54c908b2-cgu.08", directory: "/Users/juanwang/Desktop/tutorials/cpp-rust/bench/evidence-lab")
!12 = distinct !DISubprogram(name: "driftsort_main<f64, alloc::slice::{impl#0}::sort_by::{closure_env#0}<f64, fn(&f64, &f64) -> core::cmp::Ordering>, alloc::vec::Vec<f64, alloc::alloc::Global>>", linkageName: "_RINvNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6stable14driftsort_maindNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtB8_3f64d9total_cmpE0INtNtB18_3vec3VecdEECs68MIsFmw01O_12evidence_lab", scope: !14, file: !13, line: 94, type: !18, scopeLine: 94, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !19)
!13 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/slice/sort/stable/mod.rs", directory: "", checksumkind: CSK_MD5, checksum: "943c9866fee121b7ec645aa6171a994f")
!14 = !DINamespace(name: "stable", scope: !15)
!15 = !DINamespace(name: "sort", scope: !16)
!16 = !DINamespace(name: "slice", scope: !17)
!17 = !DINamespace(name: "core", scope: null)
!18 = !DISubroutineType(types: !19)
!19 = !{}
!20 = !{i64 -665904189395289709}
!21 = !DILocation(line: 115, column: 24, scope: !22)
!22 = distinct !DILexicalBlock(scope: !23, file: !13, line: 113, column: 5)
!23 = distinct !DILexicalBlock(scope: !12, file: !13, line: 112, column: 5)
!24 = !DILocation(line: 115, column: 18, scope: !22)
!25 = !DILocation(line: 1090, column: 5, scope: !26, inlinedAt: !30)
!26 = distinct !DISubprogram(name: "min<usize>", linkageName: "_RNvYjNtNtCsjIpoRzUjyHQ_4core3cmp3Ord3minCs68MIsFmw01O_12evidence_lab", scope: !28, file: !27, line: 1085, type: !18, scopeLine: 1085, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !19)
!27 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/cmp.rs", directory: "", checksumkind: CSK_MD5, checksum: "49e2a03e6445d88887d9438f640a7fcc")
!28 = !DINamespace(name: "Ord", scope: !29)
!29 = !DINamespace(name: "cmp", scope: !17)
!30 = distinct !DILocation(line: 1587, column: 8, scope: !31, inlinedAt: !32)
!31 = distinct !DISubprogram(name: "min<usize>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3cmp3minjECs68MIsFmw01O_12evidence_lab", scope: !29, file: !27, line: 1586, type: !18, scopeLine: 1586, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !19)
!32 = !DILocation(line: 115, column: 33, scope: !22)
!33 = !DILocation(line: 1051, column: 5, scope: !34, inlinedAt: !35)
!34 = distinct !DISubprogram(name: "max<usize>", linkageName: "_RNvYjNtNtCsjIpoRzUjyHQ_4core3cmp3Ord3maxCs68MIsFmw01O_12evidence_lab", scope: !28, file: !27, line: 1046, type: !18, scopeLine: 1046, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !19)
!35 = distinct !DILocation(line: 1694, column: 8, scope: !36, inlinedAt: !37)
!36 = distinct !DISubprogram(name: "max<usize>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3cmp3maxjECs68MIsFmw01O_12evidence_lab", scope: !29, file: !27, line: 1693, type: !18, scopeLine: 1693, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !19)
!37 = !DILocation(line: 115, column: 9, scope: !22)
!38 = !DILocation(line: 121, column: 9, scope: !39)
!39 = distinct !DILexicalBlock(scope: !22, file: !13, line: 114, column: 5)
!40 = !DILocation(line: 124, column: 22, scope: !41)
!41 = distinct !DILexicalBlock(scope: !42, file: !13, line: 123, column: 5)
!42 = distinct !DILexicalBlock(scope: !43, file: !13, line: 122, column: 5)
!43 = distinct !DILexicalBlock(scope: !39, file: !13, line: 121, column: 5)
!44 = !DILocation(line: 3212, column: 26, scope: !45, inlinedAt: !49)
!45 = distinct !DISubprogram(name: "overflowing_mul", linkageName: "_RNvMs9_NtCsjIpoRzUjyHQ_4core3numj15overflowing_mul", scope: !47, file: !46, line: 3211, type: !18, scopeLine: 3211, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !8, templateParams: !19)
!46 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/num/uint_macros.rs", directory: "", checksumkind: CSK_MD5, checksum: "861b08c040dcb8e56aa7d23dacf541ca")
!47 = !DINamespace(name: "{impl#11}", scope: !48)
!48 = !DINamespace(name: "num", scope: !17)
!49 = distinct !DILocation(line: 1330, column: 31, scope: !50, inlinedAt: !51)
!50 = distinct !DISubprogram(name: "checked_mul", linkageName: "_RNvMs9_NtCsjIpoRzUjyHQ_4core3numj11checked_mul", scope: !47, file: !46, line: 1329, type: !18, scopeLine: 1329, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !8, templateParams: !19)
!51 = distinct !DILocation(line: 533, column: 39, scope: !52, inlinedAt: !58)
!52 = distinct !DILexicalBlock(scope: !54, file: !53, line: 533, column: 54)
!53 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/alloc/layout.rs", directory: "", checksumkind: CSK_MD5, checksum: "044b929685d8564035fcb902806519e4")
!54 = distinct !DISubprogram(name: "repeat_packed", linkageName: "_RNvMNtNtCsjIpoRzUjyHQ_4core5alloc6layoutNtB2_6Layout13repeat_packed", scope: !55, file: !53, line: 532, type: !18, scopeLine: 532, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !8, templateParams: !19)
!55 = !DINamespace(name: "Layout", scope: !56)
!56 = !DINamespace(name: "layout", scope: !57)
!57 = !DINamespace(name: "alloc", scope: !17)
!58 = distinct !DILocation(line: 901, column: 17, scope: !59, inlinedAt: !63)
!59 = distinct !DISubprogram(name: "layout_array", linkageName: "_RNvNtCs6zY7rJBZy9D_5alloc7raw_vec12layout_array", scope: !61, file: !60, line: 896, type: !18, scopeLine: 896, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !8, templateParams: !19)
!60 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/alloc/src/raw_vec/mod.rs", directory: "", checksumkind: CSK_MD5, checksum: "acd4dae5e7aaaaf06aa0208ebac37ff5")
!61 = !DINamespace(name: "raw_vec", scope: !62)
!62 = !DINamespace(name: "alloc", scope: null)
!63 = distinct !DILocation(line: 455, column: 28, scope: !64, inlinedAt: !66)
!64 = distinct !DISubprogram(name: "try_allocate_in<alloc::alloc::Global>", linkageName: "_RNvMs5_NtCs6zY7rJBZy9D_5alloc7raw_vecNtB5_11RawVecInner15try_allocate_inCs68MIsFmw01O_12evidence_lab", scope: !65, file: !60, line: 447, type: !18, scopeLine: 447, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !8, templateParams: !19)
!65 = !DINamespace(name: "RawVecInner", scope: !61)
!66 = distinct !DILocation(line: 435, column: 15, scope: !67, inlinedAt: !68)
!67 = distinct !DISubprogram(name: "with_capacity_in<alloc::alloc::Global>", linkageName: "_RNvMs5_NtCs6zY7rJBZy9D_5alloc7raw_vecNtB5_11RawVecInner16with_capacity_inCs68MIsFmw01O_12evidence_lab", scope: !65, file: !60, line: 434, type: !18, scopeLine: 434, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !10, templateParams: !19)
!68 = distinct !DILocation(line: 177, column: 20, scope: !69, inlinedAt: !71)
!69 = distinct !DISubprogram(name: "with_capacity_in<f64, alloc::alloc::Global>", linkageName: "_RNvMs4_NtCs6zY7rJBZy9D_5alloc7raw_vecINtB5_6RawVecdE16with_capacity_inCs68MIsFmw01O_12evidence_lab", scope: !70, file: !60, line: 175, type: !18, scopeLine: 175, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !10, templateParams: !19)
!70 = !DINamespace(name: "RawVec", scope: !61)
!71 = distinct !DILocation(line: 969, column: 20, scope: !72, inlinedAt: !76)
!72 = distinct !DISubprogram(name: "with_capacity_in<f64, alloc::alloc::Global>", linkageName: "_RNvMsG_NtCs6zY7rJBZy9D_5alloc3vecINtB5_3VecdE16with_capacity_inCs68MIsFmw01O_12evidence_lab", scope: !74, file: !73, line: 968, type: !18, scopeLine: 968, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !10, templateParams: !19)
!73 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/alloc/src/vec/mod.rs", directory: "", checksumkind: CSK_MD5, checksum: "a93d3a7d4a1d55c9887c540882057a4f")
!74 = !DINamespace(name: "Vec", scope: !75)
!75 = !DINamespace(name: "vec", scope: !62)
!76 = distinct !DILocation(line: 522, column: 9, scope: !77, inlinedAt: !78)
!77 = distinct !DISubprogram(name: "with_capacity<f64>", linkageName: "_RNvMNtCs6zY7rJBZy9D_5alloc3vecINtB2_3VecdE13with_capacityCs68MIsFmw01O_12evidence_lab", scope: !74, file: !73, line: 521, type: !18, scopeLine: 521, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !10, templateParams: !19)
!78 = distinct !DILocation(line: 864, column: 9, scope: !79, inlinedAt: !83)
!79 = distinct !DISubprogram(name: "with_capacity<f64>", linkageName: "_RNvXs8_NtCs6zY7rJBZy9D_5alloc5sliceINtNtB7_3vec3VecdEINtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6stable8BufGuarddE13with_capacityCs68MIsFmw01O_12evidence_lab", scope: !81, file: !80, line: 863, type: !18, scopeLine: 863, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !10, templateParams: !19)
!80 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/alloc/src/slice.rs", directory: "", checksumkind: CSK_MD5, checksum: "8e7bce5d617a4e88f7bdb700dff9d669")
!81 = !DINamespace(name: "{impl#10}", scope: !82)
!82 = !DINamespace(name: "slice", scope: !62)
!83 = distinct !DILocation(line: 127, column: 20, scope: !41)
!84 = !DILocation(line: 478, column: 8, scope: !85, inlinedAt: !88)
!85 = distinct !DISubprogram(name: "unlikely", linkageName: "_RNvNtCsjIpoRzUjyHQ_4core10intrinsics8unlikely", scope: !87, file: !86, line: 477, type: !18, scopeLine: 477, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !8, templateParams: !19)
!86 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/intrinsics/mod.rs", directory: "", checksumkind: CSK_MD5, checksum: "95f29c0132b18aca34fbfb798048cc68")
!87 = !DINamespace(name: "intrinsics", scope: !17)
!88 = distinct !DILocation(line: 1331, column: 16, scope: !89, inlinedAt: !51)
!89 = distinct !DILexicalBlock(scope: !50, file: !46, line: 1330, column: 13)
!90 = !{!"branch_weights", i32 2002, i32 2000}
!91 = !DILocation(line: 0, scope: !92, inlinedAt: !66)
!92 = distinct !DILexicalBlock(scope: !64, file: !60, line: 455, column: 9)
!93 = !{!94, !96}
!94 = distinct !{!94, !95, !"_RNvMs5_NtCs6zY7rJBZy9D_5alloc7raw_vecNtB5_11RawVecInner15try_allocate_inCs68MIsFmw01O_12evidence_lab: %_0"}
!95 = distinct !{!95, !"_RNvMs5_NtCs6zY7rJBZy9D_5alloc7raw_vecNtB5_11RawVecInner15try_allocate_inCs68MIsFmw01O_12evidence_lab"}
!96 = distinct !{!96, !97, !"_RNvXs8_NtCs6zY7rJBZy9D_5alloc5sliceINtNtB7_3vec3VecdEINtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6stable8BufGuarddE13with_capacityCs68MIsFmw01O_12evidence_lab: %_0"}
!97 = distinct !{!97, !"_RNvXs8_NtCs6zY7rJBZy9D_5alloc5sliceINtNtB7_3vec3VecdEINtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6stable8BufGuarddE13with_capacityCs68MIsFmw01O_12evidence_lab"}
!98 = !DILocation(line: 130, column: 9, scope: !99, inlinedAt: !102)
!99 = distinct !DISubprogram(name: "alloc", linkageName: "_RNvNtCs6zY7rJBZy9D_5alloc5alloc5alloc", scope: !101, file: !100, line: 124, type: !18, scopeLine: 124, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !8, templateParams: !19)
!100 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/alloc/src/alloc.rs", directory: "", checksumkind: CSK_MD5, checksum: "87b4d0ba26e1dfe94542079de6981d97")
!101 = !DINamespace(name: "alloc", scope: !62)
!102 = distinct !DILocation(line: 302, column: 73, scope: !103, inlinedAt: !106)
!103 = distinct !DILexicalBlock(scope: !104, file: !100, line: 301, column: 13)
!104 = distinct !DISubprogram(name: "alloc_impl_runtime", linkageName: "_RNvMs0_NtCs6zY7rJBZy9D_5alloc5allocNtB5_6Global18alloc_impl_runtime", scope: !105, file: !100, line: 297, type: !18, scopeLine: 297, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !8, templateParams: !19)
!105 = !DINamespace(name: "Global", scope: !101)
!106 = distinct !DILocation(line: 424, column: 9, scope: !107, inlinedAt: !108)
!107 = distinct !DISubprogram(name: "alloc_impl", linkageName: "_RNvMs0_NtCs6zY7rJBZy9D_5alloc5allocNtB5_6Global10alloc_impl", scope: !105, file: !100, line: 423, type: !18, scopeLine: 423, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !8, templateParams: !19)
!108 = distinct !DILocation(line: 541, column: 14, scope: !109, inlinedAt: !112)
!109 = distinct !DISubprogram(name: "allocate", linkageName: "_RNvXs1_NtCs6zY7rJBZy9D_5alloc5allocNtB5_6GlobalNtNtCsjIpoRzUjyHQ_4core5alloc9Allocator8allocate", scope: !110, file: !100, line: 540, type: !111, scopeLine: 540, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !8, templateParams: !19)
!110 = !DINamespace(name: "{impl#3}", scope: !101)
!111 = !DISubroutineType(cc: DW_CC_nocall, types: !19)
!112 = distinct !DILocation(line: 466, column: 47, scope: !92, inlinedAt: !66)
!113 = !DILocation(line: 470, column: 25, scope: !114, inlinedAt: !66)
!114 = distinct !DILexicalBlock(scope: !92, file: !60, line: 465, column: 9)
!115 = !DILocation(line: 470, column: 19, scope: !114, inlinedAt: !66)
!116 = !DILocation(line: 443, column: 25, scope: !117, inlinedAt: !68)
!117 = distinct !DILexicalBlock(scope: !67, file: !60, line: 443, column: 13)
!118 = !{!96}
!119 = !DILocation(line: 136, column: 1, scope: !42)
!120 = !DILocation(line: 0, scope: !43)
!121 = !DILocation(line: 134, column: 22, scope: !122)
!122 = distinct !DILexicalBlock(scope: !41, file: !13, line: 124, column: 5)
!123 = !DILocation(line: 135, column: 5, scope: !124)
!124 = distinct !DILexicalBlock(scope: !122, file: !13, line: 134, column: 5)
!125 = !DILocation(line: 136, column: 1, scope: !39)
!126 = !DILocation(line: 136, column: 2, scope: !12)
!127 = !DILocation(line: 0, scope: !12)
!128 = !DILocation(line: 1401, column: 17, scope: !129, inlinedAt: !130)
!129 = distinct !DISubprogram(name: "unchecked_mul", linkageName: "_RNvMs9_NtCsjIpoRzUjyHQ_4core3numj13unchecked_mul", scope: !47, file: !46, line: 1389, type: !18, scopeLine: 1389, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !8, templateParams: !19)
!130 = distinct !DILocation(line: 639, column: 53, scope: !131, inlinedAt: !132)
!131 = distinct !DISubprogram(name: "current_memory<alloc::alloc::Global>", linkageName: "_RNvMs2_NtCs6zY7rJBZy9D_5alloc7raw_vecNtB5_11RawVecInner14current_memoryCs68MIsFmw01O_12evidence_lab", scope: !65, file: !60, line: 630, type: !111, scopeLine: 630, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !8, templateParams: !19)
!132 = distinct !DILocation(line: 874, column: 52, scope: !133, inlinedAt: !135)
!133 = distinct !DILexicalBlock(scope: !134, file: !60, line: 874, column: 82)
!134 = distinct !DISubprogram(name: "deallocate<alloc::alloc::Global>", linkageName: "_RNvMs3_NtCs6zY7rJBZy9D_5alloc7raw_vecNtB5_11RawVecInner10deallocateCs68MIsFmw01O_12evidence_lab", scope: !65, file: !60, line: 872, type: !111, scopeLine: 872, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !8, templateParams: !19)
!135 = distinct !DILocation(line: 425, column: 29, scope: !136, inlinedAt: !138)
!136 = distinct !DISubprogram(name: "drop<f64, alloc::alloc::Global>", linkageName: "_RNvXs1_NtCs6zY7rJBZy9D_5alloc7raw_vecINtB5_6RawVecdENtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4dropCs68MIsFmw01O_12evidence_lab", scope: !137, file: !60, line: 423, type: !18, scopeLine: 423, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !8, templateParams: !19)
!137 = !DINamespace(name: "{impl#3}", scope: !61)
!138 = distinct !DILocation(line: 847, column: 1, scope: !139, inlinedAt: !142)
!139 = distinct !DISubprogram(name: "drop_glue<alloc::raw_vec::RawVec<f64, alloc::alloc::Global>>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc7raw_vec6RawVecdEECs68MIsFmw01O_12evidence_lab", scope: !141, file: !140, line: 847, type: !18, scopeLine: 847, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !19)
!140 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/ptr/mod.rs", directory: "", checksumkind: CSK_MD5, checksum: "59033ebc630da002040513c25c9de121")
!141 = !DINamespace(name: "ptr", scope: !17)
!142 = distinct !DILocation(line: 847, column: 1, scope: !143, inlinedAt: !144)
!143 = distinct !DISubprogram(name: "drop_glue<alloc::vec::Vec<f64, alloc::alloc::Global>>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc3vec3VecdEECs68MIsFmw01O_12evidence_lab", scope: !141, file: !140, line: 847, type: !111, scopeLine: 847, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !19)
!144 = distinct !DILocation(line: 136, column: 1, scope: !42)
!145 = !DILocation(line: 175, column: 14, scope: !146, inlinedAt: !147)
!146 = distinct !DISubprogram(name: "dealloc_nonnull", linkageName: "_RNvNtCs6zY7rJBZy9D_5alloc5alloc15dealloc_nonnull", scope: !101, file: !100, line: 174, type: !18, scopeLine: 174, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !8, templateParams: !19)
!147 = distinct !DILocation(line: 321, column: 22, scope: !148, inlinedAt: !149)
!148 = distinct !DISubprogram(name: "deallocate_impl_runtime", linkageName: "_RNvMs0_NtCs6zY7rJBZy9D_5alloc5allocNtB5_6Global23deallocate_impl_runtime", scope: !105, file: !100, line: 311, type: !18, scopeLine: 311, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !8, templateParams: !19)
!149 = distinct !DILocation(line: 436, column: 9, scope: !150, inlinedAt: !151)
!150 = distinct !DISubprogram(name: "deallocate_impl", linkageName: "_RNvMs0_NtCs6zY7rJBZy9D_5alloc5allocNtB5_6Global15deallocate_impl", scope: !105, file: !100, line: 435, type: !18, scopeLine: 435, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !8, templateParams: !19)
!151 = distinct !DILocation(line: 554, column: 23, scope: !152, inlinedAt: !153)
!152 = distinct !DISubprogram(name: "deallocate", linkageName: "_RNvXs1_NtCs6zY7rJBZy9D_5alloc5allocNtB5_6GlobalNtNtCsjIpoRzUjyHQ_4core5alloc9Allocator10deallocate", scope: !110, file: !100, line: 552, type: !111, scopeLine: 552, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !8, templateParams: !19)
!153 = distinct !DILocation(line: 876, column: 28, scope: !133, inlinedAt: !135)
!154 = !{!155}
!155 = distinct !{!155, !156, !"_RNvXs1_NtCs6zY7rJBZy9D_5alloc7raw_vecINtB5_6RawVecdENtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4dropCs68MIsFmw01O_12evidence_lab: %self"}
!156 = distinct !{!156, !"_RNvXs1_NtCs6zY7rJBZy9D_5alloc7raw_vecINtB5_6RawVecdENtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4dropCs68MIsFmw01O_12evidence_lab"}
!157 = !DILocation(line: 312, column: 9, scope: !148, inlinedAt: !149)
!158 = !DILocation(line: 1401, column: 17, scope: !129, inlinedAt: !159)
!159 = distinct !DILocation(line: 639, column: 53, scope: !131, inlinedAt: !160)
!160 = distinct !DILocation(line: 874, column: 52, scope: !133, inlinedAt: !161)
!161 = distinct !DILocation(line: 425, column: 29, scope: !136, inlinedAt: !162)
!162 = distinct !DILocation(line: 847, column: 1, scope: !139, inlinedAt: !163)
!163 = distinct !DILocation(line: 847, column: 1, scope: !143, inlinedAt: !164)
!164 = distinct !DILocation(line: 136, column: 1, scope: !42)
!165 = !DILocation(line: 175, column: 14, scope: !146, inlinedAt: !166)
!166 = distinct !DILocation(line: 321, column: 22, scope: !148, inlinedAt: !167)
!167 = distinct !DILocation(line: 436, column: 9, scope: !150, inlinedAt: !168)
!168 = distinct !DILocation(line: 554, column: 23, scope: !152, inlinedAt: !169)
!169 = distinct !DILocation(line: 876, column: 28, scope: !133, inlinedAt: !161)
!170 = !{!171}
!171 = distinct !{!171, !172, !"_RNvXs1_NtCs6zY7rJBZy9D_5alloc7raw_vecINtB5_6RawVecdENtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4dropCs68MIsFmw01O_12evidence_lab: %self"}
!172 = distinct !{!172, !"_RNvXs1_NtCs6zY7rJBZy9D_5alloc7raw_vecINtB5_6RawVecdENtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4dropCs68MIsFmw01O_12evidence_lab"}
!173 = !DILocation(line: 312, column: 9, scope: !148, inlinedAt: !167)
