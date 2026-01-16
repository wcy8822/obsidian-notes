import pytesseract
from PIL import Image
import cv2
import numpy as np

# 指定Tesseract安装路径
pytesseract.pytesseract.tesseract_cmd = r"d:\Program Files\Tesseract-OCR\tesseract.exe"

# 保留边框的预处理（核心：减少去噪强度，避免边框被过滤）
def image_preprocess(image_path):
    img = cv2.imread(image_path)
    if img is None:
        raise FileNotFoundError(f"无法找到图片文件：{image_path}")
    
    # 1. 轻度灰度化（保留边框对比度）
    gray = cv2.cvtColor(img, cv2.COLOR_BGR2GRAY)
    
    # 2. 极轻度去噪（只去除小噪点，保留边框）
    denoised = cv2.GaussianBlur(gray, (1, 1), 0)  # 1x1核，几乎不模糊
    
    # 3. 低阈值二值化（保留浅色边框）
    # 降低阈值到150，让更多边框线条被保留为文字（黑色）
    _, binary = cv2.threshold(denoised, 150, 255, cv2.THRESH_BINARY_INV)
    
    # 4. 轻度腐蚀（可选：去除边框外的杂点，不破坏边框）
    kernel = np.ones((1, 1), np.uint8)
    processed = cv2.erode(binary, kernel, iterations=1)
    
    # 转换为PIL格式
    processed_img = Image.fromarray(processed)
    
    # 保存预处理图（观察边框是否保留）
    save_path = r"D:\processed_test_ocr.png"
    cv2.imwrite(save_path, processed)
    print(f"预处理后的图片已保存到：{save_path}")
    
    return processed_img

# 适配带边框的结构化内容识别
def local_ocr(image_path):
    processed_img = image_preprocess(image_path)
    
    # 关键参数调整：
    # --psm 3：默认模式，适合带边框的结构化页面（自动检测边框和文本块）
    # 保留interword_spaces，确保字段分隔正确
    custom_config = r'--psm 3 --oem 3 -c preserve_interword_spaces=1'
    
    # 执行识别
    result = pytesseract.image_to_string(processed_img, lang='chi_sim+eng', config=custom_config)
    return result

if __name__ == "__main__":
    # 替换为你的JPG图片路径
    test_image = r"D:\test_ocr.jpg"
    
    try:
        ocr_result = local_ocr(test_image)
        print("="*60)
        print("保留边框的OCR识别结果：")
        print(ocr_result)
        print("="*60)
    except Exception as e:
        print(f"运行出错：{str(e)}")
