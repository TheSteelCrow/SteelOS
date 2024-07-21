extends Panel

var SearchEngineOpen = false
var UserSearchInput

var AppRunning = false
var AppVisible = false

var AppVisualTransition

var IsFullscreen = false

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

func OnAppVisible():
	pass

func Open():
	InsertNewTab()

func Reset():
	for Tab in TabsLine.get_children():
		Tab.queue_free()
	ResetSearchBrowserText()

var Websites = ["OurChube", "TotallyNotScam", "Microsoft"]

var BrowserTabPrefab

var TabsLine

var MinimumTabLength = 180
var MaximumTabLength = 300-8
var MaxNumberOfTabs = 14

var OpenedTab

func OpenTab(TabToOpen):
	OpenedTab = TabToOpen
	for Tab in TabsLine.get_children():
		Tab.Deselect()
	OpenedTab.Select()

func InsertNewTab():
	var NewTab = BrowserTabPrefab.instantiate()
	TabsLine.add_child(NewTab)
	NewTab.text = "Parcourir"
	AlignTabs()
	OpenedTab = NewTab
	OpenTab(NewTab)

func AlignTabs():
	var TabsInTabsLine = TabsLine.get_children()
	#TabsInTabsLine.reverse()
	
	for Tab in TabsInTabsLine:
		Tab.size.x = (TabsLine.size.x - (8 * TabsInTabsLine.size())) / TabsInTabsLine.size()

	for i in range(TabsInTabsLine.size()):
		TabsInTabsLine[i].position = (Vector2(8 + ((TabsInTabsLine[0].size.x + 8) * i), 0))

	#if(TabsInTabsLine.size() > 6):
		#for Tab in TabsInTabsLine:
			#Tab.size.x = MaximumTabLength - (16 * TabsInTabsLine.size())
		
	#for i in range(TabsInTabsLine.size()):
		#TabsInTabsLine[i].position = (Vector2(8 + ((TabsInTabsLine[0].size.x + 8) * i), 0))

# Called when the node enters the scene tree for the first time.
func _ready():
	BrowserTabPrefab = preload("res://Prefabs/browser_tab.tscn")
	
	get_node("LineTwo/NewTabButton").button_up.connect(InsertNewTab)
	TabsLine = get_node("TopPanel/Tabs")
	AppVisualTransition = get_node("AppVisualTransitionComponent")
	UserSearchInput = get_node("UserSearchInput")
	hide()

func ResetSearchBrowserText():
	get_node("Motto").text = "[center]" + Mottos[randf_range(0, Mottos.size())] + "[/center]"

func OpenWebsite(WebsiteToOpen):
	if(WebsiteToOpen in Websites):
		print("Opening website: " + WebsiteToOpen)
	else:
		print("No website with name: " + WebsiteToOpen )

func _on_search_button_on_bar_button_up():
	if(UserSearchInput.text.substr(0,4) == "www."):
		print("Contains www.")
		if(UserSearchInput.text.substr(UserSearchInput.text.length() - 4, UserSearchInput.text.length()) == ".com"):
			print("Contains .com")
			print("Opening website directly")
			print(UserSearchInput.text.substr(4, UserSearchInput.text.length() - 8))
			#www.OurChube.com
			OpenWebsite(UserSearchInput.text.substr(4, UserSearchInput.text.length() - 8))
		else:
			print("Doesn't contain .com")
	else:
		print("Doesn't contain www.")
		OpenWebsite(UserSearchInput.text)
