# Editor error-reporting fixtures

One schema, many broken configs — for end-to-end testing of how the editor
surfaces validation errors.

- `schema/mobility.cue` — deploy this once as the `mobility` config type.
- `configs/*.json` — paste one at a time into the editor's draft for that config
  type. Each isolates a single error class; a few deliberately stack errors.

Every expected error below was produced by running the fixture through
`core/pkg/schemas/cue` (the same validator the backend uses), so the message
text should match what the editor receives verbatim.

## Fixtures

| Fixture | Edit | Expected error |
| --- | --- | --- |
| `00-valid.json` | — | none; the baseline every other fixture is derived from |
| `01-enum-invalid.json` | `navigation_mode: "balance"` | `navigation_mode`: 3 errors in empty disjunction, one `conflicting values` line per enum member |
| `02-number-below-min.json` | `max_linear_speed_mps: 0.05` | `max_linear_speed_mps`: `invalid value 0.05 (out of bound >=0.1)` |
| `03-number-above-max.json` | `max_linear_speed_mps: 12.5` | `max_linear_speed_mps`: `invalid value 12.5 (out of bound <=5.0)` |
| `04-type-string-for-number.json` | `max_linear_speed_mps: "1.2"` | `mismatched types string and number` |
| `05-type-string-for-bool.json` | `obstacle_avoidance_enabled: "yes"` | `mismatched types string and bool` |
| `06-int-given-float.json` | `wheel_count: 4.5` | `mismatched types float and int` |
| `07-missing-required.json` | drop `operator_email` | `operator_email`: `incomplete value =~"..."` |
| `08-unknown-field.json` | add `turbo_mode` | `turbo_mode`: `field not allowed` |
| `09-regex-robot-id.json` | `robot_id: "Robot_1"` | `invalid value "Robot_1" (out of bound =~"^[a-z][a-z0-9-]{2,15}$")` |
| `10-regex-email.json` | `operator_email: "ops-at-miruml"` | `invalid value ... (out of bound =~"^[^@]+@[^@]+\.[a-z]{2,}$")` |
| `11-nested-out-of-range.json` | `telemetry.upload_interval_sec: 5` | path is reported as `telemetry.upload_interval_sec` |
| `12-nested-unknown-field.json` | typo `telemetry.upload_interval_secs` | `telemetry.upload_interval_secs`: `field not allowed` — note the *correct* key is now also missing, but only this error is reported |
| `13-deep-nested-enum.json` | `safety.estop.channels: ["hardware", "hardwire"]` | two params: `safety.estop.channels` and `safety.estop.channels.1` — tests indexed list paths three levels deep |
| `14-list-wrong-length.json` | `imu_offset_m: [0.0, 0.0]` | `incompatible list lengths (2 and 3)`, reported twice |
| `15-list-element-type.json` | `patrol_route: ["dock", 3, "aisle-2"]` | `mismatched types int and string` plus a confusing `incompatible list lengths (1 and 3)` from the default |
| `16-list-element-out-of-range.json` | `imu_offset_m[1] = -2.5` | two params: `imu_offset_m` and `imu_offset_m.1` |
| `17-null-value.json` | `obstacle_avoidance_enabled: null` | `mismatched types null and bool` |
| `18-many-errors.json` | 10 bad values across every section | **only `max_linear_speed_mps` is reported** — see aggregation note below |
| `19-root-not-object.json` | root is a JSON array | `[root]`: `mismatched types list and struct`, with the *entire schema* inlined in the message (very long single-line error — good stress test for the error panel) |
| `20-syntax-trailing-comma.json` | trailing comma | `[root]`: `failed to extract JSON instance content: ... invalid character '}'` |
| `21-syntax-unclosed-brace.json` | missing closing brace | `[root]`: `failed to extract JSON instance content: unexpected end of JSON input` |
| `22-empty-object.json` | `{}` | three params: `operator_email`, `safety.certification_id`, `site_id` — everything else is filled by defaults |
| `23-duplicate-keys.json` | `max_linear_speed_mps` twice | `[root]`: `failed to build JSON instance content: conflicting values 99.0 and 1.2` |
| `24-all-required-missing.json` | drop all three required fields | three `incomplete value` params at once — the most reliable multi-error fixture |
| `25-multiple-unknown-fields.json` | three unknown fields at three depths | only the first (`turbo_mode`) is reported |
| `26-mixed-missing-and-unknown.json` | unknown fields *and* missing required | only `turbo_mode` is reported; the missing-required errors are hidden behind it |

## Error classes covered

- Schema validation: bounds, type mismatches, enums, regex patterns, list
  lengths, list element constraints, unknown fields, missing required fields.
- Path shapes: root-level, nested (`telemetry.x`), twice-nested
  (`safety.estop.x`), list index (`imu_offset_m.1`), and `[root]`.
- Non-schema errors: malformed JSON, duplicate keys, wrong root type. These come
  back on the `[root]` path with no line/column the editor can anchor to, so
  they're the cases most likely to render badly.
- Error count: 0, 1, 3, and "should be 10 but only 1 arrives".

## Aggregation note (worth verifying in the UI)

The validator reports **all** errors only when they come from the final
concreteness check — that is, missing required fields (`22`, `24`). Anything
that fails during unification (bad values, type mismatches, unknown fields)
short-circuits on the first failure, so a config with ten mistakes usually
reports one. `18`, `25`, and `26` exist to pin that behavior down: the editor
should not imply the config is one fix away from valid, and re-validating after
each fix should keep surfacing new errors.

## Why this schema uses `close()`

Every struct is wrapped in `close()`. A bare struct literal is open in CUE and
Miru validates without forcing closedness, so the schemas in
`../cue/strict-schemas` accept unknown fields silently. Closing is what makes
`field not allowed` reachable.
