extends Control


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var userinfo = null

# Called when the node enters the scene tree for the first time.
func _ready():
	Firebase.Auth.connect("login_succeeded", self, "_on_FirebaseAuth_login_succeeded")	
	Firebase.Auth.connect("login_failed", self, "_on_FirebaseAuth_login_failed")
	Firebase.Auth.connect("signup_succeeded", self, "_on_FirebaseAuth_signup_succeeded")
	Firebase.Auth.connect("signup_failed", self, "_on_FirebaseAuth_signup_failed")	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass


func _on_Login_button_up():
	var email = $UserName.text
	var password = $Password.text
	Firebase.Auth.login_with_email_and_password(email,password)
	pass # Replace with function body.

func _on_FirebaseAuth_login_succeeded(auth_info):
	print("Success!")
	userinfo = auth_info
	get_tree().change_scene("res://scenes/Worlds/HomeBase.tscn")


func _on_FirebaseAuth_login_failed(error_code, message):
	print("error code: " + str(error_code))
	print("message: " + str(message))
	$Errors.text = "INVALID EMAIL/PASSWORD"


func _on_Register_button_up():
	var email = $UserName.text
	var password = $Password.text
	Firebase.Auth.signup_with_email_and_password(email, password)
	pass # Replace with function body.

func _on_FirebaseAuth_signup_succeeded(auth_info):
	print("signup successful" + str(auth_info))
	userinfo = auth_info
	Firebase.Auth.send_account_verification_email()
	
func _on_FirebaseAuth_signup_failed(error_code, message):
	print("error code: " + str(error_code))
	print("message: " + str(message))
	$Errors.text = "EMAIL ALREADY TAKEN"

func _on_ForgotPassword_button_up():
	var email = $UserName.text
	Firebase.Auth.send_password_reset_email(email)
	pass # Replace with function body.
