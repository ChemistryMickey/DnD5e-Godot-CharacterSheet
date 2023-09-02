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

func find_in_dictionary(dict: Dictionary, term):
	if dict is Dictionary:
		if not dict.has(term):
			for item in dict:
				var output = find_in_dictionary(dict[item], term)
				if output is Dictionary:
					if not output.is_empty():
						return output

		else:
			return dict[term]
	else:
		return {}
		
func recursive_dict_merge(dict1: Dictionary, dict2: Dictionary) -> Dictionary:
	var merged_dict = {}
	for key in dict1.keys():
		# Make simple copy of dict1
		merged_dict.merge({key: dict1[key]}) 
		
	for key in dict2.keys():
		if dict2[key] is Dictionary and merged_dict.has(key):
			merged_dict[key].merge(recursive_dict_merge(merged_dict[key], dict2[key]))
		elif dict2[key] is Array and merged_dict.has(key):
			for item in dict2[key]:
				if item not in merged_dict[key]:
					merged_dict[key].append(item)
		else:
			merged_dict[key] = dict2[key]
	return merged_dict

func load_jsons_from_dir(path: String, dict: Dictionary) -> void:
	var json_raw_strs = []
	var filenames = []
	var dir = DirAccess.open(path).get_files()
	if dir:
		for cur_file in dir:
			var contents = FileAccess.open("%s/%s" % [path, cur_file], FileAccess.READ).get_as_text()
			json_raw_strs.append(contents)
			filenames.append(cur_file.split('.')[0])

	for idx in range(filenames.size()):
		var test_json_conv = JSON.parse_string(json_raw_strs[idx])
		dict[filenames[idx]] = test_json_conv
