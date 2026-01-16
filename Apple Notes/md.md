<span style="font-family:.PingFangUITextSC-Regular;">发改委调价预测</span>_202507_2.py. Timi版本
<span style="font-family:.PingFangUITextSC-Regular;">在初稿基础上完整实现：</span>
1. 命令行人工输入未来 1/7/14/21 天原油价 & 综合变化率
2. 自动补录未来调价日（防呆）
3. Past / Future 标记
4. 调价日官方值强制覆盖
5. 区间日期筛选器
6. 防呆（缺失/异常/空值）
7. 准确率线性递增逻辑
8. 最终 Excel 严格字段顺序
"""
import os, sys, warnings, json, itertools, holidays
from datetime import datetime, timedelta
import numpy as np
import pandas as pd
import joblib
from dateutil.parser import parse as dt_parse

warnings.filterwarnings('ignore')

# ---------------- 沿用初稿路径 ----------------
TRAIN_DATA_PATH = "/Users/didi/Downloads/panth/fgw_pre_mod_2025/发改委调价.xlsx"
CYCLE_DATA_PATH = "/Users/didi/Downloads/panth/fgw_pre_mod_2025/调价周期表.xlsx"
OUTPUT_PATH   = "/Users/didi/Downloads/panth/fgw_pre_mod_2025/调价预测结果.xlsx"
MODEL_SAVE_PATH = "/Users/didi/Downloads/panth/fgw_pre_mod_2025/oil_price_models/"
TRAIN_MODEL = False          # 初稿开关保持不变

os.makedirs(MODEL_SAVE_PATH, exist_ok=True)

# ---------------- 通用工具 ----------------
def input_future(prompt, cast=float):
    """命令行交互，回车返回 None"""
    val = input(prompt).strip()
    if val == '':
        return None
    try:
        return cast(val)
    except:
        return None

def business_days(start, end):
    """计算工作日序列（自动跳过周末+中国节假日）"""
    cn_holidays = holidays.China(years=[start.year, end.year])
    days = []
    cur = start
    while cur <= end:
        if cur.weekday() < 5 and cur not in cn_holidays:
            days.append(cur)
        cur += timedelta(days=1)
    return pd.Series(days)

def safe_read(sheet):
    try:
        return pd.read_excel(TRAIN_DATA_PATH, sheet_name=sheet)
    except ValueError as e:
        print(f"❌ 找不到工作表 {sheet}：{e}")
        sys.exit(1)

def safe_merge(df1, df2, on, how='left'):
    m = pd.merge(df1, df2, on=on, how=how, suffixes=('', '_y'))
    drop_cols = [c for c in m.columns if c.endswith('_y')]
    return m.drop(columns=drop_cols)

# ---------------- 1. 人工输入未来值 ----------------
FUTURE_DAYS = [1, 7, 14, 21]
future_inputs = {}
for d in FUTURE_DAYS:
    print(f"\n--- 未来第{d}天（留空=算法自动预测）---")
    price = input_future(f"  原油价格：")
    cr    = input_future(f"  综合变化率(%)：")   # 百分比输入
    if cr is not None:
        cr = cr / 100.0
    future_inputs[d] = {'price': price, 'cr': cr}

# ---------------- 2. 读取 & 防呆 ----------------
adj_df   = safe_read('调价结果')
crude_df = safe_read('原油价格数据')
cycle_df = pd.read_excel(CYCLE_DATA_PATH, sheet_name='调价周期')

# 日期统一
for c in ['日期','上一个调价日','下一个调价日']:
    cycle_df[c] = pd.to_datetime(cycle_df[c], errors='coerce')
adj_df['日期'] = pd.to_datetime(adj_df['日期'], errors='coerce')
crude_df['日期'] = pd.to_datetime(crude_df['日期'], errors='coerce')

# 缺失/异常处理
cycle_df = cycle_df.dropna(subset=['日期','上一个调价日','下一个调价日'])
adj_df   = adj_df.dropna(subset=['日期','油品类型','综合变化率'])
crude_df = crude_df.dropna(subset=['日期','产品名称','油种类型','收盘价'])

# 3. 自动补录未来调价日（防呆）
last_known = cycle_df['下一个调价日'].max()
need_until = datetime.today() + timedelta(days=max(FUTURE_DAYS))
if last_known < need_until:
    gap_days = (need_until - last_known).days
    next_date = last_known + timedelta(days=10)   # 简化为10工作日
    extra_days = business_days(last_known + timedelta(days=1), need_until + timedelta(days=30))
    new_cycles = []
    for start, end in zip(extra_days[::10], extra_days[9::10]):
        tmp = pd.DataFrame({
            '上一个调价日': [start],
            '下一个调价日': [end]
        })
        workdays = business_days(start, end)
        tmp = tmp.merge(workdays.to_frame('日期'), how='cross')
        tmp['是否工作日'] = True
        new_cycles.append(tmp)
    if new_cycles:
        cycle_df = pd.concat([cycle_df] + new_cycles, ignore_index=True)

# ---------------- 4. 日期区间筛选 ----------------
print("\n--- 输出区间筛选（留空=全部）---")
start_filter = input_future("  起始日期 (YYYY-MM-DD)：", dt_parse)
end_filter   = input_future("  结束日期 (YYYY-MM-DD)：", dt_parse)

# ---------------- 5. 加载模型（沿用初稿） ----------------
if TRAIN_MODEL:
    # 这里复用初稿训练流程，略写
    from发改委调价预测_202507_1 import train_crude_weight_model, train_price_models
    weights = train_crude_weight_model(adj_df, crude_df)
    models  = train_price_models(adj_df)
else:
    weights = joblib.load(MODEL_SAVE_PATH + "crude_weights.pkl")
    models  = joblib.load(MODEL_SAVE_PATH + "price_models.pkl")

oil_types = adj_df['油品类型'].unique()

# ---------------- 6. 构建完整日期序列 ----------------
all_dates = []
for _, row in cycle_df.groupby(['上一个调价日','下一个调价日']).first().iterrows():
    days = business_days(row['上一个调价日'], row['下一个调价日'])
    for d in days:
        all_dates.append({
            '日期': d,
            '上一个调价日': row['上一个调价日'],
            '下一个调价日': row['下一个调价日']
        })
date_df = pd.DataFrame(all_dates)

# 未来日期标记
date_df['数据状态'] = np.where(date_df['日期'] > datetime.today(), 'Future', 'Past')

# 合并人工未来输入
future_map = {datetime.today() + timedelta(days=k):v for k,v in future_inputs.items()}
date_df['人工_price'] = date_df['日期'].map(lambda x: future_map.get(x, {}).get('price'))
date_df['人工_cr']   = date_df['日期'].map(lambda x: future_map.get(x, {}).get('cr'))

# ---------------- 7. 计算每日综合变化率 ----------------
# 原油透视
crude_pivot = crude_df[crude_df['产品名称']=='原油'].pivot_table(
    index='日期', columns='油种类型', values='收盘价', aggfunc='first'
).reset_index()

def get_crude_series(col):
    s = crude_pivot[['日期', col]].dropna().set_index('日期')[col]
    return s.reindex(pd.date_range(s.index.min(), s.index.max())).interpolate()

brent_s = get_crude_series('布伦特')
wti_s   = get_crude_series('WTI')
dubai_s = get_crude_series('迪拜')

def combined_cr_for(row):
    d, last, _ = row['日期'], row['上一个调价日'], row['下一个调价日']
    # 优先使用人工输入
    if row['人工_cr'] is not None:
        return row['人工_cr']
    # 计算周期累计
    try:
        p0 = np.array([brent_s[last], wti_s[last], dubai_s[last]])
        p1 = np.array([brent_s[d], wti_s[d], dubai_s[d]])
    except KeyError:
        return np.nan
    rates = (p1 - p0) / p0
    return np.dot(rates, weights)

date_df['综合变化率'] = date_df.apply(combined_cr_for, axis=1)

# ---------------- 8. 准确率线性规则 ----------------
def accuracy_for(row):
    start, end = row['上一个调价日'], row['下一个调价日']
    total_days = (end - start).days
    days_pass  = (row['日期'] - start).days
    if total_days == 0:
        return 1.0
    acc = 0.6 + 0.4 * days_pass / total_days
    return min(acc, 1.0)

date_df['预测准确率'] = date_df.apply(accuracy_for, axis=1)

# ---------------- 9. 主预测循环 ----------------
results = []
for _, row in date_df.iterrows():
    date, last_adj, next_adj = row['日期'], row['上一个调价日'], row['下一个调价日']
    # 是否历史调价日
    is_official_day = ((adj_df['日期']==date)&(adj_df['油品类型'].isin(oil_types))).any()
    for ot in oil_types:
        base = {
            '日期': date,
            '城市': adj_df['城市'].iloc[0],  # 默认单城市
            '油品类型': ot,
            '上一个调价日': last_adj,
            '下一个调价日': next_adj,
            '时间周期': f"{last_adj.strftime('%Y-%m-%d')}&{next_adj.strftime('%Y-%m-%d')}",
            '数据状态': row['数据状态']
        }
        # 官方值优先
        if is_official_day:
            off = adj_df[(adj_df['日期']==date)&(adj_df['油品类型']==ot)].iloc[0]
            base.update({
                '综合变化率': off['综合变化率'],
                '预计调价状态': off.get('实际调价状态', '未知'),
                '预测准确率': 1.0,
                '预测调价幅度-升': off['预测调价幅度-升'],
                '预测调价幅度-吨': off['预测调价幅度-吨'],
                '系数/升': off['系数/升'],
                '系数/吨': off['系数/吨'],
                '发改委价格': off.get('指标列')
            })
        else:
            cr = row['综合变化率']
            if pd.isna(cr):
                continue
            # 选用线性模型（可复用初稿）
            lin_model, _ = models[ot]['linear']
            coef_ton = float(lin_model.predict([[cr]])[0])
            adjust_ton = cr * coef_ton
            # 升换算
            density = 1388 if '92' in ot or '95' in ot else 1176
            tax = 1.06 if '92' in ot else 1.12 if '95' in ot else 1.0
            coef_liter = coef_ton / density * tax
            adjust_liter = adjust_ton / density * tax
            # 搁浅判断
            crude_avg = np.array([brent_s[date], wti_s[date], dubai_s[date]]).mean()
            if crude_avg > 130 or crude_avg < 40 or abs(adjust_ton) < 50:
                status = '搁浅'
                adjust_ton = adjust_liter = 0
            else:
                status = '上涨' if adjust_ton > 0 else '下跌'
            base.update({
                '综合变化率': cr,
                '预计调价状态': status,
                '预测准确率': row['预测准确率'],
                '预测调价幅度-升': adjust_liter,
                '预测调价幅度-吨': adjust_ton,
                '系数/升': coef_liter,
                '系数/吨': coef_ton,
                '发改委价格': None   # 未来可扩展
            })
        results.append(base)

out = pd.DataFrame(results)

# 日期筛选
if start_filter:
    out = out[out['日期'] >= start_filter]
if end_filter:
    out = out[out['日期'] <= end_filter]

# 字段顺序 & 保存
COLS = ['日期','城市','油品类型','综合变化率','预计调价状态','预测准确率',
        '预测调价幅度-升','发改委价格','上一个调价日','下一个调价日',
        '预测调价幅度-吨','时间周期','系数/吨','系数/升','数据状态']
out = out[COLS]
out.to_excel(OUTPUT_PATH, sheet_name='调价预测', index=False)
print(f"\n✅ 结果已保存：{OUTPUT_PATH} 共 {len(out)} 行")