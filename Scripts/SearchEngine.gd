extends Panel

var SearchEngineOpen = false

var AppRunning = false
var AppVisible = false

var AppVisualTransition

var IsFullscreen = false

#Name : Link, FormalName, Description

var WebDomains = {
	
	"parcourir" : ["www.parcourir.com", "Parcourir - Search Engine", "Parcourir is a search engine designed to search the web. Parcourir means browse or search.", "Parcourir_WebIcon.png"],
	"government" : ["www.aloftia.govt", "Aloftia - Government Login", "Login terminal for the Aloftia Government", "AloftiaGovt_WebIcon.png"],
	"turbonews" : ["www.turbonews.com", "Turbo News - News you can trust", "News website for information on game updates as well as current events in Aloftia.", "TurboNews_WebIcon.png"],
	"crowosmanual" : ["www.crowosmanual.com", "CrowOS Manual - Trusty computer guide", "Need help using your computer? This is the guide for you!", "CrowOSManual_WebIcon.png"],
	"banc" : ["www.banc.com", "Banc - International banking", "Banc is the #1 Banking Website, keep your money safe with us!", "Banc_WebIcon.png"],
	"tenir" : ["www.tenirinvesting.com", "Tenir Investing - Stock trading company", "Tenir is a stock trading company with many investment opportunites. Invest your money today, to have something for tomorrow.", "Tenir_WebIcon.png"],
	"dailyquote" : ["www.dailyquote.com", "Daily Quote - Your daily dose of quotes", "Daily quote is a website which gives you a random quote from Dan Quayle. Remember, don't forget the 'e' on potatoe!", "DailyQuote_WebIcon.png"]
}

var BrowserTabPrefab
var ParcourirWebsitePrefab

var TabsLine

var OpenedTab

var WebsiteIndex = 0

@onready var WebsitesHolder = $WebsitesHolder

var GlobalUserSearchInput

var OpenedWebsite

func OnAppVisible():
	pass

func Open():
	InsertNewTab()

func Reset():
	for Tab in TabsLine.get_children():
		Tab.queue_free()

func ReplaceOpenedWebsite(Domain):
	OpenedWebsite.queue_free()
	OpenedTab.text = Domain
	var ReplacementWebsitePrefab = load("res://Websites/" + Domain + ".tscn")
	var ReplacementWebsite = ReplacementWebsitePrefab.instantiate()
	WebsitesHolder.add_child(ReplacementWebsite)
	ReplacementWebsite.set_meta("LinkedWebsite", OpenedTab.get_meta("LinkedWebsite"))
	ReplacementWebsite.move_to_front()
	OpenedWebsite = ReplacementWebsite
	GlobalUserSearchInput.text = WebDomains[Domain][0]

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
	WebsiteIndex += 1
	
	WebsitesHolder.add_child(NewParcourirWebsite)
	TabsLine.add_child(NewTab)
	NewTab.text = "parcourir"
	
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
	get_node("LineTwo/CopyURLButton").button_up.connect(func():DisplayServer.clipboard_set(GlobalUserSearchInput.text))
	TabsLine = get_node("TopPanel/Tabs")
	AppVisualTransition = get_node("AppVisualTransitionComponent")
	hide()

func OpenLink(Link):
	for Domain in WebDomains:
		if(WebDomains[Domain][0] == Link):
			ReplaceOpenedWebsite(Domain)

func _on_global_user_search_input_text_changed(NewText):
	OpenedWebsite.set_meta("UserSearchInput", NewText)

func _on_global_user_search_input_text_submitted(NewText):
	OpenLink(NewText)

func _on_search_button_on_bar_button_up():
	OpenLink(GlobalUserSearchInput.text)
