# Remove framer cursor
document.body.style.cursor = "auto"

# Variables
isPlaying = false
borderRadiusDefault = 5
backgroundDefault = "rgba(0, 0, 0, 0.7)"

# Layers
video = new VideoLayer
	video: "video/big_buck_bunny.mp4"
	width: 640, height: 360
	backgroundColor: "#ffffff"

videoActionable = new Layer
	parent: video
	width: video.width, height: video.height
	backgroundColor: "transparent"
	style: 
		"cursor" : "pointer"
		
startPlay = new Layer
	parent: video
	backgroundColor: backgroundDefault
	borderRadius: borderRadiusDefault
	width: 64, height: 64
	opacity: 1
	
iconStart = new Layer
	parent: startPlay
	width: 26, height: 32
	image: "images/icon-play-big.svg"
	
controlBar = new Layer
	parent: video
	width: video.width - 16, height: 40
	x: 8, y: video.height - 48
	backgroundColor: backgroundDefault
	borderRadius: borderRadiusDefault
	visible: false
	
progressElements = new Layer
	width: 440, height: controlBar.height
	parent: controlBar
	x: 40
	backgroundColor: "transparent"
	
buttonPlay = new Layer
	parent: controlBar
	width: 17, height: 20
	x: 10, y: 10
	style: 
		"cursor" : "pointer"

buttonPause = new Layer
	parent: controlBar
	width: 17, height: 20
	x: 10, y: 10
	image: "images/icon-pause.svg"
	style: 
		"cursor" : "pointer"
	visible: false

timeLeft = new Layer
	parent: progressElements
	backgroundColor: "transparent"
	width: 24, height: 12
	y: 12, x: 416
	
timeLeft.html = "0:00"
timeLeft.style = { "font" : "400 12px Helvetica" }

flashingPlay = new Layer
	parent: video
	width: 64, height: 64
	opacity: 0
	borderRadius: borderRadiusDefault
	backgroundColor: backgroundDefault
	
flashingPlayIcon = new Layer
	parent: flashingPlay
	width: 26, height: 32
	image: "images/icon-play-big.svg"

flashingPause = new Layer
	parent: video
	width: 64, height: 64
	opacity: 0
	borderRadius: borderRadiusDefault
	backgroundColor: backgroundDefault
	
flashingPauseIcon = new Layer
	parent: flashingPause
	width: 26, height: 32
	image: "images/icon-pause-big.svg"

video.center()
startPlay.center()
iconStart.center()
flashingPlay.center()
flashingPause.center()
flashingPlayIcon.center()
flashingPauseIcon.center()

# States
startPlay.states.add
	fadeOut: opacity: 0

controlBar.states.add
	fadeOut: opacity: 0
	fadeIn: opacity: 1
	
# Animation options
startPlay.states.animationOptions =
	time: 0.4

controlBar.states.animationOptions =
	time: 0.4

# Functions
play = () ->
	video.player.play()
	isPlaying = true
	videoActionable.height = video.height - 58
	buttonPlay.image = "images/icon-pause.svg"

pause = () ->
	video.player.pause()
	isPlaying = false
	startPlay.visible = false
	buttonPlay.image = "images/icon-play.svg"

# Events
videoActionable.onClick ->
	startPlay.states.switch("fadeOut")
	controlBar.visible = true
	if isPlaying 
		pause()
		flashingPause.opacity = 1
		flashingPause.scale = 1
		flashingPause.animate
			properties: 
				scale: 1.6
				opacity: 0
			time: 0.6
	else 
		play()
		flashingPlay.opacity = 1
		flashingPlay.scale = 1
		flashingPlay.animate
			properties: 
				scale: 1.6
				opacity: 0
			time: 0.6

video.onMouseOut ->
	controlBar.states.next("fadeOut")
	
video.onMouseOver ->
	controlBar.states.next("fadeIn")
	
buttonPlay.onClick ->
	if isPlaying 
		pause()
	else 
		play()
		
# Define & position sliders
progress = new SliderComponent 
	min: 0, max: 117
	width: 400, height: 2
	backgroundColor: "rgba(255,255,255,0.4)"
	parent: progressElements
	x: 6
	y: 18
	
progress.fill.backgroundColor = "#fff"
progress.fill.borderRadius = 4
progress.knobSize = 12

# Disable momentum
progress.knob.draggable.momentum = false

# Progress interaction
progress.knob.on Events.DragStart, -> 
	isPlaying = true unless video.player.paused

progress.knob.on Events.DragEnd, -> 
	video.player.currentTime = progress.value
	if isPlaying then pause()
	return isPlaying = false
	
progress.on "change:value", ->
	video.player.currentTime = Utils.round(this.value, 1)
	
Events.wrap(video.player).addEventListener "timeupdate", ->
	progress.knob.midX = progress.pointForValue(this.currentTime)
	timeLeft.html = "0:0" + Math.round(this.currentTime)
	if Math.round(this.currentTime) > 9 then timeLeft.html = "0:" + Math.round(this.currentTime)
