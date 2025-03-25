/decl/modpack/zaddat
	name = "Zaddat"

/decl/modpack/zaddat/pre_initialize()
	..()
	SSmodpacks.default_submap_whitelisted_species |= /decl/species/zaddat::uid

/mob/living/human/zaddat/Initialize(mapload, species_uid, datum/mob_snapshot/supplied_appearance)
	species_uid = /decl/species/zaddat::uid
	. = ..()
