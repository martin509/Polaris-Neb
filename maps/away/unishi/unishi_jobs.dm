/datum/job/submap/unishi_crew
	title = "Unishi Crew"
	total_positions = 1
	outfit_type = /decl/outfit/job/unishi/crew
	supervisors = "your survival"
	info = "You remember waking up to alarms blaring in your face. Before you could react, a gush of hot air blew \
	you away, knocking you cold unconcious.  Before this happened you were a crew member \
	on this research vessel, SRV Verne, as it carried the members of the presitigous Ceti Technical institute in \
	their pursuit of research. "
	required_language = /decl/language/human/common

/datum/job/submap/unishi_researcher
	title = "Unishi Researcher"
	supervisors = "the crew"
	total_positions = 2
	outfit_type = /decl/outfit/job/unishi/researcher
	info = "You remember waking up to alarms blaring in your face. Before you could react, a gush of hot air blew \
	you away, knocking you cold unconcious. Before this happened, you were a researcher, aboard SRV Verne."
	required_language = /decl/language/human/common

/decl/outfit/job/unishi
	abstract_type = /decl/outfit/job/unishi
	pda_type = /obj/item/modular_computer/pda
	pda_slot = slot_l_store_str
	l_ear = null
	r_ear = null

/decl/outfit/job/unishi/crew
	name = "CTI Research Vessel - Job - Unishi Crewman"
	r_pocket = /obj/item/radio
	shoes = /obj/item/clothing/shoes/color/black
	belt = /obj/item/belt/utility/full

/decl/outfit/job/unishi/researcher
	name = "CTI Research Vessel - Job - Researcher"
	uniform = /obj/item/clothing/jumpsuit/engineer
	suit = /obj/item/clothing/suit/jacket/hoodie
	shoes = /obj/item/clothing/shoes/color/black
	r_pocket = /obj/item/radio
	l_pocket = /obj/item/crowbar

/obj/abstract/submap_landmark/spawnpoint/unishi_crew
	name = "Unishi Crew"

/obj/abstract/submap_landmark/spawnpoint/unishi_researcher
	name = "Unishi Researcher"
