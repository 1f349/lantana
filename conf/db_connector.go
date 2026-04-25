package conf

import (
	"database/sql"
	"errors"
	"github.com/charmbracelet/log"
	_ "github.com/go-sql-driver/mysql"
	"github.com/golang-migrate/migrate/v4"
	"github.com/golang-migrate/migrate/v4/database"
	"github.com/golang-migrate/migrate/v4/database/mysql"
	"github.com/golang-migrate/migrate/v4/database/sqlite"
	_ "github.com/golang-migrate/migrate/v4/source/file"
	_ "github.com/mattn/go-sqlite3"
	"strings"
)

var DBTypeMissing = errors.New("database type missing")
var DBConnectMissing = errors.New("database connection string missing")

func CreateDBConnection(connection, schemaPath string, upgrade, reset bool) (*sql.DB, error) {
	sIdx := strings.Index(connection, ":")
	if sIdx < -1 {
		return nil, DBTypeMissing
	} else if sIdx == len(connection)-1 || sIdx == 0 {
		return nil, DBConnectMissing
	}
	dbT := connection[:sIdx]
	db, err := sql.Open(dbT, connection[sIdx+1:])
	if err != nil {
		return nil, err
	}
	var drv database.Driver
	var m *migrate.Migrate
	if reset {
		switch dbT {
		case "mysql":
			drv, err = mysql.WithInstance(db, &mysql.Config{})
		case "sqlite", "sqlite3":
			drv, err = sqlite.WithInstance(db, &sqlite.Config{})
		}
		if err != nil {
			return db, err
		}
		if drv != nil {
			if Debug {
				log.Info("Database Instance Connected") // DEBUG
			}
			m, err = migrate.NewWithDatabaseInstance(schemaPath, dbT, drv)
			if err != nil {
				_ = drv.Close()
				return db, err
			}
			if Debug {
				log.Debug("Database Instance Migrator Activated") // DEBUG
			}
			defer func() {
				_, _ = m.Close()
			}()
			if Debug {
				log.Debug("Database Instance Dropping") // DEBUG
			}
			err = m.Drop()
			/*if err == nil {
				err = m.Force(-1)
			}*/
			if err != nil {
				return db, err
			}
		}
	}
	err = nil
	drv = nil
	m = nil
	if upgrade {
		switch dbT {
		case "mysql":
			drv, err = mysql.WithInstance(db, &mysql.Config{})
		case "sqlite", "sqlite3":
			drv, err = sqlite.WithInstance(db, &sqlite.Config{})
		}
		if err != nil {
			return db, err
		}
		if drv != nil {
			if Debug {
				log.Debug("Database Instance Connected") // DEBUG
			}
			m, err = migrate.NewWithDatabaseInstance(schemaPath, dbT, drv)
			if err != nil {
				_ = drv.Close()
				return db, err
			}
			if Debug {
				log.Debug("Database Instance Migrator Activated") // DEBUG
			}
			defer func() {
				_, _ = m.Close()
			}()
			if Debug {
				log.Debug("Database Instance Upgrading") // DEBUG
			}
			err = m.Up()
			if err != nil {
				return db, err
			}
		}
	}
	return db, nil
}
