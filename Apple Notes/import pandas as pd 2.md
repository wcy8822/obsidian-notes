import re
from datetime import datetime
from pathlib import Path

# 配置参数
config = {
    'raw_data_path': '/Users/didi/Downloads/panth/tag_ct/overlap/标签数据-重叠站-202507.xlsx',
    'mapping_table_path': '/Users/didi/Downloads/panth/tag_ct/kacka/分类验证与品牌对照表.xlsx',
    'base_output_dir': '/Users/didi/Downloads/panth/tag_ct/kacka/'  # 基础路径,自动创建子文件夹
}

# 确保输出目录存在
Path(config['base_output_dir']).mkdir(parents=True, exist_ok=True)

class OilBrandProcessor:
    def __init__(self):
        # 品牌库(可扩展)
        self.BRAND_KEYWORDS = {
            '中石化', '中石油', '中海油', '中化石油','中化','壳牌', 'BP', '道达尔', '雪佛龙',
            '埃克森美孚', '延长石油', '中国航油', '南方石化', '金盾石化',
            '和顺石油', '大桥石化', '恒力石化', '荣盛石化','中油节能'
        }
        # 地域特征正则(包含完整行政体系)
        self.REGION_REGEX = re.compile(
            r'(?:[省市县区州盟旗镇乡村街巷路]|'
            r'(?:北京|上海|天津|重庆|河北|山西|辽宁|吉林|黑龙江|江苏|浙江|安徽|福建|'
            r'江西|山东|河南|湖北|湖南|广东|海南|四川|贵州|云南|陕西|甘肃|青海|台湾|'
            r'香港|澳门|内蒙古|广西|西藏|宁夏|新疆)(?:[省市县区]?))'
        )
        # 无效值标识
        self.INVALID_VALUES = {"", "无", "其他", "未知", "不详"}
        
        # 品牌特征正则(动态生成)
        brand_pattern = "|".join(sorted(self.BRAND_KEYWORDS, key=len, reverse=True))
        self.BRAND_REGEX = re.compile(
            fr"({brand_pattern})|(\w{{2,6}}[石油化])"
        )

    def _clean_region(self, text):
        """深度清洗地域特征"""
        return self.REGION_REGEX.sub('', str(text))

    def _extract_brand(self, text):
        """品牌提取核心算法"""
        clean_text = self._clean_region(text)
        
        # 多级匹配策略
        match = self.BRAND_REGEX.search(clean_text)
        if not match:
            return "待确认"
            
        # 优先返回完整品牌词
        for group in match.groups():
            if group and group in self.BRAND_KEYWORDS:
                return group
                
        # 次选提取特征词段
        for group in match.groups():
            if group:
                return group[:2] + "油" if len(group) >=2 else group
        return "待确认"

    def process_row(self, row):
        # 优先级处理逻辑
        if pd.notna(row.get('sheet1_abbr')) and row['sheet1_abbr'] not in self.INVALID_VALUES:
            return row['sheet1_abbr']
        if pd.notna(row.get('简称')) and row['简称'] not in self.INVALID_VALUES:
            return row['简称']
        if 'party_first_name' in row:
            return self._extract_brand(row['party_first_name'])
        else:
            # 如果没有'party_first_name'列,返回默认值
            return '未知品牌'

    def process_file(self, input_path):
        # 数据读取
        try:
            # 优先尝试使用工作表名称'1'
            try:
                df = pd.read_excel(input_path, sheet_name='1', dtype={'简称': str})
            except Exception:
                # 如果失败,尝试使用第一个工作表
                try:
                    df = pd.read_excel(input_path, sheet_name=0, dtype={'简称': str})
                except Exception:
                    # 最后尝试使用工作表名称'Sheet1'
                    df = pd.read_excel(input_path, sheet_name='Sheet1', dtype={'简称': str})
        except Exception as e:
            print(f"读取Excel文件时出错: {str(e)}")
            raise

        # 列名规范化
        df.columns = df.columns.str.strip().str.lower()

        # 检查必要列是否存在
        required_cols = ['sheet1_abbr', '简称', 'party_first_name']
        missing_cols = [col for col in required_cols if col not in df.columns]
        if missing_cols:
            print(f"警告:缺少以下列: {missing_cols}")
        
        # 数据处理
        df['sheet1_abbr_yqx'] = df.apply(self.process_row, axis=1)
        
        # 结果保存
        timestamp = datetime.now().strftime("%Y%m%d%H%M%S")
        output_path = f"{config['base_output_dir']}abbr清洗_{timestamp}.xlsx"
        df.to_excel(output_path, index=False)
        return output_path

# 使用示例
if __name__ == "__main__":
    processor = OilBrandProcessor()
    try:
        # 使用配置中的原始数据路径
        result_file = processor.process_file(config['raw_data_path'])
        print(f"清洗完成,结果文件:{result_file}")
    except FileNotFoundError:
        print(f"错误:找不到文件 '{config['mapping_table_path']}',请检查文件路径是否正确。")
    except Exception as e:
        print(f"处理时发生错误:{str(e)}")