#let ink = rgb("#111827")
#let muted = rgb("#667085")
#let rule = rgb("#d0d5dd")

// This must be applied via `#show: page_style` in the document that calls
// render_resume, NOT just imported and left at module top level. A plain
// `#import ... : render_resume` followed by `#render_resume(...)` only
// splices render_resume's *returned content* into the caller's flow — the
// `#set page(...)` rule below never actually reaches the caller's page,
// and Typst silently falls back to its A4 default (595 x 842pt) instead of
// the 8.5x11in Letter page configured here. This was verified by comparing
// `pdfinfo` output against the source, not just visual inspection: every
// resume built before this fix was rendered on A4, which is both narrower
// and taller than Letter and threw off every page-fit judgment made against
// it. Wrapping the setup in a function used as a show rule is the standard
// Typst idiom for a template controlling page setup.
#let page_style(body) = {
  set page(
    width: 8.5in,
    height: 11in,
    margin: (x: 0.75in, y: 0.65in),
  )
  set text(
    font: ("Helvetica Neue", "Arial"),
    size: 10.5pt,
    fill: ink,
  )
  set par(
    justify: false,
    leading: 0.3em,
    spacing: 0.55em,
  )
  set heading(numbering: none)
  set list(
    tight: true,
    marker: [•],
    body-indent: 0.55em,
    spacing: 0.3em,
  )
  // Typst's block() default above/below (~1.2em each) silently stacks
  // between every summary paragraph and every skills line, which reads as
  // much bigger gaps than the section-spacing values below suggest. Pin it
  // to something comfortable instead.
  set block(above: 0.5em, below: 0.5em)
  body
}

#let section_heading(title) = [
  #v(0.9em)
  #align(center)[
    #text(size: 8.6pt, weight: 700, tracking: 0.08em, fill: muted)[#title]
    #v(0.15em)
    #line(length: 100%, stroke: 0.7pt + rule)
  ]
  #v(0.3em)
]

#let resume_header(name, headline, contact) = [
  #align(center)[
    #text(size: 22pt, weight: 700, tracking: 0.01em)[#name]
    #if headline != "" [
      #v(0.15em)
      #text(size: 11pt, fill: muted)[#headline]
    ]
    #if contact != "" [
      #v(0.2em)
      #text(size: 9.5pt, fill: muted)[#contact]
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
  // table()/grid() here are atomic/unbreakable and their page-fit estimate
  // was verified (via rendered screenshots + pdfinfo, not just text
  // extraction) to be overly conservative: the whole entry would jump to
  // the next page even with over half an inch of visible room left on the
  // current one. Plain flowing text with a 1fr spacer lays out the same
  // title/date line without that quirk; #linebreak() keeps the meta line
  // (and bullets) from running onto the same line as the title/date.
  #text(weight: 650)[#item.title] #h(1fr) #text(size: 9pt, weight: 600, fill: muted)[#item.dates]
  #linebreak()
  #if item.meta != "" [
    #text(size: 9.1pt, style: "italic", fill: muted)[#item.meta]
  ]
  #if item.bullets.len() > 0 [
    #v(0.2em)
    #list(..item.bullets.map(bullet => [#bullet]))
  ]
  #v(0.55em)
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
