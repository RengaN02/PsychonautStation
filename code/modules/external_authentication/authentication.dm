#define ACCESS_CODE_LENGTH 20
GLOBAL_LIST_EMPTY(permitted_guests)

/mob/dead/new_player/proc/open_unauthenticated_menu()
	set name = "Open Unauthenticated Menu"
	set category = "Authentication"
	var/mob/dead/new_player/M = usr
	if(isnull(M?.client))
		return
	var/client/our_client = M.client
	if (our_client.unauthenticated)
		if(isnull(our_client.unauthenticated_menu))
			our_client.unauthenticated_menu = new(our_client)
		our_client.unauthenticated_menu.display_unauthenticated_menu()

/client/proc/external_logout()
	set name = "Logout"
	set category = "OOC"

	if (!(key in GLOB.permitted_guests) || unauthenticated)
		return

	if(!istype(mob, /mob/dead/new_player))
		to_chat(src, "<span class='warning'>You cannot logout after joining game or observe.</span>")
		return

	logout_external_account()
	GLOB.permitted_guests -= key

	log_auth("[key_name(src)] has logged out from the external account [ckey].")
	var/new_ckey = "Guest-[computer_id]"

	persistent_client.change_ckey(src, new_ckey)
	GLOB.connected_external_accounts -= "[address]_[computer_id]"

	winset(src, null, "command=.reconnect")

/datum/unauthenticated_menu

	/// Unique ID of the interview
	var/id
	var/datum/tgui/auth_menu
	/// The /client who owns this interview, the intiator
	var/client/owner
	var/new_ckey
	var/access_code

	var/request_timer

	/// Atomic ID for incrementing unique IDs
	var/static/atomic_id = 0

	var/static/valid_characters = splittext("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789", "")

/datum/unauthenticated_menu/New(client/unauthenticated)
	if(!unauthenticated)
		qdel(src)
		return
	id = ++atomic_id
	owner = unauthenticated

/datum/unauthenticated_menu/process()
	if(!owner)
		return PROCESS_KILL

	if(new_ckey)
		return PROCESS_KILL

	INVOKE_ASYNC(src, PROC_REF(check_logged_in))

/datum/unauthenticated_menu/proc/check_logged_in()
	var/list/result = owner.check_external_account()
	if(!result || !islist(result) || !length(result))
		return
	var/internal_byond_id = result["internal_byond_id"]
	var/external_uid = result["external_uid"]
	var/auth_method = result["authentication_method"]
	new_ckey = owner.prepare_external_account_key(internal_byond_id, external_uid, auth_method)
	new_ckey = ckey(new_ckey)

	if(!new_ckey)
		to_chat(owner, "<span class='warning'>Authentication failed. Please try again.</span>")
		return

	var/banned = world.IsBanned(new_ckey, owner.address, owner.computer_id, real_bans_only = TRUE, guest_bypass_with_ext_auth = FALSE)
	if(banned)
		auth_menu.window.send_message("banned", banned)

		var/msg = "[key_name(owner)] has a banned account in connection history! (Matched: [banned["ckey"]], [banned["address"]], [banned["computer_id"]]). They will be automatically disconnected in ten seconds"
		message_admins(msg)
		send2tgs_adminless_only("Banned-user", msg)
		log_admin_private(msg)
		log_suspicious_login(msg, access_log_mirror = FALSE)

		QDEL_IN(owner, 10 SECONDS)
		return FALSE

	message_admins("Non-BYOND user [new_ckey] (previously [owner.key]) has been authenticated via [auth_method].")

	STOP_PROCESSING(SSauthentication, src)
	log_in(result)

/datum/unauthenticated_menu/proc/log_in(list/account_data)

	close_unauthenticated_menu(owner)

	log_auth("[key_name(owner)] has logged in as [new_ckey].")

	owner.persistent_client.change_ckey(owner, new_ckey)
	GLOB.connected_external_accounts["[owner.address]_[owner.computer_id]"] = account_data

	winset(owner, null, "command=.reconnect")

// OBSERVE ATIP RECONNECT ATINCA BOK OLUYOO, CLIENT PROCSDAN GIRISE BAK, EN KOTU IHTIMALLE HER TUR GIRIS YAPARLAR

/// Creates a base 62 access code
/datum/unauthenticated_menu/proc/generate_access_code()
	var/code = ""

	for(var/i in 1 to ACCESS_CODE_LENGTH)
		code += pick(valid_characters)

	return code

/datum/unauthenticated_menu/proc/create_authentication_request()

	access_code = generate_access_code()

	var/datum/db_query/query_log_auth = SSdbcore.NewQuery({"
		INSERT INTO [format_table_name("authentication_requests")] (access_code, address, computer_id, timestamp)
		VALUES (:access_code, INET_ATON(:address), :computer_id, NOW())
	"}, list(
		"access_code" = access_code,
		"address" = owner.address,
		"computer_id" = owner.computer_id
	))
	query_log_auth.Execute()
	qdel(query_log_auth)
	request_timer = addtimer(CALLBACK(src, PROC_REF(create_authentication_request)), 1 HOURS, (TIMER_UNIQUE|TIMER_OVERRIDE))

/datum/unauthenticated_menu/proc/display_unauthenticated_menu()
	ui_interact(owner.mob)

/datum/unauthenticated_menu/proc/close_unauthenticated_menu()
	set waitfor = FALSE
	ui_close(owner.mob)
	owner << browse(null, "window=authwindow")

/datum/unauthenticated_menu/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if (!ui)
		ui = new(user, src, "UnauthenticatedMenu")
		ui.open()
	auth_menu = ui

/datum/unauthenticated_menu/ui_close(mob/user)
	if(!isnull(owner.unauthenticated_menu))
		owner.unauthenticated_menu = null
	qdel(src)

/datum/unauthenticated_menu/ui_state(mob/user)
	return GLOB.unauthenticated_state

/datum/unauthenticated_menu/ui_static_data(mob/user)
	. = ..()

	.["auth_options"] = list()

	var/config_options = CONFIG_GET(keyed_list/auth_urls)
	for(var/key in config_options)
		.["auth_options"] += list(
			list("name" = key, "url" = config_options[key])
		)

/datum/unauthenticated_menu/ui_act(action, list/params, datum/tgui/ui, datum/ui_state/state)
	. = ..()

	switch(action)
		if("open_browser")
			if(!access_code)
				create_authentication_request()

			usr << browse("<!DOCTYPE html><html><head><meta http-equiv='Content-Type' content='text/html; charset=UTF-8'><meta http-equiv='X-UA-Compatible' content='IE=edge'><script>location.href = '[CONFIG_GET(keyed_list/auth_urls)[params["auth_option"]]]?code=[access_code]'</script></head><body>POPO POPOO POOOPPPOOOOOOO</body></html>", "window=authwindow;can_resize=0;size=[700 * owner.window_scaling]x[700 * owner.window_scaling]")

			START_PROCESSING(SSauthentication, src)
			return TRUE

		if("close_browser")
			usr << browse(null, "window=authwindow")
			return TRUE

		if("open_ext_browser")
			if(!access_code)
				create_authentication_request()

			usr << link("[CONFIG_GET(keyed_list/auth_urls)[params["auth_option"]]]?code=[access_code]")
			START_PROCESSING(SSauthentication, src)
			return TRUE

#undef ACCESS_CODE_LENGTH
