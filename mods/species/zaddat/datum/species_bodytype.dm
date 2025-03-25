/decl/bodytype/zaddat
	name                  = "zaddat body"
	icon_base             = 'mods/species/zaddat/icons/body/body_male.dmi'
	limb_icon_intensity   = 0.7
	associated_gender     = PLURAL
	
	uid                   = "bodytype_zaddat"
	age_descriptor = /datum/appearance_descriptor/age/zaddat

	base_color = "#e2e4a6"

	has_organ = list(
		BP_HEART =    /obj/item/organ/internal/heart,
		BP_STOMACH =  /obj/item/organ/internal/stomach,
		BP_LUNGS =    /obj/item/organ/internal/lungs,
		BP_LIVER =    /obj/item/organ/internal/liver,
		BP_KIDNEYS =  /obj/item/organ/internal/kidneys,
		BP_BRAIN =    /obj/item/organ/internal/brain,
		BP_EYES =     /obj/item/organ/internal/eyes
	)
	eye_flash_mod = 2

	health_hud_intensity = 2.5

	appearance_descriptors = list(
		/datum/appearance_descriptor/height = 0,
		/datum/appearance_descriptor/build =  -1
	)

	default_emotes = list(
		/decl/emote/audible/chirp
	)

/decl/bodytype/zaddat/female
	icon_base             = 'mods/species/zaddat/icons/body/body_female.dmi'
	associated_gender     = FEMALE
	onmob_state_modifiers = list((slot_w_uniform_str) = "f")

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

