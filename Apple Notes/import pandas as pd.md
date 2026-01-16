import bisect
from datetime import date

# 输入输出文件路径
INPUT_FILE = '/Users/didi/Downloads/panth/fgw_pre_mod_2025/调价周期.xlsx'
OUTPUT_FILE = '/Users/didi/Downloads/panth/fgw_pre_mod_2025/调价周期_jg.xlsx'


# 起始调价日（关键参数）
START_DATE = date(2025, 7, 29)

# 读取数据
df = pd.read_excel(INPUT_FILE, parse_dates=['日期'])
print(f"读取数据成功，共{len(df)}行")

# 数据预处理
df['日期'] = df['日期'].dt.date  # 转换日期为date类型
df['是否工作日'] = df['是否工作日'].astype(int)  # 确保是否工作日列是整数类型

# 按日期升序排序并重置索引
df = df.sort_values('日期').reset_index(drop=True)

# 定位起始调价日所在行
start_row = df[df['日期'] == START_DATE].index.tolist()
if not start_row:
    raise ValueError(f"未找到起始调价日: {START_DATE}")
start_row = start_row[0]
print(f"起始调价日 {START_DATE} 位于第 {start_row + 1} 行")

# 标记调价日的函数
def mark_adjust_dates(df, start_row, direction):
    """标记调价日（每累计10个工作日标记一次）"""
    count = 0
    rows = range(start_row, len(df)) if direction == 'down' else range(start_row - 1, -1, -1)
    
    for i in rows:
        if df.at[i, '是否工作日'] == 1:
            count += 1
            if count == 10:
                df.at[i, '是否调价日'] = 1
                count = 0  # 重置计数
    return df

# 初始化结果列
df['是否调价日'] = 0

# 标记起始调价日
df.at[start_row, '是否调价日'] = 1
print(f"已标记起始调价日：{START_DATE}")

# 向下标记调价日（包含起始日）
df = mark_adjust_dates(df, start_row, 'down')

# 向上标记调价日（不含起始日）
df = mark_adjust_dates(df, start_row, 'up')

# 生成调价日列表并排序（确保按日期升序）
adjust_dates = sorted(df[df['是否调价日'] == 1]['日期'].tolist())
print(f"共标记{len(adjust_dates)}个调价日")

# 定义查找最近调价日的函数
def get_nearest_adjust_dates(current_date, adjust_dates):
    """获取当前日期的上一个和下一个调价日"""
    pos = bisect.bisect_left(adjust_dates, current_date)
    
    # 上一个调价日（小于等于当前日期的最近调价日）
    last_date = adjust_dates[pos-1] if pos > 0 else None
    
    # 下一个调价日（大于等于当前日期的最近调价日）
    next_date = adjust_dates[pos] if pos < len(adjust_dates) else None
    
    return last_date, next_date

# 生成上一个/下一个调价日列
df['上一个调价日'] = df['日期'].apply(lambda x: get_nearest_adjust_dates(x, adjust_dates)[0])
df['下一个调价日'] = df['日期'].apply(lambda x: get_nearest_adjust_dates(x, adjust_dates)[1])

# 保存结果
df.to_excel(OUTPUT_FILE, index=False)
print(f"结果已保存至 {OUTPUT_FILE}")