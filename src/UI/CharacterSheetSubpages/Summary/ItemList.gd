extends ItemList

func _ready() -> void:
	Signals.connect("unequip_item", self, "unequip_item")
	Signals.connect("equip_item", self, "equip_item")
	
func equip_item(item : String):
	self.add_item(item)
	
func unequip_item(item : String):
	for idx in range(self.get_item_count()):
		if self.get_item_text(idx) == item:
			self.remove_item(idx)
			return
