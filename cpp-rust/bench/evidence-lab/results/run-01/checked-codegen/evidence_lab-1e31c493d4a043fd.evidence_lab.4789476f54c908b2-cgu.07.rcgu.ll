; ModuleID = 'evidence_lab.4789476f54c908b2-cgu.07'
source_filename = "evidence_lab.4789476f54c908b2-cgu.07"
target datalayout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx11.0.0"

; core::slice::sort::shared::pivot::median3_rec::<f64, <[f64]>::sort_by<<f64>::total_cmp>::{closure#0}>
; Function Attrs: nofree nosync nounwind memory(read, inaccessiblemem: none, target_mem: none) uwtable
define hidden noundef nonnull ptr @_RINvNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6shared5pivot11median3_recdNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtBa_3f64d9total_cmpE0ECs68MIsFmw01O_12evidence_lab(ptr nofree noundef readonly %0, ptr nofree noundef readonly %1, ptr nofree noundef readonly %2, i64 noundef %n, ptr noalias nofree noundef readonly align 8 dereferenceable(8) %is_less) unnamed_addr #0 !dbg !8 !guid !17 {
start:
  %3 = and i64 %n, 2305843009213693944, !dbg !18
  %_6.not = icmp eq i64 %3, 0, !dbg !18
  br i1 %_6.not, label %bb6, label %bb1, !dbg !18

bb1:                                              ; preds = %start
  %n84 = lshr i64 %n, 3, !dbg !19
  %count = shl nuw nsw i64 %n84, 2, !dbg !20
  %_10 = getelementptr inbounds nuw [8 x i8], ptr %0, i64 %count, !dbg !22
  %count1 = mul nuw i64 %n84, 7, !dbg !29
  %_13 = getelementptr inbounds nuw [8 x i8], ptr %0, i64 %count1, !dbg !30
; call core::slice::sort::shared::pivot::median3_rec::<f64, <[f64]>::sort_by<<f64>::total_cmp>::{closure#0}>
  %4 = tail call noundef ptr @_RINvNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6shared5pivot11median3_recdNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtBa_3f64d9total_cmpE0ECs68MIsFmw01O_12evidence_lab(ptr noundef %0, ptr noundef %_10, ptr noundef %_13, i64 noundef %n84, ptr noalias nofree noundef nonnull align 8 dereferenceable(8) %is_less), !dbg !32
  %_16 = getelementptr inbounds nuw [8 x i8], ptr %1, i64 %count, !dbg !33
  %_18 = getelementptr inbounds nuw [8 x i8], ptr %1, i64 %count1, !dbg !35
; call core::slice::sort::shared::pivot::median3_rec::<f64, <[f64]>::sort_by<<f64>::total_cmp>::{closure#0}>
  %5 = tail call noundef ptr @_RINvNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6shared5pivot11median3_recdNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtBa_3f64d9total_cmpE0ECs68MIsFmw01O_12evidence_lab(ptr noundef %1, ptr noundef %_16, ptr noundef %_18, i64 noundef %n84, ptr noalias nofree noundef nonnull align 8 dereferenceable(8) %is_less), !dbg !37
  %_20 = getelementptr inbounds nuw [8 x i8], ptr %2, i64 %count, !dbg !38
  %_22 = getelementptr inbounds nuw [8 x i8], ptr %2, i64 %count1, !dbg !40
; call core::slice::sort::shared::pivot::median3_rec::<f64, <[f64]>::sort_by<<f64>::total_cmp>::{closure#0}>
  %6 = tail call noundef ptr @_RINvNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6shared5pivot11median3_recdNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtBa_3f64d9total_cmpE0ECs68MIsFmw01O_12evidence_lab(ptr noundef %2, ptr noundef %_20, ptr noundef %_22, i64 noundef %n84, ptr noalias nofree noundef nonnull align 8 dereferenceable(8) %is_less), !dbg !42
  br label %bb6, !dbg !43

bb6:                                              ; preds = %bb1, %start
  %c.sroa.0.0 = phi ptr [ %6, %bb1 ], [ %2, %start ]
  %b.sroa.0.0 = phi ptr [ %5, %bb1 ], [ %1, %start ]
  %a.sroa.0.0 = phi ptr [ %4, %bb1 ], [ %0, %start ]
  %a.sroa.0.0.val6 = load i64, ptr %a.sroa.0.0, align 8, !dbg !44, !noundef !16
  %b.sroa.0.0.val7 = load i64, ptr %b.sroa.0.0, align 8, !dbg !44, !noundef !16
  %_12.i.i.i = ashr i64 %a.sroa.0.0.val6, 63, !dbg !47
  %_10.i.i.i = lshr i64 %_12.i.i.i, 1, !dbg !69
  %7 = xor i64 %_10.i.i.i, %a.sroa.0.0.val6, !dbg !70
  %_17.i.i.i = ashr i64 %b.sroa.0.0.val7, 63, !dbg !71
  %_15.i.i.i = lshr i64 %_17.i.i.i, 1, !dbg !72
  %8 = xor i64 %_15.i.i.i, %b.sroa.0.0.val7, !dbg !73
  %_0.i = icmp slt i64 %7, %8, !dbg !74
  %c.sroa.0.0.val5 = load i64, ptr %c.sroa.0.0, align 8, !dbg !82, !noundef !16
  %_17.i.i.i10 = ashr i64 %c.sroa.0.0.val5, 63, !dbg !84
  %_15.i.i.i11 = lshr i64 %_17.i.i.i10, 1, !dbg !88
  %9 = xor i64 %_15.i.i.i11, %c.sroa.0.0.val5, !dbg !89
  %_0.i12 = icmp slt i64 %7, %9, !dbg !90
  %10 = xor i1 %_0.i, %_0.i12, !dbg !92
  %_0.i17 = icmp slt i64 %8, %9, !dbg !92
  %_12.i = xor i1 %_0.i, %_0.i17, !dbg !92
  %c.b.i = select i1 %_12.i, ptr %c.sroa.0.0, ptr %b.sroa.0.0, !dbg !92
  %_0.sroa.0.0.i = select i1 %10, ptr %a.sroa.0.0, ptr %c.b.i, !dbg !92
  ret ptr %_0.sroa.0.0.i, !dbg !94
}

attributes #0 = { nofree nosync nounwind memory(read, inaccessiblemem: none, target_mem: none) uwtable "frame-pointer"="non-leaf" "probe-stack"="inline-asm" "target-cpu"="apple-m1" }

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
!7 = !DIFile(filename: "src/lib.rs/@/evidence_lab.4789476f54c908b2-cgu.07", directory: "/Users/juanwang/Desktop/tutorials/cpp-rust/bench/evidence-lab")
!8 = distinct !DISubprogram(name: "median3_rec<f64, alloc::slice::{impl#0}::sort_by::{closure_env#0}<f64, fn(&f64, &f64) -> core::cmp::Ordering>>", linkageName: "_RINvNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6shared5pivot11median3_recdNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtBa_3f64d9total_cmpE0ECs68MIsFmw01O_12evidence_lab", scope: !10, file: !9, line: 55, type: !15, scopeLine: 55, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !16)
!9 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/slice/sort/shared/pivot.rs", directory: "", checksumkind: CSK_MD5, checksum: "26ac187e86056554a2868ec9c016e4a4")
!10 = !DINamespace(name: "pivot", scope: !11)
!11 = !DINamespace(name: "shared", scope: !12)
!12 = !DINamespace(name: "sort", scope: !13)
!13 = !DINamespace(name: "slice", scope: !14)
!14 = !DINamespace(name: "core", scope: null)
!15 = !DISubroutineType(types: !16)
!16 = !{}
!17 = !{i64 -1172875555277751548}
!18 = !DILocation(line: 65, column: 12, scope: !8)
!19 = !DILocation(line: 66, column: 22, scope: !8)
!20 = !DILocation(line: 67, column: 38, scope: !21)
!21 = distinct !DILexicalBlock(scope: !8, file: !9, line: 66, column: 13)
!22 = !DILocation(line: 871, column: 18, scope: !23, inlinedAt: !28)
!23 = distinct !DISubprogram(name: "add<f64>", linkageName: "_RNvMNtNtCsjIpoRzUjyHQ_4core3ptr9const_ptrPd3addCs68MIsFmw01O_12evidence_lab", scope: !25, file: !24, line: 837, type: !15, scopeLine: 837, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !16)
!24 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/ptr/const_ptr.rs", directory: "", checksumkind: CSK_MD5, checksum: "25118ae25e729b7c815218b31622724c")
!25 = !DINamespace(name: "{impl#0}", scope: !26)
!26 = !DINamespace(name: "const_ptr", scope: !27)
!27 = !DINamespace(name: "ptr", scope: !14)
!28 = !DILocation(line: 67, column: 34, scope: !21)
!29 = !DILocation(line: 67, column: 53, scope: !21)
!30 = !DILocation(line: 871, column: 18, scope: !23, inlinedAt: !31)
!31 = !DILocation(line: 67, column: 49, scope: !21)
!32 = !DILocation(line: 67, column: 17, scope: !21)
!33 = !DILocation(line: 871, column: 18, scope: !23, inlinedAt: !34)
!34 = !DILocation(line: 68, column: 34, scope: !21)
!35 = !DILocation(line: 871, column: 18, scope: !23, inlinedAt: !36)
!36 = !DILocation(line: 68, column: 49, scope: !21)
!37 = !DILocation(line: 68, column: 17, scope: !21)
!38 = !DILocation(line: 871, column: 18, scope: !23, inlinedAt: !39)
!39 = !DILocation(line: 69, column: 34, scope: !21)
!40 = !DILocation(line: 871, column: 18, scope: !23, inlinedAt: !41)
!41 = !DILocation(line: 69, column: 49, scope: !21)
!42 = !DILocation(line: 69, column: 17, scope: !21)
!43 = !DILocation(line: 65, column: 9, scope: !8)
!44 = !DILocation(line: 82, column: 13, scope: !45, inlinedAt: !46)
!45 = distinct !DISubprogram(name: "median3<f64, alloc::slice::{impl#0}::sort_by::{closure_env#0}<f64, fn(&f64, &f64) -> core::cmp::Ordering>>", linkageName: "_RINvNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6shared5pivot7median3dNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtBa_3f64d9total_cmpE0ECs68MIsFmw01O_12evidence_lab", scope: !10, file: !9, line: 79, type: !15, scopeLine: 79, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !16)
!46 = distinct !DILocation(line: 71, column: 9, scope: !8)
!47 = !DILocation(line: 1547, column: 19, scope: !48, inlinedAt: !55)
!48 = distinct !DILexicalBlock(scope: !50, file: !49, line: 1523, column: 9)
!49 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/num/f64.rs", directory: "", checksumkind: CSK_MD5, checksum: "b3f8ed35e28142dfe7f88c4667789fd1")
!50 = distinct !DILexicalBlock(scope: !51, file: !49, line: 1522, column: 9)
!51 = distinct !DISubprogram(name: "total_cmp", linkageName: "_RNvMNtCsjIpoRzUjyHQ_4core3f64d9total_cmp", scope: !52, file: !49, line: 1521, type: !54, scopeLine: 1521, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !16)
!52 = !DINamespace(name: "{impl#0}", scope: !53)
!53 = !DINamespace(name: "f64", scope: !14)
!54 = !DISubroutineType(cc: DW_CC_nocall, types: !16)
!55 = distinct !DILocation(line: 166, column: 5, scope: !56, inlinedAt: !61)
!56 = distinct !DISubprogram(name: "call_mut<fn(&f64, &f64) -> core::cmp::Ordering, (&f64, &f64)>", linkageName: "_RNvYNvMNtCsjIpoRzUjyHQ_4core3f64d9total_cmpINtNtNtB7_3ops8function5FnMutTRdB19_EE8call_mutCs68MIsFmw01O_12evidence_lab", scope: !58, file: !57, line: 166, type: !54, scopeLine: 166, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !16)
!57 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/ops/function.rs", directory: "", checksumkind: CSK_MD5, checksum: "ae01f833f82cd27aa916c99d95502941")
!58 = !DINamespace(name: "FnMut", scope: !59)
!59 = !DINamespace(name: "function", scope: !60)
!60 = !DINamespace(name: "ops", scope: !14)
!61 = distinct !DILocation(line: 196, column: 34, scope: !62, inlinedAt: !68)
!62 = distinct !DISubprogram(name: "{closure#0}<f64, fn(&f64, &f64) -> core::cmp::Ordering>", linkageName: "_RNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtCsjIpoRzUjyHQ_4core3f64d9total_cmpE0Cs68MIsFmw01O_12evidence_lab", scope: !64, file: !63, line: 196, type: !54, scopeLine: 196, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !16)
!63 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/alloc/src/slice.rs", directory: "", checksumkind: CSK_MD5, checksum: "8e7bce5d617a4e88f7bdb700dff9d669")
!64 = !DINamespace(name: "sort_by", scope: !65)
!65 = !DINamespace(name: "{impl#0}", scope: !66)
!66 = !DINamespace(name: "slice", scope: !67)
!67 = !DINamespace(name: "alloc", scope: null)
!68 = distinct !DILocation(line: 82, column: 13, scope: !45, inlinedAt: !46)
!69 = !DILocation(line: 1547, column: 17, scope: !48, inlinedAt: !55)
!70 = !DILocation(line: 1547, column: 9, scope: !48, inlinedAt: !55)
!71 = !DILocation(line: 1548, column: 20, scope: !48, inlinedAt: !55)
!72 = !DILocation(line: 1548, column: 18, scope: !48, inlinedAt: !55)
!73 = !DILocation(line: 1548, column: 9, scope: !48, inlinedAt: !55)
!74 = !DILocation(line: 410, column: 44, scope: !75, inlinedAt: !81)
!75 = distinct !DILexicalBlock(scope: !77, file: !76, line: 410, column: 44)
!76 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/cmp.rs", directory: "", checksumkind: CSK_MD5, checksum: "49e2a03e6445d88887d9438f640a7fcc")
!77 = distinct !DILexicalBlock(scope: !78, file: !76, line: 410, column: 44)
!78 = distinct !DISubprogram(name: "eq", linkageName: "_RNvXsb_NtCsjIpoRzUjyHQ_4core3cmpNtB5_8OrderingNtB5_9PartialEq2eq", scope: !79, file: !76, line: 410, type: !15, scopeLine: 410, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !16)
!79 = !DINamespace(name: "{impl#13}", scope: !80)
!80 = !DINamespace(name: "cmp", scope: !14)
!81 = distinct !DILocation(line: 196, column: 34, scope: !62, inlinedAt: !68)
!82 = !DILocation(line: 83, column: 13, scope: !83, inlinedAt: !46)
!83 = distinct !DILexicalBlock(scope: !45, file: !9, line: 82, column: 5)
!84 = !DILocation(line: 1548, column: 20, scope: !48, inlinedAt: !85)
!85 = distinct !DILocation(line: 166, column: 5, scope: !56, inlinedAt: !86)
!86 = distinct !DILocation(line: 196, column: 34, scope: !62, inlinedAt: !87)
!87 = distinct !DILocation(line: 83, column: 13, scope: !83, inlinedAt: !46)
!88 = !DILocation(line: 1548, column: 18, scope: !48, inlinedAt: !85)
!89 = !DILocation(line: 1548, column: 9, scope: !48, inlinedAt: !85)
!90 = !DILocation(line: 410, column: 44, scope: !75, inlinedAt: !91)
!91 = distinct !DILocation(line: 196, column: 34, scope: !62, inlinedAt: !87)
!92 = !DILocation(line: 84, column: 8, scope: !93, inlinedAt: !46)
!93 = distinct !DILexicalBlock(scope: !83, file: !9, line: 83, column: 5)
!94 = !DILocation(line: 73, column: 2, scope: !8)
