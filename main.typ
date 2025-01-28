#import "@preview/modern-technique-report:0.1.0": *
#import "@preview/subpar:0.1.0"
#import "@preview/showybox:2.0.1": showybox
#import "@preview/codly:1.1.1": *
#import "@preview/codly-languages:0.1.1": *
#show: codly-init.with()

#codly(
  zebra-fill: none,
  languages: (
    python: (name: "Python"),
  )
)

#show: modern-technique-report.with(
  title: [Introduction to Modelling in Systems Biology],
  subtitle: [
    *Systems Biology Models (8BM050)*
  ],
  series: [Eindhoven University of Technology \ Department of Biomedical Engineering],
  author: [_M. de Rooij_],
  date: [version: ]+datetime.today().display("[month]-[year]"),
  background: image("decorative_figures/2024-2.jpg"),
  theme-color: rgb(21, 74, 135),
  font: "Avenir Next",
  title-font: "Avenir Next",
)

#show figure.where(
  kind: table
): set figure.caption(position: top)

#show figure.caption: set align(left)
#show figure.caption: c => [#text(size: 10pt)[
  #text(fill: orange, weight: "bold")[
    #c.supplement #c.counter.display(c.numbering)
  ]
  #c.separator#c.body
]]

#show bibliography: set heading(numbering: none)

#show heading.where(
  level: 4
): set heading(numbering: none)

#show heading.where(level: 1): it => [
  #pagebreak()
  #if it.numbering != none [
    #let ch = counter(heading)
    #block(
      grid(
        columns: (3fr, 1fr, 1fr),
        align: (left, right, right),
        text(size: 24pt, fill: rgb(21, 74, 135), font: "Avenir Next")[#it.body],
        line(start: (0pt, 40pt), end: (0pt, -75pt), stroke: 5pt + rgb(21, 74, 135).lighten(50%)),
        text(size: 35pt, fill: rgb(21, 74, 135), font: "Avenir Next")[#ch.display("1")]
      )
    )
  ] else [ // correction when no numbering is used
    #block(
      grid(
        columns: (3fr, 1fr, 1fr),
        align: (left, right, right),
        text(size: 24pt, fill: rgb(21, 74, 135), font: "Avenir Next")[#it.body],
        [],
        []
      )
    )
  ]
]

#let c = counter("example")

#let example(it) = figure(showybox(
  frame: (border-color: rgb(115, 147, 179, 100%).darken(50%),
          title-color: rgb(115, 147, 179, 100%).lighten(20%),
          body-color: rgb(115, 147, 179, 100%).lighten(90%)
        ),
        title-style: (
          color: black, 
          weight: "bold",
          align: left
        ),
        breakable: true,
        title: [
          #c.step()
          Example #context c.display()
        ],
        [#it]
), kind: "example", supplement: [Example]
)

#show figure.where(kind: "example"): set block(breakable: true)

#set quote(block: true, quotes: true)

// #let example(it) = block(fill: rgb(255,215,181, 30%), stroke: rgb(255,215,181, 100%), inset: 16pt, radius: 8pt, above: 24pt, below: 24pt,[
//   #c.step()
//   *Example #context c.display())* \
//   #it
// ])

#set math.equation(numbering: "(1)")

#show link: underline
#set page(numbering: "1", number-align: right)

// shorthand for ODE
#let ddt(it) = $ (upright(d)#it) / (upright(d)t) $

#let chq = symbol(
  "⇌"
)

= Introduction to Systems Biology


#set align(center)
#quote(attribution: [Jack Sparrow (Pirates of the Caribbean)])[
  The problem is not the problem. The problem is your attitude about the problem.
]

#set align(left)
== Studying Biological Processes as Interconnected Systems
Many ancient cultures have sought to understand the world around us by defining the most basic components that make up everything. In ancient Greece, the philosopher Empedocles determined all matter to be composed of four primal elements: earth, air, fire, and water.  @Stroker1968 An illustration of these four elements and their combinations is shown in @four-elements.


#figure(
  image("figures/Leibniz_four_elements.jpg", width: 50%),
  caption: [Leibniz representation of the universe by combining the four elements of Empedocles according to Aristotle. Gottfried Wilhelm von Leibniz, Public domain, via Wikimedia Commons]
)<four-elements>

Later, Aristotle added a fifth element, _Aether_, as a permanent and heavenly substance. These five elements are seen in other cultures, such as Hinduism @Gopal1990 and Chinese culture @Carroll2012. This idea of reducing the world around us into fundamental components had also transferred to medicine, where Hippocrates systemized the study of four humours _blood_, _yellow bile_, _black bile_, and _phlegm_, which can be linked to air, fire, earth and water respectively. In this study, health was described as the notion of a _balance_ in the amounts of these four humours and subsequently diseases were caused by an imbalance. This practice of humoral medicine was common until the 19#super[th] century. @Jackson2001

While many advances were made in modern medicine, for the greater part of the 20#super[th] century, understanding of biology and medicine was dominated by the so-called _reductionist_ view. The central idea was that by detailed examination of each component in the system, we would gain an understanding of the system as a whole. While the obtained knowledge from reductionist research is useful in studying biological systems from a biochemical perspective, reducing these to the sum of their parts has disadvantages that relate to some key properties in complex regulatory systems.

The first of these is _emergence_. Complex systems regularly display properties related to the combined interaction of the components. These properties cannot be directly related to the components alone. This is often observed in chemistry, as knowledge about the interaction between atoms is not enough to understand the interaction between molecules, as they display emergent properties in specific configurations, which we need to understand as well.

A second property is _redundancy_. The inherent robustness of biological systems to perturbations is what keeps us alive. Biological systems are robust because of a large redundancy in their components. This means that different components can compensate together in situations when a component is lacking. 

The third and last key property is _modularity_. As also seen in various other courses on biology, our body can be studied on multiple levels, as it is composed of various organ systems, that are each made up of organs. Each organ in our body is built from forms of tissue, which is made up of cells. This strongly hierarchical property requires us to study processes on multiple levels. @Aderem2005

A common way to gain understanding about these systems as a whole is through combination of experimental 'wet lab' research (_in vitro_ and _in vivo_ experiments), and computational (_in silico_) modelling. The latter of which is an important component in systems biology. This field is largely concerned with the study of interacting biological components, not by merely investigating the components individually, but by examining the living system as a whole. A common example to illustrate the utility of the approach taken in systems biology can be seen in @blind-men-elephant. In this figure, six men are each investigating a part of the whole system (elephant), while only by studying the system as a whole, the correct solution can be found. 

#figure(
  image("figures/6-blind-men-hans-1024x6541.jpg", width: 100%),
  caption: [Six blind men investigating parts of the elephant. Each of the men has a different hypothesis of what the elephant could be, based on them feeling a specific part of the elephant. However, only by investigating all the specific parts, they can conclude that there is an elephant standing before them.],
) <blind-men-elephant>

This practice can be applied to study mechanisms that keep us alive, such as homeostatic systems, or cellular communication networks, and to identify causes of disease and the effect of possible treatments. @Voit2022 In these lecture notes, we aim to provide an introduction to integrating biological knowledge and findings from wet lab research into models, analyzing these models, and identifying basic properties of these systems that are otherwise difficult or impossible to study in practical experiments alone. In this way, we hope to create an understanding of the utility and importance of models as a tool to aid engineering research. @vanRiel2020

== Models and Modelling
Before we can talk about different modelling techniques, it is important to clarify what we mean with modelling and models in systems biology. A model in science and engineering is a broad concept, but is always something that is made to reflect a part of a real system, often in a simple, more malleable way, in order to study specific components of that system. We can do this by constructing a physical system, such as a pump and a set of tubes to model circulation, through a living model, such as a mouse model, or by means of a computer model, often described in some mathematical framework. These models are all experimental setups, but we can also have conceptual models, such as a diagram of different interactions in a system, or a free body diagram in mechanics. An example of an interaction diagram can be seen in @introduction-example-system.

In this course, we will be looking at computer models. However, even within computer models, we can make distinctions between types of models. A strong distinction often made is the difference between data-driven, and principles-driven models. In data-driven models, we typically start from a large set of measurements, combined with the desired outcome, such as a prediction, and we let the computer come up with a model that can connect the two. In principles-driven models, we start from existing knowledge of a specific process, and convert this knowledge into rigid mathematical formulations. In the latter, a model is a structured version of a collection of previous knowledge, that we use systematically to obtain new information. Both techniques can be combined, as well, were parameters, or even parts of whole models are distilled from measurements directly, while other parts of the model are fixed based on literature knowledge. The techniques involved in that are beyond the scope of these lecture notes, however.

Instead, in this course, when we talk about a model, we will be referring to a simplified mathematical description of a biological process. The mathematical framework for each model can vary depending on the level of detail we wish to include, the amount of information we possess, and the questions we wish to answer using the model. In these lecture notes, two mathematical frameworks are discussed. The first is graph theory, used to describe interactions between different (biological) components. We can build graphs of biological systems and use these models to derive system properties. Additionally, we will be discussing models that describe processes that change over time, using systems of differential equations. 

== Digital Twins
When studying complicated dynamical systems, such as biological systems, but also in industrial applications, it is often a cost-effective choice to evaluate decisions based on simulations. In industrial applications, this typically involves the measurement of product lifetimes and the probabilities of specific parts breaking. In healthcare, we can take this practice and adapt it to evaluate medical treatment decisions. These simulations are done using a virtual version of the physical system, called a 'Digital Twin'. While many definitions of a digital twin exist, a digital twin in healthcare can be thought of as a virtual representation of (a part of) an individual that enables the simulation of a potential treatment, monitoring and prediction of health, which allows for early personalised interventions, and prevention of disease. The main element distinguishing a digital twin from a model, is its ability to both take into account measurements from the physical system and provide feedback based on these measurements. 

#figure(
  image("figures/Example_Interaction_Diagram.png", width: 60%),
  caption: [Example of a conceptual model of an interaction system between various components. In this arrows present stimulatory interactions whereas bars indicate inhibitory processes. The solid lines depict the conversion of one component into another, and the dashed lines represent communicative interactions (where the messenger is not consumed). Models like these are commonly used to show the structure of various mathematical models.],
) <introduction-example-system>

== Outline of the Course
Over the course, we will be highlighting several types of mathematical models. We will gradually introduce new concepts that arise from the various mathematical frameworks that these models are embedded in. Initially, we will describe how to combine sources of biological evidence to form hypotheses about associations between components. These hypotheses can be combined to form an associative model of interactions. While these are useful in grasping the general function of the system, these models provide limited ways of analyzing the underlying system. Mathematical graph theory can aid us in obtaining static properties of systems and to identify the important components. Therefore, we will shortly discuss the fundamentals of this branch of mathematics, and how this connects to biological meaning. 

Beyond static graphs, we will move into the world of dynamic modelling and explore how to create simplified models that can describe behavior of a system over time. Finally, we will touch upon what happens when we scale-up these systems to incorporate much more interactions, and how to deal with difficulties that arise as a result. Besides the mathematical frameworks, we will discuss use cases of these models, and how they can aid us in forming and validating hypotheses, designing targeted experiments, and drawing comprehensive conclusions.

The goal of this course is therefore to provide its students with a strong set of tools that allow them to begin modelling biological systems on a great range of scales and in various medical contexts. But also to give them the ability to use these models as an aid in future experimental research.

== Mathematics and Programming in Modelling
Within these lecture notes, various concepts of mathematics will be treated. Some concepts, like differential equations, you will have seen in previous courses. Others, such as graph theory, may be new. It is important to highlight that we view mathematics as a method of describing our models and subsequent analyses. While the subject may be interesting and generally important, this course will not touch upon mathematical proofs underlying the various concepts. The description of the mathematics in these lecture notes is purely from a practical point of view. Even though we will need mathematical notation, the equations and notations are made to be as simple and easy-to-read as possible. Furthermore, all equations are explained in as much detail as necessary for understanding their use.

Besides mathematics, this course will also feature some programming skills. As with mathematics, these programming languages are tools that we use to perform simulations and analyses. It is not our goal to make you write the most beautiful and efficient programs that exist. What is important is that after the course, you will be able to use appropriate software in modelling. In further parts of these lecture notes, modelling and analyses will be accompanied by examples written in Python, to illustrate how you could perform various procedures yourself.

= Network Models
#set align(center)
#quote(attribution: [The Cheshire Cat (Alice in Wonderland)])[
  If you don't know where you want to go, then it doesn't matter which path you take.
]

#set align(left)
== Introduction to Graph Theory
In this section, we will introduce you to the fundamentals of mathematical graph theory, and apply this to analyze biological systems. Of course, we first will have to explain what a graph is. But first, one often encountered example to illustrate the significance of graph theory. 

#example[The city of Königsberg - now called Kaliningrad - was located on the river Pregel in what was called Prussia back then. The city contained two islands in the river, and two banks on each side of the river. The regions were connected by seven bridges as shown in @bridges-konigsberg-map. The problem in this case was to find a path through the city by crossing each bridge exactly once. 

    #figure(
    image("figures/bridges-konigsberg-map.png", width: 60%),
    caption: [The Bridges of Königsberg as a drawn map.],
  ) <bridges-konigsberg-map>
    
    Famous mathematician Euler pointed out that the only important property in this case, was the sequence of bridges taken, and that the paths taken on each land mass are irrelevant. This led to Euler being able to simplify the problem into a set of points - representing each land mass - and lines - representing each bridge connecting two land masses - in one figure. The result is shown in @bridges-konigsberg-graph. 

        #figure(
    image("figures/konigsberg-graph.png", width:20%),
    caption: [The Bridges of Königsberg as a graph.],
  ) <bridges-konigsberg-graph>

    He devised that it was _impossible_ to find a path that crossed every bridge, but each bridge only once, as the fundamental requirement for this to be possible, was that either zero, or two of the points had an uneven number of lines connected to them. Since there are four points in @bridges-konigsberg-graph with an odd number of lines connected to them, such a path is not possible. Now, this argument is considered to be the first theorem of graph theory, and a path that traverses every line once, is called an Eulerian path. @Diestel2017]<example-graph-theory-konigsberg>

Slightly more formally, a graph is a set of points, called 'vertices' or 'nodes', connected by lines, called 'edges'. We generally denote this by using the letters $G$ for a graph,  $V$ for vertices and $E$ for edges in between accolades. Therefore, we can note down any graph as 

$ G = {V, E} $

If our graph is small enough, we can often visualize it easily, as was the case with the example above. Another example visualization of such a small graph can be seen in @simple-graph-example. This graph contains eight vertices, labelled using the letters A-H, and nine edges. Besides describing graphs this way, we can also use what we call an adjacency matrix. This is a #emph[square] matrix of size $|V|$, which means that it has the same number of rows as it has columns, which is equal to the number of vertices in the graph. As you may have already deduced from the notation, we use bars around the letters $V$ and $E$ to denote the numbers of vertices and edges respectively.

        #figure(
    image("figures/Example_Simple_Graph.png", width: 20%),
    caption: [An example visualization of a simple graph, with 8 vertices and 9 edges. For small graphs, we can easily make these figures, but for larger graphs, it quickly becomes difficult to prevent overlapping edges, and to distinguish connections.],
  ) <simple-graph-example>

In its simplest form, the adjacency matrix is both square and #emph[symmetric], which means that on coordinate $[i, j]$ you will find the exact same entry as on coordinate $[j, i]$. Moreover, you will find only the numbers $0$ and $1$ in this matrix, where a $0$ in position $[i, j]$ denotes that two vertices, represented by row $i$ and column $j$ are #emph[unconnected] and a $1$  in this position indicates that there is a connection between these two vertices. We can form the adjacency matrix for the graph in @simple-graph-example as follows

$ mat(
  "A", "B", "C", "D", "E", "F", "G", "H";
  0, 1, 0, 0, 0, 0, 0, 0, "A";
  1, 0, 0, 1, 1, 0, 0, 0, "B";
  0, 0, 0, 1, 0, 0, 0, 0, "C";
  0, 1, 1, 0, 1, 0, 1, 1, "D";
  0, 1, 0, 1, 0, 1, 0, 0, "E";
  0, 0, 0, 0, 1, 0, 0, 0, "F";
  0, 0, 0, 1, 0, 0, 0, 1, "G";
  0, 0, 0, 1, 0, 0, 1, 0, "H";
  augment: #(hline: 1, vline: -1))

$

Another thing you might notice is that the diagonal of this matrix contains only zeros. This is because this simple graph does not contain #emph[self-loops], which are connections of one node to itself. In case of a self-loop, the entry $2$ is used in the adjacency matrix. 

In a computer, a graph is usually represented by an adjacency matrix, because it is useful to store large amounts of data in these matrices. Also, when performing analyses on graphs, these matrices come in handy, because we can apply some operations from linear algebra on these graphs to quickly and efficiently get our information out. An example calculation you can do is to sum each row, or column, to obtain the amount of connections one vertex has in total. A more complicated operation is to multiply one column with the transpose of a row. This will provide you with the amount of connections two vertices have in common. These and more of these properties will be discussed in a later section in more detail.

=== Types of Graphs
We can distinguish types of graphs, that represent connections between vertices in different ways. The simplest type is the one seen above, which is called an #emph[undirected graph], which means that all edges do not represent a direction in the connection between the vertices. Instead of this, we can also provide a directionality to edges, giving us a #emph[directed] graph. In these graphs, the adjacency matrix is not symmetric anymore, because connecting a vertex $A$ to vertex $B$, does not directly mean that vertex $B$ is also connected to vertex $A$. Biological signals or chemical reactions often have distinct directions, which also means that we often represent those with directed graphs. Besides directionality, we can distinguish graphs based on whether they have #emph[self-loops], which are vertices that are connected to themselves, or whether they are #emph[cyclic] (you can draw a path from a vertex that ends in the same vertex, without using the same edge twice), or the opposite: #emph[acyclic]. Examples of these different types are shown in @example-graph-types. 

#subpar.grid(
  figure(image("figures/Example_UAG.png", width: 60%), caption: ""), <example-graph-types-a>,
  figure(image("figures/Example_DAG.png", width: 60%), caption: ""), <example-graph-types-b>,
  figure(image("figures/Example_DCG.png", width: 60%), caption: ""), <example-graph-types-c>,
  figure(image("figures/Example_DCGsl.png", width: 60%), caption: ""), <example-graph-types-d>,
  columns: (1fr, 1fr, 1fr, 1fr),
  caption: [Different graph types. *(a)* An undirected acyclic graph. The edges have no directionality and there are no cycles. *(b)* A directed acyclic graph. The edges have a directionality, but the graph is not cyclic. *(c)* A directed cyclic graph, where we have directionality and cycles. *(d)* A directed cyclic graph with self-loops.],
  label: <example-graph-types>,
)

It may be difficult to make this information more concrete right now, so let's link these graph types to biological systems so we can understand their different uses. Because many systems in biology are linked to directions, the undirected graph may be difficult to put to use directly. 

An example where we can use undirected graphs is when analyzing gene expression data. For example, we may want to analyze whether two genes are co-expressed, meaning that mRNA is often produced from two genes at the same time of measurement @Stuart2003. We can construct such a graph by creating a vertex for each gene, and connecting two vertices if the expression of these genes is #emph[significantly] correlated (testing if it is true that when gene $a$ has a high expression value, gene $b$ also is likely to have a high expression value). In that way, if we know what the function of gene $a$ is, we can hypothesize about the possibly yet unknown function of gene $b$. 

For a directed graph, applications within biology are possibly easier to think of. Of course, we can create a directed graph of chemical reactions, or pathways, such as glycolysis, or the MAP kinase pathway. Using these graphs, we can easily reason about the downstream effect of small upstream changes. Self-loops are also often observed in biological systems, such as where a piece of DNA encodes for a protein that blocks itself from being transcribed, creating a feedback loop. 

=== Graphs in Biology
Besides the coupling of names, letters or numbers to vertices, we can also add other properties of our system to vertices. We could, for example, combine enzymes and reactants and products together in one directed graph, where we use the directionality to distinguish between the product and the reactant in a catalyzed reaction. In this graph, we will have an additional vertex property; whether it corresponds to a (consumed or produced) molecule, or an enzyme. An example is shown in @graph-hexokinase, showing the conversion of glucose to glucose-6-phosphate, by a hexokinase enzyme. Using this graph, we can identify whether a type of cell missing a specific enzyme would still be able to produce certain molecules. Other properties we could add to the enzyme nodes are the Michaelis-Menten constants ($K_M$) for these specific enzymes. 

#figure(
  image("figures/Example_Hexokinase_Directed_Graph.png", width: 50%), caption: [Example of a directed graph with two types of vertices using the conversion of glucose to glucose-6-phosphate (G6P) upon entry into the cytoplasm. We have the enzyme vertex(orange), and the four molecule vertices (blue).]
)<graph-hexokinase>

When talking about chemical reactions, we can also think about properties we could add to edges. In a simple chemical reaction graph, we can add the rate at which the reaction happens ($k$) as a property to the edge. Therefore, besides the structural component of graphs, we can also add data to each graph element. Because biological systems tend to be incredibly complicated, graphs are a powerful tool to analyze these systems in a comprehensive way. In the next section, we will discuss some graph properties that can aid us in analyzing a biological system.

=== Properties of Graphs
A graph is not just created to make visualizations of connectivity within a system. After constructing a graph, we often also want to obtain properties of this graph, and reason about what these properties mean for our system in real life. We can distinguish properties at the graph level, and at the vertex and edge level. We will first discuss some basic properties of graphs and their elements.

==== Degree
The degree of a vertex in a graph is the number of edges that connects it to the rest of the graph. In directed graphs, we can distinguish an in-degree and an out-degree for incoming and outgoing edges, respectively. The degree of a vertex is difficult to interpret directly on its own, as its meaning strongly depends on the degree of all vertices in a graph. An important measure of a graph, however, is the #emph[degree distribution]. It is given by the distribution $P(k)$ for degree $k$ as

$ P(k) = frac(n_k,n) $

Where $n_k$ is the number of vertices having degree $k$ and $n$ the total number of vertices. The sum of all degrees in a graph is directly related to the number of edges by

   $ sum_n k_n = 2|E| $

In words, this says that the sum of all degrees in a graph equals twice the amount of edges. Therefore, the sum of all degrees in a graph must always be #emph[even]. 

==== Scale-Free Graphs
A popular property related to degree distributions and often attributed to metabolic networks is scale-freeness. @Rajula2018 The main observation in a scale-free network is that the degree-distribution follows a power-law, which is given by

$ P_"sf" (k) = k^(-gamma) $

Where the parameter $gamma$ typically lies between a value of 2 and 3. 

This property relates to the idea that in a large network, there are a few vertices that are connected to many others, while there are many vertices that are only connected to one or a few others. Vertices that have many connections in such a network are called #emph[hubs]. A simple analogy for understanding the property is by imagining a graph of all people in the world, where two people are connected if they've shaken hands. You can imagine that there are a few people, such as the president of the United States, that have shaken hands with many people, while many people have only shaken hands with a couple hundred people from their neighborhood. Similarly, on a social media platform like Instagram, there are many people where the sum of followers and following is lower than 1000, while only a few people have a sum of followers and following of more than a million.

While it was initially thought that all of these networks were scale-free, studies have shown that while they sometimes approach scale-freeness, very few of them actually strongly adhere to the power law property. @Broido2019

==== Connectedness
A basic property that most graphs you'll encounter have, is connectedness. An undirected graph is connected if we can reach every other vertex in the graph, starting from one random vertex. Considering directed graphs, we can distinguish various levels of connectedness. We call a directed graph #emph[weakly connected], if it becomes a connected graph when we do not consider the directionality of the edges. In the case where there is either a path from vertex $a$ to vertex $b$, or the other way around, for every vertex in the graph, we can call this graph semi-connected. When for every vertex $a$ and $b$ in the graph, we have both a path from $a$ to $b$, as well as a path from $b$ to $a$, we call this graph strongly connected.

==== Walks, Trails and Paths
When investigating graphs, we may also be interested in the ways that we can reach one vertex from the other. In order to properly define properties that relate to this concept, we identify three ways in which we can represent this. (1) A walk is a sequence of vertices, where each next vertex is connected by the previous. (2) A trail is a walk, but with the extra requirement that each #emph[edge] is distinct. (3) A path is a trail (so, all edges are distinct) where all vertices are distinct. Additionally, a #emph[cycle] is a path that has the same starting and ending vertex.


A quantity that is often of importance in a graph is the length of the shortest path from vertex A to vertex B. A famous algorithm for computing this is Dijkstra's algorithm. The details of this algorithm are beyond the scope of this course, but its implementation exists in the `networkx` Python package, where it can be used to find shortest paths and their lengths in graphs. An example of the shortest paths in a graph can be seen in @shortest-paths-b.

#subpar.grid(
  figure(image("figures/example-graph-paths.png", width: 60%), caption: ""), <shortest-paths-a>,
  figure(image("figures/example-graph-shortest-paths.png", width: 60%), caption: ""), <shortest-paths-b>,
  columns: (1fr, 1fr),
  caption: [*(a)* Example graph. Examples of walks include `[B-A-B-D]`, `[B-D-B-C]`, `[E-C-B-D-E-H]`, `[G-E-D-F]`. The last two are also both walks, because we can use distinct edges. Only the last one is a path, as it contains no distinct edges or vertices. *(b)* Shortest paths from B to E marked in green and red. Both have length 2.],
  label: <shortest-paths>,
)

Many other properties relate in some way to paths or distances. For a vertex A, we can compute its eccentricity as the maximum distance of the shortest paths from A to all other vertices in the graph. The radius of a graph is then related to this, as this is defined by the minimum eccentricity of all vertices in the graph, and the diameter of a graph is the maximum eccentricity of the vertices in a graph. Furthermore, if a vertex has an eccentricity which is equal to the radius of the graph, this vertex is called 'central'. The set of all central vertices is the center of the graph. 


==== Biochemical Graphs
In modelling of metabolic pathways, graphs are often used to represent the large metabolic networks in various organisms. They have been extensively used to study the structural properties of metabolic regulation. For biochemical graphs, we can identify three types: the molecule graph, the reaction graph, and the molecule-reaction graph. Below we will see how to construct each of them.

The #emph[substrate graph] or metabolite graph, as it is called when talking about metabolic networks, is constructed by taking all substrates in a reaction system and connecting them if two substrates are in the same reaction. 

The #emph[reaction graph] is constructed in a similar way, but now we take all reactions as vertices and connect two of them if they contain the same substrate.

Finally, the combined #emph[substrate-reaction graph] or metabolite-reaction graph is constructed by taking both substrates and reactions as vertices. If a substrate is in a reaction, we connect that substrate to the reaction. This specific graph can be made in an undirected way, as well as a directed way, where substrates are connected to reactions via outgoing edges towards reactions, while products are connected through incoming edges from reaction vertices.

In @example-reaction-graphs, the three types of biochemical graphs are shown for the reaction system:

  $ & R_1: #h(50%) A + D -> 2B \ 
    & R_2: #h(50%) 2B -> C+D \
    & R_3: #h(50%) 2D -> E $

#subpar.grid(
  figure(image("figures/Example-met-graph.png", width: 100%), caption: "Substrate graph"), <example-reaction-graphs-a>,
  figure(image("figures/Example-reac-graph.png", width: 60%), caption: "Reaction graph"), <example-reaction-graphs-b>,
  figure(image("figures/Example-metreac-graph.png", width: 100%), caption: "Substrate-reaction graph"), <example-reaction-graphs-c>,
  columns: (1fr, 1fr, 1fr),
  caption: [Three types of graphs in biochemical systems.],
  label: <example-reaction-graphs>,
)

Additionally, the combined substrate-reaction graph has a special property that the other two do not have. Notice that because of how the graph is constructed, we can never have two metabolites that are directly connected to each other, as well as no reactions that are connected to each other. A graph where you can color two "types" of notes, such that nodes of the same color have no edge between them is called #emph[bipartite]. 

// TODO: Add example of bipartite graph

=== Stoichiometry in Graphs
A common and useful property that is assigned to edges in molecule-reaction graphs is stoichiometry. In this way, the amount of molecules consumed and produced is included as information within the graph. Using this resulting directed graph with stoichiometric edge properties, we can construct the stoichiometric matrix. We can illustrate this using an example.
#example[
    We start with creating a matrix with the weights of all outgoing edges from each molecule towards the reaction, or equivalently, all incoming edges into each reaction.

    $
    A = mat(
         ,A,B,C,D,E;
    R_1,1,0 ,0,1 , 0;
    R_2,0 , 2 , 0 , 0 , 0;
    R_3  , 0 , 0 , 0 , 2 , 0; augment: #(hline: 1, vline: 1)
  )
    $

    Then, we will need a matrix with all incoming edges from each reaction towards each molecule, or equivalently, all outgoing edges from each reaction.

        $
    B = mat(
         , A ,B , C , D , E;
    R_1  , 0 , 2 , 0 , 0 , 0;
    R_2  , 0 , 0 , 1 , 1 , 0;
    R_3  , 0 , 0 , 0 , 0 , 1;
   augment: #(hline:1, vline:1))
    $

    Finally, we can compute the stoichiometry matrix ($N$) using the formula:
    $
        N = (B-A)^T
    $

    For this particular example, the stoichiometry matrix is given by:
    $
    N = mat(
      , R_1 , R_2 , R_3 ;
    A , -1  , 0   , 0   ;
    B , 2   , -2  , 0   ;
    C , 0   , 1   , 0   ;
    D , -1  , 1   , -2  ;
    E , 0   , 0   , 1 ; augment: #(hline:1, vline: 1)
  )
    $
  ]

== Metabolic Networks
In systems biology, the analysis of complex systems of cells relies on the reconstruction of large metabolic networks. These metabolic networks contain many intermediate reactions, also referred to as #emph[intermediary metabolism]. These reactions can be classified into two types of transformations: #emph[catabolic] reactions break down complex substrates into simple metabolites, and #emph[anabolic] reactions produce building blocks such as amino acids for the synthesis of proteins, nucleic acids for synthesis of DNA, RNA and energy intermediates such as ATP, and many others. All of these intermediate metabolic reactions take place through carrier molecules that together make up the metabolic network. 

Metabolic networks are also hierarchical, where we can identify four levels. The first level contains the cellular inputs and outputs. In #emph[in vitro] experiments, these inputs usually contain the medium and possible #emph[perturbations], and the outputs can be measured directly. In analysis of metabolic networks, we are often interested in the contribution of internal intermediates to the observed outputs. 

The second level has already been described, and contains the two #emph[sectors] of catabolism and anabolism. Often, another sector that can be identified is the property of #emph[growth]. 

The third level contains metabolic pathways, which can describe for example the uptake of glucose in a cell, its conversion to glucose-6-phosphate, and the further processing into the glycolysis pathway. Pathways are often important in pharmacology, where this specific level is often the target of drugs that stimulate or disturb an entire pathway. 

The final level is the level of individual chemical reactions. Components at this level are often reconstructed to identify causes of diseases and their mechanisms. This is necessary in inborn metabolic errors, as they can be the result of enzymes being inactive, impacting one specific reaction in the human body. The reconstruction of these networks can be done using high-throughput sequencing and metabolomics data. 

=== Reconstruction of Metabolic Networks
To reconstruct these networks, various sources of information are often used. To obtain this network, a list of reactions is required. The most reliable source of information to obtain the list of reactions is direct biochemical information, from experiments where enzymes are isolated in an organism. For model organisms such as #emph[E. coli] or yeast, this information can be readily available, but for humans, information is limited and hard to obtain. Alternatively, genome and epigenetic sequencing can reveal the transcribable proteins, and RNA sequencing data gives information on the actual genes being transcribed at a specific moment in time. Using perturbation experiments, the transcription reaction to molecules can be identified. More modern sequencing techniques, such as ChIP-seq can also give information on the DNA-protein interactions. 

Many online databases exist for all of the data types mentioned, and for some organisms, large reconstructions of metabolic networks exist. Examples include:

+ #link("https://www.ebi.ac.uk")[EMBL-EBI (genome data)]
+ #link("https://www.uniprot.org")[UniProt (protein data)]
+ #link("https://iubmb.qmul.ac.uk/enzyme/")[Enzyme commission numbers]

Additionally, known physiological constraints, such as localization constraints, or the biological knowledge that an organism or cell can produce a specific enzyme can help in identifying missing components. Finally, we can fill up missing components by using computer models. As our network needs to be able to simulate, we can fill in the gaps by fixing mass balances, or adding molecules necessary to produce specific products. These unvalidated reactions are called #emph[inferred] reactions. The computational tools used to infer these reactions are beyond the scope of this course and will be discussed in the Systems Medicine master course.

#pagebreak()
== Exercises
*1. For the following undirected graphs, write down the adjacency matrix*
#image("figures/exercise_graphs_1.png", width: 80%)

*2. For graph c) in the previous exercise:* 
#set enum(numbering: "a)", indent: 16pt)
+ compute the eccentricity of each vertex. 
+ What is the radius of this graph? 
+ What is the diameter? 
+ Which of the vertices are part of the centre?

*3. Take graph c) from exercise 1:* 
+ How many walks exist from B to D of length 2
+ And how many of length 3? 
+ And how many of length 4?

*4. Given the adjacency matrix of graph c) of exercise 1 as $C$, compute the following matrix products:* \
_Hint: Use MATLAB or Python + numpy to speed up the computation._

+ $C dot C$
+ $C dot C dot C$
+ $C dot C dot C dot C$
Compare the entries at point B,D to your answers in question 3. What do you observe?

*5. Give the molecule, reaction and molecule-reaction graphs for the following reaction system.* \
Add stoichiometric coefficients to the edge weights of the molecule-reaction graph.
$
    &R_1: A + C --> 2B \
    &R_2: D + B --> C + E  \
    &R_3: 3E <--> F \
    &R_4: A + F --> G \
$

*6. Assemble the Stoichiometric Matrix of the system in question 5.*

= Dynamic Models

#quote(attribution: [Remi (Ratatouille)])[The only thing predictable about life is its unpredictability.]

At the end of the previous chapter, we have seen that we can express systems of chemical reactions as a various types of graphs. We closed with the molecule-reaction graph, where the stoichiometric coefficients represent the edge weights. We also introduced the stoichiometry matrix, or $N$, which could be derived from the substrate-reaction graph. In this chapter, we will use this graph, combined with other concepts to discuss dynamic behavior of these reaction systems.

== Biochemical Systems
As discussed in the Introduction to this chapter, we will go more in-depth into the chemical reactions discussed in the previous chapter. We will start with an example. 

#example[
Observe the directed molecule reaction graph shown in @example-chemical-reaction. This graph represents the reaction:
$2"X" --> "Y"$

#figure(
  image("figures/ChemiReaction.png", width: 30%),
  caption: [The directed molecule reaction graph of a potential dimerization of monomer $X$ into dimer $Y$. The edge weights represent the stoichiometric coefficients for the reaction.]
) <example-chemical-reaction>

This can for example represent a simple dimerization of two monomers X into a dimer Y. Using the graph, we can construct our substrate matrix, which is given by the weight of all the outgoing edges for each molecule and reaction:
$
A = mat(
, "X" , "Y" ;
R_1  , 2 , 0 ;
)
$
And we can construct the product matrix, where we take all the weights of incoming edges for each molecule and reaction:
$
B = mat(
, "X" , "Y" ;
R_1  , 0 , 1;
)
$
Using these two matrices, we can construct the stoichiometry matrix.
$ 
N = (B-A)^T = mat(
, R_1 ;
"X" , -2 ;
"Y" , 1 ;
) $]<example-dimerization>

This procedure can give us static information about the reaction system we are studying, such as whether a molecule is produced or consumed overall, and which molecules may be most critical for the system. However, if we want to observe how this reaction occurs over time, we do not have enough information yet. For this, we are going to look at #emph[reaction rates] in the next part of this section.

== The Law of Mass-Action
 To be able to describe concentrations of molecules in a reaction system over time, we need to know at what rate the reaction occurs, besides the stoichiometry of the system. This reaction rate is defined as the amount of molecules that is converted per unit of time. The reaction rate is a row-vector with an entry for each reaction and labelled $v$. 

The law of mass-action defines the reaction rate to be proportional to the product of concentrations of reactants. The initial formulation of the law came from research into equilibrium states of reactions. Imagine a simple equilibrium reaction formulated as
$ a A + b B <--> c C + d D $

At equilibrium, the reaction rate of the forward reaction equals that of the reverse reaction. We can say
$ k_"f" [A]_"eq"^a [B]_"eq"^b = k_"r" [C]_"eq"^c [D]_"eq"^d $

So the forward reaction rate is the basal reaction rate of the forward reaction $k_"f"$ multiplied by the concentrations of $A$ and $B$, both raised to the power of the stoichiometric constants. The resulting formulation of the law of mass-action relates to the equilibrium constant, which is formulated as
$ K = k_"f"/f_"r" = ([C]_"eq"^c [D]_"eq"^d)/([A]_"eq"^a [B]_"eq"^b) $

Using this given, we can compute the reaction rate for each reaction using the law of mass-action. This means that for the reaction rate, we multiply all substrates together, and multiply this with the basal reaction rate $k$.
#set enum(numbering: "1.", indent: 0pt)
#example[
  1. For the reaction $ A limits(-->)^k B $ We get the reaction rate $v = k[A]$
 
  2. For the reaction $ A + B limits(-->)^k C $ We get the reaction rate $v = k[A][B]$

  3. For the reaction $ emptyset limits(-->)^k A $ We get the reaction rate $v = k$, as we have no substrates.
]<example-reaction-rates>
When looking at this example, we can use the same rules to identify the reaction rates from our dimerization example from @example-dimerization. In that example, the reaction rate is given by $ v = k[X][X] = k[X]^2 $  

The #emph[order] of a reaction is the highest exponent we can find in the reaction rate. For example, the first two reactions from @example-reaction-rates are both #emph[first order] reactions, and the last reaction from that example is a #emph[zeroth order] reaction. @reaction-orders-a shows the reaction rates for different reaction orders, with a rate constant of $k = 0.1$. We see that lower order reactions typically have higher reaction rates for substrate concentrations below 1, while higher order reactions have higher reaction rates above substrate concentrations of 1. In @reaction-orders-b you can subsequently see the production of $B$ over time for the different reaction orders.

#subpar.grid(
  figure(image("figures/reaction_orders.png", width: 60%), caption: ""), <reaction-orders-a>,
  figure(image("figures/reaction_orders_ode.png", width: 60%), caption: ""), <reaction-orders-b>,
  columns: (1fr, 1fr),
  caption: [Simulations of reaction orders 0 to 3. *(a)* The reaction rate according to mass-action kinetics for different reaction orders for a rate constant of $k=0.1$. *(b)* Simulation over time of the production of $B$ in the reaction $n A limits(-->)^k B$ for various reaction orders.],
  label: <reaction-orders>,
)
 
If we take things to a more general level, the law of mass action dictates that for a reaction in the form of:
$ n S limits(-->)^k P $
the reaction rate of formation of the product $P$ is given by:
$ v = k[S]^n $
For a reaction with $x$ substrates, the reaction rate of the product is given by:
$ v = k lr()([S]_1^(n_1) dot [S]_2^(n_2) dots [S]_x^(n_x) ) $
In this way, we can use the law of mass action in combination with the reaction scheme to construct the reaction rates. 

=== The Rate Equation
Using the stoichiometry matrix and the rates computed using the law of mass-action, we can create the #emph[rate equation]. This is a differential equation describing the change of our concentrations over time. 

The rate equation is given by
$ frac(upright(d)u, upright(d)t) = N dot v $

This is a differential equation. Filling in the stoichiometry matrix and the rate, we get

$
&frac(upright(d)[X], upright(d)t) &=& -2 dot k[X]^2 \
&frac(upright(d)[Y], upright(d)t) &=& k[X]^2
$

==== Differential Equations

Instead of directly describing molecular modelling processes as functions of time, it is often more intuitive to use #emph[ordinary differential equations] to describe the system's behavior over time. Differential equations have been introduced to you in your calculus course, and you may be familiar with solving simple examples. However, we will not be concerned with solving these differential equations analytically. Instead, we will analyze them directly and describe their components. 

An intuitive way of looking at a differential equation for a molecule $X$ can be:
$ underbrace((upright(d)X )/ (upright(d)t), "rate of change of X at time t") = upright("Production")(X)-"Consumption"(X) $

Often, we can derive these production and consumption terms from mass-action kinetics, but as modelers, we also have the freedom of taking other assumptions about these terms. Examples of these will be discussed in the next section. For now, let's further explore some examples of mass-action kinetic models and identify the production and consumption terms in each model. 

==== Model Examples
In our first example, let's discuss a system with two reactions and one molecule. This type of reaction is a very simple basis for a biochemical model, where we have a constant input, and a concentration-dependent consumption term. In future sections, you will be able to recognize the result of this example in parts of models.

#example[
      Let's consider the reaction
      $ limits(-->)^(k_1) A limits(-->)^(k_2) $
    We only have one molecule, but we have two reactions. Therefore, the substrate matrix looks like:
    $ A = mat(
      , upright(A) ;
      upright(R)_1 , 0 ;
      upright(R)_2 , 1 ;
    ) $
    And our product matrix looks like:
    $ B = mat(
      , upright(A) ;
      upright(R)_1 , 1 ;
      upright(R)_2 , 0 ;
    ) $
    We can construct our stoichiometry matrix as:
    $ N = (B-A)^T = mat(, upright(R)_1, upright(R)_2; upright(A), 1, -1) $

    We now only need our rates, the rate for $R_1$ is equal to $k_1$, as we have no substrates, but the rate for $R_2$ is equal to $k_2[A]$, as we have $A$ as its substrate. The rate vector then looks like:
    $ v = mat(upright(R)_1, k_1;upright(R)_2, k_2[A]) $

    Our final differential equation then looks like:
    $ (upright(d)[A]) / (upright(d)t) = N dot v = mat(1, -1) dot mat(k_1;k_2[A]) = k_1 - k_2[A] $
]

In the example above we have shown two reactions with one molecule. We can also create an example of two molecules of which one is produced and the other one is consumed in accordance with both reactions of the example above. However, these molecules can also be converted into one another. Let's see how mass-action kinetics can help us define a differential equation for this system.

#example[
  #figure(image("figures/Systemfourreactions.png", width: 25%), caption: [A reaction system with two molecules and one two-sided reaction.])<system-four-reactions>
    Consider the system that is shown in @system-four-reactions. We can write the individual reactions as:
    $
    &emptyset limits(-->)^(k_1)A \
    &A limits(-->)^(k_+)B \
    &B limits(-->)^(k_2) emptyset \
    &B limits(-->)^(k_-) A
    $
    We now have four reactions and two molecules. Therefore, the substrate matrix looks like:
    $ A = mat(, A, B ;
  R_1, 0, 0;
R_2, 1, 0;
R_3, 0, 1;
R_4, 0, 1) $

    And our product matrix looks like:
        $ B = mat(, A, B ;
  R_1, 1, 0;
R_2, 0, 1;
R_3, 0, 0;
R_4, 1, 0) $
    We can construct our stoichiometry matrix as:
    $ N = (B-A)^T = mat(, R_1, R_2, R_3, R_4; A, 1, -1, 0, 1; B, 0, 1, -1, -1) $
    Now what about the rates. Our first and second reactions are similar to the previous example, and we can also easily use the mass-action theory to get the other rates, to obtain the rate vector:
    $ v = mat(R_1, k_1; R_2, k_+[A]; R_3, k_2[B]; R_4, k_-[B]) $
    Combining both using the rate equation will result in two differential equations. We get:
    
    $ &(upright(d)[A]) / (upright(d)t) &=& k_1 - k_+[A] + k_-[B] \
    &(upright(d)[B]) / (upright(d)t) &=& k_+[A] - lr()(k_2 + k_-)[B] $
]

In this example, we can see that $A$ contained two production terms and one consumption term, while $B$ contained two consumption terms and only one production term. In the next example, we will get a little closer to a metabolic process. When looking at @loop-system you may be able to imagine $A$ as a molecule outside the cell, and $C$ being the same molecule, but inside the cytosol. $B$ and $D$ could represent ATP and ADP respectively, and we have a very simple model of active transport. The reaction from $D$ to $B$ is a large oversimplification in the case of ADP and ATP, as the regeneration involves multiple steps.

#example[
  #figure(image("figures/Loopsystem.png", width: 35%), caption: [A cyclic reaction system, resembling a simple metabolic cycle.])<loop-system>
  As a final example, observe the following system of reactions:
  $
  &emptyset limits(-->)^(k_1)A \
  &A + B limits(-->)^(k_2)C+D \
  &D limits(-->)^(k_3)B \
  &C limits(-->)^(k_4) emptyset
  $
  This system is also shown in @loop-system. For this system, we can determine the differential equations in the same way as for the previous two systems:
  $
  &(upright(d)[A]) / (upright(d)t) &=& k_1 - k_2[A][B] \
  &(upright(d)[B]) / (upright(d)t) &=& k_3[D] - k_2[A][B] \
  &(upright(d)[C]) / (upright(d)t) &=& k_2[A][B] - k_4[C] \
  &(upright(d)[D]) / (upright(d)t) &=& k_2[A][B] - k_3[D]
  $
]

== Identifying Components of Biochemical ODE Systems

In the previous part, you may have seen repeated elements in these systems of differential equations. Elements that #emph[couple] two of the described molecules, or more formally called #emph[state variables], are called #emph[coupling terms]. Because of these, our systems become complicated to solve, as each state variable could be dependent on many others. Besides the identification of coupling terms, it is important to be able to distinguish production from consumption terms. Observe the system from example 3.3 and shown in @loop-system. When looking at the differential equations, we can see that all of our state variables are coupled by the term $k_2[A][B]$. Furthermore, $[B]$ and $[D]$ are coupled by the term $k_3[D]$. In biochemical systems, these coupling terms contain consumptive and productive counterparts.

Other terms in the system are open-ended, and are either production or consumption terms, such as the constant production of $[A]$, governed by term $k_1$. In this way, each term in the ODE system can be explained. This explainability is important, as a direct link to the underlying chemical or biological process can be made. Using this knowledge, we can perform targeted hypothesis testing by simulating these systems under different conditions. In the next chapter, we will take a look at how to simulate these differential equations.

#pagebreak()
== Exercises
*1. Given is the following system of ordinary differential equations*

$
&frac(upright(d)[a], upright(d)t) &=& k_(a,0) - [a] lr()(k_(a,1) + k_(a,2)[c]) \
&frac(upright(d)[b], upright(d)t) &=& k_(a,1)[a] +  k_(a,2)[a][c] - k_(b,0)[b]\
&frac(upright(d)[c], upright(d)t) &=& k_(b,0)[b] - k_(c,0)[c]
$

For each term, indicate whether this is a production, or a consumption term.

*2. Given the following sequenctial chemical reactions* 

// #set enum(numbering: "a)", indent: 16pt)
// + compute the eccentricity of each vertex. 
// + What is the radius of this graph? 
// + What is the diameter? 
// + Which of the vertices are part of the centre?
$
E + S &limits(chq)_(k_(-1))^(k_1) C_S limits(->)^(k_2) E + P
$

Write down the set of differential equations describing this system. Use mass action kinetics.

*3. Given is the following reaction*
$
A limits(->)^k emptyset
$

With $A(t = 0) = 10.0 "mM"$

*a)* Derive and solve the differential equation of this system and show that the concentration of $A$ over time equals:
$
A(t) = 10.0 e^(-k t)
$

*b)* Give the concentration of $A$ at time $t = 5.0$ for $k = 1$, $k = 5$, and $k = 10$. Explain your results.

*4. Given the following chemical reactions* 

// #set enum(numbering: "a)", indent: 16pt)
// + compute the eccentricity of each vertex. 
// + What is the radius of this graph? 
// + What is the diameter? 
// + Which of the vertices are part of the centre?
$
A &limits(->)^(k_1) B \
B + 2C &limits(chq)_(k_3)^(k_2) D \
D + C &limits(->)^(k_4) 2A \
$

*a)* Write down the set of differential equations describing this system. Use mass action kinetics.

*b)* Derive the units for each of the rate constants, assume time has a unit of $s$ and concentration is in $"mM"$.

= Numerical Solutions of Differential Equations

#quote(attribution: [Tiana (The Princess and the Frog)])[The only way to get what you want in this world is through hard work.]

As soon as we have defined the model for our biochemical system using differential equations, we typically also want to calculate the system behavior over time. In specific cases, it is possible to obtain a solution of your differential equation analytically, but in most models, this is typically not possible. For these models, we turn to so-called numerical methods to obtain the solution to differential equations. 

In this course, numerical methods are treated only very briefly, with a focus on application in Python. While many methods exist, we will only look at the most basic numerical method for solving differential equations. 

== Requirements for Solving an ODE Numerically
To be able to get the solution, we have some settings that we need to specify beforehand, so the numerical method can be used. For solving a differential equation, we will need the _initial conditions_ of all the state variables. Another term often encountered in this field is _Initial Value Problem_ or IVP, which reflect the main idea behind numerical solutions to differential equations. Namely, given a set of initial values, calculate the next value in time. Besides the initial values, we need to specify at what value of time to stop computing the next value in time, because otherwise our numerical method will go on indefinitely. 

== Euler's Method
Now that we have obtained the initial values and the time at which the numerical solution should end, we can start solving the differential equation. Remember, from a previous part of these lecture notes, that a differential equation with known parameters $p$, typically looks like this:
$ (upright(d) y (t))/(upright(d) t) = f (y, t, p) $

So, if we know the value of $y(t)$ for a specific value $t$, we can directly compute the numerical value of the derivative of $y$ at this same value $t$. As stated before, we have the initial value of $y$. Let's for now assume that we start solving at $t=0$, which means that we have the value for $y(t=0)$, and we can compute the value of the derivative, which is
$ (upright(d) y (t=0))/(upright(d) t) = f(y(t=0), 0, p) $. 

The question now is: how can we use this information about the derivative to compute the next value for $y$ in time, say at a time $Delta t$?

What you may remember from your calculus course, is that we can _approximate_ any function $f(x)$ around a value $x=a$, by using a Taylor polynomial. The Taylor polynomial for such a function looks like:

$ f(x) approx f(a) + (x-a) / 1! dot (upright(d) )/(upright(d) t)(f(a)) + (x-a)^2 / 2! dot (upright(d)^2 )/(upright(d) t^2)(f(a)) + dots + (x-a)^n / n! dot (upright(d)^n )/(upright(d) t^n)(f(a)) $

If we cut this off after the first derivative, we get:

$ f(x) approx f(a) + (x-a) / 1! dot (upright(d) )/(upright(d) t)(f(a))  + cal(O)(2) $

We can use this to get an approximation of the value of our differential equation at $t = Delta t$. We can fill this equation in by using $f(x) = y(Delta t)$, and using $a = 0$, and we get:

$ y(t = Delta t) approx y(t = 0) + Delta t dot (upright(d) )/(upright(d) t)(y(t=0))  + cal(O)(2) $

As we know the value for this derivative is given by the original differential equation, we can _approximate_ the value for $y(t = Delta t)$ by:

$ y(t = Delta t) approx y(t = 0) + Delta t dot f(y(t = 0), 0, p) $

However, we are not done yet. As we now have a numerical value for $y (t = Delta t)$, we can compute its derivative using the differential equation, and compute the next time step $y (t = 2 Delta t)$ using the same principles. What we then get is Euler's method. We can make the equation a bit easier to understand as follows:

$ underbrace(y(t + Delta t), "New value of "y "at time "t+Delta t) = overbrace(y(t), "Current value of "y "at time "t) + underbrace(Delta t, "time step") dot overbrace((upright(d) )/(upright(d) t)(y(t)),"Derivative of "y" at time "t ) $<eq-euler>

A visual explanation of Euler's method can be seen in @euler-method. In the next section, we will see how to manually implement Euler's method in Python.

#figure(
  image("figures/eulersmethod.png", width: 30%),
  caption: [Visualization of Euler's method for numerically solving a differential equation. We start at the blue dot and calculate the slope using the differential equation. Given the slope and the blue dot, we can compute the position of the green dot, which is exactly $Delta t$ away from the blue dot. We can then repeat this process starting from the green dot to obtain the purple dot, and so on.]
) <euler-method>

== Implementing Euler's Method in Python
The Python code in this section is also included in the notebook `ode-simulation-with-python.ipynb` that is included in the course.

As seen in the previous section, Euler's method can be regarded as a first-order Taylor polynomial. To compute the next step in time using Euler's method, we need the value of our state variables at time $t$, the time step $Delta t$, and the derivative of our state variables at time $t$. 

Because this derivative is given by our differential equation, we can implement a Python function of our differential equation first. This function takes the current value of $y(t)$, the time $t$, and the parameters of the system $p$, and returns the derivative of the system. For this example, we will use the simple differential equation:
$ upright(d) / (upright(d) t) (y(t)) = -y(t) $

Observe that currently, we have no parameters in our differential equation. The corresponding Python function is:

#figure(caption: "A simple differential equation in Python")[
```python
def dydt(y, t):
  return -y
```]<python-ode-simple>

We can use this function to compute the slope for Euler's method. We start by defining an initial value for $y$ and a time step $Delta t$. 

#figure(caption: "Defining an initial value for $y$ and $Delta t$ for implementing Euler's method.")[
  ```python
  # set the time step and the initial value for y
  delta_t = 0.1
  y_0 = 1.0
  ```
]

We also need to define at which time we need to start, and when we want the algorithm to stop running. Therefore, we define the starting time as $t = 0$ and we solve the differential equation until a time value of $t = 10$. 

#figure(caption: "Defining an initial value for $t$ and the time at which to stop the algorithm")[
  ```python
  # set the time to start and to end
  t = 0
  t_end = 10
  ```
]

We also need to initialize two lists, containing the final solution and the time steps at which the solution has been computed.

#figure(caption: "Initializing the lists of the solution and the corresponding time values, before running the algorithm.")[
  ```python
  # initialize the lists of the solution and the corresponding times
  y = [y_0]
  time_values = [0]
  ```
]

We can now run Euler's method. In this implementation, we use a `while`-loop that looks at the current value for $t$, and stops if it is larger than our set stopping time of $10$. Within the body of the while loop, we take the current value of the solution at time $t$ by taking the last item from the list of the solutions. We use that value and the current value of $t$ to compute the derivative with the function in @python-ode-simple. We then set the new value for $y$ using @eq-euler, and we add the result to the list of $y$ values. We end by incrementing the time value and adding this value to the list of time values. 

#figure(caption: "While-loop solving a differential equation numerically using Euler's method in Python.")[
```python
  while t <= t_end:
    # get the current value of y
    y_current = y[-1]

    # compute the derivative
    derivative = dydt(y_current, t)

    # use euler's method to compute the next value
    y_new = y_current + delta_t * derivative

    # add the next value to the list
    y.append(y_new)

    # increment the time and add it to the saved time values
    t += delta_t
    time_values.append(t)
```]<python-euler-scripted>


== Numerical Error and More Advanced Methods
As you may remember from calculus, the approximation given by Taylor polynomials becomes better for values that lie close to the original value. This means that the error of Euler's method for one time step becomes smaller, as the time step gets closer to zero. However, for longer simulations, this also means that we need to take more steps to eventually get to the final time value that we have specified. We can see the effect of increasing the $Delta t$ value very clearly in @euler-timestep, where we see that for a small time step such as $10^(-3)$, the solution found by Euler's method is very close to the exact solution. For a larger time step of $0.5$, we see that it already deviates quite a bit from the exact solution, especially around the curve between $t = 1$ and $t = 4$. However, increasing the time step even further to $1.5$, we see that the found numerical solution oscillates around to exact solution, which results in a very large error. 

#figure(
  image("figures/euler.png", width: 60%),
  caption: [Running Euler's method with different $Delta t$ values. This figure shows that increasing the $Delta t$, also increases the error made by Euler's method.]
) <euler-timestep>

To improve the numerical solution of differential equations, people have devised methods that give improved estimations with larger time steps, so we can finish simulations faster. Additionally, even more advanced methods use _adaptive time steps_, which means that the time steps are calculated based on the size and the rate of change of the derivative. Another way of improving the forward Euler method, is to not only take into account the previous value of $y$, but also the value before that, or other values of $y$. Methods that use multiple values of $y$ to calculate the next value are called #emph[multistep] methods. The details of these methods are beyond the scope of these lecture notes, but in Python, you will make use of these more advanced methods. 

== Solving Differential Equations Numerically with Python
The Python code in this section is also included in the notebook `ode-simulation-with-python.ipynb` that is included in the course.

In this course, we will use the `odeint`-function in the `scipy.integrate` library. By default, this will use a combination of a multistep method, and a method with adaptive time stepping. For solving simple differential equations like the one we have solved before, `odeint` takes the same type of function as in @python-ode-simple. We can solve this using `odeint` by running the example in @python-odeint-simple below.

#figure(caption: "Solving a differential equation using the `odeint` function from `scipy.integrate`.")[
```python
from scipy.integrate import odeint
import numpy as np # import numpy for linspace

# defining the basic ODE as in the previous example
def dydt(y, t):
  return -y

# create an array of time points to save the solution at
time_steps = np.linspace(0,10,100)

# initial y_value
y_0 = 1

odeint_solution = odeint(dydt, y_0, time_steps)
```]<python-odeint-simple>

=== Solving systems of ODEs
As you have seen in the previous chapter, we typically have a system of multiple ODEs which we need to solve simultaneously. Also in this case, `odeint` works in the same way. For example, we can simulate the following system of ODEs:
$
&frac(upright(d)[X], upright(d)t) &=& -2 dot [X]^2 \
&frac(upright(d)[Y], upright(d)t) &=& [X]^2
$

Now we need to define a function that takes in a list of state-variables containing the current values for $X$ and $Y$, and returns a list of derivatives, containing the derivatives of $X$ and $Y$ in the same order. An example of this function for the system above is shown in @python-system-ode.

#figure(caption: "Defining a system of ODEs in Python.")[
```python
def system_ode(u, t):
  dxdt = -2*u[0]**2
  dydt = u[0]**2
  return [dxdt, dydt]
```]<python-system-ode>

Using this function, we can use the same method as shown in @python-odeint-simple, but of course $u_0$ now needs to be a list of two initial values. 

=== Solving parameterized ODEs
Another common situation is the inclusion of various parameters in differential equation systems. We can also easily include this option using `odeint`. We first need to add some more parameters to our ODE system. Consider the system defined in Python in @python-system-ode-p. This is the well-known predator-prey, or Lotka-Volterra model.

#figure(caption: "Defining a system of ODEs with parameters in Python.")[
```python
def system_ode_p(u, t, a, b, c, d):
  dxdt = a*u[0] - b*u[0]*u[1]
  dydt = c*u[0]*u[1] - d*u[1]
  return [dxdt, dydt]
```]<python-system-ode-p>

To simulate this system for various values of the parameters $a$, $b$, $c$, and $d$, we can use the `args` option of `odeint`, as in @python-system-ode-p-solve, where we solve this system for two sets of values of these parameters.

#figure(caption: "Solving a system of ODEs with different sets of parameters in Python.")[
```python
from scipy.integrate import odeint
import numpy as np

u_0 = [10, 5]
time_points = np.linspace(0,10,100)
a = 0.5
b = 0.4
c = 0.1
d = 0.3

# solve for these parameters
solution_1 = odeint(system_ode_p, u_0, time_points, args=(a,b,c,d))

a = 0.3
d = 0.4

# solve for the modified parameters
solution_2 = odeint(system_ode_p, u_0, time_points, args=(a,b,c,d))
```]<python-system-ode-p-solve>

== Exercises
The exercises of this chapter are included in the `ode-simulation-with-python.ipynb` notebook.

= Biological Signalling and Enzymatic Systems

#quote(attribution: [Rafiki (The Lion King)])[Yes, the past can hurt. But the way I see it, you can either run from it or learn from it.]

In chapter 3, we have observed systems of molecules that are produced and consumed according to mass-action kinetics. In this chapter, we will see that we can use the mass-action formalism to model stimulatory and suppressive signals, as well as systems containing enzymes. However, we will also show some assumptions that can be made to simplify the model. 

We will also dive into systems that cannot be simply written as linear systems of equations, and we will delve into some examples of these systems. Furthermore, some recognizable elements of these dynamic systems are discussed separately. This is especially important when describing a model of two competitive binders, enzyme kinetics, or when we are modeling systems that automatically restore to their original state with the help of feedback loops. This will be heavily illustrated with examples, which also show how these feedback loops can sometimes explain mechanisms of pathology. 

Additionally, some systems become stable if no external input is given, which is called the steady-state. We will discuss this steady-state and so-called model setpoints that specifically determine the steady-state of a system. 

== Signaling Systems
In this section, we will talk about ways to introduce suppressive of stimulatory signals into a model, and illustrate some differences with earlier biochemical models. We will then zoom out of individual signals and inspect models as a whole.

=== Linear Stimulation

The first kind of signalling that we can model is linear stimulation. Observe the reaction
$ A + X limits(-->)^(k_1) B + X $ 
For this reaction, we can see that there is no net consumption of $X$, and we can use mass action kinetics to describe the conversion of $A$ and $B$, which is mediated by $X$ in this case:

$ 
&(upright(d)[A]) / (upright(d)t) = -k[A][X] \
&(upright(d)[B]) / (upright(d)t) = k[A][X] \
&(upright(d)[X]) / (upright(d)t) = 0 \
$

We can see from the equations that in presence of $X$, molecule $A$ is converted into molecule $B$, which is a form of positive interaction. In this form, we assume that the more of $X$ we have, the quicker $A$ is converted into $B$, without a limit. However, when $X$ is not present, we see no conversion. We can also see this in @linear-stimulation-1, which shows that with increasing value of our stimulatory agent $[X]$, the rate of conversion of $A$ into $B$ increases, but without $X$, we see no conversion happening. 

Another way to write this conversion is to define the rate of the reaction as a function of $[X]$, which we can write as:
$ A limits(-->)^(K([X])) B $<eq-signal-fun>

with

$ K([X]) = k[X] $

#figure(image("figures/linear_stimulation.png", width: 70%), caption: [Simulation of a linear stimulation model where $A$ is converted into $B$ using a stimulatory agent $X$. The colors indicate the concentrations of this stimulatory agent.])<linear-stimulation-1>

A method to extend this model is to add the possibility for $A$ to spontaneously convert into $B$ without the interaction with $X$. We can do this by adding the reaction:
$ A limits(-->)^(k_"sp") B $ 
Combining both into a system of differential equations will result in:
$
&(upright(d)[A]) / (upright(d)t) = -lr()(k[X] + k_"sp")[A] \
&(upright(d)[B]) / (upright(d)t) = lr()(k[X] + k_"sp")[A] \
&(upright(d)[X]) / (upright(d)t) = 0 \
$

In this model, we can see that the rate of conversion from $A$ to $B$ is subject to a basal rate $k_"sp"$ and increases linearly with the concentration of $X$. 

Similarly to the first example, the chemical reaction here can also be written as in @eq-signal-fun, but with $k([X])$ defined as:

$ K([X]) = k[X] + k_"sp" $

=== Linear Suppression<linsup>

Besides stimulation, we can also model suppression in a similar way. The simplest form of suppression can be achieved by using the formulation as in @eq-signal-fun, and defining the rate as:

$ K([X]) = 1 / (k[X] + k_"sp") $

In this way, as soon as $[X]$ increases, the overall rate decreases. We also need the extra term in the denominator, because otherwise, the reaction rate would go to infinity as soon as $[X]$ approached a value of $0$.

However, we can also be a bit more creative in modelling suppression, but we will need some more tools to do so. Another way to model suppression is that we have a reaction where an active form of molecule $A$ is converted into molecule $B$:
$ A_"act" limits(-->)^k B $
Additionally, we introduce a suppressive agent $Y$, which blocks this conversion. This can be modelled by a reaction, mediated by $Y$, that converts our active form of $A$ into an inactive form:
$ A_"act" + Y limits(-->)^(k_i) A_"inact" + Y $
We now still miss one key component in this model. We want this suppression to be reversible, meaning that as soon as $Y$ disappears, we need the conversion of $A$ into $B$ to occur again. Therefore, we can add a reaction where $A_"inact"}$ converts into $A_"act"}$:
$ A_"inact" limits(-->)^(k_a) A_"act" $
Combining these three reactions into a system of differential equations can once again be done using mass-action kinetics:
$
&(upright(d)[A_"act"]) / (upright(d)t) &=& -lr()(k+k_i [Y])[A_"act"] + k_a [A_"inact"] \
&(upright(d)[A_"inact"]) / (upright(d)t) &=& k_i [Y] [A_"act"] - k_a [A_"inact"] \
&(upright(d)[B]) / (upright(d)t) &=& k[A_"act"] \ 
&(upright(d)[Y]) / (upright(d)t) &=& 0 
$<linsup-eq>

Observe that we have added an additional equation that specifies that the concentration of $A$ equals the sum of active and inactive substrate. A simulation of this system for different values of our suppressant $Y$ can be seen in @linear-suppression. If we increase the level of suppressant, we see that the proportion of $A$ being converted into $B$ decreases. 

#figure(image("figures/linear_suppression.png",width: 100%), caption: [Simulation of a linear suppression model with suppressant $Y$. The colors indicate the concentration of this suppressant.])<linear-suppression>

=== Enzyme Kinetics

A special case of stimulation or suppression can be seen in enzyme catalysis. In your biochemistry course, you will have seen Michaelis-Menten kinetics. For completeness, the derivation of this type of kinetic model is given here, but the most important consideration is that you realize the assumption it makes and what the kinetic equation looks like, so you can recognize it in future models. We will first start with the derivation of the kinetic law using a stimulatory enzyme.

An enzymatic reaction can be summarized as:
$ E + S limits(<-->)^(k_1)_(k_(-1)) C limits(-->)^(k_2) E + P $

In this reaction, an enzyme $E$ and a substrate $S$ form a complex $C$, which can also fall back apart. However, if the catalysis succeeds, the enzyme is released and a product $P$ is formed. Using mass-action kinetics from the previous sections, we can create a differential equation model for this system:

$ 
&ddt([S]) &=& k_(-1)[C] - k_1 [E][S] \
&ddt([E]) &=& (k_(-1)+k_2)[C] - k_1[E][S] \
&ddt([C]) &=& k_1[E][S] - (k_(-1)+k_2)[C] \
&ddt([P]) &=& k_2[C] 
$

The main assumption for Michaelis-Menten kinetics, is that the total conversion from substrate into product is mainly determined by the formation of the complex $C$. The consequence of this assumption, is that the amount of complex in the system rapidly reaches an equilibrium, which results mathematically into the relationship:
$ ddt([C]) = 0 $

Using this assumption, we can write:
$ k_1[E][S] = k_(-1)+k_2[C] $<michmentresult>

Furthermore, the second assumption is that the total amount of enzyme in the system doesn't change. The total amount of enzyme can then be formulated as the sum of the amount of free enzyme $[E]$ and the amount of complex $[C]$. We can call this concentration $E_0$:
$ E_0 = [E] + [C] $

Replacing $[E]$ in @michmentresult with $E_0 - [C]$ gives us:
$ k_1E_0[S] = (k_(-1)+k_2 + k_1[S])[C] $

From which we can derive the following formula for $[C]$:
$ [C] = (k_1E_0[S]) / (k_(-1)+k_2 + k_1[S]) $

Dividing both numerator and denominator by $k_1$ and defining $K_M = (k_(-1)+k_2) / (k_1)$ we get:
$ [C] = (E_0 [S]) / (K_M + [S]) $

Filling this in into the function for the product formation, and defining 
$ V_"max" = k_2E_0 $<v-max-eq>
we get:
$ ddt([P]) = V_"max" [S] / (K_M + [S]) $<michmentequation>

The rate in @michmentequation is what we define as Michaelis-Menten kinetics. The behavior of this type of kinetics can be observed in @michaelis-menten-a, which shows the reaction rate as a function of the substrate concentration for different values of $K_M$. You can see that for increasing substrate concentration, the reaction rate approaches $V_"max"$. In @michaelis-menten-b you can see the product concentration over time from a simulation of the Michaelis-Menten conversion. This conversion is also compared to the linear mass-action conversion in this figure. The effect of $K_M$ is also clearly visible in both figures. 

#subpar.grid(
  figure(image("figures/michaelis_menten_rates.png", width: 60%), caption: ""), <michaelis-menten-a>,
  figure(image("figures/michaelis_menten_ode.png", width: 60%), caption: ""), <michaelis-menten-b>,
  columns: (1fr, 1fr),
  caption: [Simulation of Michaelis-Menten kinetics for various values of $K_M$. *(a)* The reaction rate according to Michaelis-Menten kinetics as a function of the substrate concentration, compared to the value of $V_"max"$. *(b)* Simulation of product formation according to Michaelis-Menten kinetics.],
  label: <michaelis-menten>,
)

=== Advanced Enzyme Kinetics: Reversible Inhibition
Sometimes, an enzymatic reaction can occur in presence of an inhibitor $I$. As discussed in earlier courses, reversible inhibition can take three forms. We have competitive inhibition, non-competitive inhibition and uncompetitive inhibition (see also @fig-inhibition). These three forms also have distinct kinetic rates that we can derive. Their derivations are beyond the scope of these lecture notes, but their resulting equations can be readily explained from the mechanisms of each type of inhibition.

#figure(image("figures/inhibition.png"), caption: [Forms of reversible inhibition. With competitive inhibition, the inhibitor binds to the active site of the substrate, preventing the formation of an active complex. In non-competitive inhibition, the inhibitor binds to an allosteric site, reducing or blocking the catalytic activity of the enzyme. In uncompetitive inhibition, the inhibitor can only bind to an allosteric site of the enzyme-substrate complex.])<fig-inhibition>

==== Competitive Inhibition
Competitive inhibition can be represented in chemical reactions as
$
E + S &limits(<-->)_(k_(-1))^(k_1) C limits(-->)^(k_2) P \
E + I &limits(<-->)^(k_i)_(k_(-i)) C_I
$
Where we have a normal complex $C$ and a substrate-inhibitor complex $C_I$. The rate law for competitive inhibition with an inhibitor $I$ is given by:
$
v = (V_"max" [S]) / (K_M^"app" + [S])
$
With $ K_M^"app" = K_M lr()(1 + [I] / K_i) $

The result of this competitive inhibition on the reaction rates can be seen from the equation. As we increase the inhibitor concentration $[I]$, we see that apparent Michaelis-Menten constant ($K_M^"app"$) increases, meaning that we will need more substrate to reach our $V_"max"$, (also see @michaelis-menten) but we will still be able to reach this maximum reaction rate. This effect can be explained as the presence of this inhibitor decreases the enzyme affinity for the substrate. Many drugs act as competitive inhibitors, as they are designed to resemble the substrate and therefore bind to or block the active site of specific enzymes. 

==== Non-competitive Inhibition
The second type of inhibition is non-competitive inhibition, which can be formulated as 
$
E + S &limits(chq)_(k_(-1))^(k_1) C_S limits(->)^(k_2) E + P \
E + I + S &limits(chq)^(k_i)_(k_(-i)) C_I + S limits(chq)^(k_("i2"))_(k_(-"i2")) C_"IS" limits(chq)^(k_("i3"))_(k_(-"i3")) C_S + I

$

This reaction system shows that our inhibitor can bind and unbind from every step of the catalytic process. For a non-competitive inhibitor, we will see that instead of increasing $K_M$, we decrease $V_"max"$ with the rate law:

$
v = (V_"max"^"app" [S]) / (K_M + [S])
$
With 
$ V_"max"^"app" = (V_"max") / (1 + [I] / K_i) $

As the binding of a non-competitive inhibitor reduces the activity of the enzyme without changing the enzyme's affinity for the substrate, the $V_"max"$ is decreased. Examples of non-competitive inhibition include the binding of Glucose-6-Phosphate to hexokinase in the brain, slowing the rate of cerebral glucose uptake. 

==== Uncompetitive Inhibition
The final type of inhibition is called uncompetitive inhibition, which changes both $V_"max"$ and $K_M$. We can formulate this inhibition as:
$
&E + S &limits(chq)^(k_1)_(k_(-1))& C_S limits(->)^(k_2) E + P \
&C_S + I &limits(chq)^(k_i)_(k_(-i))& C_"IS"
$

We can see that the inhibitor can only bind to the enzyme-substrate complex. This type of inhibition is very rare, but does occur. The rate law for this type of inhibition is given by:
$
v = (V_"max"^"app"[S]) / (K_M^"app" + [S])
$
With 
$ V_"max"^"app" = (V_"max") / (1 + [I] / K_i) $
and
$ K_M^"app" = K_M  / (1 + [I] / K_i) $

Contrarily to competitive inhibition, the $K_M$ decreases with increasing inhibitor concentration, while $V_"max"$ decreases, similarly to non-competitive inhibition. One of the main features of this type of inhibition is that its effect is largest at high substrate concentrations. 

=== Cooperative Binding: Hill Kinetics
The production rate of the product $P$ described by Michaelis–Menten kinetics, is a hyperbolic function of the substrate concentration $[S]$. However, in many cases, measuring the reaction rate as function of the substrate concentration leads to different behavior. One reason may be cooperative binding of the substrate to the enzyme. Cooperative binding means that the binding of one substrate molecule has influence on the binding of subsequent substrate molecules to the enzyme (possibly, with several active sites). The cooperativity is positive if the binding of a first substrate molecule increases the affinity of other active sites of the enzyme for substrate molecules, and negative if this binding decreases the affinity of other active sites. The effective rate of a reaction with such a cooperative effects is often described by an equation similar to the Michaelis-Menten rate equation:

$ ddt([P]) = V_"max" [S]^n / ((K_M)^n + [S]^n) $<hill-equation>

The difference is that we have introduced an additional term $n$, in the exponent of every term in the fraction. This type of kinetics is called #emph[Hill kinetics], and @hill-equation is called the #emph[Hill equation]. 

For $n=1$, this equation is equal to the Michaelis-Menten kinetics. This value $n$ is linked to the cooperativity of the reaction. A value of $n$ in between 0 and 1 indicates a negative cooperativity, while a value for $n > 1$ indicates positive cooperativity.

#subpar.grid(
  figure(image("figures/hill_rates.png", width: 60%), caption: ""), <hill-a>,
  figure(image("figures/hill_ode.png", width: 60%), caption: ""), <hill-b>,
  columns: (1fr, 1fr),
  caption: [Simulation of Hill kinetics for various values of $n$. *(a)* The reaction rate according to Hill kinetics as a function of the substrate concentration, compared to the value of $V_"max"$. *(b)* Simulation of product formation according to Hill kinetics.],
  label: <hill>,
)

=== Feedback Loops
Combining these regulatory mechanisms that are present in models of biological systems often leads to feedback loops appearing. A feedback loop is a specific regulatory pattern that dictates how components of a system interact over time. They are an important component of many biological systems and are required for a system to return to its original state after an external influence, or cause repetitive behavior to occur. 

We can identify positive and negative feedback loops. A positive feedback loop occurs when the endpoint of a series of reactions promotes the starting point of this same series, causing the complete set of reactions to become increasingly active over time. When the endpoint blocks the starting point of this series, we call this negative feedback, which is necessary for a system to return to its original state. 

Combinations of positive and negative dictate our bodily processes, and a disturbance in the balance of these loops can lead to diseases. Examples include stress-related diseases or diabetes. When analyzing a biological system, it often helps to outline the positive and negative feedback loops in the system to get an understanding of the interacting processes.

// TODO: Illustration?

=== Modelling Example: The Cell Cycle
In this part, we'll be looking at an example model, explaining the components using the modelling tools we have explored up to this point. The following model is a heavily simplified model of the cell cycle published in 1991 by Goldbeter @Goldbeter1991. In this model, cyclin ($bold(C)$) is modelled to induce the production of a cyclin kinase $(bold(M))$, which in turn activates the production of a cyclin protease $(bold(X))$. This protease then stimulates the degradation of the original cyclin. An illustration of the model and its interactions is given in @fig-goldbeter. 

#figure(image("figures/goldbeter.png", width: 50%), caption: [Illustration of the components and their interactions in the Goldbeter model \cite{Goldbeter1991} of the cell cycle. The figure shows interactions between cyclin (C), cyclin kinase (M) and cyclin protease (X). Arrows indicate positive interactions and bars indicate suppressions. Parameter names are given for all interactions.])<fig-goldbeter>

The model is mathematically formulated as:

$
&ddt(bold(C)) &=& v_i - v_d bold(X) bold(C) / (K_d + bold(C)) - k_d bold(C) \ 
&ddt(bold(M)) &=& V_1 bold(C) / (K_c + bold(C)) (1 - bold(M)) / (K_1 + 1 - bold(M)) - V_2 bold(M) / (K_2 + bold(M)) \
&ddt(bold(X)) &=& V_3 bold(M) (1 - bold(X)) / (K_3 + 1 - bold(X)) - V_4 bold(X) / (K_4 + bold(X))
$

We can see that the model contains six examples of Michaelis-Menten kinetics. The equations for cyclin kinase and cyclin protease ($bold(M)$ and $bold(X)$) are structurally similar. We will first look at cyclin ($bold(C)$). The base of this equation is the constant production and removal term, according to mass action kinetics, and based upon the chemical formulation:
$ ->^(v_i) C ->^(k_d) $

We then see that the additional term represents a catalytic consumption of cyclin by cyclin protease, yielding an unmodelled product. As the enzyme concentration ($bold(X)$) varies throughout the simulation, the previously constant term $V_"max"$ is replaced by $v_d bold(X)$, using the original definition of $V_"max"$ (see @v-max-eq).

Cyclin kinase ($bold(M)$) production is then stimulated by cyclin using a Michaelis-Menten factor in the first term of the second reaction. The term after this factor represents Michaelis-Menten kinetics of a cyclin kinase progenitor, where the total concentration of cyclin kinase and its progenitor is normalized to the constant value of 1. We can then describe the progenitor concentration as $1-bold(M)$. The second term describes the consumption of cyclin kinase by an unmodelled enzyme with constant concentration using Michaelis-Menten kinetics. 

The equations of cyclin protease ($bold(X)$) have the same structure as cyclin kinase, where its production is stimulated by cyclin kinase, and is consumed using Michaelis-Menten kinetics, driven by an unmodeled enzyme with constant concentration.

#figure(image("figures/goldbeter_ode.png", width: 50%), caption: [Simulation of the Goldbeter model. We can clearly see the oscillatory behavior that the model produces.])<goldbeter-ode>

When simulating this model, we find that it shows oscillations in all three state variables (see @goldbeter-ode). This behavior is a result of the negative feedback loops present in the system. The system is kept running through the parameters $v_i$ and $k_d$, which provide a constant production and consumption of $bold(C)$. Then $bold(C)$ stimulates $bold(M)$, which is suppressed by $bold(M)$. Then, $bold(M)$ stimulates $bold(X)$, which is suppressed by $bold(X)$. Finally, $bold(X)$ suppresses $bold(C)$ by stimulating an additional consumption term, allowing for a restart of the cycle. 

== Steady-States, Setpoints, and Perturbations

Besides the simulation, we may often be interested in other model properties that we can calculate. An important property of dynamic models is the steady state. When we have a dynamic model defined by:
$ 
ddt(x) = f(x)
$

The steady state is given by $f(x) = 0$, which means that our state variable does not change over time anymore. We can, for example, compute the steady-state for the model from @linsup-eq.

#example[
  The system represents a linear suppression model with the equations:
  $
&(upright(d)[A_"act"]) / (upright(d)t) &=& -lr()(k+k_i [Y])[A_"act"] + k_a [A_"inact"] \
&(upright(d)[A_"inact"]) / (upright(d)t) &=& k_i [Y] [A_"act"] - k_a [A_"inact"] \
&(upright(d)[B]) / (upright(d)t) &=& k[A_"act"] \ 
&(upright(d)[Y]) / (upright(d)t) &=& 0 
$

    From our first analysis, we see that $Y$ is \emph{always} in steady state, as its derivative is set to zero. To compute the steady-state for the entire system, we find that $B$ is only in steady-state whenever $[A_"act"]$ is zero. Using this fact, we can express the steady state of $A_"act"$ as
    $ ddt([A_"act"]) = underbrace(-lr()(k + k_i [Y]) [A_"act"], = 0text(", since ") [A_"act"] = 0) + k_a [A_"act"] = k_a [A_"inact"] = 0 $
    From this we conclude that in steady-state $[A_"inact"] = 0$ as well. Filling this in, we also see that no further conditions are necessary to make sure $[A_"inact"]$ is also in steady state. 
]

Systems can also have #emph[multiple] steady-states. A system with two steady-states is also called #emph[bistable]. In biological systems, this property of bistability is important in understanding specific disease mechanisms. 
#figure(image("figures/bistable.png", width: 50%), caption: [The steady-states in a bistable system.])<fig-bistable>

Bistability can be caused by a positive feedback loop where one regulatory step is very sensitive. An example is the following equation.
$ ddt(y) = p + y^5 / (1 + y^5) $

In this system, we can also recognize a Hill-kinetics rate equation. The steady states of this system depending on parameter value $p$ are shown in @fig-bistable. The point where the steady-state splits based on initial condition is called a #emph[bifurcation point], as over there, the steady-state splits into two possibilities based on the initial condition. 

A different property of a system is called a setpoint. In control systems, a setpoint is the target value of a specific variable in the entire dynamic system. Setpoints are often used when modeling biological systems that typically return to a specific steady state, such as glucose, which typically has a fasting value of around 5 mmol/L. In modeling, we then use a setpoint to force the system into steady state as soon as this is the case. An example can be seen in a simple glucose model.

#example[
  The Bergman glucose minimal model @Bergman2021 can be formulated as:
  $ 
  &ddt(G) &=& -k_1 G X - k_3 lr() (G - G_b) + "Ra"(t) \ 
  &ddt(X) &=& -X + k_2 (I(t) - I_b)
  $
    This model describes the basic regulation of glucose by insulin. The components of insulin ($I(t)$) and glucose input ($"Ra"(t)$) are described as external inputs to the model, so they must be known to describe the whole system.
    
    When investigating this system, we see that the following conditions need to be met for the system to be in steady state:

      - $X = 0$
      - $I(t) = I_b$
      - $G = G_b$
      - $"Ra"(t) = 0$

    The model contains two setpoints; we have $I_b$, which is the setpoint of the insulin concentration, and $G_b$, which is the setpoint of the glucose concentration.
] 

In some model applications, we also want to provide external inputs. In the above example, we have $"Ra"(t)$ representing the external glucose input. This external input is what we call a #emph[perturbation]. In some cases, perturbations can help us understand how models change from their normal steady state to an alternative steady state. To investigate these properties, we need simulations of model behavior, trying out various perturbation sizes and durations. 

== Measurements
To build a model, we often don't rely solely on knowledge of a specific system. Additionally, measurements from experiments can be used to create or validate a model. In this section, we will introduce various types of experiments and measurements that can be used in conjunction with building or using a computer model. 

Fundamental reaction information can be measured by recreating the situation _in vitro_ and measuring the reaction rates for different values of substrate, as well as possibly varying the environment. However, some processes cannot easily be translated from _in vitro_ experiments to _in vivo_ processes. Furthermore, some conditions may be very difficult to simulate in a test tube, such as obesity or liver disease. To perform measurements of biological systems, model organisms can be used to recreate _in vivo_ conditions. For modelling metabolic systems, mouse models are frequently used, but measurements of humans in clinical trials are also common.

The specific type of measurements that can be used also influence the way models are structured. In many _in vivo_ conditions, the state variables are often difficult to measure directly, and require additional processes to get an (indirect) measurement, such as fluorescence. These additional processes then also need to be taken into account in the model that is built. In other cases, we may be limited by the amount of detailed measurements we can do, which directly limits the amount of detail we can put in our model. 

A special type of measurements is done using #emph[tracers]. These are molecules that have a radioactive or stable isotope attached to them, that can be measured afterwards. An example of the use of stable isotope tracers is the large Dalla-Man meal simulation model @DallaMan2007, which enabled the measurement of specific subprocesses of glucose metabolism.

=== Parameter Estimation
When we have measurements, we also need to couple them to model parameters. If we have _in vitro_ kinetic measurements, we can directly derive the kinetic parameters, for example using a Lineweaver-Burk plot for Michaelis-Menten kinetics. However, a common way to obtain the model parameters from measurements of the state variables is through parameter estimation. This procedure is beyond the scope of these lecture notes, but the general idea is that you use mathematical optimization techniques, as also used in machine learning, to select parameter values that minimize the difference between the observed state variables and the simulated state variables from the model.

== Exercises 

#text(fill: red, "The exercises of this chapter are not ready yet. They will be on the next update!")

= Whole-Body Models

#quote(attribution: [Woody (Toy Story)])[To infinity and beyond!]

#text(fill: red, "This chapter is not ready yet. But it will be on the next update!")
// In this book chapter, we will explore a somewhat different application of modeling with differential equations. Instead of focusing on biological processes that occur to natural stimuli, we are now turning to models of how our bodies deal with drugs. This can be divided into two areas of research: pharmacokinetics and pharmacodynamics. The first deals with how the concentrations of drugs in our body change over time after various types of administration and dosing, while the latter involves the study of the biochemical effects of drugs. In short, pharmacokinetics studies what the body does to drugs, while pharmacodynamics focuses on what drugs do to the body. We will be discussing pharmacokinetics, as the components involved in modeling these systems resembles how we approached biological system modeling. Pharmacodynamics however, also requires an understanding of the specific chemical reactions that occur between a drug within the human body, which is beyond the scope of these lecture notes.

// The main principle in pharmacokinetics revolves around the determination of the absorption, distribution, metabolism, and excretion (ADME) of drugs following administration. Applications of this range from determining the dose-response curve of different drugs, and in different physiological and pathological conditions, to determining optimal personalized drug doses. 

// But instead of directly turning to the components of pharmacokinetics, we will first introduce a few basic concepts that are essential to grasp before diving into the details. When administering or prescribing drugs, the main goal is that they are effective, which means that the amount of drug inside someone's system should reach a level where it can be effective. However, it cannot exceed the concentration required to achieve toxicity. Additionally, we may want to minimize the dosage initially, so we will be able to increase it without coming too close to a toxic dose. To be able to produce solutions to these problems, models can be made of the behavior of drugs inside the body. In this section, we will explore modelling concepts that are necessary for building and understanding these models.

// == Compartmental Models
// To describe the distribution of drugs after administration, compartments are used in pharmacokinetics. A compartmental model is also often used in epidemiology, for example to describe disease spread over a population. @Brauer2008 Within a compartment, we assume that we have an instant homogeneous distribution of substrate. The quantity of substrate ($q_i$) within a compartment $i$, can be described according to:
// $ ddt(q_i) = "input"(bold(q), t) - "output"(bold(q), t) $<compartment>

// Where $bold(q)$ is the vector of all masses in all compartments in the system. As opposed to earlier models, observe that in this case, the differential equation describes substrate #emph[quantity] instead of substrate #emph[concentration]. To convert the differential equation to substrate concentration, we will need to divide the quantity by the #emph[volume of distribution] ($V_d$) of the substrate in the compartment. This is not an actual volume but it is the amount of blood that would be required if the drug was evenly distributed over the body at the concentration of the collected sample. As we assume this volume is kept constant, we can freely divide $q_i$ by $V_d$ within @compartment.

// === One-Compartment Model
// The one-compartment model is the simplest compartmental model in pharmacokinetics. As the name implies, it contains a single volume which contains the species or drug of interest. The one-compartment model is effective in describing drugs that are administered intravenously and remain in specific organs that have a high blood perfusion. This compartment typically combines the heart, liver, kidneys and the blood plasma into one #emph[central compartment], as seen in @one-compartment-model. 

// #figure(image("figures/one-compartment-model.png", width: 40%), caption: [One-compartment model with a central compartment containing the drug, and a single elimination term.])<one-compartment-model>

// For an IV bolus administration of a dose $D$ at $t = 0$, the one-compartment model equation is given as:
// $ ddt(q(t)) = - k_q q(t) $
// Where $q(0) = D$.

// We can solve this differential equation easily by writing
// $ integral (upright(d)q) / q = -k dot integral upright(d)t $ 
// Which results in
// $ ln(q(t)) = ln(D) - k t \ 
//  => q(t) = D e^(-k dot t) $

//  An important characteristic for a drug is the elimination half-life, which is defined as the time it takes for the drug amount to become half of its initial concentration. As $V_d$ is constant, half the concentration means half the amount of drug delivered, so we can derive a formula for this using
//  $ q(t_(1 slash 2)) &= D e^(-k dot t_(1 slash 2)) = D/2 \
//  &=> k dot t_(1 slash 2) = ln(2) \
//  &=> t_(1 slash 2) = ln(2)/k $

// To test whether a drug concentration after IV bolus injection can be modelled using a one-compartment model, we can plot the log-concentration value over time and inspect whether it has a linear slope. If the points at the low and high concentration values deviate from a linear slope, this may be reason to suspect that more compartments are necessary. However, this can also occur when the measuring equipment has a lower accuracy in specific low or high concentrations, or when the measurement device nears its limit of detection, which is the lowest concentration of drug that the test can measure.

// === Two-Compartment Model
// The most commonly used pharamcokinetic compartmental model is the two-compartment model. As the name indicates, this model contains two volumes where the drug can reside in. As in the one-compartment model, this model contains the central compartment, but it also contains a #emph[peripheral compartment]. While the compartments in this model have no direct physiological meaning, a reasonable assumption is to think of the central compartment as the highly-perfused tissues, where the drug administered spreads rapidly, while the peripheral compartment represents the tissues with a lower perfusion rate, such as the bone or the adipose tissue. 

// #figure(image("figures/two-compartment-model.png", width: 40%), caption: [Two-compartment model with a central and a peripheral compartment containing the drug, which have exchange terms and the central compartment has an elimination term.])<two-compartment-model>

// For an IV-bolus, the ODE system of the two-compartment model is
// $ 
// &ddt(q_1(t)) = -(k_0 + k_1) q_1(t) + k_2 q_2(t) \ 
// &ddt(q_2(t)) = k_1 q_1(t) - k_2 q_2(t)
// $

// The solution of this model is more difficult, and requires the Laplace transform, which is beyond the scope of these lecture notes. Nevertheless, the solution for the central compartment is given by

// $ q_1(t) = C_1 e^(-alpha t) + C_2 e^(-beta t) $

// The constants $C_1$, $C_2$, $alpha$ and $beta$ are not in the original model equations, but can be calculated from them. $alpha$ and $beta$ are known as the #emph[macro]-rate constants. The four constants are related to the original model parameters as
// $ 
// alpha + beta = k_0 + k_1 + k_2 \
// alpha dot beta = k_2 dot k_0 \
// C_1 = (D_0 (alpha - k_2)) / (alpha - beta) \
// C_2 = (D_0 (k_2 - beta)) / (alpha - beta)
// $
// Where $D_0$ is the initial bolus IV dose. 

// From the equations, one can see that the drug clearance essentially has two phases. We have the fast-phase, which is controlled by $C_1$ and $alpha$, and the slow phase, controlled by $C_2$ and $beta$. Each of these phases also has their own half-life, which are named the distribution and elimination half-life respectively:

// $ t_(1 slash 2, alpha) = ln(2)/alpha \
// t_(1 slash 2, beta) = ln(2)/beta $

// The reported half life of a drug adhering to two-compartmental kinetics is often only one value, which corresponds to the slowest of the two. 

// // TODO: Add figures

// === Physiologically-Based Pharmacokinetic Models
// In traditional pharmacokinetic models, mainly one and two-compartment models are used, with some models containing more compartments, for example when a specific tissue of interest is modelled separately. However, when more detailed information is desired, we can turn to so-called _Physiologically-based pharmacokinetic_ (PBPK) models. These models contain separate compartments for many tissues in the body, and separate arterial and venous blood as compartments. @4cpbpk shows a four-compartment PBPK model. Each of these compartments has its own rate equations, describing the blood flow through a tissue and the metabolism happening. 

// #figure(image("figures/4-comp-pbpk.png", width: 50%), caption: [A four-compartment PBPK model, showing various routes of administration, such as through inhalation, IV, or oral.])<4cpbpk>

// The general form of a rate equation for a molecule $A$ in compartment $x$ PBPK model is

// $ ddt(A_x) = Q_x dot (A_"art" - A_x slash P_x - M_x (A_x)) / (V_x) $

// Where $A_"art"$ is the concentration in the arterial blood, $Q_x$ is the blood flow through compartment $x$, $V_x$ is the volume of the compartment $x$ and $P_x$ is called the partition coefficient for compartment $x$, which describes how long a molecule remains in a specific compartment. A low partition coefficient means that a molecule disappears quickly from a tissue, while a high partition coefficient indicates that a molecule remains in a tissue for a longer time. Finally, $M_x (A)$ is the metabolism rate of molecule $A$ in the specific compartment. This metabolism can for example be described using michaelis-menten kinetics, while taking into account the volume and partition coefficient of the specific organ:

// $ M_x (A_x) = V_"max" (A_x slash P_x) / (K_m  + A_x slash P_x) $

// == Modeling Delays

// == Administration Routes
// Besides compartments that describe the concentrations over time within the body, different routes of administration may also lead to variations in appearance profiles of the drugs. For example, if a drug is administered intravenously, the full dose ends up in the blood stream, while an orally dosed drug may not be fully absorbed by the gastrointestinal tract, leading to a lower absorbed dose. To ensure correct dosage and to prevent toxicity, an accurate representation of drug appearance for different administration routes is critical. In this section, we'll explore the modelling of these routes of administration. 

// == Outcome Measures

// == Examples

// == Exercises

#bibliography("bib-refs.bib")