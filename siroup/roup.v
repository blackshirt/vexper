module siroup

// update rup
fn (c CPool) update_rup(rup Rup) ?int {
	if c.rup_withkode_exist(rup.kode_rup) {
		q := "update Rup set nama_paket = '${rup.nama_paket}', pagu = '${rup.pagu}', \
				awal_pemilihan = '${rup.awal_pemilihan}', metode = '${rup.metode}', \
				sumber_dana = '${rup.sumber_dana}', kegiatan = '${rup.kegiatan}', \
				year = '${rup.year}', last_updated = '${rup.last_updated}', \
				tipe = '${rup.tipe}' where kode_rup = '${rup.kode_rup}';"
		_, code := c.exec(q)
		if code !in [0, 101] {
			return error(" Error in query exec with code : ${code}")
		}
		return code
	}
	return error("Rup ${rup.kode_rup} does not exist")
}

// update array of rup
fn (c CPool) update_rups(rups []Rup) ? {
	if rups.len == 0 {
		return
	}
	c.exec('BEGIN TRANSACTION')
	for rup in rups {
		c.update_rup(rup)?
	}
	c.exec('COMMIT')
}

// save/insert rup
fn (c CPool) save_rup(rup Rup) ?int {
	if !c.rup_withkode_exist(rup.kode_rup) {
		rp := c.prepare_rup(rup)
		q := "insert into Rup(kode_rup, nama_paket, pagu, awal_pemilihan, \
				metode, sumber_dana, kegiatan, kode_satker, year, last_updated, tipe, \
				tipe_swakelola, jenis) \
				values('${rp.kode_rup}', '${rp.nama_paket}', '${rp.pagu}', \
				'${rp.awal_pemilihan}', '${rp.metode}', '${rp.sumber_dana}', \
				'${rp.kegiatan}', '${rp.kode_satker}', '${rp.year}', \
				'${rp.last_updated}', '${rp.tipe}', '${rp.tipe_swakelola}', '${rp.jenis}') \
				on conflict do nothing"
				
		_, code := c.exec(q)
		if code !in [0, 101] {
			return error(" Error in insert query with code : ${code}")
		}
		return code
	}
	return error("Rup ${rup.kode_rup} was exists in db, use update instead")
}

// insert array of rup
fn (c CPool) save_rup(rups []Rup) ? {
	if rups.len == 0 {
		return
	}
	c.exec('BEGIN TRANSACTION')
	for rup in rups {
		_ := c.save_rup(rup) ?
	}
	c.exec('COMMIT')
}
