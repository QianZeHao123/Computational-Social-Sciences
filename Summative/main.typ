#import "template.typ": *

// Take a look at the file `template.typ` in the file panel
// to customize this template and discover how it works.
#let today = datetime.today()
#show: project.with(
  title: "Computational Social Science Summative",
  // Remove the 'subtitle' field
  subtitle: "Research Brief: QCA Method in Developed Democracies",
  authors: ((name: "Z0195806", email: "bjsn39@durham.ac.uk"),),
  // Insert your abstract after the colon, wrapped in brackets.
  // Example: `abstract: [This is my abstract...]`
  abstract: "This is the abstract of the document.",
  date: today.display("[month repr:long] [day], [year]"),
)

// We generated the example code below so you can see how
// your document will look. Go ahead and replace it with
// your own content!
// ------------------------------------------------
// outline part
#show link: underline
#show outline.entry.where(level: 1): it => {
  v(12pt, weak: true)
  strong(it)
}
#outline(indent: auto)
// ------------------------------------------------

= Introduction

= The Social Policy Context in Democracy Satisfaction

== The Rise of Social Media in Political Action

In the past decade, social media has transformed from a platform for social interaction into a significant political tool. It has enabled political parties, advocacy groups, and individual politicians to communicate directly with the public, bypass debates in traditional media, and mobilize political action. The penetration of social media in developed democracies has raised crucial questions regarding its impact on political engagement and democratic health.

== Political Engagement and Democracy Satisfaction

Political engagement encompasses various activities that allow citizens to influence governmental policies or the selection of government officials. These activities include voting, participating in political discussions, joining political parties or movements, and engaging in protests. In a healthy democracy, high levels of political engagement suggest a population that is actively involved in shaping its governance, which is vital for the legitimacy and function of democratic institutions.

== Complexity in Social Media and Political Engagement

The relationship between social media use and political engagement is inherently complex, influenced by a myriad of factors including but not limited to:

=== Multiple Scales and Levels

Political engagement operates across multiple scales and levels, from individual tweets to country level. Actions at one level can influence outcomes at another, making it essential to consider multiple layers of interaction when analyzing political movements and their effectiveness.

=== Distributed Control

Control over political narratives and movements is distributed among many users and entities, with no single actor able to command complete control. This distributed nature can lead to diverse and sometimes conflicting messages within the same political camp, complicating efforts to present a unified stance.

=== Unknowns

There are many unknown factors in social media interactions that can unexpectedly influence political engagement and outcomes.

=== Unpredictability

The complexity and openness of political systems make them fundamentally unpredictable. The vast number of interactions and the continuous introduction of new content and users mean that predicting specific outcomes, such as the impact of a particular political message or campaign, is fraught with uncertainty. 

=== Non-linear Relationships

We cannot simply obtain democratic satisfaction through multi-level linear model fitting. And the interaction between variables is so complex that you can't manually try all the possibilities.

=== Feedback Loops

Political campaigns use social media feedback to adjust their strategies, creating an ongoing loop of action and reaction between political entities and the public.

#bibliography("references.bib")

