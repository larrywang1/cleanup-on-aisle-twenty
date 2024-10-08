extends Control

func restore_health():
	$Inner.visible = true

func lost_health():
	$Inner.visible = false
