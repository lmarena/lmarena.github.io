# Chatbot Arena Blog

For careful documentation of this template, see [here](https://github.com/alshedivat/al-folio/tree/master).

## Dev workflow

First run `bundle install`. Then run `bundle exec jekyll serve` to start a local server. To build for production, run `bundle exec jekyll build` and copy `_site` to the server.

If you also want to remove unused css classes from your file, run:

```bash
$ purgecss -c purgecss.config.js
```

which will replace the css files in the `_site/assets/css/` folder with the purged css files.

**Note:** Make sure to correctly set the `url` and `baseurl` fields in `_config.yml` before building the webpage. If you are deploying your webpage to `your-domain.com/your-project/`, you must set `url: your-domain.com` and `baseurl: /your-project/`. If you are deploying directly to `your-domain.com`, leave `baseurl` blank, **do not delete it**.

## Blog post formatting

We will write blog posts in the distill format. See [this example](https://alshedivat.github.io/al-folio/blog/2021/distill/) for an example, and [this template](https://github.com/alshedivat/al-folio/blob/master/_posts/2018-12-22-distill.md?plain=1) for code.

This template was taken from [AI-Folio](https://github.com/alshedivat/al-folio).
