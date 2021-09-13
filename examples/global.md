---
layout: static
title: SILE Examples - Global Scripts
---

<table class="examples">
{% tablerow example in site.data.examples.global cols:3%}
    <a href="{{example.fn}}.png">
    <img src="{{example.fn}}.png">
    </a>
    <br/>
    <span class="title">{{example.title}}</span><br/>
    (<a href="{{example.source}}">source</a>) 
    (<a href="{{example.fn}}.pdf">PDF</a>)
{% endtablerow %}
</table>
