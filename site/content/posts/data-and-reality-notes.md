---
title: "Data and Reality Notes"
date: 2022-10-11T21:59:50+07:00
draft: false
toc: true
images:
categories:
tags:
  - reading-notes
  - data-and-reality
---

I wanted to have my own words about the book, but apparently, the passages
within the section "About" of the book is more intriguing.

> [...], this little classic addresses timeless questions about how we as human
> beings perceive and process information about the world we operate in, and how
> we struggle to impose that view on our data processing maschines.

> You can read this book for:
> - insights into the basis of computer data processing. [...]
> - [...] the way we perceive reality, and the
> - constructs and tactics we use to cope with complexity, ambiguity, incomplete
>   information, mismatched viewpoints, and conflicting objectives.

The book's "Preface" is also interesting:

> People are awed by the sophistication and complexity of computers, and tend to
> assume that such things are beyond their comprehension. But that view is
> entirely backwards! The thing that makes computers so hard to deal with is not
> their complexity, but their utter simplicity. [...]
 
> The art of computer programming is somewhat like the art of getting an
> imbecile to play bridge or to fill out his tax returns by himself. [...]
 
> The first step toward understanding computers is an appreciation of their
> simplicity, not their complexity. [...]

## 1. Entities

> "Entities are a state of mind. No two people agree on what the real world view
> is." [Metaxides]

> An information system (e.g., database) is a model of a small, finite subset of
> the real world. (More or less --- we'll come back to that later)
> We expect certain correspondences between constructs inside the information
> system and the world. [...]
>
> So, one of the first concepts we have is a correspondence between things
> inside the information system and things in the real world. Ideally, this
> would be a one-to-one correspondence, i.e., we could identify a single
> construct in the information system which represented a single thing in the
> real world.
>
> Even these simple expectations run into trouble. In the first place, it's not
> so easy to pin down what construct in the information system will do the
> representing. [...] For now, let's just call that thing a *representative*,
> and come back to that topic later.
>
> [...] Before we go charging off to design or use a data structure, let's think
> about the information we want to represent. Do we have a very clear idea of
> what that information is like? Do we have a good grasp of the semantic
> problems involved?
>
> The information in the system is part of a communication process among people.
> There is a flow of ideas from mind to mind; there are translations along the
> way, from concept to natural languages to formal languages (constructs in the
> machine system) and back again. [...]
>
> The resemblance between the extracted ideas and the ideas in the original
> observer's mind does not depend only on the accuracy with which the messages
> are recorded and transmitted. It also depends heavily on the participants'
> common understanding of the elementary references [...].

### 1.1 One Thing

> What is "one thing"?
>
> [...] The question illustrates how deeply ambiguity and misunderstanding are
> ingrained in the way we think and talk.
>
> [...] We are dealing with a natural ambiguity of words, which we as human
> beings resolve in a largely automatic and unconscious way, because we
> understand the context in which the words are being used.
>
> [...] There are a few basic concepts we have to deal with here:
>
> - Oneness.
> - Sameness. When do we say two things are the same, or the same thing? How
>   does change affect identity?
> - What is it? In what category do we perceive the thing to be? What categories
>   do we acknowledge? How well defined are they?

I have recently read a Clojure book that dived deep into naming with this
interesting idea: a name can be "natural", or "synthetic" ("artificial" or
"man-made" are probably good synonyms). "Natural" names are easy to understand,
but unavoidably ambiguous. "Synthetic" names are hard to understand, but oftenly
unambiguous. To answer "What is this one thing", do the naming thoroughly. Pick
the right poison for the problem.

> [...], the boundaries and extent of "one thing" can be very arbitrarily
> established. This is even more so when we perform "classification" in an area
> that has no natural sharp boundaries at all.
>
> [...]
>
> This classification problem underlies the general ambiguity of words. The set
> of concepts we try to communicate about is infinite (and non-denumerable in
> the most mind-boggling sense), whereas we communicate using an essentially
> finite set of words. [...] Thus, a word does not correspond to a single
> concept, but to a cluster of more or less related concepts. Very often, the
> use of a word to denote two different ideas in this cluster can get us into
> trouble.

### 1.2 How Many Things Is It?

> A single physical unit often functions in several roles, each of which is to
> be represented as a separate thing in the information system.
>
> [...]
>
> The perceptive reader will have noticed that two kinds of "how many" questions
> have been intermixed in this section. At first we were exploring how many
> *kinds* of things something might be perceived to be. But occasionally we were
> trying to determine whether we were dealing with one or several things of a
> given kind.

Or:

- One entity, many groups; versus
- One group, many entities.

### 1.3 Change

> [...] How much change can something undergo and still be the "same thing"? At
> what point is it appropriate to introduce a new representative into the
> system, because change has transformed something into a new and different
> thing?
>
> The problem is one of identifying or discovering some essential invariant
> characteristic of a thing, which gives it its identity. That invariant
> characteristic is often hard to identify, or may not exist at all.

> There are some kinds of change which result in the existence of two copies of
> the thing, corresponding to the states before and after the change. There are
> several ways to deal with this situation:
>
> 1. Discard the old and let the new replace it, so that it is really treated as
>    a change and not as a new thing;
> 2. Treat the old and the new as two clearly distinct things; and
> 3. Try to do both.

### 1.4 The Murderer and the Butler

> [...] Sometimes it is our perception of "how many" which changes. Sometimes
> two distinct entities are eventually determined to be the same one, perhaps
> after we have accumulated substantial amounts of information about each.

### 1.5 Categories (What Is It?)

> [...] Given that you and I are pointing to some common point in space (or we
> think we are), and we both perceive something occupying that space (perhaps a
> human figure), how many "things" should that be treated as in the information
> system? One? Many? Part of a larger thing? Or not a thing at all?
>
> And: do we really agree on the composition and boundary of the thing? Maybe
> you were pointing to a brick, and I was pointing to a wall.
>
> And: if we point to that same point in space tomorrow (or think we are), will
> we agree on whether or not we are pointing at the same thing as we did today?
>
> [...] Refer to what a thing is [...] as its "category". The same idea is often
> called "type", or "entity type". Like everything else, the treatment of
> categories requires a number of arbitrary decisions to be made.
>
> There is no natural set of categories. The set of categories to be maintained
> in an information system must be specified for that system. [...] A given
> thing (representative) might belong to many [...] categories.
>
> Not only are there different kinds of categories, but categories may be
> defined at different levels of refinement. [...] Thus, some categories are, by
> definition, subsets of others, making a member of one category automatically a
> member of another. Some categories overlap without being subsets.
>
> It is often a matter of choice whether a piece of information is to be treated
> as a category, an attribute, or a relationship (Which raises the question of
> how fundamental such a distinction really is.) This corresponds to the
> equivalence of between:
>
> - "that is a parent" (the entities are parents),
> - "that person has children" (the entities are people, with the attribute of
>   having children)
> - "that person is the parent of those children" (the entities are people and
>   children, related by parentage)
>
> It is often difficult to determine whether or not a thing belongs in a certain
> category. Almost all non-trivial categories have fuzzy boundaries. That is, we
> can usually think of some object whose membership in the category is
> debatable. Then either the object is arbitrarily categorized by some
> individual, or else there are some locally defined classification rules which
> probably don't match the rules used in another information system.

> The category of a thing (i.e. what it is) might be determined by its position,
> or environment, or use, rather than by its instrinsic form and composition.
> [...]
>
> The purposes of the person using an object very often determine what that
> object is perceived to be. [...]

> In part, these observations illustrate the difficulty of distinguishing
> between the category (essence) of a thing and the uses to which it may be put
> in (its roles).
>
> There are also interesting questions having to do with fragments of things,
> and imitations. Is it still a donut after you've taken a bite out of it? Did
> you ever call a stuffed toy an animal?
>
> And, like everything else, the category of an object can change with time.
> [...]
>
> The number of entities changes, too. [...] Perhaps, the easiest way out to
> ignore the principles of continuity and conservation that we have learned
> since earliest childhood. It simply no longer the same object.
>
> The fundamental problem of this book is self describing. Just as it is
> difficult to partition a subject like personnel data into neat categories, so
> also it is difficult to partition a subject like "information" into neat
> categories like "categories", "entities", and "relationships". Nevertheless,
> in both cases, it's much harder to deal with the subject if we don't attempt
> some such partitioning.

### 1.6 Existence

#### 1.6.1 How Real?

> It is often said that a database models some portion of the real world. [...]
>
> It ain't necessarily so. The world being modeled may have no real existence.
> [...]
>
> It might be:
>
> - Historical information (it's not real now)
> - Falsified history (it never was real)
> - Planning information, about intended states of affairs (it isn't real yet)
> - Hypothetical conjectures --- "what if" speculations (which may never become
>   real).
>
> One might argue that such worlds have a Platonic, idealistic reality, having a
> real existence in the minds of men in the same way as all other concepts. But
> quite often:
>
> - The information is so complex that no one human being comprehends all of it
>   in his mind. It is not perceived in its entirety by any agency outside of
>   the database itself.
> - Or, although not everly complex, the information may simply not have reached
>   any human mind just yet. The computer might have performed some computations
>   to establish and record some consequence of the known facts, which no person
>   happens to be aware of yet.
 
> Where is the reality that the database is modeling?
>
> [...] this situation is very different from a simple lack of information.
> [...] instead, we are questioning whether [...] such characteristics exist at
> all.
>
> To conclude, if we can't assert that a database models a portion of reality,
> what shall we say that a database does in general? It probably doesn't matter.
> Once again, it seems that we can go about our business quite successfully
> without being able to define (or know) precisely what we are doing.
>
> If we really did want to define what a database modeled, we'd have to start
> thinking in terms of mental reality rather than physical reality. Most things
> are in the database because they "exist" in people's mind, without having any
> "objective" existence. (Which means we very much have to deal with their
> existing differently in different people's minds.) And, of the things in the
> database which don't exist in any person's mind, whose mental reality is that?
> Shall we say that the computer has a mental reality of its own?

#### 1.6.2 How Long?

> Some kinds of entities have a natural starting and ending, and others have an
> "eternal" existence; creation and destruction aren't relevant concepts for them.
> The latter tends to be true of what we call "concepts" --- numbers, dates,
> colors, distances, masses.

> Beginnings and endings are often processes, rather than instantaneous events.
> We get tied up in our definitions of what entities are in the first place. Is
> it the whole thing when it's partially formed? [...]
>
> The entity concept enters in some other ways, too. Depending on what entity
> categories we choose, a certain process may or may not create an entity.

> So, does the creation and destruction of information have any direct
> relationship to the beginning and ending of objects? Almost never. "Create"
> and "destroy", when applied to information, really instruct the system to
> "perceive" and "forget".
>
> Once more: we are not modeling reality, but the way information about reality
> is processed, by people.

## 2. The Nature of an Information System

> For the most part, we are looking at the nature of information in the real
> world. Our ultimate motivation is to formulate descriptions of this
> information so that it may be processed by computers. In this chapter we
> briefly explore how this goal shapes our view of information. Among other
> things, we touch on the need for having data descriptions.
>
> At a fundamental level, there are certain characteristics of computers that
> have a deep philosophical impact on what we do with them. Computers are
> deterministic, structured, simplistic, repetitious, unimaginative,
> unsympathetic, uncreative. [...]
>
> We take "information system" to be more or less synonymous with the term
> "intergrated database". We mean to deal only with information that can be
> perceived as some formal structure of relatively simple field values (as in
> computerized file or catalog processing). [...]

### 2.1 Organization

> A computer is typically described as consisting of:
>
> - Input,
> - Processing,
> - Output, and
> - Memory
>
> I will change the words slightly, and suggest that we need to think of three
> basic parts of a data processing system:
>
> - A repository,
> - An interface, and
> - A processor.

#### 2.1.1 Repository

> The repository "contains" information, in some static sense. We have to have
> some mental system for imagining what is inside that repository. That's what
> this book is mostly about. [...]
>
> I want to suggest that we try to adopt an image more in terms of the
> informational functions performed for us, rather than in terms of the
> mechanical processes and materials that perform those functions. By way of
> analogy, I would say that we should think of a clock as containing a
> "repeater", an abstract mechanism capable of actuating something at a precise
> and uniform time intervals. We would say nothing about gears and escapements,
> or silicon circuits, or pivoted and balanced water pipes.

#### 2.1.2 Interface

> The interface is the medium of communication between you and the repository,
> or, more precisely, between you and the processor. [...] For our purpose, we
> need only imagine it as an opaque surface with stream of symbols passing in
> and out of it.

#### 2.1.3 Processor

> The processor receives symbol streams coming in across the interface. Parts of
> the stream are instructions to the processor, e.g., to change information or
> to find answers to questions. Parts of the stream represent information which
> is to be put into the repository, or which is used to find things in the
> repository (e.g., the name of the person about which you want information).
>
> The processor, following instructions,
>
> - Alters or retrieves information in the repository.
> - It then generates an outgoing stream across the interface, containing either
>   requested information or status about the operations.

### 2.2 Data Description

#### 2.2.1 Purpose

> [...], an information system might be totally permissive, imposing no
> constraints at all on the semantic sensibility of information. [...], while it
> is possible to build such totally generalized systems, it is customary, in all
> current data processing systems, to exclude such absurdities. Provision is
> needed to:
>
> - Specify which things can sensibly have which properties, and which
>   relationships make sense between which things.
>
> Pre-definition of information is also needed in order to specify:
>
> - Security constraints, [...] 
> - Validity criteria for information, [...]
> - How representations are to be interpreted (data type, scale, units, etc.).
>
> There are also economic implications. Known limitations on the length of
> various information, and a predictability of which pieces of information will
> or won't occur together, make it possible to:
>
> - Plan much more efficient utilization of computer storage.
> - [...], if the constraints are strict enough, very efficient repetitions of
>   simple patterns can be employed.
> - [...], if formats are rigid enough, and the number of combinations of things
>   that might occur is limited, then programs and procedures can be kept simple
>   and efficient.
>
> This is precisely why data processing is currently done in terms of records.
>
> Such rules and descriptions should be assertable before information is loaded
> into the system, and obviously can't be expressed in terms of individuals.
> [...]
>
> At the semantic level, we have adopted (in section 1.5.) the term "category"
> to label the intrinsic character of a thing ("man or mouse"). It also offers
> an attractive way of specifiying rules about things without referring to the
> individual things. One simply asserts that certain rules apply to all things
> in a certain category; one only has to name the category, not the individuals.
>
> Categories are at the foundation of almost all approaches to the description
> of data, and we will also adopt such an approach for the time being. [...]

#### 2.2.2 Levels of Description

> We have identified three levels of description:
>
> - The multiple views held by a variety of applications, each employing their
>   own variations on record formats, structures, and access techniques. This
>   level is variously referred to as "user", "application", "external",
>   "program", and "logical".
> - The physical layout of data in storage, including implementation techniques
>   for various paths and linkages. The common names for this level are
>   "internal", "storage", and "physical".
> - The specification of the information content of the database, employing
>   concepts equivalent to entities, attributes, and relationships. Names for
>   this level include "conceptual", "information", and "entity" (and,
>   sometimes, "logical").

> This separation into multiple levels of descriptions is necessary to cope with
> change. Experience has shown that the way data is used changes with time.
>
> Application programs change the way they use the data. They change:
>
> - Record formats, [...]
> - Combinations of records they need to see in a single process.
>
> New applications need to see records containing data that had previously been
> split among several records. Other new applications need extensions to
> existing data (e.g., additional fields in old records), without perturbing the
> old applications. Applications sometimes change the data management technique
> which they use to access the data.
>
> [...], the physical layout of the data changes.
>
> - The grouping and sequencing of data,
> - Redundancy, and various kinds of access paths combine to provide certain
>   performance tradeoffs for the various applications.

> A large part of [The Database Administrator]'s job consists of defining and
> managing this mass of information as a corporate resource [...]. He needs a
> way to describe this information purely in the terms of "what kinds of
> information do we maintain in the system". With this description (the
> conceptual model) as a reference, he can then separately specify the various
> formats in which this data is to be made available to application processes
> (the external models), and also the physical organizations in which the data
> is to exist in the machine (the internal model).
>
> Besides its role in an operational database system, a conceptual model is also
> needed in the planning process. It provides:
>
> - The basic vocabulary, or notation, with which to collect the information
>   requirements of various parts of the enterprise.
> - [...] the constructs for examining the interdependencies and redundancies in
>   the requirements, and
> - For planning the information content of the database.

#### 2.2.3 The Traditional Separation of Descriptions and Data

> In traditional record processing systems, constraints on information are
> implicitly enforced by the rigid discipline of record formats. [...]
>
> Out of this practive emerged a "type" concept, referring to record formats. A
> set of records of type X all conform to the described format for type X
> records. And the systems require record descriptions. [...]
>
> Such practices have two consequences in data processing systems:
>
> - The emergence of a type concept, and
> - The partitioning of the repository into two disjoint parts (often with
>   distinct interfaces and processors): one for the data, and one for the
>   descriptions.
>
> We have thus far described a very simple system organization, consisting of
> interface, processor, and repository. The descriptions, and constraints, have
> to be somewhere.
>
> Historically, the repository has been partitioned into two unconnected
> regions, the data files and the descriptions (contained in system catalogs or
> data dictionaries).
>
> - The descriptions had to be formatted specially because the system code
>   looked at it, and it had to do that efficiently.
> - Also, the system had to be protected from anyone tampering with the
>   descriptions, as they might with ordinary data, because the system fell
>   apart if the descriptions didn't match the data.
> - If a file description is changed, that's more than just a change in
>   information --- the system has to do something, usually traumatic, to make
>   the file fit the new description.
>
> These concerns far overshadowed any possible need by any application to get at
> data that happened to be in the catalog or the dictionary. The separation is
> so entrenched in the thinking of most data processing people that they don't
> even understand what I'm talking about. Catalogs and files are so "obviously"
> different things that they can't fathom any commonality. One of them is
> encoded information used by the system, and the other is the data used by
> applications.
>
> [...] With data about data, modifications need to be carefully controlled;
> they have consequences that must be carried out by the system. [...]
>
> The distinction between information needed by the system and by applications
> isn't so sharp either; [...] systems can be implemented with the data and
> descriptions in the same repository, and in the same form [...].

### 2.3 What is "In The System"?

> The perverse nature of information touches everything: we can't even clearly
> define what information is "in the system".
>
> [...], we distinguish between "raw" and "deduced" information.
>
> - Raw information is that which the system has no way of knowing unless it is
>   asserted to the system, e.g., the names of the employees in a department.
> - Deduced information is then anything that can be computed or otherwise
>   derived from the raw information, e.g., the number of employees in the
>   department.
>
> Under what conditions shall we consider deduced information to be "in the
> system"? [...]
>
> We will have more about implicit relationships [...].

I was not really sure about the author's intention on this. He gave a few
examples on storing the data of employees, and if counting the employees (the
deduced information) is a part of the system.

> There is a nother sense in which information may implicitly exist in the
> system. One often tends to think of information in the system as the contents
> of various fields in records. A fact in a database is sometimes defined as an
> association between two fields: one giving the value of an attribute (weight =
> 200 lb.) and one identifying the entity having that attribute (name = Henry
> Jones). However, the mere existence of a record in a file itself bears
> information. [...]
>
> Another common form of implicitly represented information has to do with data
> which depends on some kind of continuous variable, such as time or weight.
> [...] The only things which are actually stored are "breakpoints", i.e.,
> points (of time or weight) at which the information changes. Extracting the
> data values for a given time or weight involves a combination of table lookup
> and computation. These are examples of:
>
> - Procedural existence tests,
> - Essentially of a range test variety [...],
> - Combined with computed relationships [...].
>
> [...] a unifying approach to many of these questions which equates "data
> in the system" with what can be extracted, rather than with what is physically
> stored.
>
> - The system is modeled as a set of named functions, which are capable of
>   returning certain values when invoked with certain arguments.
> - An update presumably modifies the function, so that it subsequently returns
>   different results for the same argument.
> - The implementation of the functions is masked from the user; it might
>   involve:
>   - Simple access to stored data,
>   - Complex traversals of data structure,
>   - And/or computations.
>
> Thus the information content of the system is defined by this set of
> functions, rather than in terms of physically stored data. [...] This
> description of information content is still incomplete, of course. We can
> always mentally infer other information from the values returned by functions.
> [...] Similar concepts occur in the "accessor" mechanism [...], and also in
> inferential systems [...].
>
> [...] The kinds of information that a system is capable of handling are as
> much determined by its manipulative interface as by its declarative
> facilities. There is a very thin line between the ability to declare something
> about a data item and the ability to dynamically request a data item with the
> same characteristics. Someone has said that "structure is process slowed
> down". The more you declare, the less your applications have to do
> procedurally --- and the effect is more stable.
>
> In terms of the abstract organization of an information system we introduced
> earlier: the distinction between processor and repository is not so clear
> after all.
>
> Still another form of implicit information concerns the *meaning* of the data
> items in the system. [...] It is customary to expect that you, the user, know
> what the fields signify. The manner in which a multiplicity of users get to
> know, and agree about, what these data items mean is the central point of data
> description.
>
> Such information could be perceived as part of the "normal" information
> content of the system if we expected to get answers to [question that can be
> deduced from the stored data] [...]

### 2.4 Existence Tests In Information Systems

#### 2.4.1 Acceptance Tests: List and Non-List

> We can broadly classify the tests as list tests and non-list tests. For list
> tests, there is an explicit list of existing elements with which the symbol
> can be compared.
>
> In practice, such lists tend to be either:
>
> - Static or
> - Dynamic.
>
> A static list is permanently defined, and is usually incorporated into the
> data description rather than occurring in the data itself. They often occur in
> the form of rules, [...]. Such rules, occuring in the data description, tend
> to be strictly enforced. These static lists can actually be modified, but
> that's exceptional and traumatic.

"Static lists" are kind of similar to `enum`s in programming languages.

> Dynamic lists occur in the data itself, and they can be modified by the normal
> update activity on the data. That is, part of the normal activity on the data
> includes inserting and removing such entities. A dynamic list might simply be
> a set of symbols; or it might be a set of objects representing entities, to
> which the symbols are associated as names. In conventional systems, records
> often play the role of such lists. [...] Actual practice varies widely in this
> respect; various systems enforce such rules to varying degrees.

Or we can say that "dynamic lists" are similar to "foreign keys" of relational
databases.

> Non-list tests involve some procedure other than list checking. The most
> common forms of these are range checks and syntactic checks.
>
> - Range checks require valid values to lie between specified limits.
> - Syntactic checks are based entirely on rules governing the composition of
>   the symbol itself; no other indication of existence or meaning is involved.
>
> [...] Symbols are all too often accepted as the names of people, companies,
> addresses, states, countries, and so on, with no test at all for their
> existence.
>
> For many entity types, any of the existence tests might be employed in a real
> system. In practice, tradeoffs are made between the cost of performing the
> tests and the cost of misrepresenting the existence of the entities. The vast
> majority of data items in today's files are subjected (in the information
> system) only to syntactic tests, leaving open the possibility of nonsense
> references to non-existent entities. While information systems are supposed to
> be modeling some aspect of reality, there does seem to be a very mixed bag of
> techniques for synchronizing the system's perceptions with the actual
> existence of things.

#### 2.4.2 An Act of Creation

> Entities whose existence is modeled by a list test require an explicit act of
> creation. Some overt act is required to establish the existence of such an
> entity before other things can be said about it. [...]
>
> In contrast, entities defined by non-list tests have a kind of "eternal"
> existence. Once the procedure is defined, the entire set of things acceptable
> to it exist implicitly. Such entities do not require an overt act of creation
> prior to being referenced.

#### 2.4.3 Existence by Mention

> In general, this ambivalence will be true wherever the acceptance test is
> limited to a loose syntactic check.

#### 2.4.4 Existence By Implication

> If the computer knows the date you were hired and the date you were fired, it
> can list all the dates on which you were and imployee. Do those date "exist"
> in the machine? We'll come back to that in section 2.3.

#### 2.5 Records and Representatives

> An attempt to provide a regular modeling of the existence of entities leads to
> the notion of "representatives".
>
> The traditional construct that represents something in an information system
> is the record. It doesn't take much to break down the seeming simplicity and
> singularity of this construct. [...]
>
> The concept of "record" is equally muddy in computer systems. [...]
>
> By various rules and conventions, we somehow know how to call a collection of
> data "one record" even though:
>
> - It may physically exist in several copies [...]
> - It may not be physically contiguous
> - Its location and content change over time.
>
> Thus, even at this level, we do not have a truly tangible, physical construct
> called "record", but rather we have to deal with it abstractly. [...]
>
> We are after a single construct that we can imagine to exist in the repository
> of an information system, for the purpose of representing a thing in the real
> world. Beyond grappling with the definition of "record", we have another
> traditional problem to contend with. [...], we find that a thing in the real
> world is represented by, not one, but many records. [...]
>
> If we can't pin down "records" to represent things in the real world, could we
> somehow use this underlying pool of data as a representative? Maybe. The
> probelm is that we would like the representatives of two things to somehow be
> cleanly disjoint, to be distinctly separate from each other. Unfortunately,
> much of the data about something concerns its relationships to other things,
> and therefore comprises data about those other things as well. [...], we can't
> draw an imaginary circle around a body of information and say that it contains
> everything we know about a certain thing, and everything in the circle
> pertains only to that thing, and hence that information "represents" the
> thing. Even if we could, the concept is too "smeared" --- we need some kind of
> focal point to which we can figuratively point and say "this is the
> representative of that thing".
>
> [...] The characteristics of a representative in an idealized repository might
> include these:
>
> - A representative is intended to represent one thing in the real world, and
>   that real thing should have only one representative in an information
>   system. [...]
> - Representatives can be linked. [...]
> - The information expressed by linking representatives includes such things as
>   relationships, attributes, types, names, and rules.
> - The kinds of rules that generally need to be specifiable about
>   representatives include conventions governing their type, name, existence
>   tests, equality tests, and general constraints on their relationships to
>   other things.
> - For representatives with explicit existence tests, the representative must
>   be created by an overt operation on the information system. [...]
> - The information associated with a representative must be asserted explicitly
>   to the information system. [...]
> - It would help to have some mechanism to clearly and unambiguously indicate
>   what is meant by "one" and "the same" representative. [...]

## 3 Naming

### 3.1 How Many Ways?

> The purpose of an information system is to permit users to enter and extract
> information --- about entities. Most transactions between user and system
> require some means of designating the particular entity of interest. In order
> to design or evaluate the naming facilities of an information system, it helps
> to be aware of the variety of ways in which we designate things.
>
> How do we indicate a particular thing we want to talk about? [...]
>
> - You point youir finger. By itself that's generally ambiguous, unless there's
>   something in the context of conversation to indicate whether you are
>   pointing to [a particular thing] [...]
> - If it's a person you might use his name. [...] People's names are generally
>   non-unique.
> - [...] In identifying something, a name may be meaningless unless you also
>   establish the category of the thing. [...] Sometimes you can't tell whether
>   an entity or a category is being named. [...]
> - A thing can have different kinds of names. [...] So, to be complete, we may
>   sometimes have to indicate the kind of identifier being used, in addition to
>   the identifier itself and the category of the thing. [...]
> - You don't always have all these options. Very often you have to know who
>   you're talking to; that will determine how you have to identify the thing
>   being referenced.
> - You might even have a choice of several different names of the same "kind"
>   for the same thing. [...]
> - You might refer to someone or something by its relationship to another
>   identified thing [...].
> - Or by the role currently played by the thing [...].
> - Or by its attributes [...].
> - And certainly by combinations of these [...]. Again, these references may or
>   may not be unambiguous.
> - We often address a letter to a person when we really want to deal with his
>   role [...]
> - A name sometimes describe the thing being named. Sometimes it doesn't. [...]
> - Some names have embedded in them information about the thing being named.
>   [...]
> - When dealing with ambiguity, we sometimes employ a complex strategy of
>   reducing the number of candidates to one. [...] Some strategies:
>   - Take the first one encountered, according to some ordering. [...]
>   - When things are versioned, default reference is to some "latest" version.
>     [...]
> - We also refer to things by pronouns [...], which depends on some convention
>   to establish the object of reference. [...]
> - Sometimes we refer to something without knowing yet exactly which thing we
>   are talking about. [...]
> - In programming, an important special case of reference by relationship
>   involves some ordering.
> - In programming, "pointing" often means naming some location in the machine.
>   It is something like pronoun reference ("that") in that it involves some
>   convention to establish what is being referenced, i.e., what is assumed to
>   be at that location [...].
>
> Which of these phenomena shall we call "naming"? No answer. It doesn't matter.
>
> Can we distinguish between naming and describing?
>
> On one hand there is a pure naming or identification phenomenon: a string of
> characters serves no other purpose than to indicate which thing is being
> referenced. On the other hand, we have information about the attributes of a
> thing and its relationships to other things. Of course, the two overlap.
>
> There are very few "pure" identifiers, containing no information whatsoever
> about things. [...]

### 3.2 What is Being Named?

> Which entity is being named? [...]

Apparently, no hard answer.
 
> Alternatively, we could invent a new abstract entity, e.g., a "message
> destination" (in teleprocessing systems, a "logical unit"). [...]
>
> A familiar message again: you the observer are free to *choose* the way you
> apply concepts to obtain your working model of reality.

### 3.3 Uniqueness, Scope, and Qualifiers

> Whether a name refers to one thing or many frequently depends on the set of
> candidates available to be referenced. This set of candidates comprises a
> "scope", and it is often implicit in the environment in which the naming is
> done. [...] The boundaries of a scope, and the implicit default rules, are
> often fuzzy [...].
>
> Qualifications, the specification of additional terms in a name, is often used
> to resolve such ambiguities by making the intended scope more explicit. In
> this case, adding the state name would (partially) resolve the ambiguity.
>
> Scopes are often nested, and we often employ a mixed convention: a larger
> scope is left implicit, but a sub-scope within it is explicitly specified.
> This is partial qualification. [...]
>
> Incidentally, phone numbers illustrate some kinds of anomalies that may occur
> in real naming conventions:
>
> - Different forms of names are valid within different scopes [...].
> - Form an content (syntax and semantics) are mixed together [...].
> - The naming conventions can depend on the scope *from* which the naming is
>   done [...].
>
> [...], the name does not go with the entity, but is an "attribute" of the
> relationship between the entity and the scope [...].

#### 3.3.1 Deliberate Non-Uniqueness

> Quite often, things don't have individual unique names. This poses no problem
> when things aren't individually represented in the system. In the case of
> parts, for example, we have one named representative for a type of part; the
> existence of individual instances is reflected only in the "quality of hand"
> attribute.
>
> [...]
>
> It is sometimes asserted that each entity represented in the system must have
> a unique identifier. I contend that this is a requirement imposed by a
> particular data model (and it may make many things easier to cope with), but
> it is not an inherent characteristics of information.

#### 3.3.2 Effective Qualification

> A scoping object does not have to have any intuitive connotations of "scope".
> It need not be a physical region, or a catalog, or an area code. It need not
> be a physical region, or a catalog, or an area code. Quite often, the
> technique for giving something a unique qualified name is simply based on an
> arbitrary relationship to some other object. In effect, the scope becomes the
> set of things having a particular relationship to a particular object.
>
> - Uniqueness Within Qualifier: the relationship must confer uniqueness of
>   simple name within relative (i.e., the employee must not have two dependents
>   with the same simple name). [...]
> - Singularity of Qualifier: ? [...]
> - Existence of Qualifier: a qualifier must exist for each entity occurrence.
>   [...]
> - Invariance of Qualifiers: such a relationship must be invariant
>   (unmodifiable). The relationship constitutes information that is redundantly
>   scattered about everywhere that this entity is referenced, with the
>   potential for enormous update anomalies if the information can change. [...]

To be honest, I have no clue what the author is wanting to convey. Let us hope
that in the future, when I suffe more from data modeling problems, I will be
able to have a clearer understanding.

### 3.4 Scope of Naming Conventions

?

### 3.5 Changing Names

> Names do change [...].
>
> The common solutions: either
>
> - Disallow name changes (pretend they don't happen), or
> - Generate a new naming scheme for the data system and treat the other
>   (changable) names as attributes.
>
> The later solution has a price, of course:
>
> - Increased space required for storing and indexing the additional names;
> - Learning and processing problems in dealing with new, "unnatural" names;
> - Possible loss of "key" facilities of some access methods (e.g., if secondary
>   indexing weren't available).
>
> Systems that depend on symbolic associations for paths (e.g. the relational
> model), as opposed to internal "unrepresented" paths between entities, cannot
> readily cope with changing names [...].
>
> When name changes are disallowed by the system, one can trick the system by
> deleting the entity, and then inserting it again as a "new" entity under its
> new name. Unfortunately,
>
> - It is sometimes very difficult, if not impossible, to discover all the
>   attributes and relationships associated with the old entity, so that they
>   may be re-established for the new entity.
> - And sometimes, deletion and insertion may have undesirable semantic
>   implications of their own, enforced by the system and perhaps unknown to the
>   application that is trying to change a name.

### 3.6 Versions

> [...] The central problem with the version concept is that we can't decide
> whether we are dealing with one thing or several.

### 3.7 Names, Symbols, Representations

> What is a name but a symbol for an idea? What essential difference is there
> between "Kent" and "25" and "blue", other than that they name different
> things.

### 3.8 Why Separate Symbols and Things?

#### 3.8.1 Do Names "Represent"?

> In linguistics, a symbol is itself a representative of the thing it names. We
> have no choice; there isn't anything else. In the conventional linguistic view
> of verbal communication (written and spoken), including our normal
> communications with computers, we have nothing else except character strings
> to represent the things we are communicating about. This leads some people to
> conclude that we must use such symbols as the representatives of entities.
>
> But in a modeling system, we do have an alternative. We *can* postulate the
> existence of some other kind of object inside a modeling system that acts as
> the representative (surrogate) for something outside the system. There
> "actually" is something in the system (a control block, an address in virtual
> memory, or some such computer-based construct) which can stand for a real
> thing. Once we've done that, we can talk about the symbols that name a thing
> separately from the representative of that thing.
>
> [...]
>
> This is not to say that we can do without character strings. They are
> absolutely indispendable in describing and referring to what is being
> represented and linked. What we have done is to shift the primary
> responsibility for representing things away from character strings and onto a
> system of objects and links. Then we use character strings for description and
> communication. This shift of responsibility gives us greater freedom in how we
> use the character strings, and helps us escape a multitude of problems rooted
> in the ambiguity and synonymity of symbols.
>
> This idea of taking the label out of the node, of treating an object
> separately from the various symbols with which it might associated, should be
> exploited for a number of reasons:
>
> - We can cope with objects that have no names at all (at least in the sense of
>   simple labels or identifiers). We can support other ways of referring to an
>   object, e.g., via its relationships with other objects.
> - The separation permits symbol objects to be introduced and described
>   (constrained) in the model, independent of the objects that they might name.
>   [...]
> - Naming rules can be expressed simply in the form of relationships between
>   thing types and symbol types.
> - Other useful relationships might be expressed among symbols: synonyms,
>   abbreviations, encodings, conversions.
> - Various kinds of relationships might exist between things and strings:
>   - Present name vs. past.
>   - Legal name vs. pseudonym, alias, etc.
>   - Maiden name vs. married name.
>   - Primary name vs. synonym.
>   - Name vs. description.
>   - Which name (representation) is appropriate for which language (or other
>     context). [...]
> - The structures of names can be distinguished from the structure of an
>   object. [...]
> - The separation permits differentiating between different *types* of names
>   for a given thing, [...]. Such types are themselves a normal part of the
>   information structure available from the model.
> - By distinguishing sets of things from sets of signs, we can avoid confusing
>   several kinds of assertions:
>   - Assertions about real things [...].
>   - Assertions about signs [...].
>   - Assertions relating things and signs [...].

#### 3.8.2 Simple Ambiguity

> "It all depends on what you mean by ambiguity."
 
> We musn't neglect the plain familiar ambiguities, which make their own large
> contribution to our communication confusion. Most words simply do have
> multiple meanings; we can't escape that. Some comments and corollaries:
>
> - As evidence of the multiplicity of meanings, simply consider the average
>   number of definitions per word in a dictionary. [...]
> - Ambiguity appears to be inevitable, in an almost mathematical sense, if we
>   consider the relative magnitudes of the set of concepts and the set of
>   words. [...]
> - "...fuziness, far from being a difficulty, is often a convenience, or even
>   essential, in communication and control processes. [...]"
> - The complexity of legal jargon testifies to the difficulty of being precise
>   and unambiguous.
> - Observe the number of puns and jokes that depend on ambiguity [...].
> - If you listen carefully, you will discover all kinds of ambiguities
>   occurring continuously in your daily conversations. [...]
> - Why should we expect the language which describe a customer's business to be
>   any better understood or less ambiguous than the language which describes
>   our own? [...]

#### 3.8.3 Surrogates, Internal Identifiers

> Some alternative models suggest that some sort of an internal construct be
> used to represent an entity, acting as a "surrogate" for it. This surrogate
> would occur in data structures wherever the entity is referenced, and naming
> problems would at least be isolated by keeping structured or ambiguous
> identifiers off to one side, outside the structures representing attributes
> and relationships.
>
> Since these surrogates must eventually be implemented inside the computer in
> some form of symbol string, it is sometimes held that such surrogates are
> themselves nothing but symbols.
>
> It is useful to be aware of some fundamental differences between surrogates
> and ordinary symbols:
>
> - A surrogate need not to be exposed to users. Only ordinary symbols pass
>   between user and system. In concept, models involving surrogates behave as
>   though a fact [...] was treated in two stages. First, the surrogates
>   corresponding to the employee and department identifiers are located (i.e.,
>   name resolution). Then the two surrogates are placed in association with
>   each other, to represent the fact.
> - Users do not specify the format, syntax, structure, uniqueness rules, etc.
>   for surrogates.
> - Surrogates are globally unique, and have the same format for all entities.
>   The system does not have to know the entity type before knowing which entity
>   is being referenced, or before knowing what the surrogate format will be.
> - Surrogates are purely information-free. They do not imply anything about any
>   related entities, nor any kind of meaningful ordering.
> - A surrogate is intended to be in one to one correspondence with some entity
>   which it is representing. In contrast, the correspondence between symbols
>   and entities is often many-to-many.
> - Surrogates are atomic, unstructured units. E.g., there is never a question
>   concerning how many fields it occupies.

### 3.9 Sameness (Equality)

#### 3.9.1 Tests

> A counterpart of the existence test of section 2.4 is the equality test. When
> shall two symbol occurences be judged to refer to the same entity? (We mean
> "symbol" broadly in this context to include phrases, descriptions, qualified
> names, etc.) In general, different models are applicable to different entity
> types. It is as much a specifiable characteristic as the naming conventions
> themselves.
>
> We can describe several kinds of equality tests:
>
> - Match, 
> - Surrogate, 
> - List, and
> - Procedural.
>
> A match test is based on simple comparison between the symbols. They are
> judged to refer to the same entity if and only if the symbols themselves are
> the same (by whatever rule sameness is judged, with regard to, e.g., case,
> font, size, color, etc.). [...]
>
> In a surrogate test, each symbol is interpreted to refer to some surrogate
> object (e.g., a record occurence). If both symbols refer to the same
> surrogate, the symbols are judged equal. [...]
>
> A list test involves a simple list of synonyms. [...] If the two symbols occur
> in the same list, they are judged equal.
>
> A procedural test involves some other arbitrary procedure by which the two
> symbols are judged equal. These are most often performed in relation to
> numeric quantities.
>
> It is not generally acknowledged that equality tests for numeric quantities
> exhibit much the same characteristics as equality tests for non-numeric
> symbols. For numeric quantities, a number of factors are generally involved:
>
> - The quantities are more likely to be judged equal if they were initially
>   named by the same "conventions", i.e., measured and recorded with the same
>   precision.
> - The quantities need to be "converted" into common units of measure, data
>   types, representations, etc. These are, in effect, replacing the original
>   symbols with procedurally determined synonyms.
> - Compare the two symbols. In many cases, the quantities only have to match
>   within a certain tolerance ("fuzz") to be judged equal. This is another
>   procedure for recognizing synonyms symbols, effectively similar to explicit
>   lists of synonyms [...].
>
> There is certainly some interaction between the forms of the equality tests and
> the existence tests. Not all of the equality tests are applicable to entities
> subject to each of the existence tests.

#### 3.9.2 Failures

> When equality is based on symbol matching, several kinds of erroneous results
> can arise.
>
> - If two things have aliases, then equality will not be detected if two
>   different names for the same thing are compared.
> - If symbols can be ambiguous (name several things), then spurious matches
>   will occur. Different things will be judged to be the same, because their
>   names match.
>
> [...]
>
> These concerns are especially relevant when attempting to detect implicit
> relationships based on matching symbols.
>
> In general, when aliases are supported, we have to know:
>
> - When two symbols refer to the same thing.
> - Which symbol(s) to reply in answer to questions.
> - Whether use of a new symbol implies a new object or a new name for an
>   existing object.

## 4 Relationships

> Relationships are the stuff of which information is made. Just about
> everything in the information system looks like a relationship.
>
> A relationship is an association among several things, with that association
> having a particular significance. [...] refer to the significance as its
> "reason". [...]
>
> Relationships can be named, and [...], we will treat the name as being a
> statement of the reason for the association (which means we will sometimes
> invent names which are whole phrases, such as "is-employed-by"). As usual, we
> have to be careful to avoid confusion between kinds and instances. We often
> say that "owns" is a relationship, but it is really a *kind* of relationship
> of which there are many instances [...]. [...] use the unqualified term
> "relationship" to mean a kind, and add the term "instance" if that's what is
> meant. So, to be precise, our opening definition was of a relationship
> instance. A relationship then becomes a colleciton of such associations having
> the same reason.

### 4.1 Degree, Domain, and Role

> We have so far looked only at relationship instances involving two things.
> They can also be of higher "degree".
>
> - If a certain supplier ships a certain part to a certain warehouse, then that
>   is an instance of relationship of degree three.
> - If that supplier uses a certain trucking company to ship that part to that
>   warehouse, then we have a fourth degree relationship.
>
> We must distinguish between "degree" and a confusingly similar notion.
>
> - If a department employs four people, we might view that as an association
>   among five things.
> - If another department employs two people, we have an association among three
>   things, and we couldn't say in general that the "employs" relationship has
>   any particular degree.
