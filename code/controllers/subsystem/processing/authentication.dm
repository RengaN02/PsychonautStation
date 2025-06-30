PROCESSING_SUBSYSTEM_DEF(authentication)
	name = "Authentication"
	flags = SS_NO_INIT | SS_BACKGROUND | SS_KEEP_TIMING
	wait = 5 SECONDS
	runlevels = RUNLEVEL_LOBBY | RUNLEVELS_DEFAULT
