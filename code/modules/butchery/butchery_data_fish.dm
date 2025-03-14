/decl/butchery_data/animal/fish
	meat_name     = "fish"
	meat_type     = /obj/item/food/butchery/meat/fish
	meat_material = /decl/material/solid/organic/meat/fish
	bone_material = /decl/material/solid/organic/bone/fish
	skin_material = /decl/material/solid/organic/skin/fish
	meat_amount   = 1
	bone_amount   = 3
	skin_amount   = 3
	must_use_hook = FALSE
	gut_type      = /obj/item/food/butchery/offal/small
	meat_flags    = ALLERGEN_FISH

/decl/butchery_data/animal/fish/oily
	meat_type     = /obj/item/food/butchery/meat/fish/oily

/decl/butchery_data/animal/fish/small
	bone_amount     = 1
	skin_amount     = 2
	butchery_offset = list(-14, 4)

/decl/butchery_data/animal/fish/medium
	meat_amount     = 2
	butchery_offset = list(-7, -2)

/decl/butchery_data/animal/fish/carp
	meat_type     = /obj/item/food/butchery/meat/fish/carp
	stomach_type  = /obj/item/food/butchery/stomach
	butchery_offset = list(-10, -2)

/decl/butchery_data/animal/fish/space_carp
	meat_type     = /obj/item/food/butchery/meat/fish/poison
	skin_material = /decl/material/solid/organic/skin/fish/purple
	bone_material = /decl/material/solid/organic/bone/cartilage
	stomach_type  = /obj/item/food/butchery/stomach

/decl/butchery_data/animal/fish/space_carp/pike
	meat_amount     = 10
	bone_amount     = 20
	skin_amount     = 20
	must_use_hook   = TRUE
	gut_type        = /obj/item/food/butchery/offal
	butchery_offset = list(-16, 0)

/decl/butchery_data/animal/fish/shark
	meat_type       = /obj/item/food/butchery/meat/fish/shark
	meat_amount     = 5
	bone_amount     = 15
	skin_amount     = 15
	bone_material   = /decl/material/solid/organic/bone/cartilage
	skin_material   = /decl/material/solid/organic/skin/shark
	must_use_hook   = TRUE
	stomach_type    = /obj/item/food/butchery/stomach
	gut_type        = /obj/item/food/butchery/offal
	butchery_offset = list(-6, 0)

/decl/butchery_data/animal/fish/shark/large
	meat_amount     = 10
	bone_amount     = 30
	skin_amount     = 30
	butchery_offset = list(-16, 0)

/decl/butchery_data/animal/fish/mollusc
	meat_name     = "mollusc"
	meat_type     = /obj/item/food/butchery/meat/fish/mollusc
	bone_material = /decl/material/solid/organic/bone/cartilage
	skin_material = /decl/material/solid/organic/skin // i have no clue what mollusc skin is like aside from 'slimy'

/decl/butchery_data/animal/fish/mollusc/clam
	meat_type     = /obj/item/food/butchery/meat/fish/mollusc/clam
	bone_material = /decl/material/solid/organic/bone // no 'shell' material :(

/decl/butchery_data/animal/fish/mollusc/barnacle
	meat_type     = /obj/item/food/butchery/meat/fish/mollusc/barnacle
	bone_material = /decl/material/solid/organic/bone // maybe we just need calcium carbonate or something... limestone?

/decl/butchery_data/animal/fish/mollusc/octopus
	meat_name     = "tako"
	meat_type     = /obj/item/food/butchery/meat/fish/octopus
	stomach_type  = /obj/item/food/butchery/stomach
	gut_type      = /obj/item/food/butchery/offal
	meat_amount   = 5
	bone_amount   = 15
	skin_amount   = 15
	must_use_hook = TRUE