@tool
extends Control

var effect: AudioEffect
var recording: AudioStreamWAV
var microphone: AudioStreamMicrophone

var stereo := true
var mix_rate := 44100  # This is the default mix rate on recordings.
var format := AudioStreamWAV.FORMAT_16_BITS  # This is the default format on recordings.

@onready var record_button = $RecordButton
@onready var play_button = $PlayButton
@onready var stereo_check_button = $StereoCheckButton
@onready var save_button = $SaveButton
@onready var format_option_button = $FormatOptionButton
@onready var mix_rate_option_button = $MixRateOptionButton
@onready var file_dialog = %FileDialog
@onready var audio_input_option_button: OptionButton = %AudioInputOptionButton


func _ready() -> void:
	enable_audio_input()
	populate_audio_input_devices()
	var idx := AudioServer.get_bus_index("Record")
	effect = AudioServer.get_bus_effect(idx, 0)
	record_button.pressed.connect(_on_record_button_pressed)
	play_button.pressed.connect(_on_play_button_pressed)
	save_button.pressed.connect(_on_save_button_pressed)
	format_option_button.toggled.connect(_on_stereo_check_button_toggled)
	mix_rate_option_button.item_selected.connect(_on_mix_rate_option_button_item_selected)
	format_option_button.item_selected.connect(_on_format_option_button_item_selected)
	audio_input_option_button.item_selected.connect(_on_input_device_selected)


func populate_audio_input_devices() -> void:
	var devices := AudioServer.get_input_device_list()
	var audio_input_options = []
	audio_input_option_button.clear()
	for device in devices:
		if device.begins_with("Microphone"):
			#audio_input_options.append(device)
			audio_input_option_button.add_item(device)
			#microphone = AudioStreamMicrophone.new()


func _on_input_device_selected(index: int) -> void:
	# This is a workaround to get the microphone working.
	# The AudioStreamMicrophone does not work properly in the editor, so we use a placeholder.
	var device := audio_input_option_button.get_item_text(index)
	if device == "":
		push_error("No microphone selected. Please select a microphone from the dropdown.")
		return
	AudioServer.set_input_device(device)

	# Uncomment the following lines if you want to use the microphone directly.
	#microphone = AudioStreamMicrophone.new()
	#microphone.set_device(device)
	#effect.set_input_stream(microphone)

	# For now, we will just print the selected device.
	print("Selected input device: %s" % device)


#
#microphone.set_device(device)
#effect.set_input_stream(microphone)
#break
#if microphone == null:
#push_error("No microphone found. Please connect a microphone to use this feature.")


func _on_record_button_pressed() -> void:
	if effect.is_recording_active():
		recording = effect.get_recording()
		$PlayButton.disabled = false
		$SaveButton.disabled = false
		effect.set_recording_active(false)
		recording.set_mix_rate(mix_rate)
		recording.set_format(format)
		recording.set_stereo(stereo)
		$RecordButton.text = "Record"
		$Status.text = ""
	else:
		$PlayButton.disabled = true
		$SaveButton.disabled = true
		effect.set_recording_active(true)
		$RecordButton.text = "Stop"
		$Status.text = "Status: Recording..."


func _on_play_button_pressed() -> void:
	var data := recording.get_data()
	$AudioStreamPlayer.stream = recording
	$AudioStreamPlayer.play()


func enable_audio_input() -> void:
	# set project setting "audio/driver/enable_input"
	ProjectSettings.set_setting("audio/driver/enable_input", true)


func list_input_devices() -> void:
	var devices := AudioServer.get_input_device_list()
	for device in devices:
		print("Input Device: %s" % device)


func _on_save_button_pressed() -> void:
	file_dialog.popup()
	await file_dialog.confirmed
	var save_path: String = file_dialog.current_path
	var extension = ".wav"
	recording.save_to_wav(save_path + extension)
	$Status.text = (
		"Status: Saved WAV file to: %s\n(%s)"
		% [save_path, ProjectSettings.globalize_path(save_path)]
	)


func _on_mix_rate_option_button_item_selected(index: int) -> void:
	match index:
		0:
			mix_rate = 11025
		1:
			mix_rate = 16000
		2:
			mix_rate = 22050
		3:
			mix_rate = 32000
		4:
			mix_rate = 44100
		5:
			mix_rate = 48000
	if recording != null:
		recording.set_mix_rate(mix_rate)


func _on_format_option_button_item_selected(index: int) -> void:
	match index:
		0:
			format = AudioStreamWAV.FORMAT_8_BITS
		1:
			format = AudioStreamWAV.FORMAT_16_BITS
		2:
			format = AudioStreamWAV.FORMAT_IMA_ADPCM
	if recording != null:
		recording.set_format(format)


func _on_stereo_check_button_toggled(button_pressed: bool) -> void:
	stereo = button_pressed
	if recording != null:
		recording.set_stereo(stereo)
