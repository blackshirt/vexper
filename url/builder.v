module url

import net.urllib

fn rekap_url_byjenis(jk JnsRekap, tahun string) ?string {
	mut val := urllib.new_values()
	val.add('tahun', tahun)
	match jk {
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

fn allsatker_url_bytipe(tp TipeKeg, tahun string) ?string {
	mut val := urllib.new_values()
	val.add('idKldi', 'D128')
	val.add('tahun', tahun)
	match tp {
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

fn persatker_url_bytipe(tp TipeKeg, id_satker string, tahun string) ?string {
	mut val := urllib.new_values()
	val.add('tahun', tahun)
	val.add('idSatker', id_satker)
	match tp {
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
