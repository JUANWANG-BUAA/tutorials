; ModuleID = 'evidence_lab.4789476f54c908b2-cgu.02'
source_filename = "evidence_lab.4789476f54c908b2-cgu.02"
target datalayout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx11.0.0"

; core::slice::sort::shared::smallsort::sort8_stable::<f64, <[f64]>::sort_by<<f64>::total_cmp>::{closure#0}>
; Function Attrs: uwtable
define internal fastcc void @_RINvNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6shared9smallsort12sort8_stabledNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtBa_3f64d9total_cmpE0ECs68MIsFmw01O_12evidence_lab(ptr nofree noundef nonnull readonly captures(none) %v_base, ptr nofree noundef nonnull writeonly captures(none) initializes((0, 64)) %dst, ptr nofree noundef nonnull captures(address) initializes((0, 64)) %scratch_base) unnamed_addr #0 personality ptr @rust_eh_personality !dbg !8 !guid !17 {
start:
  %_7.i = getelementptr inbounds nuw i8, ptr %v_base, i64 8, !dbg !18
  %_7.val.i = load i64, ptr %_7.i, align 8, !dbg !28, !noundef !16
  %v_base.val.i = load i64, ptr %v_base, align 8, !dbg !28, !noundef !16
  %_12.i.i.i.i = ashr i64 %_7.val.i, 63, !dbg !29
  %_10.i.i.i.i = lshr i64 %_12.i.i.i.i, 1, !dbg !50
  %0 = xor i64 %_10.i.i.i.i, %_7.val.i, !dbg !51
  %_17.i.i.i.i = ashr i64 %v_base.val.i, 63, !dbg !52
  %_15.i.i.i.i = lshr i64 %_17.i.i.i.i, 1, !dbg !53
  %1 = xor i64 %_15.i.i.i.i, %v_base.val.i, !dbg !54
  %_0.i.i = icmp slt i64 %0, %1, !dbg !55
  %_12.i = getelementptr inbounds nuw i8, ptr %v_base, i64 24, !dbg !63
  %_14.i = getelementptr inbounds nuw i8, ptr %v_base, i64 16, !dbg !66
  %_12.val.i = load i64, ptr %_12.i, align 8, !dbg !68, !noundef !16
  %_14.val.i = load i64, ptr %_14.i, align 8, !dbg !68, !noundef !16
  %_12.i.i.i14.i = ashr i64 %_12.val.i, 63, !dbg !69
  %_10.i.i.i15.i = lshr i64 %_12.i.i.i14.i, 1, !dbg !73
  %2 = xor i64 %_10.i.i.i15.i, %_12.val.i, !dbg !74
  %_17.i.i.i16.i = ashr i64 %_14.val.i, 63, !dbg !75
  %_15.i.i.i17.i = lshr i64 %_17.i.i.i16.i, 1, !dbg !76
  %3 = xor i64 %_15.i.i.i17.i, %_14.val.i, !dbg !77
  %_0.i18.i = icmp slt i64 %2, %3, !dbg !78
  %count.i = zext i1 %_0.i.i to i64, !dbg !80
  %a.i = getelementptr inbounds nuw [8 x i8], ptr %v_base, i64 %count.i, !dbg !82
  %_19.i = xor i1 %_0.i.i, true, !dbg !84
  %count1.i = zext i1 %_19.i to i64, !dbg !84
  %b.i = getelementptr inbounds nuw [8 x i8], ptr %v_base, i64 %count1.i, !dbg !86
  %count2.i = select i1 %_0.i18.i, i64 3, i64 2, !dbg !88
  %c.i = getelementptr inbounds nuw [8 x i8], ptr %v_base, i64 %count2.i, !dbg !90
  %count3.i = select i1 %_0.i18.i, i64 2, i64 3, !dbg !92
  %d.i = getelementptr inbounds nuw [8 x i8], ptr %v_base, i64 %count3.i, !dbg !94
  %c.val.i = load i64, ptr %c.i, align 8, !dbg !96, !noundef !16
  %a.val.i = load i64, ptr %a.i, align 8, !dbg !96, !noundef !16
  %_12.i.i.i19.i = ashr i64 %c.val.i, 63, !dbg !98
  %_10.i.i.i20.i = lshr i64 %_12.i.i.i19.i, 1, !dbg !102
  %4 = xor i64 %_10.i.i.i20.i, %c.val.i, !dbg !103
  %_17.i.i.i21.i = ashr i64 %a.val.i, 63, !dbg !104
  %_15.i.i.i22.i = lshr i64 %_17.i.i.i21.i, 1, !dbg !105
  %5 = xor i64 %_15.i.i.i22.i, %a.val.i, !dbg !106
  %_0.i23.i = icmp slt i64 %4, %5, !dbg !107
  %d.val.i = load i64, ptr %d.i, align 8, !dbg !109, !noundef !16
  %b.val.i = load i64, ptr %b.i, align 8, !dbg !109, !noundef !16
  %_12.i.i.i24.i = ashr i64 %d.val.i, 63, !dbg !111
  %_10.i.i.i25.i = lshr i64 %_12.i.i.i24.i, 1, !dbg !115
  %6 = xor i64 %_10.i.i.i25.i, %d.val.i, !dbg !116
  %_17.i.i.i26.i = ashr i64 %b.val.i, 63, !dbg !117
  %_15.i.i.i27.i = lshr i64 %_17.i.i.i26.i, 1, !dbg !118
  %7 = xor i64 %_15.i.i.i27.i, %b.val.i, !dbg !119
  %_0.i28.i = icmp slt i64 %6, %7, !dbg !120
  %self.i11.i = select i1 %_0.i28.i, ptr %c.i, ptr %b.i, !dbg !122, !unpredictable !16
  %self.i10.i = select i1 %_0.i23.i, ptr %a.i, ptr %self.i11.i, !dbg !137, !unpredictable !16
  %self.i9.i = select i1 %_0.i23.i, ptr %b.i, ptr %c.i, !dbg !139, !unpredictable !16
  %self.i8.i = select i1 %_0.i28.i, ptr %d.i, ptr %self.i9.i, !dbg !142, !unpredictable !16
  %self.i8.val.i = load i64, ptr %self.i8.i, align 8, !dbg !144, !noundef !16
  %self.i10.val.i = load i64, ptr %self.i10.i, align 8, !dbg !144, !noundef !16
  %_12.i.i.i29.i = ashr i64 %self.i8.val.i, 63, !dbg !146
  %_10.i.i.i30.i = lshr i64 %_12.i.i.i29.i, 1, !dbg !150
  %8 = xor i64 %_10.i.i.i30.i, %self.i8.val.i, !dbg !151
  %_17.i.i.i31.i = ashr i64 %self.i10.val.i, 63, !dbg !152
  %_15.i.i.i32.i = lshr i64 %_17.i.i.i31.i, 1, !dbg !153
  %9 = xor i64 %_15.i.i.i32.i, %self.i10.val.i, !dbg !154
  %_0.i33.i = icmp slt i64 %8, %9, !dbg !155
  %10 = select i1 %_0.i23.i, i64 %c.val.i, i64 %a.val.i, !dbg !157, !unpredictable !16
  store i64 %10, ptr %scratch_base, align 8, !dbg !159
  %dst4.i = getelementptr inbounds nuw i8, ptr %scratch_base, i64 8, !dbg !166
  %self.i8.val3.i = load i64, ptr %self.i8.i, align 8, !dbg !172
  %self.i10.val4.i = load i64, ptr %self.i10.i, align 8, !dbg !172
  %11 = select i1 %_0.i33.i, i64 %self.i8.val3.i, i64 %self.i10.val4.i, !dbg !174, !unpredictable !16
  store i64 %11, ptr %dst4.i, align 8, !dbg !172
  %dst5.i = getelementptr inbounds nuw i8, ptr %scratch_base, i64 16, !dbg !176
  %self.i10.val5.i = load i64, ptr %self.i10.i, align 8, !dbg !178
  %self.i8.val6.i = load i64, ptr %self.i8.i, align 8, !dbg !178
  %12 = select i1 %_0.i33.i, i64 %self.i10.val5.i, i64 %self.i8.val6.i, !dbg !180, !unpredictable !16
  store i64 %12, ptr %dst5.i, align 8, !dbg !178
  %dst6.i = getelementptr i8, ptr %scratch_base, i64 24, !dbg !182
  %b.val7.i = load i64, ptr %b.i, align 8, !dbg !184
  %d.val8.i = load i64, ptr %d.i, align 8, !dbg !184
  %13 = select i1 %_0.i28.i, i64 %b.val7.i, i64 %d.val8.i, !dbg !186, !unpredictable !16
  store i64 %13, ptr %dst6.i, align 8, !dbg !184
  %_9 = getelementptr inbounds nuw i8, ptr %v_base, i64 32, !dbg !188
  %_10 = getelementptr i8, ptr %scratch_base, i64 32, !dbg !191
  %_7.i1 = getelementptr inbounds nuw i8, ptr %v_base, i64 40, !dbg !193
  %_7.val.i2 = load i64, ptr %_7.i1, align 8, !dbg !196, !noundef !16
  %v_base.val.i3 = load i64, ptr %_9, align 8, !dbg !196, !noundef !16
  %_12.i.i.i.i4 = ashr i64 %_7.val.i2, 63, !dbg !197
  %_10.i.i.i.i5 = lshr i64 %_12.i.i.i.i4, 1, !dbg !201
  %14 = xor i64 %_10.i.i.i.i5, %_7.val.i2, !dbg !202
  %_17.i.i.i.i6 = ashr i64 %v_base.val.i3, 63, !dbg !203
  %_15.i.i.i.i7 = lshr i64 %_17.i.i.i.i6, 1, !dbg !204
  %15 = xor i64 %_15.i.i.i.i7, %v_base.val.i3, !dbg !205
  %_0.i.i8 = icmp slt i64 %14, %15, !dbg !206
  %_12.i9 = getelementptr inbounds nuw i8, ptr %v_base, i64 56, !dbg !208
  %_14.i10 = getelementptr inbounds nuw i8, ptr %v_base, i64 48, !dbg !210
  %_12.val.i11 = load i64, ptr %_12.i9, align 8, !dbg !212, !noundef !16
  %_14.val.i12 = load i64, ptr %_14.i10, align 8, !dbg !212, !noundef !16
  %_12.i.i.i14.i13 = ashr i64 %_12.val.i11, 63, !dbg !213
  %_10.i.i.i15.i14 = lshr i64 %_12.i.i.i14.i13, 1, !dbg !217
  %16 = xor i64 %_10.i.i.i15.i14, %_12.val.i11, !dbg !218
  %_17.i.i.i16.i15 = ashr i64 %_14.val.i12, 63, !dbg !219
  %_15.i.i.i17.i16 = lshr i64 %_17.i.i.i16.i15, 1, !dbg !220
  %17 = xor i64 %_15.i.i.i17.i16, %_14.val.i12, !dbg !221
  %_0.i18.i17 = icmp slt i64 %16, %17, !dbg !222
  %count.i18 = zext i1 %_0.i.i8 to i64, !dbg !224
  %a.i19 = getelementptr inbounds nuw [8 x i8], ptr %_9, i64 %count.i18, !dbg !225
  %_19.i20 = xor i1 %_0.i.i8, true, !dbg !227
  %count1.i21 = zext i1 %_19.i20 to i64, !dbg !227
  %b.i22 = getelementptr inbounds nuw [8 x i8], ptr %_9, i64 %count1.i21, !dbg !228
  %count2.i23 = select i1 %_0.i18.i17, i64 3, i64 2, !dbg !230
  %c.i24 = getelementptr inbounds nuw [8 x i8], ptr %_9, i64 %count2.i23, !dbg !231
  %count3.i25 = select i1 %_0.i18.i17, i64 2, i64 3, !dbg !233
  %d.i26 = getelementptr inbounds nuw [8 x i8], ptr %_9, i64 %count3.i25, !dbg !234
  %c.val.i27 = load i64, ptr %c.i24, align 8, !dbg !236, !noundef !16
  %a.val.i28 = load i64, ptr %a.i19, align 8, !dbg !236, !noundef !16
  %_12.i.i.i19.i29 = ashr i64 %c.val.i27, 63, !dbg !237
  %_10.i.i.i20.i30 = lshr i64 %_12.i.i.i19.i29, 1, !dbg !241
  %18 = xor i64 %_10.i.i.i20.i30, %c.val.i27, !dbg !242
  %_17.i.i.i21.i31 = ashr i64 %a.val.i28, 63, !dbg !243
  %_15.i.i.i22.i32 = lshr i64 %_17.i.i.i21.i31, 1, !dbg !244
  %19 = xor i64 %_15.i.i.i22.i32, %a.val.i28, !dbg !245
  %_0.i23.i33 = icmp slt i64 %18, %19, !dbg !246
  %d.val.i34 = load i64, ptr %d.i26, align 8, !dbg !248, !noundef !16
  %b.val.i35 = load i64, ptr %b.i22, align 8, !dbg !248, !noundef !16
  %_12.i.i.i24.i36 = ashr i64 %d.val.i34, 63, !dbg !249
  %_10.i.i.i25.i37 = lshr i64 %_12.i.i.i24.i36, 1, !dbg !253
  %20 = xor i64 %_10.i.i.i25.i37, %d.val.i34, !dbg !254
  %_17.i.i.i26.i38 = ashr i64 %b.val.i35, 63, !dbg !255
  %_15.i.i.i27.i39 = lshr i64 %_17.i.i.i26.i38, 1, !dbg !256
  %21 = xor i64 %_15.i.i.i27.i39, %b.val.i35, !dbg !257
  %_0.i28.i40 = icmp slt i64 %20, %21, !dbg !258
  %self.i11.i41 = select i1 %_0.i28.i40, ptr %c.i24, ptr %b.i22, !dbg !260, !unpredictable !16
  %self.i10.i42 = select i1 %_0.i23.i33, ptr %a.i19, ptr %self.i11.i41, !dbg !262, !unpredictable !16
  %self.i9.i43 = select i1 %_0.i23.i33, ptr %b.i22, ptr %c.i24, !dbg !264, !unpredictable !16
  %self.i8.i44 = select i1 %_0.i28.i40, ptr %d.i26, ptr %self.i9.i43, !dbg !266, !unpredictable !16
  %self.i8.val.i45 = load i64, ptr %self.i8.i44, align 8, !dbg !268, !noundef !16
  %self.i10.val.i46 = load i64, ptr %self.i10.i42, align 8, !dbg !268, !noundef !16
  %_12.i.i.i29.i47 = ashr i64 %self.i8.val.i45, 63, !dbg !269
  %_10.i.i.i30.i48 = lshr i64 %_12.i.i.i29.i47, 1, !dbg !273
  %22 = xor i64 %_10.i.i.i30.i48, %self.i8.val.i45, !dbg !274
  %_17.i.i.i31.i49 = ashr i64 %self.i10.val.i46, 63, !dbg !275
  %_15.i.i.i32.i50 = lshr i64 %_17.i.i.i31.i49, 1, !dbg !276
  %23 = xor i64 %_15.i.i.i32.i50, %self.i10.val.i46, !dbg !277
  %_0.i33.i51 = icmp slt i64 %22, %23, !dbg !278
  %24 = select i1 %_0.i23.i33, i64 %c.val.i27, i64 %a.val.i28, !dbg !280, !unpredictable !16
  store i64 %24, ptr %_10, align 8, !dbg !282
  %dst4.i52 = getelementptr i8, ptr %scratch_base, i64 40, !dbg !284
  %self.i8.val3.i53 = load i64, ptr %self.i8.i44, align 8, !dbg !286
  %self.i10.val4.i54 = load i64, ptr %self.i10.i42, align 8, !dbg !286
  %25 = select i1 %_0.i33.i51, i64 %self.i8.val3.i53, i64 %self.i10.val4.i54, !dbg !288, !unpredictable !16
  store i64 %25, ptr %dst4.i52, align 8, !dbg !286
  %dst5.i55 = getelementptr i8, ptr %scratch_base, i64 48, !dbg !290
  %self.i10.val5.i56 = load i64, ptr %self.i10.i42, align 8, !dbg !292
  %self.i8.val6.i57 = load i64, ptr %self.i8.i44, align 8, !dbg !292
  %26 = select i1 %_0.i33.i51, i64 %self.i10.val5.i56, i64 %self.i8.val6.i57, !dbg !294, !unpredictable !16
  store i64 %26, ptr %dst5.i55, align 8, !dbg !292
  %dst6.i58 = getelementptr i8, ptr %scratch_base, i64 56, !dbg !296
  %b.val7.i59 = load i64, ptr %b.i22, align 8, !dbg !298
  %d.val8.i60 = load i64, ptr %d.i26, align 8, !dbg !298
  %27 = select i1 %_0.i28.i40, i64 %b.val7.i59, i64 %d.val8.i60, !dbg !300, !unpredictable !16
  store i64 %27, ptr %dst6.i58, align 8, !dbg !298
  tail call void @llvm.experimental.noalias.scope.decl(metadata !302), !dbg !305
  %28 = getelementptr inbounds nuw i8, ptr %dst, i64 56, !dbg !306
  %_12.i.i.i.i61 = ashr i64 %24, 63, !dbg !319
  %_10.i.i.i.i62 = lshr i64 %_12.i.i.i.i61, 1, !dbg !327
  %29 = xor i64 %_10.i.i.i.i62, %24, !dbg !328
  %_17.i.i.i.i63 = ashr i64 %10, 63, !dbg !329
  %_15.i.i.i.i64 = lshr i64 %_17.i.i.i.i63, 1, !dbg !330
  %30 = xor i64 %_15.i.i.i.i64, %10, !dbg !331
  %_0.i.i65 = icmp slt i64 %29, %30, !dbg !332
  %is_l.i17.i = xor i1 %_0.i.i65, true, !dbg !334
  %31 = select i1 %_0.i.i65, i64 %24, i64 %10, !dbg !335
  store i64 %31, ptr %dst, align 8, !dbg !337, !noalias !341
  %count.i.i = zext i1 %_0.i.i65 to i64, !dbg !345
  %_12.i18.i = getelementptr inbounds nuw [8 x i8], ptr %_10, i64 %count.i.i, !dbg !346
  %count2.i.i = zext i1 %is_l.i17.i to i64, !dbg !349
  %_14.i19.i = getelementptr inbounds nuw [8 x i8], ptr %scratch_base, i64 %count2.i.i, !dbg !350
  %_16.i.i = getelementptr inbounds nuw i8, ptr %dst, i64 8, !dbg !352
  %_12.i.i.i20.i = ashr i64 %27, 63, !dbg !355
  %_10.i.i.i21.i = lshr i64 %_12.i.i.i20.i, 1, !dbg !361
  %32 = xor i64 %_10.i.i.i21.i, %27, !dbg !362
  %_17.i.i.i22.i = ashr i64 %13, 63, !dbg !363
  %_15.i.i.i23.i = lshr i64 %_17.i.i.i22.i, 1, !dbg !364
  %33 = xor i64 %_15.i.i.i23.i, %13, !dbg !365
  %_0.i24.i = icmp slt i64 %32, %33, !dbg !366
  %is_l.i.i = xor i1 %_0.i24.i, true, !dbg !368
  %34 = select i1 %_0.i24.i, i64 %13, i64 %27, !dbg !369
  store i64 %34, ptr %28, align 8, !dbg !371, !noalias !375
  %count.neg.i.i = sext i1 %is_l.i.i to i64, !dbg !379
  %_12.i.i = getelementptr [8 x i8], ptr %dst6.i58, i64 %count.neg.i.i, !dbg !380
  %count3.neg.i.i = sext i1 %_0.i24.i to i64, !dbg !385
  %_14.i.i = getelementptr [8 x i8], ptr %dst6.i, i64 %count3.neg.i.i, !dbg !386
  %35 = getelementptr inbounds nuw i8, ptr %dst, i64 48, !dbg !390
  %right.sroa.0.0.val.i.1 = load i64, ptr %_12.i18.i, align 8, !dbg !393, !alias.scope !302, !noundef !16
  %left.sroa.0.0.val.i.1 = load i64, ptr %_14.i19.i, align 8, !dbg !393, !alias.scope !302, !noundef !16
  %_12.i.i.i.i61.1 = ashr i64 %right.sroa.0.0.val.i.1, 63, !dbg !319
  %_10.i.i.i.i62.1 = lshr i64 %_12.i.i.i.i61.1, 1, !dbg !327
  %36 = xor i64 %_10.i.i.i.i62.1, %right.sroa.0.0.val.i.1, !dbg !328
  %_17.i.i.i.i63.1 = ashr i64 %left.sroa.0.0.val.i.1, 63, !dbg !329
  %_15.i.i.i.i64.1 = lshr i64 %_17.i.i.i.i63.1, 1, !dbg !330
  %37 = xor i64 %_15.i.i.i.i64.1, %left.sroa.0.0.val.i.1, !dbg !331
  %_0.i.i65.1 = icmp slt i64 %36, %37, !dbg !332
  %is_l.i17.i.1 = xor i1 %_0.i.i65.1, true, !dbg !334
  %38 = select i1 %_0.i.i65.1, i64 %right.sroa.0.0.val.i.1, i64 %left.sroa.0.0.val.i.1, !dbg !335
  store i64 %38, ptr %_16.i.i, align 8, !dbg !337, !noalias !341
  %count.i.i.1 = zext i1 %_0.i.i65.1 to i64, !dbg !345
  %_12.i18.i.1 = getelementptr inbounds nuw [8 x i8], ptr %_12.i18.i, i64 %count.i.i.1, !dbg !346
  %count2.i.i.1 = zext i1 %is_l.i17.i.1 to i64, !dbg !349
  %_14.i19.i.1 = getelementptr inbounds nuw [8 x i8], ptr %_14.i19.i, i64 %count2.i.i.1, !dbg !350
  %_16.i.i.1 = getelementptr inbounds nuw i8, ptr %dst, i64 16, !dbg !352
  %right_rev.sroa.0.0.val.i.1 = load i64, ptr %_12.i.i, align 8, !dbg !394, !alias.scope !302, !noundef !16
  %left_rev.sroa.0.0.val.i.1 = load i64, ptr %_14.i.i, align 8, !dbg !394, !alias.scope !302, !noundef !16
  %_12.i.i.i20.i.1 = ashr i64 %right_rev.sroa.0.0.val.i.1, 63, !dbg !355
  %_10.i.i.i21.i.1 = lshr i64 %_12.i.i.i20.i.1, 1, !dbg !361
  %39 = xor i64 %_10.i.i.i21.i.1, %right_rev.sroa.0.0.val.i.1, !dbg !362
  %_17.i.i.i22.i.1 = ashr i64 %left_rev.sroa.0.0.val.i.1, 63, !dbg !363
  %_15.i.i.i23.i.1 = lshr i64 %_17.i.i.i22.i.1, 1, !dbg !364
  %40 = xor i64 %_15.i.i.i23.i.1, %left_rev.sroa.0.0.val.i.1, !dbg !365
  %_0.i24.i.1 = icmp slt i64 %39, %40, !dbg !366
  %is_l.i.i.1 = xor i1 %_0.i24.i.1, true, !dbg !368
  %41 = select i1 %_0.i24.i.1, i64 %left_rev.sroa.0.0.val.i.1, i64 %right_rev.sroa.0.0.val.i.1, !dbg !369
  store i64 %41, ptr %35, align 8, !dbg !371, !noalias !375
  %count.neg.i.i.1 = sext i1 %is_l.i.i.1 to i64, !dbg !379
  %_12.i.i.1 = getelementptr [8 x i8], ptr %_12.i.i, i64 %count.neg.i.i.1, !dbg !380
  %count3.neg.i.i.1 = sext i1 %_0.i24.i.1 to i64, !dbg !385
  %_14.i.i.1 = getelementptr [8 x i8], ptr %_14.i.i, i64 %count3.neg.i.i.1, !dbg !386
  %42 = getelementptr inbounds nuw i8, ptr %dst, i64 40, !dbg !390
  %right.sroa.0.0.val.i.2 = load i64, ptr %_12.i18.i.1, align 8, !dbg !393, !alias.scope !302, !noundef !16
  %left.sroa.0.0.val.i.2 = load i64, ptr %_14.i19.i.1, align 8, !dbg !393, !alias.scope !302, !noundef !16
  %_12.i.i.i.i61.2 = ashr i64 %right.sroa.0.0.val.i.2, 63, !dbg !319
  %_10.i.i.i.i62.2 = lshr i64 %_12.i.i.i.i61.2, 1, !dbg !327
  %43 = xor i64 %_10.i.i.i.i62.2, %right.sroa.0.0.val.i.2, !dbg !328
  %_17.i.i.i.i63.2 = ashr i64 %left.sroa.0.0.val.i.2, 63, !dbg !329
  %_15.i.i.i.i64.2 = lshr i64 %_17.i.i.i.i63.2, 1, !dbg !330
  %44 = xor i64 %_15.i.i.i.i64.2, %left.sroa.0.0.val.i.2, !dbg !331
  %_0.i.i65.2 = icmp slt i64 %43, %44, !dbg !332
  %is_l.i17.i.2 = xor i1 %_0.i.i65.2, true, !dbg !334
  %45 = select i1 %_0.i.i65.2, i64 %right.sroa.0.0.val.i.2, i64 %left.sroa.0.0.val.i.2, !dbg !335
  store i64 %45, ptr %_16.i.i.1, align 8, !dbg !337, !noalias !341
  %count.i.i.2 = zext i1 %_0.i.i65.2 to i64, !dbg !345
  %_12.i18.i.2 = getelementptr inbounds nuw [8 x i8], ptr %_12.i18.i.1, i64 %count.i.i.2, !dbg !346
  %count2.i.i.2 = zext i1 %is_l.i17.i.2 to i64, !dbg !349
  %_14.i19.i.2 = getelementptr inbounds nuw [8 x i8], ptr %_14.i19.i.1, i64 %count2.i.i.2, !dbg !350
  %_16.i.i.2 = getelementptr inbounds nuw i8, ptr %dst, i64 24, !dbg !352
  %right_rev.sroa.0.0.val.i.2 = load i64, ptr %_12.i.i.1, align 8, !dbg !394, !alias.scope !302, !noundef !16
  %left_rev.sroa.0.0.val.i.2 = load i64, ptr %_14.i.i.1, align 8, !dbg !394, !alias.scope !302, !noundef !16
  %_12.i.i.i20.i.2 = ashr i64 %right_rev.sroa.0.0.val.i.2, 63, !dbg !355
  %_10.i.i.i21.i.2 = lshr i64 %_12.i.i.i20.i.2, 1, !dbg !361
  %46 = xor i64 %_10.i.i.i21.i.2, %right_rev.sroa.0.0.val.i.2, !dbg !362
  %_17.i.i.i22.i.2 = ashr i64 %left_rev.sroa.0.0.val.i.2, 63, !dbg !363
  %_15.i.i.i23.i.2 = lshr i64 %_17.i.i.i22.i.2, 1, !dbg !364
  %47 = xor i64 %_15.i.i.i23.i.2, %left_rev.sroa.0.0.val.i.2, !dbg !365
  %_0.i24.i.2 = icmp slt i64 %46, %47, !dbg !366
  %is_l.i.i.2 = xor i1 %_0.i24.i.2, true, !dbg !368
  %48 = select i1 %_0.i24.i.2, i64 %left_rev.sroa.0.0.val.i.2, i64 %right_rev.sroa.0.0.val.i.2, !dbg !369
  store i64 %48, ptr %42, align 8, !dbg !371, !noalias !375
  %count.neg.i.i.2 = sext i1 %is_l.i.i.2 to i64, !dbg !379
  %_12.i.i.2 = getelementptr [8 x i8], ptr %_12.i.i.1, i64 %count.neg.i.i.2, !dbg !380
  %count3.neg.i.i.2 = sext i1 %_0.i24.i.2 to i64, !dbg !385
  %_14.i.i.2 = getelementptr [8 x i8], ptr %_14.i.i.1, i64 %count3.neg.i.i.2, !dbg !386
  %49 = getelementptr inbounds nuw i8, ptr %dst, i64 32, !dbg !390
  %right.sroa.0.0.val.i.3 = load i64, ptr %_12.i18.i.2, align 8, !dbg !393, !alias.scope !302, !noundef !16
  %left.sroa.0.0.val.i.3 = load i64, ptr %_14.i19.i.2, align 8, !dbg !393, !alias.scope !302, !noundef !16
  %_12.i.i.i.i61.3 = ashr i64 %right.sroa.0.0.val.i.3, 63, !dbg !319
  %_10.i.i.i.i62.3 = lshr i64 %_12.i.i.i.i61.3, 1, !dbg !327
  %50 = xor i64 %_10.i.i.i.i62.3, %right.sroa.0.0.val.i.3, !dbg !328
  %_17.i.i.i.i63.3 = ashr i64 %left.sroa.0.0.val.i.3, 63, !dbg !329
  %_15.i.i.i.i64.3 = lshr i64 %_17.i.i.i.i63.3, 1, !dbg !330
  %51 = xor i64 %_15.i.i.i.i64.3, %left.sroa.0.0.val.i.3, !dbg !331
  %_0.i.i65.3 = icmp slt i64 %50, %51, !dbg !332
  %is_l.i17.i.3 = xor i1 %_0.i.i65.3, true, !dbg !334
  %52 = select i1 %_0.i.i65.3, i64 %right.sroa.0.0.val.i.3, i64 %left.sroa.0.0.val.i.3, !dbg !335
  store i64 %52, ptr %_16.i.i.2, align 8, !dbg !337, !noalias !341
  %count.i.i.3 = zext i1 %_0.i.i65.3 to i64, !dbg !345
  %_12.i18.i.3 = getelementptr inbounds nuw [8 x i8], ptr %_12.i18.i.2, i64 %count.i.i.3, !dbg !346
  %count2.i.i.3 = zext i1 %is_l.i17.i.3 to i64, !dbg !349
  %_14.i19.i.3 = getelementptr inbounds nuw [8 x i8], ptr %_14.i19.i.2, i64 %count2.i.i.3, !dbg !350
  %right_rev.sroa.0.0.val.i.3 = load i64, ptr %_12.i.i.2, align 8, !dbg !394, !alias.scope !302, !noundef !16
  %left_rev.sroa.0.0.val.i.3 = load i64, ptr %_14.i.i.2, align 8, !dbg !394, !alias.scope !302, !noundef !16
  %_12.i.i.i20.i.3 = ashr i64 %right_rev.sroa.0.0.val.i.3, 63, !dbg !355
  %_10.i.i.i21.i.3 = lshr i64 %_12.i.i.i20.i.3, 1, !dbg !361
  %53 = xor i64 %_10.i.i.i21.i.3, %right_rev.sroa.0.0.val.i.3, !dbg !362
  %_17.i.i.i22.i.3 = ashr i64 %left_rev.sroa.0.0.val.i.3, 63, !dbg !363
  %_15.i.i.i23.i.3 = lshr i64 %_17.i.i.i22.i.3, 1, !dbg !364
  %54 = xor i64 %_15.i.i.i23.i.3, %left_rev.sroa.0.0.val.i.3, !dbg !365
  %_0.i24.i.3 = icmp slt i64 %53, %54, !dbg !366
  %is_l.i.i.3 = xor i1 %_0.i24.i.3, true, !dbg !368
  %55 = select i1 %_0.i24.i.3, i64 %left_rev.sroa.0.0.val.i.3, i64 %right_rev.sroa.0.0.val.i.3, !dbg !369
  store i64 %55, ptr %49, align 8, !dbg !371, !noalias !375
  %count.neg.i.i.3 = sext i1 %is_l.i.i.3 to i64, !dbg !379
  %_12.i.i.3 = getelementptr [8 x i8], ptr %_12.i.i.2, i64 %count.neg.i.i.3, !dbg !380
  %count3.neg.i.i.3 = sext i1 %_0.i24.i.3 to i64, !dbg !385
  %_14.i.i.3 = getelementptr [8 x i8], ptr %_14.i.i.2, i64 %count3.neg.i.i.3, !dbg !386
  %left_end.i = getelementptr i8, ptr %_14.i.i.3, i64 8, !dbg !395
  %right_end.i = getelementptr i8, ptr %_12.i.i.3, i64 8, !dbg !400
  %_31.i = icmp ne ptr %_14.i19.i.3, %left_end.i, !dbg !405
  %_32.i = icmp ne ptr %_12.i18.i.3, %right_end.i
  %or.cond.i = select i1 %_31.i, i1 true, i1 %_32.i, !dbg !405, !prof !407
  br i1 %or.cond.i, label %bb13.i, label %_RINvNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6shared9smallsort19bidirectional_mergedNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtBa_3f64d9total_cmpE0ECs68MIsFmw01O_12evidence_lab.exit, !dbg !405, !prof !407

bb13.i:                                           ; preds = %start
; call core::slice::sort::shared::smallsort::panic_on_ord_violation
  tail call void @_RNvNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6shared9smallsort22panic_on_ord_violation() #7, !dbg !408, !noalias !302
  unreachable, !dbg !408

_RINvNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6shared9smallsort19bidirectional_mergedNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtBa_3f64d9total_cmpE0ECs68MIsFmw01O_12evidence_lab.exit: ; preds = %start
  ret void, !dbg !409
}

; core::slice::sort::shared::smallsort::insertion_sort_shift_left::<f64, <[f64]>::sort_by<<f64>::total_cmp>::{closure#0}>
; Function Attrs: nounwind memory(argmem: readwrite, inaccessiblemem: write) uwtable
define hidden void @_RINvNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6shared9smallsort25insertion_sort_shift_leftdNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtBa_3f64d9total_cmpE0ECs68MIsFmw01O_12evidence_lab(ptr noalias nofree noundef nonnull align 8 captures(address) %v.0, i64 noundef range(i64 0, 1152921504606846976) %v.1, i64 noundef %offset, ptr noalias nofree noundef readnone align 8 captures(none) dereferenceable(8) %is_less) unnamed_addr #1 personality ptr @rust_eh_personality !dbg !410 !guid !411 {
start:
  %0 = add i64 %offset, -1, !dbg !412
  %or.cond.not = icmp ult i64 %0, %v.1, !dbg !412
  br i1 %or.cond.not, label %bb3, label %bb2, !dbg !412

bb2:                                              ; preds = %start
  tail call void @llvm.trap(), !dbg !414
  unreachable, !dbg !414

bb3:                                              ; preds = %start
  %v_end = getelementptr inbounds nuw [8 x i8], ptr %v.0, i64 %v.1, !dbg !415
  %_10.not1 = icmp samesign eq i64 %offset, %v.1, !dbg !419
  br i1 %_10.not1, label %bb7, label %bb5.preheader, !dbg !419

bb5.preheader:                                    ; preds = %bb3
  %1 = getelementptr inbounds nuw [8 x i8], ptr %v.0, i64 %offset, !dbg !422
  br label %bb5, !dbg !424

bb7:                                              ; preds = %_RINvNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6shared9smallsort11insert_taildNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtBa_3f64d9total_cmpE0ECs68MIsFmw01O_12evidence_lab.exit, %bb3
  ret void, !dbg !428

bb5:                                              ; preds = %_RINvNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6shared9smallsort11insert_taildNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtBa_3f64d9total_cmpE0ECs68MIsFmw01O_12evidence_lab.exit, %bb5.preheader
  %tail.sroa.0.02 = phi ptr [ %_14, %_RINvNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6shared9smallsort11insert_taildNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtBa_3f64d9total_cmpE0ECs68MIsFmw01O_12evidence_lab.exit ], [ %1, %bb5.preheader ]
  %2 = getelementptr inbounds i8, ptr %tail.sroa.0.02, i64 -8, !dbg !429
  %tail.val.i = load i64, ptr %tail.sroa.0.02, align 8, !dbg !424, !noundef !16
  %.val1.i = load i64, ptr %2, align 8, !dbg !424, !noundef !16
  %_12.i.i.i.i = ashr i64 %tail.val.i, 63, !dbg !432
  %_10.i.i.i.i = lshr i64 %_12.i.i.i.i, 1, !dbg !436
  %3 = xor i64 %_10.i.i.i.i, %tail.val.i, !dbg !437
  %_17.i.i.i.i = ashr i64 %.val1.i, 63, !dbg !438
  %_15.i.i.i.i = lshr i64 %_17.i.i.i.i, 1, !dbg !439
  %4 = xor i64 %_15.i.i.i.i, %.val1.i, !dbg !440
  %_0.i.i = icmp slt i64 %3, %4, !dbg !441
  br i1 %_0.i.i, label %bb4.i.preheader, label %_RINvNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6shared9smallsort11insert_taildNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtBa_3f64d9total_cmpE0ECs68MIsFmw01O_12evidence_lab.exit, !dbg !424

bb4.i.preheader:                                  ; preds = %bb5
  store i64 %.val1.i, ptr %tail.sroa.0.02, align 8, !dbg !443
  %_18.i1 = icmp eq ptr %2, %v.0, !dbg !448
  br i1 %_18.i1, label %bb10.i, label %bb7.i, !dbg !448

bb4.i:                                            ; preds = %bb7.i
  store i64 %.val.i, ptr %sift.sroa.0.0.i2, align 8, !dbg !443
  %_18.i = icmp eq ptr %5, %v.0, !dbg !448
  br i1 %_18.i, label %bb10.i, label %bb7.i, !dbg !448

bb7.i:                                            ; preds = %bb4.i.preheader, %bb4.i
  %sift.sroa.0.0.i2 = phi ptr [ %5, %bb4.i ], [ %2, %bb4.i.preheader ]
  %5 = getelementptr inbounds i8, ptr %sift.sroa.0.0.i2, i64 -8, !dbg !449
  %.val.i = load i64, ptr %5, align 8, !dbg !451, !noundef !16
  %_17.i.i.i4.i = ashr i64 %.val.i, 63, !dbg !452
  %_15.i.i.i5.i = lshr i64 %_17.i.i.i4.i, 1, !dbg !456
  %6 = xor i64 %_15.i.i.i5.i, %.val.i, !dbg !457
  %_0.i6.i = icmp slt i64 %3, %6, !dbg !458
  br i1 %_0.i6.i, label %bb4.i, label %bb10.i, !dbg !451

bb10.i:                                           ; preds = %bb4.i, %bb7.i, %bb4.i.preheader
  %sift.sroa.0.0.i.lcssa = phi ptr [ %v.0, %bb4.i.preheader ], [ %v.0, %bb4.i ], [ %sift.sroa.0.0.i2, %bb7.i ], !dbg !460
  store i64 %tail.val.i, ptr %sift.sroa.0.0.i.lcssa, align 8, !dbg !461, !noalias !469
  br label %_RINvNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6shared9smallsort11insert_taildNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtBa_3f64d9total_cmpE0ECs68MIsFmw01O_12evidence_lab.exit, !dbg !474

_RINvNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6shared9smallsort11insert_taildNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtBa_3f64d9total_cmpE0ECs68MIsFmw01O_12evidence_lab.exit: ; preds = %bb10.i, %bb5
  %_14 = getelementptr inbounds nuw i8, ptr %tail.sroa.0.02, i64 8, !dbg !475
  %_10.not = icmp eq ptr %_14, %v_end, !dbg !419
  br i1 %_10.not, label %bb7, label %bb5, !dbg !419
}

; core::slice::sort::shared::smallsort::small_sort_general_with_scratch::<f64, <[f64]>::sort_by<<f64>::total_cmp>::{closure#0}>
; Function Attrs: uwtable
define hidden void @_RINvNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6shared9smallsort31small_sort_general_with_scratchdNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtBa_3f64d9total_cmpE0ECs68MIsFmw01O_12evidence_lab(ptr noalias nofree noundef nonnull align 8 captures(none) %v.0, i64 noundef range(i64 0, 1152921504606846976) %v.1, ptr noalias nofree noundef nonnull align 8 captures(address) %scratch.0, i64 noundef range(i64 0, 1152921504606846976) %scratch.1, ptr noalias nofree noundef readnone align 8 captures(none) dereferenceable(8) %is_less) unnamed_addr #0 personality ptr @rust_eh_personality !dbg !477 !guid !478 {
start:
  %_5 = icmp samesign ult i64 %v.1, 2, !dbg !479
  br i1 %_5, label %bb27, label %bb2, !dbg !479

bb2:                                              ; preds = %start
  %_8 = add nuw nsw i64 %v.1, 16, !dbg !481
  %_6 = icmp samesign ult i64 %scratch.1, %_8, !dbg !482
  br i1 %_6, label %bb3, label %bb4, !dbg !482

bb4:                                              ; preds = %bb2
  %len_div_29 = lshr i64 %v.1, 1, !dbg !483
  %_14 = icmp samesign ugt i64 %v.1, 15, !dbg !485
  br i1 %_14, label %bb6, label %bb9, !dbg !485

bb3:                                              ; preds = %bb2
  tail call void @llvm.trap(), !dbg !488
  unreachable, !dbg !488

bb9:                                              ; preds = %bb4
  %_22 = icmp samesign ugt i64 %v.1, 7, !dbg !489
  br i1 %_22, label %bb10, label %bb33, !dbg !489

bb6:                                              ; preds = %bb4
  %_16 = getelementptr inbounds nuw [8 x i8], ptr %scratch.0, i64 %v.1, !dbg !490
; call core::slice::sort::shared::smallsort::sort8_stable::<f64, <[f64]>::sort_by<<f64>::total_cmp>::{closure#0}>
  tail call fastcc void @_RINvNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6shared9smallsort12sort8_stabledNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtBa_3f64d9total_cmpE0ECs68MIsFmw01O_12evidence_lab(ptr noundef %v.0, ptr noundef %scratch.0, ptr noundef %_16), !dbg !493
  %_18 = getelementptr inbounds nuw [8 x i8], ptr %v.0, i64 %len_div_29, !dbg !494
  %_19 = getelementptr inbounds nuw [8 x i8], ptr %scratch.0, i64 %len_div_29, !dbg !496
  %_20 = getelementptr inbounds nuw i8, ptr %_16, i64 64, !dbg !498
; call core::slice::sort::shared::smallsort::sort8_stable::<f64, <[f64]>::sort_by<<f64>::total_cmp>::{closure#0}>
  tail call fastcc void @_RINvNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6shared9smallsort12sort8_stabledNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtBa_3f64d9total_cmpE0ECs68MIsFmw01O_12evidence_lab(ptr noundef %_18, ptr noundef %_19, ptr noundef %_20), !dbg !500
  br label %bb15, !dbg !501

bb10:                                             ; preds = %bb9
  %_7.i = getelementptr inbounds nuw i8, ptr %v.0, i64 8, !dbg !502
  %_7.val.i = load i64, ptr %_7.i, align 8, !dbg !505, !noundef !16
  %v_base.val.i = load i64, ptr %v.0, align 8, !dbg !505, !noundef !16
  %_12.i.i.i.i = ashr i64 %_7.val.i, 63, !dbg !506
  %_10.i.i.i.i = lshr i64 %_12.i.i.i.i, 1, !dbg !510
  %0 = xor i64 %_10.i.i.i.i, %_7.val.i, !dbg !511
  %_17.i.i.i.i = ashr i64 %v_base.val.i, 63, !dbg !512
  %_15.i.i.i.i = lshr i64 %_17.i.i.i.i, 1, !dbg !513
  %1 = xor i64 %_15.i.i.i.i, %v_base.val.i, !dbg !514
  %_0.i.i = icmp slt i64 %0, %1, !dbg !515
  %_12.i = getelementptr inbounds nuw i8, ptr %v.0, i64 24, !dbg !517
  %_14.i = getelementptr inbounds nuw i8, ptr %v.0, i64 16, !dbg !519
  %_12.val.i = load i64, ptr %_12.i, align 8, !dbg !521, !noundef !16
  %_14.val.i = load i64, ptr %_14.i, align 8, !dbg !521, !noundef !16
  %_12.i.i.i14.i = ashr i64 %_12.val.i, 63, !dbg !522
  %_10.i.i.i15.i = lshr i64 %_12.i.i.i14.i, 1, !dbg !526
  %2 = xor i64 %_10.i.i.i15.i, %_12.val.i, !dbg !527
  %_17.i.i.i16.i = ashr i64 %_14.val.i, 63, !dbg !528
  %_15.i.i.i17.i = lshr i64 %_17.i.i.i16.i, 1, !dbg !529
  %3 = xor i64 %_15.i.i.i17.i, %_14.val.i, !dbg !530
  %_0.i18.i = icmp slt i64 %2, %3, !dbg !531
  %count.i = zext i1 %_0.i.i to i64, !dbg !533
  %a.i = getelementptr inbounds nuw [8 x i8], ptr %v.0, i64 %count.i, !dbg !534
  %_19.i = xor i1 %_0.i.i, true, !dbg !536
  %count1.i = zext i1 %_19.i to i64, !dbg !536
  %b.i = getelementptr inbounds nuw [8 x i8], ptr %v.0, i64 %count1.i, !dbg !537
  %count2.i = select i1 %_0.i18.i, i64 3, i64 2, !dbg !539
  %c.i = getelementptr inbounds nuw [8 x i8], ptr %v.0, i64 %count2.i, !dbg !540
  %count3.i = select i1 %_0.i18.i, i64 2, i64 3, !dbg !542
  %d.i = getelementptr inbounds nuw [8 x i8], ptr %v.0, i64 %count3.i, !dbg !543
  %c.val.i = load i64, ptr %c.i, align 8, !dbg !545, !noundef !16
  %a.val.i = load i64, ptr %a.i, align 8, !dbg !545, !noundef !16
  %_12.i.i.i19.i = ashr i64 %c.val.i, 63, !dbg !546
  %_10.i.i.i20.i = lshr i64 %_12.i.i.i19.i, 1, !dbg !550
  %4 = xor i64 %_10.i.i.i20.i, %c.val.i, !dbg !551
  %_17.i.i.i21.i = ashr i64 %a.val.i, 63, !dbg !552
  %_15.i.i.i22.i = lshr i64 %_17.i.i.i21.i, 1, !dbg !553
  %5 = xor i64 %_15.i.i.i22.i, %a.val.i, !dbg !554
  %_0.i23.i = icmp slt i64 %4, %5, !dbg !555
  %d.val.i = load i64, ptr %d.i, align 8, !dbg !557, !noundef !16
  %b.val.i = load i64, ptr %b.i, align 8, !dbg !557, !noundef !16
  %_12.i.i.i24.i = ashr i64 %d.val.i, 63, !dbg !558
  %_10.i.i.i25.i = lshr i64 %_12.i.i.i24.i, 1, !dbg !562
  %6 = xor i64 %_10.i.i.i25.i, %d.val.i, !dbg !563
  %_17.i.i.i26.i = ashr i64 %b.val.i, 63, !dbg !564
  %_15.i.i.i27.i = lshr i64 %_17.i.i.i26.i, 1, !dbg !565
  %7 = xor i64 %_15.i.i.i27.i, %b.val.i, !dbg !566
  %_0.i28.i = icmp slt i64 %6, %7, !dbg !567
  %self.i11.i = select i1 %_0.i28.i, ptr %c.i, ptr %b.i, !dbg !569, !unpredictable !16
  %self.i10.i = select i1 %_0.i23.i, ptr %a.i, ptr %self.i11.i, !dbg !571, !unpredictable !16
  %self.i9.i = select i1 %_0.i23.i, ptr %b.i, ptr %c.i, !dbg !573, !unpredictable !16
  %self.i8.i = select i1 %_0.i28.i, ptr %d.i, ptr %self.i9.i, !dbg !575, !unpredictable !16
  %self.i8.val.i = load i64, ptr %self.i8.i, align 8, !dbg !577, !noundef !16
  %self.i10.val.i = load i64, ptr %self.i10.i, align 8, !dbg !577, !noundef !16
  %_12.i.i.i29.i = ashr i64 %self.i8.val.i, 63, !dbg !578
  %_10.i.i.i30.i = lshr i64 %_12.i.i.i29.i, 1, !dbg !582
  %8 = xor i64 %_10.i.i.i30.i, %self.i8.val.i, !dbg !583
  %_17.i.i.i31.i = ashr i64 %self.i10.val.i, 63, !dbg !584
  %_15.i.i.i32.i = lshr i64 %_17.i.i.i31.i, 1, !dbg !585
  %9 = xor i64 %_15.i.i.i32.i, %self.i10.val.i, !dbg !586
  %_0.i33.i = icmp slt i64 %8, %9, !dbg !587
  %10 = select i1 %_0.i23.i, i64 %c.val.i, i64 %a.val.i, !dbg !589, !unpredictable !16
  store i64 %10, ptr %scratch.0, align 8, !dbg !591
  %dst4.i = getelementptr inbounds nuw i8, ptr %scratch.0, i64 8, !dbg !593
  %11 = select i1 %_0.i33.i, i64 %self.i8.val.i, i64 %self.i10.val.i, !dbg !595, !unpredictable !16
  store i64 %11, ptr %dst4.i, align 8, !dbg !597
  %dst5.i = getelementptr inbounds nuw i8, ptr %scratch.0, i64 16, !dbg !599
  %12 = select i1 %_0.i33.i, i64 %self.i10.val.i, i64 %self.i8.val.i, !dbg !601, !unpredictable !16
  store i64 %12, ptr %dst5.i, align 8, !dbg !603
  %dst6.i = getelementptr inbounds nuw i8, ptr %scratch.0, i64 24, !dbg !605
  %13 = select i1 %_0.i28.i, i64 %b.val.i, i64 %d.val.i, !dbg !607, !unpredictable !16
  store i64 %13, ptr %dst6.i, align 8, !dbg !609
  %_27 = getelementptr inbounds nuw [8 x i8], ptr %v.0, i64 %len_div_29, !dbg !611
  %_28 = getelementptr inbounds nuw [8 x i8], ptr %scratch.0, i64 %len_div_29, !dbg !613
  %_7.i11 = getelementptr inbounds nuw i8, ptr %_27, i64 8, !dbg !615
  %_7.val.i12 = load i64, ptr %_7.i11, align 8, !dbg !618, !noundef !16
  %v_base.val.i13 = load i64, ptr %_27, align 8, !dbg !618, !noundef !16
  %_12.i.i.i.i14 = ashr i64 %_7.val.i12, 63, !dbg !619
  %_10.i.i.i.i15 = lshr i64 %_12.i.i.i.i14, 1, !dbg !623
  %14 = xor i64 %_10.i.i.i.i15, %_7.val.i12, !dbg !624
  %_17.i.i.i.i16 = ashr i64 %v_base.val.i13, 63, !dbg !625
  %_15.i.i.i.i17 = lshr i64 %_17.i.i.i.i16, 1, !dbg !626
  %15 = xor i64 %_15.i.i.i.i17, %v_base.val.i13, !dbg !627
  %_0.i.i18 = icmp slt i64 %14, %15, !dbg !628
  %_12.i19 = getelementptr inbounds nuw i8, ptr %_27, i64 24, !dbg !630
  %_14.i20 = getelementptr inbounds nuw i8, ptr %_27, i64 16, !dbg !632
  %_12.val.i21 = load i64, ptr %_12.i19, align 8, !dbg !634, !noundef !16
  %_14.val.i22 = load i64, ptr %_14.i20, align 8, !dbg !634, !noundef !16
  %_12.i.i.i14.i23 = ashr i64 %_12.val.i21, 63, !dbg !635
  %_10.i.i.i15.i24 = lshr i64 %_12.i.i.i14.i23, 1, !dbg !639
  %16 = xor i64 %_10.i.i.i15.i24, %_12.val.i21, !dbg !640
  %_17.i.i.i16.i25 = ashr i64 %_14.val.i22, 63, !dbg !641
  %_15.i.i.i17.i26 = lshr i64 %_17.i.i.i16.i25, 1, !dbg !642
  %17 = xor i64 %_15.i.i.i17.i26, %_14.val.i22, !dbg !643
  %_0.i18.i27 = icmp slt i64 %16, %17, !dbg !644
  %count.i28 = zext i1 %_0.i.i18 to i64, !dbg !646
  %a.i29 = getelementptr inbounds nuw [8 x i8], ptr %_27, i64 %count.i28, !dbg !647
  %_19.i30 = xor i1 %_0.i.i18, true, !dbg !649
  %count1.i31 = zext i1 %_19.i30 to i64, !dbg !649
  %b.i32 = getelementptr inbounds nuw [8 x i8], ptr %_27, i64 %count1.i31, !dbg !650
  %count2.i33 = select i1 %_0.i18.i27, i64 3, i64 2, !dbg !652
  %c.i34 = getelementptr inbounds nuw [8 x i8], ptr %_27, i64 %count2.i33, !dbg !653
  %count3.i35 = select i1 %_0.i18.i27, i64 2, i64 3, !dbg !655
  %d.i36 = getelementptr inbounds nuw [8 x i8], ptr %_27, i64 %count3.i35, !dbg !656
  %c.val.i37 = load i64, ptr %c.i34, align 8, !dbg !658, !noundef !16
  %a.val.i38 = load i64, ptr %a.i29, align 8, !dbg !658, !noundef !16
  %_12.i.i.i19.i39 = ashr i64 %c.val.i37, 63, !dbg !659
  %_10.i.i.i20.i40 = lshr i64 %_12.i.i.i19.i39, 1, !dbg !663
  %18 = xor i64 %_10.i.i.i20.i40, %c.val.i37, !dbg !664
  %_17.i.i.i21.i41 = ashr i64 %a.val.i38, 63, !dbg !665
  %_15.i.i.i22.i42 = lshr i64 %_17.i.i.i21.i41, 1, !dbg !666
  %19 = xor i64 %_15.i.i.i22.i42, %a.val.i38, !dbg !667
  %_0.i23.i43 = icmp slt i64 %18, %19, !dbg !668
  %d.val.i44 = load i64, ptr %d.i36, align 8, !dbg !670, !noundef !16
  %b.val.i45 = load i64, ptr %b.i32, align 8, !dbg !670, !noundef !16
  %_12.i.i.i24.i46 = ashr i64 %d.val.i44, 63, !dbg !671
  %_10.i.i.i25.i47 = lshr i64 %_12.i.i.i24.i46, 1, !dbg !675
  %20 = xor i64 %_10.i.i.i25.i47, %d.val.i44, !dbg !676
  %_17.i.i.i26.i48 = ashr i64 %b.val.i45, 63, !dbg !677
  %_15.i.i.i27.i49 = lshr i64 %_17.i.i.i26.i48, 1, !dbg !678
  %21 = xor i64 %_15.i.i.i27.i49, %b.val.i45, !dbg !679
  %_0.i28.i50 = icmp slt i64 %20, %21, !dbg !680
  %self.i11.i51 = select i1 %_0.i28.i50, ptr %c.i34, ptr %b.i32, !dbg !682, !unpredictable !16
  %self.i10.i52 = select i1 %_0.i23.i43, ptr %a.i29, ptr %self.i11.i51, !dbg !684, !unpredictable !16
  %self.i9.i53 = select i1 %_0.i23.i43, ptr %b.i32, ptr %c.i34, !dbg !686, !unpredictable !16
  %self.i8.i54 = select i1 %_0.i28.i50, ptr %d.i36, ptr %self.i9.i53, !dbg !688, !unpredictable !16
  %self.i8.val.i55 = load i64, ptr %self.i8.i54, align 8, !dbg !690, !noundef !16
  %self.i10.val.i56 = load i64, ptr %self.i10.i52, align 8, !dbg !690, !noundef !16
  %_12.i.i.i29.i57 = ashr i64 %self.i8.val.i55, 63, !dbg !691
  %_10.i.i.i30.i58 = lshr i64 %_12.i.i.i29.i57, 1, !dbg !695
  %22 = xor i64 %_10.i.i.i30.i58, %self.i8.val.i55, !dbg !696
  %_17.i.i.i31.i59 = ashr i64 %self.i10.val.i56, 63, !dbg !697
  %_15.i.i.i32.i60 = lshr i64 %_17.i.i.i31.i59, 1, !dbg !698
  %23 = xor i64 %_15.i.i.i32.i60, %self.i10.val.i56, !dbg !699
  %_0.i33.i61 = icmp slt i64 %22, %23, !dbg !700
  %24 = select i1 %_0.i23.i43, i64 %c.val.i37, i64 %a.val.i38, !dbg !702, !unpredictable !16
  store i64 %24, ptr %_28, align 8, !dbg !704
  %dst4.i62 = getelementptr inbounds nuw i8, ptr %_28, i64 8, !dbg !706
  %25 = select i1 %_0.i33.i61, i64 %self.i8.val.i55, i64 %self.i10.val.i56, !dbg !708, !unpredictable !16
  store i64 %25, ptr %dst4.i62, align 8, !dbg !710
  %dst5.i65 = getelementptr inbounds nuw i8, ptr %_28, i64 16, !dbg !712
  %26 = select i1 %_0.i33.i61, i64 %self.i10.val.i56, i64 %self.i8.val.i55, !dbg !714, !unpredictable !16
  store i64 %26, ptr %dst5.i65, align 8, !dbg !716
  %dst6.i68 = getelementptr inbounds nuw i8, ptr %_28, i64 24, !dbg !718
  %27 = select i1 %_0.i28.i50, i64 %b.val.i45, i64 %d.val.i44, !dbg !720, !unpredictable !16
  store i64 %27, ptr %dst6.i68, align 8, !dbg !722
  br label %bb15, !dbg !724

bb33:                                             ; preds = %bb9
  %28 = load i64, ptr %v.0, align 8, !dbg !725
  store i64 %28, ptr %scratch.0, align 8, !dbg !725
  %_31 = getelementptr inbounds nuw [8 x i8], ptr %v.0, i64 %len_div_29, !dbg !728
  %dst = getelementptr inbounds nuw [8 x i8], ptr %scratch.0, i64 %len_div_29, !dbg !730
  %29 = load i64, ptr %_31, align 8, !dbg !732
  store i64 %29, ptr %dst, align 8, !dbg !732
  br label %bb15, !dbg !724

bb15:                                             ; preds = %bb33, %bb10, %bb6
  %presorted_len.sroa.0.0 = phi i64 [ 8, %bb6 ], [ 4, %bb10 ], [ 1, %bb33 ], !dbg !734
  %30 = sub nsw i64 %v.1, %len_div_29
  %_7390 = icmp samesign ult i64 %presorted_len.sroa.0.0, %len_div_29, !dbg !735
  br i1 %_7390, label %bb38, label %bb16.loopexit, !dbg !739

bb16.loopexit:                                    ; preds = %bb24, %bb15
  %src.1 = getelementptr inbounds nuw [8 x i8], ptr %v.0, i64 %len_div_29, !dbg !757
  %dst5.1 = getelementptr [8 x i8], ptr %scratch.0, i64 %len_div_29, !dbg !759
  %_7390.1 = icmp ult i64 %presorted_len.sroa.0.0, %30, !dbg !735
  br i1 %_7390.1, label %bb38.1, label %bb16.loopexit.1, !dbg !739

bb38.1:                                           ; preds = %bb16.loopexit, %bb24.1
  %iter1.sroa.0.091.1 = phi i64 [ %_77.1, %bb24.1 ], [ %presorted_len.sroa.0.0, %bb16.loopexit ]
  %_49.1 = getelementptr inbounds nuw [8 x i8], ptr %src.1, i64 %iter1.sroa.0.091.1, !dbg !761
  %dst6.1.idx = shl nuw nsw i64 %iter1.sroa.0.091.1, 3, !dbg !764
  %dst6.1 = getelementptr inbounds nuw i8, ptr %dst5.1, i64 %dst6.1.idx, !dbg !764
  %31 = load i64, ptr %_49.1, align 8, !dbg !766
  store i64 %31, ptr %dst6.1, align 8, !dbg !766
  %32 = getelementptr inbounds i8, ptr %dst6.1, i64 -8, !dbg !768
  %.val1.i.1 = load i64, ptr %32, align 8, !dbg !771, !noundef !16
  %_12.i.i.i.i82.1 = ashr i64 %31, 63, !dbg !772
  %_10.i.i.i.i83.1 = lshr i64 %_12.i.i.i.i82.1, 1, !dbg !776
  %33 = xor i64 %_10.i.i.i.i83.1, %31, !dbg !777
  %_17.i.i.i.i84.1 = ashr i64 %.val1.i.1, 63, !dbg !778
  %_15.i.i.i.i85.1 = lshr i64 %_17.i.i.i.i84.1, 1, !dbg !779
  %34 = xor i64 %_15.i.i.i.i85.1, %.val1.i.1, !dbg !780
  %_0.i.i86.1 = icmp slt i64 %33, %34, !dbg !781
  br i1 %_0.i.i86.1, label %bb4.i.1.preheader, label %bb24.1, !dbg !771

bb4.i.1.preheader:                                ; preds = %bb38.1
  store i64 %.val1.i.1, ptr %dst6.1, align 8, !dbg !783
  %_18.i.16 = icmp eq i64 %iter1.sroa.0.091.1, 1, !dbg !785
  br i1 %_18.i.16, label %bb10.i.1, label %bb7.i.1, !dbg !785

bb4.i.1:                                          ; preds = %bb7.i.1
  store i64 %.val.i.1, ptr %sift.sroa.0.0.i.17, align 8, !dbg !783
  %_18.i.1 = icmp eq ptr %35, %dst5.1, !dbg !785
  br i1 %_18.i.1, label %bb10.i.1, label %bb7.i.1, !dbg !785

bb7.i.1:                                          ; preds = %bb4.i.1.preheader, %bb4.i.1
  %sift.sroa.0.0.i.17 = phi ptr [ %35, %bb4.i.1 ], [ %32, %bb4.i.1.preheader ]
  %35 = getelementptr inbounds i8, ptr %sift.sroa.0.0.i.17, i64 -8, !dbg !786
  %.val.i.1 = load i64, ptr %35, align 8, !dbg !788, !noundef !16
  %_17.i.i.i4.i.1 = ashr i64 %.val.i.1, 63, !dbg !789
  %_15.i.i.i5.i.1 = lshr i64 %_17.i.i.i4.i.1, 1, !dbg !793
  %36 = xor i64 %_15.i.i.i5.i.1, %.val.i.1, !dbg !794
  %_0.i6.i.1 = icmp slt i64 %33, %36, !dbg !795
  br i1 %_0.i6.i.1, label %bb4.i.1, label %bb10.i.1, !dbg !788

bb10.i.1:                                         ; preds = %bb4.i.1, %bb7.i.1, %bb4.i.1.preheader
  %sift.sroa.0.0.i.lcssa.1 = phi ptr [ %dst5.1, %bb4.i.1.preheader ], [ %dst5.1, %bb4.i.1 ], [ %sift.sroa.0.0.i.17, %bb7.i.1 ], !dbg !797
  store i64 %31, ptr %sift.sroa.0.0.i.lcssa.1, align 8, !dbg !798, !noalias !802
  br label %bb24.1, !dbg !807

bb24.1:                                           ; preds = %bb10.i.1, %bb38.1
  %_77.1 = add nuw i64 %iter1.sroa.0.091.1, 1, !dbg !808
  %exitcond.1.not = icmp eq i64 %_77.1, %30, !dbg !735
  br i1 %exitcond.1.not, label %bb16.loopexit.1, label %bb38.1, !dbg !739

bb16.loopexit.1:                                  ; preds = %bb24.1, %bb16.loopexit
  tail call void @llvm.experimental.noalias.scope.decl(metadata !818), !dbg !821
  %count1.i73 = add nsw i64 %v.1, -1, !dbg !823
  %37 = getelementptr inbounds nuw [8 x i8], ptr %v.0, i64 %count1.i73, !dbg !825
  %38 = getelementptr inbounds nuw [8 x i8], ptr %scratch.0, i64 %count1.i73, !dbg !827
  %39 = getelementptr i8, ptr %dst5.1, i64 -8, !dbg !830
  br label %bb15.i, !dbg !832

bb16.i:                                           ; preds = %bb15.i
  %left_end.i = getelementptr i8, ptr %_14.i.i, i64 8, !dbg !838
  %right_end.i = getelementptr i8, ptr %_12.i.i, i64 8, !dbg !841
  %_43.i = and i64 %v.1, 1, !dbg !844
  %_22.i = icmp eq i64 %_43.i, 0, !dbg !844
  br i1 %_22.i, label %bb9.i, label %bb5.i, !dbg !847

bb15.i:                                           ; preds = %bb15.i, %bb16.loopexit.1
  %dst.sroa.0.012.i = phi ptr [ %_16.i.i, %bb15.i ], [ %v.0, %bb16.loopexit.1 ]
  %iter.sroa.0.011.i = phi i64 [ %_39.i, %bb15.i ], [ 0, %bb16.loopexit.1 ]
  %left.sroa.0.010.i = phi ptr [ %_14.i19.i, %bb15.i ], [ %scratch.0, %bb16.loopexit.1 ]
  %right.sroa.0.09.i = phi ptr [ %_12.i18.i, %bb15.i ], [ %dst5.1, %bb16.loopexit.1 ]
  %left_rev.sroa.0.08.i = phi ptr [ %_14.i.i, %bb15.i ], [ %39, %bb16.loopexit.1 ]
  %right_rev.sroa.0.07.i = phi ptr [ %_12.i.i, %bb15.i ], [ %38, %bb16.loopexit.1 ]
  %dst_rev.sroa.0.06.i = phi ptr [ %46, %bb15.i ], [ %37, %bb16.loopexit.1 ]
  %_39.i = add nuw nsw i64 %iter.sroa.0.011.i, 1, !dbg !848
  %right.sroa.0.0.val.i = load i64, ptr %right.sroa.0.09.i, align 8, !dbg !854, !alias.scope !818, !noundef !16
  %left.sroa.0.0.val.i = load i64, ptr %left.sroa.0.010.i, align 8, !dbg !854, !alias.scope !818, !noundef !16
  %_12.i.i.i.i74 = ashr i64 %right.sroa.0.0.val.i, 63, !dbg !856
  %_10.i.i.i.i75 = lshr i64 %_12.i.i.i.i74, 1, !dbg !860
  %40 = xor i64 %_10.i.i.i.i75, %right.sroa.0.0.val.i, !dbg !861
  %_17.i.i.i.i76 = ashr i64 %left.sroa.0.0.val.i, 63, !dbg !862
  %_15.i.i.i.i77 = lshr i64 %_17.i.i.i.i76, 1, !dbg !863
  %41 = xor i64 %_15.i.i.i.i77, %left.sroa.0.0.val.i, !dbg !864
  %_0.i.i78 = icmp slt i64 %40, %41, !dbg !865
  %is_l.i17.i = xor i1 %_0.i.i78, true, !dbg !867
  %42 = select i1 %_0.i.i78, i64 %right.sroa.0.0.val.i, i64 %left.sroa.0.0.val.i, !dbg !868
  store i64 %42, ptr %dst.sroa.0.012.i, align 8, !dbg !869, !noalias !871
  %count.i.i = zext i1 %_0.i.i78 to i64, !dbg !875
  %_12.i18.i = getelementptr inbounds nuw [8 x i8], ptr %right.sroa.0.09.i, i64 %count.i.i, !dbg !876
  %count2.i.i = zext i1 %is_l.i17.i to i64, !dbg !878
  %_14.i19.i = getelementptr inbounds nuw [8 x i8], ptr %left.sroa.0.010.i, i64 %count2.i.i, !dbg !879
  %_16.i.i = getelementptr inbounds nuw i8, ptr %dst.sroa.0.012.i, i64 8, !dbg !881
  %right_rev.sroa.0.0.val.i = load i64, ptr %right_rev.sroa.0.07.i, align 8, !dbg !883, !alias.scope !818, !noundef !16
  %left_rev.sroa.0.0.val.i = load i64, ptr %left_rev.sroa.0.08.i, align 8, !dbg !883, !alias.scope !818, !noundef !16
  %_12.i.i.i20.i = ashr i64 %right_rev.sroa.0.0.val.i, 63, !dbg !885
  %_10.i.i.i21.i = lshr i64 %_12.i.i.i20.i, 1, !dbg !889
  %43 = xor i64 %_10.i.i.i21.i, %right_rev.sroa.0.0.val.i, !dbg !890
  %_17.i.i.i22.i = ashr i64 %left_rev.sroa.0.0.val.i, 63, !dbg !891
  %_15.i.i.i23.i = lshr i64 %_17.i.i.i22.i, 1, !dbg !892
  %44 = xor i64 %_15.i.i.i23.i, %left_rev.sroa.0.0.val.i, !dbg !893
  %_0.i24.i = icmp slt i64 %43, %44, !dbg !894
  %is_l.i.i = xor i1 %_0.i24.i, true, !dbg !896
  %45 = select i1 %_0.i24.i, i64 %left_rev.sroa.0.0.val.i, i64 %right_rev.sroa.0.0.val.i, !dbg !897
  store i64 %45, ptr %dst_rev.sroa.0.06.i, align 8, !dbg !898, !noalias !900
  %count.neg.i.i = sext i1 %is_l.i.i to i64, !dbg !904
  %_12.i.i = getelementptr [8 x i8], ptr %right_rev.sroa.0.07.i, i64 %count.neg.i.i, !dbg !905
  %count3.neg.i.i = sext i1 %_0.i24.i to i64, !dbg !908
  %_14.i.i = getelementptr [8 x i8], ptr %left_rev.sroa.0.08.i, i64 %count3.neg.i.i, !dbg !909
  %46 = getelementptr inbounds i8, ptr %dst_rev.sroa.0.06.i, i64 -8, !dbg !912
  %exitcond.not.i = icmp eq i64 %_39.i, %len_div_29, !dbg !914
  br i1 %exitcond.not.i, label %bb16.i, label %bb15.i, !dbg !832

bb5.i:                                            ; preds = %bb16.i
  %left_nonempty.i = icmp ult ptr %_14.i19.i, %left_end.i, !dbg !917
  %left.sroa.0.0.right.sroa.0.0.i = select i1 %left_nonempty.i, ptr %_14.i19.i, ptr %_12.i18.i, !dbg !918
  %47 = load i64, ptr %left.sroa.0.0.right.sroa.0.0.i, align 8, !dbg !920, !alias.scope !818
  store i64 %47, ptr %_16.i.i, align 8, !dbg !920, !noalias !818
  %count2.i79 = zext i1 %left_nonempty.i to i64, !dbg !924
  %_26.i = getelementptr inbounds nuw [8 x i8], ptr %_14.i19.i, i64 %count2.i79, !dbg !925
  %_30.i = xor i1 %left_nonempty.i, true, !dbg !927
  %count3.i80 = zext i1 %_30.i to i64, !dbg !927
  %_28.i = getelementptr inbounds nuw [8 x i8], ptr %_12.i18.i, i64 %count3.i80, !dbg !928
  br label %bb9.i, !dbg !930

bb9.i:                                            ; preds = %bb5.i, %bb16.i
  %right.sroa.0.1.i = phi ptr [ %_12.i18.i, %bb16.i ], [ %_28.i, %bb5.i ], !dbg !931
  %left.sroa.0.1.i = phi ptr [ %_14.i19.i, %bb16.i ], [ %_26.i, %bb5.i ], !dbg !932
  %_31.i = icmp ne ptr %left.sroa.0.1.i, %left_end.i, !dbg !933
  %_32.i = icmp ne ptr %right.sroa.0.1.i, %right_end.i
  %or.cond.i = select i1 %_31.i, i1 true, i1 %_32.i, !dbg !933, !prof !407
  br i1 %or.cond.i, label %bb13.i, label %bb27, !dbg !933, !prof !407

bb13.i:                                           ; preds = %bb9.i
; invoke core::slice::sort::shared::smallsort::panic_on_ord_violation
  invoke void @_RNvNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6shared9smallsort22panic_on_ord_violation() #7
          to label %.noexc unwind label %cleanup2, !dbg !934

.noexc:                                           ; preds = %bb13.i
  unreachable, !dbg !934

cleanup2:                                         ; preds = %bb13.i
  %48 = landingpad { ptr, i32 }
          cleanup
  %49 = shl nuw nsw i64 %v.1, 3, !dbg !935
  tail call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 8 %v.0, ptr nonnull align 8 %scratch.0, i64 %49, i1 false), !dbg !935, !noalias !939
  resume { ptr, i32 } %48, !dbg !944

bb27:                                             ; preds = %bb9.i, %start
  ret void, !dbg !945

bb38:                                             ; preds = %bb15, %bb24
  %iter1.sroa.0.091 = phi i64 [ %_77, %bb24 ], [ %presorted_len.sroa.0.0, %bb15 ]
  %_49 = getelementptr inbounds nuw [8 x i8], ptr %v.0, i64 %iter1.sroa.0.091, !dbg !761
  %dst6.idx = shl nuw nsw i64 %iter1.sroa.0.091, 3, !dbg !764
  %dst6 = getelementptr inbounds nuw i8, ptr %scratch.0, i64 %dst6.idx, !dbg !764
  %50 = load i64, ptr %_49, align 8, !dbg !766
  store i64 %50, ptr %dst6, align 8, !dbg !766
  %51 = getelementptr inbounds i8, ptr %dst6, i64 -8, !dbg !768
  %.val1.i = load i64, ptr %51, align 8, !dbg !771, !noundef !16
  %_12.i.i.i.i82 = ashr i64 %50, 63, !dbg !772
  %_10.i.i.i.i83 = lshr i64 %_12.i.i.i.i82, 1, !dbg !776
  %52 = xor i64 %_10.i.i.i.i83, %50, !dbg !777
  %_17.i.i.i.i84 = ashr i64 %.val1.i, 63, !dbg !778
  %_15.i.i.i.i85 = lshr i64 %_17.i.i.i.i84, 1, !dbg !779
  %53 = xor i64 %_15.i.i.i.i85, %.val1.i, !dbg !780
  %_0.i.i86 = icmp slt i64 %52, %53, !dbg !781
  br i1 %_0.i.i86, label %bb4.i.preheader, label %bb24, !dbg !771

bb4.i.preheader:                                  ; preds = %bb38
  store i64 %.val1.i, ptr %dst6, align 8, !dbg !783
  %_18.i3 = icmp eq i64 %iter1.sroa.0.091, 1, !dbg !785
  br i1 %_18.i3, label %bb10.i, label %bb7.i, !dbg !785

bb4.i:                                            ; preds = %bb7.i
  store i64 %.val.i, ptr %sift.sroa.0.0.i4, align 8, !dbg !783
  %_18.i = icmp eq ptr %54, %scratch.0, !dbg !785
  br i1 %_18.i, label %bb10.i, label %bb7.i, !dbg !785

bb7.i:                                            ; preds = %bb4.i.preheader, %bb4.i
  %sift.sroa.0.0.i4 = phi ptr [ %54, %bb4.i ], [ %51, %bb4.i.preheader ]
  %54 = getelementptr inbounds i8, ptr %sift.sroa.0.0.i4, i64 -8, !dbg !786
  %.val.i = load i64, ptr %54, align 8, !dbg !788, !noundef !16
  %_17.i.i.i4.i = ashr i64 %.val.i, 63, !dbg !789
  %_15.i.i.i5.i = lshr i64 %_17.i.i.i4.i, 1, !dbg !793
  %55 = xor i64 %_15.i.i.i5.i, %.val.i, !dbg !794
  %_0.i6.i = icmp slt i64 %52, %55, !dbg !795
  br i1 %_0.i6.i, label %bb4.i, label %bb10.i, !dbg !788

bb10.i:                                           ; preds = %bb4.i, %bb7.i, %bb4.i.preheader
  %sift.sroa.0.0.i.lcssa = phi ptr [ %scratch.0, %bb4.i.preheader ], [ %scratch.0, %bb4.i ], [ %sift.sroa.0.0.i4, %bb7.i ], !dbg !797
  store i64 %50, ptr %sift.sroa.0.0.i.lcssa, align 8, !dbg !798, !noalias !802
  br label %bb24, !dbg !807

bb24:                                             ; preds = %bb10.i, %bb38
  %_77 = add nuw i64 %iter1.sroa.0.091, 1, !dbg !808
  %exitcond.not = icmp eq i64 %_77, %len_div_29, !dbg !735
  br i1 %exitcond.not, label %bb16.loopexit, label %bb38, !dbg !739
}

; Function Attrs: nounwind uwtable
declare noundef range(i32 0, 10) i32 @rust_eh_personality(i32 noundef, i32 noundef, i64 noundef, ptr noundef, ptr noundef) unnamed_addr #2

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.memcpy.p0.p0.i64(ptr noalias writeonly captures(none), ptr noalias readonly captures(none), i64, i1 immarg) #3

; core::slice::sort::shared::smallsort::panic_on_ord_violation
; Function Attrs: cold noinline noreturn uwtable
declare void @_RNvNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6shared9smallsort22panic_on_ord_violation() unnamed_addr #4

; Function Attrs: cold noreturn nounwind memory(inaccessiblemem: write)
declare void @llvm.trap() #5

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(inaccessiblemem: readwrite)
declare void @llvm.experimental.noalias.scope.decl(metadata) #6

attributes #0 = { uwtable "frame-pointer"="non-leaf" "probe-stack"="inline-asm" "target-cpu"="apple-m1" }
attributes #1 = { nounwind memory(argmem: readwrite, inaccessiblemem: write) uwtable "frame-pointer"="non-leaf" "probe-stack"="inline-asm" "target-cpu"="apple-m1" }
attributes #2 = { nounwind uwtable "frame-pointer"="non-leaf" "probe-stack"="inline-asm" "target-cpu"="apple-m1" }
attributes #3 = { nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #4 = { cold noinline noreturn uwtable "frame-pointer"="non-leaf" "probe-stack"="inline-asm" "target-cpu"="apple-m1" }
attributes #5 = { cold noreturn nounwind memory(inaccessiblemem: write) }
attributes #6 = { nocallback nofree nosync nounwind willreturn memory(inaccessiblemem: readwrite) }
attributes #7 = { noinline noreturn }

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
!7 = !DIFile(filename: "src/lib.rs/@/evidence_lab.4789476f54c908b2-cgu.02", directory: "/Users/juanwang/Desktop/tutorials/cpp-rust/bench/evidence-lab")
!8 = distinct !DISubprogram(name: "sort8_stable<f64, alloc::slice::{impl#0}::sort_by::{closure_env#0}<f64, fn(&f64, &f64) -> core::cmp::Ordering>>", linkageName: "_RINvNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6shared9smallsort12sort8_stabledNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtBa_3f64d9total_cmpE0ECs68MIsFmw01O_12evidence_lab", scope: !10, file: !9, line: 657, type: !15, scopeLine: 657, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !16)
!9 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/slice/sort/shared/smallsort.rs", directory: "", checksumkind: CSK_MD5, checksum: "f8936f6f0845bec345ad21dc77043e14")
!10 = !DINamespace(name: "smallsort", scope: !11)
!11 = !DINamespace(name: "shared", scope: !12)
!12 = !DINamespace(name: "sort", scope: !13)
!13 = !DINamespace(name: "slice", scope: !14)
!14 = !DINamespace(name: "core", scope: null)
!15 = !DISubroutineType(cc: DW_CC_nocall, types: !16)
!16 = !{}
!17 = !{i64 7352441258334034858}
!18 = !DILocation(line: 871, column: 18, scope: !19, inlinedAt: !25)
!19 = distinct !DISubprogram(name: "add<f64>", linkageName: "_RNvMNtNtCsjIpoRzUjyHQ_4core3ptr9const_ptrPd3addCs68MIsFmw01O_12evidence_lab", scope: !21, file: !20, line: 837, type: !24, scopeLine: 837, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !16)
!20 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/ptr/const_ptr.rs", directory: "", checksumkind: CSK_MD5, checksum: "25118ae25e729b7c815218b31622724c")
!21 = !DINamespace(name: "{impl#0}", scope: !22)
!22 = !DINamespace(name: "const_ptr", scope: !23)
!23 = !DINamespace(name: "ptr", scope: !14)
!24 = !DISubroutineType(types: !16)
!25 = distinct !DILocation(line: 620, column: 35, scope: !26, inlinedAt: !27)
!26 = distinct !DISubprogram(name: "sort4_stable<f64, alloc::slice::{impl#0}::sort_by::{closure_env#0}<f64, fn(&f64, &f64) -> core::cmp::Ordering>>", linkageName: "_RINvNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6shared9smallsort12sort4_stabledNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtBa_3f64d9total_cmpE0ECs68MIsFmw01O_12evidence_lab", scope: !10, file: !9, line: 606, type: !15, scopeLine: 606, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !16)
!27 = distinct !DILocation(line: 665, column: 9, scope: !8)
!28 = !DILocation(line: 620, column: 18, scope: !26, inlinedAt: !27)
!29 = !DILocation(line: 1547, column: 19, scope: !30, inlinedAt: !36)
!30 = distinct !DILexicalBlock(scope: !32, file: !31, line: 1523, column: 9)
!31 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/num/f64.rs", directory: "", checksumkind: CSK_MD5, checksum: "b3f8ed35e28142dfe7f88c4667789fd1")
!32 = distinct !DILexicalBlock(scope: !33, file: !31, line: 1522, column: 9)
!33 = distinct !DISubprogram(name: "total_cmp", linkageName: "_RNvMNtCsjIpoRzUjyHQ_4core3f64d9total_cmp", scope: !34, file: !31, line: 1521, type: !15, scopeLine: 1521, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !16)
!34 = !DINamespace(name: "{impl#0}", scope: !35)
!35 = !DINamespace(name: "f64", scope: !14)
!36 = distinct !DILocation(line: 166, column: 5, scope: !37, inlinedAt: !42)
!37 = distinct !DISubprogram(name: "call_mut<fn(&f64, &f64) -> core::cmp::Ordering, (&f64, &f64)>", linkageName: "_RNvYNvMNtCsjIpoRzUjyHQ_4core3f64d9total_cmpINtNtNtB7_3ops8function5FnMutTRdB19_EE8call_mutCs68MIsFmw01O_12evidence_lab", scope: !39, file: !38, line: 166, type: !15, scopeLine: 166, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !16)
!38 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/ops/function.rs", directory: "", checksumkind: CSK_MD5, checksum: "ae01f833f82cd27aa916c99d95502941")
!39 = !DINamespace(name: "FnMut", scope: !40)
!40 = !DINamespace(name: "function", scope: !41)
!41 = !DINamespace(name: "ops", scope: !14)
!42 = distinct !DILocation(line: 196, column: 34, scope: !43, inlinedAt: !49)
!43 = distinct !DISubprogram(name: "{closure#0}<f64, fn(&f64, &f64) -> core::cmp::Ordering>", linkageName: "_RNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtCsjIpoRzUjyHQ_4core3f64d9total_cmpE0Cs68MIsFmw01O_12evidence_lab", scope: !45, file: !44, line: 196, type: !15, scopeLine: 196, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !16)
!44 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/alloc/src/slice.rs", directory: "", checksumkind: CSK_MD5, checksum: "8e7bce5d617a4e88f7bdb700dff9d669")
!45 = !DINamespace(name: "sort_by", scope: !46)
!46 = !DINamespace(name: "{impl#0}", scope: !47)
!47 = !DINamespace(name: "slice", scope: !48)
!48 = !DINamespace(name: "alloc", scope: null)
!49 = distinct !DILocation(line: 620, column: 18, scope: !26, inlinedAt: !27)
!50 = !DILocation(line: 1547, column: 17, scope: !30, inlinedAt: !36)
!51 = !DILocation(line: 1547, column: 9, scope: !30, inlinedAt: !36)
!52 = !DILocation(line: 1548, column: 20, scope: !30, inlinedAt: !36)
!53 = !DILocation(line: 1548, column: 18, scope: !30, inlinedAt: !36)
!54 = !DILocation(line: 1548, column: 9, scope: !30, inlinedAt: !36)
!55 = !DILocation(line: 410, column: 44, scope: !56, inlinedAt: !62)
!56 = distinct !DILexicalBlock(scope: !58, file: !57, line: 410, column: 44)
!57 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/cmp.rs", directory: "", checksumkind: CSK_MD5, checksum: "49e2a03e6445d88887d9438f640a7fcc")
!58 = distinct !DILexicalBlock(scope: !59, file: !57, line: 410, column: 44)
!59 = distinct !DISubprogram(name: "eq", linkageName: "_RNvXsb_NtCsjIpoRzUjyHQ_4core3cmpNtB5_8OrderingNtB5_9PartialEq2eq", scope: !60, file: !57, line: 410, type: !24, scopeLine: 410, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !16)
!60 = !DINamespace(name: "{impl#13}", scope: !61)
!61 = !DINamespace(name: "cmp", scope: !14)
!62 = distinct !DILocation(line: 196, column: 34, scope: !43, inlinedAt: !49)
!63 = !DILocation(line: 871, column: 18, scope: !19, inlinedAt: !64)
!64 = distinct !DILocation(line: 621, column: 35, scope: !65, inlinedAt: !27)
!65 = distinct !DILexicalBlock(scope: !26, file: !9, line: 620, column: 9)
!66 = !DILocation(line: 871, column: 18, scope: !19, inlinedAt: !67)
!67 = distinct !DILocation(line: 621, column: 52, scope: !65, inlinedAt: !27)
!68 = !DILocation(line: 621, column: 18, scope: !65, inlinedAt: !27)
!69 = !DILocation(line: 1547, column: 19, scope: !30, inlinedAt: !70)
!70 = distinct !DILocation(line: 166, column: 5, scope: !37, inlinedAt: !71)
!71 = distinct !DILocation(line: 196, column: 34, scope: !43, inlinedAt: !72)
!72 = distinct !DILocation(line: 621, column: 18, scope: !65, inlinedAt: !27)
!73 = !DILocation(line: 1547, column: 17, scope: !30, inlinedAt: !70)
!74 = !DILocation(line: 1547, column: 9, scope: !30, inlinedAt: !70)
!75 = !DILocation(line: 1548, column: 20, scope: !30, inlinedAt: !70)
!76 = !DILocation(line: 1548, column: 18, scope: !30, inlinedAt: !70)
!77 = !DILocation(line: 1548, column: 9, scope: !30, inlinedAt: !70)
!78 = !DILocation(line: 410, column: 44, scope: !56, inlinedAt: !79)
!79 = distinct !DILocation(line: 196, column: 34, scope: !43, inlinedAt: !72)
!80 = !DILocation(line: 622, column: 28, scope: !81, inlinedAt: !27)
!81 = distinct !DILexicalBlock(scope: !65, file: !9, line: 621, column: 9)
!82 = !DILocation(line: 871, column: 18, scope: !19, inlinedAt: !83)
!83 = distinct !DILocation(line: 622, column: 24, scope: !81, inlinedAt: !27)
!84 = !DILocation(line: 623, column: 28, scope: !85, inlinedAt: !27)
!85 = distinct !DILexicalBlock(scope: !81, file: !9, line: 622, column: 9)
!86 = !DILocation(line: 871, column: 18, scope: !19, inlinedAt: !87)
!87 = distinct !DILocation(line: 623, column: 24, scope: !85, inlinedAt: !27)
!88 = !DILocation(line: 624, column: 28, scope: !89, inlinedAt: !27)
!89 = distinct !DILexicalBlock(scope: !85, file: !9, line: 623, column: 9)
!90 = !DILocation(line: 871, column: 18, scope: !19, inlinedAt: !91)
!91 = distinct !DILocation(line: 624, column: 24, scope: !89, inlinedAt: !27)
!92 = !DILocation(line: 625, column: 28, scope: !93, inlinedAt: !27)
!93 = distinct !DILexicalBlock(scope: !89, file: !9, line: 624, column: 9)
!94 = !DILocation(line: 871, column: 18, scope: !19, inlinedAt: !95)
!95 = distinct !DILocation(line: 625, column: 24, scope: !93, inlinedAt: !27)
!96 = !DILocation(line: 635, column: 18, scope: !97, inlinedAt: !27)
!97 = distinct !DILexicalBlock(scope: !93, file: !9, line: 625, column: 9)
!98 = !DILocation(line: 1547, column: 19, scope: !30, inlinedAt: !99)
!99 = distinct !DILocation(line: 166, column: 5, scope: !37, inlinedAt: !100)
!100 = distinct !DILocation(line: 196, column: 34, scope: !43, inlinedAt: !101)
!101 = distinct !DILocation(line: 635, column: 18, scope: !97, inlinedAt: !27)
!102 = !DILocation(line: 1547, column: 17, scope: !30, inlinedAt: !99)
!103 = !DILocation(line: 1547, column: 9, scope: !30, inlinedAt: !99)
!104 = !DILocation(line: 1548, column: 20, scope: !30, inlinedAt: !99)
!105 = !DILocation(line: 1548, column: 18, scope: !30, inlinedAt: !99)
!106 = !DILocation(line: 1548, column: 9, scope: !30, inlinedAt: !99)
!107 = !DILocation(line: 410, column: 44, scope: !56, inlinedAt: !108)
!108 = distinct !DILocation(line: 196, column: 34, scope: !43, inlinedAt: !101)
!109 = !DILocation(line: 636, column: 18, scope: !110, inlinedAt: !27)
!110 = distinct !DILexicalBlock(scope: !97, file: !9, line: 635, column: 9)
!111 = !DILocation(line: 1547, column: 19, scope: !30, inlinedAt: !112)
!112 = distinct !DILocation(line: 166, column: 5, scope: !37, inlinedAt: !113)
!113 = distinct !DILocation(line: 196, column: 34, scope: !43, inlinedAt: !114)
!114 = distinct !DILocation(line: 636, column: 18, scope: !110, inlinedAt: !27)
!115 = !DILocation(line: 1547, column: 17, scope: !30, inlinedAt: !112)
!116 = !DILocation(line: 1547, column: 9, scope: !30, inlinedAt: !112)
!117 = !DILocation(line: 1548, column: 20, scope: !30, inlinedAt: !112)
!118 = !DILocation(line: 1548, column: 18, scope: !30, inlinedAt: !112)
!119 = !DILocation(line: 1548, column: 9, scope: !30, inlinedAt: !112)
!120 = !DILocation(line: 410, column: 44, scope: !56, inlinedAt: !121)
!121 = distinct !DILocation(line: 196, column: 34, scope: !43, inlinedAt: !114)
!122 = !DILocation(line: 879, column: 9, scope: !123, inlinedAt: !133)
!123 = distinct !DILexicalBlock(scope: !125, file: !124, line: 872, column: 9)
!124 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/hint.rs", directory: "", checksumkind: CSK_MD5, checksum: "720ecb12dbf1a304509abd161627e0e2")
!125 = distinct !DILexicalBlock(scope: !126, file: !124, line: 866, column: 9)
!126 = distinct !DILexicalBlock(scope: !127, file: !124, line: 865, column: 9)
!127 = distinct !DILexicalBlock(scope: !128, file: !124, line: 855, column: 5)
!128 = distinct !DILexicalBlock(scope: !129, file: !124, line: 854, column: 5)
!129 = distinct !DILexicalBlock(scope: !130, file: !124, line: 839, column: 5)
!130 = distinct !DILexicalBlock(scope: !131, file: !124, line: 838, column: 5)
!131 = distinct !DISubprogram(name: "select_unpredictable<*const f64>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core4hint20select_unpredictablePdECs68MIsFmw01O_12evidence_lab", scope: !132, file: !124, line: 832, type: !24, scopeLine: 832, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !16)
!132 = !DINamespace(name: "hint", scope: !14)
!133 = distinct !DILocation(line: 639, column: 62, scope: !134, inlinedAt: !27)
!134 = distinct !DILexicalBlock(scope: !135, file: !9, line: 638, column: 9)
!135 = distinct !DILexicalBlock(scope: !136, file: !9, line: 637, column: 9)
!136 = distinct !DILexicalBlock(scope: !110, file: !9, line: 636, column: 9)
!137 = !DILocation(line: 879, column: 9, scope: !123, inlinedAt: !138)
!138 = distinct !DILocation(line: 639, column: 28, scope: !134, inlinedAt: !27)
!139 = !DILocation(line: 879, column: 9, scope: !123, inlinedAt: !140)
!140 = distinct !DILocation(line: 640, column: 63, scope: !141, inlinedAt: !27)
!141 = distinct !DILexicalBlock(scope: !134, file: !9, line: 639, column: 9)
!142 = !DILocation(line: 879, column: 9, scope: !123, inlinedAt: !143)
!143 = distinct !DILocation(line: 640, column: 29, scope: !141, inlinedAt: !27)
!144 = !DILocation(line: 643, column: 18, scope: !145, inlinedAt: !27)
!145 = distinct !DILexicalBlock(scope: !141, file: !9, line: 640, column: 9)
!146 = !DILocation(line: 1547, column: 19, scope: !30, inlinedAt: !147)
!147 = distinct !DILocation(line: 166, column: 5, scope: !37, inlinedAt: !148)
!148 = distinct !DILocation(line: 196, column: 34, scope: !43, inlinedAt: !149)
!149 = distinct !DILocation(line: 643, column: 18, scope: !145, inlinedAt: !27)
!150 = !DILocation(line: 1547, column: 17, scope: !30, inlinedAt: !147)
!151 = !DILocation(line: 1547, column: 9, scope: !30, inlinedAt: !147)
!152 = !DILocation(line: 1548, column: 20, scope: !30, inlinedAt: !147)
!153 = !DILocation(line: 1548, column: 18, scope: !30, inlinedAt: !147)
!154 = !DILocation(line: 1548, column: 9, scope: !30, inlinedAt: !147)
!155 = !DILocation(line: 410, column: 44, scope: !56, inlinedAt: !156)
!156 = distinct !DILocation(line: 196, column: 34, scope: !43, inlinedAt: !149)
!157 = !DILocation(line: 879, column: 9, scope: !123, inlinedAt: !158)
!158 = distinct !DILocation(line: 637, column: 19, scope: !136, inlinedAt: !27)
!159 = !DILocation(line: 573, column: 14, scope: !160, inlinedAt: !162)
!160 = distinct !DISubprogram(name: "copy_nonoverlapping<f64>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3ptr19copy_nonoverlappingdECs68MIsFmw01O_12evidence_lab", scope: !23, file: !161, line: 552, type: !24, scopeLine: 552, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !16)
!161 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/ptr/mod.rs", directory: "", checksumkind: CSK_MD5, checksum: "59033ebc630da002040513c25c9de121")
!162 = distinct !DILocation(line: 647, column: 9, scope: !163, inlinedAt: !27)
!163 = distinct !DILexicalBlock(scope: !164, file: !9, line: 645, column: 9)
!164 = distinct !DILexicalBlock(scope: !165, file: !9, line: 644, column: 9)
!165 = distinct !DILexicalBlock(scope: !145, file: !9, line: 643, column: 9)
!166 = !DILocation(line: 970, column: 18, scope: !167, inlinedAt: !171)
!167 = distinct !DISubprogram(name: "add<f64>", linkageName: "_RNvMNtNtCsjIpoRzUjyHQ_4core3ptr7mut_ptrOd3addCs68MIsFmw01O_12evidence_lab", scope: !169, file: !168, line: 936, type: !24, scopeLine: 936, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !16)
!168 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/ptr/mut_ptr.rs", directory: "", checksumkind: CSK_MD5, checksum: "0a9a444e8d978ea2fd7622da49f95724")
!169 = !DINamespace(name: "{impl#0}", scope: !170)
!170 = !DINamespace(name: "mut_ptr", scope: !23)
!171 = distinct !DILocation(line: 648, column: 42, scope: !163, inlinedAt: !27)
!172 = !DILocation(line: 573, column: 14, scope: !160, inlinedAt: !173)
!173 = distinct !DILocation(line: 648, column: 9, scope: !163, inlinedAt: !27)
!174 = !DILocation(line: 879, column: 9, scope: !123, inlinedAt: !175)
!175 = distinct !DILocation(line: 644, column: 18, scope: !165, inlinedAt: !27)
!176 = !DILocation(line: 970, column: 18, scope: !167, inlinedAt: !177)
!177 = distinct !DILocation(line: 649, column: 42, scope: !163, inlinedAt: !27)
!178 = !DILocation(line: 573, column: 14, scope: !160, inlinedAt: !179)
!179 = distinct !DILocation(line: 649, column: 9, scope: !163, inlinedAt: !27)
!180 = !DILocation(line: 879, column: 9, scope: !123, inlinedAt: !181)
!181 = distinct !DILocation(line: 645, column: 18, scope: !164, inlinedAt: !27)
!182 = !DILocation(line: 970, column: 18, scope: !167, inlinedAt: !183)
!183 = distinct !DILocation(line: 650, column: 43, scope: !163, inlinedAt: !27)
!184 = !DILocation(line: 573, column: 14, scope: !160, inlinedAt: !185)
!185 = distinct !DILocation(line: 650, column: 9, scope: !163, inlinedAt: !27)
!186 = !DILocation(line: 879, column: 9, scope: !123, inlinedAt: !187)
!187 = distinct !DILocation(line: 638, column: 19, scope: !135, inlinedAt: !27)
!188 = !DILocation(line: 970, column: 18, scope: !189, inlinedAt: !190)
!189 = distinct !DISubprogram(name: "add<f64>", linkageName: "_RNvMNtNtCsjIpoRzUjyHQ_4core3ptr7mut_ptrOd3addCs68MIsFmw01O_12evidence_lab", scope: !169, file: !168, line: 936, type: !24, scopeLine: 936, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !16)
!190 = !DILocation(line: 666, column: 29, scope: !8)
!191 = !DILocation(line: 970, column: 18, scope: !189, inlinedAt: !192)
!192 = !DILocation(line: 666, column: 50, scope: !8)
!193 = !DILocation(line: 871, column: 18, scope: !19, inlinedAt: !194)
!194 = distinct !DILocation(line: 620, column: 35, scope: !26, inlinedAt: !195)
!195 = distinct !DILocation(line: 666, column: 9, scope: !8)
!196 = !DILocation(line: 620, column: 18, scope: !26, inlinedAt: !195)
!197 = !DILocation(line: 1547, column: 19, scope: !30, inlinedAt: !198)
!198 = distinct !DILocation(line: 166, column: 5, scope: !37, inlinedAt: !199)
!199 = distinct !DILocation(line: 196, column: 34, scope: !43, inlinedAt: !200)
!200 = distinct !DILocation(line: 620, column: 18, scope: !26, inlinedAt: !195)
!201 = !DILocation(line: 1547, column: 17, scope: !30, inlinedAt: !198)
!202 = !DILocation(line: 1547, column: 9, scope: !30, inlinedAt: !198)
!203 = !DILocation(line: 1548, column: 20, scope: !30, inlinedAt: !198)
!204 = !DILocation(line: 1548, column: 18, scope: !30, inlinedAt: !198)
!205 = !DILocation(line: 1548, column: 9, scope: !30, inlinedAt: !198)
!206 = !DILocation(line: 410, column: 44, scope: !56, inlinedAt: !207)
!207 = distinct !DILocation(line: 196, column: 34, scope: !43, inlinedAt: !200)
!208 = !DILocation(line: 871, column: 18, scope: !19, inlinedAt: !209)
!209 = distinct !DILocation(line: 621, column: 35, scope: !65, inlinedAt: !195)
!210 = !DILocation(line: 871, column: 18, scope: !19, inlinedAt: !211)
!211 = distinct !DILocation(line: 621, column: 52, scope: !65, inlinedAt: !195)
!212 = !DILocation(line: 621, column: 18, scope: !65, inlinedAt: !195)
!213 = !DILocation(line: 1547, column: 19, scope: !30, inlinedAt: !214)
!214 = distinct !DILocation(line: 166, column: 5, scope: !37, inlinedAt: !215)
!215 = distinct !DILocation(line: 196, column: 34, scope: !43, inlinedAt: !216)
!216 = distinct !DILocation(line: 621, column: 18, scope: !65, inlinedAt: !195)
!217 = !DILocation(line: 1547, column: 17, scope: !30, inlinedAt: !214)
!218 = !DILocation(line: 1547, column: 9, scope: !30, inlinedAt: !214)
!219 = !DILocation(line: 1548, column: 20, scope: !30, inlinedAt: !214)
!220 = !DILocation(line: 1548, column: 18, scope: !30, inlinedAt: !214)
!221 = !DILocation(line: 1548, column: 9, scope: !30, inlinedAt: !214)
!222 = !DILocation(line: 410, column: 44, scope: !56, inlinedAt: !223)
!223 = distinct !DILocation(line: 196, column: 34, scope: !43, inlinedAt: !216)
!224 = !DILocation(line: 622, column: 28, scope: !81, inlinedAt: !195)
!225 = !DILocation(line: 871, column: 18, scope: !19, inlinedAt: !226)
!226 = distinct !DILocation(line: 622, column: 24, scope: !81, inlinedAt: !195)
!227 = !DILocation(line: 623, column: 28, scope: !85, inlinedAt: !195)
!228 = !DILocation(line: 871, column: 18, scope: !19, inlinedAt: !229)
!229 = distinct !DILocation(line: 623, column: 24, scope: !85, inlinedAt: !195)
!230 = !DILocation(line: 624, column: 28, scope: !89, inlinedAt: !195)
!231 = !DILocation(line: 871, column: 18, scope: !19, inlinedAt: !232)
!232 = distinct !DILocation(line: 624, column: 24, scope: !89, inlinedAt: !195)
!233 = !DILocation(line: 625, column: 28, scope: !93, inlinedAt: !195)
!234 = !DILocation(line: 871, column: 18, scope: !19, inlinedAt: !235)
!235 = distinct !DILocation(line: 625, column: 24, scope: !93, inlinedAt: !195)
!236 = !DILocation(line: 635, column: 18, scope: !97, inlinedAt: !195)
!237 = !DILocation(line: 1547, column: 19, scope: !30, inlinedAt: !238)
!238 = distinct !DILocation(line: 166, column: 5, scope: !37, inlinedAt: !239)
!239 = distinct !DILocation(line: 196, column: 34, scope: !43, inlinedAt: !240)
!240 = distinct !DILocation(line: 635, column: 18, scope: !97, inlinedAt: !195)
!241 = !DILocation(line: 1547, column: 17, scope: !30, inlinedAt: !238)
!242 = !DILocation(line: 1547, column: 9, scope: !30, inlinedAt: !238)
!243 = !DILocation(line: 1548, column: 20, scope: !30, inlinedAt: !238)
!244 = !DILocation(line: 1548, column: 18, scope: !30, inlinedAt: !238)
!245 = !DILocation(line: 1548, column: 9, scope: !30, inlinedAt: !238)
!246 = !DILocation(line: 410, column: 44, scope: !56, inlinedAt: !247)
!247 = distinct !DILocation(line: 196, column: 34, scope: !43, inlinedAt: !240)
!248 = !DILocation(line: 636, column: 18, scope: !110, inlinedAt: !195)
!249 = !DILocation(line: 1547, column: 19, scope: !30, inlinedAt: !250)
!250 = distinct !DILocation(line: 166, column: 5, scope: !37, inlinedAt: !251)
!251 = distinct !DILocation(line: 196, column: 34, scope: !43, inlinedAt: !252)
!252 = distinct !DILocation(line: 636, column: 18, scope: !110, inlinedAt: !195)
!253 = !DILocation(line: 1547, column: 17, scope: !30, inlinedAt: !250)
!254 = !DILocation(line: 1547, column: 9, scope: !30, inlinedAt: !250)
!255 = !DILocation(line: 1548, column: 20, scope: !30, inlinedAt: !250)
!256 = !DILocation(line: 1548, column: 18, scope: !30, inlinedAt: !250)
!257 = !DILocation(line: 1548, column: 9, scope: !30, inlinedAt: !250)
!258 = !DILocation(line: 410, column: 44, scope: !56, inlinedAt: !259)
!259 = distinct !DILocation(line: 196, column: 34, scope: !43, inlinedAt: !252)
!260 = !DILocation(line: 879, column: 9, scope: !123, inlinedAt: !261)
!261 = distinct !DILocation(line: 639, column: 62, scope: !134, inlinedAt: !195)
!262 = !DILocation(line: 879, column: 9, scope: !123, inlinedAt: !263)
!263 = distinct !DILocation(line: 639, column: 28, scope: !134, inlinedAt: !195)
!264 = !DILocation(line: 879, column: 9, scope: !123, inlinedAt: !265)
!265 = distinct !DILocation(line: 640, column: 63, scope: !141, inlinedAt: !195)
!266 = !DILocation(line: 879, column: 9, scope: !123, inlinedAt: !267)
!267 = distinct !DILocation(line: 640, column: 29, scope: !141, inlinedAt: !195)
!268 = !DILocation(line: 643, column: 18, scope: !145, inlinedAt: !195)
!269 = !DILocation(line: 1547, column: 19, scope: !30, inlinedAt: !270)
!270 = distinct !DILocation(line: 166, column: 5, scope: !37, inlinedAt: !271)
!271 = distinct !DILocation(line: 196, column: 34, scope: !43, inlinedAt: !272)
!272 = distinct !DILocation(line: 643, column: 18, scope: !145, inlinedAt: !195)
!273 = !DILocation(line: 1547, column: 17, scope: !30, inlinedAt: !270)
!274 = !DILocation(line: 1547, column: 9, scope: !30, inlinedAt: !270)
!275 = !DILocation(line: 1548, column: 20, scope: !30, inlinedAt: !270)
!276 = !DILocation(line: 1548, column: 18, scope: !30, inlinedAt: !270)
!277 = !DILocation(line: 1548, column: 9, scope: !30, inlinedAt: !270)
!278 = !DILocation(line: 410, column: 44, scope: !56, inlinedAt: !279)
!279 = distinct !DILocation(line: 196, column: 34, scope: !43, inlinedAt: !272)
!280 = !DILocation(line: 879, column: 9, scope: !123, inlinedAt: !281)
!281 = distinct !DILocation(line: 637, column: 19, scope: !136, inlinedAt: !195)
!282 = !DILocation(line: 573, column: 14, scope: !160, inlinedAt: !283)
!283 = distinct !DILocation(line: 647, column: 9, scope: !163, inlinedAt: !195)
!284 = !DILocation(line: 970, column: 18, scope: !167, inlinedAt: !285)
!285 = distinct !DILocation(line: 648, column: 42, scope: !163, inlinedAt: !195)
!286 = !DILocation(line: 573, column: 14, scope: !160, inlinedAt: !287)
!287 = distinct !DILocation(line: 648, column: 9, scope: !163, inlinedAt: !195)
!288 = !DILocation(line: 879, column: 9, scope: !123, inlinedAt: !289)
!289 = distinct !DILocation(line: 644, column: 18, scope: !165, inlinedAt: !195)
!290 = !DILocation(line: 970, column: 18, scope: !167, inlinedAt: !291)
!291 = distinct !DILocation(line: 649, column: 42, scope: !163, inlinedAt: !195)
!292 = !DILocation(line: 573, column: 14, scope: !160, inlinedAt: !293)
!293 = distinct !DILocation(line: 649, column: 9, scope: !163, inlinedAt: !195)
!294 = !DILocation(line: 879, column: 9, scope: !123, inlinedAt: !295)
!295 = distinct !DILocation(line: 645, column: 18, scope: !164, inlinedAt: !195)
!296 = !DILocation(line: 970, column: 18, scope: !167, inlinedAt: !297)
!297 = distinct !DILocation(line: 650, column: 43, scope: !163, inlinedAt: !195)
!298 = !DILocation(line: 573, column: 14, scope: !160, inlinedAt: !299)
!299 = distinct !DILocation(line: 650, column: 9, scope: !163, inlinedAt: !195)
!300 = !DILocation(line: 879, column: 9, scope: !123, inlinedAt: !301)
!301 = distinct !DILocation(line: 638, column: 19, scope: !135, inlinedAt: !195)
!302 = !{!303}
!303 = distinct !{!303, !304, !"_RINvNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6shared9smallsort19bidirectional_mergedNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtBa_3f64d9total_cmpE0ECs68MIsFmw01O_12evidence_lab: %v.0"}
!304 = distinct !{!304, !"_RINvNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6shared9smallsort19bidirectional_mergedNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtBa_3f64d9total_cmpE0ECs68MIsFmw01O_12evidence_lab"}
!305 = !DILocation(line: 672, column: 9, scope: !8)
!306 = !DILocation(line: 970, column: 18, scope: !307, inlinedAt: !308)
!307 = distinct !DISubprogram(name: "add<f64>", linkageName: "_RNvMNtNtCsjIpoRzUjyHQ_4core3ptr7mut_ptrOd3addCs68MIsFmw01O_12evidence_lab", scope: !169, file: !168, line: 936, type: !24, scopeLine: 936, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !16)
!308 = distinct !DILocation(line: 809, column: 31, scope: !309, inlinedAt: !318)
!309 = distinct !DILexicalBlock(scope: !310, file: !9, line: 808, column: 9)
!310 = distinct !DILexicalBlock(scope: !311, file: !9, line: 807, column: 9)
!311 = distinct !DILexicalBlock(scope: !312, file: !9, line: 805, column: 9)
!312 = distinct !DILexicalBlock(scope: !313, file: !9, line: 804, column: 9)
!313 = distinct !DILexicalBlock(scope: !314, file: !9, line: 803, column: 9)
!314 = distinct !DILexicalBlock(scope: !315, file: !9, line: 791, column: 5)
!315 = distinct !DILexicalBlock(scope: !316, file: !9, line: 789, column: 5)
!316 = distinct !DILexicalBlock(scope: !317, file: !9, line: 788, column: 5)
!317 = distinct !DISubprogram(name: "bidirectional_merge<f64, alloc::slice::{impl#0}::sort_by::{closure_env#0}<f64, fn(&f64, &f64) -> core::cmp::Ordering>>", linkageName: "_RINvNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6shared9smallsort19bidirectional_mergedNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtBa_3f64d9total_cmpE0ECs68MIsFmw01O_12evidence_lab", scope: !10, file: !9, line: 754, type: !15, scopeLine: 754, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !16)
!318 = distinct !DILocation(line: 672, column: 9, scope: !8)
!319 = !DILocation(line: 1547, column: 19, scope: !30, inlinedAt: !320)
!320 = distinct !DILocation(line: 166, column: 5, scope: !37, inlinedAt: !321)
!321 = distinct !DILocation(line: 196, column: 34, scope: !43, inlinedAt: !322)
!322 = distinct !DILocation(line: 698, column: 21, scope: !323, inlinedAt: !324)
!323 = distinct !DISubprogram(name: "merge_up<f64, alloc::slice::{impl#0}::sort_by::{closure_env#0}<f64, fn(&f64, &f64) -> core::cmp::Ordering>>", linkageName: "_RINvNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6shared9smallsort8merge_updNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtBa_3f64d9total_cmpE0ECs68MIsFmw01O_12evidence_lab", scope: !10, file: !9, line: 677, type: !24, scopeLine: 677, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !16)
!324 = distinct !DILocation(line: 812, column: 34, scope: !325, inlinedAt: !318)
!325 = distinct !DILexicalBlock(scope: !326, file: !9, line: 811, column: 9)
!326 = distinct !DILexicalBlock(scope: !309, file: !9, line: 809, column: 9)
!327 = !DILocation(line: 1547, column: 17, scope: !30, inlinedAt: !320)
!328 = !DILocation(line: 1547, column: 9, scope: !30, inlinedAt: !320)
!329 = !DILocation(line: 1548, column: 20, scope: !30, inlinedAt: !320)
!330 = !DILocation(line: 1548, column: 18, scope: !30, inlinedAt: !320)
!331 = !DILocation(line: 1548, column: 9, scope: !30, inlinedAt: !320)
!332 = !DILocation(line: 410, column: 44, scope: !56, inlinedAt: !333)
!333 = distinct !DILocation(line: 196, column: 34, scope: !43, inlinedAt: !322)
!334 = !DILocation(line: 698, column: 20, scope: !323, inlinedAt: !324)
!335 = !DILocation(line: 699, column: 19, scope: !336, inlinedAt: !324)
!336 = distinct !DILexicalBlock(scope: !323, file: !9, line: 698, column: 9)
!337 = !DILocation(line: 573, column: 14, scope: !338, inlinedAt: !339)
!338 = distinct !DISubprogram(name: "copy_nonoverlapping<f64>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3ptr19copy_nonoverlappingdECs68MIsFmw01O_12evidence_lab", scope: !23, file: !161, line: 552, type: !24, scopeLine: 552, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !16)
!339 = distinct !DILocation(line: 700, column: 9, scope: !340, inlinedAt: !324)
!340 = distinct !DILexicalBlock(scope: !336, file: !9, line: 699, column: 9)
!341 = !{!342, !344, !303}
!342 = distinct !{!342, !343, !"_RINvNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6shared9smallsort8merge_updNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtBa_3f64d9total_cmpE0ECs68MIsFmw01O_12evidence_lab: %_0"}
!343 = distinct !{!343, !"_RINvNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6shared9smallsort8merge_updNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtBa_3f64d9total_cmpE0ECs68MIsFmw01O_12evidence_lab"}
!344 = distinct !{!344, !343, !"_RINvNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6shared9smallsort8merge_updNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtBa_3f64d9total_cmpE0ECs68MIsFmw01O_12evidence_lab: %is_less"}
!345 = !DILocation(line: 701, column: 35, scope: !340, inlinedAt: !324)
!346 = !DILocation(line: 871, column: 18, scope: !347, inlinedAt: !348)
!347 = distinct !DISubprogram(name: "add<f64>", linkageName: "_RNvMNtNtCsjIpoRzUjyHQ_4core3ptr9const_ptrPd3addCs68MIsFmw01O_12evidence_lab", scope: !21, file: !20, line: 837, type: !24, scopeLine: 837, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !16)
!348 = distinct !DILocation(line: 701, column: 31, scope: !340, inlinedAt: !324)
!349 = !DILocation(line: 702, column: 33, scope: !340, inlinedAt: !324)
!350 = !DILocation(line: 871, column: 18, scope: !347, inlinedAt: !351)
!351 = distinct !DILocation(line: 702, column: 29, scope: !340, inlinedAt: !324)
!352 = !DILocation(line: 970, column: 18, scope: !353, inlinedAt: !354)
!353 = distinct !DISubprogram(name: "add<f64>", linkageName: "_RNvMNtNtCsjIpoRzUjyHQ_4core3ptr7mut_ptrOd3addCs68MIsFmw01O_12evidence_lab", scope: !169, file: !168, line: 936, type: !24, scopeLine: 936, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !16)
!354 = distinct !DILocation(line: 703, column: 19, scope: !340, inlinedAt: !324)
!355 = !DILocation(line: 1547, column: 19, scope: !30, inlinedAt: !356)
!356 = distinct !DILocation(line: 166, column: 5, scope: !37, inlinedAt: !357)
!357 = distinct !DILocation(line: 196, column: 34, scope: !43, inlinedAt: !358)
!358 = distinct !DILocation(line: 731, column: 21, scope: !359, inlinedAt: !360)
!359 = distinct !DISubprogram(name: "merge_down<f64, alloc::slice::{impl#0}::sort_by::{closure_env#0}<f64, fn(&f64, &f64) -> core::cmp::Ordering>>", linkageName: "_RINvNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6shared9smallsort10merge_downdNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtBa_3f64d9total_cmpE0ECs68MIsFmw01O_12evidence_lab", scope: !10, file: !9, line: 710, type: !24, scopeLine: 710, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !16)
!360 = distinct !DILocation(line: 813, column: 46, scope: !325, inlinedAt: !318)
!361 = !DILocation(line: 1547, column: 17, scope: !30, inlinedAt: !356)
!362 = !DILocation(line: 1547, column: 9, scope: !30, inlinedAt: !356)
!363 = !DILocation(line: 1548, column: 20, scope: !30, inlinedAt: !356)
!364 = !DILocation(line: 1548, column: 18, scope: !30, inlinedAt: !356)
!365 = !DILocation(line: 1548, column: 9, scope: !30, inlinedAt: !356)
!366 = !DILocation(line: 410, column: 44, scope: !56, inlinedAt: !367)
!367 = distinct !DILocation(line: 196, column: 34, scope: !43, inlinedAt: !358)
!368 = !DILocation(line: 731, column: 20, scope: !359, inlinedAt: !360)
!369 = !DILocation(line: 732, column: 19, scope: !370, inlinedAt: !360)
!370 = distinct !DILexicalBlock(scope: !359, file: !9, line: 731, column: 9)
!371 = !DILocation(line: 573, column: 14, scope: !372, inlinedAt: !373)
!372 = distinct !DISubprogram(name: "copy_nonoverlapping<f64>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3ptr19copy_nonoverlappingdECs68MIsFmw01O_12evidence_lab", scope: !23, file: !161, line: 552, type: !24, scopeLine: 552, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !16)
!373 = distinct !DILocation(line: 733, column: 9, scope: !374, inlinedAt: !360)
!374 = distinct !DILexicalBlock(scope: !370, file: !9, line: 732, column: 9)
!375 = !{!376, !378, !303}
!376 = distinct !{!376, !377, !"_RINvNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6shared9smallsort10merge_downdNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtBa_3f64d9total_cmpE0ECs68MIsFmw01O_12evidence_lab: %_0"}
!377 = distinct !{!377, !"_RINvNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6shared9smallsort10merge_downdNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtBa_3f64d9total_cmpE0ECs68MIsFmw01O_12evidence_lab"}
!378 = distinct !{!378, !377, !"_RINvNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6shared9smallsort10merge_downdNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtBa_3f64d9total_cmpE0ECs68MIsFmw01O_12evidence_lab: %is_less"}
!379 = !DILocation(line: 734, column: 44, scope: !374, inlinedAt: !360)
!380 = !DILocation(line: 473, column: 18, scope: !381, inlinedAt: !382)
!381 = distinct !DISubprogram(name: "wrapping_offset<f64>", linkageName: "_RNvMNtNtCsjIpoRzUjyHQ_4core3ptr9const_ptrPd15wrapping_offsetCs68MIsFmw01O_12evidence_lab", scope: !21, file: !20, line: 468, type: !24, scopeLine: 468, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !16)
!382 = distinct !DILocation(line: 1118, column: 14, scope: !383, inlinedAt: !384)
!383 = distinct !DISubprogram(name: "wrapping_sub<f64>", linkageName: "_RNvMNtNtCsjIpoRzUjyHQ_4core3ptr9const_ptrPd12wrapping_subCs68MIsFmw01O_12evidence_lab", scope: !21, file: !20, line: 1114, type: !24, scopeLine: 1114, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !16)
!384 = distinct !DILocation(line: 734, column: 31, scope: !374, inlinedAt: !360)
!385 = !DILocation(line: 735, column: 42, scope: !374, inlinedAt: !360)
!386 = !DILocation(line: 473, column: 18, scope: !381, inlinedAt: !387)
!387 = distinct !DILocation(line: 1118, column: 14, scope: !388, inlinedAt: !389)
!388 = !DILexicalBlockFile(scope: !383, file: !20, discriminator: 2)
!389 = distinct !DILocation(line: 735, column: 29, scope: !374, inlinedAt: !360)
!390 = !DILocation(line: 1054, column: 22, scope: !391, inlinedAt: !392)
!391 = distinct !DISubprogram(name: "sub<f64>", linkageName: "_RNvMNtNtCsjIpoRzUjyHQ_4core3ptr7mut_ptrOd3subCs68MIsFmw01O_12evidence_lab", scope: !169, file: !168, line: 1015, type: !24, scopeLine: 1015, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !16)
!392 = distinct !DILocation(line: 736, column: 19, scope: !374, inlinedAt: !360)
!393 = !DILocation(line: 698, column: 21, scope: !323, inlinedAt: !324)
!394 = !DILocation(line: 731, column: 21, scope: !359, inlinedAt: !360)
!395 = !DILocation(line: 473, column: 18, scope: !396, inlinedAt: !397)
!396 = distinct !DISubprogram(name: "wrapping_offset<f64>", linkageName: "_RNvMNtNtCsjIpoRzUjyHQ_4core3ptr9const_ptrPd15wrapping_offsetCs68MIsFmw01O_12evidence_lab", scope: !21, file: !20, line: 468, type: !24, scopeLine: 468, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !16)
!397 = distinct !DILocation(line: 1039, column: 14, scope: !398, inlinedAt: !399)
!398 = distinct !DISubprogram(name: "wrapping_add<f64>", linkageName: "_RNvMNtNtCsjIpoRzUjyHQ_4core3ptr9const_ptrPd12wrapping_addCs68MIsFmw01O_12evidence_lab", scope: !21, file: !20, line: 1035, type: !24, scopeLine: 1035, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !16)
!399 = distinct !DILocation(line: 816, column: 33, scope: !326, inlinedAt: !318)
!400 = !DILocation(line: 473, column: 18, scope: !396, inlinedAt: !401)
!401 = distinct !DILocation(line: 1039, column: 14, scope: !402, inlinedAt: !403)
!402 = !DILexicalBlockFile(scope: !398, file: !20, discriminator: 2)
!403 = distinct !DILocation(line: 817, column: 35, scope: !404, inlinedAt: !318)
!404 = distinct !DILexicalBlock(scope: !326, file: !9, line: 816, column: 9)
!405 = !DILocation(line: 831, column: 12, scope: !406, inlinedAt: !318)
!406 = distinct !DILexicalBlock(scope: !404, file: !9, line: 817, column: 9)
!407 = !{!"branch_weights", i32 4001, i32 4000000}
!408 = !DILocation(line: 832, column: 13, scope: !406, inlinedAt: !318)
!409 = !DILocation(line: 674, column: 2, scope: !8)
!410 = distinct !DISubprogram(name: "insertion_sort_shift_left<f64, alloc::slice::{impl#0}::sort_by::{closure_env#0}<f64, fn(&f64, &f64) -> core::cmp::Ordering>>", linkageName: "_RINvNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6shared9smallsort25insertion_sort_shift_leftdNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtBa_3f64d9total_cmpE0ECs68MIsFmw01O_12evidence_lab", scope: !10, file: !9, line: 574, type: !24, scopeLine: 574, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !16)
!411 = !{i64 -5060252760157498818}
!412 = !DILocation(line: 580, column: 8, scope: !413)
!413 = distinct !DILexicalBlock(scope: !410, file: !9, line: 579, column: 5)
!414 = !DILocation(line: 581, column: 9, scope: !413)
!415 = !DILocation(line: 970, column: 18, scope: !416, inlinedAt: !417)
!416 = distinct !DISubprogram(name: "add<f64>", linkageName: "_RNvMNtNtCsjIpoRzUjyHQ_4core3ptr7mut_ptrOd3addCs68MIsFmw01O_12evidence_lab", scope: !169, file: !168, line: 936, type: !24, scopeLine: 936, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !16)
!417 = !DILocation(line: 591, column: 28, scope: !418)
!418 = distinct !DILexicalBlock(scope: !413, file: !9, line: 590, column: 9)
!419 = !DILocation(line: 593, column: 15, scope: !420)
!420 = distinct !DILexicalBlock(scope: !421, file: !9, line: 592, column: 9)
!421 = distinct !DILexicalBlock(scope: !418, file: !9, line: 591, column: 9)
!422 = !DILocation(line: 970, column: 18, scope: !416, inlinedAt: !423)
!423 = !DILocation(line: 592, column: 31, scope: !421)
!424 = !DILocation(line: 541, column: 13, scope: !425, inlinedAt: !427)
!425 = distinct !DILexicalBlock(scope: !426, file: !9, line: 540, column: 9)
!426 = distinct !DISubprogram(name: "insert_tail<f64, alloc::slice::{impl#0}::sort_by::{closure_env#0}<f64, fn(&f64, &f64) -> core::cmp::Ordering>>", linkageName: "_RINvNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6shared9smallsort11insert_taildNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtBa_3f64d9total_cmpE0ECs68MIsFmw01O_12evidence_lab", scope: !10, file: !9, line: 536, type: !15, scopeLine: 536, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !16)
!427 = distinct !DILocation(line: 596, column: 13, scope: !420)
!428 = !DILocation(line: 602, column: 2, scope: !410)
!429 = !DILocation(line: 1054, column: 22, scope: !430, inlinedAt: !431)
!430 = distinct !DISubprogram(name: "sub<f64>", linkageName: "_RNvMNtNtCsjIpoRzUjyHQ_4core3ptr7mut_ptrOd3subCs68MIsFmw01O_12evidence_lab", scope: !169, file: !168, line: 1015, type: !24, scopeLine: 1015, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !16)
!431 = distinct !DILocation(line: 540, column: 29, scope: !426, inlinedAt: !427)
!432 = !DILocation(line: 1547, column: 19, scope: !30, inlinedAt: !433)
!433 = distinct !DILocation(line: 166, column: 5, scope: !37, inlinedAt: !434)
!434 = distinct !DILocation(line: 196, column: 34, scope: !43, inlinedAt: !435)
!435 = distinct !DILocation(line: 541, column: 13, scope: !425, inlinedAt: !427)
!436 = !DILocation(line: 1547, column: 17, scope: !30, inlinedAt: !433)
!437 = !DILocation(line: 1547, column: 9, scope: !30, inlinedAt: !433)
!438 = !DILocation(line: 1548, column: 20, scope: !30, inlinedAt: !433)
!439 = !DILocation(line: 1548, column: 18, scope: !30, inlinedAt: !433)
!440 = !DILocation(line: 1548, column: 9, scope: !30, inlinedAt: !433)
!441 = !DILocation(line: 410, column: 44, scope: !56, inlinedAt: !442)
!442 = distinct !DILocation(line: 196, column: 34, scope: !43, inlinedAt: !435)
!443 = !DILocation(line: 573, column: 14, scope: !444, inlinedAt: !445)
!444 = distinct !DISubprogram(name: "copy_nonoverlapping<f64>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3ptr19copy_nonoverlappingdECs68MIsFmw01O_12evidence_lab", scope: !23, file: !161, line: 552, type: !24, scopeLine: 552, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !16)
!445 = distinct !DILocation(line: 557, column: 13, scope: !446, inlinedAt: !427)
!446 = distinct !DILexicalBlock(scope: !447, file: !9, line: 551, column: 9)
!447 = distinct !DILexicalBlock(scope: !425, file: !9, line: 550, column: 9)
!448 = !DILocation(line: 560, column: 16, scope: !446, inlinedAt: !427)
!449 = !DILocation(line: 1054, column: 22, scope: !430, inlinedAt: !450)
!450 = distinct !DILocation(line: 565, column: 25, scope: !446, inlinedAt: !427)
!451 = !DILocation(line: 566, column: 17, scope: !446, inlinedAt: !427)
!452 = !DILocation(line: 1548, column: 20, scope: !30, inlinedAt: !453)
!453 = distinct !DILocation(line: 166, column: 5, scope: !37, inlinedAt: !454)
!454 = distinct !DILocation(line: 196, column: 34, scope: !43, inlinedAt: !455)
!455 = distinct !DILocation(line: 566, column: 17, scope: !446, inlinedAt: !427)
!456 = !DILocation(line: 1548, column: 18, scope: !30, inlinedAt: !453)
!457 = !DILocation(line: 1548, column: 9, scope: !30, inlinedAt: !453)
!458 = !DILocation(line: 410, column: 44, scope: !56, inlinedAt: !459)
!459 = distinct !DILocation(line: 196, column: 34, scope: !43, inlinedAt: !455)
!460 = !DILocation(line: 0, scope: !426, inlinedAt: !427)
!461 = !DILocation(line: 573, column: 14, scope: !462, inlinedAt: !463)
!462 = distinct !DISubprogram(name: "copy_nonoverlapping<f64>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3ptr19copy_nonoverlappingdECs68MIsFmw01O_12evidence_lab", scope: !23, file: !161, line: 552, type: !24, scopeLine: 552, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !16)
!463 = distinct !DILocation(line: 306, column: 13, scope: !464, inlinedAt: !466)
!464 = distinct !DISubprogram(name: "drop<f64>", linkageName: "_RNvXs5_NtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6shared9smallsortINtB5_10CopyOnDropdENtNtNtBd_3ops4drop4Drop4dropCs68MIsFmw01O_12evidence_lab", scope: !465, file: !9, line: 302, type: !24, scopeLine: 302, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !16)
!465 = !DINamespace(name: "{impl#7}", scope: !10)
!466 = distinct !DILocation(line: 847, column: 1, scope: !467, inlinedAt: !468)
!467 = distinct !DISubprogram(name: "drop_glue<core::slice::sort::shared::smallsort::CopyOnDrop<f64>>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtNtNtB4_5slice4sort6shared9smallsort10CopyOnDropdEECs68MIsFmw01O_12evidence_lab", scope: !23, file: !161, line: 847, type: !24, scopeLine: 847, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !16)
!468 = distinct !DILocation(line: 570, column: 5, scope: !447, inlinedAt: !427)
!469 = !{!470, !472}
!470 = distinct !{!470, !471, !"_RNvXs5_NtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6shared9smallsortINtB5_10CopyOnDropdENtNtNtBd_3ops4drop4Drop4dropCs68MIsFmw01O_12evidence_lab: %self"}
!471 = distinct !{!471, !"_RNvXs5_NtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6shared9smallsortINtB5_10CopyOnDropdENtNtNtBd_3ops4drop4Drop4dropCs68MIsFmw01O_12evidence_lab"}
!472 = distinct !{!472, !473, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtNtNtB4_5slice4sort6shared9smallsort10CopyOnDropdEECs68MIsFmw01O_12evidence_lab: %_1"}
!473 = distinct !{!473, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtNtNtB4_5slice4sort6shared9smallsort10CopyOnDropdEECs68MIsFmw01O_12evidence_lab"}
!474 = !DILocation(line: 571, column: 2, scope: !426, inlinedAt: !427)
!475 = !DILocation(line: 970, column: 18, scope: !416, inlinedAt: !476)
!476 = !DILocation(line: 599, column: 25, scope: !420)
!477 = distinct !DISubprogram(name: "small_sort_general_with_scratch<f64, alloc::slice::{impl#0}::sort_by::{closure_env#0}<f64, fn(&f64, &f64) -> core::cmp::Ordering>>", linkageName: "_RINvNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6shared9smallsort31small_sort_general_with_scratchdNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtBa_3f64d9total_cmpE0ECs68MIsFmw01O_12evidence_lab", scope: !10, file: !9, line: 220, type: !24, scopeLine: 220, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !16)
!478 = !{i64 6925365390283367105}
!479 = !DILocation(line: 226, column: 8, scope: !480)
!480 = distinct !DILexicalBlock(scope: !477, file: !9, line: 225, column: 5)
!481 = !DILocation(line: 230, column: 24, scope: !480)
!482 = !DILocation(line: 230, column: 8, scope: !480)
!483 = !DILocation(line: 235, column: 21, scope: !484)
!484 = distinct !DILexicalBlock(scope: !480, file: !9, line: 234, column: 5)
!485 = !DILocation(line: 241, column: 66, scope: !486)
!486 = distinct !DILexicalBlock(scope: !487, file: !9, line: 239, column: 9)
!487 = distinct !DILexicalBlock(scope: !484, file: !9, line: 235, column: 5)
!488 = !DILocation(line: 231, column: 9, scope: !480)
!489 = !DILocation(line: 252, column: 19, scope: !486)
!490 = !DILocation(line: 970, column: 18, scope: !491, inlinedAt: !492)
!491 = distinct !DISubprogram(name: "add<f64>", linkageName: "_RNvMNtNtCsjIpoRzUjyHQ_4core3ptr7mut_ptrOd3addCs68MIsFmw01O_12evidence_lab", scope: !169, file: !168, line: 936, type: !24, scopeLine: 936, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !16)
!492 = !DILocation(line: 243, column: 61, scope: !486)
!493 = !DILocation(line: 243, column: 13, scope: !486)
!494 = !DILocation(line: 970, column: 18, scope: !491, inlinedAt: !495)
!495 = !DILocation(line: 245, column: 24, scope: !486)
!496 = !DILocation(line: 970, column: 18, scope: !491, inlinedAt: !497)
!497 = !DILocation(line: 246, column: 30, scope: !486)
!498 = !DILocation(line: 970, column: 18, scope: !491, inlinedAt: !499)
!499 = !DILocation(line: 247, column: 30, scope: !486)
!500 = !DILocation(line: 244, column: 13, scope: !486)
!501 = !DILocation(line: 241, column: 29, scope: !486)
!502 = !DILocation(line: 871, column: 18, scope: !19, inlinedAt: !503)
!503 = distinct !DILocation(line: 620, column: 35, scope: !26, inlinedAt: !504)
!504 = distinct !DILocation(line: 254, column: 13, scope: !486)
!505 = !DILocation(line: 620, column: 18, scope: !26, inlinedAt: !504)
!506 = !DILocation(line: 1547, column: 19, scope: !30, inlinedAt: !507)
!507 = distinct !DILocation(line: 166, column: 5, scope: !37, inlinedAt: !508)
!508 = distinct !DILocation(line: 196, column: 34, scope: !43, inlinedAt: !509)
!509 = distinct !DILocation(line: 620, column: 18, scope: !26, inlinedAt: !504)
!510 = !DILocation(line: 1547, column: 17, scope: !30, inlinedAt: !507)
!511 = !DILocation(line: 1547, column: 9, scope: !30, inlinedAt: !507)
!512 = !DILocation(line: 1548, column: 20, scope: !30, inlinedAt: !507)
!513 = !DILocation(line: 1548, column: 18, scope: !30, inlinedAt: !507)
!514 = !DILocation(line: 1548, column: 9, scope: !30, inlinedAt: !507)
!515 = !DILocation(line: 410, column: 44, scope: !56, inlinedAt: !516)
!516 = distinct !DILocation(line: 196, column: 34, scope: !43, inlinedAt: !509)
!517 = !DILocation(line: 871, column: 18, scope: !19, inlinedAt: !518)
!518 = distinct !DILocation(line: 621, column: 35, scope: !65, inlinedAt: !504)
!519 = !DILocation(line: 871, column: 18, scope: !19, inlinedAt: !520)
!520 = distinct !DILocation(line: 621, column: 52, scope: !65, inlinedAt: !504)
!521 = !DILocation(line: 621, column: 18, scope: !65, inlinedAt: !504)
!522 = !DILocation(line: 1547, column: 19, scope: !30, inlinedAt: !523)
!523 = distinct !DILocation(line: 166, column: 5, scope: !37, inlinedAt: !524)
!524 = distinct !DILocation(line: 196, column: 34, scope: !43, inlinedAt: !525)
!525 = distinct !DILocation(line: 621, column: 18, scope: !65, inlinedAt: !504)
!526 = !DILocation(line: 1547, column: 17, scope: !30, inlinedAt: !523)
!527 = !DILocation(line: 1547, column: 9, scope: !30, inlinedAt: !523)
!528 = !DILocation(line: 1548, column: 20, scope: !30, inlinedAt: !523)
!529 = !DILocation(line: 1548, column: 18, scope: !30, inlinedAt: !523)
!530 = !DILocation(line: 1548, column: 9, scope: !30, inlinedAt: !523)
!531 = !DILocation(line: 410, column: 44, scope: !56, inlinedAt: !532)
!532 = distinct !DILocation(line: 196, column: 34, scope: !43, inlinedAt: !525)
!533 = !DILocation(line: 622, column: 28, scope: !81, inlinedAt: !504)
!534 = !DILocation(line: 871, column: 18, scope: !19, inlinedAt: !535)
!535 = distinct !DILocation(line: 622, column: 24, scope: !81, inlinedAt: !504)
!536 = !DILocation(line: 623, column: 28, scope: !85, inlinedAt: !504)
!537 = !DILocation(line: 871, column: 18, scope: !19, inlinedAt: !538)
!538 = distinct !DILocation(line: 623, column: 24, scope: !85, inlinedAt: !504)
!539 = !DILocation(line: 624, column: 28, scope: !89, inlinedAt: !504)
!540 = !DILocation(line: 871, column: 18, scope: !19, inlinedAt: !541)
!541 = distinct !DILocation(line: 624, column: 24, scope: !89, inlinedAt: !504)
!542 = !DILocation(line: 625, column: 28, scope: !93, inlinedAt: !504)
!543 = !DILocation(line: 871, column: 18, scope: !19, inlinedAt: !544)
!544 = distinct !DILocation(line: 625, column: 24, scope: !93, inlinedAt: !504)
!545 = !DILocation(line: 635, column: 18, scope: !97, inlinedAt: !504)
!546 = !DILocation(line: 1547, column: 19, scope: !30, inlinedAt: !547)
!547 = distinct !DILocation(line: 166, column: 5, scope: !37, inlinedAt: !548)
!548 = distinct !DILocation(line: 196, column: 34, scope: !43, inlinedAt: !549)
!549 = distinct !DILocation(line: 635, column: 18, scope: !97, inlinedAt: !504)
!550 = !DILocation(line: 1547, column: 17, scope: !30, inlinedAt: !547)
!551 = !DILocation(line: 1547, column: 9, scope: !30, inlinedAt: !547)
!552 = !DILocation(line: 1548, column: 20, scope: !30, inlinedAt: !547)
!553 = !DILocation(line: 1548, column: 18, scope: !30, inlinedAt: !547)
!554 = !DILocation(line: 1548, column: 9, scope: !30, inlinedAt: !547)
!555 = !DILocation(line: 410, column: 44, scope: !56, inlinedAt: !556)
!556 = distinct !DILocation(line: 196, column: 34, scope: !43, inlinedAt: !549)
!557 = !DILocation(line: 636, column: 18, scope: !110, inlinedAt: !504)
!558 = !DILocation(line: 1547, column: 19, scope: !30, inlinedAt: !559)
!559 = distinct !DILocation(line: 166, column: 5, scope: !37, inlinedAt: !560)
!560 = distinct !DILocation(line: 196, column: 34, scope: !43, inlinedAt: !561)
!561 = distinct !DILocation(line: 636, column: 18, scope: !110, inlinedAt: !504)
!562 = !DILocation(line: 1547, column: 17, scope: !30, inlinedAt: !559)
!563 = !DILocation(line: 1547, column: 9, scope: !30, inlinedAt: !559)
!564 = !DILocation(line: 1548, column: 20, scope: !30, inlinedAt: !559)
!565 = !DILocation(line: 1548, column: 18, scope: !30, inlinedAt: !559)
!566 = !DILocation(line: 1548, column: 9, scope: !30, inlinedAt: !559)
!567 = !DILocation(line: 410, column: 44, scope: !56, inlinedAt: !568)
!568 = distinct !DILocation(line: 196, column: 34, scope: !43, inlinedAt: !561)
!569 = !DILocation(line: 879, column: 9, scope: !123, inlinedAt: !570)
!570 = distinct !DILocation(line: 639, column: 62, scope: !134, inlinedAt: !504)
!571 = !DILocation(line: 879, column: 9, scope: !123, inlinedAt: !572)
!572 = distinct !DILocation(line: 639, column: 28, scope: !134, inlinedAt: !504)
!573 = !DILocation(line: 879, column: 9, scope: !123, inlinedAt: !574)
!574 = distinct !DILocation(line: 640, column: 63, scope: !141, inlinedAt: !504)
!575 = !DILocation(line: 879, column: 9, scope: !123, inlinedAt: !576)
!576 = distinct !DILocation(line: 640, column: 29, scope: !141, inlinedAt: !504)
!577 = !DILocation(line: 643, column: 18, scope: !145, inlinedAt: !504)
!578 = !DILocation(line: 1547, column: 19, scope: !30, inlinedAt: !579)
!579 = distinct !DILocation(line: 166, column: 5, scope: !37, inlinedAt: !580)
!580 = distinct !DILocation(line: 196, column: 34, scope: !43, inlinedAt: !581)
!581 = distinct !DILocation(line: 643, column: 18, scope: !145, inlinedAt: !504)
!582 = !DILocation(line: 1547, column: 17, scope: !30, inlinedAt: !579)
!583 = !DILocation(line: 1547, column: 9, scope: !30, inlinedAt: !579)
!584 = !DILocation(line: 1548, column: 20, scope: !30, inlinedAt: !579)
!585 = !DILocation(line: 1548, column: 18, scope: !30, inlinedAt: !579)
!586 = !DILocation(line: 1548, column: 9, scope: !30, inlinedAt: !579)
!587 = !DILocation(line: 410, column: 44, scope: !56, inlinedAt: !588)
!588 = distinct !DILocation(line: 196, column: 34, scope: !43, inlinedAt: !581)
!589 = !DILocation(line: 879, column: 9, scope: !123, inlinedAt: !590)
!590 = distinct !DILocation(line: 637, column: 19, scope: !136, inlinedAt: !504)
!591 = !DILocation(line: 573, column: 14, scope: !160, inlinedAt: !592)
!592 = distinct !DILocation(line: 647, column: 9, scope: !163, inlinedAt: !504)
!593 = !DILocation(line: 970, column: 18, scope: !167, inlinedAt: !594)
!594 = distinct !DILocation(line: 648, column: 42, scope: !163, inlinedAt: !504)
!595 = !DILocation(line: 879, column: 9, scope: !123, inlinedAt: !596)
!596 = distinct !DILocation(line: 644, column: 18, scope: !165, inlinedAt: !504)
!597 = !DILocation(line: 573, column: 14, scope: !160, inlinedAt: !598)
!598 = distinct !DILocation(line: 648, column: 9, scope: !163, inlinedAt: !504)
!599 = !DILocation(line: 970, column: 18, scope: !167, inlinedAt: !600)
!600 = distinct !DILocation(line: 649, column: 42, scope: !163, inlinedAt: !504)
!601 = !DILocation(line: 879, column: 9, scope: !123, inlinedAt: !602)
!602 = distinct !DILocation(line: 645, column: 18, scope: !164, inlinedAt: !504)
!603 = !DILocation(line: 573, column: 14, scope: !160, inlinedAt: !604)
!604 = distinct !DILocation(line: 649, column: 9, scope: !163, inlinedAt: !504)
!605 = !DILocation(line: 970, column: 18, scope: !167, inlinedAt: !606)
!606 = distinct !DILocation(line: 650, column: 43, scope: !163, inlinedAt: !504)
!607 = !DILocation(line: 879, column: 9, scope: !123, inlinedAt: !608)
!608 = distinct !DILocation(line: 638, column: 19, scope: !135, inlinedAt: !504)
!609 = !DILocation(line: 573, column: 14, scope: !160, inlinedAt: !610)
!610 = distinct !DILocation(line: 650, column: 9, scope: !163, inlinedAt: !504)
!611 = !DILocation(line: 970, column: 18, scope: !491, inlinedAt: !612)
!612 = !DILocation(line: 255, column: 33, scope: !486)
!613 = !DILocation(line: 970, column: 18, scope: !491, inlinedAt: !614)
!614 = !DILocation(line: 255, column: 62, scope: !486)
!615 = !DILocation(line: 871, column: 18, scope: !19, inlinedAt: !616)
!616 = distinct !DILocation(line: 620, column: 35, scope: !26, inlinedAt: !617)
!617 = distinct !DILocation(line: 255, column: 13, scope: !486)
!618 = !DILocation(line: 620, column: 18, scope: !26, inlinedAt: !617)
!619 = !DILocation(line: 1547, column: 19, scope: !30, inlinedAt: !620)
!620 = distinct !DILocation(line: 166, column: 5, scope: !37, inlinedAt: !621)
!621 = distinct !DILocation(line: 196, column: 34, scope: !43, inlinedAt: !622)
!622 = distinct !DILocation(line: 620, column: 18, scope: !26, inlinedAt: !617)
!623 = !DILocation(line: 1547, column: 17, scope: !30, inlinedAt: !620)
!624 = !DILocation(line: 1547, column: 9, scope: !30, inlinedAt: !620)
!625 = !DILocation(line: 1548, column: 20, scope: !30, inlinedAt: !620)
!626 = !DILocation(line: 1548, column: 18, scope: !30, inlinedAt: !620)
!627 = !DILocation(line: 1548, column: 9, scope: !30, inlinedAt: !620)
!628 = !DILocation(line: 410, column: 44, scope: !56, inlinedAt: !629)
!629 = distinct !DILocation(line: 196, column: 34, scope: !43, inlinedAt: !622)
!630 = !DILocation(line: 871, column: 18, scope: !19, inlinedAt: !631)
!631 = distinct !DILocation(line: 621, column: 35, scope: !65, inlinedAt: !617)
!632 = !DILocation(line: 871, column: 18, scope: !19, inlinedAt: !633)
!633 = distinct !DILocation(line: 621, column: 52, scope: !65, inlinedAt: !617)
!634 = !DILocation(line: 621, column: 18, scope: !65, inlinedAt: !617)
!635 = !DILocation(line: 1547, column: 19, scope: !30, inlinedAt: !636)
!636 = distinct !DILocation(line: 166, column: 5, scope: !37, inlinedAt: !637)
!637 = distinct !DILocation(line: 196, column: 34, scope: !43, inlinedAt: !638)
!638 = distinct !DILocation(line: 621, column: 18, scope: !65, inlinedAt: !617)
!639 = !DILocation(line: 1547, column: 17, scope: !30, inlinedAt: !636)
!640 = !DILocation(line: 1547, column: 9, scope: !30, inlinedAt: !636)
!641 = !DILocation(line: 1548, column: 20, scope: !30, inlinedAt: !636)
!642 = !DILocation(line: 1548, column: 18, scope: !30, inlinedAt: !636)
!643 = !DILocation(line: 1548, column: 9, scope: !30, inlinedAt: !636)
!644 = !DILocation(line: 410, column: 44, scope: !56, inlinedAt: !645)
!645 = distinct !DILocation(line: 196, column: 34, scope: !43, inlinedAt: !638)
!646 = !DILocation(line: 622, column: 28, scope: !81, inlinedAt: !617)
!647 = !DILocation(line: 871, column: 18, scope: !19, inlinedAt: !648)
!648 = distinct !DILocation(line: 622, column: 24, scope: !81, inlinedAt: !617)
!649 = !DILocation(line: 623, column: 28, scope: !85, inlinedAt: !617)
!650 = !DILocation(line: 871, column: 18, scope: !19, inlinedAt: !651)
!651 = distinct !DILocation(line: 623, column: 24, scope: !85, inlinedAt: !617)
!652 = !DILocation(line: 624, column: 28, scope: !89, inlinedAt: !617)
!653 = !DILocation(line: 871, column: 18, scope: !19, inlinedAt: !654)
!654 = distinct !DILocation(line: 624, column: 24, scope: !89, inlinedAt: !617)
!655 = !DILocation(line: 625, column: 28, scope: !93, inlinedAt: !617)
!656 = !DILocation(line: 871, column: 18, scope: !19, inlinedAt: !657)
!657 = distinct !DILocation(line: 625, column: 24, scope: !93, inlinedAt: !617)
!658 = !DILocation(line: 635, column: 18, scope: !97, inlinedAt: !617)
!659 = !DILocation(line: 1547, column: 19, scope: !30, inlinedAt: !660)
!660 = distinct !DILocation(line: 166, column: 5, scope: !37, inlinedAt: !661)
!661 = distinct !DILocation(line: 196, column: 34, scope: !43, inlinedAt: !662)
!662 = distinct !DILocation(line: 635, column: 18, scope: !97, inlinedAt: !617)
!663 = !DILocation(line: 1547, column: 17, scope: !30, inlinedAt: !660)
!664 = !DILocation(line: 1547, column: 9, scope: !30, inlinedAt: !660)
!665 = !DILocation(line: 1548, column: 20, scope: !30, inlinedAt: !660)
!666 = !DILocation(line: 1548, column: 18, scope: !30, inlinedAt: !660)
!667 = !DILocation(line: 1548, column: 9, scope: !30, inlinedAt: !660)
!668 = !DILocation(line: 410, column: 44, scope: !56, inlinedAt: !669)
!669 = distinct !DILocation(line: 196, column: 34, scope: !43, inlinedAt: !662)
!670 = !DILocation(line: 636, column: 18, scope: !110, inlinedAt: !617)
!671 = !DILocation(line: 1547, column: 19, scope: !30, inlinedAt: !672)
!672 = distinct !DILocation(line: 166, column: 5, scope: !37, inlinedAt: !673)
!673 = distinct !DILocation(line: 196, column: 34, scope: !43, inlinedAt: !674)
!674 = distinct !DILocation(line: 636, column: 18, scope: !110, inlinedAt: !617)
!675 = !DILocation(line: 1547, column: 17, scope: !30, inlinedAt: !672)
!676 = !DILocation(line: 1547, column: 9, scope: !30, inlinedAt: !672)
!677 = !DILocation(line: 1548, column: 20, scope: !30, inlinedAt: !672)
!678 = !DILocation(line: 1548, column: 18, scope: !30, inlinedAt: !672)
!679 = !DILocation(line: 1548, column: 9, scope: !30, inlinedAt: !672)
!680 = !DILocation(line: 410, column: 44, scope: !56, inlinedAt: !681)
!681 = distinct !DILocation(line: 196, column: 34, scope: !43, inlinedAt: !674)
!682 = !DILocation(line: 879, column: 9, scope: !123, inlinedAt: !683)
!683 = distinct !DILocation(line: 639, column: 62, scope: !134, inlinedAt: !617)
!684 = !DILocation(line: 879, column: 9, scope: !123, inlinedAt: !685)
!685 = distinct !DILocation(line: 639, column: 28, scope: !134, inlinedAt: !617)
!686 = !DILocation(line: 879, column: 9, scope: !123, inlinedAt: !687)
!687 = distinct !DILocation(line: 640, column: 63, scope: !141, inlinedAt: !617)
!688 = !DILocation(line: 879, column: 9, scope: !123, inlinedAt: !689)
!689 = distinct !DILocation(line: 640, column: 29, scope: !141, inlinedAt: !617)
!690 = !DILocation(line: 643, column: 18, scope: !145, inlinedAt: !617)
!691 = !DILocation(line: 1547, column: 19, scope: !30, inlinedAt: !692)
!692 = distinct !DILocation(line: 166, column: 5, scope: !37, inlinedAt: !693)
!693 = distinct !DILocation(line: 196, column: 34, scope: !43, inlinedAt: !694)
!694 = distinct !DILocation(line: 643, column: 18, scope: !145, inlinedAt: !617)
!695 = !DILocation(line: 1547, column: 17, scope: !30, inlinedAt: !692)
!696 = !DILocation(line: 1547, column: 9, scope: !30, inlinedAt: !692)
!697 = !DILocation(line: 1548, column: 20, scope: !30, inlinedAt: !692)
!698 = !DILocation(line: 1548, column: 18, scope: !30, inlinedAt: !692)
!699 = !DILocation(line: 1548, column: 9, scope: !30, inlinedAt: !692)
!700 = !DILocation(line: 410, column: 44, scope: !56, inlinedAt: !701)
!701 = distinct !DILocation(line: 196, column: 34, scope: !43, inlinedAt: !694)
!702 = !DILocation(line: 879, column: 9, scope: !123, inlinedAt: !703)
!703 = distinct !DILocation(line: 637, column: 19, scope: !136, inlinedAt: !617)
!704 = !DILocation(line: 573, column: 14, scope: !160, inlinedAt: !705)
!705 = distinct !DILocation(line: 647, column: 9, scope: !163, inlinedAt: !617)
!706 = !DILocation(line: 970, column: 18, scope: !167, inlinedAt: !707)
!707 = distinct !DILocation(line: 648, column: 42, scope: !163, inlinedAt: !617)
!708 = !DILocation(line: 879, column: 9, scope: !123, inlinedAt: !709)
!709 = distinct !DILocation(line: 644, column: 18, scope: !165, inlinedAt: !617)
!710 = !DILocation(line: 573, column: 14, scope: !160, inlinedAt: !711)
!711 = distinct !DILocation(line: 648, column: 9, scope: !163, inlinedAt: !617)
!712 = !DILocation(line: 970, column: 18, scope: !167, inlinedAt: !713)
!713 = distinct !DILocation(line: 649, column: 42, scope: !163, inlinedAt: !617)
!714 = !DILocation(line: 879, column: 9, scope: !123, inlinedAt: !715)
!715 = distinct !DILocation(line: 645, column: 18, scope: !164, inlinedAt: !617)
!716 = !DILocation(line: 573, column: 14, scope: !160, inlinedAt: !717)
!717 = distinct !DILocation(line: 649, column: 9, scope: !163, inlinedAt: !617)
!718 = !DILocation(line: 970, column: 18, scope: !167, inlinedAt: !719)
!719 = distinct !DILocation(line: 650, column: 43, scope: !163, inlinedAt: !617)
!720 = !DILocation(line: 879, column: 9, scope: !123, inlinedAt: !721)
!721 = distinct !DILocation(line: 638, column: 19, scope: !135, inlinedAt: !617)
!722 = !DILocation(line: 573, column: 14, scope: !160, inlinedAt: !723)
!723 = distinct !DILocation(line: 650, column: 9, scope: !163, inlinedAt: !617)
!724 = !DILocation(line: 252, column: 16, scope: !486)
!725 = !DILocation(line: 573, column: 14, scope: !726, inlinedAt: !727)
!726 = distinct !DISubprogram(name: "copy_nonoverlapping<f64>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3ptr19copy_nonoverlappingdECs68MIsFmw01O_12evidence_lab", scope: !23, file: !161, line: 552, type: !24, scopeLine: 552, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !16)
!727 = !DILocation(line: 259, column: 13, scope: !486)
!728 = !DILocation(line: 970, column: 18, scope: !491, inlinedAt: !729)
!729 = !DILocation(line: 260, column: 45, scope: !486)
!730 = !DILocation(line: 970, column: 18, scope: !491, inlinedAt: !731)
!731 = !DILocation(line: 260, column: 74, scope: !486)
!732 = !DILocation(line: 573, column: 14, scope: !726, inlinedAt: !733)
!733 = !DILocation(line: 260, column: 13, scope: !486)
!734 = !DILocation(line: 0, scope: !486)
!735 = !DILocation(line: 2144, column: 50, scope: !736, inlinedAt: !739)
!736 = distinct !DISubprogram(name: "lt", linkageName: "_RNvXsU_NtNtCsjIpoRzUjyHQ_4core3cmp5implsjNtB7_10PartialOrd2lt", scope: !737, file: !57, line: 2144, type: !24, scopeLine: 2144, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !16)
!737 = !DINamespace(name: "{impl#58}", scope: !738)
!738 = !DINamespace(name: "impls", scope: !61)
!739 = !DILocation(line: 1100, column: 12, scope: !740, inlinedAt: !745)
!740 = distinct !DISubprogram(name: "spec_next<usize>", linkageName: "_RNvXs3_NtNtCsjIpoRzUjyHQ_4core4iter5rangeINtNtNtB9_3ops5range5RangejENtB5_17RangeIteratorImpl9spec_nextCs68MIsFmw01O_12evidence_lab", scope: !742, file: !741, line: 1099, type: !24, scopeLine: 1099, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !16)
!741 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/iter/range.rs", directory: "", checksumkind: CSK_MD5, checksum: "6038fbd2305f6e8ce8c79c7d50b4046d")
!742 = !DINamespace(name: "{impl#5}", scope: !743)
!743 = !DINamespace(name: "range", scope: !744)
!744 = !DINamespace(name: "iter", scope: !14)
!745 = !DILocation(line: 1185, column: 14, scope: !746, inlinedAt: !748)
!746 = distinct !DISubprogram(name: "next<usize>", linkageName: "_RNvXs4_NtNtCsjIpoRzUjyHQ_4core4iter5rangeINtNtNtB9_3ops5range5RangejENtNtNtB7_6traits8iterator8Iterator4nextCs68MIsFmw01O_12evidence_lab", scope: !747, file: !741, line: 1184, type: !24, scopeLine: 1184, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !16)
!747 = !DINamespace(name: "{impl#6}", scope: !743)
!748 = !DILocation(line: 272, column: 22, scope: !749)
!749 = !DILexicalBlockFile(scope: !750, file: !9, discriminator: 2)
!750 = distinct !DILexicalBlock(scope: !751, file: !9, line: 272, column: 13)
!751 = distinct !DILexicalBlock(scope: !752, file: !9, line: 270, column: 13)
!752 = distinct !DILexicalBlock(scope: !753, file: !9, line: 269, column: 13)
!753 = distinct !DILexicalBlock(scope: !754, file: !9, line: 268, column: 13)
!754 = distinct !DILexicalBlock(scope: !755, file: !9, line: 265, column: 9)
!755 = distinct !DILexicalBlock(scope: !756, file: !9, line: 265, column: 9)
!756 = distinct !DILexicalBlock(scope: !486, file: !9, line: 241, column: 9)
!757 = !DILocation(line: 970, column: 18, scope: !491, inlinedAt: !758)
!758 = !DILocation(line: 268, column: 30, scope: !754)
!759 = !DILocation(line: 970, column: 18, scope: !491, inlinedAt: !760)
!760 = !DILocation(line: 269, column: 36, scope: !753)
!761 = !DILocation(line: 970, column: 18, scope: !491, inlinedAt: !762)
!762 = !DILocation(line: 273, column: 46, scope: !763)
!763 = distinct !DILexicalBlock(scope: !750, file: !9, line: 272, column: 13)
!764 = !DILocation(line: 970, column: 18, scope: !491, inlinedAt: !765)
!765 = !DILocation(line: 273, column: 58, scope: !763)
!766 = !DILocation(line: 573, column: 14, scope: !726, inlinedAt: !767)
!767 = !DILocation(line: 273, column: 17, scope: !763)
!768 = !DILocation(line: 1054, column: 22, scope: !430, inlinedAt: !769)
!769 = distinct !DILocation(line: 540, column: 29, scope: !426, inlinedAt: !770)
!770 = distinct !DILocation(line: 274, column: 17, scope: !763)
!771 = !DILocation(line: 541, column: 13, scope: !425, inlinedAt: !770)
!772 = !DILocation(line: 1547, column: 19, scope: !30, inlinedAt: !773)
!773 = distinct !DILocation(line: 166, column: 5, scope: !37, inlinedAt: !774)
!774 = distinct !DILocation(line: 196, column: 34, scope: !43, inlinedAt: !775)
!775 = distinct !DILocation(line: 541, column: 13, scope: !425, inlinedAt: !770)
!776 = !DILocation(line: 1547, column: 17, scope: !30, inlinedAt: !773)
!777 = !DILocation(line: 1547, column: 9, scope: !30, inlinedAt: !773)
!778 = !DILocation(line: 1548, column: 20, scope: !30, inlinedAt: !773)
!779 = !DILocation(line: 1548, column: 18, scope: !30, inlinedAt: !773)
!780 = !DILocation(line: 1548, column: 9, scope: !30, inlinedAt: !773)
!781 = !DILocation(line: 410, column: 44, scope: !56, inlinedAt: !782)
!782 = distinct !DILocation(line: 196, column: 34, scope: !43, inlinedAt: !775)
!783 = !DILocation(line: 573, column: 14, scope: !444, inlinedAt: !784)
!784 = distinct !DILocation(line: 557, column: 13, scope: !446, inlinedAt: !770)
!785 = !DILocation(line: 560, column: 16, scope: !446, inlinedAt: !770)
!786 = !DILocation(line: 1054, column: 22, scope: !430, inlinedAt: !787)
!787 = distinct !DILocation(line: 565, column: 25, scope: !446, inlinedAt: !770)
!788 = !DILocation(line: 566, column: 17, scope: !446, inlinedAt: !770)
!789 = !DILocation(line: 1548, column: 20, scope: !30, inlinedAt: !790)
!790 = distinct !DILocation(line: 166, column: 5, scope: !37, inlinedAt: !791)
!791 = distinct !DILocation(line: 196, column: 34, scope: !43, inlinedAt: !792)
!792 = distinct !DILocation(line: 566, column: 17, scope: !446, inlinedAt: !770)
!793 = !DILocation(line: 1548, column: 18, scope: !30, inlinedAt: !790)
!794 = !DILocation(line: 1548, column: 9, scope: !30, inlinedAt: !790)
!795 = !DILocation(line: 410, column: 44, scope: !56, inlinedAt: !796)
!796 = distinct !DILocation(line: 196, column: 34, scope: !43, inlinedAt: !792)
!797 = !DILocation(line: 0, scope: !426, inlinedAt: !770)
!798 = !DILocation(line: 573, column: 14, scope: !462, inlinedAt: !799)
!799 = distinct !DILocation(line: 306, column: 13, scope: !464, inlinedAt: !800)
!800 = distinct !DILocation(line: 847, column: 1, scope: !467, inlinedAt: !801)
!801 = distinct !DILocation(line: 570, column: 5, scope: !447, inlinedAt: !770)
!802 = !{!803, !805}
!803 = distinct !{!803, !804, !"_RNvXs5_NtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6shared9smallsortINtB5_10CopyOnDropdENtNtNtBd_3ops4drop4Drop4dropCs68MIsFmw01O_12evidence_lab: %self"}
!804 = distinct !{!804, !"_RNvXs5_NtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6shared9smallsortINtB5_10CopyOnDropdENtNtNtBd_3ops4drop4Drop4dropCs68MIsFmw01O_12evidence_lab"}
!805 = distinct !{!805, !806, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtNtNtB4_5slice4sort6shared9smallsort10CopyOnDropdEECs68MIsFmw01O_12evidence_lab: %_1"}
!806 = distinct !{!806, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtNtNtB4_5slice4sort6shared9smallsort10CopyOnDropdEECs68MIsFmw01O_12evidence_lab"}
!807 = !DILocation(line: 571, column: 2, scope: !426, inlinedAt: !770)
!808 = !DILocation(line: 1013, column: 17, scope: !809, inlinedAt: !813)
!809 = distinct !DISubprogram(name: "unchecked_add", linkageName: "_RNvMs9_NtCsjIpoRzUjyHQ_4core3numj13unchecked_add", scope: !811, file: !810, line: 1001, type: !24, scopeLine: 1001, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !16)
!810 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/num/uint_macros.rs", directory: "", checksumkind: CSK_MD5, checksum: "861b08c040dcb8e56aa7d23dacf541ca")
!811 = !DINamespace(name: "{impl#11}", scope: !812)
!812 = !DINamespace(name: "num", scope: !14)
!813 = !DILocation(line: 265, column: 28, scope: !814, inlinedAt: !816)
!814 = distinct !DISubprogram(name: "forward_unchecked", linkageName: "_RNvXsL_NtNtCsjIpoRzUjyHQ_4core4iter5rangejNtB5_4Step17forward_unchecked", scope: !815, file: !741, line: 263, type: !24, scopeLine: 263, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !16)
!815 = !DINamespace(name: "{impl#49}", scope: !743)
!816 = !DILocation(line: 1103, column: 35, scope: !817, inlinedAt: !745)
!817 = distinct !DILexicalBlock(scope: !740, file: !741, line: 1101, column: 13)
!818 = !{!819}
!819 = distinct !{!819, !820, !"_RINvNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6shared9smallsort19bidirectional_mergedNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtBa_3f64d9total_cmpE0ECs68MIsFmw01O_12evidence_lab: %v.0"}
!820 = distinct !{!820, !"_RINvNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6shared9smallsort19bidirectional_mergedNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtBa_3f64d9total_cmpE0ECs68MIsFmw01O_12evidence_lab"}
!821 = !DILocation(line: 286, column: 9, scope: !822)
!822 = distinct !DILexicalBlock(scope: !756, file: !9, line: 279, column: 9)
!823 = !DILocation(line: 808, column: 37, scope: !310, inlinedAt: !824)
!824 = distinct !DILocation(line: 286, column: 9, scope: !822)
!825 = !DILocation(line: 970, column: 18, scope: !307, inlinedAt: !826)
!826 = distinct !DILocation(line: 809, column: 31, scope: !309, inlinedAt: !824)
!827 = !DILocation(line: 871, column: 18, scope: !828, inlinedAt: !829)
!828 = distinct !DISubprogram(name: "add<f64>", linkageName: "_RNvMNtNtCsjIpoRzUjyHQ_4core3ptr9const_ptrPd3addCs68MIsFmw01O_12evidence_lab", scope: !21, file: !20, line: 837, type: !24, scopeLine: 837, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !16)
!829 = distinct !DILocation(line: 808, column: 33, scope: !310, inlinedAt: !824)
!830 = !DILocation(line: 871, column: 18, scope: !828, inlinedAt: !831)
!831 = distinct !DILocation(line: 807, column: 32, scope: !311, inlinedAt: !824)
!832 = !DILocation(line: 1100, column: 12, scope: !833, inlinedAt: !834)
!833 = distinct !DISubprogram(name: "spec_next<usize>", linkageName: "_RNvXs3_NtNtCsjIpoRzUjyHQ_4core4iter5rangeINtNtNtB9_3ops5range5RangejENtB5_17RangeIteratorImpl9spec_nextCs68MIsFmw01O_12evidence_lab", scope: !742, file: !741, line: 1099, type: !24, scopeLine: 1099, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !16)
!834 = distinct !DILocation(line: 1185, column: 14, scope: !835, inlinedAt: !836)
!835 = distinct !DISubprogram(name: "next<usize>", linkageName: "_RNvXs4_NtNtCsjIpoRzUjyHQ_4core4iter5rangeINtNtNtB9_3ops5range5RangejENtNtNtB7_6traits8iterator8Iterator4nextCs68MIsFmw01O_12evidence_lab", scope: !747, file: !741, line: 1184, type: !24, scopeLine: 1184, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !16)
!836 = distinct !DILocation(line: 811, column: 18, scope: !837, inlinedAt: !824)
!837 = !DILexicalBlockFile(scope: !325, file: !9, discriminator: 2)
!838 = !DILocation(line: 473, column: 18, scope: !396, inlinedAt: !839)
!839 = distinct !DILocation(line: 1039, column: 14, scope: !398, inlinedAt: !840)
!840 = distinct !DILocation(line: 816, column: 33, scope: !326, inlinedAt: !824)
!841 = !DILocation(line: 473, column: 18, scope: !396, inlinedAt: !842)
!842 = distinct !DILocation(line: 1039, column: 14, scope: !402, inlinedAt: !843)
!843 = distinct !DILocation(line: 817, column: 35, scope: !404, inlinedAt: !824)
!844 = !DILocation(line: 3875, column: 22, scope: !845, inlinedAt: !846)
!845 = distinct !DISubprogram(name: "is_multiple_of", linkageName: "_RNvMs9_NtCsjIpoRzUjyHQ_4core3numj14is_multiple_of", scope: !811, file: !810, line: 3872, type: !24, scopeLine: 3872, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !16)
!846 = distinct !DILocation(line: 820, column: 17, scope: !406, inlinedAt: !824)
!847 = !DILocation(line: 820, column: 13, scope: !406, inlinedAt: !824)
!848 = !DILocation(line: 1013, column: 17, scope: !849, inlinedAt: !850)
!849 = distinct !DISubprogram(name: "unchecked_add", linkageName: "_RNvMs9_NtCsjIpoRzUjyHQ_4core3numj13unchecked_add", scope: !811, file: !810, line: 1001, type: !24, scopeLine: 1001, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !16)
!850 = distinct !DILocation(line: 265, column: 28, scope: !851, inlinedAt: !852)
!851 = distinct !DISubprogram(name: "forward_unchecked", linkageName: "_RNvXsL_NtNtCsjIpoRzUjyHQ_4core4iter5rangejNtB5_4Step17forward_unchecked", scope: !815, file: !741, line: 263, type: !24, scopeLine: 263, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !16)
!852 = distinct !DILocation(line: 1103, column: 35, scope: !853, inlinedAt: !834)
!853 = distinct !DILexicalBlock(scope: !833, file: !741, line: 1101, column: 13)
!854 = !DILocation(line: 698, column: 21, scope: !323, inlinedAt: !855)
!855 = distinct !DILocation(line: 812, column: 34, scope: !325, inlinedAt: !824)
!856 = !DILocation(line: 1547, column: 19, scope: !30, inlinedAt: !857)
!857 = distinct !DILocation(line: 166, column: 5, scope: !37, inlinedAt: !858)
!858 = distinct !DILocation(line: 196, column: 34, scope: !43, inlinedAt: !859)
!859 = distinct !DILocation(line: 698, column: 21, scope: !323, inlinedAt: !855)
!860 = !DILocation(line: 1547, column: 17, scope: !30, inlinedAt: !857)
!861 = !DILocation(line: 1547, column: 9, scope: !30, inlinedAt: !857)
!862 = !DILocation(line: 1548, column: 20, scope: !30, inlinedAt: !857)
!863 = !DILocation(line: 1548, column: 18, scope: !30, inlinedAt: !857)
!864 = !DILocation(line: 1548, column: 9, scope: !30, inlinedAt: !857)
!865 = !DILocation(line: 410, column: 44, scope: !56, inlinedAt: !866)
!866 = distinct !DILocation(line: 196, column: 34, scope: !43, inlinedAt: !859)
!867 = !DILocation(line: 698, column: 20, scope: !323, inlinedAt: !855)
!868 = !DILocation(line: 699, column: 19, scope: !336, inlinedAt: !855)
!869 = !DILocation(line: 573, column: 14, scope: !338, inlinedAt: !870)
!870 = distinct !DILocation(line: 700, column: 9, scope: !340, inlinedAt: !855)
!871 = !{!872, !874, !819}
!872 = distinct !{!872, !873, !"_RINvNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6shared9smallsort8merge_updNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtBa_3f64d9total_cmpE0ECs68MIsFmw01O_12evidence_lab: %_0"}
!873 = distinct !{!873, !"_RINvNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6shared9smallsort8merge_updNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtBa_3f64d9total_cmpE0ECs68MIsFmw01O_12evidence_lab"}
!874 = distinct !{!874, !873, !"_RINvNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6shared9smallsort8merge_updNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtBa_3f64d9total_cmpE0ECs68MIsFmw01O_12evidence_lab: %is_less"}
!875 = !DILocation(line: 701, column: 35, scope: !340, inlinedAt: !855)
!876 = !DILocation(line: 871, column: 18, scope: !347, inlinedAt: !877)
!877 = distinct !DILocation(line: 701, column: 31, scope: !340, inlinedAt: !855)
!878 = !DILocation(line: 702, column: 33, scope: !340, inlinedAt: !855)
!879 = !DILocation(line: 871, column: 18, scope: !347, inlinedAt: !880)
!880 = distinct !DILocation(line: 702, column: 29, scope: !340, inlinedAt: !855)
!881 = !DILocation(line: 970, column: 18, scope: !353, inlinedAt: !882)
!882 = distinct !DILocation(line: 703, column: 19, scope: !340, inlinedAt: !855)
!883 = !DILocation(line: 731, column: 21, scope: !359, inlinedAt: !884)
!884 = distinct !DILocation(line: 813, column: 46, scope: !325, inlinedAt: !824)
!885 = !DILocation(line: 1547, column: 19, scope: !30, inlinedAt: !886)
!886 = distinct !DILocation(line: 166, column: 5, scope: !37, inlinedAt: !887)
!887 = distinct !DILocation(line: 196, column: 34, scope: !43, inlinedAt: !888)
!888 = distinct !DILocation(line: 731, column: 21, scope: !359, inlinedAt: !884)
!889 = !DILocation(line: 1547, column: 17, scope: !30, inlinedAt: !886)
!890 = !DILocation(line: 1547, column: 9, scope: !30, inlinedAt: !886)
!891 = !DILocation(line: 1548, column: 20, scope: !30, inlinedAt: !886)
!892 = !DILocation(line: 1548, column: 18, scope: !30, inlinedAt: !886)
!893 = !DILocation(line: 1548, column: 9, scope: !30, inlinedAt: !886)
!894 = !DILocation(line: 410, column: 44, scope: !56, inlinedAt: !895)
!895 = distinct !DILocation(line: 196, column: 34, scope: !43, inlinedAt: !888)
!896 = !DILocation(line: 731, column: 20, scope: !359, inlinedAt: !884)
!897 = !DILocation(line: 732, column: 19, scope: !370, inlinedAt: !884)
!898 = !DILocation(line: 573, column: 14, scope: !372, inlinedAt: !899)
!899 = distinct !DILocation(line: 733, column: 9, scope: !374, inlinedAt: !884)
!900 = !{!901, !903, !819}
!901 = distinct !{!901, !902, !"_RINvNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6shared9smallsort10merge_downdNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtBa_3f64d9total_cmpE0ECs68MIsFmw01O_12evidence_lab: %_0"}
!902 = distinct !{!902, !"_RINvNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6shared9smallsort10merge_downdNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtBa_3f64d9total_cmpE0ECs68MIsFmw01O_12evidence_lab"}
!903 = distinct !{!903, !902, !"_RINvNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6shared9smallsort10merge_downdNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtBa_3f64d9total_cmpE0ECs68MIsFmw01O_12evidence_lab: %is_less"}
!904 = !DILocation(line: 734, column: 44, scope: !374, inlinedAt: !884)
!905 = !DILocation(line: 473, column: 18, scope: !381, inlinedAt: !906)
!906 = distinct !DILocation(line: 1118, column: 14, scope: !383, inlinedAt: !907)
!907 = distinct !DILocation(line: 734, column: 31, scope: !374, inlinedAt: !884)
!908 = !DILocation(line: 735, column: 42, scope: !374, inlinedAt: !884)
!909 = !DILocation(line: 473, column: 18, scope: !381, inlinedAt: !910)
!910 = distinct !DILocation(line: 1118, column: 14, scope: !388, inlinedAt: !911)
!911 = distinct !DILocation(line: 735, column: 29, scope: !374, inlinedAt: !884)
!912 = !DILocation(line: 1054, column: 22, scope: !391, inlinedAt: !913)
!913 = distinct !DILocation(line: 736, column: 19, scope: !374, inlinedAt: !884)
!914 = !DILocation(line: 2144, column: 50, scope: !915, inlinedAt: !916)
!915 = distinct !DISubprogram(name: "lt", linkageName: "_RNvXsU_NtNtCsjIpoRzUjyHQ_4core3cmp5implsjNtB7_10PartialOrd2lt", scope: !737, file: !57, line: 2144, type: !24, scopeLine: 2144, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !16)
!916 = distinct !DILocation(line: 1100, column: 12, scope: !833, inlinedAt: !834)
!917 = !DILocation(line: 821, column: 33, scope: !406, inlinedAt: !824)
!918 = !DILocation(line: 822, column: 28, scope: !919, inlinedAt: !824)
!919 = distinct !DILexicalBlock(scope: !406, file: !9, line: 821, column: 13)
!920 = !DILocation(line: 573, column: 14, scope: !921, inlinedAt: !922)
!921 = distinct !DISubprogram(name: "copy_nonoverlapping<f64>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3ptr19copy_nonoverlappingdECs68MIsFmw01O_12evidence_lab", scope: !23, file: !161, line: 552, type: !24, scopeLine: 552, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !16)
!922 = distinct !DILocation(line: 823, column: 13, scope: !923, inlinedAt: !824)
!923 = distinct !DILexicalBlock(scope: !919, file: !9, line: 822, column: 13)
!924 = !DILocation(line: 824, column: 29, scope: !923, inlinedAt: !824)
!925 = !DILocation(line: 871, column: 18, scope: !828, inlinedAt: !926)
!926 = distinct !DILocation(line: 824, column: 25, scope: !923, inlinedAt: !824)
!927 = !DILocation(line: 825, column: 31, scope: !923, inlinedAt: !824)
!928 = !DILocation(line: 871, column: 18, scope: !828, inlinedAt: !929)
!929 = distinct !DILocation(line: 825, column: 27, scope: !923, inlinedAt: !824)
!930 = !DILocation(line: 820, column: 9, scope: !406, inlinedAt: !824)
!931 = !DILocation(line: 0, scope: !313, inlinedAt: !824)
!932 = !DILocation(line: 0, scope: !314, inlinedAt: !824)
!933 = !DILocation(line: 831, column: 12, scope: !406, inlinedAt: !824)
!934 = !DILocation(line: 832, column: 13, scope: !406, inlinedAt: !824)
!935 = !DILocation(line: 573, column: 14, scope: !462, inlinedAt: !936)
!936 = distinct !DILocation(line: 306, column: 13, scope: !464, inlinedAt: !937)
!937 = distinct !DILocation(line: 847, column: 1, scope: !467, inlinedAt: !938)
!938 = distinct !DILocation(line: 292, column: 5, scope: !756)
!939 = !{!940, !942}
!940 = distinct !{!940, !941, !"_RNvXs5_NtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6shared9smallsortINtB5_10CopyOnDropdENtNtNtBd_3ops4drop4Drop4dropCs68MIsFmw01O_12evidence_lab: %self"}
!941 = distinct !{!941, !"_RNvXs5_NtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6shared9smallsortINtB5_10CopyOnDropdENtNtNtBd_3ops4drop4Drop4dropCs68MIsFmw01O_12evidence_lab"}
!942 = distinct !{!942, !943, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtNtNtB4_5slice4sort6shared9smallsort10CopyOnDropdEECs68MIsFmw01O_12evidence_lab: %_1"}
!943 = distinct !{!943, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtNtNtB4_5slice4sort6shared9smallsort10CopyOnDropdEECs68MIsFmw01O_12evidence_lab"}
!944 = !DILocation(line: 220, column: 1, scope: !477)
!945 = !DILocation(line: 293, column: 2, scope: !477)
