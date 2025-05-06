class_name Enums

# Enums for Beatmap Parsing
enum Section {
	FORMAT,
	GENERAL,
	EDITOR,
	METADATA,
	DIFFICULTY,
	EVENTS,
	TIMINGPOINTS,
	COLOURS,
	HITOBJECTS,
	FONTS,
	CATCHTHEBEAT,
	MANIA,
}

enum Countdown {
	NONE,
	NORMAL,
	HALF,
	DOUBLE,
}

enum SampleSet {
	NONE, 
	NORMAL, 
	SOFT, 
	DRUM,
}

enum Mode {
	NORMAL,
	TAIKO,
	CATCH,
	MANIA,
}

#  Enums for Dicts
enum Event {
	BACKGROUND,
	VIDEO,
	BREAK,
	STORYBOARD,
}

enum Effect {
	NONE, 
	KIAI, 
	OMIT_FIRST_BAR_LINE = 8,
}

enum HitObject {
	HIT_CIRCLE,
	SLIDER,
	NEW_COMBO,
	SPINNER,
	ONE_SKIP,
	TWO_SKIP,
	THREE_SKIP,
	MANIA_HOLD,
}

enum HitSound {
	NORMAL, 
	WHISTLE, 
	FINISH,
	CLAP,
}

enum HitSample {
	NONE,
	NORMAL,
	SOFT,
	DRUM,
}

enum SliderCurve {
	BEZIER,
	CENTRIPETAL,
	CATMULL_ROM, # DEPRECATED
	LINEAR,
	PERFECT_CIRCLE
}

enum OverlayPosition {
	NO_CHANGE,
	BELOW,
	ABOVE
}
