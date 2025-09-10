extends Node

signal boss_spawned(health : float)
signal boss_first_damaged
signal boss_health_changed(damage : float)
signal boss_fifty_percent
signal boss_died(animation : String)
signal cutscene_finished
signal section_change

signal add_health
signal restore_health
signal lose_health
signal remove_health
signal player_hit
signal player_died

signal add_stamina
signal restore_stamina
signal lose_stamina
signal remove_stamina
signal minion_died

signal screenshake(time : float, amount : float)

signal end_shop
signal money_changed
