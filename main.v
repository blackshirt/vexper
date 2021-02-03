import url
import sqlite
/*
import sqlite
import nedpals.vex.router
import nedpals.vex.server
import nedpals.vex.ctx
*/
fn main() {
	db := sqlite.connect('db.sqlite3') or { panic(err) }
	c := url.CPool{db, true}
	/*
	jk := url.Rekap{.kegiatan_satker}
	rek := url.fetch('2021', jk)  or {return}
	res := url.parse_response(rek) or {return}
	data := res.data()
	mut stk := []url.RekapKegiatanSatker{}
	for item in data {
		m := item as url.RekapKegiatanSatker
		stk << m
	}
	c.save_kegiatan_satker(stk)'
	*/
	
	//println(stk)
	res := url.fetch_all_rup_from_satker('63406', '2021') or {return}
	//println(res)
	rups := url.parse_all_rup_from_satker(res, '63406', '2021') or {return}
	//for rup in rups {
	//	println(rup)
	//}
	//println(rups)
	c.save_rup(rups)
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
