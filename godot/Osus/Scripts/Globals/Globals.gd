extends Node

const PROCESS_LATENCY: float = 15.0
const AR: float = 1760.0

var song_pos_s: float = 0.0
var song_pos_ms: float = 0.0
var song_pos_beats: int = 0
var reported_latency: float = 0.0

var bpm: float = 0.0
var bps: float = 0.0
var secs_per_beat: float = 0.0
var half_beat: float = 0.0
var measure: int = 0

var timing_section_i: int = 0
var hit_object_i: int = 0
