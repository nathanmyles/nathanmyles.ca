+++
date = 2020-08-13T02:00:00Z
lastmod = 2020-08-13T02:00:00Z
author = "default"
title = "Rebuilding my website using a static site generator"
subtitle = "How I used Hugo to rebuild my website"
feature = "/img/gohugoio-card.png"
tags = ["Hugo"]
+++

I've been neglecting my personal site for years... Looking at the last modified dates on my web hosting, I haven't 
updated most files since 2013. For over a year, I've wanted to swamp from my old PHP based site to something markdown 
based. A static site generator seemed like a better way to go for a site like this, so when I found Hugo, a static site 
generator where you maintain your content in markdown files, I was sold.

I started by following the quick start guide [here](https://gohugo.io/getting-started/quick-start/). It was easy to get 
started:
1. `brew install hugo` to install `hugo`
1. use `hugo new site <project name>` to generate the structure of your site
1. pick and install a theme from the wide variety [available](https://themes.gohugo.io/)
1. use `hugo new posts/<post-name>.md` to generate a markdown file you can start adding content to
1. run `hugo server -D` and navigate to [http://localhost:1313/](http://localhost:1313/.) to see your site

Hugo server conveniently rebuilds whenever a file changes and updates without having to refresh, though I did find 
myself needing to hard refresh the page from time to time in order to see certain changes.

After playing with Hugo and the theme [axiom](https://github.com/marketempower/axiom) to get used to the tool, I decided
to drop the theme and just go with building the site from scratch, based on my previous site. I converted things into 
Hugo's format and got a few pages working more or less as they had on my current site. I decided to replace my cycling 
photo banner with one static banner image of me at Yosemite. I also needed to update bootstrap, I was using version 2 on 
my current site, but it was mainly just a few class name changes to get things working again and looking better. 

I simplified the content significantly, dropping a lot of the pages that I created when I was first building the site 
for my NSCC portfolio site in 2010/2011. I decided I'd focus on a resume, contact info, and posts section that I could
write things like this.

Hugo has a great templating language that allows you to take the contents of your markdown files and create HTML 
layouts. I'll take you through a quick example of my post template (that's being used to generate this page) but the 
Hugo docs are great. If you'd like to learn more or building your own static site using markdown files, I highly suggest
you check them out [here](https://gohugo.io/documentation/).

So the markdown file I ended up going with looks like:
```
+++
date = 2020-08-13T02:00:00Z
lastmod = 2020-08-13T02:00:00Z
author = "default"
title = "Rebuilding my website using a static site generator"
subtitle = "How I used Hugo to rebuild my website"
feature = "/img/gohugoio-card.png"
tags = ["Hugo"]
+++

I've been neglecting my personal site for years...
```

The top block of metadata can be accessed via the templating language by the attribute name, everything below the second
line of `+++` is the `Content`.

The layout I used for my posts looks like this:

```
{{ define "main" }}
<div class="single">
    <div class="d-sm-flex align-items-center">
        <div>
            <h1>{{ .Title }}</h1>
            {{ if .Params.subtitle }}
            <h3 class="text-muted">{{ .Params.subtitle }}</h3>
            {{ end }}
        </div>
        <div class="text-center d-flex d-sm-block m-4">
            {{ partial "author" . }}
            <span>
                Post Date:<br/>
                {{- $dateFormat := .Site.Params.dateFormat | default "Jan 2, 2006" -}}
                <time datetime="{{ dateFormat "2006-01-02T15:04:05Z" .Date.UTC | safeHTML }}">
                    {{ dateFormat $dateFormat .Date.Local }}
                </time>
            </span>
        </div>
    </div>
    {{ if .Params.feature }}<img src="{{ .Params.feature }}"/>{{ end }}
    <div class="pt-4">{{ .Content }}</div>
</div>
{{ end }}
```

You can see that the layout is wrapped in a `{{ define "main" }}` block, which is a block that is defined in my 
`baseof.html` template, the main template in Hugo. This layout is injected into that template when building this page.
There are also examples of injecting metadata and the content from the markdown file above. I use another layout, 
`author`, to handle the displaying of the author on this page. That's done with the `{{ partial "author" . }}` command.
The dot at the end of the command is the context I'm handing into the layout, from which it will pull its variables. I'm
also formatting the post date using the `dateFormat` command. If you "View Source" in your browser you can see the HTML
Hugo generates.

All the code for this site is on github and available at this [link](https://github.com/nathanmyles/nathanmyles.ca). If 
you're interested in learning more let me know!