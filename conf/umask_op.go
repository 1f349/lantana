//go:build !windows

package conf

const newLine = "\n"

func umask(target int) (restore func()) {
	omask := syscall.Umask(target)
	return func() { syscall.Umask(omask) }
}

func gperm(nix, win int) int {
	return nix
}
