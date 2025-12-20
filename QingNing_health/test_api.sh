#!/bin/bash

# 测试阿里千问 API 连接
# 使用前，请替换 YOUR_API_KEY 为你的实际 API Key

API_KEY="sk-aa8709157f9e499db817478141404077"
HOST="https://dashscope.aliyuncs.com"

echo "🔍 测试阿里千问 API..."
echo "API Key: ${API_KEY:0:10}..."
echo ""

curl -X POST "$HOST/compatible-mode/v1/chat/completions" \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer $API_KEY" \
  -d '{
    "model": "qwen-turbo",
    "messages": [
      {"role": "user", "content": "你好，请回复一句话。"}
    ]
  }' \
  -w "\n\n📊 HTTP Status: %{http_code}\n" \
  -v
