package models

type DailyReport struct {
	TotalRevenue      int        `json:"total_revenue"`
	TotalTransactions int        `json:"total_transaksi"`
	BestSeller        BestSeller `json:"produk_terlaris"`
}

type BestSeller struct {
	Name    string `json:"nama"`
	QtySold int    `json:"qty_terjual"`
}
