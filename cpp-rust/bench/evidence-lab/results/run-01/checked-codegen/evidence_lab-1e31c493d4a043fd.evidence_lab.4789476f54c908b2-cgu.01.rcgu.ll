; ModuleID = 'evidence_lab.4789476f54c908b2-cgu.01'
source_filename = "evidence_lab.4789476f54c908b2-cgu.01"
target datalayout = "e-m:o-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-n32:64-S128-Fn32"
target triple = "arm64-apple-macosx11.0.0"

; core::slice::sort::stable::drift::sort::<f64, <[f64]>::sort_by<<f64>::total_cmp>::{closure#0}>
; Function Attrs: uwtable
define hidden void @_RINvNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6stable5drift4sortdNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtBa_3f64d9total_cmpE0ECs68MIsFmw01O_12evidence_lab(ptr noalias nofree noundef nonnull align 8 %v.0, i64 noundef range(i64 0, 1152921504606846976) %v.1, ptr noalias nofree noundef nonnull align 8 %scratch.0, i64 noundef range(i64 0, 1152921504606846976) %scratch.1, i1 noundef zeroext %eager_sort, ptr noalias nofree noundef align 8 dereferenceable(8) %is_less) unnamed_addr #0 personality ptr @rust_eh_personality !dbg !10 !guid !19 {
start:
  %desired_depth_storage = alloca [66 x i8], align 1
  %run_storage = alloca [528 x i8], align 8
  %_6 = icmp samesign ult i64 %v.1, 2, !dbg !20
  br i1 %_6, label %bb23, label %bb2, !dbg !20

bb2:                                              ; preds = %start
  %d = udiv i64 4611686018427387904, %v.1, !dbg !22
  %0 = mul i64 %d, %v.1, !dbg !30
  %r.decomposed = sub i64 4611686018427387904, %0, !dbg !30
  %_73.not = icmp ne i64 %r.decomposed, 0, !dbg !32
  %1 = zext i1 %_73.not to i64, !dbg !32
  %scale_factor.sroa.0.0 = add nuw nsw i64 %d, %1, !dbg !32
  %_9 = icmp samesign ult i64 %v.1, 4097, !dbg !34
  br i1 %_9, label %bb3, label %bb4, !dbg !34

bb4:                                              ; preds = %bb2
; call core::slice::sort::stable::drift::sqrt_approx
  %2 = tail call noundef i64 @_RNvNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6stable5drift11sqrt_approx(i64 noundef %v.1), !dbg !36
  br label %bb5, !dbg !36

bb3:                                              ; preds = %bb2
  %_1135 = lshr i64 %v.1, 1, !dbg !37
  %v1 = sub nsw i64 %v.1, %_1135, !dbg !38
  %..i = tail call noundef range(i64 0, 1152921504606846976) i64 @llvm.umin.i64(i64 %v1, i64 64), !dbg !39
  br label %bb5, !dbg !47

bb5:                                              ; preds = %bb3, %bb4
  %min_good_run_len.sroa.0.0 = phi i64 [ %..i, %bb3 ], [ %2, %bb4 ], !dbg !48
  call void @llvm.lifetime.start.p0(ptr nonnull %run_storage), !dbg !49
  call void @llvm.lifetime.start.p0(ptr nonnull %desired_depth_storage), !dbg !52
  br label %bb6, !dbg !55

bb6:                                              ; preds = %bb19, %bb5
  %prev_run.sroa.0.0 = phi i64 [ 1, %bb5 ], [ %next_run.sroa.0.0, %bb19 ], !dbg !60
  %scan_idx.sroa.0.0 = phi i64 [ 0, %bb5 ], [ %46, %bb19 ], !dbg !61
  %stack_len.sroa.0.0 = phi i64 [ 0, %bb5 ], [ %45, %bb19 ], !dbg !62
  %_22 = icmp ult i64 %scan_idx.sroa.0.0, %v.1, !dbg !63
  br i1 %_22, label %bb31, label %bb10, !dbg !63

bb10:                                             ; preds = %_RINvNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6stable5drift10create_rundNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtBa_3f64d9total_cmpE0ECs68MIsFmw01O_12evidence_lab.exit, %bb6
  %desired_depth.sroa.0.0 = phi i8 [ %26, %_RINvNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6stable5drift10create_rundNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtBa_3f64d9total_cmpE0ECs68MIsFmw01O_12evidence_lab.exit ], [ 0, %bb6 ], !dbg !65
  %next_run.sroa.0.0 = phi i64 [ %_0.sroa.0.0.i38, %_RINvNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6stable5drift10create_rundNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtBa_3f64d9total_cmpE0ECs68MIsFmw01O_12evidence_lab.exit ], [ 1, %bb6 ], !dbg !65
  %_3753 = icmp ugt i64 %stack_len.sroa.0.0, 1, !dbg !66
  br i1 %_3753, label %bb12.preheader, label %bb17, !dbg !66

bb12.preheader:                                   ; preds = %bb10
  %v_end.i = getelementptr inbounds nuw [8 x i8], ptr %v.0, i64 %scan_idx.sroa.0.0
  br label %bb12, !dbg !67

bb31:                                             ; preds = %bb6
  %new_len = sub nuw nsw i64 %v.1, %scan_idx.sroa.0.0, !dbg !68
  %_82 = getelementptr inbounds nuw [8 x i8], ptr %v.0, i64 %scan_idx.sroa.0.0, !dbg !77
  %_7.not.i = icmp ult i64 %new_len, %min_good_run_len.sroa.0.0, !dbg !82
  br i1 %_7.not.i, label %bb8.i40, label %bb1.i, !dbg !82

bb8.i40:                                          ; preds = %_RINvNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6shared17find_existing_rundNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtB8_3f64d9total_cmpE0ECs68MIsFmw01O_12evidence_lab.exit.i, %bb31
  br i1 %eager_sort, label %bb18.i42, label %bb12.i41, !dbg !86

bb1.i:                                            ; preds = %bb31
  %_4.i.i = icmp samesign ult i64 %new_len, 2, !dbg !87
  br i1 %_4.i.i, label %bb6.i36, label %bb2.i.i, !dbg !87

bb2.i.i:                                          ; preds = %bb1.i
  %_28.i.i = getelementptr inbounds nuw i8, ptr %_82, i64 8, !dbg !93
  %_28.i.val.i = load i64, ptr %_28.i.i, align 8, !dbg !102, !alias.scope !103, !noalias !106, !noundef !18
  %v.0.val.i = load i64, ptr %_82, align 8, !dbg !102, !alias.scope !103, !noalias !106, !noundef !18
  %_12.i.i.i.i = ashr i64 %_28.i.val.i, 63, !dbg !109
  %_10.i.i.i.i = lshr i64 %_12.i.i.i.i, 1, !dbg !131
  %3 = xor i64 %_10.i.i.i.i, %_28.i.val.i, !dbg !132
  %_17.i.i.i.i = ashr i64 %v.0.val.i, 63, !dbg !133
  %_15.i.i.i.i = lshr i64 %_17.i.i.i.i, 1, !dbg !134
  %4 = xor i64 %_15.i.i.i.i, %v.0.val.i, !dbg !135
  %_0.i.i = icmp slt i64 %3, %4, !dbg !136
  %_10.i25.not.i = icmp eq i64 %new_len, 2, !dbg !142
  br i1 %_0.i.i, label %bb4.i.preheader.i, label %bb11.i.preheader.i, !dbg !144

bb11.i.preheader.i:                               ; preds = %bb2.i.i
  br i1 %_10.i25.not.i, label %bb6.i36, label %bb12.i.i, !dbg !145

bb4.i.preheader.i:                                ; preds = %bb2.i.i
  br i1 %_10.i25.not.i, label %bb5.preheader.i.i.i, label %bb5.i.i, !dbg !146

bb12.i.i:                                         ; preds = %bb11.i.preheader.i, %bb15.i.i
  %_43.i.val.i = phi i64 [ %_40.i.val.i, %bb15.i.i ], [ %_28.i.val.i, %bb11.i.preheader.i ], !dbg !147
  %run_len.sroa.0.0.i23.i = phi i64 [ %7, %bb15.i.i ], [ 2, %bb11.i.preheader.i ]
  %_40.i.i = getelementptr inbounds nuw [8 x i8], ptr %_82, i64 %run_len.sroa.0.0.i23.i, !dbg !148
  %_40.i.val.i = load i64, ptr %_40.i.i, align 8, !dbg !147, !alias.scope !103, !noalias !106, !noundef !18
  %_12.i.i.i1.i = ashr i64 %_40.i.val.i, 63, !dbg !152
  %_10.i.i.i2.i = lshr i64 %_12.i.i.i1.i, 1, !dbg !156
  %5 = xor i64 %_10.i.i.i2.i, %_40.i.val.i, !dbg !157
  %_17.i.i.i3.i = ashr i64 %_43.i.val.i, 63, !dbg !158
  %_15.i.i.i4.i = lshr i64 %_17.i.i.i3.i, 1, !dbg !159
  %6 = xor i64 %_15.i.i.i4.i, %_43.i.val.i, !dbg !160
  %_0.i5.i = icmp slt i64 %5, %6, !dbg !161
  br i1 %_0.i5.i, label %_RINvNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6shared17find_existing_rundNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtB8_3f64d9total_cmpE0ECs68MIsFmw01O_12evidence_lab.exit.i, label %bb15.i.i, !dbg !147

bb15.i.i:                                         ; preds = %bb12.i.i
  %7 = add nuw nsw i64 %run_len.sroa.0.0.i23.i, 1, !dbg !163
  %exitcond.not.i = icmp eq i64 %7, %new_len, !dbg !145
  br i1 %exitcond.not.i, label %_RINvNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6shared17find_existing_rundNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtB8_3f64d9total_cmpE0ECs68MIsFmw01O_12evidence_lab.exit.i, label %bb12.i.i, !dbg !145

bb5.i.i:                                          ; preds = %bb4.i.preheader.i, %bb7.i.i
  %_37.i.val.i = phi i64 [ %_34.i.val.i, %bb7.i.i ], [ %_28.i.val.i, %bb4.i.preheader.i ], !dbg !164
  %run_len.sroa.0.1.i26.i = phi i64 [ %10, %bb7.i.i ], [ 2, %bb4.i.preheader.i ]
  %_34.i.i = getelementptr inbounds nuw [8 x i8], ptr %_82, i64 %run_len.sroa.0.1.i26.i, !dbg !165
  %_34.i.val.i = load i64, ptr %_34.i.i, align 8, !dbg !164, !alias.scope !103, !noalias !106, !noundef !18
  %_12.i.i.i6.i = ashr i64 %_34.i.val.i, 63, !dbg !169
  %_10.i.i.i7.i = lshr i64 %_12.i.i.i6.i, 1, !dbg !173
  %8 = xor i64 %_10.i.i.i7.i, %_34.i.val.i, !dbg !174
  %_17.i.i.i8.i = ashr i64 %_37.i.val.i, 63, !dbg !175
  %_15.i.i.i9.i = lshr i64 %_17.i.i.i8.i, 1, !dbg !176
  %9 = xor i64 %_15.i.i.i9.i, %_37.i.val.i, !dbg !177
  %_0.i10.i = icmp slt i64 %8, %9, !dbg !178
  br i1 %_0.i10.i, label %bb7.i.i, label %_RINvNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6shared17find_existing_rundNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtB8_3f64d9total_cmpE0ECs68MIsFmw01O_12evidence_lab.exit.i, !dbg !164

bb7.i.i:                                          ; preds = %bb5.i.i
  %10 = add nuw nsw i64 %run_len.sroa.0.1.i26.i, 1, !dbg !180
  %exitcond31.not.i = icmp eq i64 %10, %new_len, !dbg !146
  br i1 %exitcond31.not.i, label %_RINvNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6shared17find_existing_rundNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtB8_3f64d9total_cmpE0ECs68MIsFmw01O_12evidence_lab.exit.i, label %bb5.i.i, !dbg !146

_RINvNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6shared17find_existing_rundNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtB8_3f64d9total_cmpE0ECs68MIsFmw01O_12evidence_lab.exit.i: ; preds = %bb15.i.i, %bb12.i.i, %bb7.i.i, %bb5.i.i
  %_0.sroa.0.0.i.i = phi i64 [ %new_len, %bb7.i.i ], [ %run_len.sroa.0.1.i26.i, %bb5.i.i ], [ %new_len, %bb15.i.i ], [ %run_len.sroa.0.0.i23.i, %bb12.i.i ], !dbg !181
  %_12.i = icmp samesign ule i64 %_0.sroa.0.0.i.i, %new_len, !dbg !182
  tail call void @llvm.assume(i1 %_12.i), !dbg !184
  %_13.not.i = icmp ult i64 %_0.sroa.0.0.i.i, %min_good_run_len.sroa.0.0, !dbg !185
  br i1 %_13.not.i, label %bb8.i40, label %bb3.i, !dbg !185

bb3.i:                                            ; preds = %_RINvNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6shared17find_existing_rundNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtB8_3f64d9total_cmpE0ECs68MIsFmw01O_12evidence_lab.exit.i
  br i1 %_0.i.i, label %bb16.i39, label %bb6.i36, !dbg !186

bb12.i41:                                         ; preds = %bb8.i40
  %..i.i = tail call noundef range(i64 0, 1152921504606846976) i64 @llvm.umin.i64(i64 range(i64 0, 1152921504606846976) %new_len, i64 %min_good_run_len.sroa.0.0), !dbg !187
  %_36.i = shl nuw nsw i64 %..i.i, 1, !dbg !191
  br label %_RINvNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6stable5drift10create_rundNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtBa_3f64d9total_cmpE0ECs68MIsFmw01O_12evidence_lab.exit, !dbg !195

bb18.i42:                                         ; preds = %bb8.i40
  %..i11.i = tail call noundef range(i64 0, 1152921504606846976) i64 @llvm.umin.i64(i64 range(i64 0, 1152921504606846976) %new_len, i64 32), !dbg !196
; call core::slice::sort::stable::quicksort::quicksort::<f64, <[f64]>::sort_by<<f64>::total_cmp>::{closure#0}>
  tail call void @_RINvNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6stable9quicksort9quicksortdNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtBa_3f64d9total_cmpE0ECs68MIsFmw01O_12evidence_lab(ptr noalias nofree noundef nonnull align 8 %_82, i64 noundef %..i11.i, ptr noalias nofree noundef nonnull align 8 %scratch.0, i64 noundef range(i64 0, 1152921504606846976) %scratch.1, i32 noundef 0, ptr noalias nofree noundef readonly align 8 captures(address, read_provenance) dereferenceable_or_null(8) null, ptr noalias nofree noundef nonnull align 8 dereferenceable(8) %is_less) #8, !dbg !199
  %_35.i = shl nuw nsw i64 %..i11.i, 1, !dbg !201
  %_34.i = or disjoint i64 %_35.i, 1, !dbg !201
  br label %_RINvNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6stable5drift10create_rundNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtBa_3f64d9total_cmpE0ECs68MIsFmw01O_12evidence_lab.exit, !dbg !195

bb6.i36:                                          ; preds = %bb6.i.i.i, %middle.block, %bb16.i39, %bb3.i, %bb11.i.preheader.i, %bb1.i
  %_0.sroa.0.0.i18.i = phi i64 [ %new_len, %bb1.i ], [ %_0.sroa.0.0.i.i, %bb3.i ], [ %_0.sroa.0.0.i.i, %bb16.i39 ], [ 2, %bb11.i.preheader.i ], [ %_0.sroa.0.0.i394751.i, %middle.block ], [ %_0.sroa.0.0.i394751.i, %bb6.i.i.i ]
  %_27.i = shl nuw nsw i64 %_0.sroa.0.0.i18.i, 1, !dbg !204
  %_26.i = or disjoint i64 %_27.i, 1, !dbg !204
  br label %_RINvNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6stable5drift10create_rundNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtBa_3f64d9total_cmpE0ECs68MIsFmw01O_12evidence_lab.exit, !dbg !206

bb16.i39:                                         ; preds = %bb3.i
  %half_len1.i.i = lshr i64 %_0.sroa.0.0.i.i, 1, !dbg !207
  tail call void @llvm.experimental.noalias.scope.decl(metadata !210), !dbg !213
  tail call void @llvm.experimental.noalias.scope.decl(metadata !217), !dbg !213
  %_917.not.i.i.i = icmp eq i64 %half_len1.i.i, 0, !dbg !219
  br i1 %_917.not.i.i.i, label %bb6.i36, label %bb5.preheader.i.i.i, !dbg !219

bb5.preheader.i.i.i:                              ; preds = %bb16.i39, %bb4.i.preheader.i
  %half_len1.i52.i = phi i64 [ %half_len1.i.i, %bb16.i39 ], [ 1, %bb4.i.preheader.i ]
  %_0.sroa.0.0.i394751.i = phi i64 [ %_0.sroa.0.0.i.i, %bb16.i39 ], [ 2, %bb4.i.preheader.i ]
  %end.i.i = getelementptr inbounds nuw [8 x i8], ptr %_82, i64 %_0.sroa.0.0.i394751.i, !dbg !226
  %min.iters.check = icmp samesign ult i64 %half_len1.i52.i, 4, !dbg !236
  br i1 %min.iters.check, label %bb6.i.i.i.preheader, label %vector.ph, !dbg !236

vector.ph:                                        ; preds = %bb5.preheader.i.i.i
  %n.vec = and i64 %half_len1.i52.i, 9223372036854775804
  br label %vector.body, !dbg !236

vector.body:                                      ; preds = %vector.body, %vector.ph
  %index = phi i64 [ 0, %vector.ph ], [ %index.next, %vector.body ], !dbg !237
  %11 = xor i64 %index, -1, !dbg !238
  %12 = getelementptr inbounds nuw [8 x i8], ptr %_82, i64 %index, !dbg !239
  %13 = getelementptr [8 x i8], ptr %end.i.i, i64 %11, !dbg !240
  %14 = getelementptr inbounds nuw i8, ptr %12, i64 16, !dbg !241
  %wide.load = load <2 x double>, ptr %12, align 8, !dbg !241, !alias.scope !246, !noalias !249
  %wide.load20 = load <2 x double>, ptr %14, align 8, !dbg !241, !alias.scope !246, !noalias !249
  %15 = getelementptr i8, ptr %13, i64 -8, !dbg !241
  %16 = getelementptr i8, ptr %13, i64 -24, !dbg !241
  %wide.load21 = load <2 x i64>, ptr %15, align 8, !dbg !241, !alias.scope !250, !noalias !251
  %wide.load22 = load <2 x i64>, ptr %16, align 8, !dbg !241, !alias.scope !250, !noalias !251
  %reverse = shufflevector <2 x i64> %wide.load21, <2 x i64> poison, <2 x i32> <i32 1, i32 0>, !dbg !241
  %reverse23 = shufflevector <2 x i64> %wide.load22, <2 x i64> poison, <2 x i32> <i32 1, i32 0>, !dbg !241
  %17 = getelementptr inbounds nuw i8, ptr %12, i64 16, !dbg !241
  store <2 x i64> %reverse, ptr %12, align 8, !dbg !241, !alias.scope !246, !noalias !249
  store <2 x i64> %reverse23, ptr %17, align 8, !dbg !241, !alias.scope !246, !noalias !249
  %18 = getelementptr i8, ptr %13, i64 -8, !dbg !241
  %19 = getelementptr i8, ptr %13, i64 -24, !dbg !241
  %reverse24 = shufflevector <2 x double> %wide.load, <2 x double> poison, <2 x i32> <i32 1, i32 0>, !dbg !241
  %reverse25 = shufflevector <2 x double> %wide.load20, <2 x double> poison, <2 x i32> <i32 1, i32 0>, !dbg !241
  store <2 x double> %reverse24, ptr %18, align 8, !dbg !241, !alias.scope !250, !noalias !251
  store <2 x double> %reverse25, ptr %19, align 8, !dbg !241, !alias.scope !250, !noalias !251
  %index.next = add nuw i64 %index, 4, !dbg !237
  %20 = icmp eq i64 %index.next, %n.vec, !dbg !219
  br i1 %20, label %middle.block, label %vector.body, !dbg !219, !llvm.loop !252

middle.block:                                     ; preds = %vector.body
  %cmp.n = icmp eq i64 %half_len1.i52.i, %n.vec, !dbg !219
  br i1 %cmp.n, label %bb6.i36, label %bb6.i.i.i.preheader, !dbg !219

bb6.i.i.i.preheader:                              ; preds = %bb5.preheader.i.i.i, %middle.block
  %i.sroa.0.018.i.i.i.ph = phi i64 [ 0, %bb5.preheader.i.i.i ], [ %n.vec, %middle.block ]
  br label %bb6.i.i.i, !dbg !219

bb6.i.i.i:                                        ; preds = %bb6.i.i.i.preheader, %bb6.i.i.i
  %i.sroa.0.018.i.i.i = phi i64 [ %24, %bb6.i.i.i ], [ %i.sroa.0.018.i.i.i.ph, %bb6.i.i.i.preheader ]
  %21 = xor i64 %i.sroa.0.018.i.i.i, -1, !dbg !238
  %x.i.i.i = getelementptr inbounds nuw [8 x i8], ptr %_82, i64 %i.sroa.0.018.i.i.i, !dbg !239
  %y.i.i.i = getelementptr [8 x i8], ptr %end.i.i, i64 %21, !dbg !240
  %22 = load double, ptr %x.i.i.i, align 8, !dbg !241, !alias.scope !246, !noalias !249, !noundef !18
  %23 = load i64, ptr %y.i.i.i, align 8, !dbg !241, !alias.scope !250, !noalias !251
  store i64 %23, ptr %x.i.i.i, align 8, !dbg !241, !alias.scope !246, !noalias !249
  store double %22, ptr %y.i.i.i, align 8, !dbg !241, !alias.scope !250, !noalias !251
  %24 = add nuw nsw i64 %i.sroa.0.018.i.i.i, 1, !dbg !237
  %exitcond.not.i.i.i = icmp eq i64 %24, %half_len1.i52.i, !dbg !219
  br i1 %exitcond.not.i.i.i, label %bb6.i36, label %bb6.i.i.i, !dbg !219, !llvm.loop !255

_RINvNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6stable5drift10create_rundNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtBa_3f64d9total_cmpE0ECs68MIsFmw01O_12evidence_lab.exit: ; preds = %bb6.i36, %bb18.i42, %bb12.i41
  %_0.sroa.0.0.i38 = phi i64 [ %_26.i, %bb6.i36 ], [ %_34.i, %bb18.i42 ], [ %_36.i, %bb12.i41 ], !dbg !256
  %_31 = lshr i64 %prev_run.sroa.0.0, 1, !dbg !257
  %_35 = lshr i64 %_0.sroa.0.0.i38, 1, !dbg !260
  %factor = shl nuw nsw i64 %scan_idx.sroa.0.0, 1, !dbg !262
  %x = sub nsw i64 %factor, %_31, !dbg !262
  %y = add nuw nsw i64 %_35, %factor, !dbg !265
  %_90 = mul i64 %x, %scale_factor.sroa.0.0, !dbg !267
  %_91 = mul i64 %y, %scale_factor.sroa.0.0, !dbg !269
  %self4 = xor i64 %_91, %_90, !dbg !270
  %25 = tail call range(i64 0, 65) i64 @llvm.ctlz.i64(i64 %self4, i1 false), !dbg !271
  %26 = trunc nuw nsw i64 %25 to i8, !dbg !270
  br label %bb10, !dbg !274

bb12:                                             ; preds = %bb12.preheader, %_RINvNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6stable5drift13logical_mergedNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtBa_3f64d9total_cmpE0ECs68MIsFmw01O_12evidence_lab.exit
  %stack_len.sroa.0.155 = phi i64 [ %count, %_RINvNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6stable5drift13logical_mergedNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtBa_3f64d9total_cmpE0ECs68MIsFmw01O_12evidence_lab.exit ], [ %stack_len.sroa.0.0, %bb12.preheader ]
  %prev_run.sroa.0.154 = phi i64 [ %_0.sroa.0.0.i, %_RINvNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6stable5drift13logical_mergedNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtBa_3f64d9total_cmpE0ECs68MIsFmw01O_12evidence_lab.exit ], [ %prev_run.sroa.0.0, %bb12.preheader ]
  %count = add i64 %stack_len.sroa.0.155, -1, !dbg !275
  %_41 = getelementptr inbounds nuw i8, ptr %desired_depth_storage, i64 %count, !dbg !276
  %_40 = load i8, ptr %_41, align 1, !dbg !67, !noundef !18
  %_39.not = icmp ult i8 %_40, %desired_depth.sroa.0.0, !dbg !67
  br i1 %_39.not, label %bb17, label %bb13, !dbg !67

bb17:                                             ; preds = %_RINvNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6stable5drift13logical_mergedNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtBa_3f64d9total_cmpE0ECs68MIsFmw01O_12evidence_lab.exit, %bb12, %bb10
  %prev_run.sroa.0.1.lcssa = phi i64 [ %prev_run.sroa.0.0, %bb10 ], [ %_0.sroa.0.0.i, %_RINvNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6stable5drift13logical_mergedNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtBa_3f64d9total_cmpE0ECs68MIsFmw01O_12evidence_lab.exit ], [ %prev_run.sroa.0.154, %bb12 ], !dbg !60
  %stack_len.sroa.0.1.lcssa = phi i64 [ %stack_len.sroa.0.0, %bb10 ], [ 1, %_RINvNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6stable5drift13logical_mergedNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtBa_3f64d9total_cmpE0ECs68MIsFmw01O_12evidence_lab.exit ], [ %stack_len.sroa.0.155, %bb12 ], !dbg !62
  %_59 = getelementptr inbounds nuw [8 x i8], ptr %run_storage, i64 %stack_len.sroa.0.1.lcssa, !dbg !279
  store i64 %prev_run.sroa.0.1.lcssa, ptr %_59, align 8, !dbg !282
  %_61 = getelementptr inbounds nuw i8, ptr %desired_depth_storage, i64 %stack_len.sroa.0.1.lcssa, !dbg !283
  store i8 %desired_depth.sroa.0.0, ptr %_61, align 1, !dbg !285
  br i1 %_22, label %bb19, label %bb18, !dbg !286

bb13:                                             ; preds = %bb12
  %_46 = getelementptr inbounds nuw [8 x i8], ptr %run_storage, i64 %count, !dbg !287
  %left10 = load i64, ptr %_46, align 8, !dbg !289, !noundef !18
  %_50 = lshr i64 %left10, 1, !dbg !290
  %_51 = lshr i64 %prev_run.sroa.0.154, 1, !dbg !293
  %merged_len = add nuw i64 %_50, %_51, !dbg !295
  %merge_start_idx = sub i64 %scan_idx.sroa.0.0, %merged_len, !dbg !296
  %_97 = getelementptr inbounds nuw [8 x i8], ptr %v.0, i64 %merge_start_idx, !dbg !298
  %can_fit_in_scratch.i = icmp samesign ugt i64 %merged_len, %scratch.1, !dbg !308
  %_10.i = trunc i64 %prev_run.sroa.0.154 to i1
  %27 = or i64 %left10, %prev_run.sroa.0.154, !dbg !313
  %28 = trunc i64 %27 to i1, !dbg !313
  %or.cond2.i = or i1 %can_fit_in_scratch.i, %28, !dbg !313
  br i1 %or.cond2.i, label %bb5.i, label %bb14.i, !dbg !313

bb5.i:                                            ; preds = %bb13
  %_9.i = trunc i64 %left10 to i1
  br i1 %_9.i, label %bb8.i, label %bb16.i, !dbg !315

bb14.i:                                           ; preds = %bb13
  %_40.i = shl nuw nsw i64 %merged_len, 1, !dbg !316
  br label %_RINvNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6stable5drift13logical_mergedNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtBa_3f64d9total_cmpE0ECs68MIsFmw01O_12evidence_lab.exit, !dbg !319

bb8.i:                                            ; preds = %bb16.i, %bb5.i
  br i1 %_10.i, label %bb12.i, label %bb22.i, !dbg !320

bb16.i:                                           ; preds = %bb5.i
  %self.i = or i64 %_50, 1, !dbg !321
  %29 = tail call range(i64 4, 64) i64 @llvm.ctlz.i64(i64 %self.i, i1 true), !dbg !324
  %_13.i = trunc nuw nsw i64 %29 to i32, !dbg !324
  %log.i = shl nuw nsw i32 %_13.i, 1, !dbg !339
  %limit.i = xor i32 %log.i, 126, !dbg !339
; call core::slice::sort::stable::quicksort::quicksort::<f64, <[f64]>::sort_by<<f64>::total_cmp>::{closure#0}>
  tail call void @_RINvNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6stable9quicksort9quicksortdNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtBa_3f64d9total_cmpE0ECs68MIsFmw01O_12evidence_lab(ptr noalias nofree noundef nonnull align 8 %_97, i64 noundef range(i64 0, 1152921504606846976) %_50, ptr noalias nofree noundef nonnull align 8 %scratch.0, i64 noundef range(i64 0, 1152921504606846976) %scratch.1, i32 noundef %limit.i, ptr noalias nofree noundef readonly align 8 captures(address, read_provenance) dereferenceable_or_null(8) null, ptr noalias nofree noundef nonnull align 8 dereferenceable(8) %is_less) #8, !dbg !340
  br label %bb8.i, !dbg !342

bb22.i:                                           ; preds = %bb8.i
  %_37.i = getelementptr inbounds nuw [8 x i8], ptr %_97, i64 %_50, !dbg !343
  %self.i43 = or i64 %_51, 1, !dbg !353
  %30 = tail call range(i64 4, 64) i64 @llvm.ctlz.i64(i64 %self.i43, i1 true), !dbg !355
  %_13.i44 = trunc nuw nsw i64 %30 to i32, !dbg !355
  %log.i45 = shl nuw nsw i32 %_13.i44, 1, !dbg !360
  %limit.i46 = xor i32 %log.i45, 126, !dbg !360
; call core::slice::sort::stable::quicksort::quicksort::<f64, <[f64]>::sort_by<<f64>::total_cmp>::{closure#0}>
  tail call void @_RINvNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6stable9quicksort9quicksortdNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtBa_3f64d9total_cmpE0ECs68MIsFmw01O_12evidence_lab(ptr noalias nofree noundef nonnull align 8 %_37.i, i64 noundef range(i64 0, 1152921504606846976) %_51, ptr noalias nofree noundef nonnull align 8 %scratch.0, i64 noundef range(i64 0, 1152921504606846976) %scratch.1, i32 noundef %limit.i46, ptr noalias nofree noundef readonly align 8 captures(address, read_provenance) dereferenceable_or_null(8) null, ptr noalias nofree noundef nonnull align 8 dereferenceable(8) %is_less) #8, !dbg !361
  br label %bb12.i, !dbg !362

bb12.i:                                           ; preds = %bb22.i, %bb8.i
  tail call void @llvm.experimental.noalias.scope.decl(metadata !363), !dbg !366
  tail call void @llvm.experimental.noalias.scope.decl(metadata !367), !dbg !366
  %31 = icmp eq i64 %_50, 0, !dbg !369
  %_6.i = icmp eq i64 %_51, 0
  %or.cond.i = or i1 %_6.i, %31, !dbg !369
  br i1 %or.cond.i, label %_RINvNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6stable5merge5mergedNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtBa_3f64d9total_cmpE0ECs68MIsFmw01O_12evidence_lab.exit, label %bb2.i, !dbg !369

bb2.i:                                            ; preds = %bb12.i
  %..i.i3 = tail call i64 @llvm.umin.i64(i64 %_51, i64 %_50), !dbg !375
  %_7.i = icmp samesign ult i64 %scratch.1, %..i.i3, !dbg !380
  br i1 %_7.i, label %_RINvNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6stable5merge5mergedNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtBa_3f64d9total_cmpE0ECs68MIsFmw01O_12evidence_lab.exit, label %bb5.i4, !dbg !380

bb5.i4:                                           ; preds = %bb2.i
  %v_mid.i = getelementptr inbounds nuw [8 x i8], ptr %_97, i64 %_50, !dbg !381
  %left_is_shorter.not.i = icmp samesign ugt i64 %_50, %_51, !dbg !386
  %spec.select.i = select i1 %left_is_shorter.not.i, ptr %v_mid.i, ptr %_97, !dbg !391
  %32 = shl nuw nsw i64 %..i.i3, 3, !dbg !393
  tail call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 8 %scratch.0, ptr nonnull align 8 %spec.select.i, i64 %32, i1 false), !dbg !393, !alias.scope !399
  %_21.i = getelementptr inbounds nuw i8, ptr %scratch.0, i64 %32, !dbg !400
  br i1 %left_is_shorter.not.i, label %bb1.i.i, label %bb3.i.i, !dbg !402

bb1.i.i:                                          ; preds = %bb5.i4, %bb1.i.i
  %_215.i.i = phi ptr [ %_21.i.i, %bb1.i.i ], [ %_21.i, %bb5.i4 ], !dbg !404
  %_183.i.i = phi ptr [ %_18.i.i, %bb1.i.i ], [ %v_mid.i, %bb5.i4 ], !dbg !410
  %out.sroa.0.0.i.i = phi ptr [ %35, %bb1.i.i ], [ %v_end.i, %bb5.i4 ]
  %33 = getelementptr inbounds i8, ptr %_183.i.i, i64 -8, !dbg !404
  %34 = getelementptr inbounds i8, ptr %_215.i.i, i64 -8, !dbg !411
  %35 = getelementptr inbounds i8, ptr %out.sroa.0.0.i.i, i64 -8, !dbg !414
  %.val.i.i = load i64, ptr %34, align 8, !dbg !417, !alias.scope !367, !noalias !418, !noundef !18
  %.val7.i.i = load i64, ptr %33, align 8, !dbg !417, !alias.scope !363, !noalias !421, !noundef !18
  %_12.i.i.i.i.i = ashr i64 %.val.i.i, 63, !dbg !422
  %_10.i.i.i.i.i = lshr i64 %_12.i.i.i.i.i, 1, !dbg !431
  %36 = xor i64 %_10.i.i.i.i.i, %.val.i.i, !dbg !432
  %_17.i.i.i.i.i = ashr i64 %.val7.i.i, 63, !dbg !433
  %_15.i.i.i.i.i = lshr i64 %_17.i.i.i.i.i, 1, !dbg !434
  %37 = xor i64 %_15.i.i.i.i.i, %.val7.i.i, !dbg !435
  %_0.i.i.i = icmp slt i64 %36, %37, !dbg !436
  %38 = select i1 %_0.i.i.i, i64 %.val7.i.i, i64 %.val.i.i, !dbg !441
  store i64 %38, ptr %35, align 8, !dbg !443, !alias.scope !363, !noalias !421
  %_20.i.i = xor i1 %_0.i.i.i, true, !dbg !447
  %count.i.i = zext i1 %_20.i.i to i64, !dbg !447
  %_18.i.i = getelementptr inbounds nuw [8 x i8], ptr %33, i64 %count.i.i, !dbg !448
  %count4.i.i = zext i1 %_0.i.i.i to i64, !dbg !451
  %_21.i.i = getelementptr inbounds nuw [8 x i8], ptr %34, i64 %count4.i.i, !dbg !452
  %_23.i.i = icmp eq ptr %_18.i.i, %_97, !dbg !454
  %_26.i.i = icmp eq ptr %_21.i.i, %scratch.0
  %or.cond.i.i = select i1 %_23.i.i, i1 true, i1 %_26.i.i, !dbg !454
  br i1 %or.cond.i.i, label %bb16.i5, label %bb1.i.i, !dbg !454

bb3.i.i:                                          ; preds = %bb5.i4, %bb3.i.i
  %_259.i.i = phi ptr [ %_25.i.i, %bb3.i.i ], [ %_97, %bb5.i4 ], !dbg !455
  %right.sroa.0.08.i.i = phi ptr [ %_23.i19.i, %bb3.i.i ], [ %v_mid.i, %bb5.i4 ]
  %_837.i.i = phi ptr [ %_20.i18.i, %bb3.i.i ], [ %scratch.0, %bb5.i4 ]
  %right.sroa.0.0.val.i.i = load i64, ptr %right.sroa.0.08.i.i, align 8, !dbg !455, !alias.scope !363, !noalias !460, !noundef !18
  %_8.val.i.i = load i64, ptr %_837.i.i, align 8, !dbg !455, !alias.scope !367, !noalias !463, !noundef !18
  %_12.i.i.i.i12.i = ashr i64 %right.sroa.0.0.val.i.i, 63, !dbg !464
  %_10.i.i.i.i13.i = lshr i64 %_12.i.i.i.i12.i, 1, !dbg !468
  %39 = xor i64 %_10.i.i.i.i13.i, %right.sroa.0.0.val.i.i, !dbg !469
  %_17.i.i.i.i14.i = ashr i64 %_8.val.i.i, 63, !dbg !470
  %_15.i.i.i.i15.i = lshr i64 %_17.i.i.i.i14.i, 1, !dbg !471
  %40 = xor i64 %_15.i.i.i.i15.i, %_8.val.i.i, !dbg !472
  %_0.i.i16.i = icmp slt i64 %39, %40, !dbg !473
  %consume_left.i.i = xor i1 %_0.i.i16.i, true, !dbg !475
  %41 = select i1 %_0.i.i16.i, i64 %right.sroa.0.0.val.i.i, i64 %_8.val.i.i, !dbg !476
  store i64 %41, ptr %_259.i.i, align 8, !dbg !478, !alias.scope !363, !noalias !460
  %count.i17.i = zext i1 %consume_left.i.i to i64, !dbg !482
  %_20.i18.i = getelementptr inbounds nuw [8 x i8], ptr %_837.i.i, i64 %count.i17.i, !dbg !483
  %count2.i.i = zext i1 %_0.i.i16.i to i64, !dbg !486
  %_23.i19.i = getelementptr inbounds nuw [8 x i8], ptr %right.sroa.0.08.i.i, i64 %count2.i.i, !dbg !487
  %_25.i.i = getelementptr inbounds nuw i8, ptr %_259.i.i, i64 8, !dbg !493
  %_7.i.i = icmp ne ptr %_20.i18.i, %_21.i, !dbg !495
  %_10.i.i = icmp ne ptr %_23.i19.i, %v_end.i
  %or.cond.i20.i = select i1 %_7.i.i, i1 %_10.i.i, i1 false, !dbg !495
  br i1 %or.cond.i20.i, label %bb3.i.i, label %bb16.i5, !dbg !495

bb16.i5:                                          ; preds = %bb3.i.i, %bb1.i.i
  %merge_state.sroa.13.0.i = phi ptr [ %_18.i.i, %bb1.i.i ], [ %_25.i.i, %bb3.i.i ], !dbg !496
  %merge_state.sroa.7.0.i = phi ptr [ %_21.i.i, %bb1.i.i ], [ %_21.i, %bb3.i.i ], !dbg !497
  %merge_state.sroa.0.0.i = phi ptr [ %scratch.0, %bb1.i.i ], [ %_20.i18.i, %bb3.i.i ], !dbg !497
  %42 = ptrtoint ptr %merge_state.sroa.7.0.i to i64, !dbg !498
  %43 = ptrtoint ptr %merge_state.sroa.0.0.i to i64, !dbg !498
  %44 = sub nuw i64 %42, %43, !dbg !498
  tail call void @llvm.memcpy.p0.p0.i64(ptr nonnull align 8 %merge_state.sroa.13.0.i, ptr align 8 %merge_state.sroa.0.0.i, i64 %44, i1 false), !dbg !509, !alias.scope !399, !noalias !513
  br label %_RINvNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6stable5merge5mergedNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtBa_3f64d9total_cmpE0ECs68MIsFmw01O_12evidence_lab.exit, !dbg !518

_RINvNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6stable5merge5mergedNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtBa_3f64d9total_cmpE0ECs68MIsFmw01O_12evidence_lab.exit: ; preds = %bb12.i, %bb2.i, %bb16.i5
  %_39.i = shl nuw nsw i64 %merged_len, 1, !dbg !519
  %_38.i = or disjoint i64 %_39.i, 1, !dbg !519
  br label %_RINvNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6stable5drift13logical_mergedNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtBa_3f64d9total_cmpE0ECs68MIsFmw01O_12evidence_lab.exit, !dbg !319

_RINvNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6stable5drift13logical_mergedNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtBa_3f64d9total_cmpE0ECs68MIsFmw01O_12evidence_lab.exit: ; preds = %_RINvNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6stable5merge5mergedNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtBa_3f64d9total_cmpE0ECs68MIsFmw01O_12evidence_lab.exit, %bb14.i
  %_0.sroa.0.0.i = phi i64 [ %_38.i, %_RINvNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6stable5merge5mergedNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtBa_3f64d9total_cmpE0ECs68MIsFmw01O_12evidence_lab.exit ], [ %_40.i, %bb14.i ], !dbg !522
  %_37 = icmp ugt i64 %count, 1, !dbg !66
  br i1 %_37, label %bb12, label %bb17, !dbg !66

bb19:                                             ; preds = %bb17
  %45 = add i64 %stack_len.sroa.0.1.lcssa, 1, !dbg !523
  %_65 = lshr i64 %next_run.sroa.0.0, 1, !dbg !524
  %46 = add nuw i64 %_65, %scan_idx.sroa.0.0, !dbg !526
  br label %bb6, !dbg !55

bb18:                                             ; preds = %bb17
  %_98 = and i64 %prev_run.sroa.0.1.lcssa, 1, !dbg !527
  %_66.not = icmp eq i64 %_98, 0, !dbg !527
  br i1 %_66.not, label %bb21, label %bb22, !dbg !530

bb21:                                             ; preds = %bb18
  %self.i47 = or i64 %v.1, 1, !dbg !531
  %47 = tail call range(i64 4, 64) i64 @llvm.ctlz.i64(i64 %self.i47, i1 true), !dbg !533
  %_13.i48 = trunc nuw nsw i64 %47 to i32, !dbg !533
  %log.i49 = shl nuw nsw i32 %_13.i48, 1, !dbg !538
  %limit.i50 = xor i32 %log.i49, 126, !dbg !538
; call core::slice::sort::stable::quicksort::quicksort::<f64, <[f64]>::sort_by<<f64>::total_cmp>::{closure#0}>
  tail call void @_RINvNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6stable9quicksort9quicksortdNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtBa_3f64d9total_cmpE0ECs68MIsFmw01O_12evidence_lab(ptr noalias nofree noundef nonnull align 8 %v.0, i64 noundef range(i64 0, 1152921504606846976) %v.1, ptr noalias nofree noundef nonnull align 8 %scratch.0, i64 noundef range(i64 0, 1152921504606846976) %scratch.1, i32 noundef %limit.i50, ptr noalias nofree noundef readonly align 8 captures(address, read_provenance) dereferenceable_or_null(8) null, ptr noalias nofree noundef nonnull align 8 dereferenceable(8) %is_less) #8, !dbg !539
  br label %bb22, !dbg !540

bb22:                                             ; preds = %bb21, %bb18
  call void @llvm.lifetime.end.p0(ptr nonnull %desired_depth_storage), !dbg !541
  call void @llvm.lifetime.end.p0(ptr nonnull %run_storage), !dbg !542
  br label %bb23, !dbg !543

bb23:                                             ; preds = %bb22, %start
  ret void, !dbg !543
}

; Function Attrs: nounwind uwtable
declare noundef range(i32 0, 10) i32 @rust_eh_personality(i32 noundef, i32 noundef, i64 noundef, ptr noundef, ptr noundef) unnamed_addr #1

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.start.p0(ptr captures(none)) #2

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.lifetime.end.p0(ptr captures(none)) #2

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(inaccessiblemem: write)
declare void @llvm.assume(i1 noundef) #3

; core::slice::sort::stable::quicksort::quicksort::<f64, <[f64]>::sort_by<<f64>::total_cmp>::{closure#0}>
; Function Attrs: noinline uwtable
declare void @_RINvNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6stable9quicksort9quicksortdNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtBa_3f64d9total_cmpE0ECs68MIsFmw01O_12evidence_lab(ptr noalias nofree noundef nonnull align 8, i64 noundef range(i64 0, 1152921504606846976), ptr noalias nofree noundef nonnull align 8, i64 noundef range(i64 0, 1152921504606846976), i32 noundef, ptr noalias nofree noundef readonly align 8 captures(address, read_provenance) dereferenceable_or_null(8), ptr noalias nofree noundef align 8 dereferenceable(8)) unnamed_addr #4

; Function Attrs: nocallback nofree nosync nounwind speculatable willreturn memory(none)
declare i64 @llvm.ctlz.i64(i64, i1 immarg) #5

; core::slice::sort::stable::drift::sqrt_approx
; Function Attrs: uwtable
declare noundef i64 @_RNvNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6stable5drift11sqrt_approx(i64 noundef) unnamed_addr #0

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(inaccessiblemem: readwrite)
declare void @llvm.experimental.noalias.scope.decl(metadata) #6

; Function Attrs: nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none)
declare i64 @llvm.umin.i64(i64, i64) #7

; Function Attrs: nocallback nofree nosync nounwind willreturn memory(argmem: readwrite)
declare void @llvm.memcpy.p0.p0.i64(ptr noalias writeonly captures(none), ptr noalias readonly captures(none), i64, i1 immarg) #2

attributes #0 = { uwtable "frame-pointer"="non-leaf" "probe-stack"="inline-asm" "target-cpu"="apple-m1" }
attributes #1 = { nounwind uwtable "frame-pointer"="non-leaf" "probe-stack"="inline-asm" "target-cpu"="apple-m1" }
attributes #2 = { nocallback nofree nosync nounwind willreturn memory(argmem: readwrite) }
attributes #3 = { nocallback nofree nosync nounwind willreturn memory(inaccessiblemem: write) }
attributes #4 = { noinline uwtable "frame-pointer"="non-leaf" "probe-stack"="inline-asm" "target-cpu"="apple-m1" }
attributes #5 = { nocallback nofree nosync nounwind speculatable willreturn memory(none) }
attributes #6 = { nocallback nofree nosync nounwind willreturn memory(inaccessiblemem: readwrite) }
attributes #7 = { nocallback nocreateundeforpoison nofree nosync nounwind speculatable willreturn memory(none) }
attributes #8 = { noinline }

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
!7 = !DIFile(filename: "src/lib.rs/@/evidence_lab.4789476f54c908b2-cgu.01", directory: "/Users/juanwang/Desktop/tutorials/cpp-rust/bench/evidence-lab")
!8 = distinct !DICompileUnit(language: DW_LANG_Rust, file: !9, producer: "clang LLVM (rustc version 1.99.0 (b940084d7 2026-09-28))", isOptimized: true, runtimeVersion: 0, emissionKind: FullDebug, splitDebugInlining: false, nameTableKind: None)
!9 = !DIFile(filename: "src/lib.rs/@/evidence_lab.4789476f54c908b2-cgu.04", directory: "/Users/juanwang/Desktop/tutorials/cpp-rust/bench/evidence-lab")
!10 = distinct !DISubprogram(name: "sort<f64, alloc::slice::{impl#0}::sort_by::{closure_env#0}<f64, fn(&f64, &f64) -> core::cmp::Ordering>>", linkageName: "_RINvNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6stable5drift4sortdNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtBa_3f64d9total_cmpE0ECs68MIsFmw01O_12evidence_lab", scope: !12, file: !11, line: 20, type: !17, scopeLine: 20, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !18)
!11 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/slice/sort/stable/drift.rs", directory: "", checksumkind: CSK_MD5, checksum: "45ada0f6d66a135183fb6260ca4f4329")
!12 = !DINamespace(name: "drift", scope: !13)
!13 = !DINamespace(name: "stable", scope: !14)
!14 = !DINamespace(name: "sort", scope: !15)
!15 = !DINamespace(name: "slice", scope: !16)
!16 = !DINamespace(name: "core", scope: null)
!17 = !DISubroutineType(types: !18)
!18 = !{}
!19 = !{i64 3622447186708203038}
!20 = !DILocation(line: 27, column: 8, scope: !21)
!21 = distinct !DILexicalBlock(scope: !10, file: !11, line: 26, column: 5)
!22 = !DILocation(line: 3788, column: 21, scope: !23, inlinedAt: !27)
!23 = distinct !DISubprogram(name: "div_ceil", linkageName: "_RNvMs7_NtCsjIpoRzUjyHQ_4core3numy8div_ceil", scope: !25, file: !24, line: 3787, type: !17, scopeLine: 3787, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !18)
!24 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/num/uint_macros.rs", directory: "", checksumkind: CSK_MD5, checksum: "861b08c040dcb8e56aa7d23dacf541ca")
!25 = !DINamespace(name: "{impl#9}", scope: !26)
!26 = !DINamespace(name: "num", scope: !16)
!27 = !DILocation(line: 161, column: 18, scope: !28, inlinedAt: !29)
!28 = distinct !DISubprogram(name: "merge_tree_scale_factor", linkageName: "_RNvNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6stable5drift23merge_tree_scale_factor", scope: !12, file: !11, line: 156, type: !17, scopeLine: 156, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !18)
!29 = !DILocation(line: 30, column: 24, scope: !21)
!30 = !DILocation(line: 3789, column: 21, scope: !31, inlinedAt: !27)
!31 = distinct !DILexicalBlock(scope: !23, file: !24, line: 3788, column: 13)
!32 = !DILocation(line: 3790, column: 16, scope: !33, inlinedAt: !27)
!33 = distinct !DILexicalBlock(scope: !31, file: !24, line: 3789, column: 13)
!34 = !DILocation(line: 37, column: 31, scope: !35)
!35 = distinct !DILexicalBlock(scope: !21, file: !11, line: 30, column: 5)
!36 = !DILocation(line: 42, column: 9, scope: !35)
!37 = !DILocation(line: 40, column: 24, scope: !35)
!38 = !DILocation(line: 40, column: 18, scope: !35)
!39 = !DILocation(line: 1090, column: 5, scope: !40, inlinedAt: !44)
!40 = distinct !DISubprogram(name: "min<usize>", linkageName: "_RNvYjNtNtCsjIpoRzUjyHQ_4core3cmp3Ord3minCs68MIsFmw01O_12evidence_lab", scope: !42, file: !41, line: 1085, type: !17, scopeLine: 1085, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !18)
!41 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/cmp.rs", directory: "", checksumkind: CSK_MD5, checksum: "49e2a03e6445d88887d9438f640a7fcc")
!42 = !DINamespace(name: "Ord", scope: !43)
!43 = !DINamespace(name: "cmp", scope: !16)
!44 = distinct !DILocation(line: 1587, column: 8, scope: !45, inlinedAt: !46)
!45 = distinct !DISubprogram(name: "min<usize>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3cmp3minjECs68MIsFmw01O_12evidence_lab", scope: !43, file: !41, line: 1586, type: !17, scopeLine: 1586, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !18)
!46 = !DILocation(line: 40, column: 9, scope: !35)
!47 = !DILocation(line: 37, column: 28, scope: !35)
!48 = !DILocation(line: 0, scope: !35)
!49 = !DILocation(line: 50, column: 9, scope: !50)
!50 = distinct !DILexicalBlock(scope: !51, file: !11, line: 49, column: 5)
!51 = distinct !DILexicalBlock(scope: !35, file: !11, line: 37, column: 5)
!52 = !DILocation(line: 52, column: 9, scope: !53)
!53 = distinct !DILexicalBlock(scope: !54, file: !11, line: 51, column: 5)
!54 = distinct !DILexicalBlock(scope: !50, file: !11, line: 50, column: 5)
!55 = !DILocation(line: 57, column: 5, scope: !56)
!56 = distinct !DILexicalBlock(scope: !57, file: !11, line: 56, column: 5)
!57 = distinct !DILexicalBlock(scope: !58, file: !11, line: 55, column: 5)
!58 = distinct !DILexicalBlock(scope: !59, file: !11, line: 53, column: 5)
!59 = distinct !DILexicalBlock(scope: !53, file: !11, line: 52, column: 5)
!60 = !DILocation(line: 0, scope: !57)
!61 = !DILocation(line: 0, scope: !58)
!62 = !DILocation(line: 0, scope: !51)
!63 = !DILocation(line: 62, column: 12, scope: !64)
!64 = distinct !DILexicalBlock(scope: !56, file: !11, line: 61, column: 9)
!65 = !DILocation(line: 0, scope: !64)
!66 = !DILocation(line: 87, column: 19, scope: !64)
!67 = !DILocation(line: 87, column: 36, scope: !64)
!68 = !DILocation(line: 562, column: 27, scope: !69, inlinedAt: !73)
!69 = distinct !DISubprogram(name: "index_mut<f64>", linkageName: "_RNvXs5_NtNtCsjIpoRzUjyHQ_4core5slice5indexINtNtNtB9_3ops5range9RangeFromjEINtB5_10SliceIndexSdE9index_mutCs68MIsFmw01O_12evidence_lab", scope: !71, file: !70, line: 556, type: !17, scopeLine: 556, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !18)
!70 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/slice/index.rs", directory: "", checksumkind: CSK_MD5, checksum: "a6478e6d30216db9f8cdcb9288808b92")
!71 = !DINamespace(name: "{impl#7}", scope: !72)
!72 = !DINamespace(name: "index", scope: !15)
!73 = !DILocation(line: 32, column: 15, scope: !74, inlinedAt: !76)
!74 = distinct !DISubprogram(name: "index_mut<f64, core::ops::range::RangeFrom<usize>>", linkageName: "_RNvXs_NtNtCsjIpoRzUjyHQ_4core5slice5indexSdINtNtNtB8_3ops5index8IndexMutINtNtBK_5range9RangeFromjEE9index_mutCs68MIsFmw01O_12evidence_lab", scope: !75, file: !70, line: 31, type: !17, scopeLine: 31, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !18)
!75 = !DINamespace(name: "{impl#1}", scope: !72)
!76 = !DILocation(line: 64, column: 34, scope: !64)
!77 = !DILocation(line: 102, column: 24, scope: !78, inlinedAt: !80)
!78 = distinct !DILexicalBlock(scope: !79, file: !70, line: 100, column: 5)
!79 = distinct !DISubprogram(name: "get_offset_len_mut_noubcheck<f64>", linkageName: "_RINvNtNtCsjIpoRzUjyHQ_4core5slice5index28get_offset_len_mut_noubcheckdECs68MIsFmw01O_12evidence_lab", scope: !72, file: !70, line: 95, type: !17, scopeLine: 95, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !18)
!80 = !DILocation(line: 563, column: 19, scope: !81, inlinedAt: !73)
!81 = distinct !DILexicalBlock(scope: !69, file: !70, line: 562, column: 13)
!82 = !DILocation(line: 234, column: 8, scope: !83, inlinedAt: !85)
!83 = distinct !DILexicalBlock(scope: !84, file: !11, line: 233, column: 5)
!84 = distinct !DISubprogram(name: "create_run<f64, alloc::slice::{impl#0}::sort_by::{closure_env#0}<f64, fn(&f64, &f64) -> core::cmp::Ordering>>", linkageName: "_RINvNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6stable5drift10create_rundNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtBa_3f64d9total_cmpE0ECs68MIsFmw01O_12evidence_lab", scope: !12, file: !11, line: 226, type: !17, scopeLine: 226, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !18)
!85 = distinct !DILocation(line: 64, column: 17, scope: !64)
!86 = !DILocation(line: 249, column: 8, scope: !83, inlinedAt: !85)
!87 = !DILocation(line: 25, column: 8, scope: !88, inlinedAt: !92)
!88 = distinct !DILexicalBlock(scope: !90, file: !89, line: 24, column: 5)
!89 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/slice/sort/shared/mod.rs", directory: "", checksumkind: CSK_MD5, checksum: "884ee038a0f7f00a0d12eb0ee0f7f4ff")
!90 = distinct !DISubprogram(name: "find_existing_run<f64, alloc::slice::{impl#0}::sort_by::{closure_env#0}<f64, fn(&f64, &f64) -> core::cmp::Ordering>>", linkageName: "_RINvNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6shared17find_existing_rundNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtB8_3f64d9total_cmpE0ECs68MIsFmw01O_12evidence_lab", scope: !91, file: !89, line: 20, type: !17, scopeLine: 20, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !18)
!91 = !DINamespace(name: "shared", scope: !14)
!92 = distinct !DILocation(line: 235, column: 39, scope: !83, inlinedAt: !85)
!93 = !DILocation(line: 219, column: 13, scope: !94, inlinedAt: !96)
!94 = distinct !DISubprogram(name: "get_unchecked<f64>", linkageName: "_RNvXs0_NtNtCsjIpoRzUjyHQ_4core5slice5indexjINtB5_10SliceIndexSdE13get_uncheckedCs68MIsFmw01O_12evidence_lab", scope: !95, file: !70, line: 205, type: !17, scopeLine: 205, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !18)
!95 = !DINamespace(name: "{impl#2}", scope: !72)
!96 = distinct !DILocation(line: 647, column: 26, scope: !97, inlinedAt: !100)
!97 = distinct !DISubprogram(name: "get_unchecked<f64, usize>", linkageName: "_RINvMNtCsjIpoRzUjyHQ_4core5sliceSd13get_uncheckedjECs68MIsFmw01O_12evidence_lab", scope: !99, file: !98, line: 640, type: !17, scopeLine: 640, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !18)
!98 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/slice/mod.rs", directory: "", checksumkind: CSK_MD5, checksum: "3864a87bb6bc29c76dd67717f51013ca")
!99 = !DINamespace(name: "{impl#0}", scope: !15)
!100 = distinct !DILocation(line: 34, column: 45, scope: !101, inlinedAt: !92)
!101 = distinct !DILexicalBlock(scope: !88, file: !89, line: 33, column: 9)
!102 = !DILocation(line: 34, column: 35, scope: !101, inlinedAt: !92)
!103 = !{!104}
!104 = distinct !{!104, !105, !"_RINvNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6stable5drift10create_rundNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtBa_3f64d9total_cmpE0ECs68MIsFmw01O_12evidence_lab: %v.0"}
!105 = distinct !{!105, !"_RINvNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6stable5drift10create_rundNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtBa_3f64d9total_cmpE0ECs68MIsFmw01O_12evidence_lab"}
!106 = !{!107, !108}
!107 = distinct !{!107, !105, !"_RINvNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6stable5drift10create_rundNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtBa_3f64d9total_cmpE0ECs68MIsFmw01O_12evidence_lab: %scratch.0"}
!108 = distinct !{!108, !105, !"_RINvNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6stable5drift10create_rundNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtBa_3f64d9total_cmpE0ECs68MIsFmw01O_12evidence_lab: %is_less"}
!109 = !DILocation(line: 1547, column: 19, scope: !110, inlinedAt: !117)
!110 = distinct !DILexicalBlock(scope: !112, file: !111, line: 1523, column: 9)
!111 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/num/f64.rs", directory: "", checksumkind: CSK_MD5, checksum: "b3f8ed35e28142dfe7f88c4667789fd1")
!112 = distinct !DILexicalBlock(scope: !113, file: !111, line: 1522, column: 9)
!113 = distinct !DISubprogram(name: "total_cmp", linkageName: "_RNvMNtCsjIpoRzUjyHQ_4core3f64d9total_cmp", scope: !114, file: !111, line: 1521, type: !116, scopeLine: 1521, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !18)
!114 = !DINamespace(name: "{impl#0}", scope: !115)
!115 = !DINamespace(name: "f64", scope: !16)
!116 = !DISubroutineType(cc: DW_CC_nocall, types: !18)
!117 = distinct !DILocation(line: 166, column: 5, scope: !118, inlinedAt: !123)
!118 = distinct !DISubprogram(name: "call_mut<fn(&f64, &f64) -> core::cmp::Ordering, (&f64, &f64)>", linkageName: "_RNvYNvMNtCsjIpoRzUjyHQ_4core3f64d9total_cmpINtNtNtB7_3ops8function5FnMutTRdB19_EE8call_mutCs68MIsFmw01O_12evidence_lab", scope: !120, file: !119, line: 166, type: !116, scopeLine: 166, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !18)
!119 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/ops/function.rs", directory: "", checksumkind: CSK_MD5, checksum: "ae01f833f82cd27aa916c99d95502941")
!120 = !DINamespace(name: "FnMut", scope: !121)
!121 = !DINamespace(name: "function", scope: !122)
!122 = !DINamespace(name: "ops", scope: !16)
!123 = distinct !DILocation(line: 196, column: 34, scope: !124, inlinedAt: !130)
!124 = distinct !DISubprogram(name: "{closure#0}<f64, fn(&f64, &f64) -> core::cmp::Ordering>", linkageName: "_RNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtCsjIpoRzUjyHQ_4core3f64d9total_cmpE0Cs68MIsFmw01O_12evidence_lab", scope: !126, file: !125, line: 196, type: !116, scopeLine: 196, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !18)
!125 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/alloc/src/slice.rs", directory: "", checksumkind: CSK_MD5, checksum: "8e7bce5d617a4e88f7bdb700dff9d669")
!126 = !DINamespace(name: "sort_by", scope: !127)
!127 = !DINamespace(name: "{impl#0}", scope: !128)
!128 = !DINamespace(name: "slice", scope: !129)
!129 = !DINamespace(name: "alloc", scope: null)
!130 = distinct !DILocation(line: 34, column: 35, scope: !101, inlinedAt: !92)
!131 = !DILocation(line: 1547, column: 17, scope: !110, inlinedAt: !117)
!132 = !DILocation(line: 1547, column: 9, scope: !110, inlinedAt: !117)
!133 = !DILocation(line: 1548, column: 20, scope: !110, inlinedAt: !117)
!134 = !DILocation(line: 1548, column: 18, scope: !110, inlinedAt: !117)
!135 = !DILocation(line: 1548, column: 9, scope: !110, inlinedAt: !117)
!136 = !DILocation(line: 410, column: 44, scope: !137, inlinedAt: !141)
!137 = distinct !DILexicalBlock(scope: !138, file: !41, line: 410, column: 44)
!138 = distinct !DILexicalBlock(scope: !139, file: !41, line: 410, column: 44)
!139 = distinct !DISubprogram(name: "eq", linkageName: "_RNvXsb_NtCsjIpoRzUjyHQ_4core3cmpNtB5_8OrderingNtB5_9PartialEq2eq", scope: !140, file: !41, line: 410, type: !17, scopeLine: 410, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !18)
!140 = !DINamespace(name: "{impl#13}", scope: !43)
!141 = distinct !DILocation(line: 196, column: 34, scope: !124, inlinedAt: !130)
!142 = !DILocation(line: 0, scope: !143, inlinedAt: !92)
!143 = distinct !DILexicalBlock(scope: !101, file: !89, line: 34, column: 9)
!144 = !DILocation(line: 35, column: 12, scope: !143, inlinedAt: !92)
!145 = !DILocation(line: 40, column: 19, scope: !143, inlinedAt: !92)
!146 = !DILocation(line: 36, column: 19, scope: !143, inlinedAt: !92)
!147 = !DILocation(line: 40, column: 37, scope: !143, inlinedAt: !92)
!148 = !DILocation(line: 219, column: 13, scope: !94, inlinedAt: !149)
!149 = distinct !DILocation(line: 647, column: 26, scope: !150, inlinedAt: !151)
!150 = !DILexicalBlockFile(scope: !97, file: !98, discriminator: 8)
!151 = distinct !DILocation(line: 40, column: 47, scope: !143, inlinedAt: !92)
!152 = !DILocation(line: 1547, column: 19, scope: !110, inlinedAt: !153)
!153 = distinct !DILocation(line: 166, column: 5, scope: !118, inlinedAt: !154)
!154 = distinct !DILocation(line: 196, column: 34, scope: !124, inlinedAt: !155)
!155 = distinct !DILocation(line: 40, column: 37, scope: !143, inlinedAt: !92)
!156 = !DILocation(line: 1547, column: 17, scope: !110, inlinedAt: !153)
!157 = !DILocation(line: 1547, column: 9, scope: !110, inlinedAt: !153)
!158 = !DILocation(line: 1548, column: 20, scope: !110, inlinedAt: !153)
!159 = !DILocation(line: 1548, column: 18, scope: !110, inlinedAt: !153)
!160 = !DILocation(line: 1548, column: 9, scope: !110, inlinedAt: !153)
!161 = !DILocation(line: 410, column: 44, scope: !137, inlinedAt: !162)
!162 = distinct !DILocation(line: 196, column: 34, scope: !124, inlinedAt: !155)
!163 = !DILocation(line: 42, column: 17, scope: !143, inlinedAt: !92)
!164 = !DILocation(line: 36, column: 36, scope: !143, inlinedAt: !92)
!165 = !DILocation(line: 219, column: 13, scope: !94, inlinedAt: !166)
!166 = distinct !DILocation(line: 647, column: 26, scope: !167, inlinedAt: !168)
!167 = !DILexicalBlockFile(scope: !97, file: !98, discriminator: 4)
!168 = distinct !DILocation(line: 36, column: 46, scope: !143, inlinedAt: !92)
!169 = !DILocation(line: 1547, column: 19, scope: !110, inlinedAt: !170)
!170 = distinct !DILocation(line: 166, column: 5, scope: !118, inlinedAt: !171)
!171 = distinct !DILocation(line: 196, column: 34, scope: !124, inlinedAt: !172)
!172 = distinct !DILocation(line: 36, column: 36, scope: !143, inlinedAt: !92)
!173 = !DILocation(line: 1547, column: 17, scope: !110, inlinedAt: !170)
!174 = !DILocation(line: 1547, column: 9, scope: !110, inlinedAt: !170)
!175 = !DILocation(line: 1548, column: 20, scope: !110, inlinedAt: !170)
!176 = !DILocation(line: 1548, column: 18, scope: !110, inlinedAt: !170)
!177 = !DILocation(line: 1548, column: 9, scope: !110, inlinedAt: !170)
!178 = !DILocation(line: 410, column: 44, scope: !137, inlinedAt: !179)
!179 = distinct !DILocation(line: 196, column: 34, scope: !124, inlinedAt: !172)
!180 = !DILocation(line: 37, column: 17, scope: !143, inlinedAt: !92)
!181 = !DILocation(line: 0, scope: !88, inlinedAt: !92)
!182 = !DILocation(line: 238, column: 37, scope: !183, inlinedAt: !85)
!183 = distinct !DILexicalBlock(scope: !83, file: !11, line: 235, column: 9)
!184 = !DILocation(line: 238, column: 18, scope: !183, inlinedAt: !85)
!185 = !DILocation(line: 240, column: 12, scope: !183, inlinedAt: !85)
!186 = !DILocation(line: 241, column: 16, scope: !183, inlinedAt: !85)
!187 = !DILocation(line: 1090, column: 5, scope: !40, inlinedAt: !188)
!188 = distinct !DILocation(line: 1587, column: 8, scope: !189, inlinedAt: !190)
!189 = distinct !DISubprogram(name: "min<usize>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3cmp3minjECs68MIsFmw01O_12evidence_lab", scope: !43, file: !41, line: 1586, type: !17, scopeLine: 1586, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !18)
!190 = distinct !DILocation(line: 258, column: 36, scope: !83, inlinedAt: !85)
!191 = !DILocation(line: 286, column: 14, scope: !192, inlinedAt: !194)
!192 = distinct !DISubprogram(name: "new_unsorted", linkageName: "_RNvMNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6stable5driftNtB2_12DriftsortRun12new_unsorted", scope: !193, file: !11, line: 285, type: !17, scopeLine: 285, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !18)
!193 = !DINamespace(name: "DriftsortRun", scope: !12)
!194 = distinct !DILocation(line: 258, column: 9, scope: !83, inlinedAt: !85)
!195 = !DILocation(line: 249, column: 5, scope: !83, inlinedAt: !85)
!196 = !DILocation(line: 1090, column: 5, scope: !40, inlinedAt: !197)
!197 = distinct !DILocation(line: 1587, column: 8, scope: !189, inlinedAt: !198)
!198 = distinct !DILocation(line: 254, column: 29, scope: !83, inlinedAt: !85)
!199 = !DILocation(line: 255, column: 9, scope: !200, inlinedAt: !85)
!200 = distinct !DILexicalBlock(scope: !83, file: !11, line: 254, column: 9)
!201 = !DILocation(line: 281, column: 14, scope: !202, inlinedAt: !203)
!202 = distinct !DISubprogram(name: "new_sorted", linkageName: "_RNvMNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6stable5driftNtB2_12DriftsortRun10new_sorted", scope: !193, file: !11, line: 280, type: !17, scopeLine: 280, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !18)
!203 = distinct !DILocation(line: 256, column: 9, scope: !200, inlinedAt: !85)
!204 = !DILocation(line: 281, column: 14, scope: !202, inlinedAt: !205)
!205 = distinct !DILocation(line: 245, column: 20, scope: !183, inlinedAt: !85)
!206 = !DILocation(line: 260, column: 2, scope: !84, inlinedAt: !85)
!207 = !DILocation(line: 978, column: 24, scope: !208, inlinedAt: !209)
!208 = distinct !DISubprogram(name: "reverse<f64>", linkageName: "_RNvMNtCsjIpoRzUjyHQ_4core5sliceSd7reverseCs68MIsFmw01O_12evidence_lab", scope: !99, file: !98, line: 977, type: !17, scopeLine: 977, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !18)
!209 = distinct !DILocation(line: 242, column: 30, scope: !183, inlinedAt: !85)
!210 = !{!211}
!211 = distinct !{!211, !212, !"_RINvNvMNtCsjIpoRzUjyHQ_4core5sliceSp7reverse7revswapdECs68MIsFmw01O_12evidence_lab: %a.0"}
!212 = distinct !{!212, !"_RINvNvMNtCsjIpoRzUjyHQ_4core5sliceSp7reverse7revswapdECs68MIsFmw01O_12evidence_lab"}
!213 = !DILocation(line: 997, column: 9, scope: !214, inlinedAt: !209)
!214 = distinct !DILexicalBlock(scope: !215, file: !98, line: 983, column: 9)
!215 = distinct !DILexicalBlock(scope: !216, file: !98, line: 979, column: 9)
!216 = distinct !DILexicalBlock(scope: !208, file: !98, line: 978, column: 9)
!217 = !{!218}
!218 = distinct !{!218, !212, !"_RINvNvMNtCsjIpoRzUjyHQ_4core5sliceSp7reverse7revswapdECs68MIsFmw01O_12evidence_lab: %b.0"}
!219 = !DILocation(line: 1013, column: 19, scope: !220, inlinedAt: !225)
!220 = distinct !DILexicalBlock(scope: !221, file: !98, line: 1012, column: 13)
!221 = distinct !DILexicalBlock(scope: !222, file: !98, line: 1010, column: 13)
!222 = distinct !DILexicalBlock(scope: !223, file: !98, line: 1009, column: 13)
!223 = distinct !DISubprogram(name: "revswap<f64>", linkageName: "_RINvNvMNtCsjIpoRzUjyHQ_4core5sliceSp7reverse7revswapdECs68MIsFmw01O_12evidence_lab", scope: !224, file: !98, line: 1000, type: !17, scopeLine: 1000, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !18)
!224 = !DINamespace(name: "reverse", scope: !99)
!225 = distinct !DILocation(line: 997, column: 9, scope: !214, inlinedAt: !209)
!226 = !DILocation(line: 970, column: 18, scope: !227, inlinedAt: !232)
!227 = distinct !DISubprogram(name: "add<f64>", linkageName: "_RNvMNtNtCsjIpoRzUjyHQ_4core3ptr7mut_ptrOd3addCs68MIsFmw01O_12evidence_lab", scope: !229, file: !228, line: 936, type: !17, scopeLine: 936, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !18)
!228 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/ptr/mut_ptr.rs", directory: "", checksumkind: CSK_MD5, checksum: "0a9a444e8d978ea2fd7622da49f95724")
!229 = !DINamespace(name: "{impl#0}", scope: !230)
!230 = !DINamespace(name: "mut_ptr", scope: !231)
!231 = !DINamespace(name: "ptr", scope: !16)
!232 = distinct !DILocation(line: 842, column: 34, scope: !233, inlinedAt: !235)
!233 = distinct !DILexicalBlock(scope: !234, file: !98, line: 840, column: 9)
!234 = distinct !DISubprogram(name: "as_mut_ptr_range<f64>", linkageName: "_RNvMNtCsjIpoRzUjyHQ_4core5sliceSd16as_mut_ptr_rangeCs68MIsFmw01O_12evidence_lab", scope: !99, file: !98, line: 839, type: !17, scopeLine: 839, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !18)
!235 = distinct !DILocation(line: 979, column: 41, scope: !216, inlinedAt: !209)
!236 = !DILocation(line: 1014, column: 43, scope: !220, inlinedAt: !225)
!237 = !DILocation(line: 1015, column: 17, scope: !220, inlinedAt: !225)
!238 = !DILocation(line: 1014, column: 45, scope: !220, inlinedAt: !225)
!239 = !DILocation(line: 1014, column: 27, scope: !220, inlinedAt: !225)
!240 = !DILocation(line: 1014, column: 38, scope: !220, inlinedAt: !225)
!241 = !DILocation(line: 833, column: 14, scope: !242, inlinedAt: !245)
!242 = distinct !DISubprogram(name: "swap<f64>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3mem4swapdECs68MIsFmw01O_12evidence_lab", scope: !244, file: !243, line: 830, type: !17, scopeLine: 830, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !18)
!243 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/mem/mod.rs", directory: "", checksumkind: CSK_MD5, checksum: "1dbabb11724cf003c9a4ded983e1d0cd")
!244 = !DINamespace(name: "mem", scope: !16)
!245 = distinct !DILocation(line: 1014, column: 17, scope: !220, inlinedAt: !225)
!246 = !{!211, !247, !104}
!247 = distinct !{!247, !248, !"_RNvMNtCsjIpoRzUjyHQ_4core5sliceSd7reverseCs68MIsFmw01O_12evidence_lab: %self.0"}
!248 = distinct !{!248, !"_RNvMNtCsjIpoRzUjyHQ_4core5sliceSd7reverseCs68MIsFmw01O_12evidence_lab"}
!249 = !{!218, !107, !108}
!250 = !{!218, !247, !104}
!251 = !{!211, !107, !108}
!252 = distinct !{!252, !253, !254}
!253 = !{!"llvm.loop.isvectorized", i32 1}
!254 = !{!"llvm.loop.unroll.runtime.disable"}
!255 = distinct !{!255, !254, !253}
!256 = !DILocation(line: 0, scope: !83, inlinedAt: !85)
!257 = !DILocation(line: 296, column: 9, scope: !258, inlinedAt: !259)
!258 = distinct !DISubprogram(name: "len", linkageName: "_RNvMNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6stable5driftNtB2_12DriftsortRun3len", scope: !193, file: !11, line: 295, type: !17, scopeLine: 295, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !18)
!259 = !DILocation(line: 66, column: 37, scope: !64)
!260 = !DILocation(line: 296, column: 9, scope: !258, inlinedAt: !261)
!261 = !DILocation(line: 68, column: 37, scope: !64)
!262 = !DILocation(line: 168, column: 13, scope: !263, inlinedAt: !264)
!263 = distinct !DISubprogram(name: "merge_tree_depth", linkageName: "_RNvNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6stable5drift16merge_tree_depth", scope: !12, file: !11, line: 167, type: !17, scopeLine: 167, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !18)
!264 = !DILocation(line: 65, column: 29, scope: !64)
!265 = !DILocation(line: 169, column: 13, scope: !266, inlinedAt: !264)
!266 = distinct !DILexicalBlock(scope: !263, file: !11, line: 168, column: 5)
!267 = !DILocation(line: 170, column: 6, scope: !268, inlinedAt: !264)
!268 = distinct !DILexicalBlock(scope: !266, file: !11, line: 169, column: 5)
!269 = !DILocation(line: 170, column: 27, scope: !268, inlinedAt: !264)
!270 = !DILocation(line: 170, column: 5, scope: !268, inlinedAt: !264)
!271 = !DILocation(line: 154, column: 20, scope: !272, inlinedAt: !273)
!272 = distinct !DISubprogram(name: "leading_zeros", linkageName: "_RNvMs7_NtCsjIpoRzUjyHQ_4core3numy13leading_zeros", scope: !25, file: !24, line: 153, type: !17, scopeLine: 153, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !18)
!273 = !DILocation(line: 170, column: 47, scope: !268, inlinedAt: !264)
!274 = !DILocation(line: 62, column: 9, scope: !64)
!275 = !DILocation(line: 87, column: 56, scope: !64)
!276 = !DILocation(line: 970, column: 18, scope: !277, inlinedAt: !278)
!277 = distinct !DISubprogram(name: "add<u8>", linkageName: "_RNvMNtNtCsjIpoRzUjyHQ_4core3ptr7mut_ptrOh3addCs68MIsFmw01O_12evidence_lab", scope: !229, file: !228, line: 936, type: !17, scopeLine: 936, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !18)
!278 = !DILocation(line: 87, column: 52, scope: !64)
!279 = !DILocation(line: 970, column: 18, scope: !280, inlinedAt: !281)
!280 = distinct !DISubprogram(name: "add<core::slice::sort::stable::drift::DriftsortRun>", linkageName: "_RNvMNtNtCsjIpoRzUjyHQ_4core3ptr7mut_ptrONtNtNtNtNtB6_5slice4sort6stable5drift12DriftsortRun3addCs68MIsFmw01O_12evidence_lab", scope: !229, file: !228, line: 936, type: !17, scopeLine: 936, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !18)
!281 = !DILocation(line: 103, column: 19, scope: !64)
!282 = !DILocation(line: 103, column: 13, scope: !64)
!283 = !DILocation(line: 970, column: 18, scope: !277, inlinedAt: !284)
!284 = !DILocation(line: 104, column: 29, scope: !64)
!285 = !DILocation(line: 104, column: 13, scope: !64)
!286 = !DILocation(line: 109, column: 12, scope: !64)
!287 = !DILocation(line: 970, column: 18, scope: !280, inlinedAt: !288)
!288 = !DILocation(line: 90, column: 34, scope: !64)
!289 = !DILocation(line: 90, column: 28, scope: !64)
!290 = !DILocation(line: 296, column: 9, scope: !258, inlinedAt: !291)
!291 = !DILocation(line: 91, column: 39, scope: !292)
!292 = distinct !DILexicalBlock(scope: !64, file: !11, line: 90, column: 17)
!293 = !DILocation(line: 296, column: 9, scope: !258, inlinedAt: !294)
!294 = !DILocation(line: 91, column: 56, scope: !292)
!295 = !DILocation(line: 91, column: 34, scope: !292)
!296 = !DILocation(line: 92, column: 39, scope: !297)
!297 = distinct !DILexicalBlock(scope: !292, file: !11, line: 91, column: 17)
!298 = !DILocation(line: 102, column: 24, scope: !299, inlinedAt: !300)
!299 = distinct !DILexicalBlock(scope: !79, file: !70, line: 100, column: 5)
!300 = !DILocation(line: 400, column: 13, scope: !301, inlinedAt: !304)
!301 = distinct !DILexicalBlock(scope: !302, file: !70, line: 399, column: 13)
!302 = distinct !DISubprogram(name: "get_unchecked_mut<f64>", linkageName: "_RNvXs2_NtNtCsjIpoRzUjyHQ_4core5slice5indexINtNtNtB9_3ops5range5RangejEINtB5_10SliceIndexSdE17get_unchecked_mutCs68MIsFmw01O_12evidence_lab", scope: !303, file: !70, line: 387, type: !17, scopeLine: 387, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !18)
!303 = !DINamespace(name: "{impl#4}", scope: !72)
!304 = !DILocation(line: 693, column: 30, scope: !305, inlinedAt: !306)
!305 = distinct !DISubprogram(name: "get_unchecked_mut<f64, core::ops::range::Range<usize>>", linkageName: "_RINvMNtCsjIpoRzUjyHQ_4core5sliceSd17get_unchecked_mutINtNtNtB5_3ops5range5RangejEECs68MIsFmw01O_12evidence_lab", scope: !99, file: !98, line: 686, type: !17, scopeLine: 686, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !18)
!306 = !DILocation(line: 93, column: 37, scope: !307)
!307 = distinct !DILexicalBlock(scope: !297, file: !11, line: 92, column: 17)
!308 = !DILocation(line: 203, column: 30, scope: !309, inlinedAt: !311)
!309 = distinct !DILexicalBlock(scope: !310, file: !11, line: 202, column: 5)
!310 = distinct !DISubprogram(name: "logical_merge<f64, alloc::slice::{impl#0}::sort_by::{closure_env#0}<f64, fn(&f64, &f64) -> core::cmp::Ordering>>", linkageName: "_RINvNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6stable5drift13logical_mergedNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtBa_3f64d9total_cmpE0ECs68MIsFmw01O_12evidence_lab", scope: !12, file: !11, line: 191, type: !17, scopeLine: 191, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !18)
!311 = distinct !DILocation(line: 94, column: 28, scope: !312)
!312 = distinct !DILexicalBlock(scope: !307, file: !11, line: 93, column: 17)
!313 = !DILocation(line: 204, column: 9, scope: !314, inlinedAt: !311)
!314 = distinct !DILexicalBlock(scope: !309, file: !11, line: 203, column: 5)
!315 = !DILocation(line: 205, column: 13, scope: !314, inlinedAt: !311)
!316 = !DILocation(line: 286, column: 14, scope: !317, inlinedAt: !318)
!317 = distinct !DISubprogram(name: "new_unsorted", linkageName: "_RNvMNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6stable5driftNtB2_12DriftsortRun12new_unsorted", scope: !193, file: !11, line: 285, type: !17, scopeLine: 285, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !18)
!318 = distinct !DILocation(line: 215, column: 9, scope: !314, inlinedAt: !311)
!319 = !DILocation(line: 204, column: 5, scope: !314, inlinedAt: !311)
!320 = !DILocation(line: 208, column: 13, scope: !314, inlinedAt: !311)
!321 = !DILocation(line: 269, column: 21, scope: !322, inlinedAt: !323)
!322 = distinct !DISubprogram(name: "stable_quicksort<f64, alloc::slice::{impl#0}::sort_by::{closure_env#0}<f64, fn(&f64, &f64) -> core::cmp::Ordering>>", linkageName: "_RINvNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6stable5drift16stable_quicksortdNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtBa_3f64d9total_cmpE0ECs68MIsFmw01O_12evidence_lab", scope: !12, file: !11, line: 262, type: !17, scopeLine: 262, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !18)
!323 = distinct !DILocation(line: 206, column: 13, scope: !314, inlinedAt: !311)
!324 = !DILocation(line: 598, column: 21, scope: !325, inlinedAt: !329)
!325 = distinct !DISubprogram(name: "leading_zeros", linkageName: "_RNvMs1f_NtNtCsjIpoRzUjyHQ_4core3num7nonzeroINtB6_7NonZerojE13leading_zeros", scope: !327, file: !326, line: 595, type: !17, scopeLine: 595, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !18)
!326 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/num/nonzero.rs", directory: "", checksumkind: CSK_MD5, checksum: "44bb353b0937e2f0482f1c13974302f1")
!327 = !DINamespace(name: "NonZero", scope: !328)
!328 = !DINamespace(name: "nonzero", scope: !26)
!329 = distinct !DILocation(line: 1802, column: 35, scope: !330, inlinedAt: !331)
!330 = distinct !DISubprogram(name: "ilog2", linkageName: "_RNvMs1f_NtNtCsjIpoRzUjyHQ_4core3num7nonzeroINtB6_7NonZerojE5ilog2", scope: !327, file: !326, line: 1801, type: !17, scopeLine: 1801, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !18)
!331 = distinct !DILocation(line: 1933, column: 35, scope: !332, inlinedAt: !335)
!332 = distinct !DILexicalBlock(scope: !333, file: !24, line: 1933, column: 17)
!333 = distinct !DISubprogram(name: "checked_ilog2", linkageName: "_RNvMs9_NtCsjIpoRzUjyHQ_4core3numj13checked_ilog2", scope: !334, file: !24, line: 1931, type: !17, scopeLine: 1931, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !18)
!334 = !DINamespace(name: "{impl#11}", scope: !26)
!335 = distinct !DILocation(line: 1809, column: 37, scope: !336, inlinedAt: !338)
!336 = distinct !DILexicalBlock(scope: !337, file: !24, line: 1809, column: 53)
!337 = distinct !DISubprogram(name: "ilog2", linkageName: "_RNvMs9_NtCsjIpoRzUjyHQ_4core3numj5ilog2", scope: !334, file: !24, line: 1808, type: !17, scopeLine: 1808, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !18)
!338 = distinct !DILocation(line: 269, column: 35, scope: !322, inlinedAt: !323)
!339 = !DILocation(line: 269, column: 17, scope: !322, inlinedAt: !323)
!340 = !DILocation(line: 270, column: 5, scope: !341, inlinedAt: !323)
!341 = distinct !DILexicalBlock(scope: !322, file: !11, line: 269, column: 5)
!342 = !DILocation(line: 205, column: 9, scope: !314, inlinedAt: !311)
!343 = !DILocation(line: 102, column: 24, scope: !344, inlinedAt: !346)
!344 = distinct !DILexicalBlock(scope: !345, file: !70, line: 100, column: 5)
!345 = distinct !DISubprogram(name: "get_offset_len_mut_noubcheck<f64>", linkageName: "_RINvNtNtCsjIpoRzUjyHQ_4core5slice5index28get_offset_len_mut_noubcheckdECs68MIsFmw01O_12evidence_lab", scope: !72, file: !70, line: 95, type: !17, scopeLine: 95, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !18)
!346 = distinct !DILocation(line: 563, column: 19, scope: !347, inlinedAt: !349)
!347 = distinct !DILexicalBlock(scope: !348, file: !70, line: 562, column: 13)
!348 = distinct !DISubprogram(name: "index_mut<f64>", linkageName: "_RNvXs5_NtNtCsjIpoRzUjyHQ_4core5slice5indexINtNtNtB9_3ops5range9RangeFromjEINtB5_10SliceIndexSdE9index_mutCs68MIsFmw01O_12evidence_lab", scope: !71, file: !70, line: 556, type: !17, scopeLine: 556, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !18)
!349 = distinct !DILocation(line: 32, column: 15, scope: !350, inlinedAt: !352)
!350 = !DILexicalBlockFile(scope: !351, file: !70, discriminator: 2)
!351 = distinct !DISubprogram(name: "index_mut<f64, core::ops::range::RangeFrom<usize>>", linkageName: "_RNvXs_NtNtCsjIpoRzUjyHQ_4core5slice5indexSdINtNtNtB8_3ops5index8IndexMutINtNtBK_5range9RangeFromjEE9index_mutCs68MIsFmw01O_12evidence_lab", scope: !75, file: !70, line: 31, type: !17, scopeLine: 31, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !18)
!352 = distinct !DILocation(line: 209, column: 36, scope: !314, inlinedAt: !311)
!353 = !DILocation(line: 269, column: 21, scope: !322, inlinedAt: !354)
!354 = distinct !DILocation(line: 209, column: 13, scope: !314, inlinedAt: !311)
!355 = !DILocation(line: 598, column: 21, scope: !325, inlinedAt: !356)
!356 = distinct !DILocation(line: 1802, column: 35, scope: !330, inlinedAt: !357)
!357 = distinct !DILocation(line: 1933, column: 35, scope: !332, inlinedAt: !358)
!358 = distinct !DILocation(line: 1809, column: 37, scope: !336, inlinedAt: !359)
!359 = distinct !DILocation(line: 269, column: 35, scope: !322, inlinedAt: !354)
!360 = !DILocation(line: 269, column: 17, scope: !322, inlinedAt: !354)
!361 = !DILocation(line: 270, column: 5, scope: !341, inlinedAt: !354)
!362 = !DILocation(line: 208, column: 9, scope: !314, inlinedAt: !311)
!363 = !{!364}
!364 = distinct !{!364, !365, !"_RINvNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6stable5merge5mergedNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtBa_3f64d9total_cmpE0ECs68MIsFmw01O_12evidence_lab: %v.0"}
!365 = distinct !{!365, !"_RINvNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6stable5merge5mergedNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtBa_3f64d9total_cmpE0ECs68MIsFmw01O_12evidence_lab"}
!366 = !DILocation(line: 211, column: 9, scope: !314, inlinedAt: !311)
!367 = !{!368}
!368 = distinct !{!368, !365, !"_RINvNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6stable5merge5mergedNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtBa_3f64d9total_cmpE0ECs68MIsFmw01O_12evidence_lab: %scratch.0"}
!369 = !DILocation(line: 16, column: 8, scope: !370, inlinedAt: !374)
!370 = distinct !DILexicalBlock(scope: !372, file: !371, line: 14, column: 5)
!371 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/slice/sort/stable/merge.rs", directory: "", checksumkind: CSK_MD5, checksum: "90afbaa2075bc1e9689ef92c7df39f20")
!372 = distinct !DISubprogram(name: "merge<f64, alloc::slice::{impl#0}::sort_by::{closure_env#0}<f64, fn(&f64, &f64) -> core::cmp::Ordering>>", linkageName: "_RINvNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6stable5merge5mergedNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtBa_3f64d9total_cmpE0ECs68MIsFmw01O_12evidence_lab", scope: !373, file: !371, line: 8, type: !17, scopeLine: 8, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !8, templateParams: !18)
!373 = !DINamespace(name: "merge", scope: !13)
!374 = distinct !DILocation(line: 211, column: 9, scope: !314, inlinedAt: !311)
!375 = !DILocation(line: 1090, column: 5, scope: !376, inlinedAt: !377)
!376 = distinct !DISubprogram(name: "min<usize>", linkageName: "_RNvYjNtNtCsjIpoRzUjyHQ_4core3cmp3Ord3minCs68MIsFmw01O_12evidence_lab", scope: !42, file: !41, line: 1085, type: !17, scopeLine: 1085, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !8, templateParams: !18)
!377 = distinct !DILocation(line: 1587, column: 8, scope: !378, inlinedAt: !379)
!378 = distinct !DISubprogram(name: "min<usize>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3cmp3minjECs68MIsFmw01O_12evidence_lab", scope: !43, file: !41, line: 1586, type: !17, scopeLine: 1586, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !8, templateParams: !18)
!379 = distinct !DILocation(line: 16, column: 50, scope: !370, inlinedAt: !374)
!380 = !DILocation(line: 16, column: 34, scope: !370, inlinedAt: !374)
!381 = !DILocation(line: 970, column: 18, scope: !382, inlinedAt: !383)
!382 = distinct !DISubprogram(name: "add<f64>", linkageName: "_RNvMNtNtCsjIpoRzUjyHQ_4core3ptr7mut_ptrOd3addCs68MIsFmw01O_12evidence_lab", scope: !229, file: !228, line: 936, type: !17, scopeLine: 936, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !8, templateParams: !18)
!383 = distinct !DILocation(line: 41, column: 28, scope: !384, inlinedAt: !374)
!384 = distinct !DILexicalBlock(scope: !385, file: !371, line: 40, column: 9)
!385 = distinct !DILexicalBlock(scope: !370, file: !371, line: 38, column: 9)
!386 = !DILocation(line: 47, column: 31, scope: !387, inlinedAt: !374)
!387 = distinct !DILexicalBlock(scope: !388, file: !371, line: 45, column: 9)
!388 = distinct !DILexicalBlock(scope: !389, file: !371, line: 44, column: 9)
!389 = distinct !DILexicalBlock(scope: !390, file: !371, line: 42, column: 9)
!390 = distinct !DILexicalBlock(scope: !384, file: !371, line: 41, column: 9)
!391 = !DILocation(line: 48, column: 28, scope: !392, inlinedAt: !374)
!392 = distinct !DILexicalBlock(scope: !387, file: !371, line: 47, column: 9)
!393 = !DILocation(line: 573, column: 14, scope: !394, inlinedAt: !396)
!394 = distinct !DISubprogram(name: "copy_nonoverlapping<f64>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3ptr19copy_nonoverlappingdECs68MIsFmw01O_12evidence_lab", scope: !231, file: !395, line: 552, type: !17, scopeLine: 552, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !8, templateParams: !18)
!395 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/ptr/mod.rs", directory: "", checksumkind: CSK_MD5, checksum: "59033ebc630da002040513c25c9de121")
!396 = distinct !DILocation(line: 51, column: 9, scope: !397, inlinedAt: !374)
!397 = distinct !DILexicalBlock(scope: !398, file: !371, line: 49, column: 9)
!398 = distinct !DILexicalBlock(scope: !392, file: !371, line: 48, column: 9)
!399 = !{!364, !368}
!400 = !DILocation(line: 970, column: 18, scope: !382, inlinedAt: !401)
!401 = distinct !DILocation(line: 53, column: 65, scope: !397, inlinedAt: !374)
!402 = !DILocation(line: 55, column: 12, scope: !403, inlinedAt: !374)
!403 = distinct !DILexicalBlock(scope: !397, file: !371, line: 53, column: 9)
!404 = !DILocation(line: 1054, column: 22, scope: !405, inlinedAt: !406)
!405 = distinct !DISubprogram(name: "sub<f64>", linkageName: "_RNvMNtNtCsjIpoRzUjyHQ_4core3ptr7mut_ptrOd3subCs68MIsFmw01O_12evidence_lab", scope: !229, file: !228, line: 1015, type: !17, scopeLine: 1015, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !8, templateParams: !18)
!406 = distinct !DILocation(line: 118, column: 37, scope: !407, inlinedAt: !409)
!407 = distinct !DISubprogram(name: "merge_down<f64, alloc::slice::{impl#0}::sort_by::{closure_env#0}<f64, fn(&f64, &f64) -> core::cmp::Ordering>>", linkageName: "_RINvMNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6stable5mergeINtB3_10MergeStatedE10merge_downNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtBb_3f64d9total_cmpE0ECs68MIsFmw01O_12evidence_lab", scope: !408, file: !371, line: 108, type: !116, scopeLine: 108, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !8, templateParams: !18)
!408 = !DINamespace(name: "MergeState", scope: !373)
!409 = distinct !DILocation(line: 58, column: 25, scope: !403, inlinedAt: !374)
!410 = !DILocation(line: 118, column: 28, scope: !407, inlinedAt: !409)
!411 = !DILocation(line: 1054, column: 22, scope: !405, inlinedAt: !412)
!412 = distinct !DILocation(line: 119, column: 38, scope: !413, inlinedAt: !409)
!413 = distinct !DILexicalBlock(scope: !407, file: !371, line: 118, column: 17)
!414 = !DILocation(line: 1054, column: 22, scope: !405, inlinedAt: !415)
!415 = distinct !DILocation(line: 120, column: 27, scope: !416, inlinedAt: !409)
!416 = distinct !DILexicalBlock(scope: !413, file: !371, line: 119, column: 17)
!417 = !DILocation(line: 122, column: 36, scope: !416, inlinedAt: !409)
!418 = !{!419, !364}
!419 = distinct !{!419, !420, !"_RINvMNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6stable5mergeINtB3_10MergeStatedE10merge_downNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtBb_3f64d9total_cmpE0ECs68MIsFmw01O_12evidence_lab: %self"}
!420 = distinct !{!420, !"_RINvMNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6stable5mergeINtB3_10MergeStatedE10merge_downNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtBb_3f64d9total_cmpE0ECs68MIsFmw01O_12evidence_lab"}
!421 = !{!419, !368}
!422 = !DILocation(line: 1547, column: 19, scope: !423, inlinedAt: !426)
!423 = distinct !DILexicalBlock(scope: !424, file: !111, line: 1523, column: 9)
!424 = distinct !DILexicalBlock(scope: !425, file: !111, line: 1522, column: 9)
!425 = distinct !DISubprogram(name: "total_cmp", linkageName: "_RNvMNtCsjIpoRzUjyHQ_4core3f64d9total_cmp", scope: !114, file: !111, line: 1521, type: !116, scopeLine: 1521, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !8, templateParams: !18)
!426 = distinct !DILocation(line: 166, column: 5, scope: !427, inlinedAt: !428)
!427 = distinct !DISubprogram(name: "call_mut<fn(&f64, &f64) -> core::cmp::Ordering, (&f64, &f64)>", linkageName: "_RNvYNvMNtCsjIpoRzUjyHQ_4core3f64d9total_cmpINtNtNtB7_3ops8function5FnMutTRdB19_EE8call_mutCs68MIsFmw01O_12evidence_lab", scope: !120, file: !119, line: 166, type: !116, scopeLine: 166, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !8, templateParams: !18)
!428 = distinct !DILocation(line: 196, column: 34, scope: !429, inlinedAt: !430)
!429 = distinct !DISubprogram(name: "{closure#0}<f64, fn(&f64, &f64) -> core::cmp::Ordering>", linkageName: "_RNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtCsjIpoRzUjyHQ_4core3f64d9total_cmpE0Cs68MIsFmw01O_12evidence_lab", scope: !126, file: !125, line: 196, type: !116, scopeLine: 196, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !8, templateParams: !18)
!430 = distinct !DILocation(line: 122, column: 36, scope: !416, inlinedAt: !409)
!431 = !DILocation(line: 1547, column: 17, scope: !423, inlinedAt: !426)
!432 = !DILocation(line: 1547, column: 9, scope: !423, inlinedAt: !426)
!433 = !DILocation(line: 1548, column: 20, scope: !423, inlinedAt: !426)
!434 = !DILocation(line: 1548, column: 18, scope: !423, inlinedAt: !426)
!435 = !DILocation(line: 1548, column: 9, scope: !423, inlinedAt: !426)
!436 = !DILocation(line: 410, column: 44, scope: !437, inlinedAt: !440)
!437 = distinct !DILexicalBlock(scope: !438, file: !41, line: 410, column: 44)
!438 = distinct !DILexicalBlock(scope: !439, file: !41, line: 410, column: 44)
!439 = distinct !DISubprogram(name: "eq", linkageName: "_RNvXsb_NtCsjIpoRzUjyHQ_4core3cmpNtB5_8OrderingNtB5_9PartialEq2eq", scope: !140, file: !41, line: 410, type: !17, scopeLine: 410, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !8, templateParams: !18)
!440 = distinct !DILocation(line: 196, column: 34, scope: !429, inlinedAt: !430)
!441 = !DILocation(line: 124, column: 27, scope: !442, inlinedAt: !409)
!442 = distinct !DILexicalBlock(scope: !416, file: !371, line: 122, column: 17)
!443 = !DILocation(line: 573, column: 14, scope: !444, inlinedAt: !445)
!444 = distinct !DISubprogram(name: "copy_nonoverlapping<f64>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3ptr19copy_nonoverlappingdECs68MIsFmw01O_12evidence_lab", scope: !231, file: !395, line: 552, type: !17, scopeLine: 552, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !8, templateParams: !18)
!445 = distinct !DILocation(line: 125, column: 17, scope: !446, inlinedAt: !409)
!446 = distinct !DILexicalBlock(scope: !442, file: !371, line: 124, column: 17)
!447 = !DILocation(line: 127, column: 37, scope: !446, inlinedAt: !409)
!448 = !DILocation(line: 970, column: 18, scope: !449, inlinedAt: !450)
!449 = distinct !DISubprogram(name: "add<f64>", linkageName: "_RNvMNtNtCsjIpoRzUjyHQ_4core3ptr7mut_ptrOd3addCs68MIsFmw01O_12evidence_lab", scope: !229, file: !228, line: 936, type: !17, scopeLine: 936, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !8, templateParams: !18)
!450 = distinct !DILocation(line: 127, column: 33, scope: !446, inlinedAt: !409)
!451 = !DILocation(line: 128, column: 38, scope: !446, inlinedAt: !409)
!452 = !DILocation(line: 970, column: 18, scope: !449, inlinedAt: !453)
!453 = distinct !DILocation(line: 128, column: 34, scope: !446, inlinedAt: !409)
!454 = !DILocation(line: 130, column: 20, scope: !446, inlinedAt: !409)
!455 = !DILocation(line: 90, column: 37, scope: !456, inlinedAt: !459)
!456 = distinct !DILexicalBlock(scope: !457, file: !371, line: 87, column: 13)
!457 = distinct !DILexicalBlock(scope: !458, file: !371, line: 86, column: 13)
!458 = distinct !DISubprogram(name: "merge_up<f64, alloc::slice::{impl#0}::sort_by::{closure_env#0}<f64, fn(&f64, &f64) -> core::cmp::Ordering>>", linkageName: "_RINvMNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6stable5mergeINtB3_10MergeStatedE8merge_upNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtBb_3f64d9total_cmpE0ECs68MIsFmw01O_12evidence_lab", scope: !408, file: !371, line: 78, type: !116, scopeLine: 78, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !8, templateParams: !18)
!459 = distinct !DILocation(line: 56, column: 25, scope: !403, inlinedAt: !374)
!460 = !{!461, !368}
!461 = distinct !{!461, !462, !"_RINvMNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6stable5mergeINtB3_10MergeStatedE8merge_upNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtBb_3f64d9total_cmpE0ECs68MIsFmw01O_12evidence_lab: %self"}
!462 = distinct !{!462, !"_RINvMNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6stable5mergeINtB3_10MergeStatedE8merge_upNCINvMNtCs6zY7rJBZy9D_5alloc5sliceSd7sort_byNvMNtBb_3f64d9total_cmpE0ECs68MIsFmw01O_12evidence_lab"}
!463 = !{!461, !364}
!464 = !DILocation(line: 1547, column: 19, scope: !423, inlinedAt: !465)
!465 = distinct !DILocation(line: 166, column: 5, scope: !427, inlinedAt: !466)
!466 = distinct !DILocation(line: 196, column: 34, scope: !429, inlinedAt: !467)
!467 = distinct !DILocation(line: 90, column: 37, scope: !456, inlinedAt: !459)
!468 = !DILocation(line: 1547, column: 17, scope: !423, inlinedAt: !465)
!469 = !DILocation(line: 1547, column: 9, scope: !423, inlinedAt: !465)
!470 = !DILocation(line: 1548, column: 20, scope: !423, inlinedAt: !465)
!471 = !DILocation(line: 1548, column: 18, scope: !423, inlinedAt: !465)
!472 = !DILocation(line: 1548, column: 9, scope: !423, inlinedAt: !465)
!473 = !DILocation(line: 410, column: 44, scope: !437, inlinedAt: !474)
!474 = distinct !DILocation(line: 196, column: 34, scope: !429, inlinedAt: !467)
!475 = !DILocation(line: 90, column: 36, scope: !456, inlinedAt: !459)
!476 = !DILocation(line: 92, column: 30, scope: !477, inlinedAt: !459)
!477 = distinct !DILexicalBlock(scope: !456, file: !371, line: 90, column: 17)
!478 = !DILocation(line: 573, column: 14, scope: !479, inlinedAt: !480)
!479 = distinct !DISubprogram(name: "copy_nonoverlapping<f64>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3ptr19copy_nonoverlappingdECs68MIsFmw01O_12evidence_lab", scope: !231, file: !395, line: 552, type: !17, scopeLine: 552, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !8, templateParams: !18)
!480 = distinct !DILocation(line: 93, column: 17, scope: !481, inlinedAt: !459)
!481 = distinct !DILexicalBlock(scope: !477, file: !371, line: 92, column: 17)
!482 = !DILocation(line: 95, column: 34, scope: !481, inlinedAt: !459)
!483 = !DILocation(line: 970, column: 18, scope: !484, inlinedAt: !485)
!484 = distinct !DISubprogram(name: "add<f64>", linkageName: "_RNvMNtNtCsjIpoRzUjyHQ_4core3ptr7mut_ptrOd3addCs68MIsFmw01O_12evidence_lab", scope: !229, file: !228, line: 936, type: !17, scopeLine: 936, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !8, templateParams: !18)
!485 = distinct !DILocation(line: 95, column: 30, scope: !481, inlinedAt: !459)
!486 = !DILocation(line: 96, column: 35, scope: !481, inlinedAt: !459)
!487 = !DILocation(line: 871, column: 18, scope: !488, inlinedAt: !492)
!488 = distinct !DISubprogram(name: "add<f64>", linkageName: "_RNvMNtNtCsjIpoRzUjyHQ_4core3ptr9const_ptrPd3addCs68MIsFmw01O_12evidence_lab", scope: !490, file: !489, line: 837, type: !17, scopeLine: 837, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !8, templateParams: !18)
!489 = !DIFile(filename: "/Users/juanwang/.rustup/toolchains/stable-aarch64-apple-darwin/lib/rustlib/src/rust/library/core/src/ptr/const_ptr.rs", directory: "", checksumkind: CSK_MD5, checksum: "25118ae25e729b7c815218b31622724c")
!490 = !DINamespace(name: "{impl#0}", scope: !491)
!491 = !DINamespace(name: "const_ptr", scope: !231)
!492 = distinct !DILocation(line: 96, column: 31, scope: !481, inlinedAt: !459)
!493 = !DILocation(line: 970, column: 18, scope: !484, inlinedAt: !494)
!494 = distinct !DILocation(line: 98, column: 28, scope: !481, inlinedAt: !459)
!495 = !DILocation(line: 89, column: 19, scope: !456, inlinedAt: !459)
!496 = !DILocation(line: 0, scope: !403, inlinedAt: !374)
!497 = !DILocation(line: 0, scope: !397, inlinedAt: !374)
!498 = !DILocation(line: 733, column: 18, scope: !499, inlinedAt: !501)
!499 = distinct !DILexicalBlock(scope: !500, file: !489, line: 730, column: 9)
!500 = distinct !DISubprogram(name: "offset_from_unsigned<f64>", linkageName: "_RNvMNtNtCsjIpoRzUjyHQ_4core3ptr9const_ptrPd20offset_from_unsignedCs68MIsFmw01O_12evidence_lab", scope: !490, file: !489, line: 705, type: !17, scopeLine: 705, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !8, templateParams: !18)
!501 = distinct !DILocation(line: 892, column: 37, scope: !502, inlinedAt: !503)
!502 = distinct !DISubprogram(name: "offset_from_unsigned<f64>", linkageName: "_RNvMNtNtCsjIpoRzUjyHQ_4core3ptr7mut_ptrOd20offset_from_unsignedCs68MIsFmw01O_12evidence_lab", scope: !229, file: !228, line: 887, type: !17, scopeLine: 887, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !8, templateParams: !18)
!503 = distinct !DILocation(line: 146, column: 32, scope: !504, inlinedAt: !506)
!504 = distinct !DISubprogram(name: "drop<f64>", linkageName: "_RNvXs_NtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6stable5mergeINtB4_10MergeStatedENtNtNtBc_3ops4drop4Drop4dropCs68MIsFmw01O_12evidence_lab", scope: !505, file: !371, line: 139, type: !17, scopeLine: 139, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !8, templateParams: !18)
!505 = !DINamespace(name: "{impl#1}", scope: !373)
!506 = distinct !DILocation(line: 847, column: 1, scope: !507, inlinedAt: !508)
!507 = distinct !DISubprogram(name: "drop_glue<core::slice::sort::stable::merge::MergeState<f64>>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtNtNtB4_5slice4sort6stable5merge10MergeStatedEECs68MIsFmw01O_12evidence_lab", scope: !231, file: !395, line: 847, type: !17, scopeLine: 847, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !8, templateParams: !18)
!508 = distinct !DILocation(line: 62, column: 5, scope: !397, inlinedAt: !374)
!509 = !DILocation(line: 573, column: 14, scope: !510, inlinedAt: !511)
!510 = distinct !DISubprogram(name: "copy_nonoverlapping<f64>", linkageName: "_RINvNtCsjIpoRzUjyHQ_4core3ptr19copy_nonoverlappingdECs68MIsFmw01O_12evidence_lab", scope: !231, file: !395, line: 552, type: !17, scopeLine: 552, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !8, templateParams: !18)
!511 = distinct !DILocation(line: 147, column: 13, scope: !512, inlinedAt: !506)
!512 = distinct !DILexicalBlock(scope: !504, file: !371, line: 146, column: 13)
!513 = !{!514, !516}
!514 = distinct !{!514, !515, !"_RNvXs_NtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6stable5mergeINtB4_10MergeStatedENtNtNtBc_3ops4drop4Drop4dropCs68MIsFmw01O_12evidence_lab: %self"}
!515 = distinct !{!515, !"_RNvXs_NtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6stable5mergeINtB4_10MergeStatedENtNtNtBc_3ops4drop4Drop4dropCs68MIsFmw01O_12evidence_lab"}
!516 = distinct !{!516, !517, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtNtNtB4_5slice4sort6stable5merge10MergeStatedEECs68MIsFmw01O_12evidence_lab: %_1"}
!517 = distinct !{!517, !"_RINvNtCsjIpoRzUjyHQ_4core3ptr9drop_glueINtNtNtNtNtB4_5slice4sort6stable5merge10MergeStatedEECs68MIsFmw01O_12evidence_lab"}
!518 = !DILocation(line: 63, column: 2, scope: !372, inlinedAt: !374)
!519 = !DILocation(line: 281, column: 14, scope: !520, inlinedAt: !521)
!520 = distinct !DISubprogram(name: "new_sorted", linkageName: "_RNvMNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6stable5driftNtB2_12DriftsortRun10new_sorted", scope: !193, file: !11, line: 280, type: !17, scopeLine: 280, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !18)
!521 = distinct !DILocation(line: 213, column: 9, scope: !314, inlinedAt: !311)
!522 = !DILocation(line: 0, scope: !314, inlinedAt: !311)
!523 = !DILocation(line: 105, column: 13, scope: !64)
!524 = !DILocation(line: 296, column: 9, scope: !258, inlinedAt: !525)
!525 = !DILocation(line: 113, column: 30, scope: !64)
!526 = !DILocation(line: 113, column: 9, scope: !64)
!527 = !DILocation(line: 291, column: 9, scope: !528, inlinedAt: !529)
!528 = distinct !DISubprogram(name: "sorted", linkageName: "_RNvMNtNtNtNtCsjIpoRzUjyHQ_4core5slice4sort6stable5driftNtB2_12DriftsortRun6sorted", scope: !193, file: !11, line: 290, type: !17, scopeLine: 290, flags: DIFlagPrototyped, spFlags: DISPFlagLocalToUnit | DISPFlagDefinition | DISPFlagOptimized, unit: !6, templateParams: !18)
!529 = !DILocation(line: 117, column: 18, scope: !56)
!530 = !DILocation(line: 117, column: 9, scope: !56)
!531 = !DILocation(line: 269, column: 21, scope: !322, inlinedAt: !532)
!532 = distinct !DILocation(line: 118, column: 9, scope: !56)
!533 = !DILocation(line: 598, column: 21, scope: !325, inlinedAt: !534)
!534 = distinct !DILocation(line: 1802, column: 35, scope: !330, inlinedAt: !535)
!535 = distinct !DILocation(line: 1933, column: 35, scope: !332, inlinedAt: !536)
!536 = distinct !DILocation(line: 1809, column: 37, scope: !336, inlinedAt: !537)
!537 = distinct !DILocation(line: 269, column: 35, scope: !322, inlinedAt: !532)
!538 = !DILocation(line: 269, column: 17, scope: !322, inlinedAt: !532)
!539 = !DILocation(line: 270, column: 5, scope: !341, inlinedAt: !532)
!540 = !DILocation(line: 118, column: 9, scope: !56)
!541 = !DILocation(line: 120, column: 1, scope: !53)
!542 = !DILocation(line: 120, column: 1, scope: !50)
!543 = !DILocation(line: 120, column: 2, scope: !10)
