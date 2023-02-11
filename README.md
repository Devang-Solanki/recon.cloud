<p align="center">
  <a href="https://recon.cloud/"><img src="https://user-images.githubusercontent.com/75718583/202103206-e9805a17-0cf1-4f86-9983-b1a7b4aaf725.svg" alt="recon.cloud"></a>
  <br>
</p>
<p align="center">
<a href="https://unlicense.org/"><img src="https://img.shields.io/badge/license-Unlicense-_red.svg"></a>
<a href="https://goreportcard.com/badge/Devang-Solanki/recon.cloud"><img src="https://goreportcard.com/badge/github.com/Devang-Solanki/recon.cloud"></a>
<a href="https://go.dev/blog/go1.19"><img src="https://img.shields.io/github/go-mod/go-version/Devang-Solanki/recon.cloud"></a>
<a href="https://twitter.com/devangsolankii"><img src="https://img.shields.io/twitter/follow/devangsolankii.svg?logo=twitter"></a>
</p>
<p align="center">
  <a href="#-installation">Installation</a> •
  <a href="#-usage">Usage</a> •
  <a href="#-todo">Todo</a> •
  <a href="#-how-to-contribute">Contribute</a> 
</p>

<p align="center">
<a href="https://recon.cloud/">recon.cloud</a> is website that scans AWS, Azure and GCP public cloud footprint this GO tool only utilize its API for getting result to terminal.
</p>
<br>
<p align="center"> ⚠️ NOTE: This tool will not work anymore because of cloudflare bot protection. Wait for some months till <a href="https://recon.cloud/">recon.cloud</a> develope a proper API for us to use.</p>

<h1 align="center">
  <img src="https://user-images.githubusercontent.com/75718583/201933058-08dec67d-ebe6-4e80-9267-35347771cb60.png" alt="subfinder" width="700px"></a>
  <br>
</h1>

## ⚙ Installation
recon.cloud requires go1.19 to install successfully. Run the following command to get the repo -
```
go install github.com/Devang-Solanki/recon.cloud@latest
```
or you can download the pre-built binary from [releases page](https://github.com/Devang-Solanki/recon.cloud/releases/tag/v1.0)

## 📔 Usage
#### `recon.cloud -h` will print help menu
```bash
❯ recon.cloud -h
Usage of ./recon.cloud:
  -d string
        Only Domain
  -l string
        List of file containing Domains
  -o string
        Path of output file (default "none")
  -only-ip
        Get IPs instead of Domains
```
#### You can pass single domain with flag -d
```bash
❯ recon.cloud -d wikipedia.com
wikipediademo.userlane.com.s3.amazonaws.com
wikipedia.s3.amazonaws.com
wikipedia-links.s3.amazonaws.com
wikipedia-test-data.s3.amazonaws.com
wikipedia.austinshaf.org.s3-website-us-east-1.amazonaws.com
```
#### You can also pass domain via stdin
```bash
❯ echo "hackerone.com" | recon.cloud 
resources.hackerone.com
test-hackerone-vpn-service.s3.amazonaws.com
git.hackerone-us-west-2-production-attachments.s3.amazonaws.com
hackerone-vpn-service.s3.amazonaws.com
gslink.hackerone.com

❯ cat targets.txt | recon.cloud
```
#### With -only-ip you can get IP
```bash
❯ echo "hackerone.com" | recon.cloud -only-ip
3.98.63.202
52.60.160.16
52.60.165.183
52.218.209.82
52.92.181.81
52.218.235.67
52.92.128.209
52.92.209.49
52.84.125.62
52.84.125.13
52.84.125.129
52.84.125.74
```

#### With -l flag you can pass a list of files containing domains
```
recon.cloud -l targets.txt
```

#### With -o flag you can save output to a file
```
recon.cloud -d hackerone.com -o result.txt
```

## 🤝🏻 How to contribute:
If you want to contribute to this project then:
- Submitting an issue because you have found a bug or you have any suggestion or request.

## 💡 TODO
☑️ Implemented everything in GO.
- Using multiple threads for better speed
- Option for output in different format eg: JSON, CSV etc
- Option for filtering based on resources like s3, ec2 etc

<a href="https://www.buymeacoffee.com/devangsolankii" target="_blank"><img src="https://cdn.buymeacoffee.com/buttons/default-orange.png" alt="Buy Me A Coffee" height="41" width="174" /></a>
