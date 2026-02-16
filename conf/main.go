package conf

var Debug bool

type MainYaml struct {
	Database     DBYaml            `yaml:"database"`
	API          APIYaml           `yaml:"api"`
	LotusService RemoteServiceYaml `yaml:"lotusService"`
	ArumService  RemoteServiceYaml `yaml:"arumService"`
}
