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
    [May 28, 2026],
  ))

  #v(0.35em)
  #line_group((
    [Hiring Committee],
    [Friends of Trees],
  ))

  #v(0.5em)
  Dear Hiring Committee,

  #v(0.6em)
  #paragraph([
    I am excited to apply for the Volunteer & Data Specialist position at Friends of Trees. I first became especially aware of Friends of Trees in the aftermath of Portland's June 2021 heat dome, when conversations about tree canopy, extreme heat, and neighborhood inequity felt impossible to ignore. It became clear how closely access to shade, cooling, and a healthier environment is tied to long-standing inequities, and Friends of Trees stood out to me as an organization that brings together data, advocacy, and direct community action. I am drawn to this role because it brings together several kinds of work that matter to me: supporting community-based programs, building reliable systems behind the scenes, and helping people have a meaningful experience when they show up to contribute. Friends of Trees' focus on stewardship, connection, equity, and bringing people together to care for trees and natural areas strongly resonates with me.
  ])

  #paragraph([
    To me, data management and volunteer experience are closely connected. Good volunteer experiences do not begin only when someone arrives at an event. They begin with clear sign-up systems, accurate records, timely communication, and thoughtful follow-through. When volunteer data is organized and dependable, people receive the right information, staff can plan well, outreach can be more intentional, and volunteers are more likely to feel that their time is respected. Strong data practices also help an organization learn from each event and improve how it supports both volunteers and the communities it serves.
  ])

  #paragraph([
    My background has prepared me well for that kind of work. Through Future Generations Collaborative, I contributed to community-based research and outreach work centered on housing equity, Indigenous data sovereignty, and relationship-building. That experience taught me the importance of accuracy, accountability, and handling information with care and context. I have also been active in mutual aid groups and community centers in Portland for years, and I understand how much effort it takes to coordinate people, build trust, and keep momentum going over time. In my service and operations work, I have developed a strong habit of staying organized, adapting quickly, and following through on detail-oriented responsibilities in fast-paced environments.
  ])

  #paragraph([
    In addition to what is listed on my resume, I bring grant writing, volunteer coordination, and accountability-focused experience from my time working with Future Generations Collaborative and Alder Commons. At Alder Commons, I helped support the woodshop as a volunteer coordinator and shop steward by helping keep the space safe, supporting systems for certifying new shop stewards, and contributing to community education through workshops. I also encouraged others to lead workshops and share knowledge. Those experiences strengthened my writing, reinforced the importance of clear documentation and safety-minded systems, and deepened my understanding of how behind-the-scenes coordination supports trust, consistency, and long-term community impact. I also bring technical training from my computer science degree, including experience with databases and systems thinking, which helps me feel comfortable learning and supporting new tools and workflows.
  ])

  #paragraph([
    I would be glad to bring care, consistency, and a community-centered approach to Friends of Trees' volunteer systems and operations. Thank you for your time and consideration.
  ])

  #v(0.45em)
  #line_group((
    [Sincerely,],
    [Matt Loera],
  ), gap: 0.9em)
]
