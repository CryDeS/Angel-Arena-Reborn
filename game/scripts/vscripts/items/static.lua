local init = false

local blocked_abilities = {
    ["reaver_lord_attract"] = 1,
    ["item_power_treads"] = 1,
    ["item_power_treads_2"] = 1,
    ["item_power_treads_3"] = 1,
    ["item_ward_sentry"] = 1,
    ["item_ward_observer"] = 1,
    ["obsidian_destroyer_arcane_orb"] = 1,
    ["tinker_rearm"] = 1,
    ["sniper_shrapnel"] = 1,
    ["storm_spirit_ball_lightning"] = 1,
    ["earth_spirit_stone_caller"] = 1,
    ["spectre_reality"] = 1,
    ["item_shadow_amulet"] = 1,
    ["courier_return_to_base"] = 1,
    ["courier_go_to_secretshop"] = 1,
    ["courier_transfer_items"] = 1,
    ["courier_return_stash_items"] = 1,
    ["courier_take_stash_items"] = 1,
    ["courier_take_stash_and_transfer_items"] = 1,
    ["courier_shield"] = 1,
    ["courier_burst"] = 1,
    ["riki_blink_strike"] = 1,
    ["courier_morph"] = 1,
    ["leshrac_pulse_nova"] = 1,
    ["item_bottle"] = 1,
    ["item_clarity"] = 1,
    ["item_moon_shard"] = 1,
    ["item_flask"] = 1,
    ["item_ward_dispenser"] = 1,
    ["item_smoke_of_deceit"] = 1,
    ["rubick_spell_steal"] = 1,
    ["ogre_magi_bloodlust"] = 1,
    ["rubick_telekinesis_land"] = 1,
    ["item_enchanted_mango"] = 1,
    ["skywrath_mage_mystic_flare"] = 1,
    ["elder_titan_return_spirit"] = 1,
    ["broodmother_spin_web"] = 1,
    ["shredder_return_chakram_2"] = 1,
    ["shredder_return_chakram"] = 1,
    ["phoenix_sun_ray_toggle_move"] = 1,
    ["phoenix_sun_ray_stop"] = 1,
    ["phoenix_icarus_dive_stop"] = 1,
    ["ember_spirit_activate_fire_remnant"] = 1,
    ["ember_spirit_fire_remnant"] = 1,
    ["nyx_assassin_unburrow"] = 1,
    ["lone_druid_true_form_druid"] = 1,
    ["lone_druid_true_form"] = 1,
    ["invoker_exort"] = 1,
    ["invoker_wex"] = 1,
    ["invoker_quas"] = 1,
    ["enchantress_impetus"] = 1,
    ["templar_assassin_self_trap"] = 1,
    ["witch_doctor_voodoo_restoration"] = 1,
    ["morphling_morph_str"] = 1,
    ["morphling_morph_agi"] = 1,
    ["item_tome_agi_3"] = 1,
    ["item_tome_agi_6"] = 1,
    ["item_tome_agi_60"] = 1,
    ["item_tome_str_3"] = 1,
    ["item_tome_str_6"] = 1,
    ["item_tome_str_60"] = 1,
    ["item_tome_int_3"] = 1,
    ["item_tome_int_6"] = 1,
    ["item_tome_int_60"] = 1,
    ["item_tome_lvlup"] = 1,
    ["item_tome_med"] = 1,
    ["item_branches"] = 1,
    ["item_tome_un_3"] = 1,
    ["item_tome_un_6"] = 1,
    ["item_tome_un_60"] = 1,
    ["invoker_quas"] = 1,
    ["invoker_wex"] = 1,
    ["invoker_exort"] = 1,
    ["invoker_invoke"] = 1,
    ["death_prophet_spirit_siphon"] = 1,
    ["pugna_life_drain"] = 1,
    ["item_tango"] = 1,
    ["item_diffusal_blade"] = 1,
    ["item_diffusal_blade_2"] = 1,
    ["phoenix_launch_fire_spirit"] = 1,
    ["shadow_demon_shadow_poison_release"] = 1,
    ["shadow_demon_demonic_purge"] = 1,
    ["item_mystic_amulet"] = 1,
    ["nyx_assassin_burrow"] = 1,
    ["bristleback_viscous_nasal_goo"] = 1,
    ["techies_focused_detonate"] = 1,
    ["item_tome_of_knowledge"] = 1,
    ["life_stealer_control"] = 1,
    ["templar_assassin_trap"] = 1,
    ["pudge_rot"] = 1,
    ["skeleton_king_vampiric_aura"] = 1,
    ["abyssal_underlord_cancel_dark_rift"] = 1,
    ["troll_warlord_berserkers_rage"] = 1,
    ["angel_arena_rifle"] = 1,
    ["angel_arena_firehell"] = 1,
    ["wisp_spirits_in"] = 1,
    ["wisp_spirits_out"] = 1,
    ["medusa_mana_shield"] = 1,
    ["medusa_split_shot"] = 1,
    ["wisp_overcharge"] = 1,
    ["fireblade_weapon_ignition"] = 1,
    ["fireblade_weapon_quenching"] = 1,
    ["phantom_lancer_phantom_edge"] = 1,
    ["item_slice_amulet"] = 1,
}

function DealDamageAroundCaster(caster, multiplier, damage_add, manacost, ability)
    if not caster then end
    local hero_name = caster:GetUnitName()

    if caster:GetMana() < manacost then return end

    local pos = caster:GetAbsOrigin()
    local team = caster:GetTeamNumber()
    local radius = 800

    local units = FindUnitsInRadius(team, pos, nil, radius, DOTA_UNIT_TARGET_TEAM_ENEMY, DOTA_UNIT_TARGET_HERO + DOTA_UNIT_TARGET_CREEP, DOTA_UNIT_TARGET_FLAG_NONE, 0, false)

    caster:SpendMana(manacost, nil)

    for _, x in pairs(units) do
        if x and caster and x:GetTeamNumber() ~= caster:GetTeamNumber() and IsValidEntity(x) and x:IsAlive() then
            local damage = x:GetHealth() * multiplier + damage_add
            ApplyDamage({ victim = x, attacker = caster, damage = damage, damage_type = DAMAGE_TYPE_MAGICAL, ability = ability })
        end
    end
end

function OnAbilityExecuted(keys)
    local caster = keys.caster
    local ability = keys.event_ability

    local damage = (keys.damage or 0)
    local damage_pct = (keys.damage_pct or 0) / 100
    local static_ability = keys.ability

    if (static_ability:GetToggleState()) then
        return
    end


    if not caster or not ability then return end
    if static_ability:GetCooldownTimeRemaining() > 0 then return end
    local manacost = keys.mana_cost
    local ability_name = ability:GetName()

    if blocked_abilities[ability_name] then return end

    if ability:GetCooldown(ability:GetLevel() - 1) == 0 then
        return
    end


    --print("static do damage ability = ", ability_name, "manacost = ", manacost)
    DealDamageAroundCaster(caster, damage_pct, damage, manacost, static_ability)
    static_ability:StartCooldown(static_ability:GetCooldown(static_ability:GetLevel()))
end