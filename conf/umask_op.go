//go:build !windows

package conf

import "syscall"

const newLine = "\n"

func umask(target int) (restore func()) {
	omask := syscall.Umask(target)
	return func() { syscall.Umask(omask) }
}

func gperm(nix, win int) int {
	return nix
}

func FileProtocol() string {
	return "file://"
}
