module url

fn (c CPool) satker_exist(satker string) bool {
	q := 'SELECT EXISTS(SELECT 1 FROM Satker WHERE nama_satker=$satker LIMIT 1);'
	res := c.q_int(q)
	if res == 1 {
		return true
	}
	return false
}

fn (c CPool) satker_withkode_exist(kode_satker string) bool {
	q := 'SELECT EXISTS(SELECT 1 FROM Satker WHERE kode_satker=$kode_satker LIMIT 1);'
	res := c.q_int(q)
	if res == 1 {
		return true
	}
	return false
}
