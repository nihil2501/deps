An interactive tool for generating documentation of service dependency graphs at Leafly.
Uses Github's code search API.

## Setup
```
asdf install
bundle install
```

https://help.github.com/en/github/authenticating-to-github/creating-a-personal-access-token-for-the-command-line
Generate a Github personal access token with OAuth scopes of (perhaps too much?):
* `read:gpg_key`
* `read:org`
* `read:public_key`
* `read:repo_hook`
* `repo`
* `user`

Make sure you `Enable SSO` for `Leafly-com`

Then assign it to `OCTOKIT_ACCESS_TOKEN` in `.env`

## Usage
`./deps.sh docs/path/to/file.json`

This file should be seeded with an initial query like
```json
{
  "q": "search_menu_item_v3"
}
```
Then the tool will help you fill out the rest of the graph.

## TODO
* Make it progressive / possible to pick up where you left off (if it doesn't already do this, I can't remember)
* Depth or breadth first search preferable? Make this a user option?
