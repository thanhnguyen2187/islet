#let resume(body) = {
  set list(indent: 1em)
  show list: set text(size: 0.92em)
  show link: underline
  show link: set underline(offset: 2pt)

  set page(
    paper: "us-letter",
    margin: (x: 0.5in, y: 0.5in)
  )

  set text(
    size: 10pt,
    font: "New Computer Modern",
  )

  body
}

#let name_header(name) = {
  set text(size: 2.25em)
  [*#name*]
}

#let header(
  name: "Jake Ryan",
  site: "github.com",
  phone: "123-456-7890",
  email: "jake@su.edu",
) = {
  align(
    left,
    block[
      #name_header(name) \
      #link("https://" + site)[#site] |
      #link("mailto:" + email)[#email] |
      #phone
    ]
  )
  v(5pt)
}

#let resume_heading(txt) = {
  show heading: set text(size: 0.92em, weight: "regular")

  pad(
    bottom: 0.2em,
    block[
      = #smallcaps(txt)
      #v(-3pt)
      #line(length: 100%, stroke: 1pt + black)
    ]
  )
}

#let edu_item(
  name: "Sample University", 
  degree: "B.S in Bullshit", 
  location: "Foo, BA", 
  date: "Aug. 1600 - May 1750",
  ..points,
) = {
  set block(above: 0.7em, below: 1em)
  pad(left: 1em, right: 0.5em, box[
    #grid(
      columns: (1fr, 1fr),
      align(left)[
        *#name* \
        _#location _
      ],
      align(right)[
        #degree \
        _#date _
    ])
    #list(..points)
  ])
}

#let exp_item(
  name: "Sample Workplace",
  role: "Worker",
  date: "June 1837 - May 1845",
  location: "Foo, BA",
  ..points,
) = {
    set block(above: 0.7em, below: 1em)
    pad(left: 1em, right: 0.5em, box[
      #pad(box[
        #grid(
          columns: (1fr, 1fr),
          align(left)[
            *#role* \
            _#name _
          ],
          align(right)[
            #date \
            _#location _
          ]
        )
      ])
      #list(
        tight: false,
        ..points,
      )
    ])
}

#let project_item(
  name: "Example Project",
  skills: "Programming Language 1, Database3",
  date: "May 1234 - June 4321",
  ..points
) = {
  set block(above: 0.7em, below: 1em)
  pad(left: 1em, right: 0.5em, box[
    *#name* | _#skills _ #h(1fr) #date
    #list(..points)
  ])
}

#let side_project_items(
  ..points
) = {
  set block(above: 0.7em, below: 1em)
  pad(left: 1em, right: 0.5em, box[#list(..points)])
}

#let side_project_item(
  name: "Example Project",
  content: "Programming Language 1, Database3",
) = {
  set block(above: 0.7em, below: 1em)
  pad(left: 1em, right: 0.5em, box[
    *#name*: #content
  ])
}

#let skill_item(
  category: "Skills",
  skills: "Balling, Yoga, Valorant",
) = {
  set block(above: 0.7em)
  set text(size: 0.91em)
  pad(left: 1em, right: 0.5em, block[*#category*: #skills])
}
