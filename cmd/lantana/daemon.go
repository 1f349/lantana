package main

import (
	"context"
	"flag"
	"github.com/1f349/lantana/conf"
	"github.com/charmbracelet/log"
	"github.com/google/subcommands"
	"github.com/joho/godotenv"
	"gopkg.in/yaml.v3"
	"os"
	"os/signal"
	"path"
	"strings"
	"sync"
	"time"
)

type daemonCmd struct {
	configPath  string
	debug       bool
	multiAccess bool
}

func (d *daemonCmd) Name() string {
	return "daemon"
}

func (d *daemonCmd) Synopsis() string {
	return "Run the daemon"
}

func (d *daemonCmd) Usage() string {
	return `daemon [-config <config file>] [-debug]
  Run the daemon using the specified config file.
`
}

func (d *daemonCmd) SetFlags(f *flag.FlagSet) {
	f.StringVar(&d.configPath, "config", "", "/path/to/config.yml : path to the configuration file")
	f.BoolVar(&d.debug, "debug", false, "enable debug mode")
}

func (d *daemonCmd) Execute(_ context.Context, _ *flag.FlagSet, _ ...interface{}) subcommands.ExitStatus {
	log.Info("Starting daemon...")
	ct := time.Now()

	conf.Debug = d.debug
	eerr := godotenv.Load()
	if eerr == nil {
		log.Info(".env file loaded")
	}

	if d.configPath == "" {
		cwd, err := os.Getwd()
		if err == nil {
			if st, err := os.Stat(path.Join(cwd, ".data", "config.yml")); err == nil && !st.IsDir() {
				d.configPath = path.Join(cwd, ".data", "config.yml")
				log.Info("Configuration file found at .data/config.yml")
			}
		}
		if d.configPath == "" {
			log.Error("Configuration file path is required")
			return subcommands.ExitUsageError
		}
	}

	openConf, err := os.Open(d.configPath)
	if err != nil {
		if os.IsNotExist(err) {
			log.Error("Missing config file")
		} else {
			log.Error("Open config file: ", err)
		}
		return subcommands.ExitFailure
	}

	var cnf conf.MainYaml
	err = yaml.NewDecoder(openConf).Decode(&cnf)
	_ = openConf.Close()
	if err != nil {
		log.Error("Invalid config file: ", err)
		return subcommands.ExitFailure
	}

	db, err := conf.CreateDBConnection(cnf.Database.ConnectionString, getSchemaPath(cnf.Database.SchemaPath), hasVal(os.Getenv("DB_UPGRADE"), trues), hasVal(os.Getenv("DB_RESET"), trues))
	if err != nil {
		log.Error("Error connecting to database: ", err)
		return subcommands.ExitFailure
	}
	log.Info("Connected to database")
	defer func() {
		err := db.Close()
		if err != nil {
			log.Error("Error closing database connection: ", err)
		}
	}()
	dbTokens, err := conf.CreateDBConnection(cnf.API.JWT.Database.ConnectionString, getSchemaPath(cnf.API.JWT.Database.SchemaPath), hasVal(os.Getenv("DB_TOKEN_UPGRADE"), trues), hasVal(os.Getenv("DB_TOKEN_RESET"), trues))
	if err != nil {
		log.Error("Error connecting to token database: ", err)
		return subcommands.ExitFailure
	}
	log.Info("Connected to token database")
	defer func() {
		err := dbTokens.Close()
		if err != nil {
			log.Error("Error closing token database connection: ", err)
		}
	}()

	//TODO: Exec API here

	wg := &sync.WaitGroup{}
	wg.Add(1)
	sigChan := make(chan os.Signal, 1)
	log.Infof("Started daemon in '%s'.", time.Now().Sub(ct))
	signal.Notify(sigChan, os.Interrupt)

	go func() {
		<-sigChan
		ct = time.Now()
		log.Info("Stopping daemon...")
		//TODO: Close API here
		wg.Done()
	}()

	wg.Wait()
	log.Infof("Stopped daemon in '%s'.", time.Now().Sub(ct))

	return subcommands.ExitSuccess
}

var trues = []string{"1", "Y", "YES", "T", "TRUE"}

func hasVal(val string, vals []string) bool {
	for _, v := range vals {
		if strings.EqualFold(val, v) {
			return true
		}
	}
	return false
}

func getSchemaPath(pth string) string {
	if path.IsAbs(pth) {
		return conf.FileProtocol() + pth
	}
	cwd, err := os.Getwd()
	if err != nil {
		return conf.FileProtocol() + pth
	}
	return conf.FileProtocol() + path.Join(cwd, pth)
}
