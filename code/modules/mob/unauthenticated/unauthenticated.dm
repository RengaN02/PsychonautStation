GLOBAL_LIST_EMPTY(permitted_guests)

/mob/unauthenticated
	invisibility = INVISIBILITY_ABSTRACT
	density = FALSE
	anchored = TRUE
	sight = BLIND
	stat = DEAD

	var/static/valid_characters = splittext("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789", "")
	var/access_code

	var/datum/tgui_window/unauthenticated_menu

	var/new_ckey

	COOLDOWN_DECLARE(recall_code_cooldown)

/mob/unauthenticated/New(loc, ...)
	. = ..()

	GLOB.dead_mob_list -= src
	ADD_TRAIT(src, TRAIT_IMMOBILIZED, "Unauthenticated")

/mob/unauthenticated/Login()
	. = ..()

	var/static/datum/preferences/dummy_preferences
	if(!dummy_preferences)
		dummy_preferences = new()

	client.prefs = dummy_preferences

/mob/unauthenticated/set_logged_in_mob()
	return FALSE

/// Creates our authentication request, stores the code in the database and on us
/mob/unauthenticated/proc/create_authentication_request()

	access_code = generate_access_code()

	var/datum/db_query/query_log_auth = SSdbcore.NewQuery({"
		INSERT INTO [format_table_name("authentication_requests")] (access_code, timestamp)
		VALUES (:access_code, NOW())
	"}, list(
		"access_code" = access_code
	))
	query_log_auth.Execute()
	qdel(query_log_auth)

#define ACCESS_CODE_LENGTH 20

/// Creates a base 62 access code
/mob/unauthenticated/proc/generate_access_code()
	var/code = ""

	for(var/i in 1 to ACCESS_CODE_LENGTH)
		code += pick(valid_characters)

	return code

#undef ACCESS_CODE_LENGTH

/// Polls the database to see if our access code has been validated
/mob/unauthenticated/proc/check_logged_in(code)
	if(new_ckey)
		return

	var/query = "SELECT external_username, authentication_method, access_code, time, approved FROM [format_table_name("discord_links")] WHERE access_code = :access_code AND access_code = :access_code AND timestamp >= Now() - INTERVAL 4 HOUR LIMIT 1"
	var/datum/db_query/query_get_discord_link_record = SSdbcore.NewQuery(
		query,
		list("approved" = TRUE, "access_code" = code ? code : access_code)
	)
	if(!query_get_discord_link_record.Execute())
		qdel(query_get_discord_link_record)
		return
	var/result
	if(query_get_discord_link_record.NextRow())
		result = query_get_discord_link_record.item

	if(!result)
		if(!code)
			addtimer(CALLBACK(src, PROC_REF(check_logged_in)), 5 SECONDS)
		return

	var/external_username = result[1]
	var/authentication_method = result[2]
	if(external_username)
		client.external_username = ckey(external_username)

		var/middle = ""
		if(authentication_method)
			middle = "[capitalize(authentication_method)]-"

		new_ckey = "Guest-[middle][client.external_username]"

	if(!code)
		notify_unauthenticated_menu()

	if(world.IsBanned(new_ckey, client.address, client.computer_id, real_bans_only = TRUE))
		unauthenticated_menu.send_message("banned")
		QDEL_IN(client, 10 SECONDS)
		return FALSE

	message_admins("Non-BYOND user [new_ckey] (previously [key]) has been authenticated via [authentication_method].")

	log_in()

/// Switches the clients ckey, and continues the logging in
/mob/unauthenticated/proc/log_in()
	// Grab our client from the directory based on the *old* Guest ckey
	var/client/user = GLOB.directory[ckey]
	GLOB.directory -= ckey

	user.key = new_ckey
	GLOB.permitted_guests |= user.key

	// Readd the client to the directory with the *new* Guest ckey
	GLOB.directory[ckey] = user

	var/list/pre_data = user.PreLogin()

	var/mob/new_mob = GLOB.ckey_to_occupied_mob[user.ckey]
	if(QDELETED(new_mob))
		new_mob = new /mob/dead/new_player()

	new_mob.client = user

	new_mob.client.PostLogin(pre_data = pre_data)

/mob/unauthenticated/proc/open_unauthenticated_menu()
	set category = "OOC"
	set name = "Open Unauthenticated Menu"
	set desc = "Open unauthenticated menu"

	if(!unauthenticated_menu)
		unauthenticated_menu = new(usr)

	unauthenticated_menu.ui_interact(usr)

/mob/unauthenticated/ui_interact(mob/user, datum/tgui/ui)
	. = ..()

	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "UnauthenticatedMenu")
		ui.open()

/mob/unauthenticated/ui_static_data(mob/user)
	. = ..()

	.["auth_options"] = list()

	var/config_options = CONFIG_GET(keyed_list/auth_urls)
	for(var/key in config_options)
		.["auth_options"] += list(
			list("name" = key, "url" = config_options[key])
		)

/mob/unauthenticated/ui_state(mob/user)
	return GLOB.always_state

/mob/unauthenticated/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()

	switch(action)
		if("open_browser")
			if(!access_code)
				create_authentication_request()

			client << link("[CONFIG_GET(keyed_list/auth_urls)[params["auth_option"]]]?code=[access_code]")

			INVOKE_ASYNC(src, PROC_REF(check_logged_in))
		if("recall_code")
			if(!COOLDOWN_FINISHED(src, recall_code_cooldown))
				return

			if(!params["code"])
				return

			COOLDOWN_START(src, recall_code_cooldown, 5 SECONDS)

			check_logged_in(params["code"])

/// Informs the menu that we successfully logged in with a code, stores this for usage for the next few hours
/mob/unauthenticated/proc/notify_unauthenticated_menu()
	unauthenticated_menu.send_message("logged_in", list("access_code" = access_code))
