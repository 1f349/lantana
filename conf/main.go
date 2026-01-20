package conf

type MainYaml struct {
	DatabaseType             string            `yaml:"databaseType"`
	DatabaseConnectionString string            `yaml:"databaseConnectionString"`
	API                      APIYaml           `yaml:"api"`
	LotusService             RemoteServiceYaml `yaml:"lotusService"`
	ArumService              RemoteServiceYaml `yaml:"arumService"`
}
