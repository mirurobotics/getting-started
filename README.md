# Miru getting started

Example config schemas for the [Miru quick start](https://docs.mirurobotics.com/getting-started/quick-start/overview).

Each schema sets the file path where the Miru Agent writes its config instance on the device. A release can only be deployed to devices running the operating system its file paths target, so pick the folder that matches your device:

| Device OS | Config instance location | Folder |
|-----------|--------------------------|--------|
| Linux | `/srv/miru/configs/` | [`linux/`](linux) |
| Windows | `C:\ProgramData\Miru\configs\` | [`windows/`](windows) |

Each folder holds the same schemas in two languages, [JSON Schema](https://docs.mirurobotics.com/cfg-mgmt/concepts/schemas/languages/jsonschema) and [CUE](https://docs.mirurobotics.com/cfg-mgmt/concepts/schemas/languages/cue), in two variants:

- `empty-schemas`: accept any config instance.
- `strict-schemas`: constrain the fields, types, and values of each config instance.

Create a release from the root of this repository, for example:

```bash
miru release create --version v1.0.0 --schemas ./linux/jsonschema/empty-schemas/
```
