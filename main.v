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
	//rup := c.rup_with_kode('26470707') or { panic(err) }
	//jp := siroup.jenpeng_for_rup(rup) or {return}
	//println(jp)
	//rups := c.rup_from_satker('63421')
	//urls := siroup.build_jenis_url_for_rups(rups) or {return}
	//first_5urls := urls[..4]
	//println(first_5urls)
	
	//jnres := chan siroup.DetailResult{}
	//u := siroup.detail_rup_url(.pyd, '27219230') or {return}
	//res := siroup.fetch_detail(rup) or {return}
	//println(res)
	//println(u)
	//go siroup.send_request(u, jnres)
	//mut result := siroup.DetailResult{}
	//result = <- jnres
	//println(dr)
	//sisa := res.decode()
	//println(sisa)
	//jnres.close()
	
	
	/*
	for i in urls {
		go siroup.send_request(i, jnres)
	}
	mut res := []siroup.DetailResult{}
	for i := 0; i < urls.len; i++ {
		item := <- jnres
		res << item
	}
	for u in res {
		println(u.url)
	}
	*/
	//res := siroup.jenpeng_array_rup(rups, jnres) ?
	//jnres.close()
	//println(res)
	//println(urls)
	//println(rups)
	//mjp := siroup.jenpeng_array_rup(rups) or {return }
	//println(mjp)
	/*
	jnr := siroup.OpsiRekap{.kegiatan_satker}
	rek := siroup.fetch('2021', jnr)  or {return}
	res := siroup.parse_response(rek) or {return}
	data := res.data()
	mut stk := []siroup.RekapKegiatanSatker{}
	for item in data {
		m := item as siroup.RekapKegiatanSatker
		stk << m
	}
	c.save_kegiatan_satker(stk)
	*/
	
	//println(stk)
	//res := siroup.all_rup_from_satker('63408', '2021') or {panic(err)}
	//println("Fetch ....$res")
	//rups := siroup.parse_all_rup_from_satker(res) or {panic(err)}
	//c.save_rup(rups)
	//println("Rups....$rups")
	//println("from db")
	//dbrup := c.rup_from_satker('99566')
	//println("rup from db....$dbrup")
	//diff := c.compare(rups) or {panic(err)}
	//println(diff)
	//for rup in rups {
	//	println(rup)
	//}
	//println(rups)
	//res := siroup.all_rup('2021') or {panic(err)}
	//rups := siroup.parse_all_rup(res) or {panic(err)}
	//c.save_rup(rups)
	//res := c.daftar_satker()
	//println(res)
	//rups_satker := c.rup_from_satker('63408')
	
	rchan := chan siroup.DetailResult{}
	rch := chan siroup.DetailPropertiRup{}
	drs := c.fetch_detail_from_satker_conccurently('63421', rchan) or {return}
	//println(drs)
	dpr := siroup.decode_detail(drs, rch)
	//println(dpr)
	c.update_detail(dpr)
	rchan.close()
	rch.close()
	
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
