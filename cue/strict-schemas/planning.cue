@miru(config_type="planning",instance_filepath="planning.json")
{
	planning_frequency_hz: number & >=1.0 & <=100.0 | *20.0
	control_frequency_hz: number & >=10.0 & <=200.0 | *50.0
	planning_timeout_s: number & >=0.1 & <=5.0 | *1.0

	path_following: {
		lookahead_distance_m: number & >=0.1 & <=2.0 | *0.3
		lookahead_time_s: number & >=0.1 & <=2.0 | *0.5
		path_tolerance_m: number & >=0.01 & <=0.5 | *0.05
		goal_tolerance_m: number & >=0.01 & <=0.5 | *0.1
		heading_tolerance_rad: number & >=0.01 & <=0.5 | *0.05
		min_lookahead_distance_m: number & >=0.05 & <=1.0 | *0.1
		max_lookahead_distance_m: number & >=0.2 & <=5.0 | *0.5
	}

	trajectory: {
		max_path_velocity_mps: number & >=0.2 & <=5.0 | *1.5
		min_path_velocity_mps: number & >=0.05 & <=0.5 | *0.1
		path_acceleration_mps2: number & >=0.1 & <=3.0 | *1.0
		path_deceleration_mps2: number & >=0.1 & <=4.0 | *1.2
		max_centripetal_acceleration_mps2: number & >=0.1 & <=2.0 | *0.5
		path_jerk_mps3: number & >=0.1 & <=5.0 | *0.5
	}

	local_planner: {
		min_samples: int & >=5 & <=100 | *10
		max_samples: int & >=10 & <=500 | *50
		sampling_time_s: number & >=0.1 & <=2.0 | *0.8
		resolution_m: number & >=0.01 & <=0.5 | *0.05
		horizon_m: number & >=0.5 & <=10.0 | *2.0
	}

	global_planner: {
		grid_resolution_m: number & >=0.01 & <=0.5 | *0.1
		inflation_radius_m: number & >=0.1 & <=2.0 | *0.5
		cost_scaling_factor: number & >=0.1 & <=10.0 | *2.0
		lethal_cost_value: int & >=100 & <=255 | *253
		neutral_cost_value: int & >=0 & <=100 | *50
	}

	obstacle_avoidance: {
		min_obstacle_distance_m: number & >=0.1 & <=1.0 | *0.5
		max_obstacle_distance_m: number & >=0.5 & <=5.0 | *2.0
		obstacle_inflation_m: number & >=0.05 & <=1.0 | *0.2
		dynamic_obstacle_velocity_threshold_mps: number & >=0.05 & <=2.0 | *0.2
	}

	smoothing: {
		curve_weight: number & >=0.0 & <=1.0 | *0.3
		smooth_weight: number & >=0.0 & <=1.0 | *0.3
		tolerance: number & >=0.0001 & <=0.1 | *0.01
		max_iterations: int & >=5 & <=1000 | *10
	}

	recovery: {
		enable_backoff: bool | *true
		backoff_distance_m: number & >=0.1 & <=2.0 | *0.3
		enable_rotation_in_place: bool | *true
		max_rotation_angle_rad: number & >=0.1 & <=6.28318 | *1.57
		clear_costmap_before_recovery: bool | *true
	}
}
