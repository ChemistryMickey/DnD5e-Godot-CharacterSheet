extends VBoxContainer

var money_log_template = preload("res://src/UI/CharacterSheetSubpages/TransactionLog/MoneyEntry.tscn")

func _ready() -> void:
	Signals.connect("add_purchase_entry", self, "add_purchase")
	
func add_purchase(item_name : String, quantity : String, price : Array):
	var new_log = money_log_template.instance()
	var purchase_str = "Purchased %sx %s" % [quantity, item_name]
	var total_price = []
	for currency in price:
		total_price.append("-%s" % String(int(quantity) * int(currency)))
		
	new_log.set_props(purchase_str, total_price)
	self.add_child(new_log)

func save():
	var save_dict = {"Money Entries" : []}
	for child in self.get_children():
		save_dict["Money Entries"].append(child.save())
	return save_dict
	
func load_sheet(save_dict):
	for child in self.get_children():
		child.queue_free()
		
	for entry in save_dict["Money Entries"]:
		var new_entry = money_log_template.instance()
		new_entry.load_sheet(entry)
		self.add_child(new_entry)
	Signals.emit_signal("money_changed")
