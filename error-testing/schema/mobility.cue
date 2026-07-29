// Schema used for end-to-end testing of editor error reporting.
//
// It intentionally packs one of every constraint kind we can express, so a
// single deployed schema can produce the full range of validation errors. See
// ../README.md for the config edits that exercise each one.
//
// Unlike the schemas in ../../cue/strict-schemas, every struct here is wrapped
// in close() so that unknown fields are rejected. A bare struct literal is open
// in CUE, and Miru validates without forcing closedness, so "field not allowed"
// errors only appear when the schema author opts in like this.

@miru(config_type="mobility",instance_filepath="/srv/miru/configs/mobility.json")
close({
	// Bounded floats.
	max_linear_speed_mps:    number & >=0.1 & <=5.0 | *1.2
	max_angular_speed_radps: number & >=0.1 & <=3.0 | *1.0

	// Bounded integer (rejects floats as well as out-of-range values).
	wheel_count: int & >=2 & <=8 | *4

	// Boolean.
	obstacle_avoidance_enabled: bool | *true

	// Enum / disjunction.
	navigation_mode: "conservative" | "balanced" | "aggressive" | *"balanced"

	// Strings with patterns.
	robot_id:         string & =~"^[a-z][a-z0-9-]{2,15}$" | *"robot-001"
	firmware_version: string & =~"^v[0-9]+\\.[0-9]+\\.[0-9]+$" | *"v1.0.0"

	// Required: no defaults, so omitting these leaves the config incomplete.
	operator_email: string & =~"^[^@]+@[^@]+\\.[a-z]{2,}$"
	site_id:        string & =~"^site-[0-9]{3}$"

	// Open list of strings.
	patrol_route: [...string] | *["dock"]

	// Fixed-length list with per-element bounds.
	imu_offset_m: [number & >=-1.0 & <=1.0, number & >=-1.0 & <=1.0, number & >=-1.0 & <=1.0] | *[0.0, 0.0, 0.1]

	// Nested object.
	telemetry: close({
		upload_interval_sec:    int & >=10 & <=300 | *60
		heartbeat_interval_sec: int & >=1 & <=60 | *10
		sink:                   "cloud" | "local" | "both" | *"cloud"
	})

	// Twice-nested object, plus a list of enum values.
	safety: close({
		max_payload_kg:    number & >0 & <=250 | *50
		certification_id:  string & =~"^ISO-[0-9]{4}$"

		estop: close({
			timeout_ms: int & >=10 & <=1000 | *100
			channels: [...("hardware" | "software" | "remote")] | *["hardware"]
		})
	})
})
