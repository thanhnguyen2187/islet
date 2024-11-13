#import "template.typ": resume, header, resume_heading, edu_item, exp_item, project_item, side_project_item, side_project_items, skill_item

#show: resume

#header(
  name: "Thanh Nguyen",
  phone: "(+84)-392-325-966",
  email: "thanhnguyen2187@gmail.com",
  site: "nguyenhuythanh.com",
)

#resume_heading[Experience]
#exp_item(
  role: "Fullstack Software Engineer",
  // role: "Software Engineer",
  name: "Wombat Exchange",
  location: "Remote, Hongkong SAR",
  date: "7/2023 -- Present",
  [*EVM Data Indexing*: Maintained and deployed subgraphs for 3+ EVM chains,
  which handled 600K+ events. The subgraphs served Wombat Analytics page, which
  made nearly 250K requests per month. Optimized Wombat Analytics page’s loading
  time from 10+ seconds to 1 second.

  Technologies used: TypeScript, AssemblyScript, NextJS, Subgraph.],
  [*EVM Data Analytics*: Implemented 100+ Dune queries and graphs and dashboards,
  which reduced Marketing Team's manual data calculation time by 90%.

  Technologies used: DuneSQL, Dune.],
)
#exp_item(
  role: "Software Engineer, Platform Engineer",
  name: "Xantus Network",
  location: "Hanoi, Vietnam",
  date: "10/2021 -- 12/2022",
  [*EVM Data Indexing*: Designed, implemented, and deployed Events
  Synchronization services for 10+ EVM-compatible Smart Contracts on 3+ chains.
  The services handled 100k+ events, provided on-chain data for 3+ projects
  (Mones, Gunfire Avax, and Oxalus NFT Aggregator). Optimized Block Time
  Querying Service's loading time from 15+ seconds to less than 3 seconds.

  Technologies used: Golang, TypeScript, go-ethereum, web3js, Apache Kafka.],
  // [*GitOps Pipeline*: Implemented and deployed a custom CI/CD workflow for 20+
  // projects which reduced 90% manual deployment time.

  // Technologies used: Google Cloud, Kubernetes, Docker, GitLab CI.]
)
#exp_item(
  role: "Software Engineer",
  // role: "Software Engineer, Data Platform Engineer",
  name: "Teko Vietnam",
  location: "Hanoi, Vietnam",
  date: "4/2021 -- 12/2021",
  [*Master Product Data*: Designed, implemented, and deployed data pipelines, data
  models, and REST API of Product Matching Service which processed 10K+
  products.

  Technologies used: Python, Golang, FastAPI, SQLModel.],
  // [*Real-time Analytics Storage Layer*: Tested, deployed, and operated Apache
  // Druid as the real-time analytics storage layer for 80M+ events.

  // Technologies used: Google Cloud, Kubernetes, Docker, Apache Druid,
  // Apache Kafka, GitLab CI.]
)
#exp_item(
  // role: "Software Engineer",
  role: "Software Engineer, System Engineer",
  // role: "Software Engineer, Research Engineer",
  name: "AI Academy Vietnam",
  location: "Hanoi, Vietnam",
  date: "6/2019 -- 8/2020",
  [*Data Crawling*: Designed, implemented, and deployed Data Crawling Service
  for 50+ news sources.

  Technologies used: Python, Flask, SQLAlchemy, pika, RabbitMQ, APScheduler.],
  [*Time Series Prediction*: Designed, implemented, and deployed configurable
  Prediction Service that can leverage 20+ prediction models.

  Technologies used: Python, pandas, sklearn, statsmodels.],
  // [*Sentiment Analysis*: Researched and implemented a custom rule-based
  // Sentiment Analysis Algorithm that utilizes 3K+ keywords to segment 5K+ text
  // documents.

  // Technologies used: Python, underthesea.],
)

#resume_heading[Education & Certification]
#edu_item(
  name: "Le Quy Don Technical University",
  degree: "Engineer, Software Engineering",
  location: "Hanoi, Vietnam",
  date: "6/2016 -- 6/2021",
  [*GPA*: 3.13],
  [*Specialized Individuals Informatics Olympiad 2017*: Second Prize],
  [*Super Cup Informatics Olympiad 2018*: Third Prize],
)
#resume_heading[Education & Certification]
#edu_item(
  name: "WorldQuant University",
  degree: "Master, Finance Engineering",
  location: "Remote, USA",
  date: "7/2024",
)
// #edu_item(
//   name: "IELTS Issued by British Council",
//   degree: "Academic Module",
//   location: "Tay Ho, Hanoi",
//   date: "2/2023",
//   [*Overall*: 7.5],
//   [*TRF Number*: 22VN027313NGUH002A],
// )

#resume_heading("Side Projects")
#side_project_item(
  name: "Cryptaa",
  content: [
    Offline-first code snippet manager powered by SvelteJS. Deployed at:
    #link(
      "https://thanhnguyen2187.github.io/crypta",
      "thanhnguyen2187.github.io/crypta",
    ).
  ],
)
#side_project_item(
  name: "CamLisp",
  content: [
    Simple Lisp/Scheme interpreter in OCaml. Source at:
    #link(
      "https://github.com/thanhnguyen2187/camlisp",
      "github.com/thanhnguyen2187/camlisp",
    ).
  ],
)
#side_project_item(
  name: "Phoenix",
  content: [
    Declarative machine configuration and dotfiles management with Nix, NixOS,
    and Home Manager. Source at:
    #link(
      "https://github.com/thanhnguyen2187/.phoenix",
      "github.com/thanhnguyen2187/.phoenix",
    ).
  ],
)

