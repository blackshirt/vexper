// url module intended to be used as core library
module url

import net.urllib

/*
const (
	// kegiatan
	rup_rekap_sekbm             = 'https://sirup.lkpp.go.id/sirup/ro/dt/klpd/2?tahun=2021&jenisID=KABUPATEN&sSearch=Pemerintah+Daerah+Kabupaten+Kebumen'
	rup_penyedia_sekbm          = 'https://sirup.lkpp.go.id/sirup/datatablectr/dataruppenyediakldi?idKldi=D128&tahun=2021'
	rup_swakelola_sekbm         = 'https://sirup.lkpp.go.id/sirup/datatablectr/datarupswakelolakldi?idKldi=D128&tahun=2021'
	rup_penyedia_swa_sekbm      = 'https://sirup.lkpp.go.id/sirup/datatablectr/dataruppenyediaswakelolaallrekapkldi?idKldi=D128&tahun=2021'
	rup_kegiatan_satker         = 'https://sirup.lkpp.go.id/sirup/datatablectr/datatableruprekapkldi?idKldi=D128&tahun=2021'
	rup_penyedia_per_satker     = 'https://sirup.lkpp.go.id/sirup/datatablectr/dataruppenyediasatker?tahun=2021&idSatker=63401'
	rup_swakelola_per_satker    = 'https://sirup.lkpp.go.id/sirup/datatablectr/datarupswakelolasatker?tahun=2021&idSatker=63451'
	rup_penyedia_swa_per_satker = 'https://sirup.lkpp.go.id/sirup/datatablectr/dataruppenyediaswakelolaallrekap?tahun=2021&idSatker=104593'
	// anggaran
	rup_anggaran_kbm            = 'https://sirup.lkpp.go.id/sirup/datatablectr/datatableruprekapkldianggaran?tahun=2021&jenisKLPD=KABUPATEN&sSearch=Pemerintah+Daerah+Kabupaten+Kebumen'
	rup_anggaran_perkldi        = 'https://sirup.lkpp.go.id/sirup/datatablectr/datatableruprekapkldianggaranpersatker?idKldi=D128&tahun=2021'
)
*/
const (
	baseurl              = 'https://sirup.lkpp.go.id/' // rup base url
	basepath             = 'sirup/datatablectr/' // rup base path
	mainurl              = baseurl + basepath // rup main url
	// rekap
	kegiatan_sekbm       = 'sirup/ro/dt/klpd/2' // rekap kegiatan
	kegiatan_satker      = 'datatableruprekapkldi'
	kegiatan_sekbm_path  = baseurl + kegiatan_sekbm
	kegiatan_satker_path = mainurl + kegiatan_satker
	// anggaran
	anggaran_sekbm       = 'datatableruprekapkldianggaran'
	anggaran_satker      = 'datatableruprekapkldianggaranpersatker'
	anggaran_sekbm_path  = mainurl + anggaran_sekbm
	anggaran_satker_path = mainurl + anggaran_satker
	// rup sekabupaten/all satker
	pyd_allsatker        = 'dataruppenyediakldi'
	swa_allsatker        = 'datarupswakelolakldi'
	pds_allsatker        = 'dataruppenyediaswakelolaallrekapkldi'
	// all satker rup baseurl
	pyd_allsatker_path   = mainurl + pyd_allsatker
	swa_allsatker_path   = mainurl + swa_allsatker
	pds_allsatker_path   = mainurl + pds_allsatker
	// satker
	pyd_persatker        = 'dataruppenyediasatker'
	swa_persatker        = 'datarupswakelolasatker'
	pds_persatker        = 'dataruppenyediaswakelolaallrekap'
	// persatker rup baseurl
	pyd_persatker_path   = mainurl + pyd_persatker
	swa_persatker_path   = mainurl + swa_persatker
	pds_persatker_path   = mainurl + pds_persatker
)

struct RawResponse {
	raw_data      [][]string [json: 'aaData']
	total_display int        [json: 'iTotalDisplayRecords']
	secho         int        [json: 'sEcho']
}

// generic rup item
struct Rup {
mut:
	kode_rup       string
	satker         string
	nama_paket     string
	pagu           string
	metode         string
	sumber_dana    string
	awal_pemilihan string
	kegiatan       string
}

// rup swa
// "aaData":[["24944760","RSUD PREMBUN","Belanja Alat/bahan untuk Kegiatan Kantor-Bahan Cetak","3035000","APBD","24944760","January 2021",
// "Penyediaan Layanan Kesehatan untuk UKM dan UKP Rujukan Tingkat Daerah Kabupaten/Kota"]
// struct RupSwa {
//	Rup
// mut:
//	kegiatan string
//}
// rekap rup per satker
// "aaData":[["104593","BADAN KEPEGAWAIAN PENDIDIKAN DAN PELATIHAN DAERAH","0","0","0","0","0","0","0","0"]
struct Satker {
mut:
	kode         string
	nama         string
	tot_pyd      string
	tot_pagu_pyd string
	tot_swa      string
	tot_pagu_swa string
	tot_pds      string
	tot_pagu_pds string
	last_updated string
	year         string
}

enum TipeKeg {
	pyd
	swa
	pds
}

pub fn (tipe TipeKeg) str() string {
	return match tipe {
		.pyd { 'Penyedia' }
		.swa { 'Swakelola' }
		.pds { 'Penyedia dalam Swakelola' }
	}
}

enum JnsRekap {
	anggaran_sekbm
	anggaran_satker
	kegiatan_sekbm
	kegiatan_satker
}

pub fn (jrk JnsRekap) str() string {
	return match jrk {
		.anggaran_sekbm { 'Rekap anggaran kabupaten' }
		.anggaran_satker { 'Rekap anggaran semua satker' }
		.kegiatan_sekbm { 'Rekap kegiatan kabupaten' }
		.kegiatan_satker { 'Rekap kegiatan semua satker' }
	}
}

fn rekap_url_byjenis(jrk JnsRekap, tahun string) ?string {
	mut val := urllib.new_values()
	val.add('tahun', tahun)
	match jrk {
		.anggaran_sekbm {
			mut url := urllib.parse(anggaran_sekbm_path) ?
			val.add('jenisKLPD', 'KABUPATEN')
			val.add('sSearch', 'Pemerintah Daerah Kabupaten Kebumen')
			url.raw_query = val.encode()
			return url.str()
		}
		.anggaran_satker {
			mut url := urllib.parse(anggaran_satker_path) ?
			val.add('idKldi', 'D128')
			url.raw_query = val.encode()
			return url.str()
		}
		.kegiatan_sekbm {
			mut url := urllib.parse(kegiatan_sekbm_path) ?
			val.add('jenisID', 'KABUPATEN')
			val.add('sSearch', 'Pemerintah Daerah Kabupaten Kebumen')
			url.raw_query = val.encode()
			return url.str()
		}
		.kegiatan_satker {
			mut url := urllib.parse(kegiatan_satker_path) ?
			val.add('idKldi', 'D128')
			url.raw_query = val.encode()
			return url.str()
		}
	}
}

fn allsatker_url_bytipe(tipe TipeKeg, tahun string) ?string {
	mut val := urllib.new_values()
	val.add('idKldi', 'D128')
	val.add('tahun', tahun)
	match tipe {
		.pyd {
			mut url := urllib.parse(pyd_allsatker_path) ?
			url.raw_query = val.encode()
			return url.str()
		}
		.swa {
			mut url := urllib.parse(swa_allsatker_path) ?
			url.raw_query = val.encode()
			return url.str()
		}
		.pds {
			mut url := urllib.parse(pds_allsatker_path) ?
			url.raw_query = val.encode()
			return url.str()
		}
	}
}

fn persatker_url_bytipe(tipe TipeKeg, id_satker string, tahun string) ?string {
	mut val := urllib.new_values()
	val.add('tahun', tahun)
	val.add('idSatker', id_satker)
	match tipe {
		.pyd {
			mut url := urllib.parse(pyd_persatker_path) ?
			url.raw_query = val.encode()
			return url.str()
		}
		.swa {
			mut url := urllib.parse(swa_persatker_path) ?
			url.raw_query = val.encode()
			return url.str()
		}
		.pds {
			mut url := urllib.parse(pds_persatker_path) ?
			url.raw_query = val.encode()
			return url.str()
		}
	}
}
