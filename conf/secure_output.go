package conf

import (
	"bytes"
	"errors"
	"io"
	"net"
	"os"
	"strings"
)

var emptyFunc = func() {}
var ErrNoSaveMode = errors.New("no save mode")
var StdOut io.Writer = os.Stdout

func OutputData(saveMode, saveString string, saveData []byte) (errChan <-chan error, cancel func()) {
	saveMode = strings.ToLower(saveMode)
	eChan := make(chan error, 1)
	switch saveMode {
	case "stdout":
		go func() {
			defer close(eChan)
			if StdOut == nil {
				eChan <- io.ErrUnexpectedEOF
			} else {
				toWrite := new(bytes.Buffer)
				toWrite.Write([]byte(saveString + ": "))
				toWrite.Write(saveData)
				toWrite.Write([]byte(newLine))
				_, err := StdOut.Write(toWrite.Bytes())
				eChan <- err
			}
		}()
	case "unix":
		canChan := make(chan struct{})
		cmsmg := make(chan struct{})
		cancel = func() {
			close(canChan)
		}
		go func() {
			defer close(eChan)
			defer close(cmsmg)
			urestore := umask(0077)
			defer urestore()
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
	return eChan, emptyFunc
}
