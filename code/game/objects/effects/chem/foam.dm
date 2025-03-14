// Foam
// Similar to smoke, but spreads out more
// metal foams leave behind a foamed metal wall

/obj/effect/effect/foam
	name = "foam"
	icon_state = "foam"
	opacity = FALSE
	anchored = TRUE
	density = FALSE
	layer = ABOVE_OBJ_LAYER
	mouse_opacity = MOUSE_OPACITY_UNCLICKABLE
	animate_movement = 0
	var/amount = 3
	var/metal = 0

/obj/effect/effect/foam/Initialize(mapload, var/ismetal = 0)
	. = ..(mapload)
	icon_state = "[ismetal? "m" : ""]foam"
	metal = ismetal
	playsound(src, 'sound/effects/bubbles2.ogg', 80, 1, -3)
	spawn(3 + metal * 3)
		Process()
		checkReagents()
	addtimer(CALLBACK(src, PROC_REF(remove_foam)), 12 SECONDS)

/obj/effect/effect/foam/proc/remove_foam()
	STOP_PROCESSING(SSobj, src)
	if(metal)
		var/obj/structure/foamedmetal/M = new(src.loc)
		M.metal = metal
		M.update_icon()
	flick("[icon_state]-disolve", src)
	QDEL_IN(src, 5)

/obj/effect/effect/foam/proc/checkReagents() // transfer any reagents to the floor
	if(!metal && reagents)
		var/turf/T = get_turf(src)
		reagents.touch_turf(T)

/obj/effect/effect/foam/Process()
	if(--amount < 0)
		return

	for(var/direction in global.cardinal)
		var/turf/T = get_step(src, direction)
		if(!T)
			continue

		if(!T.Enter(src))
			continue

		var/obj/effect/effect/foam/F = locate() in T
		if(F)
			continue

		F = new(T, metal)
		F.amount = amount
		if(!metal)
			F.create_reagents(10)
			if(reagents)
				for(var/R in reagents.reagent_volumes)
					F.add_to_reagents(R, 1, safety = 1) //added safety check since reagents in the foam have already had a chance to react

/obj/effect/effect/foam/fire_act(datum/gas_mixture/air, exposed_temperature, exposed_volume) // foam disolves when heated, except metal foams
	if(!metal && prob(max(0, exposed_temperature - 475)))
		flick("[icon_state]-disolve", src)
		QDEL_IN(src, 5)
		return
	return ..()

/obj/effect/effect/foam/Crossed(atom/movable/AM)
	if(metal || !isliving(AM))
		return
	var/mob/living/M = AM
	M.slip("the foam", 6)

/datum/effect/effect/system/foam_spread
	var/amount = 5				// the size of the foam spread.
	var/list/carried_reagents	// the IDs of reagents present when the foam was mixed
	var/metal = 0				// 0 = foam, 1 = metalfoam, 2 = ironfoam

/datum/effect/effect/system/foam_spread/set_up(amt=5, loca, var/datum/reagents/carry = null, var/metalfoam = 0)
	amount = round(sqrt(amt / 3), 1)
	if(istype(loca, /turf/))
		location = loca
	else
		location = get_turf(loca)

	carried_reagents = list()
	metal = metalfoam

	// bit of a hack here. Foam carries along any reagent also present in the glass it is mixed with (defaults to water if none is present). Rather than actually transfer the reagents, this makes a list of the reagent ids and spawns 1 unit of that reagent when the foam disolves.

	if(carry && !metal)
		for(var/R in carry.reagent_volumes)
			carried_reagents += R

/datum/effect/effect/system/foam_spread/start()
	spawn(0)
		var/obj/effect/effect/foam/F = locate() in location
		if(F)
			F.amount += amount
			return

		F = new /obj/effect/effect/foam(location, metal)
		F.amount = amount

		if(!metal) // don't carry other chemicals if a metal foam
			F.create_reagents(10)

			if(carried_reagents)
				for(var/id in carried_reagents)
					F.add_to_reagents(id, 1, safety = 1) //makes a safety call because all reagents should have already reacted anyway
			else
				F.add_to_reagents(/decl/material/liquid/water, 1, safety = 1)

// wall formed by metal foams, dense and opaque, but easy to break

/obj/structure/foamedmetal
	icon = 'icons/effects/effects.dmi'
	icon_state = "metalfoam"
	density =  TRUE
	opacity =  TRUE
	anchored = TRUE
	name = "foamed metal"
	desc = "A lightweight foamed metal wall."
	atmos_canpass = CANPASS_DENSITY
	var/metal = 1 // 1 = aluminium, 2 = iron

/obj/structure/foamedmetal/Initialize()
	. = ..()
	update_nearby_tiles(1)

/obj/structure/foamedmetal/Destroy()
	set_density(0)
	update_nearby_tiles(1)
	return ..()

/obj/structure/foamedmetal/on_update_icon()
	..()
	if(metal == 1)
		icon_state = "metalfoam"
	else
		icon_state = "ironfoam"

/obj/structure/foamedmetal/explosion_act(severity)
	..()
	if(!QDELETED(src))
		physically_destroyed()

/obj/structure/foamedmetal/bullet_act()
	if(metal == 1 || prob(50))
		qdel(src)

/obj/structure/foamedmetal/attack_hand(var/mob/user)
	SHOULD_CALL_PARENT(FALSE)
	if (prob(75 - metal * 25))
		user.visible_message("<span class='warning'>[user] smashes through the foamed metal.</span>", "<span class='notice'>You smash through the metal foam wall.</span>")
		qdel(src)
	else
		to_chat(user, "<span class='notice'>You hit the metal foam but bounce off it.</span>")
	return TRUE


/obj/structure/foamedmetal/grab_attack(obj/item/grab/grab, mob/user)
	grab.affecting.forceMove(loc)
	visible_message(SPAN_DANGER("\The [user] smashes \the [grab.affecting] through the foamed metal wall!"))
	qdel(grab)
	physically_destroyed()
	return TRUE

/obj/structure/foamedmetal/attackby(var/obj/item/I, var/mob/user)
	if(prob(I.expend_attack_force(user) * 20 - metal * 25))
		user.visible_message(
			SPAN_WARNING("\The [user] smashes through the foamed metal."),
			SPAN_NOTICE("You smash through the foamed metal with \the [I].")
		)
		physically_destroyed()
	else
		to_chat(user, SPAN_WARNING("You hit \the [src] to no effect."))
	return TRUE
