extends Panel

var Mottos = [
	"Parcourir: Where Your Data Finds a New Home.",
	"Parcourir: Your Privacy? What Privacy?",
	"Parcourir: Surf and Surrender Your Secrets.",
	"Parcourir: We Know What You Did Last Session.",
	"Parcourir: The Browser That Keeps a Little for Itself.",
	"Parcourir: Trust Us... Maybe You Shouldn't.",
	"Parcourir: Because Your Data is Our Business.",
	"Parcourir: Browse Boldly, Share Unknowingly.",
	"Parcourir: The Browser with a Hidden Agenda.",
	"Parcourir: Your Window to the Web, Our Door to Your Data."
]

var SearchResultPrefab
var SearchResultsHolder

@onready var SearchResults = $SearchResults

var SearchEngine

func _ready():
	get_node("Motto").text = "[center]" + Mottos[randf_range(0, Mottos.size())] + "[/center]"
	SearchEngine = get_tree().root.get_child(0).get_node("SearchEngine")
	SearchResults.hide()
	SearchResultPrefab = preload("res://Prefabs/search_result.tscn")
	SearchResultsHolder = SearchResults.get_node("ScrollContainer/SearchResultsHolder")

func DisplaySearchResults():
	SearchResults.show()
	for Domain in SearchEngine.WebDomains:
		var NewSearchResult = SearchResultPrefab.instantiate()
		SearchResultsHolder.add_child(NewSearchResult)
		
		NewSearchResult = NewSearchResult.get_node("Button")
		
		NewSearchResult.button_up.connect(func():
			SearchEngine.ReplaceOpenedWebsite(Domain)
		)
		
		NewSearchResult.get_node("Name").text = Domain
		NewSearchResult.get_node("Link").text = SearchEngine.WebDomains[Domain][0]
		NewSearchResult.get_node("FormalName").text = SearchEngine.WebDomains[Domain][1]
		NewSearchResult.get_node("Description").text = SearchEngine.WebDomains[Domain][2]
		NewSearchResult.get_node("Logo").texture = load("res://Images/WebsiteIcons/" + SearchEngine.WebDomains[Domain][3])
		
	SearchResultsHolder.move_child(SearchResultsHolder.get_node("EndingSeperator"), SearchResultsHolder.get_children().size())

func _on_local_user_search_input_text_submitted(new_text):
	DisplaySearchResults()

func _on_search_button_on_bar_pressed():
	DisplaySearchResults()
