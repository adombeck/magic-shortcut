# Magic Shortcut

Do something useful with the clipboard content like opening URLs in the browser
or jumping to a file/line in an editor.

Supports custom handlers with the protocol described below.

## Installation

Clone this repository and run `install.sh` to install Magic Shortcut and the
default handlers.

Then create a keyboard shortcut to run `magic-shortcut` (e.g. Ctrl+Shift+Q).

### Dependencies

- `jq` (for JSON output in shell handlers)
- `wl-clipboard` (for clipboard access on Wayland)
- `python3` and `python3-gi` (for notifications)

## Handler Protocol

Handler scripts process clipboard content and return JSON instructions for Magic
Shortcut.

Each handler should:
1. Read clipboard content from stdin
2. Determine if it can handle the content
3. Either perform an action directly or choose an action for Magic Shortcut to
   perform
4. Output a JSON response with the handling result and any instructions for
   Magic Shortcut
5. Exit without any output if it cannot handle the content

### JSON Response Format

When a handler can handle the clipboard content, it should output a JSON object
with:

```json
{
    "handled": true,
    "message": {
        "title": "Notification Title",
        "body": "Notification body text"
    },
    "action": "open_url | open_file",
    "url": "URL to open (for open_url action)",
    "path": "File path to open (for open_file action)",
    "line_number": 123
}
```

#### Fields:

- `handled` (boolean, required): Should be `true` when handler handles the content
- `message` (object, required): Notification message with `title` and `body` fields
  - `title` (string): Notification title
  - `body` (string): Notification body text
- `action` (string, optional): Action to perform - either `"open_url"` or `"open_file"`. 
  If omitted, the handler is expected to have already handled the content itself.
- `url` (string, optional): URL to open in browser (when action is `"open_url"`)
- `path` (string, optional): File path to open (when action is `"open_file"`)
- `line_number` (integer, optional): Line number to jump to (when action is `"open_file"`)

## Default Handlers

Handlers are installed to `~/.config/magic-shortcut/handlers`.

The default handlers:
* Open HTTP/HTTPS URLs in the default browser.
* Open file paths with optional line numbers in the default editor.
* Extracts file paths and (if applicable) line numbers to open from:
  * Python stacktraces in the format `File "path/to/file.py", line 123`
  * Ruby stacktraces in the format `path/to/file.rb:123:in 'method_name'`
  * Git diff paths in the format `a/path/to/file` or `b/path/to/file`

## Creating Custom Handlers

To create a custom handler:

1. Create an executable script in `~/.config/magic-shortcut/handlers` (e.g., `99-custom.sh`)
2. Implement the handler protocol

Handlers are executed in alphabetical order by filename. The first handler that
handles the clipboard content stops the execution of subsequent handlers.
