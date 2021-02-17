module siroup

struct RupDiff {
	mut:
	kode_rup  string
	diff_vals [][]string
}

struct SatkerDiff {
	mut:
	kode_satker string
	diff_data    []map[string][][]string
	// {'kode_rup' : [['column_name', 'db_value', 'outer_value'], ['column 2', 'oldval','newval']]}
}

pub fn (c CPool) compare(rups []Rup) ?SatkerDiff {
	mut diffstat := SatkerDiff{}
	for rup in rups {
		diff := c.compare_rup(rup) ?
		diffstat.kode_satker = rup.kode_satker
		if diff.diff_vals.len == 0 {
			continue
		}
		mut diffmap := map[string][][]string{}
		diffmap[diff.kode_rup] = diff.diff_vals
		
		diffstat.diff_data << diffmap
	}
	return diffstat
}


// `compare_rup` untuk membandingkan (compare) antara rup hasil fetch dalam parameter `rup` 
// dan membandingkannya dengan rup terkait yang ada di database
 pub fn (c CPool) compare_rup(rup Rup) ?RupDiff {
	// sqlite> select group_concat(name) from pragma_table_info('v_rups');
	// id,kode_rup,nama_paket,sumber_dana,pagu,awal_pemilihan,tipe,kegiatan,\
	// nama_satker,kode_satker,metode,jenis,tahun,last_updated
	mut diff := RupDiff{}
	//cols := c.columns('v_rups')
	//println('pragma column name .... $cols')
	if c.rup_withkode_exist(rup.kode_rup) {
		// get the rup from db 
		q := "select kode_rup, nama_paket, sumber_dana, pagu, awal_pemilihan, \
		tipe, kegiatan, nama_satker, kode_satker, metode, jenis, tahun \
		from v_rups where kode_rup='${rup.kode_rup}' limit 1"
		row := c.exec_one(q) ?// sqlite.Row ==> vals []string
		// perform checking 
				
		diff.kode_rup = row.vals[0]
		mut diffarray := [][]string{}

		// cek nama paket
		if row.vals[1] != rup.nama_paket {
			old_val := row.vals[1]
			new_val := rup.nama_paket
			mut vals := []string{}
			vals << 'nama_paket' // add column name
			vals << old_val
			vals << new_val
			diffarray << vals
		}
		// sumber dana
		if row.vals[2] != rup.sumber_dana {
			old_val := row.vals[2]
			new_val := rup.sumber_dana
			mut vals := []string{}
			vals << 'sumber_dana' 
			vals << old_val
			vals << new_val
			diffarray << vals
		}
		// pagu
		if row.vals[3] != rup.pagu {
			old_val := row.vals[3]
			new_val := rup.pagu
			mut vals := []string{}
			vals << 'pagu'
			vals << old_val
			vals << new_val
			diffarray << vals
		}
		// awal pemilihan
		if row.vals[4] != rup.awal_pemilihan {
			old_val := row.vals[4]
			new_val := rup.awal_pemilihan
			mut vals := []string{}
			vals << 'awal_pemilihan' 
			vals << old_val
			vals << new_val
			diffarray << vals
		}
		// tipe
		if row.vals[5] != rup.tipe {
			old_val := row.vals[5]
			new_val := rup.tipe
			mut vals := []string{}
			vals << 'tipe'
			vals << old_val
			vals << new_val
			diffarray << vals
		}
		// kegiatan
		if row.vals[6] != rup.kegiatan {
			old_val := row.vals[6]
			new_val := rup.kegiatan
			mut vals := []string{}
			vals << 'kegiatan' 
			vals << old_val
			vals << new_val
			diffarray << vals
		}
		// 7 nama satker skip
		// 8 kode_satker skip
		// 9 metode
		if row.vals[9] != rup.metode.str() {
			old_val := row.vals[9]
			new_val := rup.metode
			mut vals := []string{}
			vals << 'metode'
			vals << old_val
			vals << new_val.str() // enum form
			diffarray << vals
		}
		// jenis
		if row.vals[10] != rup.jenis.str() {
			old_val := row.vals[10]
			new_val := rup.jenis.str()
			mut vals := []string{}
			vals << 'jenis' 
			vals << old_val
			vals << new_val
			diffarray << vals
		}
		// 11 tahun skip
		// 12 last_updated skipped
		/*
		if row.vals[12] != rup.last_updated {
			old_val := row.vals[12]
			new_val := rup.last_updated
			mut vals := []string{}
			vals << cols[13] 
			vals << old_val
			vals << new_val
			diffarray << vals
		}
		*/
		diff.diff_vals = diffarray
	}
	return diff
}
