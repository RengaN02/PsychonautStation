/obj/item/reagent_containers/blood
	name = "blood pack"
	desc = "Contains blood used for transfusion. Must be attached to an IV drip."
	icon = 'icons/obj/medical/bloodpack.dmi'
	icon_state = "bloodpack"
	volume = 200
	var/blood_type = null
	var/unique_blood = null
	var/labelled = FALSE
	fill_icon_thresholds = list(10, 20, 30, 40, 50, 60, 70, 80, 90, 100)

/obj/item/reagent_containers/blood/Initialize(mapload, vol)
	. = ..()
	if(blood_type != null)
		reagents.add_reagent(unique_blood ? unique_blood : /datum/reagent/blood, 200, list("viruses"=null,"blood_DNA"=null,"blood_type"=get_blood_type(blood_type),"resistances"=null,"trace_chem"=null))
		update_appearance()

/// Handles updating the container when the reagents change.
/obj/item/reagent_containers/blood/on_reagent_change(datum/reagents/holder, ...)
	var/datum/reagent/blood/new_reagent = holder.has_reagent(/datum/reagent/blood)
	if(new_reagent && new_reagent.data && new_reagent.data["blood_type"])
		var/datum/blood_type/blood_type = new_reagent.data["blood_type"]
		blood_type = blood_type.name
	else if(holder.has_reagent(/datum/reagent/consumable/liquidelectricity))
		blood_type = BLOOD_TYPE_ETHEREAL
	else if(holder.has_reagent(/datum/reagent/lube))
		blood_type = BLOOD_TYPE_SNAIL
	else if(holder.has_reagent(/datum/reagent/water))
		blood_type = BLOOD_TYPE_H2O
	else if(holder.has_reagent(/datum/reagent/toxin/slimejelly))
		blood_type = BLOOD_TYPE_TOX
	else if(holder.has_reagent(/datum/reagent/fuel/oil))
		blood_type = BLOOD_TYPE_OIL
	else
		blood_type = null
	return ..()

/obj/item/reagent_containers/blood/update_name(updates)
	. = ..()
	if(labelled)
		return
	name = "blood pack[blood_type ? " - [blood_type]" : null]"

/obj/item/reagent_containers/blood/random
	icon_state = "random_bloodpack"

/obj/item/reagent_containers/blood/random/Initialize(mapload, vol)
	icon_state = "bloodpack"
	blood_type = pick(BLOOD_TYPE_A_PLUS, BLOOD_TYPE_A_MINUS, BLOOD_TYPE_B_PLUS, BLOOD_TYPE_B_MINUS, BLOOD_TYPE_O_PLUS, BLOOD_TYPE_O_MINUS, BLOOD_TYPE_LIZARD)
	return ..()

/obj/item/reagent_containers/blood/a_plus
	blood_type = BLOOD_TYPE_A_PLUS

/obj/item/reagent_containers/blood/a_minus
	blood_type = BLOOD_TYPE_A_MINUS

/obj/item/reagent_containers/blood/b_plus
	blood_type = BLOOD_TYPE_B_PLUS

/obj/item/reagent_containers/blood/b_minus
	blood_type = BLOOD_TYPE_B_MINUS

/obj/item/reagent_containers/blood/o_plus
	blood_type = BLOOD_TYPE_O_PLUS

/obj/item/reagent_containers/blood/o_minus
	blood_type = BLOOD_TYPE_O_MINUS

/obj/item/reagent_containers/blood/lizard
	blood_type = BLOOD_TYPE_LIZARD

/obj/item/reagent_containers/blood/ethereal
	blood_type = BLOOD_TYPE_ETHEREAL
	unique_blood = /datum/reagent/consumable/liquidelectricity

/obj/item/reagent_containers/blood/snail
	blood_type = BLOOD_TYPE_SNAIL
	unique_blood = /datum/reagent/lube

/obj/item/reagent_containers/blood/snail/examine()
	. = ..()
	. += span_notice("It's a bit slimy... The label indicates that this is meant for snails.")

/obj/item/reagent_containers/blood/podperson
	blood_type = BLOOD_TYPE_H2O
	unique_blood = /datum/reagent/water

/obj/item/reagent_containers/blood/podperson/examine()
	. = ..()
	. += span_notice("This appears to be some very overpriced water.")

// for IPCs
/obj/item/reagent_containers/blood/oil
	blood_type = "LPG"
	unique_blood = /datum/reagent/fuel/oil

/obj/item/reagent_containers/blood/oil/examine()
	. = ..()
	. += span_notice("There is a flammable warning on the label. This is for IPCs.")

// for slimepeople
/obj/item/reagent_containers/blood/toxin
	blood_type = BLOOD_TYPE_TOX
	unique_blood = /datum/reagent/toxin/slimejelly

/obj/item/reagent_containers/blood/toxin/examine()
	. = ..()
	. += span_notice("There is a toxin warning on the label. This is for slimepeople.")

/obj/item/reagent_containers/blood/universal
	blood_type = BLOOD_TYPE_UNIVERSAL

/obj/item/reagent_containers/blood/attackby(obj/item/tool, mob/user, list/modifiers, list/attack_modifiers)
	if (IS_WRITING_UTENSIL(tool))
		if(!user.can_write(tool))
			return
		var/custom_label = tgui_input_text(user, "What would you like to label the blood pack?", "Blood Pack", name, max_length = MAX_NAME_LEN)
		if(!user.can_perform_action(src))
			return
		if(user.get_active_held_item() != tool)
			return
		if(custom_label)
			labelled = TRUE
			name = "blood pack - [custom_label]"
			playsound(src, SFX_WRITING_PEN, 50, TRUE, SHORT_RANGE_SOUND_EXTRARANGE, SOUND_FALLOFF_EXPONENT + 3, ignore_walls = FALSE)
			balloon_alert(user, "new label set")
		else
			labelled = FALSE
			update_name()
	else
		return ..()
