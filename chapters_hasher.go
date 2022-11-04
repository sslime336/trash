package main

import (
	"bytes"
	"crypto/sha256"
	"fmt"
	"io"
	"io/fs"
	"log"
	"os"
)

func main() {
	HashChapters()
	Flush()
	fmt.Println("changed?", IsChanged)
}

func HashChapters() {
	curPath, err := os.Getwd()
	if err != nil {
		log.Fatal(err)
	}
	for _, chapter := range chapters {
		hashChapter(curPath, chapter)
	}
}

var chapters = []string{
	"authority",
	"common-params",
	"configuration",
	"custom-server",
	"database-sql",
	"dependency-inject",
	"middlewire",
	"project-layer",
	"template-mvc",
	"warming-up",
}

var (
	buffer    bytes.Buffer
	IsChanged bool
)

func Flush() {
	sf0, err := os.Open("chapters.lock")
	if err != nil {
		log.Println(err)
	} else {
		b, _ := io.ReadAll(sf0)
		if string(b) == buffer.String() {
			IsChanged = false
			return
		}
	}
	sf, err := os.OpenFile("chapters.lock", os.O_CREATE|os.O_WRONLY, 0755)
	if err != nil {
		log.Fatal(err)
	}
	sf.Write(buffer.Bytes())
	IsChanged = true
}

func hashChapter(curPath, targetChapter string) {
	f := os.DirFS(curPath)
	fs.WalkDir(f, targetChapter,
		func(path string, d fs.DirEntry, err error) error {
			if err != nil {
				log.Fatal(err)
			}
			if !d.IsDir() {
				f, err := os.OpenFile(path, os.O_RDONLY, 0755)
				if err != nil {
					log.Fatal(err)
				}
				b, err := io.ReadAll(f)
				if err != nil {
					log.Fatal(err)
				}
				sumedB := sha256.Sum256(b)
				buf := make([]byte, len(sumedB))
				copy(buf, sumedB[:])
				buffer.Write(buf)
			}
			return nil
		},
	)
}
