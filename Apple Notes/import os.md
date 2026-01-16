import warnings
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from sklearn.linear_model import LinearRegression
from sklearn.preprocessing import PolynomialFeatures
from sklearn.metrics import mean_squared_error, r2_score
import joblib
from datetime import datetime, timedelta
import logging
from openpyxl import load_workbook
from openpyxl.styles import Alignment, numbers
from openpyxl.utils import get_column_letter

# 忽略警告信息
warnings.filterwarnings('ignore')


# 配置日志（修正路径）
LOG_PATH = os.path.join(os.path.dirname(os.path.abspath(__file__)), 'error.log')
logging.basicConfig(filename=LOG_PATH, level=logging.ERROR,
                    format='%(asctime)s - %(levelname)s - %(message)s')

# 中国法定节假日（2024-2026）
HOLIDAYS_2024 = [
    '2024-01-01', '2024-02-10', '2024-02-11', '2024-02-12', '2024-02-13', 
    '2024-02-14', '2024-02-15', '2024-02-16', '2024-04-05', '2024-05-01', 
    '2024-05-02', '2024-05-03', '2024-06-08', '2024-09-15', '2024-10-01', 
    '2024-10-02', '2024-10-03', '2024-10-04', '2024-10-05', '2024-10-06'
<span style="font-family:.CJKSymbolsFallbackSC-Regular;">]</span>

HOLIDAYS_2025 = [
    '2025-01-01', '2025-02-19', '2025-02-20', '2025-02-21', '2025-02-22', 
    '2025-02-23', '2025-02-24', '2025-02-25', '2025-04-04', '2025-05-01', 
    '2025-05-02', '2025-05-03', '2025-06-02', '2025-09-29', '2025-10-01', 
    '2025-10-02', '2025-10-03', '2025-10-04', '2025-10-05', '2025-10-06'
<span style="font-family:.CJKSymbolsFallbackSC-Regular;">]</span>

HOLIDAYS_2026 = [
    '2026-01-01', '2026-02-08', '2026-02-09', '2026-02-10', '2026-02-11', 
    '2026-02-12', '2026-02-13', '2026-02-14', '2026-04-04', '2026-05-01', 
    '2026-05-02', '2026-05-03', '2026-06-07', '2026-09-28', '2026-10-01', 
    '2026-10-02', '2026-10-03', '2026-10-04', '2026-10-05', '2026-10-06'
<span style="font-family:.CJKSymbolsFallbackSC-Regular;">]</span>

ALL_HOLIDAYS = HOLIDAYS_2024 + HOLIDAYS_2025 + HOLIDAYS_2026
ALL_HOLIDAYS = [pd.to_datetime(date) for date in ALL_HOLIDAYS]

# --------------------------
# 一、配置参数（用户可手动修改）
# --------------------------
TRAIN_DATA_PATH = "/Users/didi/Downloads/panth/fgw_pre_mod_2025/发改委调价.xlsx"       # 基础数据文件
CYCLE_DATA_PATH = "/Users/didi/Downloads/panth/fgw_pre_mod_2025/调价周期表.xlsx"        # 调价周期表
OUTPUT_PATH = "/Users/didi/Downloads/panth/fgw_pre_mod_2025/调价预测结果.xlsx"          # 输出结果文件
MODEL_SAVE_PATH = "/Users/didi/Downloads/panth/fgw_pre_mod_2025/oil_price_models/"      # 模型保存路径
TRAIN_MODEL = True  # 训练开关：首次使用设为True，预测设为False

# --------------------------
# 二、工具函数定义
# --------------------------
def create_dir_if_not_exists(path):
    """创建文件夹（若不存在）"""
    if not os.path.exists(path):
        os.makedirs(path)
    return path

def check_files_exist():
    """检查必要文件是否存在"""
    for file_path in [TRAIN_DATA_PATH, CYCLE_DATA_PATH]:
        if not os.path.exists(file_path):
            raise FileNotFoundError(f"文件不存在: {file_path}")

def preprocess_data(df):
    """数据预处理：处理异常值和缺失值"""
    # 检查缺失值
    missing_rows = df[df[['综合变化率', '系数/吨', '系数/升']].isnull().any(axis=1)]
    for _, row in missing_rows.iterrows():
        logging.error(f"缺失值: 行 {row.name}, 数据: {row}")
    
    # 移除缺失关键值的记录
    df = df.dropna(subset=['综合变化率', '系数/吨', '系数/升'])
    
    # 处理异常值
    # 综合变化率超出 (-100%, 100%)
    abnormal_cr = df[(df['综合变化率'] <= -1) | (df['综合变化率'] >= 1)]
    for _, row in abnormal_cr.iterrows():
        logging.error(f"异常值: 综合变化率={row['综合变化率']}, 行 {row.name}")
    df.loc[(df['综合变化率'] <= -1) | (df['综合变化率'] >= 1), '综合变化率'] = np.nan
    
    # 系数/吨、系数/升 ≤0
    abnormal_coef = df[(df['系数/吨'] <= 0) | (df['系数/升'] <= 0)]
    for _, row in abnormal_coef.iterrows():
        logging.error(f"异常值: 系数/吨={row['系数/吨']}, 系数/升={row['系数/升']}, 行 {row.name}")
    df = df[(df['系数/吨'] > 0) & (df['系数/升'] > 0)]
    
    # 线性插值修复综合变化率
    df['综合变化率'] = df['综合变化率'].interpolate(method='linear')
    
    return df

def convert_crude_data_format(crude_df):
    """将长格式原油数据转换为宽格式"""
    # 筛选原油数据
    crude_df = crude_df[crude_df['产品名称'] == '原油']
    
    # 透视表转换
    pivot_df = crude_df.pivot_table(
        index='日期',
        columns='油种类型',
        values='收盘价',
        aggfunc='first'
    ).reset_index()
    
    # 重命名列
    pivot_df.columns.name = None
    pivot_df = pivot_df.rename(columns={
        '布伦特': '布伦特价格',
        'WTI': 'wti价格',
        '迪拜': '迪拜原油价格'
    })
    
    # 转换日期格式
    pivot_df['日期'] = pd.to_datetime(pivot_df['日期'])
    return pivot_df

def train_crude_weight_model(adjustment_df, crude_df):
    """训练原油权重模型"""
    crude_wide_df = convert_crude_data_format(crude_df)
    
    # 合并数据
    adjustment_df['日期'] = pd.to_datetime(adjustment_df['日期'])
    merged_df = pd.merge(
        adjustment_df[['日期', '油品类型', '综合变化率']],
        crude_wide_df,
        on='日期',
        how='left'
    )
    
    # 计算调价周期变化率
    merged_df = merged_df.sort_values('日期')
    merged_df['布伦特_上周期'] = merged_df['布伦特价格'].shift(1)
    merged_df['wti_上周期'] = merged_df['wti价格'].shift(1)
    merged_df['迪拜_上周期'] = merged_df['迪拜原油价格'].shift(1)
    
    merged_df['布伦特_周期变化率'] = (merged_df['布伦特价格'] - merged_df['布伦特_上周期']) / merged_df['布伦特_上周期']
    merged_df['wti_周期变化率'] = (merged_df['wti价格'] - merged_df['wti_上周期']) / merged_df['wti_上周期']
    merged_df['迪拜_周期变化率'] = (merged_df['迪拜原油价格'] - merged_df['迪拜_上周期']) / merged_df['迪拜_上周期']
    
    # 剔除首行和缺失值
    merged_df = merged_df.dropna(subset=[
        '布伦特_周期变化率', 'wti_周期变化率', '迪拜_周期变化率', '综合变化率'
    ])
    
    # 训练线性回归模型
    X = merged_df[['布伦特_周期变化率', 'wti_周期变化率', '迪拜_周期变化率']]
    y = merged_df['综合变化率']
    model = LinearRegression()
    model.fit(X, y)
    
    # 权重归一化
    weights = model.coef_
    weights = weights / weights.sum() if weights.sum() != 0 else np.array([1/3, 1/3, 1/3])
    
    # 保存权重
    joblib.dump(weights, f"{MODEL_SAVE_PATH}crude_weights.pkl")
    print(f"原油权重训练完成: 布伦特={weights[0]:.4f}, WTI={weights[1]:.4f}, 迪拜={weights[2]:.4f}")
    return weights

def train_price_models(adjustment_df):
    """训练价格预测模型"""
    models = {}
    oil_types = adjustment_df['油品类型'].unique()
    
    for oil_type in oil_types:
        oil_data = adjustment_df[adjustment_df['油品类型'] == oil_type]
        X = oil_data[['综合变化率']]
        y = oil_data['系数/吨']
        
        # 线性回归
        linear_model = LinearRegression()
        linear_model.fit(X, y)
        
        # 二次多项式
        poly2 = PolynomialFeatures(degree=2)
        X_poly2 = poly2.fit_transform(X)
        poly2_model = LinearRegression()
        poly2_model.fit(X_poly2, y)
        
        # 三次多项式
        poly3 = PolynomialFeatures(degree=3)
        X_poly3 = poly3.fit_transform(X)
        poly3_model = LinearRegression()
        poly3_model.fit(X_poly3, y)
        
        models[oil_type] = {
            'linear': (linear_model, None),
            'poly2': (poly2_model, poly2),
            'poly3': (poly3_model, poly3)
        }
        
        # 模型评估
        def eval_model(model, X, y, transformer=None):
            X_t = transformer.transform(X) if transformer else X
            y_pred = model.predict(X_t)
            return mean_squared_error(y, y_pred), r2_score(y, y_pred)
        
        mse_lin, r2_lin = eval_model(linear_model, X, y)
        mse_p2, r2_p2 = eval_model(poly2_model, X, y, poly2)
        mse_p3, r2_p3 = eval_model(poly3_model, X, y, poly3)
        
        print(f"\n{oil_type}模型评估：")
        print(f"线性回归 - MSE: {mse_lin:.4f}, R²: {r2_lin:.4f}")
        print(f"二次多项式 - MSE: {mse_p2:.4f}, R²: {r2_p2:.4f}")
        print(f"三次多项式 - MSE: {mse_p3:.4f}, R²: {r2_p3:.4f}")
    
    joblib.dump(models, f"{MODEL_SAVE_PATH}price_models.pkl")
    print("\n价格预测模型训练完成")
    return models

def load_cycle_data(cycle_path):
    """读取并预处理调价周期表"""
    cycle_df = pd.read_excel(cycle_path, sheet_name='调价周期')
    
    # 检查关键字段
    required_columns = ['日期', '上一个调价日', '下一个调价日', '是否工作日']
    missing_cols = [col for col in required_columns if col not in cycle_df.columns]
    if missing_cols:
        raise ValueError(f"调价周期表缺少必要字段：{missing_cols}")
    
    # 转换日期格式
    cycle_df['日期'] = pd.to_datetime(cycle_df['日期'])
    cycle_df['上一个调价日'] = pd.to_datetime(cycle_df['上一个调价日'])
    cycle_df['下一个调价日'] = pd.to_datetime(cycle_df['下一个调价日'])
    
    # 处理“是否工作日”字段
    if cycle_df['是否工作日'].dtype in [np.int64, np.float64]:
        cycle_df['是否工作日'] = cycle_df['是否工作日'] == 1
    
    return cycle_df

def is_working_day(date):
    """判断是否为工作日（非周末和非节假日）"""
    if date.weekday() >= 5:  # 周末
        return False
    if date in ALL_HOLIDAYS:  # 法定节假日
        return False
    return True

def calculate_cycle_combined_cr(last_adjust_date, current_date, crude_df, weights):
    """计算从上个调价日到当前日期的综合变化率"""
    crude_wide_df = convert_crude_data_format(crude_df)
    
    # 增加移动平均处理
    crude_wide_df[['布伦特价格', 'wti价格', '迪拜原油价格']] = crude_wide_df[['布伦特价格', 'wti价格', '迪拜原油价格']].rolling(window=3).mean()
    
    # 获取周期初价格
    last_date = pd.to_datetime(last_adjust_date)
    last_crude = crude_wide_df[crude_wide_df['日期'] == last_date]
    if last_crude.empty:
        raise ValueError(f"上一个调价日 {last_adjust_date} 无原油数据")
    last_prices = last_crude[['布伦特价格', 'wti价格', '迪拜原油价格']].iloc[0].values
    
    # 获取周期末价格
    current_date = pd.to_datetime(current_date)
    current_crude = crude_wide_df[crude_wide_df['日期'] == current_date]
    if current_crude.empty:
        raise ValueError(f"当前日期 {current_date} 无原油数据")
    current_prices = current_crude[['布伦特价格', 'wti价格', '迪拜原油价格']].iloc[0].values
    
    # 计算各原油周期变化率
    brent_cr = (current_prices[0] - last_prices[0]) / last_prices[0] if last_prices[0] != 0 else 0
    wti_cr = (current_prices[1] - last_prices[1]) / last_prices[1] if last_prices[1] != 0 else 0
    dubai_cr = (current_prices[2] - last_prices[2]) / last_prices[2] if last_prices[2] != 0 else 0
    
    # 加权计算综合变化率
    return brent_cr * weights[0] + wti_cr * weights[1] + dubai_cr * weights[2]

def get_closest_coef(adjustment_df, combined_cr, oil_type):
    """获取最接近综合变化率对应的系数"""
    # 筛选100%准确的历史记录
    history = adjustment_df[(adjustment_df['油品类型'] == oil_type) & 
                           (adjustment_df['系数/吨'] > 0) & 
                           (adjustment_df['系数/升'] > 0)]
    
    if history.empty:
        return None, None
    
    # 计算绝对值差
    history['diff'] = (history['综合变化率'] - combined_cr).abs()
    
    # 按差值和日期排序
    history = history.sort_values(['diff', '日期'], ascending=[True, False])
    
    # 取最小差值的第一条记录
    closest = history.iloc[0]
    return closest['系数/吨'], closest['系数/升']

def get_future_input():
    """获取未来原油价格和综合变化率的人工输入，兼容空输入"""
    future_input = {}
    days = [1, 7, 14, 21]
    
    for day in days:
        print(f"\n=== 未来第{day}天 ===")
        # 获取输入并去除首尾空格
        price_input = input(f"请输入未来第{day}天原油价格（如无请回车跳过）：").strip()
        cr_input = input(f"请输入未来第{day}天综合变化率%（如无请回车跳过）：").strip()
        
        # 处理空输入（直接回车）
        price = float(price_input) if price_input else None
        # 综合变化率需转换为小数（%→小数），空输入则为None
        cr = float(cr_input) / 100 if cr_input else None
        
        if price is not None or cr is not None:
            future_input[day] = {
                'price': price,
                'cr': cr
            }
    
    return future_input


def fill_missing_fgw_prices(df):
    """填充缺失的发改委价格"""
    # 按油品类型和日期排序
    df = df.sort_values(['油品类型', '日期'])
    
    # 对每个油品类型单独处理
    for oil_type in df['油品类型'].unique():
        oil_data = df[df['油品类型'] == oil_type]
        
        # 用上一个调价日的价格填充
        for i, row in oil_data.iterrows():
            if pd.isna(row['发改委价格']):
                # 找到上一个有价格的记录
                prev_prices = oil_data.loc[:i-1, '发改委价格'].dropna()
                if not prev_prices.empty:
                    df.loc[i, '发改委价格'] = prev_prices.iloc[-1]
                    df.loc[i, '数据状态'] = f"{df.loc[i, '数据状态']}|price_filled"
    
    return df

def adjust_excel_format(output_path):
    """调整Excel输出格式"""
    wb = load_workbook(output_path)
    ws = wb['AdjustmentForecast']
    
    # 设置列宽
    for col in range(1, ws.max_column + 1):
        ws.column_dimensions[get_column_letter(col)].width = 15
    
    # 设置日期格式
    for row in ws.iter_rows(min_row=2, max_row=ws.max_row, min_col=1, max_col=1):
        for cell in row:
            cell.number_format = 'yyyy-mm-dd'
    
    # 设置数值格式（保留2位小数）
    for col in [4, 6, 7, 9, 10, 11, 13, 14]:  # 列索引（从1开始）
        for row in range(2, ws.max_row + 1):
            ws.cell(row=row, column=col).number_format = '0.00'
    
    # 设置对齐方式
    for row in ws.iter_rows(min_row=1, max_row=ws.max_row, min_col=1, max_col=ws.max_column):
        for cell in row:
            if cell.row == 1:  # 表头
                cell.alignment = Alignment(horizontal='center', vertical='center')
            else:
                if cell.column in [1, 2, 3, 5, 8, 12, 15]:  # 文本列
                    cell.alignment = Alignment(horizontal='left', vertical='center')
                else:  # 数值列
                    cell.alignment = Alignment(horizontal='right', vertical='center')
    
    wb.save(output_path)

# 修改预测函数，处理NaN值
def predict_adjustment(models, weights, cycle_df, oil_types, adjustment_df, crude_df, future_input=None, city=None):
    """生成调价预测结果"""
    results = []
    crude_wide_df = convert_crude_data_format(crude_df)
    
    # 获取默认城市
    if city is None:
        city = adjustment_df['城市'].iloc[0] if not adjustment_df.empty else "未知城市"
    
    # 生成未来21天的日期列表
    today = pd.to_datetime('today').normalize()
    future_dates = [today + timedelta(days=i) for i in range(1, 22) if is_working_day(today + timedelta(days=i))]
    
    # 遍历未来21天
    for date in future_dates:
        # 检查是否有用户输入的综合变化率
        days_ahead = (date - today).days
        user_cr = None
        
        if future_input and days_ahead in future_input and future_input[days_ahead]['cr'] is not None:
            user_cr = future_input[days_ahead]['cr']
            print(f"使用用户输入的第{days_ahead}天综合变化率: {user_cr:.2%}")
        else:
            # 假设上一个调价日为距离今天最近的调价日
            last_adjust_date = cycle_df[cycle_df['日期'] <= today]['上一个调价日'].max()
            try:
                combined_cr = calculate_cycle_combined_cr(last_adjust_date, date, crude_df, weights)
                print(f"使用算法预测的第{days_ahead}天综合变化率: {combined_cr:.2%}")
            except Exception as e:
                logging.error(f"计算综合变化率出错: {e}")
                continue
        
        # 确定综合变化率
        combined_cr = user_cr if user_cr is not None else combined_cr
        
        # 跳过NaN值
        if pd.isna(combined_cr):
            logging.error(f"综合变化率为NaN，跳过日期: {date}, 油品类型: {oil_type}")
            continue
                
        for oil_type in oil_types:
            # 预测系数/吨
            linear_model, _ = models[oil_type]['linear']
            X = np.array([[combined_cr]])
            
            # 检查输入是否有效
            if np.isnan(combined_cr):
                logging.error(f"综合变化率为NaN，跳过日期: {date}, 油品类型: {oil_type}")
                continue
            
            coef_ton_lin = linear_model.predict(X)[0]
            
            # 获取最接近的历史系数
            coef_ton, coef_liter = get_closest_coef(adjustment_df, combined_cr, oil_type)
            
            # 若未找到历史系数，使用模型预测
            if coef_ton is None or coef_liter is None:
                coef_ton = coef_ton_lin
                # 计算系数/升
                if oil_type in ['92#(93#)', '95#(97#)']:
                    density = 1388
                    tax_rate = 1.06 if oil_type == '92#(93#)' else 1.12
                else:  # 0#柴油
                    density = 1176
                    tax_rate = 1.0
                coef_liter = coef_ton / density * tax_rate
            
            # 计算调价幅度
            adjust_ton = combined_cr * coef_ton
            adjust_liter = combined_cr * coef_liter
            
            # 判断调价结果
            current_crude = crude_wide_df[crude_wide_df['日期'] == pd.to_datetime(date)]
            if current_crude.empty:
                logging.error(f"当前日期 {date} 无原油数据")
                continue
            
            crude_avg = current_crude[['布伦特价格', 'wti价格', '迪拜原油价格']].mean(axis=1).iloc[0]
            
            if crude_avg > 130 or crude_avg < 40 or abs(adjust_ton) < 50:
                adjustment_result = "搁浅"
            else:
                adjustment_result = "上涨" if adjust_ton > 0 else "下跌"
            
            # 获取历史实际值
            hist_row = adjustment_df[
                (adjustment_df['日期'] == pd.to_datetime(date)) & 
                (adjustment_df['油品类型'] == oil_type) &
                (adjustment_df['城市'] == city)
            ]
            
            hist_ton = hist_row['系数/吨'].values[0] if not hist_row.empty else None
            hist_liter = hist_row['系数/升'].values[0] if not hist_row.empty else None
            
            # 获取发改委价格
            fgw_price = hist_row['发改委价格'].values[0] if not hist_row.empty else None
            
            # 判断数据状态
            data_status = "未来"
            
            # 预测准确率
            accuracy = 1.0 if date in cycle_df['下一个调价日'].values else None  # 调价日准确率为100%
            
            result = {
                '日期': date,
                '油品类型': oil_type,
                '综合变化率': combined_cr,
                '系数/吨': coef_ton,
                '系数/升': coef_liter,
                '调价幅度/吨': adjust_ton,
                '调价幅度/升': adjust_liter,
                '调价结果': adjustment_result,
                '历史系数/吨': hist_ton,
                '历史系数/升': hist_liter,
                '发改委价格': fgw_price,
                '数据状态': data_status,
                '预测准确率': accuracy
            }
            results.append(result)
    
    return pd.DataFrame(results)

# 主程序示例
if __name__ == "__main__":
    check_files_exist()
    create_dir_if_not_exists(MODEL_SAVE_PATH)
    
    # 读取数据
    adjustment_df = pd.read_excel(TRAIN_DATA_PATH, sheet_name='调价数据')
    crude_df = pd.read_excel(TRAIN_DATA_PATH, sheet_name='原油数据')
    cycle_df = load_cycle_data(CYCLE_DATA_PATH)
    
    # 数据预处理
    adjustment_df = preprocess_data(adjustment_df)
    
    # 训练模型
    if TRAIN_MODEL:
        weights = train_crude_weight_model(adjustment_df, crude_df)
        models = train_price_models(adjustment_df)
    else:
        weights = joblib.load(f"{MODEL_SAVE_PATH}crude_weights.pkl")
        models = joblib.load(f"{MODEL_SAVE_PATH}price_models.pkl")
    
    # 获取用户输入
    future_input = get_future_input()
    
    # 生成预测结果
    oil_types = adjustment_df['油品类型'].unique()
    result_df = predict_adjustment(models, weights, cycle_df, oil_types, adjustment_df, crude_df, future_input)
    
    # 筛选未来21天的数据
    today = pd.to_datetime('today').normalize()
    future_21_days_df = result_df[result_df['日期'] >= today][:21]
    
    # 保存结果到Excel
    future_21_days_df.to_excel(OUTPUT_PATH, sheet_name='AdjustmentForecast', index=False)
    
    # 调整Excel格式
    adjust_excel_format(OUTPUT_PATH)
    
    print("预测完成，结果已保存到", OUTPUT_PATH)