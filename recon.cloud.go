package main

import (
	"bufio"
	"encoding/json"
	"flag"
	"fmt"
	"io/ioutil"
	"log"
	"net/http"
	"os"
	"time"
)

type JsonStatusRes struct{
    Msg_type string `json:"msg_type"`
    Step string `json:"step"`
    Total_subdomains int `json:"total_subdomains"`
    Request_id string `json:"request_id"`
}

type JsonInitRes struct {
    MsgType string `json:"msg_type"`
	RequestID string `json:"request_id"`
	OnCache bool   `json:"on_cache"`
	Step string `json:"step"`
	CloudAssetsList []struct {
        Key string `json:"key"`
		Domain string `json:"domain"`
		Ip []map[string]string `json:"ip"`
		Cname string `json:"cname"`
		Service string `json:"service"`
		Region string `json:"region"`
		CloudProvider string `json:"cloud_provider"`
		Enrich struct {
            Ports interface{} `json:"ports"`
			Cves interface{} `json:"cves"`
			Tags interface{} `json:"tags"`
			StorageAccess interface{} `json:"storage_access"`
		} `json:"enrich"`
	} `json:"cloud_assets_list"`
	TotalSubdomains int `json:"total_subdomains"`
	ScanTime string `json:"scan_time"`
}

func readFile(file string) []string{
    var domains []string
    f, err := os.Open(file)
    logError(err)

    rd := bufio.NewScanner(f)

    for rd.Scan(){
        if rd.Text() != "" {
         domains = append(domains, rd.Text())
        }
    }
    return domains
}

func outPut(content []string, name string){

    if name != "none" {
        file, err := os.OpenFile(name, os.O_APPEND|os.O_CREATE|os.O_WRONLY, 0644)
        logError(err)
        defer file.Close()

        w := bufio.NewWriter(file)
        for _, line := range content {
            fmt.Fprintln(w, line)
        }
        w.Flush()
    } else {
        for _, line := range content {
            fmt.Println(line)
        }
    }
}

func logError(err error){
    if err != nil{
        log.Fatal(err)
        os.Exit(1)
    }
}

func reconCloud(domain string, onlyIP bool, outFile string) {
    initReq, err := http.Get("https://recon.cloud/api/search?domain=" + domain)
    logError(err)
    defer initReq.Body.Close()

    var jsonInitRes JsonInitRes

    dataBytes, err := ioutil.ReadAll(initReq.Body)
    logError(err)
    json.Unmarshal(dataBytes, &jsonInitRes)

    if jsonInitRes.Step != "finished"{
        reqID := jsonInitRes.RequestID

        var jsonStatusRes JsonStatusRes
        var step string

        for step != "finished" {
            time.Sleep(2 * time.Second)
            statusReq, err := http.Get("https://recon.cloud/api/get_status?request_id=" + reqID)
            logError(err)
            defer statusReq.Body.Close()

            bytes, err := ioutil.ReadAll(statusReq.Body)
            logError(err)
            json.Unmarshal(bytes, &jsonStatusRes)

            step = jsonStatusRes.Step
        }

        var jsonAnsRes JsonInitRes

        resultReq, err := http.Get("https://recon.cloud/api/get_results?request_id=" + reqID)
        logError(err)
        defer resultReq.Body.Close()

        resultBytes, err := ioutil.ReadAll(resultReq.Body)
        logError(err)
        json.Unmarshal(resultBytes, &jsonAnsRes)

        filterOutput(jsonAnsRes, onlyIP, outFile)
    } else {
        filterOutput(jsonInitRes, onlyIP, outFile)
    }
}

func filterOutput(jsonRes JsonInitRes, onlyIP bool, outFile string){
    var out []string
    if onlyIP {
        for _, value := range jsonRes.CloudAssetsList {
            for _, list := range value.Ip {
                for ip := range list {
                    out = append(out, ip)
                }
            }
        }
    } else {
        for _, value := range jsonRes.CloudAssetsList {
            out = append(out, value.Domain)
        }
    }

    outPut(out, outFile)
}

func main() {

    var domains []string

    domain := flag.String("d", "", "Only Domain")

    var inFile string
    flag.StringVar(&inFile, "l", "", "List of file containing Domains")

    var onlyIP bool
	flag.BoolVar(&onlyIP, "only-ip", false, "Get IPs instead of Domains")

    var outFile string
    flag.StringVar(&outFile,"o", "none", "Path of output file")


    flag.Parse()

    if *domain == "" {
        if inFile == "" {
            sc := bufio.NewScanner(os.Stdin)
            for sc.Scan() {
                if sc.Text() != "" {
                    domains = append(domains, sc.Text())
                    for _, domain := range domains {
                        reconCloud(domain, onlyIP, outFile)
                    }
                }
            }
            if err := sc.Err(); err != nil {
                log.Fatal(err)
            }
        } else {
            domains = readFile(inFile)
            for _, domain := range domains {
                reconCloud(domain, onlyIP, outFile)
            }
        }
    } else {
        reconCloud(*domain, onlyIP, outFile)
    }
}
