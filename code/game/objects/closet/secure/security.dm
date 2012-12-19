
/obj/secure_closet/security1
	name = "Security Equipment"
	req_access = list(access_security)

/obj/secure_closet/security1/New()
	..()
	sleep(2)
	new /obj/item/device/radio/headset/headset_sec(src)
	new /obj/item/weapon/flashbang(src)
	new /obj/item/weapon/handcuffs(src)
	new /obj/item/weapon/gun/energy/taser(src)
	new /obj/item/device/flash(src)
	new /obj/item/clothing/suit/armor/vest(src)
	new /obj/item/clothing/head/helmet(src)
	new /obj/item/clothing/glasses/sunglasses/sechud(src)
	new /obj/item/weapon/melee/baton(src)
	return

/obj/secure_closet/security1/proc/prison_break()
	src.locked = 0
	src.icon_state = src.icon_closed

/obj/secure_closet/security2
	name = "Forensics Locker"
	req_access = list(access_forensics_lockers)

/obj/secure_closet/security2/New()
	..()
	sleep(2)
	new /obj/item/device/radio/headset/headset_sec(src)
	new /obj/item/clothing/under/det( src )
	new /obj/item/clothing/shoes/brown( src )
	new /obj/item/clothing/head/det_hat( src )
	new /obj/item/clothing/suit/det_suit( src )
	new /obj/item/clothing/suit/det_suit/armor( src )
	new /obj/item/weapon/storage/fcard_kit( src )
	new /obj/item/clothing/gloves/black( src )
	new /obj/item/weapon/storage/lglo_kit( src )
	new /obj/item/weapon/f_cardholder( src )
	new /obj/item/weapon/clipboard( src )
	new /obj/item/device/detective_scanner( src )
	return

/obj/secure_closet/highsec
	name = "Head of Personnel"
	req_access = list(access_hop)

/obj/secure_closet/highsec/New()
	..()
	sleep(2)
	new /obj/item/device/radio/headset/heads/hop( src )
	new /obj/item/weapon/gun/energy( src )
	new /obj/item/device/flash( src )
	new /obj/item/weapon/storage/id_kit( src )
	new /obj/item/clothing/under/rank/head_of_personnel( src )
	new /obj/item/clothing/shoes/brown( src )
	new /obj/item/clothing/glasses/sunglasses( src )
	new /obj/item/clothing/suit/armor/vest( src )
	new /obj/item/clothing/head/helmet( src )
	return

/obj/secure_closet/hos
	name = "Head Of Security"
	req_access = list(access_hos)

/obj/secure_closet/hos/New()
	..()
	sleep(2)
	new /obj/item/device/radio/headset/heads/hos(src)
	new /obj/item/weapon/shield/riot(src)
	new /obj/item/weapon/gun/energy( src )
	new /obj/item/device/flash( src )
	new /obj/item/clothing/under/rank/head_of_security( src )
	new /obj/item/clothing/shoes/brown( src )
	new /obj/item/clothing/glasses/sunglasses/sechud( src )
	new /obj/item/clothing/suit/armor/hos( src )
	new /obj/item/clothing/head/helmet( src )
	new /obj/item/weapon/storage/flashbang_kit(src)
	new /obj/item/weapon/handcuffs(src)
	new /obj/item/weapon/melee/baton(src)
	return

/obj/secure_closet/injection
	name = "Lethal Injections"
	req_access = list(access_hos)

/obj/secure_closet/injection/New()
	..()
	sleep(2)
	new /obj/item/weapon/reagent_containers/ld50_syringe/choral ( src )
	new /obj/item/weapon/reagent_containers/ld50_syringe/choral ( src )
	return