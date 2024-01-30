+++
title = "SIL Grammar"
template = "static.html"
date = "1970-01-01"
+++

SILE accepts input in several formats.
One is XML.
Yes, just XML, no special input language required.
Use any tooling you want to create XML.
You can either target SILE's commands with XML tags or provide a module that handles the tag schema in your document.

Secondarily for those that want it, a custom intput syntax can be used that is somewhat less verbose and easier to type than XML.

We call it the SIL format (Sile Input Language).

## Parsers

The current official reference parser is the Lua LPEG based EPNF variant found in [inputters/sil-epnf.lua](https://github.com/sile-typesetter/sile/blob/develop/inputters/sil-epnf.lua).
Recently we've been working to define a formal grammar spec using ABNF syntax.
The current version of this is distributed as [sil.abnf](https://github.com/sile-typesetter/sile/blob/develop/sil.abnf) along with SILE sources.

<details>
<summary>sil.abnf</summary>

```abnf
; Formal grammar specification for SIL (SILE Input Language) files
;
; Uses RFC 5234 (Augmented BNF for Syntax Specifications: ABNF)
; Uses RFC 7405 (Case-Sensitive String Support in ABNF)

; IMPORTANT CAVEAT:
; Backus-Naur Form grammars (like ABNF and EBNF) do not have a way to
; express matching opening and closing tags. The grammar below does
; not express SILE's ability to skip over passthrough content until
; it hits the matching closing tag for environments.

; A master document can only have one top level content item, but we allow
; loading of fragments as well which can have any number of top level content
; items, hence valid grammar can be any number of content items.
document = *content

; Top level content can be any sequence of these things
content =  environment
content =/ comment
content =/ text
content =/ braced-content
content =/ command

; Environments come in two flavors, passthrough (raw) and regular. The
; difference is what is allowed to terminate them and what escapes are needed
; for the content in the middle.
environment =  %s"\begin" [ options ] "{" passthrough-command-id "}"
               env-passthrough-text
               %s"\end{" passthrough-command-id "}"
               ;         ^^^^^^^^^^^^^^^^^^^^^^
               ; End command must match id used in begin, see caveat at top
environment =/ %s"\begin" [ options ] "{" command-id "}"
               content
               %s"\end{" command-id "}"
               ;         ^^^^^^^^^^
               ; End command must match id used in begin, see caveat at top

; Passthrough (raw) environments can have any valid UTF-8 except the closing
; delimiter matching the opening, per the environment rule.
env-passthrough-text = *utf8-char

; Nothing to see here.
; But potentially important because it eats newlines!
comment = "%" *utf8-char CRLF

; Input strings that are not special
text = *text-char

; Input content wrapped in braces can be attached to a command or used to
; manually isolate chunks of content (e.g. to hinder ligatures).
braced-content = "{" content "}"

; As with environments, the content format may be passthrough (raw) or more SIL
; content depending on the command.
command =  "\" passthrough-command-id [ options ] [ braced-passthrough-text ]
command =/ "\" command-id [ options ] [ braced-content ]

; Passthrough (raw) command text can have any valid UTF-8 except an unbalanced
; closing delimiter
braced-passthrough-text = "{"
                          *( braced-passthrough-text / braced-passthrough-char )
                          "}"

braced-passthrough-char =  %x00-7A ; omit {
braced-passthrough-char =/ %x7C    ; omit }
braced-passthrough-char =/ %x7E-7F ; end of utf8-1
braced-passthrough-char =/ utf8-2
braced-passthrough-char =/ utf8-3
braced-passthrough-char =/ utf8-4

options = "[" parameter *( "," parameter ) "]"
parameter = *WSP identifier *WSP "=" *WSP ( quoted-value / value ) *WSP

quoted-value = DQUOTE *quoted-value-char DQUOTE
quoted-value-char = "\" %x22
quoted-value-char =/ %x00-21 ; omit "
quoted-value-char =/ %x23-7F ; end of utf8-1
quoted-value-char =/ utf8-2
quoted-value-char =/ utf8-3
quoted-value-char =/ utf8-4

value = *value-char
value-char =  %x00-21 ; omit "
value-char =/ %x23-2B ; omit ,
value-char =/ %x3C-5C ; omit ]
value-char =/ %x3E-7F ; end of utf8-1
value-char =/ utf8-2
value-char =/ utf8-3
value-char =/ utf8-4

text-char =  "\" ( %x5C / %x25 / %x7B / %x7D )
text-char =/ %x00-24 ; omit %
text-char =/ %x26-5B ; omit \
text-char =/ %x5D-7A ; omit {
text-char =/ %x7C    ; omit }
text-char =/ %x7E-7F ; end of utf8-1
text-char =/ utf8-2
text-char =/ utf8-3
text-char =/ utf8-4

letter = ALPHA / "_" / ":"
identifier = letter *( letter / DIGIT / "-" / "." )
passthrough-command-id = %s"ftl"
                       / %s"lua"
                       / %s"math"
                       / %s"raw"
                       / %s"script"
                       / %s"sil"
                       / %s"use"
                       / %s"xml"
command-id = identifier

; ASCII isn't good enough for us.
utf8-char = utf8-1 / utf8-2 / utf8-3 / utf8-4
utf8-1    = %x00-7F
utf8-2    = %xC2-DF utf8-tail
utf8-3    = %xE0 %xA0-BF utf8-tail
          / %xE1-EC 2utf8-tail
          / %xED %x80-9F utf8-tail
          / %xEE-EF 2utf8-tail
utf8-4    = %xF0 %x90-BF 2utf8-tail
          / %xF1-F3 3utf8-tail
          / %xF4 %x80-8F 2utf8-tail
utf8-tail = %x80-BF
```

</details>

This grammar can be converted to a W3C EBNF grammar:

<details>
<summary>sil.ebnf</summary>

```ebnf
document ::= content*

content  ::= environment
           | comment
           | text
           | braced-content
           | command

environment
         ::= '\begin' options? '{' passthrough-command-id '}' env-passthrough-text '\end{' passthrough-command-id '}'
           | '\begin' options? '{' command-id '}' content '\end{' command-id '}'

env-passthrough-text
         ::= utf8-char*

comment  ::= '%' utf8-char* CRLF

text     ::= text-char*

braced-content
         ::= '{' content '}'

command  ::= '\' passthrough-command-id options? braced-passthrough-text?
           | '\' command-id options? braced-content?

braced-passthrough-text
         ::= '{' ( braced-passthrough-text | braced-passthrough-char )* '}'

braced-passthrough-char
         ::= [#x0-#x7A]
           | '|'
           | [#x7E-#x7F]
           | utf8-2
           | utf8-3
           | utf8-4

options  ::= '[' parameter ( ',' parameter )* ']'

parameter
         ::= WSP* identifier WSP* '=' WSP* ( quoted-value | value ) WSP*

quoted-value
         ::= DQUOTE quoted-value-char* DQUOTE

quoted-value-char
         ::= '\' '"'
           | [#x0-#x21]
           | [#x23-#x7F]
           | utf8-2
           | utf8-3
           | utf8-4

value    ::= value-char*

value-char
         ::= [#x0-#x21]
           | [#x23-#x2B]
           | [<-\]
           | [#x3E-#x7F]
           | utf8-2
           | utf8-3
           | utf8-4

text-char
         ::= '\' ( '\' | '%' | '{' | '}' )
           | [#x0-#x24]
           | [&-[]
           | [#x5D-#x7A]
           | '|'
           | [#x7E-#x7F]
           | utf8-2
           | utf8-3
           | utf8-4

letter   ::= ALPHA
           | '_'
           | ':'

identifier
         ::= letter ( letter | DIGIT | '-' | '.' )*

passthrough-command-id
         ::= 'ftl'
           | 'lua'
           | 'math'
           | 'raw'
           | 'script'
           | 'sil'
           | 'use'
           | 'xml'

command-id
         ::= identifier

utf8-char
         ::= utf8-1
           | utf8-2
           | utf8-3
           | utf8-4

utf8-1   ::= [#x0-#x7F]

utf8-2   ::= [#xC2-#xDF] utf8-tail

utf8-3   ::= #xE0 [#xA0-#xBF] utf8-tail
           | [#xE1-#xEC] utf8-tail utf8-tail
           | #xED [#x80-#x9F] utf8-tail
           | [#xEE-#xEF] utf8-tail utf8-tail

utf8-4   ::= #xF0 [#x90-#xBF] utf8-tail utf8-tail
           | [#xF1-#xF3] utf8-tail utf8-tail utf8-tail
           | #xF4 [#x80-#x8F] utf8-tail utf8-tail

utf8-tail
         ::= [#x80-#xBF]
```

</details>

## Railroad digrams and EBNF snippets

What followes is EBNF grammar snippets and railroad diagrams for the syntax.

<!--
ebnf-convert -f none sil.abnf | ebnf-rr -nofactoring -noinline -noepsilon -md -
-->

----

**document:**

![document](data:image/svg+xml,%3Csvg%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%20width%3D%22167%22%20height%3D%2257%22%3E%3Cdefs%3E%3Cstyle%20type%3D%22text%2Fcss%22%3E%40namespace%20%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%3B%20.line%20%7Bfill%3A%20none%3B%20stroke%3A%20%23332900%3B%20stroke-width%3A%201%3B%7D%20.bold-line%20%7Bstroke%3A%20%23141000%3B%20shape-rendering%3A%20crispEdges%3B%20stroke-width%3A%202%3B%7D%20.thin-line%20%7Bstroke%3A%20%231F1800%3B%20shape-rendering%3A%20crispEdges%7D%20.filled%20%7Bfill%3A%20%23332900%3B%20stroke%3A%20none%3B%7D%20text.terminal%20%7Bfont-family%3A%20Verdana%2C%20Sans-serif%3B%20font-size%3A%2012px%3B%20fill%3A%20%23141000%3B%20font-weight%3A%20bold%3B%20%7D%20text.nonterminal%20%7Bfont-family%3A%20Verdana%2C%20Sans-serif%3B%20font-size%3A%2012px%3B%20fill%3A%20%231A1400%3B%20font-weight%3A%20normal%3B%20%7D%20text.regexp%20%7Bfont-family%3A%20Verdana%2C%20Sans-serif%3B%20font-size%3A%2012px%3B%20fill%3A%20%231F1800%3B%20font-weight%3A%20normal%3B%20%7D%20rect%2C%20circle%2C%20polygon%20%7Bfill%3A%20%23332900%3B%20stroke%3A%20%23332900%3B%7D%20rect.terminal%20%7Bfill%3A%20%23FFDB4D%3B%20stroke%3A%20%23332900%3B%20stroke-width%3A%201%3B%7D%20rect.nonterminal%20%7Bfill%3A%20%23FFEC9E%3B%20stroke%3A%20%23332900%3B%20stroke-width%3A%201%3B%7D%20rect.text%20%7Bfill%3A%20none%3B%20stroke%3A%20none%3B%7D%20polygon.regexp%20%7Bfill%3A%20%23FFF4C7%3B%20stroke%3A%20%23332900%3B%20stroke-width%3A%201%3B%7D%3C%2Fstyle%3E%3C%2Fdefs%3E%3Cpolygon%20points%3D%229%2051%201%2047%201%2055%22%2F%3E%3Cpolygon%20points%3D%2217%2051%209%2047%209%2055%22%2F%3E%3Crect%20x%3D%2251%22%20y%3D%223%22%20width%3D%2268%22%20height%3D%2232%22%2F%3E%3Crect%20x%3D%2249%22%20y%3D%221%22%20width%3D%2268%22%20height%3D%2232%22%20class%3D%22nonterminal%22%2F%3E%3Ctext%20class%3D%22nonterminal%22%20x%3D%2259%22%20y%3D%2221%22%3Econtent%3C%2Ftext%3E%3Cpath%20class%3D%22line%22%20d%3D%22m17%2051%20h2%20m20%200%20h10%20m0%200%20h78%20m-108%200%20l20%200%20m-1%200%20q-9%200%20-9%20-10%20l0%20-14%20q0%20-10%2010%20-10%20m88%2034%20l20%200%20m-20%200%20q10%200%2010%20-10%20l0%20-14%20q0%20-10%20-10%20-10%20m-88%200%20h10%20m68%200%20h10%20m23%2034%20h-3%22%2F%3E%3Cpolygon%20points%3D%22157%2051%20165%2047%20165%2055%22%2F%3E%3Cpolygon%20points%3D%22157%2051%20149%2047%20149%2055%22%2F%3E%3C%2Fsvg%3E)

```
document ::= content*
```

**content:**

![content](data:image/svg+xml,%3Csvg%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%20width%3D%22215%22%20height%3D%22213%22%3E%3Cdefs%3E%3Cstyle%20type%3D%22text%2Fcss%22%3E%40namespace%20%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%3B%20.line%20%7Bfill%3A%20none%3B%20stroke%3A%20%23332900%3B%20stroke-width%3A%201%3B%7D%20.bold-line%20%7Bstroke%3A%20%23141000%3B%20shape-rendering%3A%20crispEdges%3B%20stroke-width%3A%202%3B%7D%20.thin-line%20%7Bstroke%3A%20%231F1800%3B%20shape-rendering%3A%20crispEdges%7D%20.filled%20%7Bfill%3A%20%23332900%3B%20stroke%3A%20none%3B%7D%20text.terminal%20%7Bfont-family%3A%20Verdana%2C%20Sans-serif%3B%20font-size%3A%2012px%3B%20fill%3A%20%23141000%3B%20font-weight%3A%20bold%3B%20%7D%20text.nonterminal%20%7Bfont-family%3A%20Verdana%2C%20Sans-serif%3B%20font-size%3A%2012px%3B%20fill%3A%20%231A1400%3B%20font-weight%3A%20normal%3B%20%7D%20text.regexp%20%7Bfont-family%3A%20Verdana%2C%20Sans-serif%3B%20font-size%3A%2012px%3B%20fill%3A%20%231F1800%3B%20font-weight%3A%20normal%3B%20%7D%20rect%2C%20circle%2C%20polygon%20%7Bfill%3A%20%23332900%3B%20stroke%3A%20%23332900%3B%7D%20rect.terminal%20%7Bfill%3A%20%23FFDB4D%3B%20stroke%3A%20%23332900%3B%20stroke-width%3A%201%3B%7D%20rect.nonterminal%20%7Bfill%3A%20%23FFEC9E%3B%20stroke%3A%20%23332900%3B%20stroke-width%3A%201%3B%7D%20rect.text%20%7Bfill%3A%20none%3B%20stroke%3A%20none%3B%7D%20polygon.regexp%20%7Bfill%3A%20%23FFF4C7%3B%20stroke%3A%20%23332900%3B%20stroke-width%3A%201%3B%7D%3C%2Fstyle%3E%3C%2Fdefs%3E%3Cpolygon%20points%3D%229%2017%201%2013%201%2021%22%2F%3E%3Cpolygon%20points%3D%2217%2017%209%2013%209%2021%22%2F%3E%3Crect%20x%3D%2251%22%20y%3D%223%22%20width%3D%22100%22%20height%3D%2232%22%2F%3E%3Crect%20x%3D%2249%22%20y%3D%221%22%20width%3D%22100%22%20height%3D%2232%22%20class%3D%22nonterminal%22%2F%3E%3Ctext%20class%3D%22nonterminal%22%20x%3D%2259%22%20y%3D%2221%22%3Eenvironment%3C%2Ftext%3E%3Crect%20x%3D%2251%22%20y%3D%2247%22%20width%3D%2278%22%20height%3D%2232%22%2F%3E%3Crect%20x%3D%2249%22%20y%3D%2245%22%20width%3D%2278%22%20height%3D%2232%22%20class%3D%22nonterminal%22%2F%3E%3Ctext%20class%3D%22nonterminal%22%20x%3D%2259%22%20y%3D%2265%22%3Ecomment%3C%2Ftext%3E%3Crect%20x%3D%2251%22%20y%3D%2291%22%20width%3D%2244%22%20height%3D%2232%22%2F%3E%3Crect%20x%3D%2249%22%20y%3D%2289%22%20width%3D%2244%22%20height%3D%2232%22%20class%3D%22nonterminal%22%2F%3E%3Ctext%20class%3D%22nonterminal%22%20x%3D%2259%22%20y%3D%22109%22%3Etext%3C%2Ftext%3E%3Crect%20x%3D%2251%22%20y%3D%22135%22%20width%3D%22116%22%20height%3D%2232%22%2F%3E%3Crect%20x%3D%2249%22%20y%3D%22133%22%20width%3D%22116%22%20height%3D%2232%22%20class%3D%22nonterminal%22%2F%3E%3Ctext%20class%3D%22nonterminal%22%20x%3D%2259%22%20y%3D%22153%22%3Ebraced-content%3C%2Ftext%3E%3Crect%20x%3D%2251%22%20y%3D%22179%22%20width%3D%2280%22%20height%3D%2232%22%2F%3E%3Crect%20x%3D%2249%22%20y%3D%22177%22%20width%3D%2280%22%20height%3D%2232%22%20class%3D%22nonterminal%22%2F%3E%3Ctext%20class%3D%22nonterminal%22%20x%3D%2259%22%20y%3D%22197%22%3Ecommand%3C%2Ftext%3E%3Cpath%20class%3D%22line%22%20d%3D%22m17%2017%20h2%20m20%200%20h10%20m100%200%20h10%20m0%200%20h16%20m-156%200%20h20%20m136%200%20h20%20m-176%200%20q10%200%2010%2010%20m156%200%20q0%20-10%2010%20-10%20m-166%2010%20v24%20m156%200%20v-24%20m-156%2024%20q0%2010%2010%2010%20m136%200%20q10%200%2010%20-10%20m-146%2010%20h10%20m78%200%20h10%20m0%200%20h38%20m-146%20-10%20v20%20m156%200%20v-20%20m-156%2020%20v24%20m156%200%20v-24%20m-156%2024%20q0%2010%2010%2010%20m136%200%20q10%200%2010%20-10%20m-146%2010%20h10%20m44%200%20h10%20m0%200%20h72%20m-146%20-10%20v20%20m156%200%20v-20%20m-156%2020%20v24%20m156%200%20v-24%20m-156%2024%20q0%2010%2010%2010%20m136%200%20q10%200%2010%20-10%20m-146%2010%20h10%20m116%200%20h10%20m-146%20-10%20v20%20m156%200%20v-20%20m-156%2020%20v24%20m156%200%20v-24%20m-156%2024%20q0%2010%2010%2010%20m136%200%20q10%200%2010%20-10%20m-146%2010%20h10%20m80%200%20h10%20m0%200%20h36%20m23%20-176%20h-3%22%2F%3E%3Cpolygon%20points%3D%22205%2017%20213%2013%20213%2021%22%2F%3E%3Cpolygon%20points%3D%22205%2017%20197%2013%20197%2021%22%2F%3E%3C%2Fsvg%3E)

```
content  ::= environment
           | comment
           | text
           | braced-content
           | command
```

referenced by:

* braced-content
* document
* environment

**environment:**

![environment](data:image/svg+xml,%3Csvg%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%20width%3D%221103%22%20height%3D%22145%22%3E%3Cdefs%3E%3Cstyle%20type%3D%22text%2Fcss%22%3E%40namespace%20%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%3B%20.line%20%7Bfill%3A%20none%3B%20stroke%3A%20%23332900%3B%20stroke-width%3A%201%3B%7D%20.bold-line%20%7Bstroke%3A%20%23141000%3B%20shape-rendering%3A%20crispEdges%3B%20stroke-width%3A%202%3B%7D%20.thin-line%20%7Bstroke%3A%20%231F1800%3B%20shape-rendering%3A%20crispEdges%7D%20.filled%20%7Bfill%3A%20%23332900%3B%20stroke%3A%20none%3B%7D%20text.terminal%20%7Bfont-family%3A%20Verdana%2C%20Sans-serif%3B%20font-size%3A%2012px%3B%20fill%3A%20%23141000%3B%20font-weight%3A%20bold%3B%20%7D%20text.nonterminal%20%7Bfont-family%3A%20Verdana%2C%20Sans-serif%3B%20font-size%3A%2012px%3B%20fill%3A%20%231A1400%3B%20font-weight%3A%20normal%3B%20%7D%20text.regexp%20%7Bfont-family%3A%20Verdana%2C%20Sans-serif%3B%20font-size%3A%2012px%3B%20fill%3A%20%231F1800%3B%20font-weight%3A%20normal%3B%20%7D%20rect%2C%20circle%2C%20polygon%20%7Bfill%3A%20%23332900%3B%20stroke%3A%20%23332900%3B%7D%20rect.terminal%20%7Bfill%3A%20%23FFDB4D%3B%20stroke%3A%20%23332900%3B%20stroke-width%3A%201%3B%7D%20rect.nonterminal%20%7Bfill%3A%20%23FFEC9E%3B%20stroke%3A%20%23332900%3B%20stroke-width%3A%201%3B%7D%20rect.text%20%7Bfill%3A%20none%3B%20stroke%3A%20none%3B%7D%20polygon.regexp%20%7Bfill%3A%20%23FFF4C7%3B%20stroke%3A%20%23332900%3B%20stroke-width%3A%201%3B%7D%3C%2Fstyle%3E%3C%2Fdefs%3E%3Cpolygon%20points%3D%229%2017%201%2013%201%2021%22%2F%3E%3Cpolygon%20points%3D%2217%2017%209%2013%209%2021%22%2F%3E%3Crect%20x%3D%2251%22%20y%3D%223%22%20width%3D%2266%22%20height%3D%2232%22%20rx%3D%2210%22%2F%3E%3Crect%20x%3D%2249%22%20y%3D%221%22%20width%3D%2266%22%20height%3D%2232%22%20class%3D%22terminal%22%20rx%3D%2210%22%2F%3E%3Ctext%20class%3D%22terminal%22%20x%3D%2259%22%20y%3D%2221%22%3E%5Cbegin%3C%2Ftext%3E%3Crect%20x%3D%22157%22%20y%3D%2235%22%20width%3D%2266%22%20height%3D%2232%22%2F%3E%3Crect%20x%3D%22155%22%20y%3D%2233%22%20width%3D%2266%22%20height%3D%2232%22%20class%3D%22nonterminal%22%2F%3E%3Ctext%20class%3D%22nonterminal%22%20x%3D%22165%22%20y%3D%2253%22%3Eoptions%3C%2Ftext%3E%3Crect%20x%3D%22263%22%20y%3D%223%22%20width%3D%2228%22%20height%3D%2232%22%20rx%3D%2210%22%2F%3E%3Crect%20x%3D%22261%22%20y%3D%221%22%20width%3D%2228%22%20height%3D%2232%22%20class%3D%22terminal%22%20rx%3D%2210%22%2F%3E%3Ctext%20class%3D%22terminal%22%20x%3D%22271%22%20y%3D%2221%22%3E%7B%3C%2Ftext%3E%3Crect%20x%3D%22311%22%20y%3D%223%22%20width%3D%22184%22%20height%3D%2232%22%2F%3E%3Crect%20x%3D%22309%22%20y%3D%221%22%20width%3D%22184%22%20height%3D%2232%22%20class%3D%22nonterminal%22%2F%3E%3Ctext%20class%3D%22nonterminal%22%20x%3D%22319%22%20y%3D%2221%22%3Epassthrough-command-id%3C%2Ftext%3E%3Crect%20x%3D%22515%22%20y%3D%223%22%20width%3D%2228%22%20height%3D%2232%22%20rx%3D%2210%22%2F%3E%3Crect%20x%3D%22513%22%20y%3D%221%22%20width%3D%2228%22%20height%3D%2232%22%20class%3D%22terminal%22%20rx%3D%2210%22%2F%3E%3Ctext%20class%3D%22terminal%22%20x%3D%22523%22%20y%3D%2221%22%3E%7D%3C%2Ftext%3E%3Crect%20x%3D%22563%22%20y%3D%223%22%20width%3D%22158%22%20height%3D%2232%22%2F%3E%3Crect%20x%3D%22561%22%20y%3D%221%22%20width%3D%22158%22%20height%3D%2232%22%20class%3D%22nonterminal%22%2F%3E%3Ctext%20class%3D%22nonterminal%22%20x%3D%22571%22%20y%3D%2221%22%3Eenv-passthrough-text%3C%2Ftext%3E%3Crect%20x%3D%22741%22%20y%3D%223%22%20width%3D%2262%22%20height%3D%2232%22%20rx%3D%2210%22%2F%3E%3Crect%20x%3D%22739%22%20y%3D%221%22%20width%3D%2262%22%20height%3D%2232%22%20class%3D%22terminal%22%20rx%3D%2210%22%2F%3E%3Ctext%20class%3D%22terminal%22%20x%3D%22749%22%20y%3D%2221%22%3E%5Cend%7B%3C%2Ftext%3E%3Crect%20x%3D%22823%22%20y%3D%223%22%20width%3D%22184%22%20height%3D%2232%22%2F%3E%3Crect%20x%3D%22821%22%20y%3D%221%22%20width%3D%22184%22%20height%3D%2232%22%20class%3D%22nonterminal%22%2F%3E%3Ctext%20class%3D%22nonterminal%22%20x%3D%22831%22%20y%3D%2221%22%3Epassthrough-command-id%3C%2Ftext%3E%3Crect%20x%3D%221027%22%20y%3D%223%22%20width%3D%2228%22%20height%3D%2232%22%20rx%3D%2210%22%2F%3E%3Crect%20x%3D%221025%22%20y%3D%221%22%20width%3D%2228%22%20height%3D%2232%22%20class%3D%22terminal%22%20rx%3D%2210%22%2F%3E%3Ctext%20class%3D%22terminal%22%20x%3D%221035%22%20y%3D%2221%22%3E%7D%3C%2Ftext%3E%3Crect%20x%3D%2251%22%20y%3D%2279%22%20width%3D%2266%22%20height%3D%2232%22%20rx%3D%2210%22%2F%3E%3Crect%20x%3D%2249%22%20y%3D%2277%22%20width%3D%2266%22%20height%3D%2232%22%20class%3D%22terminal%22%20rx%3D%2210%22%2F%3E%3Ctext%20class%3D%22terminal%22%20x%3D%2259%22%20y%3D%2297%22%3E%5Cbegin%3C%2Ftext%3E%3Crect%20x%3D%22157%22%20y%3D%22111%22%20width%3D%2266%22%20height%3D%2232%22%2F%3E%3Crect%20x%3D%22155%22%20y%3D%22109%22%20width%3D%2266%22%20height%3D%2232%22%20class%3D%22nonterminal%22%2F%3E%3Ctext%20class%3D%22nonterminal%22%20x%3D%22165%22%20y%3D%22129%22%3Eoptions%3C%2Ftext%3E%3Crect%20x%3D%22263%22%20y%3D%2279%22%20width%3D%2228%22%20height%3D%2232%22%20rx%3D%2210%22%2F%3E%3Crect%20x%3D%22261%22%20y%3D%2277%22%20width%3D%2228%22%20height%3D%2232%22%20class%3D%22terminal%22%20rx%3D%2210%22%2F%3E%3Ctext%20class%3D%22terminal%22%20x%3D%22271%22%20y%3D%2297%22%3E%7B%3C%2Ftext%3E%3Crect%20x%3D%22311%22%20y%3D%2279%22%20width%3D%2298%22%20height%3D%2232%22%2F%3E%3Crect%20x%3D%22309%22%20y%3D%2277%22%20width%3D%2298%22%20height%3D%2232%22%20class%3D%22nonterminal%22%2F%3E%3Ctext%20class%3D%22nonterminal%22%20x%3D%22319%22%20y%3D%2297%22%3Ecommand-id%3C%2Ftext%3E%3Crect%20x%3D%22429%22%20y%3D%2279%22%20width%3D%2228%22%20height%3D%2232%22%20rx%3D%2210%22%2F%3E%3Crect%20x%3D%22427%22%20y%3D%2277%22%20width%3D%2228%22%20height%3D%2232%22%20class%3D%22terminal%22%20rx%3D%2210%22%2F%3E%3Ctext%20class%3D%22terminal%22%20x%3D%22437%22%20y%3D%2297%22%3E%7D%3C%2Ftext%3E%3Crect%20x%3D%22477%22%20y%3D%2279%22%20width%3D%2268%22%20height%3D%2232%22%2F%3E%3Crect%20x%3D%22475%22%20y%3D%2277%22%20width%3D%2268%22%20height%3D%2232%22%20class%3D%22nonterminal%22%2F%3E%3Ctext%20class%3D%22nonterminal%22%20x%3D%22485%22%20y%3D%2297%22%3Econtent%3C%2Ftext%3E%3Crect%20x%3D%22565%22%20y%3D%2279%22%20width%3D%2262%22%20height%3D%2232%22%20rx%3D%2210%22%2F%3E%3Crect%20x%3D%22563%22%20y%3D%2277%22%20width%3D%2262%22%20height%3D%2232%22%20class%3D%22terminal%22%20rx%3D%2210%22%2F%3E%3Ctext%20class%3D%22terminal%22%20x%3D%22573%22%20y%3D%2297%22%3E%5Cend%7B%3C%2Ftext%3E%3Crect%20x%3D%22647%22%20y%3D%2279%22%20width%3D%2298%22%20height%3D%2232%22%2F%3E%3Crect%20x%3D%22645%22%20y%3D%2277%22%20width%3D%2298%22%20height%3D%2232%22%20class%3D%22nonterminal%22%2F%3E%3Ctext%20class%3D%22nonterminal%22%20x%3D%22655%22%20y%3D%2297%22%3Ecommand-id%3C%2Ftext%3E%3Crect%20x%3D%22765%22%20y%3D%2279%22%20width%3D%2228%22%20height%3D%2232%22%20rx%3D%2210%22%2F%3E%3Crect%20x%3D%22763%22%20y%3D%2277%22%20width%3D%2228%22%20height%3D%2232%22%20class%3D%22terminal%22%20rx%3D%2210%22%2F%3E%3Ctext%20class%3D%22terminal%22%20x%3D%22773%22%20y%3D%2297%22%3E%7D%3C%2Ftext%3E%3Cpath%20class%3D%22line%22%20d%3D%22m17%2017%20h2%20m20%200%20h10%20m66%200%20h10%20m20%200%20h10%20m0%200%20h76%20m-106%200%20h20%20m86%200%20h20%20m-126%200%20q10%200%2010%2010%20m106%200%20q0%20-10%2010%20-10%20m-116%2010%20v12%20m106%200%20v-12%20m-106%2012%20q0%2010%2010%2010%20m86%200%20q10%200%2010%20-10%20m-96%2010%20h10%20m66%200%20h10%20m20%20-32%20h10%20m28%200%20h10%20m0%200%20h10%20m184%200%20h10%20m0%200%20h10%20m28%200%20h10%20m0%200%20h10%20m158%200%20h10%20m0%200%20h10%20m62%200%20h10%20m0%200%20h10%20m184%200%20h10%20m0%200%20h10%20m28%200%20h10%20m-1044%200%20h20%20m1024%200%20h20%20m-1064%200%20q10%200%2010%2010%20m1044%200%20q0%20-10%2010%20-10%20m-1054%2010%20v56%20m1044%200%20v-56%20m-1044%2056%20q0%2010%2010%2010%20m1024%200%20q10%200%2010%20-10%20m-1034%2010%20h10%20m66%200%20h10%20m20%200%20h10%20m0%200%20h76%20m-106%200%20h20%20m86%200%20h20%20m-126%200%20q10%200%2010%2010%20m106%200%20q0%20-10%2010%20-10%20m-116%2010%20v12%20m106%200%20v-12%20m-106%2012%20q0%2010%2010%2010%20m86%200%20q10%200%2010%20-10%20m-96%2010%20h10%20m66%200%20h10%20m20%20-32%20h10%20m28%200%20h10%20m0%200%20h10%20m98%200%20h10%20m0%200%20h10%20m28%200%20h10%20m0%200%20h10%20m68%200%20h10%20m0%200%20h10%20m62%200%20h10%20m0%200%20h10%20m98%200%20h10%20m0%200%20h10%20m28%200%20h10%20m0%200%20h262%20m23%20-76%20h-3%22%2F%3E%3Cpolygon%20points%3D%221093%2017%201101%2013%201101%2021%22%2F%3E%3Cpolygon%20points%3D%221093%2017%201085%2013%201085%2021%22%2F%3E%3C%2Fsvg%3E)

```
environment
         ::= '\begin' options? '{' passthrough-command-id '}' env-passthrough-text '\end{' passthrough-command-id '}'
           | '\begin' options? '{' command-id '}' content '\end{' command-id '}'
```

referenced by:

* content

**env-passthrough-text:**

![env-passthrough-text](data:image/svg+xml,%3Csvg%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%20width%3D%22177%22%20height%3D%2257%22%3E%3Cdefs%3E%3Cstyle%20type%3D%22text%2Fcss%22%3E%40namespace%20%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%3B%20.line%20%7Bfill%3A%20none%3B%20stroke%3A%20%23332900%3B%20stroke-width%3A%201%3B%7D%20.bold-line%20%7Bstroke%3A%20%23141000%3B%20shape-rendering%3A%20crispEdges%3B%20stroke-width%3A%202%3B%7D%20.thin-line%20%7Bstroke%3A%20%231F1800%3B%20shape-rendering%3A%20crispEdges%7D%20.filled%20%7Bfill%3A%20%23332900%3B%20stroke%3A%20none%3B%7D%20text.terminal%20%7Bfont-family%3A%20Verdana%2C%20Sans-serif%3B%20font-size%3A%2012px%3B%20fill%3A%20%23141000%3B%20font-weight%3A%20bold%3B%20%7D%20text.nonterminal%20%7Bfont-family%3A%20Verdana%2C%20Sans-serif%3B%20font-size%3A%2012px%3B%20fill%3A%20%231A1400%3B%20font-weight%3A%20normal%3B%20%7D%20text.regexp%20%7Bfont-family%3A%20Verdana%2C%20Sans-serif%3B%20font-size%3A%2012px%3B%20fill%3A%20%231F1800%3B%20font-weight%3A%20normal%3B%20%7D%20rect%2C%20circle%2C%20polygon%20%7Bfill%3A%20%23332900%3B%20stroke%3A%20%23332900%3B%7D%20rect.terminal%20%7Bfill%3A%20%23FFDB4D%3B%20stroke%3A%20%23332900%3B%20stroke-width%3A%201%3B%7D%20rect.nonterminal%20%7Bfill%3A%20%23FFEC9E%3B%20stroke%3A%20%23332900%3B%20stroke-width%3A%201%3B%7D%20rect.text%20%7Bfill%3A%20none%3B%20stroke%3A%20none%3B%7D%20polygon.regexp%20%7Bfill%3A%20%23FFF4C7%3B%20stroke%3A%20%23332900%3B%20stroke-width%3A%201%3B%7D%3C%2Fstyle%3E%3C%2Fdefs%3E%3Cpolygon%20points%3D%229%2051%201%2047%201%2055%22%2F%3E%3Cpolygon%20points%3D%2217%2051%209%2047%209%2055%22%2F%3E%3Crect%20x%3D%2251%22%20y%3D%223%22%20width%3D%2278%22%20height%3D%2232%22%2F%3E%3Crect%20x%3D%2249%22%20y%3D%221%22%20width%3D%2278%22%20height%3D%2232%22%20class%3D%22nonterminal%22%2F%3E%3Ctext%20class%3D%22nonterminal%22%20x%3D%2259%22%20y%3D%2221%22%3Eutf8-char%3C%2Ftext%3E%3Cpath%20class%3D%22line%22%20d%3D%22m17%2051%20h2%20m20%200%20h10%20m0%200%20h88%20m-118%200%20l20%200%20m-1%200%20q-9%200%20-9%20-10%20l0%20-14%20q0%20-10%2010%20-10%20m98%2034%20l20%200%20m-20%200%20q10%200%2010%20-10%20l0%20-14%20q0%20-10%20-10%20-10%20m-98%200%20h10%20m78%200%20h10%20m23%2034%20h-3%22%2F%3E%3Cpolygon%20points%3D%22167%2051%20175%2047%20175%2055%22%2F%3E%3Cpolygon%20points%3D%22167%2051%20159%2047%20159%2055%22%2F%3E%3C%2Fsvg%3E)

```
env-passthrough-text
         ::= utf8-char*
```

referenced by:

* environment

**comment:**

![comment](data:image/svg+xml,%3Csvg%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%20width%3D%22301%22%20height%3D%2271%22%3E%3Cdefs%3E%3Cstyle%20type%3D%22text%2Fcss%22%3E%40namespace%20%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%3B%20.line%20%7Bfill%3A%20none%3B%20stroke%3A%20%23332900%3B%20stroke-width%3A%201%3B%7D%20.bold-line%20%7Bstroke%3A%20%23141000%3B%20shape-rendering%3A%20crispEdges%3B%20stroke-width%3A%202%3B%7D%20.thin-line%20%7Bstroke%3A%20%231F1800%3B%20shape-rendering%3A%20crispEdges%7D%20.filled%20%7Bfill%3A%20%23332900%3B%20stroke%3A%20none%3B%7D%20text.terminal%20%7Bfont-family%3A%20Verdana%2C%20Sans-serif%3B%20font-size%3A%2012px%3B%20fill%3A%20%23141000%3B%20font-weight%3A%20bold%3B%20%7D%20text.nonterminal%20%7Bfont-family%3A%20Verdana%2C%20Sans-serif%3B%20font-size%3A%2012px%3B%20fill%3A%20%231A1400%3B%20font-weight%3A%20normal%3B%20%7D%20text.regexp%20%7Bfont-family%3A%20Verdana%2C%20Sans-serif%3B%20font-size%3A%2012px%3B%20fill%3A%20%231F1800%3B%20font-weight%3A%20normal%3B%20%7D%20rect%2C%20circle%2C%20polygon%20%7Bfill%3A%20%23332900%3B%20stroke%3A%20%23332900%3B%7D%20rect.terminal%20%7Bfill%3A%20%23FFDB4D%3B%20stroke%3A%20%23332900%3B%20stroke-width%3A%201%3B%7D%20rect.nonterminal%20%7Bfill%3A%20%23FFEC9E%3B%20stroke%3A%20%23332900%3B%20stroke-width%3A%201%3B%7D%20rect.text%20%7Bfill%3A%20none%3B%20stroke%3A%20none%3B%7D%20polygon.regexp%20%7Bfill%3A%20%23FFF4C7%3B%20stroke%3A%20%23332900%3B%20stroke-width%3A%201%3B%7D%3C%2Fstyle%3E%3C%2Fdefs%3E%3Cpolygon%20points%3D%229%2051%201%2047%201%2055%22%2F%3E%3Cpolygon%20points%3D%2217%2051%209%2047%209%2055%22%2F%3E%3Crect%20x%3D%2231%22%20y%3D%2237%22%20width%3D%2234%22%20height%3D%2232%22%20rx%3D%2210%22%2F%3E%3Crect%20x%3D%2229%22%20y%3D%2235%22%20width%3D%2234%22%20height%3D%2232%22%20class%3D%22terminal%22%20rx%3D%2210%22%2F%3E%3Ctext%20class%3D%22terminal%22%20x%3D%2239%22%20y%3D%2255%22%3E%25%3C%2Ftext%3E%3Crect%20x%3D%22105%22%20y%3D%223%22%20width%3D%2278%22%20height%3D%2232%22%2F%3E%3Crect%20x%3D%22103%22%20y%3D%221%22%20width%3D%2278%22%20height%3D%2232%22%20class%3D%22nonterminal%22%2F%3E%3Ctext%20class%3D%22nonterminal%22%20x%3D%22113%22%20y%3D%2221%22%3Eutf8-char%3C%2Ftext%3E%3Crect%20x%3D%22223%22%20y%3D%2237%22%20width%3D%2250%22%20height%3D%2232%22%2F%3E%3Crect%20x%3D%22221%22%20y%3D%2235%22%20width%3D%2250%22%20height%3D%2232%22%20class%3D%22nonterminal%22%2F%3E%3Ctext%20class%3D%22nonterminal%22%20x%3D%22231%22%20y%3D%2255%22%3ECRLF%3C%2Ftext%3E%3Cpath%20class%3D%22line%22%20d%3D%22m17%2051%20h2%20m0%200%20h10%20m34%200%20h10%20m20%200%20h10%20m0%200%20h88%20m-118%200%20l20%200%20m-1%200%20q-9%200%20-9%20-10%20l0%20-14%20q0%20-10%2010%20-10%20m98%2034%20l20%200%20m-20%200%20q10%200%2010%20-10%20l0%20-14%20q0%20-10%20-10%20-10%20m-98%200%20h10%20m78%200%20h10%20m20%2034%20h10%20m50%200%20h10%20m3%200%20h-3%22%2F%3E%3Cpolygon%20points%3D%22291%2051%20299%2047%20299%2055%22%2F%3E%3Cpolygon%20points%3D%22291%2051%20283%2047%20283%2055%22%2F%3E%3C%2Fsvg%3E)

```
comment  ::= '%' utf8-char* CRLF
```

referenced by:

* content

**text:**

![text](data:image/svg+xml,%3Csvg%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%20width%3D%22177%22%20height%3D%2257%22%3E%3Cdefs%3E%3Cstyle%20type%3D%22text%2Fcss%22%3E%40namespace%20%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%3B%20.line%20%7Bfill%3A%20none%3B%20stroke%3A%20%23332900%3B%20stroke-width%3A%201%3B%7D%20.bold-line%20%7Bstroke%3A%20%23141000%3B%20shape-rendering%3A%20crispEdges%3B%20stroke-width%3A%202%3B%7D%20.thin-line%20%7Bstroke%3A%20%231F1800%3B%20shape-rendering%3A%20crispEdges%7D%20.filled%20%7Bfill%3A%20%23332900%3B%20stroke%3A%20none%3B%7D%20text.terminal%20%7Bfont-family%3A%20Verdana%2C%20Sans-serif%3B%20font-size%3A%2012px%3B%20fill%3A%20%23141000%3B%20font-weight%3A%20bold%3B%20%7D%20text.nonterminal%20%7Bfont-family%3A%20Verdana%2C%20Sans-serif%3B%20font-size%3A%2012px%3B%20fill%3A%20%231A1400%3B%20font-weight%3A%20normal%3B%20%7D%20text.regexp%20%7Bfont-family%3A%20Verdana%2C%20Sans-serif%3B%20font-size%3A%2012px%3B%20fill%3A%20%231F1800%3B%20font-weight%3A%20normal%3B%20%7D%20rect%2C%20circle%2C%20polygon%20%7Bfill%3A%20%23332900%3B%20stroke%3A%20%23332900%3B%7D%20rect.terminal%20%7Bfill%3A%20%23FFDB4D%3B%20stroke%3A%20%23332900%3B%20stroke-width%3A%201%3B%7D%20rect.nonterminal%20%7Bfill%3A%20%23FFEC9E%3B%20stroke%3A%20%23332900%3B%20stroke-width%3A%201%3B%7D%20rect.text%20%7Bfill%3A%20none%3B%20stroke%3A%20none%3B%7D%20polygon.regexp%20%7Bfill%3A%20%23FFF4C7%3B%20stroke%3A%20%23332900%3B%20stroke-width%3A%201%3B%7D%3C%2Fstyle%3E%3C%2Fdefs%3E%3Cpolygon%20points%3D%229%2051%201%2047%201%2055%22%2F%3E%3Cpolygon%20points%3D%2217%2051%209%2047%209%2055%22%2F%3E%3Crect%20x%3D%2251%22%20y%3D%223%22%20width%3D%2278%22%20height%3D%2232%22%2F%3E%3Crect%20x%3D%2249%22%20y%3D%221%22%20width%3D%2278%22%20height%3D%2232%22%20class%3D%22nonterminal%22%2F%3E%3Ctext%20class%3D%22nonterminal%22%20x%3D%2259%22%20y%3D%2221%22%3Etext-char%3C%2Ftext%3E%3Cpath%20class%3D%22line%22%20d%3D%22m17%2051%20h2%20m20%200%20h10%20m0%200%20h88%20m-118%200%20l20%200%20m-1%200%20q-9%200%20-9%20-10%20l0%20-14%20q0%20-10%2010%20-10%20m98%2034%20l20%200%20m-20%200%20q10%200%2010%20-10%20l0%20-14%20q0%20-10%20-10%20-10%20m-98%200%20h10%20m78%200%20h10%20m23%2034%20h-3%22%2F%3E%3Cpolygon%20points%3D%22167%2051%20175%2047%20175%2055%22%2F%3E%3Cpolygon%20points%3D%22167%2051%20159%2047%20159%2055%22%2F%3E%3C%2Fsvg%3E)

```
text     ::= text-char*
```

referenced by:

* content

**braced-content:**

![braced-content](data:image/svg+xml,%3Csvg%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%20width%3D%22223%22%20height%3D%2237%22%3E%3Cdefs%3E%3Cstyle%20type%3D%22text%2Fcss%22%3E%40namespace%20%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%3B%20.line%20%7Bfill%3A%20none%3B%20stroke%3A%20%23332900%3B%20stroke-width%3A%201%3B%7D%20.bold-line%20%7Bstroke%3A%20%23141000%3B%20shape-rendering%3A%20crispEdges%3B%20stroke-width%3A%202%3B%7D%20.thin-line%20%7Bstroke%3A%20%231F1800%3B%20shape-rendering%3A%20crispEdges%7D%20.filled%20%7Bfill%3A%20%23332900%3B%20stroke%3A%20none%3B%7D%20text.terminal%20%7Bfont-family%3A%20Verdana%2C%20Sans-serif%3B%20font-size%3A%2012px%3B%20fill%3A%20%23141000%3B%20font-weight%3A%20bold%3B%20%7D%20text.nonterminal%20%7Bfont-family%3A%20Verdana%2C%20Sans-serif%3B%20font-size%3A%2012px%3B%20fill%3A%20%231A1400%3B%20font-weight%3A%20normal%3B%20%7D%20text.regexp%20%7Bfont-family%3A%20Verdana%2C%20Sans-serif%3B%20font-size%3A%2012px%3B%20fill%3A%20%231F1800%3B%20font-weight%3A%20normal%3B%20%7D%20rect%2C%20circle%2C%20polygon%20%7Bfill%3A%20%23332900%3B%20stroke%3A%20%23332900%3B%7D%20rect.terminal%20%7Bfill%3A%20%23FFDB4D%3B%20stroke%3A%20%23332900%3B%20stroke-width%3A%201%3B%7D%20rect.nonterminal%20%7Bfill%3A%20%23FFEC9E%3B%20stroke%3A%20%23332900%3B%20stroke-width%3A%201%3B%7D%20rect.text%20%7Bfill%3A%20none%3B%20stroke%3A%20none%3B%7D%20polygon.regexp%20%7Bfill%3A%20%23FFF4C7%3B%20stroke%3A%20%23332900%3B%20stroke-width%3A%201%3B%7D%3C%2Fstyle%3E%3C%2Fdefs%3E%3Cpolygon%20points%3D%229%2017%201%2013%201%2021%22%2F%3E%3Cpolygon%20points%3D%2217%2017%209%2013%209%2021%22%2F%3E%3Crect%20x%3D%2231%22%20y%3D%223%22%20width%3D%2228%22%20height%3D%2232%22%20rx%3D%2210%22%2F%3E%3Crect%20x%3D%2229%22%20y%3D%221%22%20width%3D%2228%22%20height%3D%2232%22%20class%3D%22terminal%22%20rx%3D%2210%22%2F%3E%3Ctext%20class%3D%22terminal%22%20x%3D%2239%22%20y%3D%2221%22%3E%7B%3C%2Ftext%3E%3Crect%20x%3D%2279%22%20y%3D%223%22%20width%3D%2268%22%20height%3D%2232%22%2F%3E%3Crect%20x%3D%2277%22%20y%3D%221%22%20width%3D%2268%22%20height%3D%2232%22%20class%3D%22nonterminal%22%2F%3E%3Ctext%20class%3D%22nonterminal%22%20x%3D%2287%22%20y%3D%2221%22%3Econtent%3C%2Ftext%3E%3Crect%20x%3D%22167%22%20y%3D%223%22%20width%3D%2228%22%20height%3D%2232%22%20rx%3D%2210%22%2F%3E%3Crect%20x%3D%22165%22%20y%3D%221%22%20width%3D%2228%22%20height%3D%2232%22%20class%3D%22terminal%22%20rx%3D%2210%22%2F%3E%3Ctext%20class%3D%22terminal%22%20x%3D%22175%22%20y%3D%2221%22%3E%7D%3C%2Ftext%3E%3Cpath%20class%3D%22line%22%20d%3D%22m17%2017%20h2%20m0%200%20h10%20m28%200%20h10%20m0%200%20h10%20m68%200%20h10%20m0%200%20h10%20m28%200%20h10%20m3%200%20h-3%22%2F%3E%3Cpolygon%20points%3D%22213%2017%20221%2013%20221%2021%22%2F%3E%3Cpolygon%20points%3D%22213%2017%20205%2013%20205%2021%22%2F%3E%3C%2Fsvg%3E)

```
braced-content
         ::= '{' content '}'
```

referenced by:

* command
* content

**command:**

![command](data:image/svg+xml,%3Csvg%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%20width%3D%22695%22%20height%3D%22145%22%3E%3Cdefs%3E%3Cstyle%20type%3D%22text%2Fcss%22%3E%40namespace%20%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%3B%20.line%20%7Bfill%3A%20none%3B%20stroke%3A%20%23332900%3B%20stroke-width%3A%201%3B%7D%20.bold-line%20%7Bstroke%3A%20%23141000%3B%20shape-rendering%3A%20crispEdges%3B%20stroke-width%3A%202%3B%7D%20.thin-line%20%7Bstroke%3A%20%231F1800%3B%20shape-rendering%3A%20crispEdges%7D%20.filled%20%7Bfill%3A%20%23332900%3B%20stroke%3A%20none%3B%7D%20text.terminal%20%7Bfont-family%3A%20Verdana%2C%20Sans-serif%3B%20font-size%3A%2012px%3B%20fill%3A%20%23141000%3B%20font-weight%3A%20bold%3B%20%7D%20text.nonterminal%20%7Bfont-family%3A%20Verdana%2C%20Sans-serif%3B%20font-size%3A%2012px%3B%20fill%3A%20%231A1400%3B%20font-weight%3A%20normal%3B%20%7D%20text.regexp%20%7Bfont-family%3A%20Verdana%2C%20Sans-serif%3B%20font-size%3A%2012px%3B%20fill%3A%20%231F1800%3B%20font-weight%3A%20normal%3B%20%7D%20rect%2C%20circle%2C%20polygon%20%7Bfill%3A%20%23332900%3B%20stroke%3A%20%23332900%3B%7D%20rect.terminal%20%7Bfill%3A%20%23FFDB4D%3B%20stroke%3A%20%23332900%3B%20stroke-width%3A%201%3B%7D%20rect.nonterminal%20%7Bfill%3A%20%23FFEC9E%3B%20stroke%3A%20%23332900%3B%20stroke-width%3A%201%3B%7D%20rect.text%20%7Bfill%3A%20none%3B%20stroke%3A%20none%3B%7D%20polygon.regexp%20%7Bfill%3A%20%23FFF4C7%3B%20stroke%3A%20%23332900%3B%20stroke-width%3A%201%3B%7D%3C%2Fstyle%3E%3C%2Fdefs%3E%3Cpolygon%20points%3D%229%2017%201%2013%201%2021%22%2F%3E%3Cpolygon%20points%3D%2217%2017%209%2013%209%2021%22%2F%3E%3Crect%20x%3D%2251%22%20y%3D%223%22%20width%3D%2228%22%20height%3D%2232%22%20rx%3D%2210%22%2F%3E%3Crect%20x%3D%2249%22%20y%3D%221%22%20width%3D%2228%22%20height%3D%2232%22%20class%3D%22terminal%22%20rx%3D%2210%22%2F%3E%3Ctext%20class%3D%22terminal%22%20x%3D%2259%22%20y%3D%2221%22%3E%5C%3C%2Ftext%3E%3Crect%20x%3D%2299%22%20y%3D%223%22%20width%3D%22184%22%20height%3D%2232%22%2F%3E%3Crect%20x%3D%2297%22%20y%3D%221%22%20width%3D%22184%22%20height%3D%2232%22%20class%3D%22nonterminal%22%2F%3E%3Ctext%20class%3D%22nonterminal%22%20x%3D%22107%22%20y%3D%2221%22%3Epassthrough-command-id%3C%2Ftext%3E%3Crect%20x%3D%22323%22%20y%3D%2235%22%20width%3D%2266%22%20height%3D%2232%22%2F%3E%3Crect%20x%3D%22321%22%20y%3D%2233%22%20width%3D%2266%22%20height%3D%2232%22%20class%3D%22nonterminal%22%2F%3E%3Ctext%20class%3D%22nonterminal%22%20x%3D%22331%22%20y%3D%2253%22%3Eoptions%3C%2Ftext%3E%3Crect%20x%3D%22449%22%20y%3D%2235%22%20width%3D%22178%22%20height%3D%2232%22%2F%3E%3Crect%20x%3D%22447%22%20y%3D%2233%22%20width%3D%22178%22%20height%3D%2232%22%20class%3D%22nonterminal%22%2F%3E%3Ctext%20class%3D%22nonterminal%22%20x%3D%22457%22%20y%3D%2253%22%3Ebraced-passthrough-text%3C%2Ftext%3E%3Crect%20x%3D%2251%22%20y%3D%2279%22%20width%3D%2228%22%20height%3D%2232%22%20rx%3D%2210%22%2F%3E%3Crect%20x%3D%2249%22%20y%3D%2277%22%20width%3D%2228%22%20height%3D%2232%22%20class%3D%22terminal%22%20rx%3D%2210%22%2F%3E%3Ctext%20class%3D%22terminal%22%20x%3D%2259%22%20y%3D%2297%22%3E%5C%3C%2Ftext%3E%3Crect%20x%3D%2299%22%20y%3D%2279%22%20width%3D%2298%22%20height%3D%2232%22%2F%3E%3Crect%20x%3D%2297%22%20y%3D%2277%22%20width%3D%2298%22%20height%3D%2232%22%20class%3D%22nonterminal%22%2F%3E%3Ctext%20class%3D%22nonterminal%22%20x%3D%22107%22%20y%3D%2297%22%3Ecommand-id%3C%2Ftext%3E%3Crect%20x%3D%22237%22%20y%3D%22111%22%20width%3D%2266%22%20height%3D%2232%22%2F%3E%3Crect%20x%3D%22235%22%20y%3D%22109%22%20width%3D%2266%22%20height%3D%2232%22%20class%3D%22nonterminal%22%2F%3E%3Ctext%20class%3D%22nonterminal%22%20x%3D%22245%22%20y%3D%22129%22%3Eoptions%3C%2Ftext%3E%3Crect%20x%3D%22363%22%20y%3D%22111%22%20width%3D%22116%22%20height%3D%2232%22%2F%3E%3Crect%20x%3D%22361%22%20y%3D%22109%22%20width%3D%22116%22%20height%3D%2232%22%20class%3D%22nonterminal%22%2F%3E%3Ctext%20class%3D%22nonterminal%22%20x%3D%22371%22%20y%3D%22129%22%3Ebraced-content%3C%2Ftext%3E%3Cpath%20class%3D%22line%22%20d%3D%22m17%2017%20h2%20m20%200%20h10%20m28%200%20h10%20m0%200%20h10%20m184%200%20h10%20m20%200%20h10%20m0%200%20h76%20m-106%200%20h20%20m86%200%20h20%20m-126%200%20q10%200%2010%2010%20m106%200%20q0%20-10%2010%20-10%20m-116%2010%20v12%20m106%200%20v-12%20m-106%2012%20q0%2010%2010%2010%20m86%200%20q10%200%2010%20-10%20m-96%2010%20h10%20m66%200%20h10%20m40%20-32%20h10%20m0%200%20h188%20m-218%200%20h20%20m198%200%20h20%20m-238%200%20q10%200%2010%2010%20m218%200%20q0%20-10%2010%20-10%20m-228%2010%20v12%20m218%200%20v-12%20m-218%2012%20q0%2010%2010%2010%20m198%200%20q10%200%2010%20-10%20m-208%2010%20h10%20m178%200%20h10%20m-616%20-32%20h20%20m616%200%20h20%20m-656%200%20q10%200%2010%2010%20m636%200%20q0%20-10%2010%20-10%20m-646%2010%20v56%20m636%200%20v-56%20m-636%2056%20q0%2010%2010%2010%20m616%200%20q10%200%2010%20-10%20m-626%2010%20h10%20m28%200%20h10%20m0%200%20h10%20m98%200%20h10%20m20%200%20h10%20m0%200%20h76%20m-106%200%20h20%20m86%200%20h20%20m-126%200%20q10%200%2010%2010%20m106%200%20q0%20-10%2010%20-10%20m-116%2010%20v12%20m106%200%20v-12%20m-106%2012%20q0%2010%2010%2010%20m86%200%20q10%200%2010%20-10%20m-96%2010%20h10%20m66%200%20h10%20m40%20-32%20h10%20m0%200%20h126%20m-156%200%20h20%20m136%200%20h20%20m-176%200%20q10%200%2010%2010%20m156%200%20q0%20-10%2010%20-10%20m-166%2010%20v12%20m156%200%20v-12%20m-156%2012%20q0%2010%2010%2010%20m136%200%20q10%200%2010%20-10%20m-146%2010%20h10%20m116%200%20h10%20m20%20-32%20h148%20m23%20-76%20h-3%22%2F%3E%3Cpolygon%20points%3D%22685%2017%20693%2013%20693%2021%22%2F%3E%3Cpolygon%20points%3D%22685%2017%20677%2013%20677%2021%22%2F%3E%3C%2Fsvg%3E)

```
command  ::= '\' passthrough-command-id options? braced-passthrough-text?
           | '\' command-id options? braced-content?
```

referenced by:

* content

**braced-passthrough-text:**

![braced-passthrough-text](data:image/svg+xml,%3Csvg%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%20width%3D%22377%22%20height%3D%22115%22%3E%3Cdefs%3E%3Cstyle%20type%3D%22text%2Fcss%22%3E%40namespace%20%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%3B%20.line%20%7Bfill%3A%20none%3B%20stroke%3A%20%23332900%3B%20stroke-width%3A%201%3B%7D%20.bold-line%20%7Bstroke%3A%20%23141000%3B%20shape-rendering%3A%20crispEdges%3B%20stroke-width%3A%202%3B%7D%20.thin-line%20%7Bstroke%3A%20%231F1800%3B%20shape-rendering%3A%20crispEdges%7D%20.filled%20%7Bfill%3A%20%23332900%3B%20stroke%3A%20none%3B%7D%20text.terminal%20%7Bfont-family%3A%20Verdana%2C%20Sans-serif%3B%20font-size%3A%2012px%3B%20fill%3A%20%23141000%3B%20font-weight%3A%20bold%3B%20%7D%20text.nonterminal%20%7Bfont-family%3A%20Verdana%2C%20Sans-serif%3B%20font-size%3A%2012px%3B%20fill%3A%20%231A1400%3B%20font-weight%3A%20normal%3B%20%7D%20text.regexp%20%7Bfont-family%3A%20Verdana%2C%20Sans-serif%3B%20font-size%3A%2012px%3B%20fill%3A%20%231F1800%3B%20font-weight%3A%20normal%3B%20%7D%20rect%2C%20circle%2C%20polygon%20%7Bfill%3A%20%23332900%3B%20stroke%3A%20%23332900%3B%7D%20rect.terminal%20%7Bfill%3A%20%23FFDB4D%3B%20stroke%3A%20%23332900%3B%20stroke-width%3A%201%3B%7D%20rect.nonterminal%20%7Bfill%3A%20%23FFEC9E%3B%20stroke%3A%20%23332900%3B%20stroke-width%3A%201%3B%7D%20rect.text%20%7Bfill%3A%20none%3B%20stroke%3A%20none%3B%7D%20polygon.regexp%20%7Bfill%3A%20%23FFF4C7%3B%20stroke%3A%20%23332900%3B%20stroke-width%3A%201%3B%7D%3C%2Fstyle%3E%3C%2Fdefs%3E%3Cpolygon%20points%3D%229%2095%201%2091%201%2099%22%2F%3E%3Cpolygon%20points%3D%2217%2095%209%2091%209%2099%22%2F%3E%3Crect%20x%3D%2231%22%20y%3D%2281%22%20width%3D%2228%22%20height%3D%2232%22%20rx%3D%2210%22%2F%3E%3Crect%20x%3D%2229%22%20y%3D%2279%22%20width%3D%2228%22%20height%3D%2232%22%20class%3D%22terminal%22%20rx%3D%2210%22%2F%3E%3Ctext%20class%3D%22terminal%22%20x%3D%2239%22%20y%3D%2299%22%3E%7B%3C%2Ftext%3E%3Crect%20x%3D%2299%22%20y%3D%2247%22%20width%3D%22178%22%20height%3D%2232%22%2F%3E%3Crect%20x%3D%2297%22%20y%3D%2245%22%20width%3D%22178%22%20height%3D%2232%22%20class%3D%22nonterminal%22%2F%3E%3Ctext%20class%3D%22nonterminal%22%20x%3D%22107%22%20y%3D%2265%22%3Ebraced-passthrough-text%3C%2Ftext%3E%3Crect%20x%3D%2299%22%20y%3D%223%22%20width%3D%22182%22%20height%3D%2232%22%2F%3E%3Crect%20x%3D%2297%22%20y%3D%221%22%20width%3D%22182%22%20height%3D%2232%22%20class%3D%22nonterminal%22%2F%3E%3Ctext%20class%3D%22nonterminal%22%20x%3D%22107%22%20y%3D%2221%22%3Ebraced-passthrough-char%3C%2Ftext%3E%3Crect%20x%3D%22321%22%20y%3D%2281%22%20width%3D%2228%22%20height%3D%2232%22%20rx%3D%2210%22%2F%3E%3Crect%20x%3D%22319%22%20y%3D%2279%22%20width%3D%2228%22%20height%3D%2232%22%20class%3D%22terminal%22%20rx%3D%2210%22%2F%3E%3Ctext%20class%3D%22terminal%22%20x%3D%22329%22%20y%3D%2299%22%3E%7D%3C%2Ftext%3E%3Cpath%20class%3D%22line%22%20d%3D%22m17%2095%20h2%20m0%200%20h10%20m28%200%20h10%20m20%200%20h10%20m0%200%20h192%20m-222%200%20l20%200%20m-1%200%20q-9%200%20-9%20-10%20l0%20-14%20q0%20-10%2010%20-10%20m202%2034%20l20%200%20m-20%200%20q10%200%2010%20-10%20l0%20-14%20q0%20-10%20-10%20-10%20m-202%200%20h10%20m178%200%20h10%20m0%200%20h4%20m-212%2010%20l0%20-44%20q0%20-10%2010%20-10%20m212%2054%20l0%20-44%20q0%20-10%20-10%20-10%20m-202%200%20h10%20m182%200%20h10%20m20%2078%20h10%20m28%200%20h10%20m3%200%20h-3%22%2F%3E%3Cpolygon%20points%3D%22367%2095%20375%2091%20375%2099%22%2F%3E%3Cpolygon%20points%3D%22367%2095%20359%2091%20359%2099%22%2F%3E%3C%2Fsvg%3E)

```
braced-passthrough-text
         ::= '{' ( braced-passthrough-text | braced-passthrough-char )* '}'
```

referenced by:

* braced-passthrough-text
* command

**braced-passthrough-char:**

![braced-passthrough-char](data:image/svg+xml,%3Csvg%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%20width%3D%22209%22%20height%3D%22257%22%3E%3Cdefs%3E%3Cstyle%20type%3D%22text%2Fcss%22%3E%40namespace%20%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%3B%20.line%20%7Bfill%3A%20none%3B%20stroke%3A%20%23332900%3B%20stroke-width%3A%201%3B%7D%20.bold-line%20%7Bstroke%3A%20%23141000%3B%20shape-rendering%3A%20crispEdges%3B%20stroke-width%3A%202%3B%7D%20.thin-line%20%7Bstroke%3A%20%231F1800%3B%20shape-rendering%3A%20crispEdges%7D%20.filled%20%7Bfill%3A%20%23332900%3B%20stroke%3A%20none%3B%7D%20text.terminal%20%7Bfont-family%3A%20Verdana%2C%20Sans-serif%3B%20font-size%3A%2012px%3B%20fill%3A%20%23141000%3B%20font-weight%3A%20bold%3B%20%7D%20text.nonterminal%20%7Bfont-family%3A%20Verdana%2C%20Sans-serif%3B%20font-size%3A%2012px%3B%20fill%3A%20%231A1400%3B%20font-weight%3A%20normal%3B%20%7D%20text.regexp%20%7Bfont-family%3A%20Verdana%2C%20Sans-serif%3B%20font-size%3A%2012px%3B%20fill%3A%20%231F1800%3B%20font-weight%3A%20normal%3B%20%7D%20rect%2C%20circle%2C%20polygon%20%7Bfill%3A%20%23332900%3B%20stroke%3A%20%23332900%3B%7D%20rect.terminal%20%7Bfill%3A%20%23FFDB4D%3B%20stroke%3A%20%23332900%3B%20stroke-width%3A%201%3B%7D%20rect.nonterminal%20%7Bfill%3A%20%23FFEC9E%3B%20stroke%3A%20%23332900%3B%20stroke-width%3A%201%3B%7D%20rect.text%20%7Bfill%3A%20none%3B%20stroke%3A%20none%3B%7D%20polygon.regexp%20%7Bfill%3A%20%23FFF4C7%3B%20stroke%3A%20%23332900%3B%20stroke-width%3A%201%3B%7D%3C%2Fstyle%3E%3C%2Fdefs%3E%3Cpolygon%20points%3D%229%2017%201%2013%201%2021%22%2F%3E%3Cpolygon%20points%3D%2217%2017%209%2013%209%2021%22%2F%3E%3Cpolygon%20points%3D%2251%2019%2058%203%20148%203%20155%2019%20148%2035%2058%2035%22%2F%3E%3Cpolygon%20points%3D%2249%2017%2056%201%20146%201%20153%2017%20146%2033%2056%2033%22%20class%3D%22regexp%22%2F%3E%3Ctext%20class%3D%22regexp%22%20x%3D%2264%22%20y%3D%2221%22%3E%5B%23x0-%23x7A%5D%3C%2Ftext%3E%3Crect%20x%3D%2251%22%20y%3D%2247%22%20width%3D%2226%22%20height%3D%2232%22%20rx%3D%2210%22%2F%3E%3Crect%20x%3D%2249%22%20y%3D%2245%22%20width%3D%2226%22%20height%3D%2232%22%20class%3D%22terminal%22%20rx%3D%2210%22%2F%3E%3Ctext%20class%3D%22terminal%22%20x%3D%2259%22%20y%3D%2265%22%3E%7C%3C%2Ftext%3E%3Cpolygon%20points%3D%2251%20107%2058%2091%20154%2091%20161%20107%20154%20123%2058%20123%22%2F%3E%3Cpolygon%20points%3D%2249%20105%2056%2089%20152%2089%20159%20105%20152%20121%2056%20121%22%20class%3D%22regexp%22%2F%3E%3Ctext%20class%3D%22regexp%22%20x%3D%2264%22%20y%3D%22109%22%3E%5B%23x7E-%23x7F%5D%3C%2Ftext%3E%3Crect%20x%3D%2251%22%20y%3D%22135%22%20width%3D%2258%22%20height%3D%2232%22%2F%3E%3Crect%20x%3D%2249%22%20y%3D%22133%22%20width%3D%2258%22%20height%3D%2232%22%20class%3D%22nonterminal%22%2F%3E%3Ctext%20class%3D%22nonterminal%22%20x%3D%2259%22%20y%3D%22153%22%3Eutf8-2%3C%2Ftext%3E%3Crect%20x%3D%2251%22%20y%3D%22179%22%20width%3D%2258%22%20height%3D%2232%22%2F%3E%3Crect%20x%3D%2249%22%20y%3D%22177%22%20width%3D%2258%22%20height%3D%2232%22%20class%3D%22nonterminal%22%2F%3E%3Ctext%20class%3D%22nonterminal%22%20x%3D%2259%22%20y%3D%22197%22%3Eutf8-3%3C%2Ftext%3E%3Crect%20x%3D%2251%22%20y%3D%22223%22%20width%3D%2258%22%20height%3D%2232%22%2F%3E%3Crect%20x%3D%2249%22%20y%3D%22221%22%20width%3D%2258%22%20height%3D%2232%22%20class%3D%22nonterminal%22%2F%3E%3Ctext%20class%3D%22nonterminal%22%20x%3D%2259%22%20y%3D%22241%22%3Eutf8-4%3C%2Ftext%3E%3Cpath%20class%3D%22line%22%20d%3D%22m17%2017%20h2%20m20%200%20h10%20m104%200%20h10%20m0%200%20h6%20m-150%200%20h20%20m130%200%20h20%20m-170%200%20q10%200%2010%2010%20m150%200%20q0%20-10%2010%20-10%20m-160%2010%20v24%20m150%200%20v-24%20m-150%2024%20q0%2010%2010%2010%20m130%200%20q10%200%2010%20-10%20m-140%2010%20h10%20m26%200%20h10%20m0%200%20h84%20m-140%20-10%20v20%20m150%200%20v-20%20m-150%2020%20v24%20m150%200%20v-24%20m-150%2024%20q0%2010%2010%2010%20m130%200%20q10%200%2010%20-10%20m-140%2010%20h10%20m110%200%20h10%20m-140%20-10%20v20%20m150%200%20v-20%20m-150%2020%20v24%20m150%200%20v-24%20m-150%2024%20q0%2010%2010%2010%20m130%200%20q10%200%2010%20-10%20m-140%2010%20h10%20m58%200%20h10%20m0%200%20h52%20m-140%20-10%20v20%20m150%200%20v-20%20m-150%2020%20v24%20m150%200%20v-24%20m-150%2024%20q0%2010%2010%2010%20m130%200%20q10%200%2010%20-10%20m-140%2010%20h10%20m58%200%20h10%20m0%200%20h52%20m-140%20-10%20v20%20m150%200%20v-20%20m-150%2020%20v24%20m150%200%20v-24%20m-150%2024%20q0%2010%2010%2010%20m130%200%20q10%200%2010%20-10%20m-140%2010%20h10%20m58%200%20h10%20m0%200%20h52%20m23%20-220%20h-3%22%2F%3E%3Cpolygon%20points%3D%22199%2017%20207%2013%20207%2021%22%2F%3E%3Cpolygon%20points%3D%22199%2017%20191%2013%20191%2021%22%2F%3E%3C%2Fsvg%3E)

```
braced-passthrough-char
         ::= [#x0-#x7A]
           | '|'
           | [#x7E-#x7F]
           | utf8-2
           | utf8-3
           | utf8-4
```

referenced by:

* braced-passthrough-text

**options:**

![options](data:image/svg+xml,%3Csvg%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%20width%3D%22277%22%20height%3D%2281%22%3E%3Cdefs%3E%3Cstyle%20type%3D%22text%2Fcss%22%3E%40namespace%20%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%3B%20.line%20%7Bfill%3A%20none%3B%20stroke%3A%20%23332900%3B%20stroke-width%3A%201%3B%7D%20.bold-line%20%7Bstroke%3A%20%23141000%3B%20shape-rendering%3A%20crispEdges%3B%20stroke-width%3A%202%3B%7D%20.thin-line%20%7Bstroke%3A%20%231F1800%3B%20shape-rendering%3A%20crispEdges%7D%20.filled%20%7Bfill%3A%20%23332900%3B%20stroke%3A%20none%3B%7D%20text.terminal%20%7Bfont-family%3A%20Verdana%2C%20Sans-serif%3B%20font-size%3A%2012px%3B%20fill%3A%20%23141000%3B%20font-weight%3A%20bold%3B%20%7D%20text.nonterminal%20%7Bfont-family%3A%20Verdana%2C%20Sans-serif%3B%20font-size%3A%2012px%3B%20fill%3A%20%231A1400%3B%20font-weight%3A%20normal%3B%20%7D%20text.regexp%20%7Bfont-family%3A%20Verdana%2C%20Sans-serif%3B%20font-size%3A%2012px%3B%20fill%3A%20%231F1800%3B%20font-weight%3A%20normal%3B%20%7D%20rect%2C%20circle%2C%20polygon%20%7Bfill%3A%20%23332900%3B%20stroke%3A%20%23332900%3B%7D%20rect.terminal%20%7Bfill%3A%20%23FFDB4D%3B%20stroke%3A%20%23332900%3B%20stroke-width%3A%201%3B%7D%20rect.nonterminal%20%7Bfill%3A%20%23FFEC9E%3B%20stroke%3A%20%23332900%3B%20stroke-width%3A%201%3B%7D%20rect.text%20%7Bfill%3A%20none%3B%20stroke%3A%20none%3B%7D%20polygon.regexp%20%7Bfill%3A%20%23FFF4C7%3B%20stroke%3A%20%23332900%3B%20stroke-width%3A%201%3B%7D%3C%2Fstyle%3E%3C%2Fdefs%3E%3Cpolygon%20points%3D%229%2061%201%2057%201%2065%22%2F%3E%3Cpolygon%20points%3D%2217%2061%209%2057%209%2065%22%2F%3E%3Crect%20x%3D%2231%22%20y%3D%2247%22%20width%3D%2226%22%20height%3D%2232%22%20rx%3D%2210%22%2F%3E%3Crect%20x%3D%2229%22%20y%3D%2245%22%20width%3D%2226%22%20height%3D%2232%22%20class%3D%22terminal%22%20rx%3D%2210%22%2F%3E%3Ctext%20class%3D%22terminal%22%20x%3D%2239%22%20y%3D%2265%22%3E%5B%3C%2Ftext%3E%3Crect%20x%3D%2297%22%20y%3D%2247%22%20width%3D%2286%22%20height%3D%2232%22%2F%3E%3Crect%20x%3D%2295%22%20y%3D%2245%22%20width%3D%2286%22%20height%3D%2232%22%20class%3D%22nonterminal%22%2F%3E%3Ctext%20class%3D%22nonterminal%22%20x%3D%22105%22%20y%3D%2265%22%3Eparameter%3C%2Ftext%3E%3Crect%20x%3D%2297%22%20y%3D%223%22%20width%3D%2224%22%20height%3D%2232%22%20rx%3D%2210%22%2F%3E%3Crect%20x%3D%2295%22%20y%3D%221%22%20width%3D%2224%22%20height%3D%2232%22%20class%3D%22terminal%22%20rx%3D%2210%22%2F%3E%3Ctext%20class%3D%22terminal%22%20x%3D%22105%22%20y%3D%2221%22%3E%2C%3C%2Ftext%3E%3Crect%20x%3D%22223%22%20y%3D%2247%22%20width%3D%2226%22%20height%3D%2232%22%20rx%3D%2210%22%2F%3E%3Crect%20x%3D%22221%22%20y%3D%2245%22%20width%3D%2226%22%20height%3D%2232%22%20class%3D%22terminal%22%20rx%3D%2210%22%2F%3E%3Ctext%20class%3D%22terminal%22%20x%3D%22231%22%20y%3D%2265%22%3E%5D%3C%2Ftext%3E%3Cpath%20class%3D%22line%22%20d%3D%22m17%2061%20h2%20m0%200%20h10%20m26%200%20h10%20m20%200%20h10%20m86%200%20h10%20m-126%200%20l20%200%20m-1%200%20q-9%200%20-9%20-10%20l0%20-24%20q0%20-10%2010%20-10%20m106%2044%20l20%200%20m-20%200%20q10%200%2010%20-10%20l0%20-24%20q0%20-10%20-10%20-10%20m-106%200%20h10%20m24%200%20h10%20m0%200%20h62%20m20%2044%20h10%20m26%200%20h10%20m3%200%20h-3%22%2F%3E%3Cpolygon%20points%3D%22267%2061%20275%2057%20275%2065%22%2F%3E%3Cpolygon%20points%3D%22267%2061%20259%2057%20259%2065%22%2F%3E%3C%2Fsvg%3E)

```
options  ::= '[' parameter ( ',' parameter )* ']'
```

referenced by:

* command
* environment

**parameter:**

![parameter](data:image/svg+xml,%3Csvg%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%20width%3D%22781%22%20height%3D%22115%22%3E%3Cdefs%3E%3Cstyle%20type%3D%22text%2Fcss%22%3E%40namespace%20%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%3B%20.line%20%7Bfill%3A%20none%3B%20stroke%3A%20%23332900%3B%20stroke-width%3A%201%3B%7D%20.bold-line%20%7Bstroke%3A%20%23141000%3B%20shape-rendering%3A%20crispEdges%3B%20stroke-width%3A%202%3B%7D%20.thin-line%20%7Bstroke%3A%20%231F1800%3B%20shape-rendering%3A%20crispEdges%7D%20.filled%20%7Bfill%3A%20%23332900%3B%20stroke%3A%20none%3B%7D%20text.terminal%20%7Bfont-family%3A%20Verdana%2C%20Sans-serif%3B%20font-size%3A%2012px%3B%20fill%3A%20%23141000%3B%20font-weight%3A%20bold%3B%20%7D%20text.nonterminal%20%7Bfont-family%3A%20Verdana%2C%20Sans-serif%3B%20font-size%3A%2012px%3B%20fill%3A%20%231A1400%3B%20font-weight%3A%20normal%3B%20%7D%20text.regexp%20%7Bfont-family%3A%20Verdana%2C%20Sans-serif%3B%20font-size%3A%2012px%3B%20fill%3A%20%231F1800%3B%20font-weight%3A%20normal%3B%20%7D%20rect%2C%20circle%2C%20polygon%20%7Bfill%3A%20%23332900%3B%20stroke%3A%20%23332900%3B%7D%20rect.terminal%20%7Bfill%3A%20%23FFDB4D%3B%20stroke%3A%20%23332900%3B%20stroke-width%3A%201%3B%7D%20rect.nonterminal%20%7Bfill%3A%20%23FFEC9E%3B%20stroke%3A%20%23332900%3B%20stroke-width%3A%201%3B%7D%20rect.text%20%7Bfill%3A%20none%3B%20stroke%3A%20none%3B%7D%20polygon.regexp%20%7Bfill%3A%20%23FFF4C7%3B%20stroke%3A%20%23332900%3B%20stroke-width%3A%201%3B%7D%3C%2Fstyle%3E%3C%2Fdefs%3E%3Cpolygon%20points%3D%229%2051%201%2047%201%2055%22%2F%3E%3Cpolygon%20points%3D%2217%2051%209%2047%209%2055%22%2F%3E%3Crect%20x%3D%2251%22%20y%3D%223%22%20width%3D%2248%22%20height%3D%2232%22%2F%3E%3Crect%20x%3D%2249%22%20y%3D%221%22%20width%3D%2248%22%20height%3D%2232%22%20class%3D%22nonterminal%22%2F%3E%3Ctext%20class%3D%22nonterminal%22%20x%3D%2259%22%20y%3D%2221%22%3EWSP%3C%2Ftext%3E%3Crect%20x%3D%22139%22%20y%3D%2237%22%20width%3D%2276%22%20height%3D%2232%22%2F%3E%3Crect%20x%3D%22137%22%20y%3D%2235%22%20width%3D%2276%22%20height%3D%2232%22%20class%3D%22nonterminal%22%2F%3E%3Ctext%20class%3D%22nonterminal%22%20x%3D%22147%22%20y%3D%2255%22%3Eidentifier%3C%2Ftext%3E%3Crect%20x%3D%22255%22%20y%3D%223%22%20width%3D%2248%22%20height%3D%2232%22%2F%3E%3Crect%20x%3D%22253%22%20y%3D%221%22%20width%3D%2248%22%20height%3D%2232%22%20class%3D%22nonterminal%22%2F%3E%3Ctext%20class%3D%22nonterminal%22%20x%3D%22263%22%20y%3D%2221%22%3EWSP%3C%2Ftext%3E%3Crect%20x%3D%22343%22%20y%3D%2237%22%20width%3D%2230%22%20height%3D%2232%22%20rx%3D%2210%22%2F%3E%3Crect%20x%3D%22341%22%20y%3D%2235%22%20width%3D%2230%22%20height%3D%2232%22%20class%3D%22terminal%22%20rx%3D%2210%22%2F%3E%3Ctext%20class%3D%22terminal%22%20x%3D%22351%22%20y%3D%2255%22%3E%3D%3C%2Ftext%3E%3Crect%20x%3D%22413%22%20y%3D%223%22%20width%3D%2248%22%20height%3D%2232%22%2F%3E%3Crect%20x%3D%22411%22%20y%3D%221%22%20width%3D%2248%22%20height%3D%2232%22%20class%3D%22nonterminal%22%2F%3E%3Ctext%20class%3D%22nonterminal%22%20x%3D%22421%22%20y%3D%2221%22%3EWSP%3C%2Ftext%3E%3Crect%20x%3D%22521%22%20y%3D%2237%22%20width%3D%22104%22%20height%3D%2232%22%2F%3E%3Crect%20x%3D%22519%22%20y%3D%2235%22%20width%3D%22104%22%20height%3D%2232%22%20class%3D%22nonterminal%22%2F%3E%3Ctext%20class%3D%22nonterminal%22%20x%3D%22529%22%20y%3D%2255%22%3Equoted-value%3C%2Ftext%3E%3Crect%20x%3D%22521%22%20y%3D%2281%22%20width%3D%2254%22%20height%3D%2232%22%2F%3E%3Crect%20x%3D%22519%22%20y%3D%2279%22%20width%3D%2254%22%20height%3D%2232%22%20class%3D%22nonterminal%22%2F%3E%3Ctext%20class%3D%22nonterminal%22%20x%3D%22529%22%20y%3D%2299%22%3Evalue%3C%2Ftext%3E%3Crect%20x%3D%22685%22%20y%3D%223%22%20width%3D%2248%22%20height%3D%2232%22%2F%3E%3Crect%20x%3D%22683%22%20y%3D%221%22%20width%3D%2248%22%20height%3D%2232%22%20class%3D%22nonterminal%22%2F%3E%3Ctext%20class%3D%22nonterminal%22%20x%3D%22693%22%20y%3D%2221%22%3EWSP%3C%2Ftext%3E%3Cpath%20class%3D%22line%22%20d%3D%22m17%2051%20h2%20m20%200%20h10%20m0%200%20h58%20m-88%200%20l20%200%20m-1%200%20q-9%200%20-9%20-10%20l0%20-14%20q0%20-10%2010%20-10%20m68%2034%20l20%200%20m-20%200%20q10%200%2010%20-10%20l0%20-14%20q0%20-10%20-10%20-10%20m-68%200%20h10%20m48%200%20h10%20m20%2034%20h10%20m76%200%20h10%20m20%200%20h10%20m0%200%20h58%20m-88%200%20l20%200%20m-1%200%20q-9%200%20-9%20-10%20l0%20-14%20q0%20-10%2010%20-10%20m68%2034%20l20%200%20m-20%200%20q10%200%2010%20-10%20l0%20-14%20q0%20-10%20-10%20-10%20m-68%200%20h10%20m48%200%20h10%20m20%2034%20h10%20m30%200%20h10%20m20%200%20h10%20m0%200%20h58%20m-88%200%20l20%200%20m-1%200%20q-9%200%20-9%20-10%20l0%20-14%20q0%20-10%2010%20-10%20m68%2034%20l20%200%20m-20%200%20q10%200%2010%20-10%20l0%20-14%20q0%20-10%20-10%20-10%20m-68%200%20h10%20m48%200%20h10%20m40%2034%20h10%20m104%200%20h10%20m-144%200%20h20%20m124%200%20h20%20m-164%200%20q10%200%2010%2010%20m144%200%20q0%20-10%2010%20-10%20m-154%2010%20v24%20m144%200%20v-24%20m-144%2024%20q0%2010%2010%2010%20m124%200%20q10%200%2010%20-10%20m-134%2010%20h10%20m54%200%20h10%20m0%200%20h50%20m40%20-44%20h10%20m0%200%20h58%20m-88%200%20l20%200%20m-1%200%20q-9%200%20-9%20-10%20l0%20-14%20q0%20-10%2010%20-10%20m68%2034%20l20%200%20m-20%200%20q10%200%2010%20-10%20l0%20-14%20q0%20-10%20-10%20-10%20m-68%200%20h10%20m48%200%20h10%20m23%2034%20h-3%22%2F%3E%3Cpolygon%20points%3D%22771%2051%20779%2047%20779%2055%22%2F%3E%3Cpolygon%20points%3D%22771%2051%20763%2047%20763%2055%22%2F%3E%3C%2Fsvg%3E)

```
parameter
         ::= WSP* identifier WSP* '=' WSP* ( quoted-value | value ) WSP*
```

referenced by:

* options

**quoted-value:**

![quoted-value](data:image/svg+xml,%3Csvg%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%20width%3D%22421%22%20height%3D%2271%22%3E%3Cdefs%3E%3Cstyle%20type%3D%22text%2Fcss%22%3E%40namespace%20%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%3B%20.line%20%7Bfill%3A%20none%3B%20stroke%3A%20%23332900%3B%20stroke-width%3A%201%3B%7D%20.bold-line%20%7Bstroke%3A%20%23141000%3B%20shape-rendering%3A%20crispEdges%3B%20stroke-width%3A%202%3B%7D%20.thin-line%20%7Bstroke%3A%20%231F1800%3B%20shape-rendering%3A%20crispEdges%7D%20.filled%20%7Bfill%3A%20%23332900%3B%20stroke%3A%20none%3B%7D%20text.terminal%20%7Bfont-family%3A%20Verdana%2C%20Sans-serif%3B%20font-size%3A%2012px%3B%20fill%3A%20%23141000%3B%20font-weight%3A%20bold%3B%20%7D%20text.nonterminal%20%7Bfont-family%3A%20Verdana%2C%20Sans-serif%3B%20font-size%3A%2012px%3B%20fill%3A%20%231A1400%3B%20font-weight%3A%20normal%3B%20%7D%20text.regexp%20%7Bfont-family%3A%20Verdana%2C%20Sans-serif%3B%20font-size%3A%2012px%3B%20fill%3A%20%231F1800%3B%20font-weight%3A%20normal%3B%20%7D%20rect%2C%20circle%2C%20polygon%20%7Bfill%3A%20%23332900%3B%20stroke%3A%20%23332900%3B%7D%20rect.terminal%20%7Bfill%3A%20%23FFDB4D%3B%20stroke%3A%20%23332900%3B%20stroke-width%3A%201%3B%7D%20rect.nonterminal%20%7Bfill%3A%20%23FFEC9E%3B%20stroke%3A%20%23332900%3B%20stroke-width%3A%201%3B%7D%20rect.text%20%7Bfill%3A%20none%3B%20stroke%3A%20none%3B%7D%20polygon.regexp%20%7Bfill%3A%20%23FFF4C7%3B%20stroke%3A%20%23332900%3B%20stroke-width%3A%201%3B%7D%3C%2Fstyle%3E%3C%2Fdefs%3E%3Cpolygon%20points%3D%229%2051%201%2047%201%2055%22%2F%3E%3Cpolygon%20points%3D%2217%2051%209%2047%209%2055%22%2F%3E%3Crect%20x%3D%2231%22%20y%3D%2237%22%20width%3D%2272%22%20height%3D%2232%22%2F%3E%3Crect%20x%3D%2229%22%20y%3D%2235%22%20width%3D%2272%22%20height%3D%2232%22%20class%3D%22nonterminal%22%2F%3E%3Ctext%20class%3D%22nonterminal%22%20x%3D%2239%22%20y%3D%2255%22%3EDQUOTE%3C%2Ftext%3E%3Crect%20x%3D%22143%22%20y%3D%223%22%20width%3D%22138%22%20height%3D%2232%22%2F%3E%3Crect%20x%3D%22141%22%20y%3D%221%22%20width%3D%22138%22%20height%3D%2232%22%20class%3D%22nonterminal%22%2F%3E%3Ctext%20class%3D%22nonterminal%22%20x%3D%22151%22%20y%3D%2221%22%3Equoted-value-char%3C%2Ftext%3E%3Crect%20x%3D%22321%22%20y%3D%2237%22%20width%3D%2272%22%20height%3D%2232%22%2F%3E%3Crect%20x%3D%22319%22%20y%3D%2235%22%20width%3D%2272%22%20height%3D%2232%22%20class%3D%22nonterminal%22%2F%3E%3Ctext%20class%3D%22nonterminal%22%20x%3D%22329%22%20y%3D%2255%22%3EDQUOTE%3C%2Ftext%3E%3Cpath%20class%3D%22line%22%20d%3D%22m17%2051%20h2%20m0%200%20h10%20m72%200%20h10%20m20%200%20h10%20m0%200%20h148%20m-178%200%20l20%200%20m-1%200%20q-9%200%20-9%20-10%20l0%20-14%20q0%20-10%2010%20-10%20m158%2034%20l20%200%20m-20%200%20q10%200%2010%20-10%20l0%20-14%20q0%20-10%20-10%20-10%20m-158%200%20h10%20m138%200%20h10%20m20%2034%20h10%20m72%200%20h10%20m3%200%20h-3%22%2F%3E%3Cpolygon%20points%3D%22411%2051%20419%2047%20419%2055%22%2F%3E%3Cpolygon%20points%3D%22411%2051%20403%2047%20403%2055%22%2F%3E%3C%2Fsvg%3E)

```
quoted-value
         ::= DQUOTE quoted-value-char* DQUOTE
```

referenced by:

* parameter

**quoted-value-char:**

![quoted-value-char](data:image/svg+xml,%3Csvg%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%20width%3D%22209%22%20height%3D%22257%22%3E%3Cdefs%3E%3Cstyle%20type%3D%22text%2Fcss%22%3E%40namespace%20%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%3B%20.line%20%7Bfill%3A%20none%3B%20stroke%3A%20%23332900%3B%20stroke-width%3A%201%3B%7D%20.bold-line%20%7Bstroke%3A%20%23141000%3B%20shape-rendering%3A%20crispEdges%3B%20stroke-width%3A%202%3B%7D%20.thin-line%20%7Bstroke%3A%20%231F1800%3B%20shape-rendering%3A%20crispEdges%7D%20.filled%20%7Bfill%3A%20%23332900%3B%20stroke%3A%20none%3B%7D%20text.terminal%20%7Bfont-family%3A%20Verdana%2C%20Sans-serif%3B%20font-size%3A%2012px%3B%20fill%3A%20%23141000%3B%20font-weight%3A%20bold%3B%20%7D%20text.nonterminal%20%7Bfont-family%3A%20Verdana%2C%20Sans-serif%3B%20font-size%3A%2012px%3B%20fill%3A%20%231A1400%3B%20font-weight%3A%20normal%3B%20%7D%20text.regexp%20%7Bfont-family%3A%20Verdana%2C%20Sans-serif%3B%20font-size%3A%2012px%3B%20fill%3A%20%231F1800%3B%20font-weight%3A%20normal%3B%20%7D%20rect%2C%20circle%2C%20polygon%20%7Bfill%3A%20%23332900%3B%20stroke%3A%20%23332900%3B%7D%20rect.terminal%20%7Bfill%3A%20%23FFDB4D%3B%20stroke%3A%20%23332900%3B%20stroke-width%3A%201%3B%7D%20rect.nonterminal%20%7Bfill%3A%20%23FFEC9E%3B%20stroke%3A%20%23332900%3B%20stroke-width%3A%201%3B%7D%20rect.text%20%7Bfill%3A%20none%3B%20stroke%3A%20none%3B%7D%20polygon.regexp%20%7Bfill%3A%20%23FFF4C7%3B%20stroke%3A%20%23332900%3B%20stroke-width%3A%201%3B%7D%3C%2Fstyle%3E%3C%2Fdefs%3E%3Cpolygon%20points%3D%229%2017%201%2013%201%2021%22%2F%3E%3Cpolygon%20points%3D%2217%2017%209%2013%209%2021%22%2F%3E%3Crect%20x%3D%2251%22%20y%3D%223%22%20width%3D%2228%22%20height%3D%2232%22%20rx%3D%2210%22%2F%3E%3Crect%20x%3D%2249%22%20y%3D%221%22%20width%3D%2228%22%20height%3D%2232%22%20class%3D%22terminal%22%20rx%3D%2210%22%2F%3E%3Ctext%20class%3D%22terminal%22%20x%3D%2259%22%20y%3D%2221%22%3E%5C%3C%2Ftext%3E%3Crect%20x%3D%2299%22%20y%3D%223%22%20width%3D%2226%22%20height%3D%2232%22%20rx%3D%2210%22%2F%3E%3Crect%20x%3D%2297%22%20y%3D%221%22%20width%3D%2226%22%20height%3D%2232%22%20class%3D%22terminal%22%20rx%3D%2210%22%2F%3E%3Ctext%20class%3D%22terminal%22%20x%3D%22107%22%20y%3D%2221%22%3E%22%3C%2Ftext%3E%3Cpolygon%20points%3D%2251%2063%2058%2047%20148%2047%20155%2063%20148%2079%2058%2079%22%2F%3E%3Cpolygon%20points%3D%2249%2061%2056%2045%20146%2045%20153%2061%20146%2077%2056%2077%22%20class%3D%22regexp%22%2F%3E%3Ctext%20class%3D%22regexp%22%20x%3D%2264%22%20y%3D%2265%22%3E%5B%23x0-%23x21%5D%3C%2Ftext%3E%3Cpolygon%20points%3D%2251%20107%2058%2091%20154%2091%20161%20107%20154%20123%2058%20123%22%2F%3E%3Cpolygon%20points%3D%2249%20105%2056%2089%20152%2089%20159%20105%20152%20121%2056%20121%22%20class%3D%22regexp%22%2F%3E%3Ctext%20class%3D%22regexp%22%20x%3D%2264%22%20y%3D%22109%22%3E%5B%23x23-%23x7F%5D%3C%2Ftext%3E%3Crect%20x%3D%2251%22%20y%3D%22135%22%20width%3D%2258%22%20height%3D%2232%22%2F%3E%3Crect%20x%3D%2249%22%20y%3D%22133%22%20width%3D%2258%22%20height%3D%2232%22%20class%3D%22nonterminal%22%2F%3E%3Ctext%20class%3D%22nonterminal%22%20x%3D%2259%22%20y%3D%22153%22%3Eutf8-2%3C%2Ftext%3E%3Crect%20x%3D%2251%22%20y%3D%22179%22%20width%3D%2258%22%20height%3D%2232%22%2F%3E%3Crect%20x%3D%2249%22%20y%3D%22177%22%20width%3D%2258%22%20height%3D%2232%22%20class%3D%22nonterminal%22%2F%3E%3Ctext%20class%3D%22nonterminal%22%20x%3D%2259%22%20y%3D%22197%22%3Eutf8-3%3C%2Ftext%3E%3Crect%20x%3D%2251%22%20y%3D%22223%22%20width%3D%2258%22%20height%3D%2232%22%2F%3E%3Crect%20x%3D%2249%22%20y%3D%22221%22%20width%3D%2258%22%20height%3D%2232%22%20class%3D%22nonterminal%22%2F%3E%3Ctext%20class%3D%22nonterminal%22%20x%3D%2259%22%20y%3D%22241%22%3Eutf8-4%3C%2Ftext%3E%3Cpath%20class%3D%22line%22%20d%3D%22m17%2017%20h2%20m20%200%20h10%20m28%200%20h10%20m0%200%20h10%20m26%200%20h10%20m0%200%20h36%20m-150%200%20h20%20m130%200%20h20%20m-170%200%20q10%200%2010%2010%20m150%200%20q0%20-10%2010%20-10%20m-160%2010%20v24%20m150%200%20v-24%20m-150%2024%20q0%2010%2010%2010%20m130%200%20q10%200%2010%20-10%20m-140%2010%20h10%20m104%200%20h10%20m0%200%20h6%20m-140%20-10%20v20%20m150%200%20v-20%20m-150%2020%20v24%20m150%200%20v-24%20m-150%2024%20q0%2010%2010%2010%20m130%200%20q10%200%2010%20-10%20m-140%2010%20h10%20m110%200%20h10%20m-140%20-10%20v20%20m150%200%20v-20%20m-150%2020%20v24%20m150%200%20v-24%20m-150%2024%20q0%2010%2010%2010%20m130%200%20q10%200%2010%20-10%20m-140%2010%20h10%20m58%200%20h10%20m0%200%20h52%20m-140%20-10%20v20%20m150%200%20v-20%20m-150%2020%20v24%20m150%200%20v-24%20m-150%2024%20q0%2010%2010%2010%20m130%200%20q10%200%2010%20-10%20m-140%2010%20h10%20m58%200%20h10%20m0%200%20h52%20m-140%20-10%20v20%20m150%200%20v-20%20m-150%2020%20v24%20m150%200%20v-24%20m-150%2024%20q0%2010%2010%2010%20m130%200%20q10%200%2010%20-10%20m-140%2010%20h10%20m58%200%20h10%20m0%200%20h52%20m23%20-220%20h-3%22%2F%3E%3Cpolygon%20points%3D%22199%2017%20207%2013%20207%2021%22%2F%3E%3Cpolygon%20points%3D%22199%2017%20191%2013%20191%2021%22%2F%3E%3C%2Fsvg%3E)

```
quoted-value-char
         ::= '\' '"'
           | [#x0-#x21]
           | [#x23-#x7F]
           | utf8-2
           | utf8-3
           | utf8-4
```

referenced by:

* quoted-value

**value:**

![value](data:image/svg+xml,%3Csvg%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%20width%3D%22185%22%20height%3D%2257%22%3E%3Cdefs%3E%3Cstyle%20type%3D%22text%2Fcss%22%3E%40namespace%20%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%3B%20.line%20%7Bfill%3A%20none%3B%20stroke%3A%20%23332900%3B%20stroke-width%3A%201%3B%7D%20.bold-line%20%7Bstroke%3A%20%23141000%3B%20shape-rendering%3A%20crispEdges%3B%20stroke-width%3A%202%3B%7D%20.thin-line%20%7Bstroke%3A%20%231F1800%3B%20shape-rendering%3A%20crispEdges%7D%20.filled%20%7Bfill%3A%20%23332900%3B%20stroke%3A%20none%3B%7D%20text.terminal%20%7Bfont-family%3A%20Verdana%2C%20Sans-serif%3B%20font-size%3A%2012px%3B%20fill%3A%20%23141000%3B%20font-weight%3A%20bold%3B%20%7D%20text.nonterminal%20%7Bfont-family%3A%20Verdana%2C%20Sans-serif%3B%20font-size%3A%2012px%3B%20fill%3A%20%231A1400%3B%20font-weight%3A%20normal%3B%20%7D%20text.regexp%20%7Bfont-family%3A%20Verdana%2C%20Sans-serif%3B%20font-size%3A%2012px%3B%20fill%3A%20%231F1800%3B%20font-weight%3A%20normal%3B%20%7D%20rect%2C%20circle%2C%20polygon%20%7Bfill%3A%20%23332900%3B%20stroke%3A%20%23332900%3B%7D%20rect.terminal%20%7Bfill%3A%20%23FFDB4D%3B%20stroke%3A%20%23332900%3B%20stroke-width%3A%201%3B%7D%20rect.nonterminal%20%7Bfill%3A%20%23FFEC9E%3B%20stroke%3A%20%23332900%3B%20stroke-width%3A%201%3B%7D%20rect.text%20%7Bfill%3A%20none%3B%20stroke%3A%20none%3B%7D%20polygon.regexp%20%7Bfill%3A%20%23FFF4C7%3B%20stroke%3A%20%23332900%3B%20stroke-width%3A%201%3B%7D%3C%2Fstyle%3E%3C%2Fdefs%3E%3Cpolygon%20points%3D%229%2051%201%2047%201%2055%22%2F%3E%3Cpolygon%20points%3D%2217%2051%209%2047%209%2055%22%2F%3E%3Crect%20x%3D%2251%22%20y%3D%223%22%20width%3D%2286%22%20height%3D%2232%22%2F%3E%3Crect%20x%3D%2249%22%20y%3D%221%22%20width%3D%2286%22%20height%3D%2232%22%20class%3D%22nonterminal%22%2F%3E%3Ctext%20class%3D%22nonterminal%22%20x%3D%2259%22%20y%3D%2221%22%3Evalue-char%3C%2Ftext%3E%3Cpath%20class%3D%22line%22%20d%3D%22m17%2051%20h2%20m20%200%20h10%20m0%200%20h96%20m-126%200%20l20%200%20m-1%200%20q-9%200%20-9%20-10%20l0%20-14%20q0%20-10%2010%20-10%20m106%2034%20l20%200%20m-20%200%20q10%200%2010%20-10%20l0%20-14%20q0%20-10%20-10%20-10%20m-106%200%20h10%20m86%200%20h10%20m23%2034%20h-3%22%2F%3E%3Cpolygon%20points%3D%22175%2051%20183%2047%20183%2055%22%2F%3E%3Cpolygon%20points%3D%22175%2051%20167%2047%20167%2055%22%2F%3E%3C%2Fsvg%3E)

```
value    ::= value-char*
```

referenced by:

* parameter

**value-char:**

![value-char](data:image/svg+xml,%3Csvg%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%20width%3D%22211%22%20height%3D%22301%22%3E%3Cdefs%3E%3Cstyle%20type%3D%22text%2Fcss%22%3E%40namespace%20%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%3B%20.line%20%7Bfill%3A%20none%3B%20stroke%3A%20%23332900%3B%20stroke-width%3A%201%3B%7D%20.bold-line%20%7Bstroke%3A%20%23141000%3B%20shape-rendering%3A%20crispEdges%3B%20stroke-width%3A%202%3B%7D%20.thin-line%20%7Bstroke%3A%20%231F1800%3B%20shape-rendering%3A%20crispEdges%7D%20.filled%20%7Bfill%3A%20%23332900%3B%20stroke%3A%20none%3B%7D%20text.terminal%20%7Bfont-family%3A%20Verdana%2C%20Sans-serif%3B%20font-size%3A%2012px%3B%20fill%3A%20%23141000%3B%20font-weight%3A%20bold%3B%20%7D%20text.nonterminal%20%7Bfont-family%3A%20Verdana%2C%20Sans-serif%3B%20font-size%3A%2012px%3B%20fill%3A%20%231A1400%3B%20font-weight%3A%20normal%3B%20%7D%20text.regexp%20%7Bfont-family%3A%20Verdana%2C%20Sans-serif%3B%20font-size%3A%2012px%3B%20fill%3A%20%231F1800%3B%20font-weight%3A%20normal%3B%20%7D%20rect%2C%20circle%2C%20polygon%20%7Bfill%3A%20%23332900%3B%20stroke%3A%20%23332900%3B%7D%20rect.terminal%20%7Bfill%3A%20%23FFDB4D%3B%20stroke%3A%20%23332900%3B%20stroke-width%3A%201%3B%7D%20rect.nonterminal%20%7Bfill%3A%20%23FFEC9E%3B%20stroke%3A%20%23332900%3B%20stroke-width%3A%201%3B%7D%20rect.text%20%7Bfill%3A%20none%3B%20stroke%3A%20none%3B%7D%20polygon.regexp%20%7Bfill%3A%20%23FFF4C7%3B%20stroke%3A%20%23332900%3B%20stroke-width%3A%201%3B%7D%3C%2Fstyle%3E%3C%2Fdefs%3E%3Cpolygon%20points%3D%229%2017%201%2013%201%2021%22%2F%3E%3Cpolygon%20points%3D%2217%2017%209%2013%209%2021%22%2F%3E%3Cpolygon%20points%3D%2251%2019%2058%203%20148%203%20155%2019%20148%2035%2058%2035%22%2F%3E%3Cpolygon%20points%3D%2249%2017%2056%201%20146%201%20153%2017%20146%2033%2056%2033%22%20class%3D%22regexp%22%2F%3E%3Ctext%20class%3D%22regexp%22%20x%3D%2264%22%20y%3D%2221%22%3E%5B%23x0-%23x21%5D%3C%2Ftext%3E%3Cpolygon%20points%3D%2251%2063%2058%2047%20156%2047%20163%2063%20156%2079%2058%2079%22%2F%3E%3Cpolygon%20points%3D%2249%2061%2056%2045%20154%2045%20161%2061%20154%2077%2056%2077%22%20class%3D%22regexp%22%2F%3E%3Ctext%20class%3D%22regexp%22%20x%3D%2264%22%20y%3D%2265%22%3E%5B%23x23-%23x2B%5D%3C%2Ftext%3E%3Cpolygon%20points%3D%2251%20107%2058%2091%20104%2091%20111%20107%20104%20123%2058%20123%22%2F%3E%3Cpolygon%20points%3D%2249%20105%2056%2089%20102%2089%20109%20105%20102%20121%2056%20121%22%20class%3D%22regexp%22%2F%3E%3Ctext%20class%3D%22regexp%22%20x%3D%2264%22%20y%3D%22109%22%3E%5B%26lt%3B-%5C%5D%3C%2Ftext%3E%3Cpolygon%20points%3D%2251%20151%2058%20135%20154%20135%20161%20151%20154%20167%2058%20167%22%2F%3E%3Cpolygon%20points%3D%2249%20149%2056%20133%20152%20133%20159%20149%20152%20165%2056%20165%22%20class%3D%22regexp%22%2F%3E%3Ctext%20class%3D%22regexp%22%20x%3D%2264%22%20y%3D%22153%22%3E%5B%23x3E-%23x7F%5D%3C%2Ftext%3E%3Crect%20x%3D%2251%22%20y%3D%22179%22%20width%3D%2258%22%20height%3D%2232%22%2F%3E%3Crect%20x%3D%2249%22%20y%3D%22177%22%20width%3D%2258%22%20height%3D%2232%22%20class%3D%22nonterminal%22%2F%3E%3Ctext%20class%3D%22nonterminal%22%20x%3D%2259%22%20y%3D%22197%22%3Eutf8-2%3C%2Ftext%3E%3Crect%20x%3D%2251%22%20y%3D%22223%22%20width%3D%2258%22%20height%3D%2232%22%2F%3E%3Crect%20x%3D%2249%22%20y%3D%22221%22%20width%3D%2258%22%20height%3D%2232%22%20class%3D%22nonterminal%22%2F%3E%3Ctext%20class%3D%22nonterminal%22%20x%3D%2259%22%20y%3D%22241%22%3Eutf8-3%3C%2Ftext%3E%3Crect%20x%3D%2251%22%20y%3D%22267%22%20width%3D%2258%22%20height%3D%2232%22%2F%3E%3Crect%20x%3D%2249%22%20y%3D%22265%22%20width%3D%2258%22%20height%3D%2232%22%20class%3D%22nonterminal%22%2F%3E%3Ctext%20class%3D%22nonterminal%22%20x%3D%2259%22%20y%3D%22285%22%3Eutf8-4%3C%2Ftext%3E%3Cpath%20class%3D%22line%22%20d%3D%22m17%2017%20h2%20m20%200%20h10%20m104%200%20h10%20m0%200%20h8%20m-152%200%20h20%20m132%200%20h20%20m-172%200%20q10%200%2010%2010%20m152%200%20q0%20-10%2010%20-10%20m-162%2010%20v24%20m152%200%20v-24%20m-152%2024%20q0%2010%2010%2010%20m132%200%20q10%200%2010%20-10%20m-142%2010%20h10%20m112%200%20h10%20m-142%20-10%20v20%20m152%200%20v-20%20m-152%2020%20v24%20m152%200%20v-24%20m-152%2024%20q0%2010%2010%2010%20m132%200%20q10%200%2010%20-10%20m-142%2010%20h10%20m60%200%20h10%20m0%200%20h52%20m-142%20-10%20v20%20m152%200%20v-20%20m-152%2020%20v24%20m152%200%20v-24%20m-152%2024%20q0%2010%2010%2010%20m132%200%20q10%200%2010%20-10%20m-142%2010%20h10%20m110%200%20h10%20m0%200%20h2%20m-142%20-10%20v20%20m152%200%20v-20%20m-152%2020%20v24%20m152%200%20v-24%20m-152%2024%20q0%2010%2010%2010%20m132%200%20q10%200%2010%20-10%20m-142%2010%20h10%20m58%200%20h10%20m0%200%20h54%20m-142%20-10%20v20%20m152%200%20v-20%20m-152%2020%20v24%20m152%200%20v-24%20m-152%2024%20q0%2010%2010%2010%20m132%200%20q10%200%2010%20-10%20m-142%2010%20h10%20m58%200%20h10%20m0%200%20h54%20m-142%20-10%20v20%20m152%200%20v-20%20m-152%2020%20v24%20m152%200%20v-24%20m-152%2024%20q0%2010%2010%2010%20m132%200%20q10%200%2010%20-10%20m-142%2010%20h10%20m58%200%20h10%20m0%200%20h54%20m23%20-264%20h-3%22%2F%3E%3Cpolygon%20points%3D%22201%2017%20209%2013%20209%2021%22%2F%3E%3Cpolygon%20points%3D%22201%2017%20193%2013%20193%2021%22%2F%3E%3C%2Fsvg%3E)

```
value-char
         ::= [#x0-#x21]
           | [#x23-#x2B]
           | [<-\]
           | [#x3E-#x7F]
           | utf8-2
           | utf8-3
           | utf8-4
```

referenced by:

* value

**text-char:**

![text-char](data:image/svg+xml,%3Csvg%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%20width%3D%22221%22%20height%3D%22521%22%3E%3Cdefs%3E%3Cstyle%20type%3D%22text%2Fcss%22%3E%40namespace%20%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%3B%20.line%20%7Bfill%3A%20none%3B%20stroke%3A%20%23332900%3B%20stroke-width%3A%201%3B%7D%20.bold-line%20%7Bstroke%3A%20%23141000%3B%20shape-rendering%3A%20crispEdges%3B%20stroke-width%3A%202%3B%7D%20.thin-line%20%7Bstroke%3A%20%231F1800%3B%20shape-rendering%3A%20crispEdges%7D%20.filled%20%7Bfill%3A%20%23332900%3B%20stroke%3A%20none%3B%7D%20text.terminal%20%7Bfont-family%3A%20Verdana%2C%20Sans-serif%3B%20font-size%3A%2012px%3B%20fill%3A%20%23141000%3B%20font-weight%3A%20bold%3B%20%7D%20text.nonterminal%20%7Bfont-family%3A%20Verdana%2C%20Sans-serif%3B%20font-size%3A%2012px%3B%20fill%3A%20%231A1400%3B%20font-weight%3A%20normal%3B%20%7D%20text.regexp%20%7Bfont-family%3A%20Verdana%2C%20Sans-serif%3B%20font-size%3A%2012px%3B%20fill%3A%20%231F1800%3B%20font-weight%3A%20normal%3B%20%7D%20rect%2C%20circle%2C%20polygon%20%7Bfill%3A%20%23332900%3B%20stroke%3A%20%23332900%3B%7D%20rect.terminal%20%7Bfill%3A%20%23FFDB4D%3B%20stroke%3A%20%23332900%3B%20stroke-width%3A%201%3B%7D%20rect.nonterminal%20%7Bfill%3A%20%23FFEC9E%3B%20stroke%3A%20%23332900%3B%20stroke-width%3A%201%3B%7D%20rect.text%20%7Bfill%3A%20none%3B%20stroke%3A%20none%3B%7D%20polygon.regexp%20%7Bfill%3A%20%23FFF4C7%3B%20stroke%3A%20%23332900%3B%20stroke-width%3A%201%3B%7D%3C%2Fstyle%3E%3C%2Fdefs%3E%3Cpolygon%20points%3D%229%2017%201%2013%201%2021%22%2F%3E%3Cpolygon%20points%3D%2217%2017%209%2013%209%2021%22%2F%3E%3Crect%20x%3D%2251%22%20y%3D%223%22%20width%3D%2228%22%20height%3D%2232%22%20rx%3D%2210%22%2F%3E%3Crect%20x%3D%2249%22%20y%3D%221%22%20width%3D%2228%22%20height%3D%2232%22%20class%3D%22terminal%22%20rx%3D%2210%22%2F%3E%3Ctext%20class%3D%22terminal%22%20x%3D%2259%22%20y%3D%2221%22%3E%5C%3C%2Ftext%3E%3Crect%20x%3D%22119%22%20y%3D%223%22%20width%3D%2228%22%20height%3D%2232%22%20rx%3D%2210%22%2F%3E%3Crect%20x%3D%22117%22%20y%3D%221%22%20width%3D%2228%22%20height%3D%2232%22%20class%3D%22terminal%22%20rx%3D%2210%22%2F%3E%3Ctext%20class%3D%22terminal%22%20x%3D%22127%22%20y%3D%2221%22%3E%5C%3C%2Ftext%3E%3Crect%20x%3D%22119%22%20y%3D%2247%22%20width%3D%2234%22%20height%3D%2232%22%20rx%3D%2210%22%2F%3E%3Crect%20x%3D%22117%22%20y%3D%2245%22%20width%3D%2234%22%20height%3D%2232%22%20class%3D%22terminal%22%20rx%3D%2210%22%2F%3E%3Ctext%20class%3D%22terminal%22%20x%3D%22127%22%20y%3D%2265%22%3E%25%3C%2Ftext%3E%3Crect%20x%3D%22119%22%20y%3D%2291%22%20width%3D%2228%22%20height%3D%2232%22%20rx%3D%2210%22%2F%3E%3Crect%20x%3D%22117%22%20y%3D%2289%22%20width%3D%2228%22%20height%3D%2232%22%20class%3D%22terminal%22%20rx%3D%2210%22%2F%3E%3Ctext%20class%3D%22terminal%22%20x%3D%22127%22%20y%3D%22109%22%3E%7B%3C%2Ftext%3E%3Crect%20x%3D%22119%22%20y%3D%22135%22%20width%3D%2228%22%20height%3D%2232%22%20rx%3D%2210%22%2F%3E%3Crect%20x%3D%22117%22%20y%3D%22133%22%20width%3D%2228%22%20height%3D%2232%22%20class%3D%22terminal%22%20rx%3D%2210%22%2F%3E%3Ctext%20class%3D%22terminal%22%20x%3D%22127%22%20y%3D%22153%22%3E%7D%3C%2Ftext%3E%3Cpolygon%20points%3D%2251%20195%2058%20179%20148%20179%20155%20195%20148%20211%2058%20211%22%2F%3E%3Cpolygon%20points%3D%2249%20193%2056%20177%20146%20177%20153%20193%20146%20209%2056%20209%22%20class%3D%22regexp%22%2F%3E%3Ctext%20class%3D%22regexp%22%20x%3D%2264%22%20y%3D%22197%22%3E%5B%23x0-%23x24%5D%3C%2Ftext%3E%3Cpolygon%20points%3D%2251%20239%2058%20223%20104%20223%20111%20239%20104%20255%2058%20255%22%2F%3E%3Cpolygon%20points%3D%2249%20237%2056%20221%20102%20221%20109%20237%20102%20253%2056%20253%22%20class%3D%22regexp%22%2F%3E%3Ctext%20class%3D%22regexp%22%20x%3D%2264%22%20y%3D%22241%22%3E%5B%26amp%3B-%5B%5D%3C%2Ftext%3E%3Cpolygon%20points%3D%2251%20283%2058%20267%20156%20267%20163%20283%20156%20299%2058%20299%22%2F%3E%3Cpolygon%20points%3D%2249%20281%2056%20265%20154%20265%20161%20281%20154%20297%2056%20297%22%20class%3D%22regexp%22%2F%3E%3Ctext%20class%3D%22regexp%22%20x%3D%2264%22%20y%3D%22285%22%3E%5B%23x5D-%23x7A%5D%3C%2Ftext%3E%3Crect%20x%3D%2251%22%20y%3D%22311%22%20width%3D%2226%22%20height%3D%2232%22%20rx%3D%2210%22%2F%3E%3Crect%20x%3D%2249%22%20y%3D%22309%22%20width%3D%2226%22%20height%3D%2232%22%20class%3D%22terminal%22%20rx%3D%2210%22%2F%3E%3Ctext%20class%3D%22terminal%22%20x%3D%2259%22%20y%3D%22329%22%3E%7C%3C%2Ftext%3E%3Cpolygon%20points%3D%2251%20371%2058%20355%20154%20355%20161%20371%20154%20387%2058%20387%22%2F%3E%3Cpolygon%20points%3D%2249%20369%2056%20353%20152%20353%20159%20369%20152%20385%2056%20385%22%20class%3D%22regexp%22%2F%3E%3Ctext%20class%3D%22regexp%22%20x%3D%2264%22%20y%3D%22373%22%3E%5B%23x7E-%23x7F%5D%3C%2Ftext%3E%3Crect%20x%3D%2251%22%20y%3D%22399%22%20width%3D%2258%22%20height%3D%2232%22%2F%3E%3Crect%20x%3D%2249%22%20y%3D%22397%22%20width%3D%2258%22%20height%3D%2232%22%20class%3D%22nonterminal%22%2F%3E%3Ctext%20class%3D%22nonterminal%22%20x%3D%2259%22%20y%3D%22417%22%3Eutf8-2%3C%2Ftext%3E%3Crect%20x%3D%2251%22%20y%3D%22443%22%20width%3D%2258%22%20height%3D%2232%22%2F%3E%3Crect%20x%3D%2249%22%20y%3D%22441%22%20width%3D%2258%22%20height%3D%2232%22%20class%3D%22nonterminal%22%2F%3E%3Ctext%20class%3D%22nonterminal%22%20x%3D%2259%22%20y%3D%22461%22%3Eutf8-3%3C%2Ftext%3E%3Crect%20x%3D%2251%22%20y%3D%22487%22%20width%3D%2258%22%20height%3D%2232%22%2F%3E%3Crect%20x%3D%2249%22%20y%3D%22485%22%20width%3D%2258%22%20height%3D%2232%22%20class%3D%22nonterminal%22%2F%3E%3Ctext%20class%3D%22nonterminal%22%20x%3D%2259%22%20y%3D%22505%22%3Eutf8-4%3C%2Ftext%3E%3Cpath%20class%3D%22line%22%20d%3D%22m17%2017%20h2%20m20%200%20h10%20m28%200%20h10%20m20%200%20h10%20m28%200%20h10%20m0%200%20h6%20m-74%200%20h20%20m54%200%20h20%20m-94%200%20q10%200%2010%2010%20m74%200%20q0%20-10%2010%20-10%20m-84%2010%20v24%20m74%200%20v-24%20m-74%2024%20q0%2010%2010%2010%20m54%200%20q10%200%2010%20-10%20m-64%2010%20h10%20m34%200%20h10%20m-64%20-10%20v20%20m74%200%20v-20%20m-74%2020%20v24%20m74%200%20v-24%20m-74%2024%20q0%2010%2010%2010%20m54%200%20q10%200%2010%20-10%20m-64%2010%20h10%20m28%200%20h10%20m0%200%20h6%20m-64%20-10%20v20%20m74%200%20v-20%20m-74%2020%20v24%20m74%200%20v-24%20m-74%2024%20q0%2010%2010%2010%20m54%200%20q10%200%2010%20-10%20m-64%2010%20h10%20m28%200%20h10%20m0%200%20h6%20m-142%20-132%20h20%20m142%200%20h20%20m-182%200%20q10%200%2010%2010%20m162%200%20q0%20-10%2010%20-10%20m-172%2010%20v156%20m162%200%20v-156%20m-162%20156%20q0%2010%2010%2010%20m142%200%20q10%200%2010%20-10%20m-152%2010%20h10%20m104%200%20h10%20m0%200%20h18%20m-152%20-10%20v20%20m162%200%20v-20%20m-162%2020%20v24%20m162%200%20v-24%20m-162%2024%20q0%2010%2010%2010%20m142%200%20q10%200%2010%20-10%20m-152%2010%20h10%20m60%200%20h10%20m0%200%20h62%20m-152%20-10%20v20%20m162%200%20v-20%20m-162%2020%20v24%20m162%200%20v-24%20m-162%2024%20q0%2010%2010%2010%20m142%200%20q10%200%2010%20-10%20m-152%2010%20h10%20m112%200%20h10%20m0%200%20h10%20m-152%20-10%20v20%20m162%200%20v-20%20m-162%2020%20v24%20m162%200%20v-24%20m-162%2024%20q0%2010%2010%2010%20m142%200%20q10%200%2010%20-10%20m-152%2010%20h10%20m26%200%20h10%20m0%200%20h96%20m-152%20-10%20v20%20m162%200%20v-20%20m-162%2020%20v24%20m162%200%20v-24%20m-162%2024%20q0%2010%2010%2010%20m142%200%20q10%200%2010%20-10%20m-152%2010%20h10%20m110%200%20h10%20m0%200%20h12%20m-152%20-10%20v20%20m162%200%20v-20%20m-162%2020%20v24%20m162%200%20v-24%20m-162%2024%20q0%2010%2010%2010%20m142%200%20q10%200%2010%20-10%20m-152%2010%20h10%20m58%200%20h10%20m0%200%20h64%20m-152%20-10%20v20%20m162%200%20v-20%20m-162%2020%20v24%20m162%200%20v-24%20m-162%2024%20q0%2010%2010%2010%20m142%200%20q10%200%2010%20-10%20m-152%2010%20h10%20m58%200%20h10%20m0%200%20h64%20m-152%20-10%20v20%20m162%200%20v-20%20m-162%2020%20v24%20m162%200%20v-24%20m-162%2024%20q0%2010%2010%2010%20m142%200%20q10%200%2010%20-10%20m-152%2010%20h10%20m58%200%20h10%20m0%200%20h64%20m23%20-484%20h-3%22%2F%3E%3Cpolygon%20points%3D%22211%2017%20219%2013%20219%2021%22%2F%3E%3Cpolygon%20points%3D%22211%2017%20203%2013%20203%2021%22%2F%3E%3C%2Fsvg%3E)

```
text-char
         ::= '\' ( '\' | '%' | '{' | '}' )
           | [#x0-#x24]
           | [&-[]
           | [#x5D-#x7A]
           | '|'
           | [#x7E-#x7F]
           | utf8-2
           | utf8-3
           | utf8-4
```

referenced by:

* text

**letter:**

![letter](data:image/svg+xml,%3Csvg%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%20width%3D%22159%22%20height%3D%22125%22%3E%3Cdefs%3E%3Cstyle%20type%3D%22text%2Fcss%22%3E%40namespace%20%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%3B%20.line%20%7Bfill%3A%20none%3B%20stroke%3A%20%23332900%3B%20stroke-width%3A%201%3B%7D%20.bold-line%20%7Bstroke%3A%20%23141000%3B%20shape-rendering%3A%20crispEdges%3B%20stroke-width%3A%202%3B%7D%20.thin-line%20%7Bstroke%3A%20%231F1800%3B%20shape-rendering%3A%20crispEdges%7D%20.filled%20%7Bfill%3A%20%23332900%3B%20stroke%3A%20none%3B%7D%20text.terminal%20%7Bfont-family%3A%20Verdana%2C%20Sans-serif%3B%20font-size%3A%2012px%3B%20fill%3A%20%23141000%3B%20font-weight%3A%20bold%3B%20%7D%20text.nonterminal%20%7Bfont-family%3A%20Verdana%2C%20Sans-serif%3B%20font-size%3A%2012px%3B%20fill%3A%20%231A1400%3B%20font-weight%3A%20normal%3B%20%7D%20text.regexp%20%7Bfont-family%3A%20Verdana%2C%20Sans-serif%3B%20font-size%3A%2012px%3B%20fill%3A%20%231F1800%3B%20font-weight%3A%20normal%3B%20%7D%20rect%2C%20circle%2C%20polygon%20%7Bfill%3A%20%23332900%3B%20stroke%3A%20%23332900%3B%7D%20rect.terminal%20%7Bfill%3A%20%23FFDB4D%3B%20stroke%3A%20%23332900%3B%20stroke-width%3A%201%3B%7D%20rect.nonterminal%20%7Bfill%3A%20%23FFEC9E%3B%20stroke%3A%20%23332900%3B%20stroke-width%3A%201%3B%7D%20rect.text%20%7Bfill%3A%20none%3B%20stroke%3A%20none%3B%7D%20polygon.regexp%20%7Bfill%3A%20%23FFF4C7%3B%20stroke%3A%20%23332900%3B%20stroke-width%3A%201%3B%7D%3C%2Fstyle%3E%3C%2Fdefs%3E%3Cpolygon%20points%3D%229%2017%201%2013%201%2021%22%2F%3E%3Cpolygon%20points%3D%2217%2017%209%2013%209%2021%22%2F%3E%3Crect%20x%3D%2251%22%20y%3D%223%22%20width%3D%2260%22%20height%3D%2232%22%2F%3E%3Crect%20x%3D%2249%22%20y%3D%221%22%20width%3D%2260%22%20height%3D%2232%22%20class%3D%22nonterminal%22%2F%3E%3Ctext%20class%3D%22nonterminal%22%20x%3D%2259%22%20y%3D%2221%22%3EALPHA%3C%2Ftext%3E%3Crect%20x%3D%2251%22%20y%3D%2247%22%20width%3D%2228%22%20height%3D%2232%22%20rx%3D%2210%22%2F%3E%3Crect%20x%3D%2249%22%20y%3D%2245%22%20width%3D%2228%22%20height%3D%2232%22%20class%3D%22terminal%22%20rx%3D%2210%22%2F%3E%3Ctext%20class%3D%22terminal%22%20x%3D%2259%22%20y%3D%2265%22%3E_%3C%2Ftext%3E%3Crect%20x%3D%2251%22%20y%3D%2291%22%20width%3D%2224%22%20height%3D%2232%22%20rx%3D%2210%22%2F%3E%3Crect%20x%3D%2249%22%20y%3D%2289%22%20width%3D%2224%22%20height%3D%2232%22%20class%3D%22terminal%22%20rx%3D%2210%22%2F%3E%3Ctext%20class%3D%22terminal%22%20x%3D%2259%22%20y%3D%22109%22%3E%3A%3C%2Ftext%3E%3Cpath%20class%3D%22line%22%20d%3D%22m17%2017%20h2%20m20%200%20h10%20m60%200%20h10%20m-100%200%20h20%20m80%200%20h20%20m-120%200%20q10%200%2010%2010%20m100%200%20q0%20-10%2010%20-10%20m-110%2010%20v24%20m100%200%20v-24%20m-100%2024%20q0%2010%2010%2010%20m80%200%20q10%200%2010%20-10%20m-90%2010%20h10%20m28%200%20h10%20m0%200%20h32%20m-90%20-10%20v20%20m100%200%20v-20%20m-100%2020%20v24%20m100%200%20v-24%20m-100%2024%20q0%2010%2010%2010%20m80%200%20q10%200%2010%20-10%20m-90%2010%20h10%20m24%200%20h10%20m0%200%20h36%20m23%20-88%20h-3%22%2F%3E%3Cpolygon%20points%3D%22149%2017%20157%2013%20157%2021%22%2F%3E%3Cpolygon%20points%3D%22149%2017%20141%2013%20141%2021%22%2F%3E%3C%2Fsvg%3E)

```
letter   ::= ALPHA
           | '_'
           | ':'
```

referenced by:

* identifier

**identifier:**

![identifier](data:image/svg+xml,%3Csvg%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%20width%3D%22229%22%20height%3D%22203%22%3E%3Cdefs%3E%3Cstyle%20type%3D%22text%2Fcss%22%3E%40namespace%20%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%3B%20.line%20%7Bfill%3A%20none%3B%20stroke%3A%20%23332900%3B%20stroke-width%3A%201%3B%7D%20.bold-line%20%7Bstroke%3A%20%23141000%3B%20shape-rendering%3A%20crispEdges%3B%20stroke-width%3A%202%3B%7D%20.thin-line%20%7Bstroke%3A%20%231F1800%3B%20shape-rendering%3A%20crispEdges%7D%20.filled%20%7Bfill%3A%20%23332900%3B%20stroke%3A%20none%3B%7D%20text.terminal%20%7Bfont-family%3A%20Verdana%2C%20Sans-serif%3B%20font-size%3A%2012px%3B%20fill%3A%20%23141000%3B%20font-weight%3A%20bold%3B%20%7D%20text.nonterminal%20%7Bfont-family%3A%20Verdana%2C%20Sans-serif%3B%20font-size%3A%2012px%3B%20fill%3A%20%231A1400%3B%20font-weight%3A%20normal%3B%20%7D%20text.regexp%20%7Bfont-family%3A%20Verdana%2C%20Sans-serif%3B%20font-size%3A%2012px%3B%20fill%3A%20%231F1800%3B%20font-weight%3A%20normal%3B%20%7D%20rect%2C%20circle%2C%20polygon%20%7Bfill%3A%20%23332900%3B%20stroke%3A%20%23332900%3B%7D%20rect.terminal%20%7Bfill%3A%20%23FFDB4D%3B%20stroke%3A%20%23332900%3B%20stroke-width%3A%201%3B%7D%20rect.nonterminal%20%7Bfill%3A%20%23FFEC9E%3B%20stroke%3A%20%23332900%3B%20stroke-width%3A%201%3B%7D%20rect.text%20%7Bfill%3A%20none%3B%20stroke%3A%20none%3B%7D%20polygon.regexp%20%7Bfill%3A%20%23FFF4C7%3B%20stroke%3A%20%23332900%3B%20stroke-width%3A%201%3B%7D%3C%2Fstyle%3E%3C%2Fdefs%3E%3Cpolygon%20points%3D%229%20183%201%20179%201%20187%22%2F%3E%3Cpolygon%20points%3D%2217%20183%209%20179%209%20187%22%2F%3E%3Crect%20x%3D%2231%22%20y%3D%22169%22%20width%3D%2254%22%20height%3D%2232%22%2F%3E%3Crect%20x%3D%2229%22%20y%3D%22167%22%20width%3D%2254%22%20height%3D%2232%22%20class%3D%22nonterminal%22%2F%3E%3Ctext%20class%3D%22nonterminal%22%20x%3D%2239%22%20y%3D%22187%22%3Eletter%3C%2Ftext%3E%3Crect%20x%3D%22125%22%20y%3D%22135%22%20width%3D%2254%22%20height%3D%2232%22%2F%3E%3Crect%20x%3D%22123%22%20y%3D%22133%22%20width%3D%2254%22%20height%3D%2232%22%20class%3D%22nonterminal%22%2F%3E%3Ctext%20class%3D%22nonterminal%22%20x%3D%22133%22%20y%3D%22153%22%3Eletter%3C%2Ftext%3E%3Crect%20x%3D%22125%22%20y%3D%2291%22%20width%3D%2256%22%20height%3D%2232%22%2F%3E%3Crect%20x%3D%22123%22%20y%3D%2289%22%20width%3D%2256%22%20height%3D%2232%22%20class%3D%22nonterminal%22%2F%3E%3Ctext%20class%3D%22nonterminal%22%20x%3D%22133%22%20y%3D%22109%22%3EDIGIT%3C%2Ftext%3E%3Crect%20x%3D%22125%22%20y%3D%2247%22%20width%3D%2226%22%20height%3D%2232%22%20rx%3D%2210%22%2F%3E%3Crect%20x%3D%22123%22%20y%3D%2245%22%20width%3D%2226%22%20height%3D%2232%22%20class%3D%22terminal%22%20rx%3D%2210%22%2F%3E%3Ctext%20class%3D%22terminal%22%20x%3D%22133%22%20y%3D%2265%22%3E-%3C%2Ftext%3E%3Crect%20x%3D%22125%22%20y%3D%223%22%20width%3D%2224%22%20height%3D%2232%22%20rx%3D%2210%22%2F%3E%3Crect%20x%3D%22123%22%20y%3D%221%22%20width%3D%2224%22%20height%3D%2232%22%20class%3D%22terminal%22%20rx%3D%2210%22%2F%3E%3Ctext%20class%3D%22terminal%22%20x%3D%22133%22%20y%3D%2221%22%3E.%3C%2Ftext%3E%3Cpath%20class%3D%22line%22%20d%3D%22m17%20183%20h2%20m0%200%20h10%20m54%200%20h10%20m20%200%20h10%20m0%200%20h66%20m-96%200%20l20%200%20m-1%200%20q-9%200%20-9%20-10%20l0%20-14%20q0%20-10%2010%20-10%20m76%2034%20l20%200%20m-20%200%20q10%200%2010%20-10%20l0%20-14%20q0%20-10%20-10%20-10%20m-76%200%20h10%20m54%200%20h10%20m0%200%20h2%20m-86%2010%20l0%20-44%20q0%20-10%2010%20-10%20m86%2054%20l0%20-44%20q0%20-10%20-10%20-10%20m-76%200%20h10%20m56%200%20h10%20m-86%2010%20l0%20-44%20q0%20-10%2010%20-10%20m86%2054%20l0%20-44%20q0%20-10%20-10%20-10%20m-76%200%20h10%20m26%200%20h10%20m0%200%20h30%20m-86%2010%20l0%20-44%20q0%20-10%2010%20-10%20m86%2054%20l0%20-44%20q0%20-10%20-10%20-10%20m-76%200%20h10%20m24%200%20h10%20m0%200%20h32%20m23%20166%20h-3%22%2F%3E%3Cpolygon%20points%3D%22219%20183%20227%20179%20227%20187%22%2F%3E%3Cpolygon%20points%3D%22219%20183%20211%20179%20211%20187%22%2F%3E%3C%2Fsvg%3E)

```
identifier
         ::= letter ( letter | DIGIT | '-' | '.' )*
```

referenced by:

* command-id
* parameter

**passthrough-command-id:**

![passthrough-command-id](data:image/svg+xml,%3Csvg%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%20width%3D%22157%22%20height%3D%22345%22%3E%3Cdefs%3E%3Cstyle%20type%3D%22text%2Fcss%22%3E%40namespace%20%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%3B%20.line%20%7Bfill%3A%20none%3B%20stroke%3A%20%23332900%3B%20stroke-width%3A%201%3B%7D%20.bold-line%20%7Bstroke%3A%20%23141000%3B%20shape-rendering%3A%20crispEdges%3B%20stroke-width%3A%202%3B%7D%20.thin-line%20%7Bstroke%3A%20%231F1800%3B%20shape-rendering%3A%20crispEdges%7D%20.filled%20%7Bfill%3A%20%23332900%3B%20stroke%3A%20none%3B%7D%20text.terminal%20%7Bfont-family%3A%20Verdana%2C%20Sans-serif%3B%20font-size%3A%2012px%3B%20fill%3A%20%23141000%3B%20font-weight%3A%20bold%3B%20%7D%20text.nonterminal%20%7Bfont-family%3A%20Verdana%2C%20Sans-serif%3B%20font-size%3A%2012px%3B%20fill%3A%20%231A1400%3B%20font-weight%3A%20normal%3B%20%7D%20text.regexp%20%7Bfont-family%3A%20Verdana%2C%20Sans-serif%3B%20font-size%3A%2012px%3B%20fill%3A%20%231F1800%3B%20font-weight%3A%20normal%3B%20%7D%20rect%2C%20circle%2C%20polygon%20%7Bfill%3A%20%23332900%3B%20stroke%3A%20%23332900%3B%7D%20rect.terminal%20%7Bfill%3A%20%23FFDB4D%3B%20stroke%3A%20%23332900%3B%20stroke-width%3A%201%3B%7D%20rect.nonterminal%20%7Bfill%3A%20%23FFEC9E%3B%20stroke%3A%20%23332900%3B%20stroke-width%3A%201%3B%7D%20rect.text%20%7Bfill%3A%20none%3B%20stroke%3A%20none%3B%7D%20polygon.regexp%20%7Bfill%3A%20%23FFF4C7%3B%20stroke%3A%20%23332900%3B%20stroke-width%3A%201%3B%7D%3C%2Fstyle%3E%3C%2Fdefs%3E%3Cpolygon%20points%3D%229%2017%201%2013%201%2021%22%2F%3E%3Cpolygon%20points%3D%2217%2017%209%2013%209%2021%22%2F%3E%3Crect%20x%3D%2251%22%20y%3D%223%22%20width%3D%2234%22%20height%3D%2232%22%20rx%3D%2210%22%2F%3E%3Crect%20x%3D%2249%22%20y%3D%221%22%20width%3D%2234%22%20height%3D%2232%22%20class%3D%22terminal%22%20rx%3D%2210%22%2F%3E%3Ctext%20class%3D%22terminal%22%20x%3D%2259%22%20y%3D%2221%22%3Eftl%3C%2Ftext%3E%3Crect%20x%3D%2251%22%20y%3D%2247%22%20width%3D%2240%22%20height%3D%2232%22%20rx%3D%2210%22%2F%3E%3Crect%20x%3D%2249%22%20y%3D%2245%22%20width%3D%2240%22%20height%3D%2232%22%20class%3D%22terminal%22%20rx%3D%2210%22%2F%3E%3Ctext%20class%3D%22terminal%22%20x%3D%2259%22%20y%3D%2265%22%3Elua%3C%2Ftext%3E%3Crect%20x%3D%2251%22%20y%3D%2291%22%20width%3D%2254%22%20height%3D%2232%22%20rx%3D%2210%22%2F%3E%3Crect%20x%3D%2249%22%20y%3D%2289%22%20width%3D%2254%22%20height%3D%2232%22%20class%3D%22terminal%22%20rx%3D%2210%22%2F%3E%3Ctext%20class%3D%22terminal%22%20x%3D%2259%22%20y%3D%22109%22%3Emath%3C%2Ftext%3E%3Crect%20x%3D%2251%22%20y%3D%22135%22%20width%3D%2246%22%20height%3D%2232%22%20rx%3D%2210%22%2F%3E%3Crect%20x%3D%2249%22%20y%3D%22133%22%20width%3D%2246%22%20height%3D%2232%22%20class%3D%22terminal%22%20rx%3D%2210%22%2F%3E%3Ctext%20class%3D%22terminal%22%20x%3D%2259%22%20y%3D%22153%22%3Eraw%3C%2Ftext%3E%3Crect%20x%3D%2251%22%20y%3D%22179%22%20width%3D%2258%22%20height%3D%2232%22%20rx%3D%2210%22%2F%3E%3Crect%20x%3D%2249%22%20y%3D%22177%22%20width%3D%2258%22%20height%3D%2232%22%20class%3D%22terminal%22%20rx%3D%2210%22%2F%3E%3Ctext%20class%3D%22terminal%22%20x%3D%2259%22%20y%3D%22197%22%3Escript%3C%2Ftext%3E%3Crect%20x%3D%2251%22%20y%3D%22223%22%20width%3D%2234%22%20height%3D%2232%22%20rx%3D%2210%22%2F%3E%3Crect%20x%3D%2249%22%20y%3D%22221%22%20width%3D%2234%22%20height%3D%2232%22%20class%3D%22terminal%22%20rx%3D%2210%22%2F%3E%3Ctext%20class%3D%22terminal%22%20x%3D%2259%22%20y%3D%22241%22%3Esil%3C%2Ftext%3E%3Crect%20x%3D%2251%22%20y%3D%22267%22%20width%3D%2244%22%20height%3D%2232%22%20rx%3D%2210%22%2F%3E%3Crect%20x%3D%2249%22%20y%3D%22265%22%20width%3D%2244%22%20height%3D%2232%22%20class%3D%22terminal%22%20rx%3D%2210%22%2F%3E%3Ctext%20class%3D%22terminal%22%20x%3D%2259%22%20y%3D%22285%22%3Euse%3C%2Ftext%3E%3Crect%20x%3D%2251%22%20y%3D%22311%22%20width%3D%2244%22%20height%3D%2232%22%20rx%3D%2210%22%2F%3E%3Crect%20x%3D%2249%22%20y%3D%22309%22%20width%3D%2244%22%20height%3D%2232%22%20class%3D%22terminal%22%20rx%3D%2210%22%2F%3E%3Ctext%20class%3D%22terminal%22%20x%3D%2259%22%20y%3D%22329%22%3Exml%3C%2Ftext%3E%3Cpath%20class%3D%22line%22%20d%3D%22m17%2017%20h2%20m20%200%20h10%20m34%200%20h10%20m0%200%20h24%20m-98%200%20h20%20m78%200%20h20%20m-118%200%20q10%200%2010%2010%20m98%200%20q0%20-10%2010%20-10%20m-108%2010%20v24%20m98%200%20v-24%20m-98%2024%20q0%2010%2010%2010%20m78%200%20q10%200%2010%20-10%20m-88%2010%20h10%20m40%200%20h10%20m0%200%20h18%20m-88%20-10%20v20%20m98%200%20v-20%20m-98%2020%20v24%20m98%200%20v-24%20m-98%2024%20q0%2010%2010%2010%20m78%200%20q10%200%2010%20-10%20m-88%2010%20h10%20m54%200%20h10%20m0%200%20h4%20m-88%20-10%20v20%20m98%200%20v-20%20m-98%2020%20v24%20m98%200%20v-24%20m-98%2024%20q0%2010%2010%2010%20m78%200%20q10%200%2010%20-10%20m-88%2010%20h10%20m46%200%20h10%20m0%200%20h12%20m-88%20-10%20v20%20m98%200%20v-20%20m-98%2020%20v24%20m98%200%20v-24%20m-98%2024%20q0%2010%2010%2010%20m78%200%20q10%200%2010%20-10%20m-88%2010%20h10%20m58%200%20h10%20m-88%20-10%20v20%20m98%200%20v-20%20m-98%2020%20v24%20m98%200%20v-24%20m-98%2024%20q0%2010%2010%2010%20m78%200%20q10%200%2010%20-10%20m-88%2010%20h10%20m34%200%20h10%20m0%200%20h24%20m-88%20-10%20v20%20m98%200%20v-20%20m-98%2020%20v24%20m98%200%20v-24%20m-98%2024%20q0%2010%2010%2010%20m78%200%20q10%200%2010%20-10%20m-88%2010%20h10%20m44%200%20h10%20m0%200%20h14%20m-88%20-10%20v20%20m98%200%20v-20%20m-98%2020%20v24%20m98%200%20v-24%20m-98%2024%20q0%2010%2010%2010%20m78%200%20q10%200%2010%20-10%20m-88%2010%20h10%20m44%200%20h10%20m0%200%20h14%20m23%20-308%20h-3%22%2F%3E%3Cpolygon%20points%3D%22147%2017%20155%2013%20155%2021%22%2F%3E%3Cpolygon%20points%3D%22147%2017%20139%2013%20139%2021%22%2F%3E%3C%2Fsvg%3E)

```
passthrough-command-id
         ::= 'ftl'
           | 'lua'
           | 'math'
           | 'raw'
           | 'script'
           | 'sil'
           | 'use'
           | 'xml'
```

referenced by:

* command
* environment

**command-id:**

![command-id](data:image/svg+xml,%3Csvg%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%20width%3D%22135%22%20height%3D%2237%22%3E%3Cdefs%3E%3Cstyle%20type%3D%22text%2Fcss%22%3E%40namespace%20%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%3B%20.line%20%7Bfill%3A%20none%3B%20stroke%3A%20%23332900%3B%20stroke-width%3A%201%3B%7D%20.bold-line%20%7Bstroke%3A%20%23141000%3B%20shape-rendering%3A%20crispEdges%3B%20stroke-width%3A%202%3B%7D%20.thin-line%20%7Bstroke%3A%20%231F1800%3B%20shape-rendering%3A%20crispEdges%7D%20.filled%20%7Bfill%3A%20%23332900%3B%20stroke%3A%20none%3B%7D%20text.terminal%20%7Bfont-family%3A%20Verdana%2C%20Sans-serif%3B%20font-size%3A%2012px%3B%20fill%3A%20%23141000%3B%20font-weight%3A%20bold%3B%20%7D%20text.nonterminal%20%7Bfont-family%3A%20Verdana%2C%20Sans-serif%3B%20font-size%3A%2012px%3B%20fill%3A%20%231A1400%3B%20font-weight%3A%20normal%3B%20%7D%20text.regexp%20%7Bfont-family%3A%20Verdana%2C%20Sans-serif%3B%20font-size%3A%2012px%3B%20fill%3A%20%231F1800%3B%20font-weight%3A%20normal%3B%20%7D%20rect%2C%20circle%2C%20polygon%20%7Bfill%3A%20%23332900%3B%20stroke%3A%20%23332900%3B%7D%20rect.terminal%20%7Bfill%3A%20%23FFDB4D%3B%20stroke%3A%20%23332900%3B%20stroke-width%3A%201%3B%7D%20rect.nonterminal%20%7Bfill%3A%20%23FFEC9E%3B%20stroke%3A%20%23332900%3B%20stroke-width%3A%201%3B%7D%20rect.text%20%7Bfill%3A%20none%3B%20stroke%3A%20none%3B%7D%20polygon.regexp%20%7Bfill%3A%20%23FFF4C7%3B%20stroke%3A%20%23332900%3B%20stroke-width%3A%201%3B%7D%3C%2Fstyle%3E%3C%2Fdefs%3E%3Cpolygon%20points%3D%229%2017%201%2013%201%2021%22%2F%3E%3Cpolygon%20points%3D%2217%2017%209%2013%209%2021%22%2F%3E%3Crect%20x%3D%2231%22%20y%3D%223%22%20width%3D%2276%22%20height%3D%2232%22%2F%3E%3Crect%20x%3D%2229%22%20y%3D%221%22%20width%3D%2276%22%20height%3D%2232%22%20class%3D%22nonterminal%22%2F%3E%3Ctext%20class%3D%22nonterminal%22%20x%3D%2239%22%20y%3D%2221%22%3Eidentifier%3C%2Ftext%3E%3Cpath%20class%3D%22line%22%20d%3D%22m17%2017%20h2%20m0%200%20h10%20m76%200%20h10%20m3%200%20h-3%22%2F%3E%3Cpolygon%20points%3D%22125%2017%20133%2013%20133%2021%22%2F%3E%3Cpolygon%20points%3D%22125%2017%20117%2013%20117%2021%22%2F%3E%3C%2Fsvg%3E)

```
command-id
         ::= identifier
```

referenced by:

* command
* environment

**utf8-char:**

![utf8-char](data:image/svg+xml,%3Csvg%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%20width%3D%22157%22%20height%3D%22169%22%3E%3Cdefs%3E%3Cstyle%20type%3D%22text%2Fcss%22%3E%40namespace%20%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%3B%20.line%20%7Bfill%3A%20none%3B%20stroke%3A%20%23332900%3B%20stroke-width%3A%201%3B%7D%20.bold-line%20%7Bstroke%3A%20%23141000%3B%20shape-rendering%3A%20crispEdges%3B%20stroke-width%3A%202%3B%7D%20.thin-line%20%7Bstroke%3A%20%231F1800%3B%20shape-rendering%3A%20crispEdges%7D%20.filled%20%7Bfill%3A%20%23332900%3B%20stroke%3A%20none%3B%7D%20text.terminal%20%7Bfont-family%3A%20Verdana%2C%20Sans-serif%3B%20font-size%3A%2012px%3B%20fill%3A%20%23141000%3B%20font-weight%3A%20bold%3B%20%7D%20text.nonterminal%20%7Bfont-family%3A%20Verdana%2C%20Sans-serif%3B%20font-size%3A%2012px%3B%20fill%3A%20%231A1400%3B%20font-weight%3A%20normal%3B%20%7D%20text.regexp%20%7Bfont-family%3A%20Verdana%2C%20Sans-serif%3B%20font-size%3A%2012px%3B%20fill%3A%20%231F1800%3B%20font-weight%3A%20normal%3B%20%7D%20rect%2C%20circle%2C%20polygon%20%7Bfill%3A%20%23332900%3B%20stroke%3A%20%23332900%3B%7D%20rect.terminal%20%7Bfill%3A%20%23FFDB4D%3B%20stroke%3A%20%23332900%3B%20stroke-width%3A%201%3B%7D%20rect.nonterminal%20%7Bfill%3A%20%23FFEC9E%3B%20stroke%3A%20%23332900%3B%20stroke-width%3A%201%3B%7D%20rect.text%20%7Bfill%3A%20none%3B%20stroke%3A%20none%3B%7D%20polygon.regexp%20%7Bfill%3A%20%23FFF4C7%3B%20stroke%3A%20%23332900%3B%20stroke-width%3A%201%3B%7D%3C%2Fstyle%3E%3C%2Fdefs%3E%3Cpolygon%20points%3D%229%2017%201%2013%201%2021%22%2F%3E%3Cpolygon%20points%3D%2217%2017%209%2013%209%2021%22%2F%3E%3Crect%20x%3D%2251%22%20y%3D%223%22%20width%3D%2258%22%20height%3D%2232%22%2F%3E%3Crect%20x%3D%2249%22%20y%3D%221%22%20width%3D%2258%22%20height%3D%2232%22%20class%3D%22nonterminal%22%2F%3E%3Ctext%20class%3D%22nonterminal%22%20x%3D%2259%22%20y%3D%2221%22%3Eutf8-1%3C%2Ftext%3E%3Crect%20x%3D%2251%22%20y%3D%2247%22%20width%3D%2258%22%20height%3D%2232%22%2F%3E%3Crect%20x%3D%2249%22%20y%3D%2245%22%20width%3D%2258%22%20height%3D%2232%22%20class%3D%22nonterminal%22%2F%3E%3Ctext%20class%3D%22nonterminal%22%20x%3D%2259%22%20y%3D%2265%22%3Eutf8-2%3C%2Ftext%3E%3Crect%20x%3D%2251%22%20y%3D%2291%22%20width%3D%2258%22%20height%3D%2232%22%2F%3E%3Crect%20x%3D%2249%22%20y%3D%2289%22%20width%3D%2258%22%20height%3D%2232%22%20class%3D%22nonterminal%22%2F%3E%3Ctext%20class%3D%22nonterminal%22%20x%3D%2259%22%20y%3D%22109%22%3Eutf8-3%3C%2Ftext%3E%3Crect%20x%3D%2251%22%20y%3D%22135%22%20width%3D%2258%22%20height%3D%2232%22%2F%3E%3Crect%20x%3D%2249%22%20y%3D%22133%22%20width%3D%2258%22%20height%3D%2232%22%20class%3D%22nonterminal%22%2F%3E%3Ctext%20class%3D%22nonterminal%22%20x%3D%2259%22%20y%3D%22153%22%3Eutf8-4%3C%2Ftext%3E%3Cpath%20class%3D%22line%22%20d%3D%22m17%2017%20h2%20m20%200%20h10%20m58%200%20h10%20m-98%200%20h20%20m78%200%20h20%20m-118%200%20q10%200%2010%2010%20m98%200%20q0%20-10%2010%20-10%20m-108%2010%20v24%20m98%200%20v-24%20m-98%2024%20q0%2010%2010%2010%20m78%200%20q10%200%2010%20-10%20m-88%2010%20h10%20m58%200%20h10%20m-88%20-10%20v20%20m98%200%20v-20%20m-98%2020%20v24%20m98%200%20v-24%20m-98%2024%20q0%2010%2010%2010%20m78%200%20q10%200%2010%20-10%20m-88%2010%20h10%20m58%200%20h10%20m-88%20-10%20v20%20m98%200%20v-20%20m-98%2020%20v24%20m98%200%20v-24%20m-98%2024%20q0%2010%2010%2010%20m78%200%20q10%200%2010%20-10%20m-88%2010%20h10%20m58%200%20h10%20m23%20-132%20h-3%22%2F%3E%3Cpolygon%20points%3D%22147%2017%20155%2013%20155%2021%22%2F%3E%3Cpolygon%20points%3D%22147%2017%20139%2013%20139%2021%22%2F%3E%3C%2Fsvg%3E)

```
utf8-char
         ::= utf8-1
           | utf8-2
           | utf8-3
           | utf8-4
```

referenced by:

* comment
* env-passthrough-text

**utf8-1:**

![utf8-1](data:image/svg+xml,%3Csvg%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%20width%3D%22161%22%20height%3D%2237%22%3E%3Cdefs%3E%3Cstyle%20type%3D%22text%2Fcss%22%3E%40namespace%20%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%3B%20.line%20%7Bfill%3A%20none%3B%20stroke%3A%20%23332900%3B%20stroke-width%3A%201%3B%7D%20.bold-line%20%7Bstroke%3A%20%23141000%3B%20shape-rendering%3A%20crispEdges%3B%20stroke-width%3A%202%3B%7D%20.thin-line%20%7Bstroke%3A%20%231F1800%3B%20shape-rendering%3A%20crispEdges%7D%20.filled%20%7Bfill%3A%20%23332900%3B%20stroke%3A%20none%3B%7D%20text.terminal%20%7Bfont-family%3A%20Verdana%2C%20Sans-serif%3B%20font-size%3A%2012px%3B%20fill%3A%20%23141000%3B%20font-weight%3A%20bold%3B%20%7D%20text.nonterminal%20%7Bfont-family%3A%20Verdana%2C%20Sans-serif%3B%20font-size%3A%2012px%3B%20fill%3A%20%231A1400%3B%20font-weight%3A%20normal%3B%20%7D%20text.regexp%20%7Bfont-family%3A%20Verdana%2C%20Sans-serif%3B%20font-size%3A%2012px%3B%20fill%3A%20%231F1800%3B%20font-weight%3A%20normal%3B%20%7D%20rect%2C%20circle%2C%20polygon%20%7Bfill%3A%20%23332900%3B%20stroke%3A%20%23332900%3B%7D%20rect.terminal%20%7Bfill%3A%20%23FFDB4D%3B%20stroke%3A%20%23332900%3B%20stroke-width%3A%201%3B%7D%20rect.nonterminal%20%7Bfill%3A%20%23FFEC9E%3B%20stroke%3A%20%23332900%3B%20stroke-width%3A%201%3B%7D%20rect.text%20%7Bfill%3A%20none%3B%20stroke%3A%20none%3B%7D%20polygon.regexp%20%7Bfill%3A%20%23FFF4C7%3B%20stroke%3A%20%23332900%3B%20stroke-width%3A%201%3B%7D%3C%2Fstyle%3E%3C%2Fdefs%3E%3Cpolygon%20points%3D%229%2017%201%2013%201%2021%22%2F%3E%3Cpolygon%20points%3D%2217%2017%209%2013%209%2021%22%2F%3E%3Cpolygon%20points%3D%2231%2019%2038%203%20126%203%20133%2019%20126%2035%2038%2035%22%2F%3E%3Cpolygon%20points%3D%2229%2017%2036%201%20124%201%20131%2017%20124%2033%2036%2033%22%20class%3D%22regexp%22%2F%3E%3Ctext%20class%3D%22regexp%22%20x%3D%2244%22%20y%3D%2221%22%3E%5B%23x0-%23x7F%5D%3C%2Ftext%3E%3Cpath%20class%3D%22line%22%20d%3D%22m17%2017%20h2%20m0%200%20h10%20m102%200%20h10%20m3%200%20h-3%22%2F%3E%3Cpolygon%20points%3D%22151%2017%20159%2013%20159%2021%22%2F%3E%3Cpolygon%20points%3D%22151%2017%20143%2013%20143%2021%22%2F%3E%3C%2Fsvg%3E)

```
utf8-1   ::= [#x0-#x7F]
```

referenced by:

* utf8-char

**utf8-2:**

![utf8-2](data:image/svg+xml,%3Csvg%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%20width%3D%22261%22%20height%3D%2237%22%3E%3Cdefs%3E%3Cstyle%20type%3D%22text%2Fcss%22%3E%40namespace%20%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%3B%20.line%20%7Bfill%3A%20none%3B%20stroke%3A%20%23332900%3B%20stroke-width%3A%201%3B%7D%20.bold-line%20%7Bstroke%3A%20%23141000%3B%20shape-rendering%3A%20crispEdges%3B%20stroke-width%3A%202%3B%7D%20.thin-line%20%7Bstroke%3A%20%231F1800%3B%20shape-rendering%3A%20crispEdges%7D%20.filled%20%7Bfill%3A%20%23332900%3B%20stroke%3A%20none%3B%7D%20text.terminal%20%7Bfont-family%3A%20Verdana%2C%20Sans-serif%3B%20font-size%3A%2012px%3B%20fill%3A%20%23141000%3B%20font-weight%3A%20bold%3B%20%7D%20text.nonterminal%20%7Bfont-family%3A%20Verdana%2C%20Sans-serif%3B%20font-size%3A%2012px%3B%20fill%3A%20%231A1400%3B%20font-weight%3A%20normal%3B%20%7D%20text.regexp%20%7Bfont-family%3A%20Verdana%2C%20Sans-serif%3B%20font-size%3A%2012px%3B%20fill%3A%20%231F1800%3B%20font-weight%3A%20normal%3B%20%7D%20rect%2C%20circle%2C%20polygon%20%7Bfill%3A%20%23332900%3B%20stroke%3A%20%23332900%3B%7D%20rect.terminal%20%7Bfill%3A%20%23FFDB4D%3B%20stroke%3A%20%23332900%3B%20stroke-width%3A%201%3B%7D%20rect.nonterminal%20%7Bfill%3A%20%23FFEC9E%3B%20stroke%3A%20%23332900%3B%20stroke-width%3A%201%3B%7D%20rect.text%20%7Bfill%3A%20none%3B%20stroke%3A%20none%3B%7D%20polygon.regexp%20%7Bfill%3A%20%23FFF4C7%3B%20stroke%3A%20%23332900%3B%20stroke-width%3A%201%3B%7D%3C%2Fstyle%3E%3C%2Fdefs%3E%3Cpolygon%20points%3D%229%2017%201%2013%201%2021%22%2F%3E%3Cpolygon%20points%3D%2217%2017%209%2013%209%2021%22%2F%3E%3Cpolygon%20points%3D%2231%2019%2038%203%20136%203%20143%2019%20136%2035%2038%2035%22%2F%3E%3Cpolygon%20points%3D%2229%2017%2036%201%20134%201%20141%2017%20134%2033%2036%2033%22%20class%3D%22regexp%22%2F%3E%3Ctext%20class%3D%22regexp%22%20x%3D%2244%22%20y%3D%2221%22%3E%5B%23xC2-%23xDF%5D%3C%2Ftext%3E%3Crect%20x%3D%22163%22%20y%3D%223%22%20width%3D%2270%22%20height%3D%2232%22%2F%3E%3Crect%20x%3D%22161%22%20y%3D%221%22%20width%3D%2270%22%20height%3D%2232%22%20class%3D%22nonterminal%22%2F%3E%3Ctext%20class%3D%22nonterminal%22%20x%3D%22171%22%20y%3D%2221%22%3Eutf8-tail%3C%2Ftext%3E%3Cpath%20class%3D%22line%22%20d%3D%22m17%2017%20h2%20m0%200%20h10%20m112%200%20h10%20m0%200%20h10%20m70%200%20h10%20m3%200%20h-3%22%2F%3E%3Cpolygon%20points%3D%22251%2017%20259%2013%20259%2021%22%2F%3E%3Cpolygon%20points%3D%22251%2017%20243%2013%20243%2021%22%2F%3E%3C%2Fsvg%3E)

```
utf8-2   ::= [#xC2-#xDF] utf8-tail
```

referenced by:

* braced-passthrough-char
* quoted-value-char
* text-char
* utf8-char
* value-char

**utf8-3:**

![utf8-3](data:image/svg+xml,%3Csvg%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%20width%3D%22393%22%20height%3D%22169%22%3E%3Cdefs%3E%3Cstyle%20type%3D%22text%2Fcss%22%3E%40namespace%20%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%3B%20.line%20%7Bfill%3A%20none%3B%20stroke%3A%20%23332900%3B%20stroke-width%3A%201%3B%7D%20.bold-line%20%7Bstroke%3A%20%23141000%3B%20shape-rendering%3A%20crispEdges%3B%20stroke-width%3A%202%3B%7D%20.thin-line%20%7Bstroke%3A%20%231F1800%3B%20shape-rendering%3A%20crispEdges%7D%20.filled%20%7Bfill%3A%20%23332900%3B%20stroke%3A%20none%3B%7D%20text.terminal%20%7Bfont-family%3A%20Verdana%2C%20Sans-serif%3B%20font-size%3A%2012px%3B%20fill%3A%20%23141000%3B%20font-weight%3A%20bold%3B%20%7D%20text.nonterminal%20%7Bfont-family%3A%20Verdana%2C%20Sans-serif%3B%20font-size%3A%2012px%3B%20fill%3A%20%231A1400%3B%20font-weight%3A%20normal%3B%20%7D%20text.regexp%20%7Bfont-family%3A%20Verdana%2C%20Sans-serif%3B%20font-size%3A%2012px%3B%20fill%3A%20%231F1800%3B%20font-weight%3A%20normal%3B%20%7D%20rect%2C%20circle%2C%20polygon%20%7Bfill%3A%20%23332900%3B%20stroke%3A%20%23332900%3B%7D%20rect.terminal%20%7Bfill%3A%20%23FFDB4D%3B%20stroke%3A%20%23332900%3B%20stroke-width%3A%201%3B%7D%20rect.nonterminal%20%7Bfill%3A%20%23FFEC9E%3B%20stroke%3A%20%23332900%3B%20stroke-width%3A%201%3B%7D%20rect.text%20%7Bfill%3A%20none%3B%20stroke%3A%20none%3B%7D%20polygon.regexp%20%7Bfill%3A%20%23FFF4C7%3B%20stroke%3A%20%23332900%3B%20stroke-width%3A%201%3B%7D%3C%2Fstyle%3E%3C%2Fdefs%3E%3Cpolygon%20points%3D%229%2017%201%2013%201%2021%22%2F%3E%3Cpolygon%20points%3D%2217%2017%209%2013%209%2021%22%2F%3E%3Cpolygon%20points%3D%2251%2019%2058%203%20118%203%20125%2019%20118%2035%2058%2035%22%2F%3E%3Cpolygon%20points%3D%2249%2017%2056%201%20116%201%20123%2017%20116%2033%2056%2033%22%20class%3D%22regexp%22%2F%3E%3Ctext%20class%3D%22regexp%22%20x%3D%2264%22%20y%3D%2221%22%3E%5B%23xE0%5D%3C%2Ftext%3E%3Cpolygon%20points%3D%22145%2019%20152%203%20248%203%20255%2019%20248%2035%20152%2035%22%2F%3E%3Cpolygon%20points%3D%22143%2017%20150%201%20246%201%20253%2017%20246%2033%20150%2033%22%20class%3D%22regexp%22%2F%3E%3Ctext%20class%3D%22regexp%22%20x%3D%22158%22%20y%3D%2221%22%3E%5B%23xA0-%23xBF%5D%3C%2Ftext%3E%3Crect%20x%3D%22275%22%20y%3D%223%22%20width%3D%2270%22%20height%3D%2232%22%2F%3E%3Crect%20x%3D%22273%22%20y%3D%221%22%20width%3D%2270%22%20height%3D%2232%22%20class%3D%22nonterminal%22%2F%3E%3Ctext%20class%3D%22nonterminal%22%20x%3D%22283%22%20y%3D%2221%22%3Eutf8-tail%3C%2Ftext%3E%3Cpolygon%20points%3D%2251%2063%2058%2047%20156%2047%20163%2063%20156%2079%2058%2079%22%2F%3E%3Cpolygon%20points%3D%2249%2061%2056%2045%20154%2045%20161%2061%20154%2077%2056%2077%22%20class%3D%22regexp%22%2F%3E%3Ctext%20class%3D%22regexp%22%20x%3D%2264%22%20y%3D%2265%22%3E%5B%23xE1-%23xEC%5D%3C%2Ftext%3E%3Crect%20x%3D%22183%22%20y%3D%2247%22%20width%3D%2270%22%20height%3D%2232%22%2F%3E%3Crect%20x%3D%22181%22%20y%3D%2245%22%20width%3D%2270%22%20height%3D%2232%22%20class%3D%22nonterminal%22%2F%3E%3Ctext%20class%3D%22nonterminal%22%20x%3D%22191%22%20y%3D%2265%22%3Eutf8-tail%3C%2Ftext%3E%3Crect%20x%3D%22273%22%20y%3D%2247%22%20width%3D%2270%22%20height%3D%2232%22%2F%3E%3Crect%20x%3D%22271%22%20y%3D%2245%22%20width%3D%2270%22%20height%3D%2232%22%20class%3D%22nonterminal%22%2F%3E%3Ctext%20class%3D%22nonterminal%22%20x%3D%22281%22%20y%3D%2265%22%3Eutf8-tail%3C%2Ftext%3E%3Cpolygon%20points%3D%2251%20107%2058%2091%20118%2091%20125%20107%20118%20123%2058%20123%22%2F%3E%3Cpolygon%20points%3D%2249%20105%2056%2089%20116%2089%20123%20105%20116%20121%2056%20121%22%20class%3D%22regexp%22%2F%3E%3Ctext%20class%3D%22regexp%22%20x%3D%2264%22%20y%3D%22109%22%3E%5B%23xED%5D%3C%2Ftext%3E%3Cpolygon%20points%3D%22145%20107%20152%2091%20248%2091%20255%20107%20248%20123%20152%20123%22%2F%3E%3Cpolygon%20points%3D%22143%20105%20150%2089%20246%2089%20253%20105%20246%20121%20150%20121%22%20class%3D%22regexp%22%2F%3E%3Ctext%20class%3D%22regexp%22%20x%3D%22158%22%20y%3D%22109%22%3E%5B%23x80-%23x9F%5D%3C%2Ftext%3E%3Crect%20x%3D%22275%22%20y%3D%2291%22%20width%3D%2270%22%20height%3D%2232%22%2F%3E%3Crect%20x%3D%22273%22%20y%3D%2289%22%20width%3D%2270%22%20height%3D%2232%22%20class%3D%22nonterminal%22%2F%3E%3Ctext%20class%3D%22nonterminal%22%20x%3D%22283%22%20y%3D%22109%22%3Eutf8-tail%3C%2Ftext%3E%3Cpolygon%20points%3D%2251%20151%2058%20135%20154%20135%20161%20151%20154%20167%2058%20167%22%2F%3E%3Cpolygon%20points%3D%2249%20149%2056%20133%20152%20133%20159%20149%20152%20165%2056%20165%22%20class%3D%22regexp%22%2F%3E%3Ctext%20class%3D%22regexp%22%20x%3D%2264%22%20y%3D%22153%22%3E%5B%23xEE-%23xEF%5D%3C%2Ftext%3E%3Crect%20x%3D%22181%22%20y%3D%22135%22%20width%3D%2270%22%20height%3D%2232%22%2F%3E%3Crect%20x%3D%22179%22%20y%3D%22133%22%20width%3D%2270%22%20height%3D%2232%22%20class%3D%22nonterminal%22%2F%3E%3Ctext%20class%3D%22nonterminal%22%20x%3D%22189%22%20y%3D%22153%22%3Eutf8-tail%3C%2Ftext%3E%3Crect%20x%3D%22271%22%20y%3D%22135%22%20width%3D%2270%22%20height%3D%2232%22%2F%3E%3Crect%20x%3D%22269%22%20y%3D%22133%22%20width%3D%2270%22%20height%3D%2232%22%20class%3D%22nonterminal%22%2F%3E%3Ctext%20class%3D%22nonterminal%22%20x%3D%22279%22%20y%3D%22153%22%3Eutf8-tail%3C%2Ftext%3E%3Cpath%20class%3D%22line%22%20d%3D%22m17%2017%20h2%20m20%200%20h10%20m74%200%20h10%20m0%200%20h10%20m110%200%20h10%20m0%200%20h10%20m70%200%20h10%20m-334%200%20h20%20m314%200%20h20%20m-354%200%20q10%200%2010%2010%20m334%200%20q0%20-10%2010%20-10%20m-344%2010%20v24%20m334%200%20v-24%20m-334%2024%20q0%2010%2010%2010%20m314%200%20q10%200%2010%20-10%20m-324%2010%20h10%20m112%200%20h10%20m0%200%20h10%20m70%200%20h10%20m0%200%20h10%20m70%200%20h10%20m0%200%20h2%20m-324%20-10%20v20%20m334%200%20v-20%20m-334%2020%20v24%20m334%200%20v-24%20m-334%2024%20q0%2010%2010%2010%20m314%200%20q10%200%2010%20-10%20m-324%2010%20h10%20m74%200%20h10%20m0%200%20h10%20m110%200%20h10%20m0%200%20h10%20m70%200%20h10%20m-324%20-10%20v20%20m334%200%20v-20%20m-334%2020%20v24%20m334%200%20v-24%20m-334%2024%20q0%2010%2010%2010%20m314%200%20q10%200%2010%20-10%20m-324%2010%20h10%20m110%200%20h10%20m0%200%20h10%20m70%200%20h10%20m0%200%20h10%20m70%200%20h10%20m0%200%20h4%20m23%20-132%20h-3%22%2F%3E%3Cpolygon%20points%3D%22383%2017%20391%2013%20391%2021%22%2F%3E%3Cpolygon%20points%3D%22383%2017%20375%2013%20375%2021%22%2F%3E%3C%2Fsvg%3E)

```
utf8-3   ::= #xE0 [#xA0-#xBF] utf8-tail
           | [#xE1-#xEC] utf8-tail utf8-tail
           | #xED [#x80-#x9F] utf8-tail
           | [#xEE-#xEF] utf8-tail utf8-tail
```

referenced by:

* braced-passthrough-char
* quoted-value-char
* text-char
* utf8-char
* value-char

**utf8-4:**

![utf8-4](data:image/svg+xml,%3Csvg%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%20width%3D%22481%22%20height%3D%22125%22%3E%3Cdefs%3E%3Cstyle%20type%3D%22text%2Fcss%22%3E%40namespace%20%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%3B%20.line%20%7Bfill%3A%20none%3B%20stroke%3A%20%23332900%3B%20stroke-width%3A%201%3B%7D%20.bold-line%20%7Bstroke%3A%20%23141000%3B%20shape-rendering%3A%20crispEdges%3B%20stroke-width%3A%202%3B%7D%20.thin-line%20%7Bstroke%3A%20%231F1800%3B%20shape-rendering%3A%20crispEdges%7D%20.filled%20%7Bfill%3A%20%23332900%3B%20stroke%3A%20none%3B%7D%20text.terminal%20%7Bfont-family%3A%20Verdana%2C%20Sans-serif%3B%20font-size%3A%2012px%3B%20fill%3A%20%23141000%3B%20font-weight%3A%20bold%3B%20%7D%20text.nonterminal%20%7Bfont-family%3A%20Verdana%2C%20Sans-serif%3B%20font-size%3A%2012px%3B%20fill%3A%20%231A1400%3B%20font-weight%3A%20normal%3B%20%7D%20text.regexp%20%7Bfont-family%3A%20Verdana%2C%20Sans-serif%3B%20font-size%3A%2012px%3B%20fill%3A%20%231F1800%3B%20font-weight%3A%20normal%3B%20%7D%20rect%2C%20circle%2C%20polygon%20%7Bfill%3A%20%23332900%3B%20stroke%3A%20%23332900%3B%7D%20rect.terminal%20%7Bfill%3A%20%23FFDB4D%3B%20stroke%3A%20%23332900%3B%20stroke-width%3A%201%3B%7D%20rect.nonterminal%20%7Bfill%3A%20%23FFEC9E%3B%20stroke%3A%20%23332900%3B%20stroke-width%3A%201%3B%7D%20rect.text%20%7Bfill%3A%20none%3B%20stroke%3A%20none%3B%7D%20polygon.regexp%20%7Bfill%3A%20%23FFF4C7%3B%20stroke%3A%20%23332900%3B%20stroke-width%3A%201%3B%7D%3C%2Fstyle%3E%3C%2Fdefs%3E%3Cpolygon%20points%3D%229%2017%201%2013%201%2021%22%2F%3E%3Cpolygon%20points%3D%2217%2017%209%2013%209%2021%22%2F%3E%3Cpolygon%20points%3D%2251%2019%2058%203%20116%203%20123%2019%20116%2035%2058%2035%22%2F%3E%3Cpolygon%20points%3D%2249%2017%2056%201%20114%201%20121%2017%20114%2033%2056%2033%22%20class%3D%22regexp%22%2F%3E%3Ctext%20class%3D%22regexp%22%20x%3D%2264%22%20y%3D%2221%22%3E%5B%23xF0%5D%3C%2Ftext%3E%3Cpolygon%20points%3D%22143%2019%20150%203%20246%203%20253%2019%20246%2035%20150%2035%22%2F%3E%3Cpolygon%20points%3D%22141%2017%20148%201%20244%201%20251%2017%20244%2033%20148%2033%22%20class%3D%22regexp%22%2F%3E%3Ctext%20class%3D%22regexp%22%20x%3D%22156%22%20y%3D%2221%22%3E%5B%23x90-%23xBF%5D%3C%2Ftext%3E%3Crect%20x%3D%22273%22%20y%3D%223%22%20width%3D%2270%22%20height%3D%2232%22%2F%3E%3Crect%20x%3D%22271%22%20y%3D%221%22%20width%3D%2270%22%20height%3D%2232%22%20class%3D%22nonterminal%22%2F%3E%3Ctext%20class%3D%22nonterminal%22%20x%3D%22281%22%20y%3D%2221%22%3Eutf8-tail%3C%2Ftext%3E%3Crect%20x%3D%22363%22%20y%3D%223%22%20width%3D%2270%22%20height%3D%2232%22%2F%3E%3Crect%20x%3D%22361%22%20y%3D%221%22%20width%3D%2270%22%20height%3D%2232%22%20class%3D%22nonterminal%22%2F%3E%3Ctext%20class%3D%22nonterminal%22%20x%3D%22371%22%20y%3D%2221%22%3Eutf8-tail%3C%2Ftext%3E%3Cpolygon%20points%3D%2251%2063%2058%2047%20154%2047%20161%2063%20154%2079%2058%2079%22%2F%3E%3Cpolygon%20points%3D%2249%2061%2056%2045%20152%2045%20159%2061%20152%2077%2056%2077%22%20class%3D%22regexp%22%2F%3E%3Ctext%20class%3D%22regexp%22%20x%3D%2264%22%20y%3D%2265%22%3E%5B%23xF1-%23xF3%5D%3C%2Ftext%3E%3Crect%20x%3D%22181%22%20y%3D%2247%22%20width%3D%2270%22%20height%3D%2232%22%2F%3E%3Crect%20x%3D%22179%22%20y%3D%2245%22%20width%3D%2270%22%20height%3D%2232%22%20class%3D%22nonterminal%22%2F%3E%3Ctext%20class%3D%22nonterminal%22%20x%3D%22189%22%20y%3D%2265%22%3Eutf8-tail%3C%2Ftext%3E%3Crect%20x%3D%22271%22%20y%3D%2247%22%20width%3D%2270%22%20height%3D%2232%22%2F%3E%3Crect%20x%3D%22269%22%20y%3D%2245%22%20width%3D%2270%22%20height%3D%2232%22%20class%3D%22nonterminal%22%2F%3E%3Ctext%20class%3D%22nonterminal%22%20x%3D%22279%22%20y%3D%2265%22%3Eutf8-tail%3C%2Ftext%3E%3Crect%20x%3D%22361%22%20y%3D%2247%22%20width%3D%2270%22%20height%3D%2232%22%2F%3E%3Crect%20x%3D%22359%22%20y%3D%2245%22%20width%3D%2270%22%20height%3D%2232%22%20class%3D%22nonterminal%22%2F%3E%3Ctext%20class%3D%22nonterminal%22%20x%3D%22369%22%20y%3D%2265%22%3Eutf8-tail%3C%2Ftext%3E%3Cpolygon%20points%3D%2251%20107%2058%2091%20116%2091%20123%20107%20116%20123%2058%20123%22%2F%3E%3Cpolygon%20points%3D%2249%20105%2056%2089%20114%2089%20121%20105%20114%20121%2056%20121%22%20class%3D%22regexp%22%2F%3E%3Ctext%20class%3D%22regexp%22%20x%3D%2264%22%20y%3D%22109%22%3E%5B%23xF4%5D%3C%2Ftext%3E%3Cpolygon%20points%3D%22143%20107%20150%2091%20246%2091%20253%20107%20246%20123%20150%20123%22%2F%3E%3Cpolygon%20points%3D%22141%20105%20148%2089%20244%2089%20251%20105%20244%20121%20148%20121%22%20class%3D%22regexp%22%2F%3E%3Ctext%20class%3D%22regexp%22%20x%3D%22156%22%20y%3D%22109%22%3E%5B%23x80-%23x8F%5D%3C%2Ftext%3E%3Crect%20x%3D%22273%22%20y%3D%2291%22%20width%3D%2270%22%20height%3D%2232%22%2F%3E%3Crect%20x%3D%22271%22%20y%3D%2289%22%20width%3D%2270%22%20height%3D%2232%22%20class%3D%22nonterminal%22%2F%3E%3Ctext%20class%3D%22nonterminal%22%20x%3D%22281%22%20y%3D%22109%22%3Eutf8-tail%3C%2Ftext%3E%3Crect%20x%3D%22363%22%20y%3D%2291%22%20width%3D%2270%22%20height%3D%2232%22%2F%3E%3Crect%20x%3D%22361%22%20y%3D%2289%22%20width%3D%2270%22%20height%3D%2232%22%20class%3D%22nonterminal%22%2F%3E%3Ctext%20class%3D%22nonterminal%22%20x%3D%22371%22%20y%3D%22109%22%3Eutf8-tail%3C%2Ftext%3E%3Cpath%20class%3D%22line%22%20d%3D%22m17%2017%20h2%20m20%200%20h10%20m72%200%20h10%20m0%200%20h10%20m110%200%20h10%20m0%200%20h10%20m70%200%20h10%20m0%200%20h10%20m70%200%20h10%20m-422%200%20h20%20m402%200%20h20%20m-442%200%20q10%200%2010%2010%20m422%200%20q0%20-10%2010%20-10%20m-432%2010%20v24%20m422%200%20v-24%20m-422%2024%20q0%2010%2010%2010%20m402%200%20q10%200%2010%20-10%20m-412%2010%20h10%20m110%200%20h10%20m0%200%20h10%20m70%200%20h10%20m0%200%20h10%20m70%200%20h10%20m0%200%20h10%20m70%200%20h10%20m0%200%20h2%20m-412%20-10%20v20%20m422%200%20v-20%20m-422%2020%20v24%20m422%200%20v-24%20m-422%2024%20q0%2010%2010%2010%20m402%200%20q10%200%2010%20-10%20m-412%2010%20h10%20m72%200%20h10%20m0%200%20h10%20m110%200%20h10%20m0%200%20h10%20m70%200%20h10%20m0%200%20h10%20m70%200%20h10%20m23%20-88%20h-3%22%2F%3E%3Cpolygon%20points%3D%22471%2017%20479%2013%20479%2021%22%2F%3E%3Cpolygon%20points%3D%22471%2017%20463%2013%20463%2021%22%2F%3E%3C%2Fsvg%3E)

```
utf8-4   ::= #xF0 [#x90-#xBF] utf8-tail utf8-tail
           | [#xF1-#xF3] utf8-tail utf8-tail utf8-tail
           | #xF4 [#x80-#x8F] utf8-tail utf8-tail
```

referenced by:

* braced-passthrough-char
* quoted-value-char
* text-char
* utf8-char
* value-char

**utf8-tail:**

![utf8-tail](data:image/svg+xml,%3Csvg%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%20width%3D%22169%22%20height%3D%2237%22%3E%3Cdefs%3E%3Cstyle%20type%3D%22text%2Fcss%22%3E%40namespace%20%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%3B%20.line%20%7Bfill%3A%20none%3B%20stroke%3A%20%23332900%3B%20stroke-width%3A%201%3B%7D%20.bold-line%20%7Bstroke%3A%20%23141000%3B%20shape-rendering%3A%20crispEdges%3B%20stroke-width%3A%202%3B%7D%20.thin-line%20%7Bstroke%3A%20%231F1800%3B%20shape-rendering%3A%20crispEdges%7D%20.filled%20%7Bfill%3A%20%23332900%3B%20stroke%3A%20none%3B%7D%20text.terminal%20%7Bfont-family%3A%20Verdana%2C%20Sans-serif%3B%20font-size%3A%2012px%3B%20fill%3A%20%23141000%3B%20font-weight%3A%20bold%3B%20%7D%20text.nonterminal%20%7Bfont-family%3A%20Verdana%2C%20Sans-serif%3B%20font-size%3A%2012px%3B%20fill%3A%20%231A1400%3B%20font-weight%3A%20normal%3B%20%7D%20text.regexp%20%7Bfont-family%3A%20Verdana%2C%20Sans-serif%3B%20font-size%3A%2012px%3B%20fill%3A%20%231F1800%3B%20font-weight%3A%20normal%3B%20%7D%20rect%2C%20circle%2C%20polygon%20%7Bfill%3A%20%23332900%3B%20stroke%3A%20%23332900%3B%7D%20rect.terminal%20%7Bfill%3A%20%23FFDB4D%3B%20stroke%3A%20%23332900%3B%20stroke-width%3A%201%3B%7D%20rect.nonterminal%20%7Bfill%3A%20%23FFEC9E%3B%20stroke%3A%20%23332900%3B%20stroke-width%3A%201%3B%7D%20rect.text%20%7Bfill%3A%20none%3B%20stroke%3A%20none%3B%7D%20polygon.regexp%20%7Bfill%3A%20%23FFF4C7%3B%20stroke%3A%20%23332900%3B%20stroke-width%3A%201%3B%7D%3C%2Fstyle%3E%3C%2Fdefs%3E%3Cpolygon%20points%3D%229%2017%201%2013%201%2021%22%2F%3E%3Cpolygon%20points%3D%2217%2017%209%2013%209%2021%22%2F%3E%3Cpolygon%20points%3D%2231%2019%2038%203%20134%203%20141%2019%20134%2035%2038%2035%22%2F%3E%3Cpolygon%20points%3D%2229%2017%2036%201%20132%201%20139%2017%20132%2033%2036%2033%22%20class%3D%22regexp%22%2F%3E%3Ctext%20class%3D%22regexp%22%20x%3D%2244%22%20y%3D%2221%22%3E%5B%23x80-%23xBF%5D%3C%2Ftext%3E%3Cpath%20class%3D%22line%22%20d%3D%22m17%2017%20h2%20m0%200%20h10%20m110%200%20h10%20m3%200%20h-3%22%2F%3E%3Cpolygon%20points%3D%22159%2017%20167%2013%20167%2021%22%2F%3E%3Cpolygon%20points%3D%22159%2017%20151%2013%20151%2021%22%2F%3E%3C%2Fsvg%3E)

```
utf8-tail
         ::= [#x80-#xBF]
```

referenced by:

* utf8-2
* utf8-3
* utf8-4
