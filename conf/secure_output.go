package conf

import (
	"errors"
	"net"
	"os"
	"syscall"
)

var ErrNoSaveMode = errors.New("no save mode")

func OutputData(saveMode, saveString string, saveData []byte) (errChan <-chan error, cancel func()) {
	eChan := make(chan error, 1)
	switch saveMode {
	case "unix":
		canChan := make(chan struct{})
		cmsmg := make(chan struct{})
		cancel = func() {
			close(canChan)
		}
		go func() {
			defer close(eChan)
			defer close(cmsmg)
			omask := syscall.Umask(0077)
			defer syscall.Umask(omask)
			l, err := net.ListenUnix("unix", &net.UnixAddr{
				Name: saveString,
				Net:  "unix",
			})
			if err != nil {
				eChan <- err
			} else {
				go func() {
					select {
					case <-cmsmg:
					case <-canChan:
					}
					_ = l.Close()
				}()
				c, err := l.Accept()
				if err != nil {
					eChan <- err
				} else {
					go func() {
						select {
						case <-cmsmg:
						case <-canChan:
						}
						_ = c.Close()
					}()
					_, _ = c.Write(saveData)
				}
			}
		}()
		return eChan, cancel
	case "file":
		go func() {
			defer close(eChan)
			eChan <- os.WriteFile(saveString, saveData, 0600)
		}()
	default:
		go func() {
			defer close(eChan)
			eChan <- ErrNoSaveMode
		}()
	}
	return eChan, func() {}
}
