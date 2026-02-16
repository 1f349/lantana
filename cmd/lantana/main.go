package main

import (
	"context"
	"flag"
	"github.com/charmbracelet/log"
	"github.com/google/subcommands"
	"os"
)

var (
	buildVersion = "develop"
	buildDate    = ""
	productName  = "lantana"
)

func main() {
	log.Printf("%s #%s (%s)", productName, buildVersion, buildDate)
	log.Printf("(C) 1f349 2026 - GPL v3")
	subcommands.Register(subcommands.HelpCommand(), "")
	subcommands.Register(subcommands.FlagsCommand(), "")
	subcommands.Register(subcommands.CommandsCommand(), "")
	subcommands.Register(&daemonCmd{}, "")
	subcommands.Register(&generateCmd{}, "")

	flag.Parse()
	ctx := context.Background()
	os.Exit(int(subcommands.Execute(ctx)))
}
