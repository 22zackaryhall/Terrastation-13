//This file is attempting to define shit that will enable the salvage yard to generate itself instead of pure hardmapping

//The code I think is used for random space ruin generation is in modules/awaymissions/zlevel.dm. I'll try and replicate it in a way that fits salvage yard.
//The file that actually CALLS these methods is none other than master_controller.dm (which I will have to edit, fuk)


//begin attempt to make this hapen

//THIS LOOKS FOR A DATUM LIST SIMILAR TO THE ONE IN ruins/space.dm! KEEP THIS IN MIND NIGGER ASDF
//let's build that first and move it if need be mkay

/datum/map_template/junk //SHIT. I NEED THIS FIRST FUUCK
	name = null
	var/id = null // For blacklisting purposes, all ruins need an id
	var/description = "BIG WOBBLY COCKS!"

	var/cost = null
	var/allow_duplicates = FALSE //A bit boring, don't you think? You can always explicitly allow it on a ruin definition THIS IS THE SAME COMMENT FROM WHERE I STOLE IT FROM AREN'T I A SHITLOARDE

	var/prefix = null
	var/suffix = null

/datum/map_template/junk/New()
	if(!name && id)
		name = id

	mappath = prefix + suffix
	..(path = mappath)


/* reference code
/datum/map_template/ruin/space
	prefix = "_maps/map_files/RandomRuins/SpaceRuins/"
	cost = 1

/datum/map_template/ruin/space/zoo
	id = "zoo"
	suffix = "abandonedzoo.dmm"
	name = "Biological Storage Facility"
	description = "In case society crumbles, we will be able to restore our \
		zoos to working order with the breeding stock kept in these 100% \
		secure and unbreachable storage facilities. At no point has anything \
		escaped. That's our story, and we're sticking to it."
	cost = 2
*/

//the big ones
/datum/map_template/junk/normal
	prefix = "_maps/map_files/templates/salvageyard/normal/"
	cost = 1

/datum/map_template/junk/normal/n1
	id = "fragment"
	suffix = "n1.dmm"
	name = "Mining Fragment"
	description = "This must have been a break off a mining asteroid."

/datum/map_template/junk/normal/n2
	id = "blast"
	suffix = "n2.dmm"
	name = "Blasted"
	description = "Probably an explosives mishap, given the residue."

//& small ones
/datum/map_template/junk/smol
	prefix = "_maps/map_files/templates/salvageyard/smol/"
	cost = 1

/datum/map_template/junk/smol/s01
	id = "tmelt"
	suffix = "s01.dmm"
	name = "Melted Station Fragment"
	description = "A few melterlings lurk around this old structure."

/datum/map_template/junk/smol/s02
	id = "jank1"
	suffix = "s02.dmm"
	name = "Jank 1"
	description = "might be something useful there. who knows"

/datum/map_template/junk/smol/s03
	id = "jank2"
	suffix = "s03.dmm"
	name = "Jank 2"
	description = "doesn't seem worth it, really."

/datum/map_template/junk/smol/s04
	id = "jank3"
	suffix = "s04.dmm"
	name = "Jank 3"
	description = "Maybe that meteoroid snagged something useful..?"

/datum/map_template/junk/smol/s05
	id = "syndiebust"
	suffix = "s05.dmm"
	name = "Busted Syndicate vessel"
	description = "Looks like a syndicate ship accident. \
	Probably worth looting to some extent! \
	just don't let shitcurity know."

/datum/map_template/junk/smol/s06
	id = "nmelt"
	suffix = "s06.dmm"
	name = "Melted Station Chunk"
	description = "An unsettling amount of melterlings rode this in."

/datum/map_template/junk/smol/s07
	id = "honkfuck"
	suffix = "s07.dmm"
	name = "Pod Honk Fail"
	description = "Does this even need a description?"

//^That list is incomplete.

//now for the declaration thing I think we need?
var/list/datum/map_template/salvage_yard_Mtemplates = list()
var/list/datum/map_template/salvage_yard_Stemplates = list()


//building the template list I think?
/proc/preloadSYTemplates()
	// Blacklist code from the stolen block that I may or may not rework to fit here if we decide to run a salvage yard blacklist and stuff lolololfgt
	var/list/banned
	if(fexists("config/spaceRuinBlacklist.txt"))
		banned = generateMapList("config/spaceRuinBlacklist.txt")
	else
		banned = generateMapList("config/example/spaceRuinBlacklist.txt")
	//none of that should do anything in this method.
	for(var/item in subtypesof(/datum/map_template/junk))
		var/datum/map_template/junk/junk_type = item
		// screen out the abstract subtypes
		if(!initial(junk_type.id))
			continue
		var/datum/map_template/junk/J = new junk_type()

		if(banned.Find(J.mappath))
			continue

		map_templates[J.name] = J
		ruins_templates[J.name] = J //Is this line needed at all for this purpose?

		if(istype(J, /datum/map_template/junk/normal))
			salvage_yard_Mtemplates[J.name] = J
		if(istype(J, /datum/map_template/junk/smol))
			salvage_yard_Stemplates[J.name] = J



//first the larger ones
/proc/seedMids(z_level = 1, budget = 0, whitelist = /area/salvage/yard/genarea, list/potentialMids = salvage_yard_Mtemplates)
	var/overall_sanity = 100
	var/ruins = potentialMids.Copy()
	var/initialbudget = budget
	var/watch = start_watch()

	while(budget > 0 && overall_sanity > 0)
		// Pick a ruin
		var/datum/map_template/ruin/ruin = ruins[pick(ruins)]
		// Can we afford it
		if(ruin.cost > budget)
			overall_sanity--
			continue
		// If so, try to place it
		var/sanity = 100
		// And if we can't fit it anywhere, give up, try again
		//I left the ruin variable the same for now. I don't THINK this will cause a problem? I mean, it's declared inside the method and therefore exclusive to it, right?

		while(sanity > 0)
			sanity--
			var/turf/T = locate(rand(25, world.maxx - 25), rand(25, world.maxy - 25), z_level)
			var/valid = 1

			for(var/turf/check in ruin.get_affected_turfs(T,1))
				var/area/new_area = get_area(check)
				if(!(istype(new_area, whitelist)))
					valid = 0
					break

			if(!valid)
				continue

			log_to_dd("   \"[ruin.name]\" loaded to the salvage yard in [stop_watch(watch)]s at ([T.x], [T.y], [T.z]).")

			var/obj/effect/Mjunk_loader/R = new /obj/effect/Mjunk_loader(T)
			R.Load(ruins,ruin) //DENNIS
			budget -= ruin.cost
			if(!ruin.allow_duplicates)
				ruins -= ruin.name
			break
	if(initialbudget == budget) //Kill me
		log_to_dd("  No large salvages loaded.")



//then the smaller ones
/proc/seedSmols(z_level = 1, budget = 0, whitelist = /area/salvage/yard/genarea, list/potentialSmols = salvage_yard_Stemplates)
	var/overall_sanity = 100
	var/ruins = potentialSmols.Copy()
	var/initialbudget = budget
	var/watch = start_watch()
	//same shit noted as above
	while(budget > 0 && overall_sanity > 0)
		// Pick a ruin
		var/datum/map_template/ruin/ruin = ruins[pick(ruins)]
		// Can we afford it
		if(ruin.cost > budget)
			overall_sanity--
			continue
		// If so, try to place it
		var/sanity = 100
		// And if we can't fit it anywhere, give up, try again

		while(sanity > 0)
			sanity--
			var/turf/T = locate(rand(10, world.maxx - 10), rand(10, world.maxy - 10), z_level)
			var/valid = 1

			for(var/turf/check in ruin.get_affected_turfs(T,1))
				var/area/new_area = get_area(check)
				if(!(istype(new_area, whitelist)))
					valid = 0
					break

			if(!valid)
				continue

			log_to_dd("   \"[ruin.name]\" loaded to the salvage yard in [stop_watch(watch)]s at ([T.x], [T.y], [T.z]).")

			var/obj/effect/Sjunk_loader/R = new /obj/effect/Sjunk_loader(T)
			R.Load(ruins,ruin) //DENNIS
			budget -= ruin.cost
			if(!ruin.allow_duplicates)
				ruins -= ruin.name
			break


	if(initialbudget == budget) //Kill me
		log_to_dd("  No small salvages loaded.")


//needed pseudo-objects for the above loops, evidently
/obj/effect/Sjunk_loader
	name = "random small junk"
	desc = "If you got lucky enough to see this..."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "syndballoon"
	invisibility = 0
/obj/effect/Mjunk_loader
	name = "random junk"
	desc = "If you got lucky enough to see this..."
	icon = 'icons/obj/weapons.dmi'
	icon_state = "syndballoon"
	invisibility = 0


//this next thing I think is the method it tries to call above at DENNIS
/obj/effect/Mjunk_loader/proc/Load(list/potentialRuins = salvage_yard_Mtemplates, datum/map_template/template = null)
	var/list/possible_ruins = list()
	for(var/A in potentialRuins)
		var/datum/map_template/T = potentialRuins[A]
		if(!T.loaded)
			possible_ruins += T
	if(!template && possible_ruins.len)
		template = safepick(possible_ruins)
	if(!template)
		return 0
	var/turf/central_turf = get_turf(src)
	for(var/i in template.get_affected_turfs(central_turf, 1))
		var/turf/T = i
		for(var/mob/living/simple_animal/monster in T)
			qdel(monster)
		for(var/obj/structure/flora/ash/plant in T)
			qdel(plant)
	template.load(get_turf(src),centered = 1)
	template.loaded++
	var/datum/map_template/ruin = template
	if(istype(ruin))
		new /obj/effect/landmark/ruin(central_turf, ruin)
	qdel(src)
	return 1
/obj/effect/Sjunk_loader/proc/Load(list/potentialRuins = salvage_yard_Stemplates, datum/map_template/template = null)
	var/list/possible_ruins = list()
	for(var/A in potentialRuins)
		var/datum/map_template/T = potentialRuins[A]
		if(!T.loaded)
			possible_ruins += T
	if(!template && possible_ruins.len)
		template = safepick(possible_ruins)
	if(!template)
		return 0
	var/turf/central_turf = get_turf(src)
	for(var/i in template.get_affected_turfs(central_turf, 1))
		var/turf/T = i
		for(var/mob/living/simple_animal/monster in T)
			qdel(monster)
		for(var/obj/structure/flora/ash/plant in T)
			qdel(plant)
	template.load(get_turf(src),centered = 1)
	template.loaded++
	var/datum/map_template/ruin = template
	if(istype(ruin))
		new /obj/effect/landmark/ruin(central_turf, ruin)
	qdel(src)
	return 1
//LETS HOPE THIS WORKS