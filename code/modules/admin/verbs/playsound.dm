var/list/sounds_cache = list()

/client/proc/play_sound(S as sound)
	set category = "Sound Board"
	set name = "Play Global Sound"
	if(!check_rights(R_SOUNDS))	return

	var/sound/uploaded_sound = sound(S, repeat = 0, wait = 1, channel = 777)
	uploaded_sound.priority = 250

	sounds_cache += S

	if(alert("Do you ready?\nSong: [S]\nNow you can also play this sound using \"Play Server Sound\".", "Confirmation request" ,"Play", "Cancel") == "Cancel")
		return

	log_admin("[key_name(src)] played sound [S]")
	message_admins("[key_name_admin(src)] played sound [S]", 1)
	for(var/mob/M in player_list)
		if(M.client.prefs.toggles & SOUND_MIDI)
			M << uploaded_sound

	feedback_add_details("admin_verb","PGS")	// If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/client/proc/play_local_sound(S as sound)
	set category = "Sound Board"
	set name = "Play Local Sound"
	if(!check_rights(R_SOUNDS))	return

	log_admin("[key_name(src)] played a local sound [S]")
	message_admins("[key_name_admin(src)] played a local sound [S]", 1)
	playsound(get_turf(src.mob), S, 50, 0, 0)
	feedback_add_details("admin_verb","PLS") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!


/client/proc/peel()
	set name = "Damn banana peel!"
	set category = "Sound Board"

	world << sound('sound/board/06 peel.ogg')

/client/proc/clownmusic()
	set name = "Clownmusic"
	set category = "Sound Board"

	//for(var/mob/m in world)
	//	if (m.client)	// If has client.
	//		m.music <<
	world << sound('sound/music/clown_station_redux.ogg')

/client/proc/hawly_shet()
	set name = "HAWLY SHET!"
	set category = "Sound Board"

	world << sound('sound/board/HAWLY SHET.ogg')

/client/proc/heyaheyamusic()
	set name = "Heyaheyaheya"
	set category = "Sound Board"

	world << sound('sound/board/heman-heya-full.ogg')

/client/proc/fag()
	set name = "FAG!"
	set category = "Sound Board"

	world << sound('sound/board/FAG.ogg')

/client/proc/ic_in_ooc()
	set name = "IC in OOC"
	set category = "Sound Board"

	world << sound('sound/board/IC in OOC.ogg')
/*
/client/proc/ooc_in_ic()
	set name = "OOC in IC"
	set category = "Sound Board"

	world << sound('OOC in IC.ogg')
*/
/client/proc/play_server_sound()
	set category = "Fun"
	set name = "Play Server Sound"
	if(!check_rights(R_SOUNDS))	return

	var/list/sounds = file2list("sound/serversound_list.txt");
	sounds += "--CANCEL--"
	sounds += sounds_cache

	var/melody = input("Select a sound from the server to play", "Server sound list", "--CANCEL--") in sounds

	if(melody == "--CANCEL--")	return

	play_sound(melody)
	feedback_add_details("admin_verb","PSS") //If you are copy-pasting this, ensure the 2nd parameter is unique to the new proc!

/*
/client/proc/cuban_pete()
	set name = "Cuban Pete Time"
	set category = "Fun"

	message_admins("[key_name_admin(usr)] has declared Cuban Pete Time!", 1)
	for(var/mob/M in world)
		if(M.client)
			if(M.client.midis)
				M << 'cubanpetetime.ogg'

	for(var/mob/living/carbon/human/CP in world)
		if(CP.real_name=="Cuban Pete" && CP.key!="Rosham")
			CP << "Your body can't contain the rhumba beat"
			CP.gib()


/client/proc/bananaphone()
	set name = "Banana Phone"
	set category = "Fun"

	message_admins("[key_name_admin(usr)] has activated Banana Phone!", 1)
	for(var/mob/M in world)
		if(M.client)
			if(M.client.midis)
				M << 'bananaphone.ogg'


client/proc/space_asshole()
	set name = "Space Asshole"
	set category = "Fun"

	message_admins("[key_name_admin(usr)] has played the Space Asshole Hymn.", 1)
	for(var/mob/M in world)
		if(M.client)
			if(M.client.midis)
				M << 'sound/music/space_asshole.ogg'


client/proc/honk_theme()
	set name = "Honk"
	set category = "Fun"

	message_admins("[key_name_admin(usr)] has creeped everyone out with Blackest Honks.", 1)
	for(var/mob/M in world)
		if(M.client)
			if(M.client.midis)
				M << 'honk_theme.ogg'
*/
