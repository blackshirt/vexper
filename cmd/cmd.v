module main

import cli { Command, Flag }
import os

fn main() {
	mut root_cmd := Command{
		name: 'vexper'
		description: 'vexper rup experiment'
		// required_args: 1
		// execute: root_func
	}
	mut fetch_cmd := Command{
		name: 'fetch'
		description: 'fetch operation'
		usage: '<obj>'
		// commands : ['rup', 'rekap']
		required_args: 1
		execute: fetch_func
	}

	rup_cmd := Command{
		name: 'rup'
		description: 'fetch rup'
		usage: '<obj>'
		execute: fetch_rup_func
	}

	rekap_cmd := Command{
		name: 'rekap'
		description: 'Fetch rekap'
		usage: '<name>'
		execute: fetch_rekap_func
	}

	fetch_cmd.add_command(rup_cmd)
	fetch_cmd.add_command(rekap_cmd)

	root_cmd.add_command(fetch_cmd)
	root_cmd.setup()
	root_cmd.parse(os.args)
}

fn fetch_func(cmd Command) ? {
	sub := cmd.args[0]
	mut subcmds := []string{}
	for i in cmd.commands {
		subcmds << i.name
	}
	if sub !in subcmds {
		eprintln("Error sub command '$sub' not available")
		cmd.execute_help()
		return
	}
	println('fetch func run ...$sub')
}

fn fetch_rup_func(cmd Command) ? {
	println('fetch rup run ....')
}

fn fetch_rekap_func(cmd Command) ? {
	println('fetch rekap run ....')
}
