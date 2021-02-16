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

	mut update_op := Command{
		name: 'update'
		description: 'update operation'
		usage: '<object>'
		execute: update_cb
	}
	update_op.add_flag(Flag{
		flag: .string
		name: 'tipe'
		abbrev: 't'
		description: 'tipe to update'
	})

	mut stats_op := Command{
		name: 'stats'
		description: 'statistic of the database'
		execute: stats_cb
	}
	root_cmd.add_commands([update_op, stats_op])
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
				cmd.flags[0].value << default_db
			}
		}
	}
}

fn update_cb(cmd Command) ? {
	println(cmd.args)
	db := cmd.flags.get_string('db') or { return }
	println(db)
	t := cmd.flags.get_string('tipe') or {return}
	println(t)
	if t == '' {
		cmd.execute_help()
	}
}

fn stats_cb(cmd Command) ? {
	db := cmd.flags.get_string('db') or { return }
	println(db)
}