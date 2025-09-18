/datum/asset/spritesheet_batched/species
	name = "species_body"

/datum/asset/spritesheet_batched/species/create_spritesheets()
	for (var/species_type in GLOB.species_prototypes)
		var/datum/species/species = GLOB.species_prototypes[species_type]
		var/datum/universal_icon/universal_icon = uni_icon('icons/effects/effects.dmi', "nothing")
		for (var/bodypart_zone in species.bodypart_overrides)
			var/obj/item/bodypart/bodypart = species.bodypart_overrides[bodypart_zone]
			var/bodypart_state = "[bodypart::limb_id]_[bodypart_zone][bodypart::is_dimorphic ? "_m" : ""]"
			var/bodypart_icon = icon_exists(bodypart::icon, bodypart_state) ? bodypart::icon : (bodypart::should_draw_greyscale ? bodypart::icon_greyscale : bodypart::icon_static)
			if(!icon_exists(bodypart_icon, bodypart_state))
				continue
			universal_icon.blend_icon(uni_icon(bodypart_icon, bodypart_state, dir = SOUTH), ICON_OVERLAY)
			if(!isnull(bodypart::aux_zone))
				if(icon_exists(bodypart_icon, "[bodypart::limb_id]_[bodypart::aux_zone]"))
					universal_icon.blend_icon(uni_icon(bodypart_icon, "[bodypart::limb_id]_[bodypart::aux_zone]", dir = SOUTH), ICON_OVERLAY)
		insert_icon("species_body-[species.id]", universal_icon)

/*


*/
