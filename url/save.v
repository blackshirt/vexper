module url

pub fn (c CPool) save_rup(rups []Rup) {
	if rups.len == 0 {
		return
	}
	c.exec('BEGIN TRANSACTION')
	for mut rup in rups {
		if c.use_safe_ops {
			if c.rup_withkode_exist(rup.kode_rup) {
				q := "update Rup set \
				nama_paket = '${rup.nama_paket}', \
				pagu = '${rup.pagu}', \
				awal_pemilihan = '${rup.awal_pemilihan}', \
				metode = '${rup.metode}', \
				sumber_dana = '${rup.sumber_dana}', \
				kegiatan = '${rup.kegiatan}', \
				year = '${rup.year}', \
				last_updated = '${rup.last_updated}', \
				tipe = '${rup.tipe}' where kode = '${rup.kode_rup}';"
				_, code := c.exec(q)
				println("update - ${q} - ${code}")
			} else {
				// rup not exist
				if rup.kode_satker == '' {
					qr := "SELECT kode FROM RekapKegiatanSatker WHERE nama='${rup.nama_satker}' LIMIT 1"
					kode_satker := c.q_string(qr)
					if kode_satker != '' {
						rup.kode_satker = kode_satker
					} else { 
						eprintln("error kode satker") 
						return 
					}
					
				}
				//tipe := c.q_string
				q := "insert into Rup(kode, nama_paket, \
				pagu, awal_pemilihan, metode, sumber_dana, \
				kegiatan, satker, year, last_updated, tipe) \
				values(\
				'${rup.kode_rup}', \
				'${rup.nama_paket}', \
				'${rup.pagu}', \
				'${rup.awal_pemilihan}', \
				'${rup.metode}', \
				'${rup.sumber_dana}', \
				'${rup.kegiatan}', \
				'${rup.kode_satker}', \
				'${rup.year}', \
				'${rup.last_updated}', \
				'${rup.tipe}') on conflict do nothing"
				_, code := c.exec(q)
				println("Inserting - $q - ${code}")
			}
		} else {
			eprintln("Nothing todo")
			return
		}
	}
	c.exec('COMMIT')
	
}


pub fn (c CPool) save_rekap_keg_satker(stk []RekapKegiatanSatker) {
	if stk.len == 0 {
		return
	}
	c.exec('BEGIN CONNECTION;')
	for opd in stk {
		// todo: safe binding
		if c.use_safe_ops {
			// opd exist in db
			if c.satker_withkode_exist(opd.kode) {
				q := 'update RekapKegiatanSatker set tot_pyd = $opd.tot_pyd, tot_pagu_pyd = $opd.tot_pagu_pyd, tot_swa = $opd.tot_swa, tot_pagu_swa = $opd.tot_pagu_swa, tot_pds = $opd.tot_pds, last_updated = $opd.last_updated where kode=$opd.kode'
				// println(q)
				println('Updating.....$opd.nama')
				c.exec(q)
				println('Finish update..')
			} else {
				q := "insert into RekapKegiatanSatker(kode, nama, tot_pyd, tot_pagu_pyd, tot_swa, tot_pagu_swa, tot_pds, tot_pagu_pds, last_updated, year) values('$opd.kode', '$opd.nama', '$opd.tot_pyd', '$opd.tot_pagu_pyd', '$opd.tot_swa', '$opd.tot_pagu_swa', '$opd.tot_pds', '$opd.tot_pagu_pds', '$opd.last_updated', '$opd.year') on conflict do nothing"
				// println(q)
				_, code := c.exec(q)
				println(code)
			}
		} else {
			println('Nothing todo')
			return
		}
	}
	c.exec('COMMIT;')
}
