module siroup

fn (c CPool) is_penyedia(kode_rup string) bool {
	if c.rup_withkode_exist(kode_rup) {
		q := "select tipe from Rup where kode_rup='${kode_rup}' LIMIT 1;"
		t := c.q_string(q)
		if t in ['Penyedia', 'Penyedia dalam Swakelola'] {
			return true
		}
		return false
	}
	return false
}

fn (c CPool) is_swakelola(kode_rup string) bool {
	if c.rup_withkode_exist(kode_rup) {
		q := "select tipe from Rup where kode_rup='${kode_rup}' LIMIT 1;"
		t := c.q_string(q)
		if t == 'Swakelola' { return true }
		return false
	}
	return false
	
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
	q := "SELECT EXISTS(SELECT 1 FROM RekapKegiatanSatker WHERE kode_satker='${kode_satker}' LIMIT 1);"
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
