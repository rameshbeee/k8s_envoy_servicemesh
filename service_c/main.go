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

        fmt.Fprintf(w, "Hello from service C %s\n", name)

}

func main() {
	http.HandleFunc("/service_c", handler)
	log.Fatal(http.ListenAndServe(":8080", nil))
}
