/*
fn anggaran_sekbm_url(tahun string) ?string {
	mut url := urllib.parse(anggaran_sekbm_path) ?
	mut val := urllib.new_values()
	val.add('tahun', tahun)
	val.add('jenisKLPD', 'KABUPATEN')
	val.add('sSearch', 'Pemerintah Daerah Kabupaten Kebumen')
	url.raw_query = val.encode()
	return url.str()
}

fn anggaran_satker_url(tahun string) ?string {
	mut url := urllib.parse(anggaran_satker_path) ?
	mut val := urllib.new_values()
	val.add('tahun', tahun)
	val.add('idKldi', 'D128')
	url.raw_query = val.encode()
	return url.str()
}

fn kegiatan_sekbm_url(tahun string) ?string {
	mut url := urllib.parse(kegiatan_sekbm_path) ?
	mut val := urllib.new_values()
	val.add('jenisID', 'KABUPATEN')
	val.add('sSearch', 'Pemerintah Daerah Kabupaten Kebumen')
	val.add('tahun', tahun)
	url.raw_query = val.encode()
	return url.str()
}

fn kegiatan_satker_url(tahun string) ?string {
	mut url := urllib.parse(kegiatan_satker_path) ?
	mut val := urllib.new_values()
	val.add('idKldi', 'D128')
	val.add('tahun', tahun)
	url.raw_query = val.encode()
	return url.str()
}
*/
/*
fn pyd_allsatker_url(tahun string) ?string {
	mut url := urllib.parse(pyd_allsatker_path) ?
	mut val := urllib.new_values()
	val.add('idKldi', 'D128')
	val.add('tahun', tahun)
	url.raw_query = val.encode()
	return url.str()
}

fn swa_allsatker_url(tahun string) ?string {
	mut url := urllib.parse(swa_allsatker_path) ?
	mut val := urllib.new_values()
	val.add('idKldi', 'D128')
	val.add('tahun', tahun)
	url.raw_query = val.encode()
	return url.str()
}

fn pds_allsatker_url(tahun string) ?string {
	mut url := urllib.parse(pds_allsatker_path) ?
	mut val := urllib.new_values()
	val.add('idKldi', 'D128')
	val.add('tahun', tahun)
	url.raw_query = val.encode()
	return url.str()
}
*/
/*
fn pyd_persatker_url(id_satker string, tahun string) ?string {
	mut url := urllib.parse(pyd_persatker_path) ?
	mut val := urllib.new_values()
	val.add('tahun', tahun)
	val.add('idSatker', id_satker)
	url.raw_query = val.encode()
	return url.str()
}

fn swa_persatker_url(id_satker string, tahun string) ?string {
	mut url := urllib.parse(swa_persatker_path) ?
	mut val := urllib.new_values()
	val.add('tahun', tahun)
	val.add('idSatker', id_satker)
	url.raw_query = val.encode()
	return url.str()
}

fn pds_persatker_url(id_satker string, tahun string) ?string {
	mut url := urllib.parse(pds_persatker_path) ?
	mut val := urllib.new_values()
	val.add('tahun', tahun)
	val.add('idSatker', id_satker)
	url.raw_query = val.encode()
	return url.str()
}
*/
/*
fn fetch_pyd_allsatker(tahun string) ?string {
	url := pyd_allsatker_url(tahun) ?
	res := http.get_text(url)
	return res
}

fn fetch_swa_allsatker(tahun string) ?string {
	url := swa_allsatker_url(tahun) ?
	res := http.get_text(url)
	return res
}

fn fetch_pds_allsatker(tahun string) ?string {
	url := pds_allsatker_url(tahun) ?
	res := http.get_text(url)
	return res
}
*/
/*
fn fetch_pyd_persatker(id_satker string, tahun string) ?string {
	url := pyd_persatker_url(id_satker, tahun) ?
	res := http.get_text(url)
	return res
}

fn fetch_swa_persatker(id_satker string, tahun string) ?string {
	url := swa_persatker_url(id_satker, tahun) ?
	res := http.get_text(url)
	return res
}

fn fetch_pds_persatker(id_satker string, tahun string) ?string {
	url := pds_persatker_url(id_satker, tahun) ?
	res := http.get_text(url)
	return res
}
*/
/*
fn fetch_kegiatan_sekbm(tahun string) ?string {
	url := kegiatan_sekbm_url(tahun) ?
	res := http.get_text(url)
	return res
}

fn fetch_kegiatan_satker(tahun string) ?string {
	url := kegiatan_satker_url(tahun) ?
	res := http.get_text(url)
	return res
}

fn fetch_anggaran_sekbm(tahun string) ?string {
	url := anggaran_sekbm_url(tahun) ?
	res := http.get_text(url)
	return res
}

fn fetch_anggaran_satker(tahun string) ?string {
	url := anggaran_satker_url(tahun) ?
	res := http.get_text(url)
	return res
}
*/
