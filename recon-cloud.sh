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
   echo -e "${Yellow}[*] A bash script for scanning AWS, Azure and GCP public cloud footprint and getting suddomains, service name, cname and region from recon.cloud.${NC}"
   echo
   echo -e "${Green}Syntax: ./recon-cloud.sh${NC} ${Blue}[-d|h|]${NC}"
   echo -e "${Green}options:${NC}"
   echo -e "${Red}d :${NC}     ${Blue}Takes domain name as input.${NC}"
   echo -e "${Red}h :${NC}     ${Blue}Print this Help.${NC}"
   echo
   echo -e "${Green}example ./recon-cloud.sh -d example.org${NC}"
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

UserAgent="Mozilla/5.0 (X11; Linux x86_64; rv:104.0) Gecko/20100101 Firefox/104.0"

Recon_cloud()
{
    echo -e "${Blue}Scanning AWS, Azure and GCP public cloud footprint:${NC} $Domain"
    Ans=$(curl -A $UserAgent -s "https://recon.cloud/api/search?domain=$Domain")

    Req_id=$(jq -r '.request_id' <<< $Ans)
    Len=$(jq '.cloud_assets_list | length' <<< $Ans)
    if [ $Len -gt 0 ]
        then
            jq -r '.cloud_assets_list[] | .domain + " " + .service + " "  + .region + " "  + .cname' <<< $Ans | tee -a recon.cloud.txt
            exit
    else
        while true; do
            Req_Status=$(curl -A $UserAgent -s "https://recon.cloud/api/get_status?request_id=$Req_id")
            Status=$(jq -r '.step' <<< $Req_Status)
            echo -ne "${Blue}Status:${NC} $Status\\r"
            if [ $Status = "finished" ]
            then
            Result=$(curl -A $UserAgent -s "https://recon.cloud/api/get_results?request_id=$Req_id")
            jq -r '.cloud_assets_list[] | .domain + " " + .service + " "  + .region + " "  + .cname' <<< $Result | tee -a recon.cloud.txt
            break
            fi
            sleep 3
        done
    fi
}

Recon_cloud "$Domain"
