/datum/antagonist/cop
	name = "Cop"
	show_in_antagpanel = FALSE
	antagpanel_category = ANTAG_GROUP_CREW
	job_rank = ROLE_COP
	count_against_dynamic_roll_chance = FALSE
	/// Brain trauma that gives the moods
	var/datum/brain_trauma/special/shareddelusion/trauma

	var/datum/team/cop_team/team

/datum/antagonist/cop/on_gain()
	objectives += team.objectives
	var/mob/living/carbon/C = owner.current
	trauma = C.gain_trauma(/datum/brain_trauma/special/shareddelusion)
	return ..()

/datum/antagonist/cop/get_preview_icon()
	var/mob/living/carbon/human/dummy/consistent/goodcop = new
	var/mob/living/carbon/human/dummy/consistent/badcop = new

	var/icon/goodcop_icon = render_preview_outfit(/datum/outfit/job/security, goodcop)
	goodcop_icon.Shift(WEST, 8)

	var/icon/badcop_icon = render_preview_outfit(/datum/outfit/job/security, badcop)
	badcop_icon.Shift(EAST, 8)

	var/icon/final_icon = goodcop_icon
	final_icon.Blend(badcop_icon, ICON_OVERLAY)

	qdel(goodcop)
	qdel(badcop)

	return finish_preview_icon(final_icon)

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
	show_in_antagpanel = TRUE

/datum/antagonist/cop/good/apply_innate_effects(mob/living/mob_override)
	var/mob/living/subject = owner.current || mob_override
	ADD_TRAIT(subject, TRAIT_EMPATH, COP_ROLE)

/datum/antagonist/cop/good/remove_innate_effects(mob/living/mob_override)
	var/mob/living/subject = owner.current || mob_override
	REMOVE_TRAIT(subject, TRAIT_EMPATH, COP_ROLE)

/datum/antagonist/cop/bad
	name = "Bad Cop"
	show_in_antagpanel = TRUE

/datum/antagonist/cop/bad/apply_innate_effects(mob/living/mob_override)
	var/mob/living/subject = owner.current || mob_override
	ADD_TRAIT(subject, TRAIT_NICE_SHOT, COP_ROLE)

/datum/antagonist/cop/bad/remove_innate_effects(mob/living/mob_override)
	var/mob/living/subject = owner.current || mob_override
	REMOVE_TRAIT(subject, TRAIT_NICE_SHOT, COP_ROLE)

/datum/team/cop_team
	name = "Good Cop / Bad Cop"
	member_name = "Cop"
	show_roundend_report = FALSE

/datum/team/cop_team/add_member(datum/mind/new_member)
	..()
	update_members()

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
