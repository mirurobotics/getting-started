@miru(config_type="communication",instance_filepath="/srv/miru/configs/communication.json")
{
	control_loop_rate_hz: int & >=1 & <=1000 | *50
	watchdog_timeout_ms: int & >=100 & <=5000 | *500

	network: {
		max_latency_ms: int & >=10 & <=1000 | *100
		connection_timeout_ms: int & >=100 & <=10000 | *2000
		reconnect_attempts: int & >=1 & <=10 | *3
		reconnect_interval_ms: int & >=100 & <=5000 | *1000
		heartbeat_interval_ms: int & >=50 & <=1000 | *250
	}

	logging: {
		enable_packet_logging: bool | *true
		log_level: "debug" | "info" | "warn" | "error" | *"info"
		max_log_size_mb: int & >=1 & <=1024 | *100
		retain_logs_days: int & >=1 & <=90 | *30
	}

	error_handling: {
		max_consecutive_failures: int & >=1 & <=20 | *5
		failure_timeout_ms: int & >=100 & <=30000 | *5000
		enable_auto_recovery: bool | *true
	}
}
