#!/usr/bin/env bash

# Colors for output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Base URLs
LOCAL_URL="http://localhost:8080"
PROD_URL="https://kasir-api-production-7cb2.up.railway.app"

# Current selections
BASE_URL=""

print_header() {
    echo -e "${BLUE}=================================${NC}"
    echo -e "${BLUE}    Kasir API Test CLI${NC}"
    echo -e "${BLUE}=================================${NC}"
    echo ""
}

select_environment() {
    print_header
    echo -e "${YELLOW}Select Environment:${NC}"
    echo "1) Local ($LOCAL_URL)"
    echo "2) Production ($PROD_URL)"
    echo ""
    read -p "Choose [1-2]: " env_choice
    
    case $env_choice in
        1)
            BASE_URL=$LOCAL_URL
            echo -e "${GREEN}✓ Selected: Local${NC}"
            ;;
        2)
            BASE_URL=$PROD_URL
            echo -e "${GREEN}✓ Selected: Production${NC}"
            ;;
        *)
            echo -e "${RED}Invalid choice. Defaulting to Local.${NC}"
            BASE_URL=$LOCAL_URL
            ;;
    esac
    echo ""
}

select_resource() {
    print_header
    echo -e "${YELLOW}Select Resource:${NC}"
    echo "1) Products"
    echo "2) Categories"
    echo "3) Health Check"
    echo ""
    read -p "Choose [1-3]: " res_choice
    
    case $res_choice in
        1)
            select_product_method
            ;;
        2)
            select_category_method
            ;;
        3)
            health_check
            ;;
        *)
            echo -e "${RED}Invalid choice${NC}"
            ;;
    esac
}

select_product_method() {
    print_header
    echo -e "${YELLOW}Select Product Method:${NC}"
    echo "1) GET  - List all products"
    echo "2) GET  - Get product by ID"
    echo "3) POST - Create product"
    echo "4) PUT  - Update product"
    echo "5) DELETE - Delete product"
    echo "0) Back"
    echo ""
    read -p "Choose [0-5]: " method_choice
    
    case $method_choice in
        1)
            echo -e "\n${GREEN}GET $BASE_URL/api/products${NC}"
            curl -sS "$BASE_URL/api/products" | jq '.' 2>/dev/null || curl -sS "$BASE_URL/api/products"
            echo ""
            ;;
        2)
            read -p "Enter Product ID: " product_id
            echo -e "\n${GREEN}GET $BASE_URL/api/products/$product_id${NC}"
            curl -sS "$BASE_URL/api/products/$product_id" | jq '.' 2>/dev/null || curl -sS "$BASE_URL/api/products/$product_id"
            echo ""
            ;;
        3)
            read -p "Enter Product Name: " name
            read -p "Enter Price: " price
            read -p "Enter Stock: " stock
            echo -e "\n${GREEN}POST $BASE_URL/api/products${NC}"
            curl -sS -X POST "$BASE_URL/api/products" \
              -H "Content-Type: application/json" \
              -d "{\"name\":\"$name\",\"price\":$price,\"stock\":$stock}" | jq '.' 2>/dev/null || curl -sS -X POST "$BASE_URL/api/products" \
              -H "Content-Type: application/json" \
              -d "{\"name\":\"$name\",\"price\":$price,\"stock\":$stock}"
            echo ""
            ;;
        4)
            read -p "Enter Product ID: " product_id
            read -p "Enter Product Name: " name
            read -p "Enter Price: " price
            read -p "Enter Stock: " stock
            echo -e "\n${GREEN}PUT $BASE_URL/api/products/$product_id${NC}"
            curl -sS -X PUT "$BASE_URL/api/products/$product_id" \
              -H "Content-Type: application/json" \
              -d "{\"name\":\"$name\",\"price\":$price,\"stock\":$stock}" | jq '.' 2>/dev/null || curl -sS -X PUT "$BASE_URL/api/products/$product_id" \
              -H "Content-Type: application/json" \
              -d "{\"name\":\"$name\",\"price\":$price,\"stock\":$stock}"
            echo ""
            ;;
        5)
            read -p "Enter Product ID: " product_id
            echo -e "\n${GREEN}DELETE $BASE_URL/api/products/$product_id${NC}"
            curl -sS -X DELETE "$BASE_URL/api/products/$product_id" | jq '.' 2>/dev/null || curl -sS -X DELETE "$BASE_URL/api/products/$product_id"
            echo ""
            ;;
        0)
            return
            ;;
        *)
            echo -e "${RED}Invalid choice${NC}"
            ;;
    esac
    
    echo ""
    read -p "Press Enter to continue..."
}

select_category_method() {
    print_header
    echo -e "${YELLOW}Select Category Method:${NC}"
    echo "1) GET  - List all categories"
    echo "2) GET  - Get category by ID"
    echo "3) POST - Create category"
    echo "4) PUT  - Update category"
    echo "5) DELETE - Delete category"
    echo "0) Back"
    echo ""
    read -p "Choose [0-5]: " method_choice
    
    case $method_choice in
        1)
            echo -e "\n${GREEN}GET $BASE_URL/api/categories${NC}"
            curl -sS "$BASE_URL/api/categories" | jq '.' 2>/dev/null || curl -sS "$BASE_URL/api/categories"
            echo ""
            ;;
        2)
            read -p "Enter Category ID: " category_id
            echo -e "\n${GREEN}GET $BASE_URL/api/categories/$category_id${NC}"
            curl -sS "$BASE_URL/api/categories/$category_id" | jq '.' 2>/dev/null || curl -sS "$BASE_URL/api/categories/$category_id"
            echo ""
            ;;
        3)
            read -p "Enter Category Name: " name
            read -p "Enter Description: " description
            echo -e "\n${GREEN}POST $BASE_URL/api/categories${NC}"
            curl -sS -X POST "$BASE_URL/api/categories" \
              -H "Content-Type: application/json" \
              -d "{\"name\":\"$name\",\"description\":\"$description\"}" | jq '.' 2>/dev/null || curl -sS -X POST "$BASE_URL/api/categories" \
              -H "Content-Type: application/json" \
              -d "{\"name\":\"$name\",\"description\":\"$description\"}"
            echo ""
            ;;
        4)
            read -p "Enter Category ID: " category_id
            read -p "Enter Category Name: " name
            read -p "Enter Description: " description
            echo -e "\n${GREEN}PUT $BASE_URL/api/categories/$category_id${NC}"
            curl -sS -X PUT "$BASE_URL/api/categories/$category_id" \
              -H "Content-Type: application/json" \
              -d "{\"name\":\"$name\",\"description\":\"$description\"}" | jq '.' 2>/dev/null || curl -sS -X PUT "$BASE_URL/api/categories/$category_id" \
              -H "Content-Type: application/json" \
              -d "{\"name\":\"$name\",\"description\":\"$description\"}"
            echo ""
            ;;
        5)
            read -p "Enter Category ID: " category_id
            echo -e "\n${GREEN}DELETE $BASE_URL/api/categories/$category_id${NC}"
            curl -sS -X DELETE "$BASE_URL/api/categories/$category_id" | jq '.' 2>/dev/null || curl -sS -X DELETE "$BASE_URL/api/categories/$category_id"
            echo ""
            ;;
        0)
            return
            ;;
        *)
            echo -e "${RED}Invalid choice${NC}"
            ;;
    esac
    
    echo ""
    read -p "Press Enter to continue..."
}

health_check() {
    echo -e "\n${GREEN}GET $BASE_URL/health${NC}"
    curl -sS "$BASE_URL/health" | jq '.' 2>/dev/null || curl -sS "$BASE_URL/health"
    echo ""
    read -p "Press Enter to continue..."
}

# Main loop
select_environment

while true; do
    print_header
    echo -e "${YELLOW}Current Environment:${NC} $BASE_URL"
    echo -e "${YELLOW}Select Resource:${NC}"
    echo "1) Products"
    echo "2) Categories"
    echo "3) Health Check"
    echo "4) Change Environment"
    echo "0) Exit"
    echo ""
    read -p "Choose [0-4]: " main_choice
    
    case $main_choice in
        1)
            select_product_method
            ;;
        2)
            select_category_method
            ;;
        3)
            health_check
            ;;
        4)
            select_environment
            ;;
        0)
            echo -e "${GREEN}Goodbye!${NC}"
            exit 0
            ;;
        *)
            echo -e "${RED}Invalid choice${NC}"
            sleep 1
            ;;
    esac
done
