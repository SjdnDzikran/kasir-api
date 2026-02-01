#!/usr/bin/env sh

# Health
curl -sS "http://localhost:8080/health"

# List products
curl -sS "http://localhost:8080/api/produk"

# Create product
curl -sS -X POST "http://localhost:8080/api/produk" \
  -H "Content-Type: application/json" \
  -d '{"name":"Teh Botol","price":8000,"stock":30}'

# Get product by ID
curl -sS "http://localhost:8080/api/produk/1"

# Update product by ID
curl -sS -X PUT "http://localhost:8080/api/produk/1" \
  -H "Content-Type: application/json" \
  -d '{"name":"Teh Botol Sosro","price":9000,"stock":25}'

# Delete product by ID
curl -sS -X DELETE "http://localhost:8080/api/produk/1"

# List categories
curl -sS "http://localhost:8080/categories"

# Create category
curl -sS -X POST "http://localhost:8080/categories" \
  -H "Content-Type: application/json" \
  -d '{"name":"Peralatan Rumah","description":"Peralatan rumah tangga."}'

# Get category by ID
curl -sS "http://localhost:8080/categories/1"

# Update category by ID
curl -sS -X PUT "http://localhost:8080/categories/1" \
  -H "Content-Type: application/json" \
  -d '{"name":"Peralatan Dapur","description":"Alat masak dan peralatan dapur."}'

# Delete category by ID
curl -sS -X DELETE "http://localhost:8080/categories/1"
