<%* 
  // 生成包含时分的时间戳（格式：YYYY-MM-DD HH-mm，注意用短横线代替冒号，避免系统兼容问题）
  const timestamp = tp.date.now("YYYYMMDDHHmm");
  // 将当前文件重命名为时间戳
  await tp.file.rename(timestamp);
%>

---
