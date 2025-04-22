#define JOB_DEFAULT "Default"

SUBSYSTEM_DEF(traitor)
	name = "Traitor"
	dependencies = list(
		/datum/controller/subsystem/mapping,
		/datum/controller/subsystem/atoms,
		/datum/controller/subsystem/job
	)
	flags = SS_KEEP_TIMING
	wait = 10 SECONDS
	runlevels = RUNLEVEL_GAME | RUNLEVEL_POSTGAME

	/// A list of all uplink items mapped by type
	var/list/uplink_items_by_type = list()
	/// A list of all uplink items
	var/list/uplink_items = list()

	/// The coefficient multiplied by the current_global_progression for new joining traitors to calculate their progression
	var/newjoin_progression_coeff = 1
	/// The current progression that all traitors should be at in the round, you can't have less than this
	var/current_global_progression = 0
	/// The current uplink handlers being managed
	var/list/datum/uplink_handler/uplink_handlers = list()
	/// The current scaling per minute of progression.
	var/current_progression_scaling = 1 MINUTES
	/// List of jobs with weighted prime objectives
	var/list/prime_objectives_by_job = list()

/datum/controller/subsystem/traitor/Initialize()
	current_progression_scaling = 1 MINUTES * CONFIG_GET(number/traitor_scaling_multiplier)
	for(var/theft_item in subtypesof(/datum/objective_item/steal))
		new theft_item
	generate_prime_objective_list()
	return SS_INIT_SUCCESS

/datum/controller/subsystem/traitor/fire(resumed)
	var/previous_progression = current_global_progression
	current_global_progression = (STATION_TIME_PASSED()) * CONFIG_GET(number/traitor_scaling_multiplier)
	var/progression_increment = current_global_progression - previous_progression

	for(var/datum/uplink_handler/handler in uplink_handlers)
		if(!handler.has_progression || QDELETED(handler))
			uplink_handlers -= handler
		if(handler.progression_points < current_global_progression)
			// If we got unsynced somehow, just set them to the current global progression
			// Prevents problems with precision errors.
			handler.progression_points = current_global_progression
		else
			handler.progression_points += progression_increment // Should only really happen if an admin is messing with an individual's progression value
		handler.on_update()

/datum/controller/subsystem/traitor/proc/register_uplink_handler(datum/uplink_handler/uplink_handler)
	if(!uplink_handler.has_progression)
		return
	uplink_handlers |= uplink_handler
	// An uplink handler can be registered multiple times if they get assigned to new uplinks, so
	// override is set to TRUE here because it is intentional that they could get added multiple times.
	RegisterSignal(uplink_handler, COMSIG_QDELETING, PROC_REF(uplink_handler_deleted), override = TRUE)

/datum/controller/subsystem/traitor/proc/uplink_handler_deleted(datum/uplink_handler/uplink_handler)
	SIGNAL_HANDLER
	uplink_handlers -= uplink_handler

/datum/controller/subsystem/traitor/proc/generate_prime_objective_list(datum/uplink_handler/uplink_handler)
	for(var/objective_type as anything in subtypesof(/datum/objective/prime))
		var/datum/objective/prime/objective = new objective_type //Initializing the objective datum bcs we cant get job_weights list from an unreal datum
		// The loop creates a weighted list of prime objectives for each job
		for(var/job in objective.job_weights)
			if(!prime_objectives_by_job[job])
				prime_objectives_by_job[job] = list() // Create a list
			prime_objectives_by_job[job][objective_type] = objective.job_weights[job]

		if(!prime_objectives_by_job[JOB_DEFAULT])
			prime_objectives_by_job[JOB_DEFAULT] = list() // Create a list

		prime_objectives_by_job[JOB_DEFAULT][objective_type] = objective.default_weight // Add the default value's of objectives to the list

		qdel(objective)

	// Adds objectives with default weights to jobs in the prime_objectives_by_job list that do not already have those objectives
	for(var/job in prime_objectives_by_job)
		for(var/datum/objective/prime/objective_type as anything in subtypesof(/datum/objective/prime))
			if(!prime_objectives_by_job[job][objective_type])
				prime_objectives_by_job[job][objective_type] = objective_type::default_weight

#undef JOB_DEFAULT
