#let ink = rgb("#111827")

#set page(
  width: 8.5in,
  height: 11in,
  margin: (x: 0.95in, y: 0.8in),
)

#set text(
  font: ("Charter", "Times New Roman", "Times"),
  size: 10pt,
  fill: ink,
)

#set par(
  justify: false,
  leading: 0.2em,
  spacing: 0.62em,
)

#let paragraph(body) = block(width: 100%, below: 0.88em)[#h(1.5em)#body]

#let line_group(lines, gap: 0.12em) = {
  for line in lines {
    block(below: gap)[#line]
  }
}

#align(left)[
  #line_group((
    [September 19, 2026],
  ))

  #v(0.35em)
  #line_group((
    [Hiring Team],
    [Prometheum],
  ))

  #v(0.5em)
  Dear Hiring Team,

  #v(0.6em)
  #paragraph([
    I am writing to apply for the Software Engineer 1 (Full-Stack) role at Prometheum. I recently completed a B.S. in Computer Science at Portland State University, and I am looking for an entry-level engineering role where I can grow quickly on production systems with real stakes. The chance to start with small, well-defined pieces of a TypeScript and React codebase and take on more as I learn the system is exactly the kind of ramp-up I am looking for.
  ])

  #paragraph([
    Most recently, I built a full-stack Bar Inventory App that converts unstructured spoken inventory notes into clean, structured inventory data. I used TypeScript, React, Python, and SQL across the project, and designed a command-driven parsing workflow that matches voice transcription output against inventory sheet items, cutting AI API calls by roughly 80 percent. That project gave me hands-on practice using AI coding tools as a standard part of my workflow, while still needing to read the output carefully, catch what it gets wrong, and correct it myself before trusting it.
  ])

  #paragraph([
    My coursework in systems programming, data structures, digital circuits, and SQL databases gave me a solid foundation for reasoning about how a request moves from a front end through an API into a database, which I understand is central to how your team maps and debugs issues end to end. I do not have direct experience in finance or blockchain, but I am a fast learner, and I am drawn to Prometheum's work precisely because it combines engineering with real regulatory significance.
  ])

  #paragraph([
    Outside of formal engineering work, I have spent several years in fast-paced service roles, most recently as a bar manager, where I am used to adapting quickly to shifting priorities, coordinating with a team under pressure, and staying accountable for details that matter. I also bring experience from community-based research and grant reporting work, which sharpened my written communication and my habit of double-checking accuracy before something goes out the door.
  ])

  #paragraph([
    I would welcome the opportunity to bring that combination of full-stack project experience, AI-assisted development practice, and steady, detail-oriented follow-through to your engineering team. Thank you for your time and consideration.
  ])

  #v(0.45em)
  #line_group((
    [Sincerely,],
    [Matt Loera],
  ), gap: 0.9em)
]
