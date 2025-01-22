---
title: "The HARM Stack (HTMX, Axum/AlpineJS, Rust, Maud) Considered Unharmful"
date: 2025-01-19T21:14:33+07:00
draft: false
toc: true
tags:
- htmx
- axum
- alpinejs
- rust
- maud
categories:
- explanation
---

## Overview

Generally, there are two ways of web rendering: the first is SSR, stands for
Server-Side Rendering; the second is CSR, stands for Client-Side Rendering. Both
come with different trade-offs. Someone has compared that to a cycle, where we
first started with SSR, then moved to CSR/SPA as the client-side application
state became complex. Because CSR has its problems, we (re)discovered SSR
[^ssr-csr-cycle] with HTMX, or even NextJS SSR. There were many writing about
issues of CSR and SPA [^spa-complaints-1] [^spa-complaints-2], but I would
summarize them essentially as a *state synchronization problem between the
client and the server* that results in *complexity* [^complexity].

SSR supposes to solve this by treating the UI as a representation of the
server's state [^hateoas], but it has a big UX problem: on receiving HTML, the
browser reloads the whole page, creating a white flickerring screen. HTMX, while
doesn't seem like a revolution at first, solves this exact problem. It makes the
end UI implementation just "good enough" without bringing in the complexity of
CSR/maintaining two states.

As we consider HTMX as the core and the main topic, you might wonder why is the
title about HARM stack? The HARM acronym is memorable, I must admit. Also, I can
attract more reader that way (people who are either interested in HTMX, or Axum,
or AlpineJS, or Rust, or Maud). The ARM (Axum/AlpineJS, Rust, Maud) parts are
expandable (can be replaced easily), and I will explore that in another section
of this post.

## Problems of CSR

Before moving to SSR and HTMX, let us consider this rudimentary model to
understand problems of CSR:

- The end user is interested in the server's state (data)
- That requires the client, which displays the server's state in an useful way
- To display the server's state, the client has to store a copy as well
- Keeping this duplicated version in-sync with the source of truth is
  challenging 

As we mentioned in the overview, the core problem in here is having *two
states*, one in the client, and another in the server. Reconciling them is the
source of *complexity*.

One detailed symptom of the complexity is the added cognitive load when we have
one language in the frontend, and another in the backend. Very often, it is
JavaScript/TypeScript paired with an other (Golang, Python, Rust, etc). The
languages are different, and so is the tooling around

- For JavaScript/TypeScript: `node` and `npm` 
- For Golang: `go`
- For Python: `python` and `venv` [^python-ecosystem-mess]
- For Rust: `rustup` and `rustc` and `cargo`

While learning the ecosystem itself takes a lot of work and is complex already,
having to juggle between different programming languages can also impose a heavy
burden on our mind. For an extreme example, let's say we pair JavaScript, a
dynamic garbage-collected language, with Rust, a strongly typed language with a
novel approach to memory management: switching between those two is obviously
challenging.

Communication to synchronize the states is another can of worms. We have to
validate/parse the data before taking them in. The work is required as we can
never blindly trust inputs from another source, as the data might not conform to
what we want. It shouldn't be once or twice that professional software
developers encountered runtime error from accessing invalid property from
another source. Indicating communication status in the frontend is another
source of complexity: we must write more code to take into account server error
and timeouts.

I'm aware that we can go with the fullstack route, using JavaScript/TypeScript
on both frontend and backend, to mitigate the mentioned problems. However, it
doesn't fundamentally solve the two states problem, and can still has
backend/frontend communication problem if we aren't careful [^unexpected-bug-1].

## The UX Problem of SSR and HTMX as A Solution

I hope I showed you how CSR's model of having two states caused problems and
complexity. It then be obvious how SSR allows us to sidestep the problems
mentioned: instead of needing two languages, we only need one; instead of
communicating through JSON (or any other format), there is no communication at
all, and the output is a "pure" display of the server state [^react-related].

Despite the simplicity that it brings, SSR still has a fundamental UX problem:
on page navigation, the screen flashes and there are small moments of brokeness
before it can be rendered properly [^ssr-suspicion]. Also, if we are concerned
with performance, rerendering the whole page again and again doesn't look good
as well. We then see how HTMX solves the raised issues by a brilliant mechanism:
only swap the DOM where it is needed using the server's response.

Let's take a look at a simple counter example, where the end result should look
like this (styled by `matcha.css` [^matcha-css]):

![](../images/harm-stack-counter.png)

Let's take a look at the whole page and the input:

```rust
pub async fn page(
    State(app_state_arc): State<Arc<Mutex<AppState>>>,
) -> Markup {
    let input = if let Ok(app_state) = app_state_arc.lock() {
        counter_input(&app_state)
    } else {
        html! {
            "Unable to get app state"
        }
    };

    html! {
        (header("Counter"))
        body {
            h1 { "Counter" }

            form {
                fieldset {
                    label {
                        "Server value: "
                        (input)
                    }
                    button
                        type="submit"
                        hx-post="/counter-increase"
                        hx-target="#counter-input"
                        hx-swap="outerHTML"
                        hx-trigger="click"
                        { "Increment" };
                }
            }
        }
    }
}

pub fn counter_input(app_state: &AppState) -> Markup {
    html! {
        input
            #counter-input
            type="number"
            value=(app_state.counter)
            name="counter"
        ;
    }
}
```

I must admit that because of Rust's strictness and the use of a Rust DSL to
write HTML (Maud), the code can be more verbose and cryptic that the simple idea
I want to explain. Before focus on the important ideas, there is this part that
deserve an explanation for people who are not that familiar with Rust:
`State(app_state_arc): State<Arc<Mutex<AppState>>>`. Overall, it's Rust + Axum
specific way to handle shared state (`State` is Axum's *extractor* for data of
each request handler, `Arc<Mutex>` is Rust's way to ensure the shared data is
thread-safe).

Having known that, let's take a look at the HTML for the button:

```rust
button
    type="submit"
    hx-post="/counter-increase"
    hx-target="#counter-input"
    hx-swap="outerHTML"
    hx-trigger="click"
    { "Increment" };
```

I think most experienced developers can vaguely infer what's going on here,
despite having not read HTMX docs before:

- when we click on the button
- swap the part that needs changing, `#counter-input`
- using the response of `POST /counter-increase`

It makes sense after we look at the response of `POST /counter-increase`:

```rust
pub async fn increase(
    State(app_state_arc): State<Arc<Mutex<AppState>>>,
) -> Markup {
    let data = if let Ok(mut app_state) = app_state_arc.lock() {
        app_state.counter += 1;
        counter_input(&app_state)
    } else {
        html! {
            "Unable to get app state"
        }
    };

    data
}
```

For compleness's sake, we can look at the code of `AppState` and routing:

```rust
pub struct AppState {
    counter: i32,
}

#[tokio::main]
async fn main() {
    // ...

    let app = Router::new()
        .route("/", get(page))
        .route("/counter", get(counter::page))
        .route("/counter-increase", post(counter::increase))
        // ...
        .with_state(Arc::new(Mutex::new(AppState {
            counter: 0,
        })));

    // ...
}
```

The end result is a counter that has the counted value lives on the server
[^counter-demo] (be noticed that even if I refresh the page, the value is still
there):

![](../images/harm-stack-counter-demo.gif)

The whole interaction can be simplified to this diagram:

![](../images/harm-stack-counter-diagram.png)

Where:

1. The server returns the HTML of the whole page
2. The button perform some action, then get some response from the server
3. The response from the server replaces the input of the page

## Pick or Ditch HTMX

I hope that I sold you the idea of using HTMX after the above explanation and
made you consider trying it. The author of HTMX wrote an extensive trade-off
analysis essay [^htmx-trade-offs] that we can take a look first-hand. Apart from
that, I find this diagram from Reddit useful as well [^htmx-thought-process].

![](../images/htmx-thought-process.webp)

However, I would like to emphasize one thing that the analysis essay mentioned:
the current team's state. It wouldn't be a problem if we are using HTMX in a
side project or for learning purpose, but we should consider if it is good with
the current team/company's architecture as well, as adopting HTMX is not a small
change with the current "norm" of using React/frontend libraries and frameworks.
In fact, I feel like it is a *paradigm shift*, similar to discovering functional
programming after being too familiar with object-oriented programming.

Another point that people think would go against HTMX is the reusability of the
"API" we expose: as we are returning HTML, it is not easily consumable by mobile
clients, comparing to traditional JSON data. While I'm aware that something like
Hyperview [^hyperview] exists and can help us on building mobile apps with an
approach similar to the HTMX way, I would further argue that: reaching the point
of needing mobile clients aren't that common. To push it further: even if we
need to expose REST endpoints, reusing the current HTML-returning code to build
the endpoints wouldn't take that much time, as we already established the
database connection and data transformation and such.

HTMX can simplify the application's architecture, but it's easily seen that
should there be client-side only state (like a theme toggler, or a modal, or
animation), HTMX won't help [^htmx-silver-bullet]. We can either resort to
vanilla JavaScript, or use some kind of "lightweight framework" like AlpineJS or
Hyperscript.

```rust
pub fn header(page_title: &str) -> Markup {
    html! {
        (DOCTYPE)
        head {
            meta charset="utf-8";
            title { (page_title) };
            link rel="stylesheet" type="text/css" href="https://matcha.mizu.sh/matcha.css";
            script src="https://unpkg.com/htmx.org@2.0.4" {""};
            script defer src="https://unpkg.com/alpinejs@3.14.8" {""};
        }
    }
}
```

On what is a "lightweight framework" and which one to use, I will elaborate on
that in the next section. 

## Expandability of The HARM Stack

I'm not sure if you noticed this, but the HTML-centric [^hateoas] of HTMX makes
the other components of the HARM stack (Axum/AlpineJS, Rust, Maud) pretty
expandable. Making technical comparison of each component can be a quite
extensive topic, but I'll try in the hope that even if you don't think my
opinion is that useful, you can compare the alternatives yourself. For the
post's length (it's being around 3,000 words already) and my own ability reason
(I've only started dabbling in Rust for the last month and don't have enough
exposure to the whole ecosystem), I can only cover some part of the stack,
namely AlpineJS and Maud, but I hope you get the general idea.

### Lightweight JS Frameworks for Client State

Let's define a "lightweight framework" with two properties:

- The bundle size minified + gzipped is less than 100kb
- It is usable without a build step (be embedable directly in HTML header)

You (un)suprisingly get a ton of choices, as this is the JavaScript world. Here
is an incomplete list [^lightweight-js-framework-term]:

- VueJS: https://vuejs.org/
- JQuery: https://jquery.com
- Hyperscript: https://hyperscript.org/
- AlpineJS: https://alpinejs.dev/
- PreactJS: https://preactjs.com/
- ReactJS: https://react.dev/
- SurrealJS: https://github.com/gnat/surreal

And the corresponding size table [^lightweight-js-size-comparison]:

| Size | Framework                                                                                                                                         |
| ---  | ---                                                                                                                                               |
| 45kb | [VueJS](https://bundlephobia.com/package/vue@3.5.13)                                                                                              |
| 30kb | [JQuery](https://bundlephobia.com/package/jquery@3.7.1)                                                                                           |
| 25kb | [Hyperscript](https://bundlephobia.com/package/hyperscript.org@0.9.13)                                                                            |
| 15kb | [AlpineJS](https://bundlephobia.com/package/alpinejs@3.14.8)                                                                                      |
| 5kb  | [PreactJS](https://bundlephobia.com/package/preact@10.25.4)                                                                                       |
| 4kb  | ReactJS ([React](https://bundlephobia.com/package/react@19.0.0) + [ReactDOM](https://bundlephobia.com/package/react-dom@19.0.0)) [^react-surprise] |
| ?kb  | SurrealJS [^surreal-js-missing-size]                                                                                                              |

For easier evaluation, I think it's good to summarize them using a four-quadrant
chart, where the x-axis is how imperative/declarative the framework is, and the
y-axis is how "close" the framework is to vanilla JavaScript. There is also
coloring by popularity as well.

![](../images/harm-stack-lightweight-js-frameworks.png)

In general, you won't go wrong with popular frameworks (JQuery, VueJS, and
ReactJS), as they are well-established: edge cases should be covered and issues
are easily searched and the docs are good. JQuery is old and uncool, but it
should be qualified. You might question why did I put Vue and React to this
category, as the framework side of them (usage of NextJS, NuxtJS, etc.) seems to
be more popular. I would say that they qualified since despite the framework
endorsement from their official docs, we can embed their build
[^vue-single-file-build] [^react-single-file-build] in our HTML header. However,
I won't really endose React, as it goes more into the DSL category with JSX. The
same goes for Preact, and the case is even stronger for Hyperscript: it is a
full fledged DSL that I'm too lazy to grok right now.

My personal pick is Alpine, as the declarative nature is good, and its
simplicity sold well. It has a moderated-size community, but shouldn't be a
problem if we keep out client-size JS simple. If I'm in the mood for an
adventure, I'll reach out to Surreal, as it seems like an interesting child of
Hyperscript and JQuery.

### HTML Generation

An HTML-centric UI obviously needs some way to... generate the HTML. We can
split HTML generation to two camps:

- HTML Templating: render directly from a `.html` file with special embedded
  syntax for variables (Jinja or Mako)
- DSL for HTML Generation: use Rust macro to generate HTML

I would summarize the pros and cons of the two camps using a table like this:

|      | HTML Templating                                                          | HTML Generation DSL                               |
| ---  | ---                                                                      | ---                                               |
| Pros | - Well-established community [^are-we-web-yet] [^popularity-measurement] | - Less context-switching                          |
|      | - IDE syntax highlighting for JS                                         | - Type checking                                   |
| Cons | - No/limited type checking                                               | - Less-established community                      |
|      | - Complex in-template logics                                             | - Can be a leaky abstraction [^leaky-abstraction] |

We can see that some strong points of DSL are the weak points of Templating, and
vice versa. I don't have a good answer on how should we pick each. In the end, I
chose Maud, as it seems to be well-maintained and overall make my program has
less moving parts (instead of splitting the HTML to another file, I can just
write it in a Rust file). The leaky abstraction aspect, despite the annoyance,
is acceptable [^leaky-abstraction-dsl-example].

We can refer to the counter above, but for the sake of convenience, I'll include
another example:

```rust
pub async fn page() -> Markup {
    html! {
        (header("Temperature Converter"))
        body {
            h1 { "Temperature Converter" }
            form x-data="{ celsius: 0, fahrenheit: 32 }" {
                fieldset {
                    label {
                        "Celsius: "
                        input
                            x-model="celsius"
                            "@keyup"="fahrenheit = (celsius * (9 / 5)) + 32"
                            type="number"
                            name="celsius";
                    }
                    label {
                        "Fahrenheit: "
                        input
                            x-model="fahrenheit"
                            "@keyup"="celsius = (fahrenheit - 32) * (5 / 9)"
                            type="number"
                            name="fahrenheit";
                    }
                }
            }
            (home_back_link())
        }
    }
}
```

Where the end result looks like this:

![](../images/harm-stack-temperature-converter-demo.png)

## Conclusion

I hope that it was an enjoyable and useful read, and by the time you reached
this section, you are urged to checkout HTMX and play with the HARM Stack (or
try HTMX within your favorite language, whatever it is). A wise man once said
"simple is not easy" [^simple-is-not-easy], and I fully think it is the case
with HTMX.

[^ssr-csr-cycle]: Surprisingly, I couldn't really find the origin take on this.
    I would really love it if anyone can point me to a reliable source. There is
    a similar, but not entirely related is a post named "The Configuration
    Complexity Clock":
    https://mikehadlow.blogspot.com/2012/05/configuration-complexity-clock.html
[^spa-complaints-1]:
    https://stackoverflow.blog/2021/12/28/what-i-wish-i-had-known-about-single-page-applications/
[^spa-complaints-2]:
    https://adamsilver.io/blog/the-problem-with-single-page-applications/
[^complexity]:
    https://web.stanford.edu/~ouster/cgi-bin/cs190-winter18/lecture.php?topic=complexity
[^hateoas]: A more "traditional" term for this is HATEOAS, or Hypertext As The
    Engine Of Application State: https://htmx.org/essays/hateoas/
[^python-ecosystem-mess]: it's another mess where we have `poetry` and
    `piptools` and `uv` as "The One To Rule Them All", hopefully.
[^htmx-trade-offs]: https://htmx.org/essays/when-to-use-hypermedia/
[^htmx-thought-process]:
    https://www.reddit.com/r/htmx/comments/1axyqbc/my_thought_process_on_when_and_why_htmx_is_the/
[^unexpected-bug-1]: I once had a bug where a property of a shared model has the
    type `Date` correctly in the backend, but somehow gets turned into `string`
    in the frontend. It is because the backend and the frontend still
    communicate through JSON, and there is no `Date` type in JSON. When the data
    gets transmitted from backend to frontend using text `JSON.stringify`, the
    backend's `Date` gets turned into `string`, and I forgot handling that.
[^react-related]: It suprised me on how think this can be quite similar to
    React's model, `view = f(state)`, or even Elm Architecture, `view =
    update(model, state)`.
[^ssr-suspicion]: In fact, I'm strongly suspected that this is one core issue
    why CSR was pushed as an alternative to SSR in the first place.
[^matcha-css]: https://matcha.mizu.sh/
[^counter-demo]: I know that this example is silly and cannot really demonstrate
    HTMX's full power. I considered showcasing a CRUD form, but feel like it's
    going to derail us on technical implementation more than the idea of HTMX.
    If you are really interested, feel free to look at this code and its demo on
    GitHub:
    https://github.com/thanhnguyen2187/playground/tree/master/seven-guis-htmx-axum-rust-maud
[^hyperview]: https://hyperview.org/
[^htmx-silver-bullet]: Or it's really painful to go the "pure-HTMX way". I can
    imagine having an endpoint for dark mode, but I would really question my own
    sanity when I have to do that.
[^lightweight-js-framework-term]: I know using the umbrella term "framework" for
    all "framework", "library", and "DSL" is not good semantically, but I did
    that anyway to simplify my writing.
[^lightweight-js-size-comparison]: To be honest, I'm not sure if my method of
    using Bundlephobia is correct nor a good one. Feel free to let me know if
    there is a better way. I considered using `curl -L -I` and look at
    `Content-Length`, but it didn't work for Vue, so I gave up.
[^react-surprise]: I'm really surprised by this result, where React's size is
    that tiny and even beat Preact.
[^surreal-js-missing-size]: I couldn't find a reliable way to measure Surreal's
    size, but from the tiny code base, I would put it even lower than 4kb.
[^vue-single-file-build]: You can find the link from the official docs:
    https://vuejs.org/guide/quick-start.html#using-vue-from-cdn. There is an
    explanation on how to use Vue that touched this as well:
    https://vuejs.org/guide/extras/ways-of-using-vue.html
[^react-single-file-build]: Now, React recommends using a full framework like
    NextJS instead of using a minimal amount of React. How to use React
    incrementally is considered legacy:
    https://legacy.reactjs.org/docs/add-react-to-a-website.html
[^are-we-web-yet]: https://www.arewewebyet.org/topics/templating
[^popularity-measurement]: I'm basing popularity/community by download count,
    which is a lazy way, but it should be good enough for our case.
[^leaky-abstraction]:
    https://www.joelonsoftware.com/2002/11/11/the-law-of-leaky-abstractions/
[^leaky-abstraction-dsl-example]: Let's say I pair Maud with AlpineJS. As Alpine
    uses `@click` to handle clicking events, it clashes with Maud's usage of `@`
    to prefix Rust control flows like `@if`, `@match`, and `@for`. We have to
    work around it by wrapping `@click` within double quotation marks
    `"@click"`. I consider this to be leaky as we have to understand that Maud's
    macro is generating text, so we have to escape special cases like that using
    double quotation marks.
[^simple-is-not-easy]: The wise man is Rich Hickey and his talk is "Simple Made
    Easy":
    [https://www.youtube.com/watch?v=SxdOUGdseq4](https://www.youtube.com/watch?v=dQw4w9WgXcQ)
