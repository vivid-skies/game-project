# README

### vividskies
- Danny Cao 103031155: Beatmap parsing & a scuffed prototype for a demo (only circles are supported atm)

## Notes
- Most of the project was spent on creating utilities and functions that could parse Beatmaps, these are archives that contain data such as audio, data on hit objects (these are those circles and sliders that you see in Osu gameplay), and other assets like any custom skins are visual stuff. You can find the code for it in godot/OsuLib in the project files if you want to check it out, otherwise godot/Osus is where the "game" files are stored in, a lot of the stuff in there is mostly just a testbed for me to try and learn new things about Godot.
- There was an attempt from me to create a working demo playthrough of a beatmap, but I didn't get time to finish it off.
- Currently the demo is just a main menu the the play button changes the scene to the beatmap, but it is not currently working with the export build, for some reason the level doesn't play but works fine when in the editor, I think this is something to do with how it resolves directories when exporting the project as an .exe, and I couldn't be be bothered to troubleshoot it (wasn't the main goal for this project anyways)

**Tools used:**
- GitHub
- Git
- Godot (4.4 Mono)

**Resources used:**
- [Godot Docs](https://docs.godotengine.org/en/stable/index.html) (GDScript API & Example code)
-  [ I want to make a rhythm game but I don't know how – Lislis – GodotCon2024](https://youtu.be/eEZvcG_TIHo?si=fe-7mXqcgEASjWmU)(Demonstration video)
- [Complete Godot Rhythm Game Tutorial](https://youtu.be/_FRiPPbJsFQ?si=gczkonK02JqzG8uS) (Demonstration video)
- [godot-2d-rhythm](https://github.com/gdquest-demos/godot-2d-rhythm) (Example project)
- [Osu GitHub](https://github.com/ppy/osu) (Used as reference and grab some of their assets)
- [OsuParsers](https://github.com/mrflashstudio/OsuParsers) (Used as reference on setting up parsing)
- [Osu Wiki](https://osu.ppy.sh/wiki/en/Client/File_formats/osu_%28file_format%29) (To figure out what the hell the numbers mean in the data files)
