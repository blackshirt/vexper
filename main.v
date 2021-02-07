import url
import sqlite
import sync
/*
import sqlite
import nedpals.vex.router
import nedpals.vex.server
import nedpals.vex.ctx
*/
fn main() {
	db := sqlite.connect('db.sqlite3') or { panic(err) }
	c := url.CPool{db, true}
	//rup := c.rup('27037643') or { return }
	//jp := url.jenpeng_for_rup(rup) or {return}
	//println(jp)
	rups := c.rup_from_satker('63421')
	urls := url.build_jenis_url_for_rups(rups) or {return}
	mut wg := sync.new_waitgroup()
	mut sto := []string{}
	for i in urls {
		wg.add(1)
		h := go url.send_request(i, mut wg)
		sto << h
	}
	wg.wait()
	println(sto)
	//println(urls)
	//println(rups)
	//mjp := url.jenpeng_array_rup(rups) or {return }
	//println(mjp)
	/*
	jnr := url.OpsiRekap{.kegiatan_satker}
	rek := url.fetch('2021', jnr)  or {return}
	res := url.parse_response(rek) or {return}
	data := res.data()
	mut stk := []url.RekapKegiatanSatker{}
	for item in data {
		m := item as url.RekapKegiatanSatker
		stk << m
	}
	c.save_kegiatan_satker(stk)
	*/
	
	//println(stk)
	//res := url.all_rup_from_satker('63408', '2021') or {panic(err)}
	//println("Fetch ....$res")
	//rups := url.parse_all_rup_from_satker(res) or {panic(err)}
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
	//res := url.all_rup('2021') ?
	//rups := url.parse_all_rup(res) ?
	//c.save_rup(rups)
	//res := c.daftar_satker()
	//println(res)
	
}

/*
db := sqlite.connect('db.sqlite3') or { panic(err) }
	c := url.CPool{db, true}
	
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
		db := &url.CPool(req.ctx)
		rows := db.rup_from_satker('63401')
		res.send_json<[]url.Rup>(rows, 200)
	})

	app.route(.get, '/penyedia', fn (req &ctx.Req, mut res ctx.Resp){
		db := &url.CPool(req.ctx)
		rows := db.penyedia()
		res.send_json<[]url.Rup>(rows, 200)
	})
	app.route(.get, '/swakelola', fn (req &ctx.Req, mut res ctx.Resp){
		db := &url.CPool(req.ctx)
		rows := db.swakelola()
		res.send_json<[]url.Rup>(rows, 200)
	})
	app.route(.get, '/penyediadlmswakelola', fn (req &ctx.Req, mut res ctx.Resp){
		db := &url.CPool(req.ctx)
		rows := db.penyediadlmswakelola()
		res.send_json<[]url.Rup>(rows, 200)
	})
	server.serve(app, 6789)
	
	}

*/
