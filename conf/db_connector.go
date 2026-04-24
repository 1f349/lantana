package conf

import (
	"database/sql"
	"errors"
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
	if upgrade || reset {
		var drv database.Driver
		var m *migrate.Migrate
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
			m, err = migrate.NewWithDatabaseInstance(schemaPath, dbT, drv)
			if err != nil {
				_ = drv.Close()
				return db, err
			}
			defer func() {
				_, _ = m.Close()
			}()
			if reset {
				err = m.Drop()
			}
			if err != nil {
				return db, err
			}
			if upgrade {
				err = m.Up()
			}
			if err != nil {
				return db, err
			}
		}
	}
	return db, nil
}
