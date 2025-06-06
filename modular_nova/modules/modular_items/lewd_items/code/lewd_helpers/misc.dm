/*
*	Looping sound for vibrating stuff
*/

/datum/looping_sound/lewd/vibrator
	start_sound = 'modular_nova/modules/modular_items/lewd_items/sounds/bzzz-loop-1.ogg'
	start_length = 1
	mid_sounds = 'modular_nova/modules/modular_items/lewd_items/sounds/bzzz-loop-1.ogg'
	mid_length = 1
	end_sound = 'modular_nova/modules/modular_items/lewd_items/sounds/bzzz-loop-1.ogg'
	falloff_distance = 1
	falloff_exponent = 5
	extra_range = SILENCED_SOUND_EXTRARANGE
	ignore_walls = FALSE

/datum/looping_sound/lewd/vibrator/low
	volume = 80

/datum/looping_sound/lewd/vibrator/medium
	volume = 90

/datum/looping_sound/lewd/vibrator/high
	volume = 100

/// Used to add a cum decal to the floor while transferring viruses and DNA to it
/mob/living/proc/add_cum_splatter_floor(turf/the_turf, female = FALSE)
	if(!the_turf)
		the_turf = get_turf(src)

	var/selected_type = female ? /obj/effect/decal/cleanable/cum/femcum : /obj/effect/decal/cleanable/cum
	var/atom/stain = new selected_type(the_turf, get_static_viruses())

	stain.add_mob_blood(src) //I'm not adding a new forensics category for cumstains
