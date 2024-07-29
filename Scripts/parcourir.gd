extends Panel

var SearchResultPrefab
var SearchResultsHolder

@onready var SearchResults = $SearchResults

#Name : Link, FormalName, Description

var SearchEngine

var WebDomains = {
	
	"parcourir" : ["www.parcourir.com", "Parcourir", "Parcourir is a search engine designed to search the web. Parcourir means browse or search."],
	"government" : ["www.aloftia.govt", "Aloftia Government Login", "Login terminal for the Aloftia Government"]
	
}

func _ready():
	SearchResults.hide()
	SearchResultPrefab = preload("res://Prefabs/search_result.tscn")
	SearchResultsHolder = SearchResults.get_node("ScrollContainer/SearchResultsHolder")

func DisplaySearchResults():
	SearchResults.show()
	for Domain in WebDomains:
		var NewSearchResult = SearchResultPrefab.instantiate()
		SearchResultsHolder.add_child(NewSearchResult)
		
		#NewSearchResult.button_up.connect(func():
			
		#)
		
		NewSearchResult.get_node("Name").text = Domain
		NewSearchResult.get_node("Link").text = WebDomains[Domain][0]
		NewSearchResult.get_node("FormalName").text = WebDomains[Domain][1]
		NewSearchResult.get_node("Description").text = WebDomains[Domain][2]
		
	SearchResultsHolder.move_child(SearchResultsHolder.get_node("EndingSeperator"), SearchResultsHolder.get_children().size())

func _on_local_user_search_input_text_submitted(new_text):
	DisplaySearchResults()

func _on_search_button_on_bar_pressed():
	DisplaySearchResults()
