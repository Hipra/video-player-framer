# Variables
isPlaying = false

# Layers
background = new BackgroundLayer
	backgroundColor: "#222"

video = new VideoLayer
	video: "video/sample-video.mp4"
	width: 720
	height: 480
	backgroundColor: "#ffffff"
	
video.center()
	
controlBar = new Layer
	parent: video
	height: 48
	width: video.width - 96
	y: video.height - 48
	x: 40
	backgroundColor: "#aaa"
	
buttonPlay = new Layer
	width: 32
	height: 32
	backgroundColor: "red"
	parent: controlBar
	
buttonPause = new Layer
	width: buttonPlay.width
	height: buttonPlay.height
	backgroundColor: "blue"
	visible: false
	parent: controlBar

buttonReload = new Layer
	backgroundColor: "red"
	width: 64
	height: 64
	parent: video
	visible: false

buttonReload.center()

# Functions
play = () ->
	video.player.play()
	buttonPlay.visible = false
	buttonPause.visible = true
	isPlaying = true
	
	controlBar.animate
		properties: 
			opacity: 0
		delay: 1
		time: 0.2

pause = () ->
	video.player.pause()
	buttonPlay.visible = true
	buttonPause.visible = false
	isPlaying = false
	
	controlBar.animate
		properties: 
			opacity: 1
		time: 0.2

# Events
buttonPlay.onClick (event) ->
	event.stopPropagation()
	play()
	
buttonPause.onClick (event) ->
	event.stopPropagation()
	pause()
	
video.onClick ->
	if isPlaying
		pause()
	else
		play()
		
video.player.onended = ->
	buttonReload.visible = true
	buttonPlay.visible = true
	buttonPause.visible = false
	isPlaying = false
	
buttonReload.onClick (event) ->
	event.stopPropagation()
	buttonReload.visible = false
	play()
	
video.onMouseMove ->
	controlBar.animate
		properties:
			opacity: 1
		time: 0.2
