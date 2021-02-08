module url

import time
import net.html
import net.http
import net.urllib

const (
	base     = 'https://sirup.lkpp.go.id/sirup/home/'
	swa      = 'detailPaketSwakelolaPublic2017'
	pyd      = 'detailPaketPenyediaPublic2017'
	swa_path = base + swa
	pyd_path = base + pyd
)

pub struct DetailResult {
mut:
	url  string
	body string
}

struct DetailPropertiRup {
mut:
	jenis_pengadaan           string
	usaha_kecil               string = 'Ya'
	awal_pemilihan            string // sudah difetch di daftar rup
	akhir_pemilihan           string
	awal_pelaksanaan_kontrak  string
	akhir_pelaksanaan_kontrak string
	awal_pemanfaatan          string
	akhir_pemanfaatan         string
	tgl_perbaharui_paket      string
	tipe_swakelola            string = '1' // untuk yang swakelola, default tipe 1
}

pub fn (dr DetailResult) decode_detail() DetailPropertiRup {
	mut spr := DetailPropertiRup{}

	wkt_penyedia := tags_waktu_penyedia(dr)
	jns := tags_jenis_pengadaan(dr)
	qua := tags_kualifikasi_usaha(dr)
	tgl_baharu := tags_pembaharuan(dr)
	swa_tag := tags_waktu_swakelola(dr)
	println(swa_tag)
	spr.usaha_kecil = qua[0].text()
	spr.jenis_pengadaan = jns[0].text().trim_right(',')
	spr.awal_pemilihan = wkt_penyedia[4].text()
	spr.akhir_pemilihan = wkt_penyedia[5].text()
	spr.awal_pelaksanaan_kontrak = wkt_penyedia[2].text()
	spr.akhir_pelaksanaan_kontrak = wkt_penyedia[3].text()
	spr.awal_pemanfaatan = wkt_penyedia[0].text()
	spr.akhir_pemanfaatan = wkt_penyedia[1].text()
	spr.tipe_swakelola = 'non swakelola'
	spr.tgl_perbaharui_paket = tgl_baharu[0].text()

	return spr
}

fn tags_pembaharuan(dr DetailResult) []&html.Tag {
	mut doc := html.parse(dr.body)
	mut res := []&html.Tag{}
	tags := doc.get_tag('td')
	for i, tag in tags {
		if tag.text() == 'Tanggal Perbarui Paket' {
			idx := i + 1
			res << tags[idx]
			return res
		}
	}
	return res
}

fn tags_kualifikasi_usaha(dr DetailResult) []&html.Tag {
	mut doc := html.parse(dr.body)
	mut res := []&html.Tag{}
	tags := doc.get_tag('td')
	for i, tag in tags {
		if tag.text() == 'Usaha Kecil' {
			idx := i + 1
			res << tags[idx]
			return res
		}
	}
	return res
}

fn tags_jenis_pengadaan(dr DetailResult) []&html.Tag {
	mut doc := html.parse(dr.body)
	mut res := []&html.Tag{}
	tags := doc.get_tag('td')
	for i, tag in tags {
		if tag.text() == 'Jenis Pengadaan' {
			idx := i + 1
			res << tags[idx]
			return res
		}
	}
	return res
}

pub fn tags_waktu_penyedia(dr DetailResult) []&html.Tag {
	mut doc := html.parse(dr.body)
	mut res := []&html.Tag{}
	tags := doc.get_tag('td')
	for tag in tags {
		attr := tag.attributes
		if 'class' in attr && attr['class'] == 'mid' {
			res << tag
		}
	}
	// res.len should == 6
	return res
}

fn tags_waktu_swakelola(dr DetailResult) []&html.Tag {
	mut doc := html.parse(dr.body)
	mut res := []&html.Tag{}
	tags := doc.get_tags() // get all tags, no specific info about tag to find
	
	for i, tag in tags {
		if tag.text() == 'Awal' {
			idx := i + 1 
			res << tags[idx]
		}
		if tag.text() == 'Akhir' {
			idx := i + 1 
			res << tags[idx]
		}
		return res
	}
	return res
}

pub fn detail_rup_url(tpk TipeKeg, kode_rup string) ?string {
	mut val := urllib.new_values()
	match tpk {
		.pyd, .pds {
			path := pyd_path + '/' + kode_rup
			url := urllib.parse(path) ?
			return url.str()
		}
		.swa {
			val.add('idPaket', kode_rup)
			mut url := urllib.parse(swa_path) ?
			url.raw_query = val.encode()
			return url.str()
		}
	}
	return error('Not matching tipe kegiatan or kode rup')
}

pub fn build_jenis_url_for_rups(rups []Rup) ?[]string {
	mut res := []string{}
	for rup in rups {
		url := detail_rup_url(tipekeg_from_str(rup.tipe), rup.kode_rup) ?
		res << url
	}
	return res
}

pub fn send_request(url string, jrschan chan DetailResult) {
	mut jrs := DetailResult{}
	start := time.ticks()
	data := http.get_text(url)
	finish := time.ticks()
	println('Finish fetch $url in ... ${finish - start} ms')
	jrs.url = url
	jrs.body = data
	jrschan <- jrs
}

pub fn jenpeng_array_rup(rups []Rup, jrschan chan DetailResult) ?[]DetailResult {
	mut mjp := []DetailResult{}
	urls := build_jenis_url_for_rups(rups) ?
	for item in urls {
		go send_request(item, jrschan)
		mjp << <-jrschan
	}
	return mjp
}
