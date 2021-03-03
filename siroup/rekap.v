module siroup

import net.http

pub struct OpsiRekap {
	jnr JnsRekap
}

pub enum JnsRekap {
	anggaran_sekbm
	anggaran_satker
	kegiatan_sekbm
	kegiatan_satker
}

pub fn (jnr JnsRekap) str() string {
	return match jnr {
		.anggaran_sekbm { 'Rekap anggaran kabupaten' }
		.anggaran_satker { 'Rekap anggaran semua satker' }
		.kegiatan_sekbm { 'Rekap kegiatan kabupaten' }
		.kegiatan_satker { 'Rekap kegiatan semua satker' }
	}
}

// fetch rekap
pub fn fetch_rekap(tahun string, jr JnsRekap) ?FetchResponse {
	if !valid(tahun) {
		eprintln('#Error not valid tahun')
		return error('#Error not valid tahun')
	}
	mut resp := FetchResponse{}
	resp.tahun = tahun
	url := rekap_url_byjenis(jr, tahun) ?
	text := http.get_text(url)
	resp.url = url
	resp.body = text
	resp.opsi = OpsiRekap{jr}
	return resp
}

// `rekap_kegiatan_sekbm` digunakan untuk mengambil data rekap kegiatan satu kabupaten pada tahun `tahun`
pub fn rekap_kegiatan_sekbm(tahun string) ?FetchResponse {
	//rkp := OpsiRekap{.kegiatan_sekbm}
	resp := fetch_rekap(tahun, .kegiatan_sekbm) ?
	return resp
}

// `rekap_kegiatan_satker` digunakan untuk mengambil data rekap kegiatan seluruh satker pada tahun `tahun`
pub fn rekap_kegiatan_satker(tahun string) ?FetchResponse {
	//rkp := OpsiRekap{.kegiatan_satker}
	resp := fetch_rekap(tahun, .kegiatan_satker) ?
	return resp
}

// `rekap_anggaran_sekbm` digunakan untuk mengambil data rekap anggaran satu kabupaten pada tahun `tahun`
pub fn rekap_anggaran_sekbm(tahun string) ?FetchResponse {
	//rkp := OpsiRekap{.anggaran_sekbm}
	resp := fetch_rekap(tahun, .anggaran_sekbm) ?
	return resp
}

// `rekap_anggaran_satker` digunakan untuk mengambil data rekap anggaran seluruh satker pada tahun `tahun`
pub fn rekap_anggaran_satker(tahun string) ?FetchResponse {
	//rkp := OpsiRekap{.anggaran_satker}
	resp := fetch_rekap(tahun, .anggaran_satker) ?
	return resp
}
