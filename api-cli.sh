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

# fzf configuration
FZF_OPTS=(
    --border
    --height 40%
    --layout=reverse
    --prompt="➤ "
    --header=" "
    --info=inline
)

print_header() {
    echo -e "${BLUE}=================================${NC}"
    echo -e "${BLUE}    Kasir API Test CLI${NC}"
    echo -e "${BLUE}=================================${NC}"
    echo ""
}

select_environment() {
    print_header
    echo -e "${YELLOW}Select Environment:${NC}"
    
    choice=$(echo -e "Local ($LOCAL_URL)\nProduction ($PROD_URL)" | fzf "${FZF_OPTS[@]}" --header "Select Environment")
    
    if [[ $choice == *"Local"* ]]; then
        BASE_URL=$LOCAL_URL
        echo -e "${GREEN}✓ Selected: Local${NC}"
    elif [[ $choice == *"Production"* ]]; then
        BASE_URL=$PROD_URL
        echo -e "${GREEN}✓ Selected: Production${NC}"
    else
        echo -e "${RED}✗ Cancelled${NC}"
        return 1
    fi
    echo ""
    sleep 1
}

select_resource() {
    print_header
    echo -e "${YELLOW}Current Environment:${NC} $BASE_URL"
    echo ""
    
    choice=$(echo -e "Products\nCategories\nTransactions\nHealth Check\nChange Environment\nExit" | fzf "${FZF_OPTS[@]}" --header "Select Resource")
    
    case $choice in
        "Products")
            select_product_method
            ;;
        "Categories")
            select_category_method
            ;;
        "Transactions")
            select_transaction_method
            ;;
        "Health Check")
            health_check
            ;;
        "Change Environment")
            select_environment
            ;;
        "Exit")
            echo -e "${GREEN}Goodbye!${NC}"
            exit 0
            ;;
        *)
            echo -e "${RED}✗ Cancelled${NC}"
            sleep 1
            ;;
    esac
}

select_product_method() {
    choice=$(echo -e "GET - List all products\nGET - Get product by ID\nPOST - Create product\nPUT - Update product\nDELETE - Delete product\nBack" | fzf "${FZF_OPTS[@]}" --header "Select Product Method")
    
    case $choice in
        *"List all"*)
            echo -e "\n${GREEN}GET $BASE_URL/api/products${NC}"
            curl -sS "$BASE_URL/api/products" | jq '.' 2>/dev/null || curl -sS "$BASE_URL/api/products"
            echo ""
            ;;
        *"Get product by ID"*)
            product_id=$(echo "" | fzf "${FZF_OPTS[@]}" --print-query --header "Enter Product ID" | tail -1)
            if [ -n "$product_id" ]; then
                echo -e "\n${GREEN}GET $BASE_URL/api/products/$product_id${NC}"
                curl -sS "$BASE_URL/api/products/$product_id" | jq '.' 2>/dev/null || curl -sS "$BASE_URL/api/products/$product_id"
                echo ""
            else
                echo -e "${RED}✗ Cancelled${NC}"
            fi
            ;;
        *"Create product"*)
            name=$(echo "" | fzf "${FZF_OPTS[@]}" --print-query --header "Enter Product Name" | tail -1)
            [ -z "$name" ] && echo -e "${RED}✗ Cancelled${NC}" && return
            price=$(echo "" | fzf "${FZF_OPTS[@]}" --print-query --header "Enter Price" | tail -1)
            [ -z "$price" ] && echo -e "${RED}✗ Cancelled${NC}" && return
            stock=$(echo "" | fzf "${FZF_OPTS[@]}" --print-query --header "Enter Stock" | tail -1)
            [ -z "$stock" ] && echo -e "${RED}✗ Cancelled${NC}" && return
            
            echo -e "\n${GREEN}POST $BASE_URL/api/products${NC}"
            curl -sS -X POST "$BASE_URL/api/products" \
              -H "Content-Type: application/json" \
              -d "{\"name\":\"$name\",\"price\":$price,\"stock\":$stock}" | jq '.' 2>/dev/null || curl -sS -X POST "$BASE_URL/api/products" \
              -H "Content-Type: application/json" \
              -d "{\"name\":\"$name\",\"price\":$price,\"stock\":$stock}"
            echo ""
            ;;
        *"Update product"*)
            product_id=$(echo "" | fzf "${FZF_OPTS[@]}" --print-query --header "Enter Product ID" | tail -1)
            [ -z "$product_id" ] && echo -e "${RED}✗ Cancelled${NC}" && return
            name=$(echo "" | fzf "${FZF_OPTS[@]}" --print-query --header "Enter Product Name" | tail -1)
            [ -z "$name" ] && echo -e "${RED}✗ Cancelled${NC}" && return
            price=$(echo "" | fzf "${FZF_OPTS[@]}" --print-query --header "Enter Price" | tail -1)
            [ -z "$price" ] && echo -e "${RED}✗ Cancelled${NC}" && return
            stock=$(echo "" | fzf "${FZF_OPTS[@]}" --print-query --header "Enter Stock" | tail -1)
            [ -z "$stock" ] && echo -e "${RED}✗ Cancelled${NC}" && return
            
            echo -e "\n${GREEN}PUT $BASE_URL/api/products/$product_id${NC}"
            curl -sS -X PUT "$BASE_URL/api/products/$product_id" \
              -H "Content-Type: application/json" \
              -d "{\"name\":\"$name\",\"price\":$price,\"stock\":$stock}" | jq '.' 2>/dev/null || curl -sS -X PUT "$BASE_URL/api/products/$product_id" \
              -H "Content-Type: application/json" \
              -d "{\"name\":\"$name\",\"price\":$price,\"stock\":$stock}"
            echo ""
            ;;
        *"Delete product"*)
            product_id=$(echo "" | fzf "${FZF_OPTS[@]}" --print-query --header "Enter Product ID" | tail -1)
            if [ -n "$product_id" ]; then
                echo -e "\n${GREEN}DELETE $BASE_URL/api/products/$product_id${NC}"
                curl -sS -X DELETE "$BASE_URL/api/products/$product_id" | jq '.' 2>/dev/null || curl -sS -X DELETE "$BASE_URL/api/products/$product_id"
                echo ""
            else
                echo -e "${RED}✗ Cancelled${NC}"
            fi
            ;;
        "Back")
            return
            ;;
        *)
            echo -e "${RED}✗ Cancelled${NC}"
            ;;
    esac
    
    echo ""
    echo "Press any key to continue..."
    read -n 1
}

select_category_method() {
    choice=$(echo -e "GET - List all categories\nGET - Get category by ID\nPOST - Create category\nPUT - Update category\nDELETE - Delete category\nBack" | fzf "${FZF_OPTS[@]}" --header "Select Category Method")
    
    case $choice in
        *"List all"*)
            echo -e "\n${GREEN}GET $BASE_URL/api/categories${NC}"
            curl -sS "$BASE_URL/api/categories" | jq '.' 2>/dev/null || curl -sS "$BASE_URL/api/categories"
            echo ""
            ;;
        *"Get category by ID"*)
            category_id=$(echo "" | fzf "${FZF_OPTS[@]}" --print-query --header "Enter Category ID" | tail -1)
            if [ -n "$category_id" ]; then
                echo -e "\n${GREEN}GET $BASE_URL/api/categories/$category_id${NC}"
                curl -sS "$BASE_URL/api/categories/$category_id" | jq '.' 2>/dev/null || curl -sS "$BASE_URL/api/categories/$category_id"
                echo ""
            else
                echo -e "${RED}✗ Cancelled${NC}"
            fi
            ;;
        *"Create category"*)
            name=$(echo "" | fzf "${FZF_OPTS[@]}" --print-query --header "Enter Category Name" | tail -1)
            [ -z "$name" ] && echo -e "${RED}✗ Cancelled${NC}" && return
            description=$(echo "" | fzf "${FZF_OPTS[@]}" --print-query --header "Enter Description" | tail -1)
            [ -z "$description" ] && echo -e "${RED}✗ Cancelled${NC}" && return
            
            echo -e "\n${GREEN}POST $BASE_URL/api/categories${NC}"
            curl -sS -X POST "$BASE_URL/api/categories" \
              -H "Content-Type: application/json" \
              -d "{\"name\":\"$name\",\"description\":\"$description\"}" | jq '.' 2>/dev/null || curl -sS -X POST "$BASE_URL/api/categories" \
              -H "Content-Type: application/json" \
              -d "{\"name\":\"$name\",\"description\":\"$description\"}"
            echo ""
            ;;
        *"Update category"*)
            category_id=$(echo "" | fzf "${FZF_OPTS[@]}" --print-query --header "Enter Category ID" | tail -1)
            [ -z "$category_id" ] && echo -e "${RED}✗ Cancelled${NC}" && return
            name=$(echo "" | fzf "${FZF_OPTS[@]}" --print-query --header "Enter Category Name" | tail -1)
            [ -z "$name" ] && echo -e "${RED}✗ Cancelled${NC}" && return
            description=$(echo "" | fzf "${FZF_OPTS[@]}" --print-query --header "Enter Description" | tail -1)
            [ -z "$description" ] && echo -e "${RED}✗ Cancelled${NC}" && return
            
            echo -e "\n${GREEN}PUT $BASE_URL/api/categories/$category_id${NC}"
            curl -sS -X PUT "$BASE_URL/api/categories/$category_id" \
              -H "Content-Type: application/json" \
              -d "{\"name\":\"$name\",\"description\":\"$description\"}" | jq '.' 2>/dev/null || curl -sS -X PUT "$BASE_URL/api/categories/$category_id" \
              -H "Content-Type: application/json" \
              -d "{\"name\":\"$name\",\"description\":\"$description\"}"
            echo ""
            ;;
        *"Delete category"*)
            category_id=$(echo "" | fzf "${FZF_OPTS[@]}" --print-query --header "Enter Category ID" | tail -1)
            if [ -n "$category_id" ]; then
                echo -e "\n${GREEN}DELETE $BASE_URL/api/categories/$category_id${NC}"
                curl -sS -X DELETE "$BASE_URL/api/categories/$category_id" | jq '.' 2>/dev/null || curl -sS -X DELETE "$BASE_URL/api/categories/$category_id"
                echo ""
            else
                echo -e "${RED}✗ Cancelled${NC}"
            fi
            ;;
        "Back")
            return
            ;;
        *)
            echo -e "${RED}✗ Cancelled${NC}"
            ;;
    esac
    
    echo ""
    echo "Press any key to continue..."
    read -n 1
}

select_transaction_method() {
    choice=$(echo -e "POST - Checkout (Create Transaction)\nBack" | fzf "${FZF_OPTS[@]}" --header "Select Transaction Method")
    
    case $choice in
        *"Checkout"*)
            echo -e "${YELLOW}Enter items for checkout (format: product_id,quantity)${NC}"
            echo -e "${YELLOW}Press Enter with empty line to finish${NC}"
            
            items=()
            while true; do
                item_input=$(echo "" | fzf "${FZF_OPTS[@]}" --print-query --header "Enter item (product_id,quantity) or press Enter to finish" | tail -1)
                
                if [ -z "$item_input" ]; then
                    break
                fi
                
                IFS=',' read -r product_id quantity <<< "$item_input"
                
                if [ -z "$product_id" ] || [ -z "$quantity" ]; then
                    echo -e "${RED}✗ Invalid format. Use: product_id,quantity${NC}"
                    continue
                fi
                
                items+=("{\"product_id\":$product_id,\"quantity\":$quantity}")
            done
            
            if [ ${#items[@]} -eq 0 ]; then
                echo -e "${RED}✗ No items added. Cancelled.${NC}"
                return
            fi
            
            # Build JSON array
            items_json=$(IFS=,; echo "${items[*]}")
            json_data="{\"items\":[$items_json]}"
            
            echo -e "\n${GREEN}POST $BASE_URL/api/checkout${NC}"
            echo -e "${BLUE}Request:${NC} $json_data"
            curl -sS -X POST "$BASE_URL/api/checkout" \
              -H "Content-Type: application/json" \
              -d "$json_data" | jq '.' 2>/dev/null || curl -sS -X POST "$BASE_URL/api/checkout" \
              -H "Content-Type: application/json" \
              -d "$json_data"
            echo ""
            ;;
        "Back")
            return
            ;;
        *)
            echo -e "${RED}✗ Cancelled${NC}"
            ;;
    esac
    
    echo ""
    echo "Press any key to continue..."
    read -n 1
}

health_check() {
    echo -e "\n${GREEN}GET $BASE_URL/health${NC}"
    curl -sS "$BASE_URL/health" | jq '.' 2>/dev/null || curl -sS "$BASE_URL/health"
    echo ""
    echo "Press any key to continue..."
    read -n 1
}

# Main loop
select_environment

while true; do
    select_resource
done
