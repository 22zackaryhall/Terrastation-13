
/obj/structure/window
	name = "window"
	icon = 'structures.dmi'
	desc = "A window."
	density = 1
	layer = 3.2//Just above doors
	pressure_resistance = 4*ONE_ATMOSPHERE
	anchored = 1.0
	flags = ON_BORDER
	var
		health = 14.0
		ini_dir = null
		state = 0
		reinf = 0
		silicate = 0 // number of units of silicate
		icon/silicateIcon = null // the silicated icon

	New(Loc,re=0)
		..()
		if(re)	reinf = re
		src.ini_dir = src.dir
		if(reinf)
			icon_state = "rwindow"
			desc = "A reinforced window."
			name = "reinforced window"
			state = 2*anchored
			health = 40
			if(opacity)
				icon_state = "twindow"
		update_nearby_tiles(need_rebuild=1)
		return

	Del()
	//TODO: When broken or deleted, tell any critters targetting this glass to bugger off.
		density = 0
		update_nearby_tiles()
		playsound(src, "shatter", 70, 1)
		..()

	Move()
		update_nearby_tiles(need_rebuild=1)
		..()
		src.dir = src.ini_dir
		update_nearby_tiles(need_rebuild=1)

		return

	bullet_act(var/obj/item/projectile/Proj)
		health -= Proj.damage
		..()
		if(health <=0)
			new /obj/item/weapon/shard( src.loc )
			new /obj/item/stack/rods( src.loc )
			src.density = 0
			del(src)
		return

	ex_act(severity)
		switch(severity)
			if(1.0)
				del(src)
				return
			if(2.0)
				new /obj/item/weapon/shard( src.loc )
				if(reinf) new /obj/item/stack/rods( src.loc)
				//SN src = null
				del(src)
				return
			if(3.0)
				if (prob(50))
					new /obj/item/weapon/shard( src.loc )
					if(reinf) new /obj/item/stack/rods( src.loc)

					del(src)
					return
		return

	blob_act()
		if(reinf) new /obj/item/stack/rods( src.loc)
		density = 0
		del(src)

	CanPass(atom/movable/mover, turf/target, height=0, air_group=0)
		if(istype(mover) && mover.checkpass(PASSGLASS))
			return 1
		if (src.dir == SOUTHWEST || src.dir == SOUTHEAST || src.dir == NORTHWEST || src.dir == NORTHEAST)
			return 0 //full tile window, you can't move into it!
		if(get_dir(loc, target) == dir)
			return !density
		else
			return 1

	CheckExit(atom/movable/O as mob|obj, target as turf)
		if(istype(O) && O.checkpass(PASSGLASS))
			return 1
		if (get_dir(O.loc, target) == dir)
			return 0
		return 1

	meteorhit()
		//*****RM
		//world << "glass at [x],[y],[z] Mhit"
		src.health = 0
		new /obj/item/weapon/shard( src.loc )
		if(reinf) new /obj/item/stack/rods( src.loc)
		src.density = 0


		del(src)
		return

	hitby(AM as mob|obj)
		..()
		for(var/mob/O in viewers(src, null))
			O.show_message(text("\red <B>[src] was hit by [AM].</B>"), 1)
		var/tforce = 0
		if(ismob(AM))
			tforce = 40
		else
			tforce = AM:throwforce
		if(reinf) tforce /= 4.0
		playsound(src.loc, 'Glasshit.ogg', 100, 1)
		src.health = max(0, src.health - tforce)
		if (src.health <= 7 && !reinf)
			src.anchored = 0
			step(src, get_dir(AM, src))
		if (src.health <= 0)
			new /obj/item/weapon/shard( src.loc )
			if(reinf) new /obj/item/stack/rods( src.loc)
			src.density = 0
			del(src)
			return
		..()
		return

	attack_hand()
		if ((usr.mutations & HULK))
			usr << text("\blue You smash through the window.")
			for(var/mob/O in oviewers())
				if ((O.client && !( O.blinded )))
					O << text("\red [] smashes through the window!", usr)
			src.health = 0
			new /obj/item/weapon/shard( src.loc )
			if(reinf) new /obj/item/stack/rods( src.loc)
			src.density = 0
			del(src)
		return

	attack_by_critter(var/damage, obj/critter/critter) //Call if a critter is attacking it.
		playsound(src.loc, 'Glasshit.ogg', 100, 1) //Just a normal glasshit sound.
		for(var/mob/O in viewers(src, null))
			O.show_message(text("\red <B>[src] was hit by [critter].</B>"), 1)
		src.health -= damage
		if (src.health <= 7 && !reinf)
			src.anchored = 0
			step(src, get_dir(critter, src))
		if (src.health <= 0)
			new /obj/item/weapon/shard( src.loc )
			if(reinf) new /obj/item/stack/rods( src.loc)
			src.density = 0
			critter.broke_object = 1 //Broke the object!
			//Shatter sound is played on delete.
			del(src)
			return
		return

	attack_paw()
		if ((usr.mutations & HULK))
			usr << text("\blue You smash through the window.")
			for(var/mob/O in oviewers())
				if ((O.client && !( O.blinded )))
					O << text("\red [] smashes through the window!", usr)
			src.health = 0
			new /obj/item/weapon/shard( src.loc )
			if(reinf) new /obj/item/stack/rods( src.loc)
			src.density = 0
			del(src)
		return

	attack_alien()
		if (istype(usr, /mob/living/carbon/alien/larva))//Safety check for larva. /N
			return
		usr << text("\green You smash against the window.")
		for(var/mob/O in oviewers())
			if ((O.client && !( O.blinded )))
				O << text("\red [] smashes against the window.", usr)
		playsound(src.loc, 'Glasshit.ogg', 100, 1)
		src.health -= 15
		if(src.health <= 0)
			usr << text("\green You smash through the window.")
			for(var/mob/O in oviewers())
				if ((O.client && !( O.blinded )))
					O << text("\red [] smashes through the window!", usr)
			src.health = 0
			new /obj/item/weapon/shard(src.loc)
			if(reinf)
				new /obj/item/stack/rods(src.loc)
			src.density = 0
			del(src)
			return
		return

	attack_metroid()
		if(!istype(usr, /mob/living/carbon/metroid/adult))
			return
		usr<< text("\green You smash against the window.")
		for(var/mob/O in oviewers())
			if ((O.client && !( O.blinded )))
				O << text("\red [] smashes against the window.", usr)
		playsound(src.loc, 'Glasshit.ogg', 100, 1)
		src.health -= rand(10,15)
		if(src.health <= 0)
			usr << text("\green You smash through the window.")
			for(var/mob/O in oviewers())
				if ((O.client && !( O.blinded )))
					O << text("\red [] smashes through the window!", usr)
			src.health = 0
			new /obj/item/weapon/shard(src.loc)
			if(reinf)
				new /obj/item/stack/rods(src.loc)
			src.density = 0
			del(src)
			return
		return

	attackby(obj/item/weapon/W as obj, mob/user as mob)
		if (istype(W, /obj/item/weapon/screwdriver))
			if(reinf && state >= 1)
				state = 3 - state
				playsound(src.loc, 'Screwdriver.ogg', 75, 1)
				usr << ( state==1? "You have unfastened the window from the frame." : "You have fastened the window to the frame." )
			else if(reinf && state == 0)
				anchored = !anchored
				playsound(src.loc, 'Screwdriver.ogg', 75, 1)
				user << (src.anchored ? "You have fastened the frame to the floor." : "You have unfastened the frame from the floor.")
			else if(!reinf)
				src.anchored = !( src.anchored )
				playsound(src.loc, 'Screwdriver.ogg', 75, 1)
				user << (src.anchored ? "You have fastened the window to the floor." : "You have unfastened the window.")
		else if(istype(W, /obj/item/weapon/crowbar) && reinf)
			if(state <=1)
				state = 1-state;
				playsound(src.loc, 'Crowbar.ogg', 75, 1)
				user << (state ? "You have pried the window into the frame." : "You have pried the window out of the frame.")
		else
			var/aforce = W.force
			if(reinf) aforce /= 2.0
			src.health = max(0, src.health - aforce)
			playsound(src.loc, 'Glasshit.ogg', 75, 1)
			if (src.health <= 7)
				src.anchored = 0
				step(src, get_dir(user, src))
			if (src.health <= 0)
				if (src.dir == SOUTHWEST)
					var/index = null
					index = 0
					while(index < 2)
						new /obj/item/weapon/shard( src.loc )
						if(reinf) new /obj/item/stack/rods( src.loc)
						index++
				else
					new /obj/item/weapon/shard( src.loc )
					if(reinf) new /obj/item/stack/rods( src.loc)
				src.density = 0
				del(src)
				return
			..()
		return

	proc
		updateSilicate()
			if(silicateIcon && silicate)
				src.icon = initial(icon)
				var
					icon/I = icon(icon,icon_state,dir)
					r = (silicate / 100) + 1
					g = (silicate / 70) + 1
					b = (silicate / 50) + 1
				I.SetIntensity(r,g,b)
				icon = I
				silicateIcon = I

		update_nearby_tiles(need_rebuild)
			if(!air_master) return 0
			var/turf/simulated/source = loc
			var/turf/simulated/target = get_step(source,dir)
			if(need_rebuild)
				if(istype(source)) //Rebuild/update nearby group geometry
					if(source.parent)
						air_master.groups_to_rebuild += source.parent
					else
						air_master.tiles_to_update += source
				if(istype(target))
					if(target.parent)
						air_master.groups_to_rebuild += target.parent
					else
						air_master.tiles_to_update += target
			else
				if(istype(source)) air_master.tiles_to_update += source
				if(istype(target)) air_master.tiles_to_update += target
			return 1

	verb
		rotate()
			set name = "Rotate Window Counter-Clockwise"
			set category = "Object"
			set src in oview(1)
			if (src.anchored)
				usr << "It is fastened to the floor; therefore, you can't rotate it!"
				return 0
			update_nearby_tiles(need_rebuild=1) //Compel updates before
			src.dir = turn(src.dir, 90)
			updateSilicate()
			update_nearby_tiles(need_rebuild=1)
			src.ini_dir = src.dir
			return

		revrotate()
			set name = "Rotate Window Clockwise"
			set category = "Object"
			set src in oview(1)
			if (src.anchored)
				usr << "It is fastened to the floor; therefore, you can't rotate it!"
				return 0
			update_nearby_tiles(need_rebuild=1) //Compel updates before
			src.dir = turn(src.dir, 270)
			updateSilicate()
			update_nearby_tiles(need_rebuild=1)
			src.ini_dir = src.dir
			return