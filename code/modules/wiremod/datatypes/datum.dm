/datum/circuit_datatype/datum
	datatype = PORT_TYPE_DATUM
	color = "yellow"
	datatype_flags = DATATYPE_FLAG_ALLOW_MANUAL_INPUT|DATATYPE_FLAG_ALLOW_ATOM_INPUT
	can_receive_from = list(
		PORT_TYPE_ATOM,
		PORT_TYPE_USER
	)

/datum/circuit_datatype/datum/convert_value(datum/port/port, value_to_convert)
	var/datum/object = value_to_convert
	if(QDELETED(object))
		return null
	return object

/datum/circuit_datatype/datum/vocal_signal
	datatype = PORT_SUBTYPE_VOCAL_SIGNAL
	parent_datatype = PORT_TYPE_DATUM
	color = "red"
	datatype_flags = NONE
	can_receive_from = list()
