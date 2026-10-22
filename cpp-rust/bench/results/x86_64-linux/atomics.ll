; ModuleID = 'atomics.160c9ef2bcbf9454-cgu.0'
source_filename = "atomics.160c9ef2bcbf9454-cgu.0"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-i128:128-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

; Function Attrs: mustprogress norecurse nounwind nonlazybind willreturn memory(argmem: readwrite) uwtable
define void @add_relaxed(ptr nofree noundef nonnull align 8 captures(none) %a, i64 noundef %v) unnamed_addr #0 !guid !4 {
start:
  %_3 = atomicrmw add ptr %a, i64 %v monotonic, align 8
  ret void
}

; Function Attrs: mustprogress norecurse nounwind nonlazybind willreturn memory(argmem: readwrite) uwtable
define noundef i64 @add_return_old(ptr nofree noundef nonnull align 8 captures(none) %a, i64 noundef %v) unnamed_addr #0 !guid !5 {
start:
  %_0 = atomicrmw add ptr %a, i64 %v monotonic, align 8
  ret i64 %_0
}

; Function Attrs: mustprogress norecurse nounwind nonlazybind willreturn uwtable
define void @add_seqcst(ptr nofree noundef nonnull align 8 captures(none) %a, i64 noundef %v) unnamed_addr #1 !guid !6 {
start:
  %_3 = atomicrmw add ptr %a, i64 %v seq_cst, align 8
  ret void
}

; Function Attrs: mustprogress norecurse nounwind nonlazybind willreturn uwtable
define noundef i64 @load_acquire(ptr nofree noundef nonnull align 8 captures(none) %a) unnamed_addr #1 personality ptr @rust_eh_personality !guid !7 {
bb1:
  %0 = load atomic i64, ptr %a acquire, align 8
  ret i64 %0
}

; Function Attrs: mustprogress norecurse nounwind nonlazybind willreturn memory(argmem: readwrite) uwtable
define noundef i64 @load_relaxed(ptr nofree noundef nonnull align 8 captures(none) %a) unnamed_addr #0 personality ptr @rust_eh_personality !guid !8 {
bb1:
  %0 = load atomic i64, ptr %a monotonic, align 8
  ret i64 %0
}

; Function Attrs: mustprogress norecurse nounwind nonlazybind willreturn uwtable
define noundef i64 @load_seqcst(ptr nofree noundef nonnull align 8 captures(none) %a) unnamed_addr #1 personality ptr @rust_eh_personality !guid !9 {
bb1:
  %0 = load atomic i64, ptr %a seq_cst, align 8
  ret i64 %0
}

; Function Attrs: mustprogress norecurse nounwind nonlazybind willreturn memory(argmem: readwrite) uwtable
define void @store_relaxed(ptr nofree noundef nonnull align 8 captures(none) %a, i64 noundef %v) unnamed_addr #0 personality ptr @rust_eh_personality !guid !10 {
bb1:
  store atomic i64 %v, ptr %a monotonic, align 8
  ret void
}

; Function Attrs: mustprogress norecurse nounwind nonlazybind willreturn uwtable
define void @store_release(ptr nofree noundef nonnull align 8 captures(none) %a, i64 noundef %v) unnamed_addr #1 personality ptr @rust_eh_personality !guid !11 {
bb1:
  store atomic i64 %v, ptr %a release, align 8
  ret void
}

; Function Attrs: mustprogress norecurse nounwind nonlazybind willreturn uwtable
define void @store_seqcst(ptr nofree noundef nonnull align 8 captures(none) %a, i64 noundef %v) unnamed_addr #1 personality ptr @rust_eh_personality !guid !12 {
bb1:
  store atomic i64 %v, ptr %a seq_cst, align 8
  ret void
}

; Function Attrs: nounwind nonlazybind uwtable
declare noundef range(i32 0, 10) i32 @rust_eh_personality(i32 noundef, i32 noundef, i64 noundef, ptr noundef, ptr noundef) unnamed_addr #2

attributes #0 = { mustprogress norecurse nounwind nonlazybind willreturn memory(argmem: readwrite) uwtable "probe-stack"="inline-asm" "target-cpu"="x86-64" }
attributes #1 = { mustprogress norecurse nounwind nonlazybind willreturn uwtable "probe-stack"="inline-asm" "target-cpu"="x86-64" }
attributes #2 = { nounwind nonlazybind uwtable "probe-stack"="inline-asm" "target-cpu"="x86-64" }

!llvm.module.flags = !{!0, !1, !2}
!llvm.ident = !{!3}

!0 = !{i32 8, !"PIC Level", i32 2}
!1 = !{i32 2, !"RtLibUseGOT", i32 1}
!2 = !{i32 7, !"uwtable", i32 2}
!3 = !{!"rustc version 1.99.0 (b940084d7 2026-09-28)"}
!4 = !{i64 -3112865151587404100}
!5 = !{i64 7861800097967113585}
!6 = !{i64 8243444996314310719}
!7 = !{i64 -8987779804726399277}
!8 = !{i64 7390505845583968159}
!9 = !{i64 1040414395582636440}
!10 = !{i64 7672418723394140730}
!11 = !{i64 -1926972259494135916}
!12 = !{i64 -5912224459057423535}
