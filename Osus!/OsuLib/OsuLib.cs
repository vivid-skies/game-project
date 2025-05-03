using Godot;
using System;
using OsuParsers.Beatmaps;
using OsuParsers.Decoders;
using System.IO.Compression;
using System.IO;
using System.Collections.Generic;


namespace OsuLib;

public partial class OsuLib : Node
{
    public string testProperty { get; set; } = "OsuLib";
	private HashSet<string> importedFilesCache = new HashSet<string>();
	private string cacheFilePath;

	public override void _Ready()
	{
		cacheFilePath = ProjectSettings.GlobalizePath("res://imported_files.cache");
		GD.Print("Cache file path initialised: ", cacheFilePath);
		LoadCache();

	}

	public void ImportOsz(string filePath)
	{
		// filePath = ProjectSettings.GlobalizePath("res://OsuLib/imported/1381405 USAO - Cthugha.osz");
		filePath = ProjectSettings.GlobalizePath(filePath);
		string processedPath = ProjectSettings.GlobalizePath("res://OsuLib/processed");

		if(!Godot.FileAccess.FileExists(filePath))
		{
			GD.PrintErr("File not found: ", filePath);
			return;
		}

		string oszFileName = Path.GetFileNameWithoutExtension(filePath);
		string extractDir = Path.Combine(processedPath, oszFileName);


		if (importedFilesCache.Contains(oszFileName) && !Directory.Exists(extractDir))
		{
			GD.Print($"Cache entry for '{oszFileName}' found, but directory is missing. Removing from cache...");
			importedFilesCache.Remove(oszFileName);
			SaveCache();
		}
		
		if (importedFilesCache.Contains(oszFileName))
		{
			GD.Print($"File '{oszFileName}' has already been imported. Skipping....");
		}

		if (!Directory.Exists(extractDir))
		{
			Directory.CreateDirectory(extractDir);
		}

		// .osz archive
		using (var archive = ZipFile.OpenRead(filePath))
		{
			foreach (var entry in archive.Entries)
			{
				string destinationPath = Path.Combine(extractDir, entry.FullName);

				// skips directories
				if (string.IsNullOrEmpty(entry.Name))
					continue;
				
				// check if file exists
				if (File.Exists(destinationPath))
				{
					if(FilesAreIdentical(entry, destinationPath))
					{
						GD.Print($"File '{destinationPath}' is identical. Skipping...");
						continue;
					}
					else 
					{
						GD.Print($"File '{destinationPath}' is missing. Extracting...");
					}

				}
				// Extract file & overwrite
				entry.ExtractToFile(destinationPath, true);
				// GD.Print($"File '{destinationPath}' has been extracted sucessfully.");
			}
		}

		importedFilesCache.Add(oszFileName);
		// GD.Print("Cache file path: ", cacheFilePath);
		// GD.Print("Imported files cache count: ", importedFilesCache?.Count ?? 0);
		SaveCache();

		GD.Print($"File '{oszFileName}' has been sucessfully imported");
	}
	
	private void LoadCache()
	{
		if(Godot.FileAccess.FileExists(cacheFilePath))
		{
			using var file = Godot.FileAccess.Open(cacheFilePath, Godot.FileAccess.ModeFlags.Read);
			while (!file.EofReached())
			{
				string line = file.GetLine();
				if (!string.IsNullOrEmpty(line))
				{
					importedFilesCache.Add(line);
				}
			}
			// GD.Print("Cache loaded successfully.");
		} 
		else 
		{
			GD.Print("No cache file found. Creating new cahce....");

			// Create cache if there isn't one already
			using var file = Godot.FileAccess.Open(cacheFilePath, Godot.FileAccess.ModeFlags.Write);
			string timestamp = DateTime.Now.ToString("dd-MM-yyyy HH:mm:ss");
			file.StoreLine($"# Cache initialised {timestamp}");
			GD.Print("New cache initialised at: ", cacheFilePath);
		}
	}

	private void SaveCache()
	{
		if(importedFilesCache == null)
		{
			GD.PrintErr("Error: Imported files cache not initialised.");
			return;
		}

		if (string.IsNullOrEmpty(cacheFilePath))
		{
			GD.PrintErr("Error: Cache file path not set.");
			return;
		}

		try 
		{
			using var file = Godot.FileAccess.Open(cacheFilePath, Godot.FileAccess.ModeFlags.Write);
			foreach (string fileName in importedFilesCache)
			{
				file.StoreLine(fileName);
			}

			GD.Print("Cache saved successfully.");
		}
		catch (Exception err)
		{
			GD.PrintErr($"Error saving cache: {err.Message}");
		}


	}

	public string BeatmapTitle(string filePath)
	{	
		filePath = ProjectSettings.GlobalizePath(filePath);

		if (!Godot.FileAccess.FileExists(filePath))
		{
			GD.PrintErr($"Error: Beatmap could not be found at path: {filePath}");
			return "File Not found";
		}

		try
		{
			Beatmap beatmap = BeatmapDecoder.Decode(filePath);
			string title = beatmap.MetadataSection.TitleUnicode;
			return title;
		}
		catch (Exception err)
		{
			GD.PrintErr($"Error decoding beatmap: {err.Message}");
			return "Error decoding beatmap";
		}
	}

	private bool FilesAreIdentical(ZipArchiveEntry entry, string existingFilePath)
	{
		// Compare file sizes first (quick check)
		if (entry.Length != new FileInfo(existingFilePath).Length)
			return false;

		// Compare file contents using hashes
		using (var archiveStream = entry.Open())
		using (var existingFileStream = File.OpenRead(existingFilePath))
		{
			string archiveHash = ComputeHash(archiveStream);
			string existingFileHash = ComputeHash(existingFileStream);

			return archiveHash == existingFileHash;
		}
	}

	private string ComputeHash(Stream stream)
{
    using (var sha256 = System.Security.Cryptography.SHA256.Create())
    {
        byte[] hash = sha256.ComputeHash(stream);
        return BitConverter.ToString(hash).Replace("-", "").ToLowerInvariant();
    }
}

	// end of class....
}
