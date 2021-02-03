module url

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

pub struct OpsiRekap {
	jnr JnsRekap
}

type OpsiTipe = OpsiKegiatan | OpsiRekap

enum JnsRekap {
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

pub struct Response {
mut:
	url   string
	tahun string
	body  string
	opsi  OpsiTipe
}

// eXtended Response
struct XResponse {
	Response
mut:
	opsi OpsiTipe
}

// fetch fetch up rup data for specific `tahun` and provided options `opsi`
// The `opsi` accepts sum type in the form `OpsiKegiatan` and `OpsiRekap` type and return response with 
// populated data
pub fn fetch(tahun string, opsi OpsiTipe) ?Response {
	if tahun == '' {
		eprintln('error empty tahun field required')
		return error('error empty field tahun required')
	}
	mut resp := Response{}
	resp.tahun = tahun
	if opsi is OpsiKegiatan {
		if opsi.per_satker {
			if opsi.id_satker == '' {
				eprintln('error empty field required')
				return error('"error empty field required"')
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
	}
	if opsi is OpsiRekap {
		url := rekap_url_byjenis(opsi.jnr, tahun) ?
		text := http.get_text(url)
		resp.url = url
		resp.body = text
		resp.opsi = OpsiRekap{opsi.jnr}
		return resp
	}
	return error('Error in fetch')
}

// `penyedia` digunakan untuk mengambil data rup penyedia pada tahun `tahun`
pub fn penyedia(tahun string) ?Response {
	keg := OpsiKegiatan{.pyd, false, ''}
	resp := fetch(tahun, keg) ?
	return resp
}

// `penyedia_from_satker` digunakan untuk mengambil data rup penyedia dari 
// satker dengan id `id_satker` pada tahun `tahun`
pub fn penyedia_from_satker(id_satker string, tahun string) ?Response {
	keg := OpsiKegiatan{.pyd, true, id_satker}
	resp := fetch(tahun, keg) ?
	return resp
}

// `swakelola` digunakan untuk mengambil data rup swakeloa pada tahun `tahun`
pub fn swakelola(tahun string) ?Response {
	keg := OpsiKegiatan{.swa, false, ''}
	resp := fetch(tahun, keg) ?
	return resp
}

// swakelola_from_satker digunakan untuk mengambil data rup swakelola 
// dari satker dengan id `id_satker` pada tahun `tahun`
pub fn swakelola_from_satker(id_satker string, tahun string) ?Response {
	keg := OpsiKegiatan{.swa, true, id_satker}
	resp := fetch(tahun, keg) ?
	return resp
}

// `penyediadlmswakelola` digunakan untuk mengambil data rup penyedia dalam swakelola pada tahun `tahun`
pub fn penyediadlmswakelola(tahun string) ?Response {
	keg := OpsiKegiatan{.pds, false, ''}
	resp := fetch(tahun, keg) ?
	return resp
}

// `penyediadlmswakelola_from_satker` digunakan untuk mengambil rup penyedia dalam swakelola 
// pada satker dengan id `id_satker` pada tahun `tahun`
pub fn penyediadlmswakelola_from_satker(id_satker string, tahun string) ?Response {
	keg := OpsiKegiatan{.pds, true, id_satker}
	resp := fetch(tahun, keg) ?
	return resp
}

// `rekap_kegiatan_sekbm` digunakan untuk mengambil data rekap kegiatan satu kabupaten pada tahun `tahun`
pub fn rekap_kegiatan_sekbm(tahun string) ?Response {
	rkp := OpsiRekap{.kegiatan_sekbm}
	resp := fetch(tahun, rkp) ?
	return resp
}

// `rekap_kegiatan_satker` digunakan untuk mengambil data rekap kegiatan seluruh satker pada tahun `tahun`
pub fn rekap_kegiatan_satker(tahun string) ?Response {
	rkp := OpsiRekap{.kegiatan_satker}
	resp := fetch(tahun, rkp) ?
	return resp
}

// `rekap_anggaran_sekbm` digunakan untuk mengambil data rekap anggaran satu kabupaten pada tahun `tahun`
pub fn rekap_anggaran_sekbm(tahun string) ?Response {
	rkp := OpsiRekap{.anggaran_sekbm}
	resp := fetch(tahun, rkp) ?
	return resp
}

// `rekap_anggaran_satker` digunakan untuk mengambil data rekap anggaran seluruh satker pada tahun `tahun`
pub fn rekap_anggaran_satker(tahun string) ?Response {
	rkp := OpsiRekap{.anggaran_satker}
	resp := fetch(tahun, rkp) ?
	return resp
}

// `all_rup` berguna untuk mengambil data seluruh rup dalam sekali langkah pada `tahun` yang ditentukan
pub fn all_rup(tahun string) ?[]Response {
	if tahun == '' {
		eprintln('error empty field tahun required')
		return error('error empty field tahun required')
	}
	mut resp := []Response{}
	for tipe in [TipeKeg.pyd, TipeKeg.swa, TipeKeg.pds] {
		mut r := Response{}
		op := OpsiKegiatan{tipe, false, ''} // false => all satker
		res := fetch(tahun, op) ?
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
fn all_rup_from_satker(id_satker string, tahun string) ?[]Response {
	if tahun == '' || id_satker == '' {
		eprintln('error empty field required')
		return error('error empty field required')
	}
	mut resp := []Response{}
	for tipe in [TipeKeg.pyd, TipeKeg.swa, TipeKeg.pds] {
		mut r := Response{}
		op := OpsiKegiatan{tipe, true, id_satker}
		res := fetch(tahun, op) ?
		r.url = res.url
		r.tahun = tahun // tahun
		r.body = res.body
		r.opsi = op
		resp << r
	}
	return resp
}

/*
fn fetch_rekap(jnr JnsRekap, tahun string) ?Response {
	mut resp := Response{}
	resp.tahun = tahun
	url := rekap_url_byjenis(jnr, tahun) ?
	text := http.get_text(url)
	resp.url = url
	resp.body = text
	return resp
}

fn fetch_persatker(tpk TipeKeg, id_satker string, tahun string) ?Response {
	if tahun == '' || id_satker == '' {
		eprintln('error empty field required')
		return error('"error empty field required"')
	}
	mut resp := Response{}
	resp.tahun = tahun
	url := persatker_url_bytipe(tpk, id_satker, tahun) ?
	text := http.get_text(url)
	resp.url = url
	resp.body = text
	return resp
}

fn fetch_allsatker(tpk TipeKeg, tahun string) ?Response {
	mut resp := Response{}
	resp.tahun = tahun
	url := allsatker_url_bytipe(tpk, tahun) ?
	text := http.get_text(url)
	resp.url = url
	resp.body = text
	return resp
}
*/
