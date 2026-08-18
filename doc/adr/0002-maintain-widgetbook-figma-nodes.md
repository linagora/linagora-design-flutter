# 2. Maintain widgetbook/figma-nodes.yaml

Date: 2026-08-18

## Status

Accepted

## Context

`widgetbook/figma-nodes.yaml` maps each widget to its Figma component, so we don't have to re-find the link every time we check a widget against the design.

## Decision

Keep one file, `widgetbook/figma-nodes.yaml`, as the shared list of widget → Figma link. Anyone can edit it by hand.

Format:

```yaml
WidgetName: "https://www.figma.com/design/FILEKEY/FileName?node-id=123-456"
```

- **Key**: the widget's class name.
- **Value**: the Figma link, copied from "Copy link to selection" on the exact component (must contain `node-id=`, not a whole page/frame).
- Keep the list sorted A-Z.

### Add a widget

1. Select the component in Figma → Copy link.
2. Add a new line, keeping A-Z order.
3. Commit it with the PR that adds the widget.

### Update a widget

1. Confirm the new link opens the right component in Figma.
2. Replace the old line.
3. Commit with a short reason (e.g. "moved after redesign").

### Remove a widget

Delete its line when the widget is removed or renamed.

## Consequences

- One shared, correct link per widget — no re-asking "where's the Figma for this?".
- Nothing checks automatically if a link goes stale (component moved, renamed, deleted) — we only find out next time someone opens it.
