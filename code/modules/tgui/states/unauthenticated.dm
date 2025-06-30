/**
 * tgui state: new_player_state
 *
 * Checks that the user is a /mob/dead/new_player
 */

GLOBAL_DATUM_INIT(unauthenticated_state, /datum/ui_state/unauthenticated_state, new)

/datum/ui_state/unauthenticated_state/can_use_topic(src_object, mob/user)
	var/client/client = user.client
	return client?.unauthenticated ? UI_INTERACTIVE : UI_CLOSE
