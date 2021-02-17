import cli { Command, Flag }
import os

const (
	default_db = 'db.sqlite'
)

fn new_app() Command {
	mut root_cmd := Command{
		name: 'vexper'
		description: 'vexper rup system'
	}

	root_cmd.add_flag(Flag{
		flag: .string
		name: 'db'
		abbrev: 'd'
		description: 'sqlite database to use'
		global: true
	})

	mut rup_cmd := Command{
		name: 'rup'
		description: 'rup operation'
		usage: '<command>'
		execute: rup_cb
		required_args: 1
	}

	mut rekap_cmd := Command{
		name: 'rekap'
		description: 'get rekap'
		usage: '<tipe_rekap>'
		execute: rekap_cb
	}

	mut rup_update_cmd := Command{
		name: 'update'
		description: 'perform update on rup database'
		execute: rup_update_cb
	}

	mut rup_diff_cmd := Command{
		name: 'diff'
		description: 'show different parts between rup database in db and from net'
		execute: rup_diff_cb
	}
	mut rup_stats_cmd := Command{
		name: 'stats'
		description: 'statistics of rup database'
		execute: rup_stats_cb
	}
	rup_cmd.add_commands([rup_update_cmd, rup_stats_cmd, rup_diff_cmd])
	root_cmd.add_commands([rup_cmd, rekap_cmd])
	return root_cmd
}

fn main() {
	mut app := new_app()
	inject_db_flag(mut app)
	app.setup()
	app.parse(os.args)
}

fn inject_db_flag(mut cmd Command) {
	if cmd.is_root() {
		db := cmd.flags.get_string('db') or { return }
		if db == '' {
			if cmd.flags[0].name == 'db' {
				cmd.flags[0].value = default_db
			}
		}
	}
}

fn rup_cb(cmd Command) ? {
	println(cmd.args)
	db := cmd.flags.get_string('db') or { return }
	println(db)
	t := cmd.flags.get_string('tipe') or { return }
	println(t)
	if t == '' {
		cmd.execute_help()
	}
}

fn rekap_cb(cmd Command) ? {
	println('Rekap operation ...')
}

fn rup_stats_cb(cmd Command) ? {
	db := cmd.flags.get_string('db') or { return }
	println(db)
}

fn rup_update_cb(cmd Command) ? {
	println('Rup update ....')
}

fn rup_diff_cb(cmd Command) ? {
	println('Rup diff .....')
}
