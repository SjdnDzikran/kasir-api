package repositories

import (
	"database/sql"
	"kasir-api/models"
	"time"
)

type ReportRepository struct {
	db *sql.DB
}

func NewReportRepository(db *sql.DB) *ReportRepository {
	return &ReportRepository{db: db}
}

func (r *ReportRepository) GetDailyReport() (*models.DailyReport, error) {
	today := time.Now().Format("2006-01-02")

	var totalRevenue int
	err := r.db.QueryRow("SELECT COALESCE(SUM(total_amount), 0) FROM transactions WHERE DATE(created_at) = $1", today).Scan(&totalRevenue)
	if err != nil {
		return nil, err
	}

	var totalTransactions int
	err = r.db.QueryRow("SELECT COUNT(*) FROM transactions WHERE DATE(created_at) = $1", today).Scan(&totalTransactions)
	if err != nil {
		return nil, err
	}

	var bestSellerName string
	var bestSellerQty int
	err = r.db.QueryRow(`
		SELECT p.name, SUM(td.quantity) as total_sold
		FROM transaction_details td
		JOIN transactions t ON t.id = td.transaction_id
		JOIN product p ON p.id = td.product_id
		WHERE DATE(t.created_at) = $1
		GROUP BY p.id, p.name
		ORDER BY total_sold DESC
		LIMIT 1
	`, today).Scan(&bestSellerName, &bestSellerQty)
	if err != nil {
		if err == sql.ErrNoRows {
			bestSellerName = ""
			bestSellerQty = 0
		} else {
			return nil, err
		}
	}

	return &models.DailyReport{
		TotalRevenue:      totalRevenue,
		TotalTransactions: totalTransactions,
		BestSeller: models.BestSeller{
			Name:    bestSellerName,
			QtySold: bestSellerQty,
		},
	}, nil
}
