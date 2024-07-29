extends Panel

var SearchResultPrefab
var NumberOfSearchResults = 15
var NumberOfSearchResultsCreated = 0
var SearchResultsHolder

@onready var SearchResults = $SearchResults

func _ready():
	SearchResults.hide()
	SearchResultPrefab = preload("res://Prefabs/search_result.tscn")
	SearchResultsHolder = SearchResults.get_node("ScrollContainer/SearchResultsHolder")
	DisplaySearchResults()

func DisplaySearchResults():
	SearchResults.show()
	for i in range(0, NumberOfSearchResults):
		NumberOfSearchResultsCreated += 1
		print(NumberOfSearchResultsCreated)
		var NewSearchResult = SearchResultPrefab.instantiate()
		SearchResultsHolder.add_child(NewSearchResult)
		NewSearchResult.get_node("Name").text = str(i)
	SearchResultsHolder.move_child(SearchResultsHolder.get_node("EndingSeperator"), SearchResultsHolder.get_children().size())

func _on_local_user_search_input_text_submitted(new_text):
	DisplaySearchResults()

func _on_search_button_on_bar_pressed():
	print("adam est null")
	#DisplaySearchResults()
