This is an example that uses the API at https://sup2.playplay.io.

![](mcp.gif)

Enable API access with `set api on` and obtain a token with `set api token`. The bot will give you a full URL to your team's API. Check that it works.

```bash
export TOKEN=...
curl --silent -H "X-Access-Token:$TOKEN" https://sup2.playplay.io/api/teams/1234ac95d758400015faecf | jq
```

```json
{
  "id": "1234ac95d758400015faecf",
  "team_id": "T04123456",
  "name": "dblock",
  "active": true,
  "subscribed": true,
  "created_at": "2023-03-15T22:46:33.517Z",
  "updated_at": "2025-09-10T14:17:18.698Z",
  "_links": {
    "channels": {
      "href": "https://sup2.playplay.io/api/channels?team_id=1234ac95d758400015faecf"
    },
    "stats": {
      "href": "https://sup2.playplay.io/api/stats?team_id=1234ac95d758400015faecf"
    },
    "self": {
      "href": "https://sup2.playplay.io/api/teams/1234ac95d758400015faecf"
    }
  }
}
```

Try this.

```bash
bundle exec ruby hal.rb

Bot is away.
Team name is dblock.
```

Now, let's do this via mcp.

```bash
bundle install
bundle exec ruby mcp.rb
```

If you go to http://127.0.0.1:4567 you should see "Hello World!".

Try `npx @modelcontextprotocol/inspector`.

Connect to http://127.0.0.1:4567/mcp/sse.

List templated resources, try getting your team by ID.

Add to Claude.

```bash
claude mcp add --transport sse local http://127.0.0.1:4567/mcp/sse
```

Check that the mcp is running.

```bash
$ claude mcp list
Checking MCP server health...

local: http://127.0.0.1:4567/mcp/sse (SSE) - ✓ Connected
```

```
> use "local" mcp to get info about team id 12344ac95d758400015faecf

⏺ I'll use the local MCP to get information about team id 12344ac95d758400015faecf.

⏺ listMcpResources(List MCP resources from server "local")
  ⎿  [                             
       {
         "name": "root",
     … +23 lines (ctrl+r to expand)

⏺ Let me check the root resource to understand the API structure and then look for team information:

⏺ readMcpResource(Read resource "api://" from server "local")
  ⎿  {                            
       "contents": [
         {
     … +6 lines (ctrl+r to expand)

⏺ The root resource is empty. Let me try to find team resources by checking if there's a teams endpoint:

⏺ readMcpResource(Read resource "api:///teams/12344ac95d758400015faecf" from server "local")
  ⎿  {                            
       "contents": [
         {
     … +7 lines (ctrl+r to expand)

⏺ Found the team information:

  {
    "id": "12344ac95d758400015faecf",
    "team_id": "T04KB5WQH",
    "name": "dblock",
    "active": true,
    "subscribed": true,
    "created_at": "2023-03-15T22:46:33.517Z",
    "updated_at": "2025-09-10T14:17:18.698Z"
  }

```

