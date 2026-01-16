import pathlib
import re

# 1. 这里改成你的文件夹路径
base_dir = pathlib.Path(r"E:\Obsidian\Projects\_Active\德州")

# 2. 输出文件名（会生成在同一目录下）
output_file = base_dir / "Poker_OS_2.0_full.md"

chapter_files = []

# 3. 找出形如“第 0 章 … .md”的文件，并提取章号
for md in base_dir.glob("*.md"):
    # 用文件名（不含扩展名）匹配 “第 X 章”
    m = re.match(r"^第\s*(\d+)\s*章", md.stem)
    if m:
        chap_num = int(m.group(1))
        chapter_files.append((chap_num, md))

# 4. 按章号从小到大排序（0,1,2,...,20）
chapter_files.sort(key=lambda x: x[0])

if not chapter_files:
    raise SystemExit("没有找到形如 '第 X 章*.md' 的文件，请检查文件名。")

print("即将合并这些文件（按章节号排序）：")
for num, p in chapter_files:
    print(f"第 {num} 章 -> {p.name}")

# 5. 依次读取并写入汇总文件，中间用分隔线隔开
with output_file.open("w", encoding="utf-8") as out_f:
    for idx, (num, path) in enumerate(chapter_files):
        with path.open("r", encoding="utf-8") as f:
            content = f.read().strip()

        out_f.write(content)

        # 章节之间加分隔线，最后一章后面就不加了
        if idx != len(chapter_files) - 1:
            out_f.write("\n\n---\n\n")

print(f"\n合并完成：{output_file}")
