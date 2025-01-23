/turf/open/floor/iron/pool
	name = "pool floor"
	floor_tile = /obj/item/stack/tile/iron/pool
	icon = 'icons/psychonaut/turf/pool_tile.dmi'

	base_icon_state = "pool_tile"
	icon_state = "pool_tile"
	liquid_height = -30
	turf_height = -30

/turf/open/floor/iron/pool/rust_heretic_act()
	return

/turf/open/floor/iron/pool/cobble
	name = "cobblestone pool floor"
	base_icon_state = "cobble"
	icon_state = "cobble"
	footstep = FOOTSTEP_FLOOR
	barefootstep = FOOTSTEP_HARD_BAREFOOT
	clawfootstep = FOOTSTEP_HARD_CLAW
	heavyfootstep = FOOTSTEP_GENERIC_HEAVY

/turf/open/floor/iron/pool/cobble/side
	base_icon_state = "cobble_side"
	icon_state = "cobble_side"

/turf/open/floor/iron/pool/cobble/corner
	base_icon_state = "cobble_corner"
	icon_state = "cobble_corner"

/turf/open/floor/iron/elevated
	name = "elevated floor"
	floor_tile = /obj/item/stack/tile/iron/elevated
	icon = 'icons/psychonaut/turf/elevated_plasteel.dmi'
	icon_state = "elevated_plasteel-0"
	base_icon_state = "elevated_plasteel"
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = SMOOTH_GROUP_WALLS + SMOOTH_GROUP_CLOSED_TURFS + SMOOTH_GROUP_ELEVATED_PLASTEEL
	canSmoothWith = SMOOTH_GROUP_WALLS + SMOOTH_GROUP_ELEVATED_PLASTEEL
	liquid_height = 30
	turf_height = 30

/turf/open/floor/iron/elevated/rust_heretic_act()
	return

/turf/open/floor/iron/lowered
	name = "lowered floor"
	floor_tile = /obj/item/stack/tile/iron/lowered
	icon = 'icons/psychonaut/turf/lowered_plasteel.dmi'
	icon_state = "lowered_plasteel-0"
	base_icon_state = "lowered_plasteel"
	smoothing_flags = SMOOTH_BITMASK
	smoothing_groups = SMOOTH_GROUP_WALLS + SMOOTH_GROUP_CLOSED_TURFS + SMOOTH_GROUP_ELEVATED_PLASTEEL
	canSmoothWith = SMOOTH_GROUP_WALLS + SMOOTH_GROUP_ELEVATED_PLASTEEL
	liquid_height = -30
	turf_height = -30

/turf/open/floor/iron/lowered/rust_heretic_act()
	return
