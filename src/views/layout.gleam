import lustre/attribute
import lustre/element.{type Element}
import lustre/element/html

pub fn base(title: String, content: List(Element(a))) -> Element(a) {
  html.html([attribute.attribute("lang", "en")], [
    html.head([], [
      html.meta([attribute.attribute("charset", "UTF-8")]),
      html.meta([
        attribute.name("viewport"),
        attribute.attribute("content", "width=device-width, initial-scale=1.0"),
      ]),
      html.meta([
        attribute.name("description"),
        attribute.attribute(
          "content",
          "Michal S. (Jastrzymb) - Functional programming enthusiast and developer. Rust, Gleam, Python.",
        ),
      ]),
      html.meta([
        attribute.name("robots"),
        attribute.attribute("content", "index, follow"),
      ]),
      html.link([
        attribute.rel("canonical"),
        attribute.href("https://mchal.lol/"),
      ]),
      html.meta([
        attribute.attribute("property", "og:title"),
        attribute.attribute("content", title),
      ]),
      html.meta([
        attribute.attribute("property", "og:description"),
        attribute.attribute(
          "content",
          "Michal S. (Jastrzymb) - Functional programming enthusiast and developer.",
        ),
      ]),
      html.meta([
        attribute.attribute("property", "og:type"),
        attribute.attribute("content", "website"),
      ]),
      html.meta([
        attribute.attribute("property", "og:url"),
        attribute.attribute("content", "https://mchal.lol/"),
      ]),
      html.meta([
        attribute.attribute("property", "og:image"),
        attribute.attribute("content", "https://mchal.lol/goshawk_bg.png"),
      ]),
      html.meta([
        attribute.attribute("name", "twitter:card"),
        attribute.attribute("content", "summary_large_image"),
      ]),
      html.meta([
        attribute.attribute("name", "twitter:title"),
        attribute.attribute("content", title),
      ]),
      html.meta([
        attribute.attribute("name", "twitter:description"),
        attribute.attribute(
          "content",
          "Michal S. (Jastrzymb) - Functional programming enthusiast and developer.",
        ),
      ]),
      html.meta([
        attribute.attribute("name", "twitter:image"),
        attribute.attribute("content", "https://mchal.lol/goshawk_bg.png"),
      ]),
      html.script(
        [attribute.attribute("type", "application/ld+json")],
        "{\"@context\":\"https://schema.org\",\"@type\":\"Person\",\"name\":\"Michal S.\",\"alternateName\":\"Jastrzymb\",\"jobTitle\":\"Developer and Project Lead\",\"url\":\"https://mchal.lol/\",\"sameAs\":[\"https://github.com/jastrzymb\",\"mailto:me@mchal.lol\"],\"knowsAbout\":[\"Functional Programming\",\"Rust\",\"Gleam\",\"Python\",\"Type Systems\"]}",
      ),
      html.title([], title),
      html.link([
        attribute.rel("preconnect"),
        attribute.href("https://fonts.googleapis.com"),
      ]),
      html.link([
        attribute.rel("preconnect"),
        attribute.href("https://fonts.gstatic.com"),
        attribute.attribute("crossorigin", ""),
      ]),
      html.link([
        attribute.rel("stylesheet"),
        attribute.href(
          "https://fonts.googleapis.com/css2?family=IBM+Plex+Mono:wght@400;500;600;700&family=Space+Mono:wght@400;700&display=swap",
        ),
      ]),
      html.link([
        attribute.rel("icon"),
        attribute.attribute("type", "image/svg+xml"),
        attribute.href(
          "data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 32 32'%3E%3Ccircle cx='16' cy='16' r='16' fill='%23f5f2e8'/%3E%3Ctext x='50%25' y='50%25' dominant-baseline='central' text-anchor='middle' font-family='Space Mono, monospace' font-weight='700' font-size='32' fill='%233e2723'%3EJ%3C/text%3E%3C/svg%3E",
        ),
      ]),
      html.link([
        attribute.rel("stylesheet"),
        attribute.href("/style.css"),
      ]),
    ]),
    html.body([], [navigation(), ..content]),
  ])
}

fn navigation() -> Element(a) {
  html.nav([attribute.id("navbar"), attribute.class("nav")], [
    html.div([attribute.class("nav-container")], [
      html.a([attribute.href("#"), attribute.class("logo")], [
        html.text("┌Jastrzymb┐"),
      ]),
      html.div([attribute.class("nav-links")], [
        html.a([attribute.href("#about")], [html.text("About")]),
        html.span([attribute.class("nav-separator")], [html.text("|")]),
        html.a([attribute.href("#projects")], [html.text("Projects")]),
        html.span([attribute.class("nav-separator")], [html.text("|")]),
        html.a([attribute.href("#orgs")], [html.text("Orgs")]),
        html.span([attribute.class("nav-separator")], [html.text("|")]),
        html.a([attribute.href("#stats")], [html.text("Stats")]),
        html.span([attribute.class("nav-separator")], [html.text("|")]),
        html.a([attribute.href("#contact")], [html.text("Contact")]),
      ]),
      html.a(
        [
          attribute.href("https://github.com/jastrzymb"),
          attribute.attribute("target", "_blank"),
          attribute.attribute("rel", "noopener noreferrer"),
          attribute.class("github-link"),
        ],
        [html.text("[github]")],
      ),
    ]),
  ])
}
