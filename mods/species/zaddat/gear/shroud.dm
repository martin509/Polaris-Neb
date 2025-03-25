/obj/item/clothing/head/helmet/space/void/zaddat
	name = "\improper Hegemony Shroud helmet"
	desc = "A Hegemony-designed utilitarian environment suit helmet, still common among the Spacer Zaddat."
	//icon_state = "zaddat_hegemony"
	//item_state_slots = list(slot_r_hand_str = "syndicate", slot_l_hand_str = "syndicate")
	heat_protection = SLOT_HEAD
	body_parts_covered = SLOT_HEAD|SLOT_FACE|SLOT_EYES
	//slowdown = 0.5
	armor = list(melee = 0, bullet = 0, laser = 0, energy = 0, bomb = 0, bio = 100, rad = 70) //realistically would have some armor but balance.
	siemens_coefficient = 1

	//species_restricted = list(SPECIES_ZADDAT)

/obj/item/clothing/suit/space/void/zaddat
	name = "\improper Hegemony Shroud"
	desc = "A Hegemony environment suit, still favored by the Spacer Zaddat because of its durability and ease of manufacture."
	//slowdown = 1
	armor = list(melee = 0, bullet = 0, laser = 0,energy = 0, bomb = 0, bio = 100, rad = 70)
	siemens_coefficient = 1
	allowed = list(/obj/item/flashlight,/obj/item/tank)
	//icon_state = "zaddat_hegemony"
	helmet = new/obj/item/clothing/head/helmet/space/void/zaddat //shrouds come with helmets built-in
	var/has_been_customized = FALSE

	//species_restricted = list(SPECIES_ZADDAT)

	breach_threshold = 12

/obj/item/clothing/mask/gas/zaddat
	name = "Zaddat Veil"
	desc = "A clear survival mask used by the Zaddat to filter out harmful nitrogen. Can be connected to an air supply and reconfigured to allow for safe eating."
	//icon_state = "zaddat_mask"
	//item_state = "vax_mask"
	//body_parts_covered = 0
	//species_restricted = list(SPECIES_ZADDAT)
	flags_inv = HIDEEARS //semi-transparent
	filtered_gases = list(/decl/material/solid/phoron,
		/decl/material/gas/nitrous_oxide,
		/decl/material/gas/nitrogen)