package conf

type APIYaml struct {
	JWT           JWTYaml    `yaml:"jwt"`
	BasePrefixURL string     `yaml:"basePrefixURL"`
	Domains       []string   `yaml:"domains"`
	HTTPListener  ListenYaml `yaml:"httpListener"`
	BSONListener  ListenYaml `yaml:"bsonListener"`
}
