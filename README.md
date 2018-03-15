ci-utils
---

ci-utils is support script suite for CI (Continuous Integration).

ci-utils provide following script.
- send status to github
- send deployment status to github
- apply static code test to file changes only

# How to Use

## install ci-utils

.circleci/config.yml

```
version: 2
jobs:
  build:
    docker:
      - image: .......
    steps:
      # setup ci-utils
      - run:
          name: install ci-utils
          command: |
            mkdir -p $HOME/.ci-utils
            curl -L https://github.com/takemikami/ci-utils/archive/master.tar.gz | tar zx -C $HOME/.ci-utils --strip-components 1
            echo 'export PATH=$PATH:$HOME/.ci-utils/bin' >> $BASH_ENV
            source $BASH_ENV
```

set environment variable GH_ACCESS_TOKEN to CicleCI.  
GH_ACCESS_TOKEN is "<github username>:<personal access toke>".

## execute support scripts

sent status to github

```
ciutils_gh_status_post -s success -u http://localhost/ -d "status is ok"
```

send deployment status to github.

```
ciutils_gh_deployment_post -u http://localhost/
```

send simple coverage status to github.

```
ciutils_gh_status_post_simplecov -t 80 -r coverage/index.html
```

apply static code test to file changes only

```
bundle exec rubocop | ciutils_difflint
```
