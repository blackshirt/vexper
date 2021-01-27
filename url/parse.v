module url

import json
import time

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
		rup.satker = item[1]
		rup.nama_paket = item[2]
		rup.pagu = item[3]
		rup.metode = item[4]
		rup.sumber_dana = item[5]

		// rup.kode_rup = item[6]
		rup.awal_pemilihan = item[7]
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
		rup.satker = item[1]
		rup.nama_paket = item[2]
		rup.pagu = item[3]

		// rup.metode not avaliable in swa
		rup.sumber_dana = item[4]

		// rup.kode_rup = item[5]
		rup.awal_pemilihan = item[6]
		rup.kegiatan = item[7]
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
		rup.satker = item[1]
		rup.nama_paket = item[2]
		rup.pagu = item[3]
		rup.awal_pemilihan = item[4]
		rup.metode = item[5]
		rup.sumber_dana = item[6]

		// item[7] unknown
		// item[8] unknown
		// item[9] kode rup
		// item[10] kode rup
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

		// rup.nama_satker = select nama_satker from Satker where kode_satker=id_satker
		rup.nama_paket = item[1]
		rup.pagu = item[2]
		rup.metode = item[3]
		rup.sumber_dana = item[4]

		// rup.kode_rup = item[5]
		rup.awal_pemilihan = item[6]
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
		// rup.nama_satker = select nama_satker from Satker where kode_satker=id_satker
		rup.nama_paket = item[1]
		rup.kegiatan = item[2]
		rup.pagu = item[3]

		// rup.metode not avaliable in swa, diisi Swakelola ?
		rup.metode = 'Swakelola'
		rup.sumber_dana = item[4]

		// rup.kode_rup = item[5]
		rup.awal_pemilihan = item[6]
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

		// rup.nama_satker = select nama_satker from Satker where kode_satker = id_satker
		rup.nama_paket = item[1]
		rup.pagu = item[2]
		rup.metode = item[3]
		rup.sumber_dana = item[4]

		// item[5] kode rup
		rup.awal_pemilihan = item[6]

		// item[7] unknown
		// item[8] unknown
		// item[9] kode rup
		rv << rup
	}
	return rv
}

fn parse_kegiatan_satker(src string, tahun string) ?[]Satker {
	// typical item ["94039","PUSKESMAS KLIRONG 1","27","392","12","1513","23","574","62","2480"]
	// res := fetch_kegiatan_satker(tahun) ?
	dval := json.decode(RawResponse, src) ?
	data := dval.raw_data
	mut stk := []Satker{}
	for item in data {
		mut sk := Satker{}
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

// ["D128","Pemerintah Daerah Kabupaten Kebumen",
// "130579571100","76459681099","2316174000","209355426199"]
struct RekapAnggaranKbm {
mut:
	kode_kldi          string
	nama_kldi          string
	tot_anggaran_pyd   string
	tot_anggaran_swa   string
	tot_anggaran_pds   string
	tot_anggaran_semua string
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

// total rekap rup kebumen
// {"aaData":[["D128","Pemerintah Daerah Kabupaten Kebumen",
// "964","130957","1088","76459","163","2316","2215","209733","KABUPATEN"]],"iTotalDisplayRecords":1,"sEcho":2}
struct RekapKegiatanKbm {
mut:
	kode_kldi     string
	nama_kldi     string
	tot_paket_pyd string
	tot_pagu_pyd  string
	tot_paket_swa string
	tot_pagu_swa  string
	tot_paket_pds string
	tot_pagu_pds  string
	tot_paket     string
	tot_pagu      string
	tipe_kldi     string
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

// anggaran persatker
// ["63401","DINAS PEKERJAAN UMUM DAN PENATAAN RUANG",
//"27956840000","0","0","27956840000"],
struct RekapAnggaranSatker {
mut:
	kode_satker             string
	nama_satker             string
	tot_anggaran_pyd_satker string
	tot_anggaran_swa_satker string
	tot_anggaran_pds_satker string
	tot_anggaran_satker     string
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
