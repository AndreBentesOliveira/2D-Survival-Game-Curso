extends Node

signal experience_vial_collected(number: float)
signal ability_upgrades_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary)
signal player_damaged

var enemys_killed := 0
var current_player_level := 0


func emit_experience_vial_collected(number: float):
	experience_vial_collected.emit(number)


func emit_ability_upgrade_added(upgrade: AbilityUpgrade, current_upgrades: Dictionary):
	ability_upgrades_added.emit(upgrade, current_upgrades)


func emit_player_damaged():
	player_damaged.emit()


func on_enemy_killed():
	enemys_killed += 1


func emit_on_player_levelup(current_level):
	current_player_level = current_level
