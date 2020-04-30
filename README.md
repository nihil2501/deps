# Dependency Explorer
An interactive tool for building documentation of service dependency graphs at Leafly.

## Setup
`asdf install`
`bundle install`

https://help.github.com/en/github/authenticating-to-github/creating-a-personal-access-token-for-the-command-line
Generate a Github personal access token with OAuth scopes of (perhaps too much?):
* `read:gpg_key`
* `read:org`
* `read:public_key`
* `read:repo_hook`
* `repo`
* `user`
Make sure you Enable SSO for Leafly-com.
Then assign it to `OCTOKIT_ACCESS_TOKEN` in `.env`

## Usage
`./deps.sh docs/path/to/file.json`
