
/obj/item/circuit_component/traffic_control
	var/obj/machinery/telecomms/traffic/attached_computer
	required_shells = list(/obj/machinery/telecomms/traffic)

/obj/item/circuit_component/traffic_control/register_shell(atom/movable/shell)
	. = ..()
	if(istype(shell, /obj/machinery/telecomms/traffic))
		attached_computer = shell

/obj/item/circuit_component/traffic_control/unregister_shell(atom/movable/shell)
	attached_computer = null
	return ..()

/obj/item/circuit_component/traffic_control/proc/handle_relay_signal(datum/signal/subspace/vocal/received, list/data, datum/callback/after_relay)
	if(!istype(received) || !attached_computer)
		return

	process_signal(received, data)

	var/can_send = attached_computer.relay_information(received, /obj/machinery/telecomms/hub)
	if(!can_send)
		attached_computer.relay_information(received, /obj/machinery/telecomms/broadcaster)
	if(after_relay)
		after_relay.Invoke()

/obj/item/circuit_component/traffic_control/proc/process_signal(datum/signal/subspace/vocal/signal, list/data)
	if(!data || !data.len)
		return

	// Signal data
	var/list/signal_data = list(
		"content" = html_decode(signal.data["message"]),
		"freq" = signal.frequency,
		"source" = signal.data["name"],
		"sector" = signal.levels,
		"job" = signal.data["job"],
		"pass" = !(signal.data["reject"]),
		"filters" = signal.data["spans"],
		"language" = "[signal.language::name]",
		"say" = signal.virt.verb_say,
		"ask" = signal.virt.verb_ask,
		"yell" = signal.virt.verb_yell,
		"exclaim" = signal.virt.verb_exclaim,
	)

	for(var/data_type in data)
		var/data_value = data[data_type]
		signal_data[data_type] = data_value

	// Backwards-apply variables onto signal data
	/* sanitize EVERYTHING. players can't be trusted with SHIT */

	var/msg = signal_data["content"]
	if(isnum(msg))
		msg = "[msg]"
	else if(!msg)
		msg = "*beep*"
	signal.data["message"] = msg

	signal.frequency = signal_data["freq"]

	var/setname = signal_data["source"]

	if(signal.data["name"] != setname)
		signal.data["realname"] = signal.data["name"]
		signal.virt.name = setname
	signal.data["name"] = setname

	signal.levels = signal_data["sector"]
	signal.data["job"] = signal_data["job"]
	signal.data["reject"] = !(signal_data["pass"])

	var/datum/language/newlang = GLOB.language_types_by_name[signal_data["language"]]
	if(newlang)
		signal.language = newlang
		signal.data["language"] = newlang

	signal.virt.verb_say = signal_data["say"]
	signal.virt.verb_ask = signal_data["ask"]
	signal.virt.verb_yell = signal_data["yell"]
	signal.virt.verb_exclaim = signal_data["exclaim"]
	var/list/setspans = signal_data["filters"] //Save the span vector/list to a holder list
	if(islist(setspans)) //Players cannot be trusted with ANYTHING. At all. Ever.
		setspans &= GLOB.allowed_custom_spans //Prune out any illegal ones. Go ahead, comment this line out. See the horror you can unleash!
		signal.data["spans"] = setspans //Apply new span to the signal only if it is a valid list, made using $filters & vector() in the script.
	else
		signal.data["spans"] = list()

	// If the message is invalid, just don't broadcast it!
	if(signal.data["message"] == "" || !signal.data["message"])
		signal.data["reject"] = TRUE
