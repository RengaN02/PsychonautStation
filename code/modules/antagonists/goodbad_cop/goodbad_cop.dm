/datum/antagonist/cop
	name = "Cop"
	show_in_antagpanel = FALSE
	antagpanel_category = ANTAG_GROUP_CREW
	job_rank = ROLE_COP
	count_against_dynamic_roll_chance = FALSE
	hud_icon = 'icons/psychonaut/mob/huds/antag_hud.dmi'
	/// Brain trauma that gives the moods
	var/datum/brain_trauma/special/shareddelusion/trauma

	var/datum/team/cop_team/team

/datum/antagonist/cop/on_gain()
	objectives += team.objectives
	var/mob/living/carbon/C = owner.current
	trauma = C.gain_trauma(/datum/brain_trauma/special/shareddelusion)
	. = ..()
	team.update_members()

/datum/antagonist/cop/create_team(datum/team/cop_team/new_team)
	if(!new_team)
		return
	if(!istype(new_team))
		stack_trace("Wrong team type passed to [type] initialization.")
	team = new_team

/datum/antagonist/cop/get_team()
	return team

/datum/antagonist/cop/admin_add(datum/mind/new_owner,mob/admin)
	var/list/current_teams = list()
	for(var/datum/team/cop_team/T in GLOB.antagonist_teams)
		current_teams[T.name] = T
	var/choice = input(admin,"Add to which team ?") as null|anything in (current_teams + "new team")
	if (choice == "new team")
		team = new
	else if(choice in current_teams)
		team = current_teams[choice]
	else
		return
	new_owner.add_antag_datum(src)
	log_admin("[key_name(usr)] made [key_name(new_owner)] [name] on [choice]!")
	message_admins("[key_name_admin(usr)] made [key_name_admin(new_owner)] [name] on [choice] !")

/datum/antagonist/cop/good
	name = "Good Cop"
	antag_hud_name = "goodcop"
	show_in_antagpanel = TRUE

/datum/antagonist/cop/good/apply_innate_effects(mob/living/mob_override)
	var/mob/living/carbon/C = owner.current || mob_override
	ADD_TRAIT(C, TRAIT_EMPATH, COP_ROLE)
	add_team_hud(C, /datum/antagonist/cop)

/datum/antagonist/cop/good/remove_innate_effects(mob/living/mob_override)
	var/mob/living/carbon/C = owner.current || mob_override
	REMOVE_TRAIT(C, TRAIT_EMPATH, COP_ROLE)

/datum/antagonist/cop/bad
	name = "Bad Cop"
	antag_hud_name = "badcop"
	show_in_antagpanel = TRUE

/datum/antagonist/cop/bad/apply_innate_effects(mob/living/mob_override)
	var/mob/living/carbon/C = owner.current || mob_override
	ADD_TRAIT(C, TRAIT_NICE_SHOT, COP_ROLE)
	add_team_hud(C, /datum/antagonist/cop)

/datum/antagonist/cop/bad/remove_innate_effects(mob/living/mob_override)
	var/mob/living/carbon/C = owner.current || mob_override
	REMOVE_TRAIT(C, TRAIT_NICE_SHOT, COP_ROLE)

// Admin Only
/datum/antagonist/cop/goof
	name = "Goof Cop"
	antag_hud_name = "goofcop"
	show_in_antagpanel = TRUE

/datum/antagonist/cop/goof/apply_innate_effects(mob/living/mob_override)
	var/mob/living/carbon/C = owner.current || mob_override
	if(!istype(C))
		return
	C.dna.add_mutation(/datum/mutation/human/clumsy)
	add_team_hud(C, /datum/antagonist/cop)

/datum/antagonist/cop/goof/remove_innate_effects(mob/living/mob_override)
	var/mob/living/carbon/C = owner.current || mob_override
	if(!istype(C))
		return
	C.dna.remove_mutation(/datum/mutation/human/clumsy)

/datum/team/cop_team
	member_name = "Cop"
	show_roundend_report = FALSE
	var/team_number
	var/static/team_count = 1

/datum/team/cop_team/New()
	..()
	team_number = team_count++
	name = "Cop Team #[team_number]"

/datum/team/cop_team/remove_member(datum/mind/member)
	..()
	update_members()

/datum/team/cop_team/proc/get_member_mobs()
	. = list()
	for(var/datum/mind/mind in members)
		. += mind.current

/datum/team/cop_team/proc/update_members()
	var/list/member_mobs = get_member_mobs()
	for(var/datum/mind/mind in members)
		var/mob/living/carbon/C = mind.current
		if(!istype(C))
			continue

		var/datum/brain_trauma/special/shareddelusion/trauma = C.has_trauma_type(/datum/brain_trauma/special/shareddelusion)
		if(isnull(trauma))
			continue
		trauma.friends = member_mobs - C
		trauma.clear_moods()
