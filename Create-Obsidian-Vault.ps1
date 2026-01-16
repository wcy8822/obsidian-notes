# Create-Obsidian-Vault.ps1
# 作用：在 E:\Obsidian 下创建 Obsidian Vault 标准目录结构
# 说明：可重复执行（幂等），不存在则创建，存在则跳过

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# === 1) 路径与时间上下文 ===
$root = "E:\Obsidian"
$year = (Get-Date).ToString("yyyy")
$month = (Get-Date).ToString("yyyy-MM")
$quarter = "Q{0}" -f [math]::Ceiling(((Get-Date).Month)/3.0)

# 检查 E 盘是否存在
if (-not (Test-Path "E:\")) {
    Write-Error "未找到 E:\ 盘，请确认磁盘存在后再运行。"
    exit 1
}

# === 2) 目录清单（可按需增删）===
$dirs = @(
    # 顶层
    "$root",
    "$root\Inbox",
    "$root\Daily",
    "$root\Projects",
    "$root\Knowledge",
    "$root\Deliverables",
    "$root\Playbook",
    "$root\Archive",
    "$root\Templates",

    # Daily 下沉分层（按 年 / 年-月）
    "$root\Daily\$year",
    "$root\Daily\$year\$month",

    # Projects 下常用分组
    "$root\Projects\_Active",
    "$root\Projects\_Incubator",
    "$root\Projects\_OnHold",
    "$root\Projects\_Archive",

    # Knowledge 常用分组
    "$root\Knowledge\Notes",
    "$root\Knowledge\Sources",
    "$root\Knowledge\References",

    # Deliverables 常用分组
    "$root\Deliverables\OnePagers",
    "$root\Deliverables\Docs",
    "$root\Deliverables\Slides",
    "$root\Deliverables\Exports",

    # Playbook 常用分组
    "$root\Playbook\Templates",
    "$root\Playbook\Checklists",
    "$root\Playbook\HowTos",

    # Archive 下沉分层（按 年 / 季度）
    "$root\Archive\$year",
    "$root\Archive\$year\$quarter",

    # Templates 模板分组
    "$root\Templates\Daily",
    "$root\Templates\Project",
    "$root\Templates\Deliverable",
    "$root\Templates\Playbook"
)

# === 3) 创建目录（幂等）===
foreach ($d in $dirs) {
    if (-not (Test-Path $d)) {
        New-Item -Path $d -ItemType Directory | Out-Null
        Write-Host "[新建] $d"
    } else {
        Write-Host "[存在] $d"
    }
}

# === 4) 可选：初始化 README（只在首次创建时生成占位文件）===
function Ensure-File($path, $content) {
    if (-not (Test-Path $path)) {
        $content | Out-File -FilePath $path -Encoding UTF8 -Force
        Write-Host "[写入] $path"
    } else {
        Write-Host "[存在] $path"
    }
}

Ensure-File "$root\README.md" @"
# Obsidian Vault (E:\Obsidian)

- Inbox：临时收集
- Daily：日记/复盘（按 年 / 年-月 分层）
- Projects：项目区（_Active / _Incubator / _OnHold / _Archive）
- Knowledge：知识沉淀（Notes/Sources/References）
- Deliverables：交付物（OnePagers/Docs/Slides/Exports）
- Playbook：可复用流程（Templates/Checklists/HowTos）
- Archive：归档（按 年 / 季度）
- Templates：模板区（Daily/Project/Deliverable/Playbook）
"@

Ensure-File "$root\Templates\Daily\_daily.md" @"
---
tags: [daily]
---

# {{date:YYYY-MM-DD}} Daily
- 今日目标：
- 关键产出：
- 问题与阻碍：
- 明日预告：
"@

Ensure-File "$root\Templates\Project\_project.md" @"
---
status: active
owner: ixu
---

# 项目名称
## 目标
## 里程碑
## 工作分解
## 风险与对策
## 交付标准
"@

Write-Host "`n完成：目录结构与基础模板已就绪。可以在 Obsidian 中将 E:\Obsidian 作为 Vault 打开。"
