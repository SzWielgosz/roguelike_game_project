extends Node
var player_money = 0
var player_health = 3
var player_hearts = 3
var player_max_hearts = 10
var player_is_dead = false

func save_state(health, money):
	player_health = health
	player_money = money
	
	
func add_money(amount):
	player_money += amount
	

func remove_money(amount):
	if player_money >= amount:
		player_money -= amount
		return true
	return false
	
	
func take_damage(amount):
	player_health -= amount
	if player_health < 0:
		player_health = 0
		

func heal(amount):
	player_health += amount
