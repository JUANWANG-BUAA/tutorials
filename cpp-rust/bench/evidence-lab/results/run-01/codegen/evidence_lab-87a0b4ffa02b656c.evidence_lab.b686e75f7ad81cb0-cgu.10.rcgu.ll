; ModuleID = 'evidence_lab.b686e75f7ad81cb0-cgu.10'
source_filename = "evidence_lab.b686e75f7ad81cb0-cgu.10"
target datalayout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx11.0.0"

; <&str as core::fmt::Debug>::fmt
; Function Attrs: uwtable
define hidden noundef zeroext i1 @_RNvXs1g_NtCsjIpoRzUjyHQ_4core3fmtReNtB6_5Debug3fmtCsfFAnx7WYh7o_12evidence_lab(ptr noalias nofree noundef readonly align 8 captures(none) dereferenceable(16) %self, ptr noalias nofree noundef align 8 dereferenceable(24) %f) unnamed_addr #0 !dbg !8 !guid !15 {
start:
  %_3.0 = load ptr, ptr %self, align 8, !dbg !16, !nonnull !14, !noundef !14
  %0 = getelementptr inbounds nuw i8, ptr %self, i64 8, !dbg !16
  %_3.1 = load i64, ptr %0, align 8, !dbg !16, !noundef !14
; call <str as core::fmt::Debug>::fmt
  %_0 = tail call noundef zeroext i1 @_RNvXsh_NtCsjIpoRzUjyHQ_4core3fmteNtB5_5Debug3fmt(ptr noalias nofree noundef nonnull readonly captures(address, read_provenance) %_3.0, i64 noundef %_3.1, ptr noalias nofree noundef nonnull align 8 dereferenceable(24) %f), !dbg !17
  ret i1 %_0, !dbg !18
}

; <&str as core::fmt::Display>::fmt
; Function Attrs: uwtable
define hidden noundef zeroext i1 @_RNvXs1i_NtCsjIpoRzUjyHQ_4core3fmtReNtB6_7Display3fmtCsfFAnx7WYh7o_12evidence_lab(ptr noalias nofree noundef readonly align 8 captures(none) dereferenceable(16) %self, ptr noalias nofree noundef align 8 dereferenceable(24) %f) unnamed_addr #0 !dbg !19 !guid !21 {
start:
  %_3.0 = load ptr, ptr %self, align 8, !dbg !22, !nonnull !14, !noundef !14
  %0 = getelementptr inbounds nuw i8, ptr %self, i64 8, !dbg !22
  %_3.1 = load i64, ptr %0, align 8, !dbg !22, !noundef !14
; call <str as core::fmt::Display>::fmt
  %_0 = tail call noundef zeroext i1 @_RNvXsi_NtCsjIpoRzUjyHQ_4core3fmteNtB5_7Display3fmt(ptr noalias nofree noundef nonnull readonly captures(address, read_provenance) %_3.0, i64 noundef %_3.1, ptr noalias nofree noundef nonnull align 8 dereferenceable(24) %f), !dbg !23
  ret i1 %_0, !dbg !24
}

; <str as core::fmt::Debug>::fmt
; Function Attrs: uwtable
declare noundef zeroext i1 @_RNvXsh_NtCsjIpoRzUjyHQ_4core3fmteNtB5_5Debug3fmt(ptr noalias nofree noundef nonnull readonly captures(address, read_provenance), i64 noundef, ptr noalias nofree noundef align 8 dereferenceable(24)) unnamed_addr #0

; <str as core::fmt::Display>::fmt
; Function Attrs: uwtable
declare noundef zeroext i1 @_RNvXsi_NtCsjIpoRzUjyHQ_4core3fmteNtB5_7Display3fmt(ptr noalias nofree noundef nonnull readonly captures(address, read_provenance), i64 noundef, ptr noalias nofree noundef align 8 dereferenceable(24)) unnamed_addr #0

attributes #0 = { uwtable "frame-pointer"="non-leaf" "probe-stack"="inline-asm" "target-cpu"="apple-m1" }

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
!7 = !DIFile(filename: "src/lib.rs/@/evidence_lab.b686e75f7ad81cb0-cgu.10", directory: "/Users/juanwang/Desktop/tutorials/cpp-rust/bench/evidence-lab")
!8 = distinct !DISubprogram(name: "fmt<str>", linkageName: "_RNvXs1g_NtCsjIpoRzUjyHQ_4core3fmtReNtB6_5Debug3fmtCsfFAnx7WYh7o_12evidence_lab", scope: !10, file: !9, line: 2872, type: !13, scopeLine: 2872, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !14)
!9 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/fmt/mod.rs", directory: "", checksumkind: CSK_MD5, checksum: "363229db3a4a2c778c00c76c7b1385ee")
!10 = !DINamespace(name: "{impl#80}", scope: !11)
!11 = !DINamespace(name: "fmt", scope: !12)
!12 = !DINamespace(name: "core", scope: null)
!13 = !DISubroutineType(types: !14)
!14 = !{}
!15 = !{i64 -6008249816552189645}
!16 = !DILocation(line: 2872, column: 71, scope: !8)
!17 = !DILocation(line: 2872, column: 62, scope: !8)
!18 = !DILocation(line: 2872, column: 84, scope: !8)
!19 = distinct !DISubprogram(name: "fmt<str>", linkageName: "_RNvXs1i_NtCsjIpoRzUjyHQ_4core3fmtReNtB6_7Display3fmtCsfFAnx7WYh7o_12evidence_lab", scope: !20, file: !9, line: 2872, type: !13, scopeLine: 2872, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !14)
!20 = !DINamespace(name: "{impl#82}", scope: !11)
!21 = !{i64 4826995004342723454}
!22 = !DILocation(line: 2872, column: 71, scope: !19)
!23 = !DILocation(line: 2872, column: 62, scope: !19)
!24 = !DILocation(line: 2872, column: 84, scope: !19)
