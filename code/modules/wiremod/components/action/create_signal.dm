/obj/item/circuit_component/traffic_control/create_signal
	display_name = "Create Signal"
	circuit_flags = CIRCUIT_FLAG_INPUT_SIGNAL | CIRCUIT_FLAG_OUTPUT_SIGNAL
	/// Message input
	var/datum/port/input/message_input
	/// Frequency input
	var/datum/port/input/freq_input
	/// Source input
	var/datum/port/input/source_input

	var/datum/port/output/signal_datum_output
	var/datum/port/output/signal_data_output

/obj/item/circuit_component/traffic_control/create_signal/populate_ports()
	message_input = add_input_port("Message", PORT_TYPE_STRING, trigger = null)
	freq_input = add_input_port("Frequency", PORT_TYPE_NUMBER, default = FREQ_COMMON)
	source_input = add_input_port("Source", PORT_TYPE_STRING, trigger = null)

	signal_datum_output = add_output_port("Signal Datum", PORT_SUBTYPE_VOCAL_SIGNAL)
	signal_data_output = add_output_port("Signal Data", PORT_TYPE_ASSOC_LIST(PORT_TYPE_STRING, PORT_TYPE_ANY))

/obj/item/circuit_component/traffic_control/create_signal/pre_input_received(datum/port/input/port)
	freq_input.set_value(sanitize_frequency(freq_input.value, TRUE))

/obj/item/circuit_component/traffic_control/create_signal/input_received(datum/port/input/port)
	if(!attached_computer)
		return
	INVOKE_ASYNC(src, PROC_REF(handle_create_signal), port)

/obj/item/circuit_component/traffic_control/create_signal/proc/handle_create_signal(datum/port/input/port)
	if(COMPONENT_TRIGGERED_BY(trigger_input, port))
		var/message = message_input.value
		var/freq = freq_input.value
		var/source = source_input.value

		if(!message)
			message = "*beep*"

		if(!source)
			source = "[html_encode(uppertext(attached_computer.name))]"

		if(!freq)
			freq = 1459

		var/job = "Unknown"
		var/atom/movable/virtualspeaker/virt = new
		virt.name = source
		virt.job = job

		var/datum/signal/subspace/vocal/newsign = new(attached_computer, freq, virt, /datum/language/common, message, list(), list(), list(src.z))
		newsign.data["mob"] = virt
		newsign.data["mobtype"] = /mob/living/carbon/human
		newsign.data["realname"] = source
		newsign.data["uuid"] = source
		newsign.data["compression"] = 0

		var/list/signal_data = list(
			"content" = html_decode(message),
			"freq" = freq,
			"source" = source,
			"sector" = newsign.levels,
			"job" = job,
			"pass" = !(newsign.data["reject"]),
			"filters" = list(),
		)
		signal_datum_output.set_output(newsign)
		signal_data_output.set_output(signal_data)
		trigger_output.set_output(COMPONENT_SIGNAL)
