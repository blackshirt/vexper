// url module intended to be used as core library
module url

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
	kode_satker    string
	nama_satker    string
	nama_paket     string
	pagu           string
	metode         string
	sumber_dana    string
	awal_pemilihan string
	kegiatan       string
	last_updated   string
	year           string
	tipe           string
	jenis          JenPeng
}

// rup swa
// "aaData":[["24944760","RSUD PREMBUN","Belanja Alat/bahan untuk Kegiatan Kantor-Bahan Cetak","3035000","APBD","24944760","January 2021",
// "Penyediaan Layanan Kesehatan untuk UKM dan UKP Rujukan Tingkat Daerah Kabupaten/Kota"]
// struct RupSwa {
//	Rup
// mut:
//	kegiatan string
//}
enum JenPeng {
	unknown
	barang
	konstruksi
	konsultansi
	jasalainnya
	sayembara
}

fn (j JenPeng) str() string {
	return match j {
		.unknown { 'Unknown' }
		.barang { 'Barang' }
		.konstruksi { 'Konstruksi' }
		.konsultansi { 'Konsultansi' }
		.jasalainnya { 'Jasa lainnya' }
		.sayembara { 'Sayembara' }
	}
}

fn jenis_pengadaan_from_str(jp string) JenPeng {
	return match jp {
		'Barang' { JenPeng.barang }
		'Konstruksi' { JenPeng.konstruksi }
		'Konsultansi' { JenPeng.konsultansi }
		'Jasa lainnya' { JenPeng.jasalainnya }
		'Sayembara' { JenPeng.sayembara }
		else { JenPeng.unknown }
	}
}

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

pub fn tipekeg_from_str(tk string) TipeKeg {
	return match tk {
		'Penyedia' { TipeKeg.pyd }
		'Swakelola' { TipeKeg.swa }
		'Penyedia dalam Swakelola' { TipeKeg.pds }
		else { TipeKeg.swa }
	}
}

enum JnsRekap {
	anggaran_sekbm
	anggaran_satker
	kegiatan_sekbm
	kegiatan_satker
}

pub fn (jk JnsRekap) str() string {
	return match jk {
		.anggaran_sekbm { 'Rekap anggaran kabupaten' }
		.anggaran_satker { 'Rekap anggaran semua satker' }
		.kegiatan_sekbm { 'Rekap kegiatan kabupaten' }
		.kegiatan_satker { 'Rekap kegiatan semua satker' }
	}
}

pub struct Kegiatan {
	keg        TipeKeg
	per_satker bool
	id_satker  string
}

pub struct Rekap {
	jk JnsRekap
}

type Tipe = Kegiatan | Rekap

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
	last_updated       string
	year               string
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
	last_updated            string
	year                    string
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
	last_updated  string
	year          string
}

// rekap rup per satker
// "aaData":[["104593","BADAN KEPEGAWAIAN PENDIDIKAN DAN PELATIHAN DAERAH","0","0","0","0","0","0","0","0"]
struct RekapKegiatanSatker {
mut:
	kode_satker  string
	nama_satker  string
	tot_pyd      string
	tot_pagu_pyd string
	tot_swa      string
	tot_pagu_swa string
	tot_pds      string
	tot_pagu_pds string
	last_updated string
	year         string
}

enum MePeng {
	tender
	swakelola
	epurchasing
	tendercepat
	dikecualikan
	pengadaanlangsung
	penunjukanlangsung
}

pub fn (mp MePeng) str() string {
	return match mp {
		.tender { 'Tender' }
		.swakelola { 'Swakelola' }
		.epurchasing { 'e-Purchasing' }
		.tendercepat { 'Tender Cepat' }
		.dikecualikan { 'Dikecualikan' }
		.pengadaanlangsung { 'Pengadaan Langsung' }
		.penunjukanlangsung { 'Penunjukan Langsung' }
	}
}

pub fn method_from_str(m string) MePeng {
	return match m {
		'Tender' { MePeng.tender }
		'Swakelola' { MePeng.swakelola }
		'e-Purchasing' { MePeng.epurchasing }
		'Tender Cepat' { MePeng.tendercepat }
		'Dikecualikan' { MePeng.dikecualikan }
		'Pengadaan Langsung' { MePeng.pengadaanlangsung }
		'Penunjukan Langsung' { MePeng.penunjukanlangsung }
		else { MePeng.pengadaanlangsung }
	}
}
