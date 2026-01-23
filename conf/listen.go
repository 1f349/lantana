package conf

import (
	"time"
)

type ListenYaml struct {
	Network      string        `yaml:"network"`
	Address      string        `yaml:"address"`
	ReadTimeout  time.Duration `yaml:"readTimeout"`
	WriteTimeout time.Duration `yaml:"writeTimeout"`
	ReadLimit    uint32        `yaml:"readLimit"`
}

func (ly ListenYaml) GetReadTimeout() time.Duration {
	if (ly.ReadTimeout.Seconds() < 1 && ly.ReadTimeout > 0) || ly.ReadTimeout < 0 {
		return time.Second
	} else {
		return ly.ReadTimeout
	}
}

func (ly ListenYaml) GetWriteTimeout() time.Duration {
	if (ly.WriteTimeout.Seconds() < 1 && ly.WriteTimeout > 0) || ly.WriteTimeout < 0 {
		return time.Second
	} else {
		return ly.WriteTimeout
	}
}

func (ly ListenYaml) GetReadLimit() uint32 {
	if ly.ReadLimit < 1024 {
		return 1024
	}
	return ly.ReadLimit
}
