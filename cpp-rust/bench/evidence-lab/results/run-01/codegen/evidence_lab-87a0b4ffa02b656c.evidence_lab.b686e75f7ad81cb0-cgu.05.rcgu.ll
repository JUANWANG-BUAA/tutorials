; ModuleID = 'evidence_lab.b686e75f7ad81cb0-cgu.05'
source_filename = "evidence_lab.b686e75f7ad81cb0-cgu.05"
target datalayout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx11.0.0"

; <alloc::raw_vec::RawVecInner>::try_allocate_in
; Function Attrs: nounwind uwtable
define hidden void @_RNvMs5_NtCs6zY7rJBZy9D_5alloc7raw_vecNtB5_11RawVecInner15try_allocate_inCsfFAnx7WYh7o_12evidence_lab(ptr dead_on_unwind noalias nofree noundef writable writeonly sret([24 x i8]) align 8 captures(none) dereferenceable(24) initializes((0, 16)) %_0, i64 noundef %capacity, i1 noundef zeroext %init, i64 noundef range(i64 1, -9223372036854775807) %elem_layout.0, i64 noundef %elem_layout.1) unnamed_addr #0 personality ptr @rust_eh_personality !dbg !8 !guid !15 {
start:
  %0 = tail call { i64, i1 } @llvm.umul.with.overflow.i64(i64 %elem_layout.1, i64 %capacity), !dbg !16
  %_34.0 = extractvalue { i64, i1 } %0, 0, !dbg !16
  %_34.1 = extractvalue { i64, i1 } %0, 1, !dbg !16
  %_41 = sub nuw i64 -9223372036854775808, %elem_layout.0
  %_39.not = icmp ugt i64 %_34.0, %_41
  %or.cond = select i1 %_34.1, i1 true, i1 %_39.not, !dbg !34, !prof !40
  br i1 %or.cond, label %bb20, label %bb18, !dbg !34, !prof !40

bb18:                                             ; preds = %start
  %1 = icmp eq i64 %_34.0, 0, !dbg !41
  br i1 %1, label %bb2, label %bb3, !dbg !41

bb20:                                             ; preds = %start
  %2 = getelementptr inbounds nuw i8, ptr %_0, i64 8, !dbg !43
  store i64 0, ptr %2, align 8, !dbg !43
  br label %bb11, !dbg !44

bb2:                                              ; preds = %bb18
  %_45 = inttoptr i64 %elem_layout.0 to ptr, !dbg !47
  %3 = getelementptr inbounds nuw i8, ptr %_0, i64 8, !dbg !56
  store i64 0, ptr %3, align 8, !dbg !56
  %4 = getelementptr inbounds nuw i8, ptr %_0, i64 16, !dbg !56
  store ptr %_45, ptr %4, align 8, !dbg !56
  br label %bb11, !dbg !57

bb3:                                              ; preds = %bb18
; call __rustc::__rust_no_alloc_shim_is_unstable_v2
  tail call void @_RNvCsdtSMxSA38aw_7___rustc35___rust_no_alloc_shim_is_unstable_v2() #6, !dbg !58
  br i1 %init, label %bb4, label %bb5, !dbg !59

bb11:                                             ; preds = %bb10, %bb9, %bb2, %bb20
  %.sink = phi i64 [ 1, %bb9 ], [ 1, %bb20 ], [ 0, %bb10 ], [ 0, %bb2 ]
  store i64 %.sink, ptr %_0, align 8, !dbg !60
  ret void, !dbg !61

bb4:                                              ; preds = %bb3
; call __rustc::__rust_alloc_zeroed
  %5 = tail call noundef ptr @_RNvCsdtSMxSA38aw_7___rustc19___rust_alloc_zeroed(i64 noundef range(i64 1, -9223372036854775808) %_34.0, i64 noundef range(i64 1, -9223372036854775807) %elem_layout.0) #6, !dbg !62
  br label %bb8, !dbg !77

bb5:                                              ; preds = %bb3
; call __rustc::__rust_alloc
  %6 = tail call noundef ptr @_RNvCsdtSMxSA38aw_7___rustc12___rust_alloc(i64 noundef range(i64 1, -9223372036854775808) %_34.0, i64 noundef range(i64 1, -9223372036854775807) %elem_layout.0) #6, !dbg !78
  br label %bb8, !dbg !86

bb8:                                              ; preds = %bb5, %bb4
  %.pn4 = phi ptr [ %5, %bb4 ], [ %6, %bb5 ]
  %7 = icmp eq ptr %.pn4, null, !dbg !87
  br i1 %7, label %bb9, label %bb10, !dbg !89

bb9:                                              ; preds = %bb8
  %8 = getelementptr inbounds nuw i8, ptr %_0, i64 8, !dbg !90
  store i64 %elem_layout.0, ptr %8, align 8, !dbg !90
  %9 = getelementptr inbounds nuw i8, ptr %_0, i64 16, !dbg !90
  store i64 %_34.0, ptr %9, align 8, !dbg !90
  br label %bb11, !dbg !91

bb10:                                             ; preds = %bb8
  %10 = icmp sgt i64 %capacity, -1, !dbg !93
  tail call void @llvm.assume(i1 %10), !dbg !93
  %11 = getelementptr inbounds nuw i8, ptr %_0, i64 8, !dbg !100
  store i64 %capacity, ptr %11, align 8, !dbg !100
  %12 = getelementptr inbounds nuw i8, ptr %_0, i64 16, !dbg !100
  store ptr %.pn4, ptr %12, align 8, !dbg !100
  br label %bb11, !dbg !57
}

; <alloc::raw_vec::RawVec<f64> as core::ops::drop::Drop>::drop
; Function Attrs: nounwind uwtable
define hidden void @_RNvXs1_NtCs6zY7rJBZy9D_5alloc7raw_vecINtB5_6RawVecdENtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4dropCsfFAnx7WYh7o_12evidence_lab(ptr noalias nofree noundef readonly align 8 captures(none) dereferenceable(16) %self) unnamed_addr #0 !dbg !101 !guid !103 {
start:
  %self.val = load i64, ptr %self, align 8, !dbg !104, !range !105, !noundef !14
  %0 = icmp eq i64 %self.val, 0, !dbg !106
  br i1 %0, label %_RNvMs3_NtCs6zY7rJBZy9D_5alloc7raw_vecNtB5_11RawVecInner10deallocateCsfFAnx7WYh7o_12evidence_lab.exit, label %bb2.i, !dbg !106

bb2.i:                                            ; preds = %start
  %1 = getelementptr inbounds nuw i8, ptr %self, i64 8, !dbg !104
  %self.val1 = load ptr, ptr %1, align 8, !dbg !104, !nonnull !14, !noundef !14
  %alloc_size.i.i = shl nuw i64 %self.val, 3, !dbg !112
; call __rustc::__rust_dealloc
  tail call void @_RNvCsdtSMxSA38aw_7___rustc14___rust_dealloc(ptr noundef nonnull %self.val1, i64 noundef %alloc_size.i.i, i64 noundef range(i64 1, -9223372036854775807) 8) #6, !dbg !115
  br label %_RNvMs3_NtCs6zY7rJBZy9D_5alloc7raw_vecNtB5_11RawVecInner10deallocateCsfFAnx7WYh7o_12evidence_lab.exit, !dbg !124

_RNvMs3_NtCs6zY7rJBZy9D_5alloc7raw_vecNtB5_11RawVecInner10deallocateCsfFAnx7WYh7o_12evidence_lab.exit: ; preds = %bb2.i, %start
  ret void, !dbg !125
}

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(inaccessiblemem: write)
declare void @llvm.assume(i1 noundef) #1

; __rustc::__rust_no_alloc_shim_is_unstable_v2
; Function Attrs: nounwind uwtable
declare void @_RNvCsdtSMxSA38aw_7___rustc35___rust_no_alloc_shim_is_unstable_v2() unnamed_addr #0

; __rustc::__rust_alloc
; Function Attrs: nounwind allockind("alloc,uninitialized,aligned") allocsize(0) uwtable
declare noalias noundef ptr @_RNvCsdtSMxSA38aw_7___rustc12___rust_alloc(i64 noundef, i64 allocalign noundef range(i64 1, -9223372036854775807)) unnamed_addr #2

; __rustc::__rust_alloc_zeroed
; Function Attrs: nounwind allockind("alloc,zeroed,aligned") allocsize(0) uwtable
declare noalias noundef ptr @_RNvCsdtSMxSA38aw_7___rustc19___rust_alloc_zeroed(i64 noundef, i64 allocalign noundef range(i64 1, -9223372036854775807)) unnamed_addr #3

; Function Attrs: nounwind uwtable
declare noundef range(i32 0, 10) i32 @rust_eh_personality(i32 noundef, i32 noundef, i64 noundef, ptr noundef, ptr noundef) unnamed_addr #0

; Function Attrs: nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none)
declare { i64, i1 } @llvm.umul.with.overflow.i64(i64, i64) #4

; __rustc::__rust_dealloc
; Function Attrs: nounwind allockind("free") uwtable
declare void @_RNvCsdtSMxSA38aw_7___rustc14___rust_dealloc(ptr allocptr noundef nonnull captures(address), i64 noundef, i64 noundef range(i64 1, -9223372036854775807)) unnamed_addr #5

attributes #0 = { nounwind uwtable "frame-pointer"="non-leaf" "probe-stack"="inline-asm" "target-cpu"="apple-m1" }
attributes #1 = { nocallback nofree nosync nounwind willreturn memory(inaccessiblemem: write) }
attributes #2 = { nounwind allockind("alloc,uninitialized,aligned") allocsize(0) uwtable "alloc-family"="__rust_alloc" "alloc-variant-zeroed"="_RNvCsdtSMxSA38aw_7___rustc19___rust_alloc_zeroed" "frame-pointer"="non-leaf" "probe-stack"="inline-asm" "target-cpu"="apple-m1" }
attributes #3 = { nounwind allockind("alloc,zeroed,aligned") allocsize(0) uwtable "alloc-family"="__rust_alloc" "frame-pointer"="non-leaf" "probe-stack"="inline-asm" "target-cpu"="apple-m1" }
attributes #4 = { nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none) }
attributes #5 = { nounwind allockind("free") uwtable "alloc-family"="__rust_alloc" "frame-pointer"="non-leaf" "probe-stack"="inline-asm" "target-cpu"="apple-m1" }
attributes #6 = { nounwind }

!llvm.module.flags = !{!0, !1, !2, !3, !4}
!llvm.ident = !{!5}
!llvm.dbg.cu = !{!6}

!0 = !{i32 8, !"PIC Level", i32 2}
!1 = !{i32 7, !"uwtable", i32 2}
!2 = !{i32 7, !"frame-pointer", i32 1}
!3 = !{i32 7, !"Dwarf Version", i32 4}
!4 = !{i32 2, !"Debug Info Version", i32 3}
!5 = !{!"rustc version 1.99.0 (b940084d7 2026-09-28)"}
!6 = distinct !DICompileUnit(language: DW_LANG_Rust, file: !7, producer: "clang LLVM (rustc version 1.99.0 (b940084d7 2026-09-28))", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, splitDebugInlining: false, nameTableKind: None)
!7 = !DIFile(filename: "src/lib.rs/@/evidence_lab.b686e75f7ad81cb0-cgu.05", directory: "/Users/juanwang/Desktop/tutorials/cpp-rust/bench/evidence-lab")
!8 = distinct !DISubprogram(name: "try_allocate_in<alloc::alloc::Global>", linkageName: "_RNvMs5_NtCs6zY7rJBZy9D_5alloc7raw_vecNtB5_11RawVecInner15try_allocate_inCsfFAnx7WYh7o_12evidence_lab", scope: !10, file: !9, line: 447, type: !13, scopeLine: 447, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !14)
!9 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/alloc/src/raw_vec/mod.rs", directory: "", checksumkind: CSK_MD5, checksum: "acd4dae5e7aaaaf06aa0208ebac37ff5")
!10 = !DINamespace(name: "RawVecInner", scope: !11)
!11 = !DINamespace(name: "raw_vec", scope: !12)
!12 = !DINamespace(name: "alloc", scope: null)
!13 = !DISubroutineType(types: !14)
!14 = !{}
!15 = !{i64 -6834197898747889639}
!16 = !DILocation(line: 3212, column: 26, scope: !17, inlinedAt: !22)
!17 = distinct !DISubprogram(name: "overflowing_mul", linkageName: "_RNvMs9_NtCsjIpoRzUjyHQ_4core3numj15overflowing_mul", scope: !19, file: !18, line: 3211, type: !13, scopeLine: 3211, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !14)
!18 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/num/uint_macros.rs", directory: "", checksumkind: CSK_MD5, checksum: "861b08c040dcb8e56aa7d23dacf541ca")
!19 = !DINamespace(name: "{impl#11}", scope: !20)
!20 = !DINamespace(name: "num", scope: !21)
!21 = !DINamespace(name: "core", scope: null)
!22 = !DILocation(line: 1330, column: 31, scope: !23, inlinedAt: !24)
!23 = distinct !DISubprogram(name: "checked_mul", linkageName: "_RNvMs9_NtCsjIpoRzUjyHQ_4core3numj11checked_mul", scope: !19, file: !18, line: 1329, type: !13, scopeLine: 1329, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !14)
!24 = !DILocation(line: 533, column: 39, scope: !25, inlinedAt: !31)
!25 = distinct !DILexicalBlock(scope: !27, file: !26, line: 533, column: 54)
!26 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/alloc/layout.rs", directory: "", checksumkind: CSK_MD5, checksum: "044b929685d8564035fcb902806519e4")
!27 = distinct !DISubprogram(name: "repeat_packed", linkageName: "_RNvMNtNtCsjIpoRzUjyHQ_4core5alloc6layoutNtB2_6Layout13repeat_packed", scope: !28, file: !26, line: 532, type: !13, scopeLine: 532, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !14)
!28 = !DINamespace(name: "Layout", scope: !29)
!29 = !DINamespace(name: "layout", scope: !30)
!30 = !DINamespace(name: "alloc", scope: !21)
!31 = !DILocation(line: 901, column: 17, scope: !32, inlinedAt: !33)
!32 = distinct !DISubprogram(name: "layout_array", linkageName: "_RNvNtCs6zY7rJBZy9D_5alloc7raw_vec12layout_array", scope: !11, file: !9, line: 896, type: !13, scopeLine: 896, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !14)
!33 = !DILocation(line: 455, column: 28, scope: !8)
!34 = !DILocation(line: 478, column: 8, scope: !35, inlinedAt: !38)
!35 = distinct !DISubprogram(name: "unlikely", linkageName: "_RNvNtCsjIpoRzUjyHQ_4core10intrinsics8unlikely", scope: !37, file: !36, line: 477, type: !13, scopeLine: 477, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !14)
!36 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/intrinsics/mod.rs", directory: "", checksumkind: CSK_MD5, checksum: "95f29c0132b18aca34fbfb798048cc68")
!37 = !DINamespace(name: "intrinsics", scope: !21)
!38 = !DILocation(line: 1331, column: 16, scope: !39, inlinedAt: !24)
!39 = distinct !DILexicalBlock(scope: !23, file: !18, line: 1330, column: 13)
!40 = !{!"branch_weights", i32 2002, i32 2000}
!41 = !DILocation(line: 461, column: 12, scope: !42)
!42 = distinct !DILexicalBlock(scope: !8, file: !9, line: 455, column: 9)
!43 = !DILocation(line: 457, column: 30, scope: !8)
!44 = !DILocation(line: 0, scope: !45)
!45 = !DILexicalBlockFile(scope: !8, file: !46, discriminator: 0)
!46 = !DIFile(filename: "src/lib.rs", directory: "/Users/juanwang/Desktop/tutorials/cpp-rust/bench/evidence-lab", checksumkind: CSK_MD5, checksum: "ac2520682925bb11f829d6faa84c5cca")
!47 = !DILocation(line: 105, column: 18, scope: !48, inlinedAt: !53)
!48 = distinct !DISubprogram(name: "without_provenance<u8>", linkageName: "_RNvMs0_NtNtCsjIpoRzUjyHQ_4core3ptr8non_nullINtB5_7NonNullhE18without_provenanceCsfFAnx7WYh7o_12evidence_lab", scope: !50, file: !49, line: 103, type: !13, scopeLine: 103, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !14)
!49 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/ptr/non_null.rs", directory: "", checksumkind: CSK_MD5, checksum: "accc742d53c125b723531f778524eec8")
!50 = !DINamespace(name: "NonNull", scope: !51)
!51 = !DINamespace(name: "non_null", scope: !52)
!52 = !DINamespace(name: "ptr", scope: !21)
!53 = !DILocation(line: 570, column: 41, scope: !54, inlinedAt: !55)
!54 = distinct !DISubprogram(name: "new_in<alloc::alloc::Global>", linkageName: "_RNvMs2_NtCs6zY7rJBZy9D_5alloc7raw_vecNtB5_11RawVecInner6new_inCsfFAnx7WYh7o_12evidence_lab", scope: !10, file: !9, line: 569, type: !13, scopeLine: 569, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !14)
!55 = !DILocation(line: 462, column: 23, scope: !42)
!56 = !DILocation(line: 462, column: 20, scope: !42)
!57 = !DILocation(line: 483, column: 5, scope: !8)
!58 = !DILocation(line: 0, scope: !42)
!59 = !DILocation(line: 465, column: 22, scope: !42)
!60 = !DILocation(line: 0, scope: !8)
!61 = !DILocation(line: 483, column: 6, scope: !8)
!62 = !DILocation(line: 290, column: 9, scope: !63, inlinedAt: !66)
!63 = distinct !DISubprogram(name: "alloc_zeroed", linkageName: "_RNvNtCs6zY7rJBZy9D_5alloc5alloc12alloc_zeroed", scope: !65, file: !64, line: 284, type: !13, scopeLine: 284, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !14)
!64 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/alloc/src/alloc.rs", directory: "", checksumkind: CSK_MD5, checksum: "87b4d0ba26e1dfe94542079de6981d97")
!65 = !DINamespace(name: "alloc", scope: !12)
!66 = distinct !DILocation(line: 302, column: 43, scope: !67, inlinedAt: !70)
!67 = distinct !DILexicalBlock(scope: !68, file: !64, line: 301, column: 13)
!68 = distinct !DISubprogram(name: "alloc_impl_runtime", linkageName: "_RNvMs0_NtCs6zY7rJBZy9D_5alloc5allocNtB5_6Global18alloc_impl_runtime", scope: !69, file: !64, line: 297, type: !13, scopeLine: 297, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !14)
!69 = !DINamespace(name: "Global", scope: !65)
!70 = distinct !DILocation(line: 424, column: 9, scope: !71, inlinedAt: !72)
!71 = distinct !DISubprogram(name: "alloc_impl", linkageName: "_RNvMs0_NtCs6zY7rJBZy9D_5alloc5allocNtB5_6Global10alloc_impl", scope: !69, file: !64, line: 423, type: !13, scopeLine: 423, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !14)
!72 = distinct !DILocation(line: 547, column: 14, scope: !73, inlinedAt: !76)
!73 = distinct !DISubprogram(name: "allocate_zeroed", linkageName: "_RNvXs1_NtCs6zY7rJBZy9D_5alloc5allocNtB5_6GlobalNtNtCsjIpoRzUjyHQ_4core5alloc9Allocator15allocate_zeroed", scope: !74, file: !64, line: 546, type: !75, scopeLine: 546, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !14)
!74 = !DINamespace(name: "{impl#3}", scope: !65)
!75 = !DISubroutineType(cc: DW_CC_nocall, types: !14)
!76 = distinct !DILocation(line: 468, column: 40, scope: !42)
!77 = !DILocation(line: 468, column: 62, scope: !42)
!78 = !DILocation(line: 130, column: 9, scope: !79, inlinedAt: !80)
!79 = distinct !DISubprogram(name: "alloc", linkageName: "_RNvNtCs6zY7rJBZy9D_5alloc5alloc5alloc", scope: !65, file: !64, line: 124, type: !13, scopeLine: 124, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !14)
!80 = distinct !DILocation(line: 302, column: 73, scope: !67, inlinedAt: !81)
!81 = distinct !DILocation(line: 424, column: 9, scope: !82, inlinedAt: !83)
!82 = distinct !DISubprogram(name: "alloc_impl", linkageName: "_RNvMs0_NtCs6zY7rJBZy9D_5alloc5allocNtB5_6Global10alloc_impl", scope: !69, file: !64, line: 423, type: !13, scopeLine: 423, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !14)
!83 = distinct !DILocation(line: 541, column: 14, scope: !84, inlinedAt: !85)
!84 = distinct !DISubprogram(name: "allocate", linkageName: "_RNvXs1_NtCs6zY7rJBZy9D_5alloc5allocNtB5_6GlobalNtNtCsjIpoRzUjyHQ_4core5alloc9Allocator8allocate", scope: !74, file: !64, line: 540, type: !75, scopeLine: 540, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !14)
!85 = distinct !DILocation(line: 466, column: 47, scope: !42)
!86 = !DILocation(line: 466, column: 62, scope: !42)
!87 = !DILocation(line: 470, column: 25, scope: !88)
!88 = distinct !DILexicalBlock(scope: !42, file: !9, line: 465, column: 9)
!89 = !DILocation(line: 470, column: 19, scope: !88)
!90 = !DILocation(line: 472, column: 30, scope: !88)
!91 = !DILocation(line: 0, scope: !92)
!92 = !DILexicalBlockFile(scope: !42, file: !46, discriminator: 0)
!93 = !DILocation(line: 42, column: 26, scope: !94, inlinedAt: !98)
!94 = distinct !DISubprogram(name: "new_unchecked", linkageName: "_RNvMs1z_NtNtCsjIpoRzUjyHQ_4core3num11niche_typesNtB6_14UsizeNoHighBit13new_unchecked", scope: !96, file: !95, line: 40, type: !13, scopeLine: 40, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !14)
!95 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/num/niche_types.rs", directory: "", checksumkind: CSK_MD5, checksum: "489873530aeeab72b6610b8d531aed40")
!96 = !DINamespace(name: "UsizeNoHighBit", scope: !97)
!97 = !DINamespace(name: "niche_types", scope: !20)
!98 = !DILocation(line: 480, column: 27, scope: !99)
!99 = distinct !DILexicalBlock(scope: !88, file: !9, line: 470, column: 9)
!100 = !DILocation(line: 478, column: 9, scope: !99)
!101 = distinct !DISubprogram(name: "drop<f64, alloc::alloc::Global>", linkageName: "_RNvXs1_NtCs6zY7rJBZy9D_5alloc7raw_vecINtB5_6RawVecdENtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4dropCsfFAnx7WYh7o_12evidence_lab", scope: !102, file: !9, line: 423, type: !13, scopeLine: 423, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !14)
!102 = !DINamespace(name: "{impl#3}", scope: !11)
!103 = !{i64 5726071712768121095}
!104 = !DILocation(line: 425, column: 29, scope: !101)
!105 = !{i64 0, i64 -9223372036854775808}
!106 = !DILocation(line: 631, column: 39, scope: !107, inlinedAt: !108)
!107 = distinct !DISubprogram(name: "current_memory<alloc::alloc::Global>", linkageName: "_RNvMs2_NtCs6zY7rJBZy9D_5alloc7raw_vecNtB5_11RawVecInner14current_memoryCsfFAnx7WYh7o_12evidence_lab", scope: !10, file: !9, line: 630, type: !75, scopeLine: 630, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !14)
!108 = distinct !DILocation(line: 874, column: 52, scope: !109, inlinedAt: !111)
!109 = distinct !DILexicalBlock(scope: !110, file: !9, line: 874, column: 82)
!110 = distinct !DISubprogram(name: "deallocate<alloc::alloc::Global>", linkageName: "_RNvMs3_NtCs6zY7rJBZy9D_5alloc7raw_vecNtB5_11RawVecInner10deallocateCsfFAnx7WYh7o_12evidence_lab", scope: !10, file: !9, line: 872, type: !75, scopeLine: 872, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !14)
!111 = distinct !DILocation(line: 425, column: 29, scope: !101)
!112 = !DILocation(line: 1401, column: 17, scope: !113, inlinedAt: !114)
!113 = distinct !DISubprogram(name: "unchecked_mul", linkageName: "_RNvMs9_NtCsjIpoRzUjyHQ_4core3numj13unchecked_mul", scope: !19, file: !18, line: 1389, type: !13, scopeLine: 1389, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !14)
!114 = distinct !DILocation(line: 639, column: 53, scope: !107, inlinedAt: !108)
!115 = !DILocation(line: 175, column: 14, scope: !116, inlinedAt: !117)
!116 = distinct !DISubprogram(name: "dealloc_nonnull", linkageName: "_RNvNtCs6zY7rJBZy9D_5alloc5alloc15dealloc_nonnull", scope: !65, file: !64, line: 174, type: !13, scopeLine: 174, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !14)
!117 = distinct !DILocation(line: 321, column: 22, scope: !118, inlinedAt: !119)
!118 = distinct !DISubprogram(name: "deallocate_impl_runtime", linkageName: "_RNvMs0_NtCs6zY7rJBZy9D_5alloc5allocNtB5_6Global23deallocate_impl_runtime", scope: !69, file: !64, line: 311, type: !13, scopeLine: 311, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !14)
!119 = distinct !DILocation(line: 436, column: 9, scope: !120, inlinedAt: !121)
!120 = distinct !DISubprogram(name: "deallocate_impl", linkageName: "_RNvMs0_NtCs6zY7rJBZy9D_5alloc5allocNtB5_6Global15deallocate_impl", scope: !69, file: !64, line: 435, type: !13, scopeLine: 435, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !14)
!121 = distinct !DILocation(line: 554, column: 23, scope: !122, inlinedAt: !123)
!122 = distinct !DISubprogram(name: "deallocate", linkageName: "_RNvXs1_NtCs6zY7rJBZy9D_5alloc5allocNtB5_6GlobalNtNtCsjIpoRzUjyHQ_4core5alloc9Allocator10deallocate", scope: !74, file: !64, line: 552, type: !75, scopeLine: 552, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !14)
!123 = distinct !DILocation(line: 876, column: 28, scope: !109, inlinedAt: !111)
!124 = !DILocation(line: 312, column: 9, scope: !118, inlinedAt: !119)
!125 = !DILocation(line: 426, column: 6, scope: !101)
