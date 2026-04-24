//go:build windows

package conf

import "github.com/charmbracelet/log"

const newLine = "\r\n"

func umask(target int) (restore func()) {
	log.Warn("Windows does not support umask")
	return func() {}
}

func gperm(nix, win int) int {
	return win
}

func FileProtocol() string {
	return "file:///"
}
