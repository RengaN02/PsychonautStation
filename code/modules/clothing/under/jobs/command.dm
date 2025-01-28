/obj/item/clothing/under/rank/captain
	desc = "It's a blue jumpsuit with some gold markings denoting the rank of \"Captain\"."
	name = "captain's jumpsuit"
	icon_state = "captain"
	inhand_icon_state = "b_suit"
	sensor_mode = SENSOR_COORDS
	random_sensor = FALSE
	icon = 'icons/obj/clothing/under/captain.dmi'
	worn_icon = 'icons/mob/clothing/under/captain.dmi'
	armor_type = /datum/armor/clothing_under/rank_captain

/datum/armor/clothing_under/rank_captain
	wound = 15

/obj/item/clothing/under/rank/captain/skirt
	name = "captain's jumpskirt"
	desc = "It's a blue jumpskirt with some gold markings denoting the rank of \"Captain\"."
	icon_state = "captain_skirt"
	inhand_icon_state = "b_suit"
	body_parts_covered = CHEST|GROIN|ARMS
	dying_key = DYE_REGISTRY_JUMPSKIRT
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON

/obj/item/clothing/under/rank/captain/suit
	name = "captain's suit"
	desc = "A green suit and yellow necktie. Exemplifies authority."
	icon_state = "green_suit"
	inhand_icon_state = "dg_suit"
	can_adjust = FALSE

/obj/item/clothing/under/rank/captain/suit/skirt
	name = "green suitskirt"
	desc = "A green suitskirt and yellow necktie. Exemplifies authority."
	icon_state = "green_suit_skirt"
	inhand_icon_state = "dg_suit"
	body_parts_covered = CHEST|GROIN|ARMS
	dying_key = DYE_REGISTRY_JUMPSKIRT
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON

/obj/item/clothing/under/rank/captain/parade
	name = "captain's parade uniform"
	desc = "A captain's luxury-wear, for special occasions."
	icon_state = "captain_parade"
	inhand_icon_state = null
	can_adjust = FALSE

/obj/item/clothing/under/rank/blueshield
	icon = 'icons/psychonaut/obj/clothing/under/command.dmi'
	worn_icon = 'icons/psychonaut/mob/clothing/under/command.dmi'
	name = "blueshield's suit"
	desc = "A classic bodyguard's suit, with custom-fitted Blueshield-Blue cuffs and a Nanotrasen insignia over one of the pockets."
	icon_state = "blueshield"
	strip_delay = 50
	armor_type = /datum/armor/clothing_under/rank_blueshield
	sensor_mode = SENSOR_COORDS
	random_sensor = FALSE
	alt_covers_chest = TRUE

/datum/armor/clothing_under/rank_blueshield
	melee = 10
	bullet = 5
	laser = 5
	energy = 10
	bomb = 10
	fire = 50
	acid = 50

/obj/item/clothing/under/rank/blueshield/skirt
	name = "blueshield's suitskirt"
	desc = "A classic bodyguard's suitskirt, with custom-fitted Blueshield-Blue cuffs and a Nanotrasen insignia over one of the pockets."
	icon_state = "blueshieldskirt"
	body_parts_covered = CHEST|GROIN|ARMS
	dying_key = DYE_REGISTRY_JUMPSKIRT
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON


/obj/item/clothing/under/rank/blueshield/turtleneck
	name = "blueshield's turtleneck"
	desc = "A tactical jumper fit for only the best of bodyguards, with plenty of tactical pockets for your tactical needs."
	icon_state = "bs_turtleneck"

/obj/item/clothing/under/rank/blueshield/turtleneck/skirt
	name = "blueshield's skirtleneck"
	desc = "A tactical jumper fit for only the best of bodyguards - instead of tactical pockets, this one has a tactical lack of leg protection."
	icon_state = "bs_skirtleneck"
	body_parts_covered = CHEST|GROIN|ARMS
	dying_key = DYE_REGISTRY_JUMPSKIRT
	female_sprite_flags = FEMALE_UNIFORM_TOP_ONLY
	supports_variations_flags = CLOTHING_DIGITIGRADE_VARIATION_NO_NEW_ICON
