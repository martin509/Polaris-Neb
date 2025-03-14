/*
  A system for easily and quickly removing your own bodyparts, with a view towards
  swapping them out for new ones, or just doing it as a party trick to horrify an
  audience. Current implementation only supports robolimbs and uses a modular_bodypart
  value on the manufacturer datum, but I have tried to keep it generic for future work.
  PS. jesus christ this was meant to be a half an hour port
*/

// External organ procs:
// Does this bodypart count as a modular limb, and if so, what kind?
/obj/item/organ/external/proc/get_modular_limb_category()
	return isnull(bodytype?.modular_limb_tier) ? MODULAR_BODYPART_INVALID : bodytype.modular_limb_tier

// Checks if a limb could theoretically be removed.
// Note that this does not currently bother checking if a child or internal organ is vital.
/obj/item/organ/external/proc/can_remove_modular_limb(var/mob/living/human/user)
	if((owner?.species && is_vital_to_owner()) || !(limb_flags & ORGAN_FLAG_CAN_AMPUTATE))
		return FALSE
	var/bodypart_cat = get_modular_limb_category()
	if(bodypart_cat == MODULAR_BODYPART_CYBERNETIC)
		if(!parent_organ)
			return FALSE
		var/obj/item/organ/external/parent = user && GET_EXTERNAL_ORGAN(user, parent_organ)
		if(!parent || parent.get_modular_limb_category(user) < MODULAR_BODYPART_CYBERNETIC)
			return FALSE
	. = (bodypart_cat != MODULAR_BODYPART_INVALID)

// Note that this proc is checking if the organ can be attached -to-, not attached itself.
/obj/item/organ/external/proc/can_attach_modular_limb_here(var/mob/living/human/user)
	var/list/limb_data = user?.get_bodytype()?.has_limbs[organ_tag]
	if(islist(limb_data) && limb_data["has_children"] > 0)
		. = (LAZYLEN(children) < limb_data["has_children"])

/obj/item/organ/external/proc/can_be_attached_modular_limb(var/mob/living/user)
	var/bodypart_cat = get_modular_limb_category()
	if(bodypart_cat == MODULAR_BODYPART_INVALID)
		return FALSE
	if(!parent_organ)
		return FALSE
	var/obj/item/organ/external/parent = user && GET_EXTERNAL_ORGAN(user, parent_organ)
	if(!parent)
		return FALSE
	if(!parent.can_attach_modular_limb_here(user))
		return FALSE
	if(bodypart_cat == MODULAR_BODYPART_CYBERNETIC && parent.get_modular_limb_category(src) < MODULAR_BODYPART_CYBERNETIC)
		return FALSE
	return TRUE

// Checks if an organ (or the parent of one) is in a fit state for modular limb stuff to happen.
/obj/item/organ/external/proc/check_modular_limb_damage(var/mob/living/human/user)
	. =  damage >= min_broken_damage || (status & ORGAN_BROKEN) // can't use is_broken() as the limb has ORGAN_CUT_AWAY

// Human mob procs:
// Checks the organ list for limbs meeting a predicate. Way overengineered for such a limited use
// case but I can see it being expanded in the future if meat limbs or doona limbs use it.
/mob/living/human/proc/get_modular_limbs(var/return_first_found = FALSE, var/validate_proc)
	for(var/obj/item/organ/external/limb as anything in get_external_organs())
		if(!validate_proc || call(limb, validate_proc)(src) > MODULAR_BODYPART_INVALID)
			LAZYADD(., limb)
			if(return_first_found)
				return
	// Prune children so we can't remove every individual component of an entire prosthetic arm
	// piece by piece. Technically a circular dependency here would remove the limb entirely but
	// if there's a parent whose child is also its parent, there's something wrong regardless.
	for(var/obj/item/organ/external/limb as anything in .)
		if(length(limb.children))
			. -= limb.children

// Called in bodytype.apply_bodytype_organ_modifications(), replaced() and removed() to update our modular limb verbs.
/mob/living/human/proc/refresh_modular_limb_verbs()
	if(length(get_modular_limbs(return_first_found = TRUE, validate_proc = /obj/item/organ/external/proc/can_attach_modular_limb_here)))
		verbs |= .proc/attach_limb_verb
	else
		verbs -= .proc/attach_limb_verb
	if(length(get_modular_limbs(return_first_found = TRUE, validate_proc = /obj/item/organ/external/proc/can_remove_modular_limb)))
		verbs |= .proc/detach_limb_verb
	else
		verbs -= .proc/detach_limb_verb

// Proc helper for attachment verb.
/mob/living/human/proc/check_can_attach_modular_limb(var/obj/item/organ/external/E)
	if(is_on_special_ability_cooldown() || get_active_held_item() != E)
		return FALSE
	if(incapacitated() || restrained())
		to_chat(src, SPAN_WARNING("You can't do that in your current state!"))
		return FALSE
	if(QDELETED(E) || !istype(E))
		to_chat(src, SPAN_WARNING("You are not holding a compatible limb to attach."))
		return FALSE
	if(!E.can_be_attached_modular_limb(src))
		to_chat(src, SPAN_WARNING("\The [E] cannot be attached to your current body."))
		return FALSE
	if(E.get_modular_limb_category() <= MODULAR_BODYPART_INVALID)
		to_chat(src, SPAN_WARNING("\The [E] cannot be attached by your own hand."))
		return FALSE
	if(GET_EXTERNAL_ORGAN(src, E.organ_tag))
		to_chat(src, SPAN_WARNING("There is already a limb attached at that part of your body."))
		return FALSE
	if(E.check_modular_limb_damage(src))
		to_chat(src, SPAN_WARNING("\The [E] is too damaged to be attached."))
		return FALSE
	var/obj/item/organ/external/parent = E.parent_organ && GET_EXTERNAL_ORGAN(src, E.parent_organ)
	if(!parent)
		to_chat(src, SPAN_WARNING("\The [E] needs an existing limb to be attached to."))
		return FALSE
	if(parent.check_modular_limb_damage(src))
		to_chat(src, SPAN_WARNING("Your [parent.name] is too damaged to have anything attached."))
		return FALSE
	return TRUE

// Proc helper for detachment verb.
/mob/living/human/proc/check_can_detach_modular_limb(var/obj/item/organ/external/E)
	if(is_on_special_ability_cooldown())
		return FALSE
	if(incapacitated() || restrained())
		to_chat(src, SPAN_WARNING("You can't do that in your current state!"))
		return FALSE
	if(!istype(E) || QDELETED(src) || QDELETED(E) || E.owner != src || E.loc != src)
		return FALSE
	if(E.check_modular_limb_damage(src))
		to_chat(src, SPAN_WARNING("That limb is too damaged to be removed!"))
		return FALSE
	var/obj/item/organ/external/parent = E.parent_organ && GET_EXTERNAL_ORGAN(src, E.parent_organ)
	if(!parent)
		return FALSE
	if(parent.check_modular_limb_damage(src))
		to_chat(src, SPAN_WARNING("Your [parent.name] is too damaged to detach anything from it."))
		return FALSE
	return (E in get_modular_limbs(return_first_found = FALSE, validate_proc = /obj/item/organ/external/proc/can_remove_modular_limb))

// Verbs below:
// Add or remove robotic limbs; check refresh_modular_limb_verbs() above.
/mob/living/human/proc/attach_limb_verb()
	set name = "Attach Limb"
	set category = "Object"
	set desc = "Attach a replacement limb."
	set src = usr

	var/obj/item/organ/external/E = get_active_held_item()
	if(!check_can_attach_modular_limb(E))
		return FALSE
	if(!do_after(src, 2 SECONDS, src))
		return FALSE
	if(!check_can_attach_modular_limb(E))
		return FALSE

	set_special_ability_cooldown(2 SECONDS)
	drop_from_inventory(E)
	src.add_organ(E)

	// Reconnect the organ and children as normally this is done with surgery.
	E.status &= ~ORGAN_CUT_AWAY
	for(var/obj/item/organ/external/child in E.children)
		child.status &= ~ORGAN_CUT_AWAY

	var/decl/pronouns/pronouns = get_pronouns()
	visible_message(
		SPAN_NOTICE("\The [src] attaches \the [E] to [pronouns.his] body!"),
		SPAN_NOTICE("You attach \the [E] to your body!"))
	try_refresh_visible_overlays() // Not sure why this isn't called by removed(), but without it we don't update our limb appearance.
	return TRUE

/mob/living/human/proc/detach_limb_verb()
	set name = "Remove Limb"
	set category = "Object"
	set desc = "Detach one of your limbs."
	set src = usr

	var/list/detachable_limbs = get_modular_limbs(return_first_found = FALSE, validate_proc = /obj/item/organ/external/proc/can_remove_modular_limb)
	if(!length(detachable_limbs))
		to_chat(src, SPAN_WARNING("You have no detachable limbs."))
		return FALSE
	var/obj/item/organ/external/E = input(usr, "Which limb do you wish to detach?", "Limb Removal") as null|anything in detachable_limbs
	if(!check_can_detach_modular_limb(E))
		return FALSE
	if(!do_after(src, 2 SECONDS, src))
		return FALSE
	if(!check_can_detach_modular_limb(E))
		return FALSE

	set_special_ability_cooldown(2 SECONDS)
	remove_organ(E, update_icon = TRUE)
	E.dropInto(loc)
	put_in_hands(E)
	var/decl/pronouns/pronouns = get_pronouns()
	visible_message(
		SPAN_NOTICE("\The [src] detaches [pronouns.his] [E.name]!"),
		SPAN_NOTICE("You detach your [E.name]!"))
	return TRUE
