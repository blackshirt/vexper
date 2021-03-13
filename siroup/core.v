// siroup module intended to be used as core library
module siroup

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

enum MetodePengadaan {
	tender
	swakelola
	epurchasing
	tendercepat
	dikecualikan
	pengadaanlangsung
	penunjukanlangsung
	unknown
}

pub fn (mp MetodePengadaan) str() string {
	return match mp {
		.tender { 'Tender' }
		.swakelola { 'Swakelola' }
		.epurchasing { 'e-Purchasing' }
		.tendercepat { 'Tender Cepat' }
		.dikecualikan { 'Dikecualikan' }
		.pengadaanlangsung { 'Pengadaan Langsung' }
		.penunjukanlangsung { 'Penunjukan Langsung' }
		.unknown {'Unknown'}
	}
}

pub fn metode_from_str(m string) MetodePengadaan {
	return match m {
		'Tender' { MetodePengadaan.tender }
		'Swakelola' { MetodePengadaan.swakelola }
		'e-Purchasing' { MetodePengadaan.epurchasing }
		'Tender Cepat' { MetodePengadaan.tendercepat }
		'Dikecualikan' { MetodePengadaan.dikecualikan }
		'Pengadaan Langsung' { MetodePengadaan.pengadaanlangsung }
		'Penunjukan Langsung' { MetodePengadaan.penunjukanlangsung }
		else {MetodePengadaan.unknown}
	}
}

enum JenisPengadaan {
	unknown
	barang
	konstruksi
	konsultansi
	jasalainnya
	sayembara
	swakelola
}

fn (j JenisPengadaan) str() string {
	return match j {
		.unknown { 'Unknown' }
		.barang { 'Barang' }
		.konstruksi { 'Pekerjaan Konstruksi' }
		.konsultansi { 'Jasa Konsultansi' }
		.jasalainnya { 'Jasa Lainnya' }
		.sayembara { 'Sayembara' }
		.swakelola { 'Swakelola' }
	}
}

fn jenis_pengadaan_from_str(jp string) JenisPengadaan {
	return match jp {
		'Barang' { JenisPengadaan.barang }
		'Pekerjaan Konstruksi' { JenisPengadaan.konstruksi }
		'Jasa Konsultansi' { JenisPengadaan.konsultansi }
		'Jasa Lainnya' { JenisPengadaan.jasalainnya }
		'Sayembara' { JenisPengadaan.sayembara }
		'Swakelola' { JenisPengadaan.swakelola }
		else { JenisPengadaan.unknown }
	}
}

// generic rup item
pub struct Rup {
mut:
	kode_rup             string
	kode_satker          string
	nama_satker          string
	nama_paket           string
	pagu                 string
	sumber_dana          string
	awal_pemilihan       string
	akhir_pemilihan      string
	awal_pelaksanaan     string // detail part
	akhir_pelaksanaan    string // detail part
	awal_pemanfaatan     string // detail part
	akhir_pemanfaatan    string // detail part
	kegiatan             string
	year                 string
	tipe                 string
	usaha_kecil          string // detail part
	tgl_perbaharui_paket string // detail part
	tipe_swakelola       string // untuk swakelola, detail part
	jenis                JenisPengadaan // detail part
	metode               string
	last_updated         string
}

fn (r Rup) is_penyedia() bool {
	return r.tipe == 'Penyedia' || r.tipe == 'Penyedia dalam Swakelola'
}

fn (r Rup) is_swakelola() bool {
	return r.tipe == 'Swakelola'
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
