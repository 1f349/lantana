package conf

type DBYaml struct {
	ConnectionString string `yaml:"connectionString"`
	SchemaPath       string `yaml:"schemaPath"`
}
