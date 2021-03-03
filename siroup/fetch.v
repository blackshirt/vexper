module siroup

import net.http

enum TipeKeg {
	pyd
	swa
	pds
}

pub fn (tp TipeKeg) str() string {
	return match tp {
		.pyd { 'Penyedia' }
		.swa { 'Swakelola' }
		.pds { 'Penyedia dalam Swakelola' }
	}
}

struct OpsiKegiatan {
	keg        TipeKeg
	per_satker bool
	id_satker  string
}

pub fn tipekeg_from_str(tk string) TipeKeg {
	return match tk {
		'Penyedia' { TipeKeg.pyd }
		'Swakelola' { TipeKeg.swa }
		'Penyedia dalam Swakelola' { TipeKeg.pds }
		else { TipeKeg.swa }
	}
}

type OpsiTipe = OpsiKegiatan | OpsiRekap

pub struct FetchResponse {
mut:
	url   string
	tahun string
	body  string
	opsi  OpsiTipe
}

fn (frs []FetchResponse) has_valid_rekap() bool {
	if frs.len == 0 {
		return false
	}
	for i in frs {
		if !i.valid_rekap() {
			return false
		}
	}
	return true
}

fn (frs []FetchResponse) has_valid_kegiatan() bool {
	if frs.len == 0 {
		return false
	}
	for i in frs {
		if !i.valid_kegiatan() {
			return false
		}
	}
	return true
}

fn (fr FetchResponse) valid_rekap() bool {
	return fr.opsi is OpsiRekap
}

fn (fr FetchResponse) valid_kegiatan() bool {
	return fr.opsi is OpsiKegiatan
}

// cek validitas tahun
fn valid(tahun string) bool {
	// cek len dan tahun > 2000 
	if tahun.len == 4 && tahun.starts_with('2') {
		for i in tahun {
			if !i.is_digit() {
				return false
			}
		}
		return true
	}
	return false
}

// fetch rup
fn fetch_rup(tahun string, opsi OpsiKegiatan) ?FetchResponse {
	if !valid(tahun) {
		eprintln('#Error not valid tahun')
		return error('#Error not valid tahun')
	}
	mut resp := FetchResponse{}
	resp.tahun = tahun
	if opsi.per_satker {
		if opsi.id_satker == '' {
			eprintln('error empty field required')
			return error('error empty field required')
		}
		url := persatker_url_bytipe(opsi.keg, opsi.id_satker, tahun) ?
		text := http.get_text(url)
		resp.url = url
		resp.body = text
		resp.opsi = OpsiKegiatan{opsi.keg, true, opsi.id_satker}
		return resp
	} else {
		url := allsatker_url_bytipe(opsi.keg, tahun) ?
		text := http.get_text(url)
		resp.url = url
		resp.body = text
		resp.opsi = OpsiKegiatan{opsi.keg, false, opsi.id_satker}
		return resp
	}
	return error('Error in fetch rup')
}

// `penyedia` digunakan untuk mengambil data rup penyedia pada tahun `tahun`
pub fn penyedia(tahun string) ?FetchResponse {
	keg := OpsiKegiatan{.pyd, false, ''}
	resp := fetch_rup(tahun, keg) ?
	return resp
}

// `penyedia_from_satker` digunakan untuk mengambil data rup penyedia dari 
// satker dengan id `id_satker` pada tahun `tahun`
pub fn penyedia_from_satker(id_satker string, tahun string) ?FetchResponse {
	keg := OpsiKegiatan{.pyd, true, id_satker}
	resp := fetch_rup(tahun, keg) ?
	return resp
}

// `swakelola` digunakan untuk mengambil data rup swakeloa pada tahun `tahun`
pub fn swakelola(tahun string) ?FetchResponse {
	keg := OpsiKegiatan{.swa, false, ''}
	resp := fetch_rup(tahun, keg) ?
	return resp
}

// swakelola_from_satker digunakan untuk mengambil data rup swakelola 
// dari satker dengan id `id_satker` pada tahun `tahun`
pub fn swakelola_from_satker(id_satker string, tahun string) ?FetchResponse {
	keg := OpsiKegiatan{.swa, true, id_satker}
	resp := fetch_rup(tahun, keg) ?
	return resp
}

// `penyediadlmswakelola` digunakan untuk mengambil data rup penyedia dalam swakelola pada tahun `tahun`
pub fn penyediadlmswakelola(tahun string) ?FetchResponse {
	keg := OpsiKegiatan{.pds, false, ''}
	resp := fetch_rup(tahun, keg) ?
	return resp
}

// `penyediadlmswakelola_from_satker` digunakan untuk mengambil rup penyedia dalam swakelola 
// pada satker dengan id `id_satker` pada tahun `tahun`
pub fn penyediadlmswakelola_from_satker(id_satker string, tahun string) ?FetchResponse {
	keg := OpsiKegiatan{.pds, true, id_satker}
	resp := fetch_rup(tahun, keg) ?
	return resp
}

// `all_rup` berguna untuk mengambil data seluruh rup dalam sekali langkah pada `tahun` yang ditentukan
pub fn all_rup(tahun string) ?[]FetchResponse {
	if !valid(tahun) {
		eprintln('error empty field tahun required')
		return error('error empty field tahun required')
	}
	mut resp := []FetchResponse{}
	for tipe in [TipeKeg.pyd, TipeKeg.swa, TipeKeg.pds] {
		mut r := FetchResponse{}
		op := OpsiKegiatan{tipe, false, ''} // false => all satker
		res := fetch_rup(tahun, op) ?
		r.url = res.url
		r.tahun = tahun // tahun
		r.body = res.body
		r.opsi = op
		resp << r
	}
	return resp
}

// `all_rup_from_satker` berguna untuk mengambil data rup keseluruhan pada satker dengan 
// kode `id_satker` pada `tahun` yang ditentukan
pub fn all_rup_from_satker(id_satker string, tahun string) ?[]FetchResponse {
	if !valid(tahun) || id_satker == '' {
		eprintln('error empty field required')
		return error('error empty field required')
	}
	mut resp := []FetchResponse{}
	for tipe in [TipeKeg.pyd, TipeKeg.swa, TipeKeg.pds] {
		mut r := FetchResponse{}
		op := OpsiKegiatan{tipe, true, id_satker}
		res := fetch_rup(tahun, op) ?
		r.url = res.url
		r.tahun = tahun // tahun
		r.body = res.body
		r.opsi = op
		resp << r
	}
	return resp
}
