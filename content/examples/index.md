---
layout: static
title: SILE Examples
---

<table class="examples">
{% tablerow example in site.data.examples.basic cols:3%}
    <a href="{{example.fn}}.png">
		<img src="{{example.fn}}-thumb.png">
    </a>
    <br/>
    <span class="title">{{example.title}}</span><br/>
    (<a href="{{example.source}}">source</a>)
    (<a href="{{example.fn}}.pdf">PDF</a>)
{% endtablerow %}
</table>
