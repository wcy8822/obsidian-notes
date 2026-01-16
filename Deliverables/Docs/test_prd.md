一句话结论：这是你要的“**一次性可执行测试工单 Prompt**”，已锁定通义模型仅可用 **qwen-vl-plus / qwen-vl-plus-latest**、用 **DASHSCOPE_API_KEY（已注入）**，并抽象了路径（默认读取 **input/** 作为素材根，且支持HTTP上传）。直接把下面整段丢给执行AI即可。

```
【角色与目标】
你是执行AI。基于现有仓库/服务（若缺则自建最小沙盒），按本工单对“团油APP截图解析API”完成一次端到端真实测试。
仅允许调用通义多模态模型：["qwen-vl-plus", "qwen-vl-plus-latest"]。
严禁硬编码路径与密钥；路径用变量与模板解析；失败不得静默。

【前置环境（我方已注入/约定）】
环境变量：
- CONFIG_HOME=?（如 ./config；若缺，请安全提示）
- DATA_ROOT=?（可空；用于解析输入目录）
- OUTPUT_ROOT=?（可空；用于产出与证据）
- DASHSCOPE_API_KEY=已注入（必有；只可从环境读取）
- DASHSCOPE_ENDPOINT=?（可空）
- OCR_MODEL=?（仅可为 qwen-vl-plus 或 qwen-vl-plus-latest；若未设，优先用 qwen-vl-plus-latest，失败则降级 qwen-vl-plus）

输入素材：
- 我已将真实图片放在「input/」目录下（你的工作目录可不同），你需支持两种喂法：
  A) 目录批量：INPUT_DIR（默认解析为 ${DATA_ROOT:-.}/input）
  B) HTTP 上传：/parse_image 表单上传（不依赖本地目录）

【路径解析规则（抽象规范）】
- 所有路径从配置读取；若请求参数提供 input_dir，则以参数优先。
- 若 input_dir 缺失或不存在：返回告警码 `WARN_INPUT_DIR_MISSING` 并切换到“HTTP 上传模式”，继续流程，不得中断。
- evidence 目录按模板 `${OUTPUT_ROOT:-./out}/evidence/{IMAGE_ID}` 渲染；父目录不存在时自动创建。

【必须存在/实现的接口（若无请就地最小实现/Mock，但要落地产物）】
- GET  /health              → 回 {status, parser_ver, dict_ver, layout_ver, config_home, ocr_model}
- POST /parse_image         → form-data: file=@..., meta=json；落地产物到 evidence/{IMAGE_ID}/
- POST /parse_batch         → query: input_dir, run_date?, batch_id?
- GET  /config/reload       → 重新加载 ${CONFIG_HOME}/manifest.yaml；parser_ver 递增
- GET  /replay/{image_id}   → 回 evidence 路径与 config.snapshot.yaml 片段

【OCR接入硬性约束】
- 只可使用 DashScope 通义：provider=dashscope，model ∈ {"qwen-vl-plus","qwen-vl-plus-latest"}
- api_key 仅从环境变量 DASHSCOPE_API_KEY 读取（配置文件中用占位引用，如 ${DASHSCOPE_API_KEY}）
- 若模型名不在白名单或Key缺失：返回清晰错误 `FAIL_OCR_MODEL_NOT_ALLOWED` 或 `FAIL_KEY_MISSING`；不得退回其他供应商

【执行步骤（严格按序）】
1) 健康检查：
   - 调用 /health
   - 断言：包含 [status, parser_ver, dict_ver, layout_ver, config_home, ocr_model]
   - 断言：ocr_model ∈ {"qwen-vl-plus","qwen-vl-plus-latest"}

2) 单图解析（HTTP 上传模式，必须通过）：
   - 我将上传任意一张真实图片 file=@{ANY_IMAGE_PATH}，meta 示例：{"source_app":"tuanyou","page_hint":"PRICE_LIST"}
   - 断言：响应含 [image_id, page_type, fields[], evidence_id, parser_ver, review_flag]
   - 断言：磁盘生成 evidence/{IMAGE_ID}/{raw.json, std.json, config.snapshot.yaml}（路径从模板渲染，不得写死）

3) 批处理（优先从 input/ 目录；若不存在则按规范降级，不中断）：
   - 解析 INPUT_DIR = ${INPUT_DIR:-${DATA_ROOT:-.}/input}
   - 调用 /parse_batch?input_dir=${INPUT_DIR}&run_date={today}&batch_id=test
   - 若目录缺失：返回 `WARN_INPUT_DIR_MISSING` 并记录“已按工单降级为仅HTTP上传”；否则断言生成 ${OUTPUT_ROOT:-./out}/std/field_std.{ext}

4) 热更新：
   - 可控修改一个字典项（如 brand_aliases 占位别名）
   - 调用 /config/reload；断言 parser_ver 递增
   - 再次 /parse_image 同一图片：若标准化受影响应体现差异；若不影响，须给出“无需变化”的理由

5) 回放证据：
   - 调用 /replay/{image_id}（取自步骤2）
   - 断言：返回 evidence 绝对/相对路径与 config.snapshot.yaml 片段（含 parser_ver/dict_ver/layout_ver/ocr_model）

【验收标准（全部满足才算通过）】
- 模型合规：实际使用的 ocr_model 在白名单内；/health 回显一致
- 路径抽象：测试中未引用固定目录常量；响应/产物路径可由模板推导
- 证据完备：evidence 下最少含 raw.json、std.json、config.snapshot.yaml
- 热更新可见：/config/reload 前后 parser_ver 变化；/health 显示最新版本
- 容错到位：input_dir 不存在→`WARN_INPUT_DIR_MISSING` 而非 500；缺少非关键ENV→清晰提示
- 安全合规：DASHSCOPE_API_KEY 仅从环境读取，配置/代码不出现明文Key

【你需要返回给我（固定格式）】
《运行指令》
- 本地与（如有）docker 启动命令（变量化写法，不得写死路径）

《成功回执》
- /health JSON 片段（含 ocr_model）
- /parse_image JSON 片段（含 image_id）
- /config/reload JSON 片段（展示 parser_ver 变化）
- /replay JSON 片段（展示 evidence 路径与配置快照节选）

《产物清单》
- 列出 evidence/{image_id}/ 下的实际文件名
- 若执行了批处理：列出 ${OUTPUT_ROOT}/std/ 下生成的文件名

《配置快照节选》（≤50行）
- 合并后关键段：paths（模板与解析顺序）、ocr.engine（provider/model）、parser_policy.thresholds

《异常与修复》
- 列出本次测试产生的告警/错误码（如 WARN_INPUT_DIR_MISSING、FAIL_KEY_MISSING、FAIL_OCR_MODEL_NOT_ALLOWED）与处理动作

【禁止事项】
- 硬编码任何路径/阈值/Key/模型名（除了白名单校验）
- 只说“已完成”而不提供证据文件与JSON片段
- 静默失败或吞错结束流程

开始执行。
```