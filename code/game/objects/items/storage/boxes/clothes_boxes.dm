// This contains all boxes that will possess something wearable, like an outfit or something similar.area

/obj/item/storage/box/gloves
	name = "box of latex gloves"
	desc = "Contains sterile latex gloves."
	illustration = "latex"

/obj/item/storage/box/gloves/PopulateContents()
	. = list()
	for(var/_ in 1 to 7)
		. += /obj/item/clothing/gloves/latex

/obj/item/storage/box/masks
	name = "box of sterile masks"
	desc = "This box contains sterile medical masks."
	illustration = "sterile"

/obj/item/storage/box/masks/PopulateContents()
	. = list()
	for(var/_ in 1 to 7)
		. += /obj/item/clothing/mask/surgical

/obj/item/storage/box/rxglasses
	name = "box of prescription glasses"
	desc = "This box contains nerd glasses."
	illustration = "glasses"

/obj/item/storage/box/rxglasses/PopulateContents()
	. = list()
	for(var/_ in 1 to 7)
		. += /obj/item/clothing/glasses/regular

/obj/item/storage/box/tape_wizard
	name = "Tape Wizard - Episode 23"
	desc = "A box containing the costume used by legendary entertainment icon 'Super Tape Wizard'. It got a little stuck on its way out."

/obj/item/storage/box/tape_wizard/PopulateContents(datum/storage_config/config)
	config.compute_max_item_weight = TRUE

	return list(
		/obj/item/clothing/head/wizard/tape/fake,
		/obj/item/clothing/suit/wizrobe/tape/fake,
		/obj/item/staff/tape,
		/obj/item/stack/sticky_tape,
	)

/obj/item/storage/box/fakesyndiesuit
	name = "boxed replica space suit and helmet"
	desc = "A sleek, sturdy box used to hold toy spacesuits."
	icon_state = "syndiebox"
	illustration = "syndiesuit"
	storage_type = /datum/storage/box/syndie_kit

/obj/item/storage/box/fakesyndiesuit/PopulateContents()
	return list(
		/obj/item/clothing/head/syndicatefake,
		/obj/item/clothing/suit/syndicatefake
	)

/obj/item/storage/box/syndie_kit/battle_royale
	name = "rumble royale broadcast kit"
	desc = "Contains everything you need to host the galaxy's greatest show; Rumble Royale."

/obj/item/storage/box/syndie_kit/battle_royale/PopulateContents()
	var/obj/item/royale_implanter/implanter = new(null)
	var/obj/item/royale_remote/remote = new(null)
	remote.link_implanter(implanter)
	return list(implanter, remote)

/obj/item/storage/box/deputy
	name = "box of deputy armbands"
	desc = "To be issued to those authorized to act as deputy of security."
	icon_state = "secbox"
	illustration = "depband"

/obj/item/storage/box/deputy/PopulateContents()
	. = list()
	for(var/_ in 1 to 7)
		. += /obj/item/clothing/accessory/armband/deputy

/obj/item/storage/box/hero
	name = "Courageous Tomb Raider - 1940's."
	desc = "This legendary figure of still dubious historical accuracy is thought to have been a world-famous archeologist who embarked on countless adventures in far away lands, along with his trademark whip and fedora hat."
	storage_type = /datum/storage/box/hero

/obj/item/storage/box/hero/PopulateContents()
	return list(
		/obj/item/clothing/head/fedora/curator,
		/obj/item/clothing/shoes/workboots/mining,
		/obj/item/clothing/suit/jacket/curator,
		/obj/item/clothing/under/rank/civilian/curator/treasure_hunter,
		/obj/item/melee/curator_whip,
	)

/obj/item/storage/box/hero/astronaut
	name = "First Man on the Moon - 1960's."
	desc = "One small step for a man, one giant leap for mankind. Relive the beginnings of space exploration with this fully functional set of vintage EVA equipment."

/obj/item/storage/box/hero/astronaut/PopulateContents(datum/storage_config/config)
	config.compute_max_item_weight = TRUE

	return list(
		/obj/item/clothing/suit/space/nasavoid,
		/obj/item/clothing/head/helmet/space/nasavoid,
		/obj/item/tank/internals/oxygen,
		/obj/item/gps,
	)

/obj/item/storage/box/hero/scottish
	name = "Braveheart, the Scottish rebel - 1300's."
	desc = "Seemingly a legendary figure in the battle for Scottish independence, this historical figure is closely associated with blue facepaint, big swords, strange man skirts, and his ever enduring catchphrase: 'FREEDOM!!'"

/obj/item/storage/box/hero/scottish/PopulateContents()
	return list(
		/obj/item/claymore/weak/ceremonial,
		/obj/item/clothing/shoes/sandal,
		/obj/item/clothing/under/costume/kilt,
		/obj/item/toy/crayon/spraycan,
	)

/obj/item/storage/box/hero/carphunter
	name = "Carp Hunter, Wildlife Expert - 2506."
	desc = "Despite his nickname, this wildlife expert was mainly known as a passionate environmentalist and conservationist, often coming in contact with dangerous wildlife to teach about the beauty of nature."

/obj/item/storage/box/hero/carphunter/PopulateContents()
	return list(
		/obj/item/clothing/mask/gas/carp,
		/obj/item/clothing/suit/hooded/carp_costume/spaceproof/old,
		/obj/item/knife/hunting,
		/obj/item/storage/box/papersack/meat,
	)

/obj/item/storage/box/hero/mothpioneer
	name = "Mothic Fleet Pioneer - 2429."
	desc = "Some claim that the fleet engineers are directly responsible for most modern advancements in spacefaring designs. Although the exact details of their past contributions are somewhat fuzzy, their ingenuity remains unmatched and unquestioned to this day."

/obj/item/storage/box/hero/mothpioneer/PopulateContents()
	return list(
		/obj/item/clothing/head/mothcap/original,
		/obj/item/clothing/suit/mothcoat/original,
		/obj/item/crowbar,
		/obj/item/flashlight/lantern,
		/obj/item/screwdriver,
		/obj/item/stack/sheet/glass/fifty,
		/obj/item/stack/sheet/iron/fifty,
		/obj/item/wrench,
	)

/obj/item/storage/box/hero/etherealwarden
	name = "Ethereal Trailwarden - 2450's."
	desc = "Many fantastical stories are told of valiant trail wardens, even by offworlders who, thanks to their guidance, avoided an untimely demise while traveling the sometimes treacherous roads of Sprout. In truth their job entails far more walking and fixing roads than slaying dragons, but it is no less important and well respected: keeping the roads and trails safe and well maintained is for many settlements a matter of survival."

/obj/item/storage/box/hero/etherealwarden/PopulateContents()
	return list(
		/obj/item/clothing/suit/hooded/ethereal_raincoat/trailwarden,
		/obj/item/clothing/under/ethereal_tunic/trailwarden,
		/obj/item/storage/backpack/saddlepack,
	)

/obj/item/storage/box/hero/journalist
	name = "Assassinated by CIA - 1984." // Literally
	desc = "Many courageous individuals risked their lives to report on events the government sought to keep hidden from the public, ensuring that the truth remained buried and unheard. These garments are replicas of the clothing worn by one such 'journalist,' a silent sentinel in the fight for truth."

/obj/item/storage/box/hero/journalist/PopulateContents()
	return list(
		/obj/item/clothing/under/costume/buttondown/slacks,
		/obj/item/clothing/suit/toggle/suspenders,
		/obj/item/clothing/neck/tie/red,
		/obj/item/clothing/head/fedora/beige/press,
		/obj/item/clothing/accessory/press_badge,
		/obj/item/clothing/suit/hazardvest/press,
		/obj/item/radio/entertainment/microphone/physical,
		/obj/item/radio/entertainment/speakers/physical,
		/obj/item/clipboard,
		/obj/item/taperecorder,
		/obj/item/camera,
		/obj/item/wallframe/telescreen/entertainment,
	)

/obj/item/storage/box/holy
	name = "Templar Kit"
	storage_type = /datum/storage/box/holy
	/// This item is used to generate a preview image for this set.
	/// It could be any item, doesn't even necessarily need to be something in the kit
	var/obj/item/typepath_for_preview = /obj/item/clothing/suit/chaplainsuit/armor/templar

/obj/item/storage/box/holy/PopulateContents()
	return list(
		/obj/item/clothing/head/helmet/chaplain,
		/obj/item/clothing/suit/chaplainsuit/armor/templar,
	)

/obj/item/storage/box/holy/clock
	name = "Forgotten kit"
	typepath_for_preview = /obj/item/clothing/suit/chaplainsuit/armor/clock

/obj/item/storage/box/holy/clock/PopulateContents()
	return list(
		/obj/item/clothing/head/helmet/chaplain/clock,
		/obj/item/clothing/suit/chaplainsuit/armor/clock,
	)

/obj/item/storage/box/holy/chapter
	name = "Chapter Chaplain kit"
	typepath_for_preview = /obj/item/clothing/suit/chaplainsuit/armor/chapter

/obj/item/storage/box/holy/chapter/PopulateContents()
	return list(
		/obj/item/clothing/head/helmet/chaplain/chapter,
		/obj/item/clothing/suit/chaplainsuit/armor/chapter,
		/obj/item/clothing/shoes/chapter,
	)

/obj/item/storage/box/holy/student
	name = "Profane Scholar Kit"
	typepath_for_preview = /obj/item/clothing/suit/chaplainsuit/armor/studentuni

/obj/item/storage/box/holy/student/PopulateContents()
	return list(
		/obj/item/clothing/suit/chaplainsuit/armor/studentuni,
		/obj/item/clothing/head/helmet/chaplain/cage,
	)

/obj/item/storage/box/holy/sentinel
	name = "Stone Sentinel Kit"
	typepath_for_preview = /obj/item/clothing/suit/chaplainsuit/armor/ancient

/obj/item/storage/box/holy/sentinel/PopulateContents()
	return list(
		/obj/item/clothing/suit/chaplainsuit/armor/ancient,
		/obj/item/clothing/head/helmet/chaplain/ancient,
	)

/obj/item/storage/box/holy/witchhunter
	name = "Witchhunter Kit"
	typepath_for_preview = /obj/item/clothing/suit/chaplainsuit/armor/witchhunter

/obj/item/storage/box/holy/witchhunter/PopulateContents()
	return list(
		/obj/item/clothing/suit/chaplainsuit/armor/witchhunter,
		/obj/item/clothing/head/helmet/chaplain/witchunter_hat,
	)

/obj/item/storage/box/holy/adept
	name = "Divine Adept Kit"
	typepath_for_preview = /obj/item/clothing/suit/chaplainsuit/armor/adept

/obj/item/storage/box/holy/adept/PopulateContents()
	return list(
		/obj/item/clothing/suit/chaplainsuit/armor/adept,
		/obj/item/clothing/head/helmet/chaplain/adept,
	)

/obj/item/storage/box/holy/follower
	name = "Followers of the Chaplain Kit"
	typepath_for_preview = /obj/item/clothing/suit/hooded/chaplain_hoodie/leader
	storage_type = /datum/storage/box/holy/follower

/obj/item/storage/box/holy/follower/PopulateContents()
	return list(
		/obj/item/clothing/suit/hooded/chaplain_hoodie,
		/obj/item/clothing/suit/hooded/chaplain_hoodie,
		/obj/item/clothing/suit/hooded/chaplain_hoodie,
		/obj/item/clothing/suit/hooded/chaplain_hoodie,
		/obj/item/clothing/suit/hooded/chaplain_hoodie/leader,
	)

/obj/item/storage/box/holy/divine_archer
	name = "Divine Archer Kit"
	typepath_for_preview = /obj/item/clothing/suit/hooded/chaplain_hoodie/divine_archer

/obj/item/storage/box/holy/divine_archer/PopulateContents()
	return list(
		/obj/item/clothing/under/rank/civilian/chaplain/divine_archer,
		/obj/item/clothing/suit/hooded/chaplain_hoodie/divine_archer,
		/obj/item/clothing/gloves/divine_archer,
		/obj/item/clothing/shoes/divine_archer,
	)

/obj/item/storage/box/holy/tech
	name = "Tech Priest Kit"
	typepath_for_preview = /obj/item/clothing/suit/hooded/chaplain_hoodie/tech

/obj/item/storage/box/holy/tech/PopulateContents()
	return list(
		/obj/item/clothing/suit/hooded/chaplain_hoodie/tech,
	)

/obj/item/storage/box/floor_camo
	name = "floor tile camo box"
	desc = "Thank you for shopping from Camo-J's, our uniquely designed \
		floor-tile 'NT scum' styled camouflage fatigues is the ultimate \
		espionage uniform used by the very best. Providing the best \
		flexibility, with our latest Camo-tech threads. Perfect for \
		risky-espionage hallway operations. Enjoy our product!"
	storage_type = /datum/storage/box/floor_camo

/obj/item/storage/box/floor_camo/PopulateContents(datum/storage_config/config)
	config.compute_max_item_weight = TRUE

	return list(
		/obj/item/clothing/under/syndicate/floortilecamo,
		/obj/item/clothing/mask/floortilebalaclava,
		/obj/item/clothing/gloves/combat/floortile,
		/obj/item/clothing/shoes/jackboots/floortile,
		/obj/item/storage/backpack/floortile,
	)

/obj/item/storage/box/collar_bomb
	name = "collar bomb box"
	desc = "A small print on the back reads 'For research purposes only. Handle with care. In case of emergency, call the following number:'... the rest is scratched out with a marker..."

/obj/item/storage/box/collar_bomb/PopulateContents(datum/storage_config/config)
	config.compute_max_item_weight = TRUE

	var/obj/item/collar_bomb_button/button = new(null)

	return list(button, new /obj/item/clothing/neck/collar_bomb(null, button))
