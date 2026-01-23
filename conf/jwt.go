package conf

import "time"

type JWTYaml struct {
	Database                 DBYaml        `yaml:"database"`
	KID                      string        `yaml:"KID"`
	IssueLength              time.Duration `yaml:"issueLength"`
	LocalIssuer              string        `yaml:"issuer"`
	LocalAudience            string        `yaml:"audience"`
	UltimateDelegateSaveMode string        `yaml:"ultimateDelegateSaveMode"` // unix/file
	UltimateDelegateStore    string        `yaml:"ultimateDelegateStore"`
	AllowedAudiences         []string      `yaml:"allowedAudiences"`
	Algorithm                string        `yaml:"algorithm"`
	PublicKeyLoadMode        string        `yaml:"publicKeyLoadMode"` // unix/env/environment/file/str/string/
	PublicKey                string        `yaml:"publicKey"`
	PrivateKeyLoadMode       string        `yaml:"privateKeyLoadMode"` // unix/env/environment/file/str/string/
	PrivateKey               string        `yaml:"privateKey"`
}
