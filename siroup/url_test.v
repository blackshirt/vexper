module siroup

fn test_persatker_url_bytipe() {
	res1 := persatker_url_bytipe(.pyd, '63401', '2022') or { return }
	assert res1 ==
		'https://sirup.lkpp.go.id/sirup/datatablectr/dataruppenyediasatker?idSatker=63401&tahun=2022'
	res2 := persatker_url_bytipe(.swa, '63401', '2021') or { return }
	assert res2 ==
		'https://sirup.lkpp.go.id/sirup/datatablectr/datarupswakelolasatker?idSatker=63401&tahun=2021'
	res3 := persatker_url_bytipe(.pds, '104593', '2021') or { return }
	assert res3 ==
		'https://sirup.lkpp.go.id/sirup/datatablectr/dataruppenyediaswakelolaallrekap?idSatker=104593&tahun=2021'
}

fn test_allsatker_url_bytipe() {
	res1 := allsatker_url_bytipe(.pyd, '2021') or { return }
	assert res1 ==
		'https://sirup.lkpp.go.id/sirup/datatablectr/dataruppenyediakldi?idKldi=D128&tahun=2021'
	res2 := allsatker_url_bytipe(.swa, '2021') or { return }
	assert res2 ==
		'https://sirup.lkpp.go.id/sirup/datatablectr/datarupswakelolakldi?idKldi=D128&tahun=2021'
	res3 := allsatker_url_bytipe(.pds, '2021') or { return }
	assert res3 ==
		'https://sirup.lkpp.go.id/sirup/datatablectr/dataruppenyediaswakelolaallrekapkldi?idKldi=D128&tahun=2021'
}

fn test_rekap_url_byjenis() {
	res1 := rekap_url_byjenis(.kegiatan_sekbm, '2021') or { return }
	assert res1 ==
		'https://sirup.lkpp.go.id/sirup/ro/dt/klpd/2?jenisID=KABUPATEN&sSearch=Pemerintah+Daerah+Kabupaten+Kebumen&tahun=2021'
	res2 := rekap_url_byjenis(.kegiatan_satker, '2021') or { return }
	assert res2 ==
		'https://sirup.lkpp.go.id/sirup/datatablectr/datatableruprekapkldi?idKldi=D128&tahun=2021'
	res3 := rekap_url_byjenis(.anggaran_sekbm, '2021') or { return }
	assert res3 ==
		'https://sirup.lkpp.go.id/sirup/datatablectr/datatableruprekapkldianggaran?jenisKLPD=KABUPATEN&sSearch=Pemerintah+Daerah+Kabupaten+Kebumen&tahun=2021'
	res4 := rekap_url_byjenis(.anggaran_satker, '2021') or { return }
	assert res4 ==
		'https://sirup.lkpp.go.id/sirup/datatablectr/datatableruprekapkldianggaranpersatker?idKldi=D128&tahun=2021'
}
