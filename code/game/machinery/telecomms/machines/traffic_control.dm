///Span classes that players are allowed to set in a radio transmission.
GLOBAL_LIST_INIT(allowed_custom_spans, list(
	SPAN_ROBOT,
	SPAN_YELL,
	SPAN_ITALICS,
	SPAN_SANS,
	SPAN_COMMAND,
	SPAN_CLOWN,
))

/obj/machinery/telecomms/traffic
	name = "traffic control computer"
	desc = "A computer used to interface with the programming of communication servers."
	icon = 'icons/obj/machines/computer.dmi'
	icon_state = "computer"
	density = TRUE
	telecomms_type = /obj/machinery/telecomms/traffic
	idle_power_usage = BASE_MACHINE_IDLE_CONSUMPTION * 0.01
	light_color = LIGHT_COLOR_GREEN
	circuit = /obj/item/circuitboard/computer/traffic_control

	var/icon_screen = "forensic"
	var/icon_keyboard = "power_key"

	var/datum/component/shell/shell
	var/obj/item/circuit_component/traffic_control/receive_signal/receivecomp
	var/obj/item/integrated_circuit/integrated_circuit

	var/list/active_servers = list() // List of active servers that this traffic control computer is linked to.

/obj/machinery/telecomms/traffic/Initialize(mapload)
	. = ..()
	integrated_circuit = new /obj/item/integrated_circuit(src)

	var/obj/item/circuit_component/traffic_control/relay_signal/relaycomp = new /obj/item/circuit_component/traffic_control/relay_signal
	receivecomp = new /obj/item/circuit_component/traffic_control/receive_signal

	relaycomp.datum.connect(receivecomp.datum)
	relaycomp.data.connect(receivecomp.data)
	relaycomp.trigger_input.connect(receivecomp.trigger_output)

	shell = AddComponent(\
		/datum/component/shell/traffic_control, \
		unremovable_circuit_components = list(relaycomp, receivecomp), \
		capacity = SHELL_CAPACITY_VERY_LARGE, \
		shell_flags = SHELL_FLAG_CIRCUIT_UNREMOVABLE, \
		starting_circuit = integrated_circuit)

	integrated_circuit.forceMove(src)

	RegisterSignal(shell.attached_circuit, COMSIG_CIRCUIT_PRE_POWER_USAGE, PROC_REF(use_energy_for_circuits))

// Computer Procs
/obj/machinery/telecomms/traffic/screwdriver_act(mob/living/user, obj/item/I)
	if(..())
		return TRUE
	if(circuit)
		balloon_alert(user, "disconnecting monitor...")
		if(I.use_tool(src, user, time_to_unscrew, volume=50))
			deconstruct(TRUE)
	return TRUE

/obj/machinery/telecomms/traffic/power_change()
	. = ..()
	set_light(!!(machine_stat & NOPOWER))

/obj/machinery/telecomms/traffic/update_overlays()
	. = ..()
	if(machine_stat & NOPOWER)
		. += mutable_appearance(icon, "[icon_keyboard]_off")
		return

	. += mutable_appearance(icon, icon_keyboard)
	if(machine_stat & BROKEN)
		. += mutable_appearance(icon, "[icon_state]_broken")
		return
	. += mutable_appearance(icon, icon_screen)

/obj/machinery/telecomms/traffic/spawn_frame(disassembled)
	if(QDELETED(circuit)) //no circuit, no computer frame
		return

	var/obj/structure/frame/computer/new_frame = new(loc)
	new_frame.setDir(dir)
	new_frame.set_anchored(TRUE)
	new_frame.circuit = circuit
	// Circuit removal code is handled in /obj/machinery/Exited()
	component_parts -= circuit
	circuit.forceMove(new_frame)

	if((machine_stat & BROKEN) || !disassembled)
		var/atom/drop_loc = drop_location()
		playsound(src, 'sound/effects/hit_on_shattered_glass.ogg', 70, TRUE)
		new /obj/item/shard(drop_loc)
		new /obj/item/shard(drop_loc)
		new_frame.state = FRAME_COMPUTER_STATE_WIRED
	else
		new_frame.state = FRAME_COMPUTER_STATE_GLASSED
	new_frame.update_appearance()

/obj/machinery/telecomms/traffic/play_attack_sound(damage_amount, damage_type = BRUTE, damage_flag = 0)
	switch(damage_type)
		if(BRUTE)
			if(machine_stat & BROKEN)
				playsound(src.loc, 'sound/effects/hit_on_shattered_glass.ogg', 70, TRUE)
			else
				playsound(src.loc, 'sound/effects/glass/glasshit.ogg', 75, TRUE)
		if(BURN)
			playsound(src.loc, 'sound/items/tools/welder.ogg', 100, TRUE)

/obj/machinery/telecomms/traffic/atom_break(damage_flag)
	if(!circuit) //no circuit, no breaking
		return
	. = ..()
	if(.)
		playsound(loc, 'sound/effects/glass/glassbr3.ogg', 100, TRUE)
		set_light(0)

// Computer Procs

/obj/machinery/telecomms/traffic/add_new_link(obj/machinery/telecomms/new_connection, mob/user)
	if(istype(new_connection, /obj/machinery/component_printer))
		integrated_circuit.linked_component_printer = WEAKREF(new_connection)
	return ..()

/obj/machinery/telecomms/traffic/after_add_link(obj/machinery/telecomms/new_connection)
	if(istype(new_connection, /obj/machinery/telecomms/server) && !active_servers[new_connection])
		active_servers[new_connection] = FALSE

/obj/machinery/telecomms/traffic/after_remove_link(obj/machinery/telecomms/old_connection)
	active_servers -= old_connection

/obj/machinery/telecomms/traffic/add_option()
	var/list/data = list()
	data["type"] = "traffic"
	data["connected_servers"] = list()
	var/list/connected_servers = list()
	for(var/obj/machinery/telecomms/server/server in active_servers)
		var/list/server_data = list()
		server_data["server_name"] = server.name
		server_data["server_ref"] = REF(server)
		server_data["server_active"] = active_servers[server]
		connected_servers += list(server_data)
	data["connected_servers"] = connected_servers
	return data

/obj/machinery/telecomms/traffic/add_act(action, params)
	switch(action)
		if("open_circuit")
			if(shell.locked)
				balloon_alert(usr, "it's locked!")
				return
			shell.attached_circuit.interact(usr)
			. = TRUE
		if("toggle_server")
			var/obj/machinery/telecomms/server/server = locate(params["server_ref"])
			if(!server || !(server in active_servers))
				return FALSE
			active_servers[server] = !active_servers[server]
			. = TRUE

/obj/machinery/telecomms/traffic/proc/use_energy_for_circuits(datum/source, power_to_use)
	if(use_energy(power_to_use))
		return COMPONENT_OVERRIDE_POWER_USAGE

/obj/machinery/telecomms/traffic/receive_information(datum/signal/subspace/vocal/signal, obj/machinery/telecomms/machine_from)
	if(!is_freq_listening(signal))
		return

	if(istype(machine_from, /obj/machinery/telecomms/server))
		receivecomp.on_received_signal(signal)

/obj/machinery/telecomms/traffic/AllowDrop()
	return TRUE

/obj/machinery/telecomms/traffic/preset
	id = "traffic"
	network = "tcommsat"
	autolinkers = list(
		"science",
		"medical",
		"supply",
		"service",
		"common",
		"command",
		"engineering",
		"entertainment",
		"security",
	)

/obj/machinery/telecomms/traffic/preset/Initialize(mapload)
	. = ..()
	for(var/obj/machinery/component_printer/printer as anything in SSmachines.get_machines_by_type(/obj/machinery/component_printer))
		if(printer.z != src.z)
			continue
		add_new_link(printer)

/obj/item/circuit_component/traffic_control/relay_signal
	display_name = "Relay Signal"
	circuit_flags = CIRCUIT_FLAG_INPUT_SIGNAL
	var/datum/port/input/datum
	var/datum/port/input/data

/obj/item/circuit_component/traffic_control/relay_signal/populate_ports()
	datum = add_input_port("Signal Datum", PORT_SUBTYPE_VOCAL_SIGNAL, trigger = null)
	data = add_input_port("Signal Data", PORT_TYPE_ASSOC_LIST(PORT_TYPE_STRING, PORT_TYPE_ANY), trigger = null)

/obj/item/circuit_component/traffic_control/relay_signal/input_received(datum/port/input/port)
	if(!attached_computer)
		return
	INVOKE_ASYNC(src, PROC_REF(handle_relay_signal), datum.value, data.value)

/obj/item/circuit_component/traffic_control/receive_signal
	display_name = "Receive Signal"
	circuit_flags = CIRCUIT_FLAG_OUTPUT_SIGNAL
	var/datum/port/output/datum
	var/datum/port/output/data

/obj/item/circuit_component/traffic_control/receive_signal/populate_ports()
	datum = add_output_port("Signal Datum", PORT_SUBTYPE_VOCAL_SIGNAL)
	data = add_output_port("Signal Data", PORT_TYPE_ASSOC_LIST(PORT_TYPE_STRING, PORT_TYPE_ANY))

/obj/item/circuit_component/traffic_control/receive_signal/proc/on_received_signal(datum/signal/subspace/vocal/received_signal)
	var/datum/language/language = received_signal.language
	var/list/signal_data = list(
		"content" = html_decode(received_signal.data["message"]),
		"freq" = received_signal.frequency,
		"source" = received_signal.data["name"],
		"sector" = received_signal.levels,
		"job" = received_signal.data["job"],
		"pass" = !(received_signal.data["reject"]),
		"filters" = received_signal.data["spans"],
		"language" = "[language::name]",
		"say" = received_signal.virt.verb_say,
		"ask" = received_signal.virt.verb_ask,
		"yell" = received_signal.virt.verb_yell,
		"exclaim" = received_signal.virt.verb_exclaim,
	)
	datum.set_output(received_signal)
	data.set_output(signal_data)
	trigger_output.set_output(COMPONENT_SIGNAL)
