package conf

type JWTYaml struct {
	DatabaseType             string   `yaml:"databaseType"`
	DatabaseConnectionString string   `yaml:"databaseConnectionString"`
	KID                      string   `yaml:"KID"`
	LocalIssuer              string   `yaml:"issuer"`
	LocalAudience            string   `yaml:"audience"`
	UltimateDelegateSaveMode string   `yaml:"ultimateDelegateSaveMode"` // unix/file
	UltimateDelegateStore    string   `yaml:"ultimateDelegateStore"`
	AllowedAudiences         []string `yaml:"allowedAudiences"`
	Algorithm                string   `yaml:"algorithm"`
	PublicKeyLoadMode        string   `yaml:"publicKeyLoadMode"` // unix/env/environment/file/str/string/
	PublicKey                string   `yaml:"publicKey"`
	PrivateKeyLoadMode       string   `yaml:"privateKeyLoadMode"` // unix/env/environment/file/str/string/
	PrivateKey               string   `yaml:"privateKey"`
}
