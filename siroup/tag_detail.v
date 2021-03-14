module siroup

import net.html

// tags pembaharuan paket
// typical in html source
/*
<tr>
	<td class="label-left">Tanggal Perbarui Paket</td>
	<td>2020-12-29 11:47:38.533</td>
</tr>
*/
fn tags_pembaharuan(dr DetailResult) []&html.Tag {
	mut doc := html.parse(dr.body)
	mut res := []&html.Tag{}
	tags := doc.get_tag('td')
	for i, tag in tags {
		if tag.text() == 'Tanggal Perbarui Paket' {
			idx := i + 1
			res << tags[idx]
			return res
		}
	}
	return res
}

// tags kualifikasi usaha
/*
<tr>
	<td class="label-left">Usaha Kecil</td>
	<td><span class="badge">Ya</span></td>
</tr>
*/
fn tags_kualifikasi_usaha(dr DetailResult) []&html.Tag {
	mut doc := html.parse(dr.body)
	mut res := []&html.Tag{}
	tags := doc.get_tag('td')
	for i, tag in tags {
		if tag.text() == 'Usaha Kecil' {
			idx := i + 1
			res << tags[idx]
			return res
		}
	}
	return res
}

// tags jenis pengadaan
/*
<tr>
	<td class="label-left">Jenis Pengadaan</td>
	<td>Barang,</td>
</tr>
*/
fn tags_jenis_pengadaan(dr DetailResult) []&html.Tag {
	mut doc := html.parse(dr.body)
	mut res := []&html.Tag{}
	tags := doc.get_tag('td')
	for i, tag in tags {
		if tag.text() == 'Jenis Pengadaan' {
			idx := i + 1
			res << tags[idx]
			return res
		}
	}
	return res
}

// tags waktu penyedia
/* typical html response
<tr>
    <td class="label-left">Pemanfaatan Barang/Jasa</td>
    <td>
        <table class="table table-striped table-hover" style="font-size : x-small;">
            <tr>
                <th class="mid">Mulai</th>
                <th class="mid">Akhir</th>
            </tr>
            <tr>
                <td class="mid">Februari 2021</td>
                <td class="mid">Desember 2021</td>
            </tr>
        </table>
    </td>
</tr>
<tr>
    <td class="label-left">Jadwal Pelaksanaan Kontrak</td>
    <td>
        <table class="table table-striped table-hover" style="font-size : x-small;">
            <tr>
                <th class="mid">Mulai</th>
                <th class="mid">Akhir</th>
            </tr>
            <tr>
                <td class="mid">Februari 2021</td>
                <td class="mid">Desember 2021</td>
            </tr>
        </table>
    </td>
</tr>
<tr>
    <td class="label-left">Jadwal Pemilihan Penyedia</td>
    <td>
        <table class="table table-striped table-hover" style="font-size : x-small;">
            <tr>
                <th class="mid">Mulai</th>
                <th class="mid">Akhir</th>
            </tr>
            <tr>
                <td class="mid">Februari 2021</td>
                <td class="mid"> Februari 2021</td>
            </tr>
        </table>
    </td>
</tr>
*/
fn tags_waktu_penyedia(dr DetailResult) []&html.Tag {
	mut doc := html.parse(dr.body)
	mut res := []&html.Tag{}
	tags := doc.get_tag('td')
	for tag in tags {
		if 'class' in tag.attributes && tag.attributes['class'] == 'mid' {
			res << tag
		}
	}
	// res.len should == 6
	return res
}

// tags waktu swakelola dan tipe_swakelola
/*
<dt>Tipe Swakelola</dt>
<dd>: 1</dd>
<h4>PELAKSANAAN PEKERJAAN</h4>
<dd></dd>
<dt>Awal</dt>
<dd>: Januari 2021</dd>
<dt>Akhir</dt>
<dd>: Desember 2021</dd>
*/
fn tags_waktu_swakelola(dr DetailResult) []&html.Tag {
	mut doc := html.parse(dr.body)
	mut res := []&html.Tag{}
	tags := doc.get_tags() // no specific info about tag to find, so just get all tags blindly, 

	for i, tag in tags {
		if tag.text() == 'Tipe Swakelola' {
			idx := i + 1
			res << tags[idx]
		}
		if tag.text() == 'Awal' {
			idx := i + 1
			res << tags[idx]
		}
		if tag.text() == 'Akhir' {
			idx := i + 1
			res << tags[idx]
		}
	}
	return res
}
