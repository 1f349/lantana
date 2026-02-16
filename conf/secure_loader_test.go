package conf

import (
	"github.com/stretchr/testify/assert"
	"io"
	"net"
	"os"
	"path/filepath"
	"sync"
	"testing"
	"time"
)

func TestSecureLoadInvalid(t *testing.T) {
	ldr := LoadData("invalid", "dummy")
	assert.Nil(t, ldr)
}

const testData = "tesTing123!!!"

func getTestData() []byte {
	return []byte(testData)
}

func testSelfContained(mode, testData string, compareValue func() []byte, t *testing.T) {
	t.Run(mode, func(t *testing.T) {
		t.Parallel()
		wg := &sync.WaitGroup{}
		wg.Add(1)
		ldr := LoadData(mode, testData)
		assert.NotNil(t, ldr)
		go func() {
			err := ldr.GetError()
			assert.NoError(t, err)
			wg.Done()
		}()
		assert.Equal(t, compareValue(), ldr.GetData())
		wg.Wait()
	})
}

func TestSecureLoadString(t *testing.T) {
	modes := []string{"", "sTr", "strIng"}
	for _, mode := range modes {
		testSelfContained(mode, testData, getTestData, t)
	}
}

func TestSecureLoadEnv(t *testing.T) {
	const envVar = "LOAD_test"
	modes := []string{"enV", "enviroNment"}
	err := os.Setenv(envVar, testData)
	assert.NoError(t, err)
	for _, mode := range modes {
		testSelfContained(mode, envVar, getTestData, t)
	}
}

func writeTestData(c io.WriteCloser) {
	defer func() { _ = c.Close() }()
	_, _ = c.Write(getTestData())
}

func TestSecureLoadUnix(t *testing.T) {
	tDir := t.TempDir()
	sPath := filepath.Join(tDir, "output.sock")
	testSelfContained("unix", sPath, func() []byte {
		time.Sleep(time.Second * 2)
		fi, err := os.Stat(sPath)
		assert.NoError(t, err)
		t.Log(fi.Mode().Perm().String())
		assert.Equal(t, gperm(0700, 0666), int(fi.Mode().Perm()))
		c, err := net.Dial("unix", sPath)
		assert.NoError(t, err)
		writeTestData(c)
		return getTestData()
	}, t)
}

func TestSecureLoadFile(t *testing.T) {
	tDir := t.TempDir()
	sPath := filepath.Join(tDir, "output.safe")
	err := os.WriteFile(sPath, getTestData(), 0600)
	assert.NoError(t, err)
	testSelfContained("fIle", sPath, getTestData, t)
}
