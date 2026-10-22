; ModuleID = 'evidence_lab.4789476f54c908b2-cgu.08'
source_filename = "evidence_lab.4789476f54c908b2-cgu.08"
target datalayout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx11.0.0"

; <alloc::vec::Vec<f64> as core::slice::sort::stable::BufGuard<f64>>::with_capacity
; Function Attrs: uwtable
define hidden void @_RNvXs8_NtCs6zY7rJBZy9D_5alloc5sliceINtNtB7_3vec3VecdEINtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6stable8BufGuarddE13with_capacityCs68MIsFmw01O_12evidence_lab(ptr dead_on_unwind noalias nofree noundef writable writeonly sret([24 x i8]) align 8 captures(none) dereferenceable(24) %_0, i64 noundef %capacity) unnamed_addr #0 personality ptr @rust_eh_personality !dbg !10 !guid !17 {
start:
  %_34.0.i = shl i64 %capacity, 3, !dbg !18
  %_34.1.i = icmp ugt i64 %capacity, 2305843009213693951, !dbg !18
  %_39.not.i = icmp ugt i64 %_34.0.i, 9223372036854775800
  %or.cond.i = or i1 %_34.1.i, %_39.not.i, !dbg !53
  br i1 %or.cond.i, label %bb3.i, label %bb18.i, !dbg !53, !prof !59

bb18.i:                                           ; preds = %start
  %0 = icmp eq i64 %_34.0.i, 0, !dbg !60
  br i1 %0, label %_RNvMs5_NtCs6zY7rJBZy9D_5alloc7raw_vecNtB5_11RawVecInner16with_capacity_inCs68MIsFmw01O_12evidence_lab.exit, label %bb3.i1, !dbg !60

bb3.i1:                                           ; preds = %bb18.i
; call __rustc::__rust_no_alloc_shim_is_unstable_v2
  tail call void @_RNvCsdtSMxSA38aw_7___rustc35___rust_no_alloc_shim_is_unstable_v2() #7, !dbg !62, !noalias !63
; call __rustc::__rust_alloc
  %1 = tail call noundef align 8 ptr @_RNvCsdtSMxSA38aw_7___rustc12___rust_alloc(i64 noundef range(i64 1, -9223372036854775808) %_34.0.i, i64 noundef range(i64 1, -9223372036854775807) 8) #7, !dbg !66, !noalias !63
  %2 = icmp eq ptr %1, null, !dbg !81
  br i1 %2, label %bb3.i, label %bb10.i, !dbg !83

bb10.i:                                           ; preds = %bb3.i1
  %3 = ptrtoint ptr %1 to i64, !dbg !84
  br label %_RNvMs5_NtCs6zY7rJBZy9D_5alloc7raw_vecNtB5_11RawVecInner16with_capacity_inCs68MIsFmw01O_12evidence_lab.exit, !dbg !86

bb3.i:                                            ; preds = %start, %bb3.i1
  %_4.i.sroa.4.0.ph = phi i64 [ 8, %bb3.i1 ], [ 0, %start ]
; call alloc::raw_vec::handle_error
  tail call void @_RNvNtCs6zY7rJBZy9D_5alloc7raw_vec12handle_error(i64 noundef %_4.i.sroa.4.0.ph, i64 %_34.0.i) #8, !dbg !87
  unreachable, !dbg !87

_RNvMs5_NtCs6zY7rJBZy9D_5alloc7raw_vecNtB5_11RawVecInner16with_capacity_inCs68MIsFmw01O_12evidence_lab.exit: ; preds = %bb10.i, %bb18.i
  %_4.i.sroa.4.0 = phi i64 [ %capacity, %bb10.i ], [ 0, %bb18.i ], !dbg !89
  %_4.i.sroa.9.0 = phi i64 [ %3, %bb10.i ], [ 8, %bb18.i ]
  %4 = inttoptr i64 %_4.i.sroa.9.0 to ptr, !dbg !90
  %_7.i = icmp samesign ule i64 %capacity, %_4.i.sroa.4.0, !dbg !91
  tail call void @llvm.assume(i1 %_7.i), !dbg !95
  store i64 %_4.i.sroa.4.0, ptr %_0, align 8, !dbg !100
  %5 = getelementptr inbounds nuw i8, ptr %_0, i64 8, !dbg !100
  store ptr %4, ptr %5, align 8, !dbg !100
  %6 = getelementptr inbounds nuw i8, ptr %_0, i64 16, !dbg !100
  store i64 0, ptr %6, align 8, !dbg !100
  ret void, !dbg !101
}

; <alloc::vec::Vec<f64> as core::slice::sort::stable::BufGuard<f64>>::as_uninit_slice_mut
; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: read) uwtable
define hidden { ptr, i64 } @_RNvXs8_NtCs6zY7rJBZy9D_5alloc5sliceINtNtB7_3vec3VecdEINtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6stable8BufGuarddE19as_uninit_slice_mutCs68MIsFmw01O_12evidence_lab(ptr noalias nofree noundef readonly align 8 captures(none) dereferenceable(24) %self) unnamed_addr #1 !dbg !102 !guid !103 {
start:
  %0 = getelementptr inbounds nuw i8, ptr %self, i64 8, !dbg !104
  %_10 = load ptr, ptr %0, align 8, !dbg !104, !nonnull !16, !noundef !16
  %1 = getelementptr inbounds nuw i8, ptr %self, i64 16, !dbg !115
  %count = load i64, ptr %1, align 8, !dbg !115, !noundef !16
  %_3 = getelementptr inbounds nuw [8 x i8], ptr %_10, i64 %count, !dbg !116
  %self1 = load i64, ptr %self, align 8, !dbg !123, !range !128, !noundef !16
  %len = sub i64 %self1, %count, !dbg !129
  %2 = insertvalue { ptr, i64 } poison, ptr %_3, 0, !dbg !130
  %3 = insertvalue { ptr, i64 } %2, i64 %len, 1, !dbg !130
  ret { ptr, i64 } %3, !dbg !130
}

; <alloc::vec::Vec<f64> as core::ops::drop::Drop>::drop
; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(none) uwtable
define hidden void @_RNvXsp_NtCs6zY7rJBZy9D_5alloc3vecINtB5_3VecdENtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4dropCs68MIsFmw01O_12evidence_lab(ptr noalias nofree noundef readnone align 8 captures(none) dereferenceable(24) %self) unnamed_addr #2 !dbg !131 !guid !133 {
start:
  ret void, !dbg !134
}

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(inaccessiblemem: write)
declare void @llvm.assume(i1 noundef) #3

; alloc::raw_vec::handle_error
; Function Attrs: cold minsize noreturn optsize uwtable
declare void @_RNvNtCs6zY7rJBZy9D_5alloc7raw_vec12handle_error(i64 noundef range(i64 0, -9223372036854775807), i64) unnamed_addr #4

; Function Attrs: nounwind uwtable
declare noundef range(i32 0, 10) i32 @rust_eh_personality(i32 noundef, i32 noundef, i64 noundef, ptr noundef, ptr noundef) unnamed_addr #5

; __rustc::__rust_no_alloc_shim_is_unstable_v2
; Function Attrs: nounwind uwtable
declare void @_RNvCsdtSMxSA38aw_7___rustc35___rust_no_alloc_shim_is_unstable_v2() unnamed_addr #5

; __rustc::__rust_alloc
; Function Attrs: nounwind allockind("alloc,uninitialized,aligned") allocsize(0) uwtable
declare noalias noundef ptr @_RNvCsdtSMxSA38aw_7___rustc12___rust_alloc(i64 noundef, i64 allocalign noundef range(i64 1, -9223372036854775807)) unnamed_addr #6

attributes #0 = { uwtable "frame-pointer"="non-leaf" "probe-stack"="inline-asm" "target-cpu"="apple-m1" }
attributes #1 = { mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: read) uwtable "frame-pointer"="non-leaf" "probe-stack"="inline-asm" "target-cpu"="apple-m1" }
attributes #2 = { mustprogress nofree norecurse nosync nounwind willreturn memory(none) uwtable "frame-pointer"="non-leaf" "probe-stack"="inline-asm" "target-cpu"="apple-m1" }
attributes #3 = { nocallback nofree nosync nounwind willreturn memory(inaccessiblemem: write) }
attributes #4 = { cold minsize noreturn optsize uwtable "frame-pointer"="non-leaf" "probe-stack"="inline-asm" "target-cpu"="apple-m1" }
attributes #5 = { nounwind uwtable "frame-pointer"="non-leaf" "probe-stack"="inline-asm" "target-cpu"="apple-m1" }
attributes #6 = { nounwind allockind("alloc,uninitialized,aligned") allocsize(0) uwtable "alloc-family"="__rust_alloc" "alloc-variant-zeroed"="_RNvCsdtSMxSA38aw_7___rustc19___rust_alloc_zeroed" "frame-pointer"="non-leaf" "probe-stack"="inline-asm" "target-cpu"="apple-m1" }
attributes #7 = { nounwind }
attributes #8 = { noreturn }

!llvm.module.flags = !{!0, !1, !2, !3, !4}
!llvm.ident = !{!5}
!llvm.dbg.cu = !{!6, !8}

!0 = !{i32 8, !"PIC Level", i32 2}
!1 = !{i32 7, !"uwtable", i32 2}
!2 = !{i32 7, !"frame-pointer", i32 1}
!3 = !{i32 7, !"Dwarf Version", i32 4}
!4 = !{i32 2, !"Debug Info Version", i32 3}
!5 = !{!"rustc version 1.99.0 (b940084d7 2026-09-28)"}
!6 = distinct !DICompileUnit(language: DW_LANG_Rust, file: !7, producer: "clang LLVM (rustc version 1.99.0 (b940084d7 2026-09-28))", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, splitDebugInlining: false, nameTableKind: None)
!7 = !DIFile(filename: "src/lib.rs/@/evidence_lab.4789476f54c908b2-cgu.08", directory: "/Users/juanwang/Desktop/tutorials/cpp-rust/bench/evidence-lab")
!8 = distinct !DICompileUnit(language: DW_LANG_Rust, file: !9, producer: "clang LLVM (rustc version 1.99.0 (b940084d7 2026-09-28))", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, splitDebugInlining: false, nameTableKind: None)
!9 = !DIFile(filename: "src/lib.rs/@/evidence_lab.4789476f54c908b2-cgu.05", directory: "/Users/juanwang/Desktop/tutorials/cpp-rust/bench/evidence-lab")
!10 = distinct !DISubprogram(name: "with_capacity<f64>", linkageName: "_RNvXs8_NtCs6zY7rJBZy9D_5alloc5sliceINtNtB7_3vec3VecdEINtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6stable8BufGuarddE13with_capacityCs68MIsFmw01O_12evidence_lab", scope: !12, file: !11, line: 863, type: !15, scopeLine: 863, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !16)
!11 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/alloc/src/slice.rs", directory: "", checksumkind: CSK_MD5, checksum: "8e7bce5d617a4e88f7bdb700dff9d669")
!12 = !DINamespace(name: "{impl#10}", scope: !13)
!13 = !DINamespace(name: "slice", scope: !14)
!14 = !DINamespace(name: "alloc", scope: null)
!15 = !DISubroutineType(types: !16)
!16 = !{}
!17 = !{i64 -1661877496342761299}
!18 = !DILocation(line: 3212, column: 26, scope: !19, inlinedAt: !24)
!19 = distinct !DISubprogram(name: "overflowing_mul", linkageName: "_RNvMs9_NtCsjIpoRzUjyHQ_4core3numj15overflowing_mul", scope: !21, file: !20, line: 3211, type: !15, scopeLine: 3211, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !8, templateParams: !16)
!20 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/num/uint_macros.rs", directory: "", checksumkind: CSK_MD5, checksum: "861b08c040dcb8e56aa7d23dacf541ca")
!21 = !DINamespace(name: "{impl#11}", scope: !22)
!22 = !DINamespace(name: "num", scope: !23)
!23 = !DINamespace(name: "core", scope: null)
!24 = distinct !DILocation(line: 1330, column: 31, scope: !25, inlinedAt: !26)
!25 = distinct !DISubprogram(name: "checked_mul", linkageName: "_RNvMs9_NtCsjIpoRzUjyHQ_4core3numj11checked_mul", scope: !21, file: !20, line: 1329, type: !15, scopeLine: 1329, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !8, templateParams: !16)
!26 = distinct !DILocation(line: 533, column: 39, scope: !27, inlinedAt: !33)
!27 = distinct !DILexicalBlock(scope: !29, file: !28, line: 533, column: 54)
!28 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/alloc/layout.rs", directory: "", checksumkind: CSK_MD5, checksum: "044b929685d8564035fcb902806519e4")
!29 = distinct !DISubprogram(name: "repeat_packed", linkageName: "_RNvMNtNtCsjIpoRzUjyHQ_4core5alloc6layoutNtB2_6Layout13repeat_packed", scope: !30, file: !28, line: 532, type: !15, scopeLine: 532, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !8, templateParams: !16)
!30 = !DINamespace(name: "Layout", scope: !31)
!31 = !DINamespace(name: "layout", scope: !32)
!32 = !DINamespace(name: "alloc", scope: !23)
!33 = distinct !DILocation(line: 901, column: 17, scope: !34, inlinedAt: !37)
!34 = distinct !DISubprogram(name: "layout_array", linkageName: "_RNvNtCs6zY7rJBZy9D_5alloc7raw_vec12layout_array", scope: !36, file: !35, line: 896, type: !15, scopeLine: 896, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !8, templateParams: !16)
!35 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/alloc/src/raw_vec/mod.rs", directory: "", checksumkind: CSK_MD5, checksum: "acd4dae5e7aaaaf06aa0208ebac37ff5")
!36 = !DINamespace(name: "raw_vec", scope: !14)
!37 = distinct !DILocation(line: 455, column: 28, scope: !38, inlinedAt: !40)
!38 = distinct !DISubprogram(name: "try_allocate_in<alloc::alloc::Global>", linkageName: "_RNvMs5_NtCs6zY7rJBZy9D_5alloc7raw_vecNtB5_11RawVecInner15try_allocate_inCs68MIsFmw01O_12evidence_lab", scope: !39, file: !35, line: 447, type: !15, scopeLine: 447, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !8, templateParams: !16)
!39 = !DINamespace(name: "RawVecInner", scope: !36)
!40 = distinct !DILocation(line: 435, column: 15, scope: !41, inlinedAt: !42)
!41 = distinct !DISubprogram(name: "with_capacity_in<alloc::alloc::Global>", linkageName: "_RNvMs5_NtCs6zY7rJBZy9D_5alloc7raw_vecNtB5_11RawVecInner16with_capacity_inCs68MIsFmw01O_12evidence_lab", scope: !39, file: !35, line: 434, type: !15, scopeLine: 434, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !16)
!42 = distinct !DILocation(line: 177, column: 20, scope: !43, inlinedAt: !45)
!43 = distinct !DISubprogram(name: "with_capacity_in<f64, alloc::alloc::Global>", linkageName: "_RNvMs4_NtCs6zY7rJBZy9D_5alloc7raw_vecINtB5_6RawVecdE16with_capacity_inCs68MIsFmw01O_12evidence_lab", scope: !44, file: !35, line: 175, type: !15, scopeLine: 175, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !16)
!44 = !DINamespace(name: "RawVec", scope: !36)
!45 = !DILocation(line: 969, column: 20, scope: !46, inlinedAt: !50)
!46 = distinct !DISubprogram(name: "with_capacity_in<f64, alloc::alloc::Global>", linkageName: "_RNvMsG_NtCs6zY7rJBZy9D_5alloc3vecINtB5_3VecdE16with_capacity_inCs68MIsFmw01O_12evidence_lab", scope: !48, file: !47, line: 968, type: !15, scopeLine: 968, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !16)
!47 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/alloc/src/vec/mod.rs", directory: "", checksumkind: CSK_MD5, checksum: "a93d3a7d4a1d55c9887c540882057a4f")
!48 = !DINamespace(name: "Vec", scope: !49)
!49 = !DINamespace(name: "vec", scope: !14)
!50 = !DILocation(line: 522, column: 9, scope: !51, inlinedAt: !52)
!51 = distinct !DISubprogram(name: "with_capacity<f64>", linkageName: "_RNvMNtCs6zY7rJBZy9D_5alloc3vecINtB2_3VecdE13with_capacityCs68MIsFmw01O_12evidence_lab", scope: !48, file: !47, line: 521, type: !15, scopeLine: 521, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !16)
!52 = !DILocation(line: 864, column: 9, scope: !10)
!53 = !DILocation(line: 478, column: 8, scope: !54, inlinedAt: !57)
!54 = distinct !DISubprogram(name: "unlikely", linkageName: "_RNvNtCsjIpoRzUjyHQ_4core10intrinsics8unlikely", scope: !56, file: !55, line: 477, type: !15, scopeLine: 477, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !8, templateParams: !16)
!55 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/intrinsics/mod.rs", directory: "", checksumkind: CSK_MD5, checksum: "95f29c0132b18aca34fbfb798048cc68")
!56 = !DINamespace(name: "intrinsics", scope: !23)
!57 = distinct !DILocation(line: 1331, column: 16, scope: !58, inlinedAt: !26)
!58 = distinct !DILexicalBlock(scope: !25, file: !20, line: 1330, column: 13)
!59 = !{!"branch_weights", i32 2002, i32 2000}
!60 = !DILocation(line: 461, column: 12, scope: !61, inlinedAt: !40)
!61 = distinct !DILexicalBlock(scope: !38, file: !35, line: 455, column: 9)
!62 = !DILocation(line: 0, scope: !61, inlinedAt: !40)
!63 = !{!64}
!64 = distinct !{!64, !65, !"_RNvMs5_NtCs6zY7rJBZy9D_5alloc7raw_vecNtB5_11RawVecInner15try_allocate_inCs68MIsFmw01O_12evidence_lab: %_0"}
!65 = distinct !{!65, !"_RNvMs5_NtCs6zY7rJBZy9D_5alloc7raw_vecNtB5_11RawVecInner15try_allocate_inCs68MIsFmw01O_12evidence_lab"}
!66 = !DILocation(line: 130, column: 9, scope: !67, inlinedAt: !70)
!67 = distinct !DISubprogram(name: "alloc", linkageName: "_RNvNtCs6zY7rJBZy9D_5alloc5alloc5alloc", scope: !69, file: !68, line: 124, type: !15, scopeLine: 124, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !8, templateParams: !16)
!68 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/alloc/src/alloc.rs", directory: "", checksumkind: CSK_MD5, checksum: "87b4d0ba26e1dfe94542079de6981d97")
!69 = !DINamespace(name: "alloc", scope: !14)
!70 = distinct !DILocation(line: 302, column: 73, scope: !71, inlinedAt: !74)
!71 = distinct !DILexicalBlock(scope: !72, file: !68, line: 301, column: 13)
!72 = distinct !DISubprogram(name: "alloc_impl_runtime", linkageName: "_RNvMs0_NtCs6zY7rJBZy9D_5alloc5allocNtB5_6Global18alloc_impl_runtime", scope: !73, file: !68, line: 297, type: !15, scopeLine: 297, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !8, templateParams: !16)
!73 = !DINamespace(name: "Global", scope: !69)
!74 = distinct !DILocation(line: 424, column: 9, scope: !75, inlinedAt: !76)
!75 = distinct !DISubprogram(name: "alloc_impl", linkageName: "_RNvMs0_NtCs6zY7rJBZy9D_5alloc5allocNtB5_6Global10alloc_impl", scope: !73, file: !68, line: 423, type: !15, scopeLine: 423, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !8, templateParams: !16)
!76 = distinct !DILocation(line: 541, column: 14, scope: !77, inlinedAt: !80)
!77 = distinct !DISubprogram(name: "allocate", linkageName: "_RNvXs1_NtCs6zY7rJBZy9D_5alloc5allocNtB5_6GlobalNtNtCsjIpoRzUjyHQ_4core5alloc9Allocator8allocate", scope: !78, file: !68, line: 540, type: !79, scopeLine: 540, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !8, templateParams: !16)
!78 = !DINamespace(name: "{impl#3}", scope: !69)
!79 = !DISubroutineType(cc: DW_CC_nocall, types: !16)
!80 = distinct !DILocation(line: 466, column: 47, scope: !61, inlinedAt: !40)
!81 = !DILocation(line: 470, column: 25, scope: !82, inlinedAt: !40)
!82 = distinct !DILexicalBlock(scope: !61, file: !35, line: 465, column: 9)
!83 = !DILocation(line: 470, column: 19, scope: !82, inlinedAt: !40)
!84 = !DILocation(line: 478, column: 9, scope: !85, inlinedAt: !40)
!85 = distinct !DILexicalBlock(scope: !82, file: !35, line: 470, column: 9)
!86 = !DILocation(line: 483, column: 5, scope: !38, inlinedAt: !40)
!87 = !DILocation(line: 443, column: 25, scope: !88, inlinedAt: !42)
!88 = distinct !DILexicalBlock(scope: !41, file: !35, line: 443, column: 13)
!89 = !DILocation(line: 0, scope: !38, inlinedAt: !40)
!90 = !DILocation(line: 436, column: 16, scope: !41, inlinedAt: !42)
!91 = !DILocation(line: 764, column: 9, scope: !92, inlinedAt: !93)
!92 = distinct !DISubprogram(name: "needs_to_grow<alloc::alloc::Global>", linkageName: "_RNvMs2_NtCs6zY7rJBZy9D_5alloc7raw_vecNtB5_11RawVecInner13needs_to_growCs68MIsFmw01O_12evidence_lab", scope: !39, file: !35, line: 763, type: !15, scopeLine: 763, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !16)
!93 = distinct !DILocation(line: 439, column: 50, scope: !94, inlinedAt: !42)
!94 = distinct !DILexicalBlock(scope: !41, file: !35, line: 436, column: 13)
!95 = !DILocation(line: 210, column: 9, scope: !96, inlinedAt: !99)
!96 = distinct !DISubprogram(name: "assert_unchecked", linkageName: "_RNvNtCsjIpoRzUjyHQ_4core4hint16assert_unchecked", scope: !98, file: !97, line: 202, type: !15, scopeLine: 202, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !16)
!97 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/hint.rs", directory: "", checksumkind: CSK_MD5, checksum: "720ecb12dbf1a304509abd161627e0e2")
!98 = !DINamespace(name: "hint", scope: !23)
!99 = distinct !DILocation(line: 439, column: 21, scope: !94, inlinedAt: !42)
!100 = !DILocation(line: 969, column: 9, scope: !46, inlinedAt: !50)
!101 = !DILocation(line: 865, column: 6, scope: !10)
!102 = distinct !DISubprogram(name: "as_uninit_slice_mut<f64>", linkageName: "_RNvXs8_NtCs6zY7rJBZy9D_5alloc5sliceINtNtB7_3vec3VecdEINtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6stable8BufGuarddE19as_uninit_slice_mutCs68MIsFmw01O_12evidence_lab", scope: !12, file: !11, line: 867, type: !15, scopeLine: 867, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !16)
!103 = !{i64 -3561237562055009784}
!104 = !DILocation(line: 611, column: 9, scope: !105, inlinedAt: !106)
!105 = distinct !DISubprogram(name: "non_null<alloc::alloc::Global, f64>", linkageName: "_RINvMs2_NtCs6zY7rJBZy9D_5alloc7raw_vecNtB6_11RawVecInner8non_nulldECs68MIsFmw01O_12evidence_lab", scope: !39, file: !35, line: 610, type: !15, scopeLine: 610, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !16)
!106 = !DILocation(line: 606, column: 14, scope: !107, inlinedAt: !108)
!107 = distinct !DISubprogram(name: "ptr<alloc::alloc::Global, f64>", linkageName: "_RINvMs2_NtCs6zY7rJBZy9D_5alloc7raw_vecNtB6_11RawVecInner3ptrdECs68MIsFmw01O_12evidence_lab", scope: !39, file: !35, line: 605, type: !15, scopeLine: 605, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !16)
!108 = !DILocation(line: 296, column: 20, scope: !109, inlinedAt: !110)
!109 = distinct !DISubprogram(name: "ptr<f64, alloc::alloc::Global>", linkageName: "_RNvMs0_NtCs6zY7rJBZy9D_5alloc7raw_vecINtB5_6RawVecdE3ptrCs68MIsFmw01O_12evidence_lab", scope: !44, file: !35, line: 295, type: !15, scopeLine: 295, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !16)
!110 = !DILocation(line: 2053, column: 18, scope: !111, inlinedAt: !112)
!111 = distinct !DISubprogram(name: "as_mut_ptr<f64, alloc::alloc::Global>", linkageName: "_RNvMs_NtCs6zY7rJBZy9D_5alloc3vecINtB4_3VecdE10as_mut_ptrCs68MIsFmw01O_12evidence_lab", scope: !48, file: !47, line: 2050, type: !15, scopeLine: 2050, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !16)
!112 = !DILocation(line: 3306, column: 22, scope: !113, inlinedAt: !114)
!113 = distinct !DISubprogram(name: "spare_capacity_mut<f64, alloc::alloc::Global>", linkageName: "_RNvMs_NtCs6zY7rJBZy9D_5alloc3vecINtB4_3VecdE18spare_capacity_mutCs68MIsFmw01O_12evidence_lab", scope: !48, file: !47, line: 3300, type: !15, scopeLine: 3300, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !16)
!114 = !DILocation(line: 868, column: 14, scope: !102)
!115 = !DILocation(line: 3306, column: 39, scope: !113, inlinedAt: !114)
!116 = !DILocation(line: 970, column: 18, scope: !117, inlinedAt: !122)
!117 = distinct !DISubprogram(name: "add<f64>", linkageName: "_RNvMNtNtCsjIpoRzUjyHQ_4core3ptr7mut_ptrOd3addCs68MIsFmw01O_12evidence_lab", scope: !119, file: !118, line: 936, type: !15, scopeLine: 936, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !16)
!118 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/ptr/mut_ptr.rs", directory: "", checksumkind: CSK_MD5, checksum: "0a9a444e8d978ea2fd7622da49f95724")
!119 = !DINamespace(name: "{impl#0}", scope: !120)
!120 = !DINamespace(name: "mut_ptr", scope: !121)
!121 = !DINamespace(name: "ptr", scope: !23)
!122 = !DILocation(line: 3306, column: 35, scope: !113, inlinedAt: !114)
!123 = !DILocation(line: 616, column: 49, scope: !124, inlinedAt: !125)
!124 = distinct !DISubprogram(name: "capacity<alloc::alloc::Global>", linkageName: "_RNvMs2_NtCs6zY7rJBZy9D_5alloc7raw_vecNtB5_11RawVecInner8capacityCs68MIsFmw01O_12evidence_lab", scope: !39, file: !35, line: 615, type: !15, scopeLine: 615, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !16)
!125 = !DILocation(line: 309, column: 20, scope: !126, inlinedAt: !127)
!126 = distinct !DISubprogram(name: "capacity<f64, alloc::alloc::Global>", linkageName: "_RNvMs0_NtCs6zY7rJBZy9D_5alloc7raw_vecINtB5_6RawVecdE8capacityCs68MIsFmw01O_12evidence_lab", scope: !44, file: !35, line: 308, type: !15, scopeLine: 308, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !16)
!127 = !DILocation(line: 3307, column: 26, scope: !113, inlinedAt: !114)
!128 = !{i64 0, i64 -9223372036854775808}
!129 = !DILocation(line: 3307, column: 17, scope: !113, inlinedAt: !114)
!130 = !DILocation(line: 869, column: 6, scope: !102)
!131 = distinct !DISubprogram(name: "drop<f64, alloc::alloc::Global>", linkageName: "_RNvXsp_NtCs6zY7rJBZy9D_5alloc3vecINtB5_3VecdENtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4dropCs68MIsFmw01O_12evidence_lab", scope: !132, file: !47, line: 4353, type: !15, scopeLine: 4353, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !16)
!132 = !DINamespace(name: "{impl#27}", scope: !49)
!133 = !{i64 -276995154676903100}
!134 = !DILocation(line: 4361, column: 6, scope: !131)
