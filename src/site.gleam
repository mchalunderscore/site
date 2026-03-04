import cache/github as cache
import gleam/erlang/process
import gleam/int
import gleam/result
import gleam/string
import mist
import router
import types.{AppContext}
import wisp

const default_port = 8080

@external(erlang, "gleam_erlang_ffi", "get_env")
fn get_env(name: String) -> Result(String, Nil)

pub fn main() {
  wisp.configure_logger()

  let port =
    get_env("PORT")
    |> result.try(int.parse)
    |> result.unwrap(default_port)

  let github_username =
    get_env("GITHUB_USERNAME")
    |> result.unwrap("jastrzymb")

  case cache.new() {
    Error(_) -> {
      wisp.log_error("Failed to initialize cache actor")
      Nil
    }
    Ok(cache_pid) -> {
      let ctx = AppContext(github_username: github_username, cache: cache_pid)
      let secret_key_base = wisp.random_string(64)

      let mist_handler =
        wisp.mist_handler(
          fn(req) { router.handle_request(req, ctx) },
          secret_key_base,
        )

      case
        mist.new(mist_handler)
        |> mist.port(port)
        |> mist.start_http()
      {
        Error(err) -> {
          wisp.log_error("Failed to start HTTP server: " <> string.inspect(err))
          Nil
        }
        Ok(_) -> process.sleep_forever()
      }
    }
  }
}
