module siroup
import sqlite

struct RupChangeSet {
mut:
	fresh   []Rup
	changed map[string][]RupChangedVals // map[kode_rup]
}

struct RupChangedVals {
	kode_rup string
	col_name string
	old_val  string
	new_val  string
}

// get changes of rup in the form of array of RupChangedVals
// `rup` was result from net fetch
fn (c CPool) get_changes(rup Rup) ?[]RupChangedVals {
	mut rcv := []RupChangedVals{}
	
	if c.rup_withkode_exist(rup.kode_rup) {
		status, row := c.has_changed(rup)
		if !status {
			return rcv // empty
		}
		if row.vals[1] != rup.nama_paket {
			rc := RupChangedVals{
				kode_rup: rup.kode_rup
				col_name: 'nama_paket'
				old_val: row.vals[1]
				new_val: rup.nama_paket
			}
			rcv << rc
		}
		if row.vals[2] != rup.sumber_dana {
			rc := RupChangedVals{
				kode_rup: rup.kode_rup
				col_name: 'sumber_dana'
				old_val: row.vals[2]
				new_val: rup.sumber_dana
			}
			rcv << rc
		}
		if row.vals[3] != rup.pagu {
			rc := RupChangedVals{
				kode_rup: rup.kode_rup
				col_name: 'pagu'
				old_val: row.vals[3]
				new_val: rup.pagu
			}
			rcv << rc
		}
		if row.vals[4] != rup.awal_pemilihan {
			rc := RupChangedVals{
				kode_rup: rup.kode_rup
				col_name: 'awal_pemilihan'
				old_val: row.vals[4]
				new_val: rup.awal_pemilihan
			}
			rcv << rc
		}
		if row.vals[5].to_lower() != rup.metode.to_lower() {
			rc := RupChangedVals{
				kode_rup: rup.kode_rup
				col_name: 'metode'
				old_val: row.vals[5]
				new_val: rup.metode
			}
			rcv << rc
		}
		if row.vals[6] != rup.year {
			rc := RupChangedVals{
				kode_rup: rup.kode_rup
				col_name: 'tahun'
				old_val: row.vals[6]
				new_val: rup.year
			}
			rcv << rc
		}
		return rcv
	}
	return error("#Error ${rup.kode_rup} does not exist")
}

// cek rup punya value tetap antara db dan net
fn (c CPool) has_same_value(rup Rup) (bool, sqlite.Row) {
	q := "select kode_rup, nama_paket, sumber_dana, pagu, awal_pemilihan, \
	metode, tahun from v_rups where kode_rup='${rup.kode_rup}' limit 1"
	row := c.exec_one(q) or {panic(err)} // sqlite.Row ==> vals []string
	if row.vals.len == 0 { return false, row }
	// return if all col to be checked has same value
	result := row.vals[0] == rup.kode_rup && row.vals[1] == rup.nama_paket
		&& row.vals[2] == rup.sumber_dana && row.vals[3] == rup.pagu
		&& row.vals[4] == rup.awal_pemilihan && row.vals[5].to_lower() == rup.metode.to_lower()
		&& row.vals[6] == rup.year
	return result, row
}

// cek rup antara db dan net ada perubahan
fn (c CPool) has_changed(rup Rup) (bool, sqlite.Row) {
	res, row := c.has_same_value(rup)
	status := res == false
	return status, row
}

// compare banyak rup antara db dan net
pub fn (c CPool) compare_rups(rups []Rup) ?RupChangeSet {
	if rups.len == 0 {
		eprintln('rups with len 0')
		return RupChangeSet{}
	}
	mut rcs := RupChangeSet{}
	for rup in rups {
		// check if rup exist in db
		if !c.rup_withkode_exist(rup.kode_rup) {
			// not exist in db, artinya rup baru
			println('New rup $rup.kode_rup')
			rcs.fresh << rup
		}
		// cek berubah atau tidak
		status, _ := c.has_changed(rup)
		if !status {
			continue
		}
		changes := c.get_changes(rup) ?
		rcs.changed[rup.kode_rup] = changes
		
	}
	return rcs
}
