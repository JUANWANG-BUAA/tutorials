# 前期试跑与独立调度采样

本目录原始benchmark数据是前期试跑，不纳入第9–10章正式表格。
正式归档使用相邻的`runtime-final/`。

这里保留早期测试日志、原始数据与当时源码指纹。
随后增加了两项进程回归测试和类型尺寸示例，所以不能把这里的旧测试指纹当成当前全部源码的签核。

`scheduling-sample.txt`是额外启动测量程序并附着macOS sample的报告。
scheduling业务源码与最终版本相同；采样覆盖启动、预热与多个case，也采到另一runtime的空闲worker。
正文不据此计算稳定态CPU百分比，不把它混入正式吞吐批次。

这个报告观察到current-thread park_yield/kevent、wake与step等路径，用于核对机制而非计算单次调度的绝对成本。
