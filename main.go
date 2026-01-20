package main

import (
	"encoding/json"
	"fmt"
	"net/http"
	"strconv"
	"strings"
)

type Produk struct {
	ID    int    `json:"id"`
	Nama  string `json:"nama"`
	Harga int    `json:"harga"`
	Stock int    `json:"stock"`
}

var produk = []Produk{
	{ID: 1, Nama: "Kartu by.U", Harga: 33000, Stock: 10},
	{ID: 2, Nama: "Susu Ultra Milk", Harga: 15000, Stock: 20},
}

func getProdukByID(w http.ResponseWriter, r *http.Request) {
	id := r.URL.Path[len("/api/produk/"):]
	for _, p := range produk {
		if fmt.Sprintf("%d", p.ID) == id {
			w.Header().Set("Content-Type", "application/json")
			json.NewEncoder(w).Encode(p)
			return
		}
	}
	http.Error(w, "Produk not found", http.StatusNotFound)
}

func updatedProdukByID(w http.ResponseWriter, r *http.Request) {
	// get id dari request URL
	idStr := strings.TrimPrefix(r.URL.Path, "/api/produk/")
	//id := r.URL.Path[len("/api/produk/"):]

	

	// ganti int
	id, err := strconv.Atoi(idStr)
	if err != nil {
		http.Error(w, "Invalid Produk ID", http.StatusBadRequest)
		return
	}
	// get data dari request
	var updatedProduk Produk
	err = json.NewDecoder(r.Body).Decode(&updatedProduk)
	if err != nil {
		http.Error(w, "Invalid input", http.StatusBadRequest)
		return
	}

	// loop produk, cari id, ganti data
	for i  := range produk {
		if produk[i].ID == id {
			updatedProduk.ID = id
			produk[i] = updatedProduk

			w.Header().Set("Content-Type", "application/json")
			json.NewEncoder(w).Encode(produk[i])
			return
		}
	}
	http.Error(w, "Produk not found", http.StatusNotFound)
}

func deleteProdukByID(w http.ResponseWriter, r *http.Request) {
	idStr := strings.TrimPrefix(r.URL.Path, "/api/produk/")
	id, err := strconv.Atoi(idStr)
	if err != nil {
		http.Error(w, "Invalid Produk ID", http.StatusBadRequest)
		return
	}

	for i := range produk {
		if produk[i].ID == id {
			produk = append(produk[:i], produk[i+1:]...)
			w.WriteHeader(http.StatusNoContent)
			json.NewEncoder(w).Encode(map[string]string{
				"message": "Produk deleted successfully",
			})
			return
		}
	}
	http.Error(w, "Produk not found", http.StatusNotFound)
}

func main() {
	// GET localhost:8080/api/produk/{id}
	// PUT localhost:8080/api/produk/{id}
	// DELETE localhost:8080/api/produk/{id}
	http.HandleFunc("/api/produk/", func(w http.ResponseWriter, r *http.Request) {
		if r.Method == "GET" {
			getProdukByID(w, r)
			return
		} else if r.Method == "PUT" {
			updatedProdukByID(w, r)
			return
		} else if r.Method == "DELETE" {
			deleteProdukByID(w, r)
			return
		}
	})

	// GET localhost:8080/produk
	// POST localhost:8080/produk
	http.HandleFunc("/api/produk", func(w http.ResponseWriter, r *http.Request) {
		switch r.Method {
		case "GET":
			w.Header().Set("Content-Type", "application/json")
			json.NewEncoder(w).Encode(produk)
		case "POST":
			// baca data dari body request
			var newProduk Produk
			err := json.NewDecoder(r.Body).Decode(&newProduk)
			if err != nil {
				http.Error(w, "Invalid input", http.StatusBadRequest)
				return
			}
			// tambahkan produk baru ke slice
			newProduk.ID = len(produk) + 1
			produk = append(produk, newProduk)
			w.WriteHeader(http.StatusCreated)
			json.NewEncoder(w).Encode(newProduk)
		default:
			http.Error(w, "Method not allowed", http.StatusMethodNotAllowed)
		}
	})

	// GET localhost:8080/health
	http.HandleFunc("/health", func(w http.ResponseWriter, r *http.Request) {
		w.Header().Set("Content-Type", "application/json")
		json.NewEncoder(w).Encode(map[string]string{
			"status":  "ok",
			"message": "Server is healthy",
		})
	})
	fmt.Println("Server is starting on port 8080...")
	err := http.ListenAndServe(":8080", nil)
	if err != nil {
		fmt.Println("Server failed to start:", err)
	}
}
