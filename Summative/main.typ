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

== Self-role Setting in Research

Assume that we are a group of researchers in the government think tank. We investigate the factors that influence political satisfaction in developed democracies. Our research aims to provide insights to policymakers on how to enhance democratic health and citizen satisfaction in developed democracies. Influenced by our leadership, we have been particularly interested in the *Qualitative Comparative Analysis* (QCA) approach in recent studies.

== Application in Social Policy Research

- Tailored Interventions: By identifying specific conditions under which social media positively or negatively affects political engagement with QCA, policymakers can design more targeted interventions.
- Inclusive Policy Making: QCA's ability to consider multiple combinations of conditions can ensure that diverse demographic and political contexts are considered in policy-making, preventing one-size-fits-all solutions.

= The Social Policy Context in Democracy Satisfaction

The democratic satisfaction of citizens in developed democracies is a multifaceted issue influenced by various factors. Understanding the complex interplay between these factors is crucial for policymakers seeking to enhance democratic satisfaction and governance effectiveness. In this context, I refer to the research of M. Chan in "Social Media Use and Political Engagement in Polarized Times"@SocialMediaUsePoliticalEngagement.

== The Rise of Social Media in Political Action

In the past decade, social media has transformed from a platform for social interaction into a significant political tool. It has enabled political parties, advocacy groups, and individual politicians to communicate directly with the public, bypass debates in traditional media, and mobilize political action. The penetration of social media in developed democracies has raised crucial questions regarding its impact on political engagement and democratic health.

== Affective and Issue Polarization

Affective polarization refers to the increasing hostility and negative feelings between members of different political parties or ideologies. Issue polarization, on the other hand, involves the widening gap between the policy preferences of different political groups. Both forms of polarization can contribute to political dissatisfaction and hinder effective governance in democracies.

== Political Engagement and Democracy Satisfaction

Political engagement encompasses various activities that allow citizens to influence governmental policies or the selection of government officials. These activities include voting, participating in political discussions, joining political parties or movements, and engaging in protests. In a healthy democracy, high levels of political engagement suggest a population that is actively involved in shaping its governance, which is vital for the legitimacy and function of democratic institutions.

== Complexity in Social Media and Political Engagement

The relationship between social media use and political engagement is inherently complex, influenced by a myriad of factors @VISUALCOMPLEXITY including but not limited to (*In this part I do some descriptive statistical work, and the results confirme the social complexity of the problem we are studying*):

=== Multiple Scales and Levels

Political engagement operates across multiple scales and levels, from individual tweets to country level. Actions at one level can influence outcomes at another, making it essential to consider multiple layers of interaction when analyzing political movements and their effectiveness.

#image("./img/boxp.png")

If we divide the discussion into countries and individuals during the study, we will find that when we study the state system, the political satisfaction of countries with complete democracy is higher (Appendix 3.4).

=== Distributed Control

Control over political narratives and movements is distributed among many users and entities, with no single actor able to command complete control. This distributed nature can lead to diverse and sometimes conflicting messages within the same political camp, complicating efforts to present a unified stance.

=== Unknowns

There are many unknown factors in social media interactions that can unexpectedly influence political engagement and outcomes.

#image("./img/cor.png")

Although some variables have a low correlation with each other, it does not mean that there is no interaction between them (Appendix 3.6).

=== Unpredictability

The complexity and openness of political systems make them fundamentally unpredictable. The vast number of interactions and the continuous introduction of new content and users mean that predicting specific outcomes, such as the impact of a particular political message or campaign, is fraught with uncertainty. 

=== Non-linear Relationships

We cannot simply obtain democratic satisfaction through multi-level linear model fitting. And the interaction between variables is so complex that you can't manually try all the possibilities.

#image("./img/no_linear.png")

Theoretically more information on social networks about political elections will increase more turnout, and in turn will allow democracy satisfaction decreases, however. There is no linear relationship directly from the scatter plot (Appendix 3.5).

=== Feedback Loops

Political campaigns use social media feedback to adjust their strategies, creating an ongoing loop of action and reaction between political entities and the public.

= Research Question

Therefore, based on our own background and research contexts, we propose the following research questions:

*"How does the combination of social media use, affective and issue polarization, and other socio-political factors influence political satisfaction in developed democracies?"*

This question seeks to explore the complex interplay between social media, regime and various dimensions of political engagement and satisfaction.

= Introduction to the Dem-Dataset and QCA Method

== The Dem-Dataset

Dem-Dataset is obtained by processing and integrating two datasets, namely Varieties of Democracy (V-Dem) @VDem2022 and World Values Survey (WVS) @Haerpfer2022WorldValues. In Appendix 1.2 there is a flowchart for the integration of the two datasets.

- *Varieties of Democracy (V-Dem)*: Provides comprehensive indicators on various dimensions of democracy, which can be used to measure aspects like issue and affective polarization at the country level.
- *World Values Survey (WVS)*: Offers extensive survey data on values, norms, and political behaviors of individuals across various countries, likely providing individual-level data on political engagement, social media use, and perceptions of democracy.

Here's a breakdown of the types of data used in the analysis:

+ Individual-Level Data
  - *Social Media Use for Political Information*: Frequency of using platforms like Facebook and Twitter for political information.
  - *Political Participation and Voting*: Engagement in political activities, including voting and attending political events.
  - *Demographic and Socioeconomic Variables*: Variables such as age, education, and income.
+ Country-Level Data
  - *Polarization Measures*: Affective and issue polarization scores.
  - *Political, Economic Indicators and Other Macro-level Variables*

The Dem-Dataset is loaded in *Appendix 2*.

#image("./img/distr_dem.png")

== Qualitative Comparative Analysis (QCA)

QCA is a method that allows for the systematic analysis of complex causal relationships in small to medium-N datasets. It is particularly useful when dealing with multiple causal conditions that can lead to an outcome of interest. QCA is based on Boolean algebra and set theory, which enables researchers to identify necessary and sufficient conditions for an outcome to occur.

=== Steps for QCA

+ Define the Outcome: Identify the outcome of interest, in our case, political satisfaction.
+ Select Conditions: Choose the causal conditions that may influence the outcome (Regime, Vote, and etc.).
+ Calibrate Conditions: Assign values to the conditions based on empirical data.
+ Truth Table: Generate a truth table that lists all possible combinations of conditions and outcomes.
+ Analysis: Use software like fsQCA to analyze the truth table and identify necessary and sufficient conditions for the outcome.

=== Flowchart of QCA Method

= Justification of Data and Model Choice

== Appropriateness of QCA for the Research Question

QCA is highly suitable for this research due to several factors:

- Complex Causal Relationships: It explores how interdependent variables and contingent conditions, such as social media impact under various levels of polarization and regime types, interact to affect political satisfaction.
- Configurational Comparative Approach: QCA differs from traditional methods by examining how unique combinations of conditions lead to outcomes, rather than assuming independent causal effects. This is critical for understanding the multifaceted role of social media in political engagement.
- Identification of Conditions: QCA pinpoints necessary and sufficient conditions for outcomes, offering valuable insights for policy-making, especially in understanding how specific settings influence political satisfaction.

== Suitable Dataset Selection

- Suitability for QCA: The dataset contains both continuous and categorical data suitable for transformation into the binary or multi-value sets required for QCA analysis.
- Relevance: The dataset includes variables directly relevant to the research question, such as levels of social media use, affective and issue polarization, political participation, voting behavior, and perceptions of democratic quality.
- Comprehensiveness: It spans a broad range of developed democracies, providing a diverse context that enhances the generalizability and relevance of the findings.

#bibliography("references.bib")
