---
title: "A Mildy Interesting Technical Challenge"
date: 2022-06-14T20:54:07+07:00
draft: false
toc: true
images:
categories:
tags:
---

I think I got asked the question twice or thrice in my interviews, and could not
come up with a good enough answer. Recently, I found one such mildly interesting
technical challenge, and wanted to jot it down before it faints from my mind.

## Context

As you may have (or may have not) known it, I joined a "typical" blockchain
startup with a "typical" backend job there: EVM-compatible data synchronization;
NFT-related stuff, of course. To be more specific, I needed to create a "cache"
layer for a NFT Marketplace Service that answers these questions:

- Given a wallet address, find the NFTs that the wallet address possesses
- Given a few "game-specified" attributes (name, star, etc.) of the NFTs, find
  the satisfied ones with pagination
- Make sure that this "cache" layer is "eventually consistent" with the on-chain
  data

## More Details

The "data flow" is also a "typical" one:

```
[Blockchain] --(1)--> [Event Queue] --(2)--> [Data Storage]
```

The "processing" within the data flow is also quite "normal":

```
(1): A service named "Mediator", which periodically fetches events from
blockchain, does simple processing, and saves the data to an event queue (Kafka)

(2): Four services, sequentially are "Enricher", "Metadata", "Master Data", and
"Marketplace", interact with each other to make sure that in the end, there is
ready-for-serve data within "Data Storage" (Elasticsearch in this case)

[Event Queue] --(1)--> [Enricher] <--(2)-- [Master Data]
                          |   ^
                          |   |
                         (4) (3)--- [Metadata]
                          |
                          |
                          v
                    [Marketplace] --(5)--> [Data Storage]

```

For everything except Data Storage, there is not a lot to say:

- Event Queue: store events, nothing new
- Enricher: on new events, does the hard work of
  - Fetching data from Master Data (what is the blockchain, what is the smart
    contract's name etc.),
  - Also fetches data from Metadata (what are the game-specific data of that
    NFT)
  - Consolidate the data
  - Send the data to Marketplace
- Marketplace: receive data from Enricher, save to Data Storage

What is stored within Data Storage also matters. To be simple, however, we just
need to know that it stores... NFTs' data, which includes these two fields:

- Current Owner (a wallet address, "0x00...")
- Current State ("available" or "being listed")

A few events are handled, again, to be simple, we need to pay our attention to
these three events:

- `Transfer`, which changes the owner of an NFT
- `Listing`, which changes the NFT's state from "available" to "being listed"
- `CancelListing`, which changes the NFT's state from "being listed" to
  "available"

There is also two rules:

- If an NFT is "being listed", it means a specific wallet address of the system
  (let us name it "0x00_market") must be the owner
- If an NFT is "available", it means the ownership is back to the user
  (something not "0x00_market")

```json
// valid
{
    "owner": "0x00_market",
    "state": "being listed"
}

// valid
{
    "owner": "0x00_user",
    "state": "available"
}

// invalid
{
    "owner": "0x00_user",
    "state": "being listed"
}

// invalid
{
    "owner": "0x00_market",
    "state": "available"
}
```

## Things Went Well, Until They Do Not

Everything went well for a while, until there is more data. 99.9% of the data is
handled correctly and has the correct state, while incorrect ones sometimes show
up, and I could do nothing but change them manually. I got fed up, and tried
investigating.

Reading the code was my first thought. It did not gave me anything insightful.
This pseudocode should give you a rough idea what was written then:

```python
def handle_event(data):
    fetch_item(data['id']) # fetch from database
    mutate(data)           # mutate that data in-memory
    save_item(data)        # save the mutated data to database
```

I spent a while thinking about where could it go wrong, and (luckily) came to
the right conclusion: the invalid state happens when two events are handled at
once (a `Transfer` and a `Listing` come at the same time).

The next thing to do was to set the environment up. Let me remind you of the
services:

- Mediator
- Event Queue (Kafka and AKHQ to look at data within Kafka)
- Master Data
- Metadata
- Enricher
- Marketplace
- Data Storage (Elasticsearch)

The next thing I did was simulating the request, which is faking a few
"valid" events and push them into Event Queue. Doing it manually with AKHQ got
out of my thinking immediately. `kcat` (or `kafkacat`), is the next choice.

```bash
kcat -P -b 127.0.0.1:9200 -t nft.events /tmp/transfer.json
kcat -P -b 127.0.0.1:9200 -t nft.events /tmp/listing.json
```

I got stuck for a while as I could not reproduce the error. I thought of
something more "barebone":

```bash
curl -X POST -d '@/tmp/transfer_request.json' 127.0.0.1:9000/handle-transfer
curl -X POST -d '@/tmp/listing_request.json' 127.0.0.1:9000/handle-listing
```

I got frustrated for a while, until I realize I was using `vim-slime` to send
those command to another `tmux` pane. The way my shell (`zsh`) handles those
commands was:

```
- execute the first command
- wait until it is done
- execute the second command
- wait until it is done
```

A bit of modification to the commands and the way I handle it (instead of using
`vim-slime`, copy the two commands and paste it into the shell at once) did
reproduce the error:

```
curl -X POST -d '@/tmp/transfer_request.json' 127.0.0.1:9000/handle-transfer &
curl -X POST -d '@/tmp/listing_request.json' 127.0.0.1:9000/handle-listing &
```

## Back To The... Fundamentals

I think people was having a faint idea of what went wrong, reading the
pseudocode, but I will try to make it clearer here. The sequence of events that
we needed are:

```
1. Handle Transfer Event
1.1. Fetch Data
1.2. Mutate Data
1.3. Save Data

2. Handle Listing Event
2.1. Fetch Data
2.2. Mutate Data
2.3. Save Data
```

But in reality, when those two comes at once, the sequence's order can be messed
up:

```
1.1. Fetch Data
2.1. Fetch Data
1.2. Mutate Data
1.3. Save Data
2.2. Mutate Data
2.3. Save Data
```

Then of course, the final version within our Data Store becomes incorrect. A
natural solution that came was using a mutex and lock the data mutation.

You have guessed it. The lock does not work, either.

## The Simplest Solution

Looking at the data and state again, I had another insight: `Transfer` mutates
the ownership, while `Listing` mutates the current state, which are two
different fields of a record.

```json
{
    "owner": "0x00_market", // `Transfer` mutates this
    "state": "being listed" // `Listing` mutates this
}
```

A simple fix is just:

```python
def handle_event(data):
    fetch_item(data['id'])   # fetch from database
    mutate(data)             # mutate that data in-memory
    fields_to_update = [...] # set the fields to be partially updated
    update_partial(          # partially update the data
        data,
        fields_to_update,
    )
```

## Conclusion

Congratulate on slugging through my explanation of this mildly interesting
technical challenge. I hope that it gave you some useful insights, and also hope
that I can tell the story coherently to my next interviewers.

