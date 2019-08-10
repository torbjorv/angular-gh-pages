# CI/CD with Angular and GitHub Pages

Angular relies on all URLs being redirected to index.html, which means an app can easily be deployed to GitHub pages simply by duplicating index.html as 404.html. For my Angular experiments I wanted a more professional CI/CD pipeline where I could deploy 'prod' and 'staging' builds side-by-side, still using GitHub pages. This is a bit more tricky, but can be achived as shown here.

- [prod](https://torbjorv.github.io/angular-gh-pages/): The 'prod' or 'stable' version of the app, loading from the root of the GitHub Pages. 
- [dev](https://torbjorv.github.io/angular-gh-pages/versions/latest/): The latest 'dev' version, loading from /versions/latest
- [All](https://github.com/torbjorv/angular-gh-pages/blob/gh-pages/versions/versions.md): All older versions, loading from /versions/<BUILD_ID> 

The magic happens in [404.html](https://github.com/torbjorv/angular-gh-pages/blob/gh-pages/404.html). The javascript code inspects the URL, figures out which version of the app should be loaded, fetches the appropriate index.html and simply overwrites the current document (we can't use redirect as that would change the URL and trip up Angular). 

The [CI/CD pipeline](https://circleci.com/gh/torbjorv/workflows/angular-gh-pages) uses CircleCI with a manual approval step for promoting a successfully deployed 'dev' version to 'prod'.