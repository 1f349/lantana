package conf

type RemoteServiceYaml struct {
	TargetNetwork                string `yaml:"network"`
	Target                       string `yaml:"target"`
	Type                         string `yaml:"type"`                  // http/bson
	DelegateTokenLoadMode        string `yaml:"delegateTokenLoadMode"` // unix/env/environment/file/str/string/
	DelegateToken                string `yaml:"delegateToken"`
	DelegateRefreshTokenLoadMode string `yaml:"delegateRefreshTokenLoadMode"` // unix/env/environment/file/str/string/
	DelegateRefreshToken         string `yaml:"delegateRefreshToken"`
}
