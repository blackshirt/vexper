module url
import sync
import time
import net.html
import net.http
import net.urllib

const (
	base = 'https://sirup.lkpp.go.id/sirup/home/'
	swa = 'detailPaketSwakelolaPublic2017'
	pyd = 'detailPaketPenyediaPublic2017'

	swa_path = base + swa
	pyd_path = base + pyd
)

fn jenis_url(tpk TipeKeg, kode_rup string) ?string {
	mut val := urllib.new_values()
	match tpk {
		.pyd, .pds {
			path := pyd_path + '/' + kode_rup
			url := urllib.parse(path) ?
			return url.str() 
		}
		.swa {
			val.add('idPaket',  kode_rup)
			mut url := urllib.parse(swa_path) ?
			url.raw_query = val.encode()
			return url.str()
		}
	}
	return error('Not matching tipe kegiatan or kode rup')
}

fn find_index_jenis(tags []&html.Tag) ?int {
	for i, tag in tags {
		if tag.text() == 'Jenis Pengadaan' {
			return i+1
		}
	}
	return error("Not found")
}

fn value_jenis(tags []&html.Tag) ?string {
	idx := find_index_jenis(tags) ?
	return tags[idx].text().trim_right(',') // the value contains comma, trim it
}

pub fn jenpeng_for_rup(rup Rup) ?JenPeng {
	if rup.tipe == 'Swakelola' {
		return .swakelola
	}
	if rup.tipe == 'Penyedia' || rup.tipe == 'Penyedia dalam Swakelola' {
		url := jenis_url(.pyd, rup.kode_rup) ?
		res := http.get_text(url)
		doc := html.parse(res)
		tags := doc.get_tag('td')
		val := value_jenis(tags)?
		return jenis_pengadaan_from_str(val)
	}
	return .unknown
}


pub fn build_jenis_url_for_rups(rups []Rup) ?[]string {
	mut res := []string{}
	for rup in rups {
		url := jenis_url(tipekeg_from_str(rup.tipe), rup.kode_rup) ?
		res << url
	}
	return res
}

pub fn send_request(url string, mut wg sync.WaitGroup) ?string {
    start := time.ticks()
    data := http.get(url)?
    finish := time.ticks()
    println('Finish $url time ${finish - start} ms')
	wg.done()
	println(data.text)
    return data.text
}

/*
pub fn jenpeng_array_rup(rups []Rup) ?[][]string {
	mut mjp := [][]string{}
	for rup in rups {
		mut item := []string{}
		jp := go jenpeng_for_rup(rup) ?
		h := jp.wait()
		item << rup.kode_rup
		item << h.str()
		println("Rup --- $rup.kode_rup")
		mjp << item
		println(mjp)
	}
	return mjp
}
*/