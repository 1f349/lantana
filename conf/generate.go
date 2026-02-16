package conf

import (
	"github.com/charmbracelet/log"
	"gopkg.in/yaml.v3"
	"io"
	"time"
)

func Generate(target io.Writer) {
	cEnc := yaml.NewEncoder(target)
	//Conf Defaults
	cnf := &MainYaml{
		Database: DBYaml{
			ConnectionString: "mysql:root:password@tcp(localhost:3306)/database",
			SchemaPath:       "schema/mail",
		},
		API: APIYaml{
			JWT: JWTYaml{
				Database: DBYaml{
					ConnectionString: "sqlite:tokens.sqlite",
					SchemaPath:       "schema/token",
				},
				KID:                      "test",
				IssueLength:              time.Hour * 24 * 7,
				LocalIssuer:              "example.com",
				LocalAudience:            "lantana-1",
				UltimateDelegateSaveMode: "stdout",
				UltimateDelegateStore:    "token",
				AllowedAudiences:         []string{"lantana-1"},
			},
			JWTKeys: []JWTKeyYaml{{
				KID:                "test",
				Algorithm:          "none",
				PublicKeyLoadMode:  "",
				PublicKey:          "",
				PrivateKeyLoadMode: "",
				PrivateKey:         "",
			}},
			BasePrefixURL: "example.com/lantana/",
			Domains:       []string{"example.com"},
			HTTPListener: ListenYaml{
				Network:      "tcp",
				Address:      "localhost:8180",
				ReadTimeout:  time.Minute,
				WriteTimeout: time.Minute,
				ReadLimit:    1024 * 1024 * 17,
			},
			BSONListener: ListenYaml{
				Network:      "tcp",
				Address:      "localhost:9180",
				ReadTimeout:  time.Minute,
				WriteTimeout: time.Minute,
				ReadLimit:    1024 * 1024 * 16,
			},
		},
		LotusService: RemoteServiceYaml{
			TargetNetwork:                "tcp",
			Target:                       "localhost:8181",
			Type:                         "http",
			DelegateTokenLoadMode:        "env",
			DelegateToken:                "lotus_delegate",
			DelegateRefreshTokenLoadMode: "env",
			DelegateRefreshToken:         "lotus_refresh",
		},
		ArumService: RemoteServiceYaml{
			TargetNetwork:                "tcp",
			Type:                         "bson",
			Target:                       "localhost:9182",
			DelegateTokenLoadMode:        "env",
			DelegateToken:                "arum_delegate",
			DelegateRefreshTokenLoadMode: "env",
			DelegateRefreshToken:         "arum_refresh",
		},
	}
	err := cEnc.Encode(&cnf)
	if err != nil {
		log.Error(err)
	}
}
