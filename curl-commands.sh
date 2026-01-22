#!/usr/bin/env sh

BASE_URL="http://localhost:8080"

# Health
curl -sS "$BASE_URL/health"

# List products
curl -sS "$BASE_URL/api/produk"

# Create product
curl -sS -X POST "$BASE_URL/api/produk" \
  -H "Content-Type: application/json" \
  -d '{"nama":"Teh Botol","harga":8000,"stock":30}'

# Get product by ID
curl -sS "$BASE_URL/api/produk/1"

# Update product by ID
curl -sS -X PUT "$BASE_URL/api/produk/1" \
  -H "Content-Type: application/json" \
  -d '{"nama":"Teh Botol Sosro","harga":9000,"stock":25}'

# Delete product by ID
curl -sS -X DELETE "$BASE_URL/api/produk/1"

# List categories
curl -sS "$BASE_URL/categories"

# Create category
curl -sS -X POST "$BASE_URL/categories" \
  -H "Content-Type: application/json" \
  -d '{"name":"Peralatan Rumah","description":"Peralatan rumah tangga."}'

# Get category by ID
curl -sS "$BASE_URL/categories/1"

# Update category by ID
curl -sS -X PUT "$BASE_URL/categories/1" \
  -H "Content-Type: application/json" \
  -d '{"name":"Peralatan Dapur","description":"Alat masak dan peralatan dapur."}'

# Delete category by ID
curl -sS -X DELETE "$BASE_URL/categories/1"
