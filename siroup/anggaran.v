module siroup


// update entri anggaran sekbm
fn (c CPool) update_anggaran_sekbm(akm RekapAnggaranKbm) ?int {
	if c.kldi_exist_dianggaran(akm.kode_kldi) {
		//update
		q := "update RekapAnggaranKbm set tot_anggaran_pyd='${akm.tot_anggaran_pyd}', \
				tot_anggaran_swa='${akm.tot_anggaran_swa}', tot_anggaran_pds='${akm.tot_anggaran_pds}', \
				tot_anggaran_semua='${akm.tot_anggaran_semua}', last_updated='${akm.last_updated}' \
				where kode_kldi='${akm.kode_kldi}';"
		code := c.exec_none(q) 
		println("update anggaran kbm...$code")
		if code !in [0, 101] {
			return error(" Error in update akm ${akm.kode_kldi} with code : ${code}")
		}
		return code
	}
	return error("update failed, ${akm.kode_kldi} does not exist in db")
}

// insert anggaran sekbm
pub fn (c CPool) save_anggaran_sekbm(akm RekapAnggaranKbm) ?int {
	if c.kldi_exist_dianggaran(akm.kode_kldi) {
		eprintln("Error ${akm.kode_kldi} exist, use update instead")
		return error("Error ${akm.kode_kldi} exist, use update instead")
	}
	
	q := "insert into RekapAnggaranKbm(kode_kldi, nama_kldi, tot_anggaran_pyd, \
				tot_anggaran_swa, tot_anggaran_pds, tot_anggaran_semua, last_updated, year) \
				values('${akm.kode_kldi}', '${akm.nama_kldi}', '${akm.tot_anggaran_pyd}', \
				'${akm.tot_anggaran_swa}', '${akm.tot_anggaran_pds}', '${akm.tot_anggaran_semua}', \
				'${akm.last_updated}', '${akm.year}');"
	code := c.exec_none(q) 
	println("Insert anggaran kbm...$code")	
	if code !in [0, 101] {
			return error(" Error in insert akm with code : ${code}")
	}
	return code
}

// update anggaran persatker 
fn (c CPool) update_anggaran_persatker(ras RekapAnggaranSatker) ?int {
	if !c.satker_exist_dianggaran(ras.kode_satker) {
		eprintln("${ras.kode_satker} does not exist")
		return error("#Error ${ras.kode_satker} does not exist")
	}
	q := "update RekapAnggaranSatker set \
				tot_anggaran_pyd_satker='${ras.tot_anggaran_pyd_satker}', \
				tot_anggaran_swa_satker='${ras.tot_anggaran_swa_satker}', \
				tot_anggaran_pds_satker='${ras.tot_anggaran_pds_satker}', \
				tot_anggaran_satker='${ras.tot_anggaran_satker}', \
				last_updated='${ras.last_updated}' \
				where kode_satker='${ras.kode_satker}';"
	code := c.exec_none(q)
	println("Update anggaran satker ...$code")
	if code !in [0, 101] {
			return error(" Error in update : ${code}")
	}
	return code
}

// insert single entri anggaran satker
fn (c CPool) save_anggaran_persatker(ras RekapAnggaranSatker) ?int {
	if c.satker_exist_dianggaran(ras.kode_satker) {
		eprintln("${ras.kode_satker} exist, use update")
		return error('#Error use update instead')
	}
	q := "insert into RekapAnggaranSatker(kode_satker, nama_satker, \
				tot_anggaran_pyd_satker, tot_anggaran_swa_satker, tot_anggaran_pds_satker, \
				tot_anggaran_satker, last_updated, year) values('${ras.kode_satker}', \
				'${ras.nama_satker}', '${ras.tot_anggaran_pyd_satker}', \
				'${ras.tot_anggaran_swa_satker}', '${ras.tot_anggaran_pds_satker}', \
				'${ras.tot_anggaran_satker}', '${ras.last_updated}', \
				'${ras.year}') on conflict do nothing;"
	code := c.exec_none(q) 
	if code !in [0, 101] {
			return error(" Error in insert ${ras.kode_satker} with code : ${code}")
	}
	return code
}

// update array anggaran satker
fn (c CPool) update_anggaran_satker(stk []RekapAnggaranSatker) ? {
	if stk.len == 0 {
		return
	}
	c.exec("BEGIN CONNECTION")
	for item in stk {
		code := c.update_anggaran_persatker(item) ?
		println("Result update : ${code}")
	}
	c.exec("COMMIT")
}


// insert array of anggaran satker
pub fn (c CPool) save_anggaran_satker(stk []RekapAnggaranSatker) ? {
	if stk.len == 0 {
		return
	}
	c.exec("BEGIN CONNECTION")
	for item in stk {
		//insert
		code := c.save_anggaran_persatker(item) ?
		println("Insert ${item.kode_satker} with result: ${code}")
	}
	c.exec("COMMIT")
}
