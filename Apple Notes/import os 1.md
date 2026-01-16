import warnings
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from sklearn.linear_model import LinearRegression
from sklearn.preprocessing import PolynomialFeatures
from sklearn.metrics import mean_squared_error, r2_score
import joblib
from datetime import datetime

# 忽略警告信息
warnings.filterwarnings('ignore')

# --------------------------
# 一、配置参数（用户可手动修改）
# --------------------------
TRAIN_DATA_PATH = "/Users/didi/Downloads/panth/fgw_pre_mod_2025/发改委调价.xlsx"       # 基础数据文件
CYCLE_DATA_PATH = "/Users/didi/Downloads/panth/fgw_pre_mod_2025/调价周期表.xlsx"        # 调价周期表
OUTPUT_PATH = "/Users/didi/Downloads/panth/fgw_pre_mod_2025/调价预测结果.xlsx"          # 输出结果文件
MODEL_SAVE_PATH = "/Users/didi/Downloads/panth/fgw_pre_mod_2025/oil_price_models/"      # 模型保存路径
TRAIN_MODEL = True  # 训练开关：首次使用设为True，预测设为False

# --------------------------
# 二、工具函数定义（核心修改处已标注）
# --------------------------
def create_dir_if_not_exists(path):
    """创建文件夹（若不存在）"""
    if not os.path.exists(path):
        os.makedirs(path)
    return path

def preprocess_data(df):
    """数据预处理：处理异常值和缺失值"""
    for col in ['综合变化率', '系数/吨', '系数/升']:
        if col in df.columns:
            # 异常值处理（四分位法）
            q1 = df[col].quantile(0.25)
            q3 = df[col].quantile(0.75)
            iqr = q3 - q1
            lower_bound = q1 - 1.5 * iqr
            upper_bound = q3 + 1.5 * iqr
            df = df[(df[col] >= lower_bound) & (df[col] <= upper_bound)]
    
    # 缺失值处理（均值填充）
    for col in df.columns:
        if df[col].isnull().any() and pd.api.types.is_numeric_dtype(df[col]):
            df[col].fillna(df[col].mean(), inplace=True)
    
    print("数据预处理完成：异常值按四分位法删除，缺失值用均值填充")
    return df

def convert_crude_data_format(crude_df):
    """
    【核心修改1：适配长格式原油数据】
    将长格式原油数据（按油种分行）转换为宽格式（按油种分列）
    输入格式：日期、产品名称、油种类型（WTI/布伦特/迪拜）、收盘价
    输出格式：日期、布伦特价格、wti价格、迪拜原油价格
    """
    # 筛选原油数据（排除其他产品）
    crude_df = crude_df[crude_df['产品名称'] == '原油']
    
    # 透视表转换：日期为索引，油种类型为列，收盘价为值
    pivot_df = crude_df.pivot_table(
        index='日期',
        columns='油种类型',
        values='收盘价',
        aggfunc='first'  # 同一天同一油种取第一个值
    ).reset_index()
    
    # 重命名列（确保与代码后续逻辑一致）
    pivot_df.columns.name = None  # 移除列索引名称
    pivot_df = pivot_df.rename(columns={
        '布伦特': '布伦特价格',
        'WTI': 'wti价格',
        '迪拜': '迪拜原油价格'
    })
    
    # 转换日期格式
    pivot_df['日期'] = pd.to_datetime(pivot_df['日期'])
    print("原油数据格式转换完成（长格式→宽格式）")
    return pivot_df

def train_crude_weight_model(adjustment_df, crude_df):
    """
    【核心修改2：基于调价周期计算变化率】
    训练原油权重模型：用调价周期初末的原油价格变化率与综合变化率的关系
    """
    # 1. 转换原油数据格式（长→宽）
    crude_wide_df = convert_crude_data_format(crude_df)
    
    # 2. 合并调价结果与原油数据（按日期匹配）
    adjustment_df['日期'] = pd.to_datetime(adjustment_df['日期'])
    merged_df = pd.merge(
        adjustment_df[['日期', '油品类型', '综合变化率']],
        crude_wide_df,
        on='日期',
        how='left'
    )
    
    # 3. 计算调价周期变化率（周期初=上一个调价日，周期末=当前调价日）
    # 按日期排序
    merged_df = merged_df.sort_values('日期')
    # 上一个调价日的原油价格（shift(1)获取前一行数据）
    merged_df['布伦特_上周期'] = merged_df['布伦特价格'].shift(1)
    merged_df['wti_上周期'] = merged_df['wti价格'].shift(1)
    merged_df['迪拜_上周期'] = merged_df['迪拜原油价格'].shift(1)
    
    # 计算周期变化率：(本周期末 - 上周期初)/上周期初
    merged_df['布伦特_周期变化率'] = (merged_df['布伦特价格'] - merged_df['布伦特_上周期']) / merged_df['布伦特_上周期']
    merged_df['wti_周期变化率'] = (merged_df['wti价格'] - merged_df['wti_上周期']) / merged_df['wti_上周期']
    merged_df['迪拜_周期变化率'] = (merged_df['迪拜原油价格'] - merged_df['迪拜_上周期']) / merged_df['迪拜_上周期']
    
    # 剔除首行（无历史数据）和缺失值
    merged_df = merged_df.dropna(subset=[
        '布伦特_周期变化率', 'wti_周期变化率', '迪拜_周期变化率', '综合变化率'
    ])
    
    # 4. 训练线性回归模型（特征=原油周期变化率，目标=综合变化率）
    X = merged_df[['布伦特_周期变化率', 'wti_周期变化率', '迪拜_周期变化率']]
    y = merged_df['综合变化率']
    model = LinearRegression()
    model.fit(X, y)
    
    # 5. 权重归一化
    weights = model.coef_
    weights = weights / weights.sum() if weights.sum() != 0 else np.array([1/3, 1/3, 1/3])
    
    # 保存权重
    joblib.dump(weights, f"{MODEL_SAVE_PATH}crude_weights.pkl")
    print(f"原油权重训练完成（基于调价周期）：布伦特={weights[0]:.4f}, WTI={weights[1]:.4f}, 迪拜={weights[2]:.4f}")
    return weights

def train_price_models(adjustment_df):
    """训练三种调价预测模型（线性、二次、三次多项式）"""
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
        print(f"线性回归 - MSE: {mse_lin:.4f}, R²: {r2_lin:.4f}（{get_evaluation(r2_lin)}）")
        print(f"二次多项式 - MSE: {mse_p2:.4f}, R²: {r2_p2:.4f}（{get_evaluation(r2_p2)}）")
        print(f"三次多项式 - MSE: {mse_p3:.4f}, R²: {r2_p3:.4f}（{get_evaluation(r2_p3)}）")
    
    joblib.dump(models, f"{MODEL_SAVE_PATH}price_models.pkl")
    print("\n价格预测模型训练完成")
    return models

def get_evaluation(r2):
    """模型效果评价"""
    if r2 >= 0.8:
        return "效果优秀"
    elif r2 >= 0.6:
        return "效果良好"
    elif r2 >= 0.4:
        return "效果一般"
    else:
        return "效果较差"
    
# 1. 读取调价周期表（明确指定sheet名称，确保字段匹配）
def load_cycle_data(cycle_path):
    """读取并预处理调价周期表，确保字段正确"""
    cycle_df = pd.read_excel(cycle_path, sheet_name='调价周期')  # 强制读取sheet名为“调价周期”
    
    # 2. 检查关键字段是否存在
    required_columns = ['日期', '上一个调价日', '下一个调价日', '是否工作日']
    missing_cols = [col for col in required_columns if col not in cycle_df.columns]
    if missing_cols:
        raise ValueError(f"调价周期表缺少必要字段：{missing_cols}，请检查表格格式")
    
    # 3. 转换日期格式
    cycle_df['日期'] = pd.to_datetime(cycle_df['日期'])
    cycle_df['上一个调价日'] = pd.to_datetime(cycle_df['上一个调价日'])
    cycle_df['下一个调价日'] = pd.to_datetime(cycle_df['下一个调价日'])
    
    # 4. 处理“是否工作日”字段（兼容布尔值True/False或整数1/0）
    if cycle_df['是否工作日'].dtype in [np.int64, np.float64]:
        # 若字段是整数（1=工作日，0=非工作日），转换为布尔值
        cycle_df['是否工作日'] = cycle_df['是否工作日'] == 1
        print("调价周期表：已将整数型'是否工作日'转换为布尔值（1→True，0→False）")
    
    return cycle_df  


def calculate_cycle_combined_cr(last_adjust_date, current_date, crude_df, weights):
    """计算从上个调价日到当前日期的综合变化率（周期累计）"""
    # 转换原油数据格式
    crude_wide_df = convert_crude_data_format(crude_df)
    
    # 1. 获取周期初价格（上一个调价日）
    last_date = pd.to_datetime(last_adjust_date)
    last_crude = crude_wide_df[crude_wide_df['日期'] == last_date]
    if last_crude.empty:
        print(f"警告：上一个调价日 {last_adjust_date} 无原油数据，跳过该周期。")
        return None  # 返回 None 表示跳过该周期
    
    last_prices = last_crude[['布伦特价格', 'wti价格', '迪拜原油价格']].iloc[0].values
    
    # 2. 获取周期末价格（当前日期）
    current_date = pd.to_datetime(current_date)
    current_crude = crude_wide_df[crude_wide_df['日期'] == current_date]
    if current_crude.empty:
        print(f"警告：当前日期 {current_date} 无原油数据，跳过该周期。")
        return None  # 返回 None 表示跳过该周期
    
    current_prices = current_crude[['布伦特价格', 'wti价格', '迪拜原油价格']].iloc[0].values
    
    # 3. 计算各原油周期变化率
    brent_cr = (current_prices[0] - last_prices[0]) / last_prices[0] if last_prices[0] != 0 else 0
    wti_cr = (current_prices[1] - last_prices[1]) / last_prices[1] if last_prices[1] != 0 else 0
    dubai_cr = (current_prices[2] - last_prices[2]) / last_prices[2] if last_prices[2] != 0 else 0
    
    # 4. 加权计算综合变化率
    return brent_cr * weights[0] + wti_cr * weights[1] + dubai_cr * weights[2]

def predict_adjustment(models, weights, cycle_df, oil_types, adjustment_df, crude_df):
    """生成调价预测结果"""
    results = []
    crude_wide_df = convert_crude_data_format(crude_df)  # 转换原油数据格式
    
    # 遍历每个调价周期
    for last_adjust_date in cycle_df['上一个调价日'].unique():
        # 筛选本周期数据
        cycle_subset = cycle_df[cycle_df['上一个调价日'] == last_adjust_date]
        next_adjust_date = cycle_subset['下一个调价日'].iloc[0]
        workdays = cycle_subset[cycle_subset['是否工作日']]['日期'].tolist()
        
        # 遍历本周期每个工作日
        for date in workdays:
            # 计算截至当前日期的综合变化率（周期累计）
            combined_cr = calculate_cycle_combined_cr(
                last_adjust_date, date, crude_df, weights
            )
            
            for oil_type in oil_types:
                # 加载模型
                linear_model, _ = models[oil_type]['linear']
                poly2_model, poly2 = models[oil_type]['poly2']
                poly3_model, poly3 = models[oil_type]['poly3']
                
                # 特征准备
                X = np.array([[combined_cr]])
                
                # 预测系数/吨
                coef_ton_lin = linear_model.predict(X)[0]
                coef_ton_p2 = poly2_model.predict(poly2.transform(X))[0]
                coef_ton_p3 = poly3_model.predict(poly3.transform(X))[0]
                
                # 计算调价幅度-吨
                adjust_ton_lin = combined_cr * coef_ton_lin
                adjust_ton_p2 = combined_cr * coef_ton_p2
                adjust_ton_p3 = combined_cr * coef_ton_p3
                
                # 转换为升（密度参数）
                if oil_type in ['92#(93#)', '95#(97#)']:
                    density = 1388  # 汽油密度（kg/m³）
                    tax_rate = 1.06 if oil_type == '92#(93#)' else 1.12
                else:  # 0#柴油
                    density = 1176
                    tax_rate = 1.0
                
                # 计算系数/升和调价幅度/升
                coef_liter_lin = coef_ton_lin / density * tax_rate
                coef_liter_p2 = coef_ton_p2 / density * tax_rate
                coef_liter_p3 = coef_ton_p3 / density * tax_rate
                
                adjust_liter_lin = adjust_ton_lin / density * tax_rate
                adjust_liter_p2 = adjust_ton_p2 / density * tax_rate
                adjust_liter_p3 = adjust_ton_p3 / density * tax_rate
                
                # 判断调价结果（上涨/下跌/搁浅）
                # 获取当前原油均价（用于判断天花板/地板价）
                current_crude = crude_wide_df[crude_wide_df['日期'] == pd.to_datetime(date)]
                crude_avg = current_crude[['布伦特价格', 'wti价格', '迪拜原油价格']].mean(axis=1).iloc[0]
                
                # 取线性模型结果作为判断依据
                final_adjust_ton = adjust_ton_lin
                if crude_avg > 130 or crude_avg < 40 or abs(final_adjust_ton) < 50:
                    adjustment_result = "搁浅"
                    adjust_ton_lin = adjust_ton_p2 = adjust_ton_p3 = 0
                    adjust_liter_lin = adjust_liter_p2 = adjust_liter_p3 = 0
                else:
                    adjustment_result = "上涨" if final_adjust_ton > 0 else "下跌"
                
                # 获取历史实际值（从调价结果表中匹配）
                hist_row = adjustment_df[
                    (adjustment_df['日期'] == pd.to_datetime(date)) & 
                    (adjustment_df['油品类型'] == oil_type)
                ]
                hist_ton = hist_row['系数/吨'].values[0] if not hist_row.empty else None
                hist_liter = hist_row['系数/升'].values[0] if not hist_row.empty else None
                
                # 整理结果
                results.append({
                    '日期': date,
                    '油品类型': oil_type,
                    '综合变化率（周期累计）': combined_cr,
                    '系数/吨': coef_ton_lin,
                    '系数/升': coef_liter_lin,
                    '预测调价幅度-吨（线性）': adjust_ton_lin,
                    '预测调价幅度-吨（二次）': adjust_ton_p2,
                    '预测调价幅度-吨（三次）': adjust_ton_p3,
                    '预测调价幅度-升（线性）': adjust_liter_lin,
                    '预测调价幅度-升（二次）': adjust_liter_p2,
                    '预测调价幅度-升（三次）': adjust_liter_p3,
                    '历史实际调价幅度-吨': hist_ton,
                    '历史实际调价幅度-升': hist_liter,
                    '本轮调价结果': adjustment_result
                })
    
    return pd.DataFrame(results)

def generate_visualizations(result_df, output_path):
    """生成预测趋势图"""
    oil_types = result_df['油品类型'].unique()
    with pd.ExcelWriter(output_path, engine='openpyxl', mode='a') as writer:
        for oil_type in oil_types:
            df = result_df[result_df['油品类型'] == oil_type].sort_values('日期')
            plt.figure(figsize=(10, 6))
            # 折线图：预测值（二次多项式）
            plt.plot(df['日期'], df['预测调价幅度-吨（二次）'], 'r-', label='预测值（二次多项式）')
            # 柱状图：实际值
            plt.bar(df['日期'], df['历史实际调价幅度-吨'], alpha=0.5, label='实际值')
            plt.title(f'{oil_type}调价幅度预测与实际对比')
            plt.xlabel('日期')
            plt.ylabel('调价幅度（元/吨）')
            plt.legend()
            plt.xticks(rotation=45)
            plt.tight_layout()
            # 保存图表
            img_path = f'temp_{oil_type}.png'
            plt.savefig(img_path)
            plt.close()
            # 插入Excel
            from openpyxl import load_workbook
            from openpyxl.drawing.image import Image
            wb = load_workbook(output_path)
            ws = wb['预测与实际对比']
            img = Image(img_path)
            img.anchor = f'O{len(df)*3 + 2}'  # 调整插入位置
            ws.add_image(img)
            wb.save(output_path)
            os.remove(img_path)
    print("可视化图表已插入Excel")

# --------------------------
# 主程序
# --------------------------
if __name__ == "__main__":
    create_dir_if_not_exists(MODEL_SAVE_PATH)
    
    # 1. 读取数据（明确sheet名称）
    # 【关键提示】发改委调价.xlsx需包含以下2个sheet：
    # - sheet1名称：调价结果（存储历史调价结果，含油品类型、综合变化率等）
    # - sheet2名称：原油价格数据（存储长格式原油数据，含日期、产品名称、油种类型、收盘价等）
    adjustment_df = pd.read_excel(TRAIN_DATA_PATH, sheet_name='调价结果')  # 调价结果sheet
    crude_df = pd.read_excel(TRAIN_DATA_PATH, sheet_name='原油价格数据')    # 原油数据sheet
    cycle_df = load_cycle_data(CYCLE_DATA_PATH)   # 调价周期表
    cycle_df['日期'] = pd.to_datetime(cycle_df['日期'])
    cycle_df['上一个调价日'] = pd.to_datetime(cycle_df['上一个调价日'])
    cycle_df['下一个调价日'] = pd.to_datetime(cycle_df['下一个调价日'])
    
    # 2. 数据预处理
    adjustment_df = preprocess_data(adjustment_df)
    
    # 3. 模型训练（手动触发）
    if TRAIN_MODEL:
        print("===== 开始模型训练 =====")
        # 训练原油权重模型（需调价结果和原油数据）
        crude_weights = train_crude_weight_model(adjustment_df, crude_df)
        # 训练价格预测模型（仅需调价结果数据）
        oil_types = adjustment_df['油品类型'].unique()
        price_models = train_price_models(adjustment_df)
    else:
        print("===== 使用已训练模型预测 =====")
        crude_weights = joblib.load(f"{MODEL_SAVE_PATH}crude_weights.pkl")
        price_models = joblib.load(f"{MODEL_SAVE_PATH}price_models.pkl")
        oil_types = list(price_models.keys())
    
    # 4. 生成预测结果
    prediction_df = predict_adjustment(
        price_models, crude_weights, cycle_df, oil_types, adjustment_df, crude_df
    )
    
    # 5. 保存结果
    prediction_df.to_excel(OUTPUT_PATH, sheet_name='预测与实际对比', index=False)
    print(f"预测结果已保存至 {OUTPUT_PATH}")
    
    # 6. 生成可视化图表
    generate_visualizations(prediction_df, OUTPUT_PATH)
    
    print("\n操作完成！重新训练模型请将TRAIN_MODEL设为True。")