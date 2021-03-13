import siroup
import sqlite
import sync.pool
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
	
	res := siroup.all_rup_from_satker('63408', '2021') or {panic(err)}
	//println(res)
	rups := siroup.parse_rup_from_satker(res) or {panic(err)}
	//println(rups)
	diff := c.compare_rups(rups) or { panic(err)}
	println(diff)
	*/
	
	
	/*
	Concurrent version get detail rups
	
	rchan := chan siroup.DetailResult{}
	rch := chan siroup.DetailPropertiRup{}
	drs := c.fetch_detail_from_satker_conccurently('63421', rchan) or {return}
	//println(drs)
	dpr := siroup.decode_detail_concurrently(drs, rch)
	//println(dpr)
	c.update_detail(dpr)
	rchan.close()
	rch.close()
	*/


	/*
	thread version of detail
	
	res := c.thread_version_fetch_detail_from_satker('63408')
	//println(res)
	dpr := siroup.decode_detail(res)
	c.update_detail(dpr) or {panic(err.msg)}
	*/

	/*
	rewrite using sync.pool based fetcher and decode
	*/
	//let gets []Rup array
	rups_in_unknown := c.rup_from_satker_in_unknown("63421") or { 
		eprintln("error")
		exit(-1)
	}
	//println(rups_in_unknown)

	// let setup pool processor
	mut pp := pool.new_pool_processor(callback: siroup.fetch_and_decode_worker)
	// lets pool work on items on unupdated array of rup above
	pp.work_on_items<siroup.Rup>(rups_in_unknown)
	// get results
	for dr in pp.get_results<siroup.DetailResult>() {
		
		item := dr.decode()
		println(item)
	}
	
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
