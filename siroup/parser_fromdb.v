module siroup

import sqlite

pub struct CPool {
	sqlite.DB
mut:
	use_safe_ops bool
}


fn (c CPool) koderup_from_satker(kode_satker string) ?[]string {
	if c.satker_exist_dikegiatan(kode_satker) {
		mut krups := []string{}
		q := "select kode_rup from v_rups where kode_satker='${kode_satker}'"
		rows, _ := c.exec(q)
		for row in rows {
			krups << row.vals[0]
		}
		return krups
	}
	return error("Satker ${kode_satker} tidak ada di database")
}

pub fn (c CPool) rup_with_kode(kode_rup string) ?Rup {
	if c.rup_withkode_exist(kode_rup) {
		q := "select nama_satker, kode_satker, kode_rup, nama_paket, \
			sumber_dana, pagu, awal_pemilihan, tipe, kegiatan, \
			metode, tahun, last_updated from v_rups where kode_rup='${kode_rup}' limit 1"
		row := c.exec_one(q)?
		mut rup := Rup{}
		rup.nama_satker = row.vals[0]
		rup.kode_satker = row.vals[1]
		rup.kode_rup = row.vals[2]
		rup.nama_paket = row.vals[3]
		rup.sumber_dana = row.vals[4]
		rup.pagu = row.vals[5]
		rup.awal_pemilihan = row.vals[6]
		rup.tipe = row.vals[7]
		rup.kegiatan = row.vals[8]
		rup.metode = row.vals[9]
		rup.year = row.vals[10]
		rup.last_updated = row.vals[11]
		return rup
	}
	return error("rup with kode rup ${kode_rup} doesn't exist in db")
}

// `columns` untuk mendapatkan daftar kolom dari table `table`
fn (c CPool) columns(table string) []string {
	mut cols := []string{}
	q := "select name from pragma_table_info('${table}')"
	rows, _ := c.exec(q)
	for item in rows {
		cols << item.vals[0]
	}
	return cols
}

// `daftar_satker` untuk mengambil data daftar satker yang ada dalam bentuk `map[kode_satker]nama_satker`
pub fn (c CPool) daftar_satker() map[string]string {
	mut m := map[string]string{}
	q := 'select kode_satker, nama_satker from v_all_satker'
	rows, _ := c.exec(q)
	for opd in rows {
		m[opd.vals[0]] = opd.vals[1]
	}
	return m
}

fn (c CPool) prepare_rup(r Rup) Rup {
	mut mrup := r
	if mrup.kode_satker == '' {
		q := "SELECT kode_satker FROM RekapKegiatanSatker WHERE nama_satker='${mrup.nama_satker}' LIMIT 1"
		kode_satker := c.q_string(q)
		if kode_satker != '' {
			mrup.kode_satker = kode_satker
		}
	}
	return mrup
}

fn (c CPool) rup_bytipe(tipe TipeKeg) []Rup {
	mut rups := []Rup{}

	// tp := tipe.str()
	q := "select nama_satker, kode_satker, kode_rup, nama_paket, \
	sumber_dana, pagu, awal_pemilihan, tipe, kegiatan, metode, \
	tahun, last_updated from v_rups where tipe='$tipe.str()'"
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

pub fn (c CPool) penyedia() []Rup {
	return c.rup_bytipe(.pyd)
}

pub fn (c CPool) swakelola() []Rup {
	return c.rup_bytipe(.swa)
}

pub fn (c CPool) penyediadlmswakelola() []Rup {
	return c.rup_bytipe(.pds)
}

pub fn (c CPool) all_rup() []Rup {
	mut rups := []Rup{}
	q := 'select nama_satker, kode_satker, kode_rup, nama_paket, \
	sumber_dana, pagu, awal_pemilihan, tipe, kegiatan, \
	metode, tahun, last_updated from v_rups;'
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

		//rup.jenis = jenis_pengadaan_from_str(item[11])
		rup.year = item.vals[10]
		rup.last_updated = item.vals[11]
		rups << rup
	}
	return rups
}

pub fn (c CPool) rup_from_satker(kode_satker string) []Rup {
	mut rups := []Rup{}
	q := "select nama_satker, kode_satker, kode_rup, nama_paket, \
	sumber_dana, pagu, awal_pemilihan, tipe, kegiatan, metode, \
	tahun, last_updated from v_rups where kode_satker='${kode_satker}'"

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
