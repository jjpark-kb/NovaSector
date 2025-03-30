/obj/item/research_item
	icon = 'modular_nova/modules/beginning_technology/beginning_tech.dmi'
	w_class = WEIGHT_CLASS_TINY

/**
 * Research Papers
 */
/datum/crafting_recipe/research_paper
	reqs = list(
		/obj/item/paper = 10,
	)
	result = /obj/item/research_item/research_paper
	time = 5 SECONDS
	category = CAT_TOOLS

/obj/item/research_item/research_paper
	name = "research paper"
	desc = "A very large piece of paper with tons of scribbled notes and diagrams. It seems quite hard to decipher, but perhaps spending some time can unlock secrets."
	icon_state = "research_paper"

	///the possible shapes to combine together
	var/static/list/shapes = list("cube", "sphere", "pyramid")

	///the list of currently discovered techs
	var/list/discovered_tech = list()

	///Contains images of all radial icons
	var/static/list/radial_icons_cache = list()

/obj/item/research_item/research_paper/Initialize(mapload)
	. = ..()
	if(!length(GLOB.beginning_technology))
		setup_tech_combos()

	radial_icons_cache = list(
		"cube" = image(icon = 'modular_nova/modules/beginning_technology/beginning_tech.dmi', icon_state = "cube"),
		"sphere" = image(icon = 'modular_nova/modules/beginning_technology/beginning_tech.dmi', icon_state = "sphere"),
		"pyramid" = image(icon = 'modular_nova/modules/beginning_technology/beginning_tech.dmi', icon_state = "pyramid"),
	)

/obj/item/research_item/research_paper/proc/setup_tech_combos()
	var/list/possible_combinations = list()
	for(var/first_shape in shapes)
		for(var/second_shape in shapes)
			for(var/third_shape in shapes)
				possible_combinations += "[first_shape][second_shape][third_shape]"

	for(var/datum_path in subtypesof(/datum/beginning_technology))
		var/shape_combination = pick_n_take(possible_combinations)
		GLOB.beginning_technology += list("[shape_combination]" = datum_path)

//if the research skill is in, add a check to require some proficiency in research
/obj/item/research_item/research_paper/attack_self(mob/user, modifiers)
	var/shape_one = show_radial_menu(user, src, radial_icons_cache, require_near = TRUE)
	if(isnull(shape_one))
		return

	if(!do_after(user, 5 SECONDS, target = src))
		to_chat(user, span_notice("You stopped researching."))
		return

	var/shape_two = show_radial_menu(user, src, radial_icons_cache, require_near = TRUE)
	if(isnull(shape_two))
		return

	if(!do_after(user, 5 SECONDS, target = src))
		to_chat(user, span_notice("You stopped researching."))
		return

	var/shape_three = show_radial_menu(user, src, radial_icons_cache, require_near = TRUE)
	if(isnull(shape_three))
		return

	if(!do_after(user, 5 SECONDS, target = src))
		to_chat(user, span_notice("You stopped researching."))
		return

	var/datum/beginning_technology/find_tech = GLOB.beginning_technology["[shape_one][shape_two][shape_three]"]
	if(isnull(find_tech))
		to_chat(user, span_warning("You were researching a dead end!"))
		return

	find_tech = new find_tech()
	var/missing_tech = length(find_tech.required_techs)
	for(var/discover_check in discovered_tech)
		if(is_type_in_list(discover_check, find_tech.required_techs))
			--missing_tech

	if(missing_tech > 0)
		to_chat(user, span_warning("You are missing [missing_tech] additional [missing_tech > 1 ? "technologies" : "technology"]!"))
		return

	if(!is_type_in_list(find_tech.type, discovered_tech))
		discovered_tech.Add(find_tech.type)

	var/obj/item/research_item/research_scrap/spawned_scrap = new /obj/item/research_item/research_scrap(get_turf(src))
	spawned_scrap.spawning_item = find_tech.researched_item
	spawned_scrap.spawning_tool = find_tech.required_tool
	for(var/obj/adding_requirements in find_tech.required_crafting)
		spawned_scrap.required_materials.Add(adding_requirements)
	to_chat(user, span_notice("You finished researching!."))

/obj/item/research_item/research_scrap
	name = "research scrap"
	desc = "A scrap piece of paper with deciphered notes and diagrams all pointing towards a piece of technology."
	icon = 'modular_nova/modules/beginning_technology/beginning_tech.dmi'
	icon_state = "research_scrap"

	///the spawning item when completed
	var/obj/spawning_item

	///the required tool for completing and spawning the item
	var/obj/spawning_tool

	///the materials required for completion
	var/list/required_materials = list()

/obj/item/research_item/research_scrap/examine(mob/user)
	. = ..()
	if(spawning_item)
		. += "This scrap will be able to create [spawning_item.name] when completed."

	for(var/obj/material_name in required_materials)
		. += "This scrap requires [material_name.name]."

	if(spawning_tool)
		. += "You are required to use [spawning_tool.name] to complete the research."

/obj/item/research_item/research_scrap/item_interaction(mob/living/user, obj/item/tool, list/modifiers)
	if(istype(tool, spawning_tool))
		if(length(required_materials) > 0)
			to_chat(user, span_warning("You have yet to put all required materials into [src]!"))
			return ITEM_INTERACT_BLOCKING

		if(!do_after(user, 5 SECONDS, target = src))
			to_chat(user, span_warning("You accidentally rip [src], scattering any collected materials!"))
			qdel(src)
			return ITEM_INTERACT_BLOCKING

		new spawning_item(get_turf(src))
		to_chat(user, span_notice("You were successful in creating [spawning_item]!"))
		qdel(src)
		return ITEM_INTERACT_BLOCKING

	if(is_type_in_list(tool, required_materials))
		if(required_materials[tool.type] == TRUE)
			to_chat(user, span_warning("[src] already has this material!"))
			return ITEM_INTERACT_BLOCKING

		if(istype(tool, /obj/item/stack))
			required_materials.Remove(tool.type)
			tool.use(1)

		else
			required_materials.Remove(tool.type)
			qdel(tool)

		to_chat(user, span_notice("You successfully added a material to [src]."))
		return ITEM_INTERACT_BLOCKING

	return ITEM_INTERACT_SUCCESS

/**
 * Stock Part Components
 */
/obj/item/research_item/capacitor_plate
	name = "capacitor plates"
	desc = "A piece of paper separates two conductive metal plates."
	icon_state = "cap_plate"

/obj/item/research_item/servo_motor
	name = "servo motor"
	desc = "a motor with a rod sticking out waiting for a connection."
	icon_state = "motor"

/obj/item/research_item/laser_lens
	name = "laser lens"
	desc = "a convex lens that has an edge around the side."
	icon_state = "lens"

/obj/item/research_item/part_casing
	name = "part casing"
	desc = "A metal shell that seems to have enough room to house some components."
	icon_state = "casing"

/**
 * Circuit
 */
/obj/item/research_item/computer_chip
	name = "computer chip"
	desc = "A small silicon chip that contributes with computing."
	icon_state = "chip"

/obj/item/research_item/empty_circuit
	name = "empty circuit"
	desc = "This is a circuit that is close to being finished; it just requires some forethought."
	icon_state = "circuit"

	/// list of circuits the empty circuit can become
	var/static/recycleable_circuits = typecacheof(list(
		/obj/item/electronics/airalarm,
		/obj/item/electronics/airlock,
		/obj/item/electronics/firealarm,
		/obj/item/electronics/firelock,
		/obj/item/electronics/apc,
	))

//when we get the research skill, require some research levels
/obj/item/research_item/empty_circuit/screwdriver_act(mob/living/user, obj/item/tool)
	var/circuit_choice = tgui_input_list(user, "Which circuit would you like to program?", "Circuit Creation", recycleable_circuits)
	if(isnull(circuit_choice))
		return

	if(!do_after(user, 5 SECONDS, src))
		to_chat(user, span_warning("You moved around, which results in [src] being destroyed!"))
		qdel(src)
		return

	new circuit_choice(get_turf(src))
	qdel(src)
