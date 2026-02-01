package main

import (
	"os"
	"fmt"
	"kasir-api/database"
	"kasir-api/handlers"
	"kasir-api/repositories"
	"kasir-api/services"
	"net/http"
	"strings"
	"github.com/spf13/viper"
)

// var produk = []models.Product{
// 	{ID: 1, Name: "Kartu by.U", Price: 33000, Stock: 10},
// 	{ID: 2, Name: "Susu Ultra Milk", Price: 15000, Stock: 20},
// }

// var categories = []models.Category{
// 	{ID: 1, Name: "Elektronik", Description: "Perangkat elektronik seperti ponsel, laptop, dan lainnya."},
// 	{ID: 2, Name: "Pakaian", Description: "Berbagai jenis pakaian untuk pria, wanita, dan anak-anak."},
// 	{ID: 3, Name: "Makanan", Description: "Produk makanan dan minuman dari berbagai kategori."},
// }

// func getProdukByID(w http.ResponseWriter, r *http.Request) {
// 	id := r.URL.Path[len("/api/produk/"):]
// 	for _, p := range produk {
// 		if fmt.Sprintf("%d", p.ID) == id {
// 			w.Header().Set("Content-Type", "application/json")
// 			json.NewEncoder(w).Encode(p)
// 			return
// 		}
// 	}
// 	http.Error(w, "Produk not found", http.StatusNotFound)
// }

// func getCategoryByID(w http.ResponseWriter, r *http.Request) {
// 	id := r.URL.Path[len("/categories/"):]
// 	for _, c := range categories {
// 		if fmt.Sprintf("%d", c.ID) == id {
// 			w.Header().Set("Content-Type", "application/json")
// 			json.NewEncoder(w).Encode(c)
// 			return
// 		}
// 	}
// 	http.Error(w, "Category not found", http.StatusNotFound)
// }

// func updateProdukByID(w http.ResponseWriter, r *http.Request) {
// 	// get id dari request URL
// 	idStr := strings.TrimPrefix(r.URL.Path, "/api/produk/")
// 	//id := r.URL.Path[len("/api/produk/"):]

// 	// ganti int
// 	id, err := strconv.Atoi(idStr)
// 	if err != nil {
// 		http.Error(w, "Invalid Produk ID", http.StatusBadRequest)
// 		return
// 	}
// 	// get data dari request
// 	var updatedProduk models.Product
// 	err = json.NewDecoder(r.Body).Decode(&updatedProduk)
// 	if err != nil {
// 		http.Error(w, "Invalid input", http.StatusBadRequest)
// 		return
// 	}

// 	// loop produk, cari id, ganti data
// 	for i  := range produk {
// 		if produk[i].ID == id {
// 			updatedProduk.ID = id
// 			produk[i] = updatedProduk

// 			w.Header().Set("Content-Type", "application/json")
// 			json.NewEncoder(w).Encode(produk[i])
// 			return
// 		}
// 	}
// 	http.Error(w, "Produk not found", http.StatusNotFound)
// }

// func updateCategoryByID(w http.ResponseWriter, r *http.Request) {
// 	idStr := strings.TrimPrefix(r.URL.Path, "/categories/")
// 	id, err := strconv.Atoi(idStr)
// 	if err != nil {
// 		http.Error(w, "Invalid Category ID", http.StatusBadRequest)
// 		return
// 	}

// 	var updatedCategory models.Category
// 	err = json.NewDecoder(r.Body).Decode(&updatedCategory)
// 	if err != nil {
// 		http.Error(w, "Invalid input", http.StatusBadRequest)
// 		return
// 	}

// 	for i := range categories {
// 		if categories[i].ID == id {
// 			updatedCategory.ID = id
// 			categories[i] = updatedCategory

// 			w.Header().Set("Content-Type", "application/json")
// 			json.NewEncoder(w).Encode(categories[i])
// 			return
// 		}
// 	}
// 	http.Error(w, "Category not found", http.StatusNotFound)
// }

// func deleteProdukByID(w http.ResponseWriter, r *http.Request) {
// 	idStr := strings.TrimPrefix(r.URL.Path, "/api/produk/")
// 	id, err := strconv.Atoi(idStr)
// 	if err != nil {
// 		http.Error(w, "Invalid Produk ID", http.StatusBadRequest)
// 		return
// 	}

// 	for i := range produk {
// 		if produk[i].ID == id {
// 			produk = append(produk[:i], produk[i+1:]...)
// 			w.WriteHeader(http.StatusNoContent)
// 			json.NewEncoder(w).Encode(map[string]string{
// 				"message": "Produk deleted successfully",
// 			})
// 			return
// 		}
// 	}
// 	http.Error(w, "Produk not found", http.StatusNotFound)
// }

// func deleteCategoryByID(w http.ResponseWriter, r *http.Request) {
// 	idStr := strings.TrimPrefix(r.URL.Path, "/categories/")
// 	id, err := strconv.Atoi(idStr)
// 	if err != nil {
// 		http.Error(w, "Invalid Category ID", http.StatusBadRequest)
// 		return
// 	}

// 	for i := range categories {
// 		if categories[i].ID == id {
// 			categories = append(categories[:i], categories[i+1:]...)
// 			w.WriteHeader(http.StatusNoContent)
// 			json.NewEncoder(w).Encode(map[string]string{
// 				"message": "Category deleted successfully",
// 			})
// 			return
// 		}
// 	}
// 	http.Error(w, "Category not found", http.StatusNotFound)
// }

// // GET localhost:8080/api/produk/{id}
// // PUT localhost:8080/api/produk/{id}
// // DELETE localhost:8080/api/produk/{id}
// http.HandleFunc("/api/produk/", func(w http.ResponseWriter, r *http.Request) {
// 	switch r.Method {
// 	case "GET":
// 		getProdukByID(w, r)
// 		return
// 	case "PUT":
// 		updateProdukByID(w, r)
// 		return
// 	case "DELETE":
// 		deleteProdukByID(w, r)
// 		return
// 	}
// })

// // GET localhost:8080/categories
// // POST localhost:8080/categories
// http.HandleFunc("/categories", func(w http.ResponseWriter, r *http.Request) {
// 	switch r.Method {
// 	case "GET":
// 		w.Header().Set("Content-Type", "application/json")
// 		json.NewEncoder(w).Encode(categories)
// 	case "POST":
// 		var newCategory models.Category
// 		err := json.NewDecoder(r.Body).Decode(&newCategory)
// 		if err != nil {
// 			http.Error(w, "Invalid input", http.StatusBadRequest)
// 			return
// 		}
// 		newCategory.ID = len(categories) + 1
// 		categories = append(categories, newCategory)
// 		w.WriteHeader(http.StatusCreated)
// 		json.NewEncoder(w).Encode(newCategory)
// 	default:
// 		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
// 	}
// })
// // GET localhost:8080/produk
// // POST localhost:8080/produk
// http.HandleFunc("/api/produk", func(w http.ResponseWriter, r *http.Request) {
// 	switch r.Method {
// 	case "GET":
// 		w.Header().Set("Content-Type", "application/json")
// 		json.NewEncoder(w).Encode(produk)
// 	case "POST":
// 		// baca data dari body request
// 		var newProduk models.Product
// 		err := json.NewDecoder(r.Body).Decode(&newProduk)
// 		if err != nil {
// 			http.Error(w, "Invalid input", http.StatusBadRequest)
// 			return
// 		}
// 		// tambahkan produk baru ke slice
// 		newProduk.ID = len(produk) + 1
// 		produk = append(produk, newProduk)
// 		w.WriteHeader(http.StatusCreated)
// 		json.NewEncoder(w).Encode(newProduk)
// 	default:
// 		http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
// 	}
// })

// // GET localhost:8080/health
// http.HandleFunc("/health", func(w http.ResponseWriter, r *http.Request) {
// 	w.Header().Set("Content-Type", "application/json")
// 	json.NewEncoder(w).Encode(map[string]string{
// 		"status":  "ok",
// 		"message": "Server is healthy",
// 	})
// })

type Config struct {
	Port               string `mapstructure:"PORT"`
	DBConnectionString string `mapstructure:"DB_CONNECTION_STRING"`
}

func main() {

	viper.AutomaticEnv()
	viper.SetEnvKeyReplacer(strings.NewReplacer(".", "_"))

	if _, err := os.Stat(".env"); err == nil {
		viper.SetConfigFile(".env")
		_ = viper.ReadInConfig()
	}

	config := Config{
		Port:               viper.GetString("PORT"),
		DBConnectionString: viper.GetString("DB_CONNECTION_STRING"),
	}

	db, err := database.InitDB(config.DBConnectionString)
	if err != nil {
		fmt.Println("Failed to connect to database:", err)
		return
	}
	defer db.Close()

	// Initialize repositories, services, and handlers for depenedency injection
	productRepo := repositories.NewProductRepository(db)
	productService := services.NewProductService(productRepo)
	productHandler := handlers.NewProductHandler(productService)

	categoryRepo := repositories.NewCategoryRepository(db)
	categoryService := services.NewCategoryService(categoryRepo)
	categoryHandler := handlers.NewCategoryHandler(categoryService)

	http.HandleFunc("/api/products", productHandler.HandleProducts)
	http.HandleFunc("/api/products/", productHandler.HandleProductByID)
	http.HandleFunc("/api/categories", categoryHandler.HandleCategories)
	http.HandleFunc("/api/categories/", categoryHandler.HandleCategoryByID)

	addr := "0.0.0.0:" + config.Port
	fmt.Println("Server is starting on port", config.Port)
	err = http.ListenAndServe(addr, nil)
	if err != nil {
		fmt.Println("Server failed to start:", err)
	}
}
