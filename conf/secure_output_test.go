package conf

import (
	"github.com/stretchr/testify/assert"
	"math/rand/v2"
	"net"
	"os"
	"path/filepath"
	"slices"
	"sync"
	"testing"
	"time"
)

func TestSecureOutputInvalid(t *testing.T) {
	modes := []string{"", "invaLid"}
	for _, mode := range modes {
		t.Run(mode, func(t *testing.T) {
			t.Parallel()
			eChan, _ := OutputData(mode, "", nil)
			err := <-eChan
			assert.ErrorIs(t, err, ErrNoSaveMode)
		})
	}
}

func TestSecureOutputUnix(t *testing.T) {
	tDir := t.TempDir()
	sPath := filepath.Join(tDir, "output.sock")
	tb := make([]byte, 16384)
	_, _ = rand.NewChaCha8([32]byte{}).Read(tb)
	eChan, cancel := OutputData("uNix", sPath, tb)
	wg := &sync.WaitGroup{}
	wg.Add(2)
	go func() {
		err := <-eChan
		assert.NoError(t, err)
		wg.Done()
	}()
	go func() {
		<-time.After(time.Second * 4)
		cancel()
		wg.Done()
	}()
	time.Sleep(time.Second * 2)
	fi, err := os.Stat(sPath)
	assert.NoError(t, err)
	t.Log(fi.Mode().Perm().String())
	assert.Equal(t, 0700, int(fi.Mode().Perm()))
	c, err := net.Dial("unix", sPath)
	assert.NoError(t, err)
	defer func() { _ = c.Close() }()
	var bts []byte
	buff := make([]byte, 8192)
	var n int
	n, err = c.Read(buff)
	bts = append(bts, buff[:n]...)
	for err == nil && n > 0 {
		n, err = c.Read(buff)
		bts = append(bts, buff[:n]...)
	}
	wg.Wait()
	assert.True(t, slices.Equal(tb, bts))
}

func TestSecureOutputFile(t *testing.T) {
	tDir := t.TempDir()
	sPath := filepath.Join(tDir, "output.safe")
	tb := make([]byte, 16384)
	_, _ = rand.NewChaCha8([32]byte{}).Read(tb)
	eChan, _ := OutputData("fiLe", sPath, tb)
	wg := &sync.WaitGroup{}
	wg.Add(1)
	go func() {
		err := <-eChan
		assert.NoError(t, err)
		wg.Done()
	}()
	time.Sleep(time.Second * 2)
	fi, err := os.Stat(sPath)
	assert.NoError(t, err)
	t.Log(fi.Mode().Perm().String())
	assert.Equal(t, 0600, int(fi.Mode().Perm()))
	rbts, err := os.ReadFile(sPath)
	assert.NoError(t, err)
	wg.Wait()
	assert.True(t, slices.Equal(tb, rbts))
}
