# API使用说明

## 快速开始

### 1. 安装依赖

```bash
pip install -r requirements.txt
```

### 2. 启动服务

```bash
python start.py
```

或者使用Docker：

```bash
docker-compose up -d
```

### 3. 访问API文档

打开浏览器访问: http://localhost:8000/docs

## API接口说明

### 1. 健康检查

```bash
GET /api/v1/health
```

### 2. 上传单张图片

```bash
POST /api/v1/upload
Content-Type: multipart/form-data

参数:
- file: 图片文件 (必需)
- batch_id: 批次ID (可选)
- page_type: 页面类型 (可选: ORDER_CONFIRM, STATION_DETAIL, ORDER_RESULT)
```

示例：

```bash
curl -X POST "http://localhost:8000/api/v1/upload" \
  -F "file=@test_image.jpg" \
  -F "batch_id=test_batch_001" \
  -F "page_type=ORDER_CONFIRM"
```

### 3. 批量处理

```bash
POST /api/v1/batch
Content-Type: application/json

{
  "batch_id": "batch_001",
  "image_paths": ["/path/to/image1.jpg", "/path/to/image2.jpg"],
  "page_types": ["ORDER_CONFIRM", "STATION_DETAIL"],
  "force_reprocess": false
}
```

### 4. 获取系统指标

```bash
GET /api/v1/metrics
```

### 5. 列出版式模板

```bash
GET /api/v1/templates?page_type=ORDER_CONFIRM
```

### 6. 获取证据快照

```bash
GET /api/v1/evidence/{evidence_id}
```

## 响应格式

### 成功响应

```json
{
  "success": true,
  "message": "图片解析成功",
  "data": {
    "image_id": "uuid",
    "page_type": "ORDER_CONFIRM",
    "station_info": {
      "station_name": "中石化加油站",
      "brand_name": "中石化",
      "address": "北京市朝阳区xxx路123号"
    },
    "oil_price_info": {
      "oil_type": "95#",
      "list_price": 7.50,
      "discount_price": 7.20,
      "final_payable": 7.20
    },
    "confidence": 0.85,
    "evidence_id": "uuid",
    "ttl_days": 30,
    "evidence_state": "APPLIED"
  },
  "processing_time": 2.5
}
```

### 错误响应

```json
{
  "success": false,
  "message": "处理失败: 具体错误信息",
  "errors": ["错误1", "错误2"],
  "processing_time": 0.5
}
```

## 配置说明

### 环境变量

- `DEBUG`: 调试模式 (默认: false)
- `HOST`: 服务地址 (默认: 0.0.0.0)
- `PORT`: 服务端口 (默认: 8000)
- `DATABASE_URL`: 数据库连接字符串
- `REDIS_URL`: Redis连接字符串
- `OCR_ENGINE`: OCR引擎 (默认: paddleocr)
- `OCR_USE_GPU`: 是否使用GPU (默认: false)

### 配置文件

复制 `config/config.example.yaml` 为 `config/config.yaml` 并修改相应配置。

## 页面类型说明

1. **ORDER_CONFIRM**: 下单确认/结算页
   - 包含油品、价格、优惠、应付、支付方式等信息

2. **STATION_DETAIL**: 站点详情页
   - 包含站名、品牌、地址、距离、服务能力、营业时间等信息

3. **ORDER_RESULT**: 订单结果/票据页
   - 包含订单号、时间、实付、积分/权益等信息

## 字段说明

### 站点信息
- `station_name`: 站点名称
- `brand_name`: 品牌名称
- `address`: 地址
- `poi_id_ext`: 外部POI ID
- `open_hours`: 营业时间
- `distance_km`: 距离（公里）

### 油品价格信息
- `oil_type`: 油品型号
- `list_price`: 标价
- `discount_price`: 折扣价
- `discount_amount`: 折扣金额
- `final_payable`: 最终应付
- `price_per_liter`: 每升价格
- `coupon_type`: 优惠券类型
- `coupon_value`: 优惠券面值

### 订单信息
- `order_id_ext`: 外部订单ID
- `order_time`: 下单时间
- `pay_method`: 支付方式
- `quantity_liter`: 油量（升）
- `invoice_flag`: 是否开发票

### 站内服务
- `has_carwash`: 是否有洗车
- `carwash_type`: 洗车类型
- `shop_convenience`: 是否有便利店
- `parking`: 是否有停车场
- `parking_count`: 停车位数量

## 质量指标

- **字段级准确率**: ≥ 90%
- **样本回收率**: ≥ 95%
- **Kappa系数**: ≥ 0.85
- **新鲜度**: T+1
- **SLA**: D+1 ≤ 11:00

## 故障排除

### 常见问题

1. **OCR识别率低**
   - 检查图片质量和分辨率
   - 调整OCR参数
   - 更新词典配置

2. **版式匹配失败**
   - 检查版式模板配置
   - 更新锚点关键词
   - 调整置信度阈值

3. **字段抽取错误**
   - 检查词典配置
   - 更新抽取规则
   - 调整字段映射

### 日志查看

```bash
# 查看应用日志
tail -f logs/app.log

# 查看错误日志
tail -f logs/error.log
```

### 性能优化

1. **启用GPU加速**
   ```yaml
   ocr:
     use_gpu: true
   ```

2. **调整并发数**
   ```yaml
   app:
     workers: 4
   ```

3. **优化内存使用**
   ```yaml
   ocr:
     drop_score: 0.5
   ```
