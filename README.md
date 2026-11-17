# Firelight.Html

A collection of expressive, type-safe DSLs for building UI with **Firelight**.

### Related Projects
- **Fable.Lit.Dsl** - Project this project is based on: https://github.com/JordanMarr/Fable.Lit.Dsl
---

## Installation

Add the packages to your project:

```bash
dotnet add package DavidWhelan.Firelight.Html
```
---

# HTML DSL

The HTML DSL provides a natural, structured way to write Lit templates in F# without stringly-typed markup.

### Example

```fsharp
open Firelight.Html

view {
    h1 { "Hello, world!" }

    p { "This is the Fable.Lit HTML DSL." }

    button {
        disabled false
        onClick (fun _ -> dispatch Increment)
        "Click me"
    }
}
```

### Builders

- `view { }` - Use at the top level of components. Returns a `TemplateResult` for rendering.
- `template { }` - Use for nested fragments inside elements. Returns a `Node`.
- `el "tag-name" { }` - Create custom elements with any tag name.

### Custom Elements with `el`

Use `el` for one-off custom elements or web components:

```fsharp
view {
    el "my-custom-element" {
        attr "theme" "dark"
        prop "config" {| rows = 10; cols = 5 |}
        boolAttr "enabled" true
        on "custom-event" (fun e -> dispatch (CustomEvent e))
        "Child content"
    }
}
```

Available attribute helpers:
- `attr "name" value` - String attribute
- `boolAttr "name" true` - Boolean attribute (present when true, absent when false)
- `prop "name" value` - JavaScript property (for complex values or web component properties)
- `on "event-name" handler` - Event handler

### Fragments with `template`

Use `template` when you need to return multiple sibling elements *without* a wrapper element. This is similar to React fragments (`<>...</>`).

```fsharp
/// Returns multiple elements without a wrapper div
let userInfo (user: User) =
    template {
        dt { "Name" }
        dd { user.Name }
        dt { "Email" }
        dd { user.Email }
    }

let mainView model =
    view {
        h1 { "User Details" }
        dl {
            // Inserts dt/dd pairs directly into the dl, no wrapper element
            userInfo model.User
        }
    }
```

In most cases, wrapping content in a `div` is fine. Use `template` only when an extra wrapper element would break your HTML structure or CSS styling (like inside `<dl>`, `<table>`, `<ul>`, or flex/grid containers where extra elements affect layout).

### Highlights

- Strongly-typed attributes and events
- Natural F# computation expression syntax
- No raw HTML strings
- Works seamlessly with Lit components and custom elements

---

# More Examples

### Conditional Rendering

```fsharp
view {
    h2 { "Dashboard" }

    if model.IsLoading then
        div {
            p { "Loading" }
        }
    else
        div {
            p { $"Welcome, {model.Username}!" }
        }
}
```

### Lists

```fsharp
view {
    ul {
        for item in model.Items do
            li { item.Name }
    }
}
```

A `for` loop renders as a single list that Lit updates by position, so the surrounding element (with its scroll position, focus, and running animations) is kept when items are added or removed.
When items are inserted, removed, or reordered in the middle of a list, use `forKeyed` so each item's DOM follows its key:

```fsharp
view {
    ul {
        forKeyed (fun (m: Message) -> m.Id) model.Messages (fun m ->
            li { m.Text })
    }
}
```

### Using Refs

```fsharp
let inputRef = ref Unchecked.defaultof<Browser.Types.HTMLInputElement>

view {
    input {
        bindRef (fun el -> inputRef.Value <- el :?> _)
        label' "Focus me"
    }

    button {
        onClick (fun _ -> inputRef.Value.focus())
        "Focus Input"
    }
}
```
