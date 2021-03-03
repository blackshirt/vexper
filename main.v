import siroup
import sqlite
//import sync
/*
import sqlite
import nedpals.vex.router
import nedpals.vex.server
import nedpals.vex.ctx
*/
fn main() {
	db := sqlite.connect('db.sqlite3') or { panic(err) }
	c := siroup.CPool{db, true}

	/*
	Untuk mengambil rekap kegiatan satker
	
	
	opsi := siroup.JnsRekap.kegiatan_satker
	rek := siroup.fetch_rekap('2021', opsi) or {return}
	res := siroup.parse_rekap(rek) or {return}
	
	mut stk := []siroup.RekapKegiatanSatker{}
	for item in res {
		m := item as siroup.RekapKegiatanSatker
		stk << m
	}
	c.save_kegiatan_satker(stk) or {panic(err)}
	*/
	

	/*
	Untuk mengambil semua rup dan menyimpan ke db
	
	res := siroup.all_rup('2021') ?
	rups := siroup.parse_all_rup(res) or {panic(err)}
	c.save_rups(rups) or { panic(err) }
	*/


	/*
	Untuk mengcompare rups di db dan dari net
	*/
	res := siroup.all_rup_from_satker('63412', '2021') or {panic(err)}
	//println(res)
	rups := siroup.parse_rup_from_satker(res) or {panic(err)}
	//println(rups)
	diff := c.compare_array_rup(rups) or { panic(err)}
	println(diff)
	
	
	
	/*
	Concurrent version get detail rups
	*/
	//rchan := chan siroup.DetailResult{}
	//rch := chan siroup.DetailPropertiRup{}
	//drs := c.fetch_detail_from_satker_conccurently('63421', rchan) or {return}
	//println(drs)
	//dpr := siroup.decode_detail(drs, rch)
	//println(dpr)
	//c.update_detail(dpr)
	//rchan.close()
	//rch.close()
	
}

/*
db := sqlite.connect('db.sqlite3') or { panic(err) }
	c := siroup.CPool{db, true}
	
	mut app := router.new()
	app.inject(c)
	app.route(.get, '/assets/*filename', fn (req &ctx.Req, mut res ctx.Resp) {
		filename := req.params['filename']
		res.send_file('/assets/$filename', 200)
	})
	app.route(.get, '/', fn (req &ctx.Req, mut res ctx.Resp) {
		res.send_file('index.html', 200)
	})
	app.route(.get, '/rups', fn (req &ctx.Req, mut res ctx.Resp) {
		db := &siroup.CPool(req.ctx)
		rows := db.rup_from_satker('63401')
		res.send_json<[]siroup.Rup>(rows, 200)
	})

	app.route(.get, '/penyedia', fn (req &ctx.Req, mut res ctx.Resp){
		db := &siroup.CPool(req.ctx)
		rows := db.penyedia()
		res.send_json<[]siroup.Rup>(rows, 200)
	})
	app.route(.get, '/swakelola', fn (req &ctx.Req, mut res ctx.Resp){
		db := &siroup.CPool(req.ctx)
		rows := db.swakelola()
		res.send_json<[]siroup.Rup>(rows, 200)
	})
	app.route(.get, '/penyediadlmswakelola', fn (req &ctx.Req, mut res ctx.Resp){
		db := &siroup.CPool(req.ctx)
		rows := db.penyediadlmswakelola()
		res.send_json<[]siroup.Rup>(rows, 200)
	})
	server.serve(app, 6789)
	
	}

*/
