# User Tokens Updater
Coding challenge solution for Thrive

## Description
This system reads data from a `companies.json` file and a `users.json` file,
creates an `output.txt` file indicating old a new token balance and email activity
for each user in each company.

## Requirements
* Ruby v3.0
  * config.rb uses endless functions
* Bundler vx.x.x

## Installation
* from the command line:
  * clone this repo
_NOTE: repo is private as of 2023-09-13. Contact rick@iddesign.ca
to add additional accounts as collaborators._
```bash
git clone https://github.com/rickgladwin/thrive_challenge.git
```
  * install dependencies
```bash
bundle install
```

## Notes and choices
### code style
* rubocop flags long method names. But I prefer descriptive method names that are a little
bit long to shorter, ambiguous names, especially as a project grows.
* column alignment of variable declarations etc. – I find this makes the code more readable,
but this is the kind of style choice that is best agreed upon by a team and set in a style checker.

### dynamic typing + rbs typing
For a small project like this, type declarations may be overkill, but I added them for a couple reasons:
* It was mentioned in the project brief that there could be bad data in the json files. Explicit validation
will address this, but I hold to the idea that we should catch errors as early as possible in a process, and
type declarations are one more way to catch errors earlier, including at development time.
* While an obsession with type safety can be inefficient for development in a dynamically typed language
like Ruby, I find a bit of type definition adds clarity and structure.
* Depending on the Ruby version and runtime details of the system on which the code is
running, making use of type declarations can make code perform better, especially since
Ruby 3.3.0 is expected to have a JIT compiler.
* RBS is neat.
