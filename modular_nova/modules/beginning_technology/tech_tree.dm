GLOBAL_LIST_EMPTY(beginning_technology)

/datum/beginning_technology
	///the item that will be created from using the required items
	var/researched_item

	///the required items to spawn the researched item
	var/list/required_items

	///the tool that is required to spawn the researched item
	var/required_tool = /obj/item/forging/hammer

	///the required techs before this can be researched; each item should be set to FALSE and then set to TRUE when fulfilled
	var/list/required_techs

	//if the research skill is merged, perhaps adding a research level requirement would be good

/**
 * Stock Part Components
 */
/datum/beginning_technology/part_casing
	researched_item = /obj/item/research_item/part_casing
	required_items = list(
		/obj/item/stack/sheet/iron,
	)

/datum/beginning_technology/capacitor_plate
	researched_item = /obj/item/research_item/capacitor_plate
	required_items = list(
		/obj/item/stack/sheet/iron,
		/obj/item/paper,
	)

/datum/beginning_technology/servo_motor
	researched_item = /obj/item/research_item/servo_motor
	required_items = list(
		/obj/item/stack/sheet/iron,
	)

/datum/beginning_technology/laser_lens
	researched_item = /obj/item/research_item/laser_lens
	required_items = list(
		/obj/item/stack/sheet/glass,
	)

/**
 * Stock Parts
 */
/datum/beginning_technology/t1_capacitor
	researched_item = /obj/item/stock_parts/capacitor
	required_items = list(
		/obj/item/research_item/capacitor_plate,
		/obj/item/research_item/part_casing,
	)

/datum/beginning_technology/t1_servo
	researched_item = /obj/item/stock_parts/servo
	required_items = list(
		/obj/item/research_item/servo_motor,
		/obj/item/research_item/part_casing,
	)

/datum/beginning_technology/t1_matterbin
	researched_item = /obj/item/stock_parts/matter_bin
	required_items = list(
		/obj/item/stack/sheet/iron,
		/obj/item/research_item/part_casing,
	)

/datum/beginning_technology/t1_microlaser
	researched_item = /obj/item/stock_parts/micro_laser
	required_items = list(
		/obj/item/research_item/laser_lens,
		/obj/item/research_item/part_casing,
	)

/datum/beginning_technology/t1_scanningmod
	researched_item = /obj/item/stock_parts/scanning_module
	required_items = list(
		/obj/item/research_item/laser_lens,
		/obj/item/research_item/part_casing,
	)
	required_techs = list(
		/datum/beginning_technology/t1_microlaser,
	)

/datum/beginning_technology/t1_powercell
	researched_item = /obj/item/stock_parts/power_store/cell/lead
	required_items = list(
		/obj/item/research_item/capacitor_plate,
		/obj/item/research_item/part_casing,
	)
	required_techs = list(
		/datum/beginning_technology/t1_capacitor,
	)

/datum/beginning_technology/cable
	researched_item = /obj/item/stack/cable_coil/five
	required_items = list(
		/obj/item/stack/sheet/iron,
		/obj/item/stack/sheet/mineral/gold,
	)

/**
 * Circuit
 */
/datum/beginning_technology/computer_chip
	researched_item = /obj/item/research_item/computer_chip
	required_items = list(
		/obj/item/forging/complete/plate,
	)
	required_tool = /obj/item/screwdriver
	required_techs = list(
		/datum/beginning_technology/part_casing,
	)

/datum/beginning_technology/empty_circuit
	researched_item = /obj/item/research_item/empty_circuit
	required_items = list(
		/obj/item/research_item/computer_chip,
		/obj/item/forging/complete/plate,
	)
	required_techs = list(
		/datum/beginning_technology/computer_chip,
	)
