ci-utils
---

ci-utils is support script suite for CI/CD (Continuous Integration & Continuous Delivery). ci-utils support your GitHub PullRequest status operations, application deployment control, testing in CI.

Main Features:

- Send status to GitHub
- Send deployment status to GitHub
- Detect deployment environment by GitHub Label
- Apply static code test to file changes only

Support Services:
- Software Repository Management Service
   - GitHub
   - GitHub Enterprise
- CI/CD Service
   - Travis CI
   - CircleCI
   - Drone


## Install

Put install.sh call process to CI/CD configuration. The following are sample configuration script for each service.

### Travis CI

.travis.yml

```
language: bash

script:
  - sh <(curl -L https://raw.githubusercontent.com/takemikami/ci-utils/master/install.sh)
  - export PATH=$PATH:$HOME/.ci-utils/bin
```

### CircleCI

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

### Drone

.drone.yml

```
pipeline:
  build:
    image: ruby:2.5.1-alpine
    commands:
      - sh <(curl -L https://raw.githubusercontent.com/takemikami/ci-utils/master/install.sh)
      - export PATH=$PATH:$HOME/.ci-utils/bin
```


## Environment Variables

Set following environment variable to CI/CD service you use, if integrating some services.

- GITHUB_ACCESS_TOKEN: github access token like username:token
- GHE_HOSTNAME: hostname of github enterprise
- SONARQUBE_TOKEN: sonarqube access token like username:token
- SONARQUBE_HOST: hostname of sonarqube


## Scripts

### Post commit status to GitHub

This script post commit status to GitHub. It's used for automatic-checks of branch protection, and you can work by PullRequest-based workflow.

parameters:

- s ... commit status. pending, sucess, error or failure. default: pending.
- u ... target url.
- d ... description.
- c ... context.

required environment variables: GITHUB_ACCESS_TOKEN

example:

```
ciutils github_post_status -s success -u http://localhost/ -d "status is ok"
```

### Post deployment status to GitHub

This script post deployment status to GitHub. And you can see deployment status and target link in PullRequest timeline.

parameters:

- s ... deployment status. error, failure, pending or success. default: success.
- u ... target url.
- e ... environment.

required environment variables: GITHUB_ACCESS_TOKEN

example:

```
ciutils github_post_deployment -u http://localhost/
```

### Send simple coverage status to GitHub

send simple coverage status to github.

```
ciutils_gh_status_post_simplecov -t 80 -r coverage/index.html
```

### Apply static code test to file changes only

apply static code test to file changes only

```
bundle exec rubocop | ciutils_difflint
```

### Detect deployment environment by GitHub Label

This script echo the label name, when CI-targeted PullRequest is labeled by the name like "env:XXX".
It's userd for deployment environment control by label. For example, The Module of "env:stg" labeled PullRequest will deploy to staging server, if your deployment command called with this script's output as an environment target option.

parameters:

- l ... label prefixes. default: "env:"

required environment variables: GITHUB_ACCESS_TOKEN

example:

```
DEPLOYMENT_ENV=`ciutils github_detect_env`
if [ "$DEPLOYMENT_ENV" == "" ]; then exit 0; fi
your-deployment-command --env $DEPLOYMENT_ENV
```
