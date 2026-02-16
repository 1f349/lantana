package conf

import (
	"net"
	"os"
	"strings"
	"sync"
)

type SecureLoader struct {
	s         *sync.Mutex
	dataChan  chan []byte
	errorChan chan error
	data      []byte
	err       error
	cancel    func()
}

func (s *SecureLoader) GetData() []byte {
	if s.data == nil {
		s.s.Lock()
		defer s.s.Unlock()
		s.data = <-s.dataChan
	}
	return s.data
}

func (s *SecureLoader) GetError() error {
	if s.err == nil {
		s.s.Lock()
		defer s.s.Unlock()
		s.err = <-s.errorChan
	}
	return s.err
}

func (s *SecureLoader) Cancel() {
	s.cancel()
}

func LoadData(loadMode, loadString string) *SecureLoader {
	loadMode = strings.ToLower(loadMode)
	dChan := make(chan []byte, 1)
	eChan := make(chan error, 1)
	cancel := emptyFunc
	switch loadMode {
	case "unix":
		canChan := make(chan struct{})
		cmsmg := make(chan struct{})
		cancel = func() {
			close(canChan)
		}
		go func() {
			defer close(dChan)
			defer close(eChan)
			defer close(cmsmg)
			urestore := umask(0077)
			defer urestore()
			l, err := net.ListenUnix("unix", &net.UnixAddr{
				Name: loadString,
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
					var bts []byte
					buff := make([]byte, 8192)
					var n int
					n, err = c.Read(buff)
					bts = append(bts, buff[:n]...)
					for err == nil && n > 0 {
						n, err = c.Read(buff)
						bts = append(bts, buff[:n]...)
					}
					dChan <- bts
				}
			}
		}()
	case "env", "environment":
		go func() {
			defer close(dChan)
			defer close(eChan)
			dChan <- []byte(os.Getenv(loadString))
		}()
	case "file":
		go func() {
			defer close(dChan)
			defer close(eChan)
			bts, err := os.ReadFile(loadString)
			if err != nil {
				eChan <- err
			} else {
				dChan <- bts
			}
		}()
	case "str", "string", "":
		go func() {
			defer close(dChan)
			defer close(eChan)
			dChan <- []byte(loadString)
		}()
	default:
		return nil
	}
	return &SecureLoader{
		s:         &sync.Mutex{},
		dataChan:  dChan,
		errorChan: eChan,
		cancel:    cancel,
	}
}
