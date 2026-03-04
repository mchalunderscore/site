import api/github
import gleam/list
import gleeunit
import gleeunit/should

pub fn main() {
  gleeunit.main()
}

// Smoke tests for GitHub API JSON parsing

pub fn parse_user_json_valid_test() {
  let json = "{\"public_repos\": 42, \"followers\": 100, \"following\": 50}"

  let result = github.parse_user_json(json)
  should.be_ok(result)

  let assert Ok(stats) = result
  stats.repos |> should.equal(42)
  stats.followers |> should.equal(100)
  stats.following |> should.equal(50)
  stats.stars |> should.equal(0)
  stats.languages |> should.equal(0)
}

pub fn parse_user_json_invalid_test() {
  let json = "{\"invalid\": \"data\"}"

  let result = github.parse_user_json(json)
  should.be_error(result)
}

pub fn parse_repos_json_valid_test() {
  let json =
    "["
    <> "{\"name\": \"my-repo\", \"description\": \"A test repo\", \"language\": \"Rust\", \"stargazers_count\": 10, \"forks_count\": 2, \"html_url\": \"https://github.com/user/my-repo\"},"
    <> "{\"name\": \"another-repo\", \"description\": null, \"language\": null, \"stargazers_count\": 5, \"forks_count\": 0, \"html_url\": \"https://github.com/user/another-repo\"}"
    <> "]"

  let result = github.parse_repos_json(json)
  should.be_ok(result)

  let assert Ok(repos) = result
  list.length(repos) |> should.equal(2)

  // First repo
  let assert [first, second] = repos
  first.name |> should.equal("my-repo")
  first.description |> should.equal("A test repo")
  first.language |> should.equal("Rust")
  first.stars |> should.equal(10)
  first.forks |> should.equal(2)
  first.url |> should.equal("https://github.com/user/my-repo")

  // Second repo (null handling)
  second.name |> should.equal("another-repo")
  second.description |> should.equal("No description provided.")
  second.language |> should.equal("")
}

pub fn parse_repos_json_empty_test() {
  let json = "[]"

  let result = github.parse_repos_json(json)
  should.be_ok(result)

  let assert Ok(repos) = result
  list.length(repos) |> should.equal(0)
}

pub fn parse_repos_json_invalid_test() {
  let json = "{\"invalid\": \"data\"}"

  let result = github.parse_repos_json(json)
  should.be_error(result)
}
