module url

import net.http

struct Response {
mut:
	url   string
	tahun string
	body  string
}

// eXtended Response
struct XResponse {
	Response
mut:
	opt Tipe
}

// fetch fetch up rup data for specific `tahun` and provided options `opt`
// The `opt` accepts sum type in the form `Kegiatan` and `Rekap` type and return response with 
// populated data
pub fn fetch(tahun string, opt Tipe) ?XResponse {
	if tahun == '' {
		eprintln('error empty tahun field required')
		return error('error empty field tahun required')
	}
	mut xresp := XResponse{}
	xresp.tahun = tahun
	if opt is Kegiatan {
		if opt.per_satker {
			res := fetch_persatker(opt.keg, opt.id_satker, tahun) ?
			xresp.url = res.url
			xresp.body = res.body
			xresp.opt = Kegiatan{opt.keg, true, opt.id_satker}
			return xresp
		} else {
			res := fetch_allsatker(opt.keg, tahun) ?
			xresp.url = res.url
			xresp.body = res.body
			xresp.opt = Kegiatan{opt.keg, false, opt.id_satker}
			return xresp
		}
	}
	if opt is Rekap {
		res := fetch_rekap(opt.jk, tahun) ?
		xresp.url = res.url
		xresp.body = res.body
		xresp.opt = Rekap{opt.jk}
		return xresp
	}
	return error('Error in fetch')
}

fn fetch_rekap(jk JnsRekap, tahun string) ?Response {
	mut resp := Response{}
	resp.tahun = tahun
	url := rekap_url_byjenis(jk, tahun) ?
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
