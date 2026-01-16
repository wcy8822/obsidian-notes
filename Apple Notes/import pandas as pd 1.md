import os
from datetime import datetime

def clean_store_id(store_id):
    """清洗store_id，处理可能包含引号或其他字符的情况"""
    if pd.isna(store_id):
        return None
    # 移除可能的引号和多余字符
    cleaned = str(store_id).replace("'", "").replace(" ", "").strip()
    return cleaned  # 不再限制长度为18位

def analyze_data(file_path):
    # 读取所有表
    sheets = ['下发', '收回', '清洗', '输出', '情报', '商户1', '商户2']  # 更新工作表列表
    data = {}
    
    # 读取每个 sheet 的数据，特别处理 store_id 列
    for sheet in sheets:
        try:
            # 以字符串形式读取 store_id 列，防止科学计数法
            data[sheet] = pd.read_excel(file_path, sheet_name=sheet, converters={'store_id': str})
            # 清洗 store_id 列
            data[sheet]['store_id'] = data[sheet]['store_id'].apply(clean_store_id)
            print(f"成功读取 {sheet} 表，包含 {len(data[sheet])} 条记录")
        except Exception as e:
            print(f"读取 {sheet} 表时出错: {e}")
            return None
    
    # 检查每个 sheet 中是否存在必要的列，并提供交互式重命名功能
    required_columns = {
        '下发': ['store_id', 'is_overlap_station_region', 'party_first_name'],
        '收回': ['store_id', 'is_overlap_station_region', '是否合作中小供给', '主要中小供给名称'],
        '清洗': ['store_id', 'is_overlap_station_region', 'store_level_mtd_v2', 'province_name1', 'order_cnt_mtd', 'party_first_name'],
        '输出': ['store_id', 'is_overlap_station_region'],
        '情报': ['store_id', 'is_overlap_station_region'],
        '商户1': ['store_id', 'is_overlap_station_region'],
        '商户2': ['store_id', 'is_overlap_station_region']
    }
    
    for sheet, columns in required_columns.items():
        for col in columns:
            if col not in data[sheet].columns:
                new_col = input(f"{sheet}表缺少列'{col}'，请输入替代列名（直接回车跳过此表）：")
                if new_col:
                    if new_col in data[sheet].columns:
                        data[sheet] = data[sheet].rename(columns={new_col: col})
                        print(f"已将{sheet}表中的'{new_col}'重命名为'{col}'")
                    else:
                        print(f"你提供的替代列名'{new_col}'也不存在于{sheet}表中，跳过此表")
                        return None
                else:
                    print(f"跳过{sheet}表的分析")
                    return None
    
    # 处理重复值，按order_cnt_mtd降序排列后取第一行
    for sheet in sheets:
        if 'order_cnt_mtd' in data[sheet].columns:
            data[sheet] = data[sheet].sort_values('order_cnt_mtd', ascending=False)
        data[sheet] = data[sheet].drop_duplicates(subset='store_id', keep='first')
        print(f"{sheet}表去重后剩余 {len(data[sheet])} 条记录")
    
    # 标记在哪个环节找不到数据
    missing_data = {}
    for sheet in ['收回', '清洗', '输出']:
        missing_ids = set(data['下发']['store_id']) - set(data[sheet]['store_id'])
        missing_data[sheet] = list(missing_ids)
        print(f"下发表中有{len(missing_ids)}个store_id在{sheet}表中不存在")
    
    # 计算is_overlap_station_region相关字段
    # 1. 合并各表的is_overlap_station_region字段
    result_df = data['下发'][['store_id', 'party_first_name']].copy()  # 以下发表为基准
    
    # 添加收回、情报、商户的标记
    result_df = pd.merge(result_df, data['收回'][['store_id', 'is_overlap_station_region']], 
                        on='store_id', how='left', suffixes=('', '_收回'))
    result_df = pd.merge(result_df, data['情报'][['store_id', 'is_overlap_station_region']], 
                        on='store_id', how='left', suffixes=('_收回', '_情报'))
    
    # 商户标记：优先取商户2，再取商户1
    merchant_df = pd.merge(data['商户1'][['store_id', 'is_overlap_station_region']], 
                          data['商户2'][['store_id', 'is_overlap_station_region']], 
                          on='store_id', how='outer', suffixes=('_商户1', '_商户2'))
    merchant_df['is_overlap_station_region'] = merchant_df['is_overlap_station_region_商户2'].fillna(
        merchant_df['is_overlap_station_region_商户1'])
    result_df = pd.merge(result_df, merchant_df[['store_id', 'is_overlap_station_region']], 
                        on='store_id', how='left', suffixes=('_情报', '_商户'))
    
    # 重命名列
    result_df.columns = ['store_id', 'party_first_name', 'is_overlap_station_region收回', 
                        'is_overlap_station_region情报', 'is_overlap_station_region商户']
    
    # 清洗非0/1值为99
    for col in ['is_overlap_station_region收回', 'is_overlap_station_region情报', 'is_overlap_station_region商户']:
        result_df[col] = result_df[col].apply(lambda x: 99 if pd.isna(x) or x not in [0, 1] else x)
    
    # 计算最终标记
    def calculate_final_flag(row):
        merchant = row['is_overlap_station_region商户']
        info = row['is_overlap_station_region情报']
        region = row['is_overlap_station_region收回']  # 区域值实际来自收回表
        
        if merchant != 99:
            return (merchant, '商户')
        elif info == 1:
            return (info, '情报')
        else:
            return (region, '区域')
    
    result_df[['is_overlap_station_region_final', 'is_overlap_station_region_final_标记来源']] = result_df.apply(
        calculate_final_flag, axis=1, result_type='expand')
    
    # 清洗中小供给相关字段
    # 1. 是否合作中小供给
    data['收回']['is_cooperate_with_sme_suppliers'] = data['收回']['是否合作中小供给'].apply(
        lambda x: 1 if x == '是' else 0)
    
    # 2. 主要中小供给名称
    PRIORITY_SUPPLIERS = ['易加油', '帮油', '鲸车惠', '站联科技', '油吨吨', '聚油加油', '陕西万诚', '广电猫猫']
    
    def match_supplier(name):
        if pd.isna(name):
            return '其他'
        for supplier in PRIORITY_SUPPLIERS:
            if supplier in str(name):
                return supplier
        return '其他'
    
    data['收回']['typical_sme_supplier_names'] = data['收回']['主要中小供给名称'].apply(match_supplier)
    
    # 合并中小供给信息到结果表
    result_df = pd.merge(result_df, 
                        data['收回'][['store_id', 'is_cooperate_with_sme_suppliers', 'typical_sme_supplier_names']],
                        on='store_id', how='left')
    
    # 创建中间表，用于抽样和商户差异分析
    sampling_base_df = data['清洗'].copy()
    
    # 合并最终标记结果到中间表
    sampling_base_df = pd.merge(sampling_base_df, 
                               result_df[['store_id', 'is_overlap_station_region_final', 'is_overlap_station_region_final_标记来源']],
                               on='store_id', how='left')
    
    # 特征工程
    # 1. 是否头部站
    sampling_base_df['是否头部站'] = sampling_base_df['store_level_mtd_v2'].apply(
        lambda x: '非头部站' if x == '非头部站' else '头部站')
    
    # 2. 随机抽样
    # 筛选符合条件的数据（来源为区域或情报）
    if 'is_overlap_station_region_final_标记来源' in sampling_base_df.columns:
        sampling_df = sampling_base_df[sampling_base_df['is_overlap_station_region_final_标记来源'].isin(['区域', '情报'])].copy()
    else:
        print("警告：未找到 'is_overlap_station_region_final_标记来源' 列，无法进行抽样")
        sampling_base_df['is_rand'] = 0  # 默认不抽样
        sampling_df = pd.DataFrame(columns=sampling_base_df.columns)
    
    # 按province_name1和is_overlap_station_region_final分组计算目标抽样数
    grouped = sampling_df.groupby(['province_name1', 'is_overlap_station_region_final']).size().reset_index(name='总数')
    grouped['目标抽样数'] = grouped.apply(
        lambda row: max(10, round(row['总数'] * 0.05)) if row['is_overlap_station_region_final'] == 0 else 
                    max(10, round(row['总数'] * 0.03)), axis=1)
    
    # 实现分层抽样算法
    sampled_ids = set()
    for (province, flag), group in sampling_df.groupby(['province_name1', 'is_overlap_station_region_final']):
        if len(group) == 0:
            continue
            
        target_count = grouped[(grouped['province_name1'] == province) & 
                             (grouped['is_overlap_station_region_final'] == flag)]['目标抽样数'].iloc[0]
        
        # 按order_cnt_mtd降序排列
        sorted_group = group.sort_values('order_cnt_mtd', ascending=False)
        
        # 控制每个party_first_name最多抽2个
        party_counts = {}
        sampled = []
        
        for _, row in sorted_group.iterrows():
            party = row['party_first_name']
            if party not in party_counts:
                party_counts[party] = 0
            if party_counts[party] < 2:
                sampled.append(row['store_id'])
                party_counts[party] += 1
                if len(sampled) >= target_count:
                    break
        
        sampled_ids.update(sampled)
    
    # 添加抽样标记到中间表
    sampling_base_df['is_rand'] = sampling_base_df['store_id'].apply(lambda x: 1 if x in sampled_ids else 0)
    
    # 3. 商户差异分析
    # 计算商户差异
    def calculate_merchant_diff(group):
        unique_values = group['is_overlap_station_region_final'].dropna().unique()
        if len(unique_values) <= 1:
            return 1  # 一致
        else:
            return 0  # 不一致
    
    # 按party_first_name分组计算差异，修复FutureWarning
    diff_groups = sampling_base_df.groupby('party_first_name').apply(
        lambda x: calculate_merchant_diff(x)).reset_index()
    diff_groups.columns = ['party_first_name', '商户差异']
    
    # 计算修正建议（众数），修复KeyError
    def get_mode(x):
        modes = x.mode()
        return modes.iloc[0] if not modes.empty else None
    
    mode_groups = sampling_base_df.groupby('party_first_name')['is_overlap_station_region_final'].apply(get_mode).reset_index()
    mode_groups.columns = ['party_first_name', '商户差异修正建议']
    
    # 合并结果到中间表
    sampling_base_df = pd.merge(sampling_base_df, diff_groups, on='party_first_name', how='left')
    sampling_base_df = pd.merge(sampling_base_df, mode_groups, on='party_first_name', how='left')
    
    # 合并特征工程结果到最终结果表
    result_df = pd.merge(result_df, 
                        sampling_base_df[['store_id', '是否头部站', 'is_rand', '商户差异', '商户差异修正建议']],
                        on='store_id', how='left')
    
    # 生成输出文件路径
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    output_dir = os.path.dirname(file_path)
    output_file = os.path.join(output_dir, f"重叠站分析结果_{timestamp}.csv")
    
    # 按指定顺序输出字段
    output_columns = [
        'party_first_name', 'store_id', 'is_overlap_station_region收回', 
        'is_overlap_station_region情报', 'is_overlap_station_region商户', 
        'is_overlap_station_region_final', 'is_overlap_station_region_final_标记来源',
        'is_cooperate_with_sme_suppliers', 'typical_sme_supplier_names', 
        '是否头部站', 'is_rand', '商户差异', '商户差异修正建议'
    ]
    
    # 保存结果
    result_df[output_columns].to_csv(output_file, index=False, encoding='utf-8-sig', na_rep='nan')
    print(f"分析完成，结果已保存至: {output_file}")
    
    return result_df

# 执行分析
if __name__ == "__main__":
    file_path = '/Users/didi/Downloads/panth/tag_ct/overlap/标签数据-重叠站-202507.xlsx'
    result_df = analyze_data(file_path)
    if result_df is not None:
        print(f"分析结果包含 {len(result_df)} 条记录")