extends Node

var num_inventory_entries = 0

func unique(arr_in : Array) -> Array:
	# Doesn't sort
	var array_out = []
	for item in arr_in:
		if item in array_out:
			continue
		array_out.append(item)
	return array_out

func find_in_dictionary(dict, term):
	if dict is Dictionary:
		if not dict.has(term):
			for item in dict:
				var output = find_in_dictionary(dict[item], term)
				if output is Dictionary:
					if not output.empty():
						return output

		else:
			return dict[term]
	else:
		return {}
		

