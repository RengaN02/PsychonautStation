/mob/living/basic/headcrab
	name = "Headcrab"
	desc = "It can hug."
	icon = 'icons/psychonaut/mob/nonhuman-player/headcrab.dmi'
	icon_state = "headcrab"
	icon_living = "headcrab"
	icon_dead = "headcrab_dead"
	health = 10
	maxHealth = 10
	melee_attack_cooldown = 1.5 SECONDS
	melee_damage_lower = 0
	melee_damage_upper = 0
	attack_verb_continuous = "bites"
	attack_verb_simple = "bite"
	attack_sound = 'sound/items/weapons/bite.ogg'
	combat_mode = FALSE
	faction = list(FACTION_ZOMBIE)
	pressure_resistance = 200
	ai_controller = /datum/ai_controller/basic_controller/headcrab
	var/obj/item/organ/headcrab/hctype = /obj/item/organ/headcrab/default
	var/crabbed_someone = FALSE
	var/datum/action/cooldown/mob_cooldown/headcrab_jump/hcjump

/mob/living/basic/headcrab/Initialize(mapload)
	. = ..()
	hcjump = new(src)
	hcjump.Grant(src)

/mob/living/basic/headcrab/Destroy()
	hcjump = null
	return ..()

/mob/living/basic/headcrab/throw_impact(atom/hit_atom, datum/thrownthing/throwingdatum)
	. = ..()
	if(stat == DEAD)
		icon_state = initial(icon_dead)
	else
		icon_state = initial(icon_living)
	if(. || !ishuman(hit_atom))
		return
	var/mob/living/carbon/human/hit_human = hit_atom
	if(hit_human.get_organ_by_type(/obj/item/organ/headcrab))
		return
	var/obj/item/organ/headcrab/hcorgan = new hctype()
	hcorgan.hc = src
	hcorgan.Insert(hit_human)
	forceMove(hcorgan)
	visible_message(span_danger("\The [src] jumps to the [hit_human]s face!"))

/mob/living/basic/headcrab/throw_at(atom/target, range, speed, mob/thrower, spin=FALSE, diagonals_first = FALSE, datum/callback/callback, force = MOVE_FORCE_NORMAL, gentle, quickstart = TRUE)
	if(stat != DEAD)
		icon_state = "headcrab_jump"
	return ..(target, range, speed, thrower, FALSE, diagonals_first, callback, force, gentle, quickstart = quickstart)

// MOB END
// AI START

/datum/ai_controller/basic_controller/headcrab
	blackboard = list(
		BB_TARGETING_STRATEGY = /datum/targeting_strategy/basic,
	)

	ai_movement = /datum/ai_movement/basic_avoidance
	idle_behavior = /datum/idle_behavior/idle_random_walk
	planning_subtrees = list(
		/datum/ai_planning_subtree/simple_find_target,
		/datum/ai_planning_subtree/headcrab_jump
	)

/datum/ai_planning_subtree/headcrab_jump
	var/datum/ai_behavior/headcrab_jump/hcjump = /datum/ai_behavior/headcrab_jump

/datum/ai_planning_subtree/headcrab_jump/SelectBehaviors(datum/ai_controller/controller, seconds_per_tick)
	. = ..()
	if(!controller.blackboard_key_exists(BB_BASIC_MOB_CURRENT_TARGET))
		return
	controller.queue_behavior(hcjump, BB_BASIC_MOB_CURRENT_TARGET, BB_TARGETING_STRATEGY, BB_BASIC_MOB_CURRENT_TARGET_HIDING_LOCATION)
	return SUBTREE_RETURN_FINISH_PLANNING //we are going into battle...no distractions.

/datum/ai_behavior/headcrab_jump
	action_cooldown = 1 SECONDS
	behavior_flags = AI_BEHAVIOR_REQUIRE_MOVEMENT | AI_BEHAVIOR_MOVE_AND_PERFORM
	/// range we will try chasing the target before giving up
	var/jump_range = 7
	///do we care about avoiding friendly fire?
	var/avoid_friendly_fire =  TRUE

/datum/ai_behavior/headcrab_jump/setup(datum/ai_controller/controller, target_key, targeting_strategy_key, hiding_location_key)
	. = ..()
	if(HAS_TRAIT(controller.pawn, TRAIT_HANDS_BLOCKED))
		return FALSE
	var/atom/target = controller.blackboard[hiding_location_key] || controller.blackboard[target_key]
	if(QDELETED(target))
		return FALSE
	set_movement_target(controller, target)

/datum/ai_behavior/headcrab_jump/perform(seconds_per_tick, datum/ai_controller/controller, target_key, targeting_strategy_key, hiding_location_key)
	var/mob/living/basic/basic_mob = controller.pawn
	//targeting strategy will kill the action if not real anymore
	var/atom/target = controller.blackboard[target_key]
	var/datum/targeting_strategy/targeting_strategy = GET_TARGETING_STRATEGY(controller.blackboard[targeting_strategy_key])
	var/mob/living/basic/headcrab/hc = basic_mob

	if(!istype(hc))
		return

	if(!ishuman(target))
		finish_action(controller, FALSE, target_key)
		return

	var/mob/living/carbon/human/ht = target
	if(!targeting_strategy.can_attack(basic_mob, target, jump_range))
		finish_action(controller, FALSE, target_key)
		return

	if(!can_see(basic_mob, target, jump_range))
		return

	if(ht.get_organ_by_type(/obj/item/organ/headcrab))
		return

	if(hc.crabbed_someone)
		return

	if(avoid_friendly_fire && check_friendly_in_path(basic_mob, target, targeting_strategy))
		adjust_position(basic_mob, target)
		return ..()

	if(!hc.hcjump.IsAvailable())
		return

	hc.hcjump.Activate(target)
	return ..() //only start the cooldown when the shot is shot

/datum/ai_behavior/headcrab_jump/finish_action(datum/ai_controller/controller, succeeded, target_key, targeting_strategy_key, hiding_location_key)
	. = ..()
	if(!succeeded)
		controller.clear_blackboard_key(target_key)

/datum/ai_behavior/headcrab_jump/proc/check_friendly_in_path(mob/living/source, atom/target, datum/targeting_strategy/targeting_strategy)
	var/list/turfs_list = calculate_trajectory(source, target)
	for(var/turf/possible_turf as anything in turfs_list)

		for(var/mob/living/potential_friend in possible_turf)
			if(!targeting_strategy.can_attack(source, potential_friend))
				return TRUE

	return FALSE

/datum/ai_behavior/headcrab_jump/proc/adjust_position(mob/living/living_pawn, atom/target)
	var/turf/our_turf = get_turf(living_pawn)
	var/list/possible_turfs = list()

	for(var/direction in GLOB.alldirs)
		var/turf/target_turf = get_step(our_turf, direction)
		if(isnull(target_turf))
			continue
		if(target_turf.is_blocked_turf() || get_dist(target_turf, target) > get_dist(living_pawn, target))
			continue
		possible_turfs += target_turf

	if(!length(possible_turfs))
		return
	var/turf/picked_turf = get_closest_atom(/turf, possible_turfs, target)
	step(living_pawn, get_dir(living_pawn, picked_turf))

/datum/ai_behavior/headcrab_jump/proc/calculate_trajectory(mob/living/source , atom/target)
	var/list/turf_list = get_line(source, target)
	var/list_length = length(turf_list) - 1
	for(var/i in 1 to list_length)
		var/turf/current_turf = turf_list[i]
		var/turf/next_turf = turf_list[i+1]
		var/direction_to_turf = get_dir(current_turf, next_turf)
		if(!ISDIAGONALDIR(direction_to_turf))
			continue

		for(var/cardinal_direction in GLOB.cardinals)
			if(cardinal_direction & direction_to_turf)
				turf_list += get_step(current_turf, cardinal_direction)

	turf_list -= get_turf(source)
	turf_list -= get_turf(target)

	return turf_list

/datum/action/cooldown/mob_cooldown/headcrab_jump
	name = "Jump"
	button_icon = 'icons/mob/actions/actions_items.dmi'
	button_icon_state = "sniper_zoom"
	desc = "Allows you to jump towards a position."
	cooldown_time = 3 SECONDS

/datum/action/cooldown/mob_cooldown/headcrab_jump/Activate(atom/target_atom)
	disable_cooldown_actions()
	jump_to(target_atom)
	StartCooldown()
	enable_cooldown_actions()
	return TRUE

/datum/action/cooldown/mob_cooldown/headcrab_jump/proc/jump_to(atom/target_atom)
	var/mob/living/basic/headcrab/hc = owner
	if(!istype(hc))
		return
	if(ismob(target_atom))
		if(hc.faction_check_atom(target_atom, FALSE))
			return
	if(hc.crabbed_someone)
		return
	var/turf/target_turf = get_turf(target_atom)
	target_turf.color = sanitize_hexcolor("[pick("7F", "FF")][pick("7F", "FF")][pick("7F", "FF")]")

	hc.Shake(duration = 8 DECISECONDS)
	ADD_TRAIT(hc, TRAIT_IMMOBILIZED, REF(src))

	sleep(4 DECISECONDS)
	target_turf.color = null
	target_turf = get_turf(target_atom)
	target_turf.color = sanitize_hexcolor("[pick("7F", "FF")][pick("7F", "FF")][pick("7F", "FF")]")
	sleep(4 DECISECONDS)

	REMOVE_TRAIT(hc, TRAIT_IMMOBILIZED, REF(src))
	target_turf.color = null
	hc.throw_at(target_turf, 6, 2, hc)
