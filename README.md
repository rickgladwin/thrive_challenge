# User Tokens Updater
Coding challenge solution for Thrive

## Description
This system: 
* reads data from a `companies.json` file and a `users.json` file
* creates an `output.txt` file indicating old and new token balance and email activity
for each user in each company.

## Requirements
* Ruby v3.0
  * config.rb uses endless functions

## Installation
* from the command line:
  * clone this repo
_NOTE: repo is private as of 2023-09-13. Contact rick@iddesign.ca
to add additional accounts as collaborators._
```bash
git clone https://github.com/rickgladwin/thrive_challenge.git
```
  * (this project has no non-core dependencies, so installing gems should be unnecessary)

## Run
* from the command line:
* cd into the project's root directory (`thrive_challenge/`)
* `ruby challenge.rb`

## Test
Some files have a `if __FILE__ == $0` section at the end, holding basic file-level unit
tests. The tests aren't comprehensive, but have been left in place as a tool.

As an example:
* from the command line:
* `ruby reports.rb`

If any of the unit tests fail, you'll see an exception raised on the command line.
Otherwise, all the unit tests are passing.

## Notes and choices
### code style
* I find the easiest way to ensure a team is following the same style is to have
rubocop running with a custom configuration (based on shared standards and preferences).
I wanted this project to be dependency-free, though (outside of Ruby core dependencies like `json`)
* rubocop and other style checkers flag long method names. But I prefer descriptive method names that are a little
bit long to shorter, ambiguous names, especially as a project grows.
* column alignment of variable declarations etc. – I find this makes the code more readable,
but this is the kind of style choice that is best agreed upon by a team and set in a style checker.

### dynamic typing + rbs typing
For a small project like this, type declarations may be overkill, but I added them for a few reasons:
* It was mentioned in the project brief that there could be bad data in the json files. Explicit validation
will address this, but I hold to the idea that we should catch errors as early as possible in a process, and
type declarations are one more way to catch errors earlier, including at development time.
* While an obsession with type safety can be inefficient for development in a dynamically typed language
like Ruby, I find a bit of type definition adds clarity and structure.
* Depending on the Ruby version and runtime details of the system on which the code is
running, making use of type declarations can make code perform better, especially since
Ruby 3.3.0 is expected to have a JIT compiler.
* RBS is neat.

### output format
* There are some edits I would have made to the output.txt template, namely:
  * "Previous Token Balance," ends with a comma vs "New Token Balance" with no comma
  * "Total amount of top ups for..." is indented, but could be in line with the
left column, given that it's data about the company.
  * `example_output.txt` ends with two newline characters, rather than one.
  
  In a real-world development team, I would likely send a note to whomever is in charge
  of the template to confirm its formatting or make changes, but this is a coding challenge
  and I'm trying to respect everyone's time. So I chose to replicate the template exactly.

### unit testing
In production code, I always like to have complete test coverage for all the requirements (using rspec,
end-to-end tests, etc.)

For this coding challenge, both to save time and to keep the project dependency-free, I've 
opted for file-level unit tests. The unit tests for a given file will run when the file is run
directly from the command line AND Config.run_file_level_unit_tests is true.

This type of unit test is generated as a natural part of writing and checking the code
at development time, and serves as a useful tool when refactoring or debugging later if
left in place, or can be deleted before deployment to production.

### Things I would change
* The `Company` class has methods that are coupled to the file format of the data
  (using `File` and `json` directly). This works fine for static code, but abstracting
the data retrieval and/or adding a facade or wrapper around the data read functionality
would make the code more reusable, more modular, and easier to refactor.
* I like validators to return a tuple or similar object, holding a boolean and a message.
The `Company.validate_user_data` method currently returns a boolean only, making debugging
harder.
* Since there is a restriction on the Ruby version (3.0.0 and above), due to the use of
endless functions, I could add a section to `challenge.rb` that will check the ruby version,
or check that endless functions are supported in the current Ruby environment. In a larger project,
enforcing such a restriction can be handled in the Gemfile.