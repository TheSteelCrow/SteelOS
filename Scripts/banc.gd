extends Panel

var Main
var BalanceText

func _ready():
	Main = get_tree().root.get_child(0)
	BalanceText = get_node("PersonalAcc/Balance")
	BalanceText.text = "$" + str(Main.AccountBalance)

func _on_reset_button_up():
	BalanceText.text = "$" + str(Main.AccountBalance) + ".00"
