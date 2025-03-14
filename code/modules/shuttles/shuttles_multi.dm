/datum/shuttle/autodock/multi
	var/list/destination_tags
	var/list/destinations_cache = list()
	var/last_cache_rebuild_time = 0
	abstract_type = /datum/shuttle/autodock/multi

/datum/shuttle/autodock/multi/New(map_hash)
	..()
	if(map_hash)
		var/new_tags = list()
		for(var/thing in destination_tags)
			ADJUST_TAG_VAR(thing, map_hash)
			new_tags += map_hash
		destination_tags = new_tags

/datum/shuttle/autodock/multi/proc/set_destination(var/destination_key, mob/user)
	if(moving_status != SHUTTLE_IDLE)
		return
	next_location = destinations_cache[destination_key]

/datum/shuttle/autodock/multi/proc/get_destinations()
	if (last_cache_rebuild_time < SSshuttle.last_landmark_registration_time)
		build_destinations_cache()
	return destinations_cache

/datum/shuttle/autodock/multi/proc/build_destinations_cache()
	last_cache_rebuild_time = world.time
	destinations_cache.Cut()
	for(var/destination_tag in destination_tags)
		var/obj/effect/shuttle_landmark/landmark = SSshuttle.get_landmark(destination_tag)
		if (istype(landmark))
			destinations_cache["[landmark.name]"] = landmark

//Antag play announcements when they leave/return to their home area
/datum/shuttle/autodock/multi/antag
	warmup_time = 10 SECONDS //replaced the old move cooldown
	 //This variable is type-abused initially: specify the landmark_tag, not the actual landmark.
	var/obj/effect/shuttle_landmark/home_waypoint

	var/cloaked = 1
	var/announcer
	var/arrival_message
	var/departure_message

	abstract_type = /datum/shuttle/autodock/multi/antag

/datum/shuttle/autodock/multi/antag/New(map_hash)
	..()
	if(home_waypoint)
		if(map_hash)
			ADJUST_TAG_VAR(home_waypoint, map_hash)
		home_waypoint = SSshuttle.get_landmark(home_waypoint)
	else
		home_waypoint = current_location

/datum/shuttle/autodock/multi/antag/shuttle_moved(obj/effect/shuttle_landmark/destination, list/turf_translation, angle = 0)
	if(current_location == home_waypoint)
		announce_arrival()
	else if(next_location == home_waypoint)
		announce_departure()
	..()

/datum/shuttle/autodock/multi/antag/proc/announce_departure()
	if(cloaked || isnull(departure_message))
		return
	command_announcement.Announce(departure_message, announcer || "[global.using_map.boss_name]")

/datum/shuttle/autodock/multi/antag/proc/announce_arrival()
	if(cloaked || isnull(arrival_message))
		return
	command_announcement.Announce(arrival_message, announcer || "[global.using_map.boss_name]")

/datum/shuttle/autodock/multi/test_landmark_setup()
	. = ..()
	if(.)
		return
	for(var/dest_tag in destination_tags)
		if(!SSshuttle.get_landmark(dest_tag))
			return "Could not locate at least one destination landmark (with tag [dest_tag])."