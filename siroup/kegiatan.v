module siroup

// update entri kegiatan sekbm
fn (c CPool) update_kegiatan_sekbm(rkm RekapKegiatanKbm) ?int {
	if !c.kldi_exist_dikegiatan(rkm.kode_kldi) {
		eprintln("kldi ${rkm.kode_kldi} does not exist")
		return error("#Error ${rkm.kode_kldi} does not exist")
	}
	q := "update RekapKegiatanKbm set tot_paket_pyd='${rkm.tot_paket_pyd}', \
				tot_pagu_pyd = '${rkm.tot_pagu_pyd}', tot_paket_swa = '${rkm.tot_paket_swa}', \
				tot_pagu_swa = '${rkm.tot_pagu_swa}', tot_paket_pds = '${rkm.tot_paket_pds}', \
				tot_pagu_pds = '${rkm.tot_pagu_pds}', tot_paket = '${rkm.tot_paket}', \
				tot_pagu = '${rkm.tot_pagu}', last_updated = '${rkm.last_updated}' \
				where kode_kldi='${rkm.kode_kldi}';"
	code := c.exec_none(q) 
	println("Update kegiatan kbm......$code")
	if code !in [0, 101] {
		return error("Fail in update rkm ${rkm.kode_kldi} with code ${code}")
	}
	return code
}

// insert entri kegiatan sekbm
pub fn (c CPool) save_kegiatan_sekbm(rkm RekapKegiatanKbm) ?int {
	if c.kldi_exist_dikegiatan(rkm.kode_kldi) {
		eprintln("kldi ${rkm.kode_kldi} exist, use update instead")
		return error("#Error save")	
	} 
	q := "insert into RekapKegiatanKbm(kode_kldi, nama_kldi, tot_paket_pyd, \
				tot_pagu_pyd, tot_paket_swa, tot_pagu_swa, \
				tot_paket_pds, tot_pagu_pds, tot_paket, tot_pagu, \
				tipe_kldi, last_updated, year) values('${rkm.kode_kldi}', \
				'${rkm.nama_kldi}', '${rkm.tot_paket_pyd}', '${rkm.tot_pagu_pyd}', \
				'${rkm.tot_paket_swa}', '${rkm.tot_pagu_swa}', '${rkm.tot_paket_pds}', \
				'${rkm.tot_pagu_pds}', '${rkm.tot_paket}', '${rkm.tot_pagu}', '${rkm.tipe_kldi}', \
				'${rkm.last_updated}', '${rkm.year}') on conflict do nothing;"
	code := c.exec_none(q) 
	println("Insert kegiatan kbm.....$code")
	if code !in [0, 101] {
		return error("Fail in insert with code ${code}")
	}
	return code
}

// update kegiatan persatker
fn (c CPool) update_kegiatan_persatker(opd RekapKegiatanSatker) ?int {
	q := 'update RekapKegiatanSatker set tot_pyd = ${opd.tot_pyd}, \
				tot_pagu_pyd = ${opd.tot_pagu_pyd}, tot_swa = ${opd.tot_swa}, \
				tot_pagu_swa = ${opd.tot_pagu_swa}, tot_pds = ${opd.tot_pds}, \
				last_updated = ${opd.last_updated} where kode_satker=${opd.kode_satker}'
				// println(q)
	println("Updating.....${opd.nama_satker}")
	code := c.exec_none(q) 
	if code !in [0, 101] {
		return error("Error update : ${code}")
	}
	return code
}

//update array of kegiatan satker
fn (c CPool) update_kegiatan_satker(stk []RekapKegiatanSatker) ? {
	if stk.len == 0 {
		return
	}
	c.exec('BEGIN CONNECTION;')
	for opd in stk {
		code := c.update_kegiatan_persatker(opd) ?
		println("Update : ${code}")
	}
	c.exec('COMMIT;')
}


// insert single entri rekap kegiatan satker
fn (c CPool) save_kegiatan_persatker(opd RekapKegiatanSatker) ?int {
	if c.satker_exist_dikegiatan(opd.kode_satker) {
		eprintln("satker ${opd.kode_satker} exist, use update instead")
		return	error("#Error exists")	
	}
	q := "insert into RekapKegiatanSatker(kode_satker, nama_satker, tot_pyd, \
				tot_pagu_pyd, tot_swa, tot_pagu_swa, tot_pds, tot_pagu_pds, last_updated, year) \
				values('${opd.kode_satker}', '${opd.nama_satker}', '${opd.tot_pyd}', \
				'${opd.tot_pagu_pyd}', '${opd.tot_swa}', '${opd.tot_pagu_swa}', \
				'${opd.tot_pds}', '${opd.tot_pagu_pds}', '${opd.last_updated}', \
				'${opd.year}') on conflict do nothing"
				// println(q)
	code := c.exec_none(q) 
	if code !in [0, 101] {
		return error("Error insert : ${code}")
	}
	return code
}


// insert array of rekap kegiatan satker
pub fn (c CPool) save_kegiatan_satker(stk []RekapKegiatanSatker) ? {
	if stk.len == 0 {
		return
	}
	c.exec('BEGIN CONNECTION;')
	for opd in stk {
		code := c.save_kegiatan_persatker(opd) ?
		println("Inserting ${opd.kode_satker} - result: ${code}")
	}
	c.exec('COMMIT;')
}
