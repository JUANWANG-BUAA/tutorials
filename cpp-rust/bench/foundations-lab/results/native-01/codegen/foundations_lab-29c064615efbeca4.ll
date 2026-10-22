; ModuleID = 'foundations_lab.6b24031e890cfca9-cgu.0'
source_filename = "foundations_lab.6b24031e890cfca9-cgu.0"
target datalayout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx11.0.0"

@alloc_5de39d18515fe092b446bb19ff23c123 = private unnamed_addr constant [66 x i8] c"assertion failed: iterations > 0 && units > 0 && !cases.is_empty()", align 1, !guid !0
@alloc_466e6e10d4d5a95679ab35d1156aa54e = private unnamed_addr constant [11 x i8] c"src/lib.rs\00", align 1, !guid !1
@alloc_f2bcdb9f4fa7f3e13cc31482a008da11 = private unnamed_addr constant <{ ptr, [16 x i8] }> <{ ptr @alloc_466e6e10d4d5a95679ab35d1156aa54e, [16 x i8] c"\0A\00\00\00\00\00\00\00\10\00\00\00\05\00\00\00" }>, align 8, !guid !2
@alloc_cd06a0ae561541f4fa0774ab4b1e0414 = private unnamed_addr constant <{ ptr, [16 x i8] }> <{ ptr @alloc_466e6e10d4d5a95679ab35d1156aa54e, [16 x i8] c"\0A\00\00\00\00\00\00\00\15\00\00\00\0D\00\00\00" }>, align 8, !guid !3
@alloc_5056de034da4c34a3f4fa7a12e97d3ba = private unnamed_addr constant [46 x i8] c"kind,round,position,case,ns_per_unit,checksum\0A", align 1, !guid !4
@alloc_e6699520ce8c09b0659bfe6f8a4aab05 = private unnamed_addr constant [61 x i8] c"assertion failed: outputs.iter().all(|&v| v == case.expected)", align 1, !guid !5
@alloc_5cce360e8b0ee0340c5bd0936ac43b5f = private unnamed_addr constant <{ ptr, [16 x i8] }> <{ ptr @alloc_466e6e10d4d5a95679ab35d1156aa54e, [16 x i8] c"\0A\00\00\00\00\00\00\00\22\00\00\00\0D\00\00\00" }>, align 8, !guid !6
@alloc_b58200abb742684748e2915508e77244 = private unnamed_addr constant [27 x i8] c"\04raw,\C0\01,\C0\01,\C0\01,\C5 \00\00p\09\00\01,\C0\01\0A\00", align 1, !guid !7
@alloc_f3c5c97dd09f062403c0dcf5e142dc74 = private unnamed_addr constant <{ ptr, [16 x i8] }> <{ ptr @alloc_466e6e10d4d5a95679ab35d1156aa54e, [16 x i8] c"\0A\00\00\00\00\00\00\00\A7\00\00\00\05\00\00\00" }>, align 8, !guid !8

@_RNvCs9cj3cTKSYZx_15foundations_lab8sum_iter = unnamed_addr alias i64 (ptr, i64), ptr @_RNvCs9cj3cTKSYZx_15foundations_lab7sum_soa

; foundations_lab::run
; Function Attrs: uwtable
define void @_RNvCs9cj3cTKSYZx_15foundations_lab3run(ptr noalias nofree noundef nonnull align 8 %cases.0, i64 noundef range(i64 0, 230584300921369396) %cases.1, i64 noundef %iterations, i64 noundef %units) unnamed_addr #0 personality ptr @rust_eh_personality !dbg !17 !guid !22 {
start:
  %args = alloca [80 x i8], align 8
  %ns = alloca [8 x i8], align 8
  %_36 = alloca [8 x i8], align 8
  %start2 = alloca [16 x i8], align 8
  %position = alloca [8 x i8], align 8
  %round = alloca [8 x i8], align 8
  %_16 = alloca [8 x i8], align 8
  %start1 = alloca [16 x i8], align 8
  %_4 = icmp eq i64 %iterations, 0, !dbg !23
  %_5 = icmp eq i64 %units, 0
  %or.cond.not12 = or i1 %_4, %_5, !dbg !23
  %0 = icmp eq i64 %cases.1, 0
  %or.cond8 = or i1 %0, %or.cond.not12, !dbg !23
  br i1 %or.cond8, label %bb4, label %bb3, !dbg !23, !prof !24

bb4:                                              ; preds = %start
; call core::panicking::panic
  tail call void @_RNvNtCsjIpoRzUjyHQ_4core9panicking5panic(ptr noalias nofree noundef nonnull readonly captures(address, read_provenance) @alloc_5de39d18515fe092b446bb19ff23c123, i64 noundef 66, ptr noalias nofree noundef readonly align 8 captures(address, read_provenance) dereferenceable(24) @alloc_f2bcdb9f4fa7f3e13cc31482a008da11) #19, !dbg !25
  unreachable, !dbg !25

bb3:                                              ; preds = %start
  %_34.0.i.i = shl i64 %iterations, 3, !dbg !26
  %_34.1.i.i = icmp ugt i64 %iterations, 2305843009213693951, !dbg !26
  %_39.not.i.i = icmp ugt i64 %_34.0.i.i, 9223372036854775800
  %or.cond.i.i = or i1 %_34.1.i.i, %_39.not.i.i, !dbg !64
  br i1 %or.cond.i.i, label %bb14.i, label %bb18.i.i, !dbg !64, !prof !70

bb18.i.i:                                         ; preds = %bb3
  %1 = icmp eq i64 %_34.0.i.i, 0, !dbg !71
  br i1 %1, label %bb28.lr.ph, label %bb3.i2.i, !dbg !71

bb3.i2.i:                                         ; preds = %bb18.i.i
; call __rustc::__rust_no_alloc_shim_is_unstable_v2
  tail call void @_RNvCsdtSMxSA38aw_7___rustc35___rust_no_alloc_shim_is_unstable_v2() #20, !dbg !73, !noalias !74
; call __rustc::__rust_alloc_zeroed
  %2 = tail call noundef align 8 ptr @_RNvCsdtSMxSA38aw_7___rustc19___rust_alloc_zeroed(i64 noundef range(i64 1, -9223372036854775808) %_34.0.i.i, i64 noundef range(i64 1, 9) 8) #20, !dbg !79, !noalias !74
  %3 = icmp eq ptr %2, null, !dbg !94
  br i1 %3, label %bb14.i, label %bb10.i.i, !dbg !96

bb10.i.i:                                         ; preds = %bb3.i2.i
  %4 = ptrtoint ptr %2 to i64, !dbg !97
  br label %bb28.lr.ph, !dbg !99

bb14.i:                                           ; preds = %bb3.i2.i, %bb3
  %_16.sroa.4.0.ph.i = phi i64 [ 8, %bb3.i2.i ], [ 0, %bb3 ]
; call alloc::raw_vec::handle_error
  tail call void @_RNvNtCs6zY7rJBZy9D_5alloc7raw_vec12handle_error(i64 noundef %_16.sroa.4.0.ph.i, i64 %_34.0.i.i) #21, !dbg !100, !noalias !102
  unreachable, !dbg !100

bb28.lr.ph:                                       ; preds = %bb10.i.i, %bb18.i.i
  %_16.sroa.4.0.i = phi i64 [ %iterations, %bb10.i.i ], [ 0, %bb18.i.i ], !dbg !103
  %_16.sroa.10.0.i = phi i64 [ %4, %bb10.i.i ], [ 8, %bb18.i.i ]
  %5 = inttoptr i64 %_16.sroa.10.0.i to ptr, !dbg !104
  %_68.idx = mul nuw nsw i64 %cases.1, 40, !dbg !105
  %_68 = getelementptr inbounds nuw i8, ptr %cases.0, i64 %_68.idx, !dbg !105
  %6 = getelementptr inbounds nuw i8, ptr %start1, i64 8
  br label %bb28, !dbg !125

bb28:                                             ; preds = %bb28.lr.ph, %bb11
  %iter.sroa.0.030 = phi ptr [ %cases.0, %bb28.lr.ph ], [ %_81, %bb11 ]
  %_81 = getelementptr inbounds nuw i8, ptr %iter.sroa.0.030, i64 40, !dbg !134
  call void @llvm.lifetime.start.p0(ptr nonnull %start1), !dbg !140
; invoke <std::time::Instant>::now
  %7 = invoke { i64, i32 } @_RNvMNtCs1SSuMAdGM58_3std4timeNtB2_7Instant3now()
          to label %bb41 unwind label %cleanup.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp.loopexit, !dbg !142

bb27:                                             ; preds = %bb11
; invoke std::io::stdio::_print
  invoke void @_RNvNtNtCs1SSuMAdGM58_3std2io5stdio6__print(ptr noundef nonnull @alloc_5056de034da4c34a3f4fa7a12e97d3ba, ptr noundef nonnull inttoptr (i64 93 to ptr))
          to label %bb33.us.preheader unwind label %cleanup.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp, !dbg !143

bb33.us.preheader:                                ; preds = %bb27
  %8 = getelementptr inbounds nuw i8, ptr %start2, i64 8
  %_116 = getelementptr inbounds nuw i8, ptr %5, i64 %_34.0.i.i
  %_50 = mul i64 %units, %iterations
  %_49 = uitofp i64 %_50 to double
  %_59.sroa.4.0..sroa_idx = getelementptr inbounds nuw i8, ptr %args, i64 8
  %9 = getelementptr inbounds nuw i8, ptr %args, i64 16
  %_60.sroa.4.0..sroa_idx = getelementptr inbounds nuw i8, ptr %args, i64 24
  %10 = getelementptr inbounds nuw i8, ptr %args, i64 32
  %_61.sroa.4.0..sroa_idx = getelementptr inbounds nuw i8, ptr %args, i64 40
  %11 = getelementptr inbounds nuw i8, ptr %args, i64 48
  %_62.sroa.4.0..sroa_idx = getelementptr inbounds nuw i8, ptr %args, i64 56
  %12 = getelementptr inbounds nuw i8, ptr %args, i64 64
  %_63.sroa.4.0..sroa_idx = getelementptr inbounds nuw i8, ptr %args, i64 72
  %13 = add nsw i64 %_34.0.i.i, -8, !dbg !144
  %14 = lshr exact i64 %13, 3, !dbg !144
  %15 = add nuw nsw i64 %14, 1, !dbg !144
  %_12.i.us49 = icmp samesign eq i64 %_34.0.i.i, 0
  %xtraiter = and i64 %15, 3
  %lcmp.mod.not = icmp eq i64 %xtraiter, 0
  %16 = icmp ult i64 %13, 24
  br label %bb33.us, !dbg !144

bb33.us:                                          ; preds = %bb33.us.preheader, %bb14.bb36_crit_edge.us
  %iter4.sroa.0.035.us = phi i64 [ %17, %bb14.bb36_crit_edge.us ], [ 0, %bb33.us.preheader ]
  %17 = add nuw nsw i64 %iter4.sroa.0.035.us, 1, !dbg !159
  call void @llvm.lifetime.start.p0(ptr nonnull %round), !dbg !169
  store i64 %iter4.sroa.0.035.us, ptr %round, align 8, !dbg !169
  br label %bb35.us, !dbg !144

bb35.us:                                          ; preds = %bb33.us, %bb22.us
  %iter5.sroa.0.034.us = phi i64 [ 0, %bb33.us ], [ %18, %bb22.us ]
  %18 = add nuw nsw i64 %iter5.sroa.0.034.us, 1, !dbg !170
  call void @llvm.lifetime.start.p0(ptr nonnull %position), !dbg !176
  store i64 %iter5.sroa.0.034.us, ptr %position, align 8, !dbg !176
  %19 = load i64, ptr %round, align 8, !dbg !177, !noundef !21
  %_29.us = add i64 %19, %iter5.sroa.0.034.us, !dbg !177
  %index.us = urem i64 %_29.us, %cases.1, !dbg !177
  %case6.us = getelementptr inbounds nuw [40 x i8], ptr %cases.0, i64 %index.us, !dbg !179
  call void @llvm.lifetime.start.p0(ptr nonnull %start2), !dbg !181
; invoke <std::time::Instant>::now
  %20 = invoke { i64, i32 } @_RNvMNtCs1SSuMAdGM58_3std4timeNtB2_7Instant3now()
          to label %bb38.lr.ph.us unwind label %cleanup.loopexit.split-lp.loopexit.split.us, !dbg !183

bb38.us:                                          ; preds = %bb38.lr.ph.us, %bb39.us
  %iter3.sroa.0.032.us = phi ptr [ %5, %bb38.lr.ph.us ], [ %_129.us, %bb39.us ]
  call void @llvm.lifetime.start.p0(ptr nonnull %_36), !dbg !184
  %_132.0.us = load ptr, ptr %29, align 8, !dbg !188, !nonnull !21, !noundef !21
  %_132.1.us = load ptr, ptr %30, align 8, !dbg !188, !nonnull !21, !align !194, !noundef !21
  %21 = getelementptr inbounds nuw i8, ptr %_132.1.us, i64 32, !dbg !195
  %22 = load ptr, ptr %21, align 8, !dbg !195, !invariant.load !21, !nonnull !21
  %_37.us = invoke noundef i64 %22(ptr noundef nonnull %_132.0.us)
          to label %bb39.us unwind label %cleanup.loopexit.split.us, !dbg !195

bb39.us:                                          ; preds = %bb38.us
  %_129.us = getelementptr inbounds nuw i8, ptr %iter3.sroa.0.032.us, i64 8, !dbg !196
  store i64 %_37.us, ptr %_36, align 8, !dbg !205
  call void asm sideeffect "", "r,~{memory}"(ptr nonnull %_36) #20, !dbg !205, !srcloc !209
  %23 = load i64, ptr %_36, align 8, !dbg !210, !noundef !21
  store i64 %23, ptr %iter3.sroa.0.032.us, align 8, !dbg !210
  call void @llvm.lifetime.end.p0(ptr nonnull %_36), !dbg !211
  %_123.us = icmp eq ptr %_129.us, %_116, !dbg !212
  br i1 %_123.us, label %bb37.us, label %bb38.us, !dbg !216

bb37.us:                                          ; preds = %bb39.us
; invoke <std::time::Instant>::elapsed
  %24 = invoke { i64, i32 } @_RNvMNtCs1SSuMAdGM58_3std4timeNtB2_7Instant7elapsed(ptr noalias nofree noundef nonnull readonly align 8 captures(address, read_provenance) dereferenceable(16) %start2)
          to label %bb18.us unwind label %cleanup.loopexit.split-lp.loopexit.split.us, !dbg !217

bb18.us:                                          ; preds = %bb37.us
  %elapsed.0.us = extractvalue { i64, i32 } %24, 0, !dbg !218
  %elapsed.1.us = extractvalue { i64, i32 } %24, 1, !dbg !218
  %_44.us = getelementptr inbounds nuw i8, ptr %case6.us, i64 32, !dbg !219
  call void @llvm.experimental.noalias.scope.decl(metadata !221), !dbg !224
  %_4.i.i.us = load i64, ptr %_44.us, align 8, !alias.scope !221, !noalias !225
  br i1 %_12.i.us49, label %bb20.us, label %bb13.i.us.preheader, !dbg !227

bb13.i.us.preheader:                              ; preds = %bb18.us
  br i1 %lcmp.mod.not, label %bb13.i.us.prol.loopexit, label %bb13.i.us.prol, !dbg !236

bb13.i.us.prol:                                   ; preds = %bb13.i.us.preheader, %bb1.i.us.prol
  %_221.i.us50.prol = phi ptr [ %_22.i.us.prol, %bb1.i.us.prol ], [ %5, %bb13.i.us.preheader ]
  %prol.iter = phi i64 [ %prol.iter.next, %bb1.i.us.prol ], [ 0, %bb13.i.us.preheader ]
  %ptr.val.i.us.prol = load i64, ptr %_221.i.us50.prol, align 8, !dbg !236, !noalias !237, !noundef !21
  %_0.i.i.us.prol = icmp eq i64 %ptr.val.i.us.prol, %_4.i.i.us, !dbg !238
  br i1 %_0.i.i.us.prol, label %bb1.i.us.prol, label %bb21, !dbg !236

bb1.i.us.prol:                                    ; preds = %bb13.i.us.prol
  %_22.i.us.prol = getelementptr inbounds nuw i8, ptr %_221.i.us50.prol, i64 8, !dbg !243
  %prol.iter.next = add i64 %prol.iter, 1, !dbg !227
  %prol.iter.cmp.not = icmp eq i64 %prol.iter.next, %xtraiter, !dbg !227
  br i1 %prol.iter.cmp.not, label %bb13.i.us.prol.loopexit, label %bb13.i.us.prol, !dbg !227, !llvm.loop !246

bb13.i.us.prol.loopexit:                          ; preds = %bb1.i.us.prol, %bb13.i.us.preheader
  %_221.i.us50.unr = phi ptr [ %5, %bb13.i.us.preheader ], [ %_22.i.us.prol, %bb1.i.us.prol ]
  br i1 %16, label %bb20.us, label %bb13.i.us, !dbg !236

bb1.i.us:                                         ; preds = %bb13.i.us
  %_22.i.us = getelementptr inbounds nuw i8, ptr %_221.i.us50, i64 8, !dbg !243
  %ptr.val.i.us.1 = load i64, ptr %_22.i.us, align 8, !dbg !236, !noalias !237, !noundef !21
  %_0.i.i.us.1 = icmp eq i64 %ptr.val.i.us.1, %_4.i.i.us, !dbg !238
  br i1 %_0.i.i.us.1, label %bb1.i.us.1, label %bb21, !dbg !236

bb1.i.us.1:                                       ; preds = %bb1.i.us
  %_22.i.us.1 = getelementptr inbounds nuw i8, ptr %_221.i.us50, i64 16, !dbg !243
  %ptr.val.i.us.2 = load i64, ptr %_22.i.us.1, align 8, !dbg !236, !noalias !237, !noundef !21
  %_0.i.i.us.2 = icmp eq i64 %ptr.val.i.us.2, %_4.i.i.us, !dbg !238
  br i1 %_0.i.i.us.2, label %bb1.i.us.2, label %bb21, !dbg !236

bb1.i.us.2:                                       ; preds = %bb1.i.us.1
  %_22.i.us.2 = getelementptr inbounds nuw i8, ptr %_221.i.us50, i64 24, !dbg !243
  %ptr.val.i.us.3 = load i64, ptr %_22.i.us.2, align 8, !dbg !236, !noalias !237, !noundef !21
  %_0.i.i.us.3 = icmp eq i64 %ptr.val.i.us.3, %_4.i.i.us, !dbg !238
  br i1 %_0.i.i.us.3, label %bb1.i.us.3, label %bb21, !dbg !236

bb1.i.us.3:                                       ; preds = %bb1.i.us.2
  %_22.i.us.3 = getelementptr inbounds nuw i8, ptr %_221.i.us50, i64 32, !dbg !243
  %_12.i.us.3 = icmp eq ptr %_22.i.us.3, %_116, !dbg !248
  br i1 %_12.i.us.3, label %bb20.us, label %bb13.i.us, !dbg !227

bb13.i.us:                                        ; preds = %bb13.i.us.prol.loopexit, %bb1.i.us.3
  %_221.i.us50 = phi ptr [ %_22.i.us.3, %bb1.i.us.3 ], [ %_221.i.us50.unr, %bb13.i.us.prol.loopexit ]
  %ptr.val.i.us = load i64, ptr %_221.i.us50, align 8, !dbg !236, !noalias !237, !noundef !21
  %_0.i.i.us = icmp eq i64 %ptr.val.i.us, %_4.i.i.us, !dbg !238
  br i1 %_0.i.i.us, label %bb1.i.us, label %bb21, !dbg !236

bb20.us:                                          ; preds = %bb13.i.us.prol.loopexit, %bb1.i.us.3, %bb18.us
  call void @llvm.lifetime.start.p0(ptr nonnull %ns), !dbg !251
  %_145.us = uitofp i64 %elapsed.0.us to double, !dbg !252
  %25 = icmp ult i32 %elapsed.1.us, 1000000000, !dbg !258
  call void @llvm.assume(i1 %25), !dbg !258
  %_148.us = uitofp nneg i32 %elapsed.1.us to double, !dbg !264
  %_147.us = fdiv nnan double %_148.us, 1.000000e+09, !dbg !264
  %_48.us = fadd nnan double %_147.us, %_145.us, !dbg !252
  %_47.us = fmul nnan double %_48.us, 1.000000e+09, !dbg !265
  %26 = fdiv double %_47.us, %_49, !dbg !265
  store double %26, ptr %ns, align 8, !dbg !265
  call void @llvm.lifetime.start.p0(ptr nonnull %args), !dbg !266
  store ptr %round, ptr %args, align 8, !dbg !266
  store ptr @_RNvXsi_NtNtNtCsjIpoRzUjyHQ_4core3fmt3num3impjNtB9_7Display3fmt, ptr %_59.sroa.4.0..sroa_idx, align 8, !dbg !266
  store ptr %position, ptr %9, align 8, !dbg !266
  store ptr @_RNvXsi_NtNtNtCsjIpoRzUjyHQ_4core3fmt3num3impjNtB9_7Display3fmt, ptr %_60.sroa.4.0..sroa_idx, align 8, !dbg !266
  store ptr %case6.us, ptr %10, align 8, !dbg !266
  store ptr @_RNvXs1i_NtCsjIpoRzUjyHQ_4core3fmtReNtB6_7Display3fmtCs9cj3cTKSYZx_15foundations_lab, ptr %_61.sroa.4.0..sroa_idx, align 8, !dbg !266
  store ptr %ns, ptr %11, align 8, !dbg !266
  store ptr @_RNvXs7_NtNtCsjIpoRzUjyHQ_4core3fmt5floatdNtB7_7Display3fmt, ptr %_62.sroa.4.0..sroa_idx, align 8, !dbg !266
  store ptr %_44.us, ptr %12, align 8, !dbg !266
  store ptr @_RNvXsd_NtNtNtCsjIpoRzUjyHQ_4core3fmt3num3impyNtB9_7Display3fmt, ptr %_63.sroa.4.0..sroa_idx, align 8, !dbg !266
; invoke std::io::stdio::_print
  invoke void @_RNvNtNtCs1SSuMAdGM58_3std2io5stdio6__print(ptr noundef nonnull @alloc_b58200abb742684748e2915508e77244, ptr noundef nonnull %args)
          to label %bb22.us unwind label %cleanup.loopexit.split-lp.loopexit.split.us, !dbg !271

bb22.us:                                          ; preds = %bb20.us
  call void @llvm.lifetime.end.p0(ptr nonnull %args), !dbg !271
  call void @llvm.lifetime.end.p0(ptr nonnull %ns), !dbg !272
  call void @llvm.lifetime.end.p0(ptr nonnull %start2), !dbg !273
  call void @llvm.lifetime.end.p0(ptr nonnull %position), !dbg !274
  %exitcond.not = icmp eq i64 %18, %cases.1, !dbg !275
  br i1 %exitcond.not, label %bb14.bb36_crit_edge.us, label %bb35.us, !dbg !144

bb38.lr.ph.us:                                    ; preds = %bb35.us
  %27 = extractvalue { i64, i32 } %20, 0, !dbg !183
  %28 = extractvalue { i64, i32 } %20, 1, !dbg !183
  store i64 %27, ptr %start2, align 8, !dbg !183
  store i32 %28, ptr %8, align 8, !dbg !183
  %29 = getelementptr inbounds nuw i8, ptr %case6.us, i64 16
  %30 = getelementptr inbounds nuw i8, ptr %case6.us, i64 24
  br label %bb38.us, !dbg !216

bb14.bb36_crit_edge.us:                           ; preds = %bb22.us
  call void @llvm.lifetime.end.p0(ptr nonnull %round), !dbg !283
  %exitcond41.not = icmp eq i64 %17, 21, !dbg !284
  br i1 %exitcond41.not, label %bb34, label %bb33.us, !dbg !285

cleanup.loopexit.split-lp.loopexit.split.us:      ; preds = %bb20.us, %bb37.us, %bb35.us
  %lpad.loopexit21.us = landingpad { ptr, i32 }
          cleanup
  br label %cleanup

cleanup.loopexit.split.us:                        ; preds = %bb38.us
  %lpad.loopexit.us = landingpad { ptr, i32 }
          cleanup
  br label %cleanup

cleanup.loopexit.split-lp.loopexit.split-lp.loopexit: ; preds = %bb6, %bb8
  %lpad.loopexit24 = landingpad { ptr, i32 }
          cleanup
  br label %cleanup

cleanup.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp.loopexit: ; preds = %bb28
  %lpad.loopexit26 = landingpad { ptr, i32 }
          cleanup
  br label %cleanup

cleanup.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp: ; preds = %bb21, %bb27, %bb10
  %lpad.loopexit.split-lp27 = landingpad { ptr, i32 }
          cleanup
  br label %cleanup

cleanup:                                          ; preds = %cleanup.loopexit.split-lp.loopexit.split.us, %cleanup.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp.loopexit, %cleanup.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp, %cleanup.loopexit.split-lp.loopexit.split-lp.loopexit, %cleanup.loopexit.split.us
  %lpad.phi = phi { ptr, i32 } [ %lpad.loopexit.us, %cleanup.loopexit.split.us ], [ %lpad.loopexit21.us, %cleanup.loopexit.split-lp.loopexit.split.us ], [ %lpad.loopexit24, %cleanup.loopexit.split-lp.loopexit.split-lp.loopexit ], [ %lpad.loopexit26, %cleanup.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp.loopexit ], [ %lpad.loopexit.split-lp27, %cleanup.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp ]
  %31 = icmp eq i64 %_16.sroa.4.0.i, 0, !dbg !286
  br i1 %31, label %bb25, label %bb2.i.i.i4.i, !dbg !286

bb2.i.i.i4.i:                                     ; preds = %cleanup
  %alloc_size.i.i.i.i5.i = shl nuw i64 %_16.sroa.4.0.i, 3, !dbg !300
  call void @llvm.assume(i1 true) [ "nonnull"(ptr %5) ]
; call __rustc::__rust_dealloc
  call void @_RNvCsdtSMxSA38aw_7___rustc14___rust_dealloc(ptr noundef nonnull %5, i64 noundef %alloc_size.i.i.i.i5.i, i64 noundef range(i64 1, -9223372036854775807) 8) #20, !dbg !303
  br label %bb25, !dbg !312

bb41:                                             ; preds = %bb28
  %32 = extractvalue { i64, i32 } %7, 0, !dbg !142
  %33 = extractvalue { i64, i32 } %7, 1, !dbg !142
  store i64 %32, ptr %start1, align 8, !dbg !142
  store i32 %33, ptr %6, align 8, !dbg !142
  %34 = getelementptr inbounds nuw i8, ptr %iter.sroa.0.030, i64 16
  %35 = getelementptr inbounds nuw i8, ptr %iter.sroa.0.030, i64 24
  %right_val = getelementptr inbounds nuw i8, ptr %iter.sroa.0.030, i64 32
  br label %bb6, !dbg !142

bb6:                                              ; preds = %bb9, %bb41
; invoke <std::time::Instant>::elapsed
  %36 = invoke { i64, i32 } @_RNvMNtCs1SSuMAdGM58_3std4timeNtB2_7Instant7elapsed(ptr noalias nofree noundef nonnull readonly align 8 captures(address, read_provenance) dereferenceable(16) %start1)
          to label %bb7 unwind label %cleanup.loopexit.split-lp.loopexit.split-lp.loopexit, !dbg !313

bb7:                                              ; preds = %bb6
  %_13.0 = extractvalue { i64, i32 } %36, 0, !dbg !315
  %37 = icmp eq i64 %_13.0, 0, !dbg !316
  br i1 %37, label %bb30, label %bb11, !dbg !316

bb30:                                             ; preds = %bb7
  %_13.1 = extractvalue { i64, i32 } %36, 1, !dbg !315
  %38 = icmp ult i32 %_13.1, 1000000000, !dbg !325
  call void @llvm.assume(i1 %38), !dbg !325
  %39 = icmp samesign ult i32 %_13.1, 500000000, !dbg !331
  br i1 %39, label %bb8, label %bb11, !dbg !315

bb11:                                             ; preds = %bb7, %bb30
  call void @llvm.lifetime.end.p0(ptr nonnull %start1), !dbg !347
  %_75 = icmp eq ptr %_81, %_68, !dbg !348
  br i1 %_75, label %bb27, label %bb28, !dbg !125

bb8:                                              ; preds = %bb30
  call void @llvm.lifetime.start.p0(ptr nonnull %_16), !dbg !350
  %_101.0 = load ptr, ptr %34, align 8, !dbg !351, !nonnull !21, !noundef !21
  %_101.1 = load ptr, ptr %35, align 8, !dbg !351, !nonnull !21, !align !194, !noundef !21
  %40 = getelementptr inbounds nuw i8, ptr %_101.1, i64 32, !dbg !353
  %41 = load ptr, ptr %40, align 8, !dbg !353, !invariant.load !21, !nonnull !21
  %_17 = invoke noundef i64 %41(ptr noundef nonnull %_101.0)
          to label %bb31 unwind label %cleanup.loopexit.split-lp.loopexit.split-lp.loopexit, !dbg !353

bb31:                                             ; preds = %bb8
  store i64 %_17, ptr %_16, align 8, !dbg !354
  call void asm sideeffect "", "r,~{memory}"(ptr nonnull %_16) #20, !dbg !354, !srcloc !209
  %_20 = load i64, ptr %right_val, align 8, !dbg !355, !noundef !21
  %42 = load i64, ptr %_16, align 8, !dbg !355, !noundef !21
  %_19 = icmp eq i64 %42, %_20, !dbg !355
  br i1 %_19, label %bb9, label %bb10, !dbg !355, !prof !359

bb10:                                             ; preds = %bb31
; invoke core::panicking::assert_failed::<u64, u64>
  invoke void @_RINvNtCsjIpoRzUjyHQ_4core9panicking13assert_failedyyEB4_(i8 noundef 0, ptr noalias nofree noundef nonnull readonly align 8 captures(address, read_provenance) dereferenceable(8) %_16, ptr noalias nofree noundef nonnull readonly align 8 captures(address, read_provenance) dereferenceable(8) %right_val, ptr noundef null, ptr undef, ptr noalias nofree noundef readonly align 8 captures(address, read_provenance) dereferenceable(24) @alloc_cd06a0ae561541f4fa0774ab4b1e0414) #21
          to label %unreachable unwind label %cleanup.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp, !dbg !360

bb9:                                              ; preds = %bb31
  call void @llvm.lifetime.end.p0(ptr nonnull %_16), !dbg !363
  br label %bb6, !dbg !364

unreachable:                                      ; preds = %bb21, %bb10
  unreachable

bb34:                                             ; preds = %bb14.bb36_crit_edge.us
  %43 = icmp eq i64 %_16.sroa.4.0.i, 0, !dbg !365
  br i1 %43, label %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc3vec3VecyEECs9cj3cTKSYZx_15foundations_lab.exit18, label %bb2.i.i.i4.i16, !dbg !365

bb2.i.i.i4.i16:                                   ; preds = %bb34
  %alloc_size.i.i.i.i5.i17 = shl nuw i64 %_16.sroa.4.0.i, 3, !dbg !371
  call void @llvm.assume(i1 true) [ "nonnull"(ptr %5) ]
; call __rustc::__rust_dealloc
  call void @_RNvCsdtSMxSA38aw_7___rustc14___rust_dealloc(ptr noundef nonnull %5, i64 noundef %alloc_size.i.i.i.i5.i17, i64 noundef range(i64 1, -9223372036854775807) 8) #20, !dbg !373
  br label %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc3vec3VecyEECs9cj3cTKSYZx_15foundations_lab.exit18, !dbg !378

_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc3vec3VecyEECs9cj3cTKSYZx_15foundations_lab.exit18: ; preds = %bb34, %bb2.i.i.i4.i16
  ret void, !dbg !379

bb21:                                             ; preds = %bb13.i.us.prol, %bb13.i.us, %bb1.i.us, %bb1.i.us.1, %bb1.i.us.2
; invoke core::panicking::panic
  invoke void @_RNvNtCsjIpoRzUjyHQ_4core9panicking5panic(ptr noalias nofree noundef nonnull readonly captures(address, read_provenance) @alloc_e6699520ce8c09b0659bfe6f8a4aab05, i64 noundef 61, ptr noalias nofree noundef readonly align 8 captures(address, read_provenance) dereferenceable(24) @alloc_5cce360e8b0ee0340c5bd0936ac43b5f) #21
          to label %unreachable unwind label %cleanup.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp.loopexit.split-lp, !dbg !380

bb25:                                             ; preds = %bb2.i.i.i4.i, %cleanup
  resume { ptr, i32 } %lpad.phi, !dbg !381
}

; foundations_lab::data
; Function Attrs: uwtable
define void @_RNvCs9cj3cTKSYZx_15foundations_lab4data(ptr dead_on_unwind noalias nofree noundef writable writeonly sret([24 x i8]) align 8 captures(none) dereferenceable(24) %_0, i64 noundef %n) unnamed_addr #0 personality ptr @rust_eh_personality !dbg !382 !guid !383 {
start:
  tail call void @llvm.experimental.noalias.scope.decl(metadata !384), !dbg !387
  %_34.0.i.i.i = shl i64 %n, 3, !dbg !402
  %_34.1.i.i.i = icmp ugt i64 %n, 2305843009213693951, !dbg !402
  %_39.not.i.i.i = icmp ugt i64 %_34.0.i.i.i, 9223372036854775800
  %or.cond.i.i.i = or i1 %_34.1.i.i.i, %_39.not.i.i.i, !dbg !423
  br i1 %or.cond.i.i.i, label %bb3.i.i, label %bb18.i.i.i, !dbg !423, !prof !70

bb18.i.i.i:                                       ; preds = %start
  %0 = icmp eq i64 %_34.0.i.i.i, 0, !dbg !425
  br i1 %0, label %_RNvMs_NtCs6zY7rJBZy9D_5alloc3vecINtB4_3VecyE7reserveCs9cj3cTKSYZx_15foundations_lab.exit.i.i.i, label %bb3.i.i.i, !dbg !425

bb3.i.i.i:                                        ; preds = %bb18.i.i.i
; call __rustc::__rust_no_alloc_shim_is_unstable_v2
  tail call void @_RNvCsdtSMxSA38aw_7___rustc35___rust_no_alloc_shim_is_unstable_v2() #20, !dbg !426, !noalias !427
; call __rustc::__rust_alloc
  %1 = tail call noundef align 8 ptr @_RNvCsdtSMxSA38aw_7___rustc12___rust_alloc(i64 noundef range(i64 0, -9223372036854775808) %_34.0.i.i.i, i64 noundef range(i64 1, 9) 8) #20, !dbg !430, !noalias !427
  %2 = icmp eq ptr %1, null, !dbg !438
  br i1 %2, label %bb3.i.i, label %bb10.i.i.i, !dbg !439

bb10.i.i.i:                                       ; preds = %bb3.i.i.i
  %3 = ptrtoint ptr %1 to i64, !dbg !440
  br label %_RNvMs_NtCs6zY7rJBZy9D_5alloc3vecINtB4_3VecyE7reserveCs9cj3cTKSYZx_15foundations_lab.exit.i.i.i, !dbg !441

bb3.i.i:                                          ; preds = %bb3.i.i.i, %start
  %_4.sroa.4.0.ph.i.i = phi i64 [ 8, %bb3.i.i.i ], [ 0, %start ]
; call alloc::raw_vec::handle_error
  tail call void @_RNvNtCs6zY7rJBZy9D_5alloc7raw_vec12handle_error(i64 noundef %_4.sroa.4.0.ph.i.i, i64 %_34.0.i.i.i) #21, !dbg !442, !noalias !384
  unreachable, !dbg !442

_RNvMs_NtCs6zY7rJBZy9D_5alloc3vecINtB4_3VecyE7reserveCs9cj3cTKSYZx_15foundations_lab.exit.i.i.i: ; preds = %bb10.i.i.i, %bb18.i.i.i
  %_4.sroa.4.0.i.i = phi i64 [ %n, %bb10.i.i.i ], [ 0, %bb18.i.i.i ], !dbg !444
  %_4.sroa.10.0.i.i = phi i64 [ %3, %bb10.i.i.i ], [ 8, %bb18.i.i.i ]
  %4 = inttoptr i64 %_4.sroa.10.0.i.i to ptr, !dbg !445
  %_7.i.i = icmp samesign ule i64 %n, %_4.sroa.4.0.i.i, !dbg !446
  tail call void @llvm.assume(i1 %_7.i.i), !dbg !450
  %_0.i.i.i10.not.i.i.i.i.i.i = icmp eq i64 %n, 0, !dbg !453
  br i1 %_0.i.i.i10.not.i.i.i.i.i.i, label %_RNvXs_NtNtCs6zY7rJBZy9D_5alloc3vec21spec_from_iter_nestedINtB6_3VecyEINtB4_18SpecFromIterNestedyINtNtNtNtCsjIpoRzUjyHQ_4core4iter8adapters3map3MapINtNtNtB1F_3ops5range5RangejENCNvCs9cj3cTKSYZx_15foundations_lab4data0EE9from_iterB2R_.exit, label %bb3.i.i.i.i.i.i.preheader, !dbg !484

bb3.i.i.i.i.i.i.preheader:                        ; preds = %_RNvMs_NtCs6zY7rJBZy9D_5alloc3vecINtB4_3VecyE7reserveCs9cj3cTKSYZx_15foundations_lab.exit.i.i.i
  %min.iters.check = icmp ult i64 %n, 4, !dbg !484
  br i1 %min.iters.check, label %bb3.i.i.i.i.i.i.preheader1, label %vector.ph, !dbg !484

vector.ph:                                        ; preds = %bb3.i.i.i.i.i.i.preheader
  %n.vec = and i64 %n, 2305843009213693948
  br label %vector.body, !dbg !484

vector.body:                                      ; preds = %vector.body, %vector.ph
  %index = phi i64 [ 0, %vector.ph ], [ %index.next, %vector.body ], !dbg !485
  %5 = or disjoint i64 %index, 1, !dbg !485
  %6 = or disjoint i64 %index, 2, !dbg !485
  %7 = or disjoint i64 %index, 3, !dbg !485
  %8 = mul i64 %index, 17, !dbg !491
  %9 = mul i64 %5, 17, !dbg !491
  %10 = mul i64 %6, 17, !dbg !491
  %11 = mul i64 %7, 17, !dbg !491
  %12 = xor i64 %8, 23130, !dbg !501
  %13 = xor i64 %9, 23130, !dbg !501
  %14 = xor i64 %10, 23130, !dbg !501
  %15 = xor i64 %11, 23130, !dbg !501
  %16 = getelementptr inbounds nuw [8 x i8], ptr %4, i64 %index, !dbg !502
  %17 = getelementptr inbounds nuw [8 x i8], ptr %4, i64 %5, !dbg !502
  %18 = getelementptr inbounds nuw [8 x i8], ptr %4, i64 %6, !dbg !502
  %19 = getelementptr inbounds nuw [8 x i8], ptr %4, i64 %7, !dbg !502
  store i64 %12, ptr %16, align 8, !dbg !513, !noalias !516
  store i64 %13, ptr %17, align 8, !dbg !513, !noalias !516
  store i64 %14, ptr %18, align 8, !dbg !513, !noalias !516
  store i64 %15, ptr %19, align 8, !dbg !513, !noalias !516
  %index.next = add nuw i64 %index, 4, !dbg !485
  %20 = icmp eq i64 %index.next, %n.vec, !dbg !484
  br i1 %20, label %middle.block, label %vector.body, !dbg !484, !llvm.loop !533

middle.block:                                     ; preds = %vector.body
  %cmp.n = icmp eq i64 %n, %n.vec, !dbg !484
  br i1 %cmp.n, label %_RNvXs_NtNtCs6zY7rJBZy9D_5alloc3vec21spec_from_iter_nestedINtB6_3VecyEINtB4_18SpecFromIterNestedyINtNtNtNtCsjIpoRzUjyHQ_4core4iter8adapters3map3MapINtNtNtB1F_3ops5range5RangejENCNvCs9cj3cTKSYZx_15foundations_lab4data0EE9from_iterB2R_.exit, label %bb3.i.i.i.i.i.i.preheader1, !dbg !484

bb3.i.i.i.i.i.i.preheader1:                       ; preds = %bb3.i.i.i.i.i.i.preheader, %middle.block
  %.ph = phi i64 [ 0, %bb3.i.i.i.i.i.i.preheader ], [ %n.vec, %middle.block ]
  br label %bb3.i.i.i.i.i.i, !dbg !484

bb3.i.i.i.i.i.i:                                  ; preds = %bb3.i.i.i.i.i.i.preheader1, %bb3.i.i.i.i.i.i
  %21 = phi i64 [ %22, %bb3.i.i.i.i.i.i ], [ %.ph, %bb3.i.i.i.i.i.i.preheader1 ], !dbg !485
  %22 = add nuw i64 %21, 1, !dbg !536
  %_3.i.i.i.i.i.i.i.i = mul i64 %21, 17, !dbg !491
  %_0.i.i.i.i.i.i.i.i = xor i64 %_3.i.i.i.i.i.i.i.i, 23130, !dbg !501
  %_3.i.i.i6.i.i.i.i.i.i = getelementptr inbounds nuw [8 x i8], ptr %4, i64 %21, !dbg !502
  store i64 %_0.i.i.i.i.i.i.i.i, ptr %_3.i.i.i6.i.i.i.i.i.i, align 8, !dbg !513, !noalias !516
  %exitcond.not.i.i.i.i.i.i = icmp eq i64 %22, %n, !dbg !453
  br i1 %exitcond.not.i.i.i.i.i.i, label %_RNvXs_NtNtCs6zY7rJBZy9D_5alloc3vec21spec_from_iter_nestedINtB6_3VecyEINtB4_18SpecFromIterNestedyINtNtNtNtCsjIpoRzUjyHQ_4core4iter8adapters3map3MapINtNtNtB1F_3ops5range5RangejENCNvCs9cj3cTKSYZx_15foundations_lab4data0EE9from_iterB2R_.exit, label %bb3.i.i.i.i.i.i, !dbg !484, !llvm.loop !542

_RNvXs_NtNtCs6zY7rJBZy9D_5alloc3vec21spec_from_iter_nestedINtB6_3VecyEINtB4_18SpecFromIterNestedyINtNtNtNtCsjIpoRzUjyHQ_4core4iter8adapters3map3MapINtNtNtB1F_3ops5range5RangejENCNvCs9cj3cTKSYZx_15foundations_lab4data0EE9from_iterB2R_.exit: ; preds = %bb3.i.i.i.i.i.i, %middle.block, %_RNvMs_NtCs6zY7rJBZy9D_5alloc3vecINtB4_3VecyE7reserveCs9cj3cTKSYZx_15foundations_lab.exit.i.i.i
  store i64 %_4.sroa.4.0.i.i, ptr %_0, align 8, !dbg !543, !alias.scope !384
  %vector.sroa.4.0._0.sroa_idx.i = getelementptr inbounds nuw i8, ptr %_0, i64 8, !dbg !543
  store ptr %4, ptr %vector.sroa.4.0._0.sroa_idx.i, align 8, !dbg !543, !alias.scope !384
  %vector.sroa.6.0._0.sroa_idx.i = getelementptr inbounds nuw i8, ptr %_0, i64 16, !dbg !543
  store i64 %n, ptr %vector.sroa.6.0._0.sroa_idx.i, align 8, !dbg !543, !alias.scope !384
  ret void, !dbg !544
}

; foundations_lab::cloned
; Function Attrs: noinline uwtable
define noundef i64 @_RNvCs9cj3cTKSYZx_15foundations_lab6cloned(ptr noalias nofree noundef nonnull readonly align 8 captures(none) %input.0, i64 noundef range(i64 0, 1152921504606846976) %input.1) unnamed_addr #1 personality ptr @rust_eh_personality !dbg !545 !guid !546 {
start:
  %_3 = alloca [16 x i8], align 8
  %0 = shl nuw nsw i64 %input.1, 3, !dbg !547
  %1 = icmp eq i64 %input.1, 0, !dbg !571
  br i1 %1, label %bb6, label %bb3.i, !dbg !571

bb3.i:                                            ; preds = %start
; call __rustc::__rust_no_alloc_shim_is_unstable_v2
  tail call void @_RNvCsdtSMxSA38aw_7___rustc35___rust_no_alloc_shim_is_unstable_v2() #20, !dbg !572, !noalias !573
; call __rustc::__rust_alloc
  %2 = tail call noundef align 8 ptr @_RNvCsdtSMxSA38aw_7___rustc12___rust_alloc(i64 noundef range(i64 0, -9223372036854775808) %0, i64 noundef range(i64 1, 9) 8) #20, !dbg !576, !noalias !573
  %3 = icmp eq ptr %2, null, !dbg !581
  br i1 %3, label %bb9, label %bb5, !dbg !582

bb9:                                              ; preds = %bb3.i
; call alloc::raw_vec::handle_error
  tail call void @_RNvNtCs6zY7rJBZy9D_5alloc7raw_vec12handle_error(i64 noundef 8, i64 %0) #21, !dbg !583
  unreachable, !dbg !583

bb6:                                              ; preds = %start, %bb5
  %4 = phi ptr [ %2, %bb5 ], [ inttoptr (i64 8 to ptr), %start ]
  call void @llvm.lifetime.start.p0(ptr nonnull %_3), !dbg !585
  store ptr %4, ptr %_3, align 8, !dbg !587
  %5 = getelementptr inbounds nuw i8, ptr %_3, i64 8, !dbg !587
  store i64 %input.1, ptr %5, align 8, !dbg !587
  call void asm sideeffect "", "r,~{memory}"(ptr nonnull %_3) #20, !dbg !587, !srcloc !209
  %6 = load ptr, ptr %_3, align 8, !dbg !589, !nonnull !21, !align !194, !noundef !21
  %7 = load i64, ptr %5, align 8, !dbg !589, !noundef !21
; call foundations_lab::sum_soa
  %_0 = call noundef i64 @_RNvCs9cj3cTKSYZx_15foundations_lab7sum_soa(ptr noalias nofree noundef nonnull readonly align 8 captures(address, read_provenance) %6, i64 noundef %7), !dbg !589
  call void @llvm.lifetime.end.p0(ptr nonnull %_3), !dbg !590
  %8 = icmp eq i64 %input.1, 0, !dbg !591
  br i1 %8, label %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc3vec3VecyEECs9cj3cTKSYZx_15foundations_lab.exit6, label %bb2.i.i.i4.i4, !dbg !591

bb5:                                              ; preds = %bb3.i
  tail call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 8 %2, ptr nonnull align 8 %input.0, i64 %0, i1 false), !dbg !597
  br label %bb6, !dbg !606

bb2.i.i.i4.i4:                                    ; preds = %bb6
  %alloc_size.i.i.i.i5.i5 = shl nuw nsw i64 %input.1, 3, !dbg !607
; call __rustc::__rust_dealloc
  call void @_RNvCsdtSMxSA38aw_7___rustc14___rust_dealloc(ptr noundef nonnull %4, i64 noundef %alloc_size.i.i.i.i5.i5, i64 noundef range(i64 1, -9223372036854775807) 8) #20, !dbg !609
  br label %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc3vec3VecyEECs9cj3cTKSYZx_15foundations_lab.exit6, !dbg !614

_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc3vec3VecyEECs9cj3cTKSYZx_15foundations_lab.exit6: ; preds = %bb6, %bb2.i.i.i4.i4
  ret i64 %_0, !dbg !615
}

; foundations_lab::sum_aos
; Function Attrs: nofree noinline norecurse nosync nounwind memory(argmem: read) uwtable
define noundef i64 @_RNvCs9cj3cTKSYZx_15foundations_lab7sum_aos(ptr noalias nofree noundef nonnull readonly align 8 captures(none) %input.0, i64 noundef range(i64 0, 144115188075855872) %input.1) unnamed_addr #2 personality ptr @rust_eh_personality !dbg !616 !guid !617 {
start:
  %0 = icmp eq i64 %input.1, 0, !dbg !618
  br i1 %0, label %_RINvXs2J_NtNtCsjIpoRzUjyHQ_4core5slice4iterINtB7_4IterNtCs9cj3cTKSYZx_15foundations_lab6RecordENtNtNtNtBb_4iter6traits8iterator8Iterator4foldyNCNvBS_7sum_aos0EBS_.exit, label %bb8.i.preheader, !dbg !625

bb8.i.preheader:                                  ; preds = %start
  %min.iters.check = icmp samesign ult i64 %input.1, 4, !dbg !626
  br i1 %min.iters.check, label %bb8.i.preheader6, label %vector.ph, !dbg !626

vector.ph:                                        ; preds = %bb8.i.preheader
  %n.vec = and i64 %input.1, 144115188075855868
  br label %vector.body, !dbg !626

vector.body:                                      ; preds = %vector.body, %vector.ph
  %index = phi i64 [ 0, %vector.ph ], [ %index.next, %vector.body ], !dbg !630
  %vec.phi = phi i64 [ 0, %vector.ph ], [ %12, %vector.body ]
  %vec.phi1 = phi i64 [ 0, %vector.ph ], [ %13, %vector.body ]
  %vec.phi2 = phi i64 [ 0, %vector.ph ], [ %14, %vector.body ]
  %vec.phi3 = phi i64 [ 0, %vector.ph ], [ %15, %vector.body ]
  %1 = getelementptr inbounds nuw [64 x i8], ptr %input.0, i64 %index, !dbg !631
  %2 = getelementptr inbounds nuw [64 x i8], ptr %input.0, i64 %index, !dbg !631
  %3 = getelementptr inbounds nuw i8, ptr %2, i64 64, !dbg !631
  %4 = getelementptr inbounds nuw [64 x i8], ptr %input.0, i64 %index, !dbg !631
  %5 = getelementptr inbounds nuw i8, ptr %4, i64 128, !dbg !631
  %6 = getelementptr inbounds nuw [64 x i8], ptr %input.0, i64 %index, !dbg !631
  %7 = getelementptr inbounds nuw i8, ptr %6, i64 192, !dbg !631
  %8 = load i64, ptr %1, align 8, !dbg !634, !noundef !21
  %9 = load i64, ptr %3, align 8, !dbg !634, !noundef !21
  %10 = load i64, ptr %5, align 8, !dbg !634, !noundef !21
  %11 = load i64, ptr %7, align 8, !dbg !634, !noundef !21
  %12 = add i64 %8, %vec.phi, !dbg !635
  %13 = add i64 %9, %vec.phi1, !dbg !635
  %14 = add i64 %10, %vec.phi2, !dbg !635
  %15 = add i64 %11, %vec.phi3, !dbg !635
  %index.next = add nuw i64 %index, 4, !dbg !630
  %16 = icmp eq i64 %index.next, %n.vec, !dbg !626
  br i1 %16, label %middle.block, label %vector.body, !dbg !626, !llvm.loop !641

middle.block:                                     ; preds = %vector.body
  %bin.rdx = add i64 %13, %12, !dbg !626
  %bin.rdx4 = add i64 %14, %bin.rdx, !dbg !626
  %bin.rdx5 = add i64 %15, %bin.rdx4, !dbg !626
  %cmp.n = icmp eq i64 %input.1, %n.vec, !dbg !626
  br i1 %cmp.n, label %_RINvXs2J_NtNtCsjIpoRzUjyHQ_4core5slice4iterINtB7_4IterNtCs9cj3cTKSYZx_15foundations_lab6RecordENtNtNtNtBb_4iter6traits8iterator8Iterator4foldyNCNvBS_7sum_aos0EBS_.exit, label %bb8.i.preheader6, !dbg !626

bb8.i.preheader6:                                 ; preds = %bb8.i.preheader, %middle.block
  %i.sroa.0.0.i.ph = phi i64 [ 0, %bb8.i.preheader ], [ %n.vec, %middle.block ]
  %acc.sroa.0.0.i.ph = phi i64 [ 0, %bb8.i.preheader ], [ %bin.rdx5, %middle.block ]
  br label %bb8.i, !dbg !626

bb8.i:                                            ; preds = %bb8.i.preheader6, %bb8.i
  %i.sroa.0.0.i = phi i64 [ %_27.i, %bb8.i ], [ %i.sroa.0.0.i.ph, %bb8.i.preheader6 ], !dbg !630
  %acc.sroa.0.0.i = phi i64 [ %_0.i.i, %bb8.i ], [ %acc.sroa.0.0.i.ph, %bb8.i.preheader6 ], !dbg !642
  %_45.i = getelementptr inbounds nuw [64 x i8], ptr %input.0, i64 %i.sroa.0.0.i, !dbg !631
  %_45.val.i = load i64, ptr %_45.i, align 8, !dbg !634, !noundef !21
  %_0.i.i = add i64 %_45.val.i, %acc.sroa.0.0.i, !dbg !635
  %_27.i = add nuw nsw i64 %i.sroa.0.0.i, 1, !dbg !643
  %_28.i = icmp eq i64 %_27.i, %input.1, !dbg !626
  br i1 %_28.i, label %_RINvXs2J_NtNtCsjIpoRzUjyHQ_4core5slice4iterINtB7_4IterNtCs9cj3cTKSYZx_15foundations_lab6RecordENtNtNtNtBb_4iter6traits8iterator8Iterator4foldyNCNvBS_7sum_aos0EBS_.exit, label %bb8.i, !dbg !626, !llvm.loop !646

_RINvXs2J_NtNtCsjIpoRzUjyHQ_4core5slice4iterINtB7_4IterNtCs9cj3cTKSYZx_15foundations_lab6RecordENtNtNtNtBb_4iter6traits8iterator8Iterator4foldyNCNvBS_7sum_aos0EBS_.exit: ; preds = %bb8.i, %middle.block, %start
  %_0.sroa.0.0.i = phi i64 [ 0, %start ], [ %bin.rdx5, %middle.block ], [ %_0.i.i, %bb8.i ], !dbg !642
  ret i64 %_0.sroa.0.0.i, !dbg !647
}

; foundations_lab::sum_soa
; Function Attrs: nofree noinline norecurse nosync nounwind memory(argmem: read) uwtable
define noundef i64 @_RNvCs9cj3cTKSYZx_15foundations_lab7sum_soa(ptr noalias nofree noundef nonnull readonly align 8 captures(none) %input.0, i64 noundef range(i64 0, 1152921504606846976) %input.1) unnamed_addr #2 personality ptr @rust_eh_personality !dbg !648 !guid !649 {
start:
  %0 = icmp eq i64 %input.1, 0, !dbg !650
  br i1 %0, label %_RINvXs2J_NtNtCsjIpoRzUjyHQ_4core5slice4iterINtB7_4IteryENtNtNtNtBb_4iter6traits8iterator8Iterator4foldyNCINvNtNtBY_8adapters6copied9copy_foldyyNvMs7_NtBb_3numy12wrapping_addE0ECs9cj3cTKSYZx_15foundations_lab.exit, label %bb8.i.preheader, !dbg !662

bb8.i.preheader:                                  ; preds = %start
  %min.iters.check = icmp samesign ult i64 %input.1, 8, !dbg !663
  br i1 %min.iters.check, label %bb8.i.preheader9, label %vector.ph, !dbg !663

vector.ph:                                        ; preds = %bb8.i.preheader
  %n.vec = and i64 %input.1, 1152921504606846968
  br label %vector.body, !dbg !663

vector.body:                                      ; preds = %vector.body, %vector.ph
  %index = phi i64 [ 0, %vector.ph ], [ %index.next, %vector.body ], !dbg !667
  %vec.phi = phi <2 x i64> [ zeroinitializer, %vector.ph ], [ %5, %vector.body ]
  %vec.phi1 = phi <2 x i64> [ zeroinitializer, %vector.ph ], [ %6, %vector.body ]
  %vec.phi2 = phi <2 x i64> [ zeroinitializer, %vector.ph ], [ %7, %vector.body ]
  %vec.phi3 = phi <2 x i64> [ zeroinitializer, %vector.ph ], [ %8, %vector.body ]
  %1 = getelementptr inbounds nuw [8 x i8], ptr %input.0, i64 %index, !dbg !668
  %2 = getelementptr inbounds nuw i8, ptr %1, i64 16, !dbg !671
  %3 = getelementptr inbounds nuw i8, ptr %1, i64 32, !dbg !671
  %4 = getelementptr inbounds nuw i8, ptr %1, i64 48, !dbg !671
  %wide.load = load <2 x i64>, ptr %1, align 8, !dbg !671
  %wide.load4 = load <2 x i64>, ptr %2, align 8, !dbg !671
  %wide.load5 = load <2 x i64>, ptr %3, align 8, !dbg !671
  %wide.load6 = load <2 x i64>, ptr %4, align 8, !dbg !671
  %5 = add <2 x i64> %wide.load, %vec.phi, !dbg !672
  %6 = add <2 x i64> %wide.load4, %vec.phi1, !dbg !672
  %7 = add <2 x i64> %wide.load5, %vec.phi2, !dbg !672
  %8 = add <2 x i64> %wide.load6, %vec.phi3, !dbg !672
  %index.next = add nuw i64 %index, 8, !dbg !667
  %9 = icmp eq i64 %index.next, %n.vec, !dbg !663
  br i1 %9, label %middle.block, label %vector.body, !dbg !663, !llvm.loop !682

middle.block:                                     ; preds = %vector.body
  %bin.rdx = add <2 x i64> %6, %5, !dbg !663
  %bin.rdx7 = add <2 x i64> %7, %bin.rdx, !dbg !663
  %bin.rdx8 = add <2 x i64> %8, %bin.rdx7, !dbg !663
  %10 = tail call i64 @llvm.vector.reduce.add.v2i64(<2 x i64> %bin.rdx8), !dbg !663
  %cmp.n = icmp eq i64 %input.1, %n.vec, !dbg !663
  br i1 %cmp.n, label %_RINvXs2J_NtNtCsjIpoRzUjyHQ_4core5slice4iterINtB7_4IteryENtNtNtNtBb_4iter6traits8iterator8Iterator4foldyNCINvNtNtBY_8adapters6copied9copy_foldyyNvMs7_NtBb_3numy12wrapping_addE0ECs9cj3cTKSYZx_15foundations_lab.exit, label %bb8.i.preheader9, !dbg !663

bb8.i.preheader9:                                 ; preds = %bb8.i.preheader, %middle.block
  %i.sroa.0.0.i.ph = phi i64 [ 0, %bb8.i.preheader ], [ %n.vec, %middle.block ]
  %acc.sroa.0.0.i.ph = phi i64 [ 0, %bb8.i.preheader ], [ %10, %middle.block ]
  br label %bb8.i, !dbg !663

bb8.i:                                            ; preds = %bb8.i.preheader9, %bb8.i
  %i.sroa.0.0.i = phi i64 [ %_27.i, %bb8.i ], [ %i.sroa.0.0.i.ph, %bb8.i.preheader9 ], !dbg !667
  %acc.sroa.0.0.i = phi i64 [ %_0.i.i.i.i, %bb8.i ], [ %acc.sroa.0.0.i.ph, %bb8.i.preheader9 ], !dbg !683
  %_45.i = getelementptr inbounds nuw [8 x i8], ptr %input.0, i64 %i.sroa.0.0.i, !dbg !668
  %_45.val.i = load i64, ptr %_45.i, align 8, !dbg !671, !noundef !21
  %_0.i.i.i.i = add i64 %_45.val.i, %acc.sroa.0.0.i, !dbg !672
  %_27.i = add nuw nsw i64 %i.sroa.0.0.i, 1, !dbg !684
  %_28.i = icmp eq i64 %_27.i, %input.1, !dbg !663
  br i1 %_28.i, label %_RINvXs2J_NtNtCsjIpoRzUjyHQ_4core5slice4iterINtB7_4IteryENtNtNtNtBb_4iter6traits8iterator8Iterator4foldyNCINvNtNtBY_8adapters6copied9copy_foldyyNvMs7_NtBb_3numy12wrapping_addE0ECs9cj3cTKSYZx_15foundations_lab.exit, label %bb8.i, !dbg !663, !llvm.loop !687

_RINvXs2J_NtNtCsjIpoRzUjyHQ_4core5slice4iterINtB7_4IteryENtNtNtNtBb_4iter6traits8iterator8Iterator4foldyNCINvNtNtBY_8adapters6copied9copy_foldyyNvMs7_NtBb_3numy12wrapping_addE0ECs9cj3cTKSYZx_15foundations_lab.exit: ; preds = %bb8.i, %middle.block, %start
  %_0.sroa.0.0.i = phi i64 [ 0, %start ], [ %10, %middle.block ], [ %_0.i.i.i.i, %bb8.i ], !dbg !683
  ret i64 %_0.sroa.0.0.i, !dbg !688
}

; foundations_lab::borrowed
; Function Attrs: noinline nounwind uwtable
define noundef i64 @_RNvCs9cj3cTKSYZx_15foundations_lab8borrowed(ptr noalias nofree noundef nonnull readonly align 8 captures(address, read_provenance) %input.0, i64 noundef range(i64 0, 1152921504606846976) %input.1) unnamed_addr #3 !dbg !689 !guid !690 {
start:
  %_2 = alloca [16 x i8], align 8
  call void @llvm.lifetime.start.p0(ptr nonnull %_2), !dbg !691
  store ptr %input.0, ptr %_2, align 8, !dbg !692
  %0 = getelementptr inbounds nuw i8, ptr %_2, i64 8, !dbg !692
  store i64 %input.1, ptr %0, align 8, !dbg !692
  call void asm sideeffect "", "r,~{memory}"(ptr nonnull %_2) #20, !dbg !692, !srcloc !209
  %1 = load ptr, ptr %_2, align 8, !dbg !694, !nonnull !21, !align !194, !noundef !21
  %2 = load i64, ptr %0, align 8, !dbg !694, !noundef !21
; call foundations_lab::sum_soa
  %_0 = call noundef i64 @_RNvCs9cj3cTKSYZx_15foundations_lab7sum_soa(ptr noalias nofree noundef nonnull readonly align 8 captures(address, read_provenance) %1, i64 noundef %2) #22, !dbg !694
  call void @llvm.lifetime.end.p0(ptr nonnull %_2), !dbg !695
  ret i64 %_0, !dbg !696
}

; foundations_lab::copy_add
; Function Attrs: noinline uwtable
define void @_RNvCs9cj3cTKSYZx_15foundations_lab8copy_add(ptr noalias nofree noundef nonnull writeonly align 8 captures(none) %dst.0, i64 noundef range(i64 0, 1152921504606846976) %dst.1, ptr noalias nofree noundef nonnull readonly align 8 captures(none) %src.0, i64 noundef range(i64 0, 1152921504606846976) %src.1) unnamed_addr #1 personality ptr @rust_eh_personality !dbg !697 !guid !698 {
start:
  %_6 = alloca [8 x i8], align 8
  %_4 = alloca [8 x i8], align 8
  store i64 %dst.1, ptr %_4, align 8, !dbg !699
  call void @llvm.lifetime.start.p0(ptr nonnull %_6), !dbg !700
  store i64 %src.1, ptr %_6, align 8, !dbg !700
  %_7 = icmp eq i64 %dst.1, %src.1, !dbg !701
  br i1 %_7, label %bb1, label %bb2, !dbg !701, !prof !359

bb2:                                              ; preds = %start
; call core::panicking::assert_failed::<usize, usize>
  call void @_RINvNtCsjIpoRzUjyHQ_4core9panicking13assert_failedjjEB4_(i8 noundef 0, ptr noalias nofree noundef nonnull readonly align 8 captures(address, read_provenance) dereferenceable(8) %_4, ptr noalias nofree noundef nonnull readonly align 8 captures(address, read_provenance) dereferenceable(8) %_6, ptr noundef null, ptr undef, ptr noalias nofree noundef readonly align 8 captures(address, read_provenance) dereferenceable(24) @alloc_f3c5c97dd09f062403c0dcf5e142dc74) #19, !dbg !704
  unreachable, !dbg !704

bb1:                                              ; preds = %start
  call void @llvm.lifetime.end.p0(ptr nonnull %_6), !dbg !707
  %_2.i5.not = icmp eq i64 %dst.1, 0, !dbg !708
  br i1 %_2.i5.not, label %bb7, label %bb6.preheader, !dbg !708

bb6.preheader:                                    ; preds = %bb1
  %min.iters.check = icmp samesign ult i64 %dst.1, 8, !dbg !708
  br i1 %min.iters.check, label %bb6.preheader10, label %vector.ph, !dbg !708

vector.ph:                                        ; preds = %bb6.preheader
  %n.vec = and i64 %dst.1, 1152921504606846968
  br label %vector.body, !dbg !708

vector.body:                                      ; preds = %vector.body, %vector.ph
  %index = phi i64 [ 0, %vector.ph ], [ %index.next, %vector.body ], !dbg !719
  %0 = getelementptr inbounds nuw [8 x i8], ptr %dst.0, i64 %index, !dbg !721
  %1 = getelementptr inbounds nuw [8 x i8], ptr %src.0, i64 %index, !dbg !726
  %2 = getelementptr inbounds nuw i8, ptr %1, i64 16, !dbg !731
  %3 = getelementptr inbounds nuw i8, ptr %1, i64 32, !dbg !731
  %4 = getelementptr inbounds nuw i8, ptr %1, i64 48, !dbg !731
  %wide.load = load <2 x i64>, ptr %1, align 8, !dbg !731
  %wide.load7 = load <2 x i64>, ptr %2, align 8, !dbg !731
  %wide.load8 = load <2 x i64>, ptr %3, align 8, !dbg !731
  %wide.load9 = load <2 x i64>, ptr %4, align 8, !dbg !731
  %5 = add <2 x i64> %wide.load, splat (i64 1), !dbg !733
  %6 = add <2 x i64> %wide.load7, splat (i64 1), !dbg !733
  %7 = add <2 x i64> %wide.load8, splat (i64 1), !dbg !733
  %8 = add <2 x i64> %wide.load9, splat (i64 1), !dbg !733
  %9 = getelementptr inbounds nuw i8, ptr %0, i64 16, !dbg !736
  %10 = getelementptr inbounds nuw i8, ptr %0, i64 32, !dbg !736
  %11 = getelementptr inbounds nuw i8, ptr %0, i64 48, !dbg !736
  store <2 x i64> %5, ptr %0, align 8, !dbg !736
  store <2 x i64> %6, ptr %9, align 8, !dbg !736
  store <2 x i64> %7, ptr %10, align 8, !dbg !736
  store <2 x i64> %8, ptr %11, align 8, !dbg !736
  %index.next = add nuw i64 %index, 8, !dbg !719
  %12 = icmp eq i64 %index.next, %n.vec, !dbg !708
  br i1 %12, label %middle.block, label %vector.body, !dbg !708, !llvm.loop !737

middle.block:                                     ; preds = %vector.body
  %cmp.n = icmp eq i64 %dst.1, %n.vec, !dbg !708
  br i1 %cmp.n, label %bb7, label %bb6.preheader10, !dbg !708

bb6.preheader10:                                  ; preds = %bb6.preheader, %middle.block
  %iter.sroa.8.06.ph = phi i64 [ 0, %bb6.preheader ], [ %n.vec, %middle.block ]
  br label %bb6, !dbg !708

bb6:                                              ; preds = %bb6.preheader10, %bb6
  %iter.sroa.8.06 = phi i64 [ %13, %bb6 ], [ %iter.sroa.8.06.ph, %bb6.preheader10 ]
  %13 = add nuw nsw i64 %iter.sroa.8.06, 1, !dbg !719
  %_3.i.i = getelementptr inbounds nuw [8 x i8], ptr %dst.0, i64 %iter.sroa.8.06, !dbg !721
  %_3.i1.i = getelementptr inbounds nuw [8 x i8], ptr %src.0, i64 %iter.sroa.8.06, !dbg !726
  %_18 = load i64, ptr %_3.i1.i, align 8, !dbg !731, !noundef !21
  %_17 = add i64 %_18, 1, !dbg !733
  store i64 %_17, ptr %_3.i.i, align 8, !dbg !736
  %exitcond.not = icmp eq i64 %13, %dst.1, !dbg !708
  br i1 %exitcond.not, label %bb7, label %bb6, !dbg !708, !llvm.loop !738

bb7:                                              ; preds = %bb6, %middle.block, %bb1
  ret void, !dbg !739
}

; foundations_lab::dce_empty
; Function Attrs: mustprogress nofree noinline norecurse nosync nounwind willreturn memory(none) uwtable
define noundef i64 @_RNvCs9cj3cTKSYZx_15foundations_lab9dce_empty(ptr noalias nofree noundef nonnull readonly align 8 captures(none) %input.0, i64 noundef range(i64 0, 1152921504606846976) %input.1) unnamed_addr #4 personality ptr @rust_eh_personality !dbg !740 !guid !741 {
start:
  ret i64 0, !dbg !742
}

; foundations_lab::init_push
; Function Attrs: noinline uwtable
define noundef i64 @_RNvCs9cj3cTKSYZx_15foundations_lab9init_push(i64 noundef %n) unnamed_addr #1 personality ptr @rust_eh_personality !dbg !743 !guid !744 {
start:
  %_8 = alloca [16 x i8], align 8
  %out = alloca [24 x i8], align 8
  call void @llvm.lifetime.start.p0(ptr nonnull %out), !dbg !745
  %_34.0.i = shl i64 %n, 3, !dbg !746
  %_34.1.i = icmp ugt i64 %n, 2305843009213693951, !dbg !746
  %_39.not.i = icmp ugt i64 %_34.0.i, 9223372036854775800
  %or.cond.i = or i1 %_34.1.i, %_39.not.i, !dbg !760
  br i1 %or.cond.i, label %bb8, label %bb18.i, !dbg !760, !prof !70

bb18.i:                                           ; preds = %start
  %0 = icmp eq i64 %_34.0.i, 0, !dbg !762
  br i1 %0, label %bb9, label %bb3.i, !dbg !762

bb3.i:                                            ; preds = %bb18.i
; call __rustc::__rust_no_alloc_shim_is_unstable_v2
  tail call void @_RNvCsdtSMxSA38aw_7___rustc35___rust_no_alloc_shim_is_unstable_v2() #20, !dbg !763, !noalias !764
; call __rustc::__rust_alloc
  %1 = tail call noundef align 8 ptr @_RNvCsdtSMxSA38aw_7___rustc12___rust_alloc(i64 noundef range(i64 0, -9223372036854775808) %_34.0.i, i64 noundef range(i64 1, 9) 8) #20, !dbg !767, !noalias !764
  %2 = icmp eq ptr %1, null, !dbg !772
  br i1 %2, label %bb8, label %bb10.i, !dbg !773

bb10.i:                                           ; preds = %bb3.i
  %3 = ptrtoint ptr %1 to i64, !dbg !774
  br label %bb9, !dbg !775

bb8:                                              ; preds = %start, %bb3.i
  %_12.sroa.4.0.ph = phi i64 [ 8, %bb3.i ], [ 0, %start ]
; call alloc::raw_vec::handle_error
  tail call void @_RNvNtCs6zY7rJBZy9D_5alloc7raw_vec12handle_error(i64 noundef %_12.sroa.4.0.ph, i64 %_34.0.i) #21, !dbg !776
  unreachable, !dbg !776

bb9:                                              ; preds = %bb10.i, %bb18.i
  %_12.sroa.4.0 = phi i64 [ %n, %bb10.i ], [ 0, %bb18.i ], !dbg !778
  %_12.sroa.10.0 = phi i64 [ %3, %bb10.i ], [ 8, %bb18.i ]
  %4 = inttoptr i64 %_12.sroa.10.0 to ptr, !dbg !779
  %_15 = icmp samesign ule i64 %n, %_12.sroa.4.0, !dbg !780
  tail call void @llvm.assume(i1 %_15), !dbg !784
  store i64 %_12.sroa.4.0, ptr %out, align 8, !dbg !787
  %5 = getelementptr inbounds nuw i8, ptr %out, i64 8, !dbg !787
  store ptr %4, ptr %5, align 8, !dbg !787
  %6 = getelementptr inbounds nuw i8, ptr %out, i64 16, !dbg !787
  store i64 0, ptr %6, align 8, !dbg !787
  %_2114.not = icmp eq i64 %n, 0, !dbg !788
  br i1 %_2114.not, label %bb11, label %bb10, !dbg !790

bb11.loopexit:                                    ; preds = %bb12
  %_28.pre = load ptr, ptr %5, align 8, !dbg !798
  %out.val3.pre = load i64, ptr %out, align 8, !dbg !812
  br label %bb11, !dbg !813

bb11:                                             ; preds = %bb11.loopexit, %bb9
  %out.val3 = phi i64 [ %out.val3.pre, %bb11.loopexit ], [ %_12.sroa.4.0, %bb9 ], !dbg !812
  %_27 = phi i64 [ %13, %bb11.loopexit ], [ 0, %bb9 ], !dbg !814
  %_28 = phi ptr [ %_28.pre, %bb11.loopexit ], [ %4, %bb9 ], !dbg !798
  call void @llvm.lifetime.start.p0(ptr nonnull %_8), !dbg !813
  store ptr %_28, ptr %_8, align 8, !dbg !815
  %7 = getelementptr inbounds nuw i8, ptr %_8, i64 8, !dbg !815
  store i64 %_27, ptr %7, align 8, !dbg !815
  call void asm sideeffect "", "r,~{memory}"(ptr nonnull %_8) #20, !dbg !815, !srcloc !209
  %8 = load ptr, ptr %_8, align 8, !dbg !817, !nonnull !21, !align !194, !noundef !21
  %9 = load i64, ptr %7, align 8, !dbg !817, !noundef !21
; call foundations_lab::sum_soa
  %_0 = call noundef i64 @_RNvCs9cj3cTKSYZx_15foundations_lab7sum_soa(ptr noalias nofree noundef nonnull readonly align 8 captures(address, read_provenance) %8, i64 noundef %9), !dbg !817
  call void @llvm.lifetime.end.p0(ptr nonnull %_8), !dbg !818
  %10 = icmp eq i64 %out.val3, 0, !dbg !819
  br i1 %10, label %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc3vec3VecyEECs9cj3cTKSYZx_15foundations_lab.exit7, label %bb2.i.i.i4.i5, !dbg !819

bb10:                                             ; preds = %bb9, %bb12
  %_14.i17 = phi ptr [ %_14.i, %bb12 ], [ %4, %bb9 ]
  %len.i = phi i64 [ %13, %bb12 ], [ 0, %bb9 ], !dbg !825
  %iter.sroa.0.015 = phi i64 [ %14, %bb12 ], [ 0, %bb9 ]
  %_6 = mul i64 %iter.sroa.0.015, 17, !dbg !831
  tail call void @llvm.experimental.noalias.scope.decl(metadata !834), !dbg !837
  %self1.i = load i64, ptr %out, align 8, !dbg !838, !range !844, !alias.scope !834, !noundef !21
  %_4.i = icmp eq i64 %len.i, %self1.i, !dbg !845
  br i1 %_4.i, label %bb1.i, label %bb12, !dbg !845

bb1.i:                                            ; preds = %bb10
; invoke <alloc::raw_vec::RawVec<u64>>::grow_one
  invoke void @_RNvMs4_NtCs6zY7rJBZy9D_5alloc7raw_vecINtB5_6RawVecyE8grow_oneCs9cj3cTKSYZx_15foundations_lab(ptr noalias nofree noundef nonnull align 8 dereferenceable(24) %out) #22
          to label %bb1.i.bb12_crit_edge unwind label %cleanup, !dbg !846

bb1.i.bb12_crit_edge:                             ; preds = %bb1.i
  %_14.i.pre = load ptr, ptr %5, align 8, !dbg !847, !alias.scope !834
  br label %bb12, !dbg !846

cleanup:                                          ; preds = %bb1.i
  %11 = landingpad { ptr, i32 }
          cleanup
  %out.val = load i64, ptr %out, align 8, !dbg !812
  %12 = icmp eq i64 %out.val, 0, !dbg !856
  br i1 %12, label %bb6, label %bb2.i.i.i4.i, !dbg !856

bb2.i.i.i4.i:                                     ; preds = %cleanup
  %out.val2 = load ptr, ptr %5, align 8, !dbg !812, !nonnull !21, !noundef !21
  %alloc_size.i.i.i.i5.i = shl nuw i64 %out.val, 3, !dbg !862
; call __rustc::__rust_dealloc
  tail call void @_RNvCsdtSMxSA38aw_7___rustc14___rust_dealloc(ptr noundef nonnull %out.val2, i64 noundef %alloc_size.i.i.i.i5.i, i64 noundef range(i64 1, -9223372036854775807) 8) #20, !dbg !864
  br label %bb6, !dbg !869

bb2.i.i.i4.i5:                                    ; preds = %bb11
  %alloc_size.i.i.i.i5.i6 = shl nuw i64 %out.val3, 3, !dbg !870
; call __rustc::__rust_dealloc
  call void @_RNvCsdtSMxSA38aw_7___rustc14___rust_dealloc(ptr noundef nonnull %_28, i64 noundef %alloc_size.i.i.i.i5.i6, i64 noundef range(i64 1, -9223372036854775807) 8) #20, !dbg !872
  br label %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc3vec3VecyEECs9cj3cTKSYZx_15foundations_lab.exit7, !dbg !877

_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc3vec3VecyEECs9cj3cTKSYZx_15foundations_lab.exit7: ; preds = %bb11, %bb2.i.i.i4.i5
  call void @llvm.lifetime.end.p0(ptr nonnull %out), !dbg !812
  ret i64 %_0, !dbg !878

bb12:                                             ; preds = %bb1.i.bb12_crit_edge, %bb10
  %_14.i = phi ptr [ %_14.i.pre, %bb1.i.bb12_crit_edge ], [ %_14.i17, %bb10 ], !dbg !847
  %end.i = getelementptr inbounds nuw [8 x i8], ptr %_14.i, i64 %len.i, !dbg !879
  store i64 %_6, ptr %end.i, align 8, !dbg !882, !noalias !834
  %13 = add i64 %len.i, 1, !dbg !886
  store i64 %13, ptr %6, align 8, !dbg !886, !alias.scope !834
  %14 = add nuw i64 %iter.sroa.0.015, 1, !dbg !887
  %exitcond.not = icmp eq i64 %14, %n, !dbg !788
  br i1 %exitcond.not, label %bb11.loopexit, label %bb10, !dbg !790

bb6:                                              ; preds = %bb2.i.i.i4.i, %cleanup
  resume { ptr, i32 } %11, !dbg !893
}

; foundations_lab::init_zero
; Function Attrs: noinline uwtable
define noundef i64 @_RNvCs9cj3cTKSYZx_15foundations_lab9init_zero(i64 noundef %n) unnamed_addr #1 personality ptr @rust_eh_personality !dbg !894 !guid !895 {
start:
  %_14 = alloca [16 x i8], align 8
  %_34.0.i.i = shl i64 %n, 3, !dbg !896
  %_34.1.i.i = icmp ugt i64 %n, 2305843009213693951, !dbg !896
  %_39.not.i.i = icmp ugt i64 %_34.0.i.i, 9223372036854775800
  %or.cond.i.i = or i1 %_34.1.i.i, %_39.not.i.i, !dbg !907
  br i1 %or.cond.i.i, label %bb14.i, label %bb18.i.i, !dbg !907, !prof !70

bb18.i.i:                                         ; preds = %start
  %0 = icmp eq i64 %_34.0.i.i, 0, !dbg !909
  br i1 %0, label %_RINvXs_NtNtCs6zY7rJBZy9D_5alloc3vec14spec_from_elemyNtB5_12SpecFromElem9from_elemNtNtB9_5alloc6GlobalECs9cj3cTKSYZx_15foundations_lab.exit, label %bb3.i2.i, !dbg !909

bb3.i2.i:                                         ; preds = %bb18.i.i
; call __rustc::__rust_no_alloc_shim_is_unstable_v2
  tail call void @_RNvCsdtSMxSA38aw_7___rustc35___rust_no_alloc_shim_is_unstable_v2() #20, !dbg !910, !noalias !911
; call __rustc::__rust_alloc_zeroed
  %1 = tail call noundef align 8 ptr @_RNvCsdtSMxSA38aw_7___rustc19___rust_alloc_zeroed(i64 noundef range(i64 1, -9223372036854775808) %_34.0.i.i, i64 noundef range(i64 1, 9) 8) #20, !dbg !916, !noalias !911
  %2 = icmp eq ptr %1, null, !dbg !921
  br i1 %2, label %bb14.i, label %bb10.i.i, !dbg !922

bb10.i.i:                                         ; preds = %bb3.i2.i
  %3 = ptrtoint ptr %1 to i64, !dbg !923
  br label %_RINvXs_NtNtCs6zY7rJBZy9D_5alloc3vec14spec_from_elemyNtB5_12SpecFromElem9from_elemNtNtB9_5alloc6GlobalECs9cj3cTKSYZx_15foundations_lab.exit, !dbg !924

bb14.i:                                           ; preds = %bb3.i2.i, %start
  %_16.sroa.4.0.ph.i = phi i64 [ 8, %bb3.i2.i ], [ 0, %start ]
; call alloc::raw_vec::handle_error
  tail call void @_RNvNtCs6zY7rJBZy9D_5alloc7raw_vec12handle_error(i64 noundef %_16.sroa.4.0.ph.i, i64 %_34.0.i.i) #21, !dbg !925, !noalias !926
  unreachable, !dbg !925

_RINvXs_NtNtCs6zY7rJBZy9D_5alloc3vec14spec_from_elemyNtB5_12SpecFromElem9from_elemNtNtB9_5alloc6GlobalECs9cj3cTKSYZx_15foundations_lab.exit: ; preds = %bb18.i.i, %bb10.i.i
  %_16.sroa.4.0.i = phi i64 [ %n, %bb10.i.i ], [ 0, %bb18.i.i ], !dbg !927
  %_16.sroa.10.0.i = phi i64 [ %3, %bb10.i.i ], [ 8, %bb18.i.i ]
  %4 = inttoptr i64 %_16.sroa.10.0.i to ptr, !dbg !928
  %_22 = getelementptr inbounds nuw i8, ptr %4, i64 %_34.0.i.i, !dbg !929
  %_7.i.i15 = icmp eq i64 %n, 0, !dbg !939
  br i1 %_7.i.i15, label %bb5, label %bb4.preheader, !dbg !952

bb4.preheader:                                    ; preds = %_RINvXs_NtNtCs6zY7rJBZy9D_5alloc3vec14spec_from_elemyNtB5_12SpecFromElem9from_elemNtNtB9_5alloc6GlobalECs9cj3cTKSYZx_15foundations_lab.exit
  %5 = add nsw i64 %_34.0.i.i, -8, !dbg !952
  %6 = lshr exact i64 %5, 3, !dbg !952
  %7 = add nuw nsw i64 %6, 1, !dbg !952
  %min.iters.check = icmp ult i64 %5, 24, !dbg !952
  br i1 %min.iters.check, label %bb4.preheader24, label %vector.ph, !dbg !952

vector.ph:                                        ; preds = %bb4.preheader
  %n.vec = and i64 %7, 4611686018427387900
  %8 = shl i64 %n.vec, 3
  %9 = getelementptr i8, ptr %4, i64 %8
  br label %vector.body, !dbg !952

vector.body:                                      ; preds = %vector.body, %vector.ph
  %index = phi i64 [ 0, %vector.ph ], [ %index.next, %vector.body ], !dbg !953
  %10 = shl i64 %index, 3
  %next.gep = getelementptr i8, ptr %4, i64 %10
  %11 = getelementptr i8, ptr %4, i64 %10
  %next.gep20 = getelementptr i8, ptr %11, i64 8
  %12 = getelementptr i8, ptr %4, i64 %10
  %next.gep21 = getelementptr i8, ptr %12, i64 16
  %13 = getelementptr i8, ptr %4, i64 %10
  %next.gep22 = getelementptr i8, ptr %13, i64 24
  %14 = mul i64 %index, 17, !dbg !956
  %15 = mul i64 %index, 17, !dbg !956
  %16 = add i64 %15, 17, !dbg !956
  %17 = mul i64 %index, 17, !dbg !956
  %18 = add i64 %17, 34, !dbg !956
  %19 = mul i64 %index, 17, !dbg !956
  %20 = add i64 %19, 51, !dbg !956
  store i64 %14, ptr %next.gep, align 8, !dbg !960
  store i64 %16, ptr %next.gep20, align 8, !dbg !960
  store i64 %18, ptr %next.gep21, align 8, !dbg !960
  store i64 %20, ptr %next.gep22, align 8, !dbg !960
  %index.next = add nuw i64 %index, 4, !dbg !953
  %21 = icmp eq i64 %index.next, %n.vec, !dbg !952
  br i1 %21, label %middle.block, label %vector.body, !dbg !952, !llvm.loop !961

middle.block:                                     ; preds = %vector.body
  %cmp.n = icmp eq i64 %7, %n.vec, !dbg !952
  br i1 %cmp.n, label %bb5, label %bb4.preheader24, !dbg !952

bb4.preheader24:                                  ; preds = %bb4.preheader, %middle.block
  %iter.sroa.7.019.ph = phi i64 [ 0, %bb4.preheader ], [ %n.vec, %middle.block ]
  %iter.sroa.0.018.ph = phi ptr [ %4, %bb4.preheader ], [ %9, %middle.block ]
  br label %bb4, !dbg !952

bb4:                                              ; preds = %bb4.preheader24, %bb4
  %iter.sroa.7.019 = phi i64 [ %_9.0.i, %bb4 ], [ %iter.sroa.7.019.ph, %bb4.preheader24 ]
  %iter.sroa.0.018 = phi ptr [ %_17.i.i, %bb4 ], [ %iter.sroa.0.018.ph, %bb4.preheader24 ]
  %_9.0.i = add nuw nsw i64 %iter.sroa.7.019, 1, !dbg !953
  %_17.i.i = getelementptr inbounds nuw i8, ptr %iter.sroa.0.018, i64 8, !dbg !962
  %_12 = mul i64 %iter.sroa.7.019, 17, !dbg !956
  store i64 %_12, ptr %iter.sroa.0.018, align 8, !dbg !960
  %_7.i.i = icmp eq ptr %_17.i.i, %_22, !dbg !939
  br i1 %_7.i.i, label %bb5, label %bb4, !dbg !952, !llvm.loop !965

bb5:                                              ; preds = %bb4, %middle.block, %_RINvXs_NtNtCs6zY7rJBZy9D_5alloc3vec14spec_from_elemyNtB5_12SpecFromElem9from_elemNtNtB9_5alloc6GlobalECs9cj3cTKSYZx_15foundations_lab.exit
  call void @llvm.lifetime.start.p0(ptr nonnull %_14), !dbg !966
  store ptr %4, ptr %_14, align 8, !dbg !967
  %22 = getelementptr inbounds nuw i8, ptr %_14, i64 8, !dbg !967
  store i64 %n, ptr %22, align 8, !dbg !967
  call void asm sideeffect "", "r,~{memory}"(ptr nonnull %_14) #20, !dbg !967, !srcloc !209
  %23 = load ptr, ptr %_14, align 8, !dbg !969, !nonnull !21, !align !194, !noundef !21
  %24 = load i64, ptr %22, align 8, !dbg !969, !noundef !21
; call foundations_lab::sum_soa
  %_0 = call noundef i64 @_RNvCs9cj3cTKSYZx_15foundations_lab7sum_soa(ptr noalias nofree noundef nonnull readonly align 8 captures(address, read_provenance) %23, i64 noundef %24), !dbg !969
  call void @llvm.lifetime.end.p0(ptr nonnull %_14), !dbg !970
  %25 = icmp eq i64 %_16.sroa.4.0.i, 0, !dbg !971
  br i1 %25, label %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc3vec3VecyEECs9cj3cTKSYZx_15foundations_lab.exit7, label %bb2.i.i.i4.i5, !dbg !971

bb2.i.i.i4.i5:                                    ; preds = %bb5
  %alloc_size.i.i.i.i5.i6 = shl nuw i64 %_16.sroa.4.0.i, 3, !dbg !977
  call void @llvm.assume(i1 true) [ "nonnull"(ptr %4) ]
; call __rustc::__rust_dealloc
  call void @_RNvCsdtSMxSA38aw_7___rustc14___rust_dealloc(ptr noundef nonnull %4, i64 noundef %alloc_size.i.i.i.i5.i6, i64 noundef range(i64 1, -9223372036854775807) 8) #20, !dbg !979
  br label %_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc3vec3VecyEECs9cj3cTKSYZx_15foundations_lab.exit7, !dbg !984

_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc3vec3VecyEECs9cj3cTKSYZx_15foundations_lab.exit7: ; preds = %bb5, %bb2.i.i.i4.i5
  ret i64 %_0, !dbg !985
}

; foundations_lab::sum_index
; Function Attrs: nofree noinline norecurse nosync nounwind memory(argmem: read) uwtable
define noundef i64 @_RNvCs9cj3cTKSYZx_15foundations_lab9sum_index(ptr noalias nofree noundef nonnull readonly align 8 captures(none) %input.0, i64 noundef range(i64 0, 1152921504606846976) %input.1) unnamed_addr #2 !dbg !986 !guid !987 {
start:
  %_34.not = icmp eq i64 %input.1, 0, !dbg !988
  br i1 %_34.not, label %bb4, label %bb3.preheader, !dbg !988

bb3.preheader:                                    ; preds = %start
  %min.iters.check = icmp samesign ult i64 %input.1, 8, !dbg !988
  br i1 %min.iters.check, label %bb3.preheader15, label %vector.ph, !dbg !988

vector.ph:                                        ; preds = %bb3.preheader
  %n.vec = and i64 %input.1, 1152921504606846968
  br label %vector.body, !dbg !988

vector.body:                                      ; preds = %vector.body, %vector.ph
  %index = phi i64 [ 0, %vector.ph ], [ %index.next, %vector.body ], !dbg !991
  %vec.phi = phi <2 x i64> [ zeroinitializer, %vector.ph ], [ %4, %vector.body ]
  %vec.phi7 = phi <2 x i64> [ zeroinitializer, %vector.ph ], [ %5, %vector.body ]
  %vec.phi8 = phi <2 x i64> [ zeroinitializer, %vector.ph ], [ %6, %vector.body ]
  %vec.phi9 = phi <2 x i64> [ zeroinitializer, %vector.ph ], [ %7, %vector.body ]
  %0 = getelementptr inbounds nuw [8 x i8], ptr %input.0, i64 %index, !dbg !992
  %1 = getelementptr inbounds nuw i8, ptr %0, i64 16, !dbg !992
  %2 = getelementptr inbounds nuw i8, ptr %0, i64 32, !dbg !992
  %3 = getelementptr inbounds nuw i8, ptr %0, i64 48, !dbg !992
  %wide.load = load <2 x i64>, ptr %0, align 8, !dbg !992
  %wide.load10 = load <2 x i64>, ptr %1, align 8, !dbg !992
  %wide.load11 = load <2 x i64>, ptr %2, align 8, !dbg !992
  %wide.load12 = load <2 x i64>, ptr %3, align 8, !dbg !992
  %4 = add <2 x i64> %wide.load, %vec.phi, !dbg !993
  %5 = add <2 x i64> %wide.load10, %vec.phi7, !dbg !993
  %6 = add <2 x i64> %wide.load11, %vec.phi8, !dbg !993
  %7 = add <2 x i64> %wide.load12, %vec.phi9, !dbg !993
  %index.next = add nuw i64 %index, 8, !dbg !991
  %8 = icmp eq i64 %index.next, %n.vec, !dbg !988
  br i1 %8, label %middle.block, label %vector.body, !dbg !988, !llvm.loop !996

middle.block:                                     ; preds = %vector.body
  %bin.rdx = add <2 x i64> %5, %4, !dbg !988
  %bin.rdx13 = add <2 x i64> %6, %bin.rdx, !dbg !988
  %bin.rdx14 = add <2 x i64> %7, %bin.rdx13, !dbg !988
  %9 = tail call i64 @llvm.vector.reduce.add.v2i64(<2 x i64> %bin.rdx14), !dbg !988
  %cmp.n = icmp eq i64 %input.1, %n.vec, !dbg !988
  br i1 %cmp.n, label %bb4, label %bb3.preheader15, !dbg !988

bb3.preheader15:                                  ; preds = %bb3.preheader, %middle.block
  %sum.sroa.0.06.ph = phi i64 [ 0, %bb3.preheader ], [ %9, %middle.block ]
  %i.sroa.0.05.ph = phi i64 [ 0, %bb3.preheader ], [ %n.vec, %middle.block ]
  br label %bb3, !dbg !988

bb4:                                              ; preds = %bb3, %middle.block, %start
  %sum.sroa.0.0.lcssa = phi i64 [ 0, %start ], [ %9, %middle.block ], [ %_6, %bb3 ], !dbg !997
  ret i64 %sum.sroa.0.0.lcssa, !dbg !998

bb3:                                              ; preds = %bb3.preheader15, %bb3
  %sum.sroa.0.06 = phi i64 [ %_6, %bb3 ], [ %sum.sroa.0.06.ph, %bb3.preheader15 ]
  %i.sroa.0.05 = phi i64 [ %11, %bb3 ], [ %i.sroa.0.05.ph, %bb3.preheader15 ]
  %10 = getelementptr inbounds nuw [8 x i8], ptr %input.0, i64 %i.sroa.0.05, !dbg !992
  %_7 = load i64, ptr %10, align 8, !dbg !992, !noundef !21
  %_6 = add i64 %_7, %sum.sroa.0.06, !dbg !993
  %11 = add nuw nsw i64 %i.sroa.0.05, 1, !dbg !991
  %exitcond.not = icmp eq i64 %11, %input.1, !dbg !988
  br i1 %exitcond.not, label %bb4, label %bb3, !dbg !988, !llvm.loop !999
}

; <foundations_lab::ByteRegion>::new
; Function Attrs: uwtable
define void @_RNvMCs9cj3cTKSYZx_15foundations_labNtB2_10ByteRegion3new(ptr dead_on_unwind noalias nofree noundef writable writeonly sret([32 x i8]) align 8 captures(none) dereferenceable(32) %_0, i64 noundef %capacity) unnamed_addr #0 personality ptr @rust_eh_personality !dbg !1000 !guid !1002 {
start:
  %_39.not.i.i = icmp slt i64 %capacity, 0
  br i1 %_39.not.i.i, label %bb6.i, label %bb18.i.i, !dbg !1003, !prof !70

bb18.i.i:                                         ; preds = %start
  %0 = icmp eq i64 %capacity, 0, !dbg !1018
  br i1 %0, label %_RINvXs1_NtNtCs6zY7rJBZy9D_5alloc3vec14spec_from_elemhNtB6_12SpecFromElem9from_elemNtNtBa_5alloc6GlobalECs9cj3cTKSYZx_15foundations_lab.exit, label %bb3.i.i, !dbg !1018

bb3.i.i:                                          ; preds = %bb18.i.i
; call __rustc::__rust_no_alloc_shim_is_unstable_v2
  tail call void @_RNvCsdtSMxSA38aw_7___rustc35___rust_no_alloc_shim_is_unstable_v2() #20, !dbg !1019, !noalias !1020
; call __rustc::__rust_alloc_zeroed
  %1 = tail call noundef ptr @_RNvCsdtSMxSA38aw_7___rustc19___rust_alloc_zeroed(i64 noundef range(i64 1, -9223372036854775808) %capacity, i64 noundef range(i64 1, 9) 1) #20, !dbg !1025, !noalias !1020
  %2 = icmp eq ptr %1, null, !dbg !1030
  br i1 %2, label %bb6.i, label %bb10.i.i, !dbg !1031

bb10.i.i:                                         ; preds = %bb3.i.i
  %3 = ptrtoint ptr %1 to i64, !dbg !1032
  br label %_RINvXs1_NtNtCs6zY7rJBZy9D_5alloc3vec14spec_from_elemhNtB6_12SpecFromElem9from_elemNtNtBa_5alloc6GlobalECs9cj3cTKSYZx_15foundations_lab.exit, !dbg !1033

bb6.i:                                            ; preds = %bb3.i.i, %start
  %_10.sroa.4.0.ph.i = phi i64 [ 1, %bb3.i.i ], [ 0, %start ]
; call alloc::raw_vec::handle_error
  tail call void @_RNvNtCs6zY7rJBZy9D_5alloc7raw_vec12handle_error(i64 noundef %_10.sroa.4.0.ph.i, i64 %capacity) #21, !dbg !1034, !noalias !1036
  unreachable, !dbg !1034

_RINvXs1_NtNtCs6zY7rJBZy9D_5alloc3vec14spec_from_elemhNtB6_12SpecFromElem9from_elemNtNtBa_5alloc6GlobalECs9cj3cTKSYZx_15foundations_lab.exit: ; preds = %bb18.i.i, %bb10.i.i
  %_10.sroa.10.0.i = phi i64 [ %3, %bb10.i.i ], [ 1, %bb18.i.i ]
  %4 = inttoptr i64 %_10.sroa.10.0.i to ptr, !dbg !1037
  store i64 %capacity, ptr %_0, align 8, !dbg !1038
  %_2.sroa.4.0._0.sroa_idx = getelementptr inbounds nuw i8, ptr %_0, i64 8, !dbg !1038
  store ptr %4, ptr %_2.sroa.4.0._0.sroa_idx, align 8, !dbg !1038
  %_2.sroa.5.0._0.sroa_idx = getelementptr inbounds nuw i8, ptr %_0, i64 16, !dbg !1038
  store i64 %capacity, ptr %_2.sroa.5.0._0.sroa_idx, align 8, !dbg !1038
  %5 = getelementptr inbounds nuw i8, ptr %_0, i64 24, !dbg !1038
  store i64 0, ptr %5, align 8, !dbg !1038
  ret void, !dbg !1039
}

; <alloc::raw_vec::RawVec<u64>>::grow_one
; Function Attrs: cold noinline uwtable
define void @_RNvMs4_NtCs6zY7rJBZy9D_5alloc7raw_vecINtB5_6RawVecyE8grow_oneCs9cj3cTKSYZx_15foundations_lab(ptr noalias nofree noundef align 8 captures(none) dereferenceable(16) %self) unnamed_addr #5 personality ptr @rust_eh_personality !dbg !1040 !guid !1041 {
start:
  %self3.i = alloca [24 x i8], align 8
  %self1 = load i64, ptr %self, align 8, !dbg !1042, !range !844, !noundef !21
  tail call void @llvm.experimental.noalias.scope.decl(metadata !1046), !dbg !1049
  %v16.i = shl nuw i64 %self1, 1, !dbg !1050
  %0 = tail call i64 @llvm.umax.i64(i64 %v16.i, i64 4), !dbg !1054
  call void @llvm.lifetime.start.p0(ptr nonnull %self3.i), !dbg !1061, !noalias !1046
  %1 = getelementptr inbounds nuw i8, ptr %self, i64 8, !dbg !1063
  %self.val15.i = load ptr, ptr %1, align 8, !dbg !1063, !alias.scope !1046
; call <alloc::raw_vec::RawVecInner>::finish_grow
  call fastcc void @_RNvMs5_NtCs6zY7rJBZy9D_5alloc7raw_vecNtB5_11RawVecInner11finish_growCs9cj3cTKSYZx_15foundations_lab(ptr noalias nofree noundef align 8 captures(none) dereferenceable(24) %self3.i, i64 %self1, ptr %self.val15.i, i64 noundef %0), !dbg !1063
  %_37.i = load i64, ptr %self3.i, align 8, !dbg !1064, !range !1070, !noalias !1046, !noundef !21
  %2 = trunc nuw i64 %_37.i to i1, !dbg !1071
  %3 = getelementptr inbounds nuw i8, ptr %self3.i, i64 8, !dbg !1072
  br i1 %2, label %bb18.i, label %bb3, !dbg !1071

bb18.i:                                           ; preds = %start
  %e.0.i = load i64, ptr %3, align 8, !dbg !1073, !range !1074, !noalias !1046, !noundef !21
  %4 = getelementptr inbounds nuw i8, ptr %self3.i, i64 16, !dbg !1073
  %e.1.i = load i64, ptr %4, align 8, !dbg !1073, !noalias !1046
  call void @llvm.lifetime.end.p0(ptr nonnull %self3.i), !dbg !1075, !noalias !1046
; call alloc::raw_vec::handle_error
  tail call void @_RNvNtCs6zY7rJBZy9D_5alloc7raw_vec12handle_error(i64 noundef %e.0.i, i64 %e.1.i) #21, !dbg !1076
  unreachable, !dbg !1076

bb3:                                              ; preds = %start
  %v.0.i = load ptr, ptr %3, align 8, !dbg !1077, !noalias !1046, !nonnull !21, !noundef !21
  call void @llvm.lifetime.end.p0(ptr nonnull %self3.i), !dbg !1075, !noalias !1046
  store ptr %v.0.i, ptr %1, align 8, !dbg !1078, !alias.scope !1046
  %5 = icmp sgt i64 %0, -1, !dbg !1082
  tail call void @llvm.assume(i1 %5), !dbg !1082
  store i64 %0, ptr %self, align 8, !dbg !1086, !alias.scope !1046
  ret void, !dbg !1087
}

; <alloc::raw_vec::RawVecInner>::finish_grow
; Function Attrs: cold nounwind uwtable
define internal fastcc void @_RNvMs5_NtCs6zY7rJBZy9D_5alloc7raw_vecNtB5_11RawVecInner11finish_growCs9cj3cTKSYZx_15foundations_lab(ptr dead_on_unwind noalias nofree noundef nonnull writable writeonly align 8 captures(none) dereferenceable(24) initializes((0, 8)) %_0, i64 %self.0.val, ptr %self.8.val, i64 noundef %cap) unnamed_addr #6 !dbg !1088 !guid !1089 {
start:
  %_32.0 = shl i64 %cap, 3, !dbg !1090
  %_32.1 = icmp ult i64 %cap, 2305843009213693952, !dbg !1090
  %_37 = icmp ult i64 %_32.0, 9223372036854775801
  %or.cond = and i1 %_32.1, %_37, !dbg !1100
  br i1 %or.cond, label %bb12, label %bb8, !dbg !1100, !prof !1104

bb12:                                             ; preds = %start
  %0 = icmp eq i64 %self.0.val, 0, !dbg !1105
  br i1 %0, label %bb5, label %bb3, !dbg !1105

bb3:                                              ; preds = %bb12
  %alloc_size.i = shl nuw i64 %self.0.val, 3, !dbg !1109
  call void @llvm.assume(i1 true) [ "nonnull"(ptr %self.8.val) ]
  %cond.i.i = icmp uge i64 %_32.0, %alloc_size.i, !dbg !1111
  tail call void @llvm.assume(i1 %cond.i.i), !dbg !1120
; call __rustc::__rust_realloc
  %raw_ptr.i.i = tail call noundef align 8 ptr @_RNvCsdtSMxSA38aw_7___rustc14___rust_realloc(ptr noundef nonnull %self.8.val, i64 noundef %alloc_size.i, i64 noundef 8, i64 noundef range(i64 0, 9223372036854775801) %_32.0) #20, !dbg !1123
  br label %bb7, !dbg !1126

bb5:                                              ; preds = %bb12
  %1 = icmp eq i64 %_32.0, 0, !dbg !1127
  br i1 %1, label %bb19, label %bb1.i.i, !dbg !1127

bb1.i.i:                                          ; preds = %bb5
; call __rustc::__rust_no_alloc_shim_is_unstable_v2
  tail call void @_RNvCsdtSMxSA38aw_7___rustc35___rust_no_alloc_shim_is_unstable_v2() #20, !dbg !1131
; call __rustc::__rust_alloc
  %2 = tail call noundef align 8 ptr @_RNvCsdtSMxSA38aw_7___rustc12___rust_alloc(i64 noundef range(i64 0, -9223372036854775808) %_32.0, i64 noundef range(i64 1, 9) 8) #20, !dbg !1132
  br label %bb7, !dbg !1134

bb7:                                              ; preds = %bb1.i.i, %bb3
  %raw_ptr.i.i.pn = phi ptr [ %raw_ptr.i.i, %bb3 ], [ %2, %bb1.i.i ]
  %3 = icmp eq ptr %raw_ptr.i.i.pn, null, !dbg !1135
  br i1 %3, label %bb18, label %bb19, !dbg !1140

bb18:                                             ; preds = %bb7
  %4 = getelementptr inbounds nuw i8, ptr %_0, i64 8, !dbg !1141
  store i64 8, ptr %4, align 8, !dbg !1141
  br label %bb8, !dbg !1143

bb19:                                             ; preds = %bb5, %bb7
  %raw_ptr.i.i.pn8 = phi ptr [ %raw_ptr.i.i.pn, %bb7 ], [ inttoptr (i64 8 to ptr), %bb5 ]
  %5 = getelementptr inbounds nuw i8, ptr %_0, i64 8, !dbg !1144
  store ptr %raw_ptr.i.i.pn8, ptr %5, align 8, !dbg !1144
  br label %bb8, !dbg !1146

bb8:                                              ; preds = %start, %bb19, %bb18
  %.sink10 = phi i64 [ 16, %bb19 ], [ 16, %bb18 ], [ 8, %start ]
  %_32.0.sink = phi i64 [ %_32.0, %bb19 ], [ %_32.0, %bb18 ], [ 0, %start ]
  %.sink = phi i64 [ 0, %bb19 ], [ 1, %bb18 ], [ 1, %start ]
  %6 = getelementptr inbounds nuw i8, ptr %_0, i64 %.sink10, !dbg !1147
  store i64 %_32.0.sink, ptr %6, align 8, !dbg !1147
  store i64 %.sink, ptr %_0, align 8, !dbg !1147
  ret void, !dbg !1148
}

; <&str as core::fmt::Display>::fmt
; Function Attrs: uwtable
define internal noundef zeroext i1 @_RNvXs1i_NtCsjIpoRzUjyHQ_4core3fmtReNtB6_7Display3fmtCs9cj3cTKSYZx_15foundations_lab(ptr noalias nofree noundef readonly align 8 captures(none) dereferenceable(16) %self, ptr noalias nofree noundef align 8 dereferenceable(24) %f) unnamed_addr #0 !dbg !1149 !guid !1153 {
start:
  %_3.0 = load ptr, ptr %self, align 8, !dbg !1154, !nonnull !21, !noundef !21
  %0 = getelementptr inbounds nuw i8, ptr %self, i64 8, !dbg !1154
  %_3.1 = load i64, ptr %0, align 8, !dbg !1154, !noundef !21
; call <str as core::fmt::Display>::fmt
  %_0 = tail call noundef zeroext i1 @_RNvXsi_NtCsjIpoRzUjyHQ_4core3fmteNtB5_7Display3fmt(ptr noalias nofree noundef nonnull readonly captures(address, read_provenance) %_3.0, i64 noundef %_3.1, ptr noalias nofree noundef nonnull align 8 dereferenceable(24) %f), !dbg !1155
  ret i1 %_0, !dbg !1156
}

; Function Attrs: nounwind uwtable
declare noundef range(i32 0, 10) i32 @rust_eh_personality(i32 noundef, i32 noundef, i64 noundef, ptr noundef, ptr noundef) unnamed_addr #7

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(ptr captures(none)) #8

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(ptr captures(none)) #8

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(inaccessiblemem: write)
declare void @llvm.assume(i1 noundef) #9

; alloc::raw_vec::handle_error
; Function Attrs: cold minsize noreturn optsize uwtable
declare void @_RNvNtCs6zY7rJBZy9D_5alloc7raw_vec12handle_error(i64 noundef range(i64 0, -9223372036854775807), i64) unnamed_addr #10

; Function Attrs: mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.memcpy.p0.p0.i64(ptr noalias writeonly captures(none), ptr noalias readonly captures(none), i64, i1 immarg) #8

; core::panicking::panic
; Function Attrs: cold noinline noreturn uwtable
declare void @_RNvNtCsjIpoRzUjyHQ_4core9panicking5panic(ptr noalias nofree noundef nonnull readonly captures(address, read_provenance), i64 noundef, ptr noalias nofree noundef readonly align 8 captures(address, read_provenance) dereferenceable(24)) unnamed_addr #11

; <std::time::Instant>::now
; Function Attrs: uwtable
declare { i64, i32 } @_RNvMNtCs1SSuMAdGM58_3std4timeNtB2_7Instant3now() unnamed_addr #0

; <std::time::Instant>::elapsed
; Function Attrs: uwtable
declare { i64, i32 } @_RNvMNtCs1SSuMAdGM58_3std4timeNtB2_7Instant7elapsed(ptr noalias nofree noundef readonly align 8 captures(address, read_provenance) dereferenceable(16)) unnamed_addr #0

; core::panicking::assert_failed::<u64, u64>
; Function Attrs: cold minsize noinline noreturn optsize uwtable
declare void @_RINvNtCsjIpoRzUjyHQ_4core9panicking13assert_failedyyEB4_(i8 noundef range(i8 0, 3), ptr noalias nofree noundef readonly align 8 captures(address, read_provenance) dereferenceable(8), ptr noalias nofree noundef readonly align 8 captures(address, read_provenance) dereferenceable(8), ptr noundef, ptr, ptr noalias nofree noundef readonly align 8 captures(address, read_provenance) dereferenceable(24)) unnamed_addr #12

; std::io::stdio::_print
; Function Attrs: uwtable
declare void @_RNvNtNtCs1SSuMAdGM58_3std2io5stdio6__print(ptr noundef nonnull, ptr noundef nonnull) unnamed_addr #0

; <usize as core::fmt::Display>::fmt
; Function Attrs: uwtable
declare noundef zeroext i1 @_RNvXsi_NtNtNtCsjIpoRzUjyHQ_4core3fmt3num3impjNtB9_7Display3fmt(ptr noalias nofree noundef readonly align 8 captures(address, read_provenance) dereferenceable(8), ptr noalias nofree noundef align 8 dereferenceable(24)) unnamed_addr #0

; <f64 as core::fmt::Display>::fmt
; Function Attrs: uwtable
declare noundef zeroext i1 @_RNvXs7_NtNtCsjIpoRzUjyHQ_4core3fmt5floatdNtB7_7Display3fmt(ptr noalias nofree noundef readonly align 8 captures(address, read_provenance) dereferenceable(8), ptr noalias nofree noundef align 8 dereferenceable(24)) unnamed_addr #0

; <u64 as core::fmt::Display>::fmt
; Function Attrs: uwtable
declare noundef zeroext i1 @_RNvXsd_NtNtNtCsjIpoRzUjyHQ_4core3fmt3num3impyNtB9_7Display3fmt(ptr noalias nofree noundef readonly align 8 captures(address, read_provenance) dereferenceable(8), ptr noalias nofree noundef align 8 dereferenceable(24)) unnamed_addr #0

; core::panicking::assert_failed::<usize, usize>
; Function Attrs: cold minsize noinline noreturn optsize uwtable
declare void @_RINvNtCsjIpoRzUjyHQ_4core9panicking13assert_failedjjEB4_(i8 noundef range(i8 0, 3), ptr noalias nofree noundef readonly align 8 captures(address, read_provenance) dereferenceable(8), ptr noalias nofree noundef readonly align 8 captures(address, read_provenance) dereferenceable(8), ptr noundef, ptr, ptr noalias nofree noundef readonly align 8 captures(address, read_provenance) dereferenceable(24)) unnamed_addr #12

; __rustc::__rust_dealloc
; Function Attrs: nounwind allockind("free") uwtable
declare void @_RNvCsdtSMxSA38aw_7___rustc14___rust_dealloc(ptr allocptr noundef nonnull captures(address), i64 noundef, i64 noundef range(i64 1, -9223372036854775807)) unnamed_addr #13

; __rustc::__rust_realloc
; Function Attrs: nounwind allockind("realloc,aligned") allocsize(3) uwtable
declare noalias noundef ptr @_RNvCsdtSMxSA38aw_7___rustc14___rust_realloc(ptr allocptr noundef nonnull, i64 noundef, i64 allocalign noundef range(i64 1, -9223372036854775807), i64 noundef) unnamed_addr #14

; __rustc::__rust_no_alloc_shim_is_unstable_v2
; Function Attrs: nounwind uwtable
declare void @_RNvCsdtSMxSA38aw_7___rustc35___rust_no_alloc_shim_is_unstable_v2() unnamed_addr #7

; __rustc::__rust_alloc
; Function Attrs: nounwind allockind("alloc,uninitialized,aligned") allocsize(0) uwtable
declare noalias noundef ptr @_RNvCsdtSMxSA38aw_7___rustc12___rust_alloc(i64 noundef, i64 allocalign noundef range(i64 1, -9223372036854775807)) unnamed_addr #15

; __rustc::__rust_alloc_zeroed
; Function Attrs: nounwind allockind("alloc,zeroed,aligned") allocsize(0) uwtable
declare noalias noundef ptr @_RNvCsdtSMxSA38aw_7___rustc19___rust_alloc_zeroed(i64 noundef, i64 allocalign noundef range(i64 1, -9223372036854775807)) unnamed_addr #16

; <str as core::fmt::Display>::fmt
; Function Attrs: uwtable
declare noundef zeroext i1 @_RNvXsi_NtCsjIpoRzUjyHQ_4core3fmteNtB5_7Display3fmt(ptr noalias nofree noundef nonnull readonly captures(address, read_provenance), i64 noundef, ptr noalias nofree noundef align 8 dereferenceable(24)) unnamed_addr #0

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(inaccessiblemem: readwrite)
declare void @llvm.experimental.noalias.scope.decl(metadata) #17

; Function Attrs: nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none)
declare i64 @llvm.umax.i64(i64, i64) #18

; Function Attrs: nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none)
declare i64 @llvm.vector.reduce.add.v2i64(<2 x i64>) #18

attributes #0 = { uwtable "frame-pointer"="non-leaf" "probe-stack"="inline-asm" "target-cpu"="apple-m5" }
attributes #1 = { noinline uwtable "frame-pointer"="non-leaf" "probe-stack"="inline-asm" "target-cpu"="apple-m5" }
attributes #2 = { nofree noinline norecurse nosync nounwind memory(argmem: read) uwtable "frame-pointer"="non-leaf" "probe-stack"="inline-asm" "target-cpu"="apple-m5" }
attributes #3 = { noinline nounwind uwtable "frame-pointer"="non-leaf" "probe-stack"="inline-asm" "target-cpu"="apple-m5" }
attributes #4 = { mustprogress nofree noinline norecurse nosync nounwind willreturn memory(none) uwtable "frame-pointer"="non-leaf" "probe-stack"="inline-asm" "target-cpu"="apple-m5" }
attributes #5 = { cold noinline uwtable "frame-pointer"="non-leaf" "probe-stack"="inline-asm" "target-cpu"="apple-m5" }
attributes #6 = { cold nounwind uwtable "frame-pointer"="non-leaf" "probe-stack"="inline-asm" "target-cpu"="apple-m5" }
attributes #7 = { nounwind uwtable "frame-pointer"="non-leaf" "probe-stack"="inline-asm" "target-cpu"="apple-m5" }
attributes #8 = { mustprogress nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #9 = { mustprogress nocallback nofree nosync nounwind willreturn memory(inaccessiblemem: write) }
attributes #10 = { cold minsize noreturn optsize uwtable "frame-pointer"="non-leaf" "probe-stack"="inline-asm" "target-cpu"="apple-m5" }
attributes #11 = { cold noinline noreturn uwtable "frame-pointer"="non-leaf" "probe-stack"="inline-asm" "target-cpu"="apple-m5" }
attributes #12 = { cold minsize noinline noreturn optsize uwtable "frame-pointer"="non-leaf" "probe-stack"="inline-asm" "target-cpu"="apple-m5" }
attributes #13 = { nounwind allockind("free") uwtable "alloc-family"="__rust_alloc" "frame-pointer"="non-leaf" "probe-stack"="inline-asm" "target-cpu"="apple-m5" }
attributes #14 = { nounwind allockind("realloc,aligned") allocsize(3) uwtable "alloc-family"="__rust_alloc" "frame-pointer"="non-leaf" "probe-stack"="inline-asm" "target-cpu"="apple-m5" }
attributes #15 = { nounwind allockind("alloc,uninitialized,aligned") allocsize(0) uwtable "alloc-family"="__rust_alloc" "alloc-variant-zeroed"="_RNvCsdtSMxSA38aw_7___rustc19___rust_alloc_zeroed" "frame-pointer"="non-leaf" "probe-stack"="inline-asm" "target-cpu"="apple-m5" }
attributes #16 = { nounwind allockind("alloc,zeroed,aligned") allocsize(0) uwtable "alloc-family"="__rust_alloc" "frame-pointer"="non-leaf" "probe-stack"="inline-asm" "target-cpu"="apple-m5" }
attributes #17 = { nocallback nofree nosync nounwind willreturn memory(inaccessiblemem: readwrite) }
attributes #18 = { nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none) }
attributes #19 = { noinline noreturn }
attributes #20 = { nounwind }
attributes #21 = { noreturn }
attributes #22 = { noinline }

!llvm.module.flags = !{!9, !10, !11, !12, !13}
!llvm.ident = !{!14}
!llvm.dbg.cu = !{!15}

!0 = !{i64 -4285992736103422660}
!1 = !{i64 -93925914348710609}
!2 = !{i64 -454199103322570370}
!3 = !{i64 9097719769594820099}
!4 = !{i64 -4988062118637889992}
!5 = !{i64 -1738063410948119237}
!6 = !{i64 -6085561579736960249}
!7 = !{i64 2992416366754640662}
!8 = !{i64 5000552414726894278}
!9 = !{i32 8, !"PIC Level", i32 2}
!10 = !{i32 7, !"uwtable", i32 2}
!11 = !{i32 7, !"frame-pointer", i32 1}
!12 = !{i32 7, !"Dwarf Version", i32 4}
!13 = !{i32 2, !"Debug Info Version", i32 3}
!14 = !{!"rustc version 1.99.0 (b940084d7 2026-09-28)"}
!15 = distinct !DICompileUnit(language: DW_LANG_Rust, file: !16, producer: "clang LLVM (rustc version 1.99.0 (b940084d7 2026-09-28))", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, splitDebugInlining: false, nameTableKind: None)
!16 = !DIFile(filename: "src/lib.rs/@/foundations_lab.6b24031e890cfca9-cgu.0", directory: "/Users/juanwang/Desktop/tutorials/cpp-rust/bench/foundations-lab")
!17 = distinct !DISubprogram(name: "run", linkageName: "_RNvCs9cj3cTKSYZx_15foundations_lab3run", scope: !19, file: !18, line: 15, type: !20, scopeLine: 15, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!18 = !DIFile(filename: "src/lib.rs", directory: "/Users/juanwang/Desktop/tutorials/cpp-rust/bench/foundations-lab", checksumkind: CSK_MD5, checksum: "e43a66638df9c101bcbcd68318ee71d5")
!19 = !DINamespace(name: "foundations_lab", scope: null)
!20 = !DISubroutineType(types: !21)
!21 = !{}
!22 = !{i64 3807717998545533577}
!23 = !DILocation(line: 16, column: 13, scope: !17)
!24 = !{!"branch_weights", i32 6003000, i32 -294967296}
!25 = !DILocation(line: 16, column: 5, scope: !17)
!26 = !DILocation(line: 3212, column: 26, scope: !27, inlinedAt: !32)
!27 = distinct !DISubprogram(name: "overflowing_mul", linkageName: "_RNvMs9_NtCsjIpoRzUjyHQ_4core3numj15overflowing_mul", scope: !29, file: !28, line: 3211, type: !20, scopeLine: 3211, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!28 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/num/uint_macros.rs", directory: "", checksumkind: CSK_MD5, checksum: "861b08c040dcb8e56aa7d23dacf541ca")
!29 = !DINamespace(name: "{impl#11}", scope: !30)
!30 = !DINamespace(name: "num", scope: !31)
!31 = !DINamespace(name: "core", scope: null)
!32 = distinct !DILocation(line: 1330, column: 31, scope: !33, inlinedAt: !34)
!33 = distinct !DISubprogram(name: "checked_mul", linkageName: "_RNvMs9_NtCsjIpoRzUjyHQ_4core3numj11checked_mul", scope: !29, file: !28, line: 1329, type: !20, scopeLine: 1329, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!34 = distinct !DILocation(line: 533, column: 39, scope: !35, inlinedAt: !41)
!35 = distinct !DILexicalBlock(scope: !37, file: !36, line: 533, column: 54)
!36 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/alloc/layout.rs", directory: "", checksumkind: CSK_MD5, checksum: "044b929685d8564035fcb902806519e4")
!37 = distinct !DISubprogram(name: "repeat_packed", linkageName: "_RNvMNtNtCsjIpoRzUjyHQ_4core5alloc6layoutNtB2_6Layout13repeat_packed", scope: !38, file: !36, line: 532, type: !20, scopeLine: 532, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!38 = !DINamespace(name: "Layout", scope: !39)
!39 = !DINamespace(name: "layout", scope: !40)
!40 = !DINamespace(name: "alloc", scope: !31)
!41 = distinct !DILocation(line: 901, column: 17, scope: !42, inlinedAt: !46)
!42 = distinct !DISubprogram(name: "layout_array", linkageName: "_RNvNtCs6zY7rJBZy9D_5alloc7raw_vec12layout_array", scope: !44, file: !43, line: 896, type: !20, scopeLine: 896, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!43 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/alloc/src/raw_vec/mod.rs", directory: "", checksumkind: CSK_MD5, checksum: "acd4dae5e7aaaaf06aa0208ebac37ff5")
!44 = !DINamespace(name: "raw_vec", scope: !45)
!45 = !DINamespace(name: "alloc", scope: null)
!46 = distinct !DILocation(line: 455, column: 28, scope: !47, inlinedAt: !49)
!47 = distinct !DISubprogram(name: "try_allocate_in<alloc::alloc::Global>", linkageName: "_RNvMs5_NtCs6zY7rJBZy9D_5alloc7raw_vecNtB5_11RawVecInner15try_allocate_inCs9cj3cTKSYZx_15foundations_lab", scope: !48, file: !43, line: 447, type: !20, scopeLine: 447, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!48 = !DINamespace(name: "RawVecInner", scope: !44)
!49 = distinct !DILocation(line: 587, column: 15, scope: !50, inlinedAt: !51)
!50 = distinct !DISubprogram(name: "with_capacity_zeroed_in<alloc::alloc::Global>", linkageName: "_RNvMs2_NtCs6zY7rJBZy9D_5alloc7raw_vecNtB5_11RawVecInner23with_capacity_zeroed_inCs9cj3cTKSYZx_15foundations_lab", scope: !48, file: !43, line: 586, type: !20, scopeLine: 586, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!51 = distinct !DILocation(line: 221, column: 20, scope: !52, inlinedAt: !54)
!52 = distinct !DISubprogram(name: "with_capacity_zeroed_in<u64, alloc::alloc::Global>", linkageName: "_RNvMs0_NtCs6zY7rJBZy9D_5alloc7raw_vecINtB5_6RawVecyE23with_capacity_zeroed_inCs9cj3cTKSYZx_15foundations_lab", scope: !53, file: !43, line: 219, type: !20, scopeLine: 219, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!53 = !DINamespace(name: "RawVec", scope: !44)
!54 = distinct !DILocation(line: 24, column: 31, scope: !55, inlinedAt: !60)
!55 = distinct !DISubprogram(name: "from_elem<u64, alloc::alloc::Global>", linkageName: "_RINvXs_NtNtCs6zY7rJBZy9D_5alloc3vec14spec_from_elemyNtB5_12SpecFromElem9from_elemNtNtB9_5alloc6GlobalECs9cj3cTKSYZx_15foundations_lab", scope: !57, file: !56, line: 22, type: !20, scopeLine: 22, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!56 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/alloc/src/vec/spec_from_elem.rs", directory: "", checksumkind: CSK_MD5, checksum: "22e98e423536bab5c4532831d8ac869f")
!57 = !DINamespace(name: "{impl#1}", scope: !58)
!58 = !DINamespace(name: "spec_from_elem", scope: !59)
!59 = !DINamespace(name: "vec", scope: !45)
!60 = distinct !DILocation(line: 3773, column: 5, scope: !61, inlinedAt: !63)
!61 = distinct !DISubprogram(name: "from_elem<u64>", linkageName: "_RINvNtCs6zY7rJBZy9D_5alloc3vec9from_elemyECs9cj3cTKSYZx_15foundations_lab", scope: !59, file: !62, line: 3772, type: !20, scopeLine: 3772, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!62 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/alloc/src/vec/mod.rs", directory: "", checksumkind: CSK_MD5, checksum: "a93d3a7d4a1d55c9887c540882057a4f")
!63 = !DILocation(line: 17, column: 23, scope: !17)
!64 = !DILocation(line: 478, column: 8, scope: !65, inlinedAt: !68)
!65 = distinct !DISubprogram(name: "unlikely", linkageName: "_RNvNtCsjIpoRzUjyHQ_4core10intrinsics8unlikely", scope: !67, file: !66, line: 477, type: !20, scopeLine: 477, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!66 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/intrinsics/mod.rs", directory: "", checksumkind: CSK_MD5, checksum: "95f29c0132b18aca34fbfb798048cc68")
!67 = !DINamespace(name: "intrinsics", scope: !31)
!68 = distinct !DILocation(line: 1331, column: 16, scope: !69, inlinedAt: !34)
!69 = distinct !DILexicalBlock(scope: !33, file: !28, line: 1330, column: 13)
!70 = !{!"branch_weights", i32 2002, i32 2000}
!71 = !DILocation(line: 461, column: 12, scope: !72, inlinedAt: !49)
!72 = distinct !DILexicalBlock(scope: !47, file: !43, line: 455, column: 9)
!73 = !DILocation(line: 0, scope: !72, inlinedAt: !49)
!74 = !{!75, !77}
!75 = distinct !{!75, !76, !"_RNvMs5_NtCs6zY7rJBZy9D_5alloc7raw_vecNtB5_11RawVecInner15try_allocate_inCs9cj3cTKSYZx_15foundations_lab: %_0"}
!76 = distinct !{!76, !"_RNvMs5_NtCs6zY7rJBZy9D_5alloc7raw_vecNtB5_11RawVecInner15try_allocate_inCs9cj3cTKSYZx_15foundations_lab"}
!77 = distinct !{!77, !78, !"_RINvXs_NtNtCs6zY7rJBZy9D_5alloc3vec14spec_from_elemyNtB5_12SpecFromElem9from_elemNtNtB9_5alloc6GlobalECs9cj3cTKSYZx_15foundations_lab: %_0"}
!78 = distinct !{!78, !"_RINvXs_NtNtCs6zY7rJBZy9D_5alloc3vec14spec_from_elemyNtB5_12SpecFromElem9from_elemNtNtB9_5alloc6GlobalECs9cj3cTKSYZx_15foundations_lab"}
!79 = !DILocation(line: 290, column: 9, scope: !80, inlinedAt: !83)
!80 = distinct !DISubprogram(name: "alloc_zeroed", linkageName: "_RNvNtCs6zY7rJBZy9D_5alloc5alloc12alloc_zeroed", scope: !82, file: !81, line: 284, type: !20, scopeLine: 284, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!81 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/alloc/src/alloc.rs", directory: "", checksumkind: CSK_MD5, checksum: "87b4d0ba26e1dfe94542079de6981d97")
!82 = !DINamespace(name: "alloc", scope: !45)
!83 = distinct !DILocation(line: 302, column: 43, scope: !84, inlinedAt: !87)
!84 = distinct !DILexicalBlock(scope: !85, file: !81, line: 301, column: 13)
!85 = distinct !DISubprogram(name: "alloc_impl_runtime", linkageName: "_RNvMs0_NtCs6zY7rJBZy9D_5alloc5allocNtB5_6Global18alloc_impl_runtime", scope: !86, file: !81, line: 297, type: !20, scopeLine: 297, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!86 = !DINamespace(name: "Global", scope: !82)
!87 = distinct !DILocation(line: 424, column: 9, scope: !88, inlinedAt: !89)
!88 = distinct !DISubprogram(name: "alloc_impl", linkageName: "_RNvMs0_NtCs6zY7rJBZy9D_5alloc5allocNtB5_6Global10alloc_impl", scope: !86, file: !81, line: 423, type: !20, scopeLine: 423, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!89 = distinct !DILocation(line: 547, column: 14, scope: !90, inlinedAt: !93)
!90 = distinct !DISubprogram(name: "allocate_zeroed", linkageName: "_RNvXs1_NtCs6zY7rJBZy9D_5alloc5allocNtB5_6GlobalNtNtCsjIpoRzUjyHQ_4core5alloc9Allocator15allocate_zeroed", scope: !91, file: !81, line: 546, type: !92, scopeLine: 546, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!91 = !DINamespace(name: "{impl#3}", scope: !82)
!92 = !DISubroutineType(cc: DW_CC_nocall, types: !21)
!93 = distinct !DILocation(line: 468, column: 40, scope: !72, inlinedAt: !49)
!94 = !DILocation(line: 470, column: 25, scope: !95, inlinedAt: !49)
!95 = distinct !DILexicalBlock(scope: !72, file: !43, line: 465, column: 9)
!96 = !DILocation(line: 470, column: 19, scope: !95, inlinedAt: !49)
!97 = !DILocation(line: 478, column: 9, scope: !98, inlinedAt: !49)
!98 = distinct !DILexicalBlock(scope: !95, file: !43, line: 470, column: 9)
!99 = !DILocation(line: 483, column: 5, scope: !47, inlinedAt: !49)
!100 = !DILocation(line: 589, column: 25, scope: !101, inlinedAt: !51)
!101 = distinct !DILexicalBlock(scope: !50, file: !43, line: 589, column: 13)
!102 = !{!77}
!103 = !DILocation(line: 0, scope: !47, inlinedAt: !49)
!104 = !DILocation(line: 588, column: 16, scope: !50, inlinedAt: !51)
!105 = !DILocation(line: 970, column: 18, scope: !106, inlinedAt: !111)
!106 = distinct !DISubprogram(name: "add<foundations_lab::Case>", linkageName: "_RNvMNtNtCsjIpoRzUjyHQ_4core3ptr7mut_ptrONtCs9cj3cTKSYZx_15foundations_lab4Case3addBE_", scope: !108, file: !107, line: 936, type: !20, scopeLine: 936, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!107 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/ptr/mut_ptr.rs", directory: "", checksumkind: CSK_MD5, checksum: "0a9a444e8d978ea2fd7622da49f95724")
!108 = !DINamespace(name: "{impl#0}", scope: !109)
!109 = !DINamespace(name: "mut_ptr", scope: !110)
!110 = !DINamespace(name: "ptr", scope: !31)
!111 = !DILocation(line: 240, column: 82, scope: !112, inlinedAt: !119)
!112 = distinct !DILexicalBlock(scope: !114, file: !113, line: 221, column: 9)
!113 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/slice/iter.rs", directory: "", checksumkind: CSK_MD5, checksum: "fbd326a766434a8a32d4a7c0b175710f")
!114 = distinct !DILexicalBlock(scope: !115, file: !113, line: 220, column: 9)
!115 = distinct !DISubprogram(name: "new<foundations_lab::Case>", linkageName: "_RNvMsa_NtNtCsjIpoRzUjyHQ_4core5slice4iterINtB5_7IterMutNtCs9cj3cTKSYZx_15foundations_lab4CaseE3newBT_", scope: !116, file: !113, line: 219, type: !20, scopeLine: 219, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!116 = !DINamespace(name: "IterMut", scope: !117)
!117 = !DINamespace(name: "iter", scope: !118)
!118 = !DINamespace(name: "slice", scope: !31)
!119 = !DILocation(line: 1060, column: 9, scope: !120, inlinedAt: !123)
!120 = distinct !DISubprogram(name: "iter_mut<foundations_lab::Case>", linkageName: "_RNvMNtCsjIpoRzUjyHQ_4core5sliceSNtCs9cj3cTKSYZx_15foundations_lab4Case8iter_mutBw_", scope: !122, file: !121, line: 1059, type: !20, scopeLine: 1059, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!121 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/slice/mod.rs", directory: "", checksumkind: CSK_MD5, checksum: "3864a87bb6bc29c76dd67717f51013ca")
!122 = !DINamespace(name: "{impl#0}", scope: !118)
!123 = !DILocation(line: 18, column: 23, scope: !124)
!124 = distinct !DILexicalBlock(scope: !17, file: !18, line: 17, column: 5)
!125 = !DILocation(line: 180, column: 28, scope: !126, inlinedAt: !131)
!126 = distinct !DILexicalBlock(scope: !128, file: !127, line: 162, column: 17)
!127 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/slice/iter/macros.rs", directory: "", checksumkind: CSK_MD5, checksum: "526307389b7550baea9ff75b5731c6e9")
!128 = distinct !DILexicalBlock(scope: !129, file: !127, line: 161, column: 17)
!129 = distinct !DISubprogram(name: "next<foundations_lab::Case>", linkageName: "_RNvXs2Q_NtNtCsjIpoRzUjyHQ_4core5slice4iterINtB6_7IterMutNtCs9cj3cTKSYZx_15foundations_lab4CaseENtNtNtNtBa_4iter6traits8iterator8Iterator4nextBU_", scope: !130, file: !127, line: 157, type: !20, scopeLine: 157, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!130 = !DINamespace(name: "{impl#178}", scope: !117)
!131 = !DILocation(line: 18, column: 17, scope: !132)
!132 = !DILexicalBlockFile(scope: !133, file: !18, discriminator: 2)
!133 = distinct !DILexicalBlock(scope: !124, file: !18, line: 18, column: 5)
!134 = !DILocation(line: 627, column: 28, scope: !135, inlinedAt: !139)
!135 = distinct !DISubprogram(name: "add<foundations_lab::Case>", linkageName: "_RNvMs1_NtNtCsjIpoRzUjyHQ_4core3ptr8non_nullINtB5_7NonNullNtCs9cj3cTKSYZx_15foundations_lab4CaseE3addBV_", scope: !137, file: !136, line: 619, type: !20, scopeLine: 619, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!136 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/ptr/non_null.rs", directory: "", checksumkind: CSK_MD5, checksum: "accc742d53c125b723531f778524eec8")
!137 = !DINamespace(name: "NonNull", scope: !138)
!138 = !DINamespace(name: "non_null", scope: !110)
!139 = !DILocation(line: 185, column: 40, scope: !126, inlinedAt: !131)
!140 = !DILocation(line: 19, column: 13, scope: !141)
!141 = distinct !DILexicalBlock(scope: !133, file: !18, line: 18, column: 5)
!142 = !DILocation(line: 19, column: 21, scope: !141)
!143 = !DILocation(line: 24, column: 5, scope: !124)
!144 = !DILocation(line: 1100, column: 12, scope: !145, inlinedAt: !150)
!145 = distinct !DISubprogram(name: "spec_next<usize>", linkageName: "_RNvXs3_NtNtCsjIpoRzUjyHQ_4core4iter5rangeINtNtNtB9_3ops5range5RangejENtB5_17RangeIteratorImpl9spec_nextCs9cj3cTKSYZx_15foundations_lab", scope: !147, file: !146, line: 1099, type: !20, scopeLine: 1099, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!146 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/iter/range.rs", directory: "", checksumkind: CSK_MD5, checksum: "6038fbd2305f6e8ce8c79c7d50b4046d")
!147 = !DINamespace(name: "{impl#5}", scope: !148)
!148 = !DINamespace(name: "range", scope: !149)
!149 = !DINamespace(name: "iter", scope: !31)
!150 = !DILocation(line: 1185, column: 14, scope: !151, inlinedAt: !154)
!151 = !DILexicalBlockFile(scope: !152, file: !146, discriminator: 2)
!152 = distinct !DISubprogram(name: "next<usize>", linkageName: "_RNvXs4_NtNtCsjIpoRzUjyHQ_4core4iter5rangeINtNtNtB9_3ops5range5RangejENtNtNtB7_6traits8iterator8Iterator4nextCs9cj3cTKSYZx_15foundations_lab", scope: !153, file: !146, line: 1184, type: !20, scopeLine: 1184, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!153 = !DINamespace(name: "{impl#6}", scope: !148)
!154 = !DILocation(line: 26, column: 25, scope: !155)
!155 = !DILexicalBlockFile(scope: !156, file: !18, discriminator: 2)
!156 = distinct !DILexicalBlock(scope: !157, file: !18, line: 26, column: 9)
!157 = distinct !DILexicalBlock(scope: !158, file: !18, line: 25, column: 5)
!158 = distinct !DILexicalBlock(scope: !124, file: !18, line: 25, column: 5)
!159 = !DILocation(line: 1013, column: 17, scope: !160, inlinedAt: !161)
!160 = distinct !DISubprogram(name: "unchecked_add", linkageName: "_RNvMs9_NtCsjIpoRzUjyHQ_4core3numj13unchecked_add", scope: !29, file: !28, line: 1001, type: !20, scopeLine: 1001, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!161 = !DILocation(line: 265, column: 28, scope: !162, inlinedAt: !164)
!162 = distinct !DISubprogram(name: "forward_unchecked", linkageName: "_RNvXsL_NtNtCsjIpoRzUjyHQ_4core4iter5rangejNtB5_4Step17forward_unchecked", scope: !163, file: !146, line: 263, type: !20, scopeLine: 263, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!163 = !DINamespace(name: "{impl#49}", scope: !148)
!164 = !DILocation(line: 1103, column: 35, scope: !165, inlinedAt: !166)
!165 = distinct !DILexicalBlock(scope: !145, file: !146, line: 1101, column: 13)
!166 = !DILocation(line: 1185, column: 14, scope: !152, inlinedAt: !167)
!167 = !DILocation(line: 25, column: 18, scope: !168)
!168 = !DILexicalBlockFile(scope: !158, file: !18, discriminator: 2)
!169 = !DILocation(line: 25, column: 9, scope: !158)
!170 = !DILocation(line: 1013, column: 17, scope: !160, inlinedAt: !171)
!171 = !DILocation(line: 265, column: 28, scope: !172, inlinedAt: !173)
!172 = !DILexicalBlockFile(scope: !162, file: !146, discriminator: 2)
!173 = !DILocation(line: 1103, column: 35, scope: !174, inlinedAt: !150)
!174 = !DILexicalBlockFile(scope: !175, file: !146, discriminator: 2)
!175 = distinct !DILexicalBlock(scope: !145, file: !146, line: 1101, column: 13)
!176 = !DILocation(line: 26, column: 13, scope: !156)
!177 = !DILocation(line: 27, column: 25, scope: !178)
!178 = distinct !DILexicalBlock(scope: !156, file: !18, line: 26, column: 9)
!179 = !DILocation(line: 28, column: 24, scope: !180)
!180 = distinct !DILexicalBlock(scope: !178, file: !18, line: 27, column: 13)
!181 = !DILocation(line: 29, column: 17, scope: !182)
!182 = distinct !DILexicalBlock(scope: !180, file: !18, line: 28, column: 13)
!183 = !DILocation(line: 29, column: 25, scope: !182)
!184 = !DILocation(line: 31, column: 27, scope: !185)
!185 = distinct !DILexicalBlock(scope: !186, file: !18, line: 30, column: 13)
!186 = distinct !DILexicalBlock(scope: !187, file: !18, line: 30, column: 13)
!187 = distinct !DILexicalBlock(scope: !182, file: !18, line: 29, column: 13)
!188 = !DILocation(line: 2327, column: 38, scope: !189, inlinedAt: !193)
!189 = distinct !DISubprogram(name: "call_mut<(), dyn core::ops::function::FnMut<(), Output=u64>, alloc::alloc::Global>", linkageName: "_RNvXsu_NtCs6zY7rJBZy9D_5alloc5boxedINtB5_3BoxDINtNtNtCsjIpoRzUjyHQ_4core3ops8function5FnMutuEp6OutputyEL_EIBJ_uE8call_mutCs9cj3cTKSYZx_15foundations_lab", scope: !191, file: !190, line: 2326, type: !20, scopeLine: 2326, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!190 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/alloc/src/boxed.rs", directory: "", checksumkind: CSK_MD5, checksum: "d08167ce38615623852d82b0b0764c28")
!191 = !DINamespace(name: "{impl#32}", scope: !192)
!192 = !DINamespace(name: "boxed", scope: !45)
!193 = !DILocation(line: 31, column: 37, scope: !185)
!194 = !{i64 8}
!195 = !DILocation(line: 2327, column: 9, scope: !189, inlinedAt: !193)
!196 = !DILocation(line: 627, column: 28, scope: !197, inlinedAt: !198)
!197 = distinct !DISubprogram(name: "add<u64>", linkageName: "_RNvMs1_NtNtCsjIpoRzUjyHQ_4core3ptr8non_nullINtB5_7NonNullyE3addCs9cj3cTKSYZx_15foundations_lab", scope: !137, file: !136, line: 619, type: !20, scopeLine: 619, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!198 = !DILocation(line: 185, column: 40, scope: !199, inlinedAt: !203)
!199 = !DILexicalBlockFile(scope: !200, file: !127, discriminator: 2)
!200 = distinct !DILexicalBlock(scope: !201, file: !127, line: 162, column: 17)
!201 = distinct !DILexicalBlock(scope: !202, file: !127, line: 161, column: 17)
!202 = distinct !DISubprogram(name: "next<u64>", linkageName: "_RNvXs2Q_NtNtCsjIpoRzUjyHQ_4core5slice4iterINtB6_7IterMutyENtNtNtNtBa_4iter6traits8iterator8Iterator4nextCs9cj3cTKSYZx_15foundations_lab", scope: !130, file: !127, line: 157, type: !20, scopeLine: 157, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!203 = !DILocation(line: 30, column: 27, scope: !204)
!204 = !DILexicalBlockFile(scope: !186, file: !18, discriminator: 2)
!205 = !DILocation(line: 491, column: 5, scope: !206, inlinedAt: !184)
!206 = distinct !DISubprogram(name: "black_box<u64>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core4hint9black_boxyECs9cj3cTKSYZx_15foundations_lab", scope: !208, file: !207, line: 490, type: !20, scopeLine: 490, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!207 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/hint.rs", directory: "", checksumkind: CSK_MD5, checksum: "720ecb12dbf1a304509abd161627e0e2")
!208 = !DINamespace(name: "hint", scope: !31)
!209 = !{i64 1341301106983877}
!210 = !DILocation(line: 31, column: 17, scope: !185)
!211 = !DILocation(line: 31, column: 50, scope: !185)
!212 = !DILocation(line: 1663, column: 9, scope: !213, inlinedAt: !215)
!213 = distinct !DISubprogram(name: "eq<u64>", linkageName: "_RNvXsd_NtNtCsjIpoRzUjyHQ_4core3ptr8non_nullINtB5_7NonNullyENtNtB9_3cmp9PartialEq2eqCs9cj3cTKSYZx_15foundations_lab", scope: !214, file: !136, line: 1662, type: !20, scopeLine: 1662, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!214 = !DINamespace(name: "{impl#15}", scope: !138)
!215 = !DILocation(line: 180, column: 28, scope: !199, inlinedAt: !203)
!216 = !DILocation(line: 180, column: 28, scope: !200, inlinedAt: !203)
!217 = !DILocation(line: 33, column: 33, scope: !187)
!218 = !DILocation(line: 33, column: 27, scope: !187)
!219 = !DILocation(line: 34, column: 40, scope: !220)
!220 = distinct !DILexicalBlock(scope: !187, file: !18, line: 33, column: 13)
!221 = !{!222}
!222 = distinct !{!222, !223, !"_RINvXs2J_NtNtCsjIpoRzUjyHQ_4core5slice4iterINtB7_4IteryENtNtNtNtBb_4iter6traits8iterator8Iterator3allNCNvCs9cj3cTKSYZx_15foundations_lab3run0EB1F_: argument 1"}
!223 = distinct !{!223, !"_RINvXs2J_NtNtCsjIpoRzUjyHQ_4core5slice4iterINtB7_4IteryENtNtNtNtBb_4iter6traits8iterator8Iterator3allNCNvCs9cj3cTKSYZx_15foundations_lab3run0EB1F_"}
!224 = !DILocation(line: 34, column: 36, scope: !220)
!225 = !{!226}
!226 = distinct !{!226, !223, !"_RINvXs2J_NtNtCsjIpoRzUjyHQ_4core5slice4iterINtB7_4IteryENtNtNtNtBb_4iter6traits8iterator8Iterator3allNCNvCs9cj3cTKSYZx_15foundations_lab3run0EB1F_: %self"}
!227 = !DILocation(line: 180, column: 28, scope: !228, inlinedAt: !232)
!228 = distinct !DILexicalBlock(scope: !229, file: !127, line: 162, column: 17)
!229 = distinct !DILexicalBlock(scope: !230, file: !127, line: 161, column: 17)
!230 = distinct !DISubprogram(name: "next<u64>", linkageName: "_RNvXs2J_NtNtCsjIpoRzUjyHQ_4core5slice4iterINtB6_4IteryENtNtNtNtBa_4iter6traits8iterator8Iterator4nextCs9cj3cTKSYZx_15foundations_lab", scope: !231, file: !127, line: 157, type: !20, scopeLine: 157, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!231 = !DINamespace(name: "{impl#171}", scope: !117)
!232 = distinct !DILocation(line: 309, column: 42, scope: !233, inlinedAt: !235)
!233 = distinct !DILexicalBlock(scope: !234, file: !127, line: 309, column: 49)
!234 = distinct !DISubprogram(name: "all<u64, foundations_lab::run::{closure_env#0}>", linkageName: "_RINvXs2J_NtNtCsjIpoRzUjyHQ_4core5slice4iterINtB7_4IteryENtNtNtNtBb_4iter6traits8iterator8Iterator3allNCNvCs9cj3cTKSYZx_15foundations_lab3run0EB1F_", scope: !231, file: !127, line: 304, type: !20, scopeLine: 304, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!235 = distinct !DILocation(line: 34, column: 36, scope: !220)
!236 = !DILocation(line: 310, column: 25, scope: !233, inlinedAt: !235)
!237 = !{!226, !222}
!238 = !DILocation(line: 34, column: 45, scope: !239, inlinedAt: !242)
!239 = distinct !DILexicalBlock(scope: !240, file: !18, line: 34, column: 45)
!240 = distinct !DISubprogram(name: "{closure#0}", linkageName: "_RNCNvCs9cj3cTKSYZx_15foundations_lab3run0B3_", scope: !241, file: !18, line: 34, type: !92, scopeLine: 34, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!241 = !DINamespace(name: "run", scope: !19)
!242 = distinct !DILocation(line: 310, column: 25, scope: !233, inlinedAt: !235)
!243 = !DILocation(line: 627, column: 28, scope: !244, inlinedAt: !245)
!244 = distinct !DISubprogram(name: "add<u64>", linkageName: "_RNvMs1_NtNtCsjIpoRzUjyHQ_4core3ptr8non_nullINtB5_7NonNullyE3addCs9cj3cTKSYZx_15foundations_lab", scope: !137, file: !136, line: 619, type: !20, scopeLine: 619, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!245 = distinct !DILocation(line: 185, column: 40, scope: !228, inlinedAt: !232)
!246 = distinct !{!246, !247}
!247 = !{!"llvm.loop.unroll.disable"}
!248 = !DILocation(line: 1663, column: 9, scope: !249, inlinedAt: !250)
!249 = distinct !DISubprogram(name: "eq<u64>", linkageName: "_RNvXsd_NtNtCsjIpoRzUjyHQ_4core3ptr8non_nullINtB5_7NonNullyENtNtB9_3cmp9PartialEq2eqCs9cj3cTKSYZx_15foundations_lab", scope: !214, file: !136, line: 1662, type: !20, scopeLine: 1662, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!250 = distinct !DILocation(line: 180, column: 28, scope: !228, inlinedAt: !232)
!251 = !DILocation(line: 35, column: 17, scope: !220)
!252 = !DILocation(line: 867, column: 9, scope: !253, inlinedAt: !257)
!253 = distinct !DISubprogram(name: "as_secs_f64", linkageName: "_RNvMNtCsjIpoRzUjyHQ_4core4timeNtB2_8Duration11as_secs_f64", scope: !255, file: !254, line: 866, type: !20, scopeLine: 866, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!254 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/time.rs", directory: "", checksumkind: CSK_MD5, checksum: "cd970f898658d081a7396ea0a414e543")
!255 = !DINamespace(name: "Duration", scope: !256)
!256 = !DINamespace(name: "time", scope: !31)
!257 = !DILocation(line: 35, column: 30, scope: !220)
!258 = !DILocation(line: 49, column: 26, scope: !259, inlinedAt: !263)
!259 = distinct !DISubprogram(name: "as_inner", linkageName: "_RNvMs6_NtNtCsjIpoRzUjyHQ_4core3num11niche_typesNtB5_11Nanoseconds8as_inner", scope: !261, file: !260, line: 46, type: !20, scopeLine: 46, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!260 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/num/niche_types.rs", directory: "", checksumkind: CSK_MD5, checksum: "489873530aeeab72b6610b8d531aed40")
!261 = !DINamespace(name: "Nanoseconds", scope: !262)
!262 = !DINamespace(name: "niche_types", scope: !30)
!263 = !DILocation(line: 867, column: 42, scope: !253, inlinedAt: !257)
!264 = !DILocation(line: 867, column: 30, scope: !253, inlinedAt: !257)
!265 = !DILocation(line: 35, column: 22, scope: !220)
!266 = !DILocation(line: 36, column: 13, scope: !267)
!267 = !DILexicalBlockFile(scope: !268, file: !18, discriminator: 0)
!268 = distinct !DILexicalBlock(scope: !270, file: !269, line: 148, column: 28)
!269 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/std/src/macros.rs", directory: "", checksumkind: CSK_MD5, checksum: "2da795cca9929b416fe81779263e01a7")
!270 = distinct !DILexicalBlock(scope: !220, file: !18, line: 35, column: 13)
!271 = !DILocation(line: 36, column: 13, scope: !270)
!272 = !DILocation(line: 40, column: 9, scope: !220)
!273 = !DILocation(line: 40, column: 9, scope: !182)
!274 = !DILocation(line: 40, column: 9, scope: !156)
!275 = !DILocation(line: 2144, column: 50, scope: !276, inlinedAt: !281)
!276 = distinct !DISubprogram(name: "lt", linkageName: "_RNvXsU_NtNtCsjIpoRzUjyHQ_4core3cmp5implsjNtB7_10PartialOrd2lt", scope: !278, file: !277, line: 2144, type: !20, scopeLine: 2144, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!277 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/cmp.rs", directory: "", checksumkind: CSK_MD5, checksum: "49e2a03e6445d88887d9438f640a7fcc")
!278 = !DINamespace(name: "{impl#58}", scope: !279)
!279 = !DINamespace(name: "impls", scope: !280)
!280 = !DINamespace(name: "cmp", scope: !31)
!281 = !DILocation(line: 1100, column: 12, scope: !282, inlinedAt: !150)
!282 = !DILexicalBlockFile(scope: !145, file: !146, discriminator: 2)
!283 = !DILocation(line: 41, column: 5, scope: !158)
!284 = !DILocation(line: 2144, column: 50, scope: !276, inlinedAt: !285)
!285 = !DILocation(line: 1100, column: 12, scope: !145, inlinedAt: !166)
!286 = !DILocation(line: 631, column: 39, scope: !287, inlinedAt: !288)
!287 = distinct !DISubprogram(name: "current_memory<alloc::alloc::Global>", linkageName: "_RNvMs2_NtCs6zY7rJBZy9D_5alloc7raw_vecNtB5_11RawVecInner14current_memoryCs9cj3cTKSYZx_15foundations_lab", scope: !48, file: !43, line: 630, type: !92, scopeLine: 630, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!288 = distinct !DILocation(line: 874, column: 52, scope: !289, inlinedAt: !291)
!289 = distinct !DILexicalBlock(scope: !290, file: !43, line: 874, column: 82)
!290 = distinct !DISubprogram(name: "deallocate<alloc::alloc::Global>", linkageName: "_RNvMs3_NtCs6zY7rJBZy9D_5alloc7raw_vecNtB5_11RawVecInner10deallocateCs9cj3cTKSYZx_15foundations_lab", scope: !48, file: !43, line: 872, type: !92, scopeLine: 872, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!291 = distinct !DILocation(line: 425, column: 29, scope: !292, inlinedAt: !294)
!292 = distinct !DISubprogram(name: "drop<u64, alloc::alloc::Global>", linkageName: "_RNvXs1_NtCs6zY7rJBZy9D_5alloc7raw_vecINtB5_6RawVecyENtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4dropCs9cj3cTKSYZx_15foundations_lab", scope: !293, file: !43, line: 423, type: !92, scopeLine: 423, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!293 = !DINamespace(name: "{impl#3}", scope: !44)
!294 = distinct !DILocation(line: 847, column: 1, scope: !295, inlinedAt: !297)
!295 = distinct !DISubprogram(name: "drop_glue<alloc::raw_vec::RawVec<u64, alloc::alloc::Global>>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc7raw_vec6RawVecyEECs9cj3cTKSYZx_15foundations_lab", scope: !110, file: !296, line: 847, type: !92, scopeLine: 847, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!296 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/ptr/mod.rs", directory: "", checksumkind: CSK_MD5, checksum: "59033ebc630da002040513c25c9de121")
!297 = distinct !DILocation(line: 847, column: 1, scope: !298, inlinedAt: !299)
!298 = distinct !DISubprogram(name: "drop_glue<alloc::vec::Vec<u64, alloc::alloc::Global>>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc3vec3VecyEECs9cj3cTKSYZx_15foundations_lab", scope: !110, file: !296, line: 847, type: !92, scopeLine: 847, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!299 = distinct !DILocation(line: 42, column: 1, scope: !17)
!300 = !DILocation(line: 1401, column: 17, scope: !301, inlinedAt: !302)
!301 = distinct !DISubprogram(name: "unchecked_mul", linkageName: "_RNvMs9_NtCsjIpoRzUjyHQ_4core3numj13unchecked_mul", scope: !29, file: !28, line: 1389, type: !20, scopeLine: 1389, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!302 = distinct !DILocation(line: 639, column: 53, scope: !287, inlinedAt: !288)
!303 = !DILocation(line: 175, column: 14, scope: !304, inlinedAt: !305)
!304 = distinct !DISubprogram(name: "dealloc_nonnull", linkageName: "_RNvNtCs6zY7rJBZy9D_5alloc5alloc15dealloc_nonnull", scope: !82, file: !81, line: 174, type: !20, scopeLine: 174, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!305 = distinct !DILocation(line: 321, column: 22, scope: !306, inlinedAt: !307)
!306 = distinct !DISubprogram(name: "deallocate_impl_runtime", linkageName: "_RNvMs0_NtCs6zY7rJBZy9D_5alloc5allocNtB5_6Global23deallocate_impl_runtime", scope: !86, file: !81, line: 311, type: !20, scopeLine: 311, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!307 = distinct !DILocation(line: 436, column: 9, scope: !308, inlinedAt: !309)
!308 = distinct !DISubprogram(name: "deallocate_impl", linkageName: "_RNvMs0_NtCs6zY7rJBZy9D_5alloc5allocNtB5_6Global15deallocate_impl", scope: !86, file: !81, line: 435, type: !20, scopeLine: 435, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!309 = distinct !DILocation(line: 554, column: 23, scope: !310, inlinedAt: !311)
!310 = distinct !DISubprogram(name: "deallocate", linkageName: "_RNvXs1_NtCs6zY7rJBZy9D_5alloc5allocNtB5_6GlobalNtNtCsjIpoRzUjyHQ_4core5alloc9Allocator10deallocate", scope: !91, file: !81, line: 552, type: !92, scopeLine: 552, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!311 = distinct !DILocation(line: 876, column: 28, scope: !289, inlinedAt: !291)
!312 = !DILocation(line: 312, column: 9, scope: !306, inlinedAt: !307)
!313 = !DILocation(line: 20, column: 21, scope: !314)
!314 = distinct !DILexicalBlock(scope: !141, file: !18, line: 19, column: 9)
!315 = !DILocation(line: 20, column: 15, scope: !314)
!316 = !DILocation(line: 79, column: 50, scope: !317, inlinedAt: !319)
!317 = distinct !DISubprogram(name: "cmp", linkageName: "_RNvXsk_NtCsjIpoRzUjyHQ_4core4timeNtB5_8DurationNtNtB7_3cmp3Ord3cmp", scope: !318, file: !254, line: 79, type: !20, scopeLine: 79, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!318 = !DINamespace(name: "{impl#22}", scope: !256)
!319 = !DILocation(line: 79, column: 38, scope: !320, inlinedAt: !322)
!320 = distinct !DISubprogram(name: "partial_cmp", linkageName: "_RNvXsj_NtCsjIpoRzUjyHQ_4core4timeNtB5_8DurationNtNtB7_3cmp10PartialOrd11partial_cmp", scope: !321, file: !254, line: 79, type: !20, scopeLine: 79, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!321 = !DINamespace(name: "{impl#21}", scope: !256)
!322 = !DILocation(line: 1423, column: 14, scope: !323, inlinedAt: !315)
!323 = distinct !DISubprogram(name: "lt<core::time::Duration, core::time::Duration>", linkageName: "_RNvYNtNtCsjIpoRzUjyHQ_4core4time8DurationNtNtB6_3cmp10PartialOrd2ltCs9cj3cTKSYZx_15foundations_lab", scope: !324, file: !277, line: 1422, type: !20, scopeLine: 1422, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!324 = !DINamespace(name: "PartialOrd", scope: !280)
!325 = !DILocation(line: 49, column: 26, scope: !259, inlinedAt: !326)
!326 = !DILocation(line: 70, column: 32, scope: !327, inlinedAt: !329)
!327 = distinct !DISubprogram(name: "cmp", linkageName: "_RNvXsa_NtNtCsjIpoRzUjyHQ_4core3num11niche_typesNtB5_11NanosecondsNtNtB9_3cmp3Ord3cmp", scope: !328, file: !260, line: 69, type: !20, scopeLine: 69, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!328 = !DINamespace(name: "{impl#12}", scope: !262)
!329 = !DILocation(line: 79, column: 50, scope: !330, inlinedAt: !319)
!330 = !DILexicalBlockFile(scope: !317, file: !254, discriminator: 2)
!331 = !DILocation(line: 494, column: 9, scope: !332, inlinedAt: !334)
!332 = distinct !DISubprogram(name: "is_lt", linkageName: "_RNvMNtCsjIpoRzUjyHQ_4core3cmpNtB2_8Ordering5is_lt", scope: !333, file: !277, line: 493, type: !20, scopeLine: 493, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!333 = !DINamespace(name: "Ordering", scope: !280)
!334 = !DILocation(line: 250, column: 5, scope: !335, inlinedAt: !340)
!335 = distinct !DISubprogram(name: "call_once<fn(core::cmp::Ordering) -> bool, (core::cmp::Ordering)>", linkageName: "_RNvYNvMNtCsjIpoRzUjyHQ_4core3cmpNtB5_8Ordering5is_ltINtNtNtB7_3ops8function6FnOnceTBu_EE9call_onceCs9cj3cTKSYZx_15foundations_lab", scope: !337, file: !336, line: 250, type: !20, scopeLine: 250, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!336 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/ops/function.rs", directory: "", checksumkind: CSK_MD5, checksum: "ae01f833f82cd27aa916c99d95502941")
!337 = !DINamespace(name: "FnOnce", scope: !338)
!338 = !DINamespace(name: "function", scope: !339)
!339 = !DINamespace(name: "ops", scope: !31)
!340 = !DILocation(line: 662, column: 24, scope: !341, inlinedAt: !346)
!341 = distinct !DILexicalBlock(scope: !343, file: !342, line: 662, column: 13)
!342 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/option.rs", directory: "", checksumkind: CSK_MD5, checksum: "6b6523786d7acedb57d33f9868027e9f")
!343 = distinct !DISubprogram(name: "is_some_and<core::cmp::Ordering, fn(core::cmp::Ordering) -> bool>", linkageName: "_RINvMNtCsjIpoRzUjyHQ_4core6optionINtB3_6OptionNtNtB5_3cmp8OrderingE11is_some_andNvMBK_BI_5is_ltECs9cj3cTKSYZx_15foundations_lab", scope: !344, file: !342, line: 659, type: !20, scopeLine: 659, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!344 = !DINamespace(name: "Option", scope: !345)
!345 = !DINamespace(name: "option", scope: !31)
!346 = !DILocation(line: 1423, column: 33, scope: !323, inlinedAt: !315)
!347 = !DILocation(line: 23, column: 5, scope: !141)
!348 = !DILocation(line: 1663, column: 9, scope: !349, inlinedAt: !125)
!349 = distinct !DISubprogram(name: "eq<foundations_lab::Case>", linkageName: "_RNvXsd_NtNtCsjIpoRzUjyHQ_4core3ptr8non_nullINtB5_7NonNullNtCs9cj3cTKSYZx_15foundations_lab4CaseENtNtB9_3cmp9PartialEq2eqBV_", scope: !214, file: !136, line: 1662, type: !20, scopeLine: 1662, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!350 = !DILocation(line: 21, column: 24, scope: !314)
!351 = !DILocation(line: 2327, column: 38, scope: !189, inlinedAt: !352)
!352 = !DILocation(line: 21, column: 34, scope: !314)
!353 = !DILocation(line: 2327, column: 9, scope: !189, inlinedAt: !352)
!354 = !DILocation(line: 491, column: 5, scope: !206, inlinedAt: !350)
!355 = !DILocation(line: 21, column: 13, scope: !356)
!356 = !DILexicalBlockFile(scope: !357, file: !18, discriminator: 0)
!357 = distinct !DILexicalBlock(scope: !314, file: !358, line: 46, column: 13)
!358 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/macros/mod.rs", directory: "", checksumkind: CSK_MD5, checksum: "2f18ff6bcbb078f77779c8f14def2c67")
!359 = !{!"branch_weights", !"expected", i32 2000, i32 1}
!360 = !DILocation(line: 21, column: 13, scope: !361)
!361 = !DILexicalBlockFile(scope: !362, file: !18, discriminator: 0)
!362 = distinct !DILexicalBlock(scope: !357, file: !358, line: 48, column: 21)
!363 = !DILocation(line: 21, column: 13, scope: !314)
!364 = !DILocation(line: 20, column: 9, scope: !314)
!365 = !DILocation(line: 631, column: 39, scope: !287, inlinedAt: !366)
!366 = distinct !DILocation(line: 874, column: 52, scope: !289, inlinedAt: !367)
!367 = distinct !DILocation(line: 425, column: 29, scope: !292, inlinedAt: !368)
!368 = distinct !DILocation(line: 847, column: 1, scope: !295, inlinedAt: !369)
!369 = distinct !DILocation(line: 847, column: 1, scope: !298, inlinedAt: !370)
!370 = distinct !DILocation(line: 42, column: 1, scope: !17)
!371 = !DILocation(line: 1401, column: 17, scope: !301, inlinedAt: !372)
!372 = distinct !DILocation(line: 639, column: 53, scope: !287, inlinedAt: !366)
!373 = !DILocation(line: 175, column: 14, scope: !304, inlinedAt: !374)
!374 = distinct !DILocation(line: 321, column: 22, scope: !306, inlinedAt: !375)
!375 = distinct !DILocation(line: 436, column: 9, scope: !308, inlinedAt: !376)
!376 = distinct !DILocation(line: 554, column: 23, scope: !310, inlinedAt: !377)
!377 = distinct !DILocation(line: 876, column: 28, scope: !289, inlinedAt: !367)
!378 = !DILocation(line: 312, column: 9, scope: !306, inlinedAt: !375)
!379 = !DILocation(line: 42, column: 2, scope: !17)
!380 = !DILocation(line: 34, column: 13, scope: !220)
!381 = !DILocation(line: 15, column: 1, scope: !17)
!382 = distinct !DISubprogram(name: "data", linkageName: "_RNvCs9cj3cTKSYZx_15foundations_lab4data", scope: !19, file: !18, line: 44, type: !20, scopeLine: 44, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!383 = !{i64 7603567181704331664}
!384 = !{!385}
!385 = distinct !{!385, !386, !"_RNvXs_NtNtCs6zY7rJBZy9D_5alloc3vec21spec_from_iter_nestedINtB6_3VecyEINtB4_18SpecFromIterNestedyINtNtNtNtCsjIpoRzUjyHQ_4core4iter8adapters3map3MapINtNtNtB1F_3ops5range5RangejENCNvCs9cj3cTKSYZx_15foundations_lab4data0EE9from_iterB2R_: %_0"}
!386 = distinct !{!386, !"_RNvXs_NtNtCs6zY7rJBZy9D_5alloc3vec21spec_from_iter_nestedINtB6_3VecyEINtB4_18SpecFromIterNestedyINtNtNtNtCsjIpoRzUjyHQ_4core4iter8adapters3map3MapINtNtNtB1F_3ops5range5RangejENCNvCs9cj3cTKSYZx_15foundations_lab4data0EE9from_iterB2R_"}
!387 = !DILocation(line: 33, column: 9, scope: !388, inlinedAt: !392)
!388 = distinct !DISubprogram(name: "from_iter<u64, core::iter::adapters::map::Map<core::ops::range::Range<usize>, foundations_lab::data::{closure_env#0}>>", linkageName: "_RNvXNtNtCs6zY7rJBZy9D_5alloc3vec14spec_from_iterINtB4_3VecyEINtB2_12SpecFromIteryINtNtNtNtCsjIpoRzUjyHQ_4core4iter8adapters3map3MapINtNtNtB1q_3ops5range5RangejENCNvCs9cj3cTKSYZx_15foundations_lab4data0EE9from_iterB2C_", scope: !390, file: !389, line: 32, type: !20, scopeLine: 32, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!389 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/alloc/src/vec/spec_from_iter.rs", directory: "", checksumkind: CSK_MD5, checksum: "87e48553151b7c26b3585234ec8e05e7")
!390 = !DINamespace(name: "{impl#0}", scope: !391)
!391 = !DINamespace(name: "spec_from_iter", scope: !59)
!392 = !DILocation(line: 3996, column: 9, scope: !393, inlinedAt: !395)
!393 = distinct !DISubprogram(name: "from_iter<u64, core::iter::adapters::map::Map<core::ops::range::Range<usize>, foundations_lab::data::{closure_env#0}>>", linkageName: "_RINvXsf_NtCs6zY7rJBZy9D_5alloc3vecINtB6_3VecyEINtNtNtNtCsjIpoRzUjyHQ_4core4iter6traits7collect12FromIteratoryE9from_iterINtNtNtBP_8adapters3map3MapINtNtNtBR_3ops5range5RangejENCNvCs9cj3cTKSYZx_15foundations_lab4data0EEB2R_", scope: !394, file: !62, line: 3995, type: !20, scopeLine: 3995, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!394 = !DINamespace(name: "{impl#17}", scope: !59)
!395 = !DILocation(line: 2086, column: 9, scope: !396, inlinedAt: !401)
!396 = distinct !DISubprogram(name: "collect<core::iter::adapters::map::Map<core::ops::range::Range<usize>, foundations_lab::data::{closure_env#0}>, alloc::vec::Vec<u64, alloc::alloc::Global>>", linkageName: "_RINvYINtNtNtNtCsjIpoRzUjyHQ_4core4iter8adapters3map3MapINtNtNtBc_3ops5range5RangejENCNvCs9cj3cTKSYZx_15foundations_lab4data0ENtNtNtBa_6traits8iterator8Iterator7collectINtNtCs6zY7rJBZy9D_5alloc3vec3VecyEEB1n_", scope: !398, file: !397, line: 2073, type: !20, scopeLine: 2073, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!397 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/iter/traits/iterator.rs", directory: "", checksumkind: CSK_MD5, checksum: "18f221b1fea37f3a9346ab1e3a47427f")
!398 = !DINamespace(name: "Iterator", scope: !399)
!399 = !DINamespace(name: "iterator", scope: !400)
!400 = !DINamespace(name: "traits", scope: !149)
!401 = !DILocation(line: 47, column: 10, scope: !382)
!402 = !DILocation(line: 3212, column: 26, scope: !27, inlinedAt: !403)
!403 = distinct !DILocation(line: 1330, column: 31, scope: !33, inlinedAt: !404)
!404 = distinct !DILocation(line: 533, column: 39, scope: !35, inlinedAt: !405)
!405 = distinct !DILocation(line: 901, column: 17, scope: !42, inlinedAt: !406)
!406 = distinct !DILocation(line: 455, column: 28, scope: !47, inlinedAt: !407)
!407 = distinct !DILocation(line: 435, column: 15, scope: !408, inlinedAt: !409)
!408 = distinct !DISubprogram(name: "with_capacity_in<alloc::alloc::Global>", linkageName: "_RNvMs5_NtCs6zY7rJBZy9D_5alloc7raw_vecNtB5_11RawVecInner16with_capacity_inCs9cj3cTKSYZx_15foundations_lab", scope: !48, file: !43, line: 434, type: !20, scopeLine: 434, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!409 = distinct !DILocation(line: 177, column: 20, scope: !410, inlinedAt: !411)
!410 = distinct !DISubprogram(name: "with_capacity_in<u64, alloc::alloc::Global>", linkageName: "_RNvMs4_NtCs6zY7rJBZy9D_5alloc7raw_vecINtB5_6RawVecyE16with_capacity_inCs9cj3cTKSYZx_15foundations_lab", scope: !53, file: !43, line: 175, type: !20, scopeLine: 175, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!411 = distinct !DILocation(line: 969, column: 20, scope: !412, inlinedAt: !414)
!412 = distinct !DISubprogram(name: "with_capacity_in<u64, alloc::alloc::Global>", linkageName: "_RNvMsG_NtCs6zY7rJBZy9D_5alloc3vecINtB5_3VecyE16with_capacity_inCs9cj3cTKSYZx_15foundations_lab", scope: !413, file: !62, line: 968, type: !20, scopeLine: 968, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!413 = !DINamespace(name: "Vec", scope: !59)
!414 = distinct !DILocation(line: 522, column: 9, scope: !415, inlinedAt: !416)
!415 = distinct !DISubprogram(name: "with_capacity<u64>", linkageName: "_RNvMNtCs6zY7rJBZy9D_5alloc3vecINtB2_3VecyE13with_capacityCs9cj3cTKSYZx_15foundations_lab", scope: !413, file: !62, line: 521, type: !20, scopeLine: 521, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!416 = distinct !DILocation(line: 52, column: 33, scope: !417, inlinedAt: !422)
!417 = distinct !DILexicalBlock(scope: !419, file: !418, line: 52, column: 13)
!418 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/alloc/src/vec/spec_from_iter_nested.rs", directory: "", checksumkind: CSK_MD5, checksum: "f1ca97f56309a9c2b99339993bd752ef")
!419 = distinct !DISubprogram(name: "from_iter<u64, core::iter::adapters::map::Map<core::ops::range::Range<usize>, foundations_lab::data::{closure_env#0}>>", linkageName: "_RNvXs_NtNtCs6zY7rJBZy9D_5alloc3vec21spec_from_iter_nestedINtB6_3VecyEINtB4_18SpecFromIterNestedyINtNtNtNtCsjIpoRzUjyHQ_4core4iter8adapters3map3MapINtNtNtB1F_3ops5range5RangejENCNvCs9cj3cTKSYZx_15foundations_lab4data0EE9from_iterB2R_", scope: !420, file: !418, line: 50, type: !20, scopeLine: 50, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!420 = !DINamespace(name: "{impl#1}", scope: !421)
!421 = !DINamespace(name: "spec_from_iter_nested", scope: !59)
!422 = distinct !DILocation(line: 33, column: 9, scope: !388, inlinedAt: !392)
!423 = !DILocation(line: 478, column: 8, scope: !65, inlinedAt: !424)
!424 = distinct !DILocation(line: 1331, column: 16, scope: !69, inlinedAt: !404)
!425 = !DILocation(line: 461, column: 12, scope: !72, inlinedAt: !407)
!426 = !DILocation(line: 0, scope: !72, inlinedAt: !407)
!427 = !{!428, !385}
!428 = distinct !{!428, !429, !"_RNvMs5_NtCs6zY7rJBZy9D_5alloc7raw_vecNtB5_11RawVecInner15try_allocate_inCs9cj3cTKSYZx_15foundations_lab: %_0"}
!429 = distinct !{!429, !"_RNvMs5_NtCs6zY7rJBZy9D_5alloc7raw_vecNtB5_11RawVecInner15try_allocate_inCs9cj3cTKSYZx_15foundations_lab"}
!430 = !DILocation(line: 130, column: 9, scope: !431, inlinedAt: !432)
!431 = distinct !DISubprogram(name: "alloc", linkageName: "_RNvNtCs6zY7rJBZy9D_5alloc5alloc5alloc", scope: !82, file: !81, line: 124, type: !20, scopeLine: 124, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!432 = distinct !DILocation(line: 302, column: 73, scope: !84, inlinedAt: !433)
!433 = distinct !DILocation(line: 424, column: 9, scope: !434, inlinedAt: !435)
!434 = distinct !DISubprogram(name: "alloc_impl", linkageName: "_RNvMs0_NtCs6zY7rJBZy9D_5alloc5allocNtB5_6Global10alloc_impl", scope: !86, file: !81, line: 423, type: !20, scopeLine: 423, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!435 = distinct !DILocation(line: 541, column: 14, scope: !436, inlinedAt: !437)
!436 = distinct !DISubprogram(name: "allocate", linkageName: "_RNvXs1_NtCs6zY7rJBZy9D_5alloc5allocNtB5_6GlobalNtNtCsjIpoRzUjyHQ_4core5alloc9Allocator8allocate", scope: !91, file: !81, line: 540, type: !92, scopeLine: 540, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!437 = distinct !DILocation(line: 466, column: 47, scope: !72, inlinedAt: !407)
!438 = !DILocation(line: 470, column: 25, scope: !95, inlinedAt: !407)
!439 = !DILocation(line: 470, column: 19, scope: !95, inlinedAt: !407)
!440 = !DILocation(line: 478, column: 9, scope: !98, inlinedAt: !407)
!441 = !DILocation(line: 483, column: 5, scope: !47, inlinedAt: !407)
!442 = !DILocation(line: 443, column: 25, scope: !443, inlinedAt: !409)
!443 = distinct !DILexicalBlock(scope: !408, file: !43, line: 443, column: 13)
!444 = !DILocation(line: 0, scope: !47, inlinedAt: !407)
!445 = !DILocation(line: 436, column: 16, scope: !408, inlinedAt: !409)
!446 = !DILocation(line: 764, column: 9, scope: !447, inlinedAt: !448)
!447 = distinct !DISubprogram(name: "needs_to_grow<alloc::alloc::Global>", linkageName: "_RNvMs2_NtCs6zY7rJBZy9D_5alloc7raw_vecNtB5_11RawVecInner13needs_to_growCs9cj3cTKSYZx_15foundations_lab", scope: !48, file: !43, line: 763, type: !20, scopeLine: 763, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!448 = distinct !DILocation(line: 439, column: 50, scope: !449, inlinedAt: !409)
!449 = distinct !DILexicalBlock(scope: !408, file: !43, line: 436, column: 13)
!450 = !DILocation(line: 210, column: 9, scope: !451, inlinedAt: !452)
!451 = distinct !DISubprogram(name: "assert_unchecked", linkageName: "_RNvNtCsjIpoRzUjyHQ_4core4hint16assert_unchecked", scope: !208, file: !207, line: 202, type: !20, scopeLine: 202, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!452 = distinct !DILocation(line: 439, column: 21, scope: !449, inlinedAt: !409)
!453 = !DILocation(line: 2144, column: 50, scope: !454, inlinedAt: !455)
!454 = distinct !DISubprogram(name: "lt", linkageName: "_RNvXsU_NtNtCsjIpoRzUjyHQ_4core3cmp5implsjNtB7_10PartialOrd2lt", scope: !278, file: !277, line: 2144, type: !20, scopeLine: 2144, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!455 = distinct !DILocation(line: 1100, column: 12, scope: !456, inlinedAt: !457)
!456 = distinct !DISubprogram(name: "spec_next<usize>", linkageName: "_RNvXs3_NtNtCsjIpoRzUjyHQ_4core4iter5rangeINtNtNtB9_3ops5range5RangejENtB5_17RangeIteratorImpl9spec_nextCs9cj3cTKSYZx_15foundations_lab", scope: !147, file: !146, line: 1099, type: !20, scopeLine: 1099, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!457 = distinct !DILocation(line: 1185, column: 14, scope: !458, inlinedAt: !459)
!458 = distinct !DISubprogram(name: "next<usize>", linkageName: "_RNvXs4_NtNtCsjIpoRzUjyHQ_4core4iter5rangeINtNtNtB9_3ops5range5RangejENtNtNtB7_6traits8iterator8Iterator4nextCs9cj3cTKSYZx_15foundations_lab", scope: !153, file: !146, line: 1184, type: !20, scopeLine: 1184, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!459 = distinct !DILocation(line: 2666, column: 34, scope: !460, inlinedAt: !463)
!460 = distinct !DILexicalBlock(scope: !461, file: !397, line: 2666, column: 41)
!461 = distinct !DILexicalBlock(scope: !462, file: !397, line: 2665, column: 9)
!462 = distinct !DISubprogram(name: "fold<core::ops::range::Range<usize>, (), core::iter::adapters::map::map_fold::{closure_env#0}<usize, u64, (), foundations_lab::data::{closure_env#0}, core::iter::traits::iterator::Iterator::for_each::call::{closure_env#0}<u64, alloc::vec::{impl#22}::extend_trusted::{closure_env#0}<u64, alloc::alloc::Global, core::iter::adapters::map::Map<core::ops::range::Range<usize>, foundations_lab::data::{closure_env#0}>>>>>", linkageName: "_RINvYINtNtNtCsjIpoRzUjyHQ_4core3ops5range5RangejENtNtNtNtBa_4iter6traits8iterator8Iterator4folduNCINvNtNtBR_8adapters3map8map_foldjyuNCNvCs9cj3cTKSYZx_15foundations_lab4data0NCINvNvBL_8for_each4callyNCINvMsk_NtCs6zY7rJBZy9D_5alloc3vecINtB3k_3VecyE14extend_trustedINtB1B_3MapB3_B27_EE0E0E0EB2b_", scope: !398, file: !397, line: 2660, type: !20, scopeLine: 2660, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!463 = distinct !DILocation(line: 128, column: 19, scope: !464, inlinedAt: !469)
!464 = distinct !DISubprogram(name: "fold<u64, core::ops::range::Range<usize>, foundations_lab::data::{closure_env#0}, (), core::iter::traits::iterator::Iterator::for_each::call::{closure_env#0}<u64, alloc::vec::{impl#22}::extend_trusted::{closure_env#0}<u64, alloc::alloc::Global, core::iter::adapters::map::Map<core::ops::range::Range<usize>, foundations_lab::data::{closure_env#0}>>>>", linkageName: "_RINvXs0_NtNtNtCsjIpoRzUjyHQ_4core4iter8adapters3mapINtB6_3MapINtNtNtBc_3ops5range5RangejENCNvCs9cj3cTKSYZx_15foundations_lab4data0ENtNtNtBa_6traits8iterator8Iterator4folduNCINvNvB25_8for_each4callyNCINvMsk_NtCs6zY7rJBZy9D_5alloc3vecINtB3i_3VecyE14extend_trustedBN_E0E0EB1t_", scope: !466, file: !465, line: 124, type: !20, scopeLine: 124, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!465 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/iter/adapters/map.rs", directory: "", checksumkind: CSK_MD5, checksum: "4c6778ae80de9d62520e12b61373153e")
!466 = !DINamespace(name: "{impl#2}", scope: !467)
!467 = !DINamespace(name: "map", scope: !468)
!468 = !DINamespace(name: "adapters", scope: !149)
!469 = distinct !DILocation(line: 887, column: 14, scope: !470, inlinedAt: !471)
!470 = distinct !DISubprogram(name: "for_each<core::iter::adapters::map::Map<core::ops::range::Range<usize>, foundations_lab::data::{closure_env#0}>, alloc::vec::{impl#22}::extend_trusted::{closure_env#0}<u64, alloc::alloc::Global, core::iter::adapters::map::Map<core::ops::range::Range<usize>, foundations_lab::data::{closure_env#0}>>>", linkageName: "_RINvYINtNtNtNtCsjIpoRzUjyHQ_4core4iter8adapters3map3MapINtNtNtBc_3ops5range5RangejENCNvCs9cj3cTKSYZx_15foundations_lab4data0ENtNtNtBa_6traits8iterator8Iterator8for_eachNCINvMsk_NtCs6zY7rJBZy9D_5alloc3vecINtB2P_3VecyE14extend_trustedB3_E0EB1n_", scope: !398, file: !397, line: 877, type: !20, scopeLine: 877, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!471 = distinct !DILocation(line: 4132, column: 26, scope: !472, inlinedAt: !477)
!472 = distinct !DILexicalBlock(scope: !473, file: !62, line: 4131, column: 17)
!473 = distinct !DILexicalBlock(scope: !474, file: !62, line: 4130, column: 17)
!474 = distinct !DILexicalBlock(scope: !475, file: !62, line: 4121, column: 40)
!475 = distinct !DILexicalBlock(scope: !476, file: !62, line: 4120, column: 9)
!476 = distinct !DISubprogram(name: "extend_trusted<u64, alloc::alloc::Global, core::iter::adapters::map::Map<core::ops::range::Range<usize>, foundations_lab::data::{closure_env#0}>>", linkageName: "_RINvMsk_NtCs6zY7rJBZy9D_5alloc3vecINtB6_3VecyE14extend_trustedINtNtNtNtCsjIpoRzUjyHQ_4core4iter8adapters3map3MapINtNtNtB17_3ops5range5RangejENCNvCs9cj3cTKSYZx_15foundations_lab4data0EEB2j_", scope: !413, file: !62, line: 4119, type: !20, scopeLine: 4119, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!477 = distinct !DILocation(line: 27, column: 14, scope: !478, inlinedAt: !482)
!478 = distinct !DISubprogram(name: "spec_extend<u64, core::iter::adapters::map::Map<core::ops::range::Range<usize>, foundations_lab::data::{closure_env#0}>, alloc::alloc::Global>", linkageName: "_RNvXs_NtNtCs6zY7rJBZy9D_5alloc3vec11spec_extendINtB6_3VecyEINtB4_10SpecExtendyINtNtNtNtCsjIpoRzUjyHQ_4core4iter8adapters3map3MapINtNtNtB1n_3ops5range5RangejENCNvCs9cj3cTKSYZx_15foundations_lab4data0EE11spec_extendB2z_", scope: !480, file: !479, line: 26, type: !20, scopeLine: 26, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!479 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/alloc/src/vec/spec_extend.rs", directory: "", checksumkind: CSK_MD5, checksum: "4ca86086df4f92d26bd5516641ae6bb5")
!480 = !DINamespace(name: "{impl#1}", scope: !481)
!481 = !DINamespace(name: "spec_extend", scope: !59)
!482 = distinct !DILocation(line: 60, column: 16, scope: !483, inlinedAt: !422)
!483 = distinct !DILexicalBlock(scope: !419, file: !418, line: 51, column: 9)
!484 = !DILocation(line: 1100, column: 12, scope: !456, inlinedAt: !457)
!485 = !DILocation(line: 1013, column: 17, scope: !486, inlinedAt: !487)
!486 = distinct !DISubprogram(name: "unchecked_add", linkageName: "_RNvMs9_NtCsjIpoRzUjyHQ_4core3numj13unchecked_add", scope: !29, file: !28, line: 1001, type: !20, scopeLine: 1001, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!487 = distinct !DILocation(line: 265, column: 28, scope: !488, inlinedAt: !489)
!488 = distinct !DISubprogram(name: "forward_unchecked", linkageName: "_RNvXsL_NtNtCsjIpoRzUjyHQ_4core4iter5rangejNtB5_4Step17forward_unchecked", scope: !163, file: !146, line: 263, type: !20, scopeLine: 263, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!489 = distinct !DILocation(line: 1103, column: 35, scope: !490, inlinedAt: !457)
!490 = distinct !DILexicalBlock(scope: !456, file: !146, line: 1101, column: 13)
!491 = !DILocation(line: 2728, column: 13, scope: !492, inlinedAt: !494)
!492 = distinct !DISubprogram(name: "wrapping_mul", linkageName: "_RNvMs7_NtCsjIpoRzUjyHQ_4core3numy12wrapping_mul", scope: !493, file: !28, line: 2727, type: !20, scopeLine: 2727, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!493 = !DINamespace(name: "{impl#9}", scope: !30)
!494 = distinct !DILocation(line: 46, column: 29, scope: !495, inlinedAt: !497)
!495 = distinct !DISubprogram(name: "{closure#0}", linkageName: "_RNCNvCs9cj3cTKSYZx_15foundations_lab4data0B3_", scope: !496, file: !18, line: 46, type: !92, scopeLine: 46, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!496 = !DINamespace(name: "data", scope: !19)
!497 = distinct !DILocation(line: 88, column: 28, scope: !498, inlinedAt: !500)
!498 = distinct !DISubprogram(name: "{closure#0}<usize, u64, (), foundations_lab::data::{closure_env#0}, core::iter::traits::iterator::Iterator::for_each::call::{closure_env#0}<u64, alloc::vec::{impl#22}::extend_trusted::{closure_env#0}<u64, alloc::alloc::Global, core::iter::adapters::map::Map<core::ops::range::Range<usize>, foundations_lab::data::{closure_env#0}>>>>", linkageName: "_RNCINvNtNtNtCsjIpoRzUjyHQ_4core4iter8adapters3map8map_foldjyuNCNvCs9cj3cTKSYZx_15foundations_lab4data0NCINvNvNtNtNtB8_6traits8iterator8Iterator8for_each4callyNCINvMsk_NtCs6zY7rJBZy9D_5alloc3vecINtB2F_3VecyE14extend_trustedINtB4_3MapINtNtNtBa_3ops5range5RangejEBX_EE0E0E0B11_", scope: !499, file: !465, line: 88, type: !20, scopeLine: 88, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!499 = !DINamespace(name: "map_fold", scope: !467)
!500 = distinct !DILocation(line: 2667, column: 21, scope: !460, inlinedAt: !463)
!501 = !DILocation(line: 46, column: 18, scope: !495, inlinedAt: !497)
!502 = !DILocation(line: 970, column: 18, scope: !503, inlinedAt: !504)
!503 = distinct !DISubprogram(name: "add<u64>", linkageName: "_RNvMNtNtCsjIpoRzUjyHQ_4core3ptr7mut_ptrOy3addCs9cj3cTKSYZx_15foundations_lab", scope: !108, file: !107, line: 936, type: !20, scopeLine: 936, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!504 = distinct !DILocation(line: 4133, column: 36, scope: !505, inlinedAt: !508)
!505 = distinct !DISubprogram(name: "{closure#0}<u64, alloc::alloc::Global, core::iter::adapters::map::Map<core::ops::range::Range<usize>, foundations_lab::data::{closure_env#0}>>", linkageName: "_RNCINvMsk_NtCs6zY7rJBZy9D_5alloc3vecINtB8_3VecyE14extend_trustedINtNtNtNtCsjIpoRzUjyHQ_4core4iter8adapters3map3MapINtNtNtB19_3ops5range5RangejENCNvCs9cj3cTKSYZx_15foundations_lab4data0EE0B2l_", scope: !506, file: !62, line: 4132, type: !20, scopeLine: 4132, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!506 = !DINamespace(name: "extend_trusted", scope: !507)
!507 = !DINamespace(name: "{impl#22}", scope: !59)
!508 = distinct !DILocation(line: 884, column: 29, scope: !509, inlinedAt: !512)
!509 = distinct !DISubprogram(name: "{closure#0}<u64, alloc::vec::{impl#22}::extend_trusted::{closure_env#0}<u64, alloc::alloc::Global, core::iter::adapters::map::Map<core::ops::range::Range<usize>, foundations_lab::data::{closure_env#0}>>>", linkageName: "_RNCINvNvNtNtNtNtCsjIpoRzUjyHQ_4core4iter6traits8iterator8Iterator8for_each4callyNCINvMsk_NtCs6zY7rJBZy9D_5alloc3vecINtB1p_3VecyE14extend_trustedINtNtNtBc_8adapters3map3MapINtNtNtBe_3ops5range5RangejENCNvCs9cj3cTKSYZx_15foundations_lab4data0EE0E0B3f_", scope: !510, file: !397, line: 884, type: !20, scopeLine: 884, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!510 = !DINamespace(name: "call", scope: !511)
!511 = !DINamespace(name: "for_each", scope: !398)
!512 = distinct !DILocation(line: 88, column: 21, scope: !498, inlinedAt: !500)
!513 = !DILocation(line: 1963, column: 41, scope: !514, inlinedAt: !515)
!514 = distinct !DISubprogram(name: "write<u64>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3ptr5writeyECs9cj3cTKSYZx_15foundations_lab", scope: !110, file: !296, line: 1940, type: !20, scopeLine: 1940, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!515 = distinct !DILocation(line: 4133, column: 21, scope: !505, inlinedAt: !508)
!516 = !{!517, !519, !521, !523, !525, !527, !529, !531, !385}
!517 = distinct !{!517, !518, !"_RNCINvMsk_NtCs6zY7rJBZy9D_5alloc3vecINtB8_3VecyE14extend_trustedINtNtNtNtCsjIpoRzUjyHQ_4core4iter8adapters3map3MapINtNtNtB19_3ops5range5RangejENCNvCs9cj3cTKSYZx_15foundations_lab4data0EE0B2l_: %_1"}
!518 = distinct !{!518, !"_RNCINvMsk_NtCs6zY7rJBZy9D_5alloc3vecINtB8_3VecyE14extend_trustedINtNtNtNtCsjIpoRzUjyHQ_4core4iter8adapters3map3MapINtNtNtB19_3ops5range5RangejENCNvCs9cj3cTKSYZx_15foundations_lab4data0EE0B2l_"}
!519 = distinct !{!519, !520, !"_RNCINvNvNtNtNtNtCsjIpoRzUjyHQ_4core4iter6traits8iterator8Iterator8for_each4callyNCINvMsk_NtCs6zY7rJBZy9D_5alloc3vecINtB1p_3VecyE14extend_trustedINtNtNtBc_8adapters3map3MapINtNtNtBe_3ops5range5RangejENCNvCs9cj3cTKSYZx_15foundations_lab4data0EE0E0B3f_: %_1"}
!520 = distinct !{!520, !"_RNCINvNvNtNtNtNtCsjIpoRzUjyHQ_4core4iter6traits8iterator8Iterator8for_each4callyNCINvMsk_NtCs6zY7rJBZy9D_5alloc3vecINtB1p_3VecyE14extend_trustedINtNtNtBc_8adapters3map3MapINtNtNtBe_3ops5range5RangejENCNvCs9cj3cTKSYZx_15foundations_lab4data0EE0E0B3f_"}
!521 = distinct !{!521, !522, !"_RNCINvNtNtNtCsjIpoRzUjyHQ_4core4iter8adapters3map8map_foldjyuNCNvCs9cj3cTKSYZx_15foundations_lab4data0NCINvNvNtNtNtB8_6traits8iterator8Iterator8for_each4callyNCINvMsk_NtCs6zY7rJBZy9D_5alloc3vecINtB2F_3VecyE14extend_trustedINtB4_3MapINtNtNtBa_3ops5range5RangejEBX_EE0E0E0B11_: %_1"}
!522 = distinct !{!522, !"_RNCINvNtNtNtCsjIpoRzUjyHQ_4core4iter8adapters3map8map_foldjyuNCNvCs9cj3cTKSYZx_15foundations_lab4data0NCINvNvNtNtNtB8_6traits8iterator8Iterator8for_each4callyNCINvMsk_NtCs6zY7rJBZy9D_5alloc3vecINtB2F_3VecyE14extend_trustedINtB4_3MapINtNtNtBa_3ops5range5RangejEBX_EE0E0E0B11_"}
!523 = distinct !{!523, !524, !"_RINvYINtNtNtCsjIpoRzUjyHQ_4core3ops5range5RangejENtNtNtNtBa_4iter6traits8iterator8Iterator4folduNCINvNtNtBR_8adapters3map8map_foldjyuNCNvCs9cj3cTKSYZx_15foundations_lab4data0NCINvNvBL_8for_each4callyNCINvMsk_NtCs6zY7rJBZy9D_5alloc3vecINtB3k_3VecyE14extend_trustedINtB1B_3MapB3_B27_EE0E0E0EB2b_: %f"}
!524 = distinct !{!524, !"_RINvYINtNtNtCsjIpoRzUjyHQ_4core3ops5range5RangejENtNtNtNtBa_4iter6traits8iterator8Iterator4folduNCINvNtNtBR_8adapters3map8map_foldjyuNCNvCs9cj3cTKSYZx_15foundations_lab4data0NCINvNvBL_8for_each4callyNCINvMsk_NtCs6zY7rJBZy9D_5alloc3vecINtB3k_3VecyE14extend_trustedINtB1B_3MapB3_B27_EE0E0E0EB2b_"}
!525 = distinct !{!525, !526, !"_RINvXs0_NtNtNtCsjIpoRzUjyHQ_4core4iter8adapters3mapINtB6_3MapINtNtNtBc_3ops5range5RangejENCNvCs9cj3cTKSYZx_15foundations_lab4data0ENtNtNtBa_6traits8iterator8Iterator4folduNCINvNvB25_8for_each4callyNCINvMsk_NtCs6zY7rJBZy9D_5alloc3vecINtB3i_3VecyE14extend_trustedBN_E0E0EB1t_: %g"}
!526 = distinct !{!526, !"_RINvXs0_NtNtNtCsjIpoRzUjyHQ_4core4iter8adapters3mapINtB6_3MapINtNtNtBc_3ops5range5RangejENCNvCs9cj3cTKSYZx_15foundations_lab4data0ENtNtNtBa_6traits8iterator8Iterator4folduNCINvNvB25_8for_each4callyNCINvMsk_NtCs6zY7rJBZy9D_5alloc3vecINtB3i_3VecyE14extend_trustedBN_E0E0EB1t_"}
!527 = distinct !{!527, !528, !"_RINvYINtNtNtNtCsjIpoRzUjyHQ_4core4iter8adapters3map3MapINtNtNtBc_3ops5range5RangejENCNvCs9cj3cTKSYZx_15foundations_lab4data0ENtNtNtBa_6traits8iterator8Iterator8for_eachNCINvMsk_NtCs6zY7rJBZy9D_5alloc3vecINtB2P_3VecyE14extend_trustedB3_E0EB1n_: %f"}
!528 = distinct !{!528, !"_RINvYINtNtNtNtCsjIpoRzUjyHQ_4core4iter8adapters3map3MapINtNtNtBc_3ops5range5RangejENCNvCs9cj3cTKSYZx_15foundations_lab4data0ENtNtNtBa_6traits8iterator8Iterator8for_eachNCINvMsk_NtCs6zY7rJBZy9D_5alloc3vecINtB2P_3VecyE14extend_trustedB3_E0EB1n_"}
!529 = distinct !{!529, !530, !"_RINvMsk_NtCs6zY7rJBZy9D_5alloc3vecINtB6_3VecyE14extend_trustedINtNtNtNtCsjIpoRzUjyHQ_4core4iter8adapters3map3MapINtNtNtB17_3ops5range5RangejENCNvCs9cj3cTKSYZx_15foundations_lab4data0EEB2j_: %self"}
!530 = distinct !{!530, !"_RINvMsk_NtCs6zY7rJBZy9D_5alloc3vecINtB6_3VecyE14extend_trustedINtNtNtNtCsjIpoRzUjyHQ_4core4iter8adapters3map3MapINtNtNtB17_3ops5range5RangejENCNvCs9cj3cTKSYZx_15foundations_lab4data0EEB2j_"}
!531 = distinct !{!531, !532, !"_RNvXs_NtNtCs6zY7rJBZy9D_5alloc3vec11spec_extendINtB6_3VecyEINtB4_10SpecExtendyINtNtNtNtCsjIpoRzUjyHQ_4core4iter8adapters3map3MapINtNtNtB1n_3ops5range5RangejENCNvCs9cj3cTKSYZx_15foundations_lab4data0EE11spec_extendB2z_: %self"}
!532 = distinct !{!532, !"_RNvXs_NtNtCs6zY7rJBZy9D_5alloc3vec11spec_extendINtB6_3VecyEINtB4_10SpecExtendyINtNtNtNtCsjIpoRzUjyHQ_4core4iter8adapters3map3MapINtNtNtB1n_3ops5range5RangejENCNvCs9cj3cTKSYZx_15foundations_lab4data0EE11spec_extendB2z_"}
!533 = distinct !{!533, !534, !535}
!534 = !{!"llvm.loop.isvectorized", i32 1}
!535 = !{!"llvm.loop.unroll.runtime.disable"}
!536 = !DILocation(line: 19, column: 9, scope: !537, inlinedAt: !541)
!537 = distinct !DISubprogram(name: "increment_len", linkageName: "_RNvMNtNtCs6zY7rJBZy9D_5alloc3vec15set_len_on_dropNtB2_12SetLenOnDrop13increment_len", scope: !539, file: !538, line: 18, type: !20, scopeLine: 18, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!538 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/alloc/src/vec/set_len_on_drop.rs", directory: "", checksumkind: CSK_MD5, checksum: "9a0d01ce4a85900df996691fa734ffd7")
!539 = !DINamespace(name: "SetLenOnDrop", scope: !540)
!540 = !DINamespace(name: "set_len_on_drop", scope: !59)
!541 = distinct !DILocation(line: 4137, column: 31, scope: !505, inlinedAt: !508)
!542 = distinct !{!542, !534}
!543 = !DILocation(line: 61, column: 9, scope: !483, inlinedAt: !422)
!544 = !DILocation(line: 48, column: 2, scope: !382)
!545 = distinct !DISubprogram(name: "cloned", linkageName: "_RNvCs9cj3cTKSYZx_15foundations_lab6cloned", scope: !19, file: !18, line: 132, type: !20, scopeLine: 132, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!546 = !{i64 2238579646503555973}
!547 = !DILocation(line: 3212, column: 26, scope: !27, inlinedAt: !548)
!548 = distinct !DILocation(line: 1330, column: 31, scope: !33, inlinedAt: !549)
!549 = distinct !DILocation(line: 533, column: 39, scope: !35, inlinedAt: !550)
!550 = distinct !DILocation(line: 901, column: 17, scope: !42, inlinedAt: !551)
!551 = distinct !DILocation(line: 455, column: 28, scope: !47, inlinedAt: !552)
!552 = distinct !DILocation(line: 435, column: 15, scope: !553, inlinedAt: !554)
!553 = distinct !DISubprogram(name: "with_capacity_in<alloc::alloc::Global>", linkageName: "_RNvMs5_NtCs6zY7rJBZy9D_5alloc7raw_vecNtB5_11RawVecInner16with_capacity_inCs9cj3cTKSYZx_15foundations_lab", scope: !48, file: !43, line: 434, type: !20, scopeLine: 434, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!554 = !DILocation(line: 177, column: 20, scope: !555, inlinedAt: !556)
!555 = distinct !DISubprogram(name: "with_capacity_in<u64, alloc::alloc::Global>", linkageName: "_RNvMs4_NtCs6zY7rJBZy9D_5alloc7raw_vecINtB5_6RawVecyE16with_capacity_inCs9cj3cTKSYZx_15foundations_lab", scope: !53, file: !43, line: 175, type: !20, scopeLine: 175, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!556 = !DILocation(line: 969, column: 20, scope: !557, inlinedAt: !558)
!557 = distinct !DISubprogram(name: "with_capacity_in<u64, alloc::alloc::Global>", linkageName: "_RNvMsG_NtCs6zY7rJBZy9D_5alloc3vecINtB5_3VecyE16with_capacity_inCs9cj3cTKSYZx_15foundations_lab", scope: !413, file: !62, line: 968, type: !20, scopeLine: 968, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!558 = !DILocation(line: 448, column: 29, scope: !559, inlinedAt: !566)
!559 = distinct !DILexicalBlock(scope: !561, file: !560, line: 447, column: 17)
!560 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/alloc/src/slice.rs", directory: "", checksumkind: CSK_MD5, checksum: "8e7bce5d617a4e88f7bdb700dff9d669")
!561 = distinct !DISubprogram(name: "to_vec<u64, alloc::alloc::Global>", linkageName: "_RINvXs_NvMNtCs6zY7rJBZy9D_5alloc5sliceSp9to_vec_inyNtB5_10ConvertVec6to_vecNtNtBa_5alloc6GlobalECs9cj3cTKSYZx_15foundations_lab", scope: !562, file: !560, line: 446, type: !20, scopeLine: 446, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!562 = !DINamespace(name: "{impl#1}", scope: !563)
!563 = !DINamespace(name: "to_vec_in", scope: !564)
!564 = !DINamespace(name: "{impl#0}", scope: !565)
!565 = !DINamespace(name: "slice", scope: !45)
!566 = !DILocation(line: 400, column: 16, scope: !567, inlinedAt: !568)
!567 = distinct !DISubprogram(name: "to_vec_in<u64, alloc::alloc::Global>", linkageName: "_RINvMNtCs6zY7rJBZy9D_5alloc5sliceSy9to_vec_inNtNtB5_5alloc6GlobalECs9cj3cTKSYZx_15foundations_lab", scope: !564, file: !560, line: 396, type: !20, scopeLine: 396, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!568 = !DILocation(line: 376, column: 14, scope: !569, inlinedAt: !570)
!569 = distinct !DISubprogram(name: "to_vec<u64>", linkageName: "_RNvMNtCs6zY7rJBZy9D_5alloc5sliceSy6to_vecCs9cj3cTKSYZx_15foundations_lab", scope: !564, file: !560, line: 372, type: !20, scopeLine: 372, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!570 = !DILocation(line: 133, column: 23, scope: !545)
!571 = !DILocation(line: 461, column: 12, scope: !72, inlinedAt: !552)
!572 = !DILocation(line: 0, scope: !72, inlinedAt: !552)
!573 = !{!574}
!574 = distinct !{!574, !575, !"_RNvMs5_NtCs6zY7rJBZy9D_5alloc7raw_vecNtB5_11RawVecInner15try_allocate_inCs9cj3cTKSYZx_15foundations_lab: %_0"}
!575 = distinct !{!575, !"_RNvMs5_NtCs6zY7rJBZy9D_5alloc7raw_vecNtB5_11RawVecInner15try_allocate_inCs9cj3cTKSYZx_15foundations_lab"}
!576 = !DILocation(line: 130, column: 9, scope: !431, inlinedAt: !577)
!577 = distinct !DILocation(line: 302, column: 73, scope: !84, inlinedAt: !578)
!578 = distinct !DILocation(line: 424, column: 9, scope: !434, inlinedAt: !579)
!579 = distinct !DILocation(line: 541, column: 14, scope: !436, inlinedAt: !580)
!580 = distinct !DILocation(line: 466, column: 47, scope: !72, inlinedAt: !552)
!581 = !DILocation(line: 470, column: 25, scope: !95, inlinedAt: !552)
!582 = !DILocation(line: 470, column: 19, scope: !95, inlinedAt: !552)
!583 = !DILocation(line: 443, column: 25, scope: !584, inlinedAt: !554)
!584 = distinct !DILexicalBlock(scope: !553, file: !43, line: 443, column: 13)
!585 = !DILocation(line: 134, column: 14, scope: !586)
!586 = distinct !DILexicalBlock(scope: !545, file: !18, line: 133, column: 5)
!587 = !DILocation(line: 491, column: 5, scope: !588, inlinedAt: !585)
!588 = distinct !DISubprogram(name: "black_box<&[u64]>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core4hint9black_boxRSyECs9cj3cTKSYZx_15foundations_lab", scope: !208, file: !207, line: 490, type: !20, scopeLine: 490, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!589 = !DILocation(line: 134, column: 5, scope: !586)
!590 = !DILocation(line: 134, column: 31, scope: !586)
!591 = !DILocation(line: 631, column: 39, scope: !287, inlinedAt: !592)
!592 = distinct !DILocation(line: 874, column: 52, scope: !289, inlinedAt: !593)
!593 = distinct !DILocation(line: 425, column: 29, scope: !292, inlinedAt: !594)
!594 = distinct !DILocation(line: 847, column: 1, scope: !295, inlinedAt: !595)
!595 = distinct !DILocation(line: 847, column: 1, scope: !298, inlinedAt: !596)
!596 = distinct !DILocation(line: 135, column: 1, scope: !545)
!597 = !DILocation(line: 573, column: 14, scope: !598, inlinedAt: !599)
!598 = distinct !DISubprogram(name: "copy_nonoverlapping<u64>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3ptr19copy_nonoverlappingyECs9cj3cTKSYZx_15foundations_lab", scope: !110, file: !296, line: 552, type: !20, scopeLine: 552, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!599 = !DILocation(line: 1235, column: 18, scope: !600, inlinedAt: !604)
!600 = distinct !DISubprogram(name: "copy_to_nonoverlapping<u64>", linkageName: "_RNvMNtNtCsjIpoRzUjyHQ_4core3ptr9const_ptrPy22copy_to_nonoverlappingCs9cj3cTKSYZx_15foundations_lab", scope: !602, file: !601, line: 1230, type: !20, scopeLine: 1230, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!601 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/ptr/const_ptr.rs", directory: "", checksumkind: CSK_MD5, checksum: "25118ae25e729b7c815218b31622724c")
!602 = !DINamespace(name: "{impl#0}", scope: !603)
!603 = !DINamespace(name: "const_ptr", scope: !110)
!604 = !DILocation(line: 454, column: 36, scope: !605, inlinedAt: !566)
!605 = distinct !DILexicalBlock(scope: !559, file: !560, line: 448, column: 17)
!606 = !DILocation(line: 452, column: 17, scope: !605, inlinedAt: !566)
!607 = !DILocation(line: 1401, column: 17, scope: !301, inlinedAt: !608)
!608 = distinct !DILocation(line: 639, column: 53, scope: !287, inlinedAt: !592)
!609 = !DILocation(line: 175, column: 14, scope: !304, inlinedAt: !610)
!610 = distinct !DILocation(line: 321, column: 22, scope: !306, inlinedAt: !611)
!611 = distinct !DILocation(line: 436, column: 9, scope: !308, inlinedAt: !612)
!612 = distinct !DILocation(line: 554, column: 23, scope: !310, inlinedAt: !613)
!613 = distinct !DILocation(line: 876, column: 28, scope: !289, inlinedAt: !593)
!614 = !DILocation(line: 312, column: 9, scope: !306, inlinedAt: !611)
!615 = !DILocation(line: 135, column: 2, scope: !545)
!616 = distinct !DISubprogram(name: "sum_aos", linkageName: "_RNvCs9cj3cTKSYZx_15foundations_lab7sum_aos", scope: !19, file: !18, line: 80, type: !20, scopeLine: 80, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!617 = !{i64 -4694119547460355142}
!618 = !DILocation(line: 1663, column: 9, scope: !619, inlinedAt: !620)
!619 = distinct !DISubprogram(name: "eq<foundations_lab::Record>", linkageName: "_RNvXsd_NtNtCsjIpoRzUjyHQ_4core3ptr8non_nullINtB5_7NonNullNtCs9cj3cTKSYZx_15foundations_lab6RecordENtNtB9_3cmp9PartialEq2eqBV_", scope: !214, file: !136, line: 1662, type: !20, scopeLine: 1662, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!620 = distinct !DILocation(line: 44, column: 20, scope: !621, inlinedAt: !624)
!621 = distinct !DILexicalBlock(scope: !622, file: !127, line: 33, column: 13)
!622 = distinct !DILexicalBlock(scope: !623, file: !127, line: 25, column: 86)
!623 = distinct !DISubprogram(name: "fold<foundations_lab::Record, u64, foundations_lab::sum_aos::{closure_env#0}>", linkageName: "_RINvXs2J_NtNtCsjIpoRzUjyHQ_4core5slice4iterINtB7_4IterNtCs9cj3cTKSYZx_15foundations_lab6RecordENtNtNtNtBb_4iter6traits8iterator8Iterator4foldyNCNvBS_7sum_aos0EBS_", scope: !231, file: !127, line: 254, type: !20, scopeLine: 254, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!624 = distinct !DILocation(line: 83, column: 10, scope: !616)
!625 = !DILocation(line: 25, column: 86, scope: !622, inlinedAt: !624)
!626 = !DILocation(line: 279, column: 24, scope: !627, inlinedAt: !624)
!627 = distinct !DILexicalBlock(scope: !628, file: !127, line: 270, column: 17)
!628 = distinct !DILexicalBlock(scope: !629, file: !127, line: 269, column: 17)
!629 = distinct !DILexicalBlock(scope: !623, file: !127, line: 268, column: 17)
!630 = !DILocation(line: 0, scope: !629, inlinedAt: !624)
!631 = !DILocation(line: 627, column: 28, scope: !632, inlinedAt: !633)
!632 = distinct !DISubprogram(name: "add<foundations_lab::Record>", linkageName: "_RNvMs1_NtNtCsjIpoRzUjyHQ_4core3ptr8non_nullINtB5_7NonNullNtCs9cj3cTKSYZx_15foundations_lab6RecordE3addBV_", scope: !137, file: !136, line: 619, type: !20, scopeLine: 619, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!633 = distinct !DILocation(line: 274, column: 67, scope: !627, inlinedAt: !624)
!634 = !DILocation(line: 274, column: 27, scope: !627, inlinedAt: !624)
!635 = !DILocation(line: 2652, column: 13, scope: !636, inlinedAt: !637)
!636 = distinct !DISubprogram(name: "wrapping_add", linkageName: "_RNvMs7_NtCsjIpoRzUjyHQ_4core3numy12wrapping_add", scope: !493, file: !28, line: 2651, type: !20, scopeLine: 2651, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!637 = distinct !DILocation(line: 83, column: 36, scope: !638, inlinedAt: !640)
!638 = distinct !DISubprogram(name: "{closure#0}", linkageName: "_RNCNvCs9cj3cTKSYZx_15foundations_lab7sum_aos0B3_", scope: !639, file: !18, line: 83, type: !92, scopeLine: 83, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!639 = !DINamespace(name: "sum_aos", scope: !19)
!640 = distinct !DILocation(line: 274, column: 27, scope: !627, inlinedAt: !624)
!641 = distinct !{!641, !534, !535}
!642 = !DILocation(line: 0, scope: !623, inlinedAt: !624)
!643 = !DILocation(line: 1013, column: 17, scope: !644, inlinedAt: !645)
!644 = distinct !DISubprogram(name: "unchecked_add", linkageName: "_RNvMs9_NtCsjIpoRzUjyHQ_4core3numj13unchecked_add", scope: !29, file: !28, line: 1001, type: !20, scopeLine: 1001, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!645 = distinct !DILocation(line: 278, column: 36, scope: !627, inlinedAt: !624)
!646 = distinct !{!646, !534}
!647 = !DILocation(line: 84, column: 2, scope: !616)
!648 = distinct !DISubprogram(name: "sum_soa", linkageName: "_RNvCs9cj3cTKSYZx_15foundations_lab7sum_soa", scope: !19, file: !18, line: 87, type: !20, scopeLine: 87, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!649 = !{i64 -8103703410076557555}
!650 = !DILocation(line: 1663, column: 9, scope: !651, inlinedAt: !652)
!651 = distinct !DISubprogram(name: "eq<u64>", linkageName: "_RNvXsd_NtNtCsjIpoRzUjyHQ_4core3ptr8non_nullINtB5_7NonNullyENtNtB9_3cmp9PartialEq2eqCs9cj3cTKSYZx_15foundations_lab", scope: !214, file: !136, line: 1662, type: !20, scopeLine: 1662, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!652 = distinct !DILocation(line: 44, column: 20, scope: !653, inlinedAt: !656)
!653 = distinct !DILexicalBlock(scope: !654, file: !127, line: 33, column: 13)
!654 = distinct !DILexicalBlock(scope: !655, file: !127, line: 25, column: 86)
!655 = distinct !DISubprogram(name: "fold<u64, u64, core::iter::adapters::copied::copy_fold::{closure_env#0}<u64, u64, fn(u64, u64) -> u64>>", linkageName: "_RINvXs2J_NtNtCsjIpoRzUjyHQ_4core5slice4iterINtB7_4IteryENtNtNtNtBb_4iter6traits8iterator8Iterator4foldyNCINvNtNtBY_8adapters6copied9copy_foldyyNvMs7_NtBb_3numy12wrapping_addE0ECs9cj3cTKSYZx_15foundations_lab", scope: !231, file: !127, line: 254, type: !20, scopeLine: 254, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!656 = distinct !DILocation(line: 81, column: 17, scope: !657, inlinedAt: !661)
!657 = distinct !DISubprogram(name: "fold<core::slice::iter::Iter<u64>, u64, u64, fn(u64, u64) -> u64>", linkageName: "_RINvXs_NtNtNtCsjIpoRzUjyHQ_4core4iter8adapters6copiedINtB5_6CopiedINtNtNtBb_5slice4iter4IteryEENtNtNtB9_6traits8iterator8Iterator4foldyNvMs7_NtBb_3numy12wrapping_addECs9cj3cTKSYZx_15foundations_lab", scope: !659, file: !658, line: 77, type: !20, scopeLine: 77, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!658 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/iter/adapters/copied.rs", directory: "", checksumkind: CSK_MD5, checksum: "a8d888f8d60ac75eb2c9d5156487ea4d")
!659 = !DINamespace(name: "{impl#1}", scope: !660)
!660 = !DINamespace(name: "copied", scope: !468)
!661 = !DILocation(line: 88, column: 27, scope: !648)
!662 = !DILocation(line: 25, column: 86, scope: !654, inlinedAt: !656)
!663 = !DILocation(line: 279, column: 24, scope: !664, inlinedAt: !656)
!664 = distinct !DILexicalBlock(scope: !665, file: !127, line: 270, column: 17)
!665 = distinct !DILexicalBlock(scope: !666, file: !127, line: 269, column: 17)
!666 = distinct !DILexicalBlock(scope: !655, file: !127, line: 268, column: 17)
!667 = !DILocation(line: 0, scope: !666, inlinedAt: !656)
!668 = !DILocation(line: 627, column: 28, scope: !669, inlinedAt: !670)
!669 = distinct !DISubprogram(name: "add<u64>", linkageName: "_RNvMs1_NtNtCsjIpoRzUjyHQ_4core3ptr8non_nullINtB5_7NonNullyE3addCs9cj3cTKSYZx_15foundations_lab", scope: !137, file: !136, line: 619, type: !20, scopeLine: 619, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!670 = distinct !DILocation(line: 274, column: 67, scope: !664, inlinedAt: !656)
!671 = !DILocation(line: 274, column: 27, scope: !664, inlinedAt: !656)
!672 = !DILocation(line: 2652, column: 13, scope: !673, inlinedAt: !674)
!673 = distinct !DISubprogram(name: "wrapping_add", linkageName: "_RNvMs7_NtCsjIpoRzUjyHQ_4core3numy12wrapping_add", scope: !493, file: !28, line: 2651, type: !20, scopeLine: 2651, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!674 = distinct !DILocation(line: 166, column: 5, scope: !675, inlinedAt: !677)
!675 = distinct !DISubprogram(name: "call_mut<fn(u64, u64) -> u64, (u64, u64)>", linkageName: "_RNvYNvMs7_NtCsjIpoRzUjyHQ_4core3numy12wrapping_addINtNtNtBa_3ops8function5FnMutTyyEE8call_mutCs9cj3cTKSYZx_15foundations_lab", scope: !676, file: !336, line: 166, type: !92, scopeLine: 166, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!676 = !DINamespace(name: "FnMut", scope: !338)
!677 = distinct !DILocation(line: 36, column: 22, scope: !678, inlinedAt: !681)
!678 = distinct !DILexicalBlock(scope: !679, file: !658, line: 36, column: 22)
!679 = distinct !DISubprogram(name: "{closure#0}<u64, u64, fn(u64, u64) -> u64>", linkageName: "_RNCINvNtNtNtCsjIpoRzUjyHQ_4core4iter8adapters6copied9copy_foldyyNvMs7_NtBa_3numy12wrapping_addE0Cs9cj3cTKSYZx_15foundations_lab", scope: !680, file: !658, line: 36, type: !92, scopeLine: 36, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!680 = !DINamespace(name: "copy_fold", scope: !660)
!681 = distinct !DILocation(line: 274, column: 27, scope: !664, inlinedAt: !656)
!682 = distinct !{!682, !534, !535}
!683 = !DILocation(line: 0, scope: !655, inlinedAt: !656)
!684 = !DILocation(line: 1013, column: 17, scope: !685, inlinedAt: !686)
!685 = distinct !DISubprogram(name: "unchecked_add", linkageName: "_RNvMs9_NtCsjIpoRzUjyHQ_4core3numj13unchecked_add", scope: !29, file: !28, line: 1001, type: !20, scopeLine: 1001, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!686 = distinct !DILocation(line: 278, column: 36, scope: !664, inlinedAt: !656)
!687 = distinct !{!687, !535, !534}
!688 = !DILocation(line: 89, column: 2, scope: !648)
!689 = distinct !DISubprogram(name: "borrowed", linkageName: "_RNvCs9cj3cTKSYZx_15foundations_lab8borrowed", scope: !19, file: !18, line: 127, type: !20, scopeLine: 127, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!690 = !{i64 8926404407473929810}
!691 = !DILocation(line: 128, column: 14, scope: !689)
!692 = !DILocation(line: 491, column: 5, scope: !693, inlinedAt: !691)
!693 = distinct !DISubprogram(name: "black_box<&[u64]>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core4hint9black_boxRSyECs9cj3cTKSYZx_15foundations_lab", scope: !208, file: !207, line: 490, type: !20, scopeLine: 490, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!694 = !DILocation(line: 128, column: 5, scope: !689)
!695 = !DILocation(line: 128, column: 30, scope: !689)
!696 = !DILocation(line: 129, column: 2, scope: !689)
!697 = distinct !DISubprogram(name: "copy_add", linkageName: "_RNvCs9cj3cTKSYZx_15foundations_lab8copy_add", scope: !19, file: !18, line: 166, type: !20, scopeLine: 166, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!698 = !{i64 6850724147955099699}
!699 = !DILocation(line: 167, column: 16, scope: !697)
!700 = !DILocation(line: 167, column: 27, scope: !697)
!701 = !DILocation(line: 167, column: 5, scope: !702)
!702 = !DILexicalBlockFile(scope: !703, file: !18, discriminator: 0)
!703 = distinct !DILexicalBlock(scope: !697, file: !358, line: 46, column: 13)
!704 = !DILocation(line: 167, column: 5, scope: !705)
!705 = !DILexicalBlockFile(scope: !706, file: !18, discriminator: 0)
!706 = distinct !DILexicalBlock(scope: !703, file: !358, line: 48, column: 21)
!707 = !DILocation(line: 167, column: 5, scope: !697)
!708 = !DILocation(line: 300, column: 12, scope: !709, inlinedAt: !713)
!709 = distinct !DISubprogram(name: "next<core::slice::iter::IterMut<u64>, core::slice::iter::Iter<u64>>", linkageName: "_RNvXs3_NtNtNtCsjIpoRzUjyHQ_4core4iter8adapters3zipINtB5_3ZipINtNtNtBb_5slice4iter7IterMutyEINtBZ_4IteryEEINtB5_7ZipImplBW_B1r_E4nextCs9cj3cTKSYZx_15foundations_lab", scope: !711, file: !710, line: 299, type: !20, scopeLine: 299, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!710 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/iter/adapters/zip.rs", directory: "", checksumkind: CSK_MD5, checksum: "bac37f4e22813d9f23237243aa1b48fd")
!711 = !DINamespace(name: "{impl#5}", scope: !712)
!712 = !DINamespace(name: "zip", scope: !468)
!713 = distinct !DILocation(line: 83, column: 9, scope: !714, inlinedAt: !716)
!714 = distinct !DISubprogram(name: "next<core::slice::iter::IterMut<u64>, core::slice::iter::Iter<u64>>", linkageName: "_RNvXs_NtNtNtCsjIpoRzUjyHQ_4core4iter8adapters3zipINtB4_3ZipINtNtNtBa_5slice4iter7IterMutyEINtBY_4IteryEENtNtNtB8_6traits8iterator8Iterator4nextCs9cj3cTKSYZx_15foundations_lab", scope: !715, file: !710, line: 82, type: !20, scopeLine: 82, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!715 = !DINamespace(name: "{impl#1}", scope: !712)
!716 = !DILocation(line: 168, column: 23, scope: !717)
!717 = !DILexicalBlockFile(scope: !718, file: !18, discriminator: 2)
!718 = distinct !DILexicalBlock(scope: !697, file: !18, line: 168, column: 5)
!719 = !DILocation(line: 304, column: 13, scope: !720, inlinedAt: !713)
!720 = distinct !DILexicalBlock(scope: !709, file: !710, line: 301, column: 13)
!721 = !DILocation(line: 970, column: 18, scope: !722, inlinedAt: !723)
!722 = distinct !DISubprogram(name: "add<u64>", linkageName: "_RNvMNtNtCsjIpoRzUjyHQ_4core3ptr7mut_ptrOy3addCs9cj3cTKSYZx_15foundations_lab", scope: !108, file: !107, line: 936, type: !20, scopeLine: 936, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!723 = distinct !DILocation(line: 424, column: 60, scope: !724, inlinedAt: !725)
!724 = distinct !DISubprogram(name: "__iterator_get_unchecked<u64>", linkageName: "_RNvXs2Q_NtNtCsjIpoRzUjyHQ_4core5slice4iterINtB6_7IterMutyENtNtNtNtBa_4iter6traits8iterator8Iterator24___iterator_get_uncheckedCs9cj3cTKSYZx_15foundations_lab", scope: !130, file: !127, line: 413, type: !92, scopeLine: 413, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!725 = distinct !DILocation(line: 307, column: 30, scope: !720, inlinedAt: !713)
!726 = !DILocation(line: 970, column: 18, scope: !727, inlinedAt: !728)
!727 = distinct !DISubprogram(name: "add<u64>", linkageName: "_RNvMNtNtCsjIpoRzUjyHQ_4core3ptr7mut_ptrOy3addCs9cj3cTKSYZx_15foundations_lab", scope: !108, file: !107, line: 936, type: !20, scopeLine: 936, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!728 = distinct !DILocation(line: 424, column: 60, scope: !729, inlinedAt: !730)
!729 = distinct !DISubprogram(name: "__iterator_get_unchecked<u64>", linkageName: "_RNvXs2J_NtNtCsjIpoRzUjyHQ_4core5slice4iterINtB6_4IteryENtNtNtNtBa_4iter6traits8iterator8Iterator24___iterator_get_uncheckedCs9cj3cTKSYZx_15foundations_lab", scope: !231, file: !127, line: 413, type: !92, scopeLine: 413, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!730 = distinct !DILocation(line: 307, column: 66, scope: !720, inlinedAt: !713)
!731 = !DILocation(line: 169, column: 16, scope: !732)
!732 = distinct !DILexicalBlock(scope: !718, file: !18, line: 168, column: 5)
!733 = !DILocation(line: 2652, column: 13, scope: !734, inlinedAt: !735)
!734 = distinct !DISubprogram(name: "wrapping_add", linkageName: "_RNvMs7_NtCsjIpoRzUjyHQ_4core3numy12wrapping_add", scope: !493, file: !28, line: 2651, type: !20, scopeLine: 2651, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!735 = !DILocation(line: 169, column: 20, scope: !732)
!736 = !DILocation(line: 169, column: 9, scope: !732)
!737 = distinct !{!737, !534, !535}
!738 = distinct !{!738, !535, !534}
!739 = !DILocation(line: 171, column: 2, scope: !697)
!740 = distinct !DISubprogram(name: "dce_empty", linkageName: "_RNvCs9cj3cTKSYZx_15foundations_lab9dce_empty", scope: !19, file: !18, line: 67, type: !20, scopeLine: 67, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!741 = !{i64 7615470655370342749}
!742 = !DILocation(line: 70, column: 2, scope: !740)
!743 = distinct !DISubprogram(name: "init_push", linkageName: "_RNvCs9cj3cTKSYZx_15foundations_lab9init_push", scope: !19, file: !18, line: 138, type: !20, scopeLine: 138, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!744 = !{i64 -1834400919375600439}
!745 = !DILocation(line: 139, column: 9, scope: !743)
!746 = !DILocation(line: 3212, column: 26, scope: !27, inlinedAt: !747)
!747 = distinct !DILocation(line: 1330, column: 31, scope: !33, inlinedAt: !748)
!748 = distinct !DILocation(line: 533, column: 39, scope: !35, inlinedAt: !749)
!749 = distinct !DILocation(line: 901, column: 17, scope: !42, inlinedAt: !750)
!750 = distinct !DILocation(line: 455, column: 28, scope: !47, inlinedAt: !751)
!751 = distinct !DILocation(line: 435, column: 15, scope: !752, inlinedAt: !753)
!752 = distinct !DISubprogram(name: "with_capacity_in<alloc::alloc::Global>", linkageName: "_RNvMs5_NtCs6zY7rJBZy9D_5alloc7raw_vecNtB5_11RawVecInner16with_capacity_inCs9cj3cTKSYZx_15foundations_lab", scope: !48, file: !43, line: 434, type: !20, scopeLine: 434, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!753 = !DILocation(line: 177, column: 20, scope: !754, inlinedAt: !755)
!754 = distinct !DISubprogram(name: "with_capacity_in<u64, alloc::alloc::Global>", linkageName: "_RNvMs4_NtCs6zY7rJBZy9D_5alloc7raw_vecINtB5_6RawVecyE16with_capacity_inCs9cj3cTKSYZx_15foundations_lab", scope: !53, file: !43, line: 175, type: !20, scopeLine: 175, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!755 = !DILocation(line: 969, column: 20, scope: !756, inlinedAt: !757)
!756 = distinct !DISubprogram(name: "with_capacity_in<u64, alloc::alloc::Global>", linkageName: "_RNvMsG_NtCs6zY7rJBZy9D_5alloc3vecINtB5_3VecyE16with_capacity_inCs9cj3cTKSYZx_15foundations_lab", scope: !413, file: !62, line: 968, type: !20, scopeLine: 968, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!757 = !DILocation(line: 522, column: 9, scope: !758, inlinedAt: !759)
!758 = distinct !DISubprogram(name: "with_capacity<u64>", linkageName: "_RNvMNtCs6zY7rJBZy9D_5alloc3vecINtB2_3VecyE13with_capacityCs9cj3cTKSYZx_15foundations_lab", scope: !413, file: !62, line: 521, type: !20, scopeLine: 521, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!759 = !DILocation(line: 139, column: 19, scope: !743)
!760 = !DILocation(line: 478, column: 8, scope: !65, inlinedAt: !761)
!761 = distinct !DILocation(line: 1331, column: 16, scope: !69, inlinedAt: !748)
!762 = !DILocation(line: 461, column: 12, scope: !72, inlinedAt: !751)
!763 = !DILocation(line: 0, scope: !72, inlinedAt: !751)
!764 = !{!765}
!765 = distinct !{!765, !766, !"_RNvMs5_NtCs6zY7rJBZy9D_5alloc7raw_vecNtB5_11RawVecInner15try_allocate_inCs9cj3cTKSYZx_15foundations_lab: %_0"}
!766 = distinct !{!766, !"_RNvMs5_NtCs6zY7rJBZy9D_5alloc7raw_vecNtB5_11RawVecInner15try_allocate_inCs9cj3cTKSYZx_15foundations_lab"}
!767 = !DILocation(line: 130, column: 9, scope: !431, inlinedAt: !768)
!768 = distinct !DILocation(line: 302, column: 73, scope: !84, inlinedAt: !769)
!769 = distinct !DILocation(line: 424, column: 9, scope: !434, inlinedAt: !770)
!770 = distinct !DILocation(line: 541, column: 14, scope: !436, inlinedAt: !771)
!771 = distinct !DILocation(line: 466, column: 47, scope: !72, inlinedAt: !751)
!772 = !DILocation(line: 470, column: 25, scope: !95, inlinedAt: !751)
!773 = !DILocation(line: 470, column: 19, scope: !95, inlinedAt: !751)
!774 = !DILocation(line: 478, column: 9, scope: !98, inlinedAt: !751)
!775 = !DILocation(line: 483, column: 5, scope: !47, inlinedAt: !751)
!776 = !DILocation(line: 443, column: 25, scope: !777, inlinedAt: !753)
!777 = distinct !DILexicalBlock(scope: !752, file: !43, line: 443, column: 13)
!778 = !DILocation(line: 0, scope: !47, inlinedAt: !751)
!779 = !DILocation(line: 436, column: 16, scope: !752, inlinedAt: !753)
!780 = !DILocation(line: 764, column: 9, scope: !781, inlinedAt: !782)
!781 = distinct !DISubprogram(name: "needs_to_grow<alloc::alloc::Global>", linkageName: "_RNvMs2_NtCs6zY7rJBZy9D_5alloc7raw_vecNtB5_11RawVecInner13needs_to_growCs9cj3cTKSYZx_15foundations_lab", scope: !48, file: !43, line: 763, type: !20, scopeLine: 763, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!782 = !DILocation(line: 439, column: 50, scope: !783, inlinedAt: !753)
!783 = distinct !DILexicalBlock(scope: !752, file: !43, line: 436, column: 13)
!784 = !DILocation(line: 210, column: 9, scope: !785, inlinedAt: !786)
!785 = distinct !DISubprogram(name: "assert_unchecked", linkageName: "_RNvNtCsjIpoRzUjyHQ_4core4hint16assert_unchecked", scope: !208, file: !207, line: 202, type: !20, scopeLine: 202, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!786 = !DILocation(line: 439, column: 21, scope: !783, inlinedAt: !753)
!787 = !DILocation(line: 969, column: 9, scope: !756, inlinedAt: !757)
!788 = !DILocation(line: 2144, column: 50, scope: !789, inlinedAt: !790)
!789 = distinct !DISubprogram(name: "lt", linkageName: "_RNvXsU_NtNtCsjIpoRzUjyHQ_4core3cmp5implsjNtB7_10PartialOrd2lt", scope: !278, file: !277, line: 2144, type: !20, scopeLine: 2144, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!790 = !DILocation(line: 1100, column: 12, scope: !791, inlinedAt: !792)
!791 = distinct !DISubprogram(name: "spec_next<usize>", linkageName: "_RNvXs3_NtNtCsjIpoRzUjyHQ_4core4iter5rangeINtNtNtB9_3ops5range5RangejENtB5_17RangeIteratorImpl9spec_nextCs9cj3cTKSYZx_15foundations_lab", scope: !147, file: !146, line: 1099, type: !20, scopeLine: 1099, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!792 = !DILocation(line: 1185, column: 14, scope: !793, inlinedAt: !794)
!793 = distinct !DISubprogram(name: "next<usize>", linkageName: "_RNvXs4_NtNtCsjIpoRzUjyHQ_4core4iter5rangeINtNtNtB9_3ops5range5RangejENtNtNtB7_6traits8iterator8Iterator4nextCs9cj3cTKSYZx_15foundations_lab", scope: !153, file: !146, line: 1184, type: !20, scopeLine: 1184, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!794 = !DILocation(line: 140, column: 14, scope: !795)
!795 = !DILexicalBlockFile(scope: !796, file: !18, discriminator: 2)
!796 = distinct !DILexicalBlock(scope: !797, file: !18, line: 140, column: 5)
!797 = distinct !DILexicalBlock(scope: !743, file: !18, line: 139, column: 5)
!798 = !DILocation(line: 611, column: 9, scope: !799, inlinedAt: !800)
!799 = distinct !DISubprogram(name: "non_null<alloc::alloc::Global, u64>", linkageName: "_RINvMs2_NtCs6zY7rJBZy9D_5alloc7raw_vecNtB6_11RawVecInner8non_nullyECs9cj3cTKSYZx_15foundations_lab", scope: !48, file: !43, line: 610, type: !20, scopeLine: 610, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!800 = !DILocation(line: 606, column: 14, scope: !801, inlinedAt: !802)
!801 = distinct !DISubprogram(name: "ptr<alloc::alloc::Global, u64>", linkageName: "_RINvMs2_NtCs6zY7rJBZy9D_5alloc7raw_vecNtB6_11RawVecInner3ptryECs9cj3cTKSYZx_15foundations_lab", scope: !48, file: !43, line: 605, type: !20, scopeLine: 605, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!802 = !DILocation(line: 296, column: 20, scope: !803, inlinedAt: !804)
!803 = distinct !DISubprogram(name: "ptr<u64, alloc::alloc::Global>", linkageName: "_RNvMs0_NtCs6zY7rJBZy9D_5alloc7raw_vecINtB5_6RawVecyE3ptrCs9cj3cTKSYZx_15foundations_lab", scope: !53, file: !43, line: 295, type: !20, scopeLine: 295, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!804 = !DILocation(line: 1969, column: 18, scope: !805, inlinedAt: !806)
!805 = distinct !DISubprogram(name: "as_ptr<u64, alloc::alloc::Global>", linkageName: "_RNvMs_NtCs6zY7rJBZy9D_5alloc3vecINtB4_3VecyE6as_ptrCs9cj3cTKSYZx_15foundations_lab", scope: !413, file: !62, line: 1966, type: !20, scopeLine: 1966, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!806 = !DILocation(line: 1865, column: 76, scope: !807, inlinedAt: !808)
!807 = distinct !DISubprogram(name: "as_slice<u64, alloc::alloc::Global>", linkageName: "_RNvMs_NtCs6zY7rJBZy9D_5alloc3vecINtB4_3VecyE8as_sliceCs9cj3cTKSYZx_15foundations_lab", scope: !413, file: !62, line: 1848, type: !20, scopeLine: 1848, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!808 = !DILocation(line: 3852, column: 14, scope: !809, inlinedAt: !811)
!809 = distinct !DISubprogram(name: "deref<u64, alloc::alloc::Global>", linkageName: "_RNvXs8_NtCs6zY7rJBZy9D_5alloc3vecINtB5_3VecyENtNtNtCsjIpoRzUjyHQ_4core3ops5deref5Deref5derefCs9cj3cTKSYZx_15foundations_lab", scope: !810, file: !62, line: 3851, type: !20, scopeLine: 3851, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!810 = !DINamespace(name: "{impl#10}", scope: !59)
!811 = !DILocation(line: 143, column: 24, scope: !797)
!812 = !DILocation(line: 144, column: 1, scope: !743)
!813 = !DILocation(line: 143, column: 14, scope: !797)
!814 = !DILocation(line: 1865, column: 86, scope: !807, inlinedAt: !808)
!815 = !DILocation(line: 491, column: 5, scope: !816, inlinedAt: !813)
!816 = distinct !DISubprogram(name: "black_box<&[u64]>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core4hint9black_boxRSyECs9cj3cTKSYZx_15foundations_lab", scope: !208, file: !207, line: 490, type: !20, scopeLine: 490, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!817 = !DILocation(line: 143, column: 5, scope: !797)
!818 = !DILocation(line: 143, column: 29, scope: !797)
!819 = !DILocation(line: 631, column: 39, scope: !287, inlinedAt: !820)
!820 = distinct !DILocation(line: 874, column: 52, scope: !289, inlinedAt: !821)
!821 = distinct !DILocation(line: 425, column: 29, scope: !292, inlinedAt: !822)
!822 = distinct !DILocation(line: 847, column: 1, scope: !295, inlinedAt: !823)
!823 = distinct !DILocation(line: 847, column: 1, scope: !298, inlinedAt: !824)
!824 = distinct !DILocation(line: 144, column: 1, scope: !743)
!825 = !DILocation(line: 1029, column: 19, scope: !826, inlinedAt: !827)
!826 = distinct !DISubprogram(name: "push_mut<u64, alloc::alloc::Global>", linkageName: "_RNvMsG_NtCs6zY7rJBZy9D_5alloc3vecINtB5_3VecyE8push_mutCs9cj3cTKSYZx_15foundations_lab", scope: !413, file: !62, line: 1027, type: !20, scopeLine: 1027, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!827 = distinct !DILocation(line: 996, column: 22, scope: !828, inlinedAt: !829)
!828 = distinct !DISubprogram(name: "push<u64, alloc::alloc::Global>", linkageName: "_RNvMsG_NtCs6zY7rJBZy9D_5alloc3vecINtB5_3VecyE4pushCs9cj3cTKSYZx_15foundations_lab", scope: !413, file: !62, line: 995, type: !20, scopeLine: 995, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!829 = !DILocation(line: 141, column: 13, scope: !830)
!830 = distinct !DILexicalBlock(scope: !796, file: !18, line: 140, column: 5)
!831 = !DILocation(line: 2728, column: 13, scope: !832, inlinedAt: !833)
!832 = distinct !DISubprogram(name: "wrapping_mul", linkageName: "_RNvMs7_NtCsjIpoRzUjyHQ_4core3numy12wrapping_mul", scope: !493, file: !28, line: 2727, type: !20, scopeLine: 2727, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!833 = !DILocation(line: 141, column: 29, scope: !830)
!834 = !{!835}
!835 = distinct !{!835, !836, !"_RNvMsG_NtCs6zY7rJBZy9D_5alloc3vecINtB5_3VecyE8push_mutCs9cj3cTKSYZx_15foundations_lab: %self"}
!836 = distinct !{!836, !"_RNvMsG_NtCs6zY7rJBZy9D_5alloc3vecINtB5_3VecyE8push_mutCs9cj3cTKSYZx_15foundations_lab"}
!837 = !DILocation(line: 996, column: 22, scope: !828, inlinedAt: !829)
!838 = !DILocation(line: 616, column: 49, scope: !839, inlinedAt: !840)
!839 = distinct !DISubprogram(name: "capacity<alloc::alloc::Global>", linkageName: "_RNvMs2_NtCs6zY7rJBZy9D_5alloc7raw_vecNtB5_11RawVecInner8capacityCs9cj3cTKSYZx_15foundations_lab", scope: !48, file: !43, line: 615, type: !20, scopeLine: 615, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!840 = distinct !DILocation(line: 309, column: 20, scope: !841, inlinedAt: !842)
!841 = distinct !DISubprogram(name: "capacity<u64, alloc::alloc::Global>", linkageName: "_RNvMs0_NtCs6zY7rJBZy9D_5alloc7raw_vecINtB5_6RawVecyE8capacityCs9cj3cTKSYZx_15foundations_lab", scope: !53, file: !43, line: 308, type: !20, scopeLine: 308, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!842 = distinct !DILocation(line: 1032, column: 28, scope: !843, inlinedAt: !827)
!843 = distinct !DILexicalBlock(scope: !826, file: !62, line: 1029, column: 9)
!844 = !{i64 0, i64 -9223372036854775808}
!845 = !DILocation(line: 1032, column: 12, scope: !843, inlinedAt: !827)
!846 = !DILocation(line: 1033, column: 22, scope: !843, inlinedAt: !827)
!847 = !DILocation(line: 611, column: 9, scope: !848, inlinedAt: !849)
!848 = distinct !DISubprogram(name: "non_null<alloc::alloc::Global, u64>", linkageName: "_RINvMs2_NtCs6zY7rJBZy9D_5alloc7raw_vecNtB6_11RawVecInner8non_nullyECs9cj3cTKSYZx_15foundations_lab", scope: !48, file: !43, line: 610, type: !20, scopeLine: 610, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!849 = distinct !DILocation(line: 606, column: 14, scope: !850, inlinedAt: !851)
!850 = distinct !DISubprogram(name: "ptr<alloc::alloc::Global, u64>", linkageName: "_RINvMs2_NtCs6zY7rJBZy9D_5alloc7raw_vecNtB6_11RawVecInner3ptryECs9cj3cTKSYZx_15foundations_lab", scope: !48, file: !43, line: 605, type: !20, scopeLine: 605, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!851 = distinct !DILocation(line: 296, column: 20, scope: !852, inlinedAt: !853)
!852 = distinct !DISubprogram(name: "ptr<u64, alloc::alloc::Global>", linkageName: "_RNvMs0_NtCs6zY7rJBZy9D_5alloc7raw_vecINtB5_6RawVecyE3ptrCs9cj3cTKSYZx_15foundations_lab", scope: !53, file: !43, line: 295, type: !20, scopeLine: 295, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!853 = distinct !DILocation(line: 2053, column: 18, scope: !854, inlinedAt: !855)
!854 = distinct !DISubprogram(name: "as_mut_ptr<u64, alloc::alloc::Global>", linkageName: "_RNvMs_NtCs6zY7rJBZy9D_5alloc3vecINtB4_3VecyE10as_mut_ptrCs9cj3cTKSYZx_15foundations_lab", scope: !413, file: !62, line: 2050, type: !20, scopeLine: 2050, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!855 = distinct !DILocation(line: 1036, column: 28, scope: !843, inlinedAt: !827)
!856 = !DILocation(line: 631, column: 39, scope: !287, inlinedAt: !857)
!857 = distinct !DILocation(line: 874, column: 52, scope: !289, inlinedAt: !858)
!858 = distinct !DILocation(line: 425, column: 29, scope: !292, inlinedAt: !859)
!859 = distinct !DILocation(line: 847, column: 1, scope: !295, inlinedAt: !860)
!860 = distinct !DILocation(line: 847, column: 1, scope: !298, inlinedAt: !861)
!861 = distinct !DILocation(line: 144, column: 1, scope: !743)
!862 = !DILocation(line: 1401, column: 17, scope: !301, inlinedAt: !863)
!863 = distinct !DILocation(line: 639, column: 53, scope: !287, inlinedAt: !857)
!864 = !DILocation(line: 175, column: 14, scope: !304, inlinedAt: !865)
!865 = distinct !DILocation(line: 321, column: 22, scope: !306, inlinedAt: !866)
!866 = distinct !DILocation(line: 436, column: 9, scope: !308, inlinedAt: !867)
!867 = distinct !DILocation(line: 554, column: 23, scope: !310, inlinedAt: !868)
!868 = distinct !DILocation(line: 876, column: 28, scope: !289, inlinedAt: !858)
!869 = !DILocation(line: 312, column: 9, scope: !306, inlinedAt: !866)
!870 = !DILocation(line: 1401, column: 17, scope: !301, inlinedAt: !871)
!871 = distinct !DILocation(line: 639, column: 53, scope: !287, inlinedAt: !820)
!872 = !DILocation(line: 175, column: 14, scope: !304, inlinedAt: !873)
!873 = distinct !DILocation(line: 321, column: 22, scope: !306, inlinedAt: !874)
!874 = distinct !DILocation(line: 436, column: 9, scope: !308, inlinedAt: !875)
!875 = distinct !DILocation(line: 554, column: 23, scope: !310, inlinedAt: !876)
!876 = distinct !DILocation(line: 876, column: 28, scope: !289, inlinedAt: !821)
!877 = !DILocation(line: 312, column: 9, scope: !306, inlinedAt: !874)
!878 = !DILocation(line: 144, column: 2, scope: !743)
!879 = !DILocation(line: 970, column: 18, scope: !880, inlinedAt: !881)
!880 = distinct !DISubprogram(name: "add<u64>", linkageName: "_RNvMNtNtCsjIpoRzUjyHQ_4core3ptr7mut_ptrOy3addCs9cj3cTKSYZx_15foundations_lab", scope: !108, file: !107, line: 936, type: !20, scopeLine: 936, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!881 = distinct !DILocation(line: 1036, column: 41, scope: !843, inlinedAt: !827)
!882 = !DILocation(line: 1963, column: 41, scope: !883, inlinedAt: !884)
!883 = distinct !DISubprogram(name: "write<u64>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3ptr5writeyECs9cj3cTKSYZx_15foundations_lab", scope: !110, file: !296, line: 1940, type: !20, scopeLine: 1940, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!884 = distinct !DILocation(line: 1037, column: 13, scope: !885, inlinedAt: !827)
!885 = distinct !DILexicalBlock(scope: !843, file: !62, line: 1036, column: 13)
!886 = !DILocation(line: 1038, column: 13, scope: !885, inlinedAt: !827)
!887 = !DILocation(line: 1013, column: 17, scope: !888, inlinedAt: !889)
!888 = distinct !DISubprogram(name: "unchecked_add", linkageName: "_RNvMs9_NtCsjIpoRzUjyHQ_4core3numj13unchecked_add", scope: !29, file: !28, line: 1001, type: !20, scopeLine: 1001, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!889 = !DILocation(line: 265, column: 28, scope: !890, inlinedAt: !891)
!890 = distinct !DISubprogram(name: "forward_unchecked", linkageName: "_RNvXsL_NtNtCsjIpoRzUjyHQ_4core4iter5rangejNtB5_4Step17forward_unchecked", scope: !163, file: !146, line: 263, type: !20, scopeLine: 263, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!891 = !DILocation(line: 1103, column: 35, scope: !892, inlinedAt: !792)
!892 = distinct !DILexicalBlock(scope: !791, file: !146, line: 1101, column: 13)
!893 = !DILocation(line: 138, column: 1, scope: !743)
!894 = distinct !DISubprogram(name: "init_zero", linkageName: "_RNvCs9cj3cTKSYZx_15foundations_lab9init_zero", scope: !19, file: !18, line: 147, type: !20, scopeLine: 147, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!895 = !{i64 3370252595217392267}
!896 = !DILocation(line: 3212, column: 26, scope: !27, inlinedAt: !897)
!897 = distinct !DILocation(line: 1330, column: 31, scope: !33, inlinedAt: !898)
!898 = distinct !DILocation(line: 533, column: 39, scope: !35, inlinedAt: !899)
!899 = distinct !DILocation(line: 901, column: 17, scope: !42, inlinedAt: !900)
!900 = distinct !DILocation(line: 455, column: 28, scope: !47, inlinedAt: !901)
!901 = distinct !DILocation(line: 587, column: 15, scope: !50, inlinedAt: !902)
!902 = distinct !DILocation(line: 221, column: 20, scope: !52, inlinedAt: !903)
!903 = distinct !DILocation(line: 24, column: 31, scope: !55, inlinedAt: !904)
!904 = distinct !DILocation(line: 3773, column: 5, scope: !905, inlinedAt: !906)
!905 = distinct !DISubprogram(name: "from_elem<u64>", linkageName: "_RINvNtCs6zY7rJBZy9D_5alloc3vec9from_elemyECs9cj3cTKSYZx_15foundations_lab", scope: !59, file: !62, line: 3772, type: !20, scopeLine: 3772, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!906 = !DILocation(line: 148, column: 19, scope: !894)
!907 = !DILocation(line: 478, column: 8, scope: !65, inlinedAt: !908)
!908 = distinct !DILocation(line: 1331, column: 16, scope: !69, inlinedAt: !898)
!909 = !DILocation(line: 461, column: 12, scope: !72, inlinedAt: !901)
!910 = !DILocation(line: 0, scope: !72, inlinedAt: !901)
!911 = !{!912, !914}
!912 = distinct !{!912, !913, !"_RNvMs5_NtCs6zY7rJBZy9D_5alloc7raw_vecNtB5_11RawVecInner15try_allocate_inCs9cj3cTKSYZx_15foundations_lab: %_0"}
!913 = distinct !{!913, !"_RNvMs5_NtCs6zY7rJBZy9D_5alloc7raw_vecNtB5_11RawVecInner15try_allocate_inCs9cj3cTKSYZx_15foundations_lab"}
!914 = distinct !{!914, !915, !"_RINvXs_NtNtCs6zY7rJBZy9D_5alloc3vec14spec_from_elemyNtB5_12SpecFromElem9from_elemNtNtB9_5alloc6GlobalECs9cj3cTKSYZx_15foundations_lab: %_0"}
!915 = distinct !{!915, !"_RINvXs_NtNtCs6zY7rJBZy9D_5alloc3vec14spec_from_elemyNtB5_12SpecFromElem9from_elemNtNtB9_5alloc6GlobalECs9cj3cTKSYZx_15foundations_lab"}
!916 = !DILocation(line: 290, column: 9, scope: !80, inlinedAt: !917)
!917 = distinct !DILocation(line: 302, column: 43, scope: !84, inlinedAt: !918)
!918 = distinct !DILocation(line: 424, column: 9, scope: !88, inlinedAt: !919)
!919 = distinct !DILocation(line: 547, column: 14, scope: !90, inlinedAt: !920)
!920 = distinct !DILocation(line: 468, column: 40, scope: !72, inlinedAt: !901)
!921 = !DILocation(line: 470, column: 25, scope: !95, inlinedAt: !901)
!922 = !DILocation(line: 470, column: 19, scope: !95, inlinedAt: !901)
!923 = !DILocation(line: 478, column: 9, scope: !98, inlinedAt: !901)
!924 = !DILocation(line: 483, column: 5, scope: !47, inlinedAt: !901)
!925 = !DILocation(line: 589, column: 25, scope: !101, inlinedAt: !902)
!926 = !{!914}
!927 = !DILocation(line: 0, scope: !47, inlinedAt: !901)
!928 = !DILocation(line: 588, column: 16, scope: !50, inlinedAt: !902)
!929 = !DILocation(line: 970, column: 18, scope: !930, inlinedAt: !931)
!930 = distinct !DISubprogram(name: "add<u64>", linkageName: "_RNvMNtNtCsjIpoRzUjyHQ_4core3ptr7mut_ptrOy3addCs9cj3cTKSYZx_15foundations_lab", scope: !108, file: !107, line: 936, type: !20, scopeLine: 936, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!931 = !DILocation(line: 240, column: 82, scope: !932, inlinedAt: !935)
!932 = distinct !DILexicalBlock(scope: !933, file: !113, line: 221, column: 9)
!933 = distinct !DILexicalBlock(scope: !934, file: !113, line: 220, column: 9)
!934 = distinct !DISubprogram(name: "new<u64>", linkageName: "_RNvMsa_NtNtCsjIpoRzUjyHQ_4core5slice4iterINtB5_7IterMutyE3newCs9cj3cTKSYZx_15foundations_lab", scope: !116, file: !113, line: 219, type: !20, scopeLine: 219, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!935 = !DILocation(line: 1060, column: 9, scope: !936, inlinedAt: !937)
!936 = distinct !DISubprogram(name: "iter_mut<u64>", linkageName: "_RNvMNtCsjIpoRzUjyHQ_4core5sliceSy8iter_mutCs9cj3cTKSYZx_15foundations_lab", scope: !122, file: !121, line: 1059, type: !20, scopeLine: 1059, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!937 = !DILocation(line: 149, column: 27, scope: !938)
!938 = distinct !DILexicalBlock(scope: !894, file: !18, line: 148, column: 5)
!939 = !DILocation(line: 1663, column: 9, scope: !940, inlinedAt: !941)
!940 = distinct !DISubprogram(name: "eq<u64>", linkageName: "_RNvXsd_NtNtCsjIpoRzUjyHQ_4core3ptr8non_nullINtB5_7NonNullyENtNtB9_3cmp9PartialEq2eqCs9cj3cTKSYZx_15foundations_lab", scope: !214, file: !136, line: 1662, type: !20, scopeLine: 1662, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!941 = distinct !DILocation(line: 180, column: 28, scope: !942, inlinedAt: !945)
!942 = distinct !DILexicalBlock(scope: !943, file: !127, line: 162, column: 17)
!943 = distinct !DILexicalBlock(scope: !944, file: !127, line: 161, column: 17)
!944 = distinct !DISubprogram(name: "next<u64>", linkageName: "_RNvXs2Q_NtNtCsjIpoRzUjyHQ_4core5slice4iterINtB6_7IterMutyENtNtNtNtBa_4iter6traits8iterator8Iterator4nextCs9cj3cTKSYZx_15foundations_lab", scope: !130, file: !127, line: 157, type: !20, scopeLine: 157, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!945 = distinct !DILocation(line: 80, column: 27, scope: !946, inlinedAt: !950)
!946 = distinct !DISubprogram(name: "next<core::slice::iter::IterMut<u64>>", linkageName: "_RNvXs_NtNtNtCsjIpoRzUjyHQ_4core4iter8adapters9enumerateINtB4_9EnumerateINtNtNtBa_5slice4iter7IterMutyEENtNtNtB8_6traits8iterator8Iterator4nextCs9cj3cTKSYZx_15foundations_lab", scope: !948, file: !947, line: 79, type: !20, scopeLine: 79, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!947 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/iter/adapters/enumerate.rs", directory: "", checksumkind: CSK_MD5, checksum: "593117651994d9f54658d086cd09bf97")
!948 = !DINamespace(name: "{impl#1}", scope: !949)
!949 = !DINamespace(name: "enumerate", scope: !468)
!950 = distinct !DILocation(line: 149, column: 23, scope: !951)
!951 = distinct !DILexicalBlock(scope: !938, file: !18, line: 149, column: 5)
!952 = !DILocation(line: 180, column: 28, scope: !942, inlinedAt: !945)
!953 = !DILocation(line: 82, column: 9, scope: !954, inlinedAt: !950)
!954 = distinct !DILexicalBlock(scope: !955, file: !947, line: 81, column: 9)
!955 = distinct !DILexicalBlock(scope: !946, file: !947, line: 80, column: 9)
!956 = !DILocation(line: 2728, column: 13, scope: !957, inlinedAt: !958)
!957 = distinct !DISubprogram(name: "wrapping_mul", linkageName: "_RNvMs7_NtCsjIpoRzUjyHQ_4core3numy12wrapping_mul", scope: !493, file: !28, line: 2727, type: !20, scopeLine: 2727, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!958 = !DILocation(line: 150, column: 29, scope: !959)
!959 = distinct !DILexicalBlock(scope: !951, file: !18, line: 149, column: 5)
!960 = !DILocation(line: 150, column: 9, scope: !959)
!961 = distinct !{!961, !534, !535}
!962 = !DILocation(line: 627, column: 28, scope: !963, inlinedAt: !964)
!963 = distinct !DISubprogram(name: "add<u64>", linkageName: "_RNvMs1_NtNtCsjIpoRzUjyHQ_4core3ptr8non_nullINtB5_7NonNullyE3addCs9cj3cTKSYZx_15foundations_lab", scope: !137, file: !136, line: 619, type: !20, scopeLine: 619, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!964 = distinct !DILocation(line: 185, column: 40, scope: !942, inlinedAt: !945)
!965 = distinct !{!965, !534}
!966 = !DILocation(line: 152, column: 14, scope: !938)
!967 = !DILocation(line: 491, column: 5, scope: !968, inlinedAt: !966)
!968 = distinct !DISubprogram(name: "black_box<&[u64]>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core4hint9black_boxRSyECs9cj3cTKSYZx_15foundations_lab", scope: !208, file: !207, line: 490, type: !20, scopeLine: 490, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!969 = !DILocation(line: 152, column: 5, scope: !938)
!970 = !DILocation(line: 152, column: 29, scope: !938)
!971 = !DILocation(line: 631, column: 39, scope: !287, inlinedAt: !972)
!972 = distinct !DILocation(line: 874, column: 52, scope: !289, inlinedAt: !973)
!973 = distinct !DILocation(line: 425, column: 29, scope: !292, inlinedAt: !974)
!974 = distinct !DILocation(line: 847, column: 1, scope: !295, inlinedAt: !975)
!975 = distinct !DILocation(line: 847, column: 1, scope: !298, inlinedAt: !976)
!976 = distinct !DILocation(line: 153, column: 1, scope: !894)
!977 = !DILocation(line: 1401, column: 17, scope: !301, inlinedAt: !978)
!978 = distinct !DILocation(line: 639, column: 53, scope: !287, inlinedAt: !972)
!979 = !DILocation(line: 175, column: 14, scope: !304, inlinedAt: !980)
!980 = distinct !DILocation(line: 321, column: 22, scope: !306, inlinedAt: !981)
!981 = distinct !DILocation(line: 436, column: 9, scope: !308, inlinedAt: !982)
!982 = distinct !DILocation(line: 554, column: 23, scope: !310, inlinedAt: !983)
!983 = distinct !DILocation(line: 876, column: 28, scope: !289, inlinedAt: !973)
!984 = !DILocation(line: 312, column: 9, scope: !306, inlinedAt: !981)
!985 = !DILocation(line: 153, column: 2, scope: !894)
!986 = distinct !DISubprogram(name: "sum_index", linkageName: "_RNvCs9cj3cTKSYZx_15foundations_lab9sum_index", scope: !19, file: !18, line: 51, type: !20, scopeLine: 51, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!987 = !{i64 -5492295441670971332}
!988 = !DILocation(line: 54, column: 11, scope: !989)
!989 = distinct !DILexicalBlock(scope: !990, file: !18, line: 53, column: 5)
!990 = distinct !DILexicalBlock(scope: !986, file: !18, line: 52, column: 5)
!991 = !DILocation(line: 56, column: 9, scope: !989)
!992 = !DILocation(line: 55, column: 32, scope: !989)
!993 = !DILocation(line: 2652, column: 13, scope: !994, inlinedAt: !995)
!994 = distinct !DISubprogram(name: "wrapping_add", linkageName: "_RNvMs7_NtCsjIpoRzUjyHQ_4core3numy12wrapping_add", scope: !493, file: !28, line: 2651, type: !20, scopeLine: 2651, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!995 = !DILocation(line: 55, column: 19, scope: !989)
!996 = distinct !{!996, !534, !535}
!997 = !DILocation(line: 0, scope: !986)
!998 = !DILocation(line: 59, column: 2, scope: !986)
!999 = distinct !{!999, !535, !534}
!1000 = distinct !DISubprogram(name: "new", linkageName: "_RNvMCs9cj3cTKSYZx_15foundations_labNtB2_10ByteRegion3new", scope: !1001, file: !18, line: 107, type: !20, scopeLine: 107, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!1001 = !DINamespace(name: "ByteRegion", scope: !19)
!1002 = !{i64 -1178946437422764477}
!1003 = !DILocation(line: 478, column: 8, scope: !65, inlinedAt: !1004)
!1004 = distinct !DILocation(line: 1331, column: 16, scope: !69, inlinedAt: !1005)
!1005 = distinct !DILocation(line: 533, column: 39, scope: !35, inlinedAt: !1006)
!1006 = distinct !DILocation(line: 901, column: 17, scope: !42, inlinedAt: !1007)
!1007 = distinct !DILocation(line: 455, column: 28, scope: !47, inlinedAt: !1008)
!1008 = distinct !DILocation(line: 587, column: 15, scope: !1009, inlinedAt: !1010)
!1009 = distinct !DISubprogram(name: "with_capacity_zeroed_in<alloc::alloc::Global>", linkageName: "_RNvMs2_NtCs6zY7rJBZy9D_5alloc7raw_vecNtB5_11RawVecInner23with_capacity_zeroed_inCs9cj3cTKSYZx_15foundations_lab", scope: !48, file: !43, line: 586, type: !20, scopeLine: 586, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!1010 = distinct !DILocation(line: 221, column: 20, scope: !1011, inlinedAt: !1012)
!1011 = distinct !DISubprogram(name: "with_capacity_zeroed_in<u8, alloc::alloc::Global>", linkageName: "_RNvMs0_NtCs6zY7rJBZy9D_5alloc7raw_vecINtB5_6RawVechE23with_capacity_zeroed_inCs9cj3cTKSYZx_15foundations_lab", scope: !53, file: !43, line: 219, type: !20, scopeLine: 219, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!1012 = distinct !DILocation(line: 51, column: 31, scope: !1013, inlinedAt: !1015)
!1013 = distinct !DISubprogram(name: "from_elem<alloc::alloc::Global>", linkageName: "_RINvXs1_NtNtCs6zY7rJBZy9D_5alloc3vec14spec_from_elemhNtB6_12SpecFromElem9from_elemNtNtBa_5alloc6GlobalECs9cj3cTKSYZx_15foundations_lab", scope: !1014, file: !56, line: 49, type: !20, scopeLine: 49, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!1014 = !DINamespace(name: "{impl#3}", scope: !58)
!1015 = distinct !DILocation(line: 3773, column: 5, scope: !1016, inlinedAt: !1017)
!1016 = distinct !DISubprogram(name: "from_elem<u8>", linkageName: "_RINvNtCs6zY7rJBZy9D_5alloc3vec9from_elemhECs9cj3cTKSYZx_15foundations_lab", scope: !59, file: !62, line: 3772, type: !20, scopeLine: 3772, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!1017 = !DILocation(line: 109, column: 22, scope: !1000)
!1018 = !DILocation(line: 461, column: 12, scope: !72, inlinedAt: !1008)
!1019 = !DILocation(line: 0, scope: !72, inlinedAt: !1008)
!1020 = !{!1021, !1023}
!1021 = distinct !{!1021, !1022, !"_RNvMs5_NtCs6zY7rJBZy9D_5alloc7raw_vecNtB5_11RawVecInner15try_allocate_inCs9cj3cTKSYZx_15foundations_lab: %_0"}
!1022 = distinct !{!1022, !"_RNvMs5_NtCs6zY7rJBZy9D_5alloc7raw_vecNtB5_11RawVecInner15try_allocate_inCs9cj3cTKSYZx_15foundations_lab"}
!1023 = distinct !{!1023, !1024, !"_RINvXs1_NtNtCs6zY7rJBZy9D_5alloc3vec14spec_from_elemhNtB6_12SpecFromElem9from_elemNtNtBa_5alloc6GlobalECs9cj3cTKSYZx_15foundations_lab: %v"}
!1024 = distinct !{!1024, !"_RINvXs1_NtNtCs6zY7rJBZy9D_5alloc3vec14spec_from_elemhNtB6_12SpecFromElem9from_elemNtNtBa_5alloc6GlobalECs9cj3cTKSYZx_15foundations_lab"}
!1025 = !DILocation(line: 290, column: 9, scope: !80, inlinedAt: !1026)
!1026 = distinct !DILocation(line: 302, column: 43, scope: !84, inlinedAt: !1027)
!1027 = distinct !DILocation(line: 424, column: 9, scope: !88, inlinedAt: !1028)
!1028 = distinct !DILocation(line: 547, column: 14, scope: !90, inlinedAt: !1029)
!1029 = distinct !DILocation(line: 468, column: 40, scope: !72, inlinedAt: !1008)
!1030 = !DILocation(line: 470, column: 25, scope: !95, inlinedAt: !1008)
!1031 = !DILocation(line: 470, column: 19, scope: !95, inlinedAt: !1008)
!1032 = !DILocation(line: 478, column: 9, scope: !98, inlinedAt: !1008)
!1033 = !DILocation(line: 483, column: 5, scope: !47, inlinedAt: !1008)
!1034 = !DILocation(line: 589, column: 25, scope: !1035, inlinedAt: !1010)
!1035 = distinct !DILexicalBlock(scope: !1009, file: !43, line: 589, column: 13)
!1036 = !{!1023}
!1037 = !DILocation(line: 588, column: 16, scope: !1009, inlinedAt: !1010)
!1038 = !DILocation(line: 108, column: 9, scope: !1000)
!1039 = !DILocation(line: 112, column: 6, scope: !1000)
!1040 = distinct !DISubprogram(name: "grow_one<u64, alloc::alloc::Global>", linkageName: "_RNvMs4_NtCs6zY7rJBZy9D_5alloc7raw_vecINtB5_6RawVecyE8grow_oneCs9cj3cTKSYZx_15foundations_lab", scope: !53, file: !43, line: 186, type: !20, scopeLine: 186, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!1041 = !{i64 -7018218485054564963}
!1042 = !DILocation(line: 493, column: 56, scope: !1043, inlinedAt: !1045)
!1043 = distinct !DILexicalBlock(scope: !1044, file: !43, line: 493, column: 95)
!1044 = distinct !DISubprogram(name: "grow_one<alloc::alloc::Global>", linkageName: "_RNvMs5_NtCs6zY7rJBZy9D_5alloc7raw_vecNtB5_11RawVecInner8grow_oneCs9cj3cTKSYZx_15foundations_lab", scope: !48, file: !43, line: 491, type: !20, scopeLine: 491, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!1045 = !DILocation(line: 188, column: 29, scope: !1040)
!1046 = !{!1047}
!1047 = distinct !{!1047, !1048, !"_RNvMs5_NtCs6zY7rJBZy9D_5alloc7raw_vecNtB5_11RawVecInner14grow_amortizedCs9cj3cTKSYZx_15foundations_lab: %self"}
!1048 = distinct !{!1048, !"_RNvMs5_NtCs6zY7rJBZy9D_5alloc7raw_vecNtB5_11RawVecInner14grow_amortizedCs9cj3cTKSYZx_15foundations_lab"}
!1049 = !DILocation(line: 493, column: 41, scope: !1043, inlinedAt: !1045)
!1050 = !DILocation(line: 523, column: 28, scope: !1051, inlinedAt: !1053)
!1051 = distinct !DILexicalBlock(scope: !1052, file: !43, line: 519, column: 9)
!1052 = distinct !DISubprogram(name: "grow_amortized<alloc::alloc::Global>", linkageName: "_RNvMs5_NtCs6zY7rJBZy9D_5alloc7raw_vecNtB5_11RawVecInner14grow_amortizedCs9cj3cTKSYZx_15foundations_lab", scope: !48, file: !43, line: 503, type: !20, scopeLine: 503, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!1053 = distinct !DILocation(line: 493, column: 41, scope: !1043, inlinedAt: !1045)
!1054 = !DILocation(line: 1051, column: 5, scope: !1055, inlinedAt: !1057)
!1055 = distinct !DISubprogram(name: "max<usize>", linkageName: "_RNvYjNtNtCsjIpoRzUjyHQ_4core3cmp3Ord3maxCs9cj3cTKSYZx_15foundations_lab", scope: !1056, file: !277, line: 1046, type: !20, scopeLine: 1046, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!1056 = !DINamespace(name: "Ord", scope: !280)
!1057 = distinct !DILocation(line: 1694, column: 8, scope: !1058, inlinedAt: !1059)
!1058 = distinct !DISubprogram(name: "max<usize>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3cmp3maxjECs9cj3cTKSYZx_15foundations_lab", scope: !280, file: !277, line: 1693, type: !20, scopeLine: 1693, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!1059 = distinct !DILocation(line: 524, column: 19, scope: !1060, inlinedAt: !1053)
!1060 = distinct !DILexicalBlock(scope: !1051, file: !43, line: 523, column: 9)
!1061 = !DILocation(line: 529, column: 28, scope: !1062, inlinedAt: !1053)
!1062 = distinct !DILexicalBlock(scope: !1060, file: !43, line: 524, column: 9)
!1063 = !DILocation(line: 529, column: 33, scope: !1062, inlinedAt: !1053)
!1064 = !DILocation(line: 2177, column: 15, scope: !1065, inlinedAt: !1069)
!1065 = distinct !DISubprogram(name: "branch<core::ptr::non_null::NonNull<[u8]>, alloc::collections::TryReserveError>", linkageName: "_RNvXsp_NtCsjIpoRzUjyHQ_4core6resultINtB5_6ResultINtNtNtB7_3ptr8non_null7NonNullShENtNtCs6zY7rJBZy9D_5alloc11collections15TryReserveErrorENtNtNtB7_3ops9try_trait3Try6branchCs9cj3cTKSYZx_15foundations_lab", scope: !1067, file: !1066, line: 2176, type: !20, scopeLine: 2176, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!1066 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/result.rs", directory: "", checksumkind: CSK_MD5, checksum: "d01c390c1644b468299b560eda4cb25a")
!1067 = !DINamespace(name: "{impl#27}", scope: !1068)
!1068 = !DINamespace(name: "result", scope: !31)
!1069 = distinct !DILocation(line: 529, column: 28, scope: !1062, inlinedAt: !1053)
!1070 = !{i64 0, i64 2}
!1071 = !DILocation(line: 2177, column: 9, scope: !1065, inlinedAt: !1069)
!1072 = !DILocation(line: 0, scope: !1065, inlinedAt: !1069)
!1073 = !DILocation(line: 2179, column: 17, scope: !1065, inlinedAt: !1069)
!1074 = !{i64 0, i64 -9223372036854775807}
!1075 = !DILocation(line: 529, column: 62, scope: !1062, inlinedAt: !1053)
!1076 = !DILocation(line: 494, column: 13, scope: !1043, inlinedAt: !1045)
!1077 = !DILocation(line: 2178, column: 16, scope: !1065, inlinedAt: !1069)
!1078 = !DILocation(line: 773, column: 9, scope: !1079, inlinedAt: !1080)
!1079 = distinct !DISubprogram(name: "set_ptr_and_cap<alloc::alloc::Global>", linkageName: "_RNvMs2_NtCs6zY7rJBZy9D_5alloc7raw_vecNtB5_11RawVecInner15set_ptr_and_capCs9cj3cTKSYZx_15foundations_lab", scope: !48, file: !43, line: 769, type: !20, scopeLine: 769, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!1080 = distinct !DILocation(line: 532, column: 23, scope: !1081, inlinedAt: !1053)
!1081 = distinct !DILexicalBlock(scope: !1062, file: !43, line: 529, column: 9)
!1082 = !DILocation(line: 42, column: 26, scope: !1083, inlinedAt: !1085)
!1083 = distinct !DISubprogram(name: "new_unchecked", linkageName: "_RNvMs1z_NtNtCsjIpoRzUjyHQ_4core3num11niche_typesNtB6_14UsizeNoHighBit13new_unchecked", scope: !1084, file: !260, line: 40, type: !20, scopeLine: 40, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!1084 = !DINamespace(name: "UsizeNoHighBit", scope: !262)
!1085 = distinct !DILocation(line: 774, column: 29, scope: !1079, inlinedAt: !1080)
!1086 = !DILocation(line: 774, column: 9, scope: !1079, inlinedAt: !1080)
!1087 = !DILocation(line: 189, column: 6, scope: !1040)
!1088 = distinct !DISubprogram(name: "finish_grow<alloc::alloc::Global>", linkageName: "_RNvMs5_NtCs6zY7rJBZy9D_5alloc7raw_vecNtB5_11RawVecInner11finish_growCs9cj3cTKSYZx_15foundations_lab", scope: !48, file: !43, line: 544, type: !92, scopeLine: 544, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!1089 = !{i64 234976998000780746}
!1090 = !DILocation(line: 3212, column: 26, scope: !1091, inlinedAt: !1092)
!1091 = distinct !DISubprogram(name: "overflowing_mul", linkageName: "_RNvMs9_NtCsjIpoRzUjyHQ_4core3numj15overflowing_mul", scope: !29, file: !28, line: 3211, type: !20, scopeLine: 3211, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!1092 = !DILocation(line: 1330, column: 31, scope: !1093, inlinedAt: !1094)
!1093 = distinct !DISubprogram(name: "checked_mul", linkageName: "_RNvMs9_NtCsjIpoRzUjyHQ_4core3numj11checked_mul", scope: !29, file: !28, line: 1329, type: !20, scopeLine: 1329, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!1094 = !DILocation(line: 533, column: 39, scope: !1095, inlinedAt: !1097)
!1095 = distinct !DILexicalBlock(scope: !1096, file: !36, line: 533, column: 54)
!1096 = distinct !DISubprogram(name: "repeat_packed", linkageName: "_RNvMNtNtCsjIpoRzUjyHQ_4core5alloc6layoutNtB2_6Layout13repeat_packed", scope: !38, file: !36, line: 532, type: !20, scopeLine: 532, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!1097 = !DILocation(line: 901, column: 17, scope: !1098, inlinedAt: !1099)
!1098 = distinct !DISubprogram(name: "layout_array", linkageName: "_RNvNtCs6zY7rJBZy9D_5alloc7raw_vec12layout_array", scope: !44, file: !43, line: 896, type: !20, scopeLine: 896, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!1099 = !DILocation(line: 549, column: 26, scope: !1088)
!1100 = !DILocation(line: 478, column: 8, scope: !1101, inlinedAt: !1102)
!1101 = distinct !DISubprogram(name: "unlikely", linkageName: "_RNvNtCsjIpoRzUjyHQ_4core10intrinsics8unlikely", scope: !67, file: !66, line: 477, type: !20, scopeLine: 477, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!1102 = !DILocation(line: 1331, column: 16, scope: !1103, inlinedAt: !1094)
!1103 = distinct !DILexicalBlock(scope: !1093, file: !28, line: 1330, column: 13)
!1104 = !{!"branch_weights", i32 2000, i32 2002}
!1105 = !DILocation(line: 631, column: 39, scope: !287, inlinedAt: !1106)
!1106 = distinct !DILocation(line: 551, column: 69, scope: !1107)
!1107 = distinct !DILexicalBlock(scope: !1108, file: !43, line: 551, column: 99)
!1108 = distinct !DILexicalBlock(scope: !1088, file: !43, line: 549, column: 9)
!1109 = !DILocation(line: 1401, column: 17, scope: !301, inlinedAt: !1110)
!1110 = distinct !DILocation(line: 639, column: 53, scope: !287, inlinedAt: !1106)
!1111 = !DILocation(line: 349, column: 40, scope: !1112, inlinedAt: !1115)
!1112 = distinct !DILexicalBlock(scope: !1113, file: !81, line: 346, column: 17)
!1113 = distinct !DILexicalBlock(scope: !1114, file: !81, line: 345, column: 13)
!1114 = distinct !DISubprogram(name: "grow_impl_runtime", linkageName: "_RNvMs0_NtCs6zY7rJBZy9D_5alloc5allocNtB5_6Global17grow_impl_runtime", scope: !86, file: !81, line: 328, type: !92, scopeLine: 328, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!1115 = distinct !DILocation(line: 454, column: 9, scope: !1116, inlinedAt: !1117)
!1116 = distinct !DISubprogram(name: "grow_impl", linkageName: "_RNvMs0_NtCs6zY7rJBZy9D_5alloc5allocNtB5_6Global9grow_impl", scope: !86, file: !81, line: 447, type: !20, scopeLine: 447, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!1117 = distinct !DILocation(line: 566, column: 23, scope: !1118, inlinedAt: !1119)
!1118 = distinct !DISubprogram(name: "grow", linkageName: "_RNvXs1_NtCs6zY7rJBZy9D_5alloc5allocNtB5_6GlobalNtNtCsjIpoRzUjyHQ_4core5alloc9Allocator4grow", scope: !91, file: !81, line: 559, type: !92, scopeLine: 559, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!1119 = distinct !DILocation(line: 557, column: 28, scope: !1107)
!1120 = !DILocation(line: 210, column: 9, scope: !1121, inlinedAt: !1122)
!1121 = distinct !DISubprogram(name: "assert_unchecked", linkageName: "_RNvNtCsjIpoRzUjyHQ_4core4hint16assert_unchecked", scope: !208, file: !207, line: 202, type: !20, scopeLine: 202, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!1122 = distinct !DILocation(line: 349, column: 17, scope: !1112, inlinedAt: !1115)
!1123 = !DILocation(line: 228, column: 14, scope: !1124, inlinedAt: !1125)
!1124 = distinct !DISubprogram(name: "realloc_nonnull", linkageName: "_RNvNtCs6zY7rJBZy9D_5alloc5alloc15realloc_nonnull", scope: !82, file: !81, line: 227, type: !20, scopeLine: 227, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!1125 = distinct !DILocation(line: 351, column: 31, scope: !1112, inlinedAt: !1115)
!1126 = !DILocation(line: 551, column: 22, scope: !1108)
!1127 = !DILocation(line: 298, column: 9, scope: !85, inlinedAt: !1128)
!1128 = distinct !DILocation(line: 424, column: 9, scope: !434, inlinedAt: !1129)
!1129 = distinct !DILocation(line: 541, column: 14, scope: !436, inlinedAt: !1130)
!1130 = distinct !DILocation(line: 560, column: 24, scope: !1108)
!1131 = !DILocation(line: 302, scope: !84, inlinedAt: !1128)
!1132 = !DILocation(line: 130, column: 9, scope: !431, inlinedAt: !1133)
!1133 = distinct !DILocation(line: 302, column: 73, scope: !84, inlinedAt: !1128)
!1134 = !DILocation(line: 302, column: 31, scope: !84, inlinedAt: !1128)
!1135 = !DILocation(line: 965, column: 15, scope: !1136, inlinedAt: !1138)
!1136 = distinct !DISubprogram(name: "map_err<core::ptr::non_null::NonNull<[u8]>, core::alloc::AllocError, alloc::collections::TryReserveError, alloc::raw_vec::{impl#7}::finish_grow::{closure_env#0}<alloc::alloc::Global>>", linkageName: "_RINvMNtCsjIpoRzUjyHQ_4core6resultINtB3_6ResultINtNtNtB5_3ptr8non_null7NonNullShENtNtB5_5alloc10AllocErrorE7map_errNtNtCs6zY7rJBZy9D_5alloc11collections15TryReserveErrorNCNvMs5_NtB1S_7raw_vecNtB2O_11RawVecInner11finish_grow0ECs9cj3cTKSYZx_15foundations_lab", scope: !1137, file: !1066, line: 961, type: !20, scopeLine: 961, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!1137 = !DINamespace(name: "Result", scope: !1068)
!1138 = !DILocation(line: 563, column: 16, scope: !1139)
!1139 = distinct !DILexicalBlock(scope: !1108, file: !43, line: 551, column: 9)
!1140 = !DILocation(line: 965, column: 9, scope: !1136, inlinedAt: !1138)
!1141 = !DILocation(line: 967, column: 23, scope: !1142, inlinedAt: !1138)
!1142 = distinct !DILexicalBlock(scope: !1136, file: !1066, line: 967, column: 13)
!1143 = !DILocation(line: 967, column: 32, scope: !1136, inlinedAt: !1138)
!1144 = !DILocation(line: 966, column: 22, scope: !1145, inlinedAt: !1138)
!1145 = distinct !DILexicalBlock(scope: !1136, file: !1066, line: 966, column: 13)
!1146 = !DILocation(line: 969, column: 5, scope: !1136, inlinedAt: !1138)
!1147 = !DILocation(line: 0, scope: !1088)
!1148 = !DILocation(line: 564, column: 6, scope: !1088)
!1149 = distinct !DISubprogram(name: "fmt<str>", linkageName: "_RNvXs1i_NtCsjIpoRzUjyHQ_4core3fmtReNtB6_7Display3fmtCs9cj3cTKSYZx_15foundations_lab", scope: !1151, file: !1150, line: 2872, type: !20, scopeLine: 2872, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !15, templateParams: !21)
!1150 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/fmt/mod.rs", directory: "", checksumkind: CSK_MD5, checksum: "363229db3a4a2c778c00c76c7b1385ee")
!1151 = !DINamespace(name: "{impl#82}", scope: !1152)
!1152 = !DINamespace(name: "fmt", scope: !31)
!1153 = !{i64 -7231001345260711296}
!1154 = !DILocation(line: 2872, column: 71, scope: !1149)
!1155 = !DILocation(line: 2872, column: 62, scope: !1149)
!1156 = !DILocation(line: 2872, column: 84, scope: !1149)
