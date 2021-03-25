require('heroes/gun_joe/linked_ability')

LinkLuaModifier( "modifier_gun_joe_machine_gun", "heroes/gun_joe/modifiers/modifier_gun_joe_machine_gun", LUA_MODIFIER_MOTION_NONE )

gun_joe_machine_gun = gun_joe_machine_gun or MakeLinkedBaseClass("gun_joe_rifle", "modifier_gun_joe_machine_gun")
