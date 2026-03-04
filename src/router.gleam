import api/github as github_api
import cache/github as cache
import gleam/http/response
import lustre/element
import types.{GitHubStats}
import views/home
import views/layout
import wisp.{type Request, type Response}

pub fn handle_request(req: Request, ctx: types.AppContext) -> Response {
  wisp.serve_static(req, under: "/", from: "priv/static", next: fn() {
    case wisp.path_segments(req) {
      [] -> handle_home(ctx)
      _ -> wisp.not_found()
    }
  })
}

fn handle_home(ctx: types.AppContext) -> Response {
  use stats, repos, api_error <- get_github_data(ctx)

  let html_content =
    home.page(stats, repos, api_error)
    |> layout.base("Jastrzůmb - Functional Programming Enthusiast", _)
    |> element.to_document_string_builder()

  response.new(200)
  |> response.set_body(wisp.Text(html_content))
  |> response.set_header("content-type", "text/html; charset=utf-8")
  |> response.set_header("cache-control", "public, max-age=300")
}

fn get_github_data(
  ctx: types.AppContext,
  handler: fn(types.GitHubStats, List(types.GitHubRepo), Bool) -> Response,
) -> Response {
  case cache.get_stats(ctx.cache) {
    Ok(stats) -> {
      let repos = case cache.get_repos(ctx.cache) {
        Ok(repos) -> repos
        Error(_) -> []
      }
      handler(stats, repos, False)
    }
    Error(_) -> load_from_api(ctx, handler)
  }
}

fn load_from_api(
  ctx: types.AppContext,
  handler: fn(types.GitHubStats, List(types.GitHubRepo), Bool) -> Response,
) -> Response {
  let username = ctx.github_username

  case github_api.fetch_user_stats(username) {
    Ok(user_stats) ->
      case github_api.fetch_repos(username) {
        Ok(repos) -> {
          let full_stats = merge_stats(user_stats, repos)
          cache.set_stats(ctx.cache, full_stats)
          cache.set_repos(ctx.cache, repos)
          handler(full_stats, repos, False)
        }
        Error(_) -> handler(fallback_stats(), [], True)
      }
    Error(_) -> handler(fallback_stats(), [], True)
  }
}

fn merge_stats(
  user_stats: types.GitHubStats,
  repos: List(types.GitHubRepo),
) -> types.GitHubStats {
  let total_stars = github_api.calculate_total_stars(repos)
  let languages = github_api.count_languages(repos)
  GitHubStats(..user_stats, stars: total_stars, languages: languages)
}

fn fallback_stats() -> types.GitHubStats {
  GitHubStats(repos: 0, followers: 0, following: 0, stars: 0, languages: 0)
}
