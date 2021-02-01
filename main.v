import url
import sqlite
import nedpals.vex.router
import nedpals.vex.server
import nedpals.vex.ctx


fn main() {
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
