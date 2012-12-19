
/obj/item/weapon/chemsprayer
	desc = "A utility used to spray large amounts of reagent in a given area."
	icon = 'gun.dmi'
	name = "chem sprayer"
	icon_state = "chemsprayer"
	item_state = "chemsprayer"
	flags = ONBELT|TABLEPASS|OPENCONTAINER|FPRINT|USEDELAY
	throwforce = 3
	w_class = 3.0
	throw_speed = 2
	throw_range = 10
	origin_tech = "combat=3;materials=3;engineering=3"

/obj/item/weapon/chemsprayer/New()
	var/datum/reagents/R = new/datum/reagents(1000)
	reagents = R
	R.my_atom = src
	R.add_reagent("cleaner", 10)

/obj/item/weapon/chemsprayer/attack(mob/living/carbon/human/M as mob, mob/user as mob)
	return

/obj/item/weapon/chemsprayer/afterattack(atom/A as mob|obj, mob/user as mob)
	if (istype(A, /obj/item/weapon/storage/backpack ))
		return
	else if (src.reagents.total_volume < 1)
		user << "\blue [src] is empty!"
		return

	playsound(src.loc, 'spray2.ogg', 50, 1, -6)

	var/Sprays[3]
	for(var/i=1, i<=3, i++) // intialize sprays
		if(src.reagents.total_volume < 1) break
		var/obj/decal/D = new/obj/decal(get_turf(src))
		D.name = "chemicals"
		D.icon = 'chempuff.dmi'
		D.create_reagents(5)
		src.reagents.trans_to(D, 5)

		var/rgbcolor[3]
		var/finalcolor
		for(var/datum/reagent/re in D.reagents.reagent_list)
			if(!finalcolor)
				rgbcolor = GetColors(re.color)
				finalcolor = re.color
			else
				var/newcolor[3]
				var/prergbcolor[3]
				prergbcolor = rgbcolor
				newcolor = GetColors(re.color)

				rgbcolor[1] = (prergbcolor[1]+newcolor[1])/2
				rgbcolor[2] = (prergbcolor[2]+newcolor[2])/2
				rgbcolor[3] = (prergbcolor[3]+newcolor[3])/2

				finalcolor = rgb(rgbcolor[1], rgbcolor[2], rgbcolor[3])

		D.icon += finalcolor

		Sprays[i] = D

	var/direction = get_dir(src, A)
	var/turf/T = get_turf(A)
	var/turf/T1 = get_step(T,turn(direction, 90))
	var/turf/T2 = get_step(T,turn(direction, -90))
	var/list/the_targets = list(T,T1,T2)

	for(var/i=1, i<=Sprays.len, i++)
		spawn()
			var/obj/decal/D = Sprays[i]
			if(!D) continue

			// Spreads the sprays a little bit
			var/turf/my_target = pick(the_targets)
			the_targets -= my_target

			for(var/j=1, j<=rand(6,8), j++)
				step_towards(D, my_target)
				D.reagents.reaction(get_turf(D))
				for(var/atom/t in get_turf(D))
					D.reagents.reaction(t)
				sleep(2)
			del(D)
	sleep(1)

	if(isrobot(user)) //Cyborgs can clean forever if they keep charged
		var/mob/living/silicon/robot/janitor = user
		janitor.cell.charge -= 20
		var/refill = src.reagents.get_master_reagent_id()
		spawn(600)
			src.reagents.add_reagent(refill, 10)

	return

/obj/item/weapon/chemsprayer/examine()
	set src in usr
	usr << text("\icon[] [] units of cleaner left!", src, src.reagents.total_volume)
	..()
	return