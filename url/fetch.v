module url

import net.http

fn fetch_rekap(jk JRek, tahun string) ?string {
	match jk {
		.anggaran_sekbm {
			url := rekap_url_byjenis(.anggaran_sekbm, tahun) ?
			res := http.get_text(url)
			return res
		}
		.anggaran_satker {
			url := rekap_url_byjenis(.anggaran_satker, tahun) ?
			res := http.get_text(url)
			return res
		}
		.kegiatan_sekbm {
			url := rekap_url_byjenis(.kegiatan_sekbm, tahun) ?
			res := http.get_text(url)
			return res
		}
		.kegiatan_satker {
			url := rekap_url_byjenis(.kegiatan_satker, tahun) ?
			res := http.get_text(url)
			return res
		}
	}
}

pub fn (tipe TKeg) str() string {
	return match tipe {
		.pyd { 'Penyedia' }
		.swa { 'Swakelola' }
		.pds { 'Penyedia dalam Swakelola' }
	}
}

fn fetch_persatker(tipe TKeg, id_satker string, tahun string) ?string {
	match tipe {
		.pyd {
			url := persatker_url_bytipe(.pyd, id_satker, tahun) ?
			res := http.get_text(url)
			return res
		}
		.swa {
			url := persatker_url_bytipe(.swa, id_satker, tahun) ?
			res := http.get_text(url)
			return res
		}
		.pds {
			url := persatker_url_bytipe(.pds, id_satker, tahun) ?
			res := http.get_text(url)
			return res
		}
	}
}

fn fetch_allsatker(tipe TKeg, tahun string) ?string {
	match tipe {
		.pyd {
			url := allsatker_url_bytipe(.pyd, tahun) ?
			res := http.get_text(url)
			return res
		}
		.swa {
			url := allsatker_url_bytipe(.swa, tahun) ?
			res := http.get_text(url)
			return res
		}
		.pds {
			url := allsatker_url_bytipe(.pds, tahun) ?
			res := http.get_text(url)
			return res
		}
	}
}
