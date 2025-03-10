//This file was auto-corrected by findeclaration.exe on 25.5.2012 20:42:32

var/global/list/jobban_keylist = list() //to store the keys & ranks

/proc/jobban_fullban(mob/M, rank, reason)
	if(!M)
		return
	var/last_ckey = LAST_CKEY(M)
	if(!last_ckey)
		return
	jobban_keylist.Add(text("[last_ckey] - [rank] ## [reason]"))
	jobban_savebanfile()

//returns a reason if M is banned from rank, returns 0 otherwise
/proc/jobban_isbanned(mob/M, rank)
	if(M && rank)
		if(ispath(rank, /decl/special_role))
			var/decl/special_role/antag = GET_DECL(rank)
			rank = antag.name
		if (SSjobs.guest_jobbans(rank))
			if(get_config_value(/decl/config/toggle/on/guest_jobban) && IsGuestKey(M.key))
				return "Guest Job-ban"
			if(get_config_value(/decl/config/enum/server_whitelist) == CONFIG_SERVER_JOBS_WHITELIST && !check_server_whitelist(M))
				return "Whitelisted Job"
		return ckey_is_jobbanned(M.ckey, rank)
	return 0

/proc/ckey_is_jobbanned(var/check_key, var/rank)
	for(var/s in jobban_keylist)
		if(findtext(s,"[check_key] - [rank]") == 1 )
			var/startpos = findtext(s, "## ")+3
			if(startpos && startpos<length(s))
				var/text = copytext(s, startpos, 0)
				if(text)
					return text
			return "Reason Unspecified"
	return 0

/proc/jobban_loadbanfile()
	if(get_config_value(/decl/config/toggle/on/ban_legacy_system))
		var/savefile/S=new("data/job_full.ban")
		from_savefile(S, "keys[0]", jobban_keylist)
		log_admin("Loading jobban_rank")

		if (!length(jobban_keylist))
			jobban_keylist=list()
			log_admin("jobban_keylist was empty")
	else
		if(!establish_db_connection())
			error("Database connection failed. Reverting to the legacy ban system.")
			log_misc("Database connection failed. Reverting to the legacy ban system.")
			set_config_value(/decl/config/toggle/on/ban_legacy_system, TRUE)
			jobban_loadbanfile()
			return

		//Job permabans
		var/DBQuery/query = dbcon.NewQuery("SELECT `ckey`, `job` FROM `erro_ban` WHERE `bantype` = 'JOB_PERMABAN' AND isnull(`unbanned`)")
		query.Execute()

		while(query.NextRow())
			var/ckey = query.item[1]
			var/job = query.item[2]

			jobban_keylist.Add("[ckey] - [job]")

		//Job tempbans
		var/DBQuery/query1 = dbcon.NewQuery("SELECT `ckey`, `job` FROM `erro_ban` WHERE `bantype` = 'JOB_TEMPBAN' AND isnull(`unbanned`) AND `expiration_time` > Now()")
		query1.Execute()

		while(query1.NextRow())
			var/ckey = query1.item[1]
			var/job = query1.item[2]

			jobban_keylist.Add("[ckey] - [job]")

/proc/jobban_savebanfile()
	var/savefile/S=new("data/job_full.ban")
	to_savefile(S, "keys[0]", jobban_keylist)

/proc/jobban_unban(mob/M, rank)
	jobban_remove("[M.ckey] - [rank]")
	jobban_savebanfile()


/proc/ban_unban_log_save(var/formatted_log)
	text2file(formatted_log,"data/ban_unban_log.txt")


/proc/jobban_remove(X)
	for (var/i = 1; i <= length(jobban_keylist); i++)
		if( findtext(jobban_keylist[i], "[X]") )
			jobban_keylist.Remove(jobban_keylist[i])
			jobban_savebanfile()
			return 1
	return 0
