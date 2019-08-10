# CI/CD with Angular and GitHub Pages

An Angular app relies on all URLs being redirected to index.html. This can easily be achieved with GitHub pages simply by duplicating index.html as 404.html, but for a somewhat more professional CI/CD pipeline I needed multiple versions of the app deployed to GH pages simultanously. Like this:

- [prod](https://torbjorv.github.io/angular-gh-pages/): A 'prod' or 'stable' version of the app loading from the root of the GitHub Pages. 
- [dev](https://torbjorv.github.io/angular-gh-pages/versions/latest): The latest 'dev' version loading from /versions/latest
- [All](https://github.com/torbjorv/angular-gh-pages/blob/gh-pages/versions/versions.md): All older versions loading from /versions/<BUILD_ID> 

The magic happens in [404.html](https://github.com/torbjorv/angular-gh-pages/blob/gh-pages/404.html). Th javascript code inspects the URL, figures out which version of the app should be loaded, fetches the appropriate index.html and simply overwrites the document with it (we can't use redirect as that would change the URL and trip up Angular). 

The [CI/CD pipeline](https://circleci.com/gh/torbjorv/workflows/angular-gh-pages) uses CircleCI with a manual approval step for promoting a successfully deployed 'dev' version to 'prod'.