This is an example that uses https://github.com/ruby-grape/grape-with-roar.

Start the server.

```bash
git clone git@github.com:ruby-grape/grape-with-roar.git
cd grape-with-roar
bundle install
rackup
```

You should see this. Open a browser on http://127.0.0.1:9292 to see a page.

```
* Listening on http://127.0.0.1:9292
```

Run the mcp server. Going to http://localhost:8000 should say "Hello World".

```
bundle install
rackup -p 8000
```

Try `npx @modelcontextprotocol/inspector`.

Connect to http://127.0.0.1:8000/mcp/sse.

List resources, get a templated spline with any UUID.

