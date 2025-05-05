```
.osu File Format Specification  
Source: https://osu.ppy.sh/wiki/en/Client/File_formats/Osu_(file_format)

--------------------------------------------------
File Header
--------------------------------------------------
osu file format v14

--------------------------------------------------
[General]
--------------------------------------------------
AudioFilename       : File name of the background audio  
AudioLeadIn         : Time in ms before the first hit object  
PreviewTime         : Timestamp in ms for the audio preview  
Countdown           : 0 = no, 1 = yes  
SampleSet           : "Normal", "Soft", or "Drum"  
StackLeniency       : Decimal value, typically between 0 and 1  
Mode                : 0 = osu!, 1 = Taiko, 2 = Catch, 3 = Mania  
LetterboxInBreaks   : Whether breaks use letterboxing (0 or 1)  
WidescreenStoryboard: 1 = widescreen storyboard, 0 = no  

--------------------------------------------------
[Editor]
--------------------------------------------------
Bookmarks        : Comma-separated list of timestamps  
DistanceSpacing  : Affects slider velocity in the editor  
BeatDivisor      : Timing grid snapping (e.g., 4 = 1/4 beat)  
GridSize         : Editor grid size (e.g., 4 = 4x4)  
TimelineZoom     : Editor timeline zoom level  

--------------------------------------------------
[Metadata]
--------------------------------------------------
Title           : Song title  
TitleUnicode    : Unicode title  
Artist          : Artist name  
ArtistUnicode   : Unicode artist name  
Creator         : Beatmap creator username  
Version         : Difficulty name  
Source          : Source (e.g., anime/game)  
Tags            : Space-separated keywords  
BeatmapID       : osu! beatmap ID  
BeatmapSetID    : osu! beatmap set ID  

--------------------------------------------------
[Difficulty]
--------------------------------------------------
HPDrainRate     : 0–10, how fast HP drains  
CircleSize      : Affects hit circle radius or Mania keys  
OverallDifficulty: Affects hit window timing  
ApproachRate    : Time before hit objects appear  
SliderMultiplier: Base slider speed  
SliderTickRate  : Slider tick frequency  

--------------------------------------------------
[Events]
--------------------------------------------------
Backgrounds, videos, and storyboard data  
Format: Type, StartTime, Params  
Example: 0,0,"bg.jpg"  

--------------------------------------------------
[TimingPoints]
--------------------------------------------------
Each line = one timing or inherited point  
Format:  
Time, BeatLength, Meter, SampleSet, SampleIndex, Volume, Uninherited, Effects  
Example:  
500,300,4,2,1,70,1,0  

--------------------------------------------------
[Colours]
--------------------------------------------------
Combo color definitions  
Example:  
Combo1 : 255,192,0  
Combo2 : 0,202,0  

--------------------------------------------------
[HitObjects]
--------------------------------------------------
Hit object data: circles, sliders, spinners, mania holds  
Format:  
x, y, time, type, hitSound, [objectParams], [hitSample]  
Examples:  
256,192,1234,1,0  
300,200,1500,2,0,B|400:200|400:300,1,0  
128,128,2000,5,8,0:0:0:0:
```
