/datum/appearance_descriptor/age/zaddat
	name = "age"
	chargen_max_index = 9

	standalone_value_descriptors = list(
		"an infant" =      1,
		"a toddler" =      3,
		"a child" =        5,
		"a teenager" =    13,
		"a young adult" = 16,
		"an adult" =      20,
		"middle-aged" =   35,
		"aging" =         50,
		"elderly" =       70,
		"ancient" =      91
	)


/decl/species/zaddat
	uid = "species_zaddat"
	name = "Zaddat"
	name_plural = "Zaddat"

	available_bodytypes = list(
		/decl/bodytype/zaddat,
		/decl/bodytype/zaddat/female,
		/decl/bodytype/prosthetic/basic_human
		)


	description = "The Zaddat are an Unathi client race only recently introduced to SolGov space. Having evolved on \
	the high-pressure and post-apocalyptic world of Xohok, Zaddat require an environmental suit called a Shroud \
	to survive in usual planetary and station atmospheres. Despite these restrictions, worsening conditions on \
	Xohok and the blessing of the Moghes Hegemony have lead the Zaddat to enter human space in search of work \
	and living space."

	flesh_color = "#AFA59E"

	preview_outfit = /decl/outfit/job/generic/assistant

	brute_mod = 1.15
	burn_mod =  1.15
	toxins_mod = 1.5
	
	//flash_burn = 15 //flashing a zaddat probably counts as police brutality
	metabolism_mod = 0.7 //did u know if your ancestors starved ur body will actually start in starvation mode?
	gluttonous = GLUT_TINY
	taste_sensitivity = TASTE_SENSITIVE

	//assisted_langs = list(LANGUAGE_EAL, LANGUAGE_TERMINUS, LANGUAGE_SKRELLIANFAR, LANGUAGE_ROOTLOCAL, LANGUAGE_ROOTGLOBAL, LANGUAGE_VOX, LANGUAGE_SOL_COMMON, LANGUAGE_AKHANI, LANGUAGE_SIIK, LANGUAGE_GUTTER) //limited vocal range; can talk Unathi and magical Galcom but not much else

	breath_pressure = 20
	
	hazard_high_pressure = HAZARD_HIGH_PRESSURE + 500  // Dangerously high pressure.
	warning_high_pressure = WARNING_HIGH_PRESSURE + 500 // High pressure warning.
	warning_low_pressure = 300   // Low pressure warning.
	hazard_low_pressure = 220     // Dangerously low pressure.
	//safe_pressure = 400
	poison_types = list(/decl/material/gas/chlorine = TRUE, /decl/material/gas/nitrogen = TRUE)

/decl/species/zaddat/handle_environment_special(var/mob/living/human/H)
	//if(H.in_stasis)
	//	return
	var/damageable = H.get_damageable_organs()
	var/list/covered = list() //H.get_coverage() //get_coverage() not implemented yet
	for(var/obj/item/clothing/C in H)
		if(C in H.get_held_items())
			continue
		if(C.body_parts_covered & SLOT_HEAD)
			covered += list(BP_HEAD)
		if(C.body_parts_covered & SLOT_UPPER_BODY)
			covered += list(BP_CHEST)
		if(C.body_parts_covered & SLOT_LOWER_BODY)
			covered += list(BP_GROIN)
		if(C.body_parts_covered & SLOT_LEGS)
			covered += list(BP_L_LEG, BP_R_LEG)
		if(C.body_parts_covered & SLOT_ARMS)
			covered += list(BP_R_ARM, BP_L_ARM)
		if(C.body_parts_covered & SLOT_FEET)
			covered += list(BP_L_FOOT, BP_R_FOOT)
		if(C.body_parts_covered & SLOT_HANDS)
			covered += list(BP_L_HAND, BP_R_HAND)

	var/light_amount = 0 //how much light there is in the place, affects damage
	if(isturf(H.loc)) //else, there's considered to be no light
		var/turf/T = H.loc
		light_amount = T.get_lumcount() * 5

	for(var/K in damageable)
		if(!(K in covered))
			H.apply_damage(light_amount/4, BURN, K, 0, 0, "Abnormal growths")

/decl/species/zaddat/equip_survival_gear(var/mob/living/human/H)
	/*cur_slot = H.get_inventory_slot_datum(slot_wear_mask_str)
	if(cur_slot?.get_equipped_item())
		qdel(cur_slot?.get_equipped_item())*/
	
	H.equip_to_slot_or_del(new /obj/item/clothing/mask/gas/zaddat/(H), slot_wear_mask_str) // mask has to come first or Shroud helmet will get in the way
	H.equip_to_slot_or_del(new /obj/item/clothing/suit/space/void/zaddat/(H), slot_wear_suit_str)
	/*
	var/datum/inventory_slot/cur_slot = H.get_inventory_slot_datum(slot_wear_suit_str)
	if(cur_slot?.get_equipped_item()) //get rid of job labcoats so they don't stop us from equipping the Shroud
		qdel(cur_slot?.get_equipped_item()) //if you know how to gently set it in like, their backpack or whatever, be my guest

	cur_slot = H.get_inventory_slot_datum(slot_head_str)
	if(cur_slot?.get_equipped_item())
		qdel(cur_slot?.get_equipped_item())*/

	



/*

/datum/species/zaddat
	name = SPECIES_ZADDAT
	name_plural = "Zaddat"
	icobase = 'icons/mob/human_races/r_zaddat.dmi'
	deform = 'icons/mob/human_races/r_zaddat.dmi'
	unarmed_types = list(/datum/unarmed_attack/stomp, /datum/unarmed_attack/kick, /datum/unarmed_attack/punch)
	brute_mod = 1.15
	burn_mod =  1.15
	toxins_mod = 1.5
	flash_mod = 2
	flash_burn = 15 //flashing a zaddat probably counts as police brutality
	metabolic_rate = 0.7 //did u know if your ancestors starved ur body will actually start in starvation mode?
	gluttonous = GLUT_TINY
	taste_sensitivity = TASTE_SENSITIVE
	num_alternate_languages = 3
	secondary_langs = list(LANGUAGE_ZADDAT, LANGUAGE_UNATHI)
	assisted_langs = list(LANGUAGE_EAL, LANGUAGE_TERMINUS, LANGUAGE_SKRELLIANFAR, LANGUAGE_ROOTLOCAL, LANGUAGE_ROOTGLOBAL, LANGUAGE_VOX, LANGUAGE_SOL_COMMON, LANGUAGE_AKHANI, LANGUAGE_SIIK, LANGUAGE_GUTTER) //limited vocal range; can talk Unathi and magical Galcom but not much else
	name_language = LANGUAGE_ZADDAT
	species_language = LANGUAGE_ZADDAT
	health_hud_intensity = 2.5

	minimum_breath_pressure = 20 //have fun with underpressures. any higher than this and they'll be even less suitible for life on the station

	economic_modifier = 3

	min_age = 16
	max_age = 90

	blurb = "The Zaddat are an Unathi client race only recently introduced to SolGov space. Having evolved on \
	the high-pressure and post-apocalyptic world of Xohok, Zaddat require an environmental suit called a Shroud \
	to survive in usual planetary and station atmospheres. Despite these restrictions, worsening conditions on \
	Xohok and the blessing of the Moghes Hegemony have lead the Zaddat to enter human space in search of work \
	and living space."
	catalogue_data = list(/datum/category_item/catalogue/fauna/zaddat)

	hazard_high_pressure = HAZARD_HIGH_PRESSURE + 500  // Dangerously high pressure.
	warning_high_pressure = WARNING_HIGH_PRESSURE + 500 // High pressure warning.
	warning_low_pressure = 300   // Low pressure warning.
	hazard_low_pressure = 220     // Dangerously low pressure.
	safe_pressure = 400
	poison_type = "nitrogen"      // technically it's a partial pressure thing but IDK if we can emulate that

	genders = list(FEMALE, PLURAL) //females are polyp-producing, infertile females and males are nigh-identical

	spawn_flags = SPECIES_CAN_JOIN | SPECIES_IS_WHITELISTED
	appearance_flags = null

	flesh_color = "#AFA59E"
	base_color = "#e2e4a6"
	blood_color = "#FFCC00" //a gross sort of orange color

	reagent_tag = IS_ZADDAT

	heat_discomfort_strings = list(
		"Your joints itch.",
		"You feel uncomfortably warm.",
		"Your carapace feels like a stove."
		)

	cold_discomfort_strings = list(
		"You feel chilly.",
		"You shiver suddenly.",
		"Your antenna ache."
		)

	has_organ = list(    //No appendix.
	O_HEART =    /obj/item/organ/internal/heart,
	O_LUNGS =    /obj/item/organ/internal/lungs,
	O_VOICE = 	 /obj/item/organ/internal/voicebox,
	O_LIVER =    /obj/item/organ/internal/liver,
	O_KIDNEYS =  /obj/item/organ/internal/kidneys,
	O_BRAIN =    /obj/item/organ/internal/brain,
	O_EYES =     /obj/item/organ/internal/eyes,
	O_STOMACH =	 /obj/item/organ/internal/stomach,
	O_INTESTINE =/obj/item/organ/internal/intestine
	)

	descriptors = list(
		/datum/mob_descriptor/height = 0,
		/datum/mob_descriptor/build = -1
		)

	default_emotes = list(
		/decl/emote/audible/chirp
	)
	*/


