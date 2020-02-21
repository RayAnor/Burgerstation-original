/obj/item/magazine/syringe_gun
	name = "\improper syringe gun magazine"
	bullet_type = "syringe_gun"
	icon = 'icons/obj/items/magazine/syringegun.dmi'
	icon_state = "syringe"
	bullet_count_max = 8

	weapon_whitelist = list(
		/obj/item/weapon/ranged/bullet/magazine/rifle/syringe,
	)

	ammo = /obj/item/bullet_cartridge/syringe_gun/

/obj/item/magazine/syringe_gun/update_icon()
	icon_state = "[length(stored_bullets)]"
	..()