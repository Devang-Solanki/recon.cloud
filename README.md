# recon.cloud-cli
A bash script for scanning AWS, Azure and GCP public cloud footprint and getting suddomains, service name, cname and region from [recon.cloud](https://recon.cloud/) 

## ⚙ Installation
```bash
git clone https://github.com/Devang-Solanki/recon.cloud-cli
cd /recon.cloud-cli
chmod +x recon-cloud.sh
```
## 📃 Requirements
### jq
- For Debian and Ubuntu - Install using `sudo apt-get install jq`
- For Fedora - Install using `sudo dnf install jq`.
- For openSUSE - Install using `sudo zypper install jq`.
- For Arch - Install using `sudo pacman -S jq`.


## 📔 Usage
```
❯ ./recon-cloud.sh -h
[*] A bash script for scanning AWS, Azure and GCP public cloud footprint and getting suddomains, service name, cname and region from recon.cloud.

Syntax: ./recon-cloud.sh [-d|h|]
options:
d :     Takes domain name as input.
h :     Print this Help.

example ./recon-cloud.sh -d example.org 

This comand print output on terminal and also save it in recon.cloud.txt
```
```bash
❯ ./recon-cloud.sh -d wikipedia.com
Requesting subdomain for: wikipedia.com
wikipediademo.userlane.com.s3.amazonaws.com s3 eu-central-1 s3-w.eu-central-1.amazonaws.com.
wikipedia.s3.amazonaws.com s3 us-east-2 s3-w.us-east-2.amazonaws.com.
wikipedia-links.s3.amazonaws.com s3 us-west-1 s3-us-west-1-w.amazonaws.com.
wikipedia.austinshaf.org.s3-website-us-east-1.amazonaws.com s3 us-east-1 s3-website.us-east-1.amazonaws.com.
```
## 🤝🏻 How to contribute:
If you want to contribute to this project then:
- Submitting an issue because you have found a bug or you have any suggestion or request.

## 💡 TODO
- Implementing everything in GO.
- Option for output in different format eg: JSON, CSV etc
- Option for output in different location
