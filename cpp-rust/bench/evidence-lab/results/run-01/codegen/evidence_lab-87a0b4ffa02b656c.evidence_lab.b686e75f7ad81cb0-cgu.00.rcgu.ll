; ModuleID = 'evidence_lab.b686e75f7ad81cb0-cgu.00'
source_filename = "evidence_lab.b686e75f7ad81cb0-cgu.00"
target datalayout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx11.0.0"

@alloc_466e6e10d4d5a95679ab35d1156aa54e = private unnamed_addr constant [11 x i8] c"src/lib.rs\00", align 1, !guid !0
@alloc_08ced1a55cdf80334bb487cb4f86e33b = private unnamed_addr constant <{ ptr, [16 x i8] }> <{ ptr @alloc_466e6e10d4d5a95679ab35d1156aa54e, [16 x i8] c"\0A\00\00\00\00\00\00\00c\00\00\00\05\00\00\00" }>, align 8, !guid !1
@alloc_72ddc97835b37bfd8fea21ecd4453ca4 = private unnamed_addr constant [40 x i8] c"observations must be finite and positive", align 1, !guid !2
@alloc_b9a397bd223322fcb45d21070930734e = private unnamed_addr constant [32 x i8] c"expected exactly 21 observations", align 1, !guid !3
@alloc_ea036d046f53e77e29f5a358dcf53fd4 = private unnamed_addr constant [18 x i8] c"valid measurements", align 1, !guid !4
@alloc_629ad608d4fe57cf57ef053920aa8d17 = private unnamed_addr constant <{ ptr, [16 x i8] }> <{ ptr @alloc_466e6e10d4d5a95679ab35d1156aa54e, [16 x i8] c"\0A\00\00\00\00\00\00\00p\00\00\00\1F\00\00\00" }>, align 8, !guid !5
@alloc_d0a8d7f7801890de0a5a93e364996e45 = private unnamed_addr constant [70 x i8] c"\08summary,\C0\03,n=\C0\06,mean=\C5 \00\00p\06\00\04,sd=\C5 \00\00p\06\00\05,p50=\C5 \00\00p\06\00\05,p99=\C5 \00\00p\06\00\01\0A\00", align 1, !guid !6
@vtable.0 = private unnamed_addr constant <{ [24 x i8], ptr }> <{ [24 x i8] c"\00\00\00\00\00\00\00\00\10\00\00\00\00\00\00\00\08\00\00\00\00\00\00\00", ptr @_RNvXs1g_NtCsjIpoRzUjyHQ_4core3fmtReNtB6_5Debug3fmtCsfFAnx7WYh7o_12evidence_lab }>, align 8, !guid !7

; evidence_lab::nearest_rank
; Function Attrs: uwtable
define noundef double @_RNvCsfFAnx7WYh7o_12evidence_lab12nearest_rank(ptr noalias nofree noundef nonnull readonly align 8 captures(none) %sorted.0, i64 noundef range(i64 0, 1152921504606846976) %sorted.1, double noundef %probability) unnamed_addr #0 personality ptr @rust_eh_personality !dbg !22 !guid !27 {
start:
  %_6 = uitofp nneg i64 %sorted.1 to double, !dbg !28
  %_5 = fmul double %probability, %_6, !dbg !29
  %_4 = tail call double @llvm.ceil.f64(double %_5), !dbg !30
  %rank = tail call i64 @llvm.fptoui.sat.i64.f64(double %_4), !dbg !29
  %_8 = tail call i64 @llvm.usub.sat.i64(i64 %rank, i64 1), !dbg !43
  %_10 = icmp ult i64 %_8, %sorted.1, !dbg !45
  br i1 %_10, label %bb2, label %panic, !dbg !45

bb2:                                              ; preds = %start
  %0 = getelementptr inbounds nuw [8 x i8], ptr %sorted.0, i64 %_8, !dbg !45
  %_0 = load double, ptr %0, align 8, !dbg !45, !noundef !26
  ret double %_0, !dbg !46

panic:                                            ; preds = %start
; call core::panicking::panic_bounds_check
  tail call void @_RNvNtCsjIpoRzUjyHQ_4core9panicking18panic_bounds_check(i64 noundef %_8, i64 noundef %sorted.1, ptr noalias nofree noundef readonly align 8 captures(address, read_provenance) dereferenceable(24) @alloc_08ced1a55cdf80334bb487cb4f86e33b) #15, !dbg !45
  unreachable, !dbg !45
}

; evidence_lab::complete_samples
; Function Attrs: mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: read) uwtable
define { ptr, i64 } @_RNvCsfFAnx7WYh7o_12evidence_lab16complete_samples(ptr noalias nofree noundef nonnull readonly align 8 captures(none) %samples.0, i64 noundef range(i64 0, 1152921504606846976) %samples.1) unnamed_addr #1 personality ptr @rust_eh_personality !dbg !47 !guid !48 {
start:
  %0 = icmp eq i64 %samples.1, 21, !dbg !49
  br i1 %0, label %bb1.i.preheader, label %bb6, !dbg !49

bb1.i.preheader:                                  ; preds = %start
  %ptr.val.i = load double, ptr %samples.0, align 8, !dbg !50, !noalias !58, !noundef !26
  %_0.sroa.0.0.off0.i.i = tail call noundef i1 @llvm.is.fpclass.f64(double %ptr.val.i, /* (nan inf zero nsub nnorm) */ i32 639), !dbg !61
  br i1 %_0.sroa.0.0.off0.i.i, label %bb6, label %bb1.i.1, !dbg !50

bb1.i.1:                                          ; preds = %bb1.i.preheader
  %_221.i.ptr.1 = getelementptr inbounds nuw i8, ptr %samples.0, i64 8, !dbg !66
  %ptr.val.i.1 = load double, ptr %_221.i.ptr.1, align 8, !dbg !50, !noalias !58, !noundef !26
  %_0.sroa.0.0.off0.i.i.1 = tail call noundef i1 @llvm.is.fpclass.f64(double %ptr.val.i.1, /* (nan inf zero nsub nnorm) */ i32 639), !dbg !61
  br i1 %_0.sroa.0.0.off0.i.i.1, label %bb6, label %bb1.i.2, !dbg !50

bb1.i.2:                                          ; preds = %bb1.i.1
  %_221.i.ptr.2 = getelementptr inbounds nuw i8, ptr %samples.0, i64 16, !dbg !66
  %ptr.val.i.2 = load double, ptr %_221.i.ptr.2, align 8, !dbg !50, !noalias !58, !noundef !26
  %_0.sroa.0.0.off0.i.i.2 = tail call noundef i1 @llvm.is.fpclass.f64(double %ptr.val.i.2, /* (nan inf zero nsub nnorm) */ i32 639), !dbg !61
  br i1 %_0.sroa.0.0.off0.i.i.2, label %bb6, label %bb1.i.3, !dbg !50

bb1.i.3:                                          ; preds = %bb1.i.2
  %_221.i.ptr.3 = getelementptr inbounds nuw i8, ptr %samples.0, i64 24, !dbg !66
  %ptr.val.i.3 = load double, ptr %_221.i.ptr.3, align 8, !dbg !50, !noalias !58, !noundef !26
  %_0.sroa.0.0.off0.i.i.3 = tail call noundef i1 @llvm.is.fpclass.f64(double %ptr.val.i.3, /* (nan inf zero nsub nnorm) */ i32 639), !dbg !61
  br i1 %_0.sroa.0.0.off0.i.i.3, label %bb6, label %bb1.i.4, !dbg !50

bb1.i.4:                                          ; preds = %bb1.i.3
  %_221.i.ptr.4 = getelementptr inbounds nuw i8, ptr %samples.0, i64 32, !dbg !66
  %ptr.val.i.4 = load double, ptr %_221.i.ptr.4, align 8, !dbg !50, !noalias !58, !noundef !26
  %_0.sroa.0.0.off0.i.i.4 = tail call noundef i1 @llvm.is.fpclass.f64(double %ptr.val.i.4, /* (nan inf zero nsub nnorm) */ i32 639), !dbg !61
  br i1 %_0.sroa.0.0.off0.i.i.4, label %bb6, label %bb1.i.5, !dbg !50

bb1.i.5:                                          ; preds = %bb1.i.4
  %_221.i.ptr.5 = getelementptr inbounds nuw i8, ptr %samples.0, i64 40, !dbg !66
  %ptr.val.i.5 = load double, ptr %_221.i.ptr.5, align 8, !dbg !50, !noalias !58, !noundef !26
  %_0.sroa.0.0.off0.i.i.5 = tail call noundef i1 @llvm.is.fpclass.f64(double %ptr.val.i.5, /* (nan inf zero nsub nnorm) */ i32 639), !dbg !61
  br i1 %_0.sroa.0.0.off0.i.i.5, label %bb6, label %bb1.i.6, !dbg !50

bb1.i.6:                                          ; preds = %bb1.i.5
  %_221.i.ptr.6 = getelementptr inbounds nuw i8, ptr %samples.0, i64 48, !dbg !66
  %ptr.val.i.6 = load double, ptr %_221.i.ptr.6, align 8, !dbg !50, !noalias !58, !noundef !26
  %_0.sroa.0.0.off0.i.i.6 = tail call noundef i1 @llvm.is.fpclass.f64(double %ptr.val.i.6, /* (nan inf zero nsub nnorm) */ i32 639), !dbg !61
  br i1 %_0.sroa.0.0.off0.i.i.6, label %bb6, label %bb1.i.7, !dbg !50

bb1.i.7:                                          ; preds = %bb1.i.6
  %_221.i.ptr.7 = getelementptr inbounds nuw i8, ptr %samples.0, i64 56, !dbg !66
  %ptr.val.i.7 = load double, ptr %_221.i.ptr.7, align 8, !dbg !50, !noalias !58, !noundef !26
  %_0.sroa.0.0.off0.i.i.7 = tail call noundef i1 @llvm.is.fpclass.f64(double %ptr.val.i.7, /* (nan inf zero nsub nnorm) */ i32 639), !dbg !61
  br i1 %_0.sroa.0.0.off0.i.i.7, label %bb6, label %bb1.i.8, !dbg !50

bb1.i.8:                                          ; preds = %bb1.i.7
  %_221.i.ptr.8 = getelementptr inbounds nuw i8, ptr %samples.0, i64 64, !dbg !66
  %ptr.val.i.8 = load double, ptr %_221.i.ptr.8, align 8, !dbg !50, !noalias !58, !noundef !26
  %_0.sroa.0.0.off0.i.i.8 = tail call noundef i1 @llvm.is.fpclass.f64(double %ptr.val.i.8, /* (nan inf zero nsub nnorm) */ i32 639), !dbg !61
  br i1 %_0.sroa.0.0.off0.i.i.8, label %bb6, label %bb1.i.9, !dbg !50

bb1.i.9:                                          ; preds = %bb1.i.8
  %_221.i.ptr.9 = getelementptr inbounds nuw i8, ptr %samples.0, i64 72, !dbg !66
  %ptr.val.i.9 = load double, ptr %_221.i.ptr.9, align 8, !dbg !50, !noalias !58, !noundef !26
  %_0.sroa.0.0.off0.i.i.9 = tail call noundef i1 @llvm.is.fpclass.f64(double %ptr.val.i.9, /* (nan inf zero nsub nnorm) */ i32 639), !dbg !61
  br i1 %_0.sroa.0.0.off0.i.i.9, label %bb6, label %bb1.i.10, !dbg !50

bb1.i.10:                                         ; preds = %bb1.i.9
  %_221.i.ptr.10 = getelementptr inbounds nuw i8, ptr %samples.0, i64 80, !dbg !66
  %ptr.val.i.10 = load double, ptr %_221.i.ptr.10, align 8, !dbg !50, !noalias !58, !noundef !26
  %_0.sroa.0.0.off0.i.i.10 = tail call noundef i1 @llvm.is.fpclass.f64(double %ptr.val.i.10, /* (nan inf zero nsub nnorm) */ i32 639), !dbg !61
  br i1 %_0.sroa.0.0.off0.i.i.10, label %bb6, label %bb1.i.11, !dbg !50

bb1.i.11:                                         ; preds = %bb1.i.10
  %_221.i.ptr.11 = getelementptr inbounds nuw i8, ptr %samples.0, i64 88, !dbg !66
  %ptr.val.i.11 = load double, ptr %_221.i.ptr.11, align 8, !dbg !50, !noalias !58, !noundef !26
  %_0.sroa.0.0.off0.i.i.11 = tail call noundef i1 @llvm.is.fpclass.f64(double %ptr.val.i.11, /* (nan inf zero nsub nnorm) */ i32 639), !dbg !61
  br i1 %_0.sroa.0.0.off0.i.i.11, label %bb6, label %bb1.i.12, !dbg !50

bb1.i.12:                                         ; preds = %bb1.i.11
  %_221.i.ptr.12 = getelementptr inbounds nuw i8, ptr %samples.0, i64 96, !dbg !66
  %ptr.val.i.12 = load double, ptr %_221.i.ptr.12, align 8, !dbg !50, !noalias !58, !noundef !26
  %_0.sroa.0.0.off0.i.i.12 = tail call noundef i1 @llvm.is.fpclass.f64(double %ptr.val.i.12, /* (nan inf zero nsub nnorm) */ i32 639), !dbg !61
  br i1 %_0.sroa.0.0.off0.i.i.12, label %bb6, label %bb1.i.13, !dbg !50

bb1.i.13:                                         ; preds = %bb1.i.12
  %_221.i.ptr.13 = getelementptr inbounds nuw i8, ptr %samples.0, i64 104, !dbg !66
  %ptr.val.i.13 = load double, ptr %_221.i.ptr.13, align 8, !dbg !50, !noalias !58, !noundef !26
  %_0.sroa.0.0.off0.i.i.13 = tail call noundef i1 @llvm.is.fpclass.f64(double %ptr.val.i.13, /* (nan inf zero nsub nnorm) */ i32 639), !dbg !61
  br i1 %_0.sroa.0.0.off0.i.i.13, label %bb6, label %bb1.i.14, !dbg !50

bb1.i.14:                                         ; preds = %bb1.i.13
  %_221.i.ptr.14 = getelementptr inbounds nuw i8, ptr %samples.0, i64 112, !dbg !66
  %ptr.val.i.14 = load double, ptr %_221.i.ptr.14, align 8, !dbg !50, !noalias !58, !noundef !26
  %_0.sroa.0.0.off0.i.i.14 = tail call noundef i1 @llvm.is.fpclass.f64(double %ptr.val.i.14, /* (nan inf zero nsub nnorm) */ i32 639), !dbg !61
  br i1 %_0.sroa.0.0.off0.i.i.14, label %bb6, label %bb1.i.15, !dbg !50

bb1.i.15:                                         ; preds = %bb1.i.14
  %_221.i.ptr.15 = getelementptr inbounds nuw i8, ptr %samples.0, i64 120, !dbg !66
  %ptr.val.i.15 = load double, ptr %_221.i.ptr.15, align 8, !dbg !50, !noalias !58, !noundef !26
  %_0.sroa.0.0.off0.i.i.15 = tail call noundef i1 @llvm.is.fpclass.f64(double %ptr.val.i.15, /* (nan inf zero nsub nnorm) */ i32 639), !dbg !61
  br i1 %_0.sroa.0.0.off0.i.i.15, label %bb6, label %bb1.i.16, !dbg !50

bb1.i.16:                                         ; preds = %bb1.i.15
  %_221.i.ptr.16 = getelementptr inbounds nuw i8, ptr %samples.0, i64 128, !dbg !66
  %ptr.val.i.16 = load double, ptr %_221.i.ptr.16, align 8, !dbg !50, !noalias !58, !noundef !26
  %_0.sroa.0.0.off0.i.i.16 = tail call noundef i1 @llvm.is.fpclass.f64(double %ptr.val.i.16, /* (nan inf zero nsub nnorm) */ i32 639), !dbg !61
  br i1 %_0.sroa.0.0.off0.i.i.16, label %bb6, label %bb1.i.17, !dbg !50

bb1.i.17:                                         ; preds = %bb1.i.16
  %_221.i.ptr.17 = getelementptr inbounds nuw i8, ptr %samples.0, i64 136, !dbg !66
  %ptr.val.i.17 = load double, ptr %_221.i.ptr.17, align 8, !dbg !50, !noalias !58, !noundef !26
  %_0.sroa.0.0.off0.i.i.17 = tail call noundef i1 @llvm.is.fpclass.f64(double %ptr.val.i.17, /* (nan inf zero nsub nnorm) */ i32 639), !dbg !61
  br i1 %_0.sroa.0.0.off0.i.i.17, label %bb6, label %bb1.i.18, !dbg !50

bb1.i.18:                                         ; preds = %bb1.i.17
  %_221.i.ptr.18 = getelementptr inbounds nuw i8, ptr %samples.0, i64 144, !dbg !66
  %ptr.val.i.18 = load double, ptr %_221.i.ptr.18, align 8, !dbg !50, !noalias !58, !noundef !26
  %_0.sroa.0.0.off0.i.i.18 = tail call noundef i1 @llvm.is.fpclass.f64(double %ptr.val.i.18, /* (nan inf zero nsub nnorm) */ i32 639), !dbg !61
  br i1 %_0.sroa.0.0.off0.i.i.18, label %bb6, label %bb1.i.19, !dbg !50

bb1.i.19:                                         ; preds = %bb1.i.18
  %_221.i.ptr.19 = getelementptr inbounds nuw i8, ptr %samples.0, i64 152, !dbg !66
  %ptr.val.i.19 = load double, ptr %_221.i.ptr.19, align 8, !dbg !50, !noalias !58, !noundef !26
  %_0.sroa.0.0.off0.i.i.19 = tail call noundef i1 @llvm.is.fpclass.f64(double %ptr.val.i.19, /* (nan inf zero nsub nnorm) */ i32 639), !dbg !61
  br i1 %_0.sroa.0.0.off0.i.i.19, label %bb6, label %bb1.i.20, !dbg !50

bb1.i.20:                                         ; preds = %bb1.i.19
  %_221.i.ptr.20 = getelementptr inbounds nuw i8, ptr %samples.0, i64 160, !dbg !66
  %ptr.val.i.20 = load double, ptr %_221.i.ptr.20, align 8, !dbg !50, !noalias !58, !noundef !26
  %_0.sroa.0.0.off0.i.i.20 = tail call noundef i1 @llvm.is.fpclass.f64(double %ptr.val.i.20, /* (nan inf zero nsub nnorm) */ i32 639), !dbg !61
  %spec.select = select i1 %_0.sroa.0.0.off0.i.i.20, ptr @alloc_72ddc97835b37bfd8fea21ecd4453ca4, ptr null, !dbg !50
  br label %bb6, !dbg !50

bb6:                                              ; preds = %bb1.i.20, %bb1.i.19, %bb1.i.18, %bb1.i.17, %bb1.i.16, %bb1.i.15, %bb1.i.14, %bb1.i.13, %bb1.i.12, %bb1.i.11, %bb1.i.10, %bb1.i.9, %bb1.i.8, %bb1.i.7, %bb1.i.6, %bb1.i.5, %bb1.i.4, %bb1.i.3, %bb1.i.2, %bb1.i.1, %bb1.i.preheader, %start
  %_0.sroa.4.0 = phi i64 [ 32, %start ], [ 40, %bb1.i.preheader ], [ 40, %bb1.i.20 ], [ 40, %bb1.i.19 ], [ 40, %bb1.i.18 ], [ 40, %bb1.i.17 ], [ 40, %bb1.i.16 ], [ 40, %bb1.i.15 ], [ 40, %bb1.i.14 ], [ 40, %bb1.i.13 ], [ 40, %bb1.i.12 ], [ 40, %bb1.i.11 ], [ 40, %bb1.i.10 ], [ 40, %bb1.i.9 ], [ 40, %bb1.i.8 ], [ 40, %bb1.i.7 ], [ 40, %bb1.i.6 ], [ 40, %bb1.i.5 ], [ 40, %bb1.i.4 ], [ 40, %bb1.i.3 ], [ 40, %bb1.i.2 ], [ 40, %bb1.i.1 ], !dbg !77
  %_0.sroa.0.0 = phi ptr [ @alloc_b9a397bd223322fcb45d21070930734e, %start ], [ @alloc_72ddc97835b37bfd8fea21ecd4453ca4, %bb1.i.preheader ], [ %spec.select, %bb1.i.20 ], [ @alloc_72ddc97835b37bfd8fea21ecd4453ca4, %bb1.i.19 ], [ @alloc_72ddc97835b37bfd8fea21ecd4453ca4, %bb1.i.18 ], [ @alloc_72ddc97835b37bfd8fea21ecd4453ca4, %bb1.i.17 ], [ @alloc_72ddc97835b37bfd8fea21ecd4453ca4, %bb1.i.16 ], [ @alloc_72ddc97835b37bfd8fea21ecd4453ca4, %bb1.i.15 ], [ @alloc_72ddc97835b37bfd8fea21ecd4453ca4, %bb1.i.14 ], [ @alloc_72ddc97835b37bfd8fea21ecd4453ca4, %bb1.i.13 ], [ @alloc_72ddc97835b37bfd8fea21ecd4453ca4, %bb1.i.12 ], [ @alloc_72ddc97835b37bfd8fea21ecd4453ca4, %bb1.i.11 ], [ @alloc_72ddc97835b37bfd8fea21ecd4453ca4, %bb1.i.10 ], [ @alloc_72ddc97835b37bfd8fea21ecd4453ca4, %bb1.i.9 ], [ @alloc_72ddc97835b37bfd8fea21ecd4453ca4, %bb1.i.8 ], [ @alloc_72ddc97835b37bfd8fea21ecd4453ca4, %bb1.i.7 ], [ @alloc_72ddc97835b37bfd8fea21ecd4453ca4, %bb1.i.6 ], [ @alloc_72ddc97835b37bfd8fea21ecd4453ca4, %bb1.i.5 ], [ @alloc_72ddc97835b37bfd8fea21ecd4453ca4, %bb1.i.4 ], [ @alloc_72ddc97835b37bfd8fea21ecd4453ca4, %bb1.i.3 ], [ @alloc_72ddc97835b37bfd8fea21ecd4453ca4, %bb1.i.2 ], [ @alloc_72ddc97835b37bfd8fea21ecd4453ca4, %bb1.i.1 ], !dbg !77
  %1 = insertvalue { ptr, i64 } poison, ptr %_0.sroa.0.0, 0, !dbg !78
  %2 = insertvalue { ptr, i64 } %1, i64 %_0.sroa.4.0, 1, !dbg !78
  ret { ptr, i64 } %2, !dbg !78
}

; evidence_lab::mix
; Function Attrs: noinline nounwind uwtable
define noundef i64 @_RNvCsfFAnx7WYh7o_12evidence_lab3mix(i64 noundef %value) unnamed_addr #2 personality ptr @rust_eh_personality !dbg !79 !guid !80 {
start:
  %_4 = alloca [8 x i8], align 8
  call void @llvm.lifetime.start.p0(ptr nonnull %_4), !dbg !81
  store i64 %value, ptr %_4, align 8, !dbg !82
  call void asm sideeffect "", "r,~{memory}"(ptr nonnull %_4) #16, !dbg !82, !srcloc !86
  %0 = load i64, ptr %_4, align 8, !dbg !87, !noundef !26
  %_0.i = call noundef i64 @llvm.fshl.i64(i64 %0, i64 %0, i64 9), !dbg !93
  call void @llvm.lifetime.end.p0(ptr nonnull %_4), !dbg !98
  %_2 = mul i64 %_0.i, -7046029254386353131, !dbg !99
  %_0 = add i64 %_2, 17, !dbg !102
  ret i64 %_0, !dbg !105
}

; evidence_lab::report
; Function Attrs: uwtable
define void @_RNvCsfFAnx7WYh7o_12evidence_lab6report(ptr noalias nofree noundef nonnull readonly captures(address, read_provenance) %0, i64 noundef %1, ptr noalias nofree noundef nonnull readonly align 8 captures(none) %samples.0, i64 noundef range(i64 0, 1152921504606846976) %samples.1) unnamed_addr #0 personality ptr @rust_eh_personality !dbg !106 !guid !107 {
start:
  %compare.i = alloca [0 x i8], align 1
  %is_less.i.i = alloca [8 x i8], align 8
  %e.i = alloca [16 x i8], align 8
  %args = alloca [96 x i8], align 8
  %_28 = alloca [8 x i8], align 8
  %_25 = alloca [8 x i8], align 8
  %_23 = alloca [8 x i8], align 8
  %sd = alloca [8 x i8], align 8
  %mean = alloca [8 x i8], align 8
  %case = alloca [16 x i8], align 8
  store ptr %0, ptr %case, align 8
  %2 = getelementptr inbounds nuw i8, ptr %case, i64 8
  store i64 %1, ptr %2, align 8
; call evidence_lab::complete_samples
  %3 = tail call { ptr, i64 } @_RNvCsfFAnx7WYh7o_12evidence_lab16complete_samples(ptr noalias nofree noundef nonnull readonly align 8 captures(address, read_provenance) %samples.0, i64 noundef %samples.1), !dbg !108
  %_4.0 = extractvalue { ptr, i64 } %3, 0, !dbg !108
  %.not.i = icmp eq ptr %_4.0, null, !dbg !109
  br i1 %.not.i, label %_RNvMNtCsjIpoRzUjyHQ_4core6resultINtB2_6ResultuReE6expectCsfFAnx7WYh7o_12evidence_lab.exit, label %bb2.i, !dbg !115, !prof !116

bb2.i:                                            ; preds = %start
  %_4.1 = extractvalue { ptr, i64 } %3, 1, !dbg !108
  call void @llvm.lifetime.start.p0(ptr nonnull %e.i), !dbg !117, !noalias !118
  store ptr %_4.0, ptr %e.i, align 8, !dbg !117, !noalias !118, !captures !121
  %4 = getelementptr inbounds nuw i8, ptr %e.i, i64 8, !dbg !117
  store i64 %_4.1, ptr %4, align 8, !dbg !117, !noalias !118
; call core::result::unwrap_failed
  call void @_RNvNtCsjIpoRzUjyHQ_4core6result13unwrap_failed(ptr noalias nofree noundef nonnull readonly captures(address, read_provenance) @alloc_ea036d046f53e77e29f5a358dcf53fd4, i64 noundef 18, ptr noundef nonnull %e.i, ptr noalias nofree noundef readonly align 8 captures(address, read_provenance) dereferenceable(32) @vtable.0, ptr noalias nofree noundef readonly align 8 captures(address, read_provenance) dereferenceable(24) @alloc_629ad608d4fe57cf57ef053920aa8d17) #15, !dbg !122
  unreachable, !dbg !122

_RNvMNtCsjIpoRzUjyHQ_4core6resultINtB2_6ResultuReE6expectCsfFAnx7WYh7o_12evidence_lab.exit: ; preds = %start
  call void @llvm.lifetime.start.p0(ptr nonnull %mean), !dbg !124
  %5 = icmp eq i64 %samples.1, 0, !dbg !125
  br i1 %5, label %_RINvXs2J_NtNtCsjIpoRzUjyHQ_4core5slice4iterINtB7_4IterdENtNtNtNtBb_4iter6traits8iterator8Iterator4folddNCINvXs28_NtBW_5accumdINtB1N_3SumRdE3sumBF_E0ECsfFAnx7WYh7o_12evidence_lab.exit.thread, label %bb8.i.preheader, !dbg !144

bb8.i.preheader:                                  ; preds = %_RNvMNtCsjIpoRzUjyHQ_4core6resultINtB2_6ResultuReE6expectCsfFAnx7WYh7o_12evidence_lab.exit
  %min.iters.check = icmp samesign ult i64 %samples.1, 8, !dbg !145
  br i1 %min.iters.check, label %bb8.i.preheader41, label %vector.ph, !dbg !145

vector.ph:                                        ; preds = %bb8.i.preheader
  %n.vec = and i64 %samples.1, 1152921504606846968
  br label %vector.body, !dbg !145

vector.body:                                      ; preds = %vector.body, %vector.ph
  %index = phi i64 [ 0, %vector.ph ], [ %index.next, %vector.body ], !dbg !149
  %vec.phi = phi double [ -0.000000e+00, %vector.ph ], [ %13, %vector.body ]
  %6 = getelementptr inbounds nuw [8 x i8], ptr %samples.0, i64 %index, !dbg !150
  %7 = getelementptr inbounds nuw i8, ptr %6, i64 16, !dbg !154
  %8 = getelementptr inbounds nuw i8, ptr %6, i64 32, !dbg !154
  %9 = getelementptr inbounds nuw i8, ptr %6, i64 48, !dbg !154
  %wide.load = load <2 x double>, ptr %6, align 8, !dbg !154
  %wide.load21 = load <2 x double>, ptr %7, align 8, !dbg !154
  %wide.load22 = load <2 x double>, ptr %8, align 8, !dbg !154
  %wide.load23 = load <2 x double>, ptr %9, align 8, !dbg !154
  %10 = tail call double @llvm.vector.reduce.fadd.v2f64(double %vec.phi, <2 x double> %wide.load), !dbg !155
  %11 = tail call double @llvm.vector.reduce.fadd.v2f64(double %10, <2 x double> %wide.load21), !dbg !155
  %12 = tail call double @llvm.vector.reduce.fadd.v2f64(double %11, <2 x double> %wide.load22), !dbg !155
  %13 = tail call double @llvm.vector.reduce.fadd.v2f64(double %12, <2 x double> %wide.load23), !dbg !155
  %index.next = add nuw i64 %index, 8, !dbg !149
  %14 = icmp eq i64 %index.next, %n.vec, !dbg !145
  br i1 %14, label %middle.block, label %vector.body, !dbg !145, !llvm.loop !169

middle.block:                                     ; preds = %vector.body
  %cmp.n = icmp eq i64 %samples.1, %n.vec, !dbg !145
  br i1 %cmp.n, label %bb5.i1, label %bb8.i.preheader41, !dbg !145

bb8.i.preheader41:                                ; preds = %bb8.i.preheader, %middle.block
  %i.sroa.0.0.i.ph = phi i64 [ 0, %bb8.i.preheader ], [ %n.vec, %middle.block ]
  %acc.sroa.0.0.i.ph = phi double [ -0.000000e+00, %bb8.i.preheader ], [ %13, %middle.block ]
  br label %bb8.i, !dbg !145

_RINvXs2J_NtNtCsjIpoRzUjyHQ_4core5slice4iterINtB7_4IterdENtNtNtNtBb_4iter6traits8iterator8Iterator4folddNCINvXs28_NtBW_5accumdINtB1N_3SumRdE3sumBF_E0ECsfFAnx7WYh7o_12evidence_lab.exit.thread: ; preds = %_RNvMNtCsjIpoRzUjyHQ_4core6resultINtB2_6ResultuReE6expectCsfFAnx7WYh7o_12evidence_lab.exit
  store double +qnan, ptr %mean, align 8, !dbg !172
  call void @llvm.lifetime.start.p0(ptr nonnull %sd), !dbg !173
  br label %_RINvXs2J_NtNtCsjIpoRzUjyHQ_4core5slice4iterINtB7_4IterdENtNtNtNtBb_4iter6traits8iterator8Iterator4folddNCINvNtNtBY_8adapters3map8map_foldRdddNCNvCsfFAnx7WYh7o_12evidence_lab6report0NCINvXs26_NtBW_5accumdNtB33_3Sum3sumINtB1I_3MapBF_B2f_EE0E0EB2j_.exit, !dbg !175

bb8.i:                                            ; preds = %bb8.i.preheader41, %bb8.i
  %i.sroa.0.0.i = phi i64 [ %_27.i, %bb8.i ], [ %i.sroa.0.0.i.ph, %bb8.i.preheader41 ], !dbg !149
  %acc.sroa.0.0.i = phi double [ %_0.i.i, %bb8.i ], [ %acc.sroa.0.0.i.ph, %bb8.i.preheader41 ], !dbg !191
  %_45.i = getelementptr inbounds nuw [8 x i8], ptr %samples.0, i64 %i.sroa.0.0.i, !dbg !150
  %_45.val.i = load double, ptr %_45.i, align 8, !dbg !154, !noundef !26
  %_0.i.i = fadd double %acc.sroa.0.0.i, %_45.val.i, !dbg !155
  %_27.i = add nuw nsw i64 %i.sroa.0.0.i, 1, !dbg !192
  %_28.i = icmp eq i64 %_27.i, %samples.1, !dbg !145
  br i1 %_28.i, label %bb5.i1, label %bb8.i, !dbg !145, !llvm.loop !196

bb5.i1:                                           ; preds = %bb8.i, %middle.block
  %_0.i.i.lcssa = phi double [ %13, %middle.block ], [ %_0.i.i, %bb8.i ], !dbg !155
  %_8 = uitofp nneg i64 %samples.1 to double, !dbg !197
  %15 = fdiv double %_0.i.i.lcssa, %_8, !dbg !172
  store double %15, ptr %mean, align 8, !dbg !172
  call void @llvm.lifetime.start.p0(ptr nonnull %sd), !dbg !173
  %min.iters.check25 = icmp samesign ult i64 %samples.1, 8, !dbg !198
  br i1 %min.iters.check25, label %bb8.i2.preheader, label %vector.ph26, !dbg !198

vector.ph26:                                      ; preds = %bb5.i1
  %n.vec28 = and i64 %samples.1, 1152921504606846968
  %broadcast.splatinsert = insertelement <2 x double> poison, double %15, i64 0
  %broadcast.splat = shufflevector <2 x double> %broadcast.splatinsert, <2 x double> poison, <2 x i32> zeroinitializer
  br label %vector.body29, !dbg !198

vector.body29:                                    ; preds = %vector.body29, %vector.ph26
  %index30 = phi i64 [ 0, %vector.ph26 ], [ %index.next36, %vector.body29 ], !dbg !202
  %vec.phi31 = phi double [ -0.000000e+00, %vector.ph26 ], [ %31, %vector.body29 ]
  %16 = getelementptr inbounds nuw [8 x i8], ptr %samples.0, i64 %index30, !dbg !203
  %17 = getelementptr inbounds nuw i8, ptr %16, i64 16, !dbg !207
  %18 = getelementptr inbounds nuw i8, ptr %16, i64 32, !dbg !207
  %19 = getelementptr inbounds nuw i8, ptr %16, i64 48, !dbg !207
  %wide.load32 = load <2 x double>, ptr %16, align 8, !dbg !207, !noalias !208
  %wide.load33 = load <2 x double>, ptr %17, align 8, !dbg !207, !noalias !208
  %wide.load34 = load <2 x double>, ptr %18, align 8, !dbg !207, !noalias !208
  %wide.load35 = load <2 x double>, ptr %19, align 8, !dbg !207, !noalias !208
  %20 = fsub <2 x double> %wide.load32, %broadcast.splat, !dbg !211
  %21 = fsub <2 x double> %wide.load33, %broadcast.splat, !dbg !211
  %22 = fsub <2 x double> %wide.load34, %broadcast.splat, !dbg !211
  %23 = fsub <2 x double> %wide.load35, %broadcast.splat, !dbg !211
  %24 = fmul <2 x double> %20, %20, !dbg !224
  %25 = fmul <2 x double> %21, %21, !dbg !224
  %26 = fmul <2 x double> %22, %22, !dbg !224
  %27 = fmul <2 x double> %23, %23, !dbg !224
  %28 = tail call double @llvm.vector.reduce.fadd.v2f64(double %vec.phi31, <2 x double> %24), !dbg !229
  %29 = tail call double @llvm.vector.reduce.fadd.v2f64(double %28, <2 x double> %25), !dbg !229
  %30 = tail call double @llvm.vector.reduce.fadd.v2f64(double %29, <2 x double> %26), !dbg !229
  %31 = tail call double @llvm.vector.reduce.fadd.v2f64(double %30, <2 x double> %27), !dbg !229
  %index.next36 = add nuw i64 %index30, 8, !dbg !202
  %32 = icmp eq i64 %index.next36, %n.vec28, !dbg !233
  br i1 %32, label %middle.block37, label %vector.body29, !dbg !233, !llvm.loop !234

middle.block37:                                   ; preds = %vector.body29
  %cmp.n38 = icmp eq i64 %samples.1, %n.vec28, !dbg !233
  br i1 %cmp.n38, label %_RINvXs2J_NtNtCsjIpoRzUjyHQ_4core5slice4iterINtB7_4IterdENtNtNtNtBb_4iter6traits8iterator8Iterator4folddNCINvNtNtBY_8adapters3map8map_foldRdddNCNvCsfFAnx7WYh7o_12evidence_lab6report0NCINvXs26_NtBW_5accumdNtB33_3Sum3sumINtB1I_3MapBF_B2f_EE0E0EB2j_.exit, label %bb8.i2.preheader, !dbg !233

bb8.i2.preheader:                                 ; preds = %bb5.i1, %middle.block37
  %i.sroa.0.0.i3.ph = phi i64 [ 0, %bb5.i1 ], [ %n.vec28, %middle.block37 ]
  %acc.sroa.0.0.i4.ph = phi double [ -0.000000e+00, %bb5.i1 ], [ %31, %middle.block37 ]
  br label %bb8.i2, !dbg !233

bb8.i2:                                           ; preds = %bb8.i2.preheader, %bb8.i2
  %i.sroa.0.0.i3 = phi i64 [ %_27.i7, %bb8.i2 ], [ %i.sroa.0.0.i3.ph, %bb8.i2.preheader ], !dbg !202
  %acc.sroa.0.0.i4 = phi double [ %_0.i1.i.i, %bb8.i2 ], [ %acc.sroa.0.0.i4.ph, %bb8.i2.preheader ], !dbg !235
  %_45.i5 = getelementptr inbounds nuw [8 x i8], ptr %samples.0, i64 %i.sroa.0.0.i3, !dbg !203
  %_45.val.i6 = load double, ptr %_45.i5, align 8, !dbg !207, !noalias !208, !noundef !26
  %_3.i.i.i = fsub double %_45.val.i6, %15, !dbg !211
  %_0.i.i.i = fmul double %_3.i.i.i, %_3.i.i.i, !dbg !224
  %_0.i1.i.i = fadd double %acc.sroa.0.0.i4, %_0.i.i.i, !dbg !229
  %_27.i7 = add nuw nsw i64 %i.sroa.0.0.i3, 1, !dbg !236
  %_28.i8 = icmp eq i64 %_27.i7, %samples.1, !dbg !233
  br i1 %_28.i8, label %_RINvXs2J_NtNtCsjIpoRzUjyHQ_4core5slice4iterINtB7_4IterdENtNtNtNtBb_4iter6traits8iterator8Iterator4folddNCINvNtNtBY_8adapters3map8map_foldRdddNCNvCsfFAnx7WYh7o_12evidence_lab6report0NCINvXs26_NtBW_5accumdNtB33_3Sum3sumINtB1I_3MapBF_B2f_EE0E0EB2j_.exit, label %bb8.i2, !dbg !233, !llvm.loop !239

_RINvXs2J_NtNtCsjIpoRzUjyHQ_4core5slice4iterINtB7_4IterdENtNtNtNtBb_4iter6traits8iterator8Iterator4folddNCINvNtNtBY_8adapters3map8map_foldRdddNCNvCsfFAnx7WYh7o_12evidence_lab6report0NCINvXs26_NtBW_5accumdNtB33_3Sum3sumINtB1I_3MapBF_B2f_EE0E0EB2j_.exit: ; preds = %bb8.i2, %middle.block37, %_RINvXs2J_NtNtCsjIpoRzUjyHQ_4core5slice4iterINtB7_4IterdENtNtNtNtBb_4iter6traits8iterator8Iterator4folddNCINvXs28_NtBW_5accumdINtB1N_3SumRdE3sumBF_E0ECsfFAnx7WYh7o_12evidence_lab.exit.thread
  %_0.sroa.0.0.i9 = phi double [ -0.000000e+00, %_RINvXs2J_NtNtCsjIpoRzUjyHQ_4core5slice4iterINtB7_4IterdENtNtNtNtBb_4iter6traits8iterator8Iterator4folddNCINvXs28_NtBW_5accumdINtB1N_3SumRdE3sumBF_E0ECsfFAnx7WYh7o_12evidence_lab.exit.thread ], [ %31, %middle.block37 ], [ %_0.i1.i.i, %bb8.i2 ], !dbg !235
  %_16 = add nsw i64 %samples.1, -1, !dbg !240
  %_15 = uitofp i64 %_16 to double, !dbg !240
  %_10 = fdiv double %_0.sroa.0.0.i9, %_15, !dbg !241
  %33 = tail call double @llvm.sqrt.f64(double %_10), !dbg !242
  store double %33, ptr %sd, align 8, !dbg !242
  %34 = shl nuw nsw i64 %samples.1, 3, !dbg !247
  br i1 %5, label %bb14.thread, label %bb3.i, !dbg !290

bb3.i:                                            ; preds = %_RINvXs2J_NtNtCsjIpoRzUjyHQ_4core5slice4iterINtB7_4IterdENtNtNtNtBb_4iter6traits8iterator8Iterator4folddNCINvNtNtBY_8adapters3map8map_foldRdddNCNvCsfFAnx7WYh7o_12evidence_lab6report0NCINvXs26_NtBW_5accumdNtB33_3Sum3sumINtB1I_3MapBF_B2f_EE0E0EB2j_.exit
; call __rustc::__rust_no_alloc_shim_is_unstable_v2
  tail call void @_RNvCsdtSMxSA38aw_7___rustc35___rust_no_alloc_shim_is_unstable_v2() #16, !dbg !292, !noalias !293
; call __rustc::__rust_alloc
  %35 = tail call noundef align 8 ptr @_RNvCsdtSMxSA38aw_7___rustc12___rust_alloc(i64 noundef range(i64 1, -9223372036854775808) %34, i64 noundef range(i64 1, -9223372036854775807) 8) #16, !dbg !296, !noalias !293
  %36 = icmp eq ptr %35, null, !dbg !310
  br i1 %36, label %bb17, label %bb14, !dbg !312

bb17:                                             ; preds = %bb3.i
; call alloc::raw_vec::handle_error
  tail call void @_RNvNtCs6zY7rJBZy9D_5alloc7raw_vec12handle_error(i64 noundef 8, i64 %34) #17, !dbg !313
  unreachable, !dbg !313

bb14.thread:                                      ; preds = %_RINvXs2J_NtNtCsjIpoRzUjyHQ_4core5slice4iterINtB7_4IterdENtNtNtNtBb_4iter6traits8iterator8Iterator4folddNCINvNtNtBY_8adapters3map8map_foldRdddNCNvCsfFAnx7WYh7o_12evidence_lab6report0NCINvXs26_NtBW_5accumdNtB33_3Sum3sumINtB1I_3MapBF_B2f_EE0E0EB2j_.exit
  call void @llvm.lifetime.start.p0(ptr nonnull %is_less.i.i), !noalias !315
  br label %bb3, !dbg !318

bb14:                                             ; preds = %bb3.i
  tail call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 8 %35, ptr nonnull align 8 %samples.0, i64 %34, i1 false), !dbg !332
  call void @llvm.lifetime.start.p0(ptr nonnull %is_less.i.i), !noalias !342
  store ptr %compare.i, ptr %is_less.i.i, align 8, !noalias !344
  %b.i.i = icmp eq i64 %samples.1, 1, !dbg !348
  br i1 %b.i.i, label %bb3, label %bb9.i.i, !dbg !318, !prof !349

bb9.i.i:                                          ; preds = %bb14
  %b1.i.i = icmp samesign ult i64 %samples.1, 21, !dbg !350
  br i1 %b1.i.i, label %bb11.i.i, label %bb12.i.i, !dbg !351, !prof !116

bb12.i.i:                                         ; preds = %bb9.i.i
; invoke core::slice::sort::stable::driftsort_main::<f64, <[f64]>::sort_by<<f64>::total_cmp>::{closure#0}, alloc::vec::Vec<f64>>
  invoke void @_RINvNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6stable14driftsort_maindNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtB8_3f64d9total_cmpE0INtNtB18_3vec3VecdEECsfFAnx7WYh7o_12evidence_lab(ptr noalias nofree noundef nonnull align 8 %35, i64 noundef range(i64 0, 1152921504606846976) %samples.1, ptr noalias nofree noundef nonnull align 8 dereferenceable(8) %is_less.i.i) #18
          to label %bb3 unwind label %cleanup.thread, !dbg !353

cleanup.thread:                                   ; preds = %bb12.i.i
  %37 = landingpad { ptr, i32 }
          cleanup
  br label %bb2.i.i.i, !dbg !354

bb11.i.i:                                         ; preds = %bb9.i.i
; call core::slice::sort::shared::smallsort::insertion_sort_shift_left::<f64, <[f64]>::sort_by<<f64>::total_cmp>::{closure#0}>
  call void @_RINvNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6shared9smallsort25insertion_sort_shift_leftdNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtBa_3f64d9total_cmpE0ECsfFAnx7WYh7o_12evidence_lab(ptr noalias nofree noundef nonnull align 8 %35, i64 noundef range(i64 0, 1152921504606846976) %samples.1, i64 noundef 1, ptr noalias nofree noundef nonnull align 8 dereferenceable(8) %is_less.i.i), !dbg !367
  br label %bb3, !dbg !367

cleanup:                                          ; preds = %bb5, %panic.i19.invoke
  %38 = landingpad { ptr, i32 }
          cleanup
  %39 = icmp eq i64 %_66.sroa.4.017, 0, !dbg !354
  br i1 %39, label %common.resume, label %bb2.i.i.i, !dbg !354

bb2.i.i.i:                                        ; preds = %cleanup.thread, %cleanup
  %40 = phi { ptr, i32 } [ %37, %cleanup.thread ], [ %38, %cleanup ]
  %_66.sroa.4.01620 = phi i64 [ %samples.1, %cleanup.thread ], [ %_66.sroa.4.017, %cleanup ]
  %41 = phi ptr [ %35, %cleanup.thread ], [ %42, %cleanup ]
  call void @llvm.assume(i1 true) [ "nonnull"(ptr %41) ]
  %alloc_size.i.i.i.i = shl nuw nsw i64 %_66.sroa.4.01620, 3, !dbg !368
; call __rustc::__rust_dealloc
  call void @_RNvCsdtSMxSA38aw_7___rustc14___rust_dealloc(ptr noundef nonnull %41, i64 noundef %alloc_size.i.i.i.i, i64 noundef range(i64 1, -9223372036854775807) 8) #16, !dbg !371, !noalias !380
  br label %common.resume, !dbg !383

bb3:                                              ; preds = %bb11.i.i, %bb12.i.i, %bb14, %bb14.thread
  %42 = phi ptr [ inttoptr (i64 8 to ptr), %bb14.thread ], [ %35, %bb14 ], [ %35, %bb11.i.i ], [ %35, %bb12.i.i ]
  %_66.sroa.4.017 = phi i64 [ 0, %bb14.thread ], [ 1, %bb14 ], [ %samples.1, %bb11.i.i ], [ %samples.1, %bb12.i.i ]
  call void @llvm.lifetime.end.p0(ptr nonnull %is_less.i.i), !dbg !384, !noalias !342
  call void @llvm.lifetime.start.p0(ptr nonnull %_23), !dbg !385
  store i64 %samples.1, ptr %_23, align 8, !dbg !385
  call void @llvm.lifetime.start.p0(ptr nonnull %_25), !dbg !386
  %_6.i = uitofp nneg i64 %samples.1 to double, !dbg !387
  %_5.i = fmul nnan double %_6.i, 5.000000e-01, !dbg !389
  %_4.i = call double @llvm.ceil.f64(double %_5.i), !dbg !390
  %rank.i = call i64 @llvm.fptoui.sat.i64.f64(double %_4.i), !dbg !389
  %_8.i = call i64 @llvm.usub.sat.i64(i64 %rank.i, i64 1), !dbg !393
  %_10.i = icmp ult i64 %_8.i, %samples.1, !dbg !394
  br i1 %_10.i, label %bb4, label %panic.i19.invoke, !dbg !394

bb4:                                              ; preds = %bb3
  %43 = getelementptr inbounds nuw [8 x i8], ptr %42, i64 %_8.i, !dbg !394
  %_0.i = load double, ptr %43, align 8, !dbg !394, !alias.scope !395, !noundef !26
  store double %_0.i, ptr %_25, align 8, !dbg !386
  call void @llvm.lifetime.start.p0(ptr nonnull %_28), !dbg !398
  %_5.i14 = fmul nnan double %_6.i, f0x3FEFAE147AE147AE, !dbg !399
  %_4.i15 = call double @llvm.ceil.f64(double %_5.i14), !dbg !401
  %rank.i16 = call i64 @llvm.fptoui.sat.i64.f64(double %_4.i15), !dbg !399
  %_8.i17 = call i64 @llvm.usub.sat.i64(i64 %rank.i16, i64 1), !dbg !404
  %_10.i18 = icmp ult i64 %_8.i17, %samples.1, !dbg !405
  br i1 %_10.i18, label %bb5, label %panic.i19.invoke, !dbg !405

panic.i19.invoke:                                 ; preds = %bb4, %bb3
  %44 = phi i64 [ %_8.i, %bb3 ], [ %_8.i17, %bb4 ]
; invoke core::panicking::panic_bounds_check
  invoke void @_RNvNtCsjIpoRzUjyHQ_4core9panicking18panic_bounds_check(i64 noundef %44, i64 noundef range(i64 0, 1152921504606846976) %samples.1, ptr noalias nofree noundef readonly align 8 captures(address, read_provenance) dereferenceable(24) @alloc_08ced1a55cdf80334bb487cb4f86e33b) #15
          to label %panic.i19.cont unwind label %cleanup, !dbg !406

panic.i19.cont:                                   ; preds = %panic.i19.invoke
  unreachable

bb5:                                              ; preds = %bb4
  %45 = getelementptr inbounds nuw [8 x i8], ptr %42, i64 %_8.i17, !dbg !405
  %_0.i21 = load double, ptr %45, align 8, !dbg !405, !alias.scope !408, !noundef !26
  store double %_0.i21, ptr %_28, align 8, !dbg !398
  call void @llvm.lifetime.start.p0(ptr nonnull %args), !dbg !411
  store ptr %case, ptr %args, align 8, !dbg !411
  %_34.sroa.4.0..sroa_idx = getelementptr inbounds nuw i8, ptr %args, i64 8, !dbg !411
  store ptr @_RNvXs1i_NtCsjIpoRzUjyHQ_4core3fmtReNtB6_7Display3fmtCsfFAnx7WYh7o_12evidence_lab, ptr %_34.sroa.4.0..sroa_idx, align 8, !dbg !411
  %46 = getelementptr inbounds nuw i8, ptr %args, i64 16, !dbg !411
  store ptr %_23, ptr %46, align 8, !dbg !411
  %_35.sroa.4.0..sroa_idx = getelementptr inbounds nuw i8, ptr %args, i64 24, !dbg !411
  store ptr @_RNvXsi_NtNtNtCsjIpoRzUjyHQ_4core3fmt3num3impjNtB9_7Display3fmt, ptr %_35.sroa.4.0..sroa_idx, align 8, !dbg !411
  %47 = getelementptr inbounds nuw i8, ptr %args, i64 32, !dbg !411
  store ptr %mean, ptr %47, align 8, !dbg !411
  %_36.sroa.4.0..sroa_idx = getelementptr inbounds nuw i8, ptr %args, i64 40, !dbg !411
  store ptr @_RNvXs7_NtNtCsjIpoRzUjyHQ_4core3fmt5floatdNtB7_7Display3fmt, ptr %_36.sroa.4.0..sroa_idx, align 8, !dbg !411
  %48 = getelementptr inbounds nuw i8, ptr %args, i64 48, !dbg !411
  store ptr %sd, ptr %48, align 8, !dbg !411
  %_37.sroa.4.0..sroa_idx = getelementptr inbounds nuw i8, ptr %args, i64 56, !dbg !411
  store ptr @_RNvXs7_NtNtCsjIpoRzUjyHQ_4core3fmt5floatdNtB7_7Display3fmt, ptr %_37.sroa.4.0..sroa_idx, align 8, !dbg !411
  %49 = getelementptr inbounds nuw i8, ptr %args, i64 64, !dbg !411
  store ptr %_25, ptr %49, align 8, !dbg !411
  %_38.sroa.4.0..sroa_idx = getelementptr inbounds nuw i8, ptr %args, i64 72, !dbg !411
  store ptr @_RNvXs7_NtNtCsjIpoRzUjyHQ_4core3fmt5floatdNtB7_7Display3fmt, ptr %_38.sroa.4.0..sroa_idx, align 8, !dbg !411
  %50 = getelementptr inbounds nuw i8, ptr %args, i64 80, !dbg !411
  store ptr %_28, ptr %50, align 8, !dbg !411
  %_39.sroa.4.0..sroa_idx = getelementptr inbounds nuw i8, ptr %args, i64 88, !dbg !411
  store ptr @_RNvXs7_NtNtCsjIpoRzUjyHQ_4core3fmt5floatdNtB7_7Display3fmt, ptr %_39.sroa.4.0..sroa_idx, align 8, !dbg !411
; invoke std::io::stdio::_print
  invoke void @_RNvNtNtCs1SSuMAdGM58_3std2io5stdio6__print(ptr noundef nonnull @alloc_d0a8d7f7801890de0a5a93e364996e45, ptr noundef nonnull %args)
          to label %bb6 unwind label %cleanup, !dbg !415

bb6:                                              ; preds = %bb5
  call void @llvm.lifetime.end.p0(ptr nonnull %args), !dbg !415
  call void @llvm.lifetime.end.p0(ptr nonnull %_28), !dbg !415
  call void @llvm.lifetime.end.p0(ptr nonnull %_25), !dbg !415
  call void @llvm.lifetime.end.p0(ptr nonnull %_23), !dbg !415
  %51 = icmp eq i64 %_66.sroa.4.017, 0, !dbg !416
  br i1 %51, label %_RNvXs1_NtCs6zY7rJBZy9D_5alloc7raw_vecINtB5_6RawVecdENtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4dropCsfFAnx7WYh7o_12evidence_lab.exit, label %bb2.i.i, !dbg !416

bb2.i.i:                                          ; preds = %bb6
  %alloc_size.i.i.i = shl nuw nsw i64 %_66.sroa.4.017, 3, !dbg !422
; call __rustc::__rust_dealloc
  call void @_RNvCsdtSMxSA38aw_7___rustc14___rust_dealloc(ptr noundef nonnull %42, i64 noundef %alloc_size.i.i.i, i64 noundef range(i64 1, -9223372036854775807) 8) #16, !dbg !424, !noalias !429
  br label %_RNvXs1_NtCs6zY7rJBZy9D_5alloc7raw_vecINtB5_6RawVecdENtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4dropCsfFAnx7WYh7o_12evidence_lab.exit, !dbg !432

_RNvXs1_NtCs6zY7rJBZy9D_5alloc7raw_vecINtB5_6RawVecdENtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4dropCsfFAnx7WYh7o_12evidence_lab.exit: ; preds = %bb6, %bb2.i.i
  call void @llvm.lifetime.end.p0(ptr nonnull %sd), !dbg !433
  call void @llvm.lifetime.end.p0(ptr nonnull %mean), !dbg !434
  ret void, !dbg !435

common.resume:                                    ; preds = %bb2.i.i.i, %cleanup
  %52 = phi { ptr, i32 } [ %40, %bb2.i.i.i ], [ %38, %cleanup ]
  resume { ptr, i32 } %52, !dbg !436
}

; evidence_lab::compute
; Function Attrs: nounwind uwtable
define noundef i64 @_RNvCsfFAnx7WYh7o_12evidence_lab7compute(i64 noundef %count) unnamed_addr #3 !dbg !437 !guid !438 {
start:
  %_33.not = icmp eq i64 %count, 0, !dbg !439
  br i1 %_33.not, label %bb4, label %bb3, !dbg !445

bb4:                                              ; preds = %bb3, %start
  %value.sroa.0.0.lcssa = phi i64 [ 7, %start ], [ %0, %bb3 ], !dbg !457
  ret i64 %value.sroa.0.0.lcssa, !dbg !458

bb3:                                              ; preds = %start, %bb3
  %value.sroa.0.05 = phi i64 [ %0, %bb3 ], [ 7, %start ]
  %iter.sroa.0.04 = phi i64 [ %_4, %bb3 ], [ 0, %start ]
  %_4 = add nuw i64 %iter.sroa.0.04, 1, !dbg !459
; call evidence_lab::mix
  %0 = tail call noundef i64 @_RNvCsfFAnx7WYh7o_12evidence_lab3mix(i64 noundef %value.sroa.0.05) #18, !dbg !466
  %exitcond.not = icmp eq i64 %_4, %count, !dbg !439
  br i1 %exitcond.not, label %bb4, label %bb3, !dbg !445
}

; evidence_lab::observed
; Function Attrs: uwtable
define { i64, i64 } @_RNvCsfFAnx7WYh7o_12evidence_lab8observed(i64 noundef %count, i8 noundef range(i8 0, 3) %mode) unnamed_addr #0 !dbg !467 !guid !468 {
start:
  %_12 = alloca [16 x i8], align 8
  %clock1 = alloca [16 x i8], align 8
  %counter = alloca [8 x i8], align 8
  call void @llvm.lifetime.start.p0(ptr nonnull %counter), !dbg !469
  store i64 0, ptr %counter, align 8, !dbg !470
  %_236.not = icmp eq i64 %count, 0, !dbg !477
  br i1 %_236.not, label %bb7, label %bb6.lr.ph, !dbg !479

bb6.lr.ph:                                        ; preds = %start
  %_8 = icmp eq i8 %mode, 2
  %0 = getelementptr inbounds nuw i8, ptr %clock1, i64 8
  %1 = getelementptr inbounds nuw i8, ptr %_12, i64 8
  br i1 %_8, label %bb6.us, label %bb6

bb6.us:                                           ; preds = %bb6.lr.ph, %bb6.us
  %value.sroa.0.08.us = phi i64 [ %4, %bb6.us ], [ 7, %bb6.lr.ph ]
  %iter.sroa.0.07.us = phi i64 [ %2, %bb6.us ], [ 0, %bb6.lr.ph ]
  %2 = add nuw i64 %iter.sroa.0.07.us, 1, !dbg !488
; call <std::time::Instant>::now
  %3 = call { i64, i32 } @_RNvMNtCs1SSuMAdGM58_3std4timeNtB2_7Instant3now(), !dbg !494
  %_27.0.us = extractvalue { i64, i32 } %3, 0, !dbg !494
  %_27.1.us = extractvalue { i64, i32 } %3, 1, !dbg !494
; call evidence_lab::mix
  %4 = call noundef i64 @_RNvCsfFAnx7WYh7o_12evidence_lab3mix(i64 noundef %value.sroa.0.08.us) #18, !dbg !506
  call void @llvm.lifetime.start.p0(ptr nonnull %clock1), !dbg !508
  store i64 %_27.0.us, ptr %clock1, align 8, !dbg !508
  store i32 %_27.1.us, ptr %0, align 8, !dbg !508
  call void @llvm.lifetime.start.p0(ptr nonnull %_12), !dbg !510
; call <std::time::Instant>::elapsed
  %5 = call { i64, i32 } @_RNvMNtCs1SSuMAdGM58_3std4timeNtB2_7Instant7elapsed(ptr noalias nofree noundef nonnull readonly align 8 captures(address, read_provenance) dereferenceable(16) %clock1), !dbg !511
  %_16.0.us = extractvalue { i64, i32 } %5, 0, !dbg !511
  %_16.1.us = extractvalue { i64, i32 } %5, 1, !dbg !511
  %_28.us = mul i64 %_16.0.us, 1000000000, !dbg !512
  %6 = icmp ult i32 %_16.1.us, 1000000000, !dbg !518
  call void @llvm.assume(i1 %6), !dbg !518
  %_31.us = zext nneg i32 %_16.1.us to i64, !dbg !524
  %_15.us = add i64 %_28.us, %_31.us, !dbg !512
  store i64 %iter.sroa.0.07.us, ptr %_12, align 8, !dbg !525
  store i64 %_15.us, ptr %1, align 8, !dbg !525
  call void asm sideeffect "", "r,~{memory}"(ptr nonnull %_12) #16, !dbg !525, !srcloc !86
  call void @llvm.lifetime.end.p0(ptr nonnull %_12), !dbg !527
  %_18.us = atomicrmw add ptr %counter, i64 1 monotonic, align 8, !dbg !528
  call void @llvm.lifetime.end.p0(ptr nonnull %clock1), !dbg !533
  %exitcond11.not = icmp eq i64 %2, %count, !dbg !477
  br i1 %exitcond11.not, label %bb5, label %bb6.us, !dbg !479

bb7:                                              ; preds = %bb6, %start
  %value.sroa.0.0.lcssa = phi i64 [ 7, %start ], [ %8, %bb6 ], !dbg !534
  %_19 = icmp eq i8 %mode, 1, !dbg !535
  br i1 %_19, label %bb4, label %bb5, !dbg !535

bb6:                                              ; preds = %bb6.lr.ph, %bb6
  %value.sroa.0.08 = phi i64 [ %8, %bb6 ], [ 7, %bb6.lr.ph ]
  %iter.sroa.0.07 = phi i64 [ %7, %bb6 ], [ 0, %bb6.lr.ph ]
  %7 = add nuw i64 %iter.sroa.0.07, 1, !dbg !488
; call evidence_lab::mix
  %8 = tail call noundef i64 @_RNvCsfFAnx7WYh7o_12evidence_lab3mix(i64 noundef %value.sroa.0.08) #18, !dbg !506
  %exitcond.not = icmp eq i64 %7, %count, !dbg !477
  br i1 %exitcond.not, label %bb7, label %bb6, !dbg !479

bb5:                                              ; preds = %bb6.us, %bb4, %bb7
  %value.sroa.0.0.lcssa14 = phi i64 [ %value.sroa.0.0.lcssa, %bb7 ], [ %value.sroa.0.0.lcssa, %bb4 ], [ %4, %bb6.us ]
  %9 = load atomic i64, ptr %counter monotonic, align 8, !dbg !539
  call void @llvm.lifetime.end.p0(ptr nonnull %counter), !dbg !544
  %10 = insertvalue { i64, i64 } poison, i64 %value.sroa.0.0.lcssa14, 0, !dbg !545
  %11 = insertvalue { i64, i64 } %10, i64 %9, 1, !dbg !545
  ret { i64, i64 } %11, !dbg !545

bb4:                                              ; preds = %bb7
  %_21 = atomicrmw add ptr %counter, i64 %count monotonic, align 8, !dbg !546
  br label %bb5, !dbg !550
}

; evidence_lab::sum_bytes
; Function Attrs: nofree norecurse nosync nounwind memory(argmem: read) uwtable
define noundef i64 @_RNvCsfFAnx7WYh7o_12evidence_lab9sum_bytes(ptr noalias nofree noundef nonnull readonly captures(none) %bytes.0, i64 noundef range(i64 0, -9223372036854775808) %bytes.1) unnamed_addr #4 personality ptr @rust_eh_personality !dbg !551 !guid !552 {
start:
  %0 = icmp samesign eq i64 %bytes.1, 0, !dbg !553
  br i1 %0, label %_RINvXs2J_NtNtCsjIpoRzUjyHQ_4core5slice4iterINtB7_4IterhENtNtNtNtBb_4iter6traits8iterator8Iterator4foldyNCINvNtNtBY_8adapters3map8map_foldRhyyNCNvCsfFAnx7WYh7o_12evidence_lab9sum_bytes0NCINvXsC_NtBW_5accumyNtB35_3Sum3sumINtB1I_3MapBF_B2f_EE0E0EB2j_.exit, label %iter.check, !dbg !567

iter.check:                                       ; preds = %start
  %min.iters.check = icmp samesign ult i64 %bytes.1, 8, !dbg !568
  br i1 %min.iters.check, label %bb8.i.preheader, label %vector.main.loop.iter.check, !dbg !568

vector.main.loop.iter.check:                      ; preds = %iter.check
  %min.iters.check1 = icmp samesign ult i64 %bytes.1, 32, !dbg !568
  br i1 %min.iters.check1, label %vec.epilog.ph, label %vector.ph, !dbg !568

vector.ph:                                        ; preds = %vector.main.loop.iter.check
  %n.mod.vf = and i64 %bytes.1, 24
  %n.vec = and i64 %bytes.1, 9223372036854775776
  br label %vector.body, !dbg !568

vector.body:                                      ; preds = %vector.body, %vector.ph
  %index = phi i64 [ 0, %vector.ph ], [ %index.next, %vector.body ], !dbg !572
  %vec.phi = phi <16 x i64> [ zeroinitializer, %vector.ph ], [ %5, %vector.body ]
  %vec.phi2 = phi <16 x i64> [ zeroinitializer, %vector.ph ], [ %6, %vector.body ]
  %1 = getelementptr inbounds nuw i8, ptr %bytes.0, i64 %index, !dbg !573
  %2 = getelementptr inbounds nuw i8, ptr %1, i64 16, !dbg !576
  %wide.load = load <16 x i8>, ptr %1, align 1, !dbg !576
  %wide.load3 = load <16 x i8>, ptr %2, align 1, !dbg !576
  %3 = zext <16 x i8> %wide.load to <16 x i64>, !dbg !577
  %4 = zext <16 x i8> %wide.load3 to <16 x i64>, !dbg !577
  %5 = add <16 x i64> %vec.phi, %3, !dbg !590
  %6 = add <16 x i64> %vec.phi2, %4, !dbg !590
  %index.next = add nuw i64 %index, 32, !dbg !572
  %7 = icmp eq i64 %index.next, %n.vec, !dbg !568
  br i1 %7, label %middle.block, label %vector.body, !dbg !568, !llvm.loop !594

middle.block:                                     ; preds = %vector.body
  %bin.rdx = add <16 x i64> %6, %5, !dbg !568
  %8 = tail call i64 @llvm.vector.reduce.add.v16i64(<16 x i64> %bin.rdx), !dbg !568
  %cmp.n = icmp eq i64 %bytes.1, %n.vec, !dbg !568
  br i1 %cmp.n, label %_RINvXs2J_NtNtCsjIpoRzUjyHQ_4core5slice4iterINtB7_4IterhENtNtNtNtBb_4iter6traits8iterator8Iterator4foldyNCINvNtNtBY_8adapters3map8map_foldRhyyNCNvCsfFAnx7WYh7o_12evidence_lab9sum_bytes0NCINvXsC_NtBW_5accumyNtB35_3Sum3sumINtB1I_3MapBF_B2f_EE0E0EB2j_.exit, label %vec.epilog.iter.check, !dbg !568

vec.epilog.iter.check:                            ; preds = %middle.block
  %min.epilog.iters.check = icmp eq i64 %n.mod.vf, 0
  br i1 %min.epilog.iters.check, label %bb8.i.preheader, label %vec.epilog.ph, !prof !595

vec.epilog.ph:                                    ; preds = %vector.main.loop.iter.check, %vec.epilog.iter.check
  %vec.epilog.resume.val = phi i64 [ %n.vec, %vec.epilog.iter.check ], [ 0, %vector.main.loop.iter.check ], !dbg !572
  %bc.merge.rdx = phi i64 [ %8, %vec.epilog.iter.check ], [ 0, %vector.main.loop.iter.check ], !dbg !596
  %n.vec5 = and i64 %bytes.1, 9223372036854775800
  %9 = insertelement <8 x i64> <i64 poison, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0, i64 0>, i64 %bc.merge.rdx, i64 0
  br label %vec.epilog.vector.body

vec.epilog.vector.body:                           ; preds = %vec.epilog.vector.body, %vec.epilog.ph
  %index6 = phi i64 [ %vec.epilog.resume.val, %vec.epilog.ph ], [ %index.next9, %vec.epilog.vector.body ], !dbg !572
  %vec.phi7 = phi <8 x i64> [ %9, %vec.epilog.ph ], [ %12, %vec.epilog.vector.body ]
  %10 = getelementptr inbounds nuw i8, ptr %bytes.0, i64 %index6, !dbg !573
  %wide.load8 = load <8 x i8>, ptr %10, align 1, !dbg !576
  %11 = zext <8 x i8> %wide.load8 to <8 x i64>, !dbg !577
  %12 = add <8 x i64> %vec.phi7, %11, !dbg !590
  %index.next9 = add nuw i64 %index6, 8, !dbg !572
  %13 = icmp eq i64 %index.next9, %n.vec5, !dbg !568
  br i1 %13, label %vec.epilog.middle.block, label %vec.epilog.vector.body, !dbg !568, !llvm.loop !597

vec.epilog.middle.block:                          ; preds = %vec.epilog.vector.body
  %14 = tail call i64 @llvm.vector.reduce.add.v8i64(<8 x i64> %12), !dbg !568
  %cmp.n10 = icmp eq i64 %bytes.1, %n.vec5, !dbg !568
  br i1 %cmp.n10, label %_RINvXs2J_NtNtCsjIpoRzUjyHQ_4core5slice4iterINtB7_4IterhENtNtNtNtBb_4iter6traits8iterator8Iterator4foldyNCINvNtNtBY_8adapters3map8map_foldRhyyNCNvCsfFAnx7WYh7o_12evidence_lab9sum_bytes0NCINvXsC_NtBW_5accumyNtB35_3Sum3sumINtB1I_3MapBF_B2f_EE0E0EB2j_.exit, label %bb8.i.preheader, !dbg !568

bb8.i.preheader:                                  ; preds = %iter.check, %vec.epilog.iter.check, %vec.epilog.middle.block
  %i.sroa.0.0.i.ph = phi i64 [ 0, %iter.check ], [ %n.vec, %vec.epilog.iter.check ], [ %n.vec5, %vec.epilog.middle.block ]
  %acc.sroa.0.0.i.ph = phi i64 [ 0, %iter.check ], [ %8, %vec.epilog.iter.check ], [ %14, %vec.epilog.middle.block ]
  br label %bb8.i, !dbg !568

bb8.i:                                            ; preds = %bb8.i.preheader, %bb8.i
  %i.sroa.0.0.i = phi i64 [ %_27.i, %bb8.i ], [ %i.sroa.0.0.i.ph, %bb8.i.preheader ], !dbg !572
  %acc.sroa.0.0.i = phi i64 [ %_4.0.i.i.i, %bb8.i ], [ %acc.sroa.0.0.i.ph, %bb8.i.preheader ], !dbg !596
  %_45.i = getelementptr inbounds nuw i8, ptr %bytes.0, i64 %i.sroa.0.0.i, !dbg !573
  %_45.val.i = load i8, ptr %_45.i, align 1, !dbg !576, !noundef !26
  %_0.i.i.i = zext i8 %_45.val.i to i64, !dbg !577
  %_4.0.i.i.i = add i64 %acc.sroa.0.0.i, %_0.i.i.i, !dbg !590
  %_27.i = add nuw nsw i64 %i.sroa.0.0.i, 1, !dbg !598
  %_28.i = icmp eq i64 %_27.i, %bytes.1, !dbg !568
  br i1 %_28.i, label %_RINvXs2J_NtNtCsjIpoRzUjyHQ_4core5slice4iterINtB7_4IterhENtNtNtNtBb_4iter6traits8iterator8Iterator4foldyNCINvNtNtBY_8adapters3map8map_foldRhyyNCNvCsfFAnx7WYh7o_12evidence_lab9sum_bytes0NCINvXsC_NtBW_5accumyNtB35_3Sum3sumINtB1I_3MapBF_B2f_EE0E0EB2j_.exit, label %bb8.i, !dbg !568, !llvm.loop !601

_RINvXs2J_NtNtCsjIpoRzUjyHQ_4core5slice4iterINtB7_4IterhENtNtNtNtBb_4iter6traits8iterator8Iterator4foldyNCINvNtNtBY_8adapters3map8map_foldRhyyNCNvCsfFAnx7WYh7o_12evidence_lab9sum_bytes0NCINvXsC_NtBW_5accumyNtB35_3Sum3sumINtB1I_3MapBF_B2f_EE0E0EB2j_.exit: ; preds = %bb8.i, %middle.block, %vec.epilog.middle.block, %start
  %_0.sroa.0.0.i = phi i64 [ 0, %start ], [ %14, %vec.epilog.middle.block ], [ %8, %middle.block ], [ %_4.0.i.i.i, %bb8.i ], !dbg !596
  ret i64 %_0.sroa.0.0.i, !dbg !602
}

; Function Attrs: nounwind uwtable
declare noundef range(i32 0, 10) i32 @rust_eh_personality(i32 noundef, i32 noundef, i64 noundef, ptr noundef, ptr noundef) unnamed_addr #3

; core::slice::sort::stable::driftsort_main::<f64, <[f64]>::sort_by<<f64>::total_cmp>::{closure#0}, alloc::vec::Vec<f64>>
; Function Attrs: noinline uwtable
declare void @_RINvNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6stable14driftsort_maindNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtB8_3f64d9total_cmpE0INtNtB18_3vec3VecdEECsfFAnx7WYh7o_12evidence_lab(ptr noalias nofree noundef nonnull align 8, i64 noundef range(i64 0, 1152921504606846976), ptr noalias nofree noundef align 8 dereferenceable(8)) unnamed_addr #5

; Function Attrs: nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none)
declare i64 @llvm.fshl.i64(i64, i64, i64) #6

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(ptr captures(none)) #7

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(ptr captures(none)) #7

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(inaccessiblemem: write)
declare void @llvm.assume(i1 noundef) #8

; Function Attrs: nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none)
declare double @llvm.ceil.f64(double) #6

; Function Attrs: nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none)
declare i64 @llvm.fptoui.sat.i64.f64(double) #6

; core::panicking::panic_bounds_check
; Function Attrs: cold minsize noinline noreturn optsize uwtable
declare void @_RNvNtCsjIpoRzUjyHQ_4core9panicking18panic_bounds_check(i64 noundef, i64 noundef, ptr noalias nofree noundef readonly align 8 captures(address, read_provenance) dereferenceable(24)) unnamed_addr #9

; Function Attrs: nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none)
declare double @llvm.sqrt.f64(double) #6

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.memcpy.p0.p0.i64(ptr noalias writeonly captures(none), ptr noalias readonly captures(none), i64, i1 immarg) #7

; <&str as core::fmt::Display>::fmt
; Function Attrs: uwtable
declare hidden noundef zeroext i1 @_RNvXs1i_NtCsjIpoRzUjyHQ_4core3fmtReNtB6_7Display3fmtCsfFAnx7WYh7o_12evidence_lab(ptr noalias nofree noundef readonly align 8 captures(address, read_provenance) dereferenceable(16), ptr noalias nofree noundef align 8 dereferenceable(24)) unnamed_addr #0

; <usize as core::fmt::Display>::fmt
; Function Attrs: uwtable
declare noundef zeroext i1 @_RNvXsi_NtNtNtCsjIpoRzUjyHQ_4core3fmt3num3impjNtB9_7Display3fmt(ptr noalias nofree noundef readonly align 8 captures(address, read_provenance) dereferenceable(8), ptr noalias nofree noundef align 8 dereferenceable(24)) unnamed_addr #0

; <f64 as core::fmt::Display>::fmt
; Function Attrs: uwtable
declare noundef zeroext i1 @_RNvXs7_NtNtCsjIpoRzUjyHQ_4core3fmt5floatdNtB7_7Display3fmt(ptr noalias nofree noundef readonly align 8 captures(address, read_provenance) dereferenceable(8), ptr noalias nofree noundef align 8 dereferenceable(24)) unnamed_addr #0

; std::io::stdio::_print
; Function Attrs: uwtable
declare void @_RNvNtNtCs1SSuMAdGM58_3std2io5stdio6__print(ptr noundef nonnull, ptr noundef nonnull) unnamed_addr #0

; alloc::raw_vec::handle_error
; Function Attrs: cold minsize noreturn optsize uwtable
declare void @_RNvNtCs6zY7rJBZy9D_5alloc7raw_vec12handle_error(i64 noundef range(i64 0, -9223372036854775807), i64) unnamed_addr #10

; <std::time::Instant>::now
; Function Attrs: uwtable
declare { i64, i32 } @_RNvMNtCs1SSuMAdGM58_3std4timeNtB2_7Instant3now() unnamed_addr #0

; <std::time::Instant>::elapsed
; Function Attrs: uwtable
declare { i64, i32 } @_RNvMNtCs1SSuMAdGM58_3std4timeNtB2_7Instant7elapsed(ptr noalias nofree noundef readonly align 8 captures(address, read_provenance) dereferenceable(16)) unnamed_addr #0

; <&str as core::fmt::Debug>::fmt
; Function Attrs: uwtable
declare hidden noundef zeroext i1 @_RNvXs1g_NtCsjIpoRzUjyHQ_4core3fmtReNtB6_5Debug3fmtCsfFAnx7WYh7o_12evidence_lab(ptr noalias nofree noundef readonly align 8 captures(address, read_provenance) dereferenceable(16), ptr noalias nofree noundef align 8 dereferenceable(24)) unnamed_addr #0

; core::result::unwrap_failed
; Function Attrs: cold noinline noreturn uwtable
declare void @_RNvNtCsjIpoRzUjyHQ_4core6result13unwrap_failed(ptr noalias nofree noundef nonnull readonly captures(address, read_provenance), i64 noundef, ptr noundef nonnull, ptr noalias nofree noundef readonly align 8 captures(address, read_provenance) dereferenceable(32), ptr noalias nofree noundef readonly align 8 captures(address, read_provenance) dereferenceable(24)) unnamed_addr #11

; Function Attrs: nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none)
declare i64 @llvm.usub.sat.i64(i64, i64) #6

; Function Attrs: nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none)
declare i1 @llvm.is.fpclass.f64(double, i32 immarg) #6

; core::slice::sort::shared::smallsort::insertion_sort_shift_left::<f64, <[f64]>::sort_by<<f64>::total_cmp>::{closure#0}>
; Function Attrs: nounwind memory(argmem: readwrite, inaccessiblemem: write) uwtable
declare hidden void @_RINvNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6shared9smallsort25insertion_sort_shift_leftdNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtBa_3f64d9total_cmpE0ECsfFAnx7WYh7o_12evidence_lab(ptr noalias nofree noundef nonnull align 8 captures(address), i64 noundef range(i64 0, 1152921504606846976), i64 noundef, ptr noalias nofree noundef readnone align 8 captures(none) dereferenceable(8)) unnamed_addr #12

; __rustc::__rust_no_alloc_shim_is_unstable_v2
; Function Attrs: nounwind uwtable
declare void @_RNvCsdtSMxSA38aw_7___rustc35___rust_no_alloc_shim_is_unstable_v2() unnamed_addr #3

; __rustc::__rust_alloc
; Function Attrs: nounwind allockind("alloc,uninitialized,aligned") allocsize(0) uwtable
declare noalias noundef ptr @_RNvCsdtSMxSA38aw_7___rustc12___rust_alloc(i64 noundef, i64 allocalign noundef range(i64 1, -9223372036854775807)) unnamed_addr #13

; __rustc::__rust_dealloc
; Function Attrs: nounwind allockind("free") uwtable
declare void @_RNvCsdtSMxSA38aw_7___rustc14___rust_dealloc(ptr allocptr noundef nonnull captures(address), i64 noundef, i64 noundef range(i64 1, -9223372036854775807)) unnamed_addr #14

; Function Attrs: nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none)
declare double @llvm.vector.reduce.fadd.v2f64(double, <2 x double>) #6

; Function Attrs: nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none)
declare i64 @llvm.vector.reduce.add.v16i64(<16 x i64>) #6

; Function Attrs: nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none)
declare i64 @llvm.vector.reduce.add.v8i64(<8 x i64>) #6

attributes #0 = { uwtable "frame-pointer"="non-leaf" "probe-stack"="inline-asm" "target-cpu"="apple-m1" }
attributes #1 = { mustprogress nofree norecurse nosync nounwind willreturn memory(argmem: read) uwtable "frame-pointer"="non-leaf" "probe-stack"="inline-asm" "target-cpu"="apple-m1" }
attributes #2 = { noinline nounwind uwtable "frame-pointer"="non-leaf" "probe-stack"="inline-asm" "target-cpu"="apple-m1" }
attributes #3 = { nounwind uwtable "frame-pointer"="non-leaf" "probe-stack"="inline-asm" "target-cpu"="apple-m1" }
attributes #4 = { nofree norecurse nosync nounwind memory(argmem: read) uwtable "frame-pointer"="non-leaf" "probe-stack"="inline-asm" "target-cpu"="apple-m1" }
attributes #5 = { noinline uwtable "frame-pointer"="non-leaf" "probe-stack"="inline-asm" "target-cpu"="apple-m1" }
attributes #6 = { nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none) }
attributes #7 = { nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #8 = { nocallback nofree nosync nounwind willreturn memory(inaccessiblemem: write) }
attributes #9 = { cold minsize noinline noreturn optsize uwtable "frame-pointer"="non-leaf" "probe-stack"="inline-asm" "target-cpu"="apple-m1" }
attributes #10 = { cold minsize noreturn optsize uwtable "frame-pointer"="non-leaf" "probe-stack"="inline-asm" "target-cpu"="apple-m1" }
attributes #11 = { cold noinline noreturn uwtable "frame-pointer"="non-leaf" "probe-stack"="inline-asm" "target-cpu"="apple-m1" }
attributes #12 = { nounwind memory(argmem: readwrite, inaccessiblemem: write) uwtable "frame-pointer"="non-leaf" "probe-stack"="inline-asm" "target-cpu"="apple-m1" }
attributes #13 = { nounwind allockind("alloc,uninitialized,aligned") allocsize(0) uwtable "alloc-family"="__rust_alloc" "alloc-variant-zeroed"="_RNvCsdtSMxSA38aw_7___rustc19___rust_alloc_zeroed" "frame-pointer"="non-leaf" "probe-stack"="inline-asm" "target-cpu"="apple-m1" }
attributes #14 = { nounwind allockind("free") uwtable "alloc-family"="__rust_alloc" "frame-pointer"="non-leaf" "probe-stack"="inline-asm" "target-cpu"="apple-m1" }
attributes #15 = { noinline noreturn }
attributes #16 = { nounwind }
attributes #17 = { noreturn }
attributes #18 = { noinline }

!llvm.module.flags = !{!8, !9, !10, !11, !12}
!llvm.ident = !{!13}
!llvm.dbg.cu = !{!14, !16, !18, !20}

!0 = !{i64 -1121748140000776513}
!1 = !{i64 6249990020975233276}
!2 = !{i64 -7556392798093659565}
!3 = !{i64 1908118418708466931}
!4 = !{i64 6276652310261961262}
!5 = !{i64 6136459824343714107}
!6 = !{i64 6217884862950541077}
!7 = !{i64 2476208098861551412}
!8 = !{i32 8, !"PIC Level", i32 2}
!9 = !{i32 7, !"uwtable", i32 2}
!10 = !{i32 7, !"frame-pointer", i32 1}
!11 = !{i32 7, !"Dwarf Version", i32 4}
!12 = !{i32 2, !"Debug Info Version", i32 3}
!13 = !{!"rustc version 1.99.0 (b940084d7 2026-09-28)"}
!14 = distinct !DICompileUnit(language: DW_LANG_Rust, file: !15, producer: "clang LLVM (rustc version 1.99.0 (b940084d7 2026-09-28))", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, splitDebugInlining: false, nameTableKind: None)
!15 = !DIFile(filename: "src/lib.rs/@/evidence_lab.b686e75f7ad81cb0-cgu.00", directory: "/Users/juanwang/Desktop/tutorials/cpp-rust/bench/evidence-lab")
!16 = distinct !DICompileUnit(language: DW_LANG_Rust, file: !17, producer: "clang LLVM (rustc version 1.99.0 (b940084d7 2026-09-28))", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, splitDebugInlining: false, nameTableKind: None)
!17 = !DIFile(filename: "src/lib.rs/@/evidence_lab.b686e75f7ad81cb0-cgu.02", directory: "/Users/juanwang/Desktop/tutorials/cpp-rust/bench/evidence-lab")
!18 = distinct !DICompileUnit(language: DW_LANG_Rust, file: !19, producer: "clang LLVM (rustc version 1.99.0 (b940084d7 2026-09-28))", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, splitDebugInlining: false, nameTableKind: None)
!19 = !DIFile(filename: "src/lib.rs/@/evidence_lab.b686e75f7ad81cb0-cgu.05", directory: "/Users/juanwang/Desktop/tutorials/cpp-rust/bench/evidence-lab")
!20 = distinct !DICompileUnit(language: DW_LANG_Rust, file: !21, producer: "clang LLVM (rustc version 1.99.0 (b940084d7 2026-09-28))", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, splitDebugInlining: false, nameTableKind: None)
!21 = !DIFile(filename: "src/lib.rs/@/evidence_lab.b686e75f7ad81cb0-cgu.08", directory: "/Users/juanwang/Desktop/tutorials/cpp-rust/bench/evidence-lab")
!22 = distinct !DISubprogram(name: "nearest_rank", linkageName: "_RNvCsfFAnx7WYh7o_12evidence_lab12nearest_rank", scope: !24, file: !23, line: 97, type: !25, scopeLine: 97, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !14, templateParams: !26)
!23 = !DIFile(filename: "src/lib.rs", directory: "/Users/juanwang/Desktop/tutorials/cpp-rust/bench/evidence-lab", checksumkind: CSK_MD5, checksum: "ac2520682925bb11f829d6faa84c5cca")
!24 = !DINamespace(name: "evidence_lab", scope: null)
!25 = !DISubroutineType(types: !26)
!26 = !{}
!27 = !{i64 -3662879027310662378}
!28 = !DILocation(line: 98, column: 31, scope: !22)
!29 = !DILocation(line: 98, column: 16, scope: !22)
!30 = !DILocation(line: 1831, column: 9, scope: !31, inlinedAt: !36)
!31 = distinct !DISubprogram(name: "ceil", linkageName: "_RNvNtNtCsjIpoRzUjyHQ_4core3f644math4ceil", scope: !33, file: !32, line: 1830, type: !25, scopeLine: 1830, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !14, templateParams: !26)
!32 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/num/f64.rs", directory: "", checksumkind: CSK_MD5, checksum: "b3f8ed35e28142dfe7f88c4667789fd1")
!33 = !DINamespace(name: "math", scope: !34)
!34 = !DINamespace(name: "f64", scope: !35)
!35 = !DINamespace(name: "core", scope: null)
!36 = !DILocation(line: 75, column: 9, scope: !37, inlinedAt: !42)
!37 = distinct !DISubprogram(name: "ceil", linkageName: "_RNvMNtCs1SSuMAdGM58_3std3f64d4ceil", scope: !39, file: !38, line: 74, type: !25, scopeLine: 74, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !14, templateParams: !26)
!38 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/std/src/num/f64.rs", directory: "", checksumkind: CSK_MD5, checksum: "90285b65697b7aee488f33478ad168a5")
!39 = !DINamespace(name: "{impl#0}", scope: !40)
!40 = !DINamespace(name: "f64", scope: !41)
!41 = !DINamespace(name: "std", scope: null)
!42 = !DILocation(line: 98, column: 52, scope: !22)
!43 = !DILocation(line: 99, column: 12, scope: !44)
!44 = distinct !DILexicalBlock(scope: !22, file: !23, line: 98, column: 5)
!45 = !DILocation(line: 99, column: 5, scope: !44)
!46 = !DILocation(line: 100, column: 2, scope: !22)
!47 = distinct !DISubprogram(name: "complete_samples", linkageName: "_RNvCsfFAnx7WYh7o_12evidence_lab16complete_samples", scope: !24, file: !23, line: 86, type: !25, scopeLine: 86, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !14, templateParams: !26)
!48 = !{i64 8985902132980237491}
!49 = !DILocation(line: 87, column: 8, scope: !47)
!50 = !DILocation(line: 327, column: 24, scope: !51, inlinedAt: !57)
!51 = distinct !DILexicalBlock(scope: !53, file: !52, line: 326, column: 49)
!52 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/slice/iter/macros.rs", directory: "", checksumkind: CSK_MD5, checksum: "526307389b7550baea9ff75b5731c6e9")
!53 = distinct !DISubprogram(name: "any<f64, evidence_lab::complete_samples::{closure_env#0}>", linkageName: "_RINvXs2J_NtNtCsjIpoRzUjyHQ_4core5slice4iterINtB7_4IterdENtNtNtNtBb_4iter6traits8iterator8Iterator3anyNCNvCsfFAnx7WYh7o_12evidence_lab16complete_samples0EB1F_", scope: !54, file: !52, line: 321, type: !25, scopeLine: 321, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !14, templateParams: !26)
!54 = !DINamespace(name: "{impl#171}", scope: !55)
!55 = !DINamespace(name: "iter", scope: !56)
!56 = !DINamespace(name: "slice", scope: !35)
!57 = distinct !DILocation(line: 90, column: 23, scope: !47)
!58 = !{!59}
!59 = distinct !{!59, !60, !"_RINvXs2J_NtNtCsjIpoRzUjyHQ_4core5slice4iterINtB7_4IterdENtNtNtNtBb_4iter6traits8iterator8Iterator3anyNCNvCsfFAnx7WYh7o_12evidence_lab16complete_samples0EB1F_: %self"}
!60 = distinct !{!60, !"_RINvXs2J_NtNtCsjIpoRzUjyHQ_4core5slice4iterINtB7_4IterdENtNtNtNtBb_4iter6traits8iterator8Iterator3anyNCNvCsfFAnx7WYh7o_12evidence_lab16complete_samples0EB1F_"}
!61 = !DILocation(line: 90, column: 32, scope: !62, inlinedAt: !65)
!62 = distinct !DISubprogram(name: "{closure#0}", linkageName: "_RNCNvCsfFAnx7WYh7o_12evidence_lab16complete_samples0B3_", scope: !63, file: !23, line: 90, type: !64, scopeLine: 90, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !14, templateParams: !26)
!63 = !DINamespace(name: "complete_samples", scope: !24)
!64 = !DISubroutineType(cc: DW_CC_nocall, types: !26)
!65 = distinct !DILocation(line: 327, column: 24, scope: !51, inlinedAt: !57)
!66 = !DILocation(line: 1663, column: 9, scope: !67, inlinedAt: !72)
!67 = distinct !DISubprogram(name: "eq<f64>", linkageName: "_RNvXsd_NtNtCsjIpoRzUjyHQ_4core3ptr8non_nullINtB5_7NonNulldENtNtB9_3cmp9PartialEq2eqCsfFAnx7WYh7o_12evidence_lab", scope: !69, file: !68, line: 1662, type: !25, scopeLine: 1662, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !14, templateParams: !26)
!68 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/ptr/non_null.rs", directory: "", checksumkind: CSK_MD5, checksum: "accc742d53c125b723531f778524eec8")
!69 = !DINamespace(name: "{impl#15}", scope: !70)
!70 = !DINamespace(name: "non_null", scope: !71)
!71 = !DINamespace(name: "ptr", scope: !35)
!72 = distinct !DILocation(line: 180, column: 28, scope: !73, inlinedAt: !76)
!73 = distinct !DILexicalBlock(scope: !74, file: !52, line: 162, column: 17)
!74 = distinct !DILexicalBlock(scope: !75, file: !52, line: 161, column: 17)
!75 = distinct !DISubprogram(name: "next<f64>", linkageName: "_RNvXs2J_NtNtCsjIpoRzUjyHQ_4core5slice4iterINtB6_4IterdENtNtNtNtBa_4iter6traits8iterator8Iterator4nextCsfFAnx7WYh7o_12evidence_lab", scope: !54, file: !52, line: 157, type: !25, scopeLine: 157, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !14, templateParams: !26)
!76 = distinct !DILocation(line: 326, column: 42, scope: !51, inlinedAt: !57)
!77 = !DILocation(line: 0, scope: !47)
!78 = !DILocation(line: 94, column: 2, scope: !47)
!79 = distinct !DISubprogram(name: "mix", linkageName: "_RNvCsfFAnx7WYh7o_12evidence_lab3mix", scope: !24, file: !23, line: 17, type: !25, scopeLine: 17, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !14, templateParams: !26)
!80 = !{i64 5326066766427342707}
!81 = !DILocation(line: 18, column: 5, scope: !79)
!82 = !DILocation(line: 491, column: 5, scope: !83, inlinedAt: !81)
!83 = distinct !DISubprogram(name: "black_box<u64>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core4hint9black_boxyECsfFAnx7WYh7o_12evidence_lab", scope: !85, file: !84, line: 490, type: !25, scopeLine: 490, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !14, templateParams: !26)
!84 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/hint.rs", directory: "", checksumkind: CSK_MD5, checksum: "720ecb12dbf1a304509abd161627e0e2")
!85 = !DINamespace(name: "hint", scope: !35)
!86 = !{i64 1333772029312236}
!87 = !DILocation(line: 475, column: 20, scope: !88, inlinedAt: !92)
!88 = distinct !DISubprogram(name: "rotate_left", linkageName: "_RNvMs7_NtCsjIpoRzUjyHQ_4core3numy11rotate_left", scope: !90, file: !89, line: 474, type: !25, scopeLine: 474, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !14, templateParams: !26)
!89 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/num/uint_macros.rs", directory: "", checksumkind: CSK_MD5, checksum: "861b08c040dcb8e56aa7d23dacf541ca")
!90 = !DINamespace(name: "{impl#9}", scope: !91)
!91 = !DINamespace(name: "num", scope: !35)
!92 = !DILocation(line: 19, column: 10, scope: !79)
!93 = !DILocation(line: 2215, column: 14, scope: !94, inlinedAt: !97)
!94 = distinct !DISubprogram(name: "rotate_left<u64>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core10intrinsics11rotate_leftyECsfFAnx7WYh7o_12evidence_lab", scope: !96, file: !95, line: 2211, type: !25, scopeLine: 2211, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !14, templateParams: !26)
!95 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/intrinsics/mod.rs", directory: "", checksumkind: CSK_MD5, checksum: "95f29c0132b18aca34fbfb798048cc68")
!96 = !DINamespace(name: "intrinsics", scope: !35)
!97 = distinct !DILocation(line: 475, column: 20, scope: !88, inlinedAt: !92)
!98 = !DILocation(line: 19, column: 23, scope: !79)
!99 = !DILocation(line: 2728, column: 13, scope: !100, inlinedAt: !101)
!100 = distinct !DISubprogram(name: "wrapping_mul", linkageName: "_RNvMs7_NtCsjIpoRzUjyHQ_4core3numy12wrapping_mul", scope: !90, file: !89, line: 2727, type: !25, scopeLine: 2727, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !14, templateParams: !26)
!101 = !DILocation(line: 20, column: 10, scope: !79)
!102 = !DILocation(line: 2652, column: 13, scope: !103, inlinedAt: !104)
!103 = distinct !DISubprogram(name: "wrapping_add", linkageName: "_RNvMs7_NtCsjIpoRzUjyHQ_4core3numy12wrapping_add", scope: !90, file: !89, line: 2651, type: !25, scopeLine: 2651, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !14, templateParams: !26)
!104 = !DILocation(line: 21, column: 10, scope: !79)
!105 = !DILocation(line: 22, column: 2, scope: !79)
!106 = distinct !DISubprogram(name: "report", linkageName: "_RNvCsfFAnx7WYh7o_12evidence_lab6report", scope: !24, file: !23, line: 111, type: !25, scopeLine: 111, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !14, templateParams: !26)
!107 = !{i64 -1144400010107398965}
!108 = !DILocation(line: 112, column: 5, scope: !106)
!109 = !DILocation(line: 1182, column: 15, scope: !110, inlinedAt: !114)
!110 = distinct !DISubprogram(name: "expect<(), &str>", linkageName: "_RNvMNtCsjIpoRzUjyHQ_4core6resultINtB2_6ResultuReE6expectCsfFAnx7WYh7o_12evidence_lab", scope: !112, file: !111, line: 1178, type: !64, scopeLine: 1178, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !14, templateParams: !26)
!111 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/result.rs", directory: "", checksumkind: CSK_MD5, checksum: "d01c390c1644b468299b560eda4cb25a")
!112 = !DINamespace(name: "Result", scope: !113)
!113 = !DINamespace(name: "result", scope: !35)
!114 = distinct !DILocation(line: 112, column: 31, scope: !106)
!115 = !DILocation(line: 1182, column: 9, scope: !110, inlinedAt: !114)
!116 = !{!"branch_weights", !"expected", i32 2000, i32 1}
!117 = !DILocation(line: 1184, column: 17, scope: !110, inlinedAt: !114)
!118 = !{!119}
!119 = distinct !{!119, !120, !"_RNvMNtCsjIpoRzUjyHQ_4core6resultINtB2_6ResultuReE6expectCsfFAnx7WYh7o_12evidence_lab: argument 0"}
!120 = distinct !{!120, !"_RNvMNtCsjIpoRzUjyHQ_4core6resultINtB2_6ResultuReE6expectCsfFAnx7WYh7o_12evidence_lab"}
!121 = !{!"address", !"read_provenance"}
!122 = !DILocation(line: 1184, column: 23, scope: !123, inlinedAt: !114)
!123 = distinct !DILexicalBlock(scope: !110, file: !111, line: 1184, column: 13)
!124 = !DILocation(line: 113, column: 9, scope: !106)
!125 = !DILocation(line: 1663, column: 9, scope: !126, inlinedAt: !127)
!126 = distinct !DISubprogram(name: "eq<f64>", linkageName: "_RNvXsd_NtNtCsjIpoRzUjyHQ_4core3ptr8non_nullINtB5_7NonNulldENtNtB9_3cmp9PartialEq2eqCsfFAnx7WYh7o_12evidence_lab", scope: !69, file: !68, line: 1662, type: !25, scopeLine: 1662, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !14, templateParams: !26)
!127 = distinct !DILocation(line: 44, column: 20, scope: !128, inlinedAt: !131)
!128 = distinct !DILexicalBlock(scope: !129, file: !52, line: 33, column: 13)
!129 = distinct !DILexicalBlock(scope: !130, file: !52, line: 25, column: 86)
!130 = distinct !DISubprogram(name: "fold<f64, f64, core::iter::traits::accum::{impl#134}::sum::{closure_env#0}<core::slice::iter::Iter<f64>>>", linkageName: "_RINvXs2J_NtNtCsjIpoRzUjyHQ_4core5slice4iterINtB7_4IterdENtNtNtNtBb_4iter6traits8iterator8Iterator4folddNCINvXs28_NtBW_5accumdINtB1N_3SumRdE3sumBF_E0ECsfFAnx7WYh7o_12evidence_lab", scope: !54, file: !52, line: 254, type: !25, scopeLine: 254, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !14, templateParams: !26)
!131 = distinct !DILocation(line: 185, column: 22, scope: !132, inlinedAt: !138)
!132 = distinct !DISubprogram(name: "sum<core::slice::iter::Iter<f64>>", linkageName: "_RINvXs28_NtNtNtCsjIpoRzUjyHQ_4core4iter6traits5accumdINtB7_3SumRdE3sumINtNtNtBd_5slice4iter4IterdEECsfFAnx7WYh7o_12evidence_lab", scope: !134, file: !133, line: 184, type: !25, scopeLine: 184, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !14, templateParams: !26)
!133 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/iter/traits/accum.rs", directory: "", checksumkind: CSK_MD5, checksum: "feb1ff9fb1952daa0ee55a4414e2f66e")
!134 = !DINamespace(name: "{impl#134}", scope: !135)
!135 = !DINamespace(name: "accum", scope: !136)
!136 = !DINamespace(name: "traits", scope: !137)
!137 = !DINamespace(name: "iter", scope: !35)
!138 = !DILocation(line: 3670, column: 9, scope: !139, inlinedAt: !143)
!139 = distinct !DISubprogram(name: "sum<core::slice::iter::Iter<f64>, f64>", linkageName: "_RINvYINtNtNtCsjIpoRzUjyHQ_4core5slice4iter4IterdENtNtNtNtBa_4iter6traits8iterator8Iterator3sumdECsfFAnx7WYh7o_12evidence_lab", scope: !141, file: !140, line: 3665, type: !25, scopeLine: 3665, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !14, templateParams: !26)
!140 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/iter/traits/iterator.rs", directory: "", checksumkind: CSK_MD5, checksum: "18f221b1fea37f3a9346ab1e3a47427f")
!141 = !DINamespace(name: "Iterator", scope: !142)
!142 = !DINamespace(name: "iterator", scope: !136)
!143 = !DILocation(line: 113, column: 31, scope: !106)
!144 = !DILocation(line: 25, column: 86, scope: !129, inlinedAt: !131)
!145 = !DILocation(line: 279, column: 24, scope: !146, inlinedAt: !131)
!146 = distinct !DILexicalBlock(scope: !147, file: !52, line: 270, column: 17)
!147 = distinct !DILexicalBlock(scope: !148, file: !52, line: 269, column: 17)
!148 = distinct !DILexicalBlock(scope: !130, file: !52, line: 268, column: 17)
!149 = !DILocation(line: 0, scope: !148, inlinedAt: !131)
!150 = !DILocation(line: 627, column: 28, scope: !151, inlinedAt: !153)
!151 = distinct !DISubprogram(name: "add<f64>", linkageName: "_RNvMs1_NtNtCsjIpoRzUjyHQ_4core3ptr8non_nullINtB5_7NonNulldE3addCsfFAnx7WYh7o_12evidence_lab", scope: !152, file: !68, line: 619, type: !25, scopeLine: 619, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !14, templateParams: !26)
!152 = !DINamespace(name: "NonNull", scope: !70)
!153 = distinct !DILocation(line: 274, column: 67, scope: !146, inlinedAt: !131)
!154 = !DILocation(line: 274, column: 27, scope: !146, inlinedAt: !131)
!155 = !DILocation(line: 104, column: 45, scope: !156, inlinedAt: !161)
!156 = distinct !DISubprogram(name: "add", linkageName: "_RNvXsc_NtNtCsjIpoRzUjyHQ_4core3ops5arithdNtB5_3Add3add", scope: !158, file: !157, line: 104, type: !25, scopeLine: 104, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !14, templateParams: !26)
!157 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/ops/arith.rs", directory: "", checksumkind: CSK_MD5, checksum: "a90ea76ea68a6d4da3ce004a8c5d5c08")
!158 = !DINamespace(name: "{impl#14}", scope: !159)
!159 = !DINamespace(name: "arith", scope: !160)
!160 = !DINamespace(name: "ops", scope: !35)
!161 = distinct !DILocation(line: 39, column: 17, scope: !162, inlinedAt: !165)
!162 = distinct !DISubprogram(name: "add", linkageName: "_RNvXsV_NtNtCsjIpoRzUjyHQ_4core3ops5arithdINtB5_3AddRdE3add", scope: !164, file: !163, line: 38, type: !25, scopeLine: 38, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !14, templateParams: !26)
!163 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/internal_macros.rs", directory: "", checksumkind: CSK_MD5, checksum: "51c008a9374c554409160e46dbae758a")
!164 = !DINamespace(name: "{impl#59}", scope: !159)
!165 = distinct !DILocation(line: 188, column: 28, scope: !166, inlinedAt: !168)
!166 = distinct !DISubprogram(name: "{closure#0}<core::slice::iter::Iter<f64>>", linkageName: "_RNCINvXs28_NtNtNtCsjIpoRzUjyHQ_4core4iter6traits5accumdINtB9_3SumRdE3sumINtNtNtBf_5slice4iter4IterdEE0CsfFAnx7WYh7o_12evidence_lab", scope: !167, file: !133, line: 188, type: !64, scopeLine: 188, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !14, templateParams: !26)
!167 = !DINamespace(name: "sum", scope: !134)
!168 = distinct !DILocation(line: 274, column: 27, scope: !146, inlinedAt: !131)
!169 = distinct !{!169, !170, !171}
!170 = !{!"llvm.loop.isvectorized", i32 1}
!171 = !{!"llvm.loop.unroll.runtime.disable"}
!172 = !DILocation(line: 113, column: 16, scope: !106)
!173 = !DILocation(line: 114, column: 9, scope: !174)
!174 = distinct !DILexicalBlock(scope: !106, file: !23, line: 113, column: 5)
!175 = !DILocation(line: 25, column: 86, scope: !176, inlinedAt: !178)
!176 = distinct !DILexicalBlock(scope: !177, file: !52, line: 25, column: 86)
!177 = distinct !DISubprogram(name: "fold<f64, f64, core::iter::adapters::map::map_fold::{closure_env#0}<&f64, f64, f64, evidence_lab::report::{closure_env#0}, core::iter::traits::accum::{impl#132}::sum::{closure_env#0}<core::iter::adapters::map::Map<core::slice::iter::Iter<f64>, evidence_lab::report::{closure_env#0}>>>>", linkageName: "_RINvXs2J_NtNtCsjIpoRzUjyHQ_4core5slice4iterINtB7_4IterdENtNtNtNtBb_4iter6traits8iterator8Iterator4folddNCINvNtNtBY_8adapters3map8map_foldRdddNCNvCsfFAnx7WYh7o_12evidence_lab6report0NCINvXs26_NtBW_5accumdNtB33_3Sum3sumINtB1I_3MapBF_B2f_EE0E0EB2j_", scope: !54, file: !52, line: 254, type: !25, scopeLine: 254, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !14, templateParams: !26)
!178 = distinct !DILocation(line: 128, column: 19, scope: !179, inlinedAt: !184)
!179 = distinct !DISubprogram(name: "fold<f64, core::slice::iter::Iter<f64>, evidence_lab::report::{closure_env#0}, f64, core::iter::traits::accum::{impl#132}::sum::{closure_env#0}<core::iter::adapters::map::Map<core::slice::iter::Iter<f64>, evidence_lab::report::{closure_env#0}>>>", linkageName: "_RINvXs0_NtNtNtCsjIpoRzUjyHQ_4core4iter8adapters3mapINtB6_3MapINtNtNtBc_5slice4iter4IterdENCNvCsfFAnx7WYh7o_12evidence_lab6report0ENtNtNtBa_6traits8iterator8Iterator4folddNCINvXs26_NtB28_5accumdNtB2S_3Sum3sumBN_E0EB1t_", scope: !181, file: !180, line: 124, type: !25, scopeLine: 124, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !14, templateParams: !26)
!180 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/iter/adapters/map.rs", directory: "", checksumkind: CSK_MD5, checksum: "4c6778ae80de9d62520e12b61373153e")
!181 = !DINamespace(name: "{impl#2}", scope: !182)
!182 = !DINamespace(name: "map", scope: !183)
!183 = !DINamespace(name: "adapters", scope: !137)
!184 = !DILocation(line: 163, column: 22, scope: !185, inlinedAt: !187)
!185 = distinct !DISubprogram(name: "sum<core::iter::adapters::map::Map<core::slice::iter::Iter<f64>, evidence_lab::report::{closure_env#0}>>", linkageName: "_RINvXs26_NtNtNtCsjIpoRzUjyHQ_4core4iter6traits5accumdNtB7_3Sum3sumINtNtNtBb_8adapters3map3MapINtNtNtBd_5slice4iter4IterdENCNvCsfFAnx7WYh7o_12evidence_lab6report0EEB1Z_", scope: !186, file: !133, line: 162, type: !25, scopeLine: 162, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !14, templateParams: !26)
!186 = !DINamespace(name: "{impl#132}", scope: !135)
!187 = !DILocation(line: 3670, column: 9, scope: !188, inlinedAt: !190)
!188 = !DILexicalBlockFile(scope: !189, file: !140, discriminator: 2)
!189 = distinct !DISubprogram(name: "sum<core::iter::adapters::map::Map<core::slice::iter::Iter<f64>, evidence_lab::report::{closure_env#0}>, f64>", linkageName: "_RINvYINtNtNtNtCsjIpoRzUjyHQ_4core4iter8adapters3map3MapINtNtNtBc_5slice4iter4IterdENCNvCsfFAnx7WYh7o_12evidence_lab6report0ENtNtNtBa_6traits8iterator8Iterator3sumdEB1n_", scope: !141, file: !140, line: 3665, type: !25, scopeLine: 3665, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !14, templateParams: !26)
!190 = !DILocation(line: 114, column: 58, scope: !174)
!191 = !DILocation(line: 0, scope: !130, inlinedAt: !131)
!192 = !DILocation(line: 1013, column: 17, scope: !193, inlinedAt: !195)
!193 = distinct !DISubprogram(name: "unchecked_add", linkageName: "_RNvMs9_NtCsjIpoRzUjyHQ_4core3numj13unchecked_add", scope: !194, file: !89, line: 1001, type: !25, scopeLine: 1001, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !14, templateParams: !26)
!194 = !DINamespace(name: "{impl#11}", scope: !91)
!195 = distinct !DILocation(line: 278, column: 36, scope: !146, inlinedAt: !131)
!196 = distinct !{!196, !171, !170}
!197 = !DILocation(line: 113, column: 46, scope: !106)
!198 = !DILocation(line: 28, column: 9, scope: !199, inlinedAt: !178)
!199 = distinct !DILexicalBlock(scope: !200, file: !52, line: 25, column: 86)
!200 = distinct !DILexicalBlock(scope: !201, file: !52, line: 269, column: 17)
!201 = distinct !DILexicalBlock(scope: !177, file: !52, line: 268, column: 17)
!202 = !DILocation(line: 0, scope: !201, inlinedAt: !178)
!203 = !DILocation(line: 627, column: 28, scope: !204, inlinedAt: !205)
!204 = distinct !DISubprogram(name: "add<f64>", linkageName: "_RNvMs1_NtNtCsjIpoRzUjyHQ_4core3ptr8non_nullINtB5_7NonNulldE3addCsfFAnx7WYh7o_12evidence_lab", scope: !152, file: !68, line: 619, type: !25, scopeLine: 619, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !14, templateParams: !26)
!205 = distinct !DILocation(line: 274, column: 67, scope: !206, inlinedAt: !178)
!206 = distinct !DILexicalBlock(scope: !200, file: !52, line: 270, column: 17)
!207 = !DILocation(line: 274, column: 27, scope: !206, inlinedAt: !178)
!208 = !{!209}
!209 = distinct !{!209, !210, !"_RINvXs2J_NtNtCsjIpoRzUjyHQ_4core5slice4iterINtB7_4IterdENtNtNtNtBb_4iter6traits8iterator8Iterator4folddNCINvNtNtBY_8adapters3map8map_foldRdddNCNvCsfFAnx7WYh7o_12evidence_lab6report0NCINvXs26_NtBW_5accumdNtB33_3Sum3sumINtB1I_3MapBF_B2f_EE0E0EB2j_: argument 0"}
!210 = distinct !{!210, !"_RINvXs2J_NtNtCsjIpoRzUjyHQ_4core5slice4iterINtB7_4IterdENtNtNtNtBb_4iter6traits8iterator8Iterator4folddNCINvNtNtBY_8adapters3map8map_foldRdddNCNvCsfFAnx7WYh7o_12evidence_lab6report0NCINvXs26_NtBW_5accumdNtB33_3Sum3sumINtB1I_3MapBF_B2f_EE0E0EB2j_"}
!211 = !DILocation(line: 216, column: 45, scope: !212, inlinedAt: !214)
!212 = distinct !DISubprogram(name: "sub", linkageName: "_RNvXs1e_NtNtCsjIpoRzUjyHQ_4core3ops5arithdNtB6_3Sub3sub", scope: !213, file: !157, line: 216, type: !25, scopeLine: 216, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !14, templateParams: !26)
!213 = !DINamespace(name: "{impl#78}", scope: !159)
!214 = distinct !DILocation(line: 28, column: 17, scope: !215, inlinedAt: !217)
!215 = distinct !DISubprogram(name: "sub", linkageName: "_RNvXs1W_NtNtCsjIpoRzUjyHQ_4core3ops5arithRdINtB6_3SubdE3sub", scope: !216, file: !163, line: 27, type: !25, scopeLine: 27, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !14, templateParams: !26)
!216 = !DINamespace(name: "{impl#122}", scope: !159)
!217 = distinct !DILocation(line: 114, column: 38, scope: !218, inlinedAt: !220)
!218 = distinct !DISubprogram(name: "{closure#0}", linkageName: "_RNCNvCsfFAnx7WYh7o_12evidence_lab6report0B3_", scope: !219, file: !23, line: 114, type: !64, scopeLine: 114, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !14, templateParams: !26)
!219 = !DINamespace(name: "report", scope: !24)
!220 = distinct !DILocation(line: 88, column: 28, scope: !221, inlinedAt: !223)
!221 = distinct !DISubprogram(name: "{closure#0}<&f64, f64, f64, evidence_lab::report::{closure_env#0}, core::iter::traits::accum::{impl#132}::sum::{closure_env#0}<core::iter::adapters::map::Map<core::slice::iter::Iter<f64>, evidence_lab::report::{closure_env#0}>>>", linkageName: "_RNCINvNtNtNtCsjIpoRzUjyHQ_4core4iter8adapters3map8map_foldRdddNCNvCsfFAnx7WYh7o_12evidence_lab6report0NCINvXs26_NtNtB8_6traits5accumdNtB1M_3Sum3sumINtB4_3MapINtNtNtBa_5slice4iter4IterdEBY_EE0E0B12_", scope: !222, file: !180, line: 88, type: !64, scopeLine: 88, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !14, templateParams: !26)
!222 = !DINamespace(name: "map_fold", scope: !182)
!223 = distinct !DILocation(line: 274, column: 27, scope: !206, inlinedAt: !178)
!224 = !DILocation(line: 2092, column: 9, scope: !225, inlinedAt: !226)
!225 = distinct !DISubprogram(name: "powi", linkageName: "_RNvNtNtCsjIpoRzUjyHQ_4core3f644math4powi", scope: !33, file: !32, line: 2091, type: !25, scopeLine: 2091, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !14, templateParams: !26)
!226 = distinct !DILocation(line: 326, column: 9, scope: !227, inlinedAt: !228)
!227 = distinct !DISubprogram(name: "powi", linkageName: "_RNvMNtCs1SSuMAdGM58_3std3f64d4powi", scope: !39, file: !38, line: 325, type: !25, scopeLine: 325, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !14, templateParams: !26)
!228 = distinct !DILocation(line: 114, column: 49, scope: !218, inlinedAt: !220)
!229 = !DILocation(line: 166, column: 28, scope: !230, inlinedAt: !232)
!230 = distinct !DISubprogram(name: "{closure#0}<core::iter::adapters::map::Map<core::slice::iter::Iter<f64>, evidence_lab::report::{closure_env#0}>>", linkageName: "_RNCINvXs26_NtNtNtCsjIpoRzUjyHQ_4core4iter6traits5accumdNtB9_3Sum3sumINtNtNtBd_8adapters3map3MapINtNtNtBf_5slice4iter4IterdENCNvCsfFAnx7WYh7o_12evidence_lab6report0EE0B21_", scope: !231, file: !133, line: 166, type: !64, scopeLine: 166, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !14, templateParams: !26)
!231 = !DINamespace(name: "sum", scope: !186)
!232 = distinct !DILocation(line: 88, column: 21, scope: !221, inlinedAt: !223)
!233 = !DILocation(line: 279, column: 24, scope: !206, inlinedAt: !178)
!234 = distinct !{!234, !170, !171}
!235 = !DILocation(line: 0, scope: !177, inlinedAt: !178)
!236 = !DILocation(line: 1013, column: 17, scope: !237, inlinedAt: !238)
!237 = distinct !DISubprogram(name: "unchecked_add", linkageName: "_RNvMs9_NtCsjIpoRzUjyHQ_4core3numj13unchecked_add", scope: !194, file: !89, line: 1001, type: !25, scopeLine: 1001, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !14, templateParams: !26)
!238 = distinct !DILocation(line: 278, column: 36, scope: !206, inlinedAt: !178)
!239 = distinct !{!239, !171, !170}
!240 = !DILocation(line: 114, column: 73, scope: !174)
!241 = !DILocation(line: 114, column: 14, scope: !174)
!242 = !DILocation(line: 2122, column: 9, scope: !243, inlinedAt: !244)
!243 = distinct !DISubprogram(name: "sqrt", linkageName: "_RNvNtNtCsjIpoRzUjyHQ_4core3f644math4sqrt", scope: !33, file: !32, line: 2121, type: !25, scopeLine: 2121, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !14, templateParams: !26)
!244 = !DILocation(line: 387, column: 9, scope: !245, inlinedAt: !246)
!245 = distinct !DISubprogram(name: "sqrt", linkageName: "_RNvMNtCs1SSuMAdGM58_3std3f64d4sqrt", scope: !39, file: !38, line: 386, type: !25, scopeLine: 386, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !14, templateParams: !26)
!246 = !DILocation(line: 115, column: 10, scope: !174)
!247 = !DILocation(line: 3212, column: 26, scope: !248, inlinedAt: !249)
!248 = distinct !DISubprogram(name: "overflowing_mul", linkageName: "_RNvMs9_NtCsjIpoRzUjyHQ_4core3numj15overflowing_mul", scope: !194, file: !89, line: 3211, type: !25, scopeLine: 3211, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !18, templateParams: !26)
!249 = distinct !DILocation(line: 1330, column: 31, scope: !250, inlinedAt: !251)
!250 = distinct !DISubprogram(name: "checked_mul", linkageName: "_RNvMs9_NtCsjIpoRzUjyHQ_4core3numj11checked_mul", scope: !194, file: !89, line: 1329, type: !25, scopeLine: 1329, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !18, templateParams: !26)
!251 = distinct !DILocation(line: 533, column: 39, scope: !252, inlinedAt: !258)
!252 = distinct !DILexicalBlock(scope: !254, file: !253, line: 533, column: 54)
!253 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/alloc/layout.rs", directory: "", checksumkind: CSK_MD5, checksum: "044b929685d8564035fcb902806519e4")
!254 = distinct !DISubprogram(name: "repeat_packed", linkageName: "_RNvMNtNtCsjIpoRzUjyHQ_4core5alloc6layoutNtB2_6Layout13repeat_packed", scope: !255, file: !253, line: 532, type: !25, scopeLine: 532, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !18, templateParams: !26)
!255 = !DINamespace(name: "Layout", scope: !256)
!256 = !DINamespace(name: "layout", scope: !257)
!257 = !DINamespace(name: "alloc", scope: !35)
!258 = distinct !DILocation(line: 901, column: 17, scope: !259, inlinedAt: !263)
!259 = distinct !DISubprogram(name: "layout_array", linkageName: "_RNvNtCs6zY7rJBZy9D_5alloc7raw_vec12layout_array", scope: !261, file: !260, line: 896, type: !25, scopeLine: 896, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !18, templateParams: !26)
!260 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/alloc/src/raw_vec/mod.rs", directory: "", checksumkind: CSK_MD5, checksum: "acd4dae5e7aaaaf06aa0208ebac37ff5")
!261 = !DINamespace(name: "raw_vec", scope: !262)
!262 = !DINamespace(name: "alloc", scope: null)
!263 = distinct !DILocation(line: 455, column: 28, scope: !264, inlinedAt: !266)
!264 = distinct !DISubprogram(name: "try_allocate_in<alloc::alloc::Global>", linkageName: "_RNvMs5_NtCs6zY7rJBZy9D_5alloc7raw_vecNtB5_11RawVecInner15try_allocate_inCsfFAnx7WYh7o_12evidence_lab", scope: !265, file: !260, line: 447, type: !25, scopeLine: 447, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !18, templateParams: !26)
!265 = !DINamespace(name: "RawVecInner", scope: !261)
!266 = distinct !DILocation(line: 435, column: 15, scope: !267, inlinedAt: !268)
!267 = distinct !DISubprogram(name: "with_capacity_in<alloc::alloc::Global>", linkageName: "_RNvMs5_NtCs6zY7rJBZy9D_5alloc7raw_vecNtB5_11RawVecInner16with_capacity_inCsfFAnx7WYh7o_12evidence_lab", scope: !265, file: !260, line: 434, type: !25, scopeLine: 434, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !14, templateParams: !26)
!268 = !DILocation(line: 177, column: 20, scope: !269, inlinedAt: !271)
!269 = distinct !DISubprogram(name: "with_capacity_in<f64, alloc::alloc::Global>", linkageName: "_RNvMs4_NtCs6zY7rJBZy9D_5alloc7raw_vecINtB5_6RawVecdE16with_capacity_inCsfFAnx7WYh7o_12evidence_lab", scope: !270, file: !260, line: 175, type: !25, scopeLine: 175, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !14, templateParams: !26)
!270 = !DINamespace(name: "RawVec", scope: !261)
!271 = !DILocation(line: 969, column: 20, scope: !272, inlinedAt: !276)
!272 = distinct !DISubprogram(name: "with_capacity_in<f64, alloc::alloc::Global>", linkageName: "_RNvMsG_NtCs6zY7rJBZy9D_5alloc3vecINtB5_3VecdE16with_capacity_inCsfFAnx7WYh7o_12evidence_lab", scope: !274, file: !273, line: 968, type: !25, scopeLine: 968, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !14, templateParams: !26)
!273 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/alloc/src/vec/mod.rs", directory: "", checksumkind: CSK_MD5, checksum: "a93d3a7d4a1d55c9887c540882057a4f")
!274 = !DINamespace(name: "Vec", scope: !275)
!275 = !DINamespace(name: "vec", scope: !262)
!276 = !DILocation(line: 448, column: 29, scope: !277, inlinedAt: !284)
!277 = distinct !DILexicalBlock(scope: !279, file: !278, line: 447, column: 17)
!278 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/alloc/src/slice.rs", directory: "", checksumkind: CSK_MD5, checksum: "8e7bce5d617a4e88f7bdb700dff9d669")
!279 = distinct !DISubprogram(name: "to_vec<f64, alloc::alloc::Global>", linkageName: "_RINvXs_NvMNtCs6zY7rJBZy9D_5alloc5sliceSp9to_vec_indNtB5_10ConvertVec6to_vecNtNtBa_5alloc6GlobalECsfFAnx7WYh7o_12evidence_lab", scope: !280, file: !278, line: 446, type: !25, scopeLine: 446, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !14, templateParams: !26)
!280 = !DINamespace(name: "{impl#1}", scope: !281)
!281 = !DINamespace(name: "to_vec_in", scope: !282)
!282 = !DINamespace(name: "{impl#0}", scope: !283)
!283 = !DINamespace(name: "slice", scope: !262)
!284 = !DILocation(line: 400, column: 16, scope: !285, inlinedAt: !286)
!285 = distinct !DISubprogram(name: "to_vec_in<f64, alloc::alloc::Global>", linkageName: "_RINvMNtCs6zY7rJBZy9D_5alloc5sliceSd9to_vec_inNtNtB5_5alloc6GlobalECsfFAnx7WYh7o_12evidence_lab", scope: !282, file: !278, line: 396, type: !25, scopeLine: 396, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !14, templateParams: !26)
!286 = !DILocation(line: 376, column: 14, scope: !287, inlinedAt: !288)
!287 = distinct !DISubprogram(name: "to_vec<f64>", linkageName: "_RNvMNtCs6zY7rJBZy9D_5alloc5sliceSd6to_vecCsfFAnx7WYh7o_12evidence_lab", scope: !282, file: !278, line: 372, type: !25, scopeLine: 372, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !14, templateParams: !26)
!288 = !DILocation(line: 116, column: 30, scope: !289)
!289 = distinct !DILexicalBlock(scope: !174, file: !23, line: 114, column: 5)
!290 = !DILocation(line: 461, column: 12, scope: !291, inlinedAt: !266)
!291 = distinct !DILexicalBlock(scope: !264, file: !260, line: 455, column: 9)
!292 = !DILocation(line: 0, scope: !291, inlinedAt: !266)
!293 = !{!294}
!294 = distinct !{!294, !295, !"_RNvMs5_NtCs6zY7rJBZy9D_5alloc7raw_vecNtB5_11RawVecInner15try_allocate_inCsfFAnx7WYh7o_12evidence_lab: %_0"}
!295 = distinct !{!295, !"_RNvMs5_NtCs6zY7rJBZy9D_5alloc7raw_vecNtB5_11RawVecInner15try_allocate_inCsfFAnx7WYh7o_12evidence_lab"}
!296 = !DILocation(line: 130, column: 9, scope: !297, inlinedAt: !300)
!297 = distinct !DISubprogram(name: "alloc", linkageName: "_RNvNtCs6zY7rJBZy9D_5alloc5alloc5alloc", scope: !299, file: !298, line: 124, type: !25, scopeLine: 124, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !18, templateParams: !26)
!298 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/alloc/src/alloc.rs", directory: "", checksumkind: CSK_MD5, checksum: "87b4d0ba26e1dfe94542079de6981d97")
!299 = !DINamespace(name: "alloc", scope: !262)
!300 = distinct !DILocation(line: 302, column: 73, scope: !301, inlinedAt: !304)
!301 = distinct !DILexicalBlock(scope: !302, file: !298, line: 301, column: 13)
!302 = distinct !DISubprogram(name: "alloc_impl_runtime", linkageName: "_RNvMs0_NtCs6zY7rJBZy9D_5alloc5allocNtB5_6Global18alloc_impl_runtime", scope: !303, file: !298, line: 297, type: !25, scopeLine: 297, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !18, templateParams: !26)
!303 = !DINamespace(name: "Global", scope: !299)
!304 = distinct !DILocation(line: 424, column: 9, scope: !305, inlinedAt: !306)
!305 = distinct !DISubprogram(name: "alloc_impl", linkageName: "_RNvMs0_NtCs6zY7rJBZy9D_5alloc5allocNtB5_6Global10alloc_impl", scope: !303, file: !298, line: 423, type: !25, scopeLine: 423, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !18, templateParams: !26)
!306 = distinct !DILocation(line: 541, column: 14, scope: !307, inlinedAt: !309)
!307 = distinct !DISubprogram(name: "allocate", linkageName: "_RNvXs1_NtCs6zY7rJBZy9D_5alloc5allocNtB5_6GlobalNtNtCsjIpoRzUjyHQ_4core5alloc9Allocator8allocate", scope: !308, file: !298, line: 540, type: !64, scopeLine: 540, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !18, templateParams: !26)
!308 = !DINamespace(name: "{impl#3}", scope: !299)
!309 = distinct !DILocation(line: 466, column: 47, scope: !291, inlinedAt: !266)
!310 = !DILocation(line: 470, column: 25, scope: !311, inlinedAt: !266)
!311 = distinct !DILexicalBlock(scope: !291, file: !260, line: 465, column: 9)
!312 = !DILocation(line: 470, column: 19, scope: !311, inlinedAt: !266)
!313 = !DILocation(line: 443, column: 25, scope: !314, inlinedAt: !268)
!314 = distinct !DILexicalBlock(scope: !267, file: !260, line: 443, column: 13)
!315 = !{!316}
!316 = distinct !{!316, !317, !"_RINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtCsjIpoRzUjyHQ_4core3f64d9total_cmpECsfFAnx7WYh7o_12evidence_lab: %self.0:thread"}
!317 = distinct !{!317, !"_RINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtCsjIpoRzUjyHQ_4core3f64d9total_cmpECsfFAnx7WYh7o_12evidence_lab"}
!318 = !DILocation(line: 455, column: 8, scope: !319, inlinedAt: !320)
!319 = distinct !DISubprogram(name: "likely", linkageName: "_RNvNtCsjIpoRzUjyHQ_4core10intrinsics6likely", scope: !96, file: !95, line: 454, type: !25, scopeLine: 454, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !14, templateParams: !26)
!320 = distinct !DILocation(line: 38, column: 8, scope: !321, inlinedAt: !326)
!321 = distinct !DILexicalBlock(scope: !323, file: !322, line: 37, column: 5)
!322 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/slice/sort/stable/mod.rs", directory: "", checksumkind: CSK_MD5, checksum: "943c9866fee121b7ec645aa6171a994f")
!323 = distinct !DISubprogram(name: "sort<f64, alloc::slice::{impl#0}::sort_by::{closure_env#0}<f64, fn(&f64, &f64) -> core::cmp::Ordering>, alloc::vec::Vec<f64, alloc::alloc::Global>>", linkageName: "_RINvNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6stable4sortdNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtB8_3f64d9total_cmpE0INtNtBX_3vec3VecdEECsfFAnx7WYh7o_12evidence_lab", scope: !324, file: !322, line: 29, type: !25, scopeLine: 29, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !14, templateParams: !26)
!324 = !DINamespace(name: "stable", scope: !325)
!325 = !DINamespace(name: "sort", scope: !56)
!326 = distinct !DILocation(line: 857, column: 5, scope: !327, inlinedAt: !328)
!327 = distinct !DISubprogram(name: "stable_sort<f64, alloc::slice::{impl#0}::sort_by::{closure_env#0}<f64, fn(&f64, &f64) -> core::cmp::Ordering>>", linkageName: "_RINvNtCs6zY7rJBZy9D_5alloc5slice11stable_sortdNCINvMB2_Sd7sort_byNvMNtCsjIpoRzUjyHQ_4core3f64d9total_cmpE0ECsfFAnx7WYh7o_12evidence_lab", scope: !283, file: !278, line: 853, type: !25, scopeLine: 853, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !14, templateParams: !26)
!328 = distinct !DILocation(line: 196, column: 9, scope: !329, inlinedAt: !330)
!329 = distinct !DISubprogram(name: "sort_by<f64, fn(&f64, &f64) -> core::cmp::Ordering>", linkageName: "_RINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtCsjIpoRzUjyHQ_4core3f64d9total_cmpECsfFAnx7WYh7o_12evidence_lab", scope: !282, file: !278, line: 192, type: !25, scopeLine: 192, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !14, templateParams: !26)
!330 = distinct !DILocation(line: 117, column: 12, scope: !331)
!331 = distinct !DILexicalBlock(scope: !289, file: !23, line: 116, column: 5)
!332 = !DILocation(line: 573, column: 14, scope: !333, inlinedAt: !335)
!333 = distinct !DISubprogram(name: "copy_nonoverlapping<f64>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3ptr19copy_nonoverlappingdECsfFAnx7WYh7o_12evidence_lab", scope: !71, file: !334, line: 552, type: !25, scopeLine: 552, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !14, templateParams: !26)
!334 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/ptr/mod.rs", directory: "", checksumkind: CSK_MD5, checksum: "59033ebc630da002040513c25c9de121")
!335 = !DILocation(line: 1235, column: 18, scope: !336, inlinedAt: !340)
!336 = distinct !DISubprogram(name: "copy_to_nonoverlapping<f64>", linkageName: "_RNvMNtNtCsjIpoRzUjyHQ_4core3ptr9const_ptrPd22copy_to_nonoverlappingCsfFAnx7WYh7o_12evidence_lab", scope: !338, file: !337, line: 1230, type: !25, scopeLine: 1230, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !14, templateParams: !26)
!337 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/ptr/const_ptr.rs", directory: "", checksumkind: CSK_MD5, checksum: "25118ae25e729b7c815218b31622724c")
!338 = !DINamespace(name: "{impl#0}", scope: !339)
!339 = !DINamespace(name: "const_ptr", scope: !71)
!340 = !DILocation(line: 454, column: 36, scope: !341, inlinedAt: !284)
!341 = distinct !DILexicalBlock(scope: !277, file: !278, line: 448, column: 17)
!342 = !{!343}
!343 = distinct !{!343, !317, !"_RINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtCsjIpoRzUjyHQ_4core3f64d9total_cmpECsfFAnx7WYh7o_12evidence_lab: %self.0"}
!344 = !{!345, !347, !343}
!345 = distinct !{!345, !346, !"_RINvNtCs6zY7rJBZy9D_5alloc5slice11stable_sortdNCINvMB2_Sd7sort_byNvMNtCsjIpoRzUjyHQ_4core3f64d9total_cmpE0ECsfFAnx7WYh7o_12evidence_lab: %v.0"}
!346 = distinct !{!346, !"_RINvNtCs6zY7rJBZy9D_5alloc5slice11stable_sortdNCINvMB2_Sd7sort_byNvMNtCsjIpoRzUjyHQ_4core3f64d9total_cmpE0ECsfFAnx7WYh7o_12evidence_lab"}
!347 = distinct !{!347, !346, !"_RINvNtCs6zY7rJBZy9D_5alloc5slice11stable_sortdNCINvMB2_Sd7sort_byNvMNtCsjIpoRzUjyHQ_4core3f64d9total_cmpE0ECsfFAnx7WYh7o_12evidence_lab: argument 1"}
!348 = !DILocation(line: 38, column: 27, scope: !321, inlinedAt: !326)
!349 = !{!"branch_weights", !"expected", i32 2145766520, i32 1717128}
!350 = !DILocation(line: 78, column: 35, scope: !321, inlinedAt: !326)
!351 = !DILocation(line: 455, column: 8, scope: !319, inlinedAt: !352)
!352 = distinct !DILocation(line: 78, column: 16, scope: !321, inlinedAt: !326)
!353 = !DILocation(line: 83, column: 13, scope: !321, inlinedAt: !326)
!354 = !DILocation(line: 631, column: 39, scope: !355, inlinedAt: !356)
!355 = distinct !DISubprogram(name: "current_memory<alloc::alloc::Global>", linkageName: "_RNvMs2_NtCs6zY7rJBZy9D_5alloc7raw_vecNtB5_11RawVecInner14current_memoryCsfFAnx7WYh7o_12evidence_lab", scope: !265, file: !260, line: 630, type: !64, scopeLine: 630, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !18, templateParams: !26)
!356 = distinct !DILocation(line: 874, column: 52, scope: !357, inlinedAt: !359)
!357 = distinct !DILexicalBlock(scope: !358, file: !260, line: 874, column: 82)
!358 = distinct !DISubprogram(name: "deallocate<alloc::alloc::Global>", linkageName: "_RNvMs3_NtCs6zY7rJBZy9D_5alloc7raw_vecNtB5_11RawVecInner10deallocateCsfFAnx7WYh7o_12evidence_lab", scope: !265, file: !260, line: 872, type: !64, scopeLine: 872, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !18, templateParams: !26)
!359 = distinct !DILocation(line: 425, column: 29, scope: !360, inlinedAt: !362)
!360 = distinct !DISubprogram(name: "drop<f64, alloc::alloc::Global>", linkageName: "_RNvXs1_NtCs6zY7rJBZy9D_5alloc7raw_vecINtB5_6RawVecdENtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4dropCsfFAnx7WYh7o_12evidence_lab", scope: !361, file: !260, line: 423, type: !25, scopeLine: 423, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !18, templateParams: !26)
!361 = !DINamespace(name: "{impl#3}", scope: !261)
!362 = distinct !DILocation(line: 847, column: 1, scope: !363, inlinedAt: !364)
!363 = distinct !DISubprogram(name: "drop_glue<alloc::raw_vec::RawVec<f64, alloc::alloc::Global>>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc7raw_vec6RawVecdEECsfFAnx7WYh7o_12evidence_lab", scope: !71, file: !334, line: 847, type: !25, scopeLine: 847, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !14, templateParams: !26)
!364 = distinct !DILocation(line: 847, column: 1, scope: !365, inlinedAt: !366)
!365 = distinct !DISubprogram(name: "drop_glue<alloc::vec::Vec<f64, alloc::alloc::Global>>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtCs6zY7rJBZy9D_5alloc3vec3VecdEECsfFAnx7WYh7o_12evidence_lab", scope: !71, file: !334, line: 847, type: !64, scopeLine: 847, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !14, templateParams: !26)
!366 = distinct !DILocation(line: 124, column: 1, scope: !289)
!367 = !DILocation(line: 79, column: 17, scope: !321, inlinedAt: !326)
!368 = !DILocation(line: 1401, column: 17, scope: !369, inlinedAt: !370)
!369 = distinct !DISubprogram(name: "unchecked_mul", linkageName: "_RNvMs9_NtCsjIpoRzUjyHQ_4core3numj13unchecked_mul", scope: !194, file: !89, line: 1389, type: !25, scopeLine: 1389, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !18, templateParams: !26)
!370 = distinct !DILocation(line: 639, column: 53, scope: !355, inlinedAt: !356)
!371 = !DILocation(line: 175, column: 14, scope: !372, inlinedAt: !373)
!372 = distinct !DISubprogram(name: "dealloc_nonnull", linkageName: "_RNvNtCs6zY7rJBZy9D_5alloc5alloc15dealloc_nonnull", scope: !299, file: !298, line: 174, type: !25, scopeLine: 174, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !18, templateParams: !26)
!373 = distinct !DILocation(line: 321, column: 22, scope: !374, inlinedAt: !375)
!374 = distinct !DISubprogram(name: "deallocate_impl_runtime", linkageName: "_RNvMs0_NtCs6zY7rJBZy9D_5alloc5allocNtB5_6Global23deallocate_impl_runtime", scope: !303, file: !298, line: 311, type: !25, scopeLine: 311, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !18, templateParams: !26)
!375 = distinct !DILocation(line: 436, column: 9, scope: !376, inlinedAt: !377)
!376 = distinct !DISubprogram(name: "deallocate_impl", linkageName: "_RNvMs0_NtCs6zY7rJBZy9D_5alloc5allocNtB5_6Global15deallocate_impl", scope: !303, file: !298, line: 435, type: !25, scopeLine: 435, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !18, templateParams: !26)
!377 = distinct !DILocation(line: 554, column: 23, scope: !378, inlinedAt: !379)
!378 = distinct !DISubprogram(name: "deallocate", linkageName: "_RNvXs1_NtCs6zY7rJBZy9D_5alloc5allocNtB5_6GlobalNtNtCsjIpoRzUjyHQ_4core5alloc9Allocator10deallocate", scope: !308, file: !298, line: 552, type: !64, scopeLine: 552, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !18, templateParams: !26)
!379 = distinct !DILocation(line: 876, column: 28, scope: !357, inlinedAt: !359)
!380 = !{!381}
!381 = distinct !{!381, !382, !"_RNvXs1_NtCs6zY7rJBZy9D_5alloc7raw_vecINtB5_6RawVecdENtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4dropCsfFAnx7WYh7o_12evidence_lab: %self"}
!382 = distinct !{!382, !"_RNvXs1_NtCs6zY7rJBZy9D_5alloc7raw_vecINtB5_6RawVecdENtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4dropCsfFAnx7WYh7o_12evidence_lab"}
!383 = !DILocation(line: 312, column: 9, scope: !374, inlinedAt: !375)
!384 = !DILocation(line: 858, column: 2, scope: !327, inlinedAt: !328)
!385 = !DILocation(line: 120, column: 9, scope: !331)
!386 = !DILocation(line: 121, column: 9, scope: !331)
!387 = !DILocation(line: 98, column: 31, scope: !22, inlinedAt: !388)
!388 = distinct !DILocation(line: 121, column: 9, scope: !331)
!389 = !DILocation(line: 98, column: 16, scope: !22, inlinedAt: !388)
!390 = !DILocation(line: 1831, column: 9, scope: !31, inlinedAt: !391)
!391 = distinct !DILocation(line: 75, column: 9, scope: !37, inlinedAt: !392)
!392 = distinct !DILocation(line: 98, column: 52, scope: !22, inlinedAt: !388)
!393 = !DILocation(line: 99, column: 12, scope: !44, inlinedAt: !388)
!394 = !DILocation(line: 99, column: 5, scope: !44, inlinedAt: !388)
!395 = !{!396}
!396 = distinct !{!396, !397, !"_RNvCsfFAnx7WYh7o_12evidence_lab12nearest_rank: %sorted.0"}
!397 = distinct !{!397, !"_RNvCsfFAnx7WYh7o_12evidence_lab12nearest_rank"}
!398 = !DILocation(line: 122, column: 9, scope: !331)
!399 = !DILocation(line: 98, column: 16, scope: !22, inlinedAt: !400)
!400 = distinct !DILocation(line: 122, column: 9, scope: !331)
!401 = !DILocation(line: 1831, column: 9, scope: !31, inlinedAt: !402)
!402 = distinct !DILocation(line: 75, column: 9, scope: !37, inlinedAt: !403)
!403 = distinct !DILocation(line: 98, column: 52, scope: !22, inlinedAt: !400)
!404 = !DILocation(line: 99, column: 12, scope: !44, inlinedAt: !400)
!405 = !DILocation(line: 99, column: 5, scope: !44, inlinedAt: !400)
!406 = !DILocation(line: 99, column: 5, scope: !44, inlinedAt: !407)
!407 = !DILocation(line: 0, scope: !331)
!408 = !{!409}
!409 = distinct !{!409, !410, !"_RNvCsfFAnx7WYh7o_12evidence_lab12nearest_rank: %sorted.0"}
!410 = distinct !{!410, !"_RNvCsfFAnx7WYh7o_12evidence_lab12nearest_rank"}
!411 = !DILocation(line: 118, column: 5, scope: !412)
!412 = !DILexicalBlockFile(scope: !413, file: !23, discriminator: 0)
!413 = distinct !DILexicalBlock(scope: !331, file: !414, line: 148, column: 28)
!414 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/std/src/macros.rs", directory: "", checksumkind: CSK_MD5, checksum: "2da795cca9929b416fe81779263e01a7")
!415 = !DILocation(line: 118, column: 5, scope: !331)
!416 = !DILocation(line: 631, column: 39, scope: !355, inlinedAt: !417)
!417 = distinct !DILocation(line: 874, column: 52, scope: !357, inlinedAt: !418)
!418 = distinct !DILocation(line: 425, column: 29, scope: !360, inlinedAt: !419)
!419 = distinct !DILocation(line: 847, column: 1, scope: !363, inlinedAt: !420)
!420 = distinct !DILocation(line: 847, column: 1, scope: !365, inlinedAt: !421)
!421 = distinct !DILocation(line: 124, column: 1, scope: !289)
!422 = !DILocation(line: 1401, column: 17, scope: !369, inlinedAt: !423)
!423 = distinct !DILocation(line: 639, column: 53, scope: !355, inlinedAt: !417)
!424 = !DILocation(line: 175, column: 14, scope: !372, inlinedAt: !425)
!425 = distinct !DILocation(line: 321, column: 22, scope: !374, inlinedAt: !426)
!426 = distinct !DILocation(line: 436, column: 9, scope: !376, inlinedAt: !427)
!427 = distinct !DILocation(line: 554, column: 23, scope: !378, inlinedAt: !428)
!428 = distinct !DILocation(line: 876, column: 28, scope: !357, inlinedAt: !418)
!429 = !{!430}
!430 = distinct !{!430, !431, !"_RNvXs1_NtCs6zY7rJBZy9D_5alloc7raw_vecINtB5_6RawVecdENtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4dropCsfFAnx7WYh7o_12evidence_lab: %self"}
!431 = distinct !{!431, !"_RNvXs1_NtCs6zY7rJBZy9D_5alloc7raw_vecINtB5_6RawVecdENtNtNtCsjIpoRzUjyHQ_4core3ops4drop4Drop4dropCsfFAnx7WYh7o_12evidence_lab"}
!432 = !DILocation(line: 312, column: 9, scope: !374, inlinedAt: !426)
!433 = !DILocation(line: 124, column: 1, scope: !174)
!434 = !DILocation(line: 124, column: 1, scope: !106)
!435 = !DILocation(line: 124, column: 2, scope: !106)
!436 = !DILocation(line: 0, scope: !106)
!437 = distinct !DISubprogram(name: "compute", linkageName: "_RNvCsfFAnx7WYh7o_12evidence_lab7compute", scope: !24, file: !23, line: 25, type: !25, scopeLine: 25, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !14, templateParams: !26)
!438 = !{i64 -7234282963042766396}
!439 = !DILocation(line: 2144, column: 50, scope: !440, inlinedAt: !445)
!440 = distinct !DISubprogram(name: "lt", linkageName: "_RNvXs12_NtNtCsjIpoRzUjyHQ_4core3cmp5implsyNtB8_10PartialOrd2lt", scope: !442, file: !441, line: 2144, type: !25, scopeLine: 2144, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !14, templateParams: !26)
!441 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/cmp.rs", directory: "", checksumkind: CSK_MD5, checksum: "49e2a03e6445d88887d9438f640a7fcc")
!442 = !DINamespace(name: "{impl#66}", scope: !443)
!443 = !DINamespace(name: "impls", scope: !444)
!444 = !DINamespace(name: "cmp", scope: !35)
!445 = !DILocation(line: 1100, column: 12, scope: !446, inlinedAt: !450)
!446 = distinct !DISubprogram(name: "spec_next<u64>", linkageName: "_RNvXs3_NtNtCsjIpoRzUjyHQ_4core4iter5rangeINtNtNtB9_3ops5range5RangeyENtB5_17RangeIteratorImpl9spec_nextCsfFAnx7WYh7o_12evidence_lab", scope: !448, file: !447, line: 1099, type: !25, scopeLine: 1099, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !14, templateParams: !26)
!447 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/iter/range.rs", directory: "", checksumkind: CSK_MD5, checksum: "6038fbd2305f6e8ce8c79c7d50b4046d")
!448 = !DINamespace(name: "{impl#5}", scope: !449)
!449 = !DINamespace(name: "range", scope: !137)
!450 = !DILocation(line: 1185, column: 14, scope: !451, inlinedAt: !453)
!451 = distinct !DISubprogram(name: "next<u64>", linkageName: "_RNvXs4_NtNtCsjIpoRzUjyHQ_4core4iter5rangeINtNtNtB9_3ops5range5RangeyENtNtNtB7_6traits8iterator8Iterator4nextCsfFAnx7WYh7o_12evidence_lab", scope: !452, file: !447, line: 1184, type: !25, scopeLine: 1184, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !14, templateParams: !26)
!452 = !DINamespace(name: "{impl#6}", scope: !449)
!453 = !DILocation(line: 27, column: 14, scope: !454)
!454 = !DILexicalBlockFile(scope: !455, file: !23, discriminator: 2)
!455 = distinct !DILexicalBlock(scope: !456, file: !23, line: 27, column: 5)
!456 = distinct !DILexicalBlock(scope: !437, file: !23, line: 26, column: 5)
!457 = !DILocation(line: 0, scope: !437)
!458 = !DILocation(line: 31, column: 2, scope: !437)
!459 = !DILocation(line: 1013, column: 17, scope: !460, inlinedAt: !461)
!460 = distinct !DISubprogram(name: "unchecked_add", linkageName: "_RNvMs7_NtCsjIpoRzUjyHQ_4core3numy13unchecked_add", scope: !90, file: !89, line: 1001, type: !25, scopeLine: 1001, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !14, templateParams: !26)
!461 = !DILocation(line: 265, column: 28, scope: !462, inlinedAt: !464)
!462 = distinct !DISubprogram(name: "forward_unchecked", linkageName: "_RNvXsJ_NtNtCsjIpoRzUjyHQ_4core4iter5rangeyNtB5_4Step17forward_unchecked", scope: !463, file: !447, line: 263, type: !25, scopeLine: 263, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !14, templateParams: !26)
!463 = !DINamespace(name: "{impl#47}", scope: !449)
!464 = !DILocation(line: 1103, column: 35, scope: !465, inlinedAt: !450)
!465 = distinct !DILexicalBlock(scope: !446, file: !447, line: 1101, column: 13)
!466 = !DILocation(line: 28, column: 17, scope: !455)
!467 = distinct !DISubprogram(name: "observed", linkageName: "_RNvCsfFAnx7WYh7o_12evidence_lab8observed", scope: !24, file: !23, line: 45, type: !25, scopeLine: 45, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !14, templateParams: !26)
!468 = !{i64 3889799606926820401}
!469 = !DILocation(line: 46, column: 9, scope: !467)
!470 = !DILocation(line: 2668, column: 26, scope: !471, inlinedAt: !476)
!471 = distinct !DISubprogram(name: "new", linkageName: "_RNvMs10_NtNtCsjIpoRzUjyHQ_4core4sync6atomicINtB6_6AtomicyE3new", scope: !473, file: !472, line: 2665, type: !25, scopeLine: 2665, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !14, templateParams: !26)
!472 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/sync/atomic.rs", directory: "", checksumkind: CSK_MD5, checksum: "51c6a96ef01c6a3d76d0125641245f4c")
!473 = !DINamespace(name: "Atomic", scope: !474)
!474 = !DINamespace(name: "atomic", scope: !475)
!475 = !DINamespace(name: "sync", scope: !35)
!476 = !DILocation(line: 46, column: 19, scope: !467)
!477 = !DILocation(line: 2144, column: 50, scope: !478, inlinedAt: !479)
!478 = distinct !DISubprogram(name: "lt", linkageName: "_RNvXs12_NtNtCsjIpoRzUjyHQ_4core3cmp5implsyNtB8_10PartialOrd2lt", scope: !442, file: !441, line: 2144, type: !25, scopeLine: 2144, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !14, templateParams: !26)
!479 = !DILocation(line: 1100, column: 12, scope: !480, inlinedAt: !481)
!480 = distinct !DISubprogram(name: "spec_next<u64>", linkageName: "_RNvXs3_NtNtCsjIpoRzUjyHQ_4core4iter5rangeINtNtNtB9_3ops5range5RangeyENtB5_17RangeIteratorImpl9spec_nextCsfFAnx7WYh7o_12evidence_lab", scope: !448, file: !447, line: 1099, type: !25, scopeLine: 1099, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !14, templateParams: !26)
!481 = !DILocation(line: 1185, column: 14, scope: !482, inlinedAt: !483)
!482 = distinct !DISubprogram(name: "next<u64>", linkageName: "_RNvXs4_NtNtCsjIpoRzUjyHQ_4core4iter5rangeINtNtNtB9_3ops5range5RangeyENtNtNtB7_6traits8iterator8Iterator4nextCsfFAnx7WYh7o_12evidence_lab", scope: !452, file: !447, line: 1184, type: !25, scopeLine: 1184, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !14, templateParams: !26)
!483 = !DILocation(line: 48, column: 15, scope: !484)
!484 = !DILexicalBlockFile(scope: !485, file: !23, discriminator: 2)
!485 = distinct !DILexicalBlock(scope: !486, file: !23, line: 48, column: 5)
!486 = distinct !DILexicalBlock(scope: !487, file: !23, line: 47, column: 5)
!487 = distinct !DILexicalBlock(scope: !467, file: !23, line: 46, column: 5)
!488 = !DILocation(line: 1013, column: 17, scope: !489, inlinedAt: !490)
!489 = distinct !DISubprogram(name: "unchecked_add", linkageName: "_RNvMs7_NtCsjIpoRzUjyHQ_4core3numy13unchecked_add", scope: !90, file: !89, line: 1001, type: !25, scopeLine: 1001, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !14, templateParams: !26)
!490 = !DILocation(line: 265, column: 28, scope: !491, inlinedAt: !492)
!491 = distinct !DISubprogram(name: "forward_unchecked", linkageName: "_RNvXsJ_NtNtCsjIpoRzUjyHQ_4core4iter5rangeyNtB5_4Step17forward_unchecked", scope: !463, file: !447, line: 263, type: !25, scopeLine: 263, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !14, templateParams: !26)
!492 = !DILocation(line: 1103, column: 35, scope: !493, inlinedAt: !481)
!493 = distinct !DILexicalBlock(scope: !480, file: !447, line: 1101, column: 13)
!494 = !DILocation(line: 250, column: 5, scope: !495, inlinedAt: !499)
!495 = distinct !DISubprogram(name: "call_once<fn() -> std::time::Instant, ()>", linkageName: "_RNvYNvMNtCs1SSuMAdGM58_3std4timeNtB5_7Instant3nowINtNtNtCsjIpoRzUjyHQ_4core3ops8function6FnOnceuE9call_onceCsfFAnx7WYh7o_12evidence_lab", scope: !497, file: !496, line: 250, type: !25, scopeLine: 250, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !14, templateParams: !26)
!496 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/ops/function.rs", directory: "", checksumkind: CSK_MD5, checksum: "ae01f833f82cd27aa916c99d95502941")
!497 = !DINamespace(name: "FnOnce", scope: !498)
!498 = !DINamespace(name: "function", scope: !160)
!499 = !DILocation(line: 66, column: 24, scope: !500, inlinedAt: !504)
!500 = distinct !DISubprogram(name: "then<std::time::Instant, fn() -> std::time::Instant>", linkageName: "_RINvMNtCsjIpoRzUjyHQ_4core4boolb4thenNtNtCs1SSuMAdGM58_3std4time7InstantNvMBB_Bz_3nowECsfFAnx7WYh7o_12evidence_lab", scope: !502, file: !501, line: 65, type: !25, scopeLine: 65, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !14, templateParams: !26)
!501 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/bool.rs", directory: "", checksumkind: CSK_MD5, checksum: "8f51a00fcc06f71cb9f0938e1e244e8a")
!502 = !DINamespace(name: "{impl#0}", scope: !503)
!503 = !DINamespace(name: "bool", scope: !35)
!504 = !DILocation(line: 49, column: 48, scope: !505)
!505 = distinct !DILexicalBlock(scope: !485, file: !23, line: 48, column: 5)
!506 = !DILocation(line: 50, column: 17, scope: !507)
!507 = distinct !DILexicalBlock(scope: !505, file: !23, line: 49, column: 9)
!508 = !DILocation(line: 51, column: 21, scope: !509)
!509 = distinct !DILexicalBlock(scope: !507, file: !23, line: 51, column: 36)
!510 = !DILocation(line: 52, column: 13, scope: !509)
!511 = !DILocation(line: 54, column: 35, scope: !509)
!512 = !DILocation(line: 632, column: 9, scope: !513, inlinedAt: !517)
!513 = distinct !DISubprogram(name: "as_nanos", linkageName: "_RNvMNtCsjIpoRzUjyHQ_4core4timeNtB2_8Duration8as_nanos", scope: !515, file: !514, line: 631, type: !25, scopeLine: 631, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !14, templateParams: !26)
!514 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/time.rs", directory: "", checksumkind: CSK_MD5, checksum: "cd970f898658d081a7396ea0a414e543")
!515 = !DINamespace(name: "Duration", scope: !516)
!516 = !DINamespace(name: "time", scope: !35)
!517 = !DILocation(line: 54, column: 45, scope: !509)
!518 = !DILocation(line: 49, column: 26, scope: !519, inlinedAt: !523)
!519 = distinct !DISubprogram(name: "as_inner", linkageName: "_RNvMs6_NtNtCsjIpoRzUjyHQ_4core3num11niche_typesNtB5_11Nanoseconds8as_inner", scope: !521, file: !520, line: 46, type: !25, scopeLine: 46, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !14, templateParams: !26)
!520 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/num/niche_types.rs", directory: "", checksumkind: CSK_MD5, checksum: "489873530aeeab72b6610b8d531aed40")
!521 = !DINamespace(name: "Nanoseconds", scope: !522)
!522 = !DINamespace(name: "niche_types", scope: !91)
!523 = !DILocation(line: 632, column: 64, scope: !513, inlinedAt: !517)
!524 = !DILocation(line: 632, column: 53, scope: !513, inlinedAt: !517)
!525 = !DILocation(line: 491, column: 5, scope: !526, inlinedAt: !510)
!526 = distinct !DISubprogram(name: "black_box<evidence_lab::Event>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core4hint9black_boxNtCsfFAnx7WYh7o_12evidence_lab5EventEBE_", scope: !85, file: !84, line: 490, type: !25, scopeLine: 490, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !14, templateParams: !26)
!527 = !DILocation(line: 55, column: 15, scope: !509)
!528 = !DILocation(line: 4029, column: 24, scope: !529, inlinedAt: !530)
!529 = distinct !DISubprogram(name: "atomic_add<u64, u64>", linkageName: "_RINvNtNtCsjIpoRzUjyHQ_4core4sync6atomic10atomic_addyyECsfFAnx7WYh7o_12evidence_lab", scope: !474, file: !472, line: 4025, type: !25, scopeLine: 4025, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !14, templateParams: !26)
!530 = !DILocation(line: 3220, column: 26, scope: !531, inlinedAt: !532)
!531 = distinct !DISubprogram(name: "fetch_add", linkageName: "_RNvMs10_NtNtCsjIpoRzUjyHQ_4core4sync6atomicINtB6_6AtomicyE9fetch_add", scope: !473, file: !472, line: 3218, type: !25, scopeLine: 3218, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !14, templateParams: !26)
!532 = !DILocation(line: 56, column: 21, scope: !509)
!533 = !DILocation(line: 57, column: 9, scope: !507)
!534 = !DILocation(line: 0, scope: !487)
!535 = !DILocation(line: 59, column: 8, scope: !536)
!536 = !DILexicalBlockFile(scope: !537, file: !23, discriminator: 0)
!537 = distinct !DILexicalBlock(scope: !486, file: !538, line: 434, column: 9)
!538 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/macros/mod.rs", directory: "", checksumkind: CSK_MD5, checksum: "2f18ff6bcbb078f77779c8f14def2c67")
!539 = !DILocation(line: 3994, column: 24, scope: !540, inlinedAt: !541)
!540 = distinct !DISubprogram(name: "atomic_load<u64>", linkageName: "_RINvNtNtCsjIpoRzUjyHQ_4core4sync6atomic11atomic_loadyECsfFAnx7WYh7o_12evidence_lab", scope: !474, file: !472, line: 3990, type: !25, scopeLine: 3990, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !14, templateParams: !26)
!541 = distinct !DILocation(line: 2916, column: 26, scope: !542, inlinedAt: !543)
!542 = distinct !DISubprogram(name: "load", linkageName: "_RNvMs10_NtNtCsjIpoRzUjyHQ_4core4sync6atomicINtB6_6AtomicyE4load", scope: !473, file: !472, line: 2914, type: !25, scopeLine: 2914, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !14, templateParams: !26)
!543 = !DILocation(line: 62, column: 21, scope: !486)
!544 = !DILocation(line: 63, column: 1, scope: !467)
!545 = !DILocation(line: 63, column: 2, scope: !467)
!546 = !DILocation(line: 4029, column: 24, scope: !529, inlinedAt: !547)
!547 = !DILocation(line: 3220, column: 26, scope: !548, inlinedAt: !549)
!548 = !DILexicalBlockFile(scope: !531, file: !472, discriminator: 2)
!549 = !DILocation(line: 60, column: 17, scope: !486)
!550 = !DILocation(line: 59, column: 5, scope: !486)
!551 = distinct !DISubprogram(name: "sum_bytes", linkageName: "_RNvCsfFAnx7WYh7o_12evidence_lab9sum_bytes", scope: !24, file: !23, line: 71, type: !25, scopeLine: 71, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition | DISPFlagOptimized, unit: !14, templateParams: !26)
!552 = !{i64 -2502142973024343684}
!553 = !DILocation(line: 1663, column: 9, scope: !554, inlinedAt: !555)
!554 = distinct !DISubprogram(name: "eq<u8>", linkageName: "_RNvXsd_NtNtCsjIpoRzUjyHQ_4core3ptr8non_nullINtB5_7NonNullhENtNtB9_3cmp9PartialEq2eqCsfFAnx7WYh7o_12evidence_lab", scope: !69, file: !68, line: 1662, type: !25, scopeLine: 1662, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !14, templateParams: !26)
!555 = distinct !DILocation(line: 44, column: 20, scope: !556, inlinedAt: !559)
!556 = distinct !DILexicalBlock(scope: !557, file: !52, line: 33, column: 13)
!557 = distinct !DILexicalBlock(scope: !558, file: !52, line: 25, column: 86)
!558 = distinct !DISubprogram(name: "fold<u8, u64, core::iter::adapters::map::map_fold::{closure_env#0}<&u8, u64, u64, evidence_lab::sum_bytes::{closure_env#0}, core::iter::traits::accum::{impl#40}::sum::{closure_env#0}<core::iter::adapters::map::Map<core::slice::iter::Iter<u8>, evidence_lab::sum_bytes::{closure_env#0}>>>>", linkageName: "_RINvXs2J_NtNtCsjIpoRzUjyHQ_4core5slice4iterINtB7_4IterhENtNtNtNtBb_4iter6traits8iterator8Iterator4foldyNCINvNtNtBY_8adapters3map8map_foldRhyyNCNvCsfFAnx7WYh7o_12evidence_lab9sum_bytes0NCINvXsC_NtBW_5accumyNtB35_3Sum3sumINtB1I_3MapBF_B2f_EE0E0EB2j_", scope: !54, file: !52, line: 254, type: !25, scopeLine: 254, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !14, templateParams: !26)
!559 = distinct !DILocation(line: 128, column: 19, scope: !560, inlinedAt: !561)
!560 = distinct !DISubprogram(name: "fold<u64, core::slice::iter::Iter<u8>, evidence_lab::sum_bytes::{closure_env#0}, u64, core::iter::traits::accum::{impl#40}::sum::{closure_env#0}<core::iter::adapters::map::Map<core::slice::iter::Iter<u8>, evidence_lab::sum_bytes::{closure_env#0}>>>", linkageName: "_RINvXs0_NtNtNtCsjIpoRzUjyHQ_4core4iter8adapters3mapINtB6_3MapINtNtNtBc_5slice4iter4IterhENCNvCsfFAnx7WYh7o_12evidence_lab9sum_bytes0ENtNtNtBa_6traits8iterator8Iterator4foldyNCINvXsC_NtB2b_5accumyNtB2U_3Sum3sumBN_E0EB1t_", scope: !181, file: !180, line: 124, type: !25, scopeLine: 124, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !14, templateParams: !26)
!561 = !DILocation(line: 52, column: 22, scope: !562, inlinedAt: !564)
!562 = distinct !DISubprogram(name: "sum<core::iter::adapters::map::Map<core::slice::iter::Iter<u8>, evidence_lab::sum_bytes::{closure_env#0}>>", linkageName: "_RINvXsC_NtNtNtCsjIpoRzUjyHQ_4core4iter6traits5accumyNtB6_3Sum3sumINtNtNtBa_8adapters3map3MapINtNtNtBc_5slice4iter4IterhENCNvCsfFAnx7WYh7o_12evidence_lab9sum_bytes0EEB1Y_", scope: !563, file: !133, line: 51, type: !25, scopeLine: 51, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !14, templateParams: !26)
!563 = !DINamespace(name: "{impl#40}", scope: !135)
!564 = !DILocation(line: 3670, column: 9, scope: !565, inlinedAt: !566)
!565 = distinct !DISubprogram(name: "sum<core::iter::adapters::map::Map<core::slice::iter::Iter<u8>, evidence_lab::sum_bytes::{closure_env#0}>, u64>", linkageName: "_RINvYINtNtNtNtCsjIpoRzUjyHQ_4core4iter8adapters3map3MapINtNtNtBc_5slice4iter4IterhENCNvCsfFAnx7WYh7o_12evidence_lab9sum_bytes0ENtNtNtBa_6traits8iterator8Iterator3sumyEB1n_", scope: !141, file: !140, line: 3665, type: !25, scopeLine: 3665, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !14, templateParams: !26)
!566 = !DILocation(line: 82, column: 10, scope: !551)
!567 = !DILocation(line: 25, column: 86, scope: !557, inlinedAt: !559)
!568 = !DILocation(line: 279, column: 24, scope: !569, inlinedAt: !559)
!569 = distinct !DILexicalBlock(scope: !570, file: !52, line: 270, column: 17)
!570 = distinct !DILexicalBlock(scope: !571, file: !52, line: 269, column: 17)
!571 = distinct !DILexicalBlock(scope: !558, file: !52, line: 268, column: 17)
!572 = !DILocation(line: 0, scope: !571, inlinedAt: !559)
!573 = !DILocation(line: 627, column: 28, scope: !574, inlinedAt: !575)
!574 = distinct !DISubprogram(name: "add<u8>", linkageName: "_RNvMs1_NtNtCsjIpoRzUjyHQ_4core3ptr8non_nullINtB5_7NonNullhE3addCsfFAnx7WYh7o_12evidence_lab", scope: !152, file: !68, line: 619, type: !25, scopeLine: 619, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !14, templateParams: !26)
!575 = distinct !DILocation(line: 274, column: 67, scope: !569, inlinedAt: !559)
!576 = !DILocation(line: 274, column: 27, scope: !569, inlinedAt: !559)
!577 = !DILocation(line: 72, column: 17, scope: !578, inlinedAt: !583)
!578 = distinct !DISubprogram(name: "from", linkageName: "_RNvXsY_NtNtCsjIpoRzUjyHQ_4core7convert3numyINtB7_4FromhE4from", scope: !580, file: !579, line: 69, type: !25, scopeLine: 69, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !14, templateParams: !26)
!579 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/convert/num.rs", directory: "", checksumkind: CSK_MD5, checksum: "c93dbf161bd654110f7e0ffa35b977fa")
!580 = !DINamespace(name: "{impl#62}", scope: !581)
!581 = !DINamespace(name: "num", scope: !582)
!582 = !DINamespace(name: "convert", scope: !35)
!583 = distinct !DILocation(line: 80, column: 13, scope: !584, inlinedAt: !587)
!584 = distinct !DILexicalBlock(scope: !585, file: !23, line: 74, column: 22)
!585 = distinct !DISubprogram(name: "{closure#0}", linkageName: "_RNCNvCsfFAnx7WYh7o_12evidence_lab9sum_bytes0B3_", scope: !586, file: !23, line: 74, type: !64, scopeLine: 74, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !14, templateParams: !26)
!586 = !DINamespace(name: "sum_bytes", scope: !24)
!587 = distinct !DILocation(line: 88, column: 28, scope: !588, inlinedAt: !589)
!588 = distinct !DISubprogram(name: "{closure#0}<&u8, u64, u64, evidence_lab::sum_bytes::{closure_env#0}, core::iter::traits::accum::{impl#40}::sum::{closure_env#0}<core::iter::adapters::map::Map<core::slice::iter::Iter<u8>, evidence_lab::sum_bytes::{closure_env#0}>>>", linkageName: "_RNCINvNtNtNtCsjIpoRzUjyHQ_4core4iter8adapters3map8map_foldRhyyNCNvCsfFAnx7WYh7o_12evidence_lab9sum_bytes0NCINvXsC_NtNtB8_6traits5accumyNtB1O_3Sum3sumINtB4_3MapINtNtNtBa_5slice4iter4IterhEBY_EE0E0B12_", scope: !222, file: !180, line: 88, type: !64, scopeLine: 88, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !14, templateParams: !26)
!589 = distinct !DILocation(line: 274, column: 27, scope: !569, inlinedAt: !559)
!590 = !DILocation(line: 55, column: 28, scope: !591, inlinedAt: !593)
!591 = distinct !DISubprogram(name: "{closure#0}<core::iter::adapters::map::Map<core::slice::iter::Iter<u8>, evidence_lab::sum_bytes::{closure_env#0}>>", linkageName: "_RNCINvXsC_NtNtNtCsjIpoRzUjyHQ_4core4iter6traits5accumyNtB8_3Sum3sumINtNtNtBc_8adapters3map3MapINtNtNtBe_5slice4iter4IterhENCNvCsfFAnx7WYh7o_12evidence_lab9sum_bytes0EE0B20_", scope: !592, file: !133, line: 55, type: !64, scopeLine: 55, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !14, templateParams: !26)
!592 = !DINamespace(name: "sum", scope: !563)
!593 = distinct !DILocation(line: 88, column: 21, scope: !588, inlinedAt: !589)
!594 = distinct !{!594, !170, !171}
!595 = !{!"branch_weights", i32 8, i32 24}
!596 = !DILocation(line: 0, scope: !558, inlinedAt: !559)
!597 = distinct !{!597, !170, !171}
!598 = !DILocation(line: 1013, column: 17, scope: !599, inlinedAt: !600)
!599 = distinct !DISubprogram(name: "unchecked_add", linkageName: "_RNvMs9_NtCsjIpoRzUjyHQ_4core3numj13unchecked_add", scope: !194, file: !89, line: 1001, type: !25, scopeLine: 1001, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !14, templateParams: !26)
!600 = distinct !DILocation(line: 278, column: 36, scope: !569, inlinedAt: !559)
!601 = distinct !{!601, !171, !170}
!602 = !DILocation(line: 83, column: 2, scope: !551)
