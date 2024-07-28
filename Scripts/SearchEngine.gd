extends Panel

var SearchEngineOpen = false

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
var ParcourirWebsitePrefab

var TabsLine

var MinimumTabLength = 180
var MaximumTabLength = 300-8
var MaxNumberOfTabs = 14

var OpenedTab

var WebsiteIndex = 0

@onready var WebsitesHolder = $WebsitesHolder

var GlobalUserSearchInput

var OpenedWebsite

func HideAllWebsites():
	for Website in WebsitesHolder.get_children():
		Website.hide()

func OpenTab(TabToOpen):
	HideAllWebsites()
	OpenedTab = TabToOpen
	for Tab in TabsLine.get_children():
		Tab.Deselect()
	OpenedTab.Select()
	
	for Website in WebsitesHolder.get_children():
		if(Website.get_meta("LinkedWebsite") == TabToOpen.get_meta("LinkedWebsite")):
			OpenedWebsite = Website
			Website.show()
			GlobalUserSearchInput.text = Website.get_meta("UserSearchInput")

func InsertNewTab():
	var NewTab = BrowserTabPrefab.instantiate()
	NewTab.set_meta("LinkedWebsite", WebsiteIndex)
	var NewParcourirWebsite = ParcourirWebsitePrefab.instantiate()
	NewParcourirWebsite.set_meta("LinkedWebsite", WebsiteIndex)
	NewParcourirWebsite.get_node("Title").text = "[center]" + str(WebsiteIndex) + "[/center]"
	WebsiteIndex += 1
	
	WebsitesHolder.add_child(NewParcourirWebsite)
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

# Called when the node enters the scene tree for the first time.
func _ready():
	BrowserTabPrefab = preload("res://Prefabs/browser_tab.tscn")
	ParcourirWebsitePrefab = preload("res://Websites/parcourir.tscn")
	
	GlobalUserSearchInput = get_node("LineTwo/GlobalUserSearchInput")
	get_node("LineTwo/NewTabButton").button_up.connect(InsertNewTab)
	TabsLine = get_node("TopPanel/Tabs")
	AppVisualTransition = get_node("AppVisualTransitionComponent")
	hide()

func ResetSearchBrowserText():
	get_node("Motto").text = "[center]" + Mottos[randf_range(0, Mottos.size())] + "[/center]"

func OpenWebsite(WebsiteToOpen):
	if(WebsiteToOpen in Websites):
		print("Opening website: " + WebsiteToOpen)
	else:
		print("No website with name: " + WebsiteToOpen )

func _on_search_button_on_bar_button_up():
	if(GlobalUserSearchInput.text.substr(0,4) == "www."):
		print("Contains www.")
		if(GlobalUserSearchInput.text.substr(GlobalUserSearchInput.text.length() - 4, GlobalUserSearchInput.text.length()) == ".com"):
			print("Contains .com")
			print("Opening website directly")
			print(GlobalUserSearchInput.text.substr(4, GlobalUserSearchInput.text.length() - 8))
			#www.OurChube.com
			OpenWebsite(GlobalUserSearchInput.text.substr(4, GlobalUserSearchInput.text.length() - 8))
		else:
			print("Doesn't contain .com")
	else:
		print("Doesn't contain www.")
		OpenWebsite(GlobalUserSearchInput.text)



func _on_global_user_search_input_text_changed(NewText):
	print("test")
	OpenedWebsite.set_meta("UserSearchInput", NewText)
