package main

import (
	"fmt"
	"os"

	"gopkg.in/yaml.v2"
)

func main() {
	// read yaml file
	// mainFile := read("./mkdocs.yml")
	tenantFile := read("./tenants/nav/mkdocs.yml") // TODO: generic

	for k, v := range tenantFile {
		fmt.Println(k, v)
	}
}

type yamlFile map[string][]any

func read(path string) yamlFile {
	f, err := os.Open(path)
	if err != nil {
		panic(err)
	}
	defer f.Close()

	file := make(yamlFile)

	decoder := yaml.NewDecoder(f)
	if err := decoder.Decode(&file); err != nil {
		panic(err)
	}

	return file
}
