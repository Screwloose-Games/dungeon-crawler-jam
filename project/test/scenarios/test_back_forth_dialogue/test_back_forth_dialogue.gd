extends Node2D

const DUNGEON_CRAWLER_INTRO = preload("res://narrative/timelines/dungeon_crawler_intro.dtl")


func _ready() -> void:
	Dialogic.start(DUNGEON_CRAWLER_INTRO)
