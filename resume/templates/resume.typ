#let ink = rgb("#111827")
#let muted = rgb("#667085")
#let rule = rgb("#d0d5dd")

#set page(
  width: 8.5in,
  height: 11in,
  margin: (x: 0.55in, y: 0.28in),
)

#set text(
  font: ("Helvetica Neue", "Arial"),
  size: 10pt,
  fill: ink,
)

#set par(
  justify: false,
  leading: 0em,
  spacing: 0.3em,
)

#set heading(numbering: none)
#set list(
  tight: true,
  marker: [•],
  body-indent: 0.55em,
  spacing: 0.12em,
)
// Typst's block() default above/below (~1.2em each) silently stacks between
// every summary paragraph and every skills line, which reads as much bigger
// gaps than the section-spacing values below suggest. Pin it small instead.
#set block(above: 0.2em, below: 0.2em)

#let section_heading(title) = [
  #v(0.4em)
  #align(center)[
    #text(size: 8.2pt, weight: 700, tracking: 0.08em, fill: muted)[#title]
    #v(0.08em)
    #line(length: 100%, stroke: 0.7pt + rule)
  ]
  #v(0.12em)
]

#let resume_header(name, headline, contact) = [
  #align(center)[
    #text(size: 17pt, weight: 700, tracking: 0.01em)[#name]
    #if headline != "" [
      #v(0.06em)
      #text(size: 10.2pt, fill: muted)[#headline]
    ]
    #if contact != "" [
      #v(0.1em)
      #text(size: 9pt, fill: muted)[#contact]
    ]
  ]
]

#let summary_block(paragraphs) = {
  for paragraph in paragraphs {
    block(width: 100%)[
      #paragraph
    ]
  }
}

#let entry_block(item) = [
  #table(
    columns: (1fr, auto),
    stroke: none,
    inset: 0pt,
    column-gutter: 12pt,
    [#text(weight: 650)[#item.title]],
    [#text(size: 9pt, weight: 600, fill: muted)[#item.dates]],
  )
  #if item.meta != "" [
    #text(size: 9.1pt, style: "italic", fill: muted)[#item.meta]
  ]
  #if item.bullets.len() > 0 [
    #v(0.1em)
    #list(..item.bullets.map(bullet => [#bullet]))
  ]
  #v(0.18em)
]

#let skills_block(items) = {
  for item in items {
    block(width: 100%)[
      #text(weight: 650, item.label + ":") #h(0.3em) #item.items
    ]
  }
}

#let render_resume(
  name,
  headline,
  contact,
  summary,
  experience,
  projects,
  skills,
  education,
  pagebreak_before_projects: false,
) = [
  #resume_header(name, headline, contact)

  #if summary.len() > 0 [
    #section_heading("SUMMARY")
    #summary_block(summary)
  ]

  #if experience.len() > 0 [
    #section_heading("EXPERIENCE")
    #for item in experience {
      entry_block(item)
    }
  ]

  #if projects.len() > 0 [
    #if pagebreak_before_projects [
      #pagebreak()
    ]
    #section_heading("PROJECTS")
    #for item in projects {
      entry_block(item)
    }
  ]

  #if skills.len() > 0 [
    #section_heading("SKILLS")
    #skills_block(skills)
  ]

  #if education.len() > 0 [
    #section_heading("EDUCATION")
    #for item in education {
      entry_block(item)
    }
  ]
]
