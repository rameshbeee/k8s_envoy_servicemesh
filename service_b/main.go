package main

import (
	"fmt"
	"log"
        "os"
	"net/http"
)

func handler(w http.ResponseWriter, r *http.Request) {
	name, err := os.Hostname()
	if err != nil {
		panic(err)
	}

	fmt.Fprintf(w, "Hello from service B %s\n", name)
}

func main() {
	http.HandleFunc("/service_b", handler)
	log.Fatal(http.ListenAndServe(":8082", nil))
}
