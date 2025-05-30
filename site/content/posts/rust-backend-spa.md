---
title: "Using Rust Backend To Serve An SPA"
date: 2025-05-29T12:49:19+07:00
draft: true
toc: true
tags:
categories:
- explanation
- how-to-guide
---

In web development and deployment, most software engineers are familiar with
either:

1. Separating the built SPA and the backend (Client-Side Rendering), or
2. Return HTML directly from the backend (Server-Side Rendering)

I recently (re)discovered [^rediscovered] that there is a third way: embedding
the built SPA into the backend's binary file, and serving it directly.

![](../images/rust-backend-spa.webp)

I think this is an elegant approach, as the pros are:

- Simpler deployment as we only have one binary file in the end
- Simpler code where we don't have to take into account CORS and the backend
  endpoint since the frontend and backend are served from the same origin
  [^simpler-code]

The cons are quite clear:

- No matter how good is it, it's still an unconventional approach; expect lots
  of push back from people
- Increased binary size and memory usage because of the static file embedding
- Slightly reduced DX due to no frontend hot reloading [^simpler-code]

In more details, the steps are:

1. Build the frontend
2. Copy the frontend built artifact to backend's static folder serving
3. Run the backend binary
4. (for production environment) Try to embed the built frontend to the backend's
   binary before deploying

Let's get into how are we doing it with Rust/Axum and Svelte/SvelteKit
[^example-rust-embed-sveltekit]. While the code that I'm going to show you is in
that specific stack, I think it's not challenging to adopt the mindset to other
languages and frameworks and libraries [^go-embed].

## Project Structure

For simplicity, I'd start with a monorepo setup, where the backend and the
frontend are in separate folders in the same Git repository. I'm sure the same
end result is achievable with a polyrepo setup, given enough effort.

```
.
├── ...
├── packages
│   ├── frontend
│   └── backend
└── README.md
```

I'm using monorepo tool called Moon [^moonrepo]. By the developers' terms, it
sits:

- Above task runners like Make or Just
- Below full-blown tools like Bazel

It has both build cache and task dependency built-in, adding "just enough"
structure to the tasks around a monorepo.

```yaml
# packages/frontend/moon.yml
tasks:
  install:
    command: 'npx pnpm install'

  build:
    command: 'npm run build'

  serve:
    command: 'npx vite build --watch'

# packages/backend/moon.yml
tasks:
  install:
    command: 'cargo build'

  build:
    command: 'cargo build --release'
    # Notice that we have a frontend build step before
    deps:
      - 'frontend:build'

  serve:
    command: 'cargo run'
```

## Frontend

Here is the frontend folder structure:

```
.
├── ...
├── moon.yml
├── package.json
├── README.md
├── src
│   ├── ...
│   ├── lib
│   │   └── index.ts
│   └── routes
│       ├── child-url
│       │   └── +page.svelte
│       ├── +layout.svelte
│       ├── +page.svelte
│       └── ...
└── ...
```

The home page at `/`, which has its source at `src/routes/+page.svelte` would
try to demonstrate a very simple data fetching from the backend. There is a link
to a child URL to see if navigation works:

```svelte
<script lang="ts">
async function fetchData() {
  const resp = await fetch("/api/data");
  return await resp.text();
}
</script>

<div class="prose max-w-none">
    <h1>SPA Frontend</h1>

    <p>
        {#await fetchData()}
            Fetching data from <code>/api/data</code> <br/>
            (should take precisely 3 seconds)
        {:then data}
            {data}
        {/await}
    </p>

    <a href="child-url">Go to another route</a>
</div>
```

Moving into the frontend folder, let's assume that we have a command to build
the project, and the result is an SPA in `build/`:

```json
{
    "name": "frontend",
    "private": true,
    "version": "0.0.1",
    "type": "module",
    "scripts": {
        ...
        "build": "vite build",
        ...
    },
    "devDependencies": {
        ...
    }
}
```

```shell
npm run build
# ...
# ✓ built in 2.08s
# 
# Run npm run preview to preview your production build locally.
# 
# > Using @sveltejs/adapter-static
#   Wrote site to "build"
#   ✔ done

ls -l build
# drwxr-xr-x 3 thanh users 4096 May 30 16:45 _app
# -rw-r--r-- 1 thanh users 1571 May 30 16:45 favicon.png
# -rw-r--r-- 1 thanh users 1155 May 30 16:45 index.html
```

## Backend

Before we start the backend, we have to move the built frontend folder to the
backend to be served. We could do it manually with `cp`, but I found a more
elegant solution : symlink-ing. We don't have move the files "physically" as
they are accessible through the symlink:

```shell
# assume that we are in the backend folder
ln -sr ../frontend/build frontend-build
```

Now, the structure within the backend folder:

```
.
├── Cargo.lock
├── Cargo.toml
├── frontend-build -> ../frontend/build
├── moon.yml
└── src
    ├── frontend.rs
    └── main.rs
```

There isn't a lot to care about, except `frontend.rs`, where the "magic sauce"
is placed:

```rust
use axum::{
    http::{header, StatusCode, Uri},
    response::{Html, IntoResponse, Response},
};
use rust_embed::Embed;

static INDEX_HTML: &str = "index.html";

#[derive(Embed)]
#[folder = "frontend-build/"]
struct Assets;

pub async fn static_handler(uri: Uri) -> impl IntoResponse {
    let path = uri.path().trim_start_matches('/');

    if path.is_empty() || path == INDEX_HTML {
        return index_html().await;
    }

    match Assets::get(path) {
        Some(content) => {
            let mime = mime_guess::from_path(path).first_or_octet_stream();

            ([(header::CONTENT_TYPE, mime.as_ref())], content.data).into_response()
        }
        None => {
            if path.contains('.') {
                return not_found().await;
            }

            index_html().await
        }
    }
}

async fn index_html() -> Response {
    match Assets::get(INDEX_HTML) {
        Some(content) => Html(content.data).into_response(),
        None => not_found().await,
    }
}

async fn not_found() -> Response {
    (StatusCode::NOT_FOUND, "404").into_response()
}
```

The library we use is `rust-embed`, and in fact, I reused most of the library's
example code [^rust-embed-example-code]. The code in `main.rs` using Axum is
quite straightforward:

```rust
mod frontend;

use axum::{Router, routing::get};

#[tokio::main]
async fn main() {
    let app = Router::new()
        .route(
            "/api/data",
            get(async || {
                tokio::time::sleep(std::time::Duration::from_secs(3)).await;

                "text data after 3 seconds"
            }),
        )
        .fallback(frontend::static_handler);
    let listener = tokio::net::TcpListener::bind("127.0.0.1:3000")
        .await
        .unwrap();

    println!("Listening on http://127.0.0.1:3000");
    axum::serve(listener, app).await.unwrap();
}
```

For production deployment, `rust-embed` would automatically include static files
in the binary.

## Demonstration

We can start the backend and the frontend building process:

```shell
# assume that we moved to the root folder of the project
moon run backend:serve

# frontend's continuous must be in another shell
moon run frontend:serve
```

Here is a GIF to show you how would the end result look:

![](../images/rust-backend-spa-demo.gif)

## Conclusion

After this relatively short post, I hope I showed you how would serving an SPA
in Rust backend work. Again, you can try tweaking the code
[^example-rust-embed-sveltekit] yourself.

[^rediscovered]: Actually that's what meta-frameworks like NextJS and SvelteKit
    are doing if we use the "NodeJS output mode" from them.
[^simpler-code]: Digging deeper into this, it can be a trade-off between DX and
    complexity. In more details there are two approaches:

    - Try to keep the frontend as close to the "traditional" SPA approach as
      possible by still doing `npm run dev` and have `PUBLIC_BASE_URL`, and
      handle the deployment where we set `PUBLIC_BASE_URL` to empty, and let the
      fetches go to `window.origin`. The approach means DX goes up, and so does
      the complexity.

      ```ts
      import { PUBLIC_BASE_URL } from "$env/static/public";

      const baseUrl = PUBLIC_BASE_URL === ""
        ? window.origin
        : PUBLIC_BASE_URL;
      const url = new URL("/api/data", baseUrl)
      const resp = await fetch(url);
      ```

    - We just assume that the frontend is being served by the backend; there is
      no difference between the development environment and production
      environment. This approach means DX goes down a tiny bit, and complexity
      also goes down.

      ```ts
      const resp = await fetch("/api/data");
      ```
[^example-rust-embed-sveltekit]: The full code is available at:
    https://github.com/thanhnguyen2187/example-rust-embed-sveltekit
[^go-embed]: In fact, it's even easier to do this in Golang as it's a built-in
    functionality: https://pkg.go.dev/embed
[^rust-embed-example-code]: The author of `rust-embed` moved from GitHub to
    SourceHut, so it took me a while to dig the example out:
    https://git.sr.ht/~pyrossh/rust-embed/tree/master/item/examples/axum-spa/main.rs
