module url

struct UniDiff {
	mut:
	kode_rup  string
	diff_vals [][]string
}

struct DiffStat {
	mut:
	kode_satker string
	nama_satker string
	diffdata    []map[string][][]string
	// {'kode_rup' : [['column_name', 'db_value', 'outer_value'], ['column 2', 'oldval','newval']]}
}

pub fn (c CPool) compare(exout []Rup) ?DiffStat {
	mut diffstat := DiffStat{}
	for rup in exout {
		diff := c.compare_rup(rup) ?
		diffstat.kode_satker = rup.kode_satker
		diffstat.nama_satker = rup.nama_satker
		mut diffmap := map[string][][]string{}
		diffmap[diff.kode_rup] = diff.diff_vals
		
		diffstat.diffdata << diffmap
	}
	return diffstat
}

pub fn (c CPool) compare_rup(ex Rup) ?UniDiff {
	// sqlite> select group_concat(name) from pragma_table_info('v_rups');
	// id,kode_rup,nama_paket,sumber_dana,pagu,awal_pemilihan,tipe,kegiatan,\
	// nama_satker,kode_satker,metode,jenis,tahun,last_updated
	mut diff := UniDiff{}
	if c.rup_withkode_exist(ex.kode_rup) {
		// get the rup from db 
		q := "select kode_rup, nama_paket, sumber_dana, pagu, awal_pemilihan, \
		tipe, kegiatan, nama_satker, kode_satker, metode, jenis, tahun, \
		last_updated from v_rups where kode_rup='$ex.kode_rup' limit 1"
		row := c.exec_one(q) ?// sqlite.Row ==> vals []string
		// perform checking 
		cln, _ := c.exec("select name from pragma_table_info('v_rups')") // []sqlite.Row
		mut cols := []string{}
		for item in cln {
			cols << item.vals[0]
		}
		println('pragma column name .... $cols')
		
		diff.kode_rup = row.vals[0]

		mut diffarray := [][]string{}

		// cek nama paket
		if row.vals[1] != ex.nama_paket {
			old_val := row.vals[1]
			new_val := ex.nama_paket
			mut vals := []string{}
			vals << cols[2] // add column name
			vals << old_val
			vals << new_val
			diffarray << vals
		}
		// sumber dana
		if row.vals[2] != ex.sumber_dana {
			old_val := row.vals[2]
			new_val := ex.sumber_dana
			mut vals := []string{}
			vals << cols.vals[3] 
			vals << old_val
			vals << new_val
			diffarray << vals
		}
		// pagu
		if row.vals[3] != ex.pagu {
			old_val := row.vals[3]
			new_val := ex.pagu
			mut vals := []string{}
			vals << cols.vals[4] 
			vals << old_val
			vals << new_val
			diffarray << vals
		}
		// awal pemilihan
		if row.vals[4] != ex.awal_pemilihan {
			old_val := row.vals[4]
			new_val := ex.awal_pemilihan
			mut vals := []string{}
			vals << cols.vals[5] 
			vals << old_val
			vals << new_val
			diffarray << vals
		}
		// tipe
		if row.vals[5] != ex.tipe {
			old_val := row.vals[5]
			new_val := ex.tipe
			mut vals := []string{}
			vals << cols.vals[6] 
			vals << old_val
			vals << new_val
			diffarray << vals
		}
		// kegiatan
		if row.vals[6] != ex.kegiatan {
			old_val := row.vals[6]
			new_val := ex.kegiatan
			mut vals := []string{}
			vals << cols.vals[7] 
			vals << old_val
			vals << new_val
			diffarray << vals
		}
		// 7 nama satker skip
		// 8 kode_satker skip
		// metode
		if row.vals[9] != ex.metode {
			old_val := row.vals[9]
			new_val := ex.metode
			mut vals := []string{}
			vals << cols.vals[10] 
			vals << old_val
			vals << new_val
			diffarray << vals
		}
		// jenis
		if row.vals[10] != ex.jenis.str() {
			old_val := row.vals[10]
			new_val := ex.jenis.str()
			mut vals := []string{}
			vals << cols.vals[11] 
			vals << old_val
			vals << new_val
			diffarray << vals
		}
		// 11 tahun skip
		// 12 last_updated
		if row.vals[12] != ex.last_updated {
			old_val := row.vals[12]
			new_val := ex.last_updated
			mut vals := []string{}
			vals << cols.vals[13] 
			vals << old_val
			vals << new_val
			diffarray << vals
		}
		diff.diff_vals = diffarray
	}
	return diff
}


fn (c CPool) kldi_exist_dikegiatan(kode_kldi string) bool {
	q := "SELECT EXISTS(SELECT 1 FROM RekapKegiatanKbm WHERE kode_kldi='$kode_kldi' LIMIT 1);"
	res := c.q_int(q)
	if res == 1 {
		return true
	}
	return false
}

fn (c CPool) satker_exist_dikegiatan(kode_satker string) bool {
	q := "SELECT EXISTS(SELECT 1 FROM RekapKegiatanSatker WHERE kode_satker='$kode_satker' LIMIT 1);"
	res := c.q_int(q)
	if res == 1 {
		return true
	}
	return false
}

fn (c CPool) kldi_exist_dianggaran(kode_kldi string) bool {
	q := "SELECT EXISTS(SELECT 1 FROM RekapAnggaranKbm WHERE kode_kldi='$kode_kldi' LIMIT 1);"
	res := c.q_int(q)
	if res == 1 {
		return true
	}
	return false
}

fn (c CPool) satker_exist_dianggaran(kode_satker string) bool {
	q := "SELECT EXISTS(SELECT 1 FROM RekapAnggaranSatker WHERE kode_satker='$kode_satker' LIMIT 1);"
	res := c.q_int(q)
	if res == 1 {
		return true
	}
	return false
}

fn (c CPool) rup_withkode_exist(kode_rup string) bool {
	q := "SELECT EXISTS(SELECT 1 FROM Rup WHERE kode_rup='$kode_rup' LIMIT 1);"
	res := c.q_int(q)
	if res == 1 {
		return true
	}
	return false
}

fn (c CPool) satker_exist(nama_satker string) bool {
	q := "ELECT EXISTS(SELECT 1 FROM RekapKegiatanSatker WHERE nama_satker='$nama_satker' LIMIT 1);"
	res := c.q_int(q)
	if res == 1 {
		return true
	}
	return false
}
