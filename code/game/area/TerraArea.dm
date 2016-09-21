//PERIPHERAL STATION AREAS -- For use with that little area disconnected from the station that has the solar array to itself sorta
//Being maintenance, should block rad storms and shit

/area/maintenance/peris
	name = "outpost"
	icon_state = "blueold"

/area/maintenance/peris/lock
	name = "Airlock"
	icon_state = "red"

/area/maintenance/peris/hydro
	name = "grow shit"
	icon_state = "hydro"

/area/maintenance/peris/bed
	name = "bedroom"
	icon_state = "dark160"

/area/maintenance/peris/fuck
	name = "fuckoff"
	icon_state = "dark128"


//TERRALABS AREAS -- Oh fuck

/area/terralabs
	icon_state = "away"
	music = "music/mines03.ogg"
	//Nothing; this is intended for inheritance use only and not for the actual maps

/area/terralabs/hallway
	name = "terralabs hall"

/area/terralabs/hive
	name = "Hivebot Reasearch Wing"
	icon_state = "away1"

/area/terralabs/blarg
	name = "Containment Cells"
	icon_state = "away1"

/area/terralabs/storage
	name = "Storage Hub"

/area/terralabs/storage1
	name = "Storage room #1"
	icon_state = "away2"

/area/terralabs/storage2
	name = "Storage room #2"
	icon_state = "away3"

/area/terralabs/storage3
	name = "Spare materials storage"
	icon_state = "away4"

/area/terralabs/worl
	name = "Engine Room"
	icon_state = "yellow"


//GEOSTATION AREAS -- Because I want this back sorta

/area/geostat
	name = "Geostation"
	icon_state = "dark"

/area/geostat/hydro
	name = "Geostation Hydroponics Wing"
	icon_state = "radiation"

/area/geostat/disposal
	name = "The ShitHub"
	icon_state = "law"

/area/geostat/maint
	name = "maintenance"
	icon_state = "maintcentral"

/area/geostat/exterior
	name = "Geostation Exterior"
	icon_state = "cave"

// SUBSTATIONS (I stole these from our old bay stuff if we ever want to use them in something... which I will, in rock)
// (Subtype of maint, that should let them serve as shielded area during radstorm)

/area/maintenance/substation
	name = "Substation"
	icon = 'icons/turf/areas2.dmi' //Using separate area icon file to avoid merge bullshit
	icon_state = "substation"

/area/maintenance/substation/engineering //selfexplanatory
	name = "Engineering Substation"

/area/maintenance/substation/medical_science // Unused in bay, but depending on your map demands.... This is both med and sci
	name = "Medical Research Substation"

/area/maintenance/substation/medical //med
	name = "Medical Substation"

/area/maintenance/substation/research //sci
	name = "Research Substation"

/area/maintenance/substation/civilian_east // Bar, kitchen, dorms, whatever you can hook to it really
	name = "Civilian East Substation"

/area/maintenance/substation/civilian_west // anything on the other side that's civ area stuff
	name = "Civilian West Substation"

/area/maintenance/substation/cargo //Not initially on this list when I stole it; but I'm gonna have a dedicated substation for cargo. As always.
	name = "Cargo Substation"

/area/maintenance/substation/command // Bridge and HoS plus whatever else is up there
	name = "Command Substation"

/area/maintenance/substation/security // sec
	name = "Security Substation"


// ENGINEERING AREAS THAT PARADISE CANNED FOR WHATEVER REASON

/area/engine/d_fab
	name = "Drone Fabrication"
	icon_state = "engine"

/area/engine/e_waste
	name = "Engine Waste Handling"
	icon_state = "engine"

// SALVAGE - Salvage captain and all associated areas

/area/salvage //intended for station dock
	name = "Salvage Captain"
	icon_state = "south"

/area/salvage/lobby //intended for waiting area
	name = "Salvage Expedition Lobby"
	icon_state = "southeast"

/area/salvage/q //intended for captain's quarters
	name = "Salvage Captain Quarters"
	icon_state = "red"

/area/salvage/main //intended for the whateverdiks big area
	name = "something"

area/salvage/support //intended for the ministation's supportability
	name = "Support Room"
	icon_state = "auxstorage"
//TODO: add shuttle areas for this section


//Derelicts
/area/derelict/jettison
	name = "Jettisonned Station Engine"
	icon_state = "engine"


//ABSOLUTELY POINTLESS!

/area/maintenance/pointless
	name = "Absolutely Pointless"
	icon = 'icons/turf/areas2.dmi' //Because FAK
	icon_state = "honk"
	ambientsounds = list('sound/music/atmosdel.ogg')

//butts