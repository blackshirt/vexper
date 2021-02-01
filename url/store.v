module url

//import sqlite
pub fn (c CPool) all_rup() []Rup {
	mut rups := []Rup{}
	q := "select nama_satker, kode_satker, kode_rup, nama_paket, sumber_dana, \
	pagu, awal_pemilihan, tipe, kegiatan, metode, tahun, last_updated from v_rups \
	group by nama_satker"
	rows, _ := c.exec(q)
	for item in rows {
		mut rup := Rup{}
		rup.nama_satker = item.vals[0]
		rup.kode_satker = item.vals[1]
		rup.kode_rup = item.vals[2]
		rup.nama_paket = item.vals[3]
		rup.sumber_dana = item.vals[4]
		rup.pagu = item.vals[5]
		rup.awal_pemilihan = item.vals[6]
		rup.tipe = item.vals[7]
		rup.kegiatan = item.vals[8]
		rup.metode = item.vals[9]
		// rup.jenis = jenis_pengadaan_from_str(item[11].str())
		rup.year = item.vals[10]
		rup.last_updated = item.vals[11]
		rups << rup
	}
	return rups
}
pub fn (c CPool) rup_with_tipe(tk TipeKeg) []Rup {
	mut rups := []Rup{}
	q := "select nama_satker, kode_satker, kode_rup, nama_paket, sumber_dana, \
	pagu, awal_pemilihan, tipe, kegiatan, metode, tahun, last_updated from v_rups \
	where tipe='$tk'"
	rows, _ := c.exec(q)
	for item in rows {
		mut rup := Rup{}
		rup.nama_satker = item.vals[0]
		rup.kode_satker = item.vals[1]
		rup.kode_rup = item.vals[2]
		rup.nama_paket = item.vals[3]
		rup.sumber_dana = item.vals[4]
		rup.pagu = item.vals[5]
		rup.awal_pemilihan = item.vals[6]
		rup.tipe = item.vals[7]
		rup.kegiatan = item.vals[8]
		rup.metode = item.vals[9]
		// rup.jenis = jenis_pengadaan_from_str(item[11].str())
		rup.year = item.vals[10]
		rup.last_updated = item.vals[11]
		rups << rup
	}
	return rups
}


pub fn (c CPool) rup_from_satker(kode_satker string) []Rup {
	mut rups := []Rup{}
	q := "select nama_satker, kode_satker, kode_rup, nama_paket, sumber_dana, \
	pagu, awal_pemilihan, tipe, kegiatan, metode, tahun, last_updated from v_rups \
	where kode_satker='$kode_satker'"
	// q := "select * from v_rups where kode_satker='${kode_satker}'"
	rows, _ := c.exec(q) //[]sqlite.Row
	
	// return rows
	for item in rows { // sqlite.Row
		mut rup := Rup{}
		rup.nama_satker = item.vals[0]
		rup.kode_satker = item.vals[1]
		rup.kode_rup = item.vals[2]
		rup.nama_paket = item.vals[3]
		rup.sumber_dana = item.vals[4]
		rup.pagu = item.vals[5]
		rup.awal_pemilihan = item.vals[6]
		rup.tipe = item.vals[7]
		rup.kegiatan = item.vals[8]
		rup.metode = item.vals[9]
		// rup.jenis = jenis_pengadaan_from_str(item[11].str())
		rup.year = item.vals[10]
		rup.last_updated = item.vals[11]
		rups << rup
	}
	return rups
}
