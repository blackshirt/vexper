// import sqlite
import url
import sqlite

fn main() {
	db := sqlite.connect('db.sqlite3') or { panic(err) }
	safe := true
	c := url.CPool{db, safe}
	// res := url.parse_rekap_kegiatan_allsatker('2021') or { panic(err) }
	// println('insert data to db')
	// c.save_satker(res)
	opt := url.Kegiatan{.pds, false, ''}
	//opt := url.Rekap{.kegiatan_satker}
	xres := url.fetch('2021', opt) or { return }
	// println(xres)
	xrs := url.parse_response(xres) or { return }
	println(xrs)
	data := xrs.data() //[]Store 
	/*
	mut stk := []url.RekapKegiatanSatker{}
	for item in data {
		m := item as url.RekapKegiatanSatker
		stk << m
	}
	c.save_rekap_keg_satker(stk)
	*/
	
	mut rups := []url.Rup{}
	for item in data {
		u := item as url.Rup
		rups << u
	}
	c.save_rup(rups)
	
}
