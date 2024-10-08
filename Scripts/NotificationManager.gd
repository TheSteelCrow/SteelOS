extends VBoxContainer

var NOTIFICATION_TIMEOUT = 10

var MailNotificationPrefab

var Mail

var Main

func _ready():
	Main = get_tree().root.get_child(0)
	Mail = get_parent().get_node("Mail")
	MailNotificationPrefab = preload("res://Nofitications/mail_notification.tscn")

func SendMailNotification(Sender, Type, EmailID):
	if(Main.ShuttingDown == true):
		return
	
	get_parent().get_node("NotificationSound").play()
	move_to_front()
	var NewNotification = MailNotificationPrefab.instantiate()
	add_child(NewNotification)
	NewNotification.get_node("MailNotificationPanel/AnimationPlayer").play("SlideIn")
	
	NewNotification.get_node("MailNotificationPanel/Info").text = "FROM: " + Sender + "\nTYPE: " + Type
	
	NewNotification.get_node("MailNotificationPanel/Ignore").button_up.connect(func():
		remove_child(NewNotification)
		NewNotification.queue_free()
	)
	
	NewNotification.get_node("MailNotificationPanel/Open").button_up.connect(func():
		#Mail.get_node("AppBaseComponent").Close()
		Mail.get_node("AppBaseComponent").Open()
		Mail.OpenEmail(EmailID)
		Mail.get_node("MailData").LoadedEmails[EmailID][5] = true
		remove_child(NewNotification)
		NewNotification.queue_free()
	)
	
	await get_tree().create_timer(NOTIFICATION_TIMEOUT).timeout
	
	if(NewNotification != null):
		NewNotification.queue_free()
	
