module url

import json
import time

struct Result {
mut:
	data []Store
	len  int
}

pub fn (rs Result) data() []Store {
	return rs.data
}

type Store = RekapAnggaranKbm | RekapAnggaranSatker | RekapKegiatanKbm | RekapKegiatanSatker |
	Rup

// parse_response parses responses data from the results of fetch operation in `
// XResponse` `r` params and return `Result`, underlying data stored in result `data` 
// with len `len`
pub fn parse_response(r XResponse) ?Result {
	if r.opt is Kegiatan {
		mut res := Result{}
		if r.opt.per_satker {
			rup := parse_persatker_bytipe(r.opt.keg, r.body, r.opt.id_satker, r.tahun) ?
			mut w := []Store{}
			for i in rup {
				k := Store(i)
				w << k
			}
			res.data = w
			res.len = rup.len
			return res
		} else {
			rup := parse_allsatker_bytipe(r.opt.keg, r.body, r.tahun) ?
			mut w := []Store{}
			for i in rup {
				k := Store(i)
				w << k
			}
			res.data = w
			res.len = rup.len
			return res
		}
	}
	if r.opt is Rekap {
		match r.opt.jk {
			.anggaran_sekbm {
				mut res := Result{}
				data := parse_anggaran_sekbm(r.body, r.tahun) ?
				k := Store(data)
				res.data = [k]
				res.len = [k].len
				return res
			}
			.anggaran_satker {
				mut res := Result{}
				data := parse_anggaran_satker(r.body, r.tahun) ?
				mut w := []Store{}
				for i in data {
					k := Store(i)
					w << k
				}
				res.data = w
				res.len = data.len
				return res
			}
			.kegiatan_satker {
				mut res := Result{}
				data := parse_kegiatan_satker(r.body, r.tahun) ?
				mut w := []Store{}
				for i in data {
					s := Store(i)
					w << s
				}
				res.data = w
				res.len = data.len
				return res
			}
			.kegiatan_sekbm {
				mut res := Result{}
				data := parse_kegiatan_sekbm(r.body, r.tahun) ?
				k := Store(data)
				// ck := k as RekapKegiatanKbm
				res.data = [k]
				res.len = [k].len
				return res
			}
		}
	}
}

fn parse_persatker_bytipe(t TipeKeg, src string, id_satker string, tahun string) ?[]Rup {
	match t {
		.pyd { return parse_pyd_persatker(src, id_satker, tahun) }
		.swa { return parse_swa_persatker(src, id_satker, tahun) }
		.pds { return parse_pds_persatker(src, id_satker, tahun) }
	}
}

fn parse_allsatker_bytipe(t TipeKeg, src string, tahun string) ?[]Rup {
	match t {
		.pyd { return parse_pyd_allsatker(src, tahun) }
		.swa { return parse_swa_allsatker(src, tahun) }
		.pds { return parse_pds_allsatker(src, tahun) }
	}
}

fn parse_pyd_allsatker(src string, tahun string) ?[]Rup {
	mut rv := []Rup{}
	// res := fetch_pyd_allsatker(tahun) ?
	dval := json.decode(RawResponse, src) ?
	data := dval.raw_data
	for item in data {
		mut rup := Rup{}
		// typical item ["26395240","DINAS KOMUNIKASI DAN INFORMATIKA",
		// "Pengadaan Perangkat Lunak Berlisensi",
		// "17500000","Pengadaan Langsung","APBD","26395240","December 2020"]
		rup.kode_rup = item[0]
		rup.nama_satker = item[1]
		//rup.kode_satker = ''
		rup.nama_paket = item[2]
		rup.pagu = item[3]
		rup.metode = item[4]
		rup.sumber_dana = item[5]
		// rup.kode_rup = item[6]
		rup.awal_pemilihan = item[7]
		rup.kegiatan = item[2] // sama paket ??
		rup.last_updated = time.now().str()
		rup.year = tahun
		rup.tipe = .pyd
		rv << rup
	}
	return rv
}

fn parse_swa_allsatker(src string, tahun string) ?[]Rup {
	mut rv := []Rup{}
	// res := fetch_swa_allsatker(tahun) ?
	dval := json.decode(RawResponse, src) ?
	data := dval.raw_data
	for item in data {
		mut rup := Rup{}
		// typical item ["24787378","RSUD PREMBUN","Belanja Perjalanan Dinas Biasa",
		// "104754000","APBD","24787378","January 2021","Administrasi Kepegawaian Perangkat Daerah"]
		rup.kode_rup = item[0]
		// rup.kode_satker = ''
		rup.nama_satker = item[1]
		rup.nama_paket = item[2]
		rup.pagu = item[3]
		rup.metode = 'Swakelola'
		rup.sumber_dana = item[4]
		// rup.kode_rup = item[5]
		rup.awal_pemilihan = item[6]
		rup.kegiatan = item[7]
		rup.last_updated = time.now().str()
		rup.year = tahun
		rup.tipe = .swa
		rv << rup
	}
	return rv
}

fn parse_pds_allsatker(res string, tahun string) ?[]Rup {
	mut rv := []Rup{}
	// res := fetch_pds_allsatker(tahun) ?
	dval := json.decode(RawResponse, res) ?
	data := dval.raw_data
	for item in data {
		mut rup := Rup{}
		// typical item ["27236420","DINAS PERUMAHAN DAN KAWASAN PERMUKIMAN DAN LINGKUNGAN HIDUP",
		// "Belanja Jasa Jalan/Tol","1000000","Februari 2021","Pengadaan Langsung",
		// "APBD","true","true","27236420","27236420"]
		rup.kode_rup = item[0]
		// rup.kode_satker = ''
		rup.nama_satker = item[1]
		rup.nama_paket = item[2]
		rup.kegiatan = item[2]
		rup.pagu = item[3]
		rup.awal_pemilihan = item[4]
		rup.metode = item[5]
		rup.sumber_dana = item[6]
		// item[7] unknown
		// item[8] unknown
		// item[9] kode rup
		// item[10] kode rup
		rup.last_updated = time.now().str()
		rup.year = tahun
		rup.tipe = .pds
		rv << rup
	}
	return rv
}

fn parse_pyd_persatker(src string, id_satker string, tahun string) ?[]Rup {
	mut rv := []Rup{}
	// res := fetch_pyd_persatker(id_satker, tahun) ?
	dval := json.decode(RawResponse, src) ?
	data := dval.raw_data
	for item in data {
		mut rup := Rup{}
		// typical item ["27031840","Pembangunan Kecamatan Ambal","6000000000","Tender",
		// "APBD","27031840","December 2020"]
		rup.kode_rup = item[0]
		// rup.nama_satker = select nama_satker from RekapKegiatanSatker where kode_satker=id_satker
		rup.nama_paket = item[1]
		rup.kegiatan = item[1] // sama nama paket ?
		rup.pagu = item[2]
		rup.metode = item[3]
		rup.sumber_dana = item[4]
		// rup.kode_rup = item[5]
		rup.awal_pemilihan = item[6]
		rup.kode_satker = id_satker
		rup.last_updated = time.now().str()
		rup.year = tahun
		rup.tipe = .pyd
		rv << rup
	}
	return rv
}

fn parse_swa_persatker(src string, id_satker string, tahun string) ?[]Rup {
	mut rv := []Rup{}
	// res := fetch_swa_persatker(id_satker, tahun) ?
	dval := json.decode(RawResponse, src) ?
	data := dval.raw_data
	for item in data {
		mut rup := Rup{}
		// typical item ["24957218","Penyediaan Layanan Kesehatan Untuk UKM dan UKP Rujukan Tingkat Daerah Kabupaten/Kota",
		// "Operasional Pelayanan Puskesmas","1256422000","BLUD","24957218","January 2021"]
		rup.kode_rup = item[0]
		// todo: 
		// rup.nama_satker = select nama_satker from RekapKegiatanSatker where kode_satker=id_satker
		rup.nama_paket = item[1]
		rup.kode_satker = id_satker
		rup.kegiatan = item[2]
		rup.pagu = item[3]
		// rup.metode not avaliable in swa, diisi Swakelola ?
		rup.metode = 'Swakelola'
		rup.sumber_dana = item[4]
		// rup.kode_rup = item[5]
		rup.awal_pemilihan = item[6]
		rup.last_updated = time.now().str()
		rup.year = tahun
		rup.tipe = .swa
		rv << rup
	}
	return rv
}

fn parse_pds_persatker(src string, id_satker string, tahun string) ?[]Rup {
	mut rv := []Rup{}
	// res := fetch_pds_persatker(id_satker, tahun) ?
	dval := json.decode(RawResponse, src) ?
	data := dval.raw_data
	for item in data {
		mut rup := Rup{}
		// typical item ["27271980","Belanja Bahan Baku Bangunan",
		// "905000","Pengadaan Langsung","BLUD","27271980","Mei 2021","true","true","27271980"]
		rup.kode_rup = item[0]
		// rup.nama_satker = select nama_satker from RekapKegiatanSatker where kode_satker = id_satker
		rup.nama_paket = item[1]
		rup.kegiatan = item[1] //??
		rup.pagu = item[2]
		rup.metode = item[3]
		rup.sumber_dana = item[4]
		// item[5] kode rup
		rup.awal_pemilihan = item[6]
		// item[7] unknown
		// item[8] unknown
		// item[9] kode rup
		rup.kode_satker = id_satker
		rup.last_updated = time.now().str()
		rup.year = tahun
		rup.tipe = .pds
		rv << rup
	}
	return rv
}

fn parse_kegiatan_satker(src string, tahun string) ?[]RekapKegiatanSatker {
	// typical item ["94039","PUSKESMAS KLIRONG 1","27","392","12","1513","23","574","62","2480"]
	// res := fetch_kegiatan_satker(tahun) ?
	dval := json.decode(RawResponse, src) ?
	data := dval.raw_data
	mut stk := []RekapKegiatanSatker{}
	for item in data {
		mut sk := RekapKegiatanSatker{}
		sk.kode = item[0]
		sk.nama = item[1]
		sk.tot_pyd = item[2]
		sk.tot_pagu_pyd = item[3]
		sk.tot_swa = item[4]
		sk.tot_pagu_swa = item[5]
		sk.tot_pds = item[6]
		sk.tot_pagu_pds = item[7]
		sk.year = tahun
		sk.last_updated = time.now().str()
		stk << sk
	}
	return stk
}

fn parse_anggaran_sekbm(src string, tahun string) ?RekapAnggaranKbm {
	// res := fetch_anggaran_sekbm(tahun) ?
	dval := json.decode(RawResponse, src) ?
	data := dval.raw_data
	item := data[0]
	mut rva := RekapAnggaranKbm{}
	rva.kode_kldi = item[0]
	rva.nama_kldi = item[1]
	rva.tot_anggaran_pyd = item[2]
	rva.tot_anggaran_swa = item[3]
	rva.tot_anggaran_pds = item[4]
	rva.tot_anggaran_semua = item[5]
	return rva
}

fn parse_kegiatan_sekbm(src string, tahun string) ?RekapKegiatanKbm {
	// res := fetch_kegiatan_sekbm(tahun) ?
	dval := json.decode(RawResponse, src) ?
	data := dval.raw_data
	item := data[0]
	mut rk := RekapKegiatanKbm{}
	rk.kode_kldi = item[0]
	rk.nama_kldi = item[1]
	rk.tot_paket_pyd = item[2]
	rk.tot_pagu_pyd = item[3]
	rk.tot_paket_swa = item[4]
	rk.tot_pagu_swa = item[5]
	rk.tot_paket_pds = item[6]
	rk.tot_pagu_pds = item[7]
	rk.tot_paket = item[8]
	rk.tot_pagu = item[9]
	rk.tipe_kldi = item[10]
	return rk
}

fn parse_anggaran_satker(src string, tahun string) ?[]RekapAnggaranSatker {
	// res := fetch_anggaran_satker(tahun) ?
	dval := json.decode(RawResponse, src) ?
	data := dval.raw_data
	mut rks := []RekapAnggaranSatker{}
	for item in data {
		mut rka := RekapAnggaranSatker{}
		rka.kode_satker = item[0]
		rka.nama_satker = item[1]
		rka.tot_anggaran_pyd_satker = item[2]
		rka.tot_anggaran_swa_satker = item[3]
		rka.tot_anggaran_pds_satker = item[4]
		rka.tot_anggaran_satker = item[5]
		rks << rka
	}
	return rks
}
