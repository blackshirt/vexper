module url

pub fn (c CPool) save_rup(rups []Rup) {
	if rups.len == 0 {
		return
	}
	c.exec('BEGIN TRANSACTION')
	for rup in rups {
		if c.use_safe_ops {
			if c.rup_withkode_exist(rup.kode_rup) {
				q := "update Rup set nama_paket = '$rup.nama_paket', pagu = '$rup.pagu', \
				awal_pemilihan = '$rup.awal_pemilihan', metode = '$rup.metode', \
				sumber_dana = '$rup.sumber_dana', kegiatan = '$rup.kegiatan', \
				year = '$rup.year', last_updated = '$rup.last_updated', \
				tipe = '$rup.tipe' where kode_rup = '$rup.kode_rup';"
				_, code := c.exec(q)
				println('update ... $code')
			} else {
				// rup not exist
				// check kode satker jika kosong
				rp := c.prepare_rup(rup)
				
				q := "insert into Rup(kode_rup, nama_paket, pagu, awal_pemilihan, \
				metode, sumber_dana, kegiatan, kode_satker, year, last_updated, tipe) \
				values('${rp.kode_rup}', '${rp.nama_paket}', '${rp.pagu}', \
				'${rp.awal_pemilihan}', '${rp.metode}', '${rp.sumber_dana}', \
				'${rp.kegiatan}', '${rp.kode_satker}', '${rp.year}', \
				'${rp.last_updated}', '${rp.tipe}') \
				on conflict do nothing"
				
				_, code := c.exec(q)
				println('Inserting ... ${rup.kode_rup} ..- $code')
			}
		} else {
			eprintln('Nothing todo')
			return
		}
	}
	c.exec('COMMIT')
}

pub fn (c CPool) save_anggaran_sekbm(akm []RekapAnggaranKbm) {
	if akm.len == 0 {
		return
	}
	c.exec('BEGIN CONNECTION')
	for item in akm {
		if c.use_safe_ops {
			if c.kldi_exist_dianggaran(item.kode_kldi) {
				//update
				q := "update RekapAnggaranKbm set tot_anggaran_pyd='${item.tot_anggaran_pyd}', \
				tot_anggaran_swa='${item.tot_anggaran_swa}', tot_anggaran_pds='${item.tot_anggaran_pds}', \
				tot_anggaran_semua='${item.tot_anggaran_semua}', last_updated='${item.last_updated}' \
				where kode_kldi='${item.kode_kldi}';"
				_, code := c.exec(q)
				println("update anggaran kbm...$code")
			} else {
				q := "insert into RekapAnggaranKbm(kode_kldi, nama_kldi, tot_anggaran_pyd, \
				tot_anggaran_swa, tot_anggaran_pds, tot_anggaran_semua, last_updated, year) \
				values('${item.kode_kldi}', '${item.nama_kldi}', '${item.tot_anggaran_pyd}', \
				'${item.tot_anggaran_swa}', '${item.tot_anggaran_pds}', '${item.tot_anggaran_semua}', \
				'${item.last_updated}', '${item.year}');"
				_, code := c.exec(q)
				println("Insert anggaran kbm...$code")	
			}
		} else {
			return
		}
	}
	c.exec('COMMIT')	
}


pub fn (c CPool) save_anggaran_satker(stk []RekapAnggaranSatker) {
	if stk.len == 0 {
		return
	}
	c.exec("BEGIN CONNECTION")
	for item in stk {
		if c.use_safe_ops {
			if c.satker_exist_dianggaran(item.kode_satker) {
				q := "update RekapAnggaranSatker set \
				tot_anggaran_pyd_satker='${item.tot_anggaran_pyd_satker}', \
				tot_anggaran_swa_satker='${item.tot_anggaran_swa_satker}', \
				tot_anggaran_pds_satker='${item.tot_anggaran_pds_satker}', \
				tot_anggaran_satker='${item.tot_anggaran_satker}', \
				last_updated='${item.last_updated}' \
				where kode_satker='${item.kode_satker}';"
				_, code := c.exec(q)
				println("Update anggaran satker ...$code")
			} else {
				//insert
				q := "insert into RekapAnggaranSatker(kode_satker, nama_satker, \
				tot_anggaran_pyd_satker, tot_anggaran_swa_satker, tot_anggaran_pds_satker, \
				tot_anggaran_satker, last_updated, year) values('${item.kode_satker}', \
				'${item.nama_satker}', '${item.tot_anggaran_pyd_satker}', \
				'${item.tot_anggaran_swa_satker}', '${item.tot_anggaran_pds_satker}', \
				'${item.tot_anggaran_satker}', '${item.last_updated}', \
				'${item.year}') on conflict do nothing;"
				_, code := c.exec(q)
				println("Insert anggaran satker ...$code")
			}

		} else {
			return
		}
	}
	c.exec("COMMIT")
}


pub fn (c CPool) save_kegiatan_sekbm(rkm []RekapKegiatanKbm){
	if rkm.len == 0 {
		return
	}
	c.exec('BEGIN CONNECTION')
	for item in rkm {
		if c.use_safe_ops {
			if c.kldi_exist_dikegiatan(item.kode_kldi) {
				q := "update RekapKegiatanKbm set tot_paket_pyd='${item.tot_paket_pyd}', \
				tot_pagu_pyd = '${item.tot_pagu_pyd}', tot_paket_swa = '${item.tot_paket_swa}', \
				tot_pagu_swa = '${item.tot_pagu_swa}', tot_paket_pds = '${item.tot_paket_pds}', \
				tot_pagu_pds = '${item.tot_pagu_pds}', tot_paket = '${item.tot_paket}', \
				tot_pagu = '${item.tot_pagu}', last_updated = '${item.last_updated}' \
				where kode_kldi='${item.kode_kldi}';"
				_, code := c.exec(q)
				println("Update kegiatan kbm......$code")
			} else {
				q := "insert into RekapKegiatanKbm(kode_kldi, nama_kldi, tot_paket_pyd, \
				tot_pagu_pyd, tot_paket_swa, tot_pagu_swa, \
				tot_paket_pds, tot_pagu_pds, tot_paket, tot_pagu, \
				tipe_kldi, last_updated, year) values('${item.kode_kldi}', \
				'${item.nama_kldi}', '${item.tot_paket_pyd}', '${item.tot_pagu_pyd}', \
				'${item.tot_paket_swa}', '${item.tot_pagu_swa}', '${item.tot_paket_pds}', \
				'${item.tot_pagu_pds}', '${item.tot_paket}', '${item.tot_pagu}', '${item.tipe_kldi}', \
				'${item.last_updated}', '${item.year}') on conflict do nothing;"
				_, code := c.exec(q)
				println("Insert kegiatan kbm.....$code")
			}
		} else {
			return
		}
	}
	c.exec('COMMIT')
}


pub fn (c CPool) save_kegiatan_satker(stk []RekapKegiatanSatker) {
	if stk.len == 0 {
		return
	}
	c.exec('BEGIN CONNECTION;')
	for opd in stk {
		// todo: safe binding
		if c.use_safe_ops {
			// opd exist in db
			if c.satker_exist_dikegiatan(opd.kode_satker) {
				q := 'update RekapKegiatanSatker set tot_pyd = $opd.tot_pyd, \
				tot_pagu_pyd = $opd.tot_pagu_pyd, tot_swa = $opd.tot_swa, \
				tot_pagu_swa = $opd.tot_pagu_swa, tot_pds = $opd.tot_pds, \
				last_updated = $opd.last_updated where kode_satker=$opd.kode_satker'
				// println(q)
				println("Updating.....'${opd.nama_satker}'")
				c.exec(q)
				println('Finish update..')
			} else {
				q := "insert into RekapKegiatanSatker(kode_satker, nama_satker, tot_pyd, \
				tot_pagu_pyd, tot_swa, tot_pagu_swa, tot_pds, tot_pagu_pds, last_updated, year) \
				values('${opd.kode_satker}', '${opd.nama_satker}', '${opd.tot_pyd}', \
				'${opd.tot_pagu_pyd}', '${opd.tot_swa}', '${opd.tot_pagu_swa}', \
				'${opd.tot_pds}', '${opd.tot_pagu_pds}', '${opd.last_updated}', \
				'${opd.year}') on conflict do nothing"
				// println(q)
				_, code := c.exec(q)
				println("inserting .....result - $code")
			}
		} else {
			println('Nothing todo')
			return
		}
	}
	c.exec('COMMIT;')
}
