module url

import sqlite

pub struct CPool {
	sqlite.DB
mut:
	use_safe_ops bool
}

fn (c CPool) rup_withkode_exist(kode_rup string) bool {
	q := 'SELECT EXISTS(SELECT 1 FROM Rup WHERE kode_rup=$kode_rup LIMIT 1);'
	res := c.q_int(q)
	if res == 1 {
		return true
	}
	return false
}

fn (c CPool) array_from_satker_exist(satker string) bool {
	q := 'SELECT * FROM v_rups WHERE satker=$satker'
	_, _ := c.exec(q)
	return false
}
