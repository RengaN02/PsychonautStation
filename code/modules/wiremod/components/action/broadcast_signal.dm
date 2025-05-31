/obj/item/circuit_component/traffic_control/broadcast_signal
	display_name = "Broadcast Signal"
	circuit_flags = CIRCUIT_FLAG_INPUT_SIGNAL | CIRCUIT_FLAG_OUTPUT_SIGNAL
	var/datum/port/input/datum
	var/datum/port/input/data

/obj/item/circuit_component/traffic_control/broadcast_signal/populate_ports()
	datum = add_input_port("Signal Datum", PORT_SUBTYPE_VOCAL_SIGNAL, trigger = null)
	data = add_input_port("Signal Data", PORT_TYPE_ASSOC_LIST(PORT_TYPE_STRING, PORT_TYPE_ANY), trigger = null)

/obj/item/circuit_component/traffic_control/broadcast_signal/input_received(datum/port/input/port)
	if(!attached_computer)
		return
	INVOKE_ASYNC(src, PROC_REF(handle_relay_signal), datum.value, data.value, CALLBACK(src, PROC_REF(after_broadcasted)))

/obj/item/circuit_component/traffic_control/broadcast_signal/proc/after_broadcasted()
	trigger_output.set_output(COMPONENT_SIGNAL)
