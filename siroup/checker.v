module siroup

fn (c CPool) is_penyedia(kode_rup string) bool {
	q := "select tipe from Rup where kode_rup='${kode_rup}' LIMIT 1;"
	t := c.q_string(q)
	// should compare in to_lower() form ?
	return t == 'Penyedia' || t == 'Penyedia dalam Swakelola'
}

fn (c CPool) is_swakelola(kode_rup string) bool {
	q := "select tipe from Rup where kode_rup='${kode_rup}' LIMIT 1;"
	t := c.q_string(q)
	return t == 'Swakelola'
}

fn (c CPool) detail_penyedia_has_been_updated(kode_rup string) bool {
	if c.is_penyedia(kode_rup) {
		// only check one value ?
		q := "select awal_pelaksanaan from Rup where kode_rup='${kode_rup}' limit 1"
		awal_pel := c.q_string(q)
		return awal_pel != 'Unknown' || awal_pel != ''
	}
	return false
}


fn (c CPool) detail_swakelola_has_been_updated(kode_rup string) bool {
	if c.is_swakelola(kode_rup) {
		// only check one item ?
		q := "select awal_pemanfaatan from Rup where kode_rup='${kode_rup}' limit 1"
		awal_pemf := c.q_string(q)
		return awal_pemf != 'Unknown' || awal_pemf != ''
	}
	return false
}

fn (c CPool) kldi_exist_dikegiatan(kode_kldi string) bool {
	q := "SELECT EXISTS(SELECT 1 FROM RekapKegiatanKbm WHERE kode_kldi='${kode_kldi}' LIMIT 1);"
	res := c.q_int(q)
	return res == 1
}

fn (c CPool) satker_exist_dikegiatan(kode_satker string) bool {
	q := "SELECT EXISTS(SELECT 1 FROM RekapKegiatanSatker WHERE kode_satker='${kode_satker}' LIMIT 1);"
	res := c.q_int(q)
	return res == 1
}

fn (c CPool) kldi_exist_dianggaran(kode_kldi string) bool {
	q := "SELECT EXISTS(SELECT 1 FROM RekapAnggaranKbm WHERE kode_kldi='${kode_kldi}' LIMIT 1);"
	res := c.q_int(q)
	return res == 1
}

fn (c CPool) satker_exist_dianggaran(kode_satker string) bool {
	q := "SELECT EXISTS(SELECT 1 FROM RekapAnggaranSatker WHERE kode_satker='${kode_satker}' LIMIT 1);"
	res := c.q_int(q)
	return res == 1
}

fn (c CPool) rup_withkode_exist(kode_rup string) bool {
	q := "SELECT EXISTS(SELECT 1 FROM Rup WHERE kode_rup='${kode_rup}' LIMIT 1);"
	res := c.q_int(q)
	return res == 1
}

fn (c CPool) satker_exist(nama_satker string) bool {
	q := "ELECT EXISTS(SELECT 1 FROM RekapKegiatanSatker WHERE nama_satker='${nama_satker}' LIMIT 1);"
	res := c.q_int(q)
	return res == 1
}
