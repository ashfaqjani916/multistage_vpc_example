package main

import (
	"fmt"
	"net/http"

	"github.com/gorilla/mux"
)

func main() {
	router := mux.NewRouter()
	router.HandleFunc("/", func(res http.ResponseWriter, req *http.Request) {
		fmt.Println("Welcome to the Coffee HUB")
	})
	router.HandleFunc("/get", getCoffee)
	http.ListenAndServe(":8080", router)
}

func InitDB() {

}

func getCoffee(res http.ResponseWriter, req *http.Request) {

}
