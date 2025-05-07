class_name IBeatmapGeneral


var audio_file_name: String = ""
var audio_lead_in: int = 0
var audio_hash: String = "" # DEPRECATED
var preview_time: int = -1
var countdown: Enums.Countdown = Enums.Countdown.NORMAL
var sample_set: Enums.SampleSet = Enums.SampleSet.NONE
var stack_leniency: float = 0.7
var mode: Enums.Mode = Enums.Mode.NORMAL
var letterbox_in_breaks: bool = false
var story_fire_in_front: bool = true # DEPRECATED
var use_skin_sprites: bool = false
var always_show_playfield: bool = false # DEPRECATED
var overlay_position: Enums.OverlayPosition = Enums.OverlayPosition.NO_CHANGE
var skin_preference: String = ""
var epilepsy_warning: bool = false
var countdown_offset: int = 0
var special_style: bool = false
var widescreen_storyboard: bool = false
var samples_match_playback_rate: bool = false
