holbertonschool.com — Passive Recon Notes

Date: Aug 21, 2025
Source: Shodan web search (hostname:holbertonschool.com)

Approach

Searched for all hosts on Shodan that matched the main domain and subdomains. For each host, I copied the IP, location, certificate info, and visible HTTP headers. Grouped the addresses roughly by /24 just to show ranges.

Subdomains and IPs found

apply.holbertonschool.com

15.188.230.158 (Amazon, Paris)

51.44.231.239 (Amazon, Paris)

13.37.181.187 (Amazon, Paris)

13.36.159.193 (Amazon, Paris)

15.188.218.54 (Amazon, Paris)

read.holbertonschool.com

15.188.124.24 (Amazon, Paris)

15.236.251.91 (Amazon, Paris)

staging-apply.holbertonschool.com

13.38.221.164 (Amazon, Paris)

13.37.67.17 (Amazon, Paris)

35.181.42.84 (Amazon, Paris)

yriyr2.holbertonschool.com

52.47.143.83 (Amazon, Paris)

All results point to AWS infrastructure in the eu-west-3 region (Paris).

Observed IP ranges

(not exact provider ranges, just grouped from Shodan results)

15.188.230.0/24

15.188.124.0/24

15.188.218.0/24

15.236.251.0/24

13.37.181.0/24

13.37.67.0/24

13.36.159.0/24

13.38.221.0/24

35.181.42.0/24

51.44.231.0/24

52.47.143.0/24

Technologies and headers

Web server
nginx/1.20.0 on all observed hosts

TLS and certificates

TLSv1.2 supported everywhere, some hosts also allow TLSv1.3

Cert issuers: Amazon RSA 2048 (M02/M03/M04 variants), Let’s Encrypt

Common security headers

X-Frame-Options: SAMEORIGIN

X-XSS-Protection: 1; mode=block (sometimes 0)

X-Content-Type-Options: nosniff

X-Download-Options: noopen

Status codes

200 OK (apply.* hosts)

401 Unauthorized (read.* and staging-apply.* hosts)

Notes

Infrastructure is fully on AWS eu-west-3 (Paris).

nginx 1.20.0 is a bit old, should ideally be upgraded.

TLS is fine but TLSv1.3 should be enabled everywhere for consistency.

Security headers look standard and consistent.
