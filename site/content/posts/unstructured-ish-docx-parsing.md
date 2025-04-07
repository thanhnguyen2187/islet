---
title: "Unstructured-ish DOCX Parsing in TypeScript/NodeJS"
date: 2025-04-05T19:18:46+07:00
draft: false
toc: true
tags:
- docx-parsing
- nodejs
- javascript
- typescript
- xpath
categories:
- explanation
---

I recently took in a freelancing project, and one particularly interesting task
is to convert unstructured-ish DOCX files to structured data, let's say JSON.
Intially, I estimated that it should only take me around 2 days for the
implementation. I know what are you thinking. You are right that:

> [...] overconfidence is a slow and insidious killer. [^darkest-dungeon]

In the end, the task took me more than 5 days to complete. Reflecting on it,
apart from being reminded that I shouldn't underestimate technical challenges I
haven't seen before, I also think my approach is a good language-agnostic way to
deal with DOCX file and convert unstructured-ish data to structured data.

I used the word "unstructured-ish" in the sense that it's generated from another
server with clear structure: in each file there are multiple articles; each
article lays out title, then author, then other information, then a summary at
the end. However, the format of the articles in those files can be different:
some misses author or even have multiple authors; some has commentary instead of
summary; etc. While there is essential complexity
[^accidental-and-essential-complexity] for that part of the work, I think the
accidental complexity [^accidental-and-essential-complexity] is interesting as
well. Let's explore both in this post.

## NodeJS is popular, and has a rich ecosystem...

Until you try to hunt down the "perfect" library to parse DOCX files.

- `officeparser` [^officeparser] only gives the text. It falls short as there
  are multiple articles within one file, and text-only wouldn't help.
- `docx4js` [^docx4js] seems to be better, but I couldn't dig out the text-input
  entry (the main function receives a file). It doesn't have type definition for
  TypeScript usage, which further stops me from using it.
- `docx` [^docx-nodejs]: the library is popular and is the first one that'll
  appear on your search, but it seems to be more focused on DOCX file
  creation.

After browsing for a while and gaining a rudimentary understanding that a DOCX
file is just a bunch of XML files compressed in the ZIP format, I reluctantly
decided to roll my own solution. It seems to be easy enough: the main file that
I'll have to look at is `document.xml`.

I'm not overconfident at rolling my own XML parser, however. There is
`fast-xml-parser` [^fast-xml-parser] to turn XML to Javascript object, but the
original XML is complicated enough. Let's look at this example from the
library's docs:

```ts
const xmlDataStr = `
    <root a="nice" checked>
        <a>wow</a>
        <a>
          wow again
          <c> unlimited </c>
        </a>
        <b>wow phir se</b>
    </root>`;  

const options = {
    ignoreAttributes: false,
    alwaysCreateTextNode: true
};
const parser = new XMLParser(options);
const output = parser.parse(xmlDataStr);
```

```json
{
    "root": {
        "a": [
            {
                "#text": "wow"
            },
            {
                "c": {
                    "#text": "unlimited"
                },
                "#text": "wow again"
            }
        ],
        "b": {
            "#text": "wow phir se"
        },
        "@_a": "nice"
    }
}
```

Imagine how would it look using the "real-life" XML from DOCX files:

```xml
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<w:document xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main" ...>
  <w:body>
    <w:p>
      <w:pPr>
        <w:pBdr></w:pBdr>
        <w:spacing w:after="200" w:before="120" w:line="276" w:lineRule="auto"/>
        <w:ind w:right="0" w:firstLine="0" w:left="0"/>
        <w:jc w:val="both"/>
        <w:rPr>
          <w:rFonts w:ascii="Times New Roman" w:hAnsi="Times New Roman" w:eastAsia="Times New Roman" w:cs="Times New Roman"/>
          <w:sz w:val="12"/>
          <w:szCs w:val="12"/>
        </w:rPr>
      </w:pPr>
      <w:r>
        <w:rPr>
          <w:rFonts w:ascii="Times New Roman" w:hAnsi="Times New Roman" w:eastAsia="Times New Roman" w:cs="Times New Roman"/>
          <w:b/>
          <w:bCs/>
          <w:sz w:val="12"/>
          <w:szCs w:val="12"/>
        </w:rPr>
        <w:t xml:space="preserve">Author: </w:t>
      </w:r>
      <w:r>
        <w:rPr>
          <w:rFonts w:ascii="Times New Roman" w:hAnsi="Times New Roman" w:eastAsia="Times New Roman" w:cs="Times New Roman"/>
          <w:sz w:val="12"/>
          <w:szCs w:val="12"/>
        </w:rPr>
        <w:t xml:space="preserve">John Doe</w:t>
      </w:r>
      <w:r>
        <w:rPr>
          <w:rFonts w:ascii="Times New Roman" w:hAnsi="Times New Roman" w:eastAsia="Times New Roman" w:cs="Times New Roman"/>
          <w:sz w:val="12"/>
          <w:szCs w:val="12"/>
        </w:rPr>
      </w:r>
    </w:p>
    ...
  </w:body>
</w:document>
```

I envisioned myself going through the path of converting XML to JSON, and
thought that I would need a query language as the data would be complex. Then I
realized the complexity of the data is there, no matter what I do. A more
straightforward way is to work with the XML, and the query language to use is
`xpath` [^xpath-js].

## Turning unstructured data into structured data

We get closer to the finish line having the XML file and XPath to check the
structure/content. Explore the XML content in more details, I found out that I
can split the file into nodes groups corresponding to the articles.

```ts
const _xpath = xpath.useNamespaces({
  w: "http://schemas.openxmlformats.org/wordprocessingml/2006/main",
});

export function isSeparator(node: Node): boolean {
  const foundNodes = _xpath("w:pPr/w:sectPr/*", node) as [];
  return foundNodes.length > 0;
}

export function splitNodes(nodes: Node[]): Node[][] {
  const result: Node[][] = [[]];

  for (const node of nodes) {
    if (isSeparator(node)) {
      result.push([node]);
    } else {
      result[result.length - 1].push(node);
    }
  }

  return result;
}
```

We now come to the core challenge: to turn the nodes within the articles into
structured data. As I've mentioned in the beginning, the articles have different
formats: one has author, while another doesn't, and another has multiple
authors. They have different ending as well: one is summarized, and another is
commented on. Long gone are my Lisp'ing days with SICP, but the knowledge about
"parser" part within an interpreter/compiler stayed. This is inherently a
parsing problem: we have nodes (as tokens), and the parser would read them one
by one, then checks and changes its state to accomodate.

![](../images/docx-state-machine.png)

I find that instead of implementing the code imperatively, using a parser with
explicit state makes logging/error handling/logic modification much more
bearable. There is only one final annoyance of NodeJS/Javascript land: we don't
have built-in pattern matching [^ts-match]. I suppose we can do it like this:

```ts
if (stateCurrent === "Initial" && isTitle(node)) {
    ...
} else if (...) {
    ...
} else {
    ...
}
```

For aesthetic reasons, I prefer `switch(true)`:

```ts
switch (true):
    case ...:
    {
        ...
    }
    break;
    default:
        ...
```

Which leads to this implementation:

```ts
export function advanceState({
    stateCurrent,
    node,
    article,
}: {
    stateCurrent: ParserState,
    node: Node,
    article: ArticleRaw,
}) {
    let stateNew = stateCurrent;
    switch (true) {
        case stateCurrent === "Initial" && isTitle(node):
            {
                // I "cheated" a bit by mutating the article for performance
                // reason. A purer functional approach would create a new
                // article with the extracted title.
                article.title = extractTitle(node);
                stateNew = "ParsedTitle";
            }
            break;
        case (stateCurrent === "ParsedTitle" || stateCurrent === "ParsedAuthor")
            && isAuthor(node):
            {
                article.authors.push(extractAuthor(node));
                stateNew = "ParsedAuthor";
            }
            break;
        case ...:
            {
                ...
            }
            break;
        default:
            throw new Error({
                message: "invalid node",
                state: stateCurrent,
                nodeTextContent: node.textContent ?? "",
            })
    }
    return {
        stateNew,
        article,
    }
}
```

In the end I implemented `createNodesParseFn` as a higher-order function to
ensure that the created `parse` has state. `parseRawText` and `parseDocx` are
wrappers for the actual functionality.

```ts
export function createNodesParseFn() {
  let state: ParserState = "Initial";
  let article: ArticleRaw = {
    title: "",
    author: "",
    ...
  };
  return (nodes: Node[]): [ParserState, ArticleRaw] => {
    for (const node of nodes) {
      const advancedState = advanceState({
        stateCurrent: state,
        node,
        article,
      });
      state = advancedState.stateNew;
      article = advancedState.article;
    }
    return [state, article as ArticleRaw];
  };
}

export function parseRawText(rawText: string): Node[] {
  const doc = new DOMParser().parseFromString(rawText, "text/xml");
  // @ts-ignore
  return _xpath("/w:document/w:body/*", doc) as Node[];
}

export function parseDocx(docx: Buffer) {
  const zip = new AdmZip(docx);
  const text = zip.readAsText("word/document.xml");
  const nodes = parseRawText(text);
  const nodesSplit = splitNodes(nodes);
  return nodesSplit.map((nodes) => {
    const parseNodes = createNodesParseFn();
    return parseNodes(nodes);
  });
}
```

## Conclusion

I hope that this post is useful on showing you a language-agnostic approach to
DOCX parsing:

- Decompress the file
- Read `document.xml`
- Use XPath to extract data/structure of the XML file(s)

And the implementation of a stateful parser to turn unstructured-ish data to
structured data.

Back to the journey that I traveled to finish the task (which is more convoluted
in reality, like the actual code implementation handle much more cases), it made
me really reflect on the nature of accidental and essential complexity.
Something is essential because it is unavoidable, but can we... avoid the
accidental part?

I then came to the verdict that it seems hard, if not impossible. Experience
helps, but no one has experience in everything. It's "accidental" because we
cannot foresee it. On our side, or at least my side, we should prevent ourselves
from underestimating "seemingly new" problems we face. Thinking about both types
of complexity before solving a problem helps.

[^darkest-dungeon]: It's a quote from [Darkest
    Dungeon](https://www.darkestdungeon.com/), one of my most favorite games.
    It's a shame that the narrator, whose voice was still in my head, [passed
    away
    recently](https://www.pcgamer.com/games/wayne-june-famed-narrator-of-the-darkest-dungeon-games-has-died/).
[^accidental-and-essential-complexity]: The terms are coined by Fred Brooks in
    his essay [No Silver
    Bullet](https://worrydream.com/refs/Brooks_1986_-_No_Silver_Bullet.pdf).
    "Accidental complexity" is about the challenges from the
    tooling/environment/past decision of the engineer, while "essential
    complexity" is about the inherent challenges of problem solving, in which we
    have to resolve no matter what tool we use.
[^officeparser]: https://www.npmjs.com/package/officeparser
[^docx4js]: https://www.npmjs.com/package/docx4js
[^ts-match]: While I'm aware that a library for pattern matching exists,
    https://www.npmjs.com/package/ts-match, I'm not inclined on its usage for
    additional dependency and performance reasons.
[^docx-nodejs]: https://www.npmjs.com/package/docx
[^fast-xml-parser]: https://www.npmjs.com/package/fast-xml-parser
[^xpath-js]: https://www.npmjs.com/package/xpath
