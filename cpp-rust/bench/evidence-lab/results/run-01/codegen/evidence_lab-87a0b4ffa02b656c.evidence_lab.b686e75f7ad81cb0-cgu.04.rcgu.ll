; ModuleID = 'evidence_lab.b686e75f7ad81cb0-cgu.04'
source_filename = "evidence_lab.b686e75f7ad81cb0-cgu.04"
target datalayout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx11.0.0"

; core::slice::sort::stable::merge::merge::<f64, <[f64]>::sort_by<<f64>::total_cmp>::{closure#0}>
; Function Attrs: nofree norecurse nosync nounwind memory(argmem: readwrite) uwtable
define hidden void @_RINvNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6stable5merge5mergedNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtBa_3f64d9total_cmpE0ECsfFAnx7WYh7o_12evidence_lab(ptr noalias nofree noundef nonnull align 8 captures(address) %v.0, i64 noundef range(i64 0, 1152921504606846976) %v.1, ptr noalias nofree noundef nonnull align 8 %scratch.0, i64 noundef range(i64 0, 1152921504606846976) %scratch.1, i64 noundef %0, ptr noalias nofree noundef readnone align 8 captures(none) dereferenceable(8) %is_less) unnamed_addr #0 personality ptr @rust_eh_personality !dbg !8 !guid !17 {
start:
  %1 = icmp eq i64 %0, 0, !dbg !18
  %_6 = icmp uge i64 %0, %v.1
  %or.cond = or i1 %1, %_6, !dbg !18
  br i1 %or.cond, label %bb18, label %bb2, !dbg !18

bb2:                                              ; preds = %start
  %right_len = sub nuw nsw i64 %v.1, %0, !dbg !20
  %..i = tail call i64 @llvm.umin.i64(i64 %right_len, i64 %0), !dbg !21
  %_7 = icmp samesign ult i64 %scratch.1, %..i, !dbg !29
  br i1 %_7, label %bb18, label %bb5, !dbg !29

bb5:                                              ; preds = %bb2
  %v_mid = getelementptr inbounds nuw [8 x i8], ptr %v.0, i64 %0, !dbg !30
  %v_end = getelementptr inbounds nuw [8 x i8], ptr %v.0, i64 %v.1, !dbg !39
  %left_is_shorter.not = icmp samesign ugt i64 %0, %right_len, !dbg !42
  %spec.select = select i1 %left_is_shorter.not, ptr %v_mid, ptr %v.0, !dbg !46
  %2 = shl nuw nsw i64 %..i, 3, !dbg !48
  tail call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 8 %scratch.0, ptr nonnull align 8 %spec.select, i64 %2, i1 false), !dbg !48
  %_21 = getelementptr inbounds nuw i8, ptr %scratch.0, i64 %2, !dbg !54
  br i1 %left_is_shorter.not, label %bb1.i, label %bb3.i, !dbg !56

bb1.i:                                            ; preds = %bb5, %bb1.i
  %_215.i = phi ptr [ %_21.i, %bb1.i ], [ %_21, %bb5 ], !dbg !58
  %_183.i = phi ptr [ %_18.i, %bb1.i ], [ %v_mid, %bb5 ], !dbg !65
  %out.sroa.0.0.i = phi ptr [ %5, %bb1.i ], [ %v_end, %bb5 ]
  %3 = getelementptr inbounds i8, ptr %_183.i, i64 -8, !dbg !58
  %4 = getelementptr inbounds i8, ptr %_215.i, i64 -8, !dbg !66
  %5 = getelementptr inbounds i8, ptr %out.sroa.0.0.i, i64 -8, !dbg !69
  %.val.i = load i64, ptr %4, align 8, !dbg !72, !noalias !73, !noundef !16
  %.val7.i = load i64, ptr %3, align 8, !dbg !72, !noalias !73, !noundef !16
  %_12.i.i.i.i = ashr i64 %.val.i, 63, !dbg !76
  %_10.i.i.i.i = lshr i64 %_12.i.i.i.i, 1, !dbg !97
  %6 = xor i64 %_10.i.i.i.i, %.val.i, !dbg !98
  %_17.i.i.i.i = ashr i64 %.val7.i, 63, !dbg !99
  %_15.i.i.i.i = lshr i64 %_17.i.i.i.i, 1, !dbg !100
  %7 = xor i64 %_15.i.i.i.i, %.val7.i, !dbg !101
  %_0.i.i = icmp slt i64 %6, %7, !dbg !102
  %8 = select i1 %_0.i.i, i64 %.val7.i, i64 %.val.i, !dbg !108
  store i64 %8, ptr %5, align 8, !dbg !110, !noalias !73
  %_20.i = xor i1 %_0.i.i, true, !dbg !114
  %count.i = zext i1 %_20.i to i64, !dbg !114
  %_18.i = getelementptr inbounds nuw [8 x i8], ptr %3, i64 %count.i, !dbg !115
  %count4.i = zext i1 %_0.i.i to i64, !dbg !118
  %_21.i = getelementptr inbounds nuw [8 x i8], ptr %4, i64 %count4.i, !dbg !119
  %_23.i = icmp eq ptr %_18.i, %v.0, !dbg !121
  %_26.i = icmp eq ptr %_21.i, %scratch.0
  %or.cond.i = select i1 %_23.i, i1 true, i1 %_26.i, !dbg !121
  br i1 %or.cond.i, label %bb16, label %bb1.i, !dbg !121

bb3.i:                                            ; preds = %bb5, %bb3.i
  %_259.i = phi ptr [ %_25.i, %bb3.i ], [ %v.0, %bb5 ], !dbg !122
  %right.sroa.0.08.i = phi ptr [ %_23.i19, %bb3.i ], [ %v_mid, %bb5 ]
  %_837.i = phi ptr [ %_20.i18, %bb3.i ], [ %scratch.0, %bb5 ]
  %right.sroa.0.0.val.i = load i64, ptr %right.sroa.0.08.i, align 8, !dbg !122, !noalias !127, !noundef !16
  %_8.val.i = load i64, ptr %_837.i, align 8, !dbg !122, !noalias !127, !noundef !16
  %_12.i.i.i.i12 = ashr i64 %right.sroa.0.0.val.i, 63, !dbg !130
  %_10.i.i.i.i13 = lshr i64 %_12.i.i.i.i12, 1, !dbg !134
  %9 = xor i64 %_10.i.i.i.i13, %right.sroa.0.0.val.i, !dbg !135
  %_17.i.i.i.i14 = ashr i64 %_8.val.i, 63, !dbg !136
  %_15.i.i.i.i15 = lshr i64 %_17.i.i.i.i14, 1, !dbg !137
  %10 = xor i64 %_15.i.i.i.i15, %_8.val.i, !dbg !138
  %_0.i.i16 = icmp slt i64 %9, %10, !dbg !139
  %consume_left.i = xor i1 %_0.i.i16, true, !dbg !141
  %11 = select i1 %_0.i.i16, i64 %right.sroa.0.0.val.i, i64 %_8.val.i, !dbg !142
  store i64 %11, ptr %_259.i, align 8, !dbg !144, !noalias !127
  %count.i17 = zext i1 %consume_left.i to i64, !dbg !148
  %_20.i18 = getelementptr inbounds nuw [8 x i8], ptr %_837.i, i64 %count.i17, !dbg !149
  %count2.i = zext i1 %_0.i.i16 to i64, !dbg !152
  %_23.i19 = getelementptr inbounds nuw [8 x i8], ptr %right.sroa.0.08.i, i64 %count2.i, !dbg !153
  %_25.i = getelementptr inbounds nuw i8, ptr %_259.i, i64 8, !dbg !159
  %_7.i = icmp ne ptr %_20.i18, %_21, !dbg !161
  %_10.i = icmp ne ptr %_23.i19, %v_end
  %or.cond.i20 = select i1 %_7.i, i1 %_10.i, i1 false, !dbg !161
  br i1 %or.cond.i20, label %bb3.i, label %bb16, !dbg !161

bb16:                                             ; preds = %bb3.i, %bb1.i
  %merge_state.sroa.13.0 = phi ptr [ %_18.i, %bb1.i ], [ %_25.i, %bb3.i ], !dbg !162
  %merge_state.sroa.7.0 = phi ptr [ %_21.i, %bb1.i ], [ %_21, %bb3.i ], !dbg !163
  %merge_state.sroa.0.0 = phi ptr [ %scratch.0, %bb1.i ], [ %_20.i18, %bb3.i ], !dbg !163
  %12 = ptrtoint ptr %merge_state.sroa.7.0 to i64, !dbg !164
  %13 = ptrtoint ptr %merge_state.sroa.0.0 to i64, !dbg !164
  %14 = sub nuw i64 %12, %13, !dbg !164
  tail call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 8 %merge_state.sroa.13.0, ptr align 8 %merge_state.sroa.0.0, i64 %14, i1 false), !dbg !175, !noalias !179
  br label %bb18, !dbg !184

bb18:                                             ; preds = %bb16, %bb2, %start
  ret void, !dbg !184
}

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.memcpy.p0.p0.i64(ptr noalias writeonly captures(none), ptr noalias readonly captures(none), i64, i1 immarg) #1

; Function Attrs: nounwind uwtable
declare noundef range(i32 0, 10) i32 @rust_eh_personality(i32 noundef, i32 noundef, i64 noundef, ptr noundef, ptr noundef) unnamed_addr #2

; Function Attrs: nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none)
declare i64 @llvm.umin.i64(i64, i64) #3

attributes #0 = { nofree norecurse nosync nounwind memory(argmem: readwrite) uwtable "frame-pointer"="non-leaf" "probe-stack"="inline-asm" "target-cpu"="apple-m1" }
attributes #1 = { nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #2 = { nounwind uwtable "frame-pointer"="non-leaf" "probe-stack"="inline-asm" "target-cpu"="apple-m1" }
attributes #3 = { nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none) }

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
!7 = !DIFile(filename: "src/lib.rs/@/evidence_lab.b686e75f7ad81cb0-cgu.04", directory: "/Users/juanwang/Desktop/tutorials/cpp-rust/bench/evidence-lab")
!8 = distinct !DISubprogram(name: "merge<f64, alloc::slice::{impl#0}::sort_by::{closure_env#0}<f64, fn(&f64, &f64) -> core::cmp::Ordering>>", linkageName: "_RINvNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6stable5merge5mergedNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtBa_3f64d9total_cmpE0ECsfFAnx7WYh7o_12evidence_lab", scope: !10, file: !9, line: 8, type: !15, scopeLine: 8, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !16)
!9 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/slice/sort/stable/merge.rs", directory: "", checksumkind: CSK_MD5, checksum: "90afbaa2075bc1e9689ef92c7df39f20")
!10 = !DINamespace(name: "merge", scope: !11)
!11 = !DINamespace(name: "stable", scope: !12)
!12 = !DINamespace(name: "sort", scope: !13)
!13 = !DINamespace(name: "slice", scope: !14)
!14 = !DINamespace(name: "core", scope: null)
!15 = !DISubroutineType(types: !16)
!16 = !{}
!17 = !{i64 5944565800422520829}
!18 = !DILocation(line: 16, column: 8, scope: !19)
!19 = distinct !DILexicalBlock(scope: !8, file: !9, line: 14, column: 5)
!20 = !DILocation(line: 16, column: 64, scope: !19)
!21 = !DILocation(line: 1090, column: 5, scope: !22, inlinedAt: !26)
!22 = distinct !DISubprogram(name: "min<usize>", linkageName: "_RNvYjNtNtCsjIpoRzUjyHQ_4core3cmp3Ord3minCsfFAnx7WYh7o_12evidence_lab", scope: !24, file: !23, line: 1085, type: !15, scopeLine: 1085, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !16)
!23 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/cmp.rs", directory: "", checksumkind: CSK_MD5, checksum: "49e2a03e6445d88887d9438f640a7fcc")
!24 = !DINamespace(name: "Ord", scope: !25)
!25 = !DINamespace(name: "cmp", scope: !14)
!26 = distinct !DILocation(line: 1587, column: 8, scope: !27, inlinedAt: !28)
!27 = distinct !DISubprogram(name: "min<usize>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3cmp3minjECsfFAnx7WYh7o_12evidence_lab", scope: !25, file: !23, line: 1586, type: !15, scopeLine: 1586, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !16)
!28 = !DILocation(line: 16, column: 50, scope: !19)
!29 = !DILocation(line: 16, column: 34, scope: !19)
!30 = !DILocation(line: 970, column: 18, scope: !31, inlinedAt: !36)
!31 = distinct !DISubprogram(name: "add<f64>", linkageName: "_RNvMNtNtCsjIpoRzUjyHQ_4core3ptr7mut_ptrOd3addCsfFAnx7WYh7o_12evidence_lab", scope: !33, file: !32, line: 936, type: !15, scopeLine: 936, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !16)
!32 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/ptr/mut_ptr.rs", directory: "", checksumkind: CSK_MD5, checksum: "0a9a444e8d978ea2fd7622da49f95724")
!33 = !DINamespace(name: "{impl#0}", scope: !34)
!34 = !DINamespace(name: "mut_ptr", scope: !35)
!35 = !DINamespace(name: "ptr", scope: !14)
!36 = !DILocation(line: 41, column: 28, scope: !37)
!37 = distinct !DILexicalBlock(scope: !38, file: !9, line: 40, column: 9)
!38 = distinct !DILexicalBlock(scope: !19, file: !9, line: 38, column: 9)
!39 = !DILocation(line: 970, column: 18, scope: !31, inlinedAt: !40)
!40 = !DILocation(line: 42, column: 28, scope: !41)
!41 = distinct !DILexicalBlock(scope: !37, file: !9, line: 41, column: 9)
!42 = !DILocation(line: 47, column: 31, scope: !43)
!43 = distinct !DILexicalBlock(scope: !44, file: !9, line: 45, column: 9)
!44 = distinct !DILexicalBlock(scope: !45, file: !9, line: 44, column: 9)
!45 = distinct !DILexicalBlock(scope: !41, file: !9, line: 42, column: 9)
!46 = !DILocation(line: 48, column: 28, scope: !47)
!47 = distinct !DILexicalBlock(scope: !43, file: !9, line: 47, column: 9)
!48 = !DILocation(line: 573, column: 14, scope: !49, inlinedAt: !51)
!49 = distinct !DISubprogram(name: "copy_nonoverlapping<f64>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3ptr19copy_nonoverlappingdECsfFAnx7WYh7o_12evidence_lab", scope: !35, file: !50, line: 552, type: !15, scopeLine: 552, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !16)
!50 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/ptr/mod.rs", directory: "", checksumkind: CSK_MD5, checksum: "59033ebc630da002040513c25c9de121")
!51 = !DILocation(line: 51, column: 9, scope: !52)
!52 = distinct !DILexicalBlock(scope: !53, file: !9, line: 49, column: 9)
!53 = distinct !DILexicalBlock(scope: !47, file: !9, line: 48, column: 9)
!54 = !DILocation(line: 970, column: 18, scope: !31, inlinedAt: !55)
!55 = !DILocation(line: 53, column: 65, scope: !52)
!56 = !DILocation(line: 55, column: 12, scope: !57)
!57 = distinct !DILexicalBlock(scope: !52, file: !9, line: 53, column: 9)
!58 = !DILocation(line: 1054, column: 22, scope: !59, inlinedAt: !60)
!59 = distinct !DISubprogram(name: "sub<f64>", linkageName: "_RNvMNtNtCsjIpoRzUjyHQ_4core3ptr7mut_ptrOd3subCsfFAnx7WYh7o_12evidence_lab", scope: !33, file: !32, line: 1015, type: !15, scopeLine: 1015, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !16)
!60 = distinct !DILocation(line: 118, column: 37, scope: !61, inlinedAt: !64)
!61 = distinct !DISubprogram(name: "merge_down<f64, alloc::slice::{impl#0}::sort_by::{closure_env#0}<f64, fn(&f64, &f64) -> core::cmp::Ordering>>", linkageName: "_RINvMNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6stable5mergeINtB3_10MergeStatedE10merge_downNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtBb_3f64d9total_cmpE0ECsfFAnx7WYh7o_12evidence_lab", scope: !62, file: !9, line: 108, type: !63, scopeLine: 108, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !16)
!62 = !DINamespace(name: "MergeState", scope: !10)
!63 = !DISubroutineType(cc: DW_CC_nocall, types: !16)
!64 = distinct !DILocation(line: 58, column: 25, scope: !57)
!65 = !DILocation(line: 118, column: 28, scope: !61, inlinedAt: !64)
!66 = !DILocation(line: 1054, column: 22, scope: !59, inlinedAt: !67)
!67 = distinct !DILocation(line: 119, column: 38, scope: !68, inlinedAt: !64)
!68 = distinct !DILexicalBlock(scope: !61, file: !9, line: 118, column: 17)
!69 = !DILocation(line: 1054, column: 22, scope: !59, inlinedAt: !70)
!70 = distinct !DILocation(line: 120, column: 27, scope: !71, inlinedAt: !64)
!71 = distinct !DILexicalBlock(scope: !68, file: !9, line: 119, column: 17)
!72 = !DILocation(line: 122, column: 36, scope: !71, inlinedAt: !64)
!73 = !{!74}
!74 = distinct !{!74, !75, !"_RINvMNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6stable5mergeINtB3_10MergeStatedE10merge_downNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtBb_3f64d9total_cmpE0ECsfFAnx7WYh7o_12evidence_lab: %self"}
!75 = distinct !{!75, !"_RINvMNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6stable5mergeINtB3_10MergeStatedE10merge_downNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtBb_3f64d9total_cmpE0ECsfFAnx7WYh7o_12evidence_lab"}
!76 = !DILocation(line: 1547, column: 19, scope: !77, inlinedAt: !83)
!77 = distinct !DILexicalBlock(scope: !79, file: !78, line: 1523, column: 9)
!78 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/num/f64.rs", directory: "", checksumkind: CSK_MD5, checksum: "b3f8ed35e28142dfe7f88c4667789fd1")
!79 = distinct !DILexicalBlock(scope: !80, file: !78, line: 1522, column: 9)
!80 = distinct !DISubprogram(name: "total_cmp", linkageName: "_RNvMNtCsjIpoRzUjyHQ_4core3f64d9total_cmp", scope: !81, file: !78, line: 1521, type: !63, scopeLine: 1521, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !16)
!81 = !DINamespace(name: "{impl#0}", scope: !82)
!82 = !DINamespace(name: "f64", scope: !14)
!83 = distinct !DILocation(line: 166, column: 5, scope: !84, inlinedAt: !89)
!84 = distinct !DISubprogram(name: "call_mut<fn(&f64, &f64) -> core::cmp::Ordering, (&f64, &f64)>", linkageName: "_RNvYNvMNtCsjIpoRzUjyHQ_4core3f64d9total_cmpINtNtNtB7_3ops8function5FnMutTRdB19_EE8call_mutCsfFAnx7WYh7o_12evidence_lab", scope: !86, file: !85, line: 166, type: !63, scopeLine: 166, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !16)
!85 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/ops/function.rs", directory: "", checksumkind: CSK_MD5, checksum: "ae01f833f82cd27aa916c99d95502941")
!86 = !DINamespace(name: "FnMut", scope: !87)
!87 = !DINamespace(name: "function", scope: !88)
!88 = !DINamespace(name: "ops", scope: !14)
!89 = distinct !DILocation(line: 196, column: 34, scope: !90, inlinedAt: !96)
!90 = distinct !DISubprogram(name: "{closure#0}<f64, fn(&f64, &f64) -> core::cmp::Ordering>", linkageName: "_RNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtCsjIpoRzUjyHQ_4core3f64d9total_cmpE0CsfFAnx7WYh7o_12evidence_lab", scope: !92, file: !91, line: 196, type: !63, scopeLine: 196, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !16)
!91 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/alloc/src/slice.rs", directory: "", checksumkind: CSK_MD5, checksum: "8e7bce5d617a4e88f7bdb700dff9d669")
!92 = !DINamespace(name: "sort_by", scope: !93)
!93 = !DINamespace(name: "{impl#0}", scope: !94)
!94 = !DINamespace(name: "slice", scope: !95)
!95 = !DINamespace(name: "alloc", scope: null)
!96 = distinct !DILocation(line: 122, column: 36, scope: !71, inlinedAt: !64)
!97 = !DILocation(line: 1547, column: 17, scope: !77, inlinedAt: !83)
!98 = !DILocation(line: 1547, column: 9, scope: !77, inlinedAt: !83)
!99 = !DILocation(line: 1548, column: 20, scope: !77, inlinedAt: !83)
!100 = !DILocation(line: 1548, column: 18, scope: !77, inlinedAt: !83)
!101 = !DILocation(line: 1548, column: 9, scope: !77, inlinedAt: !83)
!102 = !DILocation(line: 410, column: 44, scope: !103, inlinedAt: !107)
!103 = distinct !DILexicalBlock(scope: !104, file: !23, line: 410, column: 44)
!104 = distinct !DILexicalBlock(scope: !105, file: !23, line: 410, column: 44)
!105 = distinct !DISubprogram(name: "eq", linkageName: "_RNvXsb_NtCsjIpoRzUjyHQ_4core3cmpNtB5_8OrderingNtB5_9PartialEq2eq", scope: !106, file: !23, line: 410, type: !15, scopeLine: 410, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !16)
!106 = !DINamespace(name: "{impl#13}", scope: !25)
!107 = distinct !DILocation(line: 196, column: 34, scope: !90, inlinedAt: !96)
!108 = !DILocation(line: 124, column: 27, scope: !109, inlinedAt: !64)
!109 = distinct !DILexicalBlock(scope: !71, file: !9, line: 122, column: 17)
!110 = !DILocation(line: 573, column: 14, scope: !111, inlinedAt: !112)
!111 = distinct !DISubprogram(name: "copy_nonoverlapping<f64>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3ptr19copy_nonoverlappingdECsfFAnx7WYh7o_12evidence_lab", scope: !35, file: !50, line: 552, type: !15, scopeLine: 552, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !16)
!112 = distinct !DILocation(line: 125, column: 17, scope: !113, inlinedAt: !64)
!113 = distinct !DILexicalBlock(scope: !109, file: !9, line: 124, column: 17)
!114 = !DILocation(line: 127, column: 37, scope: !113, inlinedAt: !64)
!115 = !DILocation(line: 970, column: 18, scope: !116, inlinedAt: !117)
!116 = distinct !DISubprogram(name: "add<f64>", linkageName: "_RNvMNtNtCsjIpoRzUjyHQ_4core3ptr7mut_ptrOd3addCsfFAnx7WYh7o_12evidence_lab", scope: !33, file: !32, line: 936, type: !15, scopeLine: 936, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !16)
!117 = distinct !DILocation(line: 127, column: 33, scope: !113, inlinedAt: !64)
!118 = !DILocation(line: 128, column: 38, scope: !113, inlinedAt: !64)
!119 = !DILocation(line: 970, column: 18, scope: !116, inlinedAt: !120)
!120 = distinct !DILocation(line: 128, column: 34, scope: !113, inlinedAt: !64)
!121 = !DILocation(line: 130, column: 20, scope: !113, inlinedAt: !64)
!122 = !DILocation(line: 90, column: 37, scope: !123, inlinedAt: !126)
!123 = distinct !DILexicalBlock(scope: !124, file: !9, line: 87, column: 13)
!124 = distinct !DILexicalBlock(scope: !125, file: !9, line: 86, column: 13)
!125 = distinct !DISubprogram(name: "merge_up<f64, alloc::slice::{impl#0}::sort_by::{closure_env#0}<f64, fn(&f64, &f64) -> core::cmp::Ordering>>", linkageName: "_RINvMNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6stable5mergeINtB3_10MergeStatedE8merge_upNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtBb_3f64d9total_cmpE0ECsfFAnx7WYh7o_12evidence_lab", scope: !62, file: !9, line: 78, type: !63, scopeLine: 78, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !16)
!126 = distinct !DILocation(line: 56, column: 25, scope: !57)
!127 = !{!128}
!128 = distinct !{!128, !129, !"_RINvMNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6stable5mergeINtB3_10MergeStatedE8merge_upNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtBb_3f64d9total_cmpE0ECsfFAnx7WYh7o_12evidence_lab: %self"}
!129 = distinct !{!129, !"_RINvMNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6stable5mergeINtB3_10MergeStatedE8merge_upNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtBb_3f64d9total_cmpE0ECsfFAnx7WYh7o_12evidence_lab"}
!130 = !DILocation(line: 1547, column: 19, scope: !77, inlinedAt: !131)
!131 = distinct !DILocation(line: 166, column: 5, scope: !84, inlinedAt: !132)
!132 = distinct !DILocation(line: 196, column: 34, scope: !90, inlinedAt: !133)
!133 = distinct !DILocation(line: 90, column: 37, scope: !123, inlinedAt: !126)
!134 = !DILocation(line: 1547, column: 17, scope: !77, inlinedAt: !131)
!135 = !DILocation(line: 1547, column: 9, scope: !77, inlinedAt: !131)
!136 = !DILocation(line: 1548, column: 20, scope: !77, inlinedAt: !131)
!137 = !DILocation(line: 1548, column: 18, scope: !77, inlinedAt: !131)
!138 = !DILocation(line: 1548, column: 9, scope: !77, inlinedAt: !131)
!139 = !DILocation(line: 410, column: 44, scope: !103, inlinedAt: !140)
!140 = distinct !DILocation(line: 196, column: 34, scope: !90, inlinedAt: !133)
!141 = !DILocation(line: 90, column: 36, scope: !123, inlinedAt: !126)
!142 = !DILocation(line: 92, column: 30, scope: !143, inlinedAt: !126)
!143 = distinct !DILexicalBlock(scope: !123, file: !9, line: 90, column: 17)
!144 = !DILocation(line: 573, column: 14, scope: !145, inlinedAt: !146)
!145 = distinct !DISubprogram(name: "copy_nonoverlapping<f64>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3ptr19copy_nonoverlappingdECsfFAnx7WYh7o_12evidence_lab", scope: !35, file: !50, line: 552, type: !15, scopeLine: 552, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !16)
!146 = distinct !DILocation(line: 93, column: 17, scope: !147, inlinedAt: !126)
!147 = distinct !DILexicalBlock(scope: !143, file: !9, line: 92, column: 17)
!148 = !DILocation(line: 95, column: 34, scope: !147, inlinedAt: !126)
!149 = !DILocation(line: 970, column: 18, scope: !150, inlinedAt: !151)
!150 = distinct !DISubprogram(name: "add<f64>", linkageName: "_RNvMNtNtCsjIpoRzUjyHQ_4core3ptr7mut_ptrOd3addCsfFAnx7WYh7o_12evidence_lab", scope: !33, file: !32, line: 936, type: !15, scopeLine: 936, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !16)
!151 = distinct !DILocation(line: 95, column: 30, scope: !147, inlinedAt: !126)
!152 = !DILocation(line: 96, column: 35, scope: !147, inlinedAt: !126)
!153 = !DILocation(line: 871, column: 18, scope: !154, inlinedAt: !158)
!154 = distinct !DISubprogram(name: "add<f64>", linkageName: "_RNvMNtNtCsjIpoRzUjyHQ_4core3ptr9const_ptrPd3addCsfFAnx7WYh7o_12evidence_lab", scope: !156, file: !155, line: 837, type: !15, scopeLine: 837, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !16)
!155 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/ptr/const_ptr.rs", directory: "", checksumkind: CSK_MD5, checksum: "25118ae25e729b7c815218b31622724c")
!156 = !DINamespace(name: "{impl#0}", scope: !157)
!157 = !DINamespace(name: "const_ptr", scope: !35)
!158 = distinct !DILocation(line: 96, column: 31, scope: !147, inlinedAt: !126)
!159 = !DILocation(line: 970, column: 18, scope: !150, inlinedAt: !160)
!160 = distinct !DILocation(line: 98, column: 28, scope: !147, inlinedAt: !126)
!161 = !DILocation(line: 89, column: 19, scope: !123, inlinedAt: !126)
!162 = !DILocation(line: 0, scope: !57)
!163 = !DILocation(line: 0, scope: !52)
!164 = !DILocation(line: 733, column: 18, scope: !165, inlinedAt: !167)
!165 = distinct !DILexicalBlock(scope: !166, file: !155, line: 730, column: 9)
!166 = distinct !DISubprogram(name: "offset_from_unsigned<f64>", linkageName: "_RNvMNtNtCsjIpoRzUjyHQ_4core3ptr9const_ptrPd20offset_from_unsignedCsfFAnx7WYh7o_12evidence_lab", scope: !156, file: !155, line: 705, type: !15, scopeLine: 705, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !16)
!167 = distinct !DILocation(line: 892, column: 37, scope: !168, inlinedAt: !169)
!168 = distinct !DISubprogram(name: "offset_from_unsigned<f64>", linkageName: "_RNvMNtNtCsjIpoRzUjyHQ_4core3ptr7mut_ptrOd20offset_from_unsignedCsfFAnx7WYh7o_12evidence_lab", scope: !33, file: !32, line: 887, type: !15, scopeLine: 887, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !16)
!169 = distinct !DILocation(line: 146, column: 32, scope: !170, inlinedAt: !172)
!170 = distinct !DISubprogram(name: "drop<f64>", linkageName: "_RNvXs_NtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6stable5mergeINtB4_10MergeStatedENtNtNtBc_3ops4drop4Drop4dropCsfFAnx7WYh7o_12evidence_lab", scope: !171, file: !9, line: 139, type: !15, scopeLine: 139, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !16)
!171 = !DINamespace(name: "{impl#1}", scope: !10)
!172 = distinct !DILocation(line: 847, column: 1, scope: !173, inlinedAt: !174)
!173 = distinct !DISubprogram(name: "drop_glue<core::slice::sort::stable::merge::MergeState<f64>>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtNtNtB4_5slice4sort6stable5merge10MergeStatedEECsfFAnx7WYh7o_12evidence_lab", scope: !35, file: !50, line: 847, type: !15, scopeLine: 847, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !16)
!174 = distinct !DILocation(line: 62, column: 5, scope: !52)
!175 = !DILocation(line: 573, column: 14, scope: !176, inlinedAt: !177)
!176 = distinct !DISubprogram(name: "copy_nonoverlapping<f64>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3ptr19copy_nonoverlappingdECsfFAnx7WYh7o_12evidence_lab", scope: !35, file: !50, line: 552, type: !15, scopeLine: 552, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !16)
!177 = distinct !DILocation(line: 147, column: 13, scope: !178, inlinedAt: !172)
!178 = distinct !DILexicalBlock(scope: !170, file: !9, line: 146, column: 13)
!179 = !{!180, !182}
!180 = distinct !{!180, !181, !"_RNvXs_NtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6stable5mergeINtB4_10MergeStatedENtNtNtBc_3ops4drop4Drop4dropCsfFAnx7WYh7o_12evidence_lab: %self"}
!181 = distinct !{!181, !"_RNvXs_NtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6stable5mergeINtB4_10MergeStatedENtNtNtBc_3ops4drop4Drop4dropCsfFAnx7WYh7o_12evidence_lab"}
!182 = distinct !{!182, !183, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtNtNtB4_5slice4sort6stable5merge10MergeStatedEECsfFAnx7WYh7o_12evidence_lab: %_1"}
!183 = distinct !{!183, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtNtNtB4_5slice4sort6stable5merge10MergeStatedEECsfFAnx7WYh7o_12evidence_lab"}
!184 = !DILocation(line: 63, column: 2, scope: !8)
