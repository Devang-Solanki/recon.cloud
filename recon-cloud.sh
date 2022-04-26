#!/bin/bash

#Settings color for pretty output
NC='\033[0m'              # No Color
Red='\033[0;31m'          # Red
Green='\033[0;32m'        # Green
Yellow='\033[0;33m'       # Yellow
Blue='\033[0;34m'         # Blue

Help()
{
   # Display Help
   echo -e "${Yellow}[*] A bash script for scanning AWS public cloud footprint and getting suddomains, service name, cname and region from recon.cloud.${NC}"
   echo
   echo -e "${Green}Syntax: ./subdomain-enum.sh${NC} ${Blue}[-d|h|]${NC}"
   echo -e "${Green}options:${NC}"
   echo -e "${Red}d :${NC}     ${Blue}Takes domain name as input.${NC}"
   echo -e "${Red}h :${NC}     ${Blue}Print this Help.${NC}"
   echo
   echo -e "${Green}example ./subdomain-enum.sh -d example.org${NC}"
}

while getopts "hd:" option; do
   case $option in
      h) # display Help
         Help
         exit;;
      d) # Getting the list of domains
      	 Domain=$OPTARG;;
      \?) # Invalid option
         echo "Error: Invalid option"
         exit;;
   esac
done

# Function for getting the list of domains from recon.cloud #
#############################################################

Recon_cloud()
{
    Domain=$1
    echo -e "${Blue}Requesting subdomain for:${NC} $Domain"
    curl -s "https://recon.cloud/api/search?domain=$Domain" --output "/tmp/ans_$Domain.json"

    Req_id=$(jq -r '.request_id' "/tmp/ans_$Domain.json")
    Len=$(jq '.assets.assets | length' "/tmp/ans_$Domain.json")

    if [[ $Req_id = "None"  ]]
    then
        if [ $Len -gt 0 ]
        then
            jq -r '.assets.assets[] | .domain + " " + .service + " "  + .region + " "  + .cname' "/tmp/ans_$Domain.json" | tee -a recon.cloud.txt
        fi
    else
        while true; do
            curl -s "https://recon.cloud/api/get_status?request_id=$Req_id" --output "/tmp/status_$Domain.json"
            Status=$(jq -r '.status.stage' "/tmp/status_$Domain.json")
            echo -ne "${Blue}Status:${NC} $Status\\r"
            if [ $Status = "finished" ]
            then
            curl -s "https://recon.cloud/api/get_results?request_id=$Req_id" --output "/tmp/result_$Domain.json"
            jq -r '.assets[] | .domain + " " + .service + " "  + .region + " "  + .cname' "/tmp/result_$Domain.json" | tee -a recon.cloud.txt
            break
            fi
            sleep 3
        done
    fi
}

Recon_cloud "$Domain"
