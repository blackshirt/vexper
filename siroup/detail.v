module siroup

import time
import net.html
import net.http
import net.urllib

import sync.pool

const (
	base     = 'https://sirup.lkpp.go.id/sirup/home/'
	swa      = 'detailPaketSwakelolaPublic2017'
	pyd      = 'detailPaketPenyediaPublic2017'
	swa_path = base + swa
	pyd_path = base + pyd
)

pub struct DetailResult {
mut:
	tipe     TipeKeg
	kode_rup string
	url      string
	body     string
	err_msg  string
}

pub struct DetailPropertiRup {
mut:
	kode_rup                  string
	jenis_pengadaan           string
	usaha_kecil               string = 'Ya'
	awal_pemilihan            string // sudah difetch di daftar rup
	akhir_pemilihan           string = 'Unknown'
	awal_pelaksanaan_kontrak  string = 'Unknown'
	akhir_pelaksanaan_kontrak string = 'Unknown'
	awal_pemanfaatan          string = 'Unknown'
	akhir_pemanfaatan         string = 'Unknown'
	tgl_perbaharui_paket      string = 'Unknown'
	tipe_swakelola            string = '1' // untuk yang swakelola, default tipe 1
}

// result in oops, maybe need retry or just continue 
pub fn (dr DetailResult) result_in_oops() bool {
	mut doc := html.parse(dr.body)
	tags := doc.get_tag('h1') //<h1 class="header">Oops, sabar ya !</h1>
	for tag in tags {
		if 'class' in tag.attributes && tag.attributes['class'] == 'header' && tag.text() == 'Oops, sabar ya !' {
			// error happen
			return true
		}
	}
	return false
}


// maybe using array.filter
fn (c CPool) filter_rup_detail_belum_keupdate(rups []Rup) []Rup {
	/*
	res := rups.filter(fn (r Rup) bool {
		return !c.rup_detail_has_been_updated(r)
	})
	return res
	*/
	mut res := []Rup{}
	for rup in rups {
		if c.rup_detail_has_been_updated(rup) {
			continue
		}
		res << rup
	}
	return res
}


fn (c CPool) rup_detail_has_been_updated(rup Rup) bool {
	match rup.tipe {
		'Penyedia', 'Penyedia dalam Swakelola' { return c.detail_penyedia_has_been_updated(rup.kode_rup) }
		'Swakelola' { return c.detail_swakelola_has_been_updated(rup.kode_rup) }
		else { return false }
	}
}

fn (c CPool) update_detail_penyedia(dr DetailPropertiRup) ?int {
	if c.is_penyedia(dr.kode_rup) {
		jenis := jenis_pengadaan_from_str(dr.jenis_pengadaan)
		q := "update Rup set jenis='${jenis}', usaha_kecil='${dr.usaha_kecil}', \
		akhir_pemilihan='${dr.akhir_pemilihan}', awal_pelaksanaan='${dr.awal_pelaksanaan_kontrak}', \
		akhir_pelaksanaan='${dr.akhir_pelaksanaan_kontrak}', awal_pemanfaatan='${dr.awal_pemanfaatan}',\
		akhir_pemanfaatan='${dr.akhir_pemanfaatan}', tgl_perbaharui_paket='${dr.tgl_perbaharui_paket}', \
		tipe_swakelola='${dr.tipe_swakelola}' where kode_rup='${dr.kode_rup}'"
		code := c.exec_none(q)
		if code !in [0, 101] { 
			return error("#Error update detail")
		}
		return code
	}
	return error("#Error not penyedia")	
}

fn (c CPool) update_detail_swakelola(dr DetailPropertiRup) ?int {
	if c.is_swakelola(dr.kode_rup) {
		jenis := jenis_pengadaan_from_str(dr.jenis_pengadaan)
		q := "update Rup set jenis='${jenis}', usaha_kecil='${dr.usaha_kecil}', awal_pemanfaatan='${dr.awal_pemanfaatan}',\
		akhir_pemanfaatan='${dr.akhir_pemanfaatan}', tgl_perbaharui_paket='${dr.tgl_perbaharui_paket}', \
		tipe_swakelola='${dr.tipe_swakelola}' where kode_rup='${dr.kode_rup}'"
		code := c.exec_none(q)
		if code !in [0, 101] { 
			return error("#Error update detail")
		}
		return code
	}
	return error("#Error not swakelola")
}

pub fn (c CPool) update_detail(dpr []DetailPropertiRup) ? {
	if dpr.len == 0 {
		eprintln("#Error len 0")
		return error("Error 0 len")
	}
	c.exec("BEGIN TRANSACTION")
	for item in dpr {
		if c.is_penyedia(item.kode_rup) {
			code := c.update_detail_penyedia(item) ?
			println("Update detail penyedia ${item.kode_rup} ...${code}")
		}
		if c.is_swakelola(item.kode_rup) {
			code := c.update_detail_swakelola(item) ?
			println("Update detail swakelola ${item.kode_rup}....${code}")
		}
	}
	c.exec("COMMIT")
}


// decode array of DetailResult
pub fn decode_detail(drs []DetailResult) []DetailPropertiRup {
	mut dpr := []DetailPropertiRup{}
	if drs.len == 0 {
		return dpr
	}
	for item in drs {
		if item.result_in_oops() {
			continue
		}
		res := item.decode()
		dpr << res
	}
	return dpr
}

//setup ThreadCB = fn (p &PoolProcessor, idx int, task_id int) voidptr
//this thread callback task was fetch the item and store the result in DetailResult and then 
// decode the DetailResult to DetailPropertiRup
pub fn fetch_and_decode_worker(p &pool.PoolProcessor, idx int, worker_id int) &DetailResult {
	println("Get index ${idx}")
	item := p.get_item<Rup>(idx)
	println("Working fetch on item ... ${item.kode_rup}")
	dr := do_fetch(item)
	//println("Decoding detail result .. ${dr.kode_rup}")
	//dpr := dr.decode()
	return &dr
}

// normal decode
pub fn (dr DetailResult) decode() DetailPropertiRup {
	mut spr := DetailPropertiRup{}
	
	if dr.tipe in [.pyd, .pds] {
		waktu_tags := tags_waktu_penyedia(dr)
		jenis_tags := tags_jenis_pengadaan(dr)
		qualify_tags := tags_kualifikasi_usaha(dr)
		if waktu_tags.len != 0 {
			spr.awal_pemilihan = waktu_tags[4].text()
			spr.akhir_pemilihan = waktu_tags[5].text()
			spr.awal_pelaksanaan_kontrak = waktu_tags[2].text()
			spr.akhir_pelaksanaan_kontrak = waktu_tags[3].text()
			spr.awal_pemanfaatan = waktu_tags[0].text()
			spr.akhir_pemanfaatan = waktu_tags[1].text()
		}
		if jenis_tags.len != 0 {
			spr.jenis_pengadaan = jenis_tags[0].text().trim_right(',')
		}
		if qualify_tags.len != 0 {
			spr.usaha_kecil = qualify_tags[0].text()
		}

		spr.tipe_swakelola = 'non swakelola'
	}
	if dr.tipe == .swa {
		spr.jenis_pengadaan = 'Swakelola'
		swa_tags := tags_waktu_swakelola(dr)
		if swa_tags.len != 0 {
			spr.tipe_swakelola = swa_tags[0].text().trim_left(': ')
			spr.awal_pemanfaatan = swa_tags[1].text().trim_left(': ')
			spr.akhir_pemanfaatan = swa_tags[2].text().trim_left(': ')
		}
	}

	pembaharuan_tags := tags_pembaharuan(dr)
	if pembaharuan_tags.len != 0 {
		spr.tgl_perbaharui_paket = pembaharuan_tags[0].text()
	}

	spr.kode_rup = dr.kode_rup
	return spr
}

// channel based decode detail
/*
pub fn decode_detail_concurrently(drs []DetailResult, rch chan DetailPropertiRup) []DetailPropertiRup {
	mut dpr := []DetailPropertiRup{}
	for item in drs {
		go item.decode_concurrently(rch)
		dpr << <- rch
	}
	return dpr
}
*/

// decode concurrently using channel
/*
fn (dr DetailResult) decode_concurrently(rch chan DetailPropertiRup) {
	mut spr := DetailPropertiRup{}
	if dr.tipe in [.pyd, .pds] {
		waktu_tags := tags_waktu_penyedia(dr)
		jenis_tags := tags_jenis_pengadaan(dr)
		qualify_tags := tags_kualifikasi_usaha(dr)
		if waktu_tags.len != 0 {
			spr.awal_pemilihan = waktu_tags[4].text()
			spr.akhir_pemilihan = waktu_tags[5].text()
			spr.awal_pelaksanaan_kontrak = waktu_tags[2].text()
			spr.akhir_pelaksanaan_kontrak = waktu_tags[3].text()
			spr.awal_pemanfaatan = waktu_tags[0].text()
			spr.akhir_pemanfaatan = waktu_tags[1].text()
		}
		if jenis_tags.len != 0 {
			spr.jenis_pengadaan = jenis_tags[0].text().trim_right(',')
		}
		if qualify_tags.len != 0 {
			spr.usaha_kecil = qualify_tags[0].text()
		}

		spr.tipe_swakelola = 'non swakelola'
	}
	if dr.tipe == .swa {
		spr.jenis_pengadaan = 'Swakelola'
		swa_tags := tags_waktu_swakelola(dr)
		if swa_tags.len != 0 {
			spr.tipe_swakelola = swa_tags[0].text().trim_left(': ')
			spr.awal_pemanfaatan = swa_tags[1].text().trim_left(': ')
			spr.akhir_pemanfaatan = swa_tags[2].text().trim_left(': ')
		}
	}

	pembaharuan_tags := tags_pembaharuan(dr)
	if pembaharuan_tags.len != 0 {
		spr.tgl_perbaharui_paket = pembaharuan_tags[0].text()
	}

	spr.kode_rup = dr.kode_rup
	rch <- spr
}
*/

// `detail_rup_url` for building url spesific to tipe kegiatan in `tpk` 
// and `kode_rup` params
fn detail_rup_url(tpk TipeKeg, kode_rup string) ?string {
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

fn build_jenis_url_for_rups(rups []Rup) ?[]string {
	if rups.len == 0 {
		eprintln("#Error 0 len of rups")
		return error("rups 0")
	}
	mut res := []string{}
	for rup in rups {
		url := detail_rup_url(tipekeg_from_str(rup.tipe), rup.kode_rup) ?
		res << url
	}
	return res
}


// do real fetch on url
fn do_fetch(rup Rup) DetailResult {
	mut dr := DetailResult{}
	url := detail_rup_url(tipekeg_from_str(rup.tipe), rup.kode_rup) or { panic(err.msg)}
	start := time.ticks()
	body := http.get_text(url)
	finish := time.ticks()
	println('Finish fetch $url in ... ${finish - start} ms')
	
	//setting up result
	dr.kode_rup = rup.kode_rup
	dr.tipe = tipekeg_from_str(rup.tipe)
	dr.url = url
	dr.body = body
	return dr 
}

// thread based concurrent fetch using `[]thread` form in latest v
pub fn (c CPool) thread_version_fetch_detail_from_satker(kode_satker string) []DetailResult {
	rups := c.rup_from_satker(kode_satker)
	// rups maybe 0 len
	mut drs := []thread DetailResult{}
	if rups.len == 0 { return []DetailResult{} }
	
	for item in rups {
		println("prosesing ${item.kode_rup} ...")
		// run in go call
		drs << go do_fetch(item)
	}
	// join the result
	res := drs.wait()
	return res
}


// regular
// note: operasi ini intensif karena fetch http
/*
fn do_fetch(rup Rup) ?DetailResult {
	// TODO: check tpk dan kode_rup harus matching karena jika kode rup dimaksud untuk swakelola
	// tetapi tipe diambil penyedia, maka result bisa untuk kabupaten lain.
	// check ini https://sirup.lkpp.go.id/sirup/home/detailPaketSwakelolaPublic2017?idPaket=24925776 (Kab Kebumen)
	// dan https://sirup.lkpp.go.id/sirup/home/detailPaketPenyediaPublic2017/24925776 >> Kab Banjar (Kalsel) ?
	mut dr := DetailResult{}
	url := detail_rup_url(tipekeg_from_str(rup.tipe), rup.kode_rup) ?
	start := time.ticks()
	body := http.get_text(url)
	finish := time.ticks()
	println('Finish fetch $url in ... ${finish - start} ms')
	dr.kode_rup = rup.kode_rup
	dr.tipe = tipekeg_from_str(rup.tipe)
	dr.url = url
	dr.body = body
	return dr
}
*/

// note: operasi ini intensif karena fetch http
// channel based concurrent fetcher
/*
fn do_fetch_concurrent(rup Rup, rsc chan DetailResult) ?{
	// TODO: check tpk dan kode_rup harus matching karena jika kode rup dimaksud untuk swakelola
	// tetapi tipe diambil penyedia, maka result bisa untuk kabupaten lain.
	// check ini https://sirup.lkpp.go.id/sirup/home/detailPaketSwakelolaPublic2017?idPaket=24925776 (Kab Kebumen)
	// dan https://sirup.lkpp.go.id/sirup/home/detailPaketPenyediaPublic2017/24925776 >> Kab Banjar (Kalsel) ?
	mut dr := DetailResult{}
	url := detail_rup_url(tipekeg_from_str(rup.tipe), rup.kode_rup) ?
	start := time.ticks()
	body := http.get_text(url)
	finish := time.ticks()
	println('Finish fetch $url in ... ${finish - start} ms')
	dr.kode_rup = rup.kode_rup
	dr.tipe = tipekeg_from_str(rup.tipe)
	dr.url = url
	dr.body = body
	rsc <- dr
}
*/


/*
fn (c CPool) fetch_detail(rup Rup) ?DetailResult {
	if c.rup_withkode_exist(rup.kode_rup) {
		dr := do_fetch(rup) 
		return dr
	}
	return error("rup with kode ${rup.kode_rup} doesn't exist in db")
}
*/

// note: intensive operation, rups may be contains thousands of item
// should be placed in concurrency manner
// its sequential func
/*
pub fn (c CPool) fetch_detail_from_satker(kode_satker string) ?[]DetailResult {
	rups := c.rup_from_satker(kode_satker)
	mut drs := []DetailResult{}
	for rup in rups {
		dr := c.fetch_detail(rup)?
		drs << dr
	}
	return drs
}
*/


// channel version of concurrent fetch
/*
pub fn (c CPool) fetch_detail_from_satker_conccurently(kode_satker string, rsc chan DetailResult) ?[]DetailResult {
	rups := c.rup_from_satker(kode_satker)
	mut drs := []DetailResult{}
	for rup in rups {
		go c.fetch_detail_concurrently(rup, rsc) 
		drs << <- rsc
	}
	return drs
}

// fetch detail rup 
fn (c CPool) fetch_detail_concurrently(rup Rup, rsc chan DetailResult) ?{
	if c.rup_withkode_exist(rup.kode_rup) {
		dr := do_fetch(rup) ?
		rsc <- dr
	}
	return error("error in fetch concurent")
}
*/