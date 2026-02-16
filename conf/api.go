package conf

import "strings"

type APIYaml struct {
	JWT           JWTYaml      `yaml:"jwt"`
	JWTKeys       []JWTKeyYaml `yaml:"jwtKeys"`
	BasePrefixURL string       `yaml:"basePrefixURL"`
	Domains       []string     `yaml:"domains"`
	HTTPListener  ListenYaml   `yaml:"httpListener"`
	BSONListener  ListenYaml   `yaml:"bsonListener"`
}

func (ay APIYaml) GetBasePrefixURL() string {
	bpURL := ay.BasePrefixURL
	if !strings.HasPrefix(bpURL, "/") {
		bpURL = "/" + bpURL
	}
	if strings.HasSuffix(bpURL, "/") {
		return bpURL
	} else {
		return bpURL + "/"
	}
}
