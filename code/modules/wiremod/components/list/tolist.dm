/**
 * # Split component
 *
 * Splits a string
 */
/obj/item/circuit_component/tolist
	display_name = "To List"
	desc = "A component that converts its input to list."
	category = "List"

	/// The input port
	var/datum/port/input/input_port

	/// The result from the output
	var/datum/port/output/output

	circuit_flags = CIRCUIT_FLAG_INPUT_SIGNAL|CIRCUIT_FLAG_OUTPUT_SIGNAL

/obj/item/circuit_component/tolist/populate_ports()
	input_port = add_input_port("Input", PORT_TYPE_ANY)
	populate_list_port()

/obj/item/circuit_component/tolist/proc/populate_list_port()
	output = add_output_port("Output", PORT_TYPE_LIST(PORT_TYPE_ANY))

/obj/item/circuit_component/tolist/input_received(datum/port/input/port)

	var/list/value = input_port.value
	if(isnull(value))
		return

	if(!islist(value))
		value = list(value)

	output.set_output(value)

/obj/item/circuit_component/tolist/assoc
	display_name = "To Associative List"

/obj/item/circuit_component/tolist/assoc/populate_list_port()
	output = add_output_port("Output", PORT_TYPE_ASSOC_LIST(PORT_TYPE_ANY, PORT_TYPE_ANY))

/obj/item/circuit_component/tolist/assoc/input_received(datum/port/input/port)

	var/list/value = input_port.value
	if(isnull(value))
		return

	if(!is_assoc_list(value))
		value = list("1" = value)

	output.set_output(value)
