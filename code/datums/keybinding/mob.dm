/datum/keybinding/mob
	category = CATEGORY_HUMAN
	weight = WEIGHT_MOB

/datum/keybinding/mob/stop_pulling
	hotkey_keys = list("H", "Delete")
	name = "stop_pulling"
	full_name = "Stop pulling"
	description = ""
	keybind_signal = COMSIG_KB_MOB_STOPPULLING_DOWN

/datum/keybinding/mob/stop_pulling/down(client/user, turf/target)
	. = ..()
	if(.)
		return
	var/mob/M = user.mob
	if(!M.pulling)
		to_chat(user, span_notice("You are not pulling anything."))
	else
		M.stop_pulling()
	return TRUE

/datum/keybinding/mob/swap_hands
	hotkey_keys = list("X")
	name = "swap_hands"
	full_name = "Swap hands"
	description = ""
	keybind_signal = COMSIG_KB_MOB_SWAPHANDS_DOWN

/datum/keybinding/mob/swap_hands/down(client/user, turf/target)
	. = ..()
	if(.)
		return
	var/mob/M = user.mob
	M.swap_hand()
	return TRUE

/datum/keybinding/mob/activate_inhand
	hotkey_keys = list("Z")
	name = "activate_inhand"
	full_name = "Activate in-hand"
	description = "Uses whatever item you have inhand"
	keybind_signal = COMSIG_KB_MOB_ACTIVATEINHAND_DOWN

/datum/keybinding/mob/activate_inhand/down(client/user, turf/target)
	. = ..()
	if(.)
		return
	var/mob/M = user.mob
	M.mode()
	return TRUE

/datum/keybinding/mob/drop_item
	hotkey_keys = list("Q")
	name = "drop_item"
	full_name = "Drop Item"
	description = ""
	keybind_signal = COMSIG_KB_MOB_DROPITEM_DOWN

/datum/keybinding/mob/drop_item/down(client/user, turf/target)
	. = ..()
	if(.)
		return
	if(iscyborg(user.mob)) //cyborgs can't drop items
		return FALSE
	var/mob/M = user.mob
	var/obj/item/I = M.get_active_held_item()
	if(!I)
		to_chat(user, span_warning("You have nothing to drop in your hand!"))
	else
		user.mob.dropItemToGround(I)
	return TRUE

/datum/keybinding/mob/target/down(client/user, turf/target)
	. = ..()
	if(.)
		return .

	var/original = user.mob.zone_selected
	switch(keybind_signal)
		if(COMSIG_KB_MOB_TARGETCYCLEHEAD_DOWN)
			user.body_toggle_head()
		if(COMSIG_KB_MOB_TARGETHEAD_DOWN)
			user.body_head()
		if(COMSIG_KB_MOB_TARGETEYES_DOWN)
			user.body_eyes()
		if(COMSIG_KB_MOB_TARGETMOUTH_DOWN)
			user.body_mouth()
		if(COMSIG_KB_MOB_TARGETRIGHTARM_DOWN)
			user.body_r_arm()
		if(COMSIG_KB_MOB_TARGETBODYCHEST_DOWN)
			user.body_chest()
		if(COMSIG_KB_MOB_TARGETLEFTARM_DOWN)
			user.body_l_arm()
		if(COMSIG_KB_MOB_TARGETRIGHTLEG_DOWN)
			user.body_r_leg()
		if(COMSIG_KB_MOB_TARGETBODYGROIN_DOWN)
			user.body_groin()
		if(COMSIG_KB_MOB_TARGETLEFTLEG_DOWN)
			user.body_l_leg()
		else
			stack_trace("Target keybind pressed but not implemented! '[keybind_signal]'")
			return FALSE
	user.mob.log_manual_zone_selected_update("keybind", old_target = original)

/datum/keybinding/mob/target/head_cycle
	hotkey_keys = list("Numpad8")
	name = "target_head_cycle"
	full_name = "Target: Cycle Head"
	description = "Pressing this key targets the head, and continued presses will cycle to the eyes and mouth. This will impact where you hit people, and can be used for surgery."
	keybind_signal = COMSIG_KB_MOB_TARGETCYCLEHEAD_DOWN

/datum/keybinding/mob/target/head
	hotkey_keys = list("Unbound")
	name = "target_head"
	full_name = "Target: Head"
	description = "Pressing this key targets the head. This will impact where you hit people, and can be used for surgery."
	keybind_signal = COMSIG_KB_MOB_TARGETHEAD_DOWN

/datum/keybinding/mob/target/eyes
	hotkey_keys = list("Numpad7")
	name = "target_eyes"
	full_name = "Target: Eyes"
	description = "Pressing this key targets the eyes. This will impact where you hit people, and can be used for surgery."
	keybind_signal = COMSIG_KB_MOB_TARGETEYES_DOWN

/datum/keybinding/mob/target/mouth
	hotkey_keys = list("Numpad9")
	name = "target_mouths"
	full_name = "Target: Mouth"
	description = "Pressing this key targets the mouth. This will impact where you hit people, and can be used for surgery."
	keybind_signal = COMSIG_KB_MOB_TARGETMOUTH_DOWN

/datum/keybinding/mob/target/r_arm
	hotkey_keys = list("Numpad4")
	name = "target_r_arm"
	full_name = "Target: right arm"
	description = "Pressing this key targets the right arm. This will impact where you hit people, and can be used for surgery."
	keybind_signal = COMSIG_KB_MOB_TARGETRIGHTARM_DOWN

/datum/keybinding/mob/target/body_chest
	hotkey_keys = list("Numpad5")
	name = "target_body_chest"
	full_name = "Target: Body"
	description = "Pressing this key targets the body. This will impact where you hit people, and can be used for surgery."
	keybind_signal = COMSIG_KB_MOB_TARGETBODYCHEST_DOWN

/datum/keybinding/mob/target/left_arm
	hotkey_keys = list("Numpad6")
	name = "target_left_arm"
	full_name = "Target: left arm"
	description = "Pressing this key targets the body. This will impact where you hit people, and can be used for surgery."
	keybind_signal = COMSIG_KB_MOB_TARGETLEFTARM_DOWN

/datum/keybinding/mob/target/right_leg
	hotkey_keys = list("Numpad1")
	name = "target_right_leg"
	full_name = "Target: Right leg"
	description = "Pressing this key targets the right leg. This will impact where you hit people, and can be used for surgery."
	keybind_signal = COMSIG_KB_MOB_TARGETRIGHTLEG_DOWN

/datum/keybinding/mob/target/body_groin
	hotkey_keys = list("Numpad2")
	name = "target_body_groin"
	full_name = "Target: Groin"
	description = "Pressing this key targets the groin. This will impact where you hit people, and can be used for surgery."
	keybind_signal = COMSIG_KB_MOB_TARGETBODYGROIN_DOWN

/datum/keybinding/mob/target/left_leg
	hotkey_keys = list("Numpad3")
	name = "target_left_leg"
	full_name = "Target: left leg"
	description = "Pressing this key targets the left leg. This will impact where you hit people, and can be used for surgery."
	keybind_signal = COMSIG_KB_MOB_TARGETLEFTLEG_DOWN

/datum/keybinding/mob/prevent_movement
	hotkey_keys = list("Alt")
	name = "block_movement"
	full_name = "Block movement"
	description = "Prevents you from moving"
	keybind_signal = COMSIG_KB_MOB_BLOCKMOVEMENT_DOWN

/datum/keybinding/mob/prevent_movement/down(client/user, turf/target)
	. = ..()
	if(.)
		return
	user.movement_locked = TRUE

/datum/keybinding/mob/prevent_movement/up(client/user, turf/target)
	. = ..()
	if(.)
		return
	user.movement_locked = FALSE

/datum/keybinding/living/view_pet_data
	hotkey_keys = list("Shift")
	name = "view_pet_commands"
	full_name = "View Pet Commands"
	description = "Hold down to see all the commands you can give your pets!"
	keybind_signal = COMSIG_KB_LIVING_VIEW_PET_COMMANDS
	can_reuse_keybind = TRUE

/datum/keybinding/mob/show_names
	hotkey_keys = list("Shift")
	name = "show_name_tags"
	full_name = "Show name tags"
	description = "Lets you see people's names below their body."
	keybind_signal = COMSIG_KB_MOB_SHOW_NAME_TAGS_DOWN
	can_reuse_keybind = TRUE

/datum/keybinding/mob/show_names/down(client/user)
	. = ..()
	if(.)
		return
	var/mob/living/living_mob = user.mob
	if(istype(living_mob) && living_mob.has_quirk(/datum/quirk/prosopagnosia))
		return
	if(COOLDOWN_FINISHED(user, update_nametag_cooldown))
		for(var/mob/living/living in view(user.view, user.mob))
			living.update_name_tag()
		COOLDOWN_START(user, update_nametag_cooldown, 1 SECONDS)

	for(var/atom/movable/screen/plane_master/name_tags/name_tag as anything in user.mob?.hud_used.get_true_plane_masters(PLANE_NAME_TAGS))
		name_tag.alpha = 255

/datum/keybinding/mob/show_names/up(client/user)
	. = ..()
	if(.)
		return
	for(var/atom/movable/screen/plane_master/name_tags/name_tag as anything in user.mob?.hud_used.get_true_plane_masters(PLANE_NAME_TAGS))
		name_tag.alpha = 0
