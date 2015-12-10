# [:] Security Headers

## Description

Security related HTTP headers can be used to prevent cetrain kinds of web based attacks and provide an easy way for web developers to increase the security of their application. This project is a discourse plugin for our [community site](https://open.srcclr.com) that can scan and grade security related HTTP headers set on a website. Our goal is to raise awareness on the lack of usage of security headers and provide developers an easy way to check the headers set on their own site.

We currently support and scan for the following headers:
- HTTP Strict Transport Security (HSTS)
- Cross-Site Scripting (XSS) Protection
- Set Framing Policy
- HTTP Public Key Pinning (HPKP)
- Cross Domain Configuration
- MIME Type Security
- Force Save Downloads
- Content Security Policy

In addtion, we have also analyzed and graded Alexa top 1 million sites. You can browse the entire dataset online based on different categories. We also support basic filtering and slicing of data.

## Scripts

* `bin/import_categories` - loads categories xml file from dmoz, parses it and saves to database
* `bin/import_domains` - loads Top Million Domain list from Alexa, refreshes the info (country, category) for each domain from Alexa, collects parent categories for each domain. Please note: you can limit the amount of saved domains by inputting the desired value in Admin -> Setting -> scan_domain_count. The default value is 10,000 domains.
* `bin/scan_domains` - scans each domain for security vulnerabilities
* `bin/run_all_tasks` - runs all above tasks in the aforementioned order
