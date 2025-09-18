/datum/asset/spritesheet_batched/sprite_accessories
	name = "sprite_accessories"

/datum/asset/spritesheet_batched/sprite_accessories/create_spritesheets()
	var/list/accessories = SSaccessories.hairstyles_list | SSaccessories.facial_hairstyles_list | SSaccessories.underwear_list | SSaccessories.undershirt_list | SSaccessories.socks_list
	for(var/accessory_name as anything in (accessories))
		var/datum/sprite_accessory/accessory = accessories[accessory_name]
		if(isnull(accessory))
			continue
		var/icon_name = accessory.icon
		var/icon_state_name = accessory.icon_state
		insert_icon("sprite_accessories-[icon_state_name]", uni_icon(icon_name, icon_state_name))

	var/start_time = REALTIMEOFDAY
	for(var/obj/item/organ/organ as anything in subtypesof(/obj/item/organ))
		if(isnull(organ::bodypart_overlay) || isnull(organ::preference))
			continue
		var/datum/bodypart_overlay/overlay_type = organ::bodypart_overlay
		var/datum/bodypart_overlay/mutant/mutant_overlay = new overlay_type
		if(mutant_overlay.feature_key == "")
			qdel(mutant_overlay)
			continue
		var/list/feature_list = mutant_overlay.get_global_feature_list()
		for(var/accessory_name in feature_list)
			var/datum/sprite_accessory/accessory = feature_list[accessory_name]
			if(isnull(accessory.name) || accessory.name == SPRITE_ACCESSORY_NONE)
				continue
			var/accessory_icon = accessory.icon
			mutant_overlay.sprite_datum = accessory
			for(var/external_layer in mutant_overlay.all_layers)
				if(mutant_overlay.layers & external_layer)
					var/layer = mutant_overlay.bitflag_to_layer(external_layer)
					var/layertext = mutant_overlay.mutant_bodyparts_layertext(layer)
					var/icon_state = mutant_overlay.get_uni_icon_state(layer)
					if(!icon_exists(accessory_icon, icon_state))
						continue
					insert_icon("sprite_accessories-[organ::preference]_[replacetext(accessory_name, " ", "")]_[layertext]", uni_icon(accessory_icon, icon_state))
		qdel(mutant_overlay)
