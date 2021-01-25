import sqlite
import url

fn main() {
	db := sqlite.connect('db.sqlite3') or { panic(err) }
	safe := true
	c := url.CPool{db, safe}
	res := url.parse_rekap_kegiatan_allsatker('2021') or { panic(err) }
	println('insert data to db')
	c.save_satker(res)
}
