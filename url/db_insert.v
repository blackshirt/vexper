module url

fn (c CPool) save_rup(rups []Rup) {
	_ := 'insert into Rup()'
}

pub fn (c CPool) save_satker(stk []Satker) {
	if stk.len == 0 {
		return
	}
	c.exec('BEGIN CONNECTION;')
	for opd in stk {
		// todo: safe binding
		if c.use_safe_ops {
			// opd exist in db
			if c.satker_withkode_exist(opd.kode) {
				q := 'update Satker set tot_pyd = $opd.tot_pyd, tot_pagu_pyd = $opd.tot_pagu_pyd, tot_swa = $opd.tot_swa, tot_pagu_swa = $opd.tot_pagu_swa, tot_pds = $opd.tot_pds, last_updated = $opd.last_updated where kode=$opd.kode'

				// println(q)
				println('Updating.....$opd.nama')
				c.exec(q)
				println('Finish update..')
			} else {
				q := "insert into Satker(kode, nama, tot_pyd, tot_pagu_pyd, tot_swa, tot_pagu_swa, tot_pds, tot_pagu_pds, last_updated, year) values('$opd.kode', '$opd.nama', '$opd.tot_pyd', '$opd.tot_pagu_pyd', '$opd.tot_swa', '$opd.tot_pagu_swa', '$opd.tot_pds', '$opd.tot_pagu_pds', '$opd.last_updated', '$opd.year') on conflict do nothing"

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
